Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E78EB606A833
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ieb+P2xG
Received: by kanga.kvack.org (Postfix)
	id E40646B05F9; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14896B05FC; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3FB26B05FA; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 977476B05FB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CAC131C30A4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
X-FDA: 85406459040.05.65F3975
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CF727100007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieb+P2xG;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011838;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zs1J/x6nfmV3dx/eHdCEN/mRYv0Hi+QZwL/OVF2OHBE=;
	b=qRdQTTuTrl+SPmcRs2Ho2xjYPXykGsUjqEoSmCAu0yaX5SuPAgvCua5CvCxtG2ATp6GZay
	EZbu/O+hDQ5bGLz++8crwaw6KOZ2Q0A3uW5iBIK2zd7d2Q32qFGTBUEuhXkrxlrptpUgXw
	zV1LnDvvAORl4GypzpH1WFIGXw8VQck=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011838;
	b=lUcbLHXzo3b0mBoCEYsV0JcA3yc3YBQbuU1q4nR3HwzNCqlIKmvkgqyO/xvKeYly7zwY/+
	REZ+Q8+ddb66+oNo0TnSqsQFRvRj62oMDNAPoVu7KXmj4M9C9T3+Cp4dnSyYMIo7ptZZ2U
	JOsMGqqO7WhTQ8vctt5Laos+wdylaV8=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieb+P2xG;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 95E0760E1D;
	Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011838;
	b=g4hSPArBDnT/jney67n0J1t/Fbtz1sIexhNHL4FA/ltR+N1eazRRuuUxGVKnvNKFKE5Q
	 hNDoB9kp0LaQcALLfEmwXi7mZ/qIMZ+1k+u8VsQYAdKZHqMa1VE8F4tcqEBsTU/I/tlec
	 RZtzXwD/trH8VlFbVEAVvIKCHCwTbrSPrMNcFJwkIFkGeJ/7hX3iEMY30p/lCS3KSQmZP
	 maq1I9OklQh/Tjv4Vl8SEcI1hCzVNKuB2Kn8BA1JVNh04fnzlZMT7hEhVmnugD9TNtfYI
	 OVFGZBrG+qqpwD+OneiZx5Mi8+VuNlPoKsXkPVy2Mr+IWbQfTsVOiplV68lk5G8DJpw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011838;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Zs1J/x6nfmV3dx/eHdCEN/mRYv0Hi+QZwL/OVF2OHBE=;
	b=wUgxTJ7VW22WQ1KjJxU8xv8sYXDlQbWKTd59+MFCPYMmhcQiOaWNy+mVpqvnhPJrjoin
	 xaOtNY6MG0T1A+8m7g9wRRwlPiBDlIClFjAFLZGjMyiuFXoXdA3dvBVg9kNYO5ejT8T9g
	 y0WWdDQ5U2k5ikt6ybpknIxhOnsd4k+SVTIlhB1itYGviIdc78hLxjsH1l3+LBHPPkfgT
	 Xq5smajz4qco+fPQpxqESnMm0T7+cRo52kSlaJOQn/NGwO7dX61+E1mR8Oo3ow0+MdwZ2
	 wxeclurOeWODUsfpYF15CszyxTip1EKg/F6SyM8aOvkkScjB9Y2FFSnSnV0/0SYBPtA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id E3C221F008BC;
	Sat,  7 Nov 2026 00:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011838;
	bh=Zs1J/x6nfmV3dx/eHdCEN/mRYv0Hi+QZwL/OVF2OHBE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ieb+P2xGQ6kamYKd4+tenquqlrTGuaSLKQlY4uw6J8rckIGGLk5ey3IKena50A7jJ
	 A0e2nux8/sTNf0jZorwFGKdAy8YVWGhWc4N2wvjdyZtoZgaktWwjBFXVEzFv3qR9dN
	 1fh2oJ90229fD92r5zPH3D92IYcdrqI6gb66u7wQRBnVD1yIw3EfjjlL18eCTsqajO
	 dQ9qfzpMYgITlEJ/NKsQkpKfgeqKKUmmw6BFvy1KnC5WfxHBCjKiQ9cJmcoIME/GMK
	 JQyaVUOBl/636TUTgWCF2pFfzD+cC2yWhxa90hK58oo6Jazwx0+lMOXNhRFpxOsBRX
	 J1P4ZJPVmqTxA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 4E83147A10;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:39 -0800
