Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 190E410BA423
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 03:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 863786B00A4; Thu, 26 Mar 2026 23:33:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 838976B00A5; Thu, 26 Mar 2026 23:33:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63FE66B00A6; Thu, 26 Mar 2026 23:33:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 467A96B00A4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:33:45 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D311E140BA1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:44 +0000 (UTC)
X-FDA: 84590423568.27.0F9B94D
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1726F180006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 03:33:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Io2qgG4d;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774582423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Iybl7pyAga8N/3JgGk4Dm4BTbHSRib3nIqdcUgoEHA=;
	b=r8jCFsteJ6EmlIbRmHht3CLPB9RQpGJRDEfD+sjRv1sV9v4k0ezs33QohnpaAWuZ0vIqHG
	bf3tHlM6LJTdghV44OgSvUwxjuodppaMnJb9eV5DvfY4gOHUzyPoNV6BL8bgtzSHQ4SVJF
	5yULFWwFu0i6TrXVLBkeF90J0qPtH4k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774582423; a=rsa-sha256;
	cv=none;
	b=H5+X6Rrn4dEne6C1nsrVV/WTZN+xfa8WFxvc5NjJRLXNwqld5xx1Gs8xW3yex15KheFluJ
	R2EfjcA/pFHTXejsozeJta0k9+kXShjV349TY4Hx0KmFPygxQFhQHvmNMc5Qi8pxXaaUW9
	wBvAt6bsUvAPjTMAu1RI1QnZ2I+qqKY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Io2qgG4d;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-509061dab77so15098071cf.2
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1774582422; x=1775187222; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6Iybl7pyAga8N/3JgGk4Dm4BTbHSRib3nIqdcUgoEHA=;
        b=Io2qgG4dsX3BZKrLFVIcNvtvVz4gJ5yOHNE6gTFQ/jZbQHykoiPJgrxsh9+OL3LPyQ
         /DwJiPvZREuY/zeP/cUTW3l8RAFxiztArRB78NVnkuohCR9+Ra3ukJrBswcJWtl8n1Z+
         p8qfTmzrWNrtiwrCRA95y847fvIT1fadT8cZ59UUXt/b0IUqCdLnOVaxOHbeD7afa4MG
         V+TJK+qX1hZ4XSv0rMRDPZI5KG4H1uZnhkMlFKD+pp6D9GkHdzT5HHTo2QvB/y2fZCvB
         zZDK5eLVr+Gi+WiSANLnYiN1qQ/TnkpaOukzit7OiM5/16VYkjdHLCbvsUtIluTfzKuF
         dovw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774582422; x=1775187222;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6Iybl7pyAga8N/3JgGk4Dm4BTbHSRib3nIqdcUgoEHA=;
        b=OEL0csg0AiwGOClgLSGGwVAv0i+qRqpN6QfCNf9SAVBzJn2x7gwKTTqw7+VCSl/qZs
         gAtEt3oIFSgFiM4Otk5UXevcfB767LPLTb2rSJM5DFv2F2kc4+xEwn786kjothus0xPO
         D7ji+LkD62L7IxwfrqrBLk9lWnno0I19vtb+ybIGK6RsRSBdhT6TLxsjApNzTbGc5ZWJ
         IHVv69FKuD664joSRUu0WwJQ/uEb+8gqkOMI7KZ9hxhRECjnon/DDm9grSdmuH9POFsc
         CnsOvfKs0+HV/BbcnWQLnly8RqWAfgnb11KIQz1uvyQbMaJB340RwkRIBbyzqheclh/M
         gYwg==
X-Forwarded-Encrypted: i=1; AJvYcCXaLur2iYfmnEtSC7BI3UWA9wlY6Vx8JZcZbdtkwoNkXQPFCOgB/dz/sWLfLWWZGxLxhLvck7JkOw==@kvack.org
X-Gm-Message-State: AOJu0YxJKbHAA9k1VmpUVmoR5JGs0DeBwZPyxgZM36Zo5KN9tih4KmWB
	q0opj1+E6UWuCrKqshNeQXO9WFnr2S2zt6o1qyH5pRCsqNmrXmjBFe00V3/i4aWPyYc=
