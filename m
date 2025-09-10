Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA4DCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B1D8E0006; Wed, 10 Sep 2025 16:17:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE29E8E0001; Wed, 10 Sep 2025 16:17:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7F88E0006; Wed, 10 Sep 2025 16:17:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F3058E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:17:35 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 197E684F60
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:17:35 +0000 (UTC)
X-FDA: 83874450870.04.D359079
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6238340006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:17:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757535453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=IV4SklleQQqW3S6pu5lSNKA915ElsXta/7el5h4wIQs=;
	b=hYuDidvRAvC1u6oR4W31PCVC+r1hF/2CUBdEsE55yndW42eG22yEGkfCNJF2totFZp5Gqf
	djhu3tD9W2C3c1u2nNlYWNrYh5WjgC5/F12+F+KTHi2MuTGDshKT3TawfO+Fwr5fUNSMRB
	cUgeDET8kmn4zIS3DQzcQxnue/KAsh8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757535453; a=rsa-sha256;
	cv=none;
	b=h/SueCz4KhgmmgO0YgJX3h96y36XVZrdHN4TMnBWlOvD2VMJrVLGKzPXY+/EUeifW7SWrQ
	naieHSpOC7XT8pdrtZB8sOA/XErBu4CY/fXJ32j79Q7fXldAbb7VkO6WqV0MifvQq6T7hL
	Hqr+MauIMJIDHkDkatBWyeAbL2xQw3c=
Received: from omf05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 172E81401FC;
	Wed, 10 Sep 2025 20:17:32 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf05.hostedemail.com (Postfix) with ESMTPA id 232852000D;
	Wed, 10 Sep 2025 20:17:30 +0000 (UTC)
Date: Wed, 10 Sep 2025 16:18:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linux Trace Kernel <linux-trace-kernel@vger.kernel.org>, Linus Torvalds
 <torvalds@linux-foundation.org>, linux-mm@kvack.org, Kees Cook
 <keescook@chromium.org>, Aleksa Sarai <cyphar@cyphar.com>, Al Viro
 <viro@ZenIV.linux.org.uk>
Subject: [PATCH] uaccess: Comment that copy to/from inatomic requires page
 fault disabled
Message-ID: <20250910161820.247f526a@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX19BBTwwLDsir0hYAEKbj0Aqi5DJnU7TB68=
X-HE-Meta: U2FsdGVkX1+LXnjBkhITVL/OslgiLeLF3o1a0C4PdpHYfRRE10FTK6MKYR3ixYLqwGUxK/bvqCAQl5HzSryYE/oOxu7vIsusicNrcJUGpUK131VIXs8D7QAvmoy283ZtGnIn+/+mtzcPK6Je5EgKeGZfFmo1LcSs6aQOPniQnwD3qK+Yg/MPqE25toAlQWlDFreyedHFx1LLOA/IsDDCmYdOetFOL34AsfIZjOgXaTs5NC9+Nq/P8PwnByessqsRsKPLbFbKSPgoZgKZyA34a7T9jLCpRYOP3IibmStjVINc94sXs9OTJlhxEur0H59G2HcqtZ8ESbYYHayPUXBON2JJlhMcBrJgcvFxNI5eoxX0fvAwjw3KWMDYee3eYjxsLwW9SKlRq2AOHpjH0As1wOpFsF/hppCBzRvHWhxz1Mw=
X-Stat-Signature: rbnzs9f9yx5mabma547rjikgyq1g78x8
X-Rspam-User: 
X-Rspamd-Queue-Id: 6238340006
X-HE-Tag-Orig: 1757535450-343880
X-Rspamd-Server: rspam04
X-HE-Tag: 1757535453-814988
X-HE-Meta: U2FsdGVkX1/2lbeZUrSHi6a9Hu9RegkB7zat4ao+DW5GNNKmyNvbGkt2TrqXtSvV+nauZfIB6IoM81wqvNrRWjOy/F828n97NrPCmBGVkdJf46dNX/MtQhQtdvQPMUHEE5F0crP7qwzhzc29ZZdLc01ZDcD4K9jZYPebE8wQbgFZLRAjj3CcxsBXReRdWZrnj+lshsZZEhbFKIKMWb8ia+q/74mAfaKEL/uApOdZNRI1WlTx3iyNgS0SlP6yIMnXcOnHLz4O6Er7M4jEfuscA9EDewplvb7/iqLeRwesh2+QIHtXjtsOa37DW5jfs02CGwAp/9fnXKbKohzZK4fMFP1w0aMb6lfXjFB1VFl4fu387c/81w+i3IyDgl8LlgMHGKUXwhpvb+kPcRtVPfCb/waLFQNcgOJa2FBhy5lKkmuE/LFTsz5bFxvtHQWb9TEW/Z5GepudZXkzm8W9zyUaxeqETxctIZMZeliwQcshAF6VaMC+DS19yoAx7BH03rsKyy0EjNnrTYOdZi/eFvlX9LAQfuAW3HPiEHmZ65wWEh/4Dr3nikILayYpURIK96HzCpDp8j4zesMtL3/cv+PsArcAXeGpgvbemkn3pX5bxDsZZfy1RHjcaWTcNCP5/wLkKD55FrfTF1UsvBb42AfAOtB2BFaTlWhxvOAwPbeRl/L2EhPB9vzLJ416qxh7Ayv7EEdFVtFG9yaX23cvDmfU6FHjdIo2FI5VKwYp58x9DFhYLUGivOcenKaiwJxrlHcI6Vs9BIxnGenjSdR03+z09Jwm3WL27b9efZ0E1k6mRZTUl0/GO/xNYJQHdpkb5xl+Info+ItAsRMtoZItVyGwC6+lqpUxQwv+epHfQWXuy+Ls0wJ1Avuxv9IMV7mS4Wz9hQlmJwyyXWoJ9T5pPDBkgqOZAWNcC2r+YyZLAnBOXt/RE/YMorcKHDn12jLoVCUa+UeWYQbcyTiNHtnFWFE
 tiKp7EvP
 3Gq+YqdiYwptGJHBaf3WY9zH7/LnFW1PnX/jY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Steven Rostedt <rostedt@goodmis.org>

The functions __copy_from_user_inatomic() and __copy_to_user_inatomic()
both require that either the user space memory is pinned, or that page
faults are disabled when they are called. If page faults are not disabled,
and the memory is not present, the fault handling of reading or writing to
that memory may cause the kernel to schedule. That would be bad in an
atomic context.

Link: https://lore.kernel.org/all/20250819105152.2766363-1-luogengkun@huaweicloud.com/

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/linux/uaccess.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 1beb5b395d81..add99fa9b656 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -86,6 +86,12 @@
  * as usual) and both source and destination can trigger faults.
  */
 
+/*
+ * __copy_from_user_inatomic() is safe to use in an atomic context but
+ * the user space memory must either be pinned in memory, or page faults
+ * must be disabled, otherwise the page fault handling may cause the function
+ * to schedule.
+ */
 static __always_inline __must_check unsigned long
 __copy_from_user_inatomic(void *to, const void __user *from, unsigned long n)
 {
@@ -124,7 +130,8 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
  * Copy data from kernel space to user space.  Caller must check
  * the specified block with access_ok() before calling this function.
  * The caller should also make sure he pins the user space address
- * so that we don't result in page fault and sleep.
+ * or call page_fault_disable() so that we don't result in a page fault
+ * and sleep.
  */
 static __always_inline __must_check unsigned long
 __copy_to_user_inatomic(void __user *to, const void *from, unsigned long n)
-- 
2.50.1


