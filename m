Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72306CD6E56
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 03:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D6356B04B8; Mon,  1 Jun 2026 23:17:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9856B04BD; Mon,  1 Jun 2026 23:17:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A726B04BF; Mon,  1 Jun 2026 23:17:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 228176B04B8
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:17:31 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D59AE161BF1
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:30 +0000 (UTC)
X-FDA: 84833512260.16.A9F5700
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 12D0E40009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 03:17:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y+nQO5nk;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780370248;
	b=RnRGUKz5332WhzTaeTyEZSwXhnLsU/xdRg7NtMUP7gmW0+31JGPN2H+q+CjOpGToxRdQE4
	bjLLlLe+a2T52QagxknfH6WrAQZclQmRz2y5nTVbkDTmnNTphH6nPt0A526vGs1pi1V9HT
	CNpG61eZ5Z++MKdU7Ex6QCYlgUnJ5EU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Y+nQO5nk;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.169 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780370248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=flqTP+T3G7cekhEWLkwDVj+JxO0X/Tc2hrAvIJPKbfc=;
	b=2x2uJUALGodhLsWRVMCREeFe03eV6uZYN9dGzGWDQi+Wkm8ms9lWFQwOEHDkmdRoKy8Hzg
	6ZoglcRy0kBjbe9pu3hPGz4jj9YwV0CRGSFYde93GO40lIsBtD12g92nTDdTg+CXPK4rxo
	96CkrBRbrrdrvwIWzhgKwamV04wLIns=
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-5174a0beffcso24149421cf.1
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 20:17:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1780370247; x=1780975047; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=flqTP+T3G7cekhEWLkwDVj+JxO0X/Tc2hrAvIJPKbfc=;
        b=Y+nQO5nkZPLo7GPg5rT1TCal0dAH/A3811XVhCuOjeJrkH7YB1qpy+Eltua/fgulEJ
         9J/56a60zSdqicyGQzYAauplgoT2vB9BU7Gu4PgR8n0du+s0KDHPWwFljqK9/cj9yw7a
         Is0ytMDIe/504LyCsCmn0q2EkQFihbyWVubiUh049Sjeyfx6LWeL2vnKOJk0Nj4Icloa
         nJbgi0bD+wyF4uo56uBcGSJfr5clyWx2sFEtaK9WJZf6FZfifMrb4eEw18vVcbknnpHm
         uGG5Qa7GdMO5iF+RqLCx7fk7iaDQkVhRYzSI24NL3IB20KVGUppAOPwIcTKbQzTBq7sU
         PvEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780370247; x=1780975047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=flqTP+T3G7cekhEWLkwDVj+JxO0X/Tc2hrAvIJPKbfc=;
        b=Q/ESYAHNUyHR/DnfW43wrptQVzb+4I4JvqXZptQDxgvs6mZJB6EzjpfPaw+GBLFifl
         WcTtp6sopSobYJJwfedcu7yAnqdbAZK7UjcY07lu4CJd++zcqHI1jhgdlhgc6qiuoMmY
         JjcWdiT/QaHVS6qGI8lOvkgKcgoa8QzNx4TxVg4lsUfLJwul14ud89Z0hm+riSI1mbh5
         TYufYq2NjpaCbeuywOB/+pPJkvNIhV42PmE+rsStzGBo1mC0Y4Gb39m4B58EMo0s6fOP
         ieEOr803slc/4VlL2XERHiqS75C/7nZ3oApowJz0B2Z/sBFQeX5MFKptP1i2/ttz62lW
         ntUg==
X-Forwarded-Encrypted: i=1; AFNElJ9AZ6Zp/rU7a2WcAne5NTjCkNldTFeglLyKTjuGGiDpmqvhK6Ac74Fp6PBwlEis2XVHcS65C6DN4w==@kvack.org
X-Gm-Message-State: AOJu0YzzWwJtCg6QkGnaErbyUpHSTfXdE4PM5E9Siva+hyh5vdbnbmaM
	R9dsxSF3TF42LpdFk3OWqxK0OrxDNLh0DBd/R/KA5fuAQdoXmv4qWng26nbrgMnyiVg=
X-Gm-Gg: Acq92OGyV9PR6h799/2DNAsqo1R2SiTLIc6OmA4qhlim3W42CN72AXV6AyuvcX/J+as
	b9eG0zX/cdvSYkU2wl1jCfTiRahHbGgFYFA6iUK2f3hx3yqh5wvlRXlOa9d/7HaXO40/yeL2TUT
	Yba4/7zWy/ctVHiN7EK1dMEKNTgCM7r1HvkSCFZufOX8AVk7CAyeqAEVRdwrHnrp2YpoaFcoYNX
	6Ui+Z86j/qTK695wPtm/MYnN+BKRuz5Zt1rM4SqV0vEpdAN4DQZjaAmXb54a5HC2hKqo10zmB4G
	jZ5zPAFiQQc4veKOOrhLf/b97KJrtvVFQj9UfaBcMmMXzZxbNZegX6K6mp1QwQuKn8noZ1bxX4j
	r/gtNbHEmIA1Ef+Bks7a3i50gT/VaJTgpzVclWzgyGw+CAw+uhg/XwRoGJVF6cSouAGttfQCle5
	n2WPcae9GEF/ONXrx9XLAnL4vl9p8v8ffsslwQj99Wb/dkdUai4inU18r29WH3kg==
