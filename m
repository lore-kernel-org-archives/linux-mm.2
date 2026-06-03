Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03E27CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EB186B00A9; Wed,  3 Jun 2026 11:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69B086B00AA; Wed,  3 Jun 2026 11:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589E26B00AB; Wed,  3 Jun 2026 11:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 451566B00A9
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:45:06 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 148961C0BC9
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:45:06 +0000 (UTC)
X-FDA: 84839025012.29.57DEE8E
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3005EC000F
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:45:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jgLUsBIa;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501504;
	b=zzyLMTKVbX48q4NGX49BKLl7jKGXn4ZDbP6woohlIEgSIkj/HI1QDl3qDyfMdW9mi0tlFH
	M8BXpcaCjIbIebEDmqoAQXd4yBfDyuZ0v1KrxqoUSx7cvBrkFXXg2hZTAbcdXyOImkxQk8
	QcwQpXgsbfAj50aIR7wk57r0ayvdov4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=jgLUsBIa;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.171 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
	b=qFswIbMNLKunrOEqgQXiN64xVWkafhIyirCcfAg0I86HuInOjpFSEztbU394P1FHvCWdIb
	ZcM/gxPHSj6mARRcTs6FVWkV46KyLpwbm5ufdJlMnLDX/yOpO4wo8k+zLiZxm98KmVWCWj
	yS/93kvl/cpRReVv3mj78S0cy7a0Phc=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-915336b83adso595581585a.2
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:45:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501503; x=1781106303; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
        b=jgLUsBIaSqABGTh3g6y1OlMl13a219sguovmJyo+doohJS2g3Kobv+vMsX1tOY9L3Q
         cEiQ1UJJ+AGH+pOzLSi0XO3kPa6EAw1evzT+8dTm0mkXR6XYESy6qiGAG2e1D15rwmYD
         EoYoQVi/G6Ent+2UXWz4g/l79yeguPd1vZe0UlWTlmf2Hwu+RsPTMJhPQ2Kt81pDwz4M
         iO0BGanuXOUMLHmxyKazvY5BJ3KnW3FwUx3P+jOQYCgAC8IhNCZmZmx0OJiofg/VSxoQ
         b32TfsHfN/NLczacVYkAEzusoZZ+69WpCUGwxqtqPLaWIPg6HjOgNMQTAhy2SvyotCP1
         RoMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501503; x=1781106303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=M0UeBGKKNpBDiXtsHx+XK9ecjuYaKOuvdeJHksP7ylQ=;
        b=TMoz8gjOR5o4ZEXv6wyLzb/0FqHcl0mkNprRHzF0E5mDunRLWSL/VeCUwMtrcC/8Kk
         VgVH1+egwxxyTBpUAu/T9qg3nZr+wFNTsrcIBrDck24WZSEGphGgHe5ig6IFiGFmb+CZ
         8J9gyak9ua3Phzg+XBN337rbaaZ3sGjjSNwcvekJf6cf+IAcQ81g41v1CRbT1dRDLtN+
         OG5HnxTD6ih7KdPJryiyPibQYGWfZuspoOR0PZBeqKTXHxoTW4iZwWAwqowKgcENJgPw
         IZ8+BAucapVfH+Pzr4h/pUOcVGH7KTyaZmGQEHZi0LqFrL0GHu6EKy0lHkU7MW39lMGO
         L07g==
X-Forwarded-Encrypted: i=1; AFNElJ+b3NuSKdHea4MlEggaLEdkVX7ymplJAx1/4ebsipvdKJujY3yuRl6nSotXP3IZClnoJ3dgFiX5Pw==@kvack.org
X-Gm-Message-State: AOJu0YyobR6vMHOsPvcLoVgJGuOjukBHLGoePkfWKgeV14crR6stotw0
	fv/2AZKDHC9NyJrSvJYHkmxA4AacMxg2GFT7klJYQfcim3ZaxEgBFbgD8Uo86RG20WU=
X-Gm-Gg: Acq92OHP9ryntjFWCzQhpoFzU7ZSPxNywcosuOyr8eGV85wQQtwqAFue4g2C5eQzUU7
	eVBTJcyVs5qm+M9uCi4WdlQh2O7U3Ryarzy37rPkGdGs+ZeezLuP7OGy7SHfZfv9FVCBmRIlmAR
	PhVTOAnotgenAIRAqzJDTswmsfX+ymaYIvfWSBOHbWM3rYHYD5enFq6x67vHh4TRrVK8kwdDZOs
	AflneaH/cb4ZMFvd0lrvzuhSxGdqD/+lNGS4IxYqp5EEGwl+ZoNxEOO9hmceJity1NxZ0rU5UXI
	rvx9NkiSuZg30356mIXkKs5xJBKCRcXkTXiz0T1DmeIZo7nPZzmkyPXmJTebkZX0jFtmZi0lc3+
	QtMpQBzxCFRpFQrXjEV+X1Aix+CP8mKGg1kVqcGfeD4urlSBdcooy7/FNd4RfOI0HsyfeUh6I6B
	LUEkC0t6Xe2T1TN+ZetTdkC45zGF4OdtQTLzD+D2/UuRh5xg4uQCAK7Bhwujwstw==
