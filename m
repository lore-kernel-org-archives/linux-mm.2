Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9431560A2616
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=QzUhuz/y
Received: by kanga.kvack.org (Postfix)
	id 99C466B05B3; Mon, 26 Oct 2026 17:52:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94C736B05B2; Mon, 26 Oct 2026 17:52:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814EE6B05B5; Mon, 26 Oct 2026 17:52:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2D56B05B2
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:52:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2DD69804D5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:51 +0000 (UTC)
X-FDA: 85366127742.04.053D30D
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id 824F540005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:52:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="QzUhuz/y";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3r8vfagoKCCQJTHOUGHTONGOOGLE.COMLINUX-MMKVACK.ORG@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3r8vfagoKCCQJTHOUGHTONGOOGLE.COMLINUX-MMKVACK.ORG@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793051569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=nNWbrH52AzRslkHtbLVib7oaB3pAEHtIJlP9l4sYI30=;
	b=Z/5j3ChfmPWU/vz3L4kKJCUGYXRzB5ZvhrIw9sOR0hlKYgltJznHoy0rbeosnlb84Bj0U7
	nQTUBRJSmLuVwH66lYr8ISjsTLI8Ht9cWkT4r1K4wqj1O+FJcMGlX3ws3/bVuhNcHp/wsQ
	R8Qto94IIc0wDrRpS4/IZXbuQCeWYc8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="QzUhuz/y";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3r8vfagoKCCQJTHOUGHTONGOOGLE.COMLINUX-MMKVACK.ORG@flex--jthoughton.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3r8vfagoKCCQJTHOUGHTONGOOGLE.COMLINUX-MMKVACK.ORG@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793051569;
	b=FS+ODTMxj1LE+e5jgxxX5Rp5IIWY9u5pG1FvJJgGxmIkd9LWBoi1537jFByRz7/qe9AOX6
	zHI7A74ifMHy53PeFVnSxl+bw+VOXFob2IhsOXri8AYv5KM80E2ZXd4TOEx9icTdeQoU0g
	ndAEFfCTwuYt90YfQQhSHkUaTY/POlg=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3abfcf726dcso5158959a91.2
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 14:52:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793051568; x=1793656368; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nNWbrH52AzRslkHtbLVib7oaB3pAEHtIJlP9l4sYI30=;
        b=QzUhuz/yPthToq2sA2hwm0FNBcHrzDqrfIAg4Balx0CjThPgfxJoD81Rjt1YQowdMa
         hqEBH0t6Iq3lPlr8uCPDPtHqPGl0klYm2WQDueGJEshll9vwbWeN7QjNg1+aeWiGwAiR
         7O3h9sik7Aa7ojQ5mR87QCnOpdXkCqY0zqFyUsR1VFGNsYIfO7C/o0yCG3xOep2fqkSm
         aeTOSc4QUcGRpqW3BTRwGfpcaQnPUfZWQIr044AHpik3eraahi60nnMOr3I9j7qreRm2
         hp8gKJpg5qCIeOT7cZY7iNRA8hM1Q+dxD+AkOARjTp7f/cykhQ8lRYoZV/gwHTiZcjUK
         AXwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793051568; x=1793656368;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nNWbrH52AzRslkHtbLVib7oaB3pAEHtIJlP9l4sYI30=;
        b=Yp9dupFHBlo9l5/iROPbfMxFG5AK4geD/qVWGKcwq6v6sCLtQsqjWD/pJLevISr6Bj
         bqZ2NZtQ/eaMJJvixqTatPN6ALOWCu6/jKkV9J0Obuw5US3SaA4134PSgN35dqe5d2mO
         271Il+3IcOT8kWrpiz7Nf5POjWEo9KiEu3V7nmx9FvnUj1vWHcClvLBdgL1SEbeVJ1h0
         3JmSCLg0gdzRDn2Ix2gp2sFgt4KUYl/1VMzAPbsLRLx4ZiumAfO7KEsr/mly0oz0S7Oe
         8mXGbBBhgpE/3w8saP67okfG2DgKmzTiUOoooXWTGmO6Z/L+0UYUR8vdWtCGYHqSm0LS
         iHYw==
X-Forwarded-Encrypted: i=1; AKwUvBzM0/8Y3mVAAw676gViyJCMv72I/HgTkQbVA0iDHibzeeJNfUBhSwCFl6WR1s0rNgJTp4FIU1PQKg==@kvack.org
X-Gm-Message-State: AFq9FYJYpggfuW5aGaNyJo0WkCENWi1DsVaiz1R0xDdYWkbuJ4BSyW+F
	LseDiaAZj4/fdw9QyEZOkMjJP0fq2o+wxT8MBRCSb1hXss8ClzsFKUS3H77yKVgH6pB8TsqbauX
	4eHqGtqikoeG9HXgv7R5AsQ==
