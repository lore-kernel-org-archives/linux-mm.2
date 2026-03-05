Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA3BBEEF30B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 06:27:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011196B0088; Thu,  5 Mar 2026 01:27:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F01336B0089; Thu,  5 Mar 2026 01:27:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6716B008A; Thu,  5 Mar 2026 01:27:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC1446B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:27:42 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7939C1A088A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:27:42 +0000 (UTC)
X-FDA: 84511028364.19.CB6CB90
Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6CDED40005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 06:27:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D1sV4JxI;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772692060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/G27dhY0y/DuDhe9wyzLhfNIJSU11XcFVQz1aHTUogw=;
	b=XMqTURZlrFaZSM+iqx4EyDKw4cLRHfD/hEb9dhrl6ss98zIvaSN405aJ71D2Icq1SJa6VK
	b6hBkMiwZeNa3b0lEStAt0sXn4wqTzsM6v9tZePRu1zX88xzsT9eTG2Hn2RI9gzSjscTSf
	qMP/yfTUnHFS4vPjgpjfANJBEkk9H/0=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=D1sV4JxI;
	spf=pass (imf12.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.50 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772692060; a=rsa-sha256;
	cv=pass;
	b=JQ1EADxZrunzWVDyWID6ejaQ4pR59HgLJOARN1ftQb6Bo+7mhhFXzIrr3XEnOEL+/i1Qzp
	Cy9t0azm2bIqfICkDPN3pSV1TuEjHKJNtSxVCE+NpMhKU1D3yY+JzGUDjfXY5Nyow4LIDF
	mFTfBv/ySontR+CUw7yTChftm3tYL8Y=
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-899a5db525cso70518476d6.3
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 22:27:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772692059; cv=none;
        d=google.com; s=arc-20240605;
        b=E6iIF2JdFxc1I6jbNr8h7JLF2bJeYa0e4ahKrBLMffJYPNmjJYMmF5FpzXSRqeLZsH
         LrD3LQMXKTMJIHfoTv+4i6askxdo9P3nBlVpXFAw1B75jfmLAyKJYTCPEbEX01rEhIcv
         0z/Q6lQnZzYB1xyTF/EcU5O78gDRT3mkERMNNNMHmaFeknmrp9H2MEx/oIkAVHxgTt0m
         6FoBXRauEkiKECapHrLyd8z6fbUL41Mhgm4pk1wPRgqKfurffyPBuC+RsOZXQbbkkh/6
         ktIkVtg6YQGN9TTgeUuAW9JJ2h2R0f1msLgWuAYgVIVzR8w84bbeYX9cIbUVDKZCXa9D
         wjMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/G27dhY0y/DuDhe9wyzLhfNIJSU11XcFVQz1aHTUogw=;
        fh=GKv9Kbvle7BU43y1VPronMZwHpcbzSUXgbiEF7SsTe0=;
        b=lUEe74q6fB5GhZ4zOWVfc+C6Fe9XGzyfMe9SQPc2fJJAOD3VBfFt2PkwB1VIusr5RB
         vhktvCx2NXzABENSdB/uXTrkzyP0WI+e4pqE1zZV+IXPYzovtlvJg/p9IE9dRmB0Ml2R
         ACjmKplFDPuqWTaOy/F10fp4eQ5VeHYvVx/P3EehRrvhfNvzJacupcrH0Avp94RJxAiZ
         +ncHZdbaa+4u0fc22oM0Jd3+cRCvvbh6CSi8y9tJ1VzOZC4LD7oGsn7+oBaLOgZz+2RZ
         EhKiARhsJpBiBgBxkQVsD0iQVlu0/CVn/aa/NCb2NcWQB+2Mc1hHFZ4O723Miu5TLBcQ
         5nyw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772692059; x=1773296859; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/G27dhY0y/DuDhe9wyzLhfNIJSU11XcFVQz1aHTUogw=;
        b=D1sV4JxIOcKu3vawOpyU3rvN3lHl6xSwEFUM/vl4S/QUgUU1OttFJEr16h5yUluXqY
         a5ELwsBJdGKfy8ej3L/KzVu3HHfhY5ljuZjeilvbJQ4wQ83FGZCECcSNNUNkrN6tODuq
         lsInoQyPUmbT3o79AfOlHtK+Yaj6mCyrd7B6KM+/DhIy7VyN7fMbOP7l8u9x0f0rYZj+
         pswMSIyV4W4ewdOMRSOLr3mbI1j50cdNxNmLChFfgHF48s6qIcYKG3NUXlnc+KaeeK5r
         SyX3LmK28FJNUklMsXlX+M4KZ+5lhp/+jB5PDRccXdRWFXWZ86uxIgR8ugM+7dnwo+Ua
         DwgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772692059; x=1773296859;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/G27dhY0y/DuDhe9wyzLhfNIJSU11XcFVQz1aHTUogw=;
        b=PUgoc24A4px7cZ3ksrI65AHZEWFN5pVw8dGToKUDZN2O5Kc6aqSbcWJJu+47EDYt3+
         dw/Gscw/OW2JDTnPvjTeNwWBhIxfV5S8Di1zs08VfJQuG6TW3H62dXOXO4Zyt2aGBC7Y
         un0uVmKwDlkDbI7hbDYzSW4CKMutDbD0tWkId01zAXEhk0a87gIC6dAS0WyOVeXzO3qM
         oCROo3b8XoE5eRgeynmEYr8q09H0Z2ppI/aK73CES+bAbZTrwgMLReuyBh8UnlEH+Tys
         RQ4ssOxzbQhmv6Wjrk9yaCTa/Xcp6iScpElCTA1bKpPM6068zMU8dYRtGvaSiJyfOmdp
         PPsQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFgZwFs+BEZ1CA0dTaWYoPAidqnpRwdy2QAEfe166tDmXiUvx95AdoAhjjCHhMpURyS4C57zf5IA==@kvack.org
X-Gm-Message-State: AOJu0YzXkY6eizq5To1u9BFyMhxynXDMhnALI/FqnU7gWL2wL8rqnTGS
	HgL79X9XVTvSGK7N++h1VSymHR/IIpoNMAygN8LraUFe+dJXb0K8UkFGw8xOsHjrXZsZvrJQ+4t
	6wWlf3flJWNivYbIAWF3tjdmlJSJS+kk=
X-Gm-Gg: ATEYQzymO91cg1LWnuF5Q1xleQeS50OKuLgjv/C9MIY4XCgKWwNWVJcemkvjHq4gcyM
	55guBKaFGudPOMLSB0aTlUlQd7JFLrEM3T0no9Lf+zqcQEB+8D9WIdWOsAeDrtzjL+NgFLZm7aW
	diKwGxTh0qb1Se726AumvsXsrWkie6go8NrvcDB6hHvaHgdJ+CElB5J9K7xVHrpJCQI8GRsWGec
	ezQm1jLKfnRwH1MpX5DX+b57HE7BvjmEsfwvUHi8kwPZtjqaW4Y5GIG9rPPoHUNeyywUbDiWUJl
	+TAU/Q==
X-Received: by 2002:a05:6214:4109:b0:896:fa50:4c0c with SMTP id
 6a1803df08f44-89a19d08679mr60256596d6.53.1772692059102; Wed, 04 Mar 2026
 22:27:39 -0800 (PST)
MIME-Version: 1.0
References: <aaBsrrmV25FTIkVX@casper.infradead.org> <20260227043139.95115-1-21cnbao@gmail.com>
 <aaXM7xNSJaJBsety@gourry-fedora-PF4VCD3F>
In-Reply-To: <aaXM7xNSJaJBsety@gourry-fedora-PF4VCD3F>
From: Barry Song <21cnbao@gmail.com>
Date: Thu, 5 Mar 2026 14:27:27 +0800
X-Gm-Features: AaiRm53EHpExhPNp03SSjGivtO5ue6KD4LTlE8FVzEhkm5zC3byqYlPWUN6uhoY
Message-ID: <CAGsJ_4xsN2Kfa_f_WaZ-h9Ex7dHk6okyZxnW6oEcXW=kLXwLXw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF] Improving MGLRU
To: Gregory Price <gourry@gourry.net>
Cc: willy@infradead.org, axelrasmussen@google.com, linux-mm@kvack.org, 
	lsf-pc@lists.linux-foundation.org, ryncsn@gmail.com, weixugc@google.com, 
	yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6CDED40005
