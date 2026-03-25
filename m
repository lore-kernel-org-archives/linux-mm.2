Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9C69103A9BD
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 11:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E01A6B009E; Wed, 25 Mar 2026 07:42:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7256B009F; Wed, 25 Mar 2026 07:42:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CDEF6B00A0; Wed, 25 Mar 2026 07:42:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F340D6B009E
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 07:42:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A68988C58F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:42:03 +0000 (UTC)
X-FDA: 84584396526.23.45D9545
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id B856980008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 11:42:01 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DdlYQ2KD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774438921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7bSf5cwWFar7KW8N8pfBbamm44tOftgAlBkgIGyLuo=;
	b=z7hpzUSXPNCVtANkmLmISz39vtZ9hWaLckViu1tjRGwiLFiT/GI2ukPomIbiaHBkHKu6pA
	7wFPnA82mh5+aGJ75PiNCjFpJf029LGEjR1FhwihmT3ql5tLEcu5pXyuPkx8JgsmHGX3hl
	hjAer56BZ/vf1XfuFnx4GnY+laSCYys=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774438921; a=rsa-sha256;
	cv=none;
	b=kz9GB7tVkdLyZniFrjVHkfho6njsZ9A55MfM9S5DgROkNxgsFwL7XmG9qoBsECAFhAtSRs
	fXW86RtQ7e24uZ8m86yy9yWGMYgy/LW3KPai+u9YLaZ93TjgcEs4n1JHYsiTL7Pp6y4eWa
	eBE5uqJxFEUxAEiuuhT5ojxzSZ5qtPk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DdlYQ2KD;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774438921;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v7bSf5cwWFar7KW8N8pfBbamm44tOftgAlBkgIGyLuo=;
	b=DdlYQ2KDX3n+WAWqFY1JfpEGRD5wJl2zplSgYPy3wd7gYVf2UpInFkO/t3r0Gm90IIyRyJ
	XiCrUhDJ2oxQSL4kstC/C8WIo0vu/Trc2r0VMH0xf95XxzXJrHg1G07byb7g4BCSq5G/7r
	8jx3TjIUiOMVGpdxTMOiL51Aowz7igs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-651-rH7ah-jYNXqBYCaLPRGvaw-1; Wed,
 25 Mar 2026 07:41:56 -0400
X-MC-Unique: rH7ah-jYNXqBYCaLPRGvaw-1
X-Mimecast-MFC-AGG-ID: rH7ah-jYNXqBYCaLPRGvaw_1774438911
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9378D195608C;
	Wed, 25 Mar 2026 11:41:50 +0000 (UTC)
Received: from p1.redhat.com (unknown [10.2.14.4])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E28C91800361;
	Wed, 25 Mar 2026 11:41:32 +0000 (UTC)
From: Nico Pache <npache@redhat.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jackmanb@google.com,
	jack@suse.cz,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	Liam.Howlett@oracle.com,
	lorenzo.stoakes@oracle.com,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	npache@redhat.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: [PATCH mm-unstable v4 3/5] mm/khugepaged: define KHUGEPAGED_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
