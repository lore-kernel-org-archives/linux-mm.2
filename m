Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B74BE606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=lieF4kI8
Received: by kanga.kvack.org (Postfix)
	id CDC4A6B05B3; Mon, 26 Oct 2026 19:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8B456B05B5; Mon, 26 Oct 2026 19:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7AEE6B05BA; Mon, 26 Oct 2026 19:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 881336B05B3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:41:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BE5816084F
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:41:59 +0000 (UTC)
X-FDA: 85366402758.20.18C8148
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf31.hostedemail.com (Postfix) with ESMTP id 05DA120002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:41:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lieF4kI8;
	spf=pass (imf31.hostedemail.com: domain of 3Q-XfagoKCOoVfTagSTfaZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3Q-XfagoKCOoVfTagSTfaZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793058117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpV2CXxIZjHnFgwnEW1Our7mkEl1DYiqfIv6pgFa/1c=;
	b=YtmgsSoQRjt/qexyF06i1sEHf6vNipuZTAoCBe5teUwoX9OZIn8iqzOhM91tCZUcqDLI7B
	Y5eMhybsJMgJ5/bw3jEB32rV5RFS5HHyxurhIAy3BEP2KwDZCGkOveX+nA1r95U1dpztiC
	4FHwmR5TA1rs+JZFo71tqUIjp4fTiYQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lieF4kI8;
	spf=pass (imf31.hostedemail.com: domain of 3Q-XfagoKCOoVfTagSTfaZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jthoughton.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3Q-XfagoKCOoVfTagSTfaZSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--jthoughton.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793058117;
	b=DPNTqrDNNjyXjDU1WbdP3AZE8LW8GfUemH6YaDTATXcBf+vvGfXLyHUKCl467Wtbx08oR2
	5IXwoLy+Z6AZyoGilfqG34zyxehUfDYE73iRsHsTnITFrmqmx2vNADBJG3KZXjFymawGlM
	LSsIBlzIVGdjeaezFUWv01E/zg3xUVc=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-3ade5b3ae97so277173a91.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793058116; x=1793662916; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=OpV2CXxIZjHnFgwnEW1Our7mkEl1DYiqfIv6pgFa/1c=;
        b=lieF4kI8+22z3SSjBpx/47N10x1tq0n9+NMk1mLTR0BUMrUSpiulc07AftJthraLiX
         5CGdDKtwve4ORSsJiug4g9f8i7hYVlAVtwTeOyhxZDC1xRyBtFFsRrx5a4kTOq/KHc0/
         +2TbKbmUMDmMHaEFsb0U4OqnBx24kKnpuxPrHaMz+BGKOGCzg81wCQFLcRV1cRiUDDm8
         wfz0IBpZAqxLAwMgFVygizI9QdOwrvkzlxBE0rP1XFPZvAVinN+IehYs7jCXDZvJhKqH
         ONZycV68/t/TtAlCxraHl7ercHkTxG5UbuhQX3RnafQXXDIZwXfS6boV7kdgSUMKfG9U
         tSUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793058116; x=1793662916;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OpV2CXxIZjHnFgwnEW1Our7mkEl1DYiqfIv6pgFa/1c=;
        b=wXhSffhGobWgAJ664ncIdTuNkzKh8+HTi7S682CcSJT8wz2QhIoBC32Utd4nyV6l+G
         d95BhByvINOAJwAdC1RUape6tEcYW25DZ7akM6gKnN3IiW6C3iYpvUJqoFZqfFddtG3V
         TulUD3T6PUZu2oPUoRgjPCNAeFgXe2aNGi/IdX5f2zWcHRfaq75KhPyUJbz9iTMMRIcA
         zZmB13vwOQ2kaXCZztd3YiksjUa8N1cNQ3/7yFVWgj/JqMjEuzyLtj8It2BnRX7BAng/
         T/Oi9qmNnxBYgizc+7acxOfOBJfMyWOPjWwGfHGiqv258v19Tmt+s5RIbzV6Da1fJlFq
         AoAw==
X-Forwarded-Encrypted: i=1; AKwUvBwhTB8k2jAhcm0a6OvKcBcsgWzcnSoBWcJx2KMviW2IwaGHo+qKFg0glzob+yjMIjni4tJmKmt+rQ==@kvack.org
X-Gm-Message-State: AFq9FYIBhQkz/ocZSfGo8lTtcq2fL7LH/RbhishnbIf15/Com+qSbq6U
	A6K+RWSLElnB42TviGIMPQx9B/pGE9EWd9Nm3rKjAWqkfDBhvJ0ujDitzpq0M9IZMCkibx+QyIE
	UdHeC1W48vLdP5S/E3e98kQ==
X-Received: from plso3.prod.google.com ([2002:a17:902:bcc3:b0:2e9:4eb5:953d])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d60c:b0:3ac:b764:8521 with SMTP id 98e67ed59e1d1-3ae4041abb8mr609334a91.38.1793058115737;
 Mon, 26 Oct 2026 16:41:55 -0700 (PDT)
Date: Mon, 26 Oct 2026 23:41:54 +0000
In-Reply-To: <b9959bd7711dee7a83a07b012b5967980d178c95eae90adeebebcb6040fc526f@mail.kernel.org>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <b9959bd7711dee7a83a07b012b5967980d178c95eae90adeebebcb6040fc526f@mail.kernel.org>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026234155.4028467-1-jthoughton@google.com>
Subject: Re: [RFC PATCH 06/10] uaccess: Refuse and warn on user copies when
 current->mm is NULL
From: James Houghton <jthoughton@google.com>
To: bot+bpf-ci@kernel.org
Cc: James.Bottomley@HansenPartnership.com, acme@kernel.org, 
	akpm@linux-foundation.org, andrii@kernel.org, arnd@arndb.de, 
	asml.silence@gmail.com, ast@kernel.org, axboe@kernel.dk, bpf@vger.kernel.org, 
	daniel@iogearbox.net, david@kernel.org, dsterba@suse.com, eddyz87@gmail.com, 
	ihor.solodrai@linux.dev, io-uring@vger.kernel.org, jmattson@google.com, 
	john.fastabend@gmail.com, jpoimboe@kernel.org, jthoughton@google.com, 
	kees@kernel.org, kvm@vger.kernel.org, liam@infradead.org, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ljs@kernel.org, martin.lau@kernel.org, 
	mason@kernel.org, mathieu.desnoyers@efficios.com, mhiramat@kernel.org, 
	mhocko@suse.com, mingo@redhat.com, mkp@kernel.org, namhyung@kernel.org, 
	pbonzini@redhat.com, peterz@infradead.org, rostedt@goodmis.org, 
	rppt@kernel.org, seanjc@google.com, surenb@google.com, tglx@kernel.org, 
	vbabka@kernel.org, viro@zeniv.linux.org.uk, yonghong.song@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 05DA120002
X-Stat-Signature: 349bge38k8hhajpa6tycz7qyrmcda956
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793058117-273694
X-HE-Meta: U2FsdGVkX19SdC+Vauf6POffeFgWH41T8FiNbSAsA9b/PfXvegVvMmjx5GSkWIpQDnYuAE0+lcK5wqmKJ1/imSqjTXSZJRx/4GLOBMvKJFzgp1/B2OBKHKDIYaQLL+LDuHR/H686DNx7bCCyPG1nQuUARyeKWcn8ei0bU8EdSnjZIr48BJdMo6JnRheaLaMRkgJY9KhnytNtIckht/ozwYdYQsrJ5eXLCXfUitbl08O4akdV5gevO3lTlnUSUHN0acs1WQjHE78x8SWrEsMsuQTXrE+iZeeLKJe70fmFl70yqUUFjsmwZDnrMH3RU17wqsogI++HFZFTRkmgQMri8GieDSNQxnNXhYGfp/V68FTM5nIt0MxQWpWF9Fidipf6kIQWLT4Wj7YGYIz4h4gGrZZp1iuxg0kwRRdC3l12Ym273cv2ZgMIlAwlzjv7r9vtHOCnrjNjXkd14VmxMiEH5Cez7Y5ix5SzGNe5pUycXwiSUIk0yX67N1O5bD7pIMV3W5m2+/qq87sG++hoTsJWUnM+zHH7qASGwuvGryUajl+3OkKpRYhclHy/Z2hJT5xVJAiO0zZdaeguT1xuMrvMGKtUfTr7+eZkbgzlTPlPpHD+v7b3pDcNDaGHqzUbH+SjnVAVZFR4vFnLXwWU05GjI5+DMulWML4xgZhLACCTfPQhLOdGNSJ4e/gAarsgbmUZdKgd9Q7yKcWU1ki0cZ3QDwBgqI1PMMVEg+97S0toGTJn9UjE89MpD/6CraS7R/akYo90EjoBUHyM5MGh9nTV+qv+/oP8LFfeRL7pHGlTs63eP067x9gV7TOZeflX+M6U49J8qve6tocMZYW7w1PQbmoziLnXxXfThv7tpD9RmHWZULrohKNNVa0/xmvlJYMffyPgTnephFTWWS9cH+vIjua82mJZ5QOgATRk0tCn9+4ahD5iDRx5v++ylnMY+sBRJcGVhhhKqqCCWdRaTjT
 kcPdXoGO
 ZqbbyhGpJn/pQKrFG+1Qq8/Zo6l6vXwzy8Q/jERtMFsZvnFLMrQ2w966YzNI3465e6SC92XSsbndh6cdb+ges3ubYi8qbumejqjJVtDNDIPLDBbQIXGPrmoEFtGVSvrCaF5yBLNgK2MxLFR05TMektQuzDjZlN3EVHsmnmBRSy0ahCXPag7VS4VPF6jlNYC8fWogPMNNULnl7UFX5rTFwtBesBASJD9jIhDD8Ok9PbOFw5w72kXlGsIfZ909oirncIUkRjqs0uLzytkz8XiAgS8vdqYPbHL4TxEx0SBpKjCuwb2dn4TTTuzkqcIom5x3AMLtwMCdatNNGpYxga6kBhgVfxecOOajpaV6W4GKRK4ug7Cjbn16CvTbsxVR26Rz+FzPAtQe5BbENYOXf4HiyUVRO9GixS7UUaW3C3LhG+gnwpZSOzb/IfY/xx/oTD4TIpD7jhHnI9CDsejZQ6UD8/t49M5KWCkoS2nQ6HuUNkiqZrUELGMfxI1b68gVsuFpza16y3XmXeaqJfBSg/di0LYlflyZ6uLJGIEQqvw+CVBVKmwxqJpIk7ysaADO5RdsJ9NmLoMbOO3gXpIOciDZErIDZTn+ZWmBd2w4XUcmqLRNdDW/yL6+FeuS1HyHtK4xRdKDVvz//YokdadqpEYOWVZws/FDEA+3qDgCZaWKTP73Ngb5M2dASEiOXrJvcvRRgL3XdYYGJhzgrFJoIA5VEh+hUaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 3:42=E2=80=AFPM <bot+bpf-ci@kernel.org> wrote:
>
> > uaccess: Refuse and warn on user copies when current->mm is NULL
>
> TL;DR:
> - Possible spurious -EFAULT on valid kernel addresses on xtensa/nios2 fro=
m
>   mm-less tasks (kworkers), e.g. d_path
> - nofault helpers may hit the new WARN_ON_ONCE (BPF/tracing); fix is late=
r in
>   series, breaking bisection
>
> > diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
> > index eddbbb65ccc4..e54a6d804bf9 100644
> > --- a/include/linux/uaccess.h
> > +++ b/include/linux/uaccess.h
> > @@ -50,6 +50,23 @@
>
> [ ... ]
>
> > +static __always_inline bool uaccess_should_fail(void)
> > +{
> > +     if (WARN_ON_ONCE(!current->mm))
> > +             return true;
> > +     return should_fail_usercopy();
> > +}
>
> [ ... ]
>
> > @@ -114,7 +131,7 @@ __copy_from_user(void *to, const void __user *from,=
 unsigned long n)
> >
> >       might_fault();
> >       instrument_copy_from_user_before(to, from, n);
> > -     if (should_fail_usercopy())
> > +     if (uaccess_should_fail())
> >               return n;
> >       check_object_size(to, n, false);
> >       res =3D raw_copy_from_user(to, from, n);
>
> Can this refuse legitimate kernel address copies on xtensa and nios2?
>
> On both architectures __copy_from_user() and __copy_to_user() also sit un=
der
> the generic kernel nofault accessors.  Neither architecture defines
> __get_kernel_nofault or arch_get_kernel_nofault, so both use the fallback=
 in
> include/linux/uaccess.h, which goes through __get_user()/__put_user() on =
the
> kernel address:
>
>     #define __get_kernel_nofault(dst, src, type, label)    \
>     ...
>             if (__get_user(data, p))                       \
>                     goto label;                            \
>
> On xtensa, 8-byte __get_user()/__put_user() are implemented with
> __copy_from_user()/__copy_to_user() (arch/xtensa/include/asm/uaccess.h):
>
>     case 8: {
>             u64 __x;
>             if (unlikely(__copy_from_user(&__x, ptr, 8))) {
>     ...
>             retval =3D __copy_to_user(ptr, &__v64, 8) ? -EFAULT : 0;
>
> On nios2, __put_user_common() sends any size other than 1, 2 or 4 to
> __copy_to_user().
>
> Neither architecture selects HAVE_EFFICIENT_UNALIGNED_ACCESS, so
> copy_from_kernel_nofault() and copy_to_kernel_nofault() (mm/maccess.c) us=
e
> the u64 loop whenever dst and src are both 8-byte aligned and at least 8
> bytes remain:
>
>     if (!(align & 7))
>             copy_from_kernel_nofault_loop(dst, src, size, u64, Efault);
>
> With this patch, every such access from a task with current->mm =3D=3D NU=
LL
> (kworkers, khungtaskd, kernel_init before exec, the idle task in IRQ, kgd=
b
> entered from idle) hits WARN_ON_ONCE(!current->mm), and __copy_from_user(=
)
> returns n.  copy_from_kernel_nofault() then returns -EFAULT on valid kern=
el
> memory.
>
> Concrete generic callers include:
>
>   d_path() -> prepend() -> prepend_copy() (fs/d_path.c) fills the compone=
nt
>   with 'x' and stops the walk.  This is reachable from LSM/IMA path hooks
>   run by kworkers, for example async firmware loading.
>
>   print_worker_info() (kernel/workqueue.c), called from
>   dump_stack_print_info() and sched_show_task() for kworkers, which copie=
s
>   wq->name and worker->desc.
>
>   copy_to_kernel_nofault() from kgdb_hex2mem()/kgdb_ebin2mem() on nios2,
>   which selects HAVE_ARCH_KGDB.
>
> Before this patch these accesses worked on kernel addresses, since
> raw_copy_{from,to}_user() on these architectures is a plain fixup-protect=
ed
> copy and access_ok() is not involved.  Only opt-in fault injection could
> make them fail.
>
> The commit message rationale ("Accessing user memory from a task that has=
 no
> mm is always a bug") does not apply to kernel addresses.  The commit mess=
age
> also says get_user()/put_user() are not covered, which does not hold for
> 8-byte accesses on these two architectures.
>
> No later commit in this series appears to touch these paths.

This analysis is correct. Implementing copy-from-kernel functions with call=
s to
uaccess functions is a little hard to make sense of. :/

I've included a patch at the front of my v2 for xtensa and nios2. I don't t=
hink
any other architecture has this problem. I've placed the patch at the botto=
m of
this reply. I've also adjusted the wording for patch 6.

>
> [ ... ]
>
> > diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
> > index 5bb752ff7c61..565b3125e752 100644
> > --- a/lib/strncpy_from_user.c
> > +++ b/lib/strncpy_from_user.c
> > @@ -115,7 +115,7 @@ long strncpy_from_user(char *dst, const char __user=
 *src, long count)
> >       unsigned long max_addr, src_addr;
> >
> >       might_fault();
> > -     if (should_fail_usercopy())
> > +     if (uaccess_should_fail())
> >               return -EFAULT;
> >       if (unlikely(count <=3D 0))
> >               return 0;
>
> Can strncpy_from_user_nofault() now trip this WARN_ON_ONCE() from context=
s
> where current->mm is NULL by design?
>
> In this tree strncpy_from_user_nofault() (mm/maccess.c) has no current->m=
m
> check and no nmi_uaccess_okay() check.  It goes straight to
> strncpy_from_user():
>
>     pagefault_disable();
>     ret =3D strncpy_from_user(dst, unsafe_addr, count);
>     pagefault_enable();
>
> and strncpy_from_user() now calls uaccess_should_fail(), which does:
>
>     if (WARN_ON_ONCE(!current->mm))
>             return true;
>
> The callers of strncpy_from_user_nofault() are tracing helpers that run i=
n
> whatever context the probe fires in, including kernel threads and IRQs ta=
ken
> while the idle task runs:
>
>   bpf_probe_read_user_str() via bpf_probe_read_user_str_common()
>   (kernel/trace/bpf_trace.c), and bpf_probe_read_str() for addresses belo=
w
>   TASK_SIZE.
>
>   bpf_trace_printk()/bpf_snprintf() through bpf_trace_copy_string()
>   (kernel/bpf/helpers.c).  With CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_S=
PACE
>   (x86, arm64, ...), any '%s' argument below TASK_SIZE takes this path,
>   including a NULL pointer.  So bpf_printk("%s", ptr) with ptr =3D=3D NUL=
L in a
>   kprobe that fires in a kworker now triggers the warning.
>
>   kprobe/fprobe/eprobe ustring fetch args (fetch_store_string_user() in
>   kernel/trace/trace_probe_kernel.h).
>
>   The .ustring event filters (test_ustring() in
>   kernel/trace/trace_events_filter.c).
>
>   Synthetic event string fields (trace_string() in
>   kernel/trace/trace_events_synth.c).
>
>   The bpf_copy_from_user_str_dynptr family (copy_user_str_nofault()).
>
> Before this patch these calls either failed quietly with -EFAULT or read =
the
> lazily loaded mm.  Now a tracing user (CAP_BPF plus CAP_PERFMON, or trace=
fs
> access) can trigger a warning splat, and a panic with panic_on_warn, just=
 by
> tracing a function that kernel threads run.
>
> The same applies to copy_to_user_iter_nofault() in lib/iov_iter.c, which =
this
> patch also switches to uaccess_should_fail().  The commit message lists
> copy_to_user_nofault() as intentionally covered, but it does not account =
for
> the nofault helpers being used from mm-less contexts by design.
>
> A fix appears later in the series, e8bf23b5b30d ("uaccess: Fail user nofa=
ult
> helpers quietly when current->mm is NULL").  It adds an early !current->m=
m
> return to copy_{from,to}_user_nofault(), strncpy_from_user_nofault() and
> strnlen_user_nofault(), and switches copy_to_user_iter_nofault() back to
> should_fail_usercopy().  Its message describes this exact problem
> (bpf_probe_read_user_str() from a BPF program attached to a function call=
ed
> by a kernel thread would now trip the WARN_ON_ONCE() in
> strncpy_from_user()).
>
> This commit on its own still introduces the regression, which breaks
> bisection.  Could that fix be folded into this patch, or ordered before i=
t?

Ah, yes. I'll flip the order of patch 6 and 7 in the v2. Thanks.

Okay, the xtensa/nios2 patch is here:

-------

    xtensa, nios2: Don't use __copy_{from,to}_user() in __{get,put}_user()
   =20
    Architectures that don't define __get_kernel_nofault() or
    arch_get_kernel_nofault() use the generic fallback in
    include/linux/uaccess.h, which accesses *kernel* addresses with
    __get_user() and __put_user(). That relies on __get_user() and
    __put_user() being raw accessors, i.e. plain fixup-protected loads and
    stores with no extra checks that only make sense for user memory.
   =20
    xtensa and nios2 use this fallback, but don't quite meet that: on
    xtensa, 8-byte __get_user() and __put_user() are implemented with
    __copy_from_user() and __copy_to_user(), and on nios2, __put_user() of
    any size other than 1, 2 or 4 bytes (i.e. 8-byte puts) uses
    __copy_to_user(). __copy_{from,to}_user() do more than a plain copy: th=
ey
    inject failures with CONFIG_FAULT_INJECTION_USERCOPY, check the kernel
    object size with CONFIG_HARDENED_USERCOPY, and, with a later patch in
    this series, refuse and warn on user accesses when current->mm is NULL.
   =20
    As neither architecture selects HAVE_EFFICIENT_UNALIGNED_ACCESS,
    copy_from_kernel_nofault() and copy_to_kernel_nofault() use 8-byte
    accesses when both pointers are 8-byte aligned, so kernel nofault
    accesses (used e.g. by d_path() and print_worker_info()) end up in
    __copy_{from,to}_user() on kernel addresses. With the NULL mm check,
    copy_from_kernel_nofault() would then fail on valid kernel memory when
    called from kernel threads.
   =20
    Use raw_copy_{from,to}_user() instead, as asm-generic's
    __get_user_fn()/__put_user_fn() do, and as nios2 already does for 8-byt=
e
    gets (__get_user_8()). This only drops the extra checks and KASAN/KCSAN
    instrumentation for 8-byte accesses, making them consistent with the 1,
    2 and 4-byte cases, which are plain inline asm.
   =20
    The fallback itself is fine and is still needed: it's used by alpha,
    arc, csky, hexagon, microblaze, nios2, openrisc, sh, sparc and xtensa.
    Of those, only xtensa and nios2 have __get_user()/__put_user() that
    aren't raw. The others use either asm-generic's, which call
    raw_copy_{from,to}_user(), or inline asm for all sizes. The remaining
    architectures (arm, arm64, loongarch, m68k, mips, parisc, powerpc,
    riscv, s390, um and x86) define their own __get_kernel_nofault() or
    arch_get_kernel_nofault(), which don't use __get_user()/__put_user() or
    __copy_{from,to}_user().

    Signed-off-by: James Houghton <jthoughton@google.com>
   =20
diff --git a/arch/nios2/include/asm/uaccess.h b/arch/nios2/include/asm/uacc=
ess.h
index 5e6e05cc6efc..f20f11bd21dc 100644
--- a/arch/nios2/include/asm/uaccess.h
+++ b/arch/nios2/include/asm/uaccess.h
@@ -161,7 +161,7 @@ do {									\
 	default:							\
 		/* XXX: This looks wrong... */				\
 		__pu_err =3D 0;						\
-		if (__copy_to_user(__pu_ptr, &(__pu_val),		\
+		if (raw_copy_to_user(__pu_ptr, &(__pu_val),		\
 			sizeof(*__pu_ptr)))				\
 			__pu_err =3D -EFAULT;				\
 		break;							\
diff --git a/arch/xtensa/include/asm/uaccess.h b/arch/xtensa/include/asm/ua=
ccess.h
index 6538a29a2bbd..30c8805d1c83 100644
--- a/arch/xtensa/include/asm/uaccess.h
+++ b/arch/xtensa/include/asm/uaccess.h
@@ -76,7 +76,7 @@ do {									\
 	case 4: __put_user_asm(x, ptr, retval, 4, "s32i", __cb); break;	\
 	case 8: {							\
 		     __typeof__(*ptr) __v64 =3D x;			\
-		     retval =3D __copy_to_user(ptr, &__v64, 8) ? -EFAULT : 0;	\
+		     retval =3D raw_copy_to_user(ptr, &__v64, 8) ? -EFAULT : 0;	\
 		     break;						\
 	        }							\
 	default: __put_user_bad();					\
@@ -176,7 +176,7 @@ do {									\
 	case 4: __get_user_asm(x, ptr, retval, 4, "l32i", __cb);  break;\
 	case 8: {							\
 		u64 __x;						\
-		if (unlikely(__copy_from_user(&__x, ptr, 8))) {		\
+		if (unlikely(raw_copy_from_user(&__x, ptr, 8))) {	\
 			retval =3D -EFAULT;				\
 			(x) =3D (__typeof__(*(ptr)))0;			\
 		} else {						\

