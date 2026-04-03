Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71FEFCC6B3E
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 00:52:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB9486B008C; Thu,  2 Apr 2026 20:52:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69B56B0092; Thu,  2 Apr 2026 20:52:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C59276B0093; Thu,  2 Apr 2026 20:52:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B422E6B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 20:52:08 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BCC01A0276
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:52:08 +0000 (UTC)
X-FDA: 84615417936.05.8A9D23D
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6C96B80004
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 00:52:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DqMM7NSa;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.173 as permitted sender) smtp.mailfrom=dianders@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775177526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VEt3hSd9EKLTT0Wo55fxgtHBJYKHT3uVPRy+V8bzYNY=;
	b=Ek8N9Ku+Bu8zK0CPDHOi49IZVGeZm1QCVd9Ni6EvgKBfR84SzWkfaoDYHZcf327b6yZS39
	nsaxWyFJyriEFHH4DuWJOcdemAvBopBmIVK/j17X5sugSRF9oIH+piTHMIsOXQWr3tyugl
	yVTYcuKeLJI7aoGRoSnI94TosBnEEko=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775177526; a=rsa-sha256;
	cv=none;
	b=8SCAagmO826HGpWNApdSyOQNUwyPCVL82z+pBmmp3Wm+DmXGuipcM5sjkSJqqgL2Fm8ReN
	jvfSP/PkZw/IQ9wYS/+1y1w7gGUlQo81/U1t9ysi7PZ6fbeNDhKGhEGlnPAKyRVNtSmQK8
	fZ0/Gvg1NbX2s+OCiyVCAUC0X7p8Nhc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=DqMM7NSa;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf02.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.173 as permitted sender) smtp.mailfrom=dianders@chromium.org
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2bdd40d3c61so1322704eec.1
        for <linux-mm@kvack.org>; Thu, 02 Apr 2026 17:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1775177525; x=1775782325; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VEt3hSd9EKLTT0Wo55fxgtHBJYKHT3uVPRy+V8bzYNY=;
        b=DqMM7NSaFy3NRqG+4vT72k4JtmPoLlp1I4PSUmbtayNqlzNcgHCWkpKM57ObeiQo4Z
         +oQKIjLZe01F256CMvN5jBi7V01sR5o1mqLHH23FgXHY0wjCmNAMmKnAs3xG5uqe1QYg
         umXoCo+2eDz3iVDHI+02fSELf8W6OnVEJQZDo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775177525; x=1775782325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VEt3hSd9EKLTT0Wo55fxgtHBJYKHT3uVPRy+V8bzYNY=;
        b=UoaKiw3W/GaWmXyE3wsXxvJAUVP/mL/9VfFqVuly6kyKNVeP6PssIyfHrIdoJfOAl3
         yzoxYy5Kd01elTRuSByD1GGJjpiav/mDov0Q4ChaHhOiSeoC7OUhhyjG0qy5ziJohckp
         8fQsrQMKjbMUxNr/0/WN69+TQtsfva6QQjLudnv1M2a7WmFj5Ka94aYyx/kIlUwVx+KL
         Q55yUeaghoxnsXT6DTW1blkIFDIXQi/YTy6Gk1GL4jTpDfDMsGJd15Kne6eukQt8rhgJ
         xYAnwBcSQsiztoD2CqAQl4wqMtVWOh9ganwWFr++O1rJJRa7MG186GOLqzxmoQE5zMq7
         rJsg==
X-Forwarded-Encrypted: i=1; AJvYcCW8bMSpCNAWHALydU+BcLbQ35ChF0HuH6RqKqIXxKXs/tVz7Yp8HwBj0e0LAjfUXSisTyJjVbC6Xg==@kvack.org
X-Gm-Message-State: AOJu0YzNMWrxkdxJ9Yd80IZgrM6MNw6IrITjFl2sDNs7ceaNsYmWhZ2z
	+obnQdLiHVv6vGtbRGXozfIoefD6sScWc5B2h5b2C9d4hianzHz1kNAE/QumfnBLEg==