X-Received: from pjbfa12.prod.google.com ([2002:a17:90a:f0cc:b0:3ab:c012:2f80])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:280c:b0:3aa:ff19:42b8 with SMTP id 98e67ed59e1d1-3adead4792bmr6561021a91.27.1793051567868;
 Mon, 26 Oct 2026 14:52:47 -0700 (PDT)
Date: Mon, 26 Oct 2026 21:52:16 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026215226.3713941-1-jthoughton@google.com>
Subject: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
From: James Houghton <jthoughton@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <kees@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org, James Houghton <jthoughton@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 824F540005
X-Stat-Signature: n134q6j7gb6o6hq59pewucjyexffksnu
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793051569-417520
X-HE-Meta: U2FsdGVkX19PpgunDh4rD2dVGtJXMR1acEmf9yaeNUYm9YneAlaFgf2FkdGPCzKoYd55WYYoe4hpnpp8pNGmUB62WE0UQeq/GUdkDPPPHEyOCQb9WeDgrxtwBQWqM166ajGM3Mg3gZL91W4HWgIkCnL9OVvx1nQ2OSeBtYXUDozq+ziCAiyJzqo+oiT201meRIl18uClaW9zjhkuC/CIT4T2RhCTvcO9KLjMM+tJeYtn4gEdhuRuvgXtBVv8/qWGSYMZocH9e5QUwMCJVkZdF1iSbPZvYQzcKnq3bbx2giZuxNGaw5daToZVAWf392fZ7uPEOmEgcPtpXfX9dfE1h7yGeEffsyx7F4pdsYAVokzQ6AfDR79IMbkcovMiH/AaDFpM5xd1MmNwhfrUANdQA+fTwZzd/KR8QnZ1YjlA2ntu8Mhr91spLGvh62Oxq3KnirDWMVXvkh4DUmGddDrfmdc8rjC8wylkqB650IpQyp+3ufRfF6bWQv04J0YjywVKKlGk7v9HtIcmfDP18oA+bozMahE5EdwIgfB2Z2iMmBKjrpL/e5NQB2b4oVOOG6CBrfEypsgXokBWcg1f793NsnfhML2xY1eVB9xl5Fx9OLZnf/w90neHJeZNdM71SDZ3k7BR2py+S4Han7MDVgKXzm9fYOVhxLJ7Uvv8meDn6cq9Kb0NtMtFnMQR/QoZy/piJ6ScqM9yal4tzFAIapo3hy98QSH7L1OaYEIx4VxVHD2nbPTD+O+g9Clr/zJl9s4lVbMiWtv1z42lC46af3j98v7Jpq+Jjng3EvU8l7H5OAGpvnDjoqiHr9ENPeIhUviin1GdoiMM45vJT2Q5xLEgFz82Bj8yxUBiK673nrY9sjQ+CyRdQy6NNqhkrVKHUWHplya1rsRjYU34zMPzdwbY/mW3fKNSdSq7qpmoV1rM7eJZfOlBHGycLsMJjxuD7lrckEco5jsWjTjBsu3XFYx
 1HF0gE7J
 FDelSlaJvcHCd0k7w3W6au9tog/Ni6JgL4H6eiIgC1MC5KoCsDdRRVmiGUHwBEGtVqgUf98v6SOGrp4Jz1YXmHKuVGCL5SMODWwmpAKICHuvuYEUY6qeNQajgeP3SYEzWsuDI2ElJTGsL/9QK2HAux+4Ggm2ZOVrGigRI5mUsB/WplT2p3145KUO2MdTpHbO0RjuVoxGa2ZWgARcTmFDoYqzoQx/53Y1/pyYc1CwantpC4ywbR9TZFJXFoAXasEkQ3FR7UjRQKgQwtVbY0sS+ooXXSEMLDIbBCT70b3r1kFbQ0MRSkUFh/zjKEz6oaYj9Vahxe7XnJ7B9qonutGXuwMJubeFA2ZXm/qZby7m1AOvEFP8wGytXwR6Ip7Lw2nZAfwmKy9qtVSSrYapndEmn82ij3I2s2xwappYa5WewSvL2NvcQdc4FCA471osO72Sxm2wQ+/3yOz2s4uo2ij2aQznUFICgVNUNTzwJxq6zKScFRjbGwureY4GiuN92o4MtEemmfb7x+Wnjt+jnbQXlaStb6oGRxkeisWlvJl7js18+MgJbOC+amE+STQJLfOfx8YOG1u+YvDa7QK/SCbCUhvFPIJVOuFbitcllIgyecnc+h+RJs/3dr1qbPmLJ+k0EGcjOmzA3rm2uGXL5QAKF/OFjijKcR6QKlBR0DzgCO0pJfK0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi everyone,

