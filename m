Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E312CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 00:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5446B0096; Thu, 21 May 2026 20:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3661F6B0098; Thu, 21 May 2026 20:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255A16B0099; Thu, 21 May 2026 20:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0D97B6B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:48:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE3E2C2B5B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:48:39 +0000 (UTC)
X-FDA: 84793220358.14.7EB47AB
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf30.hostedemail.com (Postfix) with ESMTP id CFA1580002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:48:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="j/GazFy/";
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779410917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AUuo4Wsm5kupCrQA3m4DdC09avG22p4BEbUBdKbxJRo=;
	b=FoVOuHXLGhR/Tlr0q8icEL2zwWsGCai/V6yUtmndxIedAStKj5LAgi3UtKp14HkBxKJnNT
	JNc4coQWbaEqcNfraWffrQeX9QR755r7gMdKnrJtSUZm/7yYAanwq86BM4/icBYoOw8aim
	hZRLzRQM29n5oO98Yr9X5+kzrfojQUc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="j/GazFy/";
	spf=pass (imf30.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779410917; a=rsa-sha256;
	cv=none;
	b=HSp8J5XQIOxIC9eiaB6pjYzpxK0i4E0lli1Mq42f3Gp0CGhy2zOWewLfbxiMZE4bk9pMPx
	JBCBChOJfqCFic/ofAHJiCMFjJSC4EX8gLl7y+IhTLbc9pTIKuMzMzvg/NQlDYcEAY1exh
	RJ+X5eYCTK4MvPBV6VwpJveKkVyVgfU=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8b74b460d77so89939766d6.3
        for <linux-mm@kvack.org>; Thu, 21 May 2026 17:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779410917; x=1780015717; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AUuo4Wsm5kupCrQA3m4DdC09avG22p4BEbUBdKbxJRo=;
        b=j/GazFy/GzkTh0zwfsgFa+nJapWpluRK1draHymn9e00Z3Xnygt1l7F299/e4k2gON
         rA2oUqpy5D6J42HQQOOt1Tn1gRraNzRFfMegGuPpb1/xEuZXpQIArmHZLkOmkB9x2RI5
         qd0n8Omn6FPxb4rTHy/Mne7GUefuFiRBZIK9yE2Ij1I2B/ZC9s0bvjvZlYwSHXLNUQ6E
         Hmn0ZSvrCAR6w5ixRSt1ZCcyjsQVysqkXmEwLJccdM/tofddCqxhCQL7chkRKYn9Yf0b
         rgbZMKZBp9Ok7+07nhJpt3s9k4QqZHYcuZGw0jRsqnDAAwYtJtgUNiW3DUl+LcXrdPsS
         xKQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779410917; x=1780015717;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AUuo4Wsm5kupCrQA3m4DdC09avG22p4BEbUBdKbxJRo=;
        b=VsxrP6BD+ZmTLdTs5TMmOiTUG9iV+yCQknUgwjJRpZS2T1tgtgpVmB7Bod/q69Z1ra
         OZjSRLInRH8r+8Z6MV1X8p7gxWhYNIwiW+mBe2Jz852Vuz3JDKF6HadCSLuaAZtzLcwO
         tuHezGBL6YLDq9t0zF1urXl5d0WmBu78Aq0Nye/y3ZuDB+KXCj9iHwbIMdLHcHNlFKtm
         zVSQfRSSsEbq5jrsB8sPHoewK7pqFPLSWj3F13sg2f6ZouXQPNPOFXnZSN0gInjgQe+8
         +Xkr3TPVD4g12v9mioc2AYEBa7pA3S1eNULgz87FsGlKh2/R/nTEdLpEFGlzLdHLv+Yy
         22QQ==
X-Forwarded-Encrypted: i=1; AFNElJ8gribxzI7jznjh6ZfVOcEmY0gXPQo0lKMn2FkxPFJManqlj6ILgSbvSVwW1G+2hAuwG8X9ipR3yw==@kvack.org
X-Gm-Message-State: AOJu0YwbTk3akeJdYI7YtAC2TbKIv03xDQd1g+1LVk22FSdV62p7P4a0
	hWtBqXszLgTT0+Bbcs8K+EiaeMJRzTUBxCwS2Bxq/egbBi3f6gdB2/So8kvWI11sSuk=
X-Gm-Gg: Acq92OEqxz1lTkTNYRNhJ0UDgQOYVAd7TlKxh0OTV6Ki9Q+cMNli7njWh63jfMLy7QF
	7J3T3GkMq6fEtN+j3xggpVKrSfUndFzdgVLXhlpR0XU2cF5NpkxLyqcnbLd/IAQgKxBkPWdDJQJ
	vXdARXeVwuLBRFzYZ2cfvX2hhZLYWdfoeaGvn1hhj7Bck8U3K4HT8SKWGu1u8WB4MFVu9iNYaJ3
	RK5gIuamS1V69PUxfxyhrZYSBk4aup5Wb/HhCS5xGmR/fhnN1LclWVbMWtwAlVPp2zdYnIepkS1
	2Wq7Gc8Lox8sBw4JEE1rSigf54zbCX7RQEYT2Jt47B6jeV8rssixDYqRiLR4qbsnjkt4GuwjYQh
	UOIZQTzjkPHVGrkE15dw3rfsmlLxm6dEQl00dCy+hVzfFkIWDQOzNxBbpbbocUhd04YIRkfhPFM
	WTFQk5sA9Kfhhgr2EnUeJG74PNGfwugOPStGNV6Id5tyrgqnP1i8Q=
X-Received: by 2002:a05:6214:3204:b0:8cc:3546:2612 with SMTP id 6a1803df08f44-8cc7b55066fmr31946416d6.14.1779410916844;
        Thu, 21 May 2026 17:48:36 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc81316e4esm3013256d6.41.2026.05.21.17.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 17:48:36 -0700 (PDT)
Date: Fri, 22 May 2026 00:48:35 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/12] memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
Message-ID: <ag-a4ru9bMkDMthO@plex>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-10-pratyush@kernel.org>
 <agHGOxSnP_VraH1M@kernel.org>
 <2vxzecjhc2s8.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzecjhc2s8.fsf@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CFA1580002
