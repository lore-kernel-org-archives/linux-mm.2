Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 677B9CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 17:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665E46B00B3; Wed,  3 Jun 2026 13:22:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D6F6B00B5; Wed,  3 Jun 2026 13:22:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553446B00B6; Wed,  3 Jun 2026 13:22:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 417026B00B3
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:22:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07EB51C0CCC
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:22:22 +0000 (UTC)
X-FDA: 84839270124.17.D4E66B5
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf01.hostedemail.com (Postfix) with ESMTP id C274140011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 17:22:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fWd4QVGS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780507339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QurlemtwF1MwjB3Mim+A5D9PlrrHZn+JXZYlsobwsxA=;
	b=EaBdK7zdTgEUIwNEPg51JwUNTSmWzOy1cKtRRrxS4YMyuLVLLmD8Za/+WlvXxO14Nk0ISe
	W4ziweA56VRh6J4tCe9omeZQt6tveGaNXfR1BP48+7hRa3eL8hjI/eou+jSHYmXZms7UX9
	/iVVj6MFzso+kYm1tszc4qetmIFojzU=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fWd4QVGS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780507339;
	b=GvirKBWxxYFnRtrV8WpQEd8S0hAuy8V1CrEld/zXEN0d6m0JIPV46/XptN/wjRg3eZdc0p
	aN2PTBVfmLx5Buvm7+RAZK6wNS7UzQGgcyBNILv/8glmYUgo1I1aCNgsv7FShUjZCJ1me8
	ZMYiXr2QaJJzGPfSGHJnuT04CTdz7L0=
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-45eecb8bf67so5118641f8f.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 10:22:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780507338; cv=none;
        d=google.com; s=arc-20240605;
        b=LZhmxLbjqdNKkR/xX9vn4/Y2FH8qjVSQjt4244e+FiMZuey//D+ohyG7Wga7yhGqaq
         s/u9HYqvUYmjj2I1CZefHwWyDnmBFfarUUa7kY9A1x/jZSRfwFlGIhHNwBIhhZEdLW8R
         M2/jLJqc07WY9DpkvgyytseAg7vWFaOGuyBBroUe2OorpdRVfwXwLb3WbjeSy984fUFK
         e7I0fgPI0gagJioRts3dUOIfQjAuZzm6RuefG2nDh6jLQUZdr0IXXLEIKw7my716F79c
         i86ORLfkcCb1a8ZYTcePMlJuQB9rjiRw18bgfPu5uyFtZY2TKgbZaKzUx9oe13KjvVDm
         +rYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QurlemtwF1MwjB3Mim+A5D9PlrrHZn+JXZYlsobwsxA=;
        fh=t1q99lnmahBJTYQ5/EvXl1YdUrmXFEGgZusSaEic+sU=;
        b=j96W60ZzLWxO/HrLotEAhwRBE1ePq6gwMpONRY6qAkYZljnoG0k27s0mMsHKiBPbVo
         u4tS2fXAivlyJNqXWgqFqcClyMzkb1Gr1wf/r+kOtMM8uwfM1PLTCJHieryZs++ycpy7
         BQm3HA3zjz9FxPh2H/dBkW/RoJPBFKm5KDkGzzdkdG3FJveGmCXZnucQ34QDAdKrY/ZE
         mVVIeJb5078js4EDyplTOMX2zmFdtrY7whTbp7qB0kpM3WrYHUXvPwlxl472pR7dmsIR
         uGM/S0X+ctPPAPn+h5WyVkynqeTgHU5kTHvRSMF5qL4Z6Khm5+omd6Z0QakPGOy5AWVK
         ORKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780507338; x=1781112138; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QurlemtwF1MwjB3Mim+A5D9PlrrHZn+JXZYlsobwsxA=;
        b=fWd4QVGStUMDOiy1K6wJRJN2F7uODtIr0uZlMRpIZl0su2fKq5Izj5lwSVVEpk3JNu
         EYwYJXNZ0rnMimVpVGdp4ehtZQrX6tue9nCHWZEG6P8DguBnFPyFjSM/BsrS43W6walt
         ePUsjVaQ/izWjfDHNBPgsxoH5HFT8ofQVzTbHBPbFAx2iL61LdNCBrBuRc9wEb07guDa
         IzyBHeeeXpF0RXCfKvNkmTC15AL3uLzbVNZhg8rmwtw9nPpB0KG5uj3g/j6l2NRC3gFd
         8J/hNAovPAejqeP0UAzzChgxWrUdchVw+u2gsE7eLvJmWceNv7rSEI3nR2F5YE0GR6zE
         S98A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780507338; x=1781112138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QurlemtwF1MwjB3Mim+A5D9PlrrHZn+JXZYlsobwsxA=;
        b=mSLbNXvq8cX9eGxspli5GRkolnNrNDoaJbFl/zlncdaX/MuswzBs3zggYqhlncGGpL
         LoQEFPUE32cIq3JCMzBMyqcOe/PNmxfG6aoL2kmpR0SGMss8zNycbOhyBZreQ0Z3XHBZ
         oAd2ws8mWnLnU4BMInBg/vI/3BOj4l44oI/xQ5ehGjaB3T4/1VT9XMSDDKOrHgR6MNaA
         8ZfY2qs9s81T0T5oY9M0U/XEDXM6IpbODrXWpziTqgNpMfUIt2JUYCiOpW+nBTile4vL
         LnYtWl8h5g9l7UdUSjHBJfvKwCdXbymQHvqo8Ehm1oKprGh3ST0c7wQbZj6y+E0T59CE
         xmLA==
