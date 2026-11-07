Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DD8F606A9DE
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 15:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jRD4ufsD
Received: by kanga.kvack.org (Postfix)
	id 7E4E16B05B0; Sat,  7 Nov 2026 10:19:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2D06B05B1; Sat,  7 Nov 2026 10:19:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D9B16B05B2; Sat,  7 Nov 2026 10:19:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE8856B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 10:19:26 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DEDA8120363
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:19:25 +0000 (UTC)
X-FDA: 85408681890.11.0EBF3EC
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id E2FD3180008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:19:23 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jRD4ufsD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of graypanda.inzag@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=graypanda.inzag@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794064764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCe5C4xdEErz55FhjSGIX/KlPHKWFEB9lSGU0iZlRE8=;
	b=0xNxs+/JSHsu9hk86X0Zu1SrRFopyZXCz9Ms8JMCpL62+2NHd3469RrSfxkthmGn5RnSKH
	as2nDTqq0frbgs9ncUYfkiXagd0v2ZF6KkNNUj0rJ0JYiE1HQk3Ww0vL60isl07RpuRUiA
	NG+h+dAZM3p38Oi/euPWWarDMZEApA0=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jRD4ufsD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of graypanda.inzag@gmail.com designates 209.85.208.179 as permitted sender) smtp.mailfrom=graypanda.inzag@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794064764;
	b=V7J7tLa8lWl9sMliE1+X2Rp6NxCLd2/qtVH5y9uGZxeT9bDQpaqbpOwK7HI+uD8H/grBtk
	KF037E2rtFVZm/BAX5MRF8mT9KGIp/UqAkkxhArbynX7UH9cGB9o72yif1XDtGvIQxkdRR
	P8z0aNbfzo/DLjMpLse06b+JL0XvP+A=
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3acc7a0b558so10925261fa.3
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 07:19:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794064762; cv=none;
        d=google.com; s=arc-20260327;
        b=krEnaC++BpwVyxN5c0QxCiJZ2C/PabB2GfynNeeyvrNKIJz0ZbgrpxqCuf9UdxEysH
         zE++DxVttkbwnk/AYAaqfC1UXsnmzmNVK0dqhzuR5dztA3d7a81LCTqJIXz169eruB5Q
         QCAoAzfgzSDVfGLKMkLYkLZCImFTJowNeMqboyGtslsqlqHYuRevJ7AVSKBIIpIzxaYZ
         m7ALv6LkA+At8fRD34NzUvPIQa4ij0BrgkFg1faiL8cxiLMsnWMLsiQqcZApZmDZFX8s
         voYqLXGiPQjeUMLcRohKtaL3j/36ACxxAyToWjeXtbu7id0K5BvHTMy0/gThT5TdfX2V
         K7IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=TCe5C4xdEErz55FhjSGIX/KlPHKWFEB9lSGU0iZlRE8=;
        fh=d1QMtSbIIwkHisEsqsSEk7XC4ebuLDMy+VgW+ydG/tM=;
        b=WGP4sxYjqjvZYrJ0NNIF1mrbK1CkDHfi5pl0iIYtm0iTTL67M0SgHBqd8ghMnCSquH
         gAXrfYr6P/DzCgED/WMu5TmxU0fdHg2/TebPJEkNBGaqEgrsSnrYve5nfX2IFpooMFHA
         ETtk0DbniRlQ5vE/5Khem78cgbp7McVxpK1rXlb3S2tDPJJA+p0kLFbbr0KQ8Tx4dFdP
         SKv1drQ/ELoyDzpmf4YPL3jzH1Qz+VlSRBD2164PgLGmSURVeb+Sq2pVEj42KoI19puH
         /NqyRhE666RR5pBoMcUy9avVpLmfWSHI5QX/RDfLD44i6JicIRuFZjjOhZti5X0qg805
         cWBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794064762; x=1794669562; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=TCe5C4xdEErz55FhjSGIX/KlPHKWFEB9lSGU0iZlRE8=;
        b=jRD4ufsDzD8ATy7EFACDOQek5770OndZ8i1Qxl8ZaurRurHars0NPBs9BwiZv9+1qw
         RQdrPcuhK3WucGIp/nPWIvbn5nIA+P5wjaF73des/Axgfb/HP9065w94g8rZ5dEEf3wX
         MZWePMy9MQClJRDUrcgtjo1kVHOJ5mxMasLK2q9GB1DVSSDWsIYSB2iPPV6h2Z1z4PmV
         YMXtt3+V21D/58UKFXhMcS6/nIkWA9ZeVyvdpveF5UMGcPXHtWvASuajasm407Qo1bjZ
         B72Q2fQHfHjb+zRmWIwCPqodadHPQzSNtnPIoAtyIPivqQh3YRGZ0ptChPMEx7aKTKMD
         XHfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794064762; x=1794669562;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TCe5C4xdEErz55FhjSGIX/KlPHKWFEB9lSGU0iZlRE8=;
        b=qr/Lbw1jVGQ4L82ZvhSPxJjJamJbiS1To4mQmUbTYxBFri32e7d+EA6nSaeS4xVz3Q
         xqmbvENLfY7zDFLvUjuYTM7VMKQaiVZVzzeYuFlrieCuzQBbo0UteaFbyH88wZHhtxOY
         FiyfGRtXedfltQ4LmceV2BYKsL03iHtQNc4v9WeSxuqs6EaNQs/pY+Shybv/iNjbROY6
         ypBio2ylsrG1nkrjP0a54qUoo4FLPGN0o98XmfCGvrhqXR+1mHrbD5iXYd31iSoYQIBy
         okaJOaErs05IwlSkxcNO4ThFnwrmHf7ilyq9dKFoxda8n+BwqH6UUyOqFgFo/f0xj2W4
         iiSQ==