X-Stat-Signature: znta74hjsg6ez8o9kimr7p9smgypo3ao
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772692060-944294
X-HE-Meta: U2FsdGVkX1/IoR15BZVcdfVHrStqhu4qJGqmlnEjQk/wwAaeWGcYVczaOEggrLttY8Jll9tjWL9OTi3y5Ntw+6oYhfDR4vDb3o3uEtvyFKFPKyBFFBe9B9I0g4fYRr8oD7mkLWFFAcqzPrHTXq7KZ9E3DhZjBEOywwt5seatYCq1pK9/fkI9oiHuyUm9dAMFHwayD/EGJVs3zgosrXfChSt48mS8JdO/FjXuVurGg4e8h8WyoyvzscmIddf0WohmjDxJ7aP553II043WkAZu7Q+ZZVRkFrZ9+PzyZOjmpicmNqPFshaZ315/KBpUUcIXQ7zoWUcIbijvu562dAZKrMGgQcb19cpecv9eP1KXDenHQUmEeHJHY1uOTqrxUTS1ePiXcg5xHZhOn30jgp7YMDG4J8wveE4KkLrOYbwvKwIetydA+YdqyejG42jSce0qyYrbGlD61q/lJUWBvogPYYy6wlU1IiCaMBHyZfalmdHCyM9WOuTY6Z4ASGSFF2Wv5v7baMV7MrpTglr3IeWOYbhLbRnx0qmdwBYYM/I5TU+14tklJqL1UtDhWa37CPDQt2O+nGvC0s6MNFbFJ3c2cIYyYAzNvd8pX0jcdA5m3iYBISPYPXkwNHg3Fr0r3VytEtB2cMxP7aHNOI1R9F/RgRCzFf4YSs6eZObX01bnhSh/IYTpjbBY9QghI2GUvEngxJ7/EsF0kuCVhwhajwWK+BijQkmxSDr+RgtpdUY2Mjz6ouIOrbiVJCeCxnc09S6rbNzyljRCdc8rv7NeIZf47SKW46Ga/gaXJ01KMSeAROd0oglJpywE++zc8MIu+UWU2WVHEXs3J5jFV8ZdCQqqmR3nvSGKReNEXfEC85JX3Uq7ljpmLWud8d3HT8iwnLmhe7lon7py3O+i6p9SWvS65Y8UGrrDk+q5NsKCGy25FJKUYFnnApDWoOfcHEVAOYOWoXYbeD1VohjI2fwD+Pl
 GVk1WOe+
 pKAQQVc2XbczT6e19twsxbkuh2R0J7LjXc/UF+cxtzQq0EANcvOqtTPfWVLBzHlHstU45DT6R3V5HPLPJyjg9DTCqSPQlGKaxHBKBA/0nKmOFjTOjIrT1G4x4MPO3C/vmSL691c6HlePGsh6vNI9Za1z3W4rmD8h2nMEBxB9wEEdjeHrLWZS349pHb+V5svESoAb6rdsaLba/V6g+rlL7Kn9pSd8+LW+yhUoMX6K/eFdhbtUa6xSE2zz3eCNrEUr86bA+wPnKOFQ43hV8A8SKcq6SOU9zKO9eH7tznOulLq/lv5mcUzsGVElosUEMPkjrZJKq37VHXA7yqiYAFXCA4Tn9seU5e/H68/rVXJ2cEWMzg4sQ/JSQqrgb1m7b65BuRSLRkAk6CqQPmSnO9H8OoCxf2LSL7iNoIQpK2B02BOGG61PrgSTeIwMKkGPvUFow/NNIZ+QzAgWaz1HHdged5gzvkaMI0zk0pAfpS6teNTXfU/meRY2OqPdupq1Y6gqVM02x9cZVXpiafvggU81f5/zzwFxrmRzEw24kr1OQyMkiW+suerICszjArUDcS73QJRBdgPFBLRe0twzdv7Q9eNBNWPuTaOwGAAac9bOfP+yferA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 3, 2026 at 1:46=E2=80=AFAM Gregory Price <gourry@gourry.net> wr=
