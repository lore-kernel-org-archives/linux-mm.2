Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B9FCAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 02:15:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BC208E0006; Sun, 21 Sep 2025 22:15:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06C448E0001; Sun, 21 Sep 2025 22:15:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9CE98E0006; Sun, 21 Sep 2025 22:15:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D11EE8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:15:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8120E1DF5CD
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:15:14 +0000 (UTC)
X-FDA: 83915268948.04.34BCCD8
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf12.hostedemail.com (Postfix) with ESMTP id 41C6440006
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:15:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758507312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=sMF6qJo2WiodKPx7sdGCoYC5r7NLvAxgI7YX4vFUwiU=;
	b=ZY21AUQsxnP9+ggu6IA5u8UVAR0VoY3DTsPIo9lEDL/BVZ/d0jS65e65IAuEMMfP5DSZ4B
	kf3qX2gAD9sW4qiPfAP6tu6c/k5eH5sL0FIoOLX/WUjfKK0sl8cZulkpC2Xxl0MGFvKoBi
	UxEt2DXxtSSRmfYGGAsnnwdqb3dms7c=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of xieyuanbin1@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758507312; a=rsa-sha256;
	cv=none;
	b=dDoe2kJ43PefP49CCRtM0ohAfSVgK+9UoM57MxjHsOnar4sWGM4Xas5pzvrC7dqRzODJuv
	vrhAmM83U36X1RkaC1I2/UWIFLSdrl5SzFEw1kE2DiVjnIGgRtXtawWXTHFCfIJ/DCBudf
	V21nCzZVQ3gyjf1lSMzFm0Dkpdq3nDA=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cVRWh4ccPz14MPw;
	Mon, 22 Sep 2025 10:14:40 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 2E99C1401E9;
	Mon, 22 Sep 2025 10:14:59 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.108.232) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 22 Sep 2025 10:14:58 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <linux@armlinux.org.uk>, <akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<linmiaohe@huawei.com>, <nao.horiguchi@gmail.com>,
	<rmk+kernel@armlinux.org.uk>, <ardb@kernel.org>, <nathan@kernel.org>,
	<ebiggers@kernel.org>, <arnd@arndb.de>, <rostedt@goodmis.org>,
	<kees@kernel.org>, <dave@vasilevsky.ca>, <peterz@infradead.org>
