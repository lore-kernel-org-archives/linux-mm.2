Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F167BC5DF66
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 01:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 413AD6B02D9; Thu, 13 Aug 2026 21:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A5016B05F0; Thu, 13 Aug 2026 21:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267B76B05F1; Thu, 13 Aug 2026 21:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E54246B02D9
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 21:46:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 556FE1602DD
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:46:47 +0000 (UTC)
X-FDA: 85098186054.05.64529DB
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A30440004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 01:46:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786672005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XDgS3ttL+IOQjEU5bZLeRMszZ892fR3c5yALzn6nddU=;
	b=VJ9srM/6WyIjGMNSvVhjrf9zMoVaCH3gZ/jjVXeFb6LzX7ecpwtUjcewE6lk6JxWIFEJcl
	+EAVg4d9jOxYpk7uYDXGSoWaE7zfXmu5Le3hBwndaaFCapMbUML0UKwE/lewbOl5NNGNzt
	RqPdVQwMSrQbS2EIbV167pq74Lo9m40=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786672005;
	b=SxYbls6dkwjNXsFZ2atpeCpLadm3EHvYoWntOpJutrYZG/bzm23wKiOroJ8ajRP9i380QP
	pMK7OLe8kzmTeCz7EbGLB+UclSeYMY3ETVYxLwsR101eLBZB8W5KqdM5zxpQmdMf+sbvFH
	/x2f7q6+Az0bUBODVyqRzggAxq1fAvk=
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
	by 156.147.23.51 with ESMTP; 14 Aug 2026 10:46:40 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.126 with ESMTP; 14 Aug 2026 10:46:40 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Fri, 14 Aug 2026 10:46:40 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Longlong Xia <xialonglong2025@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Longlong Xia <xialonglong@kylinos.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm/swap: publish cluster tables after full initialization
Message-ID: <an5zgOC0HpxZEzI3@yjaykim-PowerEdge-T330>
References: <20260813150316.2793642-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260813150316.2793642-1-xialonglong2025@163.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1A30440004
X-Stat-Signature: ewo9df1dw8idjzft5yc3gqwgaarufgqg
X-Rspam-User: 
X-HE-Tag: 1786672003-214579
X-HE-Meta: U2FsdGVkX1/j4KahUbkkNkN3QuSsjlNcANXIH/llw36CTyi4antWZWK7G8Xuus6JulPp5tpmr/JPw+x6iv9o/ErkV0eYyJr2hX+W4WZlJ/tVZL3Ywo9kb7pDarHYKEQbX6BlWnW6b2H4Dae4yikBj7MIPlMPrtvyp9OqP/I7mUNZ/dN/1zxKeFpZoLQq/4gQNwVsnjcmJ7Rix3jv1O4TCpwTcfFK2cY4TwjWVBuuuKl8cCBJqBp+zxP4adbQFml9KZZ8AnZ7NThM/3k9g5jylJo7q5g6DLSMjSKW2J3iYYqJYi6ON5TxNlb1+KBJOlQXIzvA4Qr+jsakPEVQtqDsKOW563Gcldhovg9hhh1jdtPytlnfBBOBDqdoCYyZnVpLd338l5x7+1pKLIuVEdLZMRZmRoA7bv0AfliV6ay1R7Oq2fdFcuqnVysnWliAfXQq2XpeDpEDFaytY55drZwDIJQEHKVYGdTEkQOPA95T/fR6e2TCFPdU/cD3J101rPob6nORCaUOCouiRqMfVOiwfDr+x/FeoeEkpguc/PIFtpAIJUhXhmcvsUsX2UcSvbJVDpwHtUwg+1x60mTjgtoYj1oPZ1gtWsDHVoKaMR6BzboOLoR1QWjcIH1glTsQYbPxvR3J4mfU5IrI443VQyFRwVI2fw75+ToGJm74SBmFiIhlmGZd6IfCum6shF0mYv6FUH/qIWmliNrgGw6PqOkKNE7pcGiNOK0TmP+IJD9RVnFyKWHwz9jdWxHDrTge3MgDyrs2PyALYTNGM3dnwUdBWRFAz1AAyt9FTGseRnGjSxX4+Y3Vo8teuKqxOJrR62rBama3naHp5wWtiGeC+Gart7rNtZJ/w4v4zy42Vs9r+UlSOU5xTqGep2yVBNAtYPNR9zRqKju0gsA/yM9/h7QAJgJHstjHBc7w6l2MYXwg4qzzsYcmz9+vnAu1DszDb6qamNv7I7a+If586bM49xh
 5yefcsCF
 Z75eumxD+GhjOWOtYjYCEZxze7fh/Lx2AJl330uqdoFqeu66T/tA/R9ie+0C1bePN2Z5Nb7r4YJL4guKvsQL++pjJ81bLx+fpFto9gzNh1fg3zo8GR2XurvckyBFyjZozQt+JMhOOGWB2qcGBiXqHv7GhgPXR31TdDdScbQ79I4DTnaMxGJC4N2GaECu9T6T0x0A4mbrs3IfAZUL6xlceo58MgwGHoGLYnBkbNSJlGfKyX50=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 11:03:16PM +0800, Longlong Xia wrote:

+Cc: Kemeng Shi <shikemeng@huaweicloud.com>

Hello Longlong Xia

> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> swap_cluster_populate() drops the local, global, and cluster locks
> before its sleeping allocation.  The allocation helper publishes ci->table
> before allocating the memcg table and, on some 32-bit configurations, the
> zero bitmap.
> 
> A stale per-CPU or global cluster cursor can reach the isolated cluster in
> that window.  Since CLUSTER_FLAG_NONE and a non-NULL table make the cluster
> appear usable, it can allocate a slot without the auxiliary state.  An
> auxiliary allocation failure can then tear down a table which is already in
> use.

I think this issue is addressed in Kemeng Shi's patch, which provides a
detailed reproduce scenario.
https://lore.kernel.org/linux-mm/20260720071342.50742-2-shikemeng@huaweicloud.com/

In short, referencing the table while auxiliary table allocation fails can
lead to a panic or something due to a NULL pointer dereference. That patch only fixed
the populate code rather than the entire allocation path.

However, as I mentioned in my previous review.
https://lore.kernel.org/linux-mm/al7WTNXanPVSELAH@yjaykim-PowerEdge-T330/
I suggested making it visible only when the ci->table installation succeeds,
even in the CLUSTER_FLAG_NONE case. If we do this, seeing the table in the
CLUSTER_FLAG_NONE case would not trigger the auxiliary allocation teardown
mentioned in the problem description.

> Allocate the complete set of tables into a private carrier.  Install the
> auxiliary pointers and publish the main table only while holding ci->lock;
> the slow path does this after reacquiring all allocator locks.  Allocation
> failures now free only unpublished resources.
> 
> Fixes: b197d41462c2 ("mm/memcg, swap: store cgroup id in cluster table directly")
> Cc: stable@vger.kernel.org

I see this commit is included in v7.2-rc1:
$ git describe --contains b197d41462c2
v7.2-rc1\~94^2\~147

Since it's in v7.2-rc1, is `Cc: stable@vger.kernel.org` necessary?

> @@ -788,6 +849,7 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
>  				       struct swap_cluster_info *cluster_info,
>  				       unsigned int offset, bool mask)
>  {
> +	struct swap_cluster_tables tables = {};
>  	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
>  	unsigned long idx = offset / SWAPFILE_CLUSTER;
>  	struct swap_cluster_info *ci;
> @@ -812,9 +874,14 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
>  
>  	ci = cluster_info + idx;
>  	/* Need to allocate swap table first for initial bad slot marking. */
> -	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
> -		return -ENOMEM;
> +	if (!ci->count) {
> +		ret = swap_cluster_tables_alloc(&tables, GFP_KERNEL);
> +		if (ret)
> +			return ret;
> +	}
>  	spin_lock(&ci->lock);
> +	if (tables.table)
> +		swap_cluster_tables_install(ci, &tables);
>  	/* Check for duplicated bad swap slots. */
>  	if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) != SWP_TB_NULL) {

As discussed before, this routine is set up before the swap device becomes
visible, so it doesn't actually benefit from this fix (although it inevitably
needs to be modified to align with the current direction).

Overall, I prefer the direction I suggested in my previous review. (If my assumtion is right)
https://lore.kernel.org/linux-mm/al7WTNXanPVSELAH@yjaykim-PowerEdge-T330/
or Kemeng's current suggestion.

(+ Also, if this needs to go into the 7.2 hotfix, Kemeng Shi or Longlong Xia
can submit it. Also, I can help to submit it based on my reviewed direction 
with both of your tags included.)

Thanks
Youngjun

