Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F80606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kwvsNrut
Received: by kanga.kvack.org (Postfix)
	id 2A22F6B05B5; Tue,  3 Nov 2026 03:19:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 251DF6B05BB; Tue,  3 Nov 2026 03:19:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 142646B05BC; Tue,  3 Nov 2026 03:19:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E16B16B05B5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:19:58 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E3E1E120245
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:19:57 +0000 (UTC)
X-FDA: 85393109634.19.46C5E6A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 27F01180002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:19:55 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwvsNrut;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793693996;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QV8OQbqEgAbxmMI7EXk6eiYDzzCN82f0lLhovGPvCRE=;
	b=3R4oCdIXwTgji4XHrq9aLhS0R0nPTYYTYsU9Fhfay3oJlaWq7acFpxxmG+zcXJZvwo3H3k
	QxAIQ7DIv8hnE8AhhME/NukYhKuU3M1Q6ghV9LUqtDaSKjy8+lTRravwB1EUNpCJr+oOVs
	5X0S7g4sYFLj0RoZSuNeQJLT9HUgi8Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793693996;
	b=FRAWIs6zW9G8mqbiBifgD7MP+7emv+2uMIYXopKBwNZIQivinemWNqOB3MQFvISAGqVB5i
	2dtxg+Gir7lxJwpGJQ1BqCnTiv+1MlGV3NcHiZIh1g9jDLy8cxWp/9VLdQ0KdRAoJ3sD5A
	S8YcoWbD/fKhNs4Sg8TrIyP0253y5PI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwvsNrut;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 460B54148C;
	Tue,  3 Nov 2026 08:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A628D1F000C1;
	Tue,  3 Nov 2026 08:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793693995;
	bh=QV8OQbqEgAbxmMI7EXk6eiYDzzCN82f0lLhovGPvCRE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kwvsNrutpfuguMNeSWIfyUqAD6nD8ZT9TCHfXU8MutBmcDYL52Gx9TFwpiQDeupjL
	 K0m0fV2+WdZtu9vmW3bmnlagk02Yei7S0mswVuuLWC60pb5yw36MyhFyofDH76wGxW
	 x+uJ1t61RO8ODByH58EpcoSGcVAP005yfKsyup6lmrJlxsgfT8Ttd++O6b1K8QS/4i
	 etvXnQfakTB4/uEf/tvpFktS2Kfk8G8bwsha9Uvf8NSX1VJp0G8lma61PJcM+KrVKk
	 pY6IWZiBUfgt3hH1NmEP1WE7WEob2sknt0Nlq150u24xhYzstaQhkr/Dwnx/iEOone
	 YhoJ/JH6gZvTA==
Message-ID: <sashiko-outbox-194818@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCHv2 bpf-next 2/8] bpf: Add user memory kfuncs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jiri Olsa" <jolsa@kernel.org>, "Alexei Starovoitov" <ast@kernel.org>, "Daniel
 Borkmann" <daniel@iogearbox.net>
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, "Andrii Nakryiko" <andrii@kernel.org>, "Eduard
 Zingerman" <eddyz87@gmail.com>, "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "John Fastabend" <john.fastabend@gmail.com>, "Federico
 Di Pierro" <nierro92@gmail.com>
In-Reply-To: <20261103075916.100050-3-jolsa@kernel.org>
References: <20261103075916.100050-1-jolsa@kernel.org>
 <20261103075916.100050-3-jolsa@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 08:19:54 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: y35jw61beijg6hqo5k7ueoph5rkyi6kc
