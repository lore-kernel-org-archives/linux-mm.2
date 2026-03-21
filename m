Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 706361094478
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 14:40:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 722886B00BD; Sat, 21 Mar 2026 10:40:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FA406B00BF; Sat, 21 Mar 2026 10:40:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6375B6B00C0; Sat, 21 Mar 2026 10:40:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 526306B00BD
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 10:40:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F219913B2BE
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:40:04 +0000 (UTC)
X-FDA: 84570329928.13.1375C1D
Received: from hillsboro-edge.smtp.mymangomail.com (hillsboro-edge.smtp.mymangomail.com [5.78.130.219])
	by imf24.hostedemail.com (Postfix) with ESMTP id C5716180005
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 14:40:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=JVqdmvMK;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space;
	spf=pass (imf24.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774104003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRI3gi1rj7sgjUnDtTTIzUk4ldjLipnVZsAhyw+Xi5g=;
	b=SMMaaqj9qwabRVI0+d0AQeh6D84xohIR8BeGxUBV+t0UOMYm3AS3zG/tGI2PZKJbekZDCs
	gk8vyXvzqn5VE7whJsl0imBUTzta4dGTETT8ZtY1Q3PkMWUdXZtsfedjecPUJ/riwl/KkO
	NS+8Siom4nDs+7P62lRj0lxxM7p5eiQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774104003; a=rsa-sha256;
	cv=none;
	b=i5oWvQ4gXFzrFHo8S6pU0e1BsZr8ebIk3b1gbBpsj9AdwARYbJcBPc0VbJwTry7uLWnqsV
	etK+/E+MC1vb6cm/Db7tekonnju3AOtf84XqJt6rqk7KnknDyxZmEARXqNYSpOt6mXYiBU
	yF+kl0t/wYd9gU28I+aHkg/T1c5JEHA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=JVqdmvMK;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space;
	spf=pass (imf24.hostedemail.com: domain of oskar@gerlicz.space designates 5.78.130.219 as permitted sender) smtp.mailfrom=oskar@gerlicz.space
Received: from smtp.mymangomail.com (localhost [127.0.0.1])
	by smtp.mymangomail.com (Mango Mail) with ESMTP id 38265408C6;
	Sat, 21 Mar 2026 10:39:37 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774103977;
	bh=jz9Jb4ua+BZoDIIioX5BJmmKHIi5gc9v+wumLKcLorw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JVqdmvMKUvq7LkIocLlE+laSboKDD8eUR7gtgbTJNfrEUqkWY7oww1mbKyjxe15ZH
	 +B46IAuq0t89QKyh2cxDSV/TKkLdndJ0H2bh7Y4CajAdagVA5N9j1wwXjFrbgDafcT
	 jExo16mpKfZI0hj7IJrVuaBXiN3EI6DRSKsOOehY=
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
	by smtp.mymangomail.com (Mango Mail) with ESMTPSA id 2255641648;
	Sat, 21 Mar 2026 10:38:15 -0400 (EDT)
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
Subject: [PATCH v3 2/5] kexec: abort liveupdate handover on kernel_kexec()
 unwind
Date: Sat, 21 Mar 2026 15:36:39 +0100
Message-ID: <20260321143642.166313-2-oskar@gerlicz.space>
In-Reply-To: <20260321143642.166313-1-oskar@gerlicz.space>
References: <20260321143642.166313-1-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C5716180005
X-Stat-Signature: 1b49t3q1d8de7d7ty7jwrjubgyju9gss
X-Rspam-User: 
X-HE-Tag: 1774104002-496313
X-HE-Meta: U2FsdGVkX197CgH0r5yaaQ89vQbItRmbuRz1JgwtTsQjEMWtbDeINS4NZH+DUwvZvlWLCSSR4bN92Eep2t0VEowKyIuvGd8vbhb3plYOqAr0Ho83kRQZCH5YmDt2kJBaJcKcD5D5Jf82rdClAEIdzo8B3unYLjVkaV6AEaAa12D+gXoy03fxRL9iK8cVf29QKAcJbMGNKizMqTcQyyF5It31DOssZjDGPG2QGx4eFfpv2k+4qaZjT6lfIG2tcrHhEU2ZYSvYgtV3n+6YeESoV/HQPmxFsF3YgOxC2Fds+TtR0JKOAs1UpJ9kdLk8ED+41tZ/kys9MDTaUo6qCgVGxeZhG0g46ztBhXqnjPcgiHtoXLMj9/XDtYzee2V3awmpF0089AyNowG0hFZVoz5SEbRuMKkuinO3kvtwCUw1lSDVjkXz7mTQvo6aj4vp7qLOdYwM61+k+gsHaUBc4nbwhQA3YyHWrSrZdL5LHV0r8+jTwCVqwIabG3scUHmcwFAHpWYR+mdlptQIAyMs1AGn8abQr7sFop8X+fkbDEBxUiGxUWbeIB1rTDCxxZUCju3okc4PFm52jXG7vhDfhFxmOFkRpBjxEqBq0/7uxCGbn/UNbGwqtcLYX8fLukWFy5eMLnoZscFHKB0H8ZxXkx6/Tilea3byganQ0TkXutXlSX5jMo5jLwJ8P3lFe7WTX5xgYzZ701nDBBtFBYZfVgudsIBPgFxMvTjIqIFxNHQRDmDvE5SxqICBsSH3WuJ6FtmH7Iq1EuYH7BRIrNoOXSfVITFAvFLzfEHJCN46yyAaUg5UUI883pmo3nV+ewhWTGNN+UoP/Bqx1fFfcJadToaySl5X10oZD9a1thgCGlViWvrbC+lkI5HmPT3ZVvPCCXZ9++H45kOUXLCCSDpHAE4h/npUlQVFARTV/uhJfh8lpD1L0kL8wmcF8VJqBLGY/HWeqEZADPOlIRulwpB6HFw
 R3Zh6B6L
 kwGzjVVyPR5EcydQag2f6+BpxahUKvg4rkNpgRj5D37ayR3xz+mhqZfsIO2/qDJ/eqjv4tOVSiDCvVW953ZbNx1UmvgOZqiaAzfTHyjexIX+7EW7dEzDQ8X2gc9FjudW0ba35ZnlRpLhK/fX/UwX48XI60ylM/JATwwOZGi0h0pYY8ZZpOU3KP/bS2Fp6PT1JklIr9zAI1qud94qIk4kzGtYutxupejsNLGtFSr9k68sYc7PAqA7/fwcufnTsNiEUX1oWLxj2uSvN9F/sXIZkeGrEL3uBisDT96XaSinvDSH0ykVr8fhIeT9K++/85Ij0mUfIUOix6UjIl1GPiq5gGSQyRNMsl7wJd9Z2hTLfNtuabOfRPSkoTS2Efsq9m9hnYceHaNXKY5fODgL/uXFtzqPFbCX6q9E4uLkLl1qKRB4vaNUQ6agGrVB4plcF1fiah9obIs+IJ4aoPASvjWJPQaVOKayrtl/aNvbB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

liveupdate_reboot() can freeze outgoing session state before the kexec
transition completes. v2 only unwound that state when kernel_kexec()
returned a non-zero error, which misses the preserve_context path where
machine_kexec() can return to the old kernel with error == 0.

If that return path skips the abort, outgoing sessions remain stuck in
the reboot state and later user space operations cannot make progress.

Treat every return to the original kernel after a prepared liveupdate
handover as an unwind point and call liveupdate_reboot_abort() there as
well.

Fixes: 8b32d3ced269 ("kexec: abort liveupdate handover on kernel_kexec() unwind")
Signed-off-by: Oskar Gerlicz Kowalczuk <oskar@gerlicz.space>
---
 include/linux/liveupdate.h       |  5 +++++
 kernel/kexec_core.c              |  6 +++++-
 kernel/liveupdate/luo_core.c     | 11 ++++++++++-
 kernel/liveupdate/luo_internal.h |  1 +
 kernel/liveupdate/luo_session.c  | 23 +++++++++++++++++++++++
 5 files changed, 44 insertions(+), 2 deletions(-)

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
index 2fea396d29b9..95710a7d5e56 100644
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
@@ -1230,7 +1232,9 @@ int kernel_kexec(void)
 	}
 #endif
 
- Unlock:
+Unlock:
+	if (liveupdate_prepared)
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
index 0cfc0269d746..8a6b1f6c9b4f 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -88,6 +88,7 @@ int luo_session_retrieve(const char *name, struct file **filep);
 int __init luo_session_setup_outgoing(void *fdt);
 int __init luo_session_setup_incoming(void *fdt);
 int luo_session_serialize(void);
+void luo_session_abort_reboot(void);
 int luo_session_deserialize(void);
 bool luo_session_quiesce(void);
 void luo_session_resume(void);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index d97ec91e1118..200dd3b8229c 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -788,6 +788,29 @@ int luo_session_serialize(void)
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