X-Received: by 2002:a05:622a:251b:b0:50e:635b:5579 with SMTP id d75a77b69052e-5173a73ae37mr218885561cf.19.1780370247179;
        Mon, 01 Jun 2026 20:17:27 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51741b29745sm71219081cf.8.2026.06.01.20.17.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 20:17:26 -0700 (PDT)
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
Subject: [PATCH v5 06/13] liveupdate: Extract luo_session_deserialize_one helper
Date: Tue,  2 Jun 2026 03:17:10 +0000
Message-ID: <20260602031717.197696-7-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260602031717.197696-1-pasha.tatashin@soleen.com>
References: <20260602031717.197696-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 12D0E40009
X-Stat-Signature: qouwtcbfui7msxqeor4nzto1toexp84f
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780370247-11218
X-HE-Meta: U2FsdGVkX1+m5sXm6n7Amxoyhc6Zc5KicOJyU72raTZ5UlCXSxXmCM7yF0xT/a4x2+lMWBPzddtcnqTcVJy86AgmvrG901RUeTyAIgGOV+kkFzTb/mZpilUqCrAXY/bxDmIX4YvZo6Dvb0ZuWrARDayO/G3O3HJkmHO+ahpzS1JS3a2S7wywO2yYbefBDosQ7jc4VjvQ+6nGtJKWPQidPlAo//RnNpI6fTX56HNG6tV3i4FdgiSF9ygyWvDSrwty8FaBO1L0NaJTkUScIVZfdFmltOUgtNiNJE9uvfGaz4gFmuCad7gIYFnaCD6sSgeRdS7khyv2jaQ8N3Xz/T+9bPM9CN7SjyIfk1KuoOtOr8Hhxl0ItbRIbWC95gKsDtGaZKnnx3cL44gsOtR4h3CImEw82qiSVPUPtSx9cTH11MvIQiDbtmhzLBXq55Y8Vxt1yMg+WvbkPmeCGhJsauL/C26G9UJC4xNxBhVDG4fRUjrkIxlToNUxJkde+hjwSW+qWYGRZQu/72R7KQw9ZPg/XduMsbCzd2v7Tfd9h0mqnuTA/jY9bN/jKni908n/gkg0LYLHyvKwO1XhCNRHEygUBaXj2OlzAWL9ech2PIPEdSAq9rHgQ3/M+dUBPEAQjPYXk/4e1/W2pLAUkg559uoPi4gyQ3LpE+mT1UfA130GXxFlVS3m/EKJpDDlKHwLO4WdAOBb3vsm4DEX8T6gSDxl9PYSNeqNhviVgWnrzYETki6dNNkpiZXLnL0ESeAMIvcJnSUmuzRL/vK/KPomBEDHqKr/mN2RKOgedEcqs4FmrucWGL8ajkKTzDPQKIzIoYZ/OFNtvEgCCYt4p50Z5tNF8BsqCC19jjy5iHMcYv2BPWisCEtn4GUPn2Hh9PjGqG32FFU1pshvVS7ZggNT+2zqffsusVxH53c/Rlh3l0F7Ue6zTWfzMRjcKcL7gtUwkozmNQPeezxsQuSfb4JV8RP
 QZP8C0+h
 y8LF80BRCtaXkj9gvhFVbESffgp/cooYWwqd/pin2zxyt4iB3D1Z0ORqvIiry5o3oTeOSFYZ8M/9qFHUzp4PUCvHuz+Eqpq0E7Tx0sFZZCm29J374ROoRdGh6BFgFJIBSverQQFEbuqmHoiKat4oSed4WwOE+3+jaK/fR+DdyesMrPgJrT0QfuhVGKOJ45EbjMRM/RLlehKTpdg1p7zJCE2UAQhTLReuUR63TRNXZtSL1ukmG7hRFf1UNIQmU00tFYBudzoPkWEYrvN2oWZvbFBoBAv2/90M+2/fk7I3bFEyPWmZDvcBZyKnNwwbkM1G2pvjQ1dvUyrsqScPX9Sddop2HAMywjeuUC7L9l3xmSq13LzUrIXDVsYUO2AJD2WoA3WRSZE9/fDlBMgU=
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
index 3b255ffd1bf1..9f72a8b0a9a8 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -553,6 +553,40 @@ int __init luo_session_setup_incoming(u64 sessions_pa)
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
@@ -584,34 +618,9 @@ int luo_session_deserialize(void)
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