X-Gm-Gg: ATEYQzyBAeMNdB/51n9hsOLAAsxzLGFGuCZmlK539xluQ39q5WkxjMEyT9ABZYUuTuv
	eNEoXhRvxEvTVis5GaFCi4V1WC/fKOl8/SvpbZ0iIHO8t4BIgMpFmMn240DdJHkkZvZSjPce/LU
	+j6aIGqvcCVcJ4SCN/gIorDDm5HqaUAS4KlsKsKDHVSSUVKuuPUj29b9UlU7nGj/VUnDl4AEMFU
	XDnZ783kSEc/5++Z8e3cfj3Rzuf4MqanbywNsGtn6P4tqppmXGv9gY8GTRbfJx8hQrGAavq+fFk
	U7G0odf9381Uw3OyrI8etLyBE97LAI76fvquhWHi4LSoZe3lNrDjtjjtrbUu4rvsrdR8/mV8UId
	uW/aANASDKZDANM9xNtvpK+Mz0OuhCjdVhrs6FuYxiqkanpzwl0tfOBlavPiJjEXUb01uORoWWH
	2mZ9tNpze7kd/bj8TDfQnsxXEyfeG8oPVnZG3x3Rj+riQ+/AsSGyM0P3+kKDRvcmpCiQ==
X-Received: by 2002:ac8:7d4b:0:b0:509:26f4:64e9 with SMTP id d75a77b69052e-50ba3994b30mr12539711cf.51.1774582422102;
        Thu, 26 Mar 2026 20:33:42 -0700 (PDT)
Received: from plex.localdomain ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89cd5a22711sm46519186d6.27.2026.03.26.20.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Mar 2026 20:33:41 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: rppt@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	pratyush@kernel.org,
	skhawaja@google.com
Subject: [PATCH v3 05/10] liveupdate: Defer FLB module refcounting to active sessions
Date: Fri, 27 Mar 2026 03:33:29 +0000
Message-ID: <20260327033335.696621-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260327033335.696621-1-pasha.tatashin@soleen.com>
References: <20260327033335.696621-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1726F180006
X-Stat-Signature: z8za7ue8exq9quc45nxr7fafzf5g16q8
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774582422-849078
X-HE-Meta: U2FsdGVkX18r83L+EPYGuMPrS4YtE4HlA9Lsj/BOG9CAGhjMAQRoVeQ1UuhRh1h14WSb/DH6WQIgTrGuplNQFdP5lclUJHtHYcAt7l9H+KskbMnCUYy0dTHbVgiIw2J8nZqeINmdeNWVfM3Hegxm4H53oSC3W78gydMcXZwTnV0zSZgay8AlzzSlxJ1Itrnqo8exWtBYfMqDdiaW0F0hmZGzrfyWxP8cjyujfWdx71HxGiSaJNJfNoxv/cf1LQn5C8sTF84bwMn9i2rfmV6OsrHr+XqJ5/2enQULVKsmvBJba88DwDsCoZDQqMn9csOasqvOt37WsVLUzTr/IET72EnKasbKsvwkt2r1rGd3OhnsvW3NTB8GSmqW/lpGK34mFCHm82eoSBa5808ICCgMUOHUZDc1wwjH7zVSg36Kk6FXXVYQ7r0copqIB1qGus8tNuhtIxJ0ajRwPssqzAK//6FtWCFztCcFjqTIPS3DuoUTazSd+tTwaAHrSgaOHgTfj8DHiF7by2ZsmpTRzQtzUob8G/NyRssVjxck1hoUAGLNQSaSYly/RBu/G8YC07m2KskwpHjv1kpWgH3tsW7r5W84u0YsuIkX0vihlL22v/SiCM8z1JaA0Yxg4yaKyvj9Dz0ADTuWOyy6nC7iodkB1J3afVyAG6fvxEk+zQQB+wBXHtrvthvLRBQoJ/LHqnLjK3OEEnRPQ2gTielu2mcB1nLivDb1oR0pz8v4RjF498Ktbn3jADtVsZvVNN0kWEGW+fyiZcOLtzPLmc2Z4A3PdbdqfSFIzmpK+SI9WQiDsrY0adO4q35a5uXeRruUmTcjyMr1I/90Sff6ramNEsXQCZW3hShxwKmu9CCb9ao7aj01GlWqD01t2VxH7T0aPdq95ZW9X8KkzkO0amfp9XOc0J9OIiOLPmBL2NNvEcP/BJNwOHmSx1H3eNSUktjuVHXmfenB2qiBIMin0rf2lvr
 YVrRhYg4
 jGzAtwjED3idIzxlYO9bbKVSahHt6Bi/uuVlpca3aDEBkuV6pEtZ6IDhX1ylLQCShkaPOmJwZdsZ3USn6BApJDhM9QAb0y1U3Ys6A+7wG9rkrAYv+GE2hn2PuRhJtvjYCOccMFhZDC/ch14bW1cveEydUyDKJcu75cZyHftbQkpyUrmaTO9Aqv+0KpqZ0r4TPnR5Mbfg8FqmNexaFeZQJTnZmBRmYeHSlJtOk8fX1gmNNiOH3qGahU6exmlQt4W6nKaji84Sif+qifPzYcfXf9ZIaBJqmkpsXqvQGKd0CrXyDkuDDV7RBQsLrQ2BqwMw70+GvvTaj8vAxaD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stop pinning modules indefinitely upon FLB registration.
