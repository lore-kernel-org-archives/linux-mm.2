Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EFF8C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 15:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421606B00CD; Mon, 27 Jul 2026 11:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8786B00D0; Mon, 27 Jul 2026 11:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB0E6B00D1; Mon, 27 Jul 2026 11:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EEDE66B00CD
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 11:42:44 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84AE91A078B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:42:44 +0000 (UTC)
X-FDA: 85034974248.14.AD2BB9F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf04.hostedemail.com (Postfix) with ESMTP id 21E694000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 15:42:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ndong4jf;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785166962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6J3gnQbVG5F32M1ODXud3+fpqy/Uu5wURU5jevcJFLY=;
	b=GOBQYHC1RYkscbAu923LIsHJMAgr0jDJx6V/2ty8v1b19N9cGmWXGvc85FZxdixmK7vJmj
	4j7kw/q5AEqEknpwG9/TOfNI+Z8+NhBWZRxZ7v9rbMmiQ+r/aCmuTRWvfUUdRmYzeKIbVO
	5MXvZJ7bFCCmgKdCQzXHU0pxvsnEEpY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785166962;
	b=XHa0LZ730cwYTax42iUNK9LVkstEAotPA01/IvBKOcvDiGABIQa3t2MUNnArFcwpFsWwhw
	YhHC9uZVqAAqz8bVbGp2ESEzztCKK/G41m7KBtbnZW7bXJ7Oc2hnMZppMva/nNkFzo4Mkh
	2w4SIbMZhaY0nH9NQE48ESR4IkP8g5I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Ndong4jf;
	spf=pass (imf04.hostedemail.com: domain of agordeev@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=agordeev@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66RDnI7x2374802;
	Mon, 27 Jul 2026 15:42:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=6J3gnQbVG5F32M1ODXud3+fpqy/Uu5
	wURU5jevcJFLY=; b=Ndong4jfH4A47D8juXaN6VEO3OTQ+xwAwF2aTjQZG/Zo70
	huG5/1z18vRkW9WjsIJ1qpZcaEqr4lOt1J/IyosS2hvwszP9liVRguSgqDrxLhwd
	x/fPnM4zJqhCWr7zWXDAjHGC6djYB9v+UI0QQL4tvigC1cr7i1AKLaIT8x9eCxEU
	Bf13cu9uUGfJVnXPArimdGJCBo5CinbGFDu11XNMYdbwz/W/66i67wEkr3Lm/mY7
	4H3c/ejlM8oXnXxQKg7JoEP0EfkSQqAjByWxy3kkWSbZR0SnX5bXrWJxSGHgRO7j
	hZaeHnG6iEHsVuY8WldbrGbzS9tOxaPutDO/+4+Q==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuw78tdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 15:42:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66RFfiqA027216;
	Mon, 27 Jul 2026 15:42:12 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5xwp9y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 27 Jul 2026 15:42:12 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66RFg8Lt31326578
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 27 Jul 2026 15:42:08 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6014B201D8;
	Mon, 27 Jul 2026 15:42:08 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0BFEA201BD;
	Mon, 27 Jul 2026 15:42:08 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.224.92.206])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 27 Jul 2026 15:41:50 +0000 (GMT)
Date: Mon, 27 Jul 2026 17:41:49 +0200
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
        baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev,
        corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
        mpe@ellerman.id.au, gerald.schaefer@linux.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org, mingo@redhat.com,
        bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
        dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
        dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
        ljs@kernel.org, dev.jain@arm.com
Subject: Re: [PATCH v6 08/14] s390: move has_transparent_hugepage() out of
 THP guard
Message-ID: <a0be91ef-7e19-475f-ad0c-0f0bd14d3f1d-agordeev@linux.ibm.com>
References: <cover.1784856856.git.luizcap@redhat.com>
 <3ab69c6a9210d2764f714a093eff731dcb55ed14.1784856856.git.luizcap@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3ab69c6a9210d2764f714a093eff731dcb55ed14.1784856856.git.luizcap@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: Hpo6P-3G9ZSGxN5ZPEqd4roe8e1ndcp2
X-Proofpoint-ORIG-GUID: bSb6a6soED65r4O5K0zWqMWtVj-YvDn7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI3MDE0NCBTYWx0ZWRfXyZ7uk54aX2+6
 AoBig7mz3BHW3A6sCIp/1israkN4R2CnuP8v9sn7Baoa++HaprL+NoC4VS6OdKJQ/DOKHlksgmF
 7rRy+y7fv4jwHZ2SceT01/knP9Hjhf5mzzHplf5fNqcFi8xLf7QR9ZkoVWVCMugJ+5VXiQlpVby
 15yjJQFRp7fDyKVILNeqY1f16VekRsX9xNhJHinlzbRFIKRY3CP3CeqFo4aa5PVs1nXChBInFuI
 OnnnlHgvfKTksEvJm7eveuXISe6HXKLLw2wcOi8McanvcOU0M2bbFx6PylXJOsMmiTHmb5A2ys9
 TyrkkU6ozbgjQWAyO/ypsh1W/mKn4CH2gShGOTpyigM/Wq9UFISNposdSv5F5mvxUqGwcq8dnes
 YiflO1zu6+nk3lF9/CHtPARcOWgnXOR8hDjb9MjYFCuzTlPEEvgscUkyh/jAEgN5zUi91i8Z9Wg
 vWqDnmnMsdMrnr1VEyQ==
