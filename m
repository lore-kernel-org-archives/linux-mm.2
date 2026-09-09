Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9C57C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 15:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948876B0093; Wed,  9 Sep 2026 11:53:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F65C6B0095; Wed,  9 Sep 2026 11:53:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E0726B0096; Wed,  9 Sep 2026 11:53:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 563556B0093
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 11:53:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3179B120254
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:53:10 +0000 (UTC)
X-FDA: 85194667740.18.A6F14B6
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf02.hostedemail.com (Postfix) with ESMTP id C3A4F80002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 15:53:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b2jD6ieE;
	spf=pass (imf02.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788969187;
	b=iDMRVhdS1c/pRC8mx60phcOtIahdESgavpHHkxhqMYtcP3sZcaUayv/H+SxfQ3AzOOz+hN
	n6yFhKhQL6R2wiESXFSFlVkH6nG2xdZL+ZiDPJkgDyXVabpnPhGApiS2oDJsfKFaJOAEU8
	2uojrCituJ0+xcLjGOokPSCbFDltffk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=b2jD6ieE;
	spf=pass (imf02.hostedemail.com: domain of rnsastry@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=rnsastry@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788969187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aJQ3f9xbjxMwuiEJ1zAsToahe8kVJn3m9fPpmaehrMQ=;
	b=m12efxun7kZmtdVnmXYCOZ2AZUkm0tRWT6meQkmgc6YEDV8EOm0/pdPUDwLxKIU2T4Va3Q
	BberjEMUTMxvxcd/ii6Ngr7qOnTnCfmU8n5WYpLH25zxqsHb8okbJzsNr5n5ZUZeZSSpwb
	m2+hbLhyFF55xS3bLoXcnz2zcsCOaEw=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 689B1aW83839613;
	Wed, 9 Sep 2026 15:52:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=aJQ3f9
	xbjxMwuiEJ1zAsToahe8kVJn3m9fPpmaehrMQ=; b=b2jD6ieEKr5a47fTeuPlQn
	sG2l2XYvTfMvncOLggdaCSR7xbtyEqqicTLk+J/qKKkTfPAjBJngsJgiCJzcpR7h
	oSoGobuJP9zkOKRDReLcUdhm+2MYx5/1Uo/99uE9ekSsPWYp1Q9iBTfsjOD1to0g
	aTBwqXF6o0KWcoK8vxOba7M1IQp/NsOVCU5qJnqaT3SvbC2GTesKTonbf2p6KXX+
	M/J8nZ8lcoe5xnOPAtAocGZiPS3wVsxi0QNv/BFhG3XCHohMggZOgU4BvLnAf6tW
	KU0sC1dY2f0eUZgzIQj96TdbGd+PlQKVJ3qknHj3MT+acj2qeGtV0JBTiltFvqWw
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4ggbhf6hcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 15:52:56 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 689FfD4g030374;
	Wed, 9 Sep 2026 15:52:55 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ggwdqk94x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 09 Sep 2026 15:52:55 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 689Fqpt649283520
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 9 Sep 2026 15:52:52 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCB8A20040;
	Wed,  9 Sep 2026 15:52:51 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 80F0A2004D;
	Wed,  9 Sep 2026 15:52:41 +0000 (GMT)
Received: from [9.61.255.18] (unknown [9.61.255.18])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed,  9 Sep 2026 15:52:41 +0000 (GMT)
Message-ID: <371e950e-8d05-452e-b81f-57b120c370df@linux.ibm.com>
Date: Wed, 9 Sep 2026 21:22:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/22] powerpc/spufs: don't dump more than the note
 supports
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: Jacob Lalonde <jalalonde@meta.com>, Josef Bacik <josef@toxicpanda.com>,
        Jann Horn <jannh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Omar Sandoval <osandov@osandov.com>, Jacob Lalonde <jalalonde@fb.com>,
        Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
References: <20260820-work-coredump-sparse-v2-0-ba32dd718c51@kernel.org>
 <20260820-work-coredump-sparse-v2-1-ba32dd718c51@kernel.org>
Content-Language: en-US
From: R Nageswara Sastry <rnsastry@linux.ibm.com>
In-Reply-To: <20260820-work-coredump-sparse-v2-1-ba32dd718c51@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: Vpz_JMlA2xDilx_mOxqxkGzGaeHwxFvX
X-Authority-Analysis: v=2.4 cv=RIaD2Yi+ c=1 sm=1 tr=0 ts=6aa180d8 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=eMoGHGNclBrxslJz7JwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA5MDE3MyBTYWx0ZWRfX34hiaNYn2Z+S
 hgBtQiTobuQYrHJX6gsJIJBIG4ahe7XHwTJ42oLWMaT0s8cf1B+YuF/mpXEJLBqkdp/2SFe9j84
 Pi8F6lti/HQLUiGCf6P9l52iforvejg=
X-Proofpoint-ORIG-GUID: LzRG8kMh5H0DvZ9UWi0BCwao6ubK88PV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA5MDE3MyBTYWx0ZWRfXz1c7miAXQplM
 bOIrKaACTzAPfh71wupQgNaUEJC1w4GSNp9qOunmjMij39MUwS7W3Tcyx0TSbCNk/gXRlznMPUz
 PhO0hpBGJdx35LI4z9D91L4uQv52BOffXpZWFXzAUhUO08mwVtQh6BFPe1yTLfvBeSyTGab2HJh
 zB2bThp33YnKXUubwGq1nX+vH3Hs6fqqbKE8EPnZBqRKY8tadMqacKispmzsFlM9+juxOsqWlrW
 lgXPIVziPYwJyQUdsRJjjfFntZkqMeRtz5LIMW6MWHUncY1OCec3GvSl8muQVkLC1gpiD+c42LX
 6fpAXL78yIcJfiBqovqLeSlXzhcuJTUgCPlbEmZDuGdx8+lX0M7Ps2wK28IcED1FS/HfudXbTcB
 OiRsBxWuBXRJQQy8VskXVlXrttCU2CrIR/z8HCBhqwhKE8dY7pam8bXQ3aW97GLjZfehIjzV8Q2
 nkd3BjPMPT4mXtPAEfw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-08_03,2026-09-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 suspectscore=0 malwarescore=0 priorityscore=1501 bulkscore=0
 adultscore=0 phishscore=0 clxscore=1011 impostorscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2609090173
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C3A4F80002
X-Stat-Signature: 7dja3jziu51owyi4br9ky9tpkyufoe1s
X-HE-Tag: 1788969187-647145
X-HE-Meta: U2FsdGVkX1/nBxjpxmva6zIs2AARbMPZlXpBpCcjZUQ2+vAg38X5pPgPhUTjm0rY3qI1IZXnTgESqdAwga0zkpKx6FX8NbMmhPwhrE7xmRZ9BYKm9K5J/sHBm3RzkJBEoxx6/nZcfo1h1Rfzdhp2XdQ6ChxFFvAbRTPSzyus9hg2q5MYKPOf9mRIIbAG1R5V4a365JwUzDa7mxFSoaTkXcfmVGS5lE9ZYBIr4wnVOUJ8l8PlUauLqfoXg/nONz2GeaMn6r8ZaJyMQii4RPlnQYkEWDED7+72/Zm6yDQmkNhiA06NtZ4ZLANhyl8riziTARvcnfCV/J5EDVMprsntbEorVhar+J+NSciEkqhiXrJncdBiikIJcmfRHcmSxi930eyxQUeGBY8jbnacNoftjOfuMobczpYTdSpIxuNCl6DVkDfb4f03tge3GjpXZDJCiF1vqXmvkFojnJgSDozYv3QB+Gsrl+q6TNVKOlz3ZH9B1+oLGdy6ciNgbp2isXdC6ZH0XNKTIWPdBypuCVS0psJJliEQdc1ZZ2Me4pLzlYu9w5gABRjGZ+Sm02xiOfHapVqim1084mRJFeyUAbI8m/0dxpSSLVMh9YToBBV6Gl0L5D7PoD1s62p6ovTF48e2/CBSKsRmcM8aPxdxjQE3Cty8SJ9btqOenAE57Kny/dcFb3z3x9rkIjBo1VAZ1Ig3E/nfI5f/5nr21/u/yyUhOVzCxoI/D8wU6J5o3WpV9TwYNqi7EXJHnzz926h60VEdSFSIFoZRg+DPuN3CBklhsRnSsaw/Y/9pLwxIu9GKKEQq4snko92mTReRlreiV3ifHQysySD04lfcUJmWfMHeeEn7r72UdGBrCX1NfmjYmAxVML+OlJvLi9eh78s7V0q+LDyqNN2gKrJkHSgCKuZjMA5LTKZJYjHKPX22HawFLgvJ/keTgoJ5yLaoqdVqut5YbQ+iX/bhXABnSMkHPVQ
 OfcpFxoR
 k4sqDIYXhtXc+ELi/IaI+6DRYJq/TkW48LlLMa7uyEJsEpCB+rJD8CosFD8w0mxVRQaPx3w2zQL70nNa9gpeSEpzxM0FBCzD5BcBqniUXm4E0XVX8U/S6O+Kd1LE+HbcjIpuRZYek0VNORMkjBvgXRfN8fLqFiCADiN2/GfYjiPXZzDxtN8xoXvFxa15tM/AkMIKWYQNtSswoqes8xZfsuad/D4cfgPT4EWCPx1pJc3gskskx2zx7ts2Ix7UsJkGlAdUHtyw0cCKSWJ/k07n93ifGYZtJDZYa+tHYZxTJ7r3S+xCAYTUQzrGuaybcer0VjndJQoYGCogjEzphzLh1V0ZiDev3i4l62RSM3+qCEkxqIDcEd2rhqQBUFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 20.08.2026 4:39 AM, Christian Brauner wrote:
> The spufs_arch_write_note() function puts notes in the header and uses
> them to fin where the next note starts. The spufs_coredump_read[] array
> provides the sizes of the notes:
>
> 	dump_skip_to(cprm, roundup(cprm->pos - ret + sz, 4));
>
> In this call @ret is the amount of data the dump callback wrote. @sz is
> the declared size. So the position moves backwards if the callback
> wrote more data than the declared size.
>
> For three note sizes that is the case:
>
> (1) signal1 sets sizeof(u32) and dumps u64 via sizeof(ctx->csa.spu_chnldata_RW[3])
> (2) signal2 sets sizeof(u32) and dumps u64 via sizeof(ctx->csa.spu_chnldata_RW[4])
> (3) ibox_info sets sizeof(u32) and dumps a u64 via puint_mb_R
>
> The note is 4 byte aligned. The dump_emit() call wrote the dump_align(4)
> just before the note. So if @ret is 8 and @sz is 4 the position ends up
> 4 bytes before the current position which means cprm->to_skip is now
> negative.
>
> For __dump_skip() with size_t that means the pipe or socket gets 2^52
> PAGE_SIZE zeroes. This also means a file seeks backwards and overwrites
> the four bytes that it just wrote.
>
> Before commit 5456ffdee666 ("powerpc/spufs: simplify spufs core
> dumping") this was benign because this truncated (on purpose, I
> presume):
>
> 	u32 data;
>
> 	data = ctx->csa.spu_chnldata_RW[3];
> 	...
> 	copy_to_user(buf, &data, 4)
>
> and after said commit things became fscked. So let's truncate this
> again. Not truncation means the wrong bits will be picked on big endian.
>
> Afaict, spufs is effectively dead so the fix probably doesn't matter in
> the grand scheme of things.
>
> Fixes: 5456ffdee666 ("powerpc/spufs: simplify spufs core dumping")
> Cc: stable@vger.kernel.org
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Tested-by: R Nageswara Sastry <rnsastry@linux.ibm.com>

System: ppc64le LPAR (IBM POWER), Linux 7.3-rc2
> ---
>   arch/powerpc/platforms/cell/spufs/file.c | 18 ++++++++++++------
>   1 file changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/arch/powerpc/platforms/cell/spufs/file.c b/arch/powerpc/platforms/cell/spufs/file.c
> index de7494748fec..6f86d87e3749 100644
> --- a/arch/powerpc/platforms/cell/spufs/file.c
> +++ b/arch/powerpc/platforms/cell/spufs/file.c
> @@ -956,10 +956,12 @@ spufs_signal1_release(struct inode *inode, struct file *file)
>   static ssize_t spufs_signal1_dump(struct spu_context *ctx,
>   		struct coredump_params *cprm)
>   {
> +	u32 data;
> +
>   	if (!ctx->csa.spu_chnlcnt_RW[3])
>   		return 0;
> -	return spufs_dump_emit(cprm, &ctx->csa.spu_chnldata_RW[3],
> -			       sizeof(ctx->csa.spu_chnldata_RW[3]));
> +	data = ctx->csa.spu_chnldata_RW[3];
> +	return spufs_dump_emit(cprm, &data, sizeof(data));
>   }
>   
>   static ssize_t __spufs_signal1_read(struct spu_context *ctx, char __user *buf,
> @@ -1089,10 +1091,12 @@ spufs_signal2_release(struct inode *inode, struct file *file)
>   static ssize_t spufs_signal2_dump(struct spu_context *ctx,
>   		struct coredump_params *cprm)
>   {
> +	u32 data;
> +
>   	if (!ctx->csa.spu_chnlcnt_RW[4])
>   		return 0;
> -	return spufs_dump_emit(cprm, &ctx->csa.spu_chnldata_RW[4],
> -			       sizeof(ctx->csa.spu_chnldata_RW[4]));
> +	data = ctx->csa.spu_chnldata_RW[4];
> +	return spufs_dump_emit(cprm, &data, sizeof(data));
>   }
>   
>   static ssize_t __spufs_signal2_read(struct spu_context *ctx, char __user *buf,
> @@ -1965,10 +1969,12 @@ static const struct file_operations spufs_mbox_info_fops = {
>   static ssize_t spufs_ibox_info_dump(struct spu_context *ctx,
>   		struct coredump_params *cprm)
>   {
> +	u32 data;
> +
>   	if (!(ctx->csa.prob.mb_stat_R & 0xff0000))
>   		return 0;
> -	return spufs_dump_emit(cprm, &ctx->csa.priv2.puint_mb_R,
> -			       sizeof(ctx->csa.priv2.puint_mb_R));
> +	data = ctx->csa.priv2.puint_mb_R;
> +	return spufs_dump_emit(cprm, &data, sizeof(data));
>   }
>   
>   static ssize_t spufs_ibox_info_read(struct file *file, char __user *buf,
>
-- 
Thanks and Regards
R.Nageswara Sastry


