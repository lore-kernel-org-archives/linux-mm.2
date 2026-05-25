Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75648CD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 13:08:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D0AB6B0005; Mon, 25 May 2026 09:08:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A7AB6B0088; Mon, 25 May 2026 09:08:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370986B008A; Mon, 25 May 2026 09:08:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 222C46B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:08:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DCDAA1C0056
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:08:12 +0000 (UTC)
X-FDA: 84805970424.04.89FC3FE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 894158000B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:08:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DjcyEEcS;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779714490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L38bysUR1NeCFbrgfAfjXOTsZtYRransTREWZqs2gF0=;
	b=k0xAVsYIaa1ABMw9OZVH2m3hsdBxMF0XF1Ys298RXMFXS8SFJ4AwH7UyH9lTPlGX3G/ADq
	UW5YwXDeY9mGjzx5MkV3wQuRANP5LI5cLnr6Yxw8BTp1BZKiJUYb2xt8iBEqiLaEk3Z070
	7l9WdEG0qsDHQ1ODXluE1NrZSN8ffgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779714490; a=rsa-sha256;
	cv=none;
	b=e6EDEQkjCBQf8W0l84wE5/kc6mP+MqXIaPJE/aNkkTdSyTNTqvOTIqDgKhJNbd3J0bhKjH
	Oqcx6Y+O6rw0foSazTDjbEwgpIEaaOS7Mj01JcUeK+7NcF6YvrAXt7n28H0PVAugnIs81m
	/fwtoFr5YYsZWQeyHFiyfdKYyMbEp7o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DjcyEEcS;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779714489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L38bysUR1NeCFbrgfAfjXOTsZtYRransTREWZqs2gF0=;
	b=DjcyEEcSW9kqtpJIXVQhh+AtoWPJ8JnRUlhV0TfviSjKCOtiEDweKZhv2wQ159b8E29ROT
	rE6bssEgfKX+JOKlTnBlIQ7yWfpckNb4n6XNhOVivmS9YIQ/QVBPW5RBdMAuLIBwk3uTBQ
	P7rZYPUnDk+aVtI/rb54kxLPVpgDeZ8=
