Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 228BC606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 04:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aLaM8Z4B
Received: by kanga.kvack.org (Postfix)
	id 2D4F66B0994; Wed, 28 Oct 2026 00:50:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2867B6B0995; Wed, 28 Oct 2026 00:50:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174496B0996; Wed, 28 Oct 2026 00:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DEF706B0994
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 00:50:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEDFE40202
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:50:35 +0000 (UTC)
X-FDA: 85370809230.20.1364A78
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id 34E0C100007
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 04:50:34 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aLaM8Z4B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nikumbh.adi@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=nikumbh.adi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793163034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xqa9sataa0EvWK9xXgFBg5VA7nrfM45tjZKpi0uBZgk=;
	b=zi2ddKQv4YpM6F3uawxniERC1SaegPWMeMXRC5qC1m1xQWNkSw+nC5WG5zg6aJapykvKEe
	REu2mOa7G3Ynd0RbWjZLvb0HBWGgewBf6KBzCrOWiuD8dCSyMvBdo73+smM7XExcoYmVRg
	GmZ2lflB/SDts3GjlnZ59F9h6FxR+0Y=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aLaM8Z4B;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of nikumbh.adi@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=nikumbh.adi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793163034;
	b=oAQ9oIKGVjdvSI7FfysLw2+3dxLUudB7AWXi0KmmfJtw2BuziIVLR8b4DNTzTBLu263Zvu
	QSNwrCAv9QXDPo7IvjF7n6lH2EjWKg6FoKznTGCehR8FUYi+FGa0rs60jX2eLZYYMSt7s8
	Q3FPtykvJQ2mN4TK7gGEuMbWJ9NNG0Y=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-36a1947498bso1661481eec.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 21:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793163033; x=1793767833; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xqa9sataa0EvWK9xXgFBg5VA7nrfM45tjZKpi0uBZgk=;
        b=aLaM8Z4BqCvndlxO6kdR+b9kbQerttIAz4X64CiZ7zLULlsTyOi7bKXG9eKflBXRKu
         vYMGX/l/PgSLTuPQuaP90wmFiDiNqVMEOCLktJYXHLkr7kNIInXZKi6J+IEFp82IyNg/
         fS8wcvbt15WV9AA/AoUa7ci5V6ZbWkVs85Z0+6DPZqNyYYfjSJyTA0O4RFOxFn8uOArt
         TdZ5NKEfxRKcAbykkDZXWFiGYjZ/AOxqOloTK7ahiFqIBQLMmQv9ze7pyF749Jq+Dmko
         OR1+jWUJ6k2m4TK8oWcgLGyqUnxHiZAOJ0ckXwDZgTx0xAJqK1Mbwl6e5ybMrGUJu/ZK
         1spg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793163033; x=1793767833;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xqa9sataa0EvWK9xXgFBg5VA7nrfM45tjZKpi0uBZgk=;
        b=IwSEKksLEJbum45aBKx9Uil+akROisIlx1OYpL8Qps850YZ4ObKA6p1y1hvBoCkgkP
         X+pWUsqLBM3bpOWBAFcygL8SpSxhhxEUkdhCC40YL2PJN20zWSWxrXm3lNW3NLrcwbug
         xapzKv3h9f41lpcJ+rXfs3Wedyda4Boydn+ThQ9jSe4mYEM4eEoZiCItyiPmy+Ze/kxq
         0ZJujlu4Rr54Y3Ie+u3hXvJIibNtZUr7rrHI+XCisBsKBPmHfXf703X/yStoegrf8pzq
         LbzgpgQfzejcjF7jfxLFIIML6dJmmxSweneq5wWrqG+2u3t+4CnXQCdrhQfn0ASjmnCv
         WRoA==
X-Forwarded-Encrypted: i=1; AKwUvBx+bFaq7WbnVCySb09LpfDrDFklxcvIQk18WTynoRnm1XfIOjEXXtipy5Xmdr3vM2veVlUckwQqpg==@kvack.org
X-Gm-Message-State: AFq9FYJmoC1rGH+7g4SCQzldeNwsc/Y+C4U056QgP2WoHNppSAtwKDtl
	gFmRN7I4R9H8KjjnqkXYgWS7L6bPuJEYdY2q3qMLNKv3PMC8c3YnoFcSJRNNWPZ771Q=
