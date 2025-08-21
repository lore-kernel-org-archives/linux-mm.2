Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDCCCA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 04:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B59F66B00DF; Thu, 21 Aug 2025 00:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B391A6B00E0; Thu, 21 Aug 2025 00:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A47F76B00E5; Thu, 21 Aug 2025 00:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 93F6D6B00DF
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 00:43:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EA42F1A0250
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:43:43 +0000 (UTC)
X-FDA: 83799521526.27.7799C7E
Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	by imf05.hostedemail.com (Postfix) with ESMTP id 19EE410000F
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 04:43:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jFiuzlBP;
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755751422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWvhKp65AxyP1xwVvIS8MuCmDuU/KsXcWzjgpycsbII=;
	b=VdD3k8XlVc4LBftx/w6QViUs08IDuEVq7hTteWIkpb1SMUdHe/uZq6ETDm2+C/Yh46Ub29
	LqUaEaALqB55l+A4Mzu/KewaC60lapXZhBH0sIEzkl+RjZW9WNGx5sJZ40xnFz3ho+r8k3
	lRZmCnM69QOpfhtDvIOmwgHqBY8WIiA=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jFiuzlBP;
	spf=pass (imf05.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.161.50 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755751422; a=rsa-sha256;
	cv=none;
	b=SCpH+VapddvXJ5BQxGZNjD0tSwncpnapo4rHkzU30xBCisiLAnu9lnm+11Vt2z74NxT2Fh
	fkWFQtWt7MOLlvM9pAhgXF/oMjsD9Lyf2QoPEuXf6AoX/chd0ESSj6yg7SBdsUoP9lmih7
	U33dh5wahgYYMmpIhAvSpM96jiVd90E=
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-61d99c87ddcso130634eaf.2
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 21:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755751421; x=1756356221; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BWvhKp65AxyP1xwVvIS8MuCmDuU/KsXcWzjgpycsbII=;
        b=jFiuzlBPHbFeGtLyfCFGig5hoXuoRSyKFyIMHZnGhNF2pzL6CtwRI4v1qwjYD/DGFs
         EnknCMHJoK1IOsrvhC+uSMsHElS2CK+chb/006swt79lfoSUl7xLr/xnkXon7pMUSlxK
         aePPhNHAYazmR0N2wHh5LucdvQblcYZPR4uGAmc9aEekVa3SrzuVhl/IT1jGVsA9AsoY
         feJunWLXbrsvLM6pFf6UYBr80t4MQ6IHDISJSoTYG5v0CSqVQYahLlKS3HJ5kmFOOalR
         b2bPh8QGiWX8cij6dv4ebj7zvibYYr7CTSHti200gGEYK7DQ0U0ecpEVDr2bWDL2xYTh
         UsBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755751421; x=1756356221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BWvhKp65AxyP1xwVvIS8MuCmDuU/KsXcWzjgpycsbII=;
        b=xOywaE53SNXEg7FhSkL2fqpv+wzXhlLQHbhrANi6ASOueDiMI08Tj6LUueg6R5VGQL
         6bxzbIzUqlNoppPTgHtgaeuhpuYGLhQZpBnue1MepktMxOaGBBTcPn8qpbbc3iqFEAij
         pcoq9RRCJ7kaCcbpsCpijjKVnwGkjdDoP0igOktJHonAP6D5BaUkvJK+/v3y+BGDXgL9
         fvtedf0RfznfTTZMqVut9qsTPJ85EYYijHauWiixGg81Knkj9vU98LzjFmOlFsAjr+o1
         q9EzbqO5F91K5BfKPswtbikccEQ3z5VR9xK0Q0AZHTyFVVGG8MJLVNBccy0/lO73G46s
         PyAA==
X-Forwarded-Encrypted: i=1; AJvYcCXWdv/Rd/uMpa0pYa5sObMuprz+m5+8Mtx/3NZE2XPhbVu0Wj4g/8M/FFMMQw0lLaem6GT+9CpXSg==@kvack.org
X-Gm-Message-State: AOJu0YwKjGZByVOGLGbtmmmKTSIT52T2hXQtcuEIlIOGrHRuXnMwRnr7
	G1J++g/TLlZY5sbp5tYqC7vrsNop4xmMbLAx7ynaLqpODX1uV0NBKH6tAIdSAaxc5BKPmAn2a5J
	KAtVw0C+E2NxirbYfck9wIiAH28XWj4g=
X-Gm-Gg: ASbGncuTM3ZgA27MPbnwDt4L+5gA6V0UTDJMzzd2bYl3yymNKYgKvdWZ9iRzyU7iuei
	a4dAz2Y7dA/fTIi5zuwktnO5hZAYAWnpF7SXE6p3bLvulnTUQym8WoP1PsZ6hjyFnpcPq7tIjnq
	1Xme8LGK/8wyCS8KicDsbVp0+7sANhLFFKFTvWGKPkMKrIA3PCys6/uMzLzHSTkK7OsO6T2MSw0
	ZeW
X-Google-Smtp-Source: AGHT+IGjprBbj/E2Wm4laG+alOgDHLSfMegvi1WsGOjDb1e3hjmUvLF5JnP1I0EZQkV5dEYbsLY1up+jOJ8PGChnNH4=
X-Received: by 2002:a05:6820:1b87:b0:61d:9adf:eecc with SMTP id
 006d021491bc7-61dab25dee0mr434089eaf.2.1755751420981; Wed, 20 Aug 2025
 21:43:40 -0700 (PDT)
MIME-Version: 1.0
References: <CABFDxMGmVgswVoZFgBz=7xqA59M7fMt0jw2QHqWjm-W9tZktWg@mail.gmail.com>
 <20250821025423.90825-1-sj@kernel.org> <CABFDxME5ZEAn+6=0GRWybTi-xBzbhhz7U38pMni3SdKjA+Aj-A@mail.gmail.com>
In-Reply-To: <CABFDxME5ZEAn+6=0GRWybTi-xBzbhhz7U38pMni3SdKjA+Aj-A@mail.gmail.com>
From: Sang-Heon Jeon <ekffu200098@gmail.com>
Date: Thu, 21 Aug 2025 13:43:29 +0900
X-Gm-Features: Ac12FXxIn6O74TtxGWb4mmUw96J7yYYLAjMBUSDDJprJWR81IQ6dIXiEhH5f3OA
Message-ID: <CABFDxMEYXpQRS0fMdE-qoVMHym2Cp+2Uh+pXwB5h0MdvWGdiew@mail.gmail.com>
Subject: Re: [PATCH v2] mm/damon/core: set quota->charged_from to jiffies at
 first charge window
To: SeongJae Park <sj@kernel.org>
Cc: honggyu.kim@sk.com, damon@lists.linux.dev, linux-mm@kvack.org, 
	stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 19EE410000F
X-Stat-Signature: pyfrp3e5p3kaf9y8jenbpws5gtpdpyoq
X-Rspam-User: 
X-HE-Tag: 1755751421-690282
X-HE-Meta: U2FsdGVkX1+02mJ3ziiCIwz/BaNtXpz2Qz3OA9isL6AdOcGaUR0av8nnX0pzIpCeTcKdiXoMZSORnKT5j2EF26O9rt0gXNugsL5qyry0z4FbBlqSAJMSOgA1Jy5VvF5Ln+iqQxthexaNCVSldwK6mOqiUeNjyotieH3t6CgqS1nrt68KWDK1ujJr6KJOB1EOXT6DeYbraudiv+Jf31KhLdbt0TSW8rQ35pNnaIEoK1oS/U/fUVR5cF4lIp+FsxRVZTpSOaFY5EiJxVRc8UOYpGWgQCPHO5qt2hnzUeKz17ljJteUUWfYeBUUL8k/f6XRphLwtvNSy0/8wV+bGGsV7jQGGiYebYX0Y+n6o45CbdWqihN1J+50ps7tuOWYK+W7iHGpj3tu2EVsi/KcOGaaItjhGEpSoV4VyTInFL1ZjE4MdEIhNNWDthivy6ptEQoSxNnJQQCCThjuHwATPoL1QM4+u+oAnsu/o9TZH/CELgKjCqw/rod81rl3UV/O3JZ/jcsYcdaNvoLmZGTFbHtIeGe54mD+V9Ys28AAmK5wxTvLpAkuuF0xhyAfkq/d7wP7shJ2F9P/6R5RjvMuUrGl9UZyG6mv63UYoZa/I2akQ/7BbTpamGp45qRtWYmL4VOgErQO0S6u0Q9hfIqDWJAF4RsuK3Ke2sQWCSfAzU7zeveC8cDI+CWGDnpo4uTsoBzr57woovaDgGh6Xe8WlgcnL4axCWQbhfD4tLy36cboOl0h3FE8TQEZzyVKIugpBFIVf0Fel5MaWoCn8XJDk83WEOV8F8wvtHV49Ci4/LVzPsu2VWYMXfwhXiFe9t3tnF8EGltf2QmN8n36xRJNJ0uyGJhTUvMswWUDi9j7An39N/jQ2S4G7cexg/0mlKJvebZcm7FrTctUQq6WeA+26fQtST58eGLN5xoxCaEDbH36Qy6cT4jzkMN69blkpI65mbPOe/BF77aXa5nORlE48o5
 F6a0dizP
 f0M75lrm/32H7vuOJkLDHrrh4MmJl1+g0h35pl5bOK1W3ZZknhaEIb/LLoTo/rBYn432ecR/+PqDt24gwVvnVMltPEcTZ0ArHYYybKjlgg9ka8/vkyCIbFvJ9i0cVYywwo8UfoSXYJYVu3kDQmiPYnaytOesORji9ikVKxANk2D0M2fVUnUcVlRwLzgD33zJbnjHihFttposzOccLedCcbMNrxcUcInucW5glmuQDmFNHNnTUKgtuaZfbpNnOGTwcwivEp9izmnZ/7MzzlEf4YTcjt0bpeyvwZasohDfhgptgLPuzCL6wIVtRVqccfLfOAZOM4f1bu0PsFdgCOxZ5t2uhMO6newAJUQgw7aNP5lT3UzhkZ+/IWGwRI5Rp6H+H94730/wAi3CN6umRshVnfJcbeZ9ykZWuCluZ9TjqwR3zNmJS+gpZ65Umf6RSrw58CAiN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(Restore missing CC) + Andrew

On Thu, Aug 21, 2025 at 1:29=E2=80=AFPM Sang-Heon Jeon <ekffu200098@gmail.c=
om> wrote:
>
> On Thu, Aug 21, 2025 at 11:54=E2=80=AFAM SeongJae Park <sj@kernel.org> wr=
ote:
> >
> > On Thu, 21 Aug 2025 10:08:03 +0900 Sang-Heon Jeon <ekffu200098@gmail.co=
m> wrote:
> >
> > > On Thu, Aug 21, 2025 at 3:27=E2=80=AFAM SeongJae Park <sj@kernel.org>=
 wrote:
> > > >
> > > > On Wed, 20 Aug 2025 22:18:53 +0900 Sang-Heon Jeon <ekffu200098@gmai=
l.com> wrote:
> > > >
> > > > > Hello, SeongJae
> > > > >
> > > > > On Wed, Aug 20, 2025 at 2:27=E2=80=AFAM SeongJae Park <sj@kernel.=
org> wrote:
> > > > > >
> > > > > > On Wed, 20 Aug 2025 00:01:23 +0900 Sang-Heon Jeon <ekffu200098@=
gmail.com> wrote:
> > [...]
> > > I think that I checked about user impact already but it should be
> > > insufficient. As you said, I should discuss it first. Anyway, the
> > > whole thing is my mistake. I'm really so sorry.
> >
> > Everyone makes mistakes.  You don't need to apologize.
> >
> > >
> > > So, Would it be better to send an RFC patch even now, instead of
> > > asking on this email thread? (I'll make next v3 patch with RFC tag,
> > > it's not question of v3 direction and just about remained question on
> > > this email thread)
> >
> > If you unsure something and there is no reason to send a patch without =
a
> > discussion for the point, please discuss first.  To be honest I don't
> > understand the above question at all.
>
> Ah, I just mean that I need to make a new RFC patch instead of
> replying to this email thread. I'll just keep asking about previous
> comments on this email thread.
>
> > >
> > > > >
> > > > > In the logic before this patch is applied, I think
> > > > > time_after_eq(jiffies, ...) should only evaluate to false when th=
e MSB
> > > > > of jiffies is 1 and charged_from is 0. because if charging has
> > > > > occurred, it changes charge_from to jiffies at that time.
> > > >
> > > > It is not the only case that time_after_eq() can be evaluated to fa=
lse.  Maybe
> > > > you're saying only about the just-after-boot running case?  If so, =
please
> > > > clarify.  You and I know the context, but others may not.  I hope t=
he commit
> > > > message be nicer for them.
> > >
> > > I think it is not just-after-boot running case also whole and only
> > > case, because charging changes charged_from to jiffies. if it is not
> > > the only case, could you please describe the specific case?
> >
> > I don't understand the first sentence.  But...
> >
> > I mean, time_after_eq() can return false for many cases including just =
when the
> > time is before.  Suppose a case that the first and the second arguments=
 are,
> > say, 5000 and 7000.
>
> I think my previous explanation is not enough. I just want to say,
> time_after_eq return false, but user expected true case; And I think
> that's the point we want to fix.
>
> Maybe I can change my previous question like this, "Is there any
> situation, that charged_from has been updated before and even though
> reset_interval has passed but time_after_equal() returns false".
>
> I asked this question because I think that kind of situation can't
> exist and minimum version of Fixes patch(5.16) uses esz in the same
> way as it is now. So I think that we shouldn't use "stop working" in
> the commit message.
>
> As I was writing this, I thought about your comments deeply again.
> Since you describe the current state of esz as a bug, I think you
> might want to write "stop working" to comments, because I think you're
> thinking that some fixes patch could change esz initialized value
> (also reasonable, I agree)
>
> I think adding an explanation of the above knowledge is good to help
> newcomers to understand DAMON well. Also, Could you please check the
> above question for a more detailed commit message?
>
> > >
> > > > > Therefore,
> > > > > esz should also be zero because it is initialized with charged_fr=
om.
> > > > > So I think the real user impact is that "quota is not applied", r=
ather
> > > > > than "stops working". If my understanding is wrong, please let me=
 know
> > > > > what point is wrong.
> > > >
> > > > Thank you for clarifying your view.  The code is behaving in the wa=
y you
> > > > described above.  It is because damon_set_effective_quota(), which =
sets the
> > > > esz, is called only when the time_after_eq() call returns true.
> > > >
> > > > However, this is a bug rather than an intended behavior.  The curre=
nt behavior
> > > > is making the first charging window just be wasted without doing no=
thing.
> > > >
> > > > Probably the bug was introduced by the commit that introduced esz.
> > >
> > > Thanks for your explanation. I'll try to cover this point in the next
> > > patch as well.
> >
> > If you gonna send a patch for fixing this bug, make it as a separate on=
e,
> > please.
>
> I didn't mean newer code changes, just commit messge. As you said code
> change should be created with another patch, if it has another
> intension; Also, i didn't have any plan yet. I'm trying to resolve
> this patch first
>
> > [...]
> > > > So what I'm saying is that I tink this patch's commit message can b=
e more nice
> > > > to readers.
> > >
> > > You're right. I'll try to make the commit message more clear. I'm
> > > really sorry for bothering you.
> >
> > Again, you don't need to apologize.
>
> Maybe, I just want to express my gratitude :)
>
> >
> > Thanks,
> > SJ
> >
> > [...]
>
> Best Regards
> Sang-Heon Jeon

