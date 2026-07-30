Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9821C5516D
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 19:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DF536B007B; Thu, 30 Jul 2026 15:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88F316B008A; Thu, 30 Jul 2026 15:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8476B008C; Thu, 30 Jul 2026 15:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 430086B007B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 15:49:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A224E80269
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:49:02 +0000 (UTC)
X-FDA: 85046481324.06.990C282
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id B3249180002
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 19:49:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fAmkhccd;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785440940;
	b=Mt8yAby52f0z4IEx7sg5nl8Mu4IG7g4AilkcZa7eZLiiIJw9h4ld9fZh4OYizZcAzcN8cF
	2sQjxQ9fN2iU34mvP8lq3d9uBnJ9Kgib7x7xdE6FnF9rrXaiOCRe8QAznvjsY5I7/s66AF
	0yRTjcw7Kee6qj4SI5eVbVMGVAex/oI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=fAmkhccd;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785440940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vKjJrFJSVbDWG64pCEpgQgVIxcNyo9jTQk5m/SvIFog=;
	b=eZIJiFG6ZNwTC+e3sq3RQDrnRwQ3N215H719PxvYr1MOMz47PfXwc7B6gW1HNEOt+AoEun
	fUTEFqJZkp1LNxEqPPp6+opn0cqyBTYmeFgOXdToslvWeaU1xKDruqtl8Cyz/Ayoe4LpU3
	fSmQPCqkLstpcR15oFha2BsQNTbvlKc=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-51c10e86e52so7071cf.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 12:49:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785440940; cv=none;
        d=google.com; s=arc-20260327;
        b=NxomvJho7kKKzVJQn2Aw9OJmmYnJ1MMLtEydHRGL23/oA6lMw7QDMf67Ob8RJApJoL
         dUa1OPaRkwxOaqHqgmfCOly7K4LN10PMfytIcaNFblfbHjCE3MaNHmd0x4nfbXFs1ipb
         qWoQ5WQRylUTA0iK6oCM8oIh0TOZp9ECpSufwNhZYRlgNEAo0K9H+fQFOJj+F4UM3DY6
         Wy2JyaZnXVpwlMjJnrO7AC+tVPL8MR1Qev2kirDhJ9TuZxZzzGL5uXRDkLvQHw8mNKCn
         9fhA861N3NHw0GQJxlcoo6JCCrzoJSV2ePwz9gS4YQbBKNHJfiXx4yf89DCHoKO9NQKX
         u8SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vKjJrFJSVbDWG64pCEpgQgVIxcNyo9jTQk5m/SvIFog=;
        fh=lOFqQiL6QUJ5nJ2WmH5DzQ0grYAM4NsmWSzDUwRsiBY=;
        b=lUwTFa1jRTZypinn+J6mpFQXFkZ4P35/I3k5bvrZp2zwKKKi12Ps1uqUzXdHICxl5K
         592hqv/ymqJuGyQz5wEVC/HZJPj9vh6pxjtBzFKd2Jwtup4gCZaChedZNR2ZKXSStQq7
         VfXKtB7Q59fyPUGS/Hjl3XtNNU1IRg/k3f9Nwm8QU6BJlbM9qLk+gYy/H/iBBahU0SX1
         fiEnzGOJj6124+LYgz+urW9GfzzRL08NcNYPQEDrakAZn+BcjbpTLe1lX+t/n5JSHVBE
         roaNVP0BfGpmQSgYmgj9/VvEMXPpdVZ7X1G0xZ2YxCrIuQLQ8Vfv1nFwnzqj1+G0i1Zt
         2XOA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785440940; x=1786045740; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vKjJrFJSVbDWG64pCEpgQgVIxcNyo9jTQk5m/SvIFog=;
        b=fAmkhccdKQk0rUmmpATVTHOPlGVNBkYw/pvWnnaQwMbR1iV1w4OtGh1jEe5PUIdpLf
         p2CmrTj9k71tJJ/oFhclj1R9Dc18GN9bAZ19kGNJaJg/ATwbG4EpM9fJoSVu3gwuG+Ss
         1Ea0UbRQu8Ou5qdTcVpFeZjqOwd+mgzT6qZFJXXZC1EPgukS1dwbXEIY/PIheVLTUhsc
         gIaLn3dJNdhQUr30Q5uZhrtvrMFVgRv+B+pVa4wY+b6ejt8gCdiHCplVQfOoHpc8m0N7
         spOfZDc0jtnc81b4017/nDr34wq9SVtdkoHc5kRM95vipFz3KDfsrNtS8MRWhs+nyDYS
         F87w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785440940; x=1786045740;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vKjJrFJSVbDWG64pCEpgQgVIxcNyo9jTQk5m/SvIFog=;
        b=MR2FdYF5pg+C/DZCHWu396FEEe1as55+VSDsnzfZdZK3kEpoT+QwJ1aY1NYwHgN4Cd
         IXwEaf87dHbHzgJbyxKr1Z5XuaC8IUZD+5wFYP8atAtaaiRBbwuA/jK8bEyDV6F/nmFp
         W8iQGrd6xRfrUPYLcg2I+e+YwIC5HQj+K3+4TeTJsHqZonef72avrvBOCqc69z7E8z+X
         /z2165k6UFS4nnHIubtUs9JjYGrt+tlmwr7GDarK5a/VR0t2NvzIyLgMVoEmtwjTpiyW
         vHV/SeVtVHv3MzMLJBBBgiJepX7ZcpMCKPfRvMNw+Yj9a2vAT+NYDMt2As+gG29YHGE0
         OQag==
