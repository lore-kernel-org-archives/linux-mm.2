Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B750F531DD
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 22:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84A196B0093; Mon, 13 Apr 2026 18:40:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC4F6B0095; Mon, 13 Apr 2026 18:40:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EA666B0096; Mon, 13 Apr 2026 18:40:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6232A6B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:40:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2179CE303B
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:40:03 +0000 (UTC)
X-FDA: 84655001886.14.9E0A558
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf25.hostedemail.com (Postfix) with ESMTP id 18374A0012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 22:40:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rZPFHa12;
	spf=pass (imf25.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776120001;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JOZF/bfe2NwOA9iLtUitP+8vPc1R4qGhKhnJ9x8d3U=;
	b=FtV5hWdBRjJdPdO0TFm0Qpwy+RAm0EYRSbQSp2nMILmOsNI/P0bP7QDss0pWB/Mo9qyFQt
	imYdkuLnw/knjDJyvNk3BytL4X9oie2O1D0oB89zdALaTqMvXVs3nYAV3cCzmwAg0Bg/Dn
	1BE0HitKIz8tVQ19bG5TLCUkIcLUlsI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rZPFHa12;
	spf=pass (imf25.hostedemail.com: domain of minchan.kim@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=minchan.kim@gmail.com;
	dmarc=fail reason="SPF not aligned (relaxed), DKIM not aligned (relaxed)" header.from=kernel.org (policy=quarantine)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776120001; a=rsa-sha256;
	cv=none;
	b=DMqyxYILXHTEUw3n0jwdaEXPBWAbBy47nEcyIzIuyavweX5gnG/OuK3Qgk7m21q+L8DcTN
	gzLaX4HBjSMHERBGH9/9QRrDyD4pMP8L1FESh36QiAClqUypbEvuHMvXTI4TrbM606qkfJ
	f6hRFgeJIxRRfm0dyJOA6AVcL0I6GCo=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1279eced0b9so6905210c88.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776120000; x=1776724800; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0JOZF/bfe2NwOA9iLtUitP+8vPc1R4qGhKhnJ9x8d3U=;
        b=rZPFHa12rnXRmseO7wcKODnWffkncLZF36/haP2F38z4U2XG8lC/eyqgbWiTAAEUuw
         LiuaMcGhZfaGpN7ScAkzI68AC4yeR5SG1uFSYtYYTrwXXiHP9imOBBhcw6hqvRPMq7C3
         eB8rOUM6LbNTFxjjBWcGwUySyzG72IAwkrG2mmekuGwJG376+uvocneFVpHmW+DpfxE1
         WHlkjkT7qNAgkmNB6435U4npNlI+w74za53AiE33WTrbe3uubC50aaFccu0+4jMha/hI
         igMlc2lgaFQ7xtLIr/C+ObWp8q/QcQ29BYwABDPUk8h1lYDW2GG3yJ5r2+tS1KAwkKwb
         L/WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776120000; x=1776724800;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0JOZF/bfe2NwOA9iLtUitP+8vPc1R4qGhKhnJ9x8d3U=;
        b=BuXiiIpPp5Ms3fiATB4j7r2afWs5YvHVlfjZn8SOClHqG5rOzCTsfKe+MRBcQVOMSe
         modW3K9Dn3ZIrsWsXhut7x+v877iP4ow1w66B4V23eoLXA5sXNKAJjO1elpd4Xjkz34K
         wfMSvGTQAtCPIYa4z5Chi2LUefiadQY9dT69FUtiWH+tiJtTZ93pxsRluFlgtEdeJA+q
         7oxgsyanwmkRibN/gnsXG/Q89KAYj6RHHvBMNO1feb78QRuD0cbIcOq6rv6Ac9McI58z
         Q/ouaEZI4Xu36aJu7v1LwWn76MK40TTQysnBQXLA+5EaJny4sSEDLofWOtX0R1PXxjI3
         jhyg==
X-Forwarded-Encrypted: i=1; AFNElJ/aWCRXhA/g04voBuVdM7FoJZPak4g9xPGaWdGwcGAi5+Py8OcwEwxkeCLrjSgttIx4ujM67iMnwA==@kvack.org
X-Gm-Message-State: AOJu0Yzte/KvrR/MmWOjp+qJW4BlNDGCUX7dUipnFgAXKZVCH7XTsZLy
	TYswwiatIQuDo41N9mnX/WBmlhSWUYO5/4BMhlF4W8AnlI4JIypH85o5
X-Gm-Gg: AeBDiesA6e9JTT03UmTZ8eMnde3/zL6mf4eNYC5g5juYO4YIkvLDi1n4Qprq8Phd78y
	GBsJmf7Ax1mqRhyrRhJzcroiQXsSi6sg/6pix4XyE7sX4Wwv+9j8p5FAp5/lWnOq5tuKFp57VK5
	Kxi4lzOpys1m6A2DFnB7U3q4OyoncwgmLyAvHVJyRTCEWnlL/NtFn92GuITG1S/A8UAy3TEpukl
	RqYijteiaBSwf/oh6XBuj9C04nJvGyzCMdDfRXlF7g7LFVxWyQQbndwv9/n0Ti/3ac3HPfQTStv
	l9Z/77nhv+0b7XiWyh8QdB4qnXP/ZQciz3VFPfuXhtDDudhENQ56ALjWz29CbQ0l3Yg3kGGGRgV
	NTtyU7f1tCrue7l1Y9KNc27qvtaXurRqeIYfgJmi0RXqgGcn/NiZs5Xo2VXlBpSDWD0abXHq241
	kTcVcRMyDdHJQWqgz6GY611wswbVNT8MJv6F7HAYaJKIZcbdWd1eop/qH8/NlQfcRapYHXeIIYP
	lh8
X-Received: by 2002:a05:7022:ec1:b0:12c:2cf8:2f30 with SMTP id a92af1059eb24-12c34ea8a4fmr7509090c88.15.1776119999734;
        Mon, 13 Apr 2026 15:39:59 -0700 (PDT)
Received: from bbox-1.mtv.corp.google.com ([2a00:79e0:2e7c:8:c871:4088:5cd5:bd1b])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2d561cd3138sm18577297eec.14.2026.04.13.15.39.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 15:39:58 -0700 (PDT)
From: Minchan Kim <minchan@kernel.org>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	mhocko@suse.com,
	brauner@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	timmurray@google.com,
	Minchan Kim <minchan@kernel.org>
Subject: [RFC 2/3] mm: process_mrelease: skip LRU movement for exclusive file folios
Date: Mon, 13 Apr 2026 15:39:47 -0700
Message-ID: <20260413223948.556351-3-minchan@kernel.org>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
In-Reply-To: <20260413223948.556351-1-minchan@kernel.org>
References: <20260413223948.556351-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 18374A0012
X-Stat-Signature: c8coeg1zbq8wprcncq8k6gzkamajifu9
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspam: Yes
X-HE-Tag: 1776120000-862866
X-HE-Meta: U2FsdGVkX18wsV6vZ8MPlyglKzO9r3xD2N0xLL+48wcpgXnz+K6NzDwKTabw+GfonwvfrNpztpfuCDHx182gtdMiXD1e9dA+UeADhAejcwcZkSGu3nUk0MuwNnrOJ/NH5UiTqCUFy5d9gpuE6YP6HnJ2Li7irY3jG0Iebo/TTZQoUz3L+So1qmM6qHUq+UPYILtavwS4rjPiR3dfkrV67NYR6B64CKCMsf0ABhKybT+zs/BZMv3VF4Cqle2y5fDTYTk/FRmCgo7IkBA9/2F1jXWjk+gtKBuOiZFsuzd3viAyGngY7WaUU05LIF803VbmtHv/TOYrsh+8O1rGAqGdIGRIx+zPcOG7hLO5nFWGHMlvACHM+Q439ZfAsiMir6ebfWB3+Up/2kco5+jfKPqOC0Wll8EUj8iE9yIr1DAFveeYoJLkopuMSHNPXaS8ke0HE8/V74Pv7qI/zg2drPhzKKO/CTDhTVju7Gr5cPwNc4T011Jw2HU7QsbhddyZuGl+NABFCqX43QfcN9EnyZxrWvbUfSRwKcT0vYvBF6+Sf8vsaL85NjbURCv7ciPpnfmPU1NkugD4bkERDu01KF5WohqXi+sM1PyH+4P8WGr2LqEL5qiU+KMLSRbHUdJFcArLT7wBnfIt0jYhXgkKWDekP+QBvjh9wUPZSJ6B5IJWXDvzWGZ92IzYeUPMeJvKdOcy1Y1Bj7o1sXD4U3HjMJTVSRdxW1u3SZum/iQUH2wPcn9mEcylJGM67CP+HS09cYkyYdqDFBYfjcwKHxQ6NEGTD84UpAktWBh5NLghpvtixjD0CiRE8G+Eq5YjhnkNiunEknrFmeRHPbx5udE2VVkQJt/vyf+yHZNM691luvgs2ks/VPt+etnppcnFwVELB/P6LX7PY8yX6iIfnpVef2l6fzVZyFgWsqnTIbeaqiDUYXSp00L+MD8G/D2hV7Mcuy7CJsLEU/Gr79MNcHgGN+8
 XbgkaMu6
 VEj8aUHzvCoyn1ox7yuDR8vTym5sSoKoGCTf2j40/krpSzC0Wof0LdB6oO78zpRLLhOginKPm05JManOIpslKFkOqz68YhUOO6NACGz+zUpXEF02CvY/voxq7zvtjcpKVUh1gBS/YuNvShPtFwqLQjvcrRSkYIEHbfBy2mnb8B9655loEoxpPCqemfXmZmO94b02AGbV3OCjIFoOrVrWlO7nbqBaNiltXwuc+uAVm5gBfsXBvyAWP9c6Fv4Qz22LeaoMcHwLkOkV9/EfXIlA13IA43/fTJb/zC3btxBNGhWqLw49hzXLKVrfC2xQ9aMwy/FCzVe9ugBIW74BxmJT7q6BQydW4nFuHuWTHcOfQfg0ka13LRKO02dNtm0uq+rnXBrB69Woaj73OEu85fmsfGHUBWnx0lYzO7TjwS96KzwbzgmCCzE45fCCMEzaXSGEzw2VQTbKUsp5aSiKOR1zn6DpOzn0kqJMpgnTwQnDW7ku5wju01bMsykNh+Pgj0RogcN6Xd5JiJrgoJSTGH/gi1rm3Ik41Ib4KjtVVKfke/V0X19WAk3Ba/usQcEE6w+HgMlnjjYjJBHxcc1z0y0eBhkt84TBmE1Yvg6UwZGP+38i5FIT2ELPW8updUFO0c95UbOp0/Sqj81maaLqj4jPYUyfKJhZnhFOH2U5oiaYNgIo+7yDzoe5FeVeDAlpBC0LsYy7KeSqLJeZmtz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For the process_mrelease reclaim, skip LRU handling for exclusive
file-backed folios since they will be freed soon so pointless
to move around in the LRU.

This avoids costly LRU movement which accounts for a significant portion
of the time during unmap_page_range.

-   91.31%     0.00%  mmap_exit_test   [kernel.kallsyms]  [.] exit_mm
     exit_mm
     __mmput
     exit_mmap
     unmap_vmas
   - unmap_page_range
      - 55.75% folio_mark_accessed
         + 48.79% __folio_batch_add_and_move
           4.23% workingset_activation
      + 12.94% folio_remove_rmap_ptes
      + 9.86% page_table_check_clear
      + 3.34% tlb_flush_mmu
        1.06% __page_table_check_pte_clear

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/memory.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index 2f815a34d924..25e17893c919 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1640,6 +1640,8 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
 	bool delay_rmap = false;
 
 	if (!folio_test_anon(folio)) {
+		bool skip_mark_accessed;
+
 		ptent = get_and_clear_full_ptes(mm, addr, pte, nr, tlb->fullmm);
 		if (pte_dirty(ptent)) {
 			folio_mark_dirty(folio);
@@ -1648,7 +1650,16 @@ static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
 				*force_flush = true;
 			}
 		}
-		if (pte_young(ptent) && likely(vma_has_recency(vma)))
+
+		/*
+		 * For the process_mrelease reclaim, skip LRU handling for exclusive
+		 * file-backed folios since they will be freed soon so pointless
+		 * to move around in the LRU.
+		 */
+		skip_mark_accessed = mm_flags_test(MMF_UNSTABLE, mm) &&
+				     folio_mapcount(folio) < 2;
+		if (likely(!skip_mark_accessed) && pte_young(ptent) &&
+		    likely(vma_has_recency(vma)))
 			folio_mark_accessed(folio);
 		rss[mm_counter(folio)] -= nr;
 	} else {
-- 
2.54.0.rc0.605.g598a273b03-goog


