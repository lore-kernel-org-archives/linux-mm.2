Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E7E606A32C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 08:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=S3hJe43o
Received: by kanga.kvack.org (Postfix)
	id 7A6786B05B1; Sat, 21 Nov 2026 03:36:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7316E6B05B2; Sat, 21 Nov 2026 03:36:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7C06B05B3; Sat, 21 Nov 2026 03:36:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3701E6B05B1
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 03:36:04 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F0AFC039E
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:36:03 +0000 (UTC)
X-FDA: 85458468606.28.A3B35DA
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id C2C2D40008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:36:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=S3hJe43o;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795250161;
	b=fwtMAbWcyw8s4lvzAIqoxSIJ+maTlqCB+YsCKeOeGxBQouURH49tUpl35vR5ATcM9GJLd6
	1+VhHiDtTLc9ZH4bpbgtRa4Qcm2MWNQzkQMf/TWxDVGuyN8HeTTJlbtNcVbJJGUH998WCK
	MIzgRFQgj7+Spn5f5JpqZXvOb/qHaCU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795250161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q1d44l4EB5ZU0oAa814zHpO0T89XFHbgu/Aqd5GidKs=;
	b=Ly5Ki1fcxunKs9yKxb7CCRhX8VhZDsl2DS0EM4altvfE/5gjkdIW7K7GLJTjB+CXkEamWD
	v24F60FNG8pnnv/CErzcl+EMWyMxWL8qyxfAEJ3Guvnu+80g70eNjDIcbIy4XaTDUK2/4b
	UbuJy9Cb++XmpBPNWl62tGpdaQzqmV4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=S3hJe43o;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-cdab938dc83so762771a12.3
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 00:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795250160; x=1795854960; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=q1d44l4EB5ZU0oAa814zHpO0T89XFHbgu/Aqd5GidKs=;
        b=S3hJe43ooez8I41BH89hrT9lCM9EXoyUOCyFsuDNAFLNeYlNNwGUDMgyMzvGjlJzoj
         YHlayAuTq0NzLrM1qTnper1nTg1rCgrNtKdakqilD/zD0KG9qToWER4RqMD6QuJOk9eJ
         n31awQ2sgHJdGkAj3lI/Aec1kqFF8Jrxu4Q4A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795250160; x=1795854960;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q1d44l4EB5ZU0oAa814zHpO0T89XFHbgu/Aqd5GidKs=;
        b=hPSgxxEZ0/M04QNKIK+Av4LPJidRe1emLjECdYla1278IaSSoIz9/w3l3C6kpBWpS9
         1axYjinvEU5aqFXhsqhlAkCPvAG8HH1COklKzA8HvIPVVsyJK3Ba1UfFvHu8hyQG+1Pf
         ayb08O30oreysnYaadeCE0G5OsDiTDDQobJ9N1bSwzl46CCHCONeH0ydW5kVdRpAYVV+
         uecpXxhfu5FlUiZhUDaJwAhRRuEhCFwTg9fUgJWaCcgRvE/MA0ifukyIEoh4Ml/N6Lxt
         ZSmcGUiS4hncvSDXHiX9xKgbgOUyhz7hjufFUcRavmtQPRa9z1+3s6ntKNDTCJ3mNSdd
         KOiQ==
X-Forwarded-Encrypted: i=1; AL+hErGBlWZYHni7wHJilFUNiB2rB37v4JdMOwvVY0n3WQCq32lZ/yJPMsfF5CxJTQNLZtp36AhsFvNTZA==@kvack.org
X-Gm-Message-State: APuU4Z+522ewmb3z22jfGaUZ9J9qO7OvzLN7jTJ+q5i0cUziu2xq78ZO
	UqvHo814YOSkUs8MvPCcIniTGIHUupyjSYOUAb0kDfF/RUo3taJ/NuzLoAtr5XOHXw==
X-Gm-Gg: AZFdTZeFs/9UqaHKIix5lfq9rv5MZUPSZPLTPYhZUni65V3ueBAjUf8ZY5c3/vgtvol
	DXguGHT7PxSrb/dtchmDM365OUKJVPR0jNkqdkJmKgLKuP97FxEbDppwLJ/QfqsRuXIaEStRiQN
	SRuEOVEp6RaccbqjgsyicKez0jQ5vC9cA0utXi+PmknWQY2vi2DkvnyBl0LxH/ku2UQCnEYO2KW
	OaFCgmtwYIhvKV5tXfZ1xC5TyVI9143TVXLPxE5K4C4sXx966R+vRwvCMyPSnviYc1NBKId74FM
	Tg1uoZJiAjO3jUctyRVbYKR0qh/X3LQx93MQz0SoBvy0IMNQmMCnXgYlngw+sXD0Rdzdp8F/sFL
	uXWRA9dkidQzHUfTRaP+P02vNWETFQBGdZD81jyiMeZ+kCIm0s6+dKwmVIN+VMdyoux293xwSFe
	Wb6MrAHsn9jtdipg0jaNplU1ibJ4dEuUQ4uBROCJF77OY1NMpKIlTH4kSBaJXY9OMJsvUr9x4Jq
	Z1tkxcygeWDl7+twv71M5l6RLXuds8oDFevnLKlsy1R8JbAHJ0uRCnp1rZlNpCoqttRRO+PzCNm
	LxVS4waP3qNHBv4i89OdEmjd185UqVU53vNA76EDymBcpOFjXpXyN7dyGmwtqHm9bPeTPQ==
