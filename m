Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DF6C10987AB
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 16:41:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 008AE6B012D; Fri, 20 Mar 2026 12:41:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F22C76B012F; Fri, 20 Mar 2026 12:41:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5FAE6B0130; Fri, 20 Mar 2026 12:41:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D56D36B012D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 12:41:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 92D101A0295
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:41:15 +0000 (UTC)
X-FDA: 84567006510.20.00C86A9
Received: from toronto-edge.smtp.mymangomail.com (toronto-edge.smtp.mymangomail.com [209.38.81.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id E66D6140011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 16:41:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=CVlr5fcb;
	spf=pass (imf23.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774024873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zFcjBe+mvrvbkiJzQPLvMjEPcNe5xRrIkckbRoMHOoU=;
	b=SdVvFWk6JVe1517O8qZPfRouHosk1EslIILvDZPV8GEM6ojBG6WEsD1zWwmhgx1KUhKofu
	GLBedor6Bb0oGTw8WJNsEHp2N6FQ1stEQcVdoZgmu9Jg9LzjcZp/5QkaiOD4v8rkD5eg4q
	FqbR5ec7h0HITd/hJW7EVsm2fYsSux4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=CVlr5fcb;
	spf=pass (imf23.hostedemail.com: domain of oskar@gerlicz.space designates 209.38.81.170 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774024873; a=rsa-sha256;
	cv=none;
	b=XVjdCdCzkxmAB0CBE4OtZeEO9yKjv7K8ZImug81DAYX5qhNdi//BvDRturimo0LbHw32qn
	yt7wbRZUFH2JOaeqZQK4hNqS7AN4U5RlpZVy+PdKvwwqMXz08b80JDFBlt4lx24+94f4jy
	m8Pijc/iyvNzLXYVID7tIUq5nekMp8A=
Received: from [127.0.1.1] (localhost [127.0.0.1])
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTP id CA6965D9CF;
	Fri, 20 Mar 2026 12:40:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774024849;
	bh=QWzd64L8DpR90a0dwQiBIkOjZTFKBpBjyJYEA80DZcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVlr5fcb4wlv/TtO3vW3AC/Jm6ICTm/eyKjhDPV/8VMUuIjXTpJsD0mdi8g71aYpf
	 0JIxHH9sE2RXzitN6IGUmCNVCy2ZwMms3/ZFHO0kL/QzBc2i/kETtbp69tnH8JJtOg
	 7T4KVWl6vtg2ax/fKQpnQizf1s2t4Gah5V5DMuq4=
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
X-Mango-Origin: 1
Received: from authenticated-user (smtp.mymangomail.com [205.185.121.143])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits)
 server-digest SHA256)
	(No client certificate requested)
	by hillsboro.smtp.mymangomail.com (Mango Mail) with ESMTPSA id 92A775D9B1;
	Fri, 20 Mar 2026 12:39:37 -0400 (EDT)
From: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Baoquan He <bhe@redhat.com>
Cc: Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
Subject: [PATCH 2/5] kexec: abort liveupdate handover on kernel_kexec() unwind
Date: Fri, 20 Mar 2026 17:37:17 +0100
Message-ID: <20260320163720.100456-2-oskar@gerlicz.space>
In-Reply-To: <20260320163720.100456-1-oskar@gerlicz.space>
References: <20260320163720.100456-1-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E66D6140011
X-Stat-Signature: k8g9o79skocibwkeo4tqq756fwm7yczx
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774024872-745433
X-HE-Meta: U2FsdGVkX1/5EHtszKFVh7NNKy7JtCcc0zOLD/NXNRzSYAUu04g7oJUiKBSid34JqJxPuBsf4HqioltlGzFnuZ8V8M3kjyZuG4GUDtqBkINf0iE5V+uyhE15F9omOhpKxgpK22fnBzAxA5154YM2rl/j5whA7BD3gnBYqElT66bo/gy6IdPa+hkpad5MXUVZjGtN7tgdJihuIOpo6Zdb2/5Djgif001Vf6Gut8ai6NEwELRDZ1ejTNVmQ+/rn+aRRdd7hf06+lamVxhWdWEMti3ZILg1bXfH+gH97NW0Hws9VtOOtmO5NZdPyGyaDnAn4rf30zUTTu8gslKwe9hUM/m4vfUmkCL/no2ov2urt0dQ6l8/YZtr3c1n6Du6CyA4290Qvn5MFxVSNWOWAHdu5Rp+dD9kGObAH9CFCsuk5dBjv0jOsTraVemR2VHNo+wbG8kgaUeZihDzrZfhv44C6atYwobkicSxhHbnUBvgD9VR0bmNV5RbpUCj9BldpmSiPqMefdrStScdWv9p6U5KNfk1UnNo3OdBpFd0KBBQeg5NR5NRAA42uX1EIp9S9LXIpYYmhSTxdogglqOyAq4pjIcdnfywWWKSTgKUkerxO+n/oBalh+Z2fL45AdqLCqkS3mAUNErn6mBdeXf0G8MyhNJnX3eblLCCyUj32+G7MxPEForhk1utGcA0DvDxuDwcc3j3Fl0Is/knit4MtnvqKyhlj6Th3jNiC9d0wSYRL+UNrB8Vy7dB4xoQPeugdk2Zo8K6tNVLpxTOvSZUZVOjNuAmlMh9A6b6QYbPKWXtuvSCFui1EGXdLN5WqZF94G74r05C+G8lCOqtOlR6F20uHuSNuhm8cKH+qR1Zhr+2oBEo7rpA9rk3jxMwmarmdkyk2EDg7iWWv9dzq5g2BKV9lB4NdSa2Wy63zpaRwWxZvhGvCJGh6H3hDVFEzrN0vcE4lpLg1hUAoA2Tx/Ewpj/
 T10Y47oz
 Z9IaHIE45O4AzhnrcchyTtBXT/QdbpsUsj8Y0zWqF0YXyKmncpNtHx1YojvohlDF2g8rOpsnd1u06NdzkFAx2FzgxD5kPYsmVEmryqiJOtGeDue20tqFKLrPRstPCXPnBAVGh1wmXgch7qFrEtGPUg23xNTAf63RYbK4GkTT0aZoj9bz9dXHJV8ThifyjLAOAfpNXlDdqdD51qxau1yDppEU4w2t8hFDvcAt4lFibj9tDyflSlxpj/7sdW0RFF+WUFodg+8SJGxrsdCj58tfkUEloWXok5dHEJ7pAjX80fZBC5clOaGqGOieO8MuckqbdiJGhvWw1mw2gGbmUSNy4wDFstdNVUTF/uZ9P4Gh99J7OxF41Sd/Z1bEAXfXWUmQBfZn3QMS7WMi8tausIfh7xjxpZm7A+mLHjSO6NRG0XVstNdn/6XcAhcWKq26RMUaxW8/SoCOo7dXhAz5+wsFeAWMCR5y0pJ3H6YW/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once outgoing sessions are blocked during reboot, every failure path
after liveupdate_reboot() must release that state again. Today
kernel_kexec() sets liveupdate_prepared only after
liveupdate_reboot() returns successfully, so a partial failure inside
liveupdate_reboot() skips the abort path entirely. The
kho_finalize() failure path also leaves the LUO session state frozen.

This is dangerous because a failed kexec attempt can leave userspace
with outgoing sessions stuck in reboot state, blocking release and
preserve paths until the next reboot.

Export a liveupdate_reboot_abort() helper, call it from the
kho_finalize() error path, and mark liveupdate as prepared before
entering liveupdate_reboot(). That makes every failed handover attempt
unwind the session state and wake blocked waiters.

Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
---
 include/linux/liveupdate.h       |  5 +++++
 kernel/kexec_core.c              |  4 ++++
 kernel/liveupdate/luo_core.c     | 11 ++++++++++-
 kernel/liveupdate/luo_internal.h |  1 +
 kernel/liveupdate/luo_session.c  | 23 +++++++++++++++++++++++
 5 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index dd11fdc76a5f..d93b043a0421 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -226,6 +226,7 @@ bool liveupdate_enabled(void);
 
 /* Called during kexec to tell LUO that entered into reboot */
 int liveupdate_reboot(void);
+void liveupdate_reboot_abort(void);
 
 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh);
 int liveupdate_unregister_file_handler(struct liveupdate_file_handler *fh);
@@ -250,6 +251,10 @@ static inline int liveupdate_reboot(void)
 	return 0;
 }
 
