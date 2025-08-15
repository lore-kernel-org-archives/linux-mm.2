Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14520CA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 23:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8268E8E021C; Fri, 15 Aug 2025 19:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A878E020B; Fri, 15 Aug 2025 19:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 678C68E021C; Fri, 15 Aug 2025 19:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 534608E020B
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:13:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0E351117460
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:13:14 +0000 (UTC)
X-FDA: 83780544708.17.70A701E
Received: from out-189.mta1.migadu.com (out-189.mta1.migadu.com [95.215.58.189])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0A1271C0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 23:13:11 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T0CNXYot;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755299592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BxM4nv7eHd9SuH5ros1aBkbmXIdblLOqlo44TIn88VI=;
	b=AUDMGPfOG8WAa6kkq1M4/ijMrLzIIQChid/pOAdBL8njNhN5CGl3qhGL+2ffV/VIIfchOg
	bgp9aeZP4Kfb90mCeF34SV/qFpnOCztctyVhXAWyPaLamJpj7xLtDHmO2Wnkep7JbdUYbb
	iim3LKvkdysIDmeCz162e7NfgYR0SvU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T0CNXYot;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755299592; a=rsa-sha256;
	cv=none;
	b=i3s4Ib8BCPKrgH2OEX0RKS6C/ZjWxvA3GZ/X0VA8N4pTFsNpdvhAqBhY1QHeWRHjlIjE/3
	a7JNNWdKmmD1hTZ5akwcaNrnAgyeyS3P1hwdV3l8UkUecibElFQJNG2PrJr5DtGy6G6Wka
	GfCsSgFJRxlthVEXmWGF0Eaz/f7qG8o=
Date: Fri, 15 Aug 2025 16:13:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755299589;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BxM4nv7eHd9SuH5ros1aBkbmXIdblLOqlo44TIn88VI=;
	b=T0CNXYoth9mLqTfFPM/Rn13mKGw2USAyatawX6LT3DYDqjfVxRg7exGcvzKhNTH0lOq9Vn
	+aamORjVx3GYUlKkfhq/FZ2okstmDVIDDb/X7QH6YmrRGOejvRByAehLmO/SjOGFBULwco
	0onk0x04unL9ucdTRJp0qNiZiPGLYmM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Axel Rasmussen <axelrasmussen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Yu Zhao <yuzhao@google.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: mark MGLRU as maintained