X-Forwarded-Encrypted: i=1; AFNElJ+Cwv93qko0APkH1Cq1qKJjW0AczzqXJBEWFdQksMxfgrd/J7y98x3BFevC/YdEPoFBvezW3lR4dQ==@kvack.org
X-Gm-Message-State: AOJu0Yy78vXsxxd1FbV5DuEi+UdU8qzmOhOXqkpZE3kJrNegQxodEhe3
	5mnROXAIClAe9OBdbOzeQjacq3CJyET84FRNGEMCCR/u3hBTnSdDmGw0mqbVY+J9yOEq9jL/P8H
	7Zi0Nov5rplaB27cx8QLLCyudxG2LCIk=
X-Gm-Gg: Acq92OEDddrCH00prCvJbPz4/0bgcRsg3QYtketWTOV07oIqSbolDOXQAbqh6JrCu+p
	gR1bLnbXvlFUNhK1iaMvBRgp70b/9+q8fzApbF8Bu6YxeO+V8iSwTHgczq27vnK87LdVpY3Yvym
	irLxRlZxovs+xuvZsjQXMaYgwnzP8tZjIbAf//Y5G2hAitwZ0OCcqSDqEK8xWZfpjEl+XjN28/V
	tianAsaN4bobrtQR77lhCf89am/dN3K+mwa3B7S9MQ/wz2jkWrZr6Vkb2GZE9mUTHSZGse1YF5y
	VqVGc+AnYIrTLP8rN7hGIfWaGhjWh4+xq3I+oA20w0EWIt4Jgg==
X-Received: by 2002:a5d:5389:0:b0:45e:f2bd:2b16 with SMTP id
 ffacd0b85a97d-4602182dbb8mr5117557f8f.18.1780507338055; Wed, 03 Jun 2026
 10:22:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260528212955.1912856-1-nphamcs@gmail.com> <ah-A2gQ0GPgerXop@google.com>
 <CAKEwX=MWX9KkSFAoN4xEMg3b+gZUN9=yd7rirAWG5NOBf26eAg@mail.gmail.com>
In-Reply-To: <CAKEwX=MWX9KkSFAoN4xEMg3b+gZUN9=yd7rirAWG5NOBf26eAg@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 3 Jun 2026 10:22:06 -0700
X-Gm-Features: AVHnY4Jot3ddq7cPj22412q3gHwkkENggrGX_amw9Mz9wfEQGbpRGNvPeRfBzHk
Message-ID: <CAKEwX=MZQJLHNNU0tUqnihdhdPdVd19KhC-HtJxfbQ_d8OezzQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] mm, swap: Virtual Swap Space (Swap Table Edition)
To: Yosry Ahmed <yosry@kernel.org>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, peterz@infradead.org, pfalcato@suse.de, rafael@kernel.org, 
	rakie.kim@sk.com, roman.gushchin@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com, haowenchao22@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C274140011
