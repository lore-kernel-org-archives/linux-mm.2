Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6997DCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EA788E002B; Mon, 20 Oct 2025 11:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 973C68E0002; Mon, 20 Oct 2025 11:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814FB8E002B; Mon, 20 Oct 2025 11:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 692038E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:34:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 305421DBEB2
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:34:04 +0000 (UTC)
X-FDA: 84018888408.16.AB355FD
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3797D14000C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:34:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pyjkcCg0;
	spf=pass (imf23.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760974442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zoMPjv5QaA2iaHSWt7qx0y0ZWWey1KUmhoM8Z4ibSWU=;
	b=G27fkuQD37rLx6C2lL9eax+LhBjuHnIhdx0Gr7SQXagSjsBUIgw7atQCch1HifPlECIRP9
	y+n8oLtghPrnH61yP9F1L5U1xk97WRipFIbljQyYXeUfypGGONUOQQm9veObCg9yy5j5F0
	3oqX6OHxm9vIKY3D0NzmIbGTntsNONI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pyjkcCg0;
	spf=pass (imf23.hostedemail.com: domain of jannh@google.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760974442; a=rsa-sha256;
	cv=none;
	b=p12k2gLuEffcvpfCEsXKraygR+yqzkwqxq0rQEV3qBBZC4uDx9rrjXGliKxB1DPZWRCs7x
	B23WfX7PfH98V4fJkote0e9ntYmuFc063SZmgtCXZyywdezYnzrJlMdRhhs2jPTDp9Nr/x
	+v+d3W7y/vvfGjBKs3VnEajsPIAZL5M=
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-63c2b48c201so12645a12.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760974440; x=1761579240; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zoMPjv5QaA2iaHSWt7qx0y0ZWWey1KUmhoM8Z4ibSWU=;
        b=pyjkcCg0Y+IOaZyqq/+aPMxKkRGKI9ruuWnE6kCTnNbWzRPUPYYQogiKcv3eFWtMVB
         T5xbwykewBwtowTocwyLvHBRz986gOXx1o8mFubOd5hHNLrvfaFeyZufsZ/QFp5jUefL
         e+KRAf6rUY5drH57TLqztce+KD04fXtfnjgRimCx7VJDKOjUdXO5XEcuJr5FmQ/+vbMP
         wXg2e5JYRR9Q0yZoTKo7yA8CqgiPgIBgaYA5u2hcNCNFaRgInSOqX/gbZ5RnOy6Fc87U
         DLCxZzYb7p97rhQ+mshHCgw15Q049+Rm1i8Q2iyj2kkK03gN9vKxUF+M+84kp0xls3u/
         EWww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760974440; x=1761579240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zoMPjv5QaA2iaHSWt7qx0y0ZWWey1KUmhoM8Z4ibSWU=;
        b=lxxvtXrkvJ0o+j+8zqn9cFf+ugKkzz6pQnq5AHAUyAHmKrnsuxbwrHqVHgYbIeLW+l
         ZvUCDfxoeNn/0IyibIf4jeBXCNWOE6OuzhDzZBzF2ZrwXfVRd2EEYo8gWif2ZK9F4AbF
         PNriAbKJ1RfWV6/dKHufhMpz5MyjfB55xFMiCAd+eMYC4x8qFkBVjZDq/urSYAyUsdBM
         jK/TcOckqAyXWc1sHzlOS5dqDYktwnxCOEZcGBneWNy6cnqCQZSBIwW3DQWKDoSlfDEN
         8smuicWQ41Wd+GSmzk6va7jN/3tv5D0aeoceP3tcV0L+TXV9+VUWK9SyWSFdXuRdNEfu
         51MA==
X-Forwarded-Encrypted: i=1; AJvYcCW+UZe9B6qqTUmhmhVOiTYcVLprqgnmmTjzKOdMau85dfTpdNQT8v1QkzFKbVgJQ4AY5mNBdiAPGg==@kvack.org
X-Gm-Message-State: AOJu0Yx5CVsJwPcQAqqCyM1ij2kvuSJYTrU7tECqNrS1uJUmI9DzHdFv
	eRwHz6SUtJa8ZZ8Sx/9iaSDFztOFbFzs2IqKWQxVtlkuGp5e/DpoXnLZDUyz3CGloj1EOOsrmWk
	VKXBLaFbkunMHowwdLha50JzLqHaX0rC6QgXsT6SF
X-Gm-Gg: ASbGncsPVNB+Rsc/pnPIJqn6dA4WUF9TMa1QP+hynYTnJeRkU/Zbk+jlOiNaIXfdbCD
	MTpqRhHcAMHFATW6QPyAfzRWBNR10+0+07zutyyPeDo6v3nBh5HCHIRdryTBNZHsROAKgHmWOtI
	UggyAfmfkzFPgkPxzMLvmkoWQ8Kr8cEEWnNi4bUu8MywPXDMiF00/untuY5P55C2LbC1V+DC4/K
	S5pKUIJ6ywQ3zUt55jJvg14Vc+Grv5yXWv+MedGu9+FJuMEQy5DzoOY7O+0eZ8hBPumLmOzpYIJ
	Sg5ZmhZKVQdV+Q==
X-Google-Smtp-Source: AGHT+IEMH+U2cQKjQIsds+8fm6Kq7It+MUdS3Lsmva3FmgSZShNlk6REjMdRJGcVQFJhUkJjZdCtVYUnoT8lrmP5r+g=
X-Received: by 2002:a05:6402:1284:b0:63c:11a5:3b24 with SMTP id
 4fb4d7f45d1cf-63c11a53bd3mr332815a12.1.1760974440107; Mon, 20 Oct 2025
 08:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de> <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com> <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
 <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local>
In-Reply-To: <81d096fb-f2c2-4b26-ab1b-486001ee2cac@lucifer.local>
From: Jann Horn <jannh@google.com>
Date: Mon, 20 Oct 2025 17:33:22 +0200
X-Gm-Features: AS18NWA-e4MpKGPDrMbiZevTJxybzfCgX9TbhLW59-uk1AksQpJ17-n6IgH3c2w
Message-ID: <CAG48ez3paQTctuAO1bXWarzvRK33kyLjHbQ6zsQLTWya8Y1=dQ@mail.gmail.com>
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, "Uschakow, Stanislav" <suschako@amazon.de>, 
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com" <trix@redhat.com>, 
	"ndesaulniers@google.com" <ndesaulniers@google.com>, "nathan@kernel.org" <nathan@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "muchun.song@linux.dev" <muchun.song@linux.dev>, 
	"mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, 
	"liam.howlett@oracle.com" <liam.howlett@oracle.com>, "osalvador@suse.de" <osalvador@suse.de>, 
	"vbabka@suse.cz" <vbabka@suse.cz>, "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3797D14000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wts8ogwdk6atzm755exkq81fnsy9on45
X-HE-Tag: 1760974441-612634
X-HE-Meta: U2FsdGVkX1/cvd9t8rKbPbLlS47zTARVjZZMKD/S1q3lLhSQ/BRNOnTba/egpZqxqbpxp7/Dw5HKarNX/rR0lbotptIZ8Raqm5O4dZ4lTTp7KvbaiOHixBFim+Z8IgjVtejMJKJHz341EFJQ8+1F06XwTAyCTURoi0CtV3POXlxNXu404ozzsUZWq9i+q8/ItsTZtgsG28B16WbNACGXq111YX+f4RplDphrkcJkECGLOjmc5z1IYr/XX0zvbfKDa3mae1+wcSGfS0DAdn5n1Mxe7n7qbN+MZzlayCmGX7gBJOpddkb0oplMLlORDK981g9bBvX5cc0InVcw5jWpwFFaW3ra0P0/hotbKb6CD8ZmwyT+VIKDcp0X1WW4Qhqn5H/wO4uNAFRcDnESMVf4VqBoUnUIFROqrnDvTkkl9DQfcWGSNbuoIHdOqyU81aXI+QQRGywHcUT2uVYLzpmEShbHUs/r/rneQfCvMgA9JHb19xDF7RycQM6vFhSfXZRqXZFmYNFeSf8eu+LMCopHJ09Dr8FLeGz0w+i0BegtjC+RaoHlRdLLtWCyNK7phuiHsV0aLZLSDqRyMqmig3UzMUUAJEYBkceErLzWFN/8ZUSf3I33Jp6uhzmiZxqi3JDxrn+Idfjd0Urk/Y6xy6gvB745ZmAZxwZIeV/t+5P0h3VAwEUrkKor3oI/mbvr45xl1XHfd5LgGez9lwZZ1TJpoNUkwxmc7qsakSpjLgi9GEi7EsBDRVRf+4jU8vgOwdykIwz9XpmT40eE1Tb3xW2C2xdk06IktLD0AHmdRnsOB98BEnWQVjh0nviSo+uflUyl8iTqIYG3FijFFIBQxkLCnfu0EsPQLd712iEkSNXEhfmKHyIsgd3j9u/HbijoXuC3YZYY0m/uxAIVtajFgQ2j52k3KCD5jzyk+6if0pgl/d3QVRS+aoJm+Rqv1lUM8OfT30SwzsBr1IGSoicGZMQ
 7JPr75Me
 j43XM9UI8WT81kGQpYxWHZCsj6l5KZwS+rO1iUXFTIVJeeFmjaRdtuPKGQbIqfjKblBh6IzxSuQBRDWCSLtvHn9sL7+NLJ+GN/gVH1tPLbqVk1nAZg/gFLiaRnsGJFltLp7Cl8OkvWJ9gWHkbSSXTgzGIXDx00EicA1QBWqpyT0A4iXjJsw8q3O2fLJb16KpSHNuqDCvr36v/nlixEB/wXRh1WMbhex9wQC+z9IG2qBOCsoK7RMMD4+Tq8s6hTK2mUUgYE59ZHYlbXcQXJSQdY/tsxBhZNKp1PaEgTGFSseqAbGPHPtPAZauJ0qwC/M4YJkvmjxodPMGbsmM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 5:01=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
> On Thu, Oct 16, 2025 at 08:44:57PM +0200, Jann Horn wrote:
> > On Thu, Oct 9, 2025 at 9:40=E2=80=AFAM David Hildenbrand <david@redhat.=
com> wrote:
> > > On 01.09.25 12:58, Jann Horn wrote:
> > > > Hi!
> > > >
> > > > On Fri, Aug 29, 2025 at 4:30=E2=80=AFPM Uschakow, Stanislav <suscha=
ko@amazon.de> wrote:
> > > >> We have observed a huge latency increase using `fork()` after inge=
sting the CVE-2025-38085 fix which leads to the commit `1013af4f585f: mm/hu=
getlb: fix huge_pmd_unshare() vs GUP-fast race`. On large machines with 1.5=
TB of memory with 196 cores, we identified mmapping of 1.2TB of shared memo=
ry and forking itself dozens or hundreds of times we see a increase of exec=
ution times of a factor of 4. The reproducer is at the end of the email.
> > > >
> > > > Yeah, every 1G virtual address range you unshare on unmap will do a=
n
> > > > extra synchronous IPI broadcast to all CPU cores, so it's not very
> > > > surprising that doing this would be a bit slow on a machine with 19=
6
> > > > cores.
> > > >
> > > >> My observation/assumption is:
> > > >>
> > > >> each child touches 100 random pages and despawns
> > > >> on each despawn `huge_pmd_unshare()` is called
> > > >> each call to `huge_pmd_unshare()` syncrhonizes all threads using `=
tlb_remove_table_sync_one()` leading to the regression
> > > >
> > > > Yeah, makes sense that that'd be slow.
> > > >
> > > > There are probably several ways this could be optimized - like mayb=
e
> > > > changing tlb_remove_table_sync_one() to rely on the MM's cpumask
> > > > (though that would require thinking about whether this interacts wi=
th
> > > > remote MM access somehow), or batching the refcount drops for huget=
lb
> > > > shared page tables through something like struct mmu_gather, or doi=
ng
> > > > something special for the unmap path, or changing the semantics of
> > > > hugetlb page tables such that they can never turn into normal page
> > > > tables again. However, I'm not planning to work on optimizing this.
> > >
> > > I'm currently looking at the fix and what sticks out is "Fix it with =
an
> > > explicit broadcast IPI through tlb_remove_table_sync_one()".
> > >
> > > (I don't understand how the page table can be used for "normal,
> > > non-hugetlb". I could only see how it is used for the remaining user =
for
> > > hugetlb stuff, but that's different question)
> >
> > If I remember correctly:
> > When a hugetlb shared page table drops to refcount 1, it turns into a
> > normal page table. If you then afterwards split the hugetlb VMA, unmap
> > one half of it, and place a new unrelated VMA in its place, the same
> > page table will be reused for PTEs of this new unrelated VMA.
> >
> > So the scenario would be:
> >
> > 1. Initially, we have a hugetlb shared page table covering 1G of
> > address space which maps hugetlb 2M pages, which is used by two
> > hugetlb VMAs in different processes (processes P1 and P2).
> > 2. A thread in P2 begins a gup_fast() walk in the hugetlb region, and
> > walks down through the PUD entry that points to the shared page table,
> > then when it reaches the loop in gup_fast_pmd_range() gets interrupted
> > for a while by an NMI or preempted by the hypervisor or something.
> > 3. P2 removes its VMA, and the hugetlb shared page table effectively
> > becomes a normal page table in P1.
>
> This is a bit confusing, are we talking about 2 threads in P2 on differen=
t CPUs?
>
> P2/T1 on CPU A is doing the gup_fast() walk,
> P2/T2 on CPU B is simultaneously 'removing' this VMA?

Ah, yes.

> Because surely the interrupts being disabled on CPU A means that ordinary
> preemption won't happen right?

Yeah.

> By remove what do you mean? Unmap? But won't this result in a TLB flush s=
ynced
> by IPI that is stalled by P2'S CPU having interrupts diabled?

The case I had in mind is munmap(). This is only an issue on platforms
where TLB flushes can be done without IPI. That includes:

 - KVM guests on x86 (where TLB flush IPIs can be elided if the target
vCPU has been preempted by the host, in which case the host promises
to do a TLB flush on guest re-entry)
 - modern AMD CPUs with INVLPGB
 - arm64

That is the whole point of tlb_remove_table_sync_one() - it forces an
IPI on architectures where TLB flush doesn't guarantee an IPI.

(The config option "CONFIG_MMU_GATHER_RCU_TABLE_FREE", which is only
needed on architectures that don't guarantee that an IPI is involved
in TLB flushing, is set on the major architectures nowadays -
unconditionally on x86 and arm64, and in SMP builds of 32-bit arm.)

> Or is it removed in the sense of hugetlb? As in something that invokes
> huge_pmd_unshare()?

I think that could also trigger it, though I wasn't thinking of that case.

> But I guess this doesn't matter as the page table teardown will succeed, =
just
> the final tlb_finish_mmu() will stall.
>
> And I guess GUP fast is trying to protect against the clear down by check=
ing pmd
> !=3D *pmdp.

The pmd recheck is done because of THP, IIRC because THP can deposit
and reuse page tables without following the normal page table life
cycle.

> > 4. Then P1 splits the hugetlb VMA in the middle (at a 2M boundary),
> > leaving two VMAs VMA1 and VMA2.
> > 5. P1 unmaps VMA1, and creates a new VMA (VMA3) in its place, for
> > example an anonymous private VMA.
>
> Hmm, can it though?
>
> P1 mmap write lock will be held, and VMA lock will be held too for VMA1,
>
> In vms_complete_munmap_vmas(), vms_clear_ptes() will stall on tlb_finish_=
mmu()
> for IPI-synced architectures, and in that case the unmap won't finish and=
 the
> mmap write lock won't be released so nobody an map a new VMA yet can they=
?

Yeah, I think it can't happen on configurations that always use IPI
for TLB synchronization. My patch also doesn't change anything on
those architectures - tlb_remove_table_sync_one() is a no-op on
architectures without CONFIG_MMU_GATHER_RCU_TABLE_FREE.

> > 6. P1 populates VMA3 with page table entries.
>
> ofc this requires the mmap/vma write lock above to be released first.
>
> > 7. The gup_fast() walk in P2 continues, and gup_fast_pmd_range() now
> > uses the new PMD/PTE entries created for VMA3.
> >
> > > How does the fix work when an architecture does not issue IPIs for TL=
B
> > > shootdown? To handle gup-fast on these architectures, we use RCU.
> >
> > gup-fast disables interrupts, which synchronizes against both RCU and I=
PI.
> >
> > > So I'm wondering whether we use RCU somehow.
> > >
> > > But note that in gup_fast_pte_range(), we are validating whether the =
PMD
> > > changed:
> > >
> > > if (unlikely(pmd_val(pmd) !=3D pmd_val(*pmdp)) ||
> > >      unlikely(pte_val(pte) !=3D pte_val(ptep_get(ptep)))) {
> > >         gup_put_folio(folio, 1, flags);
> > >         goto pte_unmap;
> > > }
> > >
> > >
> > > So in case the page table got reused in the meantime, we should just
> > > back off and be fine, right?
> >
> > The shared page table is mapped with a PUD entry, and we don't check
> > whether the PUD entry changed here.
>
> Could we simply put a PUD check in there sensibly?

Uuuh... maybe? But I'm not sure if there is a good way to express the
safety rules after that change any more nicely than we can do with the
current safety rules, it feels like we're just tacking on an
increasing number of special cases. As I understand it, the current
rules are something like:

Freeing a page table needs RCU delay or IPI to synchronize against
gup_fast(). Randomly moving page tables to different locations (which
khugepaged does) is specially allowed only for PTE tables, thanks to
the PMD entry recheck. mremap() is kind of an weird case because it
can also move PMD tables without locking, but that's fine because
nothing in the region covered by the source virtual address range can
be part of a VMA other than the VMA being moved, so userspace has no
legitimate reason to access it.

