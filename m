Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A8CAC43327
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1595C6B00ED; Fri, 26 Jun 2026 12:11:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130DA6B00EE; Fri, 26 Jun 2026 12:11:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 047236B00EF; Fri, 26 Jun 2026 12:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE65A6B00ED
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:11:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34FE31C339C
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:11:09 +0000 (UTC)
X-FDA: 84922553058.10.E2A5816
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 53A74140013
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:11:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eBlvELcb;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782490267;
	b=u2+8MaxYqNLyXDe2Nzoo07IxH5qAZTCh5MDm9ig/QCqsR4R0HPLPa5hZ9/IfJJ2NHjpHqZ
	bFHZYE2fnoFI1IRzJQqAd9RFEYdtdHAHgvTkaj0S3xA3ZlPh3OcPsZ7gI3AfZx5/2Nu169
	MQNfh/TxqTOSJNMccxO8wBFudOd9dzU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782490267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJ8+hoO7D+7qgqudQMyfDfTAg2e5gJUXPK5mrA1wKl0=;
	b=5KuXsw8AsQ9ZYcd3v9xJ12i/FtMKFGwMaW56M6Lo2LPXrQZ9RdRiYBFtK00MuLqpapt+cH
	eBqlr2vQZPXVt4z6zZ4UyTf+koDDYRZhQBT9Ippt7F/gLbcMWmz8WiCKhIc3hHeHDJtpeH
	U/vtnq//q9tVhyzNEcq8+qOmeL57FKA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eBlvELcb;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6AC5740704;
	Fri, 26 Jun 2026 16:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2EF1F000E9;
	Fri, 26 Jun 2026 16:11:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782490266;
	bh=JJ8+hoO7D+7qgqudQMyfDfTAg2e5gJUXPK5mrA1wKl0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eBlvELcb1S8gvS56npK1n+m5rPWGrpFU8GDwH0REEGRGnyTu2CHTcJIypJjJqNRsD
	 W1g0C+aWhsl8de2/5PnDM6eFUirBU7DCu2oWW8FFOR5+spqArQntUKYAOOZ/9Or3sM
	 C5htzXYcXAfiT0QOhqbJdylAQ5MW4yGLsaGVkYJQpz8lhQUarSTRA5Qrlza3RmmfWw
	 bOCyoq+NkkU1ViT0kvAKZAPcgMRLTAxM/Vh385aW+mkMem+obUTBs4FCPJSTRAkoMs
	 2G/iZ1xvUTMV3am+5ar3gZKlTrGj7pYAoMs6vbqOe7lEt/u5hCkMjgRa0YdzU/mbWw
	 efQa6E1aO3rEw==
Message-ID: <53e834e9-2cb1-49c1-ab27-2d6b51d50fc0@kernel.org>
Date: Fri, 26 Jun 2026 18:10:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/migrate: rename page to folio leftovers
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Dev Jain <dev.jain@arm.com>
References: <20260626-migrate-cleanups-prep-v1-0-a95933af7619@amd.com>
 <20260626-migrate-cleanups-prep-v1-1-a95933af7619@amd.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260626-migrate-cleanups-prep-v1-1-a95933af7619@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: endbf4sh8ebnddtj3niy6ipmjh45k8yf
