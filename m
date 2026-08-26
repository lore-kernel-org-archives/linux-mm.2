Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD30FC5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 615366B0088; Wed, 26 Aug 2026 09:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5ECFB6B0092; Wed, 26 Aug 2026 09:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529896B0095; Wed, 26 Aug 2026 09:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2FCFF6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:07:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1C1C403B6
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:07:10 +0000 (UTC)
X-FDA: 85143446220.06.304C90B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 061954000F
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:07:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxEG+kxn;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787749629;
	b=vjMkh9mqVtZ/q8HO9wSXjNuLxE2fgDXTu3aEw0fn5AVf8mPv/FyJaHgNyeLymLvdLzNGfH
	goE5Z1NHX8l19Uj7eYbcDncaNzefLRx3GfG4ZV2K/iKQWQ1qL8BVaDn934htmXU5kJe+Hk
	W+rv11ZY6Qj0m95J8JwilEGUwx/ZHmY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787749629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N0uNhOoF0fsO+S9VbNFdNjCWH58LGVPdM6KbXTCpaA4=;
	b=SqDNkIuQWuwF7hwxSE9qDbG3Y3uM3B5hWOHbIH128sXb99htACCROv9NwxOsnuydiLhXtB
	m45ffFeWuMXlv26RvXqugRjC/g+wes0qhngvv3cuNV8Yi+wE0b29lvqi0nT7b0SLFaCxol
	1IYttHxo1cmbwjDTcCBcIn3EMoY7hzI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NxEG+kxn;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 87C074182C;
	Wed, 26 Aug 2026 13:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857CE1F000E9;
	Wed, 26 Aug 2026 13:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787749627;
	bh=N0uNhOoF0fsO+S9VbNFdNjCWH58LGVPdM6KbXTCpaA4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NxEG+kxnT6FOnlnSVrSWAVpAwTa7C5QXPrvPYzfYGHPS9FRNdKlXul8HG8zGK8elf
	 0mygCqOfR9eM3G+dQWdg/bMGnFWpcK2y8v4Yclu6jZMtaLboZWmhcv42qxKucUSKFP
	 klimZ00U2FyUxGwskveMz1JD1boi8Z7yoZ0o18WqhCyQyYbxFq6O8mJq/8BuUCK+rw
	 X28C16uva8QqUxBsalSioByWTAnep1PC9q0C9uJ+8+5S50+0X8O1fmOurQORIC978i
	 4NYcPfTIvqas2AY0e9QaKcmIFCW7ZeLQTXg6L2jmmIVYWqK/pIVylvBOqv8wMV0jF+
	 9vSuVy515ZNHg==
Date: Wed, 26 Aug 2026 14:06:59 +0100
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
Subject: Re: [PATCH v2 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <ao7kzYoGRrhkaoB4@gremlin>
References: <20260825-selinux-pokemem-v2-0-b46bc64916d8@google.com>
 <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 061954000F
X-Stat-Signature: bmigmsg5egho3jjx77fkog8875na6ocw
X-HE-Tag: 1787749628-990819
X-HE-Meta: U2FsdGVkX18Q3BCMcV4BxoRjF9pQFn+qrGwnAMTZhac2trnlp1HCoi4ERPRxTs5pWYTCdJT9D2fLIEbsV8mV9QLqXMfwdFRNAFt+1X7G5jRsa7puZP7ErhgGanr3iFW1WbwA1ye3blMzeJzsT4zL74CGBsWH6f3Qz+gjLDz2G5j7jWETyYVtsaaocCnYSddJQghazgB5eyNoDqVVAm9CVU+1wmwd2POwqW2e7oZkrkRaNpuQkw6BJ0qqpgJ+6l4lhxaxNKyzwKWdAv3Ivp4j7xyGnHMXhFl+C8thEVq1YjORfeoeAimgPxFUXF6krPROoA7xaycuIGJYquGdDC5I+Tzh67P/DIi51anoy6X2lldO/6YGFDV2XjAg7+tH7vxM+pfVcqH3QAeEGIZ4G7PGkhj0JMnx9Nqyhulkm5Czxx4OLyxfhYubU8aQAgQNi0Q4UKNHRNw/X8OUSVJaowGFcx+Ov8kkPnOL95pO3Fzl8L3Q6kphzzseUaVff4cneATYOLmSLFeR8naJ9LXrmeFpSG3Q9BYVF6U1EctGRIJthMCmBAso7kCrtfNWgB2tehNU5hLrcC95G0oEEAne43ADXmv5ZfK06Ui14qcU0AL/GfFibnUPo/FILJlHHnrnBvvs5i5CDRGCYxXjwy2eHoIoUnMfBdMIO2FEz9pl/TiCnFWGtcZ2TXVwmtukJy/1eL1yO0bvfPsp+kGmlp1ivKLxcUYY/HahDwqdB4Ii3PYck9NThZQdpaiZ9JP18Tjzyvci6X6gxg5KDFfmIERQk2GKojPTRcWfqYYnraD26m+a4R9sRUmRcwASPL26jhK1rJPey2hS2LZal9+BDgK/ZnkWm08qxBasGgQguhQDWYI3QuqmyZXLKBXv51XKQdGNp2qpZfeELVdrtPS8QJrn2iuiojwFWJ/yK/tRBv4+Q3U2Yu42+sFemcD9GuHaP6Z4cXFO+rC9HrnouvoDq6l/FjD
 D1EQR37y
 hSCV35C+klksG3wMmaB0c/81++1+h4aGE2n+u+6NYOcYp6nt9LVAiIy/KGDrs271Mbp3lvsxR3TpJKuW95G1st6ANCrPmldWW733kLQ9iLzz3LhqHIGM8TDRauTTmJ5LxJUVmGRl8wSmUXaYFG2/DjeOu1D2lVWlP6v/t/O2oUE9DFHOl883G01qER++kMWeJALX8PkFQldecKoeaw4YFTgS3kiJ2V6g7VkC8vwvo+A93QsLPaKMpKjqIODVWHUQeI4svNwHhX7b9GK7PCS4SeaNrrks9XQVrY3QUKNW5QPi5uoZH0QZs226ZoV5jtJ5mdc7F3Ryt5ADvxSsDIzxhk0Sg+SILEJJ4rpTj2ik0ypbz5VSBYBfSRyZgLtu2KqsBvePabgYt6w2sbJEICUN46h0Eko9l4W57sa6o0+Aey0oMstc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 08:39:18PM +0200, Jann Horn wrote:
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

Thanks for the name change! :)

