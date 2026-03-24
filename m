Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36537E9A77D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:31:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74E676B0088; Tue, 24 Mar 2026 08:31:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7262F6B0089; Tue, 24 Mar 2026 08:31:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63C496B008A; Tue, 24 Mar 2026 08:31:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 535386B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:31:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 23E9C1A03A5
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:31:34 +0000 (UTC)
X-FDA: 84580892508.19.39F59E4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 57018160010
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:31:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pURdOYrn;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774355492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7idUr+b1WBbA0HUKmjW47Cfa6aEhUoZ35UXoDy/6W7Y=;
	b=htapnllRlEuEFhaMyWl7zwNa4ZooZUaNbQUcA6RRdNPiENSBMLW/2H7eeVKjvXi7AScV1w
	oCrpXtmqTTPLaucavID1PECTe0NS9Wp/qbjMNeJ1A2HA/qtRHoBSJGuh0J7rDXQXhjNfxQ
	fbTZSFmP98O429h7w0IpMGyPb2PmdG4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774355492; a=rsa-sha256;
	cv=none;
	b=K5c8YGrTgk63XJiXogICwxK92ik+DCJokND5FcNgiSyCUFvQtPAF9q8pCYc2i+rGudW6Xz
	fB+AkBCadfINOJO3x8mV5Pk2yEeheLqYb+HqV4ksva8B+7mZI9TNw8XiX5cj5UYZFcSTDn
	YkXQjMCT+fDlZERMKKyrGgD3RvI0NR8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pURdOYrn;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A012060138;
	Tue, 24 Mar 2026 12:31:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30058C19424;
	Tue, 24 Mar 2026 12:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774355491;
	bh=0UugVX49ItAoLZWtYssfWcTOq6Q4dm+M9rixoERrF+A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pURdOYrn+MNRB5U8AyK/HuZB5Aw2nY+uZdTpGfmdWOmlC0HiS0Ujn1tVQ6drbApON
	 aW8wfpLPjh1yRD44ifCKG/X47q3RQ+of0cifN3HJ+uMbOZQaXdJ7cSjy4ASBZfC8H0
	 01/ee0mJpB0dJhkoFsiJDwjrS+2WsEtxOxUPzIfjgiN7vbgvA5Iv95N/dhtPS8IqS3
	 Y2+gx/q8y9h1xBBbd0I5cyICBf4ywbMnGHIik7u1tJO3TJKs86zBBUPs11qxZE2k9b
	 Uz3XaOC1IdjdTs/ob0kuJ/QZN+ue7hMOUU2gmRB1UP9xvISzSdHSc0zLf04wy2CaRi
	 LNT1QhhHLH1lQ==
