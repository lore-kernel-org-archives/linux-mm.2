Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E654ACCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 15:58:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170798016E; Tue, 28 Oct 2025 11:58:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 148638013F; Tue, 28 Oct 2025 11:58:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 084AE8016E; Tue, 28 Oct 2025 11:58:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBAF38013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 11:58:00 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 65BB6B855C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:58:00 +0000 (UTC)
X-FDA: 84047979120.29.4D3A5C1
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7ABF1100005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 15:57:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lID+5GGV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761667078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mgzHWai9b6XGwGZe0nQxw4+ISjl+G4EjaAYWoRIkLyE=;
	b=bEQwViU+/Uu7f6iB2/F0Oz/+s1Dk70zdeYHcbdtKTyO7JEB+GfeHYdACNYKpnj4vqIyUTC
	LfpCV1fpGSAYxtatOBx5UwbMGffJc2BnN4TqAoEWTcOakYe/pZffgYGKqbbxxgs4YPfcZe
	goYPemaQ3yW4xAx/SFXKMbwpVfgskIs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761667078; a=rsa-sha256;
	cv=none;
	b=2d1gwGlgSIYQ7htLxwn3Iwj+RiXq81PH2MvbuZfHQqYWT/pTZ76B7q4vIX5CTFx7WvK06c
	ZL1hCN1UIEcLUJ08beUWbcrcD8uv7crtzVV4gKg2nRDDJAexyonwQljrPiclrrbtAK3XYe
	HWsdiilGNkpSfOkU2no+CZedpaduTPU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lID+5GGV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761667076;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mgzHWai9b6XGwGZe0nQxw4+ISjl+G4EjaAYWoRIkLyE=;
	b=lID+5GGVDlXXyYSyM63V7A9rsUjWgkwaGuNygOvbcOIxV8HufF4T46NYOSn33PTyeVZpCa
	qPpwF1YPB6rSyaZR4D5wFdJBiw0wPdw1LRbpBJEK4hJH3G1V+2jv7TXR7LGYGL2Ppnkw9k
	fWg3hoNIpQ3I7CPwtQejzFWQFx0x91M=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: bot+bpf-ci@kernel.org
Cc: akpm@linux-foundation.org,  linux-kernel@vger.kernel.org,
 ast@kernel.org, surenb@google.com, mhocko@kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, andrii@kernel.org,
 inwardvessel@gmail.com, linux-mm@kvack.org, cgroups@vger.kernel.org,
 bpf@vger.kernel.org, martin.lau@kernel.org, song@kernel.org,
 memxor@gmail.com, tj@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
 yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH v2 02/23] bpf: initial support for attaching struct ops
 to cgroups
