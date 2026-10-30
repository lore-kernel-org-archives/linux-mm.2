Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E3EA606A31D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 13:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=HCocDf7D
Received: by kanga.kvack.org (Postfix)
	id 4CA926B05B3; Fri, 30 Oct 2026 09:08:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A27B6B05B4; Fri, 30 Oct 2026 09:08:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B7E16B05B5; Fri, 30 Oct 2026 09:08:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0CBAA6B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 09:08:24 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 930C2120686
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:08:23 +0000 (UTC)
X-FDA: 85379321286.23.56EB050
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf15.hostedemail.com (Postfix) with ESMTP id AB5ABA000B
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:08:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HCocDf7D;
	spf=pass (imf15.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793365701;
	b=cxSzKAZfXxsIQxepkqSfPHpEVSgSdfA89FwGPou8HiwVfhsuVThrs4UVOfMDu8KKF0kTUk
	oDk2k7eGBoxhEBarh1/gJNwxVwvJC2oQ4GU7W57BCsCegTG+1wH2PuoIlIxox2bNfH6ODa
	EwgD8ts/JYF6dvuLqYrDi0wwvb56alM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=HCocDf7D;
	spf=pass (imf15.hostedemail.com: domain of olsajiri@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=olsajiri@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793365701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5G7E6riYr6Xp10O1BH1B3f0Y79ijgGFd9hQYIn0tKA=;
	b=rXe7K03wr3aN+2gIDd/W7oA+XynqFU824VLG4lOwEOrwRpzsawjzanD+W/uDYqSG4nPl2b
	k9c7DcOYOpUX0fMR4O6L6nrgGBCHqXiP75gFdwVtQpk+tX+aDbiucBwX0gesGKmOcn/tkp
	wz3H0tMGPRPDrARHZcmb8W7wQ5sKFGc=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso6227945e9.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:08:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793365700; x=1793970500; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e5G7E6riYr6Xp10O1BH1B3f0Y79ijgGFd9hQYIn0tKA=;
        b=HCocDf7DKpcf9bJ6ZjUnK0m6XVXVwT7CcYjFEWst8vE6fd0PuqvqKsnas7Qa6IBtL0
         IjYkQxMS/WrUAK4dzJu/rGLj3M7gbM94YYfamFlADQ5+/wpAQGC5dsJVlaS0qQQ8fW2A
         26rWbO6jk3Du0BfNZZTka8vFqQkdtE+MPDeI//TEmdhl2U9SBilAMNCwJ6y00sQdn7NC
         fjZXxmrUh34Kk6NDqbu7LRoROwj4Gvw6t7UHqyuFBL+jSZcdnhlI28+PTUI06E20MBOL
         me+YmbcB+vgpPXTzEXSYdsxW7KbFe52JoAJguU2yJ19iml/XTaCo8bnIHU19yqGEV02z
         8QWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793365700; x=1793970500;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e5G7E6riYr6Xp10O1BH1B3f0Y79ijgGFd9hQYIn0tKA=;
        b=BlP+yZ+R3Np+EsyhCLoSf6LsnX7eixrOXbVDFhMvDqgGgTiukXMFZFdxGkbRv+w119
         NdIeBr1TISMeWhhhSFYEf5R/ttHHE3hTVPfs+7PbKRKVbCJ74Gzq6j8LDaztFV6goUUl
         t/3SqAgP/5s/WV2bx8xYmrX6WVyFFvs9oNo+5KFO9AhEDboBZSom8XltegiNC6NaKO8G
         b2QpcCxAscUqwiHc3Kd34rJF9VyZwnEF7k0rvfTapL5x4rcYJmdFjUNTRQkUCFj3d/Zb
         72mDwaAiD7Zxw9P2RaKUS4jSY7UhN+TIWGemqnJamRFRYAXCV4C1aWyG8YjcW8etPxxS
         peZQ==
X-Forwarded-Encrypted: i=1; AKwUvBwKHLDTwdZQglf6dsJiXrgRj+Ee4HpH6k1QAibiURMeWe/kMdMAN+6QO9/ScdEjo1Pu6c09Y4cHPw==@kvack.org
X-Gm-Message-State: AFq9FYJZM5YEvLI65qk40cfFkkBRNFscABoRAPxO378I7tkMENEkQHKg
	62V2fS0uKHZ8gYRXzLHsu9WoBtHJioCfk8zvqhoJVun5ANtqV9Wrmdhx
X-Gm-Gg: AYBFou2yFW8tPosvqvL5+tcSIyDbx/+yHaUGu3ytyBTAuzlEbd6xFJW89sWtErp957F
	oKIQJqgF9HLmczajfgjMFHw7RDn5P8EtSoNHP41bJYqwsDPL+eERTiAeWePONPbxHoDwkXW8v+5
	Ni6P7IULyuIepK74vxDTxzB+RVfmXUqW/v9TeFDrZwH25n4GqnGXKcp+MxiSJXdvFwceR8rPUdl
	k+NKtGFdNiOA32wWZSoDU3IQDiJM8m7llgoSDfG02cZRW5d0NiXN+avJY8/nI8lqrXeGUXMB4Tn
	rShSov/1F6Van3sAc+XkSyj0gexc+DMhe5Uwlcz4BD3oLG8mYCjZEGYL+YOVsgIa2Jbs7Y6R3jO
	bnpEryjLINtkY3k6gbSw9PHn15jtL+kZPaJHKkeahzdhRJWVRAddFjUxBBWOgP6sa6vQishDkSO
	i+msJcZM1pyszgP1G4eZw3yftAB6dDfFR2FMcVTeOPQdkYAwrA/KPdlVKMfxMoBRoUxvhjJ2aie
	GCCIz4COkT72Gt7J3CgH10aETBRij9QG2g6Z5X7QQ+wTHzOyovxgK7zILxivm5PYT27VI4nKHPQ
	6Q==
X-Received: by 2002:a05:600c:6215:b0:4aa:1527:659 with SMTP id 5b1f17b1804b1-4ac17a366c0mr47584675e9.17.1793365700051;
        Fri, 30 Oct 2026 06:08:20 -0700 (PDT)
Received: from krava ([2a02:8308:a00c:e200::25dc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa80f04723sm155545595e9.5.2026.10.30.06.08.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 06:08:18 -0700 (PDT)
From: Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date: Fri, 30 Oct 2026 14:08:16 +0100
To: bot+bpf-ci@kernel.org
Cc: ast@kernel.org, daniel@iogearbox.net, bpf@vger.kernel.org,
	linux-mm@kvack.org, andrii@kernel.org, eddyz87@gmail.com,
	memxor@gmail.com, ljs@kernel.org, john.fastabend@gmail.com,
	nierro92@gmail.com, martin.lau@kernel.org, yonghong.song@linux.dev,
	mason@kernel.org, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next 2/8] bpf: Add user memory kfuncs
Message-ID: <auSWwHhZwhUbSVf1@krava>
References: <20261029212551.56964-3-jolsa@kernel.org>
 <571f32a410a85199bc9bcecfe07a9a9b6ef425b2052643e64031dd246c13691e@mail.kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <571f32a410a85199bc9bcecfe07a9a9b6ef425b2052643e64031dd246c13691e@mail.kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: AB5ABA000B
X-Stat-Signature: 9cgujutr71y84f7byws7grcc98ndnwop
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793365701-188736
X-HE-Meta: U2FsdGVkX1+osSQwpvPw+HHhSiyr1gD1sQZQLzPrpP81lXTotsOnVL2HsNK23cGxbLPBm6JzHIlr+Yy1Ciim1bikvZ9ik/bJr6eQxYgB/jAy1lDw9JoJpqpuyMSHILoE8qHdZTElTUEpAtOZpnYXmlPQ6ZQ+vBzyCWdzUxVIrCzS5GICHEfg18Lv50OyqKSOciwmk1CSB+Bq/WWLAztdFhE7syHHFiUSetDeIylWDEmCD2h7Ae/qshnN4mWYhD8prrmfmmNPxqvCNXLNyvN6C4LPR4bzuWbTXDq7dL02BoKxoLIfYpIaWdobAOyLqzOvFNlTOArVSmc8moEvVpaAWp1kSemUuqNyclNMbxC1+BfBdYvn/tRVnEKXgo+zpMZt9ACxRz3ESlxB+HFx7kI/9Ed4qKb+krqpgUjDok/fsRm1iaPoXKc2UDWmLGYF2eKQmw1mVqmcKUIIo8KvCoCRbnkbiKfUZXBT80JChkwZckcLfpPgknUrdxT6L3v7VugzuXcXicAsvMmZPcODoTTsWL+2G0XyV0SCgcs2R/foWQ68GnVNeOddpMB42n3ltFryrPqoxJg5B3Ys+F3xU0HDU6dgSeeO4Pyu/It9c/ADiKs9uG8BNcgaO42JTn/JO4Hekq+MDJg4rTTcRjy6yFoMu9LmLTqpO6hMno4QZveWavpG17QKAPoaACSaOmY8SAZhVfFunHigYleoCNLdS4NGeRS8d0fkbXhN0TAXKJoLApcBXRVyMjF5NP/NNOCM4iAlfvhdjl8He0s5BtchU5VT7q9e2936hfiSEPrQ7cHkhMuhBabNhmrEya09kQqpitxaOULC0d6UCbDJ16ipm82Wv/J5b617pn120CSiuPLBBokDBLGsurntl5vk3SWScHhdyIt1Sah0T17rCO5feZGKkroYWy0SJ2ysdurXrOtTEl7jjO6ypiiyNENrAKhOxrGKg5gGUy6iL99rfCsRlu7
 27e9EMoa
 QeNbFdxnig1mlvSdN4K3atswrfSZ73eYYTPg0egEUzz7rbr7j9qG2x9+moWNLiK5RiAIkugNsv0cwNwnK/owCN5WAyJhuD7UG/eN7r3FuFl4JlaSbToeu6hGqn+LrEyN24A4BZgMMGDf1I1p0j2qmdZpI1QKiofAbearOWFjeru7FVf3eiVv9iyNHrYUI47aVc1vZMtwsF/FJWpay/SmTh60bTzJqsd47NW7SJXSG2RUcuZGj4kOmO9XtJaV+GqCM0IwgAM/iaHTqLjoFxg/HmVhBe4mHdqEUqB5Sok818chslr6089YlM9G4CO5Jhg3wG3O44a+iD8iVwwEaO+YVLDiw2fP5zVJtVt46B78WNIKybnbAMPjvdevisdXf0ymNhAUAGShZzDRLfSYhLCrvxOBIN2oSjr+FFCJYsyGw/3P+XemwUzg0x2TLIFa8Rf7DbpZoJT5hdOycI/eFqQh6221/fDjoYIfHZ+z4ym8JUdTMe4s4TyFWIKZxbHf8kARO93bkrw/7XGMQSMauT/H7eFYpgpy0C5EN13NFG6ts/2k/BMsO2C0NaUI8E517O+CJ7Dj1P+uzCutL0bw62sjlqtEke1aMpzCV8mbFxvx883zZosZqZ0GP9dxaAZTXAZyH5CR7PumJdgHkui0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 10:12:12PM +0000, bot+bpf-ci@kernel.org wrote:

SNIP

> > +__bpf_kfunc unsigned long bpf_user_mmap(unsigned long len, unsigned long prot)
> > +{
> > +	if (!bpf_user_mm_ok())
> > +		return -EPERM;
> > +	return vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
> > +}
> 
> Can this vm_mmap() call fail for ia32 tasks, and for 64-bit tasks when
> CONFIG_X86_X32_ABI=y, because it is not made from a syscall?
> 
> On x86_64 the address picked by vm_mmap() depends on the bitness of the
> current syscall:
> 
> vm_mmap()
>   do_mmap()
>     __get_unmapped_area()
>       arch_get_unmapped_area_topdown()
>           info.high_limit = get_mmap_base(0);
> 
> arch/x86/mm/mmap.c:get_mmap_base() {
>     if (in_32bit_syscall()) {
>         return is_legacy ? mm->mmap_compat_legacy_base
>                          : mm->mmap_compat_base;
>     }
>     return is_legacy ? mm->mmap_legacy_base : mm->mmap_base;
> }
> 
> The sleepable kprobe programs that can call this kfunc run either from
> uprobe_notify_resume() -> handle_swbp() -> handler_chain() (or
> uprobe_prog_run()) on the int3 return-to-user path, or from bpf_task_work
> callbacks run by task_work_run().  TS_COMPAT is set only in
> syscall_32_enter() and is cleared on every return to user mode, so it is
> clear in all of these paths.
> 
> For an ia32 task (TIF_ADDR32) on a kernel without CONFIG_X86_X32_ABI, the
> top-down search therefore runs below the 64-bit mm->mmap_base.  Everything
> above 4GB is free in such a task, so the search returns an address above 4GB
> and __get_unmapped_area() rejects it:
> 
>     if (addr > TASK_SIZE - len)
>         return -ENOMEM;
> 
> The bottom-up legacy layout fails the same way, because find_start_end() also
> starts from get_mmap_base(1).  So the kfunc always returns -ENOMEM for ia32
> processes.
> 
> With CONFIG_X86_X32_ABI=y the result is the opposite.  Exception entry
> stores orig_ax = -1, so in_x32_syscall() is true in the uprobe handler and
> 64-bit processes get the compat (below 4GB) layout.  A large len then fails
> with -ENOMEM in the bottom-up fallback (end = task_size_32bit()) even though
> 64-bit address space is free.
> 
> The kernel documents this dependency in __set_personality_x32(): "The x86
> mmap() code relies on the syscall bitness so set x32 syscall bit right here
> to make in_32bit_syscall() work during exec()".  The uprobes XOL area avoids
> the problem by passing an explicit TASK_SIZE - PAGE_SIZE hint.
> 
> Neither the kernel-doc ("into the current process") nor the commit message
> mentions this limitation, and the selftests later in the series only exercise
> 64-bit binaries.  Should this limitation be handled or documented?

that might be a problem..  we could use similar workaround that's
used in arch_uprobe_get_xol_area and set TS_COMPAT before we call
vm_mmap and restore after (like below)

or we can always bail out for compat apps

jirka


---
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 4ca2ac8d372d..c9dbd38ca125 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -32,6 +32,9 @@
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/limits.h>
+#ifdef CONFIG_X86_64
+#include <asm/thread_info.h>
+#endif
 
 #include "../../lib/kstrtox.h"
 
@@ -3781,6 +3784,27 @@ static bool bpf_user_mm_ok(void)
 	return current->mm && !(current->flags & (PF_KTHREAD | PF_EXITING));
 }
 
+#ifdef CONFIG_X86_64
+static unsigned long bpf_user_vm_mmap(unsigned long len, unsigned long prot)
+{
+	struct thread_info *ti = current_thread_info();
+	bool compat = test_thread_flag(TIF_ADDR32);
+	unsigned long addr;
+
+	if (compat)
+		ti->status |= TS_COMPAT;
+	addr = vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
+	if (compat)
+		ti->status &= ~TS_COMPAT;
+	return addr;
+}
+#else
+static unsigned long bpf_user_vm_mmap(unsigned long len, unsigned long prot)
+{
+	return vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
+}
+#endif
+
 /**
  * bpf_user_mmap() - Map private anonymous memory into the current process
  * @len:  Length of the mapping
@@ -3797,7 +3821,7 @@ __bpf_kfunc unsigned long bpf_user_mmap(unsigned long len, unsigned long prot)
 {
 	if (!bpf_user_mm_ok())
 		return -EPERM;
-	return vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);
+	return bpf_user_vm_mmap(len, prot);
 }
 
 /**

