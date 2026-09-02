Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6E14C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:58:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 86E0D6B009F; Wed,  2 Sep 2026 09:58:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F6EE6B00A4; Wed,  2 Sep 2026 09:58:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1436B00A6; Wed,  2 Sep 2026 09:58:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 306056B009F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:58:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9160E4021E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:58:53 +0000 (UTC)
X-FDA: 85168978146.04.0BD65F1
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf22.hostedemail.com (Postfix) with ESMTP id B21DDC000B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:58:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=B15K4Zqu;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788357531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97xe5JLv+NaFCNr+X5yBHso7S5p/kZD7Bjv4DEhoDWo=;
	b=VVtnBkWy/1M2mjuplPu0SY9z3EBME+IuUGksZnzdP/2FQ9jP7D8kKSHIiw/ZLuS0LNwQrd
	TFlJuopXRODlDRvF+SnbtG/aDVJKW5dIpb6cp3bu+McG/6li8Upi+QTeojmkLoSFTss3dl
	dq+htI09xXqm3ZgaO09GxG749cGshOE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788357531;
	b=CISnXCDRT+V+kepcNqrKW/3a+oNlQfLsA/sbREM/5owOa9/5WcG6ytuckneQUVAkEb014q
	3B7w05/ijU9bfBwddi+WfdCoGfpyDL5CM12hSAoZ8Jht809a9sfFHlFdl5ztAQ/oJ/bDJ8
	Ee2mnpPAi1tWpl0IBQOa4NWnsXF63lk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=B15K4Zqu;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.52 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-90e9ad1a373so15288046d6.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 06:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788357531; x=1788962331; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=97xe5JLv+NaFCNr+X5yBHso7S5p/kZD7Bjv4DEhoDWo=;
        b=B15K4Zquh6DvkBAR+CVWz68ayY47EE5u5+NeKqCNju0ppKKjPc0loNlM3rx2Y5IfG8
         frOxfshPGk0flbYnlLvtUEo4NxFgENPGegpNpmG7EDbCPF9rK9Y16f+2//8euut7S+G6
         nofIxp028dLXARpvJI+TD1X4nsbMqR2cCKMCQcz+cP4k8fuxt93KynRIJ/lD8v6MONy1
         04oJQJ4C8NemNFYkHxgFXsdJvs7/D2UBZq1wYJphtF7LclocDNzzhHEUF8IpgnONqqhX
         KrpmtduBSyx7pK8TemQezd6aZawog9QlwlezmqcjZRtfb8rJGonLYk/zK1t+4qsH4rvB
         +JhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788357531; x=1788962331;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=97xe5JLv+NaFCNr+X5yBHso7S5p/kZD7Bjv4DEhoDWo=;
        b=Q1lFjLnR+g5UY92+UuZIbs/VRltWT5pTOFZ3mpM5FCyMobtJr5LPetLlSzQCHEnxNr
         pPFhvhpWSjCMfDiDwa7KaiFkopaw4SSzmOj9ySEyI/jAZMXYvxIQlwpmrTu2/xj2z5Gl
         l8LpJsD1E7iy5PUeA6UlSV3Av3zxLBwCQvLlIp618FRGDgA5qtpjf4XBb6F7OfgfSpo3
         WbIz6CL8OOtErZaqqqyBHFZjxlAhzs5HXsZDUz2MHzZHz8SGvt3NDfm3kRFElxLdpgzB
         fRGOY7Wpv5l+4TUzoJkY76c4JRVPbJN4/l+q8TBZFDf0wtF++nswxXEqorKyQj+/kDfQ
         RtuQ==
X-Forwarded-Encrypted: i=1; AKwUvBzrHn/n3Cbn/ZSDaX9cN0Wn5us6Ivs6A/dLUBRlBo4Ssu+HXP8HBG2uXosNHZcPp0kx4v5NXx1XVQ==@kvack.org
X-Gm-Message-State: AFuF++lkMg6hWU88WiZMPZIQ0cpyWPS19k/4+xxJ6ftzVbQ2VYjb8Tir
	pE4MttVAJs/yiRkWwgcAaFo8WtPr31kTWzdgoC2hY34MdNWzOKjuuUpnLD7PimdxZK0=
X-Gm-Gg: AYBFou3DHKD/BR81sl1C/b3MWAGu71hmPkpbzom0FkYIP7tFMx2n+zOj3O7EpDrMBrc
	EGyn2piA2TBzwdi5PeXfz1Zxvqs8XyyLK/u8IuM3YJHnGrQWS1BQnjZUEby1pQSPVnTnnaN15ve
	pxtaC/Eca4YzfdO8niEFJFKKbMVu8/JjdxAvBx6/B+ZAESgp9dVL9sdDgyLxT/TQMwOatFA40zy
	2SXVhPgMvqk9LLBb8O/UN1snFpB/mw5p++0mEhXROnsYYeDsiS5pHG5RTMX5HCYzUEmLqqjr3m3
	VzI0Hj9GGaiLUXmtXQ0JkP1ayJdus+CP66X9fJneLQzDkd8adUtKWm6Qr5RdOZv5S73/cSmvEWt
	Bsa9UZ0PDsvEntdnMge5RFZTa35YKxcDbI+30m5A9GcnMorLrUP/+rJkfqW8WZ1dmsz5ndee+Ny
	vhVU60W4l2xKKizJXb2lZz0Yl7wS4Xq9Hf8zfBVdiQe3Vmr2Pb8Cjk6d0wWMbnDweKeJrl/n3Nr
	fbO0CKrkzLArqCLQaxaR0lxQ9CB4tDGhhEBhAS9NMkusEoQ8OTqLWo=
