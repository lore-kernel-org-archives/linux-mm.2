Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68176CA0EEB
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 01:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DBD26B00BD; Tue, 19 Aug 2025 21:05:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28C196B00BE; Tue, 19 Aug 2025 21:05:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17AEB6B00BF; Tue, 19 Aug 2025 21:05:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 03EEA6B00BD
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 21:05:20 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9F53B8099
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:19 +0000 (UTC)
X-FDA: 83795342358.15.C913A8F
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by imf10.hostedemail.com (Postfix) with ESMTP id A6B0FC0010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 01:05:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FvMDBI9D;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755651917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Le2GADmgFKn9Yb9MtlR8f8swzH8vtb/n0jwBJSbLGNY=;
	b=W8mONJ9jWgWGE8ZY4SNhkCfEqwqatUV0u/8sNcjKRxExykbHqbLllt686MtTvtBrdkUYBX
	Ozrm+bnuerDGJ7ES83+08OQe0fNGFj36ivWxnxIw0eAE96Rt3NQ9kUXamNAQf69QYWd5lR
	XV/aHWwhBMuvlRaOqGWdf6aFQPlAmfc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=oracle.com header.s=corp-2025-04-25 header.b=FvMDBI9D;
	dmarc=pass (policy=reject) header.from=oracle.com;
	spf=pass (imf10.hostedemail.com: domain of anthony.yznaga@oracle.com designates 205.220.165.32 as permitted sender) smtp.mailfrom=anthony.yznaga@oracle.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755651917; a=rsa-sha256;
	cv=none;
	b=yimFMe5h9YXo5DX94KzSTFwLkTgx+wbKnkxAKxiXOuSwZ/E5JfwF4mKpe5v53vlIl9wl8O
	fDokggguaJ9O3hcdgb1pfeq9LlbzemCMkadQFbV1nmYmDXtPv1g5zy7+7bT6vd80SDiaHa
	ovE7zydgyO63fnYfCMlj3Mf8AF/3w5Q=
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57JLCDGl005682;
	Wed, 20 Aug 2025 01:04:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=Le2GA
	DmgFKn9Yb9MtlR8f8swzH8vtb/n0jwBJSbLGNY=; b=FvMDBI9DGn0QkQHCginz8
	JbM8/Snb0kT2s6rR5PMiJDyK2AoCK07lLecZQ7VhaW1YhjzRPi5guRmKtc+mcHTi
	Vti1+elCNJGbIjKSvvvYeqWEX2xk94TfJUpaHZ/Ni60CDgFhmHxdAZgotykkiAAL
	ym/r2YMgrLPOg/rVVpvHXihsla/+IwF/ACw4hMAfBWU5oq14YoALRLB29kkpr4Yp
	MEShVeN1tNQWcGk1rQ8FrsAv65IS3WheB8PR8yfJocniIHsmvn2hLwSH8tc5M5cH
	6on04DsFYToJRPVu6JzzHTiLvlFfQT8dD4/XLiposr/yzWOfPeKznCk4T55Pf1o8
	Q==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48n0ts88gm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:52 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57JNkhLF007278;
	Wed, 20 Aug 2025 01:04:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48my3q29x2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 Aug 2025 01:04:51 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57K14NdO011685;
	Wed, 20 Aug 2025 01:04:50 GMT
Received: from localhost.localdomain (ca-dev60.us.oracle.com [10.129.136.27])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 48my3q29gw-11;
	Wed, 20 Aug 2025 01:04:50 +0000
From: Anthony Yznaga <anthony.yznaga@oracle.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, arnd@arndb.de,
        bp@alien8.de, brauner@kernel.org, bsegall@google.com, corbet@lwn.net,
        dave.hansen@linux.intel.com, david@redhat.com,
        dietmar.eggemann@arm.com, ebiederm@xmission.com, hpa@zytor.com,
        jakub.wartak@mailbox.org, jannh@google.com, juri.lelli@redhat.com,
        khalid@kernel.org, liam.howlett@oracle.com, linyongting@bytedance.com,
        lorenzo.stoakes@oracle.com, luto@kernel.org, markhemm@googlemail.com,
        maz@kernel.org, mhiramat@kernel.org, mgorman@suse.de, mhocko@suse.com,
        mingo@redhat.com, muchun.song@linux.dev, neilb@suse.de,
        osalvador@suse.de, pcc@google.com, peterz@infradead.org,
        pfalcato@suse.de, rostedt@goodmis.org, rppt@kernel.org,
        shakeel.butt@linux.dev, surenb@google.com, tglx@linutronix.de,
        vasily.averin@linux.dev, vbabka@suse.cz, vincent.guittot@linaro.org,
        viro@zeniv.linux.org.uk, vschneid@redhat.com, willy@infradead.org,
        x86@kernel.org, xhao@linux.alibaba.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: [PATCH v3 10/22] mm: add mmap_read_lock_killable_nested()
