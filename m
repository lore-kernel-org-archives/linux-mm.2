Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E2F5606A325
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 16:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=JyjOgKSQ
Received: by kanga.kvack.org (Postfix)
	id 713CF6B00EF; Sun,  1 Nov 2026 11:00:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69E036B05B1; Sun,  1 Nov 2026 11:00:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E266B05B2; Sun,  1 Nov 2026 11:00:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F6906B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 11:00:53 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8AE1B160A32
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:00:52 +0000 (UTC)
X-FDA: 85387013544.24.36EE902
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5A3E540010
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 16:00:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JyjOgKSQ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793548850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qKQDgkRL9E3S6U2cAM4sdtFLp25slrgCe2pH+1FhaxY=;
	b=07PkV1byZvB/MZtA3psDUfVomLAKNCW0tZ8YfBptDbiKjnM/nCxO9Sb3trMZGEmiNKQNl0
	F5sRTeD7EjvwFhs57Kp1C5vs9VFI5u2eLMcA4OJaQvNnjeEG7scvQ8v0MftBBIVBPi71B8
	+SGZPAbOXhFcreFjo6sQxe7o62dnAIc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=JyjOgKSQ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of surenb@google.com designates 209.85.160.181 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793548850;
	b=MZ0k/9wHNrQZo/Ue9bFzz+6xnYSIlMnQrSbnpLnvSxC92iedu+VyNB5qKK+afh4c1Uw8Kl
	fEyZLKUBe7Q527HClRapbqX4ClbvcaKXPUY0x/1JmX5OCBYgzYzLA1LBYvaivXbKN3S1Qr
	SD1vf4siRVHAE3k1cOdkvvLgxOboTSY=
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-535f598d126so190741cf.1
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 08:00:50 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793548849; cv=none;
        d=google.com; s=arc-20260327;
        b=DmZBZ8eXXfPpdemvvU5ZbfGBVgWrW593S/1gmfr48fq73PkJ5w8uFuoA/kZDTz0Jam
         oygPzHMBmaegcyP5xjvVj6JHhDUU/BnbvVPhawBgor2LWIRkzH0yz7ENBPWFcsfNdD4O
         JxRRDQW1kaSlVgGqrV7GVI+8gPqFYVuPP2JKVu/Pq8IbVPw0ajuZoYrzn47R32I9YvrT
         kkPCgQgPvcUKE31ZFcZwAh7ROa49ajliKXew8Tb1+Mct6ARRcMJBbLuWH7quXTh75eLc
         Q2bBRvES6hM2G9OtEN4xfW6t8vNRVckk3JV17HoxoglpQU1qwAT1iWphgeRw2+/SmJKc
         jXOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qKQDgkRL9E3S6U2cAM4sdtFLp25slrgCe2pH+1FhaxY=;
        fh=JLurGXv2Y/dbYyCA5UYqQMhiA1o9q3QbZpqN5BLrJ5w=;
        b=SHpXmiqptOgEpa2TBCNds4YSdbFSVTizaU0AX43AnVA3GQH91DKVvcbCooFOenmugT
         GCnhSrY1/pe4sF6qSfWXBbtXEnQh4mULNEZGndZbZWrkDheJutqRzKmwMCQTJ4SesUFd
         /hfWualBUJJNbigmhg76huAcmo3iGhX3PTzfQqMnWdp6cnkbBz+QfJ50Ig/TMazJfrbh
         1WGCwlK2OYra5im1tmkdi8X/Aj5Igb30bbhThNRABZF98BMhIP+sRSCaF2ZAILJPa1Xv
         aFOG+vL/TaOasRd02OKRBiJfCPTMB++gaoMZ5QpgT8K+RkrrddK9JAowCrsB1YfAee/0
         NQ9g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793548849; x=1794153649; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qKQDgkRL9E3S6U2cAM4sdtFLp25slrgCe2pH+1FhaxY=;
        b=JyjOgKSQDtjvbFwrMdAjs9PjhdB9usxvKvrXHU8ERfHAreuMTpTHI8gw9V4qn/2Zy2
         rJdb/FOrfeHRVRBL4p+SlECBJwzFlRj4kXgtrBiZEcYrmOZCAMzodKfiOhZKa2WltcNq
         8p9Cp1+RyJRuLncHfxJ7CPIRKAYhGsM1Z8ugCfBiWBzcIWNkFEKTqxGkQxJVQUsz4TCP
         Tw7tEv6UQo1YtyGnRnzvSa/djVv9baLrqvQtNz23IIMIryBOpTqIEqxQ7GYZ+2HgCNrH
         JhPzzLtIKYF0Br+gaOhGjwDNm3Jj5HSSibDrS1/FSEFu7/yICTeaW2HwBunDR5z+7hCg
         Uw8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793548849; x=1794153649;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qKQDgkRL9E3S6U2cAM4sdtFLp25slrgCe2pH+1FhaxY=;
        b=dUAi1u3dLNtqyXnd36kU3M2iilG8cTSPuzTL9TLRjo6ne4IbW1FEff/sIc+bZNysIO
         AU7RMar8Fbd44qIxntSf7AN/wCdMs9fGuup1sQC6ME91EVHzf9OIxbjgqtv7dH1h/nfO
         +y8QsokdidUHBlCpvIpocU2P33a4OqfpCFjtPYfOU+RFcuG0olJ2gmtHgZwBq7M4IYaf
         PcFQSqV/i4ADg/yIjhTT5jlAEU3dQJ1AkoGpK48SRQGeqqETDW6QuM3x0BxTj7hfJdC2
         lUSSQEAa4E7WvnCRSIn8T8ScYIPMB93gA7lR13Lq9t8x/qRR4vSd7OjoARmzEFEZHNkY
         TPaA==