Message-ID: <d5a1a533-cb79-428e-9119-a701a07ff4f7@kernel.org>
Date: Tue, 24 Mar 2026 13:31:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/migrate: rename PAGE_ migration flags to FOLIO_
To: Shivank Garg <shivankg@amd.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: willy@infradead.org, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260324114720.864478-2-shivankg@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260324114720.864478-2-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: a546ttuknnmzfotw6sw5wfwam1ebm15q
X-Rspamd-Queue-Id: 57018160010
X-Rspam-User: 
X-HE-Tag: 1774355492-709830
X-HE-Meta: U2FsdGVkX1/sG3qHz4dn4l+zQsnR46hIbolN2dk87o80BMdBYnajtQQkqZ8znG+yixqyOzj8rYq722iGtueMKmdKmWZlLVCAzhVDVyki1r5VjeCFUq+Kfo29kPJ1IbkndctSj5gxQlFq3CsaCYvi2CuGJUTjeFUwOUkZbcP0I7l5MQ4ntw2LjVGB/pE2/s68liiRTiD2UTTMARAPUGy+0EO4Ue1nkCBQG25a60o0qYM3U5jz/pAfEufM1v4u/i9y7mvtoGNqV8+eeeL3J+HPUGR64XNfTGxw5rBVBxOMldooFBLR8fwYHoyxPvz913k0aaZ4lBOvSKTdnqhnBJdbIHsCSZdgQV4IZtKKtjgAw4C7sDdhk7xgmmTOiy1fb4e6itDDv4Wb+p8zPSfjnSBEyG3zQJacKQzYc1VMYwfOvtCXu0KODMiTQu9pzD6cu1opZeDkYVHCi5+8jKZfa9JchOaUCwnNtu5I8wYspVTaYbiZnq14UQYSKK+g2XB2FkMwOk0L2u9keH2u5l9bihPcXXCSWbVeUubukMgFuVt5DTz9g5ElLOOhNYukqiM/u24OlyZX5CCnrPWzJCWZ2wUebkf4VjhCB/6vLCTWbqnQOvzcUfuscTvGn4xS4LDs8XHmH/6AM8HPYYesz34NFA2BV4NgHR+UcfDxgxg8YjMk3hS2Gfl6vlSIwifT2hweHwcHK1pM3BAbWK0x2OMNmyiaOLW5399jWLaQ8sLe7Tm5jguF585kjRFJawUCFe2uU/SjFLCE2UnT1GZqCU/F9Rr2KMcz0LzOD5EXEwhP6Pik1x5FyvCFCS92F2W5kT10FA8adB58ORxXn/F2Dj8sqmYLJYMKzUm4x0Cy4OQgAhlSYVmWz8g4VZFHVg4Db1HUifdlYU9cpFlKDFWbK5XZo3c5F2NcibRy7lcdlfrUmF8KB1r6gw1SJFMRz5HipliwaFEuqGrqkJvXz2XcjAJkdOk
 W6f29nIo
 OjrZ4bmigpgGtUoN8xtMFlt+iEN2X7ZgeQzT6PGl55OAToyrs7Yax7dqX7I9yC7XSEIjjZ9zlYCIA9DQImR5I3bRaRIU1FZGbteIPdmUPj1d3KD46aEERqqxVS2mRpW6OVOkcREHdp6nMi0cMDN8VSh2bg+G1oufMMDC+/+mjTkW8E9Xovi7Ns3yo/EdoTkpMNo+WFOJv0XAEw/FCi8Dj3VP9OAy6hCh17G8FBF/LOlJFUPh2VwUP05EJ1GncAtLj1ojEB5YjcVuO7OlTUujDxX+aqKX18MHVRJMdTBIeQEOyo+ngVseAQBi/0ejT77uDCKxFwda5LsOzTy/RA6+7XwAmghJEwHpx6eg4utfB0q/rUfkSkMy3CWFkc27zDvwTTTnU+uFFy8/4BBTu4AeR/2dEDnFwvW8yjD3iKZQ9QQRGP7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 12:47, Shivank Garg wrote:
> These flags only track folio-specific state during migration and are
> not used for movable_ops pages. Rename the enum values and the
> old_page_state variable to match.
> 
> No functional change.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
> 
> Applies cleanly on mm-new (02b045682c74).
> 
> v1: https://lore.kernel.org/all/20260323141935.389232-3-shivankg@amd.com
> 
> v2:
> - Rename FOLIO_MF_* to FOLIO_*, per feedback from Willy.
> 
>  mm/migrate.c | 46 +++++++++++++++++++++++-----------------------
>  1 file changed, 23 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 05cb408846f2..7dd6c2f2e1ef 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1135,26 +1135,26 @@ static int move_to_new_folio(struct folio *dst, struct folio *src,
>   * This is safe because nobody is using it except us.
>   */
>  enum {
> -	PAGE_WAS_MAPPED = BIT(0),
> -	PAGE_WAS_MLOCKED = BIT(1),
> -	PAGE_OLD_STATES = PAGE_WAS_MAPPED | PAGE_WAS_MLOCKED,
> +	FOLIO_WAS_MAPPED = BIT(0),
> +	FOLIO_WAS_MLOCKED = BIT(1),
> +	FOLIO_OLD_STATES = FOLIO_WAS_MAPPED | FOLIO_WAS_MLOCKED,
>  };
>  
>  static void __migrate_folio_record(struct folio *dst,
> -				   int old_page_state,
> +				   int old_folio_state,
>  				   struct anon_vma *anon_vma)
>  {

While at it, you could just use two tabs to indent the second parameter
line.



> -	dst->private = (void *)anon_vma + old_page_state;
> +	dst->private = (void *)anon_vma + old_folio_state;
>  }
>  
>  static void __migrate_folio_extract(struct folio *dst,
> -				   int *old_page_state,
> +				   int *old_folio_state,
>  				   struct anon_vma **anon_vmap)
>  {

Same here.


Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