Instead, dynamically take a module reference when the FLB is actively
used in a session (e.g., during preserve and retrieve) and release it
when the session concludes.

This allows modules providing FLB operations to be cleanly unloaded
when not in active use by the live update orchestrator.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_flb.c | 27 +++++++++++++++++----------
 1 file changed, 17 insertions(+), 10 deletions(-)

diff --git a/kernel/liveupdate/luo_flb.c b/kernel/liveupdate/luo_flb.c
index 3c91d0008eb1..ce28ce9b113e 100644
--- a/kernel/liveupdate/luo_flb.c
+++ b/kernel/liveupdate/luo_flb.c
@@ -115,10 +115,15 @@ static int luo_flb_file_preserve_one(struct liveupdate_flb *flb)
 			struct liveupdate_flb_op_args args = {0};
 			int err;
 
+			if (!try_module_get(flb->ops->owner))
+				return -ENODEV;
+
 			args.flb = flb;
 			err = flb->ops->preserve(&args);
-			if (err)
+			if (err) {
+				module_put(flb->ops->owner);
 				return err;
+			}
 			private->outgoing.data = args.data;
 			private->outgoing.obj = args.obj;
 		}
@@ -146,6 +151,7 @@ static void luo_flb_file_unpreserve_one(struct liveupdate_flb *flb)
 
 			private->outgoing.data = 0;
 			private->outgoing.obj = NULL;
+			module_put(flb->ops->owner);
 		}
 	}
 }
@@ -181,12 +187,17 @@ static int luo_flb_retrieve_one(struct liveupdate_flb *flb)
 	if (!found)
 		return -ENOENT;
 
+	if (!try_module_get(flb->ops->owner))
+		return -ENODEV;
+
 	args.flb = flb;
 	args.data = private->incoming.data;
 
 	err = flb->ops->retrieve(&args);
-	if (err)
+	if (err) {
+		module_put(flb->ops->owner);
 		return err;
+	}
 
 	private->incoming.obj = args.obj;
 	private->incoming.retrieved = true;
@@ -237,6 +248,7 @@ static void luo_flb_file_finish_one(struct liveupdate_flb *flb)
 			private->incoming.data = 0;
 			private->incoming.obj = NULL;
 			private->incoming.finished = true;
+			module_put(flb->ops->owner);
 		}
 	}
 }
@@ -412,11 +424,6 @@ int liveupdate_register_flb(struct liveupdate_file_handler *fh,
 				goto err_resume;
 		}
 
-		if (!try_module_get(flb->ops->owner)) {
-			err = -EAGAIN;
-			goto err_resume;
-		}
-
 		list_add_tail(&private->list, &luo_flb_global.list);
 		luo_flb_global.count++;
 	}
@@ -493,12 +500,11 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
 	private->users--;
 	/*
 	 * If this is the last file-handler with which we are registred, remove
-	 * from the global list, and relese module reference.
+	 * from the global list.
 	 */
 	if (!private->users) {
 		list_del_init(&private->list);
 		luo_flb_global.count--;
-		module_put(flb->ops->owner);
 	}
 
 	up_write(&luo_register_rwlock);
@@ -527,7 +533,8 @@ int liveupdate_unregister_flb(struct liveupdate_file_handler *fh,
  *
  * Return: 0 on success, or a negative errno on failure. -ENODATA means no
  * incoming FLB data, -ENOENT means specific flb not found in the incoming
- * data, and -EOPNOTSUPP when live update is disabled or not configured.
+ * data, -ENODEV if the FLB's module is unloading, and -EOPNOTSUPP when
+ * live update is disabled or not configured.
  */
 int liveupdate_flb_get_incoming(struct liveupdate_flb *flb, void **objp)
 {
-- 
2.43.0


