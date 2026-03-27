Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E27510ED675
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 13:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3DB6B008C; Fri, 27 Mar 2026 09:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B1D6B0098; Fri, 27 Mar 2026 09:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC86B6B0099; Fri, 27 Mar 2026 09:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BB4836B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:24:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 786E31A1045
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:24:04 +0000 (UTC)
X-FDA: 84591911208.17.DD93A47
Received: from forward103d.mail.yandex.net (forward103d.mail.yandex.net [178.154.239.214])
	by imf01.hostedemail.com (Postfix) with ESMTP id 56E2D40014
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:24:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=yandex.ru header.s=mail header.b=O3Jr5Fya;
	spf=pass (imf01.hostedemail.com: domain of dmantipov@yandex.ru designates 178.154.239.214 as permitted sender) smtp.mailfrom=dmantipov@yandex.ru;
	dmarc=pass (policy=none) header.from=yandex.ru
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=yandex.ru header.s=mail header.b=O3Jr5Fya;
	spf=pass (imf01.hostedemail.com: domain of dmantipov@yandex.ru designates 178.154.239.214 as permitted sender) smtp.mailfrom=dmantipov@yandex.ru;
	dmarc=pass (policy=none) header.from=yandex.ru
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774617843; a=rsa-sha256;
	cv=none;
	b=J8A0D8ZrnjhgKotJwIYzsA4kexE1E2PyGyq8broL9juvqnnQuUsN9CRmX+vo+IfOeHUNAm
	h0B70elCME67MrOdZWc/nwf7ui54c3OtzAz6ndYbcma94v7AWLDsB3PcCM4vnMki3NBwQY
	25WVfrmjAC2xpEPaBhzZp85OWP6Cw0M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774617843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0CwSYhkBgGiuGEbyJhnvf326GHQvt0d27IOFTpLoYY8=;
	b=UJ6wPeOZM52bFLTqUePVJa6suG4VLBXuYAkD0Kw9Ci7E/RCQhTAWxCHgfwOV3mzb5zu8R3
	dHBQODsCqSyvB3jApRL61s6RJADyovsL77T5zeUWYhuRJyh+THvWxobYi/kT0d92smzYE9
	41EgIehs/Jvp8KXd7i+BCJK8ArwBq7M=
Received: from mail-nwsmtp-smtp-production-main-57.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-57.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:494f:0:640:ed81:0])
	by forward103d.mail.yandex.net (Yandex) with ESMTPS id 42C99C46FA;
	Fri, 27 Mar 2026 16:24:00 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-57.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id VNWFBvIGsqM0-gCm9Q4UP;
	Fri, 27 Mar 2026 16:23:59 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1774617839; bh=0CwSYhkBgGiuGEbyJhnvf326GHQvt0d27IOFTpLoYY8=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=O3Jr5Fya7RBtj7KPYzeU+KfDKBUx/RBtEHK7WJc+aSGbT0BYh3rbSxhrJMQLE/qH2
	 yUer01GGcSEKeaDZ9qKEiojJkPJQTM2MpnvoADartD9zF3fKgtPaz/TEcXQKDXmG4F
	 NxY/aXtgITNLJKq1BI7k/66go12xIg6y2HOjIunY=
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>
Cc: linux-modules@vger.kernel.org,
	linux-mm@kvack.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [RFC PATCH] modules: extend {kstrdup,kfree}_const() to handle per-module .rodata
