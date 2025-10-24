Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A82E4CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:05:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EC298E009A; Fri, 24 Oct 2025 10:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09CB18E0042; Fri, 24 Oct 2025 10:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECD518E009A; Fri, 24 Oct 2025 10:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D6EA58E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:05:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA4C712A34E
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:05:49 +0000 (UTC)
X-FDA: 84033181218.15.52814B1
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6FC8520019
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:05:47 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=fnXo7b6r;
	spf=pass (imf03.hostedemail.com: domain of "prvs=63920b99c4=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=63920b99c4=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761314747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d+lSgdkA9+bEZAYGayqSUgiThyPvWrBH7x+H6ZQsxL8=;
	b=Fmrc88tEOniasQmFmEi7/NnzKdT94LrHM20vKZ0sb6ook324daCjSW8VfZpPcTuvMYK1ks
	kLK/fecvPImJRZkiWXw6BNACsWvMiYjfKZvwZO7Wk2QnywWyK8yL3FwScZw6usye6JVS8C
	TI6S55vBohAQmA6aUVDwN9r2IBg3lp0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=fnXo7b6r;
	spf=pass (imf03.hostedemail.com: domain of "prvs=63920b99c4=clm@meta.com" designates 67.231.145.42 as permitted sender) smtp.mailfrom="prvs=63920b99c4=clm@meta.com";
	dmarc=pass (policy=reject) header.from=meta.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761314747; a=rsa-sha256;
	cv=none;
	b=TNx3irtcVmSjPlgK4bI1In7FigbBueylDWXFbISpaJU2J0v2j2Vw42Lj5atMGbj7f7F7s0
	OxbJKSMUiAA7uPZ0zFMNf1UywO0ownVQOKu8o6NI0bPhIBLL9grIMkYuiWsdM2e8PEWJDd
	/ahN+hZjUHLF8Uxmt7vjCjNOFKwTsLw=
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
	by mx0a-00082601.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 59O2USQQ1836938;
	Fri, 24 Oct 2025 07:05:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=d+lSgdkA9+bEZAYGayqSUgiThyPvWrBH7x+H6ZQsxL8=; b=fnXo7b6rWJVD
	bMcf8mfLj4lFbsB8T8fVIJVThjcZ70GY0iSMWqfS+/Q2/0piWstJzxXWoE9MFBPI
	2NNDPbecaed1qI0kky0qRZNr+ZkfsHloHD5n1wEIH0kJNkhAlZs/I4OZE8oQrDGr
	S02s9fc+/6Im5sEoKhysYT01mBI4qnh9rqaUsopb91hClwLnpEYVuMIgZ2FAQs1R
	sfnifuxn8LpvBzSmi3SrEUf9fMb1On0ldS+gMGUuWW87PeCs9J6wPrHSw6YBps9O
	MjvEdvaAr4u0l2vN82Osd0DdDAa+4Z+lc0AelVEQaPVQklsZFmTGoVgBSPSdqRW/
	N7w7N/rMhw==
Received: from mail.thefacebook.com ([163.114.134.16])
	by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 4a00qr3619-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 24 Oct 2025 07:05:39 -0700 (PDT)
Received: from devbig091.ldc1.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 24 Oct 2025 14:05:37 +0000
From: Chris Mason <clm@meta.com>
To: Vlastimil Babka <vbabka@suse.cz>
CC: Chris Mason <clm@meta.com>, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@gentwo.org>,
        David Rientjes <rientjes@google.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
        "Liam R. Howlett"
	<Liam.Howlett@oracle.com>,
        Suren Baghdasaryan <surenb@google.com>,
        "Sebastian
 Andrzej Siewior" <bigeasy@linutronix.de>,
        Alexei Starovoitov
	<ast@kernel.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <linux-rt-devel@lists.linux.dev>,
        <bpf@vger.kernel.org>, <kasan-dev@googlegroups.com>
Subject: Re: [PATCH RFC 07/19] slab: make percpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
Date: Fri, 24 Oct 2025 07:04:12 -0700
Message-ID: <20251024140416.642903-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023-sheaves-for-all-v1-7-6ffa2c9941c0@suse.cz>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:208::7cb7]
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI0MDEyNSBTYWx0ZWRfX/YulqWc9km6x
 rZ9QcTf19ercfPCVy42mSwO7q320WyUffMX/ZOVV7/0+LFbBFHmAfk2Z1nHq59y7qfsbHdViGRD
 io4nb8k8yiW8czQRYEwRQEohNhFCUEl4NRmZCYsgFJZlRxj1PtPgWgZzuVIHIIhPct9t2Wfu13D
 SLHDI/8l3xJYV14IBIkFzMZH2jMjSo9AdnQtxANe+GN3UolHaVOk7d0MrciDj2ba98RBSEmnLzO
 kdTPYGW/hzVqoNvRfKQibEWBbPQz4XKL0KqpaA61zheqxCgwbjLC/NI+Q6G3Ayt2KkYvzXNpdE0
 FNU6tWhrKW6R4RJlXT9SFRQZnB8ZN5hzY5AQz5eKeJWqoWxcu69Fpr1LA7wONxXD7eMaFZm2vNM
 KjiYAhsQxFDrI5BZx4kLTH5W8/mBsA==