ote:
>
> On Fri, Feb 27, 2026 at 12:31:39PM +0800, Barry Song wrote:
> > >> MGLRU has been introduced in the mainline for years, but we still ha=
ve two LRUs
> > >> today. There are many reasons MGLRU is still not the only LRU implem=
entation in
> > >> the kernel.
> >
> > > To my mind, the biggest problem with MGLRU is that Google dumped it o=
n us
> > > and ran away.  Commit 44958000bada claimed that it was now maintained=
 and
> > > added three people as maintainers.  In the six months since that comm=
it,
> > > none of those three people have any commits in mm/!  This is a shamef=
ul
> > > state of affairs.
> > >
> > > I say rip it out.
> >
> > Hi Matthew,
> > Can we keep it for now? Kairui, Zicheng, and I are working on it.
> >
> > From what I=E2=80=99ve seen, it performs much better than the active/in=
active
> > approach after applying a few vendor hooks on Android, such as forced
> > aging and avoiding direct activation of read-ahead folios during page
> > faults, among others. To be honest, performance was worse than
> > active/inactive without those hooks, which are still not in mainline.
> >
> > It just needs more work. MGLRU has many strong design aspects, includin=
g
> > using more generations to differentiate cold from hot, the look-around
> > mechanism to reduce scanning overhead by leveraging cache locality,
> > and data structure designs that minimize lock holding.
>
> In presentations where the distribution of generations is shown for
> different workloads, I've seen many bi-modal distributions for MGLRU
> (where oldest and youngest contain the bulk of the folios).
>
> It makes the value of multiple generations questionable - especially at
> the level MGLRU emulates it right now (multiple generations PLUS multiple
> tiers within those generations).
>
> One of the issues with MGLRU is it's actually quite difficult to
> determine which feature it introduces (there are 7 or 8 major features)
> is responsible for producing any given effect on a workload.

