Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01498F433E6
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 05:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291E26B0005; Thu, 16 Apr 2026 01:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2426B6B0089; Thu, 16 Apr 2026 01:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1311C6B008A; Thu, 16 Apr 2026 01:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 05DB36B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 01:41:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB714140734
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:40:59 +0000 (UTC)
X-FDA: 84663320238.16.B292AA3
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf07.hostedemail.com (Postfix) with ESMTP id 50BC340007
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:40:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tD3THvqh;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776318057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D6k+eOmawKf0S3bAh+pGR4TUjM1VcDanzk69tnu6AhQ=;
	b=eEbnH6rmotEZorbefJEEi6a1K4ECQJDM0Z47O2O/Kwu2MEtu8k7fZ65OSPryThQcfiQ0L/
	5yqKOzxzdaiQ67S7vB7TRwG35Ry9PCZhtaCPo3F/ztA2HKZvdTC3UmIXhTVNcNQZVf9K+/
	xIuh8DWEyhi1+r489/pJi1E/ruFb2i4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=tD3THvqh;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf07.hostedemail.com: domain of hca@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=hca@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776318057; a=rsa-sha256;
	cv=none;
	b=5LDwAhhhmpFgDvCFc0zsthn7TiePCJ3U/fCKQ/PQI/09FUCP3FdVatQDiN6dGamBHeSJhf
	avT1SpKXIg598uxzkEnySeHHjyk3Ux0A3h6VF401Sh2bEeVoXa4PGUlZZLUZlunW19xV8F
	L20h0//elQfTt9JORXJoYG8+oK1r81M=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63FG8PSR1833234;
	Thu, 16 Apr 2026 05:40:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=D6k+eOmawKf0S3bAh+pGR4TUjM1VcD
	anzk69tnu6AhQ=; b=tD3THvqhELKwhvKybuzzOXYaTe3eUpFTcDW/yT5Jq3I2CI
	L49M+UCZeGtl+uX2PJXzXBIlEPs5MlYxB95jcSjgTjGN3tY6iILcNg+MDdBZACK4
	2r9wXxTP4AjyD6jGaDavmLq+J51PlRA+Z83LjIQeUiQWl0wwGIYBhykGKbY9VBgP
	ZwIChurt3LLKeKfsw+Mqqgk9lnFrVEAjU/dVqZtBvRPzqVZgkQYv6GncXuNgt1st
	nyjO9mjxyckhsrOHYZr4cSXLLhsWHjoUHh9dB/pDBoMxrEobzyJ0CscdhmIkU9uZ
	apx8DgvQFFtbemBc6OmqAohwSF8uTDXP/o5C3CXw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dh89rku53-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 05:40:53 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 63G1TnmD003610;
	Thu, 16 Apr 2026 05:40:52 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dg1mnhgn6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 16 Apr 2026 05:40:52 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 63G5embZ58130730
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Apr 2026 05:40:48 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 407A020040;
	Thu, 16 Apr 2026 05:40:48 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0CDE520043;
	Thu, 16 Apr 2026 05:40:48 +0000 (GMT)
Received: from osiris (unknown [9.52.214.206])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 16 Apr 2026 05:40:47 +0000 (GMT)
Date: Thu, 16 Apr 2026 07:40:45 +0200
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Kevin Brodsky <kevin.brodsky@arm.com>,
        David Hildenbrand <david@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] s390/mm: Batch PTE updates in lazy MMU mode
Message-ID: <20260416054045.10407A20-hca@linux.ibm.com>
References: <cover.1776264097.git.agordeev@linux.ibm.com>
 <924c91e711e8b16470eb2af7e31d0b6ffcf2940c.1776264097.git.agordeev@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924c91e711e8b16470eb2af7e31d0b6ffcf2940c.1776264097.git.agordeev@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE2MDA0OCBTYWx0ZWRfX12RE5HsXdsjt
 UXEXMbXdC/akNcokxSzoE+3CiWjt0BgHqIeiAxc7gXjFdI1T6pC6DSWPyHcV49FJUtVdcEc5OsC
 WhBCJ6QHHaZrDgnIsmnQ+6URT80ZW/wFjKRdwq6/2oEKRhsrKK2S7aQ0yPw7+Yo7EoGLVeztehb
 Ap0seC/Q+IrDGsczw0IAukVScxQyBxZqZ18cu1SZbRfOLzXh10IEnq6fnwzmR5G4+oI5ViWfj37
 aB2T7+muApMhDdJr5f5PMxFq8h2Kzn3vT60FgjnoWBd+klWeNszkJxxq5YKbGkvtsmirSno0Bvj
 BCPyK2QJmSBFcXb2YFpE2X70dkXaWKFVId7JhPk1/C/3JCYCi42qzLlyK0lPJWkFE+RqBCjczmf
 XI01NWfwkFqw+HxERtwJ4b6y7U9RaVUpncJppWIxFw26nf6snmEn/U3XOTq1BzK1BsMXo8Tnp0a
 db8E+rpHQ/QVEPwkYMg==
