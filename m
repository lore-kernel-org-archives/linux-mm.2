Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE802606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 20:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=mULKN0Nu
Received: by kanga.kvack.org (Postfix)
	id B346C6B05B1; Mon, 23 Nov 2026 15:31:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4276B05B3; Mon, 23 Nov 2026 15:31:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AC1C6B05B4; Mon, 23 Nov 2026 15:31:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 50D356B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:31:59 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63424A0A3F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:31:58 +0000 (UTC)
X-FDA: 85467530316.14.EF151A0
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id 549E840008
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:31:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mULKN0Nu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795465916;
	b=u9stZanQcC1g+CpE3959z1FafmTRyhAS6bWapsNR7+0s3IGM5fXrcUMGFa6jC6YoGBWgvw
	jJznarFPfnmQy70Qot9uKda2m1aIEahBeIxADurU6HwH6e3Iv5qcI4ZBJic96NYn7beZ7H
	PkjlYxz/ghNZFEicK2axzINxgOKQ8Yc=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795465916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJsNI40Oc4odODK4rCh9CibKGkLzE8LmGw7dcdr4rMY=;
	b=qdzNHwn19WiBAygX4B8LBLVb23Lf3rwZWtSz9ewXnvYaxfSlQSQDULdj4EN54gg3A/6LPI
	pFHrOUW0iZahqQc4iixFDlaHF8JvLUkjJSEpY6J3jsNhSWOeMZiw+LycBhAUfUNCJxHRF2
	ZKMz98X/Lm1ENsBcg26oiDqOdzUzHW4=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=mULKN0Nu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf12.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c516a574bffso269455866b.3
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:31:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795465915; cv=none;
        d=google.com; s=arc-20260327;
        b=CtGxiugHwixF5uEt5EfK0xQTxXCvUGf0wtm0Nl8QxTZJb305iBE5+zthZuPiMh8NLE
         PdQstiuXiv9gnfb4L5AgDOcCcFjJVSmYtzYAJmH2+tHXH7GAqrlf+q/ijVa6sx6YmBuh
         f3qfkKBGyVtz0Bf0xT5ue5HuoocHjsk0btXdp+BtFCrzyKtdt3T+5ngu+SMsLjSf6/zR
         wKVVVNrS7XupLf3tDl7r52ePPBVlOy6VMVu3JaTjElUK1HyEyiJrRhNMcbwKvBOmAgr/
         5/VL+FaiR/ZLa7Af9P2LWyaogDzE3C+wrMTW6Jf6qw1CPAmTmy5Toxzr46Kcr8y+4YFa
         ZlZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IJsNI40Oc4odODK4rCh9CibKGkLzE8LmGw7dcdr4rMY=;
        fh=YUT3+lThAoEWd8pAg0g9LNm50yGAMafDDtsx6Gx6b4w=;
        b=oTfpaBjRXeOi5qRsszcFOrl+WiAj716mIfIteDPWK1monelFz65T7ge8upwXhWl9Mi
         935wd129rZxW7FfDjrPFz9LjBXbMaREib3CLEluPS0tvI4Rhf8zJhaTZTmmQSay8UwD4
         q72guAt7AVAWUwKw6Gj8Dr4/ahF6wUGiVbKhSlMSQY/evmx0Un7TDDwHyW8kUtezBahU
         RRZESopnqSpWPr4f4F+A13ffmNUO/z28mF4HmsiWmE78Hy/JrKbYuQTQGlYq2WoJdHLw
         xsMDsKQ2gME7TElQJm4qqEcSTa1J7orW1wK29hGGDnkVpbosRi9J31LofdoKM+a7sjMS
         aoLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795465915; x=1796070715; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IJsNI40Oc4odODK4rCh9CibKGkLzE8LmGw7dcdr4rMY=;
        b=mULKN0NuqCjFJMZtJHLdexVdjmZU7tZQuzxW/e7xVjA+oxxdqmNzvkL/011yPLzHUg
         KGTuvg6zGT9r+sZqe2zb24mhFzElM4tBFkZO6AoNK24w0y9U3FezT0AAX+3ocunf/zkC
         co7YUj5w3LDAujMsau7fNl+tJ0ynYZJzlYvAJ+bQJTochXrEYT3rOa8IjuS5t8OFBDOb
         aiUQ2iESccFGhdUaJCAbWeYpzJ8DK31Bp8//9+RiZXSzwMbvz2N1QtBXZ/ZSjQHINrVB
         +gzb+kguc2SpUSfgx57GcoI2x6BOxVa/Q9usLTDPT6SFAern/cjFHpdogXWuw4vNmmxF
         9veA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795465915; x=1796070715;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IJsNI40Oc4odODK4rCh9CibKGkLzE8LmGw7dcdr4rMY=;
        b=rP5o1hFFIa4dsKFT2Hz9TruFxHPZDwYEU+lAIk4KsllbePvEbcos3QEsQI4eBXeLzJ
         TLHwL0rYnOgl0iDFW038Fgx+jiuBSxbAqWEoNX9DK1u3AoKiy4TJw3ZDVLvNjbsvcaqM
         zxk1FWhzSEKb0UAXp3HX1wmTwELx4F4RaaTXITrwxcsOpWjWgMosa6kM7szTpvQBrMW0
         E8jByq1isEMXmdMDsq4FWv07F4YhSAMgvk4H0JJMu8+YgJfa6UO8JFSJqlI+61I1LFei
         UUBwzPtRcvprimfVhM1nwbV0v4j7dOM5kFODb6cX0bZ8lQWQsv3msBLAftmihrlrBIdR
         STrg==
