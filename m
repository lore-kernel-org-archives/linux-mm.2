Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0506CCD187
	for <linux-mm@archiver.kernel.org>; Sun, 12 Oct 2025 16:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0B048E0007; Sun, 12 Oct 2025 12:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB928E0002; Sun, 12 Oct 2025 12:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA278E0007; Sun, 12 Oct 2025 12:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C795E8E0002
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 12:53:21 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 66E2484B71
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 16:53:21 +0000 (UTC)
X-FDA: 83990057802.27.B4AF319
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0785314000E
	for <linux-mm@kvack.org>; Sun, 12 Oct 2025 16:53:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BEg4aZ4f;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760287999; a=rsa-sha256;
	cv=none;
	b=oW+vAvP3qpgi7uSzW1QQ9EI861jUsXj5V/mn2cL/0FDus0FxoNPAWOsMNzxFXTVcg3Yn1k
	TSF53xndan+XACgmEIQYGQMCnUy4CPM4EeE6j4pQjd2sHxW9dqGSD9JMMuFCNRV/bpXGpd
	nF2Eb9FvRXl44RdAGYcE/rC0ENTjZDg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=BEg4aZ4f;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760287999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k+IjG48gXSLZIvwDyRg49bJXm99WApKLTC/kWT+9feE=;
	b=aIdqZECyXfQd90Hi6WQr2QebkShuJUiYlEiTs/bralz9ZkldJjNvGhzRfS4G18vjzBOkEN
	gwZWsylNbUcnnO93RqUKpNWSq+Cx8I6WpPBeZW+iAFbsd1fCRUYpUHHzINE8k8Qgb+bauA
	RtMfe1F8ljCer7DxPzrajxuD4WuiSBA=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59C2h43V008641;
	Sun, 12 Oct 2025 16:53:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=k+IjG48gXSLZIvwDyRg49bJXm99WAp
	KLTC/kWT+9feE=; b=BEg4aZ4fP6EnZ2EVZY0lRk8okP+8i9pqnPizPqbdniuclI
	HgnzgWDzO4IzJdk/XINJDlUmfb8ov3rwfshO5yMlJLxJvIn8FA6OI4ydzJ0Cn9SK
	pDSj4GhAJoV0LuSn/uU0oA9NGLx1xNOTdFhaRv4KiFHODTEK5pjr4YadUc6tEyoF
	e6YJlhu3gMaWgLlbKilS3pHadoUZQbrBayKQXo1x+0KgrBRHc2LVbkCU9vOsCJxo
	IfmW+pIOFct5PVFyVDqLNnABTC86FduF0q+GzmC/dksM+QHXGsvq+lAvEqSwtQO7
	Y2hiot4VjSUUbndyBpnfxjQMUHEQGBZdf+Elwq/g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49qewtn9s0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 12 Oct 2025 16:53:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59CD761C019531;
	Sun, 12 Oct 2025 16:53:16 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 49r2jma90h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 12 Oct 2025 16:53:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59CGrC1p8389034
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 12 Oct 2025 16:53:12 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A99120132;
	Sun, 12 Oct 2025 16:53:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BD0D920131;
	Sun, 12 Oct 2025 16:53:11 +0000 (GMT)
Received: from osiris (unknown [9.87.155.90])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 12 Oct 2025 16:53:11 +0000 (GMT)
Date: Sun, 12 Oct 2025 18:53:10 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>
Subject: Re: [PATCH v3 0/4] Support dynamic (de)configuration of memory
Message-ID: <20251012165310.56572A3d-hca@linux.ibm.com>
References: <20251010085147.2175918-1-sumanthk@linux.ibm.com>
 <20251011114426.5313b7cb6951618c20ab62ca@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251011114426.5313b7cb6951618c20ab62ca@linux-foundation.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 01PQDja_xbgElKHR2TdnRKhXwIJDSUh8
X-Authority-Analysis: v=2.4 cv=Kr1AGGWN c=1 sm=1 tr=0 ts=68ebdcfd cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=x6icFKpwvdMA:10 a=VnNF1IyMAAAA:8 a=amVAB9R6KjWVUBAK2OEA:9
 a=CjuIK1q_8ugA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 01PQDja_xbgElKHR2TdnRKhXwIJDSUh8
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDExMDAxNCBTYWx0ZWRfX7ZI9a5FEts5A
 /3agJNK2lThnDOJjuxKDdY0M3Nw9T+g5llBvVulTJD0GcVMHJju+mWB8tDZeTXpdtgeDFesVfSm
 geySesNVRllwQdGCOeqfTlf4B49oLSNCwOG/cZtor6v4qfG+332qOdXRt5vY68xitl3P4J6GTJ8
 SB7QuV4dLJey6QPuTN5H8YzGZX5/0iSrkAgPosxwV9SjKdTigRZo2ZYVQhRjCx1jlbtcpPyndST
 NJFdjp6C7kQnCrj92j1xCDZrtTAssr+3i89A5mtoU9rEPVU2Lslb2knWUbJQKdWHIrjhV4UaKGd
 /P80iFEGTFdNFdaqFNmtyo0jwKlr+CqsYTKKrwZ3NJohJTRaUKfGTFPu+NvggQgwRbWRwQWfW5i
 ZC7M+S657oSeVpkQv08bZEglkEJZSg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-12_06,2025-10-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 lowpriorityscore=0 bulkscore=0 adultscore=0
 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510110014
