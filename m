Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 409CCC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:53:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EDD16B0088; Wed,  2 Sep 2026 02:53:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097286B008A; Wed,  2 Sep 2026 02:53:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEE636B009B; Wed,  2 Sep 2026 02:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2AEA6B0088
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:53:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC56A16072F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:53:39 +0000 (UTC)
X-FDA: 85167906558.27.EBF8CDD
Received: from mta0.migadu.com (out-107.mta0.migadu.com [91.218.175.107])
	by imf07.hostedemail.com (Postfix) with ESMTP id AC1FB40003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:53:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lKPVmQO/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788332018;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SUBfL1ObXDhSp1KNjEF890h/cSfAgTxJtP9rG3uHEJE=;
	b=JcfVJ5cxxBgHv9ZsL6q9ZA3d9eu5T082IOzFoXYMwgOdJH+yKlg4be4zfmCUac1UDhrVpG
	XDs5TR94htQecFJVyboG9IsIUB/6ulAWKjmjcP4Dc3LnzmoFh4UGoRbjVO2QxLr3kQHD8W
	HFZcJUTpIOupW2voXk+ECNTRuNFUS88=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lKPVmQO/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788332018;
	b=hzzAqVwj3VNMuQ/1QNOxIsHjPk/yWotqHMYom/SdhjZIpYefrsf7Xhg1WWfl5mtc5+mcG5
	xOnmhEKTHIWSz+zyKMqPtnBYnnDdoi3b4wxqZyaBmWN6cnAlgNJaiIiGaumrkWBJKDrNR7
	E4xZZmDk48dhFeg1dOeyJt59bUzuAtU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uI99S26D5TZQ1wv4WgExHkjMpzPeg6mRBSMTMpU+XFU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788332016; v=1; x=1788936816;
 b=lKPVmQO/3ym5FxmjPM5ELyGfSlehMcgEUMSAhLDnTW52iV+dwyIVyPAkLFfdhZnORwZOmZiC
 EPHZh+S1x21SSbvYOttxb/ZSnxf5x3eO8m/3qhxLkimPK7MICMYD4MmCKmOqSr6K3pr4vm3bfZE
 6Q7XlldwUueVkeAzB6nsZZCg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6addee44da3240d2;
	Wed, 02 Sep 2026 06:53:35 +0000
X-Mizu-Trace-ID: 6addee44da3240d2
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 14:53:28 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com,
	david@kernel.org, hannes@cmpxchg.org, kasong@tencent.com,
	lianux.mm@gmail.com, linux-kernel@vger.kernel.org, ljs@kernel.org,
	lyugaofei@xiaomi.com, mhocko@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, stevensd@chromium.org,
	wangzicheng@honor.com, weixugc@google.com, yuanchu@google.com
Subject: Re: [PATCH v2 1/2] mm/mglru: make type fallback logic explicit in
 isolate_folios()
Message-ID: <apfH6MYe6fNj1B-E@fedora>
References: <20260829074204.45304-1-baohua@kernel.org>
 <20260829074204.45304-2-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829074204.45304-2-baohua@kernel.org>
X-Stat-Signature: kumo6yqebdim49t7gfrw6bwehofow9cg
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AC1FB40003
X-Rspam-User: 
X-HE-Tag: 1788332017-80663
X-HE-Meta: U2FsdGVkX19ep9uT3jLGBcYwMJ4EanEXOOk+jOyTQzdQjoSXTHJzOR3Lvav1BAL4IIzGHVw/fLwYjZwPaTzGNdMMbchGrC7PTZDvaJ60egOW/Qg2cMn7yu0VGFu6fT1zbKNsR/OU3k8Uklv4YWwa1PMCiy35yQwTyUpVTAHjipKH2ewfiK4r1S4UoOTjwFsZBSDU0ztmuUmffgZavxhJd40ZIIbeL1FQuHSlGwZf8Icd6I924AKEHyC6DPsCObBJKZrJa1AR9ii7gkXxBBMl3MNj3oDaEV6hVVZTBpsoNQa1kjIOxBKxSdnw+CvDz/Q5JdR7+BoEpLEKOlZH7N+yioPQg7MtSsA7oWy5QTJKA5G/yO5SImdCehKiXn7evGEoodw67JxGr8/1nwm0aQ25Tq/ttsMe+wymLL4/d2kCn3ZLY2RahXkYqMmg1CKbZ0y7LU9H4PEPrPlawc2Zayp8WkIw8Mj06V/YJGfZiZbnRdZ/+Zw0htEU9cIGc+rxnYA39BpyspsQUb6xX6deGk4xS1Kr2be6Uwy5kFJ3YZbFJgxyYUwegPV78p2CFXO5cnBWZ6M7djPIcaksrBSiDDiKIUQE10JZuyyXxvYuX3I35SnXGpi8+QBeM3zsEW/EBQLPUXrJv2HElBtVKS8T88jfmCrfAor4bAm9kovnXrDXoTngPoPWppOOzC0rAcJ5PEEykYdkrektJsejPfDigQf216No19fmcG9KwO0TeUocqWdP9JqYi5hW0XDG5xNgWpEkl8QfP4+eRUhZD3lwQc8YfDmooDLZdIiq97hWWgCCQ3OUF1BXKWXYMIJpp17SXYo8XU7L5DqXV2FuJ09xfYliKgKoxC2h+SNd952cRN+JAB6Nm6lytaaA8YVPdZvHUGemkiyhwDSSh86JCgpH60/AWxWHyraWZtVAIalyTd7PS25Xokb4YFm+gHCvD43wUVPOAOv/O5DhaMzHOFZp1w/
 nA1pg9N7
 3N+0nEnZOI09cgXnIUfSocztPAoyWFyxjp/jhsy1HHKHLFCqirJCTynkw08GFnKPptILrEI+njsecSyPBRRIY69cP0KkOdpINCzftnacUboqpHVOclwZJ+Y4bZF/nF1soYt/3BQM8Tdqp0kKL3Iszdte3LC/37by6eO7Hf9tv1kydglWcEu0CY2UqUMyA8u48YK2VWzsmH6yDoMjfoB8/HjqpEw1Yh0XXyHmqPqNBh+5EuZoSV1nzRH0qrxwdi75yXJ9F3DjQiZi4kUdFavMP0pfWNha+5WAUugKzhKRQw91HHfZPTG7RwSs8j5FzmNHseMPXyXM+SjwrXXYAMP9SXlfQnqe9EQHzCKgi6+bYKMFlrPSd0lcu+eWzaJ9eMg7w4LNwiYmXOTuN9PnDKcYeP88x7U2hB1eAan00pNfUAd0/tbDaoEwH7RscQpTI27Z0kbCu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/29/26 at 03:42pm, Barry Song (Xiaomi) wrote:
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

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fdd13299a04a..35a233623368 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4838,35 +4838,41 @@ static int get_type_to_scan(struct lruvec *lruvec, int swappiness)
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

