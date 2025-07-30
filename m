Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8E26C87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:53:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842598E0002; Tue, 29 Jul 2025 21:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F29A8E0001; Tue, 29 Jul 2025 21:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC598E0002; Tue, 29 Jul 2025 21:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 533658E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:53:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 27C9980311
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:53:54 +0000 (UTC)
X-FDA: 83719259988.29.7794BB4
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5247B80004
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:53:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CjVGUytw;
	spf=pass (imf02.hostedemail.com: domain of 3L3uJaA4KCJY8I002C0D90HH4I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--isaacmanjarres.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3L3uJaA4KCJY8I002C0D90HH4I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0VV+JH30v1GbhehHuS/Ja7CNo6IaL+kNvAkVgM9n9c=;
	b=RIcCuJ7c78rjWj3CMt2+3lLX+MsRLQHGFUwKgQwW9QQfzEjhZIRR+fy0XNOJ6BmE28OlT8
	bFRycTEqosPKx53hfsSAkH5MkC57h4pn9ZRfZ8q/dnhWRc2Mpu5QNzJNx+Je8wqqR1GW3h
	uq1f6ZCvdRk5huX7Cw1ApYbpfaSVQQw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=CjVGUytw;
	spf=pass (imf02.hostedemail.com: domain of 3L3uJaA4KCJY8I002C0D90HH4I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--isaacmanjarres.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3L3uJaA4KCJY8I002C0D90HH4I6EE6B4.2ECB8DKN-CCAL02A.EH6@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840432; a=rsa-sha256;
	cv=none;
	b=gPTXktCcJD2cr8w+E7lfW3KMh44myQKfNFbpQl17znRCTLY1A5OJB5PyBl1enNAukK40/D
	yvwrlwh1QGw9gJ9NU9h7PFrnf9PM4EqXQyneiNJpsmKKzXQJKSyS/7LQKHC3FWRFp5C0bL
	96iXQe+Ar3FDaCErD3yzFCIN89ry5I0=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31ebadfb7f2so445741a91.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840431; x=1754445231; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P0VV+JH30v1GbhehHuS/Ja7CNo6IaL+kNvAkVgM9n9c=;
        b=CjVGUytwsZ9GPHHgFILvmNVgB/RXZBPeNLWop/KqIgiZwKYw9SxlX8isg83TMCtaoh
         hVpXifJHM3u1OR+QpHuEiwjPLZwWyqwE5KT5uNqVizrzFP8y4m/AJP4E1BJIez7dUm5O
         dtSuNV428RVUPrkBSybxoDEOmsmq7xSp30Txnhtgf/eeRp6J8r5RVyr9YLbPSiu92PRV
         TMJaXGRTMVwIW6tYjkIAOJQYNEsR1c81rozhVtpgM33YmEpia+J5azylnvpjrl6sXJA9
         SO0Wer5KinODCalOfnLUOhU5YiTq2DM3CongJ3TvdPmR/t2sUrjNoT6vXzQbc3rmKP5n
         XUyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840431; x=1754445231;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P0VV+JH30v1GbhehHuS/Ja7CNo6IaL+kNvAkVgM9n9c=;
        b=XD1kzDs0QpdUi02L0oj4xq13Ygi4uI0C+5JAqfuQMtnF5gvZCSAbOjPgZl9zbUOPa6
         KTP89puynkIMPrrpKhVJdmEc/eSgr8aXgOn637IixNq4bb7Boz4dqWd11vtx3KrI33eV
         8yg6d9jW8XvcycjB6JZZMVRzg8WKqnth5MKkhjKccKJGMuwKerq3Dggvkb8fKLkTNQ9p
         jI4uBE5qG1LXiQD6YWGzVcXTRzl5kZH6pQej0hkKHKUBMknbiBSi8VsDOY/TC6VFVlrb
         V8SBP4Cu35pI1Y5MONWkCM83uKh53gBOYdw3KboX49qEf7L68IIEnja5/2ETsb+XtRUK
         3UFQ==
X-Forwarded-Encrypted: i=1; AJvYcCVp+7+Uj4cqAtC0g6dhxUt1Mf1FXFc6yprYcEwrxn51nTndg8Htz/LAEX6lf3gWhBkEBd1nVBFYmQ==@kvack.org
X-Gm-Message-State: AOJu0YwyJLNhG9cX5AvBHt6WL+LIibVULQqXS4UhcnilOtI9dbOhfqTv
	qdqeAigCOsJUyBVTIgwb+uvcxBdJ0slkUmk7/RcsJLi7JOmizD9Ac0hjVf3stiqXZSGbDWoOJPc
	EsnznjN/0jKU98SUWZoi66WPyx30PVtq6Nd9yyA==
X-Google-Smtp-Source: AGHT+IGqXwNsOOqQkNtz8QQDEe1Oh8466meEyMzhkJWjcd4HVGycbNfCuQiTek98OfmXmyLRe3SoD9hsxVLzOCYblYlv5g==
X-Received: from plbi10.prod.google.com ([2002:a17:903:20ca:b0:240:33b6:5880])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:da84:b0:234:1163:ff99 with SMTP id d9443c01a7336-24096b0dc3cmr21253325ad.43.1753840431245;
 Tue, 29 Jul 2025 18:53:51 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:53:32 -0700
In-Reply-To: <20250730015337.31730-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015337.31730-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015337.31730-4-isaacmanjarres@google.com>
Subject: [PATCH 5.15.y 3/4] mm: reinstate ability to map write-sealed memfd
 mappings read-only
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: aliceryhl@google.com, stable@vger.kernel.org, 
	"Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, 
	Julian Orth <ju.orth@gmail.com>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ski9yk85uu5b1oqk4drxnnqaxoi5mhx8
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5247B80004
X-Rspam-User: 
X-HE-Tag: 1753840432-372371
X-HE-Meta: U2FsdGVkX1/KaHDiT8aLBg2tp6NS1vyxGAi7jWSVraXvrmGamYy/jcZsL/JFZvO918wm4bEr+clq/VaHdEUIl2wCrWYvN7dSwvi2Gu7eMVKe1aAVNzzPfl/Y/GGX77u9lzWx1xS8z6Usx3HSdpaPad6r1lPZVjK7RyQc8AQROL5G3+WQplBKjyN6f7bYgWnOwxIdcPHJADVzLRt4ZS9G50ekiQBajSkcUYoAOmEpj3f1tBYuL+Z7VmODhdwEAj/BiKA7lpAhzXD9RUqAMVgmU9O8m7fEab9ecrYBpn2MUd2xVdSp3uUxe+N5B/54bgM6ZKNAL6flTA1LMQLBQRpU8yTAh7KQVb9x7uqx3LItSRFsmPCKOvhyJwKY61ZxV2w/YAUErm8coxRVBzEhLk9ySoOW6RRKWWP9rBe9SloyovpLPjg2VQugK8Onfnb49zuv1SPlvLMc/hey1HnO93AEaPtVem1lbGD4z6Fq+TsNZiQFhckqhIqWocnqwG2yXOu3MpeSQeBMvmIbAAEKZYUQcxAaKLg5IH35N9h+2/Gv7dXaUZmfNW+h5epCycsRlMnTwLaw5fwWYeX8RIk2XN7KQw0QNf5SEqWU5oQYgDa+4WNoSoPtfShvkiKxrLt/bkxrPtRX1cZ7aHCJQBlequQfMFQufEEz5B9CO67ab/cRt5aKbr7rbpK1pESYr8X/E0E292wp6HARxoYVVSRzhIwEd6ADcEKCc7HASzn3dldc1pCPPBNp+6ODfQHDSwXnVXWa+YqsKyyW4gseRVZnIXCUpWAguqbyyTD5e7/0mpNJSIvtTkAGklqXKXxMkuhCf3w5aKw0Dj08+RqeufMFJ4H0u+LFkW4P/YVbc6U/RLUB1ywMCMmYcRRh5RByw2mNFgoYZtCj7RU47XyKNFbb2V9ZIO1rh0tPRRNGXnZM6SHSZ5N4w+R9osZcqXifmDR5I85Jpv7fQ1nWQJKZY94lfV/
 xEDpauX8
 BcitQqu2gS8aZdpE3OIV0GzuTFqCHGACW8mNJiLeM1jd38xO1dtvZ5AHx0vk3toaxs8r/fZlrOYOsWE3cg1mUQkpR9VZvatZ90CKvGk77fwqIEsJtkikkA7nGvRa8uHYfDOZiPWlbtUPBYUWpC/sJ7mjHo7JqN3Qm2qFVm81o8FqS1l9y5Nwa4wcQhUiAk9b8LEJt/bU0d20bm/sxYE4xECqt15W+UpJrOBZC7zymGYBL083lhXl4BilxdHlrs3NqaOkeC3atYDWVJlpqnDFvbelG1WkAfCCDr0rNV8CGosQU+U9Ua4Rl0tQBUgFM52zybMpagp0h1IARJ/hEaQbzxIx10PFunxaEv49ESLmxbnZ01FoRjqzX9lONhuqGSHCxO2OZsYkXC80+l5OvZnJBt8PQ9W+b+XIYjKJjlqjqdjObvOEaeLMvx85+SBVZu/zpSiGjEW1t0P3gfaRiBDAXEy5jkW+ovI/mqjbbnGdyhFOL4MDRhCOxUE/G703Sf0YJed6vX5B/vUNRuF1MFkkKRK4bB/EXyJED4bzlzQVGM6gtIFycyNISP+NVJG6MKfeoPGgkZ/Q5iweZC/ZvAgEcmdRgYGJ7/fhIxUc2EFo/zxQVgHbdaFTxwuhU08nHGzUpzEk2VJFlHAqOZeyHtanKT5o2Z03+DhHWbb+YgTU/NaYVZR50X63eTJt203nmI5nraxYP3p/RpO3xAGGwP4UbSuIdIZj4WMX6LObDTiH5cWnhic8UWs72JWUrp7jjETH1TxNlHxYj8BSh5SH/l4EuXnZ2CwzCNkx2W88Bw73PjJCuqN1LenCtYGfuPsRzsCtw7OHqIeA2mgDVxUqBfKPWWQoOvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[ Upstream commit 8ec396d05d1b737c87311fb7311f753b02c2a6b1 ]

Patch series "mm: reinstate ability to map write-sealed memfd mappings
read-only".

In commit 158978945f31 ("mm: perform the mapping_map_writable() check
after call_mmap()") (and preceding changes in the same series) it became
possible to mmap() F_SEAL_WRITE sealed memfd mappings read-only.

Commit 5de195060b2e ("mm: resolve faulty mmap_region() error path
behaviour") unintentionally undid this logic by moving the
mapping_map_writable() check before the shmem_mmap() hook is invoked,
thereby regressing this change.

This series reworks how we both permit write-sealed mappings being mapped
read-only and disallow mprotect() from undoing the write-seal, fixing this
regression.

We also add a regression test to ensure that we do not accidentally
regress this in future.

Thanks to Julian Orth for reporting this regression.

This patch (of 2):

In commit 158978945f31 ("mm: perform the mapping_map_writable() check
after call_mmap()") (and preceding changes in the same series) it became
possible to mmap() F_SEAL_WRITE sealed memfd mappings read-only.

This was previously unnecessarily disallowed, despite the man page
documentation indicating that it would be, thereby limiting the usefulness
of F_SEAL_WRITE logic.

We fixed this by adapting logic that existed for the F_SEAL_FUTURE_WRITE
seal (one which disallows future writes to the memfd) to also be used for
F_SEAL_WRITE.

For background - the F_SEAL_FUTURE_WRITE seal clears VM_MAYWRITE for a
read-only mapping to disallow mprotect() from overriding the seal - an
operation performed by seal_check_write(), invoked from shmem_mmap(), the
f_op->mmap() hook used by shmem mappings.

By extending this to F_SEAL_WRITE and critically - checking
mapping_map_writable() to determine if we may map the memfd AFTER we
invoke shmem_mmap() - the desired logic becomes possible.  This is because
mapping_map_writable() explicitly checks for VM_MAYWRITE, which we will
have cleared.

Commit 5de195060b2e ("mm: resolve faulty mmap_region() error path
behaviour") unintentionally undid this logic by moving the
mapping_map_writable() check before the shmem_mmap() hook is invoked,
thereby regressing this change.

We reinstate this functionality by moving the check out of shmem_mmap()
and instead performing it in do_mmap() at the point at which VMA flags are
being determined, which seems in any case to be a more appropriate place
in which to make this determination.

In order to achieve this we rework memfd seal logic to allow us access to
this information using existing logic and eliminate the clearing of
VM_MAYWRITE from seal_check_write() which we are performing in do_mmap()
instead.

Link: https://lkml.kernel.org/r/99fc35d2c62bd2e05571cf60d9f8b843c56069e0.1732804776.git.lorenzo.stoakes@oracle.com
Fixes: 5de195060b2e ("mm: resolve faulty mmap_region() error path behaviour")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Julian Orth <ju.orth@gmail.com>
Closes: https://lore.kernel.org/all/CAHijbEUMhvJTN9Xw1GmbM266FXXv=U7s4L_Jem5x3AaPZxrYpQ@mail.gmail.com/
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 include/linux/memfd.h | 14 +++++++++++
 include/linux/mm.h    | 58 +++++++++++++++++++++++++++++--------------
 mm/memfd.c            |  2 +-
 mm/mmap.c             |  4 +++
 4 files changed, 59 insertions(+), 19 deletions(-)

diff --git a/include/linux/memfd.h b/include/linux/memfd.h
index 4f1600413f91..5d06bba9d7e5 100644
--- a/include/linux/memfd.h
+++ b/include/linux/memfd.h
@@ -6,11 +6,25 @@
 
 #ifdef CONFIG_MEMFD_CREATE
 extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
+unsigned int *memfd_file_seals_ptr(struct file *file);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned long a)
 {
 	return -EINVAL;
 }
+
+static inline unsigned int *memfd_file_seals_ptr(struct file *file)
+{
+	return NULL;
+}
 #endif
 
+/* Retrieve memfd seals associated with the file, if any. */
+static inline unsigned int memfd_file_seals(struct file *file)
+{
+	unsigned int *sealsp = memfd_file_seals_ptr(file);
+
+	return sealsp ? *sealsp : 0;
+}
+
 #endif /* __LINUX_MEMFD_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 61874611d0e4..3598925561b1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3286,6 +3286,37 @@ void mem_dump_obj(void *object);
 static inline void mem_dump_obj(void *object) {}
 #endif
 
+static inline bool is_write_sealed(int seals)
+{
+	return seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE);
+}
+
+/**
+ * is_readonly_sealed - Checks whether write-sealed but mapped read-only,
+ *                      in which case writes should be disallowing moving
+ *                      forwards.
+ * @seals: the seals to check
+ * @vm_flags: the VMA flags to check
+ *
+ * Returns whether readonly sealed, in which case writess should be disallowed
+ * going forward.
+ */
+static inline bool is_readonly_sealed(int seals, vm_flags_t vm_flags)
+{
+	/*
+	 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
+	 * MAP_SHARED and read-only, take care to not allow mprotect to
+	 * revert protections on such mappings. Do this only for shared
+	 * mappings. For private mappings, don't need to mask
+	 * VM_MAYWRITE as we still want them to be COW-writable.
+	 */
+	if (is_write_sealed(seals) &&
+	    ((vm_flags & (VM_SHARED | VM_WRITE)) == VM_SHARED))
+		return true;
+
+	return false;
+}
+
 /**
  * seal_check_write - Check for F_SEAL_WRITE or F_SEAL_FUTURE_WRITE flags and
  *                    handle them.
@@ -3297,24 +3328,15 @@ static inline void mem_dump_obj(void *object) {}
  */
 static inline int seal_check_write(int seals, struct vm_area_struct *vma)
 {
-	if (seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
-		/*
-		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-		 * write seals are active.
-		 */
-		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
-			return -EPERM;
-
-		/*
-		 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
-		 * MAP_SHARED and read-only, take care to not allow mprotect to
-		 * revert protections on such mappings. Do this only for shared
-		 * mappings. For private mappings, don't need to mask
-		 * VM_MAYWRITE as we still want them to be COW-writable.
-		 */
-		if (vma->vm_flags & VM_SHARED)
-			vma->vm_flags &= ~(VM_MAYWRITE);
-	}
+	if (!is_write_sealed(seals))
+		return 0;
+
+	/*
+	 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
+	 * write seals are active.
+	 */
+	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
+		return -EPERM;
 
 	return 0;
 }
diff --git a/mm/memfd.c b/mm/memfd.c
index a73af8be9c28..6a6bbc4477a9 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -133,7 +133,7 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 	return error;
 }
 
-static unsigned int *memfd_file_seals_ptr(struct file *file)
+unsigned int *memfd_file_seals_ptr(struct file *file)
 {
 	if (shmem_file(file))
 		return &SHMEM_I(file_inode(file))->seals;
diff --git a/mm/mmap.c b/mm/mmap.c
index e1dada58788f..273e06dad3c6 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -47,6 +47,7 @@
 #include <linux/pkeys.h>
 #include <linux/oom.h>
 #include <linux/sched/mm.h>
+#include <linux/memfd.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1486,6 +1487,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 
 	if (file) {
 		struct inode *inode = file_inode(file);
+		unsigned int seals = memfd_file_seals(file);
 		unsigned long flags_mask;
 
 		if (!file_mmap_ok(file, inode, pgoff, len))
@@ -1524,6 +1526,8 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
+			else if (is_readonly_sealed(seals, vm_flags))
+				vm_flags &= ~VM_MAYWRITE;
 			fallthrough;
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))
-- 
2.50.1.552.g942d659e1b-goog


