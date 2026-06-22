Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32521CD98F0
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 01:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9293D6B008C; Sun, 21 Jun 2026 21:13:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DAED6B0092; Sun, 21 Jun 2026 21:13:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C8E86B0093; Sun, 21 Jun 2026 21:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 451B56B008C
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:13:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81BDB40515
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:13:18 +0000 (UTC)
X-FDA: 84905775276.08.F9234BD
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5FFB3C0007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:13:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A75GhGrC;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782090796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pbtjcqkELpfq5gc7dgXyrGhXU7ULcjptM/7EKBk5FVI=;
	b=49dUDNt/WW7LKSKvMsWcngyc4f5hSujk1NS2Q74/z5/bVtBgtVuIkNaoh/49PNQJANqYVH
	R1VYwg58YW7s+T4ZgmlTj9fPtYGQMqTGTFZU69HJekFEiWdrmysjuvY7JCeq5Vk3WmuyNP
	GjTEj3P4skhj0DeBEQFlOkeEQfDqSuo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782090796;
	b=K5OOaflgdG/xZBiU48ZMykSnRuIA0mgkjxZ0z/c3KTPWJcvqK/noBMlVzFKj5bcLAcCa5r
	2UVSaXBf0Jf60usQYKLigC0FxjA3hf/iWlt41yul60taLftepMdNPnSorEpkMyucKLJqMv
	R+XFkfjTlnRJTzi1S8V2hFGoz4XZxNE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A75GhGrC;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4924933d072so31155e9.1
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 18:13:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782090795; cv=none;
        d=google.com; s=arc-20260327;
        b=E4ytUJ3qGjd0LiY1LKqSMpd2i3W0roY6SrEskL2dczBKSpE8zpyGItz6OQEcIL4NN5
         a7uqKStsC6vSbZAtI+NvjeBq1/M7aSp0NVINYkYd0wrwbgDUnOL3Z1Yu8kXcnDBzlrWk
         A+UYtz71ThaQT2hvBG3MYVbg9vmSlM4cqJjUOfZ7U/rnIlB2GkBAjROENhcX415VA5WP
         ASnXvTAdVcF2xUOiYNWyiwa/RrVdNkwrm37qHPsK+Dh4EIFNz9/Uy7BeNP/Q/YPDgN93
         KciKerzsyF31k2XUGlh9lnKqugw6A3PW6CpMcLj+eZi+uofxj4elCNFAoJ1tmShql5wR
         Ljrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pbtjcqkELpfq5gc7dgXyrGhXU7ULcjptM/7EKBk5FVI=;
        fh=FinQhZWTN2RiLWqTqrMyvoLsvfcR+d27d0GbwBM7Vcs=;
        b=Gl0miU786rco8vWPf37YUxBVWYq4VFbj9+W8AJ2HLxxYzp9LQGelRh7LR/QcA+Y4Cb
         ulo32P9kxOuZHdjXZF430pJOnOUbWxa566VcAIO6sUjpL/M1O3MK/Z6N7NMdmojnsvxt
         SV2piftt133KYBfGts1ir+UEoAs2yLPgfuQQJdsscVuoPMP8MjLEqscNcM3A8u9L8UGM
         kAZcogxHII3LKB3bcwXK1SFYOFmBnlKgjQ1JlKWsGrvWcEPoSalEpvZ9I8ipXAWQp3F6
         d+ps+Ua1V+W1zUHnOruRB3R1QZOHfc6fFltkg/FR38cDOR23s3wMqyxQOIwVnARUITth
         SJlw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782090795; x=1782695595; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pbtjcqkELpfq5gc7dgXyrGhXU7ULcjptM/7EKBk5FVI=;
        b=A75GhGrClJV4m6bMVc9xAA/i6S16X7hYakIjD/0UXLR2AGLfwyrpvy2lKccHsF8m4S
         0uG/txKbci4jrEKKSa3IIVVhpT2YoBms5X606qlKg5plqu+xTd9cyZpGDYdgY5hIeRDq
         ABcY9q/SuejjsRR4BkNwFheQ70YwyJBM8+EU8/XHPMAIFe8PQblO63WMU2wnbYyW27Y4
         qcLLlAJ5PeIyhEley4BLS46dkIRi1LyiQABXPpCgECAhszM4qzhRsi0oQDpFy8Q0CWLj
         rJEofjryqzJivhgajkM8KUC8KZJS3B54b8sJJpXKTBPL/1CaEC18qxJ7lD7okgCHfURH
         ztCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782090795; x=1782695595;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pbtjcqkELpfq5gc7dgXyrGhXU7ULcjptM/7EKBk5FVI=;
        b=S2fVc4gEKwWK7Y2aWcpW0BZjKT1mcHCo9XkD5QqHDq91cQfPhGP3vauJ7iouEixN1w
         xBiqOE/Gi+sg3MmlEth5kwZD1I9TEco0ndS0nPvHXmQLCbzj4SgtytjqbY3IXDbLT8C+
         NA4yvj9rxfNMUGxpAw5Rgciq3svxeFsE/1o3fE9aIh24/RFSkzJLqZ6U69iHVb5Z6ZMH
         MObmlMtDjONiPyLiw9UQysUswSQ97DrHx10SkH+DGne+90SibdFcS3pWFA5ghBgFEwdf
         yx2zuieeiBiUa1Ic2AMsKmrChVGtA4I/99xhkeYuWWNUI/twavoJ4S+U7KB5nMzGXKpO
         bxmQ==
