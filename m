Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2547410F284A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F5A46B0096; Fri, 27 Mar 2026 12:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A68C6B00A0; Fri, 27 Mar 2026 12:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 794AB6B00A3; Fri, 27 Mar 2026 12:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 65F866B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:24:39 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 04EA2160664
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:24:38 +0000 (UTC)
X-FDA: 84592366278.27.9287821
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id 150DC4000A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:24:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uobOBVSV;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cso+lo9ayj72K0N3BDCj+IbAGqDP53N9g3WGxbzu7rQ=;
	b=zl7g/AQkbQ8PR1G6TtJNUGZB93IH12HOkjUIPMSKAhcNJj1nXFq5paTQjjcv8/PuIKB1fj
	wL53QpffsSBkE5PSEarg40y2xPQvwlOIvDANOMUDbJ5EhRCKfQn9wmdm0qi3gtKS2IUl/t
	RwcK+t4PYA73oRrjAXKGsMwVSHkBrdg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=uobOBVSV;
	spf=pass (imf11.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.50 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628677; a=rsa-sha256;
	cv=none;
	b=RJi8H/AuJAhBCqJNpW9AD/HiHVpjRCwFDO/t45WcghLlDa+nKWK5PFNfrMhu6qw2toYvVt
	/UODGjVxWmHK4tkoo4u/xGOkMlzOYwJe0wmeyfYY21aWIuymnr/ld6DIpAUEyEEqKm5onH
	agdt0PevH7zFHy95e2ZHtcZChE+IKMg=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-89cc797547fso25558226d6.2
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1774628676; x=1775233476; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cso+lo9ayj72K0N3BDCj+IbAGqDP53N9g3WGxbzu7rQ=;
        b=uobOBVSV3UGOUAaPV1fA3rIFU2UHDhJ8I/NjPHEJEumkHW2DWT6wa8PoT3DoC6QuHS
         B6GevHrnOeuQ65EGdMg4EaKMfGQCJ1S3/NDWcL3NGNLXmU5xxYzN/3SrtAV/2XZDujbN
         RJIrrlx6IKW1SE88Fzj+hikS93CGrF5xGpRVcDIG11HNoHOcidZiDOIZZzghMl8kHnig
         jd3XhSyAsPaQ30nK/W/ZxBTWpYns1uN3t8zq+q2vqGTQIhoGpzCPxNHRrl26E9mUIjun
         Y+ieYEGXqKdvUUB2bxW/MFVJSCNBcnTZd9GPTYEr31GakJ6e3JZ4ZGQqz9H3lUdiVfEm
         z9Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774628676; x=1775233476;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cso+lo9ayj72K0N3BDCj+IbAGqDP53N9g3WGxbzu7rQ=;
        b=eGkGqm2/gy5NMSFn3U/i2fAgugW3xH8VQYsfgtzTQZ7leJVcozrpfaonAqu0QTIfoj
         AvPRBuygq3Q7stMbvyoEG3CfvbdDmoB4He0+YnaQuJfzqRAKypGByxFyLj5OTu0yVPOP
         CS01U5Emw78459/GWLKc+9sgLyUyQg8e96qIxUZZ5cN1s6VaON/KU08rBVUcx1fYgCxw
         OYgpP+HDuCvAchtCcDIJnxEh/mU9kRITze/a44mQsVn03NP2qbl1UFSGCDGzl+0R2Kik
         9YmVpmx/IBiYngi1Z8hE0WnlkCqM8qfydAi9dtHxRbcZCz1mjqewf76OP+dEKB9UVybP
         b+cg==
X-Forwarded-Encrypted: i=1; AJvYcCUlhTzfHvCqkECMg1Liyg3E28ZJ+oa0/zyvj9ZdLTUlMpWMvza8Jx/q6bRKsgp69Ksr35ji1nmduQ==@kvack.org
X-Gm-Message-State: AOJu0YzD9ftHosppztPlTe7LRUArCfsWsTKwH4c24i9NkCfcEUBeu02j
	0fiF5IhuEm45pK43Q0soNAISYjyzTB/B+433xX7sWAqxNyhmiKibjv8a/8/xfkMNw00=
X-Gm-Gg: ATEYQzyYeWYrmMRmk2w6nZoQF3y8gnRlWzSyO4+fzSawhPjbGOIBlCLSkqDOGmS/IGQ
	f1Pyi7ONKax/SA9OkV/gPaKQ5OIoJpAocZc2ZF6sD9sZ1rQwZfEyG4J6cqmAVaEcb1NdOjNrlJJ
	dT2Nb2c1bwprq3v+cg+cQ4bY46f2sFGpR49ys848aBTiGHTm+cbdLHHN2qkJTZVsoknjjpQrSnL
	YhNYbH74tTh6BU9Urng8x8g67Oi9uAFVEomv1CsyaDl5duZQhUy4t5RvHTsnvoda/n9mMlN2exG
	SVD3u4pzBxSC200rLWU+T5WxIbKp5GFB+npTvfJLsZ5uv+j6mWcu0Oi8DGzrfJAYvQNwOPatKEt
	KBEqcOBkoZ+Ug7QV7MMfoZpUI88pPWJaciRAEw/coOOVhWk8412CjpSFnRGBCRiBELMo1OQ+x74
	DqMg+PU3YUeScSP1SzpxGpLZ71O2nP/XBv
X-Received: by 2002:a05:6214:3f90:b0:89c:4ea7:a705 with SMTP id 6a1803df08f44-89ce8d8b0dbmr44536236d6.21.1774628675762;
        Fri, 27 Mar 2026 09:24:35 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd58553dcsm55760946d6.6.2026.03.27.09.24.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 09:24:34 -0700 (PDT)
Date: Fri, 27 Mar 2026 12:24:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, jack@suse.cz, hch@infradead.org,
	willy@infradead.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: reinstate unconditional writeback start in
 balance_dirty_pages()
Message-ID: <acavP-qpB0c1nNO7@cmpxchg.org>
References: <20260326215127.3857682-1-joannelkoong@gmail.com>
 <20260326215127.3857682-2-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326215127.3857682-2-joannelkoong@gmail.com>
X-Rspamd-Queue-Id: 150DC4000A
X-Stat-Signature: nzro197tsehyz5nc9jy1k6fqhrpe1wkr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774628676-174569
X-HE-Meta: U2FsdGVkX19TQECh3rXYnaR5pJg4qiMtPT77I4tnBMNpqEJHi5sVxK2bw49SmLvpi7ba7A0nDZEI0MS/8BKvuLPlKLA3/ei+4lA0mdMHoEjuCnwJpjK/nKmCIwQB2dEVq4OLMECLNYVbirzipUtGeIWUQad5BgniTvMzQ4/sKEOH73mPaCLvHIYBoRn/HNsH7pM3ANg2uHLfyE2PI0Z2ucAoMFxWf2rkW/QJPzeTz93wH9HefGUJVbbKT6DP9L53vRCWPFMmKGl19I3US58NeUzCv3j38Lc1j52eA8go2s3gPuqZ3yVnBij9nmNm2YFY0nCj6xNwckOoXIpTuJxTSGcN5WYVjRUCFipdpXF1/kkcAV6ruO4CwYP+l0GE3Zy4t2XfRSnHx3eZnZ5PPoJcly5QhLskRpRxQ3ERxNMniMixTXhuUl+iAGkmKVzFN/KfjLfwwRxiph2L9Ub7g2ppETVnoJCYls22zgvoqFTubYdBGc29FN2VM0NaMT6BSHf4UBntZ5a3FjIQKZcx5D8QQfzffTc3a/qzPa9n6khTDcPr2Y8E9FAjk+IZ+JkHVY9O9jnjNn7PXEEzTB0xdEpp3QvP3UUXVm7pSJymREdHIPS5Nx/1SjUWzeLoq8/6AZwxWF4u8ccu1hi9yRI6RiIUMrNxpUj0QOhq+vnGOPO8dL7+LmtZYOI2dtFh5jqjJRHrLj7GugbbHv2Morh+6J6WxzVNJZv7Lp8UurJyq2XwHYVSI3YGLgYcdrsI6TBTeOoNIIX+pmxjFDqt7OuHWqzqC3GY1DPdfG89rBvNi0XOho9zuRazY0wDs+1d5O2QKk/+GBg2MaxtcbPy2NOL8xPzznEzmm9zV8sG2U6MHAsKo9goJBd/UFjaEdWbYG2jmybe0Qc0HtXbndgvZOAs4E+77j6YaMB8jVHzggW1JyNal15qGaLnclrgl4Gf7fcGzbfrSU51COraplGBYduwOBy
 29Oy508r
 iXZK5qkz3Q0DKkYyItPO75oyDCg0efKls+Qv2T7lk3knGVIpomX3fbg3bFtS0kflHwYix5DGdj64SD9LNtzf4SR0BclghQsWxHILNNbT4uAxwFH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 02:51:27PM -0700, Joanne Koong wrote:
> Commit 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") removed this
> unconditional writeback start from balance_dirty_pages():
> 
>        if (unlikely(!writeback_in_progress(wb)))
> 	       wb_start_background_writeback(wb);
> 
> This logic needs to be reinstated to prevent performance regressions for
> strictlimited BDIs and memcg setups. The problem occurs because:
> 
> a) For strictlimited BDIs, throttling is calculated using per-wb
> thresholds. The per-wb threshold can be exceeded even when the global
> dirty threshold was not exceeded (nr_dirty < gdtc->bg_thresh)
> 
> b) For memcg-based throttling, memcg uses its own dirty count /
> thresholds and can trigger throttling even when the global threshold
> isn't exceeded
> 
> Without the unconditional writeback start, IO is throttled as it waits
> for dirty pages to be written back but there is no writeback running.
> This leads to severe stalls. On fuse, buffered write performance
> dropped from 1400 MiB/s to 2000 KiB/s.
> 
> Reinstate the unconditional writeback start so that writeback is
> guaranteed to be running whenever IO needs to be throttled.
> 
> Fixes: 64dd89ae01f2 ("mm/block/fs: remove laptop_mode")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Thanks for the fix. This was a combination of the old comment and my
overly hasty read of the existing dirty > bg_thresh &&
!writeback_in_progress() block. The patch looks good to me.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

