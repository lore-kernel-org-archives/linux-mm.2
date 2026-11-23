Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1279B606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=dE0MQkl2
Received: by kanga.kvack.org (Postfix)
	id 350386B05C6; Mon, 23 Nov 2026 00:39:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327F86B05C7; Mon, 23 Nov 2026 00:39:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23DA86B05C8; Mon, 23 Nov 2026 00:39:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0ADD6B05C6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:39:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C2AE1C41CD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:39:04 +0000 (UTC)
X-FDA: 85465280208.09.E8E81A2
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id B19F040003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:39:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dE0MQkl2;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412342;
	b=qAMIXeGU8nKiLvDICQ2TvxshM3SU+0Qmt/eROAStl+2rwY1ReqUHa8kRfAmkhuY0mSbJpL
	b2BWfD1C2mMsr64iTf+hbDn6w/C0FSF+qmE3vddDwVc/eBQV/bFimi3gNRhfiiKDrMUDbE
	PmVM9lqgl7AD7jK+M1Ycj/swWScu46s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1clr5r2wO4r4dTZUcOGCWEDQFMnWEIuiQe2vSyPXs6U=;
	b=Aq2bzS34bhfq1lRpCAOomCCNIS+xwI6eI8UC3YC+pDDdGjDBuRGxXUUBTyQE4V+TPuG+KJ
	ge/rYYTFNj5s5yO56gjTPiRmQ9RvhdUJoWHngS83i9huVjm6MwJm91d4goLPPqe4WUPexk
	ok33fiDd4k909hs5GoiWrSQi87EGsCQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dE0MQkl2;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2f01f296937so22428945ad.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 21:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795412341; x=1796017141; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1clr5r2wO4r4dTZUcOGCWEDQFMnWEIuiQe2vSyPXs6U=;
        b=dE0MQkl2x4RnKSi2Uos77qgNMLmYLRYZR3m+ruBVAB+rw2Ojxkc3ESY9gx1UNSoHfA
         8RbskyGEujIJs6zLXm4Ql7Ooj9exbxqEmYPcZgXCgwTfr+O4MWnwHPv4E/g0t89Ae4XI
         pIBB7uTfzvNbQMAbdF4i5uQbulppT7FRSrPSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795412341; x=1796017141;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1clr5r2wO4r4dTZUcOGCWEDQFMnWEIuiQe2vSyPXs6U=;
        b=L51e5tS9Qwk42yHa4E1dIhJjiQ0v3bmqzJp+F29KbQbzSp1/BZDexZke7Q7z6534mK
         djJLtJy7Pd0WBL5/YWlLYby6M7M18HT3PSIhuiLouQ26LOFPxDF6ZXpdL9pcMCUuoeF/
         dhyRi+jBVwhGkvO9lkE3m0TEdlpnQGsU6oon7KGxqWODC8PA6Ljc2nvIDv1rxTqvIUI4
         pCWahAp1bUDSTBTbaqiZKHf8dE41DAbKmV6uSqsHr8ZgPCzl+RCXxCqv3hGLq+ByztPY
         LjgaiInYAHewEXzOmn4uG7eUKO1iQCKQ23st4657Qz3Lu3W/10zjfzDiRNoaW+qyk/No
         kFeA==
X-Forwarded-Encrypted: i=1; AL+hErGhERhlWBaSiphNUuqBEzH8JLm2Ke36x2B+9ijjzoGcoFEqoIlE0np/2NP8dFrYrPmzf4NzzscviQ==@kvack.org
X-Gm-Message-State: APuU4Z8TcoFm1o0pZhjl44mF2Fn3aiEfOjEGMUghmCuVHqH33y0Wlw/U
	aA/igeErLSfzmD6/H+YHoBJ1Fo5/lxDwQtNZr3+vE4caCPBnpI9DPazSAnVUivHQzw==
X-Gm-Gg: AZFdTZezRpIkj2n3Ht9aikj4q6sBEx2yE9N0Uf/3U74w1C9I2MiGVTfUkYTlhuZwM1Q
	Bzx2fbXCONp+KPaxnVPpkyi6ucl1WxmwF76CfjS8MVdEf+cDW+at05A94QXZ5CItKDRik1JI9MZ
	mHxbMnt/5x4ove+mH9OIMl9VpM88Onp0zwQbWbMVMB2Q3odw02RCqvNsNj59B0gvHhzAr4MdY3U
	aNh2uIJAcRZh1IUKD6J3k7pEDCK7chIMsqzJh7dDee1yB6Xg1zD7lCBLVDLv8MzEyPPC3YTWLVP
	WcS51M8NS2A7HzCuKOG1frfvAiYX9zyotE/EZbkPmJXDnMzrZMqgVfixG7mmsWGd4AOK0TwKbbO
	smLRYqnojdtsgVmXIkUFgM+NnZnW2hUese1/cGq+RUd+DIFVVwnAIAxK+bLYXLPWwIF9JnMW5Oz
	op5FwiRqwoqo9XRO80dClVQYdPGhsXBwpeONkM46rCWT/U4+mRsmAgdwlfPVo1eGXB5jASEPR5d
	LCgm2dtIiFwKfAbDQpozJd6MqYJwGz89B834WRmxBi0FLa5k7StpcNJAhzxtEj6HOfm9fCf4Ddt
	MCXodKyIL6t4iK4h+Urb2lpa7QhKledWxIJjoHpegy2DbfV8PImI7JutL5sh/Qtr5Mys9w==
X-Received: by 2002:a17:903:19e7:b0:2ef:e8f2:ba28 with SMTP id d9443c01a7336-2f03f249c83mr98893775ad.36.1795412341632;
        Sun, 22 Nov 2026 21:39:01 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:d8fa:c511:e415:e0d0])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f14fc8csm45964775ad.74.2026.11.22.21.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 21:39:01 -0800 (PST)
