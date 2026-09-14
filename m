Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5BB2C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 13:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD85B6B0093; Mon, 14 Sep 2026 09:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89B56B0095; Mon, 14 Sep 2026 09:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC7346B0096; Mon, 14 Sep 2026 09:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1876B0093
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 09:39:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 78FD11A0157
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:39:21 +0000 (UTC)
X-FDA: 85212474522.22.E03C8DD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id CCCAB20002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:39:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4P56YCe;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789393159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wu/huhJSA+GFkwb696jBPBeb5IkeG1jxg469TwfDzg4=;
	b=fTe8M1RUvSXJGvfDYBQ9taXnnKppzaR040k+FT7zt/dm8CySEvePSqUz5OcfT6fn55qrP3
	g5F9jBTkCJ2ASKIZMYufTsb81RAjNvng7cslUUIsCeVSN+jXcQG6wJnqntEJeUvl0s2fzx
	K/18FH2JyH6a65nT3S1VAY1HQbDu0OA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C4P56YCe;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789393159;
	b=B+S3aJYmsdlIylifngzby2OMRFUabtq8wHQX4SHcbpjEsWNFFKZ0q6lQuPrjOhNP8zH88A
	o+XJXAzCmjz9y1rvjuLQiHn/cXNOt4TJZTUSDW/+MuDUmIvJ0FRQAPNvv2WO3n5Ori2EOd
	1Ty+gj5MOuo0VUMM2S3p8h7jtSUbLNk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F01FA40487;
	Mon, 14 Sep 2026 13:39:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6D81F000FF;
	Mon, 14 Sep 2026 13:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789393158;
	bh=Wu/huhJSA+GFkwb696jBPBeb5IkeG1jxg469TwfDzg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=C4P56YCe/KX3zg7RJkdmGWFq3zvlv5GWBIwVrgdCtGZNtjqgqtHCpMiCZYNkDk7q/
	 ZtKtMNXyEiXKBun4rfcGHcVM2yDajyOkWD4wZd+tRFdOqx04ZS1bcWjtLi4xYIMieC
	 iKolypAErPf0OKT7L+UcueBqViqXtD33H3SbuYmb0zOvDCqkUnZ40APL5FhFUDId8l
	 YryMSFL6XtUOZPwHwNs2GsPbmEh3l8S1XbRDTs74UJSqJOUqOrcDBmh7jaLBhHNdod
	 d/UEQDHyRVjDctnPYGjRfHotwjW9H5dwTohsjUF2nPmQR4a1xfKQAbEl5w70H9NvGO
	 bQAvLonHuDGBQ==
Date: Mon, 14 Sep 2026 14:39:16 +0100
From: Harry Yoo <harry@kernel.org>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] mm/slub: make the case handling in __slab_free()
 easier to follow
Message-ID: <aqf4IsztnhrXBocx@thinkstation>
References: <20260824122004.3652-1-hao.li@linux.dev>
 <20260824122513.3829-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824122513.3829-1-hao.li@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CCCAB20002
