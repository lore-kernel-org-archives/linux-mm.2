Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE71F532C6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 01:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015326B0095; Mon, 23 Mar 2026 21:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F07576B0096; Mon, 23 Mar 2026 21:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0346B0098; Mon, 23 Mar 2026 21:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCA856B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 21:33:57 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C3435DBA9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:33:57 +0000 (UTC)
X-FDA: 84579235314.20.0DA3C47
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id B907A20003
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:33:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gM0W/0DR";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774316035; a=rsa-sha256;
	cv=none;
	b=moDEHp78BJy8v+lP2fRKM2UdW8N8U60k17gfjb1buR8TW0YL5+ixsJKh92NKofbzIxfcWp
	gdn3HVQU4aDsPfz7es4bskvDDoBn7bQSs0DsBr6UW8knYCRLxRBgs0Q3zhhIbYrOAyR70/
	g4tXHm2PNFxUO3VXlklFeDXZuuJOL8Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="gM0W/0DR";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of chuhu@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774316035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=AxreWY1mtjt8pLcZWDtUOTSTTJ2ooThjV6Z0OS/x7Za6iACqCQC8YnCoh1M1CTBYnS0zGL
	92TjMnaQgP8AV7EUVJzmw8IdGjn7R4Gww8JB8AudgtlYCpZM/wPjmzZokM5wKDL4H3+7+D
	f6QxBCkoqY/mgctOnwfkgs0v6nJNNnk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774316035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=gM0W/0DR3900AYSIW+VJnYiR3dblmjUBBntOyeTzmkNCIojlutgWWfI/CUAeodwQirq7ki
	4JdbiKUp4Vef6RzRpPyerKN/mRnoj1cLH6OJIq5X29A0pE8UerW3cWjpCYdAR6Aej3WoHH
	G1LHaj5sT4vAf6dfwRtjLjJzRmjptLE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-477-d-NZ9g62MeaErxAlxeuEcA-1; Mon,
 23 Mar 2026 21:33:51 -0400
X-MC-Unique: d-NZ9g62MeaErxAlxeuEcA-1
X-Mimecast-MFC-AGG-ID: d-NZ9g62MeaErxAlxeuEcA_1774316029
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1EAA419560B4;
	Tue, 24 Mar 2026 01:33:49 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E2DE180035F;
	Tue, 24 Mar 2026 01:33:40 +0000 (UTC)
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
Subject: [PATCH v6 2/6] selftests/mm: soft-dirty: skip two tests when thp is not available
Date: Tue, 24 Mar 2026 09:33:12 +0800
Message-ID: <20260324013316.2590422-3-chuhu@redhat.com>
In-Reply-To: <20260324013316.2590422-1-chuhu@redhat.com>
References: <20260324013316.2590422-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-MFC-PROC-ID: 14CEhkQ0gPgFeMqshlJ5IQH5ny1-dmBuE3X9u2PK3Zk_1774316029
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Stat-Signature: 46grs488br5w7yfzhxucniz9umq73rab
X-Rspamd-Queue-Id: B907A20003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774316035-228887
X-HE-Meta: U2FsdGVkX19EojqVd58rfkNUBX6nczvA7CEDHZrVJqw6tl9EYDT3+WJwqT1OmM3MEB7k10St3JjSvcI4hzrLdMDGigafZ1V1h7AwTCqR9bG0ZBFz71kYW8EGYJ+LnefIcbDKM33LW9nDFaceHmu3aFfnJcAi+wc3/vkr2iNyhw8w/SznMiKtXiBPyFqBpTtTaaE549vyX5HoyJR1VHm2PTkhyvaCpj0LUvvwgaBRuMyF+u4ZAd5hLAHWBaLjhcUUinn34qrNiELZZT/Dn2n/1AHglGt+hGKxizRafhFkfutwD5hjwfmVWhS9KnF/34wymixrdk2BZo6FffkUc0IU8C8EYPdRu15HY/H421PScLMiuENkE3jF5pdg8859xE2zEkfPhCehycVoNiDL6sKUGFpwdScCEKUEalWSoJtByGEFU1V/NWAQsq0+/kbNiMpMnZaOybvcDNGpq2psT/2VH+ZgOuXzFjDGeeDj5rFpmhVkiHE/QN9B/26TjT08vbMCeeV2ctLt5XFeXm/t2Cxv7S/9fjDEJH+mI+48F2c5iBAw9pQhV4fzILlQfV442pkVAS1guxtBU9mbbjlZcT4a2bGLS7ao+oDf8SV5z5zvonwgJtINFltH5PrwZsxZMxYmoG7TPJQ7LhBfS3mc6xuvG3xrSKkOdNgFlzqs5++T9ZGUNQddNJijaF13mICAfi2ZhbYThSh5OCWxP7JRB8nXTlWpN5/NiOufQlZyiG+lzeffqVQUk/URMkzJPPRyJPF1CafUKs0S5b1CQoJA2sIxFsJQXqab6y2dgOY1gDCEKVm6yJn7GqsVpn8wVrlFQoMhSkb2SUPMn36FZWx3tMFc6rkw5AIb+XwY2tEIO9JvcN/dk+xdPxGaJGlR2nyv5ZryDQ8A4PH9gFcrio43mJlj54n6vrep6BYbJIH3FDtzgb0CHljsbzNRinMX7iXv0K9Knr3eR5KQS5Jfjy0qgeV
 cGSZagAh
 Ff7U4IWl+mih6oSpHzCsCcdNzRg==
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


