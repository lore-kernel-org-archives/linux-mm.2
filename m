Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBCB2C5DF8C
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8E76B0095; Fri, 21 Aug 2026 14:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A0286B009B; Fri, 21 Aug 2026 14:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6F16B009D; Fri, 21 Aug 2026 14:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45E1F6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:52:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9F8B120232
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:52:21 +0000 (UTC)
X-FDA: 85126172082.17.F2D38B9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 181E518000A
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:52:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rk6QCGUz;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338340;
	b=hPdULp2euM0nyETr3BaZcnm7u9DZk7V34/JxJp8OZLGJP2NTV9/8yX0Wqjauexo1vBe6VG
	Kk6t/nVlb20nvYCIIR+NA9jT3B7EijhjXeJaw9viRQaNKs7PtGoKIpnO+abTSAJJ4RDRM0
	IXMxsUd11Y7pdzWQWf3XOMhgGwEAM20=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rk6QCGUz;
	spf=pass (imf24.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1BHtoNef4td6Og2iN6g1HbZL10mPM2Ly/XyYiAnVCg=;
	b=oAuZPCX//Qs7yoZGYCnCmgKaZhHzVUgK/EbttkleCpq6k5iIfTlHmjcHsfmv1X7acE2vTv
	9NWPQYd+AbwfuvCwadf99AQ2tLj7Rm9FCmFiNzIUm/wy210wJGubrD0Kbv4JSdFiXabSmp
	L6QueE5qegMtdnm6b+9MtW/T6SYVZzA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27AB9414FE;
	Fri, 21 Aug 2026 18:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54FDB1F000E9;
	Fri, 21 Aug 2026 18:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787338339;
	bh=b1BHtoNef4td6Og2iN6g1HbZL10mPM2Ly/XyYiAnVCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rk6QCGUzCZBsasCr/5vVPikhT1k7x2I/nEl+6mwH3QqZ1LsZqAktAG9teYTJW/0Yf
	 rQgob+ZL0jX4pwL7soVlD0N6QpwSGKyD/ixmIP/zx274iknFX2G+3qo1r1ekFrsPnz
	 IThkxrEQPLRhMukqYrxLSenuQ3iWYu2HZ+PW97vI8/Ar6c2HoWQfaTsTX62UAv9348
	 u1FoWSqxGLWXqPtmc0ncBX6onVTxn04mHQNzkB/r2zrJ4joBxRduJPW1rdt4J5hOwn
	 KmRIWkYTD+3PRbVlx0NdK9o5eUgVGbl0a62Ev+k78ABMvBtZwY8p+YpcKo+1GbSdX0
	 XEecZhcBdhdnw==
Date: Fri, 21 Aug 2026 19:52:11 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley <stephen.smalley.work@gmail.com>, 
	Jeff Xu <jeffxu@google.com>, =?utf-8?B?VGhpw6liYXVk?= Weksteen <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] proc: query LSMs for introspective mem access (if
 PROC_MEM_FORCE_ALWAYS)
Message-ID: <aoibvf6CY99IXynk@gremlin>
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-2-90cd2357ee05@google.com>
 <741a833d-6889-4ee6-9322-d6a3a8b95893@kernel.org>
 <CAG48ez2Ngo3=VtyykXY6ynVzGwA8px-p4zV3V6U=YfgV-Hy4BA@mail.gmail.com>
 <dd8c34a9-0e09-453b-88e1-0a5511816627@kernel.org>
 <CAG48ez2bZEV+3ww2x9XV_5vRPZ_3jU_zg6+h=BDKQ94Xrd3Tqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez2bZEV+3ww2x9XV_5vRPZ_3jU_zg6+h=BDKQ94Xrd3Tqg@mail.gmail.com>
X-Rspamd-Queue-Id: 181E518000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 1ewmihrqoy7wid1bqcqpjq568o55xx8r
X-HE-Tag: 1787338339-449045
X-HE-Meta: U2FsdGVkX184KNDDRinE46wrgnRfMvYy5klaq45hwA3Vag1rLdhOi2B6KWy2p1oHh0snXkMPXBF6eDtyRGYcwG7U5NoMXa6HmHrtxgdsMxuuH3BF41qfkES3BUmZG+jXPqMvh5/lGKYSZIhDMuVrV3v+y5qYNpzAwvLYbx2daERTzb/fyRToL/qSlKpoDmgI3/Vu6r5D7bg3Uyp1J7l6gu53rO5iPKpqwiUWySuEtJUze+esG14frgTrUBalNDpqGWR3dk+aZEASTQrF5jFZoDvYfaEFdYzxjbuC1KtxmtBXZXt3J5dac+HnANhUXMMuu3WR48nYUg8+19jksJ7EAUUuXq5t0yOtqmywoBmCco+p9hvcYSw+fLK7wAhRSpr45jUFRMqj/l65IckVbKVM7WYooNLnB7/7+uW+n6BjYG9cucjYYbH55xYPUlUXtBT9KD33POfeaK6Z8lvCwqV+SXLx98bx8fQqZiIOwm6g0uYRKr8w47/vuelxXL0oM4goMUyvRfocZZLMd8hRcu8KiPF6m7ep+Sz9qH7rKIocKy3W10Y3/3FCJSZfQExRqtYXnJfn7qg+4DSOj8vErmb/ulNep5tjWrgtgzo0A2mob2AVnpgU5Fpc47PZMzfAL3te0VgqboJ/CVIzWBy7xCaaq57iPBDTXqLkWmle9TuBFrxvhnnp826N715VdskZLXMkxJY1bHqLmz1bRAUZ5xzcnWOifBlYhdFd14QGskX/uLaHyo3i7HF6Pg5fi1hyhHTmC0gVu4QgDl7ZD65Z6T5Vl+Km9x8O5BJ38zZVAH5+dxvRpLxZlRx1kP4/TQeB5J65jiBlHAp8vLxbs3hhVeZ7mv40BvXYAbAAheHJa+R0DOaQIAflC/On5AlKhWbn0VnOWLSrQuerjrePRvyw6PvYeog+8OZhQzINvWXEDt7FF/zXEb66S2f2bPC/BQjN8+AqwnJqkz0BkBzAleFE1TR
 YNh3J9b3
 vhqghOp2j8OaLjj8HbBftZSxzLUCxsvf7TwiZUdiy0XvzknwzlwxAYm4Ngime1A3L4AjpulYu2GYS2zk3rbHiKf5ao4/NPZHZwlO9YcOFjOWDVvv0urj2wgWBAVf0wPK4MCqoxOcRHE/OBfCC6jhK2fJ44mMne3T9b2MvNYDNYqnfEbB4nr51XN57Kj7qgL32ptpbX1/Duh3wBVzxnakYCfeSS9gtFgPAaJdRDIxoE+DT0dTVqLpQDg7vyekv+ryTiGRECSoSpenkUxIyqzlmBORhJCBLFSGIDWoCf/KqhSysuY8SCgU/YGs+CdVV43xESwTRNkAzmUcvGmfVfovjBN3YkrCX4X7rsiCv68ekoOOLdPaLbcOpuqkM0w7sJdEKCKgiHQKQB44rnpVlKGDF/R5iazd1kaB8jCXyhpxHUVOS1Mx/VK7S06OcdKl+4ZUKm3bX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 04:48:32PM +0200, Jann Horn wrote:
