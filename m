Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17810EBFD21
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:15:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844976B0089; Mon, 13 Apr 2026 05:15:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5B16B008A; Mon, 13 Apr 2026 05:15:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4E86B0092; Mon, 13 Apr 2026 05:15:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 636976B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:15:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 20DBA1A0D44
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:15:54 +0000 (UTC)
X-FDA: 84652975428.13.CDFCC8B
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id 36E66120007
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:15:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oY+vEH1n;
	spf=pass (imf29.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776071751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3hYK9Ei+d9kVH0VV/CR68CUDnV5UVCrS18XI/2Q3GjY=;
	b=moiA/zoyWObeNLGJCGjyscGYuoJFfLaQRSxzaBSocrEtwQuIvjZBgj0Wfewg5P/2oFvrjV
	71yY4nkSTY9Qg9bHhHcn1voW9/iw01wn22yTo0C1W7aUyb5wmM7HJurrnMi1keRWcdJBLi
	JWiMlo5MvyUjgg6oFA9XfiaR4j3TbuE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=oY+vEH1n;
	spf=pass (imf29.hostedemail.com: domain of ojaswin@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=ojaswin@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776071751; a=rsa-sha256;
	cv=none;
	b=ktq8xMwC1izOkY8Oi3vsuix4Q7h6NFqTAT5I4nxAK+x/4DZK0j2mKb4MsdaEQoneFjOYCj
	uxEf5ioNkzLT6wOiPq4QcgPUHHuJAAhwQR1KZRi6oSae+M6uuTz+ANxLUYXuJ+6zQiXSm+
	lUNujOHRDOBgG8A71cb/MC6wUgkgI/8=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63CNQ6Rp3649347;
	Mon, 13 Apr 2026 09:15:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=3hYK9Ei+d9kVH0VV/CR68CUDnV5UVC
	rS18XI/2Q3GjY=; b=oY+vEH1nHYm21zR7dKdG+rMVbiAs+2M4pSYJYH25H3Q/WQ
	S5pbibNxKHXRtCU5RA4BZpoAC/CsLV14kYSk9HD7BI83gpVLqIVXm+N3/UD3mtFb
	VGL3bfwkoS+MFSXp/7ksAXz/d/43BdzYyNe+WU94qMB7+oTAY5jMdy/aC1rg5QU1
	UhBzNrX2r1ZHEsamBr6j/bYRaaLxasa1WWuLDHkVDfa2K6RkMY6wizvw26f4v3Pw
	kdUQa11kKa0O4lHqHX35TBGaxo9cfSk8h/UtwhMbDVaUgMt8SMltIpECwIrRGVKB
	KeirN6PqfMTEor0kXcjWPcrhlHvR883P23ApPmxw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dfdt3px1j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 09:15:17 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63D80WMC015153;
	Mon, 13 Apr 2026 09:15:16 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dg0mscku7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 13 Apr 2026 09:15:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63D9FEC727328866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 Apr 2026 09:15:14 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 70F6620043;
	Mon, 13 Apr 2026 09:15:14 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B712A2004F;
	Mon, 13 Apr 2026 09:15:04 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.123.13.2])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 13 Apr 2026 09:15:04 +0000 (GMT)
Date: Mon, 13 Apr 2026 14:45:02 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Thomas Gleixner <tglx@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        x86@kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux.dev, Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
        Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
        David Woodhouse <dwmw2@infradead.org>,
        Bernie Thompson <bernie@plugable.com>, linux-fbdev@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Uladzislau Rezki <urezki@gmail.com>, Marco Elver <elver@google.com>,
        Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
        Andrey Ryabinin <ryabinin.a.a@gmail.com>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>, linux-hams@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        linux-alpha@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-m68k@lists.linux-m68k.org, Dinh Nguyen <dinguyen@kernel.org>,
        Jonas Bonn <jonas@southpole.se>, linux-openrisc@vger.kernel.org,
        Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        Paul Walmsley <pjw@kernel.org>, linux-riscv@lists.infradead.org,
        Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [patch 07/38] treewide: Consolidate cycles_t
