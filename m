Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFF03607009D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=BXv9lhRd
Received: by kanga.kvack.org (Postfix)
	id 33F276B05B5; Tue, 10 Nov 2026 19:24:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316656B05B6; Tue, 10 Nov 2026 19:24:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205346B05B7; Tue, 10 Nov 2026 19:24:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE2FA6B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:24:15 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D16F28012A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:13 +0000 (UTC)
X-FDA: 85420941186.02.85455D2
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf25.hostedemail.com (Postfix) with ESMTP id EB059A0007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:24:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BXv9lhRd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3qrXzaggKCEMirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3qrXzaggKCEMirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794356652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pksLN3i9UP8nq6v/POjqMIUemdvKGeqKKQAaazi0ic=;
	b=PFKhr8Y51UsZdxmJwX8JsGPKhOQETL2688XofB7MYFe+2HgsR0uMqjvmDM8fGPMN5/EHPm
	Fk0hsQBHzxS+SkbcdjTAanslMw6j48flZLd0GBCgfriHCgTOCU+J0tr0GlC18UAUG3z1r4
	SPQVqNpLsTsApA1E/s/kwmkLNJxmJyk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794356652;
	b=OfqmM6obs3Om7i5h42DMMQDe9T1yzBOjr7+4dhAhvaSDeyHi0vhT5F7pbCheSfd/UF06L/
	NkRHb428SGMhfJH5G26qqdLY8RPoeABUImsWMSnd/bbpHdaCGJ6mfUF2gT3gMZyZvrLRqC
	rIuGGf06rIrLHO4bbTE4xbF/qVRLqrk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=BXv9lhRd;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of 3qrXzaggKCEMirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3qrXzaggKCEMirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4c55ba309c2so3202128b6e.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794356651; x=1794961451; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6pksLN3i9UP8nq6v/POjqMIUemdvKGeqKKQAaazi0ic=;
        b=BXv9lhRdwEAgF+nDID0HmutTzTozqrFy6h4ynbBOjjMGYdXZio7A/VrMBDKiZMvEvA
         yUwJlHsNQN1PEAFJOaNoaCctNk+CZOGtbG3tyqD5cs9QdNFz7L+2fzVOUwmnu7UXlqda
         1wQCE46nxPAigQo0jBt+ckwMhunoNYiLlY9iBr4GjgZqgjyWQFgImIeSaplvFTM8/PAB
         ubyAwUa0MF4PIRnOjZGs7TiS3vJ38GaQBb8+1JzHlmuVQTdtjx+tR7hSZmbiYYfzz2or
         yr+FrOjKWHErfNrlnrJea68FGSKwG1M/bIOalAkML1xqCPxD3YdmGk2z9qvpDZ+VD7Oy
         AcLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794356651; x=1794961451;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6pksLN3i9UP8nq6v/POjqMIUemdvKGeqKKQAaazi0ic=;
        b=GS/zwy2VjBY6EBkNPnZSt2xaV9zvPbKKcKCXrHrCcyY/GWxYcaS6NJsmRonvdm/DZX
         Ht/9i9zUKHiwXqE/29MWWySoA4bqR1yamPB1OIPHQlMqDc/kp2R8u8Xa43Rhaz8gCpCv
         pYavyHCbK51/nm9X7zMr5AVAHvVOMGcigkfULErV6aGkYG2wLmnFqFRedHWUGMntB6Vq
         P1B72ysjrLzzGyHrEQWod6VAKkvLGAxtRaHBYcfSua70aYVZV9USH0rwwXRn719QpIrV
         TgqiztSM9D5wCSkuslQSUXuV7moW1+tj58K0c37eS6DWdvoPBiaDGSeZmwIPl8aO21Vr
         0/wA==
