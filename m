Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B647CCF2C9
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 18:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB3DF6B0088; Sat, 17 Oct 2026 14:36:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64436B008A; Sat, 17 Oct 2026 14:36:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B52376B008C; Sat, 17 Oct 2026 14:36:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82E056B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:36:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8D8C8A77D6
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:36:01 +0000 (UTC)
X-FDA: 85332972522.07.BCB2E34
Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id B1BD840005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 18:35:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bONUxzS7;
	spf=pass (imf01.hostedemail.com: domain of lin2530632123@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=lin2530632123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792262159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=RVIzN3gzq1iKVVWIldcTF0wt/W/JaOZtrUNnsg54zaM=;
	b=A3NJNA1akwug6dKE1XYBLc030EH9QV7sol5MYLMxpuAMVLygyQNi/Y8hdGNyyas4lxRAUS
	NbxXdpFJ8JI7Zryr4Vuawst9GlAeryDtORrXG2XTID6sA5EhfCFSXepPbv9W0AuVPXCfaU
	Q7H9BEsdU1GP4ViCrlFQTgMnbOCP2Rg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792262159;
	b=zFvKmraX+ahfqVkOAyq32M6GhIXpVh/H/fZtfTJ7I6IPRC2ioR+ixBkVr349z2ZJNgRerM
	FwI53KCfKPNcRpEdyfgGzqLKuuXlWyXmcDTw30EflErMUIgGSJvE2q6BnIckYm1+qt1Xlc
	zvo4B3AAGcKMgqJyjN4hbhdfc/r9Ai4=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bONUxzS7;
	spf=pass (imf01.hostedemail.com: domain of lin2530632123@gmail.com designates 209.85.167.46 as permitted sender) smtp.mailfrom=lin2530632123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-5bc18f54abbso754392e87.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 11:35:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792262158; cv=none;
        d=google.com; s=arc-20260327;
        b=lIvivFlxIu5lxERGG4dfNuM4B72hxAWt2DXcCgBspH49YlAoNPkosnC+yv9nhAj6tt
         HnDSfWMH6u2xDYN+4VkoYl40aLgP22Css4lPdPb+YKwyTIYr2gVs+Vaqf+QGo04mfLsH
         dm9Uz2wBW7zHyT7AKs7mfkEhboHV7gZ7i6r8o2QB9P2hLUwRnWa21tQm18whiwBWjnnV
         TjiWcuUSmcczbnS9Xql1MKTff02+oo6hDcx4WP5xcivqjd67bGTup2qGWzzVnj15w3j8
         werirKZrUVYKfYD/2WzojJlgqv4MlbcaQ87/IPv0x7EBO/hFKglVtFKLqO2DwHY57Sq6
         oRmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=RVIzN3gzq1iKVVWIldcTF0wt/W/JaOZtrUNnsg54zaM=;
        fh=Ex/ReJOlxX7rj4jTokdL+dA1WWiK9994vumBt0ohkpU=;
        b=p2ds6G/Gp8Qg1j6Zf79m/ZDsHFqS2QPB3MEcetvVvHyPj6PPPZCmvI4tCX4PHsqBLV
         0Nl+Fhjjd0LSaO51mZPdBeXr6t219lKTZjHhZBWy20LhZanCmug8+xJVZi0EIJuVwaW5
         V7xWS4LdO6TjeSiPjWIYKtdZq3TMo+x488RMzZIsblDM8ZhPuUmhmMCAGa1gx3PhwnOh
         XTDFUXlH9aRaXh7mw093F4LJ48AUIVkm9pMtvf0kh4KvRR9oGFmfliOfE/O8a/xMav5Y
         6Ffyj+EaFahgVn8pMi4U3gH2K4hiBzZZY3uXQozFN5Q18OBhSnTwYPAOvbxfXadVwsMM
         b/PQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792262158; x=1792866958; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RVIzN3gzq1iKVVWIldcTF0wt/W/JaOZtrUNnsg54zaM=;
        b=bONUxzS7HwL8PiyEt/c/g0k2+D//3wlr4k6y8u6zP7xjCRUsye4+mEvXptQFFKdwOG
         uikl67wmnpfNE+LaFEGQVykOuDbnwKe0NqlxmYq/bNx/mkpp/FQO4CZon/uUi96w8riR
         mLsQSin4FhmoDAS+OgZJnsMEzbIX1/4c8NdXR8WHTT7L+069ElRdKgiRO4jaJYVF/zkq
         AzRR8tAVWtEQfGygFckKNAvEPtWyLUNRmPIRwOVG7biXhx7CeZoGFu5Lns5f6O+xL4k8
         dUeWgLOqgXVmz+ezmsugD9l6zCK1zom2EAtlsxN6ZHY6cFYHT4Koac1QUyipdXsY8AO/
         YqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792262158; x=1792866958;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=RVIzN3gzq1iKVVWIldcTF0wt/W/JaOZtrUNnsg54zaM=;
        b=KrEgot+0M9hhKAmwnb1loKFpfLzw3wHqspCv7415K73Z1Krha6zWyHNkY+Bq9ctC2n
         cVYM40L0ekLDIsx/6NZHRkWpva0FQj4Lhe+Zye1IcHPgSrCboVv7EQ/6ZmDblSlCIaOH
         nN8B3iC4tBbPx8IUiBXJsR+2c+lNjHdyBw0/f9ib0KCMu8oBOMGqiQ957up1mn46xm3M
         QlTgo4+MeA/zq2czacOx7/x8t+Pduzz3sZ/FFiiVU0L0AK3Fl5OPnipR/do7fb6+3Nxp
         BpCBYXUSZdV8PD/NwNHuL0sp1oayHNtdPIMMGm0g8Vi1ZF9snRuThg/j9+NeNIj0iQ7b
         5NGQ==
X-Gm-Message-State: AFq9FYIpmxmwnFTmoCG9uxXZG8vyts0jqVXHB1vjJ6U+i8O9yYVs0Vhn
	h0kS6A4VLIihkBxyPdj+7X4g+P9VFi9yVtabe9DcIccZyMtNtnUHqtyMG/V5PyOGNt7Hbj19IuD
	BI/sTBfiwvEeo3PBqwMzrq5/RbEZtk+M=
X-Gm-Gg: AYBFou3+CsnZDo9jsGD/emjIlVNefOuCcPLgngnLXdFNhnbXaGVWgOmDNOPBDsZdvMH
	gkJbIBim03rEt7SkIpOxIQ15RZoQzibGBw18Xkr0wPMUKGW3D04ZrhDWJJZS4IB70JZ28q54shC
	NTOyEa2+Soq+FnVmj5cNPOLU/RIHi0gFVMIqO7uM54idcj1vsbByaAId/A4VObtT0clLwsKG0xt
	uJNjyjy5JkhS1N8r9SswUq7VvrzZbM1AUcKQlRjaaGXSJD1rcapbkFkzdhdX6tRCgnj819TLYEm
	8QVAr6mTzTTTBgq9Ac3SnV2zm4lbPrztVOx8RewY3JS/lHrpsJDizBUHroecQl/GnOYxVbFnSdN
	ZJZ2PMgyme9csJ3+iIUtXnDVk+m7LbWTXSza7nMU7vpGl
X-Received: by 2002:a05:6512:6695:10b0:5be:50d6:af8a with SMTP id
 2adb3069b0e04-5be50d6afe8mr559580e87.33.1792262157318; Sat, 17 Oct 2026
 11:35:57 -0700 (PDT)
MIME-Version: 1.0
From: Chengfeng Lin <lin2530632123@gmail.com>
Date: Sun, 18 Oct 2026 02:35:41 +0800
X-Gm-Features: AclHuK8H4e_QW3NzvEv47UxOfSdmIBFc3r2lyfwYJQ76vaS9azCvwQwFnLe8c5U
Message-ID: <CANGjgdkFAK_EF-z64cyJttAOS2gqcJuM9jOAXAXOeio6h3wg=g@mail.gmail.com>
Subject: [RFC PATCH] mm: preserve physical order in swap fallback splitting
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Barry Song <baohua@kernel.org>
Content-Type: multipart/mixed; boundary="0000000000003b5f0d065e0d8d27"
X-Rspam-User: 
X-Rspamd-Queue-Id: B1BD840005
X-Stat-Signature: zk3sut4pf6wyar1coocmonit9kks7e34
X-Rspamd-Server: rspam05
X-HE-Tag: 1792262159-144190
X-HE-Meta: U2FsdGVkX18zp3wEZQOfDUUjvgqxTJXecBJMKqLUQREPqsJqfBbTu3ZArQ2qU7m0dAP2aPJCdEiFCT/mda87VZtrnMAgQquVF+CfqBnfVrOuSH9VaXS7ntZmSj/1WocBAdXSqeGJrGKzsUmZ93rJR1PehjZZB85GopErCtOw/WHtLiiU1qqU8Jf0DwY4Zx8KaIZX5z0oylumCV/y+Ew9KQjBc7ejVWsSymeFDtG1cqQnmxYm1CdFmSLn+WxxUTAJZ1Ys1igcBkGT90/bvFS1QYEt1j5Q6CgpoLK/GVxtiBOr4j4WWHdt5Ao1qFt453StKjHKnUJwJ2LeQb03BOeVbxHu6cNi1dI/A7yYMM2WBr3AUiaXZiHk8kM8ti/XSWpQR5YhonifmNJqlMlaNKi92Nq4FD3PTSr2aXC+RNBIkE3fyuezfh/mJURPUoNWDULB1ONBs90dCtNn25q0pqf1B+pxgXdtQbfSxqeT5wUrXlM432XWT5dAvcJCXqiyjgbzgYSC33W56+kYJku4NwI/HFW9r3qEdCHXD4R9w3Qzc0cY34hyguv0xp/ou3DJCCyfZxyOeKNB6FEn4BgAZYiTNf758FBMX5awjrJnblgqki+aBCccncI5UgnLFe6+qqGYPTxToztXWvbMFzrHczDtCaC18vCaR7R3Edy0dZifqh/vu4g9ryo3wPidr/JkACEQHJa96us6+AjDyqlAnRPPCo7fQny9TgfReiXDYh4ajBehhSx8izC40LexPbXr++2SNUZCh/uVt+UqDY9/FF8TMFIWHcKlZYq9ZXHSoS22GEaf0HnCbE8XdZxNWNQ2n6wW35BBAiV+Rkh9xBLTzzRLRmU/YJRtDRJYC2BXNH2l7tv63T05e7PgMwTW5wx5pLavVRcagXrRG2p1hh9epFHaLTwSe8d3wQr4dhN2yIiZrTrCF6yeLXrYjlc+uW9dwtvmt514gMs0IWCykJzJpXW
 rDVNPM/I
 2leiO+9AbznlYT4zWjSFPPzhQ6iGR8c9wxKxiSA2zFHmau90/ZHuPeLaNb50QYorLJptp1jFFCw2gIGpfXrcu9IPaVxAX8MwG8Qe5R+lGVVF9vNKQyRHkGzMj+S6C3hVeoi+N66CoAnQiy/ck+eiHIskQRMmBKufNbWytwc6LG1UCosnDu+T45ypQtkSn4R89RQpcYIDSPJrbrjmjn9n+2bKcQDQmzZb0H431/H2apVzBu79+lxUwUxYJMu+bF36tOb5hCmSnPgQukSRHhyPiO7xOS92/RZ8SbU4gnRnyOuHRXNd7ws6AwvyeVpDEOuzG4tVCazGO4QlS8oT2dKaBHpdR2pFt31+wsMcO/DH2PnC+kXFi9Jp1De+9h6148Nfiy/c7E373PrgYSuyIDkUJKMoPkitikDvrqM3W9s6+39we8X+LYPpa7injzQOxfQbj6ZA5pd4JL29NyrQekJy3G+iwpUxgkMd5usMxNiPYL6NiPK3DpxSub+j0t514kqatuwRLRiuxGeRDvNZmVMPjwjThLMBSG4nv5hu8PKHGWL/V+FCxDvwg42bf6UMuSs0RhYERj1wex5w5o7qIh6CouR43Qb7ULMe6WT/Ih5lDsQtSOLlaj8rI45y4aMhSOFDMv0hMY170DSv+TQuH9rpop34S5GuV0OiVV5ikeQhfg0Xvn4GlmeWxFfk9TqJ2IhEjIfS8s4wBTyjUta4Nqmzt8XFKDGRDOixbLs42Ep0lKv2u4rj/1TSz6QK6IruTjZqTiXwtkghW9FwLFlNzAE4B0em5BoZENowW4M42
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000003b5f0d065e0d8d27
Content-Type: text/plain; charset="UTF-8"

When swap allocation falls back to splitting an anonymous PMD-sized
folio, the new children are appended in ascending physical order.
shrink_folio_list() consumes its list from the tail, so it processes
those children in descending order after the original head. On the
tested NVMe/IOMMU path, this prevents much of the DMA mapping coalescing.

Keep this ordering change local to the swap-allocation fallback. Collect
the new children on a temporary list and reverse their insertion into
the reclaim list after a successful split. Leave the original head and
existing reclaim entries in place. On failure, append any children in
their original order and return the original error. Other split callers
are unchanged.

Assisted-by: LLM
Signed-off-by: Chengfeng Lin <lin2530632123@gmail.com>
---
Hi,

This prototype reduced PAGEOUT plus cached-refault worker CPU time by 14.84%
with one worker and 13.14% with two workers in a synthetic 8 MiB test
starting from anonymous THPs. Is this reclaim fallback a reasonable place
to preserve physical page order, or would you prefer addressing it in
the split or block/DMA mapping code?

The patch and both measured kernels use mm-stable 2967f3ccdb5f
(7.3-rc5). The machine is an Intel Core i7-12700KF with 32 GiB RAM,
an ext4 swap file on NVMe, and translated IOMMU DMA mappings. The test
uses full preemption, the performance governor, turbo off and zswap off.
Workers run on CPU 2, or CPUs 2 and 4; the total size stays at 8 MiB.

Each cycle fills and collapses the memory, calls MADV_PAGEOUT, waits
20 ms and checks swap-cache readiness, then touches one byte per base page.
Each invocation repeats this four times. The primary metric adds the
workers' CPU time in PAGEOUT and these cached refaults, then averages it
over the four 8 MiB cycles. Setup, waiting, full data checks and cleanup
are outside this metric. It measures CPU cost, not concurrent throughput
or storage-read latency. The extra traversal of the split children runs
inside PAGEOUT, so its CPU cost is included.

                       Baseline A   Prototype   Baseline B
  Initial THP, 1 worker   3804.69 us   3243.69 us   3812.94 us
  Initial THP, 2 workers  3978.96 us   3445.82 us   3955.02 us

Each point has two warmups and nine measured invocations per condition.
Relative to the two baseline points combined, the savings are 565.13 us
and 521.17 us per 8 MiB. Baseline return drift is +0.22% and -0.60%.
The two base-page controls showed no clear change. All 108 measured
invocations, including controls, are retained. This is one A/B/A boot
sequence, not evidence of the same gain in an application.

Separate non-timing checks confirmed the changed page order. Both
kernels submitted 65 BIOs per 8 MiB. Within the observed PAGEOUT caller,
the same 8,384,512 bytes required 2,047 IOVA links on the baseline and
64 with the prototype; these counts exclude work outside that caller.
The checks covered data, page state and cleanup on both kernels.
Failure/partial-output handling was source-reviewed and checked with a
local list model, not exercised by kernel fault injection.

The reproducer and patch are attached. Configurations, measurements and
review notes are available at [1]. The numbers above are from this
MM-tree pair, not reused from older kernels.
Codex assisted with the workload, prototype, tests, analysis and message.

[1] https://github.com/lcf0399/linux-regression-evidence/tree/a233ed8edb1e91a6a0ea0d326668bb1f52384489/mm/mm-swap-fallback-folio-order

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1153,6 +1153,37 @@
                        SWAP_OPS_F_REQUIRE_NOFS))
                return true;
        return false;
