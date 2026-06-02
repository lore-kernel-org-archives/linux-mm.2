Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13FA1CD6E61
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699246B04B3; Mon,  1 Jun 2026 23:17:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 622EC6B04B8; Mon,  1 Jun 2026 23:17:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49BC86B04BC; Mon,  1 Jun 2026 23:17:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 309C46B04B3
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC5F41C0D2E
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:27 +0000 (UTC)
X-FDA: 84833512134.14.0D71522
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2DB2C14000A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DjEOT7NS;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
	b=cgY5WPOlRU6XnXve9YylaitEYowKqj2l2QRv3uURNPCPerJraEB8IMVdjNepMkYzMK5PH9
	c+oksuJFk08Yan5mtAp6N5EFD6LY8VuQq0JPMu+J68iLdXhX6gKvEEhJ8CcAJ2huYBJmwP
	AMSmVqLxqnNWNR0/517o+fJAwR5XkbM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=DjEOT7NS;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370246;
	b=wbGgwhuiG46rbq0GDHCtaZAD4FlbziloF20vKG/IvRnWALkitXCZcWWhkvFwUxjx4NZuDk
	BFSfYZ0vfaVHE5Ft2EX6WBw1hMdV4q4v6hjUC6u8qKnSZueLwKRH5x59np6r31gN8dWc0M
	ncWX/HLjWBdXhX4XCuf9PG2IQpl8kJ8=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-516d634956fso125694971cf.2
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370245; x=1780975045; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
        b=DjEOT7NSd6/cf70Np88+yckgTLt+Sxb/EFkxPSweqytDw1vYwbgSiIZ86s7rAe6ITY
         eZA3nNnbXwG4ovewm9/hCWyC8P5k0wsibnVf1NhW1lcz/h5XWewTmZMMGqzIcK4liyKy
         8wooVeUIUeths0EgSWJzOCCMk7v1YGtG5bfPNmtFfDxGW4Y4e06C23Ry7uTr6fvVhRCu
         rJRAp0s4j3rzOGfKK62Y2nE88e3EZfA04VM6dlaolpAkhKfIiNZFtd1LEgUpvgjTmuKS
         oWqJGeAlQvKPNXu2KFNL8ib+8cz+RXDkE722WnEpXn2qGORt4J8E4TvTbbQowc69h4W0
         yCTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370245; x=1780975045;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
        b=f6bgiaR0mMQcr0I9H8gCkIK4p6udQAlXwjNvihCNa9HH4md7wMe8Th/4mkdkkzfm3g
         AOTe6ryjUagl/FqTAb28s5/rxW0LoPu6uU+FtFHgV0CBC/4/ZlZE4VNr63SfmkhwMD7p
         XUBzz0T8C3SrxzIppAZ66DZ9is3iov5s0xFmSU92HL0mLyF/OJoLzu1j1psPqbqS0Xvf
         AP8uswno7N8RPPqck5mjFZ1ljz4rtr+R7EReEWsKkwCYps55OPyI6rMJl6BGui5OaWoD
         BComSLpDakSEi2uCQS7p9z1YQQv6x7VJ5bHm5blbJSaJmk88wPpY7VqWgwZHcgiA3LC6
         HVAA==
X-Forwarded-Encrypted: i=1; AFNElJ84cJU5HoB8Mrdsq/6s6Ke8xKtSYgm7ZXzk4et4D6ps9axA4uM/wHvTPgmTdyUhsi4yRWbmJKWFeA==@kvack.org
X-Gm-Message-State: AOJu0YxKLIqd6OlaX9y1fEsAidvYqpdE4u2qegg9N/pwGwRYQQz/u6ei
	DeMeQ7vlTIs62t/bpZd7e3gZScSHt4Fy6C+PWK83lm2W5ujy0Z1+G206Uvc4zj4us7Q=
X-Gm-Gg: Acq92OExVjnVVLnCdBgWxc3L5qfBBdYcHuAwnxdVKg6X3puEQPCh602t9z/7pPsWzPB
	p4lhnlL8aDs6eY3upQuVYBAIYq6aMXeMJbxWwwcSlXZt1IS2rUXY9dKddi+/cAloTZZbvfkOa65
	GWRv9CQvC/z48tQLFDU2kBELgyKq+Kg58oNusg0ougUv4zzyT5ElN4nWzRh6+t5bl5YrSO29urA
	PtcFNlU8LI/bDDHPmorGFiefcfvJSG0zsZvKRItFD4C2PrOD0Ig3aNFNxo5ssgOqSe5hhq6SWzx
	0aiUDHlco3uwa/W0U2D8QEwJLZM+K4lUyIkKngiKrGMD/Fn90E0Rs2vn5JCP+yTI/P1zI8ez/+u
	KGAZOLKR5vzZyqZQz0IhuvU9lcOGgMoM9rM21fxjQ+hFx4cH4pq0h5/+RzTd8VEufzgUbz8oiv8
	AVYdMtSKsLwHI/umel6DRGwNeIDp+J8ODQe83Cs+dDfukp1Fc6P9KqffVqKThwCA==
