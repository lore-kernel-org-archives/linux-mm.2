Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99930C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 06:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692A06B0088; Sun, 30 Aug 2026 02:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643FF6B008A; Sun, 30 Aug 2026 02:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50A776B008C; Sun, 30 Aug 2026 02:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5C36B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 02:01:00 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82AA2401E5
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:00:59 +0000 (UTC)
X-FDA: 85156887438.14.127E882
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0C249140006
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 06:00:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cSkACYyB;
	spf=pass (imf26.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788069657;
	b=VxlqALJIXe/epoRscD23mvfigg4H/rtLmMOLSgB0W6F0kbMW56ampU6kbfkPJUlKKXafw/
	YxMOLzXEAPENBWDbyTKxOpcuejOqoBI23Gt/7n2Djp/JWG0+ZV97qhW1DmYFwWztpKvkn3
	lCSecmAUJT4hNSFBlEJrz1rDe91ThFU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=cSkACYyB;
	spf=pass (imf26.hostedemail.com: domain of sourabhjain@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=sourabhjain@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788069657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cUId8mVD0q8ArFhphi7F2d/4HgLaI29h9tmyckBAMNM=;
	b=AXO4Cjg3igoh6tAl6OF13aYbaYfAprhIPU+3yuNhPjRKxtMrXpIkc41zqLP05SkUlsGjtm
	PaP/4ItcY5GRAZ8jVANOP7QwP+/gsyhcwpiO/9pnJeZDOTxLXtkszayPvLnAcEJbrkn4cg
	vUrSrJKglXMB7Qiz/GogWWbmFcvT+ZI=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67U2WDXN2400791;
	Sun, 30 Aug 2026 06:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=
	content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cUId8m
	VD0q8ArFhphi7F2d/4HgLaI29h9tmyckBAMNM=; b=cSkACYyBJLDRRx9opzknY4
	y+yIFBl4Nutn5BApIR7IwEsytvC10dMjY8NV5y/ohqDUV6vHmeT+qDmM8kq5cVDQ
	eaS8CiIyguiYz5y+NrqvStAVHykS0iHR4fg7m1iSTHhlif64lSPcRZVCFQGSaNJG
	VPglpDjFY1/Y1/N4HKuHLw0HubPtnIyYDYkBNDp6tXJ6te62NnXIaTh8gbJ2qhTT
	X2dsKTwQnuibJjWbek/LpedmeCY7IEb2oAkagEKbx6SPgppsqvcxPm8FqQTYbMKJ
	ndy9jM34L7Vhnl8jR4KrtTMeNuoj4cRF4dCiNGMiQ2A9cW6RfNGYf9WjOErNZzRw
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gbpx53ptv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 30 Aug 2026 06:00:15 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67U5vr4O029036;
	Sun, 30 Aug 2026 06:00:13 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gca4vrmb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 30 Aug 2026 06:00:13 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67U609Hq45679074
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 30 Aug 2026 06:00:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7C18A20065;
	Sun, 30 Aug 2026 06:00:09 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F1B972004F;
	Sun, 30 Aug 2026 05:59:45 +0000 (GMT)
Received: from [9.67.21.115] (unknown [9.67.21.115])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Sun, 30 Aug 2026 05:59:45 +0000 (GMT)
Message-ID: <87186b8a-f68c-400b-97cf-8ea6129eba69@linux.ibm.com>
Date: Sun, 30 Aug 2026 11:29:43 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/17] crash_dump: Fix potential double-free of
 keys_header
To: Jinjie Ruan <ruanjinjie@huawei.com>, catalin.marinas@arm.com,
        will@kernel.org, mark.rutland@arm.com, chenhuacai@kernel.org,
        kernel@xen0n.name, maddy@linux.ibm.com, mpe@ellerman.id.au,
        npiggin@gmail.com, chleroy@kernel.org, tglx@kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, akpm@linux-foundation.org, baoquan.he@linux.dev,
        rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org,
        ruirui.yang@linux.dev, kees@kernel.org, thuth@redhat.com,
        gshan@redhat.com, jic23@kernel.org, james.morse@arm.com,
        ardb@kernel.org, leitao@debian.org, yeoreum.yun@arm.com,
        coxu@redhat.com, tangyouling@kylinos.cn, hbathini@linux.ibm.com,
        adityag@linux.ibm.com, ionut.nechita@windriver.com,
        liaoyuanhong@vivo.com, seanjc@google.com, fuqiang.wang@easystack.cn,
        makb@juniper.net, piliu@redhat.com, ebiggers@kernel.org,
        jbouron@amazon.com, mclapinski@google.com, me@linux.beauty,
        graf@amazon.com, bgwin@google.com, robh@kernel.org,
        takahiro.akashi@linaro.org, palmer@rivosinc.com, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, Coiby Xu <coiby.xu@gmail.com>
References: <20260826092541.3905933-1-ruanjinjie@huawei.com>
 <20260826092541.3905933-8-ruanjinjie@huawei.com>
Content-Language: en-US
From: Sourabh Jain <sourabhjain@linux.ibm.com>
In-Reply-To: <20260826092541.3905933-8-ruanjinjie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=PPc/P/qC c=1 sm=1 tr=0 ts=6a93c6ef cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=Z4Rwk6OoAAAA:8 a=20KFwNOVAAAA:8 a=7ipKWUHlAAAA:8
 a=i0EeH86SAAAA:8 a=701CVkoOzhNhLSDMr48A:9 a=QEXdDO2ut3YA:10
 a=HkZW87K1Qel5hWWM3VKY:22 a=gpc5p9EgBqZVLdJeV_V1:22
X-Proofpoint-GUID: VgyuYv1qmRcG1RUhv8Elbl7B939Neyl3
X-Proofpoint-ORIG-GUID: Ipd0BTF3q-Kx16yAzRST5lJIyZJ6aY6-
X-Proofpoint-Spam-Info: AW1haW4tMjYwODMwMDA0NCBTYWx0ZWRfX6WdQnaMjbzZO
 +vsf9opR0Aw4vftuFjHoTgPv0tiqXKxTJoFqX/mna1HUV5/x/Hd8t1lraC+Wap35uQc7BqfgpfX
 79DNFHmQwQFUUnTnv04xySvmAwYH+eg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODMwMDA0NCBTYWx0ZWRfXxCR2SgGnG2ln
 0DIs1D4pJzx1bLvPEbmQWlt9WYJ4EN6ORjTdDAtj9FVMwsbLY1mJAqY9wFeXbjVx0Guu/PXN8mH
 r5aVchZXCCYmviAw1t05jDAPTP/BmPnt49C9bHbNS0HDcMl9KnEA8ASaD2Az6SBMeEczNVWMC7w
 VMUbxScqll0iizrX6hQWyJEADnxG9t1HKC1P0aZeS8Q+SRn+bl1j66HjK4LbhQSOX8QBkpvsVy7
 nLT4NuZf6YNHJ4LeU5DSfpIVmsyIMgiTuONGAp0ogscqfbBpgW7Nc1nOMsmz2e/joUHX3cgP0Ib
 WCotoOpIk1dhEEOCBBkAUW3xYD1FgeX1VScKe47iEGlbTYzCRup4JQLSmtLuH/Vmxhi3LgNcpT+
 EBIBgNUelP8Vody5Fi6uDVQjdHb8h5thhRxPTn/W13iQlsx4Ywi/yOwFmWTDjlCOsKYrwU6ZOye
 JxbVCJGpMDVq3dGCsBQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-30_01,2026-08-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 phishscore=0 adultscore=0 suspectscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608300044
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0C249140006
X-Stat-Signature: 89qrsukydi4z5ec7odj76m58gp94we59
X-HE-Tag: 1788069656-454052
X-HE-Meta: U2FsdGVkX18rSmUXY6kGh0c1514Z4ppGRyJQog/lqOTA8D8nJmsNC7v8RZ4UptDGPkOYVRv6a0Q3cEFKh1o448lo2nggeadcCycv+EjChisJPZTV2g1ImBYTi8H3zc0qNwyPtqtUnzuxe9mBmmesMpMabSjX6019vikPaWE97ssyXBwNMzZpzZBmzqTOrwfZxcVugERVtz+80gV84BxRR9qyl3mqV+38ksdVSiqAS1pLiDAe0dIq7zyUUsYozYeXLbSs/4t/KO6accF2Zl/ghGdoxDYQrcQATXu4UK2bPYASL3IfJS7W9oDnc6U0gWd9lw2MBsZol69xrEeP3VyNz5XB9KFdIMwOSpS/v1OIVGjVngMjI/ZMgb49ZF3XpW2lpnOM0aZSbBLZ1qW3nl/aKbsR2FnMRI63Rben91xZXpT8N6lLEqrtPxpbtN4l/SKtQqE9yi5vfmGbZsTxcbycaD5nILocviJicx9MQ3wCRi4W3pVkCDgtSpFmoWiC+2mODKUZwiOc4LLxxHc5U+KPCQcoFJt7vkGX+7JC+MAKLpWmWAgA2anqsK39vD3lUH52PE4pEIQtXRXkDQJwaRZh8cF+d3F+0T01TNF/+fFVf8hdxSbou1q4HiJfFEVXlsqbW0qQTY2b0P4ea849lzorhbi/xPawGvbm2nMW8JQlrWWjbDJf5NxfFpHHQLkdDA+7OblbSn4v0yATlDvc84k0gA1LJk5grZW1PifnYqs1Up8jNj6s2PjFd/6jigqx5cibmPR771xMUYbyn9RSdigY9E4Lt5c0vEPK+0cEqV0ou3YcBKqPVuBjTOIHi/bO+e/uxCo1GrEEu1SoY7ChwuNME+sLAVoPj6B1RL/1t10F0b8cuPGqz1P4sDndOmy/5Oj0hHowegnKCYyTIuOjUJVxbche6XqReuSjuzt91YREcR4ceicjhUtnI6SMP1FRGAGs1qvk2amTbz3kgsj1Qr4
 Vw4iUl+3
 WK487Ycnlct4A5VC053Ckvj/0kbpf0tzL6YTNg08QnNucy1p5r8F0AWlObxq1Ac1I+lBlqVNfA3BnR0PcFOICteTg2dm7b35FlSE0xXFQie4Rg5ZBdtAPHDOXifVbK5713a7mV+GKnzi2g3/6/29OEnvguHyVc6S9kaKcCBgeCVmLVlsjKlGUbpFa063UEpAqWXWZTdkyfrFGoiVwst3c7yQiuMwBYzp9W8PPmstHhooqPuk1sJvIed1flRQE1RqToLjP2t8lovFSL7OAhyZa+geCTx69MEr2/Z8gLmVyJ9S1ZS7r7b0UodwbxSKNtIIbNQ3AkR75LFC6ebUNvwLWD/5FRGTrWt5SqPyRW3P5lS83HjqMiLCjLqikvDgBG4MN6TFhy01L/8OCRuNWzNLy35ARhqEAZfCdoTGYB7aFf0UH9LJjeWzWSiBz3mMTErLf+DYQMKJ5V3L6lgRD9G4FesxXx0oHR/LqyqpN2kAWqvW7lPrVXpDHC8xbjKb/9ie5brdVaIN/0rQIcypF2SzHhLlqw5Aakzyj/GCq61giJ1hC8SPibC/eP4Frnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Jinjie,

Coiby is handling this issue in the below patch series:
https://lore.kernel.org/all/20260828084900.1496839-2-coiby.xu@gmail.com/

Since the above patch series is all about crash_load_dm_crypt_keys, 
could you
please consider dropping this patch from your series and reviewing his patch
instead?

Thanks,
Sourabh Jain

On 26/08/26 14:55, Jinjie Ruan wrote:
> `keys_header` was freed in `build_keys_header()` without being reset
> to NULL, and the error path in `crash_load_dm_crypt_keys()` freed it
> unconditionally even when reused, leading to double-free or
> use-after-free.
>
> Add `free_keys_header()` to centralize freeing and NULL-setting.
> Use it in `build_keys_header()` and only free in the error path when
> the header was newly built (`!is_dm_key_reused`).
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
> Cc: Pratyush Yadav <pratyush@kernel.org>
> Cc: Dave Young <ruirui.yang@linux.dev>
> Cc: stable@vger.kernel.org
> Fixes: e3a84be1ec2f ("arm64,ppc64le/kdump: pass dm-crypt keys to kdump kernel")
> Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
> ---
>   kernel/crash_dump_dm_crypt.c | 15 +++++++++++----
>   1 file changed, 11 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/crash_dump_dm_crypt.c b/kernel/crash_dump_dm_crypt.c
> index c685497cd470..ed0960ff0987 100644
> --- a/kernel/crash_dump_dm_crypt.c
> +++ b/kernel/crash_dump_dm_crypt.c
> @@ -363,15 +363,21 @@ static struct configfs_subsystem config_keys_subsys = {
>   	},
>   };
>   
> +static void free_keys_header(void)
> +{
> +	if (keys_header) {
> +		kvfree(keys_header);
> +		keys_header = NULL;
> +	}
> +}
> +
>   static int build_keys_header(void)
>   {
>   	struct config_item *item = NULL;
>   	struct config_key *key;
>   	int i, r;
>   
> -	if (keys_header != NULL)
> -		kvfree(keys_header);
> -
> +	free_keys_header();
>   	keys_header = kzalloc(get_keys_header_size(key_count), GFP_KERNEL);
>   	if (!keys_header)
>   		return -ENOMEM;
> @@ -441,7 +447,8 @@ int crash_load_dm_crypt_keys(struct kimage *image)
>   	r = kexec_add_buffer(&kbuf);
>   	if (r) {
>   		pr_err("Failed to call kexec_add_buffer, ret=%d\n", r);
> -		kvfree((void *)kbuf.buffer);
> +		if (!is_dm_key_reused)
> +			free_keys_header();
>   		return r;
>   	}
>   	image->dm_crypt_keys_addr = kbuf.mem;


