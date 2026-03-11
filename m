Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A7E01125809
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 13:33:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8272C6B0005; Wed, 11 Mar 2026 09:33:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CD866B0092; Wed, 11 Mar 2026 09:33:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BA76B0093; Wed, 11 Mar 2026 09:33:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42C9D6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:33:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D180EC0D9D
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:33:30 +0000 (UTC)
X-FDA: 84533874180.07.6A1100A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1528D120013
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:33:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FR5L/D52";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773236009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWBJPqyyuU6SdbbYMfzlqkb/MLOJcA/Osxca9ozNfBI=;
	b=y+7C0XEOBxuLyTHHBXKeImiXJQvZMSneUbGfmGBsrUSQzJCA+/Df/7On+9uDcNJlENUdbM
	oi/46TfzzE24AnsF0VMsr1zJ4RHovTudGcdVn6D3HeQfg2DwzCMxxWE9UJafUHfoSb4yX/
	iba9X+qw4B5uwTCYjj6zBviCKPJI6h8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FR5L/D52";
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773236009; a=rsa-sha256;
	cv=none;
	b=0D/iA7lWS7hgj3kXib07LkfF/6Rtl/RWdakIEnqeYGgrElDow/qj2gS+TqhrouRMfubcM8
	bOQ6+un4jO7W8p3+2kknHzgyMpPtuDBTojb6gk0KxG3w/cB+8VtNez0/lq/QtXxnxF8BdK
	9gSwC+76Ox5e35ZeZIx/r7x5Ph1YRF4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 76DC26012A;
	Wed, 11 Mar 2026 13:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55B99C4CEF7;
	Wed, 11 Mar 2026 13:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773236008;
	bh=srh1iZ5GFxplA+TY470q6OCG9qDd2My8dIyd8PO1UQQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FR5L/D52LKB9zHzj8bFmrpj8prjrN+ZOoqIUYJ1ckK9mkcsmdzuGWsEb39U58Hwkm
	 R4kBShD1Docgxseg4ptMOSQwGwW5kgq8jjIbElR2tiJPDZaFIxZ/lj26c22jto7zLY
	 8UlsmyZazPQAuRvhtoR5NlJ6DmO6B/sXgdwZ8ldNMyRjuN9X2IdVaVth0Elf9pgqJf
	 OYQSjyV1V0dqEsmnldjsvXHEVBCEgC0RlRcbAcx4aaReAb2bCWlhuSBLozzW3MF77C
	 KHEvrSICTm0HdOtMjI4E1GzVOZ4lIuALRwuB7hVb+wh0fSPpnrQXY+wHNHDwmQsYu1
	 Wz/WSl+rrB63w==
Message-ID: <46edc7f1-f97e-4ff3-bf11-a56feb8e33b4@kernel.org>
Date: Wed, 11 Mar 2026 14:33:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: migrate: transfer large_rmappable flag in
 folio_migrate_flags()
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, willy@infradead.org, linux-mm@kvack.org
Cc: matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com,
 linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260311132342.3193160-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260311132342.3193160-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1528D120013
