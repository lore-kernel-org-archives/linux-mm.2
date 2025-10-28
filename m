Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55E09CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 21:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7BF78E0010; Tue, 28 Oct 2025 17:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B53858E0005; Tue, 28 Oct 2025 17:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A90968E0010; Tue, 28 Oct 2025 17:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 975C48E0005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:25:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4585613B4D1
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:25:50 +0000 (UTC)
X-FDA: 84048805260.25.6D064FB
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	by imf22.hostedemail.com (Postfix) with ESMTP id 73E9FC0006
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:25:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KuCIQ4PL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 32zQBaQsKCJgC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com designates 209.85.128.201 as permitted sender) smtp.mailfrom=32zQBaQsKCJgC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761686748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S+zRclGCeCxZWGKiQ7HQS17pkEGlf1WyYG/KnmVF2Ow=;
	b=yqBZGKwjaCPz1SCHjQ7w/Y/2F04kSNNG4CWeQ+abL8/ums2qMlkN9jppLGApRv3HFDZVqH
	x0iVJxWX/Csv9DS24V5HT5gvO9HrGz9m1WXv9g/YlGqTpPRO47s35N64Nc+exnXCMDtRSx
	QwCH4VIXObmdp1H9pFeRJoz9YzXt8ws=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KuCIQ4PL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 32zQBaQsKCJgC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com designates 209.85.128.201 as permitted sender) smtp.mailfrom=32zQBaQsKCJgC2D6K9KAF898GG8D6.4GEDAFMP-EECN24C.GJ8@flex--kaleshsingh.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761686748; a=rsa-sha256;
	cv=none;
	b=d7yeCEJFSGhIxPk/v7TsgaOeCY2PoH3ZcUQrtkr2rQdkBuAIrKH8DrohZ8JO8/GG6WnWl2
	XvDRMvp3TVtw2PzfSI+TrgvuLUAezv91Km2VrcJpgKRHJteUFmvqtC5FKDIRb8PA2a4c0j
	nMm/pR5WH7/9ew7jA5GSvAvDUNt0l68=
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-785c4b8a18bso74212047b3.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761686747; x=1762291547; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S+zRclGCeCxZWGKiQ7HQS17pkEGlf1WyYG/KnmVF2Ow=;
        b=KuCIQ4PL953SAI+0G+QuIj4QqDBzbqsNqsXryKQ3XbYvmlS6t4A+N6Tz6k7w3N2aeo
         HW123pw6lFLpsxvbLMdAQGwmn2GCpslJ9LnfpLfJ/NqQP6OARDhI37R6geuvLIAtfDHl
         dBFvZs5Ytnx5EkCBj4HnuNNQeCKmTspkBJE/MpNuu0UTYujorLNhV1buHkr3pyZaws/D
         sFo5nkJeBvU73Omh0BLzTJQ7kFPRoY9lZCPsdcSP+DGmpVpxxmyYYYTD+w7D94+Dg4HR
         mA1fc6Ox57urKYw66USWR5pBSJY+RFARFArHxM2fbPP499rDRI6oceIVjcpL/IZfFtB5
         Mzpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761686747; x=1762291547;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S+zRclGCeCxZWGKiQ7HQS17pkEGlf1WyYG/KnmVF2Ow=;
        b=Kj99hRFqZ6T3NejoySpfZZ4MRymv7Ncq1MSSr5uT0SIloDylLw6B6937McDvahBoYH
         rW0Ep+sVWhYJx5Zsh/xSV5mpBI37qsepm2R2lB+eiRc2nNAVlhUw2qTdi7sYvMtI/d5t
         Sy9PO29KpbS63EbX5iCCcaj1f+Pschs4qTEYMmtmz5bP6jv214hQ4CWiXIRnq/gL/JTF
         ecf/57yir7EU56R+stNhVrcEU75gYxyC+1KaSpgmA3EnLZ6bkzR5udXpcrriqPCEbAIV
         1+ZZw0iLxPNUKBrhONsxyCPT/Vj924pJ83gv1Xg8OFDjnKLbGlH3RY5XHOvyAJ4ckqf6
         rcWw==
