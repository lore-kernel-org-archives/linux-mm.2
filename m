Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AB90D35163
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 09:44:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BBD96B0088; Wed,  1 Apr 2026 05:44:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06D6D6B0089; Wed,  1 Apr 2026 05:44:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E036B008A; Wed,  1 Apr 2026 05:44:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D7E326B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 05:44:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AA11C6A6F
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:44:35 +0000 (UTC)
X-FDA: 84609502110.05.53802A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B1A1CC0008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:44:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U37bawTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775036673; a=rsa-sha256;
	cv=none;
	b=oqcX5EZ+13E4UPzJwoIW809y98+17AwUTtFeNDtS0FLBBlqWAxL8R5se1ITQBAAEAyyaxM
	IJ0Nb8kU1+iUSd3ezCb27lSHaUVKl2s5m3V15LqynBOOBN1XEJFjVPKgnKpTa+0hvIg+lX
	nFzMwYYkQEDJQOybDABLdv7h+NIgffs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U37bawTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775036673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZMeKOnjsZyISkZoqauvndmNHypIwSE2pD+KQ/Fr5MO8=;
	b=Eo0QGXvyq1xXqBbNIOyCuENc7cozl7AfuSC8aw4I9ZXclZKoDDXV4m4cqT5dACYnuBWKVT
	n2XPYxKmN2q64SGAIwQm1wOvnNYilDCEi6CeHd/OfKSx+qxND/IULlwH4kkMGzzC9ed+VW
	QzkJg6op2FOg6yB3kVALLI+unmRu1Wk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BDAF600C4;
	Wed,  1 Apr 2026 09:44:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A4FC4CEF7;
	Wed,  1 Apr 2026 09:44:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775036672;
	bh=2oOw8zs3xzGzoF5YHSLqg3ICLDD+b5wmvRMAkOMujWQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U37bawTX8UJU2iy9qXdm6B9yw7N6+y8LKL2hpL/2a4wRUqRCCff7JpdXiBT6ZGDi3
	 fKcELR9dEua8h5+ndQSAVcAK0AjTAfqNxmsMs/+bag8AvPg1gFoX5NsPsR0iVFJ2Se
	 IgJcdtji09oWqQ5EVQQKpRYLkBQoj4yLK+udxeQLf2hZW5Bu/Gx6uNdjpBhc0OuvwQ
	 XQ5asT7Bv9eqLrzo+zee2wfKW8Jj7koruuSe9X+oPbXCM8Ghabee49lhDw2rey05+Y
	 FAzX9Re1KvMMbZygqHSNLEgVg2VFPI1Ln1gaawgTf0o75xgLtazaplF+YIO7odWJiG
	 q4IdO76V8w38A==
Message-ID: <f470801c-65db-4bf9-99ed-6e0599fc4b59@kernel.org>
Date: Wed, 1 Apr 2026 11:44:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate: fix stale partially_mapped arg to
 deferred_split_folio()
To: Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com
Cc: usama.arif@linux.dev, richard.weiyang@gmail.com, sj@kernel.org,
 hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
