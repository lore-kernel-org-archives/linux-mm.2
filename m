Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 500E3606A321
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=aB2KrtcG;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.a=rsa-sha256 header.s=susede1 header.b=a/D28pZ0
Received: by kanga.kvack.org (Postfix)
	id 51F196B079B; Tue, 24 Nov 2026 11:01:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CF186B079D; Tue, 24 Nov 2026 11:01:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4CA6B079E; Tue, 24 Nov 2026 11:01:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F2F4F6B079B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:01:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 80AEA40C38
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:01:03 +0000 (UTC)
X-FDA: 85470476406.04.E3077FB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 417862000A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:01:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=aB2KrtcG;
	dkim=pass header.d=suse.com header.s=susede1 header.b="a/D28pZ0";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of nik.borisov@suse.com designates 195.135.223.130 as permitted sender) smtp.mailfrom=nik.borisov@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795536061;
	b=i+yYMSRepV6oxYfzrJMEQGbcNuX++cr/ulwnQdm5bUZDBeZ4L0jwQICUSo8qGpK5l2j7e5
	DRnHxtcBBHkTnJkB4TPZK4x1s1FM7RMBMnn2dez5L+xbhFQGVbqKpZ/JB/d41d992EdStY
	8NTkjQbwu96VCUrqPOtel7r3uAFP4QE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795536061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=P/DvJ2vRZ8dB3FMLgxRKtDBnTYkrprwbvvpqR8tcuSw=;
	b=ABcA2qBYsKCnywvnQBVjTtZEgjrmE6j7MT6mdgssLUxlI1PhKuDngZYINMZtBJtGUDXqSN
	SvFwrioWb0ltnLqJtMQjyQ35RGxhCZ1izCHJbWoVaY4qQd9PlYBIrnj5fas5A0lKNiMPgt
	Yu8d77DWUeXKo+C6zm30m6jj9XTcyj4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=susede1 header.b=aB2KrtcG;
	dkim=pass header.d=suse.com header.s=susede1 header.b="a/D28pZ0";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf03.hostedemail.com: domain of nik.borisov@suse.com designates 195.135.223.130 as permitted sender) smtp.mailfrom=nik.borisov@suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 78EBB222F2;
	Tue, 24 Nov 2026 16:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795536059; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=P/DvJ2vRZ8dB3FMLgxRKtDBnTYkrprwbvvpqR8tcuSw=;
	b=aB2KrtcGZmdfhOtzISTeDeGJTe01UbsyW0wJL0IPhgq7v7UK77pyiAYdbYn31kRRpTOem3
	mG7Bt+U9ohTQBE5t9APKJaN8heXJ14JHdGtFCiu7H8fV0bhIAI/VNlRIeWj5UakAn7zC7q
	ZCijryk8MP035APcnTqMvfDWIHhE/yo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1795536058; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=P/DvJ2vRZ8dB3FMLgxRKtDBnTYkrprwbvvpqR8tcuSw=;
	b=a/D28pZ0961G7Xu9Ipa0/ic+tmNcAK3Fe5Sj+vYcF/ksv0Yq1yl3Kn01oOZjEDhYKjsJm6
	SEmDly5OCotCuMS/mpXq8XwRJ5yQ/tqEErKwwzxm+iJ8T5wnyJcvo8pF26briYOhggNJ8Q
	GThBJmvtfkObkUEW7mfdOxuaXNmMHG4=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8493A1339F;
	Tue, 24 Nov 2026 16:00:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Pi4gFrm0BWtKEAAAD6G6ig
	(envelope-from <nik.borisov@suse.com>); Tue, 24 Nov 2026 16:00:57 +0000
From: Nikolay Borisov <nik.borisov@suse.com>
To: x86@kernel.org
Cc: mhocko@suse.com,
	kas@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dan Williams <dan.j.williams@intel.com>,
	Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Vishal Annapurve <vannapurve@google.com>,
	Kirill Shutemov <kirill.shutemov@linux.intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Naveen N Rao (AMD)" <naveen@kernel.org>
