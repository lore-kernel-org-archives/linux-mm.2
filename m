Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71949606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 07:28:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=IqFh6xEi
Received: by kanga.kvack.org (Postfix)
	id 58DDD6B05B2; Sun,  8 Nov 2026 02:28:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E5F6B05B3; Sun,  8 Nov 2026 02:28:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 454D86B05B4; Sun,  8 Nov 2026 02:28:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 205EE6B05B2
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:28:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2CE901602A5
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:28:24 +0000 (UTC)
X-FDA: 85411123728.02.F7C9456
Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5557640002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:28:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IqFh6xEi;
	spf=pass (imf12.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794122902;
	b=Feyzp35nYNtv3NVcXX1Y/MSooDjo0JF9Fh0et911nn/ac3R20Jt6vxzbHPpCIiSrima+fL
	rs8J13b4mhn64a7YHI/omjZ6KDqqvz7Ky93vMvVT+eOjgDVhXO5ViHioAB9LAmY914kKK4
	4tvRGJtvD9sZ6FEYeQAiOTvMDAgMkcE=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IqFh6xEi;
	spf=pass (imf12.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.41 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794122902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3GPdPWtz5u4EzHahKBPeD/s+natUps7WDXeM/yF/8SA=;
	b=X0imhQ0HdRqopdi9gmaHLPoVhf+qI1V/yDMbU5iqlME67CmfXtkU12iHbzImdOomt4yD+z
	xM8LiZUWOqSnbrM5T6bnXWfmQG4o6im1cbIeMYGpfy1VUNphIwnHbdoXV3xm7kNUWgrDJl
	WS8sA2DVSRTrvUiWhG/al1K4i5nDv2U=
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-8439fe796ebso128604a34.3
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 23:28:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794122899; cv=none;
        d=google.com; s=arc-20260327;
        b=lhF8BPUG0EPY4TvFRBOR/nYxssVk2KkjIamJRr+6LpPhb4M92L6VMvbOiDKtpRotxW
         Rd5adBw2PbF8Q8tq+VdyJtO3jIUAvU1Mn9kAC1KvupiSf27m1zhPmEkcL82BhGVz60gK
         EfmBfv9n/Dmm8RZ9YQTHK17w8aROn1jAoi/spqt2U9s+ExrUD9wP9CPGJmdKpx2gq4pE
         ivJdtm2PFnBn1clxdbO5eTaq+/obs0uDMmgpsDmGXa2MESqksv4wPe6HJxybfxBRjsO1
         LGm0/C+BEw8fZII0Ntd+vm08U+Huhy8HoUxKGMKuJsP4T0v8fbAqqXXBW08v5wyaICxk
         VN1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3GPdPWtz5u4EzHahKBPeD/s+natUps7WDXeM/yF/8SA=;
        fh=0nfzr478tGh+lCZGuWX774t073b5tXshf27aFjw9lxg=;
        b=W/FaR4YwhErNpoV4/TfwtkIb3zRHrpTkfHSLu+HQTbw4h6AyBlZ3xiDKFxr1oJNYYL
         v9cZgMJGtJogcoG/2OqUf5hhtzNvqaxQtILkMzB8JPa3l5b295p/DcX2QsKy+W0bopbR
         PwoTDPjExeAzfaphDVZS0x0nB/RgJ7Fesw6OGOmtvhcUWSGceGprQ2Zdivqk1WM1jGxk
         FovRiOFlxPf8xD+4hOrPIzs4qYL1T8AS0NuJtZio7SYdlkptpgKgQ/ZrmRcIuFKHspQI
         /eh7pZwehRLqboNoWJ+qmOQjz56OTmt+a8L21mxK8f2mpqaxpBNaFA1o7joYJ2EJdhd/
         WVqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794122899; x=1794727699; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3GPdPWtz5u4EzHahKBPeD/s+natUps7WDXeM/yF/8SA=;
        b=IqFh6xEiTe1BqMzaAwVxrd6IbhecG6GrNuBCDc/sBbvYi8Ew4es403Jaqcn+8idPBv
         YRu5j29I7dpx+SgnqkbG94ir9Q20c1OpQWupeisdcPA2++G+nCc5FgF+qgR7i5iWP8vj
         swbA3sGVktbx7hNayV2payVBxK3uVa7Hdv08PndFnH1ZQOnvxEVCUxGnA6lNibSbJTHS
         PhpLIXgMWUINPpHfzhpam9mKoinRAoRqe6eZR8ntkludpv7GXnkXtERoc4B4kMBUwwvP
         +/8wRnVjc7BRZhWbAgpZJP1satxAV4NZi81nDti5ZdWUkNLt8vrasLqq1dyLSdZwDn1D
         wHHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794122899; x=1794727699;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3GPdPWtz5u4EzHahKBPeD/s+natUps7WDXeM/yF/8SA=;
        b=maDOe/2zvvj4IJo3GdcwegTdbOazsykwAGK/rEsaG5/BviBXQuFkbDYRXwd2l4rfdF
         mZOiHcqSNgPhi1A0J6U4LV6ZHyiH7WvS2ycZ/Yb7JUL4HbCdvv5Lbau3xIrrJhU4apqj
         xgT+lqqxi7SfqGjzz/eOCH+BlRIX5Ekn8A8Rp7bKtOeKpqaQts4JS7ACrCzGoSPMihxo
         mSxRh8bR6/u/lfuWkEVrik6iZV184bgaDxwj/WYlRd2kR0+UBFXa6tPpu4n4We7CYKxT
         wlaw7KG7uBz+nQB86tXAd4Lz6FK3FRH/PR8wW5UQ9uASLjFWAtH9KhUyOnxetSHyrPbU
         Vsew==
X-Forwarded-Encrypted: i=1; AKwUvByJU87ikrlel7CkqIqG9e3NJx8PMGSSeNB81TcW6qFoTrMp8ONO4nAODNtoZ19lDgrewL0uuMjHnA==@kvack.org
X-Gm-Message-State: APuU4Z8mv8Mv6szNrKIgjwY6ptZ9stzodLWXDbH/x1m4NFouXbn3cGQd
	BQcQzNnGV8F2GGJq1EcqhclSs82/tyq31fVtLgqhLRDm2WdUMbe+C3i5TVETl6jNFGAuknsr/sS
	oP+Sl2l7IehLeYPd8Qqo7VvVy59OO1v7DRD3N2YRQbw==
X-Gm-Gg: AYBFou3Jc3zvuNftMXz4+fXMQfDLsYcO5rMM6S/D0O8d2gm8ok22nt/UycgzYt8g3JO
	91jttRPa3KfBPKSG6Y81LLjAhIw1gKlpLhrbAU/6UuBhUzAkMMf0h7gZl1tDJPkO+xd4qD59WeP
	KuBhFfIOeGy6+ELqMt93nWlWlldsPRP/t+bE5SlQKLVXBz4immgnsNAq1TbBM8gcvnlc66razr4
	ufWXayu8CFh26Gvv62fzglJMZuQmuezhrAkcWv4RDJ7VDkECw2vmwozDudzipWnhKqN7iI3dlw3
	PVp1ioPsqNaA4cyziDm0vY128Zjcu9E51OWMn/60/dp9MDkGM74qTZN3VOyHH+Gj0dvNUb/4mxD
	nyTrepQSZ/OJu2kuif7+zrkJkRnBFsV9qp7ExWxq1r6c=
X-Received: by 2002:a05:6830:4492:b0:816:a9dc:6d05 with SMTP id
 46e09a7af769-85f50450ebemr666748a34.4.1794122899111; Sat, 07 Nov 2026
 23:28:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260703122832.15984-1-cuiyunhui@bytedance.com>
 <20260703122832.15984-3-cuiyunhui@bytedance.com> <20260826010748.zphu3wh2hlm4t4o2@offworld>
In-Reply-To: <20260826010748.zphu3wh2hlm4t4o2@offworld>
From: yunhui cui <cuiyunhui@bytedance.com>
Date: Sun, 8 Nov 2026 15:28:07 +0800
X-Gm-Features: AclHuK_SNtR7Na4NEO8eC4WpcHN1PCPzaC_4JypevS8z-dbzdNtdoctuDfoYllw
Message-ID: <CAEEQ3wn2+coQyDz1+cvGRDsFZu8u0d--HTyxqSz2sxq1obZFHA@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v8 2/3] riscv: introduce percpu.h into include/asm
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, 
	dennis@kernel.org, tj@kernel.org, cl@gentwo.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, martin.lau@linux.dev, 
	eddyz87@gmail.com, memxor@gmail.com, song@kernel.org, yonghong.song@linux.dev, 
	jolsa@kernel.org, bjorn@kernel.org, pulehui@huawei.com, puranjay@kernel.org, 
	thuth@redhat.com, ajones@ventanamicro.com, ben.dooks@codethink.co.uk, 
	rkrcmar@ventanamicro.com, samuel.holland@sifive.com, zong.li@sifive.com, 
	conor.dooley@microchip.com, tglx@kernel.org, debug@rivosinc.com, 
	seanwascoding@gmail.com, andybnac@gmail.com, menglong8.dong@gmail.com, 
	cyrilbur@tenstorrent.com, wangruikang@iscas.ac.cn, atishp@rivosinc.com, 
	apatel@ventanamicro.com, linux-riscv@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, 
	arnd@arndb.de, nathan@kernel.org, nick.desaulniers+lkml@gmail.com, 
	morbo@google.com, justinstitt@google.com, qingfang.deng@siflower.com.cn, 
	linux-arch@vger.kernel.org, llvm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 3odtu9kxg4rzq5wsgsyqbm3txj8w1miy
X-Rspamd-Queue-Id: 5557640002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794122900-694415
X-HE-Meta: U2FsdGVkX1+QI/0fd6grSt7XZ3py1PyTFB/0vpE6f/7u7hqQjZV+6so1PNM6tzmtWJYXziRa37gD8slIlXuzizylg3ijNVstDxKnn+t+E1sdL2Nij6N4dfxcdlbfzT5ln0JlwyROOjuh5MIne9KrPP0wSkNCZzzsRaJzUXKpelB0+WXaHabwI6zVCihhkBoBpdbkJ2fCKsvPKvF7ZZ5Ia+u4KmRxuY1YKbu9d0e5KZSg0ac5masgzEFc+N7Ut48EA6kmztX+GF2ADKUPIHhcfHiJ3hfnEdV+oIhEq90auQmTiijY4P8q3nRi1zLV2ynZuawdRH+VJoQ1blNj2crIAddhKbgNyMeeQuhMSsqR3EB3K7t+DnZtJsBTTeJhFIgF9Lmy7LhW/ittGahvwfmniVB1nLkf6jCAxGW7oo4+VUb5ozmcoMGMpiuFYxS/UCYUGCLQNoQgqap2+h8uVZeAgkMTnu48jvek/n+vDbSS6odOwpNMfoOC599bHqQ6OPYITLOd4dgGaq7T0B2oVO4PRka0KPyROMtnP8qTW+qq1L9zLEvlEdVmzXMO4K2H1IB2GDbwkJwp4TpYIcAcl9b0ucSm/U5a5yLKvlP2g+s0y5gv3K1BKBSRgB5ZZ8kzxDkLkV9j7+u639gMyXelQ04O3BoBc4kckbQPnqLwmjmzKpPHStberMlOWQc1jQGGG0KMcZQIHan95eoQlkwak5WUVUFv3U+vDubkGr0yMcIudUg0hqG7D/3qJkyO5S8Aob82axe+M++LFLuo4YIFLw/Sn0ei2u3+CGyF8F9aXn4zzyoISkEvMtAIYEx71xDT19jOgS9Y7n0QPD/QuFkZN7mxEAm8PdELp3lM5gSj+7y5l5mzP9vcj8/iFQ1LuBgqPz3ZiNq2O6jGtWYSH3ltzubtyztN2jf4fX0tw15y5BXOCNHG8dpqQaJ8Gyt92z9aJ5BCUvPIOc4LWTLCQoF1RQX
 PNfZYivu
 rFAgm42w+y4x2OSWvNVjtsqw86DiSyciGpPdrgBYEGBqb5Pb36zMr5/SwNc/6W4xneu3P8liKLAGekA1wqqIMS9iXUeJcZEcGjFvUupD2MNJjsfoOmMymCm9wKVMvIBNkDb0gG4wVk9ZNqiL7aIV+FWrk3RMXX42PyIyNL3VXpK+fw4zpCu8QBkQLMDhqrM+sVaFjBgsT00/s3J3WWNU9Irzqo0pY9sOUFtYsGsZQHvPy3roBNwvitjIJv6FYmY14t/YnMsVYm/luvmeAc0mJlbCA1hUjtDBhjs+mzzd4gikxU/+gGVG7ML++6Quu04tD9EUr5PyPed9UPqWo038zZfXODdu2Zmcfio7LNYl4KIr1xWFQ0NTaVFwH3R7dTPnuwAnQ2TG4USCz45OzurXfoTFHtogvPlO8Z2zykEfq9q5h7JcvgUrfRCCkBEHR1ZDQNyCYt7yEH+osMOYGBa/kGM1KcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Davidlohr,

On Wed, Aug 26, 2026 at 9:08=E2=80=AFAM Davidlohr Bueso <dave@stgolabs.net>=
 wrote:
>
> On Fri, 03 Jul 2026, Yunhui Cui wrote:
>
> >Add RISC-V specific this_cpu helpers so common percpu operations can use
> >short architecture sequences instead of the generic implementation.
> >Native-width operations use AMOs, while 8/16-bit operations use Zabha wh=
en
> >available and a local 32-bit LR/SC fallback otherwise.
>
> The subject and changelog could use some improvement. How about:
>
> riscv: implement this_cpu operations

Agreed.

>
> riscv has no asm/percpu.h, so every this_cpu_*() read-modify-write
> takes the generic fallback, which disables local irqs.
>
> A single AMO is atomic with respect to interrupts on the local hart,
> so this can be replaced by one relaxed AMO under preemption disabled.
> Native-width operations use AMOs, while 8/16-bit operations use Zabha whe=
n
> available, or a local LR/SC sequence otherwise.
>
> Some comments below, but I ran this on my sifive p550, feel free to add m=
y:
>
> Tested-by: Davidlohr Bueso <dave@stgolabs.net>

Thanks for testing. I will add your Tested-by.

>
> >
> >Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
> >---
> > arch/riscv/include/asm/percpu.h | 296 ++++++++++++++++++++++++++++++++
> > 1 file changed, 296 insertions(+)
> > create mode 100644 arch/riscv/include/asm/percpu.h
> >
> >diff --git a/arch/riscv/include/asm/percpu.h b/arch/riscv/include/asm/pe=
rcpu.h
> >new file mode 100644
> >index 0000000000000..76b1b8c1fb953
> >--- /dev/null
> >+++ b/arch/riscv/include/asm/percpu.h
> >@@ -0,0 +1,296 @@
> >+/* SPDX-License-Identifier: GPL-2.0-or-later */
> >+
> >+#ifndef __ASM_PERCPU_H
> >+#define __ASM_PERCPU_H
> >+
> >+#include <linux/bits.h>
> >+#include <linux/preempt.h>
> >+
> >+#include <asm/alternative-macros.h>
> >+#include <asm/cmpxchg.h>
> >+#include <asm/cpufeature-macros.h>
> >+#include <asm/hwcap.h>
> >+
> >+#define PERCPU_RW_OPS(sz)                                             \
> >+static inline unsigned long __percpu_read_##sz(void *ptr)             \
> >+{                                                                     \
> >+      return READ_ONCE(*(u##sz *)ptr);                                \
> >+}                                                                     \
> >+                                                                      \
> >+static inline void __percpu_write_##sz(void *ptr, unsigned long val)  \
> >+{                                                                     \
> >+      WRITE_ONCE(*(u##sz *)ptr, (u##sz)val);                          \
> >+}
> >+
> >+PERCPU_RW_OPS(8)
> >+PERCPU_RW_OPS(16)
> >+PERCPU_RW_OPS(32)
> >+
> >+#ifdef CONFIG_64BIT
> >+PERCPU_RW_OPS(64)
> >+#endif
> >+
> >+#define __PERCPU_AMO_OP_CASE(sfx, name, sz, amo_insn)                 \
> >+static inline void                                                    \
> >+__percpu_##name##_amo_case_##sz(void *ptr, unsigned long val)         \
> >+{                                                                     \
> >+      asm volatile (                                                  \
> >+              "amo" #amo_insn #sfx " zero, %[val], %[ptr]"            \
>
> So afaict that rd=3Dzero could steer the AMO away from the hart, no? From=
 the
> Zaamo chapter, it notes that complex implementations "might also implemen=
t
> AMOs at memory controllers, and can optimize away fetching the original v=
alue
> when the destination is x0". Similar for the others (PERCPU_8_16_OP).
>
> Maybe use a tmp register instead and force the old value from L1 ("near")=
:

Agreed.

>
>         u##sz tmp;
>         asm volatile (
>                 "amo" #amo_insn #sfx " %[tmp], %[val], %[ptr]"
>                 : [ptr] "+A" (*(u##sz *)ptr), [tmp] "=3Dr" (tmp)
>                 : [val] "r" ((u##sz)(val)));
>
>
> ... which arm64 now does for its pcpu ops:
>
>         /*
>          * Use value-returning atomics for CPU-local ops as they are
>          * more likely to execute "near" to the CPU (e.g. in L1$).
>          *
>          * https://lore.kernel.org/r/e7d539ed-ced0-4b96-8ecd-048a5b803b85=
@paulmck-laptop
>          */
>
> >+              : [ptr] "+A" (*(u##sz *)ptr)                            \
> >+              : [val] "r" ((u##sz)(val))                              \
> >+              : "memory");                                            \
>
> Should not need this clobber either - these don't imply barriers (but you=
 also get
> them with the preemption disable/enable).
>

Agreed.

> >+}
> >+
>
> ...
>
> >+#define this_cpu_cmpxchg_1(pcp, o, n) _pcp_protect_return(cmpxchg_relax=
ed, pcp, o, n)
>
> This triggers that cmpxchg variable shadowing issue you mentioned in patc=
h 1 with
> that __cpu_fallback_try_cmpxchg also using '__old'.
>

Agreed. I will put arch_cmpxchg_relaxed() behind a typed __always_inline he=
lper.

> >+#define this_cpu_cmpxchg_2(pcp, o, n) _pcp_protect_return(cmpxchg_relax=
ed, pcp, o, n)
> >+#define this_cpu_cmpxchg_4(pcp, o, n) _pcp_protect_return(cmpxchg_relax=
ed, pcp, o, n)
> >+
> >+#ifdef CONFIG_64BIT
> >+#define this_cpu_cmpxchg_8(pcp, o, n) _pcp_protect_return(cmpxchg_relax=
ed, pcp, o, n)
> >+
> >+#define this_cpu_cmpxchg64(pcp, o, n) this_cpu_cmpxchg_8(pcp, o, n)
> >+#endif
> >+
> >+#ifdef system_has_cmpxchg128
> >+#define this_cpu_cmpxchg128(pcp, o, n)                                 =
       \
> >+({                                                                    \
> >+      u128 ret__;                                                     \
> >+      typeof(pcp) *ptr__;                                             \
> >+                                                                      \
> >+      preempt_disable_notrace();                                      \
> >+      ptr__ =3D raw_cpu_ptr(&(pcp));                                   =
 \
> >+      if (system_has_cmpxchg128())                                    \
> >+              ret__ =3D cmpxchg128_local(ptr__, (o), (n));             =
 \
> >+      else                                                            \
> >+              ret__ =3D this_cpu_generic_cmpxchg(pcp, (o), (n));       =
 \
> >+      preempt_enable_notrace();                                       \
> >+      ret__;                                                          \
> >+})
>
> With those above this_cpu_cmpxchg() you could now enable HAVE_CMPXCHG_LOC=
AL.
>

Yes, I will select it in a separate patch.

> Thanks,
> Davidlohr

Thanks,
Yunhui

