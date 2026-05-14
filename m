Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5233BCD4F41
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 22:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5F56B008C; Thu, 14 May 2026 18:26:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80A816B0092; Thu, 14 May 2026 18:26:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 720636B0093; Thu, 14 May 2026 18:26:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 62CBE6B008C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 18:26:40 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2DDD21C1828
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:40 +0000 (UTC)
X-FDA: 84767460960.04.82E0FA8
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 417B2C0007
	for <linux-mm@kvack.org>; Thu, 14 May 2026 22:26:38 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UOZiXJK5;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778797598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5DzA3L8/isnr0sHad5OpiNWdq+EP7DXQ1j7lGoEnI0Q=;
	b=jx6bAF/Z7jTqFo2Y+2UFQdKuHabxxVOb2snYhJCmeyAcZD7OLslhfK+bLQQFAyqQw3gqGb
	4vqyR1OOpq37Bnd6ucUvK8n4JKlCDvucGEpcmcbBTOJFIfKjjxpd502dpHdXRgJSf64/Yp
	Y+ITaPe0u6snlo2jG1CwqEM+3pBAYUg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=UOZiXJK5;
	spf=pass (imf28.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778797598; a=rsa-sha256;
	cv=none;
	b=cFGQL8dQT0yWC8Qyj6VyYVWpnYX+0grReRFxBdZfPDth0fqe5PEVZZHTeR2pWQ/T/NYk0Q
	uRLdH2Ug0Bneh5LF19CwN5CisR+Wm7C2/RaS3HtWZpwu9JZu06Z0HaFXtY1hq4GxBylEbD
	n9f3Al0NsZYmcNwhLtO+Qc9ngm952hQ=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-50d75bfb259so56813391cf.1
        for <linux-mm@kvack.org>; Thu, 14 May 2026 15:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1778797597; x=1779402397; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5DzA3L8/isnr0sHad5OpiNWdq+EP7DXQ1j7lGoEnI0Q=;
        b=UOZiXJK5U/ZAXLZ05vpDvUxNt/hVIOGArzJ49gQqqcri2G2W8KsRNgU6fs8ib+LBqF
         e13rdpz9AlM4acmRtYCRJBnTiVdFdN5HgflgmInaxMDe/Mbz2gyypJSX7ZbZ4Udxixah
         XusN2IqWoO11L9yt/srHeH7d8zzwa+PF0iZpAENuqj5clWy9X1xArp+8so+VxeeLCX22
         SeycX8U9GRzQfuLlFOx2YLB3HY3dbcKos3iBHlJF/Gu8mTojb4Q+D7XK/L/hTumZ9QN4
         DDH70FMPdQTemu6LoEDL4kL8MpbRR+8ZljwjO/bCjBet6CpJiRoQJIG+hgHCw30rK2B1
         Z+uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778797597; x=1779402397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5DzA3L8/isnr0sHad5OpiNWdq+EP7DXQ1j7lGoEnI0Q=;
        b=ImQ+blVTt54gS6wZylvyLL2fkOP3XmDDWmsoF1vpjrVbRWFDjkJqaPPKZUQx2zxd/Q
         OzI13C5ElMo+iJDcQfCSkVyGV+QY8mS8x+FDPcGPhOPvM+8ODq6R+kNSSM+Oa9FWcnoV
         8qcNBA53wKmkizQXEUZxX+NwUGLnlNHtCU9DjXptcK2Jzoba8C+EuX5VV7Mu2VMRbGi7
         9vTJwtOHzIhgT4fZul/WTAs+ow8RFYBFnuQacky8cUKpw96K+fKVKxTRKH3qSMcdAcBD
         VlIGHnkRs/ssJdkHKndkXyUhzcywKYJz8pFaOocci3BUYGS5rXC5JptzgUhICjKQdqtW
         Tm7w==
X-Forwarded-Encrypted: i=1; AFNElJ91GzXpsbyfBARjA09gxmE+VhvKcamF/aVLNrWHbYp/Zl5E0bv1i0DSXyEqUMujpwArkFOPLiXC7Q==@kvack.org
X-Gm-Message-State: AOJu0YywouuHkWMcz6MGzbN5nHu8uy/MwAajPYlBQv1kxee/v9/lhIPk
	v6zdxzarW1FBfB5g6MAns0hafK13turr8Ot/JlLxqv+OwNON+tJEk8F5l8n3vliE9ek=
X-Gm-Gg: Acq92OHWxt0n9bdJ0FOmtqmHlV2xboCQBb+0n2vB50uUArkmT/rq0NB9E20P8HYq/0P
	l+JuubUBrxaOlBDAtmValqA23Qam2cPFSTlx7LcuqIkJl1aaOu8wUr60iQncruHHUN10+IvNlKQ
	ngW1dsZbskspxbONu/d08n5cC0ZiL4Hjqw65h8+wMH+4dBdo6T3ixmEp3MPuu0q/CwZQuCbsUKF
	IdVTPxCmUjVoZdVZSZ8eF4QXwJwiN3F/vZBPC83Sx6cCeBo8ymBSDWAoDjzR9AE1zIDP0Px/yww
	xz+kgjEzZoze7deyNUvblp1CSnC1L80KUCcP8leQSpB9nlzpvj4TShIQUalgiSUnti2CrzOZm6z
	470PEze8lFjnTo+vhI1kLnPKwyoKq+kRw5DJOsPq08lPdqoUbtf8+PPE4DeYFJBSBfTfD6LezvW
	ktMiLRRedM9MR179m/ClY1CJWBXG2jEjVbbHLeGzaewWc52CabvzA=
X-Received: by 2002:a05:622a:1814:b0:50b:893f:7d93 with SMTP id d75a77b69052e-5165a00061amr19897201cf.2.1778797597005;
        Thu, 14 May 2026 15:26:37 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456ba92fsm28671901cf.9.2026.05.14.15.26.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2026 15:26:35 -0700 (PDT)
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
Subject: [PATCH v2 03/10] liveupdate: Extract luo_session_deserialize_one helper
Date: Thu, 14 May 2026 22:26:21 +0000
Message-ID: <20260514222628.931312-4-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260514222628.931312-1-pasha.tatashin@soleen.com>
References: <20260514222628.931312-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b9ujjg5jf9ms3n7fptagc8omqk43qx1r
X-Rspamd-Queue-Id: 417B2C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778797598-593407
X-HE-Meta: U2FsdGVkX18JIG5OULYlV1Kf29a2D07z/dK9vToPdSNUL8emRz0xptmolmIhJXDhAqDp6155Pu8Sp+zdskF3Cirf8jUvC5IgPLkOPBdCLDAZdNA67peKQNKKkGYegiVRhdL4Ou12BSSkL2p0+QZIlDWzFYm3OqNKbAYFcxDde8EAj2SC5clneRUI5DrLEEFaZJQA3f2dzsDSN7IRz77tSIWpf9VJaAM/JjVSDpG/95hm6hDD/Mtl8D6nT8os1A3phsscjrtbvtbHcCAaGL6IdIQuoNing59CfldxASZBr8T9UgTas2OXSsm8FDri6QH+WOMxFHKt0rUs2oQOUtlAYkhXvw5lgzvFs5ljn0I25qwqhe17j5tS42MlihcfL2lfiIkR9c9V3uTo3dEbt0+Yd8f6Kyixcv55C0CyIbQuDvpEb71Z//ZuWgeLue38uVsmzieSykINl24tV5wZqdPZtV2wyy3/FbBoDAT6JZd8Qnqx+sq2kOtuxns2WsnIp+3L6jdZgQGPyUTjZT/q5OgOd5DvDHy4pK3sOqZAR2SabXyw+z4zl1pE0eJAdePnTi4ymsZdKtZQswqHIxeF4PRDI5Z4hae/u04moFtdzXSpl1vlFsKT8cDVan9aIEW6UQRnJ8kzQt4vdyIm2YIuK+dCUlbBJcWQADAS7N9L1vlz2SZHmYqfgY2tJE3kWXSei1zkwVwxK4qw90TVFvxiuCwGks3Dyu3/+V6O16B1vo6K0CXLSayyhit2TiZstqvUzhfGKHGKDlTsgXyDgFjpGIrGgr4rLzXWudyxW9dAY77QYIYzrmQFSTpq5KxAEvU3vqaojZLTqI7U1C7h+Tlh30y3eda1NJ4pwU12jP1qcknx5KUwMLUDPpADzueeAJ9kPRnBU9YodI5SZgTgwIWSd5oeFPhnB6wAlq5t6z6RYotENMVpBZNxMWHGMknjpbUCYJLPwhT0oETMYaKjAo8N5vR
 +fbRtF7r
 UBtHu1owHhOj9a1vRRdc9F3KI6WzYcbDYeeT38UTiec3xFa5gSTXLpZLHILysbQbT6XoEyiIIzdxnwlgmwbMw2fihuK+Yy737amAgzD04P4Fgejf/ohfWAWuSANOk2Mj+3UptZ7gCx2p/Nc3322H3U2AEl9e7d+aDPaPbFLx8uyzdylsfLWuyGnYpLFh5q8i0z3vRA1HTljWh+Qh66Lypq5u4UC5B0C+9hCikEtTMzfBS8jvGMKwRc3VXVCsQJbn7ZvPJmzTc+hP7HwPBUFZyVUmTS3IwH5JYlHo83UGrwlHFq6FH1FYLZHBF7TigWNq2wrQwOFXnmvH+ZGbchWPw42jOxKUDjKq3nqvXTlhYQw70SuyxI2FskrBOyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extract the logic for deserializing single entries for sessions into
separate helper functions. In preparation to a linked-block
serialization for sessions.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/luo_session.c | 62 +++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 915ab9ce0f34..c08733a328bc 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -489,6 +489,40 @@ int __init luo_session_setup_incoming(u64 sessions_pa)
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
@@ -519,33 +553,9 @@ int luo_session_deserialize(void)
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


