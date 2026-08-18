Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12064C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 00:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE39B6B034E; Mon, 17 Aug 2026 20:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94A46B059F; Mon, 17 Aug 2026 20:51:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83806B0876; Mon, 17 Aug 2026 20:51:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4B186B034E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 20:51:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AF800A0969
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:51:03 +0000 (UTC)
X-FDA: 85112560806.04.DD4BA3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1F3F320006
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 00:51:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOIy4XAt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787014262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HAo3mj35bMKVyA+WQx6ie7qsjBC0OY0XZUzTIFcDYRY=;
	b=DFU0FkmSytfOZolq6Oqs5PyKh81lK+oXYD/q5WBr9r+aPV2Op/DV4nDWEBivR84MG9Ddsu
	UAA19jjNl815wQaIMTA6vpggrj1DfuHzeydfFNYsYZpH0+y1g459EOewLbQ+J+p/KS/Cvt
	lulz+o/rx1ZtGf2a9UtPVwQi69YOgQA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOIy4XAt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787014262;
	b=LL8P7PVtVX/sjdZ2xPmZxNyNYLOPhBasd6OOazJiRnZ4ISjKlA/0BP3kLl/M1rfp+b0ObW
	KIRg8WSbUQXXWHLBfGPu2JXcrl8yCeUHaYpMHc2btzr445em+mxc7ft+lD8VFz6l+pvPiL
	v6348Q31bK+KapMX/nu6q0OZOa+77eU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98F10600C8;
	Tue, 18 Aug 2026 00:51:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6581F1F000E9;
	Tue, 18 Aug 2026 00:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787014261;
	bh=HAo3mj35bMKVyA+WQx6ie7qsjBC0OY0XZUzTIFcDYRY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mOIy4XAtMF1EaYAtHJCzs8bkHOds93qkjM8FrgqHH+bkltBN3F8NEy0QTaeRmv6mL
	 bXU5yX4rosIcHXDE/7zm+5neHzf0gBAE+uwP8Gc7wMUrLFZoBsIhK6ECzTLnvf0qCB
	 naqX8EMciR1iY6WOwkJPDZYE0D/bSJP8r3xM3P01F8cE3dunjN4iSKDX/bI0TltfNp
	 xA6c0b9L7FDBcnKbBnUWMpTYsyF0D/QhTSh4gZuM7PcluFs2SMK/HhkhFPib8vPSKz
	 6nB4KYgvx7e+866hDsbKVMKoQWTdqOZgmHj3HSGxS6tgWF6ITxS495eXqiQ9wLlHh/
	 wp1Ad1RA5qfuw==
Date: Tue, 18 Aug 2026 00:50:59 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	Sumit Garg <sumit.garg@oss.qualcomm.com>, Will Deacon <will@kernel.org>, rientjes@google.com, 
	patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>, 
	Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>, 
	Thomas Gleixner <tglx@kernel.org>, Patrick Bellasi <derkling@google.com>, 
	Reiji Watanabe <reijiw@google.com>, Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v3 21/26] mm/page_alloc: implement FREETYPE_UNMAPPED
 allocations
Message-ID: <aoOsKZ8JorqyE7aw@google.com>
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
 <20260726-page_alloc-unmapped-v3-21-6f5729aa9832@google.com>
 <CAO9r8zODy9UCrtJuU5_SuiZDUbg4dUYLhOyOwZtD-U0N0tpCsA@mail.gmail.com>
 <DKPL8Q39R5JD.2OY4LAGZ84XTG@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKPL8Q39R5JD.2OY4LAGZ84XTG@linux.dev>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1F3F320006
