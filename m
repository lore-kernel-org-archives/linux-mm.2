Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25F7AC87FDA
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 01:48:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52C56B00D2; Sun, 10 Aug 2025 21:48:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A886B00D4; Sun, 10 Aug 2025 21:48:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 940C36B00D6; Sun, 10 Aug 2025 21:48:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 84A726B00D2
	for <linux-mm@kvack.org>; Sun, 10 Aug 2025 21:48:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F0F21A0646
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:48:53 +0000 (UTC)
X-FDA: 83762792946.01.E795DD4
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7F99940007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 01:48:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bSjrrvCe;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754876930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOOGBV9WpZdSOZm+mTzaSHBA9jtgFEQKxJGErcxreK0=;
	b=GJNvaTR74yaUWHrbwxK3cxoZdLRNhLYWl9OHarQsfsA4ZoSZtQmbT2tCPkFk+ZnTS5O6Z8
	Tm75B0xX1OzpWu4dDWBoF1jlGOHZbH1V8O9lXJbzcN0P7a9LmAQCh2PQVvkun7+pRRYqC/
	Xk6T85SYTiV8i7tJjyPTA72VsQIVop8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754876930; a=rsa-sha256;
	cv=none;
	b=DUIWxRoEum0IpM50MxTj+R1teqN8nlL+3MlVG/2d6vwOz7BqJMwMv6+IIkB1UadOwMgs30
	vEWfqVIyep/pH7dm0DBaEt98RsVZUuSmgJeyLal1Ide+e8z8012aHWxN3Pcp5Jzkxf1MhI
	VISxm9vHPCLL7Z84d0kBURi6tdZNxRk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bSjrrvCe;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of donettom@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=donettom@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57ANdYRV007051;
	Mon, 11 Aug 2025 01:48:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=lOOGBV
	9WpZdSOZm+mTzaSHBA9jtgFEQKxJGErcxreK0=; b=bSjrrvCeDEHMQd6QLlfCxa
	SbrkHbZzxz4RkgxzrTjnzC94ORVpq/t+O9eBjOPLBXbpx4BYA0hhrrkFEZgMYLiy
	SEG+S0A79dOl1upLkPjNrlfq8/szZ14GC6BDqfLTq5o4OKLNo0t3I86l+Q/Rcfx8
	2vkzKJl5GhxS9C0PXnVbR/VoTSsIXW5c62Vz8No34V0gcoHz9OFaNIHi+nKeSHDc
	jzKoRWbetf3BUJUU27pVXQElzWShQm4wLAytTwKTAt4ZKx23KaicHYqOPIVTlKYC
	1MldFviDiO5mZ53PFLcGyJU8Zna5HDf5h/LTXMbnUa/3Sv8usb4tqJSD/+uy4g1Q
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx1471s8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 01:48:46 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 57B1mjlK009126;
	Mon, 11 Aug 2025 01:48:45 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48dx1471s6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 01:48:45 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 57ANSCVT010622;
	Mon, 11 Aug 2025 01:48:44 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 48egnuc2xr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 11 Aug 2025 01:48:44 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 57B1mh3s26608196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Aug 2025 01:48:44 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D348258056;
	Mon, 11 Aug 2025 01:48:43 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B6BC5803F;
	Mon, 11 Aug 2025 01:48:40 +0000 (GMT)
Received: from [9.124.216.38] (unknown [9.124.216.38])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 11 Aug 2025 01:48:40 +0000 (GMT)
Message-ID: <9fbc3206-3bbb-4697-959f-e413c4d3580a@linux.ibm.com>
Date: Mon, 11 Aug 2025 07:18:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2] selftests/mm: do check_huge_anon() with a number been
 passed in
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kselftest@vger.kernel.org,
        Baolin Wang
 <baolin.wang@linux.alibaba.com>,
        David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>
References: <20250809194209.30484-1-richard.weiyang@gmail.com>
 <7fcea8e2-4393-4a21-b6fc-39b853f07d3c@linux.ibm.com>
 <20250811005359.v2t75i4nhdyj5ev7@master>
