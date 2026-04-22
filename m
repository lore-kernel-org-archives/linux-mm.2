Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D4D8F9B5F6
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 09:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8719C6B008C; Wed, 22 Apr 2026 05:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 822546B0092; Wed, 22 Apr 2026 05:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 738906B0093; Wed, 22 Apr 2026 05:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 614236B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 05:27:09 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 149361B9A00
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:27:09 +0000 (UTC)
X-FDA: 84685662978.21.D75B325
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id EE1AFC000C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:27:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fW8rW8oH;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776850027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rhIGk8GFMlq34Kjk/C2UtOrmRiLKDN1ivOfWJfCS1jY=;
	b=jmnf/hyCLmEso6h0tvD6BShxpvob9NX7c5fBe6e0Po2PTJcZxrUWXQkXHGDM+OnUSp+TV2
	jmSyBLgQ6g0OvRmm5/vVy+asqi/RvjS7lUvoQpYnwM1n2K/SqKmMfmwuFYOpFSQxNbu7nP
	pXccuAv2jIYmplGHQkE5xuHSIFQ2uSg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fW8rW8oH;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776850027; a=rsa-sha256;
	cv=none;
	b=RSULIiFK8cgmc7pQONk9HL8RwTxaNuHa3llshSnKGhISnCqyydiSXTzuWDhTDL/SuPypnM
	KjDYiqEVbDZdbwuITbIPQo6Q3gZBQowkKVMjccDL6MT5AxnXE/TCeLWvz3Ubo6d591J0Lj
	q9Arb7Jv3yiO474l12/U+5b/oyD4aHk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E732543E73;
	Wed, 22 Apr 2026 09:27:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32023C2BCB3;
	Wed, 22 Apr 2026 09:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776850025;
	bh=XSXtvCEOw1rXi02T2nIM3gho4XRJ3rOy8aCyH/Flzh4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fW8rW8oH3Zc32i8I3WGhWbQgmqOQKPT6gmk4fL2A7usxNc9F5NFFDRh4v+xNfaQkQ
	 sh5xmCFr7QeNBkx1UZEBXgjEQnmllo3w7bxebHJ41r/S380l5A4Lnq6z78cfADpCHf
	 JvONOpjWbbGLy87jnRV99MswY6ifyOlCnJe5Rrr5rOV25RC7VbomMVCFAcCbyvU4hn
	 1QCqqks9KBG3Ah3iBAeJlBBr4fSZdxfSbI0DamZu75Ld1yt86YzUbOGFW5YYhiS4m3
	 7z8qA7SgDS+aQm/+5cTNVdO8XtiIC7TAPZtT1AmObHBUUEjx0t53Aa5XfsthRa9gvS
	 8/8ikfI0ZNuqQ==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 375E6F40069;
	Wed, 22 Apr 2026 05:27:04 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 22 Apr 2026 05:27:04 -0400
X-ME-Sender: <xms:aJToaeGii4IM0oL6w5d9DlxZY3J34dusHidJOAQXLgxR_JTVDGQCyg>
    <xme:aJToad0Ul418c1XPvY5j--gNP5mTl49gtqYfgphTeOn1ICkf_UmQy3NXxAS3wq9BG
    NJ99eKbxEncWGVE7MVsMuCQMSN12LZk5LZkSG7ZLzIQZqixnHUxC_c>
X-ME-Received: <xmr:aJToaeWov4PpwQe5q92KBYrsgst-IOJcGq9KUBqEPWgZnkyw2V4ddXjAIzZCzQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdeifeeludcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeeuieejieffkeehfeffffdtkeelfeelhefhfefhudehjeehvdffleeuvddufefgkeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheprghkphhmsehlihhnuh
    igqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughh
    rghtrdgtohhmpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrdhorhhgpdhrtghpthhtoh
    eprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhg
    lhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtph
    htthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohep
    iihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:aJToac1TuZDXfFwGRdKOtg1b447Z32xwhaJLPFiNfasgDF-0BKtUBg>
    <xmx:aJToaSf7bUXXrkiDOgQqd6YfId5bSLgjAU5kG26CSzkCZ7t6PKo1ew>
    <xmx:aJToaeT_HeYfJdQGHfRSP2cjHnz9A1PvUdNFY3H4v5as0SDQQ5z40A>
    <xmx:aJToadkTSABajhQ1iNy4XkkRzKKnBSjuz186wCOy5HZsK4bzmG2-_g>
    <xmx:aJToaapUOmAHDxHH5oNJEiX7nbl8UAhRgZuVgIHxUCaomgEUar_uEr38>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 22 Apr 2026 05:27:03 -0400 (EDT)
Date: Wed, 22 Apr 2026 10:27:02 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Sean Christopherson <seanjc@google.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [RFC, PATCH 00/12] userfaultfd: working set tracking for VM
 guest memory
