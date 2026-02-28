Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E1DE1048922
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 00:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5988B6B0005; Fri, 27 Feb 2026 19:50:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546286B0088; Fri, 27 Feb 2026 19:50:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41A7A6B0089; Fri, 27 Feb 2026 19:50:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C8846B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 19:50:34 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE9E613BF1F
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 00:50:33 +0000 (UTC)
X-FDA: 84492034746.19.F1EB339
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id A9B8B180008
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 00:50:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RaUpyfxG;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772239831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTVB5dWAl7VOze+/PX3CwHaUaq1aNmGLz1j8IVekX6I=;
	b=b/8oo7Nrdd1IhLe8JHGu4TnHV9l9QrLH1AqzjBNcUcMhhNjalpoMwlfH8ATRz3gKgoZF6n
	2J4KF3RHk3yxk5Gz4UgtZE/EejxHfFONcKnNuqXN5qES28WU3cNHACqESdzqvwuHlO9rhC
	CVlN+sRuLbxlps9EvWHIW8APF0elPNw=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RaUpyfxG;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772239831; a=rsa-sha256;
	cv=pass;
	b=vddpJck1z2kxpFjKi/QRvf1hLsb4luwM67WGa+NnsKctX1mCXHhLXjSYooBVkAvfe5MyS7
	BnXeaTHLhTzH/4LSX4tnrVHUiEjUBxhiFRls5UhMmPaweqUYI5n4qjY74SP3+RqKom+yg5
	cu4PMxRU1cV5oL2EbGL0dI/9d8QjoeE=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-3870976daf4so2719901fa.1
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:50:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772239830; cv=none;
        d=google.com; s=arc-20240605;
        b=b3rhIcPVx68/vEqL4vlaHC7gBWci3OD0+UiopqJI8yemheouHmy/+ILeiv+ngXuaUd
         ATjcCStObJ0OLO08KATg/6CCLurSfzGC3afxaEbKJvTkYqKHASKcnbE66Mk1c6XCVQpH
         bSs4xVCLK6Yp/YaXWAgYsoxItdbNO5o6uj8pEsEddRtH2Fw1au1sSjRkmPTSTBR9BJ+M
         PGZq74JtqIVCt5/ctZqlH2Up5yr73LPq5irDSx5ZdaXxUYQalsuCip3e0w4SL0+VYNaK
         7VD32hynkqTxML1iia1CBMSe+z+FpB/cj5GtmtvBTKSbco60TmQdlVW7JtiEQOdGC5Z1
         zw9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GTVB5dWAl7VOze+/PX3CwHaUaq1aNmGLz1j8IVekX6I=;
        fh=KmWM0r9reHuOQvS0aTvapfGx0hkIKhRT1i4+vrdwgg0=;
        b=EJLKdWc+ne+XYVVxzFmOh1tA53zsWvlYm01wo1rLZlciqCPiwtSojYw6u5rAecYQjK
         YwhWLv48CM2QssLPjL/+SFTsRNoMry8mmwnS0bVOJmXQtyHchFdz9hM3TuQL1Gl6YlIu
         LWGhAaGpb5mRlVQkKW5h9lwwO8G5NhPQf0RBywecuxndB3k+Y7KpVFEHjRykA3k3d9XA
         OsnQ7KNFXXiyEDWBIVGS0EWEauH82jIYxGjWXHDX5J3K2zd4/JIbKs9n+IzQ/PrXLL+1
         MUnmS9wECVTiTZ/iBcNjRic4q1fmMNQ1FMNFWye38hKUsdNtsfoQAc/7Um5uWBcpSdoo
         zlaQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772239830; x=1772844630; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GTVB5dWAl7VOze+/PX3CwHaUaq1aNmGLz1j8IVekX6I=;
        b=RaUpyfxGbPVDv3KxmsNZlek8pwHXhB9ECOCglIhOemC3RHOtXIhvodMBrCaQgqXHGL
         +DigwhnjHF2CBL17YwD+Y7JMNUAhXZ6Qmr1FvlvR5PXl1qBho/5Wh7+CBQLzM20DBpcp
         oJEcz7h4g/6vmEoCbsojlpMiqDY/JFV02vNZ7YoS91Hycz733G62BFMhCPBDTE3zDpX+
         APnkz9qI8ffYz3xX3WD8YKfTwimdP3lxA6MA/kOURT3pWtYVrbzZS0IFuESSKmfx6Qg6
         evyH4uoJXw9Wj0KxBlTeKbJP/SPNnrm7JjxkjEyi1mlIshfBMwuQQ03S7DBx2UqAcGnG
         OYtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772239830; x=1772844630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GTVB5dWAl7VOze+/PX3CwHaUaq1aNmGLz1j8IVekX6I=;
        b=IcMBupe0qERNSFU5kkC29HY+8zRNkImVhTx33F9NWo9tMbtYhEtzTJEx7NUDE8rWye
         pvaOl7RzSJnLaVctFKM+OXAYf+ERlI9wyuIhhUok96BB7jm+fitISoBDcpy7lzTszwDe
         Xu/C+JaUToCppUwj3DQ2jxmTe779bPkAVClbP68MJSUdQyprbPPcsH288Wa44htSvByO
         vbBBluJRcJYCOfggrBgNr2isldsPVUNk8xLvu9+rqmvo4BOQ2fKxOEl7cB8M23H/tEyb
         2Y28EPM5FFgicCV0YJRnm1y1o2BFusmZt4K//7T6EHrj1cXjr4gtGZXOem275Kf0ELby
         zv9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUEOBjXlaU11BAbCUHqkFMu8NOx6Tz7zoW+H6R0h/7uxUBKLcktbg+gdmSze4pNF5nwNVSCWv3IrQ==@kvack.org
