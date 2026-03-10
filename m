Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C577EB1049
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 10:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CCF66B0089; Tue, 10 Mar 2026 06:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97AC76B008A; Tue, 10 Mar 2026 06:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85C1A6B008C; Tue, 10 Mar 2026 06:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 748186B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:50:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18EA95979C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:50:19 +0000 (UTC)
X-FDA: 84529834158.11.B71FBB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3ECCB1C0014
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 10:50:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mz8OWw/n";
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773139817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NZox/n4HQ2A7cVBgFZF/hCEQkkbjmtd5KsYHa30OBgM=;
	b=3+bYrRmHcGsTSesk16u/M22LgomZorLo9znYf36wKgplph/iV8gzMdr+MZ4Rs6YYh21bxr
	m9whyVOpi+Oa0xfxoO6RFKCVYqiVb+lXfklB1MZ5yz91AX6TK2twzob2dtjiTyHwDd7zpq
	CiBI/00IN89gTkKHNoY6xE/Bzyrl4kw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Mz8OWw/n";
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773139817; a=rsa-sha256;
	cv=none;
	b=Z0wB1Wc+xYS2nTy8rG0wnOotAlmuMEpoIk7TaYcQs4YpWJuXjL/mbgla5qO/Zt7VzT/izK
	u8GF66yJabgwEU+sKvrI2bX0sND4qiErrKcf0ubzmC+JM74vZBOyZFDGE5MrN5PFiyv2Ry
	6pge7zbOAqvfFwzxrhtHwoZgzBR5Y+U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16564429F8;
	Tue, 10 Mar 2026 10:50:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDB5AC19423;
	Tue, 10 Mar 2026 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773139816;
	bh=lv/Ndv2cGNSU8aZpViy8aWp8+gArFm7Nl+ywKCt1J2w=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=Mz8OWw/nAP45YmbN1qfVWB3MpD98Hq/VK4sTreUz7bDKtUvA6dRpWW/XE73U4ugEG
	 HhK4RLYI4/BTv0PJfPT90p+fYzsFN01N89hUx7C94T9HjSoaosuONwyCThwlQtoYJQ
	 Wrg01OKBiiEMs3wpPqXT2AaQBxJNENgHYrypN/aMO+uyGPgOXNmnaUF3ijVO5wqqVb
	 89W5niv3FFHxKAfnIe8mubdmZSPDym/rdkgsKua1F4DFVyv9hwxIvfeeLSuPKZRS/8
	 9O8mqN/poUxM/G3DmidqbMQj8phGfEZ50QXVjxgHCRGO3PYM5dnyFadj/po+kEVEZs
	 I+EFrtjnwVVJg==
Message-ID: <a7d5ed43-2ab4-4338-87f0-7a50af463018@kernel.org>
Date: Tue, 10 Mar 2026 11:50:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: vbabka@kernel.org
Subject: Re: [PATCH] mm/debug: optimize once judgment with clang
Content-Language: en-US
To: Xie Yuanbin <qq570070308@gmail.com>, rppt@kernel.org,
 david.laight.linux@gmail.com, akpm@linux-foundation.org, david@kernel.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, surenb@google.com, mhocko@suse.com,
 nathan@kernel.org, nick.desaulniers+lkml@gmail.com, morbo@google.com,
 justinstitt@google.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev
