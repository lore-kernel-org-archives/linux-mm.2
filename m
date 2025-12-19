Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DD84E668A0
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 22:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5FB16B0088; Fri, 19 Dec 2025 17:42:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07486B0089; Fri, 19 Dec 2025 17:42:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A12916B008A; Fri, 19 Dec 2025 17:42:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5CB6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 17:42:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 354A4B77AC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:42:52 +0000 (UTC)
X-FDA: 84237696984.23.6A8AEB9
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 45DED20002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 22:42:50 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kryMfCV8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766184170; a=rsa-sha256;
	cv=none;
	b=kf1mi6QCUmyFDezHDh8Y4ejJtgTGykGsO+waB5w60Nw+qm4jYDtb14Vu3HUJqe7m210JCL
	TFDncYL7IHPpmZj+t742foEKB1Qf8PWkhHlG2BxodhHZjL/hcWTLX+wGXUdZ9gXWXYsKu7
	TnS27uPIMBheP5MZjgDkV9JbfnbJ+7Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kryMfCV8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766184170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5yKgwo1ObVk1PtlBS0PDy4iJ86OgBR5tXdRHxkExP6E=;
	b=uRCRVPQY7VgWTTaDQtRCMqlXuew9YmM1j+/yN96ies5IsmeuZLCaPZjYZNnGjJyvc/Qx7m
	xqPm7b/CtX0zxZH3cl9Q9flVgtgow0Sd/Jj6TxpDF7GCnZLPnmHn8KruPImWQmePKgih0/
	l330kY/Ygt/tGAYkAMfkH59OrfmKDiQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766184167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=5yKgwo1ObVk1PtlBS0PDy4iJ86OgBR5tXdRHxkExP6E=;
	b=kryMfCV8sBFXLDY2tZpjHZ5qu1vI/gVuXJUBjnNSCrdRnE7BFWmA/8RA09W/orfjto4LX/
	h63wNLUV8XW7skMuBaqQpi8JYdA71n5gX3uMc9YI0BDiFM5SvOqubNegMWpviB2JVlOH0P
	7eHaitaKQmRxSh5LAftv34jiQIwjSBU=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: bpf@vger.kernel.org,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  JP Kobryn <inwardvessel@gmail.com>,  Alexei Starovoitov <ast@kernel.org>,
  Daniel Borkmann <daniel@iogearbox.net>,  Michal Hocko
 <mhocko@kernel.org>,  Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v1 2/6] mm: introduce BPF kfuncs to deal with
 memcg pointers
