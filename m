Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43B07CA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 04:07:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E006B000E; Thu, 28 Aug 2025 00:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34DAD6B0010; Thu, 28 Aug 2025 00:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216106B0011; Thu, 28 Aug 2025 00:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5436B000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:07:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6E41E1409A9
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:07:07 +0000 (UTC)
X-FDA: 83824830894.02.11C1AFF
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 891E240003
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:07:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xk6bOb3x;
	spf=pass (imf12.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756354025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKxx3AHJzssWTQS4qsQitsY+pTv4aEpgVk4Q3F8J/ZQ=;
	b=n44bl/Z7PHTEfL0PGxX6mY186QjAQ9+Sxtv5yBGdwF7K+2XPzrODnhTAQmzgDg/2G1fNM3
	lRO9vnAOFUyE4bYwu5KDOCj2Na01bcEPTTBjR0jzf3HJmNve5OOgkFbLoXqU9cRUoRb79J
	Zv4Zw356R0iBLi4pkDTxIfZ1qtdDlNs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756354025; a=rsa-sha256;
	cv=none;
	b=fJecqx/u7xvpOmZvbC70HHLQOsUY45dUdueRElKsS3g9MXKb+VGHT9bbB4eehgkdWlUQRd
	/TMwCBC9xSRLlt749J0QGnGBmMDSWbZDTSLwWzf0ftHBlcdC+Yr5pnfV/nVZF3Rq7LuLIz
	D9KVTNWbsHZJdrmf7jBci6NbgBbsPe8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xk6bOb3x;
	spf=pass (imf12.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-24611734e50so81995ad.1
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756354024; x=1756958824; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LKxx3AHJzssWTQS4qsQitsY+pTv4aEpgVk4Q3F8J/ZQ=;
        b=xk6bOb3xpN7fC9VqW6e8B7DHMuWJyjkG4wE7H9uJ8U6h+OYLmiKJikNFef4QsyjqDc
         dUJEhYJe8MfpjTKSuRv8TGcVt8wQhURpUZcBTxQ34FzqIVUFgl6i64czI6WakTk1XYZk
         JnyxVdvLmpii7E9DOER//lwrD+OpbnVaSbOn4xUJtBV0bj5gFlUJov8vPa6sacyeUQJj
         XEYhZLrRSALsnS6KAqmIJjRdneybiN+XT+ZcpuYBVMfmGOO+z6zYiy13CbWjVTTXeCAY
         5BNt2BO4NYeDl8KkLhsjNScKS6dhAVNHB0n2WUrIFdvdrmf04MRKiB6+PaP0NpY/8/Ie
         a3cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756354024; x=1756958824;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LKxx3AHJzssWTQS4qsQitsY+pTv4aEpgVk4Q3F8J/ZQ=;
        b=M4FfCHXZCOiP16Da4C4SfcbEMhLUiEDHwZ7ukBqxKCtEvp9t+l/YDbSGCZ4wdcDR0C
         WKWJJq5Iyq0/VZ82y6ZH8sHBzwm7wujlEPMNHKqJMyw9yAPjGrONQy7EhtI3d4QOIuG6
         1AEl6Q2FA5oXzvuFVUHOfGQp4wSgU7FazfgQI7lpsaxbP5pXVvKf4Fg72B3okBZyrvIx
         0TTbHVVEB7FVSG7Jt2+fluq5KQkhA6zW/g+AH2uJrrXLVxntT6g8JDXh+bHYHtY9V8BM
         vZ2oeGOF8bDIHSRxFsW6Lyfg0GI8gMetSgksrw92DWFfsbCaxxSeOHJt+gEJeiyJMsVI
         ceUw==
X-Forwarded-Encrypted: i=1; AJvYcCWW6w/lZEb2rrapIeaeOLjl35142gJTRROI0z+oieiy9yAbX5VunspH4hssSoZtstD3eG00leAI/g==@kvack.org
X-Gm-Message-State: AOJu0YzeIQstbttf7ZpSwnctOp44FQe1RtrqOUPD9Qw/HosgP6/GF/Re
	IIdEiNvvQqJA+lyqkPC/KMk2QsWaGHww8nVfeR1TpZB2RNQqzX6JowQhm0tmzz+kwQ==
X-Gm-Gg: ASbGnctGhf8iLygd9AQ2tOyDlRhbnwUiBje2CXRdoR/f+r3XuWsod0DHwgH/q35UVJe
	FX8y2V6QkX82+ZMpiavhAoVdR21Rr7Fu355IqXK4B0qprsSwfrso0qwhvPhHQGJZ0V+QHNCKsZL
	oExdAYE2CuazauOZPMjfqjFkW67veun36aCaGYWBRs3qB+deUuFAlMgTN4b8VRUYAwsKooXEDZm
	HC+vRnuQqhj1krDopkwTa8I2oMmrlok8Ehi2h7QI4bX5TytbracFfijGnAsS1rU+FXTNpRO8ynE
	KgWSX6vypP4UBLh1i1EOajDqLeBFvZQojA2MnDEV5kt1bp8igHQFCxln7Yur6Hu/xe5HLEmdwhQ
	rs4xkcHvVihESbsphWDHuFpuh2nGemK/uCKnnwRcDb6NaLKGg/SCFnSKXSDOzZ/GBmfvENRjP
X-Google-Smtp-Source: AGHT+IEhJaXUpm/3jABKEO0/i+uPSd6jtOc8RtyaMS8Pll7cTZNJiHYF2mPDEp+IH3Qy4jST8wMAwA==
X-Received: by 2002:a17:903:2348:b0:248:a039:b6e3 with SMTP id d9443c01a7336-248a039be4emr5139285ad.10.1756354024077;
        Wed, 27 Aug 2025 21:07:04 -0700 (PDT)
Received: from google.com (3.32.125.34.bc.googleusercontent.com. [34.125.32.3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb88f4e5sm12850589a12.1.2025.08.27.21.07.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 21:07:03 -0700 (PDT)
Date: Thu, 28 Aug 2025 04:06:58 +0000
From: Carlos Llamas <cmllamas@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	"open list:MEMORY MAPPING" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm/mremap: fix regression in vrm->new_addr check
Message-ID: <aK_V4sOUOIpEhFC-@google.com>
References: <20250828032653.521314-1-cmllamas@google.com>
 <xpxoxn25fzhahdyvjp2vgmcnek6oot2hhvb5niz3tw7au46eno@cixyid6ywf27>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <xpxoxn25fzhahdyvjp2vgmcnek6oot2hhvb5niz3tw7au46eno@cixyid6ywf27>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 891E240003
X-Stat-Signature: izjzeazzirp6gc7hsrjxbekxtyt9xyso
X-HE-Tag: 1756354025-126191
X-HE-Meta: U2FsdGVkX181a1wdqMBr/CtFnXFHcIkIqzx1pQ1RabvcGLSaDvbT+yb4jtRN793KzAuIu0L5wgFFqIgImgVMbbXD1hoNptdZkpRiX2Dt95FE/LiytkHoxY3R8mX3b0mAyacuxF40lew56k8I2kwMpFCrTJYndgAUo/GDrIwYbLTOoeFpEEobzSQIS9367kbVWwegA4n3XqoBNH/vEiPu/TNNOa2NHm2XhzaCxie2C6iz8C+NyhCefX9nu0hDCodt/YWfcyfSzCZ29OVCIJvBuXcxH3J/484vRQimrmspbsD5uKQfL/R0J8Yj9LnqoX7yl482kCq9N6PEN5cq1nUNxJT/pESeMQ/qqxqvbSgUAyQNLJH/YnOTu4QUW3SKZYfb+XZqtXwLp2GpzSMFsmxw6H7cztIYwJcW9HaMxTCmLKVXLCGZmCsl7Szjq1ZB2jJEEej0M1ww6opT6ZIjKuvSrFn4HlQ1YU6NWGvVw6iNUMiXOzqhGjLXBP5GsQQoAy11nLZxvy/rc3g13zju5iPv7PYknybu4o9Au2peTMixQ6esQjkwvedme05lUqyT4T/wTzzsFTOpQRwnz9NBO7aO9I8Q3vbHruheZ9QUpgZBN52Qm8Ix9Ke64Z26DZpVC1uAf7LKiTlxcgt7iMvGPufyo3J9KXSVsht0Zjvmm97eSKZyTyTpbU2ictlzHAlFGXF+vq5BuCwgsBeCQ/DczSi76V2RGdExfo3OIduDsyx8zKL8UOIzxA8fcTKKM2d52GyLb0pqa3baZD0xZaUWCIPpc7o/I2M3QfqD2+Nz/FazKaP6YHi+FrO+ou5swRyP0BaPKpSqwYpU5RaZiFxbmdkkbcEJi/cTTLVZaMCyGnzYmmhBM3pBaSbiUFbxIo9t1aQmFRF4FXeJeeGBo4hdlnV4UdC2RbUrd+pA3Q2QR3908Yfw+jhgbz8Mzyf0qX4J8PCK22X2rK3wzZkQ+aqaixJ
 3zE7wJjj
 3hf+rj1UElVqd12vpUx3yg1KwsWnwPTUWsDb8yC4GXv851dkkfwIg/2CO8nPgROp1qYGIBEG/opvm4GWPn6P18ConFtEt6BQLFYvg2CmjxRQLYlSCgkePln/+LyEVVrihO2XznGox+b4sfgIWEQrptTc6HQQnf6gd5StrmQC0xdjoNtMteDnAVWODULstUZ59CtCJGmAtI6wVO7lUDlmQLXtwO8D7sL7DfUfgfg1n+BvXljbEBkIZ2DCuPpS/H33AehH1og1sKUdOB9WOuH1VrAQN4mICq938/uIwySfCw673OKar7j6sMNpD0L+FySr/S2CDAOTsHVOKDE8FvyTGD5FnOfUZ5qQyrYrPGvDK4W1B0vwghzrkMdL2/I4flK1mYYQPn1JKwPWQMsrDp9R+jmddkwnKbKZU6XjaTMCaKAVI+71j8AmwT1GbsfhhTX3hEFiwnA1csLgzKUA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 11:43:39PM -0400, Liam R. Howlett wrote:
> * Carlos Llamas <cmllamas@google.com> [250827 23:27]:
> > Commit 3215eaceca87 ("mm/mremap: refactor initial parameter sanity
> > checks") moved the sanity check for vrm->new_addr from mremap_to() to
> > check_mremap_params().
> > 
> > However, this caused a regression as vrm->new_addr is now checked even
> > when MREMAP_FIXED and MREMAP_DONTUNMAP flags are not specified. In this
> > case, vrm->new_addr can be garbage and create unexpected failures.
> > 
> > Fix this by moving the new_addr check after the vrm_implies_new_addr()
> > guard. This ensures that the new_addr is only checked when the user has
> > specified one explicitly.
> > 
> > Fixes: 3215eaceca87 ("mm/mremap: refactor initial parameter sanity checks")
> > Signed-off-by: Carlos Llamas <cmllamas@google.com>
> 
> I assume this showed up with clang?

Right.

The specific test that broke on our end was this:
https://android.googlesource.com/platform/bionic/+/HEAD/tests/__cxa_atexit_test.cpp
Although I'm not exactly sure how __cxa_atexit() implementation uses
mremap() underneath.

