Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37EC5CA0FF9
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 03:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639E66B0008; Fri, 29 Aug 2025 23:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9556B0012; Fri, 29 Aug 2025 23:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D9216B0022; Fri, 29 Aug 2025 23:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38B686B0008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:54:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9B1CC1DEFA7
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:54:38 +0000 (UTC)
X-FDA: 83832057036.20.B033F6C
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id C3FB4140003
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 03:54:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F6ikJcbJ;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756526076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHFGo9W7eW3FNHqfM+6lf2O3Swyw6p57AIvNgz1gl98=;
	b=g/X0s2Qr8wU985mUHiUWaARmweY0NB7f016UhfcOi/k1OuEeq55LaHWhdeYI6gKxHbaDeJ
	AiPovtEhHLDtzA2KE/4S+++4rCNowwhd9BXqLx1X1ziYhAK+XQzfE/EvhWczhri0aHv0/m
	RH/hu9UjAGkcOEhJ84v/7KTDqevnR48=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F6ikJcbJ;
	spf=pass (imf23.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756526076; a=rsa-sha256;
	cv=none;
	b=c5QoDhGyW++djJYFWnkPD5CXWCGrh2oDUw4xK+ow6NzAkZnKJjEWE6myG2l5GndROJXKGM
	ygpyck2jk6c5xbhlIDQAY8Oev4QLxAbz3MLIJ6nfrsimVRxeRCvvwXnKHfPA+4VeFvNMRA
	n8nMPY2lwfMl2wf2S5AV0OxSelJ1snw=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-324e6daaa39so2579027a91.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 20:54:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756526075; x=1757130875; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHFGo9W7eW3FNHqfM+6lf2O3Swyw6p57AIvNgz1gl98=;
        b=F6ikJcbJ+dd79E0oMsUj4o8IVawQrg5m2bxdDFEdV6LqL54OjsbrRSKYWuKCmNYK+C
         O7oHd+YiOC+hFOp67XXp2mTFi7g+ruuMpQgGPGdg6FwGb8VkgG3wpIZ9tsFYzKisi+9i
         4Smg3W+t5Bnoe/Lhv+uLQg0vQAtMxVB4J6TXCVeA1Ky7Rc2dr8Kx2gcLiN6wYFqzE31B
         EQZLxFaQ4v2I4ligi1rhSY/UpNCU729B2SVrYWC5IPEiRIUMszcBhNYuP3htoWNdg4l+
         2OMn7dzyCZUKloMWe9CNqRigwLnCTVZL/80PU6JJvYR/zt3z7OtVlcsn/9048PiYpOQM
         qdcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756526075; x=1757130875;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PHFGo9W7eW3FNHqfM+6lf2O3Swyw6p57AIvNgz1gl98=;
        b=XqiDjZf8ntIx6J0qVoIGpSB9/3GL3yhnzOpnImW6lkkREb3IGllmLJC1K7Fv5h4q5b
         +DX6p7pRIBCkcIX3LHlQX2koXDq+4mkA6n34PAtg1zfDAXbfo7l7hWU3kYHIP3pwMLju
         mpunxhWcq8hxOEI6W8ps9fpvNri+6QuRQY5t4Q1heMzO92C9UgV5UypRKM3qdNrZSaxO
         NJsnHozzMm3Pf8RY47l7UMjFAb4uPo8AdO3SJAunydJsoqV0kQA3hyUbrXGO92X7Z3l3
         s6F30AeO2r0DYJ7bdoICRrX3TnMfEStgbjUyqeih8yL/q/+tCg5dgof2vGkq5dmObrDB
         j+Hw==
X-Forwarded-Encrypted: i=1; AJvYcCWFavFjXKJjTDrOEG+ZUDGmjx9c+pj52toqxEW+CWZ+eaBblV3/m3KyqUO4cURAFCKF3CaNCJh1kQ==@kvack.org
X-Gm-Message-State: AOJu0YxodfZr/ggWQ/dvLQqYu6D/nk1StDEwZ6YogAKkcwfHAVEjvTGg
	QCf2DlUzR7rlBEQ6X4AfJ4ezbwQULBmhfDIGMz80AA+UwRmjntyRUsbC
X-Gm-Gg: ASbGncuUcvFkUAVk+T4SreM1yPy9qgbTjSqqXPfaZKEx5nd6atibrHCnlodjC47O05Z
	OU72o8yh+xhC3i6odDw003sOrxERPV9tj+glQCvhK6jwRceV51n4QHDUrXjKa9G8SQENUJpPLmW
	A24PPphhRWMolOngmjYUyrgCAcKPSUTt59wyXz56xm8MQFGZr1VK2AuPi543EZtp8HNB42L/QC5
	kiadpIfqLzE4gKNkEB+zvLdESatArWoSpZS39RCRZC1Z/1W6P4LsbxrBXvKjsbPCLbskdubi1kN
	STiXMlKRwH98MKrnFWl0CSUv1u5cHXkeQcTe2ZM0IWLFIJSCacTFtkzqz9kvHn2gofeCfVrFSo8
	blp/y37cmJnMRk0hHOMW0vQaskA==
X-Google-Smtp-Source: AGHT+IHGvPGfY1Eh9xgyGS4B/7DmMYIqJ7fgl+mSwic2lFnNCUiCLH7BqElvIv4cVFuD8lOlXnBNQg==
X-Received: by 2002:a17:90b:4f8c:b0:327:fd72:bd6a with SMTP id 98e67ed59e1d1-328156e2dd2mr1232775a91.29.1756526075521;
        Fri, 29 Aug 2025 20:54:35 -0700 (PDT)
Received: from dw-tp ([171.76.86.139])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-327da90ee17sm4279879a91.24.2025.08.29.20.54.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 20:54:34 -0700 (PDT)
From: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
To: linuxppc-dev@lists.ozlabs.org
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Donet Tom <donettom@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC 8/8] powerpc/book3s64/slb: Add slb faults to vmstat
Date: Sat, 30 Aug 2025 09:21:47 +0530
Message-ID: <e05ac86618d8a52feccf5bac99da44b11871382c.1756522067.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1756522067.git.ritesh.list@gmail.com>
References: <cover.1756522067.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gco44k9ka7bqtdjzxpxm4ub5jyh9zwnu
X-Rspam-User: 
X-Rspamd-Queue-Id: C3FB4140003
X-Rspamd-Server: rspam05
X-HE-Tag: 1756526076-837141
X-HE-Meta: U2FsdGVkX19/zzkti7ZY/2RtBiuKV3Yb2nb2OfeYD1eDCxf7zaFKO6oSdO4/bVznKfdQ6KnWYB4GxqLyltWQJ1CB0LzKqZfBI70iCtDXtvzmhrOe35+X+RyBLFzTFCGhOpTN/tllZ0L8Z0U96DSGK5d5qBHU9pyGBBZUDsrAC358YlXuBUv2YUFtR2CBbwmqAenBYRzDaFJEYzwvnYDkfxPhVnxUVgM6xGLsKOq/wG8LszS22x+gU7zLVm/Ib7a4k4ar90HvnMmKbPm+n9Fho7gMtfn5uSX01ZGh89wgFZMbpSWriyE8wj8uNUdDLt8aGqHs0FtHD84DJC1hvAf6nXdPlwChZYfoP0i6Z2ByC595WW6tZgnDLNzlYJUBj/2FxQ9xtAcEe2aCNxSTGR6XiPYvnGGZ7+2/cxWoTmG3cXa8pTP97E1tgvIUdnYL5aexPe8PvBAqRbqGDxmWEnOldgEL6tzpk93GZctBJRjiToEiUPGfWH+f1BZAvflM7B0Q0LZtDnjmWxvuw1OBMxKYvmsYGA3E9LuNscFSNMnz3epaIXcd2SgxLTAbS0GXKiCSeQr//dUqsx65x+rUpxSSor39kxu21kuL8xl+OH4z3PL6Ki39yfcDmC+Cdxi5qYTU5pcpBZof4UMGDszraCG4LKUyFkECFCPY7PkRYCQtQCDIFhcmk2TnlkfgMZcng0TNI86Qije8dC6oox73ZNt2Xf1O1/LA0EgfSPjn6eMhlpMpbTYokj3twbFrhHL+ZIla7b4H9G3yavD6upXDo3zSiDmSYemBVCiaoxj8koWox7Ight1ZXr54Kg6E5j7vjb+QizuJWaCM93ktrHkNiZXZqJAcbtwxD1H+UFvYnKSmLIhII20gO9CAeI9mAmOWkKXm/Y0zMG45aMvYcmjLctxDtRcdJhhZNEA6UB93HM8DupzlAIG6ELmeBbcARacHeEDh6QDq55vuwolyy0tVOG9
 xl43vwc0
 1tIWNsiKRQrqle69q6xe/o2N+syTcNSVJgm9sYZHKkjRTVJP/YxpzWnyWP58WJ14qex7b2H5S3IYX1J2hKYNGJ0BcLGhpsRfcWPzdafhnoBYeWnW8bjJV3M3pMMGch7L6GVoR/CLaFk+CK2OtqJyVqx7SuuEzsSWZ++UA1Ycg/73bfv41tL/sHZ7w52u3uyhVimcD9NQ2Gk1Ve2fAMjoReHio8LMmvnPxSp6NvmGGsTgLZCU0wnwn+xeLz2o9zlZ2cC4upJ9O+lFFH7EVV9wYp4HKUcBLVra4/He+SM0GtOPMHefkCbrlyQSSXtgFururClx8g6J/Hmo2NxnLYM5MF5me8utmPsxhFlwxxvcAHexhuhy63wo9Kd5kMGW7PxsJSIxCY7Fi/5ZZa9c1Us38HX2IpG+xWtAR8HIm8fgTiN4lT7Zcqi+L1LOOUdTVuBfCNzIx+SQ5twFBIJF32Sxn9iu4tC/jXwUh5htLeWYFyyl4P/3HCFRraYcJht384jTx57cwucCIQYScuVujigZ5dorG0ByzjiuQxTwdoHCDUqw0tMnCEwLuYAIyW2Brmdb1uAN9Puh6FSmn+YddscAzaOSvpXyCDzwveqL/n4Zl3z44+MXCBr7vgSQ35A/kOTiLGRrkfeUH44S5Vvn0cEisWi+jM7giZZF32Pdasss+PfKQ/qFththk5ZUkafKDichfksAsyG2HKe0xIV8iKSxe0sRulBbPdrE0XM3ndFPO9xh8oKz9Dqga+Jg1Njqngd2YqtHQOubPaZPNSf3J1fSkynblGIZe8RYrSqgI5OL/hfEuF6TXwJYMtg6VPe4eEldRJ9QRxbXnh6j0e0cKBMMEu9HFqGIN/I2f/JoQ1KzevYLN1tnoAwcRwId2Lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There were good optimization written in past which reduces the number of
