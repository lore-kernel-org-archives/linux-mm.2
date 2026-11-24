Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64AB5606A339
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.a=rsa-sha256 header.s=pp1 header.b=l3dTjAt2
Received: by kanga.kvack.org (Postfix)
	id 79FAB6B0824; Tue, 24 Nov 2026 13:25:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776AB6B0825; Tue, 24 Nov 2026 13:25:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68BDB6B0826; Tue, 24 Nov 2026 13:25:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1C76B0824
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:25:53 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BC78C80638
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:25:52 +0000 (UTC)
X-FDA: 85470841344.01.BE0F486
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2755614000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:25:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=l3dTjAt2;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795544750;
	b=ad1pyIB9uDA6qp+yVLiRSBfIepO+l+T1iCY/I6Xz+lWrIDPRCigTk7t0tfbPYDlqVSNgz2
	ZozN/7yBENAYXFBXTteBr/smlb1dsB9SBcZ2oHjh6+cc86rM8PQKSVRQTs5hiY2I8ozSo5
	UNyFE4rDOFK1dpG2jz6RB3dglS9IxOc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795544750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZzpPq1ob9UJ0Xx8VNNvDotWuBBmi2CQ2YmwJu5GpTM=;
	b=lacLfL902RHJLXZ8nunYh409FvrBgtcvYSHHtS3pZtSq1vTLY8bscsw2X1oMIQEXtLzmEr
	qlP4xgqY9ASFsapmNZSCRlOX3RTgwFT78Ky54+T+pCd882Tmhtrn/giLG+S9XS/La71An3
	rt1FAsoFLqcdYXvS3zV6FS7oB0+8PpM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=l3dTjAt2;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf26.hostedemail.com: domain of imbrenda@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=imbrenda@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOFYoQC3008243;
	Tue, 24 Nov 2026 18:25:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=VZzpPq
	1ob9UJ0Xx8VNNvDotWuBBmi2CQ2YmwJu5GpTM=; b=l3dTjAt2K63zLLLJXUNI9u
	xDSkucwlwAvx0VV1SdCVp7V3rYH2Hm4rXKwRV2Y7y0eLxhZnINdD8mxp5kcNDaWe
	mKLRuNh0hb+fpATgvWb+wWhq67bVr1GTNjJQb8uK837g/+7oVm9iJZlk+WOM1ocH
	Kji3e0CuM+PysRTX173t6QioKjXvNoUHdBEeHLQLSHweM2oomlFWuEuu1quHeUFV
	iREAIbf/LcOfLo8qT+LASWVkTFRyF1nzQn/Mx8t+Ceu8AmY4zA06eXNFL1fPWQmf
	HRw+eoxG0p0M2tbXgyk1GeqC7qJtw1dIv9Y1T8Q1ZQePhYiM9aLe2ISC2OF7QY4g
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4j34fa94mn-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 18:25:40 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 6AOFJW5P817075;
	Tue, 24 Nov 2026 18:25:39 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4j5a411736-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 24 Nov 2026 18:25:39 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6AOIPZ7848890174
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Nov 2026 18:25:35 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B1A720043;
	Tue, 24 Nov 2026 18:25:35 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3E0B22004B;
	Tue, 24 Nov 2026 18:25:34 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.42.244])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Tue, 24 Nov 2026 18:25:34 +0000 (GMT)
Date: Tue, 24 Nov 2026 19:19:56 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Carlos =?UTF-8?B?TMOzcGV6?= <clopez@suse.de>
Cc: kvm@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-riscv@lists.infradead.org,
        seanjc@google.com, pbonzini@redhat.com, akpm@linux-foundation.org,
        david@kernel.org, peterx@redhat.com, ljs@kernel.org,
        borntraeger@linux.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH v3 7/9] KVM: pass the mmu_notifier event and flags to
 kvm_gfn_range
Message-ID: <20261124191956.105f57d7@p-imbrenda>
In-Reply-To: <20261112142039.907090-9-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
	<20261112142039.907090-9-clopez@suse.de>
