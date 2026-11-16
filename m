Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B29606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 14:53:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B/eyQH3z
Received: by kanga.kvack.org (Postfix)
	id 2624A6B05B4; Mon, 16 Nov 2026 09:53:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 212BD6B05B5; Mon, 16 Nov 2026 09:53:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12A006B05B6; Mon, 16 Nov 2026 09:53:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7F106B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 09:53:32 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6ED9E1A0119
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:53:32 +0000 (UTC)
X-FDA: 85441275864.01.0B0BCAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id B4BDD1C0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 14:53:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B/eyQH3z";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794840810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OSKH6DGTrkopNq4tA3GSj5EKxZJjQuu22esfVd2A0Tw=;
	b=SUjYP/bbNXRKno1uQ5+T0T3GCR4wATVE1oiVdaIOGiVfkIU/m8OKDN1n9H2q+Ve/liUxrz
	R5yQeB1W/HkbZKBZ5tkSBDGcPx7A1jAvmFHkaPGhAxa+CCDA6fETDFCBGzWNlqAjS4OLsz
	4wX4ego5gbrd3KWmwps5tKAyjkcIs8g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="B/eyQH3z";
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794840810;
	b=UusXhWf96OHkgw3BiMC+FEyDLI3gepSCyi58iUvjcVOwYA9nOlrXVzQcYU7BiWNJvXbual
	RfXcb7D97RauFvTAlXg6ioVpJQNmO1SxTI6UcxnezzdBmakDuIOAXB3JuPWPRPmFuMDy6Z
	K87yU23oq/H8qwr520yySYUXeBuOUzw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C992340E02;
	Mon, 16 Nov 2026 14:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0281F000C4;
	Mon, 16 Nov 2026 14:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794840809;
	bh=OSKH6DGTrkopNq4tA3GSj5EKxZJjQuu22esfVd2A0Tw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B/eyQH3zoFS8eSMcrtMgxdf11YLokLJ0YHyV5wYnj24qRK5FEAFgjIf8GQ3SAtS3m
	 TeOtZMqmunJFTeq81KdGSP7pzcUYmJhggZHXxpT4w/Eo6Yi17USoOfrsMGatoI7t8X
	 nikwVLMgeiQyItJ4QQR6t6Dvxzeeg3sW8vpq7U1eXgwb7ZWNCTqQpAUXd3bsfBDqbk
	 EOoEXitHtOfu8t76WpxEEAF7dy8RSTuisIMNNBXZkopQTvRRfseu+QhDPg7ipNB43h
	 mc+VDH4nZvyAtNzrVB8ZomBs/1h7a+McMNOuO+O3DQ3T4nhtjoI/GlGieCtgYfAo/I
	 B295pKewLrqvw==
Date: Mon, 16 Nov 2026 14:53:22 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Carlos =?utf-8?B?TMOzcGV6?= <clopez@suse.de>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org, seanjc@google.com, 
	pbonzini@redhat.com, akpm@linux-foundation.org, david@kernel.org, peterx@redhat.com, 
	imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Subject: Re: [PATCH v3 5/9] mm/mprotect: add MM_CP_PERM_UPGRADE
Message-ID: <avsY22UYKI_Z3OUk@gremlin>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-7-clopez@suse.de>
 <avdw0O4rWi4WrTvy@gremlin>
 <079c15fb-8b41-472d-b9f2-d88826e27286@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <079c15fb-8b41-472d-b9f2-d88826e27286@suse.de>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B4BDD1C0006