X-Forwarded-Encrypted: i=1; AJvYcCW9dNV+SIMxDLCP4nJJuCZ6IIKpLG1YaRtB2E/wqbxtyHm5ymSXKfJBpkAUogyF4KMgQa5iVChZBg==@kvack.org
X-Gm-Message-State: AOJu0YwBzULG0olCHUa0c3V0tqqUT8NkJI4phLGMD3pGPVuBAk22sjjo
	6GA6uPIRVCnNgMKtkrl9TvtKo2i5wAfmMOgrxNsl/eukDwF6FPdGuxGFNqhGyi5FYJAyt2a0mRM
	V25MdyKjaKy5xqIDnR5wgUQ6Gtg==
X-Google-Smtp-Source: AGHT+IH21b8dTnDOMODyiAwwvvmg3HPg3LdlXgV0zvr0MUW3DPJaRaW0W9viFnaByL5fljhBttHAanw04I0ZoATTMA==
X-Received: from ybbgj2.prod.google.com ([2002:a05:6902:4182:b0:eba:96f:2183])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:690c:4c0b:b0:781:64f:2b33 with SMTP id 00721157ae682-786290149fcmr7812607b3.69.1761686747446;
 Tue, 28 Oct 2025 14:25:47 -0700 (PDT)
Date: Tue, 28 Oct 2025 14:24:32 -0700
In-Reply-To: <20251028212528.681081-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20251028212528.681081-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.1.851.g4ebd6896fd-goog
Message-ID: <20251028212528.681081-2-kaleshsingh@google.com>
Subject: [PATCH v4 1/5] mm: Document lenient map_count checks
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: rostedt@goodmis.org, hughd@google.com, kernel-team@android.com, 
	android-mm@google.com, Kalesh Singh <kaleshsingh@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 73E9FC0006
X-Rspamd-Server: rspam03
X-Stat-Signature: dqcug8qa8q1i6jzrh1fq4ta6eyxnxf5i
X-HE-Tag: 1761686748-99248
X-HE-Meta: U2FsdGVkX18CQt43bo1ZdHPaTvGgmA2Co7GhpzE7EDWhxFN2/RIJjZ6kjiGd/rkkdFLci5xkoyAO3HjjH7Vim58nYN86G82FxNnD8NXkd/6Pb0PyHCtMnlTmC3We0jOFmlmnzAZtTEVE/HAWKTgsvwYJnjXqY4v6hjE5QGY7HsUZIyNp0BsTIuFaD9RSOuL4RQncZwdfWz5xsQSUNFcSUFX0nULz6+eNcQm0fBGqtl0xE8HHrzFiep5HPHYx4t2ydQaR+j/Ao8tjyQkWo47jhJRxAy4xsX6pbOO9mD+aiu337rXqYnw71VPRZXar9qFCjVlSHWbixjC9Rhv5vjIdv1i8qc2Gz9ZqP8oq4P8nMC8K2KbZ6Ba6RIq7Iv2F8XjJKwknr+sJpZi9MLz37avPqBKJENjnwn6/UThf46V1FmeD5MKDGeaSw22N6c0PdtZutQTQnEfqTJ36AWNZi8EZv8ih7rO1T8yjHNMPUFeIw1P9JMPWcMufqG31T4ee08Pq+8pAcw8w5nYQjFsAWChpz4C1HJC4eixIugj/TWac16/hUZlmYHXNbAFx+fK8jii1deoQJKk7vvtB2WqIUbekSjrpd70fHieN4EpEmc+VbvdfKrc3UtXuNwAtLgajDfPTe4yF3/uwXjZjSu0dG5BbiZqwOFFixx8Nc8oezXSaKOjKJGbwizP0FGMMkmJi/g88tAirXMuqvGinr1uMZuHJHAr1PqYcaOw6Z3/FMf0j8Ypiwl0VGNOEYikdzrexBlMmtsrsdOA2J4Jy7C9PjyOEdNKh1+MLrLZ/V4eljNuRtnd+UvgKiAY13SGUNPdl8SLxCUr2vOmTmpfDWX9EJpwCiXmYk1jUEeIMDQH4YH9lCu43q006xvkyMnMyrnHmk3fGdcfuoYO81HYoD+vWn30nvcmwQYg2qb+ohTyIarcS5vMadIXF0f/3/V/Ci4ueYVfaUJuLT1Gn4yUVGh2eykB
 GJGAU6bC
 B8GqG55mmnS1GcflBTH9Q9H4SKwxoJ9+mw2izTsBMTgjYnWP7u4bXK0sWPU6zbc3dPzkRLcyV58wNQefcD2j+vZiFwN6h7xPQ9xEjAaBrG1sZ58eaCqYBZTSokqA7lr7kGqXos9Sb2VSNlAPIH5/d3SNHv9S7zwpJgnwRwpNnBu/Ro/4cLbV28SFUxRP7NAkW2MZXcOnQWzcAcOnI90wtgzXg4AJ6wECRn1UPBNoQ45uz1LgtWMxSbPHcxbf9yOkJJOIqsc33fWfbedElilFB+mnHnTnfIHtcR00WMGT7JIKo8a7AAd6HGMy5TIBCzbZqCCn+11UvmL32gE/ChQCavhu8VWQpDZCXEdOEemHOn52dDlTg+K/Uo++QTTYyBNGygGxY+tBG+AJgfkV8Y0Z9yB7BDgQaD6yyi4VtzhF7F/uXdsOMZLo3hjDAHmpA63nVYi3We5lBqNtGBThLb4snmlhfopy1vviR5IhkfZbRb8Bz1oEg+Wk1iulyPKLxH4Fj3CRmTkNH0R/iAKQ6cKyE4GSUKK6ETzW4H6cLzzKiQlB+0nX1PYOauASZcVyS3UMBpL6oZejWqYGUtF/LJ/8j1QgydQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add comments to the map_count limit checks in do_mmap() and
