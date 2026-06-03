Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20AF2CD6E60
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 15:45:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 676756B00AB; Wed,  3 Jun 2026 11:45:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626306B00AC; Wed,  3 Jun 2026 11:45:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 515476B00AD; Wed,  3 Jun 2026 11:45:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D5E66B00AB
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:45:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EFE9D8DB89
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:45:17 +0000 (UTC)
X-FDA: 84839025474.04.C9B55A2
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 02500180013
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 15:45:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Vizl/E6V";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780501516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfziVgpqRfO53l/kiKYNLloUUY6f9C5CrjqJQDvl8iE=;
	b=ktprwZEwuj9EqjIDRuFURIj4V36D491bqj6DKmNU3S5beYUBklBeiGW8uO1te5GX60EHvF
	RIA/ixdiJoK+clTmXP9Rnnuk3+zUIAqXEtcJ+2y2n0PqWvq3NljQeqPQs+WT24na1Ouo+D
	Fwlrv6dK0ilwJPbW1FN94TydxQBHz1Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="Vizl/E6V";
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780501516;
	b=6TzW6nxx/bBhj1RNvTJi1KuXsJ7gAb9Ft4qqnYIwQXqvmtzmp+gSjhYaa/n+DltIOUsB1t
	5PXpETJSPJPLl9ungO4BXzIbHXCzpLxajka8/SnI9bJReDM05rnvuc6el+OzWrTRGTJ6Ut
	Y8enMOh4SmMLpnyuft5X8rwsAcg9gSc=
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-91591f19716so82990285a.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 08:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780501515; x=1781106315; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QfziVgpqRfO53l/kiKYNLloUUY6f9C5CrjqJQDvl8iE=;
        b=Vizl/E6Vas1t2weYmherl61C4Fllpoj8YwYlbkLiMiyUEY9n/GnRPUNSAzlkgrNfNS
         J8WG1nMD8L4hgBFvYkrUiDYqm+Aahva+++KIkKumNQr+jgO+APi/HdGIa9tAObL7qHT5
         SXqqsEf3vGqPfuVVaLSWAyTXqIn+9J1frGBhzQLa5fx/w83NTsgfUP/gpRE6hVv0M7q2
         5nPVLaw/9358YBKHn0bYNEZzeumyePfqH2XnPWkQsuADn+YV63cFVB8DO5lvI+3+aJxK
         Yclrc0e0XfM5glhA2sAdn4KP+yDPAp9CGZWVriBMgkubeuaNRq461Ioy2Mm3HOgrylcD
         qcRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780501515; x=1781106315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QfziVgpqRfO53l/kiKYNLloUUY6f9C5CrjqJQDvl8iE=;
        b=YDbiChpX1LyXWa9PjiKJPyzF2CihQC/ZoGmfanr4GiY4Yzg/+heWvSbBBg+byMXaHH
         xWj9UbhTRe2ZRhpI3ve1qgNJPDzn2wpTHQ7lbUo7SDvgsGcmGGaNHea9pHaLxXUUsaMQ
         w7mHMil3qCR5VphEZBaYFjnu93s49Z2kYozUoN2oEAmp5JaQR5BYJ9Nc8dWK1tsq0CqS
         NSB7zEVj/L4qRlWmtC50Wt/DTHXHxsp3RIxmCLKg3Hhr6iDVAw5ngSbkFRwwVCToTF1g
         YRYPHfg1lHk09n/pmR9Co5sTnfbFgc73tohBDLE7y1ELaNllINsKLeQeGh40MfbSzvnb
         foFA==
X-Forwarded-Encrypted: i=1; AFNElJ+mxES+81+7M1m3XIQNNMJzORs+l7dlEEkNMID6W5pVhdTOyFaR4mr1+eaWqwSlDQAcwzaa7ZfI4Q==@kvack.org
X-Gm-Message-State: AOJu0Yxb56oc+8VeWLNAXXZjNmapr042JQ4mFWjYg01BrZPgrY2Ux2Sn
	hnI+9vJ6YjLU8LUFCgl44Ja6p0JC7FBEUpeSZEgIqTDG8XCZARpryLxuixfNR74sqbaN/7pf7eY
	QRECA
X-Gm-Gg: Acq92OEcficGGqo6XiGIaW/c7MjK0UF6CunRtuNhemc1R4eV7thGLeZ1XFp1Oq136wI
	lzz/wR+bbUKE6JwtdfMfEO3omM9whO/ozpEkthZk1Vl1E9epj5H5OK8C9M4Ad6pfdP8h5b8U+Jo
	sKIcxgAQq9MUBDicSuBS2N4aQnHCB8/mXfI66rnZf03QbTqlCUeep7FpDIdlAb5OcGBg0ol7GT2
	F1tHSUUEcI79eWi+maV9joeaRhe1hJozI/Q0s2+fcx0Qi6bUplil4xeZAyttSub01xjMnFFI/eH
	4B7Fh1D6WAVAjZPLkVSbGvqkRNH+YQX37ISuMVtW0CRqRpczwa8z2skZoSHFWI5wM/R2KkPofFq
	5LMmSk7JaZrnAMwHc1TwMg/GO7hwXr9UDPppXwf7o7ZNsZOjAKAFCS8Bhb1Tiw8hD/rsr6kQUdV
	twr890sfO6EiO0ryI/PZYlFGPM9uxheAaSPYhJgpmp04Lcvk577XgP/bt777Eb5w==
