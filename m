Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FE9AC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 12:46:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1BE6B007B; Wed,  6 Aug 2025 08:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 078F56B009F; Wed,  6 Aug 2025 08:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA95F6B00A2; Wed,  6 Aug 2025 08:46:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D99D86B007B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:46:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E03B815A9
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:46:55 +0000 (UTC)
X-FDA: 83746307190.04.943E9C1
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id 05DAD1C000D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 12:46:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="f/RvTxEa";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754484413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T1dSRtgDFd3rpqxp+UUfdWimEpYJ/LqTvkYYD4B7O4k=;
	b=I7BYad/869CIPcMxm3ju7dtdEqMdOj36QK1T/A261lqYlrRjPeadmTg6ZbqnQZVehf5LJK
	FXTac+ZhHgMdQa6H4vTBhLRV9b9gHM0Q5r8fedss5uHKNdti0IAXB+Id7D8gr5GCcU2CHq
	mFz1b/p+PNdfioCZoZTJ0owh0NOb9G4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754484413; a=rsa-sha256;
	cv=none;
	b=ugNPmKuYzwucSSnnUZZjn4u++HSXnu+p3iN0dX159N0ZMvHlQHtrRyqsJHrhGenjzB8Fp2
	jPzzIGmY2ZVP44Dia7abFLAsHM5ckX/EygnOTripOqkrehPRfuHJ//odNyx/2AlQW8XSLz
	amndxaxqzCg5VK7iUFzjKi3OuZyG1vw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="f/RvTxEa";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5766tGP1019487;
	Wed, 6 Aug 2025 12:46:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=T1dSRtgDFd3rpqxp+UUfdWimEpYJ/L
	qTvkYYD4B7O4k=; b=f/RvTxEau8SN2fssUaIC9F7Sh/HqM6Kiu6JNkM8obi8oLa
	UuChkgmYk1dj2Q5eSVXVjOr0H4SNoYDL+7/etP9yePdhfGy8w0qJWS1F8+45ZurL
	NYYawB4BX2dr593ELb/jIa0f8vcjufBuIXpDtj5II0rR4K51MFEnzPX3slqbcrK/
	fljI5dhROdhUW7Q200nTzNdrvyFwEEIThDEEHw0H00MyMU6ZpJqZSyMK8x1A0aXO
	2XrHbjTLQsQY+3IE6IzkfngQAUHDyvDTnFmwpwZFUNttx5PG3zxFrVdL5FqIZ+y6
	rT9uoFTsDfM88k66GKC65l3TJ+yXf9HwtC95clHQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48c26tsfj2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Aug 2025 12:46:51 +0000 (GMT)
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 576Ch8nb006741;
	Wed, 6 Aug 2025 12:46:51 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48c26tsfht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Aug 2025 12:46:50 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 576C7PeT020616;
	Wed, 6 Aug 2025 12:46:49 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 48bpwmuktn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 06 Aug 2025 12:46:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 576CkjLx50397510
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 6 Aug 2025 12:46:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A6EC820043;
	Wed,  6 Aug 2025 12:46:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2664620040;
	Wed,  6 Aug 2025 12:46:45 +0000 (GMT)
Received: from li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com (unknown [9.111.70.156])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  6 Aug 2025 12:46:45 +0000 (GMT)
Date: Wed, 6 Aug 2025 14:46:43 +0200
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH v2] mm: fix accounting of memmap pages for early sections
Message-ID: <aJNOs0IB1d33GSSW@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <20250804151328.2326642-1-sumanthk@linux.ibm.com>
 <20250806090320.wdt4zsfiambtgkvy@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250806090320.wdt4zsfiambtgkvy@master>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QEnwZJtDuhjBjmp6iHB0OJwXK6H_odhu
X-Authority-Analysis: v=2.4 cv=F/xXdrhN c=1 sm=1 tr=0 ts=68934ebb cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=2OwXVqhp2XgA:10 a=vht8kvy_zf64N8Etz0IA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: e9cBLpYsr6FVqWELpOywZJCGpor7R9pg
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDA3OCBTYWx0ZWRfX39J9IwK7GjJa
 fuy4krFDha5iWSbaOR4YZiIyUFBi97WqF8mXqW8p7iZdfag2Xt7bHlq3mnsSorxzK18v+dazKS2
 xPLN6NB074jvqvq6g5pllnuiXDHBm7s6Rv1B248EKM0kunrasU5zqaQ4bU4wXJbN0gMNQdATSbv
 L0n6ECj64I5cvnFeQDLVXAIqyicyRtfZ+zfTLgrmDtFhsAyNH9rhA/A0PibOHC6rCKyZk7lWMJy
 bUEdw4N4CTaiwv2ufxaFkMKk2sXJGKSA70pYnE4wcNbuXTeucP3jxiQULtbIiUynZUbntAB9Ww6
 LjbQuisamnyMASmSgUJfE21Blm6vQmCnPOEHw/97SA8W4K7VSOjXDL3hg1NQ39Rn1psgZwl8wpO
 EvKnc2Mh++6IGa1SadLdybcEXMDW0fvNnJTnJt2I8/VdG7lYUAEGXlMPu8weRF3Z/prLNY2g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-06_03,2025-08-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 mlxscore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 clxscore=1015 spamscore=0 bulkscore=0 adultscore=0 mlxlogscore=713
 malwarescore=0 phishscore=0 suspectscore=0 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508060078
