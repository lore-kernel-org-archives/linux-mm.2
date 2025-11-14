Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BAA0CDB46D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 01:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE0B8E0008; Thu, 13 Nov 2025 20:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D5788E0002; Thu, 13 Nov 2025 20:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EB2A8E0008; Thu, 13 Nov 2025 20:53:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4C48E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:53:32 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37DAB85EE2
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:53:32 +0000 (UTC)
X-FDA: 84107540664.29.CB8A9FD
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf04.hostedemail.com (Postfix) with ESMTP id 46CE64000E
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 01:53:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=l2q6OlkX;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763085210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9LDGlt5BP9HGrN5kDVPAodxjrvpp8sHxQXkzmFVXsTw=;
	b=4iY6kBSNOX5cI5uWyMPuN9sR4aWOUiXFL0mF7Bmp9pz/cx5T8k2l3AGTvY8StOqpi0idvL
	j/Qwyb1wX12P1FnRu1kHpYIuge0jigGtdh4xKyEvJKJKplrsefXdubzvDNTuWjPs7mYen0
	NV8wrNoDMQZ0IcIp8drs3C/40lMrH2c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=l2q6OlkX;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763085210; a=rsa-sha256;
	cv=none;
	b=vXM1srAjWHL4+QdwyFcvxTXWb960bQRj0v+lETY//SdcObVZy+dwFW2Oma+bhSrku30H83
	5RXDcptsR9ov1vOcl0ccL3tBM3d5hDX+i1yMRm+D5Xhm6TIalafPxR2LCZpORnhB1PZ8K1
	5sKX2pq1SscQfbeZJASzIePDcMOo+6Y=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7aace33b75bso1381909b3a.1
        for <linux-mm@kvack.org>; Thu, 13 Nov 2025 17:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763085209; x=1763690009; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9LDGlt5BP9HGrN5kDVPAodxjrvpp8sHxQXkzmFVXsTw=;
        b=l2q6OlkXj2D1X73YxNkZJaTXUBy2GimlIYS7KsujYIVZuKndTu6Dylph6BVaWzMKyj
         y/ExqHOE+IoIE5m/Lj3r2ouXciyF3RbghY4hvZekAQtH6TIuFliuV/tue3R4UOfpdilK
         ZWyQ54A32H/AoSBPml1wKAzrCGuo81SXhFvXk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763085209; x=1763690009;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9LDGlt5BP9HGrN5kDVPAodxjrvpp8sHxQXkzmFVXsTw=;
        b=YJGI3rI8jfOVSGhKqh3huoQSSP+W5Ek1QrEZ5FnxuJrq0R9UVxb8UW5frzBlj6zuKJ
         JFpKQL0jxbDcHgx+67bE540k2tCicDlHnRYMSlD8+63QcBEQWerwbNvPRYXw/uBWq0SA
         rCvQzGAPs+4R6tK5I2Y6chv8IYKUiUjdl6vZKc0cfgrHuylmNxBq/uYfDaBcwtHbf/Ab
         qqUujewdmflRCT/vfIeQ247lUd++7zIZOSiWPwOPqfXNt+0vpp2rJnJJUIgrMSFFOWvb
         6XR1/7jJeXSUmiW+VnNDUkp9Gct8TmOPHVR40Aq3hT+7uucWPg/bU03wpFIAP7y2Qrgf
         gtAw==
X-Forwarded-Encrypted: i=1; AJvYcCXz+2SNvsB93dfmTP9UQR5yF0AFBRWPdkbKcHFfl/GFr5RRwA0Zhco/jMh1itko69jEaJmMw+YD4g==@kvack.org
X-Gm-Message-State: AOJu0YyhcLV/v/L4njxx6J9oHw4RFYYHd2bHacW+QGZKHKy4V6LYXVey
	neocktCI/rP0dclTvhJfzk85KJq6IuTxyH3dCmch8SffFFDwwcGcPXSKK3oFOZC9eA==
X-Gm-Gg: ASbGnctKoiFzrgcBBO2QjR8iQrwag9OFhNKyvZBzQY9eAY+S/h1E6N46w32AOxw2jaI
	M7iOGgJ0FXDD7z9THFqhTdAUZCf8voXy+nFsghALnKbFYrgvfzN0/ZTtdVIMM6d+Azy7NyJE9Kf
	8Tm2wUO/Z+t8lRgW+XUsN53AwtOGSFvjvNK+qf1Zt4yeyb7SOnGN68DBXq/mPlxiXik9aDME+Ka
	kcTSWSYEnyh0gJCdMhSshFS4xjQGjolgrwkJ67u2B4qyU7kgnBmuEDiyZNQg+YbOIV0UyKtAmW3
	eYdTYPcCnkPcHTNL2LlAG32ub80fK2WcRreLm+uQXoqIcAYBjo7zIFZERHYoGvRVzLw+5MaT8Av
	eubQLU3+JKCZZ32BOJPQkz8S6SpHWPWW0H6McOYZfTsGuZDRhEmEWhw8gvLw8eeBNuVOy2+yxHc
	BJTIXb0Jg3uT+U8sE=
