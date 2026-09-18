Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92038C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C573B6B00A0; Fri, 18 Sep 2026 06:04:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C07DE6B00A1; Fri, 18 Sep 2026 06:04:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0DFD6B00A2; Fri, 18 Sep 2026 06:04:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7257E6B00A0
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:04:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4D89C0553
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:32 +0000 (UTC)
X-FDA: 85226448384.03.18863AD
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf17.hostedemail.com (Postfix) with ESMTP id ADA5B4000E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:04:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BckyjycA;
	spf=pass (imf17.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789725871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zufRRvpwVHCucp4/a8wU/krIeaWea9Chc2jByLlFL4c=;
	b=BgbLkqSmyJSRXyAa2F5aLNNWOxyJZu12m/aDWFEUCbte+uJNpH2uWCjxuTX7IXt1lY+ob/
	pS/x/qWmQv3ygBFrqk7/h4DbUq/n+GKwsq54TuzKNr2rsIw3/H8SdO7+DY39TlGaYQx5G0
	oJ7d26IrCEFTL1mvGMU6tYtm9mOOjO0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BckyjycA;
	spf=pass (imf17.hostedemail.com: domain of ruanjinjie@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=ruanjinjie@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789725871;
	b=5Z478W4RQnbNSwjhApRwqFjpyJGXvlejC2eNBAqgBS+SetW/D5U/xCX89bI7P4zQUSECfp
	0Y/TOzaV3qAmtvAxnCMsM4lYc/yX5vOVH9QyFMwZcw+XfYvynJ61dOz1wvN3zElCyeD1ho
	+7/j9BkpnhD0yZ7Br2Or3UHbK/Me9IM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=zufRRvpwVHCucp4/a8wU/krIeaWea9Chc2jByLlFL4c=;
	b=BckyjycAl3ciFIMoUA4aZPGw9VUPen7PpwqZaxbivk06HsP2G2e1o1OYRpVjCGxZ5ScmXWiON
	VLeKRZcC4u9YJAKQArJ+X4FgbKFWIz3sdq8RcX+POy8ZO6Pxq07qezk90rBm7yrQxrk4UOcJCME
	uqEZBVLJJhWv39vUktkr7hk=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4hmScN3dtKzKm8V;
	Fri, 18 Sep 2026 17:53:24 +0800 (CST)
Received: from kwepemk200008.china.huawei.com (unknown [7.202.194.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 17A674057C;
	Fri, 18 Sep 2026 18:04:28 +0800 (CST)
Received: from huawei.com (10.90.53.73) by kwepemk200008.china.huawei.com
 (7.202.194.74) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Fri, 18 Sep
 2026 18:04:26 +0800
From: Jinjie Ruan <ruanjinjie@huawei.com>
To: <catalin.marinas@arm.com>, <will@kernel.org>, <mark.rutland@arm.com>,
	<chenhuacai@kernel.org>, <kernel@xen0n.name>, <maddy@linux.ibm.com>,
	<mpe@ellerman.id.au>, <npiggin@gmail.com>, <chleroy@kernel.org>,
	<ritesh.list@gmail.com>, <sshegde@linux.ibm.com>, <tglx@kernel.org>,
	<mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <gregkh@linuxfoundation.org>, <rafael@kernel.org>,
	<dakr@kernel.org>, <akpm@linux-foundation.org>, <baoquan.he@linux.dev>,
	<rppt@kernel.org>, <pasha.tatashin@soleen.com>, <pratyush@kernel.org>,
	<ruirui.yang@linux.dev>, <kees@kernel.org>, <thuth@redhat.com>,
	<ruanjinjie@huawei.com>, <gshan@redhat.com>, <ardb@kernel.org>,
	<james.morse@arm.com>, <leitao@debian.org>, <yeoreum.yun@arm.com>,
	<sourabhjain@linux.ibm.com>, <robh@kernel.org>, <coxu@redhat.com>,
	<tangyouling@kylinos.cn>, <liukexin@kylinos.cn>, <guodongtai@kylinos.cn>,
	<maqianga@uniontech.com>, <zhangtianyang@loongson.cn>, <blum@kernel.org>,
	<adityag@linux.ibm.com>, <chao.gao@intel.com>, <kas@kernel.org>,
	<vishal.l.verma@intel.com>, <seanjc@google.com>, <piliu@redhat.com>,
	<jbouron@amazon.com>, <me@linux.beauty>, <mclapinski@google.com>,
	<graf@amazon.com>, <bgwin@google.com>, <eric.devolder@oracle.com>,
	<hbathini@linux.ibm.com>, <takahiro.akashi@linaro.org>,
	<lizhengyu3@huawei.com>, <palmer@rivosinc.com>, <x86@kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<loongarch@lists.linux.dev>, <linuxppc-dev@lists.ozlabs.org>,
	<driver-core@lists.linux.dev>, <kexec@lists.infradead.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: [PATCH v5 13/17] crash: Assert device_hotplug_lock in crash_get_memory_ranges_nolock()
Date: Fri, 18 Sep 2026 18:04:38 +0800
Message-ID: <20260918100442.3841135-14-ruanjinjie@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260918100442.3841135-1-ruanjinjie@huawei.com>
References: <20260918100442.3841135-1-ruanjinjie@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.90.53.73]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200008.china.huawei.com (7.202.194.74)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADA5B4000E
X-Stat-Signature: 1ek5qzuby1464xinzh3n3o56krtbm8rr
X-Rspam-User: 
X-HE-Tag: 1789725870-315921
X-HE-Meta: U2FsdGVkX1/ROs8RGUQYTpQYU3bD/uOqCJo0Jh6LQqFrouoU7mgG3ussnB58ajPFxoaIj82+QMoSEu0DPYSpD8chlOtpervWqR08SdXIYLVVeX5hszI+8BM2kWXFTZf6aLqByZ5D+A6gjAIB4IK3ULGrBbOQHekq4+XekR3I6KNB1I4RZv0tNIPaYuKv41TL5Q1NHvLZMTSVrgClqa74FeWyQnzjqlAaD1FoBXheRzVr0wwAxTG2w/+WzvynV5s4RBM7uU5LDIjjOdU9VXmOh6c0I9oiHoC2aJb7Cc0Jln8LONLxX8iMOyXdBD8BC95tIz+hKMteaQF0GhFZp4Fx+kzGSM6+mRWG8yIZCcgLs85b0+my3REyQRrq705WnDCl6IruyL+3WAW76iuyu1sca8teJ9kbNNJy0gEtZLzzTDNL3Q5gOUEYrVpI40HH9sAdGfo3jxqRT83MidAK+/PkF2mASA1kdg+KHJeVxFPjNW3j51kqbSLCwu+lxCiKmeD1DKqVleFGilgOsjnCT4MJIllZ7aQl1n7N2kHh1Ux3KQKFutpmhX79QXk6S5C6V9Rx9/293av118Vt0iwAJ3faymfzW6s4mX8pr1nn7aIPaP/bs0SYECl8MDLkALgiJbKicp9PE57GNn0Z/QMFdV360eC7XpLbQ62mLqUdtUvq+uXbixS7AIV3KR5oBvGbN8YvdjunNs/q3OxOxb1Qj8d2U8llNEy7I73KjM7cXS52CyiSy2yy7koS7ZGplDBvCxXhmsNRCqXsQrwXoRiau+CDeuqXfJvBGBwTCeUUHW6r+x7gJ85BxVigsMWLVn5AOOFLiHuKkW2MgKTlxGTtrY/WfAK1NULUTgDd5r3kcrNFmNgwSe8HddUR++yC7s7mW5FkHivnvvdK6eoa7bQAB0W4/KrikxNuFDpb/+Fc5Qhy8FDY6N2RekuyuBChCq/I8d0tx2+ZFFMB9d3SP1EZvMT
 G+4wDxB1
 YUlueliD6eGkww3nmqnbyrrFF/IOq6vtSlr1JpW5N5PFKEA1iz/B5NR0HzEZMGcQQi2IpJo9uMkGQ1ayhkT+z3EBx0xkgjzMN2Bz88QtYbZnMkzy6gdbM2BhhNwmch72ZujtTvVEHtNjwEjn3reOnRzTYmuiV5uAgeqRxyJ7u9ZzBkq33bqA6rx2Q6fzRy9dz85hTUnWr/mhFXpMOjlVH3fbLAPJG9DjbaRdOSaq7v0Bwsltec1VQeXeQ00UOVjiFWLWkm7OW47LETvOfo93v6JZohszotkUCCxbUmLH8JjxqKlefi3doPV0NXcKTnoELwVnvNwFE+X89TBDOD/Z0YmhHhxos7Qj/MITU9/gR6ROky4Zk8eXNv6Q6iv6rGyVU4ApTeT5JbUoUegMXeuAF5BMCf1DKvsvNUGzh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

crash_get_memory_ranges_nolock() walks memblock, which memory hotplug
modifies under device_hotplug_lock.  A caller that does not hold the lock
can race with memblock_double_array() and iterate a freed regions array.

Add device_hotplug_lock_assert_held() and call it at the top of the
function so that such callers are caught by lockdep.

Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
---
 drivers/base/core.c    | 5 +++++
 include/linux/device.h | 1 +
 kernel/crash_core.c    | 7 +++++++
 3 files changed, 13 insertions(+)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index 4c0c373998a1..c04adc457a96 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2420,6 +2420,11 @@ void unlock_device_hotplug(void)
 	mutex_unlock(&device_hotplug_lock);
 }
 
+void device_hotplug_lock_assert_held(void)
+{
+	lockdep_assert_held(&device_hotplug_lock);
+}
+
 int lock_device_hotplug_sysfs(void)
 {
 	if (mutex_trylock(&device_hotplug_lock))
diff --git a/include/linux/device.h b/include/linux/device.h
index aee79fd6b32b..9cca8c8bd372 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -1261,6 +1261,7 @@ do { \
 void lock_device_hotplug(void);
 void unlock_device_hotplug(void);
 int lock_device_hotplug_sysfs(void);
+void device_hotplug_lock_assert_held(void);
 int device_offline(struct device *dev);
 int device_online(struct device *dev);
 
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 760ca9822a13..852a5f51d472 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -338,6 +338,13 @@ int crash_get_memory_ranges_nolock(struct crash_mem **mem_ranges)
 	struct crash_mem *cmem;
 	int ret;
 
+	/*
+	 * Callers must serialize against memory hotplug by holding
+	 * device_hotplug_lock, otherwise the memblock iteration below can
+	 * race with memblock_double_array() and read freed memory.
+	 */
+	device_hotplug_lock_assert_held();
+
 	max_nr_ranges = arch_get_system_nr_ranges();
 	if (!max_nr_ranges)
 		return -ENOMEM;
-- 
2.34.1


