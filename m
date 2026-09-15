Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEB6C88E7B
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D985D6B00C0; Tue, 15 Sep 2026 07:35:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70DE6B00C1; Tue, 15 Sep 2026 07:35:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C873D6B00C2; Tue, 15 Sep 2026 07:35:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8E0D6B00C0
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:35:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 03A2A1403BE
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:21 +0000 (UTC)
X-FDA: 85215790884.03.3D96BAE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 12988100007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HrkMpIvO;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472120;
	b=I03eKS19lExY0mcFKQSapBE7PF7SA4eW3A+sMtE5PLg89aKMmb7Rc08JVzoKxpaChX5x0I
	/vUMJ6L6ha4/NAOUreIymg2SXKYt5yxUEJOgZqraE2Gz1W6T3uGuHFO3acmavrCG9g53qx
	LG3UTHvV/LIFAsFKBbvW2mmg1Bol2tM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HrkMpIvO;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vu/oKxz+arn92APs3M7qiv06zwHfUu2cH5sFUjT3DBs=;
	b=2QXSkx35nfiv+A+o2GOe1QoU5ohKBD/d9VLw0w1N2usGdlDhcjVMgMrTK/WDp0cLLDni2u
	Ws3IRfZInUmOYR5yts0ayojAu5NClHqWfPd7kZEuy1H0OptHEmOxSf0nASWtOKipQMiMBW
	B307VpH6hIC60SbAqGbZ2Ki/rUIgYDQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F5DC415D0;
	Tue, 15 Sep 2026 11:35:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A641F0089B;
	Tue, 15 Sep 2026 11:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472119;
	bh=vu/oKxz+arn92APs3M7qiv06zwHfUu2cH5sFUjT3DBs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HrkMpIvO7iGYskIOyxgrnhbmY51Jc8Ub7q4Why0AOMW3f+ydbKbSBCxy95zXyqe1p
	 ZoAv51UkkYKpcZYTAAisBxBl4hf6Uv+KmnEvtmEszCrFQ4UCX6prXJTwvfuh+VBg0H
	 KsE2Brv2yI+jIip82JC/Ngr+3NzDrIw2sFwoF22lMvLiCLY/9/fGutyOhJmWBoHQ0r
	 N5tgRdT+HEy2DU7RimgNlnfIOmMDcup/G0VPUdWrNxwZPN/IikW4sEG5zmO1gaEX/J
	 VgppH76C/4vJ+axoPp1uwZD0v634hBDcqupR0UFuTNRHu80xxaX7JAyL6dF7YCetWD
	 6h8T6BgsJ0X2A==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:17 +0200
Subject: [PATCH RFC POC 31/50] vfio: install the migration data descriptor
 when the ioctl returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-31-4d5217d6b246@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1192; i=brauner@kernel.org;
 h=from:subject:message-id; bh=ZuarGRo5ZqIHA3hh6zA1izPVcZ2LCwhC5SlPF3ZepH0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Kkzvf951a0G+ZqpXSZ3J2/arrxG/8r9+aez1z9K9
 bjIVK2r1FHKwiDGxSArpsji0G4SLrecp2KzUaYGzBxWJpAhDFycAjCRLQaMDBeN9d/bKs4OXXDx
 gkR+xafcmPCqbumzYcILTbl2Jzp0VTP8YspvytbQP3uhP99bqOslw97nz5UieFd43hf6lsB++8w
 DdgA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 12988100007
