Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3B55CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:40:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48546B0088; Thu, 18 Jun 2026 12:40:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8B26B008A; Thu, 18 Jun 2026 12:40:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8A86B008C; Thu, 18 Jun 2026 12:40:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 65E0D6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:40:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E751CA01B1
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:40:56 +0000 (UTC)
X-FDA: 84893597712.12.A726F0B
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0EE07A0005
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:40:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YRN/MCBg";
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781800855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xeiijMLpLKaaOkBdp35eM6zjfD+uzItWtXaFrZwEr/A=;
	b=kuaAXlm0eQlbex7VRjfrepTU4v+vgRp4YetsI690ESj8Vx9L4pLHvP7SoD52rB8wZqdSMC
	VILwdVM6h8obzUUC4O8fFG+50UYQOe1B7xue1xsEcP9u7O439ppaIW1fQ2r4DD7afTy5Eh
	bboQW0NRIVxEs3yTqH9bKL/VqEodg4o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="YRN/MCBg";
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781800855;
	b=PFw6oWmaM5EjS5hQjJNWSqVwxbEV1ghJt7izN6+Qiw00wREDR/6KatbWZHun8yDCFMX6r1
	I449ALAb4FpjNpfzV0FdNgU3ct7ISOxrqBySUKLwy2aKPMNnfxWjCmlawJx16fyMAP1bCo
	BPweG5BwWDfoHStOAlw51kA+rgGpTN0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781800852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xeiijMLpLKaaOkBdp35eM6zjfD+uzItWtXaFrZwEr/A=;
	b=YRN/MCBgQjjjy+x0E2HVms6+4UopRfdKkRjbBBd6raI83Ir4b0lNXN6gwHsucVI50zBlsY
	ui/ezbdRaiIBRz5V6y5LEvG4vT8e2PVUVtQtOUToeND8UuUp6XHPPBr3J1Zvy0p3QgLzJM
	w4Ep695ahAYnUkrvERLu5oC9iUgO3Gc=
From: Usama Arif <usama.arif@linux.dev>
To: Rik van Riel <riel@surriel.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>,
	"Dmitry Ilvokhin" <d@ilvokhin.com>,
	"Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"David Hildenbrand" <david@kernel.org>,
	"Lorenzo Stoakes" <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	"Vlastimil Babka" <vbabka@kernel.org>,
	"Suren Baghdasaryan" <surenb@google.com>
Subject: Re: [PATCH 1/3] x86/mm: use READ_ONCE/WRITE_ONCE for mm->context.untag_mask
Date: Thu, 18 Jun 2026 09:40:42 -0700
Message-ID: <20260618164043.784764-1-usama.arif@linux.dev>
In-Reply-To: <20260616190300.1509639-2-riel@surriel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0EE07A0005
X-Rspam-User: 
X-Stat-Signature: 6e9pqm1pccr4a4qif1gzhzykjrrts1ck
X-HE-Tag: 1781800854-205940
X-HE-Meta: U2FsdGVkX19WH2wtR0Gf0YqIKVVaJ8jor2gXN53+khc8fQe+f0XFpMFmX4Qk6RsK+g+8904gepqDohYuUYZbNuy3yCh83FYC2afLCnG1V9Jof63BZohFN4GLV7sNFCKK/E48ZUZXRCOuM0OzzEAvUF+RUI+zgXfZA8dIE5eqYKW6CmdenvcR+doybUAug5iwlGrCTtgzSr7iTNilFTnxSyelPNuHGZTbOvFnBoxq1q/9cMloIfcymUEFDL1u2GZXzIMcHjFAQczl+F6IOksSvE9UzhrfyMbzXp3OsraqZeiZY29lurNPqekmTqIpvPqrWl+uupvDReZUdoHNXRRwrv0LrVWByFxvA0ZTix2xviHmJNkSpXVOta6KbTbmtPR4r8LnKJ6UM1e5Qmf0yYwjhl62AkALUygZ2bpyU/ShC9kvRuPRp7uMZKXmvg7f/Oeh6/AzGUccTslgxfxgl8CfUGyfXpB4EdVdIxwb2PpRo8uQTcHY9+axoBkGCQIDlswN1enasSpF2/UOC0N6FnqI0dTiVUFZkt0BayBlHw4KqJnTBAI/RiGq3NZ9cp/X1PizcFT/QNHVh/NeSgJW903+M/GITOXP7zOV44snPmE9LuGazTsiZTRzCKhMVkJTAywM7Et2UjK44YP6zkh35S2dt2Rmx+ilthBU3g6Vhv5k99sOBJoJhTrX4UySkXhL1YZZ9jJyvbTs+y9paR+nQjRcgWIlNX2IVPi/2ZNy4H+mlgZOUnQmLr3rHbXLelEe4k0hjX9jyXFv3bB/k+rQRBcGJ6W0yy5I5UQiUyFDxU5Q4U6HGk4jzKYJwQOtrpysnvpvncNrFTkdA7q9486kmKnE8s56Yn+x6ygvAGdpJiq9C1b+89imjEU1s0mOBcam0pYm5P4XAZwM5X0760uUseHLQaf1eaxM/EzQHXuxb5z1CKZSeZr2bxTsxr+DsFcAQj0ylOzNnGTs6B26UGWZIuf
 NJeWuV8x
 5yvr4WdxAK1kAozqq19bUrkWD8ULmpjva5Yplvu5kiRQPPDgQ41NbpAmEfp6XhYyaC5WbVGpfFhf8wxBPg39+OsR+TuRCQ7tyMaG36ZwT0M6/aM11IwIFUOg1lnGUatW56GdH0RkjRGWv5pInvRGd4O8G6aXoY1hf01D/f8siCVVj+ubeu+xM8ronraLG1jzdV/QQzFXAdY0aQ+Sj3+btW5AT8GVqRbPibvV9uf8WaLp33ytbPXVG158IZOYytepwoJZAzW1li8RnmEiA6yRXrNDR5VDykRSjy4UM+o3KcRn7l2XikWZUUgpWBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Jun 2026 15:02:58 -0400 Rik van Riel <riel@surriel.com> wrote:

> mm->context.untag_mask is written once, when LAM is enabled
> (mm_enable_lam(), under mmap_write_lock and while the process is still
> single-threaded), and is otherwise stable and never reverted.
> untagged_addr_remote() reads it for a remote mm, and the new
> untagged_addr_remote_unlocked() (used by the per-VMA-lock
> access_remote_vm() fast path) reads it without the mmap lock.
> 
> The field is a single aligned word and cannot tear, but annotate the
> reads and writes with READ_ONCE()/WRITE_ONCE() to make the lockless
> access explicit and keep the compiler from reloading or tearing it.
> 
> No functional change.
> 
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Rik van Riel <riel@surriel.com>
> ---
>  arch/x86/include/asm/mmu_context.h | 6 +++---
>  arch/x86/include/asm/uaccess_64.h  | 2 +-
>  arch/x86/kernel/process_64.c       | 2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)
> 

Acked-by: Usama Arif <usama.arif@linux.dev>
 

