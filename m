Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D546ACAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 09:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D44C8E0019; Wed,  8 Oct 2025 05:14:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3ABAA8E0002; Wed,  8 Oct 2025 05:14:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C1DC8E0019; Wed,  8 Oct 2025 05:14:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC478E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 05:14:04 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1CD559033
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:14:03 +0000 (UTC)
X-FDA: 83974385166.26.CA62FFE
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7C58E40006
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 09:14:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="i/kN9LKS";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759914841; a=rsa-sha256;
	cv=none;
	b=NyJMvltIhAVlgJXiN5wgYZX9yo59qOxyZVXSpK3/N/wvHsuKaR2jyZJx4dc+SQFZlmXQ63
	mJSLu7foIPhFiluormAoUJqJnsJLsQbQx1lJX+RKCnbvN9DvHK2D3KYOLlwRVGFlGkMB7t
	XRHs7xcfYmqLD/CjvJ4IvfnAkx8P4GY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="i/kN9LKS";
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf27.hostedemail.com: domain of sumanthk@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sumanthk@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759914841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QPruGH7fTf9jQZZnyfNgBfKH7Ef9ATtAqGNYbKyXYM0=;
	b=RgypXQKhS36jiDNJ7jRq1gYm/0aloX4Jz2aDfnlEvgF6IMJj45Tj5BkQz9GSrKaTeocHc0
	vLUJ+KbqMq0gCxmWwd3Ivcru3uJRKDNCE6wG0FqiNYRGwc2FJdf+S/53XQeKhfELlH7eFj
	s4oA5qRVwMCFSEthjJYMTcBdKvgCNWg=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5982Vevp030070;
	Wed, 8 Oct 2025 09:14:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QPruGH
	7fTf9jQZZnyfNgBfKH7Ef9ATtAqGNYbKyXYM0=; b=i/kN9LKSsmIECxE9pgj0Pk
	paFXt2sDl4b+d2sBH4uGOUVcKUec+xGrhyQbK0wIWCgmXsPveGyps1GWXHw+pKWz
	N4kN7G/tmKla269vrIm6mK4PdE0X8vVgQRisckMiL1u1we1omRiivBcvpw+LN5rs
	r4b/C5UjUUH9Yl+4u0MxMc/3Qw0ounpPdieaOZv+9mY/o2U9dQ9DwulkoXjjSQ6H
	s3NaLEKbh5+8j2yN0/KY3S/e6qqqseyXcmbQZbc4wjxyiHo/Vq/9DaQQTGLeDZ0z
	+LbfOTKEqpWHS9y6wp3LiJGMWkI0Xe/cljVA0WBws5gYI1QHRp99V33yKGyH+aOA
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49ju3h46td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 09:13:59 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59859MxQ028041;
	Wed, 8 Oct 2025 09:13:58 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49kewn7qwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Oct 2025 09:13:58 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5989Dsxl38404354
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Oct 2025 09:13:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9ABC92004D;
	Wed,  8 Oct 2025 09:13:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CB1420043;
	Wed,  8 Oct 2025 09:13:54 +0000 (GMT)
Received: from li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com (unknown [9.111.14.160])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  8 Oct 2025 09:13:54 +0000 (GMT)
Date: Wed, 8 Oct 2025 11:13:52 +0200
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH 0/4] Support dynamic (de)configuration of memory
Message-ID: <aOYrUEr-inqogzJE@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
References: <20250926131527.3260733-1-sumanthk@linux.ibm.com>
 <ab366c03-8c78-449d-bfc4-2d155212d9d7@redhat.com>
 <aOVUNmDiWgrDJ1dJ@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <5e3b16ec-9ef9-483e-b97e-bff0c1915b19@redhat.com>
 <aOX_L1_2S30XhLRA@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
 <1efcb368-fcdf-4bdd-8b94-a705b7806bc2@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1efcb368-fcdf-4bdd-8b94-a705b7806bc2@redhat.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDA0MDAxOCBTYWx0ZWRfX2SinUPWl76cz
 AjKGe/+vIb6wkkuw6snsxnXWw8uKHTIO5PX8ZtgaWkHm6x2aLt1nN+KYH89EnYoHdv9argm1nwQ
 NlCyOiYHCnWmsi1jz0fXmhUSxgXER53PFSh71pk0g22a6zf1/sPcUrFZk+scMcUxhfUHoXOy23p
 6fWLp5DjrexUoFTp3P/wLrLD5p3Y6fFzdp/Z5QG1xyCBYaQJZulxcKj22WlTp9CvMZpRMbosDhZ
 JvJSubMsHEzKqf3eRyxW3AQbXJnLRP8+KAOKBGD2wsoTrePfW3wMecwgNimPv6vJ9jFKTrxWRsa
 r30WYsftT8s0Hp+3DpEbIeVH/nJgS/pMQdPf/Dr0EoekvSQ8TIpyAdigJOUiyVx4ZLy/pHnCJi0
 QvG7PavYzOhbAbsjv48DHsK/MaI6Hg==
