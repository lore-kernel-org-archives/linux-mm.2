Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7447CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 13:16:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38E088E000A; Fri, 26 Sep 2025 09:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3414B8E0001; Fri, 26 Sep 2025 09:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22D5C8E000A; Fri, 26 Sep 2025 09:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 11A6B8E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 09:15:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B0A761DFF0F
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:15:56 +0000 (UTC)
X-FDA: 83931449112.27.F6C5C38
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6E248100016
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:15:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=G4fYiew5;
	spf=pass (imf05.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758892554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CtgZ8+iO1ueeY3gMXEx6CkqtU3/2YuF7qvH0Ti5mWwc=;
	b=W3G87h1hA4l4BcgowWEgjKwlVfW1zaN8U4UAA2kgfNnFxJKgHEumy260SCqX4hEAyZbCKK
	UtXrETJe+DBVJjM+7qNVgl1U4Ax9ByGdFCPiP7odqe7h6veGSTWtHc/E/rdmuEf/3PHPj9
	nIqC9Nxmk0ReVL9WayPb36YwYPC2ZDw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758892554; a=rsa-sha256;
	cv=none;
	b=J1Q2ZqHV9XaJsn2EPjK4QUDVfuwzJOF2NbVGyeXAvSpLhO+a8xUApqeTsDDv6WEINytCHc
	4XjTU3M4D61r6Pxv+7N6SrUQgtScwPZ3lt7d28QdxmOqv3OdXe6cq7djUcBQG990OzoroI
	T/K8hOu+hAxvBLtPqZgoco1arkmawng=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=G4fYiew5;
	spf=pass (imf05.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58Q5O1f6028832;
	Fri, 26 Sep 2025 13:15:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=CtgZ8+iO1ueeY3gMX
	Ex6CkqtU3/2YuF7qvH0Ti5mWwc=; b=G4fYiew5oiyGM9+Hq/2lvYxVOOqrejTcR
	yPFrlULLKknEfAxcATDP/WUwvfI02pM9GBlUr5GUrBZCoMQx0vrD32DsU/Siy45h
	v48XOPiOCZnDtfwGc9otACGsrM3GDth54qCCN772cDUmRvdt4lBhlhZoj25nlqY4
	4oGQf5JAK+ZuwYz4lSDqh8dIrErp5JiEFmNqD8jso/YKIJAJEtUXMqj7142WO7dK
	hkQYmm8vj3MGQX5xnZRD6ZTtuBTS48Wx146aa1O4SNmZvLy8LGQpGDZiLvXACEpG
	oQCy5OMrofDiEdCjgkOlp8eUY5aEb2YlW2//Bbl3lGz77vCu/uYVA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49dbbbmpny-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 13:15:53 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58QAVUWG010035;
	Fri, 26 Sep 2025 13:15:52 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 49dawq450v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 26 Sep 2025 13:15:52 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58QDFmH329688108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 26 Sep 2025 13:15:49 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D301520043;
	Fri, 26 Sep 2025 13:15:48 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A8DC420040;
	Fri, 26 Sep 2025 13:15:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.152.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 26 Sep 2025 13:15:48 +0000 (GMT)
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: [PATCH 3/4] s390/sclp: Remove MHP_OFFLINE_INACCESSIBLE
Date: Fri, 26 Sep 2025 15:15:26 +0200
Message-ID: <20250926131527.3260733-4-sumanthk@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hN-2WtSxn6u81hiCYsJmqwsZzqsrdF5H
X-Authority-Analysis: v=2.4 cv=LakxKzfi c=1 sm=1 tr=0 ts=68d69209 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=f30ByJGsKnh_ESHQSg4A:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: hN-2WtSxn6u81hiCYsJmqwsZzqsrdF5H
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI1MDE3NCBTYWx0ZWRfX/ptYI8Up3RKz
 ehXD+jkDZjRogvAlsPYmrMzoscb9zKvUFFS1FXnP1pd6hi5rYdlDaQJWaRUr0RgHhIK5yBqije0
 uJQigGWv34T8A8mWXYT5iUJdMPwyjroeDo37g906ocBgpoTomVcpY3Tn9OoGT/jtdCzvizTRaf3
 02Gw7Ek6HZ8L8b6BRlpQW/EwL8Ae/RCuIUeYGAD2rPdQa60bHuIJd5JYozvHEH4VvOLKsYup8TR
 qpundNvgS0nzGKGBpz0XHtD1ydyDMNZYjyx3f6lKO1QaKgGSDeDnSLxThXbroLejUvwEjL2w9Dg
 m4DXNrfXXU4X0lx8BCpSEYrysxZ3SGRwinEpnxl/tGVglZnLUpOVfuFukAp9K32ODv0VywLXt5j
 B4cys4jC4SA73y3TRl36M126XeOZ5g==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-26_04,2025-09-26_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 adultscore=0 clxscore=1015
 impostorscore=0 priorityscore=1501 malwarescore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509250174
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6E248100016
X-Stat-Signature: 54od5gkhtr79i3ornqwtz31q4wseeaxj
X-Rspam-User: 
X-HE-Tag: 1758892554-203243
X-HE-Meta: U2FsdGVkX195HYWIk1hKUvFxaKYMUHgL+4Vxl36Z0Bm2K++mtdSMAOZqSAX2wpaWFJVvXqeDb3zHU2KaGcO9Ol8rR7dfPjDFMnXjJuHi3S38A7fdYpQgDb37KSToE8bXZt6dEZ34U8qeEFDaFw5VtZ24MjDxhS+3g53uGCq/7DVnybP3b8cQsCInufAfL7pdHUgaIz+G4bjdD4uvZGscRPvf0BlogQJILhRI82bYvIGKL5Xu99YlAIy//odYjwjhoJNaCUtwMj5maXkmAaYbumgc0cxKb6+NzDwYvQ6l0vctjri74F8Z4yXkARQDIL1kqraMvsrghC8msVqQi7l7Mb+H7WjpzzC1A6f/YP8VnlhE9afO+tYkDHituMxyq1ilZgqICFY1Acamt1LOF0Qzo9L6ISdYJ+qsm3Ju2DDQIG/aEdexbJ/Zu86sa6zuf8tRRykNxESop2sMXNM9Vg4K7Cxfds7UGe3XnHpRpiy/yaqw5bJihxiYXBCPC/qgiSlIum0VEum0xNEg77ceke2fYYS+zqiOnIsGmKDOrV22U24YDAXJVvhUBAPEgc74lmqr9SOsfAi3D6xp1ShGn4x3BLmTYakr/cY1gcPmGSjb8z2KLfVIUBQqTfOTEjVu5yd1CpmDJSS6ybuT7pVkEMBRtwmoXuci+3YweYiHRAVeKz0a7iTej5RIZ4o+EGN050psOHiIQrNyGxRDeE89a3+BQeiyVawaUr4mkej0Jas45+J6FgoVqHX3CC1CLWDqkgr2wzLSZUn74VK2uNNw8VgGSzQLBJRE4c4mypsDOLZHCjEZR+TC3Bc1zRh+YcpDmBArG3bAA/VC6j2UWTkfiaqAhPFG47BN1FqHyaO4T0YvIlyYB2cAKbza5nZ8RJkbEYdfMPMZnwMFaOk3qGml4DZFcFxj/GneGb1f8dz+rvSUSevMdlqsLzPy51iKevJCSnyOvewGuLb3ly9R4Fa5INH
 MU2MKex7
 xuWyzwg+wUOrg1mS9v8d5DSqTbqnLKeDsfvBD96lntq47GgSTsUuxYylairoLrXXdjl0IndaqwlbhXhi8tMaC/VEQQObD+VDpYm20FMQy4AzlzAvxzWv1z6nvboCqHWX/lILcvtsYnMto7fIZuBVXbfce/+mBAOWLRAkoPnoVArDPHedGjm4I6arAYWI/nOo32MHK4u0Q4M5DlLQ9LfcGvDTwaoQWu1w4DzFiQUixaUmEf39oTJK/QH5wPkeRJh1SPWvQdFmzNrw3B6sz0mOwV/Kf7xkCgkK7tpCq2wGFm0sU7PO4uTc6SjF9DBPkmaK5LLCxB/BT7pu0wn4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mhp_flag MHP_OFFLINE_INACCESSIBLE was used to mark memory as not
accessible until memory hotplug online phase begins.

Earlier, standby memory blocks were added upfront during boottime and
MHP_OFFLINE_INACCESSIBLE flag avoided page_init_poison() on memmap
during mhp addtion phase.

However with dynamic runtime configuration of memory, standby memory can
be brought to accessible state before performing add_memory(). Hence,
remove MHP_OFFLINE_INACCESSIBLE.

Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
---
 drivers/s390/char/sclp_mem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/s390/char/sclp_mem.c b/drivers/s390/char/sclp_mem.c
index 802439230294..f49b8457e721 100644
--- a/drivers/s390/char/sclp_mem.c
+++ b/drivers/s390/char/sclp_mem.c
@@ -267,7 +267,7 @@ static ssize_t config_mblock_store(struct kobject *kobj, struct kobj_attribute *
 		__arch_set_page_nodat((void *)__va(addr), block_size >> PAGE_SHIFT);
 		rc = __add_memory(0, addr, block_size,
 				  mblock->memmap_on_memory ?
-				  MHP_MEMMAP_ON_MEMORY | MHP_OFFLINE_INACCESSIBLE : MHP_NONE);
+				  MHP_MEMMAP_ON_MEMORY : MHP_NONE);
 		if (rc)
 			goto out_unlock;
 		mem = find_memory_block(pfn_to_section_nr(PFN_DOWN(addr)));
-- 
2.48.1