X-Forwarded-Encrypted: i=1; AL+hErFqqsku2/iff25H8NW292Mkbw4APApHh+iwcw9QDR6U4HiMhILHC3E/J10reoWYrBd6/LlZIf5N+A==@kvack.org
X-Gm-Message-State: APuU4Z++0tZhYA2mhT9OZ5sNWJpW13NWU7KQk8DQCyNOiGIJFgXJueyK
	oe69r7RodvIv5uyfjTYavMHYUmwY0bkZQLkm3uI037YqW3tX16mCqmdWAFhSS6dc+8gYq0B5nBW
	HqJm/t/6kE9eU6A==
X-Received: from iohk8-n1.prod.google.com ([2002:a05:6602:a608:10b0:9ca:dc6e:2262])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:148e:b0:4f5:20:d847 with SMTP id 5614622812f47-56b97611f9dmr681603b6e.36.1794356650705;
 Tue, 10 Nov 2026 16:24:10 -0800 (PST)
Date: Wed, 11 Nov 2026 00:23:41 +0000
In-Reply-To: <20261111002358.1842967-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261111002358.1842967-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.542.g3ef89b7020-goog
Message-ID: <20261111002358.1842967-4-dmatlack@google.com>
Subject: [PATCH v4 03/19] selftests/liveupdate: Add tests for preserve and
 retrieve user argument
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
X-Stat-Signature: wfpnzmjpi55b3dkw37eexxybn9eej6w7
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB059A0007
X-HE-Tag: 1794356651-794811
X-HE-Meta: U2FsdGVkX19+MFouB9Rg5BYex9Xocju/u18LHtktaKeE0kUsiUyRT48bkYUqAFx6UsLVxHH6o03JE29CCqTnIkU1+Ynd/kjUzMoqzzEjKDttxxhKfGOG8GitQ4xEcsI8Tw3v0pmcGVFU6nUs4hUDctLXOkOWsdi5AnJ3jnXRmfS+SkqTdjpEg//BuKBt/27x70Gs4TkGK+f03YDQU5uL4ksGe9PsVOopSdpowV9jcfQh2wRminSYMhnZLt4qNU3xCFQMtiVaMzrf0Ot8cjrGbwYT6xj1ghlZb1gMwh19k3EscVdDSQkf4/xsIh3gyV3Fe9zba7dozV5zuz4MpwjXwuFSnK0MWR2xBmFXUGM6jtCJCOiUYyo55YRXzYZsajvgHxSK81zFAm2yDspFEElNPa4X8JFU27JIETZvBEN4a+Kv/jwyU2uhKF5zfhjduEY9Glj63puZqVst5Ts5ER/LVomGc5n7f3CMZtNh5b8L5Tl+J0h/goKLl3fo0iHioZn5VS9Jg8g402ZzEevqMJXX6jXhS/HsFvYFdW5KDefgVFJY5n4L0rrfheVDMEA0Nu/nZ1qHAxHF5mo2RainhhTwj4/XBi7YONFVT69RknAl451Cbndv7rl2i1OzMFZdHHf3wApnMg8L58m5Voy5muCCcmqGW2+7HaPROJtqcBuAylLhrksLj+3fn7HN69ASxS4qWoIYznDIf20jeZFTFUSyBX387965VQh30qJaNmEZEmadVVLNSl217p3TzQ7Y1Kv2iA/Fw8szORTVY1nNxrDbra8vZyWz0PLfQ8OrG1i8mmg8FVAh+AFaDzHXRSeNBjY0w4DnlUXo10YyrTbpPhhhOsDy5V9CzinBuIwhRGq1fW9XIhPJyKwN1LwZB9ZvyCnln7u2yH3kqV7v5o92HrWUEitn+NDlO4iJWrcujosHVxCh849GoNES3m07PLpBIXjeKQbgPruGYHgJZofmGtf
 r4GAe/IQ
 0vYNDY9nk04X3AsIq5t/Ks2SBeI9MSLuDlsGhNxXxS/Z8GHdTYM6mQkibc8CUAvJTF6pXc1ew+rrhWUpxyeNsV2C1C019KaCoRidjZ/9ZzFH/EzaE/XeNOYJzlma5xNiUTMzG1Ih/F6Q4mrVvYyr4xBOqsdiD9/wwXOBi2Am05wb4B9NAjawVRnbj0wrZsoutKCAYIy8p88fMj+XYS407FyXK9WSr7rx0tfo2zQLimbbbeS+g9AA/pn//IrEAq718vTHI4UeJyxm9pmmdQZu0USRXQ4iNymqN5e6Wn9JPJHH35V0A4z+AY9wzBuLf0ErQQw2oD35A2jerLDvJfdrvmiprFJXKUgVA2Hja9ljDoI9FCoYDob+068OI3Gl2kwtaGRAhX+q3VeOrAFH/CviWryH4hwH7xaLdNH0+ce+4yWLhy+V0A47/mLh/LQpavxKz41aPX2diyqwjZXfXZMzFiAYCpvUJWyzJABId82kcXls+PntwO+4s5yB1ehZTXRXkXfCRELkTtejKeuTPmnfar9Vr+Db3zOBrCFyJzS+MmA1cHi4fisuwggBpja3mHI36+nwN4HtuhdVxGN4FdsKrVUgEcywMq5UCEs6LaVdvd27+TmUSVJSjIPX+GZEqOufTE1PmtAAQ5uDwnnQ5zRtFAERag6DVxMgngjMc3siPY0vrlS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Pasha Tatashin <pasha.tatashin@soleen.com>