Message-ID: <7a46f7jwlwgkbdjvbxjaalrrdamgtxkptmytllhkr2qv4ovbge@nbugfzavwh5w>
References: <20250815215914.3671925-1-axelrasmussen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250815215914.3671925-1-axelrasmussen@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0A1271C0002
X-Stat-Signature: yjxbkybysomhsfsoj81kap6gmmgtkrj8
X-Rspam-User: 
X-HE-Tag: 1755299591-149326
X-HE-Meta: U2FsdGVkX1+20J27HHscPvMeK245QxHDfZBaQjvCoJYAd/SCsfaPC1GRBwb9OUSCTqC1694tKfGyhy+O/7efBXb8XEsYGzzEkrp5ecuOFFTLOGx+DErppDDV694T8AGviDv0xx/3SLsl3jdSjNtbLv3u0q0eHCvAf9DYCYY2OxZqsecofxbBBfj2sK1AMJOwx1DYNkihUV/Nr2fSZyEUqWqnWMzuOWuEa4iDQgU9r3cQ3AkzuthB7inEZwPtx6tB+fTF92ql2FNCI6ufQ6DB4kVNtO0xJ7T78QOB1kLrpzgyjnL5NeJYw3+OQDEtU3mRScfakpfK3+/OZrPsvN+p0Aa/BMIUbyOepKDrpYdwh6PqId3ZyOlmdWYTxJAjW/2+KUs0J6l9qapVlQkU/GTOVIcj+QgtQxtBtgUAqM9cii5jEyhqoWaZmnAcARXZOQXPFecxdidBOsfp93K0WsmbX37ZBoJINrGyV+BsTtEXRe9NVrvuNMxSp19mOO5QCmpNK/TuVjye+eZgP8I2c17I0TM8Z5a8mYV854QtIcIIPpllJjqa9J2HHiJk0B/GYUZevdc8gFO8exxA7ttS/yYvzGwB7S0g3MXaDrR4nqBIMqYf4esr0GVMZMKbMnypbfCgM9xc8v43tz1mx5MIviZ2AKYPlavD24AKEFmpbeTU2g00Tg771Qg1yC22ciRJBNm7U2Fn/azyXVgjqxOJ2D152dmyMpD2U9dPpsFYUBxSoYZojVRpQV7OxfLUkv87d7PZFO6AN8MqvjX3t5VmnUrh7Df+DL/JBxJofHOhgZeFmXfITH2bLIpFTmToa6LXUPhQd680yD9nU1mRB5Sm9hNkTmsSm0tUm0gPBmrxk6/KYwTFJI/bKFEUFwGL3xYGTClGA2Zoc351jRn11QPEket8E47Y6RS7lKt6UyGG4F9A/GFTavDS7Ulvf3YjCan6Hidfl0V18d8XPVTEX3+HU1o
 u8iv/TOK
 ZyDI7YT0lGV/S5Q5osAyF8EA2TyFliUAOpkLrQtOTk40Z6WSEu4QsN3f0I6aVCdqxwMCO9pzh1S+DdyTXlolkgVpuWrVU/sNKC4RMEqdk6qiQOkwGqkU6IB2Lx8yptu3+MXhB8WlfSC4+ezUUxLU/qAwQr+0ZKq3+olH3mbOBKCCofS+IUxLoR7yFbL2GcKZvGYf+VpF3PEhU6wj+UYhRZd7zxNdBCRZqvBjMXJIURSSzhGQgGs/EaAOTYKqWe8EPW+xPuNYcQsBCgLoDN5t93uJNgFZtWlHFrYHWRY5ZfFCi8qun0nipfP6gwYc9MDp1RrCEypZncR2cvSN6YqGYzIraJpu+/DrnXNRezdvKIta4BM/1nLRbhmLiF7DWn4IN0nNzmPQLRdYy1hyTp2mvk2vJlYUq0DTqMF+G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 02:59:14PM -0700, Axel Rasmussen wrote:
> The three folks being added here are actively working on MGLRU within
> Google, so we can review patches for this feature and plan to contribute
> some improvements / extensions to it on an ongoing basis.
> 
> With three of us we may have some hope filling Yu Zhao's shoes, since he
> has moved on to other projects these days.
> 
> Signed-off-by: Axel Rasmussen <axelrasmussen@google.com>
> ---
>  MAINTAINERS | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index daf520a13bdf..8e987f2668cd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16058,6 +16058,23 @@ F:	mm/mempolicy.c
>  F:	mm/migrate.c
>  F:	mm/migrate_device.c
>  
> +MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)

Why not just add yourselves (and the missing files) to the existing
reclaim section? Eventually we want a single reclaim solution, so why
not start with single reviewer section?

> +M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	Axel Rasmussen <axelrasmussen@google.com>
> +M:	Yuanchu Xie <yuanchu@google.com>
> +R:	Wei Xu <weixugc@google.com>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +W:	http://www.linux-mm.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	Documentation/admin-guide/mm/multigen_lru.rst
> +F:	Documentation/mm/multigen_lru.rst
> +F:	include/linux/mm_inline.h
> +F:	include/linux/mmzone.h
> +F:	mm/swap.c
> +F:	mm/vmscan.c
> +F:	mm/workingset.c
> +
>  MEMORY MANAGEMENT - MISC
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@redhat.com>
> -- 
> 2.51.0.rc1.163.g2494970778-goog
> 

