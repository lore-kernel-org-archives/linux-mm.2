Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6BFE60A2612
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 23:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kipjYXRo
Received: by kanga.kvack.org (Postfix)
	id A6DAE6B091E; Tue, 27 Oct 2026 19:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A45746B091F; Tue, 27 Oct 2026 19:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95BD46B0920; Tue, 27 Oct 2026 19:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5226B091E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:17:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E3B7E1C43A8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:17:31 +0000 (UTC)
X-FDA: 85369969902.28.B060ECB
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com [209.85.210.199])
	by imf16.hostedemail.com (Postfix) with ESMTP id 384A5180008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 23:17:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kipjYXRo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3CDHhagoKCE0y8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3CDHhagoKCE0y8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793143050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZDGRVgYI+YuLX6sEG6mHKRJT8belKw9rO3epzepDmXc=;
	b=gYOF9mHJidUoOk2EbdewufO7awk7Hm56KEAWNOmB1VnqIi0rmQNMBihGbiD/t3QDM1KFgM
	3Lk90nHcBO8xoOg8onj5+Bd09I9wqTpECrELzqf4j+ZCUwomprES9THYgvxJv0MQT//Nks
	jdB9oMTZWM/FJK2x5RfNr938vB2WsNg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kipjYXRo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3CDHhagoKCE0y8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com designates 209.85.210.199 as permitted sender) smtp.mailfrom=3CDHhagoKCE0y8w39vw832v33v0t.r310x29C-11zAprz.36v@flex--jthoughton.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793143050;
	b=QQ+0d1mV1XBU3fNNKzs6hkBfq4B3+XnU5wdbWR0wFskTHjrlQMJ8NuDuRwkvHY68FAumuI
	SXd2EPKQkoiSMIN/6fRlqBxVtqc12rfL6wwESiPgpcTgrlfEFpS+21oqKueiQff+R6UPOS
	hcElnTMknxO3aS8wNgbefboJO4p7YCI=
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-8a0688a43d3so320375b3a.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:17:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793143049; x=1793747849; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZDGRVgYI+YuLX6sEG6mHKRJT8belKw9rO3epzepDmXc=;
        b=kipjYXRonyqTQUc8CCw2cRqQhDsWt4d8RMW7zV1NATs1FNOdk1VVKTYIORXvHmXk46
         uQJ5gBI1P2hJa8XKc/huFECsUnVRUWR5ElAzm/IKgmDkOv3Nt20Ui+3XWn+1lFOGLUvE
         KHP5oY/c8Qt5zdEuSJblPh0+lPkLWO/iVlyxkDKGbleMQP6/fcjgEtyIc1yIl0NgMoqV
         sGLPAhT0pxTlOCpG2PFn3VUnuXzo6TanDu5T/VcHg/oQ4z8jaKV/UuZCGTfUy9IhBw3a
         2D/UHUFEHzk+wX+juGR+LjIrneUjcqNg7xOquWIpqSW7+/npG6JCfMfNwcnwJHwgcZGf
         sfkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793143049; x=1793747849;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZDGRVgYI+YuLX6sEG6mHKRJT8belKw9rO3epzepDmXc=;
        b=kP430E1aNmCH/H4EeOpiyQvz1d2BtLrbRFEvSuqxnhhBNB1lyEyPKVAxRyzoQ/avDl
         G7DYJnth2MVp15G7pocXD3hlnoDf+JNjNVXme+VkxaEKBDoAcFeg/0dm8CfhhUGJ+mtL
         xoE5Ky0nwLERsW2EV1Zf0LpD+HXEQLfrMhQafHscrxhUMWYupwC6LNIOBFTYdRgCwChN
         pfl86cbnuU7XGZmqwLeneBQ6K6cUB9uszRD5b3dM2+VL+chGYjfGVFVKD+N2Wiv8FH2G
         Dq4Zy1/U1gh6AaxcFSuL4k0u3WeByqyQ/NCh3tpYAGRYf5EGz9lb0R3MjvNGrldIefBc
         eqeA==
X-Forwarded-Encrypted: i=1; AKwUvByOepT3ZhN0xgcltd/H7W0s9rUbodz8/ZG7xVnF21rn+1EWAHZZKhpKnr0sdVMgPFIetS48eFgYAQ==@kvack.org
X-Gm-Message-State: AFq9FYKzE4w69H3tRQcsa0VgUKAEmMESbrkzOJW7wdyb5fB5m4LNxsC1
	ag7lUxHvYKKQ0GwGbjtF13z1M/9g9q+DrAecxwZfzuMUB7OQXKdRWTorkcORnMqk7CUgaJuFBpO
	ZUWf+S6ihwB5/5bisWOeKKg==
