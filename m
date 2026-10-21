Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D3D560A260A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 22:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=MDTf60IP
Received: by kanga.kvack.org (Postfix)
	id 3F4496B07D4; Wed, 21 Oct 2026 18:55:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A3386B07D6; Wed, 21 Oct 2026 18:55:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B99B6B07D7; Wed, 21 Oct 2026 18:55:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED9076B07D4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:55:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 537ED4055D
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:20 +0000 (UTC)
X-FDA: 85348141200.13.42B130C
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8EBB4C0005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 22:55:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MDTf60IP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792623318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ojYKRRox9AI6+Vsc6Ju99ox5/83lSqiRHyNpYAnar/c=;
	b=EeDFxWPYc6cNy+wNPKc/s7b5+PUImx5yF31hrTlbpJKhagrgXlBxoPI2PNp20If+9v0NAR
	cs2RzJ2ZuZ4YEzHsX60owSwGoYtYrR4btpQ8UeAhAaakUZx2rIqwCtLwZoSpHsK8zZNZ3C
	1e2mYuAdJNDakvhLa9ml+OMPEjURKSs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MDTf60IP;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792623318;
	b=3hKtvuWNun0eED/QSbil2TPa0TQkq5lM9ntKoiDFK2Qu2adCQkPww67kwn0PrXUD2NimOM
	2tUASHq3bW7Yk4ITASrkMmwOo5oPDO2mb2m6RUnxcpOtDKF2bM7IsHukmt2+y1Db01IiiE
	h4lNen1Cux6esaTp29hVnz0kaiTfJds=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-677af43eed4so1172809d50.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792623317; x=1793228117; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ojYKRRox9AI6+Vsc6Ju99ox5/83lSqiRHyNpYAnar/c=;
        b=MDTf60IPJT1pg5UZuxjqS7uFK53vWP7hazR9tYhZDOi7bYSCMRlzRbJ+ltgfc0XMdi
         txgPzZV2AmS/clTqEZPAYJZYItBGQAGruZ4XmqnMzo+g9xc9j8lnfFe4HKnrCFOEiZUO
         TXRbl7Cc9ltmYiaUKgtUchL/84DCxXKxRzcsqwloA6+IlaDuqVWy2inM/uuFFiE8qquY
         xq5vbHlqpIwM4yGjNnljQ7DgilfBdXQBSRVrB4lZkW4eNL6CdAMWW84GHldDmwbfMvDX
         FS7XRCwM6ocLrmMAvP6ukdHJUtPBb+QOglqzoUiOP7p4C4pT8D3LOTiA87gdM6cIDzWF
         y4Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792623317; x=1793228117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ojYKRRox9AI6+Vsc6Ju99ox5/83lSqiRHyNpYAnar/c=;
        b=QCo5d2AFJPuzLcMp8iMh2kDu+MrE7ClAVvX4LRKbBN2zgw86DiMfeg1Syx1+EluMl0
         TZ/rl7AYdR3a9fYsWzJA0vEZt7W6NbKvvgKzlWW3uB3pJ1Hbr9i6h7OV7nPL2SDKDMfh
         ru0UDLVMqrtTENroBScn3gYpIUAocOcbVprQbjM+OVSd4EeAqXoxl+7QHNVp3mWS7Yic
         Whu3kZCAGkp1rt3Bszu7k1tHBUfZmFRzgiEWHHuE/oCAMNrhCRY6w7U2Hh+NTsHvuQKB
         jtJv9EDjcc0tum7om+aye6oWuYl2mkxQlckvDhVv5Ef56yyUmlRBinqSJduZcK/NRvTr
         98cg==
X-Forwarded-Encrypted: i=1; AKwUvBw9nlLTHkgj4qMefX34RqcimflVhMlq8b2qdhDDN2j3OsbwqA/DrFNgAv0+mAuKUIoyHrDy4iKyhQ==@kvack.org
X-Gm-Message-State: AFq9FYJtgzf1iWEpzFHbCY3AHtHekhgOkJSTRa92x+aLmso7CxL4zsPh
	MOJuv1t6dL+tHlonhlsPwjsvppsoomL03utJRfzqEHQIYJSTv+tdOkxd