Verify the user argument support in LIVEUPDATE_SESSION_PRESERVE_FD and
LIVEUPDATE_SESSION_RETRIEVE_FD. Add luo_session_preserve_fd_arg() and
luo_session_retrieve_fd_arg() helpers to libliveupdate so tests can pass
a handler-specific argument.

Add a preserve_memfd_with_arg test case to verify that memfd
preservation rejects a non-zero argument with -EOPNOTSUPP, accepts an
explicit zero argument, and remains compatible with callers passing the
legacy struct size up to the token field.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 .../liveupdate/lib/include/libliveupdate.h    |  3 ++
 .../selftests/liveupdate/lib/lu_utils.c       | 17 ++++++-
 .../testing/selftests/liveupdate/liveupdate.c | 44 +++++++++++++++++++
 3 files changed, 62 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
index fa07fed08364..cd1d843a0d3d 100644
--- a/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
+++ b/tools/testing/selftests/liveupdate/lib/include/libliveupdate.h
@@ -29,7 +29,10 @@ int luo_get_session_name(int session_fd, char *name, size_t name_len);
 
 int luo_ensure_nofile_limit(long min_limit);
 int luo_session_preserve_fd(int session_fd, int fd, __u64 token);
+int luo_session_preserve_fd_arg(int session_fd, int fd, __u64 token,
+				__u64 user_arg);
 int luo_session_retrieve_fd(int session_fd, __u64 token);
+int luo_session_retrieve_fd_arg(int session_fd, __u64 token, __u64 user_arg);
 
 int create_and_preserve_memfd(int session_fd, int token, const char *data);
 int restore_and_verify_memfd(int session_fd, int token, const char *expected_data);
diff --git a/tools/testing/selftests/liveupdate/lib/lu_utils.c b/tools/testing/selftests/liveupdate/lib/lu_utils.c
index 74d41115c281..db7a90b002cb 100644
--- a/tools/testing/selftests/liveupdate/lib/lu_utils.c
+++ b/tools/testing/selftests/liveupdate/lib/lu_utils.c
@@ -79,12 +79,14 @@ int luo_retrieve_session(int luo_fd, const char *name)
 	return arg.fd;
 }
 
-int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
+int luo_session_preserve_fd_arg(int session_fd, int fd, __u64 token,
+				__u64 user_arg)
 {
 	struct liveupdate_session_preserve_fd arg = {
 		.size = sizeof(arg),
 		.fd = fd,
 		.token = token,
+		.arg = user_arg,
 	};
 
 	if (ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &arg))
