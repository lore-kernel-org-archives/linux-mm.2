Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F2A8606A332
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=M1Vbi8X7
Received: by kanga.kvack.org (Postfix)
	id 5D6CC6B05B1; Thu, 12 Nov 2026 05:42:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5872D6B05C1; Thu, 12 Nov 2026 05:42:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44F086B05C2; Thu, 12 Nov 2026 05:42:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C9F66B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:42:34 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DA01140548
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:42:33 +0000 (UTC)
X-FDA: 85426128186.14.9F1B569
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf02.hostedemail.com (Postfix) with ESMTP id 17E4280005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:42:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=M1Vbi8X7;
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480152;
	b=hmBD/L0ImrblGnk6tEeifS5+b4alhKDRF0a5uzrhjnIOAlSk3IUU7ycfIGqByBtUccQuv/
	vjTQD9MMfylfBPv1ieccIcxHbWE2MEwe4TnEC+jL8nM91XsSL3U2A9n+UUc67rfTl1uspb
	ICec5TwotNOiwX07gC4yAPGyj6nbAyo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=M1Vbi8X7;
	spf=pass (imf02.hostedemail.com: domain of cuiyunhui@bytedance.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=klEvwnZ1yJl7mvpdDWS1ABMi3/7l4BDDL/A2UVpdY0c=;
	b=NNF/elhod6X9zytZxpr24U7hWWGUth8fJ300lOYCzIxiG1boKuF8QSTy+Htvolc8l56GZv
	VSnVdjqnhUBGoRCZ/CuMGvL50TV5HusJXzj5ud7WkzjggXLHrgCsZJfhb8ZkZ4s1bh0CZH
	j3PWRMZ69Kwnh8tVn8CUW8RKBokZGMA=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso3711273eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794480150; x=1795084950; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=klEvwnZ1yJl7mvpdDWS1ABMi3/7l4BDDL/A2UVpdY0c=;
        b=M1Vbi8X7/BY60FnwTETsuEut6tYi6sazg7lVyuz+3GC0fjXuhJjFxRjky5dGOJri6d
         Kr8lU++Dg7S/Dz4YQAzb552szieyZFkym3IZ+HmcU6qyzJYVRO/GAAlyUHee1SGQd9uR
         600nxHokC84HaXeZABym13El7wZ+xjFEJVDlMaOFhDvt0ZwIyuUehjO3ZR93IZwwfWiX
         6xAaSVzoF2mkqqbvy6RRnQt5pTwNiG4HaTEczXvzBFvKVkutXqaIa5eNNB5vfyPbQNsn
         JP8az2m8bAWHWrxnCcBW8uiCF5MKi2XrtvlAh5So6nBl3SHOR7MXPAzDCT2XDSkxrgGE
         HF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794480150; x=1795084950;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=klEvwnZ1yJl7mvpdDWS1ABMi3/7l4BDDL/A2UVpdY0c=;
        b=O7Ktlb4uHzym8vP4ZicvHSxg5M2iiOGrK6Euo5QlVfiNtplC9ScwBr3LRQcqSsRpfO
         G1d71djp+oivtVbEcGxmZtjl124fb30rYIvw3BKi5GB8FyusUrbXM0UCETOJAR98pEW0
         +ojZSMV0uY/1NpDXEbqRe2l0/hmOPlQ0WFSZkOe6UFLlJ6rbja7CY6qoYpB1EzRJijAo
         NN8FcwZ73DLuS2pD2L4LQSidE/B0Yxnhw31RLmKSXnJ8qQfdlF/Do9KAVABPG9mL80yg
         piegli3ehnQZVH1Dgw2ojUPOwUcM3xe4rNCg01FoIyMUu7DRqM0F0IlGzn0V+qHrB7hr
         FkTw==
X-Forwarded-Encrypted: i=1; AL+hErHrRXJcC/q+aP+YPKXk2WNyfxmY4RZ8Ju8I+spLgQmIkVLOmuWDVb+y0iKb16kENQxFJzkmCwVjTw==@kvack.org
X-Gm-Message-State: APuU4Z+hBpa3z69U2jAvhDCAQ4G5OFciyfkp98gTJyqUn7pJkkL2t7Hh
	L0cLp7Ssj9Jj+CxqovrZXZrSsY/5j7Dg3+4cj6Z7SXdl3l1vsQfwwl9lheEtmHxbLu8=
X-Gm-Gg: AYBFou3oCWaehLinBBmMUYamDUlpi5abm7qfRR2Ix1XKtVL2VWYpK16sbne2uJ2pml5
	Awf4TkGKPFBbLproQY7wR5jRaFjhQ1CKyIF5kx9+uMytMVz8VS4MrWQSVZ+9xZJF9uJqj0+9b+4
	tLDW/cdpNGn4dkVLk9edBRfhQJs9JKHLvSlpuLaZMjFiCAyWuRoH+yODpb0SA7ltzwo8yi4RdWW
	rZaP/ugcxHaEJjWGmizUltlqfzeEqHK4PmQaz1rW5ar9csE/OURiMNOqfGO+wUup4TA1o/dx6xF
	g0hlU3KdlYRuWUwiLqtU5QCNYOQmY2Tf7Kv/lzvJCMRfrRlWXTeFPGJYnE6ejynvlg+wwuQKON2
	dI42c+ZBDsbtsFxQk+PP0xmfsJg7mdw+vWRnJk/KirRRJ4vONuKmf8etzvaL6WfNgtnf3BauCl6
	uBSUTZCTN3H0ZzaeexkXrl2fWXkbhSZzs/UebGEq1uVpQjVEwrJOdg17d5GIe/g9jIlVV+HPpor
	Zr86zm+atLglvIeT0wT3xuWNyXnJrh8kGUfxYc34co7Dxo0i1IzUIkdbo+9kFRD5S215uKZbc+3
	6vo3eG5GweuyDLqoWd4am/rfYa5hdvcO7AZw0eLM5lObKtfMfAjk1O1aXCnjJXwcUIudZ6Ja6T8
	obdODH2UtZ617
X-Received: by 2002:a05:693c:808f:b0:36a:50f4:ed0d with SMTP id 5a478bee46e88-37686858347mr5790109eec.25.1794480147991;
        Thu, 12 Nov 2026 02:42:27 -0800 (PST)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.242])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3772121e654sm13228694eec.2.2026.11.12.02.42.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 02:42:27 -0800 (PST)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	oleg@redhat.com,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	eddyz87@gmail.com,
	memxor@gmail.com,
	martin.lau@linux.dev,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	bjorn@kernel.org,
	pulehui@huawei.com,
	puranjay@kernel.org,
	broonie@kernel.org,
	cuiyunhui@bytedance.com,
	dave@stgolabs.net,
	david.laight.linux@gmail.com,
	jszhang@kernel.org,
	tglx@kernel.org,
	conor.dooley@microchip.com,
	thuth@redhat.com,
	ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com,
	zong.li@sifive.com,
	debug@rivosinc.com,
	seanwascoding@gmail.com,
	andybnac@gmail.com,
	menglong8.dong@gmail.com,
	cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn,
	atishp@rivosinc.com,
	apatel@ventanamicro.com,
	arnd@arndb.de,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	justinstitt@google.com,
	qingfang.deng@siflower.com.cn,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	linux-arch@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v10 0/9] riscv: optimize percpu access