Subject: [PATCH RFC v3 65/88] vfio/pci: Revoke guest_memfd memory on BAR
 invalidation and reset
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-65-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=7771;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=g3NkV0PMjIPnPGwhZsAlobRqGmDhxygV0Omg1VEgfl4=;
 b=x0AjF2T9NT+QEEiAao5ICbuevp1PlS++gYajfqkdep24IiXXDURbfHVED4DDFk2qgccq23/84
 Hl46rCqEmiJD0groeAVC0Rygr97P5L8AyZHy2WA1gx7BSh3dr38vIwq
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: in1sb11ws7tnjmby5e7u5zshfy91fzxw
X-Rspamd-Queue-Id: CF727100007
X-Rspam-User: 
X-HE-Tag: 1794011838-512586
X-HE-Meta: U2FsdGVkX18B5Hc98XWtR1CUT1eGTWdJGrxZtaOg72uUw87d6AGksruvEU0ZcnXLqrIUbfyGbYM600HHGpL7XQPhQLo4cAg5nqP6pxM5AOITHEXmc8oPcnNbkzE5NUzFoT4058+5faOtinJphL2K7V/V3elCadSDasL8V+yuSaZLKXQ0BEuXTohpk2Y9fGaTsbq3BqRJlrfKlfWsKiyxANbOwLYJQ4Bl6GSUQEtGnKE4qMHbQ0NEi2ZLfPqvjedNApYc9n1O0s+vNANTgR89+zBTGAe3gwbqMAuyxGxGl+7T/vTkMrW5MwKTC81xtxbpFR45HPK/Re7G/fCiMH96sMcbmInOD5/mBqBLVlm68Rm6S7YOuMMjD2Vv7RUtbtF80RUfZy3ZJ67wfLTqGpAxck8mwfu4Iu+jZGIAIX1eUhmEezFH/fqbLRN0+UJ0Nxni2Hz+omLbyKzUaNMkd1xN2SL4s0KxaBctSygns6O/DTu03m+rAEqyC1VkIoUkSqLvHgDIZECxmTZ7nLF8jLVdAGNBCoivkbuWXuT2jA89utigmP3KR3UdIL1ijRneXcYAmcqTixVpvDMIZjk4fJcU7lNH/xrJ34yMpSEEE95Nv8y7acZItt8SsS4Xhw5RG0M+TpdlMpIXeJ01+u3JPVKLP3/YB7HOk8bsGxwkyaCB6gfW2vTRDbGeCx9fTzn1mZUpkPG3+UEE3EEd1zra+S+vNlGW9iicbRB14s6nDIhgvvZ2QHn1YKenRbEG+hQPyiOrepL+HVVPtoUYEhw+qn6Br8Dvy+y6kVKIWTrrbDtomx0a6J3iFJotPhXny3w3xzJhdK45BFOWz323GfdUJpdDhwZFBzuW8ama5lpWBwOpDtW+XQr3abf04UiNGzD2uK6McJXBGh1/CBeWpPW+sEitCOSuoAyvA7LnSEckl6uxcUXPQvp4HFCvuISgg0ZGdm4I2tifer98OdIlof7dZZS
 /I1kwyOO
 noE48kdfOia5egqcZrwuYQlgG03XqSzB0vmsc7wyNXHNOtGTgWKxidB3d6YeRaqnph2TktdkkwFua2EzJM3Krij7c2ES60gPij3C7YiNNWrcvHOabi1I4wblGayRV+NxusylcYUdE0bQRLsH4UvLnpK6GzTvgGtQNsTOsOB7dilvjwn85QXHYCY3ddu2iqbEv8/T0i96zCQMW3Y6QABLIFmKFbi/JpHKZrNdjKPL+FHQMDzdtJoZSkyGY9IHXHQ2BNNuiJJOoO1VAW2Fc3Vh9dOkSLPP0HqVMvYBI8h0aouI63ZclIaP85and18Dhl1C2cD1MCjiyT+K3B1bDKuB6K1ouIpaO1tSfaqF4xAHMHxoHVl//MAbOkQTXDHepN8Y8J+z+GYDFPc5/JDhQis5LJBSavS2evmZkn8i86eHsw0dDW4DW3vR9N4gmpvPTFw4uUIdB2RVNSpTn4OyOSZQm1wYJO+LpMpbVMqynoviBqDbkqlIwTkQ6p8jUFc7EXlZAO0Dca6XfbUOGg62OHxZ/fwgvLUbNV4zcjbD8nVrwV59OiIVoilCAE3GwTJlqO2cIz0ihjxHTuYcY401dD/T3nBduZQWAyXuAN8sr6GEwyo+uApKj2y5ghdqj0fPD+rrMholn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When PCI hardware events occur (such as clearing PCI_COMMAND_MEMORY,
entering low-power D3, bus resets, or function-level resets), physical
BAR access is invalidated.

