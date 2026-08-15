Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8E49C5CFDB
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 01:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41AF26B074D; Fri, 14 Aug 2026 21:59:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F2406B074F; Fri, 14 Aug 2026 21:59:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308726B0750; Fri, 14 Aug 2026 21:59:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDB1D6B074D
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 21:59:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 68401A0270
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:17 +0000 (UTC)
X-FDA: 85101846354.21.144A9B5
Received: from fout-a6-smtp.messagingengine.com (fout-a6-smtp.messagingengine.com [103.168.172.149])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8842C40004
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 01:59:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="q gG71gW";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=C6EwAi+P;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786759155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OagyuSQwqQVmdL1ycZwWlmABBXtstTQziQig8mkv9yQ=;
	b=DSLMRQFjm8/al4JgorYOHkwd5btA3Eg9abciEjQxY0pBO5rhH3Kt4VSTC2j4z+YycPnzUz
	/Zyi5GDz/hibqv9m2bYes0NCI17a41VmJsTeeDU/7XZTbiuF8KSVWG2KbJ/ebc9HelYS1p
	rIfnLF+iOaKiYVghQWP1aOJsRhGOHFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786759155;
	b=PII6r08Fv03ivXAgtKlHCT6u4JMgAn4YLEmUgQPaDU+2iMxUbNL7+/FeIo1TcwWlCNjoR3
	nnkOFt198k6uGES2HWnm+gS8n1NwWRVeVF/el3fT6FF17Z7YHZBJDZgloTrujCvFAjAXlt
	U5Vi7DcbAinDxKewa7Wq3PG5FCJ0rrQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="q gG71gW";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=C6EwAi+P;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.149 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.phl.internal (Postfix) with ESMTP id 21AA3EC0225;
	Fri, 14 Aug 2026 21:59:15 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Fri, 14 Aug 2026 21:59:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1786759155; x=
	1786845555; bh=OagyuSQwqQVmdL1ycZwWlmABBXtstTQziQig8mkv9yQ=; b=q
	gG71gWCMufKBaweTLjyrV/2B+GqdIdc9XNhNl4EDaq8wdvzOjlZp+CCWTQYYN2SG
	ZuJK9NJvsnOUXPMWgTxGaUPM4MOdNigu9za7ZuHNG9irZxc7v8MJjpH3i3ZfHwO/
	H/IKMpuzhDLUmUcbg++btiig/qJGvAC+WqtxsY5hloQJb7jZjAdPHIotB9KBQ805
	uWcasdNt2iGu7ZIxzdGYPwNmgVbruDFB0CKmbtJMRSkgp1fITixmjIzqf2+jGm40
	LFmwvS91qgptyogFF6qf7a/OQR0eQw1rBve0Kkhhx2zpJRim/JZr3Yyo8SQ5giMc
	KfGiEgJX5gqiBj5w9VWnQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1786759155; x=1786845555; bh=O
	agyuSQwqQVmdL1ycZwWlmABBXtstTQziQig8mkv9yQ=; b=C6EwAi+PHIyxBEzN/
	AswsushfQm78lDT+1wG9nTDM++fwGfXMe1BmmgZJ8C3yfoJalZ+SWEKv13LeGj8+
	wQf5ktoxc4eoovmIvYHts0O95I11ARSu4C/X706yBhk722QunGFrkAtRIVttgBF1
	8rrLOvPiDi4B2SsyXCz8nU2ioJW0PdUq9YTHKyVybxXTivzMZupyDKOIM5VUiqVo
	seZggNcKAylcqGviHCZoLsBQytcwIaX70S+Nyrl3RrUte0rQAirsrderXB6BQN7j
	ZtdWDaDAf9qWBJsUfVIC8pZsB9unYY0vmfLqyqnckzIELIreHf4KFDd2B/GQZCu6
	iaI2A==
X-ME-Sender: <xms:88d_aibwQXtuBSVL_bt5_bB3rUeKbiGJIhCX4Ny43et2sjzn_dpTjQ>
    <xme:88d_apWrB96vI3SqOI4GNl_4Fyhmtq6UC8ms1xANicOm9X9RvTHAHgKlrp6g-Z1Nd
    7DwehQHqn5lR8Q4kd0imQXVSR8cExY10twNdTBIxj7OdQrhkdmoZxs>
