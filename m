Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EFD6C43458
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 10:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4916B0005; Sun, 12 Jul 2026 06:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365B46B009B; Sun, 12 Jul 2026 06:46:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27DD36B009D; Sun, 12 Jul 2026 06:46:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02FF16B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 06:46:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6759392722
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:46:47 +0000 (UTC)
X-FDA: 84979796454.08.6F2BBC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CEF7840007
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:46:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PKTQ6vWX;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783853205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IOUDvUEy6TKOQq0Pr9YmzerkWeQFM6q4kLvyq82Q8as=;
	b=xwMTWV5KBYL5p7IOcUaKit9DH0y+P0HwzlBkFCuG8/GjzQkNXnMxCI8mtShsOiqqlaDRmh
	Bk8xN/Oja9czx3+waNHHhRdzjtbhu9LT3rDmd+WI6upAxuaf7gsnuw58TnbZyQDc4VyrJr
	AGepLPEt50urny9eB6spv+uFkG7jcMY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PKTQ6vWX;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783853205;
	b=oWfaVFyH1pm6it0q9Q7NwHPhVG3FhOWeKUyLH5x4fvPVU0Ts/I3jLu5122RZftWYQaybPt
	znXOQL4Bzj+059OT9XPyLfy417jTBwAKcJ8DYTbdsJq7yJysCVJxgectdWcZ/THzfDfljV
	bhtHQvQo9KthUdHwfxXejog+WV4OYp8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 173F9405C4;
	Sun, 12 Jul 2026 10:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9671F000E9;
	Sun, 12 Jul 2026 10:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783853205;
	bh=IOUDvUEy6TKOQq0Pr9YmzerkWeQFM6q4kLvyq82Q8as=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PKTQ6vWXX63l864cAkgQJT1N7/Kyzos1q+xOsJJWgJcP33PxRcUUaQilhxJIIuNVP
	 uLRI5TjlTGyTKaIYAcZAkmJ/Nqw6H1rGLFCZtVfjox2s4ML5vrToRtpAXbyrBm5x1x
	 HXYWhZcw7qmFabZ6IXVl+5UjUKDprf1XzKFdoBEExm7an3lyYxiLSL7ZHbledfUkk+
	 DpmSmW/nL09o21U05djkTJcLO1r7w3jNWcA+4kAWGYU5mxmblc2j1XeHQHw9O5g0zI
	 CravUsr9bcF38MZz/twHZNpG1+pDnjOBgQthLv48XiiG9FuFKa/gVii3M2hXkreG87
	 TVdR/fXbkO4lA==
Date: Sun, 12 Jul 2026 11:46:30 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>, Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/mm/pat: acquire mmap lock on page table free to
 avoid ptdump UAF
Message-ID: <alNwO-lnRDsWPrB6@lucifer>
References: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CEF7840007
X-Stat-Signature: a51smpxmnyjdd669r43rti185fgnq11g
X-HE-Tag: 1783853205-306847
X-HE-Meta: U2FsdGVkX1/P4sOjPqTF6GOzk8dHALEgzaBt3WhWx4xuH6Zy59tuWEXbTDUTop/4zh0QiMga/XBJx982rU+oHnZc42Rvo2kABxlDPJhMKqaDn5JOgKXknM+nL3iB6uq8CjNL/DwUA7K8EH/i7oBZih8YC8e+xhbTkRu4ogpVAG/1vVVPe4FSxtGhjy2PGf+ZtjTLP2vBj1fIypztLaspPtoon7IS0dYnfwV367yMK3ZhhWshZLFBq+AGebnKKLmZ/G5+HbXLLxU19HLmdh0dcljc8A5XU0Cs/VY0YUIr63TaQitzc+jzJ0LCjg8F+8J21tBpmGYsyhW8QS20dO7lafUrgT36G5+tBF+KTUWt60EH/8lREQJ18Axuxk6q2+kHUbM/mQGjY4X3XHZTkEGzJytZSYotgL0/I+X7ondFCqemXpl4Z9MCA5TXdn1ytHsN0ZVZ0GOOWmpo0oXw9aN70OiXe3qek9dcJ9cJiUolMMVN5HfXInLtvr91r48v4FpazZwW75LwupTrHs6cjF7+X+hkSu/plNc8cof/nzKm+C4Nbrj9LRy2kzuO4zNT0tDfjnYrbtMfI3DnsclUmKU6D+4ktTfiCBpEGCVvhtd9nH9p/ZMhPxAdSKz9Fw17U8Gm66IOkFOlTUqE1ET4UlT4nV949WugRPQx77FQyGtTLTjchS3VCDH0F6F49FZt4dXbweWFXm9HOJJWH2diMvt5XKiZz43ptc/SQXE2pA0tVxZYWCGyofx+VsLU3JRSA4AghnFw8z6UOvrzkF0T4ayJGZLF6uTfZZArpJgc797OoKZkXcQnELA+ScCUjK9JVAwRlhKyJ+3JA99857LtblpNgW11c0kRSuuCNI9lF22Tm64AaOK248fAAIBj4ILRMULtv//VMdYO7Am9mXiXmZ3lKvq7nYNn7s45fqN/JZgKWl9SLP1a+uBPdu8Ajp5Hwbq+rBvY+ijJU9hh/aMJohf
 IIb2fbrc
 LScmre3zmr1EutBak+KuxlxBDaH4yESqzSH/GnKoiClKXma/xnUiNrPdc36CTYDLJ6+JZww47m9MRtlQqOsqWVQ4vmRespIqis7CnZChU+OLgrIOKQRFGXoTyTumehtDYBoE0hi0oe8tj4Pl7/Ib5LAXaBECDsGoAvEMLEkXTFtxcLinn5XDBtrSdO6rMysoKVkzYSrAOm2K3NjeT3IRnVQRrgcc7dKDtSRbPhXYV3vJsvEYBxMVx6shEAVZD5y04vDUAFLVDgmHWP8i/Ac+eztP+jR9PVV5Ks0f0I2Mo93ycGOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

FYI please don't take this patch as it's been superceded by a v2 in the series
[0].

In the end agree with Mike that it's just simpler to keep everything together as
one :)

Cheers, Lorenzo

[0]:https://lore.kernel.org/all/20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org/