CC: <will@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, <xieyuanbin1@huawei.com>
Subject: [RFC PATCH 1/2] ARM: mm: support memory-failure
Date: Mon, 22 Sep 2025 10:14:52 +0800
Message-ID: <20250922021453.3939-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.108.232]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspamd-Queue-Id: 41C6440006
X-Stat-Signature: 6bwaewt69cc74regfbbrhynstc3mocp8
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758507307-724834
X-HE-Meta: U2FsdGVkX18tE1/4NGmW863i8EAoDBQsJkU+4Nlpyjkt0/yN8dsHbJaqpFPi3lo0XF3zoNFKVUtkX5K7tDQzFzjr1bV4KQA6f79HXG0sVEiQHopHO++SwjX7Keoos0kWjztMINjT8y2DXyXZ7m6EjGDgKFNi/BRgNe+GIHg8K4cYSCrC07zWdZJ49b5yz+UU70V67aXlM1JJ+Z9lafy7uO8YwpGIAC1oxtFyLyThpcCoCsIoH0jDs1grMZ3KMp9kP2NNxYaD8Avr4adKgENQ7vAnDeK9iPdD7jvWEnzBcOXXLIq9EdbDTByoU2Fbt3mWKtYohkdj1VpySdFIzmpSGOEvfs1f3ksLQX6AqOETiZonpRAta46LpThNXv7B+cAfr7Siu8q1RS4RptTjg2NYqsvX2jENInRQZz3vaVZMyFbFVT+yD2cYHD91xVj7waUx39tNmCEEh27lJNV9TuqVLJsqzDMx4OHN5/HaVHr0bPHNxx1Sxx781FICXkegVKYad8o980esn2VwLvn+Vs6y0kwufA1za90+jKES2/yMBImaRU1jk6TPX6ItScL18nCCmRE0bGpWSj79m1HwfQ6CMpq9jKpMAYuaFgZHys/DDAyh2ZwZVV4B+WqSjNuRTjp+bvl1JwO8E3uuWyEFpzlOhwn80cDE4/Ypq9qal11NUkUDmH/M6L2xm7LF0gxa8w03BuTmSIPYMCLN2Pxhuww+YfTecDQgyOfqxeGdBJbV1Xl9CugGMLTSvI5IFmleHKKlSfmjProrfuhDMWiVFpTjSPZVn5TLxrIwkM2ylpo0T5R3pdymmJfcG3cC3FvSeBqMChrDDuJDAPUMloGmlL8PP2HgvyPJA9P1xiKUJ9v/+qrnj7XaWDXyIE4ffTe9yKeJQuk1L4oQ/cMZNbQ8ssT0Xx0yCsCJ1p97WiVH2PQovX15XpHjJxn/vO09wPt85qeIRRh1luLc5DwALI6wPZv
 WmWf+kJ4
 yk78Anu4/0bWvhThVaY/NH9v2Qm4fQTCklTTTJJrwBE535z8ghc7xYtcAWGtyaxuj3Y2VpcWiBt6RU6mX6GVHDq1fMVC6CMYIwENAw8kuj8hCHUqf2/Se8OgN6Y+JIKee0rmDZBc0vDVHEFch2TJK7dy3FQdHF7rz3uzrJkalhQnaY2xCgeQwbpzMstNFJPfG7nBU66vEVz8iC3vXl+dfiZfb+NjOigzuxoxD4O69hvh4nTxVbD8nrZTYlZf9HASQmY4VdEaFz14MjyFSimsv4yNWr00pnk9DWC7LDGQjNi67CS/FEdRBU9qJSLvRdFeYR7CDdIKuOPJDJpw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory failure provides the ability of soft offline pages,
which is very useful to handle the memory errors such as CE in ECC.

Although ARM does not have a user interface like
`/sys/devices/system/memory/soft_offline_page`, memory-failure still
provides some exported func that can be used by some module ko driver.

Memory-failure will use one page flag (PG_hwpoison). For historical
versions, this will cause the page flags to exceed the 32-bit limit
(when CONFIG_SPARSEMEM and CONFIG_HIGHMEM are both enabled),
and therefore it cannot be enabled.

The following commit:
commit 09022bc196d2 ("mm: remove PG_error")
removes a page flag, so memory-failure can now be launched on ARM now.

The core codes of memory-failure is architecture independent, in fact,
it has performed well in current testing. Perhaps it can also be enabled
on other 32-bit architectures(like x86, and it seems that it can already
be enabled on 32-bit parisc architecture), but I haven't tested it yet.

Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
---
 arch/arm/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 5527935fd15a..b38c194a5cc4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -149,20 +149,21 @@ config ARM
 	select PCI_SYSCALL if PCI
 	select PERF_USE_VMALLOC
 	select RTC_LIB
 	select SPARSE_IRQ if !(ARCH_FOOTBRIDGE || ARCH_RPC)
 	select SYS_SUPPORTS_APM_EMULATION
 	select THREAD_INFO_IN_TASK
 	select TIMER_OF if OF
 	select HAVE_ARCH_VMAP_STACK if MMU && ARM_HAS_GROUP_RELOCS
 	select TRACE_IRQFLAGS_SUPPORT if !CPU_V7M
 	select USE_OF if !(ARCH_FOOTBRIDGE || ARCH_RPC || ARCH_SA1100)
+	select ARCH_SUPPORTS_MEMORY_FAILURE
 	# Above selects are sorted alphabetically; please add new ones
 	# according to that.  Thanks.
 	help
 	  The ARM series is a line of low-power-consumption RISC chip designs
 	  licensed by ARM Ltd and targeted at embedded applications and
 	  handhelds such as the Compaq IPAQ.  ARM-based PCs are no longer
 	  manufactured, but legacy ARM-based PC hardware remains popular in
 	  Europe.  There is an ARM Linux project with a web page at
 	  <http://www.arm.linux.org.uk/>.
 
-- 
2.48.1


