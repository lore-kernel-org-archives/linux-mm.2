Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC27FC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 03:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923476B0096; Mon, 14 Sep 2026 23:31:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D49C6B0098; Mon, 14 Sep 2026 23:31:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C3B56B0099; Mon, 14 Sep 2026 23:31:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0C26B0096
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:31:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B2251601B1
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:31:02 +0000 (UTC)
X-FDA: 85214570364.29.0EE16F8
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4D04740003
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:31:00 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d3QPNl6D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789443060;
	b=5Lw02LKeQ8IivdHxAFmcAUdnK/NT4l39zcl0yNM0t+HMlBgxMzIaxewwBGNVd7W8SE6d/W
	l4u8PYUH6KIMArd8z26kNF7D6jwRCVOshCVTubdIrOHH1puEdugLlyFbs17vrxlvIDBKZI
	FvbKTcMLZf83hOogWzM3BfBOC1VPwoA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d3QPNl6D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@gmail.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789443060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7nWcLz8pfZOPdgnq2ek5GovUDuRsqxFmdnwCI+6u6U=;
	b=ZPonbFofr0yp3d31dP7djko0/w6MzaNSflxrtBIDYwxptd8+GCq7HfieM7yAm5w+7QsKzY
	unXRAixF1yzEIrLsu8fKLGbJW2tnsPW+UYVvDZodrh37qRQ5WdGIrEQksvLzYKiWYfXkai
	B3rZSS8m/0IViHpvT5dqj3auT1ZAUDg=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccb65437so1883563a91.3
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 20:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789443059; x=1790047859; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s7nWcLz8pfZOPdgnq2ek5GovUDuRsqxFmdnwCI+6u6U=;
        b=d3QPNl6Dp34wxA8auWRNf1LraOPcjR2J8aXWU8HvSQ7NWbe/XC86CqlQfYGFqXzgF7
         b3aVtje0WdBmBjWtqsnhW2mxMEIztxzMzxHpQ4jv/aKvIgJBoV4jcwn0HBWGUHrZQjTY
         vZXCXqarkLQvSh0BEHYWlKkLyR1OhIDfEojdFOltZiLvV2lHOAi1pdx4h4jHAzqN1w2R
         0fOOL8pr6T0juGeOq6saouIzKBJ/1dGo8y04pDRpHSP+0eLbHmYemZ+P7NCnAiAV0z+M
         dMWzlEZxY+6J60+qpc0j3uhygfn55BYXC3EJ04QMOUIsImsiHxi61qrXYwKp+XeZet6Z
         yX3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789443059; x=1790047859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=s7nWcLz8pfZOPdgnq2ek5GovUDuRsqxFmdnwCI+6u6U=;
        b=Wf5oV5tOD0IIclepQbHs+joZfi1QJrsTMAa1z4JaD7b+m7I0B7KSEYGy9G94ZoTKyr
         zo6zNiUwZYsV59ze2BaHi/dRVyZSYDfZ2LsZZlfJJxQUVatiLqvV4F1g3e5pLxnEWErc
         q/3RH2h5HQun8+671C3hfpDtwqK4tcqIQrDH0FwbsUGtD00KZRIl9hOO4mn5lp2XDLj7
         NWDEZBVKCOJOTqJQOpu63rdyKw54aVtsFocewbppA0m++c5dwPTpVMAhfPEOku5iymVg
         +QtY36l6lThl4ZOFIJNdIz/OfxGd9KjPYF7cPq1WMktJyESVgJCTFefF6jDrVkligJU/
         I7nA==
X-Forwarded-Encrypted: i=1; AKwUvBxIUIzHXbWgt3ilmSHGIAn3kZalMOfacfSpdrvNtLZxmqYzHlWFJRKxB/JYuBRHBbFg6LBfWr36Sg==@kvack.org
X-Gm-Message-State: AFuF++kgNupGJaM3OAq0GOJj6MrSDxtCSIRgIBQCDHvxLmZVnKN/ySi+
	aFVFJjRaLz1pPHT2b0pQm2hO7uSvNjYjCJa5q91Z+ERdAU6Or9PWbkjc