Subject: [RESEND PATCH] x86/devmem: Drop /dev/mem access for confidential guests
Date: Tue, 24 Nov 2026 18:00:26 +0200
Message-ID: <20261124160025.738362-2-nik.borisov@suse.com>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 417862000A
X-Stat-Signature: gzp1sh7w3d9j486kqb8bn7drqhrjru3u
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795536061-413262
X-HE-Meta: U2FsdGVkX1/w+RKSE9hbmU5P/bnnpiP9UaJzot7chxOTnBmFb9v7R/Iscss5vDQ7j9yat3cXbycM2t1XqlCzt8a35pHyFyr6jYFgLPOuiAApVM88l7jbOImdAk63FQNFnPT+QoJUlG0Khfi2Q4C68uKe0U/G3qMUUBAqNis2H6BySOJUPbTR/z2+xYtbi4K2p3r5U2HfaicGmEEK9y4Tj/5B7bXNAJ9DFUhczqfUZfHX/+mnjkgKh39Z/I6tiUEH0159qFuGPPf49VyFpA7+J/LOkR4jR0sC4mqiv2dgZU3JHgx1T8AyQ6AD6QOrqSopUwLWMCbS7jXPYhFNe+8ggc9Sh9qbKlHeMmuYZu/Fyuw7YNsPtwtAvUHB1p5+s69+ZoNSqnvTx6Njd1gadU1RuPmunGTqodmkbFohT5WMKjw2RTZR0OiNJbgVvDeEKD/sgHw2HqlUUcmE+P8kTxbzKo7nFjTOLQaxl3TwS2rKkFdZh9OeodFj9HV+GDuRqrzutolZRsjxYdxyYnKCJwDAYsJkAmskinVG/BrN03tG511gW99Kv89Bsrp/o+k7aFh5tSH/d+K+Rw5mY05adG3IgThBGp0I6A3ztCfEfoUPkM46byzKqPAMHDsrwE7T2tLR+Pd/yi7U/CPk9wZQmAUVL1CSWKK9Rg3V1MhGsyheumq8kzVLmJXp0m/4XwpJ0gF1LCgyKoLt6aZb4jKQ8kFuDeEHhZKtMGuHkLwUxLpyWVJXOeKFYD7zEFVJeg3lLw20fvo3e5eEdbAUf6zOdS7NGM0w88dL/S6ygxguK4dTU4OHGYExfLRvCnHzVGvlm4GAIOvTsLJ9Z/vEUoOwvS+I2B3ZxEXPlSv9JQni+LyApYvJd5WSZvRQG3Y+kqQqIXTTaSus9jZy1l+OPyA8RUYo/pFsLHkpsT73T2B0Z4IGqFh/delrZquhn8wB35LaqnyVlbO55zJ3/AW4Tl2xsCu
 FPV7K7lr
 7SXzGvVQQmlLNCVkI86FQdjcD7Wnd0dBdW0Be6/DaV038/fu0u2Y4X8iNv+L7i5zquDEsBN8lpBMygD5IjZBvdT1yLWiYWE3T+oT04Oq94lgwxZdX1ahHxc4d5PuQ4yvODaYOUq4luYWX8qNSMt23VB6B+Tgh3/TvSk6oVpqBqHt7XDgehyNa5jLmy1fnNXZq5hCLFdpujLeTbmHplqtMUOc8nDylEIrGy/7LdPFlROba/Er7vzfZCJ/obeZzb/xMYPIxY8T6PO/lsq0e1Gr9NlwEhUVqkjdbWcPBDz2OuoM1WciTeXky+h6jrqDJ9L+P7GgVMHyDwGcp31N2uEtiAhucf0HhCW/AVn+MeL0oPVG+NWUySiZjNJBx6blQoQm1vWOrpj2wtNbQVz7wparWm4Icax0CM+Gpc2fQ916qXI9ZopRKL+zCRPHzW6vgLn3WBFinol4HtoyTb1JEsAcozSG54MeWKQC7U3O8H2t8es8n4zsXo0gZMwhth6LT8JW11x76jd5DXqnAIpyq7IDeSlPfh3aOit2LOyK3miXTaT2ZvUN6qL6oLXgeIDVuUfjVxkN5qmIQoKo3EBaSreJHCwqJHb+OlNxaXuL/8A1VuitCWw1cc088ZR/DttJJhJMXTeRMtdIu/rfUyUOel1fj5qjCpv5vGNTBf+F6nz+677town9nOQcgVJbbmKk/ceWdV8Dkp+FNZKCrw0AytO0RUZji+wR1KNMZx/aL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Dan Williams <dan.j.williams@intel.com>

Nikolay reports that accessing BIOS data (first 1MB of the physical
address space) via /dev/mem results in a "crash" / terminated VM
(unhandled SEPT violation). See report [1] for details.

The cause is ioremap() (via xlate_dev_mem_ptr()) establishes an
unencrypted mapping where the kernel had established an encrypted
mapping previously. The CPU enforces mapping consistency with a fault
upon detecting a mismatch. A similar situation arises with devmem access
to "unaccepted" confidential memory. In summary, it is fraught to allow
uncoordinated userspace mapping of confidential memory.

