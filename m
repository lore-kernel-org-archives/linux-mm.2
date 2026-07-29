Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE756C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39746B0105; Wed, 29 Jul 2026 10:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A5C6B0107; Wed, 29 Jul 2026 10:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F976B0108; Wed, 29 Jul 2026 10:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8916B0105
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:39:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 98B7E1406A0
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:11:33 +0000 (UTC)
X-FDA: 85041699666.18.8B85301
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id CE6E8100012
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:11:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GhFoAAhs;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785327091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJwQ8kTPh1W4/a3MUlvjgjtvhqULKqgMp25Frxkklaw=;
	b=fqSaRRgas1Ta79rBGTWAbIU6cvXIZ0GwmQ6pIkbMPPNTRXlh717nnTwmkIx8Y3ZJcfyzPO
	5jq4y59V94HPhUfOjDaV87FaqkgqJqC4W7j3qqZTbmUPhsaTmy9+lixbFVgwQTCJbXwfON
	kbuP0TfT+rrHRGXHtiqu5UyMslfdRx4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785327091;
	b=3pAqB/W7En3oY4nhY88bon4UeLzti/rylYjF05N6yvlOv5RAfz+mHiu+RT7ALXF9+EIo/o
	iCh9uKffPehEzO/u0cTE5azrnMmzDl3bp1CZ20w8mXKVnc3IV+0FmrqMS861/YZLjdggfv
	8iqRDdF966zXl9ZxJuzsirUXGxfK2RA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GhFoAAhs;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E67B342455;
	Wed, 29 Jul 2026 12:11:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 060A41F000E9;
	Wed, 29 Jul 2026 12:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785327090;
	bh=uJwQ8kTPh1W4/a3MUlvjgjtvhqULKqgMp25Frxkklaw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GhFoAAhsAmpS5+ALisTdbEtXrsM6n/XKQYlblpt+7NbLMlJPB70lrmH5CiWZtDnOx
	 OEhHbK6fYEhgWqLzFATRKAAHQ+Sb2GNbVhAxHrqSCKBDNm+swHhINIQ+uNDdat3YYc
	 Xce1g065zsoXDXR0wh/SU49+9KNuuiZhwe/CXphdQ+u4pbtAYaq6FnvGySvw1vtfA7
	 Uxrs+nOSTQhTsaUjeD6D4QsvxTu11Ot4NCBUD/i0sS/cnZOx9DQhrOZkP16ERnYP/N
	 YqF9O8AtiL7kop7S89wPciJVZY9TrqBnGO5TYX6Ad61NpnHQ/ZJKn3ik/MFawgeKxo
	 WLUJ9m6vkVnMQ==
Message-ID: <8f74bd51-11f2-4837-9463-d016444e45cc@kernel.org>
Date: Wed, 29 Jul 2026 14:11:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 2/2] mm: improve large folio reuse for LRU-cached
 folios
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org, ljs@kernel.org
Cc: baolin.wang@linux.alibaba.com, dev.jain@arm.com, lance.yang@linux.dev,
 liam@infradead.org, linux-kernel@vger.kernel.org, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com
