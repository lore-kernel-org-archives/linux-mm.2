Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA41C531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 07:12:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C271F6B007B; Mon, 27 Jul 2026 03:12:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6C26B0088; Mon, 27 Jul 2026 03:12:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC93D6B008A; Mon, 27 Jul 2026 03:12:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 798506B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 03:12:18 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E856214064E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:12:17 +0000 (UTC)
X-FDA: 85033687914.01.9715443
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8C55E120005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:12:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kWgRwHNB;
	spf=pass (imf29.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785136335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCeXRe/Hry7MdQ88cikzSeLz+hKeSIpTcGWcp2hlud0=;
	b=zL9SO4Ya9uYxYPE/Etm2DWanhOYg+kbL2Em4cYjn/JNAMi8wyeuI3AGIKARkMbNzs3QJKa
	/3ldcA0Qn0a1YQUwG4UulpF34LS3vipQuIguUz/vIUK1oNsxhGLAZLkwlPLYFoqyKu6SGa
	QYneRX8m76mSIHsWPrb7rbyMvXyDE5M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785136335;
	b=vM04xyq1ML9kAObUb/mifhI61TO4tyQuEvF1tiEdwlapI3sv0AQ/OwzWoGSoS0k7iLYWoE
	MkT2gZ9RjQ6YUSMUsCOtfojcyFlXc43aDjoZtmIoei7UxxC6KiTzPsnzLdOq3omY0jcGrH
	UoBbU8sUIyTEAv/jww1J4zWG6UVqZrY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kWgRwHNB;
	spf=pass (imf29.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66R1mMjw892714;
	Mon, 27 Jul 2026 07:12:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=QCeXRe/Hry7MdQ88cikzSeLz+hKeSI
	pTcGWcp2hlud0=; b=kWgRwHNBDtWsKFZKCpouNYj5NpD/zvtNLONhElFdevMOKK
	Or1UJ22JF3ofKBYK5fC6ylQCbKEfiUH5bxZGlk/9b2+WiWmvIgMwNoltIzLl9vLw
	Ckgd7CWg11Klq5IKH33EFiFFY7GDW1r7+LTF+jcvj7CBY27RqEr7oR3OHsIe5BY5
	r26YD+1dvF24id697zb/sEm7xPQi3NfuPzBXPuvrOdgv5RI3VBoNJqJjnj4mL2VR
	HLGBcY6ExuvEnNq+eOXBjMXtWejwHn6AZh6ogY/bkjaie1r+dM9zgGLrhpyVqEDp
	0BnM/p/d2j2KkH60Dkv4gPtwCYY4Hy/rQhngJ21g==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0xenjj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 07:12:00 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66R7BMrB012169;
	Mon, 27 Jul 2026 07:11:59 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yh48f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 07:11:59 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66R7BvoR42598784
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 07:11:57 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3060020195;
	Mon, 27 Jul 2026 07:11:57 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 760D22019D;
	Mon, 27 Jul 2026 07:11:56 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.87.142.159])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 27 Jul 2026 07:11:56 +0000 (GMT)
Date: Mon, 27 Jul 2026 09:11:55 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
        Pedro Falcato <pfalcato@suse.de>, Ryan Roberts <ryan.roberts@arm.com>,
        Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Mike Rapoport <rppt@kernel.org>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Samuel Holland <samuel.holland@sifive.com>,
        Kevin Brodsky <kevin.brodsky@arm.com>, linux-s390@vger.kernel.org
Subject: Re: mm: opaque hardware page-table entry handles
Message-ID: <31f2d132-34c3-47b8-a8fc-4069247fdb69-agordeev@linux.ibm.com>
References: <74182e50-b54f-4d2d-a27f-3a59a538d6bc@arm.com>
 <31d36023-d728-4eee-90f8-158c7066f565@kernel.org>
 <e22407d8-4509-4a53-9ba4-491b9d5c5ef7@arm.com>
 <4bfeb697-9c1f-4316-96bb-9bfd66f959df@kernel.org>
 <6110202c-057b-4701-8c04-1a76ee7bb9ab@arm.com>
 <20260721124057.2820903Adf-agordeev@linux.ibm.com>
 <3c21586c-0ffe-4ebc-97f1-803e8acfc5c1@arm.com>
 <650903a4-0dd9-4e6b-9d4b-3c32c5657236-agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <650903a4-0dd9-4e6b-9d4b-3c32c5657236-agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _qk5aXwUKY5pIjidqreOLKbeyvJrTdkN
X-Proofpoint-ORIG-GUID: _qk5aXwUKY5pIjidqreOLKbeyvJrTdkN
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDA2NiBTYWx0ZWRfX5lPjxtYyfQ+H
 AMCIwsCLTrDatIj+fI6eAC+G2NVhMopjrjt+V5a9wZguRTlhqIe0zkgft6cvcbtJf1BCLd2F/QI
 SjrRacjYeyvdbPnTKCwjNZW0jswJ9sA=