X-Forwarded-Encrypted: i=1; AL+hErGLlCtNg9j9kTSUp1tOFKK6DMsuelnOglnApOtZkAOzA6OdOrQUScNj3QyD+ufHvtXFvBf3QLuIsA==@kvack.org
X-Gm-Message-State: APuU4Z+jfsSTjZgdCMsKJna+6TFEgfbPqR7AnMGSr02L8YEuX5rUDegX
	M4k997CPIxj6Iir8QKr0lSx2eyUOzgTuJDOr6sdDbp5D9KnV6TIH6Cfwak6/3a598cDzsOuFP01
	hzA2QMYOn7m4/GiyfeD2V/wyaxZqh8k6UW/ZR4tHf
X-Gm-Gg: AZFdTZcJ4urrBgCytBMqEmi0dOINCSVmbIjWNBnBjYeaAlClOFII/7E2jMVCObvqmHw
	6VyjWQPnvy3n46wvtBwK6b4LDpYkLO+ac1v7ndr3VYSaQuc2LmlnwFg3+xH/5td3e6/7yOp2X3U
	93bIBZfjYjv/G8moULY1bu9TEaR9xuZe8QOQMwcp5CFcRE+RGtfTqACzaCC1erhk1q/zCK4xAH4
	E6gzc1ubKy5VtQFQ2JkZyIbS/FTk1WDS55JzEX2ksTNpkvN6vc6ChQWwzOdYFtZQhiZhEFdOIHv
	6yK6LEk3Zdzo6i5oslE0ZC3rSOeTomorYl0BjiyvHqaIPGwflpRzxkiCbibR2FuYUKsoREuhoo0
	zNouN7n8ilaBFPVwTjU/rH2i2WvALphV7Mn5Rhvg5GdLslGWxHN2YQ6DWgtO6ZhaJwtdYD3i37q
	eWrEDYXYypyIF0mX5jNjfSk0Ph7YV3L9EvXNEOqY9wfmNWbz5wcVY=
X-Received: by 2002:a05:6402:2347:b0:6b7:d1a4:fe1b with SMTP id
 4fb4d7f45d1cf-6ba37ee380amr9483450a12.43.1795465914250; Mon, 23 Nov 2026
 12:31:54 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-6-jthoughton@google.com> <C1CC6F31-4F75-41D8-89D8-CE43465FBB6C@linux.dev>