X-Authority-Analysis: v=2.4 cv=I4dohdgg c=1 sm=1 tr=0 ts=68e62b58 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=5lHgw4X1gRwckBSjVGgA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: frYyvW6OcdJeNiV13t28CQ7UrL4Xa7Gg
X-Proofpoint-ORIG-GUID: frYyvW6OcdJeNiV13t28CQ7UrL4Xa7Gg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-08_02,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 suspectscore=0 clxscore=1015 priorityscore=1501 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2510040018
X-Stat-Signature: xunenwa5otjeupges1eox9ama9zn4odj
X-Rspamd-Queue-Id: 7C58E40006
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759914841-22410
X-HE-Meta: U2FsdGVkX1/2EhatajAqz3G0dcUs07dgzpEVRiZPfNP34Dl7Ff2IQ/mqXl/d7/pJyosWlZ/bWxMixgOfyQkSBHNTB424+Qu1PqyQ5oETfktx3oeftahP+3qTa87Iq9BAUgGWYSSGS7OQhcT7y8/8r7bOapGfQFgELNABWskuyTjJRNCC7feg4oGJ+aSNj2w5XV2MmOj6QPZTIi45hYPKdmyjshoqqvRzdLeBVaTu/whzLb/YL5B3yRHBPPb793oauJGuGuGra1LnIdAcR4UX2+Ahh2D531BDdzjJ7ll7Z6RbTf1qpw0/10jnEZPLlAzcLV3px2LdYBXvxwZgAgkrWKwSCkVjsptUhiL8rJYBudxQiuwSVg6xC9zXT39QT0tOHZtZtMcxK8zyWbQyeRSA6b3rJlwhkYmbxvaBO1tNmiVn0B2yIybZJdT5rvYblR8+avbdBPBgt0ItP59nMIkEJBf41OKtjuzFbMOMmtgUyxnB6kcp7AnY7oZepV+XL4sUhSEnmbH7+fePod8m/aYAl1cAsrjWHyVYhQbh6+xv/0Og3aakNghBDCBjuLKJ0JoMBWZREDfhutUaLXCewfiRa20j3l+5aQOjVKkGQr1aolkKOQDimeGCoK/eLTDq4FMn+LCuQNHBPpYGN8GGt1J3CSn6aljmURDNhV6AJdC8Fm8+9/98hk1Ei7Su0l+Ykk4698QKyu1eqd6vT1fkYFAUaYHuCuTpyGaqaIzJZwcUPRmJVIMAxDsSC3sqYwYyiQDenTepczkg6JwiDiWzrg2GFz8v+/E61G+TqQYY2Vlr1DHPVLVVyXgNeBVvI1fk1Yld9zt8cELTvOIIITCq/5/s/ygd6EuKXJll0JZWnEaWfusGMk1ij3u1z9Nv3hKvlNL2RiqXw4eAA8Ysut8J1N99i/90K8dovihfJwE5dj7WzT2msdtXX/i33enTuM0uWqv1UtRXCHe5ewkrh9jnYfG
 f6ge9Fwh
 Em8p1iLcXuhKhlvU4ouOCGJ17lff9BbNMxfa3S3zLLKnt71qHKenF07qFYeuKPLjNf0wd9ryBYt5wRsdeEL2SkqA9P1bEJ4Oqsmnf3qhtmaqXFZmpp8YOii/MRznsRAsgahacMxIV40i7kSU7Rwt2/Hm5viZAKVa2d2UJvQL+y5AwA6djLa7kpuml4CzwwXGo4PGfKPYdx2BcP75RNvR+MQ1t5cIfzekuJ6K/A7BAW/6B2lt+gF54cfH5ZRDH7qD5u4CkJUkrec6tsL/9OzfW17lHCutojzCxsEMrjiWSp+h2gKc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > I wonder if the above two are really required. I would expect most/all users
> > > to simply keep using -e / -d.
> > > 
> > > Sure, there might be some corner cases, but I would assume most people to
> > > not want to care about memmap-on-memory with the new model.
> > 
> > I believe this remains very beneficial for customers in the following
> > scenario:
> > 
> > 1) Initial memory layout:
> > 4 GB configured online
> > 512 GB standby
> > 
> > If memory_hotplug.memmap_on_memory=Y is set in the kernel command line:
> > Suppose user requires more memory and onlines 256 GB. With memmap-on-memory
> > enabled, this likely succeeds by default.
> > 
> > Later, the user needs 256 GB of contiguous physical memory across memory
> > blocks. Then, the user can still configure those memory blocks with
> > memmap-on-memory disabled and online it.
> > 
> > 2) If the administrator forgets to configure
> > memory_hotplug.memmap_on_memory=Y, the following steps can be taken:
> > Rescue from OOM situations: configure with memmap-on-memory enabled, online it.
> 
> That's my point: I don't consider either very likely to be used by actual
> admins.
> 
> I guess in (1) it really only is a problem with very big memory blocks.
> Assuming a memory block is just 128 MiB (or even 1 GiB), you can add+online
> them individually. Once you succeeded with the first one (very likely), the
> other ones will follow.
> 
> Sure, if you are so low on memory that you cannot even a single memory
> block, then memmap-on-memory makes sense.
> 
> But note that memmap-on-memory was added to handle hotplug of large chunks
> of memory (large DIMM/NVDIMM, large CXL device) in one go, without the
> chance to add+online individual memory blocks incrementally.

Interesting. Thanks David.

Heiko suggested that memory increment size could also be upto
64GB. In that case, it might be useful.

https://lore.kernel.org/all/20250521142149.11483C95-hca@linux.ibm.com/

> That's also the reason why I didn't care so far to implement
> memmap-on-memory support for virito-mem: as we add+online individual (small)
> emmory blocks, the implementation effort for supporting memmap_on_memory was
> so far not warranted.
> 
> (it's a bit trickier for virtio-mem to implement :) )
> 
> -- 
> Cheers
> 
> David / dhildenb
> 

