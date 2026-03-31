Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B97AE10F9307
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 23:30:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDAD86B008C; Tue, 31 Mar 2026 19:30:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B436B0095; Tue, 31 Mar 2026 19:30:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA0F16B0096; Tue, 31 Mar 2026 19:30:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A88D66B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 19:30:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A91D21604C1
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:30:56 +0000 (UTC)
X-FDA: 84607955712.14.1482F68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 703C480004
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:30:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJZGzs8z;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tJZGzs8z;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774999854; a=rsa-sha256;
	cv=none;
	b=c/mgVrLVvPioWZL4zWHmok9YbGrD+2zQGO/Z4kQsvHOrF5nQd6n+guYSosF9bNXn2EhKWi
	IlIkY4FJMeotORcz+fStRla0J5gcoIw/mju+a5iM+isNXhOHFV0NgyyaMx0/j3/3UK578L
	PNh8oNEZi4zY317focKdM7QxyvVLeac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774999854;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A/o0/sjcQGqIus9sOK5w1esE+M1HIpIgFCuepnMfzqY=;
	b=UGdczQOQSuFombuO7sK1u0FMwbqUGBYgazkDz8sLCcVzbNbUS5RRFcknlE6lNqxrAmcUxf
	lLIFrAMZ9krOBEJh4xzBlP90BxfdSxTN/G7yygd4mVfTIT6y/aCGdvNugN1HGC8w7+UC0A
	McX7PeXUegxJTUlSAaIxVKQAo06OOl8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 78B5743A0E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B545C2BCB3
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 23:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774999853;
	bh=A/o0/sjcQGqIus9sOK5w1esE+M1HIpIgFCuepnMfzqY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tJZGzs8zbwAoR3vtyHi20JCRV/kpybgJiqHxMclgLelEEaEecpVM2OlSNhx8vwAZ3
	 F1rOMYOq9ppy5jaB0YYtXskCXFIPjuhZBxkZoaHWIn0SVqtofhZrYS+Wc6zeBKz/DC
	 L/WRZviq8JTIBTmn8iAOfgVPIrC54NjpQtqiOhbyfDm7P0Vbcw3Sy4ExNoUcFpeyYs
	 fCApggBlZDrps0eo8JH9xGaVojvDjQriBIkxfAY+0T9dd2V6VbCwDijzEIpjtb0fYi
	 /RYt8GetfgcspqWC3Ob7h4wJkuZLS4IkCsjP5z5KFgfWrHcqnLTHLBfQf752H1c5p0
	 aIYFLFv2NJdKQ==
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-509134ab2d2so49929061cf.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:30:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWwxv50jJoQkzhlyyBkR0/MRI/Bc7SuUSs2ugXjyNZ4/qqFT/yv8NCAXvPiv9+JR7xKHhnJ09xacQ==@kvack.org
X-Gm-Message-State: AOJu0YzH8TfC+XbugTytBZmUsWCOFw19hWB4lz6E1PJ6VGWbDMZVFgE5
	MOz5OkUJwVMcm61BPc/qHiXVRp5UCAOpSkWAzozQs8kVlWd+kODLSGDK/olq2iWVYa25wmhbESp
	myBcKRcRQhmD/xoATrw0dkaFxBnZiebY=
X-Received: by 2002:ac8:57c7:0:b0:50b:51f7:c671 with SMTP id
 d75a77b69052e-50d3be279a8mr22028771cf.67.1774999852563; Tue, 31 Mar 2026
 16:30:52 -0700 (PDT)
MIME-Version: 1.0
References: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
In-Reply-To: <aec533b2-37a7-4f44-a279-c4aa604206ac@lucifer.local>
From: Barry Song <baohua@kernel.org>
Date: Wed, 1 Apr 2026 07:30:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yEqwVHsG5joEVpuxE4Lki9vC6UJCRrEPNQDGMinyP+tA@mail.gmail.com>
X-Gm-Features: AQROBzCJypNfaVOJDcfL3n22YJc3DzehwQ0tcMfW-dVdmhPGjAIV-l2nQASZ1EQ
Message-ID: <CAGsJ_4yEqwVHsG5joEVpuxE4Lki9vC6UJCRrEPNQDGMinyP+tA@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] The Future of the Anonymous Reverse Mapping [RESEND]
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: lsf-pc@lists.linux-foundation.org, linux-mm@kvack.org, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Ryan Roberts <ryan.roberts@arm.com>, Harry Yoo <harry.yoo@oracle.com>, 
	Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, Chris Li <chriscli@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 703C480004
