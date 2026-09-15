Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0069DC88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 17:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAFBE6B0093; Tue, 15 Sep 2026 13:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86796B0095; Tue, 15 Sep 2026 13:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9C8A6B0096; Tue, 15 Sep 2026 13:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87F7E6B0093
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:54:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD9AD804F3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:54:30 +0000 (UTC)
X-FDA: 85216746300.17.4E9CE3F
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id 71CEA180002
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 17:54:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=PmIGImVV;
	dmarc=pass (policy=reject) header.from=hallyn.com;
	spf=pass (imf16.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789494868;
	b=pDPWFoJQ6HmsEOVfQs8V2B0Jlto5Ud9AqIqheaYytOSWktqUdxqV0+JuA3tAe/Tn2A9C1H
	j8wEY4pwUG0aqxgqhnn/3vPVMtiZ58AFtgRPTaepTvf4MVxZE/g0t3l4XlV1igiJ3eoJPF
	3gX4Rlfu81JmBYLAOMsVZ0aytI+wA3s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=hallyn.com header.s=mail header.b=PmIGImVV;
	dmarc=pass (policy=reject) header.from=hallyn.com;
	spf=pass (imf16.hostedemail.com: domain of serge@hallyn.com designates 178.63.66.53 as permitted sender) smtp.mailfrom=serge@hallyn.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789494868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IH0zQ66XAhM9RpaAtWgUh4AiWfH8DT36se5pdj+tfo=;
	b=2PSrovIAeYqreULP2uMz3e2Gi5JhQGcNEk+PIxTIJgiiKKRenJmVg+OtpuW1KeFS4/JnEF
	1CEL0PiqChPFpBqL4C47oVrdTrdTqBtyySO7bUKTVk44vnO99e02P9dcYu8+EafxayiS5d
	dV6vF9B1pxfNyEsvxQXCbjuqjogUseE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=hallyn.com; s=mail;
	t=1789494867; bh=v63FY1fnrEkx7QXoR+GSQJrHmBwDUBI7qUvyhgXbjJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PmIGImVVPLzOWAumb6PW4gmlneVv+6xM1ssscap9T86yUWBljn+p2Oe4CIeuTNomy
	 R4XRJJzbs/FHPhGufWGaj99v8F+0jNMEZR9RzNk06ts81sf+zoQMwDJY+zcgm8G6cG
	 gABgIEWhRHDeodGimlEH6KvdGSxsw/csqozdOy8UBNUlPxB1dBOb4nzjGcuQT6kEJc
	 UjwPqdVsqPdB/CKRGB4hODB73ZpqHpi+SpHqg2xATLd6qEeXP2LjMeqajlTf/Jzmzi
	 fiL8M2Q3os1jyaxpNS+cBkHGFPtj4pzkCY7a0M5IfkU9ChBuWtkG8io1mgHQ6xOC81
	 O8SwtEMelSm0w==
Received: by mail.hallyn.com (Postfix, from userid 1001)
	id 080F9D83; Tue, 15 Sep 2026 12:54:27 -0500 (CDT)
Date: Tue, 15 Sep 2026 12:54:27 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Paul Moore <paul@paul-moore.com>
Cc: "Serge Hallyn (AMD)" <sergeh@kernel.org>, Jann Horn <jannh@google.com>,
	James Morris <jmorris@namei.org>,
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
Message-ID: <aqmGU4rylUsH9LqA@hallyn.com>
References: <20260907-selinux-pokemem-v3-0-0bafbaeafe50@google.com>
 <20260907-selinux-pokemem-v3-2-0bafbaeafe50@google.com>
 <aql6gyQJoxEjx0xY@shallyn-amd>
 <CAHC9VhTjo+znkxBmvseCH1K3aJN18ZO7+6QGE-a+Sy6XN=uaMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHC9VhTjo+znkxBmvseCH1K3aJN18ZO7+6QGE-a+Sy6XN=uaMQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 71CEA180002
X-Stat-Signature: qzc63w9unp1e6yq5ctcdfoy1ziyuhah7
X-HE-Tag: 1789494868-281693
X-HE-Meta: U2FsdGVkX19JJwT9T7S9q+/2arehcDhLH5qlsYHpRfYyOa5jAojUddExhxsd/0whQIFKK5hIXXFZXieTM+aeC7FcTGwBlWTUlNPOHohC+NzSEIEXZObulfS34u+c59uP1oMfLH3MUUvUF0ywftGhF+UzLBkcCJXJIFchh1UcLHqtxi6JpLyScvyeuXNLlgre5k6bE/Yw+gnrPLET32n/vG3ThtuDyIoBj0HaUNqsd1IdWL8+keLlLoj1ZHZIXc3eH8KCeWh2VkZAU31YfG6dTct8ZP0wzMwUeHLTL/+n1pUCXxvbdDP5qzS6dcL9ObqomIQa2JXBFQGvZj9LM20eceU3vCeTCuPOHsKjdcq58U+9kpR7IeAAfZK3gRv3Y300Q1U1hU+v1UvU688ct1ufH11h+UzAPIKuyK/PpKbU0wh38FYDhVZDvF793Q5rv/yQPia0WmRF4SatPyi/Ut+qyaq1qGZMyEBgGrwJHlwka07TE9PHK8CS6tpxhNCi64YKgOxk2AHMdOnM2yQueAhtnpvlHWa2/Fb03oMx+jf+aFpbmmghHttO/U0bS2AYNkFUxJrpv6xA3NdMInNRKaWIz5sm5IUVtJYQU0WX14qR81tps6VwMZmGvzARGeUdzbywmxQQXNU+GpIluzMuR7cQ0XPi6qM8lZM/neCLPVQ9nkdgnjlBF/vING1c8j39E8wKVARtVUyA+0xw+5ET+tjWMJ6yllCl+TxL8dn4PdQmQtjK3hPOuC1g8scZ8lLcP3sremjWlQp5HGf2oJGqVpdb24XuXy8CrTSp7o1deVIbkvfktGvNP0jrAqpIyMFM9CWsEZcqnkFVqXRkiSjcLulZbMrU0LWVbu52tFIZ3VZqV7f4PqLMR5DJ1KNQzBvIi099VGsR4NWPw3d71R0xYQVrTMfbHWTkcvasqF6PcAprUxbQ6ZW94HM6RX/yxqvWbLP2S8UEAYIdygDtcFef9bN
 J3I2xBW5
 LslZmjfp47voUBQ8BaQjoWSmAbNFbhC/Xc4jqpxqGVMQimVVHgM0xpSdZ6Avcs8AwzeiU43aaZtulhAxv96qJr4HdWabavPI1CM0mJ5Gw4r51GdQFkZ36mtUPUECQ4tMRkLXyNI82A20Xbz64L+NtOG1Ob/rfrya2fU3EsH1NQQERQsGJypG8rN/veWHJwA++dqvIsoOgqcRLMN9kZrM1WzK6IRZbF0eabi9TnERqQzCwkEv6SPmWl/r3MfzMrMMfCcntrP72vZZNVJ9WLmErGkhCOE5OAL3utrZAnTIcaQBe9x+4uGLTAnPQIFR47DS2rlnPVnJnfO9wNzWD0Nvh6Eeqt+cZcJoIL4/WQXB45DeVAfDGQQIjKaYBsOfoMAGLVKOr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 15, 2026 at 01:24:27PM -0400, Paul Moore wrote:
> On Tue, Sep 15, 2026 at 1:04 PM Serge Hallyn (AMD) <sergeh@kernel.org> wrote:
> > On Mon, Sep 07, 2026 at 11:00:17PM +0200, Jann Horn wrote:
> > > If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently have no
> > > good opportunity to block a process from overwriting read-only code in its
> > > own address space through FOLL_FORCE writes via /proc/self/mem.
> > > The security_ptrace_access_check() LSM hook is bypassed when a process
> > > opens /proc/self/mem because this is considered "introspection".
> > >
> > > This causes a hole in SELinux EXECMEM enforcement, which tries to ensure
> > > that a process cannot create executable anonymous pages.
> > >
> > > PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> > > accesses are only possible when the LSM allows ptrace() attachment; but it
> > > is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> > > environments running lots of third-party code, such as Android.
> > >
> > > So, introduce a new LSM hook that can forbid FOLL_FORCE specifically for
> > > such "introspective" accesses.
> > >
> > > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > > Signed-off-by: Jann Horn <jannh@google.com>
> > > ---
> > >  fs/proc/base.c                | 14 ++++++++++++--
> > >  include/linux/lsm_hook_defs.h |  1 +
> > >  include/linux/security.h      |  7 +++++++
> > >  security/security.c           | 25 +++++++++++++++++++++++++
> > >  4 files changed, 45 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > > index bec6197329dc..295b21203c7f 100644
> > > --- a/fs/proc/base.c
> > > +++ b/fs/proc/base.c
> > > @@ -851,6 +851,11 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
> > >  /* private_data for proc_mem_operations */
> > >  struct mem_private {
> > >       struct mm_struct *mm;
> > > +     /*
> > > +      * Was the ptrace access check on open bypassed because the opener used
> > > +      * the same MM (introspection)?
> > > +      */
> > > +     bool opened_by_owner;
> > >  };
> > >
> > >  static int mem_open(struct inode *inode, struct file *file)
> > > @@ -864,12 +869,14 @@ static int mem_open(struct inode *inode, struct file *file)
> > >       priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
> > >       if (IS_ERR_OR_NULL(priv->mm))
> > >               return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> > > +     priv->opened_by_owner = priv->mm == current->mm;
> > >       file->private_data = no_free_ptr(priv);
> > >       return 0;
> > >  }
> > >
> > >  static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
> > >  {
> > > +     struct mem_private *priv = file->private_data;
> > >       struct task_struct *task;
> > >       bool ptrace_active = false;
> > >
> > > @@ -884,10 +891,13 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
> > >                                       READ_ONCE(task->parent) == current;
> > >                       put_task_struct(task);
> > >               }
> > > -             return ptrace_active;
> > > +             if (!ptrace_active)
> > > +                     return false;
> > > +             break;
> > >       default:
> > > -             return true;
> > > +             break;
> > >       }
> > > +     return security_mem_foll_force(file->f_cred, priv->opened_by_owner) == 0;
> > >  }
> > >
> > >  static ssize_t mem_rw(struct file *file, char __user *buf,
> > > diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> > > index 65c9609ec207..12f84a1e6fab 100644
> > > --- a/include/linux/lsm_hook_defs.h
> > > +++ b/include/linux/lsm_hook_defs.h
> > > @@ -36,6 +36,7 @@ LSM_HOOK(int, 0, binder_transfer_file, const struct cred *from,
> > >  LSM_HOOK(int, 0, ptrace_access_check, struct task_struct *child,
> > >        unsigned int mode)
> > >  LSM_HOOK(int, 0, ptrace_traceme, struct task_struct *parent)
> > > +LSM_HOOK(int, 0, mem_foll_force, const struct cred *subject, bool opened_by_owner)
> > >  LSM_HOOK(int, 0, capget, const struct task_struct *target, kernel_cap_t *effective,
> > >        kernel_cap_t *inheritable, kernel_cap_t *permitted)
> > >  LSM_HOOK(int, 0, capset, struct cred *new, const struct cred *old,
> > > diff --git a/include/linux/security.h b/include/linux/security.h
> > > index 153e9043058f..e8bc2e644241 100644
> > > --- a/include/linux/security.h
> > > +++ b/include/linux/security.h
> > > @@ -338,6 +338,7 @@ int security_binder_transfer_file(const struct cred *from,
> > >                                 const struct cred *to, const struct file *file);
> > >  int security_ptrace_access_check(struct task_struct *child, unsigned int mode);
> > >  int security_ptrace_traceme(struct task_struct *parent);
> > > +int security_mem_foll_force(const struct cred *subject, bool opened_by_owner);
> > >  int security_capget(const struct task_struct *target,
> > >                   kernel_cap_t *effective,
> > >                   kernel_cap_t *inheritable,
> > > @@ -676,6 +677,12 @@ static inline int security_ptrace_traceme(struct task_struct *parent)
> > >       return cap_ptrace_traceme(parent);
> > >  }
> > >
> > > +static inline int security_mem_foll_force(const struct cred *subject,
> > > +                                       bool opened_by_owner)
> > > +{
> > > +     return 0;
> > > +}
> > > +
> > >  static inline int security_capget(const struct task_struct *target,
> > >                                  kernel_cap_t *effective,
> > >                                  kernel_cap_t *inheritable,
> > > diff --git a/security/security.c b/security/security.c
> > > index 71aea8fdf014..2cde1efdb7a6 100644
> > > --- a/security/security.c
> > > +++ b/security/security.c
> > > @@ -595,6 +595,31 @@ int security_ptrace_traceme(struct task_struct *parent)
> > >       return call_int_hook(ptrace_traceme, parent);
> > >  }
> > >
> > > +/**
> > > + * security_mem_foll_force() - Check if FOLL_FORCE is allowed
> > > + * @subject: credentials using which /proc/$pid/mem was opened
> > > + * @opened_by_owner: whether checks on open() were bypassed because the opener
> > > + *                   has the same MM as the target
> > > + *
> > > + * Check if FOLL_FORCE is allowed for accessing process memory through
> > > + * /proc/$pid/mem. opened_by_owner signals whether the opener's MM was the same
> > > + * as the target MM, meaning the security_ptrace_access_check() hook was
> > > + * bypassed on open().
> > > + * (Current current->mm does not matter for this; for example, if write() is
> > > + * called on an FD that was received from another process which obtained it with
> > > + * open("/proc/self/mem"), @opened_by_owner is still true.)
> > > + *
> > > + * Note that this hook is only designed to be useful in the opened_by_owner
> > > + * case, where the subject credentials effectively also describe the object.
> >
> > Given this, would it make more sense to call the hook something
> > like `security_mem_foll_force_self()` and only call it in the
> > opened_by_owner==true case?
> 
> Sometimes we can't avoid it, but in general I'd like to see us avoid
> calling LSM hooks conditionally, I'd much prefer the hook
> implementation (either at the LSM framework level or the individual
> LSM) do the conditional check.  See my comments on the previous
> revision.

Ah.  Sorry, I had missed that.  +1.