X-Rspam-User: 
X-Stat-Signature: e3c3txp14m1qfsb3bonusmnaxmurmjmn
X-HE-Tag: 1779410917-589714
X-HE-Meta: U2FsdGVkX1/r+vrqsfHNvjhjq3q9x1HMu0y9mBFlR8Z7lDjYJ+Oq27KM2cwZCBJWkCk6HCnMjp66cyk70I08klLkDRhfVIoub3As5exOVWbG4sK6tty3HyiRtYLft7KRHcvALV81to/uzc+4KU/CkRyYZEwRmaBTcfAclaPaQBx6WwVNquhLawgDLgHCgyfGwfkN2OjkmG3stdtAxDf3+FzXE0RGQm4KnQXXvuTY3ueLEAvVa8cVA7d6cEkqUASoaoutA1vSJT+Dk3Sy/38OZZ6qcGAeM5hSgvQmddMqzQic5gYhQcAVAMCY9v4yBC7bQxWKwAoyelB91ymYVeFw3TmRoKGiwaaXzUwY9etm1O11iXNXkFxc5O7KgnCAezvoAe20c9RZYRuw0Ny+MGh8on7Pyjaee4/6YNjptP9UyUqElDXb/h5ngI90+daoz+Zk4L0nc5rQbvwiLsYcrek2JRPuZ1IW5NMrLTBUyTroEmD/93C1kA6ThSQBvHyCchewN/nSL2rNfwPVLOojl+sMJfJ8g3Spl9+XK2eKtAl1TLwZ0VR0yaNKCj0rqDSGFudZSDQCFivVqp//ualpxfdk4PbR0vH2fJYMn2gfP8P9Se7sRIJW/qzNk53SH2ffExPPHYSgIxUfeXpV4DsiLu7vDnNLxWngvNUlyBKgLl6OVT2E81NN3rjAOWU7OYG/8oA6nUhXiKi4U6Zf9a7y0rRH6Js1cvnFZu3A96lKP0sP3HJM+6JfA4+Wrwn8GEH5uF8ko/zanD8eSt8Xon5G8ZuVj/aWG6Z92aSjGsQdWR9J8C4lOC3Gi8Pl3Rs1CbGK56wxU8J1aCKqn68XkpRSebAVC5NdyDdbRtzFatcQLOCmkXxpL6guXqr5FrIN9N2f/snu8fFbGfin3GLf9OoWClNqgjrhk475n3VIHDsU28/h0NoqXpPevpZu3/iGEroNw54n+6NXqLDMjQWAL3Vt2Sz
 DCFz6baQ
 APT20WkRSimohtbqL+tiTkRIG4SwCYbQDiGhey5WuopWCSBk1ofqL3Hf2HJ/0HBlxNbn2+Kvlrf+3AMDyB2yp3DW/YiwB2gbzlWcZNaCpZBq9xDtzRMDOAVNVtJmgImKccZJEJU18d4+5vk8oEop/tephW1Bw2XkjYsJpE5ycwdANEBlzh9s436BG/TPtPkM4/C7FdMSHqW7Y4Ov3Aid0NOBm42OUG8b9qNmPHZCmif3FkEwqHvqFCP2PGlffTU9jMd87DV8sOjWUyDYdFYOBvSk42Tr03naU5rljyCmjqLqnu0NaUB5Kf0CDA38MqanzHOygsfltyOe0ypQW5CgNDctT4GouGDCTUcB+wsZ+K6AZq7c54ETGhBkY1EIsL8PuOw47
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05-11 18:46, Pratyush Yadav wrote:
> On Mon, May 11 2026, Mike Rapoport wrote:
> 
> > On Wed, Apr 29, 2026 at 03:39:11PM +0200, Pratyush Yadav wrote:
> >> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> >> 
> >> In the upcoming commits, the KHO will learn how to discover free blocks
> >> of memory by walking the KHO radix tree. It will then mark those regions
> >> as scratch to allow memory allocation in case scratch runs low.
> >> 
> >> To differentiate the extended scratch areas from the main scratch areas,
> >> introduce MEMBLOCK_KHO_SCRATCH_EXT. Use it when choosing memblock flags
> >> for allocations during scratch-only. Teach should_skip_region() to check
> >> for both flags before deciding if the region should be skipped.
> >
> > Why there's a need to differentiate SCRATCH and SCRATCH_EXT?
> > SCRATCH (I still hate the name) means "memory memblock can safely use for

 +1000

