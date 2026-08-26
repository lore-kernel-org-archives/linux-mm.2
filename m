Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C1BCC61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 10:29:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1B86B0088; Wed, 26 Aug 2026 06:29:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2366B0099; Wed, 26 Aug 2026 06:29:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3912D6B009B; Wed, 26 Aug 2026 06:29:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2406B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:29:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6FE49C031A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:29:24 +0000 (UTC)
X-FDA: 85143048648.27.4FFA942
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id BB1CF40008
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:29:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pjahm2Tn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787740162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=avVgzSrE2MWkMOJSSk+2BWcmErJRBoIA1/Sx++WOC9A=;
	b=Pz/dKJmhnenGNEbjvoUOD4JA6LRF5Sz7EP9Akm8JOvsV+cmP5AIwyhw8OqIeZ6TEeeRwf0
	jZvN5oyIMWEw4wvpXS20THoK+JHjGWg3r1uoN1lzP6yT05T57aw7xm9ykno2EPM8bbJOgC
	c+K7QpJKaKEXaqaa1O1Q7GK6oZoSsmU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pjahm2Tn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787740162;
	b=qnXnwQH3YfNRCRZM+xACZaG8tIVLtWpb9ah9ancMbHCDVZ3A4vP8mdhfk6pgEvbdCMRAU8
	MfviKbONAkkZCf5hLvmxeIUciWlLDPgDr9CAtKN8kE4XX2g4t4pvXoXDGzdTMQEY0d6VMK
	bjTB4gNvWyN2AcAM7HBxqR90ZEztszQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 229956020E;
	Wed, 26 Aug 2026 10:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B251F00A3D;
	Wed, 26 Aug 2026 10:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787740161;
	bh=avVgzSrE2MWkMOJSSk+2BWcmErJRBoIA1/Sx++WOC9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Pjahm2Tnm2ufdabqqoC/oGBW+/G1OnTO+3WwxoNiJfWxuwuEklqQpt8ro7mw8Tuib
	 wSCbhS1ROT+yNdXqbgBA7f7m7d4YYawLqwq+7CgCg8RVky3Ba3GEH+m3RHykPt2hUV
	 nmvaWnnjLqOMVC1uZCad7zK/9tmkcxhPImTQcqZtaBZVT145ooJHGsaj+RQaYfPRn6
	 xhy3Ehp2u2zzDoq8NaKxXWPiOT/vqjSvrSwHhOl4ixvYwVvYjsrrduwgfJtW+PVrFq
	 +m16gKo52jp4Bc0IK/O1s5GOs+aahq0EC/xPoqJ8KvUy4PzHJt4m2ABxV+1JbDC89N
	 cnSregFOsc0QQ==
Date: Wed, 26 Aug 2026 12:29:14 +0200
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
Message-ID: <20260826-juror-energetisch-hackordnung-83810c82adcf@brauner>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
 <20260825-unweigerlich-biotechnologie-abnormal-accff844337f@brauner>
 <CAG48ez14F42BgHm5dKeP4g8D_6CNhnAfF7BXdcBwa4NdtFiaiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez14F42BgHm5dKeP4g8D_6CNhnAfF7BXdcBwa4NdtFiaiw@mail.gmail.com>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: awq6iwg8eje9awadqy8knj5deo16t8rx
