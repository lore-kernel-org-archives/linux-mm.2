Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA241C624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC1636B00A2; Thu,  3 Sep 2026 06:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D71A26B00A3; Thu,  3 Sep 2026 06:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF2D6B00A6; Thu,  3 Sep 2026 06:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A85E46B00A2
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:06:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 43DF5404AF
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:06:27 +0000 (UTC)
X-FDA: 85172021214.01.563A184
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf06.hostedemail.com (Postfix) with ESMTP id 49C8318000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:06:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="qWIYn/nS";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788429985;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fpdjgc9+sv9jCsQkNtcRXnZevnJDV+QJt0b62KNfz6w=;
	b=QRhLlkPs+ycjiTePpTiGVjwVBer0bppGv/68cjaWQGV78cSRqtG0cR45yUT01TfGZbPSPV
	ImEjnr78ez/Me0dB+bKyl+o1s6LOcC60tNxa4p8acCNGZdHRo/yfa/+dNLA6uGsmlluTH4
	dlUZnypdtw3ZapeLaPB6sizYvJvGm78=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788429985;
	b=ZbrUn/eNMVNkRRiDl+fZiBa5Cc3912KJ0wUDL+l9DYky7QqfEoUfWljqi251/q3NTdcec/
	wmEIKgl14unQ3RNW7qVMQ+my02k/RIkN1Lu5smR1lXoBhM4Gk6ALIB5uEW+Biuy+Vb5GkH
	Jrb7/qE4eutNfagqnmbUUSYMOvWeyuM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="qWIYn/nS";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788429981; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Fpdjgc9+sv9jCsQkNtcRXnZevnJDV+QJt0b62KNfz6w=;
	b=qWIYn/nSw24ADrsALaLu1xdMefXQXbtLaTqnMldJ8cWzz3xMYJw5Np8ForgqKp4xsXspue+VXnSnO6hkD05VbRvA5ll/UPrURShyWO2LABuufCUQjHevPVzPxhIwz5WLHmrm0papWkx211BLlv1tRQKTHaO2T9QySUeeM3MYMuk=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XAFjTM5_1788429979;
Received: from 30.74.144.116(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XAFjTM5_1788429979 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 03 Sep 2026 18:06:19 +0800
Message-ID: <ac1f4e9a-d45a-433c-b26a-23fd0d955243@linux.alibaba.com>
Date: Thu, 3 Sep 2026 18:06:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] mm/mglru: batch update lrugen->nr_pages in
 inc_min_seq()
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baoquan.he@linux.dev, chenridong@xiaomi.com,
 david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
 lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, stevensd@chromium.org, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 Xueyuan Chen <xueyuan.chen21@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>
References: <20260901232421.40157-1-baohua@kernel.org>
 <20260901232421.40157-3-baohua@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260901232421.40157-3-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 49C8318000A
