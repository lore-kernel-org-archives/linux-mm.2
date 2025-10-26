Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0F8CCCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 20:36:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C72F08E0120; Sun, 26 Oct 2025 16:36:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B11488E0184; Sun, 26 Oct 2025 16:36:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FCFE8E0120; Sun, 26 Oct 2025 16:36:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 875738E0120
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:36:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 50E83586F3
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:31 +0000 (UTC)
X-FDA: 84041423382.04.8B8B5CC
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8AE2D16000B
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 20:36:29 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cwXSvVE9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3TIb-aAYKCKETVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3TIb-aAYKCKETVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761510989; a=rsa-sha256;
	cv=none;
	b=W9aFPfW/taomiw4xrpVCPZq37yp+tAGmKQn1O1RCkdDm3+7UpRfFeiTuU0KtkDZmhke0G6
	OoYUmB43hxjcaxtLVEDNhguA4xX6hqrLzVxGa1Zp3uI4UrKmrRUFChjyk+lFkkB9yhbGYT
	fK9k+WUoTpFSaXHb3bqt+yDMltZd5vA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cwXSvVE9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3TIb-aAYKCKETVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3TIb-aAYKCKETVSFOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761510989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+hwvxvjiT/648L8Azhj+YaogvoFsk4ZqGTdVX9dBk8=;
	b=4scl/vMsfRcQqiPed3GFiJTToV2un96EK4XhhYwz5/WVXv36Q9Dz1lCMMsRMdCJAXKAT32
	J3KowNhtBAIQUChyRFzB4q2elbOX5FU2NIF+1mBHvE9x6hbFDSAouZ5exwcs3d7kmvsGl8
	MiCglYWJrha1ILokwXG4oR6UJ2DgRtA=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2698b5fbe5bso54164745ad.0
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 13:36:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761510988; x=1762115788; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=F+hwvxvjiT/648L8Azhj+YaogvoFsk4ZqGTdVX9dBk8=;
        b=cwXSvVE992pCpKU4de8+l5m3AFAdiW8m6WXc+eYUa0cwFgaS99ZbS7KAKvMAeTYOZs
         pAS0f0m5Ujhx5R553fjMgFGYJPWWZwGFWs4P7Fet2HJNlsnJ8BXOTxhgffxfSg7Ne1DY
         U0IMuclj7vQpVbsALRKbTdauyFhaf0cKbfuteWaLt9soRh3znFQVrTyVd39hkgsDTxKy
         nzfZdidCYzuKvHWEd+yfTBYnnRqWAHwGad1nFA2NiWqyr93CUbsu8FmO7RuTaiB3CbWO
         C7elGyxFZq+ma/y3uralip5Po4t2o+d89oB18CYMzTqZtDKi7btxbIU6hlRO+FDXxbef
         +pcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761510988; x=1762115788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=F+hwvxvjiT/648L8Azhj+YaogvoFsk4ZqGTdVX9dBk8=;
        b=YxgymCB6PxWQNbl8wQson9HwkE5OOwh6bEvb69QKrvaNHEtVMHzIhNcH/wQO0c8VL4
         aysdCS8S06k6gq0gAGCRqLfpTd8TR4vFqaqGFHuro20ubwxObgSgsaNqTTlhnXR0VL5p
         MvRqWnlMRKy7/Wv9brD5xa3xRalHMwZ2gPzRAPhVAmHqdiSbgPD8igAQ3Qwqo97yoCpQ
         JWLMXS9XmQvAGwZr+B9GtfZoZ9spvOwlCdFfFS1RTYYcdNID+DIhQxKyZAaZAMix5WMA
         c9IlnIwFBkEcBm0MKkAn4gc8H4d+AltRYr1sIGWDOKfw+Fq2c8QLQgLB/VsQncSn0trg
         XglA==