X-Forwarded-Encrypted: i=1; AL+hErHCMwmcKNWtd/XmMAgLRUh65tl+i3MI4ALqHIgCGpdOI30nbz0zQDoZzJsZ+Oz7dxQky+7iYtOsJA==@kvack.org
X-Gm-Message-State: APuU4Z9Je1DFYYYm6+ZUqwmqcSWPKSnmk0PdhPt8MtNH4sW6l4shL75J
	xn3DgdoZeqzAgfwvuyOYY4rKml8Vnkxv2KObnr6VX8Cf75jCg+TwQ/lQ7Rd38d0iCDPHPNYbGda
	FpYnjCk/3oeVPFy9Seq633ACaRgAZN0Q=
X-Gm-Gg: AYBFou0FcL91HL9XlMdwA7Ij6Umpr1ZcLAYMrDPodSkN4plZZ8cnrgnmeFijR/Wi3Su
	mZerC0MiE2O8rIGslO/2SoFW5sM+Hb3uPqk/KpPb2a6kpRp9ud0oyZFrMlo3H9ulA7QaEH2vwnt
	kG6ZoZkaYU7PZG2PUux7lB9AxZI4mfA+MKrZDGs6s+ujE/dTOM58VrdWiQMfAxb6r+hcO9q9cDR
	8X3MFHpw+9qZKYXwoteieG6krBRmkEde/6cvzqY+rDtgyi1puga3fnuCpyySyPPqdUweKIMYlH3
	bTG0ojhBr/FAn7ScB2VZZH9s3kbh7Zaca/8FBy93j3htQHDGQ/0uy3v56FIjT6CPD+dSJObYdbr
	d4r0CS+Dd0fMIeS67BIEgm8hUJdi1g5gDz53xIg==
X-Received: by 2002:a05:651c:31c8:b0:3ab:ac4c:186d with SMTP id
 38308e7fff4ca-3acf3a19450mr11358261fa.13.1794064761813; Sat, 07 Nov 2026
 07:19:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261107030708.1031977-1-graypanda.inzag@gmail.com> <c243e6ab-3eb9-471c-9b6e-91064528ce82@kernel.org>
