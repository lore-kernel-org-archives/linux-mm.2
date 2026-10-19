Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B75E0CCF2E3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 12:13:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E228C6B01F5; Mon, 19 Oct 2026 08:13:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB2DD6B01F7; Mon, 19 Oct 2026 08:13:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4D086B01F8; Mon, 19 Oct 2026 08:13:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A23586B01F5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:13:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 337E140680
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:13:43 +0000 (UTC)
X-FDA: 85339266726.08.606A1EF
Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	by imf25.hostedemail.com (Postfix) with ESMTP id 26C67A000D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 12:13:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d2MCgtoo;
	spf=pass (imf25.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792412021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IaMHOaCF9qKahgBmNzjExLM3+cMiS8xPZoJLsbFvUPM=;
	b=E/YOcZ59lzxVnNABSqdIkXQc1XWOPCBUsJOyG0DE4nbhi1RZyiw+wZshR0xcyWOaNNQHlp
	O7lXnYBQ6eWAUmbkAe/A0KSitq/qnEVb9QgaeSKWXjUSz/+8aJ2hKMeIQ5XQcoj4IdtL2Q
	O8n61z+4elPv5llC+pm7reBwKSIqKs8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792412021;
	b=u5t8zgU5+NLojZiXN3s0tr2AlP1Lm8agCsk1Ukvrl7PMhhlDoCOIsMnht1Ldx96TagVKFM
	ARB7aeEPQmpC5L1AQpL+8vAufxoiN2G+/2YUS8P34xxonpkPSXifypPTit9HzN/8/h/Eyz
	dZ6TiM8BGfxmJ7bPc34CCyuw5cRu4Ck=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d2MCgtoo;
	spf=pass (imf25.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.177 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-8b0d5ddafbcso15304057b3.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:13:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792412020; cv=none;
        d=google.com; s=arc-20260327;
        b=faaKHTyAfT4wZlbETsyHDu/vMUK5ssVKMVZKlRFeTS9Buquiu4kgnLv21gH03Ei+M8
         6eKhhH9IBGGadMFISFQ2nuZb5C39CWCknSiumfIDyhNX6WBeaZTgQbp4DcS4a8nQpsuM
         tYLZosrulpiRm302uU308Cv58S0stGCmnylsTlt0N5hJM9/wrG0WjcNevRvdPQz6VWhd
         TZnB7vRwBZJb05fIR0HNMLcY0TKfklW9Ucvx/uJHi0100y2ndgXDpyZtrj4UEDDvnUiq
         jWJ00hPvw9k6DD5EXaQpebH+UEWvsW/ZAHtW7Yomel2/lGDSOj9VJf4uBoG4J8KBZXb9
         RzPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IaMHOaCF9qKahgBmNzjExLM3+cMiS8xPZoJLsbFvUPM=;
        fh=02TxcW6KCkkQJq1nAzSE4cPyBhAS0MT6sEwMstpvn5w=;
        b=hUWDfTCiuDmV8xR+CH5mh6hmllh2RJ/uK8dGYgr2Q/S1ByUWpQalJTy5UmMTEVI/yN
         Xg4ovtPuL3i0FNrVUlkY4jc2ibOlHYGaIpeWcOlWbITcUuJw6k9xW0y5Km59rk7uOUrM
         83sp/3i3hxxMvSYlptAaZIXcp07x9eichJVodiO4fXLai17NFLNxjfyvt8X1nqXR4/Dw
         Pqy/KInggAO4F83EuZgvvLKMMBQ/ffrYdwJDmZKpVk1BPknt1tj00zGC6a00HrYLwVtf
         0iHfkAAKtVyrhcobwYPYuO6RQtcxdAnn2NTN8fadElZq75Q8oTzZdTOQiVMutq4Dp/7r
         OjDQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792412020; x=1793016820; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IaMHOaCF9qKahgBmNzjExLM3+cMiS8xPZoJLsbFvUPM=;
        b=d2MCgtooy+Pr7Z7aimie9CuvAFtXakTsF/4S0v7HRFbROu/krAiRjv5CsTI6wzJFjC
         NcpoKbqgLdMCgiuJCNXLUEm8IDqIxRWQrstT16h4PEHGzUF7cvIAG0UPARkgWbJVVJJp
         3AiAkPXIYGEM+CU74H33sk00f+knSPbpyt6XpNj9zfxvkTj4ZquPVYG4qswWjbxezkGD
         sbJI2+iPW9ksYukqq5DRTYjY0JpRb1WzpA+lc+wEUEyvPxaWSQsixKW9jt3lAPM6odSY
         yKni/9IiYPf3jSuOQi+LTRErhslR4B1MGjKWY0yDLMCb5kAsFQbdVO4zJHQFkmKME4UH
         o33w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792412020; x=1793016820;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IaMHOaCF9qKahgBmNzjExLM3+cMiS8xPZoJLsbFvUPM=;
        b=a86C/x3k//3JNyDLJWJ2EWD9akgSPf6pwtSFfIiBPNGSLNCd1zCAPbBJHm8iTwpFfg
         V4Z7oG51V3NJ5LYvp6zX0tZWdA3BrTCL98VFUN/1Y1dCqoNShGB2HaaOWdmv6sNJhTWV
         OgIS62ocIkU1BwHMW85dABb+W4AStELII3CPh5cyoyIft8Sme/hHXrtdIK+NiCIna+tF
         mF3EDm8guG5eO2Yj3WdrbPZgUkDkp1cFleJ2Htib92T0bWEkuLW3NB+C5nHTt2jWohzi
         PS2+vKIZfCy9JToKw459/NVMOhqT49t935HuQcfVyVdtE5PneHjcfr1eRL4atqCzbu0N
         sseQ==
X-Forwarded-Encrypted: i=1; AKwUvBy2luOiWQCodE5ljeJkBOBC6b7+ly/sSPxQ4BOPD+jO5NPzR4/a1KMEhR6Rf1v1Dt0jw4JA/ubN+g==@kvack.org
X-Gm-Message-State: AFq9FYLUkteO2xjI17IBvK/xqMaKuvs9eYw/enop4+MntPlabqxi8gCw
	CrQzKqEop+TEURNHKSeci9QPB2vD6vSGfI4ddSHRvS/RnyacbILJwb21GwFZNC17djMwSOeHm6t
	T3sERuw9Cvf7ynEeM7JLqFTYi9DQYpwU=
X-Gm-Gg: AYBFou1WJRxdXiP7yTV74ZbGyoKgR5DgmFAZmsQyt0Gol7N9JNCUAiyKw4TQz2ZpRAj
	8j2Hr8H3srKCBZ5l7h7PwcwARspTv146wrCPGaNcLSk9LsrwIn63uUO/KPgW/oIAWThSQtGg+ZT
	Mb30m62oZ2RB9H5fx2rSyJBCEaqlFAjfjeWlaJ8k07vWgxwaeg8PLf4L5m5U4Ppf24JFLUImEqe
	9+lFGlRCRlpL797s+/jyucr7TJhUdrNL5J09aL5yZVp90pq5ZLaMXZRSk7Domnw+sEynIo3FRr1
	LwXvFtKeSoKfkfpl58GZeNLsKaJbkr9NBWkSziH1sV9ha7eS22rZdtMJURNR5O6MvHoBBm8bSC8
	Prik95s2/iXx9yw==
X-Received: by 2002:a05:690c:4802:b0:8b0:a857:654f with SMTP id
 00721157ae682-8b0f222e1f1mr24697237b3.63.1792412019904; Mon, 19 Oct 2026
 05:13:39 -0700 (PDT)
MIME-Version: 1.0
References: <6ac99eb9.6b935c14.1905ce.7c50SMTPIN_ADDED_MISSING@mx.google.com>
 <CAMw=ZnTTUxO2ZCobEDTQUY7OZxmyJUQxg4DkhC9gTWXaDaK1dQ@mail.gmail.com> <20261013110237.GA836401@chenghao-pc>
In-Reply-To: <20261013110237.GA836401@chenghao-pc>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Mon, 19 Oct 2026 13:13:28 +0100
X-Gm-Features: AclHuK_bmEUQOsQIU6VRKds3I_yd9xZsuOO4tGVmB2Rnh13ICGRCJP9TMe8I_xk
Message-ID: <CAMw=ZnTksVT1wuQwAjzz_2tYSCvLSxeUBa3mYQvCFuKUtcydaA@mail.gmail.com>
Subject: Re: Question about obtaining LUO session FD for non-systemd-managed service
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: jianghaoran@kylinos.cn, avagin@gmail.com, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 26C67A000D
X-Stat-Signature: xwqd7ekn1akegu8ndxznuq9gdd9fuba4
X-Rspamd-Server: rspam05
X-HE-Tag: 1792412020-475074
X-HE-Meta: U2FsdGVkX18AXpWWQVStnteO+e319oiwkoDzYuU0KDq00xFDPop/HVWKPsR1ophS3BInEzMa/Wayhr+VSUWVIXquW3oPPJLAKxOxp+rYeKy35g4BBgchA4WjoLoUTz5HGM1SiQvtslopHknCLFfUeMCF7/lb9ptHI8Bc38/kOUI6Xv3WNRpunwSjsj+2tB0RcTBrOPyzwI7MDrDOSyx/J4/wtbiXUcYbPzuQvJzKSnHGyvdq2Q4uLaKOoHHokLOhfR2sJaWzp3YC0dUsyhhUriKALeR9Uu/uiwxKGCMmtRSt9Q0p+uG4Gev4RkvnbN6+B9nQO2VKJ3xztlu4IFN7r3mVeylL+MBZtGhSVDG830kO2R523TlC3hTzMFTLaIketIuuBEqSCChapWZG93YuBQy9ys2cXfDm8CJtozp25yXUhZhyrHzO2ZZI1kXr745y6MXqPnjgNfHZOlenCFCCEgEqkAAdc6ypjPmwZksID1xOTQ/HJuH3tNr7sjwUj0RwnVQfU3v4/Ux87nv5eZ46GNGhl3kPdkJv4fc3qpU7JyRRuL9DV37QSBGTqAEP6ox88Sj0tb7w9Pj9zdIysEhfMjWfhkAxycexWeJETcmxK3gyHcdLhy6eQBgMPTIhovkcanxB3TINHSwAzr9DFjHRxPFRt9Knn2I8GXsJfH+LznUT64/lyfAjIYEJLysfXTvv1cp3E1UO6ASf4aSdwpPxn6kp/jSW9DUIU90cvA7kikuJcEZ93ZodeJADAqH1xw5CSNsy0hoGX1oDz1yQv4aeAGv4FPp5st2NeRe5SFjiFkGE4k/54DTlVrCnjKWJ+h9rtpTeAS33uqfrPjKa1DBxjlXji1lROI64xVXrfg8UAqf7vr8X7jD4qR7Vjss1xlpY3t7D5FzX73imAmLELSwjlgzHz6b+TnrM1wMfF77lBXhz/mZej+deepxcta5zIf0y5pfb+4InnTc3+qN1VvA
 23kfimzp
 GeSzeZfg1sLFydv+uJN7yr9u/Hxvv/0rqzFq8zGSCNtlTlfKS8WCfYHpOyPsmO6iwm6IWilmc6oa2AUgY0a0uPW7606S6E7WLYnCPpTJpDEUt/T6LzoXY8V0xhCuP7Xz1eiKzZ21agZYv6uJB++4Qk1GZmXgILSbnurI0AKoUndpfp7GxFDSEdoJSFgWCU1dS6XhWHW/WL0anM2KWp8SwaarK7GBC+p6R3IjT7xKI3lUkg7ATWPLacwvnJfpfX2aLHi16tZccMV8NKHinU82+InpOBaN5L6ZQuN+lzCbxob5C016S9FZbY2WgeAENYan+/YepYOKUSdEIsRoG/dInOYHnM/n6lr8WV6+gKSyT6n14d465/O1GKFJcax0Ma0aL9nHubRhmCTaLrJ4j4DKEMUaln9ysohExJbPhmQ3+Lvefqb6lFgAUEEFbWOwn+F8yzxXhi/gEafzN6NyhYYrv79zylWeRgXqu9X9FJNb1qWe/Pqvn7zjYOlYOxw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 13 Oct 2026 at 12:02, Chenghao Duan <duanchenghao@kylinos.cn> wrote=
:
>
> On Sat, Oct 10, 2026 at 03:05:40PM +0200, Luca Boccassi wrote:
> > On Sat, 10 Oct 2026 at 04:11, Chenghao Duan <duanchenghao@kylinos.cn> w=
rote:
> > >
> > > Hi Luca,
> > >
> > > I watched your excellent presentation from the LPC conference in Prag=
ue.
> > >
> > > I have a question I=E2=80=99d like to consult with you.
> > >
> > > I am currently working on the `memfd_luo` feature in CRIU. My goal is=
 to
> > > leverage the LUO capability to store checkpoint images inside memfds.
> > > After a kexec reboot, the image data will be retrieved directly from
> > > memory instead of from disk.
> > >
> > > Here is my pull request on the CRIU GitHub repository:
> > > https://github.com/checkpoint-restore/criu/pull/3152
> > >
> > > In the PR discussion, avagin suggested using systemd as the CRIU daem=
on
> > > to centrally manage LUO sessions and access to `/dev/liveupdate`. I h=
ave
> > > watched your talk and read parts of the systemd source code.
> > >
> > > From my understanding, systemd currently provides a unit=E2=80=91base=
d solution
> > > where child processes can inherit LUO session file descriptors. Howev=
er,
> > > this approach requires the target service to run as a child of a syst=
emd
> > > unit. As far as I know, CRIU does not run as a systemd=E2=80=91manage=
d service.
> > >
> > > So my question is: for services such as CRIU that are **not systemd=
=E2=80=91managed
> > > child services**, how can they obtain LUO=E2=80=91session=E2=80=91rel=
ated file descriptors
> > > managed by systemd?
> > >
> > > Thank you very much for reading this email. My knowledge of systemd i=
s still
> > > limited, so please feel free to correct me if I have misunderstood an=
ything.
> > >
> > > Thanks & best regards,
> > > Chenghao Duan <duanchenghao@kylinos.cn>
> >
> > Hi,
> >
> > At some point up in the stack, everything runs as a systemd unit, so
> > it's only a question of figuring out in your setup how to pass the
> > FD(s) up and down the stack.
>
> Hi Luca,
>
> Thanks for your reply.
>
> The `LUOSession=3D` configuration only takes effect for services managed
> by the system manager. If I run the CRIU command from an SSH login shell
> as I am doing now, the environment belongs to a transient unit under the
> user manager. In this case, we cannot use `LUOSession=3D` to obtain the
> LUO session fd via systemd. Does this mean the process needs to open
> `/dev/liveupdate` by itself to create the session fd?
>
> Below is the attached service of the process found via `systemctl status`=
.
>
> [root@localhost criu]# ps -ef |grep criu
> root       57589    7729  0 18:25 pts/2    00:00:00 ./criu/criu dump -D .=
./test -t 52922 -j --memfd-images -v4
> root       57784    7571  0 18:27 pts/0    00:00:00 grep --color=3Dauto c=
riu
> [root@localhost criu]# systemctl status 57589
> =E2=97=8F session-5.scope - Session 5 of User root
>      Loaded: loaded (/run/systemd/transient/session-5.scope; transient)
>   Transient: yes
>      Active: active (running) since Tue 2026-10-13 10:03:55 CST; 8h ago
>       Tasks: 4
>      Memory: 148.9M (peak: 1.3G)
>         CPU: 47.000s
>      CGroup: /user.slice/user-0.slice/session-5.scope
>              =E2=94=9C=E2=94=80 7712 "sshd: root [priv]"
>              =E2=94=9C=E2=94=80 7724 "sshd: root@pts/2"
>              =E2=94=9C=E2=94=80 7729 -bash
>              =E2=94=94=E2=94=8057589 ./criu/criu dump -D ../test -t 52922=
 -j --memfd-images -v4
>
> I'm not sure whether my understanding is correct. Could you please
> provide your feedback?

That's a user unit, and as per the documentation LUOSession=3D is only
supported for system units. So yes you have to provide your program
with privileged access to the character device and create the session
yourself, and then stash it in the FD Store as normal.

