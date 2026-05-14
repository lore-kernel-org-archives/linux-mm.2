Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F49ACD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:26:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DD626B008A; Thu, 14 May 2026 18:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 069FD6B008C; Thu, 14 May 2026 18:26:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF6A6B0092; Thu, 14 May 2026 18:26:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB4176B008A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:26:37 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 957DF1204E1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:37 +0000 (UTC)
X-FDA: 84767460834.03.3105A1B
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id DA6E3C000B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="C/Sy0Kfo";
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778797595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lNYZS3s0Ezy+RQHVqVYSzxTe1QiuBpPaay8EBa5d/Xw=;
	b=A/lbCpTAqxYTUukxNSB8JCoKc3fh8W5c2WSR3oXFE6xHudmOaqkrXEUyVbj+eG546fC0au
	oqnqk+vFpe8WPmH+y8yh4aJru3UCkYApPORdiO9d5AwV729+bO03KUY/5ZKx25P2LMF1CP
	auMRWRPQW7W3gSutNZuKoFvgYfAhWrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778797595; a=rsa-sha256;
	cv=none;
	b=t6vLanX3F1INqS69cOVhtaGsUG5euitYcD29RmrYWUki+1p0PtUN9JBehaznHnka3zEey+
	PEQFRNseJ1LOdhi6TV8b6cqZf8gK6ANvUW5aENKfDdlj7kDZNa6rn4Rwx2CsMJrFHXyrZu
	O5ACvZ6AdcUiedAxRBbHsbizKAj94X0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="C/Sy0Kfo";
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-50e97863425so84391341cf.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 15:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778797595; x=1779402395; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lNYZS3s0Ezy+RQHVqVYSzxTe1QiuBpPaay8EBa5d/Xw=;
        b=C/Sy0Kfor91FRCWUaXIqyWdip/Hnyi5jtvNrGfG0hr7Ys+XDx9FKEEeSzPNohMbPON
         kxFc1TcgU/qgyhNrUaW5jw85W0TzACF7jZU8mMqOHIvTlus5eEAKB+v/yevFIZaKAK/w
         wyPgMielcGfyWjz8x05askn00Z+dIHzK7ZCs6FSpmYbXD64wl2Dyyl8xTCZQOGCvGd6P
         eHgraTSmzpsBNNDJkAW1Dbm+Ea5ljh6qZcKytJAqmqZKCcUdlAKvUt0X2st5+B3aYQUp
         HTPa9V+nYuSaklxwh9DztfS7YzOmZ+KbJhpp9FYzb5ytpT1kx4A0EzSMEPFgwvuaCZge
         nLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778797595; x=1779402395;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lNYZS3s0Ezy+RQHVqVYSzxTe1QiuBpPaay8EBa5d/Xw=;
        b=D57P6iAaXRpvyfdp30qZ1edJ1gBZ9aG1BCz9OAC3wX78h4ovPcqP55uMTj3ghAakCz
         WtA7JKMECQDbsbe05FwGS3L8GUNei5DG55a7z4PUP/T1qMt6c7bB705Vbr2fxN22Nj4/
         2Z4IAUPhTrMjf73Scwco2c/LhLgHbc0Xe1yL2qLXPjC3M51VK2XN9HUbra/11PaS+vGD
         cDyoS/n8jzbamN1udv+8c18k2YQHtBHfMhuoIaIoo8v12h2O1pb93ZL7xt0k57ObWm4/
         E/unPylj44Z/VjcaIMeVstxkXOXVgeJeHNRwAaj4b7R955y/IT+nTcQ8FD/kPdmi8fzz
         itfw==
X-Forwarded-Encrypted: i=1; AFNElJ9DUimyM5QufMR9tTZsMl6RGHt4/f/lDbzdGlDszS8XJYyJCI2RVMmmrv2muKYT2o1LCIU4yssAtw==@kvack.org
X-Gm-Message-State: AOJu0YwLgn/eZnm1kIKPbIP5CpBgD8rZ9bGaongbx437dogoqhVB/Yhc
	cVC2qxzBwdMJ1YU8NouNeXWLJgJn/DEpzJ72dXuh8gBSNuBf0CLu95Dgi9OUD4A1Jow=
