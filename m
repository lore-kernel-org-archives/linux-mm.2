Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C34C6606A320
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h7KsVwYu
Received: by kanga.kvack.org (Postfix)
	id E90FD6B0793; Wed, 21 Oct 2026 16:22:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E691D6B0794; Wed, 21 Oct 2026 16:22:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7F256B0795; Wed, 21 Oct 2026 16:22:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B0ABC6B0793
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:22:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ACC9E1205C5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:22:28 +0000 (UTC)
X-FDA: 85347755976.26.179D397
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id EB1321A000E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:22:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7KsVwYu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792614147;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGOMnIYwvm/EEEaQ76rK00Aw0STqIep+qzYSTJj84jk=;
	b=KFXS5a7sIpjkc8fRdCglOVc9iDqCtYS6rThWRNKQ3gBaNcyiLoVZ8d+iDpHkC/VuTqTYVp
	/DndLBd/j51EOh4iu6DvVMcwaiQFL1SUqKTfwqz3f842cOR0A9tcso791oq73bIyQUe3Rs
	cwzj9CsRMDSXnON9beAGxZOvFSN9dfU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h7KsVwYu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792614147;
	b=4lrbtRQSp/+i5keivW75b80WU8TJHRolsRPROrZzrKAna3Pj998HSvU8MPT8RFU5kjQd8n
	iOayPWDLR4XiCFVlgDfKqcS5KIiVMsbAIU/4tmCGLRLD0q4PgQERHxRzQAI4OEUGUfkfrt
	W7Q6du48GV47NUcHSlnt/N4KsoiiyFQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 039E541222;
	Wed, 21 Oct 2026 20:22:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E1E1F000C1;
	Wed, 21 Oct 2026 20:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792614145;
	bh=mGOMnIYwvm/EEEaQ76rK00Aw0STqIep+qzYSTJj84jk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h7KsVwYuPW7Uw0bpS7QaDrhuM3jaYLvY7hI7HF6H9IwHLU0gYo7xW8JE7k60JPFW9
	 K/Uq17uxGUW1I7E1ME0DbwYHGfkM52Eaxc1QX2cJCrdggVPywIKm/bfBLbetC9KfF1
	 CDajCUDXAdfCv4RJnv0zuJ+GO5bo3QR5h0ce/h+XskK1GE8pIYaoDMO56vN9XaMsR5
	 ai7bjX+sk25ALCb2tykQ2LTgwkMy3vuQvtbgw4fc7sCODXLVKMFnvUMmBN4Uc0GkBM
	 3Tiz0Zd54cn26zFhc51ZBIQsy7WSH/p8uR/W+Wkt9+XBgOytQItWUJtkWSsuw9vP3s
	 8YJ1hxI3JjjtQ==
Message-ID: <sashiko-outbox-180638@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC bpf-next 2/9] bpf: Add uprobe faultable user copy kfunc
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiri Olsa" <jolsa@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, linux-mm@kvack.org, "Andrew
 Morton" <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Shuah Khan" <shuah@kernel.org>, "John Fastabend" <john.fastabend@gmail.com>
In-Reply-To: <20261021195759.119421-3-jolsa@kernel.org>
References: <20261021195759.119421-1-jolsa@kernel.org>
 <20261021195759.119421-3-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 20:22:24 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EB1321A000E
