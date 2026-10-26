Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0BD606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m+uwSINy
Received: by kanga.kvack.org (Postfix)
	id 58C536B05BA; Mon, 26 Oct 2026 18:42:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53CA56B05BB; Mon, 26 Oct 2026 18:42:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453916B05BC; Mon, 26 Oct 2026 18:42:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0971E6B05BA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:42:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84ECC140841
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:42:53 +0000 (UTC)
X-FDA: 85366253826.14.81C268B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E54B7C0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:42:51 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=m+uwSINy;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793054571;
	b=KkmcnYnc2cie0tC+9+rczRjqsyoClLrZUYmczgaVV6+4wTVmGvr2Z712j4XxNemnhvNT5j
	5Mx4B1FyrLNzEYr66w8vNA7uBjjqPiYMK/+ViQV2VcCSRjVpLpVr5MKy/WvKxvUvjEE2ps
	KT27Qe4/adFNGx3ATQhNLz1nDiV5oqw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=fail ("headers rsa verify failed") header.d=kernel.org header.s=k20260515 header.b=m+uwSINy;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793054571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zcu2D4FJ8AUuSLc0io/ntAE/p7xplg+q76zeVM6cDrI=;
	b=MUrKUSq2mXABMWWZf9SkIt95c9iU89zHmFvlYRAVmm1WKvPFQaly6XLTShLuVrL9e1oIxY
	H7HRojkXODyIggrY/1OG73VaOm3cxFLqlDs0jUA30WfJypn4lyMp2MloI21zUBpMNDXb59
	Gzs+/5OhNnbmVC+aScWFz/zjOS1JTtk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4537C601EF;
	Mon, 26 Oct 2026 22:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365B01F01825;
	Mon, 26 Oct 2026 22:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793054571;
	bh=zcu2D4FJ8AUuSLc0io/ntAE/p7xplg+q76zeVM6cDrI=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=m+uwSINyQXwtu73UZ6EyuYN1h51rwPwU+wBhwQ3x6vmKi83kNfW/gfdRbFyu2HNka
	 7VReOVigciR9zgZA89RZbtbnvj5XXQ/G6TNtz4hWpZsN9YfowyTTvxcAd5CV23+dCo
	 kwOl5dmVClKxNRL9LoZLcTCJjd7Oi+GEyiutZ+FQrSiTq5KfDAS1cTn+Qetc1J45UA
	 tlo8YpMhi0rPJU2nlQprIjVkP6LSttyfZaSKzxm5CdW5t1SoWlXNdh7eay4cH9TrvB
	 dDcwGOzRtd1woJrWVPijYslHDOfGawLoQdVx6NOSD7HbBD401iC78cwGYI3UppwGB3
	 AB4oKffoYrJrg==
Content-Type: multipart/mixed; boundary="===============7206656739672881745=="
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Message-Id: <b9959bd7711dee7a83a07b012b5967980d178c95eae90adeebebcb6040fc526f@mail.kernel.org>
In-Reply-To: <20261026215226.3713941-7-jthoughton@google.com>
References: <20261026215226.3713941-7-jthoughton@google.com>
Subject: Re: [RFC PATCH 06/10] uaccess: Refuse and warn on user copies when current->mm is NULL
From: bot+bpf-ci@kernel.org
To: jthoughton@google.com,akpm@linux-foundation.org,viro@zeniv.linux.org.uk
Cc: tglx@kernel.org,peterz@infradead.org,kees@kernel.org,arnd@arndb.de,david@kernel.org,ljs@kernel.org,liam@infradead.org,vbabka@kernel.org,rppt@kernel.org,surenb@google.com,mhocko@suse.com,seanjc@google.com,pbonzini@redhat.com,jmattson@google.com,axboe@kernel.dk,asml.silence@gmail.com,James.Bottomley@HansenPartnership.com,mkp@kernel.org,dsterba@suse.com,mason@kernel.org,ast@kernel.org,daniel@iogearbox.net,john.fastabend@gmail.com,jpoimboe@kernel.org,rostedt@goodmis.org,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,mingo@redhat.com,acme@kernel.org,namhyung@kernel.org,linux-mm@kvack.org,linux-fsdevel@vger.kernel.org,kvm@vger.kernel.org,io-uring@vger.kernel.org,linux-scsi@vger.kernel.org,linux-btrfs@vger.kernel.org,bpf@vger.kernel.org,linux-trace-kernel@vger.kernel.org,linux-perf-users@vger.kernel.org,linux-kernel@vger.kernel.org,jthoughton@google.com,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,mason
 @kernel.
 org,ihor.solodrai@linux.dev