X-Proofpoint-ORIG-GUID: 9ofSS6RPIkZFeRdb9lqffwjtnk2ZduVR
X-Proofpoint-GUID: 9ofSS6RPIkZFeRdb9lqffwjtnk2ZduVR
X-Authority-Analysis: v=2.4 cv=fYidDUQF c=1 sm=1 tr=0 ts=69e07665 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=lj8NcCMTIohhnMXQ0FkA:9
 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-16_01,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 clxscore=1015 malwarescore=0 phishscore=0
 bulkscore=0 priorityscore=1501 spamscore=0 suspectscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604160048
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 50BC340007
X-Stat-Signature: jfucey4stmkyh9as1wticdofu6nfzrng
X-Rspam-User: 
X-HE-Tag: 1776318057-812676
X-HE-Meta: U2FsdGVkX18qrHp9UtQrqVwlHIXON03CN5YruowWvXS74iAQZWz24Hn33N6G9aaRXit1mguxQyRqLNwFhPH3am+QMt6efWP91L26vEz0M1PbWYmN643xMLL4Te2JPIJ8UXnj9fPP9nYfYB6J8AZSoAgO1hVjag198X756kwCOIilLObQeYJEAZLLR9wdZt3/qr9pTlxxzpoeFYAm0nQ1HBVMWySgsmDrqnmAr+5PzJlb2GveWRbElYHDwmeUuFH5dlnuma6z4SkWi6sWzr8QgS+GZWxu98NMHsXxqfHWwsdkb32zSvXD29FBA0zCzj6RHEHEudhvMOHGCWOYhs8BJldDLx6ngBdKTHxeRfFTGRhD6s7diqSmduvMbiImSI6gjCyLbM9eFWxrz6R2DEDN5vzlqB8N7vg6W6TlbJh/4H/Z2vGHAeO82RuAL3meu+4UlaQkH9DfhJxzynV3jlabBVJCEcCpkFNj0sc16ka86jSfRS6xKv7/qniqnB0QdNdcZnvfX31fXIjk2imLsfenWKh9rGEmLEHcmTlxWyI9IXKtSSHNrZxGl2hFtO8TqnTcQN4VWjtTVRxw4rfQp7tzMGI1E1hieEXeLjQrKky+mdIDQdj5/6En8bmg5pjMy/Q+fZITtr16hP3i5jplDGDDTbmAWXw0OgO1U6WfA2ZGvTisG1qr7G/EDCi+SF3lTarpnL5+GqlVAeDrIk4iy1D71ybDMFHze66Myq2U1SUhGYf6IeIwsgsKtScAYE21b820UHTkcim+p3cxzUFW9+e3ROhq9OcSBJpBwn0bmID3l13yndqH55q7Zgl5ilWW0ra4wM2LuC6C6P6As8xEETvt+XA6op9KHP2hKXPyIWSHL/E1bArlj9905/mOIxw3I5pwHoIkkp5aDfFnhqo7dam+uvM6RMtr/eSoTEVxO3VXOCHALkIM/GCLj+IM/wWqsm4qYoWJmEcW9blVWa8iEiX
 99eyE9PD
 zXew4w+Lr09XVedeQs7lvfjcElUoz0qezW7iOVJ9V2Rzbj+bESfTjMK2CQT5jDT3+C7ZCuRXmiBprIDZO7Nk0KAW8YiqS1cIzrCvtflmHN0MxF/veljh1YvVFZeFYYgHpskcRogsC+kPeoIb7JQudwnmSxpgZaBLCI/67mCcqLlhxqpt7YbnHvG8YNEBTHYdp8quFu9S2dxgaWFTzPuFcLLAFKhSL7BwKofyl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 05:01:23PM +0200, Alexander Gordeev wrote:
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index 7828fbe0fc42..deffc819268e 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -732,6 +732,17 @@ config MAX_PHYSMEM_BITS
>  	  Increasing the number of bits also increases the kernel image size.
>  	  By default 46 bits (64TB) are supported.
>  
> +config IPTE_BATCH
> +	def_bool y
> +	prompt "Enables Additional Entries for IPTE instruction"
> +	select ARCH_HAS_LAZY_MMU_MODE
> +	help
> +	  This option enables using of "Additional Entries" field of the IPTE
> +	  instruction, which capitalizes on the lazy MMU mode infrastructure.
> +	  As result, multiple PTEs are invalidated in one go. That improves
> +	  performance of many memory-management system calls (like mremap(),
> +	  mprotect(), etc.) and decreases CEC-wide quiesce traffic.
> +
>  endmenu

Just some general comments before I find time to look deeper into this
series: please let us not add yet another config option. This will be
enabled anywhere in any case.

Not having this option makes maintenance easier.

> +#if !defined(CONFIG_IPTE_BATCH) || defined(__DECOMPRESSOR)
> +static inline
> +bool ipte_batch_ptep_test_and_clear_young(struct vm_area_struct *vma,
> +					  unsigned long addr, pte_t *ptep,
> +					  int *res)
> +{
> +	return false;
> +}

Why does this depend on __DECOMPRESSOR? Which code in the decompressor
would generate a call to the ipte_batch functions?

