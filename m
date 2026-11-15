Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C90F7606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aKItX/9j
Received: by kanga.kvack.org (Postfix)
	id E6B1D6B00EF; Sun, 15 Nov 2026 10:10:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E43416B05B0; Sun, 15 Nov 2026 10:10:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D58CE6B05B1; Sun, 15 Nov 2026 10:10:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ACE1B6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:10:13 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B2171A84AE
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:11 +0000 (UTC)
X-FDA: 85437689022.30.47E074E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0807E1A000A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aKItX/9j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794755410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TEWHh130R00cWzrxjI9RLEu/jO2W72gxEB0EEQ477+k=;
	b=XBkT812RNcipublCRNACltrwPB7bwIHixFLzmkVhEZl+iV/2uNRLvQAX9DIcCkOhk0OKtT
	kJjd7qMJQbB2urilANzmWvSziXJxTk13cY5sIsx8KOBDqYZ9R/kXxr2ipXtSxGmaRs4mWK
	sA4PMOhRDOJQ7z/okMQ4ZKeqNV66coc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aKItX/9j";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794755410;
	b=rI+BOCpKDGdgvfQyBaEUhYg6VTkNpUxsPCUAWTqYaGhxenxSE6HnuH0ED4dp7pdTLlCGy+
	nme9wTKTE06zcNDhQ7Nda+FATkpEhbGrkov44UEapjPH++WgbTDLqQJ22TQSQC0hoh9FLp
	cZUQkr0lsKISJqE48k59T27uIUBFtOE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB372418CE;
	Sun, 15 Nov 2026 15:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA8C1F000C4;
	Sun, 15 Nov 2026 15:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755408;
	bh=TEWHh130R00cWzrxjI9RLEu/jO2W72gxEB0EEQ477+k=;
	h=From:Subject:Date:To:Cc;
	b=aKItX/9j+oVOU25ty1qIp8xqlkd6ee+UQZ/Hbo8gOignltDgBFfX+79NazSakEtlI
	 UqTDY2DS6PduyUCmZxJCcfWchi4Jv6L+HhN78+jpAg0UJsQkqWeLk3Q3PFHS7rn1mw
	 +J6OGK1IWx0joXcH/Cm2DLslBex/W8Nfez8RvaMp6Q7z56cFOvZ0fIsaDNDq0m+S2Y
	 /SzwDZ105uTbgoU7SnKw3pdwpF+G/xAU6dINP3YYyITYbFIiACIvgTr3jFCtStiDPD
	 Ndvb9m4F4mAvLJ539KxbojNq8GAn4wO0BDv0JI9B+sYxPGsccB6hHq6N4c86dvPXTj
	 vjUk+44fTSmQQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Subject: [PATCH for-next v3 0/7] memcg,slab: kmalloc_nolock() fixes
Date: Sun, 15 Nov 2026 15:09:34 +0000
Message-Id: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAC/L+WoC/22OzQ6CMBCEX4Xs2TX9wVY8+R6GA9YFKtCaFgmG8
 O4WvHqZZDL7zewCkYKlCJdsgUCTjda7ZOQhA9NWriG0j+RBMKGYEjl2Q9X33qDzSTus7UwRTaG
 VPklx1lpCQl+B9iCRN6h9QEfzCOUvie/7k8y4tW63rY2jD5/9g0nsxDbGOZP/xyaBDHnBlTY15
 VoX146Co/7oQwPluq5f18yaCdUAAAA=
X-Change-ID: 20260624-kmalloc-nolock-fixes-c97675328773
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0807E1A000A
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: g41yiyjfjrfnq8s9dyexcbuewbrjwup5
X-HE-Tag: 1794755409-904293
X-HE-Meta: U2FsdGVkX18bVoVlEkgQSj+tnnKOpfISFWT75z+pKTbI5n+CdhakmRZH65geAIAZwBK1A9LMbydiOTFOnyngfvyGjB/2EFW+tyGPZ8Fd0/bVjO9dq5nuOa40nRAvsBMiE4FINhEX06Vn3hbptcNXbiFVz/EgmNspnmwq71XTdr8w0sWuvPZpjoAQzaBJ/NnZ58UnBuZgNMK6NQrbtrOQvtgZlsq0+6DUpWJqQgDAtCdfVFoY6iKDAsOyycGmW5ic1NhlhIGn21Ey8J+y6M2f44jhPCox9/EbPJTIEsKXB14GzCLk9ZSjNsrXNjiVTEcmxw90vc6a0UgIcFCmp3d6Iph/tTYtpkAgmw0ZsJ6kboWuLStzp3Tev5u+ON+5hu92rUW1qUM64+xdOgGMXLLTZb3viH+bDgZaxNbupkZpph4TmF/CpbwlIaCC67d3LOgDFWMPj263+HJr7JST7baloTszI2+54vVQA/3wRs/6Ryq9lo7tfWvyHr32QsJG0/4C9C1k8aEEFrS95wXP9oZzJ+/lBK7hQDWILBW2e3d9AG9eZhHkSunyKyeaODLXrDXNyu+DGZhsLarmZnWmDAlLiE7+ocgGAn1nBLSOHDim8ERpIrSvUu7Fnl8re787jMdYhg2lMoXl1+fUBiaGh05FwdCaEusMdWo+jK1UqrZg2LH87hfy6nM6GIJULiYQ3rWuZf5Li+E75qeLGEG0cyFT96Hh/RKKbB1cgxCjWzq4P2gQ3R4Fi4YPjAB9z0pE8xS6YYL7Brol56ZbYpr9SWj/2Zom92OCsk2jPeDSC4YIAt5LeZxIDddzEciRECZuvLnyR5P86BwiFKdMj6RFqE0wuZsKYEqTxEbnVjkgOek4wix4hSUwdoYASkJ4OD9GWC/aqZjEyiC9NFFV1BMZ0Xq9XGelnApPxWBn9yCcSg80zO+00m+zboJSc1qutCKpQBx+tUE2tsRlTpNA01ccTiE
 9PJXrviq
 5H0kexT9MTsTu515+4TiQHJo4PGMUNrMcTFIDqklEcXRuyUwjwqZx5d6MdWOzw9UkvE69/+dt82aexgSBiTSkCEIwBgreledAI0NgMReviO4lNXEjUAmUL1x9oaB0Y3v7aYlAEYETHqXz4uyTM6OCDRcP2snAgesNGDDn4ossQ4yMF01lTEBNmaypbJBVqPLOMoW10HdCvOjN0N9kjLhfTQadira1RjMrOj4a/Tkc8xBAXNAMlUGSfzxiXFu9JKwO7qKFePAteNaEUDrBlPKCwVnwdXfmz9ssfCN2A4Njm1d8wJ80xSC8oq0TAAGGUAliz94UVxqHEsKqKyS4BXWYojgsXNHiJPhUfbKf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This patchset fixes three kmalloc_nolock() bugs.

