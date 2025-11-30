Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9516FD116E2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Nov 2025 02:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5104F6B0005; Sat, 29 Nov 2025 21:49:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7AA6B0008; Sat, 29 Nov 2025 21:49:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424746B000C; Sat, 29 Nov 2025 21:49:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AD086B0008
	for <linux-mm@kvack.org>; Sat, 29 Nov 2025 21:49:39 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9349B5109E
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 02:49:38 +0000 (UTC)
X-FDA: 84165742836.05.FD082E4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9AA1D180002
	for <linux-mm@kvack.org>; Sun, 30 Nov 2025 02:49:36 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cmp4BN+X;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764470976; a=rsa-sha256;
	cv=none;
	b=6ERQiddTIfmPqS17PHnoZb5V+TfFKjwMXjaOWWOkpqknpThQoW2P2jKk1xEW0EdjP7ouEl
	1KR7KuoTVv0cil1sCJ4uMW442lpKbexKW7LldlgyeF+7jbLS5O4zAsAjuEj6GD7GOfiwcb
	oYXWgjGtu99mpv8GCPlrJz4B+fQ0niI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Cmp4BN+X;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764470976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Og04/bt+yhEkeXfMP3slZPqApRz+VQNIptaZnXqjJQA=;
	b=VF6Mc8xPKOSLu78zTLHSCAHCbZgZfh33o34fO3rSc/Q3Y1WEG3m0Icr3Dn5o7elXJQG5TO
	gSmH88eHvzoFVNguTSwB6PUi5qEXTamXBZwJOP3jCKHeQ2TKjpT8ro4Yb+FTTZxd3/4e6h
	h1hXyKWjjoqhlWjMQ2hSzgtqDyhOOzQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764470975;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Og04/bt+yhEkeXfMP3slZPqApRz+VQNIptaZnXqjJQA=;
	b=Cmp4BN+XiI7zrr6QJMLm1YvuG9o38xgjBBzWQ3hD4tkkmk/HMY1sjrI5HXj0geQtlSuVOj
	J90rxwZ6KkiGfLPGLKJ4vF+rpGMqTbFXsyZjjub7FQmfrr0gBVHCDFikF1VwwHQBPo0Em3
	zURwZrbUZUbDGcIlaSKLXVoIXjXiks8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-449--EjyqyECN-2YKkxJ_5cbUA-1; Sat,
 29 Nov 2025 21:49:29 -0500
X-MC-Unique: -EjyqyECN-2YKkxJ_5cbUA-1
X-Mimecast-MFC-AGG-ID: -EjyqyECN-2YKkxJ_5cbUA_1764470967
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BC3C1180048E;
	Sun, 30 Nov 2025 02:49:25 +0000 (UTC)
Received: from localhost (unknown [10.72.112.6])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5839F1955F1A;
	Sun, 30 Nov 2025 02:49:22 +0000 (UTC)
Date: Sun, 30 Nov 2025 10:49:18 +0800
From: Baoquan He <bhe@redhat.com>
To: Alexander Potapenko <glider@google.com>
Cc: linux-mm@kvack.org, ryabinin.a.a@gmail.com, andreyknvl@gmail.com,
	dvyukov@google.com, vincenzo.frascino@arm.com,
	akpm@linux-foundation.org, kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	elver@google.com, sj@kernel.org, lorenzo.stoakes@oracle.com,
	snovitoll@gmail.com, christophe.leroy@csgroup.eu
Subject: Re: [PATCH v4 12/12] mm/kasan: make kasan=on|off take effect for all
 three modes
Message-ID: <aSuwrkCSxvffKAZc@MiWiFi-R3L-srv>
References: <20251128033320.1349620-1-bhe@redhat.com>
 <20251128033320.1349620-13-bhe@redhat.com>
 <CAG_fn=WpLtVhhOfU3pBKbJ2P3ih+PX4oW+MKAAmHRW0onOgSvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=WpLtVhhOfU3pBKbJ2P3ih+PX4oW+MKAAmHRW0onOgSvg@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9AA1D180002