While there is an existing mitigation to simulate and redirect access to
the BIOS data area with STRICT_DEVMEM=y, it is insufficient.
Specifically, STRICT_DEVMEM=y traps read(2) access to the BIOS data
area, and returns a zeroed buffer.  However, it turns out the kernel
fails to enforce the same via mmap(2), and a direct mapping is
established. This is a hole, and unfortunately userspace has learned to
exploit it [2].

This means the kernel either needs: a mechanism to ensure consistent
plus accepted "encrypted" mappings of this /dev/mem mmap() hole, close
the hole by mapping the zero page in the mmap(2) path, block only BIOS
data access and let typical STRICT_DEVMEM protect the rest, or disable
/dev/mem altogether.

The simplest option for now is arrange for /dev/mem to always behave as
if lockdown is enabled for confidential guests. Require confidential
guest userspace to jettison legacy dependencies on /dev/mem similar to
how other legacy mechanisms are jettisoned for confidential operation.
Recall that modern methods for BIOS data access are available like
/sys/firmware/dmi/tables.

Now, this begs the question what to do with PCI sysfs which allows
userspace mappings of confidential MMIO with similar mapping consistency
and acceptance expectations? Here, the existing mitigation of
IO_STRICT_DEVMEM is likely sufficient. The kernel is expected to use
request_mem_region() when toggling the state of MMIO. With
IO_STRICT_DEVMEM that enforces kernel-exclusive access until
release_mem_region(), i.e. mapping conflicts are prevented.

Cc: x86@kernel.org
Cc: Kees Cook <kees@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Vishal Annapurve <vannapurve@google.com>
Cc: Kirill Shutemov <kirill.shutemov@linux.intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Link: https://sources.debian.org/src/libdebian-installer/0.125/src/system/subarch-x86-linux.c/?hl=113#L93 [2]
Reported-by: Nikolay Borisov <nik.borisov@suse.com>
Closes: http://lore.kernel.org/20250318113604.297726-1-nik.borisov@suse.com [1]
Fixes: 9aa6ea69852c ("x86/tdx: Make pages shared in ioremap()")
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Acked-by: Naveen N Rao (AMD) <naveen@kernel.org>
Tested-by: Naveen N Rao (AMD) <naveen@kernel.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Nikolay Borisov <nik.borisov@suse.com>
---

Resending this with the hope of either getting it accepted or arriving at a consensus
what exactly is missing so that I can take it from there and eventually get something
merged. As previously mentioned this results in real problems for confidential
guests both on TDX as well as SEV-SNP.

 arch/x86/Kconfig |  4 ++++
 mm/char-mem.c    | 10 ++++++++++
 2 files changed, 14 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 3159852fd6b3..1490e0019c71 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -901,6 +901,8 @@ config INTEL_TDX_GUEST
 	depends on X86_X2APIC
 	depends on EFI_STUB
 	depends on PARAVIRT
+	select STRICT_DEVMEM
+	select IO_STRICT_DEVMEM
 	select ARCH_HAS_CC_PLATFORM
 	select X86_MEM_ENCRYPT
 	select X86_MCE
@@ -1490,6 +1492,8 @@ config AMD_MEM_ENCRYPT
 	bool "AMD Secure Memory Encryption (SME) support"
 	depends on X86_64 && CPU_SUP_AMD
 	depends on EFI_STUB
+	select STRICT_DEVMEM
+	select IO_STRICT_DEVMEM
 	select DMA_COHERENT_POOL
 	select ARCH_USE_MEMREMAP_PROT
 	select INSTRUCTION_DECODER
diff --git a/mm/char-mem.c b/mm/char-mem.c
index c5761ddedbd7..5d383befd87d 100644
--- a/mm/char-mem.c
+++ b/mm/char-mem.c
@@ -30,6 +30,7 @@
 #include <linux/uio.h>
 #include <linux/uaccess.h>
 #include <linux/security.h>
+#include <linux/cc_platform.h>
 
 #include "internal.h"
 
@@ -609,6 +610,15 @@ static int open_port(struct inode *inode, struct file *filp)
 	if (rc)
 		return rc;
 
+	/*
+	 * Enforce encrypted mapping consistency and avoid unaccepted
+	 * memory conflicts, "lockdown" /dev/mem for confidential
+	 * guests.
+	 */
+	if (IS_ENABLED(CONFIG_STRICT_DEVMEM) &&
+	    cc_platform_has(CC_ATTR_GUEST_MEM_ENCRYPT))
+		return -EPERM;
+
 	if (iminor(inode) != DEVMEM_MINOR)
 		return 0;
 
--
2.56.0


