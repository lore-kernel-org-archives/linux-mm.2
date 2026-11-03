Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65B42606A336
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 22:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=pujvRNNk
Received: by kanga.kvack.org (Postfix)
	id 8AA9E6B00EF; Tue,  3 Nov 2026 17:31:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 836196B05B1; Tue,  3 Nov 2026 17:31:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB9A6B05B2; Tue,  3 Nov 2026 17:31:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3152B6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:31:54 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 914901205A4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:31:53 +0000 (UTC)
X-FDA: 85395256506.18.5C59846
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf16.hostedemail.com (Postfix) with ESMTP id D7885180006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:31:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pujvRNNk;
	spf=pass (imf16.hostedemail.com: domain of 31WDqagcKCJ4LFSFS8LEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--nhuhuan.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=31WDqagcKCJ4LFSFS8LEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--nhuhuan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793745111;
	b=yKb/vAEvpp7K/m5t4j6YUKcaBh4N1UXDqOtOnZ//tMyzBuDxudf5FkTHI8zC0uNSQhy7ln
	W6dV7jOePC2+fd9HMTd6WEABNbGrNEAfC5CslEDU+/AAcbOHj07TQoIn/Jy1YxWNJwIoJL
	5OmWncOLD43ZFfpSJ9UPkIgm/aYTJuc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=pujvRNNk;
	spf=pass (imf16.hostedemail.com: domain of 31WDqagcKCJ4LFSFS8LEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--nhuhuan.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=31WDqagcKCJ4LFSFS8LEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--nhuhuan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793745111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrTX3wJjILuApgcUkXldz9A0fDSI5dqDukx6+R/xaJI=;
	b=BB+IGZJIA2Lk/gKOXdBJ0S6STEbEGLPB8imulLQuomnCgr+2oS9nXbjD0mQbdykl2ZiwPD
	xrXUkNUlalXqkHf2F6hhEd7/aWAwgdzH1NTJLRpmh5YBA7U//idETIMbX0J3v79iG+bvCE
	0PJbrJKwckeCBpaiB1X5ah6wFbui/v0=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-30c0d568830so49525eec.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 14:31:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793745110; x=1794349910; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BrTX3wJjILuApgcUkXldz9A0fDSI5dqDukx6+R/xaJI=;
        b=pujvRNNkHGK72FdUnLlUAFoCzKeXArAKjCZpdhwi9SMFO1OnUh6L6jMLG/5M7+/v65
         gLsh+vipjPzSplHM7OduRS88wMlxpyaPrsud+DU16PlQ2vepPolcOUYJ6ttYSHkkw/Cu
         1pXyD89zt5UxGoXpn0YJ2L4JAqor/W1w/RppQj76bIljWDiDV0iuPFt37C8RcEEmFtIM
         if5Xe6cHcce4djSQNZsOLKpd+e0j9LTYV7W0ivAhGgVGs1Pk19jo7jIwfRFnmm+BcSbo
         P0Yk1bTTRUt+/lnYF13Bfyhxy4MbQG50v0HO8Z4VSVUqq2Eq2h0CNZUUPmBOHV+1mIkA
         /BVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793745110; x=1794349910;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BrTX3wJjILuApgcUkXldz9A0fDSI5dqDukx6+R/xaJI=;
        b=zrDEgEjMZEyaV5mkpz7Cu38VO0znsk9+pLpnzFIiDJrNuVLWLMeDX6vBLTjBSqhDbV
         zOJmY1AUHFMx74OnLcD/+rYu6Y0zpI+exbinTF8pSLMHXRiHWqkVk4TnOYCy0SW0PbJA
         htOmXRd+5+vkb8l7rkJuVDAYhOt3XZgLT2Ba0D0ekflONfwPCU9D14CP0k1eVZ5sO+YM
         Q/MEI7s1TBXTmwJ3eWOXES7f4opbHtEfx/prulp2fIYU9TA4lxBJLGoDMhvJJ+AKHmwR
         mHS9VDEPQzsfvh5WvB1qCTqjjW6Se/rAivFWlC+uaTCIx/f3zVkzm+R5prAot5bSb8MR
         3tdQ==
X-Forwarded-Encrypted: i=1; AKwUvBy5779YVy+elTbDGvL5HIDkPHbjyp/N89xK0UZgh1RfgLFU7rloADmaT5vAauAhY1s36DZAgdNTzg==@kvack.org
X-Gm-Message-State: APuU4Z8+5zK6+1CORfWcN+X0A+dm6K05JZ4ep3ZudWQFBUuUMy9AuX04
	3RYIC0XFyU1gzl106U+9DHOFSYmi+hRd8zNQZGml3PmxSeHhJAyL5ukIT3WSsDYICHfaNl6Eeqp
	gh5rdgczwVg==
X-Received: from dlbsv7.prod.google.com ([2002:a05:7022:3a07:b0:1b2:3bdb:f218])
 (user=nhuhuan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:701b:4244:10b0:149:1b5b:1f25
 with SMTP id a92af1059eb24-1ac5b211405mr22122314c88.15.1793745109795; Tue, 03
 Nov 2026 14:31:49 -0800 (PST)
Date: Tue,  3 Nov 2026 14:30:22 -0800
In-Reply-To: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
Message-ID: <20261103223025.2482227-1-nhuhuan@google.com>
Subject: [RFC PATCH v3 0/3] mm: use non-temporal stores for demotion
From: Huan Nguyen <nhuhuan@google.com>
To: tglx@kernel.org, mingo@redhat.com, bp@alien8.de, 
	dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, trondmy@kernel.org, anna@kernel.org, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, rostedt@goodmis.org, 
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, jackmanb@google.com, 
	hannes@cmpxchg.org, shivankg@amd.com
Cc: rientjes@google.com, dave@stgolabs.net, nifan.cxl@gmail.com, 
	fvdl@google.com, jic23@kernel.org, rkodsara@amd.com, bharata@amd.com, 
	sj@kernel.org, weixugc@google.com, xuezhengchu@huawei.com, 
	yiannis@zptcorp.com, yiannis.nikolakop@gmail.com, 
	dimitrios.palyvos@zptcorp.com, alirad.malek@zptcorp.com, ryan.roberts@arm.com, 
	nhuhuan@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-nfs@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D7885180006
X-Stat-Signature: thmwmg5jzuc1tcre5rit3cebpps8uucg
X-Rspam-User: 
X-HE-Tag: 1793745111-775272
X-HE-Meta: U2FsdGVkX1908Ts1D0sJ/tQgSCYtJULHdlCIH4jqbtdN9Xxfd5ftZcGp0QBBe74ALkmpYkeF6PLFE5cQponQCccQM2fPEQ3EODSt4QtA6EYheuyoDMAMkj6HTOowEZdKor4WWMSC1Sgjqs9zk/Xn92RENokZu597QgGdmqpVx11nqwADC4piSitmS00srGa5jTvWo2XU1rNVqRPY4/+dPH1jZD4k1mdB76+Z1UbMHftfBF6cYXmUwuuYx/noL4JnmnKzqeiuI0cFVkktI/9z48PrH7WBlWoNu0yCSz23aZvOR4aG7wqfwxtJM6JrYLt28geeQOARqutcYwREnW2PQffnnCDRAIhfvHbAQpFFfk0dDv3jv6onEdwTzuJ8Kkp5wCH6ZOx/3N+AKyT6CuK/H5SEARc2xCv3H+RWJnmVV3edlLD6bh/aWUnpbmbVE9JMtG0wUd0gJ7ORRFlthQGfyP9Mg0Dy14i203yCTtqwwKx5SU0tefrQVna6vo6tTQONjXweCrGCtzzKD5nKeQQkXeq+sE7Dv+Lcc+4CaKK4598s8fk16jorq7LasIHy26enBVLSmCDu0SSlWFFMEqoYMso35I5iw9jYhRfGOpuBMhDrUBnPCD3rI/PNiZ7LA6cFWoWMmZgRaOms+WXTUHMFa0SJI5DvzYHTFqumQqCR0WZgCHzRNTxdj7UHI5eVUtafpUGtdm9FPU2cUrio5vUNCG/QD3wLnEHS3OUWg5ImzDSMDoYFn0o3N8JCCGJevWT2GvOvrmp/GoYIOFHKhIsuG0s+lbusq2G3wv+OYszhsSD3yvf7O0PjiilP8uoq4rsytTuzRMU+VQhrh2KHLBpksV0o71MQuDNUzO0YSmJ/NxzTR0U5Wyx5dz/6wzKDU7IRdd7zuWefko2nkXZVtyeJdJicYU4/idTKNrL31kEj9GwNqWpISexKLLA0dhTWHqS0olesFvzouF3xv8Tmp5H
 ruSOW64X
 GP7GbnWVFzBufy/l0YrLkHxQxeBDBEWVAo+RSy9QZjfkqOsUiqe20vLMwszNaT2a+Pe5v0G/jNYLGTHBjk4Wog8B1SsSlz8XblKbjacC6CWsDkq4m+9sJRmPZ33Nd5+FZ1K8m/tMS9mnE3t8s+QmUGijBLH3GIG+FAkeBm/ZnbjwPxI3K6Y/q3SE9E1v1OjEDih0uU2iDd+aZRvIROcnxATkI+gljYkDYAEK8KXLFemw6l3L9AHJUFwHZ8LWSHpiVWwCuwRJvtm0h/os0QJiK4x7Yz6gBPMWfFUNgGtKNd2j7QCuUengARQArINDKbwCGwb3lrMNdm5N3jhIzpIXUDISDilfLmQLNEBS8v7vu61xGC/TnK/vYvdveiRsjZFREMiWKFXnqg7RcBQewEQ7JJf1eIU6VFsyWXEBDP044lNekCs/fMvHRuYi+xVdHMX7WONgdtYQ/2gTYDQDtx3YNBcosYZR5Wd/LBzhe1VMpHLIotHxOqqSGuGGMLrVVkSjwJp/DeS/0/V66DMPvOBJ24Y/LYrsCWNIKunGkBfxzNHwgb6KpQDfjFtm+XmhTJKfN2Jy0mrLxGgpL5bHIYdQIXZRfDa3SXSA48WnK+rwrFdWspnrMngR+rtGpkp6kO4LhUWyWG2nh7C+Kmy0YKTtAE/rTqKzTfN73SEABtrZKTHFvgV/b5C32mC6m+Eyt5njlVZLnTW5zI8GJlEihlA8zrhdfTHdsxo5hCsuW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series continues the non-temporal demotion work originally posted
by Yiannis Nikolakopoulos [1].

Motivation
==========
Memory tier demotion moves cold folios from local DRAM to slower memory
tiers, such as CXL or remote NUMA nodes. Standard store instructions
force the CPU to allocate cache lines for cold data that is unlikely to
be referenced in the near term.

Using non-temporal stores and prefetching on x86 bypasses CPU cache
allocation, protecting active workload working sets and improving
demotion throughput.

Changes in v3
=============
- Unified MCE-safe NT copy (addressing v2 Open #1):
  Implement copy_mc_page_nt() in x86 assembly to provide machine-check
  safe copying using non-temporal stores (movnti) and prefetchnta.

- Architecture abstraction (addressing v2 Open #2):
  v2 relied on memcpy_flushcache(), which lacks non-temporal stores on
  architectures like arm64. RFC v3 replaces this with a dedicated
  __HAVE_ARCH_COPY_PAGE_NT interface and generic fallback, enabling
  architectures to plug in native non-temporal routines independently.

- Memory ordering:
  Add a wmb() barrier at the end of folio_mc_copy_nt() to ensure weakly
  ordered non-temporal stores are drained before page tables are updated.

Discussions
===========
1. Migration mode vs. migration control refactoring:
   Currently, this series introduces MIGRATE_ASYNC_NONTEMPORAL into
   enum migrate_mode. In parallel, Shivank Garg's migration refactoring
   series [2] consolidates migration arguments into migrate_control.
   Once that lands, demotion can simply rely on the migration reason
   instead of adding a dedicated migration mode and helper.

2. Large folio copy optimization:
   Multi-page folios (such as 2MiB THP) are supported by iterating over
   constituent 4KiB pages via copy_mc_page_nt(). Once the batch page
   copy series [3] lands, copy_mc_page_nt() can be extended to copy an
   entire multi-page folio in a single invocation, eliminating per-4KiB
   loop overhead and keeping the prefetchnta stream uninterrupted.

Thanks to Yiannis Nikolakopoulos, Alirad Malek, and Dimitrios
Palyvos-Giannas for their original work, feedback, and collaboration.

References
==========
[1] https://lore.kernel.org/linux-mm/20260730-rfc-nt-demote-v2-0-452dbe3b5073@zptcorp.com/
[2] https://lore.kernel.org/linux-mm/20260902-migrate-refactor-shivank-v1-9-9dcca87669c4@amd.com/
[3] https://lore.kernel.org/linux-mm/20261019-batpagecopy-v2-1-d75e7d0dfaae@amd.com/

Signed-off-by: Huan Nguyen <nhuhuan@google.com>

Huan Nguyen (3):
  mm, x86: support copying a folio using non-temporal stores
  mm/migrate: introduce async non-temporal migration mode
  mm/vmscan: demote folios using non-temporal stores

 arch/x86/include/asm/page_64.h |  2 ++
 arch/x86/lib/copy_page_64.S    | 65 ++++++++++++++++++++++++++++++++++
 fs/nfs/write.c                 |  2 +-
 include/linux/highmem.h        | 21 +++++++++++
 include/linux/migrate.h        |  5 +++
 include/linux/migrate_mode.h   |  1 +
 include/linux/mm.h             |  1 +
 include/trace/events/migrate.h |  1 +
 mm/compaction.c                | 18 +++++-----
 mm/migrate.c                   | 29 +++++++++------
 mm/util.c                      | 29 +++++++++++++++
 mm/vmscan.c                    |  2 +-
 12 files changed, 154 insertions(+), 22 deletions(-)

base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
-- 
2.56.0.398.g882cbad275-goog