X-Forwarded-Encrypted: i=1; AJvYcCWViBNz2RZoIozrKj4YW6aYG/n9yTuwLCiAVctDbCCIIOOXhnZ8uu73oHnD7uIX7Y9GmKMPxDnKJQ==@kvack.org
X-Gm-Message-State: AOJu0Yy76IXefG8tR4u143MxVER9DauWEChlv/nBA5HiX7M3b0wb4jYA
	HA/WB/PFvbgxiWnroC7we8aOin/RGbAnyajZ0ghZ3DfXeOTXIufrzDbIX5j00BkvQyLfpAPt2HE
	mG7EbAQ==
X-Google-Smtp-Source: AGHT+IEGiuaYNqtmzAs0E42cvktCDNQUumB1H3lnOt3eYy3N7OB3Lp+O2CXv9ksq+J9ruS+aEn5/XTF4vMk=
X-Received: from pjbgt15.prod.google.com ([2002:a17:90a:f2cf:b0:33b:b662:ae3a])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:1a4c:b0:24c:c8e7:60b5
 with SMTP id d9443c01a7336-290c9cb6243mr210845465ad.16.1761510988422; Sun, 26
 Oct 2025 13:36:28 -0700 (PDT)
Date: Sun, 26 Oct 2025 13:36:09 -0700
In-Reply-To: <20251026203611.1608903-1-surenb@google.com>
Mime-Version: 1.0
References: <20251026203611.1608903-1-surenb@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251026203611.1608903-7-surenb@google.com>
Subject: [PATCH v2 6/8] add cleancache documentation
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, alexandru.elisei@arm.com, peterx@redhat.com, sj@kernel.org, 
	rppt@kernel.org, mhocko@suse.com, corbet@lwn.net, axboe@kernel.dk, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, hch@infradead.org, jack@suse.cz, 
	willy@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com, 
	hannes@cmpxchg.org, zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	minchan@kernel.org, surenb@google.com, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: gwjo5j18tkdinq4nofjs4mi8uccu95m9
X-Rspamd-Queue-Id: 8AE2D16000B
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761510989-177451
X-HE-Meta: U2FsdGVkX199GTLWrS1CIZdOaibRoh/MXMtTyLCVpjZX7Wv6AYqU8k7xhfU9mUhAH2nqRmnE2T+g7nBVHzqvZHuks0RISmpILtFBduWi+WxPboZ6sWwd5g8EPXnKqcmm5LOpb/jz6h93K0fh1aEgcXGQTVghF05RhARu0h7dv27lyP6BvYd2gsTJTr9pAgKpP49IhhoMQYbpp0f1D8ggIRJFiO/B1v/wmry7EcT/bVwN8EY9IP8tHN2JVCJFnfI639uqd9/zwnsA1av/YXKkMpV1FgEpqEyPkuz8dByub4sxjVFbPImuQQvEYdy/MguET+oDMOAEPuak990kIrtI0rM7RlDac+Z4YipdYl6zn4yXZb6BfeJFNYQolH14Be4nBZaI7T0PPCHATRiIvxep2qP1zCs09z13i291jEmAlMH0ka5APKFpm7ytZMgxe+KDbZqy17KE/58hcXLp/E7BgWyZFgV841GJWciNWAFRi8spIOswKWoKP9LYFVmeB9xA4z9k9KloztCc0lqCMuuILLb02PXYhgDaqF9cATN8a8xQ6y7/GeeKOjyzbjnVFLX6GBbN1t/WI47hM5g5TDWlrxz4/OIKybsC4FyLpSy6nK1GRzPWFH53UOMdbozQJY67L5ZN9JkG1vY7i0WTjCgbhS/ot1IbzpGHVasienKoLMSkE5deHmWonEgmxsQEFvMqBpJVlsYjrnbatLRdIhg7tWoAXRgo45ZzKZT7EtmEeAKB+zusNlotzksguJ8/GIFp0fRanLHIzGi55+tgkhFql4RvFMRtWL0n68gZk6xThrbCuw0NcrTqowqfgF4neS4Zma4k0eSrwZZLMgeh3XKvAQPjiaqTvroCqm/994Q9T2LRpAOkPFwAFwAnA0PuGp+J6RpzZiIESoTCIwXdsxm+My9LaTLmQmD1WZn1nz4h0xyCiOrKTgJZ5sy+D8gyQPGWb4R10qaLaZ06GxcLS/P
 EuCvVTj5
 /MhQIoR1qE7UxAOkx8F2HQDl8sDyIhMW+3qslkJam22/roU1qYMt6n/USWIy8EyqRcfwzn9v6/VPFG/nlW78J++cLeyeDlBz5cAQfhVnVq6nFf0i2MHLsy644fih2BsRNixUL1S2OulTGIptssU43Hjgamn60Gz13Gm4tQ3pIfZjT0xniOxBz639g0DFkAC44Y9cjZO+EmkXUIz9O4AmSyIcaHBL/LWPNbmqmRlmaA4E1xXfL1AQsbYq/0P4RaAzaiq1lol/tb4HAKXCYX4QfhnKSRcxMDueSWY/6FoXttU/Vi/0ikX+6l3CB40LmeIbfucr9K1VnLCNpSN+brk+6d2UrWUnF4+agVRH2GsL66rTUuGl8wvCKZkxcoBRBwe0zlaf/hgBxVO7zXgUOtUbBJKZoR7eWPadXovhCg0wlxEMb5Pu9prP5iptV1HDuaVwB483JTVCP/FqQLGT3OdVfTpxG6KgA8UV7Gg8jrwW0EZ2d6nGZEK8xOBvL+OcFYrNLufE5uJcBYETNolsAwV2KiQd7RZ6AjsKRYbIUaGbjkeoMtn6rO6VKX7EUKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document cleancache, its APIs and sysfs interface.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 .../admin-guide/mm/cleancache_sysfs.rst       | 51 ++++++++++++++
 Documentation/admin-guide/mm/index.rst        |  1 +
 Documentation/mm/cleancache.rst               | 68 +++++++++++++++++++
 Documentation/mm/index.rst                    |  1 +
 MAINTAINERS                                   |  2 +
 5 files changed, 123 insertions(+)
 create mode 100644 Documentation/admin-guide/mm/cleancache_sysfs.rst
 create mode 100644 Documentation/mm/cleancache.rst

