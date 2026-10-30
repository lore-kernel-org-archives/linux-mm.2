Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92243606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=reer/Bk4
Received: by kanga.kvack.org (Postfix)
	id 0E7A16B05BD; Fri, 30 Oct 2026 10:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 099C96B05BE; Fri, 30 Oct 2026 10:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECA616B05BF; Fri, 30 Oct 2026 10:43:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEE6A6B05BD
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:43:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 330484073F
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:29 +0000 (UTC)
X-FDA: 85379560938.10.38D9334
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 359AF160007
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:43:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b="reer/Bk4";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HxYJPyHsnO8kCvEm8RF+EM8gZ6vVJrs8zKSibqUU+00=;
	b=VeYoJJTRSLa36J5dYWrD5jbqD+5z5BjkHt0g4I1K11mkxcavZTbOOx5cV5qYJCDwEZpM6b
	nYpS7CDI1an1e8T5qpvGCIRGZ+Fflbswd0P50gCoP5PCfj68CbyS678unJ6nuCoGv9Jmr9
	58xxQhG8/ljgPUEaSawPuRzUp85pgsI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b="reer/Bk4";
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371407;
	b=fcCnP5eNZOpZo6cPUZrrI7+La487XQLqyxktH+VIFnTFSN2kIqoY3o1UKWV7vxvxQWjTLy
	sCnG/G3C5pEny1TCpu4CT0zHnrEjWkcVnMDYL+NTvuEeyHlpS6NAV30ox8fjZKyxIEcDoZ
	GkKkN5z0hFAuwNsGhuo4GhA4msFsfjw=
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-53653e30353so11900621cf.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 07:43:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793371406; x=1793976206; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HxYJPyHsnO8kCvEm8RF+EM8gZ6vVJrs8zKSibqUU+00=;
        b=reer/Bk4qRB4mOXUhQbNirIoOTCVbNTCVykdPiI8BLe+Gp67kxeR2bvovnX6UWxYVN
         7ap7fk3f+yxYyCBRW8XIgvlqBxmnHsKAQbzQQF+/q5lufv8/fDYmvOIErynBHhql9Iau
         VKT12rGn53SGgcnviLhaj+SsTIc9y8qR4QT5eHLSlZUrN4IL5Kr/ZwuISyhPZQvYIDcU
         fuj9Hr47OqL32c/Ep600cbv8JlRkHExR3phjeLI24jswNLtqqyyikM1oXaH8rPmdkoMd
         8wekiCpoX88PvoJNKOVdQ1fYNwXsuAckpAFZrfxp+mm6ekT3W1Vf28Cn+g16Ex9pgBoc
         fzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793371406; x=1793976206;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HxYJPyHsnO8kCvEm8RF+EM8gZ6vVJrs8zKSibqUU+00=;
        b=2xbTdTDeQYvFCh88cQUJ9YqrmL5IXYzLFEyIjOoe7Xk9Zj1IBPVGnIUoiTueDv9eP9
         HwjqpIKjZTbNlHg/1HkeNY5y151oR++iW48D693OOvVxOtisATj5alC3+9yCnduWLZz6
         Ry6STVcwxg9GrnOLknfs3wQ5n55OUjnXt886lzMSh7MditfjXVe1E3fhLvuZknrz/tS+
         qzSMX4JTwaTnnMgcN/oaUdAsQb8utbLkF0d6q+KilShZx1pcsJUhMivEyehqZzycfm3d
         01fF6uj3MxSxPi4mXMmPt8PLoRADgk+gY7PKWZ0loWzoVxKkbOaaeTd2Q47vs8wxjC7+
         a5Vg==
X-Forwarded-Encrypted: i=1; AKwUvBx6Dp7Hd2yEJgfUd7UD2OZT/vGjYAxptFntNivtEBg/L/vQJ7axBgvceZCX+m7L0n+XSUEBJSzGhA==@kvack.org
X-Gm-Message-State: AFq9FYJVLqqzwP/sT291ZiOK7n0JsLDfDT7nSKRA+y6nUuxFjs52AzM/
	5CHizUnrs+PoVY7AYstfYFIdlD01HWOMVYQVQ/1z4QiX17MABXkZHZx4S7foEhwvsqTIwZnI9cE
	tmVmADo4=
