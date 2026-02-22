Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAF48E9A02C
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 03:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C872A6B0088; Sat, 21 Feb 2026 22:47:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C35366B0089; Sat, 21 Feb 2026 22:47:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B168E6B008A; Sat, 21 Feb 2026 22:47:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9DE126B0088
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 22:47:55 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D6A9160612
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:47:55 +0000 (UTC)
X-FDA: 84470708910.11.5404437
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3ECDA4000B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:47:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=maIl76bf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771732073; a=rsa-sha256;
	cv=none;
	b=e+JbBjmVIeN9Fy1tDZBckEiQEd/iZBPWuGYgv8x5FKmNsToiqhIsmlAVh5bxGWpAqRFh97
	Kf1dylEYbfaAIHOgJ+GShroYrreKQKzLBjnbLdIFO2+cbERL6+JJq12Wy12NFG5ljukmgM
	Da36StGpR0BGTMkcd7zuReL517hXQ8w=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=maIl76bf;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of rientjes@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=rientjes@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771732073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhGPtmSA562SEqvNHVKKEpslLeLOD8N4Ld8BbTIjOjI=;
	b=fVKlMpO/3mg5h+So+pH+U35oG35riJDXAWpktkMJjdC4gbC1YSTR7IcMwrK/gFo/qz02Sa
	5FeaHoURnAEKx6+ec+ekfsI7JevzWxsOraTS9EOqH7zeb2kIFUu9m6hU72xqAeyev3qSw2
	L+QvB3YVvuv+lG2FXdqyQD8wDCmP1rY=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2aad8123335so62975ad.1
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 19:47:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771732072; x=1772336872; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dhGPtmSA562SEqvNHVKKEpslLeLOD8N4Ld8BbTIjOjI=;
        b=maIl76bfKEa1uVEqQWAv/u7afeaZipXLk+vvx0QP8veE409IxZOUQBmL9izUE6o8AO
         3s9O1fS6XKIBV+OE+zXfuEp878nLwmWrg+4uEoTFlrd1KNcWGvsMxDslIbSHXcr6JXwb
         MkKpJT7b16wQeNJpiKd+842gGmeXqU9AWYTmcwIZjLb81bw6s7U0oHhhdOSLkeFf9Obd
         VOqgOevez8dYvAq7MpTSjR/5U4+UgZh+S/B8x+eg6DFC0zmYS65UfKJNsE4eKKoW+9Hi
         Fbb0Y9Rn2H6+SsCV04imGVR4wb8kz3WF9gVvZv6c1fguH1bxQ+Mr3o0dB41+80IFsUcd
         Q23A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771732072; x=1772336872;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dhGPtmSA562SEqvNHVKKEpslLeLOD8N4Ld8BbTIjOjI=;
        b=kQO+VZW7I14my6r44tkZnplJxKugYL4emCGy5rOvn0dze5F9NjTP0YWnE2sTjMTZQ+
         /6QqObnfsvyJszP/HeIdwy1i2KxGnKxjquPZgXFwJ6fvD1VzCdXxIDqESlALcyXB9S9w
         cI1Ej0OB1mcYwbTc0XPl9BXvC7mxlZzBLpbdEa/IA10YPUuCKHtKZ63v3kgnCBKcvR+S
         0rxQKHD9LPbbz2me8nsG/sTrOBpBH6KHfOcE5fHRG8XMk7Fc42F1VI+ybI6XP16SL6Kp
         vpd5HNodvtoQx+s5vZexWhUAT7vJnQ16yFhxN0+KWsFPkjTgBzbV06B/34btUGo39wsF
         E0pw==
X-Forwarded-Encrypted: i=1; AJvYcCW2UewmWOH0yhrRJ+sx3kUdpuakoVp2/g22XK1coGw96PbatNCvqrTbi4bkp3w0CVTzoyeHgJFUpA==@kvack.org
X-Gm-Message-State: AOJu0YwCS2Io8SYXabfKlrPYIXu07+8R09zzF9wZbxfCdM9I6vGXjiNa
	8anlkMa/LG7Lil5phDn39v8seoNKzvGTxdLqyi37+tMjnfSGDW419yqFlpQkE0jJCg==
X-Gm-Gg: AZuq6aK1OSZOXLBTJrYqsif0DicGVcCKetGAH1RsBW/rPGXlWeQzcnS6jWIAcy8/+t1
	QqqaUSASs1CFxvvHJmcn45r/pavBMADHRmFOwA28G+IFT9vR+hZMV4kt5MrQjNSZRu8C4QMgSzL
	0rjhUwz6ClvQIzYCFfbgsmN/Ew7SDji7HUNSkOv2OU2G0U1lnN7ZEAQVquXAAEtGLjzE01+WjJD
	IuBi5dvxwHGnJh+HqFcWkZYG3u1wKjbRDfR29viIhSLZcazbjoVWBmkmrQoAqcsQ2JDlt0wl38l
	dzcY+Z+At9wsIP5WfDc/2+PIpZzYLe1Ho61TTVOtqYADA7SNeWieM51JNthJqimffW7pgvh0WQa
	g3d1PF83Q8lOF+0HJzgl1wp+LeVCVFGCGFDqResxNeTessAIGBBsNpaPesmupNNfDvK48caN9b2
	xE350eGNLMyDh4Rv6siasrj0rVElsmw5vnY/emNqBTygO2ycmXHcEEPKL+qcgEgAItyn7tDiL6m
	vvvWFHMs1d9kOVvqkUf+MU4Hwth715L4yb+BN5MaGhhshWxSmGYmA==
