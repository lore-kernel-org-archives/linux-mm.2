Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6D82FD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46C3F6B00B2; Wed, 25 Feb 2026 11:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 461266B00B3; Wed, 25 Feb 2026 11:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37A7B6B00B4; Wed, 25 Feb 2026 11:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 208B86B00B2
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:14:32 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B2A631A0664
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:31 +0000 (UTC)
X-FDA: 84483476742.02.4AEB4AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1B7FA140014
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772036070; a=rsa-sha256;
	cv=none;
	b=gD92X52XJeq/j9RSRoLpEPNtkEb0V2RqlHDY6lNX0xp1H9eGGUWLu/zHZ5yPhDWTNUZehA
	wWkivkRhPQggPVmJ/JAZe9CiAkWJ4aes+Zs++pGZxOWObVPvhlp2ym+qQPVLwdt1d1Gdxf
	67hsTYt3Hkd2sKDwN4uwdKxZFa3Cs2g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf09.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772036070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dZLLhlRjvjzxWt51eQTfnkEG1DQudL99bSXrKdaeGJw=;
	b=CvlFAGTB0AhK2TPWZhot/CfVJu+66vsWQggfIUdg0zZrV0EkGDFrf2Z/3A0ak2zBevKcU6
	xBDIBYPxkRjPIVM0TkHeH9WwfPryS6KXrO6BC0x5Sg/GhBBmZUKUBC0G/BzlCcKIc68+Rc
	2iom0XUn3q+4YRTPrGZeyAgqLqb32C8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4326F43392;
	Wed, 25 Feb 2026 16:14:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC27C116D0;
	Wed, 25 Feb 2026 16:14:25 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Will Deacon <will@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 5/5] mm: Do not map the shadow stack as THP
Date: Wed, 25 Feb 2026 16:14:02 +0000
Message-ID: <20260225161404.3157851-6-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225161404.3157851-1-catalin.marinas@arm.com>
References: <20260225161404.3157851-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1B7FA140014
X-Stat-Signature: o3gxhc8r4396q7tbkoxwusaaiojrae44
X-HE-Tag: 1772036069-875084
X-HE-Meta: U2FsdGVkX19gzsu3ZlA5kjV3uBSPfaRTjaZ97B+wiiUaqe5RCoPb66Z+SDKnSF9EmqZP/F9KDS7TIyAiDdVh83Fp9p59sEPGMrsC44bYJS3aCn/iOjiCSpI6K51RU30mKWjcvWfmjeSXLSwFrpLncPtyrk1qhMqN4hkZYiFSLtWx/xgqy4ocPFTqkX/6sIjjuUGz9VmGnh8CtAgqQW7kJa31cwa4lvRLhHhcZzhtDCTdKznvdyIepL5zsnFU7uBHx5oIOhi+MQM92/2+lps5vvP60Inuy96Y5DVN81ZSFXHO9hqEvqo481JZIaku8dDCjI8lyhS2ZdN1eJyZOA7NwZttk7MnteayMauY1EaMQuuAWmWBfkEz1nZPObBovFJg1dgGU+oSBPhuqrq/DKyVLKLPZuDZVPXiL+wKc94q/w3XQFlw/lN70PTfxbVYUcV71nMgmX/UJbia4yWOJsR0ctCaF4txJ3AR0DbPPyqJrB1OhD6Dx5WjhQDWJlRV7BUxEtGgWyw6mqAk8RNYqZmVhHhiil+xsmfDaVbwjxevszV9tcPc0izzPn5IBOFcX9acbEFHN7EsO5MLJanaERgzp4FZhy8Jwe9oW62UmO3D9omSDEORu4MkAVFIz9wgFo63ZqeK1jSMqZLPG5G7R01tWs4YOZtagx8xGoXbsP9E2W4xeRWcDm+hvqJ6sCjrND80HjkpS3qCuSLDJHgl2OwYUpT8SfpOtDZoBloQx8w8A5Ru7JwNBzxzsLYFLDPMcrmBK8KVTevCcKHtlblN0D0sIKQpoB1d5TLSgJNJReUmFKPJiMOGbd4xwXTgWW+j1OVm0IiMtOG69TOkoACWP3LPgLljQIAEaoF0voZfBlsr4y15bO3YT+k5F02820GxXovZCKmEYfR+kgr/cVds3lIiK0FSDkyEqj1hpeN0P/Wde+frAJkOn/RmeqlXBlTF5OxV2ZBnY45RaLEs0TIBgyh
 exL0kdw8
 eQAzptl3ZdhKPhnBYzcgkAapbfYdMTUaE+vEreucc25UNLq962MO+oRSfnQKwltHP7ldJnHPUmmA50npxS209xSbhAlHWMyp43qal6R4X77aNHmQRd9PJ0Y7LWeRtwibhhcEoe3PAygMsJwxJQiDds9q4Oq3XAqoxI5OxsO/3b1BJi3ExRAGS3yHWhVr2/aFMlz/Kn0sxIJXiJjMHRg37aE67ZN4Hj3nrL+D8pZ9aWtlpqaZzql1Qz0x6YDpAdLldIqlKO+/DGTgucQiR5YUnM4Tbx1PRWcE9CQc7nC/+ZwT+IVpAEZ1PDO6nWElMjxujm1qFcc/J3TBX4qPKJNbfYDDFBV3+DOtxMZ1INos5Wvs+x4KFnThaWRGYPRqtk4zyMgBtFtqaGn7MyHYaJ9XngWSjrMHYDFqso85l61xyfg5w5zIrgIxn5ewDwB8KA8kNuCKEqOs2ADdfoIb2qywVt+onkWZDI/AJDiRJ1LEwhwxeT4PlVKPBY3fUYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The default shadow stack size allocated on first prctl() for the main
thread or subsequently on clone() is either half of RLIMIT_STACK or half
of a thread's stack size (for arm64). Both of these are likely to be
suitable for a THP allocation and the kernel is more aggressive in
creating such mappings. However, it does not make much sense to use a
huge page. It didn't make sense for the normal stacks either, see commit
c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE").

Force VM_NOHUGEPAGE when allocating/mapping the shadow stack. As per
commit 7190b3c8bd2b ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if
THP is enabled"), only pass this flag if TRANSPARENT_HUGEPAGE is enabled
as not to confuse CRIU tools.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Tested-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/util.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index 51f7f417e91f..419cb81ab353 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -629,14 +629,18 @@ unsigned long vm_mmap_shadow_stack(unsigned long addr, unsigned long len,
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long ret, unused;
+	vm_flags_t vm_flags = VM_SHADOW_STACK;
 
 	flags |= MAP_ANONYMOUS | MAP_PRIVATE;
 	if (addr)
 		flags |= MAP_FIXED_NOREPLACE;
 
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		vm_flags |= VM_NOHUGEPAGE;
+
 	mmap_write_lock(mm);
 	ret = do_mmap(NULL, addr, len, PROT_READ | PROT_WRITE, flags,
-		      VM_SHADOW_STACK, 0, &unused, NULL);
+		      vm_flags, 0, &unused, NULL);
 	mmap_write_unlock(mm);
 
 	return ret;

