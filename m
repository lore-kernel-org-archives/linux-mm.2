Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2650FEC10B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 20:13:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97256B0005; Tue, 24 Mar 2026 16:13:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D56F36B0088; Tue, 24 Mar 2026 16:13:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6D246B008A; Tue, 24 Mar 2026 16:13:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B80326B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:13:06 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 32E141603B7
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:13:06 +0000 (UTC)
X-FDA: 84582055572.05.3FAB4FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 63D8BC000A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:13:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4hSFRzm;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f4hSFRzm;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774383184; a=rsa-sha256;
	cv=none;
	b=OPWhYYWVN4En5MGqvfvoX8yS+hZyE5NYSxe8FnCqP9n7UO2LKyOgfijjFHzYBFG5PtM7zW
	T2uuks7GC9dD13KlY08149KaCCK2loB3iz4qr4+XW2OKTWKU6dCYXnOJ4CKSz8LS87bkxK
	T8myPnszkOQm/8+9xvS3Fu4kgKhX2lY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774383184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9ENNJ2/WStIIHgcNADkEqIcixjD4RHhbJS24gMLHf0=;
	b=E4SjHph6otUfWA0EcO51Q2DfTeRcQOKLoiQqs/wT1Q+KXqAY1j/pC2keilCKEdWhDKZbhv
	SyD56oeIzogz55z0Xyoj+xgocN7PUVMBw3sRd75hjnqfmv4z13smlWZ6AynbUffU1PAHT8
	KveByeKaUUEHMDnVsKntHZ92YAycDEA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB2E5600AC;
	Tue, 24 Mar 2026 20:13:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68964C2BC9E;
	Tue, 24 Mar 2026 20:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774383183;
	bh=Ntqkf0j8AhQ1QfbmlWiRJGsbUyfajr+sdoox1lR0fqE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=f4hSFRzmOajxJBAfaNPOWzCVUDlIjeYpWV6tIqLeyaiUd+I5UHC8KBJ4Bfqomwk30
	 18rXLexSoCDcXcyMAAeyjEnTQiiYHbbuJydZGfccJqZ6xS5ID8JVC2eivG5aP4Kc/d
	 +jmx3QDKkRmNEUDol3c0YFdvpjQD8+Mst3Wz+i+Ti1X44+CHI0I3JCa0WbVXr/tI/g
	 2sFr5SSjzclH0tgWNOK7i+NpQh4lmyAB+zv0To4r/Xs/wAZQAGpBinJXYLS+xWCR+B
	 DgX0X6B/JLpx8Z/GKk6nbhUjIzXdy6qiQ7e77LO9Tor/2FM8IyqmqK1IGxRBNl1aDV
	 4k4eI8OI0pmIQ==
Message-ID: <aa7d5f7a-5fa2-4363-8061-7142fe4d10d0@kernel.org>
Date: Tue, 24 Mar 2026 21:12:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/mprotect: move softleaf code out of the main
 function
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260324154342.156640-1-pfalcato@suse.de>
 <20260324154342.156640-2-pfalcato@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260324154342.156640-2-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 63D8BC000A
