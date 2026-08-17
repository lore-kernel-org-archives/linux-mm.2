Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7396AC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 04:38:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F32B6B0396; Mon, 17 Aug 2026 00:38:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA506B039C; Mon, 17 Aug 2026 00:38:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 209976B03A2; Mon, 17 Aug 2026 00:38:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D8E076B0396
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:38:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2BBA5120665
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:38:13 +0000 (UTC)
X-FDA: 85109504466.16.23B5950
Received: from mta0.migadu.com (out-34.mta0.migadu.com [91.218.175.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id AC945180002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:38:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eL7fRrJE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786941491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xOHwnTiFuri86GASwSq3CIVJEuwTbQrjluV8yec3aok=;
	b=iRnz9DuFdQu1OlCRNul8po4jCw+mOoSIC4K9GtHooUjiCPKkc/n4mTVgYBNFbByICW8Dt1
	SEwFBp51oqCqgEBXRldInnINzs6YU0ZZCEBpsJmINUgINUvCmJfI9/+NhkGlMwNN4NcQby
	Kg7tjnmQmhPdpL87kNRpy37CrawSHaY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eL7fRrJE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.34 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786941491;
	b=XAM9f9QPCjXNd0Nciwhtu2GoE8d8/y4ZGh8jIArT1C2ZQdp7/c/fFjw9/p4jDc5BNnZ0f/
	yrEVnxLSr4eaCT0oiqZMNIo2kMDnL0N3q4J98OshJaqwdEuyWk/7YVurT966SnY6AR/tuV
	wkikZ/jhmspBXRtqclLZA23GzhEv+WU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xOHwnTiFuri86GASwSq3CIVJEuwTbQrjluV8yec3aok=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786941488; v=1; x=1787546288;
 b=eL7fRrJEP3i6jrJK7PT93R6ipKtbLe/Va3a1ka/bUSODwG6ZxMD4BjevXckAa+YL4gBx7sPd
 kX/DTw6oYBoGkSz+4zFIOqPbUn17TwOTW0k4g8PGS4dTEiOnOlR4e4biNJ+ykC+cDA0nsyZEZ48
 /zzm55pyTFK5TwIl1yrcFtZE=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 47ac407481a84769;
	Mon, 17 Aug 2026 04:38:07 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: nico.pache@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v4 4/7] mm/khugepaged: fix outdated comments
Date: Mon, 17 Aug 2026 12:37:55 +0800
Message-Id: <20260817043755.84350-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: tuzhpdca3ajtkafcn6sk5b948xt5duay
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC945180002
X-HE-Tag: 1786941489-209961
X-HE-Meta: U2FsdGVkX1+h0D7jWlRVP94TNJGf3K6luYEuZkVzbVomEA6OAngBhyg82KFdgX9vfUSNEkTK6nbtRubG2nuyuJ5yGWECBMAn4QewxcJ/pGPPcG5x4x29nBbA+bMcTZzAf8kjqjMJF92IpkDvxsOlYOEz3qrpbpxnCCPHjf/SZmaqx4Kfq1RTff3QGpqaCkl5xy5UZJ0MYkFEo7pnupm2Ei1oYgDYQXceUxjssRsW9KruJpzVonK54DTHEYYkKtStHGAzfD64k/PfRbk9LiChvKqmbmy/xD/+Aw9O+nswh9G/cw/PmZwMrSOOrSxYwp2y8hVK9jUtt0iS57vzXAcmegdhxTYIbk8DOEp9WZTyavbfOmtl18XEYozrwiXKPa2MtkW1lRa+x/m1xr5CPVP7F1wCWbW/YBRtzCCabjKhS1H4Rd/edPDe5rF9XKEeDoEeRr/nfTJyrCuUcZj7tWXLfVqoEezTGD9ztDhKrxO1XT7nrD/aMD/qaCm9nkku1hBauyljZUWt8CJbNz5t6rPCF413JvUebQUXYM9/5dKgfoEtn6KCSrExfItHvVNEbatvimvetdpd7mFTqZDd+Adj9c1/9MIx/FBw10vc/UidQkuxltUpyx/VpXRUKIXfo0h22xdgqzRxfcPbS5EZl5BEQcJRKnUWk3rFxjBhfrURUnBQ581NVLeJ9Eosq+J9zcL/VH07lvT6Ep50UPBJAPJu9hKuzAomUO2RGdFLoif6PKX831xZL8mGluQReOR78+3jkkLELp1kM6yv00mzXBSLhjeJXZcnMmJNijsTd6dVZ3xKoJekapRE7/ljfE8B5vdsLYVa4rRn6BMMBfjsckP1qoPYxp3A7sfpXDG7fiJRU6loX8kZPb/9K1zmBzSaqJHu5M3ssxVSHgm1CMUSvj5+9uNP4Pm6l5t+OdHC5W+GfX2nZFr4JfCEQSh37bd3mtjVOK/Y1IRM/zLNtTPSXWB
 3LdF/qqf
 WAVbtEtQ1ErS/Zi8pSnqUpxKOG8M5LK7ozMPhcLQCXoOIbnep4AiHYevx3gbjm8ZI+Jwl+SrTOWagSKsSDP/SJVMGnFIG4erCG86x07GI8MbyglAIG6VRE0xX8LKFo5CImXSzAPHB5n0YPc6W5ftoxP8PIytaOeR8CDfYuYX5SpbQPIsax6OvA4n9JogiBVaJIChuw0BQkngoCoiGXFR7wj7m91Tc0DfuatbtvgOdnDI+xp0yAIs91KaY5jA+6ZnYTfzsi4hQtjh197ZDBCzNEI5T4kaYX0j9C2RLvQ9bT9sCUZ+iLYLIeFEUaoqNVgveui6chFBB9uoe1RDHcBVUS+kjOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Aug 11, 2026 at 06:48:36AM -0600, Nico Pache (Red Hat) wrote:
>Fix comment in collapse_scan_pmd() that still described the old
>folio_mapcount() > folio_ref_count() check and a "512" false-positive
>scenario. The code now uses folio_expected_ref_count() != folio_ref_count()
>which doesn't suffer from the same limitation.
>
>Fix comment in collapse_huge_page() that referenced ptep_clear_flush,
>when the code actually uses pmdp_collapse_flush.
>
>Fix comment in __collapse_huge_page_swapin() that referenced the old
>function name khugepaged_scan_pmd, now collapse_scan_pmd.
>
>Also clean up some simple typos and stale terminology (mmap_sem ->
>mmap_lock, PG_lock -> folio lock, page -> folio, grammar).
>
>We also clarify a comment regarding where the max_ptes_none check is
>deferred to in mthp_collapse() from the original collapse_scan_pmd check.
>
>Update all comments that references a function to include parentheses.
>
>Acked-by: Usama Arif <usama.arif@linux.dev>
>Assisted-by: Cursor(claude-sonnet-4):4.6
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

