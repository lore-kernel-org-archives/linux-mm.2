Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC2F0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:50:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E63FE6B008C; Fri, 10 Jul 2026 08:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13F36B0093; Fri, 10 Jul 2026 08:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05A96B0095; Fri, 10 Jul 2026 08:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5ABF6B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:50:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4767E120466
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:50:56 +0000 (UTC)
X-FDA: 84972851712.26.9F776D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3BB0816000D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:50:54 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BtIu9TIz;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783687854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1iw77b8X16gJrVhQCh42mIIYra8xo3Yaosq5oDaaVCE=;
	b=bJgqslzhdgVKIZvmYRbvfOFK8ZdrUkaBK0+6BNDxbzqiGKHgX3A2wSEZ/FXtBNStsiXPCu
	fX5v5d+SEyAuxGkfHNzQcMo0RUe+t4dZxU44bzhCpQsCKhs0azEbI3BHAafWR9rBYp64vT
	/X8Oti8Nk+DwcpHIBbf17IoQqtRalyc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BtIu9TIz;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783687854;
	b=Z0pAWwp/8OG0pG/dYt/KcIv/ajLMMm6ZUH88n/Te0Zon3Gt1P2/3dkwBCYGhTu909ysQ69
	sODMF9Wj1K3JkSQUPlBbZIuWMjJXpPZ08d3KyhAB4jFxwE+v5kch8zyvKl94dqXvb89L3V
	2yArk8ods0JmOzu+wgq9ROPBTsmUEEE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 512F543EEF;
	Fri, 10 Jul 2026 12:50:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 865571F000E9;
	Fri, 10 Jul 2026 12:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783687853;
	bh=1iw77b8X16gJrVhQCh42mIIYra8xo3Yaosq5oDaaVCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BtIu9TIzl1M9XFsV3gqi76cbHzlZ6zMvVfGaZhbvQUI8MMp7QoLK8JO+VaM4s4SAP
	 pFtuUvoD3dzOZV6462v3x1pCtBvz7Vty6NI3aEOq26HbdKscVM4MEmhSC/40xPERaW
	 4vmdkoEU+hDFxJDr5AJNzj9fKWamHGWyNBK9b8RBhWR3mJvn7Y7C0rj3/m6CySE6zP
	 /OmkA4e9W9pVi2Scqj6Q2qnXmMnuMcdklTGTzhnJstjkUPf+06GniKe9a1+x7uJ338
	 p5Gmq0KthQLWuAPGAx9v0l1vLB5V0Griemw1ISgvrxpY8N1FvNSWgOMqTEN+H6Hby1
	 9BUjDFT4Fk0jA==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 9CF7EF40244;
	Fri, 10 Jul 2026 08:50:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 10 Jul 2026 08:50:51 -0400
X-ME-Sender: <xms:q-pQajhNh2CvMVMs04M2RE_-I5qeg_oeq1NSooS9Ejg2MGa7jtaCow>
    <xme:q-pQajUfLl-n5OeAYWDS5cVYTzxyYzG1O8a1IYAMbhz4qXJaSe1JzSyvUnJeKh81D
    2veYgZ4iul4w1BCOd7R_y_ZBdhFRZVZ2qP3bIHavfR9RskFz4Y8Qg>
X-ME-Received: <xmr:q-pQanKRwL__-j4KAi0qotz1jyqsdJ4IXAFhgt4tODMThg2kTd4pgr8THeWLgQ>
X-ME-Proxy-Cause: dmFkZTGqkcapElgZfb8WjwSkBUsAgnVqOvHxOfUoaJ4ounnuNfZAYA0+YO2qLAIPT58/FN
    Ix7SS+Y5Wcoqe7NAjDsgp9IeAYHG6o6YNMxvMnDIu5Z4Iviba9gq6emkFYIqhRXnurJOw4
    Cge+6seryEkCJ3T22+a2Mb8c1r7a4P9zvoHvKbxIiDqAtMCGr9F7B/1SLGQmC+rnQp+hS7
    kuFuzIAj3ENg+QOoTmsDUnayPmoHZyCy3nvgUZTAyu0O8MtyCOnVof4iQcB8CCLS7IkmZm
    3N1z9AhCnOmG5ydzgdftJsEAwCE8jUoLyHLdBW5RrZhSWqChiWQnk+xE2gOOJtUAtQnDaK
    S9Hgku7WaQp2kh43WURBLaZnl41STtc9QDDTYK7YOI/kXezNye55d3fQWfhMpug69SjUOf
    kOX3fClx1zGFIaUF3psaJGJohc8a9lurgq5FSKaPhxzS33SWLdQbnsU5HSU7mu3I5vLpMS
    LyhJdrAG33EhQ9ZbAru8cK1Mph1OHsPq3kU8U1E0IGiKYJEbKCYq0sY7fnCUNayg46r3Eq
    qxomXq0U2jhuU7+Gl0pm+O62UYTEvv7JxVyKOcfUsT/+XcHpTOkp6uwv4Q561mnPU4JFzp
    vcbelLVQa8ff92o7KW4Ry+H6I6nFf3gn5+T6klUQOaQ9VY6eybKWvzywKRjw
