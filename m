Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9B41C61DDE
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 09:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 577CD6B008C; Sat, 21 Feb 2026 04:40:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5223D6B0092; Sat, 21 Feb 2026 04:40:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4244C6B0093; Sat, 21 Feb 2026 04:40:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E54A6B008C
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 04:40:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A8D39140452
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:40:10 +0000 (UTC)
X-FDA: 84467967780.14.B30C045
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id C9A83A0005
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 09:40:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lQU3xHAq;
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771666808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=edzhGk8tZ/b1bwNazhyh0vnVmdmocc6fgdNviuUpG8U=;
	b=kNjRyVu1G+ZCMz5/t8SLw7tR6dVO6XzN30l4mCueWeJ9eA9tFBezq48hHiGG3hkZIpaGfn
	hM8j0LJFlwkGn2C+u1/xULTYI62pD/w+Kf26r3PAoiUFuOjJK7iNy4MDDLtPOPdJYdXd8f
	BuWPLH5Tb2O2vv++14NG0KeEpPbooCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771666808; a=rsa-sha256;
	cv=none;
	b=501/s30RtRwAC58Ww4qF8igC0/G3e4+UjRGRzT1+Xjgn1AE9FqwyZs8hYmHo3GJq2k65rY
	29uiIJGSWNQBMerYs5+SK8aZl9gHWX717fTft6FmCrqJS5jw33t7mG05jm0LELPxf0ft3g
	SLXVm8I3A2xW+xvH8VabXir0HYl3D9w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lQU3xHAq;
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-8217f2ad01eso2887694b3a.2
        for <linux-mm@kvack.org>; Sat, 21 Feb 2026 01:40:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771666807; x=1772271607; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=edzhGk8tZ/b1bwNazhyh0vnVmdmocc6fgdNviuUpG8U=;
        b=lQU3xHAqKWedyDdvuPszJ4zzms//n8xXrf5bn6fzSB1xTKLSVZWaig2BcIB57OPQqx
         +JYNmlyOMVFnwV9EVCEgEcKa8G1tPQeHD88NV/0JxwtuDLVhyeWklOLeLOmEDAEshZlX
         UPsByq8V8uaOSLtD45w6s0ZTYHdnDsyJ77AqAvsxZx3IIFa2M3gOwgEMtyZH+SHp88hQ
         Uceuw55AGNO1ARNPwGpX1ubkxUt+cqbNQmgyK/wxRCFJLwJpo0gND9fFH3rqaf2kqpzP
         wQvACf7iZRHSGJJaDu7dX2pmCGQfdfIqurZ2NUfCRxTs6wP3HRsTikPW4cIpxGk9SutJ
         hiyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771666807; x=1772271607;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=edzhGk8tZ/b1bwNazhyh0vnVmdmocc6fgdNviuUpG8U=;
        b=jM1xMNZ59BaoQEXlQ8q1oCWMSUhJIi7gOGCL4mMOjOMo9bqqfPR5RL+AbE6lOfXZub
         GtGo9vhA9ml5P3+90vjO+kaj7c/S1d+Ow419aYFoaomwEHUQTDvYG8f68Y/wUDZkFBa6
         HSN2vdnNG0FDWE9RRoW+UvInbVrii25oDVfIHsrFCULUOn0FKfUvxzCfPjxldHVUJUhi
         YGEAPmewGWq5CcB65dWomnJ5Ip+q4JoNqAM/Pd2S7lQGekkRG+QFw0M41s413w6Rx0md
         0jTQq115h6iuQR+i04XiSn2+bZwsahkubsTU5KcPjZa0Ig4w6ZvS05yzaq21yCO5zNlt
         OlAw==
X-Forwarded-Encrypted: i=1; AJvYcCXCm7P6hw2fokqMBTPsfnypVJGTJC1kCuJmSWn+8i1x0e5/fvVDJmQHGYp/GKRhuhbrOlDBH7b7sA==@kvack.org
X-Gm-Message-State: AOJu0YwEi95F2Lcd9ehAzjdeojd1qLAliD+KzVT+3t4h0DFS2opded+0
	7LY71JIulFGPE1UTb6+xtYOJh4ql0esLhJnnk7rFMImthzBST24F+rtn
