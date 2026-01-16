Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5D5FC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:50:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A1D26B008C; Fri, 16 Jan 2026 10:50:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BFE6B0095; Fri, 16 Jan 2026 10:50:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379346B0098; Fri, 16 Jan 2026 10:50:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 25DB96B008C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:50:35 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA11CD187C
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:50:34 +0000 (UTC)
X-FDA: 84338264388.29.EBBEA48
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	by imf14.hostedemail.com (Postfix) with ESMTP id 19314100014
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:50:32 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	spf=pass (imf14.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=breno.debian@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768578633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWaLEplWq59uIHotHJ6qgSbmWWLE1NGtyoDG+TZxz50=;
	b=twKnjBRNfmmk/de5V/VFcqbt67xwzC6RBiLMb3zJAqO0HXSUMnXVbexuUaGefB4hDM5Ur0
	tIIjnyRtnO0waIBd/ELamdqoWeHG5ccHlFKVYPs35aWOTjDIFQ6tiaqgEf/opV6ogPX2s7
	IO/SdB+8lPv/4pI0sn5mTHvkdmD4EJY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of breno.debian@gmail.com designates 209.85.161.42 as permitted sender) smtp.mailfrom=breno.debian@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768578633; a=rsa-sha256;
	cv=none;
	b=FW2EiRDtN3RVd9oe38L7K1Ru/mAFf/5jhSaY1NtrsD07SMH396hMvdTXiPdvUp768BIHyT
	Mz7EUJ0pwhC+HeYVJVaBy82QNdB8Q/Nga52ASy4djZZJhGx7q1H+TtDuvNDCwEPbOJpyRR
	UaCnt6b9WunNf1ybIQcMs9ijuuLnws0=
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-6610800b78eso822552eaf.0
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:50:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768578632; x=1769183432;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RWaLEplWq59uIHotHJ6qgSbmWWLE1NGtyoDG+TZxz50=;
        b=gkZSIQsWoweoIlVX0loAPywaZXXqr7ag6rg92/Xmd9UrSFgX+ry1LX35qfOegNshI0
         7ZpHqqWWp8aPyMpQxixC2aD5yaHodNnzcbE8mNprbbW703O8YduzLbZJNyqeAiFfpg/u
         ABvumcba95RyX6i02oRXJEFAbYg8LTDy8O+LseuSpsffXBH5PHnHjPc1Rndc9DePT3ZU
         P/zoACeajkFTBZqMz/LW90nxAUHXS29n1IP629ocLt1h6rQNlCOFNirO3gY4QUIAPHxd
         Un8aNgL1+x8tbtMGEWeyVdNepHB3UuLLNMdhlkk+uM3S2zHjhmX5k2IOEoc7haVyAeCP
         V4pg==
X-Forwarded-Encrypted: i=1; AJvYcCXyssHHH/2pykA1swjdqfvPzoaU+XtxuiZojjfFE40tgmKCpMkts9Gr7GO0JznL7DNZ4YeXDPz2JQ==@kvack.org
X-Gm-Message-State: AOJu0YyfhedcGj6AMAyAYP34IJVHh3EQWB3qC/1Mv9YwN6ZlIo9BM6/9
	iKxU3Nqncn0yAM27ZNtRFpFo5Nc4I3AkRDDLt64XEwtS1WT0GnlKDrmz
X-Gm-Gg: AY/fxX72Ioh4DMejqJnEE4yVd9jdrFIDpnAMDSk8yVAvJaLxq1TnMpV1WVIF4uc3NNE
	E8otv8TMX0p7g0Ko8PrpdFRgzVqephmyj8RG2lxBeq39n5uW7ZILYqHMCmhLIvUMaefFv5Yug1m
	oiWDvyvALVKkc4BRDIE77jcbfXa4kPvM7cQZGuD0x9E151qjIQMPwcAGxGO5s0dAOcTAEd+jVCA
	GaSR2uJWJhCmJBJclGYLeypkPU5hu/ZOoKlrpKBG7vgNjjGkQeWf5BlZln1EQOvU5lrVEyYqzQz
	XwXkFxNsRnYt+vCiHMHpwDCnGZCLqHSZicUAzlXV8CMw4DuUBWMEolJ6569b/F/VFHz5OmTC3k6
	7tdZWthtIKQbFBzJ/zcTVZF5navtQYhyV3dEnFyZRVvMTjKhzR9l2YCQS5kcBau1GD+Lew2y/K8
	HLnxdaj+TD9x0G
X-Received: by 2002:a4a:ec41:0:b0:65f:64eb:8ff5 with SMTP id 006d021491bc7-66117a392c9mr1173720eaf.81.1768578632024;
        Fri, 16 Jan 2026 07:50:32 -0800 (PST)
