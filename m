Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D976510706E4
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 15:25:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41B086B0096; Sat, 14 Mar 2026 11:25:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31D2F6B0098; Sat, 14 Mar 2026 11:25:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8D06B0099; Sat, 14 Mar 2026 11:25:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EF5C26B0096
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:25:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAA1713BCB3
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:44 +0000 (UTC)
X-FDA: 84545043408.04.AB8C517
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id D3B6818000F
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 15:25:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ki5+Sz/v";
	spf=pass (imf16.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773501942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ggISVxzQUfv8963RRxSmcP19TZhuJ7JM1vyo2f42mPA=;
	b=g1CBXkJPy5YldVxiOK4beTRWWh6iyEBGkqYbf2hsyKINZvNj1Pd4lZ6tJx6zexhynViyJ3
	FNQUnWapboeO3NTZk56+nE0nVQkf4DV28f1Drt84t98t6K+uDlhs0HSwGapc0sVg1A0YG1
	nsK7cYFFp+5WrXnOuavks+0H/CqpdDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773501943; a=rsa-sha256;
	cv=none;
	b=iI2TPvQeyPgOc1f8gly087jdatRm/gMAQtqRrvCc/N8FQuGox7ZXRNzIyxp1a0lMzjZuBJ
	0GXYhAA5oLFRgH72KE1FG67FSssQyLJ3voRo3bp7+iDitXdQd6Y0LXAmC8lYw+mSuaBONe
	2E/XzhRNDxy0gM2MXYgaN1Z8GMiGDfA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ki5+Sz/v";
	spf=pass (imf16.hostedemail.com: domain of xaum.io@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=xaum.io@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4852f8ac7e9so36701635e9.1
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 08:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773501941; x=1774106741; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ggISVxzQUfv8963RRxSmcP19TZhuJ7JM1vyo2f42mPA=;
        b=Ki5+Sz/v+Wk6deQDnSJlpEKIx+1J/NRSmHxhHHQsny0xd96wnZElUzFnvgRFMNVxVS
         Df48g3CrWynEnC4YI3VmyUm4KNW7bRjOUw+ElowNnxB9YXjR0Suo42IQAXmm298ztuzg
         lRVHxI44vShRpe+w9chGwq2mrdoCuQH5bLB/qqythBtvPCM4JNMw6Ax+fAvMZaCUN4XJ
         8lrLUJX02DdNGl/1jQt4yl2h4lYHBUabNbVMyg7XWtqhTpX2TSmvgECpCiQffCwjPlG0
         EEzUS8ZZftaG63FdipTh4X6/MiIrCdF5j3pPjp8YapHzHyk8dc4skrIQCvCxX9wq4kt7
         +Gcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773501941; x=1774106741;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ggISVxzQUfv8963RRxSmcP19TZhuJ7JM1vyo2f42mPA=;
        b=dWVRIJrU9JrpV/WtQkAHdooCJdFdoymh8ifKJkkyilai3cwjrJ9hxQCHKRdXMJravm
         LFtaxj1IJwFd3lLefArwdgBmEUY0f37UFeCeql3NIfNl8hUGq014HGcp953RbN/fgh5N
         xgjqO03vJszDf3C0nfJ51Qwy2zJU78Xv9iZ0s8D282bXJTTuzA6BzD9fasglzKIApa0u
         AwQfGwXpYAQYhCqy3fGHcOmvIqxsHoQ0OFgZxHKtgf2AuWT7mpe3pbGrSJ+Hye48VPky
         8DA7wkaiaCnOvwDr9UrCHdPtXHjBd/mZvXkjNltM0ZtP4FFEDjN1kLfZTAEs/c3yPaev
         OU5Q==
X-Gm-Message-State: AOJu0YyNc/h9+qJEP8VvOAnLrBs2NqrAvrmAQtlujdutPjErHzs2afN8
	0f+194lSCPyvMfvdMAUnda0uAZFVpKzel9WCYZWjaiwcllDIVXHVlism
X-Gm-Gg: ATEYQzyYtc2PLX7hSENUM9FG9k/J0RlEsNzm84J9HCwGsKxprs/eIsKPrM7nQC3uyuC
	ru7kvyTrRRk4sMyw7EQ1VpXliFttCeQeSO0wlqPNF8jC+68CMOODhpofWw61Pgt7qwOTJN0bhV6
	JJF+8ZAkymyBlJn3M1wpYh+tEsHPRIGrmoGOCoB6W8i97xbqe5ZcqgZR8bi6aMIIInXbCPEh2Ep
	TcbgjU4QUpqBQmPkRBGKQHf0fn34nAjHgNtQH9FXpQL3pPB1g0qHjxQurtmWQE7m4ZHc25NJyTX
	JTevBzCP1wv2gMwJW+vpo2bsLWy+9qGW/omQW/ShEtipOFlmQGxiHkZnUNm6Fv/+L+OtiqrdNOF
	CBTFTEwajXGHra5XQt0vSyBgmYHKfwb8qwR7OAdF2nnTyOYK0xT2CiV2PS0axMQuMzkIwI7Zeee
	RllN5NFb9iyj0HQGTsh9qBILrI5iq8OyJMM9zS6eNwHhke1SmIOLA2AbuQbzIsmFrbLvOIElJzc
	fCwiOSfrY26TbdC+BO3Z7F16IOyR2a6TjpElWuP
X-Received: by 2002:a05:600c:8b45:b0:485:35ba:1d81 with SMTP id 5b1f17b1804b1-48556703194mr110283255e9.21.1773501941355;
        Sat, 14 Mar 2026 08:25:41 -0700 (PDT)
Received: from DESKTOP-TILNSD1.localdomain ([139.47.104.103])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fe1a72cdsm27061783f8f.9.2026.03.14.08.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Mar 2026 08:25:40 -0700 (PDT)
From: Kit Dallege <xaum.io@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	Kit Dallege <xaum.io@gmail.com>
Subject: [PATCH] Docs/mm: document Shared Memory Filesystem
Date: Sat, 14 Mar 2026 16:25:38 +0100
Message-ID: <20260314152538.100593-1-xaum.io@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ns6kag57ft3j5hzoipoiyeyya3ifztju
X-Rspam-User: 
X-Rspamd-Queue-Id: D3B6818000F
X-Rspamd-Server: rspam12
X-HE-Tag: 1773501942-7828
X-HE-Meta: U2FsdGVkX1+nQ8XTyMjOtKd7x8HWKiSC6G/sYxW0fNP9oEGZUfsmtUEuDsTQ6AOCWp3h2UN47pu4TXO5ClDr6zhEHC+I3ohkbJTJAs5mYrrnx7vr2Ir9vJg/GCyFDiEkclCfyxG/Ipqr+v2NzuSQT2AYmMy+HytI83JzHzIXBx8c8atGm+V24rSYZ1Ukc2i39bopkWSSC9wiRV+Z7AiLwUOR+vlUH0ZXOUWx5aVEDcI937J72c2WGV2QIdmwdkeWUeUq0sXCK/hI/12F3j3vmtLBMZ4zvbrZKaYdSOFFiny5JZW34mQXTto9Ddd6rb1XUMowLuWEogpM91gvVsEZFxgF7WpJORJUNwQeeziEhDATnHRp7yvFsHtK4q2WSB8/TELpmNlTj7cAVgak7QLZazDQ8opf15z/lM4nK48i2om/7rW3QBuP6XoYBw18DKzSXgVcDtMVDKUyWhWnC6sJvJjAtri7OgGmXRPaJQ6YL9JAZgcAwddf+1ndi6TKz+BUuO+4c7aDWnlAO413lYSJu0S7mAdbA1vHqZ051oXfN6tT8AgtwMG9Xmha7b3cLZgI/KtysaRaaimQzHKaJEscuATy1LZJmNKV39Rmn8mloKAzVRx4ciIGsvdL2dqChXm6+n2b+nu1QgzjX2QouJJ5Sw3XlBWaoluW5ztKGskeA9RWE0XOHQBDa+WYe+wYIWnxBk2tZcfJWfZdRjA7f+Pqi6Xu3U7pqGvChAXVOuxen1QpdX8xoJIbRD8GU7kWjjSpS4QALjQO4xciOg9AE0iDevVg75lnW8nGyKrcwvZfdmsqXP14TywqLJggt8FloJz5p2JNF37gRZY349mjzG9l6G/a2CO/VQrXEroO7YVeWjGLvGHlHZJxKAGWEcE26082b23kxVDAsKORKWTVZK0kGhcEKQRghlyHlKlallgvIVyD4f/8kTl8B9jvZU7y0uf13uitZGmQv+yFOZnpOz+
 8+RkT0HL
 +j+zOgH18I2oBKlLK/u5Yp578J6jh5zk/r8q35A5eBwXmVg8XIKaz0n5EdzxLiXBFdrMZB4lb8BCQhssyfTjeCK5waVisQ62zKBGKY/Q4N6ZqOHut5efs2v5h6UjIe82CwJfyOhAQLkLrNSdWwunWPXYsvWym81Wh0tldUQ8ATDLLEi7xM1lgyaRc2IDbVVsgOgGIApGK614lJRBU+M55JPflXyvdQfPYNor3Ca22/dwUy+QnuRkHGe5N5pSoeDS09C3vNVKxA/v88BBpaX+Mn3na3ednw5u8LzBp3G79QqEg2rsiazXHUgD/TP9tGCh7Cmv8phG8MPzPybwlhAAm/G7jUIIJD96Ggo9sIofv7DWhA08J0MyUNB6ORxl2Uyx5Y4iUfDiFxyNZZCVMN1P1e/wPN6vre/JdJ9k4LIsM0LkKcw6mt34G6bsSMOTYYsUTvEC0Tt9wkRPkV63OqMtpznJWx8HOzBemRiEAKfsa2Gd7iJU7aTlxBTyjEf8l538nSuXQUlBMLzn3eBdKK8HT8Ty4dapTPJxvioxUUGDVmYbHrow=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fill in the shmfs.rst stub created in commit 481cc97349d6
("mm,doc: Add new documentation structure") as part of
the structured memory management documentation following
Mel Gorman's book outline.

Signed-off-by: Kit Dallege <xaum.io@gmail.com>
---
 Documentation/mm/shmfs.rst | 114 +++++++++++++++++++++++++++++++++++++
 1 file changed, 114 insertions(+)

diff --git a/Documentation/mm/shmfs.rst b/Documentation/mm/shmfs.rst
index 8b01ebb4c30e..1dadf9b481ce 100644
--- a/Documentation/mm/shmfs.rst
+++ b/Documentation/mm/shmfs.rst
@@ -3,3 +3,117 @@
 ========================
 Shared Memory Filesystem
 ========================
+
+The shared memory filesystem (tmpfs, also known as shmem) provides an
+in-memory filesystem used for ``/tmp`` mounts, POSIX shared memory
+(``shm_open()``), System V shared memory, and anonymous shared mappings
+created with ``mmap(MAP_SHARED | MAP_ANONYMOUS)``.  The implementation is
+in ``mm/shmem.c``.
+
+.. contents:: :local:
+
+How It Works
+============
+
+tmpfs stores file contents in the page cache using swap as its backing
+store rather than a disk filesystem.  Pages are allocated on demand when
+written to or faulted in.  When the system is under memory pressure, tmpfs
+pages can be swapped out just like anonymous pages.
+
+This design means tmpfs files consume no disk space — their size is bounded
+only by available memory and swap.  It also means tmpfs data does not
+survive a reboot, making it suitable for scratch data that benefits from
+memory-speed access without needing durability.
+
+Each tmpfs inode tracks two key counters: allocated pages (resident in
+memory) and swapped pages (evicted to swap).  These are maintained by
+the ``shmem_charge()`` and ``shmem_uncharge()`` accounting functions,
+which keep the inode's block usage consistent with the filesystem's mount
+limits.
+
+Page Cache Integration
+======================
+
+tmpfs uses the kernel's page cache (xarray) to index its pages by file
+offset.  When a page is read or faulted in, the page cache is checked
+first.  If the page has been swapped out, a swap entry is found in its
+place, and the page is swapped back in transparently.
+
+When a page is added to the cache for a tmpfs file, it replaces any
+existing swap entry at that offset.  When a page is evicted by reclaim,
+a swap entry takes its place.  Shadow entries (see
+Documentation/mm/page_reclaim.rst) may also be stored to support working
+set detection.
+
+Swap Integration
+================
+
+Under memory pressure, the reclaim path can evict tmpfs pages to swap just
+like anonymous pages.  This is transparent to the filesystem — the page
+cache slot simply transitions from holding a folio to holding a swap entry.
+
+When a process accesses a swapped-out tmpfs page, the page fault handler
+reads the swap entry from the page cache, allocates a new page, reads the
+data from swap, and inserts the page back into the cache.  This swap-in
+path is specific to shmem and handles locking between concurrent faults
+on the same page.
+
+Huge Page Support
+=================
+
+tmpfs can allocate transparent huge pages for its files.  The ``huge=``
+mount option controls the policy:
+
+- ``never``: only base pages (default).
+- ``always``: attempt huge page allocation for every new page.
+- ``within_size``: use huge pages only within the file's current size.
+- ``advise``: use huge pages only for mappings with ``MADV_HUGEPAGE``.
+
+When a huge page is allocated but only partially used (e.g., a file is
+smaller than a huge page), memory is wasted.  To mitigate this, tmpfs
+registers a shrinker that identifies huge pages where the file has been
+truncated or punched below the huge page boundary, and splits them back
+into base pages so the unused portion can be reclaimed.
+
+Accounting and Limits
+=====================
+
+Mount Options
+-------------
+
+tmpfs mounts accept ``size=`` and ``nr_inodes=`` options that cap the
+total blocks and inodes in the filesystem.  Every page allocation is
+checked against the block limit; if the limit would be exceeded, the
+allocation fails with ``ENOSPC``.
+
+These limits are enforced in-kernel and apply to all users of the
+filesystem.  They can be changed at remount time.
+
+Quota Support
+-------------
+
+With ``CONFIG_TMPFS_QUOTA``, tmpfs supports user and group quotas.  Each
+allocated block is charged to the owning user/group, and allocations fail
+if the quota is exceeded.  Quota state is stored in memory and does not
+persist across mounts.
+
+Memory Cgroups
+--------------
+
+tmpfs pages are charged to the memory cgroup of the process that
+instantiates them.  This means tmpfs memory counts toward cgroup limits
+and can trigger cgroup-level reclaim.  Swapping a tmpfs page out and back
+in preserves its cgroup association.
+
+fallocate
+=========
+
+tmpfs supports ``fallocate()`` to preallocate space for a file.
+Preallocated pages are allocated and inserted into the page cache
+immediately, guaranteeing that subsequent writes will not fail with
+``ENOSPC``.
+
+``FALLOC_FL_PUNCH_HOLE`` is also supported: it removes pages from a range
+of the file and returns them to the filesystem's free pool.  This is used
+by applications that want to release portions of a tmpfs file without
+truncating it.
-- 
2.53.0