In-Reply-To: <nicnfk2rfemgjvrlp2wyztymyunfxgd4ixqfnkivzjckwn4x2v@fzxj6prn3c4b>
	(Shakeel Butt's message of "Fri, 19 Dec 2025 13:51:16 -0800")
References: <20251219015750.23732-1-roman.gushchin@linux.dev>
	<20251219015750.23732-3-roman.gushchin@linux.dev>
	<nicnfk2rfemgjvrlp2wyztymyunfxgd4ixqfnkivzjckwn4x2v@fzxj6prn3c4b>
Date: Fri, 19 Dec 2025 14:42:35 -0800
Message-ID: <87qzsqhz50.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 45DED20002
X-Stat-Signature: mjib73ygc15t8nbam1akchi9uygfde9q
X-Rspam-User: 
X-HE-Tag: 1766184170-694394
X-HE-Meta: U2FsdGVkX1+iSFZCunP71Xg9q3ZKQr+tOYrPOGS5XTxzz/cQpU/F5E3DmB36N3cbCr7Q1hv1PVAz2w1OaXbo15VKX82Y3xsz3nokYN6acutx5Pu8dQi+BRLmKas5U6xFGK7y5OGGRABv/U68GqfbKnZxjctf7eGq38erDRGq7coMnotV1WjyWu5QOBlSQI1+y3uF1SDp9VBnmVbKF9t3QUsI+Jn87JLfpmq2WjO3cbNbjyTNOCLq9IhA3OGRSb2kbd36ILSXgbyOreLCS9lzoKJtGICOcuvUn+Gtr1IYoO8efntCIXd2SgjtLJrr4aPM61XXEYg4djvoGRhS138baZwWgMUhhDjKDSZ+/P1hP6TWDr1nubtxyXr9eFfH4OsAHwdHdrSfhOkx/xyOJmaIBDO+/UPaLjggT0fQ6Lalzxk96BzVTH2iaRXeb2QE2FKgLOAACaXroVxsQqRiu7Cd141t4Y2XYM0NNwV7D9b5Tj/bgv4s5DEFzqIBoFMi+IvsK3vEX02yRTVt4g9INOfoUnCpTEFJeSGQB26uUYPX0v1iSritTj97c3kGSl7B8t7LwQR3hIGf9S2MR4Gq9okeHDhe5jQsGFsZQ0T1FlijqRKO78tINhdqTDKktUR1aXgbL7c0RH/8PDWiH0IkDp2R8KaKHhgVBOmJQzBKkyunKyKrZ9OhRGkGbIFT5ouTaZwjQPLdM+O2tv1Y7tuSNfyc3ZhrURFlK71o0nTczXpYQ3ZXM4T23dH2S7XFZ77grCjqptNhGv/MQVzmjLTvRJQJmTgine0llD9jZSE9DnLSMOJarGKWj0RfC1DEIpM80vfkcEMCLC/FLkmsKPCplkbUfh25gZAFEZWlbouI/B3WkeDvHbZpRqPH3w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Thu, Dec 18, 2025 at 05:57:46PM -0800, Roman Gushchin wrote:
>> To effectively operate with memory cgroups in BPF there is a need
>> to convert css pointers to memcg pointers. A simple container_of
>> cast which is used in the kernel code can't be used in BPF because
>> from the verifier's point of view that's a out-of-bounds memory access.
>> 
>> Introduce helper get/put kfuncs which can be used to get
>> a refcounted memcg pointer from the css pointer:
>>   - bpf_get_mem_cgroup,
>>   - bpf_put_mem_cgroup.
>> 
>> bpf_get_mem_cgroup() can take both memcg's css and the corresponding
>> cgroup's "self" css. It allows it to be used with the existing cgroup
>> iterator which iterates over cgroup tree, not memcg tree.
>> 
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  mm/Makefile         |  3 ++
>>  mm/bpf_memcontrol.c | 88 +++++++++++++++++++++++++++++++++++++++++++++
>
> Let's add this file to MAINTAINERS file.

Will do. I planned to create a new entry for mm-related bpf files
as part of the bpf oom patchset.

>
>>  2 files changed, 91 insertions(+)
>>  create mode 100644 mm/bpf_memcontrol.c
>> 
>> diff --git a/mm/Makefile b/mm/Makefile
>> index 9175f8cc6565..79c39a98ff83 100644
>> --- a/mm/Makefile
>> +++ b/mm/Makefile
>> @@ -106,6 +106,9 @@ obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
>>  ifdef CONFIG_SWAP
>>  obj-$(CONFIG_MEMCG) += swap_cgroup.o
>>  endif
>> +ifdef CONFIG_BPF_SYSCALL
>> +obj-$(CONFIG_MEMCG) += bpf_memcontrol.o
>> +endif
>>  obj-$(CONFIG_CGROUP_HUGETLB) += hugetlb_cgroup.o
>>  obj-$(CONFIG_GUP_TEST) += gup_test.o
>>  obj-$(CONFIG_DMAPOOL_TEST) += dmapool_test.o
>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> new file mode 100644
>> index 000000000000..8aa842b56817
>> --- /dev/null
>> +++ b/mm/bpf_memcontrol.c
>> @@ -0,0 +1,88 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +/*
>> + * Memory Controller-related BPF kfuncs and auxiliary code
>> + *
>> + * Author: Roman Gushchin <roman.gushchin@linux.dev>
>> + */
>> +
>> +#include <linux/memcontrol.h>
>> +#include <linux/bpf.h>
>> +
>> +__bpf_kfunc_start_defs();
>> +
>> +/**
>> + * bpf_get_mem_cgroup - Get a reference to a memory cgroup
>> + * @css: pointer to the css structure
>> + *
>> + * Returns a pointer to a mem_cgroup structure after bumping
>> + * the corresponding css's reference counter.
>> + *
>> + * It's fine to pass a css which belongs to any cgroup controller,
>> + * e.g. unified hierarchy's main css.
>> + *
>> + * Implements KF_ACQUIRE semantics.
>> + */
>> +__bpf_kfunc struct mem_cgroup *
>> +bpf_get_mem_cgroup(struct cgroup_subsys_state *css)
>> +{
>> +	struct mem_cgroup *memcg = NULL;
>> +	bool rcu_unlock = false;
>> +
>> +	if (!root_mem_cgroup)
>> +		return NULL;
>
> Should we also handle mem_cgroup_disabled() here?

Good point, will add in v2. Same with bpf_get_root_mem_cgroup() patch.

>
>> +
>> +	if (root_mem_cgroup->css.ss != css->ss) {
>> +		struct cgroup *cgroup = css->cgroup;
>> +		int ssid = root_mem_cgroup->css.ss->id;
>> +
>> +		rcu_read_lock();
>> +		rcu_unlock = true;
>> +		css = rcu_dereference_raw(cgroup->subsys[ssid]);
>> +	}
>> +
>> +	if (css && css_tryget(css))
>> +		memcg = container_of(css, struct mem_cgroup, css);
>> +
>> +	if (rcu_unlock)
>> +		rcu_read_unlock();
>
> Any reason to handle rcu lock like this? Why not just take the rcu read
> lock irrespective? It is cheap.

Idk, it's cheap but not entirely free and I think the code is still
perfectly readable.

>
>> +
>> +	return memcg;
>> +}
>> +
>> +/**
>> + * bpf_put_mem_cgroup - Put a reference to a memory cgroup
>> + * @memcg: memory cgroup to release
>> + *
>> + * Releases a previously acquired memcg reference.
>> + * Implements KF_RELEASE semantics.
>> + */
>> +__bpf_kfunc void bpf_put_mem_cgroup(struct mem_cgroup *memcg)
>> +{
>> +	css_put(&memcg->css);
>
> Should we NULL check memcg here? bpf_get_mem_cgroup() can return NULL.

No, the verifier ensures it's a valid memcg pointer. No need for an
additional check.

>
>> +}
>> +
>> +__bpf_kfunc_end_defs();
>> +
>> +BTF_KFUNCS_START(bpf_memcontrol_kfuncs)
>> +BTF_ID_FLAGS(func, bpf_get_mem_cgroup, KF_TRUSTED_ARGS | KF_ACQUIRE | KF_RET_NULL | KF_RCU)
>> +BTF_ID_FLAGS(func, bpf_put_mem_cgroup, KF_TRUSTED_ARGS | KF_RELEASE)
>
> Will the verifier enforce that bpf_put_mem_cgroup() can not be called
> with NULL?

Yep.

Thanks for the review!

