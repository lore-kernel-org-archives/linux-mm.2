Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DF50C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8EF6B00B1; Tue, 21 Jul 2026 10:57:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 890EF6B00B9; Tue, 21 Jul 2026 10:57:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 783686B00BA; Tue, 21 Jul 2026 10:57:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 542736B00B1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:57:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DBF4D16019B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:57:20 +0000 (UTC)
X-FDA: 85013087040.25.BFFEA1B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 184781C0002
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:57:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WgSfBD18;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784645839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X2h5bpBFH+7npqK5spxeWS5f6StKH/bYQuKFvgmb620=;
	b=XzwvusZWrGw/OYi250xhhP5GXWWMRmcihLhDFUq31Z4tJ06CUO5qqvGI+TOyutXECdYx2O
	dwd7riy3Lb3uHbStYooOU3TDFXrB1eDh/vTP/9PMvknEcNzQdmikAOimUGDdMmmdp5/SRs
	JMEsA4CnorQp4KYnR8whpnJN4z3KigE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WgSfBD18;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784645839;
	b=EmmQgKxsYk/4wi/vNZPph/cLHL04yOqwS+jA9DRumJjglM3pGfLRplIWj4bMgmsDgC+YDj
	2Z/DHQmvgdj1sAHOKzubwQKb5D8T3allSfMmR1vH+C+hMUHj0KdiicZj76I5pTlk3TxUck
	Y3bHtaNUt8oEWOtJL2EiMWW6M1hn/EA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29BDA41E6F;
	Tue, 21 Jul 2026 14:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629C01F000E9;
	Tue, 21 Jul 2026 14:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784645838;
	bh=X2h5bpBFH+7npqK5spxeWS5f6StKH/bYQuKFvgmb620=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=WgSfBD18nsRmmrJbieRHbTVnpndeVh/tD76HjXec6RXFgapMArMcgsdjnj3ag9o+z
	 gRz5mmhtSTZHrmYy5ISeCHWFYOTq7G1IN/AumKXpJns+CtzdzduEIoHtuwoerwhrZ9
	 o+cHYXj3YXpuJr8AKYsSMPqZD19eTtjcpMp2+2Cc2bAb4BA8C0oZQBcuuIci3G3RQU
	 ifhNI6BDFoki0rZELq87NBJ4bnC/uCZ1USuEO623tHk4h8hxI+SQsbYiOmFvQARDUZ
	 nwmxkjaQnS2o0Ipn8VUe3e09evZb5SLADluS5GaT349oximkYtUuU/T1Q9kT98BPoX
	 VnzApXzpWL2iw==
Message-ID: <45118388-cf5e-4407-b2a2-ec67727cc4a4@kernel.org>
Date: Tue, 21 Jul 2026 16:57:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/22] mm: drop unused __mm_flags_set_mask_bits_word()
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>,
 x86@kernel.org, tboot-devel@lists.sourceforge.net,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-1-44be8a7685d7@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260714-remove_pgtable_cdtor-v1-1-44be8a7685d7@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 184781C0002
X-Stat-Signature: x447tgqqmjid14qhhjrs9imb57mz7xrf
X-HE-Tag: 1784645838-41530
X-HE-Meta: U2FsdGVkX1//AtiwkexqHandJkz9Otk7IC/Sa3FhIh3pr0nHLPmy4eUiz0leizu6/xhUGoZTqVal/26ZmrnHaY6K/9GddBZHdUw9JiSlBtnGECnUJK04YN5A8sc2ThKSQcBBtJBeEt8BRyxv2y+0W768qgaBG8s3XqMvPvzZnONNahzUtlb7Uyn6Xcohvol27eP6brJNrjeZJnmMBED/gBaBbBkyigAeisKQluYw4j9o6Gz1KD4Dm6AGl39FXWn0TBvHuTsh7A9SrHF/K7OusHznG0z8L81jwcR78OWLUc5Ws4zGfTAfaGYa4PUfSHE9O2XgzVIAVFZZbzI1tTXhfYnOjzcItUpc+nvHOT7BpdJNl1/KhqZh/Oc4bCNjgmEwBc3zkqPUWj9QcDpTuqvpvfMPaLFnedo4czDPnTKo2Pq/D5NSdw+kH3eCIIFRQ4cmAeof8fNNuO0e6/VAlFyehk+OG4Ake5o3mzkJ+M5DNkHOeld2zrMCNH+kweW0KZx9F5oyWPPvCq7skC0/nbbTnbIbeaPQkzZ2bXtG7VmY42XEMSu9QjkfUZ3FYWtUZ7Nu2uL/mmO8IPvu0RmYSrz+v5NWo67fAMyGbn0h7/b/hV8dBtInxcQBofx7gMgOdWwHbVDtyaO5Z4DeAesYa4lvZq3I/YcmaWplEf0rieqmauTRRKWUqX1IPtEXahL3J9dZLWSLXpTlfjNTL9GgaXHXwXfW4aQrrzEXa4C60zoYXr2ughdRjzMpHOiQ11gt12khi8e3oVnEKfmTeQ6C0P2+TCT/IE3fSR0IiQJqdgccAQkr8ZI9RYnbrz3f4/ITj8rLIe6hJjnYHP1lug72KKMbuq41HAf0bJ02EXID3q09eqgRskcgoeCDD5aRZuDesdZRcWQqyF42Yd7CGbl0uQ41+GFvHpB1ik6qRoE9Z3UYcsYwz434nZR/vVcluhirY6sPJ/QC16WVAcn5NIvNBeD
 YSLkVzLD
 +TqKKvEVJMBoQI9V2nZTBep8QpwDg+QoO9Sm7GZVWTfZpytIO0CtolvYY7n7eYRRzWjnGOXivUp9pTmn4+FRmuZV+JHkV1CMBOG1JXMkWXiyhaVNfQmKKf63lKQepwxi0VfYMcETNuTz6zwgtfg+fnPzeg5MieyZNx4Wrag++XfA1JHBVMpj3Y6kWTxRiTxdonY48pDndZvRIreJ+prK3y4RnDHDwltNPbAs1lATi9hUSaUF4dB0pNsryCCIQovxk1gG24g/vHkzMu9rEgYcN7p+b2R/jZx88kzvVIe2dOCUPePxdZ7AhxspHJqYd0qwphCOMEZxFHKDQ3mS4VCBo4JaO+zdJW6Rb2yXW2UhGOTDlTEZ2GuyWT3N3gEDOpoYt63H2YL4EhZlyvxV4IaM4ffbVAML2pdMep0yt+FBBXe/VJo0PlRM+uyqMmaqUl+NV0qMdCmQ2ebzlcie7gqThy3jE9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 16:03, Kevin Brodsky wrote:
> Commit 39f8049cd49f ("mm: update coredump logic to correctly
> use bitmap mm flags") added coredump-specific helpers for the
> remaining masked mm-flags update users.
> 
> That left __mm_flags_set_mask_bits_word() without any callers.
> This is a special-purpose helper that is unlikely to be useful for
> other purposes; best to remove it.
> 
> Assisted-by: Codex:GPT-5.5
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

