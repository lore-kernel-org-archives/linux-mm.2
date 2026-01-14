Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA21D31A03
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 02:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBED26B008A; Tue, 13 Jan 2026 21:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8F106B008C; Tue, 13 Jan 2026 21:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBC5E6B0092; Tue, 13 Jan 2026 21:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BCB666B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:05:32 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69893C186E
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:05:32 +0000 (UTC)
X-FDA: 84328927704.26.4F6CE9D
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9ED9F180003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:05:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AO0RLTb3;
	spf=pass (imf06.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768356330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jrzCY4RhpuK7plFMFlkVNnwXkq9N4udgNExDYEdqkM=;
	b=tbEZof4b/V0/bjAo/AHFq6aC+YdeT1l9jm1JlOclIUaolQ2Fz+KGKr729JuGVobNNvYQWn
	5nQIEyCNjJJYUql8Hp3E0DoZB63bXK2u8Bu2qvwFMzasiVBVbVxhO+mTHzZSukEWVozdDW
	VTRFMOvBMe5APWXrSgq6IZO6LaaG2qc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AO0RLTb3;
	spf=pass (imf06.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768356330; a=rsa-sha256;
	cv=none;
	b=bHKZ+6O7QZZ2J/FaWHbdXvbuKQN5TUkFT9zqAymd58YfcvRhwJCEZAFXpzh9Il3JvjJ5YO
	RFnLzXBywWMVFdzYf0VzIrGOIyVH2CxK443MoATUqgsOTgcjjsFie6nHNT92X19khGR4XK
	seD3zVFlUPMcpNKEZ9ELrZJVHpwWPeQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1768356328;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5jrzCY4RhpuK7plFMFlkVNnwXkq9N4udgNExDYEdqkM=;
	b=AO0RLTb3IOkWBP0yTC7H95HkShHmsUN9EZNOvlJgdqt3O2LSUm0Mcj0nRF3PQcqnt9h7r3
	ScbSte5EkC7q428Z+cFt2yDXX8zVzeZ2RPEQK+GJ8fNq+dZysnORWyHI6AxUcUre9dUX7v
	ndq7lpmIoNqEqlaOIomtm4vApfEauRo=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-173-I-UtY7Y4MUaHIAbGIClX1g-1; Tue,
 13 Jan 2026 21:05:25 -0500
X-MC-Unique: I-UtY7Y4MUaHIAbGIClX1g-1
X-Mimecast-MFC-AGG-ID: I-UtY7Y4MUaHIAbGIClX1g_1768356322
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D822518003FC;
	Wed, 14 Jan 2026 02:05:21 +0000 (UTC)
Received: from localhost (unknown [10.72.112.63])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03A0B19560A2;
	Wed, 14 Jan 2026 02:05:19 +0000 (UTC)
Date: Wed, 14 Jan 2026 10:05:10 +0800
From: Baoquan He <bhe@redhat.com>
To: Robin Murphy <robin.murphy@arm.com>
Cc: m.szyprowski@samsung.com, akpm@linux-foundation.org, vbabka@suse.cz,
	david@kernel.org, iommu@lists.linux-foundation.org,
	linux-mm@kvack.org, vladimir.kondratiev@mobileye.com,
	s-adivi@ti.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com
Subject: Re: [PATCH 3/3] dma/pool: Avoid allocating redundant pools
Message-ID: <aWb51ntBtrJCwO6I@MiWiFi-R3L-srv>
References: <cover.1768230104.git.robin.murphy@arm.com>
 <8ab8d8a620dee0109f33f5cb63d6bfeed35aac37.1768230104.git.robin.murphy@arm.com>
 <aWYbcnglF5P/WhL4@MiWiFi-R3L-srv>
 <8d0c7b1c-fc12-4498-acbb-eaf6cab9ef3f@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d0c7b1c-fc12-4498-acbb-eaf6cab9ef3f@arm.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Stat-Signature: 54jy99di5bt95cbzbewu4epqgshmn9u1
X-Rspam-User: 
X-Rspamd-Queue-Id: 9ED9F180003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768356329-495115
X-HE-Meta: U2FsdGVkX1/psL3PuRd79iBP96OCrxcduf20GS+LnBeRV1c9enhMr+5c8z5uuFpo6uTlTG6S0mKg3Zw6bx2RKskXExUf7cpRYslhKhFb8YAslnP6DotZduu4MCBmdr93N7dijYYEdAI9K1BRj6DNyU9omWk7bjC4GAvLLpFuuXUK3mQ+yPeCBFnsqeze6tgSTyuQqgefMbqJyZz8eKfma1bMuzdlpDIMMsNpVXX8+jlodu9R6pHwgLbA7wv6W1WDqpNc8ZHxU3xVFJn+Qjn8LYlr8XFaVaEWoU9koFOXguCS9BjvgvB9eLJgtapVnyqPYVaosTOU59NKIJPJfQgNyOo9ieX/ZBE5kaD3R+PjtpgT9iTBzmaqkMTdr2NGzjVqFaLW/KVPverFUV1rKUnSNZaDTrL7KURo00joarZILGxFUduOf0V2f66Sbg6TxImLGSU+3mntBrB6/eGBYka1q2kHU6sPGNgYgKrUmPoZ2lyj0k4Qq8U6yzCmBnc5f9hkOX5XHfbkPUML/Yb6BQH59/vz+EfhhsmqLcPLZtUnoO3xC9A6bhcu8zT8ApVjqlnjB5QgMOgJrsMqsal5gzmqONFj9MkDznwShIrUgMOTfQ+stOE8icBXMkh5gnocI6+cK+15xr+uW8Xyc08qGYgJEA4TOU0UJpaFIBPOwa6tee+z92g8DPFpvSp+XsnFLfnHDw47oJByBONDNPhBI2E0t8cXQoYRTy1dizkw2yWO25SbV3ZkFRjz+VeLJtDmf6znSpp650r+dwMOuZoHt26+CWA3HnmUiZzxl0XGZ4BiLUYmu1fbUjZU1fswxQN6VEmH1lGXVfjGMrIGgk/zo94veW6VJ3kAyMQDE2cH87Y2g9LUk7AuDM+aIYKF6FYISIhXt5GMUqO/h23UuzAL4olhaoXnqbyBOzASz1eKEHaFQJgIqE4vQiVV0fd+kfHwE5ese64R00An2JiVjDZ1B42
 NA8UjFM0
 vneCsF36Zp6fSoey5WK2PKDSQci4bjQF1TCBPWB+j+BBlRKi/2zuBlfTyICk6DeMTLBCM40n3QIW84+Tt4fteDvHD8F839F0+KkJHNgiJRHNgRcFiyQViS9rIKbDhu6/w2pYkLx+HpigyYj2C1brh2ziEdKaQX+s7A+lWu0AaKygw3LrRGCs11vEQY3xK5TA9x1H6QFR0vVhTgZ7gTenWUk5OkrM8SETldtnP35md3XO/mZSVBEkU9lyvsEHDteF3zul9YWwmIPLoYKh68ep/gCulTtabetGj2OLsEVwvGQl0ERzLFtFrYbAFilhLuLi+ws0uXmb+cNWLWtQuIXBEKCbhVww+hg2JITzsBr5h54Mzv5LqdxI2j067GXZVz1iMrwKYAEiJ5bkFoiEFDQHD3ElsGg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/13/26 at 04:14pm, Robin Murphy wrote:
> On 2026-01-13 10:16 am, Baoquan He wrote:
> > On 01/12/26 at 03:46pm, Robin Murphy wrote:
> > > On smaller systems, e.g. embedded arm64, it is common for all memory
> > > to end up in ZONE_DMA32 or even ZONE_DMA. In such cases it is redundant
> > 
> > This is true and the whole series looks great to me. Do we need adjust
> > warn_alloc() to handle empty DMA32 zone too like empty DMA zone case?
> 
> Hmm, I'd be inclined to think that if nobody's complaining already then we
> can probably just leave it as-is. A GFP_DMA32 allocation won't OOM unless
> *both* ZONE_DMA32 and ZONE_DMA are empty, right? At that point I'd imagine
> it's a bit more significant if someone who wants DMA32 memory can't have any
> - don't we have a mechanism for reserving some "low" memory for kdump for
> pretty much this exact reason?
> 
> A special case for when ZONE_DMA is tiny such that GFP_DMA can be expected
> to fail often seems fair, but in general I'd expect that if GFP_DMA32 starts
> failing then it's more a sign of a genuine mismatch between the kernel's
> expectations and the system configuration.

Makes sense to me. I remember someone plans to take off both DMA and DMA32 zone
in linux kernel, but that might not happen soon.