X-Authority-Analysis: v=2.4 cv=dYuwG3Xe c=1 sm=1 tr=0 ts=6a6704c0 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=7CQSdrXTAAAA:8 a=VnNF1IyMAAAA:8 a=vBBeGr7wKhRbixmBnZMA:9 a=CjuIK1q_8ugA:10
 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDA2NiBTYWx0ZWRfX8hrAA+YvndLv
 FYh303fupRJXIDnwHzo8CyCfhAh6p8b66CFWSVqSChe86cmtLEs+Tu2RrNmijMrKMz2yayNXo7+
 F+ADiG2Dbrc0qK++M/A/QnEE1BPTqcL3K165UUZ6TYZBWvPX4sClUSY4eY6CNFfhlulWPKl3U6H
 mkSy1ujyivFG1HQobPQV/dU8sT5Btq1XaO/Wc7lsSB/jRnSoQANxQz9k+bDuel4n1iHMWm8Z7ML
 9hUQEAgl7nF+kdReEFA+dR2zKMUweS3bSgB4EGsViWa98rcIR9zXYk75aoeYElluAysxTzLoffL
 dARWh8z+/Dc+C1CC85qPYENCKbcAru0NfK9Wp3i+dwxSfylH+myt9dRzUI38XL9tOnn/6Vtsi4z
 fOGUvP8Oyiaz2q1UXgeq68C5lFOIXcJZd6eEfWNDrMa0LcA6mN9tWvp7VDUCJs+c+pruW6HCl3n
 Adkz1Wp7MypDreTLohQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_01,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 phishscore=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 bulkscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607270066
X-Rspamd-Queue-Id: 8C55E120005
X-Stat-Signature: gaitxqm9mxoxzgt8pgruaahwzn3anix8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785136335-556361
X-HE-Meta: U2FsdGVkX1+DZ8z/TGAbGBfx5Mc+LmeSdsayw5h7iVPgSRdiq7U1GV8QCyyfC2NWXm101h2r/8nUC4P7moOeC0IsnJwVmi4S1Q8/x3YU9t+z6oi2xM5j5Jbd1Q4bRiEHjHdJtv5QxY6bFmfUZ6Mwd9EDnmskgRXpDvivjcC2hC0J43U3aeqnNdGPp/XAdN/R3epaw3Aq0lxMuoM0x4cw0aUb4i4D6w7rU8z/6wOgoOLOG/tdWPVJysNvmt8HtNo6feVRvx6vRfV2BTkAQnRjqkqUAThwFVTUW7+k+1Omb6kjRLSoHcmCvQ8cvw5LwXhqLDTaWrKtOcylej1tiGNyMpVvKKKA2cazpC+KGHKTNYnWS38hP98GBp54ETCS014ahvfd8JqxEyGt1QAnSU+Mjz49tH3t6GVS4HpvnW4JyZXhhUGlYBLoGvJY03iCXxZijriXNrDal0xf6TI5LHiNMbNoFiQ70craFr94RNiy+B6isK5vKNsYCBFzHqn6UvETa6dnw8aZLphm/V8gi0Ocim4n7XzDqwmq95ZxRp6Ihysl8/d1KXJTy4WneVAjndCDKh7rqnRQc7wXByQiqf3j0APlD8LG18tfrJKC/mWKjYK4fUpWNz+9EPobPz9FuHyJtfJUUzo6tUtNy7SqLwvg+xpFOke7O/1H1EAxG/xA0/d7TQj7MAE4B611qviAUpTKRbpqR9pSWFAvwT9Lyw27ejrLucih/fRfLu9IfLUX/CroOE3htjhs+4DUOVcgtAWoRkHBjePVCOxySR4PbXAU3FN/W8+opNdVeHo+rrfbBvR/nnxeV0vCDmekOfEyraWscAMIgiLnWPR3PAuziGzdxkgc22mXBW323je4qJ3cgXrHRM24Pt+MiDFCM2BwWHjxy8++AZTY8LWw+GItyh9tO42BbOY49Tcqz40aGoJSHRttGTr1VYpOX1lsO2itWWEKYlZPsoVfS1UKV3Y/Ot4
 t/7LNArB
 kU5+qsj95wPGFDjpwZt6WLHIQRcgDhLGC7efUxfnCzSPLMdin0ZF+hKq0Brq4Eczwxve0cSV2yp1eAfimPt13htIwFnftAcl325o4xAM/8qPCIByzDc+BmgqyGKSYu8ZVDM+wkK1Lb0A6bcPqUIDNUGHXvJUmoXPY02IKBoQIAqTJDVi/EICLxkH+TtFvDBkxaox9b8FtTuWuaIJyHVV1cCisP+c3exeQCHF1+jgs+K9TTUBTb7u0BZFOU6G7r2bH0PYq+BknBc73W1T5KsUP9o6tV8lrGIV4Rbsn7XGYRQZn8KHZtyNSJvivCWXVsmGzpfoOxn6RSrQ9RPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 08:47:30AM +0200, Alexander Gordeev wrote:
> > > What about unlinked/temporary page tables in memory?
> > I've thought about it multiple times and it is best to represent using hw_p*_t
> > type. Even though they aren't installed or live, but it makes more sense to use
> > hardware type as they may get installed soon. 
> 
> My concern is in the long run the dedicated hw_pte_t APIs may want to do something
> special with a hw_pXX_t pointers: accounting, HW resources allocation, tracking,
> link a shadow, whatever. Some of those might be wrong when applied against a
> temporary copy, even though that copy constitutes a formatted page table in memory.
...
> > The difference between representing stack type with pte_t and unlinked/temporary
> > page table with hw_pte_t is that unlinked/temporary page tables are complete tables
> > and not just some copied value.
...
> Sorry for bringing up the classification question from your original
> message again:
> 
> - "a pointer to a live entry in the hardware page table, or
> - "the pointer points into real page-table memory and that table is complete,
>    whether or not it's linked in yet"
> 
> ...but the semantics of the former still looks to me stronger than one of
> the latter. I am afraid this question is going to pop up time and again.

This is yet another example of why we need to stick to the live entry
requirement hw_pXX_t pointers:

https://lore.kernel.org/linux-mm/20260526-kpkeys-v8-21-eaaacdacc67c@arm.com/

> 1. https://lore.kernel.org/linux-s390/71acca838bd3c5bb690ccb4a36313a889a48f383.1784121418.git.agordeev@linux.ibm.com/

Thanks!

