Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E3A6606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 22:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Lbw0GxdG
Received: by kanga.kvack.org (Postfix)
	id 878346B087F; Tue, 24 Nov 2026 17:59:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8289B6B0881; Tue, 24 Nov 2026 17:59:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0E16B0882; Tue, 24 Nov 2026 17:59:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F2066B087F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:59:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDE89C0D57
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:47 +0000 (UTC)
X-FDA: 85471531614.20.7C46714
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 316708000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 22:59:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lbw0GxdG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795561186;
	b=zseP77si8lQmmP6pArFH+0RBWemshzP1lVM2dZ8pcONq8rvx+1Z5jlogTJP4xrwkhSbIqu
	Pn1QnfOD9/GUkuirP62WFQA+CNUP2vHavLWXbm+rMVrirFU53iLhlWAAuS9r/FAkyAdQhW
	tSdPiHXQ7uP/xZ/MZNd/aPuTw3PmaTs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795561186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVadO6FN4yERgIRYvZ1jIjoIb/Ez8TcW7BKAOAgnUo8=;
	b=KiUO09n8nmSIiLps32cvWJEQrA9I+dJtu0NffXCVhriGD+/89f4/fa/BWAKu6WXin0SaLz
	+uie0Fc6J15AwIM6Mu2KMjmBquTGIcuG7w06vaIBZGBekVGbvSv6hAsXIbL1EHwUYWgofW
	SAzHC+GHdZu43TE6jp6lYEbzHGkSvD4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lbw0GxdG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C269C62387;
	Tue, 24 Nov 2026 22:59:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3580E1F000C4;
	Tue, 24 Nov 2026 22:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795561185;
	bh=PVadO6FN4yERgIRYvZ1jIjoIb/Ez8TcW7BKAOAgnUo8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Lbw0GxdG1Nz4OYr89mliWrg+kYmoXuGpeF3Gy9/2dbtXNZ0iSefXiM7lIBAM0nu3J
	 /69CBhU3xMLpaBoFqrZurjIhfD7jGd/cTR5OtTwwXmduswoZxlIuosPRpvNuWyk1SK
	 0kPp4/KUnIP1tuWwRhZuVCLrdQaMjU8pjLRTK/GsEcfw/fF64yjQ4WfwQNMIBnFbLS
	 uH1xp0WERf0s5Hx8LOgMekEUWtMI14yuoLpi+zSxnWTURAo8cbAxcfUESfjwivBsCE
	 L8zJNrzytFV6SV55S5iE/n2Y57ZRjMBmK4bdrqjjSWInapipQRLHyPWz4zJ1bZ5f2p
	 CfPqP08p9p0Ag==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 23:58:27 +0100
Subject: [PATCH RFC 04/19] perf: copy ioctl arguments without ctx->mutex
 held
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-exec-update_lock-v1-4-e489035395b8@kernel.org>
References: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
In-Reply-To: <20261124-work-exec-update_lock-v1-0-e489035395b8@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-fsdevel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>, 
 linux-perf-users@vger.kernel.org, bpf@vger.kernel.org, 
 selinux@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org, apparmor@lists.ubuntu.com, 
 David Hildenbrand <david@kernel.org>, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=7025; i=brauner@kernel.org;
 h=from:subject:message-id; bh=N17DCeHiDWeBL9NdRznr81HJuP5L50OLTyEoYplFMWc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSzie06+nb3H9XVp+bPYNYKeX/QdNcXrtusH06Wcl7Y8
 rB0r1SgekcpC4MYF4OsmCKLQ7tJuNxynorNRpkaMHNYmUCGMHBxCsBEFmxm+F9nvaLvr17ujpqF
 M522Cbv1R/tu+bDLJ6P8e8CFc+tmVPQz/C/5t5rt4IJVRzquKqkuZlTI6nuRwMW6/dWtL963Wqq
 fv2QDAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 316708000B
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: itta57yesbtqmtdqkk8yxoc49nmphaf1
X-HE-Tag: 1795561186-9491
X-HE-Meta: U2FsdGVkX193a/0/F3/e9Y4kZddVCbxmiwyqNnQK3hOUKnEywosCK8qaQpIalvXcNlL8SUMVHsz880mILIqtw/N7KNg0bGm2sL2rxzYpJrgeyJxGds4Qd6NmuZjVpnPhKx6UH3cVtcL0+kqECWcWuxshkeSlxQmXRRawOa2D03SR3U13jTON1pdwKff0sgOeb2JlaGlefOM71/wXlkm/8+PkLRQg2X+E6LQwdf7Uv/U6jIShECMkSeVQJyhO/9BInSIENORjZhFXfnn142p2iVUH7mbxWxK5X6Zbo5yCnVSwoD4wUINdWX1hYThe7qBqE/CL3g6oPoWN9R046sKRP90RT1mePc4XetLIcxNEz6nZPStLc/RsAx0lFoKrARAeHYI9EsmbUb+LetOP5WVR0+FY/wJugCw7Y7A9tZxKUZPrQavLR0baKEJ9Vjyj/snt8BuKDoxOsKb2vPoRZZtOrex2FIBIMIR+aT5Avyur4FmsmwMRk9CS1/Nr6kHqsWsHrhI9M6+q8ldfEBzlNwMylJvcPS9kkhNH+wq6mOYn3NVh5telhUWXGNRCg3WTzu0Jedu32fe98cyu8fxZZwrad/UMIk/nQzzeIawoBa0kt2B/7VSzDJpovFNaCdVbXTReEj9DNr1o7/GznIzEHM3qxEXa0vvfT1C0rswYPl9zApwE7V6Ve2NLqmTONbxpa64t7IwGsrEQbeiKpH9T+nbNwvu+O9i/ss75i9Du3Wp38PfJk6Kgan1wpXrpe6g0CKjRqZhTsDrNrlqv+l06veRHr/eM76Zg3pp9kSSVglc6KEdGOvVivNRYuzexOJrlUYM4exGOqsEHC+0FD5gDFeKmu7d11rq28cpq8rM+Njw8sr7SkHM+ERA844UAC9d1+TDl6K1QfebTgMkwleTAOJS+kWtcQ6xKwEGO8o5Tt0e/PuuSNKBKg7ZYPa9k7tAYoYzv+9mntHvIuNGyShhNLGP
 qusWic4M
 QAlFpj4Mgl2mfqa3BrRQVqvmcoLQgNaq43G4t8jLRY6teJXoXiQyij4LUER4ivsEn2Kgo+7BVs87fcfoEQNO45JUb3ou3y1sBQgoCWCp5Y8WbDHqWs+EQiVnmPrt5yxrMsLgxVt8LnouDD3aIorWZoXupcL1JoKgbtjQZrvqKyCJA3m9n9f38McFeLc0ygBlQazCYzUB4kr9HkTGuEP7To/ajdB0jL+e2sr83w6ZewEYSF9xZI4/Vua7rOQfDddXbsChsay57ZNXlXTyl2wHPvdREUoMe62BLauad/q1QfrGpJpWdkkIJFdYvXAm1NjSs+N8ACu/nVaOOo8KGurSa4/mKsb8hr0jIbMoJYy714W270hdjvrX09LtjH2rz/Qfxv5fTw2rKaXw4zC87v6/K7KY6DZR4U3hxdvLW0LlwCa9nL6dyr7qVIbADRP7AIaRTGvaYj0zbQrvmcibgnf3uGEHdrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

