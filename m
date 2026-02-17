Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DB99E9A031
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 19:16:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A5FE6B0088; Tue, 17 Feb 2026 14:16:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7299F6B0089; Tue, 17 Feb 2026 14:16:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60B196B008A; Tue, 17 Feb 2026 14:16:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9DD6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:16:01 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E6A501C2DA
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:16:00 +0000 (UTC)
X-FDA: 84454903680.13.97E61E6
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf10.hostedemail.com (Postfix) with ESMTP id 80644C0009
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:15:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="o/v2cGmD";
	spf=pass (imf10.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771355758; a=rsa-sha256;
	cv=none;
	b=tjj+2IT6wxOT63MMic+Da5ZXGwngj1xI4orZ5+n/as0G+EO4j/wauabA41MK6GYWK4xqBz
	Tt2tNnn+wUEvyX1e/VvNlt5/da2CM9/pxAhjfCRHy/bCS2zTN5Wl71eCOVumGYyBXb3Tgk
	ZcgLKPqx8v/G7jFo6P0+lPEv6AA+ETU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="o/v2cGmD";
	spf=pass (imf10.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771355758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNMpq4qyh3WYGxKXlPxpMOOQOK3XVP3jl0fTJEZhqqQ=;
	b=As1YmSMsGr6FJ2sKsFUv1pdAhzEz+aHQKpOC75a2h6aafBxqtIDIYO1l1yvEyE6QxnHVey
	U4jRTSxrh7RGl9ICba0yhL9HAiL/qWL/bKnWwG420YA++ce11P3x0BEIphSvw0cmGv6Lcs
	dYzEc6PYXATOqeFbw+CzoL/Fr74bW0E=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61HFF78t3013565;
	Tue, 17 Feb 2026 19:15:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=VNMpq4qyh3WYGxKXlPxpMOOQOK3XVP
	3jl0fTJEZhqqQ=; b=o/v2cGmDJBZclaH3Apz9H2Lc0UbZc9P/Nh3skMRUCeKyMA
	BOUm60hRT4KlqWFKAcCtme6tHHCy5GbTN3WIhfteH4xhMleebCTcvHwlWNfL7ot7
	815XqgrtpFscGVM+YpJR2984AxAF/7eWHJzMOvLmNoG0oKDr4/QszrE8VummC2VV
	Ag9DWnF7rEQRVSK5TbdVWXCxPmIY3nKLpFwC56+lGkMjZOEezyJbecxbh28WjQJr
	cMiaTXtSTxzyH4EKCqR0IxaDucrWebONz/4gSybT2a/s3Jq1Q/4PeKdB5BKv0Kjw
	8MIriOmt9N6Jo9Nc7oOIJ347c9p12d7hvBFlkxcQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcqx0b1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 19:15:39 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61HJ3ll3030213;
	Tue, 17 Feb 2026 19:15:38 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb454hpm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Feb 2026 19:15:37 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61HJFYib50921818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Feb 2026 19:15:34 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2514B2004B;
	Tue, 17 Feb 2026 19:15:34 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 61F6B20043;
	Tue, 17 Feb 2026 19:15:32 +0000 (GMT)
Received: from osiris (unknown [9.111.13.3])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 17 Feb 2026 19:15:32 +0000 (GMT)
Date: Tue, 17 Feb 2026 20:15:30 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, willy@infradead.org, david@kernel.org,
        ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
        rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
        ying.huang@linux.alibaba.com, apopple@nvidia.com,
        lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com,
        Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
        dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
        vbabka@suse.cz, jannh@google.com, rppt@kernel.org, mhocko@suse.com,
        pfalcato@suse.de, kees@kernel.org, maddy@linux.ibm.com,
        npiggin@gmail.com, mpe@ellerman.id.au, chleroy@kernel.org,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com,
        svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, linux-mm@kvack.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm: use vma_start_write_killable() in
 process_vma_walk_lock()
Message-ID: <20260217191530.13857Aae-hca@linux.ibm.com>
References: <20260217163250.2326001-1-surenb@google.com>
 <20260217163250.2326001-4-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217163250.2326001-4-surenb@google.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: wcqAAen5QtOIh3Yd7KPIhfP50s2xWLqT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE3MDE1NiBTYWx0ZWRfX7oqGr8VrV/Xk
 p0gIknVZDxQC2GBczDROOnBcM7o7b3pKMWShsmSu1vqb+BvlzcCZcclbforXI3g03Tg2w3NQXE0
 iXFAV4kar5rcK/dTEoKjXtQ1YydA7DBAYYTXJQ6GINk1YIMDoUkt+7mkJ3MI51bmInQTTszK824
 8nC+0GeJPvCKNnOgiTfjClOWWPT+8Lpcfx5vc85/5OZTHkYR01ktJG/0YRg76aGx/X0wf04+agQ
 4kI4XL8Z0IXYl+rLKXIZzDCweR6PPYquimZJ7zKZHJhugW/R0Zxnub8iJh9jLTWzQmDmDx2stnO
 COtshVSmyDhLJ6fSxUHaIBEZ1BEuSi+RgRGyBNoRxTvLU6HRcpoi/biPBkmqE8MvUghRu4fJIvr
 xZJMzLYZujcCXK+JpPkNmjgX9+7+EQ1UvF4aYXnwqc/76xKkXQpx4u4s86e/o2ezBaAxgc9G67x
 t92lhnQ8I8WJpFBDkPA==
X-Authority-Analysis: v=2.4 cv=UPXQ3Sfy c=1 sm=1 tr=0 ts=6994be5b cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=1XWaLZrsAAAA:8
 a=28GIsqCL1x42zXYMcZMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: Atfp6M6HOZik-aY60bN0PvQ41cv5zLBo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-17_03,2026-02-16_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 adultscore=0
 bulkscore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602170156
X-Rspamd-Queue-Id: 80644C0009
X-Stat-Signature: xwex1dbnw14yhinjtbaaji49g1cj8k67
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771355758-612274
X-HE-Meta: U2FsdGVkX1/ZKwTJnU8FyUiCF703hsSvrPpqJhC1Ron9kTmcRcGP8JxhiG07v5HTKm1YtNz12zFR30/qYCiCDeySigziEJiX4+7KeyV22IYmgTdXPba95k8wiyfpsTHbJNQN4lHmQjLy56Qsd3d8URABawHOzBAb82dFf0LwOmKPcCswo4H5dS0HPohZyja5AP4K+L8BBXgl9AKNaUo7NV/xe0GnblbfqX6QIRzKhp4LQRw7e3wcWHxixjwgqXrCfpzi6qzHkM4EnnPbval8MrYNCBKelbPAAk/aQswNsXWm2OFbMoAbdTl6RTGEpy0s2pxqEdbuC8Ktr2KQUvFdtGCs+h22bbEF4sGJeVUgMafb/vINF9QQm16mU1tIfjMlo3g0ZhiyUeRVQVsS/LeFPocu7L8MyknmqxbNXCuz9At+84oIwexievg+q087C9/qAWubBtPAVKPH7y8D3TqGPQ32mVHSrI9HDhoahytoG//cfqAjcbKoi8A4AasMwKD3/QfFHbLi0jse5cQL3YEKiu0RnTY1ZNVl2oeNLFRSxWtfbkdy8NMzMTDN2ubNs8s4KihYcktAVHlYjqxEwy+/ZcwVV18YNpjMV6A6tQOkZuuQLXhY1sKnB5T74Ml9wQkdD/F97F1InAhdc75szrfPArRe7tlnHkkGTSpZe//xRh4ZVZL45my7nU+a6NrlyGbP2wId229ci/h8KgAKoomGNEuv1NLUwe8dMPsIMBN2UZFHlYt3rFkdHqWf5Dt6K4VBwQUQSYOe8zA2KxSWgyBtDl4Ahe5gV8+HmkOY4JfSyYti0U23kqlbkl5NLJy/gAGo7y7mP3RdZjCat4PDRrfwdcO/BwapgQS0sDgvnIKDuPsBOHq0mY6mZvNDvJfcgZwtjNrRQHFah5ECOI3/t8Wlxd16b9rhZFQqlJOi2HPekM9iwWif5rxJ/u6L7sGEkmMU2sycQrJvJi27DWcoqkg
 pCDyuwog
 PuKgQjy5lMlQu2DX31tnq/kXOG4eCi6L5ZVICJO2hFlKIgpDNJXtRScJIhy22nvgtA52N9dIfmQTKt0x9KIUYrytKEmYjOFWhWNyZm46yZKCfJTGwMrFZISUR9BQEgwoORKuUDvFWGmuWJ/VmVM0k/6HJJknBMbsU2iwGRFBC2PXEzTxYYnUDmOcpeMd7/ts3UTaLOA++tPad/3qiaXaK1NHF9+p3vMd0RnAJnJXanwxght+2PHMrGg231t7TuMyFrzhQuSmmXLbxidKMLhzfQuAmlrQhGYT315r3xzUpUZoNPojMg4SDhcAvcSneCyWyXvHPy56HAhCGGcp0qsElHTyzOC0EPulz9J0O2wMd6NmTapy8DZJWM5qyympjRZrf3JnsyQyq+g2a1P/5Y6rvjhcua2+ViTfBF97U4QKvyIyiu1SBt/tbUm8iMyRlXLpSr8IXUF9iTj2WZcU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 08:32:50AM -0800, Suren Baghdasaryan wrote:
> Replace vma_start_write() with vma_start_write_killable() when
> process_vma_walk_lock() is used with PGWALK_WRLOCK option.
> Adjust its direct and indirect users to check for a possible error
> and handle it.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> ---
>  arch/s390/kvm/kvm-s390.c |  5 +++--
>  arch/s390/mm/gmap.c      | 13 ++++++++++---
>  fs/proc/task_mmu.c       |  7 ++++++-
>  mm/pagewalk.c            | 20 ++++++++++++++------
>  4 files changed, 33 insertions(+), 12 deletions(-)

The s390 code modified with this patch does not exist upstream
anymore. It has been replaced with Claudio's huge gmap rewrite.

