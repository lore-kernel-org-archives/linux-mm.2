Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 264E2CD6E44
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 09:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A4566B00A2; Thu, 28 May 2026 05:54:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554BC6B00A4; Thu, 28 May 2026 05:54:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 491C36B00A5; Thu, 28 May 2026 05:54:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3872B6B00A2
	for <linux-mm@kvack.org>; Thu, 28 May 2026 05:54:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06252120775
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:54:36 +0000 (UTC)
X-FDA: 84816368952.20.793F7B9
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf20.hostedemail.com (Postfix) with ESMTP id 27FDC1C0007
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:54:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b="ibP9/gpb";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf20.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779962074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MC4dHb80t6/BIqcUh3zzA0OufX3r53dp1BU6A+dxByg=;
	b=d6MwoBlm8Kgmp1B4SSdAmjDiS4aW/0KaemZUckMb9wDoknTq4b0OG+BWy9J9DtO40YLJVt
	EGqCjEaF8rWqg2JZGayP+KcFbcijsh50clHIyTmCXcb60XiU3Q3ipzxyPcMp8Pf6sknHbC
	02NILT/5qNlK6WOUSzYo1GKV61IdgPo=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b="ibP9/gpb";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf20.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779962074; a=rsa-sha256;
	cv=pass;
	b=8qYTmQIAENYZILJthevwppl5dWLyAVcMrP7yd5l/Cnmo2EL++M0DJHYGPxIDz9uMriQi0u
	/iJuIqm9WwMpnegYBnymN3gNpEx4X/Xa8rO/57gBm+k8btw79IFBW1yLQ1IY/1ZjdFxpKi
	72ad1N4/jJAaRbJPDk4/d6Iklqds0CE=
ARC-Seal: i=1; a=rsa-sha256; t=1779962002; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=BjY+rrmWLeXJJjQO8PJHtywe0UJQ7E2pjwCx5wcNHnA4egGvITx/6i2EtDKw/2QqNijDBOqEimBC9n8mh1z5puanqcp1ql2SmS9gCg70wze3E/yaOE/v+ub7FWNQ0WbpSi79NU88eYotN8TMyyRvKJAxy3KuyMrG9rZROYEWuH8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1779962002; h=Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=MC4dHb80t6/BIqcUh3zzA0OufX3r53dp1BU6A+dxByg=; 
	b=DWGfOBX55kPaMTFI0EZNeE/PGV94CywIhXgl+CCRnmAWmdgsCpA+SHASORGhm79ZvFWpdOf9NuVZOIUf9dkHGoN6ZrYu0cc035jAag50/MWLMdB2yg13Rf3ey+sXW7HzVr87mVyVmb8hNeEtVnClLGL+QfoVZ5Mf20d21GDY/EE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1779962002;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=From:From:To:To:Cc:Cc:Subject:Subject:Date:Date:Message-ID:In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=MC4dHb80t6/BIqcUh3zzA0OufX3r53dp1BU6A+dxByg=;
	b=ibP9/gpbHz+8ZyfY8Yxk0qP/vQNgBX0rzt1bGyckd4RNeJkQqw5x+v2ABym4GyET
	SZA91nuGCe9SpX2YTxy/S6LA8HV00AM10poCIJaWS8/YHddtqYafv4m2Lfng6Nv29FI
	XdRjwESCU5nRsJaVHk7lPHNvHbMljrXf7abRlHGo=