X-Gm-Gg: AYBFou0Wn0FFvp1W8Jl0XNB6sLDIEE7Ksc016cQrpyX0/FyJ30fcFQAo8feP+PBRG7U
	R01XRYcf9+wsN7AtjQFNJ4K9C9HB5Rj10YR5Fp4438QiEnaRF2K3CM8qlwQM8iXy7bEUcOoDTTS
	z6QEbuBOCHxUE0lLdAd/sxuH0KDar3GxgJoUCy3TH3LqTuB3r0GJ9veOa0E5gvIMaYm+Vr1tF0P
	soG6X522Vp88F0DSvc6Fh9k3q4xOHBur6vUbFIBZQ2KioJbS5jvIXm2hh1PoYEEtZIPlpuALMYc
	VLyFeiMmaN0GZ/RBR1OEydJWwfVcmGgB6U/PRDIZd0GUvqzly/XQmJzuXIEqQ9FICB12Hr+4awu
	7RpjeYZV3pKDZ28iRlVLYf4S/MqYhbHtLrTnQl1cz4YCFkeUafkqFywMaYJtsJOetGgUAkR8a1j
	qbszCLlhQMiqXY4LZZOnAdS9ompFFy7bkKN5lqQa8m5mSOvAo5oAwHSRUjH1SVcNqflhi/Sw==
X-Received: by 2002:a17:90a:e7cc:b0:39d:fe64:5725 with SMTP id 98e67ed59e1d1-39dfe6461f0mr4210211a91.5.1789443058917;
        Mon, 14 Sep 2026 20:30:58 -0700 (PDT)
Received: from gmail.com ([185.220.238.35])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4f55735sm31317478eec.24.2026.09.14.20.30.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 20:30:58 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <kunwu.chan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 3/8] mm/damon/core: return an error from damos_commit_filter_arg()
Date: Tue, 15 Sep 2026 11:30:49 +0800
Message-ID: <20260915033050.1579457-1-kunwu.chan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260913171706.103052-4-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4D04740003
X-Stat-Signature: pnqc5kdg8zhuxackjy8w3nipcejg7m8s
X-HE-Tag: 1789443060-569656
X-HE-Meta: U2FsdGVkX1/JXXDidQwo7oQ6vbbzRuwlUjm6exXFovsv92BUJNgSH6WUOIyQ46ZFrUL79YC6wAi2x7FXbX4P7dQjxktG0njeqyQeIHzVgdMdO1kwxg2HbgbtgIYAVM8Sjz+daDqbEpQA0ceU5uYn9isrtbncT1RkkiS3E05s3dwi1PpYsC25cTBGUkE8DRUuYnAbdlB7VDGSP6ux8pn7hg9Uvkwwt8Xo7zvWIrYolsC+YurTyx9/r8pFHPsmWR2ktFQmzdzFMqVacoyeJTA1uMT9Tug2YBUYTCSPH65OfAW9dHrjmk+q0OZVRSWMyo6ssSXP9wddPMr3CJKOe6jZLzQP8CokQBaVEeQ3m2HAHf/qWFLPkt7sePtdi1zzTa9lR2HT+A0gQuGg24z9TsuN/qUAcMNSXTyThE6K3gwhgOZWm0tqvQ2PQchB69P+0PPn5dmoLw17EiWDOGOiuocL+q+1o4L//z+Hak2pl1+KTQdw5Hm+gEhVSzK+AQQPGLf8IxVMXmL8dAAX+Z0CKCfeMdSPNvh/PWhJVB3hCija2gMCXv1Atpqgvy0gOgRiSuUzsGTFJJ8GDJ0bnfpRAyq4HsXMZ+Oia6GIt92n15/Ubx/6yBujfo03vVuHtRiocyZ9E6pug3efck7f5JoJkXwU/rSsH35xlyFCxW46+thYJKixIoMdWepTGTjkW3tq+Wg2is13AiabQsbMAE82wQMEL8Gu8YS/vdqstv+xYD6fKGVf93gxzz8dOkHHAvDwMtmofJ8Fw0gwfu23qECtRzn10t+wsp+To50MQFImTWXcWQpYGJF0IwxA5YXfqBcSxHIIiBIcv5qgMzXNGCadDiv2h0kGRH0eDi5xqNLZoQZir5ilabIPzsb1Ft6xT9xA0rPZewd+Z8UPtsA1oUQ/V9Xz1w98Eaen4UfUR/Kk+0AKtPxqg3Y1AJfhZhsIxBtAwc0vb7/bYo67G4xZW37vrlS
 ewcXYedI
 AnV/AC49ys9PCrJ34cStxQ4d8TJ/MU7g+U4Xq5rRjSyJCd8hFc24Amjbdg2GycOl2XrVjrUR61q3WQ1oN/6aYI0h8vtFJ/GmltIlfXKdN9Oj6fZjmspz0gua5LtFeLe+VxW8hUcmazEzOsrg4B3JuujlY8aFPJWxPk1xrRCNyLJ7WlYFvRDcJiKxlSbxBYuQymoJs/KBhwq1TxIUP+bqXotmRlQKrgDTSQPOQGVNVkpj4+tL//xymWaG47pwZTffUBvvvh9r0GgGfsXpSBSCUGCZsRRw+x1oW4sgFoLJrnKwrxuMbDXt6CWQwarX/BIp5yWbeVJnOARyhXIb2Q6ddE7bvnzqTKx0zruiYn8NUG3GTLlkjyCe+YQ+fThtstGi6GBCcLAR/AgowTTS4xvzTP5bw17BmhcjgKfDuDmHEklJrS+XVjJCPf8wfcdQTXKcPNJ9Mdf/ldUWykHt0GbKwgouND6PKKFgfCA1D5a/34oB4XwVkJvIcE+/DsRrRhCXmCv/F0q3I3cAfPCB60NowHkAMjw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 13 Sep 2026 10:17:00 -0700 SJ Park <sj@kernel.org> wrote:

> damos_commit_filter_arg() is supposed to always succeed.  It may not in
> future, for example, if the given filter is invalid.  Prepare the case
> by modifying its signature to return an error when it failed.  Also pipe
> the return value to its callers and let them handle the error.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 41 ++++++++++++++++++++++++++++-------------
>  1 file changed, 28 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 3d7a973ea8b6f..ea7d8d5a4abf6 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -1317,7 +1317,7 @@ static struct damos_filter *damos_nth_ops_filter(int n, struct damos *s)
>  	return NULL;
>  }
>  
> -static void damos_commit_filter_arg(
> +static int damos_commit_filter_arg(
>  		struct damos_filter *dst, struct damos_filter *src)
>  {
>  	switch (dst->type) {
> @@ -1340,28 +1340,32 @@ static void damos_commit_filter_arg(
>  	default:
>  		break;
>  	}
> +	return 0;
>  }
>  
> -static void damos_commit_filter(
> +static int damos_commit_filter(
>  		struct damos_filter *dst, struct damos_filter *src)
>  {
>  	dst->type = src->type;
>  	dst->matching = src->matching;
>  	dst->allow = src->allow;
> -	damos_commit_filter_arg(dst, src);
> +	return damos_commit_filter_arg(dst, src);
>  }
>  
>  static int damos_commit_core_filters(struct damos *dst, struct damos *src)
>  {
>  	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
> -	int i = 0, j = 0;
> +	int i = 0, j = 0, err;
>  
>  	damos_for_each_core_filter_safe(dst_filter, next, dst) {
>  		src_filter = damos_nth_core_filter(i++, src);
> -		if (src_filter)
> -			damos_commit_filter(dst_filter, src_filter);
> -		else
> +		if (src_filter) {
> +			err = damos_commit_filter(dst_filter, src_filter);
> +			if (err)
> +				return err;
> +		} else {
>  			damos_destroy_filter(dst_filter);
> +		}
>  	}
>  
>  	damos_for_each_core_filter_safe(src_filter, next, src) {
> @@ -1373,7 +1377,11 @@ static int damos_commit_core_filters(struct damos *dst, struct damos *src)
>  				src_filter->allow);
>  		if (!new_filter)
>  			return -ENOMEM;
> -		damos_commit_filter_arg(new_filter, src_filter);
> +		err = damos_commit_filter_arg(new_filter, src_filter);
> +		if (err) {
> +			damos_destroy_filter(new_filter);
> +			return err;
> +		}
>  		damos_add_filter(dst, new_filter);
>  	}
>  	return 0;
> @@ -1382,14 +1390,17 @@ static int damos_commit_core_filters(struct damos *dst, struct damos *src)
>  static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
>  {
>  	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
> -	int i = 0, j = 0;
> +	int i = 0, j = 0, err;
>  
>  	damos_for_each_ops_filter_safe(dst_filter, next, dst) {
>  		src_filter = damos_nth_ops_filter(i++, src);
> -		if (src_filter)
> -			damos_commit_filter(dst_filter, src_filter);
> -		else
> +		if (src_filter) {
> +			err = damos_commit_filter(dst_filter, src_filter);
> +			if (err)
> +				return err;
> +		} else {
>  			damos_destroy_filter(dst_filter);
> +		}
>  	}
>  
>  	damos_for_each_ops_filter_safe(src_filter, next, src) {
> @@ -1401,7 +1412,11 @@ static int damos_commit_ops_filters(struct damos *dst, struct damos *src)
>  				src_filter->allow);
>  		if (!new_filter)
>  			return -ENOMEM;
> -		damos_commit_filter_arg(new_filter, src_filter);
> +		err = damos_commit_filter_arg(new_filter, src_filter);
> +		if (err) {
> +			damos_destroy_filter(new_filter);
> +			return err;
> +		}

I re-checked this version, and the error return from
damos_commit_filter_arg() is now handled at all call sites,
including the new-filter paths.

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

I'll take another look at the remaining patches.

Thanks,
Kunwu


>  		damos_add_filter(dst, new_filter);
>  	}
>  	return 0;
> -- 
> 2.47.3
> 

Sent using hkml (https://github.com/sjp38/hackermail)