Received: from gmail.com ([2a03:2880:10ff:42::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6611a78b02fsm902856eaf.9.2026.01.16.07.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 07:50:31 -0800 (PST)
Date: Fri, 16 Jan 2026 07:50:29 -0800
From: Breno Leitao <leitao@debian.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
	riel@surriel.com, kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] kho: history: track previous kernel version
Message-ID: <v7g7nmd3jif6vftvnmucvpluevufcdxmefcgqq3yfpnzyb7mql@ojpotuu4hgxm>
References: <20260108-kho-v3-0-b1d6b7a89342@debian.org>
 <20260108-kho-v3-1-b1d6b7a89342@debian.org>
 <2vxzy0m0gfyo.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2vxzy0m0gfyo.fsf@kernel.org>
X-Stat-Signature: 3yfybwjhdrs1nk3yk4wt8kqx3gbb13ag
X-Rspamd-Queue-Id: 19314100014
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768578632-394509
X-HE-Meta: U2FsdGVkX19fNURP125j6RNxyfs36sFShLgX9JzEOWMpGj2ZnfNmhMY1tIFrbLWfN+uGdd7UeZ2GMVTQAla/kpHJgOyEEHzNU9y0DRdHQ0ORgGz+9GyxfoVZhZ83aKonXEWONG6fTFMZ9F/iGtVAF6aSFhOWyZiK7wig+WVUO39XjpyYTlbjk0bSJVla9TECfCIiiZAvQ94Wlra58lhFLnJSjXypDNU0ZapYzpSeVfJJIxQsXHpsLSqP7L+mrtsTfQetmDXu7/kJ191/Bs3SHPlZOOuwr6j0IjjACE/KnhVLpwL/W3WKLekKgciljI7fVPDo/4eTF0f84q4i/S+JVc1JhdT+WGklyCBFDpjBS+rogTkphWmqgwv+j8JzxUQdGzUyJ1L1wJGf46Sy3DG5+CzHqXW7KzK/Mu8HNbSqVQLdv6EDM1IlidnPFkTjIXFsdsLhiZyghzqRI7XPKrs/SdU4WsTCzFKuhEiPnnauO0wjmSLcOqkYu4mMkbwp4PxF8uUUeHJYLavtMN4U7kt9s/6qJ+K3RUcwEE49h7OtFc2+fzFjX6/WcKLHJXbVh0JF3h2f7odaZjLr9cKOgKitNXKfTYd6FVR0nckAszpBP8PzeaKMXW1pEDfIVCZy5BdoPHX99yJ6LY1eRcbu9SXt/UpFa/9CZ93V8HBR2QiBFh/XD59PDVCoBD263zQgbKiF/F6KE+sQp0L4l6/GJWKLcTF254Cxe6vE9YAgyxLsa5MwQuD/Utlvl7AVzyj0kIfu+S/zDxwyIkLLDD6ENJCSQUKG4M4s1X2NiyFQ61movJBmGdIsj/4BjPn5LWMLL7qMoftWAqaIV22WR8UOfE6pWVEjqAm3GGGTx22UhMJzJIkDb6Bb5Wnf6jtk0wKgBPrxkkOK5tuDrfeDi6NtPQimGfRLMbCFizKpzsAr+0QkuIagf5FpI9zpabFydJ3VvVS+YcsWu+Sq6D6pazijoB4
 YFAJaJd8
 mphg22c+Xs97BkVxwPxXewz9q2k03/AXUzShtd2pMLQl9ryH4vpXM72G/XIl+rIE+/V7HgU4TQ3kyu6lcQFgdyBDuwjm9jOpx9FCc1pseHE8zZUqyUVOp7WQQ8oH44LkIQN5U+1xpi+y2Ok1HxHzu7KF37wFPoZKfcIeHFqHoCkcm5AvxvmRlDE1Zn5e6cEiIxH2dUBlI5/17fwYm0yIPzkW5z1HZFpADghgDgJ3Qfki7ZGjPruGOD66401dpR9vMuPMW2VefUSpjTEAhzLFz4QXj+VmfA8cFVodi3D2W2ktu0/ud0GHhxdKXDwo1+WMifmUQa511lp/kl8WbrOnqkUuA0grNoqRvCXqAaDLAQSPieXlUj9kk7+OeUt87auVNnV7nlOCLwXsPYuI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Pratyush,

On Wed, Jan 14, 2026 at 07:19:11PM +0000, Pratyush Yadav wrote:
> On Thu, Jan 08 2026, Breno Leitao wrote:
> 
> > Store and display the kernel version from the previous kexec boot.
> >
> > The current kernel's release string is saved to the "previous-release"
> > property in the KHO FDT before kexec. On the next boot, if this property
> > exists, the previous kernel version is retrieved and printed during
> > early boot.
> >
> > This helps diagnose bugs that only manifest when kexecing from specific
> > kernel versions, making it easier to correlate crashes with the kernel
> > that initiated the kexec.
> 
> The KHO FDT is ABI. So you should be bumping the version number when you
> make changes to it.
> 
> But honestly, adding this "optional" stuff to the core KHO ABI makes me
> uneasy. I say optional since it is not needed for the main functionality
> of KHO. Making this a part of the ABI increases the surface area we
> have. The more things we stuff in the ABI, the more inflexible it gets
> over time.
> 
> Any changes to the KHO ABI means all consumers also need a version bump.
> This includes LUO and all its users for example. So I would really like
> to avoid adding optional things in core KHO FDT.
> 
> The easy fix is to add a separate subtree for the optional metadata. You
> would still need to create an ABI for the data format, but being
> independent of core KHO, it will make it more flexible and easier to
> change in the future. You can keep the code in kexec_handover.c.

Thanks for the feedback and guidance!

I was able to hack this a bit and I came up with something like the
follow. Is this what you have in mind?

Author: Breno Leitao <leitao@debian.org>
Date:   Fri Jan 16 06:42:56 2026 -0800

    kho: history: track previous kernel version and kexec count
    
    Use Kexec Handover (KHO) to pass the previous kernel's version string
    and the number of kexec reboots since the last cold boot to the next
    kernel, and print it at boot time.
    
    Example output:
        [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)
    
    Motivation
    ==========
    
    Bugs that only reproduce when kexecing from specific kernel versions
    are difficult to diagnose. These issues occur when a buggy kernel
    kexecs into a new kernel, with the bug manifesting only in the second
    kernel.
    
    Recent examples include:
    
     * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
     * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
     * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")
    
    As kexec-based reboots become more common, these version-dependent bugs
    are appearing more frequently. At scale, correlating crashes to the
    previous kernel version is challenging, especially when issues only
    occur in specific transition scenarios.
    
    Implementation
    ==============
    
    The history metadata is stored in a separate FDT subtree registered via
    kho_add_subtree(), rather than being embedded directly in the root KHO
    FDT. This design choice:
    
     - Keeps the core KHO ABI minimal and stable
     - Allows the history format to evolve independently
     - Avoids requiring version bumps for all KHO consumers (LUO, etc.)
       when the history format changes
    
    The history subtree uses its own compatible string "kho-history-v1" and
    contains two properties:
     - previous-release: The kernel version that initiated the kexec
     - kexec-count: Number of kexec boots since last cold boot
    
    On cold boot, kexec-count starts at 0 and increments with each kexec.
    The count helps identify issues that only manifest after multiple
    consecutive kexec reboots.
    
    Signed-off-by: Breno Leitao <leitao@debian.org>

diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
index 285eda8a36e4..da19d6029815 100644
--- a/include/linux/kho/abi/kexec_handover.h
+++ b/include/linux/kho/abi/kexec_handover.h
@@ -84,6 +84,29 @@
 /* The FDT property for sub-FDTs. */
 #define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
 
+/*
+ * The "history" subtree stores optional metadata about the kexec chain.
+ * It is registered as a separate FDT via kho_add_subtree(), keeping it
+ * independent from the core KHO ABI. This allows the history format to
+ * evolve without affecting other KHO consumers.
+ *
+ * The history FDT structure:
+ *
+ *   / {
+ *       compatible = "kho-history-v1";
+ *       previous-release = "6.x.y-...";
+ *       kexec-count = <N>;
+ *   };
+ */
+#define KHO_HISTORY_NODE_NAME "history"
+#define KHO_HISTORY_COMPATIBLE "kho-history-v1"
+
+/* The FDT property to track previous kernel (kexec caller) */
+#define KHO_PROP_PREVIOUS_RELEASE "previous-release"
+
+/* The FDT property to track number of kexec counts so far */
+#define KHO_PROP_KEXEC_COUNT "kexec-count"
+
 /**
  * DOC: Kexec Handover ABI for vmalloc Preservation
  *
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 3cf2dc6840c9..fd22b0947587 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -15,6 +15,7 @@
 #include <linux/count_zeros.h>
 #include <linux/kexec.h>
 #include <linux/kexec_handover.h>
+#include <linux/utsname.h>
 #include <linux/kho/abi/kexec_handover.h>
 #include <linux/libfdt.h>
 #include <linux/list.h>
@@ -1246,6 +1247,8 @@ struct kho_in {
 	phys_addr_t fdt_phys;
 	phys_addr_t scratch_phys;
 	phys_addr_t mem_map_phys;
+	char previous_release[__NEW_UTS_LEN + 1];
+	u32 kexec_count;
 	struct kho_debugfs dbg;
 };
 
@@ -1331,6 +1334,48 @@ static __init int kho_out_fdt_setup(void)
 	return err;
 }
 
+/*
+ * Create a separate FDT subtree for optional history metadata.
+ * This keeps the core KHO ABI minimal and allows the history format
+ * to evolve independently.
+ */
+static __init int kho_history_init(void)
+{
+	u32 kexec_count;
+	void *fdt;
+	int err;
+
+	fdt = kho_alloc_preserve(PAGE_SIZE);
+	if (IS_ERR(fdt))
+		return PTR_ERR(fdt);
+
+	err = fdt_create(fdt, PAGE_SIZE);
+	err |= fdt_finish_reservemap(fdt);
+	err |= fdt_begin_node(fdt, "");
+	err |= fdt_property_string(fdt, "compatible", KHO_HISTORY_COMPATIBLE);
+	err |= fdt_property_string(fdt, KHO_PROP_PREVIOUS_RELEASE,
+				   init_uts_ns.name.release);
+	/* kho_in.kexec_count is set to 0 on cold boot */
+	kexec_count = kho_in.kexec_count + 1;
+	err |= fdt_property(fdt, KHO_PROP_KEXEC_COUNT, &kexec_count,
+			    sizeof(kexec_count));
+	err |= fdt_end_node(fdt);
+	err |= fdt_finish(fdt);
+
+	if (err) {
+		kho_unpreserve_free(fdt);
+		return err;
+	}
+
+	err = kho_add_subtree(KHO_HISTORY_NODE_NAME, fdt);
+	if (err) {
+		kho_unpreserve_free(fdt);
+		return err;
+	}
+
+	return 0;
+}
+
 static __init int kho_init(void)
 {
 	const void *fdt = kho_get_fdt();
@@ -1357,6 +1402,10 @@ static __init int kho_init(void)
 	if (err)
 		goto err_free_fdt;
 
+	err = kho_history_init();
+	if (err)
+		pr_warn("failed to initialize history subtree: %d\n", err);
+
 	if (fdt) {
 		kho_in_debugfs_init(&kho_in.dbg, fdt);
 		return 0;
@@ -1425,6 +1474,61 @@ static void __init kho_release_scratch(void)
 	}
 }
 
+static int __init kho_print_previous_kernel(const void *fdt)
+{
+	const char *prev_release;
+	const u64 *history_phys;
+	const u32 *count_ptr;
+	void *history_fdt;
+	int history_node;
+	int len;
+	int ret;
+
+	/* Find the history subtree reference in root FDT */
+	history_node = fdt_subnode_offset(fdt, 0, KHO_HISTORY_NODE_NAME);
+	if (history_node < 0)
+		/* This is fine, previous kernel didn't export history */
+		return -ENOENT;
+
+	/* Get the physical address of the history FDT */
+	history_phys = fdt_getprop(fdt, history_node, KHO_FDT_SUB_TREE_PROP_NAME, &len);
+	if (!history_phys || len != sizeof(*history_phys))
+		return -ENOENT;
+
+	/* Map the history FDT */
+	history_fdt = early_memremap(*history_phys, PAGE_SIZE);
+	if (!history_fdt)
+		return -ENOMEM;
+
+	prev_release = fdt_getprop(history_fdt, 0, KHO_PROP_PREVIOUS_RELEASE, &len);
+	if (!prev_release || len <= 0) {
+		ret = -ENOENT;
+		goto exit;
+	}
+
+	/* Read the kexec count from the previous kernel */
+	count_ptr = fdt_getprop(history_fdt, 0, KHO_PROP_KEXEC_COUNT, &len);
+	if (WARN_ON(!count_ptr || len != sizeof(u32))) {
+		ret = -ENOENT;
+		goto exit;
+	}
+	/*
+	 * This populate the kernel structure that will be persisted during
+	 * kernel life time, and the fdt will be unmapped
+	 */
+	kho_in.kexec_count = *count_ptr;
+
+	strscpy(kho_in.previous_release, prev_release,
+		sizeof(kho_in.previous_release));
+	pr_info("exec from: %s (count %u)\n", kho_in.previous_release,
+					      kho_in.kexec_count);
+
+	ret = 0;
+exit:
+	early_memunmap(history_fdt, PAGE_SIZE);
+	return ret;
+}
+
 void __init kho_memory_init(void)
 {
 	if (kho_in.mem_map_phys) {
@@ -1513,7 +1617,10 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	kho_in.scratch_phys = scratch_phys;
 	kho_in.mem_map_phys = mem_map_phys;
 	kho_scratch_cnt = scratch_cnt;
-	pr_info("found kexec handover data.\n");
+
+	if (kho_print_previous_kernel(fdt))
+		/* Fallback message when previous kernel info unavailable */
+		pr_info("found kexec handover data.\n");
 
 out:
 	if (fdt)

