Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB630C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A666B008C; Tue, 15 Sep 2026 13:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA4836B0092; Tue, 15 Sep 2026 13:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96C316B0093; Tue, 15 Sep 2026 13:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 626CE6B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:04:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F40971A04C7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:04:09 +0000 (UTC)
X-FDA: 85216619418.17.71318A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4AA9E14000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:04:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WRG+dve/";
	spf=pass (imf23.hostedemail.com: domain of sergeh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sergeh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789491848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQzh3VGckL53Mndb/s9icBKbUyH8gPEYoAfCQcTHMv8=;
	b=jCzwp4RETvLSr9adJdoSCkCFLo9kFLgKO/vVw2kQ2kruyCZ9qZyJKqqKUuHCNs3XujXozL
	4wK7cDklhLgGQhEPHY37KeY/4+eLx5Fxx4Mz2NZNFTWmgFKyXadDk7uqp7KVVsIXqGg5CP
	Xy+hur5+JyVIL4BV6dOpmJ1IjyegA24=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WRG+dve/";
	spf=pass (imf23.hostedemail.com: domain of sergeh@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sergeh@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789491848;
	b=BNsfyBnLTQcrAonTMH2TEwRB+KwjXfc8ZbLYOwb0ibS1l9/bl0uPjswhkFIjnRdp3dEQVz
	cJmvPV8PSZcxolgbIiHTbClD/xZrVm/f/kn+B+qJR0AjkD3leFy9qYaeVU2tmv+JITBEge
	4uPcVthF0/qzxctHvHX/akKsYwble1o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B0BFA602C5;
	Tue, 15 Sep 2026 17:04:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351091F000FF;
	Tue, 15 Sep 2026 17:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789491847;
	bh=PQzh3VGckL53Mndb/s9icBKbUyH8gPEYoAfCQcTHMv8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WRG+dve/iOrdQlsX6mrm2ROLt8HNIAmXP0TjZwot1akZghPwDQpk9LA7Cl2xzNmBN
	 QGMi+zcjyBU46HINFulvtdJcFRqcc0K41hX0W0PFfUMn45aOEXZoQFNvjr9TLVECTi
	 7CZMo8dNZEMOYqZbh5KvglLerLodgm3zExj2AJQNmtCJ0OiqXNCuKl1p4ZFENZcxKr
	 sSCtU5j2RXL273vrOWqtWPjLFye4dTJrQsRN41l8K3h7jpLNJXzGkNgwEVMFur2QlS
	 jIqY6OV5Szw6LMjfqTMI96VMnfYSjVe9+siSqyFkosH2Y9SPBr7Euj9vrzCOf8ti44
	 sbXzIkrE+QEFQ==
Date: Tue, 15 Sep 2026 12:04:03 -0500
From: "Serge Hallyn (AMD)" <sergeh@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Jeff Xu <jeffxu@google.com>,
	=?iso-8859-1?Q?Thi=E9baud?= Weksteen <tweek@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH v3 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <aql6gyQJoxEjx0xY@shallyn-amd>
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
 <20260907-selinux-pokemem-v3-2-0bafbaeafe50@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260907-selinux-pokemem-v3-2-0bafbaeafe50@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4AA9E14000A
X-Stat-Signature: rcdx5tcxwbay7r1bk669amc41augrfaa
X-Rspam-User: 
X-HE-Tag: 1789491848-807694
X-HE-Meta: U2FsdGVkX1/ieDfi6fz1v+cbbWtgCVirn78BKs4oPXX92fLo0sxlXmmYQTe0tbNRMv60G3rMplr0SovoAgpJ0vMqb4mWhpS35wVHzcH+gciaE+vssUujjiyLyVgWhFaILMcs2G1czSuO7uI5HmgXJH4qdq+h5Lb+3BZ6limE7ySmfjvsQ1dQVg76zTn5xtRtjLZLI/jt7UUQZs4FnmnxhnnEeVAS5LREHo+iAilyvbEVXn7yTnqqLkAy5NTEDEKdLpzphd0/SuVCI+C/MwuFTIDjmxzg3N0a6bQqi3H6bWQQGqU7jT3hN9MMTQxEyHb2ZoGCCrNMVTLQXhl3Vq6fogynHep4MPkQUGTfUxXxCfQMAWaOwDNbW11pQ/sgwg3u9+39pAxmTr7ZuqLaOHRNyMu8TKHnDMWd/wz1dvxlNgnpnj3dTzlQawoSFy9sJnuEqlB+b6/OLlI2R1y2dKtrxigEGL8vX/oG2sIuw0x/PTCBE9mHM9WrV3oNdmu8lYo01zzRHJ7aN3zEW/2xxU9QKWK4SVK9EjvZ/L686KOP+j1VU8C+M1ER8BTjJfSOQZ4q3X1tJ3XOWgk/QNXEDfkWGirsD6a7tsNka9ipgV+TgLwrs8Ga8jieLV2b211GmKm6lQY4GO0y2AHcxt97kZzyzeHl2kSIh3Y4v0dShrkM/0fUVwgtbbAnP0/8PKfKk2lILz266UY25aAbime9ncRtxTCAuOpOarsKiGN7y//7SWAauuHaDMF6OhGXy/cd7r094+jtxgAyXk3RgYTHQXjt5r60rasQA9PHxwgRi4rQRKyy3aIxKb5+9M5giN1y+YM0YCcmBnq2SCe/5y8Dzb98b3P2Ga/MOOLwxHgqedeN12XZKiRkbyV5GXQeHn16QDpyOnBslcTHekylXr3pjxb+5cDD3XCUTQ6p1YrTLVI1IMUjxtpazPWfb1OsY7ejoZVtXld4FDPoG1pAo1+P7Y5
 qheSrBUe
 bmJgu2lvA1MwP+tmcBxcmZOajGc+ltxsgY2pEfFHiI41DIP7EtfK+75rY8AAPZUUJPl1aY6Gskjiisj6+WpJedWo6J3OOx+HdUP9UNKqSFV87HE0p7X1uaBy7hqSJ9K5OrnfNKxfcOQsr3rb1/XCn/quwmRHfDYh5OWPGq8bm0TJTncdYRjvVb+GVpnvQq5v06iW4UNCxmQpArYHz0lL6NrAZ/Xv73shCdzpJzysnRo3rKx5HlOZURC2pmTWRuzKgZmaU0H+vp8dgI7ag2vcxCzbbUCjEV1ELarNja4rvSjDfGjHJAhZPKCvSe7vTMfCMbkDZUvY6njA2yEr8ise9cfiTLJs+Ru/M2hh2i7EW95jOl2xK2EsndJNy9VmDqhzrrdxifAZzj7hIOmODbEOSs8AvNyGvjkrxjsoH9A8dqx2SSUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 11:00:17PM +0200, Jann Horn wrote:
> If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently have no
> good opportunity to block a process from overwriting read-only code in its
> own address space through FOLL_FORCE writes via /proc/self/mem.
> The security_ptrace_access_check() LSM hook is bypassed when a process
> opens /proc/self/mem because this is considered "introspection".
> 
> This causes a hole in SELinux EXECMEM enforcement, which tries to ensure
> that a process cannot create executable anonymous pages.
> 
> PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> accesses are only possible when the LSM allows ptrace() attachment; but it
> is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> environments running lots of third-party code, such as Android.
> 
> So, introduce a new LSM hook that can forbid FOLL_FORCE specifically for
> such "introspective" accesses.
> 
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  fs/proc/base.c                | 14 ++++++++++++--
>  include/linux/lsm_hook_defs.h |  1 +
>  include/linux/security.h      |  7 +++++++
>  security/security.c           | 25 +++++++++++++++++++++++++
>  4 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index bec6197329dc..295b21203c7f 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -851,6 +851,11 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
>  /* private_data for proc_mem_operations */
>  struct mem_private {
>  	struct mm_struct *mm;
> +	/*
> +	 * Was the ptrace access check on open bypassed because the opener used
> +	 * the same MM (introspection)?
> +	 */
> +	bool opened_by_owner;
>  };
>  
>  static int mem_open(struct inode *inode, struct file *file)
> @@ -864,12 +869,14 @@ static int mem_open(struct inode *inode, struct file *file)
>  	priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
>  	if (IS_ERR_OR_NULL(priv->mm))
>  		return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> +	priv->opened_by_owner = priv->mm == current->mm;
>  	file->private_data = no_free_ptr(priv);
>  	return 0;
>  }
>  
>  static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
>  {
> +	struct mem_private *priv = file->private_data;
>  	struct task_struct *task;
>  	bool ptrace_active = false;
>  
> @@ -884,10 +891,13 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
>  					READ_ONCE(task->parent) == current;
>  			put_task_struct(task);
>  		}
> -		return ptrace_active;
> +		if (!ptrace_active)
> +			return false;
> +		break;
>  	default:
> -		return true;
> +		break;
>  	}
> +	return security_mem_foll_force(file->f_cred, priv->opened_by_owner) == 0;
>  }
>  
>  static ssize_t mem_rw(struct file *file, char __user *buf,
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 65c9609ec207..12f84a1e6fab 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -36,6 +36,7 @@ LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
>  LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
>  	 unsigned int mode)
>  LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
> +LSM_HOOK(int, 0, mem_foll_force, const struct cred *subject, bool opened_by_owner)
>  LSM_HOOK(int, 0, capget, const struct task_struct *target, kernel_cap_t *effective,
>  	 kernel_cap_t *inheritable, kernel_cap_t *permitted)
>  LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 153e9043058f..e8bc2e644241 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -338,6 +338,7 @@ int security_binder_transfer_file(const struct cred *from,
>  				  const struct cred *to, const struct file *file);
>  int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
>  int security_ptrace_traceme(struct task_struct *parent);
> +int security_mem_foll_force(const struct cred *subject, bool opened_by_owner);
>  int security_capget(const struct task_struct *target,
>  		    kernel_cap_t *effective,
>  		    kernel_cap_t *inheritable,
> @@ -676,6 +677,12 @@ static inline int security_ptrace_traceme(struct task_struct *parent)
>  	return cap_ptrace_traceme(parent);
>  }
>  
> +static inline int security_mem_foll_force(const struct cred *subject,
> +					  bool opened_by_owner)
> +{
> +	return 0;
> +}
> +
>  static inline int security_capget(const struct task_struct *target,
>  				   kernel_cap_t *effective,
>  				   kernel_cap_t *inheritable,
> diff --git a/security/security.c b/security/security.c
> index 71aea8fdf014..2cde1efdb7a6 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -595,6 +595,31 @@ int security_ptrace_traceme(struct task_struct *parent)
>  	return call_int_hook(ptrace_traceme, parent);
>  }
>  
> +/**
> + * security_mem_foll_force() - Check if FOLL_FORCE is allowed
> + * @subject: credentials using which /proc/$pid/mem was opened
> + * @opened_by_owner: whether checks on open() were bypassed because the opener
> + *                   has the same MM as the target
> + *
> + * Check if FOLL_FORCE is allowed for accessing process memory through
> + * /proc/$pid/mem. opened_by_owner signals whether the opener's MM was the same
> + * as the target MM, meaning the security_ptrace_access_check() hook was
> + * bypassed on open().
> + * (Current current->mm does not matter for this; for example, if write() is
> + * called on an FD that was received from another process which obtained it with
> + * open("/proc/self/mem"), @opened_by_owner is still true.)
> + *
> + * Note that this hook is only designed to be useful in the opened_by_owner
> + * case, where the subject credentials effectively also describe the object.

Given this, would it make more sense to call the hook something
like `security_mem_foll_force_self()` and only call it in the
opened_by_owner==true case?

I only suggest it because it seems to lower the cognitive load
when looking at this code, so it might make it easier to maintain.

> + *
> + * Return: Returns 0 if permission is granted.
> + */
> +int security_mem_foll_force(const struct cred *subject,
> +					    bool opened_by_owner)
> +{
> +	return call_int_hook(mem_foll_force, subject, opened_by_owner);
> +}
> +
>  /**
>   * security_capget() - Get the capability sets for a process
>   * @target: target process
> 
> -- 
> 2.55.0.1003.g10538fe699-goog
> 

