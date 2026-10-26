Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CAE9606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 01:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=kzjEOUtp
Received: by kanga.kvack.org (Postfix)
	id C59636B05B4; Sun, 25 Oct 2026 21:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2FEF6B05B3; Sun, 25 Oct 2026 21:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1E6A6B05B4; Sun, 25 Oct 2026 21:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7ADF36B05B2
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 21:49:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 14C3C1A05DA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:49:56 +0000 (UTC)
X-FDA: 85363096392.15.29C7A0C
Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id 54E051C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 01:49:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kzjEOUtp;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792979394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cqNF367lxFmIYhXXq+OLb+e5D4QxVBAxvfWwC9lKoew=;
	b=B5rZLSoPiC+g0/A6Sq+izdXygU6YKA/3RxHsn6gFJ1jtz0ufH5xxyLvWH0h/e0NThTs4p5
	172ps53Z1tympmMs0wcwPxTKR2wKJwzIlAgiRi4BUsfCmoXEKdPdP5rhT4ceHzrRIoqxlW
	AJvaG1fH0M5GRe8QjXgnb8DAQETd7dk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792979394;
	b=rBCzl3cxBvln3W+QXjLUecs5c2TOnjNN3wm7UFRKFXq9VQtHOeMSjHPu0VwxBcriY9EYtj
	qN9bxLZr3WIUuiQuq1t82SqWfJ0PH5RgIiF0MSPkP1c4gG37ILyeAt2s8a/Fq6Mt9QUfzo
	5IvT7c5sgMnPJhNhF8wL1r1TozUNJa0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kzjEOUtp;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5ead5ff47caso1118439e0c.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 18:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792979393; x=1793584193; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cqNF367lxFmIYhXXq+OLb+e5D4QxVBAxvfWwC9lKoew=;
        b=kzjEOUtp1gRnIvK4WMvN86scStih1fhIlGZWwBoQiEvhamN2XSy6VBrKtrmZIh9blq
         mtNHSPPXToZtRKpOjVbZ9p0hDqiMl3QIuKliDaFPlbjedWWHV/olPENApIgCHiPUiZ21
         z45WXKpWg4m8d8p2dimqt6kr1y1l4BP3bDEpZSe6mpFqVu+iJbE3lab223GHZayT/UTd
         ks0s3i5piAbF66xoT0002xgGgfUnYXAxcbzhEG4uq9hE47+9S44n4N/fsWwHFItrtUwe
         ZRZ24rOEWQsmW3IZ3F6kgx1Itby4J2Nj46qE3hbHMaJFLiBik2e5cFJ1NS4hD6kokxr2
         jbKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792979393; x=1793584193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=cqNF367lxFmIYhXXq+OLb+e5D4QxVBAxvfWwC9lKoew=;
        b=QBObkHUYDiDOVZ04MLWktUnIgJrxH8nkfZ1XfFjEZ/AePrksOjwktb1D9JhmcABgw5
         KGGGG+KcI45Z9GHFWpJPdUOUt8dCD5TOMk0+7/KfFWiYNOYzM52j+v5XYu1KxQxhp21W
         mOj05OEm9WNy5dZnfZEx+uGS0IqqoftP5hZ3QOpXwQagBk++yTD8ICs3EfcGUoITwiv1
         kOkZIVWBXNe4S4taUix6jECATSs4rLsfVn3PDgZUKcRbv6St3am6PjOekTmjDRIjBjYH
         07SzUVfrhM2HHrnhvwPOpaXv2OfeJJncJseZE2S5cUqjEHTgNKQ+fCcIzRpO+dx4tTH6
         Er4w==
X-Forwarded-Encrypted: i=1; AKwUvBxaROqYjeHQX3s2QGGthCRpUfENnra0OgYMgasBmdue5nUHhERpmt6JOZP+/90I/yPrC19dSNEnhg==@kvack.org
X-Gm-Message-State: AFq9FYJ/V4vtQkgECcJ1OrTD3Wwk9Ysxn9w7n8uX6AIBgs6MM4f17E+v
	DTIPidejpNq1yuz7p43eI5CFa790FGwXFP26d+Pp6x3PERnfH2viGibcTRv/I+bCts4=
