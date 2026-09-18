Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF1CDC982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 19:45:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 835476B0088; Fri, 18 Sep 2026 15:45:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DFB36B008A; Fri, 18 Sep 2026 15:45:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CED66B008C; Fri, 18 Sep 2026 15:45:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6526B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:45:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FD60407D2
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 19:45:09 +0000 (UTC)
X-FDA: 85227911538.22.7F1E172
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf12.hostedemail.com (Postfix) with ESMTP id 552EB40008
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 19:45:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UpBHbZN/";
	spf=pass (imf12.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789760707;
	b=ulD+UeefVIJAS7rK+2au5J74DqYsDwdPxS5xyTUp74HOVat5b9uqpj9MxCQPw+HoeTDJW4
	fZw6Ay9HUAG190ZvcNHNMnszVIkJMIZQqURO4es9dPM1ouySzflJJ4pdVHagCloV/PD83F
	sA4m89o5N4GKaEDnonIuc+kVbVNBEQI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UpBHbZN/";
	spf=pass (imf12.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789760707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=szCxdCB52TPTOMoJOhzrKbvc6KVcFeMOqRe/OAFYPcE=;
	b=x+lauFZgkljN16eE/bV30EzLt1uLoJ/AIL25SfcmxiyR4D1XrhgVuPL8dVo1kZS0nUi7zL
	k1YoEsUEfn0dh4zF0v+sj2zJOp8HA0iJg1nCOoAWXGwcE2dp6SV40kO3XU+kWdNGgqcgKB
	A9Uu06F1yRPHaN0FhpFZvP/x9IAWIpI=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd88a115ebso10245515ad.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:45:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789760706; x=1790365506; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=szCxdCB52TPTOMoJOhzrKbvc6KVcFeMOqRe/OAFYPcE=;
        b=UpBHbZN/mVubq4xhd16tQet5i9cNnvnJaIqOYu9Kw1/NH0rK43XE7Q2OLalf7ljqXL
         ZsqcRfmQoLDa2tKWfSqA6ZGhkqRX57+BqwnfJdjNWVDxWmnRpH1fWsbp/qjD28GEpDW6
         Zec+i31mpQ0JcpfVuhHgTtw28mbq3X3PrPXeP7LzzACeQnLhkNeZroi767vdetiNse2F
         u1WFskH91a2I3+yAKw69qOF9pWoSJz0Rbk7LXbG99TtAAYSSQA1eCmFTc3TZAAa3HxmF
         1j5L4heUAs/uLnVohSpdlX1cjPxk9acgkkLNG4YhHZtsN/QN0QNpl83DINNI61g2MnQJ
         4IJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789760706; x=1790365506;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=szCxdCB52TPTOMoJOhzrKbvc6KVcFeMOqRe/OAFYPcE=;
        b=l9Nlyuxhb/eIUClrm/mMz81sc85Ywp5nsvzAPQhMOBYTv9wM9j12fAjOzyf6/h95e8
         qUt0JADToie6G3HaGrVQcu8n6TmZzS6WY5wUMiYfswdFT377CHC5HYiBecomKkiHRhto
         zkfx3JqMA+rGjuvn3LLgLaAWqMFTjQR7/LOYCF9AQFdcZ7AJd+hkdZouomYjD6Q5+8JP
         lMwI5Viv83ykVZ7LI1JTRguNf4tgJ+bqAjzRpKhYfvo8s5OGUuw96MqzqlRwVq4MC+EW
         xFfCLpf9slM8dwiy+bjUE8msRn/oULRRXyuh++MtEpxWFQflAPIdXI+6YQlXP7xfcH5k
         3phQ==
X-Forwarded-Encrypted: i=1; AKwUvByzxfQjYRFWTssRDPCuGCBTj+tGQ0QLsc5lBxeLMmA6I5jx5qgVOz8ORTT5UCUQAR+8zsh2iLczXQ==@kvack.org
X-Gm-Message-State: AFuF++lBApnBo1cvgbZnKVlq8TMujLOK3ln0ud6WJEnyaapORPG0eOmS
	96aIgC8alDuEKKU8PnjdD/+tG3jzkTqz0DsFcSGartDnqEMK0luA7xFF
X-Gm-Gg: AYBFou0vcId33H1I3ONeQ3RlH2Vc5u3JzKPHf6SxijONpzZMWy8ygyjTpy1IXpRM2aR
	ifKyP4Z3qIT5l0Qoz7H/QU15tQxGD7jWvXcgPNwDUq2BMLoWo3hBYdoK+uBZ4TjJtyp9t4czPxj
	abd8R/5RcfxvnMSy62+t6TrEBm8OMrUwlSvYm41Tg30z/qYKiNqZE9DTP3nfOS6TKotA5rT1iVu
	EbEorjwTEGqEhiDig1rIEZmc4+1cyTO6hxHTsvF+NQctDLQoCfaxYGVpZP63QZFRQCqDaCbh7zM
	1IMx/rIiiJjKMymOL7j1gaSSSHyBNjotGSrhLm1TFlJzFzt6RYsLCnAQZfsLw2khAA0QeDySP16
	2LdiBxqcE/k27gxKSWbJIOZ+qveKfiedeBBcsqWw7neGjwRtPJrgpvghTKXGDulMH3QfnvLe4Ij
	swqNqFUSMlIBKHqfZbffbTNLC0YjfvA5iqj3emrdcPNiO0sGo94JZfGy1gpkIEfoiroziI/cd1D
	FztW+I=
X-Received: by 2002:a17:902:fc4b:b0:2dd:ad74:ac2f with SMTP id d9443c01a7336-2ddb1ba7187mr75143905ad.24.1789760705947;
        Fri, 18 Sep 2026 12:45:05 -0700 (PDT)
Received: from [192.168.2.190] ([24.23.128.127])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33c331b0d6esm670462eec.27.2026.09.18.12.45.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 12:45:04 -0700 (PDT)
Message-ID: <b115ece2-33a1-412e-ac25-38f339a13599@gmail.com>
Date: Fri, 18 Sep 2026 12:45:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v12 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
To: Hui Zhu <hui.zhu@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>,
 Ihor Solodrai <ihor.solodrai@linux.dev>, Alexei Starovoitov
 <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>,
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, Shuah Khan <shuah@kernel.org>,
 David Hildenbrand <david@kernel.org>, Barry Song <baohua@kernel.org>,
 Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org,
 bpf@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
References: <cover.1789714023.git.zhuhui@kylinos.cn>
 <02f0a8dc45a840d7801ec17e0c1168f7dacf9b73.1789714023.git.zhuhui@kylinos.cn>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <02f0a8dc45a840d7801ec17e0c1168f7dacf9b73.1789714023.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 552EB40008
X-Stat-Signature: 1mzg7xpg6gdcb5yi9e3x4dqf3wgzs93u
X-HE-Tag: 1789760707-663887
X-HE-Meta: U2FsdGVkX18uZ7YPxYSrHaCP7PKDe6VtQt0j2NgX3C/xBpKZfvn/ti/kcl6cC3apnE0VH5nB5BoOs8KlqY+mYoh1UU0cMtXl1t9pkfeCt+GPgQiYDWBrPt+eLtmZ/g7i4V75uKXT/h/AyHsKodXmCJGycCN7O3Zm5VPq/LP7TS5TRZ5Lvu14RZYl8hToi2JTAmnOhwYEPfH4r7BCGQ5l3jQd7Q5ThZfTeneqgzotHdJZtwOk/9ZOmESwwiy9pA5xNSU3yUcpRxhbTtqjDmuRzZYjCXK6RqHN0hx9h3eN+/MY07yCDCrcIRAJtI/+svquY19Z4udBJhJGfCRzZaGlV+HZomNAuRWzuHv3qBI6t2FtRtNUwhgv7tE1yu1n5K8bxW8Mhzqrf1WRZpD9QOyysCzDX+wUCYCmQEhSOsULBdkW1yN5H32kP4wtG8qFZF5TjNft9166PQEg+c3KcRaIlmVFWAxcNyYczIoGckdPNREyNEezbxYiBnbeeFoCkycEEbZQUgN7kTdornJpnyxOMKLmrAfbukTpCvXybixvrQCILsS9QL+DE/YT/GfVgQEMaHqa7DFwqEhwqFnoyOYB6abTT5XsEeeE9negJ9icQ8fGzlE54x27rrM8u02D3PQewT5wUoYdR7RNUb5cwWoSmZ0IfIjPZJ2pkdedVTDcQH40RiOpj83Z4RWrUiFjLHd61D9tm1+yfxjZIK0mvuVk2NMy5n5bwEevw61E48nWG3r1/zaBhT1RAEVeiWbLz7tP6OG6gL+uLHjs+MDMZPrJVMdjKuW/oK0rXNR8eJnb+U3VsOXnFBE6eHBy0xaeR56ZmUUyWKGeV1T5dV1WTOTDaBXK/5vhwEKdmVOUb4JLkh423eJFSi8NnsG0iiIx0fDEXkm1zpZlEUxUneNJfxuMhsFxsQSyz+xPyb7MYAeUG98XkqSeHQBDtwz/PV27rgqeRPYMFmhpYI931u6hJIp
 EfpHPFt+
 VPuTn3AR63dwFA4y/AE7AsP+EyjTZPQkXT9DktsaVKXQ4SuXFwLYeb9tfuDl5RIlV4c9XbJQ9zHN7iXcyYIz0suC2OSFXPfZMKsOEaCt4vRpeTXldf3bEG17XvPcZqPS7QCPJNbXCDKZog8v6nf/sEsyx52yA6iv+3FXDg8rqdJLUG94A2TBWYDNd4AyCdpIDBEkVosBCOlnMeo/ElHRVFcbeM6EZRd0aGL8h9sUSr67MHY5ij0OwuLM1hBDKoEYtMB+R1R9A4V8NsLTIXmbajMlT+o6t1fHDxp/RqcCFV6Bj6ZMZp57oIego3M71YIsMK6wHIK412Vf+k1UtpC77Q4dtNdz3hIENN5MgMVdQnlAcFQZoxqGu17oK0wWEpuh3v7jH8V+c33eCnhqWfvq8fOzr7kyBPRcdmd27dV0ItpqdS1ri4MM8DXq7iVzcdAJ2HkEAe10okwhwApnTPfKtTFDDqKUvrFGYZYc4r90kV4q+W2Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 11:58 PM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> BPF programs can observe memory pressure on a cgroup, e.g. refault
> stats via bpf_mem_cgroup_page_state(), but cannot act on it:
> triggering reclaim requires writing to memory.reclaim, which BPF
> cannot do.
> 
> Add bpf_proactive_reclaim(), a sleepable kfunc performing one
> proactive reclaim pass on a memcg, like a write to memory.reclaim
> but without retrying until the target is reached, so that when and
> how hard to reclaim is BPF policy rather than hard-coded thresholds.
> The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
> as high_work_func() does for memory.high; reclaiming more is left to
> the program, which can call the kfunc once per bpf_wq callback and
> stop at any point. It is limited to BPF_PROG_TYPE_SYSCALL, because
> other sleepable programs may run with filesystem locks held, on
> which the reclaim path could deadlock via filesystem shrinkers.
> 
> Convert MIN_SWAPPINESS, MAX_SWAPPINESS and SWAPPINESS_ANON_ONLY from
> macros to an enum so that they are emitted into BTF and usable from
> BPF programs via vmlinux.h.
> 
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>   mm/bpf_memcontrol.c | 62 ++++++++++++++++++++++++++++++++++++++++++++-
>   mm/internal.h       | 10 +++++---
>   2 files changed, 67 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> index 716df49d7647..c5d7f29ade85 100644
> --- a/mm/bpf_memcontrol.c
> +++ b/mm/bpf_memcontrol.c
> @@ -8,6 +8,8 @@
>   #include <linux/memcontrol.h>
>   #include <linux/bpf.h>
>   
> +#include "internal.h"
> +
>   __bpf_kfunc_start_defs();
>   
>   /**
> @@ -159,6 +161,48 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
>   	mem_cgroup_flush_stats(memcg);
>   }
>   
> +/**
> + * bpf_proactive_reclaim - proactively reclaim memory from a memory cgroup
> + * @memcg: the target memory cgroup to reclaim from.
> + * @size: the amount of memory to reclaim, in bytes, clamped to
> + *        MEMCG_CHARGE_BATCH.
> + * @swappiness: the reclaim swappiness, in the range [MIN_SWAPPINESS,
> + *              SWAPPINESS_ANON_ONLY], or -1 to use the memcg's own
> + *              swappiness.

The ANON_ONLY enumerator shouldn't be included as part of the range. I
would change this to [MIN_SWAPPINESS, MAX_SWAPPINESS] and then specify
that ANON_ONLY is a special mode like -1 is.

> + *
> + * Performs one proactive reclaim pass on @memcg, like a write to
> + * memory.reclaim but without retrying until @size is reached. Call it
> + * repeatedly to reclaim more than one batch.
> + *
> + * Only available to BPF_PROG_TYPE_SYSCALL, because other sleepable programs
> + * may run with filesystem locks held, which the reclaim path can deadlock
> + * on via filesystem shrinkers.
> + *
> + * Return: The amount of memory reclaimed, in bytes, or a negative error.
> + */
> +__bpf_kfunc long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> +				       unsigned long size,
> +				       int swappiness)
> +{
> +	unsigned long nr_reclaimed;
> +	unsigned long nr_pages;
> +
> +	if (swappiness < -1 || swappiness > SWAPPINESS_ANON_ONLY)
> +		return -EINVAL;

Related to the previous comment, you treat the special values as part of
the range. It works currently, but creates a layout dependency on the
enum. I think it would be more future-proof if you did:

if (swappiness != -1 && swappiness != SWAPPINESS_ANON_ONLY) {
	if (swappiness < MIN_SWAPPINESS || swappiness > MAX_SWAPPINESS)
		return -EINVAL;
}

The previous comments I brought up are now resolved, so assuming you'll
make the changes above you can include:

Reviewed-by: JP Kobryn <jp.kobryn@linux.dev>

