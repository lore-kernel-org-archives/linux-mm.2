Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D9FFC55182
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 02:18:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8465C6B0095; Mon,  3 Aug 2026 22:18:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7896B0096; Mon,  3 Aug 2026 22:18:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E6FE6B0098; Mon,  3 Aug 2026 22:18:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35EBF6B0095
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 22:18:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98472120850
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:18:57 +0000 (UTC)
X-FDA: 85061979114.20.294369A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9D3F7C0002
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:18:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrgEMC1E;
	spf=pass (imf10.hostedemail.com: domain of luto@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785809935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fBGKAE05xJKKiYIOYKeypVavHcHnoSNrfvRL+QYpZOE=;
	b=hu3wojRg2FluLJjp6QOkOqEguZtlyKoPjUdjgmddlJ8bH497kYJ6a7AumSIZ/3P61NJDxv
	Bj2GT6K8fxFawgaBhx1SJHsfu0V01++XM3bbgSHhdBKwmv6VdBO2j2drwQplL6DkV4/RmO
	7ui9Nm5y84OTr0WFU6XnI5Xp5cOmONs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RrgEMC1E;
	spf=pass (imf10.hostedemail.com: domain of luto@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785809935;
	b=fMb//hGu+pQLEk8X4ARDcFGQsWpi5f1CArKJ2e/zweagH2GoRIadZnq6H4QEX/TtLFcGhG
	8u4x+Kl2uRfvEBkZu3wFZ5c+TLTYM8iFsu+tD2fxKaAiaGmRis/WLcUr3KRuJZ0BR8Ue8W
	rPKyqVfm7atprt5uAUslx2ND54I3tQg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 712D942A83
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561861F00ACF
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 02:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785809934;
	bh=fBGKAE05xJKKiYIOYKeypVavHcHnoSNrfvRL+QYpZOE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RrgEMC1EMnhNXw99Hbu6DsDJlmu5Y3X8F1ErJMke0IA4B3r7HoShqkBJTWgR6BhVV
	 k8dmPyKBZC3Y84e6tayzMvxsd/EiCGxy5KzWW/XEc+TghWcx/zXVY8OxV8KiUvcnFC
	 2qEhQQxnYvw9Iv3OH4NFiqq38L/6zZ5lHacse2M1tMAGzcuF31iU7BUJsmqBi/MEtX
	 u6AFtCX2bXTvpNOILRJm/91Yj7CCqzQfbpA6fVyjCOY2i3g01vkWjJEX20V8UsDR+M
	 OT2YTbWTAienRaw9oaexc0S5+BaYLSNsAqU4g7tvY11GWETaRHRNFdIxmOJOdRornY
	 KKefdeEEAwXdQ==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-39c908d6cb6so46022601fa.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 19:18:54 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpgDRAap98cqAAYRBn5mPPRpmnnThWWfcO/K4RtQF9RSM7mOz1BwGo5DXpcx0FvgsM4r92j+optUw==@kvack.org
X-Gm-Message-State: AOJu0Yyf7+uWx5bYO+8G74xx3oLhFXU6+rqtsrarFGbxrEtAMW10WzcT
	0vVDvo3JaAuZJlYDA9DFygLGWlJ+yC0J/ITxLPSsCl8Z9gnrYsndDGq7BkHRlbFjhXshrwMigLs
	q4x/9SfxJ6k8kqvv5g6R0hUPfZTnb7wPJH8obu1M5
X-Received: by 2002:a2e:a88a:0:b0:39c:828a:ec28 with SMTP id
 38308e7fff4ca-39f864562a9mr27536451fa.31.1785809932740; Mon, 03 Aug 2026
 19:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260804003708.49830-1-luto@kernel.org> <20260803183032.7cc1fb1007d309c2431855ea@linux-foundation.org>
In-Reply-To: <20260803183032.7cc1fb1007d309c2431855ea@linux-foundation.org>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 3 Aug 2026 19:18:40 -0700
X-Gmail-Original-Message-ID: <CALCETrVxtFyMoOrpTckrs3HU7evczytau0fGgyCWidt4oFS=CQ@mail.gmail.com>
X-Gm-Features: AUfX_mz1zN5nkOVZ7C7UnstYQ8n2S9i8_HR-owWrYtZZxw5U9nyHOpOlZpXyzv8
Message-ID: <CALCETrVxtFyMoOrpTckrs3HU7evczytau0fGgyCWidt4oFS=CQ@mail.gmail.com>
Subject: Re: [PATCH] Fix incorrect flush address in direct page table reclaim
To: Andrew Morton <akpm@linux-foundation.org>
Cc: luto@kernel.org, linux-mm@kvack.org, 
	"David Hildenbrand (Red Hat)" <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Liam Howlett <liam.howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, stable@vger.kernel.org, 
	dfoxfranke@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9D3F7C0002
X-Stat-Signature: 6e6jc8dkdoyik969fumrnq6krm365wfi
X-HE-Tag: 1785809935-813048
X-HE-Meta: U2FsdGVkX1/1C4c3sKJVrxaG5PF631gGTw9dDUdVzhJydYJz0o7hh3b01AezWAS/XWe2sOWS9i5fEdjTDtUpt9jooPCb7zDKkPmaCN1YP6B01Nl0jpynxsZniOmfMIk/38+7Y5sJGtOyq8Ir95Kv057GeeBSnw2VFBdBQ6fo/6xSIZXYkq5IS/kOL1Xq65zSSJ9cbXgW7zInhyR1c9qvbFLTHoMnMd51YCf5pxJMeddyJuQYirsMQ4VUmVbgW1pFn3Lkt9FYXrbp8b3iuERe4BvQfT4v9LLRZXaX5GEEdhrlJpyhUlxSZzdGjNRwok8WTACjYTT93ILsgKbyUYw4zngyhQOF7+8b5Kfa8hddU1uxwlQjENeomvmxAFl7Dj3DZzyTn28aP03cRMSbT6Qo5ILsXutsAF/FOazOarjFqSLJOc/d7yJ9lK+fZ3oC5nuOTt44PVpdwqROjcad4aSWhwXAnA7Ni8Y9JfjM+NhY4nt4VBP4Fb1Ovrpg1xDdPFgWV0FMKVMxH19rMOnaRQXH94DRKCacvJxi/2a2zB2Gbx4NTND/NJ8GTbt/uTA73pVdbmh4EGXrhlDwoU/62US3gSUDvuDrK/GKCW4Z3C3+s/06vvALB5qJUnO5GKdxbUpXfJmFZuhSJPkwA4v1fPCSA80tD+EOQinxhPge+Mq7uSD8Rxcs1z0WAElNo2N+EzSLR3fzWEzmiLnBRZK82fpmo28OOcTez8bZThABXZWQiHfiRXcYiEs5AT2RG+R07w1GYNSB/wIOK3RU0RrwBT7W4irZCSIoW0l7lz0eNldKDlh5mcRG+apOLV7yqrbVeECn5W52mkAXbHIKwpGXdeM1cL1X+wjd77SA4klkIy8WSpFsbKbMIfR5+pto2W6ksFEJKhkV/V+27uQCmHtqqYy5JeefTaMfD0IFqCsbvkwkTU1W+s+A0MMqRWNnFF7juRBoa5TIy7sqUMf5whquU2E
 mIqEePXL
 2ffd2n+OsP8QrUsuQiaOkF1GLhotWt5qA7Z2oQ+OfLxiZa5HLozlsPnqNQmAmvmB577F7eJ3uY+XM3lIxfR2h8BS7tWCRQNnYYezef2ZenAt0Gs5ZZBYg54vNo604bmq/gathFCUBSGPkNs5OSmS+g0WZUq+7dRpV52TxVtt714KaXFWgeFzEtpDk4Lm1KEWbhJtxqUyU5/UQkUgWkIc3mudRtfnNTUUaBIbcG8ukubYSFnJgxSJIVcMQGqda9kw8pfYvGibjA4wP7t05V7fH1jvlmrKTrExVoKHTctXm6Gt/+RC0ZlImYHNGiw64jAKBTpYHpTY+fhbq1VvA2ZOjzpmO3kCofi4oI/UryfzWhUQ97XcUJdq5W3uzGuDMR+KAlN2iaGeYcohbBFw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 3, 2026 at 6:30=E2=80=AFPM Andrew Morton <akpm@linux-foundation=
.org> wrote:
>
> On Mon,  3 Aug 2026 17:37:08 -0700 luto@kernel.org wrote:
>
> > From: Andy Lutomirski <luto@kernel.org>
> >
> > When zap_pte_range reclaims a page table, it does:
> >
> >     pte_free_tlb(tlb, pmd_pgtable(pmdval), addr);
> >
> > and this is unconditionally wrong: if this code executes, addr *always*
> > points one past the end of the range covered by the table.  The addr
> > parameter is used to flush the TLB (really the paging-structure-cache)
> > to drop references to the to-be-freed table, and any architecture that
> > cares about the parameter will flush the wrong address.  (But they'll
> > still free the correct page).
> >
> > I think it's worth contemplating why the kernel works at all.
> >
> > If we hit the offending line of code, we will first clear the PMD entry
> > (line 1954, zap_empty_pte_table), then we will issue pending flushes if
> > force_flush is set (tlb_flush_mmu_tlbonly(tlb)), then we will skip the
> > retry on line 1979 (phew!), and then we will do the offending
> > pte_free_tlb call.  *Or* we will clear the PMD entry immediately before
> > pte_free_tlb (line 1983, zap_pte_table_if_empty).
> >
> > If we have any pending flushes (i.e. we actually zapped any last-level
> > entries) at the time we clear the PMD entry, then the flush really ough=
t
> > to flush all references to the table (Linus certainly seems to think it
> > will on all architectures [0]).
> >
> > The condition under which we have no accumulated flushes at the time of
> > the clear is very complex (the whole zap_pte_range function has absurdl=
y
> > complex control flow).  If we do hit the bad case, then we will end up
> > clearing the PMD entry after the last time the range is flushed, and an=
y
> > CPU is free to cache a reference to the (empty) page table.  If this
> > happens due to an ordinary read or write, it would segfault, so it woul=
d
> > be rare.  But the cache could be speculatively filled as well.  Then
> > we'll flush the wrong address and then free and possibly reuse the
> > table.
> >
> > On x86, even flushing the wrong address works on non-KPTI Intel systems
> > because INVLPG flushes *all* paging-structure-caches, not just the ones
> > for the target address.  But INVPCID does not, and flush_tlb_one_user
> > will use INVPCID if it's available.  And then we're toast.  AMD systems
> > are more susceptible: we set the EFER.TCE bit, which makes even INVLPG
> > only flush the target address.
> >
> > P.S. IMO zap_pte_range is a mess.  The control flow is excessively
> > complex.  The direct_reclaim variable itself has a confused meaning --
> > for the first part of the function it means, approximately, "we should
> > free the table if can_reclaim_pt".  But, later on, it means "we ALREADY
> > reclaimed the table".  And the goto retry on line 1979 is IMO just
> > asking for trouble if the condition ever changes such that it might
> > happen after clearing the PMD.
> >
> > I think this might fix an issue in ripgrep reported here:
> > https://github.com/BurntSushi/ripgrep/issues/3494
>
> Huh, cool.  Very recently I was scratching my head at Daniel's ripgrep
> report.  Upon which he obviously did a ton of work (many thanks).
>
>         https://github.com/dfoxfranke/ripgrep-3494-analysis

I'm pretty sure that's AI-generated.

>
> Daniel also pointed a finger at 4c640eb4181c ("mm: move pte table
> reclaim code to memory.c").
>
> The manifestation is that a tiny race window causes the zero page to
> magically appear where an anon page was expected.

The analysis says:

pagemap reports the page present, soft-dirty, with PFN 0 =E2=80=94 the
kernel's zero page.

ahem.  I would be quite surprised if pfn 0 is the zero page.

If whatever code the AI wrote that generated its trace is actually
correct and there was a PTE entry with pfn 0 and the present bit set,
then maybe we have a genuine race that corrupts a page table.  But the
analysis seems quite sloppy and I'm disinclined to trust it too much.
(A quick experiment suggests that even GPT-5.6-Sol high (which is
supposedly pretty good) will rapidly go off the rails if you ask it a
leading-in-the-wrong-direction question about the kernel.)

In any case, the original reporter was using an AMD system, and the
bug seems extremely sensitive to tiny details, both of which are
consistent with the possibility of a narrow page table caching bug
like this.  I'm frankly a bit amazed that he and his AI were able to
reproduce it as many times as they apparently did.  I wonder if the
specific offending assembly caused the CPU to somewhat reliably
speculatively fill the paging structure cache during the narrow window
after the last correct flush and before the PMD entry was cleared --
if so, this would be consistent with the AI's observation that even
tiny changes to the asm seemed to make the bug go away.

--Andy