This series comes out of a set of bugs that were found in KVM where the
kernel can sometimes write to a random process's user memory[1]. The KVM
fixes at [1] are still required, even with this uaccess series, as noted
by Sean here[2] and below in this cover letter. The beginning of this
series includes fixes for similar bugs found through static analysis
with Claude Opus 5.5. I don't think any of these bugs are more severe
than the KVM bugs[1].

We hit one of the KVM bugs in production, and it was challenging to
debug. This series makes such bugs, where the kernel is doing uaccess
without an mm, much more obvious.

The Cc list is wide because the fixes at the start of the series touch
several subsystems: SCSI (patch 1), btrfs (patch 2), BPF (patch 3),
tracing (patch 4) and perf (patch 5). They're included because the new
warning in patches 6-10 would otherwise fire on those paths. The core
uaccess change is in patches 6-10.

I have a reproducer only for patch 3 (a bpf_wq callback calling
bpf_copy_from_user(), which triggers the new WARN without the patch and
fails with -EFAULT with it); some details are in the notes section of
patch 3.

Patches 1, 2, 4 and 5 are only build-tested (plus syzkaller running on
the final kernel). Let me know if you'd like to see reproducers (or if
any of the patches are incorrect and should be dropped).

== Introduction ==

Accessing user memory from a task that has no mm is always a bug. This
can happen from a kernel thread that is not using kthread_use_mm(), or
from a task that has already gone through exit_mm(), e.g. when the last
reference to a file is dropped at exit and its release handler runs
from exit_task_work(). For example, KVM's nVMX code can write to guest
memory while a vCPU is being freed during VM destruction[1], and other
drivers may have similar bugs.

Such an access does not reliably fail. The user portion of the address
space belongs to whatever mm happens to be lazily loaded, if any. If
the access faults, the fault handler refuses to handle it and the copy
fails, but if the page is already mapped, the access silently reads or
writes another task's memory.

== Fixes ==

Patches 1-5 fix existing places that access current's user memory
without an mm:

 - Patches 1 and 2 fix io_uring passthrough completions in scsi_bsg and
   btrfs that copy to the submitter's user memory even when io_uring
   runs them canceled from a kworker, e.g. after the submitter exited.
   These are real bugs of the kind this series is meant to catch.

 - Patch 3 makes the sleepable BPF user copy helpers fail when
   current->mm is NULL, e.g. for bpf_wq callbacks or lsm.s programs
   running from kernel threads or exiting tasks.

 - Patches 4 and 5 make stack_trace_save_user() (ftrace's
   userstacktrace option) and get_perf_callchain() (bpf_get_task_stack()
   on the current task) use is_user_task(), so that they don't unwind
   the user stack of PID 1 before exec, usermode helpers before exec,
   or tasks that have gone through exit_mm().

== The New WARN ==

The rest of the series makes the generic uaccess helpers WARN_ON_ONCE()
and refuse the access when current->mm is NULL:

 - Patch 6 adds uaccess_should_fail(), which combines the existing
   should_fail_usercopy() fault injection check with the NULL mm check,
   and uses it in place of should_fail_usercopy(). This covers
   copy_{to,from}_user() on all architectures (including the masked
   user access paths, which never call access_ok()), the
   __copy_{to,from}_user() variants used by KVM's guest memory
   accessors, the user-backed iov_iter copy routines and
   strncpy_from_user().

 - Patch 7 makes the user nofault helpers fail quietly when
   current->mm is NULL. They are meant to be callable from any context
   (BPF, kprobes, perf), including from kernel threads, where failing
   is the expected outcome rather than a bug.

 - Patch 8 splits the NULL mm check out into uaccess_without_mm() and
   adds it to __copy_from_user_inatomic(), without also enabling fault
   injection there.

 - Patch 9 adds the check to the remaining generic paths: the scoped
   user access helpers, strnlen_user(), check_zeroed_user(), and the
   iov_iter routines that call into architecture-specific helpers.

 - Patch 10 is included for reference only. It moves the warning out of
   line, which removes ~16 KB of __bug_table growth on arm64 (where
   copy_{to,from}_user() are inlined), at the cost of warning only once
   system-wide and a slight size regression on x86_64. With defconfig +
   KVM, patches 6-9 grow vmlinux by +5,884 B (+0.014%) on x86_64 and
   +40,948 B (+0.10%) on arm64 without it, and by +9,714 B (+0.023%)
   and +24,609 B (+0.06%) with it.

