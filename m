Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B80F1CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22BBF6B03DD; Mon,  1 Jun 2026 10:40:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC766B03DF; Mon,  1 Jun 2026 10:40:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1197D6B03E0; Mon,  1 Jun 2026 10:40:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 009B76B03DD
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:40:10 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCBDBC2166
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:40:10 +0000 (UTC)
X-FDA: 84831603780.14.6BAFE55
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf26.hostedemail.com (Postfix) with ESMTP id 24B6B140016
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:40:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=fgGD4KVC;
	spf=pass (imf26.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780324808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cK3Gvdkr36jX3698KQfjB7612HPZkiyqbqTCq+0O2Zo=;
	b=IHlddZ9wFqc8c3OHEjNfRyyLoOmYCq9CbG98TBUtCCJQ0Og/qHWu/90ctSCkTibJUEznva
	ttKPuVlYFyf0qBzDFwho3TT/UsRmz453ooxkK3LPMN8XZ8UC/rvfaeQa5umq7d3Eos5ath
	MZ0hZ5zA7kYYEAHs741SIuztA57Wak4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=fgGD4KVC;
	spf=pass (imf26.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780324808; a=rsa-sha256;
	cv=none;
	b=TFyEVdaRxnPKI9ARMoVYVV5+P4au6miSetHDYgBkY5Yeg+s5LO0DsXLmyAueQSLuji51a2
	UII0FWLi8UPLx4OLXL4YPvjSZh/10Xm9HYRvKQFpJNUA+lfmIWbRmZraTsiYZmaxa20buj
	htxWkp+3KFNI0EQd97THRYZDpuzMwmQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=Message-ID:Date:MIME-Version:Subject:To:From:
	Content-Type; bh=cK3Gvdkr36jX3698KQfjB7612HPZkiyqbqTCq+0O2Zo=;
	b=fgGD4KVC/pxxMfdfYdAGu3GTLt3YblGkg7TREETQGp6bT1xHZG8S4t4ykXLseU
	/JJEUPTchNKRdzrkTFYDA5aPKt7xHvev9XrnZxzxjAvJV1hsFWgGpy1LRYRU+iMW
	59qTYhZ26lDAjAodQVsMdrM+uhrDFTsifquxSA4ZQ8PS0=
Received: from [192.168.5.171] (unknown [])
	by gzga-smtp-mtada-g1-3 (Coremail) with SMTP id _____wCX9fmymR1qF8kFAw--.654S2;
	Mon, 01 Jun 2026 22:39:46 +0800 (CST)
Message-ID: <c6d65420-c4f9-4211-b9d8-1040d99379d0@163.com>
Date: Mon, 1 Jun 2026 22:39:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm/filemap: reduce unnecessary xarray lookups when
 read cached pages
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chi Zhiling <chizhiling@kylinos.cn>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-2-chizhiling@163.com>
 <ah2ARWo_EiVOaWDI@casper.infradead.org>
From: Chi Zhiling <chizhiling@163.com>
In-Reply-To: <ah2ARWo_EiVOaWDI@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_____wCX9fmymR1qF8kFAw--.654S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tF1DuryUXFW7KrWruFyxGrg_yoW8WFyxpr
	Z8Ka4kCrWUtayakrnxtF1fZa4F934Fqay5Aa4Ig34SvFn8JFnIkr97Ka45Jan8Zr4kJF1x
	Xa18Za40ga15t3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UI_M-UUUUU=
X-Originating-IP: [58.20.13.92]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3BJ0EmodmbIWBwAA3l
X-Stat-Signature: wupitc4qh16afx5oe3kqubffy4ztbskj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 24B6B140016
X-HE-Tag: 1780324807-530887
X-HE-Meta: U2FsdGVkX1+LhUOoFk9H2dZQlYBFDWcTJrlvfNpE21u1GvAHhlnj6VG2isGgWqbBnuSQ7PfT6bZpBMxhYbQL/R6Rkc9N0N0lA034qMtgjDn9ZyP3QqV08A4kdURmAqBsZDjTWOeu2O1QVYyAeyqu2vTs+pUsChjppHJBAITzve2F0iNEq138pU/0flsR4t6dRk29EcdIh8PuwIO+0+l0SYrspatorSy8g87cNeSs9Zl1oZqvAd50Pj2a+LDGQVyz3V5Q788Jkn+pChfRjvwskkthEOvwvzxumycIe9csNyoB4fRAPuWR/+7vpyGCOnZ0y57DyqE512wtLwHwgB2jnfseLxrcIrM0CZYjBSiHCOLpE7EwlJhnPdm199CNVoc8tm0dDHCyEpGkrQjtTE4PUeg1YC/oSyRyFRbzU7148fGujq77wW/hRco4eHoKUhXhXqEbgpiFgcjissRo0WULpQSkXcmN5ruM5KoBLyXhnrYfKSGAgJRHEEjcNekBJ1VzyeBPc7a+iSoJZmobKRll5IajIWspkPcJHPBByhyc6OrYg0wc2qdyK58/+QFA6iD32mp1ggJH4Gi/S+H/S+Rw0teXomjgi7whWGIaGmcSPP8my0qYNhhEUA2aL13ABBER/ETa5VK4SMr33KW1fX8uBpYtYqLT4F6oaYDiqibYs/nnMZ7fj7EtJx7fKgrrykiyfzdEK0I8Na7DO932AD+Y9VQAy1Lr2wK3odJK3H9+FIPNPj6kbMvERsC9eydKzfGKDYQ0QIgpiqa+PGTAQ6FDWh40zY/HKpEuluWBIsqE2lenppHD0NoWSMHeY/PiiQdBquZfl4uhB9Sp8HWYuK0L+xv0WyTosoDn1yllhjnLQccGi3echUKs7LKzf0qFb6fA1wbvD9L2/YA7DXF2TPNX2eJnz+aIlcOMr1+XiEdhy80io8NmSzdKRDc4rK8IAhrXmjDmaRDPiAv+NPSOKQQ
 LtAoFUiM
 +O9wyAriHXM7gjEsqTyyG96/fdnLI26Jt9De0K7TTlFtmkHbMMDWZ0AhOspL1RGHhpiPNdHX+lmzUqF4NpUx2ZrgGPNnbPS7E9irdJLgLLoy/paHILrebmZMYY6GnStv9fTm+AujpONSVrAuizCcecz3DkurPV4ysljHqZwxMyGhOB0SKuhzoF9HERJWtJfBFcbKLZixj5ZG0PyQdCmoeTSC4wGzFuyr4uRCakEv9gn0tY4P7Tv3bRtNbYELOXmun5hbkVjB+jfmeJ9FqCbLbZEmie/icFpWbbev8ldvU7i79offB+GBkWSceF3aZ8u7dWrO7IAVlQxvkh2MSEBZvLWuFA42M9/tPFp+dEqshfjNvrvqZ5X/Sp9peMCjtdFPAahNTEEmcpEitUfU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Matthew

On 6/1/26 8:51 PM, Matthew Wilcox wrote:
> On Mon, Jun 01, 2026 at 01:57:00PM +0800, Chi Zhiling wrote:
>> From: Chi Zhiling <chizhiling@kylinos.cn>
>>
>> When reading small amounts of data from the page cache, only a single
>> folio is typically returned from filemap_read_get_batch(). In this case,
>> calling xas_advance() or xas_next() after adding the folio to the batch
>> is unnecessary and only introduces extra branches.
> 
> I don't think xas_advance() is all that expensive.  The expensive part
> is going to be calling xas_next() and realising that the folio now lies
> beyond the required range.  I think you'll get just as much benefit from
> doing this:
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4e636647100c..578b03bd5514 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2459,11 +2459,14 @@ static void filemap_get_read_batch(struct address_space *mapping,
>   	XA_STATE(xas, &mapping->i_pages, index);
>   	struct folio *folio;
>   
> +	if (index > max)
> +		return;
> +
>   	rcu_read_lock();
>   	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
>   		if (xas_retry(&xas, folio))
>   			continue;
> -		if (xas.xa_index > max || xa_is_value(folio))
> +		if (xa_is_value(folio))
>   			break;
>   		if (xa_is_sibling(folio))
>   			break;
> @@ -2480,6 +2483,8 @@ static void filemap_get_read_batch(struct address_space *mapping,
>   		if (folio_test_readahead(folio))
>   			break;
>   		xas_advance(&xas, folio_next_index(folio) - 1);
> +		if (xas.index >= max)
> +			break;
>   		continue;
>   put_folio:
>   		folio_put(folio);
>>

Looks good. I'll include it in the next version and make the same change 
in patch 2/5.

Thanks!