In-Reply-To: <9fd0fbd3d6e704d106423a333106d1296c916f288c3c3600ffde0539e8c266ec@mail.kernel.org>
	(bot's message of "Mon, 27 Oct 2025 23:48:17 +0000 (UTC)")
References: <20251027231727.472628-3-roman.gushchin@linux.dev>
	<9fd0fbd3d6e704d106423a333106d1296c916f288c3c3600ffde0539e8c266ec@mail.kernel.org>
Date: Tue, 28 Oct 2025 08:57:46 -0700
Message-ID: <87wm4f5891.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: h7onq15pchm6k4wa6mdjho5j4ihwypkt
X-Rspam-User: 
X-Rspamd-Queue-Id: 7ABF1100005
X-HE-Tag: 1761667078-77784
X-HE-Meta: U2FsdGVkX1+wKkxs5E/Y10i8Nx2PqJqIzZJrkOOSvc5ZxY2RXIeL9WyauS5LqSToQJiesDPSJPmdTOaQlFCQxmuXHfNjHug70/FED+tkyqNuu+qp44lRdvM+5a0JSaAcP3A0Jh/7+qDg3Rp7l+7aATMh6WgthXG5exV55WFo137LFsQrgfRSrxlPtY0O/u2flYTkUN5fNThxYvUzLuA+Yfl8HazstUAfYlrR0UWOq1Ncyv2SBNRx1mOmExJEKAVk2KhB/ONsq9p7BXlcaFLfyj/kaicSYXy8nQIp2P390E6FZAo/XiHRvne2jojVp4YXniu67ie06xKIfU3ZQnA/JHcjarRYvRNqvXn0NO7/m2ymyjTjDn0EGGDm8oea3c5NNC6PwhRsdp1uPAQQ8A/2ttmduQ9K94oFIOhffzbuECmFhwZci/52NaKaPwIE6ooIJM4QD2igf3a/gfBDo9XojoMIuvIuAdjqiL9VvD+NgOtGsDHHmnX9LGMSdZMzem0ni28VkkQo+bFl1EfGtdq0PohwPflBqyGpp1GsP7ftt+YREhhj7ovbH4jyVr7NjGOAmyLUuno64Dy2fYvfyS6lKYKtH5zNv2+ULYytL3OMmosZiGW/CjDlL/Vq3ODQeFUx40HYC2GnIGZ47bsul7Xad55Km4Jni/P5i2Ex8bUeQPdKatR5X4ZOSOjhJk7Z/afpm8+YVMk2DyYUNspgNpsNcHzAP8JDFhWGQnmCIrZgMwFqtt6hMGHIpSp3NQgSg8CPf58GbQefpJAJJt+cnlHqv2hxKuzR6dhxyBvDt4Jpb4PLsMV47hBNfN4ftKXFX34pMPOs3CkjkY4hF2FEOiD5dIwQC7+v3MfHIk9R58JNebnBRXZ8teM9ObGJGN2yf07+QCd/FcF0exq+AESp9omft0ZRbpOqCPt2T8lea9ataA0rpNEiTQ3dtVCTRPBxw64OIUJaaKOf8poXgkAwv2t
 /0Mu1r9R
 sX8uxGnnIVbOikJv5kt9x582ZUQNDjMXdoFoe86rYEpL7CoHwOmOLx2YHoOe2+QVlgijBJaASOhF1/pfauIqilTKfn9oYTO9ZfBSRjsB8Gi1ymPguIw47Z0CTpFN8xGugL6R03ywmApquVf7YJGE1DqxWc1ZKgEJ3joxJ4Kql4dQI54nGD4G4hcaG/sdVmoVI0wN3VxWOm3138alJe8GciK9uC0uAxyfSsFeS03xmVpKWRSgyXVvEiExrzLtxtBVvVjKd2H5WqRotVgPhiTUQWfsquY58sdu7naP6z3RHYo0wpd+ZfdiA3VPixxHe04JEpEw7W9soMU4EDF0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

bot+bpf-ci@kernel.org writes:

> ```
> commit 31d238f36a0a6a56efa48c847cb776e67ba2f079
> Author: Roman Gushchin <roman.gushchin@linux.dev>
>
> bpf: initial support for attaching struct ops to cgroups
>
> When a struct ops is being attached and a bpf link is created, allow to
> pass a cgroup fd using bpf attr, so that struct ops can be attached to a
> cgroup instead of globally. Attached struct ops doesn't hold a reference
> to the cgroup, only preserves cgroup id.
>
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index eae907218..7205b813e 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1849,6 +1849,7 @@ struct bpf_struct_ops_link {
>>  	struct bpf_link link;
>>  	struct bpf_map __rcu *map;
>>  	wait_queue_head_t wait_hup;
>> +	u64 cgroup_id;
>>  };
>>
>>  struct bpf_link_primer {
>> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
>> index 45cc5ee19..58664779a 100644
>> --- a/kernel/bpf/bpf_struct_ops.c
>> +++ b/kernel/bpf/bpf_struct_ops.c
>> @@ -13,6 +13,7 @@
>>  #include <linux/btf_ids.h>
>>  #include <linux/rcupdate_wait.h>
>>  #include <linux/poll.h>
>> +#include <linux/cgroup.h>
>>
>>  struct bpf_struct_ops_value {
>>  	struct bpf_struct_ops_common_value common;
>
> [ ... ]
>
>> @@ -1359,6 +1360,18 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>>  	}
>>  	bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_ops_map_lops, NULL,
>>  		      attr->link_create.attach_type);
>> +#ifdef CONFIG_CGROUPS
>> +	if (attr->link_create.cgroup.relative_fd) {
>> +		struct cgroup *cgrp;
>> +
>> +		cgrp = cgroup_get_from_fd(attr->link_create.cgroup.relative_fd);
>> +		if (IS_ERR(cgrp))
>> +			return PTR_ERR(cgrp);
>                         ^^^^^^^^^^^^^^^^^^^^^^
>
> Can this leak the link and map? In bpf_struct_ops_link_create(), the link
> is allocated with kzalloc(GFP_USER) and map is obtained with bpf_map_get()
> before this point. If cgroup_get_from_fd() fails, the early return skips
> the err_out label which does kfree(link) and bpf_map_put(map).
>
> All other error paths in this function use "err = <error>; goto err_out;"
> but this one returns directly.

Ok, this is indeed wrong, will fix in the next version.

Thanks!

