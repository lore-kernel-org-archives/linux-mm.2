Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1979606A33C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lG3uyAYp
Received: by kanga.kvack.org (Postfix)
	id F3A706B05B0; Mon, 23 Nov 2026 11:13:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEB2D6B05B1; Mon, 23 Nov 2026 11:13:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA6B6B05B4; Mon, 23 Nov 2026 11:13:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B684B6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:13:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 49C3B1A093D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:13:27 +0000 (UTC)
X-FDA: 85466878854.10.1197438
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf17.hostedemail.com (Postfix) with ESMTP id 37C2840006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:13:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lG3uyAYp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795450405;
	b=DyTmcC5sgNiBopkK1Vk8upOlJri8OLA6zkLaAk1ZD+a8o1/3+UHliIzu4zDOdm0tt542pw
	v+31QFQBGvZXTzJRECT8BwYej2z+e0QOX847buTF/kjfEZaPRVfk0gPQds+9VUrCjjctJk
	9bUNftpZilYzwDJDbE40tVBFUyyFFeM=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795450405;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VC60GZZo31yUNr+wgKLno9Qh5+CFy8SXNEOHTmSSUVw=;
	b=NdU/wyOsRNG7PpXqoqUtuI0LfeASOeFSvdMTKpoNxL/fpC54N3zhuEC/HV2FybxOmaNNSr
	rVGzoZ4oQGsLSfxdpYx0YFrGpt0nusCUlVQn3k/Ra0bnh0+W7sz53tYWOzw4c8IvvOroh3
	xXbbozvSI0TffVgpf8Mz40KikwAYubA=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lG3uyAYp;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-54492d8a988so510151cf.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:13:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795450404; cv=none;
        d=google.com; s=arc-20260327;
        b=BmSMlEYDAdWWwl/fn/Nc1K+JL4dVOBYnpWsmbLnm0XCHHpkqJEpvvHMGuxxBs/x7Nw
         qtlaCy+CMk4F/wYZJMv+NBWwzwtVCVjpz/dE0+DWVpOKKwGSAbHtEkj1AwiXMMj5lAqJ
         XsD6jBzkbX3xiXqH0NL6/QiQ4G/mL3kcHw8JY3sohzlSSUSFTHCsAQzA8RvuZ+nk2v+1
         nz7Y3pCnfi1Ad310u8pm2/wMqhtQKK8kGnBUWqYnQzm3Y8QvQpUveGBatUMLYRPmnLML
         Hp4oR2uerNRio4kAFB+Mme8VPjPFB5IMDiNCBZBa5RDQ+Ou//cP6OAz5PDMCprafn08E
         jhow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VC60GZZo31yUNr+wgKLno9Qh5+CFy8SXNEOHTmSSUVw=;
        fh=zepb5xnTQdRWfVjznhAFQPHofu4AwdQMkiF0pse6bkc=;
        b=Dj59aaWSh7gRIsxBHqw/cEnHW7okL+0achaer1RiBwDIKRoQ76vjtcVpY81dAU6M8x
         H/5HCg5O9N7CWRgQhJI+ZvDI7XZ2pUX1l1vqHvVMcUCIzIyvKotlRXvcUpSdXg5ZeSsW
         wlyRPmjvywSJrzYkphHed4QZECZh0S0Py1O6UKBzX6oLeXLBl1blBTqbBPAOH/JWOBtA
         gaTuNSf0pv7t4u5QAe1QSOFIcIHCgCNBNNitm81dKk3O7wLgMqjrecc9Lbg2rvLjQKEg
         qDNA/IukCScZ3P9GV4tBr9hrGWEEnhdj6EDhphEAgNxn0vsH7Y30jE8mYQdUpUuOlQq2
         Kuzw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795450404; x=1796055204; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=VC60GZZo31yUNr+wgKLno9Qh5+CFy8SXNEOHTmSSUVw=;
        b=lG3uyAYpvRM4Pr+dlSrg0N6LuJQHXVvzDQOL9ysLidcGhmqt4fJEKTi7ZCOdYd61cs
         kBIgMURFWD7d7HHIJRSN/oiPxxpvZGP92Hg19r/H266IfydHGfV554C+rcyAo5YC/Is9
         OWvC3PR3/wkiE74vRBgAkUpV9HDwKdrhbbfwLJCleOFmxuwNnXd7wW5W8gtsqhXIacIn
         bXaWeYWyrdIg4EfNx02QkC8WgTQssmD/BYOwKh43gzyDHuqNwGl3/ubQ4KM/I314M51w
         sysgSJ3jeM98BuOPQiulUqYIY3YDwirWC8NeJVA75AmpdrVluvExXsbhha7cC7e8sx5m
         C2DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795450404; x=1796055204;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VC60GZZo31yUNr+wgKLno9Qh5+CFy8SXNEOHTmSSUVw=;
        b=lNV/qC5D2XUDh4xsiJTi4Jn2FxXvSX3gEPWHx7+cBEYo+U2fJ2Ld66A2WiCsyXgtS9
         u7BYUJMhKXzg27BTyvlMGjt4t22O2LkWJAxKA7Ei7YkSXqMG8KseRxnd9pjUQ8WuRgCc
         /RNnsvDJrqVmVgEWvil9J/Coio62m85pqr5QP3/M2YsWdK96/dN57AigOaDhd4dK2TBS
         R0kIWhs3ewMPU9kC4AiCHA03qj7/EWhYeFCIBQ6TaBdrqN79TRJz/Nd15Svo0DCJaWm3
         x29Zgifg9dWQibfehQzsfQdpgdDu6XQ8jMlwzfW4njV8eLYJm2eJ0gAyjWqiOEJ6rOm0
         f91w==
