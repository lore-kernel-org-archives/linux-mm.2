Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4243CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 02:11:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 299476B008A; Tue,  9 Jun 2026 22:11:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270486B008C; Tue,  9 Jun 2026 22:11:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15F726B0092; Tue,  9 Jun 2026 22:11:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 036F66B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 22:11:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A90411407C5
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:11:40 +0000 (UTC)
X-FDA: 84862376760.13.54D0F5E
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	by imf14.hostedemail.com (Postfix) with ESMTP id BB283100002
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:11:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=c2g3JD5A;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf14.hostedemail.com: domain of chenyichong@uniontech.com designates 54.204.34.129 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781057498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IVSAXr3MVUuIvyQwhDMWEDoA0VCM2OOBNmbT/fX15ZM=;
	b=clUfPSTQHebCMtgeG9Qyq9fVvQS6JMwZZB2gQl4yzT83w+rHhe1PqKrKYlueowDmtWGaWl
	bOcgNkwprbA4qpJS4J6N0DYy1vUam1wGiCDAN8h/w/o+0vEB/v4KWnrrHrqOIs3cIIkFOu
	Jdnx1Tlx4iWJew/4p8Yr4AAE50QvriY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=uniontech.com header.s=onoh2408 header.b=c2g3JD5A;
	dmarc=pass (policy=none) header.from=uniontech.com;
	spf=pass (imf14.hostedemail.com: domain of chenyichong@uniontech.com designates 54.204.34.129 as permitted sender) smtp.mailfrom=chenyichong@uniontech.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781057498;
	b=YDmr4ebKbxI+uqRPaUmmPbtb+7ZSwGIFSSammqUDCK/eOufDJrcGbIXPKXR12hffHPkCsz
	TwX/rhny3Seb6iRqq41Jsx0bwftOUPToIu5GZIpF1lvgYwZ4RAGOwmUbwE7RhjvkMFpJ1i
	SBRs6d1aPyttBfyPLL1HT/MUMMQBQRg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1781057492;
	bh=IVSAXr3MVUuIvyQwhDMWEDoA0VCM2OOBNmbT/fX15ZM=;
	h=From:To:Subject:Date:Message-ID:MIME-Version;
	b=c2g3JD5ADekPpK/isoyNXDE19XRrbY5VqjFMP02LaMDUY87wjoI3ZDJ7P1ufGNG6f
	 BiFb8e+eCgJB2UzPIAfB6zAA/8e6tINOCy5puFnG1J6tt+LnKs9flN+crSzUPuXCR+
	 vqZTah21KrmlpGP5KG67VzFjrLiuAScI53WHay5U=