X-Gm-Gg: AYBFou0z612CQxzg48TdsRXakQpB53HsO7MS4v2HAQFBtldRHUmnNczTzD4S9gEw0sJ
	AsiXT3ruWB41QxXmrt4AUi/JCwo1m+/TeErVrc8jwi8rUB591D6bGKdOOHEg/yv5dcPAJc/QMie
	Oy2yYxRT2m04YhpnWhO4LYP9LbWs2m/hkIvnnSoiDyrCYwMCd8p6eUuuWMFQXq3Uaz2uc3F2g7x
	o/Dfpir8kXJ9pAXZFOOqpVhmLzDEf1ZaJpDUBLH9rldF7epn+Ni0wsofECikXGWhrNOHvF1UH9O
	xXnzi0HQ0brNnqg2CuSFqYSIiCwYYf2f28Aq2JA/eGAk6tvzYwcQtK75yuKjRhxoyGx1tOd0o4x
	DsBpWIvEzJuThG3qh2ximp+xRq/VqCD7M943NQ8TUm0YqLXOgnQ4EhxEHc7c1I4yAdAEMcvvPXv
	XgA9/HuBQ8KHcNCzaPpGgeCy0Xt1HO+N3CHC4zzTgOR+sfYwByfQA/KUJAwlZzygMpSskSvXZs9
	r3OYLtx5ALpls9Q1mmlCv2zHOW9tpqiz7nAgO+/88lhc8E1GxDTgKwiGl0YluSyffEOwTmqpZul
	l0FeDZQ1N2uP4gdV4MquWrohL9TUK3+N2COH7birapWxLiKhx7U870QV9ChznomthD69xaZgJZP
	C
X-Received: by 2002:a05:6102:570d:b0:7cc:1ace:fd06 with SMTP id ada2fe7eead31-7ce5cdabfa5mr1356873137.20.1792979393254;
        Sun, 25 Oct 2026 18:49:53 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7ce5df73970sm6099917137.1.2026.10.25.18.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 18:49:52 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	graf@amazon.com
Subject: [PATCH v4 2/3] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl to freeze sessions early
Date: Sun, 25 Oct 2026 21:49:45 -0400
Message-ID: <20261026014948.162559-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
In-Reply-To: <20261026014948.162559-1-pasha.tatashin@soleen.com>
References: <20261026014948.162559-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 54E051C0004
X-Stat-Signature: cy7sz6eemdgffij3oeyrtx6m5igpojtj
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792979394-725848
X-HE-Meta: U2FsdGVkX1+WBRvcLZ9HiSLY3n/gLPc99LNqqlI5zDBhbmhjFBAKuqvN90hJFBIklSU+MYQpds03Z7r7vv1kr0kfTzZgZUTeiGE8wsy+N1t1vw8WjkSlvC9uIRuYAXPebcjUR6kBDfZIdOoP/uY4aNvUkZ1BukvlZhRRaGwZesIbXX7PafMdpTZgf4d0vPVhIx85hldPxrnBBiXPn5qEtn5v3GQ3id1V/dAp7V4g+F0Jbcb0OTQAdw3UTCrW9SGJIKtlIIwH4dmFmt6/l1hJGQ4z1n12yUn6TEzu2YQ7WDBPO5wIrsVKUIRzEJ6kEf0Gl6N4XgoXVNR1BNvbziOCsU/oYMY9l0esUWXWSGKFrZWSbtN05zI8rbBAUHkDCmvKjFFdNFZYJfDrE74q5wWlgdQYqBvtkjl+L5x3oAVbFbNGZX2QNRIMSeab0lZXPQx9WB6gjLfTeIun0jpnvDzwTkXrSEenyfz9u5tN9WtAtmQbK6mStNRAtB+c87l6o1BnXuPuM5ZXymGdm3X8dPPQd5Y8EICt/8C4Y8BKUoanu7VsbFiE6yZ/WTr3PYCYtl287eTgETnfnVUmsRrpNvhFqmAsi9Pgn30m3oFeRIH3f4Ls+V2X9yQLCF7auF4loD0o6eGUM8uPGNhWIPlpRdwkNiLJ5TCoik3LCo1XL7S22sxotRuHP87BmD6UviGh05vv2YJaaF/2HoA7gFx7hPnlsH7wsU9OR+6kXBCxFMgmoiHi2Ir1R9Owt8GzFK2RO3uzElIm5H4UujddIzWY0PPQgWgBacluQ16kMc50v6yShPqPdGUDBHNad5/CtYl4hH7EH/aCx8Ge5l8JArHBMC+1gMh6iZ5qUiwuRhG9ZH7go6aL9NU5oeqhmWOTIRZK2JTIOrL5eJodZ9m+Q6ySZ4tqici/kifabmcUlCdZTdcua9QR/E5GN9mnqOwg71FBMuWcefCPOTVmqRXwCPR38Q2
 BPsJlC68
 vCwLqZdZuLORy7Plr4apU6RKs0WZA4tNMm3Iu6l4YQu/6rCSFtYGuzKe590oDH39RPbTQz9AxeUgkn/CuNuA9H4PN3Ht90kTXR2xhy9SdoM30sU58dbVMeRTjhrVrYkYAnyPXFtbbtv623ZhxoH5LRDCqmSHbNAftIA63RUs1kmIPzhGNt4gg+ShyDOXkhBtd1ThdtXKoTm9+YCOvH1WhhGIBU2rIgVqFuHw4C7T0dvdiYBqhsdni12G+9H/tem7ie3RQawy9zwtRjV8de14XzzOaSsSDCZffplRMtbP/elLWrzz7iS2Cw5CmA+lD+/uE0jrdHD0Wls90qsirpHfW1RbKWNMt3pJxuBP+D3t3S7q3D4OwoVeMGLqTTX/Ju+tuwk3Lckc7qHSgHw3zmyVcgFW4hVZUCQNa3/utcgFvhtvJ9Uo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, LUO sessions are frozen automatically only inside the
