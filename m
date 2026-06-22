Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 065F9CD98F0
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 01:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E37F6B008A; Sun, 21 Jun 2026 21:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492C66B008C; Sun, 21 Jun 2026 21:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3824C6B0092; Sun, 21 Jun 2026 21:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D3D116B008A
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:13:06 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7DDE140544
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:13:05 +0000 (UTC)
X-FDA: 84905774730.16.0AF2B1F
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id D6B2C10000D
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:13:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rwExCTlY;
	spf=pass (imf14.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782090784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z4fBASiwUSBOljL/NDIr+FCRXvrLZyKh5NfDVQFktfA=;
	b=Ri//0DwbU9Gv2/0AOLBynPiVHY9tNBt9ymvFGDIQwBcg2UPizwwDoiRwoLwjFluD35ogG6
	WK2hiX+Qvm7T4Y/16Vm7nJ4bzg2geUItj2XlV4tJKVNgi2LB/zn6XKwgyzmfbovkR1GVly
	C4xb2ivx3Rp6NTLcTCPGqmFGtO5vjvA=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rwExCTlY;
	spf=pass (imf14.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782090784;
	b=CQ4xQeI22+pABOuKebC//IliCbEV1pGLEz0MOZT5Myz8NRhJnKx6vPFdBCdPbojYjzlOIu
	TTb/wq0j2VqwztbItN53fWOsRH9MP/vmnIfGE6LGXsQE6fFctzQYHiyNMQBjzc52hKLrZG
	l5kq1/dnwzO09uoHre+pQWDeaOJ/gck=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4924933d072so31045e9.1
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 18:13:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782090782; cv=none;
        d=google.com; s=arc-20260327;
        b=sG5TV0Cg1AlOCJbM09G0umhmVH8eQB3lqSLwcNK6Jb0R8KUdmDZV7CEGNcn4n1O5Co
         syZFfGrqmtQbeDVSDdfQiJFamNaDHNEaN5yBBPgF+xmSJUVArEbWH6VT998CeNqV1u1u
         3ZC4lPoxwO+kr+Tq+DnG+YxZnaJG7Rwdn208bL91OppjN3QLk1uQyPZ9jCmQ5V+/HqDT
         Y3j+jofT76EzZ5Do1kCaP4GdSrgZgOgyVT0rXLptsFr1uUkuQ/Q2cE77Fxr44ST7JOdc
         /N3Vd5pEbZ0GAtB/9256+kKWujp9xp6d6XrX7fOocLk6KnjMOV0eKcE1KlX2yetkzpg8
         Fykg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Z4fBASiwUSBOljL/NDIr+FCRXvrLZyKh5NfDVQFktfA=;
        fh=5lTnXsaPStorpAcdR3eSPac/emNSNkNYo9nSslQHgog=;
        b=kiWGFCV6K2+xzyg//0YxkganknKJd00XWTXavU9sv4cLdNTko78TLzrNqgvcxh+Edf
         BYcT/Pg3b3YbF4+uh+PPce8vcc9EMKBly5lliEI1l0efLv5czMYwz49Lh+VzMi0jz/JL
         tWXgXZDL4uLZGnPVGoXQy8zQyfjkPby6dRuLS7Kbo7QpCamuqMHlovjptVGDjG3Lb7Fg
         SiJcD/T6BqyTna8U1XPGGI6kbkm/yyL6fn6BGQ9MKyxUalpgTGb0sgDJcjTilsvVbIsL
         A5fegReIOSbVTRJpEEYkM0e3xQDFFpAZt4wZ3vrYzSJcTkxPB5otqY08oBwU8uiQz5Nz
         6PSw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782090782; x=1782695582; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Z4fBASiwUSBOljL/NDIr+FCRXvrLZyKh5NfDVQFktfA=;
        b=rwExCTlYznJ5gjd2VQpVMNsYdJ9Wl9B8PKOAhtrJ0GPtnUyHe4sjdtMXtfRSbfdZHP
         ABI2z2be7OvZH/6Vj34ZlK3srDFBzfap8RCTtyTWi+JU0q6T81ae6614o5CNdvjqh2pI
         tPSG9Mm/YyE2TA5IiidPAlFqAi2Y+94yueJDSh/XTRWuhwyNrLAD8jdEr+eFG6jRs47b
         Hz4XmNJUPrP7btT5AXZEZDDip/j/hpk/6TRdurjWHNJCdzPAcIngQ5iQWrFhhrJjX8Fv
         qbrQpp5MGR95E/rkqipUCntKlsUt4t/sbA0qaXI4cBSYKh1mqwDPOheUlHW4Gzud6QJ0
         h+ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782090782; x=1782695582;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Z4fBASiwUSBOljL/NDIr+FCRXvrLZyKh5NfDVQFktfA=;
        b=s0KcdMDtQ258xeMCRCoi52N0r66sJ2UrWMKLs361i2Hvfa+zWNfOGnLVWroaYV5m/4
         lQtIv5wwGrzYcj5XS81CcO7tDO/GWOgreCdrVdmEyJdf9YQ9VUfm4rofOcjZ00a/ZBeQ
         9XTKX60x4O0LoPZAGRzDxJ2mn+Et+EQd4FEIwc/KXD3LwsL0K7rV2UcxWw1Z/r2Dj3+C
         9nXVOKDv19OqPitB/NJPmDhcoJNYTz+md/TExW684v5vXmz8LW2Epuzh/atyvzr32i7E
         ttNGr8GRsyqG6vKsjxi6ZWSICuP7xBXXz5kfZZEEqkdZAgkQl0num/Witrhub3vdI68i
         KqgQ==
X-Forwarded-Encrypted: i=1; AFNElJ96S7f31nrBpMCwls/GqprFn+gIokFEZU0GzelVvfu4ZQv1if9Sbf93cK770MRDwEOJYbuRnOT09Q==@kvack.org
X-Gm-Message-State: AOJu0YwATHBK5JzCK24zTq2FNLfJQutqZm3aZFdrrtRpyjzvD5tqHms5
	NYJrO/KtYd8PAksXrquVehdJCSQzdJCymjyUbveaHHNF5S5oE3TcNcIdcJ6tjNnFwOtRG4NYGck
	2ID7M/Z80BA5frZlSOllA2muRRXIkW6xUoJI7EV46
X-Gm-Gg: AfdE7cmJj62o/R2MFkHKCYeNdh67O+PdY45vfXMRrWV7kotnCbI/oZofRzY4Ra+1hhh
	PXkTc6llNzsxHRNDafbewIJNFoqnS4qTQhS8t/XB9w5rd56snoaj9TZroSMam357e1SrHEh0BNn
	GqeuSbaxKeVRqH+tuBqGCdeW5SnY1dRow3WZIup6Kmgbx09VTbyz+91WSqOXTxHNw6vCb5RsFxo
	MAv2Z0ZkXRE/bSFZFFiBga8atO8WCNnateAwMaEJ8fQBwbJYxvVRtkKLX2YhQaPjZ/Eg3/O8+uV
	SpWnLUPPp/TTU4hEEWATKlA0ZI8l
X-Received: by 2002:a05:600c:55cc:b0:45f:2940:d194 with SMTP id
 5b1f17b1804b1-49240472f61mr2783605e9.2.1782090781972; Sun, 21 Jun 2026
 18:13:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com> <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com> <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
 <ce2f2cea-1451-09a4-4562-62808b1c2d93@huawei.com> <5942d4d2-5719-4196-af49-b35cf5f7b88d@kernel.org>
In-Reply-To: <5942d4d2-5719-4196-af49-b35cf5f7b88d@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 21 Jun 2026 18:12:49 -0700
X-Gm-Features: AVVi8Cd1fXF5MESv1smxsTDjligvjtTtirGPUE3_19Yk9-4zMYvklgzW5exZ9hk
Message-ID: <CACw3F51GgF1CQ=hU2E50cnKUkDdc3zyS4in9QGCog1oY3-BSqw@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: osalvador@suse.de, Miaohe Lin <linmiaohe@huawei.com>, lorenzo.stoakes@oracle.com, 
	jackmanb@google.com, hannes@cmpxchg.org, nao.horiguchi@gmail.com, 
	david@kernel.org, william.roche@oracle.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, jane.chu@oracle.com, akpm@linux-foundation.org, 
	muchun.song@linux.dev, liam@infradead.org, rientjes@google.com, 
	duenwen@google.com, jthoughton@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, vbabka@suse.cz, rppt@kernel.org, 
	shuah@kernel.org, surenb@google.com, mhocko@suse.com, 
	boudewijn@delta-utec.com, ljs@kernel.org, osalvador@kernel.org, 
	willy@infradead.org, Zi Yan <ziy@nvidia.com>, harry.yoo@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D6B2C10000D
X-Rspam-User: 
X-Stat-Signature: m979c97f8ffmxaz4yqwizmtm3gzcydud
X-HE-Tag: 1782090783-711025
X-HE-Meta: U2FsdGVkX19VQHtZ6SXTIDrdjllT1DisuEPBCX8Zy/GSZwppsvb19YMUD6pp0Amj0i9hAPEfJ5etWkJpueVSofHYHSF+ZVv7FBDVni/uDW0kfwvAe9x9+CfcCwEMoW8WY3SdFPzW8WIK7lRNpLuYSrmW2hcfWS4uj1TUPCzEmJOR6/D45o5msvGXxhzaoYnSN28gItTnHe3qywkuWGFqeXma+vjwPNj8GNExdR2KdEgUKhIwWEfG5gXr0KTjYpxwsmVNpawq+fmcZMDCTO+dobqYCrizpPlCu2z2NTo7bnUeaAzTWNG5nPXKXJYxzPHqQgY9s/o90ZwQF1mRaFztSTg18sFrxz/J3bjokfG7viYwDCd/HWvNHzCEAJR2dLW2kt8ekgmmLzoKmYt+C7vbCyKq0zPCPUSBEUVIecrG1C4LyLe9TLLOEMdr7o9nSRb33zy06jwKX9xImHcdjqdphaX7A8iUu0oz+3ko3xeUUvhMmhTq1xcbNdpIwwIfU6tr/4kbBGKFjQToWP/+Dk5VX+yvwxaq7sOT5m1InQLR/+qm1m8jIWgbvX0tf4yGGTXtAHE/6DRjoh8MV+opUW4Pbr7XLqmVVVLh7kZ7sKSC5mpOynNAqwwzr+mCWKMX+zcilnUfza9JL66IOwDUya+V217FUmGc/czuz9+JtSoaHzVSrftlad3B4NO9H5ocggh5sKsArzAFssjOA/r6/W3OwwXVftTnipf6O7QvB4QcCgyjB6MBmZIyhiQomE4/DJg5DY66MS36/5PT8KAuC/siajPontVUwt+5hNvthPl8CKmuVm1WPyvfxnACOFDB+kcr4TlFa0V8T0pNCySK9k29pH2YuDpXYPzfeAJfx8w23+FXEV4/pKDBA4Ia8xBMg8gq/k6jyLzwO+SHzCA01dNPVT1MZKGO7H2i0NzUgRzZUJFO4DQH2dK4SI7sfm6m0SHX+orMLXSqXZQp2B3tfW7
 eQvB/OMi
 K91XhS94pLWkMf+plRdniUOuCmOYVv1pQ3N63MxFxYNzjcdu9uFmUV+VIUEsuTlIPFFNstujXQplno0PIGXiHZVScge8qicKWFUK0De49B3SsUGI/I78IscTNjSpZYCVVrblA5I2KUiy40dzsI3yO0O3VHSJb4+si04wDEjhPhLnjOYvTgLkmEF4QRf+XnuCMojmUaDljrF03gWYgjpkQsJn0EukiccCrEM1vnawMMOoClCn1ybgWBW0YtRNzsncEEihz62mZ0kodYSh+1xHN/BT1HAmVwj6NtnAKqUryl+Faib5KU+iveU4o4hwYwZZ0w9ETcSnsZ5AT8+y0zdRxg9CeZkt1rfTNjSRdACKIWhNJvvS2LKXcw/J2p30ZRUT4ibFB9Pez+cfkPb7wwX2OYaRL3OI2Te1LOvxVstDSPSPpUQWnAp5HngGgpHeBOmARXpKcJDdxhLmK3FZ0xxfYIbxrmQVVTCuCQc66/HHxb1yCndv1hnpVQklsljGbgPeHeus6xeE04p7HWwDC20vKDOAOo2jlpcyN1VQPUNoNFGGubTM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 8:02=E2=80=AFAM Vlastimil Babka (SUSE)
<vbabka@kernel.org> wrote:
>
> On 6/16/26 08:53, Miaohe Lin wrote:
> > On 2026/6/16 11:23, Jiaqi Yan wrote:
> >> On Fri, Jun 12, 2026 at 11:34=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote=
:
> >>>
> >>> On 8 Jun 2026, at 23:44, Miaohe Lin wrote:
> >>>
> >>>> On 2026/5/31 13:58, Jiaqi Yan wrote:
> >>>>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> >>>>> becomes non-HugeTLB, and it is released to buddy allocator
> >>>>> as a high-order folio, e.g. a folio that contains 262144 pages
> >>>>> if the folio was a 1G HugeTLB hugepage.
> >>>>>
> >>>>> This is problematic if the HugeTLB hugepage contained HWPoison
> >>>>> subpages. In that case, since buddy allocator does not check
> >>>>> HWPoison for non-zero-order folio, the raw HWPoison page can
> >>>>> be given out with its buddy page and be re-used by either
> >>>>> kernel or userspace.
> >>>>>
> >>>>> Memory failure recovery (MFR) in kernel does attempt to take
> >>>>> raw HWPoison page off buddy allocator after
> >>>>> dissolve_free_hugetlb_folio(). However, there is always a time
> >>>>> window between dissolve_free_hugetlb_folio() frees a HWPoison
> >>>>> high-order folio to buddy allocator and MFR takes HWPoison
> >>>>> raw page off buddy allocator.
> >>>>>
> >>>>> Another similar situation is when a transparent huge page (THP)
> >>>>> runs into memory failure but splitting failed. Such THP will
> >>>>> eventually be released to buddy allocator when owning userspace
> >>>>> processes are gone, but with certain subpages having HWPoison.
> >>>>>
> >>>>> One obvious way to avoid both problems is to add page sanity
> >>>>> checks in page allocate or free path. However, it is against
> >>>>> the past efforts to reduce sanity check overhead [1,2,3].
> >>>>>
> >>>>> Introduce free_has_hwpoisoned() to only free the healthy pages
> >>>>> and to exclude the HWPoison ones in the high-order folio.
> >>>>> The idea is to iterate through the sub-pages of the folio to
> >>>>> identify contiguous ranges of healthy pages.
> >>>>>
> >>>>> free_has_hwpoisoned() is added in free_pages_prepare() as
> >>>>> a shortcut and is only invoked if PG_has_hwpoisoned indicates
> >>>>> HWPoison page exists and after checks and preparations in
> >>>>> free_pages_prepare() all succeeded. free_has_hwpoisoned() then
> >>>>> can re-use free_prepared_contig_range() [4] to decompose healthy
> >>>>> ranges into the largest possible chunks of different orders.
> >>>>> Every chunk meets the requirements to be freed via free_one_page().
> >>>>>
> >>>>> free_has_hwpoisoned() has linear time complexity wrt the number
> >>>>> of pages in the folio. While the power-of-two decomposition
> >>>>> ensures that the number of calls to the buddy allocator is
> >>>>> logarithmic for each contiguous healthy range, the mandatory
> >>>>> linear scan of pages to identify PageHWPoison() defines the
> >>>>> overall time complexity. For a 1G hugepage having 8 HWPoison
> >>>>> pages, free_has_hwpoisoned() takes around 1ms on average on
> >>>>> a system having 56 Intel Skylake physical cores. This is
> >>>>> 15x to the case of freeing no HWPoison page. The cost is far
> >>>>> from triggering soft lockup, and fair for handling exceptional
> >>>>> hardware memory errors.
> >>>>>
> >>>>> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-em=
ail-mgorman@techsingularity.net
> >>>>> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-em=
ail-mgorman@techsingularity.net
> >>>>> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.=
cz
> >>>>> [4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anju=
m@arm.com
> >>>>>
> >>>>> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> >>>>
> >>>> Thanks for your update. This patch looks good to me while some comme=
nts below.
> >>>>
> >>>>> ---
> >>>>>  mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++++=
++++
> >>>>>  1 file changed, 85 insertions(+)
> >>>>>
> >>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>>>> index e47679e7a9db..03df929abca6 100644
> >>>>> --- a/mm/page_alloc.c
> >>>>> +++ b/mm/page_alloc.c
> >>>>> @@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly =3D GFP_BO=
OT_MASK;
> >>>>>  unsigned int pageblock_order __read_mostly;
> >>>>>  #endif
> >>>>>
> >>>>> +static void free_has_hwpoisoned(struct page *page, unsigned int or=
der);
> >>>>>  static void __free_pages_ok(struct page *page, unsigned int order,
> >>>>>                          fpi_t fpi_flags);
> >>>>>  static void reserve_highatomic_pageblock(struct page *page, int or=
der,
> >>>>> @@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(str=
uct alloc_tag *tag, unsigned int nr)
> >>>>>
> >>>>>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> >>>>>
> >>>>> +/*
> >>>>> + * Returns
> >>>>> + * - true: checks and preparations all good, caller can proceed fr=
eeing.
> >>>>> + * - false: do not proceed freeing for one of the following reason=
s:
> >>>>> + *   1. Some check failed so it is not safe to proceed freeing.
> >>>>> + *   2. A compound page has some HWPoison pages. The healthy pages
> >>>>> + *      are already safely freed, and the HWPoison ones isolated.
> >>>>> + */
> >>>>>  static __always_inline bool __free_pages_prepare(struct page *page=
,
> >>>>>              unsigned int order, fpi_t fpi_flags)
> >>>>>  {
> >>>>> @@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_pre=
pare(struct page *page,
> >>>>>      bool init =3D want_init_on_free();
> >>>>>      bool compound =3D PageCompound(page);
> >>>>>      struct folio *folio =3D page_folio(page);
> >>>>> +    /*
> >>>>> +     * When dealing with compound page, PG_has_hwpoisoned is clear=
ed
> >>>>> +     * with PAGE_FLAGS_SECOND. So the check must be done first.
> >>>>> +     *
> >>>>> +     * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SEC=
OND.
> >>>>> +     * Because PG_has_hwpoisoned =3D=3D PG_active, free_page_is_ba=
d() will
> >>>>> +     * confuse and complaint that the first tail page is still act=
ive.
> >>>>> +     */
> >>>>> +    bool should_fhh =3D compound && folio_test_has_hwpoisoned(foli=
o);
> >>>>>
> >>>>>      if (fpi_flags & FPI_PREPARED)
> >>>>>              return true;
> >>>>> @@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_pre=
pare(struct page *page,
> >>>>>
> >>>>>      debug_pagealloc_unmap_pages(page, 1 << order);
> >>>>>
> >>>>> +    /*
> >>>>> +     * After breaking down compound page and dealing with page met=
adata
> >>>>> +     * (e.g. page owner and page alloc tags), take a shortcut if t=
his
> >>>>> +     * was a compound page containing certain HWPoison subpages.
> >>>>> +     */
> >>>>> +    if (should_fhh) {
> >>>>> +            free_has_hwpoisoned(page, order);
> >>>>> +            return false;
> >>>>> +    }
> >>>>
> >>>> When the code reaches here, the hwpoisoned pages have passed through=
 kernel_poison_pages,
> >>>> kasan_poison_pages, kernel_init_pages, arch_free_page... These funct=
ions might write to
> >>>> the hwpoisoned pages. Is it safe to do so?
> >>>
> >>> At least, kernel_poison_pages() writes to the page. It probably shoul=
d be
> >>> moved up, somewhere like above kernel_poison_pages().
> >>
> >> Writing to HWPoison pages (location having memory error) is usually
> >> safe, as in it doesn't cause a machine check exception. Memory
> >
> > In x86, set_mce_nospec is called for hwpoisoned pages. So writing to
> > HWPoison pages would cause unexpected page fault in kernel?
> >
> > Thanks.
>
> Seems we'll have to extract everything between kernel_poison_pages() and
> debug_pagealloc_unmap_pages() to a function, don't call it when should_fh=
h
> is true and instead call it in free_has_hwpoisoned() on pages that are no=
t
> HWPoison? I think it's acceptable to do it there one page at a time in or=
der

Let's say I extract everything between kernel_poison_pages() and
debug_pagealloc_unmap_pages() into __free_pages_sanitize(page, order).
How about adding an extra bool to let __free_prepared_contig_range()
to do __free_pages_sanitize() for a block of pages?

This doesn't really matter to kernel_poison_pages() and
clear_highpages_kasan_tagged() because they deal with pages one by
one. However, it seems more efficient for kasan_poison() and
debug_pagealloc_unmap_pages().

BTW, I wonder whether I should carry over the fpi_t flags from
__free_pages_prepare() into free_has_hwpoisoned() and
__free_prepared_contig_range()? Right now the intended code paths to
get to __free_pages_prepare() all just have FPI_NONE, e.g.
free_frozen_pages() and free_unref_folios(). So I didn't complicate
things further.

> not to complicate things as most of that stuff is debug-only and we're
> handling a rare event.

