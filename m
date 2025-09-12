Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A0BACA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 21:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A13E8E0005; Fri, 12 Sep 2025 17:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3794A8E0002; Fri, 12 Sep 2025 17:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28EDA8E0005; Fri, 12 Sep 2025 17:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 150DE8E0002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 17:44:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA33716096F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:44:36 +0000 (UTC)
X-FDA: 83881927752.15.72985B2
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf10.hostedemail.com (Postfix) with ESMTP id DA351C0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 21:44:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCu2wn26;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757713475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9O2GTcl+qqbIgpGkrt2rOsQQ3rAmT1mavJ5h4MkQajM=;
	b=m983OUjYSw8LWaOTF83MGy0CSby1ZygfXHHywVAdlYtNHwvggrdsRu2v0qS6jJcFa3vD0A
	m/ll1cFuJoWJbM5Ei0XZsAlwwsKboHHZjQopvPZ48CJWbLnXXhb/Di9fDaVz3fvF0o/Hty
	K0k41L6N1GtSou3BfVTKLa142W3pAKM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCu2wn26;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757713475; a=rsa-sha256;
	cv=none;
	b=FPpRqfgLyHAr4OLIro7MsM1xVaUpG+sPM98JOaQAwTBvzZs/BYWkOjWoUZjCcBFpoa5Yjo
	gGAof+p1R23omwWRYwZxQ+mrucrebke4c7Ju/Rd8WHO4z1Owsu4fFcl1Q/Yu6KGdNxfD2Q
	GbZDuBxBJIoLtgCHCoQmT3OxCvpwfCs=
Date: Fri, 12 Sep 2025 14:44:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757713472;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9O2GTcl+qqbIgpGkrt2rOsQQ3rAmT1mavJ5h4MkQajM=;
	b=GCu2wn26slhy+eNNOf3M3VB4YTjkvebYaIuQRsZwJDu6TaytlpolDXrqeNooCMfhnqb3fC
	FNovhv6YpfWmWhn9FjiaskCJdIK/tbcntfw5Ip7lj4GNyHqdBYnQnLJ7gLB/KhNsu3Pk1j
	PMNysMkXIQUo2pTOQSu1gJuOjmrVrzc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Harry Yoo <harry.yoo@oracle.com>, Michal Hocko <mhocko@suse.com>, 
	Sebastian Sewior <bigeasy@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH slab v5 5/6] slab: Reuse first bit for OBJEXTS_ALLOC_FAIL
Message-ID: <lv2tkehyh4pihbczb7ghvbkkl4l75ksdx2xjtxf2r7lgzam76h@ekkrlady2et3>
References: <20250909010007.1660-1-alexei.starovoitov@gmail.com>
 <20250909010007.1660-6-alexei.starovoitov@gmail.com>
 <jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5>
 <CAJuCfpGUjaZcs1r9ADKck_Ni7f41kHaiejR01Z0bE8pG0K1uXA@mail.gmail.com>
 <CAADnVQJu-mU-Px0FvHqZdTTP+x8ROTXaqHKSXdeS7Gc4LV9zsQ@mail.gmail.com>
 <shfysi62hb5g7lo44mw4htwxdsdljcp3usu2wvsjpd2a57vvid@tuhj63dixxpn>
 <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAADnVQ+eD7p4i0B9Q2T-OS_n=AqcrrvYZGY57QOOqKEof6SkDQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bfdjjs88nbk64xiiezxems64u9rb8sk6