X-Forwarded-Encrypted: i=1; AFNElJ96nQbP92UrJvolLksZaCLuADeQ3RtVKlw1/g+brLHAMjQAV6Z7qrKkuuxo3468aYwOiploJhIpxg==@kvack.org
X-Gm-Message-State: AOJu0YwXeaKCOA5YV2npsGo25klAfk9d2UKZvbWPmz3XJB/WuiIlfTiQ
	1Rg7Ch4wSYK/brpV4rv2rx+4cXJT4Mwgi6gTsdo/GLAMpadINEzLv/wJpkpTWXMp8g/of8reBfs
	ZFA5B/OJ93YQclPDPNVCGzWLgJilWo96XN481nOJV
X-Gm-Gg: AfdE7cm148qiMOgi1Z4lfROwfzR1eakc+VKaUi86Ta/LL3tIlt4TuffGfrIuvdm0Iv6
	7/B3HWrZ2vb3jrX+lfRNYdFgCAuB022Rh7i0dw6aziAGvvULXuFLjTcMasJPgeo3eWw96ljhVXh
	lj8x0SUk0xt3d/LwlxfWOSNQBozy8PTxIyH6F6shO1IgjWVxY0SOMw9TCPMTcuGuc+kkmpeX8OF
	dv60H+18BRBt1X9OigDGFyWKb6jPFM/uiykwHx8nXAETYJKkzZmMyXn+sMm9t37wJ55o1ke2rYU
	seyHVHzj9dvLuSIUjURBbFBrz585nfBkWcdbQ50=
X-Received: by 2002:a05:600d:108:10b0:489:1ace:d0d3 with SMTP id
 5b1f17b1804b1-4924154a2f1mr2951745e9.3.1782090794576; Sun, 21 Jun 2026
 18:13:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com> <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com> <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com>
 <DJAY8RKHUO52.28U7OSO06U91J@nvidia.com> <db7d1c9d-3d73-4502-960c-9c2023b90471@kernel.org>
 <DJCAWX74LL8P.2AX46L7QCCWKV@nvidia.com>