I also strongly dislike this name and mentioned it in another thread
earlier today.

If we ever decide to s/scratch/something-else/ globally, that should be a
separate cleanup effort. However, since we are introducing a brand new flag
here, we can discuss a better name for the _ext portion to avoid overloading
the "scratch" concept.

> > the allocations". Initially this memory comes from the reservations in the
> > first kernel, but if the second kernel can find more memory to extend it,
> > why that additional memory should be treated differently? 
> 
> Two reasons:
> 
> 1. We mark SCRATCH as MIGRATE_CMA. We don't want to do that for
>    SCRATCH_EXT since this memory can be used for non-movable
>    allocations.
> 
> 2. Gigantic (1G) huge pages can not be allocated from scratch. They can
>    be preserved memory and thus should not be allocated from SCRATCH.
>    See patch 12 that does allocations for gigantic huge pages only from
>    SCRATCH_EXT.
> 
> I will add this in the commit message for the next version.
> 
> Naming is hard, so if you have any better names I'm all ears :-)

IMO, this scratch_ext is not "scratch" in the traditional KHO sense at all.
The traditional KHO scratch is what is passed from kernel to kernel and is
guaranteed to contain zero preserved memory. This new memory is not passed
from kernel to kernel and can contain preserved memory at runtime. It's
essentially just memory that we identify as currently unpreserved and release
early to the system.

If we want to keep the naming aligned with the existing codebase for now:
MEMBLOCK_KHO_SCRATCH      -> original scratch
MEMBLOCK_KHO_UNPRESERVED  -> for the new memory (instead of SCRATCH_EXT)

Alternatively, if we do want to tackle the global rename of "scratch" later:
MEMBLOCK_KHO_BOOTSTRAP    -> for the original scratch
MEMBLOCK_KHO_UNPRESERVED  -> for this new dynamic memory

What do you think?

Pasha

> 
> >
> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> >> ---
> >> 
> >> Notes:
> >>     Checkpatch complains about no space after MEMBLOCK_KHO_SCRATCH_EXT in
> >>     the declaration, but doing so makes it nicely align with all the other
> >>     numbers. Mike, if you'd like I can add some whitespace.
> >> 
> >>  include/linux/memblock.h | 10 ++++++++++
> >>  mm/memblock.c            | 41 ++++++++++++++++++++++++++++++++++------
> >>  2 files changed, 45 insertions(+), 6 deletions(-)
> 
> -- 
> Regards,
> Pratyush Yadav

