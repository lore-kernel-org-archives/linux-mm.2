Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 579E6C87FCF
	for <linux-mm@archiver.kernel.org>; Sun, 10 Aug 2025 13:38:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C00E28E0003; Sun, 10 Aug 2025 09:38:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8A4F8E0001; Sun, 10 Aug 2025 09:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51F78E0003; Sun, 10 Aug 2025 09:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 883E08E0001
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 09:38:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0593E59318
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 13:38:01 +0000 (UTC)
X-FDA: 83760951162.18.A464DB3
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7C57780009
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 13:37:58 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mw2w8paM;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754833078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D7bLjFL6R/Q9uB4qwTKOFnu7RvfXn2IQ4E/SNr7xIDg=;
	b=O0ok24HkLuAK9AnC5k5HXR7WgtDRjrP75il8lCe7ZjoQIe3V3Fr8hkZZtNYlf6/9AhCi8G
	u1yXnTpKR7oIFTWfJitdZIN93DNAv7HqsyywpkV3S1gfKOtV4ehdWtO8yo6V6HJs73wbzi
	hnfOY/xCdWDvdLIaNA4hQ/wPYbGX9H8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=mw2w8paM;
	spf=pass (imf30.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754833078; a=rsa-sha256;
	cv=none;
	b=cH16SyMxT1yMaHFNnSOta5m+yNbRCfaTPT0Fybfc4PXSiLokiFRg0kTyCQnsdH9Gx6xd/q
	FyeWBKK3Q5IqenmuzQZe4o3CPmpzeG0MP0m0mk95xE3PlIDX2Exep34uemkODaU1xCzuN9
	pQmHq5Y/ybuvc/ey5Hgx5+JgDPRtiAo=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57A0tUqh005822;
	Sun, 10 Aug 2025 13:37:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=D7bLjF
	L6R/Q9uB4qwTKOFnu7RvfXn2IQ4E/SNr7xIDg=; b=mw2w8paM1fRpw13GyY747e
	Lz5qJRNZrIHMUJ7aKTlhmL6m091313mm8voDLFFDFTkJE1z+D0I1cdIFhfrBl903
	UV14XcTwRPx7X+o4O9zEgp0CEQwtBFwVMq/RbqiUtsLjo19kdsjO/ADwsChzBYL5
	yWis4JGQLC+1joeykIvKcqUC/EsITNBb8wKJ/xYVw91R8LFmkYmEt/2FnElKa7Fy
	nfSYXTHm/CbdW972koD4xmaeayeqMpxjcTHyYOxmq5JzGJwezIQUXVYnhLtF3GVw
	TFpcBsAC9rpRUEwIlrmz7zhGmNsxOMZYIU+Mf814LIfpKg4dUhH6U3mm7NhL/aKw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48eha9ss86-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 13:37:55 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57ADbsOl015672;
	Sun, 10 Aug 2025 13:37:54 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48eha9ss81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 13:37:54 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57AC4t0r026485;
	Sun, 10 Aug 2025 13:37:54 GMT
Received: from smtprelay02.wdc07v.mail.ibm.com ([172.16.1.69])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48eh20t4c7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 10 Aug 2025 13:37:54 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay02.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57ADbrep10027558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 10 Aug 2025 13:37:53 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B639658050;
	Sun, 10 Aug 2025 13:37:53 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 532E058045;
	Sun, 10 Aug 2025 13:37:49 +0000 (GMT)
Received: from [9.124.216.245] (unknown [9.124.216.245])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 10 Aug 2025 13:37:48 +0000 (GMT)
Message-ID: <7fcea8e2-4393-4a21-b6fc-39b853f07d3c@linux.ibm.com>
Date: Sun, 10 Aug 2025 19:07:47 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: do check_huge_anon() with a number been
 passed in
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        Baolin Wang <baolin.wang@linux.alibaba.com>,
        David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>
References: <20250809194209.30484-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250809194209.30484-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=KPRaDEFo c=1 sm=1 tr=0 ts=6898a0b3 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=pGLkceISAAAA:8 a=SRrdq9N9AAAA:8
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8
 a=Ikd4Dj_1AAAA:8 a=ktfKDUQsDJOdS9iR4bQA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-ORIG-GUID: ijnXgxkVvTXl2cVXx0w5J98Pa-1MSBpS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODEwMDA5NyBTYWx0ZWRfXwiQS2kfLGXaC
 JebGCXSWTBDARstNpjroZ0vcl2aQvcKpjH3E4XW4TMDD8AH3U1iTV/UC3GLAaNLRv/2naiH11GI
 ewjeHzKDU6rEWRkcSa3VDqO/CNBRMrLLRIKOz2pypfo1Xd93x+thHXCpUPV6bvAd2G0uNVzpnbk
 0gelC/fJR82FrGkKey1OpXn8L5/2pY8aW+kNJ0ewmLI7fjirdW9LWqt0vXyWj3+att7LXjOeZzo
 EdKqz2Y2a8xOF8PANsTrXi7YKfuAwvsCDDhXUGeI5bmYSDkZxJ/gEQ9vC4ez3mQiFjfXN3fFlC2
 nxSnX77+ihW+ib0BEBucL8WMuMOigFjn4I9F0ExBxzhOfJWTU7P3M72t0BWNxYubxvD2Dl2YNVC
 wahVzIpe9f1ZM4MMhnqlaxYSLpQysnquX3X7V7ebVdijWUtKs6yUeh4UeQ+bKjwmyYC25OQP
X-Proofpoint-GUID: 5TJHmXUiqUs4UUV5oHllXv2ASL_R5ug_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-10_04,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 impostorscore=0 bulkscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 adultscore=0 priorityscore=1501 malwarescore=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508100097
X-Stat-Signature: snzgy8eetrrhtn1kdr871u5go5gsgcz7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7C57780009
X-Rspam-User: 
X-HE-Tag: 1754833078-395058
X-HE-Meta: U2FsdGVkX19sI1o4EETmene7lyMKR4uPE5a/92DglDn2tSWEM2L/q2B3/XNYTwBKFtMtbsOOG1GYbIyrhsBC0XvYyyjSQEVEy2SPXRdiUHGVtbf7uZQqIQTzhIRNUFZQsjGMyzOGXXXCNZfQQzx8vPYVY2Ia3xfrqRG9F0uLjKwMXh0Oto5GQ1VqltrDbo/9rlMg5GXV9DmZjVwABS5aGZhiPiUROsc2E1t4VvyQzZ5iV/thpDJKoSECUwiE/tWsDvGzexg+m9wQOtEWg8ZDnNEsVkFLwaRzG1F4F2H7sK3Ngl5pKQzYSUiQtBNReRjFkgnAlOA7qvQ6Bxm/dI/64SUS3JDNOuAHTenEdCUCKjPjeKlOsUwNBRChPKP/aBy5a8zj5p02FKDfb0ecpcU8DjHPufWGw5LBoMySPhoOl1OEPaEYV/0vzL7Jt13vJx5zF+4aWrSZbAvygctEOuvNfP83tKD3rPbJu8Cwz//dAbaLHh07FDDB5efvrddWcdgxSeJaapl78jZp83thkFUgMExIZr406sTUZFNKzRjcqFe+/8pwTpTy2OxfGZ3+HoVDZn0WsWf3WsyPt2kMYSNwb3uAGcvtziTodb7Ip+Qrsk816v0/fXSEiXRqs+P/CPEq/R3G96xRXTaXlQIPixOX0ponA9uAeIla519BXpHmLIJhl2T7w/XBEzV8gAgfcCSfV7kaRETNfTJtVomq+AHdZRm31skIptvHfNyFTAInAOrmzSyfTQSDYhoOCYCSWl47vrdKnxaSIoy+eDPenzmahRJarfn1kVENP8+8o2AkxQBdvymzYv2uFTkbaY7ext5mnQcKIkMNCThgkD0Nw7CT/B8KnKb3GMZHHdXDy++aIt89mHYmqHD8RfHthZqiJtptaERSEWhz4XFLEWm+1imNcVlZzHkkXWPNHEUhPwfHUtHFBPZoKiO6+2PRJD0ULiVcAsXE2ENPmWTbGFgcQWe
 z/4o1AJv
 /YP9e69qiy9peRsR6aceuL7u1WxUGtMpvb6wQm1XVmPrw/Xvd3ki4LtIYwi0w3XJHKaZugHmFieYzeMuG6E/DgOd2F8WTmf3hS8vcI/v8PnC7YlhVDaInB+BpwvWLLsW3j85pWfO+oYXKILjwV10m4Ga6YID7PMl5MDZDkbh2mnoJO7sl50cMBgg0LSw5xURUsG3G3/6EFWyV5o5+Zo/Hu0DNO8DbhfHCk2Svaftf4HqZn8Z5RLsk1mmwbBp+YNphJgh2VsWqjtO6WYi8HwnEDZ1v/wV9Vg8Igkid6/54laQudrrSKo4QzFUyU+odIXhHyuaA2cXaUGHO2MPvfxcuA2Wm5YWAefyfSLwubh5+vGiiTA6yaxacr3MuV6ELjIYRwAMa7VOeEsoN9CXHSODPeMvytVIZF+RD+m4k1G079J3OFJkbSshjvAkPN94l22tNnml1oJ3nRs0fb1S1GZ21DDhB0ETiJxmUKcc+pjoS2TU/h+QqRWglGpcLQN7qfLsCnIXzIn4Fkg6P87CvpIvw4/13kRS8sIgTsHK0dM0xYLID84RiSskjOY/WrNNwvPjDzSSH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/10/25 1:12 AM, Wei Yang wrote:
> Currently it hard codes the number of hugepage to check for
> check_huge_anon(), but it would be more reasonable to do the check based
> on a number passed in.
>
> Pass in the hugepage number and do the check based on it.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Donet Tom <donettom@linux.ibm.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
>
> ---
> v2:
>    * use mm-new
>    * add back nr_hpages which is removed by an early commit
>    * adjust the change log a little
>    * drop RB and resend
> ---
>   tools/testing/selftests/mm/split_huge_page_test.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
> index 5ab488fab1cd..63ac82f0b9e0 100644
> --- a/tools/testing/selftests/mm/split_huge_page_test.c
> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
> @@ -105,12 +105,12 @@ static char *allocate_zero_filled_hugepage(size_t len)
>   	return result;
>   }
>   
> -static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, size_t len)
> +static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)


We are re-adding this argument because nr_hpages should be the same in both
split_pmd_zero_pages and verify_rss_anon_split_huge_page_all_zeroes,
correct? I was just wondering — since the value is currently hardcoded
in both functions, would it be preferable to pass it as an argument,
or keep it hardcoded, What benefit do we gain by re-adding this argument?


>   {
>   	unsigned long rss_anon_before, rss_anon_after;
>   	size_t i;
>   
> -	if (!check_huge_anon(one_page, 4, pmd_pagesize))
> +	if (!check_huge_anon(one_page, nr_hpages, pmd_pagesize))
>   		ksft_exit_fail_msg("No THP is allocated\n");
>   
>   	rss_anon_before = rss_anon();
> @@ -141,7 +141,7 @@ void split_pmd_zero_pages(void)
>   	size_t len = nr_hpages * pmd_pagesize;
>   
>   	one_page = allocate_zero_filled_hugepage(len);
> -	verify_rss_anon_split_huge_page_all_zeroes(one_page, len);
> +	verify_rss_anon_split_huge_page_all_zeroes(one_page, nr_hpages, len);
>   	ksft_test_result_pass("Split zero filled huge pages successful\n");
>   	free(one_page);
>   }

