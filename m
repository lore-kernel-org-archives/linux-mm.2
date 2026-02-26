Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ADD0FC5903
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6D86B0088; Thu, 26 Feb 2026 02:55:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B84BB6B0089; Thu, 26 Feb 2026 02:55:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A66BD6B008A; Thu, 26 Feb 2026 02:55:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5CC6B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:55:55 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2AD675C064
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:55:55 +0000 (UTC)
X-FDA: 84485849070.29.EE15698
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 466EFC000C
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:55:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I8DUUtGl;
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772092553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdRtsLUQfCDc5iPsCOodG6em0TwbFpXFEtbprvISMYg=;
	b=Bok4wkZ43T4L19YMI96he6R/sW1pqbiS8Q2Mk8tFzINkm4IJnUE34A/8kuXKOc4Hs8AT9d
	OAUk4P1y1/u4LeBYbZaBPi0Xc7SmaG6St9rMh8WYKvNvaOSppy93cxb6zw47ALYL8Ashvi
	/YQk6fwd9vB9JhAXBgvF7zb2gtwGK18=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=I8DUUtGl;
	spf=pass (imf28.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772092553; a=rsa-sha256;
	cv=none;
	b=estbdzjoYwIsAvmc7CpKtNA8bSuXOuIjE6nPXUB0tBFthV/I5twu3gg7IgF928uSoE/Aen
	Rb2j2k2deXKz9RS0cZXDrVHbsQ3bgL/tqDw9jzFltC+jUJLn7FVYdmqHwMzItLynYSkzlV
	FVQotJKFANSKZbjAwq5MKv1agrKLx0M=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3594d7b36bdso12398a91.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:55:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772092552; x=1772697352; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VdRtsLUQfCDc5iPsCOodG6em0TwbFpXFEtbprvISMYg=;
        b=I8DUUtGlN/2xNt4BsO59Ht1FsE9LJ5JRWLL9lMjlLXd45Xj7I5Q7cFuUMnat/kkBjb
         Ha/VuQJtAcr3BmEGxo8FMNi9djzZcdZR2QZQ4NMIUnZuMdnDMGet/7G0HuGyK81Y+SDn
         zP/lreijjvkL23M4V2c7ozk8uGoJxGCYFsLQj4pTBNYTYTkI9xXkr+JJmSwgwRvYOgGM
         SJ0s+cPdxL+EglssIfv7OtHQDOIBQD6YoKFl31Yg4sohmFe0gXdq0e1r11LV8TYFP8dc
         weU0iQCvX4RM0fPwk8+BveVvOHHs16hWMByt9KMBgwugimY0vWUlG7KfQKq4/033KhL/
         AGEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772092552; x=1772697352;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VdRtsLUQfCDc5iPsCOodG6em0TwbFpXFEtbprvISMYg=;
        b=M7ISL1Szxl5wtIlTTu6MPb7dLWlqR8H/LfKq5DRD3bzjzPjX+IuKvD9JZ5jNH87RoN
         bYBnkloQTgw353G5mNibcbaBkrk3AXzt5acJ1qLp4/bxxEYMA8gwpIe8QZZarLJTQa0d
         ZIunEldaAtsk9rl5/TIPLG14JuO4GJ0ZC+Ea0gRTozKglOtxnIaqPIo0SFdXE3Ym9BlW
         jE1Eay5VwsmM0I25FjlVPV/uMmdnRkAVKDUbY6kX1xjxu3zrfFLTVzcUxSib+/Ksdl+Q
         Ac3lHiVfusoEBW1B5sbDLaAYcfEtzfyTJH+a4262qrqB72oDw6+YKwvzitdcdt3AN2Ok
         oZDg==
X-Forwarded-Encrypted: i=1; AJvYcCV53MUuaEnnp2T1flw+2LiKrnKYHitLiyVkX+7LygKDAcfD9M0uLgOaNJjiD3vyzqguoEsWNyb3rQ==@kvack.org
X-Gm-Message-State: AOJu0YxBhehO9EKH5vDO94KkRIBkALohCQaJDhCIIGyy3eKvj7J857+4
	7iB7SA1HRu44Gq+ZmG8Y2gG+50L3sGX50XDuApn+S8CGeLJbM7onG70z
X-Gm-Gg: ATEYQzwhAlIHIiA2ABFuLsK6oO3+NqZCHyxufhoD//ejdke/K1uuCugP5bDt+N4Z/b/
	sxVwXdeUBk0XPHiSqdfP7Sci5xYh64QqySnrc0xB7flyxc2JilHv2ykbgbsJ3GiBTGRtpkkHpKN
	Dav4SY760WrIpSUC0hN+fgi8WKk4XRBnEBmDW3Hux0f3TaLoLWiAapG4r1vtKkAPWBmBp6CIonJ
	pOnF77y82WYZpDV25xllkRNh8gVVcL6ceqPe3yDG+LvLoBPatSnnBacJ4g3fnne6ztkxmOP5RlR
	EujXc41H+4f2K53s3u/0o5dk/bqIPVjzBXiDd+tGH0Cr9iyjOGzE4lA11AkPJJZWC/ZBhhyZy+d
	Le+oyGiZaqkr6d9sx3XmKxnMu0P8r+WfPNMPW25LmH5fqydXpgXZvNFPWAqEmKhUXrvZdk7AuyK
	LeNwE7ZZHwl7dApdeNS7qoQ9VAKdhQdtNbSwpjNB0Pk4jAnXmXYjdluqKUEByf6h0Wc71axPegi
	GYqxA==
X-Received: by 2002:a17:90b:3e50:b0:34a:b4a2:f0bf with SMTP id 98e67ed59e1d1-358ae8a5315mr16693593a91.16.1772092552046;
        Wed, 25 Feb 2026 23:55:52 -0800 (PST)
Received: from localhost.localdomain (n058152022173.netvigator.com. [58.152.22.173])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3593db82627sm1217069a91.0.2026.02.25.23.55.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 23:55:51 -0800 (PST)
Date: Thu, 26 Feb 2026 15:55:45 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Barry Song <21cnbao@gmail.com>, akpm@linux-foundation.org
Cc: david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 4/4] mm: khugepaged: skip lazy-free folios
Message-ID: <i4uowkt4h2ev47obm5h2vtd4zbk6fyw5g364up7kkjn2vmcikq@auepvqethj5r>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-5-vernon2gm@gmail.com>
 <CAGsJ_4z1twdSNrAVR_vZRnLW4xtsfi+vegNMCwht+RPCjy=E4w@mail.gmail.com>
 <xbej7d3uc3xzlx53djgg3to3ejcgrxotxwxvrdppqxfsgieife@5moeg6x2vutg>
 <CAGsJ_4ycodbcWHxFRacpzbxx4evQRJbuqJy3gfweAdHOtJg1Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4ycodbcWHxFRacpzbxx4evQRJbuqJy3gfweAdHOtJg1Og@mail.gmail.com>