+}
+
+/*
+ * Keep this ordering local to the swap-allocation fallback.  Reclaim takes
+ * folios from the tail, so reverse only the newly split children to process
+ * physically adjacent pages in ascending order after the original head.
+ */
+static int split_folio_for_swap(struct folio *folio, struct list_head *list)
+{
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+       if (folio_test_anon(folio) && !folio_test_swapcache(folio) &&
+           folio_order(folio) == HPAGE_PMD_ORDER) {
+               LIST_HEAD(split_folios);
+               struct folio *child;
+               int ret;
+
+               ret = split_folio_to_list(folio, &split_folios);
+               if (ret) {
+                       /* A failed split may still have produced some
children. */
+                       list_splice_tail_init(&split_folios, list);
+                       return ret;
+               }
+
+               while (!list_empty(&split_folios)) {
+                       child = list_last_entry(&split_folios, struct
folio, lru);
+                       list_move_tail(&child->lru, list);
+               }
+               return 0;
+       }
+#endif
+       return split_folio_to_list(folio, list);
 }

 /*
@@ -1391,7 +1422,7 @@
                                if (ret != -E2BIG)
                                        goto activate_locked;
                                /* Fallback to swap normal pages */
-                               if (split_folio_to_list(folio, folio_list))
+                               if (split_folio_for_swap(folio, folio_list))
                                        goto activate_locked;
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
                                if (nr_pages >= HPAGE_PMD_NR) {

--0000000000003b5f0d065e0d8d27
Content-Type: application/x-gzip; 
	name="mm-swap-fallback-folio-order-reproducer.tar.gz"
Content-Disposition: attachment; 
	filename="mm-swap-fallback-folio-order-reproducer.tar.gz"
Content-Transfer-Encoding: base64
Content-ID: <>
X-Attachment-Id: 

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
--0000000000003b5f0d065e0d8d27
Content-Type: text/x-patch; charset="US-ASCII"; name="reclaim-order.patch"
Content-Disposition: attachment; filename="reclaim-order.patch"
Content-Transfer-Encoding: base64
Content-ID: <>
X-Attachment-Id: 

LS0tIGEvbW0vdm1zY2FuLmMKKysrIGIvbW0vdm1zY2FuLmMKQEAgLTExNTMsNiArMTE1MywzNyBA
QAogCQkJU1dBUF9PUFNfRl9SRVFVSVJFX05PRlMpKQogCQlyZXR1cm4gdHJ1ZTsKIAlyZXR1cm4g
ZmFsc2U7Cit9CisKKy8qCisgKiBLZWVwIHRoaXMgb3JkZXJpbmcgbG9jYWwgdG8gdGhlIHN3YXAt
YWxsb2NhdGlvbiBmYWxsYmFjay4gIFJlY2xhaW0gdGFrZXMKKyAqIGZvbGlvcyBmcm9tIHRoZSB0
YWlsLCBzbyByZXZlcnNlIG9ubHkgdGhlIG5ld2x5IHNwbGl0IGNoaWxkcmVuIHRvIHByb2Nlc3MK
KyAqIHBoeXNpY2FsbHkgYWRqYWNlbnQgcGFnZXMgaW4gYXNjZW5kaW5nIG9yZGVyIGFmdGVyIHRo
ZSBvcmlnaW5hbCBoZWFkLgorICovCitzdGF0aWMgaW50IHNwbGl0X2ZvbGlvX2Zvcl9zd2FwKHN0
cnVjdCBmb2xpbyAqZm9saW8sIHN0cnVjdCBsaXN0X2hlYWQgKmxpc3QpCit7CisjaWZkZWYgQ09O
RklHX1RSQU5TUEFSRU5UX0hVR0VQQUdFCisJaWYgKGZvbGlvX3Rlc3RfYW5vbihmb2xpbykgJiYg
IWZvbGlvX3Rlc3Rfc3dhcGNhY2hlKGZvbGlvKSAmJgorCSAgICBmb2xpb19vcmRlcihmb2xpbykg
PT0gSFBBR0VfUE1EX09SREVSKSB7CisJCUxJU1RfSEVBRChzcGxpdF9mb2xpb3MpOworCQlzdHJ1
Y3QgZm9saW8gKmNoaWxkOworCQlpbnQgcmV0OworCisJCXJldCA9IHNwbGl0X2ZvbGlvX3RvX2xp
c3QoZm9saW8sICZzcGxpdF9mb2xpb3MpOworCQlpZiAocmV0KSB7CisJCQkvKiBBIGZhaWxlZCBz
cGxpdCBtYXkgc3RpbGwgaGF2ZSBwcm9kdWNlZCBzb21lIGNoaWxkcmVuLiAqLworCQkJbGlzdF9z
cGxpY2VfdGFpbF9pbml0KCZzcGxpdF9mb2xpb3MsIGxpc3QpOworCQkJcmV0dXJuIHJldDsKKwkJ
fQorCisJCXdoaWxlICghbGlzdF9lbXB0eSgmc3BsaXRfZm9saW9zKSkgeworCQkJY2hpbGQgPSBs
aXN0X2xhc3RfZW50cnkoJnNwbGl0X2ZvbGlvcywgc3RydWN0IGZvbGlvLCBscnUpOworCQkJbGlz
dF9tb3ZlX3RhaWwoJmNoaWxkLT5scnUsIGxpc3QpOworCQl9CisJCXJldHVybiAwOworCX0KKyNl
bmRpZgorCXJldHVybiBzcGxpdF9mb2xpb190b19saXN0KGZvbGlvLCBsaXN0KTsKIH0KIAogLyoK
QEAgLTEzOTEsNyArMTQyMiw3IEBACiAJCQkJaWYgKHJldCAhPSAtRTJCSUcpCiAJCQkJCWdvdG8g
YWN0aXZhdGVfbG9ja2VkOwogCQkJCS8qIEZhbGxiYWNrIHRvIHN3YXAgbm9ybWFsIHBhZ2VzICov
Ci0JCQkJaWYgKHNwbGl0X2ZvbGlvX3RvX2xpc3QoZm9saW8sIGZvbGlvX2xpc3QpKQorCQkJCWlm
IChzcGxpdF9mb2xpb19mb3Jfc3dhcChmb2xpbywgZm9saW9fbGlzdCkpCiAJCQkJCWdvdG8gYWN0
aXZhdGVfbG9ja2VkOwogI2lmZGVmIENPTkZJR19UUkFOU1BBUkVOVF9IVUdFUEFHRQogCQkJCWlm
IChucl9wYWdlcyA+PSBIUEFHRV9QTURfTlIpIHsK
--0000000000003b5f0d065e0d8d27--

