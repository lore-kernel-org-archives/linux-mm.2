Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C960F3C263
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B9136B00A0; Mon,  9 Mar 2026 09:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69AD26B00A1; Mon,  9 Mar 2026 09:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57C426B00A2; Mon,  9 Mar 2026 09:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1F76B00A0
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:43:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E228C1A01D1
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:43:22 +0000 (UTC)
X-FDA: 84526641444.30.EC9A934
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 06D2F20002
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:43:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZQb15M8r;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773063801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTnKyrf0LGE23PY9A0Ht7/mKiGV1tV3urT+EyE+Hxyk=;
	b=4f7ZwCpcTTwyF1lHuVBQOc7hT2rlJmeUYmpqt6m+2sP5FU5KlYeEp+RsxKIis0NQ5nR1qd
	t/ImP0Rim0lqDjl5yaT19v8HXK5wvKHjj52k/4z44ScrZeEIystuteTQziZ47roCDjB16I
	egnIHJXFCiaqNS5pjVND0lMiTAj8+mA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZQb15M8r;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773063801; a=rsa-sha256;
	cv=none;
	b=4/SI9LMuWIas4ibQoKzf7B+6GZz2MSsFbLPrsJUZnFo3WjBp3m9QecgFGfitdZ0ZIUe+0D
	FLRLjr6NMvXK1zZzsXrNcmXF1i/oxXWWOCtE2JbL69S/xNZA1nO41JQMuzBQReU9KUCDAF
	s/SrCatkiF8RuvPEgY95Cn66rJ1lI1U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4186543F44;
	Mon,  9 Mar 2026 13:43:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63895C4CEF7;
	Mon,  9 Mar 2026 13:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773063800;
	bh=zmy6clpWE/fIfSwygLZAhqxBM8N2z/0Tt68Uy5Q+aps=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZQb15M8rxYvJv0UYuVy3BjBEkCLY1h9j+2RWQ//mAm3xX6WceXqnxkU4KAPcMqc47
	 /9Uak9k3MJ/h0TYdTUn7Ac9tQqUCeKrpXZ083Xz450GT2rMHX5TYSn7TE2OOIreeJR
	 H5f9S7hKuWa3u3c65EUomV/LE/YU5fNB0AST+s3WVjA8ytL//jsYsWAhHNeEfeP+ei
	 l2UdQqYswcS1+0QGd5fVBRbdvR/b9Mkk/pLCp/Y2q3Ac/2R+vM8hoE4/q69Cekjsyf
	 LQTnL/+3sWAOkRBVihWgT/nKXVQTTI8laKUWwE8QZ5Vcnr2WkVMuaQpOqEN9j8KESl
	 FX9xqEf2DSKyg==
Message-ID: <4f2abf42-983f-4cc2-92f5-c81827e7b7e2@kernel.org>
Date: Mon, 9 Mar 2026 14:43:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
 <20260309-thp_logs-v4-2-926b9840083e@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260309-thp_logs-v4-2-926b9840083e@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 06D2F20002
X-Stat-Signature: jtm3wah64gbjxgdex6ck53z7nczcmusp
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773063800-190585
X-HE-Meta: U2FsdGVkX19ziBK+i8n4CtKSx2PoiflVHGZsUgxYNYr1cSUSgsrl2PasrRrifbtPdKhIdh2uJIUWYpciUi7u1y+BqT9a2A9wHpYbQi/k5RVcTx0VW4WtUKKaVxC9T5p8+HD6DWj2qRqeQNLETqEjWUPolIJxqC/lBdTdPvb387FxJV8ODmbgvhAZwX0996qCIZKw4/iiR9+rDQ8wvzgNRCi8h/0rUkf2E3pJWWNe6jpPyF47E8a6YAXv4+XDz1laR+E2JgpR/pWUO5RSAu59KBYX5eD/r6lwUC4hZluzB6x0mhRszx2jL2NeNitfO3i4wcmPS6YjI8uRwlsezssGm8VGiIHu89nrrk9Z/kPaSUwPPZtbSwkTodV/YJ/IgdLjDxBoybMPDCpvWKxv3MRSrmRATDKX28hIyUZ4cNYiGdu3LkjTCihxQJsnhKXNQTGZbzGw0Qjv+8D0vFK4cj2sMNOgcSB2HFqWPRvfS708pGbd+/ZA5lmlFIXL/5ZO7Q0l48MLrbXhSaA3GNWIvZrzBtbX0/nOqgUGHocFDW6MUAasQs2S9R0q0yOb+oMyza9hNJxuhOXDVhCXL+j40UqIBTz6g3nlILLNuQp/yQHmNvLK/ykfF/FrK2LkGn827EsrsjRGT4m6T6a2DNP+RvBpMZce2JEkTmR1seL1FX93G/k+Hja0ziTbz4f6cM+93pjcU4/OM/413XInNiYvnNaX428DRlSwlaKCS+dqu64pB11uxRre3o3KRjKoL56c/tfsCHJyVv+45mfPCEz9iy9kSVcg/98WWDo5Myex6NiPcAx4cWyYPzr9s5H3Gjlzo0xM7fSCxaCrl1Hm1y2LYD0Tw8//0DD21goEFxWSYTK90noPrHak/ADRSnrnRwrRCasFWzTxtOwZxaum+dCBZj3/Owf5ATPHZ8IasWWHTCUDeFkbL8MIzzI3AULPeXxQMtVJqUhL3Ri5ZG212EgCxbX
 xxaBXONQ
 ORR1+N+3izUMvt9r8CWvO8ViTq1KoGQg2DEaqfgDMztguJa07svfXxomVHpkFNEdNVLSVdiQ5K5ndLt5bMuaW40jgWVv3zJhJTgrK2utGvsI80kd8z6OA7f8AYYSIdDwR2e5em682sb66mfAvieQ8P6ohwlkTRm0CYdZy3pj7d3TsdYNbzLqPPoYIn2q5Rf0PGyy8Ip4rQ0VBOCusyUlk+d2q2vBBYlctvw/r9QkFmqf4MJHw5tHpZmvkVCG2IgQFMUXVzLBzAZLjf3HAn5uqwp9rq52IB84xfS6MWKdvtQeK4jKMI9rgC64eF0mAan4cKEF9H99YKiLIZLvMUx4lIuuQih9TPADXqNxA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 12:07, Breno Leitao wrote:
> Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
> anon_enabled_store() into a new change_anon_orders() helper that
> loops over an orders[] array, setting the bit for the selected mode
> and clearing the others.
> 
> Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
> for the per-order anon THP setting.
> 
> Use sysfs_match_string() with the anon_enabled_mode_strings[] table
> to replace the if/else chain of sysfs_streq() calls.
> 
> The helper uses test_and_set_bit()/test_and_clear_bit() to track
> whether the state actually changed, so start_stop_khugepaged() is
> only called when needed. When the mode is unchanged,
> set_recommended_min_free_kbytes() is called directly to preserve
> the watermark recalculation behavior of the original code.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 52 insertions(+), 32 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8e2746ea74adf..2d5b05a416dab 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
>  	return sysfs_emit(buf, "%s\n", output);
>  }
>  
> +enum anon_enabled_mode {
> +	ANON_ENABLED_ALWAYS	= 0,
> +	ANON_ENABLED_MADVISE	= 1,
> +	ANON_ENABLED_INHERIT	= 2,
> +	ANON_ENABLED_NEVER	= 3,
> +};
> +
> +static const char * const anon_enabled_mode_strings[] = {
> +	[ANON_ENABLED_ALWAYS]	= "always",
> +	[ANON_ENABLED_MADVISE]	= "madvise",
> +	[ANON_ENABLED_INHERIT]	= "inherit",
> +	[ANON_ENABLED_NEVER]	= "never",
> +};
> +
>  static ssize_t enabled_store(struct kobject *kobj,
>  			     struct kobj_attribute *attr,
>  			     const char *buf, size_t count)
> @@ -515,48 +529,54 @@ static ssize_t anon_enabled_show(struct kobject *kobj,
>  	return sysfs_emit(buf, "%s\n", output);
>  }
>  
> +static bool change_anon_orders(int order, enum anon_enabled_mode mode)

I would suggest something a bit longer but clearer

"set_anon_enabled_mode_for_order()"

Or shorter

"set_anon_enabled_mode"

1) set vs. change. the function returns whether actually something
   changed.

2) We're not really changing "anon_orders". Yeah, we're updating
   variables that are named "huge_anon_orders_XXX", but that's more an
   implementation detail when setting the anon_enabled mode for a
   specific order.

> +{
> +	static unsigned long *orders[] = {
> +		&huge_anon_orders_always,
> +		&huge_anon_orders_madvise,
> +		&huge_anon_orders_inherit,
> +	};

Having a "order" and "orders" variable that have different semantics is
a bit confusing. Don't really have a better suggestion. "enabled_orders"
? hm.


> +	enum anon_enabled_mode m;
> +	bool changed = false;
> +
> +	spin_lock(&huge_anon_orders_lock);
> +	for (m = 0; m < ARRAY_SIZE(orders); m++) {
> +		if (m == mode)
> +			changed |= !test_and_set_bit(order, orders[m]);
> +		else
> +			changed |= test_and_clear_bit(order, orders[m]);
> +	}

Can we use the non-atomic variant here? __test_and_set_bit(). Just
wondering as the lock protects concurrent modifications.


> +	spin_unlock(&huge_anon_orders_lock);
> +
> +	return changed;
> +}
> +

Apart from that LGTM.

-- 
Cheers,

David

