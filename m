Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1B78C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 21:07:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4BA6B008C; Fri, 28 Aug 2026 17:07:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5F0B6B0092; Fri, 28 Aug 2026 17:07:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B262D6B0095; Fri, 28 Aug 2026 17:07:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 811156B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 17:07:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F5B412058E
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:07:13 +0000 (UTC)
X-FDA: 85151913546.09.5FE3243
Received: from mail-wm2-f10.google.com (mail-wm2-f10.google.com [74.125.225.138])
	by imf09.hostedemail.com (Postfix) with ESMTP id 346F614000C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 21:07:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=avVIugsp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787951231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s+xApWHFlcAD9ScbsbJspW/eUqW4O4eLPOKcYbniiu8=;
	b=QpPC2eFzHJjz27wShC8HiSulsUwXQIyV0dqxmxSrVl0XlgAdQbdOelKhHXlg8hAlcLt0aO
	Mh29i/L9Rve04W6jGxgG8nzAKyyfOkFuxdNX1F6taxTt/x8d1Rxkfn3CHgIp4hSl5MHs9M
	XaLHGd62Bratz69DYNrbsmXfy2RUckw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=avVIugsp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf09.hostedemail.com: domain of memxor@gmail.com designates 74.125.225.138 as permitted sender) smtp.mailfrom=memxor@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787951231;
	b=tK5xjCcS9P4nrw71xmVdDRZejd+v1xqH5sv2kdPyNzJQ6jjE+O34MmwvnJ3CsNw9aGAjoV
	TuMFt9sLXi05Th2heTrhCox0wXwwSWNn8FyryYTv8+TOXS3PaskYw8INj8A5snBGmIpZBZ
	gygLXr+73/CNDYHHLmv613poxadt7JA=
Received: by mail-wm2-f10.google.com with SMTP id 5b1f17b1804b1-49b90b66fd1so3961845e9.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 14:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787951230; x=1788556030; darn=kvack.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=s+xApWHFlcAD9ScbsbJspW/eUqW4O4eLPOKcYbniiu8=;
        b=avVIugspncTw5iM8dl4op0FnuFs7JHttzCA/qqghej8+wkdniLlTsnCZ5D253pM0Eq
         bvQrZK2+Pj0VmkVlUahl17fRhnyFLdZFCUBuvoICSsGYdv5ZMUn/DoPY98CTB+e8oG7q
         xPEssHT7pxahDlylxxm1SFJmk6TAuXPHa5IqPP5JU3o3FHJtIb6/LId2MgzEfVsK3//U
         K5nvASZFVVIQ+6NGzWqLpxoXvoW4NnKP1BBoydax+1JJbreWlYL9CFPHpF8lG551Ltdm
         VaxRSriQcVdt55gGIPiYGYCE61dAMLYA6RUlIp/1XoXDUmDWQ+7XqE+tsPVmKVqM2gC7
         yslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787951230; x=1788556030;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s+xApWHFlcAD9ScbsbJspW/eUqW4O4eLPOKcYbniiu8=;
        b=Z2PEqAWt+iI1bjIKL4R549WNocZUABigIQUiLF7EWw2Jf8SBUvrZh5568WjVwvf6mS
         mwiL0QjA1WCmyyp9VRfSrS01RhZ0tuXaXy8/avpwd5c8rUPpxBllPwLZhJ7NRxZHLoqy
         lMfZzM8V03SyLC5sxKEIu22m0bDtw6TxS4ptablHVbbMlR5nSyyq0E9bNnsB6EAMCvGO
         tJaWkcWBt9aePnc7STk8U5+be1MRaWd6r5cWxGyDRyeC7Rlqk5jPHRKUaVN3onXSI7iq
         10imwr+UK+NkC6KOyBTEbfKtxVSxRG7YEWIDihCEhefZNtZZVEZcCRFTcKPEIZ+8OSar
         mOGA==
