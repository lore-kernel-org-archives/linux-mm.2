Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D59E606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 16:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=K2uaKpYD
Received: by kanga.kvack.org (Postfix)
	id 47D166B05B1; Thu,  5 Nov 2026 11:21:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42D2E6B05B2; Thu,  5 Nov 2026 11:21:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F50A6B05B3; Thu,  5 Nov 2026 11:21:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06F7B6B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 11:21:48 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9CC7A1A0AB6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:21:47 +0000 (UTC)
X-FDA: 85401581454.04.AA56E26
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9433620010
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:21:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=K2uaKpYD;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793895705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+l2yB5DkbsS7QVhiiB3+7ozIRrqflYetK+MStZ3pTPc=;
	b=brZZqSOgpREtiqh1PUOyLS26ObS/zFuvidcEsP8TeKih0GCKbRlO+ICBii7dec0UE5MrN4
	03URhhwUynZjBuc4XMXAllAfjlDMXqLa8eNSxaftSiX+7lqdJuQ/8uIK2wNTUCHaTBwMmp
	Rao6zXoYvEcPj4/D8Tcx2DSs7G8lfsQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793895705;
	b=U+SZ+AgwxYHvLKDm+rBj6G4hgmUowQyulaRbPEArvvxxefaNjivoWanqOZxY62b4lN8QgW
	92rsHAFjLmVc4HjNCU3A/q/S6XNUnUMYK6Wnhm9WZeyiRiK48EDSlz7MwzgQ4NmhYcbx1O
	14EVhx9tKaKjf51J4ciah12Q13qbiCA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=K2uaKpYD;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8a9f9473029so1721048b3a.2
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 08:21:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793895704; cv=none;
        d=google.com; s=arc-20260327;
        b=XmR0kzw8h83KFYWBrzHenk/HNo354pXWhQtDWeGFXDNqWMLFx8Od7Xtsbx0xlMJ2bf
         kCscVAYUH9kv5EQHdcLt9LheevfUkUDtykHO9KMbu1U3kSCPtrQmgalQqZyiXD5sWmwB
         Y1spwg78wTKv1npKhDTdbazZZCQV4NLEWxnXuRYvPKN7F+3PPhWTok8zGXNr4mrrHn5z
         5/ppsUW0NSV923mDr9l1Xf0Rye53zLexjc1jPcrxOpkSp3DqiH1yUK/Tf90pYRbA/kh6
         sobrXGR4+XiD8eP7lvAdWqubSjT8hB2VKiCfYD+zoOhbSAO3E+l2Cwkhrh5LHwW5p0oo
         mgxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+l2yB5DkbsS7QVhiiB3+7ozIRrqflYetK+MStZ3pTPc=;
        fh=SkRqwU1HeSjK+mpXYizIge9dMVmpEGd77NFALvcwy48=;
        b=Xltr/dvseHZnhQ4iSdlTKPozbktOSp/28NvFNCQmoZeSJrLNXnv6TZzXNyAlLMUpNa
         2P81boeG1xDYgsZUUIeIpuv5EQejhoY/ObntnikWRKIEt6fxGxznu+hyNCk+W1lvGksi
         5BnUoZLMyCe7caJBX1vQ5N0seAzCa4/sPbPxWrCyGovJdjiIfQJhhmULUtmmU6OckNzq
         e+AX2Tlkgiw0hN8hY/VM+pFZYFfSB9LQYI5ECCeUOALbBY1evdLQQkT0vP9Bj3/deN+8
         9IEB//ThKLmltlTAjR5estnMxiGu0sUw2naf5CiqTbcQPtaZOC6MWxmpjfWJQjFRjfS6
         VYiA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793895704; x=1794500504; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+l2yB5DkbsS7QVhiiB3+7ozIRrqflYetK+MStZ3pTPc=;
        b=K2uaKpYDe8z2W0/s3QGaUfP28cuEN7MB5iftig2ekY3i6GL3H+IROyf9c1OsznPNc4
         8EvZ13S6rUOJ8+ctw5tJapZpyJ3U2VEOfTg9ZHrG40TbyYOOKK/iyFZyJLTTWwzMDzHm
         dPC3E+/0aRzAjhSgj4FyPV8P8ESSbyyXjneHwQOq9D97hjln6isH9uGlaj97NGGtAN/A
         i5gGBUb6CK33R+I3F2pVjMir4X/VqYdnuZzBvwc/mMcwJHxVk7S8RU4VVQlysJTnURvQ
         LReDlwRSDKhc1iEUctnsPorh5GdjhFj8Cwzo9EFf0bZBNlecBcnuXNWa6iY01/Gw3xxZ
         DE7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793895704; x=1794500504;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+l2yB5DkbsS7QVhiiB3+7ozIRrqflYetK+MStZ3pTPc=;
        b=WgBA92bZJUFSeaZC8Vtht81xyIGDz/q1PZQ5np9uq2DZeVSHsv+zK63TV7p5iOglC6
         gvCqpi6czh9Zxi5XYf4OXzBSOcM9uNuXXatZtCloEDKT6CWUVKjJvpnDufzxE23zcvmC
         eX76rdk5+8VdYOUxVoqoThg98ZEMTuE3cd6TlSgMCF3ebrH8InLQhdpqcgGazwB7s2wz
         mtKTprhPKe3Nd1QN09ayEGruMTaDMbdM7YaxAzFMP8RqCIH6/eldlBVm5G4zPqM1/nHR
         i0S+UDbZqYSuInOgecXo1XVHACZxNuFUi1H9z1JNi2PIparOxFmVzPqYzD2WnJ9xQz9L
         2zcQ==
