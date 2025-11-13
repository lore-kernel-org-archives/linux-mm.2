Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA08BCD4F28
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 179718E0006; Thu, 13 Nov 2025 02:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A578E0003; Thu, 13 Nov 2025 02:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0195A8E0006; Thu, 13 Nov 2025 02:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4E7B8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:37:16 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB71BBBA93
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:37:16 +0000 (UTC)
X-FDA: 84104778072.21.6072AD1
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0410640008
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:37:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="BcwDJQ/x";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763019435; a=rsa-sha256;
	cv=none;
	b=HEAINYlwRJ+O0rtNgXQtIFlRtlBalvbSUMTC2PL9wAg1xSWUYxh11IYkGm43jgHwutHcnv
	B/dROfhOFzP0kTslatE9+PgPYK//72z1tsxBeOYhqiOFcJv1hPEqeRFnOzx9B1YBJhDgWZ
	wwontwB/WqApWagX1u9qdg8xMHsMmEI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="BcwDJQ/x";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.174 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763019435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PWnM74uHFaI8W0wt5Su2D27ZxngaddFBBe2OQ2Sl5xM=;
	b=ABkYZCiIqViMPqMdXNG+K24/FJdI+3WqzrS0/78T3k9thbEtDME68uDWh+is0Blz53IS4+
	SI1TbZyQLGodeeXvLyk1mof7+HCkeBp7mi8o6D693DW3E0HRAGjjdAOUthA+apI+kjR7XV
	qxLw0VziZQCXabHdEACP0UmJu0RPV+k=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-bbf2c3eccc9so1305981a12.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 23:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763019434; x=1763624234; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PWnM74uHFaI8W0wt5Su2D27ZxngaddFBBe2OQ2Sl5xM=;
        b=BcwDJQ/xyLga7eFtb2ezuit59qJ5Z+gBBdpq5VjtLTg53/v1CZTsmQfIlhftI5MhwG
         r6NTOAJMryiAo6ykxQVRRQe96wO3YGCx6mkdoPbGqwE6ASEC/Tuou2h0Kiw80TA2FR7q
         7w2kID6CLBjvlojeOfSxeVFyGpOVnEIKbPNsY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763019434; x=1763624234;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PWnM74uHFaI8W0wt5Su2D27ZxngaddFBBe2OQ2Sl5xM=;
        b=rCAF0qmtTEI54zikaEj34jVS1JmGR5BddXDSSBYclRojNKV9CFhyu1FUi+JgZjYviE
         Lv/CxubMPl4T/VdqWLLQ8IY3uXYu9bt4PMox/bwEeXm744vk8L1QL6fMpd7kuTwQy592
         FYQhIW3cNw6yJNtBAdo8nv96i5j2oylal0MnQDeLOOVbIOpI/8NnQFsC5jVtg+NT7GDX
         nPz6hr1E06SCP7NhdsWrQnhH7ubTkWtN3UGI+HKCl81kv3RcHiZzWbcH7i1Ysg4tP+6E
         Yg8pQ76U6bMLuz4xkIzR5d+Uh04Q4v9rzvspQCk1WcjUwB91wSTUhvxv8ojDudrqgpkp
         SloQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwLjeb2h71fXtuJtS1FLaxw6NCUc3hSL2Izdj21AfQjkfeLEKq/Y3qZAeFiQl9V/1T7HEA0ih7cQ==@kvack.org
X-Gm-Message-State: AOJu0Yyy+W6W2qG7Lf2GAoMqxztbcagWxcOu5d+RvCqk+EJWmOVLaJfC
	qe2qNT7LRqjRWVPLw117hBL8A0K8r0vJ/R17iAhgSrl75JblNhslXV7vqyYQSidUmg==
X-Gm-Gg: ASbGncttYsDSv8t6Mr4otC8pU7WUJC6v3LEluabeY+4xNv2p12nSVczL1wGAq8EVcIQ
	b0l4L+JnoTYE7qmWqAOzuABLCwEzMkHwVWxMkiCCBpYJ7jEdAWAI1T44eZBGHr+TDRBsKWdayKv
	r0Vc6SJG24hDKi2X628rMsTNvm7nW0D2YKP76HPOzbcoa539K6TW1fkrxDkQBlmyw0Y9ZQgCMkN
	60b0/q5CR06iB3lncnohtTucaGBK3yvugG3t/JTTcoTP18iBvMaBYoc/R0qcjYLyNxmqewEcFdK
	0Z2IYouX8NI/IY9EJoofzPJ7vypl615RL3HMdYiIPuk1katdRQL5Wq9pdlrHQx3gVgmQlJyxW84
	OeeIK6raIHAoEBcDpgUlkki/5sG9+NGB10GX7SDyG/RuwueSqPwfD2GY1Ch19WjHIHjV6k+CQGF
	JF1LI+
X-Google-Smtp-Source: AGHT+IGcwVOQxenlEIltHqenht6mtl/LZ/PZU7x5t8ckv2TF/Hrj/8ENijWtytzcVZdM9dakholzmw==
X-Received: by 2002:a17:902:e80a:b0:266:57f7:25f5 with SMTP id d9443c01a7336-2985a4ccc61mr30548785ad.7.1763019433726;
        Wed, 12 Nov 2025 23:37:13 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-343eac93449sm917504a91.3.2025.11.12.23.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 23:37:13 -0800 (PST)