X-Gm-Gg: AYBFou2wRyi+JufwzVp35VBvU+m1fQw098uny9RLK0GWoIZcLyZhCIa2LWjQqQKpyY3
	4GBKrlfUJheRrJiMgQOBtnsHWop7liIDCqYkFOS6H53wZ0U6FQSW2eD+7MeBDxDdVgqLbPah/l8
	FpTPWi2caOG03IhkOWbMC3Ys/tBDlLlA4ZiEvCH5SwiHMHJm71nSqtdxwe75JbAecgSNl8IuLM7
	GIvze4eJyB2Ooa2ihIC6ZeH9sZNHXTOslaJosMFzd4CPp8IJuROA2w/PMe/OUqy9L9iF231rI8Y
	IOnFkBeQ5uPGaEZWbWPNLiffKE/5n12Vg2A/OmE/alcJT7YCKBeXhARB44CqFlg6K/7ZSJG1Ao7
	YjupIOQVGwZQRCR41OPE+ISWFiJPFwuVfVC81b4ojQALn4bW+GkPRIUxm2k7G/nWqHPfDdB2JVD
	IfdVW6yWfwo8SGOiT2A5DT4103B6K/H3IQIGZ1+x61HnOnP1+4/eFpqYSnGXwJigkfDL0zh36Dh
	3zYnBy/Ef5OmDysT6BZ/hSqt8y31u40GUgm1y0bThw9v0V0YMkJ3MhgVp5hle+x1yjIoms7lmWD
	UzI/vOvW74yifsJs3OejtAEvJl8gEiI217m+sxJsP8yZat4VuLpApG+hvPBJuXw0dmytBqZjNsw
	tyO/EiTn0UX00fg==
X-Received: by 2002:a05:7301:1890:b0:36a:1088:fb2f with SMTP id 5a478bee46e88-36a203cd260mr2028341eec.14.1793163032485;
        Tue, 27 Oct 2026 21:50:32 -0700 (PDT)
Received: from localhost.localdomain ([99.43.103.81])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a23908542sm2408998eec.10.2026.10.27.21.50.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 21:50:32 -0700 (PDT)
From: Adi Nikumbh <nikumbh.adi@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: Adi Nikumbh <nikumbh.adi@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Tony Luck <tony.luck@intel.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Tong Tiangen <tongtiangen@huawei.com>,
	Ruidong Tian <tianruidong@linux.alibaba.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] arm64: Add copy_mc_to_kernel() that recovers from synchronous external aborts
