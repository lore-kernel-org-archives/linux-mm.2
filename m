Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C1AACA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 17:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAB268E001A; Thu, 21 Aug 2025 13:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C81C68E0001; Thu, 21 Aug 2025 13:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBE698E001A; Thu, 21 Aug 2025 13:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A98D88E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:59:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C94F117E1F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:59:19 +0000 (UTC)
X-FDA: 83801526438.28.B5FE617
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf19.hostedemail.com (Postfix) with ESMTP id 5A79C1A0010
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 17:59:17 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=CV4e2eOB;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf19.hostedemail.com: domain of "prvs=321b76ff4=epetron@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=321b76ff4=epetron@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755799157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=S+gS8f64vE5JkLxSnB7ir6Lb0kF6iQE9gWFgqB32eCo=;
	b=NUPUTPiGGbXfNZzh+wHNIJ6bBysJZO92ku8HZL0BSh9L185CSeLLVTlWB/ZUBLsDUrrBZV
	a4WPFTHlEUrQ7nmGGS5H78H1TAMCeY8IkMPaYM0J9fKqZ4YsyknU64uiVmo0Pt84k9SS1l
	rTWJ+DS0kQgXTsg8fwEncuImgSBa2I8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=CV4e2eOB;
	dmarc=pass (policy=quarantine) header.from=amazon.de;
	spf=pass (imf19.hostedemail.com: domain of "prvs=321b76ff4=epetron@amazon.de" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=321b76ff4=epetron@amazon.de"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755799157; a=rsa-sha256;
	cv=none;
	b=jn2qEE8Sofd1MiV8GkKjkKODWgMWEhezM6dfzRTYtehA7awcf6uZcxH6nG4N8fqG65BMl2
	BGF7pCfP6QXSA8e5QbmpScJezj4LYPAGBC18kK7O1YiQQClcZgnJur1gqa1XZQKPg8Uhpi
	wuZUbx9Ssn3PbVOnZu/AEhZvvRT3soU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1755799157; x=1787335157;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=S+gS8f64vE5JkLxSnB7ir6Lb0kF6iQE9gWFgqB32eCo=;
  b=CV4e2eOBzV9vYhLJs33Uv1UrBrm/9Ji000mnVGzySvo4Ll3GukpVL4f0
   lBSWYaUiSfXWHhYI39DtkbeX2jiurJJnLE/dy6wUUIcbN++DIy5eVFfdP
   O/1PgFd8w7nYEtQbTUSoxqOIn/jMH+SbVN6tRTWE3e0edHVg0nzKz+eQ+
   xFvVoSoBKSpMSC5sHh5p3RIya2CQj3FL8j/VW6mXSnfzetbW4E3OiRzA1
   whIhUZTXVEb9uzQJzetPkC3LSw2EUHQqr/ySP57qjgrQJ49FfgDst/bzH
   ZvItylNdvt7SXqdKHUQuc0KUWcYPRJHKIA/ChB4klW4yS4WtqQ0qNdJ+l
   Q==;
X-CSE-ConnectionGUID: K8Hohe32Qp+Vv4T80IzDyQ==
X-CSE-MsgGUID: xyRxENLgS6O/spnd+SQBkw==
X-IronPort-AV: E=Sophos;i="6.17,309,1747699200"; 
   d="scan'208";a="1570660"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2025 17:59:14 +0000
Received: from EX19MTAUWC002.ant.amazon.com [10.0.7.35:34303]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.45.64:2525] with esmtp (Farcaster)
 id ddd70eb3-6448-4aee-bf33-ff8d888990ad; Thu, 21 Aug 2025 17:59:14 +0000 (UTC)
