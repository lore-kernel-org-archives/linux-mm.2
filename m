Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C206606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 05:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=EIEKdIWl
Received: by kanga.kvack.org (Postfix)
	id 0E8926B05C7; Thu,  5 Nov 2026 00:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C0436B05CB; Thu,  5 Nov 2026 00:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F180A6B05CC; Thu,  5 Nov 2026 00:01:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C8F496B05C7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 00:01:07 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C592D1C4335
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:06 +0000 (UTC)
X-FDA: 85399866132.13.D3AF8A2
Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0AB3F100003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:01:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EIEKdIWl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793854865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YUipaf1Xu3soLx3fON/5CvYu8l0nj5iVkY657TVC4e0=;
	b=a2chD1uA/X4VKyzWqLLpZnOqk7kVfMJ8AlykJtk+rsBNfwbDnRpEuEUGr8gsb0xo+3powC
	encNEKoZCOl6W1YthRewrAX1HuXLH40zTSKt5YZ8CxbUo6WPZ2Kt/iBMcItPoGC3xUIFwq
	0LI+TTP1b8k3T7p1JbMtL3V9AGblwWo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793854865;
	b=CkN4He4XgA/min1ywPJqVWbjIZ4gms1iPSSTcFu1d/51jEsMMJUmTIvqm0dVbLg9QbHXYv
	vxEU1ROLhciQ/VANVaiVDMZ9uCqqLv5O2wu7ddbTtrFBOCXZq5Jznejie5HsCDTE2+Mlb8
	2FMNWrq/3GNahIl/EDLVP74P+IXa6hE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=EIEKdIWl;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-5eadef147ffso1071394e0c.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 21:01:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793854864; x=1794459664; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=YUipaf1Xu3soLx3fON/5CvYu8l0nj5iVkY657TVC4e0=;
        b=EIEKdIWl0KQ/U84pri5XcGZ4nAwGPw0YO947jSXjJ/MfQnDIJnc+W6Q6G3j9TTgaxu
         xDBamcAg+WBrT4TA3+CPg8H+9ZsB/VfO3NRJ8vRY6cncC/KyLnARAhf/f7VXX2eXoaWK
         lO/LIQsEpmi9SYgQpWuPQkKAaOPxCfYoV16x8SEudNJwU4WEK0nSxZ0raRpncBo1FFmt
         1nIYdOs7XpbHUutiUOj22XuNas5y+1vbcbmhO4e+5SSxTz+iuqIeSokyusgIYm7hqasb
         EoGhlrnK20KhOHgjzVqBbcgikGCX4SNvsQXftdPinSyHIdSDvs4x5JGEXVn0Q66pFZZw
         3uWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793854864; x=1794459664;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=YUipaf1Xu3soLx3fON/5CvYu8l0nj5iVkY657TVC4e0=;
        b=Utp8aSm2xkvE3CMhbjR9chvYckvUdIdCDo3niK2N3IXHHwZZogf4HcxF1F6KV1E1EB
         U2+jybjYurubwuqdck7zOEnBlDC/3YWle0jsdjTK/uZPayMVKnhxHPcwpubs0+HVYTwD
         qPQJkbn7RVrTt/cgzrmWWcsiLkx0yDpWGl2yNLaABJAW8tGQVMNuXpRc35QgrS2eutFq
         3XJL9AfGw+f4ugiQZbLnu1Bb16eHSMUdaFhWaH5UVVXMET/7pT82jt+4pUcaQlsEAi19
         2hmfKLNtJlYiqN4iKoB5W6ih6dSZi4aoTMz88vtbINfSmFGAq0sMQuNzKqElI/gsrpkg
         J2GQ==
X-Forwarded-Encrypted: i=1; AKwUvBxnKNIHrfoX8f7evk+u1FzWRAXOQJuHiaeX2Y2HZhTYLtH59prkvzGz87ndU9MHMpDowATRtfC+Bg==@kvack.org
X-Gm-Message-State: APuU4Z9XiXV1Xk/HSalsQmuq3IMkQg19mYPMv02vm41GF9rHWSa8uK9e
	b5WFpu180i9H8EaoAycpiExyyNavAPZNebQYNpQn5Lw+EF6UHnUC5WuwLktcQeHeqwg=
