Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB26606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=GuTuoX4b
Received: by kanga.kvack.org (Postfix)
	id A40C16B05C8; Mon,  2 Nov 2026 20:02:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9A26B05C9; Mon,  2 Nov 2026 20:02:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86AA36B05CA; Mon,  2 Nov 2026 20:02:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 501F46B05C8
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:02:34 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C2851202B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:33 +0000 (UTC)
X-FDA: 85392007386.21.3C8C0C7
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6AED210000F
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:02:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=GuTuoX4b;
	spf=pass (imf14.hostedemail.com: domain of 3pTLpaggKCA4r0o7zoqyu22uzs.q20zw18B-00y9oqy.25u@flex--dmatlack.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3pTLpaggKCA4r0o7zoqyu22uzs.q20zw18B-00y9oqy.25u@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793667751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNS9XkUpb0odYgcS4hw74G9m0QCGpHkW7/U/VrcLoMQ=;
	b=BHzorFZOkbLCQMfW8UiIEAEANZNWryoo6tGAP+70AbEN5kAQlam0btgvgoM/JbSxKgPb7K
	B8hwAh12T+w4RP+xmhyv/LeaMLKkU2iWi5JTnDfpzUjgnbTjY6WIuVHb5Bx8Da8l22uy0y
	qmHS/KuJAlVBFoesq+4XXAj1iJ3TQcA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793667751;
	b=4K63GVed20JrqAqfQRzBsQR0dDmULrr4PuXsntR5NU58lPGapJv98Yo1SQkzwf5vqBXrO+
	7EMW1pBkg0Re4rnGEZmVfOYyplCcV+l03BzYzPur0S6NRK2oVYhR1yYo4i4y/xSOQWaBVo
	DI1K4ALNhAwBBCEETEgWmX75gmi0sh0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=GuTuoX4b;
	spf=pass (imf14.hostedemail.com: domain of 3pTLpaggKCA4r0o7zoqyu22uzs.q20zw18B-00y9oqy.25u@flex--dmatlack.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3pTLpaggKCA4r0o7zoqyu22uzs.q20zw18B-00y9oqy.25u@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3ab926c236aso2840910a91.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 17:02:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793667750; x=1794272550; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cNS9XkUpb0odYgcS4hw74G9m0QCGpHkW7/U/VrcLoMQ=;
        b=GuTuoX4bj2C/WDpUHm8+dinfk7hztNJIrUQVPfuGkXW2w+3LqEuQllRCQUeDqniOHq
         ZKF2cnHPyudxrk6IhWFcq1e/iZGD0+7h+E2IQJvnb0V+V7XElvh8cOTlmE+aTzeFC/Vw
         ZkldmhrcUZx/uD163uMMrbbjLuGbbzBZI5+wiLPYAGgLI2hRo1HLNjGxorZsuwxHYcNc
         gzKmvbdLHfTkWsRtj0xABckv37G3S43aZAjRh5EDhN+HA8AsHQq75u2+jMGkRM2xknh+
         oMqCua5aYYhzGHLc64NKFpRwTi61mKyqFVgaACQi/lJxi9u65QmuICCmcwQFAZ0SkdSK
         XGVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793667750; x=1794272550;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cNS9XkUpb0odYgcS4hw74G9m0QCGpHkW7/U/VrcLoMQ=;
        b=X4AaPe6y17Z2/fntVDVcXgR30WsVqmkwCPc05vrRIvePhs2ujtIhskA4w7ljbnvRVe
         dpxr1MXHNKTqHttCi/ys5vCYlsQ4RP2J8+qBWE+7nsfaf8o6wgnVABJ4y0/dpJ3qzTMl
         qJ5/Q+GKigyNbOtPBJ1sd2h2Qcz08y3HfQUAXO2pI3SUATeCubtupgMja4Bgg/8SpoDk
         17E/5hXWcoAtKtI1rxwh0JhymYkljyC7w8buRa83tYMImBjidqcBpY44BS0WQecAMlKY
         bpM0AYar+jZFoNR5W27qy98vTCThw+2QViBcr8aIVNebcVvTx+xtlFtcI37rNfbMVWa1
         MQWw==
X-Forwarded-Encrypted: i=1; AKwUvBxJPSDGrPmglcQr5Qk3kQrXZ+bOdpM4vdsUJhejgXantfKdFdluS27J69AYvr6ZPxDqE26JJx85BQ==@kvack.org
X-Gm-Message-State: APuU4Z8XK4oUWnjtW/o2OYhipEP3S99VIXZ573M7snXhAimERw/izlUg
	3HYsII+aCGw38xxqKRM6zgJauQ9Jxzc6FmUZVg5Knc8GbCxZeyshGsKO2W2kjH7wLLAy8/xVEXS
	4cnjO7DeMsFrBsA==
X-Received: from pjbgd1.prod.google.com ([2002:a17:90b:fc1:b0:3ad:5136:109b])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:1b11:b0:3ad:4bfc:1e77 with SMTP id 98e67ed59e1d1-3ae897dd40fmr9335117a91.66.1793667749818;
 Mon, 02 Nov 2026 17:02:29 -0800 (PST)
Date: Tue,  3 Nov 2026 01:02:12 +0000
In-Reply-To: <20261103010216.3447716-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261103010216.3447716-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gac671c819a-goog
Message-ID: <20261103010216.3447716-7-dmatlack@google.com>
Subject: [PATCH v3 06/10] mm/shmem_luo: Don't make early retrieve failures permanent
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6AED210000F
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Stat-Signature: 114cgwaa8xx19khdzm1iy51g91tgbx4u
X-Rspam-User: 
X-HE-Tag: 1793667751-432831
X-HE-Meta: U2FsdGVkX18MdPmVvqML9JxTPWYZXWtKjJcpUQpZd9MdaqQ4wr2hIQaEFWovRSVWHJTtqZ/T+KszHMBMv6ZcBOzAM13ei4Ee7W3WZ0LBfUQMeFTK94LcGcDGjxxHEQbTNjPZoilzPIS+LyoJoq3152QXipvj1lDlLLq6oJGVFjfmwe1fFc5qcgINB8TZ8TXIy1FXTuJ0Sw0nH7flqM7CpoxKhaJtql6gGLbWWxcE613isIw4+dutbBn9mgehdWI7A9jlpZLKgpgb655lSkLdpAz6QsZpCvnzMJzr+cbblskmsV8n3UpPmoevt7QFjrrzXy+LPEn/k8p6T6VZAzG8yx7NrPJdcQss3etscJsncQk1dm1DXz+ZjC2+CCnTn/Iwj87uFzBKo2R6AA6gxfPAJaI8cWrjOXn68L2q3dPA3qvGUgjh1w+Ojix3++dbwqJ+07KXFSwurO89hvMm6WCkbI3Y8LM9TH+BijlLsKRAjid/zEqDbjxnXs5riW1Q34wuxdcR/cF6jfiHuRgl1Ej3CIWNAaysaVYhU6pBUFYcTtQf78iSgsSJGDttDeXcuyu91tx2/HRJORd+0eceJsSqEnOPavPNQwvUf7iAyXY0Xa39wKDG7zWPZt/6Yxgjc6EB8Pn1PP7qh8vJ2em3JAp9m80wdY0Dt4c6Z2ZGjnUtS+uYgdguip3Tm7LZ7ZkNFW1mprrPFfkA7hsBT+DqGqKpVH9b+xyckog/6HYzhJdxcL3tkcEqwB6JlCbZeySQUqyZs8HCgTR4Jh4nii5/oIbVCLxh+ugs8YLaaapfzj6zilwQk5VJKRQF/CehYCUln5VpyJX15n1Tb+2q2F0595esDKaPVbTgPZTNulLrb0LyuvHmkBs3VKJ+nbeK9ZeYFsWhRDfv4qPl+DHTfhzasqXzYsuFGdaRcYh+sez7PAJbU0YTH0kbiv9ihStb9q95H32gudjaiZFeMXn0Naj4gQ7
 2J/I00Qm
 /LGO3dPYHgJsk4+Iqsu6zOjYgziHEIqlTM9OTSYFahH0gxz68xsv8eShexs3tlykxAxh3HH9kvV9KXcgHThUlxe08yQHE46VxILUCgyZE+y+tGV0nvn91v7k/MRzd58jzSmsGlwhk1WiGgUukiysdCnAhBURMyQw6+A9Du0DhUqN1j8lZ6gQzqF/tT00QE2CnClQY+x6CJRU1k/B/zQUDXf6mh3CgWg2fmPb6ZBoOLnRHd1IA0fHFxrKNNsJNnQGsuTo4zl8hh2F2pVHG2Biwi73VgDUSpzQG61gs1w3eS6pwampFD3tQwtfs6j/lWBhxTihZm7KZOe+PNTYqpKOg2Lrh9nOWVmd+DbmjPUb9YAQLOX6nOyN2iP5VUCxCbeX/babdwprxrw/7p5zngGXaXQ0qgYfREY0CR3Fgn/2eVY99107Kuk2lKio0W50//9aaQ83pHM1mwhGKCPlhaoXgLa8/6CW8ASWyjI0QoPSAAPyBE5ANcd3xlquSyllyLJgncFmbtJ5nu5SSxmtQgmG6f0cK+UprgpNWvhV/RGEHtyBT8BX6ItgO//M73UWZgXc8ibRetIGA0xbWel0UVu/34ox6oHRLG1wglPvn4nNioabA0RCxq5RDlSUKb9kYhafLBxbIn/inBPiXfb+ZNNEDLcB9I6QLgG/O2ip988KCwfKCpBNTlmfWcPTbel3Yc5IQxDpk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Mark failures in shmem_luo_retrieve() before it starts restoring the
folios as retryable, and return the error without freeing the serialized
state. If no retrieve succeeds, finish() frees the preserved folios,
like it does for a file that was never retrieved.

Nothing has consumed the preserved state before the folios are
restored, so the retrieve can be tried again.

This also fixes leaking the preserved folios when one of these early
steps fails, e.g. because the file has seals that this kernel doesn't
support. The retrieve freed the serialized state but not the folios, and
finish() then skipped the file because its retrieve had failed. There is
no Fixes tag, since the fix relies on args->retryable, which was only
added earlier in this series.

Signed-off-by: David Matlack <dmatlack@google.com>
Acked-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/shmem_luo.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/mm/shmem_luo.c b/mm/shmem_luo.c
index b8d86055912d..bcac1bbb3db3 100644
--- a/mm/shmem_luo.c
+++ b/mm/shmem_luo.c
@@ -390,9 +390,9 @@ static void shmem_luo_finish(struct liveupdate_file_op_args *args)
 	struct shmem_luo_ser *ser;
 
 	/*
-	 * If retrieve was successful, nothing to do. If it failed, retrieve()
-	 * already cleaned up everything it could. So nothing to do there
-	 * either. Only need to clean up when retrieve was not called.
+	 * If retrieve was successful, nothing to do. If it failed permanently,
+	 * retrieve() already cleaned up everything it could. So nothing to do
+	 * there either. Only need to clean up when the file was not retrieved.
 	 */
 	if (args->retrieve_status)
 		return;
@@ -526,11 +526,16 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	if (!ser)
 		return -EINVAL;
 
+	/*
+	 * Nothing has consumed the preserved state until the folios are
+	 * restored below, so failures before that can be retried. If no
+	 * retrieve succeeds, finish() frees the preserved state.
+	 */
+	args->retryable = true;
+
 	/* Make sure the file only has seals supported by this version. */
-	if (ser->seals & ~SHMEM_LUO_ALL_SEALS) {
-		err = -EOPNOTSUPP;
-		goto free_ser;
-	}
+	if (ser->seals & ~SHMEM_LUO_ALL_SEALS)
+		return -EOPNOTSUPP;
 
 	/*
 	 * The seals are preserved. Allow sealing here so they can be added
@@ -539,8 +544,7 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	file = memfd_alloc_file("", MFD_ALLOW_SEALING);
 	if (IS_ERR(file)) {
 		pr_err("failed to setup file: %pe\n", file);
-		err = PTR_ERR(file);
-		goto free_ser;
+		return PTR_ERR(file);
 	}
 
 	err = memfd_add_seals(file, ser->seals);
@@ -552,17 +556,20 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
 	i_size_write(file_inode(file), ser->size);
 
+	/* The preserved state is consumed from here on. */
+	args->retryable = false;
+
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser) {
 			err = -EINVAL;
-			goto put_file;
+			goto free_ser;
 		}
 
 		err = shmem_luo_retrieve_folios(file, folios_ser, ser->nr_folios);
 		vfree(folios_ser);
 		if (err)
-			goto put_file;
+			goto free_ser;
 	}
 
 	args->file = file;
@@ -570,10 +577,10 @@ static int shmem_luo_retrieve(struct liveupdate_file_op_args *args)
 
 	return 0;
 
-put_file:
-	fput(file);
 free_ser:
 	kho_restore_free(ser);
+put_file:
+	fput(file);
 	return err;
 }
 
-- 
2.56.0.385.gac671c819a-goog


