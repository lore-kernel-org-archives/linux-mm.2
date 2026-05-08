Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E11CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 19:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FA586B0266; Fri,  8 May 2026 15:40:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1896B0269; Fri,  8 May 2026 15:40:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E9486B026A; Fri,  8 May 2026 15:40:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B4486B0266
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:40:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 98B291A02C8
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:40:11 +0000 (UTC)
X-FDA: 84745268622.29.4A545D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D49E518000F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 19:40:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SBQl+v1b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778269209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lvl8DYF/MK5C/E7HOFJI0Yabm5mn0iYRdmJ81bmQVh0=;
	b=bUEawKwPwgi2lDMKlYLAoGSzAXZmkBHz1yhWIXUpxZcvGi3XLLeEmQHlFKLSNnQBdtRh46
	0c08ncaMxlfC1n1ISULancl0KKC4RzNNbjeb3EvdhBtfY3RU7cKhs2bfzARuM9PxldaVwP
	5Q7QenMTeViESjSAPZH9DOcvkJRjo0o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778269209; a=rsa-sha256;
	cv=none;
	b=P/sa9EMhdLbVaNZfifxpOzEtV2v/HphrHLeDNOhKdd1cYEuQlDmk0pIPRNBQAlJNSJmbSc
	XlCzIvHMPNwtr9KTJy6ly1NpMpkJ+YBmd6sCnIahC9w4e1WaFZLeFYx0XIMcZ7H2GF5rNU
	He8xWJJj6HLHrfTvDBwEN4s2vK6szTc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SBQl+v1b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EC0B60181;
	Fri,  8 May 2026 19:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E9CC2BCB0;
	Fri,  8 May 2026 19:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778269208;
	bh=bEvGjngPqBRZCRr5j8qzVVNl7z2K7O10AOSptjW9O80=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SBQl+v1bR7jR2dnGJULf2Jju99Rm/OtQ0W4c8kKHsUGraUwF4B5mXIRHRN5421WyY
	 8Zw9o3blCEjNi9rqBlfGkx/6V/AHiDYhNZ3HiEmvYBUD5lhK89eOTldXPW5Z3jy9tz
	 Qs8xSIZUersqClg5HRXkl3yYOmZV4rCKUiTAIwEq67EtQzKzJEfBsUrnDOol4lTxfq
	 XCiiwTcwSYkxnGbu8R5ykiFfxnvOzk221t4U0lL6YNXvilYJekcUSHd2I691A0j3A2
	 tTSdvTYtb0KVCBkYZe01wq5nBd04/Szq3gjTRFkOfUWeRUUday7DpZn9xYHN2na3aj
	 tivyvj0NJhQMw==
Message-ID: <ed7f1254-f669-477c-8005-78c380aa35c7@kernel.org>
Date: Fri, 8 May 2026 21:39:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/14] mm/khugepaged: remove READ_ONLY_THP_FOR_FS check
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Song Liu <songliubraving@fb.com>
Cc: Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260429152924.727124-1-ziy@nvidia.com>
 <20260429152924.727124-2-ziy@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260429152924.727124-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D49E518000F
