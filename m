Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A89C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 09:31:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B0F6B0088; Fri,  4 Sep 2026 05:31:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DC8A6B008A; Fri,  4 Sep 2026 05:31:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F37F6B008C; Fri,  4 Sep 2026 05:31:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E6E5A6B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:31:20 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E19851C3337
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:31:18 +0000 (UTC)
X-FDA: 85175561436.02.E9B3E58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 42D2840005
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:31:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EnF573Ue;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788514277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntGqMbIytPTwLlJR1fA/xTB+g7J2BTUkRTGlMKhEpBI=;
	b=08Jod/bis5AlWcOLCv3XDscMPA9uyGEGwr27rwl6wIHaw2vpkVdJG46l8A0jq8OAIkFkkT
	Ybido1u9DAwmlIyrdIG2BjqLw/BkaB5t2YtcVahtRhY0tcQngO/bfBQyWGa3VVNRAOMbQ+
	hddrvb8FGuqaoX8SZgjuh6MK2EIcZU8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788514277;
	b=CQeMgumioIRrq4aYkQ6rqOw4rwiQbej6GX49Z0etu02AP+7ElUWsdx16i7y1Y0Wry0Mcst
	2odl9Jwg53qWqA2fzyU76SUoChbUGWyC2tKynQ6O7iredQOi3pnBsEzCR3qTQIzQPbju2i
	U9sogFdmw1/8N3mbryJ/AABk8lUISHU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EnF573Ue;
	spf=pass (imf01.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 78B9660A6D;
	Fri,  4 Sep 2026 09:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4991F00A3D;
	Fri,  4 Sep 2026 09:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788514276;
	bh=ntGqMbIytPTwLlJR1fA/xTB+g7J2BTUkRTGlMKhEpBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EnF573UetbEzUTlGgz4Tk/HQtIPjMLYjCzaINKkr83N0oVneVEIXv2SAaw7NFguOD
	 HszNUHvb6pel1Q8+9mMkTNoN8ouZCDDtIWGnq+Y7SdT/t755RNwfjkCOWxii5TURV7
	 1cmDnH1wsJ6kUAzaR33Y7Zw5Q/I/X7pg6LgaikJ/PPdtiAcvZemp4uuIH0q2gcj1dH
	 WYujHcCSYUyZD+GzDq/eM9lmkPQHH/4CwFRz47OAM+WgM7PIXRzOn0nIL2JXHc3CKz
	 p7NOLDy38otOuXtrAUkU0o6muWT3qYtTElKJDUSH1H4HEyXqaVIghB3GDP4zRdL4Sc
	 Wz/r90OEWi/ug==
Date: Fri, 4 Sep 2026 11:31:09 +0200
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
Subject: Re: [PATCH v2 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <20260904-busfahren-klarkommen-kodex-da59b836bef2@brauner>
References: <20260825-selinux-pokemem-v2-2-b46bc64916d8@google.com>
 <82929c994076d95f99560ecc67f6cfce@paul-moore.com>
 <CAG48ez1rd3cFhmGn7mWkaVvGqYg+cDiGUhuhH6r51dUm-QBXUA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1rd3cFhmGn7mWkaVvGqYg+cDiGUhuhH6r51dUm-QBXUA@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 42D2840005
X-Stat-Signature: 9k3iw1x4u6q6p7hiqdam9xq1fkrfgmyd
X-HE-Tag: 1788514277-177142
X-HE-Meta: U2FsdGVkX1+1l/aJfILRny7i14xfZA5WjTDsu9zz8gOVl17QbOoS9LarWLmIdOtcpqpyt1VJZtDtnpHYr8o2kv6oNRuNc7u+WPZ/dF+m02HfSlCRSud8WcxT5oZxxll0/5CAuQuuylohFZ0S1CcgoCc7knPonhNsA2DkykXmDiyOJeW3JGDdnx7QJ69+ay8mNiAWW4RIrcHdOzw+rGBrbJPO2dBbdjAHFKXgwuDRNLLMYzunLVZ7H0ATM4cQS7/BRHYI9iw7tUNYMa74njsWCJGHoL2DfNeO+KCs0roU8Xrr2Bq3N22dKNeBMq5TPMRUr+VYU2EyYQdzBImhkW97EjK/6NuE+05hCxG/83VYLwj7VV50Ha4hqCVxN9GF6HK3GRhA32RjjVXl4oztklgW5LdKICYeWR95a/69NbMkUm58aZu1OX4IIRhmzo04oUPsSK1o2fv4Smrs7kpfA0JqE9PfG98WhWNB9JzRq66eg74rhfdkESX2d3G0KKWMWh7IvKNZYrY0NKWze4BUZ5B28Ok9xmZvJ/HCgIisOy8EzMcEMmUb1A1affhNActBok5YQl99T/jQjb7gsMpe75sn49mDCszqvCr+uAw8Z0lJdsvQzQeLt8pg5CzBu96h11vvYjGN2zyo9w9PzDw48BQmZ479n/iylz4ajKUexNOfd+1LBQo27UYW1CRH67Xx3eYh7b3USEp8Oh2yA/Gz/FKDLULI5iAmBt5Yk0NOYPBe7QteKul9H9LxBc4ksrcdyC13pUeIGIlU4h3EIfN4NFcS0NNrgkO2GOXJkE4R9wGqoSS4dmNEIEspd8QmDxiu4QBBRTraiFciJGh+fSvdGU46Ix14imKbJv9SOhKQCm7e2k3/w4wrWfuL1mkOXGHWbOnXNhjO+CnR+xtoD41pIzaP8XGZXYF2SWymlkCujWnxsSYBNYq4DlJPAqzgAfBXrnDCEpLcdkyTF7M+6L18Thp
 zfyTSpnx
 dJwSVkrOyfTKoWmGhdnF1/k53LUBtn6bugssodubzLBg8vDGiu9jxkwMAb74MrWWI1qiXX7CJFBcFzcRupLDoEHywaeXutinl4swid7uNEAK/aJJd9p1y4sZHx7EoWPXioXNbUx8QBMGGfph7ZibkdLPfvGn+zRGTcePZWC5rL+lpb2M4eVZUIXntu7PRi3EI7TySsxOcjoPZ1cwmj8p30CYM/qnVjWCGWCdGoH+ER8qXS4M9eOTEaJcKHMRFXM0BYMTQPoAWfN/K7ZrVVvMNjc1v4+293eBpt85F6qiT+mjijzkhobD0VSIQkh56WbVES9MrKBw+0hkzczMU89WLKMPIfHqf178RmQr8H9wfDsdBeBR//2+dRtTquCb62zp/SVHvcutHnkhzUyxvIw2TqZOke9Np81UjLxkk8RBhLkxUH2sx84hC/R9Ob+rKiXLkIeN1bMY+y5DBLF1yyj1INNYC5xD7I0Wo5axBSRUijywtimoUzh0O0k8dWItm3tuLGywGQPTy2pN6Soq1ijhd4BY9ZGN5xYIPTu6OV0rMEtiX8z4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 03:03:26PM +0200, Jann Horn wrote:
> On Fri, Aug 28, 2026 at 3:10 AM Paul Moore <paul@paul-moore.com> wrote:
> > On Aug 25, 2026 Jann Horn <jannh@google.com> wrote:
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
> > > Signed-off-by: Jann Horn <jannh@google.com>
> > > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > > Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > > ---
> > >  fs/proc/base.c                |  9 +++++++++
> > >  include/linux/lsm_hook_defs.h |  1 +
> > >  include/linux/security.h      |  6 ++++++
> > >  security/security.c           | 20 ++++++++++++++++++++
> > >  4 files changed, 36 insertions(+)
> > >
> > > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > > index bec6197329dc..dc6fdcb47b79 100644
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
> > > @@ -886,6 +893,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
> > >               }
> > >               return ptrace_active;
> > >       default:
> > > +             if (priv->opened_by_owner)
> > > +                     return security_mem_foll_force_opened_by_owner(file->f_cred) == 0;
> > >               return true;
> > >       }
> > >  }
> >
> > First things first, we've got to shorten that hook name :)  What do you
> > think of security_proc_mem_foll_force()?
> 
> If we move the "opened_by_owner" part into a flag then I guess that
> works... will do.
> 
> > Beyond that, we really try to avoid making LSM hook calls conditional.  It
> > can limit what an LSM can enforce, it tends to be a bit more fragile, and
> > it adds some unnecessary work in the case where CONFIG_SECURITY is
> > disabled.  I would suggest passing 'opened_by_owner' flag as a second
> > parameter to the LSM hook and calling the hook unconditionally in the
> > default switch case as a replacement for the 'return true;' statement.  I
> > understand it may seem a bit odd, but we try to make the LSM interface as
> > generic as possible with respect to different models and this is one way
> 
> I guess I can do that, but then the question becomes, what other modes
> of using the LSM hook that don't currently exist in the kernel should
> I be supporting with this? I can make this a parameter, but any LSM
> policy that actually uses the parameter in a different way would
> probably be buggy/inconsistent, unless other new LSM hooks are added.
> 
> If your intent is to make the hook work for any /proc/$pid/mem access,
> including when the caller is ptrace-attached, then I guess I have to
> move around the security hook call in proc_mem_foll_force() a little
> bit. I guess I'll do that in v3, though I really don't like trying to
> come up with a reasonable in-kernel API contract for a scenario that
> currently has zero users.

So we effectively landed on what I proposed in the first version... 

