Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A03D3C61DB6
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 08:58:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8596B008A; Tue, 25 Aug 2026 04:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0686B008C; Tue, 25 Aug 2026 04:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ED566B0092; Tue, 25 Aug 2026 04:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8185B6B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 04:58:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0103A0338
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:58:57 +0000 (UTC)
X-FDA: 85139191914.30.CEAFC38
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id DA63740002
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:58:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787648336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=PRxtczeWQXbpr0x7hgXlJGQSVB9jbrQam9QiSSZqF6c=;
	b=4PWuhDlMXzy9ziK4savpIa3PAuqh2gdEF83CjxEkxxRBzHCGWCeIk5NfGyrlFRVhY3+TwV
	zZxVHEE0aCCrd/NmxSsOWbN1gSZ9vQnAx0Ax1hAVAmp+NmMloDb69PMbopF1nb2NOjfpiW
	sviT+0xyLhIRW/E5dA3j1/6rbXbQqsY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787648336;
	b=FRZJNCehZ3Aai9cc2gQ9DYNUpwWfi9LlBrkmb6e1NL3HHpM0r9y/B9zE4vb9cM31kJVB1x
	25QAV5/+07fOzD8KzJQ+58mVtgDQCCr3kE1gIooOeWUIj2wAE5W9QdJ8ZrfuM+vh6w3IEz
	yWv7BBs7JSBNeJIt/ydGHRyBNyI/myo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
X-UUID: 2d86fddea06311f19a56ed5b684f684d-20260825
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_TRUSTED, SRC_TRUSTED, DN_TRUSTED, SA_TRUSTED
	SA_EXISTED, SN_TRUSTED, SN_EXISTED, SPF_NOPASS, DKIM_NOPASS
	DMARC_NOPASS, CIE_BAD, CIE_GOOD, CIE_GOOD_SPF, GTI_FG_BS
	GTI_C_CI, GTI_FG_IT, GTI_RG_INFO, GTI_C_BU, AMN_T1
	AMN_GOOD, ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:df9ad7aa-906e-4814-9f3f-45fc084a67c9,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:df9ad7aa-906e-4814-9f3f-45fc084a67c9,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:6a7a5721c16a400f63271eb0392519bf,BulkI
	D:260825165848ITGJ0LFM,BulkQuantity:0,SF:17|19|38|66|78|102|127|865|898,TC
	:nil,Content:0|15|50,EDM:5,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2d86fddea06311f19a56ed5b684f684d-20260825
X-User: husong@kylinos.cn
Received: from ctao-book.. [(223.70.159.239)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 2114683762; Tue, 25 Aug 2026 16:58:45 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org,
	usama.anjum@arm.com
Cc: linux-mm@kvack.org,
	shuah@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterx@redhat.com,
	sarthak.sharma@arm.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH v4 0/3] selftests/mm: TAP output and global-state fixes
