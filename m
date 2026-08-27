Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02092C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C705A6B0088; Thu, 27 Aug 2026 13:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C217B6B008A; Thu, 27 Aug 2026 13:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3A9A6B008C; Thu, 27 Aug 2026 13:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A7716B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:46:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0826B120166
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:46:47 +0000 (UTC)
X-FDA: 85147779654.14.B0637BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6243EC0005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:46:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CP+igfjs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787852805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kiHY7Snf377oa7VYd1mbKOFtc64xcuOE4VHGz2nzZeM=;
	b=Zdy32wciMarURDH44WieFBaviGWNl4cnzSEsBiJEyM0M4wF2e+YbRDwRJPVEYjCWVrIfh4
	YPw32dJxmuQ9abJ6puNMvxvrl9ATXGqdB0AsusrFYYUgtWq4zjuoCSMRBIKwySmtPR+mZC
	i9fAcln8lTCFBubcWsKy2q6fz6sm5Uc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787852805;
	b=qoZKbWXyTBc2O5DZ4x9J5+AwlqOFToJChdEIwmTx5C72Ts6tw3gL1ik9Fnd/h86oIG4AZD
	2iXyNQYEqW2r+IsDLcsLXPxlCKBVOSKquiz0F/Sbm/qeH72dvU2mDbE2JJQoofuYpWBJ1x
	rYtm+I0fVAWU/emGPTV7rZ+dYSylL/4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CP+igfjs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCED9600D2;
	Thu, 27 Aug 2026 17:46:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06371F000E9;
	Thu, 27 Aug 2026 17:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787852804;
	bh=kiHY7Snf377oa7VYd1mbKOFtc64xcuOE4VHGz2nzZeM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CP+igfjszNlZbIUl7rnHGKc5raqEHjwLHnJe417BWX3yWF9HaM6DN85AdSyFdpafR
	 Vs4wm/WpPGSXKAbNEA/53AhUN6oEC7hN4jHHCkhXbAMRBor1W42XhpsHhsVCbuN3sq
	 pVqH7VlFQru3zOkJ+Ppn3rsCpseAJ9UL5iXp0XKdaag17hYjN16BifGsha9HFLe5yi
	 BZgX0MQ4oBHg+iEv49WYDHIpSXDfDsIAYSmVkrrbaIS/k4FGHHw2vz/m2uDgtQS4P7
	 H99s1MB3vgV9u2lVYfJL53d4tk59HUNmhpJDyasvRkRSVFKdr5TL1fJCmbDtuBesoW
	 G4dI2uPeb2enQ==
Date: Thu, 27 Aug 2026 18:46:37 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/3] selinux: require PROCESS__PTRACE for FOLL_FORCE
 introspection
Message-ID: <apB32VUayqL37wyf@gremlin>
References: <20260825-selinux-pokemem-v2-0-b46bc64916d8@google.com>
 <20260825-selinux-pokemem-v2-3-b46bc64916d8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825-selinux-pokemem-v2-3-b46bc64916d8@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6243EC0005