X-Rspam-User: 
X-Stat-Signature: yk8yfn9f1sgio66a575fegejxu6j4ri5
X-HE-Tag: 1789472119-822032
X-HE-Meta: U2FsdGVkX1+bFmCTsyYAR0v5sOoVmi3dGOFoL8PDgueEn3LEXk8W99VceoY0EskCZnygc4XXE5nFhB0lxHEjrQZ/acZhnVS4JoHVCwusG2l0cNQoJhUMSj2iXMDSK4VyCHzLTEU9rTA7cG4ASKDbBpWZTMOPtNnbgWe0tzqTMAiuDCYAPKFV9vDDIzL03KbuztGEIS7txw9XtzOeeI13layE3V6rP8N4AMiwXbKcPUq5tVRiOTwibD9rHsiGTjm3imba+w/H3BAmwGX0T1QvczA8Z/1iV4Dzg3sDtcsZXmhrwVCmIvOOS1WVsAvmfainhGEPMRjNV8ke0+C4zGFgqERunyZqmup/U+KfHpizHLZ3KPJT3g1PmXwr+8QmdiAzI0h093kBZRkPt7bytnb+Oe0QflG+zI9AjfYAYOnaqhLtelwjdwxgA22O+YDiHJ5Om2ZnpFcVK6B0hmvuDN0Y3KoTZvxK5M2dIwbhU2ykAyUFEki0TzW3mVlZpSQviYwm6EvAJzZer4Px1Eh65RLfzj2Y0NAf8+cUlJSx2/L9BGnhXRyK7IB5amHV4oJ9mvYCIhFJVQlrlN8r9VEw9fNqLQ87BYZPHmHQcOIch5nvzes+bJxPmHx6AVU6s7g5z55ubOhZr6bl8WFX0Kmfo2Waeyo71xe3SoTmqdQB1rrWipo2TJNwNit+iELzxbHW8ZLM+G0+TcHqh2W7OtCoI1rfKi5szWMx7nglvs2bnbZzWAZ/dexHTnW89NZlm1hJE+xtVEuPITtwteowbT/1Gw37LyK1YYBxpGhuViy1guawkqNGlkcRbvc/yiDQ76j+JmE2H2Ecf79s1eiyEjHK7ZG5iOtFBWSbJ/gIGp3cHoi98E/+d/cQSIwz66RsSutOHvx3YmZI9kn6CQDGmmyjkbKXohP6P/rS1el1PEYwiLIqlT0pxKG9bQ9l0gnR7n824IBdDgy98FFok3U7HOVDJR2
 n0gUXfrJ
 1LgiDmsWzWUkG3200KyZx8CR0BLosyAWFSBUghKFNVdTYZ2EtWWeQAXlpwCwknucbK8WXMBYLJyHfhTF0OXtkEnC1C+reYzS5sRkHYx7UDDq2c4uE8wJ+UMw1dDKoyJwE1heeTR20dz/V1PykRnGUVi4oXZDG+RLnuc8Ng3KQxXAxkBVIUEN7QsCIHcgSzlo6LmuJVUtZboBtGKYiyyoFvrWHAv1vJON7heeoiZxyck+XOGIffxkqW/m5jIiMgtgOEJqN4udvPlQQ1Jkyn0DHInSS1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/vfio/vfio_main.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 423ead48aafe..93d9d21f4074 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -903,28 +903,17 @@ EXPORT_SYMBOL_GPL(vfio_mig_get_next_state);
 static int vfio_ioct_mig_return_fd(struct file *filp, void __user *arg,
 				   struct vfio_device_feature_mig_state *mig)
 {
-	int ret;
-	int fd;
+	FD_PREPARE(fdf, O_CLOEXEC, filp);
 
-	fd = get_unused_fd_flags(O_CLOEXEC);
-	if (fd < 0) {
-		ret = fd;
-		goto out_fput;
+	if (IS_ERR(fdf)) {
+		fput(filp);
+		return PTR_ERR(fdf);
 	}
 
-	mig->data_fd = fd;
-	if (copy_to_user(arg, mig, sizeof(*mig))) {
-		ret = -EFAULT;
-		goto out_put_unused;
-	}
-	fd_install(fd, filp);
+	mig->data_fd = fd_prepare_fd(fdf);
+	if (copy_to_user(arg, mig, sizeof(*mig)))
+		return -EFAULT;
 	return 0;
-
-out_put_unused:
-	put_unused_fd(fd);
-out_fput:
-	fput(filp);
-	return ret;
 }
 
 static int

-- 
2.53.0


