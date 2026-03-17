Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C86FF3382D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 09:45:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00C326B0093; Tue, 17 Mar 2026 05:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26286B0095; Tue, 17 Mar 2026 05:45:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3B876B0096; Tue, 17 Mar 2026 05:45:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D46CB6B0093
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 05:45:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9996CBA16F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:45:01 +0000 (UTC)
X-FDA: 84555071202.01.CF773E6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id B53DA180009
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:44:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Xc1b/elm";
	spf=pass (imf24.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773740699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=ggdCbFDlO0WDwf3O+uod/dGJGZrjsk6t3n9P/qDiVcujQlb6Go1QBrtoAIp1nuMOozXvDV
	ChHLO6L3QEgnKd3Cmq9j474BSancldXJSyvPVvVhd/LR7oQbu0PscWLJu4QEbQfK5qsWCR
	Yg1Lf9DO9OHvHYajbrLuhICXKzpVKi4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Xc1b/elm";
	spf=pass (imf24.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773740699; a=rsa-sha256;
	cv=none;
	b=2sBslWp8D53u5HlmyGEPn4Ssv92R1zBG1S0/hej06GofoCZ7bHRLZssE1+C9qoS2O2nwXC
	hv0aLx6EgCv59Q+b8mcXR1RguWwjspm1YSJImLCuZuhHnbJacSOnKS3R3ACsr5JJiywhFM
	8rFJqYSfJ7WyDuFCrHOXLF1S1SVPQsc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773740699;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=Xc1b/elmMBsRfNp62tuE7p1lmfN3+GjRIpH7kKtWLHnE9GSlhsA5aNjr6LwwdHO0cpZ+Hf
	hJ9yMtB0edWXEvSw6+zLPmcK8ptj5OvFxAAWVhjgmXwg0L6lNVtC5VzKOzd2sIAyMM7gLq
	oI9Vx5dXinqsqZZ20W5SwlOvmRPwImk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-0Qk3ULl7PuO1L_-2sgw96A-1; Tue,
 17 Mar 2026 05:44:54 -0400
X-MC-Unique: 0Qk3ULl7PuO1L_-2sgw96A-1
X-Mimecast-MFC-AGG-ID: 0Qk3ULl7PuO1L_-2sgw96A_1773740691
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9507619560AF;
	Tue, 17 Mar 2026 09:44:51 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 65A1B3000223;
	Tue, 17 Mar 2026 09:44:42 +0000 (UTC)
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
Subject: [PATCH v3 2/5] selftests/mm: soft-dirty: skip two tests when thp is not available
Date: Tue, 17 Mar 2026 17:44:16 +0800
Message-ID: <20260317094419.1429259-3-chuhu@redhat.com>
In-Reply-To: <20260317094419.1429259-1-chuhu@redhat.com>
References: <20260317094419.1429259-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 9c-7BTIAddzc8Dkqfm624GcdFRUxUUVKcfSVYTD7iko_1773740691
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: B53DA180009
X-Rspamd-Server: rspam07
X-Stat-Signature: 5ecjbaefohk59aogu5knf4igdb7m6z4c
X-Rspam-User: 
X-HE-Tag: 1773740699-404481
X-HE-Meta: U2FsdGVkX18rPPLCjeXsHt3hXjn0DDHQx+FfIMUxfYEvLAHvy7j+sHnzznrYFvDeWxSUu1MK1PgGhR0MvSE1Gvc0FlUVvDZ1Nk0rc6R9P98BprxYkqcX3LgFNVnkJ7MoF16WEzDKqaDCwqRJqyv1OkNjLIWhDNvjp3I9/aGW7FU8zCJRcwleBKVeGE01fFCm6RHPISf6TISIXscdVgEm4eX1s4ean5dtdN/6+U6wSt8P8xc1mpq8taIDynYLuknWhrgX3wSGapr1G4Ez/K4JW3xTIuB7UDd7xrafF3VFTVBMq/7k1qBfcZ+38T7bs4Ew0j4LsX7ANc9k+DdffSDelkIOBrsG/WuVIb0EQ6o3mXUOUzzv8Z+3wFghvtkbDKZo50MhmYl9todAdEA0sfV2GwkTLkjx4eL26+MmIGS9CTJUKbYortlHfbAOGFVb6sS/O9okB/N1qUcsVGCWUOg9zruVA69egTaG2moMKlDe8qD/YvOLgRCiOMT0yjYBLDOKAWZPeMa8HbPVznKD8WASdu6HNm9tKlIv3lcw79j1zV7b8jT9mIKdPZ3vfOqS8LnibQHMEdnXJYggD9Ov9/L35Jr8r3vmjHBsSiEC2pqwjw3G2PDE+WmOHDxhLNkn3Lr3ndGHKDBP+XUzLfI9xdWo17H8UqhEblYIdJZlahhvpyhSj/9/B9bKu6gI9UnH5xw7w4+BZBVlFNe82wlfode35GVzNKx0uFqifTxPvWvCB9StqvwQ5i/qSmjqtPhed2x/dusymHV4Okewefz7vWNzgn8yf8+OZgoxv6fuZt13Wwm/VE7QnkMdBJ8bHdEZPTlwSJ0oODuD04VzpZJl2NawIb/cncSA6ul+0d/4jgD1oWkz5VjpDJ+ifcQcYQzRlnwxIL3g+So4ll52azpiTIcIUmcne1L6gH1M3S2tl+MpGO05f8AtgkxkdDZh4I0k/CNslr2wA8kL7olhhrzmgSW
 Fs0YCzVe
 WV8+YNP5d0eirWPhmmV0djdITCoQdp3s1z9q4+3VOalzo1zTq3vvZVZT6XQlWhROOiPr/XiNJOL0FrcuQpnkYakbs6OTAiwbqbeSz9jpmxrwciKS4gp0Y7InPpopW5JHQOW58eeiBeRrZqB5YOyQMfdcXwSy97qap458B+p9SapXInRbuHpl2oKQPoIWYyqBLxtCBPAH2y9t42ebX3puP7PgFrOZEsyYdhSqqPYNP3Y+TgW9gdSk3A4E8198T3UYx8SpTQ1YQmrgQ8UT89s/X+IAQrFg1AAmMLv+ogcxu0gEdAHXwE2zxDc/QjuBsN2VAzaZQS9lX6lNPQj+KaILAY2GVvgQLOlcecNcm6cQXME0+eJje284drWvQU1cptGMdjFk4hUrriPBG/D4=
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


