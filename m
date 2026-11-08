Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 204E0606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GCRNIukj
Received: by kanga.kvack.org (Postfix)
	id 3EB9E6B05B1; Sun,  8 Nov 2026 04:14:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39CC06B05B3; Sun,  8 Nov 2026 04:14:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B28F6B05B4; Sun,  8 Nov 2026 04:14:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 00C986B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:14:58 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 97306A8055
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:14:58 +0000 (UTC)
X-FDA: 85411392276.23.D886AAE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B858A40006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:14:56 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCRNIukj;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794129296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCD81M4wkhyRvUZmOtk/s217PTiFdBqN/DyRmNpi43c=;
	b=2mtLvAxDyBWeyRMSXzw5kKc9dFJ7LBE+GfahDK0eWw/ZeKLrf9SWt0dZDI1bC/NI1/VtoE
	Bby0Bq8JqlBrMuyBH7Ijr+jZLGUTOdFh19yqYppD47SuKQRWJwmQ/MQ193N/VfSQInp8IA
	q+j7lX71y89ZkTo1G33ELnakn/rmLKU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCRNIukj;
	spf=pass (imf17.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794129296;
	b=v2qAneUkpwcnb9hUINisRvx+Z7nl8da/yJRwiX9MbYWgcQrI1yqM897cY1dg23A6d6+Qtx
	rynGWQrne9VP7jWmWrSZF4BJLu3Kv7cDyqiFzpSXC96c4r3P3KI01SMtR7ASzUhQ+X1OYW
	OpFwd3wUZECcc2CGXWYmDasGkfibYKM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F8186156B
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:14:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE821F008BF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794129295;
	bh=rCD81M4wkhyRvUZmOtk/s217PTiFdBqN/DyRmNpi43c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GCRNIukjmbxRSLroBYrglpNYxblFA6Gm6kPuw6XxKppjCHT6ua56dVtURYxrJ64+Z
	 vNrl1SHly+bjqYw6WBgS5qnvNzvSdgeoWr+I1PUjwO3RNjEUMRiF5I0HU1tlTsgLUG
	 3qRxFC0rcHjMY8+dmomrgwfJKp9GyRkQKlaXXYE9jsWnzjr/dWW3dn+YpDGSmEv1V2
	 RjxyeegG4kIIROaEn71Tk4bMDCBb1oyi6PdbmcZJP8pzv1t9SFTj7QnIUM01nWXOmK
	 YL0AnTq+NTf+22Ph0e6lDi1JWxOjHJzVaE+B2jl1/I8R1nIsqBw2EdbJtn6p0XPh6u
	 DtMCpfAgutmIw==
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5365f9a04c5so5500121cf.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 01:14:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErE6H7pEWvF468A8Q9MWY5ONkTsYZ035k/5pRiCi6eTcUU/9mqMmdMaJ9bHUg8yr6w92XRSNGLj3mQ==@kvack.org
X-Gm-Message-State: APuU4Z9Rx9hUBlcg8Dm9ZwMzGkilvCzh4M/A+ho5IMD5pkMoNyYaUnv5
	w0Mxl3iLLm0EjI8IMSSqsyCzzBAG3NlKH8xlkHW1cEvijHZT+0iT7hL/PFkH7IUYXAKpCSz5Mlx
	8c+Gbl66V8OrLdDgrj++g3ArD7ADJ+ZQ=
X-Received: by 2002:a05:620a:6190:b0:943:f3d6:8e89 with SMTP id
 af79cd13be357-947841f78aamr130349685a.28.1794129295069; Sun, 08 Nov 2026
 01:14:55 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105132220.2233677-1-ridong.chen@linux.dev> <20261105132220.2233677-4-ridong.chen@linux.dev>
In-Reply-To: <20261105132220.2233677-4-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 8 Nov 2026 17:14:43 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zLN1gXtDhhe1cvmerjOS=SAm1v2nnQm8u9ha9JADN+1A@mail.gmail.com>
X-Gm-Features: AclHuK-oMFADk2jaOD6cOrE84kP64sd4nEZWj1lhtonW45d2nczzkSkiLcwy8As
Message-ID: <CAGsJ_4zLN1gXtDhhe1cvmerjOS=SAm1v2nnQm8u9ha9JADN+1A@mail.gmail.com>
Subject: Re: [RFC PATCH 3/3] mm/mglru: move lrugen atomic stats off the
 read-mostly lines
To: Ridong Chen <ridong.chen@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Joanne Koong <joannelkoong@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: c34jdnotfsgqxo1wypzqrtfizzdh8beq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B858A40006
X-HE-Tag: 1794129296-548481
X-HE-Meta: U2FsdGVkX1/XyuHmSwO3qWgGe/Gntt3T2zajX+LarzVDwkjqyLR4ihw4zlamzjvC5TDF0KOf7KO3KJ1KK8sDlEIeL79CoC0Fal7M53+HV9eNL1j1+/DdQESpSxTyd5p2Y1scmsMFop64xCZvNL/BnznigXBsx6dfkgnGNbIb2WtiBo33MjZ5mh76kZWhS3vYv3x0sc5fWgD69jLUXbne7zL0HzU5Fqw2l3Y61uXkAklJHoBE4NKZiJLDIOBtevvIq08/wyH7L1Lj2T+49DhtpLgmqGoRQfynm+9kMNO4S8fcSIk+omyX3X4eKb9MmOhEc8onrZiOut9Lqql+ZlsZAQC0f7AnBMVWjXRmO2WZBG0F/8YhNBmw7xdsUu1xM4wqM/VqILIambcFoPI2Q9V+14gv8Ifv7m/GPs9U38puiykLv2VpFkEYww+aL08Gv963cAIJ8W6QqapJdlMPsJ0G6TpvMdv58qnaft3/rz1ldu+cwaBn0npENl9QLf5F0MdehMqTRqT4JMagZRt2Qhh46l4C1MDYaPZTG0NXMUSPTOZEGoOoo8iTBhht4g0zR4UypnXy/MnhpueTLlkIPdKciX8boUe5IsVqD7YBQgNy4pPd9FteHzgzb3GFAfCgexkralXUUP39rWhTr8NAYLOrU9PbTR4mqrV7Jo/7we1sQDYpDf+uYiQ0qgj4vmkPOwAp3CFThx0O7nGa+uoCp8nhoI2KOnumC2bmJ+xMYMTX9GOxBo6q5sXRoyvfPsrvLY1qszAEDI2ggKK8j5Wa27s6QpSIT8eOrulNCQnFWfOofdNKg7PQwvlPGTWpVf0ThJjI5dlWSQIXsBDAU8x/eztOw4vAbAMV/mEDp/mMG/lk82IsZYLIhGNNyfSjHiYs6LRkIKE/HoPKZnwf2J32IqHZZfENGLgwHJ8XAm18U+pvTehuGTrxhl3tW2vozyU1GB9BWjz6fEpX+Pbi7Iu8Ioi
 Qqq+47RN
 5i0G8ni9NNFccDa8DQsL21PFnZHwTyF8BmKBBsOkt8Rk1yW1Gh3uZeTq4Wz6r9taHRQoKQ709zZf5XwU5t91WxmLjm+g4DV+eu6bD+oAy/fp8CjIFcTKDOiTwVas/8cHQqr0PLtuafRcyVYcAb8Y7twkOEkOQFSgAild6izu1qnZ+XwVidx2WDJ/AwzP66xwqepbeAIOAX5ilxvuRo8bpb5InJfcvbR839wkTCKCN+2bPCSaFtJq44modo6pjy8kYDuyLUOTDcMOifcTHpQ4I2ZJr/h0745UirzVfussxI+Vs+NQ6GXFRrBnEGZKPJKFlZEryvXFrIj4FIVbPLn71BUaOOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 9:23=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev> =
wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> lru_gen_eviction() and lru_gen_refault() update lrugen->evicted[] and
> lrugen->refaulted[] locklessly with atomic_long_add(). The arrays sit at
> the tail of struct lru_gen_folio, right before enabled/gen/seg/list:
> with LRU_GEN_STATS=3Dn the file type counters share a cacheline with them=
.

So basically, this is causing false sharing, right?

I'd prefer a text diagram showing how the false sharing
occurs, specifically how freq read and freq write end up
in the same cacheline.

This will help clarify why rearranging the struct is the
right approach and how to rearrange it properly.

>
> Those fields are read far more often than they are written:
> lru_gen_add_folio() reads ->enabled on every LRU add, and shrink_many()
> walks ->list and reads ->gen/->seg under RCU. With frequent file refaults
> from several CPUs, every refault invalidates that line on the CPUs doing
> LRU adds.
>
> Move enabled/gen/seg/list next to max_seq/min_seq/timestamps, which are
> also mostly read, and put evicted[]/refaulted[] in their own cacheline
> group at the end of the struct. This grows struct lru_gen_folio from
> 1360 to 1408 bytes and struct mem_cgroup_per_node from 2176 to 2240

Why is the difference exactly 2240 - 2176 =3D 64 bytes,
which is one cacheline? I was expecting a value smaller
than one cacheline :-)

