Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4484DD34093
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:51:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ECDF6B0088; Tue, 27 Jan 2026 10:51:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49AA76B0089; Tue, 27 Jan 2026 10:51:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36FBF6B008A; Tue, 27 Jan 2026 10:51:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 242FE6B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:51:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6E20B16017E
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:51:53 +0000 (UTC)
X-FDA: 84378184506.19.F919AE0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1A8594000D
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:51:50 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=R2OZ3tNd;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769529111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OxxS5n1xieZUpH8YohdiA+9VRXqomSLAoDHyJVmPjo=;
	b=cnXUQexdx4Phr7MFes0/MoMZIXv5F7Q8L+T/Psrt4jllFzgBZA9O/qT/Px0DXAgyyjdHNP
	ekq8ctp6qwthzgoSLIdQapxGsp15xNO98I0JZzafTNdSf0Tq9kGgG2WNFgulkEKWhPwd2Z
	Mk77Th6jt7zqcQzE4euod2DadnSQ578=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=R2OZ3tNd;
	spf=pass (imf01.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769529111; a=rsa-sha256;
	cv=none;
	b=kzT5fFuqT1QzxiftGXf3PMItm4lT1jUId9b9vDXFKG5otgPvsyVX9fX5nBNTaVgaXEMxYJ
	VNzQdeSbHRqX7JRMnUo5vg3hsU0bA2FZ4XsGIX37OJ5JSdTOKIx3A4zfuMM9sYzhe2xppD
	RJVfLMBs8aO4n6nM84oxG5fwRateeZo=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R7WMWC008927;
	Tue, 27 Jan 2026 15:51:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=0OxxS5n1xieZUpH8YohdiA+9VRXqom
	SLAoDHyJVmPjo=; b=R2OZ3tNd9SFjbhgmya+gAkR1LeSUyxH/4qTui9x0/Uant4
	+He/E+9jhq17CXdAWqvn5tlXSBsBIY0k423Lv7jq6+YfHZeVMd54Yo78qQxKVPuq
	dd6+jAI5VodjgFmoPT7n1593r1Fb9KKf6vYGR1TGJZ3ta6ySO2jEKN+/Q8hmskV6
	M8b11DKp4JlY2KTeW8cYzln1cfyON+Phmgew57hSVAbypNIaxaMdvoh0QMqa7FG9
	hBGIKEIipRzww0uYI0TSD1KqYz0ocdD/Bq8GtccsOZugDFGRaiamzsY71sb3mD3g
	D02I83U0zVNelxPrFSiVffd8VmGWOQFku/D27YOQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnr64dmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:51:44 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60RFhAPC013427;
	Tue, 27 Jan 2026 15:51:43 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnr64dmn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:51:43 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60RD696c019647;
	Tue, 27 Jan 2026 15:51:42 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bw9dn18ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:51:42 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RFpc0B25821738
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:51:38 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FDCE20040;
	Tue, 27 Jan 2026 15:51:38 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F2062004B;
	Tue, 27 Jan 2026 15:51:38 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 27 Jan 2026 15:51:38 +0000 (GMT)
Date: Tue, 27 Jan 2026 16:51:36 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Andrew Donnellan <ajd@linux.ibm.com>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>, Rohan McLure <rmclure@nvidia.com>,
        Christophe Leroy <chleroy@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>,
        x86@kernel.org, Nicholas Miehlbradt <nicholas@linux.ibm.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Andrew Donnellan <andrew+kernel@donnellan.id.au>,
        Srish Srinivasan <ssrish@linux.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH v18 10/12] powerpc/mm: Implement *_user_accessible_page()
 for ptes
Message-ID: <20260127155136.2808076Add-agordeev@linux.ibm.com>
References: <20251219-pgtable_check_v18rebase-v18-0-755bc151a50b@linux.ibm.com>
 <20251219-pgtable_check_v18rebase-v18-10-755bc151a50b@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219-pgtable_check_v18rebase-v18-10-755bc151a50b@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyOSBTYWx0ZWRfXxChMywYP3CXN
 le5d6yn3Qq6MfjN6zC+Z+DQqleCzkUqKSkhMwpJSnn1Mj3zS2dO0nICsNnXEMtWsE3vyb83rzjQ
 6kso4VpQ4wBoGpfXa+uDicwe3s/Tx9G27+lBkSjIdnBpBe924kovkU2wInK8zp4fCnVcBOZS31H
 BJ3DIi34TvoRR/5d3SQODO1mtpcggsmfvH/oLD96EUws0DAq+gksrBtgsBJS82RwOsHFmTzrNBL
 CNwOe0QD3sOFuH+hrRzC0HuLjsyg7NKVHQVFym8CqHd55vAIbLaoGLE/k7/e/ZOrw+hMYWVP7oQ
 3uUxUrs0HYHgzU6E9dLRct4A1ePYLRq2MVcmQ4XlAiQw0ogB0VlRgK8V/qrltGoxEmwPlQvaIpZ
 oDSvwJEhdafxFukf2IRJrEZNbsOh1QhzlSOcS3BDkUFas4hDHNqKbsmPKpZG1pCe2JqB0joy895
 KqtIgfb/A4B51Vjsq2g==
