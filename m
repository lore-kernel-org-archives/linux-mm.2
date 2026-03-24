Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C33FBFEC116
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 21:33:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C5D16B0005; Tue, 24 Mar 2026 17:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 176E86B0088; Tue, 24 Mar 2026 17:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 065F66B008A; Tue, 24 Mar 2026 17:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8F986B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 17:33:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8B47A1604D9
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:33:44 +0000 (UTC)
X-FDA: 84582258768.03.7E00648
Received: from las-vegas.smtp.mymangomail.com (las-vegas.smtp.mymangomail.com [205.185.121.143])
	by imf02.hostedemail.com (Postfix) with ESMTP id 622C88000E
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 21:33:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=LAqVOAbt;
	spf=pass (imf02.hostedemail.com: domain of oskar@gerlicz.space designates 205.185.121.143 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774388022; a=rsa-sha256;
	cv=none;
	b=JeEVkY6/q40IcPgZy7USaaSFkpVpRBtAFMv80N6CqfNIyWnUnxvtknrn1nWQaR+DKAT6bd
	gwxJQCymtc+pYG9u+818g232MtSqgVgUJMWe8waR/64Q+sgGelGFUykq/QS3fGwQABfiic
	Yfm63YukCNotqBBDbznFXAV1yJ7YEyI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774388022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7xhDy1BgyrskKJuIWlurbpu3icLSDlAbkwHOC+AdOs=;
	b=toQZxGL/qEFvpQ5l1+fOmv2rDkgRhOcAVtxIIgSc3nYyN+j08f+Gifbxzbnwegz/pamrtE
	SsVBhS+S8vE5eOItJCNWWm9GPiAsJX/Vhz8tlabFDjGYXKxLKGBOHj2F7Lfb3GjbuLkMt7
	ftk1gIkdeoTvN9X5g7LY5dro/rD1D2g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gerlicz.space header.s=mango-1 header.b=LAqVOAbt;
	spf=pass (imf02.hostedemail.com: domain of oskar@gerlicz.space designates 205.185.121.143 as permitted sender) smtp.mailfrom=oskar@gerlicz.space;
	dmarc=pass (policy=quarantine) header.from=gerlicz.space
Received: from [127.0.1.1] (localhost [127.0.0.1])
	by kansas-city.smtp.mymangomail.com (Mango Mail) with ESMTP id 21E07FC9A4;
	Tue, 24 Mar 2026 17:32:03 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gerlicz.space;
	s=mango-1; t=1774387923;
	bh=7mgxkaS+I+cyWVazKf/NNLcFoK8RM90Iih9vQSgw1A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAqVOAbtu/JkwkGytv01uAGAM+C75VgslnRRTA5D0UJZoGg/fzkOCfzT1jYalV9Py
	 ZEdlmkhJ/TIg+uluV0kzQrwSMJQoQ02cKh0InKeifi4gmUiTno39sLlEmg3YD/lebn
	 qF8+/mNXJMJU2EIh35q/cGG/tpKV96W1U97shP8s=
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
	by kansas-city.smtp.mymangomail.com (Mango Mail) with ESMTPSA id CC427FC989;
	Tue, 24 Mar 2026 17:30:50 -0400 (EDT)
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
Subject: [PATCH v4 2/5] kexec: abort liveupdate handover on kernel_kexec()
 unwind
Date: Tue, 24 Mar 2026 22:27:27 +0100
Message-ID: <20260324212730.65290-3-oskar@gerlicz.space>
In-Reply-To: <20260324212730.65290-2-oskar@gerlicz.space>
References: <20260324212730.65290-1-oskar@gerlicz.space>
 <20260324212730.65290-2-oskar@gerlicz.space>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 622C88000E
X-Stat-Signature: qqfzfj3dnim83cu9zxfz5otmdy8q9myn
X-HE-Tag: 1774388022-80037
X-HE-Meta: U2FsdGVkX1/T3nBEMIpDg97lD9IuWJ9Jkg7Vz90S4fZapIdamKigKvDu6pC5yhJa9gPfym9Uj+mGvpDls2c03+Rqz4R+P7wRDoSfFcSuQzkn6JWNiGNY8qrLTYqk1KhlRUxQ6+of+aZ2wZMM4O3zwcht7kvB+ln886KkyuRNo7webr+NWzZGl+QDBjjYEE1mkhBV+Kv8w00mFTmVrDIMiGZxO7kU0y3k6j377sA/9t+YsV5eKE1TFuEgvjEjxvv1Jd6dXDkE5ogIrcFRdpcUFxzz/2GMrjK0clE3G/vdH9WcWhtwLArkzRe01SWttDenww/HrkJdSooui5EuGjjJe4iGLXjiXhhnonQ/WTHDKINndSy4KJD6T1wJuNj3WOJX5wETi9VKkwlAcOkLb7k4/pQ241FPDl5xYvy5kGOb+yFp/PofXv59GZ32SubPgQ6mLr6BkiHDnke14uN/7caIsI7DZ6JAhtYGuNAy0DQDK8LQae5/yprOce1Eo6ww8knG2l0wWrD67JQtyAHh4ab0xL+d80tSCq7E+i5R1eKhMaWhk84gQa2z4IC4k2r4TBfNAh6sGCEUxQi+AKH1L//JUbE72QLs5hm4VzB6aIedbfBeE5cbjRCounfYXFLbu3PvSNG/X9j8vJViKUu0RjhSOCRACKCYZik0fy9AzTpYwSv3YKxDdR6+irdwvxvoAc3O8rix9P1EFO/iftNwB4zedsM+Gol0Sstsktz/7wXIY9+bKb7O5UnAIoMM7Zo4AvBueiTVHb+T2Cb3Y1N6xQpuuu/3YnfJkDplKM9ZuZgRQqVzb9BTbxL0kvEylIZTHj1eXKxOJvAAbXAgqNLnlyK2FDG8D6jXGPGRbkV0ULRg0jX1kiVroRoAKNLYdkXrnWVrtATwkqrI6EP/hM4kM9H9AK40siC1+yc8D1DszclGLSUz24U5dVHLJmrWv5WhRiVWiWJHpbFUg+43s7ixCnQ
 vbboI3DH
 Zc1Mk/hi8KVwrArpMYoA9pNDF+zpsa473upfQT0zj+Y8h6iZbBzQIONOFQktltqV/vpD+MoHX/CVCDHrGdFPMUTDio+J26Rc/ZydhHr5LLda7frIQhkxaBDYMaoyFuj9xHktRZGtYepEM8UUGcFAW7oDDUvZ9R19JSPb8I4bRpGneXSr2Z7Em68GfmOY9ak/dhH+YrDqmI6HCIQlW815DLGhmcMTazn0lwBMS3ctmNTt5D5rKDfrxhAx1zVU9JkZp2Zbwehs6bAoREe9yBgbkklk4GJZETKKIQGp1Z5FjW0N8EL8lzHmmYyUYwGSyQg/LSSh+uONaT+NWSuVGEYINtXjhyAZJWkAiu9Qt857Q72k2hm3VktmNpeal1BK0jOUER/q0ZQbNF4ZUXxG59I008Eebsp9mP19FYHsDeLDJgstCXuMyZ5LCF0qiaHRLGCwfmeCX3HVy6V+vIJqXifMqbnsOaaeJt3mNKpQ/
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
 kernel/liveupdate/luo_session.c  | 30 ++++++++++++++++++++++++++++++
 5 files changed, 51 insertions(+), 2 deletions(-)

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
index e29e1a46b491..d6e9e85004b0 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -87,6 +87,7 @@ int luo_session_retrieve(const char *name, struct file **filep);
 int __init luo_session_setup_outgoing(void *fdt);
 int __init luo_session_setup_incoming(void *fdt);
 int luo_session_serialize(void);
+void luo_session_abort_reboot(void);
 int luo_session_deserialize(void);
 bool luo_session_quiesce(void);
 void luo_session_resume(void);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 63aee9cc881d..cc03fc2bef97 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -294,6 +294,13 @@ static int luo_session_finish_retrieved(struct luo_session *session)
 	return luo_file_finish(&session->file_set);
 }
 
+static void luo_session_unfreeze_one(struct luo_session *session,
+				     struct luo_session_ser *ser)
+{
+	guard(mutex)(&session->mutex);
+	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
+}
+
 static int luo_session_release(struct inode *inodep, struct file *filep)
 {
 	struct luo_session *session = filep->private_data;
@@ -797,6 +804,29 @@ int luo_session_serialize(void)
 	goto out_put_sessions;
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


