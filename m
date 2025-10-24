Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F51BCCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 15:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96B088E00B9; Fri, 24 Oct 2025 11:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91AD68E0042; Fri, 24 Oct 2025 11:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80A628E00B9; Fri, 24 Oct 2025 11:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6C6BB8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 11:29:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 11179C0EFA
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:29:53 +0000 (UTC)
X-FDA: 84033393066.25.A3CAC9B
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com [67.231.153.30])
	by imf14.hostedemail.com (Postfix) with ESMTP id D85C0100010
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 15:29:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=u1H8joWQ;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf14.hostedemail.com: domain of "prvs=63920b99c4=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=63920b99c4=clm@meta.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761319791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYg1vP9W9v0SXXkTSNQM/3alSk45Op1+j7AlOwvEtcM=;
	b=LrLDC3RfPz83dqdkov+i1x5rR5icAh2oS83KRDuIDrJi3EIgTkgjYGLS+D3TaOZEFWknOA
	qTxGbQEhlw6ehqQD08D0KBCcmfS8CLtGpaJKL5QEFkWhR5qz2Xzg72NWHu9vIu41nUaANr
	EtjueFbMV0gyzosbDmGA2Kdbo9Sh5vg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761319791; a=rsa-sha256;
	cv=none;
	b=Sk/htCLAYSEBumqTJIfvcy6/QYjGGKh8s8tRt0WcF8A6M839RHAPE9x4q3BtxjjOkotjaC
	Xk9FhAlIjGJ2ngj0h43hnJ7mO5azIPUmaFeXCiKMPJLUyemfSDXN5G4T7rtnYpXPwy0cWT
	vM0Q0ZlQZ1muJER7Z9g98NG14i0Utt4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=meta.com header.s=s2048-2025-q2 header.b=u1H8joWQ;
	dmarc=pass (policy=reject) header.from=meta.com;
	spf=pass (imf14.hostedemail.com: domain of "prvs=63920b99c4=clm@meta.com" designates 67.231.153.30 as permitted sender) smtp.mailfrom="prvs=63920b99c4=clm@meta.com"
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
	by m0001303.ppops.net (8.18.1.11/8.18.1.11) with ESMTP id 59OE2RhP2211218;
	Fri, 24 Oct 2025 08:29:42 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=s2048-2025-q2;
	 bh=JYg1vP9W9v0SXXkTSNQM/3alSk45Op1+j7AlOwvEtcM=; b=u1H8joWQSvKP
	lsrsEERu6cI1x3A5mfYS1zL8z0TQ0khpcMO8oYoKKD8h7+McjWX/ktRh8T6OlVd7
	YTYfYTTlFhlbaEQxQ089POCXDGW4O4ZiFd2+HPGFe8v+yA9+5tITFlTOMM2QswD0
	VpUEdNRVGQdCV9aikoHsmDQz2VGUO5389kHXGxz0TnWP8qKuS0sG6TTGir/ES96V
	H2xX4fayiv6t2blL54E3ElLvGNPYJyjqq481ODsOAu1/biqcHXXU3LECt5+qHjhO
	SVER6vuEUb3vlKr76lyqRFBGrbkBT5ZmPfENEG/Igm50m98ee4vYpQFalDF+f+S/
	E+f1ht3MRA==
Received: from mail.thefacebook.com ([163.114.134.16])
	by m0001303.ppops.net (PPS) with ESMTPS id 49yxkh4c3r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
	Fri, 24 Oct 2025 08:29:42 -0700 (PDT)