perf_ioctl() calls _perf_ioctl() with the mutex of the event's context
held and a number of commands access userspace from there:

- PERF_EVENT_IOC_PERIOD copies the period from userspace.

- PERF_EVENT_IOC_ID copies the id to userspace.

- PERF_EVENT_IOC_SET_FILTER copies the filter string from userspace.

- PERF_EVENT_IOC_QUERY_BPF copies the query from userspace and the ids
  of the programs back.

- PERF_EVENT_IOC_MODIFY_ATTRIBUTES copies the attributes from userspace.

This is the same problem as for read(). If one of them faults the mutex
is held for as long as the fault takes and an exec of the task the event
counts for hangs with exec_update_lock held:

  locks held by perf-ioctl/217:
   #0: (&ctx->mutex){+.+.}-{4:4}, at: perf_event_ctx_lock_nested+0x18f/0x360
  locks held by exec-task/216:
   #0: (&sig->cred_guard_mutex){+.+.}-{4:4}, at: bprm_execve+0xb7/0x1400
   #1: (&sig->exec_update_lock){++++}-{4:4}, at: begin_new_exec+0xa4b/0x2df0
   #2: (&ctx->mutex){+.+.}-{4:4}, at: perf_event_exec+0x17e/0xe40
  locks held by stat-reader/218:
   #0: (&p->lock){+.+.}-{4:4}, at: seq_read_iter+0xc5/0x1280
   #1: (&sig->exec_update_lock){++++}-{4:4}, at: do_task_stat+0x13b/0x2870

Copy what comes from userspace before the mutex is taken and what goes
to userspace after it has been dropped.

PERF_EVENT_IOC_QUERY_BPF doesn't need the mutex. The programs of a
tracepoint are protected by bpf_event_mutex. So call
perf_event_query_prog_array() before the mutex is taken.

Fixes: 2e498d0a74e5 ("perf: Add support for event removal on exec")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/events/core.c | 93 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 36 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f00eeded212c4..5f648e00ae661 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6635,14 +6635,25 @@ static inline bool is_perf_file(struct fd f)
 
 static int perf_event_set_output(struct perf_event *event,
 				 struct perf_event *output_event);
-static int perf_event_set_filter(struct perf_event *event, void __user *arg);
+static int perf_event_set_filter(struct perf_event *event, char *filter_str);
 static int perf_copy_attr(struct perf_event_attr __user *uattr,
 			  struct perf_event_attr *attr);
 static int __perf_event_set_bpf_prog(struct perf_event *event,
 				     struct bpf_prog *prog,
 				     u64 bpf_cookie);
 
