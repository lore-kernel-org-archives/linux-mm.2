Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BE37606A323
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 09:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vcnGO8g8
Received: by kanga.kvack.org (Postfix)
	id BBCDC6B05CB; Fri, 27 Nov 2026 04:08:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B94C16B05CC; Fri, 27 Nov 2026 04:08:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83EF6B05CD; Fri, 27 Nov 2026 04:08:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6FA196B05CB
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 04:08:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C581A160287
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:08:22 +0000 (UTC)
X-FDA: 85480322844.14.5FA7333
Received: from mail-pi2-f11.google.com (mail-pi2-f11.google.com [74.125.227.203])
	by imf03.hostedemail.com (Postfix) with ESMTP id DD6FF2000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 09:08:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vcnGO8g8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.203 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795770501;
	b=lg4EFn2F0LA442xHHDFz4cUWwV9sUYhKd1//38hJ912kUfJRYf2zpYZlVtCFfC+O8YoZKp
	u70Sy/ItbM5K1Pi70t6StJhprcsiNJ3442OGSAJ4Oq8aJ7VRRi1pEk6SeCtI88x4HIV3pk
	KSj8kLw7NQzgf1MGcqS7NQG8DGBd0Z8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795770501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HBwnwSvBiq0QxdeEz8EUNpHvBkXWdsPgrdZSvJG6u68=;
	b=G7ZmSURDVL9VYKOZSqhoQfSA2Vh5wVEEdMxd+AfHr0osdnOIDrd8PKScMRihlEseQ4k27O
	vS/uEgzGyvztxTvxLjprxxwa3XpFG7vcprWpSo1H1aamtg0vvkRvCiG94XuTKuzzv15Itu
	hnQP3bkAcOui4V0w5tEpVgN2dSG2m2w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=vcnGO8g8;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf03.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.203 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pi2-f11.google.com with SMTP id 41be03b00d2f7-cde559522c7so942715a12.0
        for <linux-mm@kvack.org>; Fri, 27 Nov 2026 01:08:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795770500; x=1796375300; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HBwnwSvBiq0QxdeEz8EUNpHvBkXWdsPgrdZSvJG6u68=;
        b=vcnGO8g8uegQx7qTE5MM020gd4igIG5eRnrahRcCtxixv98nzHhifxvf0Cu1Ri0Jax
         XlZLBojjFneAYpo6mw5UEw+EiVBuZj0ZuWr0gP6CbmjO2nIzXpkuwxZhkQF6LKtX8fb2
         kQspHwqEwNgc9qcs2tKJMPKG1uZjWczgClcDBeiBsm+gaIt3qLp+Y7D9uF3kFC23wJBC
         L5IRVnYBPKmsHbQxqBsJsTtuHCmMwTTs8uSAycymL5i2PVZFn4eEAbFiqvFHYtI1hzrm
         aE4B5zwNxX+ogCH/NtcR06dSc1CTMzTXKTXvaxpl0t+CCQhnpDikjnfM6dcJJZsl4px5
         2Vdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795770500; x=1796375300;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HBwnwSvBiq0QxdeEz8EUNpHvBkXWdsPgrdZSvJG6u68=;
        b=jFke9B5sBVjQRmH2i7cGOM10esruPXj1/sx1nOGYOCkeZYCSzjV2OXZal7rubpqGSQ
         jzHBCogbnQZaEk0/XmSvcGxZX6XxiFLHp/f+BJA0WXyOw7Z6kYfKEoJXM7LnyRJFbFE4
         9ttsrjDpw88bmwVI4vWjTcWrLCVzqHj8zTPkFLHmvLLKx9zYvqMz/S47tHoLDM98UPFO
         1Px8DTqCED0WygqncP+ecjOGYUBsORU/DImNygh/Vgf+GUMNFVSErBbMV5k6e2oL3lO4
         KB5bj3ajePzo1gfK+Kx5hWE93o1wcCaXwO3d4kn2wGeuWJ28t6SuAHcO0Xq33zgafBkD
         imRw==