Received: from devbig091.ldc1.facebook.com (2620:10d:c085:208::7cb7) by
 mail.thefacebook.com (2620:10d:c08b:78::2ac9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.20; Fri, 24 Oct 2025 15:29:40 +0000
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
Subject: Re: [PATCH RFC 06/19] slab: introduce percpu sheaves bootstrap
Date: Fri, 24 Oct 2025 08:29:09 -0700
Message-ID: <20251024152913.1115220-1-clm@meta.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023-sheaves-for-all-v1-6-6ffa2c9941c0@suse.cz>
References:
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [2620:10d:c085:208::7cb7]
X-Proofpoint-GUID: kkk2s3qprms9Z7I2EC8CkdtQeZfZNQk7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDI0MDEzOSBTYWx0ZWRfX7OIXVkMX9geX
 7pzjGpPRSpFcTx7fX8n9LXsYKQ3g0QZRGy/YPxIO393qaVutmBVwI5lA7gFo2Q5Hwa8+P741e63
 xa6tJDDXt4JLNHQXxoIcH9J3r2OhtgnPlM4/Dr6jsPRXB1oEw/kPigXQ63CZR62E3oWIRwP92bI
 Uyw/Rir17bhjlbv9m3LRbTZKG10KB7hH/N6P1EqnkT0Cqw/05VrvLihNzZyUp7LDWbJDlLeGXcc
 H/V7buo1lPWg9avwKIjQpsh4ufOJ0RbDY3XF7efzaPcvEl+kxGuwx0N75gZk9lfpaNVUS9+08yq
 tCSqvOvqHCgRAFoEYuICfiy9uaKRTDvTQ2t2EAEZ5GLOUuAXhopMjOObCyRbGyHI7KdUgqT79Bs
 +PdwDPQk/r7OGlJSV6buVYTVGDTVHg==
X-Authority-Analysis: v=2.4 cv=RqHI7SmK c=1 sm=1 tr=0 ts=68fb9b66 cx=c_pps
 a=CB4LiSf2rd0gKozIdrpkBw==:117 a=CB4LiSf2rd0gKozIdrpkBw==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=7e5GxzTNbid4F3B1EgkA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: kkk2s3qprms9Z7I2EC8CkdtQeZfZNQk7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-24_02,2025-10-22_01,2025-03-28_01
X-Rspam-User: 
X-Rspamd-Queue-Id: D85C0100010
X-Rspamd-Server: rspam02
X-Stat-Signature: pk1s7jku8asndgpyfdkyfimjpdin4erx
X-HE-Tag: 1761319790-82031
X-HE-Meta: U2FsdGVkX18oDO+ZH6KhbAO9mfHg4ipNZNIZ9xmhqS9ZdE4iL330O5PrmPtk71L1jHhIsTBvFLQwp5USg8NUTbDsnl2/Jyl2BDtTak5xeT9XEnFb7J7Cmn70AB9sv2ETgOhUqlo0RbsoIhBoxhyInZ/oaPArIgZcxpvmRKaz5YLDAcDZdcNJPgJpUr2ZGJ6djxqzy6yyIUOPh+60K2EB3K9RO8ViJBjoUskig5R+jjo/nIsLo+CtkJpu7uO49rh+wdohTCGBILtvqZ4pP5MGDVWAxCUujYg3YSeEg41xY/mxA3Ej9A/NlyOveku2jVKLLW9QHIgqKCM+YJroYhxGz9dk1Hc5zk1N112NDeNRfWoFweLPRvtHYSQ/bTPcZophy+uFDCuYghQEB/IRWAls601ELdv/Km2UT5u+FwkJP2t+zDIPLhmboLMj7H7PlbSUqDAbgde9ymHDTgHhRFaMY9EA9ztHeQPh6dG2O5RyJkcEnkX6Bs+zU+fuBqk3Llp0RZnUoSjo2+5+4z6AQZpJBTwZjrYmH7KDGSp+0jY4FOeO7mMmRq3v1rJDanZ/bTX7rurAbuRiGxe3QMsl/aiz7xnTki/jpyznOKVJu+vzo5JHehyNg6gUXQqJ3vXS6Q77bzcqH8WFEMgTTie+YZnGtAg20OmBlep8+E9z4Ja7PGcJa7y3Rhmf9STMJAgevCTsKNdSSe/iCMx8+2MqlIe7TCP5ZVnczVWWPHM/4uN87vjlQYAi06h7f0AquWvadCJoCgdw/dIkBYBQKVTVmPuY933xSsEZ6Hz7kfpDSnbslCCPGjyw7HBj2SFByhZn9ZavIoDPbvzKHn1stgjctRZNAFDBAYOlHpUbGRDuL6+37yxNWJwodKLFokTK+NASh/JPfhjvZ/va319ZybB/RLeE3784ieJ8U/KfsOEi18HAtLxCn1fv+1xWDkiRHmBtwR+A86MT1sqnFmk6+9KPCZ9
 5Z6AZxRg
 m5J8s/6dJ+cwnT0OJWpcsrU0v0v63W+zRR1AqTQrDWAlsCmuJJoFE8EM+MU39kJyinqZSBgI+KXKtMY7Gm5FQwLQGiZQBL8VT1bt+TCWJakykEZudGVew631k374FL2+wpxR4DcaDmZEDQqERcA75pje7sX3CK35UZsdASIo18EcSn9fHmltclbOA0NCvOMx5JxybCG3JcxJ3xx76zNi8RwWlQ74vHGh3sSSq4EACjIlBRDavA5Ge3i7yqXgsAlouQmSV2B8mhnaJ0bgPRcEaItWgsmVSH5DA71PGTHe3ejcp5rTRg4cbCVjxmisWpOupb8rqLN+JQSeF+91BgA/EeOCM9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Oct 2025 15:52:28 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:

> Until now, kmem_cache->cpu_sheaves was !NULL only for caches with
> sheaves enabled. Since we want to enable them for almost all caches,
> it's suboptimal to test the pointer in the fast paths, so instead
> allocate it for all caches in do_kmem_cache_create(). Instead of testing
> the cpu_sheaves pointer to recognize caches (yet) without sheaves, test
> kmem_cache->sheaf_capacity for being 0, where needed.
> 
> However, for the fast paths sake we also assume that the main sheaf
> always exists (pcs->main is !NULL), and during bootstrap we cannot
> allocate sheaves yet.
> 
> Solve this by introducing a single static bootstrap_sheaf that's
> assigned as pcs->main during bootstrap. It has a size of 0, so during
> allocations, the fast path will find it's empty. Since the size of 0
> matches sheaf_capacity of 0, the freeing fast paths will find it's
> "full". In the slow path handlers, we check sheaf_capacity to recognize
> that the cache doesn't (yet) have real sheaves, and fall back. Thus
> sharing the single bootstrap sheaf like this for multiple caches and
> cpus is safe.
>

Hi Vlastimil,

We're trying out the AI patch review automation on the BPF commits and it had
some questions about a few of these.  Since the goal is to actually test the
automation, I'm putting them in unedited, but I did try and make sure they
were valid before sending.

> diff --git a/mm/slub.c b/mm/slub.c
> index a6e58d3708f4..ecb10ed5acfe 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c

[ ... ]

> @@ -7733,8 +7782,7 @@ static void free_kmem_cache_nodes(struct kmem_cache *s)
>  void __kmem_cache_release(struct kmem_cache *s)
>  {
>  	cache_random_seq_destroy(s);
> -	if (s->cpu_sheaves)
> -		pcs_destroy(s);
> +	pcs_destroy(s);

Can pcs_destroy() handle a NULL cpu_sheaves pointer? Looking at the
error path in do_kmem_cache_create():

    s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
    if (!s->cpu_sheaves) {
        err = -ENOMEM;
        goto out;
    }
    ...
    out:
        if (err)
            __kmem_cache_release(s);

If alloc_percpu() fails, __kmem_cache_release() now calls pcs_destroy()
unconditionally. In pcs_destroy(), the first operation is:

    for_each_possible_cpu(cpu) {
        pcs = per_cpu_ptr(s->cpu_sheaves, cpu);

Does per_cpu_ptr() dereference s->cpu_sheaves when it's NULL?

>  #ifdef CONFIG_PREEMPT_RT
>  	if (s->cpu_slab)
>  		lockdep_unregister_key(&s->lock_key);

[ ... ]

> @@ -8608,12 +8656,10 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
>
>  	set_cpu_partial(s);
>
> -	if (s->sheaf_capacity) {
> -		s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
> -		if (!s->cpu_sheaves) {
> -			err = -ENOMEM;
> -			goto out;
> -		}
> +	s->cpu_sheaves = alloc_percpu(struct slub_percpu_sheaves);
> +	if (!s->cpu_sheaves) {
> +		err = -ENOMEM;
> +		goto out;
>  	}

This error path triggers the call chain: do_kmem_cache_create() error
path -> __kmem_cache_release() -> pcs_destroy() with NULL cpu_sheaves.



