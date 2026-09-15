Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2558C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA0F66B00CE; Tue, 15 Sep 2026 07:36:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B78D56B00CF; Tue, 15 Sep 2026 07:36:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB5486B00D0; Tue, 15 Sep 2026 07:36:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9162A6B00CE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:36:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1346D1A03AE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:56 +0000 (UTC)
X-FDA: 85215794832.18.E9B69D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6687A10000B
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:54 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXI8vF2M;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6e1PB4CQNzedeHCycAL44Td/hQEl2CX/iFm1Iur71xE=;
	b=yjuoaoPIwhKMKupiVHr60wtb8NtmVatNeGv/iSJ4IgawIMtU8XxNNiMd6AqyTAG2hCxqyq
	96Le74N/Ba72r5ovGUjsR6L/QIQN9DMuUFyS4eF4jeu7e+SIayE31jisjiDM0oIOOlBqUt
	7dQn3TGb8myBsHXvBeJqEAK1GXlrR0E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472214;
	b=crH2wgtLh6h1/mo6r6eI0oF5+dXsEa9bOKZiq4NTpFqmDunKeLwXDLs9i7fJVXhVyOh0wP
	SgvkXyKnB3AXup05ZEjowHXDBuTC5ZnH1jEWovHRo/SagE94F4txaOVsqcGKWAx8eYYGby
	T2qUWf+/BEfd1bmyCVTQ3rmiZb6XQoo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EXI8vF2M;
	spf=pass (imf05.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F3098602C4;
	Tue, 15 Sep 2026 11:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730581F000FF;
	Tue, 15 Sep 2026 11:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472213;
	bh=6e1PB4CQNzedeHCycAL44Td/hQEl2CX/iFm1Iur71xE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=EXI8vF2Mi2qQql8uoPNVMR9Vjgp88ee0ybxkHsj+i1EcfZwKRf7jQAqrx5XocwZ5u
	 bXuB/2sL89kC6PNZZE/dhnoh6Kr65fNehf5/WE+WzUeV5/pclzQoq/bonRzBcg9E7+
	 NfoFoguGthxJQGC332DYQsb5ljWYLD+kEUw/Pee+5M/7Dg2ZiE3sQd1cKKv890ucDD
	 /r0vRvig6oqwgwA6dJ/z5P48MPdRVZFrQKEwVGkp3Sgwz1v5wVDwGFDqx3GUFssAgt
	 DN89k/PZlDz7rh5/WFfNs5IypEAhalKV3Vwaa2jbU2stx2+1M+fSysP8b+juFLIlZq
	 jL2puXhM2BB9Q==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:29 +0200
Subject: [PATCH RFC POC 43/50] drm/amdgpu: stop unwinding the fence
 descriptor by hand
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-43-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1456; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ufNESbgGG96SdhrvZQNvdMYhyiyG0BhLW+Tl/xqdcT0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kk/up3zrbpgwjWhoti6iGnTuBPttKJTrrTH/TR99
 na/1fRNHaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABMRM2D4n28sFLhN/8+GKPvC
 voCqx/oLuw/JH2VIEPq49KPjCV75pwz/41f1ZW/e/L95zZs5+aVvD0z0YZjxyGRy0d0flus809L
 W8wMA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Stat-Signature: 7jqax3ch4ck41w5stra98txnm9pzz5qh
X-Rspam-User: 
X-Rspamd-Queue-Id: 6687A10000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1789472214-559537
X-HE-Meta: U2FsdGVkX1/LD5O4/KwgCYNjWqPWwDW1oo8vT/xI67FTQ4LVrnMFC5WVA1QPnYiimBKvxqsqxlX+TIV4qY43H2oPAiEcxTZ3Bu61KSmqTDW9aWajtQW+fHfzFioTWc7bxyqbdXSz/1errmbZIp55KVO/vMP9RDLUtErWrF1CFCFWjFhjAwF8N6DN7glLj6Jt2n461kryUlxIqzmcJ+6DH0CO8eebrpjdsmYb1a6lgcp0GIXZbUT+ETYL+aC1m695wqe+tvi04oI82boVAvhSLOmnY48lW99OesbHAyKedoZrstJeMSj+m8ZcgYzb7YpmRx8BAMOtSYTj01VVdxDZljyMhDsAVYVJEWBYlD4PerJ+EMttXOmbfGIJFBMDCVZy1Cg6OuR8IrCIKhuEqwgIj3qPwK2+mhmmdIl2FpuMwwz5QJYwaLPY36Qv7cz3JO0rLi7UlYcexZT2/+aGtzwsUMHR+UYrvxvIb8sixd5plekcz0uVt04o4isymX135jb3dlQVhmr/H0LAlB27wdUTfXh0HfjHrInRIRuoIdOQ9GnMIf4VdYUXiHy/sBxptLF/kjQlzvsIme7vTAiHalNQFNg5CuzX+SzjYOzCUnle04LT8JExH8qWejLwWDevSczBcwvbouqZk1QCA/yQopHLOoTMIXk+xLwgennHwopwaiDhnpUfgsL1jeH8iBWnNotNeT6bmXZUgaZmk8tUfZipO8TLcul87grJYnakptq9uW1TisKZTiiegUOQSpPWH5Wp2E9roAyOQR4duBur93dUcWpK+QCf37WrLNkVwaNPFV5ZOzpNUhBiqmUtBH/rgbrkzSRXAZ/u0iQbPo5P8UZT8qJf4yaoPRDnVbW6t25IXII8KNYumb84+E2RYMZAkF/4I5N/y09GFjrp0eb1Rvo6Hq2U+JiDRwfoQAfUwA2gMC1GBNnf9cuD1Q8Vqme7uQKpVvN3KCOv4tWBXtvCRnM
 vWb0Zt/d
 3hZ8erX8RSoKjhvTDzLIBrqBayAi65OGU2k9DqjUl6mx/nilcsRccDSVSPUo71raYACch66X5TgbEUfLubBv5lPMmQO4Rr5b096xQasp1bQ6V2K+uxpBpfWjCSgv/zNWrOQ/v5sbVPwRUMSVQ9P9JBTugzPI1gCTtdROjwHOKG4ISTXT9EA7BfmMlpeVaWOAiB3cR1FBJnajyMwNk3+Gg/bi6rgYy+rdHmH+csPOHLivcO4k5S38Bm+jbqELzJ6hvjleQ627sQIbM1tCbxkvkbHxnwQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
index 03b41f803520..e5c0f7201cea 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c
@@ -1581,7 +1581,8 @@ int amdgpu_cs_fence_to_handle_ioctl(struct drm_device *dev, void *data,
 	struct dma_fence *fence;
 	struct drm_syncobj *syncobj;
 	struct sync_file *sync_file;
-	int fd, r;
+	const struct fd_slot *fd;
+	int r;
 
 	fence = amdgpu_cs_get_fence(adev, filp, &info->in.fence);
 	if (IS_ERR(fence))
@@ -1610,21 +1611,18 @@ int amdgpu_cs_fence_to_handle_ioctl(struct drm_device *dev, void *data,
 		return r;
 
 	case AMDGPU_FENCE_TO_HANDLE_GET_SYNC_FILE_FD:
-		fd = get_unused_fd_flags(O_CLOEXEC);
-		if (fd < 0) {
+		fd = fd_prepare(O_CLOEXEC);
+		if (IS_ERR(fd)) {
 			dma_fence_put(fence);
-			return fd;
+			return PTR_ERR(fd);
 		}
 
 		sync_file = sync_file_create(fence);
 		dma_fence_put(fence);
-		if (!sync_file) {
-			put_unused_fd(fd);
+		if (!sync_file)
 			return -ENOMEM;
-		}
 
-		fd_install(fd, sync_file->file);
-		info->out.handle = fd;
+		info->out.handle = fd_stage(fd, sync_file->file);
 		return 0;
 
 	default:

-- 
2.53.0