diff --git a/Documentation/admin-guide/mm/cleancache_sysfs.rst b/Documentation/admin-guide/mm/cleancache_sysfs.rst
new file mode 100644
index 000000000000..503f17008046
--- /dev/null
+++ b/Documentation/admin-guide/mm/cleancache_sysfs.rst
@@ -0,0 +1,51 @@
+==========================
+Cleancache Sysfs Interface
+==========================
+
+If CONFIG_CLEANCACHE_SYSFS is enabled, monitoring of cleancache performance
+can be done via sysfs in the ``/sys/kernel/mm/cleancache`` directory.
+The effectiveness of cleancache can be measured (across all filesystems)
+with provided stats.
+Global stats are published directly under ``/sys/kernel/mm/cleancache`` and
+include:
+
+``stored``
+       number of successful cleancache folio stores.
+
+``skipped``
+       number of folios skipped during cleancache store operation.
+
+``restored``
+       number of successful cleancache folio restore operations.
+
+``missed``
+       number of failed cleancache folio restore operations.
+
+``reclaimed``
+       number of folios reclaimed from the cleancache due to insufficient
+       memory.
+
+``recalled``
+       number of times cleancache folio content was discarded as a result
+       of the cleancache backend taking the folio back.
+
+``invalidated``
+       number of times cleancache folio content was discarded as a result
+       of invalidation.
+
+``cached``
+       number of folios currently cached in the cleancache.
+
+Per-pool stats are published under ``/sys/kernel/mm/cleancache/<pool name>``
+where "pool name" is the name pool was registered under. These stats
+include:
+
+``size``
+       number of folios donated to this pool.
+
+``cached``
+       number of folios currently cached in the pool.
+
+``recalled``
+       number of times cleancache folio content was discarded as a result
+       of the cleancache backend taking the folio back from the pool.
diff --git a/Documentation/admin-guide/mm/index.rst b/Documentation/admin-guide/mm/index.rst
index ebc83ca20fdc..e22336e5c9d2 100644
--- a/Documentation/admin-guide/mm/index.rst
+++ b/Documentation/admin-guide/mm/index.rst
@@ -25,6 +25,7 @@ the Linux memory management.
    :maxdepth: 1
 
    concepts