X-Received: by 2002:a05:620a:2406:10b0:915:6c4d:d74b with SMTP id af79cd13be357-9158a7aa7d7mr477899185a.31.1780501514839;
        Wed, 03 Jun 2026 08:45:14 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9158a237330sm280242385a.16.2026.06.03.08.45.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 08:45:14 -0700 (PDT)
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
Subject: [PATCH v7 06/13] liveupdate: Extract luo_session_deserialize_one helper
Date: Wed,  3 Jun 2026 15:43:55 +0000
Message-ID: <20260603154402.468928-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603154402.468928-1-pasha.tatashin@soleen.com>
References: <20260603154402.468928-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 02500180013
X-Stat-Signature: unpes94m8soc55fjyp1qop4n9kttm8h3
X-HE-Tag: 1780501515-969086
X-HE-Meta: U2FsdGVkX18MUgTzqPk1GvaOcuSHwgcAHEfSgf6qvfoVygnrS+JEyDxTDKO1aG4le7IjfYFGTiRCMHpKWPovBcDQ3ZvYbcPC07QIskkcvqfRP1VjhpyHGIo2gZqFi1H2+0wNK2k/iNgu85COptGlvadMzzoeTAYTAGhNeBiyNgKUBgpsZZjQKnhXQImD2L6v96v6U06xoAR+TdXbRVNXmuMnvUWLx3De0ch9uFHXKu8ll8jgJ8d+AuGgCaoVoV2aEBBm+3BzbpWNiEeNttjMIi4v0oNlliRANJ8QQZDnQsvxB8pJDmjyhnyz091Y6M/q8p2MAgBYUegUPgOOOWSu8K32hoylcVJjIW6HTdA1IpvnXWiMZJPRDWg+48e4Fkvjp+hrKWn391DC/ZYS247HY6YqcI5Vp54wC5zZlJBDZ+NS14IAQkbxOU1dJnXYj9BVVRaDq/tfryfNfUCNEuxcA9TLEn0wULijJn49LHDkziSOg9PPIc6N4UH/HR5sziKnmd1YX1b/+wAwzi6h5SfvQtZv971gRCxe4itHw9ZVO9nsRqQSCCK1vxPJ8HQkTK6T/aSXgEVZDYF5M/26aPooZzUwmuRAzK4NYdtgUB0iri3KVwxKleZUwr1+3wv8Z5GHYfb89faPIV+J+LVJE0CQMdjEgyW2dLYljAwuvlpbexBzhRwjg8hCC0nfH8UdpGH4GLO2ZvBVrcHbxlVzgcbT3tOVnVxpXzLztoHRK9rJxQNwXeU4BQgP5ZvN9clIIOUdF8TAgyqEERnpVhxmqaPixz+3iAqnbCPthjy0IK+QaSHdmQ7H2iWH3tLFFyfZAujwlGa+oZHn6DI5u8Jq+7PiC+kZowKJaSS/iElVDOCDA/+y4Dog5mZ6NwNhMwYMzTurgMQ65dTKbmVgkZOr7sP8ssaLOf5QdtUD9fil5b4RPOJJgzYtfxq6h00/4UtQZJoYu/+w8YK+Jru3GdiwfhZ
 15TvCkFK
 Ck5jGFohbgYObA3fvjcyF9NHez/T8Axtu0bVOVda/4/bmRl+XfKoZINruw9AscV4qRneYoWaHUvFJaqHtQj0mjTnFBp/IK5tyMuHf5wV7t4XTwVlwwM9LE/2t/4kAAAvbh08eVcRC/knqf5kqEUmyI8EYn3XrNlvWdoeWzH+S6D1RA3/MNHVZSOYo33X4GC8mz9C/nfw/XbaozHY8PczCvcrt2FMBz0K4ksLbrCdvnqo4dzK4BaYGaDrFzxDQk6MT4yXRgKih15VvG4b3d6qopk9VbxIrNt3V8HNt1Rz1DrGICoHWosGMX4AB4+uKAVMmq3/w0i52DYYa0sAGSQQuxc8+8Xhb912lOSSRjo1mprsbEbEF+Iz+HvAQabRVvlQRWZw+/oQB8DWI0nU=
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
 kernel/liveupdate/luo_session.c | 63 +++++++++++++++++++--------------
 1 file changed, 36 insertions(+), 27 deletions(-)

diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 85782c6f3d6c..1cd315e0f6de 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -555,6 +555,40 @@ int __init luo_session_setup_incoming(u64 sessions_pa)
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
@@ -586,34 +620,9 @@ int luo_session_deserialize(void)
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
-			err = PTR_ERR(session);
-			goto save_err;
-		}
-
-		err = luo_session_insert(sh, session);
-		if (err) {
-			pr_warn("Failed to insert session [%s] %pe\n",
-				session->name, ERR_PTR(err));
-			luo_session_free(session);
-			goto save_err;
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
 			goto save_err;
-		}
 	}
 
 	kho_restore_free(sh->header_ser);
-- 
2.53.0