X-Gm-Gg: AYBFou1vxZJdnqJYUyT4m/6JYDmIylsvFCllNEhzCg6zQ2pv97/nPaMvq80hsPEgaRF
	yh6wJUw4HHsgyclsoBbo0sbB8vmjQ/sczjaQh4PztSSqjR/g2lMVZFbFRMb1yUvc8kwMsvZwA6k
	yrsbjTZog1rJ0zo4tjpX71xdhNXDtI6qxSr64ukW6KJM7kAKLLCeCcfD4JPoDO6O7YHt2ioucXc
	oHn7v77r2+aKAdFGiFSb39c2b63e7FGu5ESHgfYOpRPK1FYu0JC6qWoN/Czzu2hvgkXmiPxTrzz
	moki2oHmF5UPmNga4CRmxjdWgptFVGEQudreRsysxIVxan9QHHniE9arWAAgnshRHNjtjQdO+pz
	RsDt+LmdRfef9FJAzbnsNAtehWHl/o0LXWQroz6Vx9spNGlycR9un4A0qr1cUuS50eXeMhhS4S3
	A96IbMpKoAfNIlMYDakO7BRCqROo9BhiETUx8/NhNMgqYVprE43LbXaDJh2xM8tZCisGBIm0Ffw
	0qcQN89sU8bVVdeyWE3TOSNnaG76+V8457wpbo8lfSE7LSl276lrj/4O5keo3dUL2am6Qn4tsCC
	2pwoFNgAluTc+reCT15hpQAVPSvtuOMvLAJ8NR6m3luklw==
X-Received: by 2002:a05:622a:5793:b0:535:b21:c997 with SMTP id d75a77b69052e-542b3a79103mr39989021cf.8.1793371406059;
        Fri, 30 Oct 2026 07:43:26 -0700 (PDT)
Received: from toxicpanda.com ([153.61.196.246])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5430faff332sm15052181cf.2.2026.10.30.07.43.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 07:43:25 -0700 (PDT)
From: Josef Bacik <josef@toxicpanda.com>
Date: Fri, 30 Oct 2026 14:42:51 +0000
Subject: [PATCH 6/6] mm/mremap: split first so a failed split is reported
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-b4-mremap-pre-split-v1-6-c1829811aed0@toxicpanda.com>
References: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
In-Reply-To: <20261030-b4-mremap-pre-split-v1-0-c1829811aed0@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793371378; l=3590;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=S6y7MbMeBq4sG7K4ABtPlh1W7VoOD99D2FN+R3fYesI=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QNIHZA2KdSqmZaS78T20Z7yZ7mPe9Wi3CO8UmIxA3GVSrFyED0BIY5ztRrnl304EVtvMmJw7uge
 NxzHJEQc9nw4=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 359AF160007
X-Stat-Signature: pb4ixdqkew1dgozoce9ayday3a4qqj9q
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793371407-607441
X-HE-Meta: U2FsdGVkX18LFECPqBROsWoqmwrt961IPCxeKC3NLn9xf6rvQ89hmaG41fpeg4N+kfMppAaCVGK87+QIvlHFwcwFMZoKae11eAuZ3gYY89loQXY+fdz6I0g14zJKpH7rFfRuycNyjMc7DpdOo89S5zPGUaVpvvACyivSkYulAMbgIjf1va2D1LUZkeiJs8WYDyitD29wlRgemKc9/T34l+uQOKO+J7ikXjKaq0bRIvKqghRPCZqtGKsaZCJxp43VPWVs+9TAzSumVid2zRmX0kwRLbPYAuK3w6ZfnZsZtFunQYK3M1jWfY/lYf4TDcj24VHs8ZVT6R6TE3UFZfHUKekBzL8v82ivR14Wz7zR6cO+EPqwPQ9TM+g8LqOwq/9KaAgSavMS33IwWlrVDWN42XIqG6ZpQSHT+oRw476QrrJv+JdHS+ragTuX7HmUjfAsW7sSYuclcfOTKV9qtGCfe/kl50SUETekOMYSLSdTxQUUgxarn4e6YHI3rreWXnzfTiTkLpBqjb/4JmzHKWXsRhRa008kSsr13mBW+f3j2xJZ+hhHooXCkcN3+vxXS68GBOZiRMMRacoZ91LT+awq9evrrSIJZEZFCoaaNc6XHRxphFfocqA2EckZK879h/OKPvu1e5ObTqIhcKAjnOmQnhMW0f46PdMvRZLTUbzDyR0aWq6ZMzGjFy+EuG62wre8XIy7+2SefyBEX5IDbhqNF3+CuiOifz2AjgzW+yaG+IkT8P3tCAheIfogrjVpRK1qhet2NoSGM5bqyDAZsVC+QJAGMqOh4YrYsc3o24088fNTf+ROHsOabNgiOXMEbZO86svsVrzFDFjZWNMoYDyo5FsaGrsnzYsmlC71f/31LjRFDohxzpxTwFESFDuCc3l8PTTVH82Kh6KC3GyK2laxmukKlf82hJZ3WUu8ro4726RwwUU5U4fBaRfSTCnYUWdz1y9UZ/PKZVT7I34BpCe
 hFP33eKX
 yN6TMMbtG4YbjizQIpxSo/VbmXKXySb5h01vH3Ks5kTdGEsaTyrKZs/UXy5YfCfYIeK+3P3yBzlwJ2z1RxxZiETtRUIr2TLN2ZBuj1+Y6hmIsxnhun1FLzeX6+ECCoR7IH5hGUjfUy2/yPYSA12qPMRpQJtkL2kM8UJsyGLFpD6KgekGw57jbHiAvbGbToAjyIG2pO4wS6bquZ4ULECkAXK951BdqH+WwYbdzRRrl9sOhRfyS3gF9t0TJ966y/7Sn54I3YZeUsy6l4Fz9XX72AeKuWDRlpC+uNK6PI36BvOCHOcqG7NsXDlci4rIwR0vHIybZNHn80q9KOJs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mremap() can return the new address although the old range is still mapped,