X-Stat-Signature: qg6samj3ghb6kihgy3su45azxy84x4nm
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 466EFC000C
X-HE-Tag: 1772092553-166272
X-HE-Meta: U2FsdGVkX1+2b2KaeLUjyytyIZqLWhttDQbchyQnSncvcrPDm2ItZrxHFG77pUMdGv4EOdk55V+g1/bi0rua8DuXfKjMtIbguZuQ6gAWwsl6akUk3sbMH1ugEsezNZIP1qH+Tcp/IRuLESEP25PiNMX4S9rU3g5wCaF96/GU9idOScDMhyyaskSHYLmCAE/lCDMMCWWjWkaGcTtfJE5wDPc2C1LJPvVpqrs1mKRacf3Gru4Kxq+y1HFygOvf8MsARWnlfc4btt16j6JIXfedkWGy8bQmXAqNAl4G6XpcTU06a6EoW4Rk6MTrV/e2hP0d02LFkkB/tx4S5CMhsqPe4ybODq7/2X4oROnjFAJChZyw41Ru9PmmemvhFV7oIv6Ca1unQw5jimouitjiNKtHqgLG9AveLg4oXXbK/0ehLIpUmoy5LsQb72sWZ1ccA5s5OxVFhMBySCrOJyN/ieO15fPuNqOWJQScJKfBgWaJiNWCtjMXgWS1JvD/C8dxoVX5gX2H37AVhvZyCAOGPnR7cmkuw/N8xrTld59Y6ELGhbqcJLN9u2SOsQf8YU/eJxd/df9gItvOWYrAtbvVSd02vXmn5ZiLyynaTwRXCbNPOHSTuMhpcALtM7eFYC5kTl4tWnWXvRnOnLNm79dtBD690w6so/AEZNAbg+i2z/G1/cv5n8+ywNMviU39nQ58LF9EmU/kB4xaYNOnMDiDiBqDBlUtRCz2YIu5ln3mJDwh6rmczBs9N5bZIu9bZDgHWoSQjbmJ4tfFi3i1cUqpzrFal89udPFmJq+j7YKj2xMVs1koThjyFv0JxlA661si57zELFhfoO26FmV+/xWByla4zrOhSIuwG0ghEKlqaTHHsa0/nG6/ifKzWZKvNbrL9Mg9sUYxqkLV74/Pf+CAX+lhRJs8B7PI8Nq5h68HURV5uRlj9LlLCIw9a4ly2xDpHRCSfOW+hDX3FRXxlHvQk0N
 M36TmRZ7
 snwThGIz4HjoiFOMbRpFnYddSeimkAhTvuZ0QKzIjry5D5J/LHkMyPj5wFJuCdfFq9njEqjqkmYHLV6+Oecb8+WxoJt+5vpQUCnSLkcbyk3IjvS4ZgHyZCCADR5+kK8AjZnJq3CwNTlnHAFebOhE/Nr0lW8qsN1SGNt7rafpBP5Aa65k0OwlrRuTT5OChnCp+f4ayPlNF7RQpyk+jH2LCGy8QmqseF/Dh5IDpQXnmkH+zqCupU9UVLW2HdoPjmVQQEAkz3UaWnKGydTHl0UW9ec4+HQn3g0VB8J6EL6NmGgoBKZRz7yilljg6uyc1JLEwnUMj+QJh03Jjxz+Pc1eDkfgMpNkw6E9PjjG+YkGJHahvVK+RiA3voTFzxUuH4T48Dkvnt/zYbOm9MjHYijtKnilDMdPgHYCTpn5OPKVkVQzdezEBI3u5EZs25Keb8Wadq8aFITO4fwc/DcD1QvhlErrDIkjCNAIbxjxSMpjP6obubQRCOcZ2gmf5vZzjjJMxutjakPeYRZxUbv8t5RkAmvorIvjdg+WAfr1IyTpparMLbX6kWniA+07ytxjQBzJy+siKp6axEJttDPeIYuS28gqlS+hhtzcX6I/efJg8HNr2NBY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 04:10:47AM +0800, Barry Song wrote:
> On Sat, Feb 21, 2026 at 9:39 PM Vernon Yang <vernon2gm@gmail.com> wrote:
> >
> > On Sat, Feb 21, 2026 at 06:27:36PM +0800, Barry Song wrote:
> > > On Sat, Feb 21, 2026 at 5:40 PM Vernon Yang <vernon2gm@gmail.com> wrote:
> > > >
> > > > From: Vernon Yang <yanglincheng@kylinos.cn>
> > > >
> > > > For example, create three task: hot1 -> cold -> hot2. After all three
> > > > task are created, each allocate memory 128MB. the hot1/hot2 task
> > > > continuously access 128 MB memory, while the cold task only accesses
> > > > its memory briefly and then call madvise(MADV_FREE). However, khugepaged
> > > > still prioritizes scanning the cold task and only scans the hot2 task
> > > > after completing the scan of the cold task.
> > > >
> > > > And if all folios in VM_DROPPABLE are lazyfree, Collapsing maintains
            ^^
here

> > > > that property, so we can just collapse and memory pressure in the future
> > >
> > > I don’t think this is accurate. A VMA without VM_DROPPABLE
> > > can still have all folios marked as lazyfree. Therefore, having
> > > all folios lazyfree is not the reason why collapsing preserves
> > > the property.
> >
> > In folio_add_new_anon_rmap(), we know that the vma has the VM_DROPPABLE
> > attribute, which is the root reason why Collapsing maintains that property.
> > The above commit log clearly states "all folios in VM_DROPPABLE are lazyfree"
> >                                                 ^^^^^^^^^^^^^^^
> > (the "if" is redundant and should be removed), not "all folios are lazyfree".
>
> Yes, we should remove the if; otherwise, it’s misleading.
>
> [...]
>
> > >
> > > I would prefer to add a comment about VM_DROPPABLE here
> > > rather than only mentioning it in the changelog.
> >
> > Is the following comment clear?
> >
> > /*
> >  * If the vma has the VM_DROPPABLE flag, the collapse will
> >  * preserve the lazyfree property without needing to skip.
> >  */
>
> Looks good to me.

Hi Andrew, could you please squash the following fix into this patch?
also remove "if" in the changelog above.

---
From ab5060c7be655dd00bf3a9abc779915922b2f969 Mon Sep 17 00:00:00 2001
From: Vernon Yang <yanglincheng@kylinos.cn>
Date: Thu, 26 Feb 2026 13:18:39 +0800
Subject: [PATCH] fixup! mm: khugepaged: skip lazy-free folios

add comment about VM_DROPPABLE in code, make it clearer.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index c85d7381adb5..7c1642fbe394 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -575,6 +575,10 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);

+		/*
+		 * If the vma has the VM_DROPPABLE flag, the collapse will
+		 * preserve the lazyfree property without needing to skip.
+		 */
 		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
@@ -1333,6 +1337,10 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		}
 		folio = page_folio(page);

+		/*
+		 * If the vma has the VM_DROPPABLE flag, the collapse will
+		 * preserve the lazyfree property without needing to skip.
+		 */
 		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
--
2.51.0


