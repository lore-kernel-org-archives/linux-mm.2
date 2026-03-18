Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE358103E16F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 12:52:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8EC6B01F0; Wed, 18 Mar 2026 08:52:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69596B01F1; Wed, 18 Mar 2026 08:52:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C581E6B01F2; Wed, 18 Mar 2026 08:52:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEBE16B01F0
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:52:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F9718C268
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:52:53 +0000 (UTC)
X-FDA: 84559173426.27.BCF7A02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 72364A0015
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 12:52:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CnxfgZi8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773838371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Siw0Vci+fgOhxe4i0CpODPwJ3AizVXulBCTvtruqMVQ=;
	b=JV+10bzyOCUpCwuperlQ3BuIGLKmcBsb4vgh+HrI40BIQu9MJxw8RUDv9FmnPnF1PwIIVX
	KEJ3WqoWGufz98ZVG9ed75cLBOctdYrMsepPC7ZERKZpL0gUMPam4VEsSe9Hr74dUS82mT
	LQRZ5EosAakUw53SarWOWpJH/xOk/Q4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773838371; a=rsa-sha256;
	cv=none;
	b=zohBmpoVbypxckQfcsRD9N7A7Q1StCAMdyNewsnqrHYlMyUC1EXYajvsAGe5TcxYu8AeEZ
	pR/n+9vLFFVR3zx7OpNUoBIAKAUznAegmmkUNTjFyq3/csEKrAmS8aLSTecuXC/PKIy3o+
	UUG7YTgvbBjsBn3dpNHe3z6HLSiqXdo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CnxfgZi8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3032440020;
	Wed, 18 Mar 2026 12:52:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA636C19421;
	Wed, 18 Mar 2026 12:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773838370;
	bh=hY9zrD+8dWbPOdV/O8dA0+8cEO5ABp1kKvDZvDUe8jQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CnxfgZi8Z8Z3rVfXN2/Gs1WhHf7iVuaNhEaJfpCPUIj48FTumqXvz6XEoJa6B2J35
	 JIjnTOdJCsnRPAg/NPnlO1KbB6o+w6FKCu26DLqFNfvIu0DYuzxA5SVerbZcMj9Fh0
	 rwc2IYYgRBCE4v68ts1dwQ/fYb6a5PG7lUCbt9BjXeDIqvjZG93g/tGbrdvLerCYhk
	 mwzjKGC8Im5EcnhuRiiOONUYi4sSLoJk+b2Z+Nig2r/s0BLOY1SnPzKxerSyRb02fP
	 E2VTnop3M94inE5cK6BWm0eUoCPbtyxGdclZaGLzyBR3EgJcnJMuQisO5SEzqM2DH0
	 o4mq2o184guxg==
Message-ID: <e71acbdc-f46e-4dac-a88d-5b297f518dd3@kernel.org>
Date: Wed, 18 Mar 2026 13:52:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/rmap: clear vma->anon_vma on error
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry.yoo@oracle.com>,
 Jann Horn <jannh@google.com>, Sasha Levin <sashal@kernel.org>,
 Jiakai Xu <jiakaipeanut@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260318122632.63404-1-ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260318122632.63404-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 72364A0015
