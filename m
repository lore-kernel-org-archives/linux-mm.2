Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52B19C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58BF56B0088; Mon, 27 Jul 2026 12:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BD56B008A; Mon, 27 Jul 2026 12:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42DF36B008C; Mon, 27 Jul 2026 12:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F6526B0088
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:09:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8DDA88010E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:09:02 +0000 (UTC)
X-FDA: 85035040524.01.ED402A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AFC1C80002
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:09:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PW8tOqTC;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785168540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0LvAO0ah3SsYMLwJ96GBLTr20qyrgX9+ER60RqNQcE=;
	b=iTpUWua+NrpkzgHPsqochlt+gHDMoxKnD/Z4ndtM9S024D3Hl7yYN2fgxNWY1ZfmCksDQm
	rIoQXyIiHkbE0P/+f915dNfFh72/Ui0K34ZXHcmmSTKcW/e1H0it2CcoCguwpdMSI+YS3L
	OUp/zdktCy7XocXh45z1uTdaE1vumxM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PW8tOqTC;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785168540;
	b=dAANrWzW4HzxXH/LmrQHNd2SmJCyG2Xjzw7Gdli5M2257AtbveinGI3mGxCC///mjnyqiB
	fQvTaylXuJ8Bqy9beG3E7jfoR2+Fnx1yUom/o5TjJpyhW7er8cILre8SmiP3ht/ujrDMcP
	A8S997uBiXEMggrTfK6SYOshBEU+9lc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CBC1D43AD0;
	Mon, 27 Jul 2026 16:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5839B1F000E9;
	Mon, 27 Jul 2026 16:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785168539;
	bh=Z0LvAO0ah3SsYMLwJ96GBLTr20qyrgX9+ER60RqNQcE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PW8tOqTCRonmn5YwYODzuh7/6xiFucn+teoQBtbAYeXY5H5wOcR0RyQWihpjbgu2X
	 VWDI4A9oLfUyWlLWgGtLSQ39uZj4pfA8u10n7xpxukiQ2te96QACxV18Mbzse7Q0CI
	 HAttNqykj4lylZ6tBeoaTs8nr/q7jS1FtBMUO0OiAAXw2GxniwrpLFhZdI++XKXFtC
	 25Xm1u3f+yu6KJvMQTw6S9/N4oTnO0QeWBCEA83At62zNclFHnMhzfg0nSnf5A8Mrp
	 SVFWfeRg57CU3vYwBht9DmU2SIvS4zsuFpCMSPTpYN0dTPl+ZEhIKVseuWvEGKNeUO
	 enSJbfZh3bObg==
Message-ID: <b915b058-f5b1-423a-a835-5891e7997080@kernel.org>
Date: Mon, 27 Jul 2026 18:08:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3] mm/thp: serialize huge-zero folio state
 transitions
To: Hengbin Zhang <uqbarz@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>
References: <4146d4f5-c8fb-42cf-9dc8-a9d4c26055da@kernel.org>
 <20260727154001.4102341-1-uqbarz@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260727154001.4102341-1-uqbarz@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: AFC1C80002
X-Rspam-User: 
X-Stat-Signature: gt4u5uqnmebdfikoekpuwi5yknbda3f1
X-Rspamd-Server: rspam04
X-HE-Tag: 1785168540-577800
X-HE-Meta: U2FsdGVkX1/RfLr/tcC7lkp54XpCoFB8ZBPm/Ahz9Z8VzZ7F1kFb2kj24k4qAvkM35LzA+iBDVxUs6ut287+I9CYeLBoBylJ/oHcek+t4B2qigXmOTgQOvhzyRbGvv0AMFYxCmF+i6yGDXxTMmc3CoHWBjqa7tauJ/y2d81WqjeR/2BAEG2QMqcUaw3yb4Fwqp4GsEzNjN9FjWN7NHgKB39Y9kZ3rq9cqJjfubIMEibOZTQ14cDMzEsiJZwYcNm1PkL9420jRzMndPb7f18PapEnWWxX0xWzkman4orw13okp5ZFsyh4jqEgko3u7zC6pz8hvOXtXje6IQKk9rc6rYvGQwyeQTM4haKhr4r9TxycJhsuHLsuOSsNeDYfjLgf6StuxU2IOpmN25h5nRTcDOobc77N+M9nOcHtI0+92ON6kJnAu9sorNkoQzpHYXHDBNzct77bZfkQlBEtVuBmLFqsbka5njClwrlA/oSkvseprc4TAGPRk7shJby8pm1Ewg9NQFkEbQQ2tJzvI7ak1RQzTu8rUZy2qP//vDDyqea5KcboPstiZgBUisShLp7htbzPUCV05zP+mvMokqhtBmSOK44SLjCHGXJ2eZE+dZPAnatw2EIvMJjD9El2REKfs25i6mDUmr3yjatf019UA7KvAqNxc6iSG/DaKwbvWzDzYk3IqAnmZNuTWDC9X5eMplnO9weMpxQJT1/k7erGhZvuERRD8jO0DFtvclpzeDwmHsrD1fPmuVraUgOGpub2uXMV8bowNb/6ez0JGaf9fkWrWhwDGss2QqL3DWa5R8ACkkM4HVSLqcerT4DQsorpWp54cE+JZUPUV3MJGGRqcTpAEAoO6pgRFZCnjLLxzouNv31zX/fH2l8Bh2K6vQ8ALNUFyh4rWqkEFJWqlwb1XUujPfx7arGqmhh1cwTA4RMTc+LdAxQBz+79bKkPRuIB/RTd79tZzkj00VrHBDn
 9M+a7Vvv
 CDM6DzXo7PzykCwVAOTY1VvLCUWbtoBIu6AiNPR0j9LFBOJgCjKzPoc4RTw4xoyQ8K59RwxxgHjxujLAhSju30URU9KJ+bHABNfJfMYZsyDIFtrTegC1StGEpzp3TTJkJPLs6bVbGv/XAi6Sr2ithmAoL0AXi7Z89zGx3P/dZebduddvJILvFq7bcr6S20TU8FdHjkBhXpa3wMZgCmn+28aTtkOB31yhVsPbHYdSdYY2ODRb6Q0ntgmVy3zpdFBlLRdov8ey9BznY+I0thWDydoqRDD/wxm1racMkdrXJvj0BGBaXbiAY64Rc0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/27/26 17:40, Hengbin Zhang wrote:
> The nonpersistent huge-zero shrinker clears huge_zero_folio and then
> invalidates huge_zero_pfn. A concurrent fault can publish a replacement
> folio and PFN between those updates, after which the old shrinker
> invalidates the replacement generation's PFN identity.
> 
> A later partial mprotect() can then misidentify the live special PMD and
> enter the ordinary anonymous THP split path.
> 
> A writer-side spinlock keeps huge_zero_folio and huge_zero_pfn updates
> from different generations together. Lockless getters still use the
> refcount fast path. atomic_set_release() publishes an initialized new
> generation before a successful atomic_inc_not_zero() can admit a getter
> on weakly ordered architectures.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Link: https://lore.kernel.org/r/20260724100509.2300200-1-uqbarz@gmail.com

We want a Fixes: tag + Cc: stable.

Can you dig up the proper Fixes commit? Thanks

> Signed-off-by: Hengbin Zhang <uqbarz@gmail.com>
> ---
>  mm/huge_memory.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index b5d1e9d4463d..79bec4495540 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -78,6 +78,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  static bool split_underused_thp = true;
>  
>  static atomic_t huge_zero_refcount;
> +static DEFINE_SPINLOCK(huge_zero_lock);
>  struct folio *huge_zero_folio __read_mostly;
>  unsigned long huge_zero_pfn __read_mostly = ~0UL;
>  unsigned long huge_anon_orders_always __read_mostly;
> @@ -237,17 +238,18 @@ static bool get_huge_zero_folio(void)
>  	}
>  	/* Ensure zero folio won't have large_rmappable flag set. */
>  	folio_clear_large_rmappable(zero_folio);
> -	preempt_disable();
> -	if (cmpxchg(&huge_zero_folio, NULL, zero_folio)) {
> -		preempt_enable();
> +	spin_lock(&huge_zero_lock);
> +	if (READ_ONCE(huge_zero_folio)) {

Same comment as below: who could possibly modify this value concurrently? I
don't think we need the READ_ONCE.

> +		spin_unlock(&huge_zero_lock);
>  		folio_put(zero_folio);
>  		goto retry;
>  	}
>  	WRITE_ONCE(huge_zero_pfn, folio_pfn(zero_folio));
> +	WRITE_ONCE(huge_zero_folio, zero_folio);
> +	spin_unlock(&huge_zero_lock);
>  
> -	/* We take additional reference here. It will be put back by shrinker */
> -	atomic_set(&huge_zero_refcount, 2);
> -	preempt_enable();
> +	/* Publish the identity before admitting lockless getters. */
> +	atomic_set_release(&huge_zero_refcount, 2);

Why do we need the _release semantics here when we just did a spin_unlock()?

>  	count_vm_event(THP_ZERO_PAGE_ALLOC);
>  	return true;
>  }
> @@ -298,9 +300,15 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
>  						 struct shrink_control *sc)
>  {
>  	if (atomic_cmpxchg(&huge_zero_refcount, 1, 0) == 1) {
> -		struct folio *zero_folio = xchg(&huge_zero_folio, NULL);
> +		struct folio *zero_folio;
> +
> +		spin_lock(&huge_zero_lock);
> +		zero_folio = READ_ONCE(huge_zero_folio);

Why do we need a READ_ONCE? Nobody should be legally be allowed to change this
variable concurrently, no?

>  		BUG_ON(zero_folio == NULL);
>  		WRITE_ONCE(huge_zero_pfn, ~0UL);
> +		WRITE_ONCE(huge_zero_folio, NULL);
> +		spin_unlock(&huge_zero_lock);
> +
>  		folio_put(zero_folio);
>  		return HPAGE_PMD_NR;
>  	}


-- 
Cheers,

David

