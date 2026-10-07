Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C94CA6002
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 16:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF0A06B0092; Wed,  7 Oct 2026 12:34:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1DE6B0093; Wed,  7 Oct 2026 12:34:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B908A6B0095; Wed,  7 Oct 2026 12:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 943D06B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 12:34:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90864402CF
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:34:44 +0000 (UTC)
X-FDA: 85296378888.16.14E2DA2
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	by imf11.hostedemail.com (Postfix) with ESMTP id DF42240007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 16:34:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CpuoXwVm;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791390882;
	b=YUgPN8RrgkDHFKmiJWtodLSGxc9LL4WyJH4I3GMrw2QObAp/jRqtIxNgFpya1ZRCZS/jVz
	s6s2FIWLWwcHpiBCkCGiahS7UhR+dW9+h7Kxnn8C489sBcdX4E6B3r8cnTGqOt7pESeurB
	NvXto7zNKPiGvcefwi1raGDvHItWN/w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CpuoXwVm;
	spf=pass (imf11.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.48 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791390882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8J1GOhzcY9UVBGRcW/Cw+AY4dE8xBdwM0W7qy7H4udM=;
	b=WSlXPvPjRm0b28l2KHOfz/gKC17VT5NwAzrUi4ziJIRPnxMOxxi9w5HZCH+LEi0veOl3tH
	srv0Z4LjplAW8m0X5RudYxjkWLLmSb/ZAQGA5mJxI8/WFlVg7Yw5BUHAX8PuJn1BLVXpPC
	QXqbHTfyRlGmNbLHlKs9+6Ntjlj6FfU=
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3a02551822eso2072586a91.1
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 09:34:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791390882; x=1791995682; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8J1GOhzcY9UVBGRcW/Cw+AY4dE8xBdwM0W7qy7H4udM=;
        b=CpuoXwVmzn6pM4imMrqhbFjNX1Da1f1OR2YCVY0M1qmF5G6tEj/oAyPlCGan+Rz44z
         8yPoIcSBJOHcfFd3OI+jyM2nSM4tR6m/WN8KyEBFPimxU1FFKKxJw+3GA0hzp5GIIKG5
         iMWg2mfUj9jkJ2lN7WdJh0cGC7E3PmzxXiMsQu4nQFH4TcJTCkJeV7tjwYg07sYFuhqQ
         2PPMD/hwmr9GT4Df7vy0CoUlvY0Ktvgbv8y8IDWo1i1r1EPL+h/P3AOTkTR7nlj90Xto
         gacvYHFvE+RKI9sozs/K9xaeP1wHt+0R86XsCh0MoZvf33ea2fEnk6FyXHYIp3NgBqHH
         WQUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791390882; x=1791995682;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8J1GOhzcY9UVBGRcW/Cw+AY4dE8xBdwM0W7qy7H4udM=;
        b=iaWYjsvkwD/Zd16wEk5qH9ugFXBwID8+HbtwfYRotAvMiAieAS9Ga32IseiA79XtEG
         XRtzr1to5Wz8KbsNEX99fSezNWHioUjJW8rU+zhzBUavJcmRDPhEuBvTJ7IKMKZe6kWG
         NuEtyw+Ewe4rSIK87acm1qMiXYGXgfwBcbq6M6ibmTvuvx9hO5Xs9Rw8KKSMNlMd0CiS
         vz1IgLAL9uZ33MPBGvIGZmQ86bekXoLG7fnfhXF32KzXcFBtBHu3cOCsdUDsRIfbq8nG
         CgYMn7fzgktm3dusz+Uko1HiO8MNN4ZD+/PF+Hhvd6xQpm02bsXiBIBB0Kx8Hhd9YxWu
         HYRQ==
X-Forwarded-Encrypted: i=1; AKwUvBykbQ+t53lzn4if4CrMtGuf/HjSyzzI6PcInQrvEfdPnLu974u7Zsnj33llJCHnvjL7hzAat/pXUg==@kvack.org
X-Gm-Message-State: AFq9FYJJDmJAUvlMZ7inJIIb9dXxdvdWRTvHabFExgsqBpzsN2ZccbXb
	sM7ZpJxC4XE0i6BOsYZPPMpW95udlx60ieS/LViJgaGj2ArjFV46Ynd1
X-Gm-Gg: AYBFou1orB80S1+kTERckBVRX3IjtAdahHHqw+BulIBJRscEXgapwCqWBDYVoxdoFlG
	Ppccxhauu0miJcqzLz/laVohcClGMCWvPss9pQBnip7lKZRdQw1EQ4cigD1dDE8KUrlqICyABe0
	hpTzJWP0o7o0wTuschdd/CfKryzZOHGOqhIkqhu/+VleziT13jpI+Z7Tt0q75mNKtr11D6eUUsZ
	hGNeYSdy4cjTD/ursc0YZmXjz8lV0lDCW2VIg7iFJtJL37blnCtqQaLFFMloXEkyZaQIzalSFq0
	sdJTSa2r2jpd8WZgwYeeRZ7GDo9W2vcDEFDUxVksi1+YcLtFh42ay8LLwODT82/w5tQ7rSSWk3a
	Q/Cfd1/bPzXVGWGhFWAcHsitLaU6CKr0A2JoqryoUTd6xVMxwu9epUAJg4zSbCIoLQZBZYGxUtC
	XWG3W5XY5atddnzxdKKrTwOW2AZ2L7RZwQkIvGSUnDsA+uEzX2O7lQw4rUbhZ1mBVZBOh2DZGao
	jMfHaDud7RrGJ1HePbOOPoY
X-Received: by 2002:a17:90b:48c7:b0:3a0:eec6:b065 with SMTP id 98e67ed59e1d1-3a8a0ba1c96mr1499640a91.13.1791390881599;
        Wed, 07 Oct 2026 09:34:41 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a89dbc9297sm2713600a91.1.2026.10.07.09.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 09:34:41 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Harry Yoo <harry@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Hao Li <hao.li@linux.dev>,
	linux-mm@kvack.org,
	Roman Gushchin <roman.gushchin@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH] mm/slub: clamp slab_min_order to MAX_PAGE_ORDER