X-QQ-mid: zesmtpgz5t1781057477t84f1543c
X-QQ-Originating-IP: 77ArkWXT4jANmxzP+zcN0Xg6IIggm0KvJLEK0dOynPQ=
Received: from Shurima ( [113.57.152.160])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 10 Jun 2026 10:11:15 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15137944461439253450
EX-QQ-RecipientCnt: 4
From: chenyichong <chenyichong@uniontech.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	chenyichong <chenyichong@uniontech.com>
Subject: [PATCH] tools/mm/page_owner_sort: free per-record allocations
Date: Wed, 10 Jun 2026 10:11:08 +0800
Message-ID: <D7AC1314C01DD894+20260610021109.132538-1-chenyichong@uniontech.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrgz:qybglogicsvrgz3a-0
X-QQ-XMAILINFO: N2K7JO7TcIoEJCwugUhsgR0sp9dBpocDHWke+jbT2VWQia0n3Exm0kHm
	luwS74gHwUMY6IOx4KBNDV4f16lV6Y6+ZCaOUx/uqXz8mfvAEHYp3lnj0y9A0/pBRVrvlVK
	s6zSUl46j2/MlrEibzY8+sM/uW0hpXT5n3H2rBnzTIcXX7mPuM85VQAIzpAHpc0zSFUlc4L
	pAL8QAzopdwjuA7QDcvFvnvj3o7+DMzdh3e5eKwr+r2lOGq27wydfDb7dx5O+OHDR7LjMGh
	pwcnMGMpRWxzfg4e8j834u4PBwnn1mjNvTpCGwiA/RxP0nDv/TIeqSam8BFzmnS2nllIPhv
	v5RKMSemP7NrxEoLsA5uummP3sE+3G64zHPggy8274HrGqBXPeD8OzskKRc649iedojhIk0
	LVl+gUPNw3ZJ24qXZFXjXSIjFrgKOIEWYo5L847zaacpE8eknqW0dkszzB/t9IyvXC9fPDH
	oCsXJHhw/mqlnX3Ethr9xuIkjWKfdmtjFz4j795Gl2UGzUVmeCtGDhzwxnod+bcJzT12ZLi
	1FvUv5csiGePkbYuapSyOvuylwQ2fRMFpJYDQ5ErtfjxmG2vWglPoWDqbSUkGAEMvaFTiEx
	g6pGK96dvRTF3NoBIAt3X6bqg1tJjTy9NOuWPlyHX7tSt+dTC4jtIQTY90SAXA4Ueji3R2+
	9B1Aa/FfX1kXhJ639VUMBa7nDCTHUyJj07doV/RbQAzCVdCNdqMHQB3ooeXlzA+xJew43aj
	VkGFUkFvMNT8NubscwYPzr8OuPH57/i+BlLvVN8T6A9GcJW99rlLu3rJg0/8dZMSpIgTF6q
	83wvD+mFEF17ia/48AI8KHU5kkKr4968F26SVp0Rc8Zujkp7As9AMTqspx8SOnBH4prvtqK
	JWn4wJqmmdvgWEQe3ETbqmHmkYEffe5ESAmdgFGoMy2RoFP1iROOPPxqqrudEjeuvZXRYSX
	NDfhh8DdSUnbUZecaEyjwioK113ztO608frxkdIfjWlvMdvuDRUZ0EkCm1LQVtp669vmDXV
	H6ij9x1g==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
X-QQ-RECHKSPAM: 0
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 5efqdfpk7xd6k8b6oysmke7qrstspoie
X-Rspamd-Queue-Id: BB283100002
X-HE-Tag: 1781057495-117154
X-HE-Meta: U2FsdGVkX19xbisl734OpTQ3w6yoiiWQS0Q4zouxqJq7ncRPrd9jpl4iUGQG4eziOo6bTc8n9rAdurfuflhIfbXfMkV/ed4Fp42F8+Vkb7SeEEnt0U54l+YEt3oRtaMaHxlL7ma/exQFps1NsVNf4z0vf7Mv6Asmlvi0brKGfABJ3ZXiATRyhTrW2ra8LwIkUt42fMvgrE71v8i9S70EVBTbjvfPKxa2mkBZj4Bfsl01UTNGpGEZmRhhz0rEAHB/Pe3U/vPaEzDF8hJYYEpu9f5rcV/aDLamKJ6KobHr17l1v61oGwvfWAh4VDjQf+DwEHDRajnq4Bu18iTcyG6B5XWqp+i30myUidtW+7JM6iXy/U+n1KfjvvEgPY4aUSrfMlXlVHVsEGITWoXoUP1yjLEzLYj6Vp0IzCaTCK3PdYzCqpCgm2ut/JksGDvLb8bWGyP5v9lhnDVwFpTHjDaV3gXdX19bbFaDifeDhvWiL6hVvL13AOzmggK7eGio72h220Ffemcf1SlX2AC37EXVO88N/Zv8fhkvzLAycJ8uvZVEm6B7LoF257iQD69KPw8XhJzh7jp4g9HBJbDYPevj1QHTpgJ8aZEPyeXFEIqgDknygBb0kebF4A510k0PtJcRaTl5d/QjerbKGbD4yOrS5Grzsvo9pX4T1xv8Hmjho6179HMFLKlmw/0il4zBCEvw16vg1GHyrheB2+AboZQLW7bmoh2J+YJrnkgA3K9XPqdMhIpH7pd0fDAY73PTbRokSDZwAYJBdCeLDdcKqzYrItxDllCKcNQcH4bEQ6Pxu+Excepajv3rvM5K16O+wZAbDU/H2IExICItCnrCdl38aUfWSX3nvUOjgAyym/cRoo6g/cVQGsHxU1ucV15aZS9kOHb/xWzB1kO5izcSE49u2z+ML5Ddg8SBo6OaKb5w9+/JuwiegVC+yYxg5w/zquy3DrXCSHwesS+/WgGwkeV
 NAfkB1ek
 O5v62VOpPXyspafXM5SptJ2QqGTdGH8H/gF+nQobu/kTmM6H0xns41DPPCG/FVSe/SjIyys6GVpNxseczezNDnSksnMTPLte9nOs1MNXlFso97uiG/3BlTNzbFb6PUcFqPqvOStYCszl4Z91GPjVtBMBE7dPTc5O4kFKWAj51ynDmlUbJ7haFmhcxN0iB12hasKexVVZWjV71Bu9jWURiEdqXRss72R7s6PjzkrbwaDfPGmEqxWtbQ8YcbhxoFF7Sv2mVsRPUDbW1jmJhonL/Esqk0IywaeSdy5/tFQqCZ9UPiEb6mK1qY02k9aS/bMIfrJfMJIYWEH8AXnVuMnPu8MKUUTmfDuYEX9m/+7P/AccZXkWNHKixtDccOaToNSh6cbxeynbdi/yT/Js=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

