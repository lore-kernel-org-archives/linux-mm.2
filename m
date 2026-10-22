Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D258F606A31F
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 02:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=BcWhzLNN
Received: by kanga.kvack.org (Postfix)
	id DF5276B028B; Wed, 21 Oct 2026 22:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCD3C6B028C; Wed, 21 Oct 2026 22:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE32D6B028F; Wed, 21 Oct 2026 22:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A24C76B028B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:36:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0CA871C404F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:36:23 +0000 (UTC)
X-FDA: 85348698246.03.C7ECD4C
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3858880005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:36:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BcWhzLNN;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792636581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OnfyzMLO0P5DWvV355CXnkmHdcF8VekAj3yYMzW5EvM=;
	b=GPdpmekg1W1cBnm3SbhDHKDFzqnfSYjcWfBfwRhbnwDw/JG2o8kPSTCUuzt6SYvrRtaBqS
	U0td4kKhsy/WgYEpD5xDZhMp7MZzlVGc0VcWG/2BDOHWmSIu0sTktMf8DhDVjy6NfeoCiD
	CRC1A/L/zILXhdSQaXIGn/mncPXwZd8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=BcWhzLNN;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792636581;
	b=GwR3zja6uJwjAQNhqzqh1C2kYvDUEC+uUXpFZd8zsA9dBt8GokrRQlWn6J7+39VH8XZkqf
	K8+wYOPsq4i5lqzBtydXAqFq9Or/H4GSWQn1l7ol+0z7D7XUwR3EOH7dQKdWMATrFNsr8C
	DkKmHj0revKTivm9tIyxKOYBszoM/CE=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-534e6545939so10597281cf.3
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792636580; x=1793241380; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OnfyzMLO0P5DWvV355CXnkmHdcF8VekAj3yYMzW5EvM=;
        b=BcWhzLNNR5z84gdLU6IFnN/TvzLVnTicJn81h6t737NsZRtNj/0TvkwrBsfDuPC7Bf
         W4Hn8EePLAR+BgyI8qSUOzFh+olx1y1PWHS8ucHR3ah1MDTXuH4+WG3WuJXtOS32Akso
         LSK1lZ+E69gNVVwYM7Vs6EDRZVM7SIMPZEjEHdNaSazKunOHh4dEPBsA1ErX08sj005b
         0AGCUAW90TXv3qJYYTCur4xsMj3OQmfi+PDtdxpC9CLwMK8LxcAWj39WddB21SiinFec
         g9OzKGD6iPm+MFMjNB9Spi0E2bAbpSTsih+8n7Mi/JLgFqJP10OTMsUvNbLJPeHt/9es
         Yegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792636580; x=1793241380;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OnfyzMLO0P5DWvV355CXnkmHdcF8VekAj3yYMzW5EvM=;
        b=MJ/amZif1F58CRFisFkniraUfAFNWbMfhd3c1y5PW6Ld201ebBwMpU6w3RHMMshdrp
         bDxuRtrmEP7ErMuf5kL9iGeBb1JbNLwGa2aSBIKkpwcBCozlfsirjeEQpQqV3nXMYjY0
         J5M9QBhO89ullbaWdHuKCk4kN5d4jG4UnnTXryXkhy3ceXjVOgQlLsT8TjHRBFlFBNWj
         pa2sG9D8p/32+ooSC5OSEiyYUsDUTYHHSgVXJoUGd0oOvazTeUjhkivuN+WDgHsTX0bb
         ndxwCxSQVoL+G6kgWIEib2cXjS03BKjkXbQyow3SuyUz4m31aoElY5j+s+9qqrlfIDMv
         WYcA==
X-Forwarded-Encrypted: i=1; AKwUvBxYIsxalYrJtRR1B7rWjSaiXoNFZK5FwIkX32FvmNqXVApHWiKvOtRYWGz8SIA0P9u3/1USDZtfBw==@kvack.org
X-Gm-Message-State: AFq9FYJPnAmJxVAg3aYTDMYQ1VeSzAOafHUwnApEs0KgwfptJDeYotP5
	NePPc4X5UGzoHPbE9yHI29xg/7xm2rq842QWbbcsPJlUHIk+zLpaA7k/SmwBLABlaF4=
X-Gm-Gg: AYBFou3OClu/oat0rEuf4r0KUoRskI7czE2I64ULb8RMKpG43OCpdmxH9QYXTHyMSmt
	+5zpewK9Jk7wB4uJvdMgWv22OJhlb9DimfbxflFgolfzqdm3kHRGpP2S0VzkhKYVe7c96FwrrCl
	EZWC6JkldpQZHp3R5Okl9EKQU+hUqlkZEPBCY4SFfxNGTR2H/5ImXL8HVbk2eZ8WrEdZpaKaOtJ
	Y7T+j5BWJV4elgC+evx6fj6ClbMAyI8UAa6GgK4b1WQ8X9WvNQxag4WYq9+zELRSmNHvI56FU+4
	SyH+/jFScYXBTEpOibOXcxjubUeTddJl+mfDTd2ysbqmAntzzL2Ccs8Iw876jrSbBJ8KKCZhO0H
	DHhecCIxNOLyLRgLO73XoULCANwWXw1Zvk4LdBkpQTlWPHUdNq9P0ezhVVkont+Lp+ky6FN9ZIJ
	QVl8bMID1f4ebm1V6vthWYzSTtiUFeFE0+RojG5RAwZMCX50Tj7yDKCRWdkYpg4KqoY3UEMpFSZ
	TasbmBqd3ZBnsL0U3CNkZQrtNF8GOrwAebSbh1OOvPaB8T20WbvHvjzyrwm9Mz9Wq5K4bP/vTVI
	aDFXzZvBIyCzp1dzk10L2OI7FVw=
