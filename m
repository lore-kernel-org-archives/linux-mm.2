Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4604C54FDF
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 08:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4346B008A; Thu, 30 Jul 2026 04:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C37776B008C; Thu, 30 Jul 2026 04:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFF866B0092; Thu, 30 Jul 2026 04:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 958116B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 04:36:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 45BEDC08C9
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:36:46 +0000 (UTC)
X-FDA: 85044787212.26.DF66659
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 99A8A1A000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 08:36:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VQ99kRrI;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785400604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAoHoq3DgfZLRDw35Z4xYhIcQGEQD0G4Y9zF022oTws=;
	b=sHLUPc0G/NnJJ2owGZkOWOhgBFVyRMwLPQE1T5nvbY0CfbNHip+KfU+CwtAh49sCnDRdL8
	9vvxVITB55AWlZ1e4zEkqttFXm6CF6RYANX8oI771d0xGPm+efT5X2YwVLWwjjslh/l5is
	QrBT0fK9wRx1uQw8FGypaIx0Iw1O+Dc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785400604;
	b=EVlfRm7nUC91AYmPoDrz6SPCD34SkmUiDYhTgoY0Rw8UeBssnXD9d7wbKjuP+jxoBe6alD
	pFs/VLeK/hrDtJHMF57Bm+G6FDg5Tn+KGlpMLnAiw8ZSQ0nIaWzC9S/a6P0I9S0Mqj7Srq
	jfVhC55lMuhj5MvXQvJpvlvDottdsQo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VQ99kRrI;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7B3042339;
	Thu, 30 Jul 2026 08:36:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D199B1F000E9;
	Thu, 30 Jul 2026 08:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785400603;
	bh=SAoHoq3DgfZLRDw35Z4xYhIcQGEQD0G4Y9zF022oTws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=VQ99kRrIZv2Kvo2ELjHSiiuvEwpH+BCGYyNpROcwvGBoPbO0HXL3uivv/2oeraeFG
	 /T8xoZZszMKR2fec+pR8tHCZIoAp66ni6A1Xlgxo+zt9RbDNulUXk3De+cVY52c09p
	 QkPkSZEhmD2/3IvaY8WT/FkItFmSk7aDXJpBaj5LK4kb+BBnpnqVlAPmj5totAFJ0L
	 YPIHpmaDlN7nkVJ4PKnAqVbDdIHWMKexrvUkVlK1zmLYr96iadYAwnwfXEuVtDkSsg
	 /c4fZlMmmODrUQSoZmiqihBGmccxm9wmCJDMuWIIUleHRZbXB6YX5ptuvQK/Y1Mx04
	 LAUmzEpFye9cQ==
Date: Thu, 30 Jul 2026 09:36:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Avi Weiss <thnkslprpt@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Soheil Hassas Yeganeh <soheil@google.com>, Arjun Roy <arjunroy@google.com>, 
	Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: return -ENOMEM for page-table allocation failure in
 insert_pages()
Message-ID: <amsM9I3at8ZE4A77@lucifer>
References: <20260730071323.964321-1-thnkslprpt@gmail.com>
 <amr9zoSncZguF_uu@lucifer>
 <2a84e37c-407b-437c-a908-56526ce86322@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a84e37c-407b-437c-a908-56526ce86322@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 99A8A1A000B