X-Forwarded-Encrypted: i=1; AKwUvBzFBQwAUsCILpiz8W7mftI7BAq/E+rAip2a7yZ6mTO7luV9AUOoJG+CGRIV0xzEd4qTzJBJ3ak5tw==@kvack.org
X-Gm-Message-State: APuU4Z/aNkJK5Xn49GLwYDTQSHMAsQfQLpj454whjPb0uYa6GSp33+DK
	lMXulOGMMouIf9wfz8xL7h3kMX4+uEZjT5lIPBNn/+2kXibIf3BhPXIsF/3QT7lQkhtg9B+aCfQ
	yFdRRFlXXwfZRIFY4Pyac7rexvi8kHs4=
X-Gm-Gg: AYBFou3vutxe07/X0iAg7gQnkO3RthPVXo0p7R5YwhW+D0demrYw0D5suY4gH/EKaxK
	/rgx+cQtrSOyb1yOCJKNuSpIsMhm7AqowrgdEqGgqIdhwADY/kPhUuAAxih7bPAIrrk391LTbUB
	vE4Vo+TCuEW+Q6kZPXOOOiAfrUZJmq4DBJtC35NtfQm1xSsUwrtdC1/mjO94zY3Ajy2Ds/bjAnL
	GMkdKAY8LHgxafXwX2bhw996v5DilQOJb/cWacOb9FTRx237t73K56OHHNfKzfL0Zc7UPXWyH07
	XEyZ29BReTJELB7NsYdNhgY1YHvrzQ5VgCjVFsbpBeyA6CcBNTWkFGaejntLacNHaTotZLCROh0
	e/JiAFOaCdks0ih9B4UX2/089Qx+nNL4CUB4+nJUdEwy0bKYjDfhoZqidEFL34vRZOgwSUFhFOp
	oxBcWC+VgYMX/Jkw==
X-Received: by 2002:a05:6a00:3d54:b0:890:a777:1026 with SMTP id
 d2e1a72fcca58-8a9b7531333mr16900465b3a.0.1793895704307; Thu, 05 Nov 2026
 08:21:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261105132220.2233677-1-ridong.chen@linux.dev> <20261105132220.2233677-3-ridong.chen@linux.dev>