X-Stat-Signature: ekjkood865so6pmzdo5f8nwq55m8mhb5
X-Rspam-User: 
X-HE-Tag: 1789393159-314044
X-HE-Meta: U2FsdGVkX1/jvSBrCCqaOFoY9RpTRjcuK5P8KMdDQKH6l2IhNiXavxyGG0p6Ttd4HiDBWgDrzpSgVHWngCrOd3+otphfJIW4DopvbuYbZN7KM6u3vIuGJ8ClctKjac+9x296I/z9eOh0VMwjpOWunVDWSWZwuAY9FMhGlYQGxhAteXxOZfvTlFOOOXnB/FX08WNKxoOL4dJGMRToN6XKCnLNbtvTtTh7PKPXiwfaPnlTvBr9Z9q0JAb4xCfkA52RBPzAmo0QCS3wmXSAEAiNbEqQ5V6l1hu/L3+IAdJHnk98/g047iRAYuR9XKqySUKmY497DMTbD5yGI8WMlEl/0z2mwxrzHkuVyvajBahQ9nQdyxGbpU73nSmVLcJTpJdzBGlW8/YXKK5Yuhs53IQMOqnYEr0LNcUR7LIRJflNj/5cECranw1aDz7vKET53YSNbYTPSGW1pZDOrCxor2wdbKPZMi/EdpOFAM8kVmErykkESc+6ZqkF07NbopHZA7T1iR33Ap4z+LPgrW84qD8C5eV3HbF/ZorIZ8mIRIGbkTs1oP1X2pqUw0i26gLhcD6PTzv+mAtpDqtezEQF4sQyhTh3gnM0fZaUFoLfnTQ8Mj3KJurgHZc7wkrelNTka41oyboN39BsfljTronpqZPROT9PU2ofktQTrYVYzgWmDVxlWwj+cdi4Sy5o8rDvCeJCAkuEysSeNtyBv00zrEJEzcoZxeeMcnCrjSTM9sFlvrGQmfCRbEJL2Ad4fjhUp4T5zQPJQxAWc6jhkDK2Xy+2ZGSW72D0v4xiYpyZjb1i7sO84Cwa4pcqLDKa9ffyvIhA6qz+jNbN5Cl3wW4jzIn/DiFz9gMvaBupJH6zdkKQXdsgGuDIe8spdPXDqeGLHkuU4XOc+T3Wdh8ZTBx3ihZmqwwqsTLzQWjb4kIa/eKPK+2kYtSPy9eL9OzsPr93CHfFoNP9NghtgV/WBHmYM2D
 d7PJ9sEv
 aWcgNs29uC2urPu+OZVO8egSCb5I2uWXsxHaX/z4Pyf2Bsa1pGIsnLCIcfvdiWMJ+tN8HT126Xkoasnq53RY6eysFr+Ca+Stt5uDwcm4QiXqexnJXg6aoxKNeBd0a7LZ02D58dOVwYeWJK6zcgQv6sQDnrq9MRKlqvu06kbA32nztrYGgO3DJCrQ3QScXH+TdqDugtF15osMfJ/B2HQbB+WhiecPVNvzChhcA2O9VYaohxKpbvI3stTprB8D349YSuzlLMkmHh2Ex5VUsJ+ksV6DLlHs86o2lgIT/u5IfIh+foQEP2bWmFxpeMzVixDvETtn5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 08:25:09PM +0800, Hao Li wrote:
> There are 7 possible transitions in __slab_free():
> 
>   a. partial->partial
>   b. partial->empty, offlist
>   c. partial->empty, onlist, exceeding min_partial
>   d. partial->empty, onlist, not exceeding min_partial
>   e. full->empty, exceeding min_partial
>   f. full->empty, not exceeding min_partial
>   g. full->partial
> 
> (There is no offlist variant of e, f and g as a full slab is on no
> list.)
> 
> Clarify which case each branch handles, and replace the goto with a
> return at the end of the skipped block so that every branch explicitly
> states its coverage.
> 
> Case 'a' is the only path that needs neither list_lock nor list
> handling. Give it an early continue: handling it upfront is much clearer
> than forcing every other case into a nested block.
> 
> Also, read SL_partial once after the loop right where it is used, rather
> than re-reading it on every iteration.
> 
> No functional change.
> 
> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---

Looks good to me (with Vlastimil's suggestions adjusted),
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

>  mm/slub.c | 95 ++++++++++++++++++++++++++++---------------------------
>  1 file changed, 49 insertions(+), 46 deletions(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index b0cd0572e2f2..e20375307770 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -5748,76 +5748,79 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,

[...]

> +		/*
> +		 * The slab might need to be taken off (due to becoming empty)
> +		 * or added to (due to not being full anymore) the partial
> +		 * list.
> +		 *
> +		 * Speculatively acquire list_lock before calling cmpxchg(), as
> +		 * performing cmpxchg() prior to lock acquisition races with
> +		 * concurrent paths, such as the shrinker.

nit: it's bit weird to mention shrinkers specifically?

-- 
Cheers,
Harry / Hyeonggon

