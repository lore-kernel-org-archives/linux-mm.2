Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D2ED4A5F7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 03:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 923A06B0005; Thu, 15 Jan 2026 22:44:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D14D6B0088; Thu, 15 Jan 2026 22:44:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B1E56B0089; Thu, 15 Jan 2026 22:44:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6ADBA6B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 22:44:39 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0ACAB13B25F
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:44:39 +0000 (UTC)
X-FDA: 84336435078.10.005018A
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6D03A14000B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 03:44:37 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZqHB4JMP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3JLRpaQgKCIUsj1xwvr3pxxpun.lxvurw36-vvt4jlt.x0p@flex--jasonmiu.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3JLRpaQgKCIUsj1xwvr3pxxpun.lxvurw36-vvt4jlt.x0p@flex--jasonmiu.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768535077; a=rsa-sha256;
	cv=none;
	b=dmfsBVbXJGthxPW3yarrFplhTsMEaKhAdNhVQAZMpXh+MNUEcF3wOxXPvzVEyhT/zF8aFl
	4fOlM8oe8+JO9oBbkXjhqAsSPusQH46p+fwMfjTGrygjDThiPzqdK+Rb5+VSd/DEBWzXTR
	4N/ndbt6CGVVMYfY/J0JepusENtFztw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZqHB4JMP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3JLRpaQgKCIUsj1xwvr3pxxpun.lxvurw36-vvt4jlt.x0p@flex--jasonmiu.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3JLRpaQgKCIUsj1xwvr3pxxpun.lxvurw36-vvt4jlt.x0p@flex--jasonmiu.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768535077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=XajjLO2IfEQWNmg3arj/S1hgJxiIRRitST6jLheATpY=;
	b=50/aEq1I+Q0SpI7HT/nFqX/AZhhuZyJ5uplZgfOrZKwHA5j1QxUd/288RLYuMr/HvjsMUK
	vXD5U2rzFW8Q1+1GmhkzNkgxfxVFHEK3sVNDlaRkNjMIrAtcNpAn2tJMKT9S/gOeR6OxMZ
	UxwkP8R97KGNcCbahinOjZYSvVpg+H8=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-123349958b2so6418684c88.0
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:44:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768535076; x=1769139876; darn=kvack.org;
        h=to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XajjLO2IfEQWNmg3arj/S1hgJxiIRRitST6jLheATpY=;
        b=ZqHB4JMPlLnLjeaaz7rHEljyjWfW873uMfZsvILFiZOAigrGhba+Mp539YRymqBrDe
         gxrzG3N/cldxnbChjImrMaf8Aj25sSepMKKc9l8SUmvxP6BlEOYtdAFhqBv+DSoWogYM
         BT4h4K8AR8NTWIMIYdU/PB8CnlWlxBBBrimc+NLuKeA1ubEijWk4vvtZQ4xMQ1RQ2Ckt
         u9lN18OrFn934DCMMgezOCOkitzDMnRv28S48Awms+QyosRqBXCGnRsPtbEC9ZtZ3fo3
         Ufj+r6HNtnHot8J8Ml+qp/MrNC5vgYExe29j8oobid/acSMpKqiJtYyK6l+dRJzHbII6
         e6zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768535076; x=1769139876;
        h=to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XajjLO2IfEQWNmg3arj/S1hgJxiIRRitST6jLheATpY=;
        b=ODYETLMtEQBVw57U3DIQHSqP/YsbuFuueiwapFJ+zn6sZwLLAqdNxtmPP35b2VTJyT
         fjShHFbUrWIwnRjr0q0xwDv8XqxrCjaO2ZzfDvL07hQmh7rO518avYwhsqp5IOGR68e4
         WRfxbhNhPLCqUrC9FqKzNhFPx4ChK8thaA8XPH4kPTh4Mc4RW382zug2JvRDTNb67Hb/
         46/NfCTgGGewvrcxs1jk2v/w1Unga67R2eAU8QucjgppZvJutAfxoM0ZDMhUfh0hf+2u
         EVZRxvfnf4CQiISMis+ealVGplrOe5URmcSjYniQvwIWLusrpXZ9i3fU/xNULYigPIUt
         /R2w==