Date: Tue, 25 Aug 2026 16:57:53 +0800
Message-ID: <20260825085756.63030-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: gadnkznweuj6ussfc7s66bumte9nfa65
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DA63740002
X-HE-Tag: 1787648334-204618
X-HE-Meta: U2FsdGVkX19LMgS7e1Wfm1RYps33dRtxMG3KDJkEgpi+1Ss8efhkILjceecXkmaIRIPaP6dtfPPXnX5IVYZ5vnKiCO+ePueFVa6D0yAh/PWSuQLKPZsCQ4hMP4unoOYTkfzYjxerJvdFREN9HHFk1yGBImST+nEInZaAlqOuBAJV7WLQ8DafKl/zPPYpofKXMRnp5drT5t98dbD4mUNDDbDvlZGRwALb6GT3LR+fP/bZyw1jBzSC5WdTccVfuhT891JkMUd+35c8v5WCD2JnbU/iX9AW5PAfNocijX6P9Zy4Y7YXGpSZuf3GtxgFUNV0DClXJ3WtAY0R6xxBCWHyJkC9aeXvptLBleu/nKCK+1JKURXgIZsRDlZetTMODZKP0chk5k1EaWiXXJlG1KjWoqmXZ5PjIIgGJFcYEsu5ST4/WyzXYCpyhxI+iHqIeBTYKbFBudno7DLsRVMsQeTGJc0dbNqeCw+WMrfqz4TY3nj0xJJUS0gd0a9vYT/OONSMXEBHndVeLnC0emrzTv0zcZK6PyVItStj41wuT2V1QZytyPjoepckJbTwMtSMRifv1e/qgGnhT0EY7LKGK3GV37Mw+LnfYqzfR3qXluKfkOet4kj278foTc8HxJUjXg1WyMh3vyYMBQOSnPUszD9fE+IRnrmyqKJfIXmckt0mWGuYD98kuLuNGU8gWilWJe780qOlUAAoEjnNVI06iDaytP5qhvuWn0OYLHEc1bgIKOHgXeSlKvXhPJgZtSA56Y5X0G34O3SB5sir4N2OyD4HpfrB6kc2oGLBRuSl2zenjiflqZjRvOyjs5po5QYqRJJ88agZZRNEoTbWcrgbkjQrpe2R2B+HTPwxG9Fl1LvzGEMRbq/VogwG4z5BRB4mNw/LYYTpQEesXSxLb7rK1cOupVNa9rXI85p2miGXjsk+OfO5Bj3/ysN38LJjSj0wZvbq4RU43HhRhL0Zp69w0Jc
 oC8WunXj
 jvsYOZf2SJuG9AJuK7FMx7ECZ8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

uffd-wp-mremap and mremap_test never print the TAP header (and mremap_test
skips with a bare exit(KSFT_SKIP) rather than a KTAP skip), so their output
is not valid KTAP; hugetlb-soft-offline toggles enable_soft_offline during
the run and leaves it disabled afterwards.

Tested on x86_64.

Song Hu (3):
  selftests/mm: emit TAP header in uffd-wp-mremap
  selftests/mm: emit TAP header and use TAP skip in mremap_test
  selftests/mm: restore enable_soft_offline in hugetlb-soft-offline

 tools/testing/selftests/mm/hugetlb-soft-offline.c | 49 +++++++++++++----------
 tools/testing/selftests/mm/mremap_test.c          | 43 +++++++++++++---------
 tools/testing/selftests/mm/uffd-wp-mremap.c       |   2 +
 3 files changed, 55 insertions(+), 39 deletions(-)

---

Changes in v4, per review of v3 patch 3/3:

- hugetlb-soft-offline: the atexit restore handler no longer uses
  write_num(); on failure it re-enters exit() through
  ksft_exit_fail_msg(), undefined behavior from inside an atexit
  handler.  Restore with plain open()/write(), best effort.

Changes in v3, per Usama Anjum's review of v2 patch 2/3:

- mremap_test: cache mmap_min_addr in main() before ksft_set_plan(),
  so the skip paths in get_mmap_min_addr() are taken before the plan
  is set; a skip after the plan leaves the run with fewer tests than
  planned.

Changes in v2, per review feedback from Mike Rapoport, Sarthak Sharma and
the Sashiko AI review Andrew Morton pointed at:

- mremap_test: save errno before fclose() in get_mmap_min_addr() so
  strerror() reports the actual failure, and split the ksft_*() messages
  embedding "\n\t" so continuation lines get the "# " prefix.

- hugetlb-soft-offline: restore enable_soft_offline from an atexit()
  handler so it also runs on early exits, and use read_num()/write_num()
  from vm_util instead of the hand-rolled helpers.

v3: https://lore.kernel.org/all/20260820061426.356869-1-husong@kylinos.cn/
v2: https://lore.kernel.org/all/20260815080716.3596514-1-husong@kylinos.cn/
v1: https://lore.kernel.org/all/20260812120821.523860-1-husong@kylinos.cn/

