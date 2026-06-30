Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 052DCC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2E3C6B00AB; Tue, 30 Jun 2026 12:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE1C6B00AC; Tue, 30 Jun 2026 12:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F47D6B00AD; Tue, 30 Jun 2026 12:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 712006B00AB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:34:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 010BE1C70A3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:34:52 +0000 (UTC)
X-FDA: 84937128066.13.C79A7B2
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id E290B180015
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:34:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tr65YEDr;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837291;
	b=T3fY9bV8sVvawFbSyAFtDNn6EWg7F1b7frsuUq/XpfxW4ExzvxDGrZK3OuG9XIK52XzdHL
	nbW/f9UOinuYU3XjjknZaGgwhQ+cy/sKYrlRituXxcER5WtIQyax2oZSYwtoYdPq07TVJJ
	fAmx493ZkBsUmAGngBAyRBU0qQPX2ok=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3vzLp53JrizIZ8vRPTNfFVJq97fTRHFgjl0sdoikIw=;
	b=iD6WP5u/uO8met2Xn8tCBG0aZf647ZZ8g40O06z/XOEai6qs9BxigFNkNMshiY/XtrHFLJ
	dul0AzkpsDjk+wgtpcTrffgCmsW5KXklIOnYSjHJDjTxVWFVq26SMOnYw15ykZJJzoKrN9
	A2cJoUclUIzJ/lc+uyZWA31VI2bN3N4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=tr65YEDr;
	spf=pass (imf16.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.170 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e53230b82so194275885a.2
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782837290; x=1783442090; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=F3vzLp53JrizIZ8vRPTNfFVJq97fTRHFgjl0sdoikIw=;
        b=tr65YEDrzDQjzXAHBwfF4HpoP2jr4EDBKbYmGD+oTJ82v65YXOiylKBmUYMewcLgX3
         68f6pO6n4A4WIxeoxqhdudKBoCjIrtw6WD7TyC6L/E8k3fY/MDD21hgTG+uzgSAVkbbo
         f3fa3GsVQq7pVHi1OaHdF8rKvOUVQm/H4MHVfDzBflp7eDoDL2DGhEG7gHWJr2J/4BR4
         KjimLCDM4Q0MT8wyvwzy1eDHHTYHWsA3pihD9BThiZwJcDOxaqycBD5G06twqsGmwGXF
         hY0Ayk7IbUNd0RYWDA/agFnj+BBepOzIgszYK7FRtSPd2ESjz8qdv/xfXBm0ceNkuCjn
         bL5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782837290; x=1783442090;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F3vzLp53JrizIZ8vRPTNfFVJq97fTRHFgjl0sdoikIw=;
        b=HYTE6LaGAS9xwl8AMLOzkn8ijpH9tuykED+HaurRGJXWBDWRslg0rFFRGMNZ2L5gsc
         HeBIJ6Hi/MA7EZxgHn0dl+IS3DMFjLEthuz4zsE38NW6J+BAWAmXOGQny4jP+NuLEjhV
         wHXVJ9P4JqwCiQIIR1KzhkJp900o0KeSDYnAdm0AuwHU0s1Wvggna953TK0h0uAMQS0e
         9YB51xS8gVbGDEXhUSHYr7ux6VJlk0S1LH/RtP2rHeftZraczyT4y/Bhx1UND5lOQwJq
         JRl1z17V239UBDODF7Hrz2LFw9+pIqR2qSHJBBwWbuOUZw5LKdA+dXbIYW+sww6PHQHg
         8jxA==
X-Forwarded-Encrypted: i=1; AFNElJ/7pfSfXHG+pIhyV0IEwviGXrTGy96qkg8TiEbb8W52rA7L09p91d0tj3ZYdyIdQpneYUZ/4W2w+g==@kvack.org
X-Gm-Message-State: AOJu0YxEB969uuh2gjaT/HDDYU3eScvmg7JiAeFFoQ6F3GdUalaoca2o
	mlPRzfDW5os8XW6B+VD6RPSbSCrEN6+i4pxqWPCsc+qsMXpzSdZbqYO3CMSfdjha3k0=
X-Gm-Gg: AfdE7ckcuHUkBST3tOD9/fO4AEdpR0uzz7B3P4/+ciN9XaoQvXxQmeMsrGwGFCaecGD
	CiYdhQ2swiihFPfXMO5pCKB2OvNMD1ERAHn9ociXEW467y3n5hOQHoMNiLB4t4EdglWVXhotZ46
	RaG6PZgIaW279cQ36b6p4Aw4YGUFx0ZM76uWod5vI9FbYf0VL+lqHFGFQj9H6mSpqbcKyZvVrao
	aB2ej7D5p/iejL4V1DXKecUQScUz124micFTsyi39ba+01KShrTsvW5Q6VZD+onZRDBLzMOL53X
	JH0/elcQApen0BSl2X9d7wqZzYHJ7xlkPAEr3TVXDRAFwWkXHEw96UCMCG/fi7cJzOLKpQ3MO7+
	rJ3OyTuAH5K8VdJS3nvILUfybWZ7KCm3Xr+yAPGogAXYQT/iaCAoA4nABm+QfS6AP3hAgnopKy3
	ang4guxVOXQJQ=
X-Received: by 2002:a05:620a:2b9b:b0:925:4655:a89b with SMTP id af79cd13be357-92e625f7147mr682887885a.27.1782837289779;
        Tue, 30 Jun 2026 09:34:49 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e6213bc41sm273914985a.6.2026.06.30.09.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 09:34:49 -0700 (PDT)
Date: Tue, 30 Jun 2026 12:34:48 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Baoquan He <baoquan.he@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 1/3] mm/swap: colocate page-cluster sysctl with swap
 readahead
