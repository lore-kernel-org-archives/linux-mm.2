Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C48FCEF3718
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 08:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254726B0088; Mon,  9 Mar 2026 04:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2026B6B0089; Mon,  9 Mar 2026 04:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10DBE6B008A; Mon,  9 Mar 2026 04:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F24ED6B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:46:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97C161CCEF
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:46:27 +0000 (UTC)
X-FDA: 84525893214.13.1BCA6A8
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf04.hostedemail.com (Postfix) with ESMTP id C166440003
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:46:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773045985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ptm94RZa9ZVvrFRlGHO5+hvnjW1ygRaFselBj9OM2uc=;
	b=7YSV/HdN5dNm3y7id51LqMwtqV70eA0fifrAkq9gCX1S4tY8Ai0cBH29+ECYHyytEBHg85
	WksdNvpORtCdBePWgOLcNoC1Sc6KOID3HZUhBNpSjS00Hst+Y+H13OlMyamnGixkTnMYE8
	8Y9yiyYVbl9wd8ylplo0D/3y+r6ewnA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773045985; a=rsa-sha256;
	cv=none;
	b=aZ/q70s81vPcVu+nlKMsDI1zHFEnVDCralGJAfsy5DOu8zu8UTLjcwT9hya7y54Zeq76Le
	1om3S/dYFHTcjm0GPsyWbAgxPD05QOe6r9NwZM73LvKUgbFHqzIOCahbOTKkjKGsbWgSgy
	LiiT18rbtTtXV37PardfZ5u2EDUddgo=
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 9 Mar 2026 17:46:21 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 9 Mar 2026 17:46:21 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH v2 1/2] mm/swap: Add VM_WARN_ON to isolate_lock_cluster()
Message-ID: <aa6I3cZWNJdbGHDi@yjaykim-PowerEdge-T330>
References: <cover.1773040982.git.zhuhui@kylinos.cn>
 <25c1be6b4a54a69d4b57189fd84c7502c4412d7a.1773040982.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25c1be6b4a54a69d4b57189fd84c7502c4412d7a.1773040982.git.zhuhui@kylinos.cn>
X-Rspamd-Queue-Id: C166440003
X-Stat-Signature: kggtad6ha9muph5ufzub5sq44hzx4xf4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773045984-16249
X-HE-Meta: U2FsdGVkX1+xQ36reAdApR4O0gbJXbQMQO4u8aE3gyAd5h9QcRzYnrJ3ruZ1MWbCTiUTI4QddsQ3BouZyTqyZkqJouUJiFAlC0HTML7599qt840yRjkGbnxJX8xeGC3KBVjSQ9Sck55MXatgXwV0tbL08Rgl4RYxN36nEMQ9c6brzZw4gi7FADS4Mr4/bNyHEsRI9nK1j3sBx2hExgMORZo//qEgsrV7WijQjBAzOA2Ua7l4ucxXof3BHwLXQjB5gwYcYnzS/YwwAxg+mSVb01JYlB6A1wlna6/A5NU59p80bPBAhlELTYAI0JL02SWwe6BgxJBKaU7AVMMAPDoc2B0vYSFykW/Q9wffWOVvATp/DVNEEArKE2qQKegAn66afGG62X8wlja3yyuFzqFtazuYVvJywdKLKOiJLqet0lFc0Sl/ZAMmsL12l0OgmAPHuY94+q2He/K9KpPLMre9V410V7OT4JshcdmjVLhMBoz4tLjsxtl/6fK1hGrzRPeqFILPD0X8zKDW+HlQj1/SCOsIE2146p0J40uRQfRYmZUTsR4E8iB0ZIpB0Co+B5mnEX2Z7FDZpp9ph3lPFJp+YjOZjF10zMroblIaynumC0VgrwO2CyMftHdEozLLdWDPTsxwsi6Ld3X8oPekttswJOC8WA/BeoD+9y3IBUCrpvUa2F6wTxNH+LQG0XIyvY7bAYR1XJOYR/i5IDGtufEYkkueNIyXcNI8T0Swfte5MPOqo8pEP6A8JRudfH8XjtJ4kOS9DRUj7Zkpab5TciyUoaQrVzklidOdFuLuP9QrYwdhTqs4Sh4qskybky2CfFpOh7oJ/20XI8A33do974jCVoqO6uxMVendERDtW2IM8fRemBjEF2EPDRwXBta+s9IS50p04NUn8BUEcaXtDcC2f2rd+/g1HUfU0VS2yyrDqR8zwOuSsN1jKRpp8ZptsjORE6XZmZhwxOT+om4Tpl2
 2ZzB6fj4
 MgPfmtwgDFgwDEMCp9RAsInPPiPvtfaSjYTfRmqS1EfFOI9k+qhv99w/raWlbNyBsGjVOv8rhzXua4uLZoPj2cPFNfF4MXu0mgI1+9jNPpSj4hd28oSkRzaD2X7M5NNp9KfYNWCAgF/5JQ2JqS93wR8V5tqRH2nWoB0Hx0ukfqyp0WBmYfspnPjJ6qvgbcoCwa6WMB/HpNcUeaCJKK81hMHlUU+MKBSy1ylR+cuuonuk1w91p4jlr0MU6kDrwrVm4Fg9vQVgkXnEzDDE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 04:05:41PM +0800, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> swap_cluster_alloc_table() assumes that the caller holds the following
> locks:
> ci->lock
> percpu_swap_cluster.lock
> si->global_cluster_lock (required for non-SWP_SOLIDSTATE devices)
> 
> There are five call paths leading to swap_cluster_alloc_table():
> swap_alloc_hibernation_slot->cluster_alloc_swap_entry
> ->alloc_swap_scan_list->isolate_lock_cluster->swap_cluster_alloc_table
> 
> swap_alloc_slow->cluster_alloc_swap_entry->alloc_swap_scan_list
> ->isolate_lock_cluster->swap_cluster_alloc_table
> 
> swap_alloc_hibernation_slot->cluster_alloc_swap_entry
> ->swap_reclaim_full_clusters->isolate_lock_cluster
> ->swap_cluster_alloc_table
> 
> swap_alloc_slow->cluster_alloc_swap_entry->swap_reclaim_full_clusters
> ->isolate_lock_cluster->swap_cluster_alloc_table
> 
> swap_reclaim_work->swap_reclaim_full_clusters->isolate_lock_cluster
> ->swap_cluster_alloc_table
> 
> Other paths correctly acquire the necessary locks before calling
> swap_cluster_alloc_table().
> But swap_reclaim_work() doesn't need do that because
> swap_reclaim_full_clusters() just isolate si->full_clusters that
> the tables of it must be allocated.
> Then isolate_lock_cluster() that is called by
> swap_reclaim_full_clusters() will never call swap_cluster_alloc_table().
> 
> This patch add a VM_WARN_ON to warning if a fill cluster will be handle
> by swap_cluster_alloc_table()
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> ---
>  mm/swapfile.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 94af29d1de88..3fc2eb30c187 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -596,6 +596,9 @@ static struct swap_cluster_info *isolate_lock_cluster(
>  	spin_unlock(&si->lock);
>  
>  	if (found && !cluster_table_is_alloced(found)) {
> +		/* Table of full cluster must be allocated. */
> +		VM_WARN_ON(ci->flags == CLUSTER_FLAG_FULL);


As Kairui suggested,
Would a VM_WARN to check if `list == si->free_cluster` be good?
Or perhaps `ci->flags != CLUSTER_FLAG_FREE`?

This check only cares about CLUSTER_FLAG_FULL, so it might be better to
cover other flags except the free flag. 

Thanks! 
Youngjun Park

