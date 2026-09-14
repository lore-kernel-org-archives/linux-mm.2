Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B727C88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 18:00:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A16C6B0088; Mon, 14 Sep 2026 14:00:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 452386B008C; Mon, 14 Sep 2026 14:00:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 340A06B0092; Mon, 14 Sep 2026 14:00:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 079106B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:00:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1DFEC022E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:00:03 +0000 (UTC)
X-FDA: 85213131486.25.1DCBF2F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8B26040002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:00:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CQFL0ieY;
	spf=pass (imf07.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789408801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n6XWvEkjUJhke/eXYBmSDyCZt3sChRVssS0jrboyjOE=;
	b=YcPqATorDHwz4dNYD2QNMXWBJaB62jCueQqXkpe21qCe/1nEk74w0vkNBkinNR+h7e3msK
	hoEkGtc08K3VCaxHbYuIKfUhccnPX7DEHcrS80j3FzdwNegCDnNu6TawIf9uEPxsPP0E/0
	3uE8R2ZNMIe93Xm7kyBdC8ZQFyPkHQM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789408801;
	b=WrGo5bozoN8wRtExS1QRRKLmLCQzzdeejP7akVwE6lgeEDsRd42DYNiXa4i6kQTWTxShJW
	hEPanqOLSLm1jvzcxPALmGQ0+ZiExYAIH5pSZUrrr9pxEABkbEImDv7TAf7CgV6fvtkRsu
	6EqPCOhplHqj4EO74tv2NUGmSquvPkw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CQFL0ieY;
	spf=pass (imf07.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68EFvoxw2495162;
	Mon, 14 Sep 2026 17:59:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=n6XWvEkjUJhke/eXYBmSDyCZt3sChR
	VssS0jrboyjOE=; b=CQFL0ieYaPas4IYdV09CQtevlNKjrDVFKrgYocAup/KyrO
	KXLBYiDsue7gh1DvI/djTq7k6OB0oOFEHmBH8LXl8WzmsdqFqds7uuD/vmQC26MP
	sNe7OaM8xaxkgvhMYPK6zYfEjVHI/MOVH2zdsy4i0OwOPLnxy0rnWrgVTqHrQOQ5
	t0wzfOP+lOQGH2dB+acDHIltiAHWlDvMZ0iKGEyT3cwqv1F7UqU38U0qTEgfsO/y
	DUczkLh/G6azIqmtJHe+i5MzHXjb/hoLoZgMOa1UkAJ54AQ+p6mWPl0fUX/np2aG
	Kw9T7/a/TwhlTEKYMIyogrHnlXe9lSrYIoO1vdlw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gmxf4u46g-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 14 Sep 2026 17:59:59 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68EGVNK82359957;
	Mon, 14 Sep 2026 17:59:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gnh2pykx1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 14 Sep 2026 17:59:58 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68EHxsXj50659592
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Sep 2026 17:59:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 278ED20043;
	Mon, 14 Sep 2026 17:59:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B817420040;
	Mon, 14 Sep 2026 17:59:53 +0000 (GMT)
Received: from osiris (unknown [9.87.150.220])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 14 Sep 2026 17:59:53 +0000 (GMT)
Date: Mon, 14 Sep 2026 19:59:52 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 06/13] s390/cmf: Use kmalloc() for the CMB area
Message-ID: <20260914175952.14910Fc6-hca@linux.ibm.com>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
 <20260910-s390-cio-ready-v2-6-e931086fdde1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910-s390-cio-ready-v2-6-e931086fdde1@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: iVRITbDW7x6rY8UOuc8lzGASFfpPHKxm
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE0MDI0OCBTYWx0ZWRfX/jZQYnZDbspo
 eLajtSQuqN9l0P5gCRh/QYG+6NNOuVHNNhWcfApZ8JRauj6x4zbcS1VY8XIapyH2h6wAZV6+KIJ
 QZiLrt26q8/G/CsYkXX0vlPXiuiBqn4=
X-Authority-Analysis: v=2.4 cv=cvgOAF4i c=1 sm=1 tr=0 ts=6aa8361f cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=w3GGswcpYwqc3GNkgiYA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-ORIG-GUID: iVRITbDW7x6rY8UOuc8lzGASFfpPHKxm
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE0MDI0OCBTYWx0ZWRfXwret4GbqXc8u
 3ZDt6AjnA37okgOmgPCEI6KAKhAXtude1C8F0ksDzCP32Hh0Jx4cpLaLXyD0SiyEtZRc9DGo9xx
 J+r0m4wIdtZdU/LCRe8GBktgpoSju0CCH1+qOCxOskrOKMLh71r96gNjw1ibURKfEaPqo8egtZV
 8Xr6y2f5gLKJkNRyRTjfmyTyg8PIwnDBDERTZUZ3qQMmf8XR0BbbKTXDiNYZcFv/q6Bf4W0Vxue
 LejoyLKTfAu5zXUvKUwD/7XjzCaREtVsQBaov2DwTqQOWItmFn1yS00ike1VZVeFV+O0bsBLN9s
 L6wbcfy3CJUzY+qPoMzb3JfTx+VsgyVYWBhnKU8y2L1Yp8auH9Tlb6jLGhEZNkepxoiTzx429fj
 bJKEHPRyjRPRL+hv7A2cqcjA4D89mHaElKGt9Wmg8/n/TJVZGDBlbaX8h8kFmWYE50Evn0gTz0F
 s5/yXqW9BoTmKZdP2jA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-14_03,2026-09-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 suspectscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609140248
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: no7zd9oyrre83kq6sxk7dbn4sfhjbs5j
X-Rspamd-Queue-Id: 8B26040002
X-HE-Tag: 1789408801-990384
X-HE-Meta: U2FsdGVkX1+2I2F2soFvtD5i5SmOM0zsVw60fswrwd0MbnRVEXjZMsGpyO6/oBb5AtMiXtPz7XdrMA1psCBZQcAkI2tM+0XWnH7VTyjPCKQ3xBMhO2ImYUmiYEuA1pchJyohzifF9nySFLjSLF5pItY6X925nqYUYBKS3cNJwmj9TK7kfoVb93hfrNvCr7bThx7ld0YL5ykWfnKvfGoC0kH0B+4efpV+smjlFZ/qtb4vDUAwOX3s0hm7qfSUI/2huzd0VPtejkybigkpwSRj7HKpkMKqLCSd/aByYleYTO+Jb6p0HoIvPwafqbNa5AX8ZyuvIgZwhQG7IHth+aNKDR0DPRygyoyA5SyneyxgVv7ipy/yNdUlxCbeSt9q8dPC+QBZ6rtDn49LHUK0geit56HsqrMqpQ7l9+jP1C3W8jw+633Dy7MA2VwjuD4GB7jnqLIsikJzH0MMyqXDowjIGW2acg64iyz9k8IzO+ZzJGGrqWkbu9AZaqM5CyFvoWGcxXT2YJmPcpulQCpnLBZeBpKUDqlaSGbMgmf+G6VjRCe65cNc2cX0OpVWaV/JFsxsx6NjAyPyilqx8bYCPwItJMej13gm0vUCbC11PPbMFG/QHFSYh2G9dV14O+ZBUsB9HB7j/3Jt62xrBHLypXNoopWOVK60VmKbWX2nmPiabtcPCpoMMoG1ptVJYNoc3UREOqw6odllKtV67h++EtMHY6RmS7CiX37HEU7u5j+lpS/xmxxdtF0Bv1Rx2FZCYMvhk6YR0VKmm08MBzy6FKf2HfFK8FzhtB12qLl8Xvt1QVvRmJMYS36zq39FmBJVM0BkrpQ/8g/dU/SC0Gsy1jLkHP4ANBn4c405CqjmvQEWkiYw4BE+lTlsNE9VbEeLfxdpNqVNYyDyzKFVH+L09vqIVxkz+o5UwO66W81D4mjo+h9OMilGjT4fz9pnyVp3IPMcEIIeKIV3wizyCDqp0nP
 F2izp/Yo
 FsxGqsRputUsf5FHL/FOeUMzDnsGUIHy2RJnjwtKeatR3AF3U03aZm6NPsAS3P31ij7t5kRw5znaLxGv/wEpWvMj8sbZVjnh8i4jYngWblpEbuBaX2Z0yL3V/ZBZy2lCpjb/v7N/FhQgNnkFDle+SfN3OEWFaaOafdshyfLOO5lCUkVzN+cFC95U4c9JMwMqfnzPBJsglfYYCXKSHj52Q9hpfJX6daHcvVEY5G5UD3l5amxVuu88Huq62qgke/nTgyVLJPHwfXoQrdVkZ21ke/+UQ43HIdlAvLG2kvCP5XEhPeRVcSNlBGptdWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 02:00:08PM +0300, Mike Rapoport (Microsoft) wrote:
> alloc_cmb() allocates the channel measurement block area shared by
> devices using the basic channel measurement format.
...
> The measurement block origin must be 32-byte aligned. Each CMB is
> 32 bytes, so kmalloc() provides the required alignment without rounding
> the allocation to a power-of-two number of pages. Reject an empty area
> before allocating it.
> 
> Replace use of __get_free_pages() with kmalloc() and free_pages() with
> kfree().
...
>  		spin_unlock(&cmb_area.lock);
> -		mem = (void *)__get_free_pages(GFP_KERNEL, get_order(size));
> +		mem = kmalloc(size, GFP_KERNEL);
>  		spin_lock(&cmb_area.lock);
>  
>  		if (cmb_area.mem) {
>  			/* ok, another thread was faster */
> -			free_pages((unsigned long)mem, get_order(size));
> +			kfree(mem);
>  		} else if (!mem) {
>  			/* no luck */
>  			ret = -ENOMEM;

This is the only patch which made me raise an eyebrow, since the allocated
area is smaller. But it looks all good according to the architecture.
Since the allocation changed anyway, it might also make sense to switch to
kzalloc() and get rid of the subsequent memset() (not in the context of the
above diff).
But... I doubt it is worth it to send yet another version just for this.

The whole series looks good to me. Vineeth, Peter, any thoughts?

