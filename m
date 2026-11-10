Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43DC7606A330
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mX1JxGhm
Received: by kanga.kvack.org (Postfix)
	id 420136B00EF; Mon,  9 Nov 2026 22:29:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0F26B05B0; Mon,  9 Nov 2026 22:29:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2990B6B05B3; Mon,  9 Nov 2026 22:29:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EDE9E6B00EF
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:29:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F1CC1207A3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:29:38 +0000 (UTC)
X-FDA: 85417779636.02.10B4F10
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9F4F5140007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:29:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mX1JxGhm;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794281376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EzW2wBxhFd3AZgIdQVNZpp+frtAfuu8T5OooRMQocqk=;
	b=T9VsN5QQfoT0Z/HVTSNjBSjoUU46PsmOLBtYQ2EL2oc/AOSWCQRlEPVGmGP0Mhks7qxDLT
	YmHVM5UUJFSAwyyLPS4HRK3ppU2zRFIXCBrpHVwHFhBhDsr1BXC2SeDZH5rYBrfX7Ck2HQ
	iLtfCajTwYZPxp45ll1LTXbdxaS2Q3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794281376;
	b=F0/NhRYIY9TcbW8WmKPY0McKI4NHRHahjpgel7CZLxEmpzo/rryl62fz3koHeAFla176ww
	t+fv4RexfxAHGUrHe8+3+wvIImYtk095dxSsZpLEaxU3xk+9ZzHF/SH3aBviMXFiZkHXQp
	znforrak50qVINDa3V0//8hAN/Ab6d0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=mX1JxGhm;
	spf=pass (imf09.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8b29b83fdf1so653483b3a.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 19:29:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794281375; x=1794886175; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=EzW2wBxhFd3AZgIdQVNZpp+frtAfuu8T5OooRMQocqk=;
        b=mX1JxGhmkyio+7Qv1IAqoWzVb4dQKhGTff0D2+Nx0og8OILtsrOfQVB9JjGjLg7hAW
         wSBf2OH1jRth7Ajwt6ZEvrX6kj8LvBY5HY490S5sNR7Av6GvZla+caDPs3dCCY7sg1Ao
         ZCqj6yyT2nNf6sLSgzuCBxy+4fhrSitCMnbzz7yVnqSyuDpCkCnE9zs97hTVh4vC+3aG
         Zyr8spbb7mmfYAUJ+ej/MxBePMqBmUn3IbTMrrjisHuIJQy2VG2RxwG6tJpOrGeiAtf2
         pY0FfFxKQGM18S+QOWdRFgW+/M5tA0pJE4FRQesb7JHRIbFOSvYE0AzPKI2auoLrz0oB
         SF4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794281375; x=1794886175;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EzW2wBxhFd3AZgIdQVNZpp+frtAfuu8T5OooRMQocqk=;
        b=FWxWVr5GfXFVPKT2ynref5ROAuKBzkwplJ0jPPwNe91zdISLaSvwFlw/SViABrWfPt
         1YqRNtNrjltBYkw2ASxor1EjOFm1R6322ZRduHHFtHBbmlnD5IIznPtHy1DMzfMcp1td
         OlRt7SPGaj9Eo0ikRbQVF71GQSbgn3O7L6drCgzeRQJ/dcSoNObvavnr07ZyUGJC/zDK
         8969whxfwwX9Q1Ggd3enqCHILhEywah1j4LJUl8NpHv9xHlwuQTX4d4Go/z67AZjESJN
         vmT0cI7b+zZHuYCWtrw2PvgJf3zUZy6HYRIBZRBp2XEYPQliHplFOJVEuW84XKfT+loF
         2dUA==
X-Forwarded-Encrypted: i=1; AL+hErE+NlEAAyeHJikd6kxnzR4YIe8PINss61DIf+cC3zH2v+6uysvvU7xTkIIUjlRjTSQfWAS7l7elwg==@kvack.org
X-Gm-Message-State: APuU4Z/GKZRdo7ATKeMTTn5ly6hEyjg5acuiVBSGLpzqjyiUaXYY3eu9
	DS0z56FP1W+MxzxVRCG8PwS3aar7cttK1AQBtSK7dEWBy7oonRFVgmnG
X-Gm-Gg: AYBFou2FAiCBkkgR2kdh/eppqn/jIJ+luu5imVO9FHQHCRvYsq14LskqX3b3ySHGOG9
	I92pndA4QvVUu9E/FvHz8tnZXPEbiX2NfVzRhbzehyjQqSHAz83SH4xH21JuD9hyG8fNxa5E7M8
	jx4Paj57RH/BdHuD9PCYuaOdsG9ApY1zBLyu9KBS4hFQpSoi6SkfnDh4y6lYiuf8H4zIdm4SLG+
	bQ8imppqoQyn1EZuojha/1qpky3IN7d2pSMov0doAc+JbDMns2xKD060ej7bGwBSvOeiLkJ50QY
	rB6surtBe3Slxhu0zAQov6VNZLcynIS6yfhsPOn7AkgqKrASj3Xp5Dx0Ql7T3Wi1niq2aktE0SC
	+K1MYq22NQ9kv/5u3nj+GQo6TUW846QydBZIDMzwbR3kEa7t4UYOQQcCp3D9Bk6LZm03T3KMWic
	fNsBpgsIYFOQ9QDDN/Xx6RejFEqX6J79bsPrMzeDdm4NVdHR1yZDrRLNxxuN8g6AtUyLXvQMuT6
	UzMwuIUFHXC+pG85jkRLQ4uQUx16Ay+XqiYypaHMjk2g4ekv84A2tSNmtZFUP42wF26q3kHi++1
	wmkUmBaPugMopLNIKOK1snbgYoOxzdg1fvkV6BK+fOz3FgMfb4VMb2s4HS6/ECN1cmtM3BI3E0e
	q9/k7BENyl8cPEW6aMplZwsTv
X-Received: by 2002:a05:6a21:3a94:b0:3e2:aa13:2e4f with SMTP id adf61e73a8af0-3f190281bbamr1075007637.56.1794281375265;
        Mon, 09 Nov 2026 19:29:35 -0800 (PST)
Received: from localhost.localdomain ([240e:46d:1d00:5ed4:58d0:d294:d44c:6ae8])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baab21835fsm336973b3a.42.2026.11.09.19.29.24
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 09 Nov 2026 19:29:34 -0800 (PST)
From: Yafang Shao <laoar.shao@gmail.com>
To: ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	yu.c.chen@intel.com,
	zhao1.liu@intel.com,
	tim.c.chen@linux.intel.com,
	lizhe.67@bytedance.com,
	ziy@nvidia.com,
	mgorman@suse.de
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [RFC PATCH bpf-next v4 0/4] BPF-based per-cgroup NUMA balancing mode selection
Date: Tue, 10 Nov 2026 11:29:09 +0800
Message-ID: <20261110032913.71974-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 54n1qq9tb1xmkt53xqji4tcqn4tx9kfu
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 9F4F5140007
X-Rspam-User: 
X-HE-Tag: 1794281376-698092
X-HE-Meta: U2FsdGVkX18ZByOuvHV6HLPe/JXbJ3fsyna6059evFso8Eh+ykGmCTkdYSzUNPhTQ5lS5FI2FaYclhxcnJAPSOyu3UMZ9Uty3Zj1qkQ5hfV9R0WHM8QSGLXtXG/3GPxEYhnRW5iatlcBoJTVfwqhqw/6Jh2c+cZHg4tEKbgM7OM9K66nALqlp3VKtb11axQ/tO168xVwTMHqS8P6zPAtpjii1KH+s34Q1w+pESIXp503POl5Farq5b+8S/t3S1PbLoa3h8q+EV9C/ENLM5NQZrC0vFDSAdUBrO+F2Hz04sMta07Q36fl0GUXWY9641ovkeusCWu3ZbccKK2/tkBb/4LZTHm7L6wie6uMI3MDQ4dgNqTBQzezxDPdH8v8od8Nbh2ubuBISubm+7g/S/I6U891hivLOvQa87BA/wgt94MA0d+KA0KRla9wNhB5spzqAJn8pgHa8UMR8qtN9qRbNzYjM7XnlRmv5fTVviZ7C0vta9LxsvNxVRq4fLwZqSgEeMfr/lTiGCWxgG53TJUinct0cOJyR29N6fJD1qAfo07oHaRAK8tqTajnmpvhHY5oFILhZg9ZnyFT+SpkEo8NuZGQM1aAuhvfwC2PhskfoVy6wI/fe+9AzT+tjp7g72M4+or4+m39iX0R6dXfCoyrLjyUvPe1pbTDpxjj9t2j1cUEED06EFE+PDzcgSYT93LAz9HJoPH8cRnqqd5NJIJ9Vjb0LcA171sbLTvnrmx+Iqc0f0GR567eMVGWcrwzloGOY2KYNCcrJ2GaMwSfAoAIaQv9HdnGMT4DtdDPeXDNvTqvKrsCiYeaPlCrk30/AnXm0ZUkSx4vKkAtkY8YOI8/VzEfEVfiA0ny9V0LWpv/G4Io8vsHy0Dh4GDQBePOLcDVMru7IU5b2Z4AupWRri9rDqlBtGVDXs1Dv+yAZvY3OKZqhg8hiRQTU57aM8DWANW38wM+3sHPMzT8fMUP4Q3
 p7G8Vqyu
 Dge7RXrU6vh6FAWGjvoNUsu5E/JrEheBSfnFZRQ0/Nw1ZPi61NdO4hbs6WAKJcJY90tzUyEk3A4RA2JKB9w0e5+ynJiEnWTT7dI0/6AyWLYNLz0ITmgggtIpyhXXxUFuD0PZhTanZNopY67xnMPXD7D+rARTg1rt7RPuSTmAMcVSmendHTCCvKQrFXs2k+xUNBcOXQKgfqrtudFDithpr7bX+urNxv5jnsmYQXclXn+QiHt4Ck7HxuAHmbNX08alnPGiI8C35FiTV56z3Ar6wtL94g0rEY6GjhdIYaQrVr51f8l0Ia/YJXsOsMZ4qkfrN/ki3vo4Hn1HHH1gnx/Nj4YPberhHku2O2Pn8zk/ax1cQx95YfyItRFnBGJZBkzLgTWyzRz5+aUTQH/tYP0d/jPU2WJwrq9Q4unCE9abjBowc4oyFiJlTZe7TxlcIKbO9pCW1MU4PS7xvAdTnJtMTTUmXtqfDvnH9rDU7AxYR/y7J4XdYlCTFtEmKJrP5asc0JpteocUu/ML4ysKlTBp7qpkWtuqlh5uhukTS5jLFcLaFfUk0EWtCX08P8gA1CJ6knei6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Problem
=======

In our large fleet of Kubernetes-managed servers, NUMA balancing has
historically been disabled globally on each server. With the growing
deployment of multi-socket AMD EPYC servers, cross-NUMA access has become
a critical performance issue, which led us to reconsider enabling NUMA
balancing.

kernel.numa_balancing is a single system-wide sysctl. Latency-sensitive
workloads want NUMA balancing disabled, while NUMA-aware workloads want it
enabled. No single global setting serves both.

Design
======

Core structure
~~~~~~~~~~~~~~

This series follows Tejun's suggestion to store the existing NUMA
balancing mode bits in the cgroup's memcg and expose them through BPF
kfuncs.

A new field, mem_cgroup::numab_mode, holds the per-cgroup NUMA balancing
setting. Two kfuncs are added to set and read it:

  bpf_numab_set_mode(): set the mode for a specific memory cgroup. The
                        update is rejected with -EOPNOTSUPP if the cgroup
                        has no visible, online memcg. Valid
                        values are the NUMAB_* mode enum and
                        NUMAB_FOLLOW_SYSTEM (-1); NUMAB_FOLLOW_SYSTEM
                        uses the global sysctl state.

  bpf_numab_get_mode(): return the combined task-side request of the
                        cgroup's effective memcg and of all its ancestors.
                        NUMAB_FOLLOW_SYSTEM is returned when no request is
                        present. A cgroup without a memcg resolves to its
                        nearest ancestor memcg. The following section
                        describes how the request is combined across the
                        hierarchy.

Both kfuncs are registered for BPF_PROG_TYPE_SYSCALL. bpf_numab_set_mode()
is KF_SLEEPABLE because it takes the mode mutex and the jump-label locks;
bpf_numab_get_mode() does not sleep. The mode values are exposed as a BTF
enum, so a BPF program can use NUMAB_FOLLOW_SYSTEM and the NUMAB_* mode
names without hardcoding private integers.

Effective mode semantics
~~~~~~~~~~~~~~~~~~~~~~~~

In the current implementation, a memory cgroup can be set to the
following modes:

  NUMAB_FOLLOW_SYSTEM (-1):   use the global sysctl state
  NUMAB_DISABLED (0):         disabled
  NUMAB_NORMAL (0x1):         normal mode
  NUMAB_TIERING (0x2):        tiering mode
  NUMAB_NORMAL_TIERING (0x3): normal mode plus memory tiering

The diagrams below assume that each cgroup shown has its own memcg. A
cgroup without one resolves to its nearest ancestor memcg, as described
in Storage of numab_mode.

Except for the sentinel and the opt-out described below, the effective
mode is the OR of this memcg's mode and that of all its ancestors.

- An opt-out wins for the task side and binds the subtree

  A DISABLED mode anywhere in the cgroup's ancestry opts the cgroup's
  tasks out entirely. Given:
                     Pods (normal)
                     /
          Pod-A (disabled)
          /           \
   cgroup-A1(normal)   cgroup-A2(tiering)

  The effective task-side mode for tasks(*) in cgroup-A1 and cgroup-A2
  is:

                     Pods (normal)
                     /
          Pod-A (disabled)
          /           \
   cgroup-A1(disabled)   cgroup-A2(disabled)

  (*) The folio side is described below.

- NUMAB_FOLLOW_SYSTEM is skipped

  Given:

                     Pods (normal)
                     /
          Pod-A (-1)
          /           \
   cgroup-A1(none)   cgroup-A2(none)

  The effective mode for tasks in cgroup-A1 and cgroup-A2 is:

                     Pods (normal)
                     /
          Pod-A (normal)
          /           \
   cgroup-A1(normal)   cgroup-A2(normal)

- For all other modes, the effective value is the OR of this memcg's
  mode and that of its ancestors

  Given:

                     Pods (normal)
                     /
          Pod-A (-1)
          /           \
   cgroup-A1(none)   cgroup-A2(tiering)

  The effective mode for tasks in cgroup-A1 and cgroup-A2 is:

                     Pods (normal)
                     /
          Pod-A (-1)
          /           \
   cgroup-A1(normal)   cgroup-A2(normal|tiering)

- The rationale behind these semantics

  The cgroup hierarchy semantics invoked here are those of resource
  limits: an ancestor's limit binds every descendant. That is the right
  semantics for limits: a limit partitions a shared, finite resource,
  and what a descendant consumes comes out of its ancestors' pool, so an
  ancestor's limit must bind every level below it.

  A policy request is a different kind of control: it is a preference
  about how the kernel should treat the workload, not a quantity drawn
  from a parent's pool. Expressing it consumes nothing, so the limit
  semantics does not carry over; the question is only how the preferences
  of several levels should combine.

  We chose the additive interpretation: a descendant may ask for more on
  top of what its ancestors asked for, while an opt-out at any level
  still wins: DISABLED anywhere in the ancestry caps the whole subtree.

Task and folio keying
~~~~~~~~~~~~~~~~~~~~~

The NUMA balancing knob is consulted at some callsites with only a folio
and no task, and at others with only a task and no folio.

- Task only

  kernel/sched/fair.c: task_numa_fault()
  kernel/sched/fair.c: update_scan_period()
  kernel/sched/fair.c: migrate_degrades_locality()
  kernel/sched/fair.c: exceed_llc_capacity()
  kernel/sched/fair.c: get_pref_llc()
  kernel/sched/fair.c: get_scan_cpumasks()

- Task and folio

  kernel/sched/fair.c: should_numa_migrate_memory()

- Folio only

  mm/memory-tiers.c: folio_use_access_time()
  mm/mempolicy.c: folio_can_map_prot_numa()
  mm/migrate.c: folio_migrate_flags()
  mm/migrate.c: migrate_misplaced_folio_prepare()
  mm/migrate.c: migrate_misplaced_folio()

Therefore, the helpers are split by side:

  folio_numab_effective_mode()
  folio_numab_in_*_mode()
  task_numab_enabled()
  task_numab_get_modes()

Another concern is how to handle callsites that have both a task and a
folio. The following anchor resolves it. Both the user fault path and the
kswapd demotion path reach folio_migrate_flags():

kswapd demotion (no task):

  kswapd
  + shrink_folio_list
    + demote_folio_list
      + migrate_pages
        + folio_migrate_flags
          + folio_numab_in_tiering_mode

Fault path (user task):

  do_numa_page
  + mpol_misplaced
    + should_numa_migrate_memory(task-m, folio-n) (A)
      + task or folio?
  + migrate_misplaced_folio_prepare(folio-n)
  + migrate_misplaced_folio(folio-n)
    + migrate_pages
      + folio_migrate_flags(folio-n) (B)
        + folio_numab_in_tiering_mode

folio_migrate_flags() must key on the folio, since kswapd has no task to
consult. In the user fault path, both should_numa_migrate_memory() and
folio_numab_in_tiering_mode() are called. Since both refer to the same
folio in this context, keying on the folio at B but not at A would be
inconsistent. The rule is therefore simple: if a folio is available, key
on the folio; otherwise, key on the task. This also keeps the keying
robust to future refactoring: if either folio-keyed function is ever
reached by a kernel thread, the answer does not change.

Storage of numab_mode
~~~~~~~~~~~~~~~~~~~~~

Some cgroups do not have the memory controller enabled:

Given:
          Pods (+memory)
          /
       Pod-A ()
        /
      cgroup-A1 ()

cgroup-A1 has no memcg. Given the task/folio split, where should the
mode for such a cgroup live?

- If the mode were stored in struct cgroup and setting it on cgroup-A1
  were allowed, tasks in cgroup-A1 would use cgroup-A1's request while
  its folios would use Pod-A's memcg request, which is inconsistent.

- Storing the mode in struct mem_cgroup avoids that: cgroup-A1 cannot be
  set, and both its tasks and its folios resolve to the same ancestor
  memcg (Pod-A).

For consistency, the mode is stored in mem_cgroup, setting it on a
cgroup without the memory controller enabled is rejected with
-EOPNOTSUPP, and both task and folio lookups resolve a cgroup without a
memcg to its nearest ancestor memcg. A request is effective only while
its memcg is visible and online. Disabling the memory controller or
offlining the memcg clears the request, and lookups skip such a memcg, so
a pinned memcg cannot keep applying a stale request. A re-enabled memcg
starts transparent.

Shared memory semantics
~~~~~~~~~~~~~~~~~~~~~~~

With the mode stored in the memcg, the longstanding shared-memory
problem in memcg has to be addressed for per-memcg NUMA balancing as
well.

Given:

    cgroup-A     cgroup-B
           \       | (charge)
           Memory_shared_by_cgroup-A_and_cgroup-B

A choice is required when the NUMA modes of cgroup-A and cgroup-B
differ. Since the folio-side lookup starts at the folio's memcg, a task
in cgroup-A operating on this shared memory uses cgroup-B's folio-side
mode. If DISABLED were applied to memory, cgroup-B's DISABLED would
prevent cgroup-A from promoting the shared page. We avoid that by making
DISABLED task-side only.

In our experience, NUMA balancing is mostly disabled to avoid the
potential latency spikes it can cause. The intent of disabling it for
cgroup-B is to avoid latency spikes for tasks in cgroup-B; it does not
matter whether tasks in other cgroups perform NUMA balancing. We
therefore disable the task side only, not the memory side: DISABLED
applies to tasks, not to memory.

Demotion is global reclaim, not a per-cgroup balancing request.
DISABLED only opts the cgroup's tasks out of NUMA balancing; it must
not become a memory-side reclaim veto, or a cgroup could keep cold
pages in the fast tier, leaving less fast-tier capacity for other
cgroups' hot pages and defeating promotion for those pages.

So, in the end, DISABLED is a task-side property and does not gate
memory-side operations.

Shared fast tier
~~~~~~~~~~~~~~~~

A promotion competes for capacity in the shared fast tier, but it
cannot consume more memory than the cgroup may already consume: it moves
the cgroup's own folios, within its own memory limit, from the slow tier
to the fast tier. Each contributor's own limit bounds its footprint,
but the fast tier is still a shared resource; demotion is the global
release valve that keeps cold pages from occupying it indefinitely.

So a child can still enable tiering mode if its ancestor has only set
normal.

Given:

                     Pod (normal)
                     /        \
          cgroup-A (none)  cgroup-B (tiering)

the effective mode is:

                      Pod (normal)
                     /        \
          cgroup-A (normal)  cgroup-B (normal|tiering)

What an ancestor cannot do now is cap only tiering while leaving normal
balancing available below. If that targeted cap is wanted, the natural
extension is a negative request: NO_TIERING would propagate down the
tree like the positive requests and mask TIERING out of the effective
mode. It would cap promotion, not demotion; demotion remains global
reclaim. With:

                  Pod (normal | no_tiering)
                     /            \
            cgroup-A (none)   cgroup-B (tiering)

the effective modes would be:

                      Pod (normal)
                     /            \
            cgroup-A (normal)  cgroup-B (normal)

For this version, I would keep the modes minimal and add NO_TIERING as a
follow-up once there is a real user for it.

Cost
====

On the task side, an ancestor can opt out the whole subtree with
DISABLED, but cannot cap only tiering while leaving normal balancing
available below. On the memory side there is no opt-out at all:
DISABLED is task-side only, so a descendant's TIERING request is enough
to enable promotion for its own memory, and promotion is the mode that
consumes the shared fast tier.

The per-cgroup override was measured with schbench, 384 workers, on a
two-node 384-core machine. In that configuration, a cgroup mode put the
cgroup at the throughput of the equivalent system-wide setting, within a
fraction of a percent. This is a throughput measurement, not a
microbenchmark of the scan path: while the static key is on, a folio
lookup is O(cgroup depth), and callers that need more than one bit now
share a single lookup. An effective-mode cache may be worthwhile for
very deep hierarchies; that is left for follow-up measurements.

Limitations
===========

The mode is per-memcg, not per-task. A cgroup without its own memcg
cannot be set; its tasks and folios resolve to the nearest ancestor
memcg. If multiple tasks in a single cgroup need different modes, place
them in separate child cgroups with the memory controller enabled.

For threaded cgroups, the mode must be set on the nearest domain
ancestor that has the memory controller enabled, because the memory
controller is not threaded.

Changelog
=========

RFC v3 -> RFC v4:
- Store numab_mode in mem_cgroup instead of struct cgroup
- Refine the commit log

RFC v3: https://lwn.net/Articles/1101442/

RFC v2 -> RFC v3:
- Replace the struct_ops interface with two kfuncs, following Tejun's
  suggestion.
- Improve function naming and simplify the code (David)

RFC v2: https://lwn.net/Articles/1099962/

RFC v1 -> RFC v2:
- v1 keyed the hook on the memory cgroup and temporarily embedded the
  cgroup id into the struct_ops value, because cgroup struct_ops support
  was still under development.
- v2 attaches through the cgroup struct_ops support that has since landed
  in bpf-next, keys the task side on the task's cgroup and the memory side
  on the folio's memcg, and adds the memory-tiering mode alongside enable
  and disable.

RFC v1: https://lwn.net/Articles/1054030/

Yafang Shao (4):
  sched: add helpers for numa balancing
  sched: sample NUMA balancing mode once per path
  sched: add BPF-based per-cgroup NUMA balancing mode selection
  selftests/bpf: add tests for the numab kfuncs

 include/linux/memcontrol.h                    |   6 +
 include/linux/sched/numa_balancing.h          | 144 +++++++++
 init/Kconfig                                  |  23 ++
 kernel/sched/bpf_numab.c                      | 261 +++++++++++++++++
 kernel/sched/build_policy.c                   |   4 +
 kernel/sched/fair.c                           |  99 +++++--
 kernel/sched/sched.h                          |   1 -
 mm/memcontrol.c                               |  14 +
 mm/memory-tiers.c                             |   9 +-
 mm/mempolicy.c                                |   9 +-
 mm/migrate.c                                  |   9 +-
 mm/vmscan.c                                   |   6 +-
 tools/testing/selftests/bpf/config            |   2 +
 .../selftests/bpf/prog_tests/bpf_numab.c      | 273 ++++++++++++++++++
 tools/testing/selftests/bpf/progs/bpf_numab.c |  32 ++
 15 files changed, 844 insertions(+), 48 deletions(-)
 create mode 100644 kernel/sched/bpf_numab.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/bpf_numab.c
 create mode 100644 tools/testing/selftests/bpf/progs/bpf_numab.c

-- 
2.52.0