In-Reply-To: <C1CC6F31-4F75-41D8-89D8-CE43465FBB6C@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Mon, 23 Nov 2026 15:31:17 -0500
X-Gm-Features: Aa3M54rAEjsqVff0l9eelHjmiyUD7j4I6mswdsQtcR5CMMtlUyAnlGvfFa0vdJQ
Message-ID: <CADrL8HXemwtmL_URg-WNOzdw1YCVxP3HVxX67yd=pLRGAuFyVA@mail.gmail.com>
Subject: Re: [PATCH v3 05/19] hugetlb_vmemmap: Allow architectures to
 dynamically disallow HVO
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: it8rwswh78giizb79tbcnguq4k1gunxy
X-Rspam-User:
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 549E840008
X-HE-Tag: 1795465916-818766
X-HE-Meta: U2FsdGVkX1+QEkuHCqaeM+xrzhqhH2IsGJvZdy//aLS2bpESHX+yUdCkNGuXim9shrZ+yLbUOHGr3NAcesD3KoXhg5lMcKUfATysNbwxmnTkRRl+K1DjF3IsqMYP1yF9FoZJi806v0C56a0PRL4OVFptk4sBeirHyoiD7C2yWLp5uEwYit5aS4mUDeGfFim+XWVFAWDxEwrFaWED6VSI4jWASgsB1iWbG4JdDcrYaP4YI2AtgCGvvAYn8nUPXZ4NRBXCzeLF9ohhH7jYVTZCshe/JyLO5hb7JsotxD64E/02UXxNjRILSkIJwMxiUDUUYcLztEhVK16zYQEbomxGL9eF4p4tr2rVcguEMKDZbE62dNhrr3599oR/c/Ofv7tmQIA5OK779z/jS0mhHOmQST9k5gkZoLKEiiFGtuSZgW4aM0RApDZFnMBLSNZgO0GYtwMtvgVJmrH99ZtB5/3XxxZF9yYbjf46dPbd4JNkRr8/OQtQhwVzA9qzDDZlgqelzEgCieqTTvl5beS1Wdo58mMaaYBOpcOE+rcWFcQjRPIYcv0DijwLJeWaMCcqqV1xEzapkjybcm1gGIfgCiETtdKvJqjWtKgdaWi4uBngHobLx71ShnoKmUfEH9OaqhAeQdcFTssuBsHCXlyLc6jMdxytw/7PG9zKth3jXiSyj3BDhom/XDK5+GdI8ZUWx2p4l2DBZ64MrlIFjHXr+6hc9WHNb/MHP18+K9g0lwqVTaEsh+CZewD2o3kE51llIP6K/LHpOMMmIZAgfvK/EEbaAl/SU95FsYiAiZDRqFi7YOUZGSJyMHO5rScoenE9qgpXkUT4F1rrfA0JOPZW+LovVQgRTQUS9zHkBmoVUdM+i41duEiM4GaGe5GMBsVDbzdvXULOvD7yhAkq0pX1KYlwAtvVEEFCnbYSi9tN0TtAEaMKFkgfiNfCVTB1/OQURMhYavFbW2zaLUMVJQFz6Lg
 Q2Fpq//d
 4T8RX7AOoHuU7VA1pKTkBELx+pHU+JL9zm5XDq5nzbFq9jDt6zKaVtmL53Za4UbNCJcFcZEKMITT72KriOfTf+NZMjsXlZ47JBMavRpVK2UyxBka+51feK+jxbmLLOHuw4gOb53S/XF1isER2g2VaSTiE0ftNOi54Bwqo1bbCQ12C7cotSVCe+fHci7g5Yee9LKGlPHBVESZrVut/V4Lg4vOcBWBd+TlfhngrkYtX8BmoC9aC5MF27VLcT+ZXqxXVz85s1jYo0PayAZqgt/b3ySDvjwuPJNe9C+yBn8Pyc2ePaaOQFpEjfY3FBokwHwA8yAVo6zHivFcO+wMXopyfUgVucPF0NOcJLFIhepy93TziUoQFGgzt9IRpNpY3kU4EZvqN0txH5b2oWnRbNi+vr3iz56XhnLFr1O54qS3VhM9cb814/MaTw+gEcIlhl6xmiclCYGkiQ5jXjgF0kvPkboOudFL8pt1hREa0eXPcU2Sorv4sBAk2qdVE3poMOHOBjlMX+qfgePfpX+QFQTM/jVtnDsVl6v7LogdM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 10:01=E2=80=AFPM Muchun Song <muchun.song@linux.dev=
