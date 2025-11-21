Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28F3CCFA477
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:40:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842946B002B; Fri, 21 Nov 2025 02:40:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3136B0032; Fri, 21 Nov 2025 02:40:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 709506B0062; Fri, 21 Nov 2025 02:40:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 60A5C6B002B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:40:29 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1724C13B0F4
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:40:29 +0000 (UTC)
X-FDA: 84133816578.20.4FD840D
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id ABE4540006
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:40:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=omi7LkTu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iB5F3Fi6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bE1pThtW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SWjsWaVL;
	spf=pass (imf01.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763710827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mys2BPFJCH5oizFPG/WlAUXda1ThHbvmUvInAZBoBdw=;
	b=y21MO0ty+9oUMRgeMcfB7ueJ0GwuVoEs24bxmP1zEiOZh4I1e5CGyQR9hSQyCaxLnTz7B6
	rL+7pr6mKxC89E+zAJfqse6afJ67ou+24rx0nvdICBk0DmukmZweubaM9Mb8bNvaMbmIWi
	pn6IhespdltD1Q6W0YNnqw2QpHh9lVU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763710827; a=rsa-sha256;
	cv=none;
	b=c1YKFOaKHSjmzXMiDlzM70L9fh2FKuMmingqpJJtqwONLhiBmqpPT1k4QvFGV8HE7CHKa5
	2zLHf23XT4DTg/qkaxvmGwYQciYtyfHe1DdAFN6y8FJS0clgiAL/BHrYfJt4byYfn2hLe9
	uWcez/ZSmAE3dSntT4UDj9i1beQvcy8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=omi7LkTu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=iB5F3Fi6;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=bE1pThtW;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SWjsWaVL;
	spf=pass (imf01.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A7C2A21751;
	Fri, 21 Nov 2025 07:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763710825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mys2BPFJCH5oizFPG/WlAUXda1ThHbvmUvInAZBoBdw=;
	b=omi7LkTugDVxF5Nnukp61nw+FMZQAQaOoqa7XtP78qpNRD4r9Ybzw1OEJ1ACJwGHJwZvfz
	GbZ4OfrrlVFFtGI9x1/ZVYSmotT3oRztURPViibmx+R59DzCqO8dn9a26iNFB2rNYqTpZ6
	4iXjNbrFweo4MulD7cR5Z6YJ4zcsAwc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763710825;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mys2BPFJCH5oizFPG/WlAUXda1ThHbvmUvInAZBoBdw=;
	b=iB5F3Fi69SHjwYpKR6sFrBbBQooHEkuScpG6axQAjoexyUof27UKiQmpSpnY3lFWI513Pc
	q1+OwmWTquZ1NVCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1763710824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mys2BPFJCH5oizFPG/WlAUXda1ThHbvmUvInAZBoBdw=;
	b=bE1pThtWpz2gP4AFcHvq6norUiPPqN5omu6vuBS/9vFaUQOvvscIwzFUXqdvcwFffXjOhw
	sHlWYuMNhuDZYNlPcn3Nl466pZF18hi/BQaKycc5ST4BbsyiteVYHCRqN+kud4X8l4jN9T
	aXLV8mHLz1+OiKZcfI5xkjj8ozJ1xM4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1763710824;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Mys2BPFJCH5oizFPG/WlAUXda1ThHbvmUvInAZBoBdw=;
	b=SWjsWaVLit7Wd6GzMWR5aJbdWyoHw5R/GTXC9m5it5fensjPDPJe+sd7trQy3CxRT8uc/+
	szFWrUBHIAElgJAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4B0C43EA61;
	Fri, 21 Nov 2025 07:40:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id G3i5EGgXIGkkDQAAD6G6ig
	(envelope-from <hare@suse.de>); Fri, 21 Nov 2025 07:40:24 +0000
Message-ID: <90c06ff6-009f-430a-9b81-ca795e3115b0@suse.de>
Date: Fri, 21 Nov 2025 08:40:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCHv5 1/6] zram: introduce writeback bio batching
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>,
 Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>, Fengyu Lian <licayy@outlook.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
 <20251120152126.3126298-2-senozhatsky@chromium.org>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251120152126.3126298-2-senozhatsky@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ABE4540006
X-Stat-Signature: 3uszkto91e9dzfzeeutmmyziwmq34ms6
X-Rspam-User: 
X-HE-Tag: 1763710826-87639
X-HE-Meta: U2FsdGVkX1+9y76okU4Yyu+Jt0HoIEXvNNxfjMy5XlzoDIPIfROqiHUQxTm389wcbO51XdQiKlJ1A8eyggeZw6v84BIZOGBx8Xz8YWyf1SHTjdyY5o8dduLxz9SL7Da1XpJo84shJ/jzFFNoho+7VnFNilu20vepriJlAf7A9/ixJ2jT9cqlyKK1UDbUwJdlpcoeSi3odLIc41QpJdiVCR2n2Ts7oB6q1uF4c494nTsLfOqSC7EWOkX9+Oj4WBHPA0e+T4NoL2ZcrssQ5uCEDE7GP+KfPK8UFddE4bpDg0sGJd9MVTJygBBo5fuD4z7bIkR2YGXj/TzvgCYpnPNaLbFfQOwC+PRbvN4E4R1zokaEVV8RyaudUZvNUKS35uYOSUc00fFqZjst00/5guTUO3wxg2rJ7hreG8sHu52f+hHwXDnmuI7rF/AvLTMma2izwkNEl9gU9hA/I0X21EKwDOaIo3SauqRxEghc3MQ9VzTXnYCypBxM3g4FAAOWWJemtpj6Mn8jkAhpCuBXCnaIFAkOA0QZMog3dlaSF7hiRt/G4N1aPOxcOCq4ecMjXj8SqaJxJr3QMBepkp0fV34Wm+5ETaeuWRNPq0xAyjSav7IeaehGheASABegq/puJg52KXd74crvJsdm2NfXxI5vgZrKdI5hjN9kLDJDzW/EcxWF2m9P3MyKOW6WgXJuHQLg9f2+YSpYjGd/20GGCzcFANkDP51Xl0l+Dy+UPmgkug8JzwYse2j2yxkyoksA16kgUn08QmaFvxLNVom/PWWXLcQPzb2beYM2gGo6vSd4s1W3DAocX0H7IM4cpO04FSxP/DxeKcaW3tCFrCOtFEppXrpCk20Lk8lCNOwss23IQOkSNJTH+8Cjie3QGEm3+wPNV1Hq7NGnLLB+AWke9pva1lON2W07pkJKHQmoxT6QNqhUpJDBB3Zcy3aTcYPZNcLGyXi8dernwmzcd2EUWVr
 hh1Al4bo
 5WI4r09BYdZlAxJepnL38PYBIdh498ENjYiJ9UuD8YyQ5nSJ+axqX7Kj8uJrxRTeapYB2hxlUqcJ5TTj9IptC04rXjm54BYWCyCwQ9OACs04hKEOo1MAoXiRhZ5UnTFISvX6he7UPGpslj17eQxr74dhHDMoOB8ZsyK7ReLCJn6pRHoPt+LCsL6/z08i9w5kwCPcsYe/OPqE5+TA07uWBuilolF3xT3IZIpbm+BBtEDvs75Bk5572Vz6wjOfXIBFsC9MP3kj9Plff22QwvZiauA/idyDD5gFtjDWVZRzf8bpMhLt0XlBvZBMaBcLtxTxH27fVpqgVpCWV4KFCo0e/4Ic+k/3PW17xvqT0msQDMKz+R35VkQL8cFwNYbSfu5Td3ek1Rt2MSaOthFR2ef+KRZF6KRxWA7Q79lP+l9i7x+RJed1IFDV31wXm4g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/20/25 16:21, Sergey Senozhatsky wrote:
> Currently, zram writeback supports only a single bio writeback
> operation, waiting for bio completion before post-processing
> next pp-slot.  This works, in general, but has certain throughput
> limitations.  Introduce batched (multiple) bio writeback support
> to take advantage of parallel requests processing and better
> requests scheduling.
> 
> For the time being the writeback batch size (maximum number of
> in-flight bio requests) is set to 32 for all devices.  A follow
> up patch adds a writeback_batch_size device attribute, so the
> batch size becomes run-time configurable.
> 
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Co-developed-by: Yuwen Chen <ywen.chen@foxmail.com>
> Co-developed-by: Richard Chang <richardycc@google.com>
> Suggested-by: Minchan Kim <minchan@google.com>
> ---
>   drivers/block/zram/zram_drv.c | 366 +++++++++++++++++++++++++++-------
>   1 file changed, 298 insertions(+), 68 deletions(-)
> 
> diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
> index a43074657531..37c1416ac902 100644
> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c

[ .. ]

> +static int zram_complete_done_reqs(struct zram *zram,
> +				   struct zram_wb_ctl *wb_ctl)
> +{
> +	struct zram_wb_req *req;
> +	unsigned long flags;
>   	int ret = 0, err;
> -	u32 index;
>   
> -	page = alloc_page(GFP_KERNEL);
> -	if (!page)
> -		return -ENOMEM;
> +	while (1) {
> +		spin_lock_irqsave(&wb_ctl->done_lock, flags);
> +		req = list_first_entry_or_null(&wb_ctl->done_reqs,
> +					       struct zram_wb_req, entry);
> +		if (req)
> +			list_del(&req->entry);
> +		spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
> +
> +		if (!req)
> +			break;
> +
> +		err = zram_writeback_complete(zram, req);
> +		if (err)
> +			ret = err;
> +
> +		atomic_dec(&wb_ctl->num_inflight);
> +		release_pp_slot(zram, req->pps);
> +		req->pps = NULL;
> +
 > +		list_add(&req->entry, &wb_ctl->idle_reqs);

Shouldn't this be locked?

> +	}
> +
> +	return ret;
> +}
> +
> +static struct zram_wb_req *zram_select_idle_req(struct zram_wb_ctl *wb_ctl)
> +{
> +	struct zram_wb_req *req;
> +
> +	req = list_first_entry_or_null(&wb_ctl->idle_reqs,
> +				       struct zram_wb_req, entry);
> +	if (req)
> +		list_del(&req->entry);

See above. I think you need to lock this to avoid someone stepping in
here an modify the element under you.

Cheers,
Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

