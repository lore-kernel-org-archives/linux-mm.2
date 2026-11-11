Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A28BB606A89C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hm4pFGCX
Received: by kanga.kvack.org (Postfix)
	id C54116B05B8; Wed, 11 Nov 2026 17:50:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDCBD6B05BC; Wed, 11 Nov 2026 17:50:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACC9C6B05C0; Wed, 11 Nov 2026 17:50:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB1C6B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:50:33 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BA9A12045C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:50:33 +0000 (UTC)
X-FDA: 85424333946.30.2CE0788
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7464280004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:50:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hm4pFGCX;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437431;
	b=ALH9DH0bLZm6XZtzBTYVmxQFoaMkCv4ZEa8pWOFcy2JVyvJs7IpWqzH2bp5tDKCrnLKj6i
	ZAOPcMKgMbpUliasAa3iXW2zEqyHwetdVPt5tKlOc2Ydh3hoaKzkD9QZoS0SGbrfc/74lm
	f0GyJqhSj/k/mX2CXkkF/KMW3ROghCw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hm4pFGCX;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437431;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kfXyyQS2v6aQUXecH3totLDpvH395mCAcr9qXC/QbHo=;
	b=EFHAnF9Qb1qz6ah9UNKtEFPzPJBbXB4B4TrHsG3Tb1/D/w0/eGiDl2r74XBf1nlHjEAPDo
	T6G+yueahPTa6hodxnBuZJFCO6Dqgad31RapevN2Xny/kBYk4+xuN886Jv3wv1DYzsIp3P
	GGoBbHA9b3YZT3ldDeco32gUBpLrurQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4561433A9;
	Wed, 11 Nov 2026 22:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D4B1F00A05;
	Wed, 11 Nov 2026 22:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794437430;
	bh=kfXyyQS2v6aQUXecH3totLDpvH395mCAcr9qXC/QbHo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Hm4pFGCXRzM30xTXcMo0zXaCABZCRr03xxipFsXu5NFZve5kKuUEDkk+4E7NdZ00D
	 01ISDfwLn7lmOuJbry7MyOrcI1Z0zsockDUwv3qmLs6sWN1Hw6xRFBHHVYoZaGfx89
	 GJs6PKPfAivqFFdXqMBIYyZq6lEcEYZ45PQz6XPx6pw7FtCgxKoQyZzQKE9r1M/ljh
	 i7eQKd0DY4GARGIO9Lu6uDgcNjyaRnwUlpWDxqkQE6xPruScLclR7lieVX8KlRoYLf
	 LT89Kd+URM22cyxpnvzlX//+yP4t83xMuYpZArl91wQFaCHXsfZK4xUPAaZwQsRYXT
	 EBEnfS+EWXz/A==
Message-ID: <sashiko-outbox-209831@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/4] mm: add vmf_insert_pfn_order() and
 vmf_pfn_order_ok() helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eliav Farber" <farbere@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Greg
 Kroah-Hartman" <gregkh@linuxfoundation.org>
Cc: "David Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org
In-Reply-To: <20261111113045.35368-3-farbere@amazon.com>
References: <20261111113045.35368-1-farbere@amazon.com>
 <20261111113045.35368-3-farbere@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 11 Nov 2026 22:50:29 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7464280004
X-Stat-Signature: tkdkjxmo8ii4eo3k5tuajyees8hsmj8a
X-Rspam-User: 
X-HE-Tag: 1794437431-70868
X-HE-Meta: U2FsdGVkX18Vq5wHYFNoEiFlrvvKvQCTNhFaSj++FvXvB9nOmHddy6pJwRoqti02KByO7HifACvp/t4U8yYwIbZIHU/RcxjfEWhJ9vrkPkKIMgEUadZ6OBunu/wRfJztfRMEOlikCEcefHEzeJ66XsdYwM1o2jfjsGFGtusKUZhVw8Q3H/O0fxXnB0Wp8z/QM1RZVJ3UI6MKofLjhUBUzYWg+FPiZUc+LNibuIkZjbdZ5IUI1wU3PA2Yac6YNEAtp540B56eEgWXTs8fe1coz1qYkNQYuGJ8ZwWqfjLlhNzjVSYe3g6ONI2Nbl4ka4LiFmQZiji0fcGUKhG8PrN1gb4lso78GvLJWsaVWBaFuMEgRkoe95t7iFwNzuQORziooXbaca8Oipl31vMXMX3eAFzTeKUdDPSxt4Y7nOOanq+xoHaBE5QDsDW7FbtqosjcKrs6UUK+T4bVclxcTL49E2JHAaRnHWRROLgEt76UWB/yAFLSsMkcPeh03MUg+2qhwdDyVSVRpO3Jp6eJpbnA1Cy4SfiZpVaJosRLMAYGjai4+bGhh/xs0X2rHwhnQwexzeeP2mXXemlRL1l988xmWy3qirwvsAueWa5EflrRqik94gm1lTXm9IGDYo6I9HUkKrxwRiLkHeSCTDIa9mg6KD4Y5Mv+mvzPKTx8z+efmGHn3w2A0Y7XCW+Ssp2o87Yo+7i1IIpgAYg9P8efuNcrZF4Zs35pdbikTy4l+j3BH7oNZrEoZh5MJaGUMGSyPp3afe4kQ6CWCIxFsPg1jIZK6FVcPP2C5yL2aeHsY6kyVA1rXptwGv/Xu59E1uw3kwWbm3Jv2pmeGxhVIOepD5EaKMLdb2rT/ddnrrfBS6EktDgyosTYD9RMY8kMhi1zBNKYie/eXPhxhr6zthO91JWp4LHUsRFeSm14irwNg5WRA209lcAmWYe2xApL4dBCbJ83L5RHgNhFvxzup1QQa+5
 67Ycqj9L
 SPo+B+PcjyHibHon9n4Jbo1LSAXG7TIZl40ThEMlyRHMOmtY0YRi6Xzjn2pnDJTpHsAAuM3ZhLCR+rr0ncEn0SemJVtBC2HJhWEJCynKjG4Fw8tLEm7Fa2i5Kc88gE7aIa7hU5sAiDFwdyvIMcVhqXQLnClsYWWTFG1+/Sz8XiynVzyiUQb2nsZUCI0Z6m9JMpEms7IUzaVjPvWU+kNwSX7anv14qrARnJR+TLg2qgcBVkVNrYu/4L2EWPeIcA7BHN9MXnkzPFzpxuvSv2LkSLm80QdQuT5pBynUa5cHYLAEo/dTHRfmwl89R5BweMaxTpvyU+B0CNRjo+0AwMy0uv347K5hXsMH0YR5BW7Szoze2kaN5kWlhAPyPxP2L6fZPf8iSlG2i+hchWibqZ17ThwJNf3823SpMoxrI35BWdcAHDg7biGEsxeK8pksECciWz4I4W9BBHBNAAnMQeJ5BdD0rZb6xZ/ikSRBd0AcKJoD/ReprTrxtSFPOabTTMwJA6wOTgX/7XTZjqvLhX1azb50/k+zVl5KETwm8j8IHmBG1x8/GTzYUQYqkzNLNZyPslcfFKWNUxFhGOye0Z18LLs6o8sjCyum0wWgLLxE+q5MCbPqwnS2e1Zwk0nqDqX/s3sKVGIoUwaE6rNY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [Critical] mm: missing cross-granularity zeropage checks in
  vmf_insert_pfn_prot() [1]
