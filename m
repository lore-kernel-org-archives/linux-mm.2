Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCDE105A58D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABC596B00A9; Thu, 12 Mar 2026 07:41:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A871A6B00AA; Thu, 12 Mar 2026 07:41:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9935F6B00AB; Thu, 12 Mar 2026 07:41:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A76B6B00A9
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:41:11 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C9121A019A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:41:11 +0000 (UTC)
X-FDA: 84537219942.22.620B837
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 415EE4000F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:41:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JRqGZfBe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773315669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAzmMPLcljhdY36zlJQtF6Ye0/UcSvjVdBQd2alsCao=;
	b=teuE3eLQPy9Yov7hr0/yb4b7Dzf0ePW5EDeSkMtW36Q1ZSKzX0AUkgHbZpsqHVrYduJBUQ
	8Vb5hakNzfhoFmlPyUE/tMJ2KtAN4lNuKKrbHxuADB/8naRcFx5fOnP6XELhtypmMTfNGn
	NmvRmN6h7Auk3KNQyNBB81w8snDS944=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JRqGZfBe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf17.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773315669; a=rsa-sha256;
	cv=none;
	b=3mE+YjCMpM3wvBbBBpPDPjxwcaF0NBGKEb1U2WG3w+8jLV0PaiShcckIlDoxzbFATJoYiu
	vlTwKtGlMBWGHyKWBQSPUZ11XoZAWbf5Z79ZDE7DLs9Utqjb80EMNOPzurQ9JY/YeeHItB
	vy3UwGDbbp9j5VhhPG25GBnhNBwBUEM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773315668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qAzmMPLcljhdY36zlJQtF6Ye0/UcSvjVdBQd2alsCao=;
	b=JRqGZfBeUmUDwLo/eahc+goG7dxcxYjZrRTpfcqn3QXuMAftSAxAnyfeb1uWRH31rLHUA1
	a76ssalGZgXZuuyeqbefaLBEi0+5jg3h5YfgjVUQSKEryIeqaW5yJEs+6bn5OrUEg7vvKJ
	bLiQ+TkiTC1b7UZ3gtDkfKDrjiCmG/o=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-515-BN4trrCOMCqvLzYq7LIEJQ-1; Thu,
 12 Mar 2026 07:41:04 -0400
X-MC-Unique: BN4trrCOMCqvLzYq7LIEJQ-1
X-Mimecast-MFC-AGG-ID: BN4trrCOMCqvLzYq7LIEJQ_1773315662
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED2931953987;
	Thu, 12 Mar 2026 11:41:01 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0430180058B;
	Thu, 12 Mar 2026 11:40:52 +0000 (UTC)
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
Subject: [RESEND PATCH 2/4] selftests/mm: soft-dirty: skip two tests when thp is not available
Date: Thu, 12 Mar 2026 19:40:25 +0800
Message-ID: <20260312114027.634559-3-chuhu@redhat.com>
In-Reply-To: <20260312114027.634559-1-chuhu@redhat.com>
References: <20260312114027.634559-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 0aBX7mexx840qz0uTIm9URth_Y9mRoOqxbnFj_OIfW4_1773315662
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 415EE4000F
X-Stat-Signature: ot9sthudcifoi33su1i1bjhsa8bchqtq
X-Rspam-User: 
X-HE-Tag: 1773315669-302243
X-HE-Meta: U2FsdGVkX18nFRN6mJii6plTiKgLD8HO0h7O/hRdAXXFWlflfBgtRkUnhSPjeykFTl2Qxs6Eq+kOkCnIJAYlUwiESjCByJufdxSPGkRys4fXiYcAQpK1aokElK/bSJd4UiW4/53xjr2CokmwqvhM+HSYkHHmTLDqzlPb2rnPoHVbvyO1GN/dLjgJ/+sz4KgJMXRCRWhUBArJb7SrEhdAhlbE+NUMBSUclgJv+hHStEBFLYmSY0ycM1O4vgx9XjmJUijZy8QR3sr8xBCghGhpK05AIEDqqdFqZKH01oWKy1Xbm9cX95djNT9pyFqOk157fY6K/lY0dvf07Ai4bgUYMbDZ/pBlKHZQ9acc1vY3Ms/tIM6ArH245Ve32OAunBsSmP13HKyX4queY03ITxVUBxWW7z5qjS5e4Vd4pOMlJwtRM/pXM2bZycBW2C5Q/RSRqkq8cifVP4i/o3tjEVNQtuKil3j71m/psdyniHAqDKlbHE5dC7GzxH9lAErLwoGQYAaOFkURRIkbaJrX9Q0PYeDvUTPdrKoVQkU83nXy4tKZwH2L5nvf5WosmHpm2yhii1OzpewnFtj/6SEzdgKlakzT92I8buBh3JkEWxhtsCv7NqeePNmf3ZETfQbwJp5SpaazUUeN1y7OqGp2sdpnCyIz/pSN+i/2ys3YyGyxa2vFd+KXarYr548LQaymqZZSdBVoQN1u4FisDWgfRf15rUF70MY2TWwllyjgEyhj8Kl417wigZ+/PipQBWHd5T6oV2iXQE5I/4lQ3L4nKhVU8pwbg849GYGHtXX+p21QidxwkAPFB6I3RO0vXNwVCvpgCLiFGAf4NldEDCRVePoJVpKj1PDTEN9l6oztFlk9+HplFTO/XDgz74uMwfAy67RvwiQYdlZ/nHUIYpY1EZmL31Fp4Hv4wsFtx4pJ+wzrE61m5oiAs6GRHH2HXWiks42LH+Jei55979wEe2xi1HD
 tBhn+bgM
 Bd3HL+Z98xIf4adJop3qgIchCYNTPUNiWJbGFI9uDII5+xzT0vzmDKcGq0y7hKhdvoFTVlNyXbTMGD/wZQQzqyLx2WUEqCPZi7zoqZhPfJLXDsKlMwX03gekgGZsJ0wYe/wCO7iLR0Tl2pgdoWhNnJebR0AUGU8KN5EibolO3ZFOAc9WScD2yZ/rvs7FJfKMJs+M7qcF9/OZsUNov3JBK9I5Vf8dNqSZGNy2b9gv/YW1gfxaqG6kEGoVpVHwN9CLM9QxCdIPkdegTOmiObhIESclNhWjXTpIu2jwCyQg0uyr5KhAJqNQGNl7TyrV0eIIj3Uo/5vt6pUnBMGSHA3q5P2G9fA==
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
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
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