slb faults e.g. during context switches [1]. However if one wants to
measure total number of slb faults then there is no easy way of
measuring one e.g. number of slb faults during bootup.

This adds slb faults as part of vmstat counter to easily measure total
number of slb faults for book3s64.

Note: slb fault handling is defined as raw interrupt handler which says:
 * raw interrupt handlers must not enable or disable interrupts, or
 * schedule, tracing and instrumentation (ftrace, lockdep, etc) would
 * not be advisable either, although may be possible in a pinch, the
 * trace will look odd at least.

Hence adding a vmstat counter looks a plausible and safe option, to at-
least measure the number of slb kernel & user faults in the system.

[1]: https://lore.kernel.org/all/20181013131836.26764-4-mpe@ellerman.id.au/


Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
---
 arch/powerpc/mm/book3s64/slb.c | 3 +++
 include/linux/vm_event_item.h  | 4 ++++
 mm/vmstat.c                    | 5 +++++
 3 files changed, 12 insertions(+)

diff --git a/arch/powerpc/mm/book3s64/slb.c b/arch/powerpc/mm/book3s64/slb.c
index 297ab0e93c1e..064427af63f7 100644
--- a/arch/powerpc/mm/book3s64/slb.c
+++ b/arch/powerpc/mm/book3s64/slb.c
@@ -22,6 +22,7 @@
 #include <linux/context_tracking.h>
 #include <linux/mm_types.h>
 #include <linux/pgtable.h>
