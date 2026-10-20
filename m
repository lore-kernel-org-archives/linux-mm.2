Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9735606A33C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 14:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=gGZeVEjL
Received: by kanga.kvack.org (Postfix)
	id D75F76B04DE; Tue, 20 Oct 2026 10:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D262B6B04E0; Tue, 20 Oct 2026 10:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3DB06B04E1; Tue, 20 Oct 2026 10:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 841556B04DE
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:47:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 129B9160214
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:47:29 +0000 (UTC)
X-FDA: 85343283018.28.BFB843A
Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2B57440004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 14:47:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gGZeVEjL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792507647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zYWLDAlAlVICyxH0LQMkDk6QKXhwdIwFHz1mR9kwH8M=;
	b=SKPwIUtlP17O2pnzmNg9xPQq2XXR1sp7iBo+jKlLPnWyBoNPmBqpCotpyxYJunv6jD2DgS
	226PliNHrXn1ypACS3zWL2qfKtfoDkIim8+nU/+QX5Qu8bQ7YfpeC2r1u4+enMox3Wjeme
	ssSPwVe5MzpLh7D0J9DNvoWP7zba1fw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=gGZeVEjL;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf12.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.173 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792507647;
	b=UW1AyNAD0ByshtFXSTrDLz9usGrGcIs8NOn0g5RhIN/otlx2pa9RqSG6nLs9vLfSeKCZWe
	LnoDmvzbMxfoiC/TJ4NVmbQOG1PGpz8GejQnoMSpTrKjz0RFBHuvP42rYDevxLMczSf6Io
	ZWd+nzjtdQB/XINH5trRjBv1ZfCGlcA=
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-5eac925bac3so419141e0c.0
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792507646; x=1793112446; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zYWLDAlAlVICyxH0LQMkDk6QKXhwdIwFHz1mR9kwH8M=;
        b=gGZeVEjLHcS96KZr6Pz1KiThZQ9xbeqjVz+P3in10jvtnw7wdckVW/g+eDUhloHrY9
         BqXp283byj/2yf86XczJRiHBeMS7YWD/frU4xxV0ZS5wqWs0tUzGehwUQ3uMq/NelOMc
         i8J170iiIj0a+KpXgpskOJDA1jof8ugNLqJkscb3dxJLXNTFooB0JhyEOEc+vFV3sGCA
         1zPc+CtIB38ldPGy06abR0tzZGb6eGvqtruvZaLsFrF5t6G0Hc5qAQeR9j8xKA75SRAc
         DTIwVfyhh2yPihx7QXwZMILNPNwU10YBsEjz0/Bxg3Q75W1OMTujw9vxVfQSrpN17NpY
         vRJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792507646; x=1793112446;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zYWLDAlAlVICyxH0LQMkDk6QKXhwdIwFHz1mR9kwH8M=;
        b=biilCHFLdhpJd9CUKiFhSPGD/7tmp559aWJLhNCvbLVioemmobIvJVZKQHqsHAH5Y/
         i1zH8LLv7gIr+eEMM1PksjNypyUMnQz2/3KBI/q7b9eA+YD5d9vwZaJm1i5h+U9YRUKv
         76588N/n2Z00TitR8HXc1BmMuBKDDaMbBIc3PUWuJhJjFZ93+gbFrRDak4x+KSyqsWGj
         QPQemsNlp/LulYrLfHucelrNPcPJ4Y/7FzBywcnBpvVBumhVyWnqvk2xHmXxuY0bBl/u
         tYOcLotA9gQ1j4w/1O11kaLJdkgDRWa7hAXxQ0GVzV0ostlsLjwomE3+nmgs7kjdBBXj
         HK0Q==
X-Forwarded-Encrypted: i=1; AKwUvBxnFD3fDwAns+NktBfkKi8HLVYShHmqhSGqzW4xROyiZNNvPUdHNHbMdQOPnX/oaJsEGatIYLDLkg==@kvack.org
X-Gm-Message-State: AFq9FYIxCgFvFgqclLXnG9f6vZ09f8EEbRjWoOCA/shjPh0Qce+ZNLVN
	EGSxYbc1Ubq/0YOsaSaV+GTLerxwCJHsAJdwLL7ldUBoHO2qdCN5KylWkJeEnxI2CL8=