X-Gm-Message-State: AOJu0YwvXJv9kNi6BT6a8BcGe4L5fYOJ6jkT5oePo+/jIDWVJ1f8VHCF
	BSno1rolT/mcnOGZjPFpPrlztwUFqSgVSFiz698Y5oX6VG+lGfOv/McKWiX/oNurDWbtgjCm7II
	u39KIW7pb4qBIKpv06RrGXccdS6F9xqw=
X-Gm-Gg: ATEYQzwoCjNGEByQjkMj9OH93flOzH6YOedfrBTaKbdqY5APgEYd51wDAYfBCWlTk3g
	0pYuU8jFBdqt/UremxevBAAzI0XlHvZE02HP0nPfZ8ecuu+AKTkXOSPMkSyqaYsS8wpLY5Z2uiu
	/Dv2Gkj8/b9K6mfxpIw76OISe9/B920zQO3wo28FmBRiTPpdZycmdKBOQDVJQzQlLDHtsFXxa75
	NyoQKHouHfRLm9OvWBWM76Zv+KsHHSgCx3joxJd5WmhoSM0Qxv+9njJXZxyY7lViXSofHggF5SA
	i4wm+GUGYtFnOSonKew=
X-Received: by 2002:a05:651c:4211:b0:385:c05a:4814 with SMTP id
 38308e7fff4ca-389ff34df78mr13920551fa.4.1772239829430; Fri, 27 Feb 2026
 16:50:29 -0800 (PST)
MIME-Version: 1.0
References: <20260227075250.1128175-1-zhaoyang.huang@unisoc.com> <202602271916.OBNa34QU-lkp@intel.com>
In-Reply-To: <202602271916.OBNa34QU-lkp@intel.com>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Sat, 28 Feb 2026 08:50:17 +0800
X-Gm-Features: AaiRm53m8KqzIMzrmY-RAKJ4NM9-fml6sIeBsXd4k5lqshVtOo5_TL5oO80n_ns
Message-ID: <CAGWkznEBBRCNyxxXvcUnjJacxp1-UMcW6DS9YnhpAFntFo1H0g@mail.gmail.com>
Subject: Re: [PATCH] mm: bail out when the PMD has been set in bloom filter
To: kernel test robot <lkp@intel.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Yu Zhao <yuzhao@google.com>, linux-kernel@vger.kernel.org, steve.kang@unisoc.com, 
	llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A9B8B180008
