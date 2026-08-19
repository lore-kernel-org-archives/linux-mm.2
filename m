Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 209A1C5DF86
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 10:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22DB76B0093; Wed, 19 Aug 2026 06:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DD106B009E; Wed, 19 Aug 2026 06:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A54C6B009F; Wed, 19 Aug 2026 06:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C68CC6B0093
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 06:20:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 671921604D7
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:20:10 +0000 (UTC)
X-FDA: 85117623780.04.46CADE4
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EADE80005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 10:20:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b="Ip3l/sK0";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787134808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xVE/TCa3FajtK4vZ9pzEwtCdg70Sj2GwjXUwN4Rwvtg=;
	b=61yDjvHvcQDOSyYINkof+TsyyWlpjhNbpRYhMz2VWOn9uHYtmkZH6idJAHLZ9Rq3SGxtUl
	mZFMl9ZmgdAR0XwY4hy6B5O5AtMLNMvF7YmEMJPhpKtYmrPiP1qqiaWFiKFp5MhwIM/T0B
	7cLO55ald3hQ/gYjnHA0BPMG/Ah7cAo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b="Ip3l/sK0";
	dmarc=pass (policy=none) header.from=linux.beauty;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf30.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787134808;
	b=I6QxV2Eo4XHKb+8+ECc5lZRdmSBfz678D4oA/PSLzUvJflPPrL9QU5zjPQMPb/Z+aMv9wI
	R8YGvRmIQvSVwICrR2z+m1dM430Hs43WfebaVz0FPvkqca5y1Q5j239WaidvhrWt7uAmGJ
	sgTxlfxip1m8Z0gUhfTOum0BasQgJFE=
ARC-Seal: i=1; a=rsa-sha256; t=1787134793; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=WNX19sQNfm9NLQmLvSi+kOC6ZCmTbJJ7WAVY89yP7PTkGWzI48mF+DZEo/5SsPfs5tlb4yuNiWbI8whaohcLtGM2LqnZrmG767uXf79yXwmVAB7O77r7oXZGIBJwqMB8isAop3UQDm++jthDlgiG547f9WvjtvGPheZBrO0zZIM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1787134793; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=xVE/TCa3FajtK4vZ9pzEwtCdg70Sj2GwjXUwN4Rwvtg=; 
	b=m1yDPOiyrtBnVbwlCc4yAMvn9OuMq60JTYwKYRz96dPuRsHkh9JWEw9jRJLH3KzrYFhz6ZsgmyU4Ktd4Fnar6xtmdHKBdg+FLg6+i/yGf57NH2YOrjMvHpBZ61cXZLwpIjQKTgbmlC7P0LNCnVBro/Xy32P4nrAZOB7taA09dKM=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1787134793;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=xVE/TCa3FajtK4vZ9pzEwtCdg70Sj2GwjXUwN4Rwvtg=;
	b=Ip3l/sK0bMz2+Y8wX+yCZDGEhK2CXsJvKXXR7Xd+ofltThaYy/FvuKj3spwT7Ap1
	weE5M/KPPWjWCyFh68NS7xH94NEyG9FJ4Pjo5kahcKAJNReqm9UeS4NZJjb8BVFjZgq
	VGFBd45ONz+KGEc8vertMQ4mjLlGQRozXLe/zm3w=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1787134793322567.9703421532414; Wed, 19 Aug 2026 03:19:53 -0700 (PDT)
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1787134791630896.7239743078507; Wed, 19 Aug 2026 03:19:51 -0700 (PDT)
Date: Wed, 19 Aug 2026 18:19:51 +0800
From: Li Chen <me@linux.beauty>
To: "Andy Lutomirski" <luto@kernel.org>
Cc: "Christian Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>,
	"Gabriel Krisman Bertazi" <krisman@kernel.org>,
	"Josh Triplett" <josh@joshtriplett.org>,
	"Mateusz Guzik" <mjguzik@gmail.com>,
	"John Ericson" <mail@johnericson.me>,
	"Jonathan Corbet" <corbet@lwn.net>, "Shuah Khan" <shuah@kernel.org>,
	"Arnd Bergmann" <arnd@arndb.de>, "Oleg Nesterov" <oleg@redhat.com>,
	"Andrew Morton" <akpm@linux-foundation.org>,
	"Paul Moore" <paul@paul-moore.com>, "Eric Paris" <eparis@redhat.com>,
	=?UTF-8?Q?=22Micka=C3=ABl_Sala=C3=BCn=22?= <mic@digikod.net>,
	=?UTF-8?Q?=22G=C3=BCnther_Noack=22?= <gnoack@google.com>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"Jan Kara" <jack@suse.cz>, "linux-api" <linux-api@vger.kernel.org>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"audit" <audit@vger.kernel.org>,
	"linux-security-module" <linux-security-module@vger.kernel.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>
