Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57070CA0EE4
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 04:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E824E6B0129; Sat, 16 Aug 2025 00:01:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E59EB6B012A; Sat, 16 Aug 2025 00:01:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70346B012B; Sat, 16 Aug 2025 00:01:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C90C66B0129
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 00:01:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A3301DCD56
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:01:53 +0000 (UTC)
X-FDA: 83781272106.06.8AD41E2
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0F3EF4000B
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 04:01:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VUjdM7Bi;
	spf=pass (imf07.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755316911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YaS8eetIOBTsJvP2LRw1VSFkVozD05zxymGqu38YCZ8=;
	b=Cf1m7U8FF3sEEqaXrqPyZ8jVHs7wXaQm4gGMj0ed1md7JeASZXZfYqGwq9FcOSpMp8+Cqj
	CcifOLTNkE/imMh28xQ5hIvuIC2X7eJq/GFtvjHH2Sc8cwR3Wyg0lKnBtlUhYpK6FQqexv
	h9tDfcHx29jDs9etNaxMtyJVsliB5Ik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755316911; a=rsa-sha256;
	cv=none;
	b=LqRK4CzUrCQeKNVEM/WE5txPFOFMsI9QK88h6PVWsffmI1AAXqItuY+eJJ9TfKWGOO9RT6
	FTKYPhzu1ijxvGcc6XpKgW0a5Kc28mSiZYg8lNUV5DabL6N4Y5vG1TkgceFWaT1015ixQ+
	mMIq9j8gEgTizn/Np7CbztYBI3n5NLE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VUjdM7Bi;
	spf=pass (imf07.hostedemail.com: domain of aboorvad@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=aboorvad@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57G30C6H027452;
	Sat, 16 Aug 2025 04:01:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=YaS8eetIOBTsJvP2L
	Rw1VSFkVozD05zxymGqu38YCZ8=; b=VUjdM7BiI3qlX2BRakrkYOL/lQsK05Zrj
	02ZQU4n5iMGmfuNAL5gnSeEkK7jSv/fWPI+ykTgPqZoEWIvLpmUUdWclGV8ECJd6
	jIpx9ovfBX9qef8gqWzDgQaYVxBhKtXXg3O5cr7V2JTgY0gAo0Yp6U1Qxn8BOg43
	HRikfbrptfcfZycl/mIPgy8OkX+ZeEpH9Hwe4PmQaiI2uU8AXL/bmQecJh8crxRa
	7HrVKcar3TNS6G0N5vdnBuQ/tpyK7BC7IPJRLq7Aa53eMGl0yYdnYGdUXpCExiBL
	JKdUMtH6Nb8gmqQpfji+xdyYDQDpQbj5JuejQvT+WkTxPyuChFAyg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhnxr44k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:01:45 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57G41iQ1003014;
	Sat, 16 Aug 2025 04:01:44 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48jhnxr44g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:01:44 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57G37Mkj017581;
	Sat, 16 Aug 2025 04:01:43 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48ekc43f75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 16 Aug 2025 04:01:43 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57G41e6R52953414
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 16 Aug 2025 04:01:40 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CA0020043;
	Sat, 16 Aug 2025 04:01:40 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1688220040;
	Sat, 16 Aug 2025 04:01:29 +0000 (GMT)
Received: from aboo.ibm.com.com (unknown [9.36.5.210])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sat, 16 Aug 2025 04:01:28 +0000 (GMT)
From: Aboorva Devarajan <aboorvad@linux.ibm.com>
To: akpm@linux-foundation.org, Liam.Howlett@oracle.com,
        lorenzo.stoakes@oracle.com, shuah@kernel.org, pfalcato@suse.de,
        david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
        npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
        baohua@kernel.org, richard.weiyang@gmail.com
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, donettom@linux.ibm.com,
        ritesh.list@gmail.com, aboorvad@linux.ibm.com
Subject: [PATCH v4 1/7] mm/selftests: Fix incorrect pointer being passed to mark_range()
Date: Sat, 16 Aug 2025 09:31:07 +0530
Message-ID: <20250816040113.760010-2-aboorvad@linux.ibm.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250816040113.760010-1-aboorvad@linux.ibm.com>
References: <20250816040113.760010-1-aboorvad@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=XbqJzJ55 c=1 sm=1 tr=0 ts=68a002a9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=2OwXVqhp2XgA:10 a=VnNF1IyMAAAA:8 a=7CQSdrXTAAAA:8 a=20KFwNOVAAAA:8
 a=Ikd4Dj_1AAAA:8 a=Jsdhh-2Z5yyD8EuTVZ4A:9 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: rQIx0Wj7JcxnF7kaPSlheNKjBHxiBHHy
X-Proofpoint-GUID: SyqJ54v-8eGbNXwKAE_xeczvg8BQXYhR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE2MDAyNyBTYWx0ZWRfXxQ5raNDnLApF
 pHE0+1uAahT2+Mn98eDgUtrIvKf/7HKqmhOPvzcPG5dD6I2XscA35eiCuq1LeBlPVWQM+sDf03q
 poGa67cP1mQsGmRckkEqJz53HIK/NLlbFeGIwXKOn4BrBTY6RXPVzJAP7cP+hrz0Q/TETWVp9ih
 ewee+qxWhwl4k7fUgeZxObu2ywgI1KSbbYqgNSbD4Jd6+71n9TXEr8eKeiYevZij/j0UQvpjMqw
 KarYVLW9wTvMAbq8YO/2PrIi9+CktxzP4H1DprWcYGX4DwMcuxnDYBRB1uIzZNoR3Dua+NwQovA
 c8Y4FIRp6W0sdo+lYKUXN+xPoTKSVWrKlM4fdYjwHUGa9kOr/zyzhTZdpvY3iZn/fSG7SryiFi5
 M5SxyOmA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-16_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 adultscore=0 suspectscore=0 priorityscore=1501 bulkscore=0
 clxscore=1015 malwarescore=0 spamscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2507300000 definitions=main-2508160027
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0F3EF4000B
X-Stat-Signature: onn6xhkyge7wbyeudjih9ocsmqrnzznx
X-HE-Tag: 1755316910-329978
X-HE-Meta: U2FsdGVkX1/SD3dzubDc6BwVRwTY9/ZLSM2bdUJ3g7tiIrox/iV0XpCiO4xiRh9Qmq4+le9SlpZk3k7ei00sERZWe3NT0G9WpTV8L70nTEpfCV4KPTyLCoNG5nrzhhu3JnvNygpmtJxCoRcmKbXR1qSSfjFG2YnzH8qvhoQUoBza7HGL/7hGbexQKMh/G9sLHohYLueFmFBH1pat+D/Tp5WQSyLntm2A1NWMCfv7FTKF413zb1Fbf36Z8LpNwYE7UNukKGl98rG8SCHr8w560YW3E/A35bbKugUwSvCHrmBy+BsjRMLf9RJtusPHMOniumCC/lTDGHk2DS64wrXhMiYA8wYkObLJlTG0qwaNowlNZdvonKQEVwKNOGeclHgTGrQoidDOoe1dCXWszBdbslszh3x3gRTN1PbFP66WFXYKndktQcsr3ANROUwRWceUm5nqkflfaywUsDBQ4o3tYDWaTgVDRoXACOFbxqNV0AbZymq03W3gT8GF4crydkfPOn38eibUjQpCRw6APU26n18ZKlJsGhsoBZwin+neaoRbaux5CuO2A4NbqsiN0wur6Z0iiUTCeggX2HF/H37jZHru/WYg8fDq295QqiSEJHqtDroAwXF7gOARvo6VvZYbMDU7GSUpMaH9RMhaOPNmgmpJKQA/iCjOCLNcejZFZ8W3ytd62lRwoskQVbTIQnLTlwOrLFICj/aUl1TmHswtVKx1fbBqdxdacLfoImFHsfBZuGRyac2NYZw3KwQ7nM79aJ6ChcFwLdX4W8sejNtiA/cSm+esOybTF2F/Y2/c99G2j7fhWQ/9bB6wQaYhMjXrAK0pafGzxvcRPEcZDboecOhq1o76O0FRFjqUc8pt3blGzM7cRl/BwtYXsSULBSwwNP6BdqY5bo7+I3hBbKRbZ8WbZnB+ZgtS6FCnXU/HCfys+qBmSDr8+93BGWQKd216h0/+Jt9fFQH45Nd1quY
 7POzxBKB
 VDL9EkeigD3OPVg9y45o/VfikDe8PGg9iTtshZ3WuQpJK1co5WqTy6+MujWTi/50fSHyAzR0OlYDptO8I2sq9EEBFbiKS7kIJFLaFxbkvxLw+Vgpqx2d19LG5LHXkFmbSSu1esND+bEsK6joImRPZBhikfeHBLqfdNJtI2xyTAGezIGaO1lESZxTyEeYwl+Zj8DzU2Faya6sr86uTE5VO6k0PxpY401l2se+UeRVNt5aPWoRl87zb3KTtIwrt6MB+xGFSh56cBZMduGtD8CuMhWbikuqC/9kPrxOsV88pjXoyYIFan3HJjO+kmixduoo8rhflZ6aSRjBUuSiGMkD08sdbmJqQqvsDur6OtRVS5HQqhp6LuL6P0HWI7Sgg+5MmfvmTnPEKhDq3TfAsbriX8LsFNTlClVYr7L4G7kosHdTTov2dfJvckmdu2yccXrZNeM7ffVj9JRmaGqYpXSbqxQzvdci2+CYZztYw7H4j1hRzkRhfpFjm02CsXan0XwKXl/Ham999sxKCjbjb0MBsbnx/p87Yf8UduXQlis0Yf1wwSSU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Donet Tom <donettom@linux.ibm.com>

In main(), the high address is stored in hptr, but for mark_range(),
the address passed is ptr, not hptr. Fixed this by changing ptr[i] to
hptr[i] in mark_range() function call.

Fixes: b2a79f62133a ("selftests/mm: virtual_address_range: unmap chunks after validation")
Co-developed-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
---
 tools/testing/selftests/mm/virtual_address_range.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/virtual_address_range.c b/tools/testing/selftests/mm/virtual_address_range.c
index 3c21d136962c..e7ef6759baa1 100644
--- a/tools/testing/selftests/mm/virtual_address_range.c
+++ b/tools/testing/selftests/mm/virtual_address_range.c
@@ -227,7 +227,7 @@ int main(void)
 		if (hptr[i] == MAP_FAILED)
 			break;
 
-		mark_range(ptr[i], MAP_CHUNK_SIZE);
+		mark_range(hptr[i], MAP_CHUNK_SIZE);
 		validate_addr(hptr[i], 1);
 	}
 	hchunks = i;
-- 
2.47.1


