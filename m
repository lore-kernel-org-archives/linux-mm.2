Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBBECD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4A36B0088; Fri, 15 May 2026 08:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C156B008A; Fri, 15 May 2026 08:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28B026B008C; Fri, 15 May 2026 08:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17A4E6B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:43:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8B4301408D8
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:43:38 +0000 (UTC)
X-FDA: 84769620516.30.A1B8AE3
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf30.hostedemail.com (Postfix) with ESMTP id A9C4F80013
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:43:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wf1OkwMz;
	spf=pass (imf30.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778849016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wc8wYuM7zzBFrg1B/pg+9AN3/mqSh+xcxhJ1d3VFiS0=;
	b=npaoBbK8J3VRC99BKjOT5jwz+b7JxPO2P6Nh0MHKaZlVGZ1Gf8Cn18LcIuipcfmAMNoM9K
	6gUmXW4Q/dqe655JJ/m5HyEWC1fiXNw3TsttIRJOKSG9jXy6CB/b1ee0/uwdw8ARsiEwtl
	oWRRlVDgmmWM1/8kNAXlQ4ez6qnE+Tg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778849016; a=rsa-sha256;
	cv=none;
	b=7bYCDSRaNwNlh9P1v8iHC4WDSA1k16bvjcMiME8ENkHaHrzpuTrWWtpEpHfVnnPwCI0Nmn
	Ncr7TbfdUGCj5QtjiO9kkCajDqF6wRMLGNTwc9pGeSqovz2PprLQkGw6MUaLxl0qiP0IU5
	9qxp+2wKGfM9jAyNEl7sEWU5UdQ1GUw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Wf1OkwMz;
	spf=pass (imf30.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48909558b3aso87838565e9.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778849015; x=1779453815; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wc8wYuM7zzBFrg1B/pg+9AN3/mqSh+xcxhJ1d3VFiS0=;
        b=Wf1OkwMzQnH7zCjyNUS28AUD6yg1x4Ybkugj8BVra3OFQ0Heer9jJ/v1QdwrzunQKb
         ES41epFs0aIeWc73OJTlQ17gWOaO30A5jpRpPFHXlVVUbYvUS06RnkmC8Yzs6+XOY0T5
         vE77cirK0MJSKlg4b1eKRYiVfCA/Zmfx57Slek4lbkebKfE0VJwmYXv1ikbxXONdAT3Y
         kHETZijWzIJpJ9RmFrPMFTOSxD7B7zaSuKtb3q/7+Qewt3d3x2BKki18MS8hgegh6tiz
         tdsIaUf+SQq4TcDqD81Meqr1Ri5VvPVHg+H7qh9Zmp6M76Iak/W594/gK9B2ws7klAya
         XwDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778849015; x=1779453815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wc8wYuM7zzBFrg1B/pg+9AN3/mqSh+xcxhJ1d3VFiS0=;
        b=IGa5gw0xXi8fe09RRUaxYvmis0RTvYg/+fCawnA+9Y5qOx/ltXGPARQX2W7OTL57FC
         3rrF8Gbp6A0jWeobzoCEPrLj3W1hXf4ciinINGcRrYeTT94qv1B0KiuoNQEMwNfbK/6V
         L83yJ+0NoDOonGiNPmj7JtRUOw7vs4V5Gib5/a0iw85lep3t3EL+0zXN0MAn7YpyIyJl
         Znou7EwY1C4bNvvx6blANSmP62y2y2r4wHLZxG55/fJs0t0cQSIF0TdnXiAggitCA1+c
         jpWw6uw4mVkvco09R6DgPlN7yo5Z7gzi9DTqhDWnpXsQn4CAQwNnqx8Ejp01hezvBHWW
         +1Ng==
X-Gm-Message-State: AOJu0Yx13b0xWKRll7e+b3jvTcwUpgSjO+IXVJ909fvSzzrXYNOueae1
	YoUgu90o7XDrw8nrAoJhOwScS8ETygcfd4SOoSIs/VTz0vDSZAmbp7Mo
X-Gm-Gg: Acq92OGeohDKPD5ekdZsMu5zsckEl5p7lqpSofx2oK4xfvhT8USM1YEo1k7AM3MLTgY
	qquEw4XvyfEsAVo3ZwueQ4yiotr+pbiZNDIlZNZYyiVjibLh+DT1KNAU9z/9edwgtbyL/b/NZ3L
	+qh7urZ/4VwzUi45afXBlxR/0mNuHgfqI/1hm2HcA4XbdY7mhOsb+NlHEDSp94OfUkXfR+5BYuR
	SrXlo6K51wywN2rnLUeyErKORjPzx2bUzxgSdQI9+ZCzYml9EjLc3h1N9cfXeXPlpnbwRjhaZBo
	zXSh70SMnYwXucyG1+2XgfgzyZWmDjZSBaQHbQ1YoBtOdd6HwzCCUr6vBbgAtRhoEUzNplYAjeL
	7ayQDbHvkhMmBg5KrnVKwIXtT+ZJaH7Ce6yiuqxSLu3M4puOdXBrEq/1UoYdXY/RH/IqoZwUU2V
	CwRIc0YE5TXX6A5R6FKzqUdEepuLw8UA==
X-Received: by 2002:a05:600c:858d:b0:488:f453:b976 with SMTP id 5b1f17b1804b1-48fe651c8b1mr35586695e9.27.1778849014961;
        Fri, 15 May 2026 05:43:34 -0700 (PDT)
Received: from fedora ([156.207.183.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8344asm100188115e9.1.2026.05.15.05.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 05:43:34 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	avagin@gmail.com,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH v4 1/9] mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
Date: Fri, 15 May 2026 15:42:11 +0300
Message-ID: <20260515124218.151966-3-elaidya225@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515124218.151966-2-elaidya225@gmail.com>
References: <20260515124218.151966-2-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A9C4F80013
X-Stat-Signature: bto8sguutookmwhtntohjnm83w6opnte
X-Rspam-User: 
X-HE-Tag: 1778849016-630985
X-HE-Meta: U2FsdGVkX1+aQsKfAgIp6CEcZ0j74ekJec+kezOUuKU8fX+3QOWaZhXGclF31EPhrLh1ULvM+C5XaT1hA0VYQYqxbKKRcsKHrdX6T2QqjHzsst4vAayf6P7MuHE6yVRKyIsPBZJCHyzAnKD6ohA+0GxCp9jcfcezESx85AvcSWVg/jOi3v3p3jRmkSatmijqih1d1XlNIbFcsBRuBpZk3fKo9NX3VNPvGEkdc37yDtt2BuLM2aAa3mmATUF0g5Voch9oOynSE354tCH0edf9PmM21mPD8y9TFls7W5bhtCA/7wcFJQ758bcYEALAxHx0DxtQO74I1i41BSATnkId4NhY7FhTX/BJTu8OqOgkaJbeKz2U4Fv2l2p9bX0oJURv9bsII3m7HUbpmMIktmICWUHC51ktzGLFfjKvhyoEwM/zmHOF3tw6nEAogBuvpYjORhh+nse2JoRmfd+MaefLkCQr61l8dCJBnlGdhhllvDlDRttdKljz8mCnW6vNXstTMIoJ6OEd1aJtJ4u550qoY+Z3T8kx/bhoOEII7rRuoU0Z47rgzkU1qgFFhBnJ3Sbbi2wL71zKm5nNEY/wKPzQS9uQ+5YAXOjLonH1clTCIlqZuAooSbrMbWJe4SluzEVfExf89HOyEU9psXSw6gW3lEbArxOwsF4ymXt5sndmDAK9RSBzcnKKUnOeHk4NOAYY268MlOB2Aar4O6/UPfzNDUZdEilyX0IyEnJMz/sPrbguvUt1GSW6+ft/amNbUuFQUL+WxgWkFXOzt1v02rQhFW6TgPKOvDsvanIPvJwlwXDMaKLrYWe2n3YQRH+BoWq054G8OAL1O2hBY6ahEU8FUQUc4jx65JhaBbDgWP5K4NzF7iGHMRvUv8za+iT7O7YoeMdpM6aOkfE7EJpl2S52MLkT7MAZv5QarlPCbp3wiai0QmA1xHV+tcEojWvCuXxH4KtdMjQ2ErXtDSTq3ks
 8fFkywjc
 KyREihiVuZrbETMltOXiP9FmIz4LkHvyrbgC1qNXNdq6oGCRlKedaiS2MsHDXvrI8aarFGDJILCzWdEwuG+QsUaw8rO/2GlUGFHIUgj9CXVn9+E9t9RX6iJKMBAuJyDL5TBf1A+G6sNoC67hhc8hz3BmeoxE50qKBgAerGJk2sj9sEWXZNkSmqc5E7NGTmcLSm4KjZC5nwFBVeEaBNCUyky5BDwRZrkPQoRWaR4MzREqJvR2spcfwWpFxpAHfXMRtlskVbIpWp0NQ+nc10mOxPU4ucOyq8f4L2QXwEYytPKW3aQMQqGgKwBR1gG6Z6FIT9K/Mp/Ugrep89ZH++DHGJ4ch6RPwT7GdSO06Eo97pLWY3I+kVoHfC42QE6cMZK3dbURQZ7gd/erZZuKbU1EzhshFurAjptYLP0LduZEgwD9m6xqOuO3M/xGzZxgqN9k06bLKO90r/2ozgTU0NxwqFZv4ecmD3AC1Jg6kAXCFaLq6pLCmhRQBZFBFNv2tRHTyNQj2VSxVqjdMt6/G6+goYtMT+3+ThmwmmcARNUmnpq4POvB8+ay+LIxXpjmCXJNJrfJOh4HlZqrEkrYOB45zNFiqS7j0GJyDVlE/C42GO162esb7oCUIRYWWLUjMXZooAcFZ3do4c5QxyOmDrglE2Y516JMjX0SCI1OD8I6wLZpB3tLyBWxA5XW5O5vtlTyYldxmzOoo9cxIZXRpRu/lil/zsgk7ldFSRRPlGk5AMf+tCsA+S1oHJfzDhyq18NQ9gjDu2lkG7c7VwwXW2FI2/0+d+mQ6oKq7mhOqr/vq3e4f4n7MjXWwcOkaAbEXiZHTOm0ARTS5FrVQYX+NegfFbKprXKu008YAoOpylGF3h7PFUDb0PWd1mVrtHOsITsuMMVkPfbyEriIQEgNZKl6A4W3XKfWfchCpZzj+NQYnJNYwo1I3BgDS12/CxbXIHx8FaPKyyT4CmA430VM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Patch series "introduce VM_MAYBE_GUARD and make it sticky", v4.

Currently, guard regions are not visible to users except through
/proc/$pid/pagemap, with no explicit visibility at the VMA level.

This makes the feature less useful, as it isn't entirely apparent which
VMAs may have these entries present, especially when performing actions
which walk through memory regions such as those performed by CRIU.

This series addresses this issue by introducing the VM_MAYBE_GUARD flag
which fulfils this role, updating the smaps logic to display an entry for
these.

The semantics of this flag are that a guard region MAY be present if set
(we cannot be sure, as we can't efficiently track whether an
MADV_GUARD_REMOVE finally removes all the guard regions in a VMA) - but if
not set the VMA definitely does NOT have any guard regions present.

It's problematic to establish this flag without further action, because
that means that VMAs with guard regions in them become non-mergeable with
adjacent VMAs for no especially good reason.

To work around this, this series also introduces the concept of 'sticky'
VMA flags - that is flags which:

a. if set in one VMA and not in another still permit those VMAs to be
   merged (if otherwise compatible).

b. When they are merged, the resultant VMA must have the flag set.

The VMA logic is updated to propagate these flags correctly.

Additionally, VM_MAYBE_GUARD being an explicit VMA flag allows us to solve
an issue with file-backed guard regions - previously these established an
anon_vma object for file-backed mappings solely to have vma_needs_copy()
correctly propagate guard region mappings to child processes.

We introduce a new flag alias VM_COPY_ON_FORK (which currently only
specifies VM_MAYBE_GUARD) and update vma_needs_copy() to check explicitly
for this flag and to copy page tables if it is present, which resolves
this issue.

Additionally, we add the ability for allow-listed VMA flags to be
atomically writable with only mmap/VMA read locks held.

The only flag we allow so far is VM_MAYBE_GUARD, which we carefully ensure
does not cause any races by being allowed to do so.

This allows us to maintain guard region installation as a read-locked
operation and not endure the overhead of obtaining a write lock here.

Finally we introduce extensive VMA userland tests to assert that the
sticky VMA logic behaves correctly as well as guard region self tests to
assert that smaps visibility is correctly implemented.

This patch (of 9):

Currently, if a user needs to determine if guard regions are present in a
range, they have to scan all VMAs (or have knowledge of which ones might
have guard regions).

Since commit 8e2f2aeb8b48 ("fs/proc/task_mmu: add guard region bit to
pagemap") and the related commit a516403787e0 ("fs/proc: extend the
PAGEMAP_SCAN ioctl to report guard regions"), users can use either
/proc/$pid/pagemap or the PAGEMAP_SCAN functionality to perform this
operation at a virtual address level.

This is not ideal, and it gives no visibility at a /proc/$pid/smaps level
that guard regions exist in ranges.

This patch remedies the situation by establishing a new VMA flag,
VM_MAYBE_GUARD, to indicate that a VMA may contain guard regions (it is
uncertain because we cannot reasonably determine whether a
MADV_GUARD_REMOVE call has removed all of the guard regions in a VMA, and
additionally VMAs may change across merge/split).

We utilise 0x800 for this flag which makes it available to 32-bit
architectures also, a flag that was previously used by VM_DENYWRITE, which
was removed in commit 8d0920bde5eb ("mm: remove VM_DENYWRITE") and hasn't
bee reused yet.

We also update the smaps logic and documentation to identify these VMAs.

Another major use of this functionality is that we can use it to identify
that we ought to copy page tables on fork.

We do not actually implement usage of this flag in mm/madvise.c yet as we
need to allow some VMA flags to be applied atomically under mmap/VMA read
lock in order to avoid the need to acquire a write lock for this purpose.

Link: https://lkml.kernel.org/r/cover.1763460113.git.ljs@kernel.org
Link: https://lkml.kernel.org/r/cf8ef821eba29b6c5b5e138fffe95d6dcabdedb9.1763460113.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 5dba5cc2e0ffa76f2f6c8922a04469dc9602c396)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>

Cc: stable@vger.kernel.org # 6.18.x
---
 Documentation/filesystems/proc.rst | 5 +++--
 fs/proc/task_mmu.c                 | 1 +
 include/linux/mm.h                 | 3 +++
 include/trace/events/mmflags.h     | 1 +
 mm/memory.c                        | 4 ++++
 tools/testing/vma/vma_internal.h   | 1 +
 6 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 0b86a8022fa1..8256e857e2d7 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -553,7 +553,7 @@ otherwise.
 kernel flags associated with the particular virtual memory area in two letter
 encoded manner. The codes are the following:
 
-    ==    =======================================
+    ==    =============================================================
     rd    readable
     wr    writeable
     ex    executable
@@ -591,7 +591,8 @@ encoded manner. The codes are the following:
     sl    sealed
     lf    lock on fault pages
     dp    always lazily freeable mapping
-    ==    =======================================
+    gu    maybe contains guard regions (if not set, definitely doesn't)
+    ==    =============================================================
 
 Note that there is no guarantee that every flag and associated mnemonic will
 be present in all further kernel releases. Things get changed, the flags may
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index b490245ff9be..4c5adfd4fc1f 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1159,6 +1159,7 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 		[ilog2(VM_MAYSHARE)]	= "ms",
 		[ilog2(VM_GROWSDOWN)]	= "gd",
 		[ilog2(VM_PFNMAP)]	= "pf",
+		[ilog2(VM_MAYBE_GUARD)]	= "gu",
 		[ilog2(VM_LOCKED)]	= "lo",
 		[ilog2(VM_IO)]		= "io",
 		[ilog2(VM_SEQ_READ)]	= "sr",
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1e74eb7267ac..f1787efaedc5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -269,6 +269,8 @@ extern struct rw_semaphore nommu_region_sem;
 extern unsigned int kobjsize(const void *objp);
 #endif
 
+#define VM_MAYBE_GUARD_BIT 11
+
 /*
  * vm_flags in vm_area_struct, see mm_types.h.
  * When changing, update also include/trace/events/mmflags.h
@@ -294,6 +296,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_UFFD_MISSING	0
 #endif /* CONFIG_MMU */
 #define VM_PFNMAP	0x00000400	/* Page-ranges managed without "struct page", just pure PFN */
+#define VM_MAYBE_GUARD	BIT(VM_MAYBE_GUARD_BIT)	/* The VMA maybe contains guard regions. */
 #define VM_UFFD_WP	0x00001000	/* wrprotect pages tracking */
 
 #define VM_LOCKED	0x00002000
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index aa441f593e9a..a6e5a44c9b42 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -213,6 +213,7 @@ IF_HAVE_PG_ARCH_3(arch_3)
 	{VM_UFFD_MISSING,		"uffd_missing"	},		\
 IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
 	{VM_PFNMAP,			"pfnmap"	},		\
+	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
 	{VM_UFFD_WP,			"uffd_wp"	},		\
 	{VM_LOCKED,			"locked"	},		\
 	{VM_IO,				"io"		},		\
diff --git a/mm/memory.c b/mm/memory.c
index 94bf107a47ca..dde20cd5fa5b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1478,6 +1478,10 @@ vma_needs_copy(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma)
 	if (src_vma->anon_vma)
 		return true;
 
+	/* Guard regions have modified page tables that require copying. */
+	if (src_vma->vm_flags & VM_MAYBE_GUARD)
+		return true;
+
 	/*
 	 * Don't copy ptes where a page fault will fill them correctly.  Fork
 	 * becomes much lighter when there are big shared or private readonly
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index dc976a285ad2..c87bcc9013f5 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -56,6 +56,7 @@ extern unsigned long dac_mmap_min_addr;
 #define VM_MAYEXEC	0x00000040
 #define VM_GROWSDOWN	0x00000100
 #define VM_PFNMAP	0x00000400
+#define VM_MAYBE_GUARD	0x00000800
 #define VM_LOCKED	0x00002000
 #define VM_IO           0x00004000
 #define VM_SEQ_READ	0x00008000	/* App will access data sequentially */
-- 
2.54.0


