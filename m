Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D551E67A8D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 08:05:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E8C6B0088; Tue,  3 Mar 2026 03:05:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF6AB6B0089; Tue,  3 Mar 2026 03:05:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCB606B0092; Tue,  3 Mar 2026 03:05:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A62316B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 03:05:44 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6EDC758A30
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:05:44 +0000 (UTC)
X-FDA: 84504017808.08.E5F4E54
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf17.hostedemail.com (Postfix) with ESMTP id 731E440004
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 08:05:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TFGevwh/";
	spf=pass (imf17.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772525142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z6A4UPYtsF+nMG1/KG1agiPVqk3rBywGcRMadkU0YXw=;
	b=rNQtt4QhFgLu1k3sRLsM2KzgeymNG0lPKb0UY/5eZsJzycN73Gs736sdW8uh09nYIaGheW
	vLhBPPxQJkoBaPlgBV9BSOmnLj3TLN38UQM/tgCPuYcaeum6nct2BVm1dNR5HFsPYa/4Ek
	uOC0Kmpv3ukCPkV39WLPEhFUsyx0XFs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="TFGevwh/";
	spf=pass (imf17.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772525142; a=rsa-sha256;
	cv=none;
	b=QoRNL1fbhrWg5GR55Mb5ccyzpTPX+/3dJqvqO5q++kaT2QukrjNKuxMwbgSuP1OX7dVRuk
	SV1D2g6NIj0yWH3bDHjX8cXKLhNJR9/dwgGG0M9pSglBf4vez0t0nKoPI32M+y6Ly65oYb
	h+FzPCkPe6S8OkfPhjUpSAsGEp0qERU=
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-2adbfab4501so23988975ad.2
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 00:05:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772525141; x=1773129941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z6A4UPYtsF+nMG1/KG1agiPVqk3rBywGcRMadkU0YXw=;
        b=TFGevwh/t4ig69HuEkVw8iI3iXcO72kEENMyqIevPSHU78r81bTrL+FIzGapXn5CBq
         Ml5GVQMLK/VDmuqjeYf8rVv9qjCuRXTpZbV4XFfsOhNUe9NVaz7cKkM5ncdA548b4H4/
         8eUCxd652glKZgL0OHQB8uwNwE+OqSvlC/HP71I+NFacMrZ1GLRPFl7AcSIq8fBRBQIR
         XN7AuH5DCgwz8wUGTirPugdrFNlbDiPACwqr81Rvg4eZxgdMOQCJhvfXZw/Ui8turl0h
         L+bqAx9u/ueH4K9FoFcaCS23FkjTgNLL253u+2KyazkAv6EoRZ/xINBRIzv/YZp5LDlR
         yePA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772525141; x=1773129941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=z6A4UPYtsF+nMG1/KG1agiPVqk3rBywGcRMadkU0YXw=;
        b=VxLkXbj0zEoQU800hUx4fPmzgzQI4t2RErC7bCsM6YSfZYSMYkBCs0JLA37WiWffRw
         mk4kOy8VXAgH2CRQ+iJ53ysEwyUs/26dDWZQQMjrqLAiyBN3lGX/Pma/Gm21pdEO0FwP
         EGnbuWGEVN4fDd/q5BwZ3uwDUiBUbr+13FpwBEsz1bbnEXzJm7TYHL8Fc4B1G36yXV3p
         eD5ayUSW03hUi8cn7p2ThHSwjsjfVprsU1dy2peFlCVUKKLSrRuUVLYNu+DD/LUFpO/r
         OlUJ1x+6RSimwyxfSgDUF5EkZRu+14B5pWJz9JVFcCA31izyxQ60g6MCmL7QEq7D7FVJ
         GQEg==
X-Forwarded-Encrypted: i=1; AJvYcCXxEe8DKjfI0pUQZ5YQRR7npJMJxo1L5j8leMZdaN3CAdA4jCwbFD2KAGDuMLBayTY3iR+F9J909w==@kvack.org
X-Gm-Message-State: AOJu0YzTI9GDw/qZ4iMZMAMbMbljMMlMYmnujeOm/cp8okFlkz+zGYeW
	fU1IFnmhFvh41L3M90JgSmCL4u7yaod5uzTIMFmVajr6VMsizm9dOL6P
X-Gm-Gg: ATEYQzxfEx+WlzKdeyCGoa8pCx9o63URxHipUk8UZ8oWd2DRmi1VojXl8P0m/qEteRo
	6zBE1ljYVEC8vSTDQujjqxS434k39GGKr7IBFArJWS6VK6MB4CVMEU0sQDtZB40QMni1jBWduRO
	7lCjaKHV3RAJ7lToG/87kzTHoErNCQS4oaSWG/Kr+M6SV2ecmfKkBJoOAxgEEM5MvO/ZZim2LhF
	PCItwiY1Vw8nNnPlF/2WzES80GPoFkpfvCUmgt0s9WvhNkDWagBW6VRnMiBDqeIg3FNyarsMxrc
	pJH4S8Wy5d8Gs5WJyAoobwXS4tc/hURgR2JvUAcXdy92tvPq4oXpyy1v8VAvtXNtgeS7mtk+b9V
	iFbFfIn6rf5Xzeq6kWHmTJGhKQd/nD/iBZoBFFXAPnjPNnWyllTLu/eco1oDZ8BpEElOB7QeXTV
	/9Hmr1sJ0Odi5O5ApubnCJtCtGDC6jcZy/DJj3tOPeVA/xXAXkUrAP+VZQgAez
X-Received: by 2002:a17:903:2a8c:b0:2a9:484c:ff2f with SMTP id d9443c01a7336-2ae2e41a1d8mr126883495ad.23.1772525141150;
        Tue, 03 Mar 2026 00:05:41 -0800 (PST)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:d4d9:ac80:4245:fae4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ae4651e409sm88519795ad.44.2026.03.03.00.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 00:05:40 -0800 (PST)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: 21cnbao@gmail.com
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@suse.cz,
	weixugc@google.com,
	yuanchu@google.com,
	zhanghongru06@gmail.com,
	zhanghongru@xiaomi.com,
	ziy@nvidia.com
Subject: Re: [PATCH 3/3] mm: optimize free_area_empty() check using per-migratetype counts
Date: Tue,  3 Mar 2026 16:04:20 +0800
Message-ID: <20260303080423.472534-1-zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CAGsJ_4wCeLr6KOTU=Pc4ALeq5x-i0C7i6C3cSddexHw2ADSnng@mail.gmail.com>
References: <CAGsJ_4wCeLr6KOTU=Pc4ALeq5x-i0C7i6C3cSddexHw2ADSnng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 731E440004
X-Stat-Signature: uhxxfkcz7ct4dzs6oyzfm99g5g9myqyu
X-Rspam-User: 
X-HE-Tag: 1772525142-184637
X-HE-Meta: U2FsdGVkX1+jqkhMdlHWHzToQKJjjs10RoV4Dj/0YEw1NmI/uIryM5Dz0saj66NLFpD+6cYJVylK1hp/nlJ6Zi2FP+LNxQtBPz4OwyVfaYgl5MludCCtWXFv7fVNPDNmWN+WGxwtOtOtwf4kNKhVCNYur/Q8j1OyxuSNLgdaZN7B2BRyGz/nQuUrKCVp4ShQ5hsWfxpsbqQOIlfb0vN+1wtYIy3aqoOXjkotb6wa85TftDaFpw/U8ecisOq2q8/EA9LP3PfEN/kAxj0JXUHce7dCEDiZSOJk3WPhmztJsnH660rbZ4PcYeN19cNlcyuJy0lu1pGaVOPeRvwbt2jNGxknxZa4IMwA5rIWZkhz8L8KfI1TFePdty7VJWvcPUKJxC8zynJmWTdwXbwhCAYb3TWmLyrN+z7NTcz+BIjobqNOOlQFvVafhWvIGXUeOC//X2i6XfbZy5PwHToR6JAxrBkR4XRWbS3yf8KYuCTal9IVtus7O/VYGCb8RpkTrxPHXvzsUm8eYJ6l2svelHty7IQQRqSIje5VBfi0z4DBPv0OaeI1KVbZKskOmS5QCR2s9vfT4HctDqW9s++SEtXMRxX+aO7bvG/5MHZpoU5ZgDTfsX3Qec+LJ/TlAL2GXv/dwoys6oC4OPFKek/lDSlLznMtwikaz30Ef7W2CsbyX567qOYF9IHVTOVcrLVXPr3+FBtbZBNI+IXJomsOod3XIDyMrFAXV/kskZXmbfAoz6ehDdkW0QvzAJ3DrcdfWk7HOHLFckFeeQEkmR7vDZCoxvs6CSZTBdSLqCB4NfL6yXLbkJb9pCJzEOSj1jM3QjBdrY4RANEh+4PeBIl1+w1znWia7/9+XoEt6Jj2pEa+znqNYYaQHh0lHtyXQWrhqx9ZGo0bVesVJzwfv7ylXBIDv0OWG72C02x1/9b8ksohaBerXZqn4/j3Glql3x4t47iXlsbnBmeXTNz+eWdH66w
 gDKpcsBH
 RNg58+Ye1VL6XQW+qHHEcLWLyajZfBoX1GLloUfJCubHp1QLhxLaymE2+G2aH/y+CSB0opxMkvsX+VbGgkNnvMWLSFZy3wvfRIgWKx4q+Ku3ixuilm/QBvSFsTHECRq/hLqpcHtt6ZM6fIsPOXLFfhgnfaXDzVqJq26nRK2QZUCjTRpFc6gbuSHUQKI5OwFpKofowiUbKFqE6DAxvH4iNahIAKi8l/4mcC/ZmbOeVMxzROFXd3yqWnpC1BblUeEyL4aET8inqx1ClhjZEsS5qunvuymj8KDTvwpKe/IMCw1OeIXLaUjV2QdjjeWEi5fjeeBzmTxDB+rsKaZca0QYV5DOpVkFiHqWE8hhIzmX4cCGidleauom13Is4VVjQdkxfGWEb5EoKED1YELsD34xdN6pU2M7ooPD6ffBSZm32+ZkH7IJrxjk8MXZm9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Sat, Nov 29, 2025 at 8:04 AM Barry Song <21cnbao@gmail.com> wrote:
> >
> > On Fri, Nov 28, 2025 at 11:13 AM Hongru Zhang <zhanghongru06@gmail.com> wrote:
> > >
> > > From: Hongru Zhang <zhanghongru@xiaomi.com>
> > >
> > > Use per-migratetype counts instead of list_empty() helps reduce a
> > > few cpu instructions.
> > >
> > > Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
> > > ---
> > >  mm/internal.h | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/mm/internal.h b/mm/internal.h
> > > index 1561fc2ff5b8..7759f8fdf445 100644
> > > --- a/mm/internal.h
> > > +++ b/mm/internal.h
> > > @@ -954,7 +954,7 @@ int find_suitable_fallback(struct free_area *area, unsigned int order,
> > >
> > >  static inline bool free_area_empty(struct free_area *area, int migratetype)
> > >  {
> > > -       return list_empty(&area->free_list[migratetype]);
> > > +       return !READ_ONCE(area->mt_nr_free[migratetype]);
> >
> > I'm not quite sure about this. Since the counter is written and read more
> > frequently, cache coherence traffic may actually be higher than for the list
> > head.
> >
> > I'd prefer to drop this unless there is real data showing it performs better.
>
> If the goal is to optimize free_area list checks and list_add,
> a reasonable approach is to organize the data structure
> to reduce false sharing between different mt and order entries.
>
> struct mt_free_area {
>         struct list_head        free_list;
>         unsigned long           nr_free;
> } ____cacheline_aligned;
>
> struct free_area {
>         struct mt_free_area     mt_free_area[MIGRATE_TYPES];
> };
>
> However, without supporting data, it’s unclear if the space increase
> is justified :-)

I designed a test model to trigger more false sharing and collected data under
it to see which layout performs better.

Test model
- Based on the microbench that was removed from mmtests
  Commit: beeaeb89 ("pagealloc: Remove bit-rotted benchmark")
- Goal: Generate concurrent kernel page alloc/free activity across multiple
  orders and migratetypes to observe cacheline sharing and contention in the
  buddy free_area
- Mechanism: A systemtap module exposes a write-only
  /proc/mmtests-pagealloc-micro. Writing a 64-bit encoded value triggers
  repeated page alloc/free in kernel space
  - bits 7:0   -> mt (0=UNMOVABLE, 1=MOVABLE, 2=RECLAIMABLE)
  - bits 15:8  -> order
  - bits 63:16 -> batch
- Workload distribution:
  - order = cpu % 4 (orders 0/1/2/3)
  - mt    = cpu % 3 (UNMOVABLE/MOVABLE/RECLAIMABLE)
  - cpu0 and cpu1 are not used for the test
- Sampling:
  - load stap
  - determine encoded value according to cpu id and bind it to the cpu
  - after a short delay, runs 'perf mem record' for 100s
  - unload stap
- Test tool:
  - https://gist.github.com/zhr250/72e56f87ac703e833b11b5341d616cb0
- Data analysis tool:
  - https://gist.github.com/zhr250/f4a385ffa9fae2993d22748f31e18588

CPU topo info of my machine:
  Package L#0
    NUMANode L#0 (P#0 15GB)
    L3 L#0 (25MB)
      L2 L#0 (1280KB) + L1d L#0 (48KB) + L1i L#0 (32KB) + Core L#0
        PU L#0 (P#0)
        PU L#1 (P#1)
      L2 L#1 (1280KB) + L1d L#1 (48KB) + L1i L#1 (32KB) + Core L#1
        PU L#2 (P#2)
        PU L#3 (P#3)
      L2 L#2 (1280KB) + L1d L#2 (48KB) + L1i L#2 (32KB) + Core L#2
        PU L#4 (P#4)
        PU L#5 (P#5)
      L2 L#3 (1280KB) + L1d L#3 (48KB) + L1i L#3 (32KB) + Core L#3
        PU L#6 (P#6)
        PU L#7 (P#7)
      L2 L#4 (1280KB) + L1d L#4 (48KB) + L1i L#4 (32KB) + Core L#4
        PU L#8 (P#8)
        PU L#9 (P#9)
      L2 L#5 (1280KB) + L1d L#5 (48KB) + L1i L#5 (32KB) + Core L#5
        PU L#10 (P#10)
        PU L#11 (P#11)
      L2 L#6 (1280KB) + L1d L#6 (48KB) + L1i L#6 (32KB) + Core L#6
        PU L#12 (P#12)
        PU L#13 (P#13)
      L2 L#7 (1280KB) + L1d L#7 (48KB) + L1i L#7 (32KB) + Core L#7
        PU L#14 (P#14)
        PU L#15 (P#15)
      L2 L#8 (2048KB)
        L1d L#8 (32KB) + L1i L#8 (64KB) + Core L#8 + PU L#16 (P#16)
        L1d L#9 (32KB) + L1i L#9 (64KB) + Core L#9 + PU L#17 (P#17)
        L1d L#10 (32KB) + L1i L#10 (64KB) + Core L#10 + PU L#18 (P#18)
        L1d L#11 (32KB) + L1i L#11 (64KB) + Core L#11 + PU L#19 (P#19)

Actual (order, mt) distribution on my machine:
  order=0, mt=0: cpu12
  order=0, mt=1: cpu4, cpu16
  order=0, mt=2: cpu8
  order=1, mt=0: cpu9
  order=1, mt=1: cpu13
  order=1, mt=2: cpu5, cpu17
  order=2, mt=0: cpu6, cpu18
  order=2, mt=1: cpu10
  order=2, mt=2: cpu2, cpu14
  order=3, mt=0: cpu3, cpu15
  order=3, mt=1: cpu7, cpu19
  order=3, mt=2: cpu11

Different migratetype/order combinations are placed on CPUs that do not share
L1/L2 caches to maximize cacheline contention. For our test goal, I think this
distribution is relatively reasonable. I ran 10 rounds for each kernel and
found the data to be stable.

Layouts tested (capturing load/store samples in free_area[0..MAX_PAGE_ORDER]):
- vanilla kernel:
    struct free_area
    {
            struct list_head free_list[MIGRATE_TYPES];
            unsigned long    nr_free;
    };
- patched kernel:
    struct free_area {
            struct list_head free_list[MIGRATE_TYPES];
            unsigned long    nr_free;
   +	    unsigned long    mt_nr_free[MIGRATE_TYPES];
    };
- mtlist kernel:
   +struct mt_free_list {
   +        struct list_head list;
   +        unsigned long    nr_free;
   +};
   +
    struct free_area {
   -        struct list_head    free_list[MIGRATE_TYPES];
   +        struct mt_free_list	mt_free_list[MIGRATE_TYPES];
            unsigned long       nr_free;
    };

summary:
+---------+-----------------+-----------------+------------------------+---------------+---------------------+---------------+
|  Kernel | inrange samples |     HitM (%)    | L1 hit inc LFB/MAB (%) |   L2 hit (%)  | L3 hit inc HitM (%) |  RAM hit (%)  |
+---------+-----------------+-----------------+------------------------+---------------+---------------------+---------------+
| vanilla |     192,468     | 45,421 (23.60%) |     94,486 (49.09%)    | 1,952 (1.01%) |   91,240 (47.41%)   | 4,790 (2.49%) |
+---------+-----------------+-----------------+------------------------+---------------+---------------------+---------------+
| patched |     227,196     | 27,293 (12.01%) |    165,238 (72.73%)    | 1,194 (0.53%) |   54,609 (24.04%)   | 6,155 (2.71%) |
+---------+-----------------+-----------------+------------------------+---------------+---------------------+---------------+
|  mtlist |     240,694     | 50,911 (21.15%) |    132,827 (55.19%)    | 3,165 (1.31%) |   98,556 (40.95%)   | 6,146 (2.55%) |
+---------+-----------------+-----------------+------------------------+---------------+---------------------+---------------+

Detailed data:
- https://gist.github.com/zhr250/2ccf8902080ecaf85477d9c051e72a96

For both L1 hit and HitM, the patched kernel is the best among the three.

In this test model, I also collected memory allocation counts. The patched
kernel delivers the best performance — about 7.00% higher than vanilla and
4.93% higher than mtlist.

Detailed data:
https://gist.github.com/zhr250/4439523b7ca3c18f4a2d2c97b24c4965

