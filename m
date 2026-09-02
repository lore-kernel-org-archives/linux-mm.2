Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B478C624D4
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 19:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 131E06B00DA; Wed,  2 Sep 2026 15:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E3BE6B00DC; Wed,  2 Sep 2026 15:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002A16B00DA; Wed,  2 Sep 2026 15:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C1D116B00DA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:47:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 333A8A4294
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:03 +0000 (UTC)
X-FDA: 85169855526.04.E1A2F6B
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5E759100004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 19:47:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RwNLnTqH;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788378421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=043T58xMxK5U0+nF6j3a8AXR/ljZlHLZb140yWsthLI=;
	b=2yu2s7+KzhGtPsbCQ2M2jcEORmUTgJQqkHGTyaiBXH0Jr6Q3pUsbHCJ1nMkFq714GMpHm+
	gFWxqQ1oVN+I8trOq6RYTdfgnply4ZMaYfF5CX+BGcnzyb5ofqcbXoEjY8AGdJZ+7jiX9K
	0gidN1zudX1pX6rUoetbiL+EgfW2mS0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=RwNLnTqH;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788378421;
	b=Dnx0NvZd3sTw9L8xPFO80AhF+w3+vQRSukb9OHnqglgXMyvHwz/Itf4crH8U1/MKHVYYas
	wM+eaOXvSxQZt0C+lN3x34wxfTbxndVYrJf/KmjNPdathRBBHAMPDO4AzHlmE21VqDQWIC
	iSxO/jBdVEI+aqT9kXXJSrKmiTZ8pcs=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-9387752a4d0so133992185a.2
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 12:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788378420; x=1788983220; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=043T58xMxK5U0+nF6j3a8AXR/ljZlHLZb140yWsthLI=;
        b=RwNLnTqHsO5Iul9KI6xVc/zoDESP7v6ewrD/ObG5KJ03U54/Yiro18RbaItZnXkRER
         8v+Rs2MA/AothYBKQTpmvWdKyEnH3I4/21JzxJG4TW0FJXLhpr92mbI420Hh3BegLxPX
         J36uF3UWHjXPUGO94pcqaT3x/7qq2VHYm1PTxuAnlGnlNkqCRpzUzksQD+d4yzu9JYar
         VysalcAKbiko6YnjRpyU9c33zpeIr82DnZGmq7RcFjUyueR/QjWiTRGyyjlM4SBqWEzx
         QMCmtL5b5KTy78LkjNLwP4w/SzySpVlOcm/Ha4tgZc+jBphQpNHE4iCNbW4XPGfZsDpH
         I/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788378420; x=1788983220;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=043T58xMxK5U0+nF6j3a8AXR/ljZlHLZb140yWsthLI=;
        b=e/Ycne6u10S0Ut0tP4/5ysN9xD5hXVBmwoSxk2W1rHJdA0gYFoRm6hhTA45aJQO3hh
         DvYc6ugcD54L/eQuu4V45QGxx1OVevnBkbJbsmJ4N77VK4qJ2IlUKJ2i1IZXqe2REYn0
         y5Jstnb9Ri/aID2Jl4QFwsNKSrIhLH+dKnWo3+41hiHweJdjipBq8hZeqXdLzLqdx27u
         +VwvfcuZDrjgUT6ozWfRbylhcXlOgH7jhYrDO9ti5scF6LaE21vn9yEaL61w6ONm83G4
         dj0Rb0tEvIGtfLiN3Dg3WBIwKnTqfYFYi/swhDyPsIWDivfrEnL9I9xyuqZaYpkZx/qm
         RM8A==
X-Gm-Message-State: AFuF++mzrvCeFWScPwf1pDZS2vS0Uvt+YQMS7PJEVOsmwyIvWn3NG7lm
	7OfcKuZMqlgvT6soVAdVvH3l05zz4VqueYkmamFsdzihVB2Z7Ag7f2H9gOknLaOzHzMnRaUwq0c
	kDfahhy0=
