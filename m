Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3405C606A330
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 18:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Szo7ZTs0
Received: by kanga.kvack.org (Postfix)
	id E06D26B05C8; Sun, 22 Nov 2026 13:45:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8ECE6B05C9; Sun, 22 Nov 2026 13:45:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56E26B05CA; Sun, 22 Nov 2026 13:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95DD56B05C8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 13:45:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA9BE806F2
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:22 +0000 (UTC)
X-FDA: 85463632884.27.231AB1E
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf18.hostedemail.com (Postfix) with ESMTP id 26F411C0006
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 18:45:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Szo7ZTs0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3PzgDawoKCBwBL9GM89LGF8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3PzgDawoKCBwBL9GM89LGF8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795373121;
	b=hqQegnouQ/vltoxDqhqzuoVp6Hboxp+tWbtfVUWJZ4fTnOiH6QNhn53nOjGZB6gkAR7f1u
	3npkuTU0xBwZG23NJnsg3S4yWSy+uDnaDD8QAa/IzKuk9fBw8qDfKlcu4dt7PuOikWq1G4
	SFL77h68wPaZDvwALc0pWk8AtTSCSEY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795373121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CO+pK6yVZkso6hm9r9Bht7g79ypAkq9rsogUtAB1SJQ=;
	b=5CH3hfqcly1dPeOVm8I3AAqbU5OcL2yAMDVT4daL6BHt0Z2Y3FsSaIs0QIHmKYKUxDNVeA
	IqfeuMj1BXJrh26gUcT6BxYA39RJIyb0S7HQGhlODPIXliETWQBDUyi9zB2CjFqX+uZAvp
	q4Kl7n4F6Il1aVr1oVsp5AupJnWMdPA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Szo7ZTs0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3PzgDawoKCBwBL9GM89LGF8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jthoughton.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3PzgDawoKCBwBL9GM89LGF8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jthoughton.bounces.google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2f04004edf1so18195495ad.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:45:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795373120; x=1795977920; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CO+pK6yVZkso6hm9r9Bht7g79ypAkq9rsogUtAB1SJQ=;
        b=Szo7ZTs0gDgeTzkkT0kmqYINEg/yn89SM1XI29CI9JH1oiUolinLsGPkR1tLxSsTsC
         yz2I5M0+5lAJcegeRg/QITm2Kapq2hhVqZegW0q7zIKN732SCrUl4PTBRrBonnXpW7+k
         yXCJmXGAQ9b9GKGGT8O9VepGtAmo6VkBTa3bqM7aut37bxLFZzcAI+OGrsffNxTi3tYP
         6VJQjtshj2E6A6MsoEJ8hdvIs1fcEYyoDZvELAJ8K69i7G9u3oS+kBMfPPFle+aLCT6Y
         okjXKaoEkMBS6i0tCU4wb7DUf2oYF43JALaS5AgtvmbdryY6xvdl0BY0w1Xj3CmIZaFL
         W8JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795373120; x=1795977920;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CO+pK6yVZkso6hm9r9Bht7g79ypAkq9rsogUtAB1SJQ=;
        b=x0+ja1MpXHQ2AEHo4YQQYFYDtAb1OQEOuzqvzKLdRNEdKJb8Bws26bftFIeQfmfsDm
         hoSa+QRD829nno4GJCeB0zaIm26ZYxpNpgkGiWTkkeJVJGuS9el9s6SaVcHG69QSa1nE
         pfrSfVCoxLge67pzWAG+BUT6hWcxLIY9+CCPjIfpTB+JaCzzL6H+Vfz3Tk9KYrWXw6oF
         CrIl0+QAXdk1ELfyjmoHnmsvYBSBkufupyxabJ90+jDkYLLbEHUfTXj6j+ic4ZnyajHR
         LKfQdR9zcyhyOCGRskjUW73vbqQKQB7+e0cMfRwCBD7CLfrpa4hZIxrD9mj6cGGBkmB4
         yirQ==
