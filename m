Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACBB7C88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1176B00D7; Tue, 15 Sep 2026 07:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7A846B00D8; Tue, 15 Sep 2026 07:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDFD6B00D9; Tue, 15 Sep 2026 07:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B1496B00D7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:37:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 084BC803BE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:44 +0000 (UTC)
X-FDA: 85215796848.03.1D2E831
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 36D141C0008
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:37:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SMo47o/J";
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjgNPx3x7WII2tr/AwvmAnEJWXGOM0OeaxbIcUanKyI=;
	b=8Y5ZhHtdlTzydUWR0SuAK1dc6cIrGFWgnd9faSwwGYs72XdI5B6XBKR0tUcykXLhC+t3+i
	YTfXYsD5/gA98qf3gaRKj5YtRvquOepb+5vbZSRvGxiKZFKNRAva090Qzn3oXwGNLsNlnt
	19Ugzm4/iVT9xWDIYt0PE5lQerZIUBA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472262;
	b=dZ80TeLlo3guuFlPMTdpqZ1VPOxiSoLRBCqs3nLKhfr+cMhwBcYXRTTvcGlk2012VnWJFT
	5tfA/la3Gt/Mml2UT4Aulg3WWFrRaEXT7C2MIXbNcXvRa16Ot744ANseYdmIfkAEiCQlZq
	CLnnxW/WLogP7t2F/7GwtwUeLC00I0U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SMo47o/J";
	spf=pass (imf18.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 860D2413D3;
	Tue, 15 Sep 2026 11:37:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B071F00893;
	Tue, 15 Sep 2026 11:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472261;
	bh=tjgNPx3x7WII2tr/AwvmAnEJWXGOM0OeaxbIcUanKyI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SMo47o/JPxKGY6qTNLRWBziEbn+58IX3nPctPMC7Rjv/4Cm+o+BJijIJnYVe8zJNi
	 wtm2ogfTwLSXwVXiRa8BwU676bAhTFIUDdSLL7QWmD6wZs73V9DyEUOfRDrJ+IY403
	 kqv0bmOC18w9ruJeugOg/OVAFQjR9gpxqiygmBT/TwoeVymZyVDEbKq6Hd3l29gwkE
	 6gMLb1D7frbGbL+XuuTzjEeBT25eZX3KvVOEPtQdK5AuDh5R02exf0Wm9bz+fe67Iz
	 hw49+A+yqFYEMWzyNlTUmA/r+VKXbFFAqeFAkxdiB9zM9A5cJNU9ykZ66qrgX/f5g4
	 5B2mHT5wBqVHQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:35 +0200
Subject: [PATCH RFC POC 49/50] iommufd: stop putting descriptors back on
 failure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-49-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3656; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Tx0MTQ1YnVtsCJithyQQ1YlkyHM6SB+QGz8po6KWPTc=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kk3WbDjFvN29pT3Xq7896z8vX2FtjvvefB1xQfue
 XsWsk4o7yhlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZiI3CuGf/rLHM5NDdh5MSei
 56otb6TCFq/HRZ/fcG4J0t5of2Rr5hxGhp4HVV1b2aIEtkx5uGOb3IS1967+fbb6v6rTAdk7ocz
 G3mwA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 36D141C0008
X-Stat-Signature: 7h53b4xh3sc356njk48iia1g4ffps5i8
X-Rspam-User: 
X-HE-Tag: 1789472262-917728
X-HE-Meta: U2FsdGVkX19dEt2mCmIgCvdPFbvn5YlCg0lhUVAfggCBkvNHxetcaTLE8HDZHfeAPoCEkbILiRGC65KLNu9ystK51fDZZXOGDZoQyAlJL+JwT8s8ZyQbxItOyPXq72tSRBD6/YOfafuJivuTiV4HoJ3mRmC8U90ooq1a1DEwo/aI7Rwq5OIGJOVqfmCz8twmD7G1wvLEFl/dhIN5Jqx3DHsumL8hiHJBd7bTCg8kdlKy0Uh6ZsewvihZd5iXyzzQ8IGau6g+jxhEllEfa6GyamdHN1og4ugwmHawX6KcCf4Ni93PTD1vsqb60vQNE1CxEiPy5akIunmdpcPRMm1AjGEitwdTOsQxHTOsse3n4FXIFRmCnf6xG0yOdOip8DDut2UBVlugMwLg2mtC+vIPikSpvdzZtctwwl4HCH+ykG741NE9bx5m8n+wy1fc75yqtrGrR8RalZXuVSBb7a9VX/dahOarwbmsvp5QgBt5pry3vQzNfEN6d9JlXCubm9N5upp+1PX636KpjiEgUqCLJqv9lYOFcNEsUxzKlMd9y7Ievm0mP8KXcSHLl1+lblv4DSZVnTVd4o7KAPVXl3ij/r9EWIBYEl/l04K3OtQyVFgC94mqH78tUJfvikxKV1et8YUdt/JNRL+VYI/NCpyJVtP/kIYd0up6Ro5Eq6Zf5jDoF3XNl0aLx194GdUjQSiHd9/y0K4zpaZ9GtAhrRMVlapcElc9rJxWaixT9wMqkktPje05cxPKSy/f4x6HzwFqlL/yW3wy+0NEATWFUpT8jfhdOe3KVyMRikjNjHQhyWlXE+WNxTr2rJqcXCupsRszcZecjn/dn2ifffBzn/iEXHMFdD6fzYw6IfyWb8f50nOmx4EkopR/McERza898nnACPsf/4bR7D1uL2Tx6QT8tG7QKf1M04ALXlLH/eovVX0TjrLPIFOxVCmYYbunFJr5dmevlOS46sye7WcILu2
 iJN9qyHM
 PLm8Eon1JsR+ORfhVtfs5f61AizeFDs5TrX5gkeutdvlmThsJ+N9N2BelYrLX4ts+0Khko5EwoTTIlGlHhnDhPQE2aVHvEoIXB4Rrb7D5iH8glGEVXWt/pjHU1WEAQr2ZULLBIBX1AWzX6tMcn50A1M8ZVcFkZsNU3cBd4htYpwAIVQj/ChjyT0T2j8DDY0wg6f/t5AgaTK4sLOMgFNuO3RIXjqTCAYnKEKWOCcfPaMMkER8f3cz2B89CZ4lKi+kUGtR5w2C+TOqv+m3O8v7VAT1IbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/iommu/iommufd/eventq.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/drivers/iommu/iommufd/eventq.c b/drivers/iommu/iommufd/eventq.c
index 747dd5155121..f5fdc6cdf0a1 100644
--- a/drivers/iommu/iommufd/eventq.c
+++ b/drivers/iommu/iommufd/eventq.c
@@ -412,9 +412,9 @@ static int iommufd_eventq_fops_release(struct inode *inode, struct file *filep)
 		.release = iommufd_eventq_fops_release,                        \
 	})
 
