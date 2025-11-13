Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47FCACD4F39
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 02:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7EE88E000B; Wed, 12 Nov 2025 21:11:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2E948E0003; Wed, 12 Nov 2025 21:11:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D8E8E000B; Wed, 12 Nov 2025 21:11:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7DF2B8E0003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 21:11:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26EA48856C
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:11:23 +0000 (UTC)
X-FDA: 84103956846.01.91C05F5
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3BB951C0006
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:11:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ZsxCfLEX;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762999881; a=rsa-sha256;
	cv=none;
	b=4VS7lt6bUihT16+N2Wk5LoctPg/IKm/YGIryHHAlSyqjRUrYhQhwM1SjD8kUSYZBiWyj0Q
	RSK9yTAILCHYaecpLaLcoh2MuN83jIHL4MCzJWbm0s5shny2TI9yj8YNQRiYGs4mHlUJOx
	J4qrsWq/nDsPZsQEPJhFHhoon/8B8wU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=ZsxCfLEX;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf21.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762999881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u5AcZX+11vgWIemSVjdLJtLigPcT6NnJiEeRxWsbcqg=;
	b=JAWuI9QmCmDEL6f8yl3z4jjHjiuqyp2Hl5JQk76YMfy2OyoyLxWR4/kTi+vCnkrg7SS1mw
	yzJojyLTZW5tDS5KbeSFVxZ8P74nio31Xw7yv9O5tiVutOzJQGQ11PDWNNLdCYxzOvDTrJ
	yViKGLae62cWuKYpkOCieBGQZvDxVeE=
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b996c8db896so278275a12.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 18:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1762999880; x=1763604680; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=u5AcZX+11vgWIemSVjdLJtLigPcT6NnJiEeRxWsbcqg=;
        b=ZsxCfLEXZ0htb4+DkvYAKywzcOMnF9+2PCaWuUQ7xD+FCNqHPNG8Vkise6EHgUWfuw
         KW3ZWNobr19Yape08IW6UpHQZtAi6ieCjTny8LYjmVTTqky8bp9gVbpGzLI1vhZ+tAq4
         D2cUl8GZ66Y1MtQqUUzNH1JYKSOQNzc9QC5gc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762999880; x=1763604680;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u5AcZX+11vgWIemSVjdLJtLigPcT6NnJiEeRxWsbcqg=;
        b=ZRVb4hWfTND/07U7RyymmMIDqQr/thZalK8pC2InKJwxWGTMaO4NLDDkruXciaW9gn
         nphQAUwNhns0B6CBl0WVrOx21Zt46pzHOlsLFad5TlVL5flBC6ePNAsDqK6q7+T98GCI
         4WCAVEMdq0A1VbYX0AMDIKO1ERTSmtmD1n8ocAmlPl4W7UCboNrTu0NKjqyGlBV8d6Nf
         +ZJ9Y+KXCp/Ga0WmPss5QmNGlDMGJZpjAo+b1K0ftD2ES7gCiVkaHZJwoGnyhu5OwgFy
         5fPz9TyOit1WdIpqgzyacqaABRwVvWcfsuldnbFLoNHQjCRt1hL3QcD03xa5vu695ZVG
         zVfg==
X-Forwarded-Encrypted: i=1; AJvYcCWeqKhPpcyshkJDv8C3k0HOIsRvnS8Q/0Y7TgElkw2DY7fr8JOeXcYHQjLSCfs1NRxXqPf3UrNX5A==@kvack.org
X-Gm-Message-State: AOJu0YyMYxMzYKKSC00xyq20z69xUh+d/3OF9A2m9EDO+aPQduT2dLg9
	dC9rBC13jwHBAN/QWIXcSXxuqZDEIPFc9Ouh9oLxr/yVJ1lActJ0lrnhOjUT16wY2Q==
X-Gm-Gg: ASbGnctRtONUE7KUUDs8cvjq2cn3XdyUyQ8gQ+S9zRqoymauacnph1Ko+378XLo5sbM
	bUnUm985ELYKB0B8NHzPauxhsytTdIljAH77XiygtRvNioKjmI82SAM1Q7lwV43ggCzbqmkdzrE
	YhFLzVSqWlgzSpzZA60ch4+GBykYnREP6UGkPZpVEb2X6wShZ37vmfBX6loHFGa0MRGCtt84J3G
	pmGGrZMdwpO1r6WUNSkPc5204ZzVN5uATuTbS2cDn4iWnbH3Hk3CBgjLnrkKjDJaxPe2POG9UzK
	EWUKEwNy2ZM6SjJfQKkfOtIgE50jIT32T11ay7OXDbHYRbZYhR1JDwEXmHn6ed7M9penHIPP0cd
	zRZ0d7oJ8X0OEl3BTacouobE+cNRR/Ya+ru2CDxyFHYe/YGVO04WruD8cr+qIsO96sREVUVn5A+
	p1sOs4
