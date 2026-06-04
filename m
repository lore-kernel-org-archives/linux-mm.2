Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B694CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 11:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866496B0005; Thu,  4 Jun 2026 07:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F05A6B0099; Thu,  4 Jun 2026 07:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 705A96B009B; Thu,  4 Jun 2026 07:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C4FE6B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:38:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFBC11A0752
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:38:00 +0000 (UTC)
X-FDA: 84842031120.06.A868F6B
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 44204180006
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 11:37:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=caK7KHj7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780573079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dsgz3eNgm/YZg8A4OJQ67T5GxGFPVHwvnmyNH0yYVZk=;
	b=YLyEABgaAkDF+yG7aYVvlPdBZGyGk+sy0ra281BXzJake5MiRqwbrOGatr+yMsU/DjoOwU
	YxAAz20VdGVZ0YA0a42x5rH9nassQ74WL5TgI4GtKq2s7rYf1aC60i/gk57YDMVAQNR9T3
	K18oNChV5z6oSz9YGnD71X+7LtjhjOM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=caK7KHj7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780573079;
	b=I5p5YtU4ue8dPY1i/6Sk2P3ED+qsGncnVjrVLLfk5V/68Unm7XwsO9iNtVG3ypVPuthmE4
	lLJHkzgdh5C2sTohKc+3a8d5Slu470YLPype3EvMyb6c93C2Dly6srKMrrN0iLhwNm9gn2
	TCq3ItoM01tdctuKL40qvshzhzpVYgc=
Date: Thu, 4 Jun 2026 19:37:52 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780573077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Dsgz3eNgm/YZg8A4OJQ67T5GxGFPVHwvnmyNH0yYVZk=;
	b=caK7KHj7Zki1NNa39iKhWGmzz5/6v/zK1kfERRgdH9g+tqPJwTBojQ1GZWIo5a1Y/2kNg+
	JCrvB8GrflyeHww/RAtFsr3dEqgNpJDJ0GPfya/lAFTDa6g7Sl8UvyWb1dNTlvBG8JSKX3
	RyyFRd7BD0CEdommTLBgJeDuP+eYp7s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Christoph Hellwig <hch@lst.de>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 5/8] mm/swap: remove count_swpout_vm_event
Message-ID: <aiFjkBXIs3-6gWZI@MiWiFi-R3L-srv>
References: <20260601113449.3464734-1-hch@lst.de>
 <20260601113449.3464734-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260601113449.3464734-6-hch@lst.de>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 44204180006
X-Rspam-User: 
X-Stat-Signature: fupntwerk6s7gg1qpwnup8sw36fpgbpr
X-Rspamd-Server: rspam09
X-HE-Tag: 1780573079-158784
X-HE-Meta: U2FsdGVkX18oBdobj8vTOTR/PTDlHV/bVOillknt5A7/VH4zVXCosRbY7HLkAq0SabrBiW75oXDM9Hkg0XaDLTFtrhScGiIPV6mhFlRij19o42SIC7B7LTH8pMkqUPY74BHAtETdFMgNxGheFYLfTDplyGpNRHoNvF3hwRcTUoEX6U6plN/XpO8QD2MRp2zvIgtg6x6uRNhXsg1yZJ48rSuy6BJwn3SZ78R0wTPpspKgRtvwPAffUY+C6bt0+RRUJB/EMAs9dWvOnRNRTZISEHfluS7CSS3vUl8choQfa8f5cyCcZLl+jghMYfh6gurBJKrHWOUTIqeeSLJXU38NSCgIVmAql8DP+V8qXhFxJAEl++HhwP27rsjD4RmDXSGab9wKYG50ZKcYBqlZG6MizIr4WIuLp3qeAVNcQZo/ajea/RTxoNmcKH5nvqU9o+txyjasbWPoW7gPKEorB4iI9RDasaV6+ceHwXtzzCKYMrFyxURQS353yMYF/vnh8ETuvml/1hiTQIQ/W23q7x9W9aACMAZmC5qX6TJd2XxZkFXfGkvjGADigjWmmjSt0oSyym1ynS8C24e47O68fJOLfsc5GD0H7vsTTqXQPCuL+DnAGfLsKF6BAXdNr4y08yikjbZL+amDYxpCd1ImSUf/jDC54K2LyVhCmSyJ3T0GXfJXdygO6dhAVH1nC1aqPen8WheeEBNiVEMJIXhl6f8D6nFJWugSid71+adkTznv7nHoCnJt/sabSPm3HqnYSc8cYK/usUKQPYAGHHfMICkgNKwwcsvxdUYIA7GbwysNLqzTXovZ+qRls48BjE4ePEalwPS/0SYMdD5PM2riPlkRr3TMXds0/WgXwNKb1KtH2/XdBfxLxz1HmSJIbJuUP+Z4WRQBbyYP6NhiXhqdx8njYJVcPrm6cSu4FwXEXA60XH5Rl0nHX0FlWxBdMh+uzqNMogKqbmxjWi1BpVDNyd2
 AfnYHTc/
 EfZGT2KysdsulsrxssBQdPzca7b1EhGAazrMmRn3q6WFLTgdTVvmJsC8//hl0bkpBseMMDSBF/Lhoh2YRaYD39OHvIH2pAqR1sgiXCun0j5Qk1gicRrlisxI6jyNHGacXLozZDhAdpUxf84FjXE+lzzA1WS5/mmG3bg/Q/om76Kqc79j9Cs8jBhgaEieHC4dRhP+5g2kRLN/gQSQYAL34OrIelcoi1dORKU6KeWkSdXA3IMVHWCNRX9Q1X6RErA54/MX4WfH5GB0gyJf6NBApNPfVf3PofwdMgCLmZ97YWL6hPP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/01/26 at 01:34pm, Christoph Hellwig wrote:
> There is only one caller left, so merge it into that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  mm/page_io.c | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/page_io.c b/mm/page_io.c
> index 22c751fe03c0..0e2aabe635c8 100644
> --- a/mm/page_io.c
> +++ b/mm/page_io.c
> @@ -254,19 +254,6 @@ int swap_writeout(struct swap_io_ctx *ctx, struct folio *folio)
>  	return ret;
>  }
>  
> -static inline void count_swpout_vm_event(struct folio *folio)
> -{
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (unlikely(folio_test_pmd_mappable(folio))) {
> -		count_memcg_folio_events(folio, THP_SWPOUT, 1);
> -		count_vm_event(THP_SWPOUT);
> -	}
> -#endif
> -	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
> -	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
> -	count_vm_events(PSWPOUT, folio_nr_pages(folio));
> -}
> -
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
>  static struct cgroup_subsys_state *folio_memcg_blkg_css(struct folio *folio)
>  {
> @@ -388,7 +375,16 @@ void __swap_writepage(struct swap_io_ctx *ctx, struct folio *folio)
>  {
>  	VM_BUG_ON_FOLIO(!folio_test_swapcache(folio), folio);
>  
> -	count_swpout_vm_event(folio);
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +	if (unlikely(folio_test_pmd_mappable(folio))) {
> +		count_memcg_folio_events(folio, THP_SWPOUT, 1);
> +		count_vm_event(THP_SWPOUT);
> +	}
> +#endif
> +	count_mthp_stat(folio_order(folio), MTHP_STAT_SWPOUT);
> +	count_memcg_folio_events(folio, PSWPOUT, folio_nr_pages(folio));
> +	count_vm_events(PSWPOUT, folio_nr_pages(folio));
> +
>  	folio_start_writeback(folio);
>  	folio_unlock(folio);
>  	swap_add_page(ctx, folio, WRITE);
> -- 
> 2.53.0
> 

