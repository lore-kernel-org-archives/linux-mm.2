Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E0B4C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 512996B00A0; Fri, 21 Aug 2026 14:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C3836B00A1; Fri, 21 Aug 2026 14:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B2086B00A2; Fri, 21 Aug 2026 14:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 100B26B00A0
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:56:48 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B8471A0238
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:56:47 +0000 (UTC)
X-FDA: 85126183254.17.AA55173
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 20E63C000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:56:45 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AkQCNnKS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujt60NbqKdENBZQ77CfcHaeZZJdQN/p1Z76EsgS+bZg=;
	b=uCLN29uIbSKKrXinZLcBKpcTK7/rvNHxOwV+k/BWhBtMKud1PJ0BYS4Ki7vu0i1fAgRMak
	8gketTJohzJDurzOYzWrHUzVMOwPbmSFSHw5U11Sc30JV0IXI0jH24Md+0mvGhyeCxBqYv
	r9xKnVFDRs/8BeHVIW6KK4ExAkJudYo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AkQCNnKS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338606;
	b=3e4PrVNUK55S5Ltf6yr0clGxRGhiFkkvw1VGEnrwWBl9t1OF0EisDt7lQtIlS1tB+D5V6k
	3WPBXHs4em3VQgQBJbIDj1KTC3bNCJHkABZt9nOiHwma5SiJyEgWm+FeFqSj5tUdqbrqQO
	j/HrGlZoMGBt6jfeErxHYZCqa0mZhfs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A3A1461126;
	Fri, 21 Aug 2026 18:56:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 578281F000E9;
	Fri, 21 Aug 2026 18:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787338605;
	bh=ujt60NbqKdENBZQ77CfcHaeZZJdQN/p1Z76EsgS+bZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AkQCNnKSYtat8UOrPuf3sJGUEh9Lh4vv8cbwauS2+Ujg9OR7NymCiidbW3iofdpqh
	 2UTIvDx/sbK+DCcqDmnjJ0+dYnszaWEFLJZpba7EMR1VYBMV6sv9tU+fiqCmvLn9tC
	 LH9DMx678+JdiqTYy+EYOXbMvxH4opD9EtFNKl8Yb4zD/TPGH+WAyk28xShPYxtIsF
	 O9ssFux5L5RUDcGOW4BeljnVwHa4hlt8tYY2q1zhH2Om5asNwkbl6TqOEoLTdpRxsu
	 ZzchuFaq5oc21qL4Bz1vZM8F1ud+eeWayItx+1N0O/b0xrBQASVryR+pvI35Sy1K03
	 tCTJLEnmsG7mQ==
Date: Fri, 21 Aug 2026 19:56:37 +0100
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
Subject: Re: [PATCH 3/3] selinux: require EXECMEM or PTRACE for FOLL_FORCE
 introspection
Message-ID: <aoie0oyojqdHciKM@gremlin>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-3-90cd2357ee05@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-selinux-pokemem-v1-3-90cd2357ee05@google.com>
X-Rspam-User: 
X-Stat-Signature: r8i34egegoyhomp6z491ep8xxqbsedk7
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20E63C000C
X-HE-Tag: 1787338605-171675
X-HE-Meta: U2FsdGVkX1/0nELl5xH44hQiHqvSpmuChaOkbLyg3ugOcy0xO5G0ybh5nM2NA0ZMZMI4wRD/Zu3DIu/VBFRCm2TSrJjgBMPge56CDs+a2qKXiwuVTOY+VWELUrwIo863C2EiKPATeJQ1AFK18GJIsV3umhkQ2RlHp3bdrIf5P1+rQbe24tIyPh5qTUpeZ6ib2z3mA3LyxWAGfNoiEqlvNHskVe+OukH1DMzOCgr0l7QJOxUWgCQaLwiWc3f3m8bvAFqH4W4dAmjNwr6qiF/QuUfDvp+JXkxuPI3tCOSnwnuYhoqsPCLLrCY5Q6GPZMQ75Cjfl90KLK4YxvdlfUGX/MEvqVu2lWZxsdYgvKWocJNYTb5yjmW0+2/vVkvFWDWjcTFdMsRZWY7/uoNnYxIJn3LiCHNh943rawHG+BMSusH1WtcwBWsPHWVqqidcHQeZPzDRkb4w3jSptYtGuH77i2ReYMmoziQPCFD/QmdNO7XKJ0X0bXZWPWgFeXCYw+HgKXmqGnImpenC8RTBeb/lrj7gpt7gVpAd1PgfN+VMnGstkDn9Rsi0RNypsM6gewggzCFRWJU32KDYF009Z+mRlljeUPwmfLiNW+SmNSHvhYIQpe0/OHnUc3OM2ZQ/WCRrFCRy3kVXZVI1t/Jr/GAsmFIVjKaHhZdkd42Rff1SAOJvxfwNhp0wZgMrx32HFX1TAJJLPLuji08INvG1uzEAyjyv04fWkR9BZ/xVRXDrJQPlG5qd5tszac5dDSoX5OwpuwABDjAAalUFryZmUt+Dl/wjIG2XKFM6mp64JIHLX1mN6k9Ot4+GQFhad+F+3elPTwdLOP6IG2F4PrVs+QrBOYsjGyOEBUpjMJB9ZUBzQaSQiJZUEyB6p+4s4QoiY/qku9Th4SDoKS37v9mC3ZKWzaZ06UImNCiE2upEW3QdC80RHWJf89GKhhw6v9rJ0ezK9HpLQo46t6MJOjLe6vq
 JUhN1S/f
 qOfVkmFXQ4D+1HDj2RBxU+D+j9/1Vu5RjmG3OQwN9KXML2pf6Qr9G4xgdmHARKvWCoceYhmA54v6X1jSc+RW3FkqNbVwLTFc+Rx5T/c0OahFulE8FDXI7Fhqd6NRsy/vBk/h1P3IosfJ15oTYVCGAGil8oOfeI6G+ip4IBbuYghWHngrxhWxvMSfEUqM2KRqymGu6q/9xwd44usiR5LBdkdeHxDnS96Ojk21biY2VqaWFsekFVFhQPYwhoovN5GWRi8R8yzYxtLLOzJtirarqKazYZmiwku/qk8QEpKrFU5NBremhj9eDSZD8V7SZiIL3ai4LPJAyZYm0Vr5NFSTHlAYhL/r4QfjLMVM3H68b3T6XO2amBqOd6BDKMxIBvZaY1od/ZtTtVJqR/9k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 09:51:07PM +0200, Jann Horn wrote:
> On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a process can
> only create anonymous executable memory via /proc/self/mem if it has one
> of:
>
>  - EXECMEM (like for other methods of creating anonymous executable pages)
>  - PTRACE (like when using /proc/$pid/mem of another process)
>
> This closes a hole in EXECMEM enforcement that Project Zero has used in a
> remote Android exploit chain:
> It was possible to use a memory corruption bug in a service without EXECMEM
> permission to overwrite executable code via /proc/self/mem, which made it
> possible to load and run shellcode with a kernel exploit.
>
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  security/selinux/hooks.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 18dd28b2bb13..905137c47321 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -2157,6 +2157,32 @@ static int selinux_ptrace_traceme(struct task_struct *parent)
>  			    SECCLASS_PROCESS, PROCESS__PTRACE, NULL);
>  }
>
> +/*
> + * Decide whether it should be possible to read non-readable VMAs and write
> + * non-writable VMAs via /proc/self/mem.
> + * This only applies to systems configured with PROC_MEM_FORCE_ALWAYS, and only
> + * triggers on accesses that are not visible to selinux_ptrace_access_check().

It might be worth mentioning may_access_mm() here, and obviously propagate the
suggested name change introspection -> opened_by_owner or fd_from_order maybe
even?

> + *
> + * This allows a process to overwrite read-only code in its own address space.
> + *
> + * Creating an audit record on denial doesn't make sense here, since we can't
> + * tell whether FOLL_FORCE matters for the accessed VMAs.
> + */
> +static int selinux_introspect_mem_foll_force(const struct cred *subject)
> +{
> +	struct av_decision avd;
> +	int rc;
> +	u32 sid = cred_sid(subject);
> +
> +	/* Allow if the process is generally allowed to have executable anonymous memory. */
> +	rc = avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, PROCESS__EXECMEM, 0, &avd);

But does it make sense for the shared-by-fd case? In that case you're now
updating execmem for another process's memory right?



> +
> +	/* Also allow if selinux_ptrace_access_check() would allow it. */
> +	if (rc)
> +		rc = avc_has_perm_noaudit(sid, sid, SECCLASS_PROCESS, PROCESS__PTRACE, 0, &avd);
> +	return rc;
> +}
> +
>  static int selinux_capget(const struct task_struct *target, kernel_cap_t *effective,
>  			  kernel_cap_t *inheritable, kernel_cap_t *permitted)
>  {
> @@ -7558,6 +7584,7 @@ static struct security_hook_list selinux_hooks[] __ro_after_init = {
>
>  	LSM_HOOK_INIT(ptrace_access_check, selinux_ptrace_access_check),
>  	LSM_HOOK_INIT(ptrace_traceme, selinux_ptrace_traceme),
> +	LSM_HOOK_INIT(introspect_mem_foll_force, selinux_introspect_mem_foll_force),
>  	LSM_HOOK_INIT(capget, selinux_capget),
>  	LSM_HOOK_INIT(capset, selinux_capset),
>  	LSM_HOOK_INIT(capable, selinux_capable),
>
> --
> 2.55.0.737.g08866a6d13-goog
>

--
Cheers, Lorenzo

