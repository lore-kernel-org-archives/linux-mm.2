Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0CB4CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 07:23:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3653F8E00F3; Tue,  4 Nov 2025 02:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316568E00E7; Tue,  4 Nov 2025 02:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4CA8E00F3; Tue,  4 Nov 2025 02:23:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E58628E00F3
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:23:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9ADAD136C9F
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:23:21 +0000 (UTC)
X-FDA: 84072083802.24.0006BFB
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf03.hostedemail.com (Postfix) with ESMTP id BCC142000E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:23:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rRFvaS8d;
	spf=pass (imf03.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762240999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NghPoVpU9F9TPfTZpSz+vCAG1iGPiKItcdvquhOQIn4=;
	b=6gUEi+hB58R292MJdXzHd4YU7AcVRcwQUwT4ypQ8WZSWaZUWp+leaYP6wBNC/9540RTPOE
	oswPoQrFMPzsOQDJMLDV7mf5mAefF0mfP1nz4dSieZb98wyG1w1nQZqfWEyvX2oP7WITgT
	5jwUuLRtmnxpnmX1bhYs487YHbhja0A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762240999; a=rsa-sha256;
	cv=none;
	b=aGZRUV9n8lhv482XyF54oik14et5FWO+rixI7N0q58Ecygo+f/JMxSJbpuyijxfUdW24hB
	YYm4I0kV+48983QkDfMIN6MU1UFQvXBuR7hQyce8iyirJt/RZtBBbD6RgGxW03BsnYNcdn
	/G9i/XJH4gGuDDObUJu9Jswcys3w0SY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=rRFvaS8d;
	spf=pass (imf03.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NghPoVpU9F9TPfTZpSz+vCAG1iGPiKItcdvquhOQIn4=;
	b=rRFvaS8dJ0mRc4JzcbwoZpDYcsM59LP6EXUUKmiKOrxgiB0iiudwogcBujZwcoQpbPe7pATMf
	0l75qpkTRD2jQoXbGvabjU417w2lVBfvW0swG76sU3jj0Lv3+6XUo8y+QX31/VO4WfDJoNHjzAd
	6yMq/k3X8v/JfJWUEr1U41o=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4d10J254Ktzcb3X;
	Tue,  4 Nov 2025 15:21:38 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D9BA1402E9;
	Tue,  4 Nov 2025 15:23:13 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 15:23:12 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@redhat.com>, <dave.hansen@intel.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tony.luck@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <will@kernel.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: [PATCH v2 1/2] x86/mm: support memory-failure on 32-bits with SPARSEMEM
Date: Tue, 4 Nov 2025 15:23:05 +0800
Message-ID: <20251104072306.100738-2-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251104072306.100738-1-xieyuanbin1@huawei.com>
References: <20251104072306.100738-1-xieyuanbin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Stat-Signature: qeghi1rup5iftucp3tu3qrxck3bbcbhy
X-Rspam-User: 
X-Rspamd-Queue-Id: BCC142000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1762240998-948191
X-HE-Meta: U2FsdGVkX1/6jxlcvz8LTCQ0YlY8ifZ6Mh8OAq3Dnav7ZyKB2F47ESTBMyMpHIlhezR7HSoTVyHtb9TZ6V/RpP9YAB7Q6Rth4Rx557xjjjMP/UBPErv7bgtjHFqQrb0Adygt01bMWi/+KSh5THnW4SMUC70H3FXX16MyrlUZ9dW1SzQ/xiqE00Fv/fBwHQsWuJC6uiR7+/WybevsYDHxvLp1WASwaUCZwy4a69e6s73MzqnSprimfusmfQGTht2plT7tNINT7Z4iYUZWdTJH2hzYSLT+zduaeE0LO0aFKJZqmdxVHGR7i5RpVxj3NIdD8MdGUlfKQDkQxUJKfY1I0VWmGn3leV3ViGimUduXjbG/0supCzFxbCgAKAXyVZC9TCkDWW1fEoYZ4j+tVM6fqz64XYIYiuyFW0b1czPnpPDYGHESm1q1tweJ9yIg+0MBc0RyJcEi61BulOqKqU7av0zRLA2qNw7Kj0uau+TmjpKj83y7qj9D4bQOBDYF+2/Zrp3X6EE95jdbl6K7h82pYjmmowedzhN6ONYDRq+l3210EeF5KL77LMnuUW5yFYuWi52Sam7EQLrwklsZsAihfX+rpYgq+O4uYWnf14ohXwI+trAk2N8ob8NG/AKlqAuGe/uWQGSeNhgseAkmbr5dMObUu5sVOxUqoiPPAbiuFhyDEL+xsKpw2t3swG/H/Jg0NHN0fNkHym6E0qOe/xybKewxapjcjMxUp1VB8gXK07k5tFDekgFwKzHMRxY8Euz8dHlOUFp29TyIMniRfzfCzUVS0+OiwLLcGCTBtFwegl7LQEE5BYuiWMbZVKQv6lum/Be26Np4wp9QFwu5ye+IpgiFN2e+lx7jbddpZl/1qwZaO1m9DVEUyzP4v+voxJeOXlhW+a1nEbNGp8OqhTiU1mBmVj9EtcweDhkJ6LtZ27uBlrYn4OFIv7DzYeTMxQQByH7pRGR/nG0zdOo55+k
 sk6JmBWh
 6LRlWxDI9p1aqGHj1Vey5dbtcC3WDq+qYsY/UjcBTu6f3NSZnXjZSIXCDczbWpNPZWoDcymVM+1Cm26gHTmgYon2ooXZCb62Yef1+ZXd7+NAswlC7PZGs4MD9UPN1EYZBYolYdfW3rowzeqEEQx7QlaUKGm749LqrPyy1ySboqe/jluxNWFRV98KJLuEW48LNIsBZ+vEC8JbzMSm0HuVR8oPieOJ2aLYIY8a88JWsejJRPHDFjkmYs5nGn6BuPF8LIMXcTIyNYk7g/b/RHKGjJ7gUBMrY7ESnP8+kcwXfxWaCZPSNrPz+fePG73UYs98SKQSiQmk+SoZddSzLDf8sBNwCDGYXpRFIXL3/16hsv1jTrSTIFBpSGtkJ2TRsNNpVpvDRhRx8LxoPVFZbjY/L5gWFOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The historical commit d949f36f1865c60239d4 ("x86: Fix hwpoison code
related build failure on 32-bit NUMAQ"), disabled x86_32's
memory-failure when SPARSEMEM is enabled, because the number of
page-flags are insufficient.

The commit 46df8e73a4a3f1445f2a ("mm: free up PG_slab") removes PG_slab
flag that allows MEMORY_FAILURE to be enabled from here on.

The commit 09022bc196d23484a7a5 ("mm: remove PG_error") removes PG_error
flag.

The commit cceba6f7e46c48deca43 ("mm: add PG_dropbehind folio flag") add
PG_dropbehind flag, but MEMORY_FAILURE can still be enabled.

For the current version, for x86_32, when SPARSEMEM && HIGHMEM && X86_PAE
&& X86_PAT, the number of pageflags reaches its maximum value,
which is 31. Therefore, MEMORY_FAILURE can be safely enabled.

Signed-off-by: Xie Yuanbin <xieyuanbin1@huawei.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>
---
 arch/x86/Kconfig | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d55c01efd7c2..f9ee57a55500 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -750,13 +750,10 @@ config IOSF_MBI_DEBUG
 
 config X86_SUPPORTS_MEMORY_FAILURE
 	def_bool y
 	# MCE code calls memory_failure():
 	depends on X86_MCE
-	# On 32-bit this adds too big of NODES_SHIFT and we run out of page flags:
-	# On 32-bit SPARSEMEM adds too big of SECTIONS_WIDTH:
-	depends on X86_64 || !SPARSEMEM
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 
 config X86_32_IRIS
 	tristate "Eurobraille/Iris poweroff module"
 	depends on X86_32
-- 
2.51.0