X-Rspamd-Queue-Id: BB1CF40008
X-HE-Tag: 1787740162-549107
X-HE-Meta: U2FsdGVkX1/vqwGw4JQxP/zGY6yS5A0SMD1xFNRraaGPihoSBD3Mh9OJI8l1ZhKmhX6O/vQ1rKyp1Dvr0sxDBdctGPa3b9q48113F7iDy3gJbxA7DYEzVksfyLp36Hnu28kI5yVFPq6D85CZ2TSWuBblIY5AGNwGaSHEJtlt57lKBRv/oEU2oFwX2nHZjXWB2o/BxylZWxdYBBOzzn0aOrb8SoAQa2rC8yAEpYZ0hROD9wMy5c4DfZCTH+FZbg8tSjTwDZOimbf+bhto4jih06QG0etUqwtDmnlxp5x7PKipY/7DVhE4cH/MOn7uU1lxD3TjlGklDf9BHBCpibCvBQ8Z9M2SEu82A4aThO7TqlQ7gQwERinUmi7c0kw9G1sfbryU+P3cKK8/rbS1svYRX6b8e4KiNidP0/nCzd/nIZ8RZjRkZCMHttY/YVtf4LVSM//rxv9DHA3E2un129wg6yQOL68MDb/eHHjRpS5ME7x0zgBWb2/FlybIpbhMJolyZ8IfYRBzvw8tT6MYHqRy69zi2TmuO3Qzh5Hnc7MkMi1ezThfTKXoCPKzTDsJygvh8F5rmVApEHJLE+If33KNhKi4qWHyuqbCy6rep8VrRoJ06QUVxfevSRKI11GLSpDXtoWeanmQ0FajL1aYGZvyLwgQeeyK/z2FDz5/V7i64CiMBxHULR5F1j3V8u/agxOogdHcj6FyspZF7ZpselcKk2RucFsU5NNTBZfgtcAG3UoTx1fnYQMJEjbJ03BfD6qYQueoDXKkeNyMZby6Csa2Rl3XlD+DffWQSzX6hPt4MhrkunU07MAYTk5LT4bbVh3A3MEoQQ7sjArRIU8VOSCWlBA+FNDzuB3ipsclOcj++kiGenFn/0+2yjQHhKb9WpAF4RNxVmHVfYkIi0/n/Q/6MVlRnmD2OcBCc0aZxSLlsmV6XAUgeacWbevgXVlFADk6Jr4CID3MS6BU1/hoX0K
 PCuYMQAN
 lz4vPmf33fZbaQUVZvcEtCYu2HUnISDgNPqS5CjP9fzs3wx4JJ1Dj7S4pU+6D8fOwkbVbRpDBWz48mS4gV2a53+bRscoY+bZifj9GAllRWDWnuBnJEMar6bk3mblAcyGUb9sykYnzOxAfPgHk1Xv02kyzJP/8kr4A1RPhn6Yqu6GlI3SB0FiykwNikXY4lB/hpzgbc2+X9XXWQs2d7VQdlHaD6er5QDqMRTbiDk4koJmCgDKjTdOq4bvWa58jKY0ovIXVzoK5xndcw1AqYGTgcuk9Mrf2B3Q1v64LQZYnp0adf9VCeASt9AjZ23G2IWBvp/iHpuGfIqZ/u9XoZyV2czanmqFxPQXSM7HhaxEA2MPJC5Pc6aFu4Ot2z/0wFwxYNTWymfU+Kd8lTlpD4r8ojJwDtrTHrB0p1kkIO/yof3aasumGfb4MBQliNqjo9S/QM5c/E7cGFhEEd72zNgC1Opu4PtuUOZgqYRNQlEg/VXPBxkyvEngYLegNSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 04:00:40PM +0200, Jann Horn wrote:
> On Tue, Aug 25, 2026 at 3:19 PM Christian Brauner <brauner@kernel.org> wrote:
> > On Tue, Aug 18, 2026 at 09:51:06PM +0200, Jann Horn wrote:
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
> > > ---
> > >  fs/proc/base.c                |  6 ++++++
> > >  include/linux/lsm_hook_defs.h |  1 +
> > >  include/linux/security.h      |  6 ++++++
> > >  security/security.c           | 15 +++++++++++++++
> > >  4 files changed, 28 insertions(+)
> > >
> > > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > > index bec6197329dc..3dfaef49bb70 100644
> > > --- a/fs/proc/base.c
> > > +++ b/fs/proc/base.c
> > > @@ -851,6 +851,8 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
> > >  /* private_data for proc_mem_operations */
> > >  struct mem_private {
> > >       struct mm_struct *mm;
> > > +     /* Was the ptrace access check bypassed due to introspection? */
> > > +     bool introspection;
> > >  };
> > >
> > >  static int mem_open(struct inode *inode, struct file *file)
> > > @@ -864,12 +866,14 @@ static int mem_open(struct inode *inode, struct file *file)
> > >       priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
> > >       if (IS_ERR_OR_NULL(priv->mm))
> > >               return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> > > +     priv->introspection = priv->mm == current->mm;
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
> > > @@ -886,6 +890,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
> > >               }
> > >               return ptrace_active;
> > >       default:
> > > +             if (priv->introspection)
> > > +                     return security_introspect_mem_foll_force(file->f_cred) == 0;
> >
> > Hm. Why not pass the reason to security_introspect_mem_foll_force() and
> > call it unconditionally? Similarly it could also be called for the
> > active ptracer case. Then you'd just need to pass a flag to the security
> > hook and the LSM can decide based on that.
> 
> A process which is attached as a ptracer can modify memory with (for
> example) PTRACE_POKETEXT and registers with (for example)
> PTRACE_SETREGS. LSMs that want to prevent such debugging operations
> are supposed to prevent ptrace attachment with the ptrace_access_check
> hook.

Yeah, but as I said elsewhere that is very very coarse and you can't
differentiate between the different operations performed on the other
task.

> I am just trying to plug the enforcement hole where ptrace-style
> modification of process state is possible without going through
> ptrace_access_check - which means just looking at these
> "introspection" cases.

It seems odd to just call a hook when it's introspection denied.
And if that's the case why not also have a general hook in
ptrace_may_access() itself in the introspection branch?

I would actually have use-cases for this btw.

