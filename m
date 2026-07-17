Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81729C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 19:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17D326B00DA; Fri, 17 Jul 2026 15:29:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 154EB6B00DE; Fri, 17 Jul 2026 15:29:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091C46B00E0; Fri, 17 Jul 2026 15:29:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C82C86B00DA
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 15:29:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 412B01C0198
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:29:13 +0000 (UTC)
X-FDA: 84999256986.22.FC3E050
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E3BAD80005
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:29:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RBUssh5E;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784316551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ui+ORj1/z8nhcz2rVBcwlFO5TeUDA1QRckff/Axxhfc=;
	b=saqKycEdYoAFW6j3R0LbN25kUHbqWJqluIghROaPIGQRLwIY3xMajXDZyQu0YRk8PaSAw9
	Pf+NfBEZ5EjzE/sVSAXBDp34Px8eX4v04MPcLMskTHtaMliN4JDNX0ZZDyTc1ifKpk0fmT
	5K9x5Tg8QyMWNKu/PBtjqHkbTLrVgqE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RBUssh5E;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784316551;
	b=3xwltjmJe0Dx2+OqZVUhVaHyzCEjxx8LCmmL7+l6UYKfFWriwhgKi2v+8E6ij4nMFbvUFY
	BUb8yKk2/66E4YunCQPyiw03OZ/LICuJX1i+bnuK1pidx3rBtKzjGla6VmOIb+jjAWqSpt
	U5a8u7LshP8AJalkY87fokKTcw7/+LU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30B99600DA;
	Fri, 17 Jul 2026 19:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF5171F000E9;
	Fri, 17 Jul 2026 19:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784316549;
	bh=ui+ORj1/z8nhcz2rVBcwlFO5TeUDA1QRckff/Axxhfc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=RBUssh5EaLehERy4Cgi0QGmJnAOAqgTzVfUX3zA0MRCL/hp/gU1KuyrB1kS6Q7wSc
	 3CuE6RDTXx/8Yl95lAMi7m9NoXKXnJyX7bcJPQVkywGVvyBnHKTn7ZcFYO3itBGKP1
	 rCb1/Gdr+DbERUhJfZim7lwhNLXLpKzROb62w/uo=
Date: Fri, 17 Jul 2026 12:29:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, Mike
 Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, Uladzislau
 Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Peter
 Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@kernel.org>, Ingo
 Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Dev Jain
 <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>, David Carlier
 <devnexen@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "Denis V. Lunev"
 <den@virtuozzo.com>, stable@vger.kernel.org,
 syzbot+fd95a72470f5a44e464c@syzkaller.appspotmail.com
Subject: Re: [PATCH mm-hotfixes v5 0/5] mm: fix UAF caused by race between
 ptdump and vmap pgtable freeing
