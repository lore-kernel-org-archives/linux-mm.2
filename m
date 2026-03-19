Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF34B109190D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9AF6B009E; Thu, 19 Mar 2026 14:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 343D26B0569; Thu, 19 Mar 2026 14:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3706B056B; Thu, 19 Mar 2026 14:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 08F4E6B009E
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:37:35 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B882B1A06BA
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:37:34 +0000 (UTC)
X-FDA: 84563670828.24.31F3F83
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id B88D610000F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:37:32 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N85Ta4gk;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773945452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=frA7u7Xc3APzc2EM7Lp+OpzxNxJLgzQFv8DZjhDK9GY=;
	b=BOtTJvjNPThyJfvV4IYbgzhaJTaXEFff52TKgOt1SIB2qdqnn2e7qcLM9mn0HQljDZHVtG
	sH3XR1gxzHrdZUaOwURpRG3MeGZz4yD0G4NduLu83MCqhF0+ymLhT+SaVE3NNw3Ve56gUf
	9p1N/7FSKo7bUK36nbnUNOmgdAdFkBI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773945452; a=rsa-sha256;
	cv=pass;
	b=RY5hHxsNyeSiPcu82cuSedLBlg5//IF0h5wY7t0jifbCJ4ONd/6XvcQhBsh4pEYhShKIga
	TBt5Qw1HiR7fl0k72jQ0sTT7LkZAKfDokkFyRdY+tGxlqaIkzDkdcO60CwuXqQRmiQLGko
	mSvBCqiiNGdWa+JB+wNXjVJaA76BBxQ=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=N85Ta4gk;
	spf=pass (imf05.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.47 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-439cd6b0aedso779231f8f.1
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:37:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773945451; cv=none;
        d=google.com; s=arc-20240605;
        b=RKx6nW689WYXOaBhVkfLq2kMJkttcDZPX33DCRi5t4FlGKhxNFAkGGwokZUaa4/ef0
         kFq3/mczzejVei6ctPWqSM02grpz0pADFUbbHHwUvZmB6rshh08Cer2yubszOA9ocMQf
         QBC0sMWNnwm2ke60o1rAwn4SGNJJCJ5/4ksCASeBS371/tOVeeiRet/YD0kHqhY/yUaP
         cibvfDAx4KJTa9SxjKQS3btaQtIrfGQlN+M8/DLjpvVCnmb4TNf7QonXLHm5v/29/1wS
         GdftzOD9139gOwqhjAl9tCH1XeL3jR9WDgPzBaBZ8iDXKIAxdvmMtOKEj+yAWlAIoc7B
         vVwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=frA7u7Xc3APzc2EM7Lp+OpzxNxJLgzQFv8DZjhDK9GY=;
        fh=vbYjAAElveUnTRwkcO3cjwLt2bYeiF7gweW469Ssw70=;
        b=Xt1QTT+coS8dIZNTVCzxvGROyb9JiquxUwtZtSQcaix043hjoNq9D3AMNPxqy7sW9t
         ITiUKQENtAK2lzGgKG7SPSWpaScAVpK4nE7BaNIVuhBEQYGkGHfPhHuLXXichDAlNgdd
         iWfNWfOf/IhAimCYnZZR0t+nPbUwzOGot3fDiy8tc2JJ8lR8WnVAooip7MIH3/Gf5fAw
         +q0eoNGNVKpaaZxydS+IE7jdB0Vl3ffIZHZWHPM1MmrlXPn/7SzqmhO9aFAZ6HD757CX
         3t3dzDX1EElbYeKSVlY3W/2x2RkH/CH8M/qMgIsTBOqTb9Gm0E+srlyTMw5syOiUZlR2
         aehA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773945451; x=1774550251; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=frA7u7Xc3APzc2EM7Lp+OpzxNxJLgzQFv8DZjhDK9GY=;
        b=N85Ta4gkFVf6V2AZ3qsXSW1MzQF9rdWbyEikbkpabCtLRlGo+YgRdUoCf0FpZi4JMw
         krUt4+PAnxE8uhIMstXdCi45rRinXiOgZ2c1Cb7YQczlWd3tQXVHXsVc/h4FRCJCkdOi
         bXLjvaOmJGLDq0ogmxk3DT5UqDU9ew82KAcvMnouhhpOffT6ERydDQiLUYfMElZH1Y9k
         OjZqLcR7j6VT62fgGnCtcTreZagpTEx4isYfKCRts1f/y2txtjUO6ZM1cMiv+yU9O2uo
         /5+LD8452jGLnqtOIhcfUsT9QBwrCF6A/WCvaGE0KIdCgQ6j0OUQSW0MMIThevlgnvWn
         sfYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773945451; x=1774550251;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=frA7u7Xc3APzc2EM7Lp+OpzxNxJLgzQFv8DZjhDK9GY=;
        b=HR5FLbJ4iJsH/n6Z0J9SP+tzjBxLEWeJqzmvfrkCYJ4fzGJkL+CytIPeRGbNdxuXZ2
         b0WI2z1H9e6aSTA1V1nx6sZP2tkS8e8SnOz4YrQ3PM0x1rHJ2hxxJbiCyDulDDQXd8Wy
         /IIzDj5qc5wBhwLOKrxK8Kk2zELzkKcmTYz/3bHCtnXBRkpNC+Me+3rUr/OAHjaRPoyZ
         zs4Cw80CElg0KGpdBS8BOVsIzRVICu32wMWFVdsQ7wNK1WNFjaRwcwge9vvioiUra65c
         W8JpiyjfJgLHcgvFS/c8sm+mD0blniQRMzhc99bmslLXSr+PPJ3uCNhEdlTQzlpWKf4Y
         +8OQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJrUYgaAJwN9J/O15FxMxIX8zdESH/EcdZaQSnHkLsPk5DD3aM5YeX3VYQE+RI4q5z7YTm2FxV+A==@kvack.org
X-Gm-Message-State: AOJu0YzBo89/MqE1W2GfbefWUDmrPVIuToy5gMPzmaxyQo95g4Fhr5MI
	kz59kDmdSOu9VG2oNhGkEmZHoC0pd1e7lSM5a080SnjLVuq+OcusTQiQqGS3kiKqAjmrkh1H4bj
	AknR2ZNbYXr51cijIcpvYaVsggOxqFyU=
X-Gm-Gg: ATEYQzz1EVjtSeaF9oNx6HMkVkxVS3KcwX2j2KF+s8m/h4w++9xcS62Ciycg64uLuPe
	bfEzHd/YuUG58DOpdIoyYpFAnDte6goav2yCbdsO7NNKaE68mqV2WCjM/x8wLCTFWbvrUSup0r/
	EWKmzhjDYou5QsbOScZjj7BDh5yhq5vg+ML55ZArq471ZF2hwVj5DaPHMPL7LEbwhyLfYLYRLzH
	GKIz+ur39bziBVgsoFVxm0nKRGKnptw91rVM+pJfCjHEO8wtyKV0gnCWrd8mYu2rPmktF8h58jx
	gu4aVS9Y3nxOoanY4DstnZN5WP2rt6oL8ziGdkk=
X-Received: by 2002:a05:6000:3113:b0:43b:5003:e300 with SMTP id
 ffacd0b85a97d-43b642814fbmr636579f8f.43.1773945450700; Thu, 19 Mar 2026
 11:37:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260318222953.441758-1-nphamcs@gmail.com> <20260318222953.441758-10-nphamcs@gmail.com>
 <20260319075621.GR3738010@noisy.programming.kicks-ass.net>
In-Reply-To: <20260319075621.GR3738010@noisy.programming.kicks-ass.net>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 19 Mar 2026 11:37:19 -0700
X-Gm-Features: AaiRm50Q6KPbZbD6bEq0DQLWi-DLG4OekR5us80lL4mbKl_agLxOnXc4Kgcmx4Q
Message-ID: <CAKEwX=MUrLtZAcmwqBau5GLnWQrjL7A_4tYrdZ4TQQaE+hsVkA@mail.gmail.com>
Subject: Re: [PATCH v4 09/21] mm: swap: allocate a virtual swap slot for each
 swapped out page
To: Peter Zijlstra <peterz@infradead.org>
Cc: kasong@tencent.com, Liam.Howlett@oracle.com, akpm@linux-foundation.org, 
	apopple@nvidia.com, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, bhe@redhat.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, chengming.zhou@linux.dev, chrisl@kernel.org, 
	corbet@lwn.net, david@kernel.org, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jannh@google.com, 
	joshua.hahnjy@gmail.com, lance.yang@linux.dev, lenb@kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pm@vger.kernel.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	mhocko@suse.com, muchun.song@linux.dev, npache@redhat.com, pavel@kernel.org, 
	peterx@redhat.com, pfalcato@suse.de, rafael@kernel.org, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, surenb@google.com, 
	tglx@kernel.org, vbabka@suse.cz, weixugc@google.com, 
	ying.huang@linux.alibaba.com, yosry.ahmed@linux.dev, yuanchu@google.com, 
	zhengqi.arch@bytedance.com, ziy@nvidia.com, kernel-team@meta.com, 
	riel@surriel.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B88D610000F
X-Stat-Signature: mstzt9hc5968tt3wdhw13rafanuwntjx
X-HE-Tag: 1773945452-931145
X-HE-Meta: U2FsdGVkX18Jt5H0RdBinRPcoPPu9Zzk2UEgPWk0Lmp8y9Ra366s81rKqMIweiL/BrrKFpqCCb7rOeDC1iGgxgNE3OwfZ1c7bZ0pSC4rfSXqDW+exDH8gJh/e6UlmFHJUU5iPJjVG/XrRx4dUPtadDykr+VgCCPtnjkrrQOmWX2K+LDCbOtA4vWCPdFj7/qEQAdBQRN1T5DeHUqaEYoOjSt/BPz9rvtRooVs+p1d3F8lJ5c/SgCdcj63OiOcqIuo2XbZPkDDRAk9JZgxss+h53sWG2DV/gILP9Wy84U6qRUcUZwz6Fait9gQbOFHHwrNm5iJkFotiWIFZYvUTtpXOwq6HXcM39qcclMjBjhWcrqUwbTZXNv8r6ZnKpR6DQmBDxjYAYVg29F9svt51xb3kgfQLss8LZ6Hz9AebmuBqHvpT0i9yM181bDkwGWMaelSXl/yo6lqI4ECqTCsd0oapqqVaer7M1kfjPCJDfhimev2GcfKT7gexc++RGpPRCBJOUuLzpZ9LtlxiYyDmNH30loUFa00N1tmzgkWinVp1jMI28ZeSmMHp4iF9Y6VnOlNo2Eu71WOq67vT7WHJreLsdjgFSaofl/T6qwJhM2isRshvlFkRyMlwXs5BjoxkvrsvTggfQxwXvEWaYsMZNHgNIe6UNq5XF6tTxmDj5MErhZUDYM82cIJB2DeQV0fLKQ38afe4KBzPtBbaLJvhpc6ZGLZNMiqXoNjM9dsLc3WIg6G4qz7NhuYnB8aOh6MwG65paqDWf7QwqNhAP2ycj4N+rVWfljLAqVG3sBgRgOCzxfbuyCwe8ZzyvAT3n5oYf6GW/kMVYWyYeWNRt2YKELLsm/S/1ECUqAyEYAVKYDQzJIf40B2LFTetYN5ylCsjqqOyaA57ldO30IFjB2Ug7uFpnzLXWbljtLK42BwOFJCabg2WAtcOg8xIE+q+9ZIgqPDxCh0MC68E2DJPUcDSRQ
 em2aQh69
 LmlUg1jFcTy6Uxg899iRqoSRnUu76XPyU+7Ke9F0ABRpvnApzPFGZN742SgWa6e+elzDFy126pyriDUFC10hHtbs9hUS7NDEQF5VuBCYWDlfhegPmGrJtCyKqFKTa0F1LBR9lJIikdcmojcEAE6vDj/MuropEMhAzhZ2Ww41CeCtbtWMkYdaf0e/SOOGhOByq+UJ5+C7fCxf7rdflaw+s3T7dOie5VhcDpmNoBMT6MUfjCd/D+v7Qf/el6MfHBoMp0sE+D151R1XUI2oQkICeDhFcBFN3KmmHhF6rTp0eLaR18a1c+JqoeBU52Jx/2iJ73mG77eHX7Xp791vmHztSKniF4mXe407R6+7JDOzijioVGS2y2YvOxrYdrXvWbdsPV6oWAhJ7u9aFvsdooRpXnxO7U9wy7gQa+pGdoVgjt9D5wn7DZvqiBJy6PHGIwaZmhRzAYn/G71LNknDZxIcefEbTUJvVzzCWvddGb9DffT5Klpk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 12:56=E2=80=AFAM Peter Zijlstra <peterz@infradead.o=
rg> wrote:
>
> On Wed, Mar 18, 2026 at 03:29:40PM -0700, Nhat Pham wrote:
> > diff --git a/include/linux/cpuhotplug.h b/include/linux/cpuhotplug.h
> > index 62cd7b35a29c9..85cb45022e796 100644
> > --- a/include/linux/cpuhotplug.h
> > +++ b/include/linux/cpuhotplug.h
> > @@ -86,6 +86,7 @@ enum cpuhp_state {
> >       CPUHP_FS_BUFF_DEAD,
> >       CPUHP_PRINTK_DEAD,
> >       CPUHP_MM_MEMCQ_DEAD,
> > +     CPUHP_MM_VSWAP_DEAD,
> >       CPUHP_PERCPU_CNT_DEAD,
> >       CPUHP_RADIX_DEAD,
> >       CPUHP_PAGE_ALLOC,
>
> > +static int vswap_cpu_dead(unsigned int cpu)
> > +{
> > +     struct vswap_cluster *cluster;
> > +     int order;
> > +
> > +     rcu_read_lock();
>
> nit:
>         guard(rcu)();
>
> > +     for (order =3D 0; order < SWAP_NR_ORDERS; order++) {
> > +             cluster =3D per_cpu(percpu_vswap_cluster.clusters[order],=
 cpu);
> > +             if (cluster) {
> > +                     per_cpu(percpu_vswap_cluster.clusters[order], cpu=
) =3D NULL;
> > +                     spin_lock(&cluster->lock);
>
> This breaks on PREEMPT_RT as this is ran with IRQs disabled. This must
> be a raw_spinlock_t.
>
> > +                     cluster->cached =3D false;
> > +                     if (refcount_dec_and_test(&cluster->refcnt))
> > +                             vswap_cluster_free(cluster);
>
> And this... below.
>
> > +                     spin_unlock(&cluster->lock);
> > +             }
> > +     }
> > +     rcu_read_unlock();
> > +
> > +     return 0;
> > +}
>
> > +static void vswap_cluster_free(struct vswap_cluster *cluster)
> > +{
> > +     VM_WARN_ON(cluster->count || cluster->cached);
> > +     VM_WARN_ON(!spin_is_locked(&cluster->lock));
>
> This is terrible, please use:
>
>         lockdep_assert_held(&cluster->lock);
>
> > +     xa_lock(&vswap_cluster_map);
>
> This is again broken, this cannot be from a DEAD callback with IRQs
> disabled.
>
> > +     list_del_init(&cluster->list);
> > +     __xa_erase(&vswap_cluster_map, cluster->id);
>
> Strictly speaking this can end up in xas_alloc(), which is again, not
> allowed in a DEAD callback.

I see. I'll take a look at this. Thanks for pointing this out, Peter!

