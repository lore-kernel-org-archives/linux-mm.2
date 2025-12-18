Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE722D6ACE2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 10:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C7856B0088; Thu, 18 Dec 2025 05:35:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54BB86B0089; Thu, 18 Dec 2025 05:35:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44D846B008A; Thu, 18 Dec 2025 05:35:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 357EB6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:35:12 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E73AA6108D
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:35:11 +0000 (UTC)
X-FDA: 84232234422.26.BE4FFCC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id D00691C0009
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:35:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UDkUqeyI;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766054110; a=rsa-sha256;
	cv=none;
	b=2zmIRMxKG7mMrEiyMQA8vA6gkGY8mGjn/ssn7G+8zvJSw+G6TqZz00j62ACmzLh5teO3hi
	KETgS0SJhbNEhasBvvQAjjtF5gGX8/5xazBZSbjaVLGfVFrX5HTQs3qfwJMYwwfbjxO4Rr
	JswgG8hti1UoEklmkqv0wM8UzgsLsUI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=UDkUqeyI;
	spf=pass (imf18.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766054110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ox6wssbehUd9TNy9xO6dZkl4Qcg/MXBnBGHnzoEEBXI=;
	b=05etKf/9qJ55e8G2dm/LiZ17mfIf6TLtNifoWoIXM0p4n8Q3oxhMV83+1ruS3SnVIdNBW6
	hCiMzf3gz9YtmUxSPVs4G+vpfFff/XJWZliz9Lrd4ngnlfvlowPLh3ZW5vImi6wlOlZbGG
	vxydM8oq70RtPxGGhwEmsj4Yc3Q1r8U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766054109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ox6wssbehUd9TNy9xO6dZkl4Qcg/MXBnBGHnzoEEBXI=;
	b=UDkUqeyICeVK3mXWEmP36DlHzS6QqdfsV3Fp9C8EQHyASLR7UD272U7Sr/nacIEmu3fhsy
	ZkIqy/B30D4M+JJJj0wbSy5tvfhGtHTJEr8YCpWRcaQpRns6+cMsGZL3PhcvK81sQRg0yf
	SuF1UCViFNNmXjlh5wY0uLWBtYFCqDU=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-159-EObfuWrTPPKz-GkpgyspFQ-1; Thu,
 18 Dec 2025 05:35:03 -0500
X-MC-Unique: EObfuWrTPPKz-GkpgyspFQ-1
X-Mimecast-MFC-AGG-ID: EObfuWrTPPKz-GkpgyspFQ_1766054102
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D435F1800342;
	Thu, 18 Dec 2025 10:35:01 +0000 (UTC)
Received: from localhost (unknown [10.72.112.95])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A8CB5180045B;
	Thu, 18 Dec 2025 10:34:59 +0000 (UTC)
Date: Thu, 18 Dec 2025 18:34:53 +0800
From: Baoquan He <bhe@redhat.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] mm/vmalloc: Add attempt_larger_order_alloc parameter
Message-ID: <aUPYzWNHjkC0p4lX@MiWiFi-R3L-srv>
References: <20251216211921.1401147-1-urezki@gmail.com>
 <20251216211921.1401147-2-urezki@gmail.com>
 <aUIpciUKUeclNk2s@MiWiFi-R3L-srv>
 <aUKXs_3bxLyMvTgu@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUKXs_3bxLyMvTgu@milan>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Rspam-User: 