X-ME-Proxy: <xmx:q-pQamqjkc0G63olNJFoMBMX61nqaH2sTVPtDNv2-2vM6yDH5Eu-5w>
    <xmx:q-pQamsTYEFb93c_cm7GArnDbPMJUQgpIFRSUW12wH3H23LGihLW6Q>
    <xmx:q-pQapVs01DUCrPedF183EAtiE4TTT74e34llLlG2XqJGddA8CGKww>
    <xmx:q-pQaq2NxFiMrDb_1jTx9onYvW5oqqIW22BdKL3Y9yXsQo2ywq5bPg>
    <xmx:q-pQaiceiJ_87dsJf3d-KxP0rlTZmo7_1X0ECN3ihJc01wA_VO-VBdF9>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Jul 2026 08:50:50 -0400 (EDT)
Date: Fri, 10 Jul 2026 13:50:50 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: acquire mmap lock on page table free to
 avoid ptdump UAF
Message-ID: <alDqg4CMUIu_pLVn@thinkstation>
References: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3BB0816000D
X-Stat-Signature: 3pb4zyf9eta7zoy8nogre6wrik8oi3k9
X-HE-Tag: 1783687854-55022
X-HE-Meta: U2FsdGVkX1833bcDrMTo9RIRs0xC/TbWYmf/eDPbJ3CBzS6Tn95WBs2KcVnLvw7d3dC3eeHWNfsMn6eaHjm/EZLTGqz6tPxMVB/GPK4W/O9T2bODIUrfivFPL6QtDFPskz2JSRt4E9aUW6xu7JNr3cFcpm81tx8B/i02O3rZSbswUv5uGz4lWZkgi0fenG+tBGSZ6YDggu926WtX3NKJFO23JV6CQj9bJ5+TU5Q1dYJ+n1eNWvQ9yHbZyXcgYALWMN4tXgwsZtTNeahi0rt21NLsbwkEG4zWK67A4M74E14QzAFVS+e2Wimjj/bjM94zP1XrNteUDLPJTLu8jP6fsaHNG4v/S+/39bBK2+emkSGQ6redJadztUw7Hje6cGADE4q1hBKL79Y2z3qYVT/fwZh/+NfP9jxeegtBDUVub0PnLBNDm/irLXc7vSWH5s1hbhnsT02tgfmLvHT8Qr5tAOC6djBNx55x/BmCsBtvpCiwunXLRDM2HWwiBAC1KtZje+PtF8UHNm57HNc9UJggvIJPPELYodhSob1v1avSgKqKDIPymhFQG3U9GcQRSKZVg3tpgq5qbGUwl94tht8ECEn09me0pEMaFLQZO/+3lmkDxSeLO6hvguYyiwL/Au42tIn8t/zVWl2DkSNe0ZFsCi6YVV9sL1yc+5AXJZUkbCskkZLcQ29FUzMzrFmBNiRyi8xqUnXOYK3RwTatenwjtiPeuRrXI2iclc3xdpB1Hi4yw89Yjzktls/Wq5c1wZcNdDqYvyNsJ95gkq4csv/BgPO4nIxfM9yKf45r40xV9Es5bv7eeKjSrUIMobXGQaTrKr3yavC1Hy5FxNpDTIQ0ntnJVIBgwmY3iViVj699JY/3gOo812rulvOwgyBkTJPO+oPiI1Nwzf2q2Ytj+3Psah36KuGbggDoNSR+caOJ9aSKCkuMYODw3G0ARhuJ/Wxjoh4g41jjApc+6d1NPmc
 4+fTTouU
 yFr3zFJZe8kKqALrQ/IIMQy8m8b6XM4kE8ce9QzzfmqWZAWY4SeZh+phxc/IT7XiZXi+dJ+KUmOrWOmkr0No1KzCuhYuUTxdtbACxanjKjSXTv7GHO2ArH3U8V6P2hAmCL+HYw2pcFRI7Zjd6UE8ZhAgd4U4HidCfxosoG106nNUitdKVFT0R2Hq4d5orw6F5IbevnbM4+F0uZYexxF8IvvPZJTEASKbNUlpuD6ZWu5ZIFYeoDYUUDsQ7SsmJomuCQVrfBkPBteGQQQZUVg0TJEMuOH8Sq1m1ic9RKCzuGGb0zJs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 12:56:40PM +0100, Lorenzo Stoakes wrote:
> x86 implements page attribute modification using its Change Page
> Attributes (CPA) mechanism.
> 
> This tracks properties of ranges such as cache mode through x86 page
> attributes, and as part of that logic manipulates kernel page tables.
> 
> Since commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
> fragmentation") ranges of kernel page table entries can be collapsed into
> huge page table entries as part of this logic.
> 
> As part of this collapse, it frees the page tables which the collapsed
> entries previously pointed to, and it does so without any relevant locks
> being held to preclude concurrent kernel page table walkers.
> 
> The only way this code can be reached is if CPA_COLLAPSE is specified, and
> this is only set in set_memory_rox() via:
> 
> set_memory_rox()
> -> change_page_attr_set_clr()
> -> cpa_flush()
> -> cpa_collapse_large_pages()
> 
> Notable users of this are execmem and bpf when manipulating executable
> mappings.
> 
> However, this is problematic for ptdump, as it walks ranges it does not own
> and thus runs the risk of a use-after-free on page tables freed underneath
> it.
> 
> This patch resolves the issue by acquiring the mmap read lock on init_mm to
> provide mutual exclusion against ptdump, which acquires the init_mm write
> lock.
> 
> It is safe to acquire a sleeping lock as all the callers invoke
> set_memory_rox() from process context and in any case,
> change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
> mutex, disallowing atomic context here.
> 
> We also include cleanup.h in order to use a scoped_guard() to implement
> this cleanly.
> 
> Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
 
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

