Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4769CD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 22:48:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 218026B02AB; Fri,  8 May 2026 18:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1BE6B02AD; Fri,  8 May 2026 18:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0913C6B02AE; Fri,  8 May 2026 18:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA7AD6B02AB
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:47:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8FFC78C1B9
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:47:59 +0000 (UTC)
X-FDA: 84745741878.11.741F952
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id B3BCD14000B
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:47:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V+84QDto;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778280477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHgNbKxQRXiXgK0FgFKZNkqPMtIK+c3VNdSfsa0PfPc=;
	b=2lbwyZUSYoM2IGoQVk9RcjieNeC20VSSM3F8XSRV134amji1vqFWe3GO6RrsSKH0PLYr2O
	7gqT+7WueCVVRU3RErTMUkM8qjBSnFUrX6HLNpiIkHlNqvg54qFFPYoK1x8iZEr3MJuth+
	Tou5ryDdQHFVMLcdvg6r3e3+7rIRiEA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=V+84QDto;
	spf=pass (imf23.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778280477; a=rsa-sha256;
	cv=none;
	b=t7+xSSI/2CgVhjapZRT2HxD6fDryadN8Aoyw/rar5AsjtrDdNCkeujc4rxfZiIwS6MJEuZ
	F8MotWLndO0l+9WxY8cCMP7HXJktPmQSvyLfTkPK51nVOindbCdKyLPbt+CwMw86307UoT
	OCCFMCctbYt9Vhon5jIVWwoyZZVEqm4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 039976132F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CADC2BCF7
	for <linux-mm@kvack.org>; Fri,  8 May 2026 22:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778280476;
	bh=I2GHJNXNva5h/UIQIkwzkULkw0ReX1FhJFLD/RyVy+c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=V+84QDtoppT0cFXaEgXst8rU404quHQzipphlMV/bh9op6hvuggaXxuOMguckcMrx
	 E0Y0rXps+WavSXH/mk3WOSMTaOLostmNmYnCHiE/8yxIuhU5AgfP+8E36Wg15R95O8
	 UNgtXQR4kk3ssUK9klEWdoYkWTreaCwZTir0pfdF/VWTBXVWg5ODerMfXS3UIZMzcw
	 cxSXTMBEap/aY9A3j1Ec0fTmtZFjCU1KvDJFbXEhcWzMX4d2VjhMyTA8Iw/btOlSpQ
	 2zd6JFeGOclIz0XrRcUakrINBXhOJVdSOqd5bxVMT1ohZNadiX4mUjJ/CFs4P+Kjqp
	 rpieU2sSO2MyA==
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6579254f996so1690771d50.1
        for <linux-mm@kvack.org>; Fri, 08 May 2026 15:47:56 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy+z6RULm8swDjM0YiB6Q6NQkmU5mWAxS4grUNq2ogk2tdEKWhi
	lUl7Yxh1siNpExGXy2z3YiSb9laK7qVYyYrCMroaUPYyrn33Ygd8y5NZOZ6g+T2Ef+L5GYBV7j5
	1PRcBEetF1BWldNct61ZboeLLdKbAM9iqyxXaOWNYvA==
X-Received: by 2002:a53:bf12:0:b0:65c:6220:5fcf with SMTP id
 956f58d0204a3-65c79e5a8a0mr11015191d50.62.1778280475649; Fri, 08 May 2026
 15:47:55 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com> <20260421-swap-table-p4-v3-11-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-11-2f23759a76bc@tencent.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 9 May 2026 00:47:43 +0200
X-Gmail-Original-Message-ID: <CACePvbV8cDAy-LB6jUZMtGCsfQZBj2ZhKNFUkuzYe5MWyTYTnA@mail.gmail.com>
X-Gm-Features: AVHnY4Jh9VcdYERav2C8CbRPz67muxfk1OVxQJfiLV5jYfIr1C99npCkq8Qlf94
Message-ID: <CACePvbV8cDAy-LB6jUZMtGCsfQZBj2ZhKNFUkuzYe5MWyTYTnA@mail.gmail.com>
Subject: Re: [PATCH v3 11/12] mm/memcg: remove no longer used swap cgroup array
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
	Hugh Dickins <hughd@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B3BCD14000B
X-Rspamd-Server: rspam06
X-Stat-Signature: zmomwgau7tpqpdtwkdupa5cp1jny4qed
X-HE-Tag: 1778280477-976829
X-HE-Meta: U2FsdGVkX1+rE6oDQkQhtrqeM5ySIm7kuEB0AI6v1O2ZRj7uRZh6h9aLUrPjIZSIIG5BQ3NFxCX2lPxhEKGFv8J6fzeyaelVki+bKd5jMNsBTkTTnNAtmy9ot5KP2BZFJnH28qnif7rEuElc3VHFdUvw+qiYivFTxI0iotLr76xch7qG507MV6bb8uwJyI8NAub9hAy84bUXJyXQH1Ony71nMs0aLNceJCjzVUFnb/V+6g5u6aT8YxnbH7RP2IDRqcth4ZuJMWAtbIhJwg6ZBaOSbIlLhu0NQLNR+gc/M3s2TsyUaespwwAyZa5mD+6jLvWYcMg2pZ6UV1Hk0ZZt3eVzTlejgs997adV5oew5ksyIMLCeEpCWjpZvnE2owiiWstLD0h4QK+RXdbJBLq20hpusbJ5SkeA1Jxl5BGCIM97E0leOxkbLiLtSOXhaOBbeG2yNiBBF6pNqX6VTGITT+qliwPmTT/oGMDgtoGJX7UVp39QoU7SExqW4a7RPrr8VwbXNLH3rcJV+EtPb0s5q9IoMjWjV/yhTJC2JtcZW9msabBV4UQOzXfZuqx1HewxKPruHMpRr/ZLvfCQw8YLaPiRZ+hTsdVNTA87qR+GkB/5bNE8wxA+Os1o2EElbi82FIvWGeKja/zwPJCtnwq2jbwCgIOK6fUuHtKcSIg7xfymAePUWd4coLSDuS2qg42dp13FE70J04qcLKCV/EGDnDQrNrjl9VyAaVRTws+t1zMByTYVTA6JESEauqRb66cC88bdWDs3cPfKCA3+gEy8+N+QcIfAHZVDESQ9Gi242ysRs+t0X8BuByml7AP9/tY0FqvT7sF2Z8C39eSEm3NOByhVCwWlng8df2UkJz3r/0nYZfk08pV+VSVveckfLpLfVq6rTekt8jcP00tHhVkkbYaH245E9GfIG4WZX7gjkttO17uw0MrM5uBhgbqg/jzkR43vVxgsLtV2GLUzHSs
 95lVqTTU
 BS32L1A2O1JSgCe4XTC5333cadWDAhfmBrLXa6D2HzG2503jFQhVvWYTa/cVsyO/xICtVqSk9x6YplCFfKc5G72OFP2SvEs2fnqUKjHpEX8XCN1CqsgeB1xj/Dpe6HA6cym32Sk/C3Mw0RQLBognezYXP1f18LypnEEOcHgzz9CrnHd/a9/JnW8B6vZuhpWfZYPeLeBV3KCf7Xivw8ZQe3yMdA9D1uDQZ+RmDzUrloJ6WFQnBrkWGLj/AsVTpQkRM/flvhPh25DxSmPnn5DdW7TMuNLphmbbfYVIG7k39Odgbya7OdBgJxK54VH8aD5eZlZVHogDXT2HMNdTzXxxXCl7HL7Fq9UQG155VmqWobV6iVPE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 8:17=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Now all swap cgroup records are stored in the swap cluster directly,
> the static array is no longer needed.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  MAINTAINERS                 |   1 -
>  include/linux/swap_cgroup.h |  47 ------------
>  mm/Makefile                 |   3 -
>  mm/internal.h               |   1 -
>  mm/memcontrol-v1.c          |   1 -
>  mm/memcontrol.c             |   1 -
>  mm/swap_cgroup.c            | 172 --------------------------------------=
------

Nice patch stats.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

>  mm/swapfile.c               |   8 ---
>  8 files changed, 234 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 76d8291237be..217d98c89275 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6565,7 +6565,6 @@ F:        mm/memcontrol.c
>  F:     mm/memcontrol-v1.c
>  F:     mm/memcontrol-v1.h
>  F:     mm/page_counter.c
> -F:     mm/swap_cgroup.c
>  F:     samples/cgroup/*
>  F:     tools/testing/selftests/cgroup/memcg_protection.m
>  F:     tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> diff --git a/include/linux/swap_cgroup.h b/include/linux/swap_cgroup.h
> deleted file mode 100644
> index 91cdf12190a0..000000000000
> --- a/include/linux/swap_cgroup.h
> +++ /dev/null
> @@ -1,47 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef __LINUX_SWAP_CGROUP_H
> -#define __LINUX_SWAP_CGROUP_H
> -
> -#include <linux/swap.h>
> -
> -#if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> -
> -extern void swap_cgroup_record(struct folio *folio, unsigned short id, s=
wp_entry_t ent);
> -extern unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr=
_ents);
> -extern unsigned short lookup_swap_cgroup_id(swp_entry_t ent);
> -extern int swap_cgroup_swapon(int type, unsigned long max_pages);
> -extern void swap_cgroup_swapoff(int type);
> -
> -#else
> -
> -static inline
> -void swap_cgroup_record(struct folio *folio, unsigned short id, swp_entr=
y_t ent)
> -{
> -}
> -
> -static inline
> -unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
> -{
> -       return 0;
> -}
> -
> -static inline
> -unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
> -{
> -       return 0;
> -}
> -
> -static inline int
> -swap_cgroup_swapon(int type, unsigned long max_pages)
> -{
> -       return 0;
> -}
> -
> -static inline void swap_cgroup_swapoff(int type)
> -{
> -       return;
> -}
> -
> -#endif
> -
> -#endif /* __LINUX_SWAP_CGROUP_H */
> diff --git a/mm/Makefile b/mm/Makefile
> index 8ad2ab08244e..eff9f9e7e061 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -103,9 +103,6 @@ obj-$(CONFIG_PAGE_COUNTER) +=3D page_counter.o
>  obj-$(CONFIG_LIVEUPDATE_MEMFD) +=3D memfd_luo.o
>  obj-$(CONFIG_MEMCG_V1) +=3D memcontrol-v1.o
>  obj-$(CONFIG_MEMCG) +=3D memcontrol.o vmpressure.o
> -ifdef CONFIG_SWAP
> -obj-$(CONFIG_MEMCG) +=3D swap_cgroup.o
> -endif
>  ifdef CONFIG_BPF_SYSCALL
>  obj-$(CONFIG_MEMCG) +=3D bpf_memcontrol.o
>  endif
> diff --git a/mm/internal.h b/mm/internal.h
> index 9d2fec696bd6..7646ecb9d621 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -17,7 +17,6 @@
>  #include <linux/rmap.h>
>  #include <linux/swap.h>
>  #include <linux/leafops.h>
> -#include <linux/swap_cgroup.h>
>  #include <linux/tracepoint-defs.h>
>
>  /* Internal core VMA manipulation functions. */
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 494e7b9adc60..08be1a752c2e 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -5,7 +5,6 @@
>  #include <linux/mm_inline.h>
>  #include <linux/pagewalk.h>
>  #include <linux/backing-dev.h>
> -#include <linux/swap_cgroup.h>
>  #include <linux/eventfd.h>
>  #include <linux/poll.h>
>  #include <linux/sort.h>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 193c8eb73be7..12165fd32529 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -54,7 +54,6 @@
>  #include <linux/vmpressure.h>
>  #include <linux/memremap.h>
>  #include <linux/mm_inline.h>
> -#include <linux/swap_cgroup.h>
>  #include <linux/cpu.h>
>  #include <linux/oom.h>
>  #include <linux/lockdep.h>
> diff --git a/mm/swap_cgroup.c b/mm/swap_cgroup.c
> deleted file mode 100644
> index de779fed8c21..000000000000
> --- a/mm/swap_cgroup.c
> +++ /dev/null
> @@ -1,172 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0
> -#include <linux/swap_cgroup.h>
> -#include <linux/vmalloc.h>
> -#include <linux/mm.h>
> -
> -#include <linux/swapops.h> /* depends on mm.h include */
> -
> -static DEFINE_MUTEX(swap_cgroup_mutex);
> -
> -/* Pack two cgroup id (short) of two entries in one swap_cgroup (atomic_=
t) */
> -#define ID_PER_SC (sizeof(struct swap_cgroup) / sizeof(unsigned short))
> -#define ID_SHIFT (BITS_PER_TYPE(unsigned short))
> -#define ID_MASK (BIT(ID_SHIFT) - 1)
> -struct swap_cgroup {
> -       atomic_t ids;
> -};
> -
> -struct swap_cgroup_ctrl {
> -       struct swap_cgroup *map;
> -};
> -
> -static struct swap_cgroup_ctrl swap_cgroup_ctrl[MAX_SWAPFILES];
> -
> -static unsigned short __swap_cgroup_id_lookup(struct swap_cgroup *map,
> -                                             pgoff_t offset)
> -{
> -       unsigned int shift =3D (offset % ID_PER_SC) * ID_SHIFT;
> -       unsigned int old_ids =3D atomic_read(&map[offset / ID_PER_SC].ids=
);
> -
> -       BUILD_BUG_ON(!is_power_of_2(ID_PER_SC));
> -       BUILD_BUG_ON(sizeof(struct swap_cgroup) !=3D sizeof(atomic_t));
> -
> -       return (old_ids >> shift) & ID_MASK;
> -}
> -
> -static unsigned short __swap_cgroup_id_xchg(struct swap_cgroup *map,
> -                                           pgoff_t offset,
> -                                           unsigned short new_id)
> -{
> -       unsigned short old_id;
> -       struct swap_cgroup *sc =3D &map[offset / ID_PER_SC];
> -       unsigned int shift =3D (offset % ID_PER_SC) * ID_SHIFT;
> -       unsigned int new_ids, old_ids =3D atomic_read(&sc->ids);
> -
> -       do {
> -               old_id =3D (old_ids >> shift) & ID_MASK;
> -               new_ids =3D (old_ids & ~(ID_MASK << shift));
> -               new_ids |=3D ((unsigned int)new_id) << shift;
> -       } while (!atomic_try_cmpxchg(&sc->ids, &old_ids, new_ids));
> -
> -       return old_id;
> -}
> -
> -/**
> - * swap_cgroup_record - record mem_cgroup for a set of swap entries.
> - * These entries must belong to one single folio, and that folio
> - * must be being charged for swap space (swap out), and these
> - * entries must not have been charged
> - *
> - * @folio: the folio that the swap entry belongs to
> - * @id: mem_cgroup ID to be recorded
> - * @ent: the first swap entry to be recorded
> - */
> -void swap_cgroup_record(struct folio *folio, unsigned short id,
> -                       swp_entry_t ent)
> -{
> -       unsigned int nr_ents =3D folio_nr_pages(folio);
> -       struct swap_cgroup *map;
> -       pgoff_t offset, end;
> -       unsigned short old;
> -
> -       offset =3D swp_offset(ent);
> -       end =3D offset + nr_ents;
> -       map =3D swap_cgroup_ctrl[swp_type(ent)].map;
> -
> -       do {
> -               old =3D __swap_cgroup_id_xchg(map, offset, id);
> -               VM_BUG_ON(old);
> -       } while (++offset !=3D end);
> -}
> -
> -/**
> - * swap_cgroup_clear - clear mem_cgroup for a set of swap entries.
> - * These entries must be being uncharged from swap. They either
> - * belongs to one single folio in the swap cache (swap in for
> - * cgroup v1), or no longer have any users (slot freeing).
> - *
> - * @ent: the first swap entry to be recorded into
> - * @nr_ents: number of swap entries to be recorded
> - *
> - * Returns the existing old value.
> - */
> -unsigned short swap_cgroup_clear(swp_entry_t ent, unsigned int nr_ents)
> -{
> -       pgoff_t offset, end;
> -       struct swap_cgroup *map;
> -       unsigned short old, iter =3D 0;
> -
> -       offset =3D swp_offset(ent);
> -       end =3D offset + nr_ents;
> -       map =3D swap_cgroup_ctrl[swp_type(ent)].map;
> -
> -       do {
> -               old =3D __swap_cgroup_id_xchg(map, offset, 0);
> -               if (!iter)
> -                       iter =3D old;
> -               VM_BUG_ON(iter !=3D old);
> -       } while (++offset !=3D end);
> -
> -       return old;
> -}
> -
> -/**
> - * lookup_swap_cgroup_id - lookup mem_cgroup id tied to swap entry
> - * @ent: swap entry to be looked up.
> - *
> - * Returns ID of mem_cgroup at success. 0 at failure. (0 is invalid ID)
> - */
> -unsigned short lookup_swap_cgroup_id(swp_entry_t ent)
> -{
> -       struct swap_cgroup_ctrl *ctrl;
> -
> -       if (mem_cgroup_disabled())
> -               return 0;
> -
> -       ctrl =3D &swap_cgroup_ctrl[swp_type(ent)];
> -       return __swap_cgroup_id_lookup(ctrl->map, swp_offset(ent));
> -}
> -
> -int swap_cgroup_swapon(int type, unsigned long max_pages)
> -{
> -       struct swap_cgroup *map;
> -       struct swap_cgroup_ctrl *ctrl;
> -
> -       if (mem_cgroup_disabled())
> -               return 0;
> -
> -       BUILD_BUG_ON(sizeof(unsigned short) * ID_PER_SC !=3D
> -                    sizeof(struct swap_cgroup));
> -       map =3D vzalloc(DIV_ROUND_UP(max_pages, ID_PER_SC) *
> -                     sizeof(struct swap_cgroup));
> -       if (!map)
> -               goto nomem;
> -
> -       ctrl =3D &swap_cgroup_ctrl[type];
> -       mutex_lock(&swap_cgroup_mutex);
> -       ctrl->map =3D map;
> -       mutex_unlock(&swap_cgroup_mutex);
> -
> -       return 0;
> -nomem:
> -       pr_info("couldn't allocate enough memory for swap_cgroup\n");
> -       pr_info("swap_cgroup can be disabled by swapaccount=3D0 boot opti=
on\n");
> -       return -ENOMEM;
> -}
> -
> -void swap_cgroup_swapoff(int type)
> -{
> -       struct swap_cgroup *map;
> -       struct swap_cgroup_ctrl *ctrl;
> -
> -       if (mem_cgroup_disabled())
> -               return;
> -
> -       mutex_lock(&swap_cgroup_mutex);
> -       ctrl =3D &swap_cgroup_ctrl[type];
> -       map =3D ctrl->map;
> -       ctrl->map =3D NULL;
> -       mutex_unlock(&swap_cgroup_mutex);
> -
> -       vfree(map);
> -}
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index edf4cb36728e..2172920e68d1 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -45,7 +45,6 @@
>
>  #include <asm/tlbflush.h>
>  #include <linux/leafops.h>
> -#include <linux/swap_cgroup.h>
>  #include "swap_table.h"
>  #include "internal.h"
>  #include "swap.h"
> @@ -3136,8 +3135,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, speci=
alfile)
>         p->global_cluster =3D NULL;
>         kvfree(zeromap);
>         free_swap_cluster_info(cluster_info, maxpages);
> -       /* Destroy swap account information */
> -       swap_cgroup_swapoff(p->type);
>
>         inode =3D mapping->host;
>
> @@ -3668,10 +3665,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, speci=
alfile, int, swap_flags)
>         if (error)
>                 goto bad_swap_unlock_inode;
>
> -       error =3D swap_cgroup_swapon(si->type, maxpages);
> -       if (error)
> -               goto bad_swap_unlock_inode;
> -
>         /*
>          * Use kvmalloc_array instead of bitmap_zalloc as the allocation =
order might
>          * be above MAX_PAGE_ORDER incase of a large swap file.
> @@ -3782,7 +3775,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specia=
lfile, int, swap_flags)
>         si->global_cluster =3D NULL;
>         inode =3D NULL;
>         destroy_swap_extents(si, swap_file);
> -       swap_cgroup_swapoff(si->type);
>         free_swap_cluster_info(si->cluster_info, si->max);
>         si->cluster_info =3D NULL;
>         kvfree(si->zeromap);
>
> --
> 2.53.0
>
>
>

