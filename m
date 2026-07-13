Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 345D8C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAEAE6B00A1; Mon, 13 Jul 2026 12:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E056B00A3; Mon, 13 Jul 2026 12:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925D16B00A4; Mon, 13 Jul 2026 12:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 706D66B00A1
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:30:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 25C121C8054
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:01:33 +0000 (UTC)
X-FDA: 84983916066.18.AED7D32
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4A95914000B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:01:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IVRIV9T1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783951291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ipy29CliDU7HGj7jqsL8CnwtSYVvLT/d515x7ptJpMg=;
	b=Nbgxj0IHfkp7Cj7va+Tqfy6ixUhmSwzg/NO2okvKmpsWoh05uuBxf1T+tEyvz3oeEm7RbD
	lOatlPPfoa/UEvXttnBbZxCU5z9M1229YBIUBpPLoxORHjIR2N0zxE4hwZBPnBfNY2iouS
	WZrSiuklU0ZxuWLtpOfs8JNCzW0Rf4o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=IVRIV9T1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783951291;
	b=rpb0sS5N+Q+NEmgl9yYBCL0eKifDAYKXXvcCWRSWh+r36u4EJ9rYL5rcx1/+x0EoUo0Olh
	lc7s1vuxSzPa/voy8tJIrwrT1KLQxfTJFKokOPpmMQ8cNoGeREoGhHnTuJnQsXoDFCDILH
	/DwcauU1Mw1EuuHD+TLIYNB7rvTqWlA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1A01A2050;
	Mon, 13 Jul 2026 07:01:26 -0700 (PDT)
Received: from e129823.cambridge.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 25E193F7B4;
	Mon, 13 Jul 2026 07:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783951290; bh=rrBwQUNghxkMeytXEUNPpto8wZMFntDlW0SzsHEzoAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVRIV9T1flpA0gOrme1V1eRRplwrh4TOVZQ26715JQXP4QS1CmEmFLuEQckZtZvv4
	 4p+gq0ht2Chb+NH1sjxzNiEzIZeyEPeVbwJ1KM74ZeocLv5XHo0v7Uh1Lze0qxAo+P
	 JXkmUcVeya83Vz4L/uprN4mXjJ5dFsFizk8SHMNA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-csky@vger.kernel.org,
	linux-m68k@lists.linux-m68k.org,
	linux-openrisc@vger.kernel.org
Cc: david@kernel.org,
	linux@armlinux.org.uk,
	akpm@linux-foundation.org,
	ankur.a.arora@oracle.com,
	rppt@kernel.org,
	linmag7@gmail.com,
	chleroy@kernel.org,
	klarasmodin@gmail.com,
	chenhuacai@kernel.org,
	kernel@xen0n.name,
	kas@kernel.org,
	zhangtianyang@loongson.cn,
	wangyuli@aosc.io,
	tsbogend@alpha.franken.de,
	ljs@kernel.org,
	jgg@ziepe.ca,
	catalin.marinas@arm.com,
	will@kernel.org,
	arnd@arndb.de,
	ryan.roberts@arm.com,
	pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com,
	baolin.wang@linux.alibaba.com,
	tj@kernel.org,
	kevin.brodsky@arm.com,
	anup@brainfault.org,
	atish.patra@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	ryabinin.a.a@gmail.com,
	glider@google.com,
	andreyknvl@gmail.com,
	dvyukov@google.com,
	vincenzo.frascino@arm.com,
	anshuman.khandual@arm.com,
	yang@os.amperecomputing.com,
	chaitanyas.prakash@arm.com,
	ardb@kernel.org,
	guoren@kernel.org,
	yang.li85200@gmail.com,
	viro@zeniv.linux.org.uk,
	dinguyen@kernel.org,
	schuster.simon@siemens-energy.com,
	wangruikang@iscas.ac.cn,
	junhui.liu@pigmoral.tech,
	muchun.song@linux.dev,
	vishal.moola@gmail.com,
	namcao@linutronix.de,
	pavel@kernel.org,
	djbw@kernel.org,
	yu-cheng.yu@intel.com,
	baolu.lu@linux.intel.com,
	Jonathan.Cameron@huawei.com,
	coxu@redhat.com,
	andreas@gaisler.com,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	geert@linux-m68k.org,
	shorne@gmail.com,
	jonas@southpole.se,
	stefan.kristiansson@saunalahti.fi,
	Yeoreum Yun <yeoreum.yun@arm.com>
