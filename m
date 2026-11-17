Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B266E606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=geZMmNkz
Received: by kanga.kvack.org (Postfix)
	id D3C966B05B0; Tue, 17 Nov 2026 16:15:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6DC6B05B2; Tue, 17 Nov 2026 16:15:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F566B05B3; Tue, 17 Nov 2026 16:15:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA586B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:15:20 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCBBCA05DD
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:15:19 +0000 (UTC)
X-FDA: 85445866758.25.1C2F716
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id ED270140017
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:15:17 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=geZMmNkz;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edLdvJ5BDjaRt6RMx5EffH6A7el1uRIb0sy/VvsQYKw=;
	b=m/HIdHJwylrW190lHYcpbM14Ljhtfq9SC7mZDVJn4KuWzIsdtgscsHE8UNRDtjxxLhfSYJ
	P9hbdxEXFaFlcpK6+uW0ZHIVhSGwar5LVyYyfa2cnxQytVIGczSr7t7cvdoJB5WInxAbC3
	wDC2szx8LHlCt+3UzpR79lPQmHk8fvk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950118;
	b=W9LUNfO/dMRBWIDP+zKo+2N23SrUXp1auNyhcG4N2P4U1lzIFBliDpKBhoy6OVR+dxTr7r
	FuBzAHgq7ZZ7K4Gvxt6bqpCqvUPov4oeJcKa4V09k/CVP8SBPceiCkyxvsJmb9CqXuhqD6
	9fgyO05SVrc/AhOrFfwcne3EgHwTtIQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=geZMmNkz;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A376860DB5;
	Tue, 17 Nov 2026 21:15:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C561F000C4;
	Tue, 17 Nov 2026 21:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950116;
	bh=edLdvJ5BDjaRt6RMx5EffH6A7el1uRIb0sy/VvsQYKw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=geZMmNkzgGVXwgzgiftX/pDbrM45HqLo9V6rUnvZM3za/H5jbhPJ1hU97R8l6LZFi
	 XdCH61sbo+xgVx67ujUxGFhSOYBdxAfog3e3UpezVvy4x6O/T51qI5AUUVhiZTpS61
	 RiolJYAKQ5g05U7taZS0nOKhsJ5oKHdrIKkDdZ92jTgqT0OHXf6otza9Q+ENu8fS7/
	 z4ihSUCv2nfgxEqJuD6+ABu6gv3EYJSYgDNGxgvMr5zxDQ1EA5Jqklzkbg4Qle1oyZ
	 tCWownKAnEfgdQP2+y+lnYdbk+2/VHP3qlNQ21cEQrdP6wGo0eOMNWBv2TbMNhCud/
	 6ildXgxaLx/qg==
Message-ID: <5fc2f2aa-a6d9-42b5-a839-48ddaad60498@kernel.org>
Date: Tue, 17 Nov 2026 22:15:08 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: check exclusivity of the page being moved
To: nakixii <nakixii@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, Lokesh Gidra
 <lokeshgidra@google.com>, Kairui Song <kasong@tencent.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20261117191853.1314834-1-nakixii@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261117191853.1314834-1-nakixii@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mohxwypaz51a1e16pki6y7supg44nu7y
