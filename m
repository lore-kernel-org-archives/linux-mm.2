Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3601606A32A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 01:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=mailfence.com header.i=brianwitte@mailfence.com header.a=rsa-sha256 header.s=20240605-akrp header.b=EDrVvGmx
Received: by kanga.kvack.org (Postfix)
	id 05E066B0AA4; Thu, 22 Oct 2026 21:54:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 035DB6B0AA6; Thu, 22 Oct 2026 21:54:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB5846B0AA7; Thu, 22 Oct 2026 21:54:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD10F6B0AA4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 21:54:48 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D2AE40367
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:54:48 +0000 (UTC)
X-FDA: 85352222256.09.7E9450A
Received: from mailout-l3b-97.contactoffice.com (mailout-l3b-97.contactoffice.com [212.3.242.97])
	by imf07.hostedemail.com (Postfix) with ESMTP id 79C2340007
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:54:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=mailfence.com header.s=20240605-akrp header.b=EDrVvGmx;
	spf=pass (imf07.hostedemail.com: domain of brianwitte@mailfence.com designates 212.3.242.97 as permitted sender) smtp.mailfrom=brianwitte@mailfence.com;
	dmarc=pass (policy=reject) header.from=mailfence.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792720486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kEfN+lz4jC9aTNLTOmPGU5NO0fDKtkjBweUc+hWx6MM=;
	b=VtT7bxP2mK0XM81+A6O8tzrDa1HtscIQKbBK8BUnP88s21nTe0NXFZ990uB2TdN/2fwLz1
	tDkg/XS+OSHlCw286J+OWxfxcI2C8QKSax+9qHCe6lT+jFD7HoPtW+Zzq5AoPHj/zEKZTE
	+ZtiyG948jgbfR1X2JXKSwIyuBWq6/0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=mailfence.com header.s=20240605-akrp header.b=EDrVvGmx;
	spf=pass (imf07.hostedemail.com: domain of brianwitte@mailfence.com designates 212.3.242.97 as permitted sender) smtp.mailfrom=brianwitte@mailfence.com;
	dmarc=pass (policy=reject) header.from=mailfence.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792720486;
	b=1iIixHJ6iGGseOncs++h3v6/B2v/JahDek/6jEfIuh9nKf27YAtfdt9m0pP/D9deAXpyJi
	hF5yZ7FO8MfbBZUjSsUEQ/rrhghtPUbmwK8godv/d1KFa8Mb+ty2LF0zR+Yel4zflyvo+y
	xbvrizQl2/LKhcjDhPmP5vOFlWeYp+c=
Received: from smtpauth1.co-bxl (smtpauth1.co-bxl [10.2.0.15])
	by mailout-l3b-97.contactoffice.com (Postfix) with ESMTP id 633C060B4;
	Fri, 23 Oct 2026 03:54:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1792720481;
	s=20240605-akrp; d=mailfence.com; i=brianwitte@mailfence.com;
	h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From;
	bh=kEfN+lz4jC9aTNLTOmPGU5NO0fDKtkjBweUc+hWx6MM=;
	b=EDrVvGmxri9ofREdVPpPBZNnNxHebFqjfRzzXJJ93GYzrgzG12/r8IJOJpkT9Ews
	00N8wbDFz0w87sQbiN3sIeTV9aJYbKoS2F9yRSEi7HrhCbcXgUswpDLqy3Ea9EQoxKO
	rAH2bduHukf20f3FqXAPlN8cY6eOVWwlsfd1jrjYEuAKn9NPIDDgTOrHWZJuYJUQ/xJ
	fBXS/j/FmobO4vXiHl5m3tcQIJvcV/svlKSVmsNv0F7hM9T6rRyvXeO57wdnDncSriN
	qUvfpPMczS83cciA6qu+vg5AvoItHHhJyUQTS1pD44AmYhGRx82KfOcKDuDl2cf3Vbf
	Sowd8Uq20g==
