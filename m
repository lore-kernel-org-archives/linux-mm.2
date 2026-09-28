Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4B04CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07616B0093; Mon, 28 Sep 2026 08:03:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB7DC6B0095; Mon, 28 Sep 2026 08:03:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA5216B0096; Mon, 28 Sep 2026 08:03:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A60E36B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:03:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 39B9C1201AF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:03:49 +0000 (UTC)
X-FDA: 85263036978.15.429CD0B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf02.hostedemail.com (Postfix) with ESMTP id C29D68000E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:03:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nF08+hDG;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf02.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uI+Z0hK0OBfp+hyRvhDzQTGCIiYiIAwSOozSGuYrXfU=;
	b=M4foLYFzLsbuUeyeZ+W9WP9N7w/6f0gMmdrDD0abO0gfoLHozotgmkwVMbGF1hXQJ/nDjz
	N4k+f2wYTXsKAfV6DiJrOoWQayuoaHLwiTHSYusiZCHL1QdFbvGYBbX2vqThiWC2yHYJUV
	Jw3NIxnTR36wTxT/0QJoCVf1RaeaWPI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nF08+hDG;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf02.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597026;
	b=oMqz6BXNN2b2IaQ69lvDNB86CHaoy5MJowJRUTDZVqEdGBcu5EE6mu3mlr/ibabiJTUzDo
	njomcKbaZxxHSHjqVzV6lrdMqHdvt6unNzi0Mw9FlOQUSdSTcZdkoBBQruTmUuYVf9ZY7o
	74aG+UPHZ2h5sKSNDPuwUgeiLuEM42E=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZWJZ1047068;
	Mon, 28 Sep 2026 12:03:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=uI+Z0hK0OBfp+hyRv
	hDzQTGCIiYiIAwSOozSGuYrXfU=; b=nF08+hDGvQ/yhammcvlFIypVlWkZ++Qge
	7kwt11X9S2V9MfWYl2NPesmXxirgFyMDezLctQLpHEK6zAWtftVgXE/uWmuV4p6V
	nDqg8AVX8+6msF3gw1tCCvpJfwh4EX+pWqtbrpNbpcbf5U760geK+xw/yJYV1BcD
	S6QI5Lvlt6Py9UbKTvmwUQH6nzSHf7QzqkPM0/3b0cSBiHIrgFQKN6iYmgARRaMb
	Wj6xdmGXN7Kj3BtMMnPfaoX6U03ywQXIDhx8uYC+RJobKZIHoDzjG0oVraBlD5c0
	GT8qKBs1k1vpgNnK9tcIYskz+rLLhoKtSOe4XKZaG64dkbr7p/xiw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5j5165j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:34 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHYRK2943219;
	Mon, 28 Sep 2026 12:03:34 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxtkg4wnw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:33 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC3WG623855644
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:03:32 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 04CF320043;
	Mon, 28 Sep 2026 12:03:32 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A13620040;
	Mon, 28 Sep 2026 12:03:26 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:03:25 +0000 (GMT)
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
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: [RFC PATCH v4 02/12] fs: Add counter to track inflight writes that need stable pages
Date: Mon, 28 Sep 2026 17:33:03 +0530
Message-ID: <47a1741edc8db3753d3b555a75a7fd65f2996049.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX4vMnNb9Gk1iw
 XGdSgpZtcHwgrMsubD+qn5ukuzIpizGZRFWmk/qrs2D/L+5MaJC+YA5sOfWgq2Bt1PiNMQsaWTN
 n7y3JLlCSUsTh7J4zgs0xWFgoidtrzU=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfXxeM5QY2s8mTq
 iP3T0PRCbtogr1V9YnzN6LbwIzJ3o06Uk1ghV+7bsxm1YhtEBWsrTmoLnPDmGQwQFrqN+RpJZOV
 dlnUCMDBPjh4/96yAdi4/ABHz5yqckmnWoeYHUaR3oF88vFG1QKH+TNXDhQEJ1VaPwfeI5I0ZzR
 lddFuMptipmpv3xxOD11mkj/gAhqWC7ZJb3d8hOWY0zZgFAaMcAZO1b1lJTQNN/yjSnbnHA1n97
 vKPdpdMc/B1bKUpNeiiSptZ0j5gB3YkejIzExkMg6rPUsI/I7oZDMzVDz7ooqsQqlHIPZNC8vn8
 yV8mI7p4LyK6K3Bpq2BAijYXxU/VsBWK/NyW9Jdhm1r/rejiNXHLq8OnuvyVeCvacUBKGNAI4gQ
 6K9gi8Ih1tXYO09a31tguJQ/5r0UpdM77MUcl+mh0rUbT1Yc3sd1bHaOnel7v+6CVWlb9vZXu8r
 RTKDDiQ7FhfkCfx/EhA==