X-Forwarded-Encrypted: i=1; AL+hErHjlSZDui9orc34/BoFgfxs0cMo2Y9iG8vhzLSXeFDhSpBI+TOgwF1O7YTcqSrdRzOOOUm70yeu4g==@kvack.org
X-Gm-Message-State: APuU4Z9+MDVfgsFUkjnjYOtDGUukEMyaiERSwQV//vrg1mUNLzGwsNL9
	hvPjNahZ3E2y+tZNr+tXBZS8wDa4NEe3qxssqmWMgtRJ391Hk7bxNyiSKrGVTj9SXzjTyUN9T0A
	X7NQ1O4+AFHBuWV7LwtMW72qf8+8KGMGW/xSBVyvQ
X-Gm-Gg: AZFdTZfTkgzy+owVkljMNXRjNnQwwgAMVh9FbEW/Eq/FGRXA8zYUuZjJyPriQSQ9AFU
	T3DbpHZLg37WxRftMGX5NM4+hb9qtj/lX/UHbQbf2mGOXP5h6dmlJp6bRJn56fNyLpmSThcYrge
	KWNt0/6olTZEmS0p2s8Rpssod3CG+3VU8mvW83b1dxMJXb/dYUTFa9n9hAehT4893Eihq6LiuDQ
	qhZ0Jlc9Z21Za7dM23ZItAnMDY6x4Ps44KKeP2l59Ddu8NR1exMARrwVQOIfD6X+NKsqR6ZovSE
	vpN95KVadws1f+kRwUJqedSwawBSjAntXg6iLBhYBIkJSIFAU/uO5YO83elYkj7MDeVhSKwjupr
	ExsSjz0FedtqoUAZqjoxU8Vz2OaFX2bu+fDqt8Mj+hipBPvYrLYx47mrJUFsNWULYQVTbjTs=
X-Received: by 2002:a05:622a:2b44:b0:55d:3243:574a with SMTP id
 d75a77b69052e-55d880eb263mr39740601cf.3.1795450403673; Mon, 23 Nov 2026
 08:13:23 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-10-hao.ge@linux.dev>
 <CAJuCfpF_=KV3ArFO5LtMjc4EGMr79tX_tX2K=YCG_JTvC51OfQ@mail.gmail.com> <0e30c5c2-b9d0-40ea-b7f9-af9a8854bd58@linux.dev>
