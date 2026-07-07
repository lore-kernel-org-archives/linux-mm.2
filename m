Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C6F0C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 08:15:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CF056B009D; Tue,  7 Jul 2026 04:15:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07FF26B009E; Tue,  7 Jul 2026 04:15:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8A36B009F; Tue,  7 Jul 2026 04:15:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C619D6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:15:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45C00A0351
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:15:28 +0000 (UTC)
X-FDA: 84961271136.05.436FEAF
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6A279120002
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:15:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WAtV+HUA;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783412126;
	b=7/P73ylK0xIUV+TgPd7kXbgai8dHdDZ2CnRAQXC/lakAVjkXmJSc8YYsnGgdXqmE9Aet02
	iPgshbT7B9lCpomRve+k7bLink97O2tRg7ESlgLi1WXEHauu/WGgAQYVzbm5bNNE/a2v6n
	L7QeVGPRoP9tuCy1Qgsl7fGQWzZvu4o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=WAtV+HUA;
	spf=pass (imf29.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783412126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o75N5zPxXsSWHL7mx09XIMCEEx73pXQfavMWQ2tVG4A=;
	b=Zy6LeRvrsi0ZnlLIE9js19E7VbASOzJUzN8CkJudws0HebTavnwNNqCC28uIUW76gRCv4C
	SauyFYCFzj3PFB8bIdimyi1lw0k9VaMxS3nI/1d8sZwoYjuF/1xlmf358NF0HtjfmhgS/U
	dz6Z3hr4Jn2MrQU9a4y8w9aXeMfa164=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cae134bdc8so21586005ad.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 01:15:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1783412125; x=1784016925; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o75N5zPxXsSWHL7mx09XIMCEEx73pXQfavMWQ2tVG4A=;
        b=WAtV+HUAq0FQPNuDCFsX59oaINtmD8TeVRMjtYYSf23THX87nB3MN6/IGV7VBIxDWV
         SnA5qhOWAw90CX4uj3lkkWnzueaOnirCRlNYaOoWDda+H24s7UkQefLRdq1bXwBCTzPi
         rAgXaO7Xajh1d+SedhnxkeX0tFn8oOas+UDes=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783412125; x=1784016925;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o75N5zPxXsSWHL7mx09XIMCEEx73pXQfavMWQ2tVG4A=;
        b=J3hNqB7VvVB8rzO518jdjcupWI/4wH2pwr0GjGfbtdGNbxjBQcS6dhv0ou+mpBFFn5
         7XNr30T9VmF2oHQEG35VO58YCSEQmP9unaj/VoFGOnxQEb+aR+em7B105JFwazP4kX+t
         e1KKADX3FYd57CXGAHcDIApUAZlas+i8KRJ6tiRQmMAzP/ZrdTFkDtWTidqvKEQ8WIpE
         sF2WeFkeKBQZQ3HOvCwBrPL7z0XIDsdWPZCHrPTBTope2vGABsPoWUQ+PXYQ7iC9Y71U
         XqqulI/20w1U/Ol94csK+WztdlKlNbATLL98b3tjTALoCYy0JOGZMAi5mWR6gyMq8GZE
         m9uA==
X-Forwarded-Encrypted: i=1; AHgh+RrNP44h+lKxDOrDpCHNBM+2o+WbNciXgPVV7f0XwoMX7UZrME9OJUsn/PbDv5g/V6/QadhezliAKg==@kvack.org
X-Gm-Message-State: AOJu0YzHeSOkeKbyu/DEBVJxNqYDAJzM6zmPGHr9ISHX3F5Lst7UJsfg
	Txs9e8CLuR5MTi5XvTI7xX0Sxms4hH06/C6Wp3CfoiplAsq+QUJQzoG+QeuqKpqHmw==
X-Gm-Gg: AfdE7cke8ntb8iHPrf4V9m0g4JTADAyfM7cN3c2yaqu8swlMLLVkjImqT60JEd3e4tR
	SGatk2lZGa3XdkFXf8i6RGS77hFC/eRfcYZ2Cq4sijB4MWORZ4h6dkRY6NBT79QEg2UccA1JXiW
	Qg2KTCtmU2Ndgnyk1RDOq9Akr7jtmbg40kXcrI4AdLCcrT9owNH0kTiu/Jdo6kRxp/tS8T+uGJr
	ZOf5gZGhnL52mfP+l/Ij4gYMy3noNjmff4y9uqfeqbG6i5fkkeZS/+6AoJ/YgDY+PlxfS2+VmL2
	LEPEt9E/WH+iSWjNPWIQ7Bl1A7JTinSAqHY8MxUPjhxc0P0KdVAnaVAdseG5ts71QdhR7h9U4xP
	e5WVQQW6AHjK29iORQnMhB+Uovfu2V6FjS//YlTIXcy+AksQoRB++L1mNAHfKtwQdnOB8NgHVOW
	LO+ejGncovR1V2eq/7Qe+Ap5aghOtg+zqntYsyOtUHW4vQA0Gtfl6O
X-Received: by 2002:a17:903:983:b0:2ca:2079:91cc with SMTP id d9443c01a7336-2ccbe616759mr45182285ad.5.1783412125330;
        Tue, 07 Jul 2026 01:15:25 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:d4f4:6328:49c0:b912])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ccc9d1ecfesm7420045ad.47.2026.07.07.01.15.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 01:15:24 -0700 (PDT)