X-Proofpoint-GUID: bHLH0MBQtnRql-B3-nWJvcQeoiUdvUV_
X-Authority-Analysis: v=2.4 cv=RKcmjIi+ c=1 sm=1 tr=0 ts=6aba5797 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=8ZJD85kOQxw6bUDZt3oA:9
X-Proofpoint-ORIG-GUID: DhONHsxxA81g4bm8wfruo0OdmbIyX9sn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 spamscore=0 bulkscore=0 impostorscore=0
 adultscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609280046
X-Rspam-User: 
X-Stat-Signature: gkd839jb8kmdez54qwj3r1bim39gnsb9
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C29D68000E
X-HE-Tag: 1790597026-813448
X-HE-Meta: U2FsdGVkX1/dmJW6uHO03Yvpxo8tSIC+ZSduIU58eotrnFehvsxgtnA4zq8wO+s5mbRTfNfrOxgf9pxpy+Uim4hJajEh/6X+dXpYUeqfO4K7+OQBQ3T+wuEQzipTiwmB1uSijCs6eNGDTcu9A9rwlvEUyMD2oNti9fiuYke3UqsjOMpu0fzA+yHEBb7r8Lvm7avx7e6geBbURIhgaoK67kmL094PxsIsIsRQwOs9OGlTRHW949YLkIvr9mmjvySd7Zp0KlSD0h4J2XeIvESOarXHOycOahThWsmt72/5MskkzpyHuDbjQ2mp4mKEwhBqB00SaJ7pfZKM13oW+gC0haFTXfArXqcS432X2cmUhKsy+uaqKIuPYwr0a8yor+c1B4nMFI8wNoWhwv37EUf0F/uQpnbTkl++dNHto6qcdIjPbwCNcn/RXsU4APatndcFoLMf+yxpot11vvR8PT6FkPSSbUgIrwJCcX0/VZ6U7+Y7Gnpz+cB6Mz561E4RU3OS7EYKbntDIH0mSJ9fISI/Ykrd69SHQGZolTRxqre5Q+ocUIwRtZIxQhj1a//XMlptAxp1aJU4aGA5FBlbDF6vx55jklq3xUs//quenD5nP67M8ZaUof5xsbJuD+F1IJSLGLQ26NL8ESMfVmvUZYV//+4+8NBFss3IYqNhR3JcAgiaw7jy/dinDyGK7u9mSOC/Ei2uQ/YjWoYpeLUMocjG+e+ZCr82vddYF7k42V9c+8Fs36DfGKwqWJhxU/YmM7WsQhSvfrQg6ZnUoAlT8BMWbC4uthCPolpOa9AJg/PG0EmKqBSnd3RMC5xK9oLgaXLY896PRI7hlPhj1m83i7oG50k6epac/MmKh08Brx0IlkJtgNmxsFbaiBG9wtrrQBd57NBiXf9mi3uvQ7fHfz2RYufepCaMzTCWljy7IZOh2UYyYi6c5sIlXBf5XDaYKS3i2JXBqQtjQVS1u+pTRAz
 ZEyUc7IT
 pKChnfhdUrCjR0CiwLTce9w/toDmGj43KxJSxjqsU0txQJYQwBxr7KOTyKMj4tUgX0hSl5fxVzYV21RDEGPky5GSRw90TwOBL1wxSFN4mXENdmlW2r5JOy9tO4MbD+pT97bHDcJpMhZnUSc1Lwrr24tI0siHzbzyYkfF5Hb4YkJhgwhu3GuFKPm05XZGehjIhSqregaDlCky4exeVyGROBj4PwsiT77qgzJE03JmuF/3SmQagk0C68UD2fBJbedvhYqr1P8Jll8KMiX4Au10XaNifASlNCG2SicPS14hvBX3lINVIH63BJWuQrnlEw6abQtKpFQ9v0Awc9oik+bvzwF/x7qvirBy9/3aMPS6xZ8P7fJjHNVu+Eci0vKKargx8olAwSAQKu8lFed8=
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
index 05d05bb9c951..f196f25255ab 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -482,6 +482,7 @@ struct address_space {
 	errseq_t		wb_err;
 	spinlock_t		i_private_lock;
 	struct rw_semaphore	i_mmap_rwsem;
+	atomic_t		inflight_stable_writes_count;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
 	 * On most architectures that alignment is already the case; but
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..59713769f731 100644
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
+	WARN_ON_ONCE(atomic_dec_if_positive(
+			     &mapping->inflight_stable_writes_count) < 0);
+}
+
 static inline void mapping_set_inaccessible(struct address_space *mapping)
 {
 	/*
-- 
2.55.0