References: <20260401084116.22219-1-kartikey406@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401084116.22219-1-kartikey406@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ohehkhbmk4uk5tnohg436taxc493dx3e
X-Rspamd-Queue-Id: B1A1CC0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775036673-684502
X-HE-Meta: U2FsdGVkX19xJ2cRQI0gW/b27fm4UySGIRoMI7APVvjhy91TnfJTo5p2hxmqokWVAoFj+y4t42D7Lli7duMcOyhoYxAPkRIpKZfNwlJ/07FPqYNzAj1RgpzLZY9FQ+TNYZku4+GqzXN8E2XadJ07aNBQAqVtJ1dmucckHcQwSPfwA3dC3kVatdcQjIYQT33qjCYr8kPzNh0XEGgHXuTtigMVT27teaAKl8H0dgvF8sFOUG5kWFowBsCzIZcTqncbob7RVGK6PeHbigqWOt3rP1KTIVS61XeBPM1e6mtCvVqtnEOCXVWIhJHOsym/KooEMr61S79Gw/J/h1u/3FZJDqOYWn3LC3kuN6D6k0lbs9Ipm7nKoXHgACtHr/OKMyl1n5eGjbXLxQva1GY3nF1KLXjO8Y351iiGg33f/DlUx1hJ4wOWDHoNtArGnAGuPm/YAyaUfgNhSVrce1beKKJBhQlRICE+7qGj7VtbNZ0GYwr0l0B2gEoH8R5NhjFv8w1PdiC7pDNvKek457P0pKBt0x33CgTkMpT5plTRpQ7fn0NY4UdLAEmh02rDglbgiVdzqQw2VXmNU5hlsx1HZC+1sJEnzWpbxMDcT5EDAz5VDfg0A5dHeVZW64pclQ3COfx8PrcDBwIChEqHv4E6eNi3hmz7Iu2EU2WBqbxjNpOyorWACtpg3t+R55QMlnXlYYq8Z0cciNjmNNZRrzJ+lssjwsCobDrt4c32XUDyKxecyL7eTvumM7VC2yjPpR7TpKyet45TnhV/Ix4bzgDwZ4GDXtYpJ/ejUCJWA9dJHlkk7nn5ts2KngsYdQvYzhtmTZvwq0YXRt32p3ofOAM6iCcNvLIxbFcoWAkhtO8EMxJ9CZ4eK2M4s+VPQX36gfzQkpW8F6qJgVD57RX1PP2SrVrU88O6dGDE869mG7Hg6rmXCZaVNCz1HfQNuBq4uiWhlq0ZSR+30vgbzac0n70Q2ch
 SyaFCr2H
 PHuVDx+mk12beopACz3F79BWzsZlNWZuZ6TdxYRxTt+Cfj8IoYJG7sOIwIeAyCcI0QJrgIB9roLUUTI//IUSNqBqy78O2nUDULomKHWG34Nn5kDJpcnriIGIEpozB00pPUEDjtP22aBFZIDOkaF++Jsqhww4YE2tEkf+dk3eUzfwGhE8cR2sCntn1yzz9/inYUObtm24pDcA5SyX0vdapBkoS1JqacoNAX+2MW3uFDcCdZiss0+d5P6nuluhnfq06XJlBTECX8ulV93VwcTxcckyH31c4jWZycdmAP+6UvTDnLnVSF4H9n7wkuoK9SXiAYWxadyWDVE1um4zJpZ39PESpJCd7nBw5Za7TtbM+w3/E2AI7t+AlMEMGADMfOrXN4Jr2/9oQ5NxFECePaulELKod75DqhS63NE8qTDH6HvZQVgucrU/6yQw/xl6WI9gLNWw03VxItka1Ddu6GcRu3QsUD1/5eDnXqe3dyfqN29pVRXdhg8vkvTUM+qYyYL9ThyqkWp1NUgpdcPcgDZk6RhzjIO9D6nDify2/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 10:41, Deepanshu Kartikey wrote:
> In migrate_folio_move(), src_partially_mapped is sampled from the source
> folio before move_to_new_folio() is called:
> 
>   if (folio_order(src) > 1 &&
>       !data_race(list_empty(&src->_deferred_list))) {
>           src_deferred_split = true;
>           src_partially_mapped = folio_test_partially_mapped(src);
>   }
> 
> A concurrent thread can unmap pages from the source folio between this
> read and the actual migration, making the sampled value stale.

Indeed. We could see "partially_mapped" getting set concurrently.

> 
> After move_to_new_folio() succeeds, __folio_migrate_mapping() has already
> copied all folio flags including PG_partially_mapped from src to dst.
> Passing the stale src_partially_mapped=false to deferred_split_folio(dst)
> while dst already has PG_partially_mapped=true triggers the invariant
> check in deferred_split_folio():
> 
>   VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio)
> 
> at mm/huge_memory.c:4371, because the argument contradicts the flag
> already set on the folio.
> 
> Fix this by removing the src_partially_mapped variable entirely and
> reading PG_partially_mapped directly from dst after move_to_new_folio()
> completes, where it is authoritative and race-free.
> 
> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a7067a757858ac8eb085
> Tested-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
>  mm/migrate.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 05cb408846f2..11236779e910 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1361,7 +1361,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  	int old_page_state = 0;
>  	struct anon_vma *anon_vma = NULL;
>  	bool src_deferred_split = false;
> -	bool src_partially_mapped = false;
>  	struct list_head *prev;
>  
>  	__migrate_folio_extract(dst, &old_page_state, &anon_vma);
> @@ -1378,7 +1377,6 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  	if (folio_order(src) > 1 &&
>  	    !data_race(list_empty(&src->_deferred_list))) {
>  		src_deferred_split = true;
> -		src_partially_mapped = folio_test_partially_mapped(src);
>  	}
>  
>  	rc = move_to_new_folio(dst, src, mode);
> @@ -1404,11 +1402,13 @@ static int migrate_folio_move(free_folio_t put_new_folio, unsigned long private,
>  	/*
>  	 * Requeue the destination folio on the deferred split queue if
>  	 * the source was on the queue.  The source is unqueued in
> -	 * __folio_migrate_mapping(), so we recorded the state from
> -	 * before move_to_new_folio().
> +	 * __folio_migrate_mapping(). Read PG_partially_mapped directly from
> +	 * dst: move_to_new_folio() copies all flags from src to dst, so dst
> +	 * now holds the correct authoritative state.

Where are we copying PG_partially_mapped exactly?

I don't see that happening in folio_migrate_flags().


Also, I wonder what happens if the folio gets partially mapped after
already installing migration entries (zapping migration entries).

This is all extremely shaky.

-- 
Cheers,

David

