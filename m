Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F53C55174
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 03:09:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ADFE6B009F; Wed,  5 Aug 2026 23:09:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E6E6B00A1; Wed,  5 Aug 2026 23:09:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FF0E6B00A2; Wed,  5 Aug 2026 23:09:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2CFE6B009F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 23:09:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B91F3140635
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:09:55 +0000 (UTC)
X-FDA: 85069365150.19.4F4EFF3
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1FE9D40009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:09:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I/t9pXER";
	spf=pass (imf07.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785985794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KGF1XPlazMbD3fvAciVTTzQZg9aiCV40zzqkVikGAHY=;
	b=6yzdJ/dFVUQrFfLm0IXvEnuPrQQo1oUjZTglA7n7EXtvzElxgzBXzHcuduWi3PZwu5zDsa
	y43PAB9xpBMAKq8XseCqtbFGTqIAKm4q0agx3vp09V5kva7DBMb/IvmTS1UMAFqFP9288W
	Z80WXKIQ8Frxich88C5WxysUuI0c4+w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785985794;
	b=ORTks/iYdjI+IJlIPZdOgv/wIV1Y+ytu5iK3lXXLk5Z68t7qLXUGqTAP+KNA1hn4RJK9qY
	M6gLuvxCx/SiW0Diip0V02UdIxtVT3YghkLcIpfhZmEbhHpJr1Iw5KH/XHDqIzDEpy6sy4
	SSejbpE0ojn67+XM+X8rfK55zCPTSW4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I/t9pXER";
	spf=pass (imf07.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785985792;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=KGF1XPlazMbD3fvAciVTTzQZg9aiCV40zzqkVikGAHY=;
	b=I/t9pXEROiekKx0lic6IfCmHNEMBjjof0TTv8RrvmVQZu8aw6ShxuroG5xT8jonEecTmAo
	plzq+OxAoiSzQtU7suOUncS8ZeGvVvsndDzw0Ru+mf2+x9B3eL5DZ063/zBnYXTxXI3bb2
	Yoy8yMK102BXhT2gcUqlX3M7+j2u9eo=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH v2] selftests/mm: Drop duplicate test_seal_mprotect_two_vma_with_gap() call
Date: Thu,  6 Aug 2026 11:08:50 +0800
Message-ID: <20260806030850.76077-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1FE9D40009
X-Stat-Signature: sd134wjs59phce358rxhbpak4gh8yxcz
X-HE-Tag: 1785985793-535847
X-HE-Meta: U2FsdGVkX18BoZP/rXKifZI4Hq9wQsbACcp8k+UZYxxGJAmNAkQdGhA10Y1We06JcS2ZprVI2uaK2HA0WzJbngkxp20M45Uqp5Ov7+WhZZRtYumlxDLXhyZImLzjgJBTFsXtcR8v4k2eWowTedUnd3MhwKcd3qNlhUHC6mSt5acPhNRZfKjeNcN0u69SvBUwKXUS8WDGPEj4ACbNJ2bSaEVJeDnUWwAFpSstHr/cQCTOiIvSv7T9jEWbJg6iHD8ACQhZEfs53hACcUrEDcMdjwqwZht0Wjo3sMm2hTmSdoH+rVczlQSRLLE8j3B9YWjiy8sNOSSPGwtytyGtc5JhSOa44mMp5emM9l1gqbu1cctNGST2o1+Vh9eh9FWQ6UFLFSnIO/7z2UzzjYB6cih0M0w1NPrsMkQ7es4+aViwwmhbLuN5WfeIBLr1nvrdzX/n181TB660G8UOdSUqXK7BPtplZYYzdWYCh0DQ1cOzoecLyXx3wLzNawui4LsBc7R0Gp+hBGsthG4ZROr3G8O3fPr/kBOZ4SkPj+9UIic9WbRz/EXbMAS+ff3XZCVTFnMfMCRmQPW2pFZ6rAB8vC0aJANRStL1en0PWBUcrO8F8Ay3eu4LbkgDyvXT2EmgHxZh4xG748+niU3pqnA6xGdcvbu+Ce9SyiTuJ/z8aawCF8sZzskYTmozf53VT3QW3XJqqZw8p3geTXs9b/bTtAdF1cYD0YZlkXemspgxRvuVP4IYuMXmgBlxowlAoTVHtDNFyzsjosxqezDLzPMyzowRau6Kp92EYjEwoTGbYQixWgrQ+j3VfVdVvjasO1nFq/SuiMUHSchDGujjoTiU9BBXGlr85I98TQ5QmGtwgptLB5jItJMdWpJEti1QKXmA/L4pyDMJ1vmyfKwXb37wyuO+IpgWj1P3l9q4V0xtoA5Q3DD168/6iHQfxpuwgnBpK5xXELN6/bLD2aHomk61MM7
 6P4N6V6k
 bSfE5z0bVXtZ0WIvmorVz9YlFsdP6uc+R0ocYNNLXQQGIrHkD9n+re+1XuZhtCf9ysHkfQmYWJmuFNS2SYzUDyux9XdoTJTftM5+mAtRMfNn6nVXnK4DW+ajvZa94g217iS5IaqNvQq4tIxNf4zWakMluSxlL8IpY+k67zw8F6v2qJT66sgiqWD7uUwMTxM4GrBa9WKoh8NXY0LZwYIPMu2tnNCXt7nszb/8kzP2ofuRNmL2oteUBqtyADxuXMy0TV7HCYofh5ylj5vgyGOUfH9N3pbnJhZITm7dPzpfcmmoPaHwxaB6kkphDwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

mseal_test main() invokes test_seal_mprotect_two_vma_with_gap() twice.
The second run repeats all assertions with no benefit. Drop the
duplicate call.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
v2:
- update ksft_set_plan(88) to 87 to match the actual number of tests
  after removing the duplicate call.
- Add Reviewed-by and Acked-by tags.
---
 tools/testing/selftests/mm/mseal_test.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
index 93c2e13094d4..1a05e6921fed 100644
--- a/tools/testing/selftests/mm/mseal_test.c
+++ b/tools/testing/selftests/mm/mseal_test.c
@@ -1876,7 +1876,7 @@ int main(void)
 	if (!pkey_supported())
 		ksft_print_msg("PKEY not supported\n");
 
-	ksft_set_plan(88);
+	ksft_set_plan(87);
 
 	test_seal_addseal();
 	test_seal_unmapped_start();
@@ -1913,7 +1913,6 @@ int main(void)
 	test_seal_mprotect_partial_mprotect(false);
 	test_seal_mprotect_partial_mprotect(true);
 
-	test_seal_mprotect_two_vma_with_gap();
 	test_seal_mprotect_two_vma_with_gap();
 
 	test_seal_mprotect_merge(false);
-- 
2.54.0