X-Forwarded-Encrypted: i=1; AL+hErFbXPBSIsFGpx+nLVPs3Qm7nv6kIWpPVg5MKaHbJQttXxjKswCKUWnxP8R2tAE8M7MMnBYxPLgv2w==@kvack.org
X-Gm-Message-State: APuU4Z+6JejMyMh5d+SqJ9iumLejzbRBQDnFRcS8mb9fnAXxVSNPkIUe
	7A4ekWQHoiljHiOd3Q/GA+WUzsQOkIR3HjFDDls1NNtm6M3ZGywgHmVA
X-Gm-Gg: AZFdTZd6P43byBADcXaXsWpRa9onIUDewnQ+8dUcY6vPkrxCYcf3bGI1iCM796PjJ5Q
	TkjkFgKGMpOWUqYxdmxGblfl3M3G3UWXim2c5KTK13AZ0G9W5Mbk/4R0cgPtCSp8X30LLAr+l1S
	F3nJm5towOlG5UNT0vXstjKqcx5xecAgPBSaTWFr7n11TdsHx8kxZevxTSDfKFetbeIvc9Ndi8P
	zQ8kFX0NFfCXC6lyWj28HQ3ze2KYdzzwYlhBSN7s91gAfHWE4NsAcO7A7xZ8YKW5ejdFPQSwq2E
	/NeLCGFQvswpew7dLaY2PdQTfvMGT2WQirMbcMR9YQlNvm4e2puZK9/hJ6gFQMBhy5CDxdE6h0I
	KCBZvEICHeNN2hD+xFLCKoWOdNYCfiz44Hi3J/+QxaWubDLQD/mYyXTIfyxhKVPQJNpM7Siqxpw
	yIkUqhzoG+9w0zESI3tgdFaakO4y8yMoenDwRnvErSXWfFRPZaCvHZiS7gy91paLMt3835wtGak
	H8ZhVJJmoElt6afcZoa60nb/lJEmRpXeifUuecyLPVbtOdlaiFEIxsr2Tau/rYjE+tSL/bYgtzl
	xadglSlXL7JDV3YOWukQFJyh6Jv/4TgRTodHahYPoA==
X-Received: by 2002:a05:6300:6d93:20b0:400:77e2:eb03 with SMTP id adf61e73a8af0-4014d35f25cmr14065528637.48.1795770499535;
        Fri, 27 Nov 2026 01:08:19 -0800 (PST)
Received: from intel.company.local ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6d06ee37sm11718725a12.28.2026.11.27.01.08.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Nov 2026 01:08:18 -0800 (PST)
From: Wandun Chen <chenwandun1@gmail.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	robh@kernel.org,
	baoquan.he@linux.dev,
	rppt@kernel.org,
	m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	saravanak@kernel.org,
	akpm@linux-foundation.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com,
	ruanjinjie@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	iommu@lists.linux.dev