X-Stat-Signature: kafib9asp63k74tcog5jgcdo439669aj
X-HE-Tag: 1780507339-372074
X-HE-Meta: U2FsdGVkX18OQQETcY0M2zfFxJOZB1/NI7vxL3dJ3Xy/6eluTRu6TCMiiZsaPinoeV7iR1j/QkA1nhDOk2QcXayinpoAVuJX2dxZk7tmdH19nFdIJweRM4RfStc/DVTc1xFep0f8z+8pnnRy0092PQpRXsTEZBaBAevzwAGTw0E8T9+X3Ub7oUiu+nXm5bpAnECGwEtjt3GlSmC8Up9g9D3fK9cMdlFFmpryj9XBzF0kNHXFpXCDZyRa/yX/dWaIfRbgS+semx+kSINRcK/fyvMg/c5LZeKk3L5G+a7pbev19Rua12Nc9fIfsknDmInJq9HQjQg/yHLFUs3jgrpNcqt4qWPBthXyoh/15fz1C/H3jhh7jWFR+0QmovUo8rx8DoNTQ5Rdu4iTg2zEKCVxtfCn7D9daL1dwNfjGidIVRessVNl4k90g0Dsi1AkVipPlgnzAwwKGwxVvz3RbVkephG4VefQhSmGaYrlK9k2NiRU9FTLIym4NOfUq2w4jx35YPilxWhAeS15kivluVPcID+XZqSUDCzOQhRh0OndAT5jFq+rxCEkazH+/SDI2FhbhuQwM8hfUkxHeCXgzhS6aQi6qEOaIonEkNddCVRwtYlRW2ykri/M9A/k3fzdnevoBsr8nQCeFmRqrfVGklA4PLqThnyZwJA0nA6Ma3NEpPcd4wAk4kbrKcYfvddrEv3/oAW/y+j0VBW5Nczu7QdcfI9Dgc5YFrlqsDjoVvZMhrj8TbxtzauePLEf8gFpYp4i07yXa5PilhIJ22uXFX1heGYsurWUjuWNztJqUD9gmqj0iBo+YpXTA9z0L3JeDAYRKfaFCCBFLDBAjEMiQhjDUpD3PHdNXCWxQ+0nFadcOuyJ7NhrLGUBTCnJzWoOxDViVbDUHQU2lLVBzYp0LmcLCbybSw0llbt79wGo/ciZ/PWFaZDuDL4uY6xHYRvKG7JMa0w/APXIJJhO4kGvkKU
 kJ6FgidH
 wseF+9ayqOhjPl10TVkNaD3m988I3ZyZJ/1uaARncEu/IIpqlIs1QC1C7Fk46u2vvKdPLR1XPR+ntYGPSNmvIPugvQY2AbfG4upuDemv3NuSJFTHDZ7qEa7x4230IMp4kd8gtsaXjYJpUeGfFBgAaxJu6hn8lhVjWvqPyn++9s+pdDGl7mjm0dayG0EjcMaFLQnfILLr2WN6/YP+BFAMbBlsQYzBJPLY6MrWWqG6/woSCMu2NKi50ugZTrxRabgAiG++YP6rwQqUvWkrCNRam7N3XctbEHoNEWdiw0CpD7in0hYVniqoQ73KqfMXaJyflarbYVLUPH1/WtjsxOVrGWS3fSJKdIwcX9dhMmRvXBRHwNS8Akq8BCgKXloE1yfhxORCO5rXkHVUqdsm+8ltOpBB2tdAT8EspXcDU/yUfqQgf+F8IRp+YNYTEmOKY+1d19FJU0Hix0SmVWE0i2mMluHVHjjX8e8bXU6xhN9VIZIuog7+q43O7HUEJvrJnMn9XOZbUJ5Ng3fhgh2PV0LwXnU4zQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 10:12=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Jun 2, 2026 at 6:29=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wro=
te:
> >
> > > II. Design
> > >
> > > With vswap, pages are assigned virtual swap entries on a ghost device
> > > with no backing storage. These entries are backed by zswap, zero page=
s,
> > > or (lazily) physical swap slots. Physical backing is allocated only
> > > when needed =E2=80=94 on zswap writeback or reclaim writeout, after t=
he rmap
> > > step.
> > >
> > > Compared to the standalone v6 implementation [1], which introduces a
> > > 24-byte per-entry swap descriptor and its own cluster allocator, this
> > > edition uses swap_table infrastructure, and share a lot of the alloca=
tor
> > > logic. Per-slot metadata is stored in a tag-encoded virtual_table
> > > (atomic_long_t, 8 bytes per slot), and physical clusters store
> > > Pointer-tagged rmap entries in the swap_table for reverse lookup back=
 to