> wrote:
>
>
>
> > On Nov 23, 2026, at 02:44, James Houghton <jthoughton@google.com> wrote=
:
> >
> > For arm64, only some platforms support HVO. Add an arch hook,
> > arch_support_vmemmap_remap(), to prevent HVO from taking effect if the
> > architecture lacks support. The hook is not HugeTLB-specific, so it can
> > also be used by other users of in-place vmemmap remapping (e.g. FS-DAX)=
.
> >
> > Check it in hugetlb_vmemmap_optimizable_size(), so that hstates are not
> > reported or treated as optimizable (e.g. by report_hugepages() and the
> > HugeTLB allocation and freeing paths) when the architecture does not
> > support HVO.
> >
> > It may be the case that arch_support_vmemmap_remap() returns false at
> > first but eventually returns true. This is the case on arm64, where
> > support depends on a system-wide CPU capability that is not yet known
> > when bootmem hugepages are allocated. Such architectures cannot pre-HVO
> > bootmem hugepages, so they must disable the section-based vmemmap
> > optimization in their vmemmap population path with
> > section_vmemmap_optimization_disable(). Their bootmem hugepages are the=
n
> > optimized when they are gathered instead.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > include/linux/pgtable.h | 15 +++++++++++++++
> > mm/hugetlb_vmemmap.h    |  2 ++
> > 2 files changed, 17 insertions(+)
> >
> > diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> > index ab33df268955..8cf44120e2ed 100644
> > --- a/include/linux/pgtable.h
> > +++ b/include/linux/pgtable.h
> > @@ -480,6 +480,21 @@ static inline int try_update_vmemmap_pte(unsigned =
long addr, pte_t *ptep,
> > }
> > #endif
> >
> > +#ifndef arch_support_vmemmap_remap
>
> We usually add a 's' to 'support'. Like arch_supports_vmemmap_remap.

Oh yeah, I'll fix that. Thanks, Muchun!

>
> > +/*
> > + * arch_support_vmemmap_remap - Whether in-use vmemmap mappings may be=
 remapped.
> > + *
> > + * Vmemmap optimizations, such as the HugeTLB vmemmap optimization (HV=
O),
> > + * remap vmemmap page table entries while they are in use. Architectur=
es that
> > + * can only do this on some systems may override this hook. It may ret=
urn false
>
> "Some systems" is not clear for me, How about rewrite this sentence with:
>
>   May override this hook based on architecture-specific runtime condition=
s.
>
> > + * early during boot and true later, once system-wide features are kno=
wn.
>
> I think the description should be general, so the last sentence I think s=
hould
> be removed.

I think it's important to clarify that the return value can transition
from false to true, but not from true to false.

Okay how about this:
   * Vmemmap optimizations, such as the HugeTLB vmemmap optimization (HVO),
   * remap vmemmap page table entries while they are in use. Architectures =
that
   * can only do this under certain runtime conditions may override
   * this hook. It may return false early during boot and true later. Once
   * it becomes true, it must not start returning false.

What do you think?

Thanks!


>
> Thanks,
> Muchun
>
> > + */
> > +static inline bool arch_support_vmemmap_remap(void)
> > +{
> > +     return IS_ENABLED(CONFIG_VMEMMAP_OPTIMIZATION);
> > +}
> > +#endif
> > +
> > #ifndef __HAVE_ARCH_PTEP_SET_ACCESS_FLAGS
> > extern int ptep_set_access_flags(struct vm_area_struct *vma,
> >                                unsigned long address, pte_t *ptep,
> > diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
> > index 8b28063d78cc..440477288d19 100644
> > --- a/mm/hugetlb_vmemmap.h
> > +++ b/mm/hugetlb_vmemmap.h
> > @@ -48,6 +48,8 @@ static inline unsigned int hugetlb_vmemmap_optimizabl=
e_size(const struct hstate
> >
> >       if (!is_power_of_2(sizeof(struct page)))
> >               return 0;
> > +     if (!arch_support_vmemmap_remap())
> > +             return 0;
> >       return size > 0 ? size : 0;
> > }
> > #else
> > --
> > 2.56.1.809.ga0b61035b5-goog
> >
>