What I'm not convinced about is that nr_pages should be
updated even more frequently than evicted and refaulted.
Why aren't they causing a false sharing?

long nr_pages[MAX_NR_GENS][ANON_AND_FILE][MAX_NR_ZONES];

It would be better to have a text diagram showing the
potential false sharing, so we can consider the issue
more comprehensively.

> bytes on x86_64 (one more cacheline per memcg per node).
>
> Tested on an i7-13700HX (24 threads) with turbo disabled and the
> performance governor. 24 files of 128MiB on ext4 on brd, read with
> fio (psync, randread, bs=3D4k, fadvise_hint=3Drandom, buffered), all jobs
> in one memcg with memory.max=3D1G, so nearly every read refaults.
> IOPS, median of 5 runs:
>
>   jobs      base   patched
>      1    270537    274303   +1.4%  (sd 3.7%)
>      8   1461025   1466293   +0.4%
>     16   2455629   2508001   +2.1%
>     24   2707720   2823776   +4.3%
>
> A custom random pread() test of the same setup, with this patch alone
> against base over two boots of each kernel, shows +2.4% at 16 threads
> and +5.9% at 24 threads, and no change at 8 threads or fewer. With
> anonymous memory on zram, the refaults mostly hit the tier 0 counters
> on a different line, and there is no measurable change.
>
> The gain grows with the number of CPUs refaulting into the same lruvec
> and needs a fast backing store; with real IO it is likely to be lost in
> the noise. The patch is mostly meant to keep the lockless counters away
> from the read-mostly fields regardless of where they end up.
>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  include/linux/mmzone.h | 18 ++++++++++--------
>  1 file changed, 10 insertions(+), 8 deletions(-)
>

Thanks,
Barry