Date: Tue, 7 Jul 2026 17:15:21 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Hillf Danton <hdanton@sina.com>, Kairui Song <ryncsn@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10 01/19] zram: sleepable entry locking
Message-ID: <aky05GBxo4VKGD58@google.com>
References: <20250303022425.285971-1-senozhatsky@chromium.org>
 <20250303022425.285971-2-senozhatsky@chromium.org>
 <20260707064030.D843llKh@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707064030.D843llKh@linutronix.de>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6A279120002
X-Stat-Signature: opyhiwwarn95s35odmp4cqx4xus6akmp
X-HE-Tag: 1783412126-645148
X-HE-Meta: U2FsdGVkX1+GJjWiq15iEP0ScPP+ciQAYaPnNXfJxBtkuYrgUB34ylGk+vOy0QAT/wvlfNfPso/XAGpYRW1e2IHqrKFLZV93kOFUiIi/ss/Lz2zFLZwrXMej34cA9rQj9RccpvUp1W5lbkRXa+ZTTm6njmGf69yFurB8apnBQ07kxaSciLlr1WmtmnZnaf4yh3REasI2IPYuhTaWJXgwQ8xyyH94kF4kp2+KCNdBT22g9rjUASPOav/Xepmbmqk30wfpTYacd4dozJepcgU4BuXUfAzpiqk+raXGaFqQaBE609ucrHkOLC/pHnV/oRkxMcKwDsUXN21gqgWCfYZSl74VICVm6ZNPxUsRku5pdkCG31NGt6/+9FfUwSmf5La2VrkACxcKLFeUH1nrxdkR/BhdetmnjVwwx2RxUwSHhl7zrFzhE3+MUTDjwuAvLVe2s5k112GN9n93F3nOJFOWe55SVIPZNU3ld64KeyeaqhPbieq8rxrYQh/Z3aejSp2ZcfJimtAlEj9wOJHpkQuwaovfzGMetVg41HykWNtmDK2924vf7heXR2CVdj58+fvuPichnCpLLcBEqwfjgBkGNmkH8Uosb5fqjmga2tLIcJXJ7Q7ir8aFdC5B34ubJQ429sybxzu5cviWtZXFgoSdde+kmY9Q8qf+7+PLP6cbIocIv8WiKhUTRMzY8GnLDoV4fGwFFdxceYd6ix3MzJKk5bStiXUZR7n6Lws9s3phv1g0BL8t9gRrIJiUyQ5i8W8AVZx8Szje3TuQipCm93UyiR7c3gDavhcsvck8PxKUSt09hOis5HXexXCvOHwBcZylH0P7lWt2g70f2Un0h2gduuu2x9+CS/8kn6OR23L7gl7vvm7ELPFrZ5Bsb0D/Dxw4FGX8sccnzGtQ+NlwR2LdisZkwIR4nRKCfreUL8QMxz/k8hwFgM+0sFRC5WlbCPHu/Jkw33tR6lnVFP+5AVQ
 ARl4SrMg
 Md/2fPfJxnCt+wjFgJZnIoP0zDFSXwRv4jLToC0ibSc5I7gsOoJHXQTAaSt/sZug1xq6hfpdW178kEjsu6I3pgyAaCX2cbEe12qrHjYp4FAKM9ZmT/d+oYGX3JtTEEffn+c9ZbaIVfjr71PGDu+JFD7mVB6hyC4J0JBSEQO17SAuQDgKTg2TkyK3mmPNpfFzDd0F3rR7SaSMMGgwHygdX7v9DbFPIVCkuYli4ApSA7glF5uUf8gPFQ5/T4JELxi6t6ZRNU7qvZ4d2EQnvetHzHfmlgndKP26lIWvK74GOa4loB3A2zJ4v1VC3XaQLnAk0V4hWLfWCDWAcVgniTrxRqlQDJr8H+KLKt9OIEjhLWz0YS14=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/07/07 08:40), Sebastian Andrzej Siewior wrote:
[..]
> >  static void zram_slot_lock(struct zram *zram, u32 index)
> >  {
> > -	spin_lock(&zram->table[index].lock);
> > +	unsigned long *lock = &zram->table[index].flags;
> > +
> > +	mutex_acquire(slot_dep_map(zram, index), 0, 0, _RET_IP_);
> > +	wait_on_bit_lock(lock, ZRAM_ENTRY_LOCK, TASK_UNINTERRUPTIBLE);
> > +	lock_acquired(slot_dep_map(zram, index), _RET_IP_);
> >  }
> 
> Looking at this, is there a special need to have a lockdep map per
> table? Wouldn't it be enough to have one per zram? Logically you use the
> same __key so I don't think it makes much of a difference but you could
> lower the memory usage a bit by having less of those structs per zram.

So the idea was to separate lockdep maps and keep them per-device
because various zram devices can be on different IO paths with very
different locking graphs.  E.g. zram0 can be a swap device with all
the locks that swap layer has, while zram1 can be a "normal" block
device mounted with ext4 with all the locks that ext4/vfs bring.

