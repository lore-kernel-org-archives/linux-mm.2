Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18662606D804
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 01:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jL9cbWWd
Received: by kanga.kvack.org (Postfix)
	id EEACF6B05B0; Sat,  7 Nov 2026 20:28:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9C196B05B1; Sat,  7 Nov 2026 20:28:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D644D6B05B2; Sat,  7 Nov 2026 20:28:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA3C06B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:28:06 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 31C9C80109
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 01:28:06 +0000 (UTC)
X-FDA: 85410215772.06.962DB44
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 35FF020006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 01:28:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jL9cbWWd;
	spf=pass (imf03.hostedemail.com: domain of graypanda.inzag@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=graypanda.inzag@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794101284;
	b=fiBNqT7qZUxkv3gcnkPEC8bFV182SFZfli442+Mvz9bRYYc9gwEpAm5lOHgPr+oF6QocRe
	X24Pko2e5i2RMGon9cckNN3yK69daAR5vgAgxNtq4Hp519tIEG8QyBvlrC8lk9LFQFMo7X
	WPCg0yIIDKHfVJ/LkWKsKLO62ICxNM4=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jL9cbWWd;
	spf=pass (imf03.hostedemail.com: domain of graypanda.inzag@gmail.com designates 209.85.167.47 as permitted sender) smtp.mailfrom=graypanda.inzag@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794101284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wMbLBbMUq3a2Z8kRaW3om6dtlh6fobvmaapCy+PWFA4=;
	b=y2krrNchJRBtKB1Wsw7kZJ5ee5lTvRjkT2EbXa2R+5HGX/rwRBaKIzjYBmD/PS6w/MDjwv
	/F4LOB0JpSgYpFn33c6dAL8lr6+t5AqkHCu1ScCcQOetG1fdZC85CWGcitaNwknJ0NEJHz
	IYIgKyv2NWfX0iqU408/n+L4JUcMiFA=
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5bfa65c8617so73625e87.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 17:28:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794101282; cv=none;
        d=google.com; s=arc-20260327;
        b=rbWVwui+hmU+CilzIdN4CyHviWAJaX06vV/+3jE8Qd7G4joVMqdUT3H7J9j4RXYrHk
         61BTCNKVd4nBJMvCm1WoE3FYo2Gta+N35jzmp5LIcM5Ss7JCMkFOMvcpbhBmJ2Ic9lOX
         lK2KQtiGDDNhyQfBy1zkBgbBAqhxpk7g0/tKr/m9uvCGXy3Nz/8g6rLXHMWR5VEsGCJI
         WM1azJ67ylcQW/OfOKrGzOXjfSFaSUJBmBDnNzrkDDbs5xL1iBgqPcBHi8PparOuJE4z
         DCY2eQ+5b0luo6L88fH1EGWbD6vxUv9X3GHQRKq+Xh/xYguQVo0yfUSUy3v3vo+eylRI
         8DGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wMbLBbMUq3a2Z8kRaW3om6dtlh6fobvmaapCy+PWFA4=;
        fh=NBmFixGrgD+RUqGcypoR8ubV5IhYfsj8yM5SppUJsI0=;
        b=WmICEfM+02VnshMq4b9VLLDODPtcg8BmSq+05+dUy02HV6jgE7DH3vD1YGhIeQNztQ
         LYPg4gijNO42r2WtuJOMmIk6dUNf5DPSVlUcYI9tKkEaIfcV8FX5w26vdCOn4/pOhc53
         ZXEwM6jhGUcirpn2666NOorED2Q4Bav+t7jpmF4SzlxwHPoebFHVcJQdqDWgBOcvUjF0
         auEFpSN7jvWvt/jiYVttpwYeG5f4NjjluMuA3EJIgLlhXVss7DFnDq6s5qSBkIMZ2ucF
         kibVU7LUIogpA5JjXV2WLXi4KBoSvGqYfbDy/GMzvh7QdwKUJZYZSeh8g7jr8k2dZ8VN
         lm+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794101282; x=1794706082; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wMbLBbMUq3a2Z8kRaW3om6dtlh6fobvmaapCy+PWFA4=;
        b=jL9cbWWdNRhMcyCu0Sr4jRs4ueQ7Nz+UepNM1cxOc6U6KQ6wct1F4Y+B3A99c/Rv5X
         nqOlTRW1s1DTG96z6T3la7ZQmXqOak7OHEh2Phr2L93oLmyLm3mj4ega1EHjJ2vLOgzN
         wLRAhQVtwqOMFUIC46g8pKdWgNKLncZhXUn9/kp3wO29JFZO+Cub7YRZLsSgu1kicLdV
         6Kk/6r2KuqZLWBzouUWo+QyC/kAjCbFFnbq9upsSFiPlfALCOoipeI7f0SCJwiVlMNdT
         E3szbqsdf1e/6/83tyoeexBQpoO2Ys2lOkcwESizg1Kaz/V/bZ8qetsLyH+ucBuZ527/
         VOlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794101282; x=1794706082;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wMbLBbMUq3a2Z8kRaW3om6dtlh6fobvmaapCy+PWFA4=;
        b=JjFlKgSIe9g5OnA+v4SbN7XIwhF2+yDXcjE7dbg3DXT9sPpVwFxPHg2zGLWO6Eoxcn
         XvOQa2fGdBvagGNEzEcGuy6H+r7tKKYPjOpDt9ODbwOZXcFPAUi9P3v57sgqnWRkjJ0r
         RAjwjUzeHVdGHFjwuFiAQ08VBbu+iv8o72BQsgsOGDBsDWCfyzwDPo7DA7AKxan9e3fo
         Cn6PiJLbS/5+7pBingwEfHlSUb9FjYPJ/ENw9oK6ZWbWmmvKcGKw6yRu17P1kQYs1Rdp
         gasUKPDvp8cH68rHz6h5b9kizir0s0/uiajq5e7dm7y9oqIxRqisoaIhqXYS7mh3knoU
         3Qpw==
X-Forwarded-Encrypted: i=1; AL+hErHvcUnDVco+FpFXdW52L/acjy4vp3bzmTy/GHK78g3ROg0dhJwMV5bVQeuIU4LCo7ixfCPk03woAQ==@kvack.org
X-Gm-Message-State: APuU4Z9qph4E2KFOrpgcIfX1z4p5x7XSaYzsHseIJQivEYdiK/W7exX6
	3/zUfs21plsAKA1VNr+ts66kXfIfb8MrouC17PFHONh5VU5CsYYxnwP+gY7zw3HCwv1nsrMLG3k
	/5+QGffkSTClbirkT0qwop+IXosOT8i8=
X-Gm-Gg: AYBFou0ia9ZGLN1fbt1SzF7pfAU46oWvFlXow0NDraOHoqbFfWCJuHxw6YfNpuJswEm
	s6UHu2LvwJTYrSamA5QKYg5xG4hY/OBQgf9nV2J9N7m0p3RY7F/a406BCkMmtn9p2SywBW3St+b
	Dj3OBHRkdPgz932HRr0YKv0MRyDiyfG5CX3p/GfKjI7q8TcsSwhZFzs3eoV2hiLvUA9u2ayRVLQ
	efFkQKYTfNS7JsbDV4HZ1o5FMl+ZZJYDqiuyWKQPpebk9j+Lq3qTpLzsCgxt2VSa4We4YCSUOSH
	omCYonfUiMLmmWJTHpmBTXlLgVUr+DnP/VOuoE5h5S30cp3YA/nVifL962T74AFPKQEkGqbo8vH
	26vThwOpLauH5nMN0R8DrQCrO5dAIITAc5WpJuA==
X-Received: by 2002:ac2:4f10:0:b0:5c1:49b1:f358 with SMTP id
 2adb3069b0e04-5c14c03a16fmr42913e87.52.1794101282157; Sat, 07 Nov 2026
 17:28:02 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261107030708.1031977-1-graypanda.inzag@gmail.com>
 <c243e6ab-3eb9-471c-9b6e-91064528ce82@kernel.org> <CAO7ntTQGLNtHiu3SY+6HaRZi5gimqjbmw_FoeTSRYpqi1EbnbQ@mail.gmail.com>
 <c15e171b-d0c2-4808-8d42-e5a650b03150@kernel.org>
In-Reply-To: <c15e171b-d0c2-4808-8d42-e5a650b03150@kernel.org>
From: Junyoung Jang <graypanda.inzag@gmail.com>
Date: Sun, 8 Nov 2026 10:27:50 +0900
X-Gm-Features: AclHuK_tFec7OnAi1IvLafTkKS8WjQtkcFaEWLcZl_l-XC8Zv7JX2ViIcQ8LNUY
Message-ID: <CAO7ntTSd_riGK4gVAcO1Tr3eUMgYwGFDJ4m9CRN7J-k22ouQxA@mail.gmail.com>
Subject: Re: mm/mremap: F_SEAL_FUTURE_WRITE can be bypassed via mremap() VMA expansion/duplication
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Hugh Dickins <hughd@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 35FF020006
X-Stat-Signature: 7hm3mt1ix5adqziaofpb1ye6p6im1fgb
X-Rspam-User: 
X-HE-Tag: 1794101284-234966
X-HE-Meta: U2FsdGVkX18Y+et0EXVbz7Zf13vji8bEcytU+CIPFzkqy05VhWtgjz7oolO1OGukNDzev8mfViDY711hf5JATw7Es8L6dZFfkmsf18e9rJcV8gl4GnAAOZkEi8zCHVMfyg6txCazivrIE0YLl3wsT8KuHAHe2BvQja5BjYGx87YInsZEfnhvSdSbKQXLYYOuu9OJlwtRtbPk0Iu1f6RybZnyR1cB3Fi8f/wjkWjYL6nQ7mABtItsQ9cFq1A92bqswCdJRyv26rpqnDRB6pu0g52ieCkEogpD1sA4YbkKjvVMGOmUCkys35xsJgL4RYYxiktEI4xZJsatBLDbK5bO2l0cNZJhERjnnS0eF1SO3J1/q8rae8AoTiZH3e1hFtsJukpXYHlZs+ZxUomuf8COqQ5fAh3IeKqyLOlt5ZTGo2rKi6/YUYAoSgUw688vFjaPFGkkdDIbItLl8DhmgsXnA2b/M2+B2Q34LXLNMZ71ExOPPOxAuQVdjK1hvjMMqyMPj6YgJhRHBeTo0kBh47RLdNBv0vhc5ZCCVrsfnBuM6oVMOWy7M8OBBLxrDTU66H4fKTSsd2ld+e946dW+1oK7uF0hBCW0V81sXfv0oUooreh3vbU+k+wKcMloa1gFXvRPsB2NvXEgjvHcg/6EzlYWlUtY/bWBkF+54Sb8XbVTr8SzjWYuOpwSPdt9SJvKj1PJkXdQhAECCVkmf1TyrYk37dzRamFRqA9T0SMTXEq3pH+FTToSBzutIdMLg1aMMbTr99xuWY9GnF6zAomB8MB3WCru0AIJsjkgzi+uqY85/miFthDgJqQtXbmQ07weJ66lVA32tEjPUJZLUKQjUR7dLfL0Pbnu8FX8uqGCRFvoaNnsMgNZZ/vnBgMKPBET9I0PqmfdyVqG0pdPsNW+2ocDm+tF9Gnb5Mb2vO4tuwzp1Ez1m+XAJywjOJdJkTlmhtXQEZmBGd7dyan+qVsNLWC
 0ptsTQvb
 7XOmjuMgsVnx2CJdSiXCsUhJ0HCC+jP0Xm4dQ5oSJCnpasDERXzCtgr5eN+JD/RDawwAJIDyxGvCWADglbuVFZ5Q4upAMK2uFH7eRlpsWr9z7KMyFvvwTYUOYWl4fzWHI+1TZ5ZrxPKHLsloROw1Kk9X9d0BO7CRDvb1utHlUAeyiLZx0wUNdMQRF8QGMlk7dLWqpxMkMXUIyD4ugaNhLwnJjrW4CEgXIJIPYaMavQJSjeXmCK98ox2Jwqtk+5Li+PoFRf+AIH+Va4CqaX64wxE+IGBEIzcv4N7ngc8g3Qemt+JEMCxV97QsTZMhnEvV3YvUVAdeR+BTKcHpUWofsYF+9qOyd7Cn8f+WDzCAe9b9aUyv19NM2PWV2/VntCVUoj82zf4eDei0R30GglJbF5cKy7V1T1KocoL1QHo9/vE1NLFGUEE9BxwisOfmjVh0PtJ4yPCX8//HPTg03lmK+6ny2qxhiaA2tN48cwPIug4z1Oz0+GEqs2lOJxKDoOLl/VdoxcZFW1NEoVlJ0PzVF2LrbdyAQOsvpJ5zYpdQDQ7I+n9ynS3tMN38LZoNIEhZTqWzX6b1RfghstvzrdvyV5gy3wzYVn+NJ27801TRzci5+DqxYeBaJ7myw2kquYpyDR33DHPFW07Oof8A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

Thank you for the detailed explanation!

You are not missing anything=E2=80=94as I briefly noted in my initial repor=
t,
ordinary expansion with old_len=3Dpage indeed gives the exact same result. =
I
only highlighted old_len=3D0 in my previous reply because the mremap(2)
wording ("creating a new mapping") overlapped with the F_ADD_SEALS(2const)
wording ("create a new writable mapping").

Your explanation makes the design philosophy completely clear:

1. F_SEAL_FUTURE_WRITE is meant to block new writable file mappings rather
   than restrict page/folio ranges within an already-mapped file. Since the
   process already holds a pre-seal writable VMA, modifying or expanding
   that existing VMA via mremap() is expected to work.
2. In contrast, fresh mmap() or pwrite() calls only take an fd, so allowing
   them for a process that already holds a writable mapping would require
   scanning existing VMAs=E2=80=94which is unnecessary overhead and complex=
ity, so
   they are simply rejected outright.

That clears up my confusion completely. Thank you very much for taking the
time to clarify this!

Best regards,
Junyoung Jang <graypanda.inzag@gmail.com>

On Sun, Nov 8, 2026 at 3:16=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 11/7/26 16:19, Junyoung Jang wrote:
> > On 11/7/26 04:07, ... wrote:
> >> On 11/7/26 04:07, Junyoung Jang wrote:
> >>> Hello,
> >>
> >> Hi,
> >>
> >>>
> >>> I found a reproducible F_SEAL_FUTURE_WRITE seal-policy bypass. A proc=
ess
> >>> holding a one-page shared writable memfd mapping created before the s=
eal can
> >>> use mremap() after the seal to gain writable access to additional fil=
e pages.
> >>
> >> F_SEAL_FUTURE_WRITE is not really range-aware. What makes you believe =
that it
> >> would be?
> >>
> >> I'd say it's expected that if someone has write access to the memfd, i=
t has
> >> write access to the whole thing, not just some subset that was obtaine=
d through
> >> the initial mmap.
> >>
> >> Any documentation that made you believe that it works that way?
> >
> > Hi,
>
> Hi :)
>
> >
> > Thank you for the quick feedback.
> >
> > My understanding came from the following documentation and commit histo=
ry:
> >
> > 1. Linux man-pages: F_ADD_SEALS(2const) / fcntl(2) (under "File Sealing=
" ->
> >    "F_SEAL_FUTURE_WRITE"):
> >
> >    "The effect of this seal is similar to F_SEAL_WRITE, but the content=
s
> >     of the file can still be modified via shared writable mappings that
> >     were created prior to the seal being set. Any attempt to create a n=
ew
> >     writable mapping on the file via mmap(2) will fail with EPERM.
> >     Similarly, an attempt to write to the file via write(2) will fail
> >     with EPERM."
>
> Note that "mapping" here means "file mapping" not "folio/page mapping".
>
> >
> >    (Reference: https://man7.org/linux/man-pages/man2/F_ADD_SEALS.2const=
.html)
> >
> > 2. The original commit introducing F_SEAL_FUTURE_WRITE, commit ab3948f5=
8ff8
> >    ("mm/memfd: add an F_SEAL_FUTURE_WRITE seal to memfd"), which states
> >    that the seal:
> >
> >    "...prevents any future mmap and write syscalls from succeeding whil=
e
> >     keeping the existing mmap active."
>
> Right. The thing is that somebody that didn't have write access to the fi=
le
> before (through an existing mmap()) won't be able to gain write access (t=
hrough
> a new mmap/write) later.
>
> Expanding mmap() or mremap() modify an *existing* mapping, they don't cre=
ate a
> new one. I think we don't guarantee that expanding mmap works, but mremap=
() must
> work.
>
> >
> >    (Reference: https://git.kernel.org/linus/ab3948f58ff8)
> >
> > 3. Linux man-pages: mremap(2) (man2/mremap.2, regarding old_size =3D=3D=
 0)
> >    and the comment in mm/mremap.c:check_prep_vma():
> >
> >    mremap(2) documents that when old_size is 0 on a shareable mapping,
> >    it behaves by "creating a new mapping". Similarly, check_prep_vma()
> >    notes that "!old_len is a special case where an attempt is made to
> >    'duplicate' the existing mapping".
>
> Right, the relevant part here is:
>
>         old =3D mmap(NULL, page, PROT_READ | PROT_WRITE, MAP_SHARED, fd, =
0);
>
> and later (after sealing):
>
>         expanded =3D mremap(old, 0, 2 * page, MREMAP_MAYMOVE);
>
> With your reproducer:
>
> $ sudo ./memfd_future_write_mremap_poc
> writer uid=3D10001; mmap=3DEPERM; pwrite=3DEPERM; mremap write=3DZ; resul=
t=3D63
> owner uid=3D10002; file page 2=3DZ; size=3D8192; result=3D255
>
> Assuming I specify instead
>
>         expanded =3D mremap(old, page, 2 * page, MREMAP_MAYMOVE);$
>
> $ sudo ./memfd_future_write_mremap_poc
> writer uid=3D10001; mmap=3DEPERM; pwrite=3DEPERM; mremap write=3DZ; resul=
t=3D63
> owner uid=3D10002; file page 2=3DZ; size=3D8192; result=3D255
>
> So same result. What am I missing?
>
> >
> >    (Reference: https://man7.org/linux/man-pages/man2/mremap.2.html)
> > > Combining these references, I interpreted the intended invariant to b=
e that
> > post-seal writes are restricted to the pre-existing mapping itself, rat=
her
> > than granting the process blanket write access to the entire memfd.
>
> Again, mapping talks about "file mapping", not "page/folio page-table map=
ping".
>
> >
> > In particular, two behaviors seemed inconsistent with the idea that the
> > process simply has whole-file write access:
> >
> > - Even when holding a pre-seal writable mapping on page 1, the same pro=
cess
> >   cannot call pwrite(2) or a fresh mmap(2) with PROT_WRITE on page 2 (b=
oth
> >   fail with -EPERM).
>
> Right, but the main challenge here is rather figuring out whether the pro=
cess
> already had access. We'd have to scan existing VMAs which is just unwarra=
nted
> complexity for something nobody really needs ;)
>
> > - Calling mremap(2) with old_len=3D0 creates a brand new VMA covering p=
age 2,
> >   which appears to bypass the restriction against creating a new writab=
le
> >   mapping after the seal.
> >
> > However, if the intended design in mm is strictly an mmap()-time check=
=E2=80=94where
> > any pre-existing VM_MAYWRITE VMA implicitly retains the right to be
> > duplicated or expanded over unmapped file ranges via mremap(2)=E2=80=94=
then I
> > understand why this is considered expected behavior. If that is the cas=
e,
> > perhaps clarifying this in the F_ADD_SEALS(2const) man page would be he=
lpful.
>
> Correct me if I'm wrong, the only confusion is about the mremap() doc say=
ing
> "old_len=3D0 creates a brand new VMA covering page 2".
>
> And you seem to assume that "new VMA" implies "must be rejected", whereby=
 we
> already have a writable VMA there and there is not really a reason to rej=
ect it.
>
> --
> Cheers,
>
> David

