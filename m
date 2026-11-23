Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5513606A68C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 23:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZDo3IMNl
Received: by kanga.kvack.org (Postfix)
	id D15766B05B8; Mon, 23 Nov 2026 18:39:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6926B05B9; Mon, 23 Nov 2026 18:39:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDD1D6B05BA; Mon, 23 Nov 2026 18:39:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7385E6B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:39:40 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E344DC0A79
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:39 +0000 (UTC)
X-FDA: 85468003278.23.3872CD8
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by imf18.hostedemail.com (Postfix) with ESMTP id 21B801C0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 23:39:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZDo3IMNl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3uM4EawgKCMcqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=3uM4EawgKCMcqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795477178;
	b=Gxn0d2zTWfxz31k+R56cSwv/neY6xhYTUJ2WWOHKimDDz6P4Zkc4vT2R0jBZXJkoNoFf3g
	LoHjuPj13VOC/PopoHEGAxZTHTo/N6zYSgWhZwoiSe66epWdrqJaWaOEtm9FGLwY8s+7Eo
	E5Olshus17Aa+so4VWmuD0X+/stALEA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795477178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/ZHoT97tqf5Dj8g+JDW8nW3DDYyt8I058/DSNhpOZoc=;
	b=QCQ006krC1+rjNZadUQPqXO7cps6AzLKDrQxem7fRz4iZcbo+64Qo4GdWgv0+1Ni/Ds7Da
	415r5tiGB1yiO4zr/vCAfGUSqIbVY1s7SY5DBKAIT0XTeakZC4ZzVip56lQ6eV11zLrbNv
	Gd7YSCg6WXt7QEghD3etoWZhH9S6pkQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=ZDo3IMNl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3uM4EawgKCMcqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=3uM4EawgKCMcqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-46617932071so1945575fac.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795477177; x=1796081977; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/ZHoT97tqf5Dj8g+JDW8nW3DDYyt8I058/DSNhpOZoc=;
        b=ZDo3IMNl9KZ8t/UBWpX5zmmsZyL0F3fmvB+hf3YErjpR27/+grlPj4FItCsDl4t+eF
         FU1sIKDEeMzIAk3ksFsKcOneY0mfk0mFopdutAhFUP6dwImKGWL3jMxw6RjbaAOJzOKO
         zQkKwTfoKiCoP0f8W8w29B3GLddVVPaG3uOBCF4yAfTKJ2O8nJceHSRaES7Ln6n4EUbu
         fAFZj6DWmln6khmW5ox+gMWLngmimbVYfkr83BYLPTY+GxIJ1WO8ENEPY0tIaHhJM+9F
         ouVroDiDi2s2Z/FmiUmJxlV9C8pqmOdy5c0whaZNdqDfBvTtV2FTM8QLkERNP11PKKM2
         3T3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795477177; x=1796081977;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/ZHoT97tqf5Dj8g+JDW8nW3DDYyt8I058/DSNhpOZoc=;
        b=rSH3vPmE0w7Km6u5V6UpzbDd6AuR+Yjy1BEi13wq6o0qvQ9E6GTs4MyeQNTUkliRjt
         zay8RO5D5pC9FblWzIGogFNsBMsLZD7BNzLzA49VffGZ8wdFxg2zxhTziwnDJrVoFVF+
         0CsNqbmU2uVhbZXZMykxJNipDQaOhu7JDdJRC30PuyCQ1cfGMFJZT6P4Gdqw5z8buHTI
         kNStqRCVJEWVMlwEXEMtHrMV3m5Yzds1I75LsH8OLoIyuxR2n7p2ywTmKXHd53twzCE6
         roStBEXhpXMKLpAGdv14DUtrhk57DnEkHwVpyDcEJAn2DhIMby/B9KA8Up0M89sTRYiQ
         f7cQ==
X-Forwarded-Encrypted: i=1; AL+hErGuI7Fc3ivg0XDCvo5NMbw+YbcI6QzvhfcEDaFJOnThGe3h6NZaYy7ClicmdkPM/TtUto3EVLt1xw==@kvack.org
X-Gm-Message-State: APuU4Z95XnTUwXtGFoA/1r6Z3+LZUT0OaADD1eD2d2wsKUg1sp3bmQ1q
	iE1QV5Yrx5Ei+U9NOcd4Y/Cuy46fjnldb7RcUrOASCTH9uLdAjDuF74jP2+QjRHr4KF1wFU+mx9
	yVFdazV8u/7bU0A==
