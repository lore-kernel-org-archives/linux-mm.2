Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC22DC87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 20:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44A1C8E0003; Mon,  4 Aug 2025 16:56:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3C68E0001; Mon,  4 Aug 2025 16:56:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2108E0003; Mon,  4 Aug 2025 16:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19B3D8E0001
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 16:56:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F1BEC0902
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 20:56:07 +0000 (UTC)
X-FDA: 83740282374.10.C7470A9
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id A73D012000C
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 20:56:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IBEtHoGV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754340965; a=rsa-sha256;
	cv=none;
	b=rmyUlgpEgLDbw62x8ZNj2stiwHrPTM189iRuCd9kRk0NOmZoMNRO3ZU88GbInCsbTod4kd
	V5GSeDtRW5LLKwMRmrnPhheHY5g3d/gn0hBB2T4VF0XfiNGWrDQskoo40Xj7zt13acIr+g
	9ER+0LsC1q3RxsPcbZjhQe1Tz/kfh7Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IBEtHoGV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754340965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LL+S5D3D7UenNPgK9Ih/dkviKSFLuvopByKxtWxxp7k=;
	b=WqUbmlIrD3PbEoUfsLKqTUS57QmYLbuvlH947IpM4KJW2eumjO3C8i0aUF9FDaHl2kPNzf
	siKpiVlEYLNe9ZSVUhS9CN6+Lypmt1hRpjFJV9BzjtESVdOzJPJJIJypKOG6w934D4mmmN
	OLQB5/yUBZ0LVHgdj98M1ME6s9qt26c=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-76bd2b11f80so3954088b3a.3
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 13:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754340964; x=1754945764; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LL+S5D3D7UenNPgK9Ih/dkviKSFLuvopByKxtWxxp7k=;
        b=IBEtHoGVtKjrkW1pCPiPsb3Yo2u40BOEAXHqsFGopMwBj/ZEmTvfm8CN5fnFJROyDl
         eR4gxO5d8DE69OpJEf/nrtaQTlw+6w/zqYyKyGNJphuaD0pMy7yuU2yzLD7H1NsWm/93
         dnB6r+g/+jPIZ37yvOnkUEXoT/9tm1seS3HpaqXTwzzSsliLfs5SiNXSfd+0TE5tweRg
         e1vOGLYYvQ/a8jwBV5YIpXOAL86b6+lWBx8tVp6PejFdbiEru5qSZci4Zyy7QmhIzM5v
         xikPeG1MMab4LSyz0b6NnZ6fvnW/ijwFBKdQ+Knngs/E6EsXZvkHjhI3oMiy4368xFtq
         QT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754340964; x=1754945764;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LL+S5D3D7UenNPgK9Ih/dkviKSFLuvopByKxtWxxp7k=;
        b=j8YcxluFImpUI9l4K2ysfnYe/VdSI+NIDHkDoBwVR0t4xKdFlePRBNJg+6BT3z78KZ
         VVWmyBUgjktuqYtHkR85vlsuJCZC5St/xVFqt03jFxSb4FwkKWM9mrMJ3cMhz62P26VO
         bV9h92oKLaImtuP+66a2/c3pWxEhoyUN5kOMewGhECtygoETw2mfyhkW3pLhfadS9EF/
         xv1NaJSOIqpGNP0HxK2oIVsXtaeaCgsj+rNST5kOCsB9zPMNgPsffQrYKtPlFCpH04Qi
         0kJ9k4v+71rTzAMjm2wDHUtrIWSMwAcRtZCNSFLt3UYIOm5CEsZIbBrnv9SDxdQaBEqD
         9bWA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ/KbLSXho2khvVg2O114Kzk+p7l8EX9KTZ97clBIpZ1drQm+vchJZXSqGYbGuGOyEGeA1koGZ2w==@kvack.org
X-Gm-Message-State: AOJu0Yx1mITVIlykuwO/l/DQLpHZT9uUglhnF/dNyiN+ldHlpXfbTHBO
	SKXGvJjh7uGV8kd8xD20RXk8LYyDGzXd258hDx1DIK06GQqQ1osx0doJ