X-Gm-Gg: ATEYQzzMj1dDH37zIFYQo5AZmSi60lfEy/UIz+6uYLpsJut2CVkVNBgk3o9sTmoUZEj
	TczNEbgItXtd4f47Bu+QnFkhP62QmkxdNgHlKNVS4hjeOX33ZssJQp3OuMbZzs8gCb9KF539oYb
	x4jaCfUxgliQnfYLzQB+T7PMKcSxbRbsxjr5bI5tdI3rxe1a5nUPrJ934mj0RGrQm1+ykfZcjWT
	/N2gkvj9eWnkiRlu3GBWbF9oQvw3PMUOt3LHvNFXRo3CG1xS0Dn8O1ZI3Vk+TKhycpztWzX93K6
	M1z9FoUwSDU99u8VHkQVGVN6fGNjwTa4anLmwRt6RvHYK1yk4qIcCYdk1fiE0k2KpWiGIZfEJaP
	7EhNdtf/hMfncaF9+BSYyQlBrGp8z4iD9PcpKkRVAvywOH1YcDMYN4+c1QdE0seAFEKB+/UFsgO
	B4JG/GRIToiYJ6YUCIAcQmg3jjfIW+2YgzShW1C7PKUJekMTn/RHI4xROWaPLp+M6FhoLaLl9xm
	Wt5Rr8wlt4=
X-Received: by 2002:a05:7022:423:b0:119:e56b:91ec with SMTP id a92af1059eb24-12bfb75ee38mr560487c88.29.1775177525063;
        Thu, 02 Apr 2026 17:52:05 -0700 (PDT)
