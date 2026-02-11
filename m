Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A9E3E9E309
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 13:27:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8082D6B0005; Wed, 11 Feb 2026 08:27:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5756B0089; Wed, 11 Feb 2026 08:27:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C69D6B008A; Wed, 11 Feb 2026 08:27:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 589B26B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 08:27:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF6E313A87E
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:27:16 +0000 (UTC)
X-FDA: 84432252072.06.55DAB99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0A13040009
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 13:27:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gESZg5XO;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770816435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vX2r2SXm1aa30ata/T20YR29moz+krv2EI9xojJLN0o=;
	b=pQxtJVsmTzn9/fT6HYui4oqHbfSTjhrSbvCnsCHL5rEciCTNujStg3460HWMUX79EDAtK7
	6TNES3XIWb2t1zI3ugaK9SZnycL7xrUr0ofA5cy/gW0gd5wnPO4EC+O+eC6oIlRMP3F60k
	BiISgo7WQfw80maQ9Duf8SqgVG5hIto=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gESZg5XO;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770816435; a=rsa-sha256;
	cv=none;
	b=PXnW77ZCTGY/fVbjauV2MUx4H3B5WVuR5YbGWYWbQZLcMHx3UVjlgMz9BCfyvYNfT1w2lo
	v7IG3N+z/IkJUN+zrNkQK+65PCU4s6xUEhqoIBUSCU1cbpfMalHt4wMHD+JdmPkm8PnixC
	Ohvu+rrl90Xi85bb/prV+CF+avRJbEQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 17D51442D4;
	Wed, 11 Feb 2026 13:27:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1482CC19421;
	Wed, 11 Feb 2026 13:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770816433;
	bh=0uP5UPuCcOjvjVPIOHJi6JaNThiYbN5b4+mZkZ7BzMA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gESZg5XOzVJp8bm1+NSar2k+AMzvag49xHUbcEtfZRkqsce9HfomqkIifWnbjM7O7
	 s3n7UfUpnUiIWUb9mopQJuAF361CFl5EgMEct4+SkdJyGYZilG1n2u9XrF4zNZLUnX
	 WAPcQDFJISN7bllhkCA2J9HbOjSKtwjdX9GRzmbrC8DV5vcC+LJ/GgDy84s3bQSVjJ
	 Vhu7M3Uw536q4fWES+GMN32spgoDjRGVfEhzZ7N88tzvtQCeTdbd57wdUbgRSl9YZX
	 qTillyEMxp0sczn87bx2G5HdboaOgAI/F8OdXV/DqfGYqCzounB1VdlpEUCYMoeny+
	 ob2iOz15L4UFA==
Message-ID: <b980ef1c-2dc2-4853-a873-7338e2d36178@kernel.org>
Date: Wed, 11 Feb 2026 14:27:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 2/2] mm: thp: add THP_SPLIT_PMD_PTE_ALLOC_FAILED counter
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, lorenzo.stoakes@oracle.com,
 willy@infradead.org, linux-mm@kvack.org
Cc: fvdl@google.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, dev.jain@arm.com,
 baolin.wang@linux.alibaba.com, npache@redhat.com, Liam.Howlett@oracle.com,
 ryan.roberts@arm.com, vbabka@suse.cz, lance.yang@linux.dev,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260211125507.4175026-1-usama.arif@linux.dev>
 <20260211125507.4175026-3-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260211125507.4175026-3-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0A13040009