X-Gm-Gg: AYBFou13bK+4akfHmonBxUPGXfXTNdRjo54nxf6KNTDkiKMoyCyqCRwrzXNBoqWQwyu
	LzkPWCtLAIlflTMrwFPMjCocmfgTuedW7e9gKJYW82KlEbnkF7BEWUlbYsRua7dd7F+09AS7WcC
	W0fk8hD4WLrt081ECaXaFFIROBffKleA6bSJhDh6Ye1rJS9BKfw8KL+CwPRGVBPO8xR8KScT4yJ
	0OkDTbx87pRFwZpuIzD1yjHm1Hjuy6Njac1VEn60MxPrvpGS6kjHXkU/Bh39QFeLO7WrXFwXJn1
	GMLekcFJHoItGa+cMWVga/Lu9soMIOSAIdmsYsXfLSqPu5Ta5lL7A7Q1UoVUG9aOD1+ja7fSif9
	B1f0hQbpS8czRXLw7rzAbHCn9HgMJu/voEmIK8p0SgwWgdwKrfRcXrc4x2F+yHfYMz8qbtZ7kKp
	k0MyrURp/IdUxmKM4TbCaey8ISvxInNvWlid0oZ78Gi/ibUDFzfqLr/Nrv7NaSu+GrbjQTLJP1Z
	tQKo0eZ2+VvpcExgKptcuObm/9gh2Vpv05585fDHKAoYtOs0Om9fWKZu5vTcGo0j0h5qou00l74
	w8lJGg7qpu9ODKCtbY8kXg8HICiZ39M00A0+ws9zjYB4ciJSiRvj46vkhOhtzNVbBuxy6HCvyos
	i6mA+9+8HFfNHVqmrGyIt+GFEVnW5DGkmL8e7S2/oqsnio+nGxA==
X-Received: by 2002:a05:6122:8f85:b0:5ec:20e8:45ff with SMTP id 71dfb90a1353d-5ec68a06324mr9559381e0c.21.1793854864052;
        Wed, 04 Nov 2026 21:01:04 -0800 (PST)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5eca8d9d62bsm3305282e0c.8.2026.11.04.21.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 21:01:03 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: linux-kselftest@vger.kernel.org,
	rppt@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	skhan@linuxfoundation.org,
	linux-doc@vger.kernel.org,
	vipinsh@google.com,
	linux-kernel@vger.kernel.org,
	corbet@lwn.net,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	graf@amazon.com
