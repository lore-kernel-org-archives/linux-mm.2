Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C98ECCCFA04
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 07:23:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A86A8E00F4; Tue,  4 Nov 2025 02:23:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07DCC8E00E7; Tue,  4 Nov 2025 02:23:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E8E8E00F4; Tue,  4 Nov 2025 02:23:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D87A58E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 02:23:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD7DD8730C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:23:19 +0000 (UTC)
X-FDA: 84072083718.04.A646FC4
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf26.hostedemail.com (Postfix) with ESMTP id C7860140004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 07:23:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=C1JJhkDH;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762240998; a=rsa-sha256;
	cv=none;
	b=ijn1m1chDSbesEaEg5QWoo3wpZ0cC+822mDC/lpZT5TVHjt9O3QFoT/cWwXnrMtd2b2yNe
	CMIHivxkBZdhrMSXZ8mSw5sAwR1KZp989VtnqmRrtXTpfXWzCjdpyFgtyxMlBBx8IlIwcN
	sP4wSzWfBQP3k0YEnkeLhGTwNAbUW38=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=C1JJhkDH;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of xieyuanbin1@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=xieyuanbin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762240998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cK/LrK5YkVfoW/vU29GcruuOm2WOfLzKveAet3dsFMs=;
	b=oPTcrw1P3UM134X09fWXggwg9s1rwjUwkySpGLqBOqkCvD2sUdk64scQESLApUfhKQ9bSp
	w3mPxO8gFbc3upBjTnKnjO3AKCGKgEDS2YHBDbYSff0j6wgt4zBz7RTAOVpa8kv3smiJCr
	10ouiMJEGOOEhL2PYqIoieFAnxqr9j0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cK/LrK5YkVfoW/vU29GcruuOm2WOfLzKveAet3dsFMs=;
	b=C1JJhkDH67RgJ+bVCE/mUq7QZf87TaTJNsNCfveQ6ZwV7f/jLJnmpxPbgf8pbZIMSkY5mo1sr
	Wgy0XtVzsh0asBbc+pbhfPZ3E7Qe5+7D6M9j0KPOojSxVmhvc6U2Ji2FehhlE1eRDyg7JVWDmtn
	3MXov9ffgryyk8CK15cFvIA=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4d10J246sMzLlT5;
	Tue,  4 Nov 2025 15:21:38 +0800 (CST)
Received: from kwepemj100009.china.huawei.com (unknown [7.202.194.3])
	by mail.maildlp.com (Postfix) with ESMTPS id BEA0718001B;
	Tue,  4 Nov 2025 15:23:12 +0800 (CST)
Received: from DESKTOP-A37P9LK.huawei.com (10.67.109.17) by
 kwepemj100009.china.huawei.com (7.202.194.3) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 4 Nov 2025 15:23:11 +0800
From: Xie Yuanbin <xieyuanbin1@huawei.com>
To: <david@redhat.com>, <dave.hansen@intel.com>, <bp@alien8.de>,
	<tglx@linutronix.de>, <mingo@redhat.com>, <dave.hansen@linux.intel.com>,
	<hpa@zytor.com>, <akpm@linux-foundation.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@suse.cz>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <linmiaohe@huawei.com>,
	<nao.horiguchi@gmail.com>, <luto@kernel.org>, <peterz@infradead.org>,
	<tony.luck@intel.com>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-edac@vger.kernel.org>, <will@kernel.org>, <liaohua4@huawei.com>,
	<lilinjie8@huawei.com>, Xie Yuanbin <xieyuanbin1@huawei.com>