Date: Tue, 19 Aug 2025 18:04:03 -0700
Message-ID: <20250820010415.699353-11-anthony.yznaga@oracle.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250820010415.699353-1-anthony.yznaga@oracle.com>
References: <20250820010415.699353-1-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_04,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508200007
X-Proofpoint-GUID: IzMLS54QSyw4yb-w04wcug_DzS4oYxWb
X-Proofpoint-ORIG-GUID: IzMLS54QSyw4yb-w04wcug_DzS4oYxWb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDE5NyBTYWx0ZWRfXzFr7NCmWGcQS
 r6rWahbigH3tL3T2O4uUCawj1dnQ3YVLiaOroZl7zfVWUl5LBE9KSlBE1ejgxittoxyvG9/B5DK
 abA9GKMkwf4CP6bOw/uol16+0UuSfR+ubY+/NHmpTE18vRI+Mpb6ELG95jHs1lJVYTi+ZU73DBu
 VqVSO27e8ing7RpCBDzZEYh2COHHyseisJ27FHlES28cTKh6FDZfTcempDS2io8M0JUcTpuXr19
 1PJZVxAU1CNqPeAid+nwydmffWHGTh/8DJe2gf00z6GvCr8u4cEMmh35FeKXGAYyVerL5CzvUD1
 X4uM3+0g8pXvnTteXhIcMqZC2+UNIDwDl9tVuGiqi/+qtikWg8nR6zvlhq1xoY77rJeQv/OvM4S
 AWJev3h51X4zWyTVhu2KzJWh9PpFeg==
X-Authority-Analysis: v=2.4 cv=HKOa1otv c=1 sm=1 tr=0 ts=68a51f34 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=2OwXVqhp2XgA:10 a=yPCof4ZbAAAA:8 a=c3nol8fVUP3th71kQ2MA:9
 a=UhEZJTgQB8St2RibIkdl:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22 a=QOGEsqRv6VhmHaoFNykA:22
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A6B0FC0010
X-Stat-Signature: tqoy5ghimf5s346no8sx5wqqe9fy7np1
X-Rspam-User: 
X-HE-Tag: 1755651917-287524
X-HE-Meta: U2FsdGVkX18HkLpj7v2NYnPhZomZNl1+VpR3U9a1aZ/UU9X4ryMPZWWbK8RMFMXlMbvIyd1qPesFE12AJeZIe7rDo6BmUvymM/5KGjYb9vbTd7C5q1sGWMIkpeKe5pQZbDRqUwWIwAV9rt+i5MB7bqZ/eA7CwwkainDZ+c6USP9nzvdPQy6OysH8HKCqV41BzjbEqc79vh9CjInDRTr/pxwZcGheU5t8aKhndUsTm6SOEhnnN8xFsZiDor42Mp3Jow+lgjj5ZRoQCbh9NBpjMqkUQqlFA+0meRuTcE1l+Jgi2z01FDNvr2TCOkowdsmLK0b9AUaJNl2YQMmbDc7oowynHpg4MheNcEFWnKwGObR3N0ez3zLw2i8Uy34yQqo0+yXiekmQxnHIeXKiEvTdMrsqj9wZqFcT1yDzMgdJbpJXBFQkVRq+GS8RX1XTtDH6Ocl46yZc1+IN4oTo8szWVWvjw1f8zsSmOi9NH9ILAFOK6/GslTw5L7Qwoo/hOHz/1QaNFHqmW3C68KHmOhKJp4JkvgMk1U+cvpYJA6m/U69OMeu8rPV/qbWTwR/1pPkvCml+LDGyj5Q+I6lnXBgmhS4/GmKS6CEN9B+X0sCEhaZ0wbwKv1XHB23I3jr3BXwKEiIG7Z1Kcav0QTA+6vUgS5WC72hBQriNufAuW2SXl9l/Qurd7P8RN3RX9NnnGr1AkbdyH3KLjBiqAl2a5+3UFNx9v0tTCvmbC6u0PthagqEjT17MpbreyMZ4ECt2BbPLCrpCkSBVV/te+iO9DY8prsH6G4m45UyO3YyfvkkANAqeblLgNDxn8KNS0zfgQazrw/Tcwmq7wmr+uG1lXzApEu3fluJ3htfQBaeqiMquXmPa8JyxZdgrbN4vrkkvVZ0dhZ57fStaSluIIzrJFSfRGS/jLK5CS+p4lCYF4Kyqv/SJzItODR41He6+EJsTiU10hZYmZK7hfcuixtRWREa
 AdayRTZu
 z8fichhid90E9xyy9usu0prYXLCzfUw3LnO8U2fKuWGQfdAz2SCOiM2Ai1mrpQq8bJ/1b8ZVC8faYZZ9ip9ui0WVCX1QK90+uXePLe3NUeFSE3GeoPZVJZ1ZVqG4B6yhagNt1MoC92cTQmbgmEQNw+JOr4pKDpeke47iMYQE2Ytf6stGSTlCqrlyyBjXMsyBGDXgt0b/1G8CeFk9Z+7cjUZEnNFhF1eupxsU5KU2ZGnvePU9kOCIVs+u/aSObXlHOwUNTT+6rEd1iR1LE2lWOTaJOPvH9hUSn37AvQ4uEjkhUKghSN6u0RdOxfwtd6LCpJW1t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This will be used to support mshare functionality where the read
lock on an mshare host mm is taken while holding the lock on a
process mm.

Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
---
 include/linux/mmap_lock.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 2c9fffa58714..3cf7219306a1 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -369,6 +369,13 @@ static inline void mmap_read_lock(struct mm_struct *mm)
 	__mmap_lock_trace_acquire_returned(mm, false, true);
 }
 
+static inline void mmap_read_lock_nested(struct mm_struct *mm, int subclass)
+{
+	__mmap_lock_trace_start_locking(mm, false);
+	down_read_nested(&mm->mmap_lock, subclass);
+	__mmap_lock_trace_acquire_returned(mm, false, true);
+}
+
 static inline int mmap_read_lock_killable(struct mm_struct *mm)
 {
 	int ret;
-- 
2.47.1


