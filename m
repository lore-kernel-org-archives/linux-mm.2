Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1F23CED243
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 05:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E1156B0008; Tue, 18 Nov 2025 00:18:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 390D36B000C; Tue, 18 Nov 2025 00:18:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27FEE6B000D; Tue, 18 Nov 2025 00:18:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 066C96B0008
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 00:18:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C79CD12E2BD
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:18:03 +0000 (UTC)
X-FDA: 84122571246.05.05D008B
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf28.hostedemail.com (Postfix) with ESMTP id E393EC0003
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 05:18:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rl6o1CVG;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763443082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=twkjfa30fRHD9BgmJwt1gQHo+WH/GMWfHY9pWcyj3jw=;
	b=KOk2E1JHJb9dwjbEpZLfG2xh6A3w91l1vLXXYPpR2AgnekDbUU3OFqSDfYgz/sYF9F5YEw
	JyZKnQUPACoCAWvh5wKq/PhZgfFVIuNeuSgVdhHqd3L4CPeY9KCNpTBZlGXg8qJQhj3gnh
	FxzM4N3WC9mP0CVV4E3sqCHMrINGpXw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rl6o1CVG;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763443082; a=rsa-sha256;
	cv=none;
	b=nZoIrbmIyj3hzfcMzytqJh6qokM3MHrqX0vt7xmhmFhIqyHx5NM4t1RhKvL/8/HzpbXHJb
	59BvDro0zwYvyL1dhIdm/SVmyAydBFBzHZiQD1ggKi+k4tZZqc0uILknwyXLOHrYKPMkxI
	OfB9wAPDcOx3qIdRU3P+onBR9+Czsik=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4779a4fc916so29425e9.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:18:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763443080; x=1764047880; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twkjfa30fRHD9BgmJwt1gQHo+WH/GMWfHY9pWcyj3jw=;
        b=rl6o1CVGBugdjnnXVhvfxYUjSvn0wbDwX2dfAcZeiqOk8IwYCApeazKGwPAYa1TCMk
         eyhEDwImIa26i2vdd/aLm2SoiPXogB+sR8X0tDqwPc39uktL+801BJ2bq+HMQd3/1SV7
         oDfWFSDS1h1a7V2z0z5WT07jlOst2/xBZmpIu2gMNUI9faFtkhlL0qd2CGBgzJu2Kr1i
         J3EQls4Mt+SksEUHVXEKIlz2Q+JcqRxm8FIFr6hzyyEp/0a0ed7tofy2QV5yPKpZxE2D
         4hdH8JBD0AS1Po6KdVIYabxhEHEsB0NZmpBdqgPedBXV3x+xuKCH6Ela9f0d0DDIysQM
         KrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763443080; x=1764047880;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=twkjfa30fRHD9BgmJwt1gQHo+WH/GMWfHY9pWcyj3jw=;
        b=IH1empDAmdQgigd0I6mEPG9V7wWuOB1D38IMerHAWybgjl6Oi84tukYyfI7IUVqMIc
         v9aMAGZDyuJRm0gaWFK38aVqjE/t/0ti7rC4p5WPvQb+bC6hu19XZ0oUM2uoYuQ40s21
         RqZehzz4aIC6OpHg3KpxNGxrGWiVqe2Bobz2CzsXe2xXYpIoJ62S0oA1s6LlHOq8YJkN
         FpTILrxU5xLyzbTbfHaFjwsVri95E9Mk1uWTmM6QbviuHOO+CkEwuRSrad7FZHqmGG3Q
         /SIF7lYh6JQZHX41xaYjlrediyg8SD40DvHHgE9mkXLuyPqj2TRDwW1Os4wfB0DOLULm
         AppQ==
X-Forwarded-Encrypted: i=1; AJvYcCUr9uoksND99k3esNrT7mDdAbiWnxA6o0B444Uf/osy6vamBdav7+DpFZRuGX1nvdWNDrbAS6K2kg==@kvack.org
X-Gm-Message-State: AOJu0YwjbpcPBc1XoFza6GIf1geXLpYWcW9FKuSr36iLsQibeJOCCIsq
	S5JuSAr1xzi6kyKFCFvxffNwtX/+iu43WNkWoIzvCD68qI+ICKZTh0k4+ogtsWAPnqcusdPt7cE
	KM2YhBQU5NvmLpMLUiHCEJrxAHfsnCeNk/vp6Qpzm