X-Google-Smtp-Source: AGHT+IF8knbLFGnSfk91LbrxqoXrIXu987LpSYmuVrZv5LzQ+C4wG/KgOmFWJ7dRbgMRz0JhH+7PxA==
X-Received: by 2002:a05:6a20:6a1d:b0:355:1add:c298 with SMTP id adf61e73a8af0-35ba047db16mr2310631637.21.1763085208913;
        Thu, 13 Nov 2025 17:53:28 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:6d96:d8c6:55e6:2377])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b92782d39bsm3518611b3a.63.2025.11.13.17.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 17:53:28 -0800 (PST)
Date: Fri, 14 Nov 2025 10:53:23 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yuwen Chen <ywen.chen@foxmail.com>, 
	Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCHv2 1/4] zram: introduce writeback bio batching support
Message-ID: <rjowf2hdk7pkmqpslj6jaqm6y4mhvr726dxpjyz7jtcjixv3hi@jyah654foky4>
References: <20251113085402.1811522-1-senozhatsky@chromium.org>
 <20251113085402.1811522-2-senozhatsky@chromium.org>
 <aRZttTsRG1cZoovl@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRZttTsRG1cZoovl@google.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 46CE64000E
X-Stat-Signature: gqzdh4bj7enquseezk4x8nsfqea1t414
X-Rspam-User: 
X-HE-Tag: 1763085210-581214
X-HE-Meta: U2FsdGVkX19iIcfo6byXAmMkkMd7V4WXgwYaizKS8OBVNKwFnPa3owY1zJcYlhm86Bc41mmOfapQFV+2XDyQA1IgoWRXPLuJSblNfMY0kmRE1LU6y0SSyW34jx/DRIuHobbuhqaSVEthbFbcx6+a9MVoMFMr+AvF3gpZEIoul5tBcYf9bR2WPUz9ygCJmZWAEnxsG82JG2nd2H2d2KXX7Bn61o9HWwsisxTHBo72jF/1mzxKKkMsmiVzgXepwwYXnRjDELnMPN/lY11Zriy80CCm6oaOLgAIAFZ6ewV6N4tcfNFOd45fQQlBQdD9sW1wz0nvJ3uNXJTk+um7jYLednYVd8fRho+VvBDB5F1I9Lp3lpfLAGQg0dLiT3wOrt5Gp4Cqb2KZ8Y36K+U+aMHVUVRrCI0bAKGx3cj0xI18i1bkp20h+tJ42PAz8qJ/eFY8Aoq37qnIjBN8PCx+6BKTW96COsQ/AQOpvn5htFTYtaI0+HRVdJmwc1eqPbQhgl1tSd2qKy/+uJUC0cD6AQfNg+rZ6hLWZp3XvfHskOysbsqnGYE7acSzLR/eGykhG1FGCXI5I8yRlxHjpE+aC5OBcubSOSkjpZssku/Q0A9fuIGssFoqAf0jqp0REwtwZDIYWccOHNpTtee19WMtjmYs3Xvu53vyjPVBdkJHHw8/TgKBfw6Y9jCV/NseMQw+1bhK8iW4er0DRiNbbahcz4akfY1bSZK1pBQSGhonSQbIRGipGMrbN11ScC7qKM7nupxpjhZu4mkd0zKuzYzWSS9FmCs1AkoI8dEdOAU+GSHXSWIZMC1CH0ISgHuZTdoumLCBhIjIxMhvT0Dabo/9eL2rHWDcY5tHGtEJQtJSVY1eq5n+RLj1qzYryeYvQQcZPCqk47KJ+5qJtouZgdpRB6k1f8IRfFpWUiYLNpkWDE5fDjxa8kQDv6Zw8UYlx3u9DACeZPOVCnNT6O4FAvkPfBU
 i/cjig6j
 vSQor6lkf+OChFPV5rEY1ry4GWRmscl1Eqn9s6W54Yu+OdXeOBIcj4sMlqW+XyE9FtiAQVM888BGRn1XDNxw0uFQyWdG+KRAd81Es5GRlu2XrYfSANeBPo+S3IB6t/XnFtfTpLcX6lpzRx5V648/pduVTcweOmNz8t2BsXJJY+xWWeDAQswMQDE8Anr3dtaq+gY87G023YO45Pd6teTFmL73XMYNmAl5SOtdhp5TBrCzJj71U0BUh2s5pZdhuNzlgs7CvBf1DEYNA6cM5XQqSEtby2tY/zf1fevJr9dPA4zV3I49Eb0SGz1BwRBxHwOzF/cLMHSTsDnaKTUk6uIrPvTidpbw2xmErn5rYNVV28sWLWgo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/13 15:45), Minchan Kim wrote:
[..]
> > +struct zram_wb_req {
> > +	unsigned long blk_idx;
> > +	struct page *page;
> >  	struct zram_pp_slot *pps;
> >  	struct bio_vec bio_vec;
> >  	struct bio bio;
> > -	int ret = 0, err;
> > +
> > +	struct list_head entry;
> > +};
> 
> How about moving structure definition to the upper part of the C file?
> Not only readability to put together data types but also better diff
> for reviewer to know what we changed in this patch.

This still needs to be under #ifdef CONFIG_ZRAM_WRITEBACK so readability
is not significantly better.  Do you still prefer moving it up?

[..]

> > +/* XXX: should be a per-device sysfs attr */
> > +#define ZRAM_WB_REQ_CNT 1
> 
> Understand you will create the knob for the tune but at least,
> let's introduce default number for that here.
> 
> How about 32 since it's general queue depth for modern storage?

So this is tricky.  I don't know what number is a good default for
all, given the variety of devices out there, variety of specs and
hardware, on both sides of price range.  I don't know if 32 is safe
wrt to performance/throughput (I may be wrong and 32 is safe for
everyone).  On the other hand, 1 was our baseline for ages, so I
wanted to minimize the risks and just keep the baseline behavior.

Do you still prefer 32 as default?  (here and in the next patch)

[..]
> > +	for (i = 0; i < ZRAM_WB_REQ_CNT; i++) {
> > +		struct zram_wb_req *req;
> > +
> > +		/*
> > +		 * This is fatal condition only if we couldn't allocate
> > +		 * any requests at all.  Otherwise we just work with the
> > +		 * requests that we have successfully allocated, so that
> > +		 * writeback can still proceed, even if there is only one
> > +		 * request on the idle list.
> > +		 */
> > +		req = kzalloc(sizeof(*req), GFP_NOIO | __GFP_NOWARN);
> 
> Why GFP_NOIO?
> 
> > +		if (!req)
> > +			break;
> > +
> > +		req->page = alloc_page(GFP_NOIO | __GFP_NOWARN);
> 
> Ditto

So we do this for post-processing, which allocates a bunch of memory
for post-processing (not only requests lists with physical pages, but
also candidate slots buckets).  The thing is that post-processing can
be called under memory pressure and we don't really want to block and
reclaim memory from the path that is called to relive memory pressure
(by doing writeback or recompression).

> > +		if (!req->page) {
> > +			kfree(req);
> > +			break;
> > +		}
> > +
> > +		INIT_LIST_HEAD(&req->entry);
> 
> Do we need this reset?

Let me take a look.

> > +static void zram_account_writeback_rollback(struct zram *zram)
> > +{
> > +	spin_lock(&zram->wb_limit_lock);
> > +	if (zram->wb_limit_enable)
> > +		zram->bd_wb_limit +=  1UL << (PAGE_SHIFT - 12);
> > +	spin_unlock(&zram->wb_limit_lock);
> > +}
> > +
> > +static void zram_account_writeback_submit(struct zram *zram)
> > +{
> > +	spin_lock(&zram->wb_limit_lock);
> > +	if (zram->wb_limit_enable && zram->bd_wb_limit > 0)
> > +		zram->bd_wb_limit -=  1UL << (PAGE_SHIFT - 12);
> > +	spin_unlock(&zram->wb_limit_lock);
> > +}
> 
> I didn't think about much about this that we really need to be
> accurate like this. Maybe, next time after coffee.

Sorry, not sure I understand this comment.

[..]
> > +static int zram_writeback_slots(struct zram *zram,
> > +				struct zram_pp_ctl *ctl,
> > +				struct zram_wb_ctl *wb_ctl)
> > +{
> > +	struct zram_wb_req *req = NULL;
> > +	unsigned long blk_idx = 0;
> > +	struct zram_pp_slot *pps;
> > +	int ret = 0, err;
> > +	u32 index = 0;
> > +
> > +	blk_start_plug(&wb_ctl->plug);
> 
> Why is the plug part of wb_ctl?
> 
> The scope of plug is in this function and the purpose is for
> this writeback batch in this function so the plug can be local
> variable in this function.

ACK, that's a leftover from when I manipulated plugs outside of this
function.  Now it's completely local.

[..]
> > +		bio_init(&req->bio, zram->bdev, &req->bio_vec, 1,
> > +			 REQ_OP_WRITE | REQ_SYNC);
> 
> Can't we drop the REQ_SYNC now?

Good catch, I suppose we can.