Date: Thu, 12 Nov 2026 18:41:40 +0800
Message-Id: <20261112104149.38589-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8ii8uk4mwtk5qc9rpmjbps4b57yeqz7t
X-Rspamd-Queue-Id: 17E4280005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794480150-787447
X-HE-Meta: U2FsdGVkX191ki/RROY0gZTROnFdUGmHZCgmnf531eGj2GVExzAK4iZwTxXiFpAGU/I6DNq2j+dtlJ9tdGq66yDMezByOU71jXqe72AycPvYR12760uq4CeJd78F97XnMBJHfp8vbSYnNDhRn3gWFc3ze+70lD7Uv1FXF7bKlq5VuPF9RwrmlhdBj/sTHgu3OAE9ZTVqvX2bpEbjQFVzFvhNkPpNwzMucdT84UnRfYf4CgmGjX7Yxm9+sbq3A97me6CXVgFutf8VW4JU6rrp9X8temY6yioO/mmymJo5OXPqvjIB22lDhkM2QLQKRC15JaAEqtY2nE7eWFZy76mDKHiZ87Gz449tYWCWROAkbYSmga4bHbZAADq6ShjOz9UCSuhwztC3cuKQ2/MA8PBqt59b6q1f6XBNZDoWzNpl+ihTLuDDOhT8wcaTikLJt8mIvgxWG8bIlYnls2azeR71i6rZabFoqI0r2xsZFTBXW9IH46SjQENqbjlhx0NcClT7sCkcGTarLdxNX1ZVDEcFQ3uE2f24Ks6wbQNzk2RVix4ZKYs6S9haHBQ0WoIFXE3gHbEqmBz+Bz/pE7fS2E5ZFiJ3ij536DzVzV3MhZXZXDRhWLNoI9h8ZzuXXehgZiKjw110uR0q9pz8DEKS8MGPYAVvKYA6DfQcxGTecIWmfRe+2LR+D1IpQM1VXDNngQcNy/BXKtRa24vOITvqJYV3IMw8fEiDtrTyOTHTTbRewEghe0oZB/xDJ3NRc+k7zEuwGkGiInJknYiYHvCReiq8pmo6NEa4XlJbMDsZDxT8MqHObpQr78wH76IEqqcgcqVJhs4JRFq3NXAqfFN8qMiDSFIVRRW1DYwMcZo3ioPL7m8co+o5IzmcX0S1RG20xEENdJ1pq257H3zEqLMroxgO6/ABE7gEkyfOw5wcQMVkj7oSVfLbapdrzWkZZLD0BATHhUd+J147LC+TGc42NFW
 NOVvI2Cj
 rEJq3OWiMPqKx6MRyigaGjDNDF1WzuKciHt2CPb6QvlXoqqwlTOnW7Sha81SV1VTzv4qX2dpA68yhTYPfq4skDx5hHCjT6JzqQs33aeIKIKoZ1TPwJ1KBXUnrCo4bGYy0AsNjUy5RpBQ083uY1avun60HWF7+3568fDO/wDjuQdD86QlhZJT33lAte5GsRUfqbqkCCXYO57XHsRF7LwKc5ddoA1y8jI0YOkt8O8kqY06uJOYZfaMhePw445Ej4PIDuk5Y2rAG1bsmKct+HHysoMQXSItm+iqRSMCdKwjpE7QbzzdvQUvHJQhaD3uNZ34gEv7HL+7IUe13nBgedGJDQKqRqve1peJ5/wPne9TcvWTesV82By6E+6Vhxf6q9mriyXPXtzP/vLx5B2w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