X-Rspamd-Queue-Id: D00691C0009
X-Rspamd-Server: rspam04
X-Stat-Signature: 4omwsgrsbgdchxxxtdjfdcfwz8cntncp
X-HE-Tag: 1766054109-896515
X-HE-Meta: U2FsdGVkX1/7Gs6tiNkUqSNBMW1vS61Eh0YlO8+9zdc11gHHBFiHafngjnZu8KYH2yfi+muC7d/4Rav7V3PVb6Ks9wtbn+a1ovnoJacUribsMcY4mCGJApu+ZbXNaesBMwsaFYFKGCzX+dyIEJ9Xqm49OAe1SKIsAU97EHJJGD/VKc/Z3mhsPeqiXVNT+dj0F37+8DA91zY9WXfYO0fRCJ+XaaNgKcozqrhTcJaQzsWiKuTSQTuf83ivZOmEV60tXB1HT9Z4aQ32dtUoBZStHKnqk9xV8f/0INo9dug7Napn0tNuCEJdKGANA79RV9MLTH6nBhUwoGMrAlwNtpwUs/BLr7mwm9QHdqNkn5+45c/ZxVGOBKG7nW+JOef76J415PesxcYu3z3aKq1wUk9MZBFSUSbArPjGlIg5363yrLoe2emHMW9MyPOYw2eE00VICj1Qki7NTHvvQrUtyciRqn5qbvX2rD7pyhv7MAZhMwZ6WP3a/ZSzt4WCEn+Ca83oDIac7wo5kVhJQABzz9Lhu4pGMrnoZvX8ebJOkGM3Kd9NUMPtgZmi4HLq59dFhJfWRAMyvaa6JHAzrd8fSyX9GOCq9ddtS0HUZ7/oL+KLQLLnogjOC9w5YpfxYPy8i4UNQWgg+Kyc2T64LNcMlIe8Mji4pVGYCUIdzXM5M4GaZfvxHHpBK1dhEstYaukCVXIYoR55tEyrfcYvwBm7jEgbOga3AJTkRvRqG3qFJQagoo2xqh497MxAqZJ+HK6PFjy1RY1Ws+yoshWvvolFn3nnrvkZK+sgEgDD4/FO92prUAX3P7eB9jiNqE1WXM6l343o3nKDK6+FltbQZ4w1SVY8yY2V2+M6JBHku5+CGFjagKdrjusdyORrbQvXOqU9s/qKDixgoRMAvcveaZweDY69daFQc+x2UpXceO0j12fzR2wOiOD5VIoK7yhVAdEb5/WMKRiH2ii6Vo6aVd4L5Ly
 JRAjn/o6
 cC39OD21D02JaZ5M9Yh7sHxho4CaEDtpR4fZZfX2RtBJv3S54FVAc/yZEyEajuZa0VIXBsu8gtqyJpPKoG4Ef9w1y180dThTd/niQq0tRcXfN9mOzBsE6dBD/J3QYTQBSpZZa5qgyQQ8RnnDb3bFfNoF73VfYIejbO2NZUtOIBZuMnSKqG87q3dygfcUXaNG+VVwY8kQqHeIxrZNfvLsDfDrVycMsrMapPYzt+EMF8Y865fa6JmAtGXyZif7gEZ/wGMixXdCZtXS86G0DUpsOa3n7dLbC1ZBQ8d7qeLnrTQOw+62Ic06StjNozZ+xyqVJVwmWKg4GnbmwVr2WQmIjben1oZ0ovzr7pQTti0mLhWepPjOdFXmM1EeOuuljr36ezTadkBON6CsPEtlrfAF0Qb9pew46gBHstoCDCGrS/Nq4BOUgpbxF4byODCGgYyUOvejAt2SakPMoNkpS1IdPZt5sFIxDv4RfmdJBIy3aGnAYofA0rwcOi3Y9gX9RAy5dWDLYAn8rhDikSTc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 at 12:44pm, Uladzislau Rezki wrote:
> On Wed, Dec 17, 2025 at 11:54:26AM +0800, Baoquan He wrote:
> > Hi Uladzislau,
> > 
> > On 12/16/25 at 10:19pm, Uladzislau Rezki (Sony) wrote:
> > > Introduce a module parameter to enable or disable the large-order
> > > allocation path in vmalloc. High-order allocations are disabled by
> > > default so far, but users may explicitly enable them at runtime if
> > > desired.
> > > 
> > > High-order pages allocated for vmalloc are immediately split into
> > > order-0 pages and later freed as order-0, which means they do not
> > > feed the per-CPU page caches. As a result, high-order attempts tend
> > 
> > I don't get why order-0 do not feed the PCP caches.
> > 
> "they" -> high-order pages. I should improve it.

Ah, git it now, thanks.

> 
> > > to bypass the PCP fastpath and fall back to the buddy allocator that
> > > can affect performance.
> > > 
> > > However, when the PCP caches are empty, high-order allocations may
> > > show better performance characteristics especially for larger
> > > allocation requests.
> > 
> > And when PCP is empty, high-order alloc show better performance. Could
> > you please help elaborate a little more about them? Thanks.
> > 
> This is what i/we measured. See below example:
> 
> # default order-3
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3718592 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3740495 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3737213 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3740765 usec
> 
> # patch order-3
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3350391 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3374568 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3286374 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3261335 usec
> 
> why higher-order wins, i think it is less cyclesto get one big chunk from the
> buddy instead of looping and pick one by one.

Thanks a lot for the details.