Subject: [PATCH v10 3/8] crash_core: serialize crash header preparation against hotplug
Date: Fri, 27 Nov 2026 17:07:18 +0800
Message-ID: <20261127090723.741253-4-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261127090723.741253-1-chenwandun1@gmail.com>
References: <20261127090723.741253-1-chenwandun1@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DD6FF2000C
X-Stat-Signature: xog3i9btgmipz9t7j4gx5qor8gq1j5j6
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795770500-739155
X-HE-Meta: U2FsdGVkX1+Mn4SG3ZVbQNrUYOVEeKynXTH+NsTBAYR3v7aLZjC7vIz0npDtNWou8xKiYmRu3vWv5cMXs2+cY5MzBE+XnCwlpPW2PZ+EqvX9cBPDSwZu2VTkbCLJI4b7GIRhvqJnBmgXCiStxoVKCiKnkyQd/AdRM9wrX/A7kmMdeHr4WZoYy1GNR3BO6VjWBghpDydK66R+ziAkX30v8/RJv81YHLcoubO2F/NC5PBTdhoMglhXkuGhb0JH2NBU19Mu/n9G3As/hPHLGWPHvuTwxx6HYJ2ZfhGOCVQv1XUK8VwDl4GlvBCQOBxmZTiztTYrdEPLpg97oTYKpAR7YRiB+tTYVC22ZLxjoQ/Zj4D0EZg+NpfA/e4/9ntYqp19bM48nK04+ISgIgr39lpWJck9uhUXwW/eDOmBHQal2H3QGNEg154C/yVx+c94yyLwDmyFFvFbE2feBlWNLYS/zyp6J0YtUgGGd+5ZvnrXWTVhMA84rqNpLOXw1VpxVzHlk7spmn41MgMxTuMrRLRf9jGJgGh6exnxJBObcZiLIab/g5IWjABTmrzjcpLC+8Fpjd2zj2wYHziSakWWpzIpEzCvnAOmADwIvjfjkbRPfhGV0O5msSon2bo2CyeFqy93ZG3EXL6agbfKV+5tJhtsSF25MGgrN3wm9n4jn3sUT2GNBNrePsOR8hP3HuCKbxnrrzWBWzmtpQmyprY33qQ7vxZ+OTUgKkgz5gHjsujbiIWf9bGPnFJyAYTcamR2ZW7Tj5LCNaArpGdkjPX8kMiXDLpatpFZ2ejK3vms8+4+27iqEloVocTlcjlcInLkpYutP6PLAICJu6y7QtNg+gyzg91AAZ1ujy6Pmf2kgZtBLIsg1hRS92JEOr5COLXL0ryL63UR/T7pQsEldPeGGuSOn5sk+7VVI9YwyY7YOUs/JOFcFXe4VaTM52QkidA54xd5CKBJY1hf3CRt8VoCRYm
 Kn1vz01x
 do2juj2EDj+J7gwL/EJkhbelFnC8UCijD3g8XNsrWskK0pCrgXbU3vpOXw2VLI3DFmZfe4V30LeI/bMKz31YQTZvP+6LRBp0RxqXXRebHNmJuOghSjN5TgkmcUR3YAU1+xG8ROM5G2wIsT7VDhoMNfXKfFnxjkGeymJ6jNWgdEClwH3MxF9oY/iP3C5uTPEhl9kdTdsWAYolgi7xInOaXua6SEHhL9urLN5frWG++SDHLGjqfSJ1T35jiHo+8TacEjRgy2PBsl9zdNwThmA3iSDGfH4Q41C4ttQUwmCVSxMMMWBz4UpOSZdHqTqvLry1nOsw5MO52cWeE18niCbz9zsLnNuAroIvSsGNGDq6CQiye5ghyEfq2DcXpRvEAYP28qWfISh8slH+Tlszl2Ry6NfqlhGEGV/2tlXmHZ495KF7lzOLGprFD+IQqg97Gw91tzRIw6mNG+m0vGAn0ldNv6d/rjxmvMCN09MqaKH1RQgB7mupfqTsSto1eO6TE+jHF7IPiRZqM/dKCcThsJxkZ2Q6KbCH+hqNNJ5+dQ4/M4iRiaXpX4O7n0jKZArqimtsIyJlcOY5KgzZ8hMwKVXMyFloRdNmmind9Rrk6O9xVaeh7aQ41Nt6bcC2lE5jdc6zvMpcz6gue6WbB5xg9/afrF8yqDpSka4dx+kX4mzRyzByyuNUsuhJMP99rW/lbL2C1hKquYlS+s1K/TXZ7BaArq51jHqL2GWTidIC4+9TqIsoS8RYe1/JAr0jPbEXFoj5B8zR2HiQjBE7pgdUqin5o1bRykzuvvVqEI/E6Y4x9NtOqgWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wandun Chen <chenwandun@lixiang.com>

crash_prepare_headers() counts memory ranges before populating the
allocated crash_mem array. The weak implementation used by ARM64,
RISC-V and LoongArch walks memblock.memory, while x86 performs the
same two-pass operation over system RAM resources. Concurrent memory
hotplug can change range source between the two walks and make the
populate pass overflow cmem->ranges.

