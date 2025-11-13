Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B370CD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 02:20:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8914B8E001D; Wed, 12 Nov 2025 21:20:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 868E98E0003; Wed, 12 Nov 2025 21:20:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77F138E001D; Wed, 12 Nov 2025 21:20:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 673778E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:20:24 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D3DE1A075C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:20:24 +0000 (UTC)
X-FDA: 84103979568.10.B11474E
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id 24DF34000A
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:20:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FZaqEZNI;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763000422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/w2/PdviRdTlw070F73adAMmi8JBjtS57Q4Bt5NlWRI=;
	b=EZXqbi5HpJ8jxj77OZx8XGuL+xsXJT3Y046FJX/6hFy0/y6Kan5B5UG2VbG+nzROE731B/
	Pf0MV8S7Rc2ZnEYe9fyTaXSM4Y/ECUZtSDfjMyTejwRJZ9dfmH/vktt09n86tNlnhDs/9v
	Dyd4FWFGIVOdlnsllJBfmtyVKfRxEEY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FZaqEZNI;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763000422; a=rsa-sha256;
	cv=none;
	b=NzJUWhjy5smspVhs8CBc9skIjmanjjhlKH70jGJYfeySF5k3om4iAcQziKW6HwMJ53Tq5v
	/P0yhRPL5heXKXiWejnMWmPbCL83jJ0hIWyq49/+XFJqpdEgI+UWT3GoILKnCsAiGAO/W+
	osRGWs5akTW8utqz8tx2viM9UWmXUH8=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-298287a26c3so3399845ad.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763000421; x=1763605221; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/w2/PdviRdTlw070F73adAMmi8JBjtS57Q4Bt5NlWRI=;
        b=FZaqEZNIunxGWVpDvg/j5aC6dJ92mAZb1zsVZA2SHOzphwFFtROwKrOO97Jn+AFwmP
         oJxudrdsv0c/fBGwpL3dBDwFFAg0a2fzDZrvPHRBhPPCnuV9XV4rouB6bgZuz54pd6Bg
         qqPKvVlI7z/e30NZiOcDaInMHZ370XD1QwWm4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763000421; x=1763605221;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/w2/PdviRdTlw070F73adAMmi8JBjtS57Q4Bt5NlWRI=;
        b=E5pjyXmiU5D7THegxC1skN1vNw++27nIzwkMNgoAuBY5bxH8KemP1iP2KXAH/wL5p0
         b+/PehDfhKH696cfih7J37EYgqCjW7FJiKFGHwGY5DHBTPJwzZFMw7gG6yxXGVgmz4pD
         jDgLzd9uKASA4rmm6spT68peE0+Qv/UB+aZYkhY7l3fthoRfeUZwtTW5lyVj8tdeZou0
         B+9ARk2W2gETefame+aZLiUfKrcpiCG1EkyXuPdK7D/htvy0BtWnl+WffkVZIomg9ZbV
         1P+gRz/xcQFXNLdgyWnwU7dEGjrmsIDQpitQtjwxi3iAl2Nw1F748y624N39O/fBGQaj
         wZjA==
X-Forwarded-Encrypted: i=1; AJvYcCW+HttFNokSy7yY+8SsisrCrCCIDchHX2M4amSMvDJ+1sSa0V+ybL2rjhTPfHcqNvfb2eYgQ/iziw==@kvack.org
X-Gm-Message-State: AOJu0YwhYvGh1ehSzKupVQqrN18yWVSiTe96FOMDlTjvUGAwlDJFBsJl
	ELmvVuSINhnqVexRvuPOQX7oi7WP3j1JbzKF+ZailcGun91x/atBtirwFB0ZLBPyJQ==
X-Gm-Gg: ASbGncvH8eSKl6PWSZuHLRzl9zb2U3csM7O+Iqiq+rVl9SXpEUQHQDChJTTHBorfs+n
	yZAssTzm2rL5C3j3GL51xToLnltW4vqt+lrKJPG/BKvUSpYTOm94WyVwgjAJaPX8GrpmXXS+AWb
	7UWcOPXtk0Wp0dgJhAQv9IgeO+HgBXTmQVOLeT+OLuaqP6kVtH6QFBjUZ4+mb2OsreyZ4GSEWAs
	oAvQr1QtIR+nXwv72YmWhc7WGxPOAOaFyfQIQKVNtfhe6RWx0WVEWLPMgyaGqYI8CmgPSWVsv93
	mlULzWvFLIM8FwdJ1u3PBJTHzK5rimw592yFSdxeq6S2ertrToi3DKOgCKMJGR5214OOOdVdJzZ
	Y6hKxaY3qd3JBh+VjCjYrS/mboIAGNpBz5vV1jIh8voq01jiKWUYXpU5s64KwqBGACWWTe0eAg6
	BJMpEc
X-Google-Smtp-Source: AGHT+IEEUGpj/C7xlJlOjaN9FHEmFsBqdEM3aCXQOZ4vqMNOSNOagKZXMJ3scVSlRlMs6U2ceqWAZg==
X-Received: by 2002:a17:902:da8b:b0:297:d939:393b with SMTP id d9443c01a7336-2984ee307f5mr53960045ad.58.1763000421049;
        Wed, 12 Nov 2025 18:20:21 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:2495:f9c3:243d:2a7e])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc36fa02c42sm462699a12.16.2025.11.12.18.20.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 18:20:20 -0800 (PST)
