Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC36810F996A
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 18:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FA1E6B008C; Wed,  8 Apr 2026 14:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45CB96B0092; Wed,  8 Apr 2026 14:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B5B6B0093; Wed,  8 Apr 2026 14:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2527C6B008C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 14:46:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EB6E3E098C
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:46:24 +0000 (UTC)
X-FDA: 84636269088.01.93AE193
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf19.hostedemail.com (Postfix) with ESMTP id B07F11A000F
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 18:46:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VenbjJ5c;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf19.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775673982; a=rsa-sha256;
	cv=none;
	b=1cxcN64seVfjcDavDeAJ02P+bL1YTfvmYs512g/CQbnslnl5ZzA7JWUR9Mr1OwW1/ivFGZ
	zIEf+gG/KawoU8lpmmdhZnAboh7RlaKH1rU5lA+Uzyp+GaGjSqEJaP+Zf3CMPtGKP8/rFd
	dNqc+pE140iidJeQUJ9+WlUighnR/os=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VenbjJ5c;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf19.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775673982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfBhzVEmdDTO9khogB+4Xy9fp0weh853fIHPAUsG2nM=;
	b=JIBuYyD702BTNsiojBlhuyWIChuBEosnLYXPgVN6KcLvUu3SL4+7M0y53IjoofF/+H0NmL
	DQNy3bWetiT7Btgkb3znfV5zaymseFSB+xyoxDPVcHss9GZlCG1G2TSlcCzlz1gnLifco7
	RFaTCNy+KzDR/SrV8DPd6wKzJnhcde4=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6386WUw72326341;
	Wed, 8 Apr 2026 18:46:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=MfBhzVEmdDTO9khog
	B+4Xy9fp0weh853fIHPAUsG2nM=; b=VenbjJ5chvFAASuGyTIkrBfCJG2Uy4U4G
	uEGlQJLeYDh+mTES4Hi9Yf+2x70NQ1LEFZKqzdx5quX9gGId4KuR+fn633JAQFHQ
	DgtFcDuimsEXPCmhIl0H3NBpOk/uEWeHJLUyw0U9+DTlWKCnduvy42iRgURkQa6N
	46R2C/rIuvkAyeo7cCMT32L1TPBdd5VsCnRcrcmQ9r5ZQn+A6nsdv4OY3eBGNxda
	3WMMz8OWEJIozsgrM15VvKAK5oyCouBLFl/LqfsTMiQVfmOu4Ri9E7EHatnv16PU
	yUcFbjrJKFu5MgxyU/SFKEJVn95zWfxvIubfdG7pFw9dDOfst/v8Q==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2kgvh9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:13 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 638FwrvX019113;
	Wed, 8 Apr 2026 18:46:12 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dcme9gm34-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:12 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 638IkAs146203346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Apr 2026 18:46:10 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8767A2004E;
	Wed,  8 Apr 2026 18:46:10 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B85F020040;
	Wed,  8 Apr 2026 18:45:56 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.72])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Apr 2026 18:45:56 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH v2 1/5] mm: Refactor folio_clear_dirty_for_io()
Date: Thu,  9 Apr 2026 00:15:42 +0530
Message-ID: <a35d5d65953cd9bdead0843d09c4cfc9d1fd65aa.1775658795.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE3MCBTYWx0ZWRfX9lacaNyd+wCc
 Gpe2sNQr134QkD4u3pLlJCk4V/Ma6q+yCkM9R6rbqJ4vXCcA8BfSXgvcmS65/V31VS8L9UJfxuE
 7Th+zdNSiElxiSmCx2kQxWifz9hW/KtUYF4uHRQ4hQIMweEHu6ftwygZdcx7/xDRoFTpwmOZ+0V
 OSgjpK+v8I3U0Zc3vJvTRXdxI8p4TukKIh+qq56GADWrZAYdibxRt5J5lRqShrlA4uenDhN8CzI
 GKd/mhfJPl+tBJqGyIUYy6e7OoPMdR0tJQeqeF1kRuxJBUF8Wj5SeZ7UDBbKu9RiTql03hupLt+
 rZdSaB4chqZTqNzs8BFrHuo6FIV86d8u2p3KTtT8zle/NjG2OMTzzDiwAtuwX0nMpxO+qpMmId8
 iHcAjI/x/NsPS17V1wAbvFvxFKR/Aa5w8GOs58uJUD6JDsk04PZhaRdNXmenxz6sj1LZQdSxXdB
 Cqm9R0EV7VJ4zeKU8Bg==