Message-ID: <1a01988cfb7.7f8bf9df842660.5856426206659756785@linux.beauty>
In-Reply-To: <CALCETrU2sCf_Ab2oDcUuJV53mhaDHTtf7QNqPJuFxV_ESHkbtg@mail.gmail.com>
References: <cover.1784204592.git.me@linux.beauty> <538e494dd8fcc677da24ec985c6e90dde554e7f3.1784204592.git.me@linux.beauty> <CALCETrU2sCf_Ab2oDcUuJV53mhaDHTtf7QNqPJuFxV_ESHkbtg@mail.gmail.com>
Subject: Re: [RFC PATCH 12/24] fork: let kernel callers create embryonic
 tasks
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Stat-Signature: zg9cscqskz7bf6pb3tdc8ng4rs1u9gor
X-Rspamd-Queue-Id: 3EADE80005
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787134808-374176
X-HE-Meta: U2FsdGVkX1/3B6R4Ur0RAgq772Pnv+DqSdahRAtedA6mTUN/aU36sE0yMVVfW9Bi/6da8PaSvGnBJD0fDHyNgn12m2ufdx0GpoFrDhnyByThrl85JpNqDDPm0Cl1+3kXk65hQ+8So+5wKACcuyIk0rrKCNQsHOrMKyCyA0IYSzoxHvMhaLwOEUVUcSMTiutwE/2dWKgih6y/jf72srJ3H0/78mFNKKoOdtLYR6DcwcdB4Q4rzoE3T1GweeF1MVlXmb6ecoPQyEe0M4R5L6MvxNSv22VqsC71kdBRBFsXnxPWSNcLwawuuNBwMMOCEILbWTtEis4jXYipivxC9MvEiZvCfJmL4sYdKm/O93kUPYYlg9Jt7vPV7c13DcT1tg88t8v7zwOaozEwuwcLP0yoijGbaQy3xY0IMRG7aH2WqveUcCzuUpLfahKRjeYBT+njoZvfTwnargoZekZkKzVv3ToxeG5a4MCffb31IcjJn6PEKV/1xErgvC9yFkzy1tdj7Y+G52mRmc6CwuGRvYr0VT+a0SOaz+cGpWW+DnmQhy1Sxi1LgSxzvw+rlSqcufKyyO1Yb1+xj0WeT2hbHvcbpFb6L+oelcNBN/7oYjfejswCrBVO6cYFAfhpudhoDhLnf15BFAY/moX24HvhWkS3g0e7B4+LqQcJAg4+WMPbe3I8q8iQRIuV+D3cbAz/3NxNYurtBPmND8I9Xo1auFfyj8kvxuhLUg1xulk2gslawmN0Tu4Q/8UoIrYFHafHB+up6MshCa9xSWvYH6UgLtCi6w/52shxWuWDyHWZhK1j1e8DeM0CuDUxHnmNTwkygtDQ0nyD+je8YkoZAdQ8qCae3AqUaFT6kBOnT1C2MODGCedkaCb3FsSB20/GtJgd4+N0DQSn6K1tMzzoqE3MZq40M3HEq4GIA7UerUVW5ZLa3BMQ6c5DBzEBKwkd1QYhrWHNPYDIhoGCc55bAv4TJbF
 odGAKLfN
 CAbH1CUtG9g6muCqzoNZKdS+A13u4bux/2WACWuViQLlr/3ZtauseZIZeFIZoPWedkIhQ3hUfM4nks7LBPOKzB6LF8zTJTOjQ8uUoNBD+9pI6Ne+MojTuBA+vJkRgHPOT3FMjVxQBOdPpqSXyyS9w8SOUr5wJGs3O7yxhKS7IViMF/t7cF0J21tRjS7lF78cxTU0z8xj+EnQXUwXrjpWnLf+qfKUtgiX6PFNNjsa3H+RrFS+4xK7t3IUqclwx+vhaJRZO1Hh3uIOwDc5JTpRR2yOwmukmA7HbOT6ucUuQpeUbnmMt4WFQ6Bnalr9Z1PVPWj3LI/1dhlbAvyNFeXhnofxJIPXQnyEH2GLgEGqve5VZYM6BsAJ8J8LUCDW2j0f932rZ8mNf7C2u8vQEH5oqZS4wvuErn1d7nPj5ApnU+Bo4RdLc/GyvqbVjfzanwCAS4qY9we9E6RtK0p85ITK0oksLqAN18hOc8/65iUbrOwSYDqH/G6xBe6Z1PrJLZdzqsKy0GNMuiwSJ+ehBDD6/83mVbWBXSrX3KqXz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andy,

 ---- On Thu, 16 Jul 2026 23:57:58 +0800  Andy Lutomirski <luto@kernel.org>=
 wrote ---=20
 > On Thu, Jul 16, 2026 at 8:52=E2=80=AFAM Li Chen <me@linux.beauty> wrote:
 > >
 > > A kernel-created task can become visible before it has installed a new
 > > executable image or a valid userspace register frame. Exposing such a =