Subject: [PATCH v5 5/6] liveupdate: Add LIVEUPDATE_SESSION_FREEZE ioctl to freeze sessions early
Date: Thu,  5 Nov 2026 00:00:51 -0500
Message-ID: <20261105050053.3063001-6-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.398.g882cbad275-goog
In-Reply-To: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
References: <20261105050053.3063001-1-pasha.tatashin@soleen.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uftuf4thi9g8xd4y8mmorp1zycqxx1d3
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0AB3F100003
X-HE-Tag: 1793854864-512079
X-HE-Meta: U2FsdGVkX1+V+cwBMtD+FF2DPk+12OkH9dq/3glVEIw/litg/6j48onMvI+V+mYqmg6ZyR/+mQaKiRG3U2bhDUOv+6LKEeSup2+0ErVVVWp05C5Xf71NzcXaibxcy4evZ5nlyZFrfh64rKNKTjNjSNm50poeoyZanxVAhOKWQe5ibt4kqSP8nDVese3mTY20YBfllrmjSvklrNGMBzVIRd2nZN6AkG+qK8IVVMH7SOuwTWhv+l6e5bym2Rj/VY20Zal7XlCM700XyzbbPkLdCCe3sAWFbGlInB0wf559Wz/iCK37D46O92m5JS+BjjhYvH+JsCtoVSyaHpQT+ZNH6PJCrIO7bPk7Mr6tsSNpzBaIjODrFu+GN4/8XZ6J9USUw33iCFJw+Yx9InEO+8krW1JS5TGCeD9v8auxn4zKRLLoNa1/8inDCYCjJmduJj/M4n3YB5daQNh3T3oCZ/w/AlBdssOBKSABCjWoJV8HbJjspn0ny7VSThXkTID+ZGKA2m7tz4c1gtN6TUUubQFT8xeIQ44gWBMyJf4eEQnTq0/i0n9gMZP0cHFGcsAwkHbOyK4geaHXe6UTPF2MW+dnloYtMsFfkQI+E+cCO/kcrCi4SGRMInZeXev0AtzX8gabYEb94oNj7AwGoYyU2x03SwjGo3kN3UMgRYUI04l9ahsU+knIbQrnHFKLHCzVzJXs76woi9LXcPYx8KrrRnkx2JY8GJmkQbyTmfq4dAsn7iKkoNlye5ua6opseyOP2/b0NMVEjtpM2BcBd5dgwUBNkIRVIqb5kTy7UE3ZYyIPRiUuTYQ7Pqc1vVG0K+22AeOiVH3mQDIvu3NXZ4N1hj6NcbajNPzMqxyu8UsxmhZdSYT5tb6dZzz4YJFbzJyV8EamPKtQh2OCRf9bMpP5rOqcJQ8dwu0URJy2UTReeXSg04kSzifmt6IUbKMYiLjSvPyiWyAUHCnokHP7DCQsEJ0
 YOP2oSpA
 9FhixvrmY36/KXqV1AGvW96bUwW/ApQrkdxKrE6G5mfYuzYEeqG9HW3EM/xd+BoITWlOLQxj9zoFgc3Sr3p+AVhfY0s8wiKUUH/UQ9a2ErO7znEgBcwlIVjft9Dc27PAlEUB8OGxgIomi2vzzxduuq/xvZlheEaZq8cunXB4P43vpZsYzxEvoFoCyW5+gB2K5TDd+0AOm6uxL6Zmta1mH7J4B7trmGrfGdxv/WBhpMtgorGmv/qZIa7v+RUQRNNhoDzWEY4GbKmrsAOsFrSLSLdLbiozYW8ATi1eZrot/atUtcokeoMi7dTUgubrZG+0YjROsgTl8ABEAoQVielMqLN9hFYEV5wbSjZCyaNKWwNtFd9YK3oMpz/h3mkyXV78sscd9xYkHzTRE3R5HeottI56aTA==
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
freezes them serially during shutdown. On hosts running multiple
workloads that quiesce one by one ahead of kexec, userspace needs an
explicit per-session freeze point so each session can capture final file
state under its per-session mutex as soon as its workload pauses.

Introduce LIVEUPDATE_SESSION_FREEZE on session FDs to freeze an outgoing
session early. The ioctl runs .freeze() across all preserved files in
the session and serializes their metadata. Once frozen, no additional
files can be added to the session, and subsequent freeze calls return
-EBUSY. Freeze is only valid on outgoing sessions and returns -EINVAL on
incoming ones.

By default (flags == 0), session lifetime remains bound to the session
FD: the session stays frozen while the FD remains open, and closing the
session FD before reboot (for example, to abort the session or on
process exit/crash) unfreezes it via .unfreeze(), unpreserves its files,
and reclaims all resources. During kexec, already-frozen sessions skip
the late auto-freeze and are published into the outgoing KHO subtree.

With LIVEUPDATE_SESSION_FREEZE_COMMIT set in
struct liveupdate_session_freeze.flags, the frozen session is committed:
it and its FLB dependencies are immediately inserted into the outgoing
KHO subtree via luo_session_publish_one(), and the session survives
close() with full ownership retained by LUO until reboot. Once
committed, closing the session FD (or another session failing to freeze
during reboot) never unfreezes or unpreserves the session, allowing
processes to hand off preserved state and exit prior to kexec.

Update the uAPI and core LUO documentation to describe session freeze
and commit semantics.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/userspace-api/liveupdate.rst | 30 +++++++++
 include/linux/liveupdate.h                 |  3 +-
 include/uapi/linux/liveupdate.h            | 46 +++++++++++++
 kernel/liveupdate/luo_file.c               | 54 +++++++--------
 kernel/liveupdate/luo_internal.h           |  7 ++
 kernel/liveupdate/luo_session.c            | 77 ++++++++++++++++++++--
 6 files changed, 184 insertions(+), 33 deletions(-)

diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
index cdd74627ab75..d36537c556cc 100644
--- a/Documentation/userspace-api/liveupdate.rst
+++ b/Documentation/userspace-api/liveupdate.rst
@@ -22,6 +22,36 @@ change, so compatibility is not guaranteed when kexec rebooting between
 different kernel versions. This is expected to change and stabilize in a future
 version.
 