X-Received: by 2002:a05:622a:4cd:b0:533:2bf3:3301 with SMTP id d75a77b69052e-5369b86ae59mr66504611cf.36.1792636580301;
        Wed, 21 Oct 2026 19:36:20 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-536ab73b09dsm16032801cf.17.2026.10.21.19.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 19:36:19 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 00/12] Virtual Swap Space (Swap Table Edition)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
 hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
 shakeel.butt@linux.dev, yosry@kernel.org, david@kernel.org, 
 muchun.song@linux.dev, shikemeng@huaweicloud.com, baoquan.he@linux.dev, 
 baohua@kernel.org, youngjun.park@lge.com, chengming.zhou@linux.dev, 
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, 
 surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com, 
 yuanchu@google.com, weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
 haowenchao22@gmail.com, corbet@lwn.net, hughd@google.com, 
 baolin.wang@linux.alibaba.com, tj@kernel.org, mkoutny@suse.com, 
 skhan@linuxfoundation.org, rdunlap@infradead.org, kunwu.chan@linux.dev, 
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, cgroups@vger.kernel.org
In-Reply-To: <20261021060323.553433-1-nphamcs@gmail.com>
References: <20261021060323.553433-1-nphamcs@gmail.com>
Date: Wed, 21 Oct 2026 22:36:17 -0400
Message-Id: <179263657717.2549665.11401372071846447074.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 3858880005
X-Stat-Signature: mwf9gtsayzdmyys8uj37xmz14xago9rj
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792636581-187397
X-HE-Meta: U2FsdGVkX1/3eSgV+at0Q+QPb+dDWlCWGld3kwMjx07E92YDevgjAM153r1FCDsPYJXmVStbo4E3e4BJkFngzdz08o2fzYo1dUfusUlzozkDliafLgvbRa/5C5vgkMA57sElXsMtYncndskzk5EFJNKMnMafGyrIvEDP5dZci/Ou772/aaIgdKjVINcHLlh8lW09oivjduX8vWjM+uuD84UtxLz9Vx9YCUVogFiS1Qa9MUayqV7w56t/IWivuZoq2hqIiGRLElM16m5uR92S383N2oxeooT7/wDRqTxae6ppVgT8Y/RN9VFTFyzdAgtZFoF2gs86ZS8CZhmr7+QVNqFCzyRc1LofgVxblVlxhZws4GYSP7VzQodEsoVxKK2BTH4kaPD/nj5s9FvhqRrQ+nT+NSpWWBiGHAAKiiBSVa4Z6c4I0R5jZJPbb4q6DXuUYnI1Tfg56ZT69TIMwM0TjOXQP3NvR/HM/aejrAH0FgHnyhfIUOhFuVLvz8EoqPdOAKDScD6CyUg5ZPsa3k8Hx3A/uX3VqQW5HnD6AdxEDzRnZIYK9pDyWX96v/hjySS/+m1lj1Qyi11UvSk0uONZRIz5nPwmOfJa8isKqdtf6Q0lirMPi1ni4tpKI7rVBD1fN3Hmw9KuO6ZneAi3emFB670COCFKO2t7X303mJg4mtC6cV6SrHUTirXKkfIW1eSifRH77zZBGBT0sjTNaIl2PzCGNGletJnpI5DIw480sT2o1Fa5dSgG166yLjN/fyKcwrsLI9mywXSgYNH3SM7LOzd/90z8yw7VumP69jUqQiXFBSPCnqadYNfXe6TnPA575PaPpEeZmq072eWaZCilHl+bUVVreXyMsbhd5R9wsjdAHpcSnLetZWxX4gh8bKHaThz87BvZwsvr/idMmWSsuQ8YaY1+MNY08aExuWW+ilJDcSFv+Lhk2Q/uCmEjebDbwm9xq1LrFk3ozwLs6dg
 xLPdhmRI
 yGtzKKdTsqdY0Sg31kZXFb1erhUtGAKK4WIl+Z3l5I6fLdou6ILFUunlPSLdEUqZ3ug7MWEm/PAKV1JTig6W4IirTYHlszFRXhz/GXOTedlqtuvFYvxEo8xdm2smrOePS4nJl1ts7P24L6cAtw828AIqHPjuWl0ftmHiAKkn2D7cexxKYDMp3wqMM6kI80PVzBWdoByjZ9x5qsdrdV4+Y2vn7cfFMpwdbwijn49BGgTgG8XcMAsizm2rYXR9AepQL5g1RRodvHWzbXHn8n42wXQR/HI1JB2fkDqrFR7OvrE3yq49C3+9u6p3fLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-20 23:03 -0700, Nhat Pham wrote:
> B. Semi-synthetic Workloads (memhog, usemem, kernel build)
> ==========================================================
> 
> All values are mean +/- standard deviation across rounds.
> 
> Test system: x86_64, 52 cores, 64 GB swapfile for all 3 benchmarks.
> Swap backend: zswap (zstd) with the traditional active/inactive LRU. We
> focus on zswap here because it is the motivating use case for vswap.
>

I get that the motivation is zswap, but it would be nice to have
disk-swap performance numbers here as well right in the cover.

If only because...

> For each benchmark, we test 3 kernels:
> * Baseline: mm-unstable, no vswap patches.
> * VSS off: vswap series applied, vswap=off, to verify that there is no
>   regression to existing swap paths when we disable vswap.
> * VSS on: vswap series applied, vswap=on.
> 

If the numbers you presented carry through, I'm left wondering why this
is a boot option and not a build option.  I rather dislike the boot
option compromise in general - but other reasoning aside, if there's no
performance impact, then I don't see why it shouldn't be the default.

~Gregory

-- 
Gregory Price (Meta) <gourry@gourry.net>