In vfio_pci_zap_bars(), if guest_memfd memory was marked available,
mark the BARs unavailable and invoke vfio_device_gmem_revoke() for each
mappable standard PCI BAR to revoke host userspace mappings and guest
stage-2 SPTEs before hardware state is modified.

When memory decoding is subsequently re-enabled and power state is
restored to D0 under the device memory lock, mark BARs available again
so future guest_memfd faults can proceed.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/pci/vfio_pci_config.c | 16 ++++++++++----
 drivers/vfio/pci/vfio_pci_core.c   | 44 ++++++++++++++++++++++++++++++--------
 include/linux/vfio_pci_core.h      | 22 +++++++++++++++++++
 3 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/drivers/vfio/pci/vfio_pci_config.c b/drivers/vfio/pci/vfio_pci_config.c
index 9914f3ac69aef..fae3980fb8d9c 100644
--- a/drivers/vfio/pci/vfio_pci_config.c
+++ b/drivers/vfio/pci/vfio_pci_config.c
@@ -630,8 +630,10 @@ static int vfio_basic_config_write(struct vfio_pci_core_device *vdev, int pos,
 		*virt_cmd &= cpu_to_le16(~mask);
 		*virt_cmd |= cpu_to_le16(new_cmd & mask);
 
-		if (__vfio_pci_memory_enabled(vdev))
+		if (__vfio_pci_memory_enabled(vdev)) {
 			vfio_pci_dma_buf_move(vdev, false);
+			vfio_pci_set_bars_available(vdev, true);
+		}
 		up_write(&vdev->memory_lock);
 	}
 
@@ -720,8 +722,10 @@ static void vfio_lock_and_set_power_state(struct vfio_pci_core_device *vdev,
 	}
 
 	vfio_pci_set_power_state(vdev, state);
-	if (__vfio_pci_memory_enabled(vdev))
+	if (__vfio_pci_memory_enabled(vdev)) {
 		vfio_pci_dma_buf_move(vdev, false);
+		vfio_pci_set_bars_available(vdev, true);
+	}
 	up_write(&vdev->memory_lock);
 }
 
@@ -911,8 +915,10 @@ static int vfio_exp_config_write(struct vfio_pci_core_device *vdev, int pos,
 			vfio_pci_zap_and_down_write_memory_lock(vdev);
 			vfio_pci_dma_buf_move(vdev, true);
 			pci_try_reset_function(vdev->pdev);
-			if (__vfio_pci_memory_enabled(vdev))
+			if (__vfio_pci_memory_enabled(vdev)) {
 				vfio_pci_dma_buf_move(vdev, false);
+				vfio_pci_set_bars_available(vdev, true);
+			}
 			up_write(&vdev->memory_lock);
 		}
 	}
@@ -996,8 +1002,10 @@ static int vfio_af_config_write(struct vfio_pci_core_device *vdev, int pos,
 			vfio_pci_zap_and_down_write_memory_lock(vdev);
 			vfio_pci_dma_buf_move(vdev, true);
 			pci_try_reset_function(vdev->pdev);
-			if (__vfio_pci_memory_enabled(vdev))
+			if (__vfio_pci_memory_enabled(vdev)) {
 				vfio_pci_dma_buf_move(vdev, false);
+				vfio_pci_set_bars_available(vdev, true);
+			}
 			up_write(&vdev->memory_lock);
 		}
 	}
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 894b1332f8a0c..2b29d0ec6a0c9 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -464,8 +464,10 @@ static void vfio_pci_runtime_pm_exit(struct vfio_pci_core_device *vdev)
 	 */
 	down_write(&vdev->memory_lock);
 	__vfio_pci_runtime_pm_exit(vdev);
-	if (__vfio_pci_memory_enabled(vdev))
+	if (__vfio_pci_memory_enabled(vdev)) {
 		vfio_pci_dma_buf_move(vdev, false);
+		vfio_pci_set_bars_available(vdev, true);
+	}
 	up_write(&vdev->memory_lock);
 }
 
@@ -1337,8 +1339,10 @@ static int vfio_pci_ioctl_reset(struct vfio_pci_core_device *vdev,
 
 	vfio_pci_dma_buf_move(vdev, true);
 	ret = pci_try_reset_function(vdev->pdev);
-	if (__vfio_pci_memory_enabled(vdev))
+	if (__vfio_pci_memory_enabled(vdev)) {
 		vfio_pci_dma_buf_move(vdev, false);
+		vfio_pci_set_bars_available(vdev, true);
+	}
 	up_write(&vdev->memory_lock);
 
 	return ret;
@@ -1727,8 +1731,31 @@ static void vfio_pci_zap_bars(struct vfio_pci_core_device *vdev)
 	loff_t start = VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_BAR0_REGION_INDEX);
 	loff_t end = VFIO_PCI_INDEX_TO_OFFSET(VFIO_PCI_ROM_REGION_INDEX);
 	loff_t len = end - start;
