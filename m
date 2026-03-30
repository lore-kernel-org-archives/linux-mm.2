Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 151341061B01
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445C36B008C; Mon, 30 Mar 2026 10:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41D456B009B; Mon, 30 Mar 2026 10:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332FB6B009D; Mon, 30 Mar 2026 10:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 21DA26B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:27:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1DA8E0904
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:27:44 +0000 (UTC)
X-FDA: 84602958048.17.24E461A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 844F4C0011
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:27:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ORlFdPeC;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774880862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lJF0nkHYYwbB7bPJSppNUiXtvmyMoKWGfkNBVqXLiIA=;
	b=IJ6vSf97HoJLGfywqYBArnLZIZzGE7xBBCoF9hsWQnRs84hF92fPN1g9n+br8T9x6o2hmU
	JJ8eJe77GPEOdbdsfZstNGARp+sQ2iyBZFozglSp709Ce3IbDQL2cYtjAjvEU5BLWYmc64
	YMhuO4Ss4BFSoV5QZLCLcp4EoyF+rxs=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ORlFdPeC;
	spf=pass (imf28.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774880862; a=rsa-sha256;
	cv=none;
	b=VFDx575DVCCNKn7WrwCufb8M8cU6Cw/O6UbRq8w2Wx9+ts/8lSSDleRXdWAE0DjSzwFtwD
	qIy6UfvLe1Jklw2zJSMPTmYa2tWIPh1vJjTIOUeGkYzakww0/6Gdzcvrmru1KxbXOIrCTn
	YnoSNsKV3MYV5YqfMDrgzMJfKpGFfgk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 74BE643F88;
	Mon, 30 Mar 2026 14:27:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CAC0C19423;
	Mon, 30 Mar 2026 14:27:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774880861;
	bh=ZRa33ROhxro9w//Ij9lOfu6+s/cl7vsBNnwHFqQHtM0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ORlFdPeCuOm5yvoR+5/YIS+vR3RfBgLQ/I6FN3Wq0OF3dtf6ino1EHB1KapTFT2Nh
	 +Ee0GMKAovN5DfBJFbWzgeCtgA3IoCG39QT8Z1kQpZ2aV6Whba6Kbw0dkFGgOraXri
	 n8vlPO+JPgx0mz9FXOVEVRDSeG0y7NQfttJeCznVCyHOXrTyAhleRZGNKvkczOQhkS
	 cj6nCo85qm5or660USUhYV6+h+H5Hag5DjgRgorkUfKzD8Or69cB9ZYCtCeik99KLL
	 xsnKBa195qmzONTRnad9P+47USjRnCIS02AkjPbE9RJNEayZ52NThOoPKAjulmArvB
	 OGOVnrnRkcVxQ==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id 7B2FAF4006E;
	Mon, 30 Mar 2026 10:27:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Mon, 30 Mar 2026 10:27:39 -0400
X-ME-Sender: <xms:W4jKafyFvdk9lq332v_h2kI_OMoE0HyTT9jRHQKItPxXled9JHibHw>
    <xme:W4jKae7EvQI39ix7CkxB7sHWWP_iXTJqaXP29YwQe898JeFNPkezukAfa9THGFYPd
    ri2uZipdzvFPWK0UZaEGMRFvqMASVrCDALi2ArCbCXXfSpQXKrClg>
X-ME-Received: <xmr:W4jKaQu8femLmzHgyXPuUowScraoeIiL3B29B2wYdeT8pwCkOBro19Kaq4h9Iw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeffeelvddvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeigfdvtdekveejhfehtdduueeuieekjeekvdfggfdtkeegieevjedvgeetvdeh
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeehkedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepuhhsrghmrgdrrghrihhfsehlihhnuhigrdguvghvpdhrtghpthhtoheprghkph
    hmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgu
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhi
    nhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtohepfhhvughlsehgohhoghhlvg
    drtghomhdprhgtphhtthhopehhrghnnhgvshestghmphigtghhghdrohhrghdprhgtphht
    thhopehrihgvlhesshhurhhrihgvlhdrtghomh
X-ME-Proxy: <xmx:W4jKaUDgxdV38pqQgWKfY12ZfMdTvJWoxYvp9yoj5tp3RF53aOKuZw>
    <xmx:W4jKaYiQvfcW-HNrAn_B0ybqz3tHT342qpIx-AbDXFclmWrv05HLeA>
    <xmx:W4jKab2kU5unsMyH8uDFEgy9e1PD_HS-cAPDw7Kv-YyDXjsjtk2FEQ>
    <xmx:W4jKaVu4XJ7ufDGcRqnJoyJup9ZEVEmnrVJd-_-hG8uC7QT6KNilag>
    <xmx:W4jKaeDXpzhBEJ10Mc7NaHxSHY66iH_IjaP4Rk2XV8ZLTe34eSpEa7l2>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 30 Mar 2026 10:27:36 -0400 (EDT)
Date: Mon, 30 Mar 2026 14:27:31 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	Lorenzo Stoakes <ljs@kernel.org>, willy@infradead.org, linux-mm@kvack.org, fvdl@google.com, 
	hannes@cmpxchg.org, riel@surriel.com, shakeel.butt@linux.dev, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, 
	lance.yang@linux.dev, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	maddy@linux.ibm.com, mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, 
	hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com, 
	borntraeger@linux.ibm.com, svens@linux.ibm.com, linux-s390@vger.kernel.org
Subject: Re: [v3 07/24] mm: thp: retry on split failure in change_pmd_range()
Message-ID: <acqH5SNpSoWAkg7A@thinkstation>
References: <20260327021403.214713-1-usama.arif@linux.dev>
 <20260327021403.214713-8-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260327021403.214713-8-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 844F4C0011
X-Stat-Signature: ur1ok4w3xfj3piecof5y8mj8rxytofhh
X-Rspamd-Server: rspam06
X-HE-Tag: 1774880862-342437
X-HE-Meta: U2FsdGVkX19ocvylHHFsiCErg7opAwlKii/CWu22fZppXZuBs57IdHWfwUCrBCtdtchzyoeSFDql0X9wzMWA2rxtreJZt0eLWv57Z3DVpimOANy1+TQvYuoNzviOS6TLGQ9vBjK/6GtfD8svRPWwZUxroQ5eBWOJSzuanxNzWhLQerN5McBphgmARMuK9T2eqxctwedhdE2UjsfVb4lLMMz2NN0QooWok1OXPOlXOnQZdxTbbTf12OJk0+C+hjaY7zEOld76OzAGEpW1M9Xhv6E2yOxz2v2Z0Mo+nXpYJMv1x2CxZCc3kmyCLa74p8NX7GldCTif8Q6CYoGu520ZdEzwHTYLMzrI2pg6x+dYGp8zezPXYUSzan+y5ww8/xpvZrf6n9VTmClVSyfIB8Tn4a+620Nsh47Dw6K3YgMdyMTTltd3/8WoMEyQGyyzdtBtg0HlFIXxmw4CVZYoLAax1KhFicIt4hJ7Ht3Lfobvh/vpa086zifhH9+pDzWuHYJFpAcgTUT/58Of/0/VNsYIdAI1ztC9Si8yOMke8keyW4kjkGkYS6SriEv6az/3jkCRczemf/dTBAp47LhanETtivj7spokkkRQoU8cbop5gszEfuhGHhqLiFQ2rMCbnfiCdwuLjzr1WSxpTXzeWNLFAxatS+uTgc5Xbs2k6lBiGjb4VoHBHHL3MkixjF0SBMKw7W8AT85Y8+Bf9rzxDg0VXxn/i52GJGNu+Kxy+jdtnOGwUUVroyYK3xdLFfLlig0CsmVA3hgdxW4yFgsLab5h4D7J4CQjsfFQUh0mmw5jSRW95WuuDH3i7oJjN+vKE5ZPus9hQ9PQypDIoD7GD5vvTUsVNitLOQ1w2RyOa0ywr1OWs6TFcbFA6djUImzhXa5bJCmwkZmgBcz1oggPo+RVG6y7dHaQZynfwrAI+G5MmeAzcnO03HoNPo7vp1JC69UhTc3jSLMTMMI2aaUj1HV
 i81COkPC
 obADL6sDycv8hgo1YrXn9wlvfThy5YQqvIAvZymf2bGK7EuPj9AlKbONndYI4M0QgbW+PCXFfFgtF0dm7BFHALOVJ/vcIJdt9gV7/Wtr4vTkk7eGdhorHeQdZSYJlMGnrZYFtNVafB03NV5K/TrEdbaMAGi0N1tTVsVZ1Atg+kpGFVyclbVnT86ri0o4bPY4L7yUwRbOuMQwl5e5/aHl/jfev5WrJeL4Ogk21WmcVTRO3P2hB4YcncGx4SxohpSW/mmvH1jswr36h190KzfEr1v+NAczfwC6NtWhZR8xFhfhAI3BEvjIXOauF8tl1YRDxTXt077xU0FoSOXNyhyhISzuGpO1G4nMGMJ/l
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 07:08:49PM -0700, Usama Arif wrote:
> change_pmd_range() splits a huge PMD when mprotect() targets a sub-PMD
> range or when VMA flags require per-PTE protection bits that can't be
> represented at PMD granularity.
> 
> If pte_alloc_one() fails inside __split_huge_pmd(), the huge PMD remains
> intact. Without this change, change_pte_range() would return -EAGAIN
> because pte_offset_map_lock() returns NULL for a huge PMD, sending the
> code back to the 'again' label to retry the split—without ever calling
> cond_resched().
> 
> Now that __split_huge_pmd() returns an error code, handle it explicitly:
> yield the CPU with cond_resched() and retry via goto again, giving other
> tasks a chance to free memory.
> 
> Trying to return an error all the way to change_protection_range would
> not work as it would leave a memory range with new protections, and
> others unchanged, with no easy way to roll back the already modified
> entries (and previous splits). __split_huge_pmd only requires an
> order-0 allocation and is extremely unlikely to fail.

I think this is wrong approach. We need to split page tables upfront
before going into depth of change_protection() and doing irreversible
changes.

Conceptually, it should be similar to vma_adjust_trans_huge() in vma
split/merge paths.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