Nothing stands out so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  fs/proc/base.c                |  9 +++++++++
>  include/linux/lsm_hook_defs.h |  1 +
>  include/linux/security.h      |  6 ++++++
>  security/security.c           | 20 ++++++++++++++++++++
>  4 files changed, 36 insertions(+)
>
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index bec6197329dc..dc6fdcb47b79 100644
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
> @@ -886,6 +893,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
>  		}
>  		return ptrace_active;
>  	default:
> +		if (priv->opened_by_owner)
> +			return security_mem_foll_force_opened_by_owner(file->f_cred) == 0;
>  		return true;
>  	}
>  }
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 65c9609ec207..50e3f0abc676 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -36,6 +36,7 @@ LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
>  LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
>  	 unsigned int mode)
>  LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
> +LSM_HOOK(int, 0, mem_foll_force_opened_by_owner, const struct cred *subject)
>  LSM_HOOK(int, 0, capget, const struct task_struct *target, kernel_cap_t *effective,
>  	 kernel_cap_t *inheritable, kernel_cap_t *permitted)
>  LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 153e9043058f..74eb876054b0 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -338,6 +338,7 @@ int security_binder_transfer_file(const struct cred *from,
>  				  const struct cred *to, const struct file *file);
>  int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
>  int security_ptrace_traceme(struct task_struct *parent);
> +int security_mem_foll_force_opened_by_owner(const struct cred *subject);
>  int security_capget(const struct task_struct *target,
>  		    kernel_cap_t *effective,
>  		    kernel_cap_t *inheritable,
> @@ -676,6 +677,11 @@ static inline int security_ptrace_traceme(struct task_struct *parent)
>  	return cap_ptrace_traceme(parent);
>  }
>
> +static inline int security_mem_foll_force_opened_by_owner(const struct cred *subject)
> +{
> +	return 0;
> +}
> +
>  static inline int security_capget(const struct task_struct *target,
>  				   kernel_cap_t *effective,
>  				   kernel_cap_t *inheritable,
> diff --git a/security/security.c b/security/security.c
> index 71aea8fdf014..fff26ff65e07 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -595,6 +595,26 @@ int security_ptrace_traceme(struct task_struct *parent)
>  	return call_int_hook(ptrace_traceme, parent);
>  }
>
> +/**
> + * security_mem_foll_force_opened_by_owner() - Check if introspective FOLL_FORCE is allowed
> + * @subject: credentials of the process accessing its own memory
> + *
> + * Check if FOLL_FORCE is allowed for accessing process memory through
> + * /proc/$pid/mem in the case where the opener's MM was the same as the target
> + * MM, meaning the security_ptrace_access_check() hook was bypassed on open().
> + * (current->mm does not matter for this; for example, if write() is called on
> + * an FD that was received from another process which obtained it with
> + * open("/proc/self/mem"), this hook still runs.)
> + *
> + * This is only used when the system is configured with PROC_MEM_FORCE_ALWAYS.
> + *
> + * Return: Returns 0 if permission is granted.
> + */
> +int security_mem_foll_force_opened_by_owner(const struct cred *subject)
> +{
> +	return call_int_hook(mem_foll_force_opened_by_owner, subject);
> +}
> +
>  /**
>   * security_capget() - Get the capability sets for a process
>   * @target: target process
>
> --
> 2.55.0.860.g4b6b3295ed-goog
>

--
Cheers, Lorenzo