X-ME-Received: <xmr:88d_alcshRnnOs_Oe_2tBtYjvNr_UjWjP49HpN6QkNOC6d0Ub8JHI2M73hU>
X-ME-Proxy-Cause: dmFkZTGF7teVIHNqoa5p2A8iL+trOmU4pExV0BsGEGBxavUqSy3vvyW/t2uVaC82ybAhbC
    FZe2jS418ApiE9B8lCjDVAvs2O/1hVxxIyd2QmVeomYKnxIQlXrdOkpVI2/A6aay1R5wM6
    752pE1oD84VvsYvCM8wHufwfHzQzVg5WF64m0thPV1o6CCL0N8QD0816LOjK9LaF9KdRdp
    ShDgDyNTb/bU59JqJj/g3oSWXYBnQXQHEYh7kafl/PHtgQjoSit3F73LPXI/q1yj04b//y
    CUybFuAxuhlNqjceRELXNaCNxBn+qS4c4JK+cmo8T/HSoyzm/Kml9mcKob58Fnvz9v9LJG
    902yBfSqobVpU5cPlkQIChl1GO+Rmll+tN/Ll/HfeQFiznCNQFe9p3Bw2O/4k1VVLkgnp/
    fCNJ9XNlNHoWrBoslggvY1/O0wVbkEVo72nb108ebE4dHY77E43Q/D93CzrVpJI8lpUeSv
    S7ewJu+RGF/Xk9Qmbq2DrWS1sPrmAz00HaDwyBDmVKiPA7VPtKH+xk7t6VDMzkQ5JWyuWd
    mUDndNMaYibXgmLXP9wwtQwVc/wLMzkZevCOD+5Nv+emmXcwO5XmKGH1VXQVx3J9ELqhZn
    53V+Fj/FwHyfPLhOipV4y47OWc7xGS+LvBp0c/5eGKo3LUBE7uLpEboq9Lgg
X-ME-Proxy: <xmx:88d_auMbmkfjlyowRipg_Wn3PgWaqg4o2Aitxeru3qfXF6lRgCj9Sg>
    <xmx:88d_alIkuE8XLEGbi53b-kN88JOf8e2AYgPsn8Ei5twH4pTl2ba-1A>
    <xmx:88d_ask06vh2jf0JOKOfj7enZTeoPwM4E3cxbdDtXqFqghwPq5SAmw>
    <xmx:88d_asY1Yq511zwTv80m-jkRmaDae_DEDBaX2nqD8Mgv669LoaU5vg>
    <xmx:88d_at6mpYM-PInK81kxNveNYH27YPB6CTm4kImUTyPrbp7IKvc0N3-N>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 14 Aug 2026 21:59:14 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	nico.pache@linux.dev
Cc: baolin.wang@linux.alibaba.com,
	baohua@kernel.org,
	dev.jain@arm.com,
	hughd@google.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	mhocko@suse.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	usama.anjum@arm.com,
	agordeev@linux.ibm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kas@kernel.org
