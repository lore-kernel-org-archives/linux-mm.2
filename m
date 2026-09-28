Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3BC5C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 12:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22DC56B0098; Mon, 28 Sep 2026 08:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1990D6B0099; Mon, 28 Sep 2026 08:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0396E6B009B; Mon, 28 Sep 2026 08:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA2AA6B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:04:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F1F41C1B6B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:04:01 +0000 (UTC)
X-FDA: 85263037482.30.776F3FD
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id E9F1D4000C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 12:03:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jSYuskKy;
	spf=pass (imf11.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790597039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RQCcbouV3NVK8Fq180GFDWtpA4XeDMQjNFVf9WeK5RA=;
	b=7jFdLq+b2ZaCiqh6XwSujXLysZCjZQUdJifhTRmPnifCgDnDimbEKYBtDXx0f58qDL0GYd
	nT5OEy2sXAeOpN8HCB0G2jXzJJWymGbLRdN0wuHm002IgWK2O7+TIXLxAOUU1IpYby/zXb
	ACDs88YeJU5ryqEJnyXtzU1U+shuCUg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=jSYuskKy;
	spf=pass (imf11.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790597039;
	b=XET2Xm1n3uEZBj5UgTbbly5AwfGOD0A3OkQ9vrE/MJcXbQiehLqNUwlyYJdyNgDqIauexq
	K0IdBGzJ0tNM92D0/DDB+HJulclE8YYe3e9GBwwMDbPyZGSEzFLjnt7k0IlsqMz+u+6ltg
	5owhYmQinNMMprdBZYTsLlHZe4PKSf4=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZUqi3374967;
	Mon, 28 Sep 2026 12:03:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=RQCcbouV3NVK8Fq18
	0GFDWtpA4XeDMQjNFVf9WeK5RA=; b=jSYuskKyl754ESxGOnp1SHHAjlxLrMkvj
	nc4SNRQJvCmZzdTJTI+LDSAfu+W8Q9oXX0kZxLV3eCa0jCkX1I1jZYtBmsK3hQJZ
	JDXTxq1bSO17L6e0pr7Veesewxcarzda4RLmFL7goFK/er01VsvpaCqCoslCAerp
	Q8FcMgbH2wJPdidU1vt6pKwGynPKObubjFHV/Gd3W8QN3auqZESCHk5S+6XkMzNW
	scnuo/Anhwn5RHpKiH9NYmz94qHBWMO7xuWHNX7tf92Qor5UnsF4Ryntg/CI1Wsu
	nHubqZKfz4tguG4yr4tZ27UlU2V5XByiqjYc219YX7KJhfWI8wKlw==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qr13mv-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:46 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHZZ92943242;
	Mon, 28 Sep 2026 12:03:46 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gxtkg4wq0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:45 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC3ibS49873332
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:03:44 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 26C7820043;
	Mon, 28 Sep 2026 12:03:44 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0979B20040;
	Mon, 28 Sep 2026 12:03:39 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:03:38 +0000 (GMT)
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
Subject: [RFC PATCH v4 04/12] iomap: Add helper to revert iomap iter
Date: Mon, 28 Sep 2026 17:33:05 +0530
Message-ID: <3b88efb9351c21d6b7c883b37ab61a291be66e84.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX4bh1I7Kqvsxs
 Y1KiZSxb5+4no1AE/myX05RTnGjhIt0JUgcrIPcmSvf/46xCZVJr/ohPvadw4p/fDoIrdgg765Z
 xuX/ab/A35c5qBSp0H7KKFD2qWo3D48mCoRwJTjzKHnP7kAX02OWb80Ic25IAike0tckNFMK5PE
 y448Kj8Rfv/Lk2ys/53eks9lvIADs0zQBHGgcEimD+HzdtPawaQR3UDqgs72ORdnaGlElEC/HzQ
 5LsRZM+5DEA0V/Vcz1LnUIQluNeNKDwTZx6x+0xQNUEdxLm6N7lWTICiroVSrEYnIvS7ueVZ6jC
 1p6IpCwh0av002t2yuOvIW2IK4FsQTzpwbp+wPdeiNkRvkR20bGD2xbO0OT4CnqBVWY1QhXXF/U
 tSwCJR4/wm5L6he8/kF/sfJl25dtO8B8xmGOmgm3sckAC5Hswbts/LKZRV+iI5U5pN7hWIzFYu7
 /oVHQZHos7HI+jhT5bA==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6aba57a3 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=EiUwcbAk3iOqCFawNVEA:9
X-Proofpoint-ORIG-GUID: zuzScbER0FeoT01vL9yakAM8E0YTWvDG
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfXy6c79dz840E3
 WAUW03F5rKdkMN46LatjXJ2BDc6WfvEibSXM24wrJVKfynhldBluIx4h0qUJjZVwmLMiJp79Ipr
 k1EyvMj6c2ETOgd9bJiEMgoObGmfeXs=
X-Proofpoint-GUID: jv9ioNvqVAIl45HcTGwz4E5RBpi65zPK
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280046
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9F1D4000C
X-Stat-Signature: xky6p31fy8je3uo63gdzm4co18ysw1s6
X-HE-Tag: 1790597038-641267
X-HE-Meta: U2FsdGVkX1/p3UeQ0TYLhHQlCm3Aoed2i3PIcrB5evWdpuhMMNd5c6V8qUXpc6E6mWtz+KC9hhwGcOoZQNfzAVvPOB1vR2SEnf+DkXFm6N4USzB0kBJE2FU8Tnk1BEibCw5mhPayx5D+gjIXnz6venV60toe2OKxx/d19/iOgxxf1tUlP0z6nNDteVaJIxhs0J85EYlHifbqSixyzqnf0GX3XbOux8ZgGWtWURbHqYvOolzNNDjNE6idJx6AceZljl5vuiqAu9nGJthRsSNq9OivaoF1E4Dd15P1fBq/G1Tn5VuNkwur3waWJpoECFmNTzWL1j0nfm2Ci4YbsvRSlo3JF93dWBsfJz7OytbKdwoXhE9LIZcgtyDPHYgqWVN/Af9pLfwvpQLLUqenJdqM047yMItTS9JeySIE/+mFSpIljZm+f1GH5mFGfvlGls/0gh0cw8NiFY2/dYBx9AbNQNzuERwLwC9qxzeH6pRDq62C/WQlwP95LBoUIKp0qDqAWWk67qw7g7LvLeRy/JalLu1QD6PjIwlUm6fsWZlqIbez+S0KYs53Wsflm2YUGHno28VyoDwZ4L7uZicDOEsxMVVlK8BpuQ3JNLGK4BB+AJjhIssn3XA7+oligN4SKcdZz326v4D35th50motyKBjYo1aOlQrcPIzLvbTyQMau+DD+WCDgXV5rSNpiNfwxwwuCUa8yGawwGVFjpH1eo0F5ZBQ6GExc4gm7tvJQgDF3W677VnzUzuCF3d6OpUEoBHbH4r73/o+BAXHNEUdGg/LAXoObGbwudVaI5lf3v2j00o5CGDfom/egsw/Q9WOWIioQI9Kpiug/5dYuRIYjOvJ+mfTGKVyXDWzn4LKLtjgWZjs3gMqVH0CKG5ce0AnZ+RpmK/C0Q0fkioHgOX5M8s/YGWQ3iAnT2sbiYRtduztoIcmLcnKk+gQjDhXGw1FEnWZn7XqCfwnyTCRXsao/ie
 xWEJ2bHf
 t3njXUWWj46RZwPHMqim2pqqMPanFtyvbmowlg9fhi5QoydAtZMz292mbZQbh0gcZ6TvG7tdlAeVMouoYtWkaJvv99+yEXAF29pjvzYaaJIWTfCG7cYvwutBhZhYLDVFMhbsMQJcAZYCxCWpW+LDUWXtONRWuVtDt/4VBRQrFdm9n9sHw7nA1cqTk04kLuKdD3W7nqbt3/MQbisliWsbqHwunnJLRJjDC3vLBH5wX/MkO3uOW9Db6vihxdbKWHPtxJfl0RnM/zTU4grNUDYupiCxaByztZb4nFbnGZV4XmM8+l5pvjTQa46aoBxZyj++7qpX8fh7B5UKal8Jjj/99vQSiRhiXakUEHVAc7TBEc2Q3o/YQt09WupWUKw==
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
 fs/iomap/iter.c       | 10 ++++++++++
 include/linux/iomap.h |  1 +
 2 files changed, 11 insertions(+)

diff --git a/fs/iomap/iter.c b/fs/iomap/iter.c
index c445a38b6285..81af220dca47 100644
--- a/fs/iomap/iter.c
+++ b/fs/iomap/iter.c
@@ -32,6 +32,16 @@ int iomap_iter_advance(struct iomap_iter *iter, u64 count)
 	return 0;
 }
 
+int iomap_iter_revert(struct iomap_iter *iter, u64 count)
+{
+	if (WARN_ON_ONCE(iter->pos < count ||
+			 iter->pos - count < iter->iter_start_pos))
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
index bc7ae6327dbf..a9ebf486e7b4 100644
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


