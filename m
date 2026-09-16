Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E941C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 05:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98EA56B008C; Wed, 16 Sep 2026 01:05:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 966346B0092; Wed, 16 Sep 2026 01:05:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B576B0093; Wed, 16 Sep 2026 01:05:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60E246B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 01:05:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E718EA5C1E
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:05:55 +0000 (UTC)
X-FDA: 85218438270.07.E94B842
Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	by imf04.hostedemail.com (Postfix) with ESMTP id C5B5C40003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 05:05:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=NNf6Tgtc;
	spf=pass (imf04.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.216.99 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789535153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+i3/9cwENYafIlAkV2jcoorZwd9xMxSWurzxiZS8EDE=;
	b=YjEGdfRwg5giuc1VJHG/jpyiuoy6otJQp4z89Y975J6ZF5wVhEEfjMeyDVYLNqVUWLNtvM
	P6XHW3gvvU/88UxQkhPPHP/da1yrrCf4JBYnGcO10Pj7kj0Fpa9ruiN7YzxvbJEEafQOIn
	1327blzGbvptO4b3wKAP+Z5HUDHpo5w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789535153;
	b=7kSkaRbbD8PuLRgbfNx5Jf+hJR4kMbqGJakjvm3KRGuKdti/2R2jtMbhrmC0qRIyGqN0XA
	bTB78AJuG02KiV3fmvM4bFQYYIsRjyN0/fy8ZgTWjiY/Eikgr5ywCG8QnzVh0b9rz8wrpR
	feUMGspeUPYIydikNXgvPpzaHYo/27g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=NNf6Tgtc;
	spf=pass (imf04.hostedemail.com: domain of zack.rusin@broadcom.com designates 209.85.216.99 as permitted sender) smtp.mailfrom=zack.rusin@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-39647184c73so1483731a91.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:05:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789535152; x=1790139952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+i3/9cwENYafIlAkV2jcoorZwd9xMxSWurzxiZS8EDE=;
        b=10uqOsUvVTTVYdXS+bQ6Ki20uSxkbJzCHiEDQwyiXPpYNUwXkWJ4q6S+etPGfA4KmB
         Cp+jnqK1HeRVM/pmBt5omQ5jS7HOb9befzZoCl7kH1mVSm//v5HwkWiQnNIddBuDqVzl
         AeJIdxxqxK98S7BIwaPQo/ASp116NGsAVarMyUa3N0XK6riatHhnfFbLXfetoOusp9HM
         FiJv+BPloFCEUZrm07YX3fOZWkPW0Z2LyEaWutkpNDjtV5vYxqOlr5IgixHCRB/mU+pG
         tbLPRSqP0rUu3uoXT1qAuJaOyqiwlAgRL0+TNRRHqTSs3kAqca/4boGZ3xDQXwXeWRzM
         7+dA==
X-Forwarded-Encrypted: i=1; AKwUvBzxNDXroXys+4TWUDN40O12uF1BdrWXqwO7V8V6T8E46r+e0hNAVsdlrPxx98l1xrU13a1MUKuu5w==@kvack.org
X-Gm-Message-State: AFuF++klMLHEXJZAmdeABSKW6U8xQfMrWtJ44SuhwoJ/VdTpMvd7GgaD
	2axyY8q1GamPFIEDVPz4i40VOJvryt1Yd//ONW3IIX5iw6Zc63eG37InZmqoOm+1kxd2diAeXSn
	KFXrGnx5e9H8clWyku6zAJ5/BMiqAyTZq1V0NSX3nmOiDuc0MqcKDDUk30s8PujkrDiBz/I0Ohg
	6ZaJQdfVpgSipFEqZ/118ESJY3XaxnALtvhnAwItSv9ZmMkyfZtz5TALIRBSD/KQXIlFcro73II
	0U=
X-Gm-Gg: AYBFou2yxB01CpfXhIrjoUuEvFseJ09jEaPfb6MH2N3az+/fgmR5qtEFAE7RPNh/Dkm
	j4plA+msUPR1z6ZrmDAEDE7os5IJrm/XR5dew3BBPf6G8XE9/8jWrZm02piVROwZiB63LIQug1V
	1bQH3fFiFjVKPRH5g5/Kdvo8tCpCZXh9QC/juz3lcO38vgeF0E27SgF1scdS+ejUYPS/rAsEHwJ
	aN5YgL8lloqcXCHTLOuvpu0SugUncOap4uoMbfpvf1oCdaFXysfU9xoBirsECdpV6QcOgPahf4k
	kCd1JfGtb1Z1hJI2oQb7+ZFcVIQVySmQOvzb4C7mNYxgNh0xvwLPhZ5u3DL9j8IpGTF9iUJwA4u
	OuweL/0dIyvhHpQ8wmxCkfKlgFquOZrdKHrTtsGRe74yteSlx/0X9yhNkUfpqpxodTF04CWC6/1
	j/1imEFgFOHkiXmWKzCNOcQ7rXe52w4jOX
X-Received: by 2002:a17:90b:2e07:b0:39d:e1da:81e5 with SMTP id 98e67ed59e1d1-39e20132ca6mr1141906a91.11.1789535152267;
        Tue, 15 Sep 2026 22:05:52 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39e1bc0ec22sm740355a91.5.2026.09.15.22.05.51
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 15 Sep 2026 22:05:52 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-39af92138f9so3058867a91.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 22:05:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789535150; x=1790139950; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+i3/9cwENYafIlAkV2jcoorZwd9xMxSWurzxiZS8EDE=;
        b=NNf6TgtceT7gAOWuOonSAvhkQUDims2WhHlhxDL7YuosK0PS4vhU8Op8uLz9ZDfr81
         jYXUc/1u0Zd7F86a6IKE2Ifs4pXsSSWP7Xfh1iX4mOX1FAFeMN2ip22/+RKsqNqeiErz
         RUUM7GSz26KrV5NerlYPoxBhcHh7xRE/3liIQ=
X-Forwarded-Encrypted: i=1; AKwUvBy3Dnq5H2PY4Vh/meIW2qEkTkLEQezTZvxAh/IJLpXQ1+NLKPuid3ngJsJS53CF56rAAMRAoR8FTg==@kvack.org
X-Received: by 2002:a17:90b:39a6:b0:398:a649:8fa3 with SMTP id 98e67ed59e1d1-39dfe1c9d0emr9817221a91.23.1789535150531;
        Tue, 15 Sep 2026 22:05:50 -0700 (PDT)
X-Received: by 2002:a17:90b:39a6:b0:398:a649:8fa3 with SMTP id 98e67ed59e1d1-39dfe1c9d0emr9817170a91.23.1789535150025;
        Tue, 15 Sep 2026 22:05:50 -0700 (PDT)
Received: from vertex.localdomain ([192.19.144.250])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bf5e40494sm3951386eec.15.2026.09.15.22.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 22:05:49 -0700 (PDT)
From: Zack Rusin <zack.rusin@broadcom.com>
To: Borislav Petkov <bp@alien8.de>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	x86@kernel.org,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	virtualization@lists.linux.dev,
	bcm-kernel-feedback-list@broadcom.com,
	linux-kernel@vger.kernel.org,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Bo Gan <bo.gan@broadcom.com>,
	linux-mm@kvack.org,
	linux-arch@vger.kernel.org,
	linux-coco@lists.linux.dev,
	kvm@vger.kernel.org,
	Zack Rusin <zack.rusin@broadcom.com>
Subject: [PATCH v1 0/2] x86/vmware: Share steal-time storage in encrypted guests
Date: Wed, 16 Sep 2026 01:05:38 -0400
Message-ID: <cover.1789488039.git.zack.rusin@broadcom.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 9npsn63hre4n9ei3fj7wc9o7m694mcdn
X-Rspamd-Queue-Id: C5B5C40003
X-HE-Tag: 1789535153-420067
X-HE-Meta: U2FsdGVkX1/fCSGqCTnJzOgM0a3mpfn8OpwmS9vtNlE5/VD8aJ2FrOKQoUeu616h0DJfGMKibHs/H2HQIMLw/sJh0DinmrtNTwJMGy5EEQNJFrOcrztCC+vUqbPk4W/TAKAfaqqSn6kuTyWVWKMxnj6AR+fIfRIvIr1TdF5GQmnd4aT3E25fdebl5cSbBMbhhY71pXKTNYJGJP/VjH84EljpNWGf4AfUSOrNWFWVhy+o/i54buarLlWAHDgWx6tqdvRLJlsYrFNaV01P/6epSZSu1Z87P73H4CyHHWUnLzNlYSCyQAhwW2/Ga1JGEH4X73VLEejv33OF5c5y1AcdjjH/kun5H8D46UySQ2E8wBw9gmcWgQvbe0NXBUtxs2+qff4M86bV8P4yeuvv8q763IL+H9STBgoVuNlLGYKBTo+8jVCZvMDV5avnfGWfw7NnhPvedFrQcHXB0soQhVbnQyu+Wjy9+yfLvjIfvy6OqMwbe0cAucs7rR0JE8yy8z4FQywl78GxWE+xTKT2uQewlL8nalBe+2lclbCU4RB0xOLjlcHeNrYM+EZvoyFKhpzvlfm6WFmLUhxl/XSLOCjSmkP6d+bOU1Q+UZG3Vu2CKGlAIgdRjWm9JYocBrcnp9zdo845gx1crWcztjFxMAWOuqTXS3eGL3w+Bax38udtMO4KsfhSYGnyNaRWZOQnBnAF6cwDMlo6zdT84tcoitUwTtwFg1+c5S7hma2LmyIUG6mw9ktNGXyqTOSabnkUorqlCNeegVbOV8kRHlUJQ6UpGhbZMuZz+FijZqi1I5V+1Qhw+ClHtn0aXfwDyHyXg84cEdv1UeYK2YeDuQf5N4AjJUKn+IeWNyuIkAyxBbHfYevtrG+oW+wSjPWPrSt8lnLRMOTPjOjTCtpFkh/GBoPue0HrjR6m/KnvXi/sw5MistwkNe5yATfJxmNGiHPmntNxvuhyERgDTbolU1LxAt7
 Mwue+3ZB
 ysB7JEHjxAX47zAe9ky0Zy99jK+Ns6fnvODbV5zcesvMYAmxG0fYsCodafZ6IKw1hRe5fVYFlraa5e25AAOCa/sSYoNC4yEUQu/HdabJ2fd/VSKBf7LizM2OKZ4o4dUCfYTGtB4g2K2OCCBN/keC1T5l6Fv6eXRxw8/YBR3SXEbiCC1TAyIzOb+4yQ2r/lDn87ru9E5hmj/8dUSkMk1udfyxbt+Etnrd3QOVkHe8Q2oUtN3w6DIgVLiMCmb2Kq3JlXYH/wrM8yry/GDRPft2Mx2bmIu5BZTDDKX1jxkvQan1rQAvKUDrG/p3QftoNc3anIWikSnmLNbSVMke5WfowrILFJqNBfWHNUFGnlfbdmCyiXda2rOkCK4mY3jGZJZ8hvrkGkF7BF75sU6LYKJp7aP3M3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VMware registers each per-CPU steal-time GPA with the host. An encrypted
guest must first convert that storage to shared memory, but the existing
setup publishes the address without conversion.

Patch 1 makes the decrypted per-CPU section available with
CONFIG_X86_MEM_ENCRYPT, including TDX-only configurations. Patch 2 defers
encrypted-guest setup until allocator-backed page-table splitting is
available, converts every possible CPU's storage before publishing any
GPA, and attempts to roll back all conversions on failure.

TDX's conversion callback uses __pa(), so patch 2 preflights every possible
CPU and leaves steal time disabled if a TDX guest uses vmalloc-backed
per-CPU storage. This covers percpu_alloc=page and automatic allocator
fallback. AMD encrypted guests support those mappings and are not rejected.
Supporting them in TDX would require a separate conversion-API change.

Conversion need not preserve zeroes, and the host initializes only the
8-byte counter. Patch 2 therefore clears each 64-byte object after
conversion and before registration, without disturbing other decrypted
objects that can share its page.

The intended merge path is tip's x86/vmware branch, following
commit ac26963a1175 ("percpu: Introduce DEFINE_PER_CPU_DECRYPTED").
Per-CPU and asm-generic maintainer Acks are requested for patch 1.

This replaces patch 4 of Alexey's v2 posting:
https://lore.kernel.org/all/20260309235250.2611115-1-alexey.makhalov@broadcom.com/

Zack Rusin (2):
  percpu: Use X86_MEM_ENCRYPT for decrypted per-CPU data
  x86/vmware: Decrypt steal-time storage before sharing it

 arch/x86/kernel/cpu/vmware.c      | 96 ++++++++++++++++++++++++++++++-
 include/asm-generic/vmlinux.lds.h |  2 +-
 include/linux/percpu-defs.h       |  2 +-
 3 files changed, 97 insertions(+), 3 deletions(-)


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.53.0

