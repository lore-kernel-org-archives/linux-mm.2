Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95148CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 04:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E22F6B0088; Tue, 29 Sep 2026 00:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7926D6B008A; Tue, 29 Sep 2026 00:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684EC6B008C; Tue, 29 Sep 2026 00:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 370FF6B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:03:10 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AEB2414036A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:09 +0000 (UTC)
X-FDA: 85265454498.21.A3C9F22
Received: from mail-pg1-f226.google.com (mail-pg1-f226.google.com [209.85.215.226])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5CBB8180004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:03:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=MRPf3MIS;
	spf=pass (imf16.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.215.226 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790654587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JYFksTwPL6Xygy3lz6bjz5WbJ+cVLM8U0ms6Q5xLHTI=;
	b=yySYbF3lJan+SlKIdlaLtWVNmN4OjLqc6NoopdclvZ7wdpMJjD3nqcDnY33pIAF7bbYK2y
	vsMU8BmD6FxvWV/ViH0RjmbuKz3wL5D38oAEJ3KZd0h9fljT8GPcXXiVktyZvYPN3vQNDV
	+6sFpzZyisO6hw8WMkBsKzzBiEVEXN0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=MRPf3MIS;
	spf=pass (imf16.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.215.226 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790654587;
	b=6IK/tjzhInKsV7ibVbX5pxscpS+ePsWFXpptua7aipbiNB1qB2z2k6CVD3FklBOe87OXb9
	x3aKSUfA8xNU8AlzhQ9FWvYgQr5AVTYMMH0HCM31qLhOcT1s+si+5rHRtQJdyHOQiF6NJl
	zUnLYrrhcnfPhVbIgUL2pMwejvnga2c=
Received: by mail-pg1-f226.google.com with SMTP id 41be03b00d2f7-cc4dbda1e5dso222096a12.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790654586; x=1791259386;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JYFksTwPL6Xygy3lz6bjz5WbJ+cVLM8U0ms6Q5xLHTI=;
        b=mJoyjPOMo1dq2H0/bipPJmzvLx02qrTMP2o3FNtyc0s8KmmNuSTMe/29z4tOEehGi3
         hA7Fg3iMqngLf7pxC+CP2Hi/SYbQ06asa309VUOCWu9S8yQA2fhghePwLAr37HS2/JGV
         pAXFVEq+g5upLzpV2hJuBCoImmsqNZWAxPumQt8mygQ1Zq0lKDz4kN6MJ4daMNphgQDx
         7EaUhRGRkDV+FE98iP3FOPYkSPJ9391zjKuQvUN3r+z8DFQJoGNnQvoFCKI8a0n6YUg9
         3u5r6T9i2tsWjpiSLR84/rlGUPezgGfOrfrt6NG8zt85avLfQROQg2PvqLec2iFOAgi7
         nFHw==
X-Forwarded-Encrypted: i=1; AKwUvBxpDWZR+jMve4h1yvFJemVZqWDA3zKJcWyzVKzQJTblETFXYnNF6fmsGn0TaJzodrkpUFPrfKw0mQ==@kvack.org
X-Gm-Message-State: AFuF++mvihAmfKrLZP2jS6Z1zLUy/lOVDWyG2FLeHFKnaje/ZtBg+RD/
	oqyRSUmPgCTrhZKxTLx2X97YDvCvLq0Z0FSL/uvnYZ6JzMht/Hq+L3S37NF/QVjLHKwD53687NG
	SJXqVmJEGgz9dq9gg+eRXf0S3k/OL7KygzcdFT/dMAfTM74+8oMSV+LPDAukE7pHaSZDypP0JOA
	lqi5O6vO68fbjNTyv2xduyI+8goQzm6M0Vu2RcQ9ERLNdhN8RtrXDzJPraivCl8AD07tTgEjAij
	Ms=
X-Gm-Gg: AYBFou1TLzRhxZnf+Tl5m/aXKK7wbVQKGYeyT623ylBANugBv/QApqw3GieBrKwdwro
	eamTfTFZyWFpHUXvCnO9dg8pAf/XATg9HsXu5fSyfafqkQsZTcvyYrNu3UoE4Rq+zLO2PAHtWig
	wlwDVR7Zn0zNcWvvTCRiT6uZNCR6P328HFvmK81o6Dkgx4RrhKbSY1+XVePZXbXKsi5FxQuKKps
	iWGCH+mWp0qd117xWtIUkPiOSKB+L1b7fOmnZ+HaKLW3JYr5QJWu24jb0EtZ7t1x8lK8e5ZsN2Q
	1Xjv6YkYk1s/lODXmNhPEU+TEmfwIVdZT2HNyYEzDBY3W9pu1tjWtOK60XGTMWQ76CZ5uf+KQHl
	8d9yLUCUR4gtMyeSk0a5ptJN+7QRCWfBdVm5CA/XwHJFMhJc+QpePbOo3BPfd/09Tbj38rkU82r
	yhL+J5aObdzQjmTdUSFj+8rTraVxIWvvEl
X-Received: by 2002:a05:6a00:408d:b0:882:2195:5a74 with SMTP id d2e1a72fcca58-88221955f35mr5568814b3a.59.1790654586054;
        Mon, 28 Sep 2026 21:03:06 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-18.dlp.protect.broadcom.com. [144.49.247.18])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-885df0d7871sm91445b3a.1.2026.09.28.21.03.05
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 28 Sep 2026 21:03:06 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-34afa104860so626523eec.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1790654584; x=1791259384; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=JYFksTwPL6Xygy3lz6bjz5WbJ+cVLM8U0ms6Q5xLHTI=;
        b=MRPf3MISjkV/bP7FEN+KQHePmpivwhkvabGyOkXEoSvj6JUWBotSfs5tWjU0e09ajv
         0rQN5ytr6m3qqebpyTq1WQcyoOZBCVE9uhnJwz+nr028lVMwDFadnTS6Vym7eRdIIgrg
         m8OFsMY9MGeqsUInRSsMJg7pmJxARM3wLqLow=
X-Forwarded-Encrypted: i=1; AKwUvBxu8DKYQe9TzI5r12NRaWqmt4d1uxO45mWeqX4jZacQOkm4wClcO2n87rS/vVWAJy2qp87sy95N5A==@kvack.org
X-Received: by 2002:a05:7301:3ab0:b0:33b:e264:474a with SMTP id 5a478bee46e88-34272c5c9c8mr10268582eec.31.1790654583928;
        Mon, 28 Sep 2026 21:03:03 -0700 (PDT)
X-Received: by 2002:a05:7301:3ab0:b0:33b:e264:474a with SMTP id 5a478bee46e88-34272c5c9c8mr10268522eec.31.1790654583107;
        Mon, 28 Sep 2026 21:03:03 -0700 (PDT)
Received: from vertex.localdomain ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-347323f5a7esm10952571eec.15.2026.09.28.21.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 21:03:02 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: Kiryl Shutsemau <kas@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bo Gan <bo.gan@broadcom.com>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Ashish Kalra <ashish.kalra@amd.com>
Subject: [PATCH v2 0/6] x86/percpu: Share decrypted storage before guest setup
Date: Tue, 29 Sep 2026 00:02:49 -0400
Message-ID: <20260929040256.543767-1-zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Stat-Signature: f8skj6gx49cf7mwf9bb4sex4bjh8e18a
X-Rspamd-Queue-Id: 5CBB8180004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790654587-847730
X-HE-Meta: U2FsdGVkX1/o4zVswlf9ROJ8foiD4RsBPQCK0wvLlYmnTYIqz8jjKWEPrOh2NLHjh9fHnxmCjWYDsy93UelHfXhMfKnJNo2vctgKqQasX+7awx6zCjUMgO1YqmO6h5rCHQBrf1KzqyAASRpw/RKQrh5ZqZmO1Kxn6PLD/Lu02QjolGukFyH1VCT/qrg5sMPgTcoVsUXxXvOwHi6LJqYT2Zt6qIp7rp0/I2aw2jKHX0DaN+fe8mVNKqB0cMx+IlXpdLWOxQYWXgb+T6h3EEpvG9O5QJG9mKoZo41Sm98yngv42XC/vYcNRd88vTcSrguBOJi1vRsmWZ+DVtu+N6/C4Ltfz/Lt2brzAW/dsq8+HSgZ6B41flYmqt0OY0WU6KqpagohkretRVxaPPuCiSV8pB2xSkGDtYk5q7M61l76pMN3eUt7jvjMgyDBFFf4ub3G6yLNB+HdLT8b351XtDF0pDFbfd5+vFZhwZA7FUVYgrLqTquSr41TjoaDV7u6F4BG6hsU/p4xOZXyYqkyGfY0vEgV6wZhuuzfsjrejuTCnXqeUZKMsRzIs/rKXg8EnzkfmuglIC1nhTHW1mrGHXfhjrtib45/xCyP1zheTnCygQe0O5Nv9J/1wlspBi3ivWm3np+J1cfbnBP141EEEGzxZp4JHu3XIq++5d2EEQkuc9cjboWjpO6g3A9xs/4flPI0ry1e1Q5W+cbe3tPtnryDPFGtpbmLgEQ+Hc013yz8UwDpsjCm1qQKAB34adWzCDhPwXIPxMGUkfiLT5mAtgLrcbkjRGL3KBQHbgA3uBjgfUGBREYo+gkoAqKjBFYcMNxQuj1rfZVzKeuzd00YgqQjx3sqmYDS3bFT2MR/nkB6aBALRPLNIxJWxF4jbBNf2AadJXzRZDZ5kepeB874p9NuTi9oaIXxBXydN38NqgC1t7Dod6wi8htvhq2mBIHjBUQP6IRX2fJ4cKP4MUCN/hD
 5k4kLOZ0
 HMKSVhrStKgozycdbt7AK2FuHy8mELO9X2JT1/al+J3bywXTYLB9lZ+IgACXOLBw3jAz/fzV2jt3R77xg+o5RGiCoG88n2FXbx9XNkeF0IzPHUhMWNU7OyrFoDDf9WhqQCDNIWi6RZexZri0oWUxQXIzVnJ3x0VL0lNII7y1rQiaBbtSPGW9AXopwAQvgkmNzzx0ceQLpe6RQtCBEpMC8Mz1jT76gSTWLdhuw+n+FDULJaMOvNLuNiX0P8ix3skSVvsQ0XBjCNzVjRSXih+kL40Pfq413yF958Onxq44yDwCZVwgZ0MHYy4K0vPTnfu0EhOi9suEYhqr1fD6LjmSt9M4Yo/3EnpynOX0nFzGgyQegOgigAsbc1OGvl2RsHifh+1JSoQVdcwIOVvCMbh8iRwM8zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VMware publishes its per-CPU steal-time GPA without first sharing the
storage in encrypted guests. Following Kiryl's review, this series moves
sharing into early per-CPU initialization for both KVM and VMware.
This replaces the VMware fix from Bo Gan and Alexey Makhalov:
https://lore.kernel.org/r/20260309235250.2611115-5-alexey.makhalov@broadcom.com

The common helper uses boot-time page-table allocation and preserves
initial contents on AMD and TDX. Conversion precedes buffer registration
on SMP and UP; failures stop boot. Encrypted guests use the embedded
allocator, warn on percpu_alloc=page, and never fall back to page mode.
There is no driver conversion loop or readiness flag. .bss..decrypted
remains outside this series.

I interpreted the allocator requirement as guest-specific, so both it
and per-CPU conversion use CC_ATTR_GUEST_MEM_ENCRYPT and leave bare-metal
SME behavior unchanged.

Two corrections to v1: its isolation claim missed UP, where ordinary data
could share the decrypted objects' page; patch 1 fixes that separately.
TDX's vmalloc constraint concerns private aliases and adjacent accesses
through load_unaligned_zeropad(), not just GPA lookup. This series removes
the unused declaration macro and adds explicit SMP/UP section boundaries.
I have not carried the v1 Ack onto the revised patches; renewed review
would be appreciated.

Tested on VMware ESXi with SEV-SNP and TDX guests, and on KVM with
SEV and SEV-SNP guests, using SMP and UP kernels.

v1: https://lore.kernel.org/r/cover.1789488039.git.zack.rusin@broadcom.com

Zack Rusin (6):
  percpu: Page-align decrypted data in UP kernels
  percpu: Bound decrypted storage for all x86 encrypted guests
  x86/percpu: Require embedded allocation in encrypted guests
  x86/mm: Provide common early memory decryption
  x86/tdx: Support early sharing of kernel data
  x86/percpu: Share decrypted storage before guest CPU setup

 .../admin-guide/kernel-parameters.txt         |   3 +
 arch/x86/coco/sev/core.c                      |  16 ++
 arch/x86/coco/tdx/tdx.c                       |  32 ++++
 arch/x86/hyperv/ivm.c                         |   4 +
 arch/x86/include/asm/mem_encrypt.h            |   9 +-
 arch/x86/include/asm/x86_init.h               |   4 +
 arch/x86/kernel/cpu/vmware.c                  |   2 +-
 arch/x86/kernel/kvm.c                         |  35 -----
 arch/x86/kernel/setup.c                       |   2 +
 arch/x86/kernel/setup_percpu.c                |  14 +-
 arch/x86/mm/mem_encrypt.c                     | 139 ++++++++++++++++++
 arch/x86/mm/mem_encrypt_amd.c                 |  12 +-
 include/asm-generic/vmlinux.lds.h             |  19 ++-
 include/linux/percpu-defs.h                   |   7 +-
 14 files changed, 247 insertions(+), 51 deletions(-)


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.53.0


