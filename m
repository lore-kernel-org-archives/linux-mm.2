Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9855CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:15:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 330BB8E001C; Tue,  9 Sep 2025 16:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0548E0019; Tue,  9 Sep 2025 16:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133348E001C; Tue,  9 Sep 2025 16:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1AC98E0019
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:15:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7DEBB140595
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:32 +0000 (UTC)
X-FDA: 83870816904.06.3E78290
Received: from forwardcorp1a.mail.yandex.net (forwardcorp1a.mail.yandex.net [178.154.239.72])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7F6D6140007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:15:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=neGSZgoq;
	spf=pass (imf09.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BrTg0k8lCV2HUq6REznRngkexlNL5x/b5e/pmlQ15ZI=;
	b=1fqtzKnmly3AO8R+SJ3i5Uef9UwzNaAcW+bFwzPnEKegUieKz9LeY3Aa1Q512x7ulu4LPl
	fWBkPF4p5YH+2BNTqtngwWiiV939RKpvGuRpWmoh3JLe5kDBNowITqASNqJnOD/bjbpHMv
	a57FpJfpTuXEYmOTBBkElTHeUErKXB0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=yandex-team.com header.s=default header.b=neGSZgoq;
	spf=pass (imf09.hostedemail.com: domain of arbn@yandex-team.com designates 178.154.239.72 as permitted sender) smtp.mailfrom=arbn@yandex-team.com;
	dmarc=pass (policy=none) header.from=yandex-team.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448930; a=rsa-sha256;
	cv=none;
	b=aOrlgS/7dZDL+TgcaEcD1cizIVarzvDdU92ceOILraFyydHSs1CqIIY5l8O1O+RCM5nteY
	1UGtCp8nbcNhO5latL592NPfyGwNgzixdm8Pw1NfYF00AFlBKJIxpTgIdhrdGQMlz4kW+6
	8DbJFu9Fh0P7X3RgTGkstl9APgdNcFc=
Received: from mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:3a87:0:640:845c:0])
	by forwardcorp1a.mail.yandex.net (Yandex) with ESMTPS id 03AC6C0178;
	Tue, 09 Sep 2025 23:15:29 +0300 (MSK)
Received: from localhost.localdomain (172.31.115.73-vpn.dhcp.yndx.net [172.31.115.73])
	by mail-nwsmtp-smtp-corp-main-69.vla.yp-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id IFQqlX5GteA0-l4Vy856v;
	Tue, 09 Sep 2025 23:15:28 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.com;
	s=default; t=1757448928;
	bh=BrTg0k8lCV2HUq6REznRngkexlNL5x/b5e/pmlQ15ZI=;
	h=Message-ID:Date:In-Reply-To:Cc:Subject:References:To:From;
	b=neGSZgoqXYXwpLcgher3hOxnbUXCh+LnfyKfxD6OWkli/tXddCyRc7h06ZF74m86Z
	 KOW7OV80CpU3W0NMV/XxwboV0qA0Cd5wpuLTqhRluGsQJYAxSqi2Imnkg+R/1mMtyN
	 lhAVl+kpBSt43LU/t9BrjK5i3nl0JtZpUGJwqX/w=
From: Andrey Ryabinin <arbn@yandex-team.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	James Gowans <jgowans@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Baoquan He <bhe@redhat.com>,
	kexec@lists.infradead.org,
	Pratyush Yadav <ptyadav@amazon.de>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	David Rientjes <rientjes@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	Ashish.Kalra@amd.com,
	William Tu <witu@nvidia.com>,
	David Matlack <dmatlack@google.com>,
	Andrey Ryabinin <arbn@yandex-team.com>