-static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned long arg)
+/*
+ * What perf_ioctl() copies from userspace before it takes ctx->mutex and
+ * what it copies back once it dropped it.
+ */
+struct perf_ioctl_data {
+	u64			value;
+	char			*filter;
+	struct perf_event_attr	attr;
+};
+
+static long _perf_ioctl(struct perf_event *event, unsigned int cmd,
+			unsigned long arg, struct perf_ioctl_data *data)
 {
 	void (*func)(struct perf_event *);
 	u32 flags = arg;
@@ -6665,22 +6676,11 @@ static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned lon
 		return _perf_event_refresh(event, arg);
 
 	case PERF_EVENT_IOC_PERIOD:
-	{
-		u64 value;
+		return _perf_event_period(event, data->value);
 
-		if (copy_from_user(&value, (u64 __user *)arg, sizeof(value)))
-			return -EFAULT;
-
-		return _perf_event_period(event, value);
-	}
 	case PERF_EVENT_IOC_ID:
-	{
-		u64 id = primary_event_id(event);
-
-		if (copy_to_user((void __user *)arg, &id, sizeof(id)))
-			return -EFAULT;
+		data->value = primary_event_id(event);
 		return 0;
-	}
 
 	case PERF_EVENT_IOC_SET_OUTPUT:
 	{
@@ -6695,7 +6695,7 @@ static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned lon
 	}
 
 	case PERF_EVENT_IOC_SET_FILTER:
-		return perf_event_set_filter(event, (void __user *)arg);
+		return perf_event_set_filter(event, data->filter);
 
 	case PERF_EVENT_IOC_SET_BPF:
 	{
@@ -6729,19 +6729,9 @@ static long _perf_ioctl(struct perf_event *event, unsigned int cmd, unsigned lon
 		return 0;
 	}
 
-	case PERF_EVENT_IOC_QUERY_BPF:
-		return perf_event_query_prog_array(event, (void __user *)arg);
-
-	case PERF_EVENT_IOC_MODIFY_ATTRIBUTES: {
-		struct perf_event_attr new_attr;
-		int err = perf_copy_attr((struct perf_event_attr __user *)arg,
-					 &new_attr);
+	case PERF_EVENT_IOC_MODIFY_ATTRIBUTES:
+		return perf_event_modify_attr(event, &data->attr);
 
-		if (err)
-			return err;
-
-		return perf_event_modify_attr(event,  &new_attr);
-	}
 	default:
 		return -ENOTTY;
 	}
@@ -6758,6 +6748,7 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	struct perf_event *event = file->private_data;
 	struct perf_event_context *ctx;
+	struct perf_ioctl_data data;
 	long ret;
 
 	/* Treat ioctl like writes as it is likely a mutating operation. */
@@ -6765,10 +6756,46 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	if (ret)
 		return ret;
 
+	/*
+	 * A copy from or to userspace can sleep in a page fault. Don't hold
+	 * ctx->mutex for it.
+	 */
+	data.filter = NULL;
+	switch (cmd) {
+	case PERF_EVENT_IOC_PERIOD:
+		if (copy_from_user(&data.value, (u64 __user *)arg,
+				   sizeof(data.value)))
+			return -EFAULT;
+		break;
+
+	case PERF_EVENT_IOC_SET_FILTER:
+		data.filter = strndup_user((void __user *)arg, PAGE_SIZE);
+		if (IS_ERR(data.filter))
+			return PTR_ERR(data.filter);
+		break;
+
+	case PERF_EVENT_IOC_QUERY_BPF:
+		/* Looks at the tracepoint's programs under bpf_event_mutex. */
+		return perf_event_query_prog_array(event, (void __user *)arg);
+
+	case PERF_EVENT_IOC_MODIFY_ATTRIBUTES:
+		ret = perf_copy_attr((struct perf_event_attr __user *)arg,
+				     &data.attr);
+		if (ret)
+			return ret;
+		break;
+	}
+
 	ctx = perf_event_ctx_lock(event);
-	ret = _perf_ioctl(event, cmd, arg);
+	ret = _perf_ioctl(event, cmd, arg, &data);
 	perf_event_ctx_unlock(event, ctx);
 
+	kfree(data.filter);
+
+	if (!ret && cmd == PERF_EVENT_IOC_ID &&
+	    copy_to_user((void __user *)arg, &data.value, sizeof(data.value)))
+		return -EFAULT;
+
 	return ret;
 }
 
@@ -12367,14 +12394,9 @@ perf_event_set_addr_filter(struct perf_event *event, char *filter_str)
 	return ret;
 }
 
-static int perf_event_set_filter(struct perf_event *event, void __user *arg)
+static int perf_event_set_filter(struct perf_event *event, char *filter_str)
 {
 	int ret = -EINVAL;
-	char *filter_str;
-
-	filter_str = strndup_user(arg, PAGE_SIZE);
-	if (IS_ERR(filter_str))
-		return PTR_ERR(filter_str);
 
 #ifdef CONFIG_EVENT_TRACING
 	if (perf_event_is_tracing(event)) {
@@ -12399,7 +12421,6 @@ static int perf_event_set_filter(struct perf_event *event, void __user *arg)
 	if (has_addr_filter(event))
 		ret = perf_event_set_addr_filter(event, filter_str);
 
-	kfree(filter_str);
 	return ret;
 }
 

-- 
2.53.0