X-Stat-Signature: ee8xaccdtgh17jzoncnypiwqqsymuin6
X-Rspam-User: 
X-HE-Tag: 1778269209-367678
X-HE-Meta: U2FsdGVkX1+IbkzNcJ4hsw4kWNwpKZlCdyWQeSCvtvBEHz7I4rqsLFo3wspVvTQEPeAsmp7P71qRYjQ9KpSFUPw4oYDs1iQ+WMmWgdOq1oiou29d1sZ5S62AbmKWDEBG7CssOOvLT5nUj0f/l7GPTmOisJhzGJzkdJf4vOM8nIBPofQKucmYO1X8UeaeRlsqfMvYWv0VDpz3jWhjUJOQ6aiK14i11jY8sTY8dLu5bTLVpfH6YxpQAyGEAJ8CdUCp27mQQB4l0s24kw2Y8+/9V8Mnx0Ph2rGq9bmWGqQOpdbuJzYsbWoZDVzZdlyqd0arCtcbKVMcWtSCRff7QQhfwK6NKkLEBEGxEbmH/1dvUdJTinWCzg+2ET6IU44tQ92ma5eTS0fdiJyfv4vggOFYctTM4RDDsLwDnhAIKtEvyEckrf4kZGhCkDieyEfSLTRKf28q8O0NVpr3m95x1t8a9nPeDA1uiEuriSu6euhnOdw4n5r+PnYWi3wmXApHMrkMb6+NwNZEtUjAmlBk+5DhuzqbaSNFkI+uHClnhEYtVuyLVTDvSvWPayCvpwRDC/aYDe5IwxqcTMEeMPcvEqJxLZYo8PtOZHCHxe8LISpfSDdkVcAQNcTOTCt8nERBz2RCDP9ONwMyLxiq09sHGme0R5JZ3aN8vko9qhDR/7z0xhygx/ZDfJ6nwzAvPLbyoqUMuEhp6NnUjxJ1RdNkcLxhwcVqLsH5Wisz2Byg/ONATGepHiSgx4rJZGLPzkVt9MQ/R/i+b2qAmtnAARK1qtgyhadlIJe6Uxb2S4HfWvVtw90E3L4TbSMH+xuCYGDZnw6Xj7T7LbNB2QG2CBD/WfbvYclnZhuk+1jvA6MlkCFBBX1g0/urbenfI2WNQi5tivkkF5pNcQZDglkDALNQRBgBJJlW7ANDfvDjnGSLWKa0REwfD0AAbPJLLzHdxra/87ELUtxC3RzqlBfcEbKEGj4
 5r3yqEv7
 Sfy+nOZ6YPDZSWUxMPJbleAOuXSzHPe74dXIF6mFOTQDLuke1LQZLESeInyvr6dtUOPVADJ4yAxeVx7TM40ISI5CvqKdxlO5fXhsRoBoOkV9XsJ13SyW+7Yn0AdOdzYF/R6uFdwrtUocphjzhI3ae3gYj3wfhBGFvs2hjPhJaQNTunbouNduUsI3FyqGeUNc4rQLkP7RIDqr5Qd4li7SFNSCr9VAKioCBJc0o4VuKc3lyfVVh3uM8T7NNUCgkIEmD7zA5Xrix0VAggLersEZbsQW/kMDXV5vvBl83CEs/sQ3DdFDxLFcRxq2JTaZvNuO0H5GNz+GLIt2jf7BxTzgAfPI1Q6UPqKymnBpgo5X1x3cyTg5t9yJ8vJWQJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 17:29, Zi Yan wrote:
> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
> 
> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.
> 
> Add a helper function mapping_pmd_folio_support() for FSes supporting large
> folio with at least PMD_ORDER.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  include/linux/pagemap.h | 26 ++++++++++++++++++++++++++
>  mm/khugepaged.c         | 10 ++++++++--
>  2 files changed, 34 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 1f50991b43e3b..1fed3414fe9b8 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -513,6 +513,32 @@ static inline bool mapping_large_folio_support(const struct address_space *mappi
>  	return mapping_max_folio_order(mapping) > 0;
>  }

Some smaller doc improvements:

>  
> +/**
> + * mapping_pmd_folio_support() - Check if a mapping support PMD-sized folio

"supports"

> + * @mapping: The address_space
> + *
> + * Some file supports large folio but does not support as large as PMD order.

"While some mappings support large folios, they might not support PMD-sized folios."

> + * If a PMD-sized pagecache folio is attempted to be created on a filesystem,
> + * this check needs to be performed first.

I'd rather just add (relate to the previous sentence):

"This function checks whether a mapping supports PMD-sized folios. For example,
khugepaged needs this information before attempting to collapsing THPs".

> + *
> + * Return: true - PMD-sized folio is supported, false - PMD-sized folio is not
> + * supported.

I'd say "folios are supported" and end up with:

"True if PMD-sized folios are supported, otherwise false."

> + */
> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> +static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
> +{
> +	/* AS_FOLIO_ORDER is only reasonable for pagecache folios */
> +	VM_WARN_ON_ONCE((unsigned long)mapping & FOLIO_MAPPING_ANON);
> +
> +	return mapping_max_folio_order(mapping) >= PMD_ORDER;

Agreed that this should check for ==, although in practice it would currently
not make a difference.

> +}
> +#else
> +static inline bool mapping_pmd_folio_support(const struct address_space *mapping)
> +{
> +	return false;
> +}
> +#endif
> +
>  /* Return the maximum folio size for this pagecache mapping, in bytes. */
>  static inline size_t mapping_max_folio_size(const struct address_space *mapping)
>  {
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e112525c4aa9c..6808f2b48d864 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2235,8 +2235,14 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	int nr_none = 0;
>  	bool is_shmem = shmem_file(file);
>  
> -	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> +	/*
> +	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
> +	 *
> +	 * TODO: once shmem always calls mapping_set_large_folios() on its
> +	 * mapping, the shmem check can be removed.
> +	 */

TODO LGTM.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

