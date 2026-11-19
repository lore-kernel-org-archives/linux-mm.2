Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B104C606A334
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 19:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QbnBCM/9
Received: by kanga.kvack.org (Postfix)
	id 7340D6B0692; Thu, 19 Nov 2026 14:32:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E55F6B0693; Thu, 19 Nov 2026 14:32:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FB296B06CF; Thu, 19 Nov 2026 14:32:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 21B6C6B0692
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 14:32:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 729D1C0BE2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:32:42 +0000 (UTC)
X-FDA: 85452865764.30.B1CC1E4
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf02.hostedemail.com (Postfix) with ESMTP id F1FDD8001C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:32:24 +0000 (UTC)
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-67db23d8892so235397d50.2
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:32:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795116744; cv=none;
        d=google.com; s=arc-20260327;
        b=GOchhbv9UkDx+xd8sNIPBEDxB17fHXVmTTwFAitNMX/nidnQEvdgSdUS42JqV54bdq
         f18d1fhJACbnpy4vMNqh3O4MSELNwRUtvKPPU4S3EToyUHPSWksQCfCrXqqs4Ptk5suF
         aAKETw/SwqaRHrimgJPbZqL78Ld7P53JAEBGZXfg25qKca4Jlhk7PVn+CO5yxWGCpYfW
         Dtbm04QeeFQvlx3ReFGYR4Xtb1jGgl4fSSmh7hBJDhljASN34Y5SnmsLjDSVgoH4TZ06
         nhgGxqgRBT88uzKJubxcNsvgbTBgwFbNZgpfR7bxJxfknWmV83gdcwTL5A7StMXndB0n
         rPyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xv9XMeqz3I69IimX7OB4/p06jGyymD0wx2G8UGKTZfQ=;
        fh=LG/7MJNfiNPUBqoeT3DUliwA7YhmIvcO1m6VbEczvUg=;
        b=k1wFRY+fPAB48WZ2n2A4HECH0xFOgMDgIxlpZj9oVIUKS8Fz8kAcCMJStTUEVivftO
         jD3ZYos8WvUxxBYakPHttogdrlUTAGNbDYshUItWzN8ogxCtVfG8uc+En2vAfDwfLieA
         cAeGr5PvssaFaiyks/oKeGcVNPvf6hXRnJY3a3/hH+EQo9dArRLyrTX7DOyiuvaEgIaY
         yye9HblQ2tC4aJycUku/Aa1WQm5+Z1Ym9FK92L9qTRCsWAlwdxWQjc8dGmt/OXc+oGUW
         E2W0Ddrl9KA7QGelnmttuygIV2MqdRqMcrZk4to1eSTiwyy1WaHgqGSE1IES89ucQufd
         kOxA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795116744; x=1795721544; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xv9XMeqz3I69IimX7OB4/p06jGyymD0wx2G8UGKTZfQ=;
        b=QbnBCM/9/KIZygoy22bS+abTnnuANrYuiX+lnR/uYIUcj5N0eOZ3inXEyh9bYwGPec
         1W4VA0bRxMPRQ25MtoMGZ+SRHELlM7+VojL+AA7rqTb6cMPvJ+tISSntEm8EoZX/jffW
         gLMUcADOgRX8n3VHTaFs1LUAJo0ORlKuq8CGCsVJgBiECT0VznYYbCwoVkd8Jw37H4B5
         emcJ5bgvp6U5UQzi6BeygslT6vnOj7QhjZVOUTsX+DcLv2T3mHJIYagubrgGaUkomLKJ
         pvHa04mlrMXGmXEJXC3kDtqyRRvlqpitcSNYSBi4vRlxOaMWa678TwufblPpRLTV6aEM
         7Ruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795116744; x=1795721544;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xv9XMeqz3I69IimX7OB4/p06jGyymD0wx2G8UGKTZfQ=;
        b=uLqrOuWP72Ea6QxbhcEXMgNOOiDRUsdSBqGQjZ4vjwM8pCUb2o4xTIiU7416tAhFLV
         fIepd9vVJGFWvigCWTeJUF2MjHEIW40i7yKZD5VpmB6/xHeWfqBfnP3G5WD75B691Yxa
         64OVCIv034b9PtcGU/EbI2UyWu0lbONH+jAjVyu0IJhmf2WdLHEyYZ9nvgfx2TwBhTB9
         JtwyrpPMA7epVTNWCKAsLb2ZagxoBR1VXYGaxa5PdZWNBdPu+/EnuQusyu002QsU/6aS
         kXW5xTMSm4E3G+ehQB546JI8veYkRM8wzXeJH6vlOm9IqxzyjJVSSkskLIWzQHP/ayU+
         Ib5g==
