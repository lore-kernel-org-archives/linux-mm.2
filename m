Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27575CD6E71
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 03:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972646B0096; Tue,  2 Jun 2026 23:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922DF6B0098; Tue,  2 Jun 2026 23:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728C66B0099; Tue,  2 Jun 2026 23:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5267F6B0096
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 23:29:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1C40D8C777
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:17 +0000 (UTC)
X-FDA: 84837170754.13.CC25FCC
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5A968180004
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 03:29:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MUQ+8fgK;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780457355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
	b=0IV1t4Y3x1lGmR1bPyYGMwag9d5dV6CzByAnQ85hIPVUbaTRu0WOav0cieswyxPIXwrJ4u
	b4aY94t8sBDBzRMzickrRHwSqGkYqTbQnrENpnMMJXC1TcMXjX90zLBn7RtWjZspGen2qj
	CSQDYsGBTZ5TUDNN+xKAlBC/+yGA2sE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=MUQ+8fgK;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780457355;
	b=1nwdUvLms4CvbKiSdKY17CFjN13n41vTzB4gyVXJ7/dUKMOUawfIUfuY6U0N4kQRH8tEq2
	W7V9F4LqYG9QfFYjZsgnBBRKRlu6ta8zWTDH8zcybLCuf+bref2Bg8mXYNan+49R9SZjzK
	DpgEpsTQqnoaiA8IIEXn7SBZpWReq5Q=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8ce0f17a69cso28155366d6.0
        for <linux-mm@kvack.org>; Tue, 02 Jun 2026 20:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780457354; x=1781062154; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
        b=MUQ+8fgKh3N4ujMySY5Ywi5rIlC4bWLZ1n0eMRmCUvGvVcmheFR9vmSISD1+gHZW1p
         l0dm3j+3S1CbK+Xfdis3eAAA1lNxhvN9yZlfUGSvBs6XfZk5suE2swEzoIV8qipelJfA
         K2zll5NQJ6fUCaVUzBG6sBWR2P6hSzX8VkXbvR3OIBupfX4GpBt0A7+vk+9u5mI30fs0
         auqEE7zoH6w1Ey0kcNyKS1tIzupC1sAFkmZJzJdESDDwQx3+smQepsl5s6jdgxRwufL3
         Y8Fk5q+84VR7z8/BBT+yW640W9rcb4A67c0fylvgIJAEPq0fVnQsM7QZZdg2OotmqOo5
         5BLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780457354; x=1781062154;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
        b=cOBlPQUnB0hpvGcuCNoYpWURTK3rP6A3L2yvRTu5IIRRcNpZonN7sKATyWQnMmwAyr
         HanqFl3DuZlM8+UtEEJWujXXcU+CHeg8eLwGu7Gy7Ewp931VAb4zXP4WeD4EedpG7r38
         yx2OBk1mvwMeySRTLpqsPZArZwhLeJYIQVtviwryGBoByRdpGi0J11cwuTUqNkjPWy6P
         qJQGa4KLNIoI0dN5W62Eigc8rHjmekxTN+JA3rpmiyhQ0+aOnZ/eM95ryMt7EgyBk4ZF
         WtY2ZlxbplJahEE4zhhsAFVPZSrEB9/Q4Ttm+FOEn31yJJbTzbNTHI9eFm/5CURzKOgC
         ZB1w==
X-Forwarded-Encrypted: i=1; AFNElJ/bjqA/cBu2eicOXyxjo+h9rbel2vQbj9dgI2RfF3EHXB8E+Whfw6N/OU+taUBQmRhLhhz3guD1dw==@kvack.org
X-Gm-Message-State: AOJu0YypKDWVeZEYsdZ4N63TNb5kQkMLFfTwwPVL6yXn/OshjlHdC4Vm
	GxR0cjDNArcJp0lc5Kv0m3i6YVg4PGFyXdYZw91RDlpCZR7mFfJo20eqmzjR6DcKrjA=
X-Gm-Gg: Acq92OHts8Hn4O2TU/lT2CR4jHIveO2nE5UFNfmeaRs0UqkK6IUAEYk5k0BuhZ91x0Q
	YvCZdRlZY2FcLhLE5IqUn+ViWQC3Krlqbgj2JLu/hBZTOyOjV7lXxIgKiNckIwVUHAvA3hTftGC
	DLuGqF02e6RBvMwWTTYlBXBGvpjCPDu0OHILV5Hwtgn2W5KXiMwKC57gFQ5/eTiNEmH4+snvxrS
	5X9Vc15E0JuhoWBB8j9miI4rG/mlenSFcPKxNeX45KMIdYmzAQiXsuFe3/mqHnJeTzvUYrN2xKf
	kMDRvm6jzx21UNVanx4Twvs3o3jjA78f63lV//zsV29iqRqLf95ZYFCSznZuoBu6+NRgn0qsTWi
	m+/CDJtV0R8k+10Aza3ayTTSDSRmFy0rBzDYSANvv9I83Fni1PS/2jGXHTTqBEIGINwsij8nhv+
	xjoTw52YVo5Rsz/bjyggrXb7u+7kAJZb2ojD6IsmFOZBdnsBCGVDTX55OxVZWUzQ==