-static int iommufd_eventq_init(struct iommufd_eventq *eventq, char *name,
-			       struct iommufd_ctx *ictx,
-			       const struct file_operations *fops)
+static const struct fd_slot *iommufd_eventq_init(struct iommufd_eventq *eventq, char *name,
+				struct iommufd_ctx *ictx,
+				const struct file_operations *fops)
 {
 	struct file *filep;
 
@@ -425,14 +425,14 @@ static int iommufd_eventq_init(struct iommufd_eventq *eventq, char *name,
 	/* The filep is fput() by the core code during failure */
 	filep = anon_inode_getfile(name, fops, eventq, O_RDWR);
 	if (IS_ERR(filep))
-		return PTR_ERR(filep);
+		return ERR_CAST(filep);
 
 	eventq->ictx = ictx;
 	iommufd_ctx_get(eventq->ictx);
 	eventq->filep = filep;
 	refcount_inc(&eventq->obj.users);
 
-	return get_unused_fd_flags(O_CLOEXEC);
+	return fd_prepare(O_CLOEXEC);
 }
 
 static const struct file_operations iommufd_fault_fops =
@@ -442,7 +442,7 @@ int iommufd_fault_alloc(struct iommufd_ucmd *ucmd)
 {
 	struct iommu_fault_alloc *cmd = ucmd->cmd;
 	struct iommufd_fault *fault;
-	int fdno;
+	const struct fd_slot *fdno;
 	int rc;
 
 	if (cmd->flags)
@@ -458,22 +458,19 @@ int iommufd_fault_alloc(struct iommufd_ucmd *ucmd)
 
 	fdno = iommufd_eventq_init(&fault->common, "[iommufd-pgfault]",
 				   ucmd->ictx, &iommufd_fault_fops);
-	if (fdno < 0)
-		return fdno;
+	if (IS_ERR(fdno))
+		return PTR_ERR(fdno);
 
 	cmd->out_fault_id = fault->common.obj.id;
-	cmd->out_fault_fd = fdno;
+	cmd->out_fault_fd = fd_prepare_fd(fdno);
 
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 	if (rc)
-		goto out_put_fdno;
+		return rc;
 
-	fd_install(fdno, fault->common.filep);
+	fd_stage(fdno, fault->common.filep);
 
 	return 0;
-out_put_fdno:
-	put_unused_fd(fdno);
-	return rc;
 }
 
 int iommufd_fault_iopf_handler(struct iopf_group *group)
@@ -506,7 +503,7 @@ int iommufd_veventq_alloc(struct iommufd_ucmd *ucmd)
 	struct iommu_veventq_alloc *cmd = ucmd->cmd;
 	struct iommufd_veventq *veventq;
 	struct iommufd_viommu *viommu;
-	int fdno;
+	const struct fd_slot *fdno;
 	int rc;
 
 	if (cmd->flags || cmd->__reserved ||
@@ -543,24 +540,22 @@ int iommufd_veventq_alloc(struct iommufd_ucmd *ucmd)
 
 	fdno = iommufd_eventq_init(&veventq->common, "[iommufd-viommu-event]",
 				   ucmd->ictx, &iommufd_veventq_fops);
-	if (fdno < 0) {
-		rc = fdno;
+	if (IS_ERR(fdno)) {
+		rc = PTR_ERR(fdno);
 		goto out_abort;
 	}
 
 	cmd->out_veventq_id = veventq->common.obj.id;
-	cmd->out_veventq_fd = fdno;
+	cmd->out_veventq_fd = fd_prepare_fd(fdno);
 
 	rc = iommufd_ucmd_respond(ucmd, sizeof(*cmd));
 	if (rc)
-		goto out_put_fdno;
+		goto out_abort;
 
 	iommufd_object_finalize(ucmd->ictx, &veventq->common.obj);
-	fd_install(fdno, veventq->common.filep);
+	fd_stage(fdno, veventq->common.filep);
 	goto out_unlock_veventqs;
 
-out_put_fdno:
-	put_unused_fd(fdno);
 out_abort:
 	iommufd_object_abort_and_destroy(ucmd->ictx, &veventq->common.obj);
 out_unlock_veventqs:

-- 
2.53.0