X-Stat-Signature: gfes5xy8jeen6dch993aat3o5ds8jrq1
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792614146-927969
X-HE-Meta: U2FsdGVkX19swih2gBTA4GH1uzv/pCryZ6IW0ArtrrWMr5Eof/AMHm+2+fmSeq0xglcMFMFq+PIgdrrJLP4HxnsGzIUkvBrfc6/0QR/wGgJT4d+0COPtODE/b3hDeMVbCoCnjOu1Tcs7r+VjsoTKGbgbeH6y5uIObrQ6eca17xSL5ehAkx1IbtT0O+C/fGRwd/VWcIZoQZd5v/Yluk/9/BRMVEMjzcaSuiYRwXv0/+YhgiTgVaqVQQhDDhqgkzTRig8L0yXZ4VdeuQ3lYUKOXngfY+PaLLpiBbZI30SxF80wQ+txxqXtsSMwdA/6pzcKCuiYNLQowvDa6dBhFeQXKCLSMcjUHu0LXnC6n9+MgIP75fnA3NqVtseujC95dv0Ab0Nb/JdGRdyLrZWSZ6Tx7BcwzbJhs3Gyrm95UkMB86DCC1s+uJR7jy2ANO9DB0MvSg+PAvXN544pr3ovIr+xiK8g5QHUedUjnzOLoPJTZWLeTgsRBe5ug5Fjnhz/TjnoEWrT5v4+HJxmu1tnEp8cPPf6zhEK5gWGwOIdno1I0w3VEVxTH9AXqrHFNJgjCHN/4sjFCYssiMXBepIfo6pyoT2bHA6EXGxXchVBpbF6WS9VxS0vvoE1Tik6ibsDUTFgz1UqRT5FlT7G4fPFiPfHYNSHGpEEgqCQymmLGTaKpFjBr/60Fz4cIqOHqsT6g9HBurOJK6NLGCjvskzL/v48cWO+4ec4mFcLrrGVr7xir/5KKYcL6AHPcr/3vbInGMuz23h4kNX30vJtVP45kJa6aSMsnFwVaiV675ctZkd+Wmt3KvaAehCcJuRzLMN0SKDVOdkm6giY6OVDpftw5jHocc6sx3kqUMed+vn6puJyBAU5KgSys9N+dvAcLY2lIzBW0UiO3ZbaUmWR3SCTtpCxEsQhHksZz2FeyPzqPup0dlRXG72rQWd9QWNO/RNnQStds4YwBfhcQod+jpAPgpe
 c+7meqd6
 N/f3jAvIT1TxF4Zn1856g3G8ih3Q+3UB6d1fJrWMGr/aMxmPEykBOnCoAqlZSlV7AI1Miu0jBfAC9BrXQ/le9xANs/Y+u55krVaO9tYZNoE+oDi3UhW2b5DCfBmYthZT6FlCjhutchLar22paErahka84NA33TgB8cC86Ws8MKkn1VLPf17/EY0NN+x6UNdpj1DySfzAmpMwa/AQuc7A1INBBtCyqRXwnfHTpxibOmDS5IHGo0A+0T06oMt7TxM0oyvKXYWkM1B7Cu9Ctg/wt1/gWyUV5NJug462pXB0NYB2VdtNU0hIYBSs4vNzzfg+dbtNGCKAfInn9VorR0APctcRbLJ8fn0OrOjIK47GrdaVnngZpqbWut+7cjaoai6hlyYfVsO5EbiID1mTu1o1+jbtadaPh9IU34sjWHvKPus03OoDLGgbSoTPYTe1VryvLXI3EeS9Atpt3FzFWsAbhgobhtkqf/vnos4aHUfZE3TM8M11C69VHa6tSN/G9RMZYpfkOjqyiW7MzcEL47hAwnDHLGi6HrPI19PsTJaCN/fHTMmpNzxZ73CvzAHn7UqKOvkSRaUp5hrKY9lOPA2i9UwBeaFzDcdbQez1T3zMVHHm9cEWQtRXNp4KaVs29s96bvxEAx6oJ38giSCitJorOQ130GSZgOVpKkGLq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential issue(=
s) to consider:
- [Critical] bpf: missing CAP_SYS_ADMIN check in user_mem_kfunc_filter()
- [High] bpf: hardened usercopy BUG() in bpf_probe_write_user_faultable()
- [Medium] bpf: missing prog->sleepable check in user_mem_kfunc_filter()
- [Low] bpf: unused enum user_mem_kfunc_id in kernel/bpf/helpers.c
--

commit bbd6dece6abea0ce7dfa98ce448c7aae57de64d1
Author: Jiri Olsa <jolsa@kernel.org>

bpf: Add uprobe faultable user copy kfunc

This patch adds the bpf_probe_write_user_faultable() sleepable kfunc to copy
data to user memory with page faults enabled. It registers the kfunc for
BPF_PROG_TYPE_KPROBE programs and filters access with
LOCKDOWN_BPF_WRITE_USER.

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 648abe1ba63ae..4d9e9423826a9 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c