References: <20260309153405.20130-1-qq570070308@gmail.com>
In-Reply-To: <20260309153405.20130-1-qq570070308@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xr8h4bu98sgouuu9exumiawp3rxzsbtj
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 3ECCB1C0014
X-HE-Tag: 1773139817-911710
X-HE-Meta: U2FsdGVkX1/79olLfsiukIHIVpWZc0AROX1XyubMLU7ZDzZ140W39O/saQ3T+BVr37822dYGnBLsTDyTvFJjQGo/h3SevXW8A0f2CV3YQ0Fz5r4iDuT5gsqjeK8TtQlnQVKHvHD/2sGZE00LrwMRZLKtDKu1s5oPEFsYrPjgR01ltA3SBzkJKwUGFF7YzM22OQmx5/pdeVy5hE3v2zOVqgcEax762yJ6iPSPQZw624zVnbW+RgqISx1SbEn5JBks0Y3jqAuQZYl1skFdc2r2UsqKnr9n9YPV5fheVhyxLnBBvzyFq4Sx2u7AfP7hijyevynZ9sYaQgT8LKY6bfFiwKTP8CHYXFwWY/8gmQsVwz7le1Qh1QNxkcfD1XhImRfW91wgEm0Ye9zZ+pflNo6B6cmwlEoXQb2tVf0cWlaKHYYbiv/YvMDERDJjpSbHxDS4vI+HqxZr8TVbEzDI5JvNsVjmoIebg9E844Y5BzDwct7gkSYcNXvsaPtoKiDnPD5Ql5b58xRmImmTKtmSk5wXlug66dDwqiUvoOKDdMMcogtbevgxuZF4Sd8c6x8bHhjhFoU/+mtmy11hJkkJV30PQQWXfTSQFsgQ8Qm/pAVmmQSX2VhRF0tOF26K/KjGTf/9gxYzVzuMYBLcn/A6+z9FYn8Z5c457YpO3cpj7JtxP3Mgi+xDloLot5sEy2u72H3U0IuqJ+f1Af/zQoClYRk2dssUGQXTOf5JJMxP4JUS2tYMkkPE7hZ3048pOmEPsAuSUB4qocgLHD2LJ0RYiW5zYWD2LC/1K1Gn5DreI9ceAltaFK8xbSqHx8hCYcNfR4EcL10Vf5Qr1XOjR2kYyAQ7k6g82juFnaqaK3ysLRbTf5o9NgfUEORK0my5lvCV6Tm3thZByttFFMP07tzLQcLH+ha+1pYEbU1mlQLgtzDCTt4lV46NnTb0fjmHfYwsNku1eMWYG1Rj/PRF2mom67y
 TEilvrWe
 BQJ14qpRvxAYphCKMnIvOz4WUuJKnS+GyjbskbeZx7nJBnsdtUu4PfjKRzx7x8lJycwjjZJ9m/ddI3QPqduT3TrVk+e4G8TK4gkNdtkDC9N83LP3Rk3vriyByzZnPxdDReWOvez8N1sHQcVvQKMTGT50WKWvY8wlhd64qIlz3S54u0mdinPrqGtYDBkvNxvFslMfEeU3TAPws1HXRDYTSWkjKdHeXLzQClGIYkrpe9Yo5+1Bgtx+xiW+iJmVKf7mK9/FZ5JorFyeFrkxkDqamMIaPSrPXpqHTYzy2RMp7B57nRHgB4iZxYlmYPZ1zS9mTkA+mZkZ5pvalkmQWxewPX20DOP9Y6pKqSO2ODnNuTUXgge8IyrLe0Us73o6AqjgIjOL0JMluPHIGBACmwisrzF7EOfepxoOlPb1TRAA/HaV0Bnu8/wklvZ64Cg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/9/26 16:34, Xie Yuanbin wrote:
> commit 242b872239f6a7deacbc ("include/linux/once_lite.h: fix judgment in
> WARN_ONCE with clang") helps optimize performance and size under the
> clang compiler, but the modification is not complete.
> 
> Port the modification to VM_WARN_ON_ONCE_PAGE(), VM_WARN_ON_ONCE_FOLIO(),
> VM_WARN_ON_ONCE_MM() and VM_WARN_ON_ONCE_VMA().
> 
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: David Laight <david.laight.linux@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Xie Yuanbin <qq570070308@gmail.com>

We don't need to make debug code (hence perf doesn't matter there) more ugly
just for clang's sake, I think.

> ---
>  include/linux/mmdebug.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
> index ab60ffba08f5..a167c5aa525e 100644
> --- a/include/linux/mmdebug.h
> +++ b/include/linux/mmdebug.h
> @@ -60,7 +60,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>  	static bool __section(".data..once") __warned;			\
>  	int __ret_warn_once = !!(cond);					\
>  									\
> -	if (unlikely(__ret_warn_once && !__warned)) {			\
> +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
>  		dump_page(page, "VM_WARN_ON_ONCE_PAGE(" __stringify(cond)")");\
>  		__warned = true;					\
>  		WARN_ON(1);						\
> @@ -80,7 +80,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>  	static bool __section(".data..once") __warned;			\
>  	int __ret_warn_once = !!(cond);					\
>  									\
> -	if (unlikely(__ret_warn_once && !__warned)) {			\
> +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
>  		dump_page(&folio->page, "VM_WARN_ON_ONCE_FOLIO(" __stringify(cond)")");\
>  		__warned = true;					\
>  		WARN_ON(1);						\
> @@ -91,7 +91,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>  	static bool __section(".data..once") __warned;			\
>  	int __ret_warn_once = !!(cond);					\
>  									\
> -	if (unlikely(__ret_warn_once && !__warned)) {			\
> +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
>  		dump_mm(mm);						\
>  		__warned = true;					\
>  		WARN_ON(1);						\
> @@ -102,7 +102,7 @@ void vma_iter_dump_tree(const struct vma_iterator *vmi);
>  	static bool __section(".data..once") __warned;			\
>  	int __ret_warn_once = !!(cond);					\
>  									\
> -	if (unlikely(__ret_warn_once && !__warned)) {			\
> +	if (unlikely(__ret_warn_once) && unlikely(!__warned)) {		\
>  		dump_vma(vma);						\
>  		__warned = true;					\
>  		WARN_ON(1);						\


