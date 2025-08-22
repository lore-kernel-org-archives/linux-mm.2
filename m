Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ADA7CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FEB38E0095; Fri, 22 Aug 2025 05:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1B88E008C; Fri, 22 Aug 2025 05:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476418E0095; Fri, 22 Aug 2025 05:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 308258E008C
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:58:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AC7E2C06A0
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:23 +0000 (UTC)
X-FDA: 83803943286.30.B9BDEF7
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8EAAE40007
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:21 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf04.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZDsMiuOA3dT+ZP0vxJtn5aA698LnzwNsTPXPCWK7pa8=;
	b=dVOsa+4JV3vqMb7qghOWudRS3X6f+N9EMk05FkrT54/+4pPLf2KbEfQFIoyzEiC1uRhbzP
	+f/GJ4YbUDwXsOS9SGyk/MDduTushy8oyU2/3BCfcmDeudAJEWrNoaMfqLNMnK7/weafqx
	dr27wgotjC2/1QbE2XJQzQUJ6+QVtps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856701; a=rsa-sha256;
	cv=none;
	b=RvukUJOd0vxjBKMRlsvIB5nOcn1VZZXQSyZZFzDZI2o0P/WqsAegTQ/bP+7ZZ8tqn2bNBw
	yYZi2P4pN29nL4/EX2i31K4I3yEYvWog6C/QxOnw1097mQFxR8ZZDKWGfmt1zA8Zpv13PZ
	fj9JVmtOJOh8fUD0+mCDNdhIjekJmQM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf04.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bGn55hjz9sSS;
	Fri, 22 Aug 2025 11:58:09 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Pu_SUmsG5KVL; Fri, 22 Aug 2025 11:58:09 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bGn4GTMz9sSR;
	Fri, 22 Aug 2025 11:58:09 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 7E0CC8B781;
	Fri, 22 Aug 2025 11:58:09 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id i33fjxtVLFhx; Fri, 22 Aug 2025 11:58:09 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 704358B780;
	Fri, 22 Aug 2025 11:58:08 +0200 (CEST)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Andre Almeida" <andrealmeid@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org
Subject: [PATCH v2 03/10] uaccess: Add masked_user_{read/write}_access_begin
Date: Fri, 22 Aug 2025 11:57:59 +0200
Message-ID: <7b570e237f7099d564d7b1a270169428ac1f3099.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755856678; l=4235; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=dM/STExlfioZ7RWL1LZ1zuqJ7l+Gd1UGLLRM2BZr8VQ=; b=LfW2Zrcf/qOLKMyRJmXFszZyR+auMiNHDPsO2CmZ3LWYtqVMaj5jy30Bs37sk/DpkfpY4ScpY BhH/brYHdWZCciqcb6YZXz9IaYEwPiyBPpDY3g/qom3TrZu+gfvLQVX
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8EAAE40007
X-Stat-Signature: up57hds3ppqy63x4kjmow7cxtaynwemh
X-HE-Tag: 1755856701-502650
X-HE-Meta: U2FsdGVkX1+qkJGh4ffyVFpXfe/aQPYalz5MoeR7o9Y5ADjUF7oaKA2UoLu3Hc+yZnDfTt50o125MlOwoNWbnEWIjY1+MRyyfhin3fvnw8ElADoUkyEhGqnVSaQGOQZDai7UOTSzGT+VR120XmMuKAs4TWMihg6bHc7I81G+HQ67zMYzZ5C+NC/AmkGXbBJWQr+CplMdMcx39wt4hExc+e/K5R0ToDkcrUWrLE+v5NRy1P6PXAOCME7dGZa8WCeJgDIZihnJdI3UWIm2JuhKmhW3zmNbI2Ud82SG0IgxUEnqn8zZgNEKdb5qnzAS6ZEMqmNzmc6y6KwQhwWHGgKmwifxAW8W+Q4V9GVyD0hlfWcCsAvjlDWXv7c3A4H5lbU7eXoXLHl549oLa+zaq8qF6tiQK1//J8+KajP5Sn5M+FKDmVItxhvHWKfcK6hO2vbLy0m4zTnyBi8vEGCkhIgXCI7WTJ3+AL7Y0jqT+BXFNocCKAMwk+H972reffaMWZkEfwf7e0B8dZRoDiBcCz6tKuoN4JGmIyhUAYboH67mMT4e9htCDg7/gBOXQPjU7NzSq+6/pPauruxYuTGjsnBPzxWWTeZbT2yVZHDJRYehX+60zvF54JgVqyxQP26J4Wiidt6biAibH3uWY5MtUBORCE89KZ9p2qyEBLdKkG67Et+F2fDmTHS5kYuCc3vMXml2YMEvWx2ExnKarSmOGT/rq6VbCGMY6gyKr9/yUIJJ5TYF3MBULR14Grs88skrbmoaEkVr8//am+ND8wnuXjPDCOnEskWkH6wasDYsxp+UAuzvo1+ecPy5dE3tlYin1XqVOK9htIdUUDb8xTo7U9rcf+C2bDZfKQDHVbXqkz++L4ZjxKqSGEUl9G7OO13XCcDb4l39gi2Cc8DOjL0cQYeudr6BMdYjyqXhDu/sWGiM/qAb9CMmcVJeaBozTbqyR49s8ebctP1G5DbVn8F723Q
 +H+trtTZ
 9/cniUdsW5W0XA97soy8PA0FGBuGhcvtJgN50vv96TY5YBS5ilIM9ilBMKlZASXF2Vdc4iiR5iVes3cG+XeVbRDkcJleJPSopt6MyHH8I3UrAXpHCnlvCKDguRJdQBfEH1l9Jkiw8LrMYYLnktSFCpV+xgL8YJpVvGreeVzgW/Q5o/jleDWk6/NrhsR6ffP3njllJoZ5ivPe7S6hre1OU3TgtQ7y8rQJmCOVVZw8Mv1gnfeXNZgQJzyjFJ57zsehxbAmfUkM7mYPTb1TN0m0kr9Om9ceAbfGGkWDEQON3vMC6VUEZ/MGLGAPjEcfaPikDoDEEMAqmKPgvzSM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allthough masked_user_access_begin() is to only be used when reading