Take device_hotplug_lock when preparing crash headers during
kexec_file_load(). The x86/riscv memory hotplug path already takes
device_hotplug_lock, so call __crash_prepare_headers() directly
to avoid recursive locking.

Sashiko reported this issue in [1].

Fixes: 3751e728cef2 ("arm64: kexec_file: add crash dump support")
Fixes: 1bcca8620a91 ("LoongArch: Add crash dump support for kexec_file")
Fixes: 8acea455fafa ("RISC-V: Support for kexec_file on panic")
Fixes: dd5f726076cc ("kexec: support for kexec on panic using new system call")
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://sashiko.dev/#/message/20260806101002.1F84E1F000E9@smtp.kernel.org [1]
Acked-by: Baoquan He <baoquan.he@linux.dev>
---
 arch/riscv/kernel/crash.c  |  2 +-
 arch/x86/kernel/crash.c    |  2 +-
 include/linux/crash_core.h |  2 ++
 kernel/crash_core.c        | 17 +++++++++++++++--
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/arch/riscv/kernel/crash.c b/arch/riscv/kernel/crash.c
index fe5a4b306aae..ac8df2edf2a7 100644
--- a/arch/riscv/kernel/crash.c
+++ b/arch/riscv/kernel/crash.c
@@ -70,7 +70,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	 * Create the new elfcorehdr reflecting the changes to CPU and/or
 	 * memory resources.
 	 */
-	if (crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
+	if (__crash_prepare_headers(true, &elfbuf, &elfsz, NULL)) {
 		pr_err("unable to create new elfcorehdr");
 		goto out;
 	}
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index e6f23933a6df..bef008a0cb22 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -465,7 +465,7 @@ void arch_crash_handle_hotplug_event(struct kimage *image, void *arg)
 	 * Create the new elfcorehdr reflecting the changes to CPU and/or
 	 * memory resources.
 	 */
-	if (crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
+	if (__crash_prepare_headers(IS_ENABLED(CONFIG_X86_64), &elfbuf, &elfsz, NULL)) {
 		pr_err("unable to create new elfcorehdr");
 		goto out;
 	}
diff --git a/include/linux/crash_core.h b/include/linux/crash_core.h
index bc087124cd78..28e7a81cf263 100644
--- a/include/linux/crash_core.h
+++ b/include/linux/crash_core.h
@@ -61,6 +61,8 @@ extern int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_ma
 				       void **addr, unsigned long *sz);
 extern int crash_prepare_headers(int need_kernel_map, void **addr,
 				 unsigned long *sz, unsigned long *nr_mem_ranges);
+int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
+			    unsigned long *nr_mem_ranges);
 extern int crash_exclude_core_ranges(struct crash_mem **cmem);
 
 struct kimage;
diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index faa0f22dbb41..8a861a946e26 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -16,6 +16,7 @@
 #include <linux/mm.h>
 #include <linux/cpuhotplug.h>
 #include <linux/memblock.h>
+#include <linux/device.h>
 #include <linux/kmemleak.h>
 #include <linux/crash_core.h>
 #include <linux/reboot.h>
@@ -344,8 +345,8 @@ int crash_exclude_core_ranges(struct crash_mem **cmem)
 	return 0;
 }
 
-int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
-			  unsigned long *nr_mem_ranges)
+int __crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
+			    unsigned long *nr_mem_ranges)
 {
 	unsigned int max_nr_ranges;
 	struct crash_mem *cmem;
@@ -382,6 +383,18 @@ int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
 	return ret;
 }
 
+int crash_prepare_headers(int need_kernel_map, void **addr, unsigned long *sz,
+			  unsigned long *nr_mem_ranges)
+{
+	int ret;
+
+	lock_device_hotplug();
+	ret = __crash_prepare_headers(need_kernel_map, addr, sz, nr_mem_ranges);
+	unlock_device_hotplug();
+
+	return ret;
+}
+
 /**
  * crash_exclude_mem_range - exclude a mem range for existing ranges
  * @mem: mem->range contains an array of ranges sorted in ascending order
-- 
2.43.0