Date: Thu, 13 Nov 2025 11:20:15 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liumartin@google.com, minchan@kernel.org, richardycc@google.com, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Message-ID: <x6ksirxv2xffhzpvdxmm5fa7r4b56mlh3kbhopljdsvwzg62wm@rrsslefk4rb4>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
 <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 24DF34000A
X-Stat-Signature: mgbtxrgx4y63inuj8j7h64qsu5bk1ibm
X-Rspam-User: 
X-HE-Tag: 1763000421-296736
X-HE-Meta: U2FsdGVkX18wsmMRZbyTZBX4N/LuM8DsL4GL5eSrJW0x3T93H+M9KC5CdrYg/fyTyAWqig18U4NxqgLOweymxYGXFDr/WBkHq4T+3bDPm2gdPn9/2Q1UmXYVW/fYK+f7H79RySDNQH0NzhBWlLEqoyRSK0PHa4+tawaGmESlTUh2nI/a6Vg1/MqvERp0I8/RETNFRU3KhoRAz4VELkJqh5E3ZoIbN1qTy6b+5DYWJWLv+2c248zLA/F6m+JIaiBdqcJoqbMr93UvZmxBRRm++Ezlt7LE6RHP0yP5CMfgLUTmqpHqZjjBgt04xGJZ1eD3MGutLMURjkml+BhiEDoV1t+31LpMHb3gf6rN2O/v2+x1lQqtVWKmWS/HkZH+UEeN2AdAhzh4PAKrNITrIwc+3wagMWIiML56Zp0thKtHkVnlI3xUXsPbUJ62242YzDmh2C/vK2+NHOM375j+CJf1s4qcdX2uIQ8pzDAMoNLAnOuB6bJ4Qq68g5P+oOVHIlw67zQ4OA90SI0m6lI7oGbQXF8hkP/jiSX50RuC03jeDEDaMu6rH4fINxxP0eTrE6whs4foDM9UlgrVocaWTX0QDaXyqRXcCrhhNwwM6aDQ0S0DM5hPJVipSh+CCvhCRNNi4oyeafafCDeg3KOGF81ZgBw2cML7/4wIL1UbN6V1vc5MQi/zxCZomutE38/dK+NFdFHBfplvSG6VXrrOtVlWMDudAG7xAI4Qkar29OSaG+5+z7GxkPEkdK25pIzAUzBDGf7MsipEldbbSp6JQ3QNG+Rm6H2hQ4GpV2LtRI8l9dkR6Te/A/UAJb80D3InBMH9TNrvR0XfHM+EhjA9TaK0dIK/livfkfcffSKkZVoa825a5alrcPPeHQdY5ScduKZrMWhcgqcNgeuCcBm28VmxmRSRvYoprHMfjBM6pJe6gdkAKsy4p7PAaVxtQJB+LinYJ1ZnNFzt5bvNjGCmJXd
 I5GIF/bV
 9gcch+Jh5krkJ64b2xJ1TXL/CHbS3YrSR0kF4NBadCsylBqBuyU4P6lB+kR9EiH6aQYKx31l4YWi8nu0L1S58obalJeja07X2rRC9hNP2UGjpTZYSBOtF52rK+bY4nwPx36qoggFeXohfS+qmFSKEHqICgz9XH28a3MvhDqQsdIOWDaAtTBcb0P4drhmegCobet4Y/0xId1ruxxeattwDDJgq5ul9i61HmimW0Y5itL5krULHj7qW2ogrzQKZxbGR5UnB4VVqB4IpSxYEZezvY/NKCge6yJX8gpnULo90XZXRYwT5GYCCvLmzum81ZsSv7uyc+Mh8mTxjPQfK5mITolfgSFNWkWsSHBfpe9v1enhEPt0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/06 09:49), Yuwen Chen wrote:
> +static struct zram_wb_request *zram_writeback_next_request(struct zram_wb_request *pool,
> +	int pool_cnt, int *cnt_off)
> +{
> +	struct zram_wb_request *req = NULL;
> +	int i = 0;
> +
> +	for (i = *cnt_off; i < pool_cnt + *cnt_off; i++) {
> +		req = &pool[i % pool_cnt];
> +		if (!req->page) {
> +			/* This memory should be freed by the caller. */
> +			req->page = alloc_page(GFP_KERNEL);
> +			if (!req->page)
> +				continue;
> +		}
> +
> +		if (!test_and_set_bit(ZRAM_WB_REQUEST_ALLOCATED, &req->flags)) {
> +			*cnt_off = (i + 1) % pool_cnt;
> +			return req;
> +		}
> +	}
> +	return NULL;
> +}

So I wonder if things will look simpler (is this the word I'm looking
for?) if you just have two lists for requests: one list for completed/idle
requests and one list for in-flight requests (and you move requests
around accordingly).  Then you don't need to iterate the pool and check
flags, you just can check list_empty(&idle_requests) and take the first
(front) element.

