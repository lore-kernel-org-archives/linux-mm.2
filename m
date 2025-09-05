Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 303B0CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8838F8E000E; Fri,  5 Sep 2025 05:47:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85B598E0006; Fri,  5 Sep 2025 05:47:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 770EB8E000E; Fri,  5 Sep 2025 05:47:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 636448E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:47:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0FC26BA70C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:47:01 +0000 (UTC)
X-FDA: 83854717842.01.EA79A3A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90DA3180003
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:46:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VMha2oUb;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757065618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wm0ttcidOnuuW+7W5s4enprUWnKXFXXBpVS5cSOiYc=;
	b=anmkMHw60Z/K+NoQmFMEyRXjQEx7BlSVlPfbAuMFIh5HK+pQo10NJXc+5kIRSBGbiyStvi
	oiqppLvr3mtyHvsEwBsy2Y9ocfoOmassCh/Odv1W4HyYMkyKmx4vfbJ/hoL6NFtbdV73U9
	X8A8WNM0vax1ymk2y+g3KbPV4GWpJok=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=VMha2oUb;
	spf=pass (imf06.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757065618; a=rsa-sha256;
	cv=none;
	b=qXwys7BzACXBoIBhuzhT1dFUMOrIDC6FG5vbpFEWWpUE+jfPX3NEMLr2TayMHa+aplrKYY
	hW0EWZFpskgemAh6pmc4ppTeFZvjnjA8zxqZdTp8fDr9C2721bslNuQHNDZgjN1ImMQxNv
	FRX8r6Vi408mCm9ipUDERiW/jiOsBrg=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5858E7UF022544;
	Fri, 5 Sep 2025 09:46:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=6wm0ttcidOnuuW+7W5s4enprUWnKXF
	XXBpVS5cSOiYc=; b=VMha2oUbllfJfLMtOLr57qJJz6vzFJD7LJ8gk5XShnJjc7
	IbrZHVpXb0CrQB5ykpgaxxSFsvvfNEanPBHuuHOGbETD14NXO2pqfL1MNf784mVy
	uvjiyf12/QVwQ2mZmkqASP9O1WaaViYltK6jPW1ia7fc4z77ZZIcxHNd6zZP5Nha
	CbH/zL34/kidtMFkhDHPIOsMEJbRBMwe8T8wEPT/Ddq6WBOoaLYfsZ8bm+i7vTSv
	P1GmCBCUdyPpWD67R2YaTENZDIlFGnxT+oj4rEpMuGkVtfQCqHsL9/re90DkKZLP
	0DLbyK939ud6LvSGoOT7rBnWZkhI2AUGLtGlCZgg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usurfkcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 09:46:31 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5859bi0p009310;
	Fri, 5 Sep 2025 09:46:30 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 48usurfkc7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 09:46:30 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5856Gg3M013959;
	Fri, 5 Sep 2025 09:46:29 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 48veb3rk09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 05 Sep 2025 09:46:28 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5859kQ0M52101484
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 5 Sep 2025 09:46:26 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCE5220040;
	Fri,  5 Sep 2025 09:46:26 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id AF00220063;
	Fri,  5 Sep 2025 09:46:24 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.111.88.103])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri,  5 Sep 2025 09:46:24 +0000 (GMT)
Date: Fri, 5 Sep 2025 11:46:23 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Kevin Brodsky <kevin.brodsky@arm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andreas Larsson <andreas@gaisler.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Jann Horn <jannh@google.com>, Juergen Gross <jgross@suse.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
        Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ryan Roberts <ryan.roberts@arm.com>,
        Suren Baghdasaryan <surenb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
        Will Deacon <will@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, sparclinux@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH 0/7] Nesting support for lazy MMU mode
Message-ID: <9fd076c7-f163-4b92-8201-d8a259a338c1-agordeev@linux.ibm.com>
References: <20250904125736.3918646-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904125736.3918646-1-kevin.brodsky@arm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzMCBTYWx0ZWRfX0b7vKa9wIqUd
 15JIKVxY/eFyoNy0/rx0rVDv/Yc4PB6ogniG6U5JZlC8qyn8Y0NgFv6oYYbeCaWjZF7P/Etub/q
 /XnEYzafYNkoOrYQMbqj6nFHYpYxymufPYjcGAjaRnVt2jxUzS3zPb6lpNjC6s5Oxrs0WYMRvbR
 dBvy+J/7pMy+teTA+x9T/E6ggkXyizQGe//4AxcBxcrhCKNqzem6rRKcxJLTefmrfU0CU2VW6uC
 5x2JqlOAMSNtXM1AfGSytrxIFOr2S3XPEdTEP1QyOTNlKzTtGtrjaWkIbxQVZc7XyWa9Ggbdnl8
 wkgYg373aI71Rh0ZOzmEr1tWX4M68Yz9HwoQbCiqMpeXkMBa3EZ9mW+HowhL506x5+1yPvl4rLU
 90pIQxaV