Date: Mon, 26 Oct 2026 22:42:50 +0000 (UTC)
X-Stat-Signature: u9nk3u76uwyn4pnima8yfognsmcoq95j
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E54B7C0003
X-Rspam-User: 
X-HE-Tag: 1793054571-991436
X-HE-Meta: U2FsdGVkX1/D7Gn/2UiBnvihlpBeDsmTUMtVXcNzWFVVhMroHrU4dwgTgbFCfTky8b9pQhv3Ebom0HLn/dmwpBeP4R+kjaJ+mHybCSEj9qY4f/09gQRiSKIgbJuerp0V0ventAzC1ymEXehjXJMsxzON7jkYDFaHOvgFOFK7cHY0L/Nl73FmKkMQPhKDNILi0Xf1Oq0TE0VMFZa5toMV4+YiwNBOV6T2c6wH4Ys2rhcGbQ56S7WetqDQOhwypsZD5677QcA+Pj0U1HqQ/i1o6gmshdWBR+oE725YENoeATFvm1/3HLETbqHOdS+LqG1EJ+a/jmoQL2iyQyCP3CKbPGQXLS7JwDPLFsj+VQ31zqQNnAffwCgSjwSSrla3u7LAmPBmTE5+KhUXFu5OH4vdqth6fksqkiTuXdaOiFicKeclRACu7VC35+c+zBAK0YEb4/lQixrpmvCllfOIJ6SHITgvKhYPAb9hjFvUmgx5Vkc6Lc08IukV6kjXuUsHZnUQEThef0rKIA1xmrHMbIHM/FU68yt57aKYu00CGB24jzIHOr0YcrFlQj1v5Z4o1unorEgeZ0Hi/UkenAeIzXGq53r8jGsCTQxoFa9FT69amYVgUgcax1T8k1Gh+dhxdL42AsneWWvdKO6nxTUy0jA0IDSI9ez/Dq1ODuENy33BviPQS6YZSs4Oz2ELTFHqWadQatKGMMk67vrfdEbOpAgcE5/gBmgIrQlIxDhE1v0okVPOMS+0bkMLZyWLNHKTo4JW3bioTdq4dTpZmbukWTm42KOVmLX+9JhLF8eAP1T1gc00Jriko8YKqUwjaq52PSn42HX7v7Wd7TY367aNKGcGuIYZf4GzwtC6hASgB1ZtMu59fnWP+yB1fZmFD3Dk89JrfvOweLT/TGMoXBdcS48pexcEbuee0/TEsVoisNjHU10P/VVvc+U5HBANBHMukgKKH2kIZMUpfO2CRHYl/JS
 5Pudx5BK
 4OxIKEaPvCHq5aBPT/hUTr/hzjVp61tHusTYrBtJ21bC8InDKKE69KMo/h7Pasjb/ibacB6zjsiU5QBu2pxYBesI4L9rW4u8v4fmkarjwJgJV1L5J1wq2eTX7BJw3dJXoq/+V8Th0sjzWBOHC919DHcd0GUjLHwDM5oCSKJQT+13aHwxpeUDU9vfHikoaKR/RSagAqUMrsnc/tnn16rqZe3/iYdnS8CWtN3Zn3jyM6bgmEnpezlygMZo6rLgdSlg80q0R9SUAzOgP9IzeUqz2KNxzpduEHOceQhcQtm77b7ZKHo1FgUVEAIt5W9YcHgf/ePcK8PxPKdY+EK+ImIEM/wfC3NaHv0lFT56m2jtoP2l8AxVlr/AOYA8DKS20p4yUDqgobJq4Wpi8N52gHMRLb9bGJph6ArmQBNulh/LejE6hBDD1apBZkkYOidQbCTkhq3OULFqdxizz6TIbWv8S6v3a4VPZ4tmjQNVY+AT8aIVGiXsw5uv28t6vJFJbAIMzclF7suppSy+3Nydm3NAk/xY+c8TbMx1FZCA8F9viPPjSitw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

