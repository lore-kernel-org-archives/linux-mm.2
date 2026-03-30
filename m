Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 215821061B09
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 15:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835946B0099; Mon, 30 Mar 2026 11:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80CCE6B009B; Mon, 30 Mar 2026 11:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722A56B009D; Mon, 30 Mar 2026 11:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 629CA6B0099
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 11:15:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 14CFFE0F75
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:15:46 +0000 (UTC)
X-FDA: 84603079092.23.A62A257
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0E8604000A
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 15:15:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CRSouluj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774883744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=axsR7K0asYg5nALPRw7YsYMufL3bGkBOCMIxtB4VrQdt5G3BOpUVd4b15i0hUrHBLxdlcZ
	669y+N+4it+WYdMv5Ro6TetF4WzQpQZtTJY3YGuKegRpX5FSMCbirNjA8APOviRXhFWIHR
	LDUVv3pARulHXxhUDx2XmkkR1eLNh0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774883744; a=rsa-sha256;
	cv=none;
	b=eSCchzaN/zXsID64sLggV8gly7t2qEA4G/Kj0Sc2lVCvvqgWEKR5bPz+I71sFM1dE1uUi4
	QM3mELPter2c1S3B7mN5b86OXHukkemejJIrMuhlTJ3bxZ1Bh0p+POsn6u8Bx/bWvDYu35
	/oSQtYQus1nPfb6jjUoSYZBzX9a6t7E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CRSouluj;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774883743;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=CRSoulujzyBDpOHLQ58heeCFt1DPA9/mIBBiO71OaddjJH4JHy/DfLJvediOwchuvBEPR0
	WEyd5Pz8DnUc7rb60pBtvabtU76c385LRfVpMvKBHWnZDXHT7PbqNPcQ+aNWkZgjR2TCvT
	N/KIac8LuItHpAFwK5O2y4AgQdA4Tvc=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-533-F8nlyAYEM1aiv7zEatnhYQ-1; Mon,
 30 Mar 2026 11:15:38 -0400
X-MC-Unique: F8nlyAYEM1aiv7zEatnhYQ-1
X-Mimecast-MFC-AGG-ID: F8nlyAYEM1aiv7zEatnhYQ_1774883735
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9FFDA1944E43;
	Mon, 30 Mar 2026 15:15:34 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 591E21955F42;
	Mon, 30 Mar 2026 15:15:25 +0000 (UTC)
From: Chunyu Hu <chuhu@redhat.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org
Cc: linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	chuhu@redhat.com,
	Li Wang <liwang@redhat.com>
Subject: [PATCH v7 2/7] selftests/mm: soft-dirty: skip two tests when thp is not available
Date: Mon, 30 Mar 2026 23:14:58 +0800
Message-ID: <20260330151503.670415-3-chuhu@redhat.com>
In-Reply-To: <20260330151503.670415-1-chuhu@redhat.com>
References: <20260330151503.670415-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: t1DsWMMJ5yKaQ6-ygmJHeoRJBjLhe4CvFrCGBjnGNzY_1774883735
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 0E8604000A
X-Stat-Signature: eft4xnekkutmn4w5byc883rpyzfw9zaa
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774883743-445941
X-HE-Meta: U2FsdGVkX1/8Qe1wEJ0fptuInVGSFEzsGnEebaDNIRSoIklQwbdIAmcE2o2z/Be/IUeD+dGvVL0RYTp762JPF9EgoGX6SRi4QiIN59zMYsLjqbvfc8aILeFIT1iLDzOY2q4tqafwtevOMAP+xswdQtfH8+s1XFYjIIMip9sTuX8t8H48K7cuDsVLdHb7Lf0vUf5G9LgesVJytz59d6gjeAdn0CN4HaTaU85EzPy7IoML/sURR6cQr0O+0JtvLvb2mc41jg1aJW9rSP2cqt95SA2iFLHzdFiLiGCPLDEh3pL2TElc7E+Rs90hxoT3DfdwGcx/jcb5qlm4d/I707/GoE23YXWXQTNQDQszzAg89ILfbUZL9RWeg4XvXgcorUV0fDOynJJJe5/IKte6cfcoY8jDZB3u2E8SnI7T6rw0UCz/h4Jq3kZBLZbydUPuMaZG7+KiM6cLpkUOHI+4f8XcIWdqyJHb2k7YAyFOtsA+0ne2DP/Cuy7rHW1mpZ1uPpUv9+JU33b+sR7sZKIA0JCMbBDOq7KepWXazcc7KbsOghQVMex5KFDltpQjZViMzlBnkNwT74HR2/KeHKdSey1l0m0C8Li5FP9HNC+Bb/5FFw3EYhW6TnKopa82Aal8sonQjc60RVq9ddyoZl4doLFbGz+VdGm7ZOl9eUJrJ/t3+dohtwqYPpXe1b7uxCbDiAI1jBgjnwqycce1iDnLa0OZaXR0EUT8efVxKB/oeqcOdlKn+xkv4tz7t9k9bJ00VwhzAfZ4q432Vj5WI+4KbhAAvozZDc0shVQixheqACwYwHryN8MitCmIDBS84Vm39hflBySKP2jFBv+vRTWKYT3pxJphpkZTpXD4X0h+pNOrXRYsNT+z9zDYulMrQxn4fxrIqUHgRfnTzOINM8mEyH7tBqOaJ72E96Ao0/E8ADpYfULbu+saidkijk32MeHf6238Tx8mRzfBsmQPb62uIat
 ZDULSiMC
 3J/GUsUhe20Jqd1Ib9b/EGQJGqsAtFjgU9tpLGczpYQOxJFbY6YdbQ2XpIsNgvEkAU9fc9t3iAGLJjg6+U5zlwi9amuWnm/q1aUMh6jqLS9m+kE6XNAP86QEOqbSzJaO6Fg/U+2dKpp3aI+RE6z8QLwEv5xKFZilgp0xQPkPC4yBvA/v18BZ1bu1G3d0sNl0a/IqQWhNv/wwsadufkjZJcccDSWNB1QEtDrjQ+VzyVaQwHxyceguNvCjz2r0bysP4RJRY4XPpk0hJFSjekMVmMSmipQHi6GbhJyAhBpkh0Eey7UqSpTTBg44RnryUbLQWEJc2/+tfQe6RkE5SmF9AxkefhdJDOIH9XjvLUzhV9uNDIwHDebue/WF6UBzJjjUp6xLdyXBnXIqAqRc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The test_hugepage test contain two sub tests. If just reporting one skip