X-Proofpoint-GUID: NmMecPGQNEFV5Z6yet56qjNF4vqqAdRy
X-Proofpoint-ORIG-GUID: 1xCeVzb0bz4EbY7yd5ySncyf5nvF03Hn
X-Authority-Analysis: v=2.4 cv=Ao/u3P9P c=1 sm=1 tr=0 ts=68bab177 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=7CQSdrXTAAAA:8
 a=PE-dCK3ueRk4C2obWmcA:9 a=CjuIK1q_8ugA:10 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-05_02,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 impostorscore=0 priorityscore=1501 spamscore=0
 suspectscore=0 bulkscore=0 adultscore=0 malwarescore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508300030
X-Rspamd-Queue-Id: 90DA3180003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 56tuzaq4ngcexp4bahgxhsedzn5j7idq
X-HE-Tag: 1757065618-998141
X-HE-Meta: U2FsdGVkX1/u/a1GoaxQ1M3Ry9aVlDcAFilfLdT2e412Q2RflEkwC/GlZaV7z1ZcAl6WS2P43/A9XLCof+84pPao6mmBIhvxIr4IGCTzFBX9+GSdVl1ZtLBAhTZ2JTaCMYvyqVMRUOFoar+QVnT+a/AI3K0ifhvPJSS3hGxcWANMsgSkS6t+mS3+5lzO8SorgqHZVar+QQQZxvxvnMSOwq6wROUv4v5sjXP2Fg7KQMn071FAwHl/vSXWUq60KAUGkvUh0zakVtktvlXcbWRzPQnIUyCUGEQ7XY3Q1xRsYqg6orkvYcrZBIdD6dxPbUxDDnzfy7FUNkE/o0KnP17dlPbZZF3A8o1ROdhrpXJ0ZicwygGN28P2VrUl3IyczrUDE2WPkKF0qPlhgy0typq7FnQRNBPTwDzkIhu5/2aJgWv9Jl8ok+WQQXD+jWRVQY0RDgwJv3UB8KoYNyjWeQdo4OGLga1wz6/iSKOQpExemLk4stDPj9nSGD+qbwyowvLS8jX2TFgokJW39hXjEKkbp9MzER0GfkWjps1mFDsUIdfELatD7kJFhUH1IiM9Cluty3+YDqliWvhcb945O8SMQXk7kZ/BVfVryseVtB14VDmcyFTyFqetTLNF4vOLD2bIzxqOjZLAK18Jyq5iSmrmCWZRHe5fCg00UBRGkd1aUxKNaGNac2lj7l7ZDf+satnZ8oClteLjgxrzV8/iRUGUHki4x/MhbAfsLdsVcWq+0mWamjjksi0niCBNkZHfpYwHq6+ctFo0CpTMdsfqywhoxRftvPaaNjEhItP7fLtqCm9rkGw9PkI/NGesAlMSYaTMGoD/GktulQzPM2Z5AgSISyyFL1Xvdk5vWkk7qPlTiGOHHCUGPt3SN3OJAfyH2pyngCyN5olKL+t2KM4IgsXP3/BV6t9v2FM3pPCgjnRTqTQ2ed30dCndT2iqM0ZQGaqYa/CrpKIU2yASO4Jkq7h
 PrDW5Gcj
 jyFImAAMp+0WUTsxZsI/GZUIa+hnMSbQ/vejBgj6PR/IumdN/S+vmCIBleFqCJu0GE82lU3vDY0C8INzV2VW84MYYon88KZEvkL5QPPux/CF0uOfv/ICWM8ft9CqNdW78rTyq1cxd0+bZHlonxLQ9l3oNVZeTW7I6Y2GHep37q5+yipvl2E+uWpZir576Ff1035x6t8TbS3iZXf3iRTqaZyiTTmgcamngbeP0GD1auLUY0krGIYEnsfUKlzCzewabcT1Oq9uwATmBNzJEA4JQGqapHfuxZ56KBYj7csY5v5aaDeeFCooD66yvg5WBjYhsADj6BGJhQsJSVebhF0UxwHLbxzbedl6hEaPYIbQ0NTkVz+lAWUbzzk4oq034XjbismGDGpjzxe/clPc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 04, 2025 at 01:57:29PM +0100, Kevin Brodsky wrote:

Hi Kevin,

> When the lazy MMU mode was introduced eons ago, it wasn't made clear
> whether such a sequence was legal:
> 
> 	arch_enter_lazy_mmu_mode()
> 	...
> 		arch_enter_lazy_mmu_mode()
> 		...
> 		arch_leave_lazy_mmu_mode()
> 	...
> 	arch_leave_lazy_mmu_mode()

I did not take too deep - sorry if you already answered this.
Quick question - whether a concern Ryan expressed is addressed
in general case?

https://lore.kernel.org/all/3cad01ea-b704-4156-807e-7a83643917a8@arm.com/

	enter_lazy_mmu
		for_each_pte {
			read/modify-write pte

			alloc_page
				enter_lazy_mmu
					make page valid
				exit_lazy_mmu

			write_to_page
		}
	exit_lazy_mmu

<quote>
This example only works because lazy_mmu doesn't support nesting. The "make page
valid" operation is completed by the time of the inner exit_lazy_mmu so that the
page can be accessed in write_to_page. If nesting was supported, the inner
exit_lazy_mmu would become a nop and write_to_page would explode.
</quote>

...

Thanks!

