Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8075AC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C946B00D0; Tue, 15 Sep 2026 07:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92D046B00D1; Tue, 15 Sep 2026 07:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81E776B00D2; Tue, 15 Sep 2026 07:37:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 626A36B00D0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:37:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 005CC1601CE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:03 +0000 (UTC)
X-FDA: 85215795126.14.BBEBAC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 52EC21C0008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:02 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hJcbb+ve;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vNAyMtfXPrvlDMBwu/W4OdplmCeF+Bx8YXtsYm6LQAM=;
	b=Ws0XkRCur49mBhOar9VkBRE64W9RWpJm03Mo9bjc/tQk+yo2a7UBIMJZr2y3KQEX3yzpk+
	Q8/J0xSNiYQor1bsrzPkAV3DS8SIxhfQbuTM3+Abi2ICDoYbTRv53TTxojEbYpcYKtw5E0
	frWzGr5DN1uTAiUb1Iie5PMlRvmtJgU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hJcbb+ve;
	spf=pass (imf21.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472222;
	b=XoOcX5WiYIuiht51w15AACxCHbGCzUp1qOD6paNr5NoRSvYfK1Eo6QGRTclOAgAOcab/0f
	Ve2Rsa57WY8FhHaW7OuvU3P7laVIWhKzJxINIr3oIIc7wOSJqgol6/+sJUsoh8/GqdGO0G
	5w5MqpGGwFT0RE9DOxFN9CfcWcWwOCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE8EE600D1;
	Tue, 15 Sep 2026 11:37:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28C811F00893;
	Tue, 15 Sep 2026 11:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472221;
	bh=vNAyMtfXPrvlDMBwu/W4OdplmCeF+Bx8YXtsYm6LQAM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hJcbb+ve+d0nQ+lyOtzlz+UYbr/gC7seiGRVtM9hr3qhRy0SP4rtTxf+61fJV6HZZ
	 LW8RS1sK7opxRgNB4vdONobXBpXD+8GA3HqD2ByRAw16fqkTwu9j8tnAJddGmb7PLP
	 uAm06SirtIHb9CCSMDYGUJRVhcFsQ8v4/IdM2Y5J83ZMffAgWUfRu60wVT+I3rLxob
	 Mi3XVumaSCaqqvXwhpB/3c9gXctwqH2urcLOWEF/YPHWIZ1DoeXtnc71XLjr6mUjdh
	 GfPZGsugN7/T7eQDGipHgpsCZ2aT0QgMaxK1TaXJWBPrJ+seh1rFblIFb7+Y//Ecs/
	 SAX3DixdA32jQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:30 +0200
Subject: [PATCH RFC POC 44/50] drm/etnaviv: install the out-fence
 descriptor when the ioctl returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-44-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1875; i=brauner@kernel.org;
 h=from:subject:message-id; bh=WG8U461FL48WyesDf7+OQN8njA3nXiC/HvwYW8sZuPs=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Km/q3LcYfWGcx8fpJwoLZDaNd0oa+00ldguK1cb6
 asTWTUPdJSyMIhxMciKKbI4tJuEyy3nqdhslKkBM4eVCWQIAxenAEyEn5Hhf8CmHl/lhwWpt/aY
 /5Pr3xCoq1J+5FT33kNKDsks7ZtPZjMy7JT6oyr93P+B4L/VWRcU9j8zmrNg9ut3r3TNptlZWIi
 5MgAA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 52EC21C0008
X-Stat-Signature: 4aaxtmk1kfybx86f5yf81tc6n3nqg1bk
X-Rspam-User: 
X-HE-Tag: 1789472222-256830
X-HE-Meta: U2FsdGVkX19imY2E52qL5olZ35EwnzEHd/M6H3GkKsoI5giKrv/gCQdkepvieGh0Fmo7Vn5Ct5GiELCod6rfVHLYSiu1kbUF5altEFnj49ltKj3oBUT9F4ZROY/81tac8QNBEilJeJsMwI7yI+Ikt50FkRJa2nj+28FJQfYS6XnsDIoejoYIj6Oe1YIxtAz24W1azpSGIebwByZKTGhbtWDuiDEExyqAQX+YqNlYHzM82eKbH3+PINizbhNhvDMi3JD37wQ0t8f1jH6CaFK2SkCPADZdIp6XOjmHCGNEnt2n45DeqK9j/QR1i+xXlV1Hb4ypFfTKtqTP08Qeo9vgiuwKXbfP5UfDPzBhQSFn9TKxcdGRs+d0k4/5T+sN8te7Ap0G2pdYaJqxoKwO4F54OtsuYr+Yg4Njs6AVLrZ4eOVYR5OR1oFG7TDp+cl+8+cDZOa0W5IdRaiM8J9CjNubczChjI2a74GQiGl2pr3138TNZEicTmp7lUQqoVE2SFNGNhv/RDoAEv3KyLhAy3oBBcsGRlbUee++F3MPmSLxJ5A7dx5xtC5GgkaQ4e9MJgSZMUmFbDjiMrblMtFkq8GEbzUFY3YNeuTVgGFs/9cD8Qvg3Tm3OjyzpChhry3DkKZt8mUpc9lvIh031543BCwaC2HZYibRVw8aVCyVK9DDI05HKMYABwAeav+o8xfCdPf6nt8obRXCJ5OCF4wD7GsKjEp3WIlCbbMdjunAjpj1lyy6x22+wMVK3HChEc2bMbVc52IOMMT96bhtycHETYHGk4imDKzA3CcYo5eX4wbVUPedUQMivmLvBXyNLwqvwC5wft13KA7SeMXpygjwJIBYwjtzSRFgolvoZBgj9gHCQfDwvha3L/cBBI8Ttmm+40f9t98pHdeIOROydW0yKJexsp2rq9HYeAHrGrozd3znPSybglyzoNVeG+xasnqbc9UDLNcuF6YMs0F43vwMOTY
 91LDjEcC
 PXdIg5IYffwAocQk8+Xpf2NA/dcHo8O+Rfztyr47YlnPkt3cPFoc/+Tb65cLyFcRKNtF9nKKvD7J+YkHoKeE9XZKAE/lHEGrDVnkoCqhPO/3Rmww1m+MVFHgNnnANg3URgVLr9RltzsCLtKXxehv0wgOOgQFQvmUwVvQvb8pzXuZuj/MUz/TPYgDHnNpC+bIiZ4InnN5ZwqBX8fiz28S6+e/89dCbfeUK4qF3BNGaqCmefNsF0ka/PVimRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c b/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
index 1a77a09b3377..174f1d66d9ad 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gem_submit.c
@@ -420,7 +420,7 @@ int etnaviv_ioctl_gem_submit(struct drm_device *dev, void *data,
 	struct etnaviv_gpu *gpu;
 	struct sync_file *sync_file = NULL;
 	struct ww_acquire_ctx ticket;
-	int out_fence_fd = -1;
+	const struct fd_slot *out_fence_fd = NULL;
 	struct pid *pid = get_pid(task_pid(current));
 	void *stream;
 	int ret;
@@ -504,9 +504,9 @@ int etnaviv_ioctl_gem_submit(struct drm_device *dev, void *data,
 	}
 
 	if (args->flags & ETNA_SUBMIT_FENCE_FD_OUT) {
-		out_fence_fd = get_unused_fd_flags(O_CLOEXEC);
-		if (out_fence_fd < 0) {
-			ret = out_fence_fd;
+		out_fence_fd = fd_prepare(O_CLOEXEC);
+		if (IS_ERR(out_fence_fd)) {
+			ret = PTR_ERR(out_fence_fd);
 			goto err_submit_cmds;
 		}
 	}
@@ -607,10 +607,10 @@ int etnaviv_ioctl_gem_submit(struct drm_device *dev, void *data,
 			 */
 			goto err_submit_put;
 		}
-		fd_install(out_fence_fd, sync_file->file);
+		fd_stage(out_fence_fd, sync_file->file);
 	}
 
-	args->fence_fd = out_fence_fd;
+	args->fence_fd = out_fence_fd ? fd_prepare_fd(out_fence_fd) : -1;
 	args->fence = submit->out_fence_id;
 
 err_submit_job:
@@ -623,8 +623,6 @@ int etnaviv_ioctl_gem_submit(struct drm_device *dev, void *data,
 	ww_acquire_fini(&ticket);
 
 err_submit_cmds:
-	if (ret && (out_fence_fd >= 0))
-		put_unused_fd(out_fence_fd);
 	kvfree(stream);
 	kvfree(bos);
 	kvfree(relocs);

-- 
2.53.0


