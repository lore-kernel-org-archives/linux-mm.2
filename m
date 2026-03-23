Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AAA1F532C1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E3A6B00A9; Mon, 23 Mar 2026 19:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467356B00AC; Mon, 23 Mar 2026 19:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3824A6B00A9; Mon, 23 Mar 2026 19:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1D5426B00A9
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:00 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1A8F8D1F6
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:59 +0000 (UTC)
X-FDA: 84578995998.21.F9763F2
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2A727100002
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PtgrlTRq;
	spf=pass (imf14.hostedemail.com: domain of 3wNPBaQgKCMMmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3wNPBaQgKCMMmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i6NpvLJAkS4c52+WboP6wAkf2PbPQKSMM3U4nd1tgoo=;
	b=5Tnq+XRIDgIbBWSlisSlSXFy31obxPzngvGgiqHb723QywaIRbhKPBCeSzGFwmOKEH1MEW
	YKqkIKf4I6gjXXkuJde89OFnL2kmDVKZXlRLghGi6wIb3RStrhxw2w67t4rWpWF8ORnR9P
	hEWwmDClkYBzUY4zOgw9ZQmjo4obIyc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310338; a=rsa-sha256;
	cv=none;
	b=1mQAXMM23TuJq/RIhE5tCjW6VJlopTxphDDwcrweKOWd56VZAxk3WTkh+MIzLZpS0CZeza
	xKkzTNshirumIxg8pYJMXAZQ7vSKCdalI0vocQ+1te3e9FsjFFhzvbg25nV8jwSvaPnmN/
	qc/Pj/lB3ddiUQBFWRod5Tk4e6t6ACY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PtgrlTRq;
	spf=pass (imf14.hostedemail.com: domain of 3wNPBaQgKCMMmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3wNPBaQgKCMMmvj2ujltpxxpun.lxvurw36-vvt4jlt.x0p@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b061868724so3415035ad.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310337; x=1774915137; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=i6NpvLJAkS4c52+WboP6wAkf2PbPQKSMM3U4nd1tgoo=;
        b=PtgrlTRqK8MKJKD86vl64uNaYwWXp3DgtYsC4/ovgiBkk6MgtRURnfCx/+z2rk0KcW
         1kmAWWNGZwN5P9WfyMJaXAPcNNiHP+KItD0xusWpXXe49KpP+obqAdosXUcSKa5T1n/u
         ggYFzsn4ZxMMowReElN/12k43nDW+1qgs0RUN5nqmjrsvFGvqX89ArUg4r6pajzjxAOH
         Mc3c7nXUvS7lDi9Z/ytyjO3si+3+vZo73ticHVuO6RkyMnU3eq7hlEDL0zpwZUDwyJUJ
         Mj+0cPzKgFqMQ5MCiuXaFEQLyNbxXUA4y66oaQZJfCdit3KHUvHdo8opkGf2Vlkb6Q2k
         59xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310337; x=1774915137;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i6NpvLJAkS4c52+WboP6wAkf2PbPQKSMM3U4nd1tgoo=;
        b=eKgcbB+9xpH5/5hTT5r12aryH4hCXCKx0tFeRUQ+X2MkEvP2b1UgRKNBeP0k4rMQm8
         BIvLJnaERHc1krqCFGxRe2pl0KPHUTaaxhswnmWKd9zmIP7GDWBq5lJNid5uLu/bYiIY
         fGEBxA4IrS14HrMXbfxqbMvvRZ6pzOvl/AguhlT9w6ccatsgwcPiX1vqBqcrk8idjsT7
         IP1D6Z/+7Tthoyl1/Ihjv1DL26CtflPYeq1+sEnbh9JfuRDHlSh2zzKXbSzRiXqKwcGd
         G7/OoU0gv1fw46L/JjEMpyzvmUyWFHvzrkW7jl3JpAnwZ6Ed2IuAgI8Hn7XA+/KPw7VA
         aEkw==
X-Forwarded-Encrypted: i=1; AJvYcCVdhHIk/thxzglwhamB56zcyQiiMYUKxDLnxpudbWGxeVD1aSWrXPVmt/ctijac1LpnZ9Pf7FisFw==@kvack.org
X-Gm-Message-State: AOJu0YyvSqxI+s9PlJOmswLNqBsETndsFhNX20b+meJRFEPVSLtT2snM
	Fbdct0l8oKItZl3xMRCfvJdCm0/+ARBwPmab9bMCvHzlsKV1iWAg78tXDnczt9v2dEl/HkF9kqv
	v+G9gw5ncmsAlFA==
X-Received: from plgd12.prod.google.com ([2002:a17:902:cecc:b0:2a8:71ec:6799])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f984:b0:2ae:c795:6b4a with SMTP id d9443c01a7336-2b0826d73f3mr94191885ad.11.1774310336851;
 Mon, 23 Mar 2026 16:58:56 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:03 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-12-dmatlack@google.com>
Subject: [PATCH v3 11/24] vfio/pci: Store incoming Live Update state in struct vfio_pci_core_device
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2A727100002
X-Stat-Signature: x4z7bao1ga8idsa9ryrc8f3rkg4anki5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774310337-733015
X-HE-Meta: U2FsdGVkX18e6srekXSKRSRy+Py/m2QYXzldH1XLooEbzb4j6p7vHMbG1uErAWvwesRDAG2h1zbe8ci+w+LEM9DhPi6/VFgGRYS6yiqLvjc6NtjZEBCxX1OrWatjZQT95RZwkeiYdvELgDJmPsEXvbblOpW8aF7Cbpxsz+Ptgd24G+leSayrRl8l1BV7oY4zf4/Z6aaALhwhXh/7xK92aONyzAj4Ib5lZDVGDJ6qLLTbvsk/Cltz6lWbI8OCmVNWC34qGMo1raKRGlXiL0jvdkn86Eotoe0Qt2tNWf8q7lnx4nkDlWg0cnnFl3whveV+FBoqLG1P5ZQilldNSN9+ZhVQD4kVVzGCnin1SkOXd69zDx15wpWUohG7e0k82qRoNozqd12nU40+yU9xJKH2e1PRjAL8xEHJibL88Hmtq77bpdNckZybS6xYuhzLCvdC00KKGl+INry2/bOrMhhYZc4fKFQOp7u6eURL2rrnqgYVm2qBF00CrDnglzrBb6euazHdcCYIqGTPP/yXyQKHu0edibVH8AT6ShNM8QM/Aqr0MhIVx+67E2OVzD+ndqGzeJfYzV5Kd4bcxxmxiUNUD4ol4yAhoUMwO8bMdPQtnoC7p3+/Uwf6QERZRnuDCzOoMdm3fTrhnusvmjyKncOkq/S8CJkRAZzFl5KSAUwYp56sKF1LE8K/DzFuPbGdWuj6KaFF3k1/X/jtJLjCnLuVEebggsow9/DsTtOBDD+LiiLDDmyTINYQfalmmTU7wuz/v0lXOV5OlNUKe+B9jelUyM1wg52KrEcW1GtuOqfgtS1gWfHsc6jBcF0jcERDyTVNmFQK4qagTQk9hu5iiYxr2ByPHgM6Noz/sT+8YzbPaSqU1tRk/1kq8VMuRP8DtdLdz4c+idRawYgLWXr7YYLUmUNaG844XeFimJYpCcN36pv7+HViB7kV0jR6b0PLd0HSXUeTVw/zO5k+5tGgNJp
 QWbbQVlE
 svAVvmA9eSPQCqjnYt9fStNmmUrxtqBM3+Kd752FjzWL7Wg8dy4KW+1D8xmziXYA8cr+GFMaOTbGRM3XsMTjd7iLSen3FqeYwUD2R2gAf9B2PNVvlTWrdBuxIV4hU3lU0a4uCo8TpClenGJTmp9YxgyNjj2kcImgea73JuTjq7aWvSyukQ/OmpvmSdkbo22aBicoV6GFYRJJzVl9fNfhZDAX8laqK+cj8l9ZVITRuLL+he+5GTzL/y2ws2Wo1zo9b1Sghg/Lnatq51Plx94t2C8gHyisbIjozdfKdsB8AVRc2raBBixt2kcALvxVSoMzsjD9PY5NIg/Ck5vvwD81Ul/fjaAaSrOqU053aQ7ijzFJSVHsbSK016eLw+RkDYkLXSrl92GwqqdF1T7vzLwwb8pW+UtCMryRHykCLbCp1sZmhUtZUxS/PPegGkRqP8UhFNeUQsxMuKqJSB23Q4Ze61LUqgljqVl3mfDOnZ2V8ST/KQlPgZn6DqFj0DA4akYolZFd7Pn2NQPN2wn9xygv4VjWCJEYDSQXx6vpBeZgm+brXzm02ghjIarXKo6CmlV+5BrEhjqGQMYWsoNYskUt3OXKnzjv2M+usKPn0DY13jJ7OzrWGHaTUxlbpodOqjdr1MzytEWN5aZGkglMKNNkWOhmX4E7LmGd9KxSufanQkCaEM4ftSZ6V34ppejEV9kqhaxxd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Stash a pointer to a device's incoming Live Updated state in struct
vfio_pci_core_device. This will enable subsequent commits to use the
preserved state when initializing the device.

To enable VFIO to safely access this pointer during device enablement,
require that the device is fully enabled before returning true from
can_finish(). This is synchronized by vfio_pci_core.c setting
vdev->liveupdate_incoming_state to NULL under dev_set lock once it's
done using it.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/vfio/pci/vfio_pci_core.c       |  2 +-
 drivers/vfio/pci/vfio_pci_liveupdate.c | 17 ++++++++++++++++-
 include/linux/vfio_pci_core.h          |  2 ++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 81f941323641..d7c472cf4729 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -568,7 +568,7 @@ int vfio_pci_core_enable(struct vfio_pci_core_device *vdev)
 	if (!vfio_vga_disabled() && vfio_pci_is_vga(pdev))
 		vdev->has_vga = true;
 
-
+	vdev->liveupdate_incoming_state = NULL;
 	return 0;
 
 out_free_zdev:
diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
index 6f760ace7065..8d6681e1d328 100644
--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
@@ -226,6 +226,7 @@ static int match_device(struct device *dev, const void *arg)
 static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 {
 	struct vfio_pci_core_device_ser *ser;
+	struct vfio_pci_core_device *vdev;
 	struct vfio_device *device;
 	struct file *file;
 	int ret = 0;
@@ -246,6 +247,9 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 		goto out;
 	}
 
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+	vdev->liveupdate_incoming_state = ser;
+
 	args->file = file;
 out:
 	/* Drop the reference from vfio_find_device() */
@@ -255,7 +259,18 @@ static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
 
 static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
 {
-	return args->retrieve_status > 0;
+	struct vfio_pci_core_device *vdev;
+	struct vfio_device *device;
+
+	if (args->retrieve_status <= 0)
+		return false;
+
+	device = vfio_device_from_file(args->file);
+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
+
+	/* Check that vdev->liveupdate_incoming_state is no longer in use. */
+	guard(mutex)(&device->dev_set->lock);
+	return !vdev->liveupdate_incoming_state;
 }
 
 static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 2ebba746c18f..0c508dd8d1ac 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -26,6 +26,7 @@
 #define VFIO_PCI_OFFSET_MASK	(((u64)(1) << VFIO_PCI_OFFSET_SHIFT) - 1)
 
 struct vfio_pci_core_device;
+struct vfio_pci_core_device_ser;
 struct vfio_pci_region;
 struct p2pdma_provider;
 struct dma_buf_attachment;
@@ -142,6 +143,7 @@ struct vfio_pci_core_device {
 	struct notifier_block	nb;
 	struct rw_semaphore	memory_lock;
 	struct list_head	dmabufs;
+	struct vfio_pci_core_device_ser *liveupdate_incoming_state;
 };
 
 enum vfio_pci_io_width {
-- 
2.53.0.983.g0bb29b3bc5-goog


