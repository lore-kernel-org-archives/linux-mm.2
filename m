Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25284C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 06:29:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A556B0095; Wed,  5 Aug 2026 02:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411CA6B0096; Wed,  5 Aug 2026 02:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300CE6B0098; Wed,  5 Aug 2026 02:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03FFF6B0095
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 02:28:58 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 832808037E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:28:58 +0000 (UTC)
X-FDA: 85066237956.09.055103A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf18.hostedemail.com (Postfix) with ESMTP id 27F561C0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:28:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="s1jB/175";
	spf=pass (imf18.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785911336;
	b=dPKn9PC/XwEq23LRhrfMSvhl9Yzvhk4FJAGTeFxSBqxzKXoJ3zi095V11uwDQJHCbYCt09
	1JUpXAObXLs9pqSQBG/xJIZ47VpCF/IiMcQ/hp1pqceDapP50RWVQx+fS+PCamYB4nHmiP
	ktUToA55v00BUjlcA1dT1h8jb3kAB20=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="s1jB/175";
	spf=pass (imf18.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785911336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4gSdh3sr2ycHT3EukmQjBtk1Q919hgqEMrec8njc2Dw=;
	b=kksNLHTq1Ad2tVGQSCAhjqenGLUzBm+RUtOaBvGOjyC7BTGIpj3IVVqVaofcHO0nMT3WY4
	Nu6UFU0snFMKn2BkyjJDjTSZG4ACwUoBQd3daoDA0poUQT+4wkX8UjiFzL2RZ10X1mHnAe
	o/+PbnqSLM/USamgm3Le7cWranBw9PE=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755lvoP1121612;
	Wed, 5 Aug 2026 06:28:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=4gSdh3sr2ycHT3Euk
	mQjBtk1Q919hgqEMrec8njc2Dw=; b=s1jB/175e8VH2EsR9qoQ8dSt6XYww+ZWR
	eOkZJSN45KgYml+6R3cLj4t8dJqIqV0KjSl3M+36YTJS9ZqvCpHi8ouzCGdk0yrG
	RI+7gRuQLYwQ0W3UdAlxxjpHDLj7sNsv0FjcdrE9uP8QAjO8Kob2HTeJmLLBCIpT
	KmgZ5OdVJ45hzK8C69o9ZmDfH4WCqLtNygAi1nsgCPvNEwgo5cq/RT+KgAVZ+0ps
	vJlqRfS6259CU6M3egXpNyyxon8FTHvoW8cYGy3V8W+KcvxMPJnalWdUMl1pBhY9
	0qxi1bxh6uYMFIaWSZsPiWbOHXn/y+eDaIkeSX+ty9ZNFOL77M2Vw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8fqsj8h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:42 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QHSD010639;
	Wed, 5 Aug 2026 06:28:41 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsugw5ee6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:41 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756Sds531457622
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:28:39 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F07072004B;
	Wed,  5 Aug 2026 06:28:38 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6D66920040;
	Wed,  5 Aug 2026 06:28:33 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:28:33 +0000 (GMT)
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
Subject: [RFC PATCH v3 03/11] iomap: Add helper to revert iomap iter
Date: Wed,  5 Aug 2026 11:58:09 +0530
Message-ID: <c688c9ccbe13fda329d2bfcd423d5d38ec9ac561.1785908600.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1785908600.git.ojaswin@linux.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: LonUA8QG8JHck5z9DjLFdbCjPxe3fRjO
X-Proofpoint-ORIG-GUID: HQc6MlCSscsYcwTphpnZSkOKguor5Xs-
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX/rVMYMlnGX9p
 nT8eKbRD1ttQw7DughHsM3iPyZLw/hfH+Is0CFRzdoSFJpYpBhK9emmwkrhNhl2nJsN1K759f+z
 Nr+R9Z3JjkQQUm1LgwKRJJnjxSMrnNU=
X-Authority-Analysis: v=2.4 cv=K8cS2SWI c=1 sm=1 tr=0 ts=6a72d81b cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=EiUwcbAk3iOqCFawNVEA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX10VcwEXMqktr
 +S/UFnL70GiUKVXlYY0cCvozuvypPIJgBCHxjhDCDbIZhMm/a93vKQb28I7oPh5tS4SA8f4xH1Q
 DF8f4jd47DRQCLvsAxONfFpKvqjBk/voYjW02yljWfssblg5yXlCrKtP/mcAJnkRWtfRayJsKQs
 vMyPBk+eO9M4DQZoA4EVgThV2/9LPf3bqU9TSOZQ5j/OsTksSexIbXVo9aC80BDfyEvBkUv5AHM
 1lQzlr5ZOhN7b1nV8Bc3nnD7a9Qc0p118sbmxjGk5ovAIZYphtsHxUaW8enkIDq/ljzG9C0Raul
 U24pScs778VG69M4qRq+ftI6voEQ/9T3dyiELKOJUodJvvteISS/I1N9o3gVod+7Daft6QkBl12
 mkP99TM42MUKhQps3TZpLLNlhbMRgq7yZpq0cijN2T7dt33iV7Y61bHCmJLAlEhb82r80+3JqQq
 GqPcb1SB0QR0mNpqJLA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050047
X-Rspamd-Queue-Id: 27F561C0006
X-Stat-Signature: we9nirwdmoif3nsynwz978pcxzuzqutw
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1785911335-88277
X-HE-Meta: U2FsdGVkX18SoXxgDIr38HlvEhKP/RZ2s4RJEyeI5gLyAolm+EkeYODCehK+4/p0FuTx0Bhg24UoD4uquERQ1kjqLR98tOYY1rfxVJciLZU8UmMQlWeY5vwDHWCprkspkTVoij+OLJKfeJcMScxxlg1oH8l7nImsK3xw9rS+sX3ck6jdz8+/l2FymMCcp2KA5c22DzUgDFrIEdb92i42+kxx+kfdDUa0i5ONTH/txIQEs98VKDcKfCXtOXFcnMEK6eidtw34t3MHJin70hkKjrGVEQ1DmO1qd67YB4I8GZ3jfe1ZA6w0DAEl1YqBMiUnnLWlYlMByhXqwu9Vx+Lmw9tm7JUOJydkqs0AfsPWTdf/j4UyV+YgLDU6ChbuZWivByTZp7volWtvNjRPyqo0EzolzybrjatCZCHqsKLOdtPzwGPa+wKIafW5LgpKTGTI4ePIYh8pY1fMaitIw5tZkypX4idMHFkqzUAMW5xdpTrH9nkKFcIu0MQeb3Nch3OF/O6vCLHj8p5UWCWheTLvVDW71PLhDv/chSG9EHDJh/lGuHvBuShOK9rwsSrCD5LatQoEUe2sM7GLF3shYtn2RUEvxjY/cqHD1F95/cIasJuXF8xZTextFzY35uPsrkq9sKbSi1nG8bPyJ3hDz23CdoRhN67OMQjruOVfPM5/EfESVbt2haZfc+B7MBUPFmAurm8g+XcpuwzKSZXUAuULJ2yG7kHPG/Ctmdiw8TDsq2YrBekkEoEJYyPiU6K8SOyUH+r30mHygTS6zhKq218+BpU4rDNL7iQRGoZolisRLXOwf+AwjnZKkb56TAuvnwFEX0O1vgSYk29rh2O/bnJMwKVfrc+e5jr7BY74HPg9qWsbvP1OiIMf1z1VXwz0wiOZtNZxTuDk7FOH3dW9Y0pVtqmmlidH9U7Re3kIg5wlJxligTHiYv7hKEE31XUF6vTfBw5u8aS0+gWio22UDem
 6tJZvEay
 +wp16hqEH9Z8d/LDNQu40b3NYDDrN7MkH97aCVuAuWGHZtZQIeiJgFN9+iYj3TmtoYX/VjkODniCOjDYXkIpnEzdmZdWiWfXxfAsSRakZVJwCb9GaqHK4Zsq/zWyEEspp/MjapQDePbRfJyPiCugtO5CfN1kgmE1MId16hjyQziu1RM/KjCqP19jX2B0xSQEUL8IUHFG+IGPUdAMZPPp7fr2bfVITWZiK7XuyKG1Gpr046AsfMHMYMSTOJQXV2L5ZXvsUfoNJWeMt7HZ+J1kEm+cwzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add helper to revert back the iomap iter by count bytes. This will be
used by upcoming RWF_WRITETHROUGH feature to revert the state of the
iomap in case an error is encountered.

Writethrough can process and park folios so that they can be batched
together for IO later, this also advances the iomap iter. However if we
encounter any error, we would want to cancel the IO on those processed
folios. In this case, we want to revert the iter back so the upper
layers can know how much we were actually able to write before failure.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/iter.c       | 9 +++++++++
 include/linux/iomap.h | 1 +
 2 files changed, 10 insertions(+)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c445a38b6285..8ea849e7ccef 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -32,6 +32,15 @@ int iomap_iter_advance(struct iomap_iter *iter, u64 count)
 	return 0;
 }
 
+int iomap_iter_revert(struct iomap_iter *iter, u64 count)
+{
+	if (WARN_ON_ONCE(count > iter->pos))
+		return -EIO;
+	iter->pos -= count;
+	iter->len += count;
+	return 0;
+}
+
 static inline void iomap_iter_done(struct iomap_iter *iter)
 {
 	WARN_ON_ONCE(iter->iomap.offset > iter->pos);
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 8c754eb974fb..1c8f13948f81 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -275,6 +275,7 @@ struct iomap_iter {
 
 int iomap_iter(struct iomap_iter *iter, const struct iomap_ops *ops);
 int iomap_iter_advance(struct iomap_iter *iter, u64 count);
+int iomap_iter_revert(struct iomap_iter *iter, u64 count);
 
 /**
  * iomap_length_trim - trimmed length of the current iomap iteration
-- 
2.55.0


