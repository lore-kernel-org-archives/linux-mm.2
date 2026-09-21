Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A78BC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 13:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108FB6B00E4; Mon, 21 Sep 2026 09:45:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B9956B00E5; Mon, 21 Sep 2026 09:45:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEA196B00E6; Mon, 21 Sep 2026 09:45:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B69476B00E4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:45:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C3876801B7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:41 +0000 (UTC)
X-FDA: 85237892082.06.F76C537
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 10AC480008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:45:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jluAyHbw;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789998340;
	b=HmEYN6cICO+ZKv5OxKe3BghXoRpsJsFBRmNibnhio6QJ0myeD8qKg+GUUL7idi/aMiR4b1
	AXSf9efA4evnOO2ikLe9PSd92kqbH8L07adSKYENlhGaOH1KMG3ESvxVyAI0GGk+pR6AQC
	KOzbVlTDhglBmB/R9DKBDHv7Akv/vMU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jluAyHbw;
	spf=pass (imf02.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789998340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=85CevHKublMmHOSHJkcM1sjBk3a15MmFBWjuAkGzmnQ=;
	b=esGUNlZIY8GFH/PhnVBiv6nOYxbxim7P4Br7OyL8tcKNNcCuU/iILwAp7lJ1QWgKzBjDaZ
	umsk03xOIywy59Xbh+3sQzYDU5PpZvRHTSCsrqXf0Pn56N+Cf9FRCX667E/AzcdAIhx4k9
	uaIYWY9c4Z2ii2+IGNzKS+I/cKhMy0A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9ED4560142;
	Mon, 21 Sep 2026 13:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43E5A1F00898;
	Mon, 21 Sep 2026 13:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789998339;
	bh=85CevHKublMmHOSHJkcM1sjBk3a15MmFBWjuAkGzmnQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jluAyHbw2vEqmozixFTqdTe7zlSB6njFRBAJ0ExWMwKyQQrPnuLpAfq1sqHtIkLQv
	 /vCwG0jwKhX5dWk1usPTY5RW9pPsMgHw/K5WZYgbKog0mB29goPiwAmHbEvRXAhQqj
	 RMfOhw10tX/dA8m8hj4rPGsV1pIROIrdBpAZb4o6n+Cs+mJPL66eJUmoyaRjUv5QPx
	 Dpxe2vQvNMW+mVzy2NCrfmhfTaorDsespkd/MKmFbrgmHY90Twh1Fc3WXLh0CkHrrR
	 uMwGGpE25bIuDTXFfhKq6JyqvdVuUGD9lD4XRX4dKj1FKCbfuqIISCcPqkJKjNIv7/
	 6H5hC1Tk1CVew==
From: Christian Brauner <brauner@kernel.org>
Date: Mon, 21 Sep 2026 15:44:58 +0200
Subject: [PATCH v3 09/17] ptrace: refuse to change the signal mask of a
 user worker
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260921-work-coredump-fixes-v3-9-8e4adb1619e6@kernel.org>
References: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
In-Reply-To: <20260921-work-coredump-fixes-v3-0-8e4adb1619e6@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>, Chris Mason <mason@kernel.org>, 
 linux-fsdevel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, NeilBrown <neil@brown.name>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 linux-mm@kvack.org, io-uring@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1918; i=brauner@kernel.org;
 h=from:subject:message-id; bh=8SAsMjkrngSWGdQKZl/aHd6rJ4X+T1wuo4AkDdyJKso=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRtNLmzsfIlz+eogHshBmkqp7OcPmRILunQf6EqGXw1y
 /2qO/PzjlIWBjEuBlkxRRaHdpNwueU8FZuNMjVg5rAygQxh4OIUgInUyDL8s1+X5tHrcadbPnPv
 4o/nblRe+tdRGHO29Plc/bz/J/+6MzP8M30iLPbjpPCdKJsZOpv87HT7G+4+eLAnId91l7tlTUM
 OCwA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 10AC480008
X-Stat-Signature: frunuuqudyhr5n431ihfthz7aeia4n7r
X-HE-Tag: 1789998339-652589
X-HE-Meta: U2FsdGVkX1/y4IfjRCTqxQc28UE5FscTw9vw0im+IrO4OcWr2WYRwd2p56GuI5jxqymiTCaIIEz7n7+KH1k4+BVow3dnOPTl26lTcF3xs/qwsvuGaHZrFjT/bn9Qwx+YZSQkM2IfzkwsVD22eqmyFXcfzQ5NwH9NLzKlZZLFrVtXdq/9CWDUx6cRy6fLcglmTMAQ6qvVgtXIB1115P1epU39LKPv9nLbgURdTn+YGaXmbxCdgaGfqNPEn7QyS4m/7IGQpCbgy+9to/V1Sx63Dvd/vBJHHfCXKuIBUivtcxER3Vm/P0KqRAab/YhnbLiCBpcFzIAxhm/trRqtpdbCJvA5tYIku06N2fKL7Cg/v0Qxa17+tvFsi7umP8tZc8c8zr2N5CqabO/Ad2M9EA7ejAT5lidsQ/P1yNWlvn/7B5tCoK7xeR7dU6hmg2y5GNJGH2zlC94GdMl80o845bqDo6ags4JN26UQo7SQzo3+w8bY92lO7/fqSDGkt9p3kS3KacXmTBYTygwDnkIfEK0ITG7IUWf9hww54r7JtVlWMYT3VX/CZzl2raz54a4bUEClHxK5FZHIKMy9gW3NWB7/ZZpkFjTSmNxm3vsgeLY4IUP98woErF15vEI1mbZ5t0D6Tb5CuEBHNDWTnuJ9onPzPP+V/PP+1VirZPO13y3bS3hBQuwuhVTvzkEvJTjdPM5HC+QhkUpcxpUYHXL2eRLwawBREV29ULf6VswjGUck4Q3DRsMtmNvPUUFMT2ycraSB4NW8JxqB6pLGcczlQX67v9X+8kLetVHhfTXpvqaOSbgxaGzph7HfMeRSsu2KLLxWlGjle96REP29y4DM22MRcA6w7jUFeF6CPWtw0LbAVFpicBTkCqO1B62jW8CP4GnPQSfghgtjoZEEUP5mlLd1XY2VU0N+MLrsmIPDUGUg7ppMCEzVviJkKURMyhVXsDu5qEOaYJeg1k7rxDUMvGb
 eHTOuJcV
 6tNmHGXcbG7oWP122Pa5NspifMVxZSTie5r7f+vlhlMlpRouTWvj/+194vtYDzvBn/7Kygt3+N618T+9Z0r1YWFwwaPN8MMj7KZnFyVBmEkb7Lz6mfy/SzLPgmZjYnSXaqXmEqoFuZM+/aUDz/0HL7VWum7mPKDEGS7toKzBEecAtcmS8fKEeDdcnz0ktnp6cMGMu8dciLuLd8vr7Rg1+Q0jNbdnCfw2xhOnhfjDoA+9wIteroxjjS22CzfDV1UmhiaJrOfRMl2TCyc7ubWrKu4FKDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A user worker is created with every signal other than SIGKILL and
SIGSTOP blocked. It never runs user code and that mask is what keeps
get_signal() from dequeuing anything else for it. complete_signal()
never picks a thread that blocks the signal, tkill() queues on the
worker but nothing dequeues it. ptrace_signal() requeues an injected
signal that the tracee blocks.

PTRACE_SETSIGMASK is the only way to change that mask from the outside.
A tracer that clears it makes the worker eligible for every signal.
Whatever the worker then dequeues it can only act on by leaving.

Refuse PTRACE_SETSIGMASK for a user worker with -EPERM, the way
ptrace_attach() refuses a kernel thread. A worker is guaranteed to only
ever dequeue SIGKILL or SIGSTOP and an injected signal stays pending on
it, which is what already happens when the mask isn't touched.

Taking the request and quietly leaving the mask alone was the other
option, the way set_current_blocked() keeps SIGKILL and SIGSTOP
unblocked whatever userspace asks for. But then a tracer gets success
back with nothing changed and no way to tell that apart from a mask that
took effect.

Fixes: e8b33b8cfafc ("Revert "kernel: treat PF_IO_WORKER like PF_KTHREAD for ptrace/signals"")
Cc: stable@vger.kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 kernel/ptrace.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index d041645d9d17..4e9822a87aab 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -1227,6 +1227,12 @@ int ptrace_request(struct task_struct *child, long request,
 	case PTRACE_SETSIGMASK: {
 		sigset_t new_set;
 
+		/* A user worker only ever takes SIGKILL and SIGSTOP. */
+		if (child->flags & PF_USER_WORKER) {
+			ret = -EPERM;
+			break;
+		}
+
 		if (addr != sizeof(sigset_t)) {
 			ret = -EINVAL;
 			break;

-- 
2.53.0


