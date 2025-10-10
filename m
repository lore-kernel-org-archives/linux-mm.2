Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E0BCCD18C
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 01:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0E08E00BC; Thu,  9 Oct 2025 21:20:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12CA88E0002; Thu,  9 Oct 2025 21:20:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7908E00BC; Thu,  9 Oct 2025 21:20:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D818D8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 21:20:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A0D911166F3
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:12 +0000 (UTC)
X-FDA: 83980448664.27.89729D6
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id D1EB0C0008
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 01:20:10 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YpUoA5rf;
	spf=pass (imf28.hostedemail.com: domain of 3SV_oaAYKCPYqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3SV_oaAYKCPYqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760059210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TF3568yP8arSICTc3vnXw7wkTlYOmrE0XKsy2eUArt4=;
	b=TkJvjt0iB1ax+wyXlwoZUpec9bwbU3g5845MUzHDgmtgslkyjb9B+v5Nxo0JcdAv8xnKsK
	nU7dOndENbf3ozWzHvtLarHGih6+HhRaOBB6CAxggWpWffM5Upih9t0FtCBGhudjbw+KRI
	khQERu4njzLxPYKGV4t2GMukVju6rUQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=YpUoA5rf;
	spf=pass (imf28.hostedemail.com: domain of 3SV_oaAYKCPYqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3SV_oaAYKCPYqspclZemmejc.amkjglsv-kkitYai.mpe@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760059210; a=rsa-sha256;
	cv=none;
	b=LCQf2T5z5099sEnssq/xzA0uCMsPRhK6kXqaVQulvsnFRdjpdZaphiJg5bjRTzma9EYgGe
	avrMQYBXWkaJ50qmLYoin/LxQLsEeHXQ+vUcSyURL01Jh/U0IWiBhYVCnZK1vD1tFfkNOp
	KxLHsL8t+gIFmABYstyWHZ3fG1G+j9A=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b59682541d5so4727464a12.0
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 18:20:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760059210; x=1760664010; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TF3568yP8arSICTc3vnXw7wkTlYOmrE0XKsy2eUArt4=;
        b=YpUoA5rfp/HK7frrsJb7kGVEhmkZcST/9qzg67hrOsD8qYr9/aQuDMJgGNScU7ACkJ
         uP4PPuOpD4GGtckJSZXBOtjqgL4thLXC1V/+0UiDgsoHMuihsIxlkcdFtCAC0fPA2MkI
         81pcioUSaPyJ7s1fPuNoYxBYK63xqpTFINAbdbxcX+wtgh1wPPEVM8fffRZ24qe/hZ9e
         WuvyKq7Fm0ihlwuVkotzIssWd1oNRPfri3eNlVVJ1SZ8Ed99/J2S9U94P+B7OzsJX0qO
         crUQsNCEhdDZljzZ8cbllYIhgN3PnriTwaAOZcvUxD/1O2rKdb2V9cA4Dm4y4VM49HCO
         rGoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760059210; x=1760664010;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TF3568yP8arSICTc3vnXw7wkTlYOmrE0XKsy2eUArt4=;
        b=G2u/rMBJhUpX3LNIR5qeFEONIW9GCUrTQLjLINOniqB7DNHiuVIipgLEOJ4wKEHPfH
         OdGkSsaihgh5dwqQzRcKgIpgVvtB70VbEZQUf5aM1otWYDjJvir+ZWLS3I29ZMRw75H7
         +c+WpoNOGz42B2FejnA7B0cELjiElbrlpTP89KHuJ9TXx10xNWd+GXEimk9yZspCeS4Y
         wSXJbmeYoB4J3h42P2DurrtRxotZEC0qbLbxOk/jaba+VXNhwbH/tVG7uxXLQlFuIfOT
         GDfO9YD/x4+mIoFEmdiFurGAh6ZodPoWgOY0uCm8uL4dWNdMkBpqDcRRlvhH/N0KAjpQ
         7V0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUDMDjrAiIq4B0RHKeV2tkrKF756TlfuqDN66C3DxkkG1ZagKRoHsxwoYTBh+HlNutjmQKWvgH3Ww==@kvack.org
X-Gm-Message-State: AOJu0YxaCqb9BUH25F/yK7P+gbVnn1JReOEsRePWiJr/Uj4t36fVW8YO
	+y+/VcibpagIUiSb+MQeh6yTKg6SsKAH2L9J6oDGiZZ7iSTkIZunfxDuMhCi/n093L/NtYs0G24
	MWzC07A==
X-Google-Smtp-Source: AGHT+IHpnUj2OMWlXlYxp3ZZZRkgvkpKUji8FWq+Is/jpL7rJv/HUvTEG2aUVmhGkdq+yIG7uf4JBu02rqQ=
X-Received: from pgbcq6.prod.google.com ([2002:a05:6a02:4086:b0:b49:de56:6e3c])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:431f:b0:32d:80ab:7132
 with SMTP id adf61e73a8af0-32da83de283mr12170415637.37.1760059209572; Thu, 09
 Oct 2025 18:20:09 -0700 (PDT)
Date: Thu,  9 Oct 2025 18:19:49 -0700
In-Reply-To: <20251010011951.2136980-1-surenb@google.com>
Mime-Version: 1.0
References: <20251010011951.2136980-1-surenb@google.com>
X-Mailer: git-send-email 2.51.0.740.g6adb054d12-goog
Message-ID: <20251010011951.2136980-7-surenb@google.com>
Subject: [PATCH 6/8] add cleancache documentation
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
X-Stat-Signature: fatyp1q4zwpf48zsxhs8t7bnp3tsa897
X-Rspamd-Queue-Id: D1EB0C0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760059210-505994
X-HE-Meta: U2FsdGVkX19FNLoIYRvtyN0LNbP/KiCTFPs4vH98F0V67TX8CxhIcA2CuExmnTaQsQ9DhbhOb+JpKA9s+uHzFG10MZZBEKCaDY8yTMlM0wJSlql7SRANO5Uy/UZFRpieytZHLQNLecS3GYrFek2M34rGDe3JXkiXEwRzMgMTOlOxM7MWVpb4lXpQybeCl6gL9my18annIe/hEcEka3RQCPSD6CDH3ydGMX1ATD1Jd7RSE0ZOA6xqZJ+j2LhKt7r8hhHr9xjlsRyY2AIn4KQun5VtuR62MPDmZwjKdz8b9q+O4mZlYeq/4SaE5S9kOG5onEUWhsuEQXtDC6jwyS3BerheezMlP6QyGrLBd28eigKMitQAMWxX+zUBTELq8MmVNVeXjn35fQw9XCl+f8ckrJLztdkhxV+tOELOI/8nmnK+TSIxcOkDgb/p4WcnDAxv35lsHOFY+COtw920ILi20uEgq+dmVy086g/Jb9Q882WT15pCzP4+bsZbuWVSRQXdnYmy+hcAbIFJIzohC0h3YFTEGvc9083zUrhOtcYaugzVmTPf3UKf7jeKZP5e2NhHOFUEwnv9A7Xbm6i1BOxRjXxq71noHKe0lTEnHSItVuL1MtcrPfXLWNJowWvqppU/g8p77mM5sPrpEwGT/w4dgoyN1woMpBPiQ470ftV5rWYrGSiRCJk9JxU+6+XZ1vBXZ+QukcjAppQUgSsre0TLn4McDGudS7aXp9prY4cFqUb8T5rQRq0H3cxgpbk+c0Ez1Sm4bUYsNhMQ+bO+rZNcoCIqjI2heZm1iozHYPrAryKjwrt13kylGOVwy4dSbfLIxexdS47etZ19QLZysX4oulVZ5ftinfziIr1hnQ67XwqX0iteffJRqaKUVbOXiVWfGZN9ASLqns2yHycdqjh3jOwt0raeNmWh2E3V2e0u51ozL6TgrG16jiMMSD0uxH+OU4aW12fQ4CL+JYPAtWZ
 VAdOR1sh
 faHb785l4ZQ52d6sgmI5ZffwCZhRztzrQK5+Dqu0WOe9vJj8Xq32eE+RNFxz+1chtmcI6r1N/RDkl3RgPPiOhS9v77oPb4uOnaYTWv4gBZtYzSdeAo3HMcxEl9h9+eUlNH/kkh3Mo1ey5Nvz3l8YC1e4upJcc/Oha/Fx9pbUKazgWgas3X5wAUZ0Rg2LqERysitc9XB9v+xjizvIzNLn3TzXqDRe8I9J3D71Pw+lzDOmSjRcibs0PWRS04UYojrVV7EOaUD0Ub9Svs8zn97zIcZ+jl80vjUE/8qQQ0MFR9DaNSch4WCXBdarktGbtgthLCbg4fZ/HjafvLnzKvrel4hQ4L+uLxrY0HXlNJW6KLhxwBeSSHxuB6g4vwY2OCU1uX/FG3J307WLgTggysvTFfBizDa0IEC666YIqhYwmDY9AC7gkgUlxEFT5R4zGvLT12xLogkx7P1ETy6RmjxWDMCbLbec2rebyWOxckeallV5EZ8A1PUpvIbNAMgJiuJAsw5uXO0703soCzlC4O1waFALAFl3oNLSXhg4FsQkyDR4MLLomfOWvNMDFiA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document cleancache, it's APIs and sysfs interface.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 Documentation/mm/cleancache.rst | 112 ++++++++++++++++++++++++++++++++
 MAINTAINERS                     |   1 +
 2 files changed, 113 insertions(+)
 create mode 100644 Documentation/mm/cleancache.rst

diff --git a/Documentation/mm/cleancache.rst b/Documentation/mm/cleancache.rst
new file mode 100644
index 000000000000..deaf7de51829
--- /dev/null
+++ b/Documentation/mm/cleancache.rst
@@ -0,0 +1,112 @@
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
+file-backed pages that the kernel's pageframe replacement algorithm (PFRA)
+would like to keep around, but can't since there isn't enough memory. So
+when the PFRA "evicts" a folio, it stores the data contained in the folio
+into cleancache memory which is not directly accessible or addressable by
+the kernel (transcendent memory) and is of unknown and possibly
+time-varying size.
+
+Later, when a filesystem wishes to access a folio in a file on disk, it
+first checks cleancache to see if it already contains required data; if it
+does, the folio data is copied into the kernel and a disk access is
+avoided.
+
+The memory cleancache uses is donated by other system components, which
+reserve memory not directly addressable by the kernel. By donating this
+memory to cleancache, the memory owner enables its utilization while it
+is not used. Memory donation is done using cleancache backend API and any
+donated memory can be taken back at any time by its donor without no delay
+and with guarantees success. Since cleancache uses this memory only to
+store clean file-backed data, it can be dropped at any time and therefore
+the donor's request to take back the memory can be always satisfied.
+
+Implementation Overview
+=======================
+
+Cleancache "backend" (donor that provides transcendent memory), registers
+itself with cleancache "frontend" and received a unique pool_id which it
+can use in all later API calls to identify the pool of folios it donates.
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
+If CONFIG_CLEANCACHE_SYSFS is enabled, monitoring of cleancache performance
+can be done via sysfs in the `/sys/kernel/mm/cleancache` directory.
+The effectiveness of cleancache can be measured (across all filesystems)
+with provided stats.
+Global stats are published directly under `/sys/kernel/mm/cleancache` and
+include:
+
+``stored``
+	number of successful cleancache folio stores.
+
+``skipped``
+	number of folios skipped during cleancache store operation.
+
+``restored``
+	number of successful cleancache folio restore operations.
+
+``missed``
+	number of failed cleancache folio restore operations.
+
+``reclaimed``
+	number of folios reclaimed from the cleancache due to insufficient
+	memory.
+
+``recalled``
+	number of times cleancache folio content was discarded as a result
+	of the cleancache backend taking the folio back.
+
+``invalidated``
+	number of times cleancache folio content was discarded as a result
+	of invalidation.
+
+``cached``
+	number of folios currently cached in the cleancache.
+
+Per-pool stats are published under `/sys/kernel/mm/cleancache/<pool name>`
+where "pool name" is the name pool was registered under. These stats
+include:
+
+``size``
+	number of folios donated to this pool.
+
+``cached``
+	number of folios currently cached in the pool.
+
+``recalled``
+	number of times cleancache folio content was discarded as a result
+	of the cleancache backend taking the folio back from the pool.
diff --git a/MAINTAINERS b/MAINTAINERS
index 1c97227e7ffa..441e68c94177 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6053,6 +6053,7 @@ CLEANCACHE
 M:	Suren Baghdasaryan <surenb@google.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/mm/cleancache.rst
 F:	include/linux/cleancache.h
 F:	mm/cleancache.c
 F:	mm/cleancache_sysfs.c
-- 
2.51.0.740.g6adb054d12-goog