X-Received: by 2002:a05:620a:1a09:b0:915:4212:c483 with SMTP id af79cd13be357-9158a7dfdb2mr674935885a.45.1780501503068;
        Wed, 03 Jun 2026 08:45:03 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a259428sm273352585a.21.2026.06.03.08.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:45:02 -0700 (PDT)
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
Subject: [PATCH v7 05/13] liveupdate: Extract luo_file_deserialize_one helper
Date: Wed,  3 Jun 2026 15:43:54 +0000
Message-ID: <20260603154402.468928-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3005EC000F
X-Rspam-User: 
X-Stat-Signature: obqewre3rj4qdjtp9wmsainae7phc4fq
X-HE-Tag: 1780501503-20350
X-HE-Meta: U2FsdGVkX18VZVZf8CfbDiS61w+Kex7DWbsY44TCYQ+De8GKtVfQoRaIG29X+/OBwA0Ic56RSajrRsAsnF/ujF0/gNwOfKjWTQMgXJhTyt3dgE6FfNx+WLz01JBx8P/bcga9mZcJSeM6j27/q7cwfNGtnE2LgaIIW6nKKlMsJtrWwJJs/FgxO9I5TuT5csHuAdA9sv9BapTeyuiFUc86ULkQJ4UjGYHBXZsqkV58gQEr+sh9Imbp0eei3Hm1g6NDRr/03RUD35zRiBv5exgaR5WglHA30xxKYXSNsF/UNwWdypeCnoUCmpC/c8fvafSnOvxmZT31eZdVt+Vo68eVETkpTpj2/YWbeNKUyZKHERHi+Meo3AhITRw4XptOMIM6+vDsLcKYAu/SqIWSun9pfF35fHb48h6VPSDJRCHt/+fQKAJ53HdISSsc5J7NjFqWo2cwazQQmNXAaT4iOEJ6/Fg5K/kYWzIBBJtdttmFqp1nbATdEwSA9rIEtxUPQ1BQq7goxkimAytqRJ9DD3Uj3ud+rt/FRFZbLLpQcJA8ZugKlOhVi1rxzVWRBdwo7r1LTnITiRoZIsbzwZwunLF8kyICWzwg+ERSKUWZcH9qLTUycGSdWCVSO0gnYSOqoPiLz764Cr8FcXMbS93Dc4Rb3PfwAmadfN/NAkzsRegBN7E69P4fgboApOYP3zCVqYQ0XKuSRXBmhbjHEZUsRpniG73cCwp5cWaxK0v7yqVoqDWKf8AKUcErYzecgOfPFIWToE4MuDSCtvo1rxY4HZMoiGlYBZ8WAejHxicdz8ud4R/IbULKhUgK2QeNovAVRtIgSz53GoFbnlDlRzYkP+ucbRURgGB6Psiv/TGFgyzESTAtBZI++9Z5wuFDCtYdlh5kEIjsIpYb23TYM/7PUeI6CVEJs0Z2SUAOGUUT/Wrlf722KOqg9q+8uKoalxgfEzhvU7XtyEa5uaATBEnWMW8
 GV1v1K2K
 GRckxOxjcxGjjX2TwzrpdcBX95IZwXxoceF74Lh+zh2BdJmQRG2WC1vAdL9lkYlXOhVhnDl2ega7iV2UhyClrtY6k+0iqwcvvXhVHB12z5XPgm0Z7qQKc5qC3OGcNJz1yslF+W23zhno6g56ODxAHnqtW2BhWOJqXpaiBfpKc8nrcQWR814bkG5+uZakNeTSC6d9PG8HnURR/8ZhkfM2nx+gU+Y6xpya9VLIjGM1iwTWWtR3sSyKuQgPU8Krq3nBsgy4N0MJ9XpGmN7f8dN1t3xWDqd9BN8BdmBl2YDJAN+bNK4SnK2IwuyNf5aePaYNERgamit5tsJ7BehMMvdC6VSrpaD4piUSgwFvQ9SUlf4k3h0CNOPg+WfCt3KjaClUx63rYg1PTtKcHRGU=
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