X-Stat-Signature: n84xarmrmeprirwmg7uhksyz3g8g8a7m
X-Rspam-User: 
X-HE-Tag: 1764470976-370416
X-HE-Meta: U2FsdGVkX19DX3QkPnNxnFDY0ytpQc7obzuzs36pJAdMyU2KdVXJbCl0b1ARJxzUjF6FNqdAMAAj6+gubv8vI2AAMyQbfK8sfM0WUMrhJk2nK9asJBm3tOwUnaBGmtRDOYXpKvxStWfGCHaK0R6hWj4WDzz93s/4xIvranTiOvDw9hGJm6YLKk5pXoUQLGsmPiRK6FdRtcoHZMHsMcoaU0COxqtiFY6rZFaJO3AN8dX2iWjMuenYSDAgldKsUzuP4Urm3h88tN8iyhi/HrFyXkcjQqCDjnedC06E+IjcquBgm/cj+TrFal2lbTGUnW+RoRv+PxwQ5uIVmK4pnF97WtD2bXM0ZLhihcdK+ZwLYGVP3LtymEh1VPg3weChOM7gFNFXDBuLaSLpT789n3VpTxg8+1KMaIT4mFJ3KL0g3/d4gNX0hbhzSR6bcL6GStGzp5yjArEOAAC6GOWwg3f3SPuj3ZamJ8HE11R2BIJFu6SqCe88J2qxmw8Z/z79dQYNc7da7S+wpwv0W56b7/zLfpx+xBQC77jGwj5ODV8lJh78HSIsM8mcM/3D0VuSJoW2lBDYF/HU8+zcBJBlR1NOMHR6wVrWAe1ZFc70PgcznpeQS6YslLs7b8JJFPwzd0mXQPvrp0uF8/ndwQcGwy2CU9izHExAQGLozKUxQlRZdxOviUZB/oRkCkIeeIgGxEV8ZfuUNvKAI4/hwnzxd03mtQIMsWr18ssgEDcIPxQraWj2Xl/MGGq9Ghf6M28j1cKqfgOMhvsEfwBsUsyg2NzECBQJ3g/LVExvH6VbXRXpF8xRZ+Q/30fBUSqk5N+Ng1HPirRKU6m1R9RgMjrNvwrgnGnXQyVrVALJtRvkWbplPWpsGdppAb4uKnavdkiyn+bF56DexW/AjqGYBc7fT/nnR4oG96LCaiPuQ1d4a6JFJTM0IwCqxRQBWKhwCrfFNsZo6QuTuc2QEoUZvEWgY8/
 ux1mGLIf
 cd7bCBKcg2iEEHJIxHLzuP/XD1JKFU90eL12VKKwyGusdg5SE4h243DZWNyPJkJuRspiOcmyrr5O3tK+bcIPR79hzGn3TKp9nIEvfs2W3Mz6ET9KI0Z1WVkzQP3W6w8b0Wmt+83VWls83XzHNMVnVsyxK/5UinPvFDsmQ/Q+UkV5fe1JvhKC/botgTuqAtjdNRUB/GAgBk3+798S4slFUSMxsDAh1I4TnwQJ1tNamXi905dtBNoErELnA8ElAh36yzLC4HSUQzxMPU5ryxvuTypzvpov3acXF8IOvHLDgIOPbI1gXkrqMHEdfpIsGDICXyMd6yed9B9CSobgknSVN/KKmqG/4KRlHWoKl27FOgvAHCfQsHIvZnARE1YBTAay+wkkbFhL2utebk+Q1Cnvvq2DYTrcH85Rrj4+jZRUgnqNPo+M/dWtmMqW5iqY5CQvRZzt6tSOfR69MyDCRl0226ffDPQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/28/25 at 04:50pm, Alexander Potapenko wrote:
> > @@ -30,7 +30,7 @@ static inline void kasan_enable(void)
> >  /* For architectures that can enable KASAN early, use compile-time check. */
> I think the behavior of kasan_enabled() is inconsistent with this comment now.

You are right, that line should be removed. Thanks for careful checking.

> >  static __always_inline bool kasan_enabled(void)
> >  {
> > -       return IS_ENABLED(CONFIG_KASAN);
> > +       return false;
> >  }
> 


