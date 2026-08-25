Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8EE8C61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 13:19:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2A26B00B4; Tue, 25 Aug 2026 09:19:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53D66B00B6; Tue, 25 Aug 2026 09:19:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41AA6B00B7; Tue, 25 Aug 2026 09:19:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 95A0A6B00B4
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 09:19:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C945A03DD
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:19:36 +0000 (UTC)
X-FDA: 85139848752.02.83B280E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6619F40003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 13:19:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irA18ZYw;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787663974;
	b=fgO8GuepE0ulwCE4+JWSzMaV1v35Yl6UtXL7Vmgo/zZqCzsxE5M5ygacAFpPFD/1DNBlNU
	U422SDPKI1PVkapQg1MbF9KYqreIm/+xsY1HO0/c9sKNE6XI3P/tpVIfhcGViHoQcXN7CI
	Pra1CfzOFlPH3ZHoFD3RnMClVmOvdDc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irA18ZYw;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787663974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/S8lJXP4Su77nb9Qz5npefmL7dibQbuTDmwSH7ctnBQ=;
	b=snL4tGf54WFcA0ys8/mwTdX/l/+5Zz7rKDwIUUQ/gns0B8Bv+JsGCZNQ9Zozknc5Cy6WUc
	8IXt8HQP5LN4nDmZ6GR6bL5p86Y8UGHu0YsmEWb1iTw4HcJSqJ8SHgzqTXjmXc4r6XKxNq
	+HcbhwmwzIlOZZuKmGR5bUAp0ODIlrw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AE8BD40789;
	Tue, 25 Aug 2026 13:19:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53AEF1F000E9;
	Tue, 25 Aug 2026 13:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787663973;
	bh=/S8lJXP4Su77nb9Qz5npefmL7dibQbuTDmwSH7ctnBQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=irA18ZYwPthr+6QDgVK5lD+/BFmBQ/ISwoKbz6KWGhRcXqHCqhjYsah0If9m4jhnd
	 IeG1WnsJmKgUnPFOTdDKk0OXHmdE7NXrm9L/gGZALrxuqFgZMP3ECaflyJEmgie+NV
	 K0diRUSxGq00KjTwDJoZUMhcoDs6Itv9TT+jsPus6UBbRUrXl4/BN9ER7A9bm/gQ+7
	 +E+IGbgQAa5IaQiSTwRcUe8SiVVR7/mpfWAvIdKLwM0Ub/KgAgW+JEblIBGzYnEt0W
	 C720h9N71y02pCFVqiciA/FJP4JOJC3YP+qSLNhgd2sOdVJ4b11JbgqnZHyqvnWAZH
	 vpKBRRFgaC3+g==
Date: Tue, 25 Aug 2026 15:19:27 +0200
From: Christian Brauner <brauner@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <20260825-unweigerlich-biotechnologie-abnormal-accff844337f@brauner>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
X-Rspamd-Queue-Id: 6619F40003
X-Rspam-User: 
X-Stat-Signature: to4si7ai1m7rtcdeq6xf5b78s3ktmc1f
X-Rspamd-Server: rspam06
X-HE-Tag: 1787663974-503814
X-HE-Meta: U2FsdGVkX1/4mOkGB8SQ7VbjJNWzGufDy4RY/O9lt2fNk9CunoOFs6XKw4pKDRW4fOYRBRIbEZebi81pZNkdPqCodLwAoeublU0ocu0Opr/ZsKi7P/Qja5WBj3gpk/bWRfTCYpHDMfskcpEvpFeWQokpmT3B0W6jsPZw17LxnUGMb113cDItb+DE83j8Zg66l+/gGIGSgydrfsi4jnHgM+b4KxI4m/2wnNUwM0Kdik6YWTi3q1t0n7SzrSMq4H8vF9zkhdevjDSQxNc/MjUfs54Yrj3zEC6Lni/treQ81gwdD4MUViAqN+pG03w1mabp9pHvqMYEOHJ4rY8UyMjUqqpRpAJCJyzaSZ2nsNDtYSYM1bUMj7xzz+NAqslhEV1KKCCQCKu+DUZ7JSdnGq7P+R72OC2oWnFmam8EIZvgx3ZIe+IaKSBaY0ZSQntzsyMP9REGNqUMHWKmeDkJAsb1jmOSUy64J7RYZEocq/ri3xBx74l0Y5brIHfoMT6OySLU8OKUd3McbbzmhsO7TYpztnaF+Xv2O7nV+WNiCZirL0tp+Xm+avuIh+YAA93YtHOAx162oYu3b0AROx9fLfca78T32W4tI5srYYZ9o/6K5CMRNDy4RFKIjG4BcnTOVk5DTe/VApyGULRcEjkp7oJFU/Irg6Qr8XwlDwwvlPOoOHcC7Xlrnpd99hJMMm3YLtKgwJPmVzo2MxxvgnytkKykB7t5s1jeX3IGXguBJ9cU8Cj9AEXch8AdxFKio41zxqMTz5m+mC8EE6C0nFhTpUCRnosxPHir3rGIbVt549hCwIB+zeRJvCwN6+2oICRvJ9PsuIN/ycjdTW7GjJ+y0wEG9H8TvGxjpff9XtIpYxIEKibQMtOak3pXrjXeJfT5CLN+PHn4sJlWOjBWF9EfgSOqBcqq7EhXVRlfhzElFrT0k5iB9jmskcF3lgujDtXKdappSIT7EWsYn7mmge+tozN
 vsHCHEmk
 mhQIEK4E4B74meymoW0hwl3zzXcbi8k0OtcyhajnLhqIzBeIyAHir4xp/zzBMX7MW6II/ZZOVxOL7kDd+xpvQsdDcfGEuWspkGy1bVS2NUmLfeQCrULezgGExv3+wqjx0L9n0wJJ3QCZ9Howz84juv+rUXqa+uIbC6oLkyobGVHq4iu0FlVhA2ncJpOPb7JdYYuF90EiYNA/1sBUeETT8ldLSDneKSwcWhqD++TEujEkni3FsHbqsjIipFVAmVDXRgClfRT5hmfZwpM5IBwETLg6EifHojfsSvTvukwsukmyJ85gBdjbWfWriHCpbIOg+aC5JpBIbFSSt+RvPNoUJi/kLOybkxZjwmIHriCah6sZakGAKG/4Xs/6VEcPhUyeEbztw4QoKgARcfcPYXNlqJOc2CJzHFv8meY+/ct9KbZdwExb698wzlaa0C8bjGhqsoFkz
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

Hm. Why not pass the reason to security_introspect_mem_foll_force() and
call it unconditionally? Similarly it could also be called for the
active ptracer case. Then you'd just need to pass a flag to the security
hook and the LSM can decide based on that.