+Session Freeze and Commit
+=========================
+
+By default, LUO freezes active sessions automatically inside the
+``reboot(LINUX_REBOOT_CMD_KEXEC)`` syscall path, and an outgoing session's
+lifetime is bound to its open session FD: closing the FD before reboot aborts
+preservation and returns all resources.
+
+Userspace may also freeze an outgoing session explicitly ahead of reboot via
+``ioctl(session_fd, LIVEUPDATE_SESSION_FREEZE, &arg)`` once it has finished
+preserving and modifying the session's files:
+
+- **Freeze** (``flags == 0``): Executes ``.freeze()`` on all preserved files in
+  the session under the per-session lock (allowing multiple sessions to freeze
+  concurrently), while keeping session lifetime tied to ``session_fd``. When
+  ``session_fd`` is closed before reboot (for example, to abort the session or
+  on process exit/crash), LUO runs ``.unfreeze()`` and ``.unpreserve()`` on all
+  files in the session and reclaims all resources. As long as ``session_fd``
+  remains open, the session stays frozen across any failed ``reboot()`` attempt;
+  at kexec time, already-frozen sessions skip the late auto-freeze step and are
+  published into the outgoing KHO subtree.
+- **Freeze and commit** (``LIVEUPDATE_SESSION_FREEZE_COMMIT``): Freezes the
+  session's files, immediately inserts the session and its FLB dependencies
+  into the outgoing KHO subtree, and commits the session so that it survives
+  closing ``session_fd`` with ownership retained by LUO until reboot. Once
+  committed, closing ``session_fd`` (or another session failing to freeze
+  during ``reboot()``) will neither unfreeze nor unpreserve the session,
+  allowing processes to hand off preserved state to LUO and exit prior to
+  kexec.
+
 Userspace Integration
 =====================
 
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
index 4043d4038712..ba424dc51578 100644
--- a/include/uapi/linux/liveupdate.h
+++ b/include/uapi/linux/liveupdate.h
@@ -60,6 +60,7 @@ enum {
 	LIVEUPDATE_CMD_SESSION_RETRIEVE_FD = 0x41,
 	LIVEUPDATE_CMD_SESSION_FINISH = 0x42,
 	LIVEUPDATE_CMD_SESSION_GET_NAME = 0x43,
+	LIVEUPDATE_CMD_SESSION_FREEZE = 0x44,
 };
 
 /**
@@ -236,4 +237,49 @@ struct liveupdate_session_get_name {
 #define LIVEUPDATE_SESSION_GET_NAME					\
 	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_GET_NAME)
 
+/**
+ * enum liveupdate_session_freeze_flags - Flags for LIVEUPDATE_SESSION_FREEZE
+ * @LIVEUPDATE_SESSION_FREEZE_COMMIT: Commit the frozen session. The session is
+ *                                    immediately inserted into the outgoing KHO
+ *                                    tree and survives closing the session FD
+ *                                    until reboot.
+ */
+enum liveupdate_session_freeze_flags {
+	LIVEUPDATE_SESSION_FREEZE_COMMIT = 1 << 0,
+};
+
+/**
+ * struct liveupdate_session_freeze - ioctl(LIVEUPDATE_SESSION_FREEZE)
+ * @size:  Input; sizeof(struct liveupdate_session_freeze)
+ * @flags: Input; Combination of enum liveupdate_session_freeze_flags.
+ *
+ * Freezes the session from userspace before the kexec reboot phase.
+ *
+ * When this ioctl is called, the kernel executes the .freeze() callback on all
+ * preserved files in the session and serializes their metadata. Once frozen,
+ * no further files can be preserved in the session, and subsequent freeze
+ * attempts return -EBUSY.
+ *
+ * By default (@flags is 0), session lifetime remains tied to the session FD:
+ * if the session FD is closed before reboot (for example, if the application
+ * exits or crashes), the session is unfrozen, its preserved files are
+ * unpreserved, and all resources are returned.
+ *
+ * If %LIVEUPDATE_SESSION_FREEZE_COMMIT is set in @flags, the frozen session is
+ * committed: it is immediately inserted into the outgoing KHO tree and survives
+ * closing the session FD, transferring full ownership of the session and its
+ * preserved resources to LUO until reboot. Once committed, the session is never
+ * unfrozen or unpreserved, even if the session FD is closed or if another
+ * session fails to freeze during reboot.
+ *
+ * Return: 0 on success, negative error code on failure.
+ */
+struct liveupdate_session_freeze {
+	__u32		size;
+	__u32		flags;
+};
+
+#define LIVEUPDATE_SESSION_FREEZE					\
+	_IO(LIVEUPDATE_IOCTL_TYPE, LIVEUPDATE_CMD_SESSION_FREEZE)
+
 #endif /* _UAPI_LIVEUPDATE_H */
diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
index 611b9967a3a9..afed2b59f489 100644
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
@@ -72,17 +73,19 @@
  *
  * File Preservation Lifecycle unhappy paths:
  *
- * 1. Abort Before Reboot: If the userspace agent aborts the live update
- *    process before calling reboot (e.g., by closing the session file
- *    descriptor), the session's release handler calls
- *    luo_file_unpreserve_files(). This invokes the .unpreserve() callback on
- *    all preserved files, ensuring all allocated resources are cleaned up and
- *    returning the system to a clean state.
+ * 1. Abort Before Reboot: When an uncommitted session FD is closed before
+ *    reboot (e.g., to abort preservation or on process exit), the session's
+ *    release handler unfreezes the files if the session was frozen via
+ *    LIVEUPDATE_SESSION_FREEZE and calls luo_file_unpreserve_files(). This
+ *    invokes the .unpreserve() callback on all preserved files, ensuring all
+ *    allocated resources are cleaned up and returning the system to a clean
+ *    state. Committed sessions survive closing their FD and remain owned by
+ *    LUO until reboot.
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
@@ -458,9 +461,9 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
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
@@ -477,13 +480,12 @@ static void __luo_file_unfreeze(struct luo_file_set *file_set,
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
@@ -533,15 +535,15 @@ int luo_file_freeze(struct luo_file_set *file_set)
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
+ *          or when a frozen uncommitted session is released before kexec.
  */
 void luo_file_unfreeze(struct luo_file_set *file_set)
 {
diff --git a/kernel/liveupdate/luo_internal.h b/kernel/liveupdate/luo_internal.h
index a7253b48df80..f1ecc8586ea1 100644
--- a/kernel/liveupdate/luo_internal.h
+++ b/kernel/liveupdate/luo_internal.h
@@ -64,6 +64,11 @@ struct luo_file_set {
  *              previous kernel) sessions.
  * @retrieved:  A boolean flag indicating whether this session has been
  *              retrieved by a consumer in the new kernel.
+ * @user_frozen: A boolean flag indicating whether this session has been
+ *               frozen explicitly from userspace.
+ * @committed:   A boolean flag indicating whether this session has been
+ *               committed (frozen, published into the outgoing KHO tree,
+ *               and owned by LUO across session FD close until reboot).
  * @file_set:   A set of files that belong to this session.
  * @mutex:      protects fields in the luo_session.
  */
@@ -71,6 +76,8 @@ struct luo_session {
 	char name[LIVEUPDATE_SESSION_NAME_LENGTH];
 	struct list_head list;
 	bool retrieved;
+	bool user_frozen;
+	bool committed;
 	struct luo_file_set file_set;
 	struct mutex mutex;
 };
diff --git a/kernel/liveupdate/luo_session.c b/kernel/liveupdate/luo_session.c
index 713b9b400f07..4358a5e77c38 100644
--- a/kernel/liveupdate/luo_session.c
+++ b/kernel/liveupdate/luo_session.c
@@ -34,10 +34,16 @@
  * 1.  Creation: A userspace agent calls `luo_session_create()` to create a
  *     new, empty session and receives a file descriptor for it.
  *
- * 2.  Serialization: When the `reboot(LINUX_REBOOT_CMD_KEXEC)` syscall is
- *     made, `luo_session_serialize()` is called. It iterates through all
- *     active sessions and writes their metadata into a memory area preserved
- *     by KHO.
+ * 2.  Freeze / Serialization: Sessions may be frozen explicitly from userspace
+ *     via `LIVEUPDATE_SESSION_FREEZE`. With `flags == 0`, the session's files
+ *     are frozen while keeping the session tied to its FD so closing it
+ *     unfreezes and unpreserves the session. With
+ *     `LIVEUPDATE_SESSION_FREEZE_COMMIT`, the frozen session is committed: it
+ *     is immediately published with its FLBs into the outgoing KHO tree and
+ *     survives closing the session FD until reboot. When the
+ *     `reboot(LINUX_REBOOT_CMD_KEXEC)` syscall is made,
+ *     `luo_session_serialize()` freezes any remaining unfrozen sessions and
+ *     publishes all remaining unpublished sessions into the KHO tree.
  *
  * 3.  Deserialization (in new kernel): After kexec, `luo_session_deserialize()`
  *     runs, reading the serialized data and creating a list of `struct
@@ -276,12 +282,21 @@ static int luo_session_finish_one(struct luo_session *session)
 static void luo_session_unfreeze_one(struct luo_session *session)
 {
 	guard(mutex)(&session->mutex);
-	luo_file_unfreeze(&session->file_set);
+	/*
+	 * Only unfreeze sessions that were auto-frozen by
+	 * luo_session_freeze_one(); sessions frozen explicitly by
+	 * userspace stay frozen until the session FD is closed.
+	 */
+	if (!session->user_frozen)
+		luo_file_unfreeze(&session->file_set);
 }
 
 static int luo_session_freeze_one(struct luo_session *session)
 {
 	guard(mutex)(&session->mutex);
+	if (session->user_frozen)
+		return 0;
+
 	return luo_file_freeze(&session->file_set);
 }
 
@@ -302,8 +317,13 @@ static int luo_session_release(struct inode *inodep, struct file *filep)
 		}
 		sh = &luo_session_global.incoming;
 	} else {
-		scoped_guard(mutex, &session->mutex)
+		scoped_guard(mutex, &session->mutex) {
+			if (session->committed)
+				return 0;
+			if (session->user_frozen)
+				luo_file_unfreeze(&session->file_set);
 			luo_file_unpreserve_files(&session->file_set);
+		}
 		sh = &luo_session_global.outgoing;
 	}
 
@@ -320,6 +340,9 @@ static int luo_session_preserve_fd(struct luo_session *session,
 	int err;
 
 	guard(mutex)(&session->mutex);
+	if (session->user_frozen)
+		return -EBUSY;
+
 	err = luo_preserve_file(&session->file_set, argp->token, argp->fd);
 	if (err)
 		return err;
@@ -393,11 +416,51 @@ static int luo_session_get_name(struct luo_session *session,
 	return luo_ucmd_respond(ucmd, sizeof(*argp));
 }
 
+static int luo_session_freeze(struct luo_session *session,
+			      struct luo_ucmd *ucmd)
+{
+	struct liveupdate_session_freeze *argp = ucmd->cmd;
+	int err;
+
+	if (argp->flags & ~LIVEUPDATE_SESSION_FREEZE_COMMIT)
+		return -EOPNOTSUPP;
+
+	scoped_guard(mutex, &session->mutex) {
+		if (session->user_frozen)
+			return -EBUSY;
+
+		err = luo_file_freeze(&session->file_set);
+		if (err)
+			return err;
+
+		err = luo_ucmd_respond(ucmd, sizeof(*argp));
+		if (err) {
+			luo_file_unfreeze(&session->file_set);
+			return err;
+		}
+
+		session->user_frozen = true;
+	}
+
+	if (argp->flags & LIVEUPDATE_SESSION_FREEZE_COMMIT) {
+		struct luo_session_header *sh = &luo_session_global.outgoing;
+
+		guard(rwsem_write)(&sh->rwsem);
+		guard(mutex)(&session->mutex);
+
+		luo_session_publish_one(session);
+		session->committed = true;
+	}
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
@@ -435,6 +498,8 @@ static const struct luo_ioctl_op luo_session_ioctl_ops[] = {
 		 struct liveupdate_session_retrieve_fd, token, LUO_IOCTL_INCOMING),
 	IOCTL_OP(LIVEUPDATE_SESSION_GET_NAME, luo_session_get_name,
 		 struct liveupdate_session_get_name, name, LUO_IOCTL_ALL),
+	IOCTL_OP(LIVEUPDATE_SESSION_FREEZE, luo_session_freeze,
+		 struct liveupdate_session_freeze, flags, LUO_IOCTL_OUTGOING),
 };
 
 static bool luo_ioctl_type_valid(struct luo_session *session,
-- 
2.56.0.398.g882cbad275-goog


