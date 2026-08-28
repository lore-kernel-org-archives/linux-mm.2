Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33212C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 03:15:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D62936B00A1; Thu, 27 Aug 2026 23:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3AD26B00A2; Thu, 27 Aug 2026 23:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A476B00A3; Thu, 27 Aug 2026 23:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9407D6B00A1
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 23:15:24 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1915D140166
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:15:24 +0000 (UTC)
X-FDA: 85149212568.11.B67DA06
Received: from mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	by imf31.hostedemail.com (Postfix) with ESMTP id EC40220006
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:15:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CNnl1uXM;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787886922;
	b=cAqEGji5rJLjUv+xq9veAIuTGMrlFA+TrYbpKAK5HxHIsabw7K6/EIESWeReKC7jF9eALS
	V5jeX5zO3U5hB/Pi8xCcPq/A0iLaIzjOu6oEqAVcy4w0pDZgQ/5Pl4ovnsoh3zLdrZD3wE
	sxd5rThGqgFFvefJ6/iIVm18nQE5s9c=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CNnl1uXM;
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787886922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xc9e2gndZmbk/JaHG3vXXFZRX22pRvxvJ4AK2q7KD/c=;
	b=YNFTuPvFto9e6Hy1GehWluxImg/X5B3IIGnIayDRmsQxZmCoCW9sjo3nTnGXCCrFYJbmQd
	FF8n5OQJP5HeeqanUnU0ZI9x4hCw8vgjCBltmikWLZjlol+cGMfUsMpJT+ScjBtBwOEjdu
	gAkiArEe+8n1P9ll9dmfqmWub7z0OwI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XOjaiGKjhheJ/kjCevTLOAsBuo3lmObElKlXBzQBRYA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787886920; v=1; x=1788491720;
 b=CNnl1uXM2Lfcc1PxX5SJy+Cg8Op4CQlCaBSwewc6DSKh1HHZkQmoWUeD43QInC2VFxR34F72
 F3FQxJ8//YRO9XoWrhei/9BS2jjJmzM0WdSgwPPyah/edgLe5BLWlnc/5GvFk5PQwxJlGSjuRpV
 Kma75/8SimqFFy1OizuRJFEc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 01ad734866bc36eb;
	Fri, 28 Aug 2026 03:15:20 +0000
X-Mizu-Trace-ID: 01ad734866bc36eb
X-Migadu-Flow: FLOW_OUT
Date: Fri, 28 Aug 2026 11:15:14 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com
Subject: Re: [PATCH 1/3] mm/mglru: improve readability of isolate_folios()
Message-ID: <apD9QqyFGRoGxyZA@fedora>
References: <20260820045603.68809-1-baohua@kernel.org>
 <20260820045603.68809-2-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260820045603.68809-2-baohua@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EC40220006
X-Stat-Signature: 3nbt45qbcin89yw9w5k8aiedaiies5cw
X-HE-Tag: 1787886921-382015
X-HE-Meta: U2FsdGVkX1+qbfqqVMzHBocPaEyAY4mkE4bg/jV50HhRaJGjP54Ao7q2fH1g6xNYNEaiBnzpjbTQb4ytXIR1xSCh8IyjOa56gIDbFzI4v1meLtXdXBElrHvjDNpQASrq41/KwUkky1o7fIedPwWiTDWZo5SsP/ZeO3bP0SL8UCorpXfkeuif+XAHc30VdSihJnLxTtzDr3//OxYw5Jf72tRR3saRQXM3WA+oprybIyNOAuT0eOw2Lb9zlHEF0UCSsA85CnxHnD+H3yvZ69IEyw0zBGqKDUSQf/nGTJOtebuyF3sDAqgTX0UecnlJaXLuzVlvAjGRbttXr9FHgmZMAnM+nbpmvtn3SGGZ8tew61uwiYcF+k/87WdBASkGvhcbQS93NRk1juCDd7AoKmcwv0kK3aasC1H6XaumLJ5ceuDuGsZttChqD56vhPNgtfUxQ8dIG7BH9JfOJ4mWa4F3TzaO5xkYKIQXaLsq8sAIjYBKNYfNbowutIsUU0ns34kM6CFZAnwj3uMbO+WE1+AhZjKNzonom745luUvPXVrfFI/kuQdMImGmhh1hSm4FStWDJDUoQMTC+nlFSnjxrwbFvkIZQAINGaXDCtdeeBXvKvpfsSfJ2hemYx4nkAjS0e5eger1xgz+4UxUUkx0hBzxuO8B/uUe13DAkgxX9AsYJSBthztEbPH9hr8wfoajNXxFqct3dEBc15qnqYj7Zi87XvwxetEVgbIi5APiz7AxkcT/MJa5BYCZ305dvf8Mo22FcbnIDJUqEQm8ujlpbPqdu88WmGDXGTA9AAvoFSbXMfGr1Atr1uV08Prln17np/Qzi5mt3AcsAS0kXn78kq/1Q1H5lFPeFVr7CEdxXIVzMsW+9fFjsaWdAX4PZ14BtSWGCqy+fisoFIUqLXLzUa8CQZex+GfIDPTcgjgiME22pHGbEWZcwsk1xFA4IK++gIJrlf8zS364MwKQaZa4CS
 g1DD6QTn
 A9kCwyoG9XXLDDA6p0+cAYugzL4MHPZOY5alHRaJVKuvoMawCIkGVcZXNbe6KclOs5a07p4akbOkHLYUfqEnRFNyXru/+kwqixFgC/Jm54FXrS5OdFkfzUyX60XAwy9otWc1VgobB1lbakr28C17brVb3biaQkS13odDbxUd2hd+x7qaRsxdbfHa3MsEOptGf+y3Y75UqS3iw4oQS4gZAwAT7EdK+DkLUXPbB6r07wFuF9CgGHG8Q7hUG38kGoqE69fsmPTaXDqyqKcluo/AlgNtK+OB89D+v7YsHAPHTVCEKGZnNhgkTL/3C2gJ0OQwlTultU4Rfxi8d9rFUS7eBUZU2WK8kaxYPwcQvyi/e0ntEfcRaWEn+AxHIkFXPoXk+BSYjIvknJN/+qF1C7Qkhp4gVbaFF6BJM98R9Ytxg6M7vuNntAA0/4iPcpWGDHebcjDJ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/20/26 at 12:56pm, Barry Song (Xiaomi) wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The for_each_evictable_type() loop in isolate_folios()