do_brk_flags() to clarify their intended behavior.

The use of a strict inequality ('>') in these checks is intentional but
non-obvious. It allows these functions to succeed when the VMA count is
exactly at the sysctl_max_map_count limit. This historical behavior
accounts for cases where the operation might not create a new VMA, but
instead merge with or expand an existing one, in which case the VMA
count does not increase.

These comments clarify the long-standing behavior and will help prevent
future misinterpretation as an off-by-one error.

Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v4:
 - Keep the existing lenient behavior, per Hugh
 - Document this is intended, per Lorenzo

Changes in v3:
 - Collect Reviewed-by and Acked-by tags.

Changes in v2:
 - Fix mmap check, per Pedro

 mm/mmap.c | 9 +++++++++
 mm/vma.c  | 6 ++++++
 2 files changed, 15 insertions(+)

diff --git a/mm/mmap.c b/mm/mmap.c
index 644f02071a41..78843a2fae42 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -374,6 +374,15 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
+	/*
+	 * The check is intentionally lenient (>) to allow an mmap() at the limit
+	 * to succeed. This is for historical reasons, as the new mapping might
+	 * merge with an adjacent VMA and not increase the total VMA count.
+	 *
+	 * If a merge does not occur, the process is allowed to exceed the
+	 * sysctl_max_map_count limit by one. This behavior is preserved to
+	 * avoid breaking existing applications.
+	 */
 	if (mm->map_count > sysctl_max_map_count)
 		return -ENOMEM;
 
diff --git a/mm/vma.c b/mm/vma.c
index 919d1fc63a52..d0bb3127280e 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2813,6 +2813,12 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
+	/*
+	 * The check is intentionally lenient (>) to allow brk() to succeed at
+	 * the limit. This is for historical reasons, as expanding the heap
+	 * typically extends the existing brk VMA rather than creating a new one.
+	 * See also the comment in do_mmap().
+	 */
 	if (mm->map_count > sysctl_max_map_count)
 		return -ENOMEM;
 
-- 
2.51.1.851.g4ebd6896fd-goog


