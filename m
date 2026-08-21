Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0965BC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 19:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1700B6B00B6; Fri, 21 Aug 2026 15:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1215E6B00B7; Fri, 21 Aug 2026 15:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00F966B00B8; Fri, 21 Aug 2026 15:00:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7A556B00B6
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:00:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BC9FA2BD2
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:00:47 +0000 (UTC)
X-FDA: 85126193334.29.DF452BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 88D8A40011
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 19:00:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PvGzyhO/";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEagc8SPvaN9Oa8aVDhOR1OaWuRI/QhLc1rk2xR/OeI=;
	b=JfAO1ev2zY1uBQdrJVPGTJlvoccJ20qvX7y6wlGtRfkwCpmKbikpXgqeBxlH4FgRzve+2k
	OxDD4YJ5l5qKaeoc6pX1c/TjhJsVTm/lySE2TJPKXK24et5fQyNOBu01Fco+w0mffWnCpA
	NaqfbSZHdeGJsQQoPYMG+a3eWxxjufk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="PvGzyhO/";
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338845;
	b=5VGyo9Lj+CsRknANo8MlJa5y9HByo118XOtationtb0sQg9I+XWFtuE24t5KjQtKP3UJqD
	33oCI/mfj3bnJpeF/ED1wHybTvC6yO54omAhD+kXjyFvb3d88aiDHYjWmYIm1UiJcmyMov
	NtagaXrnxnFBC6dDh8ICvoC8EirBaVo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A123D43A96;
	Fri, 21 Aug 2026 19:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51E5C1F00A3D;
	Fri, 21 Aug 2026 19:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787338844;
	bh=IEagc8SPvaN9Oa8aVDhOR1OaWuRI/QhLc1rk2xR/OeI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PvGzyhO/TCg78i4TiCwfMnJRwrKx7JYZd3h0Y7oeoimxcZzu3dVhDc9n3IV3Hxx5x
	 wRuCEK/MZio1uqv0KZr8DYt9EI6twnrrm0D71OOF9CgvLRk0NWVDoJHUvN0YkHXlJK
	 sCRdrQhAcH9dogaUc3//75WN6R9lMm/InG/xkGpiiCmcAJqdwZGtTp0Ev80CmflA4q
	 ofmSK00z5G2iiA1fcljuDrSbJcoFhQX2LhkmvOyofNUYlfXehJD/fqUl/CS+jeYcIl
	 4hzD/J0JgIZrP3oJdw68GrBwXNAgDrZzjs5+IkT9z4XX2Lb2SpRCgr39slcYaB0hpe
	 hfx8qAZhxA2Lw==
Date: Fri, 21 Aug 2026 20:00:36 +0100
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
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <aoifijlkCRzeO4bj@gremlin>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
X-Stat-Signature: r4as66qcshne5igftnhg6yu71sq47nst
X-Rspamd-Queue-Id: 88D8A40011
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787338845-930881
X-HE-Meta: U2FsdGVkX1/kfL+y7YPcmKGxcHbWnmWo8b0Mskv+eNP6I/HsgnbZ62SgbKnZdBCzuvEm0/jvchUdYXGp2fsZy8M1WOzunJ0GSKD3EsAMS6fEfl6gu+ZrWdv56St10Y4wxXPniPJZZuWbVISzc5GJgwXFala/LM9pGwD4hZsK4l2VXRd9XmG0JxwKG9Ksl/yWzIyrIc9Irp2qL5GCk2MwDrU6pi51dX+EfHdFezwnkwkbpJgdzSImHVtrHN5UkdniBahc1SjP39xn/jzgZOEl1egluoWsa21Ec+FO+Du5QlM2xsQ97hXSCm38IWdzdfNevXebD77xRwPlUy2U89xpTmVHXrXbSvpPHqZEHhfpJIUJyc5ORs2CsRdf/6w12h1BlwTWDzRhKnXBQGCpSyqtypI7wyqdx05PRRKGt3xd2tU5j3zHqpbE3fIxGHUfSFCTS1NJN43oeth1SIN3ACHtOQtEpjyzhk9L59GAkdq7gqf35LTAIWYgjcIuN71DF19Uz+HqHr7swAbOssRb9F0y5g7998k5VQAwsNOjwT0OPSMIyYREfRRzMoHk8hht7n/siV6qDjkaxIlOIaeuGqC8flIHs/04N/seN0UP15jDdCe0CF8HhKjm10rRpFmbicC3oyiuOZhD5NM7wISOckHZzhHYMXYd7AZLANjJbcgtf4FOSRgPMzf/zYXNycd1s9U9XkPue1ZJotOyWt8symtc5rCMljykOfShZw9X1xdQ5grTapHmpcgSumTrFJrDhj07ELfGb8Ne8F7RFTUZKMmihhn/uSxjGJB5pNJeMeKOsziZO02LPf92tADcGe29y53jPQh3jpDYxbBXTkRT8oK68Z+cnado+/Lq8LibN3nszdALcJuxKAFRZ+vMtUHEUec+ri8Jy00LA+dUzS8vxpUXOC4KBze8Hb/LjBlRRUPYpFHGMGVa+MWk1zwOSvae9G0sh5YfWdwLkoJuTEC39L+
 5P9R4wut
 BDd2x7dAr3JXwJDcINzhfDX5LdVB20EKtKc6s52NLdk93Xxik8PZjhgZZG5J1S91bxpIrJtUKQ1jUBZglodkg/GRkwGKah90vyZ2H70po14H+LuqAGMzHUgThPjP/G7S3Og3pYZTt1XiIe8siZw2BjmUyClWrQVodb2JsOLA1H2PmGcFB2BYIQE8bZbzyWm0n6OkJmRtUEC4yIH05Ep1IHsIOpYJiLn6p4xNLg2Ad+Kd07iloZ2aXpvDoFEGJK3KHaTc/0B7cqHMqHUtaQQo3Ig0xvWI53juzoxs45VKEIBH+KA5oyoiiZ/LfUWNnYAxIcG764cmL00DfkY67atolVGFmYkKCe22eGafl5djncI9akDj+7VDB4WLc7VYs4SR1IAvH/j/aqNinmgujPFp2Ycl/Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 09:51:06PM +0200, Jann Horn wrote:
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
> Signed-off-by: Jann Horn <jannh@google.com>
> ---
>  fs/proc/base.c                |  6 ++++++
>  include/linux/lsm_hook_defs.h |  1 +
>  include/linux/security.h      |  6 ++++++
>  security/security.c           | 15 +++++++++++++++
>  4 files changed, 28 insertions(+)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index bec6197329dc..3dfaef49bb70 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -851,6 +851,8 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
>  /* private_data for proc_mem_operations */
>  struct mem_private {
>  	struct mm_struct *mm;
> +	/* Was the ptrace access check bypassed due to introspection? */
> +	bool introspection;
>  };
>
>  static int mem_open(struct inode *inode, struct file *file)
> @@ -864,12 +866,14 @@ static int mem_open(struct inode *inode, struct file *file)
>  	priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
>  	if (IS_ERR_OR_NULL(priv->mm))
>  		return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> +	priv->introspection = priv->mm == current->mm;
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
> @@ -886,6 +890,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
>  		}
>  		return ptrace_active;
>  	default:
> +		if (priv->introspection)
> +			return security_introspect_mem_foll_force(file->f_cred) == 0;