> On Fri, Aug 21, 2026 at 4:19 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> > On 8/20/26 20:44, Jann Horn wrote:
> > > On Thu, Aug 20, 2026 at 7:22 PM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > >> On 8/18/26 21:51, Jann Horn wrote:
> > >>> If the system is running with PROC_MEM_FORCE_ALWAYS, LSMs currently have no
> > >>> good opportunity to block a process from overwriting read-only code in its
> > >>> own address space through FOLL_FORCE writes via /proc/self/mem.
> > >>> The security_ptrace_access_check() LSM hook is bypassed when a process
> > >>> opens /proc/self/mem because this is considered "introspection".
> > >>>
> > >>> This causes a hole in SELinux EXECMEM enforcement, which tries to ensure
> > >>> that a process cannot create executable anonymous pages.
> > >>>
> > >>> PROC_MEM_FORCE_PTRACE prevents that and ensures that such FOLL_FORCE
> > >>> accesses are only possible when the LSM allows ptrace() attachment; but it
> > >>> is unclear how quickly PROC_MEM_FORCE_PTRACE can be deployed in
> > >>> environments running lots of third-party code, such as Android.
> > >>>
> > >>> So, introduce a new LSM hook that can forbid FOLL_FORCE specifically for
> > >>> such "introspective" accesses.
> > >>>
> > >>> Signed-off-by: Jann Horn <jannh@google.com>
> > >>> ---
> > >>>  fs/proc/base.c                |  6 ++++++
> > >>>  include/linux/lsm_hook_defs.h |  1 +
> > >>>  include/linux/security.h      |  6 ++++++
> > >>>  security/security.c           | 15 +++++++++++++++
> > >>>  4 files changed, 28 insertions(+)
> > >>>
> > >>> diff --git a/fs/proc/base.c b/fs/proc/base.c
> > >>> index bec6197329dc..3dfaef49bb70 100644
> > >>> --- a/fs/proc/base.c
> > >>> +++ b/fs/proc/base.c
> > >>> @@ -851,6 +851,8 @@ static int __mem_open(struct inode *inode, struct file *file, unsigned int mode)
> > >>>  /* private_data for proc_mem_operations */
> > >>>  struct mem_private {
> > >>>       struct mm_struct *mm;
> > >>> +     /* Was the ptrace access check bypassed due to introspection? */
> > >>> +     bool introspection;
> > >>>  };
> > >>>
> > >>>  static int mem_open(struct inode *inode, struct file *file)
> > >>> @@ -864,12 +866,14 @@ static int mem_open(struct inode *inode, struct file *file)
> > >>>       priv->mm = proc_mem_open(inode, PTRACE_MODE_ATTACH);
> > >>>       if (IS_ERR_OR_NULL(priv->mm))
> > >>>               return priv->mm ? PTR_ERR(priv->mm) : -ESRCH;
> > >>> +     priv->introspection = priv->mm == current->mm;
> > >>
> > >> Is the feat that the fd could be passed to someone else that would then not be
> > >> detected as introspection?
> > >
> > > Yes, exactly, that's the primary reason why I did it this way.
> >
> > Okay, would "opened_by_owner" or something like that be clearer? At least
> > "introspection" is less intuitive for me.
>
> Ack, I'll rename it to something like that for the next version.

I agree the naming is confusing.

OK so the whole thing is:

mem_open()
  -> __mem_open()
    -> proc_mem_open()
      -> mm_access()
        -> may_access_mm()

And:

static bool may_access_mm(struct mm_struct *mm, struct task_struct *task, unsigned int mode)
{
	if (mm == current->mm)
		return true;
	...
}

And what this flag is carrying is 'hey the reason we allowed the _open_ is
because it's looking at its own address space'.

I did wonder if what you're protecting against is even a process updating
execmem _it_ owns, no fd shared anywhere, as something LSM might want to
prevent even so?

The sharing a /proc/mem fd seems like that's a pretty dumb thing to do in
general :) but I guess you have to protect against that.

But TL;DR I agree with David on the naming, opened_by_owner is probably the
least-worst way of saying it very plainly and covers both cases.

--
Cheers, Lorenzo