X-Received: by 2002:a17:90b:1a90:b0:3b0:9941:8d42 with SMTP id 98e67ed59e1d1-3b41c92a1c0mr5014603a91.33.1795250160405;
        Sat, 21 Nov 2026 00:36:00 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:2f43:ed99:516b:8dcd])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2f03f0c42b1sm24237865ad.17.2026.11.21.00.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Nov 2026 00:35:59 -0800 (PST)
Date: Sat, 21 Nov 2026 17:35:54 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hongfeng Chen <hongfengchen@xiaomi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, 
	Wenchao Hao <haowenchao@xiaomi.com>, Wenchao Hao <haowenchao22@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, chenhongfeng0212@gmail.com
Subject: Re: [RFC PATCH v4 2/2] zram: keep the hot statistics per cpu
Message-ID: <awFXOyeELHgLfy_D@google.com>
References: <20261016120927.3191690-1-hongfengchen@xiaomi.com>
 <20261017031542.3504947-1-hongfengchen@xiaomi.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017031542.3504947-1-hongfengchen@xiaomi.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C2C2D40008
X-Rspam-User:
X-Stat-Signature: hu7fm4a8hshwntir9nftoks4o3adbzra
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795250161-148912
X-HE-Meta: U2FsdGVkX1+op9BrFnCuC+7/Av07hweTAYW70NCYhqjqIPwPLmS/zJy4n4fWnzuUcZkz90AOshOyOYBgU5MOhBhKUvCXAdwd2jnHexAOX4BfCKyuZ1wrOqWbnSabP48U52UaztxCqcW5p/P/MuugHLCTQL2Vt2JJA0xn7eRtH4rRcQF2/v9GyEWxcclUa5NRTqw90ZZoDP80vzoeK7Eff6NMCjIcC3Cxx2aaVi/xFq7/52G5XiucWe8xpiSGj0f6//QfCqLwcnCby5pgDGhDnjDqvXlkkPJbQkZtxPVAwFhuTHsnIivtmp4APIisJ4KSgy2IIqIhTFwx+12AvMnBTPt+8fKfD3p6DNxByJwCPw7ZKyFUzaXgvCAz9Jh2tqyZTQUcHUS6N5iqLCzi6MvYJus+drJtF+MOhg3SPgO+163jxtM8WTDR11eyj8lkk45NHv0Uz/6mx1egukG52tI8UGg7DUkMjRuLl7HC/kEBcIHgZ936F22EISAZU+bxbCJGB3CIJFfBB+JUraN60vpW5u0gV/XMqxOUMzuPfOiXYGTXX2EY5Hot8b09DDzfymrhzza+pNOhClp3PQgArr9FlR9v3zhhp3pWgHRDwZvYlLFtj0Awl7GThZzwhjqvv11IuvpTvMl/M0Q4rk+JTqMgqwigWx6+1ZSxAcW0jGcLLWoxWHDxovksa9OPwi8B3gl/X1OVxR3Arjt9+ABe99MyxvENY4nVqop1fOkHrZHDInaSFZ+ZVSxUV16+FKpc1Ch/OwaDTLwvoL0iB52NO/+NHcjma36BXvd6Zwf07fjOFq4ISJkYVsa6Ui42CwRw2wPUV2UN2P/wNMxrhxOUouJrOvnBUcFSAPjOQxeuPYQLxMKkzcZwEQ6GIehT9xNCin3v9GPZ0w1GJFIzsoHwodRNaG+YFPwHqXAxi8Ty0sJUGhm6vbLZOtvM0gNA5R7uIQTcO4qDdTWfYfoho6Kc4B4
 G+VJMJp1
 MJgvthlMPFh7f2x5EKogG8bFvEehIns9oTkH40X+fGnbwjylk1fIuggbq5N4Kp0rBYhvp4NHxkLaR+In8TzmrECj9JaXd7VFHC+vNLtJPdSSi5KlUp7xCNspqwPpAUnWXGdNsdkFYwbUVusKeWGdmLaXOItRz6c+OTOpauV7CIFzNl4rGvhsWJglx4tb4g3EGv6UUSX8MuIIlXXakYELwg0wAlxRULYZvARx3wTZfpKiGEwQI6TVlIZ00WGHkFsI/fD06EXKvN1drwM5whcrNUIdlqP2VsNOo0Jk9pXvIlqHGIL+jdH8GqgHmEEbpWKiR37d9foJsZNm22qqL/s5bnnz74j50NSdAd4atYlThAMc6I8oX+tWT3Rk2lm8is7zF6IHaXbkECT2wFfNwXHPftwZfHwLggAEO/twOwsXFjo34A58jyRpbvYdY0jpRY/Kx2vkeFTb7M5VXl8o304o9efe0f7emK7yj36QakSDdXj/sJEQ1dlyEYp+TLu4xgHcT9BkV44MurgOMtUilMWs0dj0eVrFqI2CrvcKxU921Pc5C7pXYHsMG0NuJFgwoPFwjkkclgJm7kgL6Ml8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Once again, recovered from the SPAM folder.  Sorry for the delay.

