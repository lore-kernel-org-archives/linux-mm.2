Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2506DD1489A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 03:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F526B0092; Wed,  7 Jan 2026 22:39:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84CEE6B0093; Wed,  7 Jan 2026 22:39:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F3B6B0095; Wed,  7 Jan 2026 22:39:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 617476B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:39:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 03CC8160158
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:39:44 +0000 (UTC)
X-FDA: 84307392330.03.C9BCFCB
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00E10140007
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 03:39:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=HFL+2J1j;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767843583; a=rsa-sha256;
	cv=none;
	b=GMF1jakZiVehDYhZCwwLvId2amF2nXuT6D3EgfssBlPFBfabHzcLcf6AYXUojJmJKxaG/D
	Pm3vsD6KDpXNgtp0Ap1/AeoXPPZdVV7wRKzF0aUU5r5WB/DOIbZAkgvE/DoN430DpCrHpn
	vJIkp0+1LLCQB1UKXnAfqtzrB3D2RIU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=HFL+2J1j;
	spf=pass (imf26.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.173 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767843583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qc8pspNNXQUhdzs3do5S7dhET6IwPPng/8Ra1Z52ecI=;
	b=HL6xhL8mUcyoUhk0fihW6OH9+kckPLKbEK9XtOzHLB09zs/PrD4+sT5CN6luG8kFvSvuBw
	0F9ztflDBZ6PQjoh2XrA4GB8CANHH0nu/4leFP18DeTXm9raH0Txo82wMeycCvMYnRxqOS
	D/+GfuJg6WtdVdZ25MGayaRjHFkBywI=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-81c5ff546f6so297116b3a.1
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 19:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767843582; x=1768448382; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Qc8pspNNXQUhdzs3do5S7dhET6IwPPng/8Ra1Z52ecI=;
        b=HFL+2J1jPzP/eFwv8VO50qjYHecFrHruPrqRzbtw0uH7KiiZGiO1/ctVtOGQzXq4i0
         kYN+TkQYL4hVS+VRq7075G6tMPGf/8Ut2Ic96TJMZbTZXSPJ/xBZbZC/uo1N4J7AC31G
         ZUXF2TemU1y7l1ShnT4W6KK7VzV17I2qetYvk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767843582; x=1768448382;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qc8pspNNXQUhdzs3do5S7dhET6IwPPng/8Ra1Z52ecI=;
        b=v6hkcOO8YuzyEcvw0qSzDMTBoUQGDEysKl9WZrghKGERBYTlZn5t24ncmdXgle2P2C
         AxVbBpJi5wOk19WhmViqd5sgYeqzsj6n/f6b/AlbdGl0HKUjMy5fc1uIVsjDgFyNxIIr
         MYcwkMy3Y+tkGVWkSBYaB+ByFDXZPJ1awZwyQ1HX/oWk09uF1v2Cv992d90WQAK9ITCn
         i+xrT6SBkcXuupg+lD7QygtfRFNd6ddb0UyCh6HOG9GgmaZoH0NavdjKeXajJY86OmFT
         9LBeqnL2Mqf0k8rvcl4qQciK2lSG0d7appA2Q74KW6pE/zfv3e7co3mADDUqPKFxpeBv
         iZCw==
X-Forwarded-Encrypted: i=1; AJvYcCUVB/pCVeoruMXMN6zARBMjzyL4kA+6SoHjfChOtbF5C/dLc343tUoFWcON8iXQj4iFWCeKvp6epw==@kvack.org
X-Gm-Message-State: AOJu0Yxre50t2z2eMeX4e5OJrPlKPUz5YobazdElTrR3ZOiOviPr6gxe
	mUgq9gL8HAH6G7dDBbhAIwqb2PwFSWlV8gyjX43kVyJsWnYUK0X1QNsk48Y3sIKD3A==
X-Gm-Gg: AY/fxX5NY2Cz1f7vfxuKjlZO/Utmitjx0DDzBYOhKGo6XCVBHVcoE9gvAcGuh/wWZZ7
	xta24Tp9VU9Z6HNw86HqHWuircReXuTL+GPPLjdFqJaS/GPYFJdbr5sRHLalm+dwBRhwrtobQCR
	JgbrUa8/s1HwNpiFQf4N0dAjOQuoRprzBCL7jFC0LxBJBgD23c6I8ND7/k840u5siQjz9aI23N6
	IfSTZDQSaZnleT7dDDt0vpI3EGErDyfjJIcicREy1ocT3bHSTuwxHt7s2kuzcGQA5nQacma5JSD
	NSU736TWbVnnvoEdPnkcUEkUB2xxy5hs7jwsyXBNZVwNW7BGTikX43/zq34E2VaqkpTjht8NCVW
	asIxB1SjwridkbgeM+WgdMmJtyHG5VFYjQUOOLPYHUvrNMlRjowboRyDWpA6/o1xmHw6C3dLgWk
	cNctaTVf9oGoMGQkL72X/9lQRCVJ59/QX2iPYO6Fuu21Ii6R1RAhg=
X-Google-Smtp-Source: AGHT+IGpuF6K1P8/mRvNgLohjXoq793u3g5Fu/6kaGkCnnD2ds/AiOp5VHnjWNr5eMZVtkxAGJI1Lw==
X-Received: by 2002:a05:6a00:ab03:b0:7e8:3fcb:bc4c with SMTP id d2e1a72fcca58-81b78e9ae88mr4717233b3a.33.1767843581800;
        Wed, 07 Jan 2026 19:39:41 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:7bef:7c13:79b4:e9de])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c52fd904sm6129668b3a.33.2026.01.07.19.39.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 19:39:41 -0800 (PST)