X-Google-Smtp-Source: AGHT+IGYC/tpzfm6WP035R1JLH5r9YIj4B9ph9aHTGNiXUFgK9mwh2404ZnYi+GMlrhBXOVAxw8iUA==
X-Received: by 2002:a17:903:244a:b0:295:3d5d:fe37 with SMTP id d9443c01a7336-2984eddf6b0mr67014565ad.41.1762999880114;
        Wed, 12 Nov 2025 18:11:20 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:2495:f9c3:243d:2a7e])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bc375eee433sm400380a12.25.2025.11.12.18.11.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 18:11:19 -0800 (PST)
Date: Thu, 13 Nov 2025 11:11:14 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liumartin@google.com, minchan@kernel.org, richardycc@google.com, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Message-ID: <3vua4ekiwivbeulfirygpll2vhkrtjj7ezafolwyxjuujrcelx@iyx2apjk7oay>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
 <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3BB951C0006
X-Stat-Signature: g1ogt5mzj4rs4nc6aqpa1jpfu5iqxfoo
X-HE-Tag: 1762999881-754904
X-HE-Meta: U2FsdGVkX1/By9cBr18HzErSA7o7LAuuyLk0vmmjFI4v18sqJ3IzN6t58oTj6GeGl+mATdnaoVAjm4etitUiZWasW9lMvjXRPaj5+vlvF2lBws7raaEWQPsNyKE41YH691QC+VX9u5Wic/e/5nBMpJwwHi9lXwXSwLdAcUFJkmCpQ+DuFXu1yiyX8VNsMI1PNolBbbXVEUHQhK0AXsaJgWPbxYdp8ECo8eb23May2C8wdxWe6lstJNeRKCCByujk9xM3mw5pYyOB7tUTbXoIbAMcBSblXHyHQv32l20JfeBb7zVjtqRPek/2Pj6y59td9JE9DDc49o0meCf/jWRTT0iBETv2LncygUZZk9T5koXLlTgZSLE1Iui+0AUGzA7y8w1QE6YXQHLHsfqoERSI9zF5SHm7NBrkWt7Ewxn7GSz4zI4MrjssH/0FiuzLWTIHtnhOnKdexgN2HuU4YYF3BmBUUQnl+G2BDuYCty7bG1XWPcsOmg105f3w+pcfyey4vNpuxExFwywFbzAhUSWnmYevgIZGUj7RmWSiq/sBnOSBfgKVpmSTLOMxYAfrauu/aQ4k63OGaYn9FnnroZhhFkq8YlVRKjG5VsW+tk0ok1qpAloLtFPLfQ7FoFMrL3wMTkx1py4ryTnfVNdrPC80+9wYX2OwKDF/XCIaT+HQBcx0kNHEan/bpTh/u1EqBAyY/Ck40BBF4trcfNHUKGlVsR+g5vSIyHpKvSQwfbznX1EwTAmzdv8U7jkKlNiW7BY5CjeJTLKbZQR9jPWmkfM7vMmwCYtonfEypQ0Q14qzgs+D837jSH//bq2ntWIkF8xGZ2sIv5Z2qgvYG4GVW4H1mGAY4+o76w2wQhaijGYtD5/W00nSbfgFjL68a8d9SASzCHKYcjOcI93Jh5uCGHE7xwoDBmqpCP/BNi2qsB1HCNxezUuiA7ukCHymh8A/WhdjM6cCBymaBR9yR17OqTK
 +WD4T8fk
 I5Xb2tQ1LrLCkV5NXxdEwKIgkRcSsP4zH5IWl42REPP/EiS6zYlN9tngTRLs99xkesT7jpJpR3IrjqqWvPNjXxZdXSTt2snhK9mboyFO3ZACJ3+3VnBw9h7+5MKL+PzxiJ/9w0KFIW3FCdmbatlROXsy+noef+f9KGHtyVyDITTDq6BpPjJbbtSZtXw8BpJg/VKafB1iXab31rJhx+04Yj7BRXg+24wl9kEGbt6+zXaQAHhMGUHBjwXf2loVTfFYusITxQ7AXkON1+ljmibA1svPCnDfCkHsYifoP0yUAh5rFQX37ikupnZ9jPqeFK+llygU7j9eaUBZqSsebukaIx666fcBEWeVj0OBLX/wNkdOX/yM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/06 09:49), Yuwen Chen wrote:
[..]
> +static int zram_writeback_slots(struct zram *zram, struct zram_pp_ctl *ctl)
> +{
[..]
> +	struct zram_wb_request req_prealloc[2] = {0};
[..]
> +	/* allocate memory for req_pool */
> +	req_pool = kzalloc(sizeof(*req) * ZRAM_WB_REQ_CNT, GFP_KERNEL);
> +	if (req_pool) {
> +		req_pool_cnt = ZRAM_WB_REQ_CNT;
> +	} else {
> +		req_pool = req_prealloc;
> +		req_pool_cnt = ARRAY_SIZE(req_prealloc);
> +	}

This looks like a preliminary optimization, I'd probably prefer
to not have req_prealloc entirely.