Received: by smtp.mailfence.com with ESMTPSA ; Fri, 23 Oct 2026 03:54:40 +0200 (CEST)
From: Brian Witte <brianwitte@mailfence.com>
To: Kees Cook <kees@kernel.org>
Cc: Brian Witte <brianwitte@mailfence.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jann Horn <jannh@google.com>,
	Helge Deller <deller@gmx.de>,
	Justin Stitt <justinstitt@google.com>,
	Daniel Micay <danielmicay@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-hardening@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] exec: randomize the argument block's offset within its page
Date: Fri, 23 Oct 2026 03:54:41 +0200 (CEST)
Message-ID: <20261023015345.1594514-2-brianwitte@mailfence.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023015345.1594514-1-brianwitte@mailfence.com>
References: <20261023015345.1594514-1-brianwitte@mailfence.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CO-INDEX: 5Hfd5iwv96PZ+oxlg2+SbbocvRakgd9BwmPCE7Z93iA=
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 79C2340007
X-Spam-Status: No, score=-23.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1ftsmrgwbu1mutgqifp1nxrwrcdpdx5g
X-HE-Tag: 1792720486-180888
X-HE-Meta: U2FsdGVkX1/OtSEjREw45Ypl51iI/+eW+jCoPZpNpR4YMar60n4Ecax5TAV+qitJK4cPI4VJ1vS/siKF3v0XKdIuuWL/7NDEdspVufH2kdp+tbk1g4MuDnmJTDFZM3a3jKO+3dqFXoiI55elY6rPAVNt5Bwgv1QnQ7CjtBzgcBZdnP2ECpxqQbwp645Z10QF4ekES8elFmYVwIehzAgk6go9jYRRJf37w1wnzmgvX9pSqjrxnTRUDonDYJGpUdEZKCO+1yaUxQpsnX/36sAtn3mJwrxARt1x8DZOnv/xc/fL9KUzxq+IcPr8zn1AdXaNp1k/bF46IoVvQoib863FHgV87uaWEwoA8NdaCV1NJG5R54a6ahJf4ix5wPhcg//SjKuAsrxuLV+MYjeGtbga2ZztmCR9bKRMPjWDd8sI2BvJO9aOYcSrQn2vnYALpruSc7gOhXaBDOQ+yf3uhKaDRCz2npNYmjRNIOMV3w2Ipfz1iq00DRykPEpdclMI17Q2wQMtDC2VpsvaeGtMv8kgLYNEgYdquXbCkyliZO6mkoaztkhbyFK9hRVFPHpgrZR7qZ4QjyWD6ai73C1WQMlD30e3Gfi9BFn8W34fyj4NzbSBExVMchnma68lk05mp7jenxyZT+DkL1JETbkqYdzTPPQ1iKCd/23uwr6t8aBM7QfyCMuuENS45mcvTdCSJMkpHDR+0eef8KEFyHTkqZlcG6iyqVqobUtRZ4X6wsLUlzhzF9f56/iMxPYJ6ATTpNtXU/cVHxk9OcAhE5q6mp+zQZvBLNMRDe7/ZLjNwxKta21aat/TWVz5sz7vxTz4hN0AMwJgmeJ0Rx1mltyeArsc+gXbmMzovXvjtTFG8nKzLItBu59dD8pCeG6vJeu2zSm7syJx3kyrtQMdjf7llmYYmnUfQvhJbFidzL3h7QW32r7YLqVrwmESvx81YFhJSJTgVt2sRTsEO10zpa24xIJ
 m2+X08Q/
 rdBUH7mB8tFwgQ4khsclEMO2e2Z1uyBkN5GF/Z0ThQWN6K8pDPFNFombO9om0mSbD5rxvBEsXdFhvPN4d+9WtnG2qHW6ZcZZ6dKlM3tTuD0ocM3llCBCh7QyAsnbPPYeCNzAAfYKvGddIcFqaf/kIlRcqdrITHB/kWCD25sElky/gjHAgiQZx2vOQ0iRZfUwvKN5do2Jkv5zzPeF684Zi2JATiEl4Od9HC0aQZKJU4qWMgZ8g9olt5odSPhuOus7TJcejZhYZZsuEtHRTYXJqstG3YX48sNwRgadAfwN7g6b6l9JPwRYA3GNnyle4qfrcAipElQI5dCVLH1es9PY3jXJeMPIkoclKLsVfAb/NLQOXs1u5wPu8wsm2M/WSmpSLo2f+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

