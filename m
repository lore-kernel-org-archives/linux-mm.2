Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A13C5AD7B
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3739A6B007B; Tue, 11 Aug 2026 00:23:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A5F6B008A; Tue, 11 Aug 2026 00:23:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2611E6B009E; Tue, 11 Aug 2026 00:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EEC126B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:23:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 774B2140314
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:23:17 +0000 (UTC)
X-FDA: 85087694034.18.0CEAC7F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2A36720003
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:23:14 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fCDPROh5;
	spf=pass (imf31.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786422195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VOaIwkaxwacg2X/k6KlkBM/881r7wvgZqaaDMVUJj+g=;
	b=ohJvCO6eBCfx9p5C3sHQDAP9FTxLMmRlQZKCyosApeFu6tq/HT+hds0rODkwbTMuLb9jsu
	neM8PCzJrtvaA3yIVwKOkLOZaeuv3dMCGQ3dCncMXFddVbHumInBPIQetD00Un9Vhisz3V
	lwzk7dYd28otKIzmYXOD56y2l0UhNQo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786422195;
	b=o2OlJkMBPtiWvJitNU+QNR7Yb2NeQZPCht1gDNHgiICfBCLG5xahbLGwhOgYv0tqLQO+Rf
	KUTXQV/JBO9UQOnh0GFA2o2Ar1+i9gMiPW1iA1p4I8XNJALAjHweQddQcSEljJ/0LxIGJJ
	6pBPPLV4+aPQY2Uo9uA7ajr8ECpTqE0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=fCDPROh5;
	spf=pass (imf31.hostedemail.com: domain of venkat88@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=venkat88@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67B0MIcQ3036438;
	Tue, 11 Aug 2026 04:23:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VOaIwk
	axwacg2X/k6KlkBM/881r7wvgZqaaDMVUJj+g=; b=fCDPROh5B9BiwwzwUxlZ0p
	/XTRKPOkFQXGiCMYvYd8W6Q3IAsHEpNI42EVnU7TSGzL34MtxKgyBabcic8bWgVw
	RExJ4VkSYtlCqQKH44GWcFOPmSSsl6C2cBxvKnd8jCDCduk7ayANww0SeL4xnvlp
	x8ebbPxyy+0IE31/gCcDotPu+r/nwsB7gUXrDOGjPgsWl7+0FZKQ5/3faMI7Cz+9
	TXWpEKv6yOfNy4gN6GlmO530JNW0rrJjkh3TOlRts9Fq81ezn5ZdqVOEPEgDDHnu
	8L06fpA6Up/xxwzXzbDosm7u4zme7l3jZ4U307USG3BfY26e1SmosMzB756hVSTQ
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvp2tpdv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 04:23:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67B4BIPv018940;
	Tue, 11 Aug 2026 04:23:09 GMT
Received: from smtprelay01.wdc07v.mail.ibm.com ([172.16.1.68])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fxfsjqhhj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 11 Aug 2026 04:23:09 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay01.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67B4N7sT6161202
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Aug 2026 04:23:07 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4C28258052;
	Tue, 11 Aug 2026 04:23:07 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6B6E5805E;
	Tue, 11 Aug 2026 04:23:04 +0000 (GMT)
Received: from [9.123.12.38] (unknown [9.123.12.38])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 11 Aug 2026 04:23:04 +0000 (GMT)
Message-ID: <627c5c2f-a0b3-4fba-811f-7b4ed4c74dbb@linux.ibm.com>
Date: Tue, 11 Aug 2026 09:53:03 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG] powerpc: userspace processes crash in ld64.so.2 when
 running recent linux-next kernels
Content-Language: en-GB
From: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Ritesh Harjani <riteshh@linux.ibm.com>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, ajd@linux.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>,
        Christian Brauner <brauner@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <75419f88-eab9-444b-bf97-28a9765819ad@linux.ibm.com>
In-Reply-To: <75419f88-eab9-444b-bf97-28a9765819ad@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=AMtp2X5w c=1 sm=1 tr=0 ts=6a7aa3ae cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8
 a=ooee5C11TIdXIoiR4BMA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: uvObd9Lph9ADs967J5aV-AEQPGlBVQsC
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODExMDAzMSBTYWx0ZWRfX83+QPcr4DCYE
 xhbWKYnXXJMFoM06mzEMr0C898pl/ceQ3DJHleVEjAhEEvFd90FSHys7A26NJ352l+ijg7CNbXH
 3DgOxdMdRFT8RsxXj8GDBMqRFIh9a9J6KTI22JenN1NXWTOmuAxN5l5VKWpj+/mdOu9zXZ7FQVc
 j2qd6a94TJlu6qQ8TUobzNIL0aakXdyzci1fsqe8b6xq3jAvacSX0a1PKFbUuDwFq0nzS3gUgCl
 qDZGoNqWAmRsbCg+YEE+F7iz5Mme50gTzEdMglNsoWxKBmF/rm8rgNipE/8QHD9QPKw/3BTBRlo
 DeT84C5qwzRi7z0/I6dXHiKONxS40e21/eDh/VjA/+n3h6B1bhsKTiY3erYrFA61tPBQPSRwZqv
 EvrhmNngw4LizQIAAIlrHtfwnYODbiwQfwDR95bk+/mhvUIlB7sgFWavkkTcUKbqoVutRNobmU8
 jTC+d/qDf4A6CIwABnQ==
X-Proofpoint-ORIG-GUID: uvObd9Lph9ADs967J5aV-AEQPGlBVQsC
X-Proofpoint-Spam-Info: AW1haW4tMjYwODExMDAzMSBTYWx0ZWRfX5daGqX6rmPcc
 qBbRqET6shuhCv9WJzs0iMIq/99HPqyhFQPwuRtST2c0ymPHi0aXxJj543wqgZigwkDy0fEB8GG
 SToF+Rap9D2+l6W6rhi6uy6sPjB7EyQ=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-10_06,2026-08-10_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 adultscore=0 lowpriorityscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 phishscore=0 spamscore=0 bulkscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608110031
X-Rspamd-Queue-Id: 2A36720003
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ybeoiuuoc37xfakabobh9hj9gspdieu5
X-HE-Tag: 1786422194-702269
X-HE-Meta: U2FsdGVkX1+mfgNSn8Oh+5Yx4GJMLTRLRG4YdfLi2e2+lgX+udFKwjqmiYWIXQ4zIR/j/Kf1/qFHwsB8RMV1qDaNfT9vTIJq8kmvyy5gAaaXRFZJmy0tV5JRZVHMb+MwWByM9wyyTmtXw0QElvQW57WKE9GApLMFXj+iryw2DZzVBZeRbYLzT811lrKnUq6htM22W2qhy61fByaceZ6bgYK2xQB+PZPMHSPlSSX8QXgGE4uf8k82/Nu7GQLnz9aImgEKkPe+sRjWoMo/NOErnuPeNgxTnSLMD4B6hCM9nYB7co1xM8IfPVARdcvq4vhCQkXwG5Dpzztrd+sTJ0F97XWx3GYchG14pAFumKcgCJgAqK8vnnRGJJclX8rwO7WS9Nv6HEckwoPI+vpPL9fEvYSjZgfm266nrgLfRx/qw9XgKhUkzYvVXmv/qDYcW5U2qpnr2L8I/9GBWA10Qlmf+WJY2HUmcBLwyWNsIvJ4nk4CniknhOXM/E5QX49zS8ffWmSdijoc3OB8MEtj+iQPUrEZ6jPtzrCD/f/eaVj44wLsfZopNhImudHgPoJE4zpVeM5qHDPp6AZJUq20yeJFntjpYx2idrITBSVU92KrNWgIIM3XxP4gPaEFaQbYkhbcCMHMBSP6QDawd45aTrFx9eQeCq9/k0h7mFf84DqPa2+vyyJZuyWtWf8wtGwFlYIK1yhbV8nsZsZW6w8lZ6RkU8nahkaqyl5LcoBhLsgmMrWqv7wA0ufeuwhRRP+hQvqRpM4+BzcHwTAb79B6ukm0UMV4KVzi5Vn/UVQK5vO9/1QUlRnmrK+/Lo1i+XqGV5Okavm9oF2JMOYFJ1KMtgOAU813lKAh7Id4KpnoKpGL3HMT+cBGZvKTSZBQnY22L8krHzLKu+orYy+z1ge9lCkEJV6xW5NJC7fcGhNl4bWbzds6v5H6v3HdYQ3Yus5MF3KtdTvSNE9cf7pivtxcq4S
 keO/Zcir
 J8LNaDQDKJAEBB1BxWpZ7St1fVh/mqriGBQR/VCja0hgCdIX7NblQxISeY8qq3/qJW8vqkSVzKJ/jGBLrp6pyE7QaNOnf6Ebaqvd5rPQoIdEDu6p3cCRkU4WJ9SUy0Pr/VYIkBzwJnKRdJWxT8rRioIRBwbJcowzWVLgt40yf4tl1elKr1GY6vOB+ySkyVregT13Fkvkx0jtz2vQU8/6D6Npl0LuSyy9Mhrk8QJeu/mODvI8QCMfOB0B8/cVdNjxTfQ/o7YsmDOO85xsADpBpTyfkqVbHNJZdc2HgfKJKt2Xi4ampWgNIvJB01ITqqGslH/Ou
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 03/08/26 6:40 pm, Venkat Rao Bagalkote wrote:
> Hi,
>
> We are seeing random userspace crashes while building the kernel on
> ppc64le when running recent upstream/mainline or linux-next kernels.
>
> The failures occur in different userspace programs, but the crash
> signature is consistently inside ld64.so.2.
>
> Environment
> -----------
>
> Architecture:
>   ppc64le
>
> Platform:
>   IBM Power systems (LPAR)
>
> Userspace:
>   RHEL userspace
>
> Workload:
>   Kernel build
>
>     make -j32 -s && make modules_install && make install
>
>
> gcc version 14.3.1 20251022 (Red Hat 14.3.1-4) (GCC)
>
> GNU ld version 2.41-63.el10
> ldd (GNU libc) 2.39
>
>
>
>
> Observation
> -----------
>
> The issue is observed when the system is booted with recent upstream
> kernels.
>
> The same LPAR, userspace, toolchain, and source tree are able to build
> successfully when booted with the base OS kernel.
>
> Typical failures include:
>
>   sh
>   fixdep
>   make
>
> The source file being compiled when the failure occurs varies from run
> to run.
>
> Examples
> --------
>
> Example 1:
>
> [ 1277.872746] fixdepsegfault (11) at 29ac0
> [ 1277.872746] fixdep[122982]: nip 3fffbebd8214 lr 3fffbebd7358
> [ 1277.872746] fixdep[122982]: code 1 in ld64.sofffbeba1000+50000]
>
> [ 1277.872793] fixdepcode:
> f90104a8 7ce903a6 f9410060 f9490008
> f9490010 f9490018 39290020 f9490000
>
> [ 1277.872805] fixdep[122982[37214,3fffbeba1000+50000 f9490018 
> <ea628000> 7e731050 f9410030 fa610020
>
> cripts/Makefile.build:289:
> drivers/gpu/drm/amd/amdgpu/../pm/powerplay/smumgr/vegam_smumgr.o]
> Error 139
>
> Example 2:
>
> [Sun Aug 2 12:36:38 2026] sh[115552]: segfaultbcd0
> nip 3fffbd73d004 lr 3fffbd73c148 code 1 in
> ld64.so.2[35004,3fffbd708000+4d000]
>
> Example 3:
>
> [Sun Aug 2 12:40:08 2026] fixdep[134469]: segfault (11) at 
> 2bcd0c3ca004 lr 3fff8c3c9148 code 1 in
> ld64.so.2[35004,3fff8c395000+4d000]
>
> Example 4:
>
> [Mon Aug 3 05:44:20 2026] make[600291]: segfault (11) ip 3fffaf3b5004 
> lr 3fffaf3b4148 code 1 in
> ld64.so.2[35004,3fffaf380000+4d000]
>
> Notes
> -----
>
> - The crashing executable varies (sh, fixdep, make, etc.).
> - The object file being compiled also varies.
> - The crash always appears to occur in ld64.so.2.
> - The issue has been observed on more than one system.
> - A fresh OS installation with ample free memory reproduces the issue.
>
> Let me know, if any more info is needed.
>
> If you happen to fix this issue, please add below tag.
>
> Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
>
>
>

As part of debugging and suggested by Maddy, I reverted the following 
commit:

   263e5159e00a ("powerpc: Fix exit_flags field placement in pt_regs for 
ptrace")

and rebuilt/booted linux-next with only that change reverted.

After booting the reverted kernel, I rebuilt the latest upstream kernel
using the same userspace and toolchain. The build completed
successfully and I did not observe any of the ld64.so.2 userspace
segfaults that were previously seen during kernel compilation.

Kernel used for testing:

   7.2.0-rc5-next-20260731-00001-g79d9c1ce90a9

Top of tree:

   commit 79d9c1ce90a9873422ca4d6d0124a1d1c10a098c
   Revert "powerpc: Fix exit_flags field placement in pt_regs for ptrace"

The upstream kernel build completed successfully:

   INSTALL /lib/modules/7.2.0-rc7/kernel/net/openvswitch/vport-gre.ko
   DEPMOD  /lib/modules/7.2.0-rc7
   INSTALL /boot

Based on this testing, reverting commit 263e5159e00a appears to
eliminate the random userspace crashes observed during kernel builds,
suggesting that the issue may be related to that change.

>
>
> Thanks,
> Venkat.