Content-Language: en-US
From: Donet Tom <donettom@linux.ibm.com>
In-Reply-To: <20250811005359.v2t75i4nhdyj5ev7@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: wqzRUrzAXy4utWGrlgyUD3ZQBXuZT-mY
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDAwNyBTYWx0ZWRfX8waS1pYfHfNg
 BWoVIi6jdOl0ChzShLej36lpc3fSEpG8ghSkiSN5DCAFBIVNwKRJc5p+ifhhi33bkrPytp57DNT
 mIc5N2eT0tbCetqdQUXTdeqbqJOZqyiSq6b4K9g8Tgi0jR9olHqPV3EGAIQERbXZ7AucUi86b7i
 2h4w+1wlCTW15p0qmy52B67sZ6PTyg8o9ithz+3dasHojPGChxzpTSiWx6/Kmm/aBqjq/faStcY
 lH/IL4Enb0NqCu4/nBMMeyaZryUD06tergCHnMEcm3/D0JmT1YR57XbOeMtoqbL0G8sZR3rToxB
 nai7GgK+jopsJTvs5E3khEek+OvHDnbUiWVhbVfpYvfxYa4yuGHFGWlAamU92hkPhchCsS9UzVF
 dIcNR2XZXjxaj+e2TOjS5jiKZ0bjN45J6sxbVRtQ49XJArIGTyLTbQrDDJr9+AIe5MGQwC4d
X-Proofpoint-GUID: K61ixOpEdzqEo1x0UnSmxXM-WgW8_G2P
X-Authority-Analysis: v=2.4 cv=fLg53Yae c=1 sm=1 tr=0 ts=68994bfe cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=pGLkceISAAAA:8 a=SRrdq9N9AAAA:8
 a=VnNF1IyMAAAA:8 a=20KFwNOVAAAA:8 a=7CQSdrXTAAAA:8 a=yPCof4ZbAAAA:8
 a=Ikd4Dj_1AAAA:8 a=cYopgATv1J4xzT-q3MYA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-10_06,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 priorityscore=1501
 impostorscore=0 phishscore=0 mlxlogscore=999 malwarescore=0 bulkscore=0
 mlxscore=0 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2507300000
 definitions=main-2508110007
X-Rspamd-Queue-Id: 7F99940007
X-Stat-Signature: ixbkjzi67bwcxksmkonriwqmzf5pjmjq
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754876930-189716
X-HE-Meta: U2FsdGVkX19Ayva9ZaQRL3GW9ChPB3OS0hUK2WFXoHtDIE8yI1oC/5k5DnVjdBgd00/W7qHC6ZNMx7PXoEGrdqQAkKhoSABF9v+tjI3J+TuLGUnC3Adg93njTc1rMsiyl+XJxNErE8bc8DBrMtdX4xhoL/f9DR8E2UTDxcFcq5s9IVdPQ3XOmsxX1/P+n8ytSpR3l6MxxlYH5Zvs8/CuaOZ/vkIOJdleIyCI8tf0kjjeB5VkJ9zwX3DvjDzo83zu6S3quf7o5OdPHjOVnCSwVqcXOiNUejhDYqZoJ5/SZHlJtpaDBap8pkVJ/ae9y7c1+SsGbaV3bOcN6dmjWUhRseBZhX8uXVSxTQwudb1JMrb8Zl2xCU61z34Vg1bh9ANkp4iRd1/Jb2z5OUdBdUVKcdLTRNRXMEt8utqNCAa02dzJpDibLag7ffl3K8fyw3lWFDiyoytupl69JiEkqbmR2jmfT8GRvMGA3DJWHY4+RvMEvcPuoiCAqaUja8fNbvhvm27bipQ1z1AJaNvZ9NRpJDQbCQv9nMncEye1hiMeVeTTbpIIq4SG3a/b8vZq4TZn4ATVq0ckA6AETq6mE2DXZ4ugJOC1pZkK0Ba/O0SH4HlqtUlU44Vmy135aqKKEWK+SB4kMcZsaXuUEfYJd6/or8iWYobvx8BP/trqv9BZwL2BkjgiwcPhXO287m4iCJa0uDXhoV5w+GDjor2OY5rjtEu9W+csm28Vhlqk76thoXSi5+fR+Jf9yjmh0C7foN49DbgaVBDRIYXkNEvmZERQ+Nu4bMkWPOgDo7AUvVph83clZMODYKA1JJGMFlS9j0tSxBji8UVUahQGh/WQSSm2EEKa+kg0IFYpuq2+C5zVyf3eBJykyZYT8VuJftWceXVvBZ/Vg6L91NZn28K6E14XWWrazd3tLdfJGZUkdU/7a5d2eOriZrtCACUM3LcWkGb11kHkskuu06pkzYXfJ6E
 KPEkQQln
 BnBPOq/BcrPjoc6/bzTuaxH8JcStRUK26HcAGdR+/zS2cSlsFp/D/nqRenqYOtSDzugoAVrjcyD5WmqagCbu/QtTgFm9SEtVymnnUmCe8a/F6/ilyJ42LYteLGqpo0VfTsc4kzqxf+FwtiDB0HgU5m/fuvxsS6vD2962/xsCwa0UcratK2Wvu+NBRjZ+CCokrrHMjtVOoERWfICcWYkyAFA7GdfuB3h6ajmht6fUZ1y8v2mCmnPpz9CJfI/rfO5OrfKQrhIUYJVTRrpmjUNVPp1fHJQgMpNM1oL7EfZv88pS+zOMm/H6VulJUVA9EPoS5nF+nJ8njDt749Y9SBs4HWeq0fFm8xYSW8ziMy1xB1fNLQrhcH9SeYhV2qmhfAsHkbn8Df+oR9gauuVrG5NlpSRFhLLUWkzULnNxhFiBsYtH6Z1IS93d70TepxXEX/uZoUqE/fW7k7buSRKhRFOjzzFk7b2W6bV4WhmHF+7z4C+wJhTovY9EjQMx2YDa34zhjHhbkcr9H9FYrBXddhsfesJeHP8AXk7HnFpNehiBJGYVosIDRvQLcz/scbYTGhu8F+ba8f5tMuQCfFPq0tY01g3iul8ApR1XXzA5QzbGZhKWoP/tD82Mzx55yqRBkeQn/edaDe2xaId7fnhqMPUoW8PEq9u9J6SWSiDfHgDMR2qDfKhonP2A1JpxfqlrZKCgapoFV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 8/11/25 6:23 AM, Wei Yang wrote:
> On Sun, Aug 10, 2025 at 07:07:47PM +0530, Donet Tom wrote:
>> On 8/10/25 1:12 AM, Wei Yang wrote:
>>> Currently it hard codes the number of hugepage to check for
>>> check_huge_anon(), but it would be more reasonable to do the check based
>>> on a number passed in.
>>>
>>> Pass in the hugepage number and do the check based on it.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>> Cc: Donet Tom <donettom@linux.ibm.com>
>>> Cc: David Hildenbrand <david@redhat.com>
>>> Cc: Dev Jain <dev.jain@arm.com>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>>
>>> ---
>>> v2:
>>>     * use mm-new
>>>     * add back nr_hpages which is removed by an early commit
>>>     * adjust the change log a little
>>>     * drop RB and resend
>>> ---
>>>    tools/testing/selftests/mm/split_huge_page_test.c | 6 +++---
>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/split_huge_page_test.c b/tools/testing/selftests/mm/split_huge_page_test.c
>>> index 5ab488fab1cd..63ac82f0b9e0 100644
>>> --- a/tools/testing/selftests/mm/split_huge_page_test.c
>>> +++ b/tools/testing/selftests/mm/split_huge_page_test.c
>>> @@ -105,12 +105,12 @@ static char *allocate_zero_filled_hugepage(size_t len)
>>>    	return result;
>>>    }
>>> -static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, size_t len)
>>> +static void verify_rss_anon_split_huge_page_all_zeroes(char *one_page, int nr_hpages, size_t len)
>>
>> We are re-adding this argument because nr_hpages should be the same in both
>> split_pmd_zero_pages and verify_rss_anon_split_huge_page_all_zeroes,
>> correct? I was just wondering — since the value is currently hardcoded
>> in both functions, would it be preferable to pass it as an argument,
>> or keep it hardcoded, What benefit do we gain by re-adding this argument?
>>
> Thanks for your comment.
>
> It looks the correct way to do so.

Thank you for the clarification

LGTM

Reviewed by: Donet Tom <donettom@linux.ibm.com>

>