In-Reply-To: <c243e6ab-3eb9-471c-9b6e-91064528ce82@kernel.org>
From: Junyoung Jang <graypanda.inzag@gmail.com>
Date: Sun, 8 Nov 2026 00:19:10 +0900
X-Gm-Features: AclHuK_dNYM1XnHj7rfsjRaDgzAmEJTriPZ9IjNPu2MGSc4-bhL3xcJuJZ6cHwQ
Message-ID: <CAO7ntTQGLNtHiu3SY+6HaRZi5gimqjbmw_FoeTSRYpqi1EbnbQ@mail.gmail.com>
Subject: Re: mm/mremap: F_SEAL_FUTURE_WRITE can be bypassed via mremap() VMA expansion/duplication
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E2FD3180008
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: rc48i1wtzbxrh8ta93yfxq49oqsfyxk3
X-HE-Tag: 1794064763-353594
X-HE-Meta: U2FsdGVkX18wUwVTi/YvPsSQ3H0eqhI5KAogIjKJ4HkDMaFhV/nkW7OTVviRJHVRqoE3Z+lr/h0ovsvZlowL6gRNHWfI7x7OpnGfm1yE//gMqIcJbzzEoyXMlxA0Wf45ghICDPJl+9PBPSuFbZO+Q1GUJ+vnA8K2e0UCv/B836iZvTq/XVc1sqBnjZ+kKOcqpyEBoxjzTMq07NbHw7xxRJs43iGe9Y3oi6fSWwE92DorxQLTOgJa6IvNj+bYTO0ZZbmS3+cj73d5ViHGyFYMtLTQcqF20nyt/Ly71PX37dBNNhtx9e+TtQ9SNK8KWfhOcdEtRLrc/s6WfZt5VLdFJmFCs6ut3PT1E/Ub+iQSOl3pBRLSVNW8R7ikikAlo/l5o6FdcB+R3cYVKheeS3K5pGx0wz4XBQwk2PfbErp1YSnkmpKNNWAPSoheR/MHcJSz1W+q8am0njTTVeykMj6vG9rN1e/BXXsFgOiHvUom+t8dYFomXdoyqZykPIGfyQ4/beVcExStINVXKfbNmhB9GqRRToWRJy91/xrAj4Gsw3HCyBVKrHrvbRc7YQr9RC8gf/OVZ4s3c9Le791eWLiOWzg47oIo1YEJxO6I0Ct8fQSNqK4j7naV33o436eepZj2jTiExXpFkrutKo8F4bWqWtzJ8zFcXVLj99gYtb9ZLGtYuT500Et2+k37GX52H1yk05dN56o73UwAhIjOLxZiCL9bq4xKsxhXF6si6g/BxVXWOOwSvcFhU0239r0x9CyUl2iFoWXEZr5g2gqXGbojYWIybTQ+AFD0jvKjIsGxRb3FfgMRgNu91VFX7j0Yz6MAjX0B20DcUstz7iXrsXMH+PwNefdwGJPK+uWjWohDtchs5jy+5xz+knjvTTAkSy4plXWHYdheNzz7LX1IqjbQ/gtt6rCkkHwg+UfyeblpnNZ6fzdCllLdTKOrUtROc1APJEGlPSIIVccQyhpHPjX
 8aqtt8AN
 Qid6UfWdcq4o4OhaqlK+uCC20mDscdoW7iRQwVkiRqi1E0E1yVomJHsxQjGcJKIKhbcw9ZHQYhqOBmXbTyxmKevQ//TWqaPaVOoWUX8oxr8udMi5/8l60kl+diY6IZyHUwjDKD3uMiZkgwx08cwvvMg7EV7uhJ6hsXbdyNHUnS5E12EEJS1Y0wYtoFnNDVpeBB9ynj3bRE829V4ZUkLnDfheuwkexdtHH1upbNk8ksd41/Sdpy+jJCmQMiWVa1aRcV34VWSpV89eL3Q5tC7z6u4ZFEauRHNizJkpAY5Fc03KnDtbGAR8NIFkkfnko9wdNZJ77z6ZboeA73349aVwziIq9T30Kp5FCbQlOle0dp4Syl145Mg1g7u5SkI0wNmZwIzpfBTmDjtj7kA4BbMhdgPsDLzl4PqUHcTjj1g/msWOfKSKeiOvKy2eRIVuHDuRdKIAhwziJ8TEeZ2yvXcovcn7dPKq32NXlKHWQAizAxiRobe+wqTsVbeDpQoC6QkSAQBZXBk3WENWbRx80zfd/5ZDCmiSuntqO0SDTltgdBzJnoh2t+kIotwGk6ad7e0263Nvh7KqLxpykpuR0OT9PWjBtjkxxYBG4fQCnjP+p5RZ+tZEa5FnILXSHifGM+rv9zJTJJ+zcAkoTmoA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/7/26 04:07, ... wrote:
> On 11/7/26 04:07, Junyoung Jang wrote:
> > Hello,
>
> Hi,
>
> >
> > I found a reproducible F_SEAL_FUTURE_WRITE seal-policy bypass. A proces=
s
> > holding a one-page shared writable memfd mapping created before the sea=
l can
> > use mremap() after the seal to gain writable access to additional file =
pages.
>
> F_SEAL_FUTURE_WRITE is not really range-aware. What makes you believe tha=
t it
> would be?
>
> I'd say it's expected that if someone has write access to the memfd, it h=
as
> write access to the whole thing, not just some subset that was obtained t=
hrough
> the initial mmap.
>
> Any documentation that made you believe that it works that way?

Hi,

Thank you for the quick feedback.

My understanding came from the following documentation and commit history:

1. Linux man-pages: F_ADD_SEALS(2const) / fcntl(2) (under "File Sealing" ->
   "F_SEAL_FUTURE_WRITE"):

   "The effect of this seal is similar to F_SEAL_WRITE, but the contents
    of the file can still be modified via shared writable mappings that
    were created prior to the seal being set. Any attempt to create a new
    writable mapping on the file via mmap(2) will fail with EPERM.
    Similarly, an attempt to write to the file via write(2) will fail
    with EPERM."

   (Reference: https://man7.org/linux/man-pages/man2/F_ADD_SEALS.2const.htm=
l)

2. The original commit introducing F_SEAL_FUTURE_WRITE, commit ab3948f58ff8
   ("mm/memfd: add an F_SEAL_FUTURE_WRITE seal to memfd"), which states
   that the seal:

   "...prevents any future mmap and write syscalls from succeeding while
    keeping the existing mmap active."

   (Reference: https://git.kernel.org/linus/ab3948f58ff8)

3. Linux man-pages: mremap(2) (man2/mremap.2, regarding old_size =3D=3D 0)
   and the comment in mm/mremap.c:check_prep_vma():

   mremap(2) documents that when old_size is 0 on a shareable mapping,
   it behaves by "creating a new mapping". Similarly, check_prep_vma()
   notes that "!old_len is a special case where an attempt is made to
   'duplicate' the existing mapping".

   (Reference: https://man7.org/linux/man-pages/man2/mremap.2.html)

Combining these references, I interpreted the intended invariant to be that
post-seal writes are restricted to the pre-existing mapping itself, rather
than granting the process blanket write access to the entire memfd.

In particular, two behaviors seemed inconsistent with the idea that the
process simply has whole-file write access:

- Even when holding a pre-seal writable mapping on page 1, the same process
  cannot call pwrite(2) or a fresh mmap(2) with PROT_WRITE on page 2 (both
  fail with -EPERM).
- Calling mremap(2) with old_len=3D0 creates a brand new VMA covering page =
2,
  which appears to bypass the restriction against creating a new writable
  mapping after the seal.

However, if the intended design in mm is strictly an mmap()-time check=E2=
=80=94where
any pre-existing VM_MAYWRITE VMA implicitly retains the right to be
duplicated or expanded over unmapped file ranges via mremap(2)=E2=80=94then=
 I
understand why this is considered expected behavior. If that is the case,
perhaps clarifying this in the F_ADD_SEALS(2const) man page would be helpfu=
l.

Best regards,
Junyoung Jang <graypanda.inzag@gmail.com>

On Sat, Nov 7, 2026 at 10:18=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 11/7/26 04:07, Junyoung Jang wrote:
> > Hello,
>
> Hi,
>
> >
> > I found a reproducible F_SEAL_FUTURE_WRITE seal-policy bypass. A proces=
s
> > holding a one-page shared writable memfd mapping created before the sea=
l can
> > use mremap() after the seal to gain writable access to additional file =
pages.
>
> F_SEAL_FUTURE_WRITE is not really range-aware. What makes you believe tha=
t it
> would be?
>
> I'd say it's expected that if someone has write access to the memfd, it h=
as
> write access to the whole thing, not just some subset that was obtained t=
hrough
> the initial mmap.
>
> Any documentation that made you believe that it works that way?
>
> --
> Cheers,
>
> David

