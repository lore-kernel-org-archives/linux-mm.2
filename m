Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7BC3CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 02:56:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C8DE6B008A; Mon, 22 Jun 2026 22:56:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87A196B008C; Mon, 22 Jun 2026 22:56:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F2D6B0092; Mon, 22 Jun 2026 22:56:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6CE6B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 22:56:54 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C88581C21A2
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:56:53 +0000 (UTC)
X-FDA: 84909665106.17.38745C3
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0CCBBA0007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 02:56:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=thCksxOr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782183412;
	b=DVQreJ5jK0uyar3NTtUFX5iGGzxFGidyRtlJ10D/yCqvtmIuyqozmVNjlwex1DlTgWPMhD
	tu2VXPKk4Y1JdOROFbCblxsv5PSu7Wo1E/uMU9iImCeHIkGdMB8Qj13Zc0M30BE4kcdnL2
	e+QO1bemC/e2piEmkuXnoM+m3q6zEME=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782183412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gamJXZDJG5FoQ+0MRzknU1CG7VksU99okaa549Y0pGE=;
	b=vcjXfkDeq//gwQoXw8PRH91yhQLdKbXdioqT3jCO0a3oGKafgDIv5nRFpb+4mwbVKw3dzq
	zxh9iX9+7STZdBPWrKD2DN9W/AVYH4BjWX+/B2a1nbC5truJvZtkLTKp+29kRiz5J5Kets
	mj3gXPtcIEZnYnq/wjtRvQ/8qozI4IU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=thCksxOr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
Message-ID: <08f71d27-db8a-40d3-b906-28405f790e56@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782183409;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gamJXZDJG5FoQ+0MRzknU1CG7VksU99okaa549Y0pGE=;
	b=thCksxOrVcOVb8+PUQuVaNwG96PRajMNWiIzsT7m1Cc/eD1A4hXIZc4cqtegkrbEe2nIRE
	Z6L7GOJjZCL/Fj16FxaYfthJrd6nUSFj3xiCmnlpgfpFs1/V5nEhpWPc3qfhrpt/CoaBjR
	ZC4AIccBDvqnrhZ/NDhsEt7zjhQ0Ojo=
Date: Tue, 23 Jun 2026 10:56:14 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] mm: mglru: fix stale batch updates after memcg
 reparenting
To: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 harry@kernel.org, muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn,
 mhocko@kernel.org, roman.gushchin@linux.dev, ljs@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260623024237.45990-1-qi.zheng@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260623024237.45990-1-qi.zheng@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0CCBBA0007
X-Rspam-User: 
X-Stat-Signature: zzcw5qkazzr9hqkxcrim6ssc8rxyx9mb
X-HE-Tag: 1782183411-250616
X-HE-Meta: U2FsdGVkX1/h+Dqlmp2uD+F3x8/n3WMxazxpEqx27/Wlg5juwyeTxNCMi5/O6LtVtt5smCeqvG1CSVXeHZb4VWp0ITdMiPulaC7WVusckU01l7xqNeUaRmToB8tDpcZ1+XY+QGU81sQqFMARpPIDNcYCveyhCVY53zYDQ30W054vPoazU984+ZZm4Kh0VoJQFwNuIukr7XryNU+G+YGWYYNdv84jLnPv4e+i1C2X9FkIv0CjIaitnWBMgnuSJPRSNEeiNfDvxN/1Ii57Jv/HZ5jzue7wlPll+zL36OfgKhgxeDcbgGYpfdFPOec8/hu8t6NCh4dAX0smaCQf1UrjcE44EGhFiPH+bb6NTjh4PRjgTZvCyl/IxupRBkwED96PBiZoN2JL6EQ0X8tz4CZjWVG2Y+I6PXmR+o0auf2XNTOHCCEyE6It1Ks1NN1kD65W8FxWv1uuOWLSQD1zRmweVzwC2T/29lIeCxPlkhyC6ZspJ+xAo+crWFR2klSXgso4DufkQK2KJAjaw/RqB2Fei8My4J41xZB9QOScklroG8mK67XkytUW8tHkzp1fjyggh7C4V7Ap3wO4+nW1JnuZtZOJd5nJ8K9phcZ+lrh8N08NEck11QjGYZUFz36245xTB82+oqY20N7QaTDz2RumsXWI8XSRlbhUVljjTXQATFDmt98JPozhl1TG7WXaTVotqKHG1GjXY1xPDwZ8039ux3XLi1MQ2k0KQUKJWzLnhtdCtoS0YInj5kN48o6hGhTinxbl06wLeLonBcdJWSVCK8zmSvHuka6B9A1D8H+o8h7zuyfFmXprGuKdyykCSKAD+yPAYqneLzhahhubFGaMtO4mMvTrCVOqcrL51548dfTkXAhPbw1a4tXXaYHfGVslVQl/54PL5hefTY0pUA8jUzWf1aSWIjgX4EdHJgg1EMZ9bmRbHCT3UCukiAxG/afiYYongqzGFJXX8oVBQkh
 jYPlVZ0d
 u3NI0itfdH7JIWifRRBn9n6wYyOc5MwSdoNPATaf/P4el8luUbT2ilEZlEwyOYwHea4r2uIqhap0XpWV+Fs6KWpC/qaFsTee32LnDmPSbqUDfSUpDOzjJvreRhbl+audn2wvQ7GuGbduNkoX7beggQWMRdhzQiqulyxrH0nbMVKYNS6CvXHrDrcNJ+LMqUFTRS2GEYIqfArOrMu/zOqrj8PyasxyP0Z8i18lphL7lFPWQ3xMUYlcBFPnG45jOsGczOiIn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/23/26 10:42 AM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The mglru page table walker batches per-generation size deltas in
> walk->nr_pages while walking page tables without holding the lruvec lock.
> The reset_batch_size() later folds those deltas into walk->lruvec under
> the lruvec lock.
> 
> The page table walker can run concurrently with the memcg reparenting path
> as follows:
> 
> CPU0                           CPU1
> ====                           ====
> 
> walk_mm
> --> walk_page_range
>      --> update_batch_size
>          --> walk->nr_pages += delta
> 
>                                mem_cgroup_css_offline
>                                --> memcg_reparent_objcgs
>                                    --> lock lruvec
>                                        lru_gen_reparent_memcg
>                                        --> reparent child folios to parent
>                                        unlock lruvec
> 
>      lock lruvec
>      reset_batch_size
>      --> child lrugen->nr_pages += delta
> 
> This will trigger the following warning in lru_gen_exit_memcg():
> 
> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
> 				   sizeof(lruvec->lrugen.nr_pages)));
> 
> To fix it, add lrugen->reparented to remember the new owner of a
> reparented lruvec, and make reset_batch_size() charge pending deltas to
> that owner.
> 
> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---

Changes in v2:
  - update the commit message (pointed by Barry)
  - collect Reviewed-by

>   include/linux/mmzone.h |  4 ++++
>   mm/vmscan.c            | 43 +++++++++++++++++++++++++++++++++++-------
>   2 files changed, 40 insertions(+), 7 deletions(-)
> 