X-Rspamd-Queue-Id: 53A74140013
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782490267-52371
X-HE-Meta: U2FsdGVkX1/yv2+dGlvJYKSbNGYtMIzYyClBRBed8jYXHgNTlI+CbtgxTy2TBABTkAs1rnG3leD3RJi7rHi90zcDZed7REnvmG5NIEhnWiLSD6Ra6wvsPflUMFIhFl5MQGaIIjTI0XpfToAfgiZFsbg/nSWP1Y3TCbLyPcWmncWFURhAMHwzV4diZykQ7FIlejc4mn6J5/0PcuMlFc2EoQzwHUwJWRzqtK1rgqNKa/FimZo1KrmIvOYNH9hgmEM9gzNUQJLqe7OAuybGlT0/Bnqrt1FsLRbCIjs7AZ4QM0RKINeabLuIY+nI5zCkqZyirtbvdur7Whd9wzzjbjAMZzaiLx7z9t0GokIDEGeRPYSYIjo/ymNE+dzL23RfqdDV1cFaO5HJWN5rwDP2Qom6UnF3H/jcmc9foNxRakUmj9kUrGyoe3RDK0xtm5f7ergNYY5SpnpPtGmrG5wFaIRdXSUbJ+9i7BuAxvRUFx+h1PpjZ7UEDx/3QspA+5UfqemYEf1ouBeuJNAlfswxrkn4uo7N+7wshdp9K6cy7OrSjCnTgKKSaDcwkFIgWVKXKxPFXfqQ7hW/2p/EPjDiFCme85XrLDpxVVvjr+T3q5O70xbjb9B6IzyNT1odT9d49mq4ATQTNob7v+x30PoRyZtqa8xVwNdS9WUpKW0VWeRRs5xI/ZO4ZxrG2GBW4KmrVsgbk/DHHofKW5Ad1eh3hDa/bGLLmwpgyBX+pR4B8Bc1o+ZLAVMUIYWkTYHBpWXKQbIzjh0BPHD2VUZP8xLbC4X6xxwuSSnr6TcrmapIJO7DboMFLCdY6uWUAw6ONAsoYucPDZzoTBPCj7vFUwcMkS1ZlszmBp1hkrml3Byrqrl60S3o58GWCzUfX5h/Gh+d1SS0waagDYsYOE8p7ABWntFNl53BTkbhWyJ6AqWygxqPGO9x3Cr941x3/g91hE8X9ditDdvxuzMIKJB6Eqd34+S
 taU7K1Wm
 nKP14a2trfxKuk6VpF/oq+ViI8kzHd8V4EI948RJc9nBYZ/k8yx7WfDz1cMJ//7yINQlbXo7oXVqFNHaFkmWTW+H3cNVsdKe9HAm7rMfY8aQrzLRBU2tY5TE14ISnCJH3PMHiNUKH5XwKpdHNVT/lwsM7VCqEIURElUFY2qkLQ4v6nlCgUH6ZcVc2rozU/Xj5UX8au6975xvfwdCqlLT1th158oBebqd2S77Ni9KwHYzpMr+fP5mMAVjEatuUxAGjAaV7iKRy3w3cnZnRfTtX7n8Gwok+5MWqJcaro3gVae8mAOiDjKhf/fkWqha2RJh8t02ZP9sp2G5mck+5qN7gU/rB1hNIuKYCVjpvA6FYd/ao2lbmNOaV/6Cut1VQWbNbfva5k22vV2/ZTlV1h+mNfQokqP9KjEe96/liUaa9u8LIjqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/26/26 11:37, Shivank Garg wrote:
> Rename migrate_folio_undo_src()'s page_was_mapped parameter to
> folio_was_mapped, matching FOLIO_WAS_MAPPED naming.
> 
> Also fix migrate_folio() kerneldoc to say "folio" instead of "page".
> 
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/migrate.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index d9b23909d716..dd7dbd8d84a0 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -884,7 +884,7 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
>   * @mapping: The address_space containing the folio.
>   * @dst: The folio to migrate the data to.
>   * @src: The folio containing the current data.
> - * @mode: How to migrate the page.
> + * @mode: How to migrate the folio.
>   *
>   * Common logic to directly migrate a single LRU folio suitable for
>   * folios that do not have private data.
> @@ -1157,13 +1157,10 @@ static void __migrate_folio_extract(struct folio *dst,
>  }
>  
>  /* Restore the source folio to the original state upon failure */
> -static void migrate_folio_undo_src(struct folio *src,
> -				   int page_was_mapped,
> -				   struct anon_vma *anon_vma,
> -				   bool locked,
> -				   struct list_head *ret)
> +static void migrate_folio_undo_src(struct folio *src, int folio_was_mapped,
> +		struct anon_vma *anon_vma, bool locked, struct list_head *ret)
>  {
> -	if (page_was_mapped)
> +	if (folio_was_mapped)

Why not "was_mapped" given that folio is part of the function name?

(it's also not "folio_locked") :)

-- 
Cheers,

David

