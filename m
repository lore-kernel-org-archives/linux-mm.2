Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C129BCD343F
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 12:43:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328AE6B008C; Fri, 15 May 2026 08:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FFE06B0092; Fri, 15 May 2026 08:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2164F6B0093; Fri, 15 May 2026 08:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD8A6B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 08:43:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE66A1C0570
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:43:50 +0000 (UTC)
X-FDA: 84769621020.30.1065AD0
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf25.hostedemail.com (Postfix) with ESMTP id E371BA000B
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:43:48 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D+r4JloU;
	spf=pass (imf25.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778849029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuXpdMtSnDfGpZVmjIfUouOlQ5gFe/YG7aOKwEOn+Uk=;
	b=xxkKynC+UC4YppX3ii4cMiUCjLlkbWr4o5VCEJVggCvPmEG4KhjsS0MoaSiS/yd//wItwo
	9Tn//I0SNph50c47TMO3FxjZofMadE1kl9o0HMTJeRPFxlke5L8tlLhchHJ4c+p6Eoq6dB
	FErANf92bsJzCkZ/qH79kHb6CIFMsKs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=D+r4JloU;
	spf=pass (imf25.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778849029; a=rsa-sha256;
	cv=none;
	b=emQJD+XxowQhKZxR54CS4YYorEDiJXLTF04kd7hJmOFOB1v1JgpD8zmAo0dEg7Qxe4eACM
	nI0/6VXGQFvEGj0arvsIk+hHN4bgV5Bf7Mi/TVtLBJHoaE5PT61b1Hp4uQVXwRWQJmKxhv
	jLfCEHppTeh5N0d62NNZFm8dE8swb8s=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891b0786beso59516425e9.1
        for <linux-mm@kvack.org>; Fri, 15 May 2026 05:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778849027; x=1779453827; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GuXpdMtSnDfGpZVmjIfUouOlQ5gFe/YG7aOKwEOn+Uk=;
        b=D+r4JloU80DlbJs1KSdFYYepzjw0eG/smAiszqVxhynboZnviJvhM+WRvNlBDFbotL
         uknM0mmVBHRehhQkYa4eHO2TwWhWDOxu7dspFLPNp1rU8s7Cr0sXwqMlsANgQs4AXiuF
         0zLZnIqHvhgvOJ/uDgQmyI+O0oK6tyDxCukunXIPVhMBkqKb6KsSYBgHTvsscrfAp+ub
         W5sfCoAQO7pMfpCkg8ixLkZuERLj0GevnuviRtSeVAvQwwbHwLM8syU9uYR6oCNsL2TQ
         nz20UTJwyM40pt9MFIKsEVXmm5Br+KhLOkpbFHNntfrUL4hrsGzXPOcrSqaS+HUMb8jU
         x/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778849027; x=1779453827;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GuXpdMtSnDfGpZVmjIfUouOlQ5gFe/YG7aOKwEOn+Uk=;
        b=hwpiDjfQ+3lCfcGFpvaxecDafzkiRZrsMo7gyFDRbNcD/Zom+YqkHfQt4dR86ziA31
         WIO28tlloPgRN0Rs4BssycDSj4Sfs6EpmA2gyLeQYdKDJn/u5waZHoagzLfDyT7zcMqN
         l84vWxhWlfkvbJfTdsqOkiraHdG3V2zf6oTyM3v4KIvjdjpU7LscLO3bVXt4utPHS/2I
         YIuOQyAt0MCongSDRxyKMHaDBPzzDiSOzQVOEUi43awYaEae4JLA00SH7YYiXYp5J4BU
         6kxG5A4njDt5hvwHfBR0fvdHbO1JE6geUsQxuTKTewxr5QQeFtNTrjvhRaD3pSUR5R8D
         QbgA==
X-Gm-Message-State: AOJu0YxlngathM3MKqLeVzJjG7gxzVmMuNccRESaqpbyhEW80fGtQLSp
	F04qVKfHJTzcAnd8yfjMmjhnpVFFDBE+M/yUqQSv8afJoWv4VkC9EQWT
X-Gm-Gg: Acq92OFHJdr6xFZL9rOnIq0P3qDs6Jvh1Geo1hJZFz/fyWTYZh1JNYjLswMOFgnPrhp
	DS9/BCdPmipCq9NJKzBT4/nPWfdNv/TXIwjDqYkfCKrVJXoIBN3BYzVgbWjrdpOxXawvHPBzz+g
	jHZiOt8FYP7EENmBuUCUZHwljUqrXutABNqK4X19nbcdhQe/6tBknqtFw2mce4IWRNs1Kmn5fbL
	Gx1tCuI/5dw1bh7ufHZFgLslKuW84i3ADlA6NzpbgrY8JjVhotOHq1WNXRtxmlfFZme5hyyOXZM
	AxbKkltVLspmlJN7U7Ch11t1c7H222tZYO33aPVCs7LYkcSAxWZQ/BRjeCWW1t7NB7SjYSS3u/O
	syhjmukch12+KsdTWMEvWSd1RapZzrezQgaONULMt8ITB5X4Fq3JoC9QszT55egE0digVAJxFnZ
	bot6Ob5a5yDIXI6jI5BhwOmHfFbvs1aA==
X-Received: by 2002:a05:600c:8b18:b0:485:3b9e:caa7 with SMTP id 5b1f17b1804b1-48fe6515983mr57198095e9.23.1778849027404;
        Fri, 15 May 2026 05:43:47 -0700 (PDT)
Received: from fedora ([156.207.183.142])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48fe4c8344asm100188115e9.1.2026.05.15.05.43.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2026 05:43:47 -0700 (PDT)
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
Subject: [PATCH v4 2/9] mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
Date: Fri, 15 May 2026 15:42:12 +0300
Message-ID: <20260515124218.151966-4-elaidya225@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515124218.151966-2-elaidya225@gmail.com>
References: <20260515124218.151966-2-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E371BA000B
X-Rspamd-Server: rspam06
X-Stat-Signature: ypftrn1ogt89gw46u3bugx4yp3psp6gr
X-HE-Tag: 1778849028-853189
X-HE-Meta: U2FsdGVkX19J7ao2IobJf3JxEkIdI5aCxxcXBc3SQnase2umVSgMBckxYEJlNKRX27wMTAEXfQFQ8Hgtnk7nygC8W/KtsZCJK8rBOWZFJiooWRpu8Q61HyRlJGaBoe4Ri/aJg/G+NOQibh++Wc87hP4+/j77S5hk6o4xP3eLJLT0hYNgkiFcIrfafTUNnSh/50MT+TBFXjOfOkMr9Q50HzcYM5fsSwp7gBGNqVdFpLwy3G2uC7qkg5UOZqFFAvOBThgDPvWM0PwQ0IbfqiDPkdXBG+WAQVFgW7Xailr0m4cyZpe4e4QRlyo0+t+iNjasoq/DCP/mNEYCVBjkTTlor3jHFngvv/nUeFZhCs3ijOU9VhPm4kDTL3Bx5xd6xkFZyD2qoDTox7oUV1iOYAQQLd3O9PdcFNC5wxrIMIF812T1XJadJ+Wqy5TD+md03QjIZVyYYGZixjFjuRHstp3d075i3T8hnOw+m9ebgKEoMEXtHjYgs8AL9Ac1xwKxgimP8ccJxLuXHTbq3YmFv0l7mvN8j3Z1dQCrnPy3Jx66dEoM3ZNuNdAtgMaZVphtWOJcclMZPwYiyCVSSqkVVGdW1M9ETAmDDWvOuWoT5ayYuAP+hedzwUgbCW2c7Y5efnbFiz0TWbKBeq6l8upfjtwylz6O1bp6GEi82Goao38EFUI+XtVqWop8Wg8viPA2G0Ky/bnd1p1XsxGfvxgjsIdiNngwnQsVVL3FhEtXz6lReENOfo1RBAkstaFzIoil+7gkGyL4N1uOa2TeS8VPpCa0JcFjrfzp+aCSk9kZ7rgqaBp77R0z8CdZwiXOdDSVqdSIsvMGlvo/MTAK0P4nAqgdTEcfIgbs1fDDdP8+59+YSb9EMFKl1Jr28sZIbuifD6RzvkytK4qEj13aO2KmEL7pogWjT0Of+7nqltvL7lMKZGc9sOSYXnJok34ggh13Xu9RWhx/EmWuRK3eleOAz/u
 crBGws/b
 gWEtf3r7u7NFJwZXr6UJBVj5scutY7AxKDw/ocEKISIU+NuOc0KfN6itmi6LOof7c6Ie6RA3nqiwDOl+hfdKdzmLxS7AwDSq1dSkDg/hFm9XJ/bhIlNvtQdPCNIdu2drmEvrvW66dL1YO+rVv4+KBK8WrRz2J+vF9uTh3Un5JL5ljIgK0szW9+JH5ghw1co4g++XKnmiTPSzUWztZUillfih/JO822r5dNqzv3o6bS7KOVsq0zvQSJANEjAhKx+1I6425LCRRbiJ8u1rtA1NP1wvHQ1ZR1zFQ1YFLWt+0iQEUEc8eba1J0Hjv3BmmJ9QeTLeh+IFl6J9YwpfbsDgplFesjxuUCV6416Rutl4HQm+KO0f1BqmI7zeZfNZg1yLaOlxCHvIyHi23jVhsVp2rkBdUFKTR5ETfcceXBxm019ykcxPnXLiU7iKZEEgEjVj35i8JolATXqQOgpzF/Vric8XQVnpMDpY7hojdAlRIznr8G2ARISPDJhK4QU4k7Yma3PrpWvzJtVXV1oH4T8b/d+tFd2qtdW9x6P+gBHalKco1XpbvoKvjWQkkAPgunPJ7eSiXbLHX7DwLYfMUPNsHdKJ9G/Vz4Bwpvw7digB6vYdAlnMc2nNvojBoi/042b7816nByTg/+f4gqmKODywHE1l/27NEDQksNL1d6Eda1Cdb7ZZ9NwPAjuX6uHku4gS7f94Nd/zbS0YzjST7KPHNVRmdRzR/IxHuetOdwY/6/l1mgRRft7IS5xMI5NFrO+ornvF+SiTmdaldq92eYJa20JZ2E/Rz8GyyA0Qujy9qVn/dPU4Qz+q+MbA5OJnEEZ39QIJDTl/7hUI5o++DnO43kJ4JV6q0LXfXrCOhkhrz0AofoV4LkW5FUz1oM30KtOEfspZBpZJ7ISPpF4SgrH5+D+twvTUCwsn/LgZW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

This patch adds the ability to atomically set VMA flags with only the mmap
read/VMA read lock held.

As this could be hugely problematic for VMA flags in general given that
all other accesses are non-atomic and serialised by the mmap/VMA locks, we
implement this with a strict allow-list - that is, only designated flags
are allowed to do this.

We make VM_MAYBE_GUARD one of these flags.

Link: https://lkml.kernel.org/r/97e57abed09f2663077ed7a36fb8206e243171a9.1763460113.git.ljs@kernel.org
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
(cherry picked from commit 568822502383acd57d7cc1c72ee43932c45a9524)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>

Cc: stable@vger.kernel.org # 6.18.x
---
 include/linux/mm.h | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index f1787efaedc5..a96c99066351 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -501,6 +501,9 @@ extern unsigned int kobjsize(const void *objp);
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+/* These flags can be updated atomically via VMA/mmap read lock. */
+#define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
+
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
 # define VM_ARCH_CLEAR	VM_NONE
@@ -843,6 +846,47 @@ static inline void vm_flags_mod(struct vm_area_struct *vma,
 	__vm_flags_mod(vma, set, clear);
 }
 
+static inline bool __vma_flag_atomic_valid(struct vm_area_struct *vma,
+				       int bit)
+{
+	const vm_flags_t mask = BIT(bit);
+
+	/* Only specific flags are permitted */
+	if (WARN_ON_ONCE(!(mask & VM_ATOMIC_SET_ALLOWED)))
+		return false;
+
+	return true;
+}
+
+/*
+ * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
+ * valid flags are allowed to do this.
+ */
+static inline void vma_flag_set_atomic(struct vm_area_struct *vma, int bit)
+{
+	/* mmap read lock/VMA read lock must be held. */
+	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
+		vma_assert_locked(vma);
+
+	if (__vma_flag_atomic_valid(vma, bit))
+		set_bit(bit, &ACCESS_PRIVATE(vma, __vm_flags));
+}
+
+/*
+ * Test for VMA flag atomically. Requires no locks. Only specific valid flags
+ * are allowed to do this.
+ *
+ * This is necessarily racey, so callers must ensure that serialisation is
+ * achieved through some other means, or that races are permissible.
+ */
+static inline bool vma_flag_test_atomic(struct vm_area_struct *vma, int bit)
+{
+	if (__vma_flag_atomic_valid(vma, bit))
+		return test_bit(bit, &vma->vm_flags);
+
+	return false;
+}
+
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
 {
 	vma->vm_ops = NULL;
-- 
2.54.0