X-Gm-Gg: AYBFou297B2tXkuiLc1zVtjvL6Wk0EVUBuDvr7vIZVYO+jmfFqU92ZHsn0CP9oVXdxh
	IFQZNrx4wkkO91VOsj6/r7tMAriVlKWUrdoAFR1TLSehTdLzil0YXDd6aA1E1ZcMOo5HBozRJIX
	ss10aHjSbq3a0szXTxm6xgcuFel7tiiWob+086TejZ7UP0DXmcWYWqqh3VyVQ8uYuXtMtV6SOrU
	JL6XOIburEOj/PJ+73m5UkVvojMDNOJ/ovgIZEPchqtqih4eo/atocmC9OWbmfHGFw+nWspQSG5
	p6MaT7p8df4Drv7gXIwM3OoyzD7msn3+bejxhsnxE4SRifz4Zu2iiXEBZxmBePXn3O07KGA/RiC
	86c/kYn63nImBRD5aeFSmJ18aghVZpH2tHm5wi5il61AJ+saPoe0M/9xV2Kzo97SYtaA0rtmm1J
	N+Ga0AdWzDhQ6RGbW+boTnVC5GYXyAhjYNf9At1M2MTT33qSnwyuP/JGjGMAWGEwlszKT6N3XBK
	OzuF1FbpcBWSjVJ8BbpWpvvQmHfOSlSAUxYlWM7HaiSnUdmt3mMK0p+m9nbvm2F3OFUlPV6YV3T
	QPLZU92EYUmUHoOgdj0=
X-Received: by 2002:a05:6122:3d0f:b0:5ea:e197:43ee with SMTP id 71dfb90a1353d-5eae1975698mr366937e0c.19.1792507646090;
        Tue, 20 Oct 2026 07:47:26 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b536ccdsm12920421e0c.13.2026.10.20.07.47.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 07:47:23 -0700 (PDT)
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
Subject: [PATCH v2 1/2] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl to freeze sessions early
Date: Tue, 20 Oct 2026 10:47:03 -0400
Message-ID: <20261020144710.4154339-2-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
In-Reply-To: <20261020144710.4154339-1-pasha.tatashin@soleen.com>
References: <20261020144710.4154339-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2B57440004
X-Rspam-User: 
X-Stat-Signature: 1kdq79a757apy6hxg1ja9fuhd9anghxh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792507647-93463
X-HE-Meta: U2FsdGVkX1/HcVKZTwra9QyL/PmnJhMYk7sMHuGO5ymjkeRa1C1sGGMREdyx2jvrOcKeHjGMsSL+9NEZjxeh9SwTgy21UT6BAQ1bJhHMaTC7FgQ+DBUoSGvwWusyEFKUy8l08Q+S5CrZ60crGg7wE/eypaIUNkyPi3Vhh3+MR8KsQzLjaM/lS86UtrCXE+xEvV06X+W1833ADmpmx2cNoDlqPPEc0H6QDBhmlxurLVSVTl6ke/6+C2pYvSctvDHUD/QLppALt6FbBEa/MUYNVy8zKSzfuwDQu8GCKLqHEIIauaBAoKq2ZFw69ZXcTVcXEtO//AHGQIznZklQric//25TK9LFj3UhW1AvC2ML5oIvQt1ENz6dYnRJUb3nO3C0S3AfL6i/ZJQPSejSOqY9KnX+ZrR3YnQ4ssXRBgTZTZ2DCdrYwlRCH9xRjGLujI82ftCOLRvNOGcSfu24ZVqrq1m2yY+u6OTV8CBIW6+zzipPBk7KEXDTo+Vvyw3tLihNuvleHqyrX0If0kI1crasPmggTNnz6HOErlBryNdmKooUtrSUc/nj5uq1eL9DP2JJ0JOanQz/dx794k0kfGg+yP0I4QJGALjmh6WDUlFxQ8DbLDR49o2zopMbjuDfaxIxWYGTXNFl25D5CX506LbzXWeDOlCjElEA4S23j+ilSweNhHz87x3yViiih0XPUC7wxyptuzVO0BwPPyKjFTQCKWQHC4utPiKQsfGtGgxdcJyPTXx/Qzv8JQBG4uPG5TcNR5neDhWoUdHnY2K2CSv03/df/JWic0MfUVF7IR+N/6P/FlmCbWUraCZmoxepfe5sazPngjb+5yFPKeP4eF3izxhrgZQ4zEmEP4rXfEHz80fKJ/DHkPP0FnbKRFCNUrFeQdVaNku/TIgx69U/76BetQsHU92c/vdytCbefUXb+s6FKrBBMwfkLCQQ9nqjCzow03KZZRo4taSOfKA3Qj7
 3tJUkzvm
 e4AYbCbMRjAajc28DqXXY++ld/51csH7QhkM3k2TxAPWmn+2dhjT1cRN8NnVnmymN8cX6H6rj9Q8cQmmCndWiNfhmVzBaBGYxqpGDOoHbOjmlFEmaNEZCOFoeBFteOhHRoilZsqWvzR4Sab1YtwuSrMRvkYOSg9gSss1Wv6aBckmwSoQi9l98l6zbBMApd+68zZRuCPHfdixGgcGIrl8PtwbC3H+lxnfQrti5I7DZNFYJFKaRKuQxR+S1aMw0gLre3LQAg2Ed0UYWwV6YN1DBF46N1m7BSYj/kYP8K2EK/iN2Wf4SbmboihyEPjOHdWnkGQfQ175iqNP//MOHOXqOoh7NZbvWzLjznvEo9bHe2GZtH4kLtZx+qcY1KaSSGDqdAkJFQC6fDdoqnOy/RKMN5OoRPKviLv6b3K+apUIkt8A6LR0PsfFpNnPTyw==
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

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 include/linux/liveupdate.h       |  3 +-
 include/uapi/linux/liveupdate.h  | 25 ++++++++++
 kernel/liveupdate/luo_file.c     | 73 +++++++++++++---------------
 kernel/liveupdate/luo_internal.h |  9 ++--
 kernel/liveupdate/luo_session.c  | 82 +++++++++++++++++++++++++-------
 mm/memfd_luo.c                   |  5 +-
 6 files changed, 134 insertions(+), 63 deletions(-)

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
index 4043d4038712..1644c502521e 100644
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
+ * Freezes the session early from userspace before the reboot kexec phase.
+ *
+ * When this ioctl is called, the kernel executes the .freeze() callback on all
+ * preserved files in the session and serializes their metadata. Once frozen,
+ * no further files can be preserved in the session.
+ *
+ * During the subsequent reboot kexec, this session is recognized as already
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
index a39992da504f..7f79890beb31 100644
--- a/kernel/liveupdate/luo_file.c
+++ b/kernel/liveupdate/luo_file.c
@@ -31,9 +31,9 @@
  *   - unpreserve(): Cleans up any resources allocated by .preserve(), called
  *     if the preservation process is aborted before the reboot (i.e. session is
  *     closed).