Date: Thu, 8 Jan 2026 12:39:35 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: zhangdongdong <zhangdongdong925@sina.com>, 
	Jens Axboe <axboe@kernel.dk>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Richard Chang <richardycc@google.com>, 
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>, 
	David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>
Subject: Re: [PATCHv2 1/7] zram: introduce compressed data writeback
Message-ID: <luzn25fgin43cnbmvmxwps7isqeq2pt5kfn26jqzly6hbnedlp@ojpw52ldzmuw>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
 <20251201094754.4149975-2-senozhatsky@chromium.org>
 <40e38fa7-725b-407a-917a-59c5a76dedcb@sina.com>
 <7bnmkuodymm33yclp6e5oir2sqnqmpwlsb5qlxqyawszb5bvlu@l63wu3ckqihc>
 <2663a3d3-2d52-4269-970a-892d71c966bb@sina.com>
 <z22c2qgw2al73yij2ml2hlle2p24twgpmz4jemfqhjoiekc65f@pvap7olsolfp>
 <a527b179-263f-40ad-9d7c-bfa86731bfde@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a527b179-263f-40ad-9d7c-bfa86731bfde@sina.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 00E10140007
X-Rspamd-Server: rspam04
X-Stat-Signature: 9t9o86ahadi3kirchi6m1c9sj3ejomjr
X-HE-Tag: 1767843582-475487
X-HE-Meta: U2FsdGVkX1+RBNXIs98DFlSsQ1k6BrB+M9U38QeEDRx6c/OnAOQKC6gSkfyl/KMNnJUu0BtFCeOjFnNrN8zAzN6m+EIctf8r/3ORNX9Bf1j822rrethBH1v6srXxSCIKp/jdZJvdhLjYWbTQv65JbGQQK64IUlQtkMApM4Tu1rxMWznr/8ilzD0hVQlK2kff2ILZQv6rK/fbDW/+rYXPQw5uub2gvTnDJIcLD3qU6k3ZBElbIcPsfjfmR+y74Y8Im/gVRI8Qy59EpGmSH+Ejzlwr8PhcciFOz9LcfMecLcKUIzZRbDN97SdkRxFR/TQRQIjQxp1I/d8UYEVMgz6BEqeABlxTtZNiMKUUUu/tlScEFlqttnofLq0vjZlrT3OhhQk8RPYTOm+BMgll27eT4jcaN+SSBa5j1fGGh39SD+dyrEjGQjUqUxwyNzPnjKT//kDElyE317FrmANdYQG+eGAYn4UGjHzJ+JG/XpOtnmrdsEiBHAQ6Cu3PbrcdcKNr4SEr76Q4wM8cWonyP8fsIrs0bKBMe0GdPDAi5RSlad5YGrhiXR8wFSmx6RNMzyNPvvBpe+5jwEJIsCQ3UK0JU+COce5qxyYrNBJ4lnAsYLknOxKCST5Q9iFtU1CjcYEtrie0xrPSyB5tguEZn2Eyz3Wj6XvWNAIB008P6XYeqfQnZBvD0G0GSs7BXe73BKcdRVtB9PMYVzpNqq9PxxNi1enIfhtsoP2qv+gAmC3AYPc+tKzx/yrbqMneDokZq8hlpsEm+lVuNtZl9MYcYiJSpTQ3XjRcjAcQswAXgg1uT0yKLI6QmrDi74P0zhjxk6MqGqIg0WwwB9SHw2Ow6HBfz+Cs0ejIipiUfQsx+RR+j5/PL33R2hqdIdSTdqSGpkE/pEqKq5nv5gEW5COKfIlfnDxAvzffwulZEM3dQnOull34IMlUsexmCM+YZWGbJYV1qGTprvzP8G227wTWQmk
 3GXlOrC/
 3o+9LKlUedVowZoLukvc/yQhFzf8/sXPIzQwJjdbReEt2mnDUaFy/ttFPIaAd7glbuaojGxSfwc3gZ2UR8kXP9oba90dVDntuZ0qvdNtUmY0skpUC1j0cMsrH7OK++OD6oU3Z25m08sUlS2wHAIxk7nhvHzvDF1EKubDj1fqUdg8R6v1dS1ycFq6vzUxhtFx/l/9YKOeyt1aNQLNuU9Q3X6a08aRMw/IFrltXnrl6biYjDPTncxQJ4AnAUeI5kH6phvO/1yKw1jWVR0kFLk/9Bk5o6oBC9G9nKieX2KL3FXB7wCMJO9xH12Ie9S4tP4Ek5uja/luAsTsWIQqHw9OKBpK5wPIyV+UYb5t3nXGf5l/AcMXSBYYCvTkGnQMhrz5edMihgekKhkai4Ik=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On (26/01/08 10:57), zhangdongdong wrote:
> > Do you use any strategies for writeback?  Compressed writeback
> > is supposed to be used for apps for which latency is not critical
> > or sensitive, because of on-demand decompression costs.
> > 
> 
> Hi Sergey,
> 
> Sorry for the delayed reply — I had some urgent matters come up and only
> got back to this now ;)

No worries, you reply in a perfectly reasonable time frame.

> Yes, we do use writeback strategies on our side. The current implementation
> focuses on batched writeback of compressed data from
> zram, managed on a per-app / per-memcg basis. We track and control how
> much data from each app is written back to the backing storage, with the
> same assumption you mentioned: compressed writeback is primarily
> intended for workloads where latency is not critical.
> 
> Accurate prefetching on swap-in is still an open problem for us. As you
> pointed out, both the I/O itself and on-demand decompression introduce
> additional latency on the readback path, and minimizing their impact
> remains challenging.
> 
> Regarding the workqueue choice: initially we used system_dfl_wq for the
> read/decompression path. Later, based on observed scheduling latency
> under memory pressure, we switched to a dedicated workqueue created with
> WQ_HIGHPRI | WQ_UNBOUND. This change helped reduce scheduling
> interference, but it also reinforced our concern that deferring
> decompression to a worker still adds an extra scheduling hop on the
> swap-in path.

How bad (and often) is your memory pressure situation?  I just wonder
if your case is an outlier, so to speak.


Just thinking aloud:

I really don't see a path back to atomic zram read/write.  Those
were very painful and problematic, I do not consider a possibility
of re-introducing them, especially if the reason is an optional
feature (which comp-wb is).  If we want to improve latency, we need
to find a way to do it without going back to atomic read/write,
assuming that latency becomes unbearable.  But at the same time under
memory pressure everything becomes janky at some point, so I don't
know if comp-wb latency is the biggest problem in that case.

Dunno, *maybe* we can explore a possibility of grabbing both entry-lock
and per-CPU compression stream before we queue async bio, so that in
the bio completion we already *sort of* have everything we need.
However, that comes with a bunch of issues:

- the number of per-CPU compression streams is limited, naturally,
  to the number of CPUs.  So if we have a bunch of comp-wb reads we
  can block all other activities: normal zram reads/writes, which
  compete for the same per-CPU compressions streams.

- this still puts atomicity requirements on the compressors.  I haven't
  looked into, for instance, zstd *de*-compression code, but I know for
  sure that zstd compression code allocates memory internally when
  configured to use pre-trained CD-dictionaries, effectively making zstd
  use GFP_ATOMIC allocations internally, if called from atomic context.
  Do we have anything like that in decompression - I don't know.  But in
  general we cannot be sure that all compressors work in atomic context
  in the same way as they do in non-atomic context.

I don't know if solving it on zram side alone is possible.  Maybe we
can get some help from the block layer: some sort of two-stage bio
submission.  First stage: submit chained bio-s, second stage: iterate
over all submitted and completed bio-s and decompress the data.  Again,
just thinking out loud.