Organization: IBM
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMTI0MDA3MSBTYWx0ZWRfX2g7p/APmDZD7
 +FKutPQbrWivuxmdL6oEbvGatMiAgGrstkVr3qWEWYfBphbbT9KEpaX01SPP2EdyWRqpT/JFT/G
 Y/8UAkXpvHM0R9cU6go/zc+QjKt3CtrwUG2uNdrR3cVjHZYlrgUTlCc6qnrR5jHqb48ObJnr5yG
 XWDPOiGq7l8+bsuocqisujNQ+T2OX2aBE5jcssWqd0/rxnGCan3KJPUQdF7N5ssEROllG8g1I3G
 oxWVuMOKcm+DOcA7M7e3KWJlEtQPjWyOHSVKj04ZUtNWe684TMNQ/0vTzVN/lQQgpOg+xjLARMJ
 ICOjqZwc8r6Onn7WhtBOYqqxs/lDs+iH8yeHuP1ofhvhzom7tFGe/xZMGLbPMYwCN/JPu5fbbhS
 dnOWdlLy/lzJ4fcrfNpsxb96gf4qkVi/bfNv/ihjWbeebOcxbgM7n//Dx4vCYwWtCtJUL0vEcnE
 jFU7xJrzRBpooS9Lo0A==
X-Proofpoint-ORIG-GUID: j8OLDtUZy6r6KTQh7BhViRFKCYHKl6YS
X-Authority-Analysis: v=2.4 cv=U6QHnuru c=1 sm=1 tr=0 ts=6b05d6a5 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=zJRp6_cAMcgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=oIiWE7W5Vk6XH6OXHjMA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 2Nf20C-yb7AeZvFs-II-eTTDn8p7a7qn
X-Proofpoint-Spam-Info: AW1haW4tMjYxMTI0MDA3MSBTYWx0ZWRfX4jFBJmeZ1r4N
 1xDPSwkCxjuOhqmSdfdMHRgjKzeHe+z0KeKJQ65wiWwonz5H8SCnHNpJfWdxYVy2/XtdCDUp27w
 xMyEv+08vKIfa8SXdOGLwZ65K8WsgC0=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.138,FMLib:17.12.100.49
 definitions=2026-11-24_04,2026-11-23_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 lowpriorityscore=0 spamscore=0 impostorscore=0
 clxscore=1015 bulkscore=0 suspectscore=0 adultscore=0 phishscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2611040001
 definitions=main-2611240071
X-Rspamd-Queue-Id: 2755614000C
X-Stat-Signature: cuxaxbryoejaq77rceszg6n3fzmecwub
X-Rspam-User:
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795544749-287754
X-HE-Meta: U2FsdGVkX1/2meoAXI7QM6JMlfNg+qn9s830454Hx8BKtcVLwHv9iWGeCcWre0IwPZxouunevjDhFNN172TvMwvoZA6yKg913UWMjBU8/J0lf5PWl8N9gr68IOBCRYyUtEzVQxU1jN6FFvvSnrjG6DDBod5PWAP3Jsv1C8HdDtvnBSe+455XVomRqjQuD0rIBvLaHEVqTtS2J0QjeuF0Y9gWcr3rxiJ5WFclUr6PCfDWr+3Zrck6AONBdsnehTcUhjESsvj6GusQq4LfEz/HRZll9ZczLFKIBklMtMHh4cAtFApwfob1CdcixuCQCo4go8tRAN165tu3FTDnBAM7DPj2hzhG1dCSBh6DUz6DPelSNJ+rcWb4NUuksZnr25gf/83PzlFBuy5tCWUi2nxNrhDOmuvZkdV/M+R+lj0ILYZFabyXcIOz4tCQQ2MDwaiV76OYrqvNtVIDvDfY2ostHSyQx9DrQtomE0CaVZWAhoIZRTBR6wONzsTwilUaZEf5Ba8GWVzFpiswVBsmMrVfa/3p8RNkYhBcPRG/P1fcJfgen8CIlzYsCNGWX5zXKxBkcJckdlThjtY/NthkNErdRF2Y8vLyBx0AjDxaNh7kbpDI+G4FJVIF4HwGGulhkOZsdy5fx2W4SvzsIvNQgN6QCH397KM5jPRMHLunIFXkDeJsDF/BXBzSljtGSAhs6m1WYnAge6CN8HXpMa1ufbXRwM47zH1Rb9e940CgRrdC40bP1t+Lw/3gHbkcFWFw1+F4MZfQaiOICrnXqlOsYjUGOofJpVPO8FwD7ZsddeF6sNctkaP0uS5yZNvssjBI5SWzYo+8gvhbI8S1teLu4twbnVQHLej15OtFIw4BgUb8TbqJtfSH6szUa1sy1wGFSIWL4tR563Jtbfnm3csfkP2yTzjdJ4OauSN7UqavinSI1BGUTcd/f/U8hyshgJY+m6OWjuJXM3Mv2LvTxxSki2j
 AJQxF+hm
 WNk7FiaT59BUbkrigwPY+31HmBfw0ml4sN/S1n6e+gS+a647OaIsMY+RhWU/LJ13UadbL0uUhetAi3wq2PU4BI12Gi1c+5KSSUJxlYHn3C8lplDlLcshhDS2SxjoNHbze559ArIamUdyFOhk8hHgPPx0qBNYIBCyCqJI6oy2RrqIWvzrjYOucaHkifRgT42+h9kyNvKnUfm6M3SA4ZEBkWxLYgoUg9/LH6yoWlBPbqQhtf9AVtXEVxAe5Hz5Eaogr1sE5CLRACnC/wNQo5XIYqQsj67cNINnYbQYPJVjFdRtKmC3F/JNkB/L4tN/1E1UqqRG6W1h8VQX12KzAb+MdxrovqJLeNQbwLfKdXLBW+eLJyUXMWINgxAyz7/pqyMbfPvib1sy7yIGfAsPCUcSJxsqVWaiUGmSLyoH+8tt/1C6OeYrmgY9Kd3EhaQKCMh8yNpGILJgyRvQjejTM/MN9PsXJF9+lBDUwBgcw7xO025IkcBK1h4V9mpFbx4FHewfP2uYz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 15:20:36 +0100
