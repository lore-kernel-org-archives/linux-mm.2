Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC7C4105A587
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2107E6B009D; Thu, 12 Mar 2026 07:27:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D0F36B009F; Thu, 12 Mar 2026 07:27:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D3ED6B00A0; Thu, 12 Mar 2026 07:27:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F09A36B009D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:27:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B55E21C0BE
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:27:04 +0000 (UTC)
X-FDA: 84537184368.02.CD3702F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id C1EF4160007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:27:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PJcjeDX+;
	spf=pass (imf08.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773314822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAzmMPLcljhdY36zlJQtF6Ye0/UcSvjVdBQd2alsCao=;
	b=vMJakQCw7pB975tc1TzJugOMgLYaFV4BTXdbQ+52b4dmNs+wR2IwXJuMb+UC7GMIiRLBbU
	xpP5DWSa9aoNipXrPLwVQKOpBqUnTLICzqfNNCFdu49w3K/auvr0r1dQd3elAzcM0+b3IW
	U3sRwAj+LMhPtysNypZA53v0b9OxvKY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773314822; a=rsa-sha256;
	cv=none;
	b=neoKXEhoZBkJZZ49ojPLULxEmf41HHR79rvjy7y5TY2bzqpaEr3Q7PlYhuE/RTjGWTyuQ0
	lf4k7UEpKN9ePM7tS31fn3prIMRL1cpuVntWtmjH37Y1pUsc377BvccsEG3uoiOWfmKxp3
	Ow7CQRpjnSbtxnWEBosMn/kvKPX0G6I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PJcjeDX+;
	spf=pass (imf08.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773314822;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qAzmMPLcljhdY36zlJQtF6Ye0/UcSvjVdBQd2alsCao=;
	b=PJcjeDX+hq6craDmAOHgp71K+NCQueboTKojRXFeEUYjZQ204cMo6+4c1FiBfhF4GfjAtM
	cPXyijdYeyZwopFhRXoAwqj9cE6xXh1vKCYXBlfZ3YLDI661YB7AOjTT68OwJVs0+3XgRA
	AmnvKcbAbKSeuSacPGA88NFcpfvrpiA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-612-HnkQYvrMNY-RfiqmKHksQA-1; Thu,
 12 Mar 2026 07:26:58 -0400
X-MC-Unique: HnkQYvrMNY-RfiqmKHksQA-1
X-Mimecast-MFC-AGG-ID: HnkQYvrMNY-RfiqmKHksQA_1773314810
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6FE3B18997C2;
	Thu, 12 Mar 2026 11:26:47 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2987C18002A6;
	Thu, 12 Mar 2026 11:26:37 +0000 (UTC)
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
Subject: [PATCH 2/4] selftests/mm: soft-dirty: skip two tests when thp is not available
Date: Thu, 12 Mar 2026 19:26:09 +0800
Message-ID: <20260312112612.633138-3-chuhu@redhat.com>
In-Reply-To: <20260312112612.633138-1-chuhu@redhat.com>
References: <20260312112612.633138-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: wD3mNu918arTUYRvyGOY76P4ixBO2Ghs5u3L6AtzKvE_1773314810
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 5p9hsja8sqdkkw6o1ftuyu5kbiia5doa
X-Rspam-User: 
X-Rspamd-Queue-Id: C1EF4160007
X-Rspamd-Server: rspam12
X-HE-Tag: 1773314822-521793
X-HE-Meta: U2FsdGVkX1/0NXJX0hiyGT3m2OIIBVuYHwU1Qt3JnW1fZV+godQ/V2mOp6RsjR8nNnoOyIWwOqlJT5j05m9jEYBaNMmm4W6PJQSR2V2gsG7L3u8y+wVDOF7JE61+2aYdyNG9+3FX8+V8yAqC0dzQJhyB+DjBXblbDUa7UwXTqvLmwtCbdsaqG33ItiUYoF+KX85oVbzK9tJJ2Nuh7zsqzuJTazcK/+bQn0RXi0b/z8a6lgTOzFYSP9Kpy9PItRpaFfEL9jmfcK2BiFfmBxrTimEGpCssL3HB03NC7DDIEC1IMqgPT8EorN3dz4HuI3v4wwKQUfNh8/4o6qusmmDsTn/tDR3bL6DpP4GDzD1JnzpZ7JzcN8jQt1JYDIhIRhE1kIOOc4t4Op0vLI/U6xL57eMWurUUaDrSVacXVkx7EQTXpedtUOc2gSY6wjttPhPOIgPJ5AOkXm4A08cMHJUqYu77kAFx42j9GOT3D/anJ6hVrnYMa+amwTUQD5eZZuGYlE3u0ZvdyPXWlGLfI75dWi3KOl5v70GurNjRQqu2q+whItyllcvijTIaOIENrFC0ZE8GaWQ78PzqRH7opvV6T486EgH3Z+eoUtxcOOFzKk844aro7Skn7YHLCKEtMss3mtomQ/gD7onaSIVm+T79ntWvmIJIBKQMbehjO1akwCveJqSS56ok306qVuKVXEz0TathqV1zrsyyd4C+eAVEfub5XuDBOkdGvHHuwIqaxTDmen841Lx1uLkkMTLs/mAnLmEADMjK7tJ1u4g1mjmnfN4heKBSFjpnhZciYVfi73oj7w7kLWOeJDn/hnOwr+Qj8xfJxuNnSLNPEr9xflifISq5W6tGHmVTY9umOKCKNdua9X3yZhPqzJpnfxzfCjiEc/jsqIeh+azU2pZ8AxbJH0aEjI9mDuwSkEEK7dQdOPDWpeD0yy7RPj9bmBNxMHGnjTzcahcHOCfr2UuV8Aq
 wx8i6ynv
 ZrOkmsj3OjEls8q7PJOXNbMb8p3IwdKhiGt7qjjKY7x46VSaL6mYV1+9dAvFVaKZity/eM0wS+oqmyR7pq1dOlZiMKf7az3mRs3V67zS/j26V4RKvhsMi/Xoz/U5Q0mjBfFdApuDvJsITiP58XmkNozeUGgbjcQlhWemJTosYOIOLTJ9DeKB4IziZC9qxAKanE+C/YXyOWnKxCEtma58MUOmC0WTu3IBmQBr/GEZE3GrZxLHHhDC6U0nppjZkl61spGGel45JKfj0wvwA++jYnPR5gV075WEi2nGwXalSME6jPeJzeKFABTs426hjlQ/RWNm1Gr8zd6FuLNZ3Maak4/t+xw==
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