X-Gm-Gg: AYBFou1yG8P1aq4uCDZp0nwcfWrJMuKsA1lztdTkOZGBU/ZZSJSD+orl8CR2rqyyXZn
	RAJbvqsQepctYPeMwMYWXC+ETMjrR5oTY+g99NL8RDL0sHBA3a0BREsJSZmbOPEfC+/IImn4kAV
	dEkvZj1gd7Lf0sKJRUlsJiflTF6/UFR4DYp4FXxIjJXpT5OOb469etFEK+QZY5BkhSeRatt5Qvk
	H1D3O8pOT164/ph54BrJeEM2txstF3qA0f5781y61zR08LEIbB/636FkWZmP6X89C3jsCkGeiOL
	NE3bca44+rdunk/Kmowu4woztfhgybWRk1ruoI5nHwcYuOHFJmSFG0aYECVUWGNvEkQbVCeATOk
	OaqTO2VnprIJob76wmNLpi6NmFqWAirw6R2gJzePt1bHurLKn3WlTtmzcziyBfJ1WJDeKh3p0bU
	Um0zFg21hjOp3A9qRzGd8hUmkA+c5AtdV8pfzsmLiUgnFtZo5XHb0FftP76LUoLOhugkQJRWLDh
	ZHT0HcOE4RSxZyyE94f7Coj1lsDkOnP+lxEosMyYbqVViOW83iWwxIpTfZV04/eu+M2KT8F1lwX
	vil6OvOMwreM2g5O/Xyxfa6kA2E1qhxe
X-Received: by 2002:a53:c349:0:b0:677:c075:a57a with SMTP id 956f58d0204a3-67a0e57efb3mr1569403d50.108.1792623317429;
        Wed, 21 Oct 2026 15:55:17 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:56::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b1301045a3sm18422467b3.28.2026.10.21.15.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 15:55:17 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <nat@pixelcluster.dev>,
	Tejun Heo <tj@kernel.org>,
	Michal Koutny <mkoutny@suse.com>,
	Oscar Salvador <osalvador@suse.de>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v7 0/5] mm/page_counter: move stock from mem_cgroup to page_counter
Date: Wed, 21 Oct 2026 15:55:09 -0700
Message-ID: <20261021225516.1620680-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8EBB4C0005
X-Rspam-User: 
X-Stat-Signature: wryq9swjeeiii9q87i7q1d1kcdw7q94t
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792623318-249667
X-HE-Meta: U2FsdGVkX1/FmoeH/PhhHs09BPaNySCyh12/yYKFPflQiFoKzEDi99nwWfJ/mT2swu7sYunJxbCbJ22PrCzFlkZeaeYfj7GsgSVh1+Mwu+qc+yDUORFxCF4Of9O2DnSGqVLwHslAysnoXzJcjpxaGT/1DxRQd8RRqf329NblwUhCbfeGKeZqPOqSr3TdDHtylCHmHUmrSgdOeg/t1glVp+TZiPqA2Z3Ytiqoj5mgKxFgE4k2AhLFhCgPKkIdLTepCSh7yJSp5QrNPumZI630VI5reu9ozv55XU0kKsfadaUg3Mt4GZU8Dci0TqYaNHK2xbiy93nNMfhAlxT+pXYyFMPtlZ0BZfe0M8oCBo5fuRQfASfAFCh2ilz9m9JRLQBUBYRd5joNnPsFyOjwehKcG/ddZr4U30idOMuPdH68kUod3ts8jPVu6ns8U06wBuvwoQIBNW0d+kTaCgb4ulG5/nasuHhNDpQPovboQ3LeKQYFzvdY3h+0wQiKv9YV1kFZps8Kku62SwyGkHFEqFfKmEBPnQ4+x1XZ3JJt23tJWsy139D9+talhbkyo3R9PV6v4aMjaSgxEU8kx9aNVXt49HXirU4sfTa8NqdOgq3xDRnqqR8wA0JxuY4tF1JRsk3MJIHHX6pOyoRKqLQ+NaPZfyya9qh/tWvKtQO2WT6YBLEBGNzrZSI6zt+sJYJsSJu992Wy+2ijHUW/ve2kuY1Xi4DMEtUcY5NVqGM3K0NbVXq9dPmu6bt50k9nmKNncwhStzqD2z4FlgTAbjKZaJW+HdIOY7Fq+/Zd1wQUXszXC8fuB8Ge8PYGQLiUq0Xpgs0VEfQ6Svaf0CO2I2hUr3pivND977/FT1M9/Kp42Gc4wyL18z/OED/osGNRFyQPH1wUxUSlucrtGENYP1IAjPQtLAniKqX31Ck9YqoE5JCSbrIAVLU+5ubYXdlggIyyMoKQZK8VHA0ZACrwspGbIpn
 HFhpAdim
 izrnGG6r4HuNJG+AH0ptqjPTCH3BUEgJ5bfHrORelGQULMNUCRWITezRGxELM06qrvGMIU9UdX0vLYba4P0uriTrRupT/di78pzH8ZMbza1LzxDA0Dmz0NzCBt4ZLRfd94gHkyLUM8U0WjfUYoRJL1HcvEsVTg2jLQ3mjoFKWJZBiVVQIEAdqHN4JIB3F6tPzqGyv/NiEexCEpLNm4MV9kdkdWKAthGQUy4qqPgI13jgX+hZaqfPh0vpSoqjigYzZ4NCuZS1vLUaGEEtvmmg+2OFsiICW91jzXfQGbGETjSmeVOILCNSGNl2/piJ7Ektc5ML862a1Ol5WJO3rxyEbrtEUbahHHi4Z+hEjDUodGUpFZ6pPUKue7Dfgjf4usamx5Q7E1BFGm7Mw5nyMdIRCnQAw5p26Jj8TE45FR3zw8YjqK9C180o+sXGlwAsoEGFHXGx/M94knq2pkqentKnbTJHCKFeOPfgYKkELRLVVTs6BRGEnig57rrkk33VjdvsIOMnu4vVLKxmV53+348/Ljbq8/OoU/uRRqSFSznqDfqz+YQOuLdKE7R05NnD9CbX2+oCu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