X-Forwarded-Encrypted: i=1; AL+hErG46pu76NmhvTKzopo5mAM6i3aJTC0OWl2FK1z88XDonPeu5CW4MItMrrTpcRIsxGs2Atz+6zf+Rw==@kvack.org
X-Gm-Message-State: APuU4Z9C3v2cPXXuPsfQQbhqPjECTdCBEH67HSjmTh6N5jW0qrN+0aqF
	1hp20aKy+VZMhIvohCqjG1EBHCMQBQrjwzKMghZ/iIKZyMJfZWBygKo4kM8caNUlY3kl4Tni7S0
	AWI+1gzqqrwpcZCcZAS5+Ww==
X-Received: from plwp12.prod.google.com ([2002:a17:903:248c:b0:2ed:8eec:6a11])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:db06:b0:2ef:efaa:17ae with SMTP id d9443c01a7336-2f03f1bacacmr79207885ad.71.1795373119804;
 Sun, 22 Nov 2026 10:45:19 -0800 (PST)
Date: Sun, 22 Nov 2026 18:44:53 +0000
In-Reply-To: <20261122184453.2668189-1-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261122184453.2668189-20-jthoughton@google.com>
Subject: [PATCH v3 19/19 DO-NOT-MERGE] selftests/mm: Add HVO pmd-split fault
 injection tests
From: James Houghton <jthoughton@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>, Nikos Nikoleris <nikos.nikoleris@arm.com>, 
	Linu Cherian <linu.cherian@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	David Hildenbrand <david@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Nanyong Sun <sunnanyong@huawei.com>, Yu Zhao <yuzhao@google.com>, 
	Frank van der Linden <fvdl@google.com>, David Rientjes <rientjes@google.com>, 
	James Houghton <jthoughton@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 26F411C0006
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: pxohszicmhb5zuewhxosut5dbh3qpaug
X-Rspam-User:
X-HE-Tag: 1795373121-462567
X-HE-Meta: U2FsdGVkX19nVJYrltgREUbr2lztp4KORMpYJZzZrH1edYASmj7I1kAe52q6UweYmY7EIJkzYB89pO+3Ic48NTk0T7ojGnM33cvJLEdqSlBx2+PDjX8C4nYUIFzC23tedSfXZbfV7vyePYExjJpUAA+Hg0Kn4MME2678owj6563M0DCKHl8GahKm+97bGXWXfDCzZZhD6OPOPNtxKTBwG1I5/3AXtkglGjQoQrtYFo4Lx4It2Xv7Bkd6FgWUNZ9aV5u2U/LDdyhLWO0urZjBxsCJo4doP8RJL/twl3GoUYdoex0StHKwMuC27NKCXZNnwjnw180P8TvXjdsLCeR5Mc7/BYcyPVTGpvSNYEXIffF2kFsGScHOzDheV3HcKvLJHqZIY+ishcBFnpSsAemEctf4PP8ueRgaO9OeOg7IpcHYtz9s9cbFEYlUiv8MPatre8GGvTmbNDvGlYHM4Kvi/xTe3xMcXsbmf0thdXK4Hlh5XasiDzLfgz9UAdVfUVDtA/FXS9qTZpyEsik5kD4uBmKnQo1GNxyftmqNqqCZuBwDDaogAP2DOsbGgvaMEPLrVCYd0CYUrO1kNY9gPJzX5oo0hJ90P1IAdEPsvXtnrF3dK1U5BAC/g5q99Oy3nc52ebpZ11qFYY0kNIcEZqkOnZunj7jZdcNzqqgVhE+LY/G7tYdzE1EqSiwRVtBocE/xLW89gDTNYIntmnQAF/BDNkox8dEebdqcadnRD1b5iOABU3HVn32UT5+m2m9IF0c4aNnsZBIiizFOtWR5FAjqo1FA2DehM85UpC28meAPjcBtYbTxt3Q887YPJY+FeeNbRgsiAxOPiP90cYWS5jfYELp11DYWa3ZlpZqC15yb6VTMogb2H5b2BAFeAKXiQ1/HtGkJobHGXDzWPs3YLNxKtY6lAFBOmpqs+GtAJiRirgO9t7yF0DNTwsZEOTWsTPf4hjmLkur3QpvwFxbFbKy
 fRMbgevJ
 xW2MsHNAeC+246x5HtXm86ztmq+R+Brw52A8IP9BQVtHjBub39eofc4iiI3abcopSbXmPIWoY7nr+MNxWp9L8vv3+cUMJMX3jVcXGVn0eWblDuxlLspVF1ueMvz1fMoQXyYuo7AxsUotWb4qwwvKNmxlajl6qFT72kMh+aTYoeLJeDUzI9QL7Da0y17//CRUOIM7goIcNDabogoOKwQ2N87ETVjt4VlAK6lJotyO01VwRbiOZaao6U6kawtLZCP4ECZ5Brrenw2P3kOM3m4jzDNgjJnbvnToYCLCQ33EJMiB8q09tSV4gwLJmqx6br3XPbSxHv8ix/MJ+c15JSTKN+DmlR5/Evlj3dwQPM/coTGdhOYZGFqsI3jUQDx+YwgpDn5M7K1xBRCi1ideLJRF7hM+l9JvYqXCR+k1sMB/0bz9eUNeCwtzeOedSQTPy81CoUQSMNOzka6ZffU89um7+9TV3t15MzTYQKDSR8wVZgI9TTa1hD7MNYRDNPa53ptgQeASwM1fbQ9gJHSZlaOzvd7HBVmTNl6qvdjBNK+34kgAdZfkZOKxjE9EtuOTdMX6xq19RjZMe1Mw/G5rx8ZytP8KTq03s0xsp+lY68XFOYe0qjWsRrrOuXKRsHvIvuk2SwDW+MvG5VeHykxCX2Euu6DpnuYYzCE1kZyMyjeYBU1gPrV4yRc07RZZLgxjTB3iqWSP7tquS5ynTxioMd6Mg1RMmC+5sKwPKBACJl7HbZHbgco6dgvSOzwmfo2BY62dnOOpNGwLHWzfLQzqQ1YEv272uSnQQ6y+MUudi/kFIZ0nyIK8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Run the stress test with PMD splitting failure injection enabled (if