+   cleancache_sysfs
    cma_debugfs
    damon/index
    hugetlbpage
diff --git a/Documentation/mm/cleancache.rst b/Documentation/mm/cleancache.rst
new file mode 100644
index 000000000000..bd4ee7df2125
--- /dev/null
+++ b/Documentation/mm/cleancache.rst
@@ -0,0 +1,68 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========
+Cleancache
+==========
+
+Motivation
+==========
+
+Cleancache is a feature to utilize unused reserved memory for extending
+page cache.
+
+Cleancache can be thought of as a folio-granularity victim cache for clean
+file-backed pages that the kernel's pageframe replacement algorithm would
+like to keep around, but can't since there isn't enough memory. When the
+memory reclaim mechanism "evicts" a folio, it stores the data contained
+in the folio into cleancache memory which is not directly accessible or
+addressable by the kernel and is of unknown and possibly time-varying
+size.
+
+Later, when a filesystem wishes to access a folio in a file on disk, it
+first checks cleancache to see if it already contains required data; if
+it does, the folio data is copied into the kernel and a disk access is
+avoided.
+
+The memory cleancache uses is donated by other system components, which
+reserve memory not directly addressable by the kernel. By donating this
+memory to cleancache, the memory owner enables its utilization while it
+is not used. Memory donation is done using cleancache backend API and any
+donated memory can be taken back at any time by its donor with no delay
+and with guaranteed success. Since cleancache uses this memory only to
+store clean file-backed data, it can be dropped at any time and therefore
+the donor's request to take back the memory can always be satisfied.
+
+Implementation Overview
+=======================
+
+Cleancache "backend" registers itself with cleancache "frontend" and gets
+a unique pool_id, which it can use in all later API calls to identify the
+pool of folios it donates.
+Once registered, backend can call cleancache_backend_put_folio() or
+cleancache_backend_put_folios() to donate memory to cleancache. Note that
+cleancache currently supports only 0-order folios and will not accept
+larger-order ones. Once the backend needs that memory back, it can get it
+by calling cleancache_backend_get_folio(). Only the original backend can
+take the folio it donated from the cleancache.
+
+Kernel uses cleancache by first calling cleancache_add_fs() to register
+each file system and then using a combination of cleancache_store_folio(),
+cleancache_restore_folio(), cleancache_invalidate_{folio|inode} to store,
+restore and invalidate folio content.
+cleancache_{start|end}_inode_walk() are used to walk over folios inside
+an inode and cleancache_restore_from_inode() is used to restore folios
+during such walks.
+
+From kernel's point of view folios which are copied into cleancache have
+an indefinite lifetime which is completely unknowable by the kernel and so
+may or may not still be in cleancache at any later time. Thus, as its name
+implies, cleancache is not suitable for dirty folios. Cleancache has
+complete discretion over what folios to preserve and what folios to discard
+and when.
+
+Cleancache Performance Metrics
+==============================
+
+Cleancache performance can be measured and monitored using metrics provided
+via sysfs interface under ``/sys/kernel/mm/cleancache`` directory. The
+interface is described in Documentation/admin-guide/mm/cleancache_sysfs.rst.
diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index ba6a8872849b..7997879e0695 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -41,6 +41,7 @@ documentation, or deleted if it has served its purpose.
    allocation-profiling
    arch_pgtable_helpers
    balance
+   cleancache
    damon/index
    free_page_reporting
    hmm
diff --git a/MAINTAINERS b/MAINTAINERS
index eb35973e10c8..3aabed281b71 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6058,6 +6058,8 @@ M:	Suren Baghdasaryan <surenb@google.com>
 M:	Minchan Kim <minchan@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/admin-guide/mm/cleancache_sysfs.rst
+F:	Documentation/mm/cleancache.rst
 F:	include/linux/cleancache.h
 F:	mm/cleancache.c
 F:	mm/cleancache_sysfs.c
-- 
2.51.1.851.g4ebd6896fd-goog


