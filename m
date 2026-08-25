Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D46C61DB9
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 21:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 794B86B0088; Tue, 25 Aug 2026 17:27:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76CE36B008A; Tue, 25 Aug 2026 17:27:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634726B008C; Tue, 25 Aug 2026 17:27:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 33CA26B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 17:27:26 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B0B4A1201B6
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:27:25 +0000 (UTC)
X-FDA: 85141078050.14.3CDDBA7
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA25840003
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:27:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H5k3A0Dr;
	spf=pass (imf17.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787693243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bE5lTVE/l+hmDFQxUEo/OmNLEGESlTEML0H1de8/2cY=;
	b=Y+ptsHdfg9uu/8Wv4yapxdrQNB7eQ7OyaHpe6Brl5P/7q7HFUm6U0yqwKO+VPMaEvToRsg
	GdG8z7tLnFXQEbwP+yp4ETF8Kvf4jq6esfdxgtGBbqiTRbejuU+dn+D86xNbwluO4oMY0M
	ZevzR+Cvgh5PMrgcndR0frigYFiz/Ak=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787693243;
	b=Fj80+NhD0O7gsr9vm8m5ovin2DYkZTnJFtHNdoBBrMbkza1DSu8Enm15HbcrqVox+aAxQV
	LN7FsER1aPNgQ3PqfQS1+tAYkH6Fv5Uyro+X25323jgfD1EwBtx7XssY7Kpw78n6riUFd9
	M8neivUmU/N4YgSwGig6acFCwXygJq4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H5k3A0Dr;
	spf=pass (imf17.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a0de062db5so415371a12.1
        for <linux-mm@kvack.org>; Tue, 25 Aug 2026 14:27:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787693242; cv=none;
        d=google.com; s=arc-20260327;
        b=QJ8QOyOC7NntIOSJ/Qpu9wlo9GKvJu0u5vsCojY4WuGhep9Auq5VqYdPvxyNvlh+xW
         jrWM0Ai0f/nbxylnPVFlui24RMK7/7qr4vYogCRXLJpxB5vSEVvRGRKKCHS1LbW66s9i
         UZOUzjJnxDpc7FkEsQOAefD6OoNjr9/LTBCRevmhbivOrThMPyK6lOIkZKKfSNregg6U
         phhojmDEeCOMSIZyfJnkFcBYz3AckDmgkGgqTc4WXiFlnqfx5YzTARzjy/0PyWGXo2wQ
         KKbIwj7CymbSNIMa39vjkTosKTeCrN9DwHnyo9QnzrRE6HH+Q0CWv/I3lUoKydRIpNEb
         Efaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bE5lTVE/l+hmDFQxUEo/OmNLEGESlTEML0H1de8/2cY=;
        fh=1x92Q+QSDO0Le1Loe2eImUooUyuTNMBHY7Lbri75kwk=;
        b=VyMq39PdoogiygyGSAehK8ADHYAVpXFGNBIGVknfYUlgziazDP5O8VpYEen75dMQI/
         CWf3XvK5woP6dgCVPx4aEF3rFxqt2HaJSUfv+8lLguyhgVm0sFyJ8S2GVXLME15nAZ/i
         EaPYLykmov8GOqLtf1/DoAtLuTF75eCrj9DTvgLlmK7oQFVyMCgVZTUPjsFcZYh5ZZET
         D98GOd6YsgFAApQZEK29yvySi+BW3oaY94l6Y7dBm6aYXcvMsRv2fdQj0/0jd7gnAXqB
         fL2tLmVtrCA7Ea6SMAh2wRZAmJym1LjEcK9T2kLRlYbIg2UZo3WvpTqBmA7Tq092ryPi
         Ww+w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787693242; x=1788298042; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bE5lTVE/l+hmDFQxUEo/OmNLEGESlTEML0H1de8/2cY=;
        b=H5k3A0DrNUya3rZYum1ywNuMj5/q+wZsDyEryHYsLunzlaTeeSrIHhJ3lku/cIolqX
         p2KdOCZe/TUR5ir3yfZpHEUdIcY6cQtHQfnfUTr7itGpIT7zdu7eWg2bZzzurY8KKjlO
         40RKId7/9GjZvDv4yWt4U5ShosUYePFVb3EPsaFApA9XVpxcUOeNw1dhx7ldNKgDaGC6
         WG4pNpV7vaIpvH9Pojn9LbQO47Tc9jBnwZkfeBUGY14hFtn/0hu01KWoQ/lz5gLx09K7
         c6+8vqBFNo2zKWEVfsyJnbkf0svgzASk+o+gQGbJq72GKsg9NRTTNBBUEe6pRrOU9eB+
         ZFUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787693242; x=1788298042;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bE5lTVE/l+hmDFQxUEo/OmNLEGESlTEML0H1de8/2cY=;
        b=QRylK7tRibptEvOA776ZcIBrdPSpm0At4mNhnH6jLe/efPoqfeAs1DzcCc53sxkltV
         CqajdWc5f5k7gkAURNDPzXlGXATTZks6ukG/3MkhDFA0zbcu/2bsfQNiQyCwkqX2rdYK
         eek6Xy6qQgMwLxdppHCzTQk0p+fyenhca5euLVincmtlHyiMku0tMEugOg6Hkpgviwiy
         Jkq+17fhWPJdvqit6Tp+jrhD+KFZpbmI6pYtjuNPqZsRHGHGqSalG6brlTYUW036WEMu
         ClBmfxdYDbVtiA+GMraFEkrowgkwb4iMYr3poylx26rFZbD2zhYLMVfhX7t3zi0npBvf
         3weg==
X-Forwarded-Encrypted: i=1; AHgh+Rr+FVAnmmdRWhfrBy/WZ7aveQB4f6WxJXJqkt+03UbuqyokH0rQjR4kqXR8NXghuUOBrwqWAv8rtA==@kvack.org
X-Gm-Message-State: AFuF++nCpAshKJFLlpR9aB9jmwbmfFFFNJk39GoRRvMIgMF6jxO6sOzd
	30iOXCKgEKXfdLc2QGhVLBUEVB7CZWPwdTxB82mk2Nxedx8iYyPINHCmxSP6Hku8TtcAA1ukvp3
	lzGyIVNzGh1fvb647an6E/T0eb9iGCzY=
X-Gm-Gg: AR+sD103UltDZNLxOWZsDRH1gF9qIpQvvT5sd4FetzZa3KoSwKZbZcD7OoaqoJ2aqy3
	RicPMrLap0ZZu2fC6kscljN4Y8EQTwjVBpmwZOpkxK11OeeWRg8F+0EjKOJFYMeI6WPEc2/b4/o
	OVirimazuIMU9hb1/4oi9Xm48FOEQuwqCzZi7fJCWnLYgRAsh9CzektyONGmv75oz3UBCW3NPyu
	tMh0Sp7RYVp3CMXyruCe0Yng1xgfPeoK51TDqgtWTTU7M0W9evUq+aIPzIBQGeOxGN5PSRPMk2q
	N4P+82WRMxKtGj1P9FdknE8teWTJ30EEHRd7ta3UOUvAcxJ7puJ+BtTy/IUOoG+tEDITUJ/UW3n
	01TWCICu8nlY=
X-Received: by 2002:a05:6402:21cc:b0:6a5:d58a:9640 with SMTP id
 4fb4d7f45d1cf-6a5df61b209mr2046699a12.9.1787693242034; Tue, 25 Aug 2026
 14:27:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1784204592.git.me@linux.beauty> <anJE8SfBLtkh6QSa@zenbox> <1a01795b07a.1f456216580426.3401229391386650127@linux.beauty>
In-Reply-To: <1a01795b07a.1f456216580426.3401229391386650127@linux.beauty>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 25 Aug 2026 23:27:09 +0200
X-Gm-Features: AcwNN1VIk99DyxEcpdaJ9t08bm4LFPXj5Yk5ztu7oKocV4saiMTQcrI1RCnhRcA
Message-ID: <CAGudoHGoOr8rvhSQK+HQp7LmNyE9vP=xTok9eA1ZbV7uaVnMEg@mail.gmail.com>
Subject: Re: [RFC PATCH 00/24] pidfd: add a minimal process spawn builder
To: Li Chen <me@linux.beauty>
Cc: Justin Suess <utilityemal77@gmail.com>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <kees@kernel.org>, Gabriel Krisman Bertazi <krisman@kernel.org>, 
	Josh Triplett <josh@joshtriplett.org>, Andy Lutomirski <luto@kernel.org>, 
	John Ericson <mail@johnericson.me>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Oleg Nesterov <oleg@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	Eric Paris <eparis@redhat.com>, =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	=?UTF-8?Q?G=C3=BCnther_Noack?= <gnoack@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-api <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>, 
	linux-kselftest <linux-kselftest@vger.kernel.org>, linux-doc <linux-doc@vger.kernel.org>, 
	audit <audit@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	linux-arch <linux-arch@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BA25840003
X-Stat-Signature: wouykbb6ganyt6u7e79jzgwu5xfah13b
X-HE-Tag: 1787693243-213246
X-HE-Meta: U2FsdGVkX1+XEb8g5bWjqMbQpjn1Gsp7unaNKEjPbTZQ2EssdfxIJJgHV/sbyYasd4MZL8DOCFuzDsOpu4Q4wE7ZTafCdvDpemRMSdOhH6X+pOvYYmf3MmwFJyWMRv5pZdUZmDvMXiPrAn2/xIEP2Vp6Na6lmxLTAguZpcMxzdGh1KuABeAXDoj8ieOSeoBgopuMHe2eQd9lr1gjPHbk9PJJvI+RNQJmefkIDCgRCLXnBSGVfiuLahPYjwTjSAR+wx5IqgvnBSsauI2lPE1lALGyPcBXXmr2llJxcB1UpTdVgXJNHxoPHfhWMmkX+NyJIrq5WKeDZkTFSoDcZ4iH9D+mK3It95JMSBWcq7WdFZpzSXl7zDFOYJQJf3zDidDObvvQpOaQyyuEo16KrUsIz/itdfFvusRR341o1V1SuPAKVddfVRHnrQMFv75UKIxNJ+mqyEtiNDWaQ/SjzLl0tvbWBvan5eSX5QWyoP7lxBXeWQxL1dSuniPIwk+43pnyFY/RlOxjmuFRcNUaa7Hhs+un51lqG/B9caeMUsIoSqJ6FpX6KRiCFOCsrD7sRzOdgvU+x0rE6noOzvCXLOt4u03wV1ZAvdMOX6Qiry0TVMkR+GxFfUq1lyuCexGwBElst6ScWiMOHrWn/YBcTFViwPHqRaXnxacEkYvhOZdgjCMguhT6itbyogxsN9JiqSMXmCCXekBHPRc6pKlNSVQqEpY2phH+h0KVEZS52XZFRQ5y6dYtnuHnjcGUhrDeNSbr19jshdrUrNDLyad3gNSqV8YY0kHbjyFtam4Q9Ir5AwUyiY47Mk0lr+X1e+Qt4y+ZFoM7Djs12pmIAjyLdeJt/mtWoSDW6R4f55X+lveTiW1EeNjEgQsqZq2LLyEfmaLoDGLaGUGuv3CmtgHCeCiiBijXlFvPqS45KE78HpgUTYbuUM/NCqSUL0NiTVu1Natr8rNYQMIpglgKM/Nsm7I
 E0RCCIEI
 sLLLhooTVUbvtOvVNvonZq69DRa0gCrLkiK9AxgWRdZ0SEgnCDGcz7x+kgXgJgFNx0iORwiH1eSmWVGWAONmuQqq4zHDQXZLC7S9u6uQhFM08gKZ3KUO9L6v+GFI4v80lRB5xRzAnIvzA1u4JQtgrICTnj9BKLhNMXNMK6q+7uQj7ybxAYCoj61U0MrdEOwQ3duSDO1+GckXLXrlLUBiDSY/CY4Uah5QQdOEEauo7W/cTrKmWvLSFRKo1ZzKm1fos/iDSIas0b0uMC8AtUjuQE2X3m6ckIKv7PbJw+IPaUC2ACNFDodta/f7ETFdkHMv7hbVTf+3qAXSxVEnMKWBFubcqjlukDHkjHkM1FCza3Xn4rfCb22ZNSKKkTZzYGxjWQAWTH1EicLUZFMixa0PuPXmaoCStJ6Ew7mka
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Whoa, this is older than I thought.

First and a foremost apologies for radio silence, I got really busy
with other stuff.

I did not have the time yet to go through the patchset, but I have
some time to respond to this bit.

On Wed, Aug 19, 2026 at 3:15=E2=80=AFAM Li Chen <me@linux.beauty> wrote:
>
> Hi Justin,
>
>  ---- On Wed, 05 Aug 2026 04:25:25 +0800  Justin Suess <utilityemal77@gma=
il.com> wrote ---
>  > On Thu, Jul 16, 2026 at 10:31:26PM +0800, Li Chen wrote:
>  > > Hi,
>  > >
>  > > This RFC follows feedback on my earlier spawn_template RFC [1]. That
>  > > proposal made caching the primary interface; this one starts with ge=
neral
>  > > process construction. Christian suggested a pidfd/pidfs exec builder
>  > > modeled after fsconfig(), with enough semantics for userspace to imp=
lement
>  > > posix_spawn() [2], and Kees agreed [3].
>  > >
>  > > This RFC is based on linux-next next-20260710 and depends on two pid=
fs
>  > > fixes that I sent separately:
>  > >
>  > >   * pidfs: preserve thread pidfds reopened by file handle
>  > >     https://lore.kernel.org/all/20260716052726.1032092-1-me@linux.be=
auty/
>  > >   * pidfs: handle FS_IOC32_GETVERSION in compat ioctl
>  > >     https://lore.kernel.org/all/20260716052822.1034228-1-me@linux.be=
auty/
>  > >
>  > > The initial implementation is source-based. The executable path can =
be
>  > > provided with the final run request:
>  > >
>  > >     struct pidfd_spawn_run_args run =3D {
>  > >         .path =3D (unsigned long)"/usr/bin/rg",
>  > This should probably be an FD for the path.
>  >
>  > This way it prevents race conditions over multiple configuration steps=
.
>
> Thanks, that makes sense. Using an fd avoids the pathname race and pins
> the executable we actually want to run.
>

I don't understand what race is supposed to be addressed either as
none of the setup depends on the content binary.

Regardless I don't think this is going to fly as it directly shafts
NUMA setups. What's needed is a path to the binary + the PATH
envifornment variable or a collection of paths to try out.

Here is how it harms NUMA: In the most extreme case suppose there is a
container bound to a specific node and you want to exec something into
it. Further suppose none of the relevant data is in RAM yet. And
finally the process doing all the work is running a different node.

Say you are going to spawn ${container}/usr/bin/coolprog.

At minimum this will allocate a dentry and an inode for usr, bin and
coolprog itself.

Afterwards any path lookup going through usr in that that container
will have to fetch memory from a non-local node to traverse it, same
thing for the bin subdirectory.

This is a self-induced problem when using a fd.

In the real world userspace notoriously performs failed execs as it
makes its way through dirs in provided in PATH, and while you can
patch select programs all you want, the mechanism will have to account
for it.

This is where the next NUMA issue lies its ugly head. Suppose you have
a box with multiple nodes, but don't use anything to maintain affinity
(as in, processes run where the scheduler sees fit).

A well-known exec-heavy workload where this is fine is compilation.
Any big project will do, to give you one trivial example, make -j
$BIGNUM modules in the Linux kernel directory.

Say you have a box with 4 domains and 32 threads per each. make -j 128
will end up spilling on the entirety of the machine and there will be
some loss of locality when spawning gcc and whatnot. Even then, a
sensibly behaving scheduler will not migrate processes between nodes
without needing to do it. Meaning after the process gets to run, you
can assume it stays on the given node. The stock kernel with the fork
+ exec machinery is doing a shitty job here, but the new mechanism can
assure process-specific allocation to come form the target node as
long as the scheduler does not mess up.

To that end, the final form of the machinery needs to be in position
to do the following:

1. copy in whatever data it needs from userspace
2. if no affinity is specified, ask the scheduler: assuming something
forks now, where is it going to run? the answer would be speculative
ofc
3. to the minimum allocations needed (task_struct etc.) while passing
the node number from above
4. have the newly spawned task handle everything else

This in particular means that a failed exec would be very expensive,
as it would go through task creation and teardown. Meaning the child
needs to be able to figure out where to binary to execute is. And
user-visible part has to account for it from the get-go.

I'm going to write more after I go through the patchset, should be next wee=
k.

>  > >         .argv =3D (unsigned long)argv,
>  > >         .envp =3D (unsigned long)envp,
>  > >     };
>  > >
>  > >     fd =3D pidfd_open(0, PIDFD_EMPTY);
>  > >     pidfd_spawn_run(fd, &run, sizeof(run));
>  > >
>  > > Alternatively, the path can be staged before the final run step:
>  > >
>  > >     struct pidfd_spawn_run_args run =3D {
>  > >         .argv =3D (unsigned long)argv,
>  > >         .envp =3D (unsigned long)envp,
>  > >     };
>  > >
>  > >     fd =3D pidfd_open(0, PIDFD_EMPTY);
>  > >     pidfd_config(fd, PIDFD_CONFIG_SET_STRING,
>  > >                  PIDFD_CONFIG_KEY_PATH, "/usr/bin/rg", 0);
>  > Same here. Should probably be an FD to the binary instead.
>  >
>  > >     pidfd_spawn_run(fd, &run, sizeof(run));
>  > I'm worried this pidfd_spawn_run just adds another varient to the exis=
ting
>  > myriad of exec* syscalls we already have. Would it be better to just h=
ave this
>  > work through execveat(fd, "", argv, envp, AT_EMPTY_PATH) instead?
>  >
>  > (i.e have execveat take a pidfd directly).
>  >
>  > Then you can get rid of pidfd_spawn_run which looks almost structurall=
y
>  > identical to execveat (with the argv and envp collapsed).
>
> Thanks, but I'm less sure about using execveat() as the run operation, si=
nce it
> normally replaces the caller while the builder creates a new child and
> returns. A separate run operation still seems clearer to me.
>
> Regards,
> Li
>
>