X-Forwarded-Encrypted: i=1; AKwUvBzMLeeQmXNtr9xCTZIt+njjLSWLl4EH1SWdCb29vYjepQQHgvW7IxsLoWO9v17D7hy8YWKdSmv2LA==@kvack.org
X-Gm-Message-State: AFq9FYJ6nGbnJUURTvlfV8QC/zwwe4ivwe/CpnvC+erdHWz/zYV4Vsts
	dKl/Uis6NTfExCTJNrczV7VCwR9XbWRMgZDcoxdF8x+uvKBPTPGgG2T2P/NS54rwETqDUtNsH7o
	dF9Qba5iIOXFXKb0UVHQpTijsJ6CZFcSkbSkC230m
X-Gm-Gg: AYBFou35PU3Q0f8xJr4tbuqK5cnmWeXnx0rLXAYIKaAzMIwl35J/fqS7Y7cSXe7wwhi
	MyU/ZouTQOmM3v+VVge/dsqaMBzWy/ekoyQOijvMZJ5DD57v6Rqt4HiuWAXcLnljqJw9oK5PeYR
	kWSQOKRxhbjBnuVU2cfzdyt03sr9AeYCU5QDDUMfpU1gXln/EzKcOHfumfpJaQ8FTmLXg0rv9Wa
	tnxgcGtMvy+fNbjV8QWUkkD/8x36vffmEgDXHJX3zXE+QHjxlAUalOucREp+xJxiZatqeY6J1MI
	9FF9m/VoJS7bHQ/dGVwlQLigPtnzU+s704oV95TfqrB8wRuqMcPwDmdFfSvVkfY5GEWG7uH0es2
	53A2+xkAC4Lv58PafolCDv4bGTrnShsVKcJY=
X-Received: by 2002:a05:622b:1c2:10b0:546:92f2:7830 with SMTP id
 d75a77b69052e-54692f2886fmr8712951cf.6.1793548848845; Sun, 01 Nov 2026
 08:00:48 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026080329.140244-1-hao.ge@linux.dev> <20261026080329.140244-5-hao.ge@linux.dev>
 <e1cfd568-8fdf-4aa1-a8c5-961bb8d7efba@arm.com> <5b0f90a4-c7d2-4f12-9d95-95c7149c49c7@linux.dev>
