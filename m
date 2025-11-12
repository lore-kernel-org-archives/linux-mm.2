Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44466CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 05:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DA798E0007; Wed, 12 Nov 2025 00:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B20C8E0002; Wed, 12 Nov 2025 00:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EF288E0007; Wed, 12 Nov 2025 00:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E61C8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 00:18:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 311A416034E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:18:10 +0000 (UTC)
X-FDA: 84100798740.22.8007DE6
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3E3CE40007
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 05:18:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WxaFq2W6;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762924688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJv5UmqfgHdkO0lr5oB99ha660rGNd0N5LAs+dq++Iw=;
	b=wpOym/NncEmVwgAumF05sJqdMLxa5X7FgpVm5KdM0s5+LZtKA55/r2PtmtkH/SAmcJB+Fw
	yKYFybbaKi0Iwo3YLeoLbGayMHZW0QNxW+1v9+lUBBiOd+3zIKDJ9XMd7/JPjthaXq7Mcf
	lrClvLphhVm7d1iUY412HRKriDVBp54=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762924688; a=rsa-sha256;
	cv=none;
	b=pr5+D6LAtKhkHSpTLLIlcU6SbKMMzNrooP4ezzd/VwXbKiLlKXBg2FJuhHSQsqkEBmUVk4
	Xj1QRkw4Uh0CtX3VdsG6yNoMVDSRYWUzedt2sMtVuYzT3uhNgNoc00FcFSHmWfKsZJnSSS
	tCwggMqyRFeLTleNx1lyd4CzFUpozPQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WxaFq2W6;
	spf=pass (imf17.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.180 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-298287a26c3so4950725ad.0
        for <linux-mm@kvack.org>; Tue, 11 Nov 2025 21:18:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1762924687; x=1763529487; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kJv5UmqfgHdkO0lr5oB99ha660rGNd0N5LAs+dq++Iw=;
        b=WxaFq2W6MwjfFutS4SLdPKOC0y0jGp7rkAT4oLngdB1iOhwFjHiuUSMbMQKgSgeGXp
         wUsJXFDhDWEAfsC/2jRR0aKUTuPecbKcD1NWLg82rF8KpKw10saR4YMmYe6G6k4VqUmG
         OutMU8JeeTDjSENYYuwr8rWw1an1k9bwzqaq8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762924687; x=1763529487;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJv5UmqfgHdkO0lr5oB99ha660rGNd0N5LAs+dq++Iw=;
        b=OLoGt8Q2mEH1Jah+jt+Uj1nDhPMNMrk6a2ugEve3csbG+vsyU1cZB0OyMnphwNQMY4
         9Dckd/yQ3ukaJQiMrfVm2oDqrNHXYNKI8hadMlzUM6bukmcqvNc0m44r5vohVJEq4ck7
         J+B0QceyjtN0GiT2qIRi7o2ORyUVQd8p7+rhW1vaxNmvr7rUwpm9SajfZ8oCUuWXL7uI
         X974AuuRqdmP8CJwGBUttQjCXbsxCEr4HmhhyPmtcrYZ+BsLwQu3d2px90mtbaJ89IhW
         a0kZ5rXf3lkp5EsiR4QUoL+0OSf1/fxCdopevoAsCgiGaC8aafxPNSC0isEo7FypI+Nz
         ru0w==
X-Forwarded-Encrypted: i=1; AJvYcCVUj9IYoSOmcj6mGTyG+Zl+8v8FUCFoxPGqvVmNj9yaOydIgdM+C1iCH3ou35sP50wBSdBbZC2RqA==@kvack.org
X-Gm-Message-State: AOJu0YwnwnaHNDelNflRAV+ySC8OShUJ4K0O/SLOQoIfKUNNQ87FLcB8
	zqHt2MaoYdZwNaQuHHzuFOltUUwMqXqEZdXjxuM/wMSwD/t0qn79Ghq6fk7iIPwjXrke3uuZDym
	TFKIr9w==
X-Gm-Gg: ASbGnctcA2jy0TEDOSyTMjnJExlj7ch+WuZuXNFwwcsRh25Bq55RO4YmLkCol9FSD00
	mFU1Mp+UQmBKXSOkSfVuSJz8+LneY7UQ3Ar3jY0739poVzFyrZ3sYTZhyFgRaKkyF2MnZMRBT9z
	Nj4nLNIIZ3eXVDx3Twem3ic346x+Ro0sV9flz/M5I2HfFGpDrqtCDU++KBxjEkiMs7H5SwwGLDf
	EUAL/X7sxWD66QNMufBTY3oaLVzqdHCGhPnlHlMWdPxzQ0W9WUSg9y/xc1O4PL7KBxhu+d6w8m3
	oZaD9iN6l03bgL5B9cpWZ0kz4y8Ntg4+bBAGs/il5BJgOWiJsoCWuxDBJLh0fx6qIVMhjk+5Hv5
	jlsMnH1sUScMuF8QSrDV7HglBctmR7XUi4zuSwa8GnnXaEgAkRgxflOTNEPXKARDCs2xhresvgP
	Tnn2vle4dffiWRNHU=
X-Google-Smtp-Source: AGHT+IGbKMmfp62moQ55XqRXlYknpv7VsvU1R/1ooo2QU9Rce7Cy8tcLuOmjURe+U+W+1KDGa9Khaw==
X-Received: by 2002:a17:902:e5d0:b0:295:1aa7:edbe with SMTP id d9443c01a7336-2984ee021demr25227455ad.41.1762924686858;
        Tue, 11 Nov 2025 21:18:06 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:2495:f9c3:243d:2a7e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2984dbf550bsm15774345ad.33.2025.11.11.21.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Nov 2025 21:18:06 -0800 (PST)
Date: Wed, 12 Nov 2025 14:18:01 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liumartin@google.com, minchan@kernel.org, richardycc@google.com, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Message-ID: <htycvrcqbnkk7ldhpaqxesy7uhz3lssymwqm7nzkhyhnid3krm@mfju626njxvb>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
 <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3E3CE40007
X-Stat-Signature: 3pnynjpo1ktz43q4tsn9zbog4smzmiuq
X-Rspam-User: 
X-HE-Tag: 1762924688-99490
X-HE-Meta: U2FsdGVkX1/82J9vM6dgGuLsKPcsMO75zHprG5q8xb0CjceNacivWNmO5hC0z5mHXj2xBNrh9Qs2qYeEMUi8rKfXWhzlHBR25iVC7/IBZtWz8CENuaLb0mXOPf+VLswhEvTzq6KLQtYKxoto0gAeMJPzAaM2FzqjVpIAUTkoCp6KDs/pLzzNeLFFzf0E/uDsmvkOqX1t6mnO/l/MU+uBHO1Txd8hpA5h4OuC3OgnPv9Oo5uKu/92yCn+m8XoxMf3z86xKeRBi/h/E0Ii8vx2wex2+UvnVixaYxV55wfBHWnKOlHcKAoMnUfmrzCjrF+/bAlyautg4LJLSOFazVzdU33K0xTJtkUNJ5lkrqgnmLbSK6penpzscRfFlWAs2PUfK/UYsoB53tGUm0cDw6rmEi+NPAmlSWaK+L7NHZ5s+dDBZ5mnUBliVijxSuXWMimSV/pG8BSBMo8UbTwcSZ0vNxsRoEv6PekHSmf1gApBFSBfPCYAkgsaYKUAY7ql1AgqX7Q0PBYGOqSYFg0eTT8BiWw+iRTQxG/f7yxgYRHpMCD3dvL5AFwg716u6N04zfeX/NLA2JQfBjGHnykmtkG5ubGBIu6vMEwPrLsahSKLFAunYOAGzs6X688GymJW8fCICt1ohLKUqdFUn0xgenAYexB+mv4qZ/W7QP3IraEE+sc9PyLdNBQHgtYeNb5Qi2jfeMsJ/okEhJzHawpX6POJ5Lq1Geg/nYDaxy5KsjqTYbDeCWQ6e+GDQeqe7evrGVdYf3ThIIOQuBpnJAwTKOXsYAEnSN/2y4ZQvCEoI0FCIHOSYryVY3JiAnLQx8WG/szVCHXQKdFzw8N/BP6LbSakkMKg7NlPkUSBY/x6D5Wofec6hnHBRYlVpT4RFZjkG7VEvZ3Ysg7VnubhL6bjcc30ICYLM6rSRr4lYuIFC8T/Vi34RDPPMl3/SXaBP4+XXbtz2tz/e1QMZ9OKVyr8i5B
 nfk8nkGT
 9zpNsCBPXsh63+0Vu+yII3iDxYLUpJZSqVJpLrPvJOm6qZXBl2PnoaGCv70C4BkPYJT0XDgtHg3O/8ME5amdo0EbwcDcpZ3GxVui6T+PJbgsiJPeXPS8KuosIVDpyH7DJQfSbc8c9LcS0sjh+yExqd6BGXtfESVKP1iQRy8ZYYPvMdozV40x+JTRzgwg1seXUNOgAvojghG8cZKUm8EwuBbhsCHznWNVouR8C6P96j/X+y2O3tQle3bI55w22wqUO1SPMfqtZ6cNtbDWPdjeMqzMRzslgn0TLndJuwocUeXugLNh3WlqWxc0myO4m4i44sDINWZGnBspuMqdKFlcw+MUTKdf9uxoKGfESuxIU61BPqZE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/06 09:49), Yuwen Chen wrote:
[..]
> +	blk_start_plug(&plug);
> +	while ((req->pps = select_pp_slot(ctl))) {
>  		spin_lock(&zram->wb_limit_lock);
>  		if (zram->wb_limit_enable && !zram->bd_wb_limit) {
>  			spin_unlock(&zram->wb_limit_lock);
> @@ -774,15 +884,15 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
>  		}
>  		spin_unlock(&zram->wb_limit_lock);
>  
> -		if (!blk_idx) {
> -			blk_idx = alloc_block_bdev(zram);
> -			if (!blk_idx) {
> +		if (!req->blk_idx) {
> +			req->blk_idx = alloc_block_bdev(zram);
> +			if (!req->blk_idx) {
>  				ret = -ENOSPC;
>  				break;
>  			}
>  		}
>  
> -		index = pps->index;
> +		index = req->pps->index;
>  		zram_slot_lock(zram, index);
>  		/*
>  		 * scan_slots() sets ZRAM_PP_SLOT and relases slot lock, so
> @@ -792,22 +902,32 @@ static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
>  		 */
>  		if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
>  			goto next;
> -		if (zram_read_from_zspool(zram, page, index))
> +		if (zram_read_from_zspool(zram, req->page, index))
>  			goto next;
>  		zram_slot_unlock(zram, index);
>  
> -		bio_init(&bio, zram->bdev, &bio_vec, 1,
> +		bio_init(&req->bio, zram->bdev, &req->bio_vec, 1,
>  			 REQ_OP_WRITE | REQ_SYNC);
> -		bio.bi_iter.bi_sector = blk_idx * (PAGE_SIZE >> 9);
> -		__bio_add_page(&bio, page, PAGE_SIZE, 0);
> -
> -		/*
> -		 * XXX: A single page IO would be inefficient for write
> -		 * but it would be not bad as starter.
> -		 */
> -		err = submit_bio_wait(&bio);
> +		req->bio.bi_iter.bi_sector = req->blk_idx * (PAGE_SIZE >> 9);
> +		req->bio.bi_end_io = zram_writeback_endio;
> +		req->bio.bi_private = req;
> +		__bio_add_page(&req->bio, req->page, PAGE_SIZE, 0);
> +
> +		list_del_init(&req->pps->entry);
> +		submit_bio(&req->bio);
> +
> +		do {
> +			req = zram_writeback_next_request(req_pool, req_pool_cnt, &cnt_off);
> +			if (!req) {
> +				blk_finish_plug(&plug);
> +				wait_for_completion_io(&done);
> +				blk_start_plug(&plug);
> +			}
> +		} while (!req);

Why do you do this do-while loop here?

