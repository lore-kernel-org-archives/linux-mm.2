Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C16B1F4BB6C
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:58:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158FC6B0088; Tue, 24 Feb 2026 12:58:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 130A96B0089; Tue, 24 Feb 2026 12:58:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0300A6B008A; Tue, 24 Feb 2026 12:58:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E684D6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:58:08 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB5D51C1FE
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:08 +0000 (UTC)
X-FDA: 84480109056.27.439F14B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 32E6480003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771955887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=hkM+tLt+lg1PX5UAHL5V6yrO8Ui0OtMZiaPAp5Jak2w=;
	b=gDpKJXhUOLlcS+iPnhKjl+MNecGTvVSN7x7KaTmEOEMcJPvh7lD5IdP6TaJhJk3FOC6Mfk
	rJMd05gdFiO98b1p0uMvOXoUf+iTeMy0jYMCoZVDKZdYpjWDg4izjuWI73HilIkXaTZQq6
	hADaphYD/Te9jaBnXlmDGW/H7P5STkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771955887; a=rsa-sha256;
	cv=none;
	b=ZPT8kytq2cwvtONAmgnv6dYWrCz8JjN5KBiRd23/kBSEo7ysWrSQzx4vfBd6QYddY/xK+L
	HW7z7X9uWfXQSWL5dsnQBwmgcKLi64G9citm6olF5tVPQh+Byy7/F1ZdWEwGeoosiw53xm
	+DCwHHCvAGQIyB3tXoZXy+SZDlTyx8Q=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64C436011F;
	Tue, 24 Feb 2026 17:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B645BC19422;
	Tue, 24 Feb 2026 17:58:02 +0000 (UTC)
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
Subject: [PATCH 0/5] mm: arch/shstk: Common shadow stack mapping helper and VM_NOHUGEPAGE
Date: Tue, 24 Feb 2026 17:57:52 +0000
Message-ID: <20260224175800.2500729-1-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 6z9o8uziammit664xseocb44zxyrp9f5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 32E6480003
X-HE-Tag: 1771955886-119300
X-HE-Meta: U2FsdGVkX18W04bwcX2tVKaw6hGbiQPgyar8tNBYLy0jXCh0pVFqSlkSmvAMyY7Qn3lcfkpmsgvBa0/OCILxP9GHHchdeEfNJdvxHkhenv+vrIpCRanhq/flubXxRVhj6kjx7NSnpJE2KIAOvrTVgrHT63d3AOZzFuD0hz+GuAJoRxNYFOFMnvQNVe0MdDl+JiMQ1YLEcumM2PYv/DSMmOaKc8wTkj0uu65v1S+0rJZAj8MgTFbclMYC+559IZf+XwWOItbPhEb5qv/UbveSUjukVg6kZZknGHUAS7CwHP4Y1nlJ/5NL6APqlFOmYNQzQi4YzNUCAWnmAKHhUT+64BeC/1OrvUMs3Sax+AFsY6/3LSUxghvzNZiJC6+Pi931rtzFP+KtaxDhIBjo/e0mTgRf1mOKq7m+uZV/4a/cw8Fl/DlxIFsMkYH3eppj0bIEo5ewczMlUJm4oPMgDRTKBq1erPfsBKYdB/aQpoRF0pyuJTAC6llTs/hSeqT5CuVIfmRNh4PqiAeQVwhDQCWHXMLBPZFtas5hPsM3H2FQe9WAtm8oyohtcNz8Q/CmHZFsOruG1tUuc5ey1aIzaA/Ym78bFAWFQxtApKWCL34UvcyukJpTAI3MZpKyzk2Pu9MMlaoqcYMjqlhFkZwLYejkKysS6hifS7BZouqWo5kzOmPKTfkaP/IbfIZ28MzXLlvFkiGgXRyfhpIOn752EgpAjxyzhl5j9fN/K6WgNuBRHxFbqXIbHkvRU/1k63HACoBwT4fUUyMAwVrpUFpn8MD98ZU7kbFLt8nmll3Gbio7snQA55IYvTdwgzqrBSMjFzEtb6U4RXDI1xYuJlv0WfhbyyzovMeq6jIcNNEghyL9SR9PuvGf7USAd5ItjisyVTMiD5rGBC9zeWCMyJCyN03ePttz1Fi/ZilncvyUc6W0A7f7gSgRNucMLdgKmbKjZxZZmjgnkWHrvuqWZ1OGLx5
 YECyXZSY
 jKaANFMUrrQmjSHtw9HGt03pC8QHnd/SZEboFDRPmm99zAQMHxAWsp3o6x2nnLqSCkR6KTs6zEfgYSgR0TTcvK9zGzasnyh+0Bo9MLPBZrC9LF+LvNWTUUTxbQfcgKjlhom4VylZ0fS4GsUElKphUs9VXPnxQw4Wv1R2d+Y42nDq513T1LB+Cc62woFGLOj6Ku+INdN64XAyRa2C+m6tSzt/V0IVWfbzsqYAVIEJBC/0Fq2E876wstANMkZEL+ZIFFmjdxUHzvrW6mwEC5aNvFuYgdC1ANNMSldzsAgdNrM9vjqA6NGNuG0in6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

arm64, riscv and x86 all implement shadow stack support and use a
similar pattern for mapping the user shadow stack (originally cloned
from x86). Extract this common pattern into a shared helper -
vm_mmap_shadow_stack().

Patch 1 introduces vm_mmap_shadow_stack() in mm/util.c, which wraps
do_mmap() with the flags required for a VM_SHADOW_STACK mapping. The
helper uses PROT_READ|PROT_WRITE prot bits instead of the earlier x86
approach of PROT_READ with an explicit VM_WRITE vm_flag. Functionally
there is no difference. I looked up the history of this flag on the
lists but it wasn't conclusive. My guess is that the original aim was to
mark the vma not writable but that would confuse the kernel, so it ended
up with the VM_WRITE flag instead.

Patches 2-4 update arm64, riscv and x86 respectively to use the new
helper, removing the duplicated mmap logic.

Patch 5 forces VM_NOHUGEPAGE when allocating the shadow stack via the
new helper, mirroring what commit c4608d1bf7c6 ("mm: mmap: map MAP_STACK
to VM_NOHUGEPAGE") did for normal stacks. It will save some memory,
especially when the ulimit -s is high.

Boot-tested on x86, fully tested on arm64. I do not have a compiler
version that supports the -march=rv64ima_zicfiss_zicfilp option for
riscv, so any help with testing is welcome.

Thanks.

Catalin Marinas (5):
  mm: Introduce vm_mmap_shadow_stack() as a helper for VM_SHADOW_STACK
    mappings
  arm64: gcs: Use the new common vm_mmap_shadow_stack() helper
  riscv: shstk: Use the new common vm_mmap_shadow_stack() helper
  x86: shstk: Use the new common vm_mmap_shadow_stack() helper
  mm: Do not map the shadow stack as THP

 arch/arm64/mm/gcs.c         | 14 +-------------
 arch/riscv/kernel/usercfi.c | 12 +-----------
 arch/x86/kernel/shstk.c     | 12 ++----------
 include/linux/mm.h          |  4 ++++
 mm/util.c                   | 29 +++++++++++++++++++++++++++++
 5 files changed, 37 insertions(+), 34 deletions(-)