Date: Tue, 27 Oct 2026 21:50:28 -0700
Message-ID: <20261028045028.72644-1-nikumbh.adi@gmail.com>
X-Mailer: git-send-email 2.50.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 34E0C100007
X-Rspam-User: 
X-Stat-Signature: nqk8tzsmw6bh6srxm37amjhjzyzcu8t9
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793163034-984779
X-HE-Meta: U2FsdGVkX19+F0bgoEb+YyDzHxuTdQ29PeC/cK+Il1yt2gCyPHB87AygWfYk77KNiqjlsQSRWNm/MqoxgLqvYkcrQs34mPp8dmRVx9TRNlRciVB+eyooOUF0fMDPcH7opCeSj27/iu30A6oJvRM0fkghf+ephB5L9nRErEuI8a6/hRfBmno50Jv5lb5DKlc4kasmTfIQ6rFCkbqVAaqYiyB2Sq0/ujzRabrLZWJjccg3O/Le5TWKQk5nuH5mM61ZyBEpUnsd33XNDwzLx0VX39UQCq4OsgDQ/OLG+P/FZ5rdwvNQxUsVK8iGH/Jn0vLoH0P9a5JmmurxGfNT0YrEvDmh+dUEmTj4JVAQGbqkBVP1slf5eyBxjsacoj/bAvw9856OoXODsqsA9qMVS29FBOImaGGkkbhOHLp+cORBHcVCwiAF0JmGt9aIpfsbX4t49qZ9n5JKWbvPf4kr+iqPcW8whPW9rXkq7Il0LQzyFNb5syEJO8aFbSBFupRI8nRC9ZVwqg4sOr4b710NjbVyzzK26tqWHXW8A6v5r7IJl050zOOKcf5+UvL6jUq1Jc95hiwJap4LRYW0AgHJK07PuI06yLhQq/gQba+W+T7FCApSMKFybJ+p+aaMiyCDYiojoPT/FZQwjos96cIO9KJHTCqyFyi3Jp2eKQpFk/U50ANqzaaZNStpOVKlV4DphC88r/CSPtWnE4VxN2OfO8ZKSTTjwkxAlikfZ0prbvU9A4D0MesF5dCA6beJjpwYFnZ4pzvwiIm7kpj5TEQ+WJhoEXTE1wgSD5+S3tg5I+LMVWfZxEE1WKcpdJ7N5vXyk5xVXCFPcCN/+rNIzWXp2VJtCKaNJXhL6Kd2hQebKbP+HVBLWjJOimapN8RDl124IaAzycs4XgIIreAtiscvhbdE0Azsqb88huEtu+p8/pMgSEpbKJTk7bDGtOGo0iJbIfPH8S/7ePmSRrhFtcjiFpb
 2V9x2/b9
 EQGEePYWKCxWXQk6vKNcVKTDU1frN0tWv23Uns3d96qlF5Xh46z16eAtU2IJFOiQCHjapKlQW8qIZOJ5jrnVLuBrzY3Qpar0/3y4Wr7XF1WC9zWdVX6Mm968RB+o0Vw99K6rwmWHqg6OfsKJNp2PelU6H3hdPn3uo90iSdRLNKSXV9hkmoLuj8n9RziKQwqDm54uMTT05+dvH0xf7e07LtgAq1Is6i8JMFTObbk+EapU3DKqZ/Gr6QO7iYdYNGqj3EWMiEMU6GbSo60ZfPu3m2XbemXQ3Ndo47CfKipGgB42ZUy0dWM01nvmRSnVoQvYWU9vjy7ZSaeP+PBf7wgGI8x05O1RLOlVLl3vC9GkHi+zJHhiiqBqrz5vMxNn5qMqXMvldsQzk1prmD4C/3a7Q3cgGIslIoZ/d33dp6YhlDfVVMu47l4Q00WWi4p3vVOrFOsGuaw7tgEle84jHW3xYYTW1FK7VnxnYBBfaj8kZniPJjk6XRy1FTEwCrx+PrHbQF0YfXtEO+GtjDELwZj0KSSfN/QnDfafh1+ukzSkb0Q0yZpXPp1CWzVS+uvkRUtbT+qhMj1Ai0eP//1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Without ACPI APEI firmware-first error handling, as on Zynq UltraScale+
boards using synopsys_edac, an uncorrectable DRAM ECC error reaches the
CPU as a synchronous external abort (SEA). When the kernel itself reads
the bad memory, do_sea() can only die.

fs/coredump.c already copies each page with copy_mc_to_kernel() when the
architecture provides it, so that a poisoned page ends the dump rather
than the kernel. arm64 does not provide it. A process killed with SIGBUS
by a SEA on poisoned memory is then dumped with a plain memcpy(), which
reads the same memory again from kernel mode and oopses.

The oops is worse than the original error. The dumping thread dies
before coredump_finish(), so every other thread of the process stays in
exit_mm() in TASK_UNINTERRUPTIBLE, waiting for a dump that never
completes. The process cannot be killed, and a service manager waiting
for it to exit cannot restart it.

Provide copy_mc_to_kernel() for arm64. Its source loads carry a new
EX_TYPE_KACCESS_MC exception table entry. When a kernel-mode SEA lands
on one of those loads, do_sea() moves the PC to the fixup and the copy
returns the number of bytes it did not copy. fixup_exception() does not
handle the new type, so other faults on these loads behave as they do
for memcpy(). The kernel is still tainted with TAINT_MACHINE_CHECK.

Only an EL1 data abort with an external abort fault status is
recovered. Aborts on instruction fetches or translation table walks
still die, and so does an error that a CPU with the RAS extension
reports as uncontainable.

Recovery does not depend on apei_claim_sea(). A SEA on a load is
synchronous and precise: the load did not complete, so resuming at the
fixup is safe however the error was reported. do_sea() still calls
apei_claim_sea() before resuming so that firmware-first systems record
and handle the error.

Defining copy_mc_to_kernel also gives its existing users the same
behaviour on arm64: copy_mc_highpage() and copy_mc_user_highpage(),
which queue memory_failure() for the source page on failure, and the
pmem, DAX, dm-writecache and dm-pcache drivers. copy_mc_to_user() and
ARCH_HAS_COPY_MC are left for later.

Signed-off-by: Adi Nikumbh <nikumbh.adi@gmail.com>
---