X-Stat-Signature: foufbx891wfkp13h3yi318es4toiw4ix
X-Rspam-User: 
X-HE-Tag: 1787852805-632209
X-HE-Meta: U2FsdGVkX188E3BPTOC9qSzMwX0rXAhOaj7EFE+xSsCs57SnXjLZxpmVouTGSBoAleQ50bHz0JfqbfdGfQGzLOvp2UNNFoRbn2wluMMuniXghMxK4noHXh8Kk7e0ivs4wtHOu4TUZDwcJk2kKHXiiwblonxjV9GNF2PLaRWWAWTRk+jtHk9rnxDLN9URIYa4LXHPKLftJuon1qQEOXXO5TmvjtDWBcFgGnWryYiC6rqhPajbNdqKkPTCqbKqaX24LuGhyqJDiB0NuwQvNVn0dyuYjKkfcjIsXhyNFENrpsDiesAwLWCt2t+CLOQ5uEcQi7F8NKOdd1Zqv1Ggoj17sT9/xlYdgjq6GblPB5U3lkEdY+lh5umSP+oKdVLMtonJ9URoillZKokoVVr/cNgGwqdp8Jdcsp2W6Bf2j3OatMBh+F02PQ8RFFYF2eBDpf+AOcQ0Elhdqd/sZ6GlSPqCIjl9rsjzgezp1WZjAIz6muRz1mLJh1Gqk4VmduUktWSuWux5RHp3x9a5tuwpuAoTC7rjpB64JI/2lXDDb4DEYwIufAMNQhaYM/7/zye6wJDfemlw2HXHwgbMqzMaNp/Bl57xeGx82C4tJ5Y+J6AcR37LEUHBiKZZCynQx29Z2HmiwzbUXfqkRIYXrq4mwDNp5Pdm4q2uhIenGtL/d6RgBudXn0QmOiYTfbOHyxlQ2hwXD5U6oBIQ++aYG1v1kRtqvKbe6YlYb+hlViTwgmFc2q4RDuvK/8op2pfNGyuxgI8w8lDptQYdtSngVyNxHgwpy5PnUEfpgbRqOGl0CMaSy4s94ZsDmwG68Z2DHVMsHMorfkyeV7aE2Z/hg/88gvOLtwvs7gVaLIpys/dvgu4bo2cwo7YahGL3FeDZ3kSwmMHqkA6S7agTMrk5AmwA9bw4ZrvHXDQPxQeq3e6nHmB12rM2roW9bQca2YI6G8bpOzzqMX/qjgSaHIb9+vtbPxV
 F13emzxn
 gz3bb9AyNv6qQESzWEhtM8uUNKq3bAyWLP6Uo3H+0hNBQoqFXi6rO+//iQA0X4wHeodv4Bdx48beX5mbNWYQXai9J0Iw7iVf5Yo85QQlr8Uc9TD6nJAenmZfIJM5/f6UFkHesbWW5/yTFz2SgPt7Nbraqa/wz25NBAe9ANDv5VOnph/ymSOUZhCIZr75TsKLuY1zmFUCSoJCyfR5cNaKf2ttU1HOaPvQN27fbWIWFQY11AeFFk2EHItnpO/lvTIKZcryApYj+WY59FSv/fuBDJ7f6gLsuaAK3P/kK2YWM8jxjGx6n2Aw0j/7VNIHDtSAiJGUZ9xKagh51txENfSy4wH+H+0zaRF4pPoy+mS4OBKCzJZCtIS/m3K51QryOPzfZdp41z1lHXJZ56n86bJ8GnG3/2dU1YVq9mRvYoLlVdmCS/e4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 08:39:19PM +0200, Jann Horn wrote:
> On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a process can
> only create anonymous executable memory via /proc/self/mem if it has
> PROCESS__PTRACE (like when using /proc/$pid/mem of another process).
>
> This closes a hole in code integrity enforcement that Project Zero has used
> in a remote Android exploit chain:
> It was possible to use a memory corruption bug in a service without
> EXECMEM/EXECMOD/PTRACE permission to overwrite executable code via
> /proc/self/mem, which made it possible to load and run shellcode containing
> a kernel exploit.
>
> Signed-off-by: Jann Horn <jannh@google.com>

Not really my area but in general looks reasonable so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  security/selinux/hooks.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 18dd28b2bb13..2c2c60e9e0fe 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2157,6 +2157,27 @@ static int selinux_ptrace_traceme(struct task_struct *parent)
>  			    SECCLASS_PROCESS, PROCESS__PTRACE, NULL);
>  }
>
> +/*
> + * Decide whether it should be possible to read non-readable VMAs and write
> + * non-writable VMAs via /proc/self/mem.
> + * This only applies to systems configured with PROC_MEM_FORCE_ALWAYS, and only
> + * triggers on accesses that are not visible to selinux_ptrace_access_check()
> + * because of the introspection exceptions in may_access_mm() and
> + * __ptrace_may_access().
> + *
> + * This allows a process to overwrite read-only code in its own address space.
> + *
> + * Creating an audit record on denial doesn't make sense here, since we can't
> + * tell whether FOLL_FORCE matters for the accessed VMAs.
> + */
> +static int selinux_mem_foll_force_opened_by_owner(const struct cred *subject)
> +{
> +	struct av_decision avd;
> +	u32 sid = cred_sid(subject);
> +
> +	return avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, PROCESS__PTRACE, 0, &avd);
> +}
> +
>  static int selinux_capget(const struct task_struct *target, kernel_cap_t *effective,
>  			  kernel_cap_t *inheritable, kernel_cap_t *permitted)
>  {
> @@ -7558,6 +7579,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
>
>  	LSM_HOOK_INIT(ptrace_access_check, selinux_ptrace_access_check),
>  	LSM_HOOK_INIT(ptrace_traceme, selinux_ptrace_traceme),
> +	LSM_HOOK_INIT(mem_foll_force_opened_by_owner, selinux_mem_foll_force_opened_by_owner),
>  	LSM_HOOK_INIT(capget, selinux_capget),
>  	LSM_HOOK_INIT(capset, selinux_capset),
>  	LSM_HOOK_INIT(capable, selinux_capable),
>
> --
> 2.55.0.860.g4b6b3295ed-goog
>

--
Cheers, Lorenzo

