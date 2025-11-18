Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ECE1CEE347
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 17:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57ED06B0008; Tue, 18 Nov 2025 12:58:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52FB16B0062; Tue, 18 Nov 2025 12:58:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46C9D6B007B; Tue, 18 Nov 2025 12:58:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4906B0008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 12:58:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DC1D784F64
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:58:26 +0000 (UTC)
X-FDA: 84124487412.08.FB2BF53
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3F0AD40016
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 17:58:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tkcpWsQ6;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763488705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7D4xI2O/bB4EMoFw1Jg1PkaLfb/+AcsO0nuQkdjaCk8=;
	b=K4Qb2G/DLzl505KKFLCns8PH0oUbkyq1g5UFAqYkofAVqqi4pwTWDsAQlY053zNJy+UJuN
	Y1viiUO70s5a8RsTHKEpSniPxx8arBdKSNEPh+4WVvimDDJBbpdLUbLinmmn46LNgz37iJ
	a5LbPIoRjw/lmJAa4Zcm/g2jZJDn7GI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763488705; a=rsa-sha256;
	cv=none;
	b=7xY50zLrtjs7d6wZBNmuHsi3MmdbwQJGAFFQ4T9eZxjG3nDaM3+rNbOctfNUliD3kJCpmB
	+2DzvnvBZ5FwbwY9AlCvSumhaMDqP+jlRz5mXl60fFXUzztM2JhDR6eDwRhPkULtSmARG6
	aQcGIfnPFKTq3x/oafXVZmf5sjauzPk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tkcpWsQ6;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B27260B51;
	Tue, 18 Nov 2025 17:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DDAEC19424;
	Tue, 18 Nov 2025 17:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763488704;
	bh=gXLYFoI5HKY7XzkdKe3wBPCOcpuojDRXTSnfYbyW4Do=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tkcpWsQ6wQ6ft+VT1F4eerpYqic8MpMrWBidA6eNKsiaEuYYzbOBCnXiIjI9MPngY
	 Bc3J4n5aYkUOXdje5HtrVyQQr5TJpUzkCy1vIM9+bsCW5JR8cDh8dsMoanlYWpLMo9
	 cBdJ/a/HvkXNNfhHF3kURONhqZwQq8HcSotl9qsI=
Date: Tue, 18 Nov 2025 09:58:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: senozhatsky@chromium.org, bgeffon@google.com, licayy@outlook.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
Subject: Re: [PATCH v2] zram: Fix the issue that the write - back limits
 might overflow
Message-Id: <20251118095821.ebea2deea23aea6921866aa8@linux-foundation.org>
In-Reply-To: <tencent_2FEBA8888C5B7C3CC495E17C29EFE76BA805@qq.com>
References: <tencent_2FEBA8888C5B7C3CC495E17C29EFE76BA805@qq.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F0AD40016
X-Stat-Signature: dixkxw599ef1b9398ridukrb9zwh5bi7
X-HE-Tag: 1763488705-912381
X-HE-Meta: U2FsdGVkX1/xiX+VyLsWebxSWIDWGT8fk0KF7Ei32h6R0FM1ZxXf0teuJ1SQXkjgCMnXQJpzdi5EK5fMBvp5/Zwu0j5zpN4g/FGiwIaQP/WNDjlljwhNDO2a35Ds2ciU6zBz7HdgGZNl9dVjWtZOpjWZ6fvrSoTBI/CQUZA3LuFCIBtHyEf9Ft0ffv0fRTMv6cpESMod7Tn2i5o+hwcjqmykUMyRKf0EIjzYfr8lflaw7hcQobFz+by5q/Y349yYlu3f/8DOpx/Matoc+OZWWkkR3abc43ILT5mRaL35vF7IpwwsOtn7ehJy9zNUemh5HRYJ7L3vxPHVcLeosczt07VDJ7ZJiHmUVM1aZA2t9K2ptR8UzbV37hnfRYvSYEDosLbV0iIr1ZFs0jobOvwHUEbp07Kopa9N3QeRSh/m/v7Rk1mU5XbBYRB08vY2eDHV4bCMLWmYXzctZe0tO6QEV16QbFPV5FM2GlAzZMNgDb9M6hd2ZaGlrBh5uU9qcOz03KClMz3uSop8+9keCeUCotH3r0IEDvNmjrKiZfZiBUVKVyKW7rfTEZnNzyy2ycmMjaWVMs02gvBkG9u+CHwNCLsW673Z+Web4xuOD6OdFVI0fEnXrYu33GKAnFdfqpuK93MGkWXX5l594hbW7AFD0Re5mcpnzj/lYqqboFhoIlBtu2rTqHpP4lf6sJMUx2ZQ+D0faP2oRcScghGFiESM1oPpBBmVOcdfR3tlv6qutqHh1wzrlYvzSG5N0om6f5wLplt0YGN/SGXmc9/s78FitXxH3XNqU0AXbzXl+EyDoG9WFk+O40p3wYiGikLpngKOZ3CYjzLodUxBi3So7RnZ9WpmqHnY7zb6mj8h7TjQ/idguwUXvAbQ0BKBQ0XXEBPgmyBU4o5OfuPEbLBruTAKF/gMpGOULpJKu5h+71cEaHe0dVF9RvkjkjygawNQPeT8b6luZLfpx7UeH7FHWJZ
 0ELMxOgo
 QocRc23FMCQMh6x+FrsqNbp/nsl5PcJPcHkKZZ/cFpesrWadOMutm8lqez+fyqEdATis34pn9jHk4kLkz9cQw+PWqiz3AZF57A11YNqBIefGwj0cJDVQu1drTsKTKwO9WNKmeccDdBVDfFmP3bv1XO39zJmk1YTGP6DxARGv87lgj9buYERXosJn7cE2aUbuQyQ7gOi49lUYDyPr5wwdxbSwP2bOSjGWSrDGAIdEH+e6AbsYYWVXrkZKFBJnNUgsfXyigkIkcDzpZ4nc63Wpx9Dp0CngdOlw+z6rcoWMyLhuIcIVPhGpIPa/LLw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 16:15:50 +0800 Yuwen Chen <ywen.chen@foxmail.com> wrote:

> Since the value of bd_wb_limit is an unsigned number, when the
> page size is larger than 4 KB, it may cause an out-of-bounds situation.

Please update the changelog to fully describe this out-of-bounds
situation.  Where does it occur, why, how, with what effects?

> This patch fixes the issue by limiting bd_wb_limit to be an
> integer multiple of PAGE_SIZE / 4096.

I don't see at all how clearing the lower 11 bits is related to "page
size is larger than 4 KB".

All quite confusing!

> --- a/drivers/block/zram/zram_drv.c
> +++ b/drivers/block/zram/zram_drv.c
> @@ -579,6 +579,7 @@ static ssize_t writeback_limit_store(struct device *dev,
>  	if (kstrtoull(buf, 10, &val))
>  		return ret;
>  
> +	val = val & (~((1UL << (PAGE_SHIFT - 12)) - 1));

Needs a little comment, I suggest.

>  	down_write(&zram->init_lock);
>  	zram->bd_wb_limit = val;
>  	up_write(&zram->init_lock);
> -- 
> 2.34.1