In-Reply-To: <5b0f90a4-c7d2-4f12-9d95-95c7149c49c7@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 1 Nov 2026 08:00:37 -0800
X-Gm-Features: AclHuK9081SXnilxbhxPhUG0EsiIt3QEWxeLpuWJxyGCO1FD5elbMhuUvO38YFc
Message-ID: <CAJuCfpHOZPKKd-bGWavBmBf5cmR-PEZO7a_jxXMZVS8tsgG5PA@mail.gmail.com>
Subject: Re: [PATCH v3 04/10] mm/vmalloc: propagate errors in vmap_pages_p*d_range()
To: Hao Ge <hao.ge@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5A3E540010
X-Stat-Signature: jxwex14wfhzoqnohmn9t4mooty6uwug5
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793548850-349984
X-HE-Meta: U2FsdGVkX1+W69KWz5XQBNvAG0ebuMntVPSeJuDcWpfcR0Xwu1klesHu8lFa4GpINiaSlzEjFHzFBUYgkbUoFKq1I/4NrZ7VQ8MGV1J/SfIku7pldCfpCf3jNreMh6+0baSQ1ldPm2DtksMnz2sw8R5QA7KnkZW24dgJtjHMHfoKcRlXwOwGjvk2j/6IlI3Fpq+BKEK5yeX89LE7vkdxdc/AR62DN6v8mo/jO7B1M3VPKKzLU6ZGXTdsMXjLU4geqnbxA6zrKrjBpUGvun90CozSI2mKiNP/FYFRZbug5vxM9GCKbo27ZwVPV9Jcs1dzJtiP81CTfg6SLeSRdNYPikdnHjPyriMeBLmJFidOd5w2jALu2BV00JprsrMF77ml2izPAwTbAjBDMzxkRrS4P7l+tN1XI6cspNGOlIdw+hcQIEFY8BNNR7GCSY9lxoKoRX4rboA55u68E3Kdo4mqg4xuUf5V3iVn1sLVU/2klNcqLi4vLyXutq2yQbFVCGW7hG2FYXRhseKw0IyS9ngGGnVOoPN/o3KQnyWEgjUAwn/4a9u3nJ9LrLB2aCLYUb5SBvQGa/aN5unoLzUeOm+jLVBqb3B+jxBVyADD2hfeXk29nmtE5SUYrFIsCC6//cVfAHxcvRkvnskUOltvw6cDb5yM+XOxzj5GttyUC9I/UKr+2GctLEPiFeMec1ZPG9vzH57Zo/fmVqvhEa2K3q/ON/gKjjYa7f8g/2llkhSNIfoDNBCZpAz3DVAH7mi7Jc32fuA43FE2+XBH8T80S5eBkNayLCjXOmCP+XLfM/GIYfQO0GmJBhB0itMhj/yTmHrUyglPoGTUqm1dujhSqvsJB2A3qZgCkyRDLLfJlHLxpZ/d3sbouILPBwpUUU2usCDpzjvvsJTK3apPQpc/6OUwioQrAqWt7Gj4pxj5V8dhiyYovkH6MHb5zlJEdY6asAbPkt3C9p3E1ObjFSHCvod
 Mit2ZaFX
 /HEP2CCnBqoDoD5lxYnTbz65IcA9lFANUYKB6HMWg58qcMCJOaZzfEXVMSYRDsYAf+/f6OZ7Q0bU9wgQyFXa+b7jpt34n53zFkF8s+n3KkwB0WMlLqfK32/1qY6JBULMq1yB/SY/ENy7a3lmbDwqybaawdN4lonBAeQ46n1CEW2b+zZm/rajtREUswfZKZs+3YoDWBQTyycMKdXKU9L084qscsdsX7uazPdEbnDitwS01Rzfc1q9XaaTxr6b1CVyGg4M+o2BxTnl/Setk/x4+opTCiVT/xLncZxnJLkwwRmcQWShu5wtxBMod1ZfTAW+Dk/1DuUFU3YJZCSVZjbNoe5f0tTza3g1tPOtJ3t+/2no6VyKgvNl42egFrxAUj2gK1XF5AYcNxBMruBu36vASb/GKhmCf+TVCDCyiOjbd/irANak=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 30, 2026 at 2:16=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Dev