Received: by mx.zohomail.com with SMTPS id 1779961999561196.25957869706974;
	Thu, 28 May 2026 02:53:19 -0700 (PDT)
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
Subject: [RFC PATCH v1 03/13] file: expose helpers for in-kernel fd actions
Date: Thu, 28 May 2026 17:52:24 +0800
Message-ID: <20260528095235.2491226-4-me@linux.beauty>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260528095235.2491226-1-me@linux.beauty>
References: <20260528095235.2491226-1-me@linux.beauty>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Stat-Signature: zn4dbuuei8hueh77784ideb9b1kmyeht
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27FDC1C0007
X-Rspam-User: 
X-HE-Tag: 1779962073-771762
X-HE-Meta: U2FsdGVkX19kP4HIxBIpReaZtKs4fML4kqkxos66kedkTC6sFjrfgEreAVzgMpfz9iKTpuuaRyofZyw0vxOtGZdPXwTFWSN/01fPsYhxAuQt2D85Ricprp4thP8+uirMMLHyuI10HMBiRAmz9qkgl6KeVSMMbNKrXpZKYIYZTlwouVZbZIzdKs9Y+yUALsbDexbMR3V6VUd7mazjNI8bfF7Y3iAyYdINmsf4sRDYdg9zJ0QynzoG7CrHqwQZIQ68k1/TfWJzM1X61dLkqoWLQTJkq0m8bEe/UKmuk0U58fAK+mZVDw2q3JdTbGpeJhGkIcbLVcL/anJng9rM6f8nKTEMXLq1xxNCZaSNMvWb68eXHBUjpFYCjDN5u+fBDlGIYpT7zYGRJCI3eHUAgG5eSqEu6PCSllFpoYuKzX/8Zx/yPe1o1LT9ojOSfi13zfK3WK8ONSMQ/j9wn7mmEiZ7XLA3L62SMNJjtFqDYq38cigzzReZg1FNtoKG1xVVV/dIsEycJL1HH7hrQKYYZU6drx8avt6yVN4N0pqvct4x0R0tjq15JFTUV5QkXn+3tE5pKVF37w6xFq8uhvzimGO4qigsi3pv1lu2Gy5t7miQMip7fS9apm1466ILBI/HTEXgra0F7JxtgRomA1xGJ3JkXWaZs3dmONz4hOJ5s83Nldw6nFh1Xl5Lp94YEoNtHh6BN52VVjWvQ/R1DmOgANM8u/VYy90SLUQFNDxFm0n7PUduDU7dm8G5L6ST5ikV6IR0gsCZNxF0lgtxePyjZeOznQu8Pu57vbxVGg/+tyN7XdBa/MTCOldpkexlsKqjiksN4H9RJTqwsDIhrh76yRrF80fLsvnB8mUa6Cw1qOAU9nVd7KiDN5HmQ9HRV40oV5i0oAPeHkuqCNxxL7IhySc4tUszfJaJ3v+WIgkSCOK/S3Ft4Y1dyPKc9ezaOQ6OIGwnY+u4eJODJn7Iu9PNbzz
 SnjvCxbE
 lnjGZq50azYbHaBKlld4rTwxIf+C8utGkQ7oZTBLSLEpP6J27oeM9Xd2bOQ7omEzWhGglgby9K23w4ACetR/BViJkmaTzLC4esW676Fk+6hHYtvVZXbSykFLhSRk4tb9LRnHNFgi37clwP3m6bBoWob+EasbokRa4igHe3xs++YnOw74U0lfxHBlRc6VxlWrH1ydnlP0nb2bvhY7jwXnzuYTil/1Hx+OtenPffxhwiwxU8yNy1ubrT2/J2glXCsB2dPp4Ba1hSH6WthZ5LqseZ6saOuEvy3IlFNjl4sHIYOWL8ZfDGzksbO2sGxmDFd78gs6HdN0+Z+sSmz5FgGZO9Bcv9I9WoS8zbiOUtDthG5en6of7Wdu+sJ3SI1BheLrbZHzl5v4yOcIRTAlhDC0qh2DqUWJv2jE8tSgdZ4HMxE8kEoQyiwJg0xfZ4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split do_close_range() from the close_range syscall wrapper and make
ksys_dup3() available to in-kernel callers. Later spawn-template fd
actions use these helpers instead of duplicating close and dup logic.

Signed-off-by: Li Chen <me@linux.beauty>
---
 fs/file.c               | 11 ++++++++---
 include/linux/fdtable.h |  2 ++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index e5c75b22e0c7c..a9f4b4e2dcd45 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -815,8 +815,7 @@ static inline void __range_close(struct files_struct *files, unsigned int fd,
  * from @fd up to and including @max_fd are closed.
  * Currently, errors to close a given file descriptor are ignored.
  */
-SYSCALL_DEFINE3(close_range, unsigned int, fd, unsigned int, max_fd,
-		unsigned int, flags)
+int do_close_range(unsigned int fd, unsigned int max_fd, unsigned int flags)
 {
 	struct task_struct *me = current;
 	struct files_struct *cur_fds = me->files, *fds = NULL;
@@ -867,6 +866,12 @@ SYSCALL_DEFINE3(close_range, unsigned int, fd, unsigned int, max_fd,
 	return 0;
 }
 
+SYSCALL_DEFINE3(close_range, unsigned int, fd, unsigned int, max_fd,
+		unsigned int, flags)
+{
+	return do_close_range(fd, max_fd, flags);
+}
+
 /**
  * file_close_fd - return file associated with fd
  * @fd: file descriptor to retrieve file for
@@ -1421,7 +1426,7 @@ int receive_fd_replace(int new_fd, struct file *file, unsigned int o_flags)
 	return new_fd;
 }
 
-static int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
+int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags)
 {
 	int err = -EBADF;
 	struct file *file;
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index c45306a9f0072..7f852fcc082a4 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -112,6 +112,8 @@ int iterate_fd(struct files_struct *, unsigned,
 
 extern int close_fd(unsigned int fd);
 extern struct file *file_close_fd(unsigned int fd);
+int do_close_range(unsigned int fd, unsigned int max_fd, unsigned int flags);
+int ksys_dup3(unsigned int oldfd, unsigned int newfd, int flags);
 
 extern struct kmem_cache *files_cachep;
 
-- 
2.52.0