X-Rspam-User: 
X-Rspamd-Queue-Id: DA351C0005
X-Rspamd-Server: rspam04
X-HE-Tag: 1757713474-412786
X-HE-Meta: U2FsdGVkX19r176Ksw35CIUx51lhAGTQx1gqM/xUqDo3f1URp/6JZRWAe1Hc1G2cLLrZU+eyLGeLIY7P2HLtvLB7sRzMNOG2ahZdrcmzDacGFfQNyNpgCLtA4UHRP8S0gDXKTiaaKB/5h3UFA4Wp62vzx/4NPa4S786XOmevZLeL9c/gtztSX/MfQPxe1PHgMEkF2O3H3X5u1hPI9veBn9p6op4I4Fjbn6C0KkszFEqdM5X8SQatSSHLAK/4qLcKL90XWxz7yrZ9TyLtVeuygDGtJ4rNxTy3qmRdP8cipEeHKfdLsROjQ73o7vvz3J+RH7954k4Wy6L3M56l/9z82EN0r0T4me183EPeJobLySNiwVHvvUY3uYHej0OhE4jLKHV/FeIBi7hH6Vby9RjiHVN7GxS921nMc+u+0bMzCv4X4FkU+a5Y6L+EWIbdC0mNOdWBft7fU2NFLMvuGCwQgsTN6i5c474B1KVzlWZsgdMCL4hAiJk473VH15EH4thAjiG4raRiJIF/hV4pzJODS9jQF7C0OykodRAXDiA9gi64xUV944/uisQAstl0O67E+b5VVU/TOFGIho4SxDyMp5bC8JkIbXhAg7f6RU3z2no1v7dp9yGAdxWwDFdUltkCOvSFZobTFTauS9ppyXUuHtxIlAkHyqNtBrxPye17Rz6xY3xOFgjPV0S7P8pwkjSa3ZR8d8mAWE1xh3ltQWx5GkKx+s4tIXgCNf3eOfNW3pd+TcZp25F2EwWCovQBstiDdzg1yXYx8fYyNAj3deRzNAxGUO+ap5sHAygYCVqOrBK6PnZGmMaVJChReCFqDpK9QJHYkKtwLWerz9+d8/eBDOO9T3z10BDVUHCUEZUnBC+9MZqkYddVQJfQ/ICRZ1Fjt9/3a87ZKerqAnjCMPXVhUX4yk+j94T4D/xuk8wMU3uykWx+Y29nFsu3gwb1BRmEMC6ARjTR1823fT0km3L
 lunYEB9z
 UKPJMcVU0Y8XV/QQFCnoB4kqak69sEoVjjLgjWEyoEQrNk0A/7fOcDmS+h8mmvkFCiRvaf7kaNN+FeX32RZzmDj5TlAUG/lfqujGCOUYJajJ905AB+x0UySKDwcxWnWYcef9YK0b7ITxRk1p/q1x4khBXnzatCPtA8N+78NWvdHktSx5WiN09Uqr1Q0amEQiF2uDFffpvE2sqMMtfepBSJnH0VtV61qM0q9tqwjyc/gFtlxQgvbzmmV9cfIW3edTCuKROm58uSsWjC+nD1+h6dVnASEjsyJT1kQv/mhGQh3EAoiFtg4ifdwVPN4pAscvfoMvtxSLGWxtHnG+fsEmSYxmGcR2upRIu0u1pfl7jkEORQouzsbkYG2EHBuTs5louwidGlGACNhxz//U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 02:31:47PM -0700, Alexei Starovoitov wrote:
> On Fri, Sep 12, 2025 at 2:29 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Fri, Sep 12, 2025 at 02:24:26PM -0700, Alexei Starovoitov wrote:
> > > On Fri, Sep 12, 2025 at 2:03 PM Suren Baghdasaryan <surenb@google.com> wrote:
> > > >
> > > > On Fri, Sep 12, 2025 at 12:27 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > > >
> > > > > +Suren, Roman
> > > > >
> > > > > On Mon, Sep 08, 2025 at 06:00:06PM -0700, Alexei Starovoitov wrote:
> > > > > > From: Alexei Starovoitov <ast@kernel.org>
> > > > > >
> > > > > > Since the combination of valid upper bits in slab->obj_exts with
> > > > > > OBJEXTS_ALLOC_FAIL bit can never happen,
> > > > > > use OBJEXTS_ALLOC_FAIL == (1ull << 0) as a magic sentinel
> > > > > > instead of (1ull << 2) to free up bit 2.
> > > > > >
> > > > > > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > > > >
> > > > > Are we low on bits that we need to do this or is this good to have
> > > > > optimization but not required?
> > > >
> > > > That's a good question. After this change MEMCG_DATA_OBJEXTS and
> > > > OBJEXTS_ALLOC_FAIL will have the same value and they are used with the
> > > > same field (page->memcg_data and slab->obj_exts are aliases). Even if
> > > > page_memcg_data_flags can never be used for slab pages I think
> > > > overlapping these bits is not a good idea and creates additional
> > > > risks. Unless there is a good reason to do this I would advise against
> > > > it.
> > >
> > > Completely disagree. You both missed the long discussion
> > > during v4. The other alternative was to increase alignment
> > > and waste memory. Saving the bit is obviously cleaner.
> > > The next patch is using the saved bit.
> >
> > I will check out that discussion and it would be good to summarize that
> > in the commit message.
> 
> Disgaree. It's not a job of a small commit to summarize all options
> that were discussed on the list. That's what the cover letter is for
> and there there are links to all previous threads.

Currently the commit message is only telling what the patch is doing and
is missing the 'why' part and I think adding the 'why' part would make it
better for future readers i.e. less effort to find why this is being
done this way. (Anyways this is just a nit from me)