The checks are deliberately limited to generic code. Accesses
implemented entirely by architectures (get_user(), put_user(),
clear_user(), and direct users of user_access_begin() or
masked_user_access_begin()) are not covered. Please let me know if the
new check should be placed elsewhere.

The check also cannot catch a valid mm that isn't the one the caller
expects, e.g. when a file's release or ioctl handlers run in a
different process than the one that created it. Code that keeps user
addresses belonging to a specific mm still has to compare current->mm
against that mm itself. For KVM, Sean's series[1] does exactly that for
guest memory accesses, and so complements this one: it handles the case
where the VM is destroyed from another process, which this series cannot
detect.

Without [1], the nVMX vCPU teardown path described there may trigger
the new warning when the last reference to a VM is dropped by an
exiting task or by the delayed fput kworker. The write to guest memory
is then refused, which is also what [1] does.

For example, running Jim Mattson's selftest for that bug[3] (adapted
slightly) on a kernel with this series but without [1] gives the
following warning, and the write to guest memory is refused. The warning
comes from uaccess_warn_without_mm() because patch 10 was applied;
without it, it points at the inlined copy helper in the caller instead.

  WARNING: lib/usercopy.c:31 at uaccess_warn_without_mm+0xa/0x12, CPU#2: vmx_shadow_vmcs/5299
  Call Trace:
   kvm_write_guest_offset_cached.cold+0xa/0xf
   __nested_vmx_vmexit+0x1974/0x3fd0
   nested_vmx_free_vcpu+0xb3/0xd0
   vmx_vcpu_free+0x96/0x350
   kvm_arch_vcpu_destroy+0x15c/0x400
   kvm_destroy_vcpus+0x270/0x3f0
   kvm_arch_destroy_vm+0xc7/0x230
   kvm_put_kvm+0x560/0xbf0
   kvm_vm_release+0x3c/0x50
   __fput+0x3f8/0xb50
   fput_close_sync+0x113/0x250
   filp_close_sync+0x75/0xa0
   put_files_struct+0x201/0x390
   exit_files+0x97/0xd0
   do_exit+0x872/0x2a00
   do_group_exit+0xd5/0x2a0
   __x64_sys_exit_group+0x3c/0x50

== Testing ==

Build-tested on x86_64 and arm64. Verified that the KVM reproducer hits
the new WARN, and that the BPF reproducer hits it without patch 3.

I'm also fuzzing this series with syzkaller on x86_64 (syzbot's
upstream KASAN config, nested VMX enabled), so far for about a day and
a half. syzkaller hasn't triggered the new warning yet, i.e. it hasn't
found any other path that accesses user memory without an mm. Fuzzing
is ongoing, and I'll report anything it finds in reply to this RFC.

Please let me know what you think. Thank you!

[1] https://lore.kernel.org/kvm/20261001202234.3794060-1-seanjc@google.com
[2] https://lore.kernel.org/kvm/aqMBidJ_96qroogH@google.com/
[3] https://lore.kernel.org/kvm/20260911191011.528460-1-jmattson@google.com/

James Houghton (10):
  scsi: bsg: Don't copy sense data to user memory when canceled
  btrfs: Don't copy encoded read data to user memory when canceled
  bpf: Fail sleepable user copy helpers when current->mm is NULL
  stacktrace: Don't unwind the user stack without an mm
  perf/core: Don't unwind the user stack without an mm
  uaccess: Refuse and warn on user copies when current->mm is NULL
  uaccess: Fail user nofault helpers quietly when current->mm is NULL
  uaccess: Refuse and warn on __copy_from_user_inatomic() without an mm
  uaccess: Refuse and warn on more user accesses without an mm
  uaccess: Move the NULL mm warning out of line

 drivers/scsi/scsi_bsg.c   | 10 +++++++-
 fs/btrfs/ioctl.c          | 10 ++++++++
 include/linux/uaccess.h   | 50 +++++++++++++++++++++++++++++++++++----
 kernel/bpf/helpers.c      | 11 +++++++--
 kernel/events/callchain.c | 12 ++++++----
 kernel/stacktrace.c       |  8 +++++--
 kernel/trace/bpf_trace.c  |  4 ++++
 lib/iov_iter.c            | 12 ++++++++--
 lib/strncpy_from_user.c   |  2 +-
 lib/strnlen_user.c        |  3 +++
 lib/usercopy.c            |  9 +++++++
 mm/maccess.c              | 17 +++++++++++++
 12 files changed, 131 insertions(+), 17 deletions(-)


base-commit: 2a08195e4db5aba84600db6518089a1dbe2d04c7
-- 
2.56.0.307.g5fe7bd680c-goog


