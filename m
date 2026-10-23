Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A898606A333
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 05:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=tQffM7ad
Received: by kanga.kvack.org (Postfix)
	id AA0DB6B0337; Fri, 23 Oct 2026 01:45:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4AD56B0339; Fri, 23 Oct 2026 01:45:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9602B6B033A; Fri, 23 Oct 2026 01:45:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75BBE6B0337
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 01:45:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E612EC028D
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 05:45:23 +0000 (UTC)
X-FDA: 85352803326.13.F28C56F
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf31.hostedemail.com (Postfix) with ESMTP id B20D120009
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 05:45:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tQffM7ad;
	spf=pass (imf31.hostedemail.com: domain of 3cPTaagcKCCMFSGDKDMFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--gthelen.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3cPTaagcKCCMFSGDKDMFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--gthelen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792734322;
	b=j1A1lnplc5rcTio28ieVrajQ/jfnigloFTmwpdZGmUrUouAXvEslQHLB9+6GoJFiGdFKdt
	zXXtrOvBaa7mnhG4hCRKKXBneygj8V7/T8/Wu1ah5a0QxGW/6TP2LViT9gstd1OHXqDys4
	X4GMW1A+u+UWZHvZ51Kj+MAif/wSrZA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tQffM7ad;
	spf=pass (imf31.hostedemail.com: domain of 3cPTaagcKCCMFSGDKDMFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--gthelen.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=3cPTaagcKCCMFSGDKDMFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--gthelen.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792734322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zx81mJCQGymu1OZlc3jNrPjZqmEatAtALfsBDY/sthM=;
	b=5FsDO2b/8tJMaKDjU+zZU/EPpKwShQpIPIasaXHHLWNfPuS2vXTWNrGG+hVTo24jYpe0gz
	XjP7NfjB+43fZd5ndv8EzZwZGTFtuzKL6p4gGLIgo2e0+TVYesVv5gkpL2ycra/+/0zDs+
	mZZhyIFVYRG9VMmtcZZb6TthuDThtp4=
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-33c35f5ca6cso906015eec.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792734321; x=1793339121; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zx81mJCQGymu1OZlc3jNrPjZqmEatAtALfsBDY/sthM=;
        b=tQffM7adX3ONgiZ3rsJ1ypS5dC+iae+ZNTWCnilxv+jZ3TfxeNCxEX6mmTyH91emu1
         Z3Ygv1x81PKlF3KaD1u3KdsU/GCD7Pdp87oyBTVr6yjYsAMTfRYKXBDRbsgt+XPaVYe+
         DmBvvIKBbMYJb/Kj7ssnICJRNkvibEiAcmXT++HXd212EZ7bvT8cZPRK1b179cSe5G2b
         xCYMk61mK+Tz2jVQOmIv6+yQ6cdMxb0K98M2RCbladOZ4RU+r3dq84aa3fpC/inGwA9L
         CjYDSmyqO3ciIkseZVKf6Y969bAsq0ceKF+3UORL/kb0yMueU5TU2rnJNkzxX02aj8XI
         97bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792734321; x=1793339121;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zx81mJCQGymu1OZlc3jNrPjZqmEatAtALfsBDY/sthM=;
        b=mFgYl0zQoTUfKfO7imK+1e9Ai2emWYYucd39AAC1qnivxg0RylD43Hbo16KjKt5cKb
         79vDfXGpUVBnLudFFZkrIiWHdeeZgJ2Mr/iEsCrgfL378dBIPrjdyOUKbN76fnqaUSOd
         BbeSheiugjPRu6AqFK7cPFfo/pnl/loSZda68R/0lyK6aEGgd29VnCMyqZDbvI7zW+mN
         bzqMw4S3zF3Q+mgtePBTzIdBzetHnx/cDfRPjpkjhNbLqVa8ZV8MuF5LIjET91UBrU15
         vFsIYkOLn6bTQxvLlMlajm2X/5zjtKK6Ro5EwlD09rVhJahkJhodfUeHdxMLX2UcPfS8
         biTg==
X-Forwarded-Encrypted: i=1; AKwUvBxZt3QJBf0WXX307OisN3DBWvqo3qEVAnZDudL7qbejvwVS8MXy/Q1KRqqTKVYK9HOt9wBm6BY3fA==@kvack.org
X-Gm-Message-State: AFq9FYJ/tQPlvTGyzbFcmeOLem2IMF2P0u+feFOUIBndi4lzuvJ5RqEO
	1Lh8llLJupJ4ok9NjU1CHP9h0iY4mRJNmGas+7M0yRugWBW8ebRwO+qUgScMLjyibKO+374O53l
	eOriTYraU+A==
X-Received: from dly16-n1.prod.google.com ([2002:a05:701b:2050:10b0:14a:84ec:bd53])
 (user=gthelen job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:28a:b0:18e:355b:f6b3
 with SMTP id a92af1059eb24-195c6e0b80amr1891111c88.23.1792734320663; Thu, 22
 Oct 2026 22:45:20 -0700 (PDT)
Date: Thu, 22 Oct 2026 22:45:18 -0700
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.257.gf7497c7d27-goog
Message-ID: <20261023054518.3258350-1-gthelen@google.com>
Subject: [PATCH] kho: check fdt_phys in is_kho_boot()
From: Greg Thelen <gthelen@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Evangelos Petrongonas <epetron@amazon.de>, 
	kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Greg Thelen <gthelen@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: B20D120009
X-Stat-Signature: qg5skfu3zbw6faksiw1cpc15nxuch7bb
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792734322-112876
X-HE-Meta: U2FsdGVkX1+u/eXQvYBFI4SiWmVO1XeicA8+JkEAS+qQUoQ1sDCBV45M4DVjfIqh7c76QoH5CrMknWzRf+uZiZskhE8HlRSlYnpoywtaNPc7JIAg+ULXSy9u8K1pvvPYirEI8hjnvQLqGesKlopkwiBshMukgQphsliWnaBXCVuca/8+ZTcM++aig67QRMwJJE12GVLlN2BpsmIR4CR6mmDeP8tlqe5iS7LeETfMckm29G+7vX3Xd4JXTW/Xs407lhI8tINlfz034fatDH3q4UKuEnmAteUoJvdXVoJu9r/oz9cjnnvtwe17Rpbgr5vR9s6vaBzS54he7Dzrqifwa+Dj81R/8Bq5IPjBgHQSuHEIL86WRITxL5AcJNW6DlYFWGjWeP4f0MPZdW2cs4tHnUeApKWw8AzTfwZ9LJ9GUNR6/AgqRFFZ8eu5luDqh4Nm8PaZrxxnt8Lk/qLx42qT1US1l4MuKbBkqv97oXYY1sx0jy8l8KXDUIpq13IGwrjdxTzxCHhS+oO+EVSmSB/ETYJRS56wGXQNEYdS+/uEp72eRSE5lZdzaJlBl9wsZ2dG7l5/keM5Xq2B5dKNwRP71TDR/xHmtg8YBxSpt30W9MX01R457VIP1iq6GALPH6Mw/Ihe83eUKVD/L4An9Le0FqsQ2uz8xCjOLPdQ2WwmEOJO+Dy8/SmtIXOm7qDPzeuh2Nmls+fK4NI+sGuyEJvS9T5jclwmB7t9T+hiru4cEP7MkyIF4NW9b/8z/NU+Jepxv6q/g8AizclFFvywhNxq2oEohW7Cdmh3a55VS2tBd1sIfmBgvmm4QRmfwgYRymdPrTRzc+vB/fRHEwctY2pTfw6O1lQKIPHUaBraAY+uxTJYYkZukNTyJMuaNmduxMTGKDMt7Vc2muIQlpIdGT4P47R04/gf7Kcd0Rnu/hpgcuThLJ9PvqTpnWHWqJ6TwyummCjc05GU8XqGiQNdYr9
 LtoYUcR5
 afG7BJPd4FjNrA2t+3nTuxD+Xpq58FOsmwMHo7VLBMBVdfTGL2mu0hxNmyr2xxsIDEIqvNKLxX8PWrGBRtrQAt6+fnPNExdJMxHIRvPUmO7qmwtdWyjKwIy/zvlSPoU80tZXAND30RFfzodD9tI2sldH+YxELjFEQ86Kd7vWhH6ov4gCkf1Nen5QFlQKFYBNhi8xIlHU74kFND9L9CXGWz/yIFnWmNGI9ilQNdVRHAmRrp6NbMBcG2/+f95VkqX5Sl9y+EY/MrdN5SFZjizbkxaAqMn94wBEdYwyHibPjQWby6+gRhLgZ1sV4ajego4lGiiXoQeKfPaRuCtGgIQiWqaTI0x/9gLrlpownl3Sutvg6EujPT5PpZpwpnFbSzDoZlQfIttjRorz7YytkPBYbeWJ8IaFSgh8guBdQCF6OBH5sNSqxBJPpcEShU7hrUbYON1Q0TQ2RvVI7DTuk1o6b9xz5ynrtpPKPIHSi6eaDLCy0HwF7TMXIcbPRVD7eTVkNfmDpLkDALFDrHjCcKR+3tPjtUaWnyCVygImCIw36QOvR0Jkv8JAqJfrAy7GBtljMg6+EMGo7T7yd1Lhh3O7jez0nnQ09cjUkitkI8j+QTtTT2hKoQf4E4mBm83UMAE1fsTIK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

During arm64 setup_arch(), efi_init() -> reserve_regions() calls
is_kho_boot() before arm64_memblock_init() initializes memstart_addr.
At this point memstart_addr still holds its initial sentinel value (-1).

When booting via kexec with KHO enabled, kho_populate() sets
kho_in.fdt_phys from the /chosen FDT node. Calling is_kho_boot() ->
kho_get_fdt() invokes phys_to_virt(kho_in.fdt_phys), which evaluates
PHYS_OFFSET and triggers VM_BUG_ON(memstart_addr & 1) on arm64 kernels
built with CONFIG_DEBUG_VM=y:

  kernel BUG at ./arch/arm64/include/asm/memory.h:377!
  Internal error: Oops - BUG: 00000000f2000800 [#1] SMP
  Call trace:
   is_kho_boot+0x2c/0x38 (P)
   efi_init+0x94/0xf8
   setup_arch+0xf0/0x240
   start_kernel+0x84/0x490
   __primary_switched+0x88/0x98

Check kho_in.fdt_phys directly in is_kho_boot() instead of calling
kho_get_fdt() so that early boot callers do not invoke phys_to_virt()
before the linear map offset is initialized.

Fixes: d6d511639185 ("kexec: introduce is_kho_boot()")
Assisted-by: Gemini:gemini-3.8-flash
Signed-off-by: Greg Thelen <gthelen@google.com>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 7c4d86daf86d..d81baa38497f 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1630,7 +1630,7 @@ EXPORT_SYMBOL_GPL(kho_restore_free);
  */
 bool is_kho_boot(void)
 {
-	return !!kho_get_fdt();
+	return !!kho_in.fdt_phys;
 }
 EXPORT_SYMBOL_GPL(is_kho_boot);
 
-- 
2.56.0.257.gf7497c7d27-goog


