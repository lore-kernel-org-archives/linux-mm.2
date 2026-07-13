Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 035FDC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:19:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92F96B00E8; Mon, 13 Jul 2026 13:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6A036B00E9; Mon, 13 Jul 2026 13:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82B56B00EA; Mon, 13 Jul 2026 13:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 979A56B00E8
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:19:11 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 166C9A013D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:19:11 +0000 (UTC)
X-FDA: 84984414102.26.663CA21
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 26C07A000D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:19:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=boJ4VxME;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783963149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sT8ncCoskQ+pPBlVmZsj1ldkcql22WoFMry/YNTn7dY=;
	b=KC2SgOePsHexIPnfrYaesn5bjAUjtWC9ZnDTo4uaTggk+sH6MtejSI64v6e+9EIcGo1t3r
	2AUt5o1pcnbrJtyCPUif/zei62g07VnlwcJnNzReep6wQxrAuzjpwA8BQjghaTeBpmk3FO
	VmMGHYzHZt43SbdJV3e4/UTp03MUuqM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=boJ4VxME;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783963149;
	b=pmfrmPP2uCOB9buiwjaIzWxSEone7q2a6M+hwl+92u82cKd8fUyAsGZu7GXOqZyA9eQgAc
	jyodFJ5CgPqX5RU132yAYxvfmnJj70FOoslYEr7BFWiRaIIHf2Vp34feWXX+wVc83nbrRn
	btzLbTi+/a7XSqPT20U83LaZMaw9PKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2879600D8;
	Mon, 13 Jul 2026 17:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972251F000E9;
	Mon, 13 Jul 2026 17:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783963148;
	bh=sT8ncCoskQ+pPBlVmZsj1ldkcql22WoFMry/YNTn7dY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=boJ4VxMEmG63STqe+XFCnj16oQ7l+0rEaBTr5BJHY/4QyYwdcOPLk/CHmde/re4iF
	 fEh0mglmtEmzRuQhUOEqnWlQt0tNYHyA87uDBHT4b4eL/9psB7SXrBl/4bqVXFwHh0
	 l7qy6tODw0b+aIxGBGn7vD44LU8rX1Zp+c/ToNTc2uPGrxPaPSqjqSs2f5z9OBXHUd
	 6Ay1qFpyMD142+txfZQ+JBuhv8KK+GOMsU6TVRKs/7SR2+5/454lJUVIwvwoNuuOuL
	 ASVfuIEZbms/fzPv86YOTlYqCDS7kM8Ui9XQKZ/7H784DFE+qnfoQFLk9EJJ4zKObG
	 AuoKKLf26ZUYw==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id BF36FF4027E;
	Mon, 13 Jul 2026 13:19:06 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Mon, 13 Jul 2026 13:19:06 -0400
X-ME-Sender: <xms:Ch5Vapkw_J_hWklNR21wK1KKIBeblcJH9nG69vBtUr8uQjtvdjbPzA>
    <xme:Ch5VaoEfePqA02oVSHz1UNta3XSzzWuL7PMDrX_CqI7wdD4WRaeY1Lg0laPXMYiCN
    wCRW_Yo5Hc-hxCmB9N_B7KSofxg-hYvVALdgo1XQkJBX2WtxtdL8H0>
X-ME-Received: <xmr:Ch5VanIsgv6d1HLy3wvj80hRkRg2wnsowoe86iILxc08bdfEiELSDRpW4Pq-ZQ>
X-ME-Proxy-Cause: dmFkZTEJ4lXnpy7cJu3kFZKie8XWmk7c16mf9c3dcg0mO/FRWw9JnqjgAXFL0YAMoBP1EJ
    3xyuhbt9BpRDEzXMxnJfwaKFHYcsya5wGuyrDMTWWxzCkKI4Pv2rog+fL8gPL5WqfWAbUY
    ICsHYG56N5Gu45mM1QaSisXid9T5TyNpxl5uf69gdMIrqWPh+JXRP5hXTFb/mkMc+UZAKA
    CjLTsZZCg8zJeTPMIApQmEoo4QI6fow3qIeTeBGGYfSrtF8keWO2+L4+L3246fvQcvYPsD
    o3OWDXJkLyganHi/46YNGLhBEpkTvo55OAnPmHxwvEvEXua41QXG/KQ5VQtjTJBqbr2LtQ
    dDHAxskcep2CzldPvnyC0cQU9W5m7ZnNLvHQD32nI/REFI51GAnENKrKi4nGZu44nogMkA
    M8DvSGtHMwaG3Tq9XiOUMo/oggtZVqfJkJPMieBMIykGMstIdx+hkm4v7j82UolMzsQaKn
    70uRX+2FasfCx9DVifeP+mFUBYMOEemngKsgGj32mI1qPdvsXdWFgZt7NlfGVd7V1zgeGB
    DeSZN38Ez3MKW0qgKNsGPX+mFRnIWtMdEJfdqszTSk7PJbHp4kYi0PT6dwN/ZcHV+jX76K
    2xvLHjPdyR5tLmOwT7JWSXJxl4RH8Aa4m3eU/bqdZeoNZrBgBUfZ+bMC9wNQ