X-Stat-Signature: qi3zfkrid6mqucbotr61c7ft3jqucsnj
X-Rspam-User: 
X-HE-Tag: 1770816434-963346
X-HE-Meta: U2FsdGVkX1/0BoWkKp4X2BuANTo/bCWz7cic2msWsrs7OBznERPfNZI1V1F/9omneAIKcKORTCUc0RMN6QcR2vedSh9x2escF0Z3hQ/Fn7uzhB7TK8+6P481fIWSiIfR1hX9byTHLBipHik1Z62cVr2FXYJJ5gW3ad8jdjI2CIQWC+A5Iju6kqYKxZHFA/lgMGRJZc7+vWxPDq6uVE3D5lBdbLiwnRLM4IcwTb+Fr8OI2aju4mFt6o8WkUT7+V11OxT+tFJxs2KQsAHb9PWmt27AaUqlk77mvrfojn/NJaD9VOXPVuO4zkYmwVuxk1YtRhB0RdO4fibsifWGj0/HQ+D4Cl04p+o4meXQkaLyecMyEOjNGm7DM8dU25Hk4Ie0Usnb1riuTOSaTKV5SZ6NMo9PXP7jLTioSQP+1bocYYeeAYTsXxYK9mEZ0BvfccWnp5m+TPwJ8Yyoxolctp65qojN83dczcq9y3Gj/rr11Rl02/pQoyvBua/zTor1b0eieyOPcC153iiriLudUk0kgl4DAUSFpOJr1IgMrf8K6NeyzZBv9DZHsP+aoGSotudR5uQcIPKj67o8MVdfiL5VF1XLfXfBZnoejRbaZqbpHVwrc7+/p+kVVCmwYvF32BOnH3sa/Zq0qKc8qZV50sWwhj6kOOjwLWfkUhwt4aAvwuB7Gxu6TnnBfLY/eAxlJUmVyIkalafYua/9kMiLskTExYQlWRA+wVEO7Kb0zp9AEviifquQlHQDkL5XOg2vB3vwI+7VSpJFP3MUpCIOM+9DaaRT9vaPE2eMahr1F8bhqKAnmKI349NdAzIhVt5hq7/MIQdHKUeKkDeKu4ZyAhiY9n40TmVdHuEFblbgcKEKnh5Vy8/+IdgYnNg3/M5euenwuK8YBkQIgnNzdPYXuN9eoW1EpiAPG55gIRIdybCGo1dQZcK4usrHutlPY5abAsJkc7SaTZZSb4TG7LMwjoK
 skncY6IT
 rGcHIS1dmFjXOVh6Izzn25V2Au7gIRT3PkVAWTvIX4dyPvTjJq9dNag97kQWSxXoY1SOuQih1qYdKymFU7yBlyRfuHloe41KZVFYJek6zWcRhRQxM8OVmnB/P586egBn2lp1W5mGgpdUDv0D+sU8PsrM37S3xt+eBLgY6duWe+NnLO6+izEY2f80kOse/1Ee3TK8fges7O4zT38kSEo3XKuWstM2VlrV196uZ+CuAfkNbFz0hdVq6BQ3T8VTnvAx8ocRGijjC+c0rxlHpGUEoZwm75cJwj/m6boFgmQ2koyjWnX5Z9l8hZwGvZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 13:49, Usama Arif wrote:
> Add a vmstat counter to track PTE allocation failures during PMD split.
> This enables monitoring of split failures due to memory pressure after
> the lazy PTE page table allocation change.
> 
> The counter is incremented in three places:
> - __split_huge_pmd(): Main entry point for splitting a PMD
> - try_to_unmap_one(): When reclaim needs to split a PMD-mapped THP
> - try_to_migrate_one(): When migration needs to split a PMD-mapped THP
> 
> Visible via /proc/vmstat as thp_split_pmd_pte_alloc_failed.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>   include/linux/vm_event_item.h | 1 +
>   mm/huge_memory.c              | 1 +
>   mm/rmap.c                     | 3 +++
>   mm/vmstat.c                   | 1 +
>   4 files changed, 6 insertions(+)
> 
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 22a139f82d75f..827c9a8c251de 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -111,6 +111,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
>   		THP_DEFERRED_SPLIT_PAGE,
>   		THP_UNDERUSED_SPLIT_PAGE,
>   		THP_SPLIT_PMD,
> +		THP_SPLIT_PMD_PTE_ALLOC_FAILED,

Probably sufficient to call this THP_SPLIT_PMD_FAILED and count any 
(future) failures (if any) as well.

It's a shame that we called a remapping a "split" and keep causing 
confusion.

-- 
Cheers,

David

