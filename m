Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFB06CFC26D
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 07:09:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 297D56B002B; Sun, 23 Nov 2025 02:09:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26FD06B00A1; Sun, 23 Nov 2025 02:09:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 184996B00A2; Sun, 23 Nov 2025 02:09:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0712A6B002B
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 02:09:13 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 92E52130B93
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 07:09:12 +0000 (UTC)
X-FDA: 84140995344.30.A92DC28
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1F49F100002
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 07:09:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=n2SgyKt1;
	spf=pass (imf14.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763881750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWVoqRCJJQzeqwmG+uZqGF4Sif6dBJSA9rBhyQq0L5k=;
	b=ScfMN6Vk1j7bn4jyuZprcVZEHgB8hNp2NZbqvyiXpeioBPJPDnk+CwGHJXlJc03hgA0Cab
	UkdGy2h/1hnV45lpN8lzHhODBR7uQPFMsc19a40ryTSy5jmeD/PL2vYJbuDpdxeoqUm8Wr
	kbtVI89BrW0dtGrw9w+AHTHHeZdhIDY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=n2SgyKt1;
	spf=pass (imf14.hostedemail.com: domain of maddy@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=maddy@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763881750; a=rsa-sha256;
	cv=none;
	b=NGj1ry365ozLBBMSKOr+XmC9kaE9iubCWx+lI5cLdOrf8cnJNhcLKOUF2voHKSbsgXX/fe
	VmPptDW3yOsilokv8o/yZEZY3nf2cTHCGHVgrHZQp8JbyB8K4O2Le5+CmfBxJVj6gesM89
	qD04b9j52dbWQqk7DV+9frnuwQREFkE=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AN57K1V012347;
	Sun, 23 Nov 2025 07:08:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=fWVoqR
	CJJQzeqwmG+uZqGF4Sif6dBJSA9rBhyQq0L5k=; b=n2SgyKt1Imzb3KshltZ4kw
	GCk30khNq5je2WSuwv7gP4nkkY/QSxrZyRHU99w3vKZ0cIk1O2Sopfz0x18sUrtU
	wsvBlgijJfA1k4feoZVX25y0a1vJ3F1TS9tdywFHEvFzeufHZcaIWrTLY2uhRG0j
	bzxN88XhDiNqMAaOuoyH7zYrLrP7whdYfVDgLQR7+So4NMZdw0JO01YWhwIn71C9
	Q+yHhW8cqo93XVAd7fKEpzWfFIpVRIobew9C03V8aj+6p8U3oJmfRQlsbRFOyEky
	KBwWy3d4Vo1zlBxfz3TwXg87Pz50yImWcDK1DSxVz2uZLHsMdvKa+LHHhHxWquqQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4phkt0a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 23 Nov 2025 07:08:50 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5AN78AsC025230;
	Sun, 23 Nov 2025 07:08:49 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ak4phkt09-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 23 Nov 2025 07:08:49 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5AN6fQ9K030768;
	Sun, 23 Nov 2025 07:08:48 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4akqgs10ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 23 Nov 2025 07:08:48 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5AN78kNd29491478
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 23 Nov 2025 07:08:46 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C134C20043;
	Sun, 23 Nov 2025 07:08:46 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 28ED820040;
	Sun, 23 Nov 2025 07:08:44 +0000 (GMT)
Received: from li-ec1c5fcc-2902-11b2-a85c-a56d12941531.ibm.com (unknown [9.39.28.54])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 23 Nov 2025 07:08:43 +0000 (GMT)
From: Madhavan Srinivasan <maddy@linux.ibm.com>
To: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nadav Amit <nadav.amit@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Dave Vasilevsky <dave@vasilevsky.ca>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] powerpc, mm: Fix mprotect on book3s 32-bit
Date: Sun, 23 Nov 2025 12:38:42 +0530
Message-ID: <176388153643.266380.17169073097404532999.b4-ty@linux.ibm.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251116-vasi-mprotect-g3-v3-1-59a9bd33ba00@vasilevsky.ca>
References: <20251116-vasi-mprotect-g3-v3-1-59a9bd33ba00@vasilevsky.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTIyMDAxNiBTYWx0ZWRfX2E+dZydoBIjq
 j/a/Fuhl1XWmEEj5AHgqhURViq8wIUsLzFFYnFIPDULo8sKfC64ctWWtkuiBy/5BCSeTkGXVPce
 Q1P77wvL8O5Uub/5FHar82Ek5l3npYFRBmUn6YZ8j8yMhmLRmHPIYaUS2O0hoAhVsMuOPyngDLu
 QbGTjOg2AnDtHItFHSaPv8RUGU8Jm6BLkww3vhoF7tQyVbpZapuW2c1+MBVFLQ7Ssp+rQ8ELLT4
 4W8/o2HcsIsCqHi2DZBFeWxzP50Vvqkhmyhg4KhOhL+Dw7URkF4FE4+p9xPCoLln3zxp/6qJ5DV
 7fD0hLLjK9dtf3/bjd2gUim3IaF4ypPgp71M9c073fhgwlCB5u4i1D64PDD/naIH7beI1MkaVWC
 9x3WW8VpHeebPQ7zNTM1xAg4IcQspA==
X-Proofpoint-ORIG-GUID: FI8kl5yIzH5v47u0HKj_StUJaVkAQRz_
X-Authority-Analysis: v=2.4 cv=CcYFJbrl c=1 sm=1 tr=0 ts=6922b302 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=qxS73Cczoj_2XmlJWXgA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: OPEAhxgTMF36rTxy6rRkhAlgEqpEQIwu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-23_02,2025-11-21_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 clxscore=1011 adultscore=0 spamscore=0
 phishscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2510240000
 definitions=main-2511220016
X-Rspamd-Queue-Id: 1F49F100002
X-Stat-Signature: j6cefwsg7is5uba971cjbwhcaxs99oyr
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763881749-589932
X-HE-Meta: U2FsdGVkX1+b8zHgTvrWBVSoKgT4p9X+6PNlbXjFR53R237H78vWRGEQWCnnvnWjut7mFxeDN9r3Ri8WJmy2e7wyp+p1XANiL5v/bN/rkLtJveMIQJSH/nyrT8bUYRF2woTsWw+YBGHh4IEGmVh9Mo+CQd3QmtVPemz0+pAYdTnOdkC7kFoA0ep5tJdTSp7cpuMnblRrsgSSYlNMTlIQ+tl5+4iO7sfaOLEhVDF3eBcuepeY3wl02TWvICTOp9+PyFWTiGoIp4g+VMbkFWK881rlyFFlGkd9K90eoljwVqt9ox/mRcbvt8xrw7d89tvfHv46AQfBIB/4lxNDxn+LmdZYpYY2tmxMuWZUgPChZH+hInPgrGHYFsYAid6PbU4SC2jdqwB2jjqpqzKWGmM5CqhTn20bdmS92EpHhXaUu5MwvrVmB+GcPLwGysdyaPIJfx33WO09ea2F5PQwHB7ASTJ/U8981gbfJslYG2NXvLrPxa0yYOhdF7LxG7wZ9n61KeSPYIjlC8ATvo9FwMp8orq9nO9aWkA/3my9KwgWlknikpv8ZGy37c7Rof5HXvwd1OgTdsWt/Fcq2yuv3DvKwJcDXT5YH6S4vnLyXn34WdeoRjKISJURif4+esKPBtByfYF1NQGCX2Lybze3GxuZyPIQ9LEcloxwevegdMqkXwfa2MIHgtw2801zYFA4bRy9cbO2LmQdL6h6aJ1xtB2JYFuksMFjklDPkXeu+BRiCIpi4ZHqOXJFegM49gYWPJBpZOTwSsQet1Z1Y9GMRuoWd/pGKQ/wOvd8NvMaXBF7YunCR4ibDacbY3BK/nUk5TMtJJzgisAvV2IXxBYVW24gZnu+2p6moJP3zBW5MUv5v4sBmr9Bq60q4tujYsVNQAo4Eg1rc4vDwY3YOWUEBO9kUv/BHzFNkUkzFrnr4bGIg45kBulZAMT8W64xgAD5ENg9FdYVnuDtXnnIqpHm4vM
 QYkjBAo9
 H/8MSJTj1DIeKuB8IqW12ntVvfz7M/bcWiG3kEb3STkprWgPL/xUXPpSNvIjEEx4LTdsHdfL/VAr3HtaAaaSmvnflr1j9CWJgo50Ow9yRuDAJOwHRInEAIRMd3OaI1auoypbkvgqBBnWlAeuzJyNfNVcQtFLzrZ1Jzp4AveIrsR/H7+fTHcWpavUH6UzOGqDboaMgcQ/ABh72Es7DOMZ7pPdATq69BjysHP61oWL01Gg4bDI6p7c9fGK/cPTfGsZseK2kHdy9CtBDYY9ktGkPlchRuDw0BS1lIVQtCWTB9qbyUrx9x1uC+qPR3Ze4EsycUo63raLUtWLnK2Bte2oNqw0Vc8VCCDB60DiHmalKIqywJRrHF9PL+0VvBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 16 Nov 2025 01:40:46 -0500, Dave Vasilevsky wrote:
> On 32-bit book3s with hash-MMUs, tlb_flush() was a no-op. This was
> unnoticed because all uses until recently were for unmaps, and thus
> handled by __tlb_remove_tlb_entry().
> 
> After commit 4a18419f71cd ("mm/mprotect: use mmu_gather") in kernel 5.19,
> tlb_gather_mmu() started being used for mprotect as well. This caused
> mprotect to simply not work on these machines:
> 
> [...]

Applied to powerpc/next.

[1/1] powerpc, mm: Fix mprotect on book3s 32-bit
      https://git.kernel.org/powerpc/c/78fc63ffa7813e33681839bb33826c24195f0eb7

cheers