X-Received: by 2002:ad4:5be8:0:b0:8ac:b4d5:50ec with SMTP id 6a1803df08f44-8cecdcc5dd2mr23007136d6.38.1780457354509;
        Tue, 02 Jun 2026 20:29:14 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd26b3b9sm9244566d6.45.2026.06.02.20.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2026 20:29:14 -0700 (PDT)
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
Subject: [PATCH v6 05/13] liveupdate: Extract luo_file_deserialize_one helper
Date: Wed,  3 Jun 2026 03:28:56 +0000
Message-ID: <20260603032905.344462-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603032905.344462-1-pasha.tatashin@soleen.com>
References: <20260603032905.344462-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5A968180004
X-Stat-Signature: 4gxq9mcjow696r5jpwnoh34unhj3z1g5
X-HE-Tag: 1780457355-909528
X-HE-Meta: U2FsdGVkX19M6kDj0KVSmda7zk4FZcGQHOZcV5iWxt4qjJkgaEnzVm3Ww3s2bx1EfIV8BLtGYbmQ/QltzYJ63Qpe9/J1tLswsL533/XUV8aEjrKpN2N/NHOX1AqGBVQW9vXCCr7Na0GqXKXT68zhuN7xM9SO+gHlXOuQIFRv30TWuzyBoI1ImVL+4AqprBQrrhK5ARpAQem1vKNYSJHYiyZQCdRw3hoiEpjse8oJElUb9lCbAd+LNk+9B7YZwaTStHCKiXclN83iPZtiE8fwzaJa3YpnpjRWHShcycgPqQIsftqHRH7jzDULwYBYuObIjBQcBClEMmeL4bQcVVKtaE232SqMYxrSQZu3U3Z/pGbWu4v6lmK33rqMDnRnVZTp9YARHkbxR9yhMbAqspm6thK8oQaH5RUonhSN4VouvHOYyFZJ4UiUgKmPMR/XG8k4JaKk4RmuRFczehqNpEyqEdw77o8LhQOhvb1l3s97LZ6PfasR6AO/PDML6DzMgPQ1F4v+JPE8QVXbKH0jKgZzSi/qx6EJWhr8QuJOGQMDmyGHwh1KWmVDb1E0dmC9ZIUUpgJdz+J6QHcbinnN28AZLPHQ3MuZPjJ4F/dp1rj7u8bFRCrGl6a2fTR/3xCBr2RwGhsPERYDQnUHyX32znzqeM4AEg7Ihs3mJSY0Qq68agwcbd4XPvIWiKGzqD6ofMhIQo6NA3IsA/m5/exWtXPC0kE/ZjtrTW4RN68dXNrjDZlCPM7JVUSmWc4xfAXZ9FctjfSn1GD0L23nGWWthjywcBBZJFxn9JluquAcbUzxhhdiYbglWE7udBAEW0kYx1HoKgvhMluWCfh+61K7NqUwl4IxH6oqBUGDMiaxKxScPWD/5xrANi4RmXP98s6LD2w+Hwujjmn683wU4SWRpKH2ZlC7qBsfJis7hIjaBorXOJ5d8WqVCvYgmNivRnqXS1Px8RDoU6cRQt8joj/fXhR
 SSgyWkLV
 F6F2AfQVi+kbT/HE5nsh/o8ytU8FlTYim55gy0weWGcO5SHsNcRm9xsF43OuNhKWcGS4/OWGfDsSFVKbQ/eQJUD/6Fxo077sWV1eRDFBVZ7uJyXCglkwSDNbJlXjJqGo2iDGNYB6s/2a0Pv89dSrdf93onE+fOcemtg6Dqd9mvw0953cPnlOdPOmg1j4T1e/785NuTJJEc1aJCu8o55hAYk2/ZnKlA0Ad114FlNVwZLm6MeLav/0s7dS40YWhOyLOb7re7LrxQJmGEslQbT9QH6aEEZCE+GzfWO1EBs3y8NzIkhaI3Ie7MxVUx+6FT2LNS+BaifuIxzrui5qSoojMfbbXelQmJWUFAdu29SfDeOpUNkxRNy5N7TFjIRLlZ3nybxLzKPe7VraJlho=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the logic for deserializing single entries for files into
separate helper functions. In preparation to a linked-block
serialization for files.

This is a pure code movement, no other changes intended.

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_file.c | 77 ++++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 33 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 208987502f73..9eec07a9e9fc 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -753,6 +753,46 @@ int luo_file_finish(struct luo_file_set *file_set)
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
@@ -782,6 +822,7 @@ int luo_file_deserialize(struct luo_file_set *file_set,
 			 struct luo_file_set_ser *file_set_ser)
 {
 	struct luo_file_ser *file_ser;
+	int err;
 	u64 i;
 
 	if (!file_set_ser->files) {
@@ -809,39 +850,9 @@ int luo_file_deserialize(struct luo_file_set *file_set,
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


