Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB8FCD6E4F
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 03:21:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 279656B0092; Thu, 28 May 2026 23:21:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250FC6B0095; Thu, 28 May 2026 23:21:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1184F6B0098; Thu, 28 May 2026 23:21:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB6716B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 23:21:15 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B4CFC141021
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:15 +0000 (UTC)
X-FDA: 84819006510.10.99E68E3
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf12.hostedemail.com (Postfix) with ESMTP id E775A40002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 03:21:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CujjcvS2;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780024873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NpCsC6C+qH6VW/iV99P+6fjIK3KTX0m1gB7hOlYbVxk=;
	b=vAwXPm+x/yQIaw7/6VOyABFOVZoHLA2W6dKFYlUF/6A45T2OxlKm5/zHoJI7oByqmuub22
	R756UWWNaBjL0txmaLwBfSx1k9ioBZaMRreCQNBNNdne0F8Jk+ZKGkLK4Q9+tgyd7vmYVA
	TwRPR+zNNZt8pSXqUy3XlBhC6oideb4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=CujjcvS2;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780024874; a=rsa-sha256;
	cv=none;
	b=59qjnriBG94YjO78CywsX/CoSHajJpHqvtShtAcOfo01uhVmbX/+ir0SpHE+JQl55SfNLe
	hux5N6gIPzQm8GtNV3Z34bN/6/OwqVpQaxcNAXPtb0b7atjUItxu1yx/PpH5so9lPUT5kl
	4Dgn2l3Eg2X09g08O7dZ9YYrUdDs13k=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5148cbdea08so111437531cf.2
        for <linux-mm@kvack.org>; Thu, 28 May 2026 20:21:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780024873; x=1780629673; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NpCsC6C+qH6VW/iV99P+6fjIK3KTX0m1gB7hOlYbVxk=;
        b=CujjcvS22sWEtKYxsdNChOnDX/j8UCozNf5nzuH3x8WmNbT9GnSlAymdwxsHAoYSVM
         KcED3gnSgv7mzdI8oMOg2cnvUj+DjRgnic5QLw7bKqwWo4UeVeMkH2eMBvPOtUsSVFkU
         pXEy+nPCAhZiPHYJ9wTpUG5Zd/gxFOHV+CjneHdqlkAr4EgQdEZtmN9U7NKwTL09QL9I
         ++TFMeF2+8ofRaK6cIhkVqNgos0z0rVGew4f1ts3cKJfM1Obs/JApNXqnPJK2Il5zSSW
         JgbcUq2B8xz7cwn8b8xQbU/OZttrZ/JcbMKIlVMxHlSa9njv3rGvfM4djXEMEfMt+6lG
         LVxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780024873; x=1780629673;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NpCsC6C+qH6VW/iV99P+6fjIK3KTX0m1gB7hOlYbVxk=;
        b=nG94fTcG6nzjAer9t6p62VpGs7UQUuMoZimhFY29wpCYBlTaTW5yu1nkgvQ7OnS+ER
         qrdrefTubiagpL5fDXYX3DTkpjs0ltZt9zUdLbnd9SkLLu0h+ZvDlvAOkGl4hNamGi76
         ECsltyXJbyyn7NyL45PbXYs0qMCSiAoETzF4XznPYviRvl8xacpqYeXMe4KyhXF7NTCk
         QxQCiB9rqahdVDVMXRiCb2ivcQUCeTHR2gBfHdrZEBeIYaoB2Ut1PIR22lM+qu2vHjiZ
         T+Qi4lcY7/sLNKj4JhdQHiuwSJsjWZgcZlfUO0gV3wXI/PSy18x2O1YIwKYmiD6EkMQV
         oisA==
X-Forwarded-Encrypted: i=1; AFNElJ+dWQqyLpANi+TZ6K3ilGqo4h50bUK/IMqQaJbRAhhXgwvHnzBBnWlzyKWsFW/5Z8qaLeM8x9pUbw==@kvack.org
X-Gm-Message-State: AOJu0Yx4Xb+FRc+QR7B6h13BBfexDs5bDEZhsEMJimHVEg/3I3mYFEZI
	pe/dGqhT8rHe8nQdN/bUlI4AVo8an6WfKy+RQiEAgcmLVzZyWvbVa1I5TaBkH3JX9tg=
