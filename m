Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B22AC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499C26B00A6; Mon, 21 Sep 2026 17:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471B16B00A7; Mon, 21 Sep 2026 17:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386BA6B00A9; Mon, 21 Sep 2026 17:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 169526B00A6
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:57:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D40C802E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:57:04 +0000 (UTC)
X-FDA: 85239130368.03.D46B4D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A89864000C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:57:02 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UWLymRA4;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790027822;
	b=CI3AvGfCgHUJ5Z3hgz7mHosUtV6rWLZeqRJ/dRsW4JUQVU97focU1m0bEoo4Hj2AA3r5MP
	mygKWI2cHHfuSHHcUu8ZbNY1Lp90WnVRsdlaB85GwRKPhURqn1ncMNeVp/5ZEGfDS0qPMy
	FCOmCj2RRZThJKcYcnY3Kac4ltcFdAw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UWLymRA4;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790027822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qSVVL7TW61oF74m7rSQbYkMlEzrUZT28aAJlLtjv558=;
	b=gd6fUDyCVOKFdNaEeRPSdA929agKhXRoqZgsJF8UahNhQvXlIPRLHCaUX16QpZGquJEPMF
	Uk+XQN9+p2jqgruAFrCVlKBVzh5V3+9LWnsR+0aUqgh0Zzkp5PhkQBSOwSE/GOISoOvgIm
	S2BLNjvUsCEVZN3z08OzRH0zIbe2Zto=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2CEE40B72
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8639D1F00893
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790027821;
	bh=qSVVL7TW61oF74m7rSQbYkMlEzrUZT28aAJlLtjv558=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=UWLymRA4dRaUVCNgxbyFuI0sgH1RptweTBoHL1aoPAuEMPHD2GwK9pr0Y2/F8IjtC
	 AzsMOelpBRu0ibT+YgaKcQhY81MQunCrgiY+70Hj0oQsicaHoDvg6wzTkgWnekys1o
	 nH7DX+jrIEledtA+S+0dPk5Gq2D1lzBOG37kumVi5PzgS9UymwW6pillHTZq/mv/oL
	 g3c/aJpf021oj019kcIeqxkxwSe2KcGcCKuIfazdIUADNGLvQU2/+s9zuMNrre1uHN
	 nMEU85phY2UHu8nW59GB50G6dPJ9t6WeC20yS8fp5o1FO1Na3An/OIR6q4HgDIOiXW
	 TZ3uhGwcAxTCg==
Received: by mail-qk2-f43.google.com with SMTP id af79cd13be357-93910ad20d4so381925485a.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:57:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByjdXA9zLjNQCVa5WO3FlXm2LTnKtWzG4wsYLYQ+GmGW88mzxRYpUrWjvpJSbYxiQ3aa8KA3LXsng==@kvack.org
X-Gm-Message-State: AFuF++m/XJS/fnoTfP5rHYTz29pcDwRnoovSNa916WrRzeo9R/p5r3zB
	Zb6G+O2E6wN28rjimu/22nKSgnQ6OonViu4LRxKv1EpRYcVW+gofbqhxDA8a1YuHJLV4hgI2eTd
	BzxAecDNdUSYxXbnQ6MLszGNC0buXoBM=
X-Received: by 2002:a05:620a:2893:b0:937:d6e8:59b0 with SMTP id
 af79cd13be357-93c15d69efdmr230732985a.10.1790027820912; Mon, 21 Sep 2026
 14:57:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260921152449.629486-1-alex@ghiti.fr> <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
In-Reply-To: <70cae945-3a4a-40db-96ac-5ce66a3fa186@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Tue, 22 Sep 2026 05:56:49 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
X-Gm-Features: AcwNN1VSw5Rr4NROqiaRDFlkbhVNl6ttklStB_B4KIyo7Yo7DDoF7gUuyR6ZS_s
Message-ID: <CAGsJ_4y8-wD0yMV8GCtCz5MfNrOKqUaTd+UgH=8MoP_nuvPnGg@mail.gmail.com>
Subject: Re: [PATCH] mm: madvise: drop MADV_PAGEOUT folios at swap writeback completion
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Alexandre Ghiti <alex@ghiti.fr>, akpm@linux-foundation.org, willy@infradead.org, 
	jack@suse.cz, liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, 
	jannh@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, yosry@kernel.org, 
	chengming.zhou@linux.dev, kunwu.chan@gmail.com, tz2294@columbia.edu, 
	hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A89864000C