References: <20260709081536.82768-1-baohua@kernel.org>
 <20260709081536.82768-3-baohua@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260709081536.82768-3-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bketkxygh9jqktq3pg16t3p6qomceuze
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CE6E8100012
X-HE-Tag: 1785327091-816892
X-HE-Meta: U2FsdGVkX1+dePpQOuBjGRNq8VzM8JxFFJ7XyU0/YraICgduHBGsTsISCWuvWaIlQxX6xMhA+oa3OzCljV4wq0aeJytwlkswP+mZ7edt+XchirueVCzVa4KvytC+h/8wrJ+I9yaYXEGby3OfeJD/IdVs1sjS5ZqSo/NosfitHDpGq8KW/kszeVuZ4XY7xFeUzymhK7LBzEKwbEqxD2ciBb62DZDexZ1n7AsfT4h+IEXglUJQRmQt+ElpFrtDSnwuryEfcD7lVo2KHK1xnJe0bFdRk6pP2PkYJIxCHbISoLdsPPAutHSSm+hz2xDIgstXNkkoiSKSgxf/02/KxscM3MGzED2LC0ccC2Jv3IbpAcE4EjrN3mz2dKUieEiJQbVnO7M5bnDqh2HzU8c+G6wFgW0lrJhfS3liJMp55RPR2QGlRWI8T8OFQr9Hx0xy92LF7V+6PLnZZhYAkZ5MiIoz+N4bM8Th/+ZuaE3GNtobsvFn6FO/pByOiS8HZZEVKYXyNPu88WcAYVQTS2thJVo6VokUWT9T+BqleYL28lHtM9UMWp0xBjv3qqvkYw2OO18suQZoDs9ni+QWjmkjc4a1gIN6/BngYygK1RxvSAq++fNIZTECS0vHEGp927uSlh0QNBBxNTWgZ08C1rXaO0ziIE7XnzSdgp+MQraPjdqVWwNT7U0Iw1h6m6iGHZJhWGviLw7PIiQmDgp0OhWGQJAv9YsacGCpE0HhMFEr5b9UIudJf4aMVaoM0QG2s/LpbxMRhzxdGTqYKKdlQPs3cXCAS+7GQGPlueJJf4qeaxEQgbH28m7Q2K7kkcqiwZDQ2w6kvqDqdGkrSihcegRZK6VRstGXDg3/2YvLJ+1G+oFFVSicOnw5uIAxIiEooSDKjzPIvK4tW9ECbj6qpTOh3U3EvsOVZnaGevQ6eQoA2L+BiHzhOiaNsxIwFZBRe7xBhkl4SN1MDLpPQynTV+j4S/m
 D5A5f6pM
 8lPU+VSEJQg0Rze9naDBY9RX8FaIrffs793MSGlcVjpdQjXd1/vCRcG3M0fR1JjqQGtZowHTMV2lRmM61COOIrkukhqEljy3akoNuMZD/WubthakMzufhLE6f9puzwfPOnyYXQxP8NIY5/x1KM/wHe1+rOammofK0cio0IJs4F15bTGyIkaw9BuavYw65RUI0iS9KAfjkAcz9PC8/Gc2vnaglus901ZeCK0gqQ29InTLMtZj2pjsRtHG08RJAMnqf73kKQL7io+BbloMi2+G4Bqr8EZAuBI5nn+Kj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 10:15, Barry Song (Xiaomi) wrote:
> Large folios may now reside in the per-CPU LRU cache. Before
> attempting to reuse them, drain the local LRU cache, which
> can still be beneficial in cases where the folios are likely
> to remain in this CPU's LRU cache:
> 
> int main(int argc, char *argv[])
> {
>     int i;
>     while (1) {
>         volatile int *p = mmap(0, SIZE, PROT_READ | PROT_WRITE,
>                                MAP_PRIVATE | MAP_ANONYMOUS,
>                                -1, 0);
>         for (int i = 0; i < SIZE / sizeof(int); i++)
>             p[i] = i;
>         madvise((void *)p, SIZE, MADV_PAGEOUT);
>         if (!fork())
>             _exit(0);
>         for (int i = 0; i < SIZE / sizeof(int); i++)
>             p[i] = i;
>         munmap((void *)p, SIZE);
>     }
>     return 0;
> }
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/memory.c | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 5689b7cff76c..1d08ed5ba99b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4136,6 +4136,19 @@ static bool __wp_can_reuse_large_anon_folio(struct folio *folio,
>  		folio_unlock(folio);
>  	}
>  
> +	if (folio_may_be_lru_cached(folio) && !folio_test_lru(folio)) {
> +		if (folio_ref_count(folio) > folio_large_mapcount(folio) + 1)

I assume that can just be a "!=".

> +			return false;
> +		/*
> +		 * A global LRU drain is too expensive, but a local drain
> +		 * can still be beneficial. For example, large folios that
> +		 * have just been swapped in and fall back from
> +		 * do_swap_page() to do_wp_page() are likely still in this
> +		 * CPU's LRU cache.
> +		 */

Do we really need that comment? It's just the same as we have in
wp_can_reuse_anon_folio(). So either drop it or use the same comment.

I was wondering whether we could unify some logic with
wp_can_reuse_anon_folio(), but the checks are just to different.


Apart from that LGTM. I'm sure there are some micro-optimizations to be had, but
this here should suffice.

-- 
Cheers,

David