X-Forwarded-Encrypted: i=1; AL+hErHnZPI04d7fAEgahpFq81F+uozD92WUgqGPPwGsXDly3PAYbgIqfunnBCrQSTSogZebZzzmpJoBPw==@kvack.org
X-Gm-Message-State: APuU4Z82qyveRzxx3SrOyj873rybg+CReuMnmrb0AnJZ6D8/MOPiNaE1
	FB3Su7gZKy3x3ivqRbtrcnUZi7q/K/anA7kbGpredIgkrqOc+1rfqtNAzAEUIif27wKnbToYzdA
	fFRuXCIAOHDXnGto1CRa+K9bVJNkv85Y=
X-Gm-Gg: AZFdTZcA8Sj58ahD7yl9L9+BHDqdmvKEFo2FvZXZ2NVwetRSrriuItGbDmoIhxuY3N/
	t/8n8izvINtQzorDQEDoXLCoHbON2EeRFkFOFy0495YhXQWP9oLZZiDLKWjp2Bo2Pusc812lpC4
	d/uYjiQ1cEW0YPRAOLsuUXrPlzf1Qfweh5hyXxUFY1noDryg1eRtoMOx2ncxpu0A0ZVtITYT6M9
	oDRgT/XL3buxs4cXjAgxTxPFnB7kbBE6mTQuxh2GnTGjvAuG/Nb0wqta1T4HCF8A+8IGExlLL7+
	90td5idBFpNtxhx3IJONFm4k1hXCDtWhTCYyDXe1+9ieHeJOf8Vndj4Pk9U4aHZqrSZREXbvNoE
	g4PUmW+eLPOzGYH7QwzbjG9vK22kU3iAKB+S7j7wj00+SDmuUyIEibUt4mX42d3RYCLfirQ2euf
	pprOPpMH03pRBdQtQNpE0EbUxE3eI=
X-Received: by 2002:a05:690e:4894:20b0:67d:b54b:3cb8 with SMTP id
 956f58d0204a3-67df43f5c57mr215394d50.34.1795116743905; Thu, 19 Nov 2026
 11:32:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119180015.933433-1-thnkslprpt@gmail.com> <av88TW3GQRvXJDwA@gremlin>
In-Reply-To: <av88TW3GQRvXJDwA@gremlin>
From: Avi <thnkslprpt@gmail.com>
Date: Thu, 19 Nov 2026 21:31:46 +0200
X-Gm-Features: AclHuK8VZBHxgsR35Omg5I3sBSMaRh6fN_PGQ8RGPAjS_X46z1BtoGQn3KkJiHQ
Message-ID: <CA+jvY9E3XD5mJZ7V-+6HFxEkY1FHNGom42F-nxMZNGtOy9POqA@mail.gmail.com>
Subject: Re: [PATCH] mm: skip temporary folio allocation for anonymous UFFD
 missing faults
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: david@kernel.org, akpm@linux-foundation.org, rppt@kernel.org, 
	peterx@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	liam@infradead.org, mhocko@suse.com, surenb@google.com, vbabka@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-HE-Tag: 1795116744-604481
X-HE-Meta: U2FsdGVkX1/M7OsI7uMlEXzYfzeQ6ZR32tot5xpS9U12eTJdkFhqd8Lz1Oksde6dvNDKvFD4BGymm9HT9HjflMVkt92B0KwpFe4oNyfyKtJrp31Dj2uoZjuUUHaK2uGk7JWfCJNjcRWiSqe+rSIe47+D0GvFF9jXB/CKbxxh/dIROULfa/fQzckCVcqujw9E6fZjcShgwtxroa1JhlYZZpJpfNDUl1qaXI7A8w8BgJFuqs4ZUlAZeG+9toqVV0HH9zo1sbM+fdWXIbmA32Do2AG72rGepeV6YGDAMUPFUApyGmO3fzCBxsrEDAxs71IBYprk9KkenTdhbD0AUppzj6Ajf1EiBqJ0gDsxsRSo450NzSxsSkS4wR1CgkrKMrA9trH8tDL4jmZmVr5pqW89ssXncjJ2D65yyq6Rz52D13UhGMy/kUCvXyGGv7Fk8vazL5yT6kmneWI9YuuqpUenG4/nZbDvKpSHyOOlvkwGEaOqbvQUMI6fShjwBlfBrGYh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	FROM_LOCAL_NOVOWEL,HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Lorenzo - I don't think you are in charge of all of Linux and can
decide who can and cannot submit contributions.
This is a legitimate improvement in my opinion - if you disagree that's fin=
e.
The 'word salad' you describe is my best attempt at describing an
issue that this patch potentially makes worse, but is nevertheless
preexisting.
Regarding cc'ing the right people - you're right, it's very hard to
always know who to CC and who to not include - it's easy to make
mistakes with that.
Good Luck

