Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B2C6C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCF6D6B016D; Thu,  2 Jul 2026 21:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52AB6B016E; Thu,  2 Jul 2026 21:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1B1C6B0170; Thu,  2 Jul 2026 21:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 651A46B016D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:01:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7A01A1A017A
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:35:09 +0000 (UTC)
X-FDA: 84944235138.11.9D0C496
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id ADF7BC0009
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:35:07 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=claYiCGD;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783006507;
	b=K/eDLqpMg7L3iA3Yf7mG9phRcJpT6lsreNX+5EXZpZDP1iGBWHGkSrQoMAhceq+Qa+k+kz
	M3n7RGsVhn0317X8/GvXnIHU8AjmKO+SOqtB5v7JGkwsVjd+ZFX/pqnQD5sm3kwM16yzQf
	LvsO3MUB7rFtuZmN2khrxpR+0afNjOs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783006507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jWa1mD+awYvcVqO7NB5NDH/ijt/TFGs11SlmfzyMrnY=;
	b=NVPufLm1kC7NV3VBTKUdsk8uZDSL6rWVlRYFl5nODI7xP5H+ml6rCHRNuuDmBZEHCb49NF
	E0a4JltSEoJo7A6ML46NIL5QCrS4umEF2rO6j62A7OXi0k6DdPv7gBSAlBmgyxqdrNy/Ch
	MmRcSqcguuN9e3vr6S3Lw+K3v0PS0O4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=claYiCGD;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C600F4356A;
	Thu,  2 Jul 2026 15:35:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ABFF1F000E9;
	Thu,  2 Jul 2026 15:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783006506;
	bh=jWa1mD+awYvcVqO7NB5NDH/ijt/TFGs11SlmfzyMrnY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=claYiCGD9+iGsb3rEHrI1s5HJg2hkS7W6gL8omu35jx7x6oqejSN3G4l7/5wm7Oj8
	 +qeUOcSoyvFJPDTJquyp36FHneu5xD9PqAyLHKJcQ+P3eTzJg10elubGWbYbJr+tvk
	 gEE7trLBICmQyG4GF4bSPPqOoz8r1KexO9NQFWpt3u0Qf8T4/i/JJfkd3SpHnFKz99
	 RX6qVFtcgpOs+c+omD5H0aJsah5hYR2/8Ml0K83F+CITI6tNy81EbWhYtG4d4EAkVL
	 yNTim2+Lm0L3zEKKV5p6v+OojCOKZ+TZsWnkiFcAAN0kVhGppFbuEVQCf5lkvEZkm2
	 Ixf8nfTRbGYxw==
Message-ID: <38a23f8c-56c4-43a2-a3ed-bf7d4f784cda@kernel.org>
Date: Thu, 2 Jul 2026 17:34:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/6] mm/rmap: use huge_ptep_get() in
 try_to_migrate_one()
To: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, j-nomura@ce.jp.nec.com,
 nao.horiguchi@gmail.com, ak@linux.intel.com, mel@csn.ul.ie,
 pfalcato@suse.de, jpoimboe@kernel.org, dave.hansen@intel.com,
 tglx@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260702051341.126509-1-dev.jain@arm.com>
 <20260702051341.126509-4-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260702051341.126509-4-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: ADF7BC0009
