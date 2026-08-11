Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A034C5CFCF
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 11:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40CA86B007B; Tue, 11 Aug 2026 07:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BD2A6B008A; Tue, 11 Aug 2026 07:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286B86B008C; Tue, 11 Aug 2026 07:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E95706B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:16:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5CCA01C1095
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:16:45 +0000 (UTC)
X-FDA: 85088735970.14.AFAC881
Received: from mail-yx1-f42.google.com (mail-yx1-f42.google.com [74.125.224.42])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6C78D180005
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:16:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KRl0S/mc";
	spf=pass (imf06.hostedemail.com: domain of vladimirelitokarev@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=vladimirelitokarev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786447003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=twCriJJyPDkrFNQ//1T3Z3bxqMxGixd+v6Z8PIqxN5o=;
	b=I35fktRrhw6u2AUg8/XiHn+1vAvlIIXbThevbS03hTKP+/pRHCCYViA90Tn5fANL+EpuJc
	vJW4tEVXXNmyOGdaOzdtB4LKPzFmrAdqaIkAW+ZGTx09MBQ4Tx6ynXEEQcUEfKxm+aBTkB
	S+czWRyhUHtMqLqy6KgAxFEDcSke2q0=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1786447003;
	b=DrrFQ33vXcMkreGQcoKlzOcNp3COoEoCOG7Sl/xg98FTjV+SX9y1CUit0GS4TR/IM8LYlz
	uISWqoP14JLLtZyr2ePl0qa/P5uw6BiVkBpgsiGJRsLoVpaCYPRz2Fq3nVj6dZq4Vku1Ec
	uZnmEUxYoaDrruF9w9wu6mS2I8Xpjvs=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="KRl0S/mc";
	spf=pass (imf06.hostedemail.com: domain of vladimirelitokarev@gmail.com designates 74.125.224.42 as permitted sender) smtp.mailfrom=vladimirelitokarev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6689402c7bfso3076808d50.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:16:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786447002; cv=none;
        d=google.com; s=arc-20260327;
        b=VhbvII/qU625ky4nn8+YfFgd1SI1bccf6FwKBjCl1raNkqrWGSuoL0A6w9Wj6NPhMS
         ZHq9c/MgdAIQXON4sgA54i4JhUApAzWXJF/Wxq+XiC35ghytaQu0vODuhKqFb7qS7qKk
         jzXBLqnjzU42k8sURl/BupvmzMctwOjb2shUXT8xkuO93VaFkGMYyuaLalvddPWbx0Kq
         jMKTa5XIVDATXjM0F1ysdpZdV0Gd+j3vlOxqUcJHTUYLaa+iZABdZ+Xhj8RmE/eCsFx+
         5h6NRhpUvlF5Cj/vcxpdyIMtRZTlqEwPF8skMZWjFyXpnXj0Naw/ED7e1sNrDv7wGof0
         PFtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=twCriJJyPDkrFNQ//1T3Z3bxqMxGixd+v6Z8PIqxN5o=;
        fh=o9irZ4Q+dIxVHNGO9B2A+UrZTczROABaLAEdJD8mEHQ=;
        b=P7/DYZh/QCmAiCjqOBxyfFM3qMlh1GV8WodMRF0JJlkbDqxH2v10btrPJDe39ukIW5
         zb1u6AKCNMxmViY1YectUaUCE5gIIawmDNcW+4CNSCzBp2GuPjcd0KiS73f23KNLLZzn
         8jWhTncfa2OFUb8TSHiPwEJq9ReVYLAFrTq00zTLHQRbii+osIicHVNFDAZIaal++Vs+
         1IQdzZ0vHHCCaXJJ/9tAju+wRwynHYpeob3BcfxrIGpT+3/17f3ILZuCt30m+w04CDuk
         p/5csOGyqjXJzjOsCk7nzdTnFOovtaKDHSn+JOyuAfQVKdbmXKrOPpOSaeXhipDwCHw7
         GoOg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786447002; x=1787051802; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=twCriJJyPDkrFNQ//1T3Z3bxqMxGixd+v6Z8PIqxN5o=;
        b=KRl0S/mcYYISiUg4HkZAi6ap1tBq3rhZH85zOykku22LY6p7hzg0KfVhRkjgvmHYJg
         Aug7BTxUTBEH8rts65SbDKsxU2HM5bAyggxsf95eR+TzCOCkliMr8yZvvWeVsZMDc5sc
         Dxkzsu4uOUVF0LTe0RZM5Z97qLecbjKW66Wvu2L3iV8Sxa8pTB4+QTmSOiFWo6UZHvCG
         ZjJVe5m3/n1641g65SUJVc7aU8a614a71n8DM2DHIpgGsZP/vPqp4JxQ876r5bY8WF+T
         DV4uvtiEXqdH01olK2t7LGg8LqC0J/DaCi7Sgg6oBPp4z2qBpNo5tfdI6iV2LXi5RxL9
         CUxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786447002; x=1787051802;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=twCriJJyPDkrFNQ//1T3Z3bxqMxGixd+v6Z8PIqxN5o=;
        b=BM81tDMw6J1z764Op7fhQx3obej99EyyIxQA9w4+h/r4uI1UKMfTVkIOsM/scjj3a2
         4quEMfwGdJkirvQYJT2qfegcJTYphKHPiXXn7Mu8iYxojdZbbes8AnpPUGbRJFg9XCFI
         X5yRsMf7GLr2vmOJJiy8tsbc79hnx6zJH+3d7YborN+TGgJO3vfoMIyU6e3wEcmGb2kB
         eGkNFxAxzibW/NX8PFQNlcp0M0oMsyfbbMe6KI9N9m4qyZET6eKe1RUyDf7qeo5su3Oi
         ifoEnnpjoEJ8tQTr2P+SmvkRWwAJQUSiyig4XesBb7Nx7+7wkYxYa1poc+yD6DthbOfj
         4YTw==
X-Forwarded-Encrypted: i=1; AHgh+RrHgBYzVGY0LP7pRtwPmWg1kKGVpmpVwiy5KwR/AcC4YWTJyscoRAaA9r4mFxg9o0fFhLbwZH3qyg==@kvack.org
X-Gm-Message-State: AOJu0YyZsLxXHHJjj4dkqEUu5pEqJFW+j3u+Xo9Ahn7oVH3evLLdIBI4
	A1KXgjzf7zMZSzuP80Zf8BJfOWcmyVYX/CvI5WwtBFgb0JonIkXGwGU2MSW5d2wRhyYl3JQLTOM
	lWB7dhiSyAtIdxYih5NYpVUpEms1gtQQ=
X-Gm-Gg: AR+sD11cat+NUxbNurWRfbKHydHoY1EjqJwV6f7kz0bH2pY5oseVc/iuZnnWSjH5Dxk
	kJtlOgyLLhDxs4by1u0z7fy2ze1tqjkQYsaiGXSFywCC/+rll+ddZOPHkYac+tSdpqDgOE/8aVV
	tnUOXwi0IhG2fS3yo0iVhjWlCwhoLjAl2msSiliF21G92qJi+n8pb6A9KnYTp3dFG1VFyzq/VL4
	vvB84hEuCKJjQiDgqAxFiUSBw18KAJcCjBOPjnjJj0XFyJz8OZZMnLi+czK2b0oGrTgsU4So38d
	oKvkeDFCpXnIVJELiRrVvtCotIpRbpWwU9CyV3vvu8Tznyvnj2CvaRrmCvDD6qZIZnIh99IOVwt
	SGo6ZuX3g9QA1cHxmwg==
X-Received: by 2002:a05:690e:4284:20b0:668:97f3:d58 with SMTP id
 956f58d0204a3-66b2326d87fmr1306809d50.52.1786447002288; Tue, 11 Aug 2026
 04:16:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAGBKPgOm8q-8_rwyRPEmSj8JXdh_GaK1Q8vpJ=j-+yA0SgcNQw@mail.gmail.com>
 <CAGBKPgPPALX_5CQJAKUNjwi2fD28pBeS5pRuwQgePU93pOy8EA@mail.gmail.com>
 <anXnHMInq_JLYbWc@pedro-suse.lan> <CAGBKPgOfbMJruqcegJca6BBpEtpd91s5ASF_VU+gucWsjwp8WA@mail.gmail.com>
 <ancYCBUT8aB0qHwz@pedro-suse.lan> <anlOGOmO1HWVCMdF@casper.infradead.org> <20260811-knieprobleme-holten-palmen-4d42742b1962@brauner>
In-Reply-To: <20260811-knieprobleme-holten-palmen-4d42742b1962@brauner>
From: vova tokarev <vladimirelitokarev@gmail.com>
Date: Tue, 11 Aug 2026 14:16:31 +0300
X-Gm-Features: AUfX_mweP3B_jaoMY_ByYQQO7vLr1Pzgi5nGdB1pQUH9ulCDjdFpdDOlKF97Mt4
Message-ID: <CAGBKPgPanzn8WuHK1hm44FLCXwJcnk7W=J6b17D9UzScWW7SJQ@mail.gmail.com>
Subject: Re: Fwd: BadBunny: UFFDIO_COPY shmem killpriv bypass leading to local
 privilege escalation
To: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org, 
	security@kernel.org, linux-mm@kvack.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	linux-fsdevel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000fb459d0658c39a7b"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ywzf9k9rw4xee963fu78gyg5iwbpreaq
X-Rspamd-Queue-Id: 6C78D180005
X-HE-Tag: 1786447003-263615
X-HE-Meta: U2FsdGVkX1+SGGyddaHkPtLg55lB84UGdTDUu2ESd3GZINbtuj8Ucwt2tu2WnXs81Ijd6RuMyFzc+jvllbtZGvhBxkLg6jIT+Xz2DlsBYY20tUXhxqWUKLhLtwZVi/S8a1Rz3gfIwye7KRYScSF5aNMsn8td+iCP+zlcdlxIp/ajE+XWcr0f2TzEFg1tX+JCNG/AysTJnlkv4R04ifJD8HgwPpl50Hr5IOxP1wCU1uN+CJ/1gqSI/77lGImFYP9dGM3H2ZSrlaubQcO4CjoRhOB6iGTNwwOVmjPhWN+m9j69xeKmw6tOI3BXVr1jZv6GGJpP3i2yL2UmDWAzadnFxd3rXr/85XWbjYRbHNApKgsWF+KIwOL2KPf7IXpLnJHWCgIZQso4MBxsA1NLxRJEcE71dfyb/nB8gGO5n92cGZMUOyys/ojNmFX9SCky3vgNZOgxDkC62nzPMKlr3spA24RaD16udbjEpNfAmSCpZJAbUvwrF/fNjXI24EIgEGg4+dg6Qsb8SLXRssDCsNn0rL/vdux/vUDNijqj9sp7QDa/VKID4gl5LpwQy3UE4kKaBkWZVeP4QFeZ7Lr9R40LECuNx8oBUCmV3xo0hL16HKG5e4OVdnLoaCS9mT14NVLkmr9SvEyJff2klmK9f6TJRq15nQn5eFNN1iDVln6M1xXB6DgcndZ/V7FnxtwCojbEz5S1Zz9FNbt52+d/XkQ/q0hagPtSWBEr1qjgb/y6a78g5cWD3uWMMHCVlJC3V5voavd5I9GlbQojdFFN4Xhy90j87OPl/w4VV6kvXY9woYECcxz5aPcClF5A4AkasK9ugiF0G0IblylLNqFox2l25z0/TbGbkSwqNOZr4lyW/afH7JA2eNk/Z2DJZhsjWU5kc8/YO3JDmLsT4GYKVSPu4AIAwallfMZl6bB9K7pQxrzFy2+D5VdNxRXiin1ryco2sxqyQncVT/SRPlqJO/g
 w7PmxmSn
 TajPY7IZ5/5DKXfvGVBdRGbn2FguvBvvcZoEHTFwPm0SNuth4DOhEz5gODabBCBtEMkb5fit/TVFRmYbKhXfghAUqeLM9qAvj+V8iwF0kcVMqW3cuQSamiOUUUNFpGzBAv7fPtt3TP5UQ8q1bRtA8d3JePLjBGapMVHYQTmAEcfa+HLHew2z01ck108obvLtRgJ2w4GTF29zRsJv9wFYU/WV4hjKh8bnAVsUsHzaTNPVIZ6u0olNxxyqshx/zJzNSvmMrVOQ7mgN2Q4QE9rTf7D+RvHkLx0ifXLp8C5C5x/yJ3oytNg5F8Fj1YYGu8Cv4S1XGXdma8PzlfGY/aKhKQCLPng1FI9INA4AvXe79Zr0MSwux17F54iPbAHRVMbnZ3d0XsG2Mkt4yitAygCaxJYmdgmrYfdR98E7hIofxRw9IJ0Evz0aYzbXypjnBi1toxuEG0yF6zK60brj5QDn/AbSjeDGPqwqNI1G9Omjo8ZDiJcv93CuFMk3NvLWrqUaMABCJbHR3uWErR+JL+Kcm6K7sua1qa22uUP/v6SRWf/oLMPprn4T6lz+Qusv8AWT5Z/dW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000fb459d0658c39a7b
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Matthew, Christian, Pedro,

Lol - fair point, I'll keep the reggaeton references out of future
commit messages.

Agreed on severity - but this is a
killpriv invariant violation, and the kernel has treated those as
security fixes worth backporting before.

1. The fallocate killpriv fixes (XFS fbe7e5200365, ext4, f2fs) are
   exact precedent: same reasoning ("can change the file contents [...]
   should drop file privileges like suid just like we do for a regular
   write()"), same one-line fix, and they went through the security fix
   process with CVE assignment and stable backports.

2. CVE-2023-0386 (overlayfs SUID preservation) -- same bug class,
   CVSS 7.8, CISA KEV.

3. If permissions alone protected SUID, write() wouldn't strip it.
   killpriv exists for POSIX ACLs granting write to non-owners,
   group-writable SUID, container shared mounts, and chaining with
   other write-access bugs.

4. This path is reachable unprivileged even with
   vm.unprivileged_userfaultfd=3D0 (UFFD_USER_MODE_ONLY bypasses it).

5. Pedro's point that MAP_SHARED faults also skip killpriv isn't a
   counterargument -- it's another instance of the same class. We can
   fix them independently.

Given that the fallocate killpriv fixes went through the security fix
process (CVE + stable backport), should this follow the same path?
Happy to send the patch either way.

Thanks,
Vladimir

On Tue, Aug 11, 2026 at 12:21=E2=80=AFPM Christian Brauner <brauner@kernel.=
org>
wrote:

> On Mon, Aug 10, 2026 at 05:05:44AM +0100, Matthew Wilcox wrote:
> > On Sat, Aug 08, 2026 at 01:17:09PM +0100, Pedro Falcato wrote:
> > > I'm adding a bunch of fs people that might have opinions about this.
> Please
> > > see the rest of the thread below.
> > >
> > > On Sat, Aug 08, 2026 at 12:13:06PM +0300, vova tokarev wrote:
> > > > Pedro,
> > > >
> > > > Thanks for the review. Let me address both points.
> > > >
> > > > On the page fault comparison:
> > > >
> > > > UFFDIO_COPY is not comparable to a page fault. Page faults serve
> > > > existing page cache content (read-like). UFFDIO_COPY adds new,
> > >
> > > A page fault can also write to the page cache. On MAP_SHARED mappings=
.
> > >
> > > >
> > > > user-controlled content to the shmem page cache (write-like).
> > > >
> > > > The correct comparison is to write(), which calls file_modified()
> > > >
> > > > -> __remove_privs() to strip SUID/SGID.
> > > >
> > > >
> > > > This is exactly the reasoning used when fallocate() was fixed
> > > >
> > > > across XFS (commit fbe7e5200365), ext4, and f2fs to call
> > > >
> > > > file_modified(). The XFS commit message says:
> > > >
> > > > "as various fallocate modes can change the file contents [...]
> > > >
> > > > we should drop file privileges like suid just like we do for a
> > > >
> > > > regular write()"
> > >
> > > I can't speak for fallocate, or other system calls. As far as I'm
> aware,
> > > this is a best-effort kind of thing. As I said, writing to a MAP_SHAR=
ED
> > > mapping does not clear the setuid bit. It's a super trivial thing to
> do,
> > > too. But it's not a problem because setuid executables are not
> world-writable.
> >
> > I mean, you're right.  But maybe we should make a bit more of an effort=
?
> > I wouldn't like to see this used as part of a chain of exploits, and I
> > can just about see a path where a confused actor manages to create an
> > 04777 executable.
> >
> > All the tmpfs on my system are mounted nosuid, and many of them noexec
> too:
> >
> > willy@deadly:~$ mount |grep tmp |wc -l
> > 8
> > willy@deadly:~$ mount |grep tmp |grep nosuid |wc -l
> > 8
> > willy@deadly:~$ mount |grep tmp |grep noexec |wc -l
> > 4
> >
> > This certainly isn't a hair-on-fire situation, it's just a place we
> > could do slightly better.  Not so much BadBunny as
> MildlyMisbehavingMicrobe
>
> Let's not drag Bad Bunny's good name into kernel development. ;)
>

--000000000000fb459d0658c39a7b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Matthew, Christian, Pedro,<br><br>Lol - fair point, I&#39;=
ll keep the reggaeton references out of future<br>commit messages.<br><br>A=
greed on severity - but this is a<br>killpriv invariant violation, and the =
kernel has treated those as<br>security fixes worth backporting before.<br>=
<br>1. The fallocate killpriv fixes (XFS fbe7e5200365, ext4, f2fs) are<br>=
=C2=A0 =C2=A0exact precedent: same reasoning (&quot;can change the file con=
tents [...]<br>=C2=A0 =C2=A0should drop file privileges like suid just like=
 we do for a regular<br>=C2=A0 =C2=A0write()&quot;), same one-line fix, and=
 they went through the security fix<br>=C2=A0 =C2=A0process with CVE assign=
ment and stable backports.<br><br>2. CVE-2023-0386 (overlayfs SUID preserva=
tion) -- same bug class,<br>=C2=A0 =C2=A0CVSS 7.8, CISA KEV.<br><br>3. If p=
ermissions alone protected SUID, write() wouldn&#39;t strip it.<br>=C2=A0 =
=C2=A0killpriv exists for POSIX ACLs granting write to non-owners,<br>=C2=
=A0 =C2=A0group-writable SUID, container shared mounts, and chaining with<b=
r>=C2=A0 =C2=A0other write-access bugs.<br><br>4. This path is reachable un=
privileged even with<br>=C2=A0 =C2=A0vm.unprivileged_userfaultfd=3D0 (UFFD_=
USER_MODE_ONLY bypasses it).<br><br>5. Pedro&#39;s point that MAP_SHARED fa=
ults also skip killpriv isn&#39;t a<br>=C2=A0 =C2=A0counterargument -- it&#=
39;s another instance of the same class. We can<br>=C2=A0 =C2=A0fix them in=
dependently.<br><br>Given that the fallocate killpriv fixes went through th=
e security fix<br>process (CVE + stable backport), should this follow the s=
ame path?<br>Happy to send the patch either way.<br><br>Thanks,<br>Vladimir=
</div><br><div class=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr"=
 class=3D"gmail_attr">On Tue, Aug 11, 2026 at 12:21=E2=80=AFPM Christian Br=
auner &lt;<a href=3D"mailto:brauner@kernel.org">brauner@kernel.org</a>&gt; =
wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0=
px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">On Mon, A=
ug 10, 2026 at 05:05:44AM +0100, Matthew Wilcox wrote:<br>
&gt; On Sat, Aug 08, 2026 at 01:17:09PM +0100, Pedro Falcato wrote:<br>
&gt; &gt; I&#39;m adding a bunch of fs people that might have opinions abou=
t this. Please<br>
&gt; &gt; see the rest of the thread below.<br>
&gt; &gt; <br>
&gt; &gt; On Sat, Aug 08, 2026 at 12:13:06PM +0300, vova tokarev wrote:<br>
&gt; &gt; &gt; Pedro,<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; Thanks for the review. Let me address both points.<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; On the page fault comparison:<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; UFFDIO_COPY is not comparable to a page fault. Page faults s=
erve<br>
&gt; &gt; &gt; existing page cache content (read-like). UFFDIO_COPY adds ne=
w,<br>
&gt; &gt; <br>
&gt; &gt; A page fault can also write to the page cache. On MAP_SHARED mapp=
ings.<br>
&gt; &gt; <br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; user-controlled content to the shmem page cache (write-like)=
.<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; The correct comparison is to write(), which calls file_modif=
ied()<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; -&gt; __remove_privs() to strip SUID/SGID.<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; This is exactly the reasoning used when fallocate() was fixe=
d<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; across XFS (commit fbe7e5200365), ext4, and f2fs to call<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; file_modified(). The XFS commit message says:<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; &quot;as various fallocate modes can change the file content=
s [...]<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; we should drop file privileges like suid just like we do for=
 a<br>
&gt; &gt; &gt; <br>
&gt; &gt; &gt; regular write()&quot;<br>
&gt; &gt; <br>
&gt; &gt; I can&#39;t speak for fallocate, or other system calls. As far as=
 I&#39;m aware,<br>
&gt; &gt; this is a best-effort kind of thing. As I said, writing to a MAP_=
SHARED<br>
&gt; &gt; mapping does not clear the setuid bit. It&#39;s a super trivial t=
hing to do,<br>
&gt; &gt; too. But it&#39;s not a problem because setuid executables are no=
t world-writable.<br>
&gt; <br>
&gt; I mean, you&#39;re right.=C2=A0 But maybe we should make a bit more of=
 an effort?<br>
&gt; I wouldn&#39;t like to see this used as part of a chain of exploits, a=
nd I<br>
&gt; can just about see a path where a confused actor manages to create an<=
br>
&gt; 04777 executable.<br>
&gt; <br>
&gt; All the tmpfs on my system are mounted nosuid, and many of them noexec=
 too:<br>
&gt; <br>
&gt; willy@deadly:~$ mount |grep tmp |wc -l<br>
&gt; 8<br>
&gt; willy@deadly:~$ mount |grep tmp |grep nosuid |wc -l<br>
&gt; 8<br>
&gt; willy@deadly:~$ mount |grep tmp |grep noexec |wc -l<br>
&gt; 4<br>
&gt; <br>
&gt; This certainly isn&#39;t a hair-on-fire situation, it&#39;s just a pla=
ce we<br>
&gt; could do slightly better.=C2=A0 Not so much BadBunny as MildlyMisbehav=
ingMicrobe<br>
<br>
Let&#39;s not drag Bad Bunny&#39;s good name into kernel development. ;)<br=
>
</blockquote></div>

--000000000000fb459d0658c39a7b--