Date: Wed, 25 Mar 2026 05:40:20 -0600
Message-ID: <20260325114022.444081-4-npache@redhat.com>
In-Reply-To: <20260325114022.444081-1-npache@redhat.com>
References: <20260325114022.444081-1-npache@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Dg_fiMnvs2MK6x3HXVR6kOPdm8fDDCtUyXAVnjk0o6U_1774438911
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Queue-Id: B856980008
X-Stat-Signature: ory5ze94gopyhhmydfdthb1upbdgtwgw
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774438921-788660
X-HE-Meta: U2FsdGVkX1+tYrOSE7KEgII1QyE3IO3cx9GcoRxyhEjslzk64M/KcLtXanmMxJnsHoUD9d0UynHUIKypdgPiA+2PuPbJrS4Z89/M1pr2Whz3PLUAZPrfXcic8I5KyOmpGDujnrA78oc3kgncWirwpby30BWdihOzAiiBr9VBE/r918sn3rEByEefNgx+jrZFycwKDLCmDhjb/PzQNE2HteBNWSqhyEgt25MslxSeuaO3FGBLChCUvimtThgXRvLa6fHNZ37z6Ukr4nNLUGnUcbFyvKavWZA3ZvtGkECsdRolnK6QOdx5jJ1OwwbCW9iO+WGGnYX7Mrcyz7bh7xhg6zPHRV52TUr1zR+E8GnP5gmEvek3tEpreosAxUyny7tHFrxOrqVEdUKm23MSAkN78o+/RfcaqcnNj4kHY0ZHjPF7ytzRTw2INZ7MrfXD/Me3jZpBSmEUA/tCprJ+QvgYfTZ4/oLEcWUkXfdbGIcC1H7qUhDBddl9jBRGuKucWa7Rmq8sUqsm6amSc9TGxysqKAogMGiu8XejQNMTx2g+NOVf/ocBITWQlsyIffb0ITiTpgYol45WdT8OOX47FojYMErteeUEpNzV9kvjLe0wS2pH8kQ8gYB76u7uaylaqcBcbVuc0O5pxMMLCCn76l9Ei4uhMJZmGbtazm81GGbfW6SEQKIvYMXY5wyclKOY4EiwkredlPvWVUkquv8d4HKCl8/X/tbkT+Sm0oDos7bDz4cUcLBZKl9DYDpR/4NrH9UAWTkUQ7rQ0/Yc3e+BIVoPsPjqJ7LgspMyW63Z5Xr4P6OizeJy0b/aN+mPJX4fHOkqvpikcqX4sMMX/ETO/p2pBLu/jM4p5530dH4nzXCQ+0pwhD9EZRFVbAgPijWjMLalcCZrzFuzebl0JZ3gSRVN9JhdNDtjY7G0RfSlmb5NaQ3C5vDRWAy57Imu4EHHrsglHFLxXbolh3k8r/fJoyz
 B3q2yvfw
 C3EthIRuGNf8x702fJn0VfW0aL5uw6EtnH++8aP/8XWX0bf2lNzWlvOxx5Z4FKFTIRckFl+LknFr/MNA3qLLwDPpJWL7P4DxWQXbPaEHI55usy0TnsZ6ODnaacnfbCwkB0BrzNfB/cEe/HZV+HnqLAY2RwNZYMkv7yFETIu9pACUI8mGpjduZiPxaCYpIi2H/1oV5h1s7lm4fVM8ra4l03RAGMGTk2E6MqtbrwH5Jt1vMHSo8a+3fCxTQbpXBce7p9o6CaNPRfNxJAPHk9dc5AA/i7MhHNQGeY3z7pasRVa/HkqnSC3q5lBTL06FMujf3DkYt8dTxn368sptyhconVasWc15AjnVjITUvFaQ/dLAYOZAItt1xHHwQo4dRboNHcOLhAr4a3QFYGXa0l8OYy6jvqe5I91T0urj1li/xH1VNtiVsJ/CX2JHm/hdRpPkBaOHWq01L8cl/eCVwurJIJhKrI+9QRS7lK4idWkDKaT8Of0L4FYV9NArFHNUewOn5X0JXdaMWXZ9jnmJ9EAle4hdFvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
signify the limit of the max_ptes_* values. Add a define for this to
increase code readability and reuse.

Acked-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Suggested-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Nico Pache <npache@redhat.com>
---
 mm/khugepaged.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 1f4609761294..c9c17bfccf0d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -89,6 +89,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
  *
  * Note that these are only respected if collapse was initiated by khugepaged.
  */
+#define KHUGEPAGED_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
 unsigned int khugepaged_max_ptes_none __read_mostly;
 static unsigned int khugepaged_max_ptes_swap __read_mostly;
 static unsigned int khugepaged_max_ptes_shared __read_mostly;
@@ -259,7 +260,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
 	unsigned long max_ptes_none;
 
 	err = kstrtoul(buf, 10, &max_ptes_none);
-	if (err || max_ptes_none > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_none > KHUGEPAGED_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_none = max_ptes_none;
@@ -284,7 +285,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
 	unsigned long max_ptes_swap;
 
 	err  = kstrtoul(buf, 10, &max_ptes_swap);
-	if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_swap > KHUGEPAGED_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_swap = max_ptes_swap;
@@ -310,7 +311,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
 	unsigned long max_ptes_shared;
 
 	err  = kstrtoul(buf, 10, &max_ptes_shared);
-	if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
+	if (err || max_ptes_shared > KHUGEPAGED_MAX_PTES_LIMIT)
 		return -EINVAL;
 
 	khugepaged_max_ptes_shared = max_ptes_shared;
@@ -382,7 +383,7 @@ int __init khugepaged_init(void)
 		return -ENOMEM;
 
 	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
-	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
+	khugepaged_max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
 	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
 	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
 
-- 
2.53.0


