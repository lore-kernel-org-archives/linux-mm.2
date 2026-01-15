Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DA72D4117A
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 12:12:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A5496B0088; Thu, 15 Jan 2026 07:12:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929026B0089; Thu, 15 Jan 2026 07:12:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E01C6B008A; Thu, 15 Jan 2026 07:12:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 692EB6B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 07:12:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1F55E8B34D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:12:23 +0000 (UTC)
X-FDA: 84334085766.14.AA1E3FD
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf25.hostedemail.com (Postfix) with ESMTP id A9A11A0007
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:12:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="cuKu8ya/";
	spf=pass (imf25.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768479140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ltc+hcjxizM3P3QQBHE8tMO8jkD4AxQpYmpFhYGG4/w=;
	b=RL50Ob71wAyzscAJo5sfsKk888Yx00jd6HcovKvZjSxCFrM5FbbputJClho8/luJJLHbe5
	s/8rnjqT+XmrMQhk8yqJ0UGnSpAd9W5vA3lZ0D9oM21cPCzdNmyQNPgR/kSv+Ri+SnPpIS
	ukhZTl/VGpQG4bm5Qyt9i2ex1cphGJA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="cuKu8ya/";
	spf=pass (imf25.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768479140; a=rsa-sha256;
	cv=none;
	b=8ORABVbVyYHrBG++kMJuf1NNZ1tTT18DNO6XUC8PTxESYVIv8WHmWSb5ld0ImgtmRkagv6
	pJx1ZSIV3yF72Vqv6XLzRY4uVVVpCYqPoQRXjW/kzDDy5va6EQK8jEQ91h0Bc5WlbDcVOz
	fF+YRje0GDwdRNvTbpN1ei3ZZ4gR3ro=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60FBh0Lo026299;
	Thu, 15 Jan 2026 12:12:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=Ltc+hcjxizM3P3QQBHE8tMO8jkD4Ax
	QpYmpFhYGG4/w=; b=cuKu8ya/gJARYizZ+g/vHOY4PzDBHZF7Wwq1mv4V5AdCv1
	XtCNos0bxbpmqKnKdLi4H5IdfKb9s7ch6G1geIanNdWa/X3K6YkKRecaAPokUfb2
	1x4mgLqPN16fB0/D0Pkm6U/pb59Ogtc3eOpM1B44xD2ehHe+glr2xrd1WVELSucC
	w1jyKp86zhqkdOnALb30dL2/ACSyMp7uPc3x6mqSdi/3nwslJn8vSQg4Ja6SAUY9
	GldKPVt66qLjpOUIAyutPLXE6dH9uWTlCr+0Z+SnIyuknO5Dx7wiiH3LkchHwh+j
	RNdQcJfkXvDGCHWjOidfiUORs+UGEwXKLPICprOA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bpja4k093-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:12:17 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60FBW8mI025858;
	Thu, 15 Jan 2026 12:12:16 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bm2kkqtyb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Jan 2026 12:12:15 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60FCCBvg36634880
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jan 2026 12:12:11 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B634A2004D;
	Thu, 15 Jan 2026 12:12:11 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B8BAA20040;
	Thu, 15 Jan 2026 12:12:10 +0000 (GMT)
Received: from osiris (unknown [9.52.214.206])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 15 Jan 2026 12:12:10 +0000 (GMT)
Date: Thu, 15 Jan 2026 13:12:09 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "kernel@xen0n.name" <kernel@xen0n.name>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
        "oupton@kernel.org" <oupton@kernel.org>,
        "joey.gouly@arm.com" <joey.gouly@arm.com>,
        "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
        "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "will@kernel.org" <will@kernel.org>,
        "seanjc@google.com" <seanjc@google.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
        "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "luto@kernel.org" <luto@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "david@kernel.org" <david@kernel.org>,
        "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
        "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
        "surenb@google.com" <surenb@google.com>,
        "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "martin.lau@linux.dev" <martin.lau@linux.dev>,
        "eddyz87@gmail.com" <eddyz87@gmail.com>,
        "song@kernel.org" <song@kernel.org>,
        "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "sdf@fomichev.me" <sdf@fomichev.me>,
        "haoluo@google.com" <haoluo@google.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
        "peterx@redhat.com" <peterx@redhat.com>,
        "jannh@google.com" <jannh@google.com>,
        "pfalcato@suse.de" <pfalcato@suse.de>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "riel@surriel.com" <riel@surriel.com>,
        "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
        "jgross@suse.com" <jgross@suse.com>,
        "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
        "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
        "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
        "ackerleytng@google.com" <ackerleytng@google.com>,
        "maobibo@loongson.cn" <maobibo@loongson.cn>,
        "prsampat@amd.com" <prsampat@amd.com>,
        "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
        "jmattson@google.com" <jmattson@google.com>,
        "jthoughton@google.com" <jthoughton@google.com>,
        "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
        "alex@ghiti.fr" <alex@ghiti.fr>,
        "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
        "dev.jain@arm.com" <dev.jain@arm.com>,
        "gor@linux.ibm.com" <gor@linux.ibm.com>,
        "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
        "palmer@dabbelt.com" <palmer@dabbelt.com>,
        "pjw@kernel.org" <pjw@kernel.org>,
        "shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
        "svens@linux.ibm.com" <svens@linux.ibm.com>,
        "thuth@redhat.com" <thuth@redhat.com>,
        "wyihan@google.com" <wyihan@google.com>,
        "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
        "vannapurve@google.com" <vannapurve@google.com>,
        "jackmanb@google.com" <jackmanb@google.com>,
        "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
        "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
        "Thomson, Jack" <jackabt@amazon.co.uk>,
        "Itazuri, Takahiro" <itazur@amazon.co.uk>,
        "Manwaring, Derek" <derekmn@amazon.com>,
        "Cali, Marco" <xmarcalx@amazon.co.uk>
Subject: Re: [PATCH v9 01/13] set_memory: add folio_{zap,restore}_direct_map
 helpers
Message-ID: <20260115121209.7060B42-hca@linux.ibm.com>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-2-kalyazin@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114134510.1835-2-kalyazin@amazon.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTE1MDA4NiBTYWx0ZWRfX8xuvdIWONZns
 NVj8BAvAH4TNQ9O0kDyAmsAi7jrDlvBlIX5lrVtDjlKsAykqSak61W2NzOEE/mTeTapMZAxp4BE
 Kg5JlEQ4oCZWkWECJyrK2hjes04NLm7FAxGCZLFEpSOLNK1+igAOkLJOHY9GXNAN7bkVCl9xtfU
 qXDykXOjQUTOWBz25zMoy3olki99jMxOPUC0PwGY/k8vF3D7ujIT5mkzaC/zsmark/FqUFuC91E
 +10vy+dh49wFMZRjzJA1LX+EM18nWBc15kk/7b4DHobAhio5bH3z57/Jt8du8sRGsMSFOrV8v9q
 1gZM94iCNVVUgv/wFLJNo3sZMr4MvSRNs611NG5Gl6uaOxxj0gsx1F0GA9AWcV2yHhAJAOQjPhG
 ywiloEVRKAUYbQRI1zQhnfFyDO73c8tnH757E4fEE+iW/HO5M2Mf9Wc16eZZ8naIw0Qe3IcZlBk
 4FgoOq0SpQYiKqDUr5w==
X-Proofpoint-ORIG-GUID: SiTgUlerDfUVs79tMKJhCw9rSIvAm_ra
X-Proofpoint-GUID: SiTgUlerDfUVs79tMKJhCw9rSIvAm_ra
X-Authority-Analysis: v=2.4 cv=U4afzOru c=1 sm=1 tr=0 ts=6968d9a1 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=vggBfdFIAAAA:8 a=3DJOwtP4az6VclhYBKkA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-15_03,2026-01-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1011 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 bulkscore=0 phishscore=0 suspectscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2512120000 definitions=main-2601150086
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A9A11A0007
X-Stat-Signature: 4y9azyq59zefu7z1ruxxj8gj6nergdbi
X-HE-Tag: 1768479140-749188
X-HE-Meta: U2FsdGVkX1++OtxjqQOwYlUx+nnHx8HX0Ygl1uPYGunevWvdJm9BUGDuFNv4RnrPprx6jZojrZcGq2x8kcpjR8cDApBHolfNxL5ySxHSQpyLjf/Jo5l6JHp0X9tcjlLVmRaYwQfK+e1Vcp/MPrKGP2PZ6hGE6cwhJX/zcA1V03YWoNBE4/qy/5rFkChvwYgq3aqPYjDucrakTpW8rj95Wrq7fR1C8ZHiTEPUD+RH45Xj1bMufYjsYLrUXsjrLIEpiuIBjIhet2JCWEKwZ1MfAwi478/0fRvBVuI4T/Q1H/u+y60DmHOaMWHse8lm4odlu+3W/8uj78k3dRXBLe+kJS6Ia6EP+r+CniRwh8HejeeoUlfLcPMAhVBmG3kNpsz6UJAQYbqjI5DxN6gMDpmEmQZZW2qBBwzcim3FWFgvM/bWf11xWuJLRpoNryVIEOslIVU53IhO3/tnHCs9a1K6X1TJK9n9GY9xv0G100kPqloIGsnrp/56Loryk3mq5HXi/DMKzNROQmjJNnCN7T6mq1Q6nQldDNl71UBSf26hVu2HGAGjXAa5oSH4F6XHqjtITLhursqTJtmv2YsJwPJtdZM+0xoMzXIcU9XtFmXvG8hlXy49sqFMvUwddsdSKmSIymikgYv/S50aUuJ/KV1cfvzcdug63EXMWHRoavVJDswEcJwacb55N3nnoIHieaxmZQHVRtgGY/lmmJb11hBdSzRK3bReqGL1EEgf41GyLFLCsJmoc5TjphS5t2QFWm9tVXraE+SjS0en54k3DvnQFbqkNgdlwVhFTW1JH+GKQBNr7uzs+0A0HGc0S1i8maMIP7ISq9raq0CL0WLmZKySRfOzyhExqNAASaUAOMZHOU5x1QhRmoIMRP2ehBsMCPT1cIBf7g3MeptOchZ38UU39Y7xUbcjJcUdvwBdU3Cf3UdRRKnlvdmkvg4nX8xCRrkSWnY2kwa4WzEqiXgusdy
 77co6943
 vla/g5yKHJrJ+neDCl66vld3WuXDe8jU7rRp9uf7GGBhzBA7r9TCS9EbmmdgEbSQo4jwNEMmy+WKOI2fuo0qyZTAQuc4/J2Ji1b2cSnHDIf254BAKpkQfg84lWYRpZRWL1sV3klOO5AAP12P01BbQJUhUjMpieRrfXhlBcQI1krII5p1FDCoggWtO+9E0CoUSt+JGIJgswijUunxx6klvAM29VqGhP0U0OlVkkwfpj5nXV+Bo8an/ZkLyRjUXY1J38dorjhh42cipVt4u6diHwlwwa6Ws+Aj2BN7QS8scOGfOLjN55fkPBrUVlvrJTQT5iYAAfmX+ub1ntKRbsojEkD+OW1JBY83j0MKqHWZT0UmGkySpJx6sKMaXITtC9xUvDWh+5jaNBxXxpQXDGsrL/BFjzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 01:45:23PM +0000, Kalyazin, Nikita wrote:
> From: Nikita Kalyazin <kalyazin@amazon.com>
> 
> These allow guest_memfd to remove its memory from the direct map.
> Only implement them for architectures that have direct map.
> In folio_zap_direct_map(), flush TLB on architectures where
> set_direct_map_valid_noflush() does not flush it internally.

...

> diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
> index d3ce04a4b248..df4a487b484d 100644
> --- a/arch/s390/mm/pageattr.c
> +++ b/arch/s390/mm/pageattr.c
> @@ -412,6 +412,24 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>  	return __set_memory((unsigned long)page_to_virt(page), nr, flags);
>  }
>  
> +int folio_zap_direct_map(struct folio *folio)
> +{
> +	unsigned long addr = (unsigned long)folio_address(folio);
> +	int ret;
> +
> +	ret = set_direct_map_valid_noflush(folio_page(folio, 0),
> +					   folio_nr_pages(folio), false);
> +	flush_tlb_kernel_range(addr, addr + folio_size(folio));
> +
> +	return ret;
> +}

The instructions used in the s390 implementation of
set_direct_map_valid_noflush() do flush TLB entries.
The extra flush_tlb_kernel_range() is not required.