Received: from dianders.sjc.corp.google.com ([2a00:79e0:2e7c:8:5db3:7542:a530:f43a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca78df3b84sm3630074eec.5.2026.04.02.17.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2026 17:52:04 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Leon Romanovsky <leon@kernel.org>,
	Paul Burton <paul.burton@mips.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Toshi Kani <toshi.kani@hp.com>,
	Christoph Hellwig <hch@lst.de>,
	Alexey Kardashevskiy <aik@ozlabs.ru>,
	Johan Hovold <johan@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	ardb@kernel.org,
	broonie@kernel.org,
	catalin.marinas@arm.com,
	chleroy@kernel.org,
	david@kernel.org,
	driver-core@lists.linux.dev,
	kees@kernel.org,
	kevin.brodsky@arm.com,
	lenb@kernel.org,
	linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	maz@kernel.org,
	miko.lenczewski@arm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	osalvador@suse.de,
	oupton@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	will@kernel.org,
	yangyicong@hisilicon.com,
	yeoreum.yun@arm.com
Subject: [PATCH v3 9/9] driver core: Replace dev->offline + ->offline_disabled with DEV_FLAGs
Date: Thu,  2 Apr 2026 17:49:55 -0700
Message-ID: <20260402174925.v3.9.I897d478b4a9361d79cd5073207c1062fd4d0d0e4@changeid>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260403005005.30424-1-dianders@chromium.org>
References: <20260403005005.30424-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6C96B80004
X-Stat-Signature: r4k8jokejzw8okkrrdzpxh5yaqcobbrr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775177526-514827
X-HE-Meta: U2FsdGVkX1/sUgRsAxH5Tu7nyQFfQ/YxY/F8kphBBq5hJxw25mecqqDr8Ya5V+Qx4q197bY0abcC4+eCRnfKbbxXVOui2KkPtYyaWN1jgrwCjhuCXeWW/yeXgnjDtcXROMXjez/Uh5NLp+iBNk3iSoo6AGIRyVo+ahoi6eSHsZrKtOk+KeQVBn0O3hMBYVJ1+zGysJ49ytO6bxC4nvXQcBOCt6ugjIOLazZuneI/RlxWedrOgx7F/7x5tB4xm4CvjXPs0TPvnPg8BgnAUkx+sst5FPQFfMt3mAzPplyMAW6Kn+K0kczSq9RPq8SmgoHB+UUoiN8DhNhtzIB2cbWorPLgk7mPAOM1QcF5MZhwDqHSIfuU1qyPpZ+GKJ/UZbQrWBYG69Yc1f2upy19LjnGv4RnosT3lzf1ohi5G+KsdyQLO6+nBAdDkfv61t16Mqt8+qVqa+azbTpZMhUmQuqjkKomEktUiW+bWFw0MGEZBha5AvpC97ebF2xwMXGuet2GuL75AGUY00Mlz5tPfnkzfiGVswXFJN2oDw+xelj7LOpUnihpQV8yJQuaEMcnSlZY7hOymIXK3tyab+PI25uZDF+vmsMCeqICJD1BhbMXIfoLvpzkNO0u6CA0bB3sNNh73IEKp6gWYVUGTMpd28lKX20d2YJmPHPYbcphjtLL2AwnVN6rCg3XX6wNgwYQQ/zwm6E9q+QVzTSlq+zuqEVCJSAfd3InAV8wLy3s7HQw0vMKKy+UgH2MbkjXzguZ02YEdrGJobsrYNGDCytIH+rkSpv3LY0osvMepmmEy/7uyrd/1F/Ntu/cv/gFWGy5PIGkxij3I6BqMEzhh5otQLjVLpa7E4lThUUEjSfO8sgyEoP3VqaHNJf4rTihtD2F1b7GuRjIVhp8I1c/5cV2i2AUnKnjrNmOwjx6nzhCcFNhIICuu8SiwNwOUedj0TO3oDCnR6nadCPp9wem71FmM5S
 hzssnn/l
 Nme7QU2a7JFXdYTl/yOqd+D5361TDhFQJqQKtK8sX06j62/WD5XwGc9XuOdC6caqrxwl0lVLM8gtzmUeCBRqqUZgnkvJIDKCwzevcXXSjYf51IRIQY9J1keT7Xt8CK+F5Xfmmm8tWD2m5Oth89hg3m2zkarHKRrSee/9PDvaUnos7ssJrYaxIEW+6uzKoHElbJPTslgYTm9qtlrm8OqPXNkJIN48vtlcvHpr1mukFLWl+ue2WCgzkQOBczTJnDDO/nHSucCcqKI2GgtjIc1MRTJh8OGXXA82s4t6mwl+zXa5a0D6PnBUp4qfoBJL8JKvyQ27BMtOvkGC1Hugm+H3yBBN5PzrsSaEicTtoiu8d28PIr2dLKvcubujWiqFtNjtwuet/UPvH7df3fsaGddNR+G8YzxqVnqWBBL8kLAhTvnF5tSzcbLU04F9UVngN8svLW1Q6aanudK49FbCZmD2UjYP0n95xSkDKyUva
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In C, bitfields are not necessarily safe to modify from multiple
threads without locking. Switch "offline" and "offline_disabled" over
to the "flags" field so modifications are safe.

Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Toshi Kani <toshi.kani@hp.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
Not fixing any known bugs; problem is theoretical and found by code
inspection. Change is done somewhat manually and only lightly tested
(mostly compile-time tested).

Changes in v3:
- New

 arch/arm64/kernel/cpufeature.c                |  2 +-
 .../platforms/pseries/hotplug-memory.c        |  4 ++--
 drivers/acpi/scan.c                           |  3 ++-
 drivers/base/core.c                           | 19 ++++++++++---------
 drivers/base/cpu.c                            |  4 ++--
 drivers/base/memory.c                         |  2 +-
 include/linux/device.h                        |  9 ++++-----
 kernel/cpu.c                                  |  4 ++--
 8 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 32c2dbcc0c64..f6f7c35b7a93 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -4042,7 +4042,7 @@ static int enable_mismatched_32bit_el0(unsigned int cpu)
 	 */
 	lucky_winner = cpu_32bit ? cpu : cpumask_any_and(cpu_32bit_el0_mask,
 							 cpu_active_mask);
-	get_cpu_device(lucky_winner)->offline_disabled = true;
+	set_bit(DEV_FLAG_OFFLINE_DISABLED, &get_cpu_device(lucky_winner)->flags);
 	setup_elf_hwcaps(compat_elf_hwcaps);
 	elf_hwcap_fixup();
 	pr_info("Asymmetric 32-bit EL0 support detected on CPU %u; CPU hot-unplug disabled on CPU %u\n",
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index b2f14db59034..d9a0a75ada46 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -213,9 +213,9 @@ static int dlpar_change_lmb_state(struct drmem_lmb *lmb, bool online)
 		return -EINVAL;
 	}
 
-	if (online && mem_block->dev.offline)
+	if (online && test_bit(DEV_FLAG_OFFLINE, &mem_block->dev.flags))
 		rc = device_online(&mem_block->dev);
-	else if (!online && !mem_block->dev.offline)
+	else if (!online && !test_bit(DEV_FLAG_OFFLINE, &mem_block->dev.flags))
 		rc = device_offline(&mem_block->dev);
 	else
 		rc = 0;
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index e8cdbdb46fdb..f2707b704468 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -122,7 +122,8 @@ bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent)
 	mutex_lock_nested(&adev->physical_node_lock, SINGLE_DEPTH_NESTING);
 
 	list_for_each_entry(pn, &adev->physical_node_list, node)
-		if (device_supports_offline(pn->dev) && !pn->dev->offline) {
+		if (device_supports_offline(pn->dev) &&
+		    !test_bit(DEV_FLAG_OFFLINE, &pn->dev->flags)) {
 			if (uevent)
 				kobject_uevent_env(&pn->dev->kobj, KOBJ_CHANGE, envp);
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index a87bd40499b6..63d724ece384 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2789,7 +2789,7 @@ static ssize_t online_show(struct device *dev, struct device_attribute *attr,
 	bool val;
 
 	device_lock(dev);
-	val = !dev->offline;
+	val = !test_bit(DEV_FLAG_OFFLINE, &dev->flags);
 	device_unlock(dev);
 	return sysfs_emit(buf, "%u\n", val);
 }
@@ -2914,7 +2914,7 @@ static int device_add_attrs(struct device *dev)
 	if (error)
 		goto err_remove_type_groups;
 
-	if (device_supports_offline(dev) && !dev->offline_disabled) {
+	if (device_supports_offline(dev) && !test_bit(DEV_FLAG_OFFLINE_DISABLED, &dev->flags)) {
 		error = device_create_file(dev, &dev_attr_online);
 		if (error)
 			goto err_remove_dev_groups;
@@ -4179,7 +4179,8 @@ static int device_check_offline(struct device *dev, void *not_used)
 	if (ret)
 		return ret;
 
-	return device_supports_offline(dev) && !dev->offline ? -EBUSY : 0;
+	return device_supports_offline(dev) &&
+	       !test_bit(DEV_FLAG_OFFLINE, &dev->flags) ? -EBUSY : 0;
 }
 
 /**
@@ -4197,7 +4198,7 @@ int device_offline(struct device *dev)
 {
 	int ret;
 
-	if (dev->offline_disabled)
+	if (test_bit(DEV_FLAG_OFFLINE_DISABLED, &dev->flags))
 		return -EPERM;
 
 	ret = device_for_each_child(dev, NULL, device_check_offline);
@@ -4206,13 +4207,13 @@ int device_offline(struct device *dev)
 
 	device_lock(dev);
 	if (device_supports_offline(dev)) {
-		if (dev->offline) {
+		if (test_bit(DEV_FLAG_OFFLINE, &dev->flags)) {
 			ret = 1;
 		} else {
 			ret = dev->bus->offline(dev);
 			if (!ret) {
 				kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
-				dev->offline = true;
+				set_bit(DEV_FLAG_OFFLINE, &dev->flags);
 			}
 		}
 	}
@@ -4237,11 +4238,11 @@ int device_online(struct device *dev)
 
 	device_lock(dev);
 	if (device_supports_offline(dev)) {
-		if (dev->offline) {
+		if (test_bit(DEV_FLAG_OFFLINE, &dev->flags)) {
 			ret = dev->bus->online(dev);
 			if (!ret) {
 				kobject_uevent(&dev->kobj, KOBJ_ONLINE);
-				dev->offline = false;
+				clear_bit(DEV_FLAG_OFFLINE, &dev->flags);
 			}
 		} else {
 			ret = 1;
@@ -4715,7 +4716,7 @@ static int device_attrs_change_owner(struct device *dev, kuid_t kuid,
 	if (error)
 		return error;
 
-	if (device_supports_offline(dev) && !dev->offline_disabled) {
+	if (device_supports_offline(dev) && !test_bit(DEV_FLAG_OFFLINE_DISABLED, &dev->flags)) {
 		/* Change online device attributes of @dev to @kuid/@kgid. */
 		error = sysfs_file_change_owner(kobj, dev_attr_online.attr.name,
 						kuid, kgid);
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 875abdc9942e..e4e6a399def4 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -422,8 +422,8 @@ int register_cpu(struct cpu *cpu, int num)
 	cpu->dev.id = num;
 	cpu->dev.bus = &cpu_subsys;
 	cpu->dev.release = cpu_device_release;
-	cpu->dev.offline_disabled = !cpu->hotpluggable;
-	cpu->dev.offline = !cpu_online(num);
+	assign_bit(DEV_FLAG_OFFLINE_DISABLED, &cpu->dev.flags, !cpu->hotpluggable);
+	assign_bit(DEV_FLAG_OFFLINE, &cpu->dev.flags, !cpu_online(num));
 	cpu->dev.of_node = of_get_cpu_node(num, NULL);
 	cpu->dev.groups = common_cpu_attr_groups;
 	if (cpu->hotpluggable)
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index a3091924918b..7f42727dde81 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -697,7 +697,7 @@ static int __add_memory_block(struct memory_block *memory)
 	memory->dev.id = memory->start_section_nr / sections_per_block;
 	memory->dev.release = memory_block_release;
 	memory->dev.groups = memory_memblk_attr_groups;
-	memory->dev.offline = memory->state == MEM_OFFLINE;
+	assign_bit(DEV_FLAG_OFFLINE, &memory->dev.flags, memory->state == MEM_OFFLINE);
 
 	ret = device_register(&memory->dev);
 	if (ret) {
diff --git a/include/linux/device.h b/include/linux/device.h
index f6ca067bacca..fd53aa04cad9 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -484,6 +484,8 @@ struct device_physical_location {
  *		architecture supports non-coherent devices.
  * @DEV_FLAG_OF_NODE_REUSED: Set if the device-tree node is shared with an
  *		ancestor device.
+ * @DEV_FLAG_OFFLINE_DISABLED: If set, the device is permanently online.
+ * @DEV_FLAG_OFFLINE: Set after successful invocation of bus type's .offline().
  */
 enum struct_device_flags {
 	DEV_FLAG_READY_TO_PROBE,
@@ -494,6 +496,8 @@ enum struct_device_flags {
 	DEV_FLAG_STATE_SYNCED,
 	DEV_FLAG_DMA_COHERENT,
 	DEV_FLAG_OF_NODE_REUSED,
+	DEV_FLAG_OFFLINE_DISABLED,
+	DEV_FLAG_OFFLINE,
 };
 
 /**
@@ -571,8 +575,6 @@ enum struct_device_flags {
  *              should be set by the subsystem / bus driver that discovered
  *              the device.
  *
- * @offline_disabled: If set, the device is permanently online.
- * @offline:	Set after successful invocation of bus type's .offline().
  * @flags:	DEV_FLAG_XXX flags. Use atomic bitfield operations to modify.
  *
  * At the lowest level, every device in a Linux system is represented by an
@@ -677,9 +679,6 @@ struct device {
 
 	enum device_removable	removable;
 
-	bool			offline_disabled:1;
-	bool			offline:1;
-
 	unsigned long		flags;
 };
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index bc4f7a9ba64e..15a873ad8025 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2639,7 +2639,7 @@ static void cpuhp_offline_cpu_device(unsigned int cpu)
 {
 	struct device *dev = get_cpu_device(cpu);
 
-	dev->offline = true;
+	set_bit(DEV_FLAG_OFFLINE, &dev->flags);
 	/* Tell user space about the state change */
 	kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
 }
@@ -2648,7 +2648,7 @@ static void cpuhp_online_cpu_device(unsigned int cpu)
 {
 	struct device *dev = get_cpu_device(cpu);
 
-	dev->offline = false;
+	clear_bit(DEV_FLAG_OFFLINE, &dev->flags);
 	/* Tell user space about the state change */
 	kobject_uevent(&dev->kobj, KOBJ_ONLINE);
 }
-- 
2.53.0.1213.gd9a14994de-goog