X-Gm-Gg: Acq92OHqGygEK/OM3O2w4bpmAF9rOzGdRa4/wzPxcJuDGWaR0MPahYb3zubzXPfYx0E
	ccOjhQlaFC/ziqgw5AkDOPBxQk3uS5r+Tng+If11fUKSS290AA9/gslsCLGya+k/OY/C26UuvIb
	lK3qLrtQbXRWo6ka3PgdcbkQHAS+FN5BCsTXIzavBVU3h1Vy+aeYaXAr8mYiqvLoxhB0vV25CoE
	pOBsjjil2ue+cje70rXL+Ql3acuVShZQcMN6G/4alcDZRi7t9xPLcbHY61ZfjqQ75hpJLpcuwmZ
	uMq+UnnfmCH436mEtRZWuLAhDcbjIXcsCYVgkDq9r99Fd41SZIZotdpvEa498c3Q53MQvMnX1oK
	Y2iGPv0cNvgoFxQ6k0ZxQ4bm+dY55g+c/QEJz+5qazibTChJnQKQ1TA8fPXECYi8xjGkDhhUDir
	KqOU+3HP0XAaIA4DGbPI4Ubzh2G60DiiVY2x7ZoauNviZYRvG9Amyzxlrsc22bGg==
X-Received: by 2002:a05:622a:4c1b:b0:516:d955:ea2 with SMTP id d75a77b69052e-5172daa1350mr16395121cf.0.1780024873082;
        Thu, 28 May 2026 20:21:13 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ccea26d286sm1179476d6.48.2026.05.28.20.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 May 2026 20:21:12 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	skhawaja@google.com,
	graf@amazon.com
Subject: [PATCH v3 04/11] liveupdate: Extract luo_session_deserialize_one helper
Date: Fri, 29 May 2026 03:20:59 +0000
Message-ID: <20260529032106.1505796-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
References: <20260529032106.1505796-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wombqsznhjpw4j9g7z41qu3qb9q6pcru
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E775A40002
X-Rspam-User: 
X-HE-Tag: 1780024873-335513
X-HE-Meta: U2FsdGVkX19ATBu4zsvwllo9P/nduwe7N4eqUmM3BCfZZ5/TksSpDQOo8NtrOsMuE7tvuYpIr4CXqHhVQh6gBLOCLfLLJcGE8zQOvXKn2CQGX55bDNilWoVXt/ECadJQ3Bv9PsmAZof9KdOTIDDNl6yf5QQeGy+nWwrsUyYRNnvkVxJ+TRyxzlumTr7BNdUNIt18CXuAkQOqwhrKSCXFQx6mPR5EJ35IGfUXZ0GA4dCts0mbnZSsvFmx//mRt0DKZtkoKZAZLmjbAujdERRVq36Ci0glmWfyXSnllWElyCtMH+HUAL8YQG8S3sYOE5JFakbKzUiv7JcR6Mqc9/NdOrZmVU3TOKEf5uVJKOvLhddjAcJKIB1b6rHm3SxqOLjc7Us9tlnnMn1Quu+8FiJqaG6uf6kPh3H/jstE0EC8SkYYICwEPGmTVPNBlS1kse0eTUQPHZTpF7M/rOE0akZmmOgZFZClA861KMyUgrJkNhvjPZPMXUBm1VQnUocq6KSNhL5EwYOQ3P+VMVfVNYZ00i/KwOzAC7gXpp5s90DLy88QcbMLgQ0rj9ILVA4KY4WnV5A8jUIPQRFe8DMdX/MRyBQLhr/b4n2E6oukYOYiWVnxWIOws4LUQBIt0ruoetdohJiVqQFsbv5I9w+yPZ+MrVYZKNyWtYRp2u0uXLNuDssNtxtDYRz5PQDa5qhNAwZcUS2bkTmOe5n1sTDr22cYgvPDk8eqOiu6UBANcfi3IJhaQpmWlc1TvLB0+6vbWka3DfWHePgEP23HCMSltfls5bNNIYeJnrVtzWC1y1MDpR6TB93jgbLI54RvAjngWUgchMuSOWftJwou6LHKx0xAp54MOEqpA49/DlHkSPGatmxDCdeEmasvIqqqbggJTgHvozZyfDcjbjYIRjEV8jGWzVpsUsjFmLjMwMxWspUDWy2iXY4Kyf3IBck2gsxst7DSMqap2cozoSOZMO3CkOy
 Sa32VQFY
 LER9NoTkRmJ/za0OyUfxEekvRldMnPxYO+IEAmez2MKfjMOEXRV59HVk61Qebs1tOYmtko1m4Lb8q3fd3XkTW6GMoWp/65Po/AoybMpQ6lJjC60w/J8dZbua+ZNuS6RRhKnDI9Fv8StQUD4iZFxOAH06AurYFleepGZnzIMDfM+c1OtP3hh9oADjAWozRZJII0AMjFU9ktDhPZHXeUgOgRIyj0wREbZ++xhz+moI+KmikrE0gTHRRIgVFfP6LaGeXzX3YJX18dH/13jTQZXeS6xl7x8xw20yd/URoWiG0ET9j5MEzf8sjbOq5chMzDH6Rs9ikLzoVUv81NnWqz3WZA3WQM7SoRzWrVIyKOtv3/NK7n7Po8MwAvUIs+VyIz+RuTOUPkT2P67GpUio=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the logic for deserializing single entries for sessions into
