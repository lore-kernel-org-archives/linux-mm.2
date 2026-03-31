Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD36B109B47B
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:00:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B0656B008C; Tue, 31 Mar 2026 11:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288436B0095; Tue, 31 Mar 2026 11:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19E6E6B0096; Tue, 31 Mar 2026 11:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 098996B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:00:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A142D8AB58
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:00:14 +0000 (UTC)
X-FDA: 84606668748.19.8854EC6
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5069F14000A
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:00:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TEoo9V5V;
	spf=pass (imf23.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774969212; a=rsa-sha256;
	cv=none;
	b=Co//SRzV6wM6rF+bo3IlgbAQCMRiUcFGLydb12cjYhnz1kbpeA9BoNyKFwJmY0IBWfjUZU
	7cNclQInciQvqWt5TPhoUo7BY7XiA0Svf9477GmPOj0Cus6k15/4eT+cXR6S4osE+FBPrY
	oKdZYRBf1qsPWiFQ2vdaIICLM0TzVhQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774969212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLLxzw5GoGg/yFRLXTVGHHzH2KjcxDISY31IWyrVnzg=;
	b=TOSjb/WYT0OOiweaH0X61uhf4IleVNWLAOBATaRRzElZQE7jYwjDhq8h3r9HW9+AUnPEzc
	vQ1TjereSDhH+Aukq7zbWa7OxThlbE48oYTPKddkLDEMu8MdZb9aU9aHlMmjxABh3xeqED
	JL3rmhV6nxeXIVmlNLWd2raqol64eU8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TEoo9V5V;
	spf=pass (imf23.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-c741db5d610so2416353a12.3
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:00:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774969211; x=1775574011; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MLLxzw5GoGg/yFRLXTVGHHzH2KjcxDISY31IWyrVnzg=;
        b=TEoo9V5V02/zuDV17UgKJn3vXIJDfa1/HC5RipAvl6CFxkYuHQThO2dcvgiwU3QID3
         DuoJQlaCNTxMA2gn5NGkkP2Kco3YdSWcNETo/Rihu1v9heDdtnwuEyfIfdWjsFqkIUHv
         u3i365aoeHTYw96JuAkboscGtLArs4A/MtRjAIZ2CqWCT5Fnc8Ig277Hbnw/01xOj0KT
         7R7xDCUWmPa1Z2rS9FvxxjXQoj98xsYPStWchTG17tqdQDPnUpMpvOyyx5oIiW67CGN9
         ieDDApOITnEBhpuqDUkvonm9s3cJ6iWaqwGypaKpuZyqlQLsNZIjTVD2DXuZuy9MeMi7
         J5nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774969211; x=1775574011;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MLLxzw5GoGg/yFRLXTVGHHzH2KjcxDISY31IWyrVnzg=;
        b=pkz1wmPyU9p2Gzo+WDb661XGqOpA9fyb8B4HaShgZifKuhucsx8GCB/4CsG/g6Gc/G
         0YIQzjVUX2JnJRsLcuCgps3d1PAxhr2hueN6RNfijvhzw6qh2b4ulpdCi5LsOZ1DGBaQ
         foWi9GB75zd0uBUMbDL3wXA6+oAK/e3M2SmRIGiXkITHytyZTLiMbyxJ65YqlueejQ1l
         Wbx/3GMLWyKjGJGWr5tF76ZKrhi106NoyLz+RHx47n0cYw+cHkX0AbWZvehIUKg/YxkW
         ZLIvXeV0FO3879AlkGSYhukdYnwL8DxtUJY+uKemt/4U7hdefS33sh5i6kzOHItFS7Cm
         707w==
X-Forwarded-Encrypted: i=1; AJvYcCV90HvsHJQhXsqQ5riGu2SkOqig82/sVi+kentPBaw/jCp6FMTxzziKfSnAXKYziJXAilsYd4v40w==@kvack.org
X-Gm-Message-State: AOJu0YxUlRrram2y/8di/4TWsFf/257+w/DQMr3EFU1NOGNBtrMJvgfT
	aBf+kLIz3xYH9c09vDOS97PVWglulbFuwX5k6rVa4zuCOyRQOi6nDDgSsbRAbg==
X-Gm-Gg: ATEYQzz0tTDa4P9K6X/l06whSa3WEVnntF4XeglgoI3qoLS3C0nGrehpxGTWmRCig6L
	jU5y90rQSiWbrnTckRrG9ikstQB70aQrLgqB2b0sFJ/WUQiqqvdyQNL2IVJ07npjBHUWML/2XH9
	lrGChNq7nZLDvVx7KpGIEO85GPTSdS3t0hTV6MgBNzoGChXEPZkAk1ZFjyYpKVp2XxmU9qnj5U7
	ASw74OHmrlFrOWrESAhDlHqlv5faIJgiwQvmAuPERAezmkRlsoe87LOps3S/AlleBVAZ8O3qZtg
	/707COYqiTAmVar+lFWXbVmK4Dwvrt7eWqUrAtqKL1TZJKMlHbDLjolo0BSAbF9EdLuMyYiKkaa
	Bz8ytvUO3QEe4v8P93bEWyaSmiKxn2WajdaITsLi4CktHEU3/WN2KPwMe1esi1zcsotb6HcxWxZ
	pUkFK/G2jIZrn3w5FEGdAaoBY5vC6qqUuGv43/zHt5jiENxcbQHDU=
X-Received: by 2002:a05:6a00:2345:b0:81e:ef16:b288 with SMTP id d2e1a72fcca58-82c95eba347mr16752033b3a.22.1774969210580;
        Tue, 31 Mar 2026 08:00:10 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:898b:301c:d085:a35:99e7:ffec])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82cdf219c17sm2141792b3a.49.2026.03.31.08.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 08:00:10 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: aethernet65535@gmail.com
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	sj@kernel.org
Subject: Re: (sashiko review) [PATCH] mm/damon: validate min_region_size to be power of 2
Date: Tue, 31 Mar 2026 23:00:09 +0800
Message-ID: <20260331150009.5014-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331073231.30060-1-aethernet65535@gmail.com>
References: <20260331073231.30060-1-aethernet65535@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5069F14000A
X-Stat-Signature: buy9tprntirt15ggztqtoxksxybqprbe
X-HE-Tag: 1774969212-109853
X-HE-Meta: U2FsdGVkX1/r/fBQfHrq3eTO3UteYxWu6uMVI4WPVyM5dlajmNLjEiNHpaGy/thIeicjqx8UM0DNNSy6/d2emqP0LJnorxwvdW8TjZbCXFeXqiSIZasCs1ksklGS5xFWA73U/XdicH593oBixXlBo+XrO5ajm7AGjqmRoKFJtrfFpAbXwfOCPuXM5A0OYJx/MQEZgatU9tvvFpuF2hjtbl9iAtuwyxoV5edbJiL7HWQnljXUKMdfgkTQQHRjeRDqcAVLWtavO27I+fHpEz4tiBCOVgcgJ3VCUn83kPtlWJRgzEFFt1kTfg+MBY/Bio3g4CuDHUqhtspwFTA1wEsCK9qSgyR2F2MXHdMnUBTjxrUobF48E6Llh4dD6VLY/AhtJIoE0IQZLuyRPJd7+ZeU9yRi9RJLRtVxRwkTUdmtyRBH5toz+gxOyshT8H1z9uEq8c9S72Rg0iUqT9a4NAeI6/qVnarmUDmQ4Vv/3AuDrHHszH8pwUkYOZ9WAttIKOO40HrDHAaP683rHNm+g5bQ1Qr5sLWimCjlrtrP0Rp0E2litXQtYgElNgODlz0VhddTF+TsR5DKsCi+dcmN9+mkvHlGnNdanERpuLiwY4849PVT5OT0AB6Gl85aOS/JrNs7uXL+tpYZzd141y5ha5EG+G0KaxtNtX4bLNhOFcnEHwA2SOYQH9hScjD0kF/kzfKqH7A+c4/Z/6/hIgCimMixKN4bohZ5T3P676VnUHpupHjQz69bGi/8wr/LDADH9jjNJdvxvIh10s41gDEJMbRvson5wKh2RmPe6w+Q9CJZSnbf8nWy6uyciFSPSBxDb3vQkGMaCOrx8bhS/nC83eHlHeTfvow7UylmupIcToWGowfANriBr/UtXaocoCeoMV5cCrySUvfiZM4ntzGEh7uz7RXOtfMlewgIel+vSKTutfCNtFNTSeeyhxx5ro7rutJftoxGnBNlpwGv8gh26vb
 bE1ppzVf
 QbjnzWtwd1VBi49sWR3LtkQqkqOf20DsXtyC73cVjGySEgbE6SJugy5t7IeIYX/DxFa3EWLLXxhlaG6Uq5hWuZs9rAuxxoCZj45xRFwT7fVQJlnEXwcU4+rdFlDCpqr7rSYCy+kT/pXHcfQbUs1G6RCvc28Oer4WtmSlmzf7PfMavXHf/zUuxMxKtpWMShxvtuGC6mG16/Jh+LMj8JYoFwAuUTh9Pey1BMJX/pf03lThrXZye3hrtn4/bt+LDeakhtvxsDKOjlIQdIY45WCdqIsWNaDmAx0Dg2LRKLNUHpN26NSseb2awWQlgJHWov9UiEM+LRqnX3RjdnUsV0GT/gKcZnTZs5Fbgs9B+WW8UQIB81TqiZH7inNaqSgrXY73av6+lXghbMzzYdDdw7PaRKFnWpq0+d3XRb04X4tYJiTRnnvaQtppWXwqFabjFGga9dzJWTw2BhTEzoL14LlhnuiGqGz+hvvWuXITgP6NDwfy9P/6LDOk6zd326Cvrl1bNteI+1tbqc1tCXSH1R1/LFCqWi2IrSlF6H4OZ35zlWdH/Y0U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260331073231.30060-1-aethernet65535@gmail.com