X-Gm-Gg: Acq92OGDYPAZccdFOaWOmKwlneVh3ZzQDK89LK61cFtvyy0J+LW1tRNSZDLuPVAETgk
	2ue2+nATU+5jx0aU1wourrS85FFJnCeaDfsJkfkZNDMW5afnxihFZ9GP7k+6N0LZb+xyVivi8e/
	r0VgpbfqC/BqochaLbq9yH9cz3COZdSUDCGlj/3O3/+s8GxadptWF+TPVykhShL1lvbYxQjE3ZH
	saFAI934TgZlyFZHtjI0gSgd/3WKvJ0rp5F4XdbOa6w9MnsygznEvNRU8Xhg4qaKdTtPdr+vVMD
	91RhELM4F/1RcDNbk7TiCausjzpnguUp6C4ftw2l2bF7qQLBdnHvHMhlmXqTLb2UXlyu/JfhumN
	nM9H7F2tYQbFGCQ7DHeJjm2yvcezZpfU/0KEKad1vBfEIgdteEA532/i8qvdPDJdkxfgXfgLXX+
	uf2QHg2KoxH4hY+I2CeurWohTXGqmf1sUvfp8kqXaZbra84hmxXK8=
X-Received: by 2002:ac8:7dcd:0:b0:50e:6055:274e with SMTP id d75a77b69052e-5165a025376mr20219891cf.17.1778797595002;
        Thu, 14 May 2026 15:26:35 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456ba92fsm28671901cf.9.2026.05.14.15.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 15:26:34 -0700 (PDT)
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
Subject: [PATCH v2 02/10] liveupdate: Extract luo_file_deserialize_one helper
Date: Thu, 14 May 2026 22:26:20 +0000
Message-ID: <20260514222628.931312-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514222628.931312-1-pasha.tatashin@soleen.com>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA6E3C000B
X-Rspam-User: 
X-Stat-Signature: q4ike1fud6sjntibaruo5xw8g819gjr4
X-HE-Tag: 1778797595-880761
X-HE-Meta: U2FsdGVkX19KGSvYIaXqizIDvt7MHMUsF+4CYJfqf1hDrOAwwfY9xnxOWYAM0mU5XEroFPmYmy/u85JNT1jw99E99zfQzi9gmMWrQ3YEXntrVnPPwRP/L6kTdDw395wvyN7tBby6sd6EKTXcNUwoKUm8ZNiWxJBcOUOzpYBLRajq71TFSHGvCL4OQ+3o/+XSFN4yl3RSkVUqZTqFAKiuQoY8M5D95bqW1851MY7/QdkXXmGxsqLX681Qa1JeE1RXJqpoVvtsZRbah7t+bLNlFZoMwAM8rhU661CYxZpFGjqZ9TmGjhM6xqRRhUDIsAZa5Qz/KKi0Z//DroWJRVfH15ETIIGo+h2FhpDnLOm33U/iYcuWrqJIYPwE/JQUw1wy7xZFsPfB90fkKL2EEBG5ZIofkrgL9V40Bc8uuUsubDuvU7x6VVk0bDv6clzsZa+Wwhh3WR9hXLgsk3BUEAlm6aQ6ZmEIcrsDtSKQapPFzRWV2VN5t1Ezf2Kp099l6z4sZn0G5ZbRbPdchQFp3L7U1dajh6+TgHMNK3MO8jmzGnq21hiRwMoiiQZ1780ApQkX/tlmyqwq9pqPtu/kx60urCGCUOzkbE5rOi+0OGI532TmJKKeWi9vV/W3zeCmxWPQictsl1veD9Ndpd2zrwEsDKW8gNWlgZtwhlxuJTpgXIibMy/wKQRAaj3wriNU8fhjVq0TlXSBhSDNRsZAZLHlqBglgWnD+SNAUE4ZiGjoADECQz2cgl0djZ1NCAyNrGViAUnmxQPL8vyQ78/cuWAZN7UbmhhHhWUE7qrFpOxFVRe37ScqkX7UEc8maZqhMvxzJtFPf5OJS9FSprDSswrEsuLvlGgYAwTDEPjL1l3ZqESXI6kDkC1dZ9f5HoMiyQq5FXhUgH5mYnKI7GFn6rXOQ8Bldlb/jfHbVcLjGcokYgRvL6q4YMV/owbW9+SEohGu6pPpDi41S0CjYbQCz+E
 8/IQsAi7
 sjZfrCMEzKLS5RkbA3zpfPSQdli8byL/yJ5e8hicByxT81RnvYUkrVk/SgAKky+0jg7yoqTnRr0pWa36csf6Mgt8PHJ8VvOX8Rgi1JswnQwgsmbihVP8su93LosDZAn2GjsrwJ+szV70EYtJlqnqGcFyyiPc3hDlQXMpPgDWKGFfat4MbWRAk1Rgb63PyFHjgmd3MNOyVKVJeWv6tnF/Jg7xFrMtCHEedOqO4gTWKHL4HYUyOecjzpAn7eNWZzwJ1NNaP2h/feS806rpzR3Q/wRDD9VAS1pz02BibDMFmHlo3EYigbWRMZ1sghoApHBNDW21reL97ET0alJV9jN88/zew8LEYqTqVXqUXHjbGaXc6dqInJdP7VWBgwftj/dtPG8s72ujTxD28X38zq5YxCk/xtX5M3yqmiPaTgU6dQctTK2TF6ZTlNzIvwdl6bDOi9NRt4dzjgFqD91oRjMdLUnlvSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the logic for deserializing single entries for files into