X-Stat-Signature: 18czt11zh4r136f7ew1huygcwdkmt4tk
X-Rspam-User: 
X-HE-Tag: 1790027822-209932
X-HE-Meta: U2FsdGVkX1+HFenlgyyJmSEpiN0PpMCXbhQ/m83b9YyjY5+9DwrJMGp/Dgd5ER/2gB4+BMrEfwRLMjhxOjAxDvsQLDPGZTeJwocUWfTP15EDpeZGJwH8bOCEJoqvtBhw84joZI42yuNN80A8z5bPWjeihSnHCJaaJLCgNNxI7RoTOTHZit2brXRVANZmlbh7FFaX+9UZDUTkZ6g/nA4RH7a1KAR0PtcmU1xrebgAGD/A9Pd04gMK6+od0Ps4tv+/o84/Y01lYbVlZhPzAEpUU8sry/7h64l7hMngW97mok0cvZ3GrUb94AOJAi1gzpEE7R185/Y3dfJ8BcnVB0QR9N1dgmexy+CGyokOAQbxT1rv/dOQ09tg+JPE0OKUMjE2/wbj42lARt7AUnPg4HWxsRN+TTswmiW/29wAsjd3BKiaByPkZkpx3DabH3QnEaF5S/QJZDPnbS5nm7kyAPuIeMpyHPeXaXGf83ppVc9IaBq2GWsrHgMSdN4V3mt0pDY1pnnYEaGbIFZfZxFy1aFbqtGh0fgHA3V+GEK7GU1w9npTltinSVaE8r6rrHxG6pbZnf28r+CaP4+93x3OP6zSMzyL+Na9BSPdRvMntTwhmsdSB1PTr2T0FOhYC+Y1LwKBBI5UlWW1XlOwkpFwO8yzpfTTd3Sr5arDa8hHBktzFRMoc0bJ+HJiGYHFeSY3dLw+fP/yrBKZKaenRz56/xTHOeWro1tZ4JswFqj1OdkGhPK3ezUaoWnl2n9VcKZDGJwEZGuxEC6RiYwgXb1l/g8TIy9aZM/PxgkRjIIz2WiDsLrNzDlxWFLvVMrw29en+xRpWqgwyq/K3f8UYtPCyzVwzVeNQJi27BwZKNs/zG0vhf2gPA9ajx8HbOC98faYVXZOJI1Aavz5iG0wbOv8rACyXDdSRQGw+JYQNacyN8fsrNRRUHkuMxXs8QkGkPfsjFSmGHJaoJGGKI/2F8JZUf3
 uwt85utY
 7eQ5PkhAL2wzUEhaf86cuFrWDUITkfX494pY4aD/629EfKBUsRQrLE9RPGz1cnimxCvgyD/YyFyoJVT+oBF8Z7J1XC2qvt1pjQepgCyuzKqZJlmRNY+DC/Avi9bKcffoCRetaUjfPIynTWhU+b5GWLaJhtKUB7OKoGIWv7CAy7/ZtpxyEN1FC1A/+n3BNsPkhWzjuFaQnfRNjEonPfAa3QEMwUv+yNpTxI7yem6pp2z4Z/4PmCN5SnDf6/abNxCzBGx0hsEeTH9HMjJskAFmaZ/4dJKB/Wmmx1Lfzjv+95pz9nxpmsSnGVHPz7ESPl1srPK/7PcDZjpYMfOXpihauqk4gTLZnubbc1UUY1DqLl6LsmW4vzb+PvB7wNzx3nkW0L9/G8qWgYmie5qtUCrt4Fu86b2Jo8bs3k4rw3AvsLWhtvjjbnFGTy9C1Sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 11:37=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/21/26 17:24, Alexandre Ghiti wrote:
> > On an asynchronous swap device MADV_PAGEOUT only marks the folio
> > PG_reclaim and rotates it to the tail of the inactive list once its
> > writeback completes, so the memory is not actually freed until a later
> > reclaim scan removes the by then clean swap cache folio.
> But we have the same behavior when just reclaiming memory ordinarily? It'=
s added
> to the swapcache and only the next scan actually frees up the memory.
>
> Wouldn't we memory we reclaim ... just gone, like in the sync case?

For synchronous I/O, such as zswap and zram, the memory is released
immediately after sync I/O is done.

For asynchronous I/O, such as NVMe, the swapcache is currently
expected to be rotated back to the tail of the LRU and wait for
another scan. Alexandre once mentioned that when he tried handling
async I/O the same way as sync I/O=E2=80=94releasing the memory once the I/=
O
completed=E2=80=94he saw some regression. So, delaying the release until a
later scan may allow swapcache hits before the folios are eventually
reclaimed.

But we actually have a problem here: this rotation, which puts
writeback folios at the tail of the LRU, is not reliable at all.

`folio_rotate_reclaimable()` would only work reliably if the endio
happens after the folio has been put back on the LRU head, rather than
while it is still isolated.

But nowadays NVMe is very fast. If we isolate N pages and perform
shrink on them, M pages may finish writeback during the isolation,
while the remaining N-M pages are still under writeback. M can easily
be more than 50% of N.

As a result, we can end up with the following cold/hot inversion:

LRU head
----- M pages whose writeback completed during isolation
----- other pages
----- N-M pages that are successfully rotated to the LRU tail
LRU tail

Now we can see that the M pages were expected to be reclaimed, but
they are not only left unreclaimed, but are effectively promoted to
the LRU head.

For MGLRU, commit 359a5e1416ca ("mm: multi-gen LRU: retry folios
written back while isolated") added the following code to reclaim
those M pages that finish writeback during isolation by retrying
`shrink_folio_list()` on them:

                /* retry folios that may have missed
folio_rotate_reclaimable() */
                if (!skip_retry && !folio_test_active(folio) &&
!folio_mapped(folio) &&
                    !folio_test_dirty(folio) && !folio_test_writeback(folio=
)) {
                        list_move(&folio->lru, &clean);
                        continue;
                }

This somehow resolves the cold/hot inversion, but leaves the M and
N-M pages with inconsistent behavior: some are actually reclaimed,
while others remain at the tail of the LRU.

For the active/inactive LRU and `MADV_PAGEOUT`, we don't have a
mechanism to restore the missed reclaim opportunity. Ridong's patch[1]
addresses this cold/hot inversion in the active/inactive LRU reclaim
path. To my knowledge, there has never been a patch to address the
same cold/hot inversion in `MADV_PAGEOUT`.

BTW, if `MADV_PAGEOUT` is an explicit hint from userspace to reclaim
the memory, would it make sense to skip the later scan and reclaim the
folios immediately once the I/O completes?

[1] https://lore.kernel.org/linux-mm/20260920132519.3369946-1-ridong.chen@l=
inux.dev/

Best Regards
Barry