X-Forwarded-Encrypted: i=1; AHgh+RrCgs1Z+lThwrxPt8/6dwyhCIcS+DXx4sYmZnUrCD7aYKI+uQfz9N9aVhlTtu7GhdsJ91GWNu1urg==@kvack.org
X-Gm-Message-State: AOJu0Yyd0+fqTgjWBX4ZrJG/YywnpAxNVunwrYbg5aFanGs3vgiMC3Qu
	DguGpaK3bgkuM7WXW5g1p6pAtjNoXuvGrPsOViYu2qWfJxP0xM6nOklr5NOaAoI5zyBHPR88zPw
	cMTsij0S1NkXksdJZ260U5q9EsV4Cdst1UusEt+2+
X-Gm-Gg: AR+sD13x+CtUPLL/63+Tihch7FzBgu4C1T4fHuUazV9jsTkUtv0ihR4m7gqw0HpCPcm
	YSmVU4PaSDbgo5w6c+RgUX48ioFjhYtIewFzv13zq/A5mm56H5OOoc3QSApjK1mcbbTc2hoPZNy
	lNxxrSWH9CopoWYBlMPLNK11A6jIDOHK10+MhlxR+amhF6YyjJco0fTNa835tn1n4Kks/er2JyH
	34x/e9TBs8O9QGd10NHh/5TxQMWpUCJFI2FjsgHokI+6ucBnVbTOCsJ55+9/L59MFrzNiIOLjC5
	Iewvp4aFQ6L8c8SllgNeJvuWXKr8Lq3+LfaXMaaa5DzZP/puDBnJoZYA1rT7zk3j3LPWoITmn8I
	=
X-Received: by 2002:ac8:7f44:0:b0:51c:ca9:3d17 with SMTP id
 d75a77b69052e-52b455652e2mr3350251cf.12.1785440938877; Thu, 30 Jul 2026
 12:48:58 -0700 (PDT)
MIME-Version: 1.0
References: <2614a3a2f5cb11b63e3cacdcc8ab20a0fe7ae972.1785365110.git.abhishekbapat@google.com>
 <729c578c-e5a3-4351-b07b-469f79c26b0d@linux.dev> <CAL41Mv7_CjWTahWO9sfDZkVKZKEU56j9Sk+xMWN7zbJfRH5MSA@mail.gmail.com>
