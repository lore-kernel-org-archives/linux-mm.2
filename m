Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65C0DC5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 00:21:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 728C36B00A2; Mon, 24 Aug 2026 20:21:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8AE6B00A4; Mon, 24 Aug 2026 20:21:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AB296B00A2; Mon, 24 Aug 2026 20:21:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2ADDC6B00A2
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:21:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAC0AA265B
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:21:06 +0000 (UTC)
X-FDA: 85137886932.09.5F4C539
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id AF83C1A0003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 00:21:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y91rY8Ca;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787617264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOccCJ+s3b7MTFGKQlT/SH3M4GxfcnJ6QVVNw7oc3jc=;
	b=fX8VDoYbsIVdwW1Ry1hxDk2sKCIAi2MvJV2w5rLcB281l6Wqi7u4fFE8vOknYnFpZBL/QJ
	LE2hdUZ+ZPmsa2uX0o/43PXDBdXvt5mCem4lcPXVc+eVSOB4eXN1r10M4doOblZmfo/ap0
	sQVFHKWM7+Cs2zIEQ20DVnL+o/0W+/I=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Y91rY8Ca;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787617264;
	b=opEudP768E9BYu1S7cfHsSGbeA7Nb+KepdrfQpO48HkMuPSIW78GmtWb3IVBeeBf3dPldc
	ZlMwBmlG9ZvX8ocOzKTP2xImXcx7YvFUW4MkJEY2NFDzquX1TltGFyju5Rtmz7RFjPKUOv
	Mp78PVUkvXzYGlP7ID2m0t64v5T+xT4=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c1712a04ddaso695981166b.2
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 17:21:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787617263; cv=none;
        d=google.com; s=arc-20260327;
        b=pJFD5v4DpDsDa0cIGEiO1UogkJE7QKMWcWZ/0dBN4cnZ5Cc4Hnz1TSNiKoQHYU2Ctv
         Xfvrj7zNPAYF4YwQDqYAqUyjYPxvyc7sUeSSQdxfVBf9U19u04zZECunUPh0nTg5TJNL
         sBEo9g/YjRqmZSM83pimMHf+0wXvumscHyyufwhKt64ayaRg3VWfc4dAzSyeZ+xYuo3m
         3MsExH0bUCta+PQ/cj9CVp1b/t1z5eWHcGteboH9s3DzoHGTZbXhT7hxIEVKgl5+m5QJ
         oMBHQ32bw3ydTjevxKEr6UcjeTcSfUeFlH3p+4wIusht+EwzklDqUnFrAjOLHLd7UFWm
         /p6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MOccCJ+s3b7MTFGKQlT/SH3M4GxfcnJ6QVVNw7oc3jc=;
        fh=r+OMbq0bj1FLZEZMhptVAuJyteKi56TShIbCZwi3Rck=;
        b=grQoD4eMtu0428RZswjdV3XdlXXeEyWiXuMFIJ3mDBqdJda+haGb5qYujJxD6R/l2L
         ix2WWEickaHtMXBZsyCC4LZF6uVM5xp0touo4dP7MbxFlfYAeatAFSwmDWM+ZumQ1fD7
         IqqrPXjPJzLBOZRYEvIh68JNh+c11DDOWQuD0Pu30AulLtsbHMaKWuUDEvWyNZHzyrpn
         LHbRckKPkRUJn8HPxJZ3Y5m3yWlfLIWCjUh03Wr3b0Jk+FwiuzialBnTQbp+4gxAmNCB
         uPITHn0ohzWPI6cAbqQKE+p9jXterPspa4K8H5Tx81eE0OUkVVQUeBLKoRbVZYUKb3R5
         KjAw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787617263; x=1788222063; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MOccCJ+s3b7MTFGKQlT/SH3M4GxfcnJ6QVVNw7oc3jc=;
        b=Y91rY8Caj6/2BLqMb880cW/1DslW49tK98kDDZHlDbT9WdA9I6DDKpAwG+Dg4OKXj9
         saEAgihGbgx1B1Jico7bYcZZIDYClBqwQ4+6MKu4JSxlZjLlKhU/+UQ4aKql77ViKRUk
         71Lyn90yq5R3PVG88CGbxcwIPasteveG/9YO+T6PCSaJxc9E7l9FuZzCi39YllxmmVpo
         tFedXyrBNvD+8aUTizS2hREZBwCMwIbG1u6YsI1SBFQ5FnDuCinG58zsyWC6ALxFNDFF
         5L3+BrmbbxLAhGBGwawW6y85YL6dFC33rMBKKhf44P0vDg5hZtU7c5nbvcyIu5i5EYoA
         uD/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787617263; x=1788222063;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MOccCJ+s3b7MTFGKQlT/SH3M4GxfcnJ6QVVNw7oc3jc=;
        b=ifsxnuFjopaCivgB+jhu99mMp+eWv9MX90Pxh10KFxmKClXLNTnronF0VA/pVVC84B
         JcMq6cmIma5t2RO1ND1eUmJIYm+yerb9KeSVPorxRmZ3a3uuW8MfHO4oDpZVlVzRCfSh
         pjuN6wECXziPMJeGnKThn8UUPWQo8DJRttnN/U4iVG2fHeuAZO2YLyFg7JEhfrTWWEFx
         soFX02mHsSrjDgQCEf6raTGbjcfCl5zAhlGr/ScJtcTBY7sgGLGD4aCs5wK79SSnSMb5
         TfUiLV12MOC8RjPDHVqT6dkH3QSm4Kz7FHs+fX5sYIyHqchMrfUqaDHJRQGthcFMqgwK
         x0nQ==
