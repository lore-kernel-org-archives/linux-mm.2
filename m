Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EE99606D819
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D4m0xrqi
Received: by kanga.kvack.org (Postfix)
	id C58976B05BC; Thu,  5 Nov 2026 05:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C097A6B05BD; Thu,  5 Nov 2026 05:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21746B05BE; Thu,  5 Nov 2026 05:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 93E4C6B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:12:29 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97F2DA86C2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:12:28 +0000 (UTC)
X-FDA: 85400650776.14.A675360
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id EA8134000B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:12:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4m0xrqi;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793873547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5tdVeohczQcF/1PA58PpWxIbAKDKZLhIvKE2pdtIyoQ=;
	b=A2d35en+jiptqH8WovKfVM/Vi+XVHk3wqGmU6HtLJwNYC2M6utnCgD88IL2JJLfyKj234M
	h5XTXX8SkaYp4HhTpghvJTwDGFtRuSFM1EGafAaEm3iNVLaq7sIEKqXVjYtdNRRvh35XOR
	7pd8WZ+hHl03EOPaqaLnaGK2/PHdGfs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D4m0xrqi;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793873547;
	b=YNQgV7uuSGxXMbB7/QheWVZzDjVv1m25QWxfvY/w2rek+MjsX8MpXJiCbJwTIsMZmIAYx8
	DZsWWhB1I0rm256yh5KBJYnIYjPIYSXcIUz4oi1ZVrTntYJJk0QjRfKb4LqGObog5A8nAI
	meczZXxYh6shJKnQBVdq/jBHrmVEL/8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 373C643906;
	Thu,  5 Nov 2026 10:12:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D294C1F000C1;
	Thu,  5 Nov 2026 10:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793873546;
	bh=5tdVeohczQcF/1PA58PpWxIbAKDKZLhIvKE2pdtIyoQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=D4m0xrqitxKnrWDpcPxFMNQayxHP7JZMlYZ5EK9L/FyD5VpbLSYYjCq4BowIrvgNf
	 vIIq6h66ZAUN9n/FZNSd4ZndLixv7mhA5o4biggzhTz+9B16KSzt+ufd7Pc8f/dCgl
	 CRqUdeiMbCFAx4rLH3tZW8n4EihPBVurj1FGAeDVXDuEN4KD/koqm90KifjEL2JJhd
	 M8+2qqQlDlePkUvBiwvZfWGk/FvmUz2dvjbDFT5Qows8yTTvnTw5V4bcBrMuu2Pnku
	 X3tW1kgC4CBsoYck8rH98jh8Mo8OQud0pYI8ilYKXl4rdKb25LjwmiaggxLtyjJC8V
	 3thUu9pBgaPxA==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Hui Zhu <hui.zhu@linux.dev>
Cc: Hui Zhu <zhuhui@kylinos.cn>, stable+noautosel@kernel.org
In-Reply-To: <20261104091050.117076-1-hui.zhu@linux.dev>
References: <20261104091050.117076-1-hui.zhu@linux.dev>
Subject: Re: [PATCH v4] mm/memory: use pmdp_get_lockless() for the pmd read
 in do_fault_around()
