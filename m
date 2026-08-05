Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3AB6C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD39F6B007B; Wed,  5 Aug 2026 02:33:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83BD6B0088; Wed,  5 Aug 2026 02:33:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9757D6B00A9; Wed,  5 Aug 2026 02:33:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 68B3C6B007B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:33:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EB6F4403EA
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:33:46 +0000 (UTC)
X-FDA: 85066250052.03.4B51E89
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id B30D940007
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:33:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iBtLqhFB;
	spf=pass (imf27.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785911624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7mkcadJVmAqJI9buap6E5CxELlfihDwaquThutvKHd4=;
	b=MCor+cS5b8H9dqYxJdopd7ww6flvf7CBg08ig1Vt6AsdjAkm+BI/U3xLm4N8vrCiHI3wK8
	KdiXilWUniFWetwn9d9dA5kQ4LBFf59Uf4jNNCtZehm3HLM6pAwFJazm9CwqiyoEJnLMDe
	C3nuX+46G7rfm/yFI9+t2qmCnm9ytOo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=iBtLqhFB;
	spf=pass (imf27.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785911624;
	b=P9/h7KZZqB2cQOUT65vX5qQFDMRwuRVGvNiA/HpW5DQr8fcgMVU+x5zoBBpM1ePLmG+3uq
	ANIDusT4Tz6XJduztNUa1LH++Tc7Nz7M4Wqs/rARnqcglmcU/qtxpx6a/A44HM/7dEqJOm
	89+WpMqNgZFMwIcyUp6ZvYWOrlfcSJ0=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755mYMR2910700;
	Wed, 5 Aug 2026 06:28:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=7mkcadJVmAqJI9bua
	p6E5CxELlfihDwaquThutvKHd4=; b=iBtLqhFBgUmsk9kJLMFftzKOe75YexqsD
	YXuBsgZi9G5Qgm1zsshk5BcyA7kZMjYOJM9nI5MLQLeLYaJz+/xJUMyuCmBdDs+H
	xNuhNcptmzRo0Luoa7Bp3DFUpXVyQ0QQ0mCAdsy+TECeBLTUV0I024g8vXATeiL3
	IOKw9J6KiBRWsQ23xMZx0G4sUKsjQxMit/xFu2SAIDObi9fevvD926v/aVyNSrXT
	C7MX19drUWgihVc6G8BYBWVAQGS9BbUYS+B9lH3uscO5KXTQnZcRSCxoj2V8Pym0
	xQfWSo1U6QYS2dLXDuMDFfTJwU9+vdGc76x5euZ7tgEqMls0WOOkQ==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs77g99ka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:30 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QJdg026819;
	Wed, 5 Aug 2026 06:28:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswbgd4ja-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:30 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756SSBS37224742
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:28:28 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 37DD720043;
	Wed,  5 Aug 2026 06:28:28 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0F80020040;
	Wed,  5 Aug 2026 06:28:24 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:28:23 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Pankaj Raghav <pankaj.raghav@linux.dev>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH v3 01/11] fs: Add counter to track inflight writes that need stable pages
Date: Wed,  5 Aug 2026 11:58:07 +0530
Message-ID: <548c55490029490e68287aeae3d737454fa78e0e.1785908600.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1785908600.git.ojaswin@linux.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX15tpIh4spCjU
 AUcBnujClBo+DcVOKF9/a4d+yMeUkxJ5qnaJaksPvwrcCxrQG2PrxUfOZkSb175hfmMH5EDv3mZ
 6TB0NfHcB/uhQpMY/KDgI4lImdFaLPXDrzg21NL29ZHA8+6mLXywd92C70/k1QnReNU2QLgZz1Y
 rFZKLuwMuhNmDyu4Fd9qYAzIIyy3mH5un8k1r7rLF7y8i8Q0/ZmIBRYykn9jum0n6pdl/y1jxTo
 RFFt6T+3PRZA073j5H9eG1ONxb5kzClE75Es6hSXGN2BjL+G1nEk+Q/FENzNXbRLvoY5iFqumIU
 gQZnuSsijadoRJD8a6w9PyrNteQSD96TtuXzzVoJLUdKgyjeYW5mKyy/z7uJWa7gXN2FdZ/wUAP
 i1HePB3ul8Yt3q19raTo9oeNERTXwcVWc5CHf+n4QmTuG5dgZvUKz7+MV99tv3YImqSZHsq/2z9
 pgkruvU/V5NJrC04bKw==
X-Authority-Analysis: v=2.4 cv=WIFPmHsR c=1 sm=1 tr=0 ts=6a72d80f cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=8ZJD85kOQxw6bUDZt3oA:9
X-Proofpoint-GUID: p518RXZYhP7QoLVp4gaKCUOUg2x3O4co
X-Proofpoint-ORIG-GUID: eDeq56Fk8OMNwfiGb737VVWlvKkwja-m
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX1IpFCQCXKwec
 BBy1Jy/YmMXefn5MKSIRJo8UceAH/bW5AJGsBf0q8w9WjU+wzE0wEy0DlFSGg+lBdY4OAn2zrPv
 Vn7UQIPyqrutiackW3bN19yB7uOg26o=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0 malwarescore=0
 suspectscore=0 clxscore=1011 impostorscore=0 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050047
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B30D940007
X-Stat-Signature: 19pu3zo9hxgogc5urxr69ni3zbyp5r3g
X-HE-Tag: 1785911624-582706
X-HE-Meta: U2FsdGVkX1++2ML6j+IEZAb9sDk8UBkRY2DbwmnRqz8VNbVoUvPa++weftTATvYHXxa7uhlHwT7//pdoB6WZuIbNJlTPR/fmbtdqvSRaOTpPSb3AErFr0X7IRSg4vUS1KXogYG/Q/fa1+SvJOy9v4/wiUeJi9p7Jhd6EPaC1yImWXi6VIlpWica2u2V3EVzvCZgr5kHomKXYGs9Po9F4H43QuY51Wy1iBPTdgNXlFYVS3bIHK/ukcQii4kKVv3YoC3ge213kL624If2XJq+8X7WY8IZsalEblWjkNvLGBLHjUrXkbdMuEQbZi0rIiJnwd1RWaYSPeqi/KM5vulgRV2O1YPPQmCeNVENiN2387Dr8a6lVpmx3pa58wP6ylpizQTrTcHptNga7VCPcvgCqKKQ+3p/EqCCDtFn6g8DjisRzcONJJzVb+9T6j06/58vnEnk2g5CjHkeOVvTX+g5von+SFcnZTnRHJtBxMkgMLIsxHg/ShD1pHjNlydYIE9Er0ohNatTUi3/VB+g/9VYyz18UhXPycFELUO1qGV+gEFRXv6rwdIKHoVsPO8hcwPnAiZpFkP80IShZor36bp5Xyw3EXxCg38Rkea6+nmBXzKSaxoBFNFe9PzTEg+CzI8Olg5PzjLVBkQe/9XVMFcnKZOAGf3MYYado2X1vlK+IwitH4i2jPSye33zuZCAbTCoMIqQw4HxxACHP9MEXIuwxfD8+8KpiuxD0vlyiL0qmYGTYZqsRknMuLX5fp6CTidfm9mcPs0RlXywAf+CBdreUYGbd61HcJbv35xvRrUmMn0Xv3zNuyTDZ73afwLvTWZa9ZfTwKD6hcSvbdMIxrQzTEA/5eT+eWNbMbHF2lpohkCXyJle1MabL/eta5BbTupraWtVgsP0uXgH36WkhOP0ZsJiIQOhKS2dJuQ+FltqkeeiiJRCw7JY1xX2CsjGMTbluwML+22Dzq3FKsL/6OSL
 LgPVSxMZ
 Vs44yYvFemrcbWXRH5NX8+BYNAZlJJZUbHsk/QPFkTThn3JrjqXGCicPT0fSRqnqwqDN/5J6OLbl/wNwdkzk63eRZR6eme1PSpx3cWYtQUJyTUhl8i4FF70TphVAj0Mi9AqUUfZF/svaUIto6BXTglYrFF5ti30NtsSASCxD+LBZLbRkndJge+wGHlwp17r5KWIvVG1oi1CwOausZw4CpuHW8Ei/eT9det90G+fnpk5vneEcY6Y32+cnEXhrZ5XWRTH9UWjEImnGFfaxSN0OO6RAQSHMvgemu5x/EUWheoQdUx3OnayWU+dM0C2+86lvvsAX9VyYhA5i94B6Y/8wnhgtOutvPcvx/dE+OLUzicLvKvaYeZcauX/mW14LDqbedvi57PgGbKdZmP4M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current flag-style stable write implementation uses idempotent set
and clear functions. This is okay because the users for the most part
just want to set or clear it once based on factors like underlying
device support.

However, this scheme doesn't play well when we have parallel users
wanting to temporarily set and unset stable writes. For example, the
upcoming RWF_WRITETHROUGH patches need stable writes to be enabled for
the duration of the IO. The current scheme can lead to bugs like:

RWF_WRITETHROUGH write 1             RWF_WRITETHROUGH write 2

enable stable write		     enable stable write
submit IO
disable stable write   <---- WRONG

                                     submit IO
                                     disable stable write

The 2nd write loses the stable write guarantee midway which is not
correct. Fix this by introducing a new inflight_stable_write counter
which can be used by parallel users safely.

Unfortunately, due to the way the current users are designed, we cannot
directly migrate them to the counter approach hence for now we will
have to keep both methods till all the users adapt to the counters.

Suggested-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 include/linux/fs.h      |  1 +
 include/linux/pagemap.h | 14 +++++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8e9bc9dda0cb..5f17aa0ed4c7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -483,6 +483,7 @@ struct address_space {
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
 	struct rw_semaphore	i_mmap_rwsem;
+	atomic_t		inflight_stable_writes_count;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
 	 * On most architectures that alignment is already the case; but
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 2c3718d592d6..eb8b7e292478 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -306,7 +306,8 @@ static inline void mapping_clear_release_always(struct address_space *mapping)
 
 static inline bool mapping_stable_writes(const struct address_space *mapping)
 {
-	return test_bit(AS_STABLE_WRITES, &mapping->flags);
+	return test_bit(AS_STABLE_WRITES, &mapping->flags) ||
+	       atomic_read(&mapping->inflight_stable_writes_count) > 0;
 }
 
 static inline void mapping_set_stable_writes(struct address_space *mapping)
@@ -319,6 +320,17 @@ static inline void mapping_clear_stable_writes(struct address_space *mapping)
 	clear_bit(AS_STABLE_WRITES, &mapping->flags);
 }
 
+static inline void mapping_inc_inflight_stable_writes(struct address_space *mapping)
+{
+	atomic_inc(&mapping->inflight_stable_writes_count);
+}
+
+static inline void mapping_dec_inflight_stable_writes(struct address_space *mapping)
+{
+	WARN_ON_ONCE(atomic_read(&mapping->inflight_stable_writes_count) == 0);
+	atomic_dec_if_positive(&mapping->inflight_stable_writes_count);
+}
+
 static inline void mapping_set_inaccessible(struct address_space *mapping)
 {
 	/*
-- 
2.55.0


