Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0EEC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00CC6B00A3; Fri, 18 Sep 2026 16:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB17B6B00A6; Fri, 18 Sep 2026 16:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 979A36B00A7; Fri, 18 Sep 2026 16:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 70F7D6B00A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:15:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFEF4A07CF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:15:49 +0000 (UTC)
X-FDA: 85227988818.20.632CBE1
Received: from mta0.migadu.com (out-76.mta0.migadu.com [91.218.175.76])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8D9BD180002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:15:47 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EKgnW5eN;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.76 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xE4leVhtxdP6TGySEhzj2t6lgGhQK3Pjury5Vt+fwaI=;
	b=OQS9Jh1Z8YJ2Tmf2rSJYmHmwFL1kmGuBdCEdtCPUkF1vgXkFz3X3ZRneLa+xIgr1pPKFDS
	g0WAwdG9fFfgF2Pb+nTcaUujM8ZkiXlmd9WWKxK/kREFxsuqxDgq2Pd9e1Jfd5TnWi/v2h
	PlJyQCQi6yEmQwZz7RwQTZYKhGsoxuw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EKgnW5eN;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.76 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762548;
	b=8Fiv78b/1aL8MES+lq4X0/Li2T5HRpCjmbf02cuiNj6PRYgLcCmDzn9Bbgi8Y0zpKBI7SC
	s2hlGZ7YFijP/BGjaJUIxQG4Ne+KOryLShrduwSmPztQVzdPObYh55r2hZ13Wp8GijQzdU
	TsL7RVCq3AcAiaoTtQp1yryxD1Hemhg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iouTRwcP6p6sORyaAyVd4nF2CdJPsrPN00jaStu4b50=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789762545; v=1; x=1790367345;
 b=EKgnW5eNwYUSMYi5mLGwEpSgf1iuBPjL2JNsjN9V8Z4AWUyhTuyHTlqbrnI3o2JQb1SpB/ga
 voRD2QcxnU3iRxaoU298g2+1Rla74UTd64Py1s1csV2goaMYeprRBXa/r73SR9I4GwRda318+qT
 KEbVBbKAycznOlIdshhkj4S4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 67fa36d92599c8ae;
	Fri, 18 Sep 2026 20:15:36 +0000
X-Mizu-Trace-ID: 67fa36d92599c8ae
X-Migadu-Flow: FLOW_OUT
Date: Fri, 18 Sep 2026 13:15:35 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: Hui Zhu <hui.zhu@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>, 
	Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
	Shuah Khan <shuah@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Barry Song <baohua@kernel.org>, Geliang Tang <geliang@kernel.org>, linux-kernel@vger.kernel.org, 
	bpf@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH bpf-next v12 1/2] mm/bpf: Add bpf_proactive_reclaim kfunc
Message-ID: <aq2bo5Q-YUj7lkxn@linux.dev>
References: <cover.1789714023.git.zhuhui@kylinos.cn>
 <02f0a8dc45a840d7801ec17e0c1168f7dacf9b73.1789714023.git.zhuhui@kylinos.cn>
 <b115ece2-33a1-412e-ac25-38f339a13599@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b115ece2-33a1-412e-ac25-38f339a13599@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 1giah41ku63j34dwd7daww75y4dfqjn7
X-Rspamd-Queue-Id: 8D9BD180002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789762547-5265
X-HE-Meta: U2FsdGVkX18Esf2+tR9X6dPFcNJyKXjA8aLi8xV37LWUiL+fzlPAozQY2uXrA9S5O4gGiasw0X3kBdq83vrkRZSly6wkfOU+t5a5Qu5QaEiuNtmDCj5p/imcN46wG48dv7fbEA5AERo0ti7mprP3mBQJyoLZGwDfMcOScN+3Vw3/E8+Zhm2kcmFMVaBFFchkDOEm7dITRRZwzPpgKjZd83uselQKArM5x+c7zt4RbnbSZtBgjFP0OT4a0MvchWAqZ+Ou7vQoJ5wopuHUJpQwUZpNnL2Rpkh1lBZqjIcPpuV0NiJ1RPlT+2CkeMuN4/dX11GwpAF6z2r65Ymbz0gAAGIpNB0RNsyI8u9FM3eUifDcNvi39CUK6fzbhmNMwlOJN7f72r1epHDLZpZejM0V+Xmc+rUEs99kGPCSZOzZDJPe2onUNtoslNDccwyrW9oKafCuzxvxmyunVw2G8Dhezx/xD0a57j8/WPmi8wUNHxjZD6r6nEqf8PSRChanFzld1Z4oazvDa0t2Ai75skSttM2I8aT6rTWT+58Oc+qhV7hUIqwFFrHXDCKtumM2Zj6JhL4bXqbl8fUzRVfhWWvClmeZvpxKGZ7LAQK2n7VaeYhYh0yyWBoc6PI/mCm1VJyHIeLiSeN8lOWi6hsXQsEGVeP3/i0GrhkbXWIPCHMYr1aOa6Fm6QrU/WlfohS3eKqfZ0UzoHmy6/wakpKAAOQ/XzMMtPwEd781v5IzmLgSPyeJKHCaf0UpJa3q/lQZXkIDRGOLSX5Ht1E94kA8ynFNs/xvvNtX4QDOWW9NYVnntKlKMcUtF+TnJxfmZk3v++w3+eZhtKw3GNwW1SzgOBsvDsFz844T4mc8D51ZRCu19SxqbxNaChZTovPtq8o9CcuA7ryfK91S8JK8S/c5/Hgf9FGS8ix8y9FH1J1A68pz7c5xqqK4LWbZERuZnmqpt9etprbWVk34LRWtipRxJkD
 QYbxnQqn
 gHJnuasdlvw0rXu+GWAB+992yedPR8lTl04hOJOhAUcCYpdgIexx0NAouyU+wjhNfWsrlaMC6ZmRZjVXnFkRN9wESad43lB6AvxqZeXHZ2HZ6oQwyU/DjXevU/pw+EhyZvEjzqZO0JVhn2WqKbkv16NLpCBW4dKwgboLuR5y63gxCAtkxF7bBJcB46t8C+4WvKIq0GP9DP8s6Rc+7AqOF0AvAukqwGT/5nTk6CvmIlRFmkbGiv4dsgFgdVVTPHiBTAkmRnW710HU0qEyE7LPtKXQDRvtipkT7WhuOU8ZZg/LmTxvuVH/a/bpHzu1A0xhYX3FY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 12:45:01PM -0700, JP Kobryn wrote:
> On 9/17/26 11:58 PM, Hui Zhu wrote:
> > From: Hui Zhu <zhuhui@kylinos.cn>
> > 
> > BPF programs can observe memory pressure on a cgroup, e.g. refault
> > stats via bpf_mem_cgroup_page_state(), but cannot act on it:
> > triggering reclaim requires writing to memory.reclaim, which BPF
> > cannot do.
> > 
> > Add bpf_proactive_reclaim(), a sleepable kfunc performing one
> > proactive reclaim pass on a memcg, like a write to memory.reclaim
> > but without retrying until the target is reached, so that when and
> > how hard to reclaim is BPF policy rather than hard-coded thresholds.
> > The reclaim target of a single call is capped at MEMCG_CHARGE_BATCH,
> > as high_work_func() does for memory.high; reclaiming more is left to
> > the program, which can call the kfunc once per bpf_wq callback and
> > stop at any point. It is limited to BPF_PROG_TYPE_SYSCALL, because
> > other sleepable programs may run with filesystem locks held, on
> > which the reclaim path could deadlock via filesystem shrinkers.
> > 
> > Convert MIN_SWAPPINESS, MAX_SWAPPINESS and SWAPPINESS_ANON_ONLY from
> > macros to an enum so that they are emitted into BTF and usable from
> > BPF programs via vmlinux.h.
> > 
> > Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> > Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> > ---
> >   mm/bpf_memcontrol.c | 62 ++++++++++++++++++++++++++++++++++++++++++++-
> >   mm/internal.h       | 10 +++++---
> >   2 files changed, 67 insertions(+), 5 deletions(-)
> > 
> > diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> > index 716df49d7647..c5d7f29ade85 100644
> > --- a/mm/bpf_memcontrol.c
> > +++ b/mm/bpf_memcontrol.c
> > @@ -8,6 +8,8 @@
> >   #include <linux/memcontrol.h>
> >   #include <linux/bpf.h>
> > +#include "internal.h"
> > +
> >   __bpf_kfunc_start_defs();
> >   /**
> > @@ -159,6 +161,48 @@ __bpf_kfunc void bpf_mem_cgroup_flush_stats(struct mem_cgroup *memcg)
> >   	mem_cgroup_flush_stats(memcg);
> >   }
> > +/**
> > + * bpf_proactive_reclaim - proactively reclaim memory from a memory cgroup
> > + * @memcg: the target memory cgroup to reclaim from.
> > + * @size: the amount of memory to reclaim, in bytes, clamped to
> > + *        MEMCG_CHARGE_BATCH.
> > + * @swappiness: the reclaim swappiness, in the range [MIN_SWAPPINESS,
> > + *              SWAPPINESS_ANON_ONLY], or -1 to use the memcg's own
> > + *              swappiness.
> 
> The ANON_ONLY enumerator shouldn't be included as part of the range. I
> would change this to [MIN_SWAPPINESS, MAX_SWAPPINESS] and then specify
> that ANON_ONLY is a special mode like -1 is.
> 
> > + *
> > + * Performs one proactive reclaim pass on @memcg, like a write to
> > + * memory.reclaim but without retrying until @size is reached. Call it
> > + * repeatedly to reclaim more than one batch.
> > + *
> > + * Only available to BPF_PROG_TYPE_SYSCALL, because other sleepable programs
> > + * may run with filesystem locks held, which the reclaim path can deadlock
> > + * on via filesystem shrinkers.
> > + *
> > + * Return: The amount of memory reclaimed, in bytes, or a negative error.
> > + */
> > +__bpf_kfunc long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> > +				       unsigned long size,
> > +				       int swappiness)
> > +{
> > +	unsigned long nr_reclaimed;
> > +	unsigned long nr_pages;
> > +
> > +	if (swappiness < -1 || swappiness > SWAPPINESS_ANON_ONLY)
> > +		return -EINVAL;
> 
> Related to the previous comment, you treat the special values as part of
> the range. It works currently, but creates a layout dependency on the
> enum. I think it would be more future-proof if you did:
> 
> if (swappiness != -1 && swappiness != SWAPPINESS_ANON_ONLY) {
> 	if (swappiness < MIN_SWAPPINESS || swappiness > MAX_SWAPPINESS)
> 		return -EINVAL;
> }
> 
> The previous comments I brought up are now resolved, so assuming you'll
> make the changes above you can include:
> 
> Reviewed-by: JP Kobryn <jp.kobryn@linux.dev>

Hui, please make these changes and just send this patch in next version.