X-Forwarded-Encrypted: i=1; AHgh+Ros/smwa+WookXKf/IZqdFHcZHrgKHjolKOpeZ/PDlPY+Ap6eR7I1UMFy1+8ek5fmjX0OgclzzpNA==@kvack.org
X-Gm-Message-State: AFuF++khk7eOuRyhBekQJzFqhqqLq26pbhXeRgHDs4Kk7A7Pdp2d/Hn5
	n1rzN7miPpUkTtxNwjNMFA+tnr2/h6EoBapobO8tck7Sn9HZ/VMDm54+YeIzh293olYNsAPBPzx
	iS0r1vgpNseOJgwTi+hRNulFRDq7WsL/TaHUqqUJ5
X-Gm-Gg: AR+sD12fLNSw95R8K4z1tPOWsceaXdW0XVOnx69zNb40rSH3I19ad0UrjR9Je/LZeOH
	j0DS1iYNa6vWMfLftE7KJUiCtTYuRNmpeINhuj8q1OjJmHn16rej41JADMo+WjB/75xl2rFF7vO
	7awUos3/sPTp/VT/XVNuuR0t5WxanCdnkifLZC2g6e2jISlxuDYJUxJhcxn42ojvrfj+8hVPsju
	M4ZltmGv/vJdqhc/pg5reOAxt8BlKAkkhSgEq4UMXenah5vBPyJDJaC52CF5+oRgQbqVvwp9Fc6
	n1l2/BA39ZEKMZfOW1GzZMMmGbEz8NgGvGqUTimw77Topl5xjAWCXlowq7JKXY+/lFzdoiZ6MqY
	NxamEWMuXxOwLH5sCQ13ivJxntNqLtI0Wh/7jg2gxpp1S7ZWBoPefg4EUW3xee9kdY99V/XiHpv
	4Y7NqC5HedVHvIFrmcoA==
X-Received: by 2002:a17:907:930e:b0:c1c:4e36:eec6 with SMTP id
 a640c23a62f3a-c2492099898mr2233901066b.18.1787617262791; Mon, 24 Aug 2026
 17:21:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260708031129.3503195-1-jthoughton@google.com>
 <20260708031129.3503195-9-jthoughton@google.com> <aoRn3Fn1dhTdsk6d@arm.com>