X-Received: by 2002:a05:622a:5986:b0:50f:c117:1c52 with SMTP id d75a77b69052e-5173a5e7f0emr188951681cf.4.1780370245318;
        Mon, 01 Jun 2026 20:17:25 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:24 -0700 (PDT)
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
Subject: [PATCH v5 05/13] liveupdate: Extract luo_file_deserialize_one helper
Date: Tue,  2 Jun 2026 03:17:09 +0000
Message-ID: <20260602031717.197696-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602031717.197696-1-pasha.tatashin@soleen.com>
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2DB2C14000A
X-Stat-Signature: qpg58wo16taboi3ek9hniogynkea6ewz
X-Rspam-User: 
X-HE-Tag: 1780370245-463024
X-HE-Meta: U2FsdGVkX18x+0aiaeTiRv+eo71CAthpq/1X8EfebqC7iHgr9AYqknFPvEbbadMIZWJE64rQNQU5gsokhGC4A7FlcqasKW4pU5hchiUMcYjhkTmaPz9DrufTQVAdui7rvCJCswmdpOM60KGzIUZBbEqf2fYs/5fv424S3TrkXjvT4MQalPcOk8KfG5rpt1z53nghYrBpp7DK3HXcxU8RNn7tuoqUDRaTTjT+a4q8t+2uvOQhqxgHikCBl4ciSdWxWiM6jE/tgOFgsy0AlEajgsT6h/xIg1/qisVGBu3nNnDRPCs7Zd/m7NI7NP7xGJfzD2t8Xd816jturMa0Xvuuexcr55afZIwaXeYLo1Mf83o0zD6NxGsW1QMsbxsbfkPu+fZ5vwt9AkwvSd5LDvqySexyf6IZEkAR+w4K2mlHbD5H489ea4vS6mW6RBbLjpsTAQ58hc0ptva9OXK36iPeAEqu0eGjy/xj9bHBezoTkisZF6aS2A96AyIAGV+mXmW5MAfUGE5M5g0IuVFCJHsN0EGGcDJGIhhtm6Yonzx0PQ7VLx7JRU7xFuuyavk1vnMgmh44+0BGYCGxEgQGU6r5FQ0hb6XyCBl2/tG8e/oVGpYtpdGF/zEK8wT3dfpXDOGfuJU2ra+VfLvyr7NPw1P0WJM6v4ej60g1oWl6cLrcyJWFcYSMcbv9SD3TzGtBRQHSRaGsUDs5MB2tvtVmoAyz0owintldEHF0SDNm5xJL0VX6wxWBRM/Cazakw0VH6u49UlIhvdDzY2AAGx04Rkfi6m6sETCr1Ock04UKHdD5mw/2L7fgWQRYfSfIzueQAa2bN9hKGKkFFHUC2KigVCMum7d5fjwxFF52vfAfCNoSUExUSg/J+GL8Q8hzgrg1XRL6WZJ8uDzZBdWJPmll66nfEDgDblnoZKGOZuCExKEznJ3Aksma0j5/F/naCTR5KXMhZ6Qw4o2k7xNwtFlPSCL
 6RhQbq/W
 P3fCBfTMaVsVSW1EF9LLX1ImN06vmfmdAwQPCKCQbaNEI4Mmw7qEqrVhI5cXek7WxBv9Ox8xTnDNP8U/n3leOmfGvKIxPb2j+pPwu85We9Fylh4Wx025bKENhZKz1NopMt5Bvrbelxe4fLMPlYVeQvIDYc0UCMgq3OxY7vH8IgBAU5cBk1s4rCGfq6bM27s+uf2wiRsgwh5SdiIhd2Nqi2fIFolp98tt2qXTeLAsH9tL2FmeJa7XRfy2SD4L74VM3dTJH/k15gIUvehdFOkFGLlcQnWq1T+guPf2Dfp6tUez5KdxDX/0h8mCqzBuW+pVlewBDd641yxsqokYmvWK+D5nT0KA36nb4RG1Yr6va5uMh4YAoqnf/6n/Zyub6IPE/EmdDqEpP+u5tLaODqh2yaUtBlKSrDTwWbQlqUvbcrzaU2oA5wH4OGtWR8I6zZ4PJ9576SB4SZgidZmtRp4zKdF59+psn9bprn0gvT8CBK/TtKJs=
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