Date: Thu,  8 Oct 2026 01:34:02 +0900
Message-ID: <20261007163403.1643768-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: DF42240007
X-Stat-Signature: ky1sr6g3jq98zfhs89r6g4czbf9mhbsy
X-HE-Tag: 1791390882-731934
X-HE-Meta: U2FsdGVkX18iwxYo+zoyVFNfVRhiMTOsYclH5Y9aWOxnlYb+qBEpIJSLaKwRW3ztGuC5V9XIAxNBhPQ2yaVc0K072StGSVLGQner5eRtt8kplcMxuIQnWfHAXv3G9ZA77lwTCSixwG0RrBsBD7CcJSHdMHPDPluWYG6pBm1Llj4PiyTwYuvCpajvVLmrifMD/ktmkEVjQ3hCIRXtQXkN+wZNAEN6NzcphxynIVOQZ8SIBoD/dvFjM70mrtqzcBHFmeWiNbrB9TMgN+jTkwVHurG1rSa2vQOxUNvZiCVzdx8BLVQhOBN4i53ODy7zpCNEH0qikevyFqf+JZHEoaRNUocwLx8cjqDBn5YiSHxiroCJaTM43yPl8IjoDnoZfsQxRBoxCcAZCe9SNASu81ZEkQr+bs7AB2RwYUXFElaEPhrJ3bJNNDQJilBucNppna7uELiXX8zJm75Bv+tDeCU+CkvSXucPKoQny5qke8nVpyAZmgIyaKIe0jRhztL6YjnlJJvKuZEo/twrJ4CvGMWWCr1PN+RT4l9Jk+JaYyQrrEb2iG+OKvOk+dgdtL0ls839PyqP2p8dKNev8C/fj1aQ70CsK4PBN1Bty0pkZ1Ks9di+fWFv93vVzCQfhJVm1fEn/SBhBJ921POmYphM0ZloyCCfGVDrCkLjTbXMTnNiKVNYMSgX4JNyrcW3EG1cmu9GUC1kPOyMCrdudqoX0ok9XYH1VqcMniaUPmb/LQNhc55kMRbk3wYAl5kIU9ke4+Oisa6K0mnB3bdHgOCSCiHn3ZPX9ovcCqoTAGnzYbXmW9/Cz1wMyrZbBxlZCsvMsm3xCBnHXUA1v+7V30isDx0mG2nJbh0/v1PhahwYST04z/5Uv1yo1Oxk7JTWs9x/U0B8oZSFmFvgXzo8Pql4OYipy39DOA83v6ZfLDUHqjkDrYrd1Mn22DK83943TM53am1cCXSy/APCMTPBKbUKP70
 zG/iWpCJ
 vSd4oKk0tUpjM+aKNSjKDTzZg9/jAa2W39J6InJmIfPjwqZxfigP9DEJVo653FuM2py9ukqvXr+wD91nr9liZHi+ZSJSAsLNwaDdsnayBu2HbLkUz8M2o9aolEX8OMo1L6/Pldv2LyRzTfBPog5qY3z3RCitFDf/w20gXCbAnaKr4pPJwiCbxo9uhNKVWoWntMusR/auZTZVpOQmSqWtDVInt7y0wY5XPICCVA5sWvY/qiC/k+C7hhmCHV+uNxnxdtFiwl0QM0X2m8pvUz7qt/tLWh3eGypv9i+BYgigrIUrbNVt4E2HErI0EV5yUEoAbN8/He3OFoHnIoaQpQnS36ZaZHcOgIJ1kG1bscdfwYIl80f0kkwTyGiOOGjjnAbs7LZtW2FpFeCGXkgduwtPTiHF/w4A8fo9hw6+BUhnS/UBe0DUAm1U+Twt3H8uvFfqhyrjPKtatBC5ZXWgsrYfpHSIgI+t0Sw8sVC0r34YZYgMaEzU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