true. MGLRU has multiple features:

1. lru_gen_look_around =E2=80=94 exploits spatial locality by scanning
adjacent PTEs of a young PTE.

This is also beneficial for active/inactive LRU, as it helps reduce
rmap cost. The Android kernel once had a hook to enable it for the
active/inactive LRU:

https://android.googlesource.com/kernel/common.git/+/76541556a9a3540

2. page table walks for aging =E2=80=94 further exploit spatial locality.
The aging path prefers walking page tables to look for young PTEs
and promote hot pages.

I didn=E2=80=99t observe any improvement on ARM64 Android, but I did notice
increased mmap_lock contention. Disabling it actually reduced CPU
usage, rather than increasing it as the patch claimed. Perhaps this is
because ARM64 lacks a non-leaf young bit, making the scanning cost
quite high?

3. fallback to the other type when one type has only two generations.

isolate_folios():
                scanned =3D scan_folios(nr_to_scan, lruvec, sc, type, tier,=
 list);
                if (scanned) // scanned will be set to 0 if the type
has only two gens
                        return scanned;

                type =3D !type;

This seems to be a major issue with MGLRU, making swappiness largely
ineffective. People have been complaining about over-reclamation of
file pages even when they set a high swappiness to prefer reclaiming
anonymous pages.

4. very aggressively promote mapped folios.

Active/inactive LRU relies on scanning and detecting young PTEs to
promote mapped folios from inactive to active, whereas MGLRU
promotes mapped folios directly to the youngest generation.

Active/inactive LRU should be able to retain read-ahead and
map_around folios that haven=E2=80=99t actually been accessed in inactive, =
but
MGLRU promotes all of them indiscriminately.

This can sometimes be appropriate, but it often overshoots:

void folio_add_lru(struct folio *folio)
{
        VM_BUG_ON_FOLIO(folio_test_active(folio) &&
                        folio_test_unevictable(folio), folio);
        VM_BUG_ON_FOLIO(folio_test_lru(folio), folio);

        /* see the comment in lru_gen_folio_seq() */
        if (lru_gen_enabled() && !folio_test_unevictable(folio) &&
            lru_gen_in_fault() && !(current->flags & PF_MEMALLOC))
                folio_set_active(folio);

        folio_batch_add_and_move(folio, lru_add);
}

In particular, I observed that read-ahead folios triggered by faults were
being promoted, which significantly degrades MGLRU performance on
low-memory devices. I attempted to mitigate this by:

https://lore.kernel.org/linux-mm/20260225223712.3685-1-21cnbao@gmail.com/

5. min_ttl_ms - thrashing prevention

This might be a good option, but I=E2=80=99ve noticed that people often don=
=E2=80=99t
know how to use it or how to integrate it with the Android OOM
killer. As a result, I see users leaving it untouched. I=E2=80=99m not sure=
 if
any Android users are actually using it=E2=80=94if there are, please let me
know.

6. gen, tier, bloom filter

This replaces active/inactive and compares file versus anon aging,
handling scan balance between anon and file.
I=E2=80=99m not sure they are definitely better, but they do seem much more
complex than active/inactive.

7. Missing shrink_active_list() =E2=80=94 the function to demote folios fro=
m
active to inactive.

active/inactive perform rmap and scan PTEs to demote folios from active to
inactive before reclamation. MGLRU, however, seems to always
promote=E2=80=94finding young folios and moving them to the new
generation, while older folios automatically move to the old
generation.

This seems to reduce reclamation cost significantly, as folio_referenced()
would otherwise need to perform rmap and scan PTEs in each process
to clear access bits in shrink_active_list().

Points 1 and 7 might explain why we have observed MGLRU showing lower
CPU usage than active/inactive.

8. swappiness concept difference.

In active/inactive LRU, even with swappiness set to 0, anonymous pages
still have a chance to be reclaimed if file pages run out.

In MGLRU, setting swappiness=3D0 effectively disables anon reclamation,
which can lead to cold/hot inversion of anon pages:

inc_min_seq():

        /* For anon type, skip the check if swappiness is zero (file only) =
*/
        if (!type && !swappiness)
                goto done;

        /* prevent cold/hot inversion if the type is evictable */
        for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
                struct list_head *head =3D &lrugen->folios[old_gen][type][z=
one];

I wonder if setting swappiness=3D201 could also cause file cold/hot inversi=
on?
        /* For file type, skip the check if swappiness is anon only */
        if (type && (swappiness =3D=3D SWAPPINESS_ANON_ONLY))
                goto done;

So, when people set swappiness=3D201 to force shrinking anonymous pages
only, it might put file folios at risk?

Together with point 3 - MGLRU=E2=80=99s swappiness has a much less clear ef=
fect
on reclaiming file versus anon pages compared to active/inactive,
highlighting a significant difference between MGLRU and
active/inactive behavior.

Considering all of the above, I feel MGLRU is quite different from
active/inactive. Trying to unify them seems like merging two
completely different approaches. Still, active/inactive might have
some useful lessons to learn from MGLRU, particularly on how to
reduce reclamation cost.

>
> In a random test over the weekend where I turned everything but
> multiple generations off (no page table scan, no bloom filter, etc -
> MGLRU just defaults to a multi-gen FIFO) I found that streaming
> workloads did better this way.

I understand your point, I'd say there will always be cases where LRU
is not the most suitable algorithm.

Perhaps an eBPF-programmable LRU could also be a direction
worth exploring. We could set different eBPF programs for
different workloads? There is a project in this area:

https://dl.acm.org/doi/pdf/10.1145/3731569.3764820
https://github.com/cache-ext/cache_ext

>
> Makes sense, given that MGLRU is trying to protect working set,
> but I didn't expect it to be that dramatic.
>
> It seems at best problematic to argue "We just need more heuristics!",
> but clearly MGLRU "works, for some definition of the word works".

The goal of the in-kernel LRU is probably suitable for most workloads,
but not =E2=80=9Cgood=E2=80=9D enough for all workloads :-)

Thanks
Barry

