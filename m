Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 477B5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB8E36B0112; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90056B0113; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A08EE6B0115; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7075B6B0113
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:28:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A30AFC0632
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:49 +0000 (UTC)
X-FDA: 84983909178.22.B8E5D2F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 104EF2000D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:58:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YkNMk2du;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Knn/IlgpbZTFm0uPlrSK4RQsRgPGqFz5Of3Db38ttBU=;
	b=Nc7lniWYqMac6kmD9/IkHnn4HjO/SMQcTewFQf9H1dSFnpTVmgz71iBJpcUOVfA6aYXhFv
	tQ5fLsEdrXvuEjbbLDcQFS8U82yjKB7cfHzf5nWaL/SwitXHSgdT62ltcnwCG0pzklmV+b
	T1m5quNzx81M65aVX86JOhXgrwciPxo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YkNMk2du;
	spf=pass (imf13.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951128;
	b=UyyKDlRRhYPhdyl5qw3/giR/McikXF2Sd8rWvYYFpngnChBcYxhRMH8+oZg9ebXBY/0nub
	QaHjVyUkvZax92l3swkH8SaBGpxbFNzmWXThYXh2cFcAZkospnfslwKQMB1plBUZEE25QD
	WGjzIiKrYyeq/UUnmVUab0UobVoO9Mk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EBC211AC1;
	Mon, 13 Jul 2026 06:58:42 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id F144A3F7B4;
	Mon, 13 Jul 2026 06:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951127; bh=uqt0YCzTdiYk9CWaJTOcbu4/zhkZINw0+fy6QeqfMrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkNMk2duo++wV39RQ3zQsSkBtiXGMU8KXH8jVFl7fKMdTT/xjjvp60qA2AMoxmk68
	 Eg4fUEaPBaK2tL00GYQTBSmmhplTwjTD2k3y608RG1C/j/Fh8LekoiysZImaxes3aD
	 i+drxBJLKGmYBW0HKqOEYeyxcBZniTS0k9lWnbXQ=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-csky@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org
Cc: david@kernel.org,
	linux@armlinux.org.uk,
	akpm@linux-foundation.org,
	ankur.a.arora@oracle.com,
	rppt@kernel.org,
	linmag7@gmail.com,
	chleroy@kernel.org,
	klarasmodin@gmail.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	kas@kernel.org,
	zhangtianyang@loongson.cn,
	wangyuli@aosc.io,
	tsbogend@alpha.franken.de,
	ljs@kernel.org,
	jgg@ziepe.ca,
	catalin.marinas@arm.com,
	will@kernel.org,
	arnd@arndb.de,
	ryan.roberts@arm.com,
	pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	kevin.brodsky@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	anshuman.khandual@arm.com,
	yang@os.amperecomputing.com,
	chaitanyas.prakash@arm.com,
	ardb@kernel.org,
	guoren@kernel.org,
	yang.li85200@gmail.com,
	viro@zeniv.linux.org.uk,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	wangruikang@iscas.ac.cn,
	junhui.liu@pigmoral.tech,
	muchun.song@linux.dev,
	vishal.moola@gmail.com,
	namcao@linutronix.de,
	pavel@kernel.org,
	djbw@kernel.org,
	yu-cheng.yu@intel.com,
	baolu.lu@linux.intel.com,
	Jonathan.Cameron@huawei.com,
	coxu@redhat.com,
	andreas@gaisler.com,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	geert@linux-m68k.org,
	shorne@gmail.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [RFC PATCH 11/34] mm: vmscan: remove stack copy address of pud pass in wallk_pud_range()
Date: Mon, 13 Jul 2026 14:55:50 +0100
Message-ID: <20260713135614.1618183-12-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 104EF2000D
X-Stat-Signature: haiitziuzmrnipuf84yrbaxymcstk6yp
X-HE-Tag: 1783951127-215751
X-HE-Meta: U2FsdGVkX1+BunRXFbUkh1aRmPZdCh0g7WPxA+nfE/N4gKC5cNCP9vaDOM4Pi6oG6me6+LrWzhHhXLKSfvZBuv9R3WEKf5M/jIKORzVO0jYEgRa2lhCKGAAXbHTYotwkOAdNp4OooXce4h3McaJ6XDT0yMxYgbKmJ6Ocs0MfV5tTIlrVUuZzkbFf/5YI/3CuULW0j+g04vNQCtjMIgYurMe3bVjlcqcxFk08ficfu1FxeJC/+7FCdNviZPCqbpURRS0XOi22TKBllBwgmgMOEDMMtAtTNWOQ9iPYylVcorLmhRVahU9nEFDti7AGuybXxKjE3xGQcZoeYWv+jJSG4z5nUPxh4QTtLhh60KEJ4Dm+n1362kF9B31s7Ro9Rf8an46wDLVOEoeRyqR3liURHVbSK+JdQSoGq1CtPzEGcvuoWKBbg7Jd34vsg0rf7QTZkxGiagKV+yXsgbKgdxV9aEdUPQ2jcd2TinatqdzVfMvnbmWSi2RHXYsB9RqS3bUMjaVPRvpDd05bW8hWgus9R4im+AVUo97hnQgMgY/NFtzdXLyADISFMYoPw9CK4DgWkYwBupHFodLgR9MHw7NEhporv4dgE/zAKwaO6QhPR7Vkn+Beh0FqoF7Bqpl61DaOEmEYPmZ2R5hvqOASJf7VicKp4+rzfsDvdlv5vZJwCECLT+X9Ba1hgJiAdvpy3jh5BHrM6UXLuqc6uiFptYvi2g8f7mH8hBUTt+ktLdaM+su3Qkrw9dc8+c+3VFt2xih6ytmoeuP8NPsHmYlJZ+mtLDVrVw2Afh1XnYLhWKzIXHAy0ZSqwrbVUyNNjkyJOYdT2wFD1e8b9USFta5zfjmR0mKp+FxNQVddtZCboyyo3Qu4eTG3N3o3kwksFAw4pwIRKG8UklDjZVWNN07dsSAkBHhCDHZeuwukp2i8SVmlxpVgvxH+W/HF92xS2ZhZy3+1E0knbYyah9bgGseVSqD
 aN0m1Fxy
 EibEY6xWXD65xAOz1WaY2U2jTZk88g8Ba/5eRanDZvmEbwOAXo7fLMC+dTs5AduRUfYqdLzkip2IeVJXA4d/32UAafFX3m8KRuE/XluTaMn42Q63yXej1cxZFwLDu7CuaIq8nhUk2zIo6R++SpNohTOMVoM2lVrbAncjFl1TB5yOQIPdjAumqSZDZ+WR5pqqiUn3+43MNCdKqtwTBynE9u0gi1dHzJhcK/Cs7txF7sH6hncaQ1yD6dgggIWrsIaUREQeNdRPMcDq8Q8EmKXA/+b1V/8XLfNweOSRbO0PdDbprE3wYBlCtfTP86JJN0Yt4/vIq2IvR7fepkvbswc1px76oCCdr2e84JeMSNjAwZZbib2U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to change how pXdp_get() works with generic compile-time folded
page tables. To prepare for that, replace passing the address of a stack
copy of a pXd to walk_pmd_range() with pud pointer directly so that
the ignoring the value of folded entries.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 986dde8e7429f..61470223d8213 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3725,7 +3725,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		walk_pmd_range(pud + i, addr, next, args);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