X-Farcaster-Flow-ID: ddd70eb3-6448-4aee-bf33-ff8d888990ad
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC002.ant.amazon.com (10.250.64.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 21 Aug 2025 17:59:13 +0000
Received: from dev-dsk-epetron-1c-1d4d9719.eu-west-1.amazon.com
 (10.253.109.105) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17; Thu, 21 Aug 2025
 17:59:11 +0000
From: Evangelos Petrongonas <epetron@amazon.de>
To: Ard Biesheuvel <ardb@kernel.org>, Mike Rapoport <rppt@kernel.org>
CC: Evangelos Petrongonas <epetron@amazon.de>, Alexander Graf
	<graf@amazon.com>, Changyuan Lyu <changyuanl@google.com>, Andrew Morton
	<akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
	<kexec@lists.infradead.org>, <linux-mm@kvack.org>,
	<linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<nh-open-source@amazon.com>
Subject: [PATCH v3 0/2] efi: Fix EFI boot with kexec handover (KHO)
Date: Thu, 21 Aug 2025 17:58:58 +0000
Message-ID: <cover.1755721529.git.epetron@amazon.de>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
X-Originating-IP: [10.253.109.105]
X-ClientProxiedBy: EX19D043UWC004.ant.amazon.com (10.13.139.206) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5A79C1A0010
X-Stat-Signature: 5n8eu35oyonyqjtewj8acysamfo3a8ko
X-Rspam-User: 
X-HE-Tag: 1755799157-821369
X-HE-Meta: U2FsdGVkX18QiAPfJh2C77afUkiDtIVW7aPaDi9n9bVoYQlMApgxlLqmNLGopBTcRhwbDCDMZxY6CqHe5OYLO0dJGjEA8R8ZmD6boPebqdvK2aUuP7QHA4N//RqcR3KnJEVAdqAQuKyq0vqL0d+pUJddvzLwlhac3gRlBxobSGpjt8ncLBoxWHQkFEy5DPZroj1UQsbE2rTqcZjyeAUaX0rB1fC0YGtUF8iWywDHQXi6wdZtWbf608fU8YKPWWal+NKHvr+0bnMuXrCwcTD1iux0O02YMLeVBsMWVZZMek1pcRqQZugxlTtTxmlgw96EqnmhISFwUOQpb2ksHrQM2jz464+lxAkcwuRXlTQM8CIxfTtQm9dSJDN1MDJvq0Ta7UbsMlQ2CWZPZixzfS2pSFeCmzNSB8EZoKolJQJop8qVVRztl+5wyVOnnzP/7Wy/6+yLonE78Tj4wIfWOklLT8osciUG9q/Ngurr286fQjh2+enhA5uZhW3Qzdg9TCc/31sLY2XzubXXKul3uF8QzLLEFCpIhsAOVE4yNZLHHgE9A/KieI75XMXLeAovM3pkrD58x+k1WwKVMftGeguAac+H/6tkTFEr8wqkL3usXTLMCwpWK4boUkMYV1eZR9EaJ1vNzGMUv7dxd0o9S+FnulPFSAlBXulxVkXSE5Gg75IEdqbllCzDrQikpqSHElvlNoV9miDYycFKYiyQBKk+R68HnwWpsbsdDeuPiwEIfH8WcGG2EwZP0Tu2u+UNACJZQg7zpZilhipLwBPFDRSaemkoqyAIBQ7dLXg3EzpTUNVtC5W2rPS3kYCwoHMMR1cGN2ytgtF8ZqVZd+h/NCRn+qmwODl4mFLBS9X/6gfqrqQXy8b66R7UurnD3mvDFePja+cqZnNxcO2if8Xpim4QePSpFANvAV6PaoKBh0xASRQSc3XSzG6HvYiiM/Ezo2gLbqbA4s0XONjfzOdKGbb
 u9zaJCk1
 jK2qtbowbF7HLcfY7hWReTPrTCfXTHTHQX9mDnYX0yWeDb/nN3D8HT2kHDn2EN+05H9LN551wBhaWTunQ9WRNsbloP3mHFD0LT9ljD9s37gOmXqagMbXb3VAX23Bvo7SP7uowu1a3VSQvAA0lG+w3VkLwq6gbxpaJ4t9c9yUrwRMAbmIsro9ptZ7wC1Rzglqc2dq7xfPEPbDno5YFBO4ZeWL4fecetIbx8FYNDJP/SBMs4aU71ISq2vxN6Z69CWvrOQa57Y3RJP9b/kgsNAFjt/ToesXoUlG6f1K2SM6BLXucm4vzwyR6JoAwV6BDSjmdT9pp2UZuwLDKrWsIoppZFAfxPgHh0GKB9L+gqEPd8iwEKVe7WfKCKnpX0kqN+YyLMXtt/tL/tMCWQpS6TL1ApFSfPyzWNTkMj03TwfLP8zPF3IO6kgZXLnojAabfqXIP75B+MMsKCAM/W21pAsbCP3kRK65fGFgjI7grE13kaTffn5CeBMDR/elom0fz48Xh/Zc5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch series fixes a kernel panic that occurs when booting with
both EFI and KHO (Kexec HandOver) enabled.

The issue arises because EFI's `reserve_regions()` clears all memory
regions with `memblock_remove(0, PHYS_ADDR_MAX)` before rebuilding them
from EFI data. This destroys KHO scratch regions that were set up early
during device tree scanning, causing a panic as the kernel has no valid
memory regions for early allocations.

The first patch introduces `is_kho_boot()` to allow early boot
components to reliably detect if the kernel was booted via KHO-enabled
kexec. The existing `kho_is_enabled()` only checks the command line and
doesn't verify if an actual KHO FDT was passed.

The second patch modifies EFI's `reserve_regions()` to selectively
remove only non-KHO memory regions when KHO is active, preserving the
critical scratch regions while still allowing EFI to rebuild its memory
map.

The patchset was developed/tested on arm64.

Main Changes in v3 (smaller changes can be found in individual patches):
    - Condition is_kho_boot only on the existence of a KHO FDT
    - Add Reviewed-by/Acked-by

Main Changes in v2:
    - Introduce is_kho_boot()
    - Replace manual loop with for_each_mem_region macro

Evangelos Petrongonas (2):
  kexec: introduce is_kho_boot()
  efi: Support booting with kexec handover (KHO)

 drivers/firmware/efi/efi-init.c | 29 +++++++++++++++++++++++++----
 include/linux/kexec_handover.h  |  6 ++++++
 kernel/kexec_handover.c         | 20 ++++++++++++++++++++
 3 files changed, 51 insertions(+), 4 deletions(-)

-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