+static inline void liveupdate_reboot_abort(void)
+{
+}
+
 static inline int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
 {
 	return -EOPNOTSUPP;
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 2fea396d29b9..492c17f7e96f 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1139,6 +1139,7 @@ bool kexec_load_permitted(int kexec_image_type)
 int kernel_kexec(void)
 {
 	int error = 0;
+	bool liveupdate_prepared = false;
 
 	if (!kexec_trylock())
 		return -EBUSY;
@@ -1147,6 +1148,7 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+	liveupdate_prepared = true;
 	error = liveupdate_reboot();
 	if (error)
 		goto Unlock;
@@ -1231,6 +1233,8 @@ int kernel_kexec(void)
 #endif
 
  Unlock:
+	if (error && liveupdate_prepared)
+		liveupdate_reboot_abort();
 	kexec_unlock();
 	return error;
 }
diff --git a/kernel/liveupdate/luo_core.c b/kernel/liveupdate/luo_core.c
index dda7bb57d421..95a0b81ce60d 100644
--- a/kernel/liveupdate/luo_core.c
+++ b/kernel/liveupdate/luo_core.c
@@ -233,8 +233,9 @@ int liveupdate_reboot(void)
 	err = kho_finalize();
 	if (err) {
 		pr_err("kho_finalize failed %d\n", err);
+		liveupdate_reboot_abort();
 		/*
-		 * kho_finalize() may return libfdt errors, to aboid passing to
+		 * kho_finalize() may return libfdt errors, to avoid passing to
 		 * userspace unknown errors, change this to EAGAIN.
 		 */
 		err = -EAGAIN;
@@ -243,6 +244,14 @@ int liveupdate_reboot(void)
 	return err;
 }
 
+void liveupdate_reboot_abort(void)
+{
+	if (!liveupdate_enabled())
+		return;
+
+	luo_session_abort_reboot();
+}
+
 /**
  * liveupdate_enabled - Check if the live update feature is enabled.
  *
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 8083d8739b09..ad09ea756156 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -82,6 +82,7 @@ int luo_session_retrieve(const char *name, struct file **filep);
 int __init luo_session_setup_outgoing(void *fdt);
 int __init luo_session_setup_incoming(void *fdt);
 int luo_session_serialize(void);
+void luo_session_abort_reboot(void);
 int luo_session_deserialize(void);
 bool luo_session_quiesce(void);
 void luo_session_resume(void);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index ee5ea2a8ed3f..39215e5eda7a 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -649,6 +649,29 @@ int luo_session_serialize(void)
 	return err;
 }
 
+void luo_session_abort_reboot(void)
+{
+	struct luo_session_header *sh = &luo_session_global.outgoing;
+	struct luo_session *session;
+	int i = 0;
+
+	guard(rwsem_write)(&sh->rwsem);
+	if (!READ_ONCE(sh->rebooting))
+		return;
+
+	list_for_each_entry(session, &sh->list, list) {
+		if (i >= sh->header_ser->count)
+			break;
+
+		luo_session_unfreeze_one(session, &sh->ser[i]);
+		memset(&sh->ser[i], 0, sizeof(sh->ser[i]));
+		i++;
+	}
+
+	sh->header_ser->count = 0;
+	luo_session_reboot_done(sh);
+}
+
 /**
  * luo_session_quiesce - Ensure no active sessions exist and lock session lists.
  *
-- 
2.53.0