X-Stat-Signature: 4ezt6jpx5rexet46kjj7579j5c8ff3pm
X-Rspam-User: 
X-HE-Tag: 1774999854-597507
X-HE-Meta: U2FsdGVkX1+BWExWMrIRgQ0ecKzTc2NMoB52aixaLRTIeMRNqKUEhwzyc8Rf3gZU6EeFrkOGliB7wucFcZORZnvM0nA9qkWxcDKQ0cbGg5DvwIy+E3jF3prb44GNpuTuT6vR2g9U+0K9bMQRmUxEIIcsJGSrf+k1/se3EmGdWV9g6/u61ft3aYNUkPh4Eh3y72M65DEX48C1pbMTE+57VHwMEp2savFV65s54HXWBx4LGZ8m+kjDiDYwf1Ik3isD7qyYysQWpJr7KRJxVuBKFK8OBZonCwTVNAy+8A19r8+MGmECyYWvY5nYAc2xv2f35x6nqf0BzfRFqYlyo742KMW6WqM9S09G3kLqAX53cgxfkiPKLSIilPhdGrf5ih0a7LMEyr/HQk9p0uojFHEw6vDihJg0qxDGlOcOJY6/a7+zf+yUoTnUXCE+64Q+8CDRz/1FRJBpn+4Ie2mgJkzwZUjPfnDxn85cYK30NEvl/yoHjWoGq9yi5iq26nhmXcZtKAnq+JFBo1MJ0iXrO/GpFxiBth1ShWyROxNqbxZqH6O/bvg39u3kli1ASF6R2q5dSUth0eI1aaE5dhL/UCyOg892js9NMYILhS9wHY8/eSFWqRupblDE7yvsLmPiafpN0fNUVPCfZc7jjYCgZlic17FKG7J7EcVZqcmzMv6BsIuU47bzKNh8JlfRSWKa4FNnt7Dyko4OFEBfCpXK8UK+V8zf1pAVca2a7WUvFjxiZnS0YZSi+fs4GzXcUxigCXnnR1h3Jzq8xKY9l+KAJYwTL3hTxUdpjmqDNdiEeajMx4n7bIFFW8SHDko2R7USgmZc5FZ4fyuG1ls6U98uxbHDAW29PpJxbe+5rYdako6GCMylYXuR020BPTXaHE/qNbL3sL38tT89nhBB1SQg+EVDhhC79oHCu7kXVijn2ai9c2lENqC9dVm71dNqgMoa+qXCXKeIFl5rQNTG4eAH8Mu
 ZianOoRu
 XYSos/sAfP8FfMacg6Ea0j1+rw2r7sgI0us35Ne7bPa4ej/C+DWVJt8ANxNQBd1BRsSFHyIpYYu0+ZK4TIeOvfrbJOKJffh/VQV2u0GhFa1uPvlayFhSm94lESS5ybD3OT/vKdOhGwPIgQ2EJi8i8DNlKd9kmh5o3xzNq02D2LN1boegq0FUy1Xpg/pfHnObUEGiRfZ46aN+LzmEeffJbE8lkqnDrHHvt/i1tc6teSnH1XnMYhbxmWETeIu4T6lB2dF4GZDOStFKkFK0sd/cYg6+QXJJnrEi4Em9R03uuY7gLVNzAU2NwD/S6WiPPAjBx7WCkSY4LcGjitgyb3bqOLJqeNgXgBITbhd9o0NyElB3Zr20a8GFUVQfjlYY3cyvYIFOi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Lorenzo,

Thank you very much for bringing this up for discussion.