X-Rspamd-Queue-Id: 27F01180002
X-Rspam-User: 
X-HE-Tag: 1793693995-421592
X-HE-Meta: U2FsdGVkX19Yx5XokaLllNtlNMQ0Y55VUXeD/ojQ1K09VGqx7bza1wdnnX5aFngMNNEuTcBaJjTSJ+9yWF0mc48mwrUdTxQotyc/S5yz6yQYHOdtSu45LXNla1hIxANL/pjEkSCuDq5ihzFf2Gi5bhyT1VwEG9uyKH9yFyanyD43Wc7UBJMX/IrLOk9lROIBec5WZZQEZcigK9ROgaCcLJKmv7KCRthym/H9pgMvwmv6zWNaoUDEciKtklIfgbKr9U0Fkmjzr24zxRUpluDF/K9Zr9Q2lEVbDJnkN295uUIyQWv54yAN8DjD/sCe991acXrHDfoYEb7ZsrBWYV4JnWwko8hdukc3PGTKZ3neaoJT8tkLZFweT4wmG6J2QJrpOqaSD23g5ARK23yW2ownWNmn9Bc8i4lQ2kRPdlR531ah/Q+x64fuNyXKY3V2/AjFe4pXYL6b+uu42XhuvsJ8gC7A3w4fpq3yjS02cyrLN99ul/SIMSu2zSP3rTH8EFSZXgJaX0YaE9k9YRajVAHLreXC+ochf0ahKaogxocwmvgJcyE03U6jAZ3+DXEMPXBbhhpoUgoM4cg8CNXaC7j0vswHOq2AW6EHKO7R/I8uwfkZU2OXBs/Ch3Xk28VvA00tE++LzAbg9Vlkd3qcavydmZMCfiNcXfzm6MImfcrdr8YfrbnXPynmJRktMI/Ocsni1R7YMt6GXzIyYhP4gPvVJIjGSPOWzwYJigYc20OwUTx5YW7us9dROY3ft7NXYbVUe2dkhKV7uSqsHjjOTkbZvj1XBF7T4YvGDgX34VpaYpfCOFa+7+qpkBsEgoeT9jZZ7iMeHg2pMiR8DyZYVrPGcKwOax4W+3T5z96BiWjC6v4VnuvCwU5JxeV3B37DG3oHR2yORZwvFGEn425efgdG90qth8irvySjWXfGh+6/uklYv/giu5ELxKC0q4RYJtXbRpYXKoexxzjHNfxT+qU
 oIoXGH/Y
 TVmmx7Qm/4OUQBQYa2zTY5KGl/nb1oJuyTPfY6Vo+s2ovHAPDkuo68FPpuYh4BptZTrjh5hp4480J8fXBkatrWM12tIsH+fhlu3UmR5N036nVqy2AilwYu9jqx2LnbJGpDequer7g45fY2JoselC4O5a3vKXJaQV46eBCWxo/5jkkaAG9x44P6P87K8ou06CMWtGaunAoBli4T55pCtriSq7+5CL8XDGuECZrUOPl4KZPqYkYLL02gNeJsZPHU3Yzl/sHstZu474IwLJhqhqA8BKyECbC9mRreA2dFQMzKAi+NocwxAQ0pj5/g1mIloKonJ8DIuqmi7e2FWcfSYE+EuZqHoA30UlISgH1KjcD2Cbyv9c9GX3W8rlH1RZCFNB5Z4EAMrSHjbWltwuETizi4qY2mqSI5dwsH7JRL5pEh5PGDN0HaFI7/iCpsD3Tvc3eFx0ZE3VDOShUxUdWtI53SG/ECHNZBapfQctxVlKb7FrJfGKHVysTm280iYtCxFJztdFZR3TeJRUA75A2ePMQeZKjMYItWBzcgOeriKtfwIUBrGen+ItH9E8W6vOhVEyKpV4p/fs/NXvIItSb5dpzZzWxFhZ+yyST3yoYMwFeptalaTN+8RebUJEaLFybYnvSnx/IlxOJbz3jflLV7TDYH1yVmvv7JNTSo0XN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Medium] bpf: bpf_user_vm_mmap() clears active TS_COMPAT on TIF_ADDR32 ta=
sks
- [Medium] bpf: bpf_user_vm_mmap() triggers false in_32bit_syscall() on x86=
_64
--

commit f91c9a5c8eeb0a10c48d0c7030bd2cd248f6d3fd
Author: Jiri Olsa <jolsa@kernel.org>

bpf: Add user memory kfuncs

This commit adds the sleepable kfuncs bpf_copy_to_user(),
bpf_user_anon_mmap(), and bpf_user_munmap() for KPROBE BPF programs to
modify a user task's address space and manage private anonymous mappings.

> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 58e357302850e..ae7dfa58ae95c 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c

[ ... ]

