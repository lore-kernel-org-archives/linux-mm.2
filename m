Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8460C982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06D0F6B00E5; Mon, 21 Sep 2026 09:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 045826B00E6; Mon, 21 Sep 2026 09:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E280D6B00E7; Mon, 21 Sep 2026 09:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B08DD6B00E5
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C47C91201B1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:48 +0000 (UTC)
X-FDA: 85237892376.21.78C22AB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id ECFC88000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPLFbMp5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C1pfPreOO6HKMgZ9q+Nqw+m6d7jYr0ACpShFH4V9mcU=;
	b=YIubb4+mQAqSYhq1Vl0+w37IkHNNGf83fNMfaYRVgWQ1MIM3gy7ax2gkx+l2lZHOUmvVai
	62/g/I1zGgzN43H5tBjyqZSy/XDVDo70XF2MailHhhAUV+HZAIpXTkxJKkyKJPBTdSdHtv
	w5NIdIoIn/CUaLI5BFWST5QhVRiirpE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998347;
	b=7J+Z70+CHBHMuDL+o4YkKvH6OsrjEWp/PzkNvriLgxlaAQLI+Vazlv+BjgI9RnZQpEyFiD
	MKEzWxvHHihPyLcAVNDmQu5+a2e43iC9JgKezk1mKuPIh7zKz/eOlgvSi++wa/rT5BGAx/
	6uTx2YNvQcbylRQ66EyE4R7qaMZAhis=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPLFbMp5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41841437AF;
	Mon, 21 Sep 2026 13:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459E01F00893;
	Mon, 21 Sep 2026 13:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998346;
	bh=C1pfPreOO6HKMgZ9q+Nqw+m6d7jYr0ACpShFH4V9mcU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OPLFbMp5APpFtxsxTti4fNjZl+zGL2kKVPIF4twuXm8Vv5JzNj5Uk/61J1WYuyd+b
	 VFYkPbMFJlf7ujPd7iI071pGkNVX7bZEy59Ivs8GxWcWoOlaPEoxJu/82IdiMZEYMz
	 4LwQiANgIin1sxxhYMkYsdSSXn2aPB6uFzzLcLa0PtWvpLoGSB/8uN6t8Q9720TVUC
	 6ForjC4p0vkAEquj9i2NaYfeqGD8wSdrsHzFL7ZAdjoRmdQ3xID2q3ZGosVx8ld7kU
	 KoOskmGT8Q+wDg+Kdp8I54ZiaoLJaO2T1jEuZKrClfx/pFJteTsHk2TgpgFlvfAPze
	 gIQzq7HkgSGiw==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:45:00 +0200
Subject: [PATCH v3 11/17] selftests/coredump: expect PTRACE_SETSIGMASK to
 be refused on a user worker
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-11-8e4adb1619e6@kernel.org>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
In-Reply-To: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=3510; i=brauner@kernel.org;
 h=from:subject:message-id; bh=y1jOkzZuO9VHLKMd/1GcHI3KZB/M7wgZM5eLLCIt5GE=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLmzN7HmW9fVol0em69sXzTtfdueq2u8xY4ErL76Y
 PkH7qXzVnaUsjCIcTHIiimyOLSbhMst56nYbJSpATOHlQlkCAMXpwBMJOYvwy+m5xZfq4M2P9IR
 vVVvNX++2z6uvxmnZz0S0hUVWhr53G06wx8e3qv7RBeVTH9swcyg8tkvdNVfP1nhoDeh0q9LX2b
 LnuIHAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ECFC88000B
X-Stat-Signature: 969y4see7sk1bwwxyow4an1mui3nqozp
X-HE-Tag: 1789998346-892680
X-HE-Meta: U2FsdGVkX19cc39nRpeKRkYxMLVr5LPFz3RQ+Tz4zLnVI6cw2okKrf9ba2mqjJkvxN0p1sCS1mUEtpfgYlOicnvZz3m5BApotAMnRX1HIAoZtQLdMx8UbBfc89cNL8mHmnc0MKJS1pmXXcEq1Zu+CFANT217iF6XPx3RHoPNdgprkio3vTHNmPz9vwI0ad4nVlAp7xHE8hBgZmfRsVlzYpcPvdIczrVciUbWeyn1DqeEQElwjoenhWxJRUVP1uIR8H0ogWt0UQJWfncbrwDfXwbH8pV7N9+ADUR4x6iVaQRnV6TGdiJXLMiRe1Pi62N8KIKxhVXMbFFI5orO9AVGBiOM7Zm0CaGWylFbBbuQCnM7xEbfm5rehLVLkbfeTUQNrFJjLjPwrkAjq53m8ocR9Wlq95SAJ0jNEabeJoUBWBdAaBAdUURbOBYwhpJwX/iufSS1zI1SsrLzRKyQElgNJ+Hr3KwIjDB6DjNCqL6Dvfyi3JIAdFKXEVgMXxkSXD8JNIIiVWASNjLXr+fdlBAU3/AfgZcaac8wP/UrCYxXaHEHHThSFnOcj2ht7nZfdNUMw+Z1lpo18jEvmOsHYkYpb2Jj094Nt1Nkbspxf5tpTxfeDPtdTFnTusPlR7eeRCXjHskWLrM/ZxM8HTBKehqtOYtB+7BAvJYiSMYCsGZN9aFWFUXl921UJkNr7B6Sy39kCEFBtgnXLrsIf1qPMsaYGpcrulPaGQgxEnlz14OoICHxrRFXA3Qlj2WW1XVMfIpQyoNOGm38TlRfIkUoLvtaCXDyed5fuxTBfJsK3B8gzgS61H8BkUJv24ZVByu0bnsL3QUK5bt4glIiQI69sgFrp85YtxHvKx93ap6l3iTnFe+C5SYVPwKUK0kG7Fl8TVPwBCEVCTKpK5s9SRinKYLlZU18sGet4GOUk6foWbOziCxeCNPwEAIDCO4QVLU4s/Cz/I4aSXn+xHfmDu60/E+
 zwk3g666
 LapwGcaIGlySMuD1VGwZoN8DlioisiIs3hfd2hsyycv/hehT/O61qVT4kodCQRqFF4NECU2aLiZ4aaSC2Gf6pizSBoFJgBkJ+UXBlBjSiKIEn5TS3c4uMcecDQATF27cuhYtqCneKWwOJVcTNlfrzs65brPEq/9i/UZBYDqjBEF1txuPMXtzAYO+yRlbVISS73wTHBMN89k7CyMMwHUGxKT7aMsaqAQsvPkbXwu/C7Rf+V1PWDBu3+Vo0EeNkqcJx8PUj6Rz6IYPUe3kjAYKfEbh9aqUpoEtUBBpM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PTRACE_SETSIGMASK returns -EPERM for a user worker now.