+#include <linux/vmstat.h>

 #include <asm/udbg.h>
 #include <asm/text-patching.h>
@@ -780,6 +781,7 @@ DEFINE_INTERRUPT_HANDLER_RAW(do_slb_fault)
 #ifdef CONFIG_DEBUG_VM
 		local_paca->in_kernel_slb_handler = 0;
 #endif
+		count_vm_event(SLB_KERNEL_FAULTS);
 		return err;
 	} else {
 		struct mm_struct *mm = current->mm;
@@ -792,6 +794,7 @@ DEFINE_INTERRUPT_HANDLER_RAW(do_slb_fault)
 		if (!err)
 			preload_add(current_thread_info(), ea);

+		count_vm_event(SLB_USER_FAULTS);
 		return err;
 	}
 }
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 9e15a088ba38..8aa34d0eee3b 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -156,6 +156,10 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		DIRECT_MAP_LEVEL2_COLLAPSE,
 		DIRECT_MAP_LEVEL3_COLLAPSE,
 #endif
+#ifdef CONFIG_PPC_BOOK3S_64
+		SLB_KERNEL_FAULTS,
+		SLB_USER_FAULTS,
+#endif
 #ifdef CONFIG_PER_VMA_LOCK_STATS
 		VMA_LOCK_SUCCESS,
 		VMA_LOCK_ABORT,
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 71cd1ceba191..8cd17a5fc72b 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1464,6 +1464,11 @@ const char * const vmstat_text[] = {
 	[I(DIRECT_MAP_LEVEL2_COLLAPSE)]		= "direct_map_level2_collapses",
 	[I(DIRECT_MAP_LEVEL3_COLLAPSE)]		= "direct_map_level3_collapses",
 #endif
+#ifdef CONFIG_PPC_BOOK3S_64
+	"slb_kernel_faults",
+	"slb_user_faults",
+#endif
+
 #ifdef CONFIG_PER_VMA_LOCK_STATS
 	[I(VMA_LOCK_SUCCESS)]			= "vma_lock_success",
 	[I(VMA_LOCK_ABORT)]			= "vma_lock_abort",
--
2.50.1