X-Gm-Gg: AYBFou1d0A7PWYvX63/RYwa2ZOf7wZFzlA9UHDNs1NwDxT+mF/dyJdy1y6d1ao+oaGP
	Y8O/JykZ5SdORUT4fPgiHUa7dUI5z6YE9j6EYrtthNOxitHPRp/oLQD5wKniHUTOte8+YY/j7SK
	XrK+Os/82DHr9p+60gYi1Bsc40EFAacq43CWKI3A1K82r3leYJnDmyyCiBYSVEuOVzo0MYhCb44
	grsRgBesnq6UHcBxv993j+ZgK7rreeyItWwk93CZbdCoKTFsdGNHC0XjbP/wfVha1M2P8A9V+Wd
	4Qd4mLwo99+Zk8+fYdkzpxNiep2YfL3f8Jrhxy0gQ8Rjav5B8H2lo9knlnPsl393vNQhtAzapUw
	C+7xbqb7goXCL+kc/PQy9z2/IUuDyV+l/9/YSFc1l/O4Thw26zzwLelYBb9MASH57wL3zPaV3S4
	dQRQRJR2AeQv5WrpjCTbJI2uM819GSzW2/LhZ3hd1re7njh6fBcWTpFnVt9FGZLpvwc9U+K/RUG
	25EjqmKEL+A+woBuv+vqbvCJw0I1NJ9iS891+4N8L4lZs/KlynBPnRwSQuh
X-Received: by 2002:a05:620a:5bd3:b0:939:6de7:a623 with SMTP id af79cd13be357-9396de7ccf2mr158269885a.47.1788378420256;
        Wed, 02 Sep 2026 12:47:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9395f18801asm299300585a.16.2026.09.02.12.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 12:46:59 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	shuah@kernel.org
Subject: [PATCH 0/5] KVM: guest_memfd: bind backing memory to a NUMA node
Date: Wed,  2 Sep 2026 15:46:52 -0400
Message-ID: <20260902194657.79075-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5E759100004
X-Stat-Signature: zbckpdfghcd5xr7pw556t7naxnw9wjkk
X-Rspam-User: 
X-HE-Tag: 1788378421-908236
X-HE-Meta: U2FsdGVkX1+wu1HIyX5HhEfu0rP35A+NepQrr6p+wFOopfo7xprdahmhI1KHk/+5332WMh5VfeJuRSCl16mtRy46i89JiBmDsyXEw9ZtqXe+2xE4gHkAxsU/OkhhSNS8ZpFfzSx12YZbcTgAo4++lTTu2GLfSSYR7d6SwNr8Mt0taiMKyBq2gdVF8ubGRET5ZHQLbW6xgKf0ymxZn0uWX4jZfTo9ppIBXINbzthQ3EZI8jjSO0OhrFCAyRi0d4J3y7KkY0tB71XGVbfJfygd18AFroMcJT+rKKF3OAKUD4F6kaxWhIUp77mkc+crOXzBWQepMF0eAefk6K/Y/0DPv05GnLeJJXDnKOIq/nzBsXGttD/8cCVs1FEBpZEVVS4a4kgaEl/9A2Mf9axoISdPwdLcbyW+IOB45e6FKQoiMBU+JH8Xg4LVqeDw3BBPgB4+YwChx8amt/SlGzsD4SEOqSvwReIoT4QH/FFoJXqjW7QKvP8eiPjGUNiT69DVQ9EID9ke4sHyL9oDWEuCt6slhGtQRaDsq+U+wk1FYmPbAycCgkAqjHhZMthi04va1USbOspWiZn+130oo8YffK3HbQImh3z5hrEdzr7fp/FxnevftttOxKxALu3ZF2ynyBxAyBGqmd6pu03kV9yoTDRV8tEiieGvoaKKuAFtgjeJbDKQWncPylJsbG8Y1/gUP81gkXU3mj7lsd8vsBavFn8GIbocm9zYOdOqqTiQ4aPXMu3MgpWWIL/5WNbVZ21ItVk6ncitZM0YKmO/uItVI4tSAbmkmTLTMnejRmNPt9STqpxp5betLe059gVRF+QI1ARmZ219Mz48qoh7GCm5mIIdg9hieVUZVVVBLJDqJ5jPyXQuC7KDRsrV/qIuUzAMGM0JAJ17on2uaGKVlzQRReSLiYYr4MoLLYFw+soRkivV5ZHObwLN3S3eCyQKuaAJI80xL+emuaQ1/39rZ7toCRo
 h2Ta3MOA
 P7dOMuUnxba09TqfDfAehZA48s5fvOVlPJ6SqB3/G6i6exoNjJHueYc9JZnwcvTqFFyWV6nDANdQNhhBghEpE01rIC8bRssjT8jBqJy+f8Zqn4Mgc9lyibtFoyNlwZMed6IF0p6WfUw1hETcwC4IufiH0bYCN1L6JwBA2yUeJHIYrfczBDPq+LxkH1dJzGeeJmFrW+5eNubQweaXE/7StEgwrMKbS6L+aBGhnhl/zRmYIefHKMdINlOVPNp7RWyYuBq91riNiJVEOWoBGM2g0BfyRyxtm2eZ2136igVRx8pQxgSj9Tt23ovMl33+BcPVdDosHpsX3IXUYwqyfTzWioGYXvZjdOgzw8isil+65n0GV3YA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

