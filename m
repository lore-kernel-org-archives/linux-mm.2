Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35BEECC6B3A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 16:28:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3B16B0092; Thu, 15 Oct 2026 12:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3D036B0095; Thu, 15 Oct 2026 12:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D04606B0096; Thu, 15 Oct 2026 12:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A12286B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 12:28:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C43E12011E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:28:09 +0000 (UTC)
X-FDA: 85325392698.07.05848C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6725A20008
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 16:28:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XoDoNgJY;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792081687;
	b=W61q5uLXDzg/aeq2L/wQyXg++CkQuTV7QDt2OktmN1hDwZfPx5xOCamLzXkiMQ8UU5PW/8
	vuj5nXVRYF1ukCad1R3MwhQesbYklai+/HNLo3wXj8++f3gN/gcCeuWEyQypiaJM8awuWL
	RhktROswKj0Zvt2P0qKe3i6Ie5nFSPI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XoDoNgJY;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792081687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLnWwWNMPSm6y57bf4F4xUjaAeFj35H0VYjcsc11Jog=;
	b=Mu0/cvuD1OiLt5aDbDYndevLud5+Cbos7zzbe3ftMxMlJv+9st2qDodc2ly/PVID8hHEua
	cTTBAPonv3XcjEY14TsNPJOJWTzzwVJ9wpUlJXKyUEt7k72A336voobw28XpcL+dXjvtYq
	C0io44z5rlFcVqRLKzu/Yq+TiXOQpZA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CF5E41881;
	Thu, 15 Oct 2026 16:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6661F000C4;
	Thu, 15 Oct 2026 16:28:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792081686;
	bh=XLnWwWNMPSm6y57bf4F4xUjaAeFj35H0VYjcsc11Jog=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XoDoNgJYJMqr9vyGRiW3ypkgKBopgiUuSRDg6wNPKmdgpfrW11xHPPaLdEyhNhDW2
	 YUWvLh5ZV6hNwVJOcu38x0CgKFxpxvreAHI/1jqpxTxcGmC5sFaPZJYCcY0CmpkzNb
	 JWi4NEC9MyrEPpInNFS8cqXGiLyHLtLA6k7Phsjfs8vDXr+ddqa90jgGpwSoINykgE
	 xJo88GhhHwORpaTZvHUTgfYQIK8eg6DnI28n27yzbJ468Gs3XIn2Nkc4xJeM3R3GXg
	 zLKQFLzJJxiYcXKBjL7TsHfAYCFyKYddxGlaniCrm3xPQJye5eaISd4aI8RSy6mnXN
	 AHqD8M4tv4JVg==
Date: Thu, 15 Oct 2026 17:28:00 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R . Howlett" <liam@infradead.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Jann Horn <jannh@google.com>, Michal Hocko <mhocko@suse.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: prevent VMA generation reuse from skipping readers
Message-ID: <atD8jesRoc38xF0J@gremlin>
References: <20261015143735.1630957-1-4ncienth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015143735.1630957-1-4ncienth@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6725A20008
X-Stat-Signature: e41pi7n19bct8sk3f98or39ie7u4db7a
X-HE-Tag: 1792081687-147564
X-HE-Meta: U2FsdGVkX18nZEp/GGlxHh1E6R/H58nwOoHgptoEZOoQuRy4Eq8IhTFBGhMij+2oH/cqiYDar5AyAi4uy00bIdXPHkv/3EgmQRr5lS0S6uETIxiWJ+U9aCUw9nrSRzd197aJqkKYTS77IjKjbQiqZ4ai0aVtAS48L1QY+kaovW4e14uqMeq8faq1aF5rByyvb7VdI1hexRnSa34y2nZM7foViHUNXwyY98Km7vrN8BJlS1tupujRsSTXKAmW7F4ZXqdT/5ZORY73ZHD9gZ0xROCCxic3pk2ihjFPcvgHIk/ATZ44Hxjfd2dXNt3bcUDefs0GnSnXBDKm74h66fK4rUyMF1P2piJmb4hi/8zYucMu+QJhDOqWeqdSn/qMW5RW8BElPhufSwL9XWYS8Ov++lCOG6xIGDbiLFfnjA8t5mmFb0Wyhu2se2oWZxaPgEnlQfGZ908vt10uJEUpUf3BNzFhBVfCQoUyAtgPJpu5fnIP0UpVaklr2rG+qukMr4kX/q0jb4IOr1C7aGeNcip34GHzQdUckza3Z5p1yGO8iV3KmsKbomYasDu6+F42L9C/F9t6zmr6Mo9ZoeOAznYhgVFvEyV6qqNrBHRu3im2udCgv18FbhUlYBjuz2igB+lzw+jw0H+DNkJ7hu3eEKsKYX58D2RDtvXRdqvhQD1CSAGmdlnCBsc+FZKnnkVY0H2YTJoVsJO1VT/EXbdHrK3xiXdqI/vWfVLqjZyB2qc5YCYU7LZYwnLSf6uK1egoWoyzWo6AJy25pNP0B2K0ekq/ZuZc/hFP7iV3Pqz3l+OjGO+ZFT26bV7/i+eG30Rjil88oOfiBVakQpBQnyLqAncy/4D6xdORJ4XJgNPKSl8FGjlTfw8KF3klWMZ/ipqnokhRi4mrxRBgax97Of8YmQgCgYp3K72wVzDOylkqKf8oEBKrqEoPEozZELSZMOUlmWJDNF8C2ApTG1atgMVeE4x
 2ke4M0bU
 BfXepn93GATpznF9tkMxGbiRtX65l6P64RsWNdz7OsYnSK/kKvD2AYyug8RtOw0QgWLtqrxpJkSz5uTNbE/O7Al8aNQJIarDJz66R8HNktdul6+d2r9zYwyconcvMZVCMXzw8yDo8q8oKb4k/fU67D9jtwQDMwhzf1cQh90A55/F1OhH6NTR/gLFPcW9vQv+MDk9mtUjGAzfiDqmhJRGTrfgFXLUPV7yVhpRB256YgylZw6V6mKBnvqCxeQLlbDE/cniT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK.

You're making VMAs a cache line bigger.

Since this is the second time you've done this - stop sending patches to mm, we
don't want your AI slop, thanks.

(In future you'll likely be ignored.)

On Thu, Oct 15, 2026 at 11:37:35PM +0900, Daehyeon Ko wrote:
> Both values are 32-bit. After 2^31 complete mmap write-lock acquisitions,
> an old VMA stamp can alias the live odd generation. vma_start_write() then
> returns without waiting for an existing reader.

This is really unclear, I guess, as before, a member of the core team (likely
me) will assess this to see if there's anything actually valid here.

--
Cheers, Lorenzo

