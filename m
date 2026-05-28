Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5A8CCD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F19256B0099; Thu, 28 May 2026 05:53:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEFD76B009B; Thu, 28 May 2026 05:53:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2D416B009D; Thu, 28 May 2026 05:53:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D20906B0099
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:53:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 96E9940567
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:46 +0000 (UTC)
X-FDA: 84816366852.25.186E27A
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf29.hostedemail.com (Postfix) with ESMTP id BB17812000C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:53:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=sIdbe8n9;
	spf=pass (imf29.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TW9xzJaDheLzGIs2ITQXktnE3vsoHg7TqlJgpHRDctk=;
	b=n2ml4A4+BRoz6Ka5Wapxyj0jTv49MBTOHbs2AtCKCpGWJFxFpgfCpq3h9NMTF97tPs0nXd
	vOira5+kvyUnn9EoNrpwvgnirWXuBaqIWnIkInEP32Ouq2e8O1l1oQBLJUcx4KZ/CghR/S
	A1v+Ko3+SJTga86OzJuKocyABGOGtYw=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=sIdbe8n9;
	spf=pass (imf29.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779962024; a=rsa-sha256;
	cv=pass;
	b=x8FQ8ankcvMoLLeXWLPfXLgfk9ScoboEM875m9uFXO7LqTrK8H8xeYFcQ70QZrZOm0qcfP
	6XnCnBTLAXesGj4vjHtR8bXf5soB7lit+4odN+yh7Ez7xy1GkMp7cBo3l/O00H7nBweHmC
	mJOYEQmv6pU4xlTcMGlYijmRyMQy6fU=
ARC-Seal: i=1; a=rsa-sha256; t=1779961986; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=X7dnCemyRqEyut9V0SvVWbBJ81qtmnAvbGRlrccs1zrEKYNR8zMqZkq5SW8+5RzWC11E8wC4sZiczegs1Fas45T8ZhWzAjaGr3TvcGTGjvaMOtFwP2kUb+1F7sJK1gRm0iPRq80xbxUVeM1icNvoozlNjNl4qLYSHZUPx0ArOw8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779961986; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=TW9xzJaDheLzGIs2ITQXktnE3vsoHg7TqlJgpHRDctk=; 
	b=ezVqXRV9miOfrjvwjSocUZyJf7ailaKqN+vVFlYzR/LoY1z7uDyNUwlRaK1Yr+XHjGxTDdFDKLmzuoxi8Jy4mp9jEByQP7kLMbnPlWaxgqAFxTWMzd/PUp/rGedmQoYbWUmX9YAoEvfwwvgmZ2Q0Z+VpiAno2m8ySfrPePBNY58=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779961986;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=TW9xzJaDheLzGIs2ITQXktnE3vsoHg7TqlJgpHRDctk=;
	b=sIdbe8n96YbY8VT5gwJ3g34/YwKwOlA+a+er8pX2jqmL1D6m+0PNAASmIKC2OVBe
	zmwW8CsIeGTvHbiPGhNvxdMby31wyE2juw4jNWa12UsRCrdHzolJfQcCCcI2jOniGy6
	oi/6XcU1WwLsWQn/y7xrIXUj9C5/43otDghx22Ek=
Received: by mx.zohomail.com with SMTPS id 1779961982944561.1060190300934;
	Thu, 28 May 2026 02:53:02 -0700 (PDT)
From: Li Chen <me@linux.beauty>
To: Christian Brauner <brauner@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
	linux-api@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	x86@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Li Chen <me@linux.beauty>
Subject: [RFC PATCH v1 01/13] exec: factor argument setup out of do_execveat_common()
Date: Thu, 28 May 2026 17:52:22 +0800
Message-ID: <20260528095235.2491226-2-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BB17812000C
X-Stat-Signature: kmcozh3w4gzhreis781yq8mnjmq78pj5
X-HE-Tag: 1779962024-20618
X-HE-Meta: U2FsdGVkX1+6fKObVQ/JJd5NLtQRQ0UdeMC9x659Wlg6z0Tz2PD6+8Y635u4gmIJVp20GZ2SYsfkaZJNXzYn+McNdRwrIKbNuwZn3wSzdNdfacPWOpFJ8hxQjHzSjhMNZTbC2Uq1J53YojMBQYHzwdU02V8hIXG8AG98mp2nnf8Hzi5lGA69klykr1xHVCkOeS/G1tnA8Oyad5CzYdwnc4bmavYSzNPjunBUzInMEpn0Ibhyd9YE5SJHEz8oiDqly590DEA+1fE4QJgMuRcFtjmXyUmzz9LGiToKQXG/utnN0eysVh2mGA66bWqltGCk2RVeAt71Vny/x2RaSP7AwGsLvjbFlOSE76/G0Rd6NdXX8ox1SZasjQVVpJ8TcDqor0ZKpHd9nxu1pYDcrhMXdqY/1utYFD/29brNER0c05gAYQ4JtDgs6D8FP0iayNPxKVvn5QZvWn2roXF1qTghwU3MuO1KlQ6OVQFzw5QAza6lEdSWlEHOJ4N44CmWZnE7nJScAuzcy935/hHwXbmpt665kb3eNjo/WhRjJVcn0VK3Q9Ke7ylzLsKGeDtNJpWyDDexL/s3Y7xqQdMUnajNoBkz3RlijFD477SD6kAQubobUawH6q5CdSJ4aMnMtpe8B5BaW4/ZTpFzr3MMoAldSIlMB3mbAU19+zZbtdO8csgljbqaiflWz2CF2qJioXnoSQC5s36z4etxG9+fyvncbaiTilgNoAUhLwWbhF19u4liCuyH9Dj5epPfWSU1ibe/WD2SUqJWr0A+lNAS604p+AtJsg4v5oZsF8qaVESZ73Qs6phXORW9GaTQtVRAdPNVmA0wTC9EYOapA6qR7qJAiEZ/kPlNRRUuxdnoV75dpnEqQ+P7EujWEYwLiLViaj4UZantKSJhJZ8YT/2AToWUsOxghzhAzwnXVmZKq0ODBIhJxekIqufhNf+J6cc019Z1WiD8TNmJtfnTmoMWMSJ
 rIFBE9wg
 JQc/M1Xmzv8Xc3fyfFZ++UXgpqJUN4XirFyfgUbvP2ZdF+RDGc6Ddjb/TFOlCLJF/ut9z5R2VU9nopIF4gW2iYMubawfN9GhIfaie0nX4gbtupGrl7JYivyRDchmu1EPfu65s5WXYhCTEiQ+myOLq8gT29GmR4GGp1iqNaTT0iKSw0DxgosC+XNbEA2c5azdoyn/WFn2mc8mJ8lzpanjuqfkLGhtGm3E+M6NaJQcp9db998j5lWvt8XkoqhT+4J57MiEthMY2aZknaioV1BNh9VCC0WDEkhIALBs5OcEgvizJ473cz+gbrM9kXmEjpQnnNprhzpaAogH7yCT5mgNRxIw9+PkqhdqZ3M5V3F1Q0PnTKIzFkVqwicpDUsNiEn9GcC22fQ7T9f17EtYp1v1QFqz4gSp08p0UBx1nCEg2db1TXFiVSMPZu8ErO/TdHidMMckpWpMRvimSRPdhBK0mksRLqC/WwgipZBSIIPWWgeBldvE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the common userspace argv and envp counting and stack setup code
into do_execveat_common_bprm(). Keep do_execveat_common() responsible
for the existing RLIMIT_NPROC check, bprm allocation, and error path.
This is a mechanical refactor for later opened-file exec users. It
does not change execve or execveat behavior.

Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/exec.c | 53 +++++++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 22 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 2889b7cf808d7..53f7b18d2b1ea 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1775,31 +1775,12 @@ static int bprm_execve(struct linux_binprm *bprm)
 	return retval;
 }
 
-static int do_execveat_common(int fd, struct filename *filename,
-			      struct user_arg_ptr argv,
-			      struct user_arg_ptr envp,
-			      int flags)
+static int do_execveat_common_bprm(struct linux_binprm *bprm,
+				   struct user_arg_ptr argv,
+				   struct user_arg_ptr envp)
 {
 	int retval;
 
-	/*
-	 * We move the actual failure in case of RLIMIT_NPROC excess from
-	 * set*uid() to execve() because too many poorly written programs
-	 * don't check setuid() return code.  Here we additionally recheck
-	 * whether NPROC limit is still exceeded.
-	 */
-	if ((current->flags & PF_NPROC_EXCEEDED) &&
-	    is_rlimit_overlimit(current_ucounts(), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)))
-		return -EAGAIN;
-
-	/* We're below the limit (still or again), so we don't want to make
-	 * further execve() calls fail. */
-	current->flags &= ~PF_NPROC_EXCEEDED;
-
-	CLASS(bprm, bprm)(fd, filename, flags);
-	if (IS_ERR(bprm))
-		return PTR_ERR(bprm);
-
 	retval = count(argv, MAX_ARG_STRINGS);
 	if (retval < 0)
 		return retval;
@@ -1846,6 +1827,34 @@ static int do_execveat_common(int fd, struct filename *filename,
 	return bprm_execve(bprm);
 }
 
+static int do_execveat_common(int fd, struct filename *filename,
+			      struct user_arg_ptr argv,
+			      struct user_arg_ptr envp,
+			      int flags)
+{
+	/*
+	 * We move the actual failure in case of RLIMIT_NPROC excess from
+	 * set*uid() to execve() because too many poorly written programs
+	 * don't check setuid() return code.  Here we additionally recheck
+	 * whether NPROC limit is still exceeded.
+	 */
+	if ((current->flags & PF_NPROC_EXCEEDED) &&
+	    is_rlimit_overlimit(current_ucounts(), UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)))
+		return -EAGAIN;
+
+	/*
+	 * We're below the limit (still or again), so we don't want to make
+	 * further execve() calls fail.
+	 */
+	current->flags &= ~PF_NPROC_EXCEEDED;
+
+	CLASS(bprm, bprm)(fd, filename, flags);
+	if (IS_ERR(bprm))
+		return PTR_ERR(bprm);
+
+	return do_execveat_common_bprm(bprm, argv, envp);
+}
+
 int kernel_execve(const char *kernel_filename,
 		  const char *const *argv, const char *const *envp)
 {
-- 
2.52.0