X-Gm-Gg: ASbGnct3o+eaX11jKHeR/EQXPK9eTx291vrf5C3/0SkmqaDp8DlSS1pCogxB9u0Bc05
	0p69kFIqTnq3h5RThp5TorH/TxyPuXpqwyU34D3qB2dQzf/h6jBkeH1tSrJOQTf88tq+BG/qkrC
	eoOPNJmk0uAR68WP75RMEuWC4d4or3cJ+LFRivdufnYrsHGg/jkbu3JWy5649stp0N2ocyj5FbK
	pIfCIVo3Jo4uIIJvGOvBLHtN8gFqR/dbt8Wbuy5Byx42dIXk3rIjtNr1cr5+L5avyl6um7zxtsG
	XbunxSUf+oDXwYYlcejDV/R4LViH
X-Google-Smtp-Source: AGHT+IGc2iVngTxPT7o91+hFQAjlxB2KQTgYyAt0T10shwhYAGaHBuuZJNq/JBCqg3zPWok91qHXU5duI91ezWn0P2M=
X-Received: by 2002:a05:600c:6dc1:b0:477:563a:135c with SMTP id
 5b1f17b1804b1-477aca4f02amr22915e9.0.1763443080368; Mon, 17 Nov 2025 21:18:00
 -0800 (PST)
MIME-Version: 1.0
References: <20251116014721.1561456-1-jiaqiyan@google.com> <20251116014721.1561456-3-jiaqiyan@google.com>
 <bcfd5575-cff0-4ead-9136-dd509bf11f64@kernel.org>
In-Reply-To: <bcfd5575-cff0-4ead-9136-dd509bf11f64@kernel.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 17 Nov 2025 21:17:48 -0800
X-Gm-Features: AWmQ_bkYLyh7FOYFP8JKvk2EtcfX6pixH2v2kxW0ZwYd8ZeKopK5TC-BlJFWJ3U
Message-ID: <CACw3F53x=n2mNJ6QS9wBRESim8ojHCmhY+-YLAL5N_wi6x0P4Q@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm/memory-failure: avoid free HWPoison high-order folio
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: nao.horiguchi@gmail.com, linmiaohe@huawei.com, ziy@nvidia.com, 
	lorenzo.stoakes@oracle.com, william.roche@oracle.com, harry.yoo@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, willy@infradead.org, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E393EC0003