X-Stat-Signature: q8ofcuyc8oh5bcapn1g7kkh8kg6pfzw5
X-HE-Tag: 1783006507-247984
X-HE-Meta: U2FsdGVkX19F6BXMUAhYNrI+qrFPEV0o7MMmv25tzVJbiU2oIpIwRPe//zGor57BR2o53DBdu42hYOsI5lN/LeU9TwocOatIcaATZ8PH520EAErL/ED2hpECb6LzVQy7ddSPZjEZ/1PisplExHeRpXwOQvm6wKtwhxx1SoWWUk5M6rOE8osH6qLDA/MAejx9xL/eCDSaEj6SIx3HNwKdTHITHhMpJd6mtGY9fz5dI2IBMB2orKYLa76q9Q8OZkkfOxqJ4sv4KbCdb8rqvxvUlGmICaSxphIbybRyHqVAsB3oSkD4xAeZyN5+DwD2W8UPtjn9Jyr3wQ6OIR+rLU18gbqQyX4KnyuqN0AZjwxwbvz/+tYxwsjwVoVg+6wU6g4pOze/l6d+HxTPpZyiR2GdgM0pZQetcuv5iSi3QZFY7LgXD48B5GBWn1AR7ony/h5vaTLFxEuRdatPrSLyLXup6SQ5TnPiPdrMCadA4rcTOKwsJ9M281bUnMZ8YAVuI/Lsy0jAXeRoU2oyKsbCS260PY1Jj/BnuZf3sumbJfa0vvbd8OxCv4AgOozve8jNRRaJxNe72oix/yDq4005yrcdWUJ/ztUZG9oPulkrtZGf5XmDvMqUlJvhXsqmR/MIA20TcNja9UxrIQqhWUAzmHnlkd5jLSpdPhdTysDCJTogsZDYnLz/NDOX4kBCqo/QJxU/G5X46PFmazvuAPPBusqXeMERdZCnCZu2iqfUYEtoAyxhzcDWs+JMgHUe3SWCx8PeEEgSWsbhOY6+ZuF/i8J6skjthQP5Mct0FA5r9jWbwURS2gOZKRUlolF13Q2yJ48W+so8Z5E48xzB7hoKBKu7aSH3cONn+tfyZbk0EavoBZ053JBDV34X+oPX+JN19zDm85RmcU0h+NgC6jmX3ptiOvxKihvv30gGwI1vBqy8nDcxhRfx1RgxyMdH6IZOPVJ7owIG/n908OsyuHYQll/
 N/8Chm6D
 AD7LlEK1gC0GDMVzoXfGNyJTzeVTOI30hHxxnvmefJsBdSTIlXtyvFM4uc4q9TAWRnI0Ut9BgWRTGZzCMHsj/AB4nyC0trHMWQk1nQ8NdoIyepRd89X3WRYOtqKNnPy9+Un899sF3iEvL05jYdWryf6dgpqnXiotSw6nFxn/tbn9Ra3tACVviJjA87Beg7YCqtaPUBJFDHihtWMOfqIAuakyV52tBuhZbIcRrcDFM7N6Htb6WUr7GWCpNljV+GxV+cwG0dGBB3SSUmBCFJXViaqzVaL/VgA9YzXxOvFrr+sCStm+EUMVL3zbCxaEbvj3GcENfqnWbeSCUMOTsPJBSCQ6JIetKB2xbFU2C7rAzxIyez6AiBKUS/um6UXlNfWS7Glcq33jD7SDBxBjLeByLD6ruN9dvtXeOPP7ebJOhPU1qISTWNQtbiccT7RhX1YTMTMH4ylDqVqTezZ/VrEunczq0fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 07:13, Dev Jain wrote:
> try_to_migrate_one() is used by folio migration to replace a present
> mapping with a migration entry. For hugetlb folios, page_vma_mapped_walk()
> returns the pte pointer to the hugetlb folio in pvmw.pte, but the code
> reads the huge pte entry with ptep_get().
> 
> On arches which provide their own huge_ptep_get() to dereference a huge
> pte pointer, accessing via ptep_get() would cause pte_pfn(), pte_present()
> etc to misbehave.
> 
> It is not clear whether this has a trivially visible effect to userspace.
> 
> Use huge_ptep_get() to dereference a huge pte pointer.
> 
> Commit a98a2f0c8ce1 copied the bug from try_to_unmap_one into
> try_to_migrate_one.
> 
> Fixes: a98a2f0c8ce1 ("mm/rmap: split migration into its own function")
> Cc: stable@vger.kernel.org
> Acked-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index aa8a254efaecc..abc3a44baaa3d 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2505,11 +2505,16 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>  		/* Unexpected PMD-mapped THP? */
>  		VM_BUG_ON_FOLIO(!pvmw.pte, folio);
>  
> -		/*
> -		 * Handle PFN swap PTEs, such as device-exclusive ones, that
> -		 * actually map pages.
> -		 */
> -		pteval = ptep_get(pvmw.pte);
> +		address = pvmw.address;
> +		if (folio_test_hugetlb(folio)) {
> +			pteval = huge_ptep_get(mm, address, pvmw.pte);
> +		} else {
> +			/*
> +			 * Handle PFN swap PTEs, such as device-exclusive ones,
> +			 * that actually map pages.
> +			 */

Again, the comment is related to the pte_present() handling, so best to move it
down there.

Apart from that LGTM.

-- 
Cheers,

David