X-Stat-Signature: zos7zc9r3azdf5yewaees63mxz8e9eyj
X-Rspamd-Queue-Id: 0785314000E
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760287998-368548
X-HE-Meta: U2FsdGVkX193Bg9QRZpFa6f7bOeFc/4k9FNKF5d0z55n/8YCDnfOgrhsh7qzjbFGT36kpLShq7a1D/cqz/c7NfBhCb7j41IM6DOt05TFt7uq8jRNukJVAwP7gz0Rk1GUunSak++CT7Gs7guYHMVdiU8TBpOVTcWigXeeJuinRBIyN+cm6PwV0ttPNPhhjH0ixGgmUqC/e7/bicRHTSwvwTfrGoSR+vvpqw+IPLDE493styRYuS2WNo4rZTY7m+IPCQKaHw9Sh0jDsmL93ZD01C8xg495N7E3Ak3400UatZT73Yh4ulVJj3pTSaLalmwfnqX00YmpulZniIfcFBAnqo8csmwwo2bH0nn/a38AZPsO8a+jcNuJ4RcsMYXGUXjNDv83DMzVn4E7T7mvYZ18BRC2I8GPjj0iiSIkKCCja27pq5v4TxBm3T9RWVhdycjKVHer+dett3uTJmrQSLNu2RdyKTL9/AKeRQmne+Jb4MSsb89OjXzSZIEK+iSfBvWTs92q6DyxfqBE6Y5NGjBF52uPzY4O9FZFaDoxjXfZvwY4YLW2ujk5Gq519nRJ/U/5j9VeMw6MIKc0xHY+gxHMOxi9O6jLJfUdxaBKKiOB5A786sPHCba3hadBXTcA87EDOLDvn0DhHIxw16Xowmys41Cs1hMss8UohX+OnAuYprHV1+RtR6SSepF9HsPk81aNSzbhVuGwU6+Xy9P2U2hlGT5x/V7VIcCRGWE04ItmJNmkSb+osu5Xqk4uFMEck8uAlbdYvaPblEXDhJALaPgVvUariEdvq7laA/BE2ayNWkE3tMC7ddR99V68pvhx6YspvomP3fOgJrlFX64gx0t3mUUNKXaaK/0ieB2WTryacsLQV14P1dwsL6odHg9inXNnCJn2wl6HApZVhl0X2qSJIGzG8U3gHKOUPvv9RXZQ/jkA8iwkImMWQjlAwk3YEqeCLuNTzTtyJlpakYiDKZS
 GkAh0NQj
 87PJagqruxEKgbwasK+8ZFAO42SatJuG7yZSHCiBZotBXzqjlh3p0GwBFwgjBIRWkumEm6TClt69luMEg42N4TCTNi/k3Yj5TA0CnOn2e4f7FsWnRRs/LyqLpzH0PYXOGmtWD0ZBkayAoJXfY6QfOjNcmwK/R3t3F/ijMKcyqeoYJL7kh7424Cb1YJgvYeQFBeK5c1LiOk0rdrqowyJZDCUj4y3pqvn7DZMD676NqwRGaF+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 11, 2025 at 11:44:26AM -0700, Andrew Morton wrote:
> On Fri, 10 Oct 2025 10:51:43 +0200 Sumanth Korikkar <sumanthk@linux.ibm.com> wrote:
> > Patchset provides a new interface for dynamic configuration and
> > deconfiguration of hotplug memory on s390, allowing with/without
> > memmap_on_memory support. It is a follow up on the discussion with David
> > when introducing memmap_on_memory support for s390 and support dynamic
> > (de)configuration of memory:
> > 
> > ...
> >
> >  arch/s390/mm/pgalloc.c         |   2 +
> >  arch/s390/mm/vmem.c            |  21 +--
> >  drivers/base/memory.c          |  23 +--
> >  drivers/s390/char/sclp_mem.c   | 288 +++++++++++++++++++++++----------
> >  include/linux/memory.h         |   9 --
> >  include/linux/memory_hotplug.h |  18 +--
> >  include/linux/memremap.h       |   1 -
> >  mm/memory_hotplug.c            |  17 +-
> >  mm/sparse.c                    |   3 +-
> >  9 files changed, 225 insertions(+), 157 deletions(-)
> 
> I can add this to mm.git in the usual fashion, but the s390 tree would
> be a better place from a testing point of view?

It is not only about the testing point of view. We also want the
correspondig util-linux changes upstream - there may (or much more likely
may not) feedback which could require additional changes. Which means we
would going back and forth.

I think it is easiest to move forward with the s390 tree because of this.

