Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D101FCCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 14:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FBE8E000A; Tue,  7 Oct 2025 10:30:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9A48E0005; Tue,  7 Oct 2025 10:30:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA83A8E000A; Tue,  7 Oct 2025 10:30:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C4AAE8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:30:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 688591DCA77
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 14:30:31 +0000 (UTC)
X-FDA: 83971553862.06.0BF7EB2
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id 03CA4140023
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 14:30:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CwYYfD2l;
	spf=pass (imf26.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759847429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIQG8fe18Cm5jfwgp1PcSo86AFXK7b2BBlHnYTtTuIM=;
	b=diw1q6uTe6vstsUT2/3N+bMcjxYErAG35arkj8/1qJ7Tft+TdibfNOzvR1jrCQrK9HlHCj
	1OZLZ3BOl++knYYKEbBs3an2cLXhzcHU0S/1zZUuUlVfgRZd2dtGvwPCkpY9Fs32PSb80E
	dlH/Q5/YH2RanZA/VG5vH+P32ZzyvII=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CwYYfD2l;
	spf=pass (imf26.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759847429; a=rsa-sha256;
	cv=none;
	b=NAos97Yvsf/PtGsCXESd+2V5TqmY3TpbEvgOGqM+KugOvovDZSLw1QUrCZ/Nr5q1VGzzHT
	dVpsKFLl4QEvM+Qr09slT9Fu0pHtL8Q8ha/9BABEd85QgPJJx2iMUJfJyfJxJpj1pCA6hP
	KDVaTQ7yMNGb0YW0gSs2sme1coZllWc=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 597BF7i8031517;
	Tue, 7 Oct 2025 14:30:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KIQG8fe18Cm5jfwgp1PcSo86AFXK7b
	2BBlHnYTtTuIM=; b=CwYYfD2lrxdBqH48n17aAykQR5P+PvM+gXkItNXLycqN4L
	vYkoBl5oohmVfU+70xqsp5wXoSk2SL4RtRoJj8SL968ZQpL/KY7eQsHvYhjxQuwW
	kX4udQrdFhoxJkY39JPU0ExVn3PCmxOYhxlXARi7lbMAqyyMuiIuqO6k+Klee753
	gCN7u60SGOJ7jVb92f5SVMWnstdn7ip8GXG/BfMfFlJOLNJitXzIiNV746qTkHHd
	F33eH+w9uVFPHfkE5jwBmtsfDeS93WNYsPI5D4ipFFH2X1VIgq1Zy66UDOmSE0S6
	4k3sqKkGwrnZVjMx7nEcQVdKhMUjxT9vcbj5biTA==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49ju8aq37r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Oct 2025 14:30:27 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 597CeRC9019601;
	Tue, 7 Oct 2025 14:30:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 49kdwsbv1y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 07 Oct 2025 14:30:26 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 597EUNax53477864
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 7 Oct 2025 14:30:23 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0247420040;
	Tue,  7 Oct 2025 14:30:23 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 936F520043;
	Tue,  7 Oct 2025 14:30:22 +0000 (GMT)
Received: from li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com (unknown [9.111.19.165])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  7 Oct 2025 14:30:22 +0000 (GMT)
Date: Tue, 7 Oct 2025 16:30:21 +0200
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@redhat.com>, linux-mm <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH 0/4] Support dynamic (de)configuration of memory
Message-ID: <aOUj_RE8z9OiIIfN@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: PdkXKFhNzTG2BT8DipAPd1uZ87BQphbV
X-Authority-Analysis: v=2.4 cv=BpiQAIX5 c=1 sm=1 tr=0 ts=68e52403 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
 a=VnNF1IyMAAAA:8 a=w9My_uIrVxvTaZuSxxAA:9 a=CjuIK1q_8ugA:10
 a=HhbK4dLum7pmb74im6QT:22 a=cPQSjfK2_nFv0Q5t_7PE:22 a=pHzHmUro8NiASowvMSCR:22
 a=Ew2E2A-JSTLzCXPT_086:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAyMiBTYWx0ZWRfX/tzvw3cApgKZ
 ONyKqQVhsLg6ZJvP2trmG55xOCkFAKZ7rwkNlxFpvKy2DdcVbtpTE2QsTCCIuF5ZwONxvIu5fK6
 OTJAy4WeFfjs6kdZz0a2Z8TiF2RP3FB110TP6GPoWYjNV64WXPcYHqcfNEj07g1dVRXNV1y/ZeA
 ORaL+5YDnl0Cjphe38y2uIOOmWkX2xRbgtnxtddU+96nHVBUKtHK6EToiaeVD7Xb0iYk8YfFdJk
 2BwbeN6UXRxFQEr7kZ5S91yKpLmkyiV9mXqX1B8E5q4GKoLT1tdzOx0tZW04TkCC9FGTB8aP+A0
 xixHAVY8S3Z8/IM2p7TKvjv/uwNJFpn1t0DfEd8xr50eP//PX56KYAUoeUrbIHdvDRgp+eRwF0j
 Lv9Nm2fMvHRvOCJ9ORwsT8v84u4ZGA==
X-Proofpoint-ORIG-GUID: PdkXKFhNzTG2BT8DipAPd1uZ87BQphbV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-07_01,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 suspectscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2509150000
 definitions=main-2510040022
X-Stat-Signature: ym1ezbufaidxpjbpkpi6ppw3xh1urso8
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 03CA4140023
X-HE-Tag: 1759847428-856002
X-HE-Meta: U2FsdGVkX1/MDkg5hCCHVn5No0t9VAlraVsrWJ9K+36Hd6Ggo0hSLzQa0wG2H/FWadkvA94dWxCLH/BMDyV7t8aL0r1984MHuDX00wUebePwJNf8GzlRZR7A/HvUGJr1MK2GcT4aX+t0809oehM0oadeiCLAoukPfu6fkuD/BX7OcJLH3OnGODVDpeh/nFlYduOOeacbTiy3p2ZeePXYaSxrfOBSOwroMr0CsActlvbffQPg61kvdzpfcEslRh5p1yw16mG7Mu+rq4I+pB61U+7XJ8zS7zKiI5zW/4lXCYUrQ3NPQcKgAJS4fXGW7Bhh2gz08xOv2ATn0v3Plvc+2PuMQZaD8/dl0UF2kRpL4w7Hex+gq8JlDk5yZnHJ7NV0eG04Z2W9ylykms820DKk8TnVacV9IdPw0ci6OTdgufxzLS/gErP3redhHmoXt6rU4mjQLZe8/Z8cwN8C/BBPPcRrDOvrkM+5BuDuK82EGH2DtXKBR5vDU/FIOBKpUcWNglQ6tSKnhUUmO+GiVrTXiUeJAufNShSguyepy1f2GpGvWcCt57R1GhhrI5A2pha8C88pvhNXCnDXTrcMapqBKZkF4p/TOl20G9eAR5dly56/J0+0qjy9D+D2skMi19UGA4VrhU/J0g9eGI3L3egNzvVNzmqi+IGPPYo6bieJNnA707tekyC597hgig/mMcm3FgU9qREVKC2pc2yjXDoQzA5TsmJ4pityLLX1C4f3LmyIOgJlWb7kWtXY62zLFXf6WGMP1RVQBmk9Ri2FcVVhQM9dlAWgyUY1Bhr2GFQ2RxXbT97WB00Tel7IYcGXSXM9cRfcSXO/aZZNnrfwePrE3xTk3ah4a4JIwZdxfidgtEC/MqSJfNEuU3xNPN63FEp7hrqk/dYJCedkzbgjFOG+IGSIOVN2s+vNwUEC4umyOfsOkB5F8UEq4+DZOID4CAKyHtaGtOTzi6CnKn9ETqu
 NG8LLSCO
 BtbQvKLFRDtHWYSId085/LlJXLcjF+ufnWx4dSwDxNYFTLMyXbdJ3bYqmcr6mZn6AEVce2t3pPQkI7HPEWrESVZiqBnZTh4/r67utn96Y0m5c9/a/H42PLMNRKyF0jyWflKhmLY2AGB91P7a9Kx38ipvLVs0d2SSUL/yiGPPuEXQm8Csxf5VPctjvcVPMhg7/YZKw/4kZ56xspjua7jG7/d1md9pdvFQtFx8SjnJlkfL8Xs56o9r7CmnRtszjI5RWYk4SWNBRqfb2v0h3OoDc5S6s4uiMYO61vDryPctOQnVtN6SabSj+DkMOxzzK1riVkv85hRCPf33ft/m01MJ4iS/sD/Ts65LKk7VWu6bGML9GgbNNcB4BtMWrQxWo49BgcBts
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 03:15:23PM +0200, Sumanth Korikkar wrote:
> Hi,
> 
> Patchset provides a new interface for dynamic configuration and
> deconfiguration of hotplug memory on s390, allowing with/without
> memmap_on_memory support. It is a follow up on the discussion with David
> when introducing memmap_on_memory support for s390 and support dynamic
> (de)configuration of memory:
> https://lore.kernel.org/all/ee492da8-74b4-4a97-8b24-73e07257f01d@redhat.com/
> https://lore.kernel.org/all/20241202082732.3959803-1-sumanthk@linux.ibm.com/
> 
> The original motivation for introducing memmap_on_memory on s390 was to
> avoid using online memory to store struct pages metadata, particularly
> for standby memory blocks. This became critical in cases where there was
> an imbalance between standby and online memory, potentially leading to
> boot failures due to insufficient memory for metadata allocation.
> 
> To address this, memmap_on_memory was utilized on s390. However, in its
> current form, it adds struct pages metadata at the start of each memory
> block at the time of addition (only standby memory), and this
> configuration is static. It cannot be changed at runtime  (When the user
> needs continuous physical memory).
> 
> Inorder to provide more flexibility to the user and overcome the above
> limitation, add an option to dynamically configure and deconfigure
> hotpluggable memory block with/without memmap_on_memory.
> 
> With the new interface, s390 will not add all possible hotplug memory in
> advance, like before, to make it visible in sysfs for online/offline
> actions. Instead, before memory block can be set online, it has to be
> configured via a new interface in /sys/firmware/memory/memoryX/config,
> which makes s390 similar to others.  i.e. Adding of hotpluggable memory is
> controlled by the user instead of adding it at boottime.

Hi David,

Looking forward to your feedback to proceed further.

Thank you,
Sumanth