In-Reply-To: <CAL41Mv7_CjWTahWO9sfDZkVKZKEU56j9Sk+xMWN7zbJfRH5MSA@mail.gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 30 Jul 2026 12:48:46 -0700
X-Gm-Features: AUfX_mzQ_fGmFWLrkyQqBJs2wE2ENvPKaFVP7U5uLfE4_IQ8KRqxCX05LsPK2aA
Message-ID: <CAJuCfpH3W-gOa6r=2jyw6Ckh_HjAAtdF+0LA2Hu8FkwNe1TM+Q@mail.gmail.com>
Subject: Re: [PATCH] alloc_tag: expose profiling and compression states in /proc/allocinfo
To: Abhishek Bapat <abhishekbapat@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B3249180002
X-Stat-Signature: wzi71fzfn3qt9xgtjmdrgf1hu35qz45x
X-Rspam-User: 
X-HE-Tag: 1785440940-504751
X-HE-Meta: U2FsdGVkX184pMe2mvNy3SJh6DKpMF76Osh3HSj5u8A5bdhlb7Ry5S2UDYS2HSSnj/Bm14lI0+Q1qO0gK2b3g+1D4NZonap1lq8jkoTXV5RZqP/c28PBHVvnEjiZ8GBTstqZVRrIFaJ79i2OJf+OmK6mD2paBXHdLMQjaUPYqIbaVsrgiJOywzclv8qJ+LJqgL97t/Y/pMc8P91nXYq0LxJ7VS91EmZLYH/u114lJIM/yQfNoZt8lzpWuId2oGxU2qJ/9yMqg7UfSIzOtVBmc4bBOjj6iljMijdOcgnlDAggdFkXqkm4r7IRRTeCyWKS29VId82mKIMHuewshyVRUpxwDc4S5Ea6EnivDB0bXzayxm+LUqUEe5fCsU5z0nmccrRCHCRJt8pZ7+ht5GNww5AL9OgIaOte5tKOLnP6f4wo/zN86JROcDoo0mfvqqgrQT9nljFz4hpmJOiI5JUZyCDxI5RAWuYdja4BbCD8SnKRmU4di7gZRXRyritIcaSGZvpw0nbhQGQFgzS3AYBkTg4kiF7o2c91sCOzRbQAoC4E+ad/o1fq0ABtGHaZTgAl4Ysld0Zyd4J0ybB+hUjr4EUQCVc51+CuLrtvVXOTYmKHSy8oNcVTBpFSwief8lOichVlvy/0LBUn9WGZyWhjNxZaxqFnWjCgBG8lAY9v/0e3zbcoo01rKykRk+Q+NLh6JNBhAvM8u+lWmenPzWt4R92VMQ6rUo1Dt9Ue3QT7u60aiVT7ijsqrsVF12lvWYxWUWybRF9NvOxVjuxvtTlKSt+KbcHyNsK72bQ5YyKCeq1fPUYYBmT/w8x86xA52n8axsTQqWm2B7zGei+xlCKHE7VQRUJfkkZ/Ta6YeK/hzZPeAQlGtOOsQ9WFP/Jmkox5FZvB3LgX03jB8AX8hwNShOzKsZU4UW2cDUvVoxiEPgYxqMyTsXhm7j6kSylnO5ebmagua0PUSsgt8cH6E73
 siEcnPMH
 06nFlBPQdSkdMsgOHk7gqopR9qWnNFQEw6tBfkCNDJve4gaHOMZqEoyYB+UTSvrja9+zCpP6rGFNbsDHbWDEnD+vQWFbHtiOnPY2i0xaSVRXN2/omB2ozVt4a4ta4xem0xYjJQSPzEUrHZkEOAVxR1dHXNXpFGahr1gR6Ltpl4ugMOz3tlW4U9C+Xvdb5qoZok+1Xop761v1DLUj3axhmY9IKyO6UJuNIWByj6AHDBCxIXGPLBJSU74psfMA3/429fbLT5woHzxp4boJfODBSreZiNDaXrm3nv9BPOgBIFyaaSeVJPsyM5noweQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:57=E2=80=AFAM Abhishek Bapat