X-Gm-Gg: ASbGncsOGRH9AQ6FNTn040i+/qBx9Ur33m1xpgY5YSMjOH9HyN1UalN2X3xXBDj/Bs+
	7g3Z1hXQjD0CGjANKM2d8kBxCyDY/qNq2/DEaqyt0CfoHmsvj9Qnx4JjnQBibRaeLH6kCczHVGi
	6QpHhfnI8TF3XYIIuUNdEn8zHvpbQTZO+3RD9rMa5FgnZEJXpTYKjuEWVUnU+B2Ear6Z5wv+IWT
	e7geAwvMJYyTByrTYyCn8Fg8vwCvOz2xhOP4alZlFfSd8OVpyynOCfmsH285MKO8SkI6YurbQAo
	fI/pFLjhOARljhQALsfV7jAuAxflTeRBls3Bf/Vw3FT2bo20GwzdGTHvn6WBg8UpddqBi0mFGmX
	A8yBIl/kDToWg6/WAqEGgfZQUZQJbkoFHNZlD1XAoj4VbNoOTB9pM8A==
X-Google-Smtp-Source: AGHT+IGtyi4MTM9XY0YVR4RqcloIyIeFcIrEpMnzvURgHuRILumswsMOJjznaIS1b6cFkJl1i5cLVw==
X-Received: by 2002:a05:6a00:2d08:b0:736:54c9:df2c with SMTP id d2e1a72fcca58-76bec48a2c2mr11815760b3a.15.1754340964337;
        Mon, 04 Aug 2025 13:56:04 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bccfcf5f7sm11316454b3a.88.2025.08.04.13.56.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 13:56:03 -0700 (PDT)
Date: Mon, 4 Aug 2025 13:56:01 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] mm; hugetlb: simpify alloc_buddy_hugetlb_folio()
Message-ID: <aJEeYY_T7pEhBbll@fedora>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-4-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250802073107.2787975-4-wangkefeng.wang@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A73D012000C
X-Stat-Signature: gje1tn5e38441n4zgwqbt1izqrpcytut
X-HE-Tag: 1754340965-739960
X-HE-Meta: U2FsdGVkX196DTERht5YW30hVWbMyS0UOXd3kOJRNfKP//oH35xkD7g5aOQVOaDtFfct9ApEPBIaUzLBAlayUVMwEmYuDAXsmav2jH0Zdn+BXlnLR4xd3ntJQxxx1WbQGdClV40RDJhHVMUhjImZxz5BkZoxRqKhgsjf/YVVgWkDKhhsBA35zs02LyTe1m79JtXc1TDaIONBzxyhX8fkgvhT/A+vnYeqkoodv1710A7ZCCgj6PvbyEVRptfkZh+x850UieOmkgrXojht3R6VadXC/jqquHyzjhLpteK7I+Hqt+r8a5zCFee2FNV37REnrq88H4l6ftAhMt7TCe8G4eodGPmPCMOtR4zpLtOy1LLOF80vbH4RBfiGZizUrtAruIwUa7ylDItWJ+p4IhmLPXAWymqiwZT7G6ACGq8XcxtskzEOUz9ZcfHPZABoZU3Dnd0/D0Q8PRGHOO84j4STRUG85zB9T+WRohzKFwgHbO6FFVqLMGrDvqY7xPcHPcJMOrVNf1s30Dkc60vpcAp2A18Lc12Ot0xbc+xfMWFIMQIe4oDhcktCKt8uieq1zBAziqURUkx8lOHPsx/Ki3B8RqR6Di3RUP9lUhPdQ+/JuC5tQaKjuHlXtFkklgGGkICDo2E9+aRK96BqT288Tli/aeZEtlt1Dth9v/jWnkJIIRwQJJnVE4PvA6jaTYoQv0CuVHhmD6BslhgrkVmrpccq1s9P+mtTpejuVV2vg+l8aohOnDPQlL2lV+kZq8hc1eUEtvMorpqMnECMGSppF8Jpn/Kl1d/0aqGMafAMdTE4PzFovIMclhN9IXhaP/u0lMZFbZU+HZ89ku+a/39Rn4Yrem8PA0lk2dFL2yMpp/dLRMljWxw5lgJWLTiAjy55+jq3zrS17fApBM136WXpvoJ3UNhwgHaXKxuKcHVbzTGgwE6h/4qwBYi6pDzj07HsBmFd5HfTUFeIt1KArPwwfxZ
 6Dq1QaB2
 h9kzmy5NATrQvrOZVSoEUNKAvkbgaN7crwiy9Xeds6vuVCdItf8hM5Bt3tu9ORBGoTqBiui/dOeBi961vJOrJLaC+39BUE3bzXVYqjXnH5quHCXWfORU3yDKMdtn13w60QRVN1kt9UKWh29lYa7IQ1PO9cDXts4jwpWUjecGwpkZwolXH/eM65yTifRX9Zx3ObmGIU874zG9m6yNoe6+W/dGoqID5d+4uWAFFwEpKdpCW+XV1LFIrPAli00lSeoewfqhynsV293kF3eAZwDFpxnhe6keFAfoZrfGZX13VXgCBhOnU4uq05Mz/gjfGO+k3B5R/Xi/qAf5hvRXlWRw9Ug1+iZUxjZ5WKSN1Gc1IXtHJDB8+dkHo57vp+uck4OFGQ0hw5lYfSyNrRaL6kHZMvd6/jQhCe3Y5Tjl4uqW6VUX1vvfZKq1k8Z02n3rht/hThMfjzN6m9YygLaAxdAdqun9sOVqYEC7VTbXEzf2sOITZ7R/u0B8jy5zwvA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 02, 2025 at 03:31:03PM +0800, Kefeng Wang wrote:
> Check folio once instead of three times in alloc_buddy_hugetlb_folio().
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>  mm/hugetlb.c | 37 +++++++++++++++++--------------------
>  1 file changed, 17 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index afec5a6a8aca..436403fb0bed 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1949,29 +1949,26 @@ static struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
>  		nid = numa_mem_id();
>  
>  	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
> -
> -	/*
> -	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
> -	 * folio this indicates an overall state change.  Clear bit so
> -	 * that we resume normal 'try hard' allocations.
> -	 */
> -	if (node_alloc_noretry && folio && !alloc_try_hard)
> -		node_clear(nid, *node_alloc_noretry);
> -
> -	/*
> -	 * If we tried hard to get a folio but failed, set bit so that
> -	 * subsequent attempts will not try as hard until there is an
> -	 * overall state change.
> -	 */
> -	if (node_alloc_noretry && !folio && alloc_try_hard)
> -		node_set(nid, *node_alloc_noretry);
> -
> -	if (!folio) {

I really don't like the way you've done this below. I feel like it makes
the code harder to understand since it feels like we've effectively
divided this function into 2 different ones (depending on if we
successfully got a folio).

I don't have a better idea, but I also don't think eliminating those 2
extra checks is worth increasing the complexity like this.

> +	if (folio) {
> +		/*
> +		 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
> +		 * folio this indicates an overall state change.  Clear bit so
> +		 * that we resume normal 'try hard' allocations.
> +		 */
> +		if (node_alloc_noretry && !alloc_try_hard)
> +			node_clear(nid, *node_alloc_noretry);
> +		__count_vm_event(HTLB_BUDDY_PGALLOC);
> +	} else {
> +		/*
> +		 * If we tried hard to get a folio but failed, set bit so that
> +		 * subsequent attempts will not try as hard until there is an
> +		 * overall state change.
> +		 */
> +		if (node_alloc_noretry && alloc_try_hard)
> +			node_set(nid, *node_alloc_noretry);
>  		__count_vm_event(HTLB_BUDDY_PGALLOC_FAIL);
> -		return NULL;
>  	}
>  
> -	__count_vm_event(HTLB_BUDDY_PGALLOC);
>  	return folio;
>  }
>  
> -- 
> 2.27.0
> 
> 