Subject: [PATCH v4 04/19] selftests/mm: skip khugepaged page cache cases without a PMD folio
Date: Sat, 15 Aug 2026 02:58:46 +0100
Message-ID: <20260815015901.1236937-5-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260815015901.1236937-1-kirill@shutemov.name>
References: <20260815015901.1236937-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: n7d13p4ifzcmfnmbinwppn5bbih6oyn7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8842C40004
X-HE-Tag: 1786759155-37810
X-HE-Meta: U2FsdGVkX1/fPUjqs7JG2/Ycz+b0G8ybvvOy9Xhnw4OkRLok0CXhxYhQfaa9P9jD0SQGC47wBzYh3nt5KBfKRw6hxxmq1eUgEmWrZiBIwCERgnEZguY6BiDRK6aZf6A5+8J9L2y9i6GE+XzIs8xt2AJ+sm2FY36lv492b4fPCPfdboO0FDEaRekohvqq0sUzd7PZJvaQQp0nxfCx3nmmOewyJ2iYm+P56g1EBDfJUjkZU3DhP2+XBQIcE2I7Bbj0PpGWZ8+J6ipgnpRfMpA5w+/zW8sRhsF9RISRt4EkVUdnl6aypcIv1Mg/Vs6uE9SBEjSVe6aSH8rcXoDEI5TJ4pA4PUq2mtA/iNohl/SMWcG5K5eLtZ6/jRJHxiKfAiQXaWOyouwrELodGjaGVNlWG4PnF2NpWopfkcZOhLZJPGVunExBnDHjG12pSrLapVKeRUeabYsn7JUBlzI4+8RRXF2UJEWovOfX/GbFEbhb+QcMuR3eSJppaRAXtR/tGA+Yrt8WFxJey9r3un1Uc6ibLfDfcHhImlb6uUcR9872HeAIz5cGlyaJB2marGyXb9ca60DtM0W2aebTEIbNr2IMVPdDcjHSWn5b6qhoWFwQkS0MsOBCuwHTGXwfaUBvgfB3J+OFicGBJRXCcemIbZsfuY7XA+oIsuNIT1ApZYSi7zfki/wcrRLr6njREeRqvV0yShg8AHkf62DbdA5y5lbEYZDFdzHdurxhfLqSq1Op+clPlfqkOPuBrB4Z4IXELsSjjBlyOy38z8nz9jrf7NnzeqXpgj/suF9YduhumtOCfcm7/bRioY2Y1u4UGR0oTsGqNg0pALv/F85WGpuk3pvQCXA4NoxeAblUwULHaxDdBLcBci/mhtc2oy8ZzaqlWJSSZ1+vNfuUsAZMLZX+Tu1gN4e4d0AZLoH6F6nlXm4/ucbBdea5wAoVELf9rIyF0i5im+9X14qoEIm8f8nw4a0
 A7lb1XVk
 Kb3xgjhZs/m2sRJWpNjyOoNOoOi6upD+MmNMmLpgAkfx/42j7LNYZZ/cdCeWW1blBB0Xgxr5gCfG2/WOZiou9eectqGs8ITFSxS5b8YpONjkV9xQ4WffBGa4sreGDYaNs26msD4ZlsWp7JHk77VVgTzfHjv6nsEZ3bnCKpqx3tBL7GFf18L8I8Z+40Eo/EfbwrxU44rwStWUXz39JFUuPaVWNG4ezsAgXAL7/cdY3sHsehAjWCqTu5wbYofPr+BWVQ46kLXFjiqNugbMs5mW64KwJ6BeJqZ0HPt0eGH4z/kpRY3+PoHDNh1wd9cck5x34Ep07MVOiptmEuEjAJq3xfpIHbKhv8qnExAbH422+habwOXRtIfROAxLlSZ2HIVURpOKM4Quv5pBJ3J6slIXkS/WLA6Fqzir5ilGUdIt5WQpYzn/LUNuVMmsCOixqv6uwLYZ8CS4yTJLzyvT8BC58T0s1d2gHdWiDVHkDlThRnmN5bHFz8l6vv/nk9xM8+xr8kuHU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The page cache caps folio order at MAX_PAGECACHE_ORDER, which is smaller
than the PMD order on arm64 with 64K pages, where a PMD is 512M.  A
PMD-sized page cache folio is impossible there, so MADV_COLLAPSE answers
-EINVAL and khugepaged passes over the range.  The shmem cases ask for a
PMD-sized folio anyway, so four of them fail and the run bails out in the
middle.

MAX_PAGECACHE_ORDER is not shmem-specific: it caps every file folio.  Skip
both mem types where the cap is below the PMD order.

Anonymous collapse is unaffected: its orders are not capped this way.

Assisted-by: Claude-Code:claude-opus-5
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 tools/testing/selftests/mm/khugepaged.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/selftests/mm/khugepaged.c b/tools/testing/selftests/mm/khugepaged.c
index c499804a0ec4..ec5c36a19d92 100644
--- a/tools/testing/selftests/mm/khugepaged.c
+++ b/tools/testing/selftests/mm/khugepaged.c
@@ -1357,6 +1357,30 @@ int main(int argc, char **argv)
 
 	setbuf(stdout, NULL);
 
+	/*
+	 * The page cache caps folio order at MAX_PAGECACHE_ORDER, which is
+	 * below the PMD order on arm64 with 64K pages.  A PMD-sized page cache
+	 * folio is impossible there, so the kernel refuses these collapses by
+	 * design and there is nothing to test.  The cap is not shmem-specific:
+	 * it rules out regular files too, and the per-order shmem_enabled
+	 * controls exist for exactly the orders it allows, which is what makes
+	 * them readable here.
+	 */
+	if (!(thp_shmem_supported_orders() & (1UL << hpage_pmd_order))) {
+		if (shmem_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping shmem\n");
+			shmem_ops = NULL;
+		}
+		if (read_only_file_ops) {
+			ksft_print_msg("no PMD-order page cache folio: skipping file\n");
+			read_only_file_ops = NULL;
+			read_write_file_read_ops = NULL;
+			read_write_file_write_ops = NULL;
+		}
+		if (!anon_ops && !shmem_ops && !read_only_file_ops)
+			ksft_exit_skip("Nothing left to collapse into\n");
+	}
+
 	default_settings.khugepaged.max_ptes_none = hpage_pmd_nr - 1;
 	default_settings.khugepaged.max_ptes_swap = hpage_pmd_nr / 8;
 	default_settings.khugepaged.max_ptes_shared = hpage_pmd_nr / 2;
-- 
2.54.0


