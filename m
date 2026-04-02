Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30E55111224B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 01:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7E26B008A; Wed,  1 Apr 2026 21:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF496B008C; Wed,  1 Apr 2026 21:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E58B6B0092; Wed,  1 Apr 2026 21:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E54B6B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 21:46:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA7A8B857E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:24 +0000 (UTC)
X-FDA: 84611925888.29.D01CA02
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id C8D7C180003
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 01:46:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I9zX92Oe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775094382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=Xgzu3hFnfgmCCEn0nKv6D+JX4h0CE/kPovvqtPo9q7HyC4O6m7K3nzyRov0g0rrPjc6W+2
	tzup5Zhim3hL4VGCuS47BNcHfaXxipleyAop+AEJeYgt5WmGjHU0XY2M5oFilzGLO44pXe
	qiRj31r8cNGEtRp5h5F9AJgB+ZfHJrs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775094382; a=rsa-sha256;
	cv=none;
	b=UVhaMBiYONz4qlnRbsMYicayXVFTiK3Y7NpB969UCOZDEMZbDbcgUAmYqyasWse9HiovIV
	/3gw8aZSSWPUo9WuKUqZtfdPNW2CBjaFHztGH8i/WSjyhpYSJ5BUWSXzZeYHIdD3hVvtCH
	qBWQCwPnH9lNmCGmnI1zG3h3YX0Y8SY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=I9zX92Oe;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of chuhu@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=chuhu@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775094382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n94zkV/pmZZJ7k7RKaGT+ic/vcFa4MFeGtug2QtIPI4=;
	b=I9zX92OeWpfYV1YcAAQSxusL3PRh7catSqPSL1s1yQWZUzz6rk1ac+DG/Ywl37SiuWrrk6
	Igob1gb89GlULFlenRpk25/HHL89lPiSJnWMmFpbeufJAzkeGmADyPbgFSUOp/dqkezCa+
	F4t2EexKIw5elYozZmp7TAutuscPdrc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-502-NNDtiJKwNi2izcF6TcqZvA-1; Wed,
 01 Apr 2026 21:46:17 -0400
X-MC-Unique: NNDtiJKwNi2izcF6TcqZvA-1
X-Mimecast-MFC-AGG-ID: NNDtiJKwNi2izcF6TcqZvA_1775094375
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CA7F61956096;
	Thu,  2 Apr 2026 01:46:14 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 666D519560AB;
	Thu,  2 Apr 2026 01:46:06 +0000 (UTC)
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
Subject: [PATCH v8 2/6] selftests/mm: soft-dirty: skip two tests when thp is not available
Date: Thu,  2 Apr 2026 09:45:39 +0800
Message-ID: <20260402014543.1671131-3-chuhu@redhat.com>
In-Reply-To: <20260402014543.1671131-1-chuhu@redhat.com>
References: <20260402014543.1671131-1-chuhu@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: YAP2qLcqdfWAEVAcXpGusaLwwGwyikqMbyce1LH0b2k_1775094375
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: C8D7C180003
X-Stat-Signature: 8y6e4q433be4hd8pdbfensxg3aka41fi
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775094382-289181
X-HE-Meta: U2FsdGVkX19R+HisaGEVaNLdArNeKfPhCSd/fAzPqNp8Wma3FlGGj8BexLkTJTxgRG5DYYE/oY75Gf0sBt+8HHydelDy3VlVjBtoz4eLKCSEMS3ZlgqELzhgXRRKVTOmigTdq0NCdW1n1MPhZZk7dz680lIj6IVyMXtPaO2y3lWOHU/wa9pu9mtsnCfg2c3x48xTku2Xy6dzj/Bz+B26T2ssJQ4dVmpBhaJEwsV7ZSjmIb6Vpxi437kp0R7GU5fvtZkK+Pbo/ulxr72qf4cTpZMtX4KD7q6T/BygwUeKaJ+jCcXDiTTp2Ba2TakKY0kE4rSgSH7nnvHK1OkFf/ir88GUk3OnD1zUjgiL2tSmZDQR00UmaPqj0EH5bBHduaW2kHJMkPeyQ/tnR1QkpEy1Tcxxe7aZhP7loO1IkcQ+JbVVl8LvvsOm+fHi45N53gO8YyCHgwR4toE3nryW01Z8L2noRY7KqRyJA7+BERY4ewpWyAWbUkKLwr4fgxsJFn7kJGFoGpKSTrpT1KBoETCbE2nnr/k31liFLwVOt1dL96dvZOS8MLov+x29/C+9WFxfzuUnDdvpxKkuUscaMdlw4NmGlK2vXvMK3rmTVgbMKG9xvX12QyJ8VlPN04SwweoYI3isZA1ORMkPg9uhNVg1YjbWW6O99D3aE4yUcAzvlV3P2A2TRZ1XcwP0CedVop+YUYCsRMFY6qciu/84pwTDn1X5NdbRJTUj7bCwVXFkED6tnOI9KgOf6y/VbUcyScwv5waVJjncgZN6X447Xx2i8V2mm+c33dyBcEuII713q3H8iq+OpN3KZuCOrJjWt4Quy/kbM8YnqdC6TC9m62ZXGTrynONZtKggyu63jfD5HFgemQoL9ULkIGL+PmvZECsmx0JbgeTnz2sVvaYWr7Ra3fWsjqbLHdAHFvVZZsGyYKAo6aGgBcrhyj29k0UcaUpwzK2O8LKDieQKTHGUdSu
 XoNlGFfY
 ar84k35XjX2vBh20rWcWeBOjQCsWJ3pCL700jFPLwd7m1GXb9T5cAh54BA/GNrKdPWodcIFKAT65aMhjybM4tWD6+e3oN5j3J+CEoMQLRjkbmx0kKVRTLFRACZpXOlnW1bNkBctfhEcS/Ch70huX6lu7Luqx0LSCH9GYP68lTrxJ5M2TS5j2et1SgHGHPj1EjshQQqr+yua3TkbGhytvdf54GG0xH0ZcaOCRObaI6xXlto/PyOCVNFXbWdPF3bnGpR2kTcYeurK3EmGHQXyXhETOmmufkrzeUsgUBfU0rTLg8PJ1GlPE+ZsSl3p7f2YNOV0AMA/L6Zv/9pajKKXtwdYL9f1roYnz+HlA/dEH7/4WMYBshiurT62U94gYfKs2rcwV9tg8h9u9G91c=
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