data from user at the moment, introduce masked_user_read_access_begin()
and masked_user_write_access_begin() in order to match
user_read_access_begin() and user_write_access_begin().

That means masked_user_read_access_begin() is used when user memory is
exclusively read during the window, masked_user_write_access_begin()
is used when user memory is exclusively writen during the window,
masked_user_access_begin() remains and is used when both reads and
writes are performed during the open window. Each of them is expected
to be terminated by the matching user_read_access_end(),
user_write_access_end() and user_access_end().

Have them default to masked_user_access_begin() when they are
not defined.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: Added more explanations in the commit message following comments received.
---
 fs/select.c             | 2 +-
 include/linux/uaccess.h | 7 +++++++
 kernel/futex/futex.h    | 4 ++--
 lib/strncpy_from_user.c | 2 +-
 lib/strnlen_user.c      | 2 +-
 5 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index 082cf60c7e23..36db0359388c 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -777,7 +777,7 @@ static inline int get_sigset_argpack(struct sigset_argpack *to,
 	// the path is hot enough for overhead of copy_from_user() to matter
 	if (from) {
 		if (can_do_masked_user_access())
-			from = masked_user_access_begin(from);
+			from = masked_user_read_access_begin(from);
 		else if (!user_read_access_begin(from, sizeof(*from)))
 			return -EFAULT;
 		unsafe_get_user(to->p, &from->p, Efault);
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 1beb5b395d81..aa48d5415d32 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -41,6 +41,13 @@
  #define mask_user_address(src) (src)
 #endif
 
+#ifndef masked_user_write_access_begin
+#define masked_user_write_access_begin masked_user_access_begin
+#endif
+#ifndef masked_user_read_access_begin
+#define masked_user_read_access_begin masked_user_access_begin
+#endif
+
 /*
  * Architectures should provide two primitives (raw_copy_{to,from}_user())
  * and get rid of their private instances of copy_{to,from}_user() and
diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 2cd57096c38e..a1120a318c18 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -303,7 +303,7 @@ static __always_inline int futex_get_value(u32 *dest, u32 __user *from)
 	u32 val;
 
 	if (can_do_masked_user_access())
-		from = masked_user_access_begin(from);
+		from = masked_user_read_access_begin(from);
 	else if (!user_read_access_begin(from, sizeof(*from)))
 		return -EFAULT;
 	unsafe_get_user(val, from, Efault);
@@ -318,7 +318,7 @@ static __always_inline int futex_get_value(u32 *dest, u32 __user *from)
 static __always_inline int futex_put_value(u32 val, u32 __user *to)
 {
 	if (can_do_masked_user_access())
-		to = masked_user_access_begin(to);
+		to = masked_user_write_access_begin(to);
 	else if (!user_write_access_begin(to, sizeof(*to)))
 		return -EFAULT;
 	unsafe_put_user(val, to, Efault);
diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index 6dc234913dd5..5bb752ff7c61 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -126,7 +126,7 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
 	if (can_do_masked_user_access()) {
 		long retval;
 
-		src = masked_user_access_begin(src);
+		src = masked_user_read_access_begin(src);
 		retval = do_strncpy_from_user(dst, src, count, count);
 		user_read_access_end();
 		return retval;
diff --git a/lib/strnlen_user.c b/lib/strnlen_user.c
index 6e489f9e90f1..4a6574b67f82 100644
--- a/lib/strnlen_user.c
+++ b/lib/strnlen_user.c
@@ -99,7 +99,7 @@ long strnlen_user(const char __user *str, long count)
 	if (can_do_masked_user_access()) {
 		long retval;
 
-		str = masked_user_access_begin(str);
+		str = masked_user_read_access_begin(str);
 		retval = do_strnlen_user(str, count, count);
 		user_read_access_end();
 		return retval;
-- 
2.49.0