[ ... ]

> @@ -3738,6 +3739,36 @@ __bpf_kfunc int bpf_copy_from_user_mm(void *dst, u=
32 dst__sz,
>  	return ret;
>  }
> =20
> +/**
> + * bpf_probe_write_user_faultable() - Copy data to userspace with page f=
aults
> + * enabled
> + * @unsafe_dst__ign: Destination address in the current task's address s=
pace.
> + * @src__srcptr:     Source buffer in BPF-accessible memory.
> + * @src__sz:         Number of bytes to copy.
> + *
> + * Copies data to userspace, allowing page faults to resolve the destina=
tion
> + * mapping. A failed copy may have written a prefix of the source buffer.
> + *
> + * Return: 0 on success, -EFAULT if the copy is incomplete, or -EPERM if=
 the
> + * current task cannot safely access userspace.
> + */
> +__bpf_kfunc int bpf_probe_write_user_faultable(void __user *unsafe_dst__=
ign,
> +					      const void *src__srcptr,
> +					      u32 src__sz)
> +{
> +	if (unlikely(in_interrupt() ||
> +		     current->flags & (PF_KTHREAD | PF_EXITING)))
> +		return -EPERM;
> +	if (unlikely(!nmi_uaccess_okay()))
> +		return -EPERM;
> +	if (unlikely(!current->mm))
> +		return -EFAULT;
> +	if (copy_to_user(unsafe_dst__ign, src__srcptr, src__sz))
> +		return -EFAULT;

[Severity: High]
Can calling copy_to_user() directly on src__srcptr trigger a hardened
usercopy bug when a BPF program passes a trusted BTF object pointer?

In kernel/bpf/verifier.c, get_kfunc_arg_type() classifies src__srcptr paired
with src__sz as ARG_PTR_TO_MEM | MEM_RDONLY. During verification,
check_reg_type() permits mem_types, which includes:

kernel/bpf/verifier.c:
	PTR_TO_BTF_ID | PTR_TRUSTED,

and check_helper_mem_access() allows BPF_READ access on scalar fields of
trusted BTF objects (such as &task->pid or task->comm from
bpf_get_current_task_btf()).

At runtime, copy_to_user() calls check_copy_size(src__srcptr, src__sz, true)
-> __check_object_size() -> __check_heap_object() in mm/slub.c:

mm/slub.c:__check_heap_object() {
	...
	usercopy_abort("SLUB object", s->name, to_user, offset, n);
}

When src__srcptr points to a field in a dedicated slab cache outside its
whitelisted usercopy region (for example task_struct_cachep, mm_cachep,
files_cachep, or fs_cachep), wouldn't __check_heap_object() call
usercopy_abort() and panic the kernel when CONFIG_HARDENED_USERCOPY is
enabled?

> +
> +	return 0;
> +}
> +
>  /**
>   * bpf_copy_from_user_mm_str() - Copy a string from an address space
>   * @dst:             Destination address, in kernel space. This buffer m=
ust be
> @@ -5139,6 +5170,31 @@ static const struct btf_kfunc_id_set generic_kfunc=
_set =3D {
>  	.set   =3D &generic_btf_ids,
>  };
> =20
> +BTF_KFUNCS_START(user_mem_btf_ids)
> +BTF_ID_FLAGS(func, bpf_probe_write_user_faultable, KF_SLEEPABLE | KF_PER=
FMON)
> +BTF_KFUNCS_END(user_mem_btf_ids)
> +
> +enum user_mem_kfunc_id {
> +	KF_bpf_probe_write_user_faultable,
> +};

[Severity: Low]
Is enum user_mem_kfunc_id left over from an earlier version of the patch?
Since user_mem_kfunc_filter() compares kfunc_id against
bpf_probe_write_user_faultable_btf_id[0], neither enum user_mem_kfunc_id nor
KF_bpf_probe_write_user_faultable is used anywhere in kernel/bpf/helpers.c.

> +
> +BTF_ID_LIST_SINGLE(bpf_probe_write_user_faultable_btf_id, func,
> +		   bpf_probe_write_user_faultable)
> +
> +static int user_mem_kfunc_filter(const struct bpf_prog *prog, u32 kfunc_=
id)
> +{
> +	if (kfunc_id =3D=3D bpf_probe_write_user_faultable_btf_id[0])
> +		return security_locked_down(LOCKDOWN_BPF_WRITE_USER);

[Severity: Critical]
Should user_mem_kfunc_filter() also verify that the program has
CAP_SYS_ADMIN via bpf_token_capable(prog->aux->token, CAP_SYS_ADMIN)?

In user_mem_btf_ids, bpf_probe_write_user_faultable is marked with
KF_PERFMON, which in check_kfunc_call() in kernel/bpf/verifier.c only checks
env->allow_ptr_leaks (satisfied by CAP_PERFMON). Meanwhile, for the existing
bpf_probe_write_user() helper, bpf_tracing_func_proto() in
kernel/trace/bpf_trace.c enforces CAP_SYS_ADMIN in addition to lockdown:

kernel/trace/bpf_trace.c:bpf_tracing_func_proto() {
	...
	if (!bpf_token_capable(prog->aux->token, CAP_SYS_ADMIN))
		return NULL;

	switch (func_id) {
	case BPF_FUNC_probe_write_user:
		return security_locked_down(LOCKDOWN_BPF_WRITE_USER) < 0 ?
		       NULL : &bpf_probe_write_user_proto;
	...
}

And include/uapi/linux/capability.h documents this boundary under CAP_BPF:

	* CAP_SYS_ADMIN is required to use bpf_probe_write_user.

Without a bpf_token_capable(prog->aux->token, CAP_SYS_ADMIN) check in
user_mem_kfunc_filter(), couldn't a process or container granted only
CAP_BPF and CAP_PERFMON attach a sleepable uprobe or uprobe_multi program to
a shared library and overwrite memory in privileged processes?

> +
> +	return 0;
> +}

[Severity: Medium]
Does user_mem_kfunc_filter() also need to check prog->sleepable to restrict
bpf_probe_write_user_faultable() to sleepable uprobes as described in the
commit message?

Because BPF_PROG_TYPE_KPROBE is shared by kernel kprobes and uprobes, the
uprobe-only restriction for sleepable programs is enforced at attach time by
checking prog->sleepable in __perf_event_set_bpf_prog() and
bpf_kprobe_multi_link_attach().

In check_kfunc_call() in kernel/bpf/verifier.c, KF_SLEEPABLE checks
in_sleepable_context(env) rather than prog->sleepable. When a non-sleepable
BPF_PROG_TYPE_KPROBE program (prog->sleepable =3D=3D false) registers a cal=
lback
via bpf_task_work_schedule_signal(), bpf_task_work_schedule_resume(), or
bpf_wq_set_callback(), push_callback_call() marks the callback state as
sleepable via is_async_cb_sleepable():

kernel/bpf/verifier.c:is_async_cb_sleepable() {
	/* bpf_wq and bpf_task_work callbacks are always sleepable. */
	if (bpf_pseudo_kfunc_call(insn) && insn->off =3D=3D 0 &&
	    (is_bpf_wq_set_callback_kfunc(insn->imm) || is_task_work_add_kfunc(ins=
n->imm)))
		return true;
	return false;
}

Without checking !prog->sleepable in user_mem_kfunc_filter(), wouldn't a
non-sleepable kernel kprobe, kretprobe, or kprobe_multi program be able to
call bpf_probe_write_user_faultable() from a bpf_task_work callback?

> +
> +static const struct btf_kfunc_id_set user_mem_kfunc_set =3D {
> +	.owner =3D THIS_MODULE,
> +	.set =3D &user_mem_btf_ids,
> +	.filter =3D user_mem_kfunc_filter,
> +};

[ ... ]

> @@ -5266,6 +5322,7 @@ static int __init kfunc_init(void)
>  	};
> =20
>  	ret =3D register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &generic_kfunc=
_set);
> +	ret =3D ret ?: register_btf_kfunc_id_set(BPF_PROG_TYPE_KPROBE, &user_me=
m_kfunc_set);

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021195759.1194=
21-1-jolsa@kernel.org?part=3D2