v6 --> v7
=========
- Preserve two cgroup v1 proprerties that previously followed implicitly
  from sharing a stock:
  - memory.usage_in_bytes <= memory.memsw.usage_in_bytes
  - Reclaim does not swap when memory and memsw have equal limits.
- Wordsmithing commit messages for 4/5 and 5/5 to document the
  cgroupv1 divergence (bounded) between memory and memsw caused by
  independent stock.

INTRODUCTION
============
Memcg keeps a per-CPU stock of precharged pages so that small, frequent
allocations do not walk the page_counter hierarchy every time.
Today, the stock implementation is within memcontrol code, even though
the operation it caches is a page_counter charge. This makes it
difficult to add new page_counters to a memcg and preserve the fast
path behavior.

This matters for future work like my tiered memcg limits series [1]
which introduces multiple new page_counters to memcg. Without making
stock a page_counter-level property, it means that every memcg charge
now goes through multiple page_counter hierarchy walks, instead of
being able to cache these charges.

To make future page_counters scalable and performant, move stock from
mem_cgroup to page_counter so that each page_counter can opt into its
own per-CPU cache of pre-charged pages.

We get an added benefit of simplifying try_charge_memcg(), which now
has all the stock management handled transparently within the
page_counter layer.

EFFECT ON MEMCG V2 USERS
========================
This series has no functional changes intended for memcg v2 users. We
preserve all draining, refilling, and (un)charging behavior, including
the uncharge path's refills / direct uncharges.

EFFECT ON MEMCG V1 USERS
========================
For memcg v1 users, the decoupling of the memsw and memory stock means
that each of them now manage their own independent stocks and can lead
to a different size of precharged cache for each.

Cgroup v1 has an invariant that memory.memsw.usage_in_bytes is larger
than or equal to memory.usage_in_bytes, because memsw is a superset of
memory. With separate stocking, this could have been broken in scenarios
where the memory stock is bigger than the memsw stock, leading to
memory usage appearing to be inflated and greater than memsw usage,
even though the real usage preserves the invariant.

Preserve the user-visible invariant by reporting memory.usage_in_bytes
as the smaller of the raw memory and memsw values. Both counters are
upper bounds on charged memory, so this remains a bounded stock-related
overestimate and importantly does not affect limit enforcement.

Based on latest mm-new as of 10/21/26:
fcec4f4bcc110 "riscv: mm: fix concurrency in mark_new_valid_map()"

[1] https://lore.kernel.org/all/20260807202059.2620949-1-joshua.hahnjy@gmail.com/

Joshua Hahn (5):
  mm/memcontrol: flatten try_charge_memcg control flow
  mm/page_counter: introduce per-CPU stock
  mm/page_counter: make page_counter_try_charge() stock-aware
  mm/memcontrol: move memory stock to page counters
  mm/memcontrol: add stock to the memsw page counter

 include/linux/page_counter.h |  35 +++-
 kernel/cgroup/dmem.c         |   2 +-
 mm/hugetlb_cgroup.c          |   2 +-
 mm/memcontrol-v1.c           |  17 +-
 mm/memcontrol.c              | 352 ++++++++++++-----------------------
 mm/page_counter.c            | 209 ++++++++++++++++++++-
 6 files changed, 361 insertions(+), 256 deletions(-)

-- 
2.53.0-Meta