> is misleading: it does not actually iterate over each
> evictable type. Instead, get_type_to_scan() selects the
> type to scan, while the iterator `i` merely bounds the
> number of attempts.
> 
> Make the fallback behavior explicit in the code and remove the
> opaque for_each_evictable_type(i, swappiness).
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/vmscan.c | 46 ++++++++++++++++++++++++++--------------------
>  1 file changed, 26 insertions(+), 20 deletions(-)

The subject doens't reflect the truth. This patch changes the behaviour,
but not improve readability of isolate_folios() only.

I also noticed the confusion of isolate_folios() implementation, and made
a patch to only change the local variable and added code comment to
explain it in my local branch. Surely refactorying is also good.

+        * Scan at most one type per evictable type (anon/file), starting with
+        * the type get_type_to_scan() picked as statistically colder.
+        *
+        * After a scan:
+        *  - isolated > 0:  got folios, record the type and return.
+        *  - scanned == 0:  the type is empty; fall back to the other type.
+        *  - otherwise:     the type has folios but all were hot (or lost an
+        *                   isolate race); retry the same type rather than
+        *                   switch, so positive_ctrl_err()'s refault
+        *                   statistics stay unbiased.
+        */

While in Ridong's patch, the 3rd case disappeared. It doesn't rescan with
the original type as the old code is doing, but return directly. 


> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c1404a59523d..d5cc30b667ad 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4833,35 +4833,41 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
>  	return positive_ctrl_err(&sp, &pv);
>  }
>  
> +static inline bool is_single_type_reclaim(int swappiness)
> +{
> +	return swappiness == MIN_SWAPPINESS ||
> +	       swappiness == SWAPPINESS_ANON_ONLY;
> +}
> +
>  static int isolate_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  			  struct scan_control *sc, int swappiness,
>  			  struct list_head *list, int *isolated,
>  			  int *isolate_type, int *isolate_scanned)
>  {
> -	int i;
> -	int total_scanned = 0;
> +	bool type_fallback_allowed = !is_single_type_reclaim(swappiness);
>  	int type = get_type_to_scan(lruvec, swappiness);
> +	int total_scanned = 0, scanned, tier;
>  
> -	for_each_evictable_type(i, swappiness) {
> -		int scanned;
> -		int tier = get_tier_idx(lruvec, type);
> +retry:
> +	tier = get_tier_idx(lruvec, type);
> +	scanned = scan_folios(nr_to_scan, lruvec, sc,
> +			      type, tier, list, isolated);
>  
> -		scanned = scan_folios(nr_to_scan, lruvec, sc,
> -				      type, tier, list, isolated);
> +	total_scanned += scanned;
> +	if (*isolated) {
> +		*isolate_type = type;
> +		*isolate_scanned = scanned;
> +		return total_scanned;
> +	}
>  
> -		total_scanned += scanned;
> -		if (*isolated) {
> -			*isolate_type = type;
> -			*isolate_scanned = scanned;
> -			break;
> -		}
> -		/*
> -		 * If scanned > 0 and isolated == 0, avoid falling back to the
> -		 * other type, as this type remains sufficient. Falling back
> -		 * too readily can disrupt the positive_ctrl_err() bias.
> -		 */
> -		if (!scanned)
> -			type = !type;
> +	/*
> +	 * We are running out of the current reclaim type. Fall back to
> +	 * the other type if allowed.
> +	 */
> +	if (!scanned && type_fallback_allowed) {
> +		type = !type;
> +		type_fallback_allowed = false;
> +		goto retry;
>  	}
>  
>  	return total_scanned;
> -- 
> 2.34.1
> 

