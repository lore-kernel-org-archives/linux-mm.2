Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40D02C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:33:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41FC06B00B0; Tue, 15 Sep 2026 07:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6656B00B1; Tue, 15 Sep 2026 07:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C2B6B00B2; Tue, 15 Sep 2026 07:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD096B00B0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:33:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6537AA03B4
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:49 +0000 (UTC)
X-FDA: 85215786978.20.592BF35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6C6D414000C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:33:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nmpj4NaF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nmpj4NaF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472027;
	b=0/bRhniUP/5fiAgoVpSJNdUioewKmObcE40CfngGM+y/2ZSJxpVxAVWqbViWVvx+JtDtmR
	Aq8YXaX6xNBDpgHmsymoyWNaeWAmhyR7FeB4LgE5Xpau0iKGmy6JVn8eyiNysHedDR5PfA
	oKgvHUmIrEl8sYWYGOEnVaD5gxjCGXg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPUeEhZalZFbuqvBU8/iDG2tqjgIH/ueKLGrOGx0E/Q=;
	b=cjFRih1OIq8NrfRLT0S9QVwmGaCcl/UcEXkYaG1wkOc9+D4CiMGbDbVvJRvV+gcbvBTEvm
	i9F38SmHLsEljOt4BBBj5366JaBPXtD4G8z1C70g+J0s5sDzCvdJqtcZhQRR+BNiADNO7r
	+89DZ1MEjrAAGKyLctnnMgNdbN7PZRI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88ED742A92;
	Tue, 15 Sep 2026 11:33:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32EB01F00898;
	Tue, 15 Sep 2026 11:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472026;
	bh=fPUeEhZalZFbuqvBU8/iDG2tqjgIH/ueKLGrOGx0E/Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Nmpj4NaFXMtUCUBJkK324vi22fpzvX6uomFULBZJOjhgDQCroZWI/8lb8hRAJVCHh
	 9EhYq/igSRVSJd0Z69cCAreFakLrT8v7g5ED2rGJFufV7eihjNzGDapElAJqkyWjpl
	 lBXB4AtsKeIiuD1UD4coI3pcXNoLmTr78UlIqOkuglt9Hw0oChJkwnEGg4w0f6UJ0f
	 E3lrRN0G+U0+0MXEDUccPLURv/tGCWrEtzl5wBa6tk79GG6qHRxEjmf3jJK1LMmPo3
	 /VFHB2tZrT068p2qgHGbLHusKwE8Tye3wqbBTFb6QOLjp++ERuzcM9sRPxtZnWLn1E
	 KgqcMBfnsrMfA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:05 +0200
Subject: [PATCH RFC POC 19/50] file: require the syscall exit hook from
 every architecture
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-19-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=1044; i=brauner@kernel.org;
 h=from:subject:message-id; bh=kO5/kQT0XZnIdRnIvngddyYIzT4ZNU9mDakuELDqlrQ=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kmt7K/PWBxqv33Jx9xZ93feiJvYXvn0wyGRJfor4
 xvDgz5O7ChlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjImo8M/0t6Hp5cOHfxxr5q
 5ZTEWby+CmuzN2gtu/o25VNw3Kl5VQ8Z/ns2bzkbtn3/k1lfb3I0OE2bn/HePMr9P8+ZRZUPSuV
 nr+YCAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C6D414000C
X-Stat-Signature: bshsssjxytd61fycqu5n69i4h4qseu15
X-Rspamd-Server: rspam01
X-HE-Tag: 1789472027-465379
X-HE-Meta: U2FsdGVkX1/imkZiB+kjBESWOImczpIyRnxnjewWfBjFn0F68mZJ6ZkxifnhpoCH82ggtL19hPUiX0mYG6zQysNG10XlqN3hxv3c7n6Iv0UGsP+FHT0RUqMyiqetOwUe06giQjhry/gDUOy+O7G3Wgvqx5UtJV9I5zemZ4OVkd8eSgP9YQkJ65YTDHukvv5ITe3fYWz7hDcKZ7RuF+PyKG2RcIDerWUHfjFKJYfYmMKy+oIPD3HLwfJvTbdNN10qG0mDk81rqrdu8xHzbB/t1tkZ7tDAYlpDtlQ95uGDUBA4pEcmFNmRj03C/bvLexd9xCIJ0Z/TKYns4vFm7fkVP+Dmfn++qjeDjvWsIsM39kUOTfHe5EWG0c47G5wFAvt4LDnhh19vB92jj+OSVbK3zaYAKeAaYaggWXZpjmqQGOmoPO/qbzvMQ0E3Be5jYUH2bCuVmoh28k/OCGHdnpajDmdqAug56dK1W3N85EA7VjPluHhcSI4fCNr9idQ/7jAg6b8XFFTShxlU7RGIlJyAtR0RdCwqTro8cu2STHVMhxLBIUHs407PIRyvTaeTe2FqqcarjOL7j9ejP8LM+zRgg3rs1kRf3uzybcSFENwHX0eOwhPJrCjAlDhi94pcfzX0HW8rsG+G1cOx+5MdRMBAyayBDFf3Ayt+ferhtAGvvSbjribQsfLFg9oURb5mIHaOJi7aVrq5NqG9Vm3G5Y4puzC0kB+3mGfDP/p/deKLgzde8AYtAhFLb71J28s/Toqm/1ZakskUOxbpX/EehXLatOKv8KhW+EOknP+1oFRfXRTCns7Gr9pdbTzzxke75ku4hi94Bun6QCJSvGIbdw5P+fDzrowEZoIntiCQ0t0L+R/NAfdkwFdlsNnetNaXxOuvQXqU8+G2LTR2YEJO1MkL5h0C7xgE5d2pdPm6U78Sk+bT9M+hIfyI5rEQN3YQKZH8pddK6radqSW0g2cMG4n
 bk4F7dG1
 DtEW2IC0ZEPB5MQ4Em8a7eVEQujyBkAiUW1qQgqHV/WY7q5mF1GANvTYSEyXFMUg0PmhGXMyHxDe+rZERo+3oc3wjuQPy6AVCuaZ8wPfmBd7CbCoNO5VWBoIlXLE6vdr0AulSD6mQrwmtDpbIRuomzlF8ckCtjpoj2MJiFvqnYb8hmEjt/s4+jDQwO/qxmo0BKwM1bN+GS6cn9wGIRRQOQW8ozM/E7NqA0moWHyk6iC06jPsS6c9jt5xsBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Every architecture now either uses the generic entry code or provides
TIF_FD_SLOTS. The fallback that deferred without ever committing
can go. Make it a build error instead. A new architecture can't grow
fd_prepare() callers without the syscall exit hook.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 fs/file.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 6fa481d63dcf..2b041b45f225 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -652,9 +652,7 @@ static void fd_release(unsigned int fd)
 #define fd_slots_set_work()	set_thread_flag(TIF_FD_SLOTS)
 #define fd_slots_clear_work()	clear_thread_flag(TIF_FD_SLOTS)
 #else
-/* Nothing commits until the architecture provides the flag. */
-#define fd_slots_set_work()	do { } while (0)
-#define fd_slots_clear_work()	do { } while (0)
+#error "the syscall exit path must commit prepared file descriptors"
 #endif
 
 static struct fd_slot *fd_slot(struct fd_slots *slots, unsigned int idx)

-- 
2.53.0


