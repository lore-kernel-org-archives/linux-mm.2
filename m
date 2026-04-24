Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E90ECFED3F0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 17:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05F866B0005; Fri, 24 Apr 2026 13:03:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 010536B008A; Fri, 24 Apr 2026 13:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E68906B008C; Fri, 24 Apr 2026 13:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1E296B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:03:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 313841B72EA
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:03:32 +0000 (UTC)
X-FDA: 84694070664.27.1706609
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4415D1C000E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:03:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o9BWKgOp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777050210; a=rsa-sha256;
	cv=none;
	b=b20jQdhGFWdlF1zjIIcta3LGQ+uD11TrLqdCxg8zoQ8//bUUnUSurOqjm4Vntc1b7Gej5a
	g0naX420BvGFQGz+e6L6tBMYOWs6fHQBuypOq0UBw9FtpZOfEdvKPaZvYsgjup7xcqdbHq
	Taq+xs54o64XUFIQNva7wFP5jjGI+Bk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=o9BWKgOp;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777050210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PxzC51aQA2fUyDAJ+7W52bxyjfPnIe8XaOR5KMc8c0=;
	b=Mc2+CmY8R3jO1pF+1rD3rp3BEKNvmcTYZ+bL8gQnC9alxsZyeS64nW5QMbC/CnumYUgATi
	Bdd6eIx+8JudnEgqnuPZokERRfMdb2y5cgBkjY9BwJsCl1UNkGT7jl4dZEhZI0t6aQ0hV7
	0kFbU5bqKC4ueoFzuNbF/uWUyXURuPA=
Date: Fri, 24 Apr 2026 10:03:19 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777050205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3PxzC51aQA2fUyDAJ+7W52bxyjfPnIe8XaOR5KMc8c0=;
	b=o9BWKgOpkE3OcHqpWEJO+vDuUJZo4r+JopDCV5ZJ2apzJXaFmJlJMcz9cEU44UFD3tq3zv
	5RvcqDTYpdNHMj/q3tp2S8GoRGELDhl/5We5EP0T5kO84ms4J8mG7LWD1Nh5o+M9Io12mE
	bhLgBNx0okXVC7P2Ct6etfY46miyvWc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>, 
	Xueyuan Chen <xueyuan.chen21@gmail.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	wangzicheng <wangzicheng@honor.com>, Suren Baghdasaryan <surenb@google.com>, 
	Lei Liu <liulei.rjpt@vivo.com>, Matthew Wilcox <willy@infradead.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] mm/mglru: Use folio_mark_accessed to replace
 folio_set_active in PF
Message-ID: <aeuhMZ_uriPEYpAp@linux.dev>
References: <20260418120233.7162-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260418120233.7162-1-baohua@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Stat-Signature: 715frfazqyqayiw9uum48r7oosdfz4hu
X-Rspam-User: 
X-Rspamd-Queue-Id: 4415D1C000E
X-HE-Tag: 1777050208-794464
X-HE-Meta: U2FsdGVkX1/VDScyGVNjv3V+HXx2etG5JhOIlIGAScn9g5CM4Ia2YQv7Hk53aIb1LXGKyNbj5bCCsGcPGH1nQohiR47ubWuwZBV+qb4CIiBWgxtxOglYL8sOnE1zFVCGRxA6SwBQTHU2Z2eSMxC6bSFuI8ZeZtqXlkbGj0mPXFYX58uJxqp5ZQRRl7V9Rbay476Wil9psIBag27wt+xgXFdSjs2UJYbthdnRhxTWb1Shw0GH7E/e34v8dXBRp7qs/MvJV+0l0ip+/EjkdMsaNyWo5/MIvET2w0ubJMndcygxjjA0V5byRofDQGsSzNRkkfBLyEqMwO3BmCH0PkV2Rc3dda0fMzNqaQCuKmgTsBvo/rTwtKgpa7sfu3kSi8HsAkCdPw7y5OqJbppZCDCwii+/WDemDZFTW4kC2xGe7RQmu2RV5BssKYwJFYzt9cyOeTm8DV/eg8DPth2DtotbekyV9BZfvAocimsg+/E7uPntGnB8aNFvkoUcvOL4Av/ohHMAJasm1LgHirQ/7di5+x5Pn7cirRPrGIXqJtwJpaZMDUSGJSTkY8qCMk0x2WadYqZBEgh0+EkNemNL4qMLR27VibpzquqciwswYw5iCzde1uuDFFQbti05cBDUmF++NYUNmE00AB+lyulZ3MnQq4QiQgr+o6qdJ1NSPVLBnBMasCqd1XwD8hFs7lQe1pHoy2sH3aLNPDc3ndaqgaP6McpfNfuj1QWOn1UbAqwUKDRtLGF2d2aA1E88bkg3kZTBQV5XWKTazDI2HE4Ye1LTErK7enFiR9UccCG8fC5u7BVfG8TlzYFBGc8+C3ftKYLAf+DEKAVC4r5C2luCpYEzbOPlFhCijog37QgZVLFr+ZLqe6VhjuJFxy1bWJWkfE08WRbpFJTXm3ZooSS9J0he30uPG+cBsD0xez/bAV/T/TEsNXJ3hBGZWdBQgae5We2VFro70N2hyNs0RwvXa/j
 dYcxhtEp
 j2KC33OQZtp1ocWwhF2TZZfDDm6CC1+m2wBiahGEAVF6kj5WHFX8hF2EEpOkAEWeoRJXBJJs8gn6SYyEXqhkWtelOyz3LUFxM31r3Dq64nA5Bcp1Hf0aB5DxpS1MLjbfrehemoWn7Hqj1Cyl5skFRiWppdMa6K865pGHovf0/B5tHHipvaSwFaQG2ynQa7qDG/2bjlDFvnTRkOBRxfmPwioE6PPJWpV40UKZTWLIh4H3Z93zk0MAlsnEehXBCHMTJx/0FulBaejjNGEjIpk1RP7aLvqrOGXHvg/Jw5Kc/cWiJ63cyR/CrVbdu9qxb+8oNvNfRE5AmQGGQWVU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Apr 18, 2026 at 08:02:33PM +0800, Barry Song (Xiaomi) wrote:
> MGLRU gives high priority to folios mapped in page tables.
> As a result, folio_set_active() is invoked for all folios
> read during page faults. In practice, however, readahead
> can bring in many folios that are never accessed via page
> tables.
> 
> A previous attempt by Lei Liu proposed introducing a separate
> LRU for readahead[1] to make readahead pages easier to reclaim,
> but that approach is likely over-engineered.
> 
> Before commit 4d5d14a01e2c ("mm/mglru: rework workingset
> protection"), folios with PG_active were always placed in
> the youngest generation, leading to over-protection and
> increased refaults. After that commit, PG_active folios
> are placed in the second youngest generation, which is
> still too optimistic given the presence of readahead. In
> contrast, the classic active/inactive scheme is more
> conservative.
> 
> This patch switches to folio_mark_accessed(). If
> folio_check_references() later detects referenced PTEs,
> the folio will be promoted based on the reference flag
> set by folio_mark_accessed().
> 

There is a following comment and stat update in lru_gen_refault() which is
referring to setting active bit which this patch is removing.

	/* see folio_add_lru() where folio_set_active() will be called */
	if (lru_gen_in_fault())
		mod_lruvec_state(lruvec, WORKINGSET_ACTIVATE_BASE + type, delta);

Is this still relevant or need changes?

I have not yet dig deeper into the patch and the heuristic. Will do later.

