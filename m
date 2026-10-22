Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E3F606A323
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 01:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=VHJ9g2vI
Received: by kanga.kvack.org (Postfix)
	id 680366B027B; Wed, 21 Oct 2026 21:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657E16B081D; Wed, 21 Oct 2026 21:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520986B081E; Wed, 21 Oct 2026 21:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 174C76B027B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 21:57:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EAC341C4003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:44 +0000 (UTC)
X-FDA: 85348600848.21.F740705
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf10.hostedemail.com (Postfix) with ESMTP id 23752C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:57:42 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VHJ9g2vI;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792634263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1YfAOVlMmaFO1m8awbcQvUypoDPfeD8mK+PEX0oRAyM=;
	b=gqLdVuCKjnCmjv4UMg3G/WNlFN5FK+aQVDVQWGJzkOKk07Ne+hJBo9wdtEl+lF4BfeWB5G
	P1D6txHwHp/EMOhkFPISnvOm1hjUXAuTgHmYKMajei+WbScOq/KUIim8nkf6vuyH3ZmVSy
	ZszN6IgD6My9o1VyN78BqT07yg0pnZ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792634263;
	b=dPCUnvCOknqKNncWi6fI7k8mbn4a71WN/j7efPF2a1fpAsgmVhC0l3bYla9Y0w2u+YLBQt
	HqBQ/FJUYJcstJMk/zwHS6qdWJsAyhvkcFGwGeyKxkvorLj3Z4/BuNsVvYJOC8LU2+1VKj
	hf2ydx4vHNPHISdlUvGPNHz+ADmWxRg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VHJ9g2vI;
	spf=pass (imf10.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2e940d5d2beso5285165ad.0
        for <linux-mm@kvack.org>; Wed, 21 Oct 2026 18:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792634262; x=1793239062; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1YfAOVlMmaFO1m8awbcQvUypoDPfeD8mK+PEX0oRAyM=;
        b=VHJ9g2vIzt4fjWkGWo1/Wm2MxUwD1YSUPi7PhR8U2Q0kPwulJFvdagqNxG2aXospyu
         UjFtb1c8C3Qhu1zQJNh+IujWos0sa3Fnv+kCo1otEyxl9rtySVWnWbZUGC7SLoYu4NFS
         E5JLCSCAnaPp1Lbx2LQgQTdPhMNpq4syCiJo2hlEzj1oyQ0hf3IbNQ6wMHuPJVJtaaZL
         bkwPPQQu4Q5UTTDz2QKKi1b2P17SeHy0OXu628JMpLpoU3mmfn5fq2TZWnAEQDdDbl0z
         5gG9YyFmLjXuboQtxLo2HqmPTJlGIM0HqVf/lnFIZO/wsE+glCtK62SPtIe+ON+CLc1z
         pdmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792634262; x=1793239062;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1YfAOVlMmaFO1m8awbcQvUypoDPfeD8mK+PEX0oRAyM=;
        b=qOjSxEgzuOl+BXDl1xP+Cs9eE1FD1MKw6y/H16N4UsWZo4nfvcpbhzxO/4fYzuD1Eh
         fL5MUiY8hX35+uFXSIJaEAtCrmPKugBUgUoy732pJFUkInsa1dMcuoU7LOg1DBxKTpTQ
         d+qUrexmqSdRIqfpXLCsaGW9T+jwosGE5N0ZyDzrXzXdmzOy5z4ChVioE9YfmQnpBZEH
         LUeeCgm6gPgX+Ix1dWmdTyFcqNvz6Tz30o2Z1lXhr/INuuEfPn8F0+kp9di6bxPrD4e9
         i8w5T0Cg8dLiXJsJHcw6YpL3No+O4iOcu1rgI3/xidXz9dGmP5kn4ZjEJy55vZiVq+51
         K1IQ==
X-Forwarded-Encrypted: i=1; AKwUvBy0VFMP44nQCeGcrgTVQmEsmWkvedA0+gHCwlTesS2QeKfhVyGRvPvsY8ReE0c8wEvHTRrnuWrD9Q==@kvack.org
X-Gm-Message-State: AFq9FYIkpeVXj6G2dMCKzBMaFiTQbuoCDtshdsI7mx92JR6/Nb3i3l9G
	xQUePHUFetXZrHHtXZNX4LZTT2pLbhRBdvs8XF4J+IZHybhRQPn1XLsK
X-Gm-Gg: AYBFou1SUjshvcxuXJ9NMaj9dzc1ZBSUep0nkDXnqtXbbqj3dr3zwlT5E4vxHHUetyq
	b5m9ZrB7bA5fzCyPXMt6eRhwWAEU5aWLNEFd35YKAYhD7L5/VCkc5bd6R/ku8G12xL86kTHeHJx
	3YcHj0ZpjV0IWsDqmjoVdHI/Tsr6icK0l1cVSCQf5QqgFfbKoqCD/zM9xjRyApeYq2LDeXwqnWK
	ONgdX80IdQXzickQC4o1mDBpDYaL/lA3ojb05fnwC5u1dl7V6lOliXxnOyMxdkQREyluhO1P+2P
	WRTOb+9aa8Il/kVDj20kms5z71PVSra394vX6hoBsFYrmWyyaIDxSycDvIgKiSWcwu9qGO3kI2+
	Epf29BYYuxM5FNA6E/6ktosi7ZQXAB/8wSUM4+wH7+eUxjVacRJ6AGmY4NO7EmID/V8lY6xCyKi
	EnTlxgn1IXr2a0LhpSFJd8EQALuJda647zcKKkr8rtlkoU1q13Ee2+DAJHrAO1H0Y4g4QCmCEkA
	buuwHlWe+ZvTGqp5VPUz2aQNYs15ipRwKZtho0AF/yqx9RQ/SLCPG5fQR+VYRoo/rZhj7ld4jnb
	Zn25IPet0QNhkqBAjqCi3cGcy0FzptzWKxRG5kfQddcvlwRHbrR0A6byKk34DFk8SsGE6+isE7T
	LnE/3Oe+LtIjlYtqA2r0DvLdi
X-Received: by 2002:a17:902:e74c:b0:2dd:c0ff:e72b with SMTP id d9443c01a7336-2ea4404e987mr25918265ad.61.1792634261828;
        Wed, 21 Oct 2026 18:57:41 -0700 (PDT)
Received: from coder-ast-ast-dev-ml-0.tail2dda0.ts.net ([153.61.198.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ea3b4af4dasm17474295ad.75.2026.10.21.18.57.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 18:57:41 -0700 (PDT)
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
To: bpf@vger.kernel.org
Cc: daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	oleg@redhat.com,
	peterz@infradead.org,
	mhiramat@kernel.org,
	jolsa@kernel.org,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	surenb@google.com,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	hughd@google.com,
	kees@kernel.org,
	mingo@redhat.com,
	tglx@kernel.org,
	x86@kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH bpf-next 4/9] uprobes/x86: Don't WARN if an optimized probe can't be written
Date: Thu, 22 Oct 2026 01:57:07 +0000
Message-ID: <20261022015712.1297331-5-alexei.starovoitov@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
References: <20261022015712.1297331-1-alexei.starovoitov@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 23752C0004
X-Stat-Signature: tdnpcrtnp5ycbwjqn7w6cgnm1u46dipc
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792634262-920584
X-HE-Meta: U2FsdGVkX1+m0v5VZu6hCr2y0W5M6+pfruQIAP2G7fjxmPVtyTG6co/ZkHYGoP8AAQw6xrHhwBN71VD6E4NTdqK5vpFB8EMD74giIG8cRLKIcc2EfeaJJaGq0oWoy7MAHJ0GZ0M95w7WDKGxMdxC18+QM6+shAVYlVmcapNCPF7DnmFZNzPEpSfpXDHNfRh3SeTMuMeTEHQeRoBHi+tmECPi+TN8i2zpSVOTkwfQw2ZtCIFSx2Tl85BIVU92OvV9bUCcLGMkqVx1MA88kaqq/Jc9OSlkeIix5HWYhvcYmLZAhMwTS5+DJbC2DEAbyTTpcaiYkxIIdRM23U42i+LWVnHDLo8qSalbTHem+wV2j28P4iICqxpShXut3QwCIppFSb1r/e1qgtpukbbSnLPRKUZJO5Qoa74TTgpMmYDRfmIIcH+oSbAs/EhiHPLCwlphjd7gXHZ0FwtFlOZbuClBWf+weGAPxD2rC/z1syEmlzysspCgi/LBD+8JY62RvXlNXy9TpHc710yIgcZxQuXwVM8RW2+WwTS4WtJKEMKqJNmkIUoBhr+A/tYjgfyFO8EUIiVmEm/R78jjyHPbgLbMskx+Q08jdUeCcEK4EgX23FQMMqZWACwFmRbCb0OEEbaRY9nvC22sabfLPOgAOWIxOkubHSse7wScTwrmpLtxwrrQfVWbqQUfnGvuIrwR4PC8Aec2qdqgiL2Fj0qKEzvGaAD8w3mGz6UzOngH2Vl0aVLauauwHRX5yBHU/zNaio1+GmLEPeBCFm66aoB7KAhFacm3GAqv4ZYTv21qBS8cJhRZ2xP12SSBLExVvYtLBaaOIAiTQMk5rd8YgsEB4Egfs9r8OcxgTNUkqZo5acmtJXS2yLbKy4MBOKSle/aRMFAZ7Ijm9U+kwfz0tH6e0rqoKtGMOpHrq6Z8PeCYnyzyjNcAg0jGfcYVd03fheCKmxTsnUI2VaRAKDfhsBjSmT/
 kTSrkf6V
 rHwiskt/CrCJbnrrgh+52H/3mhz8eo971UhDnwMhfmRS1kxwJjYoDRh7opPwO0dOFa3gxROA7dVgkHHl6KKWIvCpFUSeuOoGiwyn6kDOuuYEwcMssNBRV39bZoSbxSvFT1JtAtCbsACY6qdxf428OmQtwYasepYBZR5QU6IWtSuQ3pUkSscFBV4kdpFNSMjCMzrf6mblFWx1+licOmuOhoXhybs1jCks8v2iOzR24l41dOYv+k59GrJieYMSxGRiO/4FKBePi/Bvn/hReX0B1Pg4ztuKf+qpkzeYE9Eiq7XtC+yG5b9edDYCDsTFk2r/e4ecjBwITGNKeebBfpB5NYst0t46/nz61LJDI8yqDfXZKfFv7huq+WMlH+GMoS10e6yZ1HMyGWcyNDV4p/6rG4Bftvc9crct3VJ1XOL4EmUW4GXzkB8gy2i+4YEIwRx7W+6q1Vyp87Hw4sdmyQox3w3JlQclg0bRG/wbf1N/tTm59Gcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alexei Starovoitov <ast@kernel.org>

__arch_uprobe_optimize() and set_orig_insn() do WARN_ON_ONCE() when
uprobe_write() fails, and user space can make it fail:
- -EINTR from get_user_pages_remote() when current is being killed.
- -ENOMEM when COW can't be broken, since memcg is at its limit.
- -EINVAL from __update_ref_ctr() when the process cleared the semaphore
  of SDT probe.

Kill the processes that call probed nop10. It warns in 8 of 8 runs:

  WARNING: arch/x86/kernel/uprobes.c:1186 at arch_uprobe_optimize+0x291/0x3a0
   uprobe_notify_resume+0x1c3/0x4c0
   exit_to_user_mode_loop+0x63/0x4e0
   exc_int3+0x1f3/0x250

The next patch calls set_orig_insn() from fork(). Kill the processes that
fork and keep mmap_lock busy, while a trace event on nop10 is enabled and
disabled. The kernel with the next two patches and without this one warns
in 3 of 3 runs. The whole series in 0 of 3:

  WARNING: arch/x86/kernel/uprobes.c:1161 at set_orig_insn+0x161/0x170
   register_one_mm+0x154/0x180
   uprobe_dup_mmap+0x61/0xb0
   dup_mmap+0x149/0x9f0

The callers handle the error. arch_uprobe_optimize() marks uprobe as not
optimizable and byte 0 stays a breakpoint. set_orig_insn() returns
the error. Drop both WARNs.

This depends on the previous patch. Without it WARN was the only sign of
the bytes that set_orig_insn() cannot restore. Hence no Fixes tag.

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 arch/x86/kernel/uprobes.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 62bbe41c6466..33c35bf07801 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -1170,11 +1170,8 @@ int set_orig_insn(struct arch_uprobe *auprobe, struct vm_area_struct *vma,
 		int ret = is_optimized(vma->vm_mm, vaddr);
 		if (ret < 0)
 			return ret;
-		if (ret) {
-			ret = swbp_unoptimize(auprobe, vma, vaddr);
-			WARN_ON_ONCE(ret);
-			return ret;
-		}
+		if (ret)
+			return swbp_unoptimize(auprobe, vma, vaddr);
 	}
 	return uprobe_write_opcode(auprobe, vma, vaddr, *(uprobe_opcode_t *)&auprobe->insn,
 				   false /* is_register */);
@@ -1197,7 +1194,7 @@ static int __arch_uprobe_optimize(struct arch_uprobe *auprobe, struct mm_struct
 	if (IS_ERR(tramp))
 		return PTR_ERR(tramp);
 	ret = swbp_optimize(auprobe, vma, vaddr, tramp->vm_start);
-	if (WARN_ON_ONCE(ret) && new_mapping)
+	if (ret && new_mapping)
 		WARN_ON_ONCE(do_munmap(mm, tramp->vm_start, PAGE_SIZE, NULL));
 	return ret;
 }
-- 
2.55.0