In-Reply-To: <aoRn3Fn1dhTdsk6d@arm.com>
From: James Houghton <jthoughton@google.com>
Date: Mon, 24 Aug 2026 17:20:25 -0700
X-Gm-Features: AcwNN1VDT0z61JeW37ejfojh06XWJMZpjbgbk_244A1kNUnBGA4i1Z7ktlukd9E
Message-ID: <CADrL8HVaa9a=E3+ABThCFzZWd15RPvXzR3QafDrztgJMAoG_Nw@mail.gmail.com>
Subject: Re: [PATCH 08/18] arm64: Implement try_update_vmemmap_pte using the
 AF trick
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AF83C1A0003
X-Stat-Signature: z7ac3es5bakxny9edkshjhxigrc97g8p
X-Rspam-User: 
X-HE-Tag: 1787617264-545808
X-HE-Meta: U2FsdGVkX1+KZj7MmyYikM6GCiGF2WQvKsGgzTY3bf5QBZ9uxBLsf5NkAQ10Q9zsk+aD7JnadVAxV/F+uD2vCExZz+r2z4torTL6EUze/7n0sT1ExKFH1jM+4G2grsEJjGswhgzf6dP8z9lD+rmvo/8PI9X9xpnZljDl6Kr0Rt42Vx4FGJZAw/5sYl3enhL4Gir3swE6tjVvJekPHRkjGLcNKsNPfUE61F8J74Q5JadyInKhUFipHzXnuhVz2WiTzqIAXcrlcU98cSvcihKFhvZQPnRS3lUsUIc8MxlYa1Le1JLUWUiTzkYHbxwK2xFAyuObf7P8utzQLht04DLrPIDXlWzC+GAAxwmRWN2IiREnVatJ25rVM4BJl3mllY+z31RGXsGuivJcXTdl3tnwMMgboWpNs9Ixq50YVLV28jLloim2o8z8wXDLuj8w+4qQWfT55xFl4yRu21aWuzW7wbcvb+CYFQfAV6xJdraL+0RtTj/SqBARFFiPkSBAVRKGfMUgcNMGciP3tuwDPhDLQxxLeM31v0jxehIopq/YWAjolqrr7i4C2qPZ+Yt9GAfedUutX1pvy+mFE023pGjMi5JbEFri1EKqigpuiNg7XwQHaA+5VOmfuNfQHnJI+Rpe+aPfLJb7+/s3/m22P6Uetmn2sYxz/ggAJgQMK0rEA1Osc2YkbUm6tIxguj/gPuAW8gl/exSOLKiUVIouxTORqzmOWbm+VY/evOjIWCJ77T9MysmlA+QOpjmSzn0gJA+HiA71l/qzc/hgpilisXMCBv6ZA8xsi79kecGo+WaEKtNOTna6cN0YDM0Xn1S5EKav7GBQ+XPIqZPJM1yW40xPYeHXn4M6fFdvU0ooCvKuplLB6QUFXi+newD+iAskWe6stYHS5I6A33UYNrYQXM4POThvWDyqPNDOSQM64C/QDT7KjP9rVDGvUhHKzjMvoZT8Y6EzO4nFbNLdcVoQb51
 bsfuLkTg
 2mn1JYFFyJehvW4uKmoxOe7scvOUQ5w3GJKZ4pWbRfXVozOyoJU3F3Lj1HeQ6IK2f5sE/4CawW2uS7ZgmDrqqw5E8wO2oCAWHkF05+OhzTdeb9cBxgsBFhMmIXXVv5pRqmsc06nQugfHFbZagjlZagHh3FSoCpcVAOfg5ZGItnKz6nxU9hJaC7pSLYtGz/XLYyw06K88wK7SKKK6lQJjK+awT2BFOaTSFnW4rJ7lhhADiKbbp+kQTRSSYNGmcEUrZGTq1Hb9NWEXg7sdbuktvLUGbRHpdr2HgM4qORRN+rwLq2AVlKDoW9nGOne8LqbAUYUfBS7SW9d8IUn+UDqxKx3HR59Ywxu46Stak
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 7:10=E2=80=AFAM Catalin Marinas <catalin.marinas@ar=
m.com> wrote:
>
> On Wed, Jul 08, 2026 at 03:11:18AM +0000, James Houghton wrote:
> > diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/=
pgtable.h
> > index 5f21d3a738ee..7b11aa41d0a0 100644
> > --- a/arch/arm64/include/asm/pgtable.h
> > +++ b/arch/arm64/include/asm/pgtable.h
> > @@ -1302,8 +1302,7 @@ static inline void __pte_clear(struct mm_struct *=
mm,
> >       __set_pte(ptep, __pte(0));
> >  }
> >
> > -static inline bool __ptep_test_and_clear_young(struct vm_area_struct *=
vma,
> > -             unsigned long address, pte_t *ptep)
> > +static inline pte_t __ptep_clear_young(pte_t *ptep)
> >  {
> >       pte_t old_pte, pte;
> >
> > @@ -1315,7 +1314,13 @@ static inline bool __ptep_test_and_clear_young(s=
truct vm_area_struct *vma,
> >                                              pte_val(old_pte), pte_val(=
pte));
> >       } while (pte_val(pte) !=3D pte_val(old_pte));
> >
> > -     return pte_young(pte);
> > +     return pte;
> > +}
>
> At some point, we should use LSE atomics directly here if supported
> rather than a CAS loop (well, this is LSE as well if supported but it
> doesn't guarantee forward progress of the loop). I reckon we can replace
> it with some test_and_clear_bit_relaxed() call.

I'll put a patch (or two) at the front of this series to do this. :)
Will mentioned it too in my offline discussions with him.

Will also pointed out that FEAT_LSE relaxed some of the forward
progress guarantees[1], pretty strong justification to just use LDCLR.
So unless you feel strongly, I'll skip performance testing for this
change.

[1] B2.12.5 (M.c) The bullet that begins with "If FEAT_LSE is not implement=
ed".

> > +static inline bool __ptep_test_and_clear_young(struct vm_area_struct *=
vma,
> > +             unsigned long address, pte_t *ptep)
> > +{
> > +     return pte_young(__ptep_clear_young(ptep));
> >  }
> >
> >  static inline bool __ptep_clear_flush_young(struct vm_area_struct *vma=
,
> > @@ -1793,6 +1798,48 @@ static inline void pte_clear(struct mm_struct *m=
m,
> >       __pte_clear(mm, addr, ptep);
> >  }
> >
> > +#define __HAVE_ARCH_TRY_UPDATE_VMEMMAP_PTE
> > +static inline int try_update_vmemmap_pte(unsigned long addr, pte_t *pt=
ep,
> > +                                      const pte_t pte)
> > +{
> > +     const int max_attempts =3D 16;
> > +     int attempts =3D 0;
> > +     pte_t old_pte;
> > +
> > +     if (!system_supports_hvo())
> > +             return -EOPNOTSUPP;
> > +
> > +     /* This routine is only to be used for valid-to-valid transitions=
. */
> > +     if (WARN_ON_ONCE(!pte_valid(pte)))
> > +             return -EINVAL;
> > +
> > +     old_pte =3D __ptep_get(ptep);
> > +
> > +     do {
> > +             if (WARN_ON_ONCE(!pte_valid(old_pte)))
> > +                     return -EINVAL;
> > +
> > +             /* We should never get a contiguous PTE here. */
> > +             if (WARN_ON_ONCE(pte_valid_cont(old_pte)))
> > +                     return -EINVAL;
> > +
> > +             if (pte_young(old_pte)) {
> > +                     /* __ptep_clear_young() returns the overwritten P=
TE */
> > +                     old_pte =3D pte_mkold(__ptep_clear_young(ptep));
> > +
> > +                     flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> > +             }
>
> I think this is going to do a lot of TLBIs given that the default kernel
> prot has PTE_AF. It somewhat defeats the VMEMMAP_REMAP_NO_TLB_FLUSH
> flag but I haven't figured exactly how this optimisation works.
>
> If it becomes a problem, we could do a first pass to clear AF as an
> optimisation or later via vmemmap_split_pmd(), only map with AF=3D0. We
> still have some page copying that touches the vmemmap, bringing AF back.
> Of course, you'd still need the above flush, just wondering whether we
> can reduce/coalesce it.

We could reduce/coalesce the TLBIs (it should be very unlikely for the
page structs of a to-be-optimized (or to-be-unoptimized) HugeTLB folio
to be accessed, which is nice), but as far as I can tell, the TLBIs
don't seem *too* slow yet.

On my test system (single-socket, 80 CPUs, Neoverse V2), the TLBIs
seem to take about half the total time required to free the vmemmap.
This isn't great, but the absolute time taken isn't a problem for me
(maybe because my machine is single-socket?).
```
$ echo 0 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages
$ time perf record -g -- bash -c "echo 288 >
/sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages"

real    0m1.271s
user    0m0.076s # this is just perf :)
sys     0m1.180s

Trimmed perf report:
+   47.44%    47.44%  bash     [kernel.kallsyms]  [k] try_update_vmemmap_pt=
e
# In try_update_vmemmap_pte, it's the TLBI + ISB taking all of the time
+   33.66%    33.62%  bash     [kernel.kallsyms]  [k] prep_new_page
+   10.71%    10.71%  bash     [kernel.kallsyms]  [k]
_raw_spin_unlock_irqrestore
+    8.57%     4.86%  bash     [kernel.kallsyms]  [k] __free_pages
```

Also checking to see if HugeTLB-2M is problematic; it doesn't appear to be.
```
HugeTLB-2M
$ echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
$ time echo 10000 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages

real    0m0.080s
user    0m0.001s
sys     0m0.079s
```




> > +     /*
> > +      * Translations without AF cannot be cached, so we can replace
> > +      * them without BBM.
> > +      */
> > +     } while (!try_cmpxchg_relaxed(&pte_val(*ptep), &pte_val(old_pte),
> > +                                   pte_val(pte)) &&
> > +              ++attempts < max_attempts);
> > +
> > +     return attempts =3D=3D max_attempts ? -EAGAIN : 0;
> > +}
>
> Here, indeed, we do need this bounded, otherwise some pathological cases
> may set the AF continuously.
>
> --
> Catalin