RISC-V has no asm/percpu.h, so this_cpu_*() read-modify-write
operations use generic fallbacks that disable local interrupts. Per-CPU
addressing also derives the current offset from the CPU number and
__per_cpu_offset[].

Cache the per-CPU offset in thread_info and implement preemptible this_cpu
operations using recoverable GPR critical sections. Each operation records
the registers used to form its per-CPU address so exception return can
repair them if the task resumes on a different CPU. Use AMOs for
native-width operations. Use Zabha for 8-bit and 16-bit operations when
available, or a 32-bit LR/SC fallback otherwise. Finally, select
HAVE_CMPXCHG_LOCAL so common per-CPU counter users can use
this_cpu_try_cmpxchg().

The recoverable-GPR scheme follows the arm64 design. Only the protocol is
common, however: RISC-V uses a cached offset in thread_info, its own GPR
encoding and exception entry code, and AMO/LR/SC operation sequences.
Factoring these pieces into generic code would share little beyond the
field layout while coupling architecture entry paths, so keep the
implementation under arch/riscv.

As with arm64's SDEI path, independent NMI-like entry paths must
participate in the entry-state protocol directly. Keep the save, clear and
restore operations in common RISC-V assembly macros so SBI Supervisor
Software Events (SSE) can preserve an interrupted per-CPU operation. SBI
SSE support is developed separately and is not a dependency of this
series.