X-Stat-Signature: mw4kd7nzcup98espm1de4ntnmztwz88k
X-Rspam-User: 
X-HE-Tag: 1773838371-910122
X-HE-Meta: U2FsdGVkX1/Lr1+EJtp76j1JASsnEWoBTiSBrLJzE0DoOVZOd51vxtbxMUTbgAT/E+EOzkgkWmpAKd1DwZVLimJljpfIOwlV9ujWhEMbl5eMKzMWFGlaUv5DRKNrI4fOeRdMxVWKFsIa4W4qBQi9vYcEdyA0oZPJIvDvGN6RbhJ9owrcCMZ7cW7HsBOizGLG6rP0BqRjvt3CmzJnyBHhf/4ibDqbQbuvD7SqCFcK9h6fz7WeWwrMqggotQQHZLWxl4wJMkngnO1fqgO6oi5q15Qm8586ymjdJfattJztSLiLYT/KVft+cu0hgX9EBEVAV+ItwAOzQRppfen2Uy9XfFaaIKHMO1D8rOzQftvaFX16U4u0DgArDZhJGTe9E9SAk00rHtzS5CBosAO0Ws7QJoNHNB5LHTMO1zR9DZM/cXWDO1F5tpZYWI/YhBKAEFFn82zi9RrKsdAvH7NymM9Z2KcpYuxb42Yqpsj6iJLpD/f+kZ4YSYurOwKS2l4swd6/QpBcI5ZH3KxdF79xAaiFXh+CN+kOh//CKhC0914Qla3xS6J1IORl2MAMMEuWtASXC1iK8THDzCvIqKNHPey7xmqJpm2qHpAuCx5nIfxGXh91TtDyk+RvFqV5iQVM/sDm1/iXBfSJPkThr/7RCnkfCm6itmH+fPqrR9ye0vfUoxo6hDDhJuPdCGhs2zw/0woKcvC8yPE+kgL+4gqyUBe11b9H1hWM8qCk+ftyokqq4bNp+iE/A7KRlKHslTwIIggfjNYqjmY7AxKhkvNPdRovyezo+QeDZtXyi2j0EAh/Nl+C0s2NpmKjL2StDBgRMJe8z3lrec5J683p1zlYVaZIUKF++yyR2mPfQSueks5UsmW18L5j8tqGcHwCj/LG/StBvfbrV0mfsaRxhxFw5grOWGxVOeLYRj1EyqPFd10tZ9j8i5r3jTwaWCaqMPVvkeEOfJvUcXLVv2ZiQDrBFol
 5hT1xQw2
 qK5GWHPR/Spm7IQTU77OHtzJkcsvYkjPJglpxQhZT7LNXjXQBDTntnQijGpinrb+Z4tUekNaPTJosPSw2xNQZXIEKMXDomngthJpvBhDm+toTjaco1eWRQ8B1D1AlTG6DOu+Ouu+U3o+5E/N+JqoN+dADOy8XYiFwVfVgxL2evvClmBvYdd3+KbkjyBNn2ZjmNYY0xop2z2IukRqp1V11NNUFf4xFIK6VV+iTShnARlBUVPPuyj8FHlGCu7tnla/EiKwNPhQCx4QPpM+sPQa+eZijpG3aXQULfFYLZGh27hnVLrbz/fLoX7ZDxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 13:26, Lorenzo Stoakes (Oracle) wrote:
> Commit 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas()
> comments, add asserts") alters the way errors are handled, but overlooked
> one important aspect of clean up.
> 
> When a VMA encounters an error state in anon_vma_clone() (that is, on
> attempted allocation of anon_vma_chain objects), it cleans up partially
> established state in cleanup_partial_anon_vmas(), before returning an
> error.
> 
> However, this occurs prior to anon_vma->num_active_vmas being incremented,
> and it also fails to clear the VMA's vma->anon_vma field, which remains in
> place.
> 
> This is immediately an inconsistent state, because
> anon_vma->num_active_vmas is supposed to track the number of VMAs whose
> vma->anon_vma field references that anon_vma, and now that count is
> off-by-negative-1 for each VMA for which this error state has occurred.
> 
> When VMAs are unlinked from this anon_vma, unlink_anon_vmas() will
> eventually underflow anon_vma->num_active_vmas, which will trigger a
> warning.
> 
> This will always eventually happen, as we unlink anon_vma's at process
> teardown.
> 
> It could also cause maybe_reuse_anon_vma() to incorrectly permit the reuse
> of an anon_vma which has active VMAs attached, which will lead to a
> persistently invalid state.
> 
> The solution is to clear the VMA's anon_vma field when we clean up partial
> state, as the fact we are doing so indicates clearly that the VMA is not
> correctly integrated into the anon_vma tree and thus this field is invalid.
> 
> Reported-by: Sasha Levin <sashal@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/20260302151547.2389070-1-sashal@kernel.org/
> Reported-by: Jiakai Xu <jiakaipeanut@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/CAFb8wJvRhatRD-9DVmr5v5pixTMPEr3UKjYBJjCd09OfH55CKg@mail.gmail.com/
> Fixes: 542eda1a8329 ("mm/rmap: improve anon_vma_clone(), unlink_anon_vmas() comments, add asserts")
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>  mm/rmap.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 6398d7eef393..abe4712a220c 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -457,6 +457,13 @@ static void cleanup_partial_anon_vmas(struct vm_area_struct *vma)
>  		list_del(&avc->same_vma);
>  		anon_vma_chain_free(avc);
>  	}
> +
> +	/*
> +	 * The anon_vma assigned to this VMA is no longer valid, as we were not
> +	 * able to correctly clone AVC state. Avoid inconsistent anon_vma tree
> +	 * state by resetting.
> +	 */
> +	vma->anon_vma = NULL;

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM. I was wondering whether anon_vma_clone() should take care of
setting up dst->anon_vma. It looks a bit odd in dup_anon_vma.

-- 
Cheers,

David