Message-ID: <ady0Ft_tDrbGlu2o@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <20260410120044.031381086@kernel.org>
 <20260410120318.045532623@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410120318.045532623@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: r6KN03kK1HZaoam71kVl5aHZm9BfgAQ4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDEzMDA4NSBTYWx0ZWRfX+Gwbo0yddZP/
 ED3CWrVQNFFw/TECS1M9+tSS57FYBZnMmG79KmJVnAwBWc3o5BgyeadFZ9maSHI4Tv+/+VHQiXF
 uu6/EAbMsVnRYIXugjj6TyQBBqRyeSoPbLxIVX8tqr0goumkz0lPJ9Y4Y3a3ECfM9WbzUtOSm5u
 eNbyrRMw+nuwi0Afz/QuxwA0FuazktkFPrSziYKfNEV92tR6ksCbhLbdKwZfOQ6IaUNAK3mHh04
 Z9ZuJvFG4+5R/DIJQ8v5H1fE5bYExgqIL1hC1HoekBef4/UHL3Jav5jU5Ty8ib2gAESLlopFcCb
 VttV6mxWXomhvrcFDBgGSdweqIiLio3UyKWRaxfdCdf1K3UdP0nDdx3LiWp/XKSUCxaso/02xav
 PADy/jEsrag0vsgcCLG1/jcBcJ3bFL3cNcYlDCC6JXFySGCPKTcpDMOtfvLh9vv4Vg7VR02ItSs
 a0USozVz3do3GTBrHkA==
X-Proofpoint-GUID: iwEVNX-0n_YmGG6iAARt9TRRoEhRuwqE
X-Authority-Analysis: v=2.4 cv=WpEb99fv c=1 sm=1 tr=0 ts=69dcb426 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=9Pz4rRoAHiK5H5RfW9YA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-13_02,2026-04-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 malwarescore=0 clxscore=1011 lowpriorityscore=0 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604010000
 definitions=main-2604130085
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36E66120007
X-Stat-Signature: fcf87d3tr3xuuddunxzbk19nmmakboip
X-Rspam-User: 
X-HE-Tag: 1776071751-3274
X-HE-Meta: U2FsdGVkX18JpiKC2EuO6iKVb7VaYn5xpJfPths6WPxfyI09FCBjdA3uyW6upgx5SvoR1GNgM0Sf8nlWxI4JJKm0Dkf6rDadz+cs9cVKoQCDiY9s8dBEjwxF25oaL7I23uqemgPC2hZtBR/PS52L1nZPyujC2K/0d90OhEYzPidbGk17bCmgmUhPDIWi5EBym8Xz/gaZPb2w+YUM/yOKtNhcR5tNv63g7e+plBd5Izx9o70bE4Mp03i80da/Tvu1nWQuiIqJO3lp+vQ1woKDykXaPnP5JkHhBqyoQzwf92LU/3vJRKIso6VAhUulY7l21l9KWGY57LynMEL6e8SDj9W5rxxdNBX0OlfE7Eaqdf/xBZq50x+Sy21j34zK1Mh9seOMf+xf4kNtAlC1xjsYEt7aufdMQeVqRS/lXv7fDohKAhfGhT4kB650AM+noCeZw9DHLfK9tlE0EfWGnQsxDVCijKrGLdqd3Eeym1VaGjlKGpGQJztOLWVyN7I462OGGYLi81KBnOnfhBB4wPLJkxFw9J1ScNN4djeFECzHcWMWN+wu2LQmRH2noB9SYHo3dQd0Ea0GEcqp6UQBOgYC7Tw89L0d5KU7dqoML8fvMyZdFj5+72p6ZpzgdW9S8+rj3fh909PcY40WaYsR6CBVXPHBNFfCPFhEQdYUBOrhEBz1+TowoR0LjNiNXJ8oa4Ia0DJmvfgySizlA48c8R9f/qX7qRcn6KOegexbEYNp49j//FHfJYEMoDHVQyRQz7FiXyftr/H69MF3LVSMGN3q34LjT11EOi5r90awqAq5XMqSqafVZ+IXTOm2nTzZegJu52/cA49RJu1vwV4pT/a3o9klsyLF+hqTjCPqvldHD7m5yiu4gF3D8cw8ONKsZGhBlNO1I4x6/CgXHflcCDCjg+qyI4U3RsAjEY2jGO340yP60AqlIl+PH8a4hCzCtMlI2oWzIXSaTcnyWzxKiHR
 ARyl/To/
 TSEfyPfZyICpLBLT28gAMfeoDUo2tEWbVzlaCoGihrbpXk+W9pdf7OngXF68nc57p9JfR2OKtthbJmflf4HsCtqtoHNyLfcL647tQywu4tskaGNiyNT/2eutN1QdA2LfQb7kmI5G8v071f0Ji0lQT4JKJRewTvO/QgpgcFQnkN2QK7bLXVKZMkjwF1SeCifO9WET5Nlir0zGFyAPENaLNzcgdKf1SfqfcW9I4GhH++g1l8rbKfATLSHmT18gUj2o3EG0+daI0nqitlRO2RnEYxZDg2YeqoCiFpf3XI/XBZR2t3rmrrSwR6WF0VVGmmJUCFd39MIQBF/4VyyiZPxTk2BE4kZlWisAHwYOoWmj0tRzxpJ+pl2UCfAgd10/6b65vZN6LNh6M075ik1Km1Y24MLAfxFiFDdmJSNk2LuicyXSzI9oj3IBb5uvtqIA+58etzirdNhPLIfe2i+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 02:19:03PM +0200, Thomas Gleixner wrote:
> Most architectures define cycles_t as unsigned long execpt:
> 
>  - x86 requires it to be 64-bit independent of the 32-bit/64-bit build.
> 
>  - parisc and mips define it as unsigned int
> 
>    parisc has no real reason to do so as there are only a few usage sites
>    which either expand it to a 64-bit value or utilize only the lower
>    32bits.
> 
>    mips has no real requirement either.
> 
> Move the typedef to types.h and provide a config switch to enforce the
> 64-bit type for x86.
> 
> Signed-off-by: Thomas Gleixner <tglx@kernel.org>
> ---
>  arch/Kconfig                       |    4 ++++
>  arch/alpha/include/asm/timex.h     |    3 ---
>  arch/arm/include/asm/timex.h       |    1 -
>  arch/loongarch/include/asm/timex.h |    2 --
>  arch/m68k/include/asm/timex.h      |    2 --
>  arch/mips/include/asm/timex.h      |    2 --
>  arch/nios2/include/asm/timex.h     |    2 --
>  arch/parisc/include/asm/timex.h    |    2 --
>  arch/powerpc/include/asm/timex.h   |    4 +---
>  arch/riscv/include/asm/timex.h     |    2 --
>  arch/s390/include/asm/timex.h      |    2 --
>  arch/sparc/include/asm/timex_64.h  |    1 -
>  arch/x86/Kconfig                   |    1 +
>  arch/x86/include/asm/tsc.h         |    2 --
>  include/asm-generic/timex.h        |    1 -
>  include/linux/types.h              |    6 ++++++
>  16 files changed, 12 insertions(+), 25 deletions(-)
> 
<...>

> --- a/arch/powerpc/include/asm/timex.h
> +++ b/arch/powerpc/include/asm/timex.h
> @@ -11,9 +11,7 @@
>  #include <asm/cputable.h>
>  #include <asm/vdso/timebase.h>
>  
> -typedef unsigned long cycles_t;
> -
> -static inline cycles_t get_cycles(void)
> +ostatic inline cycles_t get_cycles(void)

Hi Thomas, I'm in middle of testing this series on powerpc. In the meantime I
noticed that there's probably a small typo here (althrough this is fixed
later)

Regards,
ojaswin
>  {
>  	return mftb();
>  }