separate helper functions. In preparation to a linked-block
serialization for files.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c | 77 ++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index a0a419085e28..a2510563469a 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -752,6 +752,46 @@ int luo_file_finish(struct luo_file_set *file_set)
 	return 0;
 }
 
+static int luo_file_deserialize_one(struct luo_file_set *file_set,
+				    struct luo_file_ser *ser)
+{
+	struct liveupdate_file_handler *fh;
+	bool handler_found = false;
+	struct luo_file *luo_file;
+
+	down_read(&luo_register_rwlock);
+	list_private_for_each_entry(fh, &luo_file_handler_list, list) {
+		if (!strcmp(fh->compatible, ser->compatible)) {
+			if (try_module_get(fh->ops->owner))
+				handler_found = true;
+			break;
+		}
+	}
+	up_read(&luo_register_rwlock);
+
+	if (!handler_found) {
+		pr_warn("No registered handler for compatible '%.*s'\n",
+			(int)sizeof(ser->compatible),
+			ser->compatible);
+		return -ENOENT;
+	}
+
+	luo_file = kzalloc_obj(*luo_file);
+	if (!luo_file) {
+		module_put(fh->ops->owner);
+		return -ENOMEM;
+	}
+
+	luo_file->fh = fh;
+	luo_file->file = NULL;
+	luo_file->serialized_data = ser->data;
+	luo_file->token = ser->token;
+	mutex_init(&luo_file->mutex);
+	list_add_tail(&luo_file->list, &file_set->files_list);
+
+	return 0;
+}
+
 /**
  * luo_file_deserialize - Reconstructs the list of preserved files in the new kernel.
  * @file_set:     The incoming file_set to fill with deserialized data.
@@ -781,6 +821,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser)
 {
 	struct luo_file_ser *file_ser;
+	int err;
 	u64 i;
 
 	if (!file_set_ser->files) {
@@ -808,39 +849,9 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 	 */
 	file_ser = file_set->files;
 	for (i = 0; i < file_set->count; i++) {
-		struct liveupdate_file_handler *fh;
-		bool handler_found = false;
-		struct luo_file *luo_file;
-
-		down_read(&luo_register_rwlock);
-		list_private_for_each_entry(fh, &luo_file_handler_list, list) {
-			if (!strcmp(fh->compatible, file_ser[i].compatible)) {
-				if (try_module_get(fh->ops->owner))
-					handler_found = true;
-				break;
-			}
-		}
-		up_read(&luo_register_rwlock);
-
-		if (!handler_found) {
-			pr_warn("No registered handler for compatible '%.*s'\n",
-				(int)sizeof(file_ser[i].compatible),
-				file_ser[i].compatible);
-			return -ENOENT;
-		}
-
-		luo_file = kzalloc_obj(*luo_file);
-		if (!luo_file) {
-			module_put(fh->ops->owner);
-			return -ENOMEM;
-		}
-
-		luo_file->fh = fh;
-		luo_file->file = NULL;
-		luo_file->serialized_data = file_ser[i].data;
-		luo_file->token = file_ser[i].token;
-		mutex_init(&luo_file->mutex);
-		list_add_tail(&luo_file->list, &file_set->files_list);
+		err = luo_file_deserialize_one(file_set, &file_ser[i]);
+		if (err)
+			return err;
 	}
 
 	return 0;
-- 
2.53.0