With CONFIG_PREEMPT_LAZY=y, GCC 15, the same linux-next base and
configuration, an in-kernel microbenchmark pinned to one CPU ran each
operation 2,000,000 times for 15 rounds. The table reports the median
empty-loop-adjusted time; lower is better.

  operation                 v9 (ns/op)   v10 (ns/op)   change
  this_cpu_read(u64)            5.668         0.333     -94.1%
  this_cpu_write(u64)           5.668         0.395     -93.0%
  this_cpu_add(u64)             8.002         8.004      +0.0%
  this_cpu_add_return(u64)      8.335         8.004      -4.0%
  this_cpu_xchg(u64)            8.278         8.004      -3.3%
  this_cpu_cmpxchg(u64)        18.713        16.133     -13.8%

With the same configuration, vmlinux .text decreased from 14,369,618 to
14,212,882 bytes (-156,736 bytes, -1.09%). percpu_counter_add_batch()
decreased from 330 to 228 bytes.

Changes since v9:

- Rework the this_cpu operations to remain preemptible using recoverable
  GPR critical sections, as suggested by David Laight and Jisheng Zhang.
- Put the cached per-CPU offset first, then split the exception/fixup
  infrastructure and operation classes into independently reviewable
  patches.
- Keep GPR-state save and restore in reusable assembly macros for NMI-like
  entry paths such as SBI SSE.
- Keep masked LR/SC cmpxchg operands XLEN-wide so RV64 high-byte and
  high-halfword comparisons are not affected by LR.W sign extension.
- Force both halves of the AMOCAS.Q new value into fixed registers so the
  implicit register pair remains valid when either half is zero.
- Use TYPEOF_UNQUAL() in wrappers and fully parenthesize this_cpu_write()
  values.

Changes since v8:

- Drop the PIO helper patch, which has already been merged.
- Rename the first patch and update its changelog as suggested by
  Davidlohr Bueso.
- Use value-returning AMOs instead of rd=x0 for CPU-local operations.
- Remove unnecessary memory clobbers from the new relaxed AMO and LR/SC
  code.
- Use .option arch,+zabha for the Zabha inline asm, matching the
  existing RISC-V cmpxchg implementation.
- Isolate arch_cmpxchg_relaxed() behind typed always-inline helpers to
  avoid macro variable capture while preserving atomic instrumentation.
- Make the cmpxchg128 fallback use the already resolved per-CPU pointer,
  avoiding the same macro variable capture.
- Copy the cached per-CPU offset from prev to next during context switch,
  as suggested by Thomas Gleixner.
- Initialize secondary idle tasks in the common startup path, covering
  parallel bringup and CPU hotplug, and remove the duplicate initialization
  from smp_callin(), as reported by Sashiko.
- Select HAVE_CMPXCHG_LOCAL in a separate patch.

Yunhui Cui (9):
  riscv: store percpu offset into thread_info
  riscv: add infrastructure for preemptible this_cpu operations
  riscv: implement preemptible this_cpu read and write operations
  riscv: implement preemptible this_cpu void RMW operations
  riscv: implement preemptible this_cpu add_return operations
  riscv: implement preemptible this_cpu xchg operations
  riscv: implement preemptible this_cpu cmpxchg operations
  riscv: implement preemptible this_cpu cmpxchg128
  riscv: select HAVE_CMPXCHG_LOCAL

 arch/riscv/Kconfig                   |   1 +
 arch/riscv/include/asm/asm.h         |  25 +-
 arch/riscv/include/asm/percpu.h      | 701 +++++++++++++++++++++++++++
 arch/riscv/include/asm/ptrace.h      |  15 +
 arch/riscv/include/asm/switch_to.h   |   9 +
 arch/riscv/include/asm/thread_info.h |   4 +-
 arch/riscv/kernel/Makefile           |   1 +
 arch/riscv/kernel/asm-offsets.c      |   4 +-
 arch/riscv/kernel/entry-common.c     |  32 ++
 arch/riscv/kernel/entry.S            |  10 +
 arch/riscv/kernel/smpboot.c          |  10 +-
 arch/riscv/net/bpf_jit_comp64.c      |   9 +-
 12 files changed, 805 insertions(+), 16 deletions(-)
 create mode 100644 arch/riscv/include/asm/percpu.h
 create mode 100644 arch/riscv/kernel/entry-common.c


base-commit: ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b
-- 
2.39.5