X-Forwarded-Encrypted: i=1; AJvYcCXFKB1Tsif4xP9EUcCB/ZM8OoTevKF0XlohJn/YpYbSZq00N62x41H6z7dN4D1YcQkC/ld23Npf5w==@kvack.org
X-Gm-Message-State: AOJu0YwAchAdBHDd/03t4qDfPFvZdG/4vIdCz/bDhKbMOmuUlArn0bro
	J82EMDc37ehVpF/yDm7o8AheeUoRzWv1EfuI5B+n3P+ATu/drQ5XG0Dy4P4L/7oyZ+BoayHrg1a
	OV+x0j27Iku741w==
X-Received: from dlkk2.prod.google.com ([2002:a05:7022:6082:b0:11b:b064:f5dc])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:a8a:b0:11b:9386:825c with SMTP id a92af1059eb24-1244a791c71mr1740076c88.41.1768535076050;
 Thu, 15 Jan 2026 19:44:36 -0800 (PST)
Date: Thu, 15 Jan 2026 19:44:30 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260116034432.1520731-1-jasonmiu@google.com>
Subject: [PATCH v7 0/2] Make KHO Stateless
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D03A14000B
X-Stat-Signature: 68fs1q9k9bchwwnobu6n37u5cmh33ccs
X-Rspam-User: 
X-HE-Tag: 1768535077-495283
X-HE-Meta: U2FsdGVkX1/+GOEJqaShB+jeLnwgWvK4f9wyboOxXaCvB4YfTp5aJ2RcFFsFNURjE3wA3N6qT5oxzFIUSpdONVZDUc1T6ABsCp2mOy/0aeAGAbGbatVE3j0kNKZrvBdV0B6XWAfBY1JrkdOgURAB15thl4mBJ7Z+7atu4wmg3Pr0CQVRBziCDogMVmlO+UtTfDYhqReEGKBYT8kr1/tciTu730kkSRZTorQv341VOephAtbAOpDBgOXSX4xP26NQzEwWDZe/ESAVbs9dE9WYB80you8t44IMwPWArI4rVO2U1Wd44zS/U7/UdexWQE0EwtLt73l++wCH8UABL/MZ4J1er1uJkuYD5+ASjNTeH9YhM998Q2F2TQT31o49+KOeMrdyUwBJadcWsBTTTNWXY67nmvmm0MCM54Uu1SMNBy2m/LpoLzSsDjRpyPg++nFVxISo916wcEOm8dmyVt6xmYFFy4WUPpvVhdoJPHpyEzJMD9bnYcT9r0VwLLTySh93SF4H/IjPIqblexu8TbbIgqpKPjeU7cIBpxM1RforHZhS98mal97yEODLLZzljEVUX46jxHXNQw7SOdw6Zs0ehn82vk0o9yjjly+OloIkMUte/gC2/4uNjpmsRjPdJgNZJ8JLxyfI6hnFWHbcp8APoghTM6qUdC/JVB4GjmqLqCS2E964oZoc+q5Vf71sINpzSC1yvLBSw97Gf6NPRIzBhWMQiwwzft8MGJKrHqY8vgacxaMIhjoSadfWRDI1fWX3TkpCzuEHwJpGEH20Vo2QCVOK1DnJ1Wgqfx5APbR2gErO5nM8arNZrkOyT+Iecwz5SFomyqxanTXWajPDVVgE2hJjCUUC/XnZHBshPYbK4WnERy59ufZZbH46YyEwXwu+pffHcdjLTKJqImtmMUxbvLaAXa79Y0Kzv/hElewpcZccqt3uO4RmA4e7pdYeBKUDLgvgY5zeR2tvu/PXn6T
 Vnv8Mkv6
 AmSClVTYkplg+41SsfuSXQzNb0Ac6X4hYi31dg8lEtzamwIIFBaa2HBJqq4qG8xxgePp1JdavqXpTXtDPYEbSmbi+yGC4nUHez4e8v0w4ldSuYcQMzP4EVOne7mlSJ4PmWabg+TQQokGj+UZtwn9h9T7QQcuoYtyaqFqKAFG3G27MVSBDuMTwaOjZzm+X9IRGDsNZO4UOyCJtiN5OPnqULIJlpQ02x8OHs1rl/vq0olZkTRUMybCNJcZHMxqFOfOQ9LSFX0z3jEDLOfL7noWw0EIFtdMARdnyR0vgFXVC3cs/S9FE2JkPuDdGS0kOVXXIcJHT/UUO69AB+OHodPOEG8008YB9WZJtMIJRcL6zkppbg6gaDERsLVWzdQRZPLI0GGTbMKgbAk7FVc5A17/SqSdfdq/7pV4xlhTrQ0R1zVG8sezrRdjbaL9tIuMd0Ccv0bciYT/M9QdNy5b3KGPH0pMm81nB98zErZ7Qh7HOcAFfHo5kvdO1WFHAEVH3K5Vfg/W839Ft6utkzsPs/IfXDdMUjl8ZE0hR+aeH33wFD+uPOMVKQlAcGW6hXM88F4JhzxJuexxthL0DIac=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series transitions KHO from an xarray-based metadata tracking system