X-Proofpoint-GUID: 8EJeeV34r0_XNIY9EmhfW46Wh100FMUs
X-Proofpoint-ORIG-GUID: Bk5rloqyZadRkxusHYTPbD17s7SpVN9w
X-Authority-Analysis: v=2.4 cv=X+Vf6WTe c=1 sm=1 tr=0 ts=6978df10 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=cPWeadVanShsLn6B-a8A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601270129
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1A8594000D
X-Stat-Signature: 7pth1to5za5kexeojxgsqs1wtyj88srs
X-Rspam-User: 
X-HE-Tag: 1769529110-147261
X-HE-Meta: U2FsdGVkX18DKEKHnz9GU24IciWXGptani6R3t5WH9fZ6/KG2l9EEpaN/vF7Xg1sneEuH5xEfnfepaG9G1VgIUdqZHDephe/BaLKSamO0NSgllP3SJwzRJpFs6JQN7Vv9kinmke2SHNxaaWt2TwzxLkD4l5FdWDuTAW5QOHxXFhZvVev4K+fxQ9Rdubq9LcQWkGhCd8sY04q3ov4my3gCHQVTW8PWjW/Bc61DuJZSE3W9hq0FXz3Ium1pkmq9TRy/RGft+7LboYMW7ff3wADx6tydvXNLTskdegbh1R0VOYbASDqFxsZH1gdKjhS4cHYh8TOik2fYr0r61S113eMmgwMPi7YKTloDO+fngHRH+i+AC8ZnaKBYdiRoKRy4uZr7LFcdShiLkMpFCAjuzHZeKGgOqq59BcBqK9TMLtDwUQj5oM0AhMfBAqK3yJKC7pvKm3tUFdDuDSX9LPNzQltJZYzGku8UQUvoTr9dkrfBjJ39DeIBVzAP4TbZdDDfzTeDnh2YCG8xLKsQKDPTqwuP05MRfmN4unHz+ixp32RMaZbipaSSAbSw1X666nGjehAFmlWw0wjcXJ9rlY0Ufpg5DYmNHsCOdoWamB4ov78yNjyYhTg36a1PWxwdyrLZMar3w0nfx606Pj8p7ECekIueoETCGx8CsVULQUBNVNsDyHsR041746AcHNH50EjQ5bgBp8qc1t3bl50DWQPzPwO2WzVJFSyjkYWVCW5NArcVkui3a8StZMHi9vmLuwg8FPnHJhG0hnrN5JX4qTk+WRuCI2Ne7mIYziChtBVtDf7D0RFQFOPm3V3jnG8TeGTD7KFUpgZXiB89jB6K/jHdhiF68+HQzyVzkh6qt1Hf/gBXYZTfSO/JaeoqSOHIFMv79Q2/2yfTvOA3m8Fhlyp+RHb6TtVa8iQjSgsMLuNzAcnMhVQu+aHsPhOWBy0JEUIVK1GYdHbqs/YHoeDgeFe5Wp
 w931Z57k
 GAAsVEjPuinvvSVDz7kMpOKKaLMNQOHKvlPmzsOhvTHhJwt1naT4eyWFc12KSFYPXB3JMrMKeliFeil82pakB/MHw9NO6BqBnzeF9b9u/Kk7Mu1zN8Cxm7bgeXy3c7UfjQD47bPPLQax4g7x0Ovh7KktdfBzNplL5QM+Mk5YJs6vJPxLu0ktC0ui3dVxd6VBIB5ZbehE1LBu7Jst8owZ6wpHetCepFtvROhwBdfDEPMfB/X7adrwstsckJl2nFpKkZHx4+fr/WxGPfp+VPxqBuPu7mDN67muH/PKARXWz2gmYvZf3C+AW23jc6YyxhfEfk3gQ/m/QTclqOlmHcV4/dyVTPp/zGabD8lOz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 04:09:42AM +1100, Andrew Donnellan wrote:

Hi All,

...
> Page table checking depends on architectures providing an
> implementation of p{te,md,ud}_user_accessible_page.
...
> +static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
> +{
> +	return pte_present(pte) && !is_kernel_addr(addr);
> +}

We looked into implementing this for s390 and for us the only possible
user vs kernel entry attribute is comparing mm to init_mm. The generic
code already does that, but I am not sure whether such check alone is
enough.

But it occured to me that we could implement e.g. ARCH_SUPPORTS_PTC_USER_PAGE
that adds an extra field to struct page_table_check:

struct page_table_check {
	atomic_t anon_map_count;
	atomic_t file_map_count;
#ifdef CONFIG_ARCH_SUPPORTS_PTC_USER_PAGE
	bool user_page;
#endif
};

Page Table Extensions already used by PTC, so that would fit pretty natural.
Once a page is mapped into a user process it would be marked as user_page,
while p{te,md,ud}_user_accessible_page() could go generic:

static inline bool pte_user_accessible_page(pte_t pte, unsigned long addr)
{
	return pte_present(pte) && page_table_check_is_user_page(pte);
}
...

I guess, many architectures without viable p.._user() support could benefit
from that.

But I am not sure whether is it doable, so opinions are very welcomed!

Thanks!

