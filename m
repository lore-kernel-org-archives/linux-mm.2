Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E75C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 08:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CCE06B008C; Fri, 10 Jul 2026 04:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357256B0092; Fri, 10 Jul 2026 04:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 221F66B0093; Fri, 10 Jul 2026 04:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFF666B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:24:28 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7A4648D9AE
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:24:28 +0000 (UTC)
X-FDA: 84972180216.15.77DA539
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C98AA0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:24:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G0XVHYl3;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783671866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYNzOD1GcWAIhXgfXQt5l/kqnxCuXuRLWYOwQqPDlJk=;
	b=7qXwQzAcE3cvVZelGAXkWVNRRFjphN3A9QlbSIvGGWX3Zy7WKmdKdzZjWd2ZI6HNnNchOa
	yDhA1lLdxQyDnWZMqRMz29z9P6oDAZARCv4AT6dnFrb1uCa1mZIbk91YTZGojozhDwOkJV
	sRGnfK54ZZYOn57xCq1z10X1q5GTQwA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=G0XVHYl3;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783671866;
	b=iXs4ZLFm2I9YEIpppc/goXmzJqRR5m74s5nDuR70xInok4KSowisBNjU2s5EVvFLUO5LQb
	Cfj+mDzEhG4sxqSeRrCygmzm5uZ+D6KWNU8WbSlr+tF6F1ijo5a/zBm1NP0y/PC6IYN2vo
	5tHo2SgYbjbcRisnNtuAbYjfhDJKtas=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1656E1D15;
	Fri, 10 Jul 2026 01:24:21 -0700 (PDT)
Received: from [10.174.42.251] (unknown [10.174.42.251])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 853CC3F85F;
	Fri, 10 Jul 2026 01:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783671865; bh=HwhvEkxqat43Xn3E6NAymJDvmzKSAfufM7rsYSms4Zc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=G0XVHYl3glbJJqU3GU1Aasyd6F8eB4lHtfSsljGrI6Id/FiAMcGuBTuxgysiqQnKd
	 MfUeoGtNqzhVoSM/e5qvX1XWjHm4tFklA6QURPAKGToYJVNdSrlec7KiOR/j6siw4G
	 4v6rdYinaL1erVhjTqqKi+tulw6+iTx2r0wDSmJs=
Message-ID: <8182d981-cb4e-4c76-93c8-b48173e2cc12@arm.com>
Date: Fri, 10 Jul 2026 13:54:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove wb_writeout_inc
To: Christoph Hellwig <hch@lst.de>, willy@infradead.org, jack@suse.cz
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260710051052.1839523-1-hch@lst.de>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260710051052.1839523-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C98AA0004
X-Stat-Signature: utgjidgrudspn1eobzi3dpnq35y4bxub
X-HE-Tag: 1783671866-785136
X-HE-Meta: U2FsdGVkX1+26UDGUsfdlbTt8B41Ip5nmWRyL7rBMUG7xj4mlEFXBzscSoDo4OMH1GIh2/nFIr0eZvxNOsIAFWv/psGZgL7ic8oUtuwYNGjxaD4cFK0xmsualiCpvSS1OLmSzYpkALp+YhrFkW+RtLUMEQMwXky0cx5zHcS+xvRfU/JSPqey/h3EerXf+6gypN272v8x1QhQ65YjLvuE1G1hz1gnJoTgwf0Bp789Bhaah67v9lbiPm0feTB5cszJ/YxivmLIoj/TZ1W4eOtWgIyv0gyNcxFO/GPgl2EoxYkTIuxT3YYGHBKWH5Vy1YPMDVeyijndg+BwkRa56B778HPSwYjVH9ZOweWljiZO6nIANf8skiJorPtYy7SulWxDZJuYQoM3ODULUSvgXyAC7Ep9N7UNB9X6tsh15waTIoSF/IcvwAWA3DgWEBBc/Yo+9c2peZsLa9EU1ZWig51vx7HbRRogaoX3uykA1f3ArflQMo8vYD4x9QLn6S26Gq44c5r6PpWWOFDxjWevut4pYYU+0xh163n6mjLoAiiLEVf2MHH5slgl8QyWR7tjYZ7+Df4dlT9Zu9O8loHJk23I8KZi1K5IUupx74sWtjRqirn7nZ+bjs8kpWNsjGXjRRH0iJy+1LRhzbOByeJbNATymrkrpkkWdgfiNfKpfApvUBt+Ymmgrxc/XfVKtLEW4udmbsa6qQJnVop9ac8/OtEGpApiPXygIUJsnyHmRO/ebWBiVA5cMBaACGdv8cqjBpEnEkglgC9LosbtH4VdIQK1uBfTfmcnAYDHSXr3mnjOxxgfCZuXfgt3Rmji7UiGIyfuK7uIYYrdEm0VRTCevBbmwA5Hcwz2y4Fyxp5h/Akct2FlnGyp3b/iCB6OTIroLmPV1c4MhNKJkbU5oNwAbB2Pg89y38N010PxyCZ6tpvFZYyyT8gpDFnHl1irWfxEVRPtME1p+PR4Hze6mEpv09s
 hike+8JU
 t8Q13WvnPTkEuIVBP5AMD9opdgXFBaiLJx5YTEhQWqpvccHg0uoO8tYu+QEzsNz/NfEkEGUAFidB/4KNFG0uUvmd4zh2OsAP8Bnkdj0IDCdUvgpSNZ3ltcqCR+dcseZ2EjqGOrAQlPZOd7lugB12+7HVYo0tg6f4+af8ZSYKDJaR1IUvpRsgJMBj5xKLtRnylxEkaHDTe2RFOWrg8Hp+H5lffqidzRfVErBZpW2YnGYB6OR+Q2392UyzdwVpbwueAsELEwCHN8XUPrHoZkzsu7OUEl228DyWc+Q8ro4BqPwAw1V0dQBBgb00L05JYacUkChq/zTlNCweOlR58vGa2MNn/HA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/07/26 10:40 AM, Christoph Hellwig wrote:
> Remove this entirely unused but exported function.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  include/linux/backing-dev.h |  2 --
>  mm/page-writeback.c         | 10 ----------
>  2 files changed, 12 deletions(-)
> 
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index 5b7d12b40d5e..c2284466e7aa 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -76,8 +76,6 @@ static inline s64 wb_stat_sum(struct bdi_writeback *wb, enum wb_stat_item item)
>  	return percpu_counter_sum_positive(&wb->stat[item]);
>  }
>  
> -extern void wb_writeout_inc(struct bdi_writeback *wb);
> -
>  /*
>   * maximal error of a stat counter.
>   */
> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
> index e98748112d1e..47495be68598 100644
> --- a/mm/page-writeback.c
> +++ b/mm/page-writeback.c
> @@ -584,16 +584,6 @@ static inline void __wb_writeout_add(struct bdi_writeback *wb, long nr)
>  				       wb->bdi->max_prop_frac, nr);
>  }
>  
> -void wb_writeout_inc(struct bdi_writeback *wb)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	__wb_writeout_add(wb, 1);
> -	local_irq_restore(flags);
> -}
> -EXPORT_SYMBOL_GPL(wb_writeout_inc);
> -
>  /*
>   * On idle system, we can be called long after we scheduled because we use
>   * deferred timers so count with missed periods.