Received: from mail-yx1-f70.google.com (mail-yx1-f70.google.com
 [74.125.224.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-128-uJSCkaNAO2G0bEwwL0OXVw-1; Mon, 25 May 2026 09:08:02 -0400
X-MC-Unique: uJSCkaNAO2G0bEwwL0OXVw-1
X-Mimecast-MFC-AGG-ID: uJSCkaNAO2G0bEwwL0OXVw_1779714482
Received: by mail-yx1-f70.google.com with SMTP id 956f58d0204a3-65c21049da9so16099702d50.1
        for <linux-mm@kvack.org>; Mon, 25 May 2026 06:08:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779714482; x=1780319282;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L38bysUR1NeCFbrgfAfjXOTsZtYRransTREWZqs2gF0=;
        b=ihVwpGSd4cmBzuYRHMlxBaKTGFmhyPGe+VmyIyhVDs1KzERp0LpFVebS4G4tJFy0/F
         kJ6HJi8uLiPQldx/3kK5ZwmU5unWQ5mr/Hp9L48hm3q8vfNLURPpAlzRSMugmsk/G5x8
         u8INU6zVwqs/cKHB8OtUSTtHQ9KI6MJ4fNZ9QXC8e6IYnx8GjcJSvLB+MhvbmhYZA+Lg
         IbBkSrQLftBvHtKWLdltTlHqqq8bYxvfJC5ViM/5B1Wsr3ZR9mXHRXALid2ecFX0H8RH
         hIizdEfKNl27ElJyKxmhpFl+vwVVCcShwW7uCXbPP7mbNgAH8Y2YX65suAdVr59Lg4SG
         Qz2Q==
X-Forwarded-Encrypted: i=1; AFNElJ/WtyE0U8UGB5MBEvAuPpQ/I5i5M2rax3+aq3JuGasZ+XYzVuSI6jbDoNeGwfPdIYou7VgMKlpxOg==@kvack.org
X-Gm-Message-State: AOJu0YxylZB3eF8ctzp+YjxC9Jv99063FCnKdhRz+odgDxEl5Qa8YLFW
	wKsPT3hgMyiBH6w29p6xPNAIOheDpoqeI56jIli88/JlxZtc43Xe4RELgxliuw6n3HNRBA4Xn73
	au3qO9BAC9FegOuCMci8zlWr0JJ6bFllFWYB9gAiJ/hfAkQQyyaFCwHRk2AfifjC/Vcs8kK2ghc
	ZoR/yvuGdwM+fKbpXTmnPohTy9xQM=
X-Gm-Gg: Acq92OEYtsTJEdxmtsm+zoePOjkNT8Cvsnyzunzp9tXbvwW2LhFqtOz/vy9qOOmCxlf
	x3Z4Cd242T/hA/eObu/rw7V3SC4tv05+e+rkBHi8+yFrUqPONWUaIztmACVCuduAcBc5IO7zc3H
	0PKckcnH+qAWPK01/VA5kpdvntXe2OUu5B0SzCe5yiwp+lLzf/nh5XyilpktVFhl1cjAp3n2bcQ
	rnYkA==
X-Received: by 2002:a05:690e:4401:b0:65c:308c:a164 with SMTP id 956f58d0204a3-65ec95f0db3mr10162572d50.1.1779714481928;
        Mon, 25 May 2026 06:08:01 -0700 (PDT)
X-Received: by 2002:a05:690e:4401:b0:65c:308c:a164 with SMTP id
 956f58d0204a3-65ec95f0db3mr10162501d50.1.1779714481381; Mon, 25 May 2026
 06:08:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260511185817.686831-1-npache@redhat.com> <20260511185817.686831-12-npache@redhat.com>
 <20260512154431.jxcs632mqqatqtsw@master> <CAA1CXcD2KPKFrwCZd2PatQhf_e1nrvCguPD77GcNOVPFZLvsew@mail.gmail.com>
 <20260521015510.k4p22m365q2wqkro@master>
In-Reply-To: <20260521015510.k4p22m365q2wqkro@master>
From: Nico Pache <npache@redhat.com>
Date: Mon, 25 May 2026 07:08:31 -0600
X-Gm-Features: AVHnY4J29748AeO7-WOLHmwpUAN_-xfWW3Sk7UtCIpdjXtCFGkj0IW_c31BTQDw
Message-ID: <CAA1CXcBNGmWb7798GEVbqNKqAUN_uRQ3KXx0G3372o_u-x9kSA@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v17 11/14] mm/khugepaged: Introduce mTHP
 collapse support
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, rientjes@google.com, rostedt@goodmis.org, 
	rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E3389Zf6sEbbDK_iE8EuLmB7jBPE5KuEjQ9cfTAP-e4_1779714482
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 894158000B
X-Stat-Signature: oozi7x18zxy9gtgonekz5atpeouscy8r
X-Rspamd-Server: rspam06
X-HE-Tag: 1779714490-186726
X-HE-Meta: U2FsdGVkX19oXfUdrmoRlor2wXGT6in/Apbftj1sfgRdxVwGHWH6PnydKVqMep+dNsK005dbRub0sW1LWGeI4gcCf5Nul9Pg1o8QgGeDy2IVsXNi8mNXbkOu/z9+b4QemB6g5g702WtpSDqv6528DhLkyCkl3lp24N72dW8UStDgvWyebUVGaL+xUuR/2W2jUsUc0ISS5LCjhlUHxziSR2kBriIPSEtD240kSwDIGdXrMeFZ95tWmzVTlon7oXq3bnLlBYYDDVDy9+lqUEPM2+kS2q+XcWU5mDoNrUZCJhwVm1SUGFvKacDJU0GoiIrbgSBOKaWHkPxNgy5EVd+73iiUPewZg2NECEc+vN3OfFfdpMYQKzaBXRi5IInXUKbqMna09FsgWmArIu/sHYk9H4BuY4CTk4RaTFifTGkXIc3RCa6SwfgAKr8wO67XM2xEfuzFnjwFeU6nROy8rJs3to2/UovZZTA54jwsImkFFXJzKc3MYagKaSjW0VRkSTzwHYbTO6hiHX7KwMXxWEiITZD36cEfPLBzaZh5nr7l9d5UCgI5VJGN+aVonKGWCzQS619UHA4KN5QbzwNgonjtn3Quo1smaTrv53HCIYD8K3mZrCdBqc7Cpz/uqM4sjEIdv/dLAyRp1u8oVhzhsLIN2TJpzBfk4BfehmK8kjPRyFmPpFmsmsUX0+ARdP/UqFrIDzc3k+1L5vwZkK5Y/iTbwzPlaI4xUCANWBzhZN8zhaOZGx41yFQ8J/bXT5zz8WvO1jVeyCCvA0A6zCl4VN/BX2X8/OysppQA21vkYOH2y0FroyY2C4RmNWjU9Fv67LA+Yu0letCm6JKUPo7NijbFDuT8jMnUhL85zAQJK88hMjMV0BgTxk7pelNdCMylbwcA/tYh73K1l1+dCEsOqS1JlfScO0TepIM9ECbIwD6Z7tthQUYTrMWuRMb5/V9jTAHdFanPZlH66oyB944n9wS
 8acWA0LL
 C1/O0YlqSVhNZz5l6FEXSHTVil2+DGzhf6lWoMgMwUnEyv+Bbg1EOk0a+nBW1MN0oHFo9ZV97KYDXg4DABIA/4EasykzykgBVAMzBHsvQufCS2xqErF/bcHi6N1lQuFLnrKKLPAipVQXKBJerHqbLlmSi0Ns1fo3l8bScukC6NqqofjRn/Y8If6YfN8p5l9dO1QmyUI1gW1iXbrjN1j9hUDhlJ0FVmqJcq8d37huOq+Ysf0ZgKOoOBJqrlq8uagIR3MS0oSjrDlFcgyYqFwv2FX46pl+uhbd/L6MZscyST8xVb7QYPfcAj6lwfVMrdy4n8eiOUeWpje68ixiuQxJbL6rau86tJ29/TEy/dg+uP1HTDq5bjCcMIWNgiwwuv3ZwFTzB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 7:55=E2=80=AFPM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> On Wed, May 20, 2026 at 06:05:31AM -0600, Nico Pache wrote:
> >On Tue, May 12, 2026 at 9:44=E2=80=AFAM Wei Yang <richard.weiyang@gmail.=
com> wrote:
> >>
> >> On Mon, May 11, 2026 at 12:58:11PM -0600, Nico Pache wrote:
> >> >Enable khugepaged to collapse to mTHP orders. This patch implements t=
he
> >> >main scanning logic using a bitmap to track occupied pages and a stac=
k
> >> >structure that allows us to find optimal collapse sizes.
> >> >
> >> >Previous to this patch, PMD collapse had 3 main phases, a light weigh=
t
> >> >scanning phase (mmap_read_lock) that determines a potential PMD
> >> >collapse, an alloc phase (mmap unlocked), then finally heavier collap=
se
> >> >phase (mmap_write_lock).
> >> >
> >> >To enabled mTHP collapse we make the following changes:
> >> >
> >> >During PMD scan phase, track occupied pages in a bitmap. When mTHP
> >> >orders are enabled, we remove the restriction of max_ptes_none during=
 the
> >> >scan phase to avoid missing potential mTHP collapse candidates. Once =
we
> >> >have scanned the full PMD range and updated the bitmap to track occup=
ied
> >> >pages, we use the bitmap to find the optimal mTHP size.
> >> >
> >> >Implement collapse_scan_bitmap() to perform binary recursion on the b=
itmap
> >> >and determine the best eligible order for the collapse. A stack struc=
ture
> >> >is used instead of traditional recursion to manage the search. This a=
lso
> >> >prevents a traditional recursive approach when the kernel stack struc=
t is
> >> >limited. The algorithm recursively splits the bitmap into smaller chu=
nks to
> >> >find the highest order mTHPs that satisfy the collapse criteria. We s=
tart
> >> >by attempting the PMD order, then moved on the consecutively lower or=
ders
> >> >(mTHP collapse). The stack maintains a pair of variables (offset, ord=
er),
> >> >indicating the number of PTEs from the start of the PMD, and the orde=
r of
> >> >the potential collapse candidate.
> >> >
> >> >The algorithm for consuming the bitmap works as such:
> >> >    1) push (0, HPAGE_PMD_ORDER) onto the stack
> >> >    2) pop the stack
> >> >    3) check if the number of set bits in that (offset,order) pair
> >> >       statisfy the max_ptes_none threshold for that order
> >> >    4) if yes, attempt collapse
> >> >    5) if no (or collapse fails), push two new stack items representi=
ng
> >> >       the left and right halves of the current bitmap range, at the
> >> >       next lower order
> >> >    6) repeat at step (2) until stack is empty.
> >> >
> >> >Below is a diagram representing the algorithm and stack items:
> >> >
> >> >                            offset   mid_offset
> >> >                            |        |
> >> >                            |        |
> >> >                            v        v
> >> >          ____________________________________
> >> >         |          PTE Page Table            |
> >> >         --------------------------------------
> >> >                           <-------><------->
> >> >                             order-1  order-1
> >> >
> >> >mTHP collapses reject regions containing swapped out or shared pages.
> >> >This is because adding new entries can lead to new none pages, and th=
ese
> >> >may lead to constant promotion into a higher order mTHP. A similar
> >> >issue can occur with "max_ptes_none > HPAGE_PMD_NR/2" due to a collap=
se
> >> >introducing at least 2x the number of pages, and on a future scan wil=
l
> >> >satisfy the promotion condition once again. This issue is prevented v=
ia
> >> >the collapse_max_ptes_none() function which imposes the max_ptes_none
> >> >restrictions above.
> >> >
> >> >We currently only support mTHP collapse for max_ptes_none values of 0
> >> >and HPAGE_PMD_NR - 1. resulting in the following behavior:
> >> >
> >> >    - max_ptes_none=3D0: Never introduce new empty pages during colla=
pse
> >> >    - max_ptes_none=3DHPAGE_PMD_NR-1: Always try collapse to the high=
est
> >> >      available mTHP order
> >> >
> >> >Any other max_ptes_none value will emit a warning and skip mTHP colla=
pse
> >> >attempts. There should be no behavior change for PMD collapse.
> >> >
> >> >Once we determine what mTHP sizes fits best in that PMD range a colla=
pse
> >> >is attempted. A minimum collapse order of 2 is used as this is the lo=
west
> >> >order supported by anon memory as defined by THP_ORDERS_ALL_ANON.
> >> >
> >> >Currently madv_collapse is not supported and will only attempt PMD
> >> >collapse.
> >> >
> >> >We can also remove the check for is_khugepaged inside the PMD scan as
> >> >the collapse_max_ptes_none() function handles this logic now.
> >> >
> >> >Signed-off-by: Nico Pache <npache@redhat.com>
> >>
> >> [...]
> >>
> >> >+static int mthp_collapse(struct mm_struct *mm, unsigned long address=
,
> >> >+              int referenced, int unmapped, struct collapse_control =
*cc,
> >> >+              unsigned long enabled_orders)
> >> >+{
> >> >+      unsigned int nr_occupied_ptes, nr_ptes;
> >> >+      int max_ptes_none, collapsed =3D 0, stack_size =3D 0;
> >> >+      unsigned long collapse_address;
> >> >+      struct mthp_range range;
> >> >+      u16 offset;
> >> >+      u8 order;
> >> >+
> >> >+      collapse_mthp_stack_push(cc, &stack_size, 0, HPAGE_PMD_ORDER);
> >> >+
> >> >+      while (stack_size) {
> >> >+              range =3D collapse_mthp_stack_pop(cc, &stack_size);
> >> >+              order =3D range.order;
> >> >+              offset =3D range.offset;
> >> >+              nr_ptes =3D 1UL << order;
> >> >+
> >> >+              if (!test_bit(order, &enabled_orders))
> >> >+                      goto next_order;
> >> >+
> >> >+              max_ptes_none =3D collapse_max_ptes_none(cc, NULL, ord=
er);
> >>
> >> I am thinking whether there is a behavioral change for userfaultfd_arm=
ed(vma).
> >>
> >> collapse_single_pmd()
> >>     collapse_scan_pmd
> >>         max_ptes_none =3D collapse_max_ptes_none(cc, vma)
> >>         max_ptes_none =3D KHUGEPAGED_MAX_PTES_LIMIT                ---=
 (1)
> >>         mthp_collapse
> >>             max_ptes_none =3D collapse_max_ptes_none(cc, NULL)     ---=
 (2)
> >>             collapse_huge_page(mm)
> >>                 hugepage_vma_revalidate(&vma)
> >>                 __collapse_huge_page_isolate(vma)
> >>                     max_ptes_none =3D collapse_max_ptes_none(cc, vma)
> >>
> >> Before mthp_collapse() introduced, userfaultfd_armed(vma) is skipped i=
f there
> >> is any pte_none_or_zero() in collapse_scan_pmd().
> >>
> >> But now, max_ptes_none could be set to KHUGEPAGED_MAX_PTES_LIMIT at (1=
), so
> >> that we can scan all the pte to get the bitmap. This means
> >> userfaultfd_armed(vma) could continue even with pte_none_or_zero().
> >>
> >> Then in mthp_collapse(), collapse_max_ptes_none() at (2) ignores
> >> userfaultfd_armed(vma), which means it will continue to collapse a
> >> userfaultfd_armed(vma) when there is pte_none_or_zero().
> >>
> >> The good news is we will stop at __collapse_huge_page_isolate(), where=
 we
> >> get collapse_max_ptes_none() with vma. But we already did a lot of wor=
k.
> >
> >Good catch!
> >
> >As you stated we eventually ensure we respect the uffd checks. So
> >there are no correctness issues, just the potential for wasted cycles.
> >
> >At (1) we only do this if mTHPs are enabled. If that is the case, the
> >only waste that can arise is at the PMD order, as that order respects
> >the max_ptes_none value.
> >
> >I think one approach is to gate (1) with the uffd check as well. That
> >way, if mTHPs are enabled and its uffd-armed, max_ptes_none will stay
> >at 0, and we bail early on the scan early if any none_ptes are hit.
> >
> >But then we lose the ability to collapse to mTHPs that are uffd-armed,
> >where the PMD has none/zero-ptes and the mTHP fully has 0
> >non-none/zero-ptes.
> >
> >ie) assume a PMD is 16 x's [xxxxxxxx00000000]
> >where x is a populated pte and 0 is not
> >If we guard this scan (1), then we will never check if its possible to
> >collapse to the smaller orders.
> >
> >Let me know if you see a flaw in my logic, I think it's best to keep it =
as is?
> >
>
> Yes, gate it at (1) is not a proper place.
>
> I am thinking whether we could pass vma to (2)? So that we could respect
> uffd-armed?

Ok, sorry I never replied but i did implement it at (2). Sashiko
brought up a good point that this can result in a UAF; I verified
that. I'm going to send a fixup to the v18 to undo the change.

I added this to my todo list, and will look into optimizing/finding a
solution for this in a future series. The good thing is, as you stated
earlier, this can result in some wasted work, but it is not logically
incorrect overall.

Cheers,
-- Nico

>
> >>
> >> Not sure if I missed something.
> >>
> >> >+
> >> >+              if (max_ptes_none < 0)
> >> >+                      return collapsed;
> >> >+
> >> >+              nr_occupied_ptes =3D collapse_mthp_count_present(cc, o=
ffset,
> >> >+                                                             nr_ptes=
);
> >> >+
> >> >+              if (nr_occupied_ptes >=3D nr_ptes - max_ptes_none) {
> >> >+                      int ret;
> >> >+
> >> >+                      collapse_address =3D address + offset * PAGE_S=
IZE;
> >> >+                      ret =3D collapse_huge_page(mm, collapse_addres=
s, referenced,
> >> >+                                               unmapped, cc, order);
> >> >+                      if (ret =3D=3D SCAN_SUCCEED) {
> >> >+                              collapsed +=3D nr_ptes;
> >> >+                              continue;
> >> >+                      }
> >> >+              }
> >> >+
> >> >+next_order:
> >> >+              if (order > KHUGEPAGED_MIN_MTHP_ORDER) {
> >> >+                      const u8 next_order =3D order - 1;
> >> >+                      const u16 mid_offset =3D offset + (nr_ptes / 2=
);
> >> >+
> >> >+                      collapse_mthp_stack_push(cc, &stack_size, mid_=
offset,
> >> >+                                               next_order);
> >> >+                      collapse_mthp_stack_push(cc, &stack_size, offs=
et,
> >> >+                                               next_order);
> >> >+              }
> >> >+      }
> >> >+      return collapsed;
> >> >+}
> >> >+
> >> > static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >> >               struct vm_area_struct *vma, unsigned long start_addr,
> >> >               bool *lock_dropped, struct collapse_control *cc)
> >> > {
> >> >-      const int max_ptes_none =3D collapse_max_ptes_none(cc, vma, HP=
AGE_PMD_ORDER);
> >> >+      int max_ptes_none =3D collapse_max_ptes_none(cc, vma, HPAGE_PM=
D_ORDER);
> >> >       const unsigned int max_ptes_shared =3D collapse_max_ptes_share=
d(cc, HPAGE_PMD_ORDER);
> >> >       const unsigned int max_ptes_swap =3D collapse_max_ptes_swap(cc=
, HPAGE_PMD_ORDER);
> >> >+      enum tva_type tva_flags =3D cc->is_khugepaged ? TVA_KHUGEPAGED=
 : TVA_FORCED_COLLAPSE;
> >> >       pmd_t *pmd;
> >> >-      pte_t *pte, *_pte;
> >> >-      int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> >> >+      pte_t *pte, *_pte, pteval;
> >> >+      int i;
> >> >+      int none_or_zero =3D 0, shared =3D 0, nr_collapsed =3D 0, refe=
renced =3D 0;
> >> >       enum scan_result result =3D SCAN_FAIL;
> >> >       struct page *page =3D NULL;
> >> >       struct folio *folio =3D NULL;
> >> >       unsigned long addr;
> >> >+      unsigned long enabled_orders;
> >> >       spinlock_t *ptl;
> >> >       int node =3D NUMA_NO_NODE, unmapped =3D 0;
> >> >
> >> >@@ -1429,8 +1579,19 @@ static enum scan_result collapse_scan_pmd(stru=
ct mm_struct *mm,
> >> >               goto out;
> >> >       }
> >> >
> >> >+      bitmap_zero(cc->mthp_bitmap, MAX_PTRS_PER_PTE);
> >> >       memset(cc->node_load, 0, sizeof(cc->node_load));
> >> >       nodes_clear(cc->alloc_nmask);
> >> >+
> >> >+      enabled_orders =3D collapse_allowable_orders(vma, vma->vm_flag=
s, tva_flags);
> >>
> >> Would it be 0 at this point?
> >
> >If your question relates to the issue you brought up above, then yes,
> >max_ptes_none would be 0 if it's uffd-armed. We must recheck the
> >uffd-armed status before modifying it to 511.
> >
> >>
> >> >+
> >> >+      /*
> >> >+       * If PMD is the only enabled order, enforce max_ptes_none, ot=
herwise
> >> >+       * scan all pages to populate the bitmap for mTHP collapse.
> >> >+       */
> >> >+      if (enabled_orders !=3D BIT(HPAGE_PMD_ORDER))
> >> >+              max_ptes_none =3D KHUGEPAGED_MAX_PTES_LIMIT;
> >> >+
> >> >       pte =3D pte_offset_map_lock(mm, pmd, start_addr, &ptl);
> >> >       if (!pte) {
> >> >               cc->progress++;
> >> >@@ -1438,11 +1599,13 @@ static enum scan_result collapse_scan_pmd(str=
uct mm_struct *mm,
> >> >               goto out;
> >> >       }
> >> >
> >> >-      for (addr =3D start_addr, _pte =3D pte; _pte < pte + HPAGE_PMD=
_NR;
> >> >-           _pte++, addr +=3D PAGE_SIZE) {
> >> >+      for (i =3D 0; i < HPAGE_PMD_NR; i++) {
> >> >+              _pte =3D pte + i;
> >> >+              addr =3D start_addr + i * PAGE_SIZE;
> >> >+              pteval =3D ptep_get(_pte);
> >> >+
> >> >               cc->progress++;
> >> >
> >> >-              pte_t pteval =3D ptep_get(_pte);
> >> >               if (pte_none_or_zero(pteval)) {
> >> >                       if (++none_or_zero > max_ptes_none) {
> >> >                               result =3D SCAN_EXCEED_NONE_PTE;
> >> >@@ -1522,6 +1685,8 @@ static enum scan_result collapse_scan_pmd(struc=
t mm_struct *mm,
> >> >                       }
> >> >               }
> >> >
> >> >+              /* Set bit for occupied pages */
> >> >+              __set_bit(i, cc->mthp_bitmap);
> >> >               /*
> >> >                * Record which node the original page is from and sav=
e this
> >> >                * information to cc->node_load[].
> >> >@@ -1580,10 +1745,11 @@ static enum scan_result collapse_scan_pmd(str=
uct mm_struct *mm,
> >> >       if (result =3D=3D SCAN_SUCCEED) {
> >> >               /* collapse_huge_page expects the lock to be dropped b=
efore calling */
> >> >               mmap_read_unlock(mm);
> >> >-              result =3D collapse_huge_page(mm, start_addr, referenc=
ed,
> >> >-                                          unmapped, cc, HPAGE_PMD_OR=
DER);
> >> >+              nr_collapsed =3D mthp_collapse(mm, start_addr, referen=
ced, unmapped,
> >> >+                                            cc, enabled_orders);
> >> >               /* collapse_huge_page will return with the mmap_lock r=
eleased */
> >>
> >> collapse_huge_page will return with mmap_lock released, but mthp_colla=
pse()
> >> may not?
> >
> >We are now releasing the lock before calling mthp_collapse, which
> >subsequently calls collapse_huge_page. Even if `collapse_huge_page` is
> >never called-- say, because enabled_orders is 0 (which should not
> >happen) and all collapse orders are skipped (never calling
> >collapse_huge_page)-- we still return here with the lock dropped.
> >
> >I think this is sound. Let me know if you think differently.
> >
>
> You are right. I missed the lock is released in previous patch.
>
> >Cheers :)
> >-- Nico
> >
> >>
> >> >               *lock_dropped =3D true;
> >> >+              result =3D nr_collapsed ? SCAN_SUCCEED : SCAN_FAIL;
> >> >       }
> >> > out:
> >> >       trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> >> >--
> >> >2.54.0
> >>
> >> --
> >> Wei Yang
> >> Help you, Help me
> >>
>
> --
> Wei Yang
> Help you, Help me
>


