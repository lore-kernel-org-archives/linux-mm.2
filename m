Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71380C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:26:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57CDD6B0088; Thu, 24 Sep 2026 04:26:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52DF06B008A; Thu, 24 Sep 2026 04:26:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5546B0096; Thu, 24 Sep 2026 04:26:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1FB6C6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:26:42 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8578DC02A2
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:26:41 +0000 (UTC)
X-FDA: 85247974602.14.E9B9F2D
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D708A0002
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:26:39 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VIe9dXnH;
	spf=pass (imf15.hostedemail.com: domain of edumazet@google.com designates 74.125.230.235 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790238399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Djx86NYnyz/9RFz/5fi7+M66lo0Fi/FSUEqHr4nGVIo=;
	b=HD5K/NsK2qith/7kq7Fp+hZW7c/BU0FngJCjHNlwMzFFK1lbL+bo2cRvBIu3gcPABL5p6G
	Ixw/eyjdec5F6s4G7ZQ6KXfn9i7TWa74LSSu0N+6v48iyL4TN+tqEtMewEYuZclpglerlK
	NRhXHx/g3RQAX2HqjYyR/4IeJ1LA8BQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790238399;
	b=O42xiYfqSULT+1WAhFuXWE+Btu4yscGqvlC0QFCcciXAmFUZQ6oYJc+LP/3R9priV/S5A5
	v+kJZJTAJGUgYL2KkTcIv2LC+IWHZA7Wzjoo/H80/ZoLzs/gb+wejMz9Kbx0uPS4w6TcwW
	aGAaWHXFW2o53vdeKefCsXhMFtjzgOQ=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VIe9dXnH;
	spf=pass (imf15.hostedemail.com: domain of edumazet@google.com designates 74.125.230.235 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb767cc71so15441501cf.1
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 01:26:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790238399; cv=none;
        d=google.com; s=arc-20260327;
        b=M9u2Q/9UNKmNNWDXsHwVO3kQByNP12FSK/c9o2ttxyU4XCDwCvuBz/02Nu9u09XR1B
         Tex+xLudz21stjyVZ7M/qOjJjdc9ga7IniCHosHU3jFMzPGZPRPv5ArJu+q4FHdxzpoQ
         nkj+3Uad6XCKb6gbpcW+/rZtpthph8kIxl0X6SlNg78kkYjfHinyCGBN/KaaBEqGobV+
         +BReNsKCLwMqteIYyVEE1KB1SlEtQu7+AfisOYpahrCerOynuichib0ZGrrsbkYAo+iU
         g6SHaE0iHmPUmL21oOkO56KP0eWMKBWTolcOydDmoPd7YqFJTuP4OfY+TvTc5y8xIPWm
         9l4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Djx86NYnyz/9RFz/5fi7+M66lo0Fi/FSUEqHr4nGVIo=;
        fh=HXQPEBoEVe09iYjrT10/9bwNKjc2z/yLIuCkEEQmV54=;
        b=Z9RTDHCx/FBge/Jsuoq3+rPNiToXaik+eInB147BJMEefkpD0RgzFm/wpPQWnp3vl6
         lI22pUhgfYOxScbyBOPVkynRR+we5Or7C4B56ric8temanwufc35KT6351Ucd1B4sfTV
         LdHPdYf6xYTDKX09EAgS5JAA3vrybrfSmiczkwdx6crc57qgwgfppvqEfo3k86xvx5mE
         svah4QAPBvwwM3JFyBvU+4x3lgnnmonm2j4ls3caExDVc6i5epp1wl0V67H4JLW6kivg
         ImVoFnQTIRny6VDEpmIB/9PMOkWtM3nGtRvECqDa9tSOPecdEHsuwyeaaYOrWFRbBWW4
         R2XA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790238399; x=1790843199; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Djx86NYnyz/9RFz/5fi7+M66lo0Fi/FSUEqHr4nGVIo=;
        b=VIe9dXnHz6d+YtR3RDpAl67uUjo5VsQGSlPctXyP1KcIzdUxRgukuek0sTIinl+s3f
         h5rPv7gwwppoGTR2Gk+zBAxyvEDJpgSPdbUZMMrIBWCdi82FI1leZxMfsJ9+yJXxxaDo
         iQS6KBlvSkbQLg4XMPlNCQyCM6sqIWavrnaQvni6//J46EDICJ55Vxo6H/r/JO0min84
         nPxNAl282svxBzyo1SvRQHtTM31HM2Gbpc9ppeJZji256zGqgQC4bwAFd4j7SbDU1r9X
         XS/322Aak5IhLLuo7S+J3yGOKxUZASsF5KDQpBOmsbeg6Jb2G8Sw2gLIpvP2mB6lQu+d
         g8Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790238399; x=1790843199;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Djx86NYnyz/9RFz/5fi7+M66lo0Fi/FSUEqHr4nGVIo=;
        b=TmjpTBbM/b2jJXrRo0S4aQKB611YUkDSQRESxiEnP+VA6YsMUWLP713bLOkakwioZw
         zUCBj4/Iee93YkvXxSkt+jmEKo35l4gWrzxlJkQV/YcQfcNIIzRfvL287rrEE1Qju4s9
         cgAC/pd/yVQyK8Tj4TZs4az6OGfhNm50K7GlzqjOxSLG6UFBbfImO3eqA7sHQ7VQpHzG
         8jfpycs06w118yoGuHHPMMeUaMU81mQaTs5rMAKCuGcA1X7hF58oS8cRp8x4CLnHp7ec
         QCDxR2uU+CT36Jger7NYFyPlJzXHgAl+XoRkd6Mf6WcaWc/wOeVVr9zViRY7fPHIVgq9
         GcQQ==
X-Forwarded-Encrypted: i=1; AKwUvBxSQk4eILSZOIeA3kYoFJMU52CpJmkGY0I2WITcnqIKDnCeZ/KPxZ5Sv0GX7vF0IIJC+dZJmAhdtA==@kvack.org
X-Gm-Message-State: AFuF++lA2WPrS6ZYaEjRhZ2ql5JUA9Ot2RIUakrDq0kWWTZ8dKp+3rV6
	QoMukyLXK67/HWjZWXDlNaZGlPMLwPcTArzvQX7LkEXNObgArxCeO2+4qPhjcybHZTa4bnVSHsp
	cj7LIzWw2bDxcQ2L6LQAS3XVlBMYx5cYwYw8SHWSr
X-Gm-Gg: AYBFou3hYg63HC1+xxVipAxTWVNLIywlyK7vy1uQPbwf3fDB2OJyy3H2uuE09YBauzY
	2L2rEkj64t8GELxQNMUyjojeqn+juPRMVhiVmysHqhL6OvYazG+L7BrFlIE6XMYnJUe22LuNTpF
	N5n5tk1zZtBlRM0iIoDFslI1eJvIZbjWLA2vWDWIs6KCCU0bV4fKwVkYYmb8qfvRreGRb9APKEB
	fdXZfI1GMnYaJbqQaVatW4iQlktayfWgpK/oPeP4B8Y1kV0pzFTckR6TxcEaqGFA4X9FCWFPaf4
	0o/howT/lAuArxrwwui2XwDP9sh253GRtBllaye2eubo97Fn/9h0ma4yMb80OeJesVCqHinUEyS
	RgZsLpA3GkMemLlQRp+IkZsHjQ/205JgJWzouo3eHlRUPtjjqFKM+THdYEnmBfyopJi0L
X-Received: by 2002:a05:622a:4185:b0:532:d0ab:f3cb with SMTP id
 d75a77b69052e-532feb52734mr11578341cf.59.1790238398107; Thu, 24 Sep 2026
 01:26:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260924080219.1036588-1-caixinchen1@huawei.com>
In-Reply-To: <20260924080219.1036588-1-caixinchen1@huawei.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 24 Sep 2026 10:26:25 +0200
X-Gm-Features: AclHuK9XSbyZhfSiccnO7XKdYo-g6nGD7WSG7r9j6ZGeEHZyUxcT2PFsdbnfwn4
Message-ID: <CANn89iJVGmYwQerOixGurH6vw-GtvSAQq6u6zSNZoyZrcEx6Jw@mail.gmail.com>
Subject: Re: [PATCH RFC -next 0/5] net: charge socket memory budget to memcg upfront
To: Cai Xinchen <caixinchen1@huawei.com>
Cc: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net, 
	skhan@linuxfoundation.org, rdunlap@infradead.org, kuniyu@google.com, 
	pabeni@redhat.com, willemb@google.com, davem@davemloft.net, kuba@kernel.org, 
	horms@kernel.org, ncardwell@google.com, matttbe@kernel.org, 
	martineau@kernel.org, geliang@kernel.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, lujialin4@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 77rar6iw6k14txrh67ncyq34a3yikygt
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9D708A0002
X-HE-Tag: 1790238399-450117
X-HE-Meta: U2FsdGVkX191uU7QTcIJmIatRxRQP89FfQqUj+UYjUU30m0e7ZVqDSAviCMYgK6HzT7yIy6lZLuQc8csACKVsn4sQLJNsYvN/7A0KqaTeN5KJFp0Zkr1N9bW2rrrQQnn9pWhW0lX1g7H3qMnCgTpb+k4wV4//BAp4Zzjy20yTJBEFkQnlh2oELZBoaZ8bqMfe/xjSibpp+2lQ1FeJJmd1iM6Co4CXlUeKy+CHD8z0gWmK1JeItkh85hmq55ppkv8K7d4rms4FZMCJUsRANVh2JAHPuDhZbx3mzhtqXsfZ4OIQu4TpqHfkfKNs+ujQE2fGf/jOFv5tBLTfEkwaGGp/8n6eng4UAuhHUci7Cr0YNliFAzt2ImnfsLpytHf/BppQiato72EBiOLH7Eqn3u9C5hXOzVStxrdW4XwM0GVhk5nx5eejX2+Q7Iwdnc4p6ZEZO6HjcXVmxLJI9ItBIK9Xs4CuNTtfUViZcVzlFjjMIfVt/ycrtowp50SvC6NeQeeH2iAuF2cPXkgjhAiW7L5mgG545s51v4l1H13ara4c/uvdoUUtmirupuoRi0GBSn6s4h2ILgXodT0TSP3/+8Opm2wwuBX9wk1Sleot0QVkZIyrlE/3pGuMsPsVzRzhOwHeZwBKlXpoHm3sdtF3tjGxBjuxDwl9SfSjqqwGNBDZzPGJvofTun9B6ktxmRhJOTv3CGx0xjwKshPyPQ5yEeyjGN9V9gQH2m3P7Ka8OcwneQmvUQ8jWU7v4yJu51cEnl76yye7l30PbmoAKylgHAnlqYOnVZBT7iWYRufsTinv4WXC3za+Kq/VOCRzXYCV8xzxoCEWLD4WhsvexYdIC+/KRDkCfmEbtqCsPJRITU1x/1a8LQkZ0LH7PsfRxJhSGabxMMBHoDfcyz2jLigBtnsIGMLsTi6BXqkb25SvQP980iRPda92R4QpLDrxnY1DlHwAlZPt8TWy+7AMZHlcb+
 xwS21o+N
 bTZs+X5HMlITnwneviW6DDlSpmLL/s2b7Q8Pzwk5OCl2aenoP1t+viJrvLVeqVp2QhnfbMSTL2UB8bd5onimZNHu268urB5ZUQh6Swaf6cYk1z9WEKAByFF6XgIJ0jXTvpiZM1fnz8W1MdJ31BfYamah3wQDvH1+wr4HdaYaKM+uFd15EJ1yEOiQZShB7+JQI+hma7RvRkG6chWchG8Dahw1B4Dxz6YFae9/1NnZXrpeJpTOP7Y23FdFwoFO4U/dPguyJtaGawa/UyHY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 9:36=E2=80=AFAM Cai Xinchen <caixinchen1@huawei.com=
> wrote:
>
> The memcg socket accounting currently charges pages to the memory
> cgroup per grant (__sk_mem_schedule() publishing forward allocation)
> and refunds them later from skb destructors.  The refund side folds
> per-skb "was this charged" snapshots back into the socket balance
> under concurrent lockless RMW, and races there can drive the memcg
> socket balance negative, ending with:
>
>     page_counter underflow
>     WARNING: ... mm/page_counter.c ... page_counter_cancel()
>
> This series flips the model: a socket is charged its whole memory
> budget (sk_sndbuf + sk_rcvbuf + sk_reserved_mem) to its memcg when the
> budget is established or grows, and refunded when the budget shrinks
> or the socket dies.  Grants and per-skb charge/uncharge stop touching
> the memcg entirely, so the racy refund pairing has no code left to go
> wrong: refunds can never exceed charges and the balance cannot
> underflow by construction.
>
> Tested: full arm64 build with 0 warnings; each intermediate state
> compiles (bisectable); tools/testing/selftests/cgroup builds clean.
> Runtime validation on the workload that used to trigger the underflow
> is pending.
>


Charging sk_sndbuf + sk_rcvbuf upfront to memory.current is not
viable, especially for servers handling large numbers of connections
(e.g. 1 million TCP sockets):

We specifically went in the exact opposite direction in commit
4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
to make sure idle sockets hold zero forward-allocated memory and
non-idle sockets hold less than one page (4 KB) in sk_forward_alloc.


1. Massive phantom memory charges and false OOMs:
   With default sysctl_tcp_wmem[1] (16 KB) and sysctl_tcp_rmem[1]
   (128 KB), 1 million completely idle TCP sockets immediately charge
   144 GB to the cgroup's memory.current while holding 0 bytes of
   actual packet buffers.
   Worse, once TCP autotuning grows sk_rcvbuf / sk_sndbuf during a
   short burst (up to tcp_rmem[2] =3D 6 MB and tcp_wmem[2] =3D 4 MB by
   default), TCP does not shrink sk_rcvbuf or sk_sndbuf when the queues
   drain and the connection becomes idle again. 1 million long-lived,
   mostly-idle connections would permanently pin hundreds of GBs (up to
   several TBs) of non-existent memory in memory.current, forcing the
   memcg into constant reclaim thrashing of real page cache/anon pages
   and triggering premature memcg OOM kills.

2. Overcommitted caps vs. physical reservations:
   sk_sndbuf and sk_rcvbuf are per-socket upper bounds that are heavily
   overcommitted across sockets, not reservations (unlike SO_RESERVE_MEM).
   Comparing this to vm_committed_as is flawed: vm_committed_as tracks
   virtual address space overcommit globally and is never charged to
   memcg's memory.current for the exact same reason.

3. Broken memcg limit enforcement (memory.max bypass):
   __sk_mem_raise_allocated() drops mem_cgroup_sk_charge() completely,
   while sk_memcg_budget_sync() ignores charge failures ("the new budget
   is used uncharged"). When a cgroup reaches memory.max,
   sk_memcg_budget_sync() fails in sock_init_data_uid(), tcp_init_sock(),
   setsockopt(SO_SNDBUF/SO_RCVBUF), or autotuning, yet sk_sndbuf and
   sk_rcvbuf are still raised. Subsequent skb allocations in
   __sk_mem_schedule() will then allocate real physical memory without
   charging the memcg at all.

4. Unnecessary struct sock bloat and hot-path overhead:
   - Adds 8 bytes (sk_memcg_budget + sk_memcg_budget_lock) to struct sock
     (even when !CONFIG_MEMCG).
   - Acquires spin_lock_bh(&sk->sk_memcg_budget_lock) inside
     sk_mem_reclaim().
   - Every TCP socket creation charges rmem_default + wmem_default
     (416 KB) in sock_init_data_uid() and immediately uncharges 272 KB
     in tcp_init_sock().

If you are hitting a page_counter underflow race in socket memcg
accounting, please share the exact race / stack trace and fix the
underlying accounting bug rather than charging uncommitted buffer limits.

