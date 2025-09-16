Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458F8CAC598
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 16:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A1EE8E0002; Tue, 16 Sep 2025 12:33:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8526E8E0001; Tue, 16 Sep 2025 12:33:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 768498E0002; Tue, 16 Sep 2025 12:33:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 60C958E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 12:33:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF44613A2FB
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:33:35 +0000 (UTC)
X-FDA: 83895659190.15.FD7B263
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0BA6C140015
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 16:33:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="McT+eH/b";
	spf=pass (imf26.hostedemail.com: domain of yuanchu@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758040414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PpJRPqyE+DLgCkViSYT6h8uO5sNq+STFGuKFYPZGf4U=;
	b=qc3Nj6MTch2lDEsvGdyk1QKrJCRHQa0OTf81qW0JbUCRo1qVNxk7+RS/DmVj1ZG+NJsyuW
	OCLSvZuZjbT0STRXfYjM4cDwVJIsWgoZyVjlzebffqwxJ3iAzFiSTbvpiuwod6ClbiS5kL
	jXZS9b9fcDxxFo+2NTIR9VYHoBqbX2I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="McT+eH/b";
	spf=pass (imf26.hostedemail.com: domain of yuanchu@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=yuanchu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758040414; a=rsa-sha256;
	cv=none;
	b=2i6jnd7PkIKaDfFqyG9wZmrxedyMyk8mrgu1B2BfZ6JYrxsIGz3fREVxZx9RnifiamiokJ
	uGKN+fMdPpslMi2fGe8eVnUjU1RmGUBF8/5i7WLSNj5HYhguiNaki/VhNunmxNJoyYkOMb
	Xh3uzS8bB2Ip/F39KuMj86PRuwHXBC0=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2637b6e9149so236145ad.1
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 09:33:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758040413; x=1758645213; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PpJRPqyE+DLgCkViSYT6h8uO5sNq+STFGuKFYPZGf4U=;
        b=McT+eH/bILiOs+WNjWlEdI0v+us6C34Yqq979Bk+bVShAil8ymK7PS42xkkJy/d+pf
         /bdttoPOqZcq9IrU5Q/qS53vDDmQBUC45jCloie+8klsd0lpoMQmEcKnYrOIo0b8+jGs
         dWT5whac6cvBmZ6znwsSUDMnF9k3xl5seAslEt2mI9azAqrg1ToAbk7nD58yeuRXF2od
         5hkugZHOnmDpOJmtRmTG77Y64LS3u3Mso5Blwy75T9ajH9M5xoVyULQH+bQsitvbYK8j
         SqwipjgRrTyK4gwMGD2d5wQeTbOp6QOmpQUK1sIPIym7cTQcAobPeEi4SZdmOxN8h6H6
         +6lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758040413; x=1758645213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PpJRPqyE+DLgCkViSYT6h8uO5sNq+STFGuKFYPZGf4U=;
        b=faRm+GtElqMmnVN+xfJozO31AS/oEFV6b3HqXTpP9jHocnT8uww7hJoJPPIJ6is6Tv
         FcRvIP6cKfjsbdXLtYd7Onrx2PuE5vCUOvbtH8TGsn18PErVh8Mz7ykK8XhG8jOx264X
         fMwxP3bXEKeQEuLyls31lTh8nMtXF4yo6zvsDtc1YsbcgdWYE1nMkMPVVSVgpHD2uJb9
         0LTf4nuesJkklDL7YZ8fEe+wnviKRydPEUJelT5fF2+3jUXPdvBQSEsHn2iXd3HIXPy5
         r6a1iQlLsKOl34a5zfd0Kq63Xh70zZsMeRFd/1d1nXrW4BnDz4Ry9uhFf3ot0Yc0kWYT
         Brig==
X-Forwarded-Encrypted: i=1; AJvYcCXkFmpsgTobO7/cBbPSWGW9TQq6My6+JLg94jh1CVHLVDBNKdPh0B+pUeGCUPRoNRDa29boZbPiDg==@kvack.org
X-Gm-Message-State: AOJu0Yz6Siir/q5QFLBorDGe0N8DihnPV2otGqKAT3Lp+3AbIGm4btEW
	XkFDblCL5wLmmNisjptsdJCphxrK7x+rHNISMV6/nuysZ7quyzmCqVja5U1CogwHN2nXIsgCTSa
	UQmTpFRTBldW8xBhHYLIxXMiHoQh56Q+edCCRGnMR
X-Gm-Gg: ASbGnctBruruNeEFhbyODqONsGRKJaez9gk9b+2f9ZNbLWCbZo1WQqKE2tQHSqjZaRG
	k+8zKA05gSuwpB9Q7zy9QKlEK+K1GNmsD4foGUd0M50GiT0ftRgGqB7LKmQ4Oc+4Y1CzXmMs9ea
	V4oBGqzK2sGi5ucUjhQX9+rSi4GwMIiheXVhDTgJ3d8OyhTNrK1peOwHJqbfPjVH431JNSxNRpH
	2N3IAm0UBFua2QRjruPWK9A6oF+ZK5Oa1ImybrHykPX1XQF4AB5g4YuQbXu6mgW6hAjmeO5uUJU
	BPxELr/chlw=
X-Google-Smtp-Source: AGHT+IEmopqHrLlKAg9oy907o3DJI6+vH3JcnFDx1aG/LSz9zqj3HF4XGnr65ldjfgJRaRNtO5J5uw5CFf4k7w6uZSw=
X-Received: by 2002:a17:902:c94c:b0:267:e853:69e6 with SMTP id
 d9443c01a7336-267e8536dcbmr2381375ad.10.1758040412493; Tue, 16 Sep 2025
 09:33:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250916072226.220426-1-liulei.rjpt@vivo.com>
In-Reply-To: <20250916072226.220426-1-liulei.rjpt@vivo.com>
From: Yuanchu Xie <yuanchu@google.com>
Date: Tue, 16 Sep 2025 11:33:15 -0500
X-Gm-Features: AS18NWDSakZyj0YpuhHGRbZt0lSAiKvJ-Ui1fUjnfRR1XkwTcSWp7BRZ--IPK2c
Message-ID: <CAJj2-QHy3rTSPpE5uyu4gW9dWe1E5Q28P_N-VX2Uo+xBFauxdw@mail.gmail.com>
Subject: Re: [RFC PATCH v0] mm/vmscan: Add readahead LRU to improve readahead
 file page reclamation efficiency
To: Lei Liu <liulei.rjpt@vivo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Wei Xu <weixugc@google.com>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kanchana P Sridhar <kanchana.p.sridhar@intel.com>, 
	Johannes Thumshirn <johannes.thumshirn@wdc.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Nico Pache <npache@redhat.com>, Harry Yoo <harry.yoo@oracle.com>, Yu Zhao <yuzhao@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Usama Arif <usamaarif642@gmail.com>, 
	Chen Yu <yu.c.chen@intel.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, 
	Nhat Pham <nphamcs@gmail.com>, Hao Jia <jiahao1@lixiang.com>, 
	"Kirill A. Shutemov" <kas@kernel.org>, Barry Song <baohua@kernel.org>, Ingo Molnar <mingo@kernel.org>, 
	Jens Axboe <axboe@kernel.dk>, Petr Mladek <pmladek@suse.com>, 
	Jaewon Kim <jaewon31.kim@samsung.com>, 
	"open list:PROC FILESYSTEM" <linux-kernel@vger.kernel.org>, 
	"open list:PROC FILESYSTEM" <linux-fsdevel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>, 
	"open list:TRACING" <linux-trace-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0BA6C140015
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 7rwukxo93q4mta6jwfik6p3rmikir8d5
X-HE-Tag: 1758040413-9649
X-HE-Meta: U2FsdGVkX1/IjQ7KCJjGopTyDbjA7R85AEj7v/iN3ycmtXUxgg5pDyDHirLCvOoqXmzIXBKZ0J2UdS5Pdii2dhLJulBs4QRRiOsuXStTKrkBmJiG0xFEYn/ezfw5wb4hIoHQbBKPSY4KaH+pnWyBcUBjihBFrpVjYOAkHZz9ofg5CRMeCh305LX6hmIfXIJ1URZrqv83zQUx7/VocTpGKJRPJM8oSnCVonT/K9ZIq0uGgcvoKXWHcWS2Xfybn9x0XBqrpg68ajTihm9F7j8DJV6C9XJj4au8Zk3Rk6H1BuPYy1i7Eezpum840OjLLXxZH0cgLKksDVMvE6NF9v8FlWLE9CKlOldDn+FdaQOBmvsKwMSSoRmaqY71+aBuTBed5zXCNl5F8nbsMd8Lp/CoZtm+4Qja/xVA1y45yMML0BGJs2jAhYfYuadrGQEEkp3rmxttuMdJPB0uCSJGuQDzmM3sCzVVZ5+hz7ua1TQASENKKKoh+WF0wbQCOGOzlbHnP9ht1va0uF+3IjPRqbWkXsRiiC13tMgmmhdrZaIYzmiBhbpO06aAOQAnDWZQvvbvLP/Jq1BN7yDfxBysdOjvklh61mi3/YLUB3P3lwsdbcx12cpQdwCFEGbJV3BVTPNpFeqc5oEvqh3rO5lubTbSaszerNwlPWqxLBSuW5JjiJ9xK7xUm9U5ElWtD/LEu4FQtbPJnSgwvcbEMfrztsLwCawmWbyTcnmgS3RIMduQTBqiZHGO6mS9PekAxClb9/ggXqjRo735dIL8UVvRhlsytUD7WVu9n52cjsxVhhkl+hECQ15HyQ8qpQ90DsubZWPMgqqjxUmUhP2MlVfMCFt768BF3MPNC8kOU+F9Qb/iC4ao6ylDwV2cgZw8gkOV8IaHeXW9C2iQBK17+RbBgBfFE7D1Xv8K+zmgNIUGowxzNizFmgrqRsaKnBMRtnMZQ3vScomP2OdRsrdhFCq3wMv
 EOZSLWpP
 iXP71quFDErxom/SZMkvNzSJmAURynFciYy844dJzQr/FshF/vjNfijDHm6k7k1B5UCwlzYiiI5LyJhU6FWFywSXU82Q6vxoVVLiQ2QS33jRijpCF4VvNhmwQRw8cajD2nL8wi+urbsS+3IJn/y0oqTyO8qOx9OQebmc9Ng/3LA+uRTjPasI35Z/mmIoV/elnB9woD36O3MysHDVJ+snvt7eCgQZAnIvWNT3ve2pUXWklvlMlp3cMHpcjWYLv608Glw9Rp9IVIU90Tu4T2nBXsGN98x8HKmcz5NnD8WeZY+tHIfM1Hv2sgrywHGQLB398nhCn2ZfvLKZwLsyLt+p0P+JEuqg/GdA5qY2ykdSSlKt9uLRX+QNfFU11Kj+9/78UgKAr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 2:22=E2=80=AFAM Lei Liu <liulei.rjpt@vivo.com> wrot=
e:
> ...
>
> 2. Solution Proposal
> Introduce a Readahead LRU to track pages brought in via readahead. During
> memory reclamation, prioritize scanning this LRU to reclaim pages that
> have not been accessed recently. For pages in the Readahead LRU that are
> accessed, move them back to the inactive_file LRU to await subsequent
> reclamation.
I'm unsure this is the right solution though, given all users would
have this readahead LRU on and we don't have performance numbers
besides application startup here.
My impression is that readahead behavior is highly dependent on the
hardware, the workload, and the desired behavior, so making the
readahead{-adjacent} behavior more amenable to tuning seems like the
right direction.

Maybe relevant discussions: https://lwn.net/Articles/897786/

I only skimmed the code but noticed a few things:

> diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
> index a458f1e112fd..4f3f031134fd 100644
> --- a/fs/proc/meminfo.c
> +++ b/fs/proc/meminfo.c
> @@ -71,6 +71,7 @@ static int meminfo_proc_show(struct seq_file *m, void *=
v)
>         show_val_kb(m, "Inactive(anon): ", pages[LRU_INACTIVE_ANON]);
>         show_val_kb(m, "Active(file):   ", pages[LRU_ACTIVE_FILE]);
>         show_val_kb(m, "Inactive(file): ", pages[LRU_INACTIVE_FILE]);
> +       show_val_kb(m, "ReadAhead(file):",
I notice both readahead and read ahead in this patch. Stick to the
conventional one (readahead).

> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 8d3fa3a91ce4..57dac828aa4f 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -127,6 +127,7 @@ enum pageflags {
>  #ifdef CONFIG_ARCH_USES_PG_ARCH_3
>         PG_arch_3,
>  #endif
> +       PG_readahead_lru,
More pageflags...

b/include/trace/events/mmflags.h
> index aa441f593e9a..2dbc1701e838 100644
> --- a/include/trace/events/mmflags.h
> +++ b/include/trace/events/mmflags.h
> @@ -159,7 +159,8 @@ TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
>         DEF_PAGEFLAG_NAME(reclaim),                                     \
>         DEF_PAGEFLAG_NAME(swapbacked),                                  \
>         DEF_PAGEFLAG_NAME(unevictable),                                 \
> -       DEF_PAGEFLAG_NAME(dropbehind)                                   \
> +       DEF_PAGEFLAG_NAME(dropbehind),                                  \
> +       DEF_PAGEFLAG_NAME(readahead_lru)                                \
>  IF_HAVE_PG_MLOCK(mlocked)                                              \
>  IF_HAVE_PG_HWPOISON(hwpoison)                                          \
>  IF_HAVE_PG_IDLE(idle)                                                  \
> @@ -309,6 +310,7 @@ IF_HAVE_VM_DROPPABLE(VM_DROPPABLE,  "droppable"     )=
               \
>                 EM (LRU_ACTIVE_ANON, "active_anon") \
>                 EM (LRU_INACTIVE_FILE, "inactive_file") \
>                 EM (LRU_ACTIVE_FILE, "active_file") \
> +               EM(LRU_READ_AHEAD_FILE, "readahead_file") \
Likewise, inconsistent naming.

> diff --git a/mm/migrate.c b/mm/migrate.c
> index 9e5ef39ce73a..0feab4d89d47 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -760,6 +760,8 @@ void folio_migrate_flags(struct folio *newfolio, stru=
ct folio *folio)
>                 folio_set_workingset(newfolio);
>         if (folio_test_checked(folio))
>                 folio_set_checked(newfolio);
> +       if (folio_test_readahead_lru(folio))
> +               folio_set_readahead_lru(folio);
newfolio

>  /*
> @@ -5800,6 +5837,87 @@ static void lru_gen_shrink_node(struct pglist_data=
 *pgdat, struct scan_control *
>
>  #endif /* CONFIG_LRU_GEN */
>
> +static unsigned long shrink_read_ahead_list(unsigned long nr_to_scan,
> +                                           unsigned long nr_to_reclaim,
> +                                           struct lruvec *lruvec,
> +                                           struct scan_control *sc)
> +{
> +       LIST_HEAD(l_hold);
> +       LIST_HEAD(l_reclaim);
> +       LIST_HEAD(l_inactive);
> +       unsigned long nr_scanned =3D 0;
> +       unsigned long nr_taken =3D 0;
> +       unsigned long nr_reclaimed =3D 0;
> +       unsigned long vm_flags;
> +       enum vm_event_item item;
> +       struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> +       struct reclaim_stat stat =3D { 0 };
> +
> +       lru_add_drain();
> +
> +       spin_lock_irq(&lruvec->lru_lock);
> +       nr_taken =3D isolate_lru_folios(nr_to_scan, lruvec, &l_hold, &nr_=
scanned,
> +                                     sc, LRU_READ_AHEAD_FILE);
> +
> +       __count_vm_events(PGSCAN_READAHEAD_FILE, nr_scanned);
> +       __mod_node_page_state(pgdat, NR_ISOLATED_FILE, nr_taken);
> +       item =3D PGSCAN_KSWAPD + reclaimer_offset(sc);
> +       if (!cgroup_reclaim(sc))
> +               __count_vm_events(item, nr_scanned);
> +       count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
> +       __count_vm_events(PGSCAN_FILE, nr_scanned);
> +       spin_unlock_irq(&lruvec->lru_lock);
> +
> +       if (nr_taken =3D=3D 0)
> +               return 0;
> +
> +       while (!list_empty(&l_hold)) {
> +               struct folio *folio;
> +
> +               cond_resched();
> +               folio =3D lru_to_folio(&l_hold);
> +               list_del(&folio->lru);
> +               folio_clear_readahead_lru(folio);
> +
> +               if (folio_referenced(folio, 0, sc->target_mem_cgroup, &vm=
_flags)) {
> +                       list_add(&folio->lru, &l_inactive);
> +                       continue;
> +               }
> +               folio_clear_active(folio);
> +               list_add(&folio->lru, &l_reclaim);
> +       }
> +
> +       nr_reclaimed =3D shrink_folio_list(&l_reclaim, pgdat, sc, &stat, =
true,
> +                                        lruvec_memcg(lruvec));
> +
> +       list_splice(&l_reclaim, &l_inactive);
> +
> +       spin_lock_irq(&lruvec->lru_lock);
> +       move_folios_to_lru(lruvec, &l_inactive);
> +       __mod_node_page_state(pgdat, NR_ISOLATED_FILE, -nr_taken);
> +
> +       __count_vm_events(PGSTEAL_READAHEAD_FILE, nr_reclaimed);
> +       item =3D PGSTEAL_KSWAPD + reclaimer_offset(sc);
> +       if (!cgroup_reclaim(sc))
> +               __count_vm_events(item, nr_reclaimed);
> +       count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
> +       __count_vm_events(PGSTEAL_FILE, nr_reclaimed);
> +       spin_unlock_irq(&lruvec->lru_lock);
I see the idea is that readahead pages should be scanned before the
rest of inactive file. I wonder if this is achievable without adding
another LRU.


Thanks,
Yuanchu