In-Reply-To: <20261105132220.2233677-3-ridong.chen@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 6 Nov 2026 00:21:05 +0800
X-Gm-Features: AclHuK8-zrfIHeBiy8wtYRyJ57iwoiwUVM3nQia2xJy5VJ0CWDXaiLLQDvY0sQg
Message-ID: <CAMgjq7DtU+tSOgQWgTaV0obLwkkUwQqgvtTXjG2qf8L+iPXbiQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/3] mm/mglru: skip the flags cmpxchg when nothing changes
To: Ridong Chen <ridong.chen@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Joanne Koong <joannelkoong@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: iw1e9i63finizsf4trsifjhoznanf9tq
X-Rspamd-Queue-Id: 9433620010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793895705-398452
X-HE-Meta: U2FsdGVkX1+zLVSHyCe9CzAcIT7Se6XjfIT2TxvVMP73Q0N3tInx2g+OxBHLPFG5cjfD+eAlgOMVDEfpX2kQH0uxNrxCBT17+SbSHHHzbXnEQzK+s3TuVsPsERe2LjtVUWvNwBrxbNgUOxoyIo1ebvREDTufHl2PjJSeBc8KB+/IR8iQm9iCLVl7ljtgXosDLx5AgIv1OqoXJ2Xd/7BwF1Outj1bFCzOWDWd9xMEQ3h1YhJMqDJ+XhDGk7kSwQ2PBf0WSKr0hfiT9gLcix0ig7fG6rVv8N0fVXsyNd2mriapWAMRi/C30qiX256I2FSiSHvne806qR+bGjs5m9W9L/7lAzRuxozJnIT4aA/+DBg0nxoYbEY4fcXoLT/k0D9tJhNaUSEv1LE8Mpt44lQFNYC/GIkNInsGjhWVRNBa25aSCsLBKKPZG2ExGP0Wq/KrrzwUy0stiv0WIDXl8fyuaH4bFvWZDgv2zAr9lkXnP79c1ZO7D2/LOoiVCBPyIryIoc50qjdXgDcFpDsKmVFxEvsBFGCBuWLQSQFif1MDyO8+g+h2pFclKaG5m/jterpGaW2qkcfruzfyeMQd2WpRq3hc9DQ1uUlRCYVpBjPbmPuWo2LhlNB+rJqDfX8vWGVQdvM4xwe3Fo/jRwcG6J6TtssFzgcCHlc1ADo9QIsZf0R2NKU4QO4IpZTgyTBlfUBSIy3za+gPWendOSnsgujqdh4zwtzTJw7JrFyZLNzkiV9aqjEOyr8oh2jKwH7wF7DG5Ia990QHVZi0crohHAGjC3whNWhR3Xi1qX75oP7A1I3SHrwYexl+/K8mSmXqmAeNmcN6ZmiHrkpX5AWhZElENuZ9wn+PK4qfHVocm8+uGl0EE3kzTXzZn+YdlER6Yo2133rCE4D0hoYafYW9zj4Obuw1c8oex/spKQ2HHa5LZk+UUztOcuqMWHwzl5YH88JmjpA5H54ttwYfYfCRbLJ
 RbkEAd7p
 ueW2i5xIR2d8/VAm9A00ish01Oo8HifJzGqIeVikt33uPgUP2EN01HuzlkmlkHY8Jj7HtjVabNcFFY+RDIIduQF9gZ1g8SZDXMqI8XikjOSlOc1nHGqFSDlg07KogJrZl+kOPJpmO/3bK6kS4ck8cIPFWNvUKL/2rHaAhMs3Zp8VH+qw7+QUV45DrzUhO9rKgGrFxixk91SpRqjGI1glb5UTpOg1Mrz1FNhcn+nS4GANlDmznTmicCYYHrrswawReU4ng55obNSVt2DgUB+kDV938YGl941aqNAxO1iTHme7HrEK8tTJxAFtqxoZzJF6wUS6otmuGa2hzr11CktB3sfmCLygguN1x7ewzsyAnQtjZ4wmqR0IVrAVPZAzP01hPpULpD0KOoHL0KVvXpCD9I10RLkn0x4w6AlAN0zZWEkkGRNgDwGhkeZJIJx2B1H/9Dokbhcbzahxg3nw0WvtgFLQGNNDZqM9JPZ4P
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 5, 2026 at 10:11=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> folio_update_gen() and folio_set_lru_refs() always end with a
> try_cmpxchg() on folio->flags, even when the new value equals the old
> one. The locked instruction still takes the struct page cacheline in
> exclusive state.
>
> That is common in practice: a folio mapped by many processes is visited
> once per mm during a page table walk, and after the first visit it is
> already in the youngest generation with refs cleared and PG_workingset
> set. isolate_folio() and the eviction paths also call
> folio_set_lru_refs(folio, 0) on folios whose refs are already zero.
>
> Break out of the loop when the flags would not change. The result is
> the same as a successful no-op cmpxchg. The only difference is that the
> full barrier implied by the locked instruction is gone on that path.
> No caller relies on it: the eviction and isolation callers run under
> the LRU lock, and the others (page table walks, folio_mark_accessed(),
> lru_gen_clear_refs()) only care about the resulting flags value, which
> is already in place. Note that lru_gen_inc_refs() already returns
> without any atomic when refs is at LRU_REFS_MAX and the folio is in
> the workingset.
>
> Tested on an i7-13700HX with turbo disabled and the performance
> governor. N processes map the same 2GiB tmpfs file (huge=3Dnever) and
> read every page, then one aging pass is triggered on their memcg
> through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
> Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
> over 2 boots of each kernel:
>
>   processes    base   patched
>           1    32.9      31.7   -3.5%
>           8   195.1     160.2  -17.9%
>          32   755.8     592.2  -21.7%
>          64  1597.2    1260.6  -21.1%
>
> With one process, every visit changes the generation, so there is
> nothing to skip. Before the patch, perf annotate attributes 53-58% of
> the walk_update_folio() samples to the lock cmpxchg in the inlined
> folio_update_gen() in this test.
>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  include/linux/mm_inline.h | 2 ++
>  mm/vmscan.c               | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index b3d85fe91385..4ba9079f4dc8 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -244,6 +244,8 @@ static inline void folio_set_lru_refs(struct folio *f=
olio, unsigned int refs)
>         do {
>                 new_flags =3D old_flags;
>                 lru_set_refs_flags(&new_flags, refs);
> +               if (new_flags =3D=3D old_flags)
> +                       break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>  }
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 50c352e9ffef..3fa76715382d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3398,6 +3398,8 @@ static int folio_update_gen(struct folio *folio, in=
t new_gen, int *type,
>                 lru_set_gen_flags(&new_flags, new_gen);
>                 lru_set_refs_flags(&new_flags, 0);
>                 new_flags |=3D BIT(PG_workingset);
> +               if (new_flags =3D=3D old_flags)
> +                       break;
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));

Hi Ridong,

I had the same idea in V4 of MGLRU-FG which is posted a few weeks ago,
with the same code:
https://lore.kernel.org/linux-mm/20261016-mglru-fg-v4-4-2106750c0bfa@tencen=
t.com/

+ if (new_flags =3D=3D old_flags)
+ break;

I didn't have time to benchmark that one function but the e2e test
showed very trivial improvement, it's a good improvement though. Feel
free to add:

Reviewed-by: Kairui Song <kasong@tencent.com>

BTW there are a lot of concurrent activity is happening for MGLRU at
the moment so conflicts occur very frequently...