X-Rspamd-Server: rspam07
X-Stat-Signature: trp4cbkfc5ngjwyfem3q3rniqtp3kd6c
X-HE-Tag: 1787014261-327402
X-HE-Meta: U2FsdGVkX1/0RoqWwqojjS/2m18PT0uF8DpYr7XfCCF/hUS7K8g4VRI4gks7dLqCp7HgoDpJHoEWl5MB/P66msvdEAtSffKkpsTUSnhfBzylB3kVRjUsi18hkA6xzw8lydJ3A8/aByAPtVbepEAXXtc1tHmlJd4HEr78LwIluU6H4KHeHHdPsSvaw985eRWZbzNVMe+lw5L2gCOh9w9rXfBfZYa+BJC2uF8jBaC7fAzj5z9jmkAnVw+8xb8fKpPS04iZvTrCZTwb1Q7tTFKM1zIcODBzxbRY41yGT7rxAbWbqw2XlUgCFQVC4IsaHVnTwP9JfJtCue+BdQLYr6Xo4SoR84z40jenrD1qWMtBDRrL171bSoYcuHkyUTISnJqA49ueQBZRn/EdUoICssVMdt30hEHlnTw30HiDP3SF7WrvFjLUR7bgT8Hy4A//yjB7/qrZ1qFr/J/YxmP6N5yjsfjy4YrhhdjRT4Mfzv7crY2LTrfxDvY83T8Pa/jbUJao/RX3UCbxpHx4Jdl5TFigDjOrXyXax0rLZzBOu+9Ga2w9TIyrZC6iJrHQOMdoX1TD8oowgL1oTf9ZsOZyDnCLvd6F+urVxrtP7C/C72gSlfDN06Pv/YU5RpCcQl82ERzYINlUKMfZsjKJjOulaWRYOEvsaU93uzX5nDdiqPfdgx2+6FFJHKy4QKepfwYQA47bSW8mcCU27aB0qEMk3m5lcECXtW9PBWMIHHyDTf4J4y/uFUTCERnRtIGl1T0JS2/FMSUBw2XlEytiFP8xx+qj0D6xvrfNrLIxl2fe0jv+KCTPMDYhhPNG2CLkMgLgRA0eH6rOddGH/PMw7RHpoSLHyPr1TbN4jFGykSpurZAdXVeGCji1E5z+h1u1vU33/WRDaDPOEm5B3foV17BZjEkmg0O6gNxlhN/f4+DQnJleC9OuvJEvsU0C8RHOy5GWRrNGnetNHkLdJPwiqXx30Ls
 nfnBJZo9
 KGRF+niKibZbZUi59Wrtg3Hh1TIiKC8s3BhzhvDwU4A/pI1MxrQtsv9VdIHDoj85clJVS0vmP6tGzzReclGmWWVxdY3PJxBUXWwPVmvPzM5Ocn4Cu7Pdt10/E43wSgfOW+gRXoT3ePRkOwAAiCtSoBdaTttKcK6Oh/mDRxx2LK0DGlKe1t0K4GBvZwlu9i8POTSYFVkqQTnJDtw0/hdxQN0pigZYTZDv2tNKegzXKHVSvRF6iRIv3BcZsFiTxZjPnAuJESBBKCBR+Rh0mHhwdIloLdHfSmNIAxQUvegOFIQJrHyF5/922Ko9Llq15nRA+GGAvctIQNIRT+CQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 15, 2026 at 03:30:44PM +0100, Brendan Jackman wrote:
> On Fri Aug 7, 2026 at 1:16 AM BST, Yosry Ahmed wrote:
> >> diff --git a/mm/compaction.c b/mm/compaction.c
> >> index 67b01af024e17..c9eb3947ffc79 100644
> >> --- a/mm/compaction.c
> >> +++ b/mm/compaction.c
> >> @@ -1393,6 +1393,9 @@ static bool suitable_migration_source(struct compact_control *cc,
> >>         block_ft = get_pageblock_freetype(page);
> >>         block_mt = free_to_migratetype(block_ft);
> >>
> >> +       if (freetype_unmapped(get_pageblock_freetype(page)))
> >> +               return false;
> >> +
> >>         /*
> >>          * CMA pages can only be taken by ALLOC_CMA requests. For anybody
> >>          * else, vacating a CMA block consumes free pages the caller
> >> @@ -1444,6 +1447,9 @@ static bool suitable_migration_target(struct compact_control *cc,
> >>                         return false;
> >>         }
> >>
> >> +       if (freetype_unmapped(get_pageblock_freetype(page)))
> >> +               return false;
> >> +
> >
> > Do we also want to add safety checks in the page migration code? IIUC,
> > if we miss a check in the compaction code and try to compact an
> > unmapped pageblock the kernel will crash with a #PF in supervisor
> > mode.
> 
> Shrug, yeah I would certainly be happy with sprinkling some more
> 
> if (WARN_ON(freetype_unmapped(...)))
>   return -1;
> 
> here and there. But yeah this feels like a maintainer preference /
> philosophy question :D If the machine is gonna crash quite clearly
> anyway maybe it's not worth it, I dunno.

Hmm not necessarily crash? Right now if we do miss a check and end up
trying to migrate an unmapped page we will crash (we actually do, will
respond separately). If migration fails, I assume compaction will just
fail and we might end up with more reclaim or OOMs, but not necessarily
crash?

Migration is where we actually access memory, so having checks there to
avoid crashes (when possible) seems worthwhile.

> 
> >>         if (cc->ignore_block_suitable)
> >>                 return true;
> >>
> 