Date: Fri, 27 Mar 2026 16:22:47 +0300
Message-ID: <20260327132247.861984-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 56E2D40014
X-Stat-Signature: 61k9zhggquuqaundy6i9n91nm66q95qy
X-Rspam-User: 
X-HE-Tag: 1774617842-895058
X-HE-Meta: U2FsdGVkX1++Veqn7xyU8XtV+lWF6jFNg2QE2IfcW7ezkWe1jZfkFr4EcwR6WQb0GqGwAuEMhR55u6smLo8GPgJf6ndIAmAC0nBNvoGKdhalkNStrz+5RT9yXSsnsOIIrs+trcNhE2NJSi5PyR++TxgknzFfqUg1pL8xNGEKHpPhT9DJRbW3pgUQq7DT7zCvLSHK8zuFcSz/GHYEbZGPuy+v990IPyseetCFgZ+8C5I7RcY41275HK/375JcNjqwvRBwXn5TRncadJxbPQ7hJ8CDuptrUYLx2k55axDKFECoVQ8O/rBVQqAaLOmNwemrAZwg/8cVLAJfwhlRVu/bn3nxnAVs3NHzWIttBbHuQ24cWKtWj4NhrdA99UCoDdUljUHfxNY3Cxk4YxQqOrJMQcj0/n8cam3/Jp6rzzHb0KzzPq8cUeR1NJUaZKlgJLHiiJ/GemBI4YMgRPKAcu+Za+DXtSNRLXg7CSSJxVk5dmjzI7mLyT20ikfrkj3iHgrM5pLaEXsA404BUsrY0gZd3+xIfKIJoQVjvUNMUq1o1jp9yEP5JKTJgBnAE9LM/hlQVE37cmyrMQ1aTBx2LMF/DMxe6jn163+ZBDHriEJmZZhnLO5Q+MbX1h9iKxl0GZd9kkmHi0bGzn845dZ+eraglqO3Cp7xhmip/1ZNV86GJz6zSUR4SkyFHzGnhTgPg6IrC4su1DWLqrSAswnzqC5QKxbacGou9H8HBiT4MtjkkO/eKWbj1mU+uyrt+nkImT9f6fTpK7IzwNy7JMK6qKSAhOaZWmONresfWSYfQQr+1XTqrsLpiGxyvwpQpGwdEZNXq6CIYfi7PG2XqF05/p89Iui69MLKZP0wASMQz0Po0DZPZ/rtThn6FfKdvHQke9KGNWq32LGAa+l6vqC1u3Lgz1otJ8s1P0YJETBHl9DnMwkWs67Qufb2/46MZcKLqPUGuIY+/1PECAS07C2fjmq
 A2I/fAGe
 fQYlcrSGE7GlL2dZB87I92kXYi+PSHbU0wLk1bJKTxIYPfI0RAOx2Taw+lhzAou7tnNSfaiW1Ps79MIwf4Van01xcaxyZ+sngx7j5VYzTb52icfTFus4aYmwO4xbCE+uIVpYjeg144yf7vZXWqvqzqE2rMosb3vntgTtgNmW9qU1CxYn/7hIcqAlycLGYqAFhro/OCyegBSiqKh0XXKYbDhFaLkoZkhwFCmNQp8j9C2GhWS4UGVjk2tV8Ar7NAmsQS2J2xROij21AJmkB9hyLb4DrKYoE6hlZZRyyUtL3LIdfAQZzGHrQeIbqApwm6N40LPakAEJ0GhPfRXzmtc9uKlNQktPuLHB4E7kNgLWrDJFj4voDUDxASZYgqKjTdxFfoGVx2DBDJyVGXx+TnyE9Vj4oLxkAwUqVLjRTJ6gqEk4D8wE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since kernel modules has their own .rodata sections, functions like
'kstrdup_const()' called from the module context are not required to
copy string constants from these sections. Likewise, 'kfree_const()'
in such a context becomes a no-op also because the whole module's
.rodata is freed at module unloading. OTOH this proof-of-concept
implementation introduces substantial overhead due to calls to
'__module_address()' from 'is_module_rodata()', which is much slower
than 'is_kernel_rodata()'. Anyway, comments are highly appreciated.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 include/linux/module.h | 6 ++++++
 kernel/module/main.c   | 9 +++++++++
 mm/util.c              | 7 +++++--
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/include/linux/module.h b/include/linux/module.h
index 14f391b186c6..7edaf2b730ce 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -623,6 +623,7 @@ bool is_module_address(unsigned long addr);
 bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
+bool is_module_rodata(unsigned long addr);
 
 static inline bool within_module_mem_type(unsigned long addr,
 					  const struct module *mod,
@@ -807,6 +808,11 @@ static inline bool is_module_text_address(unsigned long addr)
 	return false;
 }
 
+static inline bool is_module_rodata(unsigned long addr)
+{
+	return false;
+}
+
 static inline bool within_module_core(unsigned long addr,
 				      const struct module *mod)
 {
diff --git a/kernel/module/main.c b/kernel/module/main.c
index c3ce106c70af..5003cacd0786 100644
--- a/kernel/module/main.c
+++ b/kernel/module/main.c
@@ -3858,6 +3858,15 @@ bool is_module_text_address(unsigned long addr)
 	return __module_text_address(addr) != NULL;
 }
 
+bool is_module_rodata(unsigned long addr)
+{
+	struct module *mod;
+
+	guard(rcu)();
+	mod = __module_address(addr);
+	return mod && within_module_mem_type(addr, mod, MOD_RODATA);
+}
+
 void module_for_each_mod(int(*func)(struct module *mod, void *data), void *data)
 {
 	struct module *mod;
diff --git a/mm/util.c b/mm/util.c
index b05ab6f97e11..8dd1f1e95554 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -26,6 +26,7 @@
 #include <linux/compat.h>
 #include <linux/fsnotify.h>
 #include <linux/page_idle.h>
+#include <linux/module.h>
 
 #include <linux/uaccess.h>
 
@@ -42,7 +43,8 @@
  */
 void kfree_const(const void *x)
 {
-	if (!is_kernel_rodata((unsigned long)x))
+	if (!is_kernel_rodata((unsigned long)x) &&
+	    !is_module_rodata((unsigned long)x))
 		kfree(x);
 }
 EXPORT_SYMBOL(kfree_const);
@@ -98,7 +100,8 @@ EXPORT_SYMBOL(kstrdup);
  */
 const char *kstrdup_const(const char *s, gfp_t gfp)
 {
-	if (is_kernel_rodata((unsigned long)s))
+	if (is_kernel_rodata((unsigned long)s) ||
+	    is_module_rodata((unsigned long)s))
 		return s;
 
 	return kstrdup(s, gfp);
-- 
2.53.0