In-Reply-To: <0e30c5c2-b9d0-40ea-b7f9-af9a8854bd58@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 23 Nov 2026 08:13:10 -0800
X-Gm-Features: Aa3M54r0R4skiMgKsHIc0IKP4yYJ-BOLVODQJYPoar_iFImIJ0fTee_iDqFXrIw
Message-ID: <CAJuCfpE7S3uTX2rqEkmYqhO6zuqTKtDH88w20m1_fMHF8L672Q@mail.gmail.com>
Subject: Re: [PATCH v5 09/11] mm/vmalloc: undo what vmap_pages_range_batched()
 mapped on failure
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 37C2840006
X-Stat-Signature: qj6mi55q1ddh85b69w33bsd744kipwh3
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795450405-560043
X-HE-Meta: U2FsdGVkX18IYAM8C2Qshx0J9/ACY8Ymn1jJvKi/fAplHoYkpYiv3U5GI1PH7a+5MrjM2AcvqULmNA3LmBBJGdHw50s/OKFFYFnWkSg48897u9gRAzrQDo0GMSGoTNeMzU8PVnKi2bOj2bVz6eYkIluDTK3pBF6IAS1RiMqXy1F3cNQHb3xge6SX+je6HVMGBdt6bvBG0/81JjZX3bS4FPwukCMX9bZiWqZB2HloQx3kpRr5zUKT0mc/z87FZNHDPRW+6uvlYci/kvgws+nJLpQ/4lnXQnlfc+VuDtNwMzs/m5J59AiRBmK+f7j6xoVlXw/OqGj3PpEq9dS4VFjUkoSas3V79npXDTISJuov0rzJFHng6zCpttH8i+KGOSY9tdf+ZhnsJ9OXrA31mo9w1khtQC+DEIgBtmVFF281Z9rdPr12oigJRZ2aFzHURWoBqnf8e/kQhznc08FqZHNmcnQTqYvtsVrB0QRhVjxbbCDiNQoFnUDx1Jz8J1Bbf0sQ9wiKfY65kQra3FWwNCU+F+ITalEvTvj7skRKrNB8LN9A1fowqI/frv5CPKzg0oiQog958PammOAIza+Lo9Yfigep3Fmn7TQJfSMu3IuSd+aOdNsVeAAWQAUk2p+QrXRL/AXMbfC2zDWtwa/RBRe0qWWPtuzxSzdKcNZP4aQpsBkTpbrknN9C4SviREaTCUldS79g2Kx3hEVHhhMW9N7o0nBEP0LHCSw0iqEeo4nMohNI4Ly+sRiYJh4qRfc5ISDnRYp8vkJ6z9kY95tw9GDQBTBCTWPdvHivUycthmJy/xaA7rpN23OXlgQ7aXOb/o7YYG63kYFtvnBXvgs4GwRA1k+dlEAnQKKcsH2NXpKPblKRONkIrSCbhQZybR7VEEH8Ldpit1/QS6pxEzVnXKGVEKdVwTiAQYkVb/KVPTZr1aLLDmUDnLMKUeJ3HVFNR5GvlxsMYUmdcTaEJhY3Crc
 FpAddx2N
 H44m/SUqckpTBfKYaxq+qG1/gm77v2mqggo1r97BTpW01Y4EIzf+Bt7CqngryMG4Bwfw3MnZJikaiVr6iqgi1TS9O6zHKFDyt3x1YhmJpj07JpAFxzksNdPLGo6E+OXtFdKa9fvWZwVkCacsJ0CuCalAX+IpK9eS0+K/7t3Q6FsWtWCWTYNxUrdQAf3Jl8+f7Mkw/DCIGmXX+BJQ0/eO1zD6osucMDdEY9qhOmCIcdjpn9/6xDry0VZcZQ88e+BbO53a0tfP3bbeqldL687d5J7gwEDkpz/+iJt1kXNt2zFlN45rHpBFgAcujCfhdRvSMsxNIfMAlHE3gVic4gBfE0JUuVS+oY2uobBMsgL+cR6QUuXURULcJQbd9RqfRsc+vbvT3TF0IOMek3h5lP7K6+FDWmeaDFi4ggCI0W/SjpWKM8Aj+iKhT+OErksthQAxpNqBjerNQYCP9N2MV2rIZVoZGHNK8pkjuTkElU9hhmEH0Uhvlh2xOZ395MhrupuW4dM5VtWna750McT7JHsgQWplHZAhg/U4jgxVdlyYIr3pjnQFNteX8ghpj6HCVXdejRlrlf4grEKWK2wU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 3:32=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Suren