X-Stat-Signature: kqnjeb668578ddekotp7a3wiocmb1kc1
X-Rspamd-Queue-Id: 05DAD1C000D
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754484412-103310
X-HE-Meta: U2FsdGVkX18pRuPN5LPbMkC/slIwpQJT6PXqvybceuMrXmNjd1AlhYaeCP1UBfl9VQ23WpWmCxmtLLBDepYGfR/C0Mcl0tG3GjQ1i6o1qRrLQlU95EVmvI8bza9bG4ku6MJCHXymBVMjK5ClhtbeAaQkJTXNlP4wmadY6XHPotoZb8Ne6CSY2NyXMR8PjlblrfvQJ0VkEyTdVFRykZOm7O1/ZQp3tZwxrcak6VgtZBuinyYTUmUe0flL12qXlSASnIX2cZHL0JRGqRzbi3YwqQoOUEdW6WLt0fT+d505GZcfWJh7EUeFFwNkzPIswtxBlNN9gtVWpODjMUoOukJKU2vvJKHgyBlGqCtgXIzRiUKi830BQedvilrsj3lvMaJTdzMfS8oAYv3YUYuwmcvyaggxDyA6P+nFKugXKFausvgqzVHXmwheX3yJkNkzDHU6CC06QXMOD9KW4LoPIqEQhHDxw01cMA6YJBGRarel087G8eVkQMPb3K/OTFPmYjYfakdxaTbi8z1YihwOxHYe0R1bvmjfcv64kpPS+wlWnPD2N/Gem6liHr4J7qkcQjyTnI7bTBl/LK2sHyQEJ/tI1R2NImDZCYhIKTHxeRdhPVlu5SJxRvgty/6mC7uRwkXnGzWceXWO2bmd+01NuzEjaqMxKjMZFX6ETyeLfjZFEXOL+3nk0zAoJKPzN7z5mrT25z1j2rTqQAsK9cXllw5sX2jFC/rXTrMN3c26kp+HFBY4GDyvcCiXiu7NPUcBMzCyJ77Ksa5fEdEKmp9zTA6dFpc3WwxU9rbZzFkaH4cx9yEjsb0jicn3Kw/C0Z+6lpW98o3X8BdXvLQxy6I4dY/fsF8YZFCNsYZKelhTObHi6cEdVrBJ2t+6A920ZwEg5xlxpfn5iEL07PxWCPvVkp6Lw/dgU5O/d1wpfAjwBgtFC9/FRlb/PDj2mtOvRatRFiHjHz3SyHqK+eBEl1qYu5g
 86f9E6J8
 +/X4ex1oVNT/lGKIsKsNe5SiOS6z1KBV40G9aK4PXxvqPaB2/G0xbyrkLg/GR7T5JVostUOCaO74vMWnTo4USFqizAvSGUYfzHBt4S/m6ty34JteYwwChv98VgGRogBdb8wcvxqRvSLbJljaLtAYAmn65mC3OJl5bkJcY9KaDboqaPz1PYf1SqlHSvndmq9x6elLSwo6iS/SnYkv/pfBpOmT0gYIUa74YUE16MhpEnqo83xRePGTj0DJi6Hq9nv+tN74kgudGpkBPOBbgt35pwKsst3tnnviOf4jRKiSdX7gjwxg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The change here is reasonable. While maybe we still miss the counting at some
> other points.
> 
> For example:
> 
> a. 
> 
>   sparse_init_nid()
>     __populate_section_memmap()
> 
> If !CONFIG_SPARSEMEM_VMEMMAP, and sparse_buffer_alloc() return NULL, it
> allocate extra memory from bootmem, which looks not counted.

Currently, the accounting is done upfront in sparse_buffer_init(), where
memmap_boot_pages_add() is called for !CONFIG_SPARSEMEM_VMEMMAP.

The function sparse_buffer_alloc() can return NULL in two scenarios:

* During sparse_buffer_init(), if memmap_alloc() fails, sparsemap_buf will be NULL.
* Inside sparse_buffer_alloc(), if ptr + size exceeds sparsemap_buf_end,
  then ptr is set to NULL.

Considering this, perhaps memmap_boot_pages_add() could be moved into
__populate_section_memmap(), with the accounting done only if the
operation is successful. What do you think?

>   section_activate()
>     populate_section_memmap()
> 
> If !CONFIG_SPARSEMEM_VMEMMAP, it just call kvmalloc_node(), which looks not
> counted.

Sounds right. This means nr_memmap_pages adjustment is needed for
!CONFIG_SPARSEMEM_VMEMMAP here. I will recheck this.

Thank you