reboot(LINUX_REBOOT_CMD_KEXEC) pathway, where luo_session_serialize()
iterates through all outgoing sessions under global write locks and
freezes them serially during shutdown. Allowing userspace to decide when
to freeze a session once it is done with it (and to freeze multiple
sessions in parallel, since luo_session_freeze() only acquires the
per-session mutex) avoids postponing this work to kexec shutdown and
reduces blackout time.

Introduce LIVEUPDATE_SESSION_FREEZE on session file descriptors to freeze
a session early. The ioctl runs .freeze() across all preserved files in the
session and serializes their metadata. Once frozen, no additional files can
be added to the session, and subsequent freeze calls return -EBUSY. Freeze
is only valid on outgoing sessions and returns -EINVAL on incoming ones.

During kexec, sessions that were already frozen early are skipped, while
sessions that did not invoke this ioctl auto-freeze as before. If an
early-frozen session is released before kexec, its files are rolled back
via .unfreeze() before being unpreserved.

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h       |  3 +-
 include/uapi/linux/liveupdate.h  | 25 +++++++++++++
 kernel/liveupdate/luo_file.c     | 49 ++++++++++++------------
 kernel/liveupdate/luo_internal.h |  3 ++
 kernel/liveupdate/luo_session.c  | 64 +++++++++++++++++++++++++++-----
 mm/memfd_luo.c                   |  5 ++-
 6 files changed, 113 insertions(+), 36 deletions(-)

diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
index 6051abc0612c..851692571e13 100644
--- a/include/linux/liveupdate.h
+++ b/include/linux/liveupdate.h
@@ -59,7 +59,8 @@ struct liveupdate_file_op_args {
  *                compatible with the given file.
  * @preserve:     Required. Performs state-saving for the file.
  * @unpreserve:   Required. Cleans up any resources allocated by @preserve.
- * @freeze:       Optional. Final actions just before kernel transition.
+ * @freeze:       Optional. Prepares final state before kexec (via
+ *                LIVEUPDATE_SESSION_FREEZE or during reboot).
  * @unfreeze:     Optional. Undo freeze operations.
  * @retrieve:     Required. Restores the file in the new kernel.
  * @can_finish:   Optional. Check if this FD can finish, i.e. all restoration
diff --git a/include/uapi/linux/liveupdate.h b/include/uapi/linux/liveupdate.h
index 4043d4038712..3fb0cae0f711 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -60,6 +60,7 @@ enum {
 	LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
 	LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
 	LIVEUPDATE_CMD_SESSION_GET_NAME = 0x43,
+	LIVEUPDATE_CMD_SESSION_FREEZE = 0x44,
 };
 
 /**
@@ -236,4 +237,28 @@ struct liveupdate_session_get_name {
 #define LIVEUPDATE_SESSION_GET_NAME					\
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
 
+/**
+ * struct liveupdate_session_freeze - ioctl(LIVEUPDATE_SESSION_FREEZE)
+ * @size:     Input; sizeof(struct liveupdate_session_freeze)
+ * @reserved: Input; Must be zero. Reserved for future use.
+ *
+ * Freezes the session from userspace before the kexec reboot phase.
+ *
+ * When this ioctl is called, the kernel executes the .freeze() callback on all
+ * preserved files in the session and serializes their metadata. Once frozen,
+ * no further files can be preserved in the session.
+ *
+ * During the subsequent kexec reboot, this session is recognized as already
+ * frozen and is skipped from the late auto freeze.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_session_freeze {
+	__u32		size;
+	__u32		reserved;
+};
+
+#define LIVEUPDATE_SESSION_FREEZE					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FREEZE)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 988eb313a135..fac2e5a6bdc0 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -31,9 +31,9 @@
  *   - unpreserve(): Cleans up any resources allocated by .preserve(), called
  *     if the preservation process is aborted before the reboot (i.e. session is
  *     closed).
- *   - freeze(): A final pre-reboot opportunity to prepare the state for kexec.
- *     We are already in reboot syscall, and therefore userspace cannot mutate
- *     the file anymore.
+ *   - freeze(): Prepares the final state for kexec. Invoked either via
+ *     the LIVEUPDATE_SESSION_FREEZE ioctl once userspace is done modifying
+ *     the session's files, or during the reboot() syscall.
  *   - unfreeze(): Undoes the actions of .freeze(), called if the live update
  *     is aborted after the freeze phase.
  *   - retrieve(): Reconstructs the file in the new kernel from the preserved
@@ -48,7 +48,8 @@
  *    handler, calls its .preserve() operation, and creates an internal &struct
  *    luo_file to track the live state.
  *
- * 2. Freeze (Pre-Reboot): Just before the kexec, luo_file_freeze() is called.
+ * 2. Freeze (Pre-Reboot): Either explicitly via LIVEUPDATE_SESSION_FREEZE or
+ *    just before the kexec during reboot(), luo_file_freeze() is called.
  *    It iterates through all preserved files, calls their respective .freeze()
  *    operation, and serializes their final metadata (compatible string, token,
  *    and data handle) into a contiguous memory block for KHO.
@@ -74,15 +75,16 @@
  *
  * 1. Abort Before Reboot: If the userspace agent aborts the live update
  *    process before calling reboot (e.g., by closing the session file
- *    descriptor), the session's release handler calls
- *    luo_file_unpreserve_files(). This invokes the .unpreserve() callback on
- *    all preserved files, ensuring all allocated resources are cleaned up and
- *    returning the system to a clean state.
+ *    descriptor), the session's release handler unfreezes the files if the
+ *    session was already frozen and calls luo_file_unpreserve_files(). This
+ *    invokes the .unpreserve() callback on all preserved files, ensuring all
+ *    allocated resources are cleaned up and returning the system to a clean
+ *    state.
  *
- * 2. Freeze Failure: During the reboot() syscall, if any handler's .freeze()
- *    op fails, the .unfreeze() op is invoked on all previously *successful*
- *    freezes to roll back their state. The reboot() syscall then returns an
- *    error to userspace, canceling the live update.
+ * 2. Freeze Failure: During LIVEUPDATE_SESSION_FREEZE or the reboot() syscall,
+ *    if any handler's .freeze() op fails, the .unfreeze() op is invoked on all
+ *    previously *successful* freezes to roll back their state, and an error is
+ *    returned to userspace, canceling the live update if called from reboot().
  *
  * 3. Finish Failure: In the new kernel, if a handler's .finish() op fails,
  *    the luo_file_finish() operation is aborted. LUO retains ownership of
@@ -442,9 +444,9 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
  * luo_file_freeze - Freezes all preserved files and serializes their metadata.
  * @file_set: The file_set whose files are to be frozen.
  *
- * This function is called from the reboot() syscall path, just before the
- * kernel transitions to the new image via kexec. Its purpose is to perform the
- * final preparation and serialization of all preserved files in the file_set.
+ * This function is called from LIVEUPDATE_SESSION_FREEZE or from the reboot()
+ * syscall path. Its purpose is to perform the final preparation and
+ * serialization of all preserved files in the file_set.
  *
  * It iterates through each preserved file in FIFO order (the order of
  * preservation) and performs two main actions:
@@ -461,13 +463,12 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
  *
  * Error Handling (Rollback):
  * This function is atomic. If any handler's .freeze() operation fails, the
- * entire live update is aborted. The __luo_file_unfreeze() helper is
- * immediately called to invoke the .unfreeze() op on all files that were
- * successfully frozen before the point of failure, rolling them back to a
- * running state. The function then returns an error, causing the reboot()
- * syscall to fail.
+ * __luo_file_unfreeze() helper is immediately called to invoke the .unfreeze()
+ * op on all files that were successfully frozen before the point of failure,
+ * rolling them back to an unfrozen state, and an error is returned to the
+ * caller, canceling the live update if called from the reboot() path.
  *
- * Context: Called only from the liveupdate_reboot() path.
+ * Context: Called from LIVEUPDATE_SESSION_FREEZE or the liveupdate_reboot() path.
  * Return: 0 on success, or a negative errno on failure.
  */
 int luo_file_freeze(struct luo_file_set *file_set)
@@ -517,15 +518,15 @@ int luo_file_freeze(struct luo_file_set *file_set)
  * @file_set: The file_set whose files are to be unfrozen.
  *
  * This function rolls back the state of all files in a file_set after the
- * freeze phase has begun but must be aborted. It is the counterpart to
- * luo_file_freeze().
+ * freeze phase has begun. It is the counterpart to luo_file_freeze().
  *
  * It invokes the __luo_file_unfreeze() helper with a NULL argument, which
  * signals the helper to iterate through all files in the file_set, call their
  * respective .unfreeze() handler callbacks, and clear the serialized blocks.
  *
  * Context: This is called when the live update is aborted during
- *          the reboot() syscall, after luo_file_freeze() has been called.
+ *          the reboot() syscall, after luo_file_freeze() has been called,
+ *          or when an explicitly frozen session is released before kexec.
  */
 void luo_file_unfreeze(struct luo_file_set *file_set)
 {
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index 01a172cd9d7a..381499e73d2a 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -64,6 +64,8 @@ struct luo_file_set {
  *              previous kernel) sessions.
  * @retrieved:  A boolean flag indicating whether this session has been
  *              retrieved by a consumer in the new kernel.
+ * @user_frozen: A boolean flag indicating whether this session has been
+ *               frozen explicitly from userspace.
  * @file_set:   A set of files that belong to this session.
  * @mutex:      protects fields in the luo_session.
  */
@@ -71,6 +73,7 @@ struct luo_session {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
 	struct list_head list;
 	bool retrieved;
+	bool user_frozen;
 	struct luo_file_set file_set;
 	struct mutex mutex;
 };
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 827f9ad1938f..cce6d09280b3 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -34,10 +34,11 @@
  * 1.  Creation: A userspace agent calls `luo_session_create()` to create a
  *     new, empty session and receives a file descriptor for it.
  *
- * 2.  Serialization: When the `reboot(LINUX_REBOOT_CMD_KEXEC)` syscall is
- *     made, `luo_session_serialize()` is called. It iterates through all
- *     active sessions and writes their metadata into a memory area preserved
- *     by KHO.
+ * 2.  Freeze / Serialization: Sessions may be frozen explicitly from userspace
+ *     via `LIVEUPDATE_SESSION_FREEZE`. When the `reboot(LINUX_REBOOT_CMD_KEXEC)`
+ *     syscall is made, `luo_session_serialize()` is called to freeze any
+ *     remaining active sessions and write all session metadata into a memory
+ *     area preserved by KHO.
  *
  * 3.  Deserialization (in new kernel): After kexec, `luo_session_deserialize()`
  *     runs, reading the serialized data and creating a list of `struct
@@ -222,7 +223,13 @@ static void luo_session_unserialize_one(struct luo_session *session,
 					struct luo_session_ser *ser)
 {
 	guard(mutex)(&session->mutex);
-	luo_file_unfreeze(&session->file_set);
+	/*
+	 * Only unfreeze sessions that were auto-frozen by
+	 * luo_session_serialize_one(); sessions frozen explicitly by
+	 * userspace stay frozen until the session FD is closed.
+	 */
+	if (!session->user_frozen)
+		luo_file_unfreeze(&session->file_set);
 	memset(ser, 0, sizeof(*ser));
 }
 
@@ -232,9 +239,11 @@ static int luo_session_serialize_one(struct luo_session *session,
 	int err;
 
 	guard(mutex)(&session->mutex);
-	err = luo_file_freeze(&session->file_set);
-	if (err)
-		return err;
+	if (!session->user_frozen) {
+		err = luo_file_freeze(&session->file_set);
+		if (err)
+			return err;
+	}
 
 	strscpy(ser->name, session->name, sizeof(ser->name));
 	ser->file_set_ser.count = session->file_set.count;
@@ -261,8 +270,11 @@ static int luo_session_release(struct inode *inodep, struct file *filep)
 		}
 		sh = &luo_session_global.incoming;
 	} else {
-		scoped_guard(mutex, &session->mutex)
+		scoped_guard(mutex, &session->mutex) {
+			if (session->user_frozen)
+				luo_file_unfreeze(&session->file_set);
 			luo_file_unpreserve_files(&session->file_set);
+		}
 		sh = &luo_session_global.outgoing;
 	}
 
@@ -279,6 +291,9 @@ static int luo_session_preserve_fd(struct luo_session *session,
 	int err;
 
 	guard(mutex)(&session->mutex);
+	if (session->user_frozen)
+		return -EBUSY;
+
 	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
 	if (err)
 		return err;
@@ -352,11 +367,40 @@ static int luo_session_get_name(struct luo_session *session,
 	return luo_ucmd_respond(ucmd, sizeof(*argp));
 }
 
+static int luo_session_freeze(struct luo_session *session,
+			      struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_freeze *argp = ucmd->cmd;
+	int err;
+
+	if (argp->reserved)
+		return -EINVAL;
+
+	guard(mutex)(&session->mutex);
+	if (session->user_frozen)
+		return -EBUSY;
+
+	err = luo_file_freeze(&session->file_set);
+	if (err)
+		return err;
+
+	err = luo_ucmd_respond(ucmd, sizeof(*argp));
+	if (err) {
+		luo_file_unfreeze(&session->file_set);
+		return err;
+	}
+
+	session->user_frozen = true;
+
+	return 0;
+}
+
 union ucmd_buffer {
 	struct liveupdate_session_finish finish;
 	struct liveupdate_session_preserve_fd preserve;
 	struct liveupdate_session_retrieve_fd retrieve;
 	struct liveupdate_session_get_name get_name;
+	struct liveupdate_session_freeze freeze;
 };
 
 /* Type of sessions the ioctl applies to. */
@@ -394,6 +438,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
 		 struct liveupdate_session_retrieve_fd, token, LUO_IOCTL_INCOMING),
 	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
 		 struct liveupdate_session_get_name, name, LUO_IOCTL_ALL),
+	IOCTL_OP(LIVEUPDATE_SESSION_FREEZE, luo_session_freeze,
+		 struct liveupdate_session_freeze, reserved, LUO_IOCTL_OUTGOING),
 };
 
 static bool luo_ioctl_type_valid(struct luo_session *session,
diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 6b68220275eb..a3bf872b3a03 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -43,8 +43,9 @@
  *   allocating pages for them during preservation.
  *
  * File Position
- *   The current file position is preserved, allowing applications to continue
- *   reading/writing from their last position.
+ *   The file position at the time the session is frozen is preserved,
+ *   allowing applications to continue reading/writing from their last
+ *   position.
  *
  * File Status Flags
  *   memfds are always opened with ``O_RDWR`` and ``O_LARGEFILE``. This property
-- 
2.56.0.307.g5fe7bd680c-goog


