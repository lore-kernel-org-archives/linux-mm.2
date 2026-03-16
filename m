Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51019D58B22
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 04:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83D36B010F; Mon, 16 Mar 2026 00:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24996B0111; Mon, 16 Mar 2026 00:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A50FF6B0112; Mon, 16 Mar 2026 00:44:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 96B676B010F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 00:44:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 486458C17F
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:44:17 +0000 (UTC)
X-FDA: 84550684554.26.3C6DCF8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 64A11C0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:44:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Npbxi3pw;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773636255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J+5vIvfueq6IMhLJl1sQj/A9x+kVAV9b++ZY+Mb8ytI=;
	b=qv9uYLZQUXBDMno5BkFZq3lzd5FG/IG9BBTFab1c4hp6kg291VVpaokERo2Mh+DnmSGlbm
	C1X9JT5yKEKRPoc+H4VmqH+JT7ET4dMty2T/LTLHvDCxKgqTxboy7Yh8ip1WCi+HwKvq0P
	l5kBqwCXNd42RY2TlYYf39+2iYF+ZmI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Npbxi3pw;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773636255; a=rsa-sha256;
	cv=none;
	b=gLRVcOYpz1Mk9D8M/zBmB+PJ7BdHGG97oLR8N6ZSyGlAg8BzPmvxfNAd5A4vo061bFlrmn
	mz7ZAzZ8jPcyTN+Mv35dIfUUFnKrUWbU7fgsqwSW2QNFMAwnpLac+mu918UtUXHVR+cMgt
	249oib92lJY/7J03CGtrfprAu8Z5nro=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773636254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J+5vIvfueq6IMhLJl1sQj/A9x+kVAV9b++ZY+Mb8ytI=;
	b=Npbxi3pwrSZ44S+mETvVmLu4towuv5Bjcr4hgjfytdA/W7rS+WIyNFnlthAT/sniVF0UXt
	Jlpq8fCDcCR6BpCscZtDqU7GR2JTUtSkdAp8rJUiehGr8S7LmyGxBUbb4jCCoO+TBikSiS
	Fne8NpQZjqyZhrhAummAqmm9S75hVug=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-412-8OuO6jwKNUyHHMlH86adPw-1; Mon,
 16 Mar 2026 00:44:11 -0400
X-MC-Unique: 8OuO6jwKNUyHHMlH86adPw-1
X-Mimecast-MFC-AGG-ID: 8OuO6jwKNUyHHMlH86adPw_1773636248
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 93CBB180044D;
	Mon, 16 Mar 2026 04:44:08 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4D8881955E80;
	Mon, 16 Mar 2026 04:43:59 +0000 (UTC)
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
Subject: [PATCH v2 2/5] selftests/mm: soft-dirty: skip two tests when thp is not available
Date: Mon, 16 Mar 2026 12:43:32 +0800
Message-ID: <20260316044335.1390608-3-chuhu@redhat.com>
In-Reply-To: <20260316044335.1390608-1-chuhu@redhat.com>
References: <20260316044335.1390608-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: -n1t0NFuzj9B3hj-ENPJvI07LK6Kne7MDjE1fHqySPw_1773636248
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: 64A11C0005
X-Stat-Signature: x1ue79d94ftxccgbtyaaxz4gt9nsm3zz
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773636255-395061
X-HE-Meta: U2FsdGVkX19G1zgcyqMBrW9eJvTxmKKl0KaKViKWaw711QIiQh3h2ylaVez3Rd0ZAsEzq5zszyOQdcvE59wokHyKB201qsC3odbcZN5o+bwcljyZM8ZHOcF9LO57+VUdDUcf9hEsfFtAMWekZhUKGXd8Pw6P4jlyiGfhreywGou3gTGNWfK7sWsupTSdJ6BHtaj6Nbc6zsU+oxDWpSGxc9nU5OleX1FFwpM+DOi3RssViKaugSBb72nl78iE4zVwIkBp67HCGYWgwn2T0xR/9O+sqQqvRKgdfIyE3NbX+U9G1lU8np+ufzA8Unxhn5zNYWMSqpufociAzkJ2VY8BjvUptK9eofScFz3KG5QoJ30StZEWHQTX57k61uO4bCzL7oqjpkRQOfYUQ48sUslDVEVJ//++VNIfNkdsxJqtXTnaRurW9zD82sYIPhrf7B1rNa94lomnCogcO+6ms8jSu7xCCIaXzOKxG4a04aXjp6o4+YX2/Ynbjd+VTqHEDXh3ly5bod6nruIJjK4fa8ikkpw2Ce8d9PibBiKWWEiQs+uB6hmt7Yb8I2NlgoUrFBsY9VlTATRbFmfOYtybtOVXHfe7Ey2w+x+KQS1Ar7xx/IMDgOSZNY2+RuE+bIDZPwcVQma5YEh6Y98kgVKJZLRm8/3wE6GK1Q4Pzr8ivvNAqvEBXkxNwfO53JsgeAABwcl2GRX6TqGYzPYlmI64w0igUO8N4P6nBo4UEsLvKWGuxX1MhV6p68up0UM2m1pdvOZEqhsAwyjLYuivzHsMTh0JLoYscjqNBv6YREk3CimrjgAtlKgwWWnGfCXFzKHhQatXBP0z1jbRffTNH2cCbzonfIgKY4g+CGYJkB8g+jM3vTu2Kyo/IHDV+O1do2oMuEERpAnLcCEiDx/V6mHn1xVYkp2ZtamMamNkjuWbWXPr3gFHRpNtJlkdRxykovxfTNUPfD3n28MqdZe38TQR0eu
 i9JuyCcT
 vWDxr5NQ+NDuIXBjVUdjxccRoej6l7ojLbX7B1jiy7w3vtkqNHTt7AAFQB+kln9QV4jHJ/NDfB7/mRJRB398h1v/7U1qGCobeSHzA7fLydJsft5yijK8ADU/uSMGPh4tYOQKSa2pCCbqEAK8r/NAv7jC92dkky6oTaXyM3duG6wf3yYh63chdubZV3zAKJKzbiEdeVRY6Jl9ZIjEv9RkdNJ1Oe+6PSuKx17yG8p1rUubYrU44fOS0fa4ML1bte7WbXDM9aYKMjyhphsiGHHTq8Kt3OhZDRTS68ixXTc/URdp2cCa1Z0KonjMDV2ddos5AxGbCT4yQDe7MQPn7Bkr8rxqfc2skkKOsdTsYzbIrjA17SpoRTrRqfSBFhNFmpqTzPBUWNZOfzC4VWv0=
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

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
CC: Li Wang <liwang@redhat.com>
Signed-off-by: Chunyu Hu <chuhu@redhat.com>
---
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