X-Received: from ioi24-n1.prod.google.com ([2002:a05:6602:c658:10b0:9d3:b408:7991])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:2381:b0:50a:7162:87df with SMTP id 5614622812f47-57a06b2491amr12786319b6e.2.1795477176976;
 Mon, 23 Nov 2026 15:39:36 -0800 (PST)
Date: Mon, 23 Nov 2026 23:39:11 +0000
In-Reply-To: <20261123233924.3970932-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261123233924.3970932-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261123233924.3970932-7-dmatlack@google.com>
Subject: [PATCH v5 06/18] liveupdate: Don't WARN if tracking a retrieved file fails
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org
Cc: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Hugh Dickins <hughd@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	"Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	David Matlack <dmatlack@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 9unr3c7xwhkhsixp9mid3eyphay9fjd8
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 21B801C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1795477177-84274
X-HE-Meta: U2FsdGVkX1+Yn7iBfpZxp+0ZgpKXdgSL2VBAwIbcSlXsLh/4AZLMUN/qHcS2k+jMf8MtrY1Fpz3QunzRTt3ZXj1BMI9EvpJfrIpUa6Xgv633grfCVm4QQVKG/QbcxKhYn6n/jkGZig0xDYrRhjSDJZDVLLHoU5HXLWmWOLv6BMdhO+0muYwvGmsNJOvSRpSL6D2bb/i6l+xXDIE2zhll6UnIwKprSnOXrns7G5zjNb8IpSpvrYyO4hUDZEqefPiv2BQPSP5hPqf5GbgqnxaujIfqo3UF3l1OYMdECzZD7aOHSOeYba5aXcgsFrzj78w210nZRrGPqsnlFlJGFpHtt3BT9dNsAy2N+bfcyGYp0Wwlexe0KdL6D0ImwrJo+yBmTqDLAXns1sQ/GFzTJlzxeR0+cHp2k3PbKQ5fRglFXDIpZD2boI22VHHjNR21Wx09wPlfBx8fYJuM5rfJRn3MGFnXAFUPUc+7peCn8rzmUYASxnSCPEOE4n5l/A5lf74SONJ9BvYLabuev0+bsTTtjrTQvdTo1rHQOTFiL1y3eSaFdOo5I0k2mdkZLujk+aUKXOhGm9EJp9SPQIX2NCcd/X/feJj2GKHTA9yiIKLJmUmWlyXnA1aL7LWSH1ZCNvEth1YC3kXqoinfWIXqEvU5TQh3o0+adFO6x4mkWztq80KjRVpA0+1Xwd6WTZfefplkUppd6Vqu3hTXVYN85WdgQVQ/k4pb9fRzTxhjcMFRjwW32D+bVdj/pohkw25u4sB739a2wofrHOSUPfqCey92uo7GB3rKp1c3c1diRmQY14nu0/s3oQooR3QJZn30KzC11Tmsc6vdg/fLpL+TYK/yJeDIf61/6pZYeiVZq/mWRI9NLvkln7Cj/y+m9MHLq+lTE4o76jwR+ChO+v8SDbHsDN5K0YhR2FOLC3nOb+hKn9SrBWe8SN9GDGPZ7ji6ANkx8QFiuGCWxzY/lBG81yv
 5K4qaC2u
 iRJ/Qh4JnAIQxknO5diexhTAZ5EOgPTlCkAE8bY54TyyzF336mVKaf6DahkEt0NN0ofMxF/jriyboa7tUwplh+J4XwEgT8hrOvIUAPhGoe8hjXoVxpfT3dToPAolX1r6Iflvi5NheDPVlOBMa/aGE8b48ogvv6w2GPekA97T37ei8XPIUq9i9rNIGAodooPKrRqSh94epdpGDNduUPB3Ny4xiSgJNEVz66BchNzcaHoS53aENaJCNrj+sUMAIZiylSSyviPm1Ef6GcFYyTO+CU6P/IMdfb4IAAZlpGrJ9JPXAxq4RK7YfGM4ZvT3yfZHHfhx2oi7EG72GbghXpNoZTE1FVk9CqBU0TMBgnngM6WfoR5kG2imuhfaXUF+AwSsRVVmfNCnhDYESAuP30OFCuqmEPCRF4i/p7R1iNDBbz8LORp7JR9tAdjSySIs+3Zq5ztF9HpaItj+nfXN8u3+P9pEQvTbieEk9FZL3ORDkMdtdMXtjtfkgSeBPfABa2/5LESuKuKwnk7ehZrohsiZefn+OrvxBUMM+r7nBzkw+TJZYnknb7txeICwEbgyd8g39WJYJXdYv9Ho9ivMZG061OFLaFPgVL5xw0UDGaKwd+6DeCwpMzRKANHBEPks7Xo51+sy8EomRNwtDnl3eL3JDQR77UkaHTzMADIHfTndUX+YEntd+hCzTe9m1NbzGNGRFUMF2zT+M6KD32kUafr+wr2mCF/s63mskeQLU+dDySmqWY2d5WOVxzjHsjqJOb1fre1/yrGKQqbNdJGE8bo0HB98pj03W2QB7OU5IAJAMN/5LtcG7+GCbmgNTMfMxOayj14u6He0QLuHmz7Zk8EHmF6U6z6I7tRjop2vlBLt9zcoJnis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Handle a failure to add a retrieved file to luo_preserved_files instead
