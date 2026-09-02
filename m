Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 565B3C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5A46B00CF; Wed,  2 Sep 2026 07:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 45E676B00D1; Wed,  2 Sep 2026 07:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 374246B00D3; Wed,  2 Sep 2026 07:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7476B00CF
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:58:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D8D91201B9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:31 +0000 (UTC)
X-FDA: 85168674822.25.EA5BB60
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id B960E140004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:58:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jYatJEpX;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788350309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=davfq0z7MyiduyrJqxBuiTUo7xKHqvO6yeyvaRPCkgI=;
	b=xXBXprTT48rfiUiGmhchlCwdkURI/OdVW104DZfgFkUG6WTBwghoLBvp1nr947FQFanAB0
	EzRFjm6xVxu05Ds6yeEfCBlCrp1C9A0RBET1j2GHr/uKFbiXrWZGcwJBCTxSFDLMvMDYsl
	Rk6uh/7uTjH4ovQpndC6miFWSyBVrpg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jYatJEpX;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf09.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788350309;
	b=0O/I/NMEnxvf88CO2/Pzj/LGIhe1Sq/jcs4XE+Ow/G1RXv9jEMrnUF/YOKDMcII8hU/39T
	X4bGS2RnnA08wj6NEKTlcJWzR3IVq8I5pKcBvVh6Su2tuBkL9ixYz+L37vdOfa/jsDIOzF
	o3CulVsMuaKJXKSVlM7FtcJ1vfu6wLo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4A5EC1684;
	Wed,  2 Sep 2026 04:58:25 -0700 (PDT)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C64723F85F;
	Wed,  2 Sep 2026 04:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788350309; bh=k2zH0FGZAHQHsE8iyLCaqqIz9EPe8wwBeb+yxtADtNc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jYatJEpXusEujngnHtU6I+YPUKEc9K8lGG+lz1k8jk0KjT5om9VcibE/ezX/VNx7b
	 lpj/LXh8tiH840xQlDjIN8NOZFbyzF3GoEjDO3+GBfOYuqP94T7AQrC++hekhMS6tA
	 8FkWEGa9JBOcKLOCiJlkvBaOKggzzYeRDZmNyDQM=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Wed, 02 Sep 2026 12:56:17 +0100
Subject: [PATCH RFC v3 15/21] x86: mm: skip collapse_pud_page() when
 CONFIG_X86_DIRECT_GBPAGES disabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-dummy_ptxp3-v3-15-5d8f5b17c25c@arm.com>
References: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
In-Reply-To: <20260902-dummy_ptxp3-v3-0-5d8f5b17c25c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=958; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=k2zH0FGZAHQHsE8iyLCaqqIz9EPe8wwBeb+yxtADtNc=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBqmA7pUQwEjNuqeUAg7BhIVlnxOYow79q+z+b/o
 Mu+s6x0zhqJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCapgO6QAKCRBt1cPRWsUx
 Mz9sDACbzWbwygGpa8m3XTPuxJjLPEKbMbsFtZoHAET7S3zJ2LzXLww4d97at64xdcy0C9qcaWn
 tUK+uYwT5SoDrcZGmfsCgkyKnZ3bcOfrvI1CTIx3pn9wi7HlvNnFpoHJWX1wFhyDvNnivGAWwsD
 RVZ6G5XrvM3ngBD9A3GaObxS/hOfNl6B2cAfrLJdXQlFvhTOA7evFUwYxbSFQtREo7W9iPBbbhm
 FPNf9wlD8mSt0yJmy3Qv97MpkoT7C4YN9hgXPoJ2xU+Q0YTYJi5hf71QPpJgYQrr2aCRm06oBrf
 Hjgq3DMzHZEQL3ROMxL2wlUgUj0dpPf6JXmI4z3zSpp0POGmdgTjUGkTKUflejOTbAnUKV3SOyA
 /5BZiBlXnygsBnRlMPKDve452e/HvUePcW2dHO4oVqHDg+1C2R3xXuQyq+w8kGdgQXAlc2papvE
 ACcncgIrI/l73eXzjT29pSeE28A+OoQGnf4+ycoq2SoHHMNmrkkPY3GeJeF6nalFI2ayU=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B960E140004