Subject: [RFC PATCH 24/34] x86: mm: call try_to_free_pmd_page() when CONFIG_PGTABLE_LEVELS > 2
Date: Mon, 13 Jul 2026 14:56:03 +0100
Message-ID: <20260713135614.1618183-25-yeoreum.yun@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713135614.1618183-1-yeoreum.yun@arm.com>
References: <20260713135614.1618183-1-yeoreum.yun@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4A95914000B
X-Stat-Signature: 5m98eqpzkxgiwigfaqg68oqzptw34rud
X-Rspam-User: 
X-HE-Tag: 1783951291-297730
X-HE-Meta: U2FsdGVkX1/dYsbQmlRBnc1biHD8zJ68lkdOoEsM+anBvJ4VPFjEPVJqmv1AXWzrCxK0H2OuOtEyJ/u2EQvJccT6C5t6KF973dUs6Xcr6J8HvBYHRnLVB3ylx+npuWE9H8i453FmDL0YmFblO3UJ9zTM5nPsjHVu/kLH/+j3z4CwBDQhcHJjH42az4UjmqzkgZLy7Ey3VuqVRFa+1TAmjUwIlsV0Q0KDk+YAF4RQcNPfe6EAUNZfINTieZGEZ5GF1xGlokP0YrfEu9P32RRwMRASUrxBm/FaU1kRIwSsLQGzOjHjjtbV3Ns74WC22oAgslLFr8vKMyq+upDHXaESwNMu3+hcJcVqmya6aEteEdN30NSX3xyLLJ54xQKii5kj+INxYOBGlX4nNPyOsbSr4WqWWI4dht8SNjV/bo352mesEJ1zuj5yD3AS4dN8g9AVxOcek+D9TC6o6BQE36s76SOi06yUq6/YGTOr61pptgMZwN852Uzx5SBCqs6E2g2AKAAAq8o12iT+T5f+rhqXH8Y3PgX/O+bc4t5iqXcUYRV40A1GTzbFeql0xeDMIBtY1vxLmK0mcOQSUbfNGqFe/m+IKHZpc06BEB/caPo9P8ruySsq8+sHMVHxvyc1ymI9SfeoNgOaEmbetfDtl+ZkVsrThN8jUWHrFg0/IcpodMGZo92YDX/Lqaz1xlCUtLm2dwHCy+P2ygvHkRSILX5UX8K3yJu4rE7UPHpV+8Y2FjbeamXzUh2oPDn5qkQFoKLntATNCSuYr+gjPHWr2oS61OgqvSlq9TBIZng6hJd7OhkvJFTYvmokyiFQxYodruEiF3XmNGPT4I9ZBbbeTLfwtySx9Ls1zC3EU3iQz/k3JoiQMoQUmlo5yBlbkfQeEq9qwvrKIrZ8zPauqRyMT/owUiTPmmWkOPcqo8juV/4cVMNS9Drx1Trv6eRzlyDjaxOprdXYeGohS/1bRPwGyqJ
 sqf+8UMV
 PhnZc5jUeCPWhc3qI0sNgrAS8g4LtwNiWo8NEONupHMjsPSyKsnlVfe0o0LqYCw74u5LdDoiF0w1HmfluBMF39b0qOSlWu2FJ2N976/DASNrM/vytocFp45nubXCuuYvlbU+AiXcgjaGWB0PHc8VebYMA5A0Y/UnGvRAG0fcJNY0ABUpfNf79WpPVS/FWyEyUQqivHyqxTTRkK5x7zmK03nm+FUEeFOcMBXr9WVHNJEqc6C+jBczLzEwmtfqc/JwSKmkpWvUdaNHhOaQ5pQh3XdV9aL3ECdOpwNcRbgv9U6wRhmwN7QCcUlt3v+EjxDl//Fd4CxLazfOh8WkMxK4HuW4FsoTiD9hKzGHqYROXDiFTsig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We want to rework how pgd_page_vaddr() behaves for generic compile-time
folded page tables by disallowing its use and triggering a compile-time
error when it is used improperly, ensuring that the actual
first-level pXd_pgtable() function is used instead.

The try_to_free_pmd_page() wouldn't need to call when
CONFIG_PGTABLE_LEVELS=2. therefore call it when CONFIG_PGTABLE_LEVELS > 2.

There should be no functional change.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 arch/x86/mm/pat/set_memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index cffb1cef869cc..2137174b733ae 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1452,7 +1452,7 @@ static bool unmap_pte_range(pmd_t *pmd, unsigned long start, unsigned long end)
 static void __unmap_pmd_range(pud_t *pud, pmd_t *pmd,
 			      unsigned long start, unsigned long end)
 {
-	if (unmap_pte_range(pmd, start, end))
+	if (unmap_pte_range(pmd, start, end) && CONFIG_PGTABLE_LEVELS > 2)
 		if (try_to_free_pmd_page(pud_pgtable(*pud)))
 			pud_clear(pud);
 }
@@ -1496,7 +1496,7 @@ static void unmap_pmd_range(pud_t *pud, unsigned long start, unsigned long end)
 	/*
 	 * Try again to free the PMD page if haven't succeeded above.
 	 */
-	if (!pud_none(*pud))
+	if (!pud_none(*pud) && CONFIG_PGTABLE_LEVELS > 2)
 		if (try_to_free_pmd_page(pud_pgtable(*pud)))
 			pud_clear(pud);
 }
-- 
LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}