Message-Id: <179387354148.17709.689999444954400279.b4-ty@b4>
Date: Thu, 05 Nov 2026 11:12:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: 9dx3fu9qotkkr4f7objqwkpw9wcs3xd1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EA8134000B
X-HE-Tag: 1793873546-110866
X-HE-Meta: U2FsdGVkX1/3WBOlW4m1dDl2MOmSm0H8CrQDtAaiQTBPWjDNMb3LWU4FkI5h16bbXYzIfOptNOC/60mwXvpQAOUS2+lE77MLbeGwM1TNZNhtu39iLvoJ377gTw7YzxvwhLsUN5MDipa9Y9esjjK2zjy49U/RCecukUALM9X1KbZN2gIDRN+jK2T/Sa3qGJxGAFMY2Qdg2dTz7BUkcPg9MBjg5QOaEEamHte8AIMXJp7k+65fAsBa8Ehc263X4XEQoCHpN9/t+gkwrUKv5vnWCurhNOjMdW4wdAeymuhm116tshQT1HrcC6yikHn6E3JIC/lo8hnwUGNOb+3wt4YLLYNJZurPdqjFuCO2WSnLd6zwi+JEG3fa+lyb5yBhWCmDoUmSx1KEdm9Yyo1Es8quRzbLOGx43oDv/2id2TehqQLI4thB+BC5qSA+2JQqxQ7yj3QvEKI46iVjTesRH3cocDBB1Zq2oT37mgDAUFVpmG1X1x0F8GOF2rLTpY24oX3ZildHOpOLLBVhM8Z7QyLCvIQZmqlsg8pdkd92FOYHvoPaM2U0LOUBN3I5iV76dC976R9hKY/vp+JDtdax97P+kmZVA2TcAgjfbPtCH5jlTSvcIz0tgxq3sfrIGTS1vnPKNrN27iCftTfwkSHkLOsFq9pPNN75G3b/i4V40W4QJMpluLaN/FJ1G+o4hRXDBLXtkb0K7bucAVKHCeNGqph4aM06ft4cttw89vN9mSfaxKb6vfU26SO9CZUncXNlmCmcve4Zidko2dwG+UPZrng+m9B03qErv23voIH0MSsUFWwySAtr7nzFnzAbE8sIqJZ1vkocw9FqSnPDn8bHv0E7H1Lir4fQzP6UucrOR/Qas1bHhDoWxQ42jOL5JgxfS+u47u4vch3T1Drh7RXVcl30vbhY6wf9cY/IRn2UrD2eOX5rjR2bZXg2jHixqzSKXBvhIkoQ1fkwACN+iezZ0ya
 POQuFgTP
 rdtc56GqWlzhpXoQJhxv7XtMQR6u+/XDORIh18X/9BruJ78b6OtutuRcy/ps5Ff7IK0pACAU8fZxsafRIHHzq3wAq/WPh4ZcQcCkACIovjTKC2iiLOJQ/62ARbpp16PkSspMg54KxVxdQx3WrkZNqT90Wkp3eOuQtkGOCGo/ByUQTuFPA0yWteO/anybp+AC0xdTTp/zipEd+652k3p/7os9Ic2Qa+Rfjkc1FK3y8JPgsGT+kHPrt3uTfMA9x0PTBu/g+T6RyHIAOLFmmUByaplu1FKHbIY+u9lzpaiHT8JQDD9XPrjxD4Jxi94wB/Zh5pSeb9TEwkN0uCwNIQdcjVil+yZ0CDjsr8pLcMIbhTB/r8KIR80TcCrUSUmf4ryk+R61gMPW1hSKCCS7+Lt39oxdsFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 17:10:50 +0800, Hui Zhu wrote:
> KCSAN reports a data-race in do_read_fault / pmd_install; the same code
> is in mainline:
> 
>   write (marked) to 0xffff8d52a75fb810 of 8 bytes by task 27487 on cpu 5:
>    native_set_pmd arch/x86/include/asm/pgtable_64.h:83 [inline]
>    pmd_populate arch/x86/include/asm/pgalloc.h:84 [inline]
>    pmd_install+0xe0/0x120 mm/memory.c:444
>    finish_fault+0x5bc/0xb00 mm/memory.c:5204
>    do_cow_fault mm/memory.c:5432 [inline]
>    do_fault+0x5d0/0x6e0 mm/memory.c:5526
>    handle_mm_fault+0x211/0x4c0 mm/memory.c:6218
>    __mm_populate+0x144/0x270 mm/gup.c:2207
>    __do_sys_mlockall+0x2cd/0x380 mm/mlock.c:764
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/memory: use pmdp_get_lockless() for the pmd read in do_fault_around()
      https://git.kernel.org/mm/core/c/6ab55cfd

-- 
Cheers,

David