- *   - freeze(): A final pre-reboot opportunity to prepare the state for kexec.
- *     We are already in reboot syscall, and therefore userspace cannot mutate
- *     the file anymore.
+ *   - freeze(): Prepares the final state for kexec. Invoked either early via
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
+ *    returned to userspace.
  *
  * 3. Finish Failure: In the new kernel, if a handler's .finish() op fails,
  *    the luo_file_finish() operation is aborted. LUO retains ownership of
@@ -440,12 +442,11 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
 
 /**
  * luo_file_freeze - Freezes all preserved files and serializes their metadata.
- * @file_set:     The file_set whose files are to be frozen.
- * @file_set_ser: Where to put the serialized file_set.
+ * @file_set: The file_set whose files are to be frozen.
  *
- * This function is called from the reboot() syscall path, just before the
- * kernel transitions to the new image via kexec. Its purpose is to perform the
- * final preparation and serialization of all preserved files in the file_set.
+ * This function is called from LIVEUPDATE_SESSION_FREEZE or from the reboot()
+ * syscall path. Its purpose is to perform the preparation and serialization of
+ * all preserved files in the file_set.
  *
  * It iterates through each preserved file in FIFO order (the order of
  * preservation) and performs two main actions:
@@ -457,22 +458,20 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
  *
  * 2. Serializes Metadata: After a successful freeze, it copies the final file
  *    metadata—the handler's compatible string, the user token, and the final
- *    private data handle—into the pre-allocated contiguous memory buffer
- *    (file_set->files) that will be handed over to the next kernel via KHO.
+ *    private data handle—into the pre-allocated serialization blocks
+ *    (file_set->block_set) that will be handed over to the next kernel via KHO.
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
+ * caller.
  *
- * Context: Called only from the liveupdate_reboot() path.
+ * Context: Called from LIVEUPDATE_SESSION_FREEZE or the liveupdate_reboot() path.
  * Return: 0 on success, or a negative errno on failure.
  */