X-Rspam-User: 
X-Stat-Signature: bbfq4prghttnfwtwzq5uawre9de3yaca
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794840810-841149
X-HE-Meta: U2FsdGVkX1/sTuxArPobufZ7OCrArvkV7MsULVbNomtbBA05j+6tgGaWOlMKRR7p7ESgxlkuDc/3N07ZOInvwqiguHMDNOmM7TCYipNMO3G685kNF37rbNBNZvFrl9C6wzXLuQPIVK/TmDFq5Cvk9WQ2pvNTROJvBLhisluCTsa/xrmW41ztIlE/MD0sXuhG9dD/8/NBAXXLOXVNj+m0o34jqXTh8bQIFPvxLyqn6J/NrF+vwN7JGr/pGHxB2+6X+x0YJAJUBOtnea/XIu9UqBU2ckazVPjia9y5j1KCAGRWgspGafai+96voTsGPUjiQYkOQHX2CQN1y+T/6I8il0qVN7N718e4gLL0KqnybAe875k1ZlI0WhzDWvii4Ku7Tr7Em4WVmLxu7UTvRtK/WQcgRd+stLxCN3jWfhayyovr7D9WpAQee4hPkwGsvtX3hbA9zhr29rSy41wCqn9ar9tk8DpohYTCyt87Z8EobdvNH6kpGpna6wmg5XhJGVMmU+tqeUx2WtD4k27GgGdox8Z5pCuw9/huVKKguaCQs8se5QlAgC1HJu29ullHQ+J03p+iOR9uJQOoJbEq00hFi7U2zSe1tpFjSh8Jlov103Ln3KAmFWkkEY6rizuFUWBc6RCIGrmUCoen7PEaJ0MzzzwHRi7yp6U86IiF/vq+0xR6ZknBF8+P1QgTtY2//btP/TeI95bIlfeZD9BM18iff4dPFT7nzqO9u6UggqnOnUv4o2FdvhnAIIC2iTOICiAdw7PzfsO53h2gqWL5ftessaz2Yhv7hQnIy7SWNY2OTTPMwglsC3LRaJM/yWqplQsrXD/19EHOwORTpL5hXdI6978kfaKoAgHzIvl0hTAflrcN+fd9usLPpx3GXeYiZud23NT4TW6DpFvIHKNwDHVV4jrDEb6Z+EsCJwiFUvR8usEVH7H2XvW3FNromxxwkzwcYP92j907KVXccRn1Esv
 cp+u65g8
 GH/3td5HtaSDSFKpSJTG8kbb+9O9e2IGc/bCXNyZIkoQsjR47n5FhsHPR8CLl0ZGzDdPmF/e2sXwKiVJIOeY+Df9EjBW4VD0adzHJchOpwO3WL5rTT0fCDg0pUDIDNF2WGDZqfzmJaa6+/bY0m5YGrIR6Zvj0eLT2zQ7fZwUaHcA6dWlqNn/h4PUcFxd/I2R0vrF4Jc2xhW53AKba9wiBdDATEmj1Iwpd2/IQ96wxEPoVwOk+mvRYm6WEIFtEux0eYziyHm8u1Bs3QTF7aLUqxBQl0bqdYlcKPjtnRCFIoiL4gg1aTaV38ef8wLDfGDHmAF64BVVrPTey5Lw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 15, 2026 at 11:01:52PM +0100, Carlos López wrote:
> On 11/13/26 9:37 PM, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Nov 12, 2026 at 03:20:34PM +0100, Carlos López wrote:
> >> Add a change_protection() flag for changes that only add permissions,
> >> so that MMU notifier users can keep their mappings and fault in the new
> >> permissions later. mprotect() sets it when the new VMA flags only add
> >> read, write or execute permissions, or VM_ACCOUNT, which does not affect
> >> the page tables. Any other change, such as a different protection key,
> >> is not an upgrade.
> >
> > I'm struggling to comprehend what this means.
> >
> > 'Add a flag for changes that only add 'permissions' (not defined) so that 'MMU
> > notifier users' can keep mappings and 'fault' in 'the new permissions' later.
> >
> > The rest of the message just states what the code does but speaks about it as if
> > it was already what happened.
> >
> > This needs to be completely rewritten...!
>
> I'll rewrite it. By permissions I mean the access granted by the
> protection bits in the page table entries.
>
> > [...]
> >> +/* Whether this change only upgrades/adds permissions */
> >> +#define  MM_CP_PERM_UPGRADE                (1UL << 6)
> >
> > What are 'permissions' exactly?
>
> See above
>
> > [...]
> >> +static bool vma_flags_is_perm_upgrade(vma_flags_t old_vma_flags,
> >> +				      vma_flags_t new_vma_flags)
> >
> > No comment, random abbreviation (but just one word). Not ideal.
>
> I'll rename. As David noted, the name I chose is not really correct.
>
> >> +{
> >> +	vm_flags_t old = vma_flags_to_legacy(old_vma_flags);
> >> +	vm_flags_t new = vma_flags_to_legacy(new_vma_flags);
> >
> > This is beyond appalling and a complete abuse of the VMA flags API.
> >
> > You seem to have decided that you won't try to learn how the API works, so
> > instead you'll just write deprecated code that I have to find time to come and
> > fix up later I guess?
>
> Sorry, I'll rewrite the helper with the vma_flags_t API, using
> VMA_ACCESS_FLAGS and VMA_ACCOUNT_BIT, and document it.
>
> > And we're at v3...!
> >
> >> +	/* VM_ACCOUNT does not affect page tables */
> >
> > What does this mean? And why are you referring to a deprecated constant?
>
> I meant that setting VM_ACCOUNT does not affect the protection bits of
> an entry, so it should not prevent the new flag from being set.
> mprotect() sets VM_ACCOUNT when a private mapping becomes writable,
> which is the case I wanted to cover. I'll explain this better.

Thanks for all! :)

--
Cheers, Lorenzo