when thp not available, there will be error in the log because the test
count don't match the test plan. Change to skip two tests by running the
ksft_test_result_skip twice in this case.

Without the fix (run test on thp disabled kernel):
  ./run_vmtests.sh -t soft_dirty
  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..19
  # ok 1 Test test_simple
  # ok 2 Test test_vma_reuse dirty bit of allocated page
  # ok 3 Test test_vma_reuse dirty bit of reused address page
  # ok 4 # SKIP Transparent Hugepages not available
  # ok 5 Test test_mprotect-anon dirty bit of new written page
  # ok 6 Test test_mprotect-anon soft-dirty clear after clear_refs
  # ok 7 Test test_mprotect-anon soft-dirty clear after marking RO
  # ok 8 Test test_mprotect-anon soft-dirty clear after marking RW
  # ok 9 Test test_mprotect-anon soft-dirty after rewritten
  # ok 10 Test test_mprotect-file dirty bit of new written page
  # ok 11 Test test_mprotect-file soft-dirty clear after clear_refs
  # ok 12 Test test_mprotect-file soft-dirty clear after marking RO
  # ok 13 Test test_mprotect-file soft-dirty clear after marking RW
  # ok 14 Test test_mprotect-file soft-dirty after rewritten
  # ok 15 Test test_merge-anon soft-dirty after remap merge 1st pg
  # ok 16 Test test_merge-anon soft-dirty after remap merge 2nd pg
  # ok 17 Test test_merge-anon soft-dirty after mprotect merge 1st pg
  # ok 18 Test test_merge-anon soft-dirty after mprotect merge 2nd pg
  # # 1 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # # Planned tests != run tests (19 != 18)
  # # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:1 error:0
  # [FAIL]
  not ok 52 soft-dirty # exit=1

With the fix (run test on thp disabled kernel):
  ./run_vmtests.sh -t soft_dirty
  # --------------------
  # running ./soft-dirty
  # TAP version 13
  # --------------------
  # running ./soft-dirty
  # --------------------
  # TAP version 13
  # 1..19
  # ok 1 Test test_simple
  # ok 2 Test test_vma_reuse dirty bit of allocated page
  # ok 3 Test test_vma_reuse dirty bit of reused address page
  # # Transparent Hugepages not available
  # ok 4 # SKIP Test test_hugepage huge page allocation
  # ok 5 # SKIP Test test_hugepage huge page dirty bit
  # ok 6 Test test_mprotect-anon dirty bit of new written page
  # ok 7 Test test_mprotect-anon soft-dirty clear after clear_refs
  # ok 8 Test test_mprotect-anon soft-dirty clear after marking RO
  # ok 9 Test test_mprotect-anon soft-dirty clear after marking RW
  # ok 10 Test test_mprotect-anon soft-dirty after rewritten
  # ok 11 Test test_mprotect-file dirty bit of new written page
  # ok 12 Test test_mprotect-file soft-dirty clear after clear_refs
  # ok 13 Test test_mprotect-file soft-dirty clear after marking RO
  # ok 14 Test test_mprotect-file soft-dirty clear after marking RW
  # ok 15 Test test_mprotect-file soft-dirty after rewritten
  # ok 16 Test test_merge-anon soft-dirty after remap merge 1st pg
  # ok 17 Test test_merge-anon soft-dirty after remap merge 2nd pg
  # ok 18 Test test_merge-anon soft-dirty after mprotect merge 1st pg
  # ok 19 Test test_merge-anon soft-dirty after mprotect merge 2nd pg
  # # 2 skipped test(s) detected. Consider enabling relevant config options to improve coverage.
  # # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:2 error:0
  # [PASS]
  ok 1 soft-dirty
  hwpoison_inject
  # SUMMARY: PASS=1 SKIP=0 FAIL=0
  1..1

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
Changes in v3:
  - Add reviewed by from Mike
Changes in v2:
  - add reviewed by from Lorenzo and Zi
  - add acked-by from David
---
 tools/testing/selftests/mm/soft-dirty.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/selftests/mm/soft-dirty.c
index 59c0dbe99a9b..bcfcac99b436 100644
--- a/tools/testing/selftests/mm/soft-dirty.c
+++ b/tools/testing/selftests/mm/soft-dirty.c
@@ -82,7 +82,9 @@ static void test_hugepage(int pagemap_fd, int pagesize)
 	int i, ret;
 
 	if (!thp_is_enabled()) {
-		ksft_test_result_skip("Transparent Hugepages not available\n");
+		ksft_print_msg("Transparent Hugepages not available\n");
+		ksft_test_result_skip("Test %s huge page allocation\n", __func__);
+		ksft_test_result_skip("Test %s huge page dirty bit\n", __func__);
 		return;
 	}
 
-- 
2.53.0


