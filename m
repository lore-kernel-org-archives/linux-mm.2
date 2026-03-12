Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157C8105A587
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:27:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D28E6B009F; Thu, 12 Mar 2026 07:27:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 693276B00A1; Thu, 12 Mar 2026 07:27:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 575D46B00A2; Thu, 12 Mar 2026 07:27:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 473B46B009F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:27:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 117341A0181
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:27:09 +0000 (UTC)
X-FDA: 84537184578.23.9CF416C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 39DF21C000E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:27:07 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R7miAm7m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773314827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAzmMPLcljhdY36zlJQtF6Ye0/UcSvjVdBQd2alsCao=;
	b=Uo7OgJsXvw0cpRcP5M/ALvQq+N05ma+ad5ARYQmX7aNEaJtn3j82GhZTiqNYVp4IUjPMsg
	3yejwB8fwa+tduUSuv0f3yTlLCk29PqG2p+/rEKAI1kI0bIbkChtZyN79VvXL7DXf/oslf
	w5nGKxdB4wvb0KuZGDMMIFZ8Wk19p0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773314827; a=rsa-sha256;
	cv=none;
	b=Zwd7+9GWYfz5e6MM5zo0Nw+++1s1VcNGjBW82UKazAiQRwdx7a//a/9d3Xib/WxSJlgw8x
	IEuXi5zhEas0sZECSxMRa2NX/EN4O5Vuuhx55Xz8lumpGKf/pzzAkgFFMnJRgAOH8xdJFA
	TkclrECu7eQ6JIj2idZgyuy2ziuA8k0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=R7miAm7m;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf20.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773314826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qAzmMPLcljhdY36zlJQtF6Ye0/UcSvjVdBQd2alsCao=;
	b=R7miAm7mt6xitQnUvZPT5v9RL8FvwO93V+I0r+rcPVvYYJXGotIqdoulAPJvl2vJZ+SpUL
	ZY1BubREdFwF6bpFJi2IIbQ+9G6G6KMczQTrBSfyPW6Dvyl4o4QzsB1ND5D2Ux72CTMgwI
	FUV4Yu/3MLhlsTw4yPNHfDxITQcpB/w=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-588-83Z6rh2mPryq4yNmS5A3TQ-1; Thu,
 12 Mar 2026 07:27:05 -0400
X-MC-Unique: 83Z6rh2mPryq4yNmS5A3TQ-1
X-Mimecast-MFC-AGG-ID: 83Z6rh2mPryq4yNmS5A3TQ_1773314822
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7A391189A372;
	Thu, 12 Mar 2026 11:26:57 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2B75B1800762;
	Thu, 12 Mar 2026 11:26:47 +0000 (UTC)
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
Subject: [PATCH 2/4] selftests/mm: soft-dirty: skip two tests when thp not available
Date: Thu, 12 Mar 2026 19:26:10 +0800
Message-ID: <20260312112612.633138-4-chuhu@redhat.com>
In-Reply-To: <20260312112612.633138-1-chuhu@redhat.com>
References: <20260312112612.633138-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 0S9iv-4Qyv9gZZWsOdaATxWVgwBRLcH41BiwtcWUdxs_1773314822
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 39DF21C000E
X-Stat-Signature: 5p9hsja8sqdkkw6o1ftuyu5kbiia5doa
X-Rspam-User: 
X-HE-Tag: 1773314827-938270
X-HE-Meta: U2FsdGVkX19bAWtnCpk5WNlnkfGh8MCBcir0bU/rrfKfQKbjapHpVo0zHCTukV5ULmK+P0V3j9yltJVw2JtdoBwygane6bQJi2FTDGecD1kLMcIxtkHqQ5gT4Ow9OetZnbIQYNBVKOOytD/YlkINwdIKPOQFj8sny0gAAsqvNmiE+SkkETiFPadGlRx4JAxf0tyIJp5UT46pr/sezteU3Q9F3AEJ89yse/ZTveJ3KGk5pW6keLzC0qIpLMxVRDLzrP3f37L4eZDQqUurEWchW31G5jB3DR+3kQOl9YDK5y5rWzdsDU0waik8pCGmn2HIsH6JJ7foKzgsMlOE5cZADLDItY8+KrIiRSPwZ6HSqrufrA4LDDJtsHW0xQbMpx6hON51P6kGugegKw5yHPi/bdIFhl6DXWiG3IZP6F3BjHMnr1/P8z/CRKnSxPu7uYdRTKE95RfRrAXsA7de5WWJNpK2OeaQsU9f/W+QliUlbM4F2djYW5ilh0TJK+OBn6v6Aqnj4w2o+zKFl4aNbmKo6JMwGkVjJqzn19B8oAwkf0zV+vaV9ql1UUiln0bzTxWwRGv7p4IYeshlTgT/pJt3C8C9OugHZRD2FXqL4JI7jN5vHb46czCiBpzD9NYY+Hu17ZN7WcX2pYqM7s6+w2RI1yDLWUVDbomwm4IEWF9J7HCuy2Kb1JWTuz5qeHaGxpm8mtnQRkTEhsaZfrhsk5JvS32MeyitxJbUS/LC/nHgi0l7CrZ2gp5gqr3Z6nF/YNL3OpMsMIR/Vy04yBNJXR79/V7n0Qh++2+iQJtf9e/a3qNnlYZD4QaPbc/k+Aw5Ay9Fn5uH9v0KKguesceNMGEFtz5wZaID/7Wtcmymir9wl4ocZ7XCgkrcrcqXt6zNCDn0w4pBgaTaOXbfn9P3n2UdPQBjx0Q+yTCm5F9olwfP1c/MobiFFR061TrcJ3CXoe0l5Ia6qwlCdu+K4Y78Afo
 29cjtPXR
 ds0/5vfL9qEbJJD9qZu9tMCc3rw5X2bIsdrkA2/qeE8yu+mOITKFnU4hqtJrI/EKwGYtS60ylNtJ5K44ZpCULM0Y6hVHMQOtzrF+13IVSt0JuwIIFAlygS+Sw2eGKDXhKDeEQtfZFt/EHpBH41exX0BFBCyHASezaWiyu7cBjo97ghhtIceK6ZiH1Avm6OAdDsEKHGTuHgEyCOJFpVzcI8w7bcaANMgazC9N0yzZ4B+O/bgUZOsKiJKJOOLLuIRIKL9dZeNEaz1hEptvn0IPpqj1tAal1o0fhzHPg8Ul0fk/yao7lHGiHUt8JhMYRjRVOAphj3ZC3d0wxl33nsf5kjL0Lag==
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