# start of sashiko.dev inline review
commit 883916ab04d9fc6b9074dcd36200cd14402cc8fb
Author: Liew Rui Yan <aethernet65535@gmail.com>
mm/damon: validate min_region_size to be power of 2

This patch adds checks to ensure that min_region_sz is a power of 2 in
damon_lru_sort_apply_parameters() and damon_reclaim_apply_parameters().
If the value is not a power of 2, it returns -EINVAL immediately to
prevent kdamond from terminating unexpectedly.

> diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> index 554559d72976..205592194efd 100644
> --- a/mm/damon/lru_sort.c
> +++ b/mm/damon/lru_sort.c
> @@ -294,6 +294,9 @@ static int damon_lru_sort_apply_parameters(void)
>  	param_ctx->addr_unit = addr_unit;
>  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
>  
> +	if (!is_power_of_2(param_ctx->min_region_sz))
> +		return -EINVAL;
> +

Does this code leak the allocated param_ctx?

Looking earlier in damon_lru_sort_apply_parameters(), param_ctx is allocated
via damon_modules_new_paddr_ctx_target(). The existing error paths below
this check use a goto out; to ensure damon_destroy_ctx(param_ctx) is called.

By returning directly here, does it skip freeing param_ctx?

>  	if (!damon_lru_sort_mon_attrs.sample_interval) {
>  		err = -EINVAL;
>  		goto out;

[ ... ]

> diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> index 86da14778658..6e29d92670c4 100644
> --- a/mm/damon/reclaim.c
> +++ b/mm/damon/reclaim.c
> @@ -204,6 +204,9 @@ static int damon_reclaim_apply_parameters(void)
>  	param_ctx->addr_unit = addr_unit;
>  	param_ctx->min_region_sz = max(DAMON_MIN_REGION_SZ / addr_unit, 1);
>  
> +	if (!is_power_of_2(param_ctx->min_region_sz))
> +		return -EINVAL;
> +

Can this result in a similar leak in the reclaim path?

Like the previous file, param_ctx is allocated earlier in this function
and there is an out label that handles cleaning up the context. Could this
be changed to set err = -EINVAL; and goto out; instead of returning directly?

>  	if (!damon_reclaim_mon_attrs.aggr_interval) {
>  		err = -EINVAL;
>  		goto out;


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260331073231.30060-1-aethernet65535@gmail.com
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260331073231.30060-1-aethernet65535@gmail.com
#
# [1] https://github.com/sjp38/hackermail