On Tue, Mar 31, 2026 at 5:23=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> [sorry subject line was typo'd, resending with correct subject line for
> visibility. Original at
> https://lore.kernel.org/linux-mm/8aa41d47-ee41-4af1-a334-587a34fe865d@luc=
ifer.local/]
>
> Currently we track the reverse mapping between folios and VMAs at a VMA l=
evel,
> utilising a complicated and confusing combination of anon_vma objects and
> anon_vma_chain's linking them, which must be updated when VMAs are split,
> merged, remapped or forked.
>
> It's further complicated by various optimisations intended to avoid scala=
bility
> issues in locking and memory allocation.
>
> I have done recent work to improve the situation [0] which has also lead =
to a
> reported improvement in lock scalability [1], but fundamentally the situa=
tion
> remains the same.
>
> The logic is actually, when you think hard enough about it, is a fairly
> reasonable means of implementing the reverse mapping at a VMA level.
>
> It is, however, a very broken abstraction as it stands. In order to work =
with
> the logic, you have to essentially keep a broad understanding of the enti=
re
> implementation in your head at one time - that is, not much is really
> abstracted.
>
> This results in confusion, mistakes, and bit rot. It's also very time-con=
suming
> to work with - personally I've gone to the lengths of writing a private s=
et of
> slides for myself on the topic as a reminder each time I come back to it.
>
> There are also issues with lock scalability - the use of interval trees t=
o
> maintain a connection between an anon_vma and AVCs connected to VMAs requ=
ires
> that a lock must be held across the entire 'CoW hierarchy' of parent and =
child
> VMAs whenever performing an rmap walk or performing a merge, split, remap=
 or
> fork.
>
> This is because we tear down all interval tree mappings and reestablish t=
hem
> each time we might see changes in VMA geometry. This is an issue Barry So=
ng
> identified as problematic in a real world use case [2].
>
> So what do we do to improve the situation?
>
> Recently I have been working on an experimental new approach to the anony=
mous
> reverse mapping, in which we instead track anonymous remaps, and then use=
 the
> VMA's virtual page offset to locate VMAs from the folio.

Please forgive my confusion. I=E2=80=99m still struggling to fully
understand your approach of =E2=80=9Ctracking anonymous remaps.=E2=80=9D
Could you provide a concrete example to illustrate how it works?

For example, if A forks B, and then B forks C, how do we
determine the VMAs for a folio from the original A that has
not yet been COWed in B or C?

Additionally, if B COWs and obtains a new folio before forking
C, how do we determine its VMAs in B and C?

Also, what happens if C performs a remap on the inherited VMA
in the two cases described above?

>
> I have got the implementation working to the point where it tracks the ex=
act
> same VMAs as the anon_vma implementation, and it seems a lot of it can be=
 done
> under RCU.
>
> It avoids the need to maintain expensive mappings at a VMA level, though =
it
> incurs a cost in tracking remaps, and MAP_PRIVATE files are very much a T=
ODO
> (they maintain a file vma->vm_pgoff, even when CoW'd, so the remap tracki=
ng is
> pretty sub-optimal).
>
> I am investigating whether I can change how MAP_PRIVATE file-backed mappi=
ngs
> work to avoid this issue, and will be developing tests to see how lock
> scalability, throughput and memory usage compare to the anon_vma approach=
 under
> different workloads.
>
> This experiment may or may not work out, either way it will be interestin=
g to
> discuss it.
>
> By the time LSF/MM comes around I may even have already decided on a diff=
erent
> approach but that's what makes things interesting :)
>
> [0]:https://lore.kernel.org/all/cover.1767711638.git.lorenzo.stoakes@orac=
le.com/
> [1]:https://lore.kernel.org/all/202602061747.855f053f-lkp@intel.com/
> [2]:https://lore.kernel.org/linux-mm/CAGsJ_4x=3DYsQR=3DnNcHA-q=3D0vg0b7ok=
=3D81C_qQqKmoJ+BZ+HVduQ@mail.gmail.com/
>
> Cheers, Lorenzo

Thanks
Barry

