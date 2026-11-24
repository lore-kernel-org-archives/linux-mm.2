Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64670606A322
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.a=rsa-sha256 header.s=s201512 header.b=f0VgwLuR
Received: by kanga.kvack.org (Postfix)
	id 7A84A6B0621; Tue, 24 Nov 2026 03:06:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E6A6B0623; Tue, 24 Nov 2026 03:06:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66D896B0624; Tue, 24 Nov 2026 03:06:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2AEF26B0621
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:06:22 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9747C120AAD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:06:21 +0000 (UTC)
X-FDA: 85469280162.30.FB8EC00
Received: from out162-62-57-49.mail.qq.com (out162-62-57-49.mail.qq.com [162.62.57.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7654120005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:06:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=f0VgwLuR;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf13.hostedemail.com: domain of 1045704958@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=1045704958@qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795507578;
	b=dKEhybf4/jT+Bm4PE9Anfr15vdDaODeR1qK2Hki8+JA5Xkhwy7Af7sWon+B0J3Kh3NEBXD
	8TVzXPdx9Y0T+P/NmAfEjKedbnryYrhLHvJGhPCaraCZHgtJXxRQnMQgyk2iGz4+0xRnkh
	JyYCEK6kizoU5T9ePQmjONfWVm3YhzQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795507578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=KEf9xsv+Xy0b4bEOzIOgKFEp/lzfcwuiaMzbGAMUi40=;
	b=ow8MQTS7R3msmFoM5T54JkTXvGfxH9SCF9efZ9Lb3BI1sLCuGW7zIL4fMgde3QcmqoJQUp
	w52oZDNSAIt1701umsDrFuTWg4IbcSfGg8wMm5OGrT+MwChqjBcDMbhDccDp0UYYUtwHDB
	f8aAj9fqFa6sXmkB9IjUGTqh7Kn9NPw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=f0VgwLuR;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf13.hostedemail.com: domain of 1045704958@qq.com designates 162.62.57.49 as permitted sender) smtp.mailfrom=1045704958@qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1795507571; bh=KEf9xsv+Xy0b4bEOzIOgKFEp/lzfcwuiaMzbGAMUi40=;
	h=From:To:Cc:Subject:Date;
	b=f0VgwLuREjP91QgVwycyRmdY6t7wDq24Ayj3sqzvMzw6f8uW9kJUWpAb2LUT7LUMv
	 07mCdReM087o1kskTX58PTJuY92d6NRraTMEmQnV4tq7Tq/7Pw6U60TjYLqZIh1xHg
	 LvaNeVQDw2v5nJEcdOyfeSDtqyR3wO29s/g0rhQI=
Received: from DESKTOP-6LNKCJL.localdomain ([114.245.37.219])
	by newxmesmtplogicsvrsza73-0.qq.com (NewEsmtp) with SMTP
	id 17894CED; Tue, 24 Nov 2026 16:05:56 +0800
X-QQ-mid: xmsmtpt1795507556tkbp9b8x1
Message-ID: <tencent_9D774595101D7C0F5A46CBCE69817B8A6E06@qq.com>
X-QQ-XMAILINFO: NWEwCzsFJJ7Kuv0IbmjuX6r/80AqKeLaq8kNUZXU8vUuph4VpGYY2jaqG64iWi
	 CdJLf6lblftyp+H3puR2kfj88fF2ZwRDFm6o44H5tZeEx21hcagCnAHmlf8qY2DnioEuFwn/fy0n
	 1F0vl+kW/eP9eHMMdOR32E9R9m4DtdoKUhmhd2CMPOZzBo6grM3YGtfSpsoIpaz5ns6j5PrjoM5b
	 dskr/EgLBzSzzxck1OoAlmCNvD9ohcKC1Q43eqBr+zBt0uK3uIybEcRhXfcYzUFZF3fnJPQL8mgn
	 X9MY6GL6kymJV5/iqz+u4cazbRqTbjTpFUjqkN2l9+icI+wxLAAB6DWb4Usk1JnV4bmYnQ+zHLeZ
	 60xGORfpt/fjn4RKrUYeJhLN+SE8AxZ3DDJuo2qFd+5pwTn0tlN/7r+g8R9WAchv8lXeCcnK6EhV
	 oh3WWxLJMIk30RWFp2hVrfzep/TiBLCRgiAuzYwBPBGAYiyEzl8NPxUWWkQEQgm8+GuEho2iVFJB
	 V12/ElIBTQlwBILuEZMIxEgKsOp0Z/zv6vkxqFtw836iq+6oAbEY+NCAjMWGjuDAEjRFpJJyKbMC
	 iE0fIN8361bIQEzol30+tGdwe/z96AYmUT4ibQOZzcJSiaXJrPmQNC6or8iBbfcLlx9p7wgUDMZK
	 jwNwK0CinpPfhFrx7zzTnrCWxkWxLo0Q4agkT5fryyJZJnRc+htzlEeEU2gLezvarL6yDcQcWY2n
	 /rsA3FQyDQ1y29sbHMtEa76hr1o1fF+UtrZjgPoFmB2cJCxoI/PTfdUPCCtKifUB3whLu5mPaxED
	 HHDThL1+hr5Mp5o071jVZoYCZP3fey+PdP7n0o/JJZzvQp+Xnnhv8ESrd3YKrw8182ugIXyOMSiB
	 O9bXHHyrkOBdf0XIe9TEm9S5QD091MdYxCd2uy/n+ZLeEijXDVVDpj3PNPqiPWIUPyK49CvPW+AB
	 pwxjalAIPtFG0mTo4Wd0Q/Aj0xE9li40W7VTscIjX6brpAFlTw0dBXXqTDDwQboUjR6+roxaFoxO
	 h8BdUvdG0sg+I9fDZhPkUV3ufIiNDoREOqa18tMjQIpajXE9TX
X-QQ-XMRINFO: MSVp+SPm3vtSI1QTLgDHQqIV1w2oNKDqfg==
From: Jingyi Sun <1045704958@qq.com>
To: Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: Alexandre Ghiti <alex@ghiti.fr>,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	Jingyi Sun <1045704958@qq.com>,
	stable@vger.kernel.org
Subject: [PATCH] riscv: mm: make pud_leaf() only care about the leaf bits
Date: Tue, 24 Nov 2026 16:05:50 +0800
X-OQ-MSGID: <20261124080550.616-1-1045704958@qq.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: przqwxkzgyfkdoai34frcx5r613zo5hf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7654120005
X-Rspam-User:
X-HE-Tag: 1795507577-438249
X-HE-Meta: U2FsdGVkX1/P2F0uo50DMBYfQYDjZtaGQZbOaeJz8hjCLNR/WRb9iKB7+fEv75uxk9LrSzR3drh9HLsva01FrpkX/hyvS8S8N/Dpjp7mgI/p+Zto2PaPiD5bOiB/dGSgMkNZ9YNIugW7Kjzma7tyo6f2wc3b/IBLxq18XKA2UpDxwyrumAl4fzS4L3R8gNxN9s2Mtv9wIKosQXOdKcC92JwRWLwspZwqe9SEyxB/Tv/iG7G69JaS76V5i+ojs42iomp6xxBcyFJSwIdWr/vppegMOPPZsrlzM/pgLstiZTEuNVzEJ5oXbYbZKKOpTYwUva7X+dQXsuGhf8NrSmxJ1McyPDisQo6DP+osWg6M2hB43HAo7j4E/zXaaPGr0bQC2P7BU8tKAO2UMNBH2Yu2esSPtbqcIKMYVikkjuMag5IJnbZaVxvuCJ2SldqpGm7s5fZRJvTdzUk5ERX90CGfIajHLXmRPWw4zvTVmRwj9p+3ghNn7niXw4nHkVuLbLDYJPPWhXplPEkutuR4K/tLdeepFV1oNdwnZ6FqqD0FjDaK/2XyDucHNtq5uwnUgevxgR9KE2e43ySh2fmiha/JIxm1MxaufkyqycOQVyLLmxzYNiDzZ3tkr/8p8tZ1K7/AWuqBLPDTHUs6kKYHaXHYwo8bJuv2gghPWaMAP4nOvKFs4j57SjP5oiikylNRycHTcmvBr+PYEJle6rKt8lBdYu3K3ykgQA2+4XOFkpjJYGdsgAzIbWfa+gbazMRbdozglh2DJMb8qr+UQpHzY+tmEFMisVt5co+dugFZfRDTQH2a8TqWB0PpiFQI7a0a/rr6YHKHPKh4G1f75qcsCg5TudYuOFoHgr+kfM3rejw+qrqhn9q5l2B1meDA6E8M3Ptnx0xgvjv55vlBMnoHAtAReBwchzcywdqmoHXDm4Q9kJJMNS2OlGCNsHmJEUr53LpiL8FrYoFdkRnk90YLBgf
 jJqwmsYo
 +pR9aIJZy54MZ8eIrfzTZIOWaz+pZKKJ+OzRy9TMQ5ct+bCXxiVJznhsclfhmSqPTkEf1Fost5rrG8Usx0ckprYsXHnovwUxRsPGUTeSXrg3QoVgusi6Znkb2wehif+4BDQzhYHlqWsbr1nkzp7XSoR7JU4mZgF/uV2rLNwpTkK6b86GjCqGnYbO+PSaHWBqiyCUn0e5AqGjNmtOD2IYKcIjvVeeHhIdHSY/7P8tScjlTvJX/t2AICKHRdVyqF4Je2nvRsPL4gqK94M+wKPeLp7ezoK9o+88hlHasFe1APzfuXUqVTfM8hhal5wgu6sR6vOw4Ezn2sqH97YtV0selWFqu7PLzQ9XqZVqb2XzTnFC8uUV/v+js3yuwRfjhACwlmAJcyWx8A3erqrNk0MQvz98327A0SvG/ogGKrexezIluHrfZ74/6boEYTGyR8FI8Kz1hAUIJa2Xfd6t1q18ebAes97BKyA5aj07j1dfmMAFvarP6ahv2vJATb2EZIeA8fgVvPDW88vNI8/fMEsHuS/WQwb5dff1IjRYc+HDVHyBBkv8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit c3cc2a4a3a23 ("riscv: Add support for PUD THP"), riscv can
map huge PUDs, e.g. 1G pfnmaps of VFIO BARs. mprotect(PROT_NONE) on such
a mapping goes through change_huge_pud(), which writes back
pud_modify(pud, PAGE_NONE). PAGE_NONE does not have _PAGE_PRESENT, and
pud_leaf() requires pud_present(), so afterwards pud_leaf() and
pud_trans_huge() return false for an entry that still maps 1G.

Core mm then treats the leaf entry as a pointer to a PMD table:

- munmap(): zap_pud_range() skips zap_huge_pud(), and
  pud_none_or_clear_bad() reports "bad pud 00000001000001e2." and clears
  the entry.

- mprotect() back to PROT_READ|PROT_WRITE: change_pud_range() calls
  change_pmd_range(), which uses the physical address of the 1G mapping
  as a PMD table. For a BAR that address is not in the linear map, so
  the kernel takes a paging fault at 0xff60000380000000 (the linear map
  alias of the BAR) and oopses:

    epc : change_protection+0x498/0xf74
     ra : change_protection+0x2e4/0xf74
    [<ffffffff80263f4e>] change_protection+0x498/0xf74
    [<ffffffff80264c18>] mprotect_fixup+0x1ee/0x32c
    [<ffffffff80264f96>] __riscv_sys_mprotect+0x240/0x344

pmd_present() already treats _PAGE_PROT_NONE as present, so PMD-sized
mappings are fine. x86 had the same problem with PUDs and fixed it in
commit 144bb0aee33a ("mm/x86: make pud_leaf() only care about PSE bit"):
PROT_NONE entries must still be reported as leaves. Do the same for
riscv and only check _PAGE_LEAF in pud_leaf(). pud_present() is left
alone, so pud_access_permitted() and GUP-fast still reject PROT_NONE
PUDs.

Reproduced in QEMU (riscv64 virt, Sv57) on v7.3-rc2 and on mainline as
of 2026-11-19 (v7.4-rc3+), with an ivshmem-plain device (2G BAR) bound
to vfio-pci in no-IOMMU mode. The reproducer mmaps the first 1G of BAR2
at a 1G-aligned address and touches it; vfio-pci dynamic debug shows
vfio_pci_mmap_huge_fault() with order 18 returning VM_FAULT_NOPAGE.
Then:

- mprotect(PROT_NONE) + munmap(): "bad pud" in 3/3 runs, 0/3 with this
  patch;
- mprotect(PROT_NONE) + mprotect(PROT_READ|PROT_WRITE) + access: oops in
  3/3 runs, 0/3 with this patch (the data is read back and written
  normally);
- mprotect(PROT_READ) + munmap(): no "bad pud" (control).

x86_64 with the same reproducer shows neither problem.

The issue was found with a research static analyzer for
cross-architecture inconsistencies and confirmed with the QEMU
reproducer described above.

Fixes: c3cc2a4a3a23 ("riscv: Add support for PUD THP")
Cc: stable@vger.kernel.org
Signed-off-by: Jingyi Sun <1045704958@qq.com>
---
Notes:

- The tested mainline kernels (2026-11-19) had DEBUG_VM,
  DEBUG_VM_PGTABLE and PAGE_TABLE_CHECK(_ENFORCED) enabled. With this
  patch the debug_vm_pgtable self-test and page_table_check stay quiet.

- With this patch, the PROT_NONE -> PROT_READ|PROT_WRITE case reaches
  change_huge_pud() -> pudp_invalidate() on a PROT_NONE PUD, and
  VM_WARN_ON_ONCE(!pud_present(*pudp)) fires once:

    WARNING: arch/riscv/mm/pgtable.c:160 at pudp_invalidate+0x42/0x64

  x86_64 (same mainline, DEBUG_VM) shows the same warning with the same
  reproducer:

    WARNING: arch/x86/mm/pgtable.c:527 at pudp_invalidate+0xb6/0x100

  so this looks like a separate issue: pmdp_invalidate() has the same
  check, but pmd_present() is true for PROT_NONE on both architectures,
  while pud_present() is not. I left it alone here; I am not sure
  whether the check or pud_present() should change.

- The reproducer (a static /init for QEMU) is available on request.

 arch/riscv/include/asm/pgtable-64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable-64.h b/arch/riscv/include/asm/pgtable-64.h
index eb7708e35cf9..1f45ebce8a75 100644
--- a/arch/riscv/include/asm/pgtable-64.h
+++ b/arch/riscv/include/asm/pgtable-64.h
@@ -226,7 +226,7 @@ static inline int pud_bad(pud_t pud)
 #define pud_leaf	pud_leaf
 static inline bool pud_leaf(pud_t pud)
 {
-	return pud_present(pud) && (pud_val(pud) & _PAGE_LEAF);
+	return pud_val(pud) & _PAGE_LEAF;
 }
 
 static inline int pud_user(pud_t pud)

base-commit: 8d7fe9885c62fc9a95bf55d9db244d9672a8aadc
-- 
2.43.0


