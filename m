Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B79CE606A327
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=OSi4f8xf
Received: by kanga.kvack.org (Postfix)
	id A597B6B05B3; Wed, 11 Nov 2026 02:53:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E2216B05B5; Wed, 11 Nov 2026 02:53:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8206B05B6; Wed, 11 Nov 2026 02:53:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 574C06B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:53:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C8BF580212
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:07 +0000 (UTC)
X-FDA: 85422072414.26.F1A633C
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id D1302A000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:53:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=OSi4f8xf;
	spf=pass (imf15.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794383586;
	b=EPK+fJ28Qp82qdPrOebF6M3zrBXATxqNGGheo95aEdaSVj/lNk9XJgbDK7Cay2U5QgCPFz
	CXWMapK6d8nFVTa4Cx/Nw8deRehW/WCSKgCHe3ceIP55fMX6W/q3U0QQCgg5v5yetMZkiF
	B9iTP+S+jon81LTM3HCKZ6z6Z0neDqs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=OSi4f8xf;
	spf=pass (imf15.hostedemail.com: domain of chris@chrisdown.name designates 209.85.128.43 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794383586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OO34thgIpfnBLKDxy+V7gJ/LfMCRQ5G6mslroPjHH60=;
	b=1hqbSn6rEpEFZQoPRPdLAsE6RIrUPyBd8tzQSSQFDH1UoUjM/s20Q4rp6DJbfUcoOfSt9I
	2DOSglWBTWw56r6Z2u5YFA2HXBwkMOfbkFVSW+/yJZvvUFKREWN5CusiPFyXlbhsP0idOh
	scazN+cz3wV9/5CnoC7ottBjXTUHxOE=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so16594445e9.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794383584; x=1794988384; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=OO34thgIpfnBLKDxy+V7gJ/LfMCRQ5G6mslroPjHH60=;
        b=OSi4f8xfkYvnYiFSlHeJZrVzO2/dLdaH/7MeEiUovUVXxoRqJ1AEOI5ACMRIqTsKV2
         Zf3LAVcKZ9eBFc70dRne5j5aclUgBOicwG5fe7C6tUPEnLs4GyfheAWovrmH0qg7b4qM
         5sDqwS8LjbE8LhL88upKBv51FL2h5KISvsDTE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794383584; x=1794988384;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OO34thgIpfnBLKDxy+V7gJ/LfMCRQ5G6mslroPjHH60=;
        b=PxY1rDrcHwd5YCFihA9LwTtorjEyAG7JLTyu/+eCbmZGb+FGEX0D7pZZaoRsUo6xve
         QBt/vBCad5x8ExHILaHeMNwMZsEUO9OgZAEEBQbErifJwl5EOBmR+6AzQSMZr0szFoG8
         s5VO3onibDHwYNaWIcroBy1GeoJk0kFg4ObQtmXidy4XSeUNzMf5wgL14m0s3wDLPgng
         Y3K2Bm4Q4G0sy1n9xGnI5BI4NK90bvcVGR5HrwR9zQ4MyLu2k3guf+H4hszFsXua8sEr
         FkTmA+JM4+hFRoiU+ZuLitMZHtsd3P8NE5BMIQRHZVtWTOCVxyLKDubrAhcFBSx9pvnR
         YV8g==
X-Forwarded-Encrypted: i=1; AL+hErHsVOadEkDRugwZTx8MgvBQ6ZlWER3y+lwsaPeQJwqEAbWKrRcO700Hi3RdbiQJ4xTaDldg2q/0hQ==@kvack.org
X-Gm-Message-State: APuU4Z/CBT4eQD36TpB6GflyPCc/IbxzBG4TbIOED0YMeE9UH4I7wwUu
	GLD3LaNyNQ8FaLioMprtL08q6dhe3NGo9zXoTPZZ0W16WP6NXw5JMgG17h0BhlSZYuI=
X-Gm-Gg: AYBFou2ucmU0WtKtxXO5flBAWy273yIrBvVvAujeuqrwfaiSDhcqY9C/MpASOBIwof1
	1beTcc2LsV9T/vQi2+DHFset1qKOVINY48VP4skIVVE5iXLo29aR5HgIIec7ptS4oC4L1McWhQx
	2mI77YLUcWHEQXmRTAJMsqjgl7fR352NNsGhL6Zhhn4b3xN4TON0ZToBZWzjr806opzmbCWugUR
	mKXx9mCpwRqPAmtblnNJOI3zVZFgI6OqaiO/AUYJRDuqF1qXDfifsd91nMll0/XXcd9ekQIkPb6
	lNn0VSH/5pE2b33mD4RRUhojdZ7mFviC37KoAq0BctUGIzFb8KJjbbBiTzELOnhom/B1hEGIQPG
	oW/DFjlv7Os/y0itLp8MqxdPsJ7J0sI8QoD8ulCrC1ZaGjrCedd2cG4wj+odAbsK27AtrKQ5KnN
	zEN5DHZdDgOpFx4ZhK2EzOYTmdzuufjQ1IVvnycbQV1m+M9jUSwoXGrxS+fgMfe+9/g/Bqm+em5
	oU/xUFf4oWaL+asWW6srE0hSA2jzHvTseSqS9sJ45/GEBMEtgreboIoTB0VQsovYFX9Y0AYBy9Z
	tl5mNtJyei1juvMRwtFphoGatLZxRjn1rfqhbQMjcfcoSXbnRDtze8N045B8TfA82IrOYlerCPF
	nbM35LZO2LkyXBkilDmkiTWrftl/XIAZsGU6xeBlJBU2nlt29ubz43Ylcow+FHWoF9tsejZHCNH
	21GnPvxlteqixiN2t68O7hZ1GiSGCS7wCQeWR7dsDWuhBR8xNuwaEy
X-Received: by 2002:a05:600c:3508:b0:4b2:3c81:d1 with SMTP id 5b1f17b1804b1-4ba093811c8mr23533605e9.5.1794383584057;
        Tue, 10 Nov 2026 23:53:04 -0800 (PST)
Received: from localhost ([199.201.64.8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4ba0203a763sm120391615e9.4.2026.11.10.23.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 23:53:03 -0800 (PST)
Date: Tue, 10 Nov 2026 23:53:01 -0800
From: Chris Down <chris@chrisdown.name>
To: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Baoquan He <baoquan.he@linux.dev>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/9] kho: Make bootmem reservations visible to fleet
 monitoring
Message-ID: <c41c639fc5f453d60a265ba42a233f2ea5b48319.1794383544.git.chris@chrisdown.name>
References: <cover.1794383544.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1794383544.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Stat-Signature: wckjfabysafjndnz8ossa5pcjt1f43aj
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D1302A000B
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794383585-817086
X-HE-Meta: U2FsdGVkX18EHxkclmon51XixVxMyXGa7dAdAZDavt8vtghSR5nJ1v61YM7yR8APvhPwVUpJszilHdHZ/djOpQW/G6uRFAylmYcuIOGL2Dh8bLrzNZCXL+Mac7Sm4cftpliWa5iLZrwic0FB9yqVMivuPAxR/Qiq2L9RmNAdXsH40rQ1dDCjSoICb+11+RH0vQhC7fCzLdAy4gkLaSqZ+bdBNKciebTrl+bUpxGD3DBmpLjC//hWA8Gbr9u9w7XAtH3CaOYBQjbgu5P8lL88Hr28yzzWVQBiZCKQQIgU7+OOJsRGzCiDmFR/bVkI5U5bXgxIOMKScYwiZZjQt9f8tFwxUBIUpaMbmAHJIRHQFn3sWkmZxeNNwmhM5BUHi3Q83FqBUedfV4SAhULONFhiwOM7WGLfHhpUlcdyUKquaQgw8pZyB6wYJERG4CU7DZh32+qFQ4Km7BLGEUYsm2M+q7tjLAMyjnUxheLqCDujN7gsp3lA7HjHjj9Aix+SSx+p8JIAmsCjxa5Hc7/aPIjHlITNHfFd3zZdGu2tiFhWOqT+dvWuFvr91PDnaHtoDcIcTfmlJ6yRKP959nEbfA3q1S/mJKjLNyy8O23giyD807tA4uDUDWrdWOba6YWNzb+M5Ob5IP4HTo45SouqM/WfayKgTWMbisNvFa7dLttbZupW/nIF/7sCsNDTKmRjTX0xjfa25g/Yudh6RgqwKBRib5ZNRNVag29qs9pO5UnkYn/nFNCgRvJZIZWkVRHWXHQtqO8foIUI9gioOT+odyXFcSvC4bAABKWBFwVcZSroKNmlXisruJW5kIlzbRZG7sS0vVoGqkmuZwyFQ6a48wEecNv4733JCp9p3xdTqEWimXwEC01T6deKsv/PQWvt89iT8XL722dKQmWv5E9kgUhDtPF5hJkeB2L+6FRyncSNdMHW67JiwdJap5A04Bf6HiVfqm34lv4nna2gd+aSUTa
 Gb6kt/fa
 SKOpy35JLEoH9IHbCHQxobc6vVB89YucXMaUWDV4+NKBHD1xX0ndajrVPy7JzO6F7+VvVlUwlfd9G4SQVikHM1oULNJvLxtIPU/0lSV+n+hMu4DQKvqAHyS11C2VHmJ5udHt60fFihHXY/P6DXOgIdrn+VyAZRs/iuU77nptYIOh+if5eeMM86cuaVTdKGvN+FkdpEEbnHKiUkTy/2Dgx9kW+Tt+UyPcB/LpWyatomW1/Bqg4VrKhvJJTv5WVocC0c5WzPmQudzJY1qrtfyMONMxJovyaCehYLkdblsLUwHyKdUVnwoEI41XjfzyJtNKSAdxmh5wRDikRpJyqTpPkN+Y57jadpN9fvyj9Zn8ihYofeLbq6oGnJ4Yg1fTNL8Skhy7WIRhJzd2uET3LbcFUlsB8GatE+yYSvIZxK9vCWAaxA7f6Hdt9CNXgrcR612grzRXrb4pdiHwbysle8uxyJ4uf5f8+TDZfB7LdCG6xYV4R3N8NgCzl8goObnHq0h7bFoTuytZBJAhHOdvdwn9+JDxx9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

We want to use live update at Meta to upgrade hypervisors whose VMs
can't be migrated away first. But this poses a problem: whether we can
enable KHO on a class of host depends on how much memory it leaves
available for unmovable allocations. In an early test, a 64 GiB host
with hugetlb_cma=6G set aside about 30 GiB of bootmem, which the running
kernel can only use for movable allocations.

The reservation varies with the kernel, memory size, NUMA layout and
command line. Our fleet collector needs the actual size from each host
so we can decide where to enable KHO and catch a kernel release that
takes those hosts over their bootmem budget.

Today the collector would have to sum kho/out/bootmem_len in debugfs,
which isn't a userspace ABI. In /proc/meminfo, free bootmem contributes
to CmaFree, but the reservation doesn't contribute to CmaTotal. The cma
count in /proc/zoneinfo includes bootmem after a cold boot but not after
a KHO kexec. On an 8 GiB QEMU guest booted with
kho_bootmem=32M,1536M,512M:

                CmaTotal  CmaFree     zoneinfo cma (all zones)
    cold boot   0 kB      2127872 kB  2129920 kB
    KHO kexec   0 kB       881336 kB  0 kB

Even if bootmem becomes a CMA area, CmaTotal will still include other
areas such as hugetlb CMA, so inferring the bootmem size is still
error-prone.

Let's report the total bootmem reservation in bytes at
/sys/kernel/kexec/kho_bootmem_size.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 .../ABI/testing/sysfs-kernel-kexec-kdump          |  8 ++++++++
 Documentation/admin-guide/mm/kho.rst              |  9 +++++++++
 include/linux/kexec_handover.h                    |  1 +
 kernel/kexec_core.c                               | 13 +++++++++++++
 kernel/liveupdate/kexec_handover.c                | 15 +++++++++++++++
 5 files changed, 46 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
index f59051b5d96d..80941a7d8a7c 100644
--- a/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
+++ b/Documentation/ABI/testing/sysfs-kernel-kexec-kdump
@@ -59,3 +59,11 @@ Description:	read only
 		to the crash (kdump) kernel. It lists the start and end physical
 		addresses of CMA regions assigned for crashkernel use.
 User:		kdump service
+
+What:		/sys/kernel/kexec/kho_bootmem_size
+Date:		Nov 2026
+Contact:	kexec@lists.infradead.org
+Description:	read only
+		Total size of the KHO bootmem regions in bytes. Returns 0
+		when KHO is disabled.
+User:		system monitoring
diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index f9d2cc5999ee..c329d720bf25 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -81,6 +81,15 @@ At scale, correlating crashes to the previous kernel version enables
 faster root cause analysis when issues only occur in specific kernel
 transition scenarios.
 
+sysfs Interfaces
+================
+
+``/sys/kernel/kexec/kho_bootmem_size``
+    Total size of the KHO bootmem regions in bytes, or 0 when KHO is
+    disabled.
+
+See Documentation/ABI/testing/sysfs-kernel-kexec-kdump for the sysfs ABI.
+
 debugfs Interfaces
 ==================
 
diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index ef2b188c8ed0..736d51e79fd2 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -40,6 +40,7 @@ void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t bootmem_phys,
 		  u64 bootmem_len);
 
 bool kho_bootmem_overlap(phys_addr_t phys, size_t size);
+phys_addr_t kho_bootmem_size(void);
 
 static inline enum migratetype kho_bootmem_migratetype(unsigned long pfn,
 						       enum migratetype mt)
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index f4a31565c447..ed105e6351eb 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/fs.h>
 #include <linux/kexec.h>
+#include <linux/kexec_handover.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/liveupdate.h>
@@ -1324,6 +1325,15 @@ static struct kobj_attribute crash_elfcorehdr_size_attr = __ATTR_RO(crash_elfcor
 #endif /* CONFIG_CRASH_HOTPLUG */
 #endif /* CONFIG_CRASH_DUMP */
 
+#ifdef CONFIG_KEXEC_HANDOVER
+static ssize_t kho_bootmem_size_show(struct kobject *kobj,
+				     struct kobj_attribute *attr, char *buf)
+{
+	return sysfs_emit(buf, "%llu\n", (unsigned long long)kho_bootmem_size());
+}
+static struct kobj_attribute kho_bootmem_size_attr = __ATTR_RO(kho_bootmem_size);
+#endif
+
 static struct attribute *kexec_attrs[] = {
 	&loaded_attr.attr,
 #ifdef CONFIG_CRASH_DUMP
@@ -1335,6 +1345,9 @@ static struct attribute *kexec_attrs[] = {
 #ifdef CONFIG_CRASH_HOTPLUG
 	&crash_elfcorehdr_size_attr.attr,
 #endif
+#endif
+#ifdef CONFIG_KEXEC_HANDOVER
+	&kho_bootmem_size_attr.attr,
 #endif
 	NULL
 };
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 3046b89e5db4..21d77e29d2bb 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -942,6 +942,21 @@ static void __init kho_reserve_bootmem(void)
 	kho_enable = false;
 }
 
+phys_addr_t kho_bootmem_size(void)
+{
+	phys_addr_t size = 0;
+	unsigned int i;
+
+	/* kho_init() can disable KHO without clearing kho_bootmem_cnt. */
+	if (!kho_enable)
+		return 0;
+
+	for (i = 0; i < kho_bootmem_cnt; i++)
+		size += kho_bootmem[i].size;
+
+	return size;
+}
+
 /*
  * Look for free blocks of 1G. This is a heuristic chosen to work efficiently
  * with large systems with hundreds of gigabytes of memory. It will work poorly
-- 
2.54.0