- inject_coredump_signal() reports whether the mask could be changed
- a refused mask means the injected SIGSEGV stays pending on the worker
- the worker cases check that the group is alive and kill it

The main thread case still dumps.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 .../selftests/coredump/coredump_worker_test.c      | 44 ++++++++++++++++------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/coredump/coredump_worker_test.c b/tools/testing/selftests/coredump/coredump_worker_test.c
index 81cadde0e752..9a4270b65a6e 100644
--- a/tools/testing/selftests/coredump/coredump_worker_test.c
+++ b/tools/testing/selftests/coredump/coredump_worker_test.c
@@ -16,6 +16,7 @@
  * SIGKILL still works. A failure leaves the stuck process behind.
  */
 #include <ctype.h>
+#include <errno.h>
 #include <dirent.h>
 #include <fcntl.h>
 #include <sys/mman.h>
@@ -255,24 +256,31 @@ static pid_t find_thread(pid_t pid, const char *prefix)
 
 /*
  * Attach, stop the thread with SIGSTOP, drop the signal mask that
- * copy_process() gave it and resume it with SIGSEGV instead.
+ * copy_process() gave it and resume it with SIGSEGV. Returns 1 when the
+ * mask was changed, 0 when PTRACE_SETSIGMASK was refused (a user worker
+ * keeps its mask and the SIGSEGV stays pending), -1 on any other failure.
  */
-static bool inject_coredump_signal(pid_t pid, pid_t tid)
+static int inject_coredump_signal(pid_t pid, pid_t tid)
 {
 	__u64 mask = 0;
-	int status;
+	int status, ret = 1;
 
 	if (ptrace(PTRACE_SEIZE, tid, NULL, NULL))
-		return false;
+		return -1;
 	if (syscall(SYS_tgkill, pid, tid, SIGSTOP))
-		return false;
+		return -1;
 	if (waitpid(tid, &status, __WALL) != tid)
-		return false;
+		return -1;
 	if (!WIFSTOPPED(status) || WSTOPSIG(status) != SIGSTOP)
-		return false;
-	if (ptrace(PTRACE_SETSIGMASK, tid, sizeof(mask), &mask))
-		return false;
-	return !ptrace(PTRACE_DETACH, tid, NULL, (void *)(long)SIGSEGV);
+		return -1;
+	if (ptrace(PTRACE_SETSIGMASK, tid, sizeof(mask), &mask)) {
+		if (errno != EPERM)
+			return -1;
+		ret = 0;
+	}
+	if (ptrace(PTRACE_DETACH, tid, NULL, (void *)(long)SIGSEGV))
+		return -1;
+	return ret;
 }
 
 /* Reap @pid within @timeout_ms, -1 when it is still there. */
@@ -333,7 +341,7 @@ static void run_dumper(struct __test_metadata *const _metadata, bool sqpoll,
 {
 	bool killed = false;
 	char path[64], c;
-	int ipc[2], status, fd;
+	int ipc[2], status, fd, ret;
 	pid_t pid, tid;
 
 	ASSERT_TRUE(set_core_pattern("/tmp/coredump.file.%p"));
@@ -361,7 +369,19 @@ static void run_dumper(struct __test_metadata *const _metadata, bool sqpoll,
 		break;
 	}
 	ASSERT_GT(tid, 0);
-	ASSERT_TRUE(inject_coredump_signal(pid, tid));
+	ret = inject_coredump_signal(pid, tid);
+	ASSERT_GE(ret, 0);
+	if (!ret) {
+		/* The signal sits on the worker, the group must be untouched. */
+		ASSERT_NE(dumper, DUMPER_MAIN);
+		TH_LOG("PTRACE_SETSIGMASK refused for tid %d, the SIGSEGV stays pending", tid);
+		ASSERT_EQ(wait_exit(pid, &status, 1000), -1);
+		kill(pid, SIGKILL);
+		ASSERT_EQ(wait_exit(pid, &status, EXIT_TIMEOUT_MS), 0);
+		ASSERT_TRUE(WIFSIGNALED(status));
+		ASSERT_EQ(WTERMSIG(status), SIGKILL);
+		return;
+	}
 
 	if (wait_exit(pid, &status, EXIT_TIMEOUT_MS)) {
 		/* No dump. Whatever happened, SIGKILL must still work. */

-- 
2.53.0