X-Received: by 2002:a17:902:ec8f:b0:2ab:333:22d2 with SMTP id d9443c01a7336-2ad75181695mr1385005ad.20.1771732071178;
        Sat, 21 Feb 2026 19:47:51 -0800 (PST)
Received: from [2a00:79e0:2eb0:8:dc03:fd19:e29a:8093] ([2a00:79e0:2eb0:8:dc03:fd19:e29a:8093])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7500e189sm34537735ad.57.2026.02.21.19.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 19:47:50 -0800 (PST)
Date: Sat, 21 Feb 2026 19:47:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
To: Sanjay Chitroda <sanjayembeddedse@gmail.com>
cc: Vlastimil Babka <vbabka@suse.cz>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Christoph Lameter <cl@gentwo.org>, 
    Roman Gushchin <roman.gushchin@linux.dev>, 
    Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slub: drop duplicate kernel-doc for ksize()
In-Reply-To: <20260220124243.3264133-1-sanjayembedded@gmail.com>
Message-ID: <00fc801f-6a11-4510-2b77-a683e5e37c77@google.com>
References: <20260220124243.3264133-1-sanjayembedded@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: s3ofzx37rtjb16aj6tob484f4r1ioyis
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3ECDA4000B
X-HE-Tag: 1771732073-851717
X-HE-Meta: U2FsdGVkX1+gYLPl64owndDlfiusKGiBYjKz0g/AZgizl7sE5nw9CBIfuJue/PKqAA1QKfK3l0859hzFzA6ndtOwN6yTEISoV7bF//JXnre+oSpf28a0AznJd87ORuxGtiXxsXty+unQ9FtNbPVtGFhIOUllCuOZ3L2W3QDkrMbOX3eBzZ/AyaZxXcvXYdCm8NeKZi51WDkr+JnqJOlHVjPE4IZ18MmCzmG8+sB07fyQO6Ow2jl42MY0iK38jS6XOXUss6fBrJ8DOSlA5fCo+jHcaF+lYc+riZQUBDczGqKmVYMvb6NkCzNsFxHLpSA3v5kxp7CM6Eg+Rcy7Guj1tn3p/zU0a3p7UizM+llzgloz/dxa2AC/d1AaLrwQx93ccoBgn1GLTlOpDWfxLwpeKYuA5bkrfnrqdqGXodcK9c0lLVC833XzXLqtl9B/zf0jYKS6NOH+gV0bTUNBYc8BZ1GfhuinqnxaO71BBGXjhZznzdtDdMqb56ek4QrrBBgVT5vtSdwmRasKtoNFGvCjSKLKs0qFW/ZxiK5fliRJ5FX+kVRwP8QcDw16xI8akQH3POE365sehe8BHk8Y2nDEsRVTj8zmYaDlOkmiPTQ4U4VGp3K6O+m4U8EyYz+Wm2v7UJEB6H1e9N3HddOCB4p2FrNx/8JbVZXBm+cImlJX43Io8h0CwjG32Hr4rM+Z/dX4mY8Y/3NNsq7sHkoxgOske0PVDzviYIcUJo8A2RhuvuFuw1PofTOjbLTAWFtAdMWW8cL0I1w8zMSK4+XdLE2f6XLNmfke5GsKa2/i6LYK/DxZsmLeJHIMvbUadJdfDD6T59RjuG1F5qsoILhKKnfEhDYr2B8XtVTDf/rxjrMjR97xLAt+0cp6Kk6pc64c8XOi+2leODtKiqsh3nGSf+0uc91dw+rS2fEPOQCvFd3tYaRcWffTEt0B112OWOKioFjAX1PGEbGSlq6g2LMNztU
 HDhJgkqu
 7qaRkXOMQNt8QHa7Uxy/LGznVwIdDnPbVq7+FxUp/GtLu5YtZLU8hFOEQTlUYPaChQAgW64uVfVc8wBwoZcm046wGKyZjz+PkOCkHul1wLTCQO1sFor/wd2St4K/Lur6gnTifyM9/mCHAwYZ6nqqkYAJ/LrS06iGXbJ3Dl/OWKNooba/MH48xMtBT0DBLZzwNWR7sex+gBcC2nRxDUUW37XfCsEiD/GtEct2QZEnXdJ2U7tFNGqzzqGaE65Q4KgIc4V7FbhjFNP4v+k/nX4MyEANSEzEq5MzkEVMkk9NlhcsRaOPADIguYrDR7l7KN9U9nk+v+AiqdgIxyUXLFajEVzZCp66buhN1EjFeLQy8d2BjUaaFNaAjvrAQcBhze+4GXp5hTk/N7433uDo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 20 Feb 2026, Sanjay Chitroda wrote:

> From: Sanjay Chitroda <sanjayembeddedse@gmail.com>
> 
> The ksize() API is already documented in the public header, and
> Documentation/core-api/mm-api.rst pulls that canonical doc into the
> book. The kernel-doc block added to mm/slub.c by commit
> fab0694646d7 ("mm/slab: move [__]ksize and slab_ksize() to mm/slub.c")
> introduced a second definition for the same symbol in the generated
> docs, which makes Sphinx emit:
> 
>   WARNING: Duplicate C declaration, also defined at core-api/mm-api:521
>   Declaration is '.. c:function:: size_t ksize(const void *objp)'
> 
> Remove the redundant kernel-doc comment from slub.c so only the
> header-provided documentation is emitted. This keeps the user-visible
> API documentation intact while eliminating the duplicate-declaration
> warning during `make htmldocs`.
> 
> No functional change.
> 
> Fixes: fab0694646d7 ("mm/slab: move [__]ksize and slab_ksize() to mm/slub.c")
> Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>

The header file kernel-doc looks equivalent without mentioning that it 
returns bytes.  Might be best to make that clear in slab.h?

