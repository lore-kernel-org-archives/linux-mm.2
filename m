Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD365606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 02:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=w8ubrdgQ
Received: by kanga.kvack.org (Postfix)
	id CC81E6B05B1; Sat, 31 Oct 2026 22:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA0786B05B2; Sat, 31 Oct 2026 22:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDCF06B05B3; Sat, 31 Oct 2026 22:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9743F6B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 22:41:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 335FD1A025A
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:41:02 +0000 (UTC)
X-FDA: 85384997964.11.56186AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6964A140002
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:41:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w8ubrdgQ;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793500860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vtgNBTDMW/DtrGtv/8hkAbq35pBY5cFFg+9Km6ShdQ4=;
	b=EP/M75f0dYxXd8bZjEzBwl/HhxBrF3f1clcmB2/XrSYkgYXiWfIxqRSVtNoZs5ptvbj29x
	MXRD5xE76fZyRMU9CrraVBg9mZT+keI2mKNH7NCbjD1AqEtnXlbbVeC4W8I8FKlTKw9Oh6
	n/y8JYfDVqyLVufXajHCzjnC3duyq/8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=w8ubrdgQ;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793500860;
	b=3aXtlRFLunUk3M4NmBjUwf49aMgS6nGP96jdFdN4XlTfHnjXbBEuQOeWm4p8oo25ZyZZ2d
	HyNUVlp30eQqczBnOD8PdV/2/jiTp3PI7u3mQKtDek8ENp49vzTtPhJkVbOBd21D+vW4Nz
	OxJQ+Pvi48VlURo4LcViPDQOBLemxNc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2184C6060E;
	Sun,  1 Nov 2026 02:40:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810C41F0093A;
	Sun,  1 Nov 2026 02:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793500858;
	bh=vtgNBTDMW/DtrGtv/8hkAbq35pBY5cFFg+9Km6ShdQ4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=w8ubrdgQ1H/88s1oR8DPOKefcURK6dl+7lDkz06LB+py/vNtwV5SmJt623XeYDEPG
	 MmQJmYnC4dazZopFbfUqdgOKXd1qQ5jzZTsIGyf5XJsbvppfZbm0CCL6SFvmZzHExJ
	 h2qnSkEyYWst05ejBOP+EHuEFy/ccuXV1qGDpCnI=
Date: Sat, 31 Oct 2026 19:40:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Andy
 Lutomirski <luto@amacapital.net>, Chris Mason <mason@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/gup: check folio->mapping under folio lock in
 memfd_pin_folios()
Message-Id: <20261031194058.d3bd25ed950e5340ab595f07@linux-foundation.org>
In-Reply-To: <20261031203540.2282507-1-skhawaja@google.com>
References: <20261031203540.2282507-1-skhawaja@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6964A140002
X-Stat-Signature: pmhcgpqz1zg7ca1j9gjqynzqw5aqrbpz
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793500860-424806
X-HE-Meta: U2FsdGVkX1+1bmfxGKyD/zLHp17UbAhP/P/on+iuNsBHRi3/YtlTpmoAF1+Dbx0mfvAYDQxnuZp6OcofeosxRMaNoWyxUrI/+RP3o5lx3Q/8U+0ikt7hC18l7vONW6ko+0whTnknG3BYV1icd9KF0FWBqP386mtxyt726YJtY/1f1nwbDAtEin6m7xL0AY6c8iPIBKpCEr+G92npMB3QADElAK7fUxp4UgLq3VsTb5e9XGnAAC0cEDilGhXPvxeKMJkwEcVdZClujHaTrTrBW9DegQoBj5dPPAAYASZjBnBQ6xwheUfWadLS0DQ6WYQ7JKS6obNqHL/UoJitVgmeOGsCYB6zpDGkdK9BclzGU9/fesb4lK6zDoIh5L08j1086J2UxkLPO+5nPnC+E1shj7ecnx9GpBokng/ajnDIn/96m7se0/TnYVPxulzFMaznB0CZ3NXUiXjPwpv49QbOVUzkmbdXpSQS17nEV399TY9e+V/fXfYn5bgxTxzjR4SCB3fyuBXMcqJWyUvX11nW7iGyIev4TKcWxwd15Ay1rBkZUBA8aC8iF80pTr6Aq67G3q1pCL3hSMKfF4MCMVJ7cwyhdl/IYfMaZuduqssbfyVrvfAzt6xiRJm0nYHyIIrjCZdqdW2kJ+Gs8GoeObIXEH6o9riaFydDEJT1c+yewJeUpmJ6Puhna/RKAzoloIkRwnN09jykpxDjnqMz5G105Dy6qGvUQEXixwS0T7HD92ca8eBFggn94KPlLuR+iIJX2FYL32bR1Q1fWl2BYZD8RDP6ws041V2HyyUSqSve7yZzBMR8/DAOs++/1wUv+jr8++MycZS5KrCA+Z/PKmGFwRexB7kaIR57YlqgXGxZB6GcLO1gs7mRFH7WEo63Y1EMoRs7sp1KsKHKAL8ckil1xdafbasM50lt9KFOp/stIrMxdnbCB59+lyIl6IlJ+YBs3Fj6HSoPE12wN3aEIcH
 QDHeu5Kh
 ZcrO+gvMKOkX7UfAKUv4CiLcStdtGUawnZy/JNAA2Ub/jasqabbxn4vfhLK57MCDkFCSgtI8xMm4kM+4rOD1hldmxUTYYBmFHbcjqk2J9RoOGZOEjkQBggIjkKx8oFcqSxY5xrFqY1i5qclIoZWwwxf4BuBqwo1Qz2PPzfn16YKkOXl/Hm/2yGh+FGxirawIs/RkAfXy3Bx3AGSQznEiAWPec+UH6CmJVKF26cgoNIX0XN225J4+TsZKRAUfzoDUow2asvB+e20axvJZDl1hdEza7wG0tBsYj5XRhSb5wgTWdHNBN6ORICU1na36p/CmMZM+j9nfpdnex6n3O3USae1rIuk9XfRaMQl+E70plvGtGYshqdrD2Qdnf5/PkUCD1skMeXtaOECYEBKLoLgB/iYiiGecCJVb4vgzraxFyKOGcM7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 31 Oct 2026 20:35:40 +0000 Samiullah Khawaja <skhawaja@google.com> wrote:

> memfd_pin_folios() pins folios from the page cache without taking the
> folio lock. So khugepaged or MADV_COLLAPSE can replace the folio after
> its refcount check while memfd_pin_folios() still pins the old folio,
> and the caller ends up with a folio that is no longer part of the memfd.
> 
> Lock the folio and recheck folio->mapping before pinning it, like other
> page cache users do. If the folio was removed, retry the folio lookup
> from the index that was removed.

Can we please include a clear description of the userspace-visible
runtime effects of the bug?

> Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
> Reported-by: Andy Lutomirski <luto@amacapital.net>
> Closes: https://lore.kernel.org/all/CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com/

Includes the words

> The issue is live update doesn't preserve those background punched
> folios and now we have created an UAF attack on the kernel across
> kexec if you don't do something about it.

Is that the extent of it, or are there other effects?