supported). Keep in mind that vmemmap PMDs are only ever split, never
collapsed back to PMDs, so run this step first, before the main stress
test.

Signed-off-by: James Houghton <jthoughton@google.com>
---
 tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh b/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
index b64fdb3ed761..d570df02a28d 100755
--- a/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
+++ b/tools/testing/selftests/mm/hugetlb_vmemmap_stress.sh
@@ -4,13 +4,16 @@
 # Stress test for HugeTLB vmemmap optimization (HVO).
 #
 # Phases:
-#   1. accounting: allocate N hugepages, check that nr_memmap_pages +
+#   1. pmd-inject: churn the pool with fail_hugetlb_vmemmap_pmd enabled.
+#      Runs first because vmemmap PMDs are only split once, so later phases
+#      would leave few PMD splits to fail.
+#   2. accounting: allocate N hugepages, check that nr_memmap_pages +
 #      nr_memmap_boot_pages drops by exactly N * (vmemmap pages per folio - 1),
 #      then free them and check it returns to the baseline.
-#   2. stress: churn the pool (optimize/restore) while concurrently reading
+#   3. stress: churn the pool (optimize/restore) while concurrently reading
 #      struct pages (/proc/kpageflags, /proc/kpagecount), compacting memory,
 #      and optionally reading page_owner and offlining/onlining memory.
-#   3. pte-inject: like 2, with fail_hugetlb_vmemmap_pte enabled; this hits
+#   4. pte-inject: like 2, with fail_hugetlb_vmemmap_pte enabled; this hits
 #      both the optimize rollback and the restore (partial HVO) paths.
 #
 # After each phase the pool is drained back to its original size, memmap
@@ -284,7 +287,7 @@ cleanup() {
 	local blk t
 
 	stop_workers
-	for t in fail_hugetlb_vmemmap_pte; do
+	for t in fail_hugetlb_vmemmap_pte fail_hugetlb_vmemmap_pmd; do
 		[ -d "$(fa_dir $t)" ] && fa_disable $t > /dev/null
 	done
 	if [ -f "$tmpdir/hotplug" ]; then
@@ -366,6 +369,7 @@ accounting_phase() {
 
 echo "$marker" > /dev/kmsg
 
+stress_phase pmd-inject fail_hugetlb_vmemmap_pmd
 accounting_phase
 stress_phase stress ""
 stress_phase pte-inject fail_hugetlb_vmemmap_pte
-- 
2.56.1.809.ga0b61035b5-goog