X-Stat-Signature: t793om5nsg64xr8j6qmczs5jwzez7uhh
X-Rspam-User: 
X-HE-Tag: 1774383184-552868
X-HE-Meta: U2FsdGVkX19zGjQVwcNk8Fx1RxcHff3kPZpC/kKbz6zN4Yt8FSCZkchQQ84ii/iRo61exWVypqQsVgclqJ+/tJrTEjABS3YsU7d+iXh+opbLh/qegLK62aKLuCgHmkGXgC0IuvnE1NzVgPU7RKOxjj9LD0FVnEyxkzfDvVXvHd7niso7jCKILtgcXFHDis61DyKdchc5fzazeb9VhWbsXPyczWoO7Yu0m1nT9BVj5zz36iOoJOKNp6AD5+qPZG/nmqPHxYSdtRc/s5Y749nt8FyO3cCtYWPkUt8qOFJY0ui5/oZLbujqvlJHhAOfQF/ptpX6waeqG4EaKLxuD33gWIbUD6ICOu0HcKq/z1TvaOflBI3lZCX1/P9e9UmGzWhoOADYbQ2y5+E9sgtAtDu4fM8pDJ5y5kXjBv13MNI66Ym2YkCAq8KevO0bnwpknpq96SKtY1ukNOylm2oWQjHs6+5eGQTS6dRNDWAX3jAH4sygxaEPBWYbqBfi/2fFORQVITVwtoX6VnyugKMv5/svfvKqz96i5DZzm/yshaZ2lm4cuFKPGcMjTtg50y/bzU/NoxerQhG6LscTI3c3N+xTVhAMj7Qqe5Vb18jelm1TNh/401Cr/hm5Nhe5wa5m5+FnKAmsN2s5qFD0yRhCUKMtRn7TThofNIGZki25258J0NNAWSMllpV8kv3xkRLJuGYfac4nb00/o1gEF8uNWZEjX8elQuP2ne5EvN50mgrKVaMZ6/UGX2my1qORlP88woqb926LyA8S9tj3Tv/8H77MAoWX1ZyP2ERrIY+vre+KRb9bN6v8rcUdiAMtFPdzZVZVaM2XSN0levC72uCDK/J+ugW/g3cRdYTo5RSCj+czTEU7v30RT9dur261VnTQ9OfPckuCgOsimWPKYV/R6BmqCm46DDd4I+GHaeHumRmc3t1T9rWWmxn89LtLJAHgn81oDMbCAnVNhE+R8Vx37TY
 XXkQHzq9
 mEQrN5yJzt1InTMA27/uKciZragwg80e24JU64NBbMYdGMQKsZi6kTY1FXxodweCHgYujkyqo98HqJV3r5HUfUpjDOnB7JsUGZK1YXVHAvj9588ZkzMcGxKxl+2+W3Ps8cI7FV+ondA57Ss1yY6fCPCqS5DPr2VE66kFl29lqBBje99duPIfa5Gv+kBf5+yF6Rc40wIG6Pp6Sb0HNKJtBSIrwlvWHAlJ0oZ4kcEchnQo1E0KjdMmekC5XtPS8iIe4W8db+7eA7GeaUeRRqvaY7vPXEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 16:43, Pedro Falcato wrote:
> Move softleaf change_pte_range code into a separate function. This makes
> the change_pte_range() function a good bit smaller, and lessens cognitive
> load when reading through the function.
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  mm/mprotect.c | 129 +++++++++++++++++++++++++++-----------------------
>  1 file changed, 69 insertions(+), 60 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 9681f055b9fc..2eaf862e5734 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -211,6 +211,74 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
>  	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
>  }
>  
> +static long change_softleaf_pte(struct vm_area_struct *vma,
> +	unsigned long addr, pte_t *pte, pte_t oldpte, unsigned long cp_flags)
> +{
> +	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
> +	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
> +	softleaf_t entry = softleaf_from_pte(oldpte);
> +	pte_t newpte;
> +
> +	if (softleaf_is_migration_write(entry)) {
> +		const struct folio *folio = softleaf_to_folio(entry);
> +
> +		/*
> +		 * A protection check is difficult so
> +		 * just be safe and disable write
> +		 */
> +		if (folio_test_anon(folio))
> +			entry = make_readable_exclusive_migration_entry(
> +					     swp_offset(entry));

We can now even fit this into a single line without feeling bad :)

> +		else
> +			entry = make_readable_migration_entry(swp_offset(entry));
> +		newpte = swp_entry_to_pte(entry);
> +		if (pte_swp_soft_dirty(oldpte))
> +			newpte = pte_swp_mksoft_dirty(newpte);
> +	} else if (softleaf_is_device_private_write(entry)) {
> +		/*
> +		 * We do not preserve soft-dirtiness. See
> +		 * copy_nonpresent_pte() for explanation.
> +		 */
> +		entry = make_readable_device_private_entry(
> +					swp_offset(entry));

Same here.

> +		newpte = swp_entry_to_pte(entry);
> +		if (pte_swp_uffd_wp(oldpte))
> +			newpte = pte_swp_mkuffd_wp(newpte);
> +	} else if (softleaf_is_marker(entry)) {
> +		/*

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

