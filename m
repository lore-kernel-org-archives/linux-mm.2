Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3538FD9E1E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 23:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E11426B0261; Thu, 26 Feb 2026 18:48:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE7586B027D; Thu, 26 Feb 2026 18:48:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6CF6B027E; Thu, 26 Feb 2026 18:48:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B29C16B0261
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:48:10 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6209BB7A0C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:48:10 +0000 (UTC)
X-FDA: 84488248740.15.62E6B61
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81CA6A000B
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:48:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VJCtftPb;
	spf=pass (imf15.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772149688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qMhNYL66uyyvm2mERLSMYbR874HZRTjIqsz72AJ0zr4=;
	b=Fvd5ga36n21GrdQmWkp/A9/GcKAE71LdElmlkmXnGOF/9xN/t+kJcF16A8m2xelFTj4CXm
	zythgUDC4caCy++uxjaBdzloNaxgu+PDxaYSkV86wTZbAOrTVCMmFrDqw3c9Fh30GZ6YW1
	/IY8Gyi/ujDKjd+aICHbHIwf9jK4e88=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VJCtftPb;
	spf=pass (imf15.hostedemail.com: domain of isaacmanjarres@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=isaacmanjarres@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772149688; a=rsa-sha256;
	cv=none;
	b=JJ0GYxHAj4BpGH3R2v/bRhm8TiQKD4H/GBh2tvfMh1z5UBug02qZ5rD/CzME8b8WztvHyU
	juGqHigSQbZSf/TSeEBOndUbaB4Mf2i+8Z6WjTYKyctaIYFHQQmIG3yi9tQf3ZM5fXH2/6
	PvRiNzBf8luTMaD21EggShh3Dv9K+34=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-124a60cc9a1so3848c88.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:48:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772149687; x=1772754487; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qMhNYL66uyyvm2mERLSMYbR874HZRTjIqsz72AJ0zr4=;
        b=VJCtftPb/Rnpj7ZzaERlW6qBvfl3YZzdxu+LknjiGanwgDzHMAM/kAokjSdrMYppPN
         iZ2rJgE7ltLZ+SN2hY42ds8pKrJRh5T1Ig6kuz34kWuuKtN+rljzTwE8vX6yJ9bkCjTN
         M1BbQGKxpDdw1HbD32hHkDgFxX/zmtoJ5woB5MBLagAK8xws+rTq2+7RKTK7Y62qbNSQ
         YwYg6TkyHjIfsSRvDIDu6fJiuzvFDV9Tc2cjjW2OiDrqw+O0yBQZllMjMur50XV509lX
         7rpHdsoayfs5byXK1JptAIPB8R8IfL2iVex/mv5R8RNdca4YF60BejQRrmcgwF0RcnMC
         nrxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772149687; x=1772754487;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qMhNYL66uyyvm2mERLSMYbR874HZRTjIqsz72AJ0zr4=;
        b=sx/uQMiCYirNnj3Fb0JGmFdScjV8IwiqNceoTSDPGi7q9sWxu8c9S6bDR6D4/e1EW3
         F+y06k1dnXFzHigWtOEgtYmA1Hh6KxmK1CvRoO42oeF8Fx2sb6Qf9FnTk5cHQ/nLw2/G
         3ultep2q0tippf2vxc8OQ3+Hw9flZDhoY0V7NI+Ftm6KiFhXIuXOYIiH34vy7/aYZl23
         EHmLvu0sbLFcbqXCHPnHv8mkwLFT1hZaX2f3e4LVVOyg0ANHEDBPEwG2Mm/JkJGFcP0m
         /duH5oEFY2nSYv8Ypc8SukHV4PBs+8IFYcZPvKos3j2o3U6Vr8u5hm9YJLkO2p7Z6S9H
         mvQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnNYRGdMKfsNT1j7Qu9s1lVjPPJOV6o58SnwnoqvGH1eSwMpzfoGrXZ1Y9cFbIo+AsKfgEqMa3Gw==@kvack.org
X-Gm-Message-State: AOJu0YwPQKZZcBB0MsrSohmH+0CjrSBZ3Jd1KmBRHMZ7qnWz6hF0j5JR
	Plx2kFFXvlernfJhajgirbvqM2bw47qn1lxQRJZ19MtAEzf9roBP+8aDJm3irzdTBrlzDt12JlE
	nNVFB1E1c
X-Gm-Gg: ATEYQzxmIG1YqebaGQikOGJyKmffNccsMCa8gvyfpSKMDBoB73QmbYgQ6NvHUuAFDm4
	SPDgfjdI8gTbNh1iOF4t6HsDv6B/B3sju8adPEFTxYtBH9oR8cSk/QBZX+46lRBqZQ+e3H3dLDD
	i1xlWL+O4dNpYHYmg04YxGL79BiDSK6f1kxF/R3bZyNqh76YDryn+n4Rnw0fKj33yudMZv5Dw2e
	0QLEFYl5O7OjyM+rX7Ys6h9ehVEk97vMq1+T+pHLwhz8wGJAYpBeMum8aHg2T+RWENmLDqX8j7r
	olpH/EwKfSVjJvEZ5jv8RCj8NwbYnjRwb1SZldT8xroPtPEiRuJr+qS+Iq4zey5HQl8NSzpL4O9
	eCGAUsZQnr53X6+R73bO8rc63UE1MVd9tfIYk2Jc8OaD+5dk+jNWN+6ElWIT/LaRZLSg3fldU+X
	1xqUEbT/uTvYQXbcEFW5I/YYNq1GS/f26J/uqRul0l1wvoSuUMlDeGCNlUPiWgpAJz
X-Received: by 2002:a05:7022:2227:b0:127:67ef:f180 with SMTP id a92af1059eb24-12788fe0558mr274442c88.24.1772149686516;
        Thu, 26 Feb 2026 15:48:06 -0800 (PST)
Received: from google.com ([2a00:79e0:2e51:8:d9de:6ece:634a:85ca])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127899df391sm3991941c88.5.2026.02.26.15.48.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 15:48:06 -0800 (PST)
Date: Thu, 26 Feb 2026 15:48:01 -0800
From: Isaac Manjarres <isaacmanjarres@google.com>
To: Kalesh Singh <kaleshsingh@google.com>
Cc: anthony.yznaga@oracle.com, lsf-pc@lists.linux-foundation.org,
	linux-mm@kvack.org, Suren Baghdasaryan <surenb@google.com>,
	android-mm <android-mm@google.com>
Subject: Re: [LSF/MM/BPF TOPIC] mshare - sharing page tables across processes
Message-ID: <aaDbscdpsamHakmj@google.com>
References: <ea6c914d-44a4-4958-adb6-642e86488045@oracle.com>
 <CAC_TJvdzgOdvf9=uDaF=zBFWdZ5J9Qh=04Y9OHry6V+YiA-3EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAC_TJvdzgOdvf9=uDaF=zBFWdZ5J9Qh=04Y9OHry6V+YiA-3EQ@mail.gmail.com>
X-Stat-Signature: pwtwso66bbpngnyx93nhz1g9brtacmwr
X-Rspamd-Queue-Id: 81CA6A000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772149688-815550
X-HE-Meta: U2FsdGVkX19F3UeS66vNHyylEAKqMn1a8TvhOR7k6fi+8K7Tna2OiCyGReVivp/wAZ2a0MlzT0GdKDsXfRGZcrsSZQ4IDCJvlrpzOluKcScvu39NfWPT7r37yCAQwxjqzaBH+0GU1tRQ4Zz1HGrNBTYvDbPTw9zaxl/OCYI3igbdjZyHXfkEFQpY3hHiko82KZeXqxyssSkqWyak3JJxYFyQN7en3Q8+1Rtg41b0i+KADibyaZzPKpilZVlkmYap0qJQussbGY+SyP6dIoqaOYhZVHemTeVAQh+LmfkN6NSRutcF+zwdmudaHKKr6F42fvvDX8ED2V+jGzM+xTEK07ifGuZjvzDEd+xZLH/oDOKFMuetSf+msLeorie+wsILOHon8ZZQOQKgrbatEJ3V5WiXz1lsL0A/s9p/lfsjEi9otPvektuXpWZVUaNnCEgD2CFv7CbKJTGIgPDPk7B3uhxmR1+yVG8Yapiv8qXsfipaxuIe3XQBviY4HfKjSACRvyAff3KLAVWBmc4jd1009j+oAIWS6QKIqsw/rYBMeis0A7svuJc0pzEPzM8EofLspqeusKgN539prrNqKcJfDLeCAO8ZUfPhHkt0cDn/FOUTsyAZ0FuzaApuK61Dl1n2SN6y43jsklN0qQ9gXnGfZtYHAU32ueNTDkLDRSemFfsmS+iW7HpeGcwmT/HdZBWLQedxm/vqqyTU53Zikf7wSPI916jXtVEbJLJNjng+Ir772zpidoFqVDF2xHCaA2eYdF7yFdZLM+20tcyxIuyo/IqwV0H++VUhaMMRifXoDoe2Tszbf7AAPHBOR9alsR70rupVmuxNMaddi/wHDB3RVbb963aMYMNama/Y4Lc3X1OAdyVip+unbTgyF64AJsCUPI9iqVNiY2yJ0SMMma6ot9W1Ha87WEAlXmlTfLAJmDZpUWkKpL/VfWBSrUqjQ//Qk/6/wra3tSWCxHn6bop
 cm+bKGrV
 ohLzdtWIup8HimR33C1TuKBKM5ppnzPZzP+Sx30n74yxzBxvx4xx7gNLsK8eMoory6Tp55+RA9dtVE7m41IurP9Q+KH3wFb+H8ZiysjjKOSsOadaWbRvtZGTPgIaipVil1AD+Hc5n5ylQC8MyY2cKwuBoYMojxQlhWPaYjixNbA+1gtcGvh1+DOtza8OnBbFUTdNVMLb2GZJI3wixvxgwOuAZFWV71XuMdY282DUv6DjeTZoXViHPRaKmye3370hlI87aMlxuSfBg/ZCSsNGijHLw0qGZeJOOlxkpOJ5H3fxnvV7wZcApZc8JKygS22y804YtQqa1jL7F6qQkpbIItDjwh5M7d3ktrzHD2hVLfMsS0CGrTkkUtqGetjoTnUnXm7bYdicHTFBw5IRs+TOM1ozgMgBo2EjlQfrPypGob7ZgVWnEwIYhXinVrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 04:59:32PM -0800, Kalesh Singh wrote:
> On Mon, Feb 23, 2026 at 6:12 PM <anthony.yznaga@oracle.com> wrote:
> >
> > mshare is a new form of shared memory that shares resources between
> > processes, namely the page tables entries and VMAs of the shared
> > objects. Advantages include reduced memory consumption through
> > eliminating the need for duplicated PTEs in each process, reduced
> > overhead needed to fault shared pages into multiple processes, and the
> > ability for updates to the memory such as protection changes to be
> > immdediately visible to all sharing processes.
> >
> > For some time now the proposed API has continued to evolve. With
> > feedback from mm maintainers, a new approach using syscalls is being
> > taken to create, attach, and deattach mshare regions and to map and
> > manipulate the memory objects within a region.
> >
> > Let's discuss the current state of the API and technical challenges of
> > managing and accomodating shared page tables in the kernel.
> >
> > Anthony
> >
> >
> > References:
> >
> > https://lore.kernel.org/linux-mm/20250820010415.699353-1-anthony.yznaga@oracle.com/
> > https://lore.kernel.org/linux-mm/20250404021902.48863-1-anthony.yznaga@oracle.com/
> 
> Hi Anthony,
> 
> I would be very interested in participating in this discussion at LSF/MM.
> 
> As mentioned on the mailing list, we are currently exploring similar
> optimizations to deduplicate page tables for Android's Zygote process.
> I'd love to join the session to discuss how the proposed sharing
> mechanisms might align.
> 
> Thanks,
> Kalesh

Hello Anthony,

I'm also working on optimizing pagetable usage in Android with Kalesh,
so I'm definitely interested in participating in this discussion as
well.

Thanks,
Isaac

