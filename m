Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7E20C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 18:05:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C1026B018D; Tue, 18 Aug 2026 14:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 898586B018E; Tue, 18 Aug 2026 14:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AD636B018F; Tue, 18 Aug 2026 14:05:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3AA6B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 14:05:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E673DA27D2
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:05:40 +0000 (UTC)
X-FDA: 85115168040.29.A998873
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7519040008
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 18:05:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kj2cl3WL;
	spf=pass (imf17.hostedemail.com: domain of iii@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=iii@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787076338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9+4u+bZZRZ+PeqvvOuqGx/3fkOYGzNVHoOh4cOl5rwU=;
	b=grcH9YJW39c+hadpp/CQbU9ffTC1MQaYz1/TzgT9YIxbdtQYJ/kmvPvuW5pIHC4DBImA5G
	5waZh7Alnh5Ek8tHOx3aVQZuM0RgJWKIqQ+frLRu6uTy6p2JYhKV9BbD1oHUNWkkbm2JE7
	qq5y1smTEhAyXeva4Bzr+RT66yFTKJ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787076338;
	b=pEsob3zy2LF0298gKbNcAnTb9eAiLc9JcD3M81Yv0kqZxDpVqOlFHKEoGYhmZlw13GkGAV
	LNhwHRIHrbH4spfkhi2saI8bz7Lo2BefikxGmcuP+Ymmw3ya1LGHB4ZfojlGiY/b+wzYFn
	75fO0rdugZme/0WC4JRQAsinBMP/XP8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kj2cl3WL;
	spf=pass (imf17.hostedemail.com: domain of iii@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=iii@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67IHVaBO4056033;
	Tue, 18 Aug 2026 18:05:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=9+4u+b
	ZZRZ+PeqvvOuqGx/3fkOYGzNVHoOh4cOl5rwU=; b=kj2cl3WLElWZQki5NrZjuL
	Z4hhgRJVuNoXlt5F4QyKqwnzsdlWsVRkTu1kmz4QStbDD1u1m5jjSfbuJD3QH80Y
	smBkVPG0GAiT3flvAYQYSJv9Rl+HJfCOX2l25UJJds6/bew3Qw2EkBWM0KcfYesc
	iRrTLfxpmt/RnS4pWjA3TpHe6JGDawYKb6NL5OhB0MXv4MW7qYQXBZd/NMov1CJi
	4oNeGYZdEtFz0gaUh7PYxVYykbCalfX/t/Jy59aebDfRlcCC7LRT1fVr53gV73yv
	9CaA5aYeQ8t00lGmBNBX9kSvgyq6pRpQfDZPIm65e7/ohspPenX3a00JmjnxbBgQ
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2ehe9k94-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 18:05:18 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67IHuJe9000966;
	Tue, 18 Aug 2026 18:05:18 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4g32eq4u0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 18 Aug 2026 18:05:17 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67II5GAh38207760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Aug 2026 18:05:16 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1713F2004E;
	Tue, 18 Aug 2026 18:05:16 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF8E22004F;
	Tue, 18 Aug 2026 18:05:14 +0000 (GMT)
Received: from [0.0.0.0] (unknown [9.87.142.99])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 18 Aug 2026 18:05:14 +0000 (GMT)
Message-ID: <605d3468-4b2f-4bde-b5cb-07619462dd51@linux.ibm.com>
Date: Tue, 18 Aug 2026 20:05:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: fix objtool failure with KMSAN enabled
To: Dmitry Voytik <voytikd@gmail.com>,
        Alexander Potapenko
 <glider@google.com>,
        Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ankur Arora <ankur.a.arora@oracle.com>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
        Bill Wendling <morbo@google.com>,
        Justin Stitt <justinstitt@google.com>, Marco Elver <elver@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        kasan-dev@googlegroups.com, linux-mm@kvack.org, llvm@lists.linux.dev
References: <20260701125151.352632-1-voytikd@gmail.com>
Content-Language: en-US
From: Ilya Leoshkevich <iii@linux.ibm.com>
In-Reply-To: <20260701125151.352632-1-voytikd@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE4MDEzMyBTYWx0ZWRfXykfSQBA7Lksw
 W1dXri9x8UBF8W1c6VbZZlrXsRErJTWfLUbOX41paanvjh6j6ymjP4Dh4mafxLiOvxJXrBQDu0J
 Y3kLSLZN4F9X6zeuMRGKBMzfcfkZsjeiJT7Mg1mvrNmreNc4BMY3gG73ReSV243MT+GwKvZaonc
 wUBE5MqAxEeSE4ZpOHTVmLj+R1m+ZNZXJClb+qAbfyvTvNiNfUxeTBzNBGcRxmuMytAWGIMFDtH
 Uf29UesSk3Izv9VLmMyNmzHRw7gYAaq8XpwTIfjeRwRHoPwflOwMTMIXinuEuOvinJFp7bm5ImB
 CGbMb9E/+V/eeFnHidZ2loILu4d1gQ1UsroMd0ggsuHyZZ0JysSLsMPmYjqpbfjRndlk1Fz5TWk
 X/MfT5KOniGhAp6tEvvM5Xywzrjhdf/1SNIZsiC2GyiLAz5GVXRh24hN/mPAg1z/b26XtXmqV+g
 jNfGZ38mISJEPtqIZvg==
X-Authority-Analysis: v=2.4 cv=DY8nbPtW c=1 sm=1 tr=0 ts=6a849edf cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=fGO4tVQLAAAA:8 a=VnNF1IyMAAAA:8 a=IzFO8XHbKeul4SU-JC8A:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Rgl4_PeBW0ljUeOiw7MXuCe5_aW-h4AJ
X-Proofpoint-GUID: 7ss18Xr76sCLSOddYB1MDNBU4H7p8GEM
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE4MDEzMyBTYWx0ZWRfX8EIlgqIcWRdq
 4H/LwsfTGoLEQN3ZeKbxbkFSYWgLA+Gqt6/YU87myd5oX0+AL8FXpRbSsaF8sIMv1kOwO3BEr97
 rcEbvVyMqIFXltMzvCalMwNdHMnF0MM=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-18_03,2026-08-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1011 spamscore=0 malwarescore=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608180133
X-Rspam-User: 
X-Stat-Signature: dkkkrqhjf7nesg17iet65khx1u9fphgp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7519040008
X-HE-Tag: 1787076338-649345
X-HE-Meta: U2FsdGVkX18QUyDFSnUD6FwaTITX1VI4YGqiQlvIZMgDYpSrHdNEzO9liU52uuyn25Km9n5zqX2UXuy59TGRW33hRhsG0W92eTFUAq/odYmi9NiGJcq9WTwTl54hELROxadOqTzyzd2U4Z8Z5hg1iysFPVRmc5JTOqdpvhTjqwD9PPqcBHYGDxXqKRceMmExvXoXp9ChLBXr0ux5WLChvhjhW8ddDGGldCnrPZDsYEzWSqAtXLyOZTX2BiAT3W2TR6mEdDqNK+rw4JRcf/vR4ujYXwALbt2uBYyZGsP+eTJp8Yqi5UkwIYS7EptZsWTlkVQ/EyGiCd/L8kGn6bcRoNVt330g5mX7zAnSZ459f+I5/HPB9M+xU4aVzRLfJZ/NZPgyP5oy7lKgreIoypvVvdKIbbpnJpk6w3NUBNMRaZ8YBDOxkkotbGb84/CW8QBN8HCclR0LvA2LEncJ40yJnrVhdif7TXZu13EjBJCAb/oBxc1e2kyj/krJHVa9wGw2KCBYeulfXeYVIM5VARcWLPMxaIzLNKJnveiZon3CAkzI93W+DBveK9/PcirdzW/MvOgikFOdBqAuLiThOZ/0q6KESQbnW+pPUm49EYLrs9tAap4K15Z0I9hEx2KS+l1jbnRkMAJsucJr9AfcTb72MufniRQnUHjtfwdRTXtdxNxNb2A5rs/OSZvzkl4Yc+7rDGTDB+l654U23IvGWHaCpEYT9t3nVVk1IPTgFFaiG/VZ05cPhQNmzWCOY7hX63MPUV3JXd2BGEoUN4stiWWj2+2EjPiUhhqhW4NVmydokXbrcCgyeTlQ1YdV+7vI4BCaIaexPvegdWrz3u83LWxXwt5mzfjKkohHYxAYNHuVP1TxvrmE5fLuSdhtLTo6Ot7dvEag7r6q+FY/Gbp0xwvFm5GjiQnZwLPbFNCkbrH1HK1JUxoJ8nTZq1SSDtTplQBDVKOAnmXmrGwvvcXWSez
 zCt1QWT9
 KEpb7O1UZuhO3tPy6zYPBpMGYiUFR9ccln3TU/xM6L38z24Pg4+gU55MZLZ2g1bSwLQR7F8NKNBZ0WVvCofyIs/hWuESPkTskeN5GmmSci+EpCnEEX4zviqQOQjl12uIJ8SdMlKP3JlRV/fo3wQT1EW69oFhe4snNv6wNmJFrKTsVYUCSdlrJ8t0ZUbBuxXwe/B5LPFx51kenCGVU1RDvO+34IbWU2HbgDWJikeEOILcQS8f1jxDodsnqFoXP26Dy/QPDMJQERDbEB2CZU8cf9iNMjOy9EMA1F3HYDep1n8Yuyu9QUPJaQEeY/W3dpxBdqfw1ooVNv1hruLzGMW8AGpqrKx1ixoSfvMc0o5JzZDKn36ejqnuxifhoMoj2qgTsagZQneWcL/5R7+N5/Sv4Agszf+89vD545vwfyP2hfW1WkSp0hxO3F7enC97pksO/5oCCXwB7+VpVKWAnh++fgcvEhUkLofeX/O2A5CfUmfymyKjwN3UAbiPkVMlH+I6tYICwZU8hoA7UQ2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/1/26 14:51, Dmitry Voytik wrote:
> This patch fixes broken builds with defconfig + CONFIG_KMSAN +
> CONFIG_DEBUG_INFO_*.
> 
> To reproduce the issue before the fix:
>    make mrproper
>    make LLVM=1 defconfig
>    ./scripts/config -e CONFIG_KMSAN \
>      -e CONFIG_DEBUG_INFO_DWARF_TOOLCHAIN_DEFAULT
>    make LLVM=1 olddefconfig
>    make LLVM=1 -j(nproc) vmlinux
>    ...
>      LD      vmlinux.o
>    vmlinux.o: warning: objtool: folio_zero_user+0x801: undefined stack state
>    vmlinux.o: error: objtool: folio_zero_user+0x801: unknown CFA base reg -1
>    make[2]: *** [scripts/Makefile.vmlinux_o:76: vmlinux.o] Error 255
> 
> objtool in verbose mode shows how the frame pointer is omitted:
>    make LLVM=1 OBJTOOL_VERBOSE=1 -j(nproc) vmlinux
>    ...
>    b15a2c:  folio_zero_user+0x7fc      xor    %eax,%eax
>    b15a2e:  folio_zero_user+0x7fe      mov    %rcx,%rsp
>    b15a31:  folio_zero_user+0x801      mov    %r14,%rdi
>    b15a34:  folio_zero_user+0x804      mov    %rbx,%rcx
>    b15a37:  folio_zero_user+0x807      call   0xb15a3c <__clear_pages_unrol
> 
> After the fix, the frame pointer is back:
>    b15a37: 31 c0                       xor    %eax,%eax
>    b15a39: 48 89 ec                    mov    %rbp,%rsp
>    b15a3c: 4c 89 f7                    mov    %r14,%rdi
>    b15a3f: 48 89 d9                    mov    %rbx,%rcx
>    b15a42: e8 00 00 00 00              call   b15a47 <folio_zero_user+0x817>
> 
> It seems the issue was introduced by
> commit 54a6b89a3db2 ("x86/mm: simplify clear_page_*")
> 
> The actual fix is to revert the change how ASM_CALL_CONSTRAINT is
> positioned.
> Additionally, reintroduce asm_inline to prevent potential compiler
> rejection of inlining.
> 
> Link: https://lore.kernel.org/CAAX90H2_RPnZL_dFYN7cQF6yt-wAweKKSx2=6e2aZ0kv+Pm+NQ@mail.gmail.com
> Signed-off-by: Dmitry Voytik <voytikd@gmail.com>
> ---
>   arch/x86/include/asm/page_64.h | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)

FWIW I just bumped into this build issue; this patch helped and the
resulting kernel booted.

Config: https://pastebin.com/B6GedVDL


Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>

