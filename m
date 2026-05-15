Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 134ADCD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 16:28:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D4DF6B008C; Fri, 15 May 2026 12:28:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786E96B0092; Fri, 15 May 2026 12:28:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675686B009F; Fri, 15 May 2026 12:28:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 526186B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:28:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07D301C00B6
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:28:23 +0000 (UTC)
X-FDA: 84770186886.11.B296E9D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9210B8000A
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:28:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bb5l1PMM;
	spf=pass (imf02.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778862500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTyLvnc7a30FszlNQUw0zOTJPAtRhnN7+363lZhWLlo=;
	b=RA36mSc8vhXejCIN24Wi3mX5D4HjFHbZR72TXarDdPZKZL7RC2UEHzRIHM8RJVOYbIRzly
	RuVX/KZ1Ce5j9azTlBRnv2TqBh86H6w+0ElEnhqZgDWNyb0sUx6nFd2llcnZEO9V/C9Iat
	GAUQayWFmsgEEzX2ijdMkjqq8Gq2sng=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=bb5l1PMM;
	spf=pass (imf02.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778862500; a=rsa-sha256;
	cv=none;
	b=hgKnD8FKjWxJrFFdCGjKmCO/RiRk8VaZoErN7pJujYRC2CF2Bh+2/cDo5mMPI12rWBZYMi
	SP32czoDNueZncNU2dwKFZZQiDq97ULQzGfrO6fUkxX+tzZ0txJ1lBXaDBdnjj5oIhuhTA
	D1NkAK8S2sCjZ04Trd16Gbos/tQlfHY=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64FB1cdK393522;
	Fri, 15 May 2026 16:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KTyLvnc7a30FszlNQUw0zOTJPAtRhn
	N7+363lZhWLlo=; b=bb5l1PMMf1FqFX/tGLriLbIQYiV3VDSmjo2EeMd7AMmWmA
	2hkRp9aSfAlz2TuwuzAO3ZTYJzdZudXarFhbC6OfaZwRNYXW5Pw3LGqDlKx6AD7J
	gADfjG2KvEJsvIywoL9w5Sf9Thb4JazFU37onU4rdhP0IKOxiwlbncQ/rREqqrxM
	HuUDHyArrPr4Geffrsen0UaUKv1edTusKu46giaAGf8SITOY6VBfKxCb0kaPFZkQ
	49zIJbpyLP0t2iQ3PmHfJa9Q/6zR4PRULDay8PZE6JKZjO1B8UqMIZaxJsm4fcMI
	dL8lHjxRkvT1MoiPqX+OQififOg3Z14wTzSXwRWQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e5m8vc539-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 May 2026 16:28:11 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64FGO7K1026003;
	Fri, 15 May 2026 16:28:10 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e5m3am8wb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 15 May 2026 16:28:10 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64FGS7R451970304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 May 2026 16:28:07 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F0A9320040;
	Fri, 15 May 2026 16:28:06 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5351E20043;
	Fri, 15 May 2026 16:28:06 +0000 (GMT)
Received: from osiris (unknown [9.87.152.91])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Fri, 15 May 2026 16:28:06 +0000 (GMT)
Date: Fri, 15 May 2026 18:28:04 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Yang Shi <yang@os.amperecomputing.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, cl@gentwo.org,
        dennis@kernel.org, tj@kernel.org, urezki@gmail.com,
        catalin.marinas@arm.com, will@kernel.org, ryan.roberts@arm.com,
        akpm@linux-foundation.org, gor@linux.ibm.com, agordeev@linux.ibm.com,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v1 PATCH 0/11] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
Message-ID: <20260515162804.10935A18-hca@linux.ibm.com>
References: <20260429170758.3018959-1-yang@os.amperecomputing.com>
 <d16893b5-3a21-4595-b4ce-e34a7e8a199c@kernel.org>
 <583d5984-fc21-4204-9845-8ceabacf823f@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <583d5984-fc21-4204-9845-8ceabacf823f@os.amperecomputing.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: wqAuYEqpyC0PwdB9XTu9vOodcN-WAZSN
X-Authority-Analysis: v=2.4 cv=duXrzVg4 c=1 sm=1 tr=0 ts=6a07499c cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=kj9zAlcOel0A:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=Ilrfog-IFM-LmiIkkiEA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: Ep4EDxbuyWSfO4E6e2i8hUChjCMZkeqE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTE1MDE2NCBTYWx0ZWRfX9QwzjTNjAdg8
 zvaaTNbk7r8YnJhAfC4qzFf+enpfMiIs7SYxiwu3DMBBqBGH0HiNNZYunznOi4KY56xMf7NIqVG
 nXBsIwP+a0lHialoCZBVoZ6B0GzN54eafdP/8K0lgA/d1ckJHWKBnE7lcuGBibul+pQVHhhpXOJ
 AQ6BLt9FgcMdBzPP7o/CGcVexl+YW1Kc9uRXyf67j0gdJKE/cd1DOK8H0qKqW1i+TzRU1SY2KBZ
 B4IUn5DCyIHE9R1SaS8rWspYke+SDb+8fvmpuJGJTd7Kvd9KHgtKMJ8zLZ4ndyrJBLvCPIg7XfN
 4C/s0dcQnw2okOJU+kymeT7U5RM8sabO0TXiTHPzzOqPU3KDr34RfIv/QgNkZAKsNUWYAOlKjV3
 7IhpOz8OzrE2bthGyY7RvHK5gEDeM7/srz53S5v86y5jKY7PhuIKPn2dAk51DUtHGQOX5mBiVSf
 1AF+e1H5nADyY2v6RxQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-15_04,2026-05-15_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 clxscore=1015 priorityscore=1501 phishscore=0 bulkscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605150164
X-Stat-Signature: q7464wabcbz4ihs8d46a4x9d3i68zqbf
X-Rspamd-Queue-Id: 9210B8000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778862500-642584
X-HE-Meta: U2FsdGVkX197+g+52hJkrlYd2FfHy3piAzpfWfzpSFfretdoL8xTK5Gef27cQLgkU8GINJTgcSQSlVSBm8PoTdwFGlUfcY+MkPtXKpqu0ubFFboDPIZWnFEZucjLXi3ylGG/j8qDuqRQzqDzqCJH7h7oi/fDnlcQTUGCuFZSwiDeG7VlXw0HO+//DYioloUX7Uah00eP8a9/SXAeyk4Q5X6PVpd6k2CEmglazpqwNzr3lJ7tXj5JX7ElhcNf5b8hJaC4N1qzGhBeYKcj5egmxiQflNIds3ufMlIk1SazbQv6aN9LuRXILkLGtSXcpUEJ36zSJQ0b09nid9s8KTBmCADcUKjEq9JKu020bP7lcl2EJ9NnJu2CtRwnQF0Y2BTnKcLgqgTltuUkxIq0UsKO0S8N5dm+BuU3KMSJXUMIXgTRjl7n6NnA/I89FkXdZpx/4nJSw7EBkgsNJN6NteC5nU1hCUkzYATlwDr/I1FkiCylBNNMLa8gA6jB0ZT26PXS+W2M9s714YHmt27D42KJiQomwlkzIjJaNNI+xbICljw60R4lo3fwT2HGGhN3BSWwjjcTiRTSsmxDdwqFHVpIzkTmIJxzl4qwoDy8UMaQ+LG5kfqKVUqdwG7cQRi0WHvgBbusoPhY514sfl/pMkneIqYpGbtWyKPC1H7j7ydNYiwsfRSYAJMKqoWPto1TnwjOdnMoHZQ95HHfLROBvC7yeIaRF/OHY+jr3c+qC0UVFF9JTqcE197A4raEJns3nd4hwY+AcdHwYimCY8fvG9NlhxsduRB5z/SBvI5zDHVJV0p00vC3BxTrxVhB35CEIxxcOvrPdGTOSIT01sHoxBv5zXJUZzPS9CX4eIitIwI0oztNnsGAtwQfpHPHgm0QMxorIb5WXhFIdUZ3scHjN5JATpR69a7hxHrDa8fdPCjGquuovnaDrxs6SIPYdZ9SodlKGc/iu9qx+qHI4DGFw7h
 o/WjKSLV
 t8mw4Hd0gSVkgw41ccz0V/rhI6zIDMZxYQ6/RuNWHc6OQeDJYhWftfvyoNVjNyN412jemg7jFEMMWY+We4C/C2TfNgcSBlmzUONaxBEso6TFpFFwqBC/riRK+sJSeuEOmaMlFIP4IyEVsyi03rv/OU3eVRHYH1jFCZcfF03+AMaZ6PHADWtp9PB3E3mxJ3722XHAPUc5A4+yefSS4tdffmmlLueacXWZPE37wtAlG+/N6xhQdkpuMP5dH5VwzmNzLMUyE4C1az624as0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 05:00:19PM -0700, Yang Shi wrote:
> On 5/12/26 2:02 AM, David Hildenbrand (Arm) wrote:
> > There was quite some feedback during the LSF/MM session, what's the current plan?
...
> I'm not sure whether S390 folks will implement this on S390 or not, anyway
> they are cc'ed.

I'm not sure yet, however after I had a look at the architecture documentation
a couple of weeks ago, I think it shouldn't be too hard to get this working on
s390 as well. I was a bit concerned about TLB flushing, if changes to the
kernel mapping happen with per-cpu page tables, but as of now I believe this
shouldn't cause any harm (famous last words...).