Message-Id: <20260717122908.3d9f4a8ad76a748d859b43f2@linux-foundation.org>
In-Reply-To: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
References: <20260717-series-vmap-race-fix-v5-0-606a0ac6d3e5@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E3BAD80005
X-Stat-Signature: kn33f9qpe55fmaxxh6s5gs898qh7ntiy
X-HE-Tag: 1784316550-526456
X-HE-Meta: U2FsdGVkX19NdvOYlg3/tklsyeMzKNtAyBRY1GHCQG+NPaDN17Mp/B6zhKAwMlOdykOGpkC+eslU/M8HwmDM3HWInAmeS7XTUqcLkW4J6ZGF/tPTJ7GOyPHjnHarrqA3uRlfhxa3k8N0C4CWAKIkToJ1eKhyjZ0HjVt7l2tJYGtDUmSznW54DQqDDs5DW6ixyE9yxxPgV2hKtREGL8unwmME5tK1M12gsOGDJPWkN536+hWPlc37e1i+ivZyMM1aJoCf/kaPZHtQzAKn65ypNoY50c9gdOSNtxDCAcdrgtE5Z1UeOYaQwo4DKE7QzZCuXfbg69nSCp1nasqDVOj4GXQvQMntv+xmllCQXMZCqeTK1dT3WMMZ8rVhMtc2fRKf3EwYBGzqatfMaMwdOGErKykw6dlUi1f7qwf88zw9tc8I7/Vbs+86R1tj5T+GJ1bWD4cPkvXvhoYVV9pjC4aDSrwCSu8a+n2a2YZRN+MlfjfEFWFfxpnpRkNM2aq/o4hYUCvPc3FDgkD94GGZKonP7HqxApxTCqSBn2E588SpEkiN34C0e6aUVFQjCXmg4NT2US2E9gaFqlKK8ewkSknhYVH5J+iskrb9uFD+ld/cC5WC37N/lFOD2xgfpTJdzWNdBqUO1rSsrHpX6ZgtEWlH7n3OTp4vvaKwaqGbADpb/vkhB3b080coFhqO4fYByAbT4ub/2slEqVJicIqP4IMNv4YBDifWV8wXYcqpRWOS/hgrg9ThN7jyme6LIOX1QINvWZxz+pXvX2h6BLft5NlWVV5eZ0NGL83GdoICj2z5/5J8PrtNeRL4Hnh+lDXlCP8OOw1fz1mY3X+w+eGzarQMMZ1qyGLVyiLd1L0vyRpgaHzx5o8P+ggJTsvlmYcePEqylbrdj3hwnA2lhj/CypzVeyFWoSzQ+sfg1PVWJWmT3RE2ottKwLv0geIk8tdtWh3LIYLBFDKzePGIsZxsxO7
 ipcJ/LeD
 d56gxVIJZT2hKD+bTuu7/aXWVAlMzv+8quoBc8eSQVHbafocawdQ8gAvyZTND5hRu+LF7egAF9dxRUEgO2ivswYbgJVLalfz7QQLM8jUkYLx1c28gDnAb+Y3tjS8Up4faBUwUK7QBRl6AyG87wktqZaw9/3kIuX1VpV+hfJ2mv2w7DqMTa+9iRw2s0leQq0mIfAVRq/z/y9dsbPvYFUyWjtcEwGytOoO3Q92driAgL7NH40LV/c6XET1pOqSP9yHrwDQ2xZ5wCB1p/AuiTQeQU8qVJtmpJ3IfuWeKQeozeLLFYbpM+yygMs61I3ZlyTCQ6eQAxIvdtAWbXLf7vqjUDYgMX/QiBo92MxNQbbPdimzyRf+rKQ7pXx7wTy7+JfsLbvxMtUGLKVBEu514W9troi/XYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 18:30:06 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Kernel page table walkers fall into two broad categories - those ranges
> where no exclusion is required via walk_kernel_page_table_range_lockless()
> and those where exclusion is required via walk_kernel_page_table_range()
> or walk_page_range_debug().
> 
> The former category is used only by arm64 arch code operating on ranges it
> both wholly owns and does not concurrently write.
> 
> The latter category consists of kernel page table walkers operating on
> ranges that are wholly owned (but which need exclusion against concurrent
> writers).
> 
> The lock used for exclusion is the mmap lock, and for kernel ranges this
> the mmap lock on init_mm.
> 
> ptdump is a special case being both the only user of
> walk_page_range_debug(), and the only case in which it walks ranges it does
> not own.
> 
> This presents a problem, as page tables may be freed under ptdump. And
> indeed there is a use-after-free bug in the kernel as a result, which this
> series addresses.
> 
> ...
>
> This series works around this by #ifndef CONFIG_ARM64'ing the mmap read
> lock in vmap logic, then partially reverting commit fa93b45fd397 ("arm64:
> Enable vmalloc-huge with ptdump"), keeping the enablement of huge vmap
> support, and removing the ifdeffery with the partial revert patch.
> 

Thanks, I updated mm-hotfixes-unstable to this version.

> v5:
> * Rebased on latest master of Linus's tree.
> * Accumulated tags, thanks everybody!
> * Added additional commit to fix race between CPA collapse/attribute set.
> * Slight commit message tweaks.

Here's how v5 altered mm.git.  This is from the addition of [3/5] - no
other patches changed.


 arch/x86/mm/pat/set_memory.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/mm/pat/set_memory.c~b
+++ a/arch/x86/mm/pat/set_memory.c
@@ -2122,7 +2122,9 @@ static int change_page_attr_set_clr(unsi
 	cpa.curpage = 0;
 	cpa.force_split = force_split;
 
-	ret = __change_page_attr_set_clr(&cpa, 1);
+	/* Avoid race with concurrent CPA collapse. */
+	scoped_guard(mmap_read_lock, &init_mm)
+		ret = __change_page_attr_set_clr(&cpa, 1);
 
 	/*
 	 * Check whether we really changed something:
_