of triggering a WARN_ON(). Make the failure permanent, and keep the file
until the file set is finished, like any other retrieved file. Only warn
if the file is already tracked (-EBUSY), which would be a kernel bug,
since a retrieved file is always a new file.

xa_insert() can fail with -ENOMEM, and userspace can trigger that with
LIVEUPDATE_SESSION_RETRIEVE_FD, so warning about it lets userspace crash
systems with panic_on_warn.

The handler has already consumed the preserved state when this happens,
so the retrieve can't be retried. Keeping the file ensures that its
resources are not released before the file set is finished. When
finishing the file set, only erase successfully retrieved files from
luo_preserved_files, so that the id of a file that was never added
doesn't erase the entry of another file.

Fixes: 00d0b372374f ("liveupdate: prevent double management of files")
Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/luo_file.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 9d98438b0166..0755a6478aec 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -675,14 +675,28 @@ int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		return err;
 	}
 
+	err = xa_insert(&luo_preserved_files,
+			luo_get_id(luo_file->fh, args.file), args.file,
+			GFP_KERNEL);
+	if (err) {
+		/* A retrieved file is new, so it can't be tracked already. */
+		WARN_ON_ONCE(err == -EBUSY);
+
+		/*
+		 * The handler has consumed the preserved state, so the retrieve
+		 * can't be retried. Keep the file until the file set is
+		 * finished, so that its resources are released at the same
+		 * time as those of other retrieved files.
+		 */
+		luo_file->file = args.file;
+		luo_file->retrieve_status = err;
+		return err;
+	}
+
 	luo_file->file = args.file;
 	/* Get reference so we can keep this file in LUO until finish */
 	get_file(luo_file->file);
 
-	WARN_ON(xa_insert(&luo_preserved_files,
-			  luo_get_id(luo_file->fh, luo_file->file),
-			  luo_file->file, GFP_KERNEL));
-
 	*filep = luo_file->file;
 	luo_file->retrieve_status = 1;
 
@@ -780,11 +794,12 @@ int luo_file_finish(struct luo_file_set *file_set)
 
 		luo_file_finish_one(file_set, luo_file);
 
-		if (luo_file->file) {
+		/* Only a successfully retrieved file was tracked. */
+		if (luo_file->retrieve_status > 0)
 			xa_erase(&luo_preserved_files,
 				 luo_get_id(luo_file->fh, luo_file->file));
+		if (luo_file->file)
 			fput(luo_file->file);
-		}
 		module_put(luo_file->fh->ops->owner);
 		list_del(&luo_file->list);
 		file_set->count--;
-- 
2.56.1.809.ga0b61035b5-goog