X-Received: by 2002:a05:6214:2628:b0:8e9:51b7:2d49 with SMTP id 6a1803df08f44-9102e9d92a2mr33434286d6.2.1788357530755;
        Wed, 02 Sep 2026 06:58:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90e9ee07983sm18656516d6.8.2026.09.02.06.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 06:58:50 -0700 (PDT)
Date: Wed, 2 Sep 2026 09:58:48 -0400
From: Gregory Price <gourry@gourry.net>
To: Liu Jing <liujing@cmss.chinamobile.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mempolicy: fix mod-by-zero in weighted_interleave_nid
Message-ID: <apgrXDZ_dOz2hRJ3@gourry-fedora-PF4VCD3F>
References: <20260902090346.16429-1-liujing@cmss.chinamobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902090346.16429-1-liujing@cmss.chinamobile.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B21DDC000B
X-Stat-Signature: d7qay1q69apweozbc9zxj37aws5hbe47
X-HE-Tag: 1788357531-46865
X-HE-Meta: U2FsdGVkX18nfvFH2+Wg18x34kKwu8xLwMnhNSxuty0l9ZmynkOVjQPPxUS1XQewxagaugoxrRI6Kk8FubGAYEy8CiAm2eWlltpwmkp2N4NymD3qavL/2ucW5SdrCAMO8FUQrmrtQNnncDtST66hOFKAwAfcGDqZQBoZmR61ZadiE++6zXABGuiK3eLRlDjD1CzuA6SnKiD4eJiauIWPVqUROeY79DEl0/9uQi3ZRCw/sB9oD6M+besHNGQkp1wWk/PUDZz6FMXxTTVRTgvUTsrZAojCb7tT2H1UVpnx+PztnaPFrgAic0NV2hbpKQ8HDCAQdiHz8xCOuz7t/YH/3Nd0o6R8sFsdoyeC3GpH0bKVEqU6UkcnAKJlGqg/7fCRHdYF/djur6X2vf8UY7VY5c4MXxsnzRjy3q4npo+Ae8Qf22BAtzfb/sRy/r6lknCMIx8p4+WEPUCmn3zTpjnXw3Qr58TZ5YU93U/uoiGB+22W/hS9uI35a/AqpaiqSTRDgzEJ+Mg1Ksi94b+jSgeR36VmEc5q8Vf9F/bus4QCLkqySNMWsU3eGCQD+5kRarkHFNXisLBKIAR2DE/gPLT4XQpIjBKdz+RBVJlnMH5hwsOVJgGVBTX4j0QVAsmsySuFri0qjsw90o7owtQLfUatbfiz0GsKns+0g2aIuxSN8VfuUdeNwlunsuuSTUuKD1opfDDjeGpZW8yBrOesL02Jdog9kGSL2vn2/YNmfenzKd2HYgmmFzfXrD/tawstn5QCcim/wTF05n/l1pLllnXIFJOCFYOMu2F+wWLqrYECgDBATA7PvpIPOYHlk2498Z1bGuMeigJ2kEP76WksAIgYpi1eXGMDAzni6IbIf5WZ5PlGv9N9GYw6QdlFESI8SvDIpH39SI8LBtJhxOXrouHvSvNlZYyhKP+dNZOmwju/yu0MzkJGfmXtS3Y+bL0OQJPR69Vo9GopQy4DQJWanIy
 cAyJk4Sq
 SOLw/AlFCAb/t6D8AjP6MXjt9k9D6vKY15MvfktvW7UnTp6r7NJFQuzgqNWzJWxbRFL/gZ5pjK6DL1eXXjcUvGMEU9wDJk66dX9uZi6fjNm6HVwUF8L50rXm7hj83TAOYRd9X6JSkYucvWEczKemaqwX6/sRUbeeA0RHBvk2gQMHEhJimp87cxA3tgNURzpi2VnW2gGIPxcpqc3yoCA/tEz3z1HTb/AiNVeL+MRKQ1OF+pFN56LDgJSwS7/F32wT6v7sV4jE35Qvnwiyp6VRoULXp0x7+CEbOJqNdh3xwwbXHV1i7easaDsbuviJfvN9zRLBrcY6pqyO0ITO8e8vBsvAJvlBAYq6GI6lC7SplGWDnMMz4cyIWJznLvSH9xB6BFzIE8zN0HE5PRytOibT3Lfn6t6IhmQy8JJiDQ5SEoGnkqKL9Tl8HZXMSTeBEfvBPnIYyixCBiS/tO5ounRS7zeqBp47slDzEr8xx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 05:03:46PM +0800, Liu Jing wrote:
> In weighted_interleave_nid(), if the iw_table contains all-zero
> weights for every node in the policy nodemask, weight_total sums to
> zero. The subsequent "ilx % weight_total" triggers a divide-by-zero
> panic.
> 

weights can't be zero and we just fixed the rebind race

if you're actually seeing this then there's a different bug to fix

> Add a zero check returning the current NUMA node id when the total
> weight is zero, consistent with the existing !nr_nodes guard.
> 
> Signed-off-by: Liu Jing <liujing@cmss.chinamobile.com>
> ---
>  mm/mempolicy.c | 4 ++++
>  1 file changed, 4 insertion(+), 0 deletion(-)
> 
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2218,6 +2218,10 @@
>  	/* calculate the total weight */
>  	for_each_node_mask(nid, nodemask)
>  		weight_total += table ? table[nid] : 1;
> +
> +
> +	if (!weight_total)
> +		return numa_node_id();
>  
>  	/* Calculate the node offset based on totals */
>  	target = ilx % weight_total;
> 
> --
> 2.43.0
> 
> 