X-Authority-Analysis: v=2.4 cv=YfWwJgRf c=1 sm=1 tr=0 ts=68fb87b3 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=y43Pqs-daWJVC1BrHOAA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-GUID: ypt68hrsJxSCnWKUb2JArGmMBobBfU89
X-Proofpoint-ORIG-GUID: ypt68hrsJxSCnWKUb2JArGmMBobBfU89
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Rspamd-Queue-Id: 6FC8520019
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: mam8gyx1cjxiwhdw96mdwyjizb8dobcp
X-HE-Tag: 1761314747-847023
X-HE-Meta: U2FsdGVkX1/lPkEMtH9pd9ICrEmzywHMjuAvCqXI+HShLEkKbWN29PUSNsinVCGQQk3PfRuwQMePP8lL9qTvhuHOEDqeoDZ+FWMMdzqNSkkiTdlwpKyGG8HkD9eRGoqA60xaT3XEjy1J4e8//jiKnT4NvmRmX+bykxfRA/iwk+pFi4Q6lXojHwdHfcMtLtA9pIO1Jbm8t2XDGLOQgmfr5lW5UDvqETJQ2XkWyZwNl2aQQ4wgmMV50mW0C2hRpgDPw5DTX5T6D1UWUTaeE/OOsAcPqkymGjZbFm70NvLmlb96ZciCS+kmvJa/QU2MDzzcDnpkD69ziENgOU5TNE6UVwibR5Kjy/YXFz1kHTcV+Brsb94rQu7aoh9wZ9bN/Mh6/NNL+0OLN6WfSnlOT8P6j8qa+Q40588ACw6fiC9/OpqzcGLynKRQlW0QLYVs0lbpCyohJNbeup5Dm81ESEmXsl/GJVeHd11LFuOTo+eAPPk+GAfcErQtT0YfL0qlK6OOldMBfww7e4a4L2MuhF7iig0hciIQz4RIutIPc6D652Qx9KoofSdskJCzNRNz4S6DdrP0dwzL05LXwC6UfLO7s8q462zV74H5fwdCszyvS5Naqz4JuOKrwTqCLcC4wgfV/6lZzRwNvDNpJZf7u4f5+SUe/bl2/uatiSC9CYJpHXB3aUzwzjh4Edi/7xj7FsDrYnfLlJL73J5YLCbj3F+IkX6OHaT4VmWeutoDOWCQkO/UQ0ADC+iWdamVvCYQc/9rs3n9OD1akEcxNfCFlnl0xFU1n53NVgt/Bs+VQ2LDS38uSyiPJBz8v49j9cI5SMUgVuqZ9wISpaVZ8ZlrXhJ0F2g1iGEqMwmdsvCXv6DdoMg31NHIUgIh7rbOPrwv+5+ohC0A9RqpOWebQkDAaXkcVkO20ZJOfoFtoSK18aUHFcZGCzsBNeSR1OmA7SMH5itR9Zp+QmmqdLEC5Q7J6eG
 028nt0oV
 tflilHLNpqhNGrWykSK4JWl+uahYbMCeSp8OJJKD482lm5TG3sG9hTxN31okCvmp2X5UwohrcT2FcZkvQZxiZWZLR+4sn/o8lfo9JApJ0C6fgUmReOrtj13/Vt9ROuQVK71Lv+Uwigo8/vfvnqrUX03wpQsj9oPuKp29+I3ye4sePxHdtpagUphc5r+m1R4qMIFUWaRKlWS8a4hwCypqahYmhoO+PqWmuRyYG9qWXfzQrhUJXaK5EHnv4OexcWlGItnv3v1nM+w8ItRtik5/IUl7Q2X5IwuF3CS8T6uvFEx8mZqqYn+kwf1xO90J4dv60kYa2g1p5GkVwgJp2PwajYXHnbYj6ZROpSZ3nIi5nAMfeydqP+X3cU8VLDf9FqYVejzZrr8WD968Q+ph5t7DeqWqvLtPtrYdVcGVqck7VUgVASqY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025 15:52:29 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> Before we enable percpu sheaves for kmalloc caches, we need to make sure