>
> Thanks for your review.
>
> On 2026/10/30 15:29, Dev Jain wrote:
> >
> >
> > On 26/10/26 1:33 pm, Hao Ge wrote:
> >> vmap_pages_pmd_range(), vmap_pages_pud_range() and
> >> vmap_pages_p4d_range() return -ENOMEM whenever the level below them
> >> fails.  But vmap_pages_pte_range() can also return -EINVAL for a
> >> page without a valid pfn and -EBUSY for a pte that is already
> >> mapped.  Pass the error up as-is instead, like the vmap_p*d_range()
> >> helpers for vmap_page_range() do.
> >>
> >> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >> ---
> >
> > Fixes?
> >
>
> Sorry, I missed that.
>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
>
> Thanks! If you have some time, I'd also appreciate a review of the
> remaining patches in the series -- or Suren and Uladzislau, if they
> get a chance. No rush, I know everyone is busy.

Yep, it's in my review queue.

>
> Thanks
> Best Regards
> Hao
>
> >
> >
> >>  mm/vmalloc.c | 24 +++++++++++++++---------
> >>  1 file changed, 15 insertions(+), 9 deletions(-)
> >>
> >> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >> index 7131f60d1a8e..d60b99b81ec9 100644
> >> --- a/mm/vmalloc.c
> >> +++ b/mm/vmalloc.c
> >> @@ -600,16 +600,18 @@ static int vmap_pages_pmd_range(pud_t *pud, unsi=
gned long addr,
> >>  {
> >>      pmd_t *pmd;
> >>      unsigned long next;
> >> +    int err =3D 0;
> >>
> >>      pmd =3D pmd_alloc_track(&init_mm, pud, addr, mask);
> >>      if (!pmd)
> >>              return -ENOMEM;
> >>      do {
> >>              next =3D pmd_addr_end(addr, end);
> >> -            if (vmap_pages_pte_range(pmd, addr, next, prot, pages, nr=
, mask))
> >> -                    return -ENOMEM;
> >> +            err =3D vmap_pages_pte_range(pmd, addr, next, prot, pages=
, nr, mask);
> >> +            if (err)
> >> +                    break;
> >>      } while (pmd++, addr =3D next, addr !=3D end);
> >> -    return 0;
> >> +    return err;
> >>  }
> >>
> >>  static int vmap_pages_pud_range(p4d_t *p4d, unsigned long addr,
> >> @@ -618,16 +620,18 @@ static int vmap_pages_pud_range(p4d_t *p4d, unsi=
gned long addr,
> >>  {
> >>      pud_t *pud;
> >>      unsigned long next;
> >> +    int err =3D 0;
> >>
> >>      pud =3D pud_alloc_track(&init_mm, p4d, addr, mask);
> >>      if (!pud)
> >>              return -ENOMEM;
> >>      do {
> >>              next =3D pud_addr_end(addr, end);
> >> -            if (vmap_pages_pmd_range(pud, addr, next, prot, pages, nr=
, mask))
> >> -                    return -ENOMEM;
> >> +            err =3D vmap_pages_pmd_range(pud, addr, next, prot, pages=
, nr, mask);
> >> +            if (err)
> >> +                    break;
> >>      } while (pud++, addr =3D next, addr !=3D end);
> >> -    return 0;
> >> +    return err;
> >>  }
> >>
> >>  static int vmap_pages_p4d_range(pgd_t *pgd, unsigned long addr,
> >> @@ -636,16 +640,18 @@ static int vmap_pages_p4d_range(pgd_t *pgd, unsi=
gned long addr,
> >>  {
> >>      p4d_t *p4d;
> >>      unsigned long next;
> >> +    int err =3D 0;
> >>
> >>      p4d =3D p4d_alloc_track(&init_mm, pgd, addr, mask);
> >>      if (!p4d)
> >>              return -ENOMEM;
> >>      do {
> >>              next =3D p4d_addr_end(addr, end);
> >> -            if (vmap_pages_pud_range(p4d, addr, next, prot, pages, nr=
, mask))
> >> -                    return -ENOMEM;
> >> +            err =3D vmap_pages_pud_range(p4d, addr, next, prot, pages=
, nr, mask);
> >> +            if (err)
> >> +                    break;
> >>      } while (p4d++, addr =3D next, addr !=3D end);
> >> -    return 0;
> >> +    return err;
> >>  }
> >>
> >>  static int vmap_small_pages_range_noflush(unsigned long addr, unsigne=
d long end,
> >