As per 3/3 I wonder if you need an additional parameter to cover the fd -> some
other process case?

Like:
	if (priv->owned_by_owner) {
		const bool is_remote = current->mm != priv->mm;

		return !security_fd_from_owner_mem_foll_force(file->f_cred,
				is_remote);
	}

(I'm not sure how LSM hooks are supposed to look :)

>  		return true;
>  	}
>  }
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 65c9609ec207..67452f71bedf 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -36,6 +36,7 @@ LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
>  LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
>  	 unsigned int mode)
>  LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
> +LSM_HOOK(int, 0, introspect_mem_foll_force, const struct cred *subject)
>  LSM_HOOK(int, 0, capget, const struct task_struct *target, kernel_cap_t *effective,
>  	 kernel_cap_t *inheritable, kernel_cap_t *permitted)
>  LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 153e9043058f..f8483be58bc8 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -338,6 +338,7 @@ int security_binder_transfer_file(const struct cred *from,
>  				  const struct cred *to, const struct file *file);
>  int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
>  int security_ptrace_traceme(struct task_struct *parent);
> +int security_introspect_mem_foll_force(const struct cred *subject);
>  int security_capget(const struct task_struct *target,
>  		    kernel_cap_t *effective,
>  		    kernel_cap_t *inheritable,
> @@ -676,6 +677,11 @@ static inline int security_ptrace_traceme(struct task_struct *parent)
>  	return cap_ptrace_traceme(parent);
>  }
>
> +static inline int security_introspect_mem_foll_force(const struct cred *subject)
> +{
> +	return 0;
> +}
> +
>  static inline int security_capget(const struct task_struct *target,
>  				   kernel_cap_t *effective,
>  				   kernel_cap_t *inheritable,
> diff --git a/security/security.c b/security/security.c
> index 71aea8fdf014..d0f790a534eb 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -595,6 +595,21 @@ int security_ptrace_traceme(struct task_struct *parent)
>  	return call_int_hook(ptrace_traceme, parent);
>  }
>
> +/**
> + * security_introspect_mem_foll_force() - Check if introspective FOLL_FORCE is allowed
> + * @subject: credentials of the process accessing its own memory
> + *
> + * Check if FOLL_FORCE is allowed for a process accessing its own memory, which
> + * bypasses the security_ptrace_access_check() hook.

This should be updated to also explicitly mention the fd case. As surely in that
case this is not true? Unless I'm missing something.

> + * This is only used when the system is configured with PROC_MEM_FORCE_ALWAYS.
> + *
> + * Return: Returns 0 if permission is granted.
> + */
> +int security_introspect_mem_foll_force(const struct cred *subject)
> +{
> +	return call_int_hook(introspect_mem_foll_force, subject);
> +}
> +
>  /**
>   * security_capget() - Get the capability sets for a process
>   * @target: target process
>
> --
> 2.55.0.737.g08866a6d13-goog
>

--
Cheers, Lorenzo

