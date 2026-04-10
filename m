Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD869E99071
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4626B008A; Fri, 10 Apr 2026 06:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03EA56B008C; Fri, 10 Apr 2026 06:14:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E48676B0092; Fri, 10 Apr 2026 06:14:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CEA746B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:14:05 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C2CBC1CBE
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:14:05 +0000 (UTC)
X-FDA: 84642235650.29.1C4E552
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 33B1C120006
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:14:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=E1foYPMP;
	spf=pass (imf29.hostedemail.com: domain of mfleming@cloudflare.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mfleming@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775816043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dbaB09io7eIeSd/fBpSMtpWa8DN/qn+8fhizuMNJiYU=;
	b=IQD46Ags/XrNvvE3wWmV57hdYbIVaH5IqczevDI4OaICgp+JkQq8F6uRc60oXI6YVU9vY3
	ijFO3dF5NPfVbYFmLCHIiVDpdh3jAda/z0HPRTctfLPr9ah7ltU9iGfAruS0rfQi4KiFcd
	1bCXI8BotOxqkeZ4tO5tn9c/5Bp74Ps=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=E1foYPMP;
	spf=pass (imf29.hostedemail.com: domain of mfleming@cloudflare.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=mfleming@cloudflare.com;
	dmarc=pass (policy=reject) header.from=cloudflare.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775816043; a=rsa-sha256;
	cv=none;
	b=gRQODtpsuXb3c6TmaTbisFZLxiB8TorNbEOurnF+oyvFcMgp3PYDZJQAnDcXYKhUrnjhTx
	FdswUKCuL+AhS1WV58m+qow2+L/cnb2tT3dsqbzD6EcWxUybCYfeJg0AzNWRVdPVAaTygr
	nGSn2CecdOACpyiMxV88Boj7pn4wM+c=
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-43cf8fe9c2aso1202669f8f.2
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1775816041; x=1776420841; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dbaB09io7eIeSd/fBpSMtpWa8DN/qn+8fhizuMNJiYU=;
        b=E1foYPMPatrx3sLOAV5s9+LMtMql8IBJV4YaXNRnnx4HJk6YPWWXHodMz4BiTToahy
         8UfVnv+BLwXpkmk0UfeiBWbxRTtWDXmC1S3sBHz/l25CdEDYPOvA8JgBwjczCfy2d8+7
         JDkZsip3bNr4GWHl3g6+U0UUEA/wjfTo4lArqlrMCxW+wAFvWPHNT9iym72XHXDaXWtG
         /70CdwwsPTPqFcmE05Em8B+U4lLqB6JWmifSqFk5tBbGE7shtWFjL1IDdPXjFxYPINr7
         QOKsNznKTQaR7vWZDZdvsxaHXJrfQnBP95WoQ8rwziZDYPkfJjKBzNly6A1zhNeHoMc4
         UE2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775816041; x=1776420841;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dbaB09io7eIeSd/fBpSMtpWa8DN/qn+8fhizuMNJiYU=;
        b=tPSNhjBxUxwHY18CsPJPSG3WMpIRdR8XwVIEZeOIQcOnX5egbVD5P3oP7DDv6X6m7u
         6QygF2U0dOH8CVArUWE6OM2gqmifkllIb4BRydX9M/X680znmm1bRknIG1TovfdkMVbS
         VKZumkso5aa0m6zjw73iQc9rXhrcO94+R1PB1x8ExsV+uVwedW72ePa6CqQTSq3oGjcx
         Q8x0NxCnSRl/amXMJQeqpz7sQqlDXqavRscRros+yzJJXSiW0Ie2YDS4cxpZU1emdBBV
         PYjKMjxoLggiTsR6AV1SEIFOy1ttqmRVDKKnNNi+qgaU4jBBX8uIl/d119luI3EDBlzh
         Ru0A==
X-Forwarded-Encrypted: i=1; AJvYcCXHZ77MZIioR0PS+t0Tt08svC5uh1N2d2aGsJcqkDGRONFcQYw3kyi5lL8kBJoB0+xS3f9K7gcsbA==@kvack.org
X-Gm-Message-State: AOJu0Yy7yjX/O7+F70KdzK6Im6rfZG0YoRRNLlgAKJrGPwOkrj7b/Apq
	gcMyvlU2FO3+NzpzcTUvljRFxQUbSZF/QgEn+l7IKnO5lrgzNlj/KZQSRoauGY1KuIs=
X-Gm-Gg: AeBDieu9EDnpbfsbnkvlWTLNQQxWaS0QLNZ1Hht0t0oDTUkUjRGWTt/mpf+Ik0hXngt
	63QFy7RkvhcOp+JU3yrZL20bYgqYvtE8IId+uD57xyjvGGBhKlGzmd87aEgA1xcwQeoZNNLFn0s
	975qxcLoYhDZeVGg2UCAIuMuOe22m8jgplSl24HwZhFHjr0KUikA52VFh1QPKv451fBw9CbzBCE
	TVns8XyGXLyo8J1Vc00O+IT2rXLlgCcH8rFozZ3lBupGpEkVkoZ6ghcQrKGg7YvpTchcW8+jdke
	WBvaBfDbgooidPiZpvBf2JMeSSYAdbvWWpOvCdlX675IB34LvUN3CerZxiyX9ac641EI3/qGUQi
	Nv93mK0BCItgutNcwk7ogO/Bj+ui1dwZTQby+cPrslw9bgd6DyNY5/yzgOHxJbgyLB3BKKBNNy8
	9BKVrLCwCiuwLT
X-Received: by 2002:a05:6000:4287:b0:43d:2f68:2ecc with SMTP id ffacd0b85a97d-43d642552cbmr3681559f8f.1.1775816041337;
        Fri, 10 Apr 2026 03:14:01 -0700 (PDT)
Received: from localhost ([2a09:bac6:37a8:ebe::178:140])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43d63e46a85sm6294764f8f.24.2026.04.10.03.14.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Apr 2026 03:14:00 -0700 (PDT)
Date: Fri, 10 Apr 2026 11:13:59 +0100
From: Matt Fleming <mfleming@cloudflare.com>
To: Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, kernel-team@cloudflare.com, Johannes Weiner <hannes@cmpxchg.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Message-ID: <adjNOotXkgJLresL@matt-Precision-5490>
References: <20260303115358.1323188-1-matt@readmodwrite.com>
 <20260410094157.2895775-1-matt@readmodwrite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410094157.2895775-1-matt@readmodwrite.com>
X-Rspamd-Queue-Id: 33B1C120006
X-Stat-Signature: cmjkqkoyk8fpjum1a3uxfpnpxdqhbzec
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775816043-222051
X-HE-Meta: U2FsdGVkX19PXz0RSboqfOZ9wEd8DbBiIdZ4PlYlsN5njLoG5NoBRbUMH1st7BiD4AvSUxCA+hxuYKm9xov8eynerLKkSJMT5G3BIzpoBFutO3sY9+ZtgNM5pZXSWNqCnPVS/n3VMAq01txmYJS04ox5puS7ZQB/R73B2OPOxQnHDU3exb0zK9mlegeTQvoQ1WrOZkzTHOqyRxKn9kPk2KeaPL1wRgczNrjn6jL0RW820ApKzIq+/SFu07urCgHgcA1z5EQE6Wx18yyc2im1Fs/JUwLoTo1XuwUnzP6fs8ipKvz/s1JQ+AiT5sl1brMsQFNQoYkFZWVWhrRGh0ATECH+Nb16ZzyQbWinwDWuqz2rr4QXUdiVCib91Qi5x8aV2l77ah6ciiYT/8BloewocBp5IylrGo0wIThgy+Yqej7eo1ryhLdtcqoqHETeJR4ninftybB+KJDsepuFIuw+ULOxde11aETFZZEvEZIvwjoo2VW35n4t9Udwti6keoEY3YMbQBC8MzVWHRg3PDguOr49nRDpYFsxilyYGYVlnYad/A28+9RvbwNPPWWch3XOuFvsyLBM/zPHWuoLoUoD/MvxUl+WEucLZQ44gNg4tmJEdWmrjddaSJGuV2qpdPatodoaO3y3T7w7kJeih5BYA9Ggq5o/V3LvswvIO/emnO+2gqiTci4OXykhFhNCZtORrFdMEo3UngMgMTxvTbe5shn+JpTEwXSnaMJPn1oXvs4GE8+UsEM9RByACDttsOqrZd33jo1lfff0tZvVaKEVRBHD4rb/pex/07nz4sKPGq0XCyqMzBC2eWCJDORRQa6NSYARA4JFPLTIgz+Lg0XM1Uk0GVdy+pRU6vnHGTL/qU2L/OHamVdFl3q+zmzBtJY6S9pUtIITWiftXjpUxddV20fMJ/+8T5NUrQM85zzpeSE9OwWW2REXN8JpdLbgkqexgGlaQ/tuw+adc0YmMBh
 +Fmz7ILt
 LHLhuZ51S/50h7bLqM2Mj3Jd5iWqqHXUYed0E7FnFYpDiB8g3n5xwc8I/OpCk1fzoMnImjW0WjAgLyGp9Dn/FQ9/09ZynJJUPVAEGGCoBsYfioLermJNiRBZSzF5X735XJKLEY82FOgFbOy7RuUsIkaAVkVeBtUvTNL+gzoEQRig7TIXovLA+4QASFQnPOfJGcStj5mdWv8nbSBF0w8L8Scnu/868OBhPOdg9vf26Ic5dIghmRUCCqtXFiG78EkBKFFxJ9LCsR7pc95hfrngOIt4OAaqWtZSx8oXm0Vlc9nuWmvy5zZ8U+ySmfQuct0PU2JDY/P8RDySK6vEs9sHGRMq97WMzxpprRLUyrWoOAiYTcRyAHIL4EL230uwBKu8qUCF6ayNNFKhi4NKJNgU+z9XrqtxKh+1tqEHcSdAVLbY5yARu58a2IfYxnPW0Q8enxw9u7+92sp2fbvoap7azGa8diMysMF+O2CHgCbmtVgN1YHi4ZkrUEtIDKSoxMLZh2etUL3Zjstav4Cs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 10:41:56AM +0100, Matt Fleming wrote:
> From: Matt Fleming <mfleming@cloudflare.com>
> 
> should_reclaim_retry() uses zone_reclaimable_pages() to estimate whether
> retrying reclaim could eventually satisfy an allocation. It's possible
> for reclaim to make minimal or no progress on an LRU type despite having
> ample reclaimable pages, e.g. anonymous pages when the only swap is
> RAM-backed (zram). This can cause the reclaim path to loop indefinitely.
> 
> Track LRU reclaim progress (anon vs file) through a new struct
> reclaim_progress passed out of try_to_free_pages(), and only count a
> type's reclaimable pages if at least reclaim_progress_pct% was actually
> reclaimed in the last cycle.
> 
> The threshold is exposed as /proc/sys/vm/reclaim_progress_pct (default
> 1, range 0-100). Setting 0 disables the gate and restores the previous
> behaviour. Environments with only RAM-backed swap (zram) and small
> memory may need a higher value to prevent futile anon LRU churn from
> keeping the allocator spinning.
> 
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
> ---
>  include/linux/swap.h |  13 +++++-
>  mm/page_alloc.c      | 101 +++++++++++++++++++++++++++++++++++--------
>  mm/vmscan.c          |  72 ++++++++++++++++++++++--------
>  3 files changed, 146 insertions(+), 40 deletions(-)

Whoops, I fat-fingered this and sent it as a reply. I'll send it again
as a separate patch. My bad.