+	int i;
 
 	unmap_mapping_range(core_vdev->inode->i_mapping, start, len, true);
+
+#ifdef CONFIG_KVM_GUEST_MEMFD
+	if (vfio_pci_get_bars_available(vdev)) {
+		vfio_pci_set_bars_available(vdev, false);
+
+		for (i = 0; i < PCI_STD_NUM_BARS; i++) {
+			pgoff_t gmem_start;
+			unsigned long pfn;
+			size_t nr_pages;
+
+			if (!vdev->bar_mmap_supported[i])
+				continue;
+
+			gmem_start = VFIO_PCI_INDEX_TO_OFFSET(i) >> PAGE_SHIFT;
+			nr_pages = pci_resource_len(vdev->pdev, i) >> PAGE_SHIFT;
+			pfn = pci_resource_start(vdev->pdev, i) >> PAGE_SHIFT;
+
+			vfio_device_gmem_revoke(&vdev->vdev, gmem_start,
+						nr_pages, &pfn);
+		}
+	}
+#endif
 }
 
 void vfio_pci_zap_and_down_write_memory_lock(struct vfio_pci_core_device *vdev)
@@ -2621,8 +2648,10 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
 err_undo:
 	list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
 					 vdev.dev_set_list) {
-		if (vdev->vdev.open_count && __vfio_pci_memory_enabled(vdev))
+		if (vdev->vdev.open_count && __vfio_pci_memory_enabled(vdev)) {
 			vfio_pci_dma_buf_move(vdev, false);
+			vfio_pci_set_bars_available(vdev, true);
+		}
 		up_write(&vdev->memory_lock);
 	}
 
@@ -2709,9 +2738,7 @@ int vfio_pci_core_gmem_attach(struct vfio_device *core_vdev)
 
 	bars_available = __vfio_pci_memory_enabled(vdev) &&
 			 !vdev->pm_runtime_engaged;
-
-	/* Pairs with smp_load_acquire() in provider operations */
-	smp_store_release(&vdev->bars_available, bars_available);
+	vfio_pci_set_bars_available(vdev, bars_available);
 
 	up_write(&vdev->memory_lock);
 
@@ -2726,8 +2753,7 @@ void vfio_pci_core_gmem_release(struct vfio_device *core_vdev)
 
 	down_write(&vdev->memory_lock);
 
-	/* Pairs with smp_load_acquire() in provider operations */
-	smp_store_release(&vdev->bars_available, false);
+	vfio_pci_set_bars_available(vdev, false);
 
 	up_write(&vdev->memory_lock);
 }
@@ -2747,7 +2773,7 @@ int vfio_pci_core_gmem_get_pfn(struct vfio_device *core_vdev, pgoff_t index,
 	 * Lockless check: if memory decoding is disabled or the device is in
 	 * low-power D3, fail immediately without blocking on memory_lock.
 	 */
-	if (!smp_load_acquire(&vdev->bars_available))
+	if (!vfio_pci_get_bars_available(vdev))
 		return -EFAULT;
 
 	bar = index >> (VFIO_PCI_OFFSET_SHIFT - PAGE_SHIFT);
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 6ff67e38eaf84..af74766d7c90a 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -178,6 +178,28 @@ int vfio_pci_core_gmem_get_pfn(struct vfio_device *core_vdev, pgoff_t index,
 int vfio_pci_core_gmem_check_set_attributes(struct vfio_device *core_vdev,
 					    pgoff_t index, size_t nr_pages,
 					    u64 attributes);
+static inline void vfio_pci_set_bars_available(struct vfio_pci_core_device *vdev,
+					       bool available)
+{
+	/* Pairs with smp_load_acquire() in provider operations */
+	smp_store_release(&vdev->bars_available, available);
+}
+
+static inline bool vfio_pci_get_bars_available(struct vfio_pci_core_device *vdev)
+{
+	/* Pairs with smp_store_release() under memory_lock */
+	return smp_load_acquire(&vdev->bars_available);
+}
+#else
+static inline void vfio_pci_set_bars_available(struct vfio_pci_core_device *vdev,
+					       bool available)
+{
+}
+
+static inline bool vfio_pci_get_bars_available(struct vfio_pci_core_device *vdev)
+{
+	return false;
+}
 #endif
 extern const struct pci_error_handlers vfio_pci_core_err_handlers;
 int vfio_pci_core_sriov_configure(struct vfio_pci_core_device *vdev,

-- 
2.56.0.455.g6c5a503b38-goog



