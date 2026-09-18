Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA587C982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:33:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CAC06B009F; Fri, 18 Sep 2026 11:33:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2A86B00A0; Fri, 18 Sep 2026 11:33:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7437F6B00A1; Fri, 18 Sep 2026 11:33:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 433CF6B009F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:33:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61C171406D4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:34 +0000 (UTC)
X-FDA: 85227277548.27.68CC7FD
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf14.hostedemail.com (Postfix) with ESMTP id A2982100004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:33:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fcWx8yLd;
	spf=pass (imf14.hostedemail.com: domain of 3y1mtagYKCJACEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3y1mtagYKCJACEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789745612;
	b=b0e0fT4xhe3UXjv2jlX9+sphuyIadBl7fF4RUIkadZLp1ONhBzuBsdRK6z4rBa6G0sUWel
	iBCPuO/3flFPeD+X29maq8WHk5lbRgMFdlis/8AVIDUcMZV7NFRWScyXy80ySrD6xPq3/f
	fOHeO+i+Ds746IyQH9O0vPtMEuCvXjU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fcWx8yLd;
	spf=pass (imf14.hostedemail.com: domain of 3y1mtagYKCJACEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3y1mtagYKCJACEBy7v08805y.w86527EH-664Fuw4.8B0@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789745612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lv14f2Ly5jvNlP8xqLAumR3AMqosSrAJIJiLUsY0qSI=;
	b=qeqiF5cM29i5H32TRoqSVIkkY9oDu3khkcoFWafhNz60+Bqtjkb9zcAyBYzfgvzqUi9FLy
	wCZdK6HwN7VPzfMWYduvF7vqIZQZ8A2lEEKZUfWCAlcxSMdDoGElFgz6BGnUadz7AZJr5q
	Rpy9FvoSsSD2xoGHTGTYZUo5c9oXaG0=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39aee9b4cf2so1588536a91.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789745611; x=1790350411; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lv14f2Ly5jvNlP8xqLAumR3AMqosSrAJIJiLUsY0qSI=;
        b=fcWx8yLdsplLTN7Yeg394V1MvJmRFbApT6mzKZmnyN8MXHlzEW7ZP5YcmNUP/aZ71G
         UF8eB3lZcrjqUOlUHC3RLNh3dhjVgww/qkhbkY4vk29XHw2hx91ue6OxHCU5LVAkJ95K
         /LfTFE2uKMC97mzg3ukDYUVmIZ9APRqgT4Gk9Z1go8nsS1QLPnoM3bb+ECXGFCb8QOWU
         yZKy3/m0sfgyPI2PUseeGGH08nwJe0AlQwIcv/KItPlwuEqOA0s9toISWHP+O6ioNC0F
         09vkBx/q6Pxx+DNw1oJJtmjEeOZzvnni+QWJHYU57pFS4a08lkaQt5Ddm5KlRJRUEBBE
         SRTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789745611; x=1790350411;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lv14f2Ly5jvNlP8xqLAumR3AMqosSrAJIJiLUsY0qSI=;
        b=Gwl2oISZgKRuwPM2qoFryCaBWLq2rnjjIpgUv52viBEiucs2Ad7lxBsLBgOKeHdRXj
         Ot0+NmDAwR8mMS/OzMOqwXKPDSBWX+nCvstGjSLeyqvPEdJvmMt2tQJZu+Xg02loumjX
         yG1WvzAf+uNP1IhUCPz1XuC3fJlyR8LVAEQYqoH+h3cNuKLYmgy6eGfj3y5uFdg5x6Mo
         zqMsWfQSNk6iVo4W9poZyB1Gi26iBLnGmOgYW69RCbe+d2GFoZ19AX8iY95GtFtwm/6I
         kHaIyZMI8hexDhiJIav3dZO1nxVa0MDX4n6bwFi8fRJ5eqZkJ6AXBP15Y0QqjJD6CMTY
         X8wA==
X-Forwarded-Encrypted: i=1; AKwUvBzcgU+5Q3ZyMyfEBHBGMWbtKOMVR3Y0U9vGohAxnVPplwZd7Mm5J3Vw5oCkTsZp5G0b6p7KlIwjfA==@kvack.org
X-Gm-Message-State: AFuF++lMyktl4suDeTp2K02nNjVKBhAWq900Kirq9+vICuM1pdCwTQSn
	R/cGmeEySx+o++LkukqaR64mqIrzuqycNZiDSb6ke+RhOKSam03hNG+ZT9b0ZFmoOYPAGs74TLj
	jc43DEg==
X-Received: from dlbcy8.prod.google.com ([2002:a05:7022:b88:b0:143:7b76:ee9c])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90a:d410:b0:39d:f024:c7e2
 with SMTP id 98e67ed59e1d1-39e54cb099bmr6569591a91.4.1789745611342; Fri, 18
 Sep 2026 08:33:31 -0700 (PDT)
Date: Fri, 18 Sep 2026 08:33:16 -0700
In-Reply-To: <20260918153318.758387-1-surenb@google.com>
Mime-Version: 1.0
References: <20260918153318.758387-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918153318.758387-6-surenb@google.com>
Subject: [PATCH v5 5/7] proc/task_mmu: change proc_get_vma() to stop returning
 gate VMA at the end
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@kernel.org, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	xueyuan.chen21@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A2982100004
X-Stat-Signature: 3h3keyukifqaixuyt9zm3zfj6fz6dr67
X-Rspam-User: 
X-HE-Tag: 1789745612-726350
X-HE-Meta: U2FsdGVkX1/wtaKIocGOp6MVUoJA4rwWdxth4C5p0FnYL/snESjmNJgkMseQI24zoo0O93Cv3qYCb+6pBVfXMSbxdu7s+2AYTlVqP5wiJhgwB7IfWFlQ8gPVYCEeGLdShSD2KZbRJxDxoL/HNtNH/UbAjozvG33egMLZbjbJhQereto5A1tWoSMrk6SlYB9B4fILuC+Fy0xxaxg9A32O1bVCP92PuhuQ8rXHhpiot87aFK7KzgfNNzyKnHW1amkBHosSxVSxVyJHQTOXr04yW6CiatbvBTk/UNk2cN2gaILren5+jpbX3W737Na/LE4tg2ZyjbkICQ+miALwSTEk4KGKtiZJSQ3Hghnb+TTuCao/sLvGFEsx1fDccBSxUUPmJThq8VL8VdGXrNT8svLTWRi4MF9hyinVt3hEHYpQndr22+Z6FwRwucB2fiH1sVWsbTOO+3nOFUuQcy3c7k0tkTHeX4crdXJQylK4F+jghK+fb+/5UhMgQvBMWQisahFMVOLVnWQeabeRYami3IMZU+f+4kCztrIVyX4ILKp5WOWuZAMza1c8+pArVVpJSG4iDPQrA7+103MIwtb5ZTg3ubOC6JFjxs4TwBmGCSPI+r9d6iZ98nsivAwe/PNaDSSkgtCJdgQfF/YvLu+wg0bve9eZFCmvHJ1DV6sW8ruFyrU0sM+lnoqsdPfMqQ7ihOOSss1/C3wWqDazsdfbljYIEwlJmojPxTrkqGFU2QxzGrq909PptXFVTVLlkKgcuaT6QLvZj6epbLvJqbYc53bflcjiOYE9Jf8QK3poTeaX4sTu20HKlG2YSeBYb2xrettl69/jrOitOoMixJoEUN9/++BOtrPwo/mIdfdHuJufanIiVuOy2Tmlyvm3e4CCsGpqiGQj/CKIrLT4vh86XJ5avpsNVyTsZddTH8rhf3TJ3MJyhx5in7Qt1b53Hr4PTCXhAEjX4pOba9Vfl+pVXyx
 ReWajE6J
 g8XW49iFmoGOLMIFg8MvShqJ2dV0RqWhaPLjVow1wHxQwo7fxDvwaYNDNLQjnFAWDd04H56HHCTqiBJS3Gv7i/XVvoI562ZcVWOHer8qg+LFx+Y37diVUGPlrJwn8F1n+FOu/4aYGGHiETab8WnLtgXWAcJdFxaYsUjW4WNRVklJDMZIELxqIeCJS6qoiHtQVAjks+Vmw0m99qZIqenbCk3TOKJ1Nu0VGVtwJeZ5j97PF/h6NZu6ga3j/BawHrr0Iq0XWMluPKe/LjeGk9KXfeO6GCDS0XGcJSP9389eMBwETZm7AV+91fL3XVCWv/wIxUHWzm98sC32vMBquEqoKn1/5QyGsTt9NGYi58UlhGTm8sFuG49trmfwHLBMZkZ8LovJviWthYz4/1vxUFXIPO7zu8yJC88tc4//EdPDCy1geqQri3adDXT/hSAhIR0o6DQylo4r3eHGxb7tgOkGuGEirGyjX35sgBeuDTHebxFZ7589E0aG+V02jrAMNfp9IxLR53P3ZmYeagA6VZTshPx9uCvv7UHzs9bBvjQDB4emHY/IA2HvTX5z5ij2xUjpF8g9MJ80t1tEfWAKWddpEVzQ3WfAsA0dLf6J1XbgW3kB+j69Mv6Jb2k+KatoVoqJnaFQB9g/1Ub4WtCfjtsXe9XJXuTf/UZ2ukake3CpV6vSS48I35ulY1Eek+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

proc_get_vma() returning gate VMA at the end is desirable for the its
current m_start/m_next callers, as they need to report a gate VMA at the
end of the address space. This behavior is very specific to these callers
and makes proc_get_vma() hard to use for other purposes.

Move this usage-specific behavior into the callers themselves so that
proc_get_vma() returns either a valid VMA, an error or a NULL when no
more VMAs are available. This makes it more generic, simpler and usable
in the later patches.

Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 8f2f302d4563..2c90b91d271b 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -240,9 +240,6 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
 		 * found the extended vma with the same vm_start.
 		 */
 		*ppos = vma->vm_end;
-	} else {
-		*ppos = SENTINEL_VMA_GATE;
-		vma = get_gate_vma(priv->lock_ctx.mm);
 	}
 
 	return vma;
@@ -252,6 +249,7 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 {
 	struct proc_maps_private *priv = m->private;
 	struct proc_maps_locking_ctx *lock_ctx;
+	struct vm_area_struct *vma;
 	loff_t last_addr = *ppos;
 	struct mm_struct *mm;
 
@@ -281,19 +279,39 @@ static void *m_start(struct seq_file *m, loff_t *ppos)
 		*ppos = last_addr = priv->last_pos;
 	vma_iter_init(&priv->iter, mm, (unsigned long)last_addr);
 	hold_task_mempolicy(priv);
+	/*
+	 * If seq_file had to flush its collected data right after m_next() set
+	 * position to SENTINEL_VMA_GATE, m_start() will get that sentinel and
+	 * should return gate_vma without calling proc_get_vma().
+	 */
 	if (last_addr == SENTINEL_VMA_GATE)
 		return get_gate_vma(mm);
 
-	return proc_get_vma(m, ppos);
+	vma = proc_get_vma(m, ppos);
+	if (vma)
+		return vma;
+
+	/* Return gate VMA at the end */
+	*ppos = SENTINEL_VMA_GATE;
+	return get_gate_vma(mm);
 }
 
 static void *m_next(struct seq_file *m, void *v, loff_t *ppos)
 {
+	struct proc_maps_private *priv = m->private;
+	struct vm_area_struct *vma;
+
 	if (*ppos == SENTINEL_VMA_GATE) {
 		*ppos = SENTINEL_VMA_END;
 		return NULL;
 	}
-	return proc_get_vma(m, ppos);
+	vma = proc_get_vma(m, ppos);
+	if (vma)
+		return vma;
+
+	/* Return gate VMA at the end */
+	*ppos = SENTINEL_VMA_GATE;
+	return get_gate_vma(priv->lock_ctx.mm);
 }
 
 static void m_stop(struct seq_file *m, void *v)
-- 
2.55.0.1082.g2b9226bbc0-goog