guest_memfd allocates its folios through a per-inode shared mempolicy.

Today that policy can only be set after the fact, with mbind() on a host
mmap of the fd. That requires the fd to be mappable, and it cannot reach
folios that are only ever guest-faulted. Neither holds for a
non-mappable (confidential) guest_memfd.

Add GUEST_MEMFD_FLAG_BIND_NODE and a node field to struct
kvm_create_guest_memfd. When set, KVM builds an MPOL_BIND policy for the
requested node and installs it over the whole inode, so every folio is
allocated there with no userspace mbind().

  1-2  mm/mempolicy prep. mempolicy_create() builds a validated,
       cpuset-contextualised policy without installing it into the
       calling task. mpol_set_shared_policy_range() installs one over a
       pgoff range with no VMA.
  3    The KVM flag.
  4-5  Selftest harness support, and the test.


Why a single node and not a full mempolicy?

  The fd is the unit of guest NUMA topology. A multi-node guest is one
  guest_memfd per guest node - or one range per node, since
  kvm_gmem_bind() is offset-based and mpol_set_shared_policy_range() is
  already range-capable - each bound to a host node, with the guest
  placing memory on top. This is the shape QEMU already builds with one
  memory-backend per guest node.

  Interleaving a single fd across host nodes would model a guest node
  whose pages are scattered underneath it. That defeats every placement
  decision the guest makes: guest NUMA balancing, tiering and weighted
  interleave would all be reasoning about a topology that doesn't exist.

  This narrow implementation enables the only clear use case.


User-visible behaviour:

  mempolicy_create() constrains the request to the task's cpuset.
  A node outside mems_allowed fails the ioctl with -EINVAL - the same
  constraint mbind() carries. A task cannot grant a guest_memfd access
  to a node it cannot reach itself.

  Nothing rebinds an inode's shared policy on a later cpuset change:
  mpol_rebind_task() walks tsk->mempolicy and mpol_rebind_mm() walks
  vma->vm_policy, and neither reaches a struct shared_policy. The bind
  is fixed for the life of the fd. This matches shmem's implementation.


Testing

  guest_memfd_test under virtme-ng, nested KVM:

  - 2-node guest, test pinned to the CPUs of the node it is not binding
    to, with the task mempolicy aimed at that other node. Pages land on
    the bound node, so the placement cannot be explained by the fault
    being local. Stripping the flag from the harness puts them on the
    other node, confirming the check has teeth.

  - CONFIG_NUMA=n: the flag is not advertised and the tests skip.

  - Single node: create/mmap/fault coverage, no placement claim.

Gregory Price (5):
  mm/mempolicy: add mempolicy_create()
  mm/mempolicy: add mpol_set_shared_policy_range()
  KVM: guest_memfd: bind backing memory to a NUMA node at creation
  selftests: KVM: guest_memfd: let the gmem_test() harness bind a node
  selftests: KVM: guest_memfd: test GUEST_MEMFD_FLAG_BIND_NODE

 include/linux/kvm_host.h                      |   3 +
 include/linux/mempolicy.h                     |   5 +
 include/uapi/linux/kvm.h                      |   5 +-
 mm/mempolicy.c                                |  75 +++++++++-
 .../testing/selftests/kvm/guest_memfd_test.c  | 134 ++++++++++++++++--
 virt/kvm/guest_memfd.c                        |  44 +++++-
 6 files changed, 248 insertions(+), 18 deletions(-)

---

base-commit: da6c37ed8beb273e3308e42d4bca3ce11b4432fa

-- 
2.53.0-Meta