Subject: [PATCH v3 1/7] kho: move fdt setup in separate helper.
Date: Tue,  9 Sep 2025 22:14:36 +0200
Message-ID: <20250909201446.13138-2-arbn@yandex-team.com>
X-Mailer: git-send-email 2.49.1
In-Reply-To: <20250909201446.13138-1-arbn@yandex-team.com>
References: <20250909201446.13138-1-arbn@yandex-team.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7F6D6140007
X-Stat-Signature: 7t4gnor4dy8brwsipn87y8bbu4sfh9pf
X-HE-Tag: 1757448930-401706
X-HE-Meta: U2FsdGVkX1//ua2N4FQ5yGtNNWL9sDmJ3fcMBbU9wGYZJ5KcTP2hN3RBHlIkYR7bdgXdoIx7AvggM4CKruesmdXHRZMld118ghFqV+lH8i47ZrH7wxGwhLTWb58SGLHY/89N88hVoYMs/iPCACUhobDfxJynTRPVc8ikJ6RsSiPfVUKuhaaQlCnap29MRssOFbF91zVKR7WRL7/eNpP4itLWdTbjxPtMl+Za/reWtpJlzEdieKXOdL5P1RL8ZguRe+P91aZ8IibubHIdOuswkvtvxcLNMHYPywdIcKNFsfFHcDukbm6qcGxY4FzuijevVjEvaDEnPlUa2I4bPQF+2YIx+Hf2Qoi8W4TU7g/4BEgb8W924kPhNUgLF8XxcMfzPHltjD57kqq1IlMxJR+E01VVsueBJdNK+SRQ2VWi44oDKb4O0ODhUQYITs05a46ljbLs+pL5bKtZGSvXukNzeadgADCJukWPgNkCNRGCUeXBGi1/y2atVx9E2TDfbozRHFqN6T8EyHR7JmQz02XU7swXpWZxol0Ax2EgqaODEZmplDqR+R2sdV0J9kUY7W13XVTYjrCUwIe7m9UU8RtkHnFMzrl5Pal39p88kYD9ICeBH10LKztH4Pm+ztcYqJS8rb8VrqqTZp8dHEcEG8E47vFAu5Nj+0EYBDFskOl2aIqx2A2VvgjEhtX0CBXL9Ounkb3Vgbn9qeoJJsjsT/2TgaPVGzfzGEx5+bVpXCBS6DUbRczJLw8AE4B9zBPdO0zKI/JtJk45VVFpufqsCNqs5Vqae1Nyn80cbdCHI+jn3cTQKe7l4uOqWhZRAZGcqF1mLpiqYx++dFonEMlT9SbmkowhE3hRB0j6odC7m9uhtzh9fdh5ktWbaP2NSihp+RLcMf1xEl+vMDQGeuwX4A86RsJc8wuO8qfAKPc85sH8ck+kKOSTut4RzmtJEoEhYVvsq2GT9ZtttkbuqCbHTyk
 TjQCioz6
 L00+Tn2JD9QC820gyV4tyic73rfAHrfOmnhxt9x5Yh8CnRFAa7J0q5aQ7iusAD3pWYuA1A8m+Sk+bMo5qwK2PCdsk9aDBPudX1b05MW4sDDBSAe7scFL/hW+QPQwhLW+R2BznXCJL1AVAHesEp4atHTLVZ7gJMhgALWQJQJYvyExyQvyEhP8eRViqLs54RIxf5LLn6Ivc4V/3Qjb/tCkF/8/JerHAQrE8ntwos3PzmoRwoS2+65HsprN+ksIaMp1g+1LOeN1HltcQUjVsYWOo7RzZ//PD66hPt6/NJEtcD4xlUmX3LENIfD5/vElrHZ6kXNvOzLQgmEn6IgzY4gw+8Fjl2b6/YdyBtAvH5CqZ54NfqdhZpOita+P8bjs6eVcjT2OTw+rashe/imwxCcB5LoIzjtBpXfEGpOVuv1CqTnStKtE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move FDT initialization logic from kho_populate() into a new
helper function kho_fdt_init(). The helper takes care of mapping,
validating, and unmapping the FDT.

This prepares for using KSTATE in KHO instead of FDT.

Signed-off-by: Andrey Ryabinin <arbn@yandex-team.com>
---
 kernel/liveupdate/kexec_handover.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 364a69a2fa1b..e5a436893f5b 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1077,13 +1077,10 @@ void __init kho_memory_init(void)
 	}
 }
 
-void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
-			 phys_addr_t scratch_phys, u64 scratch_len)
+static int __init kho_fdt_init(phys_addr_t fdt_phys, u64 fdt_len)
 {
 	void *fdt = NULL;
-	struct kho_scratch *scratch = NULL;
 	int err = 0;
-	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
 
 	/* Validate the input FDT */
 	fdt = early_memremap(fdt_phys, fdt_len);
@@ -1107,6 +1104,26 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 		goto out;
 	}
 
+out:
+	if (fdt)
+		early_memunmap(fdt, fdt_len);
+
+	return err;
+}
+
+void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
+			 phys_addr_t scratch_phys, u64 scratch_len)
+{
+
+	struct kho_scratch *scratch = NULL;
+	int err = 0;
+	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
+
+
+	err = kho_fdt_init(fdt_phys, fdt_len);
+	if (err)
+		goto out;
+
 	scratch = early_memremap(scratch_phys, scratch_len);
 	if (!scratch) {
 		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
@@ -1151,8 +1168,6 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	pr_info("found kexec handover data. Will skip init for some devices\n");
 
 out:
-	if (fdt)
-		early_memunmap(fdt, fdt_len);
 	if (scratch)
 		early_memunmap(scratch, scratch_len);
 	if (err)
-- 
2.49.1


