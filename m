Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B20CA606A338
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 07:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=wpQ8iFKC
Received: by kanga.kvack.org (Postfix)
	id 987406B05BF; Fri,  6 Nov 2026 02:15:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95F466B05C1; Fri,  6 Nov 2026 02:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EEDE6B05C0; Fri,  6 Nov 2026 02:15:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 49B796B05BD
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 02:15:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5419B40D31
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:15:11 +0000 (UTC)
X-FDA: 85403832822.23.BB248F6
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf14.hostedemail.com (Postfix) with ESMTP id B7DAC100004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 07:15:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wpQ8iFKC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793949309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJG+oWzeBiYTOj3RU2JHcsvV/qqXp37vXx+hYTPpTbg=;
	b=aQ1Z4ESZSUW/NcEEOJyfvPA59mNCmkVZT6780sd2p11fLiEchr690VTge+m3lpF4vglPpv
	7SZS8leqPeMRA2rsTk7Hb8t6FLBpnhSpLVX5BY26kgnbluZss84OefW8Mo2ZpTat+Ncl+9
	cYc9iy7lmfXsFZPGw4pjVPKSfIJwpao=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=wpQ8iFKC;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf14.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793949309;
	b=NdFgy9OjryZV63yvRzp5OYHBpz3zV4O+ua8JeyrfxQD4HwNwHmfPNmpOoHlutZgLRwUZ1/
	UukV16oqF4OGQDpvzIUdN+ewtdA0Ia1Rg0/BDUuwEAqKp+tPTR+NhYMycDePUXxvpNYkyh
	jimVpmHX8fo/LtmLzu6+xFyMDfNjO5E=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793949306; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=jJG+oWzeBiYTOj3RU2JHcsvV/qqXp37vXx+hYTPpTbg=;
	b=wpQ8iFKCpBrJ29/nGpdag3wuzNfj/MYs+5ylVtplEJ4y0oieBs+EHSlJjOAaxHmtYp4nPfQURUMLJJAjvzn+MGkNYKeI468AQSo48yBpTRQScg1rLYIufFnCLD6c/ZXF/pfVVShMdE7dbgoI5TPPlxemCjMuyTDuDHHLxwBhuu0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XEAtjN9_1793949304;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XEAtjN9_1793949304 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Nov 2026 15:15:05 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	alex@ghiti.fr,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	graf@amazon.com,
	shuah@kernel.org
Cc: guoren@kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [PATCH v3 2/4] riscv: Add support for kexec handover (KHO)
Date: Fri,  6 Nov 2026 15:14:57 +0800
Message-ID: <20261106071459.2003-3-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261106071459.2003-1-cp0613@linux.alibaba.com>
References: <20261106071459.2003-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B7DAC100004
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: utbdpme5cqt5oywzu3j6gw6h955uc1nt
X-HE-Tag: 1793949308-173707
X-HE-Meta: U2FsdGVkX18e79zUU09cwYgJQ1BWVBUAKJJ9LIzbCfvgJOjQIsDcOc2yiXS5XyhYMxZk6LHmkMXWAV4ZMyz3HStQ7LSFpzQqKE9clmeBawIZs8Ik59D7miQFhxI1UDHOpF2E6T6KTx5HWAfXasmlGYtqj0RqgSJXqBPPoUgPEUxdDIdEeJpWe+aiSlTX3bquF4W03PBD4XjvF5L5VcYj3pmzG2UhpvD95vzWtWVZMmnzQ1baTzyo65FZBsty64cH9vxyBBbjC4HkNnMeyI/Oln/1UTPQ9sO/YsP5AbbALIC+xOFzgLychEofmPSf1zv1Crkhr2XwsMOgntdGOcMIquxuhTUKv4gKVKK1nyXQ3Z39pDsQphG+gkBsUi5Xk/LceqJGKMdtoGr6GBp5cYC4tlTBNXXpgJ4GBQq8T0yZkGtcDhUqlsAdFpd1Lv1E+peQ5ubbsIAEns+yk9+YNwuoAygZptiv3014Lt4aQcUjOo0bedapADTGfXSx03ewsB2dHAUQaDQzHJ97M3HDsEIduLBT71wmlUqbVAlH4dNq1m3A2XG8WGXxEon7vwl0GECBesd0t6wPtRRYRPCQaDv+mutWvu3v6R/UMPZgbeRhTMAbogF+RoSUZOogK2NPvrT3y2GO9KoocWQfNcQd/4hvqnpdHJc7NNV7N2vUa5s9YmqLnZPFGUl2Cd0yvEMkkRgt89h7pmHqpqHq3d2+dCo3Etn4H63mPwA0IVbZTSUos3zJ93u1zRlNr8KM4iv7h0XmEXPHLX4KMEN6oJoNYVBR9RRCqOxc3R/BRu+CjjgufdLhLq3PMp6JuPS6bpGYr5UJfheBaan6G8yNbLFFX0PkThLMWcwYOGZpP0R/cJSDP8owe3LW12fktzPykrxEcVj17b3FbFj37SRz9zrlvmW4M6w4x0WT2RoAY+2Nkwj7dXFejdAHMSD4NkE5JCKAUjz01G9LJMdnt5L/7RzCL+A
 Zw5CvbFh
 55jXgmkD08o2sMN1l0gmi5DB2FZz2OKrvGDywmAxTp5+cgywkCZQkO7R1J1W7b2hyxuWRmezg3MVAUKYCdXJkw9Bb/sBorq04UebvPpWuSfDErCOc52nKwFVzgi5wDqknergldS/LBLd4q/YsVb1KnKGE2sehcWCZXr9RZGmkqcCKTXncoqL/A+/Q7gRjDyEZ1MkYNin5/W2RfynyONQs2FBIb8j59fI7JFsvRtGxik1ZnOE/KB5ErVdaIZ21RlUrQu0U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The generic handover paths are already in place on RISC-V: the outgoing
kernel publishes the handover FDT and the bootmem list in /chosen of the
DTB built by of_kexec_alloc_and_setup_fdt(), and the incoming kernel
picks both up while scanning that node. Only the architecture symbol is
missing.

Set it to 64BIT && MMU: ARCH_SUPPORTS_KEXEC_FILE is already 64BIT only,
and KEXEC_HANDOVER selects CMA, which depends on MMU.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
---
 arch/riscv/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index bde1f1885038..bffef6b903e1 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -1125,6 +1125,9 @@ config ARCH_SELECTS_KEXEC_FILE
 config ARCH_SUPPORTS_KEXEC_PURGATORY
 	def_bool ARCH_SUPPORTS_KEXEC_FILE
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool 64BIT && MMU
+
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
-- 
2.50.1