X-Stat-Signature: kecn74fxgaqjns3adkxmodd59jy7o1b9
X-Rspam-User: 
X-HE-Tag: 1788350309-902048
X-HE-Meta: U2FsdGVkX19iCOKaCynIjkmW3iUzMA8D+e6vyfvLQmSADzRoUVzmdgN63lDovoq6jvcypP78SGkv1in+28R2vrno+duhP8ji1CG8kK2KmnWEjX1kncuO2WRzmNWRXO+pZVAR+cNGbt4yFvjkcwNwhHhjy0Aj8t3M7IY1qqv5gS2dixHX+RHX+YUHs0dtPLweZ8i9eqyUuSXrsjOoSdBKtwZAP9tAoYaXohnPtqRQqpo/ny8c8xYvQ9xiqCRSECZBRFljDKYq6ne9FX+dR0bURuV0uP4epjlWGsA+jBMCMDevzLqkJUb7ioiy9pWPJgVrrCtOHC1EKrCxc+QJEiOiSFpKp0cdgSjVDEjx0RDDG6moYBSDsGxtgWAUSS3vnGEdXwAuc9+ZYsUvpfw8CoBuGYHfhvgQwr2SP1CdvK3ANxORtE3tGp53aCZfJjD1GXkPyoxX4LAx9NwsOn5X0GwNBlr1a7outI5nWPgdMjQaRzyzRzzYziLkMu35u8P7bf8Mh9nQrPWMFVST6gdSFuMK7JnBdEyIuYX0gWC07M7PjdJpmtJr3y7ZZ1cmBapaKygB4erFqtBEKvWnnOJw4U2WOTaI5pgmlTRO6Zs+14ihgYBXsO8GsDBt6t1wKEZvY3CiWmiNEmuwo7IWpUNgVZhGy7fWPdkUdP9KUQHLP/yZRt3M6zHf1/1R6D28RLfb5AlHuZpd2EYxUWSCLp+Mjbixd2XavhbZNog2EXzGCpOUvqPA7RM4QdCFPbVOsS1CvB5LuQZswR5i+hSeZMMwgzVCHNhoG4NOnS6sr5IfZ/qOryA4YdEK9Akv1c9Ee8EvlFv4gmDNjFmNoZRpSs8PTE9vvpAcvPO/7LttKqSCXpppxuVyl1M4OJle0eqZ2PuAiUGlkHrcdWTw4XbiiFxmEhdUIm0zBNv1sCK8iLx1qLb/IlQRFsWTVM+XOBrDw95UtpDyt2k0dast9IrWSTacMD0
 5p3KCMLl
 7sLkqVREHi9pZ6C1ZvDZjhloP1ZhCBbOXUvmzO1kRTLgsCv2DkHlkfvWVevae+GyqyGY6RmV3lM6Jeego6VP3L46nQHaid6+ZcQLoZ0xW9AK3/Jco4nE8HiQBEqahESs8aL50+op3HoC+u2HceFFf+JQa495tUk8EaiRonNkY9OBUvB5smy6x21E/ALR9RXqKqzWpkux908fpilwdRCOhJhEYKRkYBgxBdmD7ZMsqJfXTERhhLNsLlxQHuimyhHpM3XhE2BgYeRzORvTLvZ56qSDb0o3pJEBBoxl/zLJK/F0mGd0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The behaviour of pXd_page() will change with generic compile-time folded
page tables by disallowing its use and triggering a compile-time error
when it's used improperly, ensuring that the actual pXd_page() is used
instead.

To prepare fot that, skip collapse_pud_page() when
CONFIG_X86_DIRECT_GBPAGES is disabled.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/pat/set_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index a1a061d995b3..07a873775279 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1315,7 +1315,7 @@ static int collapse_pud_page(pud_t *pud, unsigned long addr,
 	pmd_t *pmd, first;
 	int i;
 
-	if (!direct_gbpages)
+	if (!IS_ENABLED(CONFIG_X86_FEATURE_GBPAGES) || !direct_gbpages)
 		return 0;
 
 	addr &= PUD_MASK;

-- 
2.43.0