-int luo_file_freeze(struct luo_file_set *file_set,
-		    struct luo_file_set_ser *file_set_ser)
+int luo_file_freeze(struct luo_file_set *file_set)
 {
 	struct luo_file *luo_file;
 	struct kho_block_set_it it;
@@ -506,9 +505,6 @@ int luo_file_freeze(struct luo_file_set *file_set,
 		file_ser->token = luo_file->token;
 	}
 
-	file_set_ser->count = file_set->count;
-	file_set_ser->files = kho_block_set_head_pa(&file_set->block_set);
-
 	return 0;
 
 err_unfreeze:
@@ -519,28 +515,25 @@ int luo_file_freeze(struct luo_file_set *file_set,
 
 /**
  * luo_file_unfreeze - Unfreezes all files in a file_set and clear serialization
- * @file_set:     The file_set whose files are to be unfrozen.
- * @file_set_ser: Serialized file_set.
+ * @file_set: The file_set whose files are to be unfrozen.
  *
  * This function rolls back the state of all files in a file_set after the
- * freeze phase has begun but must be aborted. It is the counterpart to
- * luo_file_freeze().
+ * freeze phase has begun. It is the counterpart to luo_file_freeze().
  *
  * It invokes the __luo_file_unfreeze() helper with a NULL argument, which
- * signals the helper to iterate through all files in the file_set and call
- * their respective .unfreeze() handler callbacks.
+ * signals the helper to iterate through all files in the file_set, call their
+ * respective .unfreeze() handler callbacks, and clear the serialized blocks.
  *
  * Context: This is called when the live update is aborted during
- *          the reboot() syscall, after luo_file_freeze() has been called.
+ *          the reboot() syscall, after luo_file_freeze() has been called,
+ *          or when an early-frozen session is released before kexec.
  */
-void luo_file_unfreeze(struct luo_file_set *file_set,
-		       struct luo_file_set_ser *file_set_ser)
+void luo_file_unfreeze(struct luo_file_set *file_set)
 {
 	if (!file_set->count)
 		return;
 
 	__luo_file_unfreeze(file_set, NULL);
-	memset(file_set_ser, 0, sizeof(*file_set_ser));
 }
 
 /**
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index dac6644bfb18..b3fc3dcf5f36 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -64,6 +64,8 @@ struct luo_file_set {
  *              previous kernel) sessions.
  * @retrieved:  A boolean flag indicating whether this session has been
  *              retrieved by a consumer in the new kernel.
+ * @frozen:     A boolean flag indicating whether this session has been
+ *              frozen early from userspace.
  * @file_set:   A set of files that belong to this session.
  * @mutex:      protects fields in the luo_session.
  */
@@ -71,6 +73,7 @@ struct luo_session {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
 	struct list_head list;
 	bool retrieved;
+	bool frozen;
 	struct luo_file_set file_set;
 	struct mutex mutex;
 };
@@ -103,10 +106,8 @@ int luo_session_deserialize(void);
 
 int luo_preserve_file(struct luo_file_set *file_set, u64 token, int fd);
 void luo_file_unpreserve_files(struct luo_file_set *file_set);
-int luo_file_freeze(struct luo_file_set *file_set,
-		    struct luo_file_set_ser *file_set_ser);
-void luo_file_unfreeze(struct luo_file_set *file_set,
-		       struct luo_file_set_ser *file_set_ser);
+int luo_file_freeze(struct luo_file_set *file_set);
+void luo_file_unfreeze(struct luo_file_set *file_set);
 int luo_retrieve_file(struct luo_file_set *file_set, u64 token,
 		      struct file **filep);
 int luo_file_finish(struct luo_file_set *file_set);
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index f48e9a4185f9..8bf505cdba7e 100644
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
+ * 2.  Freeze / Serialization: Sessions may be frozen early from userspace
+ *     via `LIVEUPDATE_SESSION_FREEZE`. When the `reboot(LINUX_REBOOT_CMD_KEXEC)`
+ *     syscall is made, `luo_session_serialize()` is called to freeze any
+ *     remaining active sessions and write all session metadata into a memory
+ *     area preserved by KHO.
  *
  * 3.  Deserialization (in new kernel): After kexec, `luo_session_deserialize()`
  *     runs, reading the serialized data and creating a list of `struct
@@ -218,18 +219,33 @@ static int luo_session_finish_one(struct luo_session *session)
 	return luo_file_finish(&session->file_set);
 }
 
-static void luo_session_unfreeze_one(struct luo_session *session,
-				     struct luo_session_ser *ser)
+static void luo_session_unserialize_one(struct luo_session *session,
+					struct luo_session_ser *ser)
 {
 	guard(mutex)(&session->mutex);
-	luo_file_unfreeze(&session->file_set, &ser->file_set_ser);
+	if (!session->frozen)
+		luo_file_unfreeze(&session->file_set);
+	memset(ser, 0, sizeof(*ser));
 }
 
-static int luo_session_freeze_one(struct luo_session *session,
-				  struct luo_session_ser *ser)
+static int luo_session_serialize_one(struct luo_session *session,
+				     struct luo_session_ser *ser)
 {
+	int err;
+
 	guard(mutex)(&session->mutex);
-	return luo_file_freeze(&session->file_set, &ser->file_set_ser);
+	if (!session->frozen) {
+		err = luo_file_freeze(&session->file_set);
+		if (err)
+			return err;
+	}
+
+	strscpy(ser->name, session->name, sizeof(ser->name));
+	ser->file_set_ser.count = session->file_set.count;
+	ser->file_set_ser.files =
+		kho_block_set_head_pa(&session->file_set.block_set);
+
+	return 0;
 }
 
 static int luo_session_release(struct inode *inodep, struct file *filep)
@@ -249,8 +265,11 @@ static int luo_session_release(struct inode *inodep, struct file *filep)
 		}
 		sh = &luo_session_global.incoming;
 	} else {
-		scoped_guard(mutex, &session->mutex)
+		scoped_guard(mutex, &session->mutex) {
+			if (session->frozen)
+				luo_file_unfreeze(&session->file_set);
 			luo_file_unpreserve_files(&session->file_set);
+		}
 		sh = &luo_session_global.outgoing;
 	}
 
@@ -267,6 +286,9 @@ static int luo_session_preserve_fd(struct luo_session *session,
 	int err;
 
 	guard(mutex)(&session->mutex);
+	if (session->frozen)
+		return -EBUSY;
+
 	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
 	if (err)
 		return err;
@@ -340,11 +362,40 @@ static int luo_session_get_name(struct luo_session *session,
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
+	if (session->frozen)
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
+	session->frozen = true;
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
@@ -382,6 +433,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
 		 struct liveupdate_session_retrieve_fd, token, LUO_IOCTL_INCOMING),
 	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
 		 struct liveupdate_session_get_name, name, LUO_IOCTL_ALL),
+	IOCTL_OP(LIVEUPDATE_SESSION_FREEZE, luo_session_freeze,
+		 struct liveupdate_session_freeze, reserved, LUO_IOCTL_OUTGOING),
 };
 
 static bool luo_ioctl_type_valid(struct luo_session *session,
@@ -656,13 +709,11 @@ int luo_session_serialize(void)
 			goto err_undo;
 		}
 
-		err = luo_session_freeze_one(session, ser);
+		err = luo_session_serialize_one(session, ser);
 		if (err) {
 			kho_block_set_it_prev(&it);
 			goto err_undo;
 		}
-
-		strscpy(ser->name, session->name, sizeof(ser->name));
 	}
 
 	if (sh->count > 0)
@@ -675,8 +726,7 @@ int luo_session_serialize(void)
 	list_for_each_entry_continue_reverse(session, &sh->list, list) {
 		struct luo_session_ser *ser = kho_block_set_it_prev(&it);
 
-		luo_session_unfreeze_one(session, ser);
-		memset(ser->name, 0, sizeof(ser->name));
+		luo_session_unserialize_one(session, ser);
 	}
 	up_write(&sh->rwsem);
 	up_write(&luo_session_serialize_rwsem);
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
2.56.0.212.g129ede20d9-goog


