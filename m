Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74063FF8851
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:13:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBE696B008A; Fri, 24 Apr 2026 17:13:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6EDC6B008C; Fri, 24 Apr 2026 17:13:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C85306B0092; Fri, 24 Apr 2026 17:13:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1DD76B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:13:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4C6D1A0121
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:33 +0000 (UTC)
X-FDA: 84694700706.05.18723AB
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6EE3F1A0007
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=buhE2jVj;
	spf=pass (imf19.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ZjzCUUsesNLmJFuXuHKf9RuHQuQN+tzG8EJowoiGQk=;
	b=wo168dNAV0UV7WyWR1hXL3OFuM4+f5tZsr+D261DkHe/p0DwCSa2+QAtE5GpHbs7MWAzRd
	0jlKP4eg3j9wdKU8zC8hGyhs4Fx3w/y2Fj9+knNq8GYr9J2vwRbKrWrF6NEBrbWTFtdVvs
	apaHtzf2TjK+96g4JYD7D8wVUE2EpJk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=buhE2jVj;
	spf=pass (imf19.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777065211; a=rsa-sha256;
	cv=none;
	b=gEwiablpoXKgHxQUsRRP1kuHdbSShWXU42bTdmxjVVA9OpIldQtzI4J3MaXqxkjF0jggQ4
	X34hIx7pGMBBYO+sINIrQiAi97BLWjyOa+ycdwQ9puWfRCoG3S795RM4eAfbWoMe7eP1Nx
	p6RZubBVYEYzekyT7a4MY2hOF9ZorAk=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-43d70c30767so5367503f8f.0
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777065210; x=1777670010; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ZjzCUUsesNLmJFuXuHKf9RuHQuQN+tzG8EJowoiGQk=;
        b=buhE2jVjwYwOX6Ql9pJ4NtqqT7HvLrL/lguZRj53KG/CqKNZOgq49lDaGuuTEW818u
         /Hn2yyetof9XOPwgFEPDneUNm9wEhljsT8H+yxq6Oum8IPiDwNmS6Ig/sEgvuSE1HJjv
         uNgaftr3Iq8eTSuVPkzP3p4DpFjwkR4HE6h8irqewn/rF/A1quA81um0TXR8jSua7JDS
         TwHBQOVK/nJFEZvsYQEW20O1FQUHoo2v+w0S+F7vMKgodYshq5UJYrw0BSuqlk2Ui3Sa
         uPqMk6qswLrJo6pc23WIM214cBR5N4buLNHS3f7td8E+kwFsEfiBT31QdNtzcqI12MZE
         GyZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777065210; x=1777670010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4ZjzCUUsesNLmJFuXuHKf9RuHQuQN+tzG8EJowoiGQk=;
        b=Cc0TE9smIpPxvKiPyxk/S65FnzptbmJn2N9EtnQw5WErqJ+FnKoY4J6kMyfG+9oB7A
         hQxXLJweRPhWES9W6NZK8jb57KSOlHREv++WHDAUR5Oi2CeLfwXw5sYmKWCJDrxV0JA7
         8Gvvmqm7e6elfqzg78JePOCZ6zZEY8tdp/zaKIM/qKZcmW1ToP5gntd90IEWXcenrlWj
         po0xYKUKPH69AoTodLmxVM6c96I7N1BcB5B7160JztNbVGlJOvio5K9ZsINHX0d6knzU
         wX7pFC6PumOqvoUr57AvH/qdQ6JC9vDR7/1GoZgPzNcFQKsbmUdk5Jt2GxPJ9Jh1wvvy
         odrw==
X-Gm-Message-State: AOJu0YyNlIreNkEzqZLFe1WQJpx8/ymFm4GST+SLuv96uDyN7rYipS1+
	In52WhYqlnBfxkTB0uhwTD61NQPekn+x75yDKOZUsLirUZv8BPWq1hMk
X-Gm-Gg: AeBDies7k1JE/+rzseLBd4AKSHJzUa5JJdk10I8A5BEEDcJjdSW6T2kLETpCNA/s12P
	oBI0j0Rdq8MavhtDP+yD5mkFjsfU57myXnWkbWa/JhylctmAqjtj/vhpbc92p/pZHWrXnSBVpum
	EOmXvUTw6SNr3pTzafe38ELlLMgPmxxlPFs6VU/mhjTG+HaHFsh83Njpu8utaew3z9N+E194Mao
	PoCFh2E9Al2PIH5PN65+BRq3HvFof4p9DVPXWq1HcIgktav/O5KZzVobb+kGR/sGZ4cQRFIMt74
	W8pSsc074fekMtfg0iEtuhhB6n1JsoaKr2SFvjswMLVHWwcxqmyMN3zLXKnnBih+RtOw7b9bz4B
	37QjK5k2ghZAcwd3vRSMXO4wzc4pYbUA0e29M4CJ1kyzynFxG4El2w7z5l3vXpPRnvfBeDimwZQ
	q7Zpk5eKABFmTQgJOjAQVkeu1cbyAUJw==
X-Received: by 2002:a05:6000:2d8a:b0:439:adc3:f0e7 with SMTP id ffacd0b85a97d-43fe4043f54mr33365742f8f.9.1777065209838;
        Fri, 24 Apr 2026 14:13:29 -0700 (PDT)
Received: from fedora ([156.207.128.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm63845677f8f.3.2026.04.24.14.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 14:13:29 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	avagin@gmail.com,
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
Subject: [PATCH v1 1/9] mm: introduce VM_MAYBE_GUARD and make visible in /proc/$pid/smaps
Date: Sat, 25 Apr 2026 00:12:35 +0300
Message-ID: <20260424211315.1072123-2-elaidya225@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424211315.1072123-1-elaidya225@gmail.com>
References: <20260424211315.1072123-1-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: syig1dy8ycnqmaof3cnx1gyprm4ey5jp
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6EE3F1A0007
X-Rspam-User: 
X-HE-Tag: 1777065211-498835
X-HE-Meta: U2FsdGVkX1+XaNhj7jy5w+cpw07egvVl/FS3172zhBRxFext33OrmmPIL2bqFuK7sb1qSviVqkiIpGfT6naubgijvafPt2cCvkNRlUWl/gJtbtb/5ca5QuTA63+JqW21+8etgzYzGemW6a5sgXo380bem47jQJ1cBwm13heHSn7ZIyc4XAZFwRDheLfOcfvmdQ1cjfX2FsHnGsxUYO5APR9aqR09OEFnIaU2c0R8JIQ5KMimRClSVopWNgeyhAvCdlzMvuxKgPOy/GoZR8IB6XZ7eX9PLcVv1Vaw8BJCMMlLZHUE/pN/THYeEpB9gESckaqw/PBVF2yrhieTgQGbi/U/TpabaIe1CQZ8VmImPVzyeKwewOzsCnL9UrbRoYcLb/uNxNfxRGXnWNlioDtk1BjN4snlGGBPPJ2Ekjgn5+Q+J4Cqw8X8e1nNTiFds6grIVQVYAcWo9mNtPzGxKLgU5zhKQbrap02Kg4JTyKLy7AmlbIHFrTLEEYmV/3PiT1J7InZ8zkfm1J6xzwjZMrbRjYtOAZrx0exBjd4u4s/RcWNFm/qtxd2UMVcV3JZjmaDh14+FmgK0x6v175ClPbddeatewSXjNfwXTVTXEzYMO6+vpJ3fagi/N+7N2EnqC+9HV4aj/m/T0yKiM8Cug7FX2jCfKOHkwknnxkonXMLWlryljPkQLqtMhOVeN1Iuo47BClWOg6gGYHtqYlqdwUuEBwdOmyaBMKkl/YgW3DwdDGHiCmhB9vXxIscEWxKOeiaYttVjTXg1h3fL5VXUMJ+szDVltuy+gUx1wq8tpXHT+hv7YyOGheIHOX+6BxTOhN3Qma8Yr03Oj7tlJaKawmJRaJghw3G22WuRhq77PzyIOQQYuHumvZUKOYPqWREe/BLrlhr7hkYcg+d+fJiyfMDcBFaM4UxHsZ6PiS3Od6zw4sTHFIE/k/SRYQYvXEJHhBIBpSHNAxpKz3C20fcgR7
 h4EFNv1W
 OyHEMKbuKVtRvqV01V+J9yLbv4I9OG24YwKNjGkjfol5t0FAENb4VL+jDTU13+iQaIZkp5GTVY3umw1ce/468hbs3A1hfHbDP0hP+L+Mq3Hq/Bg/GPLy0vzIPmUiNDtAvek+ftXLEQvvXGSB9VmsCkf6TG7kmiYEnq4jHoS5pU2pHpnjkoddRKHZDWncXdfqDbkxyj90IQlOFZ4HcheW2Wwkp/mV9z/6QNghyz8n8HoSA9BB19KoARUwniYpwZJkCPnMPLjvD68/8esamyHhGCgzWl/MyXWlydVOjzfoyyd3rOP5+j8Eqn9oSp8y9fCGsJ2udyp+r0OaCHtX0B6XtCitg3sjG202hlAF0XHsTk9iUfY4H2uAklAWJ+pl5ctArYZGzhv0qRiHswpaA17U9PlOZBqohkurIK466/Fw71/2T5rLmqV9kL5dP5wfETQcTyEizoSNPxVl/36rFrKJcZhTg20hY1YJ/YyxUDic1yZpa1Q2qqn5UDk3H7PF6c0CYttFia2DjzkL6QO733a/uUaKU2EKxcZE+HAo4z8UkkkWcFhgVcbFe6SnIfUfbEnBhK7t2hwGq6JF2gTLMQXuXeMapL6MejKdpYZ5Bvxg9cEQwUv79Ov1doVuWvf7hGHRVo+9T+C+ZRUqiwRwR8ln8Z7Yal7eCnDm42bp/1zMG/7r6ScDamIBAL+Y4MOfe5n2CmNuJXZ78folF448DvIgN3EQxksYqK76MQ5plfYvfi/3uDPt011FKZcu8t6W5xfA6Wek5nWH12ouT3x/i2Qfa61Tq5PfJD9k1WDoDXJtFuFZQZQmcsNLzNCC5rcD6phjpU+Zi/bKUtsqtmRQapTCzHo/j0wQjwxJMtNiR/+jluZDbCvOWdretBOV5IukqZf4WSqnZV1K9xBi8mQGx9CTxqKcuTdZC/XHJNdqJhyvhbcjcviy6Es8g8ABF6Nj6u278wvC1qwkDMTdzzyA=
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

Link: https://lkml.kernel.org/r/cover.1763460113.git.lorenzo.stoakes@oracle.com
Link: https://lkml.kernel.org/r/cf8ef821eba29b6c5b5e138fffe95d6dcabdedb9.1763460113.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
2.53.0


