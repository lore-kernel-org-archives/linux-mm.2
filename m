Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA76C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF066B0138; Mon, 17 Aug 2026 22:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CCA66B0139; Mon, 17 Aug 2026 22:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690EE6B013A; Mon, 17 Aug 2026 22:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3724F6B0138
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:59:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7F03120A40
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:59:37 +0000 (UTC)
X-FDA: 85112884794.09.5010932
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf17.hostedemail.com (Postfix) with ESMTP id D297C40003
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:59:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b="Y/jx2De8";
	spf=pass (imf17.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.179 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787021975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpYS9nogSeC5YAWQyKVXdj3E5kPL+kfXuGGttfptnTE=;
	b=kiQ1P/eqpHe+fPGmH1hcfkAzfSHkol83l9B6l0AELh7zEmEOIhcI5YVXmzZgR1JeZmQ2YV
	0z+6ZS8JsEZ/0o8vxzyimcmW4JPJaN2Ue1pM0ZxwlIfOH87utXUrmx/gpsH7KHEtrZ8VJn
	HXeTdGpHDkrcPx2bAB/NjhYUcuWOaRw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=rowland.harvard.edu header.s=google header.b="Y/jx2De8";
	spf=pass (imf17.hostedemail.com: domain of stern@g.harvard.edu designates 209.85.222.179 as permitted sender) smtp.mailfrom=stern@g.harvard.edu;
	dmarc=pass (policy=none) header.from=rowland.harvard.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787021975;
	b=icLqjmKOqcrGC6F3d4TO9plgYo6tTp4FZqEcPrgga/UDbxTlsOuV/TKgfcVj418MWlvxUv
	9PtrOf+ODKrSxB93UxEmOICyxUlv4P0lNm52AcgpZGrRFlwIwtGJ4YR4/FNp/jZ0692sdQ
	C8obqtVsdMi9QEVdtw6qRw1i4C3mv1s=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92edb12cdf2so341396585a.3
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 19:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1787021975; x=1787626775; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tpYS9nogSeC5YAWQyKVXdj3E5kPL+kfXuGGttfptnTE=;
        b=Y/jx2De8+g0M3cwLmd14HXJccm17Y6cz9BMqDIouYgD0qGEhqh17g6ejumVuxlsDVX
         uxo/CK5Ri/v/7hx0KHmZkr4wbUtUMSQpobC4ZbAFwcnTUnT8wkjpOZfKnkjTO38w+fiq
         lPxV1VKpgcdqrNGLsjOh0UmGw0TOado5GE6HyRrkkjmNcl/VBxybfhqXMIHlLwBPgHAl
         q79xChLNZuxQZZ9OSkFVaue5pXRe0QXn5b20LcR/xHE50azOMzwyxLrP1LKWu+oPpsDN
         J2fDoqD3JTSdptERcL2a5L6SZ7f+wHjhhtblbbhzmqN3nAAEUWOZRbwQXmqqt6lRFEL3
         OY4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787021975; x=1787626775;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tpYS9nogSeC5YAWQyKVXdj3E5kPL+kfXuGGttfptnTE=;
        b=NhguiVPi4xTgQo+Zfucgv0pi/kDHRAD/X0mWnb5sftxszSbs+gmK1wFypG/Kh6FRFd
         NANgy1i0RzcfIJ3QM7lFqGAdc/ZvMm5qJkiHSo3lbF2NpTnTMOZNP0Vovr5lGOvnHez9
         lm2iwP7lBKaKjNgiqKxppK18GxxZID4RUbJIb0HLkTStdNL9Q0JBwHXAdgi+VYUtpo3n
         0UhTDCX+QAZtNevp/q7htvZEuc3pcUEQPfzXB3zDiTV1/4nNsjxomCJFK5Lj1L8UihMN
         eRVXGwg4v+sFmisirnGLvuOnkC2L6gRuC+ujRnG7fN0iFrATaLGabLuYDUC5REg7vnNN
         YaXw==
X-Forwarded-Encrypted: i=1; AHgh+RqGXgECIL66VEpcVWWzzNo//R0WW3AtSd6St2iW/5Zk0Lnqo7v+9TfsfyFu8yDrl2qJ/wolbyYP1w==@kvack.org
X-Gm-Message-State: AOJu0YzXH58XORdZ2bTrmeZCcbaSz2bQzt5ID/qJa2wiST9WAykfzFgM
	RlPSrVBQwBeGOAe2d4ubMynrr1c7EYIpRFbJnKKOBEQmeWUa6S5oana8AVsmHI0KmQ==
X-Gm-Gg: AR+sD13Oi7IX1YSo2lUEYLPwgFp17V4sG+VC8GMvanl5BVugQWtE2pun/O67zXqHak8
	/WmAI56dzd4zF344suBFn7Ov4Qx5KxJLEWtD7GMpt9pyvxLMPD9FDcgpu+zi+GohYBHBkID/zm0
	Zyz04Kq0RTolNPfA0XFfveQMULbqc1ogC8tk82iKYA9rTeNHTFszU/SAWqiNLWRoD/Gc7a2ETba
	q7Nv1PGS6EgptfDen1t/5eSLZ5O0Y1noAplTP9UIo3gZhBnwRvyUaTCXkyCw6KJb8UFKgx/6GKt
	j7nGEiJg/GLyJL2Fv0c6gsNQ726AZHluz7Qpzvt64NHXPF65CyqR4aoRcniAr/onLrPmLZuKu3N
	QGJVzS79VdxDqve1/9wXqAW2ZxKmImU04yLb66gygNJb9xZqxJAf5yw1M/XWaxc92cVHlSU9VB7
	MsXPd2dmbYx5v2mVEChlugEqkTHOcwGfPettjC2wTw7dXUk5AfNWABjoZ1kXCk3g==
X-Received: by 2002:a05:620a:2683:b0:915:83fa:b3e0 with SMTP id af79cd13be357-936d1fdb95bmr2738326885a.5.1787021974874;
        Mon, 17 Aug 2026 19:59:34 -0700 (PDT)
Received: from rowland.harvard.edu ([2601:19b:d01:d210::dfd8])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033ceb9bsm191865685a.23.2026.08.17.19.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 19:59:34 -0700 (PDT)
Date: Mon, 17 Aug 2026 22:59:31 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: Zi Yan <ziy@nvidia.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	syzbot+805630f1453e490427fa@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/slab: reject unsupported kmalloc sizes
Message-ID: <3ec57a22-3096-418f-b10f-b0993a352007@rowland.harvard.edu>
References: <20260817-limit_kmalloc_size-v1-1-5bef487701cc@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817-limit_kmalloc_size-v1-1-5bef487701cc@nvidia.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D297C40003
X-Stat-Signature: dq3r6aud4qyeciz9n44ttf7gjemmop4f
X-Rspam-User: 
X-HE-Tag: 1787021975-452750
X-HE-Meta: U2FsdGVkX1+XbCwdLPJw0A7xjrQPxuBO423ohmx/sPeleAc6JMz8+/YSJHbSNmTSRSBhnJfM3vvTUlgtaN2D4Jv61ehwzfQJDN9duAA70M7TswyUWdd0T7FtFVFxNYPSKlY0ehFRoO41lNi9DtD/xLyg+sLrZOBIRpV/Vg6NIzQ6dMkr6mLNSr5NOFx5Ebh2gPeWCR515L9lD5DyUi/ZnSWXpk1tMO7z/dWxjclEvdiicv1vkGgbfH82N0G4tqUBUS8DGgi1XfW28XmzyEmeiMxoijlRDCxwoSE35d2JPSAEAJfs0iVvhatN3s+tnZuLcHpW0/sqP7Ktl/bdqStIpyG6A5oGaiogxXoXq1XfbFWXCvUwRE9oaiOSxrLBm1PyGSOEq3xHgUYiyUuaCad01CM4NxRVKyEEPMzf46ZKNGWf6kfeTc6JJjLOS37aU5rAuboUybAZoIgZQZApGHi7WrhxPC0Kckd1E3/0Ez/W0bGrlS9VbLjxDcOlQkRmGtX6bGZQaX4+OpxHokKASpEEWKWxKJ/oSffsN/GgC02hPcdsm2sQxck+72S8G+ryJ2T1jDCHOmY1ZWXW6jmz2NKDEGKlnbXTw2nRzat+LzVpNlJk5Bw0c2G/mtJ36+4j8UrG0FipTiaFpnA9xr6Mx/wGDemSwIMEhQAeztTmuE/G8iPedRjWGjjQUlvNtx0YEe9sftCVqm+bLmqBrEDlsZ7QdDkO/plzb2fDaQhXCtR6mbwNCZzx1dZ4b8IZg53wYVu+9DBwMWJlkycaYOVg4rbOL5GfjyB+q0zvAXHd3rd193zg4WRbF4fXNY8Af3SHH0BPgao3di6r8dSua42eTJALaPSGBHBVQz4cll/MVMgzrfDVtO9qfiBPjuQH8As+rVDK29FljFf6GxN2p8KWUVTStSF1V8lvfEddSJVQWtWSbobHLsuTYT1ZtH4yO42JlnaCcA7OuNEvvIT0szAa35E
 Iamgxcyu
 g9y1vUXkSeWo/KEZ05JIty9zz/ScayEohGCH5RxYbXU/uGWy3JpXIavB/GxKqnTKZoZQP2yQjSErGAYym9FqoT6pvu4tvnTvRLVoMU0RKQS2swDHNyoS5LJ2q5f9x2hxV5frc+VCeGs1Wj0KOPjI9A/I1cH5xXkTc2gAZ2FwWfZ0eezmMzxiaYVagsxnut2hPuuVDwDO96yOkzmI+ppDWGlyaMK47/8KS0G0sVKYWWsn4eEy4UFZ7aBPxq4r0Jy+lO5JQXw1pcmyMMq00Y8bZCU2tNo9zce5jbGfViPYaqA9FDL/VKoYgmCAFqcdPfKZPa+bW0rQ16z0MWChdCZhcs5E9pn1GRnzemYULzeZGZxMwS0V3Vu2TBGh50IzMCGMw2jg3x3DXSayFJpGKhyVLNFaez7eHFeMg/bdAOJ4kc5a8q0gYvE1ny7/t8iCs+W36Am1Tmt0FOub/6UnZUlLLNAr6gcTlE617aumLTiOSOqhwqyoAyFF1V1+q9UxC5AmaK4lOMl9aKG2efERPaiawhGzVZrIff/KZmypwY5gSjeSF3lsH46FnE40fqDFmwXpmGDJt3YwjyVgpoTLRe5MchyRbRMUW0Aa4Hocxf5Xep1RZH3lBsDFrp3o+sj3Wj71cRCWAwzBKId7JBYudY3ALj+dw2Tw8M0nF20/pIG+xWQvqGQe/FQo5Ov8/6ldToL6iefCsvdC6aClaqRCyL2z3BYcpBjeEt0jt0kIChg8DcDyNEjiQyZloToNOhP0ffsFsfEJQuWkxPRzJzbX57OiFTJz03fsWlYwE24Ats+PduYDuf3o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 04:40:18PM -0400, Zi Yan wrote:
> kmalloc is used to allocate physically contiguous memory for kernel
> allocations. For requests larger than KMALLOC_MAX_CACHE_SIZE, kmalloc uses
> the page allocator and can only support up to KMALLOC_MAX_SIZE. For request
> sizes bigger than KMALLOC_MAX_SIZE, the page allocator can emit a WARN
> because kmalloc allocates an order greater than MAX_PAGE_ORDER. Systems
> with panic_on_warn=1 crash because of this WARN. Fix it by rejecting any
> kmalloc size bigger than KMALLOC_MAX_SIZE.
> 
> Fixes: aadb4bc4a1f9 ("SLUB: direct pass through of page size or higher kmalloc requests")
> Reported-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a820ebc.9ebadd4d.20b15e.001b.GAE@google.com/
> Tested-by: syzbot+805630f1453e490427fa@syzkaller.appspotmail.com
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Cc: stable@vger.kernel.org
> ---
> It fixes a page allocator warning (order > MAX_PAGE_ORDER) when gadgetfs
> requests excessively large memory from kmalloc. Instead of adding
> __GFP_NOWARN to suppress the warning, as was done for usbfs[1], change
> kmalloc to return NULL without a warning for this specific issue.
> 
> [1] commit 4f2629ea67e72 ("USB: usbfs: Don't WARN about excessively large memory allocations")

Thanks for doing this.  If you like, I can write a follow-up patch to 
remove the __GFP_NOWARN added in 4f2629ea67e72, now that it isn't needed 
any more.

Alan Stern