Date: Mon, 23 Nov 2026 14:38:57 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, 
	Hongfeng Chen <hongfengchen@xiaomi.com>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 2/2] zram: keep the hot statistics per CPU
Message-ID: <awPRKEk_Q0wRhZx1@google.com>
References: <a74aca7a3d27333972782b29786c7b33861a56f1.1795412161.git.senozhatsky@chromium.org>
 <cd96ecab2cfbb9a50a0b5141c09f9fda086780a0.1795412161.git.senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd96ecab2cfbb9a50a0b5141c09f9fda086780a0.1795412161.git.senozhatsky@chromium.org>
X-Rspam-User:
X-Rspamd-Queue-Id: B19F040003
X-Stat-Signature: 19k5ruyq5kn9pph1frpqqupns167atq4
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795412342-618282
X-HE-Meta: U2FsdGVkX18k2ofaTEeKsIsRA4phB/cyXeYsssSS/LzYvYzyjd5fvCE3CqKqsXrkXAgPUFNiXRyuwjABj4hFw0qh17q/OCQz08EIPTyNzXfmaX4nq9s0EmOUvvHTtpm/g6anVy1PfdM3oZCGJroOhxlHOwvaHKKgKKAdZf4Ra1W7+wVIn917LhJve94XmCiuPkawUl9Mbnvkzvja8a+LG8qIqkelL94w0sVEyE7vDRT2Vn7VM0GZCA+lcp/uOqqkl2TZ4WD6OKXw40xNN+j7Ghlju2zQaBPFSZTM/ESNe6j4J+I5QjJAkHk6shl0nwq5751hbIqVQnwQsnthneUwO/I62MHweIdbhbfq9KV1l8OIFjkQAdlmyQeirQTVvEiM8jBDuEiDWQljEVkfbQUloLrdOzL2i2+7AlsE2iAsD+p2faN3zF/NwcVyem27GbGIH3NNSDaLoXqGtI7X8G8fABxy67aWzHSvVpUz43OxMlZKretGYC6H3IXYILxcD7bD85FnvQoSYFua0d7LFth+w9688xBtIgUC7RKx8lp5NKt9W87c0UcBQ963+WZvhXY/OSVcbur5Jc3TeEuXXTrY30h4t0O+v5Wj5IAkOKkIfMY2RJZ+IZj7+brYJdnWffcGuOK+6ZNG3Nf45NY46aSs8z3SDlQW+hikl64Xl62Ostezsrd5dxnEAshM3B2uzE35tl692zUHoIDLA+AmrLT/w9WS9gk1M/DDPwkokKHIfCXUwqOsSNOc7uz8VgcjcBTml2/o2Dy9hx6URgDeIAp5iGByLk192xbNY6BPLrz4BMWgEQqh7cgtP/JsNZaDbvWKO1xj27UVWUzF5kHcC4rcVfCd8W2F6fvZXV9zvBfHeZzTlxhb2AG42SO5GbHsXjwyBVPDbBTpZve6iaxiMYcO+LMpcPJS1+98iPmUPuaD1T8peYDdzXz+YQgDvf4gv3sFalE+IMNNZt+EYWOLdNW
 jHOqMGHH
 IOiSqKlYBJAvdNvCWbPu/BltA1zDvBjTasozNmMbXjk/VWP2x5Xn6iJJo6oqtCyBUWYIHhtV6/xvqw3PFpvB5ubV0AlewzKklwHfmmT8Ywvj8OhO3n9bzf66dH5edLGmLpqCMlS8cS2humc4l/4haHQ+H5XMoo+mZwym+oaexpwTbP0OoqpPOjBtU8Pmj/Gi9Antjm3JaC5OmQf1HDuR9Xzrl7b7AwQHhgNl3pH2NUU410kNmwMPUCLjXAdwFvEDlbIeO9PSfgb8GlAFrhkca/tNxbWZWRnmjhiTIF6nOl7m5IaRbSUmLPLEPUI+/9c/Rk2Qpeh1FxWFDugOnrrWCqIu8+S01gVT8BTWweBqjHLdSFpudtar/LYbkGNXcv9ZAyjAfSzNkgHEgZyQwOCOLtwnjsa/hbNfT854i9+9n8bu7bD8EEFn+lkiDME+7HMX0A5K8o7lpOzi1iROR0ja6px0Gi6ucAY07jcHeh5PKw4xxQIIqWcspQeBdthyXne0Ta3qadfjhkYh/Y1FTRxccpxWtVrJ3D3BJwaD+4cmpgOdh4aHWC56k2rYvqQadzZsOIU3RYkn8Gij7y0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/23 14:36), Sergey Senozhatsky wrote:
[..]
> +static u64 zram_stat_read(struct zram *zram, enum zram_pcpu_stat item)
> +{
> +	struct zram_pcpu_stats *stats;
> +	s64 sum;
> +	int cpu;
> +
> +	/*
> +	 * Other CPUs keep updating while the values are added up: a page
> +	 * stored on a CPU already summed and freed on one not yet summed
> +	 * can make the sum negative.  Sum them up again then.
> +	 */
> +	for (;;) {
> +		sum = 0;
> +		for_each_possible_cpu(cpu) {
> +			stats = per_cpu_ptr(zram->pcpu_stats, cpu);
> +			sum += local64_read(&stats->stat[item]);
> +		}
> +		if (sum >= 0)
> +			return sum;
> +		cond_resched();
> +	}
> +}

Oh god... and, of course, I forgot to quash the clamping patch...
What a muppet.

