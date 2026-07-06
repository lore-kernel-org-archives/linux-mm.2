Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36328C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 00:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 998546B009E; Sun,  5 Jul 2026 20:03:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 949836B009F; Sun,  5 Jul 2026 20:03:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 837BE6B00A0; Sun,  5 Jul 2026 20:03:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 463EE6B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:03:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87A1340217
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:03:58 +0000 (UTC)
X-FDA: 84956403756.03.8AF2431
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf29.hostedemail.com (Postfix) with ESMTP id C5FA2120002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:03:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fzP+XkTJ;
	spf=pass (imf29.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783296236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UHjk7mNhNGJNxheN87FC/1xpAIA5OLqN+evo9A9ShlI=;
	b=1DfQPb4u+S7rw0d0vjc6b+7WfqTuWHPRhYJzJZLfigcD/PZHWEsA6YvBQe7y7Sm75p0Td0
	ObSarzlghOnxizOpvUzf49hsWLcQNhSr33uQZMZ4Q5KTwfHH10jIIBygCTJPkAZ/BxbG07
	Ei6cm9JSzA5GITfoN0DsaLDKX8j4BZQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fzP+XkTJ;
	spf=pass (imf29.hostedemail.com: domain of shijujose2008@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=shijujose2008@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783296236;
	b=SqQUeppvaBgpoDKdZ13li+JV8KH1h0xspDyqWXj61X1V0D7pz57TKxs6/w275ZGyfOy+AE
	GQt0mXvYirNdNBtCRa3GZz+gfB2pGZYwBMBHkI8f9Vbf0fl7ViMIGgOYQI4hdSyFxFWDlH
	d2WuxKyWcktQonjDrw2ZFLMl0+YqX4o=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493c5220cb7so17932435e9.3
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 17:03:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783296235; x=1783901035; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UHjk7mNhNGJNxheN87FC/1xpAIA5OLqN+evo9A9ShlI=;
        b=fzP+XkTJfJ1d3BB/F5eefVnx5MGle+GWEbdS8S9/3vxTwWlwoxukNCV9v/a4F2tQl+
         tRX3Cuo+l8Z8oAmhO71alR9KJg3s3wAEUgnXWd8FYVVxrnu81unZSKQmGBN49tku0ImC
         Rl1lacESwunM16MSacm9iv77cFu0UCHqnBRWYcpNHyRJjeHkoe5EYs7EBBcWiFPfe2HF
         syI7aR7rOJDxMjSvJFg+Kekog/o+1DTWqce4t3fByvm6kQmW69yQQ8gg3TcKVIMiqFdm
         cmgvHQYScwsPqhbAlGA8nruoGyutmKB082kT5MFMWsTc9lHcCN5yBWSD9zfjFQa6CgPu
         HJbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783296235; x=1783901035;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UHjk7mNhNGJNxheN87FC/1xpAIA5OLqN+evo9A9ShlI=;
        b=fi8JLmW8VFitkCWcmxh0x+NslqoMGIWUmhpIOUktCsjyfB7C8LnB88hkoSqb74vplZ
         puacn/S2tOhj+g7TW7MwdmkUHP/SeoDLWJE0CX2aJxV59CxuxfUBRXvr6dMoQkOybBr6
         kR0rZ5J3YYhMAakbavby6IOuyLqRykEnuuzbciRo7nk0rKTD3oIRyhcgwym1UP9KZDiT
         OlKEjyxLso+CXug8Mns0734TEGNwGBSebLCoekIDaQIe+38VXw0LcMex/dRKxsD1JU44
         UZuch7TXSwTEep4w8WVXpTcaZeb88C9iG6AtjsqsaGQcVCPD3T+367BfxbCk8BC59h2Y
         dXkA==
X-Forwarded-Encrypted: i=1; AHgh+RrRBRflTdS5+rYiS7ewf9KPLRUEn19fLzkmQOB9BnRXFbYSObDm5qLeKpi7AKlRU4+aGBJ/p/pxzg==@kvack.org
X-Gm-Message-State: AOJu0YxRpId1xhKeT0eOy6nJ/9yBxpTILhk/H4Hx97ijE6mH2WJyC8jp
	ZLVMXY5YBIq8qT62+cx5Ur0Rp0p9YwgeUadzz0l2ORfzBWq/Z5KhAolO
X-Gm-Gg: AfdE7clWIt1Ex2VExSQDRkIqiYACmHR3qMqis0aSYv4xSB/A25BsSScTHrv0ed0ZopG
	hz11vJogQuZJSSl7bE3OUJyMtBwsIzwjR0CjS+nI0FjVoqTyyRNYMmLVEZiil4oehALv6u15VP4
	PPCnpfrv8wJZuJvBzyIcqKTrwmmjuiVZ6owLruhmvUBJ80d7MM0n1EJO4YVPUEL/Ckme0kT1hGE
	PPhwjAJer9deC64C6HsN4BReOnkQjVPWWrXCcsTM7/wF2EMCYjqr3Xhi2jQ4ehGfEzkihESR0uI
	xK6M2fAJwXt1rn2fb0gHeMeZG83w0DcIMLt3Su2Qpl74w5vcF0A8reh88EP8eZTKZAGPRY07xwj
	NHIkz6wacrZtJUDvoRXBH8teiUw0dhuDt3CgcLlHPasGef0BkS+8z8z9+nW3AdGPxyIpHmXCJ2h
	8tVmQ2D3eYgR0RMvmwK6rV+NrdTZxsrQINmjil4yuVQk1DfsFkku734SH2W8RIOxXm3YVesNqb9
	x81AFBnRBqRc5cJO8iP/X5Dig74Qzb9
X-Received: by 2002:a05:600c:154b:b0:493:bfbf:1da4 with SMTP id 5b1f17b1804b1-493d11f0daamr72246405e9.22.1783296235148;
        Sun, 05 Jul 2026 17:03:55 -0700 (PDT)
Received: from localhost.localdomain (stev-08-b2-v4wan-169520-cust2225.vm32.cable.virginm.net. [81.98.232.178])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493be4a343csm296589065e9.0.2026.07.05.17.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jul 2026 17:03:53 -0700 (PDT)
From: shijujose2008@gmail.com
To: rafael@kernel.org,
	bp@alien8.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	dferguson@amperecomputing.com,
	linux-edac@vger.kernel.org,
	linux-acpi@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	tony.luck@intel.com,
	lenb@kernel.org,
	leo.duran@amd.com,
	Yazen.Ghannam@amd.com,
	mchehab@kernel.org
Cc: jic23@kernel.org,
	linuxarm@huawei.com,
	rientjes@google.com,
	jiaqiyan@google.com,
	Jon.Grimm@amd.com,
	dave.hansen@linux.intel.com,
	naoya.horiguchi@nec.com,
	james.morse@arm.com,
	jthoughton@google.com,
	somasundaram.a@hpe.com,
	erdemaktas@google.com,
	pgonda@google.com,
	duenwen@google.com,
	gthelen@google.com,
	wschwartz@amperecomputing.com,
	wbs@os.amperecomputing.com,
	nifan.cxl@gmail.com,
	tanxiaofei@huawei.com,
	prime.zeng@hisilicon.com,
	roberto.sassu@huawei.com,
	kangkang.shen@futurewei.com,
	wanghuiqiang@huawei.com,
	shijujose2008@gmail.com
Subject: [PATCH v21 0/2] ACPI: Add support for ACPI RAS2 feature table
Date: Mon,  6 Jul 2026 01:03:36 +0100
Message-Id: <20260706000338.362421-1-shijujose2008@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5FA2120002
X-Stat-Signature: 97crcb973aym1e31metfz1d33fyfb61c
X-HE-Tag: 1783296236-495592
X-HE-Meta: U2FsdGVkX1+KTJfdQk+VZITnZaPsX4JHlcMJYxro3SwdO83usea03BEw479GtmP1MO3R0i+xlDwfbNR2SHJ1BmgCjh2IHDxDrk+Yl1PeTTrYUP8p/OHEi1FAg9p8GZnC8sfbRkIBOhMAxYHnhi7VJnFtNiHSyADzucycakkayacFoAuM8Q1RhI7nCJUwNqPWAmraW/+kbTs8wwXTdLVFg4KABTO6fm0UmJZr/qfJDuFt46DIOV/NW8YArm+wksvyvEbjFq2CWtRDPKo/FxSYy9r3D0T9vJBN3MuM8DI8uDmSfirV0weYwVdjCn0ReaLeIE6/pt++2zwc2T6tenjxeLMfCDI+4gFKo/ztGNF/wGpMNxQzSSlnx5BQO6/YwWr1oP+tLj/WGj8+De2qdAyfCz5HR15HAGHttc5JIQ4XPq+Dc9U6n44nnLC8WjyPSFWw28FwDfv9AOG9a2EIOYSZhpn59uXZDDedH1YYnUmRehaKLc6+zzDF6RWtlByxTzl0LClySSvR5WxQa0oCKLvd6FJai0clEOAT6s/m3LcsI1Z8g4nb95mHf4xGrdVEmjkXXT2nkRmIsWqml/8oo3uhG45EuYjrG01TQzKNnQFiiUNtZPpMiXqOj349VcpbHInCFerHe0YxxGPrDP/ailg43vbIcn1MD8509dsjKZaQ9hkOFZnRuoGwTLgRUrXAtnjI2/45WVG+gmGCoaDSGR+fhAdfwtE+RwNdbQft/BSF2i/EOxNYJMCVK2IjUBCr3KCYK214uyom7JWMF3NXXWjhGitK6Ps+Nfi/kBspq//CtOuCV+VfEFCuNkq8W75IsQjdX0AZ35Bz4PkQ0lrcxOFWWgrzfpvs/KWwKccMl34AmLd7lIjUAqRM6rf1IdiQVp2U+rbTi0/eD3o0Yrv3mgERsfhApOHmK3vPTx8GdlIc7kzDVSQ5fikD4r9kbkN3NKMf+lvOLgfPe/NE8H5QCYB
 S6liXKXA
 8ddnV0MyVh++tzpsgKxWUA3ap9PaRdwziHoCyMjZoHMdQxnHSsf5Fvx1iZ1z0v5JtB6E+jZzyyNb4SA2W3DNYG/TJY/vnY5+w8oljxPkGNVNjO3N+S1t//mgL9J42SHql3gXwS19GiMgBLYag+POcZFiiXtf87KXlaRWwwyannKTLsxjKRlId7lRhgHfUNgRAFGUzUheKp2Ve90iOeAc1SYMtQQii5hjMaX6K3h0aTFq2qr0tx1k1hkxXI8PAn6abl8TZDBd9qVAS8C96a9EUP+OSgWZvHM1Gx8xJOKTUfmM5DktETAJwmxWcJ53IDo7KTEHHbtsT6SRdEX6icqcK6qOTl5D31coDl5z0hWaBeyClPAhSHflprXic62blDMZBaMC1ROpVGAk5GcsvHSxEgW7IIYZ8p/e5Bzu1r07BbVaRnj6EDS3gjV3EtDRLrv9oPPOfWz0d/GuR2xV2AOXalnHc8fzEN5cc0K0rpq1eMtBANskBBlt5gfQd0YGcJmq5V1eiQkGLKve7ZDL/pMs5sMrjYdMAvEwZOblWSO5u0owze5phRMuntYpfTHGWllHzVbJFgdCQD1Sw0wnnJJCNDpYlvy154lnj/vHRvM22f0pbEQPkcruqIBntjuhGmg/z3R5+X4sdGaXknxKTzjV+OjXHy8CN02tkw8bkZeYpNpsFaSmu3Dx1rFxXrLGnpmS+1tqKDkrpOlIT9IeLn3FTNbnbc+cJxkMNKnl3fNNWZR28GfBy2MU2PQ88Y0wPl8k6QekKeqB/AaLJT812klepps1c/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shiju Jose <shijujose2008@gmail.com>

Add support for ACPI RAS2 feature table (RAS2) defined in the
ACPI 6.5 specification, section 5.2.21 and RAS2 HW based memory
scrubbing feature.

ACPI RAS2 patches were part of the EDAC series [1].

The code is based on linux.git v7.2-rc1 [2].

1. https://lore.kernel.org/linux-cxl/20250212143654.1893-1-shiju.jose@huawei.com/
2. https://github.com/torvalds/linux.git

Changes
=======
v20 -> v21:
1. Added fixes for gemini AI reported issues shared by Borislav. Thanks.
https://sashiko.dev/#/patchset/20260704220745.110773-1-shijujose2008%40gmail.com

v19 -> v20:
1. Added possible fixes for gemini AI reported issues shared by Borislav. Thanks.
   https://sashiko.dev/#/patchset/20260408172850.183-1-shiju.jose%40huawei.com
   Unfortunately could not get a local sashiko review setup to verify the fixes
   before posting patches.

v18 -> v19:
1. Fixed gemini tool reported issues sent by Borislav. Thanks.
https://sashiko.dev/#/patchset/20260325165714.294-1-shiju.jose%40huawei.com
 - Replace with iowriteX() and ioreadX() for reading fields in RAS2 shared memory
   tables throughout patches considering big-endian architectures. 
 - In ras2_send_pcc_cmd(), add extra check for non-zero last_mpar_reset,
   changed time_delta to s64, add lockdep_assert_held().
 - In register_pcc_channel(), handled case of pcc_chan->latency is 0
   and fixed timeout of 0 to readw_relaxed_poll_timeout().
 - Fixed double free case When auxiliary_device_add() fails, the driver calls
   auxiliary_device_uninit(&ras2_ctx->adev).
 - In parse_ras2_table(), add check to verify table length is large enough to contain the
   num_pcc_descs elements it iterates over.
 - Add some missing cases to acquire pcc_lock, such as ras2_hw_scrub_read_addr()
   and ras2_hw_scrub_read_size(). 
 - Removed clearing base and size in ras2_scrub_monitor_thread() when demand scrubbing
   has finished, to avoid clearing the user set values, though chances are very little.
 - Add new field set_scrub_cycle to ras2_ctx to avoid user set value is being cleared when
   ras2_update_patrol_scrub_params_cache() is being called. 
 - In ras2_hw_scrub_set_enabled_od(), redesigned to avoid prematurely restart the background scrub
   due to race condition in ras2_scrub_monitor_thread(). 
 - rename ras2_probe() to ras2_mem_drv_probe()
 - add ras2_mem_drv_remove() and call kthread_stop() to stop the ras2_scrub_monitor_thread().
   However unregistering the EDAC device which registered in the ras2_mem_drv_probe() will
   automatically happen in the EDAC via the devm_add_action_or_reset() in edac_dev_register(),
   edac_dev_unreg() and edac_dev_release().
   
v17 -> v18:
1. Fixed few AI tool reported issues shared by Borislav. Thanks.
https://lore.kernel.org/all/20260312165247.GSabLvX5DjzhDtmyuh@fat_crate.local/
2. Re-add support for user setting scrub address range for Daniel's 
   reply in v16, which was removed in v13 because of request to simplify the code and
   with the expectation that the firmware will do the full node demand scrubbing and
    may enable these attributes later in the follow-up patches.
   https://lore.kernel.org/all/df5fe0ed-3483-4ac5-8096-447e4e560816@os.amperecomputing.com/

v16 -> v17:
1. Merged all changes suggested by Borislav.
https://lore.kernel.org/all/20260126171552.GJaXehSJp33nFnpvVd@fat_crate.local/
2. Changes for Borislav's feedback "Add remove_aux_device() which unwinds everything
   add_aux_device() does for all those devices".

v15 -> v16:
Attempt to modify throughout the code and logs for the below comments from Borislav.
Thanks for the comments.
https://lore.kernel.org/all/20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local/
https://lore.kernel.org/all/20251231131512.GBaVUh4NSWqvr2xhbM@fat_crate.local/
https://lore.kernel.org/all/20260119111701.GBaW4Sres045xnfkpz@fat_crate.local/

v14 -> v15:
1. Incorporated new changes suggested by Borislav on v13.
   https://lore.kernel.org/all/20251231131512.GBaVUh4NSWqvr2xhbM@fat_crate.local/
   
2. Rebase to v6.19-rc5.

v13 -> v14:
1. Modifications for changes wanted by Borislav.
   https://lore.kernel.org/all/20251125073627.GLaSVce7hBqGH1a3ni@fat_crate.local/

2. Changes for the comments from Randy Dunlap 
   https://lore.kernel.org/all/4807417b-a8f7-47a3-b38a-94ea7bdbf775@infradead.org/
   https://lore.kernel.org/all/af7b6cdc-c0a7-4896-ba6b-6bb933898d37@infradead.org/
   https://lore.kernel.org/all/26083ba9-1979-4d14-8465-3f54f2f96d23@infradead.org/
   
v12 -> v13:
1. Fixed some bugs reported and changes wanted by Borislav.
   https://lore.kernel.org/all/20250910192707.GAaMHRCxWx37XitN3t@fat_crate.local/ 

2. Tried modifying the patch header as commented by Borislav.

3. Fixed a bug reported by Yazen.
   https://lore.kernel.org/all/20250909162434.GB11602@yaz-khff2.amd.com/

4. Changed setting 'Requested Address Range' for GET_PATROL_PARAMETERS
   command to meet the requirements from Daniel for Ampere Computing
   platform. 
   https://lore.kernel.org/all/7a211c5c-174c-438b-9a98-fd47b057ea4a@os.amperecomputing.com/

5. In RAS2 driver, removed support for scrub control attributes 'addr' and
   'size' for the time being with the expectation that a firmware will do
   the full node demand scrubbing and may enable these attributes in the
   future.
   
6. Add 'enable_demand' attribute to the EDAC scrub interface to start/stop
   the demand scrub, which is used for the RAS2 demand scrub control.

v11 -> v12:
1. Modified logic for finding the lowest contiguous phy memory addr range for
NUMA domain using node_start_pfn() and node_spanned_pages() according to the
feedback from Mike Rapoport in v11.
https://lore.kernel.org/all/aKsIlFTkBsAF5sqD@kernel.org/

2. Rebase to 6.17-rc4.

v10 -> v11:
1. Simplified code by removing workarounds previously added to support
   non-compliant case of single PCC channel shared across all proximity
   domains (which is no longer required). 
   https://lore.kernel.org/all/f5b28977-0b80-4c39-929b-cf02ab1efb97@os.amperecomputing.com/

2. Fix for the comments from Borislav (Thanks).
   https://lore.kernel.org/all/20250811152805.GQaJoMBecC4DSDtTAu@fat_crate.local/

3. Rebase to 6.17-rc1.

v9 -> v10:
1. Use pcc_chan->shmem instead of 
   acpi_os_ioremap(pcc_chan->shmem_base_addr,...) as it was
   acpi_os_ioremap internally by the PCC driver to pcc_chan->shmem.
   
2. Changes required for the Ampere Computing system where uses a single
   PCC channel for RAS2 memory features across all NUMA domains. Based on the
   requirements from by Daniel on V9
   https://lore.kernel.org/all/547ed8fb-d6b7-4b6b-a38b-bf13223971b1@os.amperecomputing.com/
   and discussion with Jonathan.
2.1 Add node_to_range lookup facility to numa_memblks. This is to retrieve the lowest
    physical continuous memory range of the memory associated with a NUMA domain.
2.2. Set requested addr range to the memory region's base addr and size
   while send RAS2 cmd GET_PATROL_PARAMETER 
   in functions ras2_update_patrol_scrub_params_cache() &
   ras2_get_patrol_scrub_running().
2.3. Split struct ras2_mem_ctx into struct ras2_mem_ctx_hdr and struct ras2_pxm_domain
   to support cases, uses a single PCC channel for RAS2 scrubbers across all NUMA
   domains and PCC channel per RAS2 scrub instance. Provided ACPI spec define single
   memory scrub per NUMA domain.
2.4. EDAC feature sysfs folder for RAS2 changed from "acpi_ras_memX" to  "acpi_ras_mem_idX"
   because memory scrub instances across all NUMA domains would present under
   "acpi_ras_mem_id0" when a system uses a single PCC channel for RAS2 scrubbers across
   all NUMA domains etc.
2.5. Removed Acked-by: Rafael from patch [2], because of the several above changes from v9.

v8 -> v9:
1. Added following changes for feedback from Yazen.
 1.1 In ras2_check_pcc_chan(..) function
    - u32 variables moved to the same line.
    - Updated error log for readw_relaxed_poll_timeout()
    - Added error log for if (status & PCC_STATUS_ERROR), error condition.
    - Removed an impossible condition check.
  1.2. Added guard for ras2_pc_list_lock in ras2_get_pcc_subspace().
        
2. Rebased to linux.git v6.16-rc2 [2].

v7 -> v8:
1. Rebased to linux.git v6.16-rc1 [2].

v6 -> v7:
1. Fix for the issue reported by Daniel,
   In ras2_check_pcc_chan(), add read, clear and check RAS2 set_cap_status outside
   if (status & PCC_STATUS_ERROR) check. 
   https://lore.kernel.org/all/51bcb52c-4132-4daf-8903-29b121c485a1@os.amperecomputing.com/

v5 -> v6:
1. Fix for the issue reported by Daniel, in start scrubbing with correct addr and size
   after firmware return INVALID DATA error for scrub request with invalid addr or size.
   https://lore.kernel.org/all/8cdf7885-31b3-4308-8a7c-f4e427486429@os.amperecomputing.com/
   
v4 -> v5:
1. Fix for the build warnings reported by kernel test robot.
   https://patchwork.kernel.org/project/linux-edac/patch/20250423163511.1412-3-shiju.jose@huawei.com/
2. Removed patch "ACPI: ACPI 6.5: RAS2: Rename RAS2 table structure and field names"
   from the series as the patch was merged to linux-pm.git : branch linux-next
3. Rebased to ras.git: edac-for-next branch merged with linux-pm.git : linux-next branch.
      
v3 -> v4:
1.  Changes for feedbacks from Yazen on v3.
    https://lore.kernel.org/all/20250415210504.GA854098@yaz-khff2.amd.com/

v2 -> v3:
1. Rename RAS2 table structure and field names in 
   include/acpi/actbl2.h limited to only necessary
   for RAS2 scrub feature.
2. Changes for feedbacks from Jonathan on v2.
3. Daniel reported a known behaviour: when readback 'size' attribute after
   setting in, returns 0 before starting scrubbing via 'addr' attribute.
   Changes added to fix this.
4. Daniel reported that firmware cannot update status of demand scrubbing
   via the 'Actual Address Range (OUTPUT)', thus add workaround in the
   kernel to update sysfs 'addr' attribute with the status of demand
   scrubbing.
5. Optimized logic in ras2_check_pcc_chan() function
   (patch - ACPI:RAS2: Add ACPI RAS2 driver).
6. Add PCC channel lock to struct ras2_pcc_subspace and change
   lock in ras2_mem_ctx as a pointer to pcc channel lock to make sure
   writing to PCC subspace shared memory is protected from race conditions.
   
v1 -> v2:
1.  Changes for feedbacks from Borislav.
    - Shorten ACPI RAS2 structures and variables names.
    - Shorten some of the other variables in the RAS2 drivers.
    - Fixed few CamelCases.

2.  Changes for feedbacks from Yazen.
    - Added newline after number of '}' and return statements.
    - Changed return type for "ras2_add_aux_device() to 'int'.
    - Deleted a duplication of acpi_get_table("RAS2",...) in the ras2_acpi_parse_table().
    - Add "FW_WARN" to few error logs in the ras2_acpi_parse_table().
    - Rename ras2_acpi_init() to acpi_ras2_init() and modified to call acpi_ras2_init()
      function from the acpi_init().
    - Moved scrub related variables from the struct ras2_mem_ctx from  patch
      "ACPI:RAS2: Add ACPI RAS2 driver" to "ras: mem: Add memory ACPI RAS2 driver".


Shiju Jose (2):
  ACPI:RAS2: Add driver for the ACPI RAS2 feature table
  ras: mem: Add ACPI RAS2 memory driver

 Documentation/ABI/testing/sysfs-edac-scrub |  14 +-
 Documentation/edac/scrub.rst               |  70 +++
 drivers/acpi/Kconfig                       |  11 +
 drivers/acpi/Makefile                      |   1 +
 drivers/acpi/bus.c                         |   3 +
 drivers/acpi/ras2.c                        | 503 ++++++++++++++++++
 drivers/edac/scrub.c                       |  12 +
 drivers/ras/Kconfig                        |  13 +
 drivers/ras/Makefile                       |   1 +
 drivers/ras/acpi_ras2.c                    | 589 +++++++++++++++++++++
 include/acpi/ras2.h                        |  86 +++
 include/linux/edac.h                       |   4 +
 12 files changed, 1302 insertions(+), 5 deletions(-)
 create mode 100644 drivers/acpi/ras2.c
 create mode 100644 drivers/ras/acpi_ras2.c
 create mode 100644 include/acpi/ras2.h

-- 
2.25.1