X-Gm-Gg: AZuq6aIxHyLlC4aCNSC0TZlE5Gd6dnslyPbL/B0DdtWyf2aNrjK5qfzYJt+ldnNFfnq
	gkQvryGeoqJVVXh9ltmF1g2wRrXXYddxHnN3kWCsAs7JcIvhHnfXSwrbopI4Hwls0Ar32GZT9qE
	gybH0MuvPaxx4Tk/bgl068Nu3Ue030rcpSAM2GLkxQC1Kb6FxwUE+2LYNxkYUMRXgI9kz2t5+fx
	AQ24g+E6TRbKFjY0Yw5cC76kbmjxzZmcBAPWhwCy2niQ5m1fHvzrRLIvxH4FpG1GGq0IYPL1JH3
	gJ2nvPAgFU6onXKoyrgQZa03/k07NyvLONSVtLWyRdwxWkDBFFqsxzq195loYB7Biy4yChVuvS0
	Qpc4EVBlbw2ywIY1DdFJ2pWK5Mjli8r17zdNZvfCsJaoK1nM8b+lfdcq8u3vI+E9yL+gAcXLZOJ
	En51BM2YImvcE0Cp2C+704+dr3M3wZPasgmJ36FT5Ed80H
X-Received: by 2002:a05:6a00:450a:b0:81f:3d13:e07e with SMTP id d2e1a72fcca58-826da9ee90dmr2286218b3a.41.1771666807525;
        Sat, 21 Feb 2026 01:40:07 -0800 (PST)
Received: from localhost.localdomain ([49.79.21.101])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8ba11bsm1761708b3a.50.2026.02.21.01.40.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Feb 2026 01:40:07 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH mm-new v8 4/4] mm: khugepaged: skip lazy-free folios
Date: Sat, 21 Feb 2026 17:39:18 +0800
Message-ID: <20260221093918.1456187-5-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260221093918.1456187-1-vernon2gm@gmail.com>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C9A83A0005
X-Stat-Signature: 7xrejg5adhdkghmy9en45pqog5mfcjqe
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771666808-495411
X-HE-Meta: U2FsdGVkX19QQh5GnW/S1FSelLxto7E6FPgEvxfQCAcb7/qPps/w9DJn5xujTklFRK8iA95qsjwmDXWf2Qa9wMkRUizIwjGXfs4BQqrY3NUj4G4M1uiGBbWIEoWRydYI94Om/khoD5JvwAh+Lj+fjzzFL3oHrVRCeFe7DER73yOndqpIl9DBmoKXp4IS9REY5Zj7lJnlsFVTOa2g4Xi8X3+zEM68MhGNtL2AXjjIG1evK4hp6ojiN99B+vwwdxMSp7ACSb90W7y8W3kBLcCkuEtH5swxp/osg5UzLGhAoP67DLooUybpJ7aJDOvyfchbpdiiSruN0j3XUwUqQ0IY5st52p7oEmja5bv7o7iVAK0+SjzGSdr5v5r1Xb29otdotY43Lis/Sv1g80S6PNpan6vLaFVi2dG7xROqAHl2HaR7m++Rl0spSmzFnjEJ10KH2lIFovtOwdyaWW95WeRIGIpTmke/+S2ffPInAQ/uMU7bbSf+f6XsopdIyZmtIO8Ddh3E5tP8xPZLv7ygyREDGsB0T1Y1l02VyUpLfCcDJVfialpo5Fh1arceV35PiTseTtlcuEADR9CImkqJtdPjCou0OuO3vMxWppTHC0xRHUIYIGkm6ve9vKhcKiEpaq1O6Ti/Fq4VMhWV1NxS6A1H0gDG6Q768tyn9ASTD8pPDsju7F9zfg5+qHUoDicucMoIsyfkYNncdgvEmFCJjA0dSNJPgMR9qMAgd6NwxQoQZ/gjwjAQVUJlkx5o3HF4yvi7wz6qW5xVkDrlKpvzKF0meyvK7bTM/EbiT+a2rkmRngL1hsYPgJ9hk/ClHyy+/tWMijhqdutfNc8+iZSByixMlfZYzd2TAacydUYeaAMtlKpbdH+tfU/ea37RVY18kUQuvi8InHYukGohLkBMiyesK+tGvp9d7StCJJHBO+XC98YbO8CRJAhn1m2Wnl8GyUcA5o89+tbLh/Mr58bp/7C
 PA7QLsEk
 540MY64WqBv07UutoLyYTdte5+EPFzDzRmKsDlFl6x6cli2Ffaqy630UenoqhtZhZMjr1wADbSAYks/mGQfdPwTejaB+ZHhoG0SsfVO/buCnqRm+Q54kq35uKBdRrIiV55wNLzqlHT5dIyud5nM8L7+RDoGz/+qGawfxOH/R5o2uRRkz/1ARibwFdJBPmXwayrAWJL0X8doQVG5mGKV06YgMvyD0ZF5Fxci/CeHyLfWCPvRZ281Qkhef8EuM/8l/M4+rxRZTIA34iIlciydcYTDoPm4whghP7ilfv/Ff64V3M42Jxxbo67kfNsdeuXeFHbTUjpvtS6T2CQvMJ3UTLlJSTM+qKt1bwIWjSOz9R1Nh8l9z49GpVg8V0hsnRCLRdJ+42Q3ynOMBLyLZNuD/ZmvlHV4+QHoMv/zpzSvaO4HIqK8VOtGCJUsI0+nXf0V23HX8AxWVjeKgkFb91RmLlq0u0U9UMC7DqTAHjb6wE06QwZIzLNR5pHZeRLDraCMvtjiM1wZB8Remw14iy9wGkcAtlKShSOdU2IV+k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