X-Forwarded-Encrypted: i=1; AHgh+Rq6sRzhy8IXlswVepDRIxjLE1IrKzWDPt8J/zLwDqN67olSD8+PvM0uJCNOYAcoyEHxG2JHA1hImg==@kvack.org
X-Gm-Message-State: AFuF++n22cWVFGa0cgpM8+wVQ2Xyd5r1aygpyeCLvgSGY1xN9m2770aM
	Lc8kjqHzOg4oPraobot4CCA3kuohTdKZaNE14s+t6/vBxG87FqFTtRcO
X-Gm-Gg: AR+sD120a2hlc5aSNvHTqZ9t+on+psqIV2bnSvysnPhnTUA1PArz2FrQDaVDZecyyro
	YDwFimtMRpt/yJG30+QMH/S8K8gjAVxMG7NscKthW8mLc+s/T4hXkJkQW5+n9dudKSJ0V1LVaqu
	OgqShEf/pJ6pXnWwVK7fz7ZdI23iTBHsfUhs86JI1PUtebAnGFi1Oc0Os63rNuxLIwe3J6c8WhO
	G8guDfQyOPAMXCNgeFMkcDfvYz1hCjeCCWAXHqUSy3IpNSTjDu60bOpWdGWV62rMG3XdStE2hJW
	0YJT33R6uBriuz8RJvRppl7SkyT9cNGAjxWGZbtLWEB9TWO1eu+DCoMZotTni8Z43weW0AArub6
	eaosQ8ddbUB/dVe1dcgZCQFJaVA4VWncXOBlpgpMPpKCmlZpeL6CpTFQeD0aRWj17XQcsXzL/es
	EMJIp0eke92GTRTEv7LaAvfbM/NXpKSNm3jR+NaMOwfCXPDzTDKD+NxzE3dQ3bd9EBpttajLrpe
	NZn5CceyxfOsplWNOD8mcuK/WFy0B+75RDgm2OJjxg9JZc3AFDQSSgOud58WOKXZM7p409Cy3fT
	b8wumbpSLYX9p+2d0ZxfxxTYFTqX4+WER41ECQ==
X-Received: by 2002:a05:600c:4585:b0:499:b402:6c0 with SMTP id 5b1f17b1804b1-49b91c265d7mr138746125e9.3.1787951229566;
        Fri, 28 Aug 2026 14:07:09 -0700 (PDT)