In-Reply-To: <DJCAWX74LL8P.2AX46L7QCCWKV@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 21 Jun 2026 18:13:02 -0700
X-Gm-Features: AVVi8CcPMAkbOjHEk1S_heVVGPxa39EfvUYxqxh_2zf3x_QS6zEtbEwqESwI7B0
Message-ID: <CACw3F53jgq5JS+0qkC3Jmj-jkDRHm1H_Z=Xvv-jKoL5XHy11sg@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Zi Yan <ziy@nvidia.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, harry.yoo@oracle.com, 
	osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, ljs@kernel.org, 
	osalvador@kernel.org, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bayx7rmddydbtuqhrrnzm1sojsht7nbc
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5FFB3C0007
X-HE-Tag: 1782090796-843059
X-HE-Meta: U2FsdGVkX19mn/at/nfoB/IBR9H6FNOkUqZuIUJBRZAgw7634LLTV/qYo0zP5ERvTZU261b74I67sD0UaQIGy6uvYY2EvJfC+oKOKsSH7bLRSYq77vyZzM6RSsh4iFGWV9Y4jwZqurkWkraYUoPt3Qo6lMAPFG8EmY7z9DQIeNFonlAtcqnUol27wV2S2WtA2nRMH9v3H+2hSRfbJTi17gqc3rQjO1VI+k2R7gHZ6OXE/mA9n+nzDYfLRxFaVU9kfYBaLoj3c+8mpIOcbSW+RFbToV6X5KhbE4XOycKK4fIDRVrjqX3tqVxea9iYzOvRIjgrZEfiaoBCRb/NluhdNGn2cx+vrgvkhDEM5p9jzUNImM7xVYRl0Jhf+z+/QwRCU/L/LbfGfAKx1LsxuvRaPOXm3/9udf3gsdQ/Eb0zSeDchuJrWnUPk6ZaVRzpwPXonv4/ctD3trxnex/BFaySyiwJl/lcoHkJoGLZPjsPwHE10f5+R/lOHD/q6vdHNXIbBJGLYMxRPTc8eHG3m/gg4kVa1zudaf67/kmiGkzgdNOAKbKp4fvZvZmg69Dz60X3GvLLsw4OETA+ut41kbZHisZACtLwkV8rSqQ19pb9V4Co07oGZLix4xwk+8lNGA69YhofnfyCCRKLWxyqhtxZGvrsLgmMyeb87w62Gzsn/OSoVXzaJxtJeLPumuepaCCcHmfhsXC1Fqe0ZzT7UFm2j8gOwanBK6Aj/6xTaksJRWYYlIboS1pL5wWqEI8BHBTbSZ79fZZgGEC6nXrjeWrUlhMv9aGyECY7hOirSfhqox4o/IN2FcbckW5tFoG+yKEDN/N0RJEyvsatAyHZl3/VKW77jXzY0i40fktmgBnEqE757Zpa4LnJU98giedbIUENkPCHMCOSna8hKZYIFzHDgzyhq92R8E0rr8jLRs9u5lfpm9xpLkDJfX7XiXTMrTN4EHQ9dKqbiPhV/21fZCk
 ePau8H8a
 WFz7HibML0agKsdYEUs68iSyrSMn1TJS/VIY5fGqKNV+PXPvons/QdaCCvcJi2V532ogmlk9/6YxXEHlgh0eaDJXbJhEXDgyl1T1n8/SzZMlSSa4+HNKYlTTv6ArBgnfbDwja/opHpnKTR7ybvrU1ISd76vHpVOgraS3td2mRrRQdSuqcFlarqI2ziUTeyHQDcTWjZMcROLSsrtZrAnYBQGhgpGhjea+ufAL3MhH46hr8uPgq/8p3VBQXHCny9ZHMh/pqdvw4b8qmKn6HIqOrMYGiAUCRMYXDUk6RkynXzjv5GRwvMrVOWf0u6gBcf1r6o0hPSg88Eol0dX2J86Tl39KfRWD2v84a4k0Y0D1k0o/F22EcLHLz5Ll/pe6e/m4I9bGR9ABpsZ/EfC8xHVOuRQSTPjG7e3nmz8XWNgiyjUJEWFEUqVz1a8NSVhu0tzZhvtrEAf3HQDPTjgSsVFfBxJ5QchcYfioMdts7nUesuENDH6FE8HAlqq6WLCli69bGxTl19nydKbyqcqZMOWHY3hAZ65OjjOooVstd5tFErnhuGtI0t1Nt/qhms8Sicej/UJ96ovKFQB6vpAiKY6pJ+YaA7sNekhXqrGpr5UUKUUbCGMVKyhZALYdXSc5/HvRZ26FX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 9:04=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Thu Jun 18, 2026 at 10:52 AM EDT, Vlastimil Babka (SUSE) wrote:
> > On 6/17/26 03:56, Zi Yan wrote:
> >> On Mon Jun 15, 2026 at 11:23 PM EDT, Jiaqi Yan wrote:
> >>> On Fri, Jun 12, 2026 at 11:34=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrot=
e:
> >>>>
> >>>> On 8 Jun 2026, at 23:44, Miaohe Lin wrote:
> >>>>
> >>>> > On 2026/5/31 13:58, Jiaqi Yan wrote:
> >>>> >> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> >>>> >> becomes non-HugeTLB, and it is released to buddy allocator
> >>>> >> as a high-order folio, e.g. a folio that contains 262144 pages
> >>>> >> if the folio was a 1G HugeTLB hugepage.
> >>>> >>
> >>>> >> This is problematic if the HugeTLB hugepage contained HWPoison
> >>>> >> subpages. In that case, since buddy allocator does not check
> >>>> >> HWPoison for non-zero-order folio, the raw HWPoison page can
> >>>> >> be given out with its buddy page and be re-used by either
> >>>> >> kernel or userspace.
> >>>> >>
> >>>> >> Memory failure recovery (MFR) in kernel does attempt to take
> >>>> >> raw HWPoison page off buddy allocator after
> >>>> >> dissolve_free_hugetlb_folio(). However, there is always a time
> >>>> >> window between dissolve_free_hugetlb_folio() frees a HWPoison
> >>>> >> high-order folio to buddy allocator and MFR takes HWPoison
> >>>> >> raw page off buddy allocator.
> >>>> >>
> >>>> >> Another similar situation is when a transparent huge page (THP)
> >>>> >> runs into memory failure but splitting failed. Such THP will
> >>>> >> eventually be released to buddy allocator when owning userspace
> >>>> >> processes are gone, but with certain subpages having HWPoison.
> >>>> >>
> >>>> >> One obvious way to avoid both problems is to add page sanity
> >>>> >> checks in page allocate or free path. However, it is against
> >>>> >> the past efforts to reduce sanity check overhead [1,2,3].
> >>>> >>
> >>>> >> Introduce free_has_hwpoisoned() to only free the healthy pages
> >>>> >> and to exclude the HWPoison ones in the high-order folio.
> >>>> >> The idea is to iterate through the sub-pages of the folio to
> >>>> >> identify contiguous ranges of healthy pages.
> >>>> >>
> >>>> >> free_has_hwpoisoned() is added in free_pages_prepare() as
> >>>> >> a shortcut and is only invoked if PG_has_hwpoisoned indicates
> >>>> >> HWPoison page exists and after checks and preparations in
> >>>> >> free_pages_prepare() all succeeded. free_has_hwpoisoned() then
> >>>> >> can re-use free_prepared_contig_range() [4] to decompose healthy
> >>>> >> ranges into the largest possible chunks of different orders.
> >>>> >> Every chunk meets the requirements to be freed via free_one_page(=
).
> >>>> >>
> >>>> >> free_has_hwpoisoned() has linear time complexity wrt the number
> >>>> >> of pages in the folio. While the power-of-two decomposition
> >>>> >> ensures that the number of calls to the buddy allocator is
> >>>> >> logarithmic for each contiguous healthy range, the mandatory
> >>>> >> linear scan of pages to identify PageHWPoison() defines the
> >>>> >> overall time complexity. For a 1G hugepage having 8 HWPoison
> >>>> >> pages, free_has_hwpoisoned() takes around 1ms on average on
> >>>> >> a system having 56 Intel Skylake physical cores. This is
> >>>> >> 15x to the case of freeing no HWPoison page. The cost is far
> >>>> >> from triggering soft lockup, and fair for handling exceptional
> >>>> >> hardware memory errors.
> >>>> >>
> >>>> >> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-=
email-mgorman@techsingularity.net
> >>>> >> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-=
email-mgorman@techsingularity.net
> >>>> >> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@sus=
e.cz
> >>>> >> [4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.an=
jum@arm.com
> >>>> >>
> >>>> >> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> >>>> >
> >>>> > Thanks for your update. This patch looks good to me while some com=
ments below.
> >>>> >
> >>>> >> ---
> >>>> >>  mm/page_alloc.c | 85 +++++++++++++++++++++++++++++++++++++++++++=
++++++
> >>>> >>  1 file changed, 85 insertions(+)
> >>>> >>
> >>>> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>>> >> index e47679e7a9db..03df929abca6 100644
> >>>> >> --- a/mm/page_alloc.c
> >>>> >> +++ b/mm/page_alloc.c
> >>>> >> @@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly =3D GFP_=
BOOT_MASK;
> >>>> >>  unsigned int pageblock_order __read_mostly;
> >>>> >>  #endif
> >>>> >>
> >>>> >> +static void free_has_hwpoisoned(struct page *page, unsigned int =
order);
> >>>> >>  static void __free_pages_ok(struct page *page, unsigned int orde=
r,
> >>>> >>                          fpi_t fpi_flags);
> >>>> >>  static void reserve_highatomic_pageblock(struct page *page, int =
order,
> >>>> >> @@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(s=
truct alloc_tag *tag, unsigned int nr)
> >>>> >>
> >>>> >>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> >>>> >>
> >>>> >> +/*
> >>>> >> + * Returns
> >>>> >> + * - true: checks and preparations all good, caller can proceed =
freeing.
> >>>> >> + * - false: do not proceed freeing for one of the following reas=
ons:
> >>>> >> + *   1. Some check failed so it is not safe to proceed freeing.
> >>>> >> + *   2. A compound page has some HWPoison pages. The healthy pag=
es
> >>>> >> + *      are already safely freed, and the HWPoison ones isolated=
.
> >>>> >> + */
> >>>> >>  static __always_inline bool __free_pages_prepare(struct page *pa=
ge,
> >>>> >>              unsigned int order, fpi_t fpi_flags)
> >>>> >>  {
> >>>> >> @@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_p=
repare(struct page *page,
> >>>> >>      bool init =3D want_init_on_free();
> >>>> >>      bool compound =3D PageCompound(page);
> >>>> >>      struct folio *folio =3D page_folio(page);
> >>>> >> +    /*
> >>>> >> +     * When dealing with compound page, PG_has_hwpoisoned is cle=
ared
> >>>> >> +     * with PAGE_FLAGS_SECOND. So the check must be done first.
> >>>> >> +     *
> >>>> >> +     * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_S=
ECOND.
> >>>> >> +     * Because PG_has_hwpoisoned =3D=3D PG_active, free_page_is_=
bad() will
> >>>> >> +     * confuse and complaint that the first tail page is still a=
ctive.
> >>>> >> +     */
> >>>> >> +    bool should_fhh =3D compound && folio_test_has_hwpoisoned(fo=
lio);
> >>>> >>
> >>>> >>      if (fpi_flags & FPI_PREPARED)
> >>>> >>              return true;
> >>>> >> @@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_p=
repare(struct page *page,
> >>>> >>
> >>>> >>      debug_pagealloc_unmap_pages(page, 1 << order);
> >>>> >>
> >>>> >> +    /*
> >>>> >> +     * After breaking down compound page and dealing with page m=
etadata
> >>>> >> +     * (e.g. page owner and page alloc tags), take a shortcut if=
 this
> >>>> >> +     * was a compound page containing certain HWPoison subpages.
> >>>> >> +     */
> >>>> >> +    if (should_fhh) {
> >>>> >> +            free_has_hwpoisoned(page, order);
> >>>> >> +            return false;
> >>>> >> +    }
> >>>> >
> >>>> > When the code reaches here, the hwpoisoned pages have passed throu=
gh kernel_poison_pages,
> >>>> > kasan_poison_pages, kernel_init_pages, arch_free_page... These fun=
ctions might write to
> >>>> > the hwpoisoned pages. Is it safe to do so?
> >>>>
> >>>> At least, kernel_poison_pages() writes to the page. It probably shou=
ld be
> >>>> moved up, somewhere like above kernel_poison_pages().
> >>>
> >>> Writing to HWPoison pages (location having memory error) is usually
> >>> safe, as in it doesn't cause a machine check exception. Memory
> >>> controller usually just fails the write op and waits for the next rea=
d
> >>> to raise the MCE / exception for prevent silent data corruption.
> >>>
> >>>>
> >>>> I do not like the shortcut method, since the pages are freed in
> >>>> __free_pages_prepare(). This causes confusion. One alternative I can=
 think
> >>>
> >>> What exactly is the confusion? or why does freeing has to be done by
> >>> __free_pages_prepare()'s caller?
> >>>
> >>> Harry suggested the shortcut method [1]. Although freeing inline migh=
t
> >>> surprise the caller, it simplifies things for all callers.
> >>>
> >>> [1] https://lore.kernel.org/linux-mm/aVy7L-3pc4JUYBEn@hyeyoo
> >>
> >> The function name is __free_pages_prepare(), but the code ends up with
> >> freeing the pages if the folio has HWPoison.
> >
> > It might free some, or leak some (already before this patch). Seems to =
me
> > really the only important part for the caller is if it can proceed free=
ing
> > or not.
>
> OK, at least add a comment to __free_pages_prepare() to document all
> possible outcomes.
>
> >
> >>>
> >>>> of is to make __free_pages_prepare() returns a enum
> >>>> { FREE_PAGE_PREPARE_SUCCESS, FREE_PAGE_PREPARE_FAIL, FREE_PAGE_PREPA=
RE_HAS_HWPOISON}
> >>>> and handle the return value in the caller.
> >
> > Until the callers need to distinguish that, it sounds like an unnecessa=
ry
> > complication to me.
> >
>
> Sure.
>
> >>> Are you worried that a caller of __free_pages_prepare() may see false
> >>> returned in the has_hwpoison case, but mistakenly propagate some kind
> >>> of error, or doing something under the assumption that folio not
> >>> freed? In this case the three enums can be useful. But I checked
> >>> current callers of __free_pages_prepare() and they don't have the
> >>> above problem.
> >>
> >> Right. Looking at compaction_free() code, if dst gets has_hwpoison (no=
t
> >> possible now, but if in the future migration code decides to mark foli=
os

It is very unlikely kernel can know any pages in dst has HWPoison.
copy_mc_*() and folio_mc_copy() tell and handle memory errors in src
pages (because it gets to read them), so callers like khugepaged and
page migration is impossible to know any error on dst pages.

However, ...

> >> when copy fails with EHWPOISON), the next list_add() is going to cause
> >
> > I think we should fix compaction_free() (as a separate patch preceding =
this
> > one) to not proceed if prepare returns false. It could in theory alread=
y
> > happen before this patch due to a random memory corruption of struct pa=
ge
> > causing some of the existing checks to fail.
>
> Something like below should do the job, plus
> Fixes: 733aea0b3a7bb ("mm/compaction: add support for >0 order folio memo=
ry compaction.")
>
> diff --git a/mm/compaction.c b/mm/compaction.c
> index b776f35ad0200..b2104cbe63477 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -1876,10 +1876,12 @@ static void compaction_free(struct folio *dst, un=
signed long data)
>         struct page *page =3D &dst->page;
>
>         if (folio_put_testzero(dst)) {
> -               free_pages_prepare(page, order);
> +               if (!free_pages_prepare(page, order))

... for other cases that free_pages_prepare() fails, this is
absolutely necessary for correctness. Do you mind sending it out for
formal review (I will be happy to help review).

> +                       goto skip;
>                 list_add(&dst->lru, &cc->freepages[order]);
>                 cc->nr_freepages +=3D 1 << order;
>         }
> +skip:
>         cc->nr_migratepages +=3D 1 << order;
>         /*
>          * someone else has referenced the page, we cannot take it back t=
o our
>
> >
> >> trouble. Or you can rename the function to
> >> __free_pages_prepare_and_free_has_hwpoison()? At least, caller knows t=
he
> >> potential side effect.
> >
> > Uh that's long. All callers are from PAGE ALLOCATOR mm-subsystem, it's =
not a
> > driver API so we'll know what we're doing (famous last words :)
>
> The name above is a half joke. :)
>
> BTW, I do not even trust myself sometimes. ;) Just look at the
> compaction_free() issue I introduced myself. But I do not want to be too
> pedantic here. So a comment above __free_pages_prepare() should be
> sufficient.

There is already a comment about the possible freeing case.

>
> --
> Best Regards,
> Yan, Zi
>