Message-ID: <akPwKK22ahROxDqL@cmpxchg.org>
References: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-0-d4f648963382@gmail.com>
 <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-1-d4f648963382@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701-ch-swap-series-plus-folio-lru-cleanup-v6-1-d4f648963382@gmail.com>
X-Rspamd-Queue-Id: E290B180015
X-Stat-Signature: rzh9zem7uaw8kesd5xynn5pq6jjqy8fp
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782837290-213966
X-HE-Meta: U2FsdGVkX18EdaCuNkf7F3XS1wEsTON4AtWNlmzCh9V5yL30ZoK7bCsBywaBNKKqnHbN4MG9TL4d0DjKLEhT/w2PtRoy4QRq4vwaYJ09IS8lWexMwyqytkIeYCggR/ljJbyTlYhbguLSO1/EpSV6Ayo28ZVMG1rQ9ecu243zYodo8LHgwFTiVKtdNmCNkLjifb/GNDXzvdGPI9fta+YqtzRAPObC9TDlLX7knkAid8B7hCLqDuJqiL6Q5Z0nNB5ihNs9Wao/lgfxj+XDTGLDmDp3cFK80cKL0fof3OGjGUFLDDr9CZZs8rTFk2OhXdWrjT63xmYlT9h+7L9Z55GFUbtts6JvHfYBcoNmk4SkQdV9dtkwcrMcIgAuNz0EYbqVbWk3mdLD6EvSlQqfhtXDUFs6D9KWTOLQUqmNSHFozkq05sVEIGc3KbuYNWSijTVB+BXLcY+o8pbs99rXYD9su6vFvNo+6hxoSY6uucQrSQ9ev5/doGMS5kpNIsfy4cPGTLe2p4XlsbanKfSKxPOsciVHQ9invHv2cbwRPpSVs/ZoG4jxAYTozohdeBW0bZubcXNfOZ1m42Iin1Li1DaAZgfoaKXHWAVUdPqNxDHWDi9LGQM28e4VNOuOJEttaMropTzTPa5UiU6Dd4jqKjw1E+qvmB08WsvfXiTk6pRRe557CV7wpEtODN37uf2bks+CJxqr3v7f47aggXBAsaPXY/MAiDY4JhH0PHFQTsj0sZDkjKtMrDRSsZuku9O4qq9Vo1b1uPSspfw+4hzem6QzTEcFk67Y0B7+2ePc6e+ufhDI4DdMS/cfP8MAZ77Q2mmoyQmAvXQpd8ikalzZI4SuRAO6YMNO1UkPashLQ4WKLIfUhCOOFpNo+SDVQYq+Ch7RdoEEpq5lJMkyUhbyBRq15nrLFW9vSSsUz2EbfNJ5EzlJ3Skcp2ZZ3KmfsUShKRG+EdzhE6orMRGpUWWm4GR
 P7/mm6ur
 IRqwXP1abtWbNMjQwZMV6QpsHstlmRGd/SE0rvHIWQ9aGHzhV1K1U3QZ9naERRSaHRqWYYdo0TBS0L6AQ0vmDPYmxXRWUzbTCN3mt3W6bxM+NYfAf0LMQkZkSRHOTV49H6F+4fIjZYh9BED0wRnN2/Wy+AOnoL3Kjx41+dLDW2eSwvp6QMSMbROl8mJNswxiCwp2CC6LsxBxEv72hnbtenquoKW8J4eMh0lHtjwqPkZdidKxz11Cp+fEN700c1qTxH2x/QiLnl68oz4bra/9outhTiL/BDhHuckiQAUEr2+LVcMU+QenRa6gVlWtyv73TmGts8/yTeZGPO1CyqTbIPtJ/vIDrxAZ5FXirDrkVFT5d9ZNHs3oeA16UlWjI8zB0L+3PtuaqFhtGCjfs9psLo+pyUhZqQA6PKb6HWv2Ilp7NU7UvAQnlrP87y0zifpYqeT7h0gL7k5MHMPcHIqCcNfzXGboOc3+CCJlt30v37EHeDlD2JtDsAdWpFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 01, 2026 at 12:27:32AM +0800, Jianyue Wu wrote:
> page_cluster and the vm.page-cluster sysctl are only used by swap-in
> readahead in swap_state.c. Move them out of swap.c together with
> swap_readahead_setup(), and make page_cluster static to that file.
> 
> Rename swap_setup() while moving it as well. The helper is internal to
> MM and now only sets up swap readahead defaults and its sysctl hook, so
> the more specific name matches its reduced scope.
> 
> swap_setup() previously lived in mm/swap.c, which is built
> unconditionally, so the vm.page-cluster sysctl was registered also on
> CONFIG_SWAP=n kernels. swap_readahead_setup() is now a no-op stub when
> CONFIG_SWAP is disabled, so vm.page-cluster is no longer registered
> there. The knob only tunes swap-in readahead and had no effect without
> swap.
> 
> Suggested-by: Baoquan He <bhe@redhat.com>
> Suggested-by: Barry Song <baohua@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Btw, I suggested this:

https://lore.kernel.org/all/adUTC-7iyOAUlhR7@cmpxchg.org/

