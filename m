Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ACDAFB517B
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 23:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 241836B008A; Mon,  6 Apr 2026 19:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 218706B008C; Mon,  6 Apr 2026 19:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E8D6B0092; Mon,  6 Apr 2026 19:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 05A2E6B008A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:25:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C62A160547
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:25:53 +0000 (UTC)
X-FDA: 84629715786.04.BD2C882
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf03.hostedemail.com (Postfix) with ESMTP id BB3092000C
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 23:25:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=L5iph+iN;
	spf=pass (imf03.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.175 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=L5iph+iN;
	spf=pass (imf03.hostedemail.com: domain of dianders@chromium.org designates 74.125.82.175 as permitted sender) smtp.mailfrom=dianders@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775517951; a=rsa-sha256;
	cv=none;
	b=IfCH9dIJCWapgxU1VP9nU/2W3ymzeiCl70MH3qMoDGYJgOUW3O/J1UU7GLY2bYhhndtlXy
	AsiD8MsOf/i8bq6mVbvegqzuXOjG/hKZaENFhCz8jh+b9DIAEAJqwfuk2Y0Sd18LtINoFQ
	Cl3HyMz1ktVhFP/G5v1iWMQGyxHX0l8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775517951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7fxdjSi9+RKgdFwjeRu5DfLfM5rFKPeYpJSBLh/9No=;
	b=vpwTks7L8KcNiuBGN9iUe9NfuXP8bzsMKyl2Kb/wOevz6dFtQeyHdkJsMS+r7k5HNyyb/z
	ALMdwWgfF0AoekyfKnv6Ig5WzrB/C+qYeMA8pEy0I3Kqym606/IjoxP8EpM8Adm91KAXtj
	iN2O5ymJ0XEFjMjiaL+lYYm+SvS8vgs=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2c56aa62931so9459816eec.0
        for <linux-mm@kvack.org>; Mon, 06 Apr 2026 16:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1775517950; x=1776122750; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+7fxdjSi9+RKgdFwjeRu5DfLfM5rFKPeYpJSBLh/9No=;
        b=L5iph+iNhS8fM10HejkKEY29GjwTKj4pI80t8Jes9hMjv8YNIUJsMfv4zM2M0wk6jD
         maUXDb/Mc4i0LPmPYFHvWtxPbEbJMLgeP0JPx3HZ7MF/M9c7Jatc/qQU/c+XFaP/oS4M
         xztyeOPORlA1RYMQff5zfLhbN7k1i3dsYoeAk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775517950; x=1776122750;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+7fxdjSi9+RKgdFwjeRu5DfLfM5rFKPeYpJSBLh/9No=;
        b=ravh8qwiaIpZsAFbrAjvLtOhODN2CORsFSaYfX0TYMvl/Z00nfXAVkLyv00ti2V7m+
         RhergHrxpuSpgS0NBsOC5oXNtj3+jCF1UG5PmVat64AKGF0JSw2fBL3lxSV+2Z/PZzhY
         q2pCHghfcd3ISFZNSBHhpTzdGzn5Zdw7UcAK/+SfIsqQVJXyY8bHRjBILgEIGRhXzd3h
         Ym9YElUPoRl5XxTr31y2+IYov+B4cE/i8jCw+VXRcpaiXKYahmtLd7nL9fMrjp6TNjeC
         JAAu3PjySjGneE1javbkOWsrUvSknndIc93T/PYLzlSI9oxzW1UPZNoVV5oQThrEo0Y6
         bSfg==
X-Forwarded-Encrypted: i=1; AJvYcCXExqTz+cIwoBpDa7X6GEwpYbCOpqEPpcIycFmWsQ6Wbn3hHPm4rn7ekQBlimH1cOvNUrvsLpaXlg==@kvack.org
X-Gm-Message-State: AOJu0YyT5EtDvtlj0iok6mQCoHxVIdLNYNzDhsvEeQurAsBxa9ZVahfi
	7SwnEqPMsSliwG0CFAoToXi7G9rwh+LH1VAd0A0dSKM6bvXUhgYGMmyKLxJX7AtloA==
X-Gm-Gg: AeBDiesWru/von4VdHQthG1CbVg7JhmrO7IZgKTFTrcHpkBZIocY5nsSBFiQk5TR1hZ
	gBkpzpvg/al7ANfuYBUSFaZ6VaVRJaVV7KzAX+IGn/5fVdpeGFOuPEqDreGYmUoC2L15pm2nE9E
	Q4kjpdMVuJc8hcbC09+2zkH4g8De14RZSHIpBouMiXZh5yjk5OC4dupHtKEeExAE1Q/BEi1CQHC
	zjrCCJvog9NapGnv1Obb+R6ZY6MVfy16PkiaqA4dHRuI4oQtThAWMttTFeRbLmVe+tyMa3Uqcwo
	4GgFfL1x7ZYH/syB8XrL4p03Onei34ODyAqLG8mBTwC5Ef7VCfLZxImBOWDK4ByyWverBwaiGdU
	zEWx6k5FQZY1QJquCrFo3cxHSqPF6pa4wAc56YD3eS9GbP9oA6L5emXw0yy5SSa0JK9VeQChd1v
	BRyqvLXYVqQ9MjhFttuXJuRuQn2n+x6qfosxc8gYCH1nO122kjse/I7Y9uHL2S+dq1BfKCsNQzl
	CCW+P73WQ==
X-Received: by 2002:a05:7301:434b:b0:2c8:6361:ab38 with SMTP id 5a478bee46e88-2cbfa5c1258mr7548017eec.15.1775517950390;
        Mon, 06 Apr 2026 16:25:50 -0700 (PDT)
Received: from dianders.sjc.corp.google.com ([2a00:79e0:2e7c:8:c071:3b78:5a5:824a])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2ca760b0518sm14730975eec.0.2026.04.06.16.25.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2026 16:25:49 -0700 (PDT)
From: Douglas Anderson <dianders@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alan Stern <stern@rowland.harvard.edu>
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
	Johan Hovold <johan@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Robin Murphy <robin.murphy@arm.com>,
	maz@kernel.org,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Douglas Anderson <dianders@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	ardb@kernel.org,
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
Subject: [PATCH v5 9/9] driver core: Replace dev->offline + ->offline_disabled with accessors
Date: Mon,  6 Apr 2026 16:23:02 -0700
Message-ID: <20260406162231.v5.9.I897d478b4a9361d79cd5073207c1062fd4d0d0e4@changeid>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
In-Reply-To: <20260406232444.3117516-1-dianders@chromium.org>
References: <20260406232444.3117516-1-dianders@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BB3092000C
X-Stat-Signature: 5x7q3ij34tjehf1fpje5dxfhktknzu1s
X-Rspam-User: 
X-HE-Tag: 1775517951-283031
X-HE-Meta: U2FsdGVkX19raxEgGVnWV1SH/nMFJ1X/YWsvFeDOzfAia8FPsp8hA52C9xLukCxeaG9CW2pEDzaXZQeqkn5LiovopsDMgR8iQEdoH2Mz9hgvT74BMgie1Jtc84bb9rMusm65gy2PolVypjhlGvQv3up1Kjcz/P9vNwiflfmJVnEFjCtxwDKwe4iII7c5dML8uoEiYNSURY4ASEn2vUYUSqU3/+7DNvzoLowDREYKHs3ydOJBrz+uDVw8PRin1Jzc0WSYnbug4ogOuNdEobJhjtkntFAyhklJmtIMNlJxrczNzJdy/OFiJTSXhXWuNL0dXuAv5iHsm34xkys5rUEHnE8dtYMcIIE+a073jeDgbIMX4yqoTXF6j4c2uMDlXOt4wPCL0yy0b11bKbY9z+gf7T843F3zfzhQ+BGyaeLhaL8b+kidx98bwHT+5mhh0YU1lBskBHu/Rjma2P3qjphvhrVn+gfXdW6iFN5l0+6PI5D1jFaL444qJCe2fALiYs5jlH67GcsmvkIHZmdipHlrAdORzO+hLQlKboGpsfSCzrzF76LBNM4aLH0rejvTjMKxz39d15yWcXkpA9je7VtXHaHPA3Bec1b+DZW57IwrvufbxHJScxWHUwY1j7nwvBDWOJOf/b4NajHRGmOLfHZID4/p6+plIuciw6tTp2VWvU52dms7ioDJ96QsxDPDVTZ1tz+03RgGuUdTPW6OqNPYH9eHnAqMk6svEMxCb5bDyQtnh1zDu/5Cj+RCtwIfcSGWycBl15NamQRrAtF0zkd7MKqmGGv2wdOLocFLXZqwmohpBN32Xx7IIkgAmHCjn9Z3bmWuiGnjprPC18rTHy9Y1Pq+Ngm9l7f1t8RPFBDcY3HVtqRJWs2sOhZRCm9drXQOWwxKBoA29AUCxWG38CwjbpWhDcsVXuLtLXcpo5kfg4m5iEZ/emDK9Cd9GCs6XBytI834ZLk3HIxcqel448E
 ObYH93VU
 3Vk5QAdpTQsAutNdldlKhEmgbKSRsJVrt4Mp2OxHTCvyMF8cNo3LbLqg3T+sNdpFdIn3cxvdxRjwoSOw2qt+QKhZ73NFkxeHVKS2RNEUriWILvqkKmcc8+YfXIV0U36mMORQTLEpmfUXGw/9m+URbFZqYCp9TlBGBlfC3hkGhp4sWX3LUa4pNWx7du14LGivB0QIS9zYsuOwo8L6UaLsC4bxOOjwBnE+RGE5ne6qgOJaS51Ya64AEHkj9CPJZjfrE+YmAkJ3+Zi0DYhvOLanzMSXlaP61fNMJ+onOpRFlW1Dt2bHYqJRX8F83uUfZ5NbM1iQ9O4tD8X2IejmBC5e6ibxOX+YLTKnhXLbeKZNyTDhjSN1V2AYH5E+Xypgbd5uUV/0y1mBtPV8l5OTv6KTeixsEuVXV5MplwylStw9BBGgIaxwpoZb53SInlvPO2ShXJIl9zhmBoC3b/pQ=
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
Acked-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
Reviewed-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
---
Not fixing any known bugs; problem is theoretical and found by code
inspection. Change is done somewhat manually and only lightly tested
(mostly compile-time tested).

(no changes since v4)

Changes in v4:
- Use accessor functions for flags

Changes in v3:
- New

 arch/arm64/kernel/cpufeature.c                 |  2 +-
 .../powerpc/platforms/pseries/hotplug-memory.c |  4 ++--
 drivers/acpi/scan.c                            |  2 +-
 drivers/base/core.c                            | 18 +++++++++---------
 drivers/base/cpu.c                             |  4 ++--
 drivers/base/memory.c                          |  2 +-
 include/linux/device.h                         | 12 ++++++------
 kernel/cpu.c                                   |  4 ++--
 8 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 32c2dbcc0c64..c832aa565dc2 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -4042,7 +4042,7 @@ static int enable_mismatched_32bit_el0(unsigned int cpu)
 	 */
 	lucky_winner = cpu_32bit ? cpu : cpumask_any_and(cpu_32bit_el0_mask,
 							 cpu_active_mask);
-	get_cpu_device(lucky_winner)->offline_disabled = true;
+	dev_set_offline_disabled(get_cpu_device(lucky_winner));
 	setup_elf_hwcaps(compat_elf_hwcaps);
 	elf_hwcap_fixup();
 	pr_info("Asymmetric 32-bit EL0 support detected on CPU %u; CPU hot-unplug disabled on CPU %u\n",
diff --git a/arch/powerpc/platforms/pseries/hotplug-memory.c b/arch/powerpc/platforms/pseries/hotplug-memory.c
index b2f14db59034..75f85a5da981 100644
--- a/arch/powerpc/platforms/pseries/hotplug-memory.c
+++ b/arch/powerpc/platforms/pseries/hotplug-memory.c
@@ -213,9 +213,9 @@ static int dlpar_change_lmb_state(struct drmem_lmb *lmb, bool online)
 		return -EINVAL;
 	}
 
-	if (online && mem_block->dev.offline)
+	if (online && dev_offline(&mem_block->dev))
 		rc = device_online(&mem_block->dev);
-	else if (!online && !mem_block->dev.offline)
+	else if (!online && !dev_offline(&mem_block->dev))
 		rc = device_offline(&mem_block->dev);
 	else
 		rc = 0;
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index e8cdbdb46fdb..1353adbcc234 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -122,7 +122,7 @@ bool acpi_scan_is_offline(struct acpi_device *adev, bool uevent)
 	mutex_lock_nested(&adev->physical_node_lock, SINGLE_DEPTH_NESTING);
 
 	list_for_each_entry(pn, &adev->physical_node_list, node)
-		if (device_supports_offline(pn->dev) && !pn->dev->offline) {
+		if (device_supports_offline(pn->dev) && !dev_offline(pn->dev)) {
 			if (uevent)
 				kobject_uevent_env(&pn->dev->kobj, KOBJ_CHANGE, envp);
 
diff --git a/drivers/base/core.c b/drivers/base/core.c
index 30825bf83234..4f293aed879a 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2788,7 +2788,7 @@ static ssize_t online_show(struct device *dev, struct device_attribute *attr,
 	bool val;
 
 	device_lock(dev);
-	val = !dev->offline;
+	val = !dev_offline(dev);
 	device_unlock(dev);
 	return sysfs_emit(buf, "%u\n", val);
 }
@@ -2913,7 +2913,7 @@ static int device_add_attrs(struct device *dev)
 	if (error)
 		goto err_remove_type_groups;
 
-	if (device_supports_offline(dev) && !dev->offline_disabled) {
+	if (device_supports_offline(dev) && !dev_offline_disabled(dev)) {
 		error = device_create_file(dev, &dev_attr_online);
 		if (error)
 			goto err_remove_dev_groups;
@@ -4180,7 +4180,7 @@ static int device_check_offline(struct device *dev, void *not_used)
 	if (ret)
 		return ret;
 
-	return device_supports_offline(dev) && !dev->offline ? -EBUSY : 0;
+	return device_supports_offline(dev) && !dev_offline(dev) ? -EBUSY : 0;
 }
 
 /**
@@ -4198,7 +4198,7 @@ int device_offline(struct device *dev)
 {
 	int ret;
 
-	if (dev->offline_disabled)
+	if (dev_offline_disabled(dev))
 		return -EPERM;
 
 	ret = device_for_each_child(dev, NULL, device_check_offline);
@@ -4207,13 +4207,13 @@ int device_offline(struct device *dev)
 
 	device_lock(dev);
 	if (device_supports_offline(dev)) {
-		if (dev->offline) {
+		if (dev_offline(dev)) {
 			ret = 1;
 		} else {
 			ret = dev->bus->offline(dev);
 			if (!ret) {
 				kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
-				dev->offline = true;
+				dev_set_offline(dev);
 			}
 		}
 	}
@@ -4238,11 +4238,11 @@ int device_online(struct device *dev)
 
 	device_lock(dev);
 	if (device_supports_offline(dev)) {
-		if (dev->offline) {
+		if (dev_offline(dev)) {
 			ret = dev->bus->online(dev);
 			if (!ret) {
 				kobject_uevent(&dev->kobj, KOBJ_ONLINE);
-				dev->offline = false;
+				dev_clear_offline(dev);
 			}
 		} else {
 			ret = 1;
@@ -4716,7 +4716,7 @@ static int device_attrs_change_owner(struct device *dev, kuid_t kuid,
 	if (error)
 		return error;
 
-	if (device_supports_offline(dev) && !dev->offline_disabled) {
+	if (device_supports_offline(dev) && !dev_offline_disabled(dev)) {
 		/* Change online device attributes of @dev to @kuid/@kgid. */
 		error = sysfs_file_change_owner(kobj, dev_attr_online.attr.name,
 						kuid, kgid);
diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
index 875abdc9942e..19d288a3c80c 100644
--- a/drivers/base/cpu.c
+++ b/drivers/base/cpu.c
@@ -422,8 +422,8 @@ int register_cpu(struct cpu *cpu, int num)
 	cpu->dev.id = num;
 	cpu->dev.bus = &cpu_subsys;
 	cpu->dev.release = cpu_device_release;
-	cpu->dev.offline_disabled = !cpu->hotpluggable;
-	cpu->dev.offline = !cpu_online(num);
+	dev_assign_offline_disabled(&cpu->dev, !cpu->hotpluggable);
+	dev_assign_offline(&cpu->dev, !cpu_online(num));
 	cpu->dev.of_node = of_get_cpu_node(num, NULL);
 	cpu->dev.groups = common_cpu_attr_groups;
 	if (cpu->hotpluggable)
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index a3091924918b..5005654f44fa 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -697,7 +697,7 @@ static int __add_memory_block(struct memory_block *memory)
 	memory->dev.id = memory->start_section_nr / sections_per_block;
 	memory->dev.release = memory_block_release;
 	memory->dev.groups = memory_memblk_attr_groups;
-	memory->dev.offline = memory->state == MEM_OFFLINE;
+	dev_assign_offline(&memory->dev, memory->state == MEM_OFFLINE);
 
 	ret = device_register(&memory->dev);
 	if (ret) {
diff --git a/include/linux/device.h b/include/linux/device.h
index a79865a212e9..d695f7537112 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -485,6 +485,8 @@ struct device_physical_location {
  *		architecture supports non-coherent devices.
  * @DEV_FLAG_OF_NODE_REUSED: Set if the device-tree node is shared with an
  *		ancestor device.
+ * @DEV_FLAG_OFFLINE_DISABLED: If set, the device is permanently online.
+ * @DEV_FLAG_OFFLINE: Set after successful invocation of bus type's .offline().
  */
 enum struct_device_flags {
 	DEV_FLAG_READY_TO_PROBE = 0,
@@ -495,6 +497,8 @@ enum struct_device_flags {
 	DEV_FLAG_STATE_SYNCED = 5,
 	DEV_FLAG_DMA_COHERENT = 6,
 	DEV_FLAG_OF_NODE_REUSED = 7,
+	DEV_FLAG_OFFLINE_DISABLED = 8,
+	DEV_FLAG_OFFLINE = 9,
 
 	DEV_FLAG_COUNT
 };
@@ -573,9 +577,6 @@ enum struct_device_flags {
  * @removable:  Whether the device can be removed from the system. This
  *              should be set by the subsystem / bus driver that discovered
  *              the device.
- *
- * @offline_disabled: If set, the device is permanently online.
- * @offline:	Set after successful invocation of bus type's .offline().
  * @flags:	DEV_FLAG_XXX flags. Use atomic bitfield operations to modify.
  *
  * At the lowest level, every device in a Linux system is represented by an
@@ -680,9 +681,6 @@ struct device {
 
 	enum device_removable	removable;
 
-	bool			offline_disabled:1;
-	bool			offline:1;
-
 	DECLARE_BITMAP(flags, DEV_FLAG_COUNT);
 };
 
@@ -716,6 +714,8 @@ __create_dev_flag_accessors(dma_ops_bypass, DEV_FLAG_DMA_OPS_BYPASS);
 __create_dev_flag_accessors(state_synced, DEV_FLAG_STATE_SYNCED);
 __create_dev_flag_accessors(dma_coherent, DEV_FLAG_DMA_COHERENT);
 __create_dev_flag_accessors(of_node_reused, DEV_FLAG_OF_NODE_REUSED);
+__create_dev_flag_accessors(offline_disabled, DEV_FLAG_OFFLINE_DISABLED);
+__create_dev_flag_accessors(offline, DEV_FLAG_OFFLINE);
 
 #undef __create_dev_flag_accessors
 
diff --git a/kernel/cpu.c b/kernel/cpu.c
index bc4f7a9ba64e..f975bb34915b 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2639,7 +2639,7 @@ static void cpuhp_offline_cpu_device(unsigned int cpu)
 {
 	struct device *dev = get_cpu_device(cpu);
 
-	dev->offline = true;
+	dev_set_offline(dev);
 	/* Tell user space about the state change */
 	kobject_uevent(&dev->kobj, KOBJ_OFFLINE);
 }
@@ -2648,7 +2648,7 @@ static void cpuhp_online_cpu_device(unsigned int cpu)
 {
 	struct device *dev = get_cpu_device(cpu);
 
-	dev->offline = false;
+	dev_clear_offline(dev);
 	/* Tell user space about the state change */
 	kobject_uevent(&dev->kobj, KOBJ_ONLINE);
 }
-- 
2.53.0.1213.gd9a14994de-goog


