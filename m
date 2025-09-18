Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFC21CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13ABB8E00B4; Thu, 18 Sep 2025 01:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1114A8E0093; Thu, 18 Sep 2025 01:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026388E00B4; Thu, 18 Sep 2025 01:42:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E74078E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:42:10 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BFE8140762
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:42:10 +0000 (UTC)
X-FDA: 83901275220.10.13A3D99
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 50701100009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:42:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Gk43Mya7;
	spf=pass (imf05.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758174128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OBKDixxSjT9l4K8ggAIuPhppYH3mz6c+uzt5X0taDP8=;
	b=IjW4WWWmHuEasibsH32ORW2cY3jOPyx44AMjiseubOG8SoyTFduhE00ulJdJefmen0/7I0
	MR6XCYkd/URnK5xSWtbRl+Z+7fjA387bJ4T11xPEaSaYs+XX0DEzjvD7CZ3oPcFXLyefqs
	vHSfdw+5hBbmR7fiGLWnJr0KU4L0l90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758174128; a=rsa-sha256;
	cv=none;
	b=Rq6F50ydHh/+6HGwTob8trKptrGSpag0zTGT98k2RhxqCh1x3fxRgIwk22e2MDO+N0gwif
	c2wB+p7ixWbnc+83ptsSKuEhh0gGE/3JkWQwXgp+L7knhK67MTy4isBG2+kuv2nIQzH9DT
	CKWRiul32TPXRujMk2tAyfWcqzkEJko=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Gk43Mya7;
	spf=pass (imf05.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58HICOo0031226;
	Thu, 18 Sep 2025 05:41:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=OBKDixxSjT9l4K8ggAIuPhppYH3mz6c+uzt5X0taD
	P8=; b=Gk43Mya7CycMMGrFXDyvFLazPFln3O0efxiRrTTyEeJlaXkxhwMyzXcYK
	CDJV3F9rwkJxXF6M6AexeESgZjAdnv24kt5SlDCgD4y9FAcHApUXhfRDBpc0qKRx
	Teh9rc6v6GUGVooaeUFse17glud4v0Ml7Td4MFvwX6UlPduSL4wVe1xgUkF4ky56
	4WsEnWNuPmamTaXQTlEJbk6OjHh9uA+gLjZPh2JjtRKw7ICHu4I33QNfVRDrj28X
	jtjJjWZgW2Z2aoTHW/y9pmlc2Yvtj/1pHYeHLpLh8NLWI7ClzybT5WXaMN1L2umC
	amWbfKq9auVqDu8oedeqHVUVzcslw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4hr6f7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 05:41:56 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 58I5ft41020814;
	Thu, 18 Sep 2025 05:41:55 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 497g4hr6f2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 05:41:55 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 58I29qA3027349;
	Thu, 18 Sep 2025 05:41:54 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 495mend029-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 18 Sep 2025 05:41:54 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 58I5fqmG19923348
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 18 Sep 2025 05:41:52 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4865820040;
	Thu, 18 Sep 2025 05:41:52 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9E55620043;
	Thu, 18 Sep 2025 05:41:47 +0000 (GMT)
Received: from li-218185cc-29b5-11b2-a85c-9a1300ae2e6e.in.ibm.com (unknown [9.109.215.183])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 18 Sep 2025 05:41:47 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: akpm@linux-foundation.org, clm@meta.com
Cc: Jonathan.Cameron@huawei.com, alison.schofield@intel.com, dakr@kernel.org,
        dave.jiang@intel.com, david@redhat.com, gregkh@linuxfoundation.org,
        kamezawa.hiroyu@jp.fujitsu.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, osalvador@suse.de, rafael@kernel.org,
        ritesh.list@gmail.com, yury.norov@gmail.com, ziy@nvidia.com,
        Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH] drivers/base/node: Fix double free in register_one_node()
Date: Thu, 18 Sep 2025 11:11:44 +0530
Message-ID: <20250918054144.58980-1-donettom@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: fd2goAVEEdH8ru3hzgPbmf9ZS_NUOEPf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTE2MDIwNCBTYWx0ZWRfX/Kvmx8lXMZAr
 ESMuGg4RK6CyQ7Er4mqCCEkm+upkNw+TY9Yz532HF9AYdUfYMO67DoKG0zGncMmJZKtHIuayWk9
 rvEJsnWHtzlitNsERaKujevkNjUvXHz3T3SFKdX3PXZLc1X8x+Dg7albq4tZ1CD6wXEmDDKxmG5
 YAohK1fHAhDGTxhPHq/tYku2zHxWMITUSFx3+nXDM38aYUe22ZfFP36FR+Bp7xwcvbwsdWUB0mj
 sEXcT8uclieEamy2opwGcC+86u8AVdeH9ls8Tf2/JeBKhxxLLJF14ccrSaCsc6LRJm1ujBb7GjP
 pox+oCQ41NdLz+c50CjtivCQWZSe+q+tmtYYro4pcNDz6J/AWL6u3+9457gd9cGUCB7JW5taQ2F
 Kkfs6K5z
X-Proofpoint-GUID: 9dkO_JwuQlghnLk9u7i_C_STFIa2wwFr
X-Authority-Analysis: v=2.4 cv=co2bk04i c=1 sm=1 tr=0 ts=68cb9ba4 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=yJojWOMRYYMA:10 a=VnNF1IyMAAAA:8 a=U0bHb1oF5oj0ebd8ssAA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-17_01,2025-09-17_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 priorityscore=1501 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 spamscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2509160204
X-Stat-Signature: 8ped9f6smkn9k79zc1que8feq18cpb3f
X-Rspam-User: 
X-Rspamd-Queue-Id: 50701100009
X-Rspamd-Server: rspam10
X-HE-Tag: 1758174128-807654
X-HE-Meta: U2FsdGVkX1+3zLT8Hzf0dpkjZGIvGCIjx0pd9sOfWo1gKM8D6sQRBJoIv7T02WrRe530KNYweIJT4LXjqzQF6yaU3pbs745CqUiNYuhfWt6nnOXZ8DaT1m1U6rbrmJJ0RAJstXTIPW/O/pkqfFYcb2rUtqMbtyk1xa0Yl19H73f3mda+U/7YcJZ2FhgKE+5V1QoUW25oVUm1P+Q+Z4RZ9nX1JhPR+FUYSdnkBxPHyqrc0JGiZF4oR9f2wH0p3+NzmxDR5oBtNRDqezb+k5yE2n/haPybwuCpRC8zazz6vE8MQKaANQBaVYGWWjD/LZL1CFTTJ+nVu9U8/+Ied/f4mxUbqTlhi/RXDjRBwX4Omd+/rSZP7OpHXIxIrjGV7TrbPIkif6T7ce5u/9omRl92uzy9sVlmyHy7BJIotv6ibjiSzWiJ5DUO/SXtJ79cw1RqgO31KSck+XDtx32Bf6rbHFkavEryaggoa5nMu5oNJwx8vyDVqeJOlDBQSWiP6f5rIs8BKj+OyiX6PjXGv9CLLjCV6xlvSoTWr7QbWceB75opzYy+5UGlSibAnvFVvWLs6wmGuJqOBUQYkQTm7pdL0W0tJNKPlFMV1pxsX7MEnzHlPLmZMaMXWCMifavR6Sxq4nvuwconRf/zg72GKwVL/6sXWfHjtd0lm7Bo17jnI9voAOpUmyaOQQMCvdBYj5WCzhmgVUsES7F+3ghxy2SYP5jWIzJ5tsaP7A0ndl/F4Vp7WpZc0izRM6MLCksyiklQ3nb3jxLWI6CwlF4we3tv518bK3n1JMkMF2Mqtv7q1NRCC9TSdkmGE/Cx1yza86K3vjrVb6WmFwIcA0MYcYa//n0M3Hv3Pdeyv0sZKQj9Wi3aai+Yt7pNybk+zdOy9MFoTGLyIpCNVE7d2gnDH84QheqXVmhfYP59ModUHLUymZ3Ofkgfifbu8kuHoI7L4bGvTHdWcF1ErR6A3X+TLKc
 pf/hHy5J
 r2GdCxuC9+Q++DI0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When device_register() fails in register_node(), it calls
put_device(&node->dev). This triggers node_device_release(),
which calls kfree(to_node(dev)), thereby freeing the entire
node structure.

As a result, when register_node() returns an error, the node
memory has already been freed. Calling kfree(node) again in
register_one_node() leads to a double free.

This patch removes the redundant kfree(node) from
register_one_node() to prevent the double free.

Fixes: 786eb990cfb7 ("drivers/base/node: handle error properly in register_one_node()")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 drivers/base/node.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 1608816de67f..6b6e55a98b79 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -885,7 +885,6 @@ int register_one_node(int nid)
 	error = register_node(node_devices[nid], nid);
 	if (error) {
 		node_devices[nid] = NULL;
-		kfree(node);
 		return error;
 	}
 
-- 
2.51.0