X-Proofpoint-ORIG-GUID: IDLTCbjMJD02ckO5zX8Yk3FV6kIhxYo_
X-Authority-Analysis: v=2.4 cv=e9k2j6p/ c=1 sm=1 tr=0 ts=69d6a275 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=BWzSRGt6nnUlSqokuEQA:9
X-Proofpoint-GUID: pun6bXvTAKHjjfiNwEHsCXmTH6QMpLDJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_05,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 malwarescore=0 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080170
X-Rspamd-Queue-Id: B07F11A000F
X-Stat-Signature: 7unqcpbx7cssqc5w4fi761mr33nwfcgx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775673982-873140
X-HE-Meta: U2FsdGVkX19qbu+YanhzZhcx8XejcMZAlIL0c9A29IC/RzqBK5FYI7GbEQd+RbqcxPyCICI0yXmFGjqACwU0rynYLgyS2lA5WrytTCYL003JCK/gpmOvllU6bELLSqiYeYtoIptfWx1/pUeHMTddh2OmqG/tpvfLHeJeK5m18BtbCLXNuMQqDfZw6wNpxkU3GOFpdWnOJF6lZNc0//MaLuGMOEtRcfrW01gUsdQoJQCNFlKmdObgRnU0j9uj5ruAr9aHZRzKu8RuJ0oGG8uh0it/0i3gx/IfNIS+sdBapk8igBCX7ugBKG4yRvwFQfqcFR3Ndul+EJteX/nHRUrNWH1NXSEa7doMNm/n5ptR6SRkTYyZl1CXCqj58fkNhZMFKM8E5spyVpEPi/tTYS8p4bcCTr9hhGNUo7brQKqnIxfk64ihAaH6UDjMP/yzV9LqFxMBP1ZPexCZKqpQ1s/9YFpo0Q1kNnHUOf7cb9cB3muhyJkl/OyGI4CK8J2/r2jOYCZkKtNp9Bo25crIYMvADOhjgv0ivGncO7QnkfsrHfij4MNrdplMbOMvFnB2iHtIe60MZAA4UURIoH28RnidBwvvNHc7AqOeraaC01lg/GLs+XJLM0RzfEPu19J6zEi/jVrU5Hc/yB2Q644QoXFKW3aFrrfWD+q9lCwOJssAnnhaoaGuaCNJHrMe/8MbfhhCeOXY3AShrWUsP7Fo5f6vTnX9XQcWni2uza46Bgevtpln2Y9CMufjiioaYA3Up2wMZ8tgYOkoMjR8LZJ1iCt1R7+zAe10hcWEBk0W48peQ3vYsUTE8uqEqA8RTFMhLz/zpDDGV5kSVmL90ZydiJ55DbrBtE81DkiQnRMAiZ20uDhBncHuSFbxc+OiyJ0YZ7U8e8iz38aLsRJ3vRbh2ttaJYZkrcOSIZOCybMWLg+Hcd7Dpea6q4cLki5EFyrsx6WdDe9/Ptf6mdeZyJBdCxJ
 hSpt1Z8w
 WtgWLwlFwc/SEDGVdrphd4ePKCqgsrelzxRGrr1KSG6JEkV0J/UYhWg48hJn48Fc78MqLu7vBy0IUyoRQwwRhaZQ8ZSxNyz6vNhnX+LZO8vOZqQ7d6vvKIJcwW2IisjPS8sY6IDLiQsA/4mwljsBx9A2knTlPLpGwEgjI1hGPJ6jGLPfIcmfhQZ9E/6sMATu5Yu6WUTfAxCD7OQMzSZK4A64oJnupbm/rVMbda1VrnhEupb+5Lv20S8PmjeQRyYy0PHQSwXmh8amSL2FnggazRkW0hCVeFdBbdt2YT5VwxKeDW6As4Wf5CDPDE5vRnQg75aA5U5EZsTNION1Lvjf7CA0ifCR7wXlVdfNHgUf6fLvw+ABoy5jv8sWdMqPGGVP+p12aMCF/EoI8Y8yMWDKqcFJgABknKGmwsk1Odj3SYnO/R6C9YTGBZunlbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new __folio_clear_dirty_for_io() helper which takes an extra
parameter to indicate folio_mkclean() is needed. This is in preparation
of buffered writethrough support where we already do folio_mkclean()
before calling into this function.

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 mm/page-writeback.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 601a5e048d12..2f0c6916213d 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2847,8 +2847,11 @@ EXPORT_SYMBOL(__folio_cancel_dirty);
  *
  * This incoherency between the folio's dirty flag and xarray tag is
  * unfortunate, but it only exists while the folio is locked.
+ *
+ * For some cases we might not want to do mkclean, eg, if we've already taken
+ * care of it, hence pass the should_mkclean flag to indicate if its needed.
  */
-bool folio_clear_dirty_for_io(struct folio *folio)
+static bool __folio_clear_dirty_for_io(struct folio *folio, bool should_mkclean)
 {
 	struct address_space *mapping = folio_mapping(folio);
 	bool ret = false;
@@ -2885,7 +2888,7 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 		 * as a serialization point for all the different
 		 * threads doing their things.
 		 */
-		if (folio_mkclean(folio))
+		if (should_mkclean && folio_mkclean(folio))
 			folio_mark_dirty(folio);
 		/*
 		 * We carefully synchronise fault handlers against
@@ -2908,6 +2911,11 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 	}
 	return folio_test_clear_dirty(folio);
 }
+
+bool folio_clear_dirty_for_io(struct folio *folio)
+{
+	return __folio_clear_dirty_for_io(folio, true);
+}
 EXPORT_SYMBOL(folio_clear_dirty_for_io);
 
 static void wb_inode_writeback_start(struct bdi_writeback *wb)
-- 
2.53.0


