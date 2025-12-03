Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A1D0D1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 09:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22696B0031; Wed,  3 Dec 2025 04:23:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFAC96B0032; Wed,  3 Dec 2025 04:23:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B37326B008A; Wed,  3 Dec 2025 04:23:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A26816B0031
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 04:23:27 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E75558E29
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:23:25 +0000 (UTC)
X-FDA: 84177621570.21.E2B06C5
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id AEC3618000B
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 09:23:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k49+nHHp;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764753803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFjX7Gas1ZYIoPQgX1ANr0djeVn/uypCOzwVMV3za7w=;
	b=dMTEnBq6AlyGo/sh7x+PMC8SFb53zyjRAHYTTyKY55l6TY5QIT0J2gWbHzt4w50dVC38mK
	kjdb/1gxxdvkoYXDkM1Xf/4kM00KBh+8AwZ2PrdjJ/ehYbVHoh6AFPbp7QoSNegjnmUdfH
	5ubJqf4DNhNcx5CNiTRhR/pgU+UNMiw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=k49+nHHp;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764753803; a=rsa-sha256;
	cv=none;
	b=D9HJfGrv/wwGX95ga/D58WL9pPGBxEewJXM8xpbIyhtqmsok/qY9KOjCUC6Sva5JgZqxJz
	rr6x1/F6BZSD/LsaTialr/eqpW8VbfPXp66RcAIJ5wer/K4Vs3Ov1RGqtCUijUwuSOUPk6
	X/vk4EgBb9cDzQ8jK3BEtO0fXg7jyaQ=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4eda6a8cc12so62553971cf.0
        for <linux-mm@kvack.org>; Wed, 03 Dec 2025 01:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764753803; x=1765358603; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EFjX7Gas1ZYIoPQgX1ANr0djeVn/uypCOzwVMV3za7w=;
        b=k49+nHHptx5Lyehd1zb97BWKVLXFE/xWKIkvnfIYUF+Ajzpp5fYLpzrcpWV4bqBWaZ
         0WLVQSoHcYXEr2fOTkLglXksMvvrwgd/5mI1PvN2q+t2drTxl6tDDUZ5olNawcsotE22
         ps640HJPNHHP0cpHOX8ErYmvZCQtQrs9DCL+iJ6rgut2UC/lq/VzFsMBcIzDtzArpjpA
         pZ4uelLM63QGmDrYpxqO2H3MxgCTvDJHmJA3sBWTk6L1UQFzwuNFBEm2qTVlTcdGg6EZ
         lU4Z6l1VNJ8971Y6wxjoaE6Nuklo93VX21k/vQ4/fUF9gcWWCbDk+X3rJzavCi8kOpTq
         8jHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764753803; x=1765358603;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EFjX7Gas1ZYIoPQgX1ANr0djeVn/uypCOzwVMV3za7w=;
        b=BTEizDzremx8sRgI42fn6MocyHOyT7e0gI2zxJcj1zzTumSIWxDIQ+IPKZhE24UDus
         OKadx2XJkyuYZ3MDmtmkYRWqX7mCc02ox1e/bnVIDmiId1uNAPe83dcRqQxtdqsrqvrg
         3CvD2MCp1lRr2syie3MdlIlB1+NYH/eYoeuLsUcCDUpazvclmKumw+hhx828oCX3USnP
         JPaYtoJIGqTmnOm04+hGI2IaDfJUmk59jPMX9yY0AkH1ti0qHAuDruEGAlk8kj+yHzB0
         /t5H6VXnh9ZomKV72d2hNvDV8bSjmdvWBJiUHksYM2h4XwyO0jm73IHHLt+FW4H3K4x9
         grpA==
X-Forwarded-Encrypted: i=1; AJvYcCX0CU2L2Kn3i1JwBx0OWoDcfJiD8/uX8IWtRfRsHKQ7wiWAczmP0uD43GVbFQ497EN96NHJyQP+kg==@kvack.org
X-Gm-Message-State: AOJu0Yyz9hs7I9dtVCeGi2BdZF8B7Q4kOHIKsfdBA9FiN8gXlUyoG85i
	ai/WtAaYTA5lI8jjXP9ZbopQEMuSnXpKRZPcsiOrz+7aNAoxd3KY0JgBcdRjLg/pljY=
X-Gm-Gg: ASbGnctDZNLVZ0uh4zZSmWBxP6IqiAv32p+EUzlrNAHnPF25oZGR5fpxKF1br+I11wY
	rspoopAMPo6AHULDzGBbEeWhn9UkX5r8SyHVgs+S5VmcgvtBZVg74eURzHUCBkcI0Y1mC9XGSbw
	ha5JGsNfsqGJl8c/Vro9x54rKP3ZAq5+50PWewwhFe88lniAE6hmTJuDxFqt99YWV8Wyt4dLRhC
	jwRHqjz6BRKgArWV87WKP909biSzhjYd5vXznfdaaFmOEUzyV5ZmsWIT48gjGsmHMAsHlrEmW10
	HlC2a11aLLrxZhQplUIRbR0X2PR7DUGCe0G+HzN0iqrKkeAe3ZLMrRT6MfebehkJZIx4IItiXGt
	Z/HOwjDVMrFTvmkvCwfaaFc/mgKX/BtklAmOOzatiSie4oNA8GHvXOEyu3Tivq043Wz6doMx2kS
	xFVbMJCkygVHRw+IXDx7aF5eTzYfg3MTHX3smZlSjgZ9MRT5a3ZtzDtUV6zIFZ3hodCndKeA==