bprm->p starts one word below STACK_TOP_MAX, and setup_arg_pages()
moves the stack only by whole pages, so the argv, envp and execfn
strings sit at the same offset within their page on every exec. Three
execs on x86_64 put argv[0] at 0x7ffeee30af9f, 0x7ffdf3709f9f and
0x7ffc871e0f9f.

Lower bprm->p by a random amount under a page before the strings are
copied: about 12 bits of entropy with 4K pages and 16 with 64K.
bprm->argmin is derived from bprm->p, so the argument size limit is
unchanged, but up to a page of RLIMIT_STACK is used.

ADDR_NO_RANDOMIZE disables the offset; PF_RANDOMIZE cannot be used,
since load_elf_binary() sets it after the strings are copied.
PER_CLEAR_ON_SETID also clears the flag for set-id execs only after the
copy, and moving the strings then would mean copying them all. So
bprm_fill_uid()'s set-id checks are repeated early, without its
inode_lock(), and a set-id exec gets the offset regardless of the flag.
A racing chmod or sysctl write can make the offset disagree with the ELF
loader but never affects the credentials. Only the file passed to
execve() is checked: set-id interpreters, file capabilities and LSM
transitions keep today's fixed offset under the flag. The checks need
bprm->file, so they run in bprm_mm_init(), not create_init_stack_vma().

The idea comes from PaX RANDUSTACK; linux-hardened carries a version by
Daniel Micay and Levente Polyak.

Suggested-by: Daniel Micay <danielmicay@gmail.com>
Link: https://github.com/KSPP/linux/issues/283
Signed-off-by: Brian Witte <brianwitte@mailfence.com>
---
 fs/exec.c | 32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff --git a/fs/exec.c b/fs/exec.c
index 5d7b0fe32dbf..1070f0799b27 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -70,6 +70,7 @@
 #include <linux/user_events.h>
 #include <linux/rseq.h>
 #include <linux/ksm.h>
+#include <linux/random.h>
 
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
@@ -195,6 +196,33 @@ static bool valid_arg_len(struct linux_binprm *bprm, long len)
 	return len <= MAX_ARG_STRLEN;
 }
 
+/*
+ * Called before credentials exist: treat ADDR_NO_RANDOMIZE as cleared for
+ * files bprm_fill_uid() will treat as set-id.
+ */
+static bool bprm_randomize_args(struct linux_binprm *bprm)
+{
+	struct file *file = bprm->file;
+	const struct mnt_idmap *idmap = file_mnt_idmap(file);
+	struct inode *inode = file_inode(file);
+	/* bprm->cred, not yet set, will be in the caller's namespace. */
+	struct user_namespace *ns = current_user_ns();
+	umode_t mode;
+
+	if (!READ_ONCE(randomize_va_space))
+		return false;
+	if (!(current->personality & ADDR_NO_RANDOMIZE))
+		return true;
+	if (!mnt_may_suid(file->f_path.mnt) || task_no_new_privs(current))
+		return false;
+	mode = READ_ONCE(inode->i_mode);
+	if (!(mode & S_ISUID) &&
+	    (mode & (S_ISGID | S_IXGRP)) != (S_ISGID | S_IXGRP))
+		return false;
+	return vfsuid_has_mapping(ns, i_uid_into_vfsuid(idmap, inode)) &&
+	       vfsgid_has_mapping(ns, i_gid_into_vfsgid(idmap, inode));
+}
+
 #else
 
 static inline void acct_arg_size(struct linux_binprm *bprm, unsigned long pages)
@@ -279,6 +307,10 @@ static int bprm_mm_init(struct linux_binprm *bprm)
 	err = create_init_stack_vma(bprm->mm, &bprm->vma, &bprm->p);
 	if (err)
 		goto err;
+
+	/* Randomize the strings' offset within their page; keep the top word. */
+	if (bprm_randomize_args(bprm))
+		bprm->p -= get_random_u32_below(PAGE_SIZE - sizeof(void *));
 #endif
 
 	return 0;
-- 
2.47.3


