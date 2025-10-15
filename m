Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF534CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 19:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9D98E000C; Wed, 15 Oct 2025 15:08:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 491A08E0005; Wed, 15 Oct 2025 15:08:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A6F48E000C; Wed, 15 Oct 2025 15:08:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AFC68E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 15:08:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BF2E8B7CC1
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:08:37 +0000 (UTC)
X-FDA: 84001285074.08.D7778D8
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id E50B920007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 19:08:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JnZaSuoy;
	spf=pass (imf13.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760555316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QmSbXI2ApsZqfklDnKMr9/VcpSy3bad84AJw3uoOIms=;
	b=uFpFC4Exh/hDEfhUbhsKvACazHyPz0V0AUk7i9FnLedepONZyNpNhyFRYcVTmAF/73oiNX
	j4TGvWVGNb8yAns9pyeP17f7u4iM7A1QchZoxpqyV2HoVlpr2Z/1vu8Z1AI51mfj3m0XiR
	TXcCzGzh8iLbC47oQfGcqW9Y/Lf7lLo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JnZaSuoy;
	spf=pass (imf13.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760555316; a=rsa-sha256;
	cv=none;
	b=iuX1qCkGVTR6o7foSIwZxWJmCfn2VEm03BB51IPtMDn/BMQ7kWkC5Pkv4dnOYi5KjouOGO
	YvcUwgdJ49jnI4B/oyt65+FAjS78lXFjkKeLeg1aQ4M18JSvfUdc2iP5LyMcwtgU2mc3s3
	WAntwCm8kcuO6An0Xh8kgRR7AsPzy5c=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-78af3fe5b17so5576217b3a.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:08:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760555315; x=1761160115; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=QmSbXI2ApsZqfklDnKMr9/VcpSy3bad84AJw3uoOIms=;
        b=JnZaSuoyGbZzfuLnLh5t3IBzPutSDZ7ND7tKcuOvePBWiYt0xOp8H0GmCu5y49zlgA
         VpRJQIgyMef6WyVElHhZoblSOuoCiMuDZFqJ8rxpeJ+urQsygZ2xpZcOpKL7rDALczpG
         4U0zqhs9A9VFOoveRXsJJ0MLbP4SHUB5wfxn4LOGh//mKgG0jhCnpBUVuBiEFS1lqQmY
         8VKCm1oe1dh1QhJNHtyBhdwy1CBrAibQcMLK5M1cgPXUSQ2p2B2G9y4/gLyj3JYNzPZF
         Onn7zgtz7ZSc3yI1U+gNAGRvg5M+zEU4CzykW6k3bB7ltODrXSHEwuUeJeSj0BUSHBZX
         hHaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760555315; x=1761160115;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QmSbXI2ApsZqfklDnKMr9/VcpSy3bad84AJw3uoOIms=;
        b=d9l2oVx+rSDVbq5bBX+s5ufOMdfQR6Mp4gfudWJJNZuVRZK4OpK64CvRSZqrAL+vi5
         cprVb+PCH0pCyLrjLfkpmkCc5D0samOFLuIKvYSf484+JpAkle40pETi1GTsOhS6uJU0
         AuOE0VwwUiaFL/kYTa9fEzz3S9DJd1nU7xIVqMgRgDvBjwQ/5HpYn/lFpHHr7scWc97B
         Q7QqxYpJdm0ISRJCVI6yGbvWtpHBdCJnev4ZOS/F3AbKHm7Hz12doGHKrdqFmKEU/1X9
         fiIRQaSHiKOvPT0bJVTNZOJrUBZ8wIqIuMS7+H7w+Xrkxq00JFIe7ZGTb0IRYCS8eddh
         fnXA==
X-Forwarded-Encrypted: i=1; AJvYcCV3GHAtM6T1y9KD5D8/ShZwEdn8SmLObyrddEmrNJBKlQb2PpYSFN8CTlXi20j3J5q1eirD0/Oekg==@kvack.org
X-Gm-Message-State: AOJu0YyHbDTPjktyuZE9ZrRkrmQL8Lg2xgEgGx0dN1bEviNUDxz24nFa
	ZBYNPXldZvMQcJsG2EX0u87WeSeHboeh/CNSIeVhdm27zRK36uxIX1jC
X-Gm-Gg: ASbGncuqU3dVWa9CVOqLU54G7V4ZlN6Jdk2fxbGEpI0NffT5Dej2VYmkG8D+6+674IC
	GEni6PabJAwoAzEgklUavXHTCb91oqYUzXQAA93QUvh/m1+ruAJlzr/0Qobd/lxtwHJ5wCuV7CE
	bbnv1RopsYbVRp7AYQO0YGj9f04osoc/GKJYnEDohKtwc/Rkq6Z5pRaU3VMnEy4ezXCXs5DXwcf
	Xo8ZBHANIzkcvGJPSgin/oIz6MKGQbOxLOAEa/5p1SyigORXTOK/Nu6HrwhKzD7mIdLsK+PWRw6
	hfW6scE4uQ5zsxXId6t7ohfk2b6HF8MfssO3hLOikqCvLoyDzcrXAqqK3ApbsDK9MzjM3C5e03P
	DkjDbAFebOsTgtsErrm+jiw3Ow8giwqwyeEWisMhABRuuYAi0o9D7JuHBH2/dGKn+5JtGCQ==
X-Google-Smtp-Source: AGHT+IHMSB7YdnX8tgv3hAnoptITEW+v5c6/QGjesZK24TcZjCmiCjAy3xCUPKMz1WHLBr4gr+e/lA==
X-Received: by 2002:a05:6a00:1884:b0:77f:416e:de8e with SMTP id d2e1a72fcca58-79387efb06cmr33823101b3a.26.1760555314450;
        Wed, 15 Oct 2025 12:08:34 -0700 (PDT)
Received: from jpkobryn-fedora-PF5CFKNC.thefacebook.com ([2620:10d:c090:500::7:1069])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d5b8672sm19483106b3a.69.2025.10.15.12.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 12:08:33 -0700 (PDT)
From: JP Kobryn <inwardvessel@gmail.com>
To: shakeel.butt@linux.dev,
	andrii@kernel.org,
	ast@kernel.org,
	mkoutny@suse.com,
	yosryahmed@google.com,
	hannes@cmpxchg.org,
	tj@kernel.org,
	akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 0/2] memcg: reading memcg stats more efficiently
Date: Wed, 15 Oct 2025 12:08:11 -0700
Message-ID: <20251015190813.80163-1-inwardvessel@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m91qspy89mk6jbjpszxbszmq5gxbcjgg
X-Rspamd-Queue-Id: E50B920007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760555315-967009
X-HE-Meta: U2FsdGVkX19sseufI20xXfczmzDKMtHdyFj42aoid+mWP1lp2Jj/F6LSXws/iY+rjvLtxSlNm1TQLyXCNaYOfQZOEGcb5CIQlUf9l+CATDAD9iDaYnwBbWfayRQUk7AEFQurH6XqHgwCXD47HC2/5HolgxuPQpAHGssF9MBRjRSCNtIckszEuOHPYpHvfmcODlh6PxenMWhC8suQsrLGMIzv+uUTnVk99BbGN5oqOkPjeAjoPwzicQuriJCpDy//qksQQNdBoXOnGVDmelB7vKjmSFiLR9hXalYLeVeA4DcDzNFEBSXMSvL0Za02iOEpHbT6D9L/duVWpRKwWa3tpOUV7/0K0OFk9ZI+Ws+LOZummGHgh/MG/IV8EnouemPV+l92nYVlHWh385Ocrs1dbpjVtQo97bn0R25RHQYqlFVujqErlQDb4vIJTFV8DF6qKynBMJVK6cHv13ZRCaid/J4Kl/ilEofgKFPvhDUx6FFflH3+e0Puk0QlEvXP+YhPEoUguGXqjm/gAF5Icd7Kkb4RQN+Nvs53qr223bguBbKccrKSn5fCkwJQK2EtCAegbzVa748QiCI0ytz/nPnCIMy5kBTwnXQwfJ3XjkN3n8taRiMaTJ7iNsiT7R1La2smWX7I3KO//83r9C2SpOYppamV2XkkbWY/gAIZmXl6IGSPiPRclKl5at9N+U5PvVf+gN1S0c3gZ+N0Uw1JNc9IuVTIpXDOALUpmdt/Jv4P2+T3I6DvA6RusSIcsUTeVltTiC4Dj83jHjE0n2BJJYkZi7PnP6ycPed69bK8GvgSiJqKQnqE5fY1cfiNzCERHp7Y/YD+W8bbAS3tggvw7QazX+hh5uJ79h7u49hB2zOpaSrmJKjPcVyEDHp1sFxQYFuBHIlp11bFqFiH4HN9tDXgSxwn2ELKQE8fzL/tAQF99XkmLvhMJAKmNZMxJUUi89/9CSnT6Z0BIbjhr3mlMkV
 e8M7znr6
 jyZ2Etp5dCK2/FM5Ga6KpXgjWNYK1v1TsVsyCNr+dPhhzF85f+Ffxbmac41qyw9Jm6QFNvrUhSJo3/3Z1AJpoUerQkH+43SMng/2ux785Imislo9KfV32XiJ7gnmd0ps+FMw+J396TrUyTVLUgF1etr5Mug+zkdWVBw/JnCGHzv2uRr9xWVRGfcIR91IDyy3Ti4AGopM/7WG3nUF3BATrFavpKzfjov4nYbJlqEfRvryfSIZ0Ga2usIm2m9wAg8augmr30MCVoPJCQk2L7Ox1E+HleVoVpR3bg6I7PBRju1VBvC8LO6N+kPxq0RR1E5pAYmyd9R+Jjuy1WsHO+6ySN915yMJVqjNnPhdahB4qRkENNAD+o/k8MxLWjAuwfGBZf9dKCS3tirPEJLwEYP88cFp2zN28rB70K0F1Dys/YFTreEgG+WCzk2O11Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When reading cgroup memory.stat files there is significant kernel overhead
in the formatting and encoding of numeric data into a string buffer. Beyond
that, the given user mode program must decode this data and possibly
perform filtering to obtain the desired stats. This process can be
expensive for programs that periodically sample this data over a large
enough fleet.

As an alternative to reading memory.stat, introduce new kfuncs that allow
fetching specific memcg stats from within cgroup iterator based bpf
programs. This approach allows for numeric values to be transferred
directly from the kernel to user mode via the mapped memory of the bpf
program's elf data section. Reading stats this way effectively eliminates
the numeric conversion work needed to be performed in both kernel and user
mode. It also eliminates the need for filtering in a user mode program.
i.e. where reading memory.stat returns all stats, this new approach allows
returning only select stats.

An experiment was setup to compare the performance of a program using these
new kfuncs vs a program that uses the traditional method of reading
memory.stat. On the experimental side, a libbpf based program was written
which sets up a link to the bpf program once in advance and then reuses
this link to create and read from a bpf iterator program for 1M iterations.
Meanwhile on the control side, a program was written to open the root
memory.stat file and repeatedly read 1M times from the associated file
descriptor (while seeking back to zero before each subsequent read). Note
that the program does not bother to decode or filter any data in user mode.
The reason for this is because the experimental program completely removes
the need for this work.

The results showed a significant perf benefit on the experimental side,
outperforming the control side by a margin of 80% elapsed time in kernel
mode. The kernel overhead of numeric conversion on the control side is
eliminated on the experimental side since the values are read directly
through mapped memory of the bpf program. The experiment data is shown
here:

control: elapsed time
real    0m13.062s
user    0m0.147s
sys     0m12.876s

experiment: elapsed time
real    0m2.717s
user    0m0.175s
sys     0m2.451s

control: perf data
22.23% a.out [kernel.kallsyms] [k] vsnprintf
18.83% a.out [kernel.kallsyms] [k] format_decode
12.05% a.out [kernel.kallsyms] [k] string
11.56% a.out [kernel.kallsyms] [k] number
 7.71% a.out [kernel.kallsyms] [k] strlen
 4.80% a.out [kernel.kallsyms] [k] memcpy_orig
 4.67% a.out [kernel.kallsyms] [k] memory_stat_format
 4.63% a.out [kernel.kallsyms] [k] seq_buf_printf
 2.22% a.out [kernel.kallsyms] [k] widen_string
 1.65% a.out [kernel.kallsyms] [k] put_dec_trunc8
 0.95% a.out [kernel.kallsyms] [k] put_dec_full8
 0.69% a.out [kernel.kallsyms] [k] put_dec
 0.69% a.out [kernel.kallsyms] [k] memcpy

experiment: perf data
10.04% memcgstat bpf_prog_.._query [k] bpf_prog_527781c811d5b45c_query
 7.85% memcgstat [kernel.kallsyms] [k] memcg_node_stat_fetch
 4.03% memcgstat [kernel.kallsyms] [k] __memcg_slab_post_alloc_hook
 3.47% memcgstat [kernel.kallsyms] [k] _raw_spin_lock
 2.58% memcgstat [kernel.kallsyms] [k] memcg_vm_event_fetch
 2.58% memcgstat [kernel.kallsyms] [k] entry_SYSRETQ_unsafe_stack
 2.32% memcgstat [kernel.kallsyms] [k] kmem_cache_free
 2.19% memcgstat [kernel.kallsyms] [k] __memcg_slab_free_hook
 2.13% memcgstat [kernel.kallsyms] [k] mutex_lock
 2.12% memcgstat [kernel.kallsyms] [k] get_page_from_freelist

Aside from the perf gain, the kfunc/bpf approach provides flexibility in
how memcg data can be delivered to a user mode program. As seen in the
second patch which contains the selftests, it is possible to use a struct
with select memory stat fields. But it is completely up to the programmer
on how to lay out the data.

JP Kobryn (2):
  memcg: introduce kfuncs for fetching memcg stats
  memcg: selftests for memcg stat kfuncs

 mm/memcontrol.c                               |  67 ++++
 .../testing/selftests/bpf/cgroup_iter_memcg.h |  18 ++
 .../bpf/prog_tests/cgroup_iter_memcg.c        | 294 ++++++++++++++++++
 .../selftests/bpf/progs/cgroup_iter_memcg.c   |  61 ++++
 4 files changed, 440 insertions(+)
 create mode 100644 tools/testing/selftests/bpf/cgroup_iter_memcg.h
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
 create mode 100644 tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c

-- 
2.47.3