with serialization to a radix tree data structure that can be passed
directly to the next kernel.

The key motivations for this change are to:
- Eliminate the need for data serialization before kexec.
- Remove the KHO finalize state.
- Pass preservation metadata more directly to the next kernel via the FDT.

The new approach uses a radix tree to mark preserved pages. A page's
physical address and its order are encoded into a single value. The tree
is composed of multiple levels of page-sized tables, with leaf nodes
being bitmaps where each set bit represents a preserved page. The
physical address of the radix tree's root is passed in the FDT, allowing
the next kernel to reconstruct the preserved memory map.

This series is broken down into the following patches:

1.  kho: Adopt radix tree for preserved memory tracking:    
    Replaces the xarray-based tracker with the new radix tree
    implementation and increments the ABI version.

2.  kho: Remove finalize state and clients:
    Removes the now-obsolete kho_finalize() function and its usage
    from client code and debugfs.

---

Changelog since v6 [1]:
- Fixed a potential dangling pointer in kho_radix_add_page() on allocation failure
- Fixed a premature return in __kho_radix_walk_tree()
- Corrected the size type in kho_preserved_memory_reserve() to match memblock_reserve()

[1] https://lore.kernel.org/lkml/20260115230047.1220580-1-jasonmiu@google.com/

---

Jason Miu (2):
  kho: Adopt radix tree for preserved memory tracking
  kho: Remove finalize state and clients

 Documentation/admin-guide/mm/kho.rst        |  53 +-
 Documentation/core-api/kho/abi.rst          |   6 +
 Documentation/core-api/kho/index.rst        |  18 +-
 include/linux/kho/abi/kexec_handover.h      | 144 +++-
 include/linux/kho_radix_tree.h              |  70 ++
 kernel/liveupdate/kexec_handover.c          | 695 ++++++++++----------
 kernel/liveupdate/kexec_handover_debugfs.c  |  23 -
 kernel/liveupdate/kexec_handover_internal.h |   3 -
 kernel/liveupdate/luo_core.c                |  12 +-
 kernel/liveupdate/luo_flb.c                 |   2 +-
 tools/testing/selftests/kho/init.c          |  20 -
 11 files changed, 573 insertions(+), 473 deletions(-)
 create mode 100644 include/linux/kho_radix_tree.h


base-commit: 9b7977f9e39b7768c70c2aa497f04e7569fd3e00
-- 
2.52.0.457.g6b5491de43-goog


