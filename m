Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D95BC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5479F6B0088; Wed, 26 Aug 2026 09:01:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F91D6B0096; Wed, 26 Aug 2026 09:01:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40F6D6B0098; Wed, 26 Aug 2026 09:01:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 19B036B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:01:34 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E238E140381
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:01:32 +0000 (UTC)
X-FDA: 85143432024.18.B9C93B6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1DF0F10001D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:01:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Deau/1hd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787749290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i7OqggJ1fEHcFpexMbhQr1tq9t2PX/2Yu/4dFGYaW10=;
	b=iwzb1TCOpZ+W+98F/NPtuvXyxQE91lnuzM3fJJhPkdpl1L3EUMG5VgWbeTdtsR/n8R9kaC
	RQA6M0MVXEaV5Dp+D1qGllV6/eafoQyaDWtn90+PGrl0j/THbyp3bfxzOVDck6KPEFCUoR
	mT8Aym5x6L28nWuTSmz50mfsDXeEUe0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Deau/1hd";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787749290;
	b=KaNScJwsbiIlje7cQ0JsMODE+BHtfVsqXYUdF89yWnrADC+5bOlDdI0Uh4adXjyw6NoPuj
	sLrVhQ8jICtEtKcH3qKStFddWDdk9ITjRw9oXx5O7yFaR2mnX1XajdfjeXo8cT0y95u7aX
	UrBvMvDOtvOyN+xX62AUJ4PsBmr7oKo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C0E443B2D;
	Wed, 26 Aug 2026 13:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85E11F000E9;
	Wed, 26 Aug 2026 13:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787749288;
	bh=i7OqggJ1fEHcFpexMbhQr1tq9t2PX/2Yu/4dFGYaW10=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Deau/1hdi71/TOvis/j3rQ6M5DSNtC+Kpb0/4DLYBDHfMXUUwrKHVpPabqpUJDPtS
	 NHVrY//f44lEJXjWKB0PXAG5QIUAG0304rpz3nGYnEOfCNaiExxKEAURMcUHdvT5oy
	 LzQpmPMtkJO/r+WlXV24XgkReQb9hpVH/HU1lDUrXhUHWecsnf+KBhcz85XyL5VftT
	 tBV5WEiYNpA96+w3fsyTK+zu41Qw3lM5ogZkrVsBURYTeXNxv5QpUxim8yuOJkQt/u
	 OYe8lRx9cHBWu+Blgo8xD745UPdnEgCfM25pZ4Gb+bEFmXWRU6OgD6LbAVRW+0nNft
	 cwFTYvzm8dD+A==
Date: Wed, 26 Aug 2026 15:01:21 +0200
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
Message-ID: <20260826-rotor-heterogen-wollust-2091c20f5e30@brauner>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
 <20260825-unweigerlich-biotechnologie-abnormal-accff844337f@brauner>
 <CAG48ez14F42BgHm5dKeP4g8D_6CNhnAfF7BXdcBwa4NdtFiaiw@mail.gmail.com>
 <20260826-juror-energetisch-hackordnung-83810c82adcf@brauner>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260826-juror-energetisch-hackordnung-83810c82adcf@brauner>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1DF0F10001D
X-Stat-Signature: awrrq81gifnhegfm5autms76tfskon64
X-Rspam-User: 
X-HE-Tag: 1787749289-359818
X-HE-Meta: U2FsdGVkX1+eAziARsGmyVqOqFyMeIrekDIjbQ3AOSpPMkPDwzc0KyJIEhtsvV4AmBPoD9gagTUV+MJr0kMzDstT6rMQ2ngCZypyaPzyKw2ZxZgW9klWp9uWEFm7ayPWtFWYI3bL1DqirTlJTguxVoGiAp4TF0sJvpNtSEWoSEh5/A41K+x+QUD2vkdGcnVrSwwcrc87jUQ0tpvPlIq7zoAOEp4vTrWwJH+JfTqpOnVL7oiG3JBE33eA8Rr0OjUsau+tGC8lUc2LZTzktRJuBV/tQ45/Sy8vQN5lyhmnF0YzfTMgEYtuOJHOiJDOX/FH2RR5SkOUhYJogHB/LfUCjuwTTyE0zzKADTefty41FJfiO7daFWhTCkai0zlHMxSDm8Ki7HSKb+jY6TxhODNgcOWBIxOqIxCb75ozZEMup0Fg7r2+f13il5iY2pmwQk2WEqYkS/VsIOFLPzI3Gug2eC5xAHPmSaxu3tcYxo6Th7o5qd3xfM6FCa8nOefahod2pJegwzDKSyrKSAwjuyLDXmFyRERiRi4fkgc9VyibuT5QAof8bP7qsWMO1frzp8Yy8qmNtVFAHFyWFg17q9Wqp36agshTLKcpXe5+g7zWFqloxXZx8loVMzgsTT59H80A6JQ0u/fBjn4HBNA7lcKXeYEzaXC5xmidNI1DHKZci26YbRKjf2dm0VtXhCx7M/i1O8o/uuA2aDfvzYT8KUG9vZ+3zvTq3rd2BPzXdA6sUyrs4p6BwjPuUWPGyuaYBnbfDD75DhJ8iuBG02fuDufQYoIJkXPbFXQn5NB+W0/jA5Zcp/JPK/8CvI6V4aEoAybzLAuUBd34S/MXA75cIVHU3UdHX79rpWJg/WLSXC67O87x+4P6h4hgnVqng0V51eSzYf4eiFhIxhERZj1+YZB0F64MCiXHVn0zIh0+YpZ072avm4hnr1TKWkQDoayoKscwHDHQsFRaA4KJy9oPz+L
 M8EPcsah
 +oiYifk4tvLs6EJ6PuXlR8AW0NC6ClB6EjRCquOfTZDyI31bSy2wJrZaes2sU7y1GcbPdTPjUOmPFALZ6ZQXY04QYr+aCKlKbT1dADXw1R9UGEdZ7NljUgpNFoaY3I2iF9uMTSmRVxquwny0U78b0HW8rxRCn1zAm/0bL2nIpngJlt62UpK0gDyWWbkDwpFrl6ok/SZMYsj5yCswwQEdcfihGVStBJeNRl8BLktW8Oke3A3OSkO0m4VQit7j2UWNUL0DIKAuU3J7sjvQ+SSOv/RIp2tSS1teOMEc/JbIg5FfEBAe8+XxECNakfOXp37YvPqkN/hVRKy726g0re26C5gLL4LCIDyGzsjAkTQxu7hxFTc9mCJkS2WnU81/5YfyI4WiYggrknfTFj0cfH8PoS6CZS3vGoMGYhctF0uoKyLDd/oBFZlG4R2y/KqJyvxxSVcMFQ6/lj4RItSt7MNHIFDZ1H8Ct5QGQ4FS5YvrJlFEjxzhFM/7QbfzPCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 12:29:14PM +0200, Christian Brauner wrote:
> On Tue, Aug 25, 2026 at 04:00:40PM +0200, Jann Horn wrote:
> > On Tue, Aug 25, 2026 at 3:19 PM Christian Brauner <brauner@kernel.org> wrote:
> > > On Tue, Aug 18, 2026 at 09:51:06PM +0200, Jann Horn wrote:
> > > > If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently have no
> > > > good opportunity to block a process from overwriting read-only code in its
> > > > own address space through FOLL_FORCE writes via /proc/self/mem.
> > > > The security_ptrace_access_check() LSM hook is bypassed when a process
> > > > opens /proc/self/mem because this is considered "introspection".
> > > >
> > > > This causes a hole in SELinux EXECMEM enforcement, which tries to ensure
> > > > that a process cannot create executable anonymous pages.
> > > >
> > > > PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> > > > accesses are only possible when the LSM allows ptrace() attachment; but it
> > > > is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> > > > environments running lots of third-party code, such as Android.
> > > >
> > > > So, introduce a new LSM hook that can forbid FOLL_FORCE specifically for
> > > > such "introspective" accesses.
> > > >
> > > > Signed-off-by: Jann Horn <jannh@google.com>
> > > > ---
> > > >  fs/proc/base.c                |  6 ++++++
> > > >  include/linux/lsm_hook_defs.h |  1 +
> > > >  include/linux/security.h      |  6 ++++++
> > > >  security/security.c           | 15 +++++++++++++++
> > > >  4 files changed, 28 insertions(+)
> > > >
> > > > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > > > index bec6197329dc..3dfaef49bb70 100644
> > > > --- a/fs/proc/base.c
> > > > +++ b/fs/proc/base.c
> > > > @@ -851,6 +851,8 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
> > > >  /* private_data for proc_mem_operations */
> > > >  struct mem_private {
> > > >       struct mm_struct *mm;
> > > > +     /* Was the ptrace access check bypassed due to introspection? */
> > > > +     bool introspection;
> > > >  };
> > > >
> > > >  static int mem_open(struct inode *inode, struct file *file)
> > > > @@ -864,12 +866,14 @@ static int mem_open(struct inode *inode, struct file *file)
> > > >       priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
> > > >       if (IS_ERR_OR_NULL(priv->mm))
> > > >               return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> > > > +     priv->introspection = priv->mm == current->mm;
> > > >       file->private_data = no_free_ptr(priv);
> > > >       return 0;
> > > >  }
> > > >
> > > >  static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
> > > >  {
> > > > +     struct mem_private *priv = file->private_data;
> > > >       struct task_struct *task;
> > > >       bool ptrace_active = false;
> > > >
> > > > @@ -886,6 +890,8 @@ static bool proc_mem_foll_force(struct file *file, struct mm_struct *mm)
> > > >               }
> > > >               return ptrace_active;
> > > >       default:
> > > > +             if (priv->introspection)
> > > > +                     return security_introspect_mem_foll_force(file->f_cred) == 0;
> > >
> > > Hm. Why not pass the reason to security_introspect_mem_foll_force() and
> > > call it unconditionally? Similarly it could also be called for the
> > > active ptracer case. Then you'd just need to pass a flag to the security
> > > hook and the LSM can decide based on that.
> > 
> > A process which is attached as a ptracer can modify memory with (for
> > example) PTRACE_POKETEXT and registers with (for example)
> > PTRACE_SETREGS. LSMs that want to prevent such debugging operations
> > are supposed to prevent ptrace attachment with the ptrace_access_check
> > hook.
> 
> Yeah, but as I said elsewhere that is very very coarse and you can't
> differentiate between the different operations performed on the other
> task.
> 
> > I am just trying to plug the enforcement hole where ptrace-style
> > modification of process state is possible without going through
> > ptrace_access_check - which means just looking at these
> > "introspection" cases.
> 
> It seems odd to just call a hook when it's introspection denied.
> And if that's the case why not also have a general hook in
> ptrace_may_access() itself in the introspection branch?
> 
> I would actually have use-cases for this btw.

To be clear: I have no quarrels with this going in as is. I'm just
interested in how policy decision such as this can be made more
meaningful in general. If you have thoughts around this you want to
share, please do.

