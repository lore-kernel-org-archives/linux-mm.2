Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6527C5DF67
	for <linux-mm@archiver.kernel.org>; Sat, 15 Aug 2026 08:08:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63D296B0335; Sat, 15 Aug 2026 04:08:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EDA96B0419; Sat, 15 Aug 2026 04:08:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5039C6B07A5; Sat, 15 Aug 2026 04:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 328DD6B0335
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 04:08:04 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B414F802EB
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:08:03 +0000 (UTC)
X-FDA: 85102775646.03.E7B66B3
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8CAAB40005
	for <linux-mm@kvack.org>; Sat, 15 Aug 2026 08:07:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	spf=pass (imf01.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786781280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=eZ3eky4CdKlaR4NYj0xgEsNXaTyjnG8lBIMBecBowz4=;
	b=vwdyI2DGD6VS41+Kux3o2o93yJdmf+Aw+7J4AD9LFU2EsuKsSKyHI7DRgEd1SnUJKNGuUJ
	JYDEPRT2z/ucQ/0f9SSmAJGfgdXJfMdxWfiAuPOB4MsricJ+/JznipRFEjy7ACuyZF5GDr
	nkWaJhieH/qCRGxUBqIl42D1JFK2w2s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786781280;
	b=fmEzM5uOrUcsc2FJyWn8KAKr9uV+I4TUEGXNaMl8tJOxMG65ljxdkoPv8LigHN1gNX5VZr
	MIHyeopu9DUZZpL7AiRWAJd13U0hAuHZGM70X3jv9End0IIYEtyigkf7MEwyL8KaGYun22
	hymzgrqsu/pGLYMRKo1gBTg4luritgQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of husong@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=husong@kylinos.cn;
	dmarc=none
X-UUID: 67a3f494988011f19a56ed5b684f684d-20260815
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:65757eeb-3e3d-4b3f-8a9e-09c0f46a2b13,IP:10,
	URL:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:35
X-CID-INFO: VERSION:1.3.19,REQID:65757eeb-3e3d-4b3f-8a9e-09c0f46a2b13,IP:10,UR
	L:0,TC:0,Content:0,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:35
X-CID-META: VersionHash:7db8b62,CLOUDID:a0afd14ce99ee6cef1623ae023eb2c5c,BulkI
	D:260815160751QEPPXWOZ,BulkQuantity:0,SF:17|19|38|66|78|102|127|865|898,TC
	:nil,Content:0|15|50,EDM:5,IP:-2,URL:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,
	BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_FAS,TF_CID_SPAM_FSD,TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 67a3f494988011f19a56ed5b684f684d-20260815
X-User: husong@kylinos.cn
Received: from ctao-book.. [(111.162.215.50)] by mailgw.kylinos.cn
	(envelope-from <husong@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 9118596; Sat, 15 Aug 2026 16:07:48 +0800
From: Song Hu <husong@kylinos.cn>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	sarthak.sharma@arm.com
Cc: linux-mm@kvack.org,
	shuah@kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	peterx@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Song Hu <husong@kylinos.cn>
Subject: [PATCH v2 0/3] selftests/mm: TAP output and global-state fixes
Date: Sat, 15 Aug 2026 16:07:13 +0800
Message-ID: <20260815080716.3596514-1-husong@kylinos.cn>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jbdqhufmkecrtuffy5jfat8jdhztj18p
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8CAAB40005
X-HE-Tag: 1786781279-272224
X-HE-Meta: U2FsdGVkX1/SAkvTus50mMssxmUSPmkbn+g13kT3X+ehZhn8Us77KO9xo0xyM1gjuoBU1XgSf6IEv7+CCb8NXcUy2JK5Ah2th8omYv8OEHTYKMYNolOg6vmC7c4j0VaVFD5chIRsupF9Fvfev7zhPQeiwWd5jLsVkKSYyCmDChezYw7TTlpbyMmzJE/oyrHZJQOvL7QwgmC8CerOy4F3TpwJp/syu3P3rWqWlvEWyY7Xva/2bz0+pN9PFlumn/as5u1oWqNsZbeZ48P6897UyfRNMlnyy8opLexVw7nDl6npfd/RsKup5eQx04RqIQt9x7td688IXiFJIEMJH5gyU1lG74rrFYzAaxUH4ovQpCyvqyKrmuYFPRGpqO+KdLnvoWVJSihp2yhUONZNo9dtqDp6CE4Fl9F8EsbZeEyqTqp9eOmpSWkQJWoGjzhDkT7OFa0KaMBwc+tJ7fhNB1EElv0IRdmro2PKKx/P2iRH3fFBs4/Bj50M0XFrR67KneqCYqSkzszggXWiGdq2FiHoq0CjNv1xqY0NIe6G1exyKtkGSQp4XZX+72RCCvOBhXEfOJfcNVHSpa1m/WasawaPiZByGVDojujWDX929+fnS6W6/zmu9HzWc0J4voGpeL2FKAObFR8e/9znz7m+x3rtGigAOZ52QRJ/oRD6qItLgaVLu3ez6Zw63zNQUkYB6FuWMqdFTzHiAdzGiaSX90EBkLJ7XKyzAnuUc9iumQqHVzPMEiTOI3lnyOkaQq5MT/O88FyGyab282Bq+Fq6x9g6UTkAV7f/+/zfrNu/0HQOoh3mkDafm/r7OTtPzWZQSIZfK4JWA+j0tjx3hYNtI1oLAV21tPr1AWZXFUJxp0c9KcuM34M8zYRReut8Di4fEXoWAIChYeUQTI2BGQZ5vGcqq9uRT90m3SIM87G1qr1I7gX0g2VN1E9W3OsQ37ebVW/xV3Mf9OPs+mai7gW/nRj
 Eh3kyQux
 fz2rEKqiKqa0umW36zmi2LxXOaQ==
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

 .../selftests/mm/hugetlb-soft-offline.c       | 35 ++++++----------
 tools/testing/selftests/mm/mremap_test.c      | 41 +++++++++++--------
 tools/testing/selftests/mm/uffd-wp-mremap.c   |  2 +
 3 files changed, 37 insertions(+), 41 deletions(-)

---

Changes in v2, per review feedback from Mike Rapoport, Sarthak Sharma and
the Sashiko AI review Andrew Morton pointed at:

- mremap_test: save errno before fclose() in get_mmap_min_addr() so
  strerror() reports the actual failure, and split the ksft_*() messages
  embedding "\n\t" so continuation lines get the "# " prefix.

- hugetlb-soft-offline: restore enable_soft_offline from an atexit()
  handler so it also runs on early exits, and use read_num()/write_num()
  from vm_util instead of the hand-rolled helpers.

v1: https://lore.kernel.org/all/20260812120821.523860-1-husong@kylinos.cn/

-- 
2.43.0