--===============7206656739672881745==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> uaccess: Refuse and warn on user copies when current->mm is NULL

TL;DR:
- Possible spurious -EFAULT on valid kernel addresses on xtensa/nios2 from
  mm-less tasks (kworkers), e.g. d_path
- nofault helpers may hit the new WARN_ON_ONCE (BPF/tracing); fix is later in
  series, breaking bisection

> diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> index eddbbb65ccc4..e54a6d804bf9 100644
> --- a/include/linux/uaccess.h
> +++ b/include/linux/uaccess.h
> @@ -50,6 +50,23 @@

[ ... ]

> +static __always_inline bool uaccess_should_fail(void)
> +{
> +	if (WARN_ON_ONCE(!current->mm))
> +		return true;
> +	return should_fail_usercopy();
> +}

[ ... ]

> @@ -114,7 +131,7 @@ __copy_from_user(void *to, const void __user *from, unsigned long n)
>  
>  	might_fault();
>  	instrument_copy_from_user_before(to, from, n);
> -	if (should_fail_usercopy())
> +	if (uaccess_should_fail())
>  		return n;
>  	check_object_size(to, n, false);
>  	res = raw_copy_from_user(to, from, n);

Can this refuse legitimate kernel address copies on xtensa and nios2?

On both architectures __copy_from_user() and __copy_to_user() also sit under
the generic kernel nofault accessors.  Neither architecture defines
__get_kernel_nofault or arch_get_kernel_nofault, so both use the fallback in
include/linux/uaccess.h, which goes through __get_user()/__put_user() on the
kernel address:

    #define __get_kernel_nofault(dst, src, type, label)    \
    ...
            if (__get_user(data, p))                       \
                    goto label;                            \

