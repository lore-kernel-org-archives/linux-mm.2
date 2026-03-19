Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7608109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:07:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BF996B0528; Thu, 19 Mar 2026 12:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 596A66B052A; Thu, 19 Mar 2026 12:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ACCC6B052B; Thu, 19 Mar 2026 12:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38BFF6B0528
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:07:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F07E21606BF
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:07:36 +0000 (UTC)
X-FDA: 84563292912.24.F2EFF2A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id F3079C0014
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:07:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S+hJMJQf;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773936455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=7sjva6z3XQTm9hd/W/nDKr98F4xFjg8P+nwiTILqTJ+UvwCjS9MM5O+DGlhsXR4ze1tZww
	Y5CrOXdOAVEf5xCsL3Htkr+ogtP59Cpseqy+51oMUs6oAlGrHLLEe/DGOaxWIzd9piDbYd
	cXF+PhEi1Bsnm3NBXYd0s5SNEQArdos=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S+hJMJQf;
	spf=pass (imf28.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773936455; a=rsa-sha256;
	cv=none;
	b=y9PU7FTSY+8nEnigYdomZTvhU86r3oMW+dTEPRY/rRpwbM1umVx/UjiUcO7ZVjvjmDkm+N
	2gsscW/J+qCI0VrPaCoxCDb/SINJYIfxG3Obtfecgia5LjTFcFMxjHDZZdb0L7C1KQQKZo
	RVZr1PChZ3ehdXec1F59dQSe66YbCK8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773936454;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=S+hJMJQfJgjwIa/pG6nAUpC0HalLzhm1iqhS8yM52meVoFhJfILzBAvUR0bUmL8QYaY9pR
	sJsOv85bxyy7erRHGLqzD2RO2CMjLk95LnYxdmQsqu9P8waHL1Ijb1sScxIC/cPRBk85V7
	rVATcgwTY/x3nn3EJnWEox0chi9uKWs=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-404-hS2BsEMWO-C18kfasiHIsA-1; Thu,
 19 Mar 2026 12:07:30 -0400
X-MC-Unique: hS2BsEMWO-C18kfasiHIsA-1
X-Mimecast-MFC-AGG-ID: hS2BsEMWO-C18kfasiHIsA_1773936448
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5D9AF18002E9;
	Thu, 19 Mar 2026 16:07:27 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3DAD430001A1;
	Thu, 19 Mar 2026 16:07:18 +0000 (UTC)
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
Subject: [PATCH v4 2/5] selftests/mm: soft-dirty: skip two tests when thp is not available
Date: Fri, 20 Mar 2026 00:06:53 +0800
Message-ID: <20260319160656.1480279-3-chuhu@redhat.com>
In-Reply-To: <20260319160656.1480279-1-chuhu@redhat.com>
References: <20260319160656.1480279-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: XSPQyOU_b68nsO3Q9LIXXdfaIAqxGqTlKbZoTTdQ6gM_1773936448
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F3079C0014
X-Stat-Signature: b8aajsormkwyota9sain4qbg4h4xaemq
X-Rspam-User: 
X-HE-Tag: 1773936454-362729
X-HE-Meta: U2FsdGVkX19pYf4pWoFPygxBB7qYHFqxTP2oGr+TGbi9Q5q1GM/2Lr8KHcYUS8Ni1VTl61cG+RlfwZ5wGXpW7QnRthTY6zNiJ8BVri6LhVGOuPQOX0IuBlqtMA7EVcTwwCvN1S6aiXW7YUzW21cQo+hGBNgVsZPGFMTNmsjnnHOdodGyaLIDI0FUX0g3iK3psoDlPbQPfo4yhKiBKzPx0YxmigAhfU/UQwRqNI0IefhEffji2lDXNGs9ANm49kCUy/sBzwkNjFqPHe4gHZdkis7oW4Krg2lFvFKG1zqoVghDo1CHJHl7xztOA8Z9nUKqDhlLrsivLqPbNSlCPjg4EqhsqDxJdH2z96Yz6y6uU6SIKyWWIZVWNCg0sJdBCdNwlCm2ZAC7DIQunQK5RvGryKMwGIR/6czOBoVRiJgaW9ppfqtX4PlOyNR+c0yVTz/Jne/iTbNJMoyKspFspi+pcY82WrJh0x2QDJNmszuYalGSG52xehD1DyES3DP1JuuqUVUXQJTBE1zVav1UIbqSRKwa01NA3MNummguxmJnTVx2R4Dazm40AUiOd04jKZKy1KnpT8q8RDDdudE+h24UetNa/lWWq5MKMItVEkk7a/HXdpEdfRgOCz+glnuqFQPHjvKKFDQL0ios0xpAqW9BBoac3/FA4MLVDW02ivtBXrxEW1pftFtoyfsERCb5DM9F/bdWvYMci9bZxiMjgiJOnXnXuvVd1912lJ7oc22IRosa636j/geqC+OO+yDIxyuBky4Z9Y6l92ND5os3xNgpjligle8xLV/hfqIJ0EQMBVD1EJhZDY1Qy4pIuxRAf4JLyBQ/CnJ8T4eHLVjS8Rr3XSOfr6YU8hoeAWLzVxFfmk7jXupe/sfEIihKcys/wZHephc/pISlCGyE5tBqOmX43/nvg+et/hsjmidM2UF6RNXEPuqDwMaLlbiHUd5bG8BzqaqQneQRZBhL+h7CDp/
 iSyZ88zV
 u0Vjk9xwyAyp/rlnS5wYZv5wRVrrdU6G+04HYnQ26Arj7+Jt6/QGSFw7M9scpnQ34wNlIojZkZSKjvpMiyRrMH90mv10VbmlamdK0QxpHVi2CQKX8plkjndunjygOK2h2Chgka/7ZU8sVXmhqDVw2ypunTWHUcijc1AO/3/RrInu8l9vO2TEZEJxEFnqN+qyNt64tgLdh8xk7bisFUFtaAqGPyvN7wYvM/5+H76x1t1XQ0egYxnEaPLvqNM3+mDk13kiStFImu0/6gsKIO2sTyrOMiA90f42CQW+M1Xz854z+yF2v4qXvZSwNHRkdGB3iq8ukOQzpjbSmphOrTj2nKgYZms7HgN/R7mDsOoXONQQUOdWIxP8rKVG3ISAXXF+K5Pz3h/vCUHy1EFI=
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