X-Stat-Signature: 3g9fci1at1oqkmbicgniybd896tufuyx
X-Rspam-User: 
X-HE-Tag: 1772239831-556958
X-HE-Meta: U2FsdGVkX19QU35BuQQYRRSGpOD6jMNhrLLswnlzNdamvrlg/nJeAAwgPnCbBPV7OAKU3W8hIqDK3RuwSFGJC3Q0uG6OFCTKtWubGlma00yp9Z5pUx2M8FUmtvFurwbQq3hhPorkBTDrOOqE0yjTaRYbwndttb+sQXSkeNGHdsZC3woriJqbZoKpRrwAtQR/u5Qqi7bm+/7QE/xstRoUAFAWdO5Yv+ymHXISiuWNKWKvGlwLPB/Z8tzLDZ3ziBYa864PRgwPlKzSINYHm6pxiF9TZ0URbKRniEpQHLaqMdhA7GBD1bElnnIfHjbBP/r0AsH4Aj/2TkrLLm8eJ9qpeIlzEoAoswOFd24QQ1C9wH2NWlsMyWjDTYQYM97pLGJOMfvS+gyb99ka/PK8yy6iT/WEYUKQbYGLj74bo6Skw5hutjNg6cu1f+XA0E1J3z+AgY+G47dHILTTvkEj6fonjfGqT1RwvGg1r32ftG8NyXPbXXKcyDbT0JDnncOfNRy0lcq0ug12xRcX9XrXyi0t0wFUrLlcFnXVEcGl4yw0M8WiS5fDRB/WWTRTihYw+XQnoxSfDSdAEZ68FKk6UTYUTrcDy7q8fNDaPzDUmUwEfarVyeO4qKrdN375unB/gt/k5I4kdUgcTh37x+s1bG5N3ED0z6aSVH3EdL5Vd22R1Fvcq0LDHaBYWmvORBd00G4h0QCRpMZpVdg/Nvyy3u+fWqpkrMpwoPcoliED9wroscRs2tU0zsDRKBeSzQL871IJ7JBkCsq0alN75w74ZSJZyr9REOm/pFW/j3myKWr3jiLFL8RH2FicGGdeIYroQmhXs/aqW6hdAuNn7daksR6hk30UToExica4XTh5c2CO/l/m71zaenoy9h6oCDLt0amCSy53H1Dr5uKFrIPHKyEKLrk7QWd16O8N8K8Jdgy3qmWyNYMjvBRz+l4A4sWqopR9anKDoVA+Cm+SPPqKhFg
 a3eBox+W
 mEyCpjBQZBEb4sybdrGGxpcswQuexJwJIhy5JJcLHvzhbkch8DI3C/rqkK05g+luuCbRHX/QsV2by4kFM7hnHAcNZN55hSO0JAob2Kg+qYT+5bf4Xp6XJCU6wPpOBwU2D0lUlQYlTVeZs2yYgkngxwGgjP+I4I/pBwMUu9Lvi9knUWyAJ1DGkO7RPEz2a8ETf1bxDgl+FRMl0KJiSaNkcjxbeCWnjvpTruvki+F6D78++EG2mFR9BMvBne+sSEDtow97eecm9GkBJpjgZusIlFNRZ/OyaHRC7b8A7kn/BaUmsOJrvo2AkzeRxBfFfvlb6Wm9kBWNDFlp7NELw73Qr/QT3YiShifKQ7eYhaX3Xo65ElcxAfy1J0SLR7VX9pOgdW+cLUeJoqHv7Kp2eDi6oaVDTK0eXO53vVcNwib+E3f1YPUcBBOCFsTaTdeAAc6oAcTbMjUUk4GDHuO295Uy3r2qCVWEQpkGfN1BD1TgduWSbRJmZrUW8WUROM5vajPGrHWxKIUmb9pKLHVEwakVxvM5+kENun2r2+nogxEqK3bfOB8bQ/CcCwtx03zk2Lc9by0+G31IzNiet1ic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Feb 27, 2026 at 7:43=E2=80=AFPM kernel test robot <lkp@intel.com> w=