Subject: [PATCH v2 0/2] x86/mm: support memory-failure on 32-bits with SPARSEMEM
Date: Tue, 4 Nov 2025 15:23:04 +0800
Message-ID: <20251104072306.100738-1-xieyuanbin1@huawei.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.67.109.17]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemj100009.china.huawei.com (7.202.194.3)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C7860140004
X-Stat-Signature: ci4z1mtkt16rafb3qmeifh3na6n9iw4m
X-HE-Tag: 1762240996-558863
X-HE-Meta: U2FsdGVkX1+PvIwT2Z3QRalX28Et+ofSEU55XW4BSOjTYeTPbga0xHISmzUXaQVuLl0AK/zjvk0odsQ8Mh1/bS80ZFzZ1c6PkruG5PLj3ht2OIoChltKz/PW/tlPYn5Iyy2NMa8ZDQZ7pioEuINkq10HNkKvzUQ36dDQ3dBe7yFQHUFhEypsEyBn1BrPqiytchxyYHzhtvMDT+BsricxJ4FjNr7e60lKlorZ8fAXJ3CDR0LVwD2fQOGAAvHQlO8+HCkyFQvjnJMcy4AlEWhGTu/BToy81Kb+rImZrw7iZVs7hrlPvKyP2rTacDphEguEMbbgR8QZHGmhFpGouXi0Xo4D/51POuiLEaGKGJqAxXgUyDX7awN+ZsHOlI5DvDwelmqxba4X8D0knD6vnQRUIClzb0K1jkjUst0SZjevkn0sSG+tgdVbC4Kqt9bUTz/uUb7zOsIlJ4iaodmh+s/r5e9JwVhvyTCjzoVX8iefFR2+G2eKrvqcDgdnmwyGMFDZ0qVGmIs6JmCkBvD/Y8pDE4gZZTCTxgosbrFo02RM2wvS8UIMaCFlpq25FJqP0h7elBZOUMV7+sjOd0NddvuT5ySnUQCJdFPQ/o2/WRA9Z7fFeyy1x8+3eg9M9gGBhnKe6+5hQ9zOmlANcwNHy8Qh6eo7U5zxsVob2pxq4yKgVNUttEZNzYHI9mdd1LfWJaEiYTyBTCg5E22Dp9QF6G0vC52WuOZy4e6YuxhZxT7+Mwpd9FGYTUbzhLTkkS+vqG4gSZMAkT5CsDbWIDtHF3Z58ehY8y0nXDcN31OGmMe0g+EvRr2sJnT00OkT3fjq6TCM/ZcWC52pY79kviBVZBZ+eLCF3IzTrF15uCyTLxyc3Je5xY1bJJTEtrx5lGa8WYDuD5uCkJMOPhhog8N2uX6Oq1mFVg+y9X5NZz15f/3WLZmKVi0PLRw8lCyjQOupFs/b3T/wDjm7vahXiRHPiES
 otFT0oJo
 unldkeRjlwC5sbjKMrYlcbiSlLFuX2rwu0C3ESD/z4laNr2Xl95V7Oc+G7OhQPn8lX9k554G/QwnkUrrzWXt/GsbLnfIWJU4tG8OV1E1O2AVMCUn0OrxkdU9Ef4R9G0tp8HL0O+a1VZOJAS0/v3Il3oBAwGz3mUV+PfXcpyb4nmksaTqFoC+bA/4eclt5pER14RUneFboIFDWfbUlCue2C26W9FLG4vOPJIFWI5mbApDfQAzQX2K/yzN2k2UVekN7fgsyxi44PwRemh+BanUljxm3V0ILQ2eH/FWaKcIgMmmOOzeSj2/cLXpMix13ZyIQ9hqvzAL+FVez79lCPMG46YU12kebyIXTpYGNtwbRFYV4EJu0sXrYC0MShv359XzIZw4O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory bit flips are among the most common hardware errors in the server
and embedded fields, many hardware components have memory verification
mechanisms, for example ECC. When an error is detected, some hardware or
architectures report the information to software (OS/BIOS), for example,
the MCE (Machine Check Exception) on x86.

Common errors include CE (Correctable Errors) and UE (Uncorrectable
Errors). When the kernel receives memory error information, if it has the
memory-failure feature, it can better handle memory errors without reboot.
For example, kernel can attempt to offline the affected memory by
migrating it or killing the process. Therefore, this feature is widely
used in servers and embedded fields.

For historical versions, memory-failure cannot be enabled with x86_32 &&
SPARSEMEM because the number of page-flags are insufficient. However, this
issue has been resolved in the current version, and this patch will allow
SPARSEMEM and memory-failure to be enabled together on x86_32.

By the way, due to increased demand, DRAM prices have recently
skyrocketed, making memory-failure potentially even more valuable in the
coming years.

v1-v2: https://lore.kernel.org/20251103033536.52234-1-xieyuanbin1@huawei.com
  - Describe the purpose of these patches in the cover letter.

  - Correct the description of historical changes to page flags.

  - Move the memory-failure traceing code from ras_event.h to
    memory-failure.h

Xie Yuanbin (2):
  x86/mm: support memory-failure on 32-bits with SPARSEMEM
  mm/memory-failure: remove the selection of RAS

 arch/x86/Kconfig                      |  3 -
 include/ras/ras_event.h               | 86 ------------------------
 include/trace/events/memory-failure.h | 97 +++++++++++++++++++++++++++
 mm/Kconfig                            |  1 -
 mm/memory-failure.c                   |  5 +-
 5 files changed, 101 insertions(+), 91 deletions(-)
 create mode 100644 include/trace/events/memory-failure.h

-- 
2.51.0