X-Received: from pgcgn27-n2.prod.google.com ([2002:a05:6a02:6a1b:20b0:cda:df40:b50f])
 (user=jthoughton job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:b7a6:b0:3e2:4c65:5905 with SMTP id adf61e73a8af0-3e902404531mr513567637.60.1793143048797;
 Tue, 27 Oct 2026 16:17:28 -0700 (PDT)
Date: Tue, 27 Oct 2026 23:17:28 +0000
In-Reply-To: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <ac22215d-3e58-4aab-851e-47c30836e058@app.fastmail.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261027231728.1466446-1-jthoughton@google.com>
Subject: Re: [RFC PATCH 00/10] uaccess: Refuse and warn on user accesses when
 current->mm is NULL
From: James Houghton <jthoughton@google.com>
To: arnd@arndb.de
Cc: James.Bottomley@hansenpartnership.com, acme@kernel.org, 
	akpm@linux-foundation.org, asml.silence@gmail.com, ast@kernel.org, 
	axboe@kernel.dk, bpf@vger.kernel.org, daniel@iogearbox.net, david@kernel.org, 
	dsterba@suse.com, io-uring@vger.kernel.org, jmattson@google.com, 
	john.fastabend@gmail.com, jpoimboe@kernel.org, jthoughton@google.com, 
	kees@kernel.org, kvm@vger.kernel.org, liam@infradead.org, 
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-perf-users@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, ljs@kernel.org, mason@kernel.org, 
	mathieu.desnoyers@efficios.com, mhiramat@kernel.org, mhocko@suse.com, 
	mingo@redhat.com, mkp@kernel.org, namhyung@kernel.org, pbonzini@redhat.com, 
	peterz@infradead.org, rostedt@goodmis.org, rppt@kernel.org, seanjc@google.com, 
	surenb@google.com, tglx@kernel.org, vbabka@kernel.org, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 384A5180008
X-Stat-Signature: d9wh5nzdofdi3f11bbhbigp5i4cbrgkr
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-21.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793143050-321845
X-HE-Meta: U2FsdGVkX1/LCl4rnfc20Acodlq3kXLra035RoGfO65iLtdtrzrwnBjXfAzDPX7Zqsh1X3/4jaRdKpSrnJCpa32G91tR6uwjSDhc3/ZJTVJMSXu+t1zDHwoBlvs5Cc+unpVs3P2hk/ejC/p4WsGABnNeSBusEIcDsZLDk84u94kxPT4sXrieaCZzQQr5pfB61rmf7/RQjqe/mfOgZIxpVmwNPul0NMWFAHiAQ/F/RpLDMC5/8q0QonduLo4+3tNQkJTlVKviWIcoiC7uYVWocmyicOOHIV+UTqSM1f0win9JStWLKtOMyi0SKOf1gWfpXH2T2cvnU2lbLbzZydv9JOVcN0EouLTsG4Hv8kkhMr1SyWdiYfgoTDlVCs66XLxMyE/iRB1uJYie+fYuVUaBQj9xtC6CFDqs4zFtoWvUFs54QBQDPM7nOHlIV0D8s90IDwvh65ynLoJGCBFcUNkaiD4IWSgpgdFTGiVjPkxor6sdUSthKiU811KCMnvDKY8nu4alqFruTfanNjhDvsAdoWniQysdeqbSld8nLEHJNQQjzEU7wOgKhIK1SCFfxVNkD7HoOW1vUD9goMwquH0KNCf6+ZY28c6YnIqMgJWo0rxejGcnkAIN0p+PFrr5/ZfWedhqovCGeKSvlUUFvorAOVdAnGeaJymoCY64wDudztJj0gmNcMe/2n6rrntzOdnqQvIiLWuoreRX4XeSnK/wjDBlFWNnq1qR0pntzrCU3mr5vtBu3TpHwNBzCkILukP39fnV3NJtTi4LhIA+tEwWE/Qy8vupnVUdznxQQ5kWYjQiqbvyuqbg6UOmMoidgmeERGogYM8EGxPF+uxAap5Vz09IDsvuAspZRNsoIafQkxAPLMDr3ROFpfxFDvaj1pdjg5qgFwE2Z0fDSl2BXAnPlFsm6JjshL4XpZirWxEv5c8Bm5aP5cgqSA6KPUwxnoQNhbnS3PeRmDabPko8qKR
 6/lpe4k/
 a48lwJSFSEwkvQP+xlp9JA0jMWBb4Un/242XQb2hiu7xJ+DCUJAEUPnGvbMAPZO77K3UOFVWJH1aDT+E65I3hmyNjpTtjsbIV6cHdULC+8WPbYD2zJZHq+7ZS44SudrXh2XlhxmP9go0ElJDZrjaK7Eif7GgjOgdGDjPq4El2S8N/Zxtje0e+DDAJf32vEwuXslX5Lc5Df3B7azg9aKtb/hC//zgbj4U1V4/ZAwKJJSFSJ87xulXRESmIs3sI8bXxQ7HrU3n6wfPmmumsPZBB6Ne22A1zePZEmC9H880ysZf3VPt6Ii5npmz8z9G8kYcRkv8+maY4XaD9hTKtacc8U7xXUnQvllHNAOMN/rdKsoD0tb0+7Di7U/cdHnANfXGSRJba8F3nt46AX1uvmzNkiUAT6mrwN9/qHgKOoSJxy0DauJA4qmzApPEAmApJ0Fs6CqNVDtck+50JZYhTupiOxF+XHFGZ7bm1ZGWsXyBvd2s65ZLSS1Ran8gtBC5ZB+6krpua2V3SQCyDQbo3ymDecbidxoC4/4vCCuh09e3DolV3vSaDVTARdaKyfH84KdoZGWIGbr7fhi3SR4uBFYdp34NkeVimOVVyCgVQKTxptvsweEWFQKMMScvaxU81xv5KvfCsz+7BlasujsXHqeekRWgXnkEkpLy5QdAhl8lZN7zMrapCh2kVYqKs8LhoUzJ9B+7t2MGdCX11Qy1osngEFbJ3DyhHyWVOPODPPVgOag+hsf9tQwusqKE57CR/J5mCqWvn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 11:32 AM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Oct 27, 2026, at 18:29, James Houghton wrote:
> > On Mon, Oct 26, 2026 at 5:13 PM Arnd Bergmann <arnd@arndb.de> wrote:
> >>
> >> E.g. on arm64 with CONFIG_ARM64_SW_TTBR0_PAN, the page table base for
> >> the current process is only set in user_access_begin() and would
> >> not point to any task here. Without ttbr0_pan, it should be
> >> covered by cpu_set_reserved_ttbr0() turning off all user space access
> >> for kernel threads.
> >>
> >> Should this perhaps be addressed in architecture specific code
> >> instead of in a common place?
> >
> > You're right that whether corruption can actually occur depends on the
> > architecture and config. I'll write a note about this in the v2 cover
> > letter.
> >
> > That being said, I still think the right thing to do is to have the
> > new check(s) in common code. Instances of improper uaccesses are still
> > bugs, even if no corruption occurs.
>
> I agree we have to do something to prevent the problem for most
> configurations and find any newly introduced bugs.  The questions
> that need to be properly decided are
>
>  - does there need to be any compile-time configuration to skip
>    the extra checks and/or the warnings?

Since patch 10 moves the warning out of line, it costs nothing on the
fast path, so making the WARN configurable wouldn't save anything. The
question is really whether the mm check itself should be configurable,
and that check is also what makes the access safe.

The text size increase seems manageable[1], but it would be great to
hear other people's thoughts. For the runtime cost, I'll do some
performance testing. My guess is that a load of current->mm and a
well-predicted branch per user access will be negligible, but I'll get
numbers.

>  - are there any cheaper ways to make it safe than to add a
>    condition on each user access?
>    E.g. the original lazy mm switch was intended to avoid
>    expensive TLB flushes when switching to a kernel thread and
>    back to the original task on 32-bit x86. On modern CPUs,
>    the MMU can deal with multiple ASIDs cheaply, so turning
>    off user access in a kernel thread may be cheaper than
>    adding code to uaccess depending on the architecture.

That's a fair point. If user memory were inaccessible in kernel threads
and after exit_mm(), every such access would fault, and the fault
handler could WARN about it (x86's do_user_addr_fault() already has a
!mm branch), so it could still be loud without a check on every access.

I'll look into disabling lazy mm switching on x86 and doing some
performance testing with that (like comparing the per-uaccess check
with the added cost of non-lazy mm switching).

Other than the performance difference, I see these issues with making
uaccess safe entirely with the mm switch mechanics:

 - It only helps on architectures (and configs) that implement it,
   while the common check works everywhere today.

 - The fault handler would need to tell legitimate faults apart from
   bugs, e.g. copy_from_user_nofault() from BPF or perf in a kernel
   thread is fine and must stay quiet. The series handles that today by
   checking current->mm in the nofault helpers (patch 6).

The two approaches are mostly complementary: if non-lazy switching
turns out to be cheap enough, an architecture that does this will have
better defense against uaccess bugs. But I'd still like the common
check so that these bugs are reported on every architecture.

> >> I would think that user_access_begin() is a more natural place
> >> for the added checks, as this should be called exactly once for
> >> any function that accesses user space and also stays out of the
> >> way of the copy_from_kernel_nofault() etc.
> >
> > user_access_begin() isn't used in a lot of places that I want to
> > catch, including the KVM case. Roughly:
> >
> >   kvm_write_guest_cached() --> __copy_to_user() --> raw_copy_to_user()
> >
> > There's no user_access_begin() in there. :/
>
> Good point, yes. After the changes described in
> https://lwn.net/Articles/1102061/, I had assumed that all
> __copy_{from,to}_user() are going from common code, but it looks
> like the series so far only touches __{get,put}_user().
>
> There are of course few enough of these left that I think
> we can consider doing the same thing here and turn them all
> into the checking version:
>
> $ git grep -wl __copy_'\(from\|to\)'_user  drivers mm virt
> drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
> drivers/gpu/drm/i915/i915_gem.c
> drivers/gpu/drm/i915/i915_query.c
> drivers/usb/gadget/udc/atmel_usba_udc.c
> drivers/vhost/scsi.c
> drivers/vhost/vhost.c
> mm/kasan/kasan_test_c.c
> virt/kvm/kvm_main.c

Agreed, I think we should clean those up, but that can be done
separately. This series already adds the check to the common
__copy_{from,to}_user() and __copy_{from,to}_user_inatomic() wrappers
in include/linux/uaccess.h (patches 7 and 8), so the KVM path is
covered without converting the callers first.

> > I do think user_access_begin() should have the new check though, so
> > I've added it in the v2.
>
> I had the details confused here. Seing that user_access_begin()
> and the other accessors always call access_ok() at some
> point, maybe that would be enough?:
>
> --- a/include/asm-generic/access_ok.h
> +++ b/include/asm-generic/access_ok.h
> @@ -33,6 +33,9 @@ static inline int __access_ok(const void __user *ptr, unsigned long size)
>         unsigned long limit = TASK_SIZE_MAX;
>         unsigned long addr = (unsigned long)ptr;
>
> +       if (WARN_ONCE(!current->mm))
> +               return false;
> +
>         if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
>             !IS_ENABLED(CONFIG_MMU))
>                 return true;
>
> (plus the few extra copies of access_ok()/__access_ok())
>
> As a quick fix I would probably start with just the 'if (!mm) return false'
> bit here to get something merged while we still discuss the other
> details.