> @@ -3741,6 +3747,110 @@ __bpf_kfunc int bpf_copy_from_user_mm(void *dst, =
u32 dst__sz,

[ ... ]

> +/* bpf_wq and bpf_task_work callbacks can run without a usable mm. */
> +static bool bpf_user_mm_ok(void)
> +{
> +	return current->mm && !(current->flags & (PF_KTHREAD | PF_EXITING));
> +}
> +
> +#ifdef CONFIG_IA32_EMULATION
> +static unsigned long bpf_user_vm_mmap(unsigned long len, unsigned long p=
rot)
> +{
> +	struct thread_info *ti =3D current_thread_info();
> +	bool compat =3D test_thread_flag(TIF_ADDR32);
> +	unsigned long addr;
> +
> +	/*
> +	 * We are not in a syscall, but x86 get_unmapped_area() paths
> +	 * ignore TIF_ADDR32 and rely on in_32bit_syscall().
> +	 */
> +	if (compat)
> +		ti->status |=3D TS_COMPAT;
> +	addr =3D vm_mmap(NULL, 0, len, prot, MAP_PRIVATE | MAP_ANONYMOUS, 0);

[Severity: Medium]
As reported by bot+bpf-ci@kernel.org on v1 [1], on x86_64 kernels with
CONFIG_X86_X32_ABI=3Dy, will calling bpf_user_anon_mmap() from a sleepable
uprobe in a native 64-bit process falsely trigger in_32bit_syscall() and
restrict mappings to the 32-bit compat range below 4 GiB?

When a 64-bit task enters a uprobe breakpoint exception (or sys_uprobe /
sys_uretprobe), task_pt_regs(current)->orig_ax is -1. Under
CONFIG_X86_X32_ABI=3Dy, in_32bit_syscall() checks in_x32_syscall():

arch/x86/include/asm/compat.h:in_x32_syscall() {
#ifdef CONFIG_X86_X32_ABI
	if (task_pt_regs(current)->orig_ax & __X32_SYSCALL_BIT)
		return true;
#endif
	return false;
}

Because bpf_user_vm_mmap() passes addr =3D 0 to vm_mmap(),
arch_get_unmapped_area_topdown() and arch_get_unmapped_area() call
get_mmap_base() and find_start_end(), which both check in_32bit_syscall()
and select mm->mmap_compat_base and task_size_32bit() instead of the 64-bit
address space.

> +	if (compat)
> +		ti->status &=3D ~TS_COMPAT;

[Severity: Medium]
Could clearing TS_COMPAT unconditionally whenever TIF_ADDR32 is set clobber
an active 32-bit syscall's TS_COMPAT state?

When a 32-bit IA32 task enters a syscall via syscall_32_enter(), TS_COMPAT
is set in current_thread_info()->status and must remain set until
arch_exit_to_user_mode_prepare() clears it after signal handling and
syscall restart fixups:

arch/x86/include/asm/entry-common.h:arch_exit_to_user_mode_prepare() {
	...
	/*
	 * Compat syscalls set TS_COMPAT.  Make sure we clear it before
	 * returning to user mode.  We need to clear it *after* signal
	 * handling, because syscall restart has a fixup for compat
	 * syscalls.  The fixup is exercised by the ptrace_syscall_32
	 * selftest.
	...
	 */
	current_thread_info()->status &=3D ~(TS_COMPAT | TS_I386_REGS_POKED);
}

If a kprobe schedules a sleepable bpf_task_work callback that runs during
syscall exit (for example via task_work_run() inside get_signal() or
ptrace_notify()) and calls bpf_user_anon_mmap() -> bpf_user_vm_mmap(),
ti->status &=3D ~TS_COMPAT will clear TS_COMPAT before signal handling
finishes. Subsequent calls to syscall_get_error(), in_ia32_syscall(), and
in_compat_syscall() will then treat the active 32-bit syscall as a 64-bit
syscall.

Should bpf_user_vm_mmap() only set and clear TS_COMPAT when
!(ti->status & TS_COMPAT)?

[1] https://lore.kernel.org/r/571f32a410a85199bc9bcecfe07a9a9b6ef425b205264=
3e64031dd246c13691e@mail.kernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103075916.1000=
50-1-jolsa@kernel.org?part=3D1

