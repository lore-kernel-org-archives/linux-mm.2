Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB6C1CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CEA96B00C1; Wed, 13 May 2026 11:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8446B00C3; Wed, 13 May 2026 11:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BB3E6B00C4; Wed, 13 May 2026 11:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 29EEF6B00C1
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:31:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C5FDA1C00B3
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:31:03 +0000 (UTC)
X-FDA: 84762784806.10.75E2618
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id A0538C001F
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:31:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQ69U3Jg;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778686261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/i6A2lIyfBPVQrxT02D017eSBVTMpvEdKpIeCFZGzlY=;
	b=JVSRIbNQSoDDaUSh4fkbbubQs8QUl5mI+RHD2GKjxYV1iGPs9QloHJBL+I+5RChgMc6UIk
	RU5qt6s1yy51PdDWlox8dSIUTgM15XHaHhWtCiMZIRn6ggbPcprzujuEVyXEH642lUg3NL
	LSN747OG7Q5es6mvjCraEyT27FjTMzQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vQ69U3Jg;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778686261; a=rsa-sha256;
	cv=none;
	b=dQ3OdzzX0fvMjKyViFDjZXRBuJV8ajPUgLEMJpj4FD8f4bR7B9Ja/sy1MMqPfKQlbZdZ9Q
	aABnLxv2yyJAvxfewT3qAc3IqjX3zvSc05Swt7cfCRKsd79vRRFN2V5RyjcbCLXEqH9xHi
	9liw118avj7wJjAPWnKkr2wsQnlkiA4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 86B7843403;
	Wed, 13 May 2026 15:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCB27C2BCC6;
	Wed, 13 May 2026 15:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778686260;
	bh=HxOcaNkSWUrdTUDltrD5t+kOiINvTITwK0zOY8qgjio=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vQ69U3JgJfPfLgdPT89HklCWlbGxdnacToxrAy+GebEnGkVo5+GinCzNpjtLlsxt9
	 zrqh9kh3urTQ1/IrAvUc1EJgA+ZKuV3lnzGRlouyg6U5WMafMRqwyFO4Q6NcBYHbqq
	 p4RhwSZM8+yJAEDgrJ23ddmmipAP2tOlgy8gCqdaxfz4cVDSgPdZHmdhONYYQs5qWk
	 v53ozJXLnHNPUSe5T0fK+JFAsLjTkohmiyIVvj9QXloQH6/aAiHkfywJmkSUGq/wWq
	 Y/9X27rIcD/k0e1pDbWHJ1aHbzpvQkGCUcD4uBYb1KLD7+Ouqo14Mn9vvqdb8182S2
	 3Cocbx/HILB4g==
Message-ID: <8683a04e-54e9-4e8e-8931-69e31d15b99b@kernel.org>
Date: Wed, 13 May 2026 17:30:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] mm: introduce pgtable_has_pmd_leaves()
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <2a0bae00cdd2b6ef6b962610b523ebfc97806ba7.1777663129.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <2a0bae00cdd2b6ef6b962610b523ebfc97806ba7.1777663129.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hobdjhry5jcp9awbkfjz6p9ryg1uuafp
X-Rspamd-Queue-Id: A0538C001F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778686261-156894
X-HE-Meta: U2FsdGVkX1+dpkFg3lKOY9at33ylyc/PhVbtMa7G91zT8R/UedGsnjsTgpPG2bB1ZgvMOvCeqIBdLj2Sc43fxIHjBUlZRjdMambKjIqd6q7kwvtddr5IQPijf3hm6EMGoPQV+4WSdavh6PpVwhbZS0qGA+eFD1S9CcWYWuHZtaJ2p7YHDpa18GjG9EnJ/tEjRipbOzoNyEL6yIxlhxiSbXFaqeaN7nEoA+JPGh5xcfe/+NAsiPR6c0kuqbbSql4XYR6ZNsiOghAfaCePfDaW+cPXbNYnPoDKs0YoFzNolCAfWTQYwcW2A4D9aGCEUrm8OfxCqQslOXbRwe1iLJwGYi+B2oYiJSqlz2Nd9EukTAHSjAhtZC09X8A2FtvtvR7XyYL9nrpCeUvHGjafVyH3w0lU5Q40XzukH7aft1dt/hTgHIi5R09HIMxjoYudtBOBnSMMkpV11nTcc1roX0hMf9kDtVDw/bvNT+a0/hpAYxnfJ+TxKKo35aw6GhUnzDm4pafHWLOZjtR89Mo0QrraThrARiw7lvRhA5EqehDsZsJYBLZAHy9c04eygIy30LhXZ/iN6Gk7ahy4JDmg0GO/hmaLKb/X8RpjDV66mwQm16wznO0WJSvde4KykfyHvwNqVH3p5oc1TIx8NsVdrPTrff0qw08YcZgjUPy7392RElegJi6SjnmUZvoeJf3Ckjj2say/I8QS8gG4tGSlnUmB+ekGFjMfM37mCMKF2HoVWfcwJ8lqVTO6SbJcRSIWp3LHBjQK37CC5x5j0ueUn3meKqC45x+1Ot+aamfjC+s2on7LXdG34pvZHmJb/A30yflwh+8QPQE0kTOoK0OXlWtz47+cvmqualEqXYM5b2nr0C2V7tmeg3BGaqDWY6e6evVcpwwNCbwKDlt0MbOwVXmSNKh4g67GXZWTX2BldHhVhU4g3Vy9yVqjIkN3SlMU244LAm2kJAgkg99xG6iKo2M
 JD9smIbg
 0s4fTgHhGw5mMazur42+9cbmsD/U1pvyBKuL5M8mZbVq6i7LFLusj0SBTMrk5AEYcF+P6dFemN12Z2owVFJnXNf4d51ep7JLuALJDUFiPM4EaVIapgaY4FvrBW0kgAxvHYZY/nRsjwBKKhmduXxkhDYzI7zpUHT1YG3irvAu5LASl3LHrEn2Fnb5W4bxYcc9OU116eOfStZ3EhY3V1ge5DEMvTTAUIVUX+xBJqTYpbNIBYi9CYYqhwxvOmGwHy4qIETs2YuVFe0az0WXgEu7lG7yVasWoDeNAWmgRPDvgWI7QHmTilaB9bSWj9JvhDG38Q5WJiVDgDoZtRhU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 21:18, Luiz Capitulino wrote:
> Currently, we have two helpers that check for PMD-sized pages but have
> different names and slightly different semantics:
> 
> - has_transparent_hugepage(): the name suggests it checks if THP is
>   enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>   implements this helper, it actually checks if the CPU supports
>   PMD-sized pages
> 
> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>   by the hardware, but it just returns a cached value acquired with
>   has_transparent_hugepage(). This helper is used in fast paths
> 
> This commit introduces a new helper called pgtable_has_pmd_leaves()
> which is intended to replace both has_transparent_hugepage() and
> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
> it returns true if the CPU supports PMD-sized pages and false otherwise.
> It always returns a cached value, so it can be used in fast paths.
> 
> The new helper requires an initialization step which is performed by
> init_arch_has_pmd_leaves(). We call init_arch_has_pmd_leaves() early
> during boot in start_kernel() right after parse_early_param() but before
> parse_args(). This allows early_param() handlers to change CPU flags if
> needed (eg. parse_memopt() in x86-32) while also allowing users to use
> the API from __setup() handlers.
> 
> The next commits will convert users of both has_transparent_hugepage()
> and thp_disabled_by_hw() to pgtable_has_pmd_leaves().
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  include/linux/pgtable.h | 15 +++++++++++++++
>  init/main.c             |  1 +
>  mm/memory.c             |  9 +++++++++
>  3 files changed, 25 insertions(+)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index cdd68ed3ae1a..b365be3516bf 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -2243,6 +2243,21 @@ static inline const char *pgtable_level_to_str(enum pgtable_level level)
>  	}
>  }
>  
> +#ifdef CONFIG_MMU
> +DECLARE_STATIC_KEY_TRUE(__arch_has_pmd_leaves_key);
> +static inline bool pgtable_has_pmd_leaves(void)
> +{
> +	return static_branch_likely(&__arch_has_pmd_leaves_key);
> +}
> +void __init init_arch_has_pmd_leaves(void);
> +#else
> +static inline bool pgtable_has_pmd_leaves(void)
> +{
> +	return false;
> +}
> +static inline void __init init_arch_has_pmd_leaves(void) { }
> +#endif
> +
>  #endif /* !__ASSEMBLY__ */
>  
>  #if !defined(MAX_POSSIBLE_PHYSMEM_BITS) && !defined(CONFIG_64BIT)
> diff --git a/init/main.c b/init/main.c
> index 96f93bb06c49..eea7c5bdddf7 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -1053,6 +1053,7 @@ void start_kernel(void)
>  	print_kernel_cmdline(saved_command_line);
>  	/* parameters may set static keys */
>  	parse_early_param();
> +	init_arch_has_pmd_leaves();

Can't we do this a bit later from some mm code?

This feels like something that can just go somewhere into mm_core_init()?

There, we should probably call this something like XXX_init(), and prepare it
from detecting support for PUD leaves as well.

Maybe just

pgtable_init() ?

-- 
Cheers,

David

