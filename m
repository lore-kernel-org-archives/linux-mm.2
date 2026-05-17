Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69628CD4F47
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 18:37:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 799B36B0093; Sun, 17 May 2026 14:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D5236B0095; Sun, 17 May 2026 14:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C39E6B0096; Sun, 17 May 2026 14:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 43A686B0093
	for <linux-mm@kvack.org>; Sun, 17 May 2026 14:37:12 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0C8A0C2150
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:12 +0000 (UTC)
X-FDA: 84777769104.07.ED1847E
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 18ED180009
	for <linux-mm@kvack.org>; Sun, 17 May 2026 18:37:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=jwdfCr1n;
	spf=pass (imf02.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779043030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yuo9ZBEeU6JatQxAD5qGTp8gG9D/rBQJB1zd4jdqZnQ=;
	b=hZamCSiy/hrt7fFCZwvSzkMPDYz6wnAp3/umzRpqfI6U6mXWrh5xgvHDdfjNio3nDe7B28
	lf9hZgqUnPOv7Hg3hx37wIjOyzSYmslfb90fc+zKAjDzdIUGDbxDvQaVYmYi0kVau8j0+H
	PSNUQ0vn7IRi8Voq2UEM+Wvt0c2b+aI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=jwdfCr1n;
	spf=pass (imf02.hostedemail.com: domain of andrealmeid@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=andrealmeid@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779043030; a=rsa-sha256;
	cv=none;
	b=tAXhalV9U3/N0lJv+aVR/+T2xaUpCycuBpu9eBsfHJeUWQBot/HT79LyH2esLUhnaBEVZW
	SXyWgSNzYrZCD3CIlbGRI4d1GTIgMxYwIdOb68/CGGvNnUu7V3yoNvoBPSvE9StTuMwFkS
	Kz1qpSimEolB3vluw1d2pPnrFrrbXXI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Cc:To:In-Reply-To:References:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:Sender:
	Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender
	:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yuo9ZBEeU6JatQxAD5qGTp8gG9D/rBQJB1zd4jdqZnQ=; b=jwdfCr1naca0+SgNY7Fg6nzwJ/
	ZRQJSEbbDbbmNMAKTqPq2VKnwKg9paRsZzpLquf1QLKtwWShG6RJO6qP7W5lr9Rp52XYu47Sb39pD
	2m7SXOyCQMJEFEmBwjLtBsxDDoy6yp7WCVAkKukBd6aVzSFCT0aDSeaazYvvQIVq2kfYdBtFcSfg0
	jL0keziT5QhEHoMbhUlneScxpXeG0XcN8hSRgVf6SYzYd+a8hT75igcTBIbM1hR7/c6Pyv+IRuIaZ
	oacU0fbvlhWyqitJrt54+7WiP/yJKLPW2EsQMBXGCVXkHVR64uZm0A43uWmke5alhSHoTYtZUbhgH
	rZBeSYCw==;
Received: from [179.193.2.40] (helo=[192.168.15.100])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1wOgME-001cLz-8l; Sun, 17 May 2026 20:36:58 +0200
From: =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
Date: Sun, 17 May 2026 15:36:12 -0300
Subject: [PATCH 2/6] treewide: Get rid of get_task_comm()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260517-tonyk-long_name-v1-2-3c282eaa91e2@igalia.com>
References: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
In-Reply-To: <20260517-tonyk-long_name-v1-0-3c282eaa91e2@igalia.com>
To: Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Christian Brauner <brauner@kernel.org>, Kees Cook <kees@kernel.org>, 
 Shuah Khan <shuah@kernel.org>, willy@infradead.org, 
 mathieu.desnoyers@efficios.com, David Laight <david.laight.linux@gmail.com>, 
 Linus Torvalds <torvalds@linux-foundation.org>, akpm@linux-foundation.org, 
 Yafang Shao <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, 
 arnaldo.melo@gmail.com, Petr Mladek <pmladek@suse.com>
Cc: linux-kernel@vger.kernel.org, kernel-dev@igalia.com, linux-mm@kvack.org, 
 linux-api@vger.kernel.org, Bhupesh <bhupesh@igalia.com>, 
 =?utf-8?q?Andr=C3=A9_Almeida?= <andrealmeid@igalia.com>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 18ED180009
X-Stat-Signature: c9rdfn5kgmq3dbcysqwrejurgykfc6mo
X-HE-Tag: 1779043029-588978
X-HE-Meta: U2FsdGVkX1/ul8WkRCSSxlQA9d2BFIEnM//9vYokrilN72bzRsytzTEerFNhXgyZLOuijRWpeKp/1XQuRr+4ngF0+/5k5m7SH6bD745Vc63cqf6bmbl6qb+Vhds0KDumpMJWEzdAGUb3UN19ipc7YU/CST0W7s3/H9WJOtgXmk8o7yasANq/QmNquiNDnYqutod5rxPgWg6cxYLzO+IlVecTyBcsjGcXQQodQeIfw16BsTAGCts8m0ZYJACPIJzwu2wKVnazma8uYCCnIB3tPsfxe4R3yJgWT3EgN4JOYtrJzy8+J/jsp2OAdp7/txO6A7toNCPFOE06+SfuOuy9sVIsWhXXsKFlSg54QfyFrAoicNApI6VZUma3yg/9Zwnq6FpSQPJYGBqECcwp/fF4rS6pK92uD0yqaF10mf7978beGbSDfBl68RGtYRspO/fplpKOgQwiA1RxX80WmogI5k1PMUL3Cpxxpyv8fCcuhgXxtv4J/a0PEwZhrSvSaEk899QR4dZE1egYcI4PHSjKhwwzkYlNKmspwPee3blJxSUpol8VlWoHwVxzRXPAYeKozqdA6oBktqnXtQdKDhMnp2DBjUa1wrOw0VQT1pTd4bvpYz92td4toiKDR9aBvrKooQZvv/YScuz7/HzDtozrZq4YCYyJfRZU2jB9HC2Dgkf1ac5/R9oT4Mo8ArZBp9V07h4WE1o99p4xxg5X4gBitO/1yJuz0Dj6g3MK/jG7mgsdn70b3UeGrR1wAo8+CA4wvrN4Zx0FsfIyvk+8QcMtQZYz38BWGGVzCuHGN89CwR9azBThzgdfkGJWBchyJywFbO4fOBpIlc40j20p+9rSZUaHhIDyPAcu5ab+bOH9ZhJhHnV70wishc6flpV+lbD363rsCM+PZr0zQs0xZ18szo0E9vUVwofQvzDSPuxzQ/EkevuKnz7CLJ8zLcsMLusJF30XtJDALViS5x0QSO0
 2t5MyevA
 dF+WYChHFX06FL105LiN+OdT3JyWXgEWn7maSRKZoxGLJ7nnE7m89ZRjGZdIchSX6HZTUy3AsWox0tuWTmJ5lNPoBGeTI4ShvF8ZmK6n9xVY9wMLUq+H9JaIkeBbO/lxQP0DGIYRAPvRJGp8zImQnSDS7XnfJWW5KZ+/THjcEYlT0u961N/kjf7SGQzW8dtFvpUeMBqLfiYSyJ+9u4lwmzq8IRQ6SMSj8As8QEpvwoBPV+mbkFpKaButnQHlOfwSm8VCsKSKVZUup6fWKW9SVuSeq5lnhcjh1PilxAc+wwNHucvMSw+TSDvcJuasTP3eNno6FJoYjFhTW/G/kDBi+bT7LPDPAqYi1aAfKavuj5Ly1XYTDswv3serwdu4aqklAooqsTOxk0GobGiThuCoxXMjfR9YRAZVoKpo7UzHVnHSNsm6wp6/MUAyD0ddaNqStV3E7dRu1tDfEsd/kmy1SaJpx7rsnsrLTVfL1G1hZiL8fKBK2u5+zT/ZqHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 4cc0473d7754 ("get rid of __get_task_comm()"),
get_task_comm() does just a redundant check for the buffer size and call
strscpy_pad(). Replace get_task_comm() calls with strscpy_pad(), that will
do the right thing if the buffers sizes doesn't match: zero-pad if it's
bigger, and truncate if it's smaller.

Link: https://lore.kernel.org/lkml/CAHk-=wi5c=_-FBGo_88CowJd_F-Gi6Ud9d=TALm65ReN7YjrMw@mail.gmail.com/
Co-developed-by: Bhupesh <bhupesh@igalia.com>
Signed-off-by: Bhupesh <bhupesh@igalia.com>
Signed-off-by: André Almeida <andrealmeid@igalia.com>
---
 drivers/connector/cn_proc.c                        |  2 +-
 drivers/dma-buf/sw_sync.c                          |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c   |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c            |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c    |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  4 ++--
 drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c       |  2 +-
 drivers/gpu/drm/lima/lima_ctx.c                    |  2 +-
 drivers/gpu/drm/panfrost/panfrost_gem.c            |  2 +-
 drivers/gpu/drm/panthor/panthor_gem.c              |  2 +-
 drivers/gpu/drm/panthor/panthor_sched.c            |  2 +-
 drivers/gpu/drm/virtio/virtgpu_ioctl.c             |  2 +-
 drivers/hwtracing/stm/core.c                       |  2 +-
 drivers/tty/tty_audit.c                            |  2 +-
 fs/binfmt_elf.c                                    |  2 +-
 fs/binfmt_elf_fdpic.c                              |  2 +-
 fs/proc/array.c                                    |  2 +-
 include/linux/sched.h                              | 19 -------------------
 kernel/audit.c                                     |  6 ++++--
 kernel/auditsc.c                                   |  6 ++++--
 kernel/printk/printk.c                             |  2 +-
 kernel/sys.c                                       |  2 +-
 net/bluetooth/hci_sock.c                           |  2 +-
 net/netfilter/nf_tables_api.c                      |  2 +-
 security/integrity/integrity_audit.c               |  3 ++-
 security/ipe/audit.c                               |  2 +-
 security/landlock/domain.c                         |  2 +-
 security/lsm_audit.c                               |  7 ++++---
 29 files changed, 39 insertions(+), 52 deletions(-)

diff --git a/drivers/connector/cn_proc.c b/drivers/connector/cn_proc.c
index 0056ab81fbc3..c78243ed3c2a 100644
--- a/drivers/connector/cn_proc.c
+++ b/drivers/connector/cn_proc.c
@@ -278,7 +278,7 @@ void proc_comm_connector(struct task_struct *task)
 	ev->what = PROC_EVENT_COMM;
 	ev->event_data.comm.process_pid  = task->pid;
 	ev->event_data.comm.process_tgid = task->tgid;
-	get_task_comm(ev->event_data.comm.comm, task);
+	strscpy_pad(ev->event_data.comm.comm, task->comm);
 
 	memcpy(&msg->id, &cn_proc_event_id, sizeof(msg->id));
 	msg->ack = 0; /* not used */
diff --git a/drivers/dma-buf/sw_sync.c b/drivers/dma-buf/sw_sync.c
index 8df20b0218a9..d501657ad801 100644
--- a/drivers/dma-buf/sw_sync.c
+++ b/drivers/dma-buf/sw_sync.c
@@ -312,7 +312,7 @@ static int sw_sync_debugfs_open(struct inode *inode, struct file *file)
 	struct sync_timeline *obj;
 	char task_comm[TASK_COMM_LEN];
 
-	get_task_comm(task_comm, current);
+	strscpy_pad(task_comm, current->comm);
 
 	obj = sync_timeline_create(task_comm);
 	if (!obj)
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c
index 6a364357522b..13c8857e4ffb 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_fence.c
@@ -74,7 +74,7 @@ struct amdgpu_amdkfd_fence *amdgpu_amdkfd_fence_create(u64 context,
 	/* This reference gets released in amdkfd_fence_release */
 	mmgrab(mm);
 	fence->mm = mm;
-	get_task_comm(fence->timeline_name, current);
+	strscpy_pad(fence->timeline_name, current->comm);
 	spin_lock_init(&fence->lock);
 	fence->svm_bo = svm_bo;
 	fence->context_id = context_id;
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c
index 4c5e38dea4c2..faf0f36d8328 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_eviction_fence.c
@@ -129,7 +129,7 @@ int amdgpu_evf_mgr_rearm(struct amdgpu_eviction_fence_mgr *evf_mgr,
 		return -ENOMEM;
 
 	ev_fence->evf_mgr = evf_mgr;
-	get_task_comm(ev_fence->timeline_name, current);
+	strscpy_pad(ev_fence->timeline_name, current->comm);
 	spin_lock_init(&ev_fence->lock);
 	dma_fence_init64(&ev_fence->base, &amdgpu_eviction_fence_ops,
 			 &ev_fence->lock, evf_mgr->ev_fence_ctx,
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
index 6c644cfe6695..c45630457155 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras.c
@@ -4419,7 +4419,7 @@ int amdgpu_ras_init(struct amdgpu_device *adev)
 	}
 
 	con->init_task_pid = task_pid_nr(current);
-	get_task_comm(con->init_task_comm, current);
+	strscpy_pad(con->init_task_comm, current->comm);
 
 	mutex_init(&con->critical_region_lock);
 	INIT_LIST_HEAD(&con->critical_region_head);
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
index e2d5f04296e1..8fdc38d8d64d 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_userq_fence.c
@@ -85,7 +85,7 @@ int amdgpu_userq_fence_driver_alloc(struct amdgpu_device *adev,
 
 	fence_drv->adev = adev;
 	fence_drv->context = dma_fence_context_alloc(1);
-	get_task_comm(fence_drv->timeline_name, current);
+	strscpy_pad(fence_drv->timeline_name, current->comm);
 
 	*fence_drv_req = fence_drv;
 
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
index 9ba9de16a27a..de80d0ace905 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c
@@ -2571,10 +2571,10 @@ void amdgpu_vm_set_task_info(struct amdgpu_vm *vm)
 		return;
 
 	vm->task_info->task.pid = current->pid;
-	get_task_comm(vm->task_info->task.comm, current);
+	strscpy_pad(vm->task_info->task.comm, current->comm);
 
 	vm->task_info->tgid = current->tgid;
-	get_task_comm(vm->task_info->process_name, current->group_leader);
+	strscpy_pad(vm->task_info->process_name, current->group_leader->comm);
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
index 2a241a5b12c4..f8ce59d8587a 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vram_mgr.c
@@ -563,7 +563,7 @@ static int amdgpu_vram_mgr_new(struct ttm_resource_manager *man,
 	}
 
 	vres->task.pid = task_pid_nr(current);
-	get_task_comm(vres->task.comm, current);
+	strscpy_pad(vres->task.comm, current->comm);
 	list_add_tail(&vres->vres_node, &mgr->allocated_vres_list);
 
 	if (bo->flags & AMDGPU_GEM_CREATE_VRAM_CONTIGUOUS && adjust_dcc_size) {
diff --git a/drivers/gpu/drm/lima/lima_ctx.c b/drivers/gpu/drm/lima/lima_ctx.c
index 68ede7a725e2..e8c5c3601bf1 100644
--- a/drivers/gpu/drm/lima/lima_ctx.c
+++ b/drivers/gpu/drm/lima/lima_ctx.c
@@ -29,7 +29,7 @@ int lima_ctx_create(struct lima_device *dev, struct lima_ctx_mgr *mgr, u32 *id)
 		goto err_out0;
 
 	ctx->pid = task_pid_nr(current);
-	get_task_comm(ctx->pname, current);
+	strscpy_pad(ctx->pname, current->comm);
 
 	return 0;
 
diff --git a/drivers/gpu/drm/panfrost/panfrost_gem.c b/drivers/gpu/drm/panfrost/panfrost_gem.c
index 3a7fce428898..11936c4d3573 100644
--- a/drivers/gpu/drm/panfrost/panfrost_gem.c
+++ b/drivers/gpu/drm/panfrost/panfrost_gem.c
@@ -36,7 +36,7 @@ static void panfrost_gem_debugfs_bo_add(struct panfrost_device *pfdev,
 					struct panfrost_gem_object *bo)
 {
 	bo->debugfs.creator.tgid = current->tgid;
-	get_task_comm(bo->debugfs.creator.process_name, current->group_leader);
+	strscpy_pad(bo->debugfs.creator.process_name, current->group_leader->comm);
 
 	mutex_lock(&pfdev->debugfs.gems_lock);
 	list_add_tail(&bo->debugfs.node, &pfdev->debugfs.gems_list);
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index cd49859da89b..b44fd715c17e 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -46,7 +46,7 @@ static void panthor_gem_debugfs_bo_add(struct panthor_gem_object *bo)
 						    struct panthor_device, base);
 
 	bo->debugfs.creator.tgid = current->tgid;
-	get_task_comm(bo->debugfs.creator.process_name, current->group_leader);
+	strscpy_pad(bo->debugfs.creator.process_name, current->group_leader->comm);
 
 	mutex_lock(&ptdev->gems.lock);
 	list_add_tail(&bo->debugfs.node, &ptdev->gems.node);
diff --git a/drivers/gpu/drm/panthor/panthor_sched.c b/drivers/gpu/drm/panthor/panthor_sched.c
index 2fe04d0f0e3a..8ee9de96acf6 100644
--- a/drivers/gpu/drm/panthor/panthor_sched.c
+++ b/drivers/gpu/drm/panthor/panthor_sched.c
@@ -3603,7 +3603,7 @@ static void group_init_task_info(struct panthor_group *group)
 	struct task_struct *task = current->group_leader;
 
 	group->task_info.pid = task->pid;
-	get_task_comm(group->task_info.comm, task);
+	strscpy_pad(group->task_info.comm, task->comm);
 }
 
 static void add_group_kbo_sizes(struct panthor_device *ptdev,
diff --git a/drivers/gpu/drm/virtio/virtgpu_ioctl.c b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
index c33c057365f8..d2bf221e8f01 100644
--- a/drivers/gpu/drm/virtio/virtgpu_ioctl.c
+++ b/drivers/gpu/drm/virtio/virtgpu_ioctl.c
@@ -50,7 +50,7 @@ static void virtio_gpu_create_context_locked(struct virtio_gpu_device *vgdev,
 	} else {
 		char dbgname[TASK_COMM_LEN];
 
-		get_task_comm(dbgname, current);
+		strscpy_pad(dbgname, current->comm);
 		virtio_gpu_cmd_context_create(vgdev, vfpriv->ctx_id,
 					      vfpriv->context_init, strlen(dbgname),
 					      dbgname);
diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index f48c6a8a0654..c7715439964e 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -634,7 +634,7 @@ static ssize_t stm_char_write(struct file *file, const char __user *buf,
 		char comm[sizeof(current->comm)];
 		char *ids[] = { comm, "default", NULL };
 
-		get_task_comm(comm, current);
+		strscpy_pad(comm, current->comm);
 
 		err = stm_assign_first_policy(stmf->stm, &stmf->output, ids, 1);
 		/*
diff --git a/drivers/tty/tty_audit.c b/drivers/tty/tty_audit.c
index d014af6ab060..d514a81d0a5c 100644
--- a/drivers/tty/tty_audit.c
+++ b/drivers/tty/tty_audit.c
@@ -77,7 +77,7 @@ static void tty_audit_log(const char *description, dev_t dev,
 	audit_log_format(ab, "%s pid=%u uid=%u auid=%u ses=%u major=%d minor=%d comm=",
 			 description, pid, uid, loginuid, sessionid,
 			 MAJOR(dev), MINOR(dev));
-	get_task_comm(name, current);
+	strscpy_pad(name, current->comm);
 	audit_log_untrustedstring(ab, name);
 	audit_log_format(ab, " data=");
 	audit_log_n_hex(ab, data, size);
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 16a56b6b3f6c..d25922460b63 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1557,7 +1557,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
 	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
-	get_task_comm(psinfo->pr_fname, p);
+	strscpy_pad(psinfo->pr_fname, p->comm);
 
 	return 0;
 }
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 7e3108489c83..c4d4e59ff34d 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1371,7 +1371,7 @@ static int fill_psinfo(struct elf_prpsinfo *psinfo, struct task_struct *p,
 	SET_UID(psinfo->pr_uid, from_kuid_munged(cred->user_ns, cred->uid));
 	SET_GID(psinfo->pr_gid, from_kgid_munged(cred->user_ns, cred->gid));
 	rcu_read_unlock();
-	get_task_comm(psinfo->pr_fname, p);
+	strscpy_pad(psinfo->pr_fname, p->comm);
 
 	return 0;
 }
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 90fb0c6b5f99..c8c3fbd9bfa9 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -110,7 +110,7 @@ void proc_task_name(struct seq_file *m, struct task_struct *p, bool escape)
 	else if (p->flags & PF_KTHREAD)
 		get_kthread_comm(tcomm, sizeof(tcomm), p);
 	else
-		get_task_comm(tcomm, p);
+		strscpy_pad(tcomm, p->comm);
 
 	if (escape)
 		seq_escape_str(m, tcomm, ESCAPE_SPACE | ESCAPE_SPECIAL, "\n\\");
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 60d004a49a27..b6de742b1155 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2000,25 +2000,6 @@ extern void __set_task_comm(struct task_struct *tsk, const char *from, bool exec
 	__set_task_comm(tsk, from, false);		\
 })
 
-/*
- * - Why not use task_lock()?
- *   User space can randomly change their names anyway, so locking for readers
- *   doesn't make sense. For writers, locking is probably necessary, as a race
- *   condition could lead to long-term mixed results.
- *   The logic inside __set_task_comm() ensures that the task comm is
- *   always NUL-terminated and zero-padded. Therefore the race condition between
- *   reader and writer is not an issue.
- *
- * - BUILD_BUG_ON() can help prevent the buf from being truncated.
- *   Since the callers don't perform any return value checks, this safeguard is
- *   necessary.
- */
-#define get_task_comm(buf, tsk) ({			\
-	BUILD_BUG_ON(sizeof(buf) < TASK_COMM_LEN);	\
-	strscpy_pad(buf, (tsk)->comm);			\
-	buf;						\
-})
-
 static __always_inline void scheduler_ipi(void)
 {
 	/*
diff --git a/kernel/audit.c b/kernel/audit.c
index e1d489bc2dff..6fc867adbf3d 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -1662,7 +1662,8 @@ static void audit_log_multicast(int group, const char *op, int err)
 	audit_put_tty(tty);
 	audit_log_task_context(ab); /* subj= */
 	audit_log_format(ab, " comm=");
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	strscpy_pad(comm, current->comm);
+	audit_log_untrustedstring(ab, comm);
 	audit_log_d_path_exe(ab, current->mm); /* exe= */
 	audit_log_format(ab, " nl-mcgrp=%d op=%s res=%d", group, op, !err);
 	audit_log_end(ab);
@@ -2465,7 +2466,8 @@ void audit_log_task_info(struct audit_buffer *ab)
 			 audit_get_sessionid(current));
 	audit_put_tty(tty);
 	audit_log_format(ab, " comm=");
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	strscpy_pad(comm, current->comm);
+	audit_log_untrustedstring(ab, comm);
 	audit_log_d_path_exe(ab, current->mm);
 	audit_log_task_context(ab);
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index ab54fccba215..8e4f70105a13 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2877,7 +2877,8 @@ void __audit_log_nfcfg(const char *name, u8 af, unsigned int nentries,
 	audit_log_format(ab, " pid=%u", task_tgid_nr(current));
 	audit_log_task_context(ab); /* subj= */
 	audit_log_format(ab, " comm=");
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	strscpy_pad(comm, current->comm);
+	audit_log_untrustedstring(ab, comm);
 	audit_log_end(ab);
 }
 EXPORT_SYMBOL_GPL(__audit_log_nfcfg);
@@ -2900,7 +2901,8 @@ static void audit_log_task(struct audit_buffer *ab)
 			 sessionid);
 	audit_log_task_context(ab);
 	audit_log_format(ab, " pid=%d comm=", task_tgid_nr(current));
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	strscpy_pad(comm, current->comm);
+	audit_log_untrustedstring(ab, comm);
 	audit_log_d_path_exe(ab, current->mm);
 }
 
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 0323149548f6..1f04e753ca02 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -2247,7 +2247,7 @@ static u16 printk_sprint(char *text, u16 size, int facility,
 static void printk_store_execution_ctx(struct printk_info *info)
 {
 	info->caller_id2 = printk_caller_id2();
-	get_task_comm(info->comm, current);
+	strscpy_pad(info->comm, current->comm);
 }
 
 static void pmsg_load_execution_ctx(struct printk_message *pmsg,
diff --git a/kernel/sys.c b/kernel/sys.c
index 62e842055cc9..1d5152d2395e 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2609,7 +2609,7 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 		proc_comm_connector(me);
 		break;
 	case PR_GET_NAME:
-		get_task_comm(comm, me);
+		strscpy_pad(comm, me->comm);
 		if (copy_to_user((char __user *)arg2, comm, sizeof(comm)))
 			return -EFAULT;
 		break;
diff --git a/net/bluetooth/hci_sock.c b/net/bluetooth/hci_sock.c
index 0290dea081f6..38e16ba2de38 100644
--- a/net/bluetooth/hci_sock.c
+++ b/net/bluetooth/hci_sock.c
@@ -106,7 +106,7 @@ static bool hci_sock_gen_cookie(struct sock *sk)
 			id = 0xffffffff;
 
 		hci_pi(sk)->cookie = id;
-		get_task_comm(hci_pi(sk)->comm, current);
+		strscpy_pad(hci_pi(sk)->comm, current->comm);
 		return true;
 	}
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 87387adbca65..d859ffa2874c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9711,7 +9711,7 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 
 	if (nla_put_be32(skb, NFTA_GEN_ID, htonl(nft_base_seq(net))) ||
 	    nla_put_be32(skb, NFTA_GEN_PROC_PID, htonl(task_pid_nr(current))) ||
-	    nla_put_string(skb, NFTA_GEN_PROC_NAME, get_task_comm(buf, current)))
+	    nla_put_string(skb, NFTA_GEN_PROC_NAME, strscpy_pad(buf, current->comm)))
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
diff --git a/security/integrity/integrity_audit.c b/security/integrity/integrity_audit.c
index d8d9e5ff1cd2..98060060929d 100644
--- a/security/integrity/integrity_audit.c
+++ b/security/integrity/integrity_audit.c
@@ -54,7 +54,8 @@ void integrity_audit_message(int audit_msgno, struct inode *inode,
 			 audit_get_sessionid(current));
 	audit_log_task_context(ab);
 	audit_log_format(ab, " op=%s cause=%s comm=", op, cause);
-	audit_log_untrustedstring(ab, get_task_comm(name, current));
+	strscpy_pad(name, current->comm);
+	audit_log_untrustedstring(ab, name);
 	if (fname) {
 		audit_log_format(ab, " name=");
 		audit_log_untrustedstring(ab, fname);
diff --git a/security/ipe/audit.c b/security/ipe/audit.c
index 93fb59fbddd6..c04901baed73 100644
--- a/security/ipe/audit.c
+++ b/security/ipe/audit.c
@@ -145,7 +145,7 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
 	audit_log_format(ab, "ipe_op=%s ipe_hook=%s enforcing=%d pid=%d comm=",
 			 op, audit_hook_names[ctx->hook], READ_ONCE(enforce),
 			 task_tgid_nr(current));
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	audit_log_untrustedstring(ab, strscpy_pad(comm, current->comm));
 
 	if (ctx->file) {
 		audit_log_d_path(ab, " path=", &ctx->file->f_path);
diff --git a/security/landlock/domain.c b/security/landlock/domain.c
index 06b6bd845060..a35a27f523e6 100644
--- a/security/landlock/domain.c
+++ b/security/landlock/domain.c
@@ -101,7 +101,7 @@ static struct landlock_details *get_current_details(void)
 	memcpy(details->exe_path, path_str, path_size);
 	details->pid = get_pid(task_tgid(current));
 	details->uid = from_kuid(&init_user_ns, current_uid());
-	get_task_comm(details->comm, current);
+	strscpy_pad(details->comm, current->comm);
 	return details;
 }
 
diff --git a/security/lsm_audit.c b/security/lsm_audit.c
index 737f5a263a8f..a587ffecd985 100644
--- a/security/lsm_audit.c
+++ b/security/lsm_audit.c
@@ -276,8 +276,8 @@ void audit_log_lsm_data(struct audit_buffer *ab,
 			if (pid) {
 				char tskcomm[sizeof(tsk->comm)];
 				audit_log_format(ab, " opid=%d ocomm=", pid);
-				audit_log_untrustedstring(ab,
-				    get_task_comm(tskcomm, tsk));
+				strscpy_pad(tskcomm, tsk->comm);
+				audit_log_untrustedstring(ab, tskcomm);
 			}
 		}
 		break;
@@ -417,7 +417,8 @@ static void dump_common_audit_data(struct audit_buffer *ab,
 	char comm[sizeof(current->comm)];
 
 	audit_log_format(ab, " pid=%d comm=", task_tgid_nr(current));
-	audit_log_untrustedstring(ab, get_task_comm(comm, current));
+	strscpy_pad(comm, current->comm);
+	audit_log_untrustedstring(ab, comm);
 	audit_log_lsm_data(ab, a);
 }
 

-- 
2.54.0