X-ME-Proxy: <xmx:Ch5VanNriCjfnz8yYshIDIf3p97N9HWCROMmDfgsNcmm-xkWsAc9kw>
    <xmx:Ch5VapEYQMiAAASjG9sGsIVxLSdOmHJNRPEhZi9iQBk3ZTFu7vi6sw>
    <xmx:Ch5VaomSoAAa4XNbLcCuZxhmsnahq9uskwAhdsHd75mnMcxahDPxRg>
    <xmx:Ch5VakcdkwWfOV1Xn37kJWx2WqlIHFcP2GCFH0zriKVprx1VvV2Dow>
    <xmx:Ch5VaiYvYAoJxn7KpCO1wmZUIlSx6AbdaYmo4o1S8m3emWW2DXghwl4Q>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Jul 2026 13:19:05 -0400 (EDT)
Date: Mon, 13 Jul 2026 18:19:05 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	David Carlier <devnexen@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes v2 3/4] mm/ptdump: always stabilise against
 page table freeing using init_mm
Message-ID: <alUdUKk0zGmskSib@thinkstation>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
 <20260712-series-vmap-race-fix-v2-3-ad134cc3a12a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712-series-vmap-race-fix-v2-3-ad134cc3a12a@kernel.org>
X-Stat-Signature: ni3skd9ypu3nkom77r5yr48kgw5bzxjx
X-Rspamd-Queue-Id: 26C07A000D
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783963148-378745
X-HE-Meta: U2FsdGVkX1945htg1LFMyMJv9jY1EG3QK70uiksj3IIveEZfHBvjnzRIoag+Lea4eArvVyh5PLF+J3IxYDcWQ7fSUbgPxfYpChI8p49svt4/6GbvAjCLp1nAVa90JmMCGyElVejYms90Gz3Hd/WFNVZ9Ck5yTXrtu3KAhwNxIo3rVpoWqkzbEb9gZeZ+8+0wj+9QYKtH9M+CZlP7A6mzOWz0K+0vdjCFFroguMIHJyI11ezY+NDPn3EkcHGimf24tiP6o6vgINKWY9azy4p31GgS2AR5np/tQK81lD4PkwQT3ZpEFQdUoSkBlq85msxL1lv0FoymR2/Z1mLeR8Fxn4xS05HOLuiTcURyf7plEKHLw31xxvOF6C/P8ny2FfQTOD4WHbsuaBhcEq6Ey8d5t4vpdgF8PBzZk4EgnNbS4qLajWdMC6AXlAPp+hMS6pXN3abPjW9dIPTJxe/ceY1bdvxjooTkh2VqVpZCMra622szKaiq8x/eY5gWXa6SEbflNM975RLu91FSJwJRuRZaz7exP0JyoNMVWV+IkF0ci4FtuiHcu0k1BEmKvx7ES+A5/o9lCvN3+6ncXrhWVKd4NkbLytKEvVMxw+6SUgUCggltn5WRdsn+mSZiVODKZ7FZuL/MyyzWQEZ3BH3nDi21FOmJWlb8RY9se4BrEsV9tW7UuMcUYjmRiz0DVJ6xunHxZhu/+cOsCCzCvj5fptOmDalrNSR/Js2sfh4QqKF09TL6bFyt6PtuDloLEqRopmGT06+713EZuobGeHZ+kjDeEtoxenhuEiH2EELcc/4mjLaAC4Ivqg9vbCYWMBCSEJJyILQ2DvqX/5XqxHfBQ+13xyIdudZvyjzb+A7hCgAmJYk/LVLwgt2fw/YRdARxA2IVPnvMXUik4T4LsnxY7N0GApHEzIwJ99wm9KeLh8phjyFYhMlHLDUdfNUn8SzfV97tsIdULE0l5l9rvrS1913
 fnl/i6w5
 5qpElJmOv2RBxHE0CAeYn+dfu2hNA+3rrpS3cChtVxfQmywZXwVT7Ekba0492gSs8d6PmLCqDro2wz/ZJ07Unrz0xr8/nKnMWyW4yvJLhOR5g8l2wBDKFJk6KCaSzRXY9KNkMxhaLQ4ixl0yEaDKjoJG4Uz5ijqzS1dtwoZkxVd3NqifngGlwhJMZHj6rijqA4xaSVoz2IZ4AmETtGwnpXv6WeVvrKwebYJh+X0oLS5+fMLN/tvTn9Yoeu8q96kUFQ/AViC99Pnuehk8XqtbrU6i88dSn+8WUGoHPhazpa49Vkqi0137ealR9GW3FbdtWW6zxWx1J5N0EzNSFD4TsIuuQVn8y/L+1hHeI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 12, 2026 at 11:42:26AM +0100, Lorenzo Stoakes wrote:
> x86 and arm64 invoke ptdump_walk_pgd() with non-init_mm mm whilst still
> walking kernel page table ranges.

The code looks good to me.

Same comment as on patch 1 about the commit message structure, only
more so: the race itself is never actually stated -- that these walks
hold only the walked mm's lock, while the freeing exclusion built by
patches 1 and 2 hangs off the init_mm lock. The fact that makes it
possible (x86 shares kernel pgd entries with every mm) is hidden in a
parenthesis. And the last three paragraphs read like v2 changelog
rather than commit message material.

> We take this after mmap write locking the non-init_mm mm. Nothing acquires
> the init_mm lock first before locking an arbitrary mm, so no deadlock is
> possible.

Do we want to document this locking order somewhere?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