On xtensa, 8-byte __get_user()/__put_user() are implemented with
__copy_from_user()/__copy_to_user() (arch/xtensa/include/asm/uaccess.h):

    case 8: {
            u64 __x;
            if (unlikely(__copy_from_user(&__x, ptr, 8))) {
    ...
            retval = __copy_to_user(ptr, &__v64, 8) ? -EFAULT : 0;

On nios2, __put_user_common() sends any size other than 1, 2 or 4 to
__copy_to_user().

Neither architecture selects HAVE_EFFICIENT_UNALIGNED_ACCESS, so
copy_from_kernel_nofault() and copy_to_kernel_nofault() (mm/maccess.c) use
the u64 loop whenever dst and src are both 8-byte aligned and at least 8
bytes remain:

    if (!(align & 7))
            copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);

With this patch, every such access from a task with current->mm == NULL
(kworkers, khungtaskd, kernel_init before exec, the idle task in IRQ, kgdb
entered from idle) hits WARN_ON_ONCE(!current->mm), and __copy_from_user()
returns n.  copy_from_kernel_nofault() then returns -EFAULT on valid kernel
memory.

Concrete generic callers include:

  d_path() -> prepend() -> prepend_copy() (fs/d_path.c) fills the component
  with 'x' and stops the walk.  This is reachable from LSM/IMA path hooks
  run by kworkers, for example async firmware loading.

  print_worker_info() (kernel/workqueue.c), called from
  dump_stack_print_info() and sched_show_task() for kworkers, which copies
  wq->name and worker->desc.

  copy_to_kernel_nofault() from kgdb_hex2mem()/kgdb_ebin2mem() on nios2,
  which selects HAVE_ARCH_KGDB.

Before this patch these accesses worked on kernel addresses, since
raw_copy_{from,to}_user() on these architectures is a plain fixup-protected
copy and access_ok() is not involved.  Only opt-in fault injection could
make them fail.

The commit message rationale ("Accessing user memory from a task that has no
mm is always a bug") does not apply to kernel addresses.  The commit message
also says get_user()/put_user() are not covered, which does not hold for
8-byte accesses on these two architectures.

No later commit in this series appears to touch these paths.

[ ... ]

> diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
> index 5bb752ff7c61..565b3125e752 100644
> --- a/lib/strncpy_from_user.c
> +++ b/lib/strncpy_from_user.c
> @@ -115,7 +115,7 @@ long strncpy_from_user(char *dst, const char __user *src, long count)
>  	unsigned long max_addr, src_addr;
>  
>  	might_fault();
> -	if (should_fail_usercopy())
> +	if (uaccess_should_fail())
>  		return -EFAULT;
>  	if (unlikely(count <= 0))
>  		return 0;

Can strncpy_from_user_nofault() now trip this WARN_ON_ONCE() from contexts
where current->mm is NULL by design?

In this tree strncpy_from_user_nofault() (mm/maccess.c) has no current->mm
check and no nmi_uaccess_okay() check.  It goes straight to
strncpy_from_user():

    pagefault_disable();
    ret = strncpy_from_user(dst, unsafe_addr, count);
    pagefault_enable();

and strncpy_from_user() now calls uaccess_should_fail(), which does:

    if (WARN_ON_ONCE(!current->mm))
            return true;

The callers of strncpy_from_user_nofault() are tracing helpers that run in
whatever context the probe fires in, including kernel threads and IRQs taken
while the idle task runs:

  bpf_probe_read_user_str() via bpf_probe_read_user_str_common()
  (kernel/trace/bpf_trace.c), and bpf_probe_read_str() for addresses below
  TASK_SIZE.

  bpf_trace_printk()/bpf_snprintf() through bpf_trace_copy_string()
  (kernel/bpf/helpers.c).  With CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
  (x86, arm64, ...), any '%s' argument below TASK_SIZE takes this path,
  including a NULL pointer.  So bpf_printk("%s", ptr) with ptr == NULL in a
  kprobe that fires in a kworker now triggers the warning.

  kprobe/fprobe/eprobe ustring fetch args (fetch_store_string_user() in
  kernel/trace/trace_probe_kernel.h).

  The .ustring event filters (test_ustring() in
  kernel/trace/trace_events_filter.c).

  Synthetic event string fields (trace_string() in
  kernel/trace/trace_events_synth.c).

  The bpf_copy_from_user_str_dynptr family (copy_user_str_nofault()).

Before this patch these calls either failed quietly with -EFAULT or read the
lazily loaded mm.  Now a tracing user (CAP_BPF plus CAP_PERFMON, or tracefs
access) can trigger a warning splat, and a panic with panic_on_warn, just by
tracing a function that kernel threads run.

The same applies to copy_to_user_iter_nofault() in lib/iov_iter.c, which this
patch also switches to uaccess_should_fail().  The commit message lists
copy_to_user_nofault() as intentionally covered, but it does not account for
the nofault helpers being used from mm-less contexts by design.

A fix appears later in the series, e8bf23b5b30d ("uaccess: Fail user nofault
helpers quietly when current->mm is NULL").  It adds an early !current->mm
return to copy_{from,to}_user_nofault(), strncpy_from_user_nofault() and
strnlen_user_nofault(), and switches copy_to_user_iter_nofault() back to
should_fail_usercopy().  Its message describes this exact problem
(bpf_probe_read_user_str() from a BPF program attached to a function called
by a kernel thread would now trip the WARN_ON_ONCE() in
strncpy_from_user()).

This commit on its own still introduces the regression, which breaks
bisection.  Could that fix be folded into this patch, or ordered before it?


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/40410166379
--===============7206656739672881745==--