rote:
>
> Hi zhaoyang.huang,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on akpm-mm/mm-everything]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/zhaoyang-huang/mm-=
bail-out-when-the-PMD-has-been-set-in-bloom-filter/20260227-155729
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-ev=
erything
> patch link:    https://lore.kernel.org/r/20260227075250.1128175-1-zhaoyan=
g.huang%40unisoc.com
> patch subject: [PATCH] mm: bail out when the PMD has been set in bloom fi=
lter
> config: sparc64-randconfig-002-20260227 (https://download.01.org/0day-ci/=
archive/20260227/202602271916.OBNa34QU-lkp@intel.com/config)
> compiler: clang version 23.0.0git (https://github.com/llvm/llvm-project 9=
a109fbb6e184ec9bcce10615949f598f4c974a9)
> reproduce (this is a W=3D1 build): (https://download.01.org/0day-ci/archi=
ve/20260227/202602271916.OBNa34QU-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202602271916.OBNa34QU-lkp=
@intel.com/
>
> All warnings (new ones prefixed by >>):
>
> >> mm/vmscan.c:4206:24: warning: variable 'mm_state' is uninitialized whe=
n used here [-Wuninitialized]
>     4206 |         if (test_bloom_filter(mm_state, max_seq, pvmw->pmd))
>          |                               ^~~~~~~~
>    mm/vmscan.c:4185:35: note: initialize the variable 'mm_state' to silen=
ce this warning
>     4185 |         struct lru_gen_mm_state *mm_state;
>          |                                          ^
>          |                                           =3D NULL
> >> mm/vmscan.c:4206:34: warning: variable 'max_seq' is uninitialized when=
 used here [-Wuninitialized]
>     4206 |         if (test_bloom_filter(mm_state, max_seq, pvmw->pmd))
>          |                                         ^~~~~~~
>    mm/vmscan.c:4186:23: note: initialize the variable 'max_seq' to silenc=
e this warning
>     4186 |         unsigned long max_seq;
>          |                              ^
>          |                               =3D 0
>    2 warnings generated.
>
>
> vim +/mm_state +4206 mm/vmscan.c
>
>   4157
>   4158  /****************************************************************=
**************
>   4159   *                          rmap/PT walk feedback
>   4160   ****************************************************************=
**************/
>   4161
>   4162  /*
>   4163   * This function exploits spatial locality when shrink_folio_list=
() walks the
>   4164   * rmap. It scans the adjacent PTEs of a young PTE and promotes h=
ot pages. If
>   4165   * the scan was done cacheline efficiently, it adds the PMD entry=
 pointing to
>   4166   * the PTE table to the Bloom filter. This forms a feedback loop =
between the
>   4167   * eviction and the aging.
>   4168   */
>   4169  bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw)
>   4170  {
>   4171          int i;
>   4172          bool dirty;
>   4173          unsigned long start;
>   4174          unsigned long end;
>   4175          struct lru_gen_mm_walk *walk;
>   4176          struct folio *last =3D NULL;
>   4177          int young =3D 1;
>   4178          pte_t *pte =3D pvmw->pte;
>   4179          unsigned long addr =3D pvmw->address;
>   4180          struct vm_area_struct *vma =3D pvmw->vma;
>   4181          struct folio *folio =3D pfn_folio(pvmw->pfn);
>   4182          struct mem_cgroup *memcg;
>   4183          struct pglist_data *pgdat =3D folio_pgdat(folio);
>   4184          struct lruvec *lruvec;
>   4185          struct lru_gen_mm_state *mm_state;
>   4186          unsigned long max_seq;
>   4187          int gen;
>   4188
>   4189          lockdep_assert_held(pvmw->ptl);
>   4190          VM_WARN_ON_ONCE_FOLIO(folio_test_lru(folio), folio);
>   4191
>   4192          if (!ptep_clear_young_notify(vma, addr, pte))
>   4193                  return false;
>   4194
>   4195          if (spin_is_contended(pvmw->ptl))
>   4196                  return true;
>   4197
>   4198          /* exclude special VMAs containing anon pages from COW */
>   4199          if (vma->vm_flags & VM_SPECIAL)
>   4200                  return true;
>   4201
>   4202          /* avoid taking the LRU lock under the PTL when possible =
*/
>   4203          walk =3D current->reclaim_state ? current->reclaim_state-=
>mm_walk : NULL;
>   4204
>   4205          /* may the pmd has been set in bloom filter */
> > 4206          if (test_bloom_filter(mm_state, max_seq, pvmw->pmd))
>   4207                  return true;
>   4208
>   4209          start =3D max(addr & PMD_MASK, vma->vm_start);
>   4210          end =3D min(addr | ~PMD_MASK, vma->vm_end - 1) + 1;
>   4211
>   4212          if (end - start =3D=3D PAGE_SIZE)
>   4213                  return true;
>   4214
>   4215          if (end - start > MIN_LRU_BATCH * PAGE_SIZE) {
>   4216                  if (addr - start < MIN_LRU_BATCH * PAGE_SIZE / 2)
>   4217                          end =3D start + MIN_LRU_BATCH * PAGE_SIZE=
;
>   4218                  else if (end - addr < MIN_LRU_BATCH * PAGE_SIZE /=
 2)
>   4219                          start =3D end - MIN_LRU_BATCH * PAGE_SIZE=
;
>   4220                  else {
>   4221                          start =3D addr - MIN_LRU_BATCH * PAGE_SIZ=
E / 2;
>   4222                          end =3D addr + MIN_LRU_BATCH * PAGE_SIZE =
/ 2;
>   4223                  }
>   4224          }
>   4225
>   4226          memcg =3D get_mem_cgroup_from_folio(folio);
>   4227          lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
>   4228          max_seq =3D READ_ONCE((lruvec)->lrugen.max_seq);
>   4229          gen =3D lru_gen_from_seq(max_seq);
>   4230          mm_state =3D get_mm_state(lruvec);
I am confused about the code base which this test is based on. By
checking the base that listed above and linux-next and 7.1-rc1, I
can't find above merged result or I miss anything?
>   4231
>   4232          lazy_mmu_mode_enable();
>   4233
>   4234          pte -=3D (addr - start) / PAGE_SIZE;
>   4235
>   4236          for (i =3D 0, addr =3D start; addr !=3D end; i++, addr +=
=3D PAGE_SIZE) {
>   4237                  unsigned long pfn;
>   4238                  pte_t ptent =3D ptep_get(pte + i);
>   4239
>   4240                  pfn =3D get_pte_pfn(ptent, vma, addr, pgdat);
>   4241                  if (pfn =3D=3D -1)
>   4242                          continue;
>   4243
>   4244                  folio =3D get_pfn_folio(pfn, memcg, pgdat);
>   4245                  if (!folio)
>   4246                          continue;
>   4247
>   4248                  if (!ptep_clear_young_notify(vma, addr, pte + i))
>   4249                          continue;
>   4250
>   4251                  if (last !=3D folio) {
>   4252                          walk_update_folio(walk, last, gen, dirty)=
;
>   4253
>   4254                          last =3D folio;
>   4255                          dirty =3D false;
>   4256                  }
>   4257
>   4258                  if (pte_dirty(ptent))
>   4259                          dirty =3D true;
>   4260
>   4261                  young++;
>   4262          }
>   4263
>   4264          walk_update_folio(walk, last, gen, dirty);
>   4265
>   4266          lazy_mmu_mode_disable();
>   4267
>   4268          /* feedback from rmap walkers to page table walkers */
>   4269          if (mm_state && suitable_to_scan(i, young))
>   4270                  update_bloom_filter(mm_state, max_seq, pvmw->pmd)=
;
>   4271
>   4272          mem_cgroup_put(memcg);
>   4273
>   4274          return true;
>   4275  }
>   4276
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