X-Stat-Signature: itm1hf58rafyozmctbnuxw3787xdez3t
X-Rspam-User: 
X-HE-Tag: 1785400604-170942
X-HE-Meta: U2FsdGVkX19Ff+eIvJmnwuevH7ZTb7zK08x1cm9B2KiJI4CYupbTfGxeXCcDlxmhYH7XAfMd5+c3Bm9mql98DFtHtbb8IAhviHY18Hactyd+24z2+AdRrK6y5h7JnhU4hui4SOdIsxYQovMCRjyeuLFJyzGcXV4V+laduBiDEcaEZ+q3t/sjhOyZWMEA642tVBoWKECJgI7uT+B2PD+1FBy92rboH/wXHKvBCMPQNEkFS0hRai82r4cQ/isFDJuZiumbX082V/5oBmUiQL9XBIcn+wl4w4Txl1usJWCERJLc5zmGGQE7qZFB8EwlY03sikOznzAUoZSaZVrdbGp4o61wprenNgKnePkPDfajpwai5+U2dnID/E7noQRFZLhHhSs3pmmSDyT+exgWmei6t6uR3vNjYMSDfhOIewdfrc4YThxhJIdk3wk0H8Yi478jyqqBzjPn2YMENEoG6+aISWMFN+BaNRnS5FWy5nYSovSreBAcFEPXyQ86ETemmW8zb23HYInrmVDrb2mSj3OyjhdIiR3UPoykWTjrUr7Q4fOmiLyDNsXPtVMt9vu85bx1+5dDbciQJ2n0u6mCKGGXPPbmDojtwTEwfZooLQvpXAw7Gxz3X3qolNeQYFog8VfAzF0O3i8YxELcAynjnTF/NKxS0+VaTdbjKCnvdfNw2MsiddceMAk0/kQf2y74zzU5yN50KN9Sjxao4ZO8XF0vfcUR6ycmnkTpcwHWKVBzH0PtMlsM/I+fsh4JZeISFOmeTcAfetqv4DYWXTAX62z4ZNlSDzKvoQZxJk4QUVByds4otb5QEmORZ8ix4P/r5sfJdOcW7RfiECDAA4vS4YREraGOTH/T6JJfSG25tSRk/DgHdL6QGaIEcWlfzS8a4Z1tuSqaWMxRYJ5f4gJnxmz4dPjPAHq1ozKh3d8woECZON2XlQgKYgi4++4DCBsC56fFwap1SXjXxQaLx5A0+zx
 iTWprFQa
 AqMwWnbKKbg0nOOSb2/CDiOJ8bEOgbcqOR6KRau2Ieq/kcTN3Vhk8r8O2JehvFZso3me2m2QY8aNHvid6zeWBrebPo+G0BEdqCnJrSf4uXZpwhzbnIzdIMbO+hRz2wnibLaiSLgntc4qYs0Hj19/bx/k4527SwtixxmSrzFXWT27PckbHXezmh3Sv8qQ2HfafUnvYEQ59xS4ypGsHGUPAy6PsMgCUAg+Qq6hhtSbhAGIdO5L3Vq8M3lgbPB6LFFytZhtjDR6kcuQQ/uCJSeoT4blFjjpz/ZYv5BbpDArCAXbqsVA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:27:20AM +0200, David Hildenbrand (Arm) wrote:
> On 7/30/26 09:42, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Jul 30, 2026 at 10:13:23AM +0300, Avi Weiss wrote:
> >> walk_to_pmd() returns NULL only when p4d_alloc(), pud_alloc(), or
> >> pmd_alloc() fails. These are page-table allocation failures, but
> >> insert_pages() currently reports them as -EFAULT.
> >>
> >> Return -ENOMEM instead, consistent with the subsequent pte_alloc()
> >> failure and with the single-page insert_page() path, which reports
> >> failure of the same page-table allocation chain as -ENOMEM.
> >>
> >> Address and range validation failures in vm_insert_pages() continue to
> >> return -EFAULT. Keep the later -EFAULT return for
> >> pte_offset_map_lock(), which is not an allocation failure.
> >>
> >> Fixes: 8cd3984d81d5 ("mm/memory.c: add vm_insert_pages()")
> >
> > Hmm :)
> >
> > This isn't really a fix. Anybody relying on this returning -ENOMEM
> > vs. -EFAULT here is in a state of sin anyway (unless you can point to
> > specific users who are broken).
>
> Agreed, I am missing the problem here?

Seems just a cleanup, I gave Avi some ideas ;) this function could do with
it.

>
> --
> Cheers,
>
> David

Cheers, Lorenzo