setup_slub_max_order() clamps slab_max_order to MAX_PAGE_ORDER, but
setup_slub_min_order() has no such clamp.

The buddy allocator cannot allocate more than 2^MAX_PAGE_ORDER pages
at once, so slab_min_order above it makes no sense.

If slab_min_order is set above MAX_PAGE_ORDER, it can even panic at
boot or invoke undefined behavior in order_objects().

So clamp slab_min_order to MAX_PAGE_ORDER as well.

Fixes: 818cf5909701 ("slub: enforce MAX_ORDER")
Cc: stable@vger.kernel.org
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
QEMU-based test results

- Booted with "slab_min_order=20"

1) AS-IS (before fix)
[    0.094926] mem auto-init: stack:all(zero), heap alloc:off, heap free:off
[    0.097776] Kernel panic - not syncing: Creation of kmalloc slab kmem_cache_node size=64 failed. Reason -22
[    0.099542] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 7.2.0 #1 PREEMPT(undef) 
[    0.100903] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[    0.102607] Call Trace:
[    0.103040]  <TASK>
[    0.103417]  vpanic+0x32a/0x4b0
[    0.103976]  panic+0x5e/0x60
[    0.104491]  create_boot_cache+0xe3/0xf0
[    0.105194]  kmem_cache_init+0x12d/0x410
[    0.105890]  ? mem_init+0x1fc/0x210
[    0.106521]  mm_core_init+0xba/0x140
[    0.107153]  start_kernel+0x441/0x8b0
[    0.107814]  x86_64_start_reservations+0x18/0x30
[    0.108638]  x86_64_start_kernel+0x10c/0x120
[    0.109401]  common_startup_64+0x13e/0x158
[    0.110145]  </TASK>
[    0.110584] ---[ end Kernel panic - not syncing: Creation of kmalloc slab kmem_cache_node size=64 failed. Reason -22 ]---

2) TO-BE (after fix)
[    0.008976] mem auto-init: stack:all(zero), heap alloc:off, heap free:off
[    0.011366] SLUB: HWalign=64, Order=10-10, MinObjects=0, CPUs=4, Nodes=1

Also, I'm not sure about the Fixes commit. Please change it if you know
a better one.

---
 mm/slub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 1559cbace469..8400df7c222e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8354,6 +8354,8 @@ static int __init setup_slub_min_order(const char *str, const struct kernel_para
 	if (ret)
 		return ret;
 
+	slub_min_order = min_t(unsigned int, slub_min_order, MAX_PAGE_ORDER);
+
 	if (slub_min_order > slub_max_order)
 		slub_max_order = slub_min_order;
 

base-commit: d755441b7672c74f29d1241ffdd2b067ecab1ca0
-- 
2.43.0