> kmalloc_nolock() and kfree_nolock() will continue working properly and
> not spin when not allowed to.
> 
> Percpu sheaves themselves use local_trylock() so they are already
> compatible. We just need to be careful with the barn->lock spin_lock.
> Pass a new allow_spin parameter where necessary to use
> spin_trylock_irqsave().
> 
> In kmalloc_nolock_noprof() we can now attempt alloc_from_pcs() safely,
> for now it will always fail until we enable sheaves for kmalloc caches
> next. Similarly in kfree_nolock() we can attempt free_to_pcs().
>

Hi Vlastimil,

We're trying out the AI patch review automation on the BPF commits and it had
some questions about a few of these.  Since the goal is to actually test the
automation, I'm putting them in unedited, but I did try and make sure they
were valid before sending.

This one is a little verbose for s/NULL/ERR_PTR/ suggestions, but:

> diff --git a/mm/slub.c b/mm/slub.c
> index ecb10ed5acfe..5d0b2cf66520 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c

[ ... ]

> @@ -2990,7 +2998,8 @@ barn_replace_empty_sheaf(struct node_barn *barn, struct slab_sheaf *empty)
>   * barn. But if there are too many full sheaves, reject this with -E2BIG.
>   */
>  static struct slab_sheaf *
> -barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
> +barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full,
> +			bool allow_spin)
>  {
>  	struct slab_sheaf *empty;
>  	unsigned long flags;
> @@ -3001,7 +3010,10 @@ barn_replace_full_sheaf(struct node_barn *barn, struct slab_sheaf *full)
>  	if (!data_race(barn->nr_empty))
>  		return ERR_PTR(-ENOMEM);
>
> -	spin_lock_irqsave(&barn->lock, flags);
> +	if (likely(allow_spin))
> +		spin_lock_irqsave(&barn->lock, flags);
> +	else if (!spin_trylock_irqsave(&barn->lock, flags))
> +		return NULL;

barn_replace_full_sheaf() now returns NULL when the trylock fails, in
addition to its existing ERR_PTR(-ENOMEM) and ERR_PTR(-E2BIG) returns.

[ ... ]

> @@ -6047,7 +6070,8 @@ static void __pcs_install_empty_sheaf(struct kmem_cache *s,
>   * unlocked.
>   */
>  static struct slub_percpu_sheaves *
> -__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
> +__pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
> +			bool allow_spin)
>  {
>  	struct slab_sheaf *empty;
>  	struct node_barn *barn;
> @@ -6071,7 +6095,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>  	put_fail = false;
>
>  	if (!pcs->spare) {
> -		empty = barn_get_empty_sheaf(barn);
> +		empty = barn_get_empty_sheaf(barn, allow_spin);
>  		if (empty) {
>  			pcs->spare = pcs->main;
>  			pcs->main = empty;
> @@ -6085,7 +6109,7 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>  		return pcs;
>  	}
>
> -	empty = barn_replace_full_sheaf(barn, pcs->main);
> +	empty = barn_replace_full_sheaf(barn, pcs->main, allow_spin);
>
>  	if (!IS_ERR(empty)) {
>  		stat(s, BARN_PUT);
>  		pcs->main = empty;
>  		return pcs;
>  	}

Can this set pcs->main to NULL? When allow_spin=false and the trylock
fails, barn_replace_full_sheaf() returns NULL. Since !IS_ERR(NULL) is
true, the code executes pcs->main = NULL and returns pcs. This violates
the documented invariant that main is "never NULL when unlocked" (from
struct slub_percpu_sheaves comment at mm/slub.c:481).

The caller free_to_pcs() then dereferences pcs->main->objects at
mm/slub.c:6208, which would be a NULL pointer dereference:

    pcs->main->objects[pcs->main->size++] = object;

The execution path is:
1. kfree_nolock() calls free_to_pcs() with allow_spin=false
2. free_to_pcs() calls __pcs_replace_full_main() with allow_spin=false
3. pcs->spare exists and is full (size == s->sheaf_capacity)
4. barn_replace_full_sheaf() trylock fails, returns NULL
5. !IS_ERR(NULL) = true, so pcs->main = NULL is executed
6. __pcs_replace_full_main() returns pcs with NULL main
7. free_to_pcs() dereferences pcs->main->objects causing NULL deref

Should the check be if (empty && !IS_ERR(empty)) to properly handle the
new NULL return case?

> @@ -6093,6 +6117,11 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs)
>  		return pcs;
>  	}
>
> +	if (!allow_spin) {
> +		local_unlock(&s->cpu_sheaves->lock);
> +		return NULL;
> +	}

This check is never reached when barn_replace_full_sheaf() returns NULL,
because the early return at the !IS_ERR(empty) check above executes first.

[ ... ]



