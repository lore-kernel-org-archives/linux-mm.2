Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75122C79FB6
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 02:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 320696B0095; Wed,  9 Sep 2026 22:34:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8676B0096; Wed,  9 Sep 2026 22:34:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 211086B0098; Wed,  9 Sep 2026 22:34:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CFBA56B0095
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 22:34:17 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 20F6BA490A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:17 +0000 (UTC)
X-FDA: 85196283354.21.5E40F49
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6DBCE80005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:15 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=od7ACfPH;
	spf=pass (imf02.hostedemail.com: domain of 3JReiagoKCDgdnbioabnihaiiafY.Wigfchor-ggepUWe.ila@flex--jthoughton.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3JReiagoKCDgdnbioabnihaiiafY.Wigfchor-ggepUWe.ila@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789007655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QCBRc7qyPLFL+OJFBYmAJyv6e7+fNwOVRVnLSpwhyZU=;
	b=LmpH5nKWT0rLks6NXlFRyHDDorW+lWfpzJ5TbVHcJiWHcq23htepjT6viuve7bC1dKAZ4n
	14F8lz1O50dyruj7UXtPekleZTGLei61d9G/yEEd/ZzNjhO5JWt1l7J6WFGcv09hMoQOrP
	nJa06CjEGX3KTxU7LxT7F8Cdbb80Un4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789007655;
	b=z/IFmQGkSuZbNq5hZKMLhWE7bbwuFCqVwXfvnidHx/6rGA9xkhXBMlgA+4bOXkQ+FPxF/R
	9Sce6h2xaFzRBsOISb07QqME+VgB9zt3fkqEFj9SQlVOvqASiDlUzG3MzO1YlkfFUZhkiV
	6tOPHFAOjrAF6qpIjMl8IpCfjd33GaI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=od7ACfPH;
	spf=pass (imf02.hostedemail.com: domain of 3JReiagoKCDgdnbioabnihaiiafY.Wigfchor-ggepUWe.ila@flex--jthoughton.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3JReiagoKCDgdnbioabnihaiiafY.Wigfchor-ggepUWe.ila@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-398dc3d8f0fso630131a91.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 19:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789007654; x=1789612454; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=QCBRc7qyPLFL+OJFBYmAJyv6e7+fNwOVRVnLSpwhyZU=;
        b=od7ACfPH38y/vifIV/iWmKgNC3ouTgDbwx0HMcAbyZ3tBBN7Bw0J6ORvDPKxQ2fn4U
         boxlcZR9InOJbIHX3bZKaJgsaH5N+2hFq0XlZs5CE/RzJ64jhLGAJpo/PSnSZCh0tpfW
         TuTv8M86SklM/HsVF2nvv7N5yJLA5+nPyh5r2EYBezMLO3zWCX5rzaLB341D36n5Vnz6
         J+IQwOHIZ5N0aXO1F1nZFlrUnKly6/G7cn5BEG0Z+VMvV4/G1X6G8KS3p0JKdituGvvp
         jnFC+kEuJmqSYZRy6970UB/1La2gK0li8C5RgzvahmpHw3Ay3BtuKhUTincuUG342qpB
         rydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789007654; x=1789612454;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QCBRc7qyPLFL+OJFBYmAJyv6e7+fNwOVRVnLSpwhyZU=;
        b=PQqWzl/YkOUDIpR3nJIjN2IJR9MB0if0so27DB5IfQtyNDKeb1a3xnHTyd7CQG0+Lo
         gVLhcPsFNvympZIHk1ddexs71Q1nc3C/PmZLtCEK2shk/x6K7UwAqpoRM8MvlIxi/vSm
         PtZ/eWauswh5GxG5NPwVRgFIvkuZS38kfwEGwyx2mRkGctwvHeD5gy8IKMiy8fL/SGlc
         CIk6lvLTfyyS6qRKd00YN6tJv8IQx3I8T2l8NM+c+H0sUIbXAVtv7F91pkxE3IgVNrc3
         u1Z3IneHdldssEQUkIr7vnjt5/BOABqYDNOTyC2n0gho7RL5/3x/aXEjxeKTvl+IuY/M
         WFWw==
X-Forwarded-Encrypted: i=1; AKwUvByIQSnSeHY1X/oPSbKFQBX951nO3rDkvwQ65eqU8clNrM4OZM6K4xtCpYLNC236uiBOyYj2m30p2g==@kvack.org
X-Gm-Message-State: AFuF++l+oororHUdd74G+mO0lREas0G7QOkudYlws9z8tBA9qMJ/Mll1
	4BFLVdBL79//ISzGLwHdqD6kIXzmjpTw3mwxlUH+Wowd2/SAmznZvA2VT5EsZ//F6tkZzFyRJXt
	S+kpNCPGhqom4FSHwiI/+Gw==
X-Received: from pjqo17.prod.google.com ([2002:a17:90a:ac11:b0:396:54ba:892d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:5485:b0:395:8124:ac53 with SMTP id 98e67ed59e1d1-39d77a1d83bmr1950372a91.6.1789007653937;
 Wed, 09 Sep 2026 19:34:13 -0700 (PDT)
Date: Thu, 10 Sep 2026 02:34:10 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.1007.g17ff1f9808-goog
Message-ID: <20260910023411.514987-1-jthoughton@google.com>
Subject: [PATCH v3 1/2] mm/khugepaged: Never install PMDs in
 uffd-minor-registered VMAs
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com, 
	hughd@google.com, Kiryl Shutsemau <kas@kernel.org>, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: md8nap97fxbfks3z1uznjgodo1iue56t
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DBCE80005
X-Rspamd-Server: rspam03
X-HE-Tag: 1789007655-761896
X-HE-Meta: U2FsdGVkX1/0oi0pSDMR/DQW/iHpBzfm40nwMZBlwq1hNkE/aXN8hlYf28wdfNzxmazv2bf9Nqoe2L4Pa5HYI7D3J9o/9TvD2xVuhHB9wObvhbjm0YRluSlbZ2oNUxRF6bOp9NFqlvM3RNCFakPPA6hZKjvIL+BsR16lNgszbacRtH0AXA6B87pePCPQpi6hMyIVmHvdyQjMHYfD7Sq9z41H25SkiHS+vevdFimdG55p/t+rdc1gdhBCdiovZBT1cIwMmMXxo8CM5F8fE9n51iHbJ7mm/HYnCwL08+5+CGjXMOHpgJSc2VL4hazvqDNa0XDPTWWgIQppq7CuY+L7eabq0It34jkWJfukYxsU5dr5yHc/pQp8juAxYVob7k6IqJG7odtciSyLxz0A82tz3WG+T0u73ebBITAgD/WoOTGh9Nv+Qduv3+kMxta0Qkv/ieTBoEaOrjNYNUBzPyQds+bkJ2vaOpTdh3YC4Q5xXVm0hnRymjylYAGCsRMg0IJKIeHlsPsYuCL1Q9eDzq6nkG7mG1kSf18ppbC9IzTqxXVArqw7CD6axo3VjsZ353QO98ohr7+vodzWPIzx2pbLfhqWy9n80UozUknDgEIfS4cji75tRWfUnX7C6Nn4KdHuQTQUoJlrqXaVLIuigaRcwxh3Famn+tAcxOOCtl0Qvn8xnGEkZGiEqq4paBhs/T57i1b1xSiSO/4w2k6i3VdI4RWcTG8MB7SJZOAZf2lNgAa7If9qJI3AvbPailg/r4toBHKGjRN1ZzGKNI1Uo14YFrqlnLQlGgObV1nrASEPcjEEDzMAcGR92Skr4+FV8wRsoHPtTP+hVTqZy++iiJl3rWzb3QE+N5XJ1n5n5f5mJaR27p9+L4GetCQQexyH22dl/NKCutWx7k5ojJ36TYDfCzWdEYZj0EIDkQCOKsNX+Gte5tTaTFoGbq8XMvxznfF2L+iH7b9mJFtvjZnZefU
 qN0pKaZo
 Z+zUoZcqTOb7RXpuSwxcK+TMofp8t2diPGmsoIOuBlkykE+LrWMeAxitaRooUQS1rAqCDO+cWMjDzQxdk5Nje7QDWYwuNLazVdjJUJTCoaCCBmKhWneNDH2grkYJox2vc0P8xx57uaO5LOqrImF2V3WtXed+2fD14kGXoRMw9H8ELI8YCSB4SK5ltXryYgUlZYrNpAZQyHnpox0LcOxhMKS79zuYeA1Sy8OFL/DInPJzF+D9sf2quab3ZtFIoE7Gu79vN8Gqtwebktoe8QatGvpkjCH3L40ib93ICzDDmVxy9EMC617Dss4CU5tZwId+ulIL3vUKi5yJh87Ti9m9H0r26OBvipa/+0eM+/nUPCCeIYjNqpbRZYKYAGSsV2l69CQgnOGKcX5qKcjffba4+06qlKIjbp364An+rLaYqJp/Jay4DXnqrP2UxcRWryrnkJNbf0yb8EkFX85w7PIg1iK4eDPfgP53E32h8WuawdInZF8YmxFlg52+6BAHCl2T61pccDisRdXbn78SygafxBAz1AI3rPAJ0QTsA+uWFRGanddFWr0TfYx94TCWV8yBeT0fWymvdzSfaEuhiwkNzamYG1oMsS2OBm5boWUSv9TuhlZ9w8NQnrXOiqGHOolI3JsCJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Userfaultfd minor faults provides userspace with the ability to manually
install PTEs with UFFDIO_CONTINUE. Right now, MADV_COLLAPSE can map
holes in the VMA when a naturally-aligned THP is present. This is not
true for khugepaged collapse: the PTEs will be retracted, but a PMD will
not be installed.

When MADV_COLLAPSE installs a PMD that mapped holes in the VMA,
userspace is likely to expect UFFDIO_CONTINUE to succeed on the
should-be holes. UFFDIO_CONTINUE will fail and return EEXIST.

This is not inherently a problem, as MADV_COLLAPSE is an explicit
userspace action. But, especially because MADV_COLLAPSE can be invoked
by an external process via process_madvise(), a rogue caller could break
a userfaultfd-minor resolver thread. If khugepaged is later updated to
install PMDs for khugepaged collapsing, that would be a genuine problem.

Userspace cannot generally use MADV_COLLAPSE to resolve userfault minor
faults, as MADV_COLLAPSE will only resolve such faults if a
naturally-aligned THP is present.

The naturally-aligned THP case is the only case where this quirk exists.
Collapsing otherwise requires all PTEs to be present for
userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
correct. This check is essentially bypassed for naturally-aligned THPs.

Suggested-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: James Houghton <jthoughton@google.com>
---
v2: https://lore.kernel.org/linux-mm/20260828222640.1638457-1-jthoughton@google.com/
Changes since v2:
 - Drop cc:stable and update the changelog for the main patch.
   khugepaged doesn't actually install PMDs, so it is impossible for the
   kernel to silently install mappings that userspace didn't ask for.
   Therefore this patch does not need to be backported.
 - Update the uffd-unit-tests selftest to account for the new behavior
   (new patch). This patched selftest is equivalent to the reproducer I
   provided in v1.

v1: https://lore.kernel.org/linux-mm/20260828005004.2870750-1-jthoughton@google.com/
---
 mm/khugepaged.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 75639298efc2..e6947fe142ee 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1894,6 +1894,13 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	if (userfaultfd_protected(vma))
 		return SCAN_PTE_UFFD;
 
+	/*
+	 * Userfaultfd-minor-registered VMAs should not be collapsed, as
+	 * userspace is expecting to explicitly install PTEs.
+	 */
+	if (userfaultfd_minor(vma))
+		return SCAN_PTE_UFFD;
+
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
 	if (IS_ERR(folio))

base-commit: 5acbae5f7eb3d5275120abfe698c394b7325dcec
-- 
2.55.0.1007.g17ff1f9808-goog


