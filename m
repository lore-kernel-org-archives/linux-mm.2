Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9E71CA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:49:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D786E6B0183; Fri, 22 Aug 2025 04:49:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4FC58E0056; Fri, 22 Aug 2025 04:49:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C65636B0185; Fri, 22 Aug 2025 04:49:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF4B06B0183
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:49:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DA841A06D2
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:49:19 +0000 (UTC)
X-FDA: 83803769238.07.55D8F2E
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf28.hostedemail.com (Postfix) with ESMTP id 06513C000B
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:49:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VQaeNILa;
	spf=pass (imf28.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755852557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mPZVwvfWavV4HClz+jY+wxIvWkfGxruR0/gW4y6TrKM=;
	b=0tRKobV81ZzqqG2YZD6ocdpBSmuxiGxVHRtPI5XxRgcU7vz1BkNVvnEwVtuOHMhkIhhyQ3
	IY4mqEyKGfGKPyFLv8VgzIt9eYgPkRY4nqGcdQF1sdKAcXjCgvINHgBmIknGl3hWYN9TyH
	BuH4Y15NdTVPrlz64s7h5NVOt1+80yM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VQaeNILa;
	spf=pass (imf28.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755852557; a=rsa-sha256;
	cv=none;
	b=Y5k5JMkSW0HF0PrrvLYYEBVueZnnqRL7VjJgSwBhwPV8T+wkBXRBsx23nngoIEGDfjruCg
	OyG9WJmI9fpxHgruxTja5kNhqWmxvxnRYyhMNUJ9RANUedzo4iCc1NJiSTZGJAWN/fsp8t
	UkFerlqmoOqlw3SaZtLmo9Hns1c4TI4=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57M8mOL1026300;
	Fri, 22 Aug 2025 08:48:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pp1; bh=mPZVwvfWavV4HClz+jY+wxIvWkfG
	xruR0/gW4y6TrKM=; b=VQaeNILa9B3AgzWLpyCVVWiaRKtwnE4kf1D6iQXAoEeX
	METzk0xAAbpmNhxbUSpIjiGGZzDdsIKwXEIJBPYvmxbCwX5R8wq0MOSIk4U2V9NF
	xOyVkIHMWRWos+58SCZxp2wl7UzLYZviezlVlb2eREoiSFs1cMQ8ryK0IMkqRvcI
	s/Nt7aaHsrMNa2tGsysXyKYnEehXU2rm2py8CpAfK2t5f1RMwHCnZdzWxDiz0SvC
	B7ZVQBam7OCbCq0de5a7ojIGi2XN9NzcZ0aLGu3Hch5CxX5EF5gtmhPiVjBkmrFV
	NyW3k2hfaiyqbLkMaOt4jl5z27HeZHzkkAXqwfwlMQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48n38vngyt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Aug 2025 08:48:57 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57M8mvMa024344;
	Fri, 22 Aug 2025 08:48:57 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48n38vngyr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Aug 2025 08:48:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57M87Lkh031994;
	Fri, 22 Aug 2025 08:48:56 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48my5ycess-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Aug 2025 08:48:56 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57M8msAJ19005740
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 Aug 2025 08:48:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5DF372004B;
	Fri, 22 Aug 2025 08:48:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8EA6F20040;
	Fri, 22 Aug 2025 08:48:50 +0000 (GMT)
Received: from li-06431bcc-2712-11b2-a85c-a6fe68df28f9.ibm.com.com (unknown [9.39.21.51])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 22 Aug 2025 08:48:50 +0000 (GMT)
From: Donet Tom <donettom@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oscar Salvador <osalvador@suse.de>, Zi Yan <ziy@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, "Rafael J . Wysocki" <rafael@kernel.org>,
        Danilo Krummrich <dakr@kernel.org>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Yury Norov <yury.norov@gmail.com>, Dave Jiang <dave.jiang@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Donet Tom <donettom@linux.ibm.com>
Subject: [PATCH v2] drivers/base/node: Handle error properly in register_one_node()
Date: Fri, 22 Aug 2025 14:18:45 +0530
Message-ID: <20250822084845.19219-1-donettom@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDIyMiBTYWx0ZWRfX7UGMZhipVthh
 Stkntuj7VehdRWzLVmeeIYhxx+ktPQmeIjH0hxbyqppNZ3hWEdvDOomTYwOCjTjuUx4HLPImmAH
 fyS+WmmBTuAH60ixmzm/z0ebD7a8WMtPdjl3HUhASVRqpXLgX5MLwTr6barBoNtFHRoaFaeskbQ
 llqZElV0MhUFD4O7cUESeYKJRo2c1rqBb7g+mzPPQyoKELr4qZHYbz/r8EY6JSApLiw+EH03UkM
 y0+cjHS5PZGGYkzf2gDLir7Mc09Jnxfj43QEzswTukwLjrJ/qSDPCu8WEbKGuz7yWEDS2fzBNkV
 HBmanuclNar8kd3l7KnbucT7Fczt6ROu6fRryj42ce+GTe35NzI3gGoyscj4ZpI/+w104889HXE
 RmieLP+bIEbn0aXrmILgYWdvc5aqTg==
X-Authority-Analysis: v=2.4 cv=PMlWOfqC c=1 sm=1 tr=0 ts=68a82ef9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=5ll99_7Qev2jIdKbKUkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: 0aVtIqSXgZCth1bRsup1cSf5pxWqzXqn
X-Proofpoint-ORIG-GUID: QrZJ9-yrqYdAn9qvjzfnpcfgC97BJz8S
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_03,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 spamscore=0 phishscore=0 suspectscore=0
 clxscore=1011 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2508110000
 definitions=main-2508190222
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 06513C000B
X-Stat-Signature: bwbooqi9rny3tfq4sgpbmfg4eaqbsgo6
X-Rspam-User: 
X-HE-Tag: 1755852556-379072
X-HE-Meta: U2FsdGVkX19EEa0wc2TSm5LzmCituk0LLCi8zQpn0PfWNV/KLfUpoNYKC5MkabYgiw4Kkn0IUZ/JexzmJdIuPw3hvybJhxT/O6189keYPYHEutLJu4XW/WRo9jxyGDztgQJUuua22C9HV+BMmcIanLnp/YnueWNkbSg8qYjbFz/lzYhJCl/pV6gzywQCKFXHNTipmWryd0UCvlbsBZqFDLipXqfcLgIz9Ri36DrYO3Y05M1Asz+JSXoUsKGMrCy4Ico4ETt474kP9BLvRJsZrtx/kFcjiftuxDFsKr5t20jwjT5Di5O0L/w5he7fH1nSNSDVeBSdEugxDWCugac6gsHCLVoYkMNcLhStEaiW8bKUnHl0IpCKwZE9PCauV5N2m+Buf26sEe2b6f/zIimNkfQpzIqGnhDn8iK84sJjecv0C/GKWLaI6On2WNzo4hDUNiOPtWr4ut8j4G83sN7x+llYasrVGRKHJbM8sLsR07lMGKX5apV5+NtSjds1m6BSZ+WtQUCPhZ4kji7WusK5R/B9l6m+CSXMmK19CCYlyyj0UW6cfpUC5Zx+4fedEU/6a15C2LGUowuyifM8r+XCNmhosNb6guCnUM3pqD1nIZmjV8F+MJEsmJM2qlQQCOBjN1YOebtp+t9C3rBaaZG/wtHhC5GUN4kL7w3Kyt8Wu6wyIgOCAhxbFK4wObUIxAoYw80Nc6hMHAGfc+ATNJARHcQ9dKJT+AoFYHjlcblclsQYr5n8bfgzOxPCsenjao+xhPnwz+TAAAZxwstUvwHbQeaCkmxqWqSb/TMdDNiCIn1ZjbSjrQOPvp09HHCE0ltGNsQLZ5Fw0wRYyqpMLabWG85RU6cZ67gdV8lSgizmtaKFx+oEEtuKMZlNTiyS8SwK+INdEJY5jXLzdZgszhAJJIryPqATqdlwtU+h4Q/6IynTe95WUdr460bdPn4s29uv6ZYxT4KKMiiuzCPPFL0
 /RrgGVdX
 pXRrTDJVLVvMqHlQE7GIVmkdkfp71qoL9+SWRRk5rGpEJA42rgpnoy+715GbbBrbKgsy/08mwuXkEWqSVjM32pY11DZ6b8/JnRMHwkKO7CR5cxA1tANqpHn07i6oyDCG8ek82HHnm15zvsPbU1h8RMyVPcDG3F8D9N0Fuh/I9Wxre4MXgN2wqsPRlFKEE2asAGmEENIvdxCWKQL8QLZUdMpkYzbY4SwihITcTU04uRA1pdMWE5OgErBoKriKVgYzPbnQzxFfZb6kgF/v4qq+QFf8vn14SHmMEsCmW/x69ZH04jjTbWmrVPrGDVHEws4OGfalI5ONdfoxR5+LDU5wnMMZM/IdN0UoLMMeRXDZhRjt+KQzVR1EW2iMoXWW2I28PbxdZz3zv7QSRKqEiJF/I3Rzrkup7Os3SYSbVLkuf3TRq0Q+LsDpYVkT+cGa7CYDFzfUCVL5fawGf+eb8HdoMEv158Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If register_node() returns an error, it is not handled correctly.
The function will proceed further and try to register CPUs under the
node, which is not correct.

So, in this patch, if register_node() returns an error, we return
immediately from the function.

Fixes: 76b67ed9dce6 ("[PATCH] node hotplug: register cpu: remove node struct")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
v1 -> v2
Made the changes based on Oscar’s review comments.

v1 - https://lore.kernel.org/all/20250702112856.295176-1-donettom@linux.ibm.com/
---
 drivers/base/node.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index c65b4917794e..1608816de67f 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -883,6 +883,11 @@ int register_one_node(int nid)
 	node_devices[nid] = node;
 
 	error = register_node(node_devices[nid], nid);
+	if (error) {
+		node_devices[nid] = NULL;
+		kfree(node);
+		return error;
+	}
 
 	/* link cpu under this node */
 	for_each_present_cpu(cpu) {
-- 
2.50.1