Notes:
    Testing: arm64 defconfig with EDAC_SYNOPSYS, MEMORY_FAILURE,
    BLK_DEV_PMEM=m, DM_WRITECACHE=m, DEV_DAX=m and WERROR builds without
    warnings; fs/coredump.o now calls copy_mc_to_kernel(). Tested in QEMU
    virt (TCG, cortex-a53) with an out-of-tree module, where a load from an
    unassigned physical address raises a synchronous external abort (ESR
    0x96000010). Without this patch, copy_mc_to_kernel() from that address
    oopses in memcpy(). With the patch, it returns the full length as not
    copied, sets TAINT_MACHINE_CHECK, leaves the destination unchanged and
    the kernel continues. copy_mc_to_kernel() on RAM matches memcpy() for
    sizes 0 to 4096 at offsets 0 to 2. Instruction-fetch, table-walk and
    RAS-uncontainable aborts still die, but QEMU cannot raise those on the
    annotated loads, so that is checked by review only. Not yet
    tested on ZynqMP hardware or with a real DRAM ECC error, and not
    through the coredump path end to end.
    
    Prior work: Ruidong Tian's "arm64: add ARCH_HAS_COPY_MC support" v15 [1],
    which continues Tong Tiangen's series, does more (copy_mc_to_user(),
    copy_mc_[user]_highpage(), ARCH_HAS_COPY_MC), but its do_sea() only
    applies the kernel fixup after apei_claim_sea() succeeds, so it does not
    help systems without APEI firmware-first handling. This patch is the
    smaller piece that does. The two conflict, since both add an exception
    table type and a memcpy_mc.S. If v15 is the preferred base, I am happy
    to rework this as a follow-up on top of it. If the arm64 maintainers want
    the APEI gating kept, I would welcome guidance on how DT-only systems
    should opt in.
    
    [1] https://lore.kernel.org/all/20260618092124.3901230-1-tianruidong@linux.alibaba.com/
    
    Tool use: this patch was drafted with an LLM coding assistant
    (Anthropic's Claude). It traced the coredump and do_sea() paths,
    drafted the architecture, the code, the changelog and the QEMU test
    module, and ran the builds, checkpatch and the QEMU tests. A second
    model (OpenAI's) reviewed the patch; its findings restricted recovery
    to EL1 data aborts with an external abort fault status.

 arch/arm64/include/asm/asm-extable.h |  9 ++++++
 arch/arm64/include/asm/esr.h         |  1 +
 arch/arm64/include/asm/extable.h     |  1 +
 arch/arm64/include/asm/uaccess.h     |  4 +++
 arch/arm64/lib/Makefile              |  2 ++
 arch/arm64/lib/copy_mc.c             | 28 +++++++++++++++++
 arch/arm64/lib/memcpy_mc.S           | 45 ++++++++++++++++++++++++++++
 arch/arm64/mm/extable.c              | 15 ++++++++++
 arch/arm64/mm/fault.c                | 33 ++++++++++++++++++++
 9 files changed, 138 insertions(+)
 create mode 100644 arch/arm64/lib/copy_mc.c
 create mode 100644 arch/arm64/lib/memcpy_mc.S

diff --git a/arch/arm64/include/asm/asm-extable.h b/arch/arm64/include/asm/asm-extable.h
index d67e2fdd1ae..60cbadff723 100644
--- a/arch/arm64/include/asm/asm-extable.h
+++ b/arch/arm64/include/asm/asm-extable.h
@@ -11,6 +11,7 @@
 #define EX_TYPE_KACCESS_ERR_ZERO	3
 #define EX_TYPE_UACCESS_CPY		4
 #define EX_TYPE_LOAD_UNALIGNED_ZEROPAD	5
+#define EX_TYPE_KACCESS_MC		6
 
 /* Data fields for EX_TYPE_UACCESS_ERR_ZERO */
 #define EX_DATA_REG_ERR_SHIFT	0
@@ -77,6 +78,14 @@
 	__ASM_EXTABLE_RAW(\insn, \fixup, EX_TYPE_UACCESS_CPY, \uaccess_is_write)
 	.endm
 
+/*
+ * Create an exception table entry for a kernel load in copy_mc_to_kernel(),
+ * which will branch to `fixup` only on a synchronous external abort.
+ */
+	.macro		_asm_extable_kaccess_mc, insn, fixup
+	__ASM_EXTABLE_RAW(\insn, \fixup, EX_TYPE_KACCESS_MC, 0)
+	.endm
+
 #else /* __ASSEMBLER__ */
 
 #include <linux/stringify.h>
diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
index a584f88dbaf..8436c8d4668 100644
--- a/arch/arm64/include/asm/esr.h
+++ b/arch/arm64/include/asm/esr.h
@@ -105,6 +105,7 @@
 #define ESR_ELx_VNCR		(UL(1) << ESR_ELx_VNCR_SHIFT)
 #define ESR_ELx_SET_SHIFT	(11)
 #define ESR_ELx_SET_MASK	(UL(3) << ESR_ELx_SET_SHIFT)
+#define ESR_ELx_SET_UC		(UL(2) << ESR_ELx_SET_SHIFT)
 #define ESR_ELx_FnV_SHIFT	(10)
 #define ESR_ELx_FnV		(UL(1) << ESR_ELx_FnV_SHIFT)
 #define ESR_ELx_EA_SHIFT	(9)
diff --git a/arch/arm64/include/asm/extable.h b/arch/arm64/include/asm/extable.h
index 9dc39612bdf..2629a2fe18c 100644
--- a/arch/arm64/include/asm/extable.h
+++ b/arch/arm64/include/asm/extable.h
@@ -48,4 +48,5 @@ bool ex_handler_bpf(const struct exception_table_entry *ex,
 #endif /* !CONFIG_BPF_JIT */
 
 bool fixup_exception(struct pt_regs *regs, unsigned long esr);
+bool fixup_exception_mc(struct pt_regs *regs);
 #endif
diff --git a/arch/arm64/include/asm/uaccess.h b/arch/arm64/include/asm/uaccess.h
index 9f5bd9c69c2..19596fa3d67 100644
--- a/arch/arm64/include/asm/uaccess.h
+++ b/arch/arm64/include/asm/uaccess.h
@@ -474,6 +474,10 @@ extern long strncpy_from_user(char *dest, const char __user *src, long count);
 
 extern __must_check long strnlen_user(const char __user *str, long n);
 
+unsigned long __must_check
+copy_mc_to_kernel(void *to, const void *from, size_t size);
+#define copy_mc_to_kernel copy_mc_to_kernel
+
 #ifdef CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE
 extern unsigned long __must_check __copy_user_flushcache(void *to, const void __user *from, unsigned long n);
 
diff --git a/arch/arm64/lib/Makefile b/arch/arm64/lib/Makefile
index 38ffd359123..2772ce3ead9 100644
--- a/arch/arm64/lib/Makefile
+++ b/arch/arm64/lib/Makefile
@@ -11,6 +11,8 @@ lib-y		:= clear_user.o delay.o copy_from_user.o		\
 
 lib-$(CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE) += uaccess_flushcache.o
 
+obj-y		+= copy_mc.o memcpy_mc.o
+
 obj-$(CONFIG_FUNCTION_ERROR_INJECTION) += error-inject.o
 
 obj-$(CONFIG_ARM64_MTE) += mte.o
diff --git a/arch/arm64/lib/copy_mc.c b/arch/arm64/lib/copy_mc.c
new file mode 100644
index 00000000000..365df3bfea3
--- /dev/null
+++ b/arch/arm64/lib/copy_mc.c
@@ -0,0 +1,28 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/export.h>
+#include <linux/instrumented.h>
+#include <linux/uaccess.h>
+
+unsigned long __memcpy_mc(void *to, const void *from, unsigned long n);
+
+/**
+ * copy_mc_to_kernel - copy memory, surviving uncorrectable source errors
+ * @to: destination address
+ * @from: source address
+ * @size: number of bytes to copy
+ *
+ * Return: 0 on success, otherwise the number of bytes not copied because a
+ * source load hit memory with an uncorrectable error.
+ */
+unsigned long __must_check copy_mc_to_kernel(void *to, const void *from, size_t size)
+{
+	unsigned long ret;
+
+	instrument_memcpy_before(to, from, size);
+	ret = __memcpy_mc(to, from, size);
+	instrument_memcpy_after(to, from, size, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(copy_mc_to_kernel);
diff --git a/arch/arm64/lib/memcpy_mc.S b/arch/arm64/lib/memcpy_mc.S
new file mode 100644
index 00000000000..e34a86bc0d2
--- /dev/null
+++ b/arch/arm64/lib/memcpy_mc.S
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#include <linux/linkage.h>
+#include <asm/asm-extable.h>
+#include <asm/assembler.h>
+
+/*
+ * Copy memory whose source may contain an uncorrectable error. A synchronous
+ * external abort on a source load stops the copy instead of killing the
+ * kernel. Faults of any other kind are handled as they are for memcpy().
+ *
+ * Parameters:
+ *	x0 - dest
+ *	x1 - src
+ *	x2 - n
+ * Returns:
+ *	x0 - bytes not copied
+ */
+SYM_FUNC_START(__memcpy_mc)
+	cmp	x2, #8
+	b.lo	.Lbytes
+.Lwords:
+1:	ldr	x3, [x1], #8
+	str	x3, [x0], #8
+	sub	x2, x2, #8
+	cmp	x2, #8
+	b.hs	.Lwords
+.Lbytes:
+	cbz	x2, .Ldone
+2:	ldrb	w3, [x1], #1
+	strb	w3, [x0], #1
+	subs	x2, x2, #1
+	b.ne	2b
+.Ldone:
+	mov	x0, #0
+	ret
+
+	/* The faulting load did not complete, so x2 still counts its bytes */
+.Lfault:
+	mov	x0, x2
+	ret
+SYM_FUNC_END(__memcpy_mc)
+
+	_asm_extable_kaccess_mc	1b, .Lfault
+	_asm_extable_kaccess_mc	2b, .Lfault
diff --git a/arch/arm64/mm/extable.c b/arch/arm64/mm/extable.c
index 299a244f68e..22b0356664b 100644
--- a/arch/arm64/mm/extable.c
+++ b/arch/arm64/mm/extable.c
@@ -105,7 +105,22 @@ bool fixup_exception(struct pt_regs *regs, unsigned long esr)
 		return ex_handler_uaccess_cpy(ex, regs, esr);
 	case EX_TYPE_LOAD_UNALIGNED_ZEROPAD:
 		return ex_handler_load_unaligned_zeropad(ex, regs);
+	case EX_TYPE_KACCESS_MC:
+		/* Only a synchronous external abort is fixed up, by fixup_exception_mc() */
+		return false;
 	}
 
 	BUG();
 }
+
+bool fixup_exception_mc(struct pt_regs *regs)
+{
+	const struct exception_table_entry *ex;
+
+	ex = search_exception_tables(instruction_pointer(regs));
+	if (!ex || ex->type != EX_TYPE_KACCESS_MC)
+		return false;
+
+	regs->pc = get_ex_fixup(ex);
+	return true;
+}
diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
index b22736853fc..f65304f29f6 100644
--- a/arch/arm64/mm/fault.c
+++ b/arch/arm64/mm/fault.c
@@ -874,6 +874,26 @@ static int do_bad(unsigned long far, unsigned long esr, struct pt_regs *regs)
 	return 1; /* "fault" */
 }
 
+/*
+ * A kernel data abort on memory with an uncorrectable error can be recovered
+ * by copy_mc_to_kernel(). Aborts on instruction fetches or translation table
+ * walks cannot, and neither can errors the CPU reports as uncontainable.
+ */
+static bool is_el1_recoverable_sea(unsigned long esr)
+{
+	if (!is_el1_data_abort(esr))
+		return false;
+
+	if ((esr & ESR_ELx_FSC) != ESR_ELx_FSC_EXTABT)
+		return false;
+
+	if (cpus_have_cap(ARM64_HAS_RAS_EXTN) &&
+	    (esr & ESR_ELx_SET_MASK) == ESR_ELx_SET_UC)
+		return false;
+
+	return true;
+}
+
 static int do_sea(unsigned long far, unsigned long esr, struct pt_regs *regs)
 {
 	const struct fault_info *inf;
@@ -889,6 +909,19 @@ static int do_sea(unsigned long far, unsigned long esr, struct pt_regs *regs)
 		return 0;
 	}
 
+	if (!user_mode(regs) && is_el1_recoverable_sea(esr) &&
+	    fixup_exception_mc(regs)) {
+		/*
+		 * copy_mc_to_kernel() read memory with an uncorrectable error.
+		 * It returns the bytes it could not copy and its caller handles
+		 * the failure, so the kernel does not need to die. Firmware-first
+		 * systems still get to record the error.
+		 */
+		apei_claim_sea(regs);
+		add_taint(TAINT_MACHINE_CHECK, LOCKDEP_STILL_OK);
+		return 0;
+	}
+
 	if (esr & ESR_ELx_FnV) {
 		siaddr = 0;
 	} else {

base-commit: 8a36f53fd5ec3eff01f1b637d42cbdc3821d0493
-- 
2.53.0