Message-ID: <aeiUGtFgmYB9M18L@thinkstation>
References: <55019037-4f1c-4d9c-83ee-3a844d8f3d5e@kernel.org>
 <ad50rPOseVa-SP_s@thinkstation>
 <aeDoqFWPFxkkNB26@thinkstation>
 <1a499781-1115-44bc-adbf-2ac3769354ca@kernel.org>
 <aeFCuLJXT8VOkzH7@thinkstation>
 <4c635703-3d8d-4cfa-bb98-7f6f5fcbe547@kernel.org>
 <aeImfRrrvr3UoKtL@thinkstation>
 <aeTnlQUOOh-dHG8z@thinkstation>
 <34f75083-29a3-4860-8a6e-94551d37ac6a@kernel.org>
 <aed6fHLrIdahbdY3@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aed6fHLrIdahbdY3@thinkstation>
X-Stat-Signature: mbhg5p33pyeanhcgwcn7w9x674b7piwa
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EE1AFC000C
X-HE-Tag: 1776850026-826934
X-HE-Meta: U2FsdGVkX1+p2IywM8suxvhXYHlRtqLM+J4XSUIjXrG02By2CoewtoY7dnup+aU0ndzAuB/YlNw5zwdih1aY+vmeDJaBhgwQXfljpFj6n1j48ZSdZwNpR0XHB15c3iKjDYZATYZ9lwUmJ7MkUCKEXw4CCtnYTSKo0HsuDBMV+DdNwqptm9q5N08hyBLLgLix6+aDLSYad1/Pmlq5tEKgiVFCu74mdH0/xfcaz6e3fckiCdNWwM8rOgZ8X2owsA4J4BBV8sGOjaIQhbyNAZrHS/4wYgu7SJanHmDwvS9moxbaXj/pqCBbmo1ld6Mp1M/FC7bAIn8hd9LXHHzb9B2RpAkmAh64O6PGmhmoJVNupt/QTt5lVUgTtcDn89OdY9w81dBqO7+u2EceadIrWbQt1/bcCaOfNGU9tSVFIahJq4r2nhTmlDFYiEpsA9iH6yU/soKaXtGufKvHN72nUWhrH++r/jKOtncaDPuLgJ2kNWSn02yMB4JFg2Rlrd89cIxOYeQttEySSHmH7EEyMXU1DthseT7+jhajQGNZFFiJPz7j43484xd2n98QbTf85W83NsR7QsC+A5zb3zydJoQlagAC9n02jzRaMWFNWiUDpXiJlH9M+nywuem9Z2UMMe7TCcNigd7YxywI5+aZFQLkbFJ6Dhb1mW6GhmnJjrWq1lBZBx4nfEt2D+hkARmvqoceW++wFxGCAm0tyLLQE7GkmavdRLYSqmtqKDkv2XFqMCjcwRBlNRLGoooBX9i5hEIXef7lxaiIERu3VekFoV7YQ5oWAh3B8vDU65AsqgG2F1lv+uKT7dG5/YnTDS8q4/WnPM0pwSrBWtcAaYVOebr/ZWvyYGZGwfT5hHZLVPgqnbMIncWv8pB9GiPuUolAM1qVyNidx2nD8S7iQ/b2N0dsFoojtegy3gs35MJW/xUqo+jlX3XNJvuTZg2yb/LFeO1Ss3oUvyCPE0Dnlcgvr+u
 RBU67ADT
 FiT2GYjMe0Xu13gJ4EbHa/+/XHCW4EMnulQ59Z7qg5AIaWny4NNHUQ2VBK3WgbkQq0QDB9MY8QBrCpV0sXS/dWIno+M/md23ZCUyadjec6540tYO/pnbamdta6+jBMSDRL99Ed3CulFCKq1oxEHqiauZ5EcrxJJVW0Q590gxlMROmv6p9QYIZg5IqYpyxTyWId7GvSpXM6Ydr7hiKD6cWi20nIwF8sMd8efF9XFSC4KQvGQ/43HNp0+uXVA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 03:33:27PM +0100, Kiryl Shutsemau wrote:
> > 3) Some other stuff needs a second thought, like
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index 8e7dc2c6ee738..08fc18f1290d4 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -695,7 +695,8 @@ static inline bool can_follow_write_pmd(pmd_t pmd, struct page *page,
> >  	/* ... and a write-fault isn't required for other reasons. */
> >  	if (pmd_needs_soft_dirty_wp(vma, pmd))
> >  		return false;
> > -	return !userfaultfd_huge_pmd_wp(vma, pmd);
> > +	return !userfaultfd_huge_pmd_wp(vma, pmd) &&
> > +	       !userfaultfd_huge_pmd_rwp(vma, pmd);
> >  }
> > 
> > How can a pte be writable and prot_none at the same time? Maybe just confused AI
> > output that you should carefully double check before sending that out officially.
> 
> Note that this path is for !pmd_write() case to begin with. It serves
> FOLL_FORCE case. I believe this check is correct: we don't want to allow
> to write to such pages even with FOLL_FORCE.
> 
> But looking around, I missed gup_can_follow_protnone() modification. It
> has to return false for RWP.

With gup_can_follow_protnone() fixed, the checks in
can_follow_write_pmd/pte() are redundant. Will drop them.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