Making the same point as Sean[2] but with a little more detail, I had
thought about making the change in access_ok(), but:

 - On x86-64 and powerpc, the masked user access paths don't call
   access_ok() at all. That includes copy_from_user(),
   strncpy_from_user(), strnlen_user() and every scoped_user_*_access()
   block, which is where many of the converted __get_user() users ended
   up.

 - __copy_{from,to}_user() and __copy_from_user_inatomic() skip it too,
   and the KVM bug followed exactly that pattern: the range was checked
   once up front, and the access came much later from a different
   context.

 - access_ok() is also used as a plain range check where having no mm
   is fine. For example, copy_{from,to}_user_nofault() call
   __access_ok()/access_ok(), and BPF and perf legitimately call those
   from kernel threads, so a WARN there would fire on valid tracing.

Even the quiet 'if (!mm) return false' version would have missed the
KVM case, because of the first two points. I don't think there's really
a "small" fix here, unfortunately. :/

Thanks again for all the feedback, Arnd. I really hope we can get this
series into a mergeable state. :)

[1] https://lore.kernel.org/linux-mm/CADrL8HUZ3t8RdMEeBPfqsy1_1rN0Ty9B2c4iP6OzNS12te6vOg@mail.gmail.com/
[2] https://lore.kernel.org/kvm/auEVMrMDqVuKtDqh@google.com/