add_list() allocates a command name and text buffer for every page owner record.  The cleanup path only frees the outer list array, leaving both allocations for every retained record behind until process exit.

Records discarded while culling also lose their allocation references when the list is compacted.  Free those records as they are merged, track the compacted list size, and release the remaining per-record allocations on exit.  Also handle allocation failures in get_comm() and unwind the command name if allocating the text buffer fails.

Signed-off-by: chenyichong <chenyichong@uniontech.com>
---
 tools/mm/page_owner_sort.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index e6954909401c..67a7fc6d9de2 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -372,6 +372,9 @@ static char *get_comm(char *buf)
 {
 	char *comm_str = malloc(TASK_COMM_LEN);
 
+	if (!comm_str)
+		return NULL;
+
 	memset(comm_str, 0, TASK_COMM_LEN);
 
 	search_pattern(&comm_pattern, comm_str, buf);
@@ -386,6 +389,12 @@ static char *get_comm(char *buf)
 	return comm_str;
 }
 
+static void free_block_list(struct block_list *block)
+{
+	free(block->comm);
+	free(block->txt);
+}
+
 static int get_arg_type(const char *arg)
 {
 	if (!strcmp(arg, "pid") || !strcmp(arg, "p"))
@@ -480,9 +489,15 @@ static bool add_list(char *buf, int len, char *ext_buf)
 	list[list_size].pid = get_pid(buf);
 	list[list_size].tgid = get_tgid(buf);
 	list[list_size].comm = get_comm(buf);
+	if (!list[list_size].comm) {
+		fprintf(stderr, "Out of memory\n");
+		return false;
+	}
 	list[list_size].txt = malloc(len+1);
 	if (!list[list_size].txt) {
 		fprintf(stderr, "Out of memory\n");
+		free(list[list_size].comm);
+		list[list_size].comm = NULL;
 		return false;
 	}
 	memcpy(list[list_size].txt, buf, len);
@@ -841,8 +856,10 @@ int main(int argc, char **argv)
 		} else {
 			list[count-1].num += list[i].num;
 			list[count-1].page_num += list[i].page_num;
+			free_block_list(&list[i]);
 		}
 	}
+	list_size = count;
 
 	qsort(list, count, sizeof(list[0]), compare_sort_condition);
 
@@ -876,8 +893,11 @@ int main(int argc, char **argv)
 		free(ext_buf);
 	if (buf)
 		free(buf);
-	if (list)
+	if (list) {
+		for (i = 0; i < list_size; i++)
+			free_block_list(&list[i]);
 		free(list);
+	}
 out_ts:
 	regfree(&ts_nsec_pattern);
 out_comm:
-- 
2.51.0


