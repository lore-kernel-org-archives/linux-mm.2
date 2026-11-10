Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B91606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 01:18:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zl0pp8oC
Received: by kanga.kvack.org (Postfix)
	id D85106B00EF; Mon,  9 Nov 2026 20:18:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D367D6B05B0; Mon,  9 Nov 2026 20:18:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C51A46B05B1; Mon,  9 Nov 2026 20:18:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 983406B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 20:18:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 178FA1607C3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:18:22 +0000 (UTC)
X-FDA: 85417448844.23.C26F351
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6CA2240006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 01:18:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zl0pp8oC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794273500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4W9ISFbtgCFMCYArZUe7DDHrDlGmnATZOpaOt8j7+uk=;
	b=DyjAbhcp7nrOeBGckwq5zRfGtAGoUscCGnlmRQdrzghSHSGJxk/Kx09xoCvwg9wiJaUwzE
	sRl2gmYLtJVwCqofB3M7lAL2TgzySRiIdkI5DJsedW5CJKxMoaPHphN9VdKbRoi0LAGk3z
	FN/cZxmnmBha+Kzkgf5JB54TswUD3Wg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zl0pp8oC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794273500;
	b=q6dMHziq8jCdtcCxQceCR0R/h/wc7o9Z++QcTUblndr3EuW3dxdaC1DrqvU9UAyaMv4sUR
	lGcgZRX8RNaBTzqETp5CDHjdgow9udY4NiFlae1a8X6llgyxXqZLTPWSvz5OFAexRilRGR
	pOEx7XBvI/QBnJvhYMfUD/QmKIV76us=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E55745DB0;
	Tue, 10 Nov 2026 01:18:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A911F0089F;
	Tue, 10 Nov 2026 01:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794273499;
	bh=4W9ISFbtgCFMCYArZUe7DDHrDlGmnATZOpaOt8j7+uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zl0pp8oCON9HQRs0goyjbzHxLac/2D1pMfxoHCkaiXYzaDrzrabkp6QBCnuZ8pjR0
	 P+hbm4VYScOJj4YSeLIMGILB3MFlqaJp1Cb2s9dbNJiuO1szo1ootxNgv5PSrSWWOJ
	 zhhq1qlZbZmj1Fjmi7zSIUZAbioozGpfTtYQINOwnJTfZz0ZyRNKUy5DENWhF9Eq9Z
	 W+m/SSt0BS/M6jtf+uA3FEnsaMuW/PyEMrXh49NQmDN+SViaBBug2XrToFl5lug1Ai
	 rlIj09vaOgQCufQXZclwCo5f4rIRoOY2mwkXNE66IugIQh+mPhnXHmnPXwhtVLqJ9f
	 xH+HOvbCLG7BQ==
From: SJ Park <sj@kernel.org>
To: Shivank Garg <shivankg@amd.com>
Cc: SJ Park <sj@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: remove unused clear_flush_young_ptes_notify()
Date: Mon,  9 Nov 2026 17:18:11 -0800
Message-ID: <20261110011812.106413-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109-clear-flush-young-notify-v1-1-b37fbafa2686@amd.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6CA2240006
X-Stat-Signature: 7z81fdwmaok9kpdaorkkfgybcciejgcq
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794273500-884715
X-HE-Meta: U2FsdGVkX19/XkKLAb49fQi6PUvhlUTXFGGMgott6tKT0pbWe4pYBLWZjfLNzM7klC0IEJFC1p0W74cCUVC4kZlVD8Af5p1wErjZe2x8/ErnUEZsV2lbWUZKft4pmYGZc09WsjO4YUqTBTF+OVOYoX7x1FCPyxLUXIByWXb684lICSvFomVNNGwMoFiPA4BRdabxsLkdlkMRFo+YuonTwK3iVLCgq2RQtgEcuT1SWz8bih6BCb/gV7IBCd++d3V6uy4Sj7RY3pQxqV+X3hQHs5wvUcLSRupRlCovorSbZDI0H5S+Am4LhtnOKePZ6SwJ/gHRkNJZsl2PsdNvN+zL5m95vPvzWq+S4bULUqdZqpG+5PZ6CRapnc0jOnyX7WYBtMC3xzRcB7MFhEp9SXUtvGh5e3XXLpgLTG4xgGzfw0i7By9NLha775QnyVgzGrNrRfixwjqSYXCQa6dkmhhBvWmmxBEgutfQh2NDY9NVCdWEeMHbW05ARcdjDkgl5gQGk5nFQ9AyCKSzUNOFf8Y/EmYI+zNCGtMbT2hCYaYdAF5HzjixTPTXW8xzgPuHJCIB+4wRztfXvCFndBdqiRApV4W1GfA4impU4VOgS0oIkdDvU3UClwjD4CKbbQMgBG7+P3PpMn3aZryVebKQpNbG1xgYXBTEJLwlm86X2TT3dTpEMYZN5zlTSXMTVC/XSK5ZApsx9M7B0Fn6V7+g0Cr2LZRe5JMKO6LTpFuj8D82EFoBf/zsX1HOvLfW7xGPNzEICc5Wrywz/yeTHmboXIC2YcLN60QxkP8HfecKS1CW5EY15ye4zRG4Oz2Nwd9h6/lyxm8QP9HzctYAkrs6oZVo/yzc7FAnXWXH3zGMsRDpdjsPOJKvmNb/auaQWTPDf0+ed/LQ6AtFvDs5SDabZtNK7EASZT5NRhr4bKIHORKVaUQP1bWZxs8R1qrIhfJswPFw1hTq0mv+Tcw0FLUCwZo
 rpAFUY9J
 Pr7uVjyJ3dzN9g7el9Yj3HLiQa/mevxtFwXggs27gUAea++nEmKrkq4PBwM+wcdh7QMLK+TQiaootaA+QZ0ZVlw0E1v4kNjhpNSXFtxMboKiC7D7Tfh9x97w9iP7fgrbx32grZXE6Jp7hsvkaVA1BWqx6OSxqKxcy22q5hNtpPpk/n49PHPmMss/9kb+p4WI4tvcGOILQVbJLrmQqqXxcWFXJLCsiUmIKCfSRrhzvUSh03fUGJE2SOwPFvb3+l3n2Wu6d10HmekhhriwEsTPzsbqoq5/SQRqcu++/ZwaImSjfh+1XZ7+bd/zd1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026 18:41:55 +0000 Shivank Garg <shivankg@amd.com> wrote:

> clear_flush_young_ptes_notify()'s last user was removed in
> commit f3c493d2f42b ("mm/rmap: handle device-exclusive entries in
> folio_referenced_one()"), which open-codes clear_flush_young_ptes()
> and mmu_notifier_clear_flush_young() in folio_referenced_one().
> 
> Remove both the CONFIG_MMU_NOTIFIER definition and the
> !CONFIG_MMU_NOTIFIER alias.

Looks good to me.

> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