which leaves the caller with a VMA it does not know about.

To move a part of a VMA, that part has to be split off, and this is left to
the unmap at the end of the move. If the split fails there, the page tables
have moved already and there is nothing to go back to. unmap_source_vma()
returns void, so move_vma() reports success.

This was reproduced with fault injection, by failing each allocation of
such an mremap() in turn. Anonymous and shmem mappings hit it at 2 to 7 of
7 to 13 allocations, with numbers that differ from boot to boot, and no
longer hit it with this patch.

Fix by splitting the source VMA in prep_move_vma() whenever it is going to
be unmapped, so that a failed split is reported before anything has moved.
An old size of 0 unmaps nothing and does not split. If a later step fails,
the VMA stays split, as it does after a munmap() that fails half way. The
unmap at the end can still fail in its allocations, or if copy_vma() has
merged the range and it has to be split again.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/mremap.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 256eac721a07..64f8e0895e77 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1112,11 +1112,20 @@ static bool split_source_stays(struct vma_remap_struct *vrm)
 
 static bool needs_pre_split(struct vma_remap_struct *vrm)
 {
+	/* This duplicates a shared mapping: no range to split off or unmap. */
+	if (!vrm->old_len)
+		return false;
+
 	/*
-	 * fixup_hugetlb_reservations() takes the reservations away from the
-	 * source VMA.  The parts of it that do not move have to keep theirs.
+	 * The source range is unmapped once its page tables have moved.  If a
+	 * split fails at that point there is nothing left to go back to, so
+	 * split while the failure can still be reported.
+	 *
+	 * hugetlb relies on this too: fixup_hugetlb_reservations() takes the
+	 * reservations away from the source VMA, and the parts of it that do
+	 * not move have to keep theirs.
 	 */
-	if (vma_is_hugetlb(vrm->vma))
+	if (!(vrm->flags & MREMAP_DONTUNMAP))
 		return true;
 
 	return split_source_stays(vrm);
@@ -1175,10 +1184,10 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	if (err)
 		return err;
 
-	/* Perform any split ahead of time if the source VMA has to be distinct. */
 	if (needs_pre_split(vrm)) {
 		VMA_ITERATOR(vmi, vma->vm_mm, old_addr);
 
+		/* This leaves vma as the VMA that spans the range to move. */
 		if (split_before)
 			err = split_vma(&vmi, vma, old_addr, 1);
 		if (!err && split_after)
@@ -1247,10 +1256,12 @@ static void unmap_source_vma(struct vma_remap_struct *vrm)
 	vrm->vmi_needs_invalidate = true;
 	if (err) {
 		/*
-		 * OOM: unable to split vma, just get accounts right. Both the
-		 * old and the new range remain mapped, so charge the range a
-		 * second time, and reinstate the flag on all that is left of
-		 * the VMA so the charge is returned when it gets unmapped.
+		 * The unmap failed, just get accounts right. Both the old and
+		 * the new range remain mapped, so charge the range a second
+		 * time, and reinstate the flag on all that is left of the VMA
+		 * so the charge is returned when it gets unmapped.
+		 *
+		 * An old_len of 0 ends up here as well. It has nothing to unmap.
 		 */
 		if (accountable_move) {
 			vm_acct_memory(len >> PAGE_SHIFT);

-- 
2.55.0


