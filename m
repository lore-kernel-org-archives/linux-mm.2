Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7822E60A3813
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Tf5YISm/
Received: by kanga.kvack.org (Postfix)
	id 9B7CC6B05BA; Mon,  2 Nov 2026 06:21:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9192A6B05BB; Mon,  2 Nov 2026 06:21:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8087D6B05BC; Mon,  2 Nov 2026 06:21:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB6C6B05BA
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:21:58 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E9F951A0C5D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:21:57 +0000 (UTC)
X-FDA: 85389939474.22.8E0BD0B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id E9BE78000C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:21:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Tf5YISm/";
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793618516;
	b=SzcOdB4zibHF7Tc5EDfnSpNIfPSwHUmliysD5corhBVfeTcVpwYJF4vtlUYPBE50OFlQg0
	Jxul/QEpKUsnztnHhJh7opi3BgDAYEgoCOmWZKjeWsktK0QUIGgmb6/HiKtU/Zsnf4j5ev
	ap2kArvFKwFT+x4Pn4wwP3bbEs7AZgc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Tf5YISm/";
	spf=pass (imf30.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793618516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJr4pyTBUPDwtFxqouKNlkLHudO0sOE1ps0QHQE9jbo=;
	b=7h/KF45pqGTIcfDZzK2OcCUzJuCEhYSbf+PYL11VtIUfizWswVtNfWGR9P03xAmT9XhGnx
	UvR5fMu5L+PzfD+yPrLh9viwF5XH01kaJ201Kz9J6qhsGEZuTVaYnXdizPmEC/C4HNERhJ
	gvyNX+DRwRntVSWRuEieDJ26DeuweFI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E13402A68;
	Mon,  2 Nov 2026 03:21:51 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 000EB3F632;
	Mon,  2 Nov 2026 03:21:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793618515; bh=pfH49/wekZWH0tUlmAGPYfXLPMYhwWIki53rOu3JrVc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Tf5YISm/NbZvwkPEnUHnWMU4HZk+CDcrkirL9z+8KS5qYFwMCSdPLDcxtwNkqYbla
	 mFdwJmtXdDZOweXSP/PDkgFSpVfkODm5NlcHFi+CoNzkIVmyQp1290rt9pBK2JiC9o
	 kYPxrWkSuMDqiTHtpyDsilHlX/0l2sFdrwt6OtRE=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:21:16 +0000
Subject: [PATCH RESEND v2 03/21] ARM: mm: remove custom pgdp_get()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-dummy_ptxp3-v2-3-78840b2ec73c@arm.com>
References: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
In-Reply-To: <20261102-dummy_ptxp3-v2-0-78840b2ec73c@arm.com>
To: Russell King <linux@armlinux.org.uk>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Tianrui Zhao <zhaotianrui@loongson.cn>, 
 Bibo Mao <maobibo@loongson.cn>, Anup Patel <anup@brainfault.org>, 
 Atish Patra <atish.patra@linux.dev>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonas Bonn <jonas@southpole.se>, 
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>, 
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org, 
 linux-openrisc@vger.kernel.org
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=794; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=yi3BzhiHjasTHpKXh1MmDEBzfM1jM8lRPSh1W8s2lTo=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HIwc/GAt+z5/OOvI3XR8a7QDzLX+Kmmbr+jA
 ZF852tvsq2JAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauhyMAAKCRBt1cPRWsUx
 Myg5C/wNk/i75t104WkQdgspkcwkRtCjKwHmV8D+fUK6nYb7ji1MHoEsVIe1sHMK0ADIk7OhxRS
 S3rpo2/d6+5qv/LmYF55JqittempBiiZZ+UFylH0lRHBfdXkOQNDbYCPopeHy3uEZbCUONl2ATe
 9mMlptrkZULQOx0oikCg1Pz3pLbent5TKJ9XwhSE7M7utu5izrQrquojB54trKaQfNCZQ8qS3GG
 tv3+PZd7ghv+bTvhDvi9AvjoCnZREX6rWFwVv/mxSR3zoOuloBrW+44ASZJpqJAWzwvREAM4N//
 UAbJCBV2ykb6MBSmZEEKQKIEDhhQRAY489gVgAMjOa/Un448WLURsjNETK4mMK064AuH8uQ5gyT
 krvRSxNzJeqsDewqn8e638zfsd7jtGSAsu6S5FT1p3KZGa6B6217eOXhOvTHJkAkrjOCNk/J/RB
 AXmrtPiCPS1sZsFy11YkhRK35X9QswfJPdmpKES7oBqQdrPfh4pA3GXP9KNqQLUay7cv8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Queue-Id: E9BE78000C
X-Stat-Signature: kf9fx8jhtrn4gzkqgx9qj9rdsqrni3dr
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793618515-912867
X-HE-Meta: U2FsdGVkX1+9CVR7EnoPpv+D7wH8Ma0FH03hLSmOXk0c1u4nVHHT1RM2haci+0Ndw57JdvTErr0brPv/JmijIeOmcaGBn47JBD1Pc5sen7NzSVn7T9Vcapeq5Gnqct5Taq4XzvFoYVkhwMbtBbh6ZXdhKiOUGE5Evyxts9Ufxwip/nQ9QwlqWGOz3kkisuVXdOF5cQnzY1kSif7p3+8S3RPxCoFLff4S3iamDsg+GipUFRS4dlft+FMvrcCX2hPCqOk3Blix4kSJ+9X8F7B0wGFf61KXV3Wn251CYahJ4DVBLhfKilgzmNCEPH2fipKZhpZm78fljTk3h+22OKpTd+FFnCsMUfvvgA7+BywhT70MsAlsnLiWUluWzUKQPohTL99f54+GteK/idelTImbwgvFgmUcWbadrKpADLBTN0oqwVpPCpRz1WxrZJ63rGRuXipGYPSO3bkvS3fadJB8jdtrmMqR7DHOWEjWDHC2ZSogKHMdygJTxfEt6WrQzb0baR8K9u4ip37B/gNUAGoCNFUFALQHgFyi451vwMOERMadvIoLVwR0D4oZ4lqoEazX2eY7fuskGbCIQyTd/psMPQd2bzZwhH/mkE4VVej0q1JEYSgqDm8lh1CEllVj3MbXYEf+v4c5s/SfHUqtTBa9srF3uC2S07PoALJtVULLACmx9t/43L+IpdpRbYYXXhRtgvbX6Pt659X2j3mIOKvS+FoVnSTZhMc0lVK58Ueei8yYWQGHA4m9QI3nbQPy4Ip/qCWzQjLJFqQ5jUJq78DmMbPY1tls937K1hLUO6Ix8Xf3XmBr3/lb60cDu4aHDKqD6cOMCCjYvk+DBvqr45rRPH6+k1lS6GVwZFTGfNKlYdIoPgnswCRjgJa4L0rlNzUCm3uR9entvKpiIGe4EC/Zq1JW8o54yhJd7SJYqas4cqYAtIoI3xjvs3Un4MUWBhDQFUGKCUN4QJa6XLsmFl3
 VjC1Rrp3
 jOQOvDH/vCK/oooUrxiXegjo3NinMQ2KXS7y7dT1ZRCP0n50GmA1zgOfYFNOgZQoYbExMdL+EUAeHoKr445+7ramQZAsQGQAtO01Z6fluAzcBydUpafjdvHCQTAD2IGACy7JIYF27rf6mVsZmUapnuVCDPjhGANh/nVMFxYN/7b9jAKsb6yXTDKHtyuKR4WvmhbTruLF4xQooqsCpemUcM7TG+NM03WfAS7crhUSX7jbD0JVvLHk6dC3sDwgmGEE0mcQJayjwZuoS4oU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "David Hildenbrand (Arm)" <david@kernel.org>

Now that pgd_t is no longer an array and rely on the common
code pgdp_get(), which is a static inline function that returns pgd_t.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/arm/include/asm/pgtable.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
index 8dd17d20faa33..ff3868acea945 100644
--- a/arch/arm/include/asm/pgtable.h
+++ b/arch/arm/include/asm/pgtable.h
@@ -134,8 +134,6 @@ extern pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 
 extern pgd_t swapper_pg_dir[PTRS_PER_PGD];
 
-#define pgdp_get(pgpd)		READ_ONCE(*pgdp)
-
 #define pud_page(pud)		pmd_page(__pmd(pud_val(pud)))
 #define pud_write(pud)		pmd_write(__pmd(pud_val(pud)))
 

-- 
2.43.0