1. obj_cgroup_put() takes spinlocks in the release path when it drops
   the last reference, but it can be called from any context.

2. A spinlock may be taken in the following path and may lead
   to deadlock:

   kmalloc_nolock()
   -> slab_post_alloc_hook()
   -> memcg_slab_post_alloc_hook()
   -> memcg_alloc_abort_single().

3. irq_work_sync() is called without synchronization for rcuwait
   (on PREEMPT_RT or some architectures), potentially causing a
   hang.

Bug 1 was reported by lockdep, and bugs 2 [1] and 3 [2] were
reported by Sashiko.

This series fixes the bugs by:
- 1. Deferring obj_cgroup_release() to an irq work.
- 2. Making slab_free_hook() and memcg_alloc_abort_single() respect
     SLAB_*_NOLOCK
- 3. Serializing irq_work_sync() with a mutex

Patch 1, 4, 5 are bugfixes and others are refactoring and cleanup
patches.

Changes in v3
=============

- Rebased onto the latest slab/for-next.

- New patches and changes to existing patches were written and
  verified with AI assistance and carefully reviewed by Harry Yoo.

- Patch 1: added Vlastimil's Reviewed-by (thanks!).

- Patch 2 (new): pass free_flags to slab_free_hook() instead of adding
  a third bool, as suggested by Vlastimil.

- Patch 3 (patch 2 in v2):
  - Now handles SLAB_FREE_NOLOCK in free_flags, so callers no longer
    need the allow_spin local variables.
  - Updated the subject accordingly.
  - Addressed v2 review comments from Vlastimil (thanks!):
    - dropped the memcg_alloc_abort_single() functional change from
      the changelog, as it does not change until patch 4.

- Patch 4 (patch 4 in v2):
  - Try freeing the object to the percpu sheaves first in both
    contexts, as suggested by Alexei and Vlastimil. Dropped Vlastimil's
    Reviewed-by accordingly.
  - memcg_alloc_abort_single() now takes alloc_flags instead of a bool
    allow_spin, and converts them with a new to_free_flags() helper.

- Patch 5 (patch 5 in v2): added Vlastimil's Acked-by.

- Patch 6 (new): Make free_to_pcs() call can_free_to_pcs() and take
  free_flags instead of allow_spin.

- Patch 7 (patch 3 in v2): moved to the end of the series, after the
  fixes. Reworded the comment.

- Link to v2: https://lore.kernel.org/20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org

[1] https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org?part=9
[2] https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5

---
Harry Yoo (Meta) (7):
      mm/memcontrol: defer obj_cgroup_release() to irq_work
      mm/slab: pass free_flags to slab_free_hook()
      mm/slab: handle SLAB_FREE_NOLOCK in slab_free_hook() instead of open coding
      mm/slab: fix a deadlock in memcg_alloc_abort_single()
      mm/slab: serialize deferred_work_barrier()
      mm/slab: refactor free_to_pcs()
      mm/slab: call debug_locks and KCSAN checks in kfree_nolock()

 include/linux/memcontrol.h |   2 +
 mm/memcontrol.c            |  27 ++++-
 mm/slab.h                  |  14 ++-
 mm/slub.c                  | 247 ++++++++++++++++++++++++++-------------------
 4 files changed, 180 insertions(+), 110 deletions(-)
---
base-commit: a7cdd0af963a420fc0e6f20b7c8bc8d4784098db
change-id: 20260624-kmalloc-nolock-fixes-c97675328773

Best regards,
--  
Cheers,
Harry / Hyeonggon