X-Authority-Analysis: v=2.4 cv=SKFykuvH c=1 sm=1 tr=0 ts=6a677c55 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=20KFwNOVAAAA:8
 a=7DZdcF_Zup3vnnvw1dUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI3MDE0NCBTYWx0ZWRfX12iEE3N1poRZ
 kwXZD4/RXfWwuS+MJuxL5wclF+l4F/HLs/UqIl5j9fL8BVNYXN3k4QatF4isne/GaNiHgFlE0JA
 M/1evJgtUMrsiIh6k7fkAXo9PiMc3FU=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-27_04,2026-07-24_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1011 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607270144
X-Stat-Signature: oq9qf7sh46wihnpah9ogy8u6byjacjp8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 21E694000D
X-HE-Tag: 1785166961-287564
X-HE-Meta: U2FsdGVkX1/rq50A95qVSbxzsYTW6OV7P/eMSsynbu8go0OEb+9hQjr5GFTpfjs8QZ33r61daf+I+iX5lKxFdkxTmEVjk4TXmtIrNTyI1PuYCkewHCIcLs5j3RKpTHjo6onOfFdlNlCD7Ah+ruMaRJgifX+H8O54qO/qvCMDFhMZXjN2tSX1liMivtGZ0HI/cMWjsIPkLGp+SYRUM8TIuy1KQCXx97v+O1WtVkLXsyZc2n0bXWyf05XPzTF34gXLjpGwDwPtdgblwQ32pIzPf9PFSDC33IpFs/Np2N9v85RIZ3TF1XHY6PlkFwd2kTt9ZnClRtCCPWHUGbrjo2V1G56OnRskC/PaOht8Mi+lHO6mzijqJXRh/vE8QXdvlyCTJrgp8zAw2VGCLGaFnvfwROFit+0hACFmLAme62XoG34w4o+F03mmCxxT73p6NKUF2Vpj0x3hZxqKDtCaDSRfgh532kXHXRG7nv5UrtgaTt0GAcTTleiA1tgfGC4JzBa0SN47UC4BL2YfjUp3H7gDkxDYSVpDztgUbQ3h/LET8y4JCJUD3BS45000QIofc4IYP2ir9y/ZVbizqfNKpMhC3ejvjzolCJF0AbzlbtK/QflcVwHkIY8ZhsqF6cyJpqfpzEj1w/xoftXRi21dFsSGtI33X6KGx18wxqwbum3Dv7inSLRJkzEUMly++6Tuvo/P0ojpR1WCDtDSdVTbK4b9W0A/VdLo+sBKGIOofo+YhM9gysOIVichNJa1s7z6DvrcTSF30YgZuEaeMmxml9f36cHLjR9iq0OAb0+G0iH+TYmLm9ruakLhsvnzfajaPTMSEMarv1o1a0jL1Q/IQbFtIMwtjZzTFJJzcj6vz7v1A9Y4igkT8EQ9O7jfCZ8aWCWC5DKtv0gnkbjRZv8m+NFPuMqukc/EPjcPmmotS3RyB6WwONvXsRShzfktNmz4v3D9Jzgoz/o/m1vkUdOUtZZ
 EsLiRR8P
 rcROU/MARjmEyPp6tvyHA9yUkVCg2QuxTvN4PXmwcg7EZ1xaeH4ugxfX4ETdV9ew0hV1n/29FELE9QELvTY8lpVIe8X56BZ1lnZSJnUxQcQ7J/0f3mfN9vWH9n9dCgEOmbvot5Oq8sUTCrHOMG257MsvD2DyvFgD1t0raywxYPtF3CvcR/2hkEnjt0l8+rg5QrXOeY4j/tYuYhjSwxMu8DtkdmM7jzAjBa3NFkykVV1HWVNHvtkSZBBi3VG9Ekwhq2xSjYuXW6cChWXLKJNTX11v0sCxnZczcN6zefUmxy6oTxnPe7L5cqZTc7QO7HiQ8Pg9H/xlpefBCrF6usg2ZPzoiuGW4orPmxbW4za7v1MvwNjUsveprMZz/BMXccCTpR54g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 09:34:12PM -0400, Luiz Capitulino wrote:
> has_transparent_hugepage() definition is guarded by
> CONFIG_TRANSPARENT_HUGEPAGE, but there's a need to use it when
                                   ^^^^^^^^^^^^^^
What need? The commit message needs to be self-sufficient or
at least explain why that it is a pre-requisite.

> CONFIG_TRANSPARENT_HUGEPAGE=n. Move the definition out of the THP guard.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  arch/s390/include/asm/pgtable.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks!