X-Rspam-User: 
X-Rspamd-Queue-Id: ED270140017
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794950117-933074
X-HE-Meta: U2FsdGVkX19maj0+y9WtPu/t6o27zCwPZbMroUSFxeObC1RnK6g5+TTRVr8Lk1U0qmW7+Ijg712NQFoPyQAMmQjpwSfEA8i9oYmWOBn5fbEMNJevoXSr38TWsjuwnMqxvakjXOihqbVcLWzquRW3Ug/I9X72lGtla7eL+vLuZzTwgEDcoUUs+Mx4pCoiUwT7TnuVykEkNVl7I8c4VzyI1XWLlTyRBSRG5VvQNkZeLgK5smXs22S6hNR+LgpBUgsERkbZWhAbMC4ZJ+AU+BXO/QaHrmDsO1aQiETKVciAL+zf+VvYjOGfVJtDKW3EmtQ3wl1Zi0YbhQ6z0eecpbVARnmcYscLqj2sx6ZeJHz7pM66YKpCUvEqCJcxdR6W1OsieAKNmVdHVg7qHI2YL5dGZ5eW7iwSriH6R2zWJsF5pQUrlEaLSa0wvfft/Ncq7IygWAvoZOex+Rn/MDY4Ahpk0SkaSsnDrw2suVyCEWAFIM3pjx1DNQT0EqYq6FE38nQ4Cnsah7+86fW4lhNYRfYtZfZmR9FtdWVnDGNXVHjNix0NB26c+6uqvFjqRN8pmn6oqimqLAsgZK6r06zUG9pjoBRGp4ivM7Lrk83X/3Rji/rxOqbRxb13LjP7KPg/DOpGmJLRlUNdqZEcF8rvsPVJyEN6LTwLBLQwmCelKk26iX6HveVD3KSs6etImAmm7J7fKJvcuRA2KjISdzNnnU3vKcBmehLEG5m+a0pmDLs+iIqzBx6VVHc0Ue0Th6ShN/c2bx5mnHyZ+vXOovc5dDGfj6LVs4fNLENF7j2IhbmnaD0HCMbhiAIZ1RnuIJE5XqcZKXyoSYZD4Emzwm0U6rQ637T9KtPbhoNZJPh+CKa2pIMuAXpxBGa3nFW78854SmpBXGvaGUAKE6hI2kn31K/zv9vtzaG2odS+2J9k22SO44uMJGeO7IrpUtE8xDAkUExXtB6A7+XcmfdIzRv57zK
 NezWhOXx
 QmUCvsoswlFDNNrnbFtkm5jvEXRL3u37Tr9hx9YI0EVPpCMvf0qMu6PDFPvTlLJ8eDiHkX7oT7tEscwI+G2C5aX2C7GEREFc/NsbpmvNtuYjGY8oebd9U+JhlNMO7b6dgW4cJAZeVa425xZRXEfnex5b6Ey5LQWDFZtB7Vo8aqulGSLk9bppwnnQROljlN5lW+U+mlVFtDYolmjdcVQH8W5KpnkRNqBA9RScKbuCbPiB8Hy8IKNTEzMK6AzQlfOP7VryA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/17/26 20:18, nakixii wrote:
> move_pages_ptes() gets the folio of a present source PTE and then checks
> PageAnonExclusive() on the first page of that folio.  PG_anon_exclusive
> is per page, so for a PTE-mapped large folio this can give the wrong
> answer for the page that is actually being moved.
> 
> This happens after fork().  fork() clears the flag on every page of the
> folio.  Once the child exits, a write fault in the parent can reuse the
> large folio, and do_wp_page() sets the flag again only on the faulting
> page.  Reclaim can leave the same state behind when try_to_unmap()
> replaces the earlier pages with swap entries and then fails on a later
> one.
> 
> Moving that page with UFFDIO_MOVE then fails with -EBUSY, even though
> the folio could be split and the page moved.  Callers that fall back to
> UFFDIO_COPY on -EBUSY end up copying instead.

Ah, I was about to say, nothing bad will happen because we reject to move large
folios.

So this is pretty harmless and pretty uncommon to hit.

> @@ -1570,8 +1571,14 @@ static long move_pages_ptes(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd
>  				goto out;
>  			}
>  
> -			folio = vm_normal_folio(src_vma, src_addr, orig_src_pte);
> -			if (!folio || !PageAnonExclusive(&folio->page)) {
> +			/*
> +			 * PG_anon_exclusive is per page. The first page of a
> +			 * large folio can be shared while the page mapped here
> +			 * is still exclusive, so check the page being moved.
> +			 */
> +			page = vm_normal_page(src_vma, src_addr, orig_src_pte);
> +			folio = page ? page_folio(page) : NULL;
> +			if (!folio || !PageAnonExclusive(page)) {

Yeah, we could have also moved it after the split and test for an early
folio_likely_mapped_shared() first, but doesn't really matter.

-- 
Cheers,

David