On Thu, Nov 19, 2026 at 8:22=E2=80=AFPM Lorenzo Stoakes (ARM) <ljs@kernel.o=
rg> wrote:
>
> +cc missing.
>
> Please just stop. You sent 7 series across 6 different subsystems over 11
> hours. You(r AI) even failed to cc the right people (added).
>
> On Thu, Nov 19, 2026 at 08:00:15PM +0200, Avi Weiss wrote:
> > An anonymous write fault on a VMA registered for missing userfaultfd
> > faults currently allocates, zeroes and memcg-charges a folio before
> > checking the PTE and handing the fault to userspace. The folio is then
> > immediately discarded without ever being mapped.
> >
> > Check the PTE and address-space stability under the PTE lock before
> > allocating a folio when missing faults are registered. Deliver the faul=
t
> > to userfaultfd without allocating and discarding a temporary folio.
> >
> > In a four-boot native B/P/B/P comparison, the mean UFFD fault median
> > fell from 13,997.75 ns to 13,093.55 ns (-904.2 ns, -6.46%). A guest
> > allocation trace saw 256 fewer allocations in the faulting task for
> > 256 registered missing faults.
>
> A .9us delta on a _uffd_ fault (nobody in their right mind puts it on a h=
ot
> path) with no standard deviation? Seriously?
>
> >
> > Note: this changes OOM ordering. In a fixed 18 MiB memcg test, the
> > baseline OOM-killed only the faulting client before delivering a UFFD
> > event. With this change, the event reached an unprotected shared handle=
r,
> > and its UFFDIO_COPY allocation could trigger an additional OOM kill of =
the
> > handler. A separate surviving client consequently lost its handler and
> > failed a page-content check after the UFFD registration was released.
> > The same handler-death mechanism was reproducible on the unmodified
> > (mainline) kernel when memory pressure was imposed after event delivery
> > but before UFFDIO_COPY, although the fixed-limit outcomes differed.
>
> This is both unreadable word salad and alludes to you causing possibly
> breaking changes for a barely-distinguishable-from-noise fault time
> improvement.
>
> >
> > Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
>
> Please stop submitting patches, thanks.
>
> "You are expected to understand and to be able to defend everything you
> submit. If you are unable to do so, then do not submit the resulting
> changes."
>
> https://docs.kernel.org/process/generated-content.html
>
> > ---
> >  mm/memory.c | 22 ++++++++++++++++------
> >  1 file changed, 16 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 0fb676d..63b39fa 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5547,6 +5547,22 @@ static vm_fault_t do_anonymous_page(struct vm_fa=
ult *vmf)
> >       ret =3D vmf_anon_prepare(vmf);
> >       if (ret)
> >               return ret;
> > +
> > +     if (unlikely(userfaultfd_missing(vma))) {
> > +             vmf->pte =3D pte_offset_map_lock(vma->vm_mm, vmf->pmd,
> > +                             vmf->address, &vmf->ptl);
> > +             if (!vmf->pte)
> > +                     goto unlock;
> > +             if (vmf_pte_changed(vmf)) {
> > +                     update_mmu_tlb(vma, vmf->address, vmf->pte);
> > +                     goto unlock;
> > +             }
> > +             ret =3D check_stable_address_space(vma->vm_mm);
> > +             if (ret)
> > +                     goto unlock;
> > +             pte_unmap_unlock(vmf->pte, vmf->ptl);
> > +             return handle_userfault(vmf, VM_UFFD_MISSING);
> > +     }
> >       /* Returns NULL on OOM or ERR_PTR(-EAGAIN) if we must retry the f=
ault */
> >       folio =3D alloc_anon_folio(vmf);
> >       if (IS_ERR(folio))
> > @@ -5579,12 +5595,6 @@ static vm_fault_t do_anonymous_page(struct vm_fa=
ult *vmf)
> >       if (ret)
> >               goto release;
> >
> > -     /* Deliver the page fault to userland, check inside PT lock */
> > -     if (userfaultfd_missing(vma)) {
> > -             pte_unmap_unlock(vmf->pte, vmf->ptl);
> > -             folio_put(folio);
> > -             return handle_userfault(vmf, VM_UFFD_MISSING);
> > -     }
> >       map_anon_folio_pte_pf(folio, vmf->pte, vma, addr,
> >                             vmf_orig_pte_uffd_wp(vmf));
> >  unlock:
> > --
> > 2.43.0
> >
>
> --
> Cheers, Lorenzo