--

commit 4d09867f23905da16cf7a825dd8a13e152a14d1e
Author: Eliav Farber <farbere@amazon.com>

mm: add vmf_insert_pfn_order() and vmf_pfn_order_ok() helpers

This commit introduces vmf_pfn_order_ok() and vmf_insert_pfn_order() to
validate fault windows and PFN alignment and to dispatch PFN insertions
across PTE, PMD, and PUD orders for VM_PFNMAP fault handlers.

> diff --git a/mm/memory.c b/mm/memory.c
> index ab29ec719ae11..0c583442e0493 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3002,6 +3002,55 @@ vm_fault_t vmf_insert_pfn(struct vm_area_struct *v=
ma, unsigned long addr,
>  }
>  EXPORT_SYMBOL(vmf_insert_pfn);
> =20
> +/**
> + * vmf_insert_pfn_order - insert a pfn mapping of a given fault order
> + * @vmf: The fault being handled.
> + * @pfn: The pfn to map at the start of the order-aligned fault window.
> + * @order: The fault order (0 for a single page).
> + *
> + * Helper for ->fault and ->huge_fault handlers of VM_PFNMAP mappings: m=
aps @pfn
> + * with a PTE for order 0, or with a PMD/PUD for PMD_ORDER/PUD_ORDER whe=
re the
> + * architecture supports huge PFN mappings. The caller must have checked=
 the
> + * window and the pfn alignment with vmf_pfn_order_ok().
> + *
> + * vma cannot be a COW mapping.
> + *
> + * Return: vm_fault_t value; %VM_FAULT_FALLBACK if @order cannot be mapp=
ed, so
> + * that the fault is retried at a smaller order.
> + */
> +vm_fault_t vmf_insert_pfn_order(struct vm_fault *vmf, unsigned long pfn,
> +				unsigned int order)
> +{
> +	struct vm_area_struct *vma =3D vmf->vma;
> +	bool write =3D vmf->flags & FAULT_FLAG_WRITE;
> +
> +	if (!order)
> +		return vmf_insert_pfn(vma, vmf->address, pfn);
> +
> +	/*
> +	 * vmf_insert_pfn_pmd() refuses the huge zero folio's pfn with SIGBUS,
> +	 * while a PTE mapping of it is fine, so fall back to a smaller order.
> +	 */
> +	if (is_huge_zero_pfn(pfn))
> +		return VM_FAULT_FALLBACK;

[Severity: Critical]
This problem wasn't introduced by this patch, but can falling back to
order-0 here or dispatching to vmf_insert_pfn_pmd() and
vmf_insert_pfn_pud() below bypass zeropage checks across granularities
[1]?

Because is_huge_zero_pfn() and is_zero_pfn() match mutually exclusive PFNs,
when a huge zeropage PFN falls back to vmf_insert_pfn() ->
vmf_insert_pfn_prot() (or reaches vm_mixed_ok()), it only checks
is_zero_pfn(pfn), allowing the shared huge zeropage to be mapped writable
via PTEs and corrupted system-wide.  Conversely, vmf_insert_pfn_pmd() and
vmf_insert_pfn_pud() do not check is_zero_pfn(pfn) (and
vmf_insert_pfn_pud() does not check is_huge_zero_pfn(pfn) either), so
mapping the order-0 shared zeropage at PMD or PUD granularity exposes the
surrounding physical memory within that PMD/PUD range to userspace.

[1] https://sashiko.dev/#/bug/linux-c77c75ca-4c72-4dae-8d19-e971631bb97c

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111113045.3536=
8-1-farbere@amazon.com?part=3D2