Date: Thu, 13 Nov 2025 16:37:07 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: axboe@kernel.dk, akpm@linux-foundation.org, bgeffon@google.com, 
	licayy@outlook.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, liumartin@google.com, minchan@kernel.org, richardycc@google.com, 
	senozhatsky@chromium.org
Subject: Re: [PATCH v4] zram: Implement multi-page write-back
Message-ID: <sz4brk7ixwzud4hzcgw65au6eto2y55thcku5ouo7x6ieifvlm@t3svlkcwcjb3>
References: <83d64478-d53c-441f-b5b4-55b5f1530a03@kernel.dk>
 <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0410640008
X-Stat-Signature: szj6xkdji4qwmx5uu6aizuuotes7n1xy
X-Rspam-User: 
X-HE-Tag: 1763019434-789346
X-HE-Meta: U2FsdGVkX1+Ki3AaiNIikbXFmf1M9MSFBF6xTR80Fqg8o8rz7l+eu16uLhEBfKRKQPpu52gtursVI+rVnO4EROEXeYNnjkmg0A8+6ghGEcmNTbpoKopNcHuYv/MpLEl++aoIh1k12mf2mTo6hNrX1ecvpUyNaY67qst0QImukzLBq4mGBBp+w9Y1QDUkPumqStY6rh6jwit9tutnL2qeYedrU9XUdmV+MAqEJSK4/yg5HsF0LUCMyiP9Vm8nJdLE5wSOyhiy/A0xkOL/E/Ch2fWripb+Gj1D2wtvpsRheQhh9Ya6EgaoOoIXMTA8PAih+eDic011+g2ZTndEBe8g92LO3Gm1KVT5zZCTR+GGsNFWVGLsuIYWtdrcmyD3qI0WAIn9bN5e8cyfD6YeomE4aJzU5ohjUHSA2k27+Jo/q48e5GTLPI4BdZUivGIcgR9CUZ1TLvSPWy7pElQD/duMkCVwcI/s4BvKbefsKD8wZ7QaMJ2Ff0QtbQ5CJzktKkh5wQ24CWC7grV0cHXpjlXbCGSEgUdFEDU5hgXqOplY0BpIPEIKsTslzSXPjX9UDPDLLwrfm/nli11O35h1QCcPoVbLBDJDZhjDSIdK6ey+x/zMaLnJO0sdiv4L6coJ1gqGVWtH1NwECNplLlDOpGI2KAyZ8nLXwllxzoxNXGFGPWyFmS71GdtfqoehX4rgJyGA12mgz0tvDGynIvOqZctN4+HDtOXikVvvrVN1H97vROqEcmEtJDtf7M7DXGmjdKVuScvNHyZ3dqh4uRpFQUtpITxKm0B1ZgGcZ1UEC6MnTIlDlTym0NXLC8oDOIqfEV1629Mtx/yGdL4JA/f6NNoRfNnKQgDr3tVLKdclWLc5MVuhLYn6ehOQ7bv+rPGYhFN2y9BbqRsYrT0+bFP91Cn/8peHjFctSCd01BSAsh+K/YG/oDK3FFGLaF8xXxJjplvC1U/olzvO+dUB41Yi5eK
 bKjVly7s
 OmHwmrvjU06+iC/wcVQYj9c8MIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/06 09:49), Yuwen Chen wrote:
[..]
> +static int zram_writeback_complete(struct zram *zram, struct zram_wb_request *req)
> +{
> +	u32 index = 0;
> +	int err;
>  
> -	while ((pps = select_pp_slot(ctl))) {
> +	if (!test_and_clear_bit(ZRAM_WB_REQUEST_COMPLETED, &req->flags))
> +		return 0;
> +
> +	err = blk_status_to_errno(req->bio.bi_status);
> +	if (err)
> +		return err;
> +
> +	index = req->pps->index;
> +	atomic64_inc(&zram->stats.bd_writes);
> +	zram_slot_lock(zram, index);
> +	/*
> +	 * Same as above, we release slot lock during writeback so
> +	 * slot can change under us: slot_free() or slot_free() and
> +	 * reallocation (zram_write_page()). In both cases slot loses
> +	 * ZRAM_PP_SLOT flag. No concurrent post-processing can set
> +	 * ZRAM_PP_SLOT on such slots until current post-processing
> +	 * finishes.
> +	 */
> +	if (!zram_test_flag(zram, index, ZRAM_PP_SLOT))
> +		goto next;
> +
> +	zram_free_page(zram, index);
> +	zram_set_flag(zram, index, ZRAM_WB);
> +	zram_set_handle(zram, index, req->blk_idx);
> +	req->blk_idx = 0;
> +	atomic64_inc(&zram->stats.pages_stored);
> +	spin_lock(&zram->wb_limit_lock);
> +	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
> +		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
> +	spin_unlock(&zram->wb_limit_lock);

This should be done before the submission, not after the completion.
Otherwise we can significantly overshoot the wb_limit.  And we simply
need to rollback wb_limit adjustment for failed bio requests.

Will incorporate this into next iteration of the patch.