X-Google-Smtp-Source: AGHT+IHqPQaHW1DZ4s4jpY2crTNj/JQPWH3xZfsJp1SX8T9ifTYZwnPrkGsw5JGaEAmGRsm1E+BRkQ==
X-Received: by 2002:ac8:5dc7:0:b0:4eb:a192:de99 with SMTP id d75a77b69052e-4f017695341mr21786921cf.76.1764753802764;
        Wed, 03 Dec 2025 01:23:22 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-88652b492b3sm123488176d6.33.2025.12.03.01.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Dec 2025 01:23:21 -0800 (PST)
Date: Wed, 3 Dec 2025 04:23:20 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>, vbabka@suse.cz,
	surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Oscar Salvador <OSalvador@suse.com>,
	Juan Yescas <jyescas@google.com>
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
Message-ID: <aTABiHsL8NbGWNaL@gourry-fedora-PF4VCD3F>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka>
 <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
 <aS_4E2H5aJmSvWF7@tiehlicka>
 <47a8b4d5-f4d2-4772-b1b2-ee96bc21e742@kernel.org>
 <aS_8ndgdVbffPYGN@gourry-fedora-PF4VCD3F>
 <9de2f7e2-a202-499d-8858-6936beb251d9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9de2f7e2-a202-499d-8858-6936beb251d9@kernel.org>
X-Rspamd-Queue-Id: AEC3618000B
X-Rspamd-Server: rspam02
X-Stat-Signature: gbj39fz97uqt4niiahgr9oc9xupmhkjs
X-Rspam-User: 
X-HE-Tag: 1764753803-730230
X-HE-Meta: U2FsdGVkX1+jR0osMq0WScZ3VvWJ2IhXfDcpW2Q9pxN9LcfGdwyckpUyAAxy+dEGIyB9z0OqfUs0923rJrk646LkXyjth9er/wVeIIMCNJzr8QmAC4B1fxcyBK1IYP3u4gkllP52htsKA1EFcQHG4WkDj2PemfpjjY3J/mX0wRzYhwc602X8aJYCNbNLvoINA9qs3M4Vn2PvvUbmc+2jKeyXpNakZPH76igA+TK0TpPPlGUuP/qURqayjr3uNjzfVXi4CENTPM3cCJIGZtpSB1R4PcuOfP+He1xBmIjzqYlJoUS9C4ZiAQArMmJsZz2yB4PUahPhlI2S9j0pdEVQcFYSuk2XswkPyJW5v0lMhrPBVkpGA37TooqEwzNPs1hV2cvwv5sgqOkugJ19KEoioUtCc+lHhozO/P53nBT5PZ4L2bq8UdjtasPELaQ1Q5OIHnPmEuAOh5QWE7tzMdTtTq9sVvA9dfHvIohuWPhRwoOQ5mI1tYXysP/N+oZKVgGTMFV4rOj5xvxfMZe7+wL9x97Sok4tt8mL1CG9rMnGIkQoJizQ15ujCCiVyPNbCWb7i+MIlcYBharZFSUvLGXYCb6uU1jKNVYjy52jzeAWjN3vi7tgBhsqEqlwlXDKd4vyUTwn2oNBPESeSOVYoXuQUgx+Eskuc0qIJDsOtkxRnUQZq82stXC7hL2zkVLvbuCz5GvsqKs0bRnv4jYee9I/bJ/LmSZw+Gv8sBNnRFjAR4L6TzIVwgo5dTWjlMVmVODYJmHLCYhdX49k0KZTbR+PHRs7/qO6ilXbKocIXxr2PQkQE5Blls47KtygAq9P0R/wA8EdjOZPFd8ma4XiEq5Zdre+RciGqewkzBuQZSfUNO0SZDyC2xDIMQEA5KL1w1WeG8pKxJGsmBxOiybCatMaNWfPGtfpiVRSCKf26eb1dUvDMVQe9p44iNpA4eLu5jC9R7RSpvKrFuErAQCn1eS
 oe6wlTlA
 Z/G8fbEzXa0yEKXKLrb5q0o0hlyAWS+g2efrwfQ43AYLirzGiwchFbK6Mu8wMeFD/G58AzPQoT3UcYR4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 03, 2025 at 10:08:55AM +0100, David Hildenbrand (Red Hat) wrote:
> On 12/3/25 10:02, Gregory Price wrote:
> > 
> > My transient failure (although i'm not sure it was actually transient, i
> > killed it and retried after a few minutes and it succeeded immediately)
> > was on a ZONE_MOVABLE block.
> 
> Okay, so that one should not bail out. Longterm pinnins must never end up on
> such memory, and if it happens, we have to identify why and fix it.
> 
> We have this known problem of "stream of short-term pinnings" that can
> temporarily turn memory effectively unmovable. Juan will talk about that at
> LPC [1].

Nice, fun, good topic. Looking forward to Japan n_n

> 
> We have another set of problematic cases (vmsplice(), fuse) but I would
> assume that these are not the cases you are hitting.
> 

We do use fuse, but this system was relatively quiet when i tried this.

We do have some proactive reclaim / demotion going on, but i don't think
it was that (see below).

> > 
> > Kind of suggested to me there was some bad condition the resolved once I
> > took a second to release the lock and try again.
> 
> Hard to tell I'm afraid. Do you still have the dump_folio() calls we print
> when migration fails?
> 

What luck, I do! :D
And i just noticed it's the same page over and over

[ 3404.119270] migrating pfn c06f176 failed ret:1
[ 3404.129152] page: refcount:4 mapcount:0 mapping:0000000061ca20ba index:0xad28e5b pfn:0xc06f176
[ 3404.148284] memcg:ffff88842e855000
[ 3404.155834] aops:btree_aops ino:1
[ 3404.163193] flags: 0x17ffff066c00420c(referenced|uptodate|workingset|private|node=1|zone=3|lastcpupid=0x1ffff)
[ 3404.185408] raw: 17ffff066c00420c ffffc90066a13ca0 ffffc90066a13ca0 ffff88812b8502f8
[ 3404.202603] raw: 000000000ad28e5b ffff888859fd42d0 00000004ffffffff ffff88842e855000
[ 3404.219779] page dumped because: migration failure

[ 3404.230610] migrating pfn c06f176 failed ret:1
[ 3404.240483] page: refcount:4 mapcount:0 mapping:0000000061ca20ba index:0xad28e5b pfn:0xc06f176
[ 3404.259603] memcg:ffff88842e855000
[ 3404.267152] aops:btree_aops ino:1
[ 3404.274511] flags: 0x17ffff066c00420c(referenced|uptodate|workingset|private|node=1|zone=3|lastcpupid=0x1ffff)
[ 3404.296716] raw: 17ffff066c00420c ffffc90066a13ca0 ffffc90066a13ca0 ffff88812b8502f8
[ 3404.313909] raw: 000000000ad28e5b ffff888859fd42d0 00000004ffffffff ffff88842e855000
[ 3404.331102] page dumped because: migration failure

[ 3404.341778] migrating pfn c06f176 failed ret:1
[ 3404.351658] page: refcount:4 mapcount:0 mapping:0000000061ca20ba index:0xad28e5b pfn:0xc06f176
[ 3404.370781] memcg:ffff88842e855000
[ 3404.378331] aops:btree_aops ino:1
[ 3404.385687] flags: 0x17ffff066c00420c(referenced|uptodate|workingset|private|node=1|zone=3|lastcpupid=0x1ffff)
[ 3404.407895] raw: 17ffff066c00420c ffffc90066a13ca0 ffffc90066a13ca0 ffff88812b8502f8
[ 3404.425073] raw: 000000000ad28e5b ffff888859fd42d0 00000004ffffffff ffff88842e855000
[ 3404.442264] page dumped because: migration failure

[ 3404.452928] migrating pfn c06f176 failed ret:1
[ 3404.462809] page: refcount:4 mapcount:0 mapping:0000000061ca20ba index:0xad28e5b pfn:0xc06f176
[ 3404.481948] memcg:ffff88842e855000
[ 3404.489511] aops:btree_aops ino:1
[ 3404.496899] flags: 0x17ffff066c00420c(referenced|uptodate|workingset|private|node=1|zone=3|lastcpupid=0x1ffff)
[ 3404.519128] raw: 17ffff066c00420c ffffc90066a13ca0 ffffc90066a13ca0 ffff88812b8502f8
[ 3404.536332] raw: 000000000ad28e5b ffff888859fd42d0 00000004ffffffff ffff88842e855000
[ 3404.553534] page dumped because: migration failure

[ 3404.564200] migrating pfn c06f176 failed ret:1
[ 3404.574077] page: refcount:4 mapcount:0 mapping:0000000061ca20ba index:0xad28e5b pfn:0xc06f176
[ 3404.593208] memcg:ffff88842e855000
[ 3404.600769] aops:btree_aops ino:1
[ 3404.608138] flags: 0x17ffff066c00420c(referenced|uptodate|workingset|private|node=1|zone=3|lastcpupid=0x1ffff)
[ 3404.630355] raw: 17ffff066c00420c ffffc90066a13ca0 ffffc90066a13ca0 ffff88812b8502f8
[ 3404.647558] raw: 000000000ad28e5b ffff888859fd42d0 00000004ffffffff ffff88842e855000
[ 3404.664761] page dumped because: migration failure