task
 > > through ptrace can disclose kernel setup state.
 > >
 > > Add a task-local embryonic flag and an internal clone argument for cal=
lers
 > > that need this lifecycle. Reject ptrace access until the creator clear=
s the
 > > flag. Clear it with release ordering and observe it with acquire order=
ing.
 > > This orders visibility of the completed exec state with the transition=
.
 > >
 > > Existing fork, vfork, clone, and kernel-thread callers leave the argum=
ent
 > > unset and retain their current behavior.
 > >
 >=20
 > > --- a/kernel/ptrace.c
 > > +++ b/kernel/ptrace.c
 > > @@ -56,6 +56,8 @@ bool ptracer_access_allowed(struct task_struct *tsk)
 > >         guard(rcu)();
 > >         if (ptrace_parent(tsk) !=3D current)
 > >                 return false;
 > > +       if (task_is_embryonic_exec(tsk))
 > > +               return false;
 > >         es =3D task_exec_state_rcu(tsk);
 > >         return READ_ONCE(es->dumpable) =3D=3D TASK_DUMPABLE_OWNER ||
 > >                ptracer_capable(tsk, es->user_ns);
 > > @@ -312,6 +314,8 @@ static int __ptrace_may_access(struct task_struct =
*task, unsigned int mode)
 > >                 WARN(1, "denying ptrace access check without PTRACE_MO=
DE_*CREDS\n");
 > >                 return -EPERM;
 > >         }
 > > +       if (task_is_embryonic_exec(task))
 > > +               return -EPERM;
 >=20
 > Would it be better to use a different error code?  -ECONNREFUSED?
 > After all, this isn't a permission failure per se.

Good point. I'm not sure ECONNREFUSED fits outside connection setup,
though. ESRCH may make more sense if the task is meant to appear hidden.
I'll think about this some more.
 =20
 > There's a not-locally-obvious gotcha here: reading other process
 > attributes prior to calling task_is_embryonic_exec may result in
 > (security-relevant!) data races.  This should at least be documented
 > -- it's critical to check task_is_embryonic_exec *before* trying to
 > read credentials.  Also, I think /proc and many pidfd APIs have the
 > same issue.

Agreed. Patch 15 later in the series already applies this ordering to procf=
s,
including cached dentry revalidation, and to PIDFD_GET_INFO.

The ordering requirement still needs to be made more explicit. I'll
document it, move the check ahead of ptrace_parent() in
ptracer_access_allowed(), and audit the remaining pidfd users before the
next version.

Regards,
Li=E2=80=8B