@@ -93,11 +95,17 @@ int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
 	return 0;
 }
 
-int luo_session_retrieve_fd(int session_fd, __u64 token)
+int luo_session_preserve_fd(int session_fd, int fd, __u64 token)
+{
+	return luo_session_preserve_fd_arg(session_fd, fd, token, 0);
+}
+
+int luo_session_retrieve_fd_arg(int session_fd, __u64 token, __u64 user_arg)
 {
 	struct liveupdate_session_retrieve_fd arg = {
 		.size = sizeof(arg),
 		.token = token,
+		.arg = user_arg,
 	};
 
 	if (ioctl(session_fd, LIVEUPDATE_SESSION_RETRIEVE_FD, &arg))
@@ -106,6 +114,11 @@ int luo_session_retrieve_fd(int session_fd, __u64 token)
 	return arg.fd;
 }
 
+int luo_session_retrieve_fd(int session_fd, __u64 token)
+{
+	return luo_session_retrieve_fd_arg(session_fd, token, 0);
+}
+
 /* Helper function to get a session name via ioctl. */
 int luo_get_session_name(int session_fd, char *name, size_t name_len)
 {
diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/testing/selftests/liveupdate/liveupdate.c
index 2dedd5fc2534..4c4272167635 100644
--- a/tools/testing/selftests/liveupdate/liveupdate.c
+++ b/tools/testing/selftests/liveupdate/liveupdate.c
@@ -20,6 +20,7 @@
 
 #include <errno.h>
 #include <fcntl.h>
+#include <stddef.h>
 #include <string.h>
 #include <sys/ioctl.h>
 #include <unistd.h>
@@ -530,4 +531,47 @@ TEST_F(liveupdate_device, preserve_many_files)
 	ASSERT_EQ(close(session_fd), 0);
 }
 
+/*
+ * Test Case: Preserve MemFD with User Argument
+ *
+ * Verifies that passing a non-zero user argument to memfd preservation fails
+ * with -EOPNOTSUPP, while passing a zero argument or using the minimum struct
+ * size without the arg field succeeds.
+ */
+TEST_F(liveupdate_device, preserve_memfd_with_arg)
+{
+	struct liveupdate_session_preserve_fd min_arg = {};
+	int session_fd, mem_fd1, mem_fd2;
+
+	self->fd1 = open(LIVEUPDATE_DEV, O_RDWR);
+	if (self->fd1 < 0 && errno == ENOENT)
+		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
+	ASSERT_GE(self->fd1, 0);
+
+	session_fd = luo_create_session(self->fd1, "preserve-arg-test");
+	ASSERT_GE(session_fd, 0);
+
+	mem_fd1 = memfd_create("arg-memfd-1", 0);
+	ASSERT_GE(mem_fd1, 0);
+
+	/* Non-zero arg is not supported by memfd handler */
+	EXPECT_EQ(luo_session_preserve_fd_arg(session_fd, mem_fd1, 0x1111, 1),
+		  -EOPNOTSUPP);
+
+	/* Legacy struct size (up to token) should zero-fill arg and succeed */
+	min_arg.size = offsetof(struct liveupdate_session_preserve_fd, arg);
+	min_arg.fd = mem_fd1;
+	min_arg.token = 0x1111;
+	ASSERT_EQ(ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &min_arg), 0);
+
+	/* Explicit zero arg with full struct size should also succeed */
+	mem_fd2 = memfd_create("arg-memfd-2", 0);
+	ASSERT_GE(mem_fd2, 0);
+	ASSERT_EQ(luo_session_preserve_fd_arg(session_fd, mem_fd2, 0x2222, 0), 0);
+
+	ASSERT_EQ(close(session_fd), 0);
+	ASSERT_EQ(close(mem_fd1), 0);
+	ASSERT_EQ(close(mem_fd2), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.56.0.542.g3ef89b7020-goog