Carlos L=C3=B3pez <clopez@suse.de> wrote:

> Propagate the event and flags of the mmu_notifier invalidation into
> struct kvm_gfn_range, so that architecture handlers can detect a
> permission upgrade (MMU_NOTIFIER_RANGE_PERM_UPGRADE). No functional
> change.
>=20
> Signed-off-by: Carlos L=C3=B3pez <clopez@suse.de>

straightforward, and also exactly what I wanted to implement myself,
thanks for doing it for me :D

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  include/linux/kvm_host.h | 3 +++
>  virt/kvm/kvm_main.c      | 8 ++++++++
>  2 files changed, 11 insertions(+)
>=20
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e7fc94e2910a..1f5ce4410ddb 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -274,6 +274,9 @@ struct kvm_gfn_range {
>  	enum kvm_gfn_range_filter attr_filter;
>  	bool may_block;
>  	bool lockless;
> +	/* From the mmu_notifier invalidation, if any. */
> +	enum mmu_notifier_event event;
> +	unsigned int flags;
>  };
>  bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
>  bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index cf4cb586f140..c517d1deb488 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -532,6 +532,8 @@ struct kvm_mmu_notifier_range {
>  	bool flush_on_ret;
>  	bool may_block;
>  	bool lockless;
> +	enum mmu_notifier_event event;
> +	unsigned int flags;
>  };
> =20
>  /*
> @@ -613,6 +615,8 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_ra=
nge(struct kvm *kvm,
>  			 */
>  			gfn_range.arg =3D range->arg;
>  			gfn_range.may_block =3D range->may_block;
> +			gfn_range.event =3D range->event;
> +			gfn_range.flags =3D range->flags;
>  			/*
>  			 * HVA-based notifications aren't relevant to private
>  			 * mappings as they don't have a userspace mapping.
> @@ -738,6 +742,8 @@ static int kvm_mmu_notifier_invalidate_range_start(st=
ruct mmu_notifier *mn,
>  		.on_lock	=3D kvm_mmu_invalidate_start,
>  		.flush_on_ret	=3D true,
>  		.may_block	=3D mmu_notifier_range_blockable(range),
> +		.event		=3D range->event,
> +		.flags		=3D range->flags,
>  	};
> =20
>  	trace_kvm_unmap_hva_range(range->start, range->end);
> @@ -2552,6 +2558,8 @@ static __always_inline void kvm_handle_gfn_range(st=
ruct kvm *kvm,
> =20
>  	gfn_range.arg =3D range->arg;
>  	gfn_range.may_block =3D range->may_block;
> +	gfn_range.event =3D range->event;
> +	gfn_range.flags =3D range->flags;
> =20
>  	/*
>  	 * If/when KVM supports more attributes beyond private .vs shared, this