For example, create three task: hot1 -> cold -> hot2. After all three
task are created, each allocate memory 128MB. the hot1/hot2 task
continuously access 128 MB memory, while the cold task only accesses
its memory briefly and then call madvise(MADV_FREE). However, khugepaged
still prioritizes scanning the cold task and only scans the hot2 task
after completing the scan of the cold task.

And if all folios in VM_DROPPABLE are lazyfree, Collapsing maintains
that property, so we can just collapse and memory pressure in the future
will free it up. In contrast, collapsing in !VM_DROPPABLE does not
maintain that property, the collapsed folio will not be lazyfree and
memory pressure in the future will not be able to free it up.

So if the user has explicitly informed us via MADV_FREE that this memory
will be freed, and this vma does not have VM_DROPPABLE flags, it is
appropriate for khugepaged to skip it only, thereby avoiding unnecessary
scan and collapse operations to reducing CPU wastage.

Here are the performance test results:
(Throughput bigger is better, other smaller is better)

Testing on x86_64 machine:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
| cycles per access   |  4.96         |  2.21         | -55.44% |
| Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
| dTLB-load-misses    |  284814532    |  69597236     | -75.56% |

Testing on qemu-system-x86_64 -enable-kvm:

| task hot2           | without patch | with patch    |  delta  |
|---------------------|---------------|---------------|---------|
| total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
| cycles per access   |  7.29         |  2.07         | -71.60% |
| Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
| dTLB-load-misses    |  241600871    |  3216108      | -98.67% |

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
---
 include/trace/events/huge_memory.h |  1 +
 mm/khugepaged.c                    | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 384e29f6bef0..bcdc57eea270 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -25,6 +25,7 @@
 	EM( SCAN_PAGE_LRU,		"page_not_in_lru")		\
 	EM( SCAN_PAGE_LOCK,		"page_locked")			\
 	EM( SCAN_PAGE_ANON,		"page_not_anon")		\
+	EM( SCAN_PAGE_LAZYFREE,		"page_lazyfree")		\
 	EM( SCAN_PAGE_COMPOUND,		"page_compound")		\
 	EM( SCAN_ANY_PROCESS,		"no_process_for_page")		\
 	EM( SCAN_VMA_NULL,		"vma_null")			\
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 61e25cf5424b..e792e9074b48 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -46,6 +46,7 @@ enum scan_result {
 	SCAN_PAGE_LRU,
 	SCAN_PAGE_LOCK,
 	SCAN_PAGE_ANON,
+	SCAN_PAGE_LAZYFREE,
 	SCAN_PAGE_COMPOUND,
 	SCAN_ANY_PROCESS,
 	SCAN_VMA_NULL,
@@ -574,6 +575,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		folio = page_folio(page);
 		VM_BUG_ON_FOLIO(!folio_test_anon(folio), folio);
 
+		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
+			result = SCAN_PAGE_LAZYFREE;
+			goto out;
+		}
+
 		/* See hpage_collapse_scan_pmd(). */
 		if (folio_maybe_mapped_shared(folio)) {
 			++shared;
@@ -1326,6 +1333,12 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
 		}
 		folio = page_folio(page);
 
+		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
+			result = SCAN_PAGE_LAZYFREE;
+			goto out_unmap;
+		}
+
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
 			goto out_unmap;
-- 
2.51.0