On (26/10/17 11:15), Hongfeng Chen wrote:
[..]
> +#define zram_pcpu_add(zram_dev, field, val)					\
> +do {									\
> +	struct zram *__zram = (zram_dev);				\
> +	struct zram_pcpu_stats *__stats;				\
> +									\
> +	__stats = get_cpu_ptr(__zram->pcpu_stats);			\
> +	u64_stats_update_begin(&__stats->syncp);			\
> +	WRITE_ONCE(__stats->field, __stats->field + (val));		\
> +	u64_stats_update_end(&__stats->syncp);			\
> +	put_cpu_ptr(__zram->pcpu_stats);				\
> +} while (0)
> +
> +static void zram_pcpu_sum(struct zram *zram, struct zram_stats_sum *sum)
> +{
> +	int cpu;
> +
> +	memset(sum, 0, sizeof(*sum));
> +
> +	for_each_possible_cpu(cpu) {
> +		struct zram_pcpu_stats *stats;
> +		unsigned int start;
> +		s64 pages, bytes, same, huge;
> +		u64 notify;
> +
> +		stats = per_cpu_ptr(zram->pcpu_stats, cpu);
> +		do {
> +			start = u64_stats_fetch_begin(&stats->syncp);
> +			pages = READ_ONCE(stats->pages_stored);
> +			bytes = READ_ONCE(stats->compr_data_size);
> +			same = READ_ONCE(stats->same_pages);
> +			huge = READ_ONCE(stats->huge_pages);
> +			notify = READ_ONCE(stats->notify_free);
> +		} while (u64_stats_fetch_retry(&stats->syncp, start));
> +
> +		sum->pages_stored += pages;
> +		sum->compr_data_size += bytes;
> +		sum->same_pages += same;
> +		sum->huge_pages += huge;
> +		sum->notify_free += notify;
> +	}
> +}
> +
>  #ifdef CONFIG_ZRAM_WRITEBACK
>  #define INVALID_BDEV_BLOCK		(~0UL)
>  
> @@ -919,6 +969,8 @@ static void zram_account_writeback_submit(struct zram *zram)
>  static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
>  {
>  	unsigned long index = req->pps->index;
> +	struct zram_pcpu_stats *stats;
> +	s64 huge, size;
>  	int err;
>  
>  	err = blk_status_to_errno(req->bio.bi_status);
> @@ -947,9 +999,14 @@ static int zram_writeback_complete(struct zram *zram, struct zram_wb_req *req)
>  	}
>  
>  	clear_slot_flag(zram, index, ZRAM_IDLE);
> -	if (test_slot_flag(zram, index, ZRAM_HUGE))
> -		atomic64_dec(&zram->stats.huge_pages);
> -	atomic64_sub(get_slot_size(zram, index), &zram->stats.compr_data_size);
> +	huge = test_slot_flag(zram, index, ZRAM_HUGE) ? -1 : 0;
> +	size = get_slot_size(zram, index);
> +	stats = get_cpu_ptr(zram->pcpu_stats);
> +	u64_stats_update_begin(&stats->syncp);
> +	WRITE_ONCE(stats->huge_pages, stats->huge_pages + huge);
> +	WRITE_ONCE(stats->compr_data_size, stats->compr_data_size - size);
> +	u64_stats_update_end(&stats->syncp);
> +	put_cpu_ptr(zram->pcpu_stats);

Thanks for reminding me that I actually looked into per-CPU stats a while
ago.  And I had much less code, IIRC, let me find and rebase that patch,
these WRITE_ONCE()-s, etc. are hard to maintain.  Let me find my patch.