<abhishekbapat@google.com> wrote:
>
> Hi Hao,
>
> Thanks for your review, however, I'd like to disagree with your
> points. Replies in line:
>
> On Wed, Jul 29, 2026 at 7:23=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
> >
> > Hi Abhishek
> >
> >
> > Thanks for your patch.
> >
> >
> > On 2026/7/30 06:49, Abhishek Bapat wrote:
> > > Currently, userspace has limited visibility into the exact active
> > > runtime state of memory allocation profiling and its page extension
> > > compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]').
> > >
> > > While reading the sysctl provides basic on/off status, it is currentl=
y
> > > impossible for userspace to natively determine whether page-tag
> > > compression was successfully enabled without scraping dmesg boot logs=
.
> > > Furthermore, since /proc/allocinfo remains in the procfs filesystem e=
ven
> > > after profiling is dynamically disabled at runtime, simply checking f=
or
> > > the file's presence does not reliably indicate if the allocation
> > > tracking hooks are actively running.
> > >
> > > Resolve this ambiguity by appending the active state directly into th=
e
> > > header of /proc/allocinfo.
> >
> >
> > It's not obvious to me why userspace would need this state.
> >
> >
> > Suppose userspace reads mem_alloc_profiling_enabled as disabled, then
> > the profiling
> >
> > gets enabled later. All allocations generated during that intermediate
> > window are lost.
> >
> > When users later cat /proc/allocinfo and see the enabled state, will
> > they mistakenly take
> >
> > the output as a complete, accurate record?
> >
>
> Currently, userspace has no mechanism to determine the actual internal
> state of mem_alloc_profiling, meaning users are forced to make
> assumptions regardless.
>
> By exposing the explicit state, this patch allows userspace to query
> and validate the state concretely rather than guessing. If the state
> changes, userspace can immediately detect this and react accordingly
> (for instance by invalidating and / or refreshing its view). Rather
> than introducing unsafe assumptions, this brings a clear, testable and
> net-positive improvement over the current opaque behaviour.
>
> >
> > I'm also unclear what userspace would do with the compression state;
> >
> > this is just an internal implementation detail of memory profiling.
> >
> > Put another way, personally I'd prefer /proc/allocinfo to stay lean and
> >
> > avoid exposing too many internal implementation details to userspace.
> >
> > Unless users intend to dig deep into how memory profiling works, these
> > extra details
> >
> > will likely only confuse them =E2=80=94 most don't care about internals=
 at all.
> >
> > It's similar to how we use APIs: we only care about what an API achieve=
s,
> >
> > not its underlying implementation.
> >
> >
> > Could you share the concrete use cases for exposing these states to
> > userspace?
> >
> In large scale production environments (such as our deployments at
> Google), we can only afford to run memory allocation profiling when
> compression is enabled, as the overhead of running with compression
> disabled is too high for production workloads.
>
> Currently, there is no way to write an automated regression test to
> validate that compression is active. Exposing this configuration state
> in /proc/allocinfo provides a clean, concrete interface to write
> regression tests that verify and enforce this constraint in
> production.
>
> Hope this helps clarify the intent behind these changes.

Hi Folks,
Thinking about these states, I tend to agree with Hao that compression
state is somewhat internal information that most users should not care
about. So, adding that state into /proc/allocinfo, which contains the
data user cares about does not seem ideal. Maybe we can expose that
via some other interface, like /proc/sys/vm/ or debugfs?
I also just realized that profiling enabled state can be read from
/proc/sys/vm/mem_profiling, so we don't really need anything extra for
it. Would you agree?
Thanks,
Suren.




>
> Thanks,
> Abhishek.
>
> >
> > Thanks
> >
> > Best Regards
> >
> > Hao
> >
> >
> > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > ---
> > >   mm/alloc_tag.c | 6 +++++-
> > >   1 file changed, 5 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > index 52aece27b00e..89ec2c6ce57a 100644
> > > --- a/mm/alloc_tag.c
> > > +++ b/mm/alloc_tag.c
> > > @@ -108,7 +108,11 @@ static void allocinfo_stop(struct seq_file *m, v=
oid *arg)
> > >   static void print_allocinfo_header(struct seq_buf *buf)
> > >   {
> > >       /* Output format version, so we can change it. */
> > > -     seq_buf_printf(buf, "allocinfo - version: 2.0\n");
> > > +     seq_buf_printf(buf, "allocinfo - version: 2.1\n");
> > > +     seq_buf_printf(buf, "# Profiling: %s\n",
> > > +                    mem_alloc_profiling_enabled() ? "Enabled" : "Dis=
abled");
> > > +     seq_buf_printf(buf, "# Compression: %s\n",
> > > +                    static_key_enabled(&mem_profiling_compressed) ? =
"Enabled" : "Disabled");
> > >       seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
> > >   }
> > >
> > >
> > > base-commit: c73b725a57f276a3702ca213bde78fca029bc619