Received: from localhost (nat-icclus-192-26-29-3.epfl.ch. [192.26.29.3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b94dc0f57sm91854115e9.2.2026.08.28.14.07.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2026 14:07:09 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 28 Aug 2026 23:07:08 +0200
Message-Id: <DL0VTAZE10HC.3R4HIC6S0U3P1@gmail.com>
From: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Hui Zhu" <hui.zhu@linux.dev>
Cc: "Roman Gushchin" <roman.gushchin@linux.dev>, "JP Kobryn"
 <inwardvessel@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>,
 "Andrii Nakryiko" <andrii@kernel.org>, "Eduard Zingerman"
 <eddyz87@gmail.com>, "Ihor Solodrai" <ihor.solodrai@linux.dev>, "Alexei
 Starovoitov" <ast@kernel.org>, "Daniel Borkmann" <daniel@iogearbox.net>,
 "Martin KaFai Lau" <martin.lau@linux.dev>, "Song Liu" <song@kernel.org>,
 "Yonghong Song" <yonghong.song@linux.dev>, "Jiri Olsa" <jolsa@kernel.org>,
 "Emil Tsalapatis" <emil@etsalapatis.com>, "Shuah Khan" <shuah@kernel.org>,
 "Barry Song" <baohua@kernel.org>, "Geliang Tang" <geliang@kernel.org>,
 <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>,
 <linux-mm@kvack.org>, <linux-kselftest@vger.kernel.org>, "Hui Zhu"
 <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v5 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
X-Mailer: aerc 0.21.0
References: <cover.1787826402.git.zhuhui@kylinos.cn>
 <5dfdc7800469eac4e9a240f2422ba65d4ef4c4ba.1787826402.git.zhuhui@kylinos.cn>
 <apHk86Y8araBlXcq@linux.dev>
In-Reply-To: <apHk86Y8araBlXcq@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 346F614000C
X-Stat-Signature: reu8abaziohjqzxpq117xezpduksz7r8
X-Rspam-User: 
X-HE-Tag: 1787951231-205278
X-HE-Meta: U2FsdGVkX18QK7nKczwBrMY8+idTR+M3VJ1GQGOUGfk/gJ5F0h3NHf8Ke9vpMpP2ABPZ0/DVYNKp8GqTLr9G6q6vLSHGcsywsU13eTkkMaRWWK+wX4MK8ZpdMmufYB8IjJaBN4h8Qb/PRYor8LRWoQD4c6VE6xdZPDjcLJ98GTBm84xyI+7KXjeR8ijHrvaJcZ69cmmjXAEi1OYvQTBt5i6iAIFYFDLiWswcRM6AD11+6cDClvtbI+Vn4hUAQ+lH6xlNLkJ139X6e+RvPAqCPzA7eShO48MVgxd2VUK0uTIGrRysmubluBimwneG/EnQT0ggTy5mWCaKnJkRjI46XdfVHdmDya3KFDY9pz4yXYy+tM0GJ5iaxM19WxuNDwkY3fgOCdCbKmXe/6ESXffQlCFG+UoM5DyrjGxuGYv8gUxd19Ar5AcluDg6jZ2eKF/nTyYkmJZwp0s3AohmYJOO++rTwzSaFUVsbtNnUhglLWGuYeu8bYgJePPjNF86eVQRTl/OcxkI3uTdxq33Dd9kvKATgqPQL7FxVxaEuSVnCkMatEhvP+v3zpNNSpnybZMDnAfSfLSQ/Dyu7E+tJc4DuYkG68gCZRK79tWkd2I87Cq9UZsE4R0pFChe7KMgfitGUuJEf1t2QtdlcefAqaW7weSG9oiui+3wD216oSgGEETFcSW5A/bioGTAti4S82vrH/vqogFmdSRsS5r8eM36+D43fqcvPp67LXGPhFo1OKYw6GcCFXVCESWYDPZrfSePEqQTj0KfeYS2Ipz0wDmjVIR6sfqcFgZW+p1oeSDSHthpybGCC5mCGWSE0kWsatgsEThrkb1M80PuUsAzRZRJw0yeTJJDnoyLzmTDLIr5sBEYu9jxET6cCQ7Ib9aHnu/szgwhTywDXBcIqqHToC8TQjRm2y3JG2KKOYKgY6Rnk6tj147QtPbravYBDymChCB0Rb4Nt85AQNmYJ3spOk0
 +ny3Ztnb
 l2ujuy0AwTCIBmJYrryOCKiwip3NmHYhl2xXYRi/dEH/ChD7dU/zqpaFbCGQmTEk7/8vGlSshFubkRMnqsid/o5isJDZedLOgPBU+/D9G+IKaPRB12Pqhgbiwmyca/JFp83VX1f3u3UN1prSEwy5Ffum5ANWhqEDcqDr/WklIlyILqtuw9QpCezElkWY4pElTxIzAd6hJNvz9vTHty8CRMIK+nwR3Lf3AZ1wV1zO7LlfDwoMa8wohnwv/evCmz1AzdTlWrn8GKklzZj0ZexUn5aghaa19bEQqngFiINX/eLhdxG61KmpkgD+DGlrgbCr5OL3VEDrSzvVRNb365jf2HhDpywCuRgZkRYPBuc9V6NtozqHeoBmkPeNP85MoZl4ErUnnIG7vBX6csNekR6f62pUmq2h6wv6BTrnOA2XnBrckvCpm0JmlHuOMbX5dNh0/Pm6sDbRVAqr19qxFjxg7Z1BXxAUlongsOoVUlJO0IzGb9eRGtQjqx6nfsDHDKKlxAOpZNTLQ04tzZiE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Aug 28, 2026 at 9:53 PM CEST, Shakeel Butt wrote:
> On Thu, Aug 27, 2026 at 06:36:29PM +0800, Hui Zhu wrote:
>> From: Hui Zhu <zhuhui@kylinos.cn>
>>
>> Add bpf_proactive_reclaim(), a sleepable kfunc which performs one
>> proactive reclaim pass on a given memory cgroup, similar to a write
>> to memory.reclaim but without retrying until the target is reached.
>>
>> The kfunc refuses to reclaim if the calling task is already in a
>> reclaim context, as a nested reclaim would corrupt the outer reclaim
>> state.
>>
>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>> ---
>>  mm/bpf_memcontrol.c | 46 +++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 46 insertions(+)
>>
>> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
>> index 716df49d7647..297ff7f05042 100644
>> --- a/mm/bpf_memcontrol.c
>> +++ b/mm/bpf_memcontrol.c
>> @@ -6,6 +6,7 @@
>>   */
>>
>>  #include <linux/memcontrol.h>
>> +#include <linux/swap.h>
>>  #include <linux/bpf.h>
>>
>>  __bpf_kfunc_start_defs();
>> @@ -159,6 +160,49 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct =
mem_cgroup *memcg)
>>  	mem_cgroup_flush_stats(memcg);
>>  }
>>
>> +/*
>> + * Reclaim must not recurse: try_to_free_mem_cgroup_pages() overwrites
>> + * current->reclaim_state, so a nested call would corrupt the outer
>> + * reclaim state. Reclaim windows are marked with PF_MEMALLOC;
>> + * reclaim_state is also checked because it is installed slightly
>> + * before PF_MEMALLOC.
>> + */
>> +static bool bpf_in_reclaim_context(void)
>> +{
>> +	return (current->flags & PF_MEMALLOC) || current->reclaim_state;
>> +}
>> +
>> +/**
>> + * bpf_proactive_reclaim - proactively reclaim memory from a memory
>> + *                         cgroup
>> + * @memcg: the target memory cgroup to reclaim from
>> + * @size:  the amount of memory to reclaim, in bytes
>> + *
>> + * Trigger one proactive reclaim pass on @memcg, similar to a write to
>> + * memory.reclaim, but without retrying until @size is reached.
>> + * Must not be called with a filesystem lock held: the reclaim path
>> + * may deadlock on it via filesystem shrinkers.
>> + *
>> + * Return: The amount of memory reclaimed, in bytes, or 0 if @size is
>> + * smaller than a page or the task is already in a reclaim context.
>> + */
>> +__bpf_kfunc unsigned long bpf_proactive_reclaim(struct mem_cgroup *memc=
g,
>> +						unsigned long size)
>> +{
>> +	unsigned long nr_reclaimed;
>> +
>> +	if (size < PAGE_SIZE || unlikely(bpf_in_reclaim_context()))
>> +		return 0;
>
> I have been thinking about this more and more and after looking at the re=
asoning
> behind your check current->reclaim_state and also Sashiko's comment on NO=
IO/NOFS
> contexts, I am more convinced that this kfunc can not be a simple sleepab=
le
> function. We need more than that. We need clean process context as well s=
imilar
> to the userspace poking memory.reclaim. Something like kthread or workque=
ue.
>
> Kumar & Andrii, is there a way to restrict a kfunc to only be called from
> special BPF threads/workqueues? Is there some similar concept in BPF worl=
d?
>

Yeah, I think the concern is valid. E.g. inode_rmdir() is sleepable but wil=
l be
problematic here, I think. My first instinct was if bpf_in_reclaim_context(=
) +
nofs/noio save-restore might provide enough protection to let it be callabl=
e
from generic sleepable contexts, but I guess that will disable invocation o=
f
filesystem shrinkers unconditionally.

So my suggestion would be to fix the context to BPF_PROG_TYPE_SYSCALL. Ther=
e, we
should be able to init and schedule timers which poll specific state and ar=
ms wq
execution etc. It then remains invocable from sleepable async contexts (wq,
task_work) or the syscall program, all of which should be ok. Once BPF kthr=
ead
lands we can let it be callable from those threads as well, but that is for
later.

> [...]