X-Stat-Signature: ja3oi5b1oswdy374njbgeyhqoude3gmr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773236008-298849
X-HE-Meta: U2FsdGVkX1/jrXs2p4kBCV3lTifVTSQOu5t7TUqkoPBcuewGI+QoM//9uO/sGDQIn9CNx6hZ0i5fmcYFMujk7BEfLaZhNCKUiLmGYmcF4z7yuJRZYtFQxDsGx82x7YrzZfoE4QBs66BMGByAne+HsoVjhHiQD02aFKQfFW50d4HTlh2tGf4JulJg0P/8Kr2nqO8Yhm9DLjcowdZVsvfN4Z/scpyMIxr9TcEACIEgaRwhUCCd5pSwwP9lWpJ6NkWJtQb4fqwL0Dgt4Itie0xanb6TVkI3ReUA4HPj0zwWFBhuYQJ1MSpqrZO7UMIzxe426O9vqCrC4jZGTOuXcS0Nb03s8Eqs2pe1EvUKzYj/wyAeFuQlcPu7MQDT8qkH39h3yXrEAkzpPnp+/VaMnQdApx8JoayThySw0fAy6L9bkQM5ROTUXvvw0rXhiZXrFtcvtD7NC7Zo+vh+4f5n4qiA21yKdj8pmrBtGgoaGfNdSyWg7/XOlCD+9zaOFRKrOqxpgXIjqE5jF8ufJmX82L3up5osLab9FEiCTUzJGXtiae+Dg+xbRRmAHJcfN2NWmBtLmGkpq4D9anUBBGC25Kd53LkV/atBSHKO4T0ZUQCVTJwATlyvteYbA2MWqJGu0WD8XdvmmRV3j2zinmYPq2SlaxQFVzREPoOe+UWW3+dmrr846qs5sfeBzGXo4UUAeALRYH8m3sOcOyQg0wpB5p5hhpFZ9AfSiVU1SghEoq07462c3aKrKnt2JftjUL9vTb5i21KsaDCAadPGnM50lAGhqqWscDzSxBvlzvGHACQO6UDAhRitlOMv483QqsNC75WU4WO5UZOJvv77YnUnLlUKfAJfj9Bo/YqpiRDUGEMwQOeQ3sTsxbykLj1maOyhjVgDQx9SaBDJwlgPHMkAsibDHZeqMK2r244F4ymBq1WUTW6ZCgmdSbWz+NhHiNlwUKCyj1bRoR1nZFLp1WvIiWZ
 wcfb+1XB
 DNr9fwttjY3WwlG24BkawXVaxrR21qrLKIymhpMlOjNKWbDNqCHr/s/4TxnQQeBaXuFAlzhmF4yeePkmpi1hS3wcKwsF7RZC0lUDnf5oT2Avs1gPueiwCb163UNbOKZprhed62VEbQGxT9mq5W2eLC8ocDriGQtO7YteHraRCimtTLlINcn+I4JjVrvKNZ70rnqrOH617Ph6uTbdhLKyoKlwoQur9AQa7KBssGeOscjuvx6DhupNHfhc3G88c6mh+1RraoK74yphedg+3eIzvY3/4A+dK0MEWjqWAi/MJze1EoCJa1l/GCFOHnmvDq4lvlBrYEJJDz0MupkCQX6Z0RNSY5korrLTxjQzov6fFURXsmLOcUpdlWDPfFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 14:23, Usama Arif wrote:
> folio_migrate_flags() transfers folio state from source to destination
> during migration, but does not transfer the large_rmappable flag.
> 
> Migration allocators like alloc_migration_target() and
> alloc_misplaced_dst_folio() use __folio_alloc() directly without
> wrapping the result in page_rmappable_folio(), so the destination folio
> never gets large_rmappable set.
> 
> This becomes a problem when a folio on the deferred split queue is
> migrated: the destination folio can be added to the deferred split queue
> via deferred_split_folio() (which does not check large_rmappable), but
> when the folio is later freed, folio_unqueue_deferred_split() bails out
> early because large_rmappable is not set:
> 
>   if (folio_order(folio) <= 1 || !folio_test_large_rmappable(folio))
>       return false;
> 
> This leaves a stale entry on the deferred split queue, leading to
> use-after-free when the shrinker walks the list.
> 
> Fix this by transferring large_rmappable in folio_migrate_flags(),
> consistent with how all other folio flags are handled.
> 
> Fixes: dafff3f4c850 ("mm: split underused THPs")
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 3380021fd3db..ee1c7bc851dd 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -846,6 +846,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>  	folio_copy_owner(newfolio, folio);
>  	pgalloc_tag_swap(newfolio, folio);
>  
> +	if (folio_test_large_rmappable(folio))
> +		folio_set_large_rmappable(newfolio);
> +
>  	mem_cgroup_migrate(folio, newfolio);
>  }
>  EXPORT_SYMBOL(folio_migrate_flags);

compaction_alloc_noprof() does the page_rmappable_folio() at the end.

I'd assume that all migration allocation functions must take care of that.

It's a responsibility of the folio allocation code, not folio migration
code.


-- 
Cheers,

David

