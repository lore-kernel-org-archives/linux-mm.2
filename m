Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E981E6B25B
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 22:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9F96B0005; Mon, 22 Dec 2025 17:06:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB9FB6B0089; Mon, 22 Dec 2025 17:06:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B74DA6B008A; Mon, 22 Dec 2025 17:06:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A655A6B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:06:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3748F8ABDB
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:06:39 +0000 (UTC)
X-FDA: 84248492118.09.46EB51E
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2406E1C0012
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:06:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sykHpx47;
	spf=pass (imf20.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766441197; a=rsa-sha256;
	cv=pass;
	b=DZG9dzRu/DFO80mr+7jaoCDFmWGUaPBYhXxSL30AfmY9j5tEwUd6JX4+SycdjoR2AC508q
	waSxm6xRoM6MirRbU3fCWmZ+5NFOKv1DtVxbXT3CMW1lkE+R/ayR5qQZ0wIxOxjD8VCo4S
	OG3vEdMwkM5UfFBQ1q611AVFPVx8fVc=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=sykHpx47;
	spf=pass (imf20.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766441197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OfiiUBxHODIfiFAu/omMDMpEQbjjQ/pM2woKEhucF8s=;
	b=WRnq32qzaVnx2AElVRjuza8NqNI3RfXB6TpYsGqBefd5XIR5rxK/3JOKlt77vZzpPIa/c9
	u0ty+wJRx8wS8IxnLboNnuySrvgoEx6KyCC7jRD/P+DD3BORA4REjyGiQPgN9YDoHYMOHL
	nG542HFZmcVlDeGatrn/+Rg/bpz9MP0=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so243175e9.1
        for <linux-mm@kvack.org>; Mon, 22 Dec 2025 14:06:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1766441195; cv=none;
        d=google.com; s=arc-20240605;
        b=Cvqd+uRWKwlLQb8Di54AVJMWetQfqhE7QJ9ekijh/w3HtaJ187jZaCYgoSuaXjJMzO
         Ly7e1Im5Fc9mCJ6Pmdf4Fo9w8wlqMa/nqMY0ISrlVeprA6bdLYLW2adA1MQSSSHxR1Vi
         HZbBiRuoCiPD903CoV7G0QxRsUUGqNyyXt3yRGjFAd3+Qqhe4zUVpER/HU278FhL3IhX
         FH9ObVIsqeRfyh/J+he9WxSJJueXZAazinhcciTlLNLq0lLJ/BiZzigNaKL5DFYtPDbF
         zBue3GqTKgU+MHMuvo7ZG3D+5z7Od24t1hh1sTknLWISBgigZpRvbM47A/sWiNLZAIaT
         07vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OfiiUBxHODIfiFAu/omMDMpEQbjjQ/pM2woKEhucF8s=;
        fh=JKI4Zk4ju617q80zilUc6cPRnPw/5Vclq1bEs8ks/8A=;
        b=Axr5oDOqRQZR1j/wzWSYeLpO5fm/NIHSEojcT0iNkMpZ+RXwhSf0zVT4LhdBr1ipLd
         +/GuDrEFyZFvi+JblZQ910clnl93lVIqZQGQW3riG8rFyxtsF25fJH0CDsvmSeakrEMc
         gFIMpcKGJs6pMbucB9b24dOGvrzgibVw3GZrTLce4CGfW+88y3lDCIw/IrMW33Yie4L+
         kJrR/47pEOWAL3ZWpmfbI4tATRuDEMsiMFVb9aIqI79NXtY+c4KEdLI0peFHw8y/0yMY
         +1meHDLrzu2WB7zleDi86FxfqoFBNpKizwDbm0/arqnZNbcZbv67JYfGRsuv2glSncTt
         Ns2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766441195; x=1767045995; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OfiiUBxHODIfiFAu/omMDMpEQbjjQ/pM2woKEhucF8s=;
        b=sykHpx47/VEcAer/ZGZUugAkX2ktcRZM8ev89nOQa0Rs0u2PeH1KAXmY83T/6ewtXi
         WQg67Wq/DbY7hFg/jZdVCAjyfLf6D2SG+U4hOp7QAciz4EBjh/j5tQK6bLdmuNntmQsa
         QP8PA+88p/Bo9WzVH97y0xCIX7TbmlKTvtuA0EPn7DWVCVmSYhMlXrCl5NFzM/h8lHrJ
         lp491JViGn3zxTc0/S9Hem2eic2J8guQ9L29izXwT0IiM2iLWGGHrNzM9u4p5qyn+soR
         jkuwMVDuSFTaUL1zMPHD7wxBhevLDljHmP2stfAZJc6yxx9YIfs0D/IQtMxOkrNfaVph
         Qa/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766441195; x=1767045995;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OfiiUBxHODIfiFAu/omMDMpEQbjjQ/pM2woKEhucF8s=;
        b=YiNO+jyzyCYIuwj/S63w6pjue+LDGUjTbZ8AKHpSjIZ2OrpvNIun06MUDAvXoNbdFR
         VuN0h7g7kM9UjrUTGOlrWBTwsmPp9RLfYz9QfYim6iFMDRSU8DtvVUcGRt/Situ4ylVW
         HSZB0K+KtBp6rrNNH8B/pJZ83W4G64JP8BJ+u7iW7w/r/oXZ9UiBNuDL15Q/ZGbDe2z0
         V7Y8u943i1ghPuJb2DHHf/WQ/xwyGdSvGxRBS9EYTvyHBtNd2fXBOx4gQ5vShZ8I08nb
         RQU0OgDmc6RuTWWXwX/HKPHn+yt49e+SKnzAU7BxMrfPB4DYyA1RAeJ4/mvJakjdmhsL
         a4fw==
X-Forwarded-Encrypted: i=1; AJvYcCUrE0D10zZkH51ktzlc2JJTm7aBrbabltyRCkKJ635nF17KtPE3pb9U6wDoZ55/30XCKH58J2IhHw==@kvack.org
X-Gm-Message-State: AOJu0YzlTuxubpFVW2oYIbPASQiBxZ2yFTDHbYTg7se4zVOO8S7bDKlO
	EzywOdQ6idmtdh4jPmBYH2uxZa1iejzEgMBN+uxURNmm1sbeaJSh1FfOQzUZ1MNGGd9NCOAf0XV
	q1uAkVGdKkAJqdfaX13mXQW0LeCYj4FuayYPkMcyb
X-Gm-Gg: AY/fxX6wX8qciorasCrAR9mefGPYT5ONF8eeSD1uCIWnzr6KiWdw/FY39oISsZTZJqG
	ML4GGPOcbA8nTWEzpnctjwHsxJb1lSSlmxx7tzxzYOX3Bvc6RULHjM7HB7PfnSJN+/V3283TmOU
	XXHZ9hl9QuOPbygz+tazcDtxtU/qINDrR1436eu8AtT8yq+0rQi8lRDxIGK9cpU5ROk6n4hH8fN
	qUs7jDS6cq3oz/AbuJpa3WLf2UmULQZDDtCbOFInFh50+Oe3FoIvLyyNL0ig8+kEi5wHUyDLbLt
	ty4Whqe4Uz6buE0xg0RLWR0KRA==
X-Google-Smtp-Source: AGHT+IG05ffXZWoU38Q6y7vtEIY6XB2qFmMV15Q4qFB6H0ckZwZp+YJcjkjUlt+tgsAXAXdrW9Bnte4pkn97IRTOikc=
X-Received: by 2002:a05:600d:10:b0:477:95a8:2565 with SMTP id
 5b1f17b1804b1-47d22249c3bmr1872065e9.16.1766441195119; Mon, 22 Dec 2025
 14:06:35 -0800 (PST)
MIME-Version: 1.0
References: <20251219183346.3627510-1-jiaqiyan@google.com>
In-Reply-To: <20251219183346.3627510-1-jiaqiyan@google.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 22 Dec 2025 14:06:23 -0800
X-Gm-Features: AQt7F2pFQFw-1QvlKZmn-HhQidNRfDhVja2Md4Rwvb8cHh3NFVoNYU0yQxVjmHM
Message-ID: <CACw3F501wCmc4G+69pmkkONTxUNJHeuo+7JqHhQ2W-L9vQ474A@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] Only free healthy pages in high-order HWPoison folio
To: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, harry.yoo@oracle.com, willy@infradead.org
Cc: nao.horiguchi@gmail.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2406E1C0012
X-Rspamd-Server: rspam04
X-Stat-Signature: y3rr7p34yjd7f6bbwx79dbz4tjrsrtcm
X-HE-Tag: 1766441196-88953
X-HE-Meta: U2FsdGVkX1+cu/xvNV1rYZ3c1+9HElg0KsaHivL3dMnS372MwilwA94HC0nueiJLb4IamVT7O2EY0+WN4Z7GNToCbQ3ekrstOIVkRaIKIaswDNXiUMkuZ1wGgbbIAWXhCPHDGAiJiu7sl7DMFOQ2mXbnpx1h7JHrIcF4HrmF+dZTaE2psg/vQxxz5EFz104nbJPeguSsNvl1T5DY6QiHzHB6xYuWP1oaCW+RNKew02N/pxROqzIlrWntKBaGMqNrhF3uyKHVn22bbqArVWquK1PBiU+h1oOqhPFc0+Zx0DDedTAIj6K1InuywQjVHeIOTY4T3kVJUF1HeOtIrTMNKBWshtl5d5+fZy5lKvnhpUXFac8et6/gVW+xN69TAU5lyo8ejozFQ6OazE5SZP0M7dtFhgr9aWQMDKZfKyrtSKtdAKZqLs9PgurQCLVWbhp3BSbigU7wK48p5gffZnBTmmE/3jgGpMggFG/8lNg8Wt5cXIAmnGOPDGRAzQB2gCQoatBoHBHMAZCNqKbIZA2Yi3sQuSZ8BrheL4hWGpuXvzJ1HuWoPsNwOFa97+aSZ9DWWRb6CMGb6RLY99Huik0b3CjaqZ+F4fyRbjnTvtOhwIonKVWzOHLfGC6yLNnc2dgKXBbjtrC9TfM1wWe5XyE3OvFPpEM7oEjrK9a3pq9YFzpQ8tLteWWljKfG8NVLL4b+UlJw8/R7bOfkEPTGwoDWLEdP94MghsKpjsQ3HyTfuV1v8dM/o/3F+Nz69RaxvTI1AfTHAqSGBawPsyUbtfrCLGfwAKnT/WTB1QExNe24PbskgoCQeWmfp+W7dsXCsBzSKmTQqCGp9TfKBd0Q81keeYBXmtsR5pPzU+HbXAxujdiaYJFBMFJXCQJDg25J9fncxnnWJWdzF5vgddPJuVc+zxBrDxlScFknbK88MojzKa3jDjN0d2no5MwAZ2hE+3txfc/GumuXgzsn9MxnJEL
 zcqaOqYV
 r+xbUEblzi7/Q15ReHap25+aIOZnE4L1JbC+1nQEo/3nsH2Ov8pSKofdNLAui/7tU01zD11hCYZvn+liBg/9BZmQbxPOnTLvvMnc2xB8DVx/+TiuMjHNJ8hgHGYYbcMMZwXfm34EpNKd1SqeJViDDKKUfLsv8MWfKZFGRQ4XnMeOZQUK0ydp6ZEWnArHlMEwDXTh8rIxJst0uygKJphCauJDnXo4G/Et7D8vHG8kg7L4VsK3lxoAJbBU5qrT9Q7m1EqRNjEenHUcRSAWiAJv4EpGZWHHnXmLh1yBtQtLhyBbpQHmTpPCy5oo9D77ppp7+rBsp05GojWZMyYEsH6/roSzJDh8lY/oYX6BxTlCf/GBTw3zwijfVTtNjZNf2XIVnEGNLDtgPUttROwMLft0xnXskvBL7QoRqiFoAJ87lx0hEPNyPrnIqRRzRcdLmDtb4+fr+3pa62TFwdVC3/hKoGzXfsStaUR6GUJMIR/XHiTUAVzx1xlxau06PCszzoIjUNBhiXSPOK4pU0LuGLiOnt389Sw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 10:33=E2=80=AFAM Jiaqi Yan <jiaqiyan@google.com> wr=
ote:
>
> At the end of dissolve_free_hugetlb_folio that a free HugeTLB
> folio becomes non-HugeTLB, it is released to buddy allocator
> as a high-order folio, e.g. a folio that contains 262144 pages
> if the folio was a 1G HugeTLB hugepage.
>
> This is problematic if the HugeTLB hugepage contained HWPoison
> subpages. In that case, since buddy allocator does not check
> HWPoison for non-zero-order folio, the raw HWPoison page can
> be given out with its buddy page and be re-used by either
> kernel or userspace.
>
> Memory failure recovery (MFR) in kernel does attempt to take
> raw HWPoison page off buddy allocator after
> dissolve_free_hugetlb_folio. However, there is always a time
> window between dissolve_free_hugetlb_folio frees a HWPoison
> high-order folio to buddy allocator and MFR takes HWPoison
> raw page off buddy allocator.
>
> One obvious way to avoid this problem is to add page sanity
> checks in page allocate or free path. However, it is against
> the past efforts to reduce sanity check overhead [1,2,3].
>
> Introduce free_has_hwpoison_pages to only free the healthy
> pages and excludes the HWPoison ones in the high-order folio.
> The idea is to iterate through the sub-pages of the folio to
> identify contiguous ranges of healthy pages. Instead of freeing
> pages one by one, decompose healthy ranges into the largest
> possible blocks. Each block meets the requirements to be freed
> to buddy allocator by calling __free_frozen_pages directly.
>
> free_has_hwpoison_pages has linear time complexity O(N) wrt the
> number of pages in the folio. While the power-of-two decomposition
> ensures that the number of calls to the buddy allocator is
> logarithmic for each contiguous healthy range, the mandatory
> linear scan of pages to identify PageHWPoison defines the
> overall time complexity.
>
> I tested with some test-only code [4] and hugetlb-mfr [5], by
> checking the status of pcplist and freelist immediately after
> dissolve_free_hugetlb_folio a free hugetlb page that contains
> 3 HWPoison raw pages:
>
> * HWPoison pages are excluded by free_has_hwpoison_pages.
>
> * Some healthy pages can be in zone->per_cpu_pageset (pcplist)
>   because pcp_count is not high enough.
>
> * Many healthy pages are already in some order's
>   zone->free_area[order].free_list (freelist).
>
> * In rare cases, some healthy pages are in neither pcplist
>   nor freelist. My best guest is they are allocated before
>   the test checks.

Sorry, just realized changelog is missing. Appending it here:

Changelog

v1 [6] =3D> v2:
- Total reimplementation based on discussions with Mathew Wilcox,
  Harry Hoo, Zi Yan etc.
- hugetlb_free_hwpoison_folio =3D> free_has_hwpoison_pages.
- Utilize has_hwpoisoned flag to tell buddy allocator a high-order
  folio contains HWPoison.
- Simplify __page_handle_poison given that HWPoison page
  won't be freed within the high-order folio.

>
> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mg=
orman@techsingularity.net/
> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mg=
orman@techsingularity.net/
> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> [4] https://drive.google.com/file/d/1CzJn1Cc4wCCm183Y77h244fyZIkTLzCt/vie=
w?usp=3Dsharing
> [5] https://lore.kernel.org/linux-mm/20251116013223.1557158-3-jiaqiyan@go=
ogle.com

[6] https://lore.kernel.org/linux-mm/20251116014721.1561456-1-jiaqiyan@goog=
le.com

>
> Jiaqi Yan (3):
>   mm/memory-failure: set has_hwpoisoned flags on HugeTLB folio
>   mm/page_alloc: only free healthy pages in high-order HWPoison folio
>   mm/memory-failure: simplify __page_handle_poison
>
>  include/linux/page-flags.h |   2 +-
>  mm/memory-failure.c        |  32 +++---------
>  mm/page_alloc.c            | 101 +++++++++++++++++++++++++++++++++++++
>  3 files changed, 108 insertions(+), 27 deletions(-)
>
> --
> 2.52.0.322.g1dd061c0dc-goog
>