> > > the virtual cluster.
> > >
> > > Here are some data layout diagrams:
> > >
> > >   Case 1: vswap entry (virtualized)
> > >
> > >   PTE                  swap_cluster_info_dynamic
> > >   vswap_entry          +-------------------------+
> > >   (swp_entry_t) ------>| swap_cluster_info (ci)  |
> > >                        | +--------------------+  |
> > >                        | | swap_table         |  |
> > >                        | |   PFN / Shadow     |  |
> > >                        | | memcg_table        |  |
> > >                        | | count,flags,order  |  |
> > >                        | | lock, list         |  |
> > >                        | +--------------------+  |
> > >                        |                         |
> > >                        | virtual_table           |
> > >                        | +--------------------+  |
> > >                        | | NONE               |  |
> > >                        | | PHYS               |  |
> > >                        | | ZERO               |  |
> > >                        | | ZSWAP(entry*)      |  |
> > >                        | | FOLIO(folio*)      |  |
> > >                        | +--------------------+  |
> > >                        +-------------------------+
> > >                               |
> > >                               | PHYS resolves to
> > >                               v
> > >                        PHYSICAL CLUSTER (swap_cluster_info)
> > >                        +--------------------------+
> > >                        | swap_table per-slot:     |
> > >                        |   NULL   - free          |
> > >                        |   PFN    - cached folio  |
> > >                        |   Shadow - swapped out   |
> > >                        |   Pointer- vswap rmap    |
> > >                        |   Bad    - unusable      |
> > >                        |                          |
> > >                        | Vswap-backing slot:      |
> > >                        |   Pointer(C|swp_entry_t) |
> > >                        |     rmap back to vswap   |
> > >                        +--------------------------+
> > >
> > >   Case 2: direct-mapped physical entry (no vswap)
> > >
> > >   PTE                  PHYSICAL CLUSTER (swap_cluster_info)
> > >   phys_entry           +--------------------------+
> > >   (swp_entry_t) ------>| swap_table per-slot:     |
> > >                        |   NULL   - free          |
> > >                        |   PFN    - cached folio  |
> > >                        |   Shadow - swapped out   |
> > >                        |   Bad    - unusable      |
> > >                        +--------------------------+
> > >
> > > struct swap_cluster_info_dynamic {
> > >     struct swap_cluster_info ci;       /* swap_table, lock, etc. */
> > >     unsigned int index;                /* position in xarray */
> > >     struct rcu_head rcu;               /* kfree_rcu deferred free */
> > >     atomic_long_t *virtual_table;      /* backend info, 8 B/slot */
> > > };
> > >
> > > Each vswap cluster (swap_cluster_info_dynamic) extends the classic
> > > swap_cluster_info struct with a virtual_table array that stores the
> > > backend information for each virtual swap entry in the cluster. Each
> > > entry is tag-encoded in the low 3 bits to indicate backend types:
> > >
> > >   NONE:   |----- 0000 ------|000|  free / unbacked
> > >   PHYS:   |-- (type:5,off:N)|001|  on a physical swapfile (shifted)
> > >   ZERO:   |----- 0000 ------|010|  zero-filled page
> > >   ZSWAP:  |--- zswap_entry* |011|  compressed in zswap
> > >   FOLIO:  |--- folio* ------|100|  in-memory folio
> > >
> > > We still have room for 3 more future backend types, for e.g. CRAM, i.=
e
> > > compressed-CXL-as-swap, which is laid out in [10] and [11]. Worst
> > > case scenario, we can add more fields to this extended struct.
> > >
> > > Other design points:
> > > - Both vswap entries (Case 1) and directly-mapped physical entries
> > >   (Case 2) coexist as first-class citizens. All the common swap
> > >   code paths =E2=80=94 swapout, swapin, swap freeing, swapoff, zswap
> > >   writeback, THP swapin, etc. work for both. When CONFIG_VSWAP=3Dn,
> > >   the vswap branches compile out and behavior should be identical to
> > >   today's swap-table P4 (at least that is my intention).
> > > - Pointer-tagged swap_table on physical clusters for rmap (physical
> > >   -> virtual) lookup.
> > > - Virtual swap slots not backed by physical swap are not charged to
> > >   memcg swap counters =E2=80=94 only physical backing is charged (I m=
ade the
> > >   case for this in [7]).
> > > - Careful separation of vswap and physical swap allocation paths and
> > >   structures adds a lot of complexity, but is crucial to make sure
> > >   both paths are efficient and do not conflict with each other (for
> > >   correctness and performance). I do re-use a lot of the allocation
> > >   logic wherever possible though.
> >
> > Thanks for working on this! I mostly looked at the high-level design an=
d
>
> Thank you for initiating this effort in LSFMMBPF 2023 (god, time
> flies). I was very excited by your presentation and decided to take a
> stab at it :)
>
> (I'll be sure to mention the full context in a non-RFC version - it
> has a lot of gems in our technical discussions).
>
> > the zswap parts, as the swap code has changed a lot since I was familia=
r
> > with it :)
>
> It has changed a lot since 6.19, when I was working on v6. Very
> exciting time to be a (z)swap developer right now - we have new ideas
> and new features every other week :) Reviewing code has been quite a
> joy (albeit a lot of work).
>
> >
> > It seems like the direction being taken here is that we have one
> > (massive) vswap swap device, and we keep normal physical swap devices
> > around as well.
>
> Yep.
>
> >
> > A vswap entry can point at a physical swap entry, or zswap, or zeromap.
> > If a vswap entry points at a physical swap entry, then the physical swa=
p
> > entry points back at the vswap entry (a reverse mapping).
>
> Yep.
>
> >
> > I assume the main reason here is to avoid the extra overhead if
> > everything uses vswap, which would mainly be the reverse mapping
> > overhead? I guess there's also some simplicity that comes from reusing
> > the swap info infra as a whole, including the swap table.
>
> Yeah it helps a lot that we don't have to rewrite the whole allocator
> and swap entry reference counting logic again :)
>
> >
> > I don't like that the code bifurcates for vswap vs. normal swap entries
> > though. Not sure if this is an issue that can be fixed with proper
> > abstractions to hide it, or if the design needs modifications. I was
> > honestly really hoping we don't end up with this. I was hoping that the
> > physical swap device no longer uses a full swap table and all, and
> > everything goes through vswap.
> >
> > I hoping that if redirection isn't needed (e.g. zswap is disabled),
> > vswap can directly encode the physical swap slot so that the reverse
> > mapping isn't needed -- so we avoid the overhead without keeping the
> > physical swap device using a fully-fledged swap table.
>
> Can you expand on "vswap can directly encode the physical swap slot"?
> I'm not sure I follow here.
>
> >
> > All that being said, perhaps I am too out of touch with the code to
> > realize it's simply not possible.
> >
> > Honestly, if the main reason we can't have a single swap table for vswa=
p
> > is saving 8 bytes on the reverse mapping, it sounds like a weak-ish
> > argument, even if we can't optimize the reverse mapping away. But maybe
> > I am also out of touch with RAM prices :)
>
> In terms of the space overhead I do agree, FWIW :)
>
> I think the other concern is the indirection overhead with going
> through the xarray for every swap operation, hence the per-CPU vswap
> cluster lookup caching idea:
>
> https://lore.kernel.org/all/20260505153854.1612033-23-nphamcs@gmail.com/
>
> >
> > I at least hope that, the current design is not painting us into a
> > corner (e.g. through userspace interfaces), and we can still achieve a
> > vswap-for-all implementation in the future (maybe that's what you have
> > in mind already?).
>
> That's still my plan. Operationally speaking, I want to make this
> completely transparent to users, with minimal to no performance
> overhead.

I do want to add that, even without achieving this, the current design
already enables a lot of use cases. I think it is a good compromise to
maintain both virtual and directly mapped physical swap entries for
now, and revisit the conversation of whether we can afford a mandatory
vswap layer once all the optimizations have been done :)

We should strive to simplify the codebase, and it will naturally
happen when the original overhead concern is no longer there. A
swap-related example: a few years ago, everyone thought swap slot
cache was needed. But then, Kairui optimized the swap allocator's lock
contention issue away, and that swap slot cache is suddenly redundant.
That finally allowed us to get rid of it. Similar thing happened (or
is happening?) with the SWP_SYNCHRONOUS_IO swapcache-skipping
heuristics.

