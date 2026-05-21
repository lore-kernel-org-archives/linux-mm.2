Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E547CD5BA6
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 06:48:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91E7C6B00A1; Thu, 21 May 2026 02:48:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F60A6B00A2; Thu, 21 May 2026 02:48:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E55C6B00A3; Thu, 21 May 2026 02:48:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 682486B00A1
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:48:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F6B7404FA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:55 +0000 (UTC)
X-FDA: 84790499430.08.601649D
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id EA9AE4000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 06:48:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WyHTV82z;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779346133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nq5DzWgRtL4E1DjO2dFfdwfaryhi9dLpfVcJI5A/LOU=;
	b=Tcqp0wEvv5H6dToVICi8rzYJl2uNMb4nTz2CmeC5l3cOt+icy52TPZX2cTSxMjg1DhaWdZ
	EScBUgYhnWzvks64hMyVYM3jHbhIcrBP8BPG/a7BALK9C/Kt0IhR08GhUoPOcnXI1AyAcU
	DSITjv7Cw7Dg5YBQ8QgW5XajG/Corzg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=WyHTV82z;
	spf=pass (imf27.hostedemail.com: domain of sayalip@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sayalip@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779346133; a=rsa-sha256;
	cv=none;
	b=NTPFlUbMR7JgGb44vPsZMnho4UohP4H94IkhfUYo4pTTt9v774VYCMsauKOPmnET47ucdm
	ixv+9isKfM3zAMy+TLAYcDuRQjverd3sLDdnva1JVTNSUSKMmr3psIP7FgY8amKxoOLuY0
	bvzN9FhWrifa5WOWcZGLVvrTgTLgjOc=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KIvSiV2082630;
	Thu, 21 May 2026 06:48:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Nq5DzWgRtL4E1DjO2
	dFfdwfaryhi9dLpfVcJI5A/LOU=; b=WyHTV82z1KFFn4BB8fy5BaybULEjJQZZ1
	wrf4oGmjLxBsjRBXCifazLl+LnLdbVX6ZLKMyYUjgjgNuNN+PnZLAgoaqU7Z7k/n
	qgmAYiIov68p62Ysgd7keNQwPYPyZFWYXg2sBtWyE4D01VGgHoNCaH8xLE9m5CEZ
	D4RXvKyKzgSyw1xM46a5bTmml5+Nf7yrGn6fXCvJ2rvFd/O2M1WDLEaZYqlDBs3g
	Zn663AYQfT+/mhCSeVYta3eUBzVS2+QoHPxOGdooKrCU/BJr2g81t4annnXEBNI6
	VB5WO/mC8uR3G3m9sUfjGmZoi0bi4TXYzsgX+416ZyFiEm+1dblqw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h88mcey-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:40 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64L6dHiD009806;
	Thu, 21 May 2026 06:48:39 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e74dhtrr1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 06:48:39 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64L6mZKB24248794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 06:48:36 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D3F392004B;
	Thu, 21 May 2026 06:48:35 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A23D920040;
	Thu, 21 May 2026 06:48:32 +0000 (GMT)
Received: from li-3f69264c-2ce6-11b2-a85c-c3f414d24014.bl1-in.ibm.com (unknown [9.123.3.209])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 06:48:32 +0000 (GMT)
From: Sayali Patil <sayalip@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Ritesh Harjani <ritesh.list@gmail.com>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Michal Hocko <mhocko@kernel.org>, Oscar Salvador <osalvador@suse.de>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Dev Jain <dev.jain@arm.com>, Liam.Howlett@oracle.com,
        linuxppc-dev@lists.ozlabs.org, Miaohe Lin <linmiaohe@huawei.com>,
        Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
        Sayali Patil <sayalip@linux.ibm.com>
Subject: [PATCH v7 13/13] selftests/mm: clarify alternate unmapping in compaction_test
Date: Thu, 21 May 2026 12:17:53 +0530
Message-ID: <da5e0a8d5152e54152c0d2f456aac2fac35af291.1779296493.git.sayalip@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1779296493.git.sayalip@linux.ibm.com>
References: <cover.1779296493.git.sayalip@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 1pF53W5BIdKYW_lxTRZ2eoamRBw1P_PD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDA2MiBTYWx0ZWRfX06tcHDJDJrMG
 YTFU4A6E26qTAclF1E1qDWHIUoF9KXE8DEwb/pMYeYuOeVyLcCLybY1x5fGVUCSim145a1mlZD8
 GfjwxHYaqL2E4zu6APXvFl4rvBOA4ziF4hAXjNex9HYZzny/0JqUC1PI96EWVlUyuKLm31amdnI
 MLDCNdnJjFQHS0LKK48qb2Dd68yCdxjC+F4RQKg0JSs8vmfAv4i8vu8tAjmIQSKfFVEKgZt/eLp
 dBsWKBBBd9hmQJWBqYYvbLFiIIFWI+sIwZ446xwW4jiiBje7q3NqOsvfCRDAjbjZ8Nsn3EUT+v9
 WweWPONzdSF+DHLTri2ON7OuR2cTZM2OYVnLtvEAheoLqsxAGp93I3rwBgT/CwEjjEEEuEHL4eW
 C/NbNTJmy0naTFHV6RSZI0FYgik0rTGbFyzXyKpTWjNMbPZ3oL21U0f1bdxNmbr9FGAoZkH1xEw
 35JkQVNyzF1ljtxr0CA==
X-Proofpoint-GUID: ypZ8jMGmHbV48Chdn4zcz8L_7sFw0qly
X-Authority-Analysis: v=2.4 cv=apyCzyZV c=1 sm=1 tr=0 ts=6a0eaac8 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=THlBPJCoSQ4NST9nLWYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605210062
X-Stat-Signature: nn3oecqtsjp1c68hskee3ekyhcpo9h93
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA9AE4000A
X-HE-Tag: 1779346132-100166
X-HE-Meta: U2FsdGVkX19JqhHk0K7GrnYyXbhnS5DJHFTPdRPyy26Nc+sHbMwE6c9RZOrLjXaET6kATaG6B7r5K5/6pVvrN3fDFW0dll1KHWlVINxVF+emfZLE6B45+UkypugUUnbXqNmObwHD3kw4K9Zg/nigjJjCOH+tmWXIEl/20oFDPDORWA/sX4ueIsg6U3rWfgMEoU90PzYNSjZnBwVsi/RWea1WKszKYI+GmV0hdT32lr7FRgcXp/ajJ6a8reO7HZSr/6LMNJy2kFCzKIh6sQHdMOSQrqdowW17pk04uM5HKC6FYAmgAZThK3wgzTDzHX8GjjmHGaYo4VN4Dq76Pv6ox5/YhDYOo4xqTymvjecVv2Mqyf9Jd8ixaLIVloi5u4Bq3SJ9IbCNFxI37SCJvPz38btYeh/y3mU/nTIHvOaQvQpzhTR/tV2fMb0YIcUZn0KLl0Ca/7IhogHMVCH50W8A/kLP2tjO27qLstt60XQ1Z1KL4OuBiGeSJQSiHaB/DN3HLG+ksyVIH5L3PuZkZOPNV4hULXLpYtekWNLdArpZoGDNBWARn+ppnTF9/TxNnRYvBY1DiZOoldR62wuCpTPy1BtzWay06d39SQYlk3H8cWOJR4owiyh4MNO1cHW0Rdd85NGgGNqg9SCR9QRc6H/CNN1b9gJmbRhMDYX3SLnHQaFaBgH0NlluDOVLblhfMov8cvi5UKOkDnKHmZlmUQAsokMmN9EpD7vROtQddLBmvpxyCe9DtgcrrGZGIZl84h1CEO4G57VJDlkUIX5e17cwZUyGAZsUlN80qeEMDUYKaiN8fSF6nyUsshjqa9s3X/xjQZSPG3IrRda7i8YM5T607JRnJ5zpnZlQxlxvLnasJgOb7LAGpXQXQ42AQj84cCPCLEfL7bpqt0vmpNoEbfULaJRDChRL6KBg0wqQZzsjOFJ4szFkEbkljh1VcH7tLAEhHLkZt9+gMMsZd12tvRj
 ZSUJNBMG
 48swRHkNlufLOesFXmdiOn+lk882waAhhiCICfGagKtqo3gP+pafeQUZRa+oNNCLBivQijRhh7/eahoANSdNqaRqRCWmjb+Me1DgrgiKy29EOCwb+5hTGl8zQfwX6QAYprfJS6jueARkKlUmEhwAfONM3F81rPxOBX29slY9Lpda/QZx1fRaUZw3QAibhxkpEYcVfN19aqwR5dMoVHJHy0F5K0NVF791BR/CqUwUv+jSYfL6OXhHUekSIDkZ/pFMLKsdotachVMr9rHnFP4EhN3G76Td7iV1Nf67t9yJfIqSMtIZ1uXggxKK2BpPXMA2dRIyD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a comment explaining that every other entry in the list is
unmapped to intentionally create fragmentation with
locked pages before invoking check_compaction().

Fixes: bd67d5c15cc1 ("Test compaction of mlocked memory")
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>
---
 tools/testing/selftests/mm/compaction_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/mm/compaction_test.c b/tools/testing/selftests/mm/compaction_test.c
index de0633f9a7e5..5b582588e015 100644
--- a/tools/testing/selftests/mm/compaction_test.c
+++ b/tools/testing/selftests/mm/compaction_test.c
@@ -181,6 +181,9 @@ int main(int argc, char **argv)
 		mem_fragmentable_MB -= MAP_SIZE_MB;
 	}
 
+	/* Unmap every other entry in the list to create fragmentation with
+	 * locked pages before invoking check_compaction().
+	 */
 	for (entry = list; entry != NULL; entry = entry->next) {
 		munmap(entry->map, MAP_SIZE);
 		if (!entry->next)
-- 
2.52.0


