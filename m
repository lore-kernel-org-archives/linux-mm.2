Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8C99CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 06:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B12B6B008A; Thu,  8 Oct 2026 02:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 862136B008C; Thu,  8 Oct 2026 02:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756B36B0092; Thu,  8 Oct 2026 02:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 515626B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:52:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C621AA04D9
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:52:44 +0000 (UTC)
X-FDA: 85298541048.20.4228FCA
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf17.hostedemail.com (Postfix) with ESMTP id F0A3040009
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:52:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TXWhngC8;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791442363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFlD45V+rHQdBusfn6VlwYaqiad05DvAgkXkaaZjCzQ=;
	b=8qHsJ+rgSqlvtQXMHHh1tFZkWF9IUaD0HCfhdk5vj5YqQJSOJ9779SjsptaIn302r0gEqU
	dzLKEqtV2aMRSlk3Y0uwtB4Hhw9r8QZKqsxNgcaqIo6bu0e41YJAv2KCjW0TK9z56yh91v
	eaLgk62XTPMi3w0CAXDiy5OqPqbB4Vc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TXWhngC8;
	spf=pass (imf17.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791442363;
	b=xnPp7OZ/58c5lnKgwCBLjVxG2h1d/8j5on1E06DNuGaSIb9TsdFojCuVx+s8amyJRNMNuM
	z3w0bRO+VR95FiGaXHy/NCd2yggwT3lTDQkB1HBrMw2ECjkx+dsZjYn42h3QKAgkz50OV0
	uizN2SDMweRCa+MKFlDKBifSnwJsnbo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1791442358; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=KFlD45V+rHQdBusfn6VlwYaqiad05DvAgkXkaaZjCzQ=;
	b=TXWhngC87E6PriZ+nnVspkwLG2D4XUshjw0Eq6G68fwqxVyhpqsLHdsblVKHReyBL+1S1VL8+NcGMyJepHR0cFjNVwtNCncU0biqR71B9g2+LTfVRd6Ezt2yHPFpfPywHC7CcC5Ckdvu8byqKVnsl3DXbb4uWLmX5u7ZGp4tczs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XCLlNM9_1791442356;
Received: from 30.74.144.149(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XCLlNM9_1791442356 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 08 Oct 2026 14:52:36 +0800
Message-ID: <088f991f-429f-49e0-be11-548a77e8d44e@linux.alibaba.com>
Date: Thu, 8 Oct 2026 14:52:35 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/mglru: Avoid reclaiming kept folios during
 retrying missed rotated folios
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu.xie@google.com,
 weixugc@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 Yu Zhao <yuzhao@google.com>, Bo Zhang <zhangbo56@xiaomi.com>
References: <20261003054216.9155-1-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261003054216.9155-1-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F0A3040009
X-Rspam-User: 
X-Stat-Signature: tfbu5cjyrckmcr1d3sit83w8e93i8a76
X-HE-Tag: 1791442360-844619
X-HE-Meta: U2FsdGVkX19X2R2HISzzADwt9fPmfciUL/EpPjguGi3ZN7W4mifjELdT6DKVrlTjtumBwhaxg8dIOVbjymH6NhMLTcl6YRaSRXWTO9sPMI1AxziE3LyGlKFAvJMJgP13xt05KL9+gJ1IxdUfTkEIZxJRYl39lNq4UUVAwNNFXfOl9poepDiRz/6Jhc3Y1zn3HXCJv3Oa1ZNpfLau0WawDeYgSAM0m6Wxo8+HnNFpoeYxd9kAn5c2L51cxSHQHih/bYpU1a8vm8g37cDMHusyU42b0jGXRyE8ogqF0DrL+VGdG5YmZ1vpQ/l7L+6749VsQm9cBjNzfM5+YKRklP6kll2WnbSBNqPWskcjUmpL41vcPj/+Q9RpULIxjH1QdciBzwUchP05TG09ZRDK5Q5aiyEOU2jxHkS0Unfv+BnWl9+EuwTw1z2kuemFN4lRkWsxNZcC14u/P50heOubwQcMAUUgH5/yJGMWX4EcAA8PGWX8Ekhs0R8XGoc92Zu2H2eqjU4Cnc+7szxYrCUeZhiwGq6GniiNLdgPNJjWK4OJc3pkUtJ4hHWYiDYVuWnSiZRQw/HYY5+UDCVESN2pGeays0qPMrFNybInENqhmOXF76/AZGyY+LV71ZswOVBQBvIiEKph9zJ1Kg+4Kbjf9e570GSvEjh+BPbPXBXE5CeoGeET+/a60w8cLK9OLtBtwwQ3AQQAsPFGgqEPmR8k/JIOzB9GvZL4loECGYhRfMESPARcZCc0DUoeMhkjaqCUAE8EDRPS5AcHFnAx8NRk1fBg11Kpy9nlUMj+w5pYGeY8PJGknWNntb0nuRAlXADwpWEezzVcqjl+FBdpRYJDsLfj+h/6yqgXid+MZ5bH0CmyJyx+K2HwBmiOtlWzzIubfagepBxXhcn3mmeVOZwD38mVXNpLTIPtdQ2k1eUJ8chgUGBhjy4Sdi6i2naH6UsPp/z4qfNp6gOSFIOuVEBHNcw
 kNBiKIXW
 js0Wlw3BNSMG+bZlnZcboO5z6Lls4PK7eVkLpaWIrEAKlqNcYFHlwbchdKWs2nFs8XarU9dspwK/+lhzUAMgnMT9BFcjQUbXuSmCayqdjBDbJmO4eipdAsh3YV8Jx4FRUuVhs5Dk8q3EV7BnlpcuCz8g7Xm/Eo9zjIb3TLCLC5yvEr8H0LrEenXnKPeRdYM9cUoc+RHu4EvjPHZ12fW041YFb0MYHFnRqrYsj1Lsn4keaYqjqQp2EgbFX8VUPbsyI7V2qm4JnBchR81ZzijiJovU1BjzjGwVXje3GN8rz1/izTumvNVFrBHkYUPOIzoD2bQEAyWXKsTlWan4c13shV+qoWg+sS8Jar9zoUQJbyOb+f7cw1A8CtNSgAfBcXjIdJXEs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Barry,

On 10/3/26 1:42 PM, Barry Song (Xiaomi) wrote:
> Since commit 4d5d14a01e2c ("mm/mglru: rework workingset protection"),
> `folio_test_referenced()` was accidentally removed when checking for
> missed rotated folios. As a result, kept folios without an active set
> could be added to the retry list and eventually reclaimed.
> 
> The impact should be very small, as we have the `folio_mapped(folio)`
> check before retrying. Kept folios won't have `try_to_unmap()` called,
> so this is really only applicable to folios that are unmapped by users
> after `folio_referenced()` has been called.
> 
> I'm not sure if anyone else has seen any issues with this. Sending an
> RFC to check whether it is worth fixing.
> 
> Fixes: 4d5d14a01e2c ("mm/mglru: rework workingset protection")
> Cc: Yu Zhao <yuzhao@google.com>
> Reported-by: Bo Zhang <zhangbo56@xiaomi.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/vmscan.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 91295070ca33..6a931b576b7d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -994,8 +994,10 @@ static enum folio_references folio_check_references(struct folio *folio,
>   		return FOLIOREF_KEEP;
>   
>   	if (lru_gen_enabled() && !lru_gen_switching()) {
> -		if (!referenced_ptes)
> +		if (!referenced_ptes) {
> +			folio_clear_referenced(folio);
>   			return FOLIOREF_RECLAIM;
> +		}

I've also been investigating the issue of referenced folios being 
reclaimed recently. The background is that classical LRU will return 
FOLIOREF_KEEP for folios accessed once via page table, giving the 
accessed folio another chance.

However, for MGLRU, if the folio's pagetable access has already been 
consumed by aging or lru_gen_look_around(), referenced_ptes may be 0 at 
that point, leading to reclaiming folios that were accessed via page 
table, which could cause more refaults (I don't have data yet).

But it's not easy to maintain logic consistent with classical LRU, 
because we cannot distinguish whether this one access count comes from 
page table or file descriptors (for anonymous pages, it can be 
distinguished). I'm not sure if Kairui's MGLRU-FG patchset helps with 
this case (I haven't looked at it carefully yet).

Perhaps at least for anonymous pages, if the referenced flag is set, we 
should return FOLIOREF_KEEP to give it another scan chance.

>   		return lru_gen_set_refs(folio, &vma_flags) ? FOLIOREF_ACTIVATE : FOLIOREF_KEEP;
>   	}
> @@ -5110,7 +5112,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   			continue;
>   
>   		/* retry folios that may have missed folio_rotate_reclaimable() */
> -		if (!skip_retry && !folio_test_active(folio) && !folio_mapped(folio) &&
> +		if (!skip_retry && !folio_test_active(folio) &&
> +		    !folio_test_referenced(folio) && !folio_mapped(folio) &&

This part makes sense to me.

>   		    !folio_test_dirty(folio) && !folio_test_writeback(folio)) {
>   			list_move(&folio->lru, &clean);
>   			continue;