X-Stat-Signature: w1cqonza5ie9695fyouobxyqz168f8xd
X-Rspam-User: 
X-HE-Tag: 1763443081-662077
X-HE-Meta: U2FsdGVkX19Tl+VdQWYUAsI7oxSDFJNhL4+6TPPLRR2gfI+8GQ8TGVm0uDgDbkweAN1rsjYXPAIOxaZkapVCAsuPc9/CUPeqgr46nVVheVH5Qfx0mItvGkmZImtS+HwbUrdGyoMvtLFBX1M7UnplhALp31hLmHFaGvPywZMtjtM1MhDyQJFquBAyD3Ouose37zQXpXxrGuHjJMz88oLogRT/QhRRdR7D0rLhUNF+T6WDFuVMmrOs6bjUC1KRp0Ky7nTN+VIaRVhrspXcKxeSuHyNcNQHENl+Gs+FCG+Ay3iaRUgaLwibdiLqt3VDQD7p+6JmlY3V70oewj5GemHC3t73dAtur21juXFeTLykIQimhD0ALbwlkgepn1dJ2cbp1tYBvuFoQbBZe1O4ojSZa5dSx2dGCpimOLSUNOjlyOWDWF2s3YAc+2pqL+t2VbCaplKsWLMvIvYFiCpuOHQUcpZIE381mMxxJMzv+3lwbHqd3jAqEnlOaEg6Ow2eWvqbgFHnhMzf/rO4gFFFGWEdnUQc8LzIxviIzwShbidOvssTvDUBPhS3vL2oJzhafU5fvM73BUbacsiiH4S1KV+J4gw4Ohk69aPQE45sZC5E68/sm2nWS1OYRrLAfdOn0TpBHJq7lAL5gq/Cj+GQLhH1vzJ1fwekNXy43LFXTpFYQqrm1UzacC92LEIeOA629/+K5c3Tncba0pe9dnAoDZisuHmY6EvtfW0v6AXVfqq1pxn811XSgCdfJU2Ra5dCSJXre2Fayrm2UULcWL6jWR45n3c5tfB8giJnjm2i0oJQgEpKCWdoOxLA+jXbj2AUo4DGAT85tdS0xGJoHu8MBCQeiMJ0poVDsucbCI9ffJX8qUptvIS0/uDoh0m0CCW8I2+vi3iv0ZRUWXka2rcZEHJhN1KKtDpKjqqcYtmAC+y/WXspGuGCzgKyJBkCpGzd4OkwUuQZfMkI724uAM0aWHm
 wBW4ep6j
 zYAxextgPRB5xXFrSk5LTCzbhxJ2Z7s/p3n8eKHJqfbT6+/VYABNQ1wr3/CAbTnR7tdx7YV/8CQYRcyI7Jo4E4+WB3NmXen/aT/Tp9/YDEwSJov9ZZSw+x2GGFVtrpSPmgUL+bQj0doAzvbrpx9H57D878Lh/Yb8WUyxgSHsBJJcLng9pTmtHjojnSVAO8NHNa8Jsn+nvFjBr2DMW7aF6lwroWoSt/5d2v7N0EFfCdeyOJrRXvyxoQEfZ38vXNG90c0DIUKwH5UlTsq/u0VFj0RZewD/ct6sEKA/TEpvxCBjq0N/5NgGnHB+XWbP9EKBh8RfZj185n3vHJVIQRIw4nUXuly08++q5tjPMcS+h63u9HRnjy3Mtbp6zaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 9:15=E2=80=AFAM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 16.11.25 02:47, Jiaqi Yan wrote:
> > At the end of dissolve_free_hugetlb_folio, when a free HugeTLB
> > folio becomes non-HugeTLB, it is released to buddy allocator
> > as a high-order folio, e.g. a folio that contains 262144 pages
> > if the folio was a 1G HugeTLB hugepage.
> >
> > This is problematic if the HugeTLB hugepage contained HWPoison
> > subpages. In that case, since buddy allocator does not check
> > HWPoison for non-zero-order folio, the raw HWPoison page can
> > be given out with its buddy page and be re-used by either
> > kernel or userspace.
> >
> > Memory failure recovery (MFR) in kernel does attempt to take
> > raw HWPoison page off buddy allocator after
> > dissolve_free_hugetlb_folio. However, there is always a time
> > window between freed to buddy allocator and taken off from
> > buddy allocator.
> >
> > One obvious way to avoid this problem is to add page sanity
> > checks in page allocate or free path. However, it is against
> > the past efforts to reduce sanity check overhead [1,2,3].
> >
> > Introduce hugetlb_free_hwpoison_folio to solve this problem.
> > The idea is, in case a HugeTLB folio for sure contains HWPoison
> > page(s), first split the non-HugeTLB high-order folio uniformly
> > into 0-order folios, then let healthy pages join the buddy
> > allocator while reject the HWPoison ones.
> >
> > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-=
mgorman@techsingularity.net/
> > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-=
mgorman@techsingularity.net/
> > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
>
>
> [...]
>
> >   /*
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index 3edebb0cda30b..e6a9deba6292a 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -2002,6 +2002,49 @@ int __get_huge_page_for_hwpoison(unsigned long p=
fn, int flags,
> >       return ret;
> >   }
> >
> > +void hugetlb_free_hwpoison_folio(struct folio *folio)
>
> What is hugetlb specific in here? :)
>
> Hint: if there is nothing, likely it should be generic infrastructure.
>
> But I would prefer if the page allocator could just take care of that
> when freeing a folio.

Ack, and if it could be taken care by page allocator, it would be
generic infrastructure

>
> --
> Cheers
>
> David