>
>
> On 2026/11/22 12:13, Suren Baghdasaryan wrote:
> > On Sun, Nov 15, 2026 at 11:14=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrot=
e:
> >>
> >> vmap_pages_range_batched() maps the range batch by batch. When a
> >> batch fails, the batches before it are installed, and the failing
> >> one may have installed some of its pages. mapped_end follows the
> >> end of the last installed page, and the error path undoes
> >> [addr, mapped_end), never past the point where the walk stopped.
> >>
> >> The KMSAN metadata is set up for the whole range up front, so it is
> >> torn down as a whole when the mapping fails, like in
> >> vmap_pages_range_noflush(). The only caller, vmap(), also calls
> >> vunmap() on its error path; the double teardown only walks over PTEs
> >> that are already cleared.
> >
> > As I mentioned before I think this patch should be merged with patch 7.
>
> Ack.
>
> >
> >>
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >> ---
> >>  mm/vmalloc.c | 22 ++++++++++++++++------
> >>  1 file changed, 16 insertions(+), 6 deletions(-)
> >>
> >> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >> index 28e65073624a..aa80bc273ec0 100644
> >> --- a/mm/vmalloc.c
> >> +++ b/mm/vmalloc.c
> >> @@ -3748,13 +3748,14 @@ static int vmap_pages_range_batched(unsigned l=
ong addr, unsigned long end,
> >>         const unsigned int nr_pages =3D (end - addr) >> PAGE_SHIFT;
> >>         unsigned int prev_shift =3D 0, batch_idx =3D 0, nr_mapped;
> >>         unsigned long batch_start =3D addr, batch_end =3D addr;
> >> +       unsigned long mapped_end =3D addr;
> >>         int err;
> >>
> >>         err =3D kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> >>                                              PAGE_SHIFT, GFP_KERNEL);
> >>
> >>         if (err)
> >> -               goto out;
> >> +               return err;
> >>
> >>         for (unsigned int i =3D 0; i < nr_pages; ) {
> >>                 unsigned int shift =3D PAGE_SHIFT +
> >> @@ -3764,9 +3765,10 @@ static int vmap_pages_range_batched(unsigned lo=
ng addr, unsigned long end,
> >>                         prev_shift =3D shift;
> >>
> >>                 if (shift !=3D prev_shift) {
> >> -                       err =3D vmap_pages_range_noflush_walk(batch_st=
art, batch_end,
> >> -                                       prot, pages + batch_idx, prev_=
shift,
> >> -                                       &nr_mapped);
> >> +                       err =3D vmap_pages_range_noflush_walk(batch_st=
art,
> >> +                                       batch_end, prot, pages + batch=
_idx,
> >> +                                       prev_shift, &nr_mapped);
> >> +                       mapped_end =3D batch_start + (nr_mapped * PAGE=
_SIZE);
> >>                         if (err)
> >>                                 goto out;
> >>                         prev_shift =3D shift;
> >> @@ -3786,13 +3788,21 @@ static int vmap_pages_range_batched(unsigned l=
ong addr, unsigned long end,
> >>         }
> >>
> >>         /* Remaining */
> >> -       if (batch_start < end)
> >> +       if (batch_start < end) {
> >>                 err =3D vmap_pages_range_noflush_walk(batch_start, end=
, prot,
> >>                                 pages + batch_idx, prev_shift, &nr_map=
ped);
> >> +               mapped_end =3D batch_start + (nr_mapped * PAGE_SIZE);
> >> +       }
> >>
> >>  out:
> >> -       if (!err)
> >> +       if (err) {
> >> +               /* Undo the part the batches installed before they fai=
led. */
> >> +               if (mapped_end > addr)
> >> +                       __vunmap_range_noflush(addr, mapped_end, true)=
;
> >> +               kmsan_vunmap_range_noflush(addr, end, true);
> >
> > So, you are unmapping (addr, mapped_end) range but removing KMSAN
> > metadata for the entire (addr, end) range. Is that intended?
>
> Yes, that is intended. The metadata for the whole range is set up
> before the mapping starts, kmsan_vmap_pages_range_noflush() at the top
> of vmap_pages_range_batched() installs the shadow and origin pages for
> the entire [addr, end) in one go. So on failure the metadata is fully
> installed and has to go as a whole, while the page tables only reached
> mapped_end and are undone up to there.
>
> I know this looks somewhat awkward. The asymmetry comes from the metadata
> having to be set up before the mapping starts, I don't see a way to avoid=
 it.
> Maybe add a comment explaining this?

Are there any side-effects like the one we found earlier with
unmapping PTEs which we never installed?
I don't think a comment is needed as it's quite obvious.

>
> WDYT?
>
> Thanks
> Best Regards
> Hao
>
> >
> >> +       } else {
> >>                 flush_cache_vmap(addr, end);
> >> +       }
> >>         return err;
> >>  }
> >>
> >> --
> >> 2.25.1
> >>