X-Stat-Signature: 866d9uh9ufz9nytybgdsmdh61i19ib1g
X-Rspam-User: 
X-HE-Tag: 1788429983-567857
X-HE-Meta: U2FsdGVkX1/n/7dYp1EnaRaMQkb7qN2eJencLgZwiF0zvWaDoPMeZpnquokVzqhXvz270SM6RYw8YGM8Gpl/DHq8uTT94V/8Ul/FDgWDyXEculRnfSIeGj/zqxgukITerbMayCqESCTQHMltr0hYSqw0+hecQigwRYhrcDJsd9AecHiN33TF7FTlOrNVmhW8o2ah5YmbHot0MxTEUaXNvlWzEGq7qS1HHbKT4KI5o00aEKzHsqi9iV+/7F3b9tazqlpbW005on6BgcWrwvKmkclbcJUvIbiOLLaTUVtmbllutO3G2om/Ep2xtTdUXNPkZVGhjGBQNTdukvTkwHFaqTq1Sylqs3H30Haor9jp+Z8XI4oGdhDCLvvaVZBndlIdUYWE1XcYG+N/cLyCNT7izo6p3sRLgl2e0oQnPCJeYdDGCSslTqKEnvzdq3awdgwnIyY6yDvSSW8Q3UGU6R9YmVith1mkVYM2A/fuA4OYNhpm0BfsM5V45SJHRP7+34uji1MVJ4jTyQbSx9sbK+IqYmzVR0FuYs1Hpeaw/BaTWAgRDVUDlcRZw6iyhTQSlzxg27AJclI0yT+Vuq8nr9T+jsM+At5Mn3q7f4+YzCgqxTMdn4HXnkIYL/A9SCA5MsGB+cgeIH68TbaTrxDIpiEq1u/A0oR1BqTstZP/n+UdlPk4wcOv2y+E3AoyHbsotpj+aXTFizkNOF5smwoO/U1Y7YET+cZbU3eh3c6jZkVpsRBiV0rjG2x/8dsxIRrBu/18UadMbnXyohXbzuFI9h51js0Wj4xfTRrItlscpoxCqNfa5pdcRWg6JE1I5UJImfSMl/xVh+uq/JSvrdj4gPRx7h2WDUMbww1UyherRWruNgDJ4JJT429NVnzabNdy7IU8M9srkFgEFLrVNas/DAT0AE56194lu7X6zwcTKA+Mj9phXEiSHEBB/Ub0Ax5W6mm4tBLcm71CP7yXATGUcOY
 StRWCOzd
 2rHWEG1CJuEapy4Hxrm8YIXpwX5IR3WiWI+B5ORYESTSBgVk763w4qc3ct1TOOYn7qeu73gVMg8dBlIDXMPH6YIqgJavpO6a4Fl+m40V2t9uQVVJy73rJoMI1jsr/MGjCjnVHsJLRgmrJW+1ccn+ScYuAp1qP0qXtuZ9b7yvsfetZ9T+bWm9340x1HFSFuHFh0ZqBiBwhg5/auDc7BzP7kEX4HTyDta2+HFUO7YQGZ8bmpF0kmERQV0t1DAgI7ARn7x1oh8ghtV/GOED4RASrK5xqNwNpyB1lD/F9R/na3+idCSiz7K8tt7rXzpgVH+i+cH1QvHImMGY/FSpxyUQ5eBQuIgK2mF0i0WF16Gi7lE+xTR5dfELmkS47hR8g9uSh3trSftIexJeIKZxQhAZkIBIZ/rjhYS5DBbMb0ykGR1dy8fDA/mvswNRobbX8z/E+DCMlns4D6OKmb7p79VDMhOm6KA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 7:24 AM, Barry Song (Xiaomi) wrote:
> Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
> as it advances generations. Instead, accumulate the size changes
> and update lrugen->nr_pages in a batch after scanning the entire
> oldest generation, or when the scan stops because remaining reaches
> zero.
> 
> Since we only move folios from the oldest generation to the second
> oldest generation, the active/inactive state cannot change. We can
> therefore skip __lru_update_size().

Make sense to me.

> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> ---

LGTM. One nit follows.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/vmscan.c | 23 ++++++++++++++++++-----
>   1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 54bce2f608ef..27494505cecc 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3918,6 +3918,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
>   	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> +	int target_gen = (old_gen + 1) % MAX_NR_GENS;
>   
>   	/* For file type, skip the check if swappiness is anon only */
>   	if (type && (swappiness == SWAPPINESS_ANON_ONLY))
> @@ -3927,35 +3928,47 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>   	if (!type && !swappiness)
>   		goto done;
>   
> +	VM_WARN_ON_ONCE(get_nr_gens(lruvec, type) != MAX_NR_GENS);
> +	VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) !=
> +			lru_gen_is_active(lruvec, target_gen));
>   	/* prevent cold/hot inversion if the type is evictable */
>   	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>   		struct list_head *head = &lrugen->folios[old_gen][type][zone];
> +		long delta = 0;
>   
>   		while (!list_empty(head)) {
>   			struct folio *folio = lru_to_folio(head);
> +			long nr_pages = folio_nr_pages(folio);
>   			int refs = folio_lru_refs(folio);
>   			bool workingset = folio_test_workingset(folio);
> +			bool gen_increased;
>   
>   			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
>   			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
>   			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
>   			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
>   
> -			new_gen = folio_inc_gen(lruvec, folio);
> +			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);

IMO, it's better to add some comments to describe why we don't need to 
call __lru_update_size(), in case someone thinks this needs to be fixed 
in the future. :)

