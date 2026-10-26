Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4168606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=snSXCmLg
Received: by kanga.kvack.org (Postfix)
	id 145266B05CA; Mon, 26 Oct 2026 19:22:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11BB26B05CB; Mon, 26 Oct 2026 19:22:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00A0C6B05CC; Mon, 26 Oct 2026 19:22:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB20B6B05CA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:22:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BDDB1408A6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:22:27 +0000 (UTC)
X-FDA: 85366353534.20.4DCB8EC
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5D2F74000B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:22:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=snSXCmLg;
	spf=pass (imf01.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sClihItsgegsMKKiMW0EDJ5IHIVhrTOtuDwhYJOOpz4=;
	b=HdhLAldAirhL/93JgoXnMBUSA7Z1OocBmsFeXaAvBRtSth2qIry8QmyzQnfp2BFCa+XMGh
	cBUuVDXvrRITp6n8jQGPj9l9y4yBVU4FUXeTnMlEojI5PhtxpPKb/OqZ1J1FwDG7dQILSu
	U+1Vxzlv8MkLjQw+Pqrz6vfK0qSgfjA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793056945;
	b=v4Ir/5T1V4bq6waOThPHHBEQcAQNTdy54os/h35PMeHrRpAxZt4OUlomb+8oYaYtcNAyRd
	E0nz6QL2d8ASShCq52wVX4k+NykC5iN4ZRXqvbKgBTG4bbDCD7ey0fQwb99e297FMIjgDR
	7dr87h+wpL8qBxeFRE0SbDS5ZJbLfjI=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=snSXCmLg;
	spf=pass (imf01.hostedemail.com: domain of luca.boccassi@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=luca.boccassi@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-8ab3d3c5761so31248137b3.1
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 16:22:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793056944; cv=none;
        d=google.com; s=arc-20260327;
        b=C3iNx8pNGMB/2Tdzo4R+GxPr1buambix3UBNd2KfJIJgYdqdW2QLuwQmai/Zaal88j
         N2GEXWGwAHhm0HhsP/mmft0zHIRHXJ4rht5MLI7+tjbc1n44BuHNlOoDeQ8x0dEMB5+h
         Lus/ZGOLZBQMd2MIQ/X/0RLRcE4gKuNUGzB37s6LCx0OZ+9+OzSB+4WRexA9lJ7tLdku
         GOQ2kVqHImGN/tEVKty1xw086+tsvf0tZyDCUKKLQE7tZLvzFCKJ8nPsqA0XQh6/lgem
         Z9+COipU6+mOWNJEvpx0YNxNmxauPxuOnev+DVOkv20uhzAuoMAYJNI/hY2SLYQFIwBy
         0JiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sClihItsgegsMKKiMW0EDJ5IHIVhrTOtuDwhYJOOpz4=;
        fh=D5DCYdUju1roqZa2zyTYRrr+c8/XQnFhoXCqqyVVGjs=;
        b=omn1efAWcj5btuMksAU1xnLT0vnzh9PceabNYoC6z7NuPOSCtfD5EFh6R8M6k7tj5m
         CFVW3YR17mjSAl5R3W+dhV2iN5uPw2p2dTXfx/wGT8EEx1tgzUHdY2AqTBVhMnRGLzPD
         9veFw/cGau1Kjb9+j1SWUB0kLGnSUnyf4JGbHFAXzuRE02nYriiK+eMVt/IRsp86KaCg
         rDrc+oyk2Yb/zQrAPE840wO67A8XTRS34Mg+YCIVNr7mExwDaRJ44yTW2ITKQGfD4FoH
         peS5N6iYpgFHawagUJ18OdJkjw8QkXTPW63hZOfpy6Qsxi7WmEg9oGEfJcs+qafNW425
         h6XA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793056944; x=1793661744; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sClihItsgegsMKKiMW0EDJ5IHIVhrTOtuDwhYJOOpz4=;
        b=snSXCmLgr2cjl1qOEB2snqMedH7LluR0MTtJX+ihz6bLRjerAmPXhqMtgXMIreDrHm
         qD3G8L7pvRCDPRfvrAi4OF1ZsxCRAc4umKDnZY2Nbfel/nauwhU55ND+U1Viauo1JgI4
         Q+ICHd5WHoyjbihWIe1h5RP+8TFobUB+vMU4mplLgOsm7rFBBrrrR1ragity8FUS28gZ
         g28sJTb6eUHrXPY5/HNAtzMsxDc04+ok3i3IFn2g38dB84OSDlKVjSdbjj3Fsu3ZmWRk
         nmxqaFHoo/xDXBSKoxTNt/n3b5+cxSWcljMtC3GjBtF7aaGyN/hUbMSjp/yRD+rMz1y2
         Tqcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793056944; x=1793661744;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sClihItsgegsMKKiMW0EDJ5IHIVhrTOtuDwhYJOOpz4=;
        b=tbUeyrxuAHPxHsqiixKAdOjlc51BWP/k/UEEa8G80JMOwoccBL+95DMZNb5k85VvwN
         0zB+HTln6WjHhG203XsKaWP6bTfjea4g6V3t0bG8v0AYmsas+m6Ndb3gL190ilxUV34j
         6WT8u4n9tSSUksVeWP8QBr0X0y1Z2WvzijdedLVg4jeP/YoskEppFk4uzsxHPQbJ09j+
         zSM+y6dYMy5wW6lgq06nf6kGHIwa+ybH75tm5CbUSZexXw9q58TprBTWQTrRLmAImORb
         vCu0IiO7rIeAnkpxYrfy2/orq9V0h2AqE9hCWO5rxKqDLb6wUyQ1i9/4RyS+CMrapbbY
         bN7w==
X-Forwarded-Encrypted: i=1; AKwUvBxLWvHXXO5DEGN4UOhtj+ZkzD6VwF2J77ldZGSo+rVNLZpaFw44jbPtn5gyIcwxSreqiSP1JxHMSw==@kvack.org
X-Gm-Message-State: AFq9FYJa2NdXCT2FrnoWq6EzcYqLs4mgGWiXb8gCvoETsuhc4Szsw/Zn
	sAxniWdIDmtmVhVvmYDiwwLiuBAlrdlvSJ3vOG6jUf8OtBpDbD+/cKEuvnueFg9y8Urms2lMuDz
	FPBZAwdY7gdMY5TjT13go6ek7TikidRY=
X-Gm-Gg: AYBFou2MaoN0+0nRpnZBQBV2KaQtmZhYZPgnNOWG308zvxG7RGaygIkqY0MGh3DpriB
	4NOOVMZSEOGIL4OXZQI0rb0zWsyOWunUgza06URBuWN78Nvo5uwEIl2bL3JDOpixGctQhSPJPnO
	bPqSB1wIR5hmnJvh6qj/Fpw0svGx1fBPzcGUQM1GlEXgP4e4DM+L3rbWCEWiUwTkn6Ov8SzLwnO
	gIJVN9Fcikv2bJyOy89tFP1RV6N0Y+PEkaGYAjoSaxbMIrJXNcTTOc6u/75CUyrZFFryT55Nuc+
	TE8GJzbUvtQft+X+Z72SktMXppA42DkEtHFULEIb2Q2+/bRvEl/w9uYCiFaw87TvVlOj68s+VBF
	ZSFzio5SaLdDB+lFAkzVS5EG+Lv+VBJo9t+v+zbHM2wO+vI8hPw9tWQRdUT6fGJ4F4EPKSkWE
X-Received: by 2002:a05:690c:6603:b0:8a9:8021:5cd1 with SMTP id
 00721157ae682-8b1669e6465mr70712677b3.6.1793056944432; Mon, 26 Oct 2026
 16:22:24 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <6ac99eb9.6b935c14.1905ce.7c50SMTPIN_ADDED_MISSING@mx.google.com>
 <CAMw=ZnTTUxO2ZCobEDTQUY7OZxmyJUQxg4DkhC9gTWXaDaK1dQ@mail.gmail.com>
 <20261013110237.GA836401@chenghao-pc> <CAMw=ZnTksVT1wuQwAjzz_2tYSCvLSxeUBa3mYQvCFuKUtcydaA@mail.gmail.com>
 <20261021103633.GA1324331@chenghao-pc>
In-Reply-To: <20261021103633.GA1324331@chenghao-pc>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Mon, 26 Oct 2026 23:22:13 +0000
X-Gm-Features: AclHuK-hwbYwy5ob9GAZTuHyNgSeoVljDHkkHHLA6n-8vBOmCS8V_bd2quxR25o
Message-ID: <CAMw=ZnRpDdqKDPbofeF=1U70Q0Ms0aniwA6OPF-paNZEb+k5bQ@mail.gmail.com>
Subject: Re: Question about obtaining LUO session FD for non-systemd-managed service
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: jianghaoran@kylinos.cn, avagin@gmail.com, linux-mm@kvack.org, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	systemd-devel@lists.freedesktop.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5D2F74000B
X-Stat-Signature: h4w3somjozj7x18oztu35drykj67qhnb
X-Rspam-User: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793056945-299346
X-HE-Meta: U2FsdGVkX19GSQfQnuaodUGueNqV1/bnMf4PaW8LWOSsZsBU3Cft5HOAHFG89CY4u8Rxk61H26w8GbqMvGp39YDpDS0eq+gaS51HnEYdlGsoNRBlKid0ngt30C6PMqX2Kzos8D3oP4S4iBs6wFt2zdkaFYM4m3UGrenFkYydWKVqUmHTUaNQY7tJHmvxWZQC7QK3j9i1qD7jgmb772SqmGldiSA60LS6yYki0pemNJGKmvp/G7gtF2pUmUUr4vvZ7WlKoDh8hHK1liu+A3pFgR1JvYBNqoxrDduOT4Qa+pXOFxG6vdU3FfQwNFfLC6JT3/1Eztg06P6rTxDM128keiFw8n3KL/uNxtcyN0/W6piNfTg6AsFhSjBismc5qH0xDkkUa5VeAbaRWn1w5T7PESOH6koPeQGmUwN/7F/m82EES/h8ewBYh7odRkgGHscM5x5zJfVkqQUmYwNCaHTr+VsUU7+S08DIP6vPz4hceD4lrmiz2WF8GTgDU+2sViGlj9e2SpvBcVGHfwaL6tn6spzLtSHg1nqx89IUcXqF5EEVkK7bUHWHc1Snystwyjn6vKzH2xoEUCCfW0pxeJ3SCXKXNReB6qZ/AvSxVU7edw/vy7tbM79nFOstlNppjEmDccs8ReRFF9GEk89CHk3o2HIDHi/ISyBvDuI9v8dcRYhJ3ODMfeRZOim71aAnVxXy0fD66XJx3I7HemnqcX9f+RjnQCT8CTeZX5qM+4bgyY5fLCsQyXueTxvd2L6kZADvAHFjTtYhvGgssoPCY7CX1hH6cIo0mTTSIOJeNi9aHWp/d95FAXjOo6zP9HQ40zc2SE2HPWAWVyMLXUkBce2ixqFDjsYLkRF48uZxYuv3ETt9idtAMll2kz8G95iX/mq6t04/e0IJw6hvHTFUB7gjZbUYbJRmEcA4rafjNHiWgYvRApBPOWo8eszlRH20Kn41+FnsewNFRAdTD7thT+i
 52YkDB0s
 sxECUF7AjlB9KsQjuAeZyDIF1ScuCcno024uKBXqP1FFkTyjCrshl9s2E0XDww1hybYBTRanHIk2nlmQbaye1kMhgFW6HaJ8LU9HIzAQQDbPabG4gQH9C9rS5r54zWZ/FIiI5dseXp7/zidB/Y4yEyANkzI/6wJvRNUlrR+BEfUY9vYCyTMsUp/qEEAk7ycxo+8/HWnJV5Pn5QdEVFq8oF8aipdN6vvo19XRtwTyD33CSprh6mUYjiTnDG/Tczwh/ESF7QQ+vcjMBEMShGE4NzBRIaB1AU8YkB6BkTHCJ6AimnVdO2cI27Ve33IIjI3wFwz9rR1FJ41fBnZ+c2s6oH0uI/4OeO0vLJ9IWAPsEV8iIoyfti29ch8gi69mBxbi/R8pVOlWMVMJQvSwHFCNYEmQUcrsS2M08ls+dwfmA+u/SInUqz2O89cSs99Wjra43WaYcoQxWi2WMrq4AowYbG96cORy53ovJe/IW8ou6yGBDoBuPO7pJK+SjWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 at 11:36, Chenghao Duan <duanchenghao@kylinos.cn> wrote=
:
>
> On Mon, Oct 19, 2026 at 01:13:28PM +0100, Luca Boccassi wrote:
> > On Tue, 13 Oct 2026 at 12:02, Chenghao Duan <duanchenghao@kylinos.cn> w=
rote:
> > >
> > > On Sat, Oct 10, 2026 at 03:05:40PM +0200, Luca Boccassi wrote:
> > > > On Sat, 10 Oct 2026 at 04:11, Chenghao Duan <duanchenghao@kylinos.c=
n> wrote:
> > > > >
> > > > > Hi Luca,
> > > > >
> > > > > I watched your excellent presentation from the LPC conference in =
Prague.
> > > > >
> > > > > I have a question I=E2=80=99d like to consult with you.
> > > > >
> > > > > I am currently working on the `memfd_luo` feature in CRIU. My goa=
l is to
> > > > > leverage the LUO capability to store checkpoint images inside mem=
fds.
> > > > > After a kexec reboot, the image data will be retrieved directly f=
rom
> > > > > memory instead of from disk.
> > > > >
> > > > > Here is my pull request on the CRIU GitHub repository:
> > > > > https://github.com/checkpoint-restore/criu/pull/3152
> > > > >
> > > > > In the PR discussion, avagin suggested using systemd as the CRIU =
daemon
> > > > > to centrally manage LUO sessions and access to `/dev/liveupdate`.=
 I have
> > > > > watched your talk and read parts of the systemd source code.
> > > > >
> > > > > From my understanding, systemd currently provides a unit=E2=80=91=
based solution
> > > > > where child processes can inherit LUO session file descriptors. H=
owever,
> > > > > this approach requires the target service to run as a child of a =
systemd
> > > > > unit. As far as I know, CRIU does not run as a systemd=E2=80=91ma=
naged service.
> > > > >
> > > > > So my question is: for services such as CRIU that are **not syste=
md=E2=80=91managed
> > > > > child services**, how can they obtain LUO=E2=80=91session=E2=80=
=91related file descriptors
> > > > > managed by systemd?
> > > > >
> > > > > Thank you very much for reading this email. My knowledge of syste=
md is still
> > > > > limited, so please feel free to correct me if I have misunderstoo=
d anything.
> > > > >
> > > > > Thanks & best regards,
> > > > > Chenghao Duan <duanchenghao@kylinos.cn>
> > > >
> > > > Hi,
> > > >
> > > > At some point up in the stack, everything runs as a systemd unit, s=
o
> > > > it's only a question of figuring out in your setup how to pass the
> > > > FD(s) up and down the stack.
> > >
> > > Hi Luca,
> > >
> > > Thanks for your reply.
> > >
> > > The `LUOSession=3D` configuration only takes effect for services mana=
ged
> > > by the system manager. If I run the CRIU command from an SSH login sh=
ell
> > > as I am doing now, the environment belongs to a transient unit under =
the
> > > user manager. In this case, we cannot use `LUOSession=3D` to obtain t=
he
> > > LUO session fd via systemd. Does this mean the process needs to open
> > > `/dev/liveupdate` by itself to create the session fd?
> > >
> > > Below is the attached service of the process found via `systemctl sta=
tus`.
> > >
> > > [root@localhost criu]# ps -ef |grep criu
> > > root       57589    7729  0 18:25 pts/2    00:00:00 ./criu/criu dump =
-D ../test -t 52922 -j --memfd-images -v4
> > > root       57784    7571  0 18:27 pts/0    00:00:00 grep --color=3Dau=
to criu
> > > [root@localhost criu]# systemctl status 57589
> > > =E2=97=8F session-5.scope - Session 5 of User root
> > >      Loaded: loaded (/run/systemd/transient/session-5.scope; transien=
t)
> > >   Transient: yes
> > >      Active: active (running) since Tue 2026-10-13 10:03:55 CST; 8h a=
go
> > >       Tasks: 4
> > >      Memory: 148.9M (peak: 1.3G)
> > >         CPU: 47.000s
> > >      CGroup: /user.slice/user-0.slice/session-5.scope
> > >              =E2=94=9C=E2=94=80 7712 "sshd: root [priv]"
> > >              =E2=94=9C=E2=94=80 7724 "sshd: root@pts/2"
> > >              =E2=94=9C=E2=94=80 7729 -bash
> > >              =E2=94=94=E2=94=8057589 ./criu/criu dump -D ../test -t 5=
2922 -j --memfd-images -v4
> > >
> > > I'm not sure whether my understanding is correct. Could you please
> > > provide your feedback?
> >
> > That's a user unit, and as per the documentation LUOSession=3D is only
> > supported for system units. So yes you have to provide your program
> > with privileged access to the character device and create the session
> > yourself, and then stash it in the FD Store as normal.
> Hi Luca,
>
> Thanks for your clarification.
> I now have a rough idea for the implementation: CRIU will leverage the
> FD Store facility to deposit the memfd into systemd=E2=80=99s file descri=
ptor
> store. As FD Store is tied to a service unit, a criu.service is
> required. The unit file I intend to use is shown below:
>
> [Service]
> Type=3Doneshot
> RemainAfterExit=3Dyes
> FileDescriptorStoreMax=3D10
> FileDescriptorStorePreserve=3Dyes
> ExecStart=3Dcriu command
>
> Does this setup conform to the original design intent of systemd FD
> Store and LUO? Please feel free to point out any mistakes.

That looks about right. If it's a user unit, also remember to enable
fd store preservation on the user session via a drop-in, ie the
user@.service system unit