separate helper functions. In preparation to a linked-block
serialization for sessions.

This is a pure code movement, no other changes intended.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 62 +++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 1cad54ea8209..5c092c71797e 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -526,6 +526,40 @@ int __init luo_session_setup_incoming(u64 sessions_pa)
 	return 0;
 }
 
+static int luo_session_deserialize_one(struct luo_session_header *sh,
+				       struct luo_session_ser *ser)
+{
+	struct luo_session *session;
+	int err;
+
+	session = luo_session_alloc(ser->name);
+	if (IS_ERR(session)) {
+		pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
+			(int)sizeof(ser->name), ser->name, session);
+		return PTR_ERR(session);
+	}
+
+	err = luo_session_insert(sh, session);
+	if (err) {
+		pr_warn("Failed to insert session [%s] %pe\n",
+			session->name, ERR_PTR(err));
+		luo_session_free(session);
+		return err;
+	}
+
+	scoped_guard(mutex, &session->mutex) {
+		err = luo_file_deserialize(&session->file_set,
+					   &ser->file_set_ser);
+	}
+	if (err) {
+		pr_warn("Failed to deserialize files for session [%s] %pe\n",
+			session->name, ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
+
 int luo_session_deserialize(void)
 {
 	struct luo_session_header *sh = &luo_session_global.incoming;
@@ -556,33 +590,9 @@ int luo_session_deserialize(void)
 	 * reliably reset devices and reclaim memory.
 	 */
 	for (int i = 0; i < sh->header_ser->count; i++) {
-		struct luo_session *session;
-
-		session = luo_session_alloc(sh->ser[i].name);
-		if (IS_ERR(session)) {
-			pr_warn("Failed to allocate session [%.*s] during deserialization %pe\n",
-				(int)sizeof(sh->ser[i].name),
-				sh->ser[i].name, session);
-			return PTR_ERR(session);
-		}
-
-		err = luo_session_insert(sh, session);
-		if (err) {
-			pr_warn("Failed to insert session [%s] %pe\n",
-				session->name, ERR_PTR(err));
-			luo_session_free(session);
-			return err;
-		}
-
-		scoped_guard(mutex, &session->mutex) {
-			err = luo_file_deserialize(&session->file_set,
-						   &sh->ser[i].file_set_ser);
-		}
-		if (err) {
-			pr_warn("Failed to deserialize files for session [%s] %pe\n",
-				session->name, ERR_PTR(err));
+		err = luo_session_deserialize_one(sh, &sh->ser[i]);
+		if (err)
 			return err;
-		}
 	}
 
 	kho_restore_free(sh->header_ser);
-- 
2.53.0


