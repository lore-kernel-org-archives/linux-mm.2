Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44279C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306396B00B8; Tue, 30 Jun 2026 12:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B7556B00BC; Tue, 30 Jun 2026 12:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 15A066B00EC; Tue, 30 Jun 2026 12:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D20D56B00B8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:59:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3EBC91A04BE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:59:14 +0000 (UTC)
X-FDA: 84937189428.27.B7BC90E
Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5F4C32000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:59:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uqtnrfbi;
	spf=pass (imf31.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782838752;
	b=NFLqpdZTG47LbPCiS2kgGoHsP9k/88ZFVYUIRUf5XlZusenSMqCsulfGdKda9fZAcTAOnf
	5zzd6E9HUTmiyNHW8ZjwIAKegpbLr1E32xD5rarScx/WdS7B6ZjY/a9u8ywC/o2vIsCtV0
	WT02q4X3vGT5Am8othTEMOfGEV1rTh4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782838752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k4zfz2a25b/4hh/Mk6SSry+b3vjwL3UMLdr/ekqsfYQ=;
	b=XKktRe8KsTnZCEe+7WNoc6fMZKzYQlact3y4zBUo8zFcJ/GDGJWcuiA/YaucAQ8UHqDIg9
	pNc47wFaW7vGTtvuJ04kquVeASxv7lbpnAr3Db38ZL4H9sbF4cbIlWxJJesSx5F1vxzsiy
	q6U2j5N1lOpNd0e25KP07SIomzA03Iw=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Uqtnrfbi;
	spf=pass (imf31.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.167.174 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-49600c51a17so48920b6e.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:59:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782838751; cv=none;
        d=google.com; s=arc-20260327;
        b=n0ywOFvP0JS3XrWatiOerqwb//1VkxWUsHdJ8DGGVueVvWlAUqXRPzIwCJJwwI1EQS
         bjkAdqQLv1arsHCcL2+UJOnNDHoB1iNA/mgOO+fZB++7us70A07dbxO5lCE+VLIOdQm/
         vsYTE0LE/I01236T8MEd10/TLO7WgT49PmnKpgCR+mjfRbeuOSXZLmK4tjkuWI3e5w+N
         fi3kkiMAnFxwbu0/NPLCJg0muIhtjBNcAkhkwLuLKL0pUGJ3V3mF7o05MHVHasfU5LaX
         gz+fGlSeoPCmEUUQXnJKLk4Rk9Rcr7sJWnmrABNUHNm2lZ74xO3FjDXDm5xhBIVTRUyE
         HWWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=k4zfz2a25b/4hh/Mk6SSry+b3vjwL3UMLdr/ekqsfYQ=;
        fh=l/pjwyTBpo/bbO0Sl4eHGkNH6GY5/qYsOH9jtEIEo9U=;
        b=l1GQ+SNakpTQN5sVrNZPy6Y5k/0DE8yyR7U3DF4XP02NFGVwqvF70MVqm2q0O2L2Kw
         yfCe+T55LSq/obRUXPyx3pqYDPHK/SpQi7x07x0OfBZQwn2hU1wqb1wKTOb4AMy1m1Ao
         qWCSc1q8WQUDxwr6Bxqu6xB+9KronX7U2DeBgYgqVQWyzedaDI6jPIdocUzUCzZUuZTL
         Xwl/a7wK3IcWXD24yiItPLYTS55cmAHV13+GpoRZ72a1lOLVciGHmiqQ/jgxhcnpSP9m
         MWnTRc1ixs35O5PrPDy4OJKmushQ6E+FWl6SgwT1DCWB+aS3b3VlW7vXcRgCwnKWMLhe
         WEhA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782838751; x=1783443551; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k4zfz2a25b/4hh/Mk6SSry+b3vjwL3UMLdr/ekqsfYQ=;
        b=UqtnrfbivniuRmHoc6n1ZZr5qU27FSyJYIwHnVFbNI+MrS6Q2GWC5aWmKgufp6BsoS
         +9QvL64Ul1vwpd95ZZlRjDS5TKZLg433xbG+1SXe+iywIj2T1z0oPQkza2rPDJAGMR66
         j8g2cUB6JhVnFTC6LRIR/NzYyTB4psRjz8VgpfRqjGRuofHGTxzDNOJNa669NGbSbBQv
         AcIi7ygCPlteCOYx/lrnTa0Dv9I73QYnoQPgvzEkCFRjX44QFeB1w8DR8aKQI/djpo2x
         TJySBAs86ovZLolOy9ZhYatbxGvrrxFAavyCKcjuqFilxTuKcrSwn3glp32C1QCBc3h9
         4EZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782838751; x=1783443551;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=k4zfz2a25b/4hh/Mk6SSry+b3vjwL3UMLdr/ekqsfYQ=;
        b=Js7gjAR7T1jqhY/8XBO+iTcEDnMALB90Ls0UpyvN50GOpDHCKHSx7ZYyuuPSNZ0e6e
         Kgr9bH6ib91d1vjYPZ6cJpnzrY8TrPcflm2gqm+ggjwIrveImdAOKgvPYL/OTJYPgdBP
         zIG8X7m3K8KDV7+bm1Adw/77Rgzt/GAtn3SxjpFhqY7fNFezXoTc6smbi9Jj5nZWj+qj
         oCGkH0YJbUKXOpxeTjcp8NM4LqSFDa9R1mFEN4CEYNe17CkQzcPZuzIwmzS7WTf5pyRw
         Og4tHPnmNxvbkgw/voUWTvUQltlXsnSSHHiUmtjoJQ7eP/gFvpZfDbyON7S5kQ8L2GGk
         TgsA==
X-Forwarded-Encrypted: i=1; AFNElJ/XxSYXkBU5pPI7oc9N4QZjzDRY3UfB32PHqymlusXWHFGElRqmKpKq2w7JCqVtXeuZc3jePlmqOg==@kvack.org
X-Gm-Message-State: AOJu0YyKvtOqOuUAuAPCpwDqNi7CQLJTK+a1AGCE/20TA0q2bICOfrFV
	vk6rRt7Qt3PcCAzeZBGwYuRoJfmMkwNi52/KXUhv7K6E8mS16wz/0lAQpE0BHH6wdwAYPrLzMUw
	bqAGhzIQ1M7LBnzoVoOVidK0YxljoISo=
X-Gm-Gg: AfdE7cl46nqZ+py/P5Ef8SrMpaofpipUq+/ICQQJpkl7pHDfbttDvLVv8ucD7DvFsjK
	+3dvdrpJ98OHJ75KXx0Ud31bTj66c7S1EoThxbZkKDadgcvHL3NzRFbIXz+iI87DAf1xOndbUel
	UoxRYwZfX/63ZxYzSO9nhK5SHCWzoaJhSzFfqDT5TlWDlsE0JzcMYsBRzoDdy6S3qFGFbGlxHdR
	JsBRh/JIqlYtF4vRpEUpeoB6y7CqTrfG/kF7tnYUzbZhi3zRwor9nr9A+Ms+6FAIccC5Q==
X-Received: by 2002:a05:6808:10d6:b0:48f:ba75:4d86 with SMTP id
 5614622812f47-495fd786f9fmr877167b6e.32.1782838751296; Tue, 30 Jun 2026
 09:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260622043934.179879-1-farid.m.zakaria@gmail.com>
 <sfv7zc6jboy2oxv7zuyofysas4ncbzenwsuzveiyduisfr6i7q@mx23er7uxdbg>
 <CACCo2jkDuwy5w_yhX8833m+s-rY736pk8xtKjxg3_y_7BCOHeg@mail.gmail.com>
 <24420045-a6eb-4999-ab19-1e344eaba8a4@app.fastmail.com> <20260625-atomkraftgegner-hunger-kursbuch-b452ff2becab@brauner>
 <CAG48ez2X1p5Nm2_sU=SK9wUusUO8c3_T-=FGrrOhkm7Kn9Y_7g@mail.gmail.com>
 <20260628-ungeordnet-orgel-stechen-36dd64038541@brauner> <20260628-debatten-vertagen-amortisieren-3bf518773e75@brauner>
In-Reply-To: <20260628-debatten-vertagen-amortisieren-3bf518773e75@brauner>
From: Farid Zakaria <farid.m.zakaria@gmail.com>
Date: Tue, 30 Jun 2026 09:58:59 -0700
X-Gm-Features: AVVi8CeK8WjwHCQZDoC40WvF605CJBeqNgve_898b7N0eQYbsYh8_ELB2RiXXo0
Message-ID: <CACCo2jkA=HajHww=Ysf+cg+LLTg8y1eHd3MZVJqCGtHryzT6CA@mail.gmail.com>
Subject: Re: [PATCH 0/2] fs: support $ORIGIN in ELF interpreter paths
To: Christian Brauner <brauner@kernel.org>
Cc: Jann Horn <jannh@google.com>, John Ericson <mail@johnericson.me>, Jan Kara <jack@suse.cz>, 
	Kees Cook <kees@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, shuah@kernel.org, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, 
	linux-kselftest <linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: p35jp5c9q74wcof6fyecetfppcm4g8yw
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5F4C32000D
X-HE-Tag: 1782838752-657425
X-HE-Meta: U2FsdGVkX1/P/BK47tA/dkPxUTitz4bJjTqL/N2zTrRxvEYRIZw4jRmAjutYOkJlrs60+vlJnCFB6sxKQw2fAVRusPEbFFeH2vWX+m1ERTTtYCMkC8T6ftQ8VKu87dM1Wkjuip6MR8G++JGhcewwzIkLhucw2XmlXPo5fAWp4cgpn89Reue31V3v0RGHbXJdgN7UgEadufdXAags7NsctuZ1GrGn2Tlwrohuy1OVi8IRf5Dj80CW3djKpvVYrw1cXNiKnG7GgVPPZRRhOxyo9PWUbyamfWSY1tCTbBwWeHvks2/tpgq5kL0rPEsBUx29H95Ucy+P13f8bUBrCANd4tm6jH/9Pwa82gZI9d2qRVm8BJ08jhZxatkHOc6OBh9RE4xzAmoXb6bpLrLvv+6WReYQsC0rvN+eOdfXgynm4eYTcGUVgzuCp3R0pQvRyEeQkPMwId6SwwsWFvJPNzSZCntpVMsc9DNVz2GKoBDG8vPn+mjXycAezjlIRoAGCnjuiLefY9/12rpfsRCYJ7L9/6Dq7jZT5aXv/1vl3YK3RdFArlSxxVcPzHjzF2JlXyVz0F1MC4kZmrrX2nzZJv82cKS12EivGrgJfLWxHUNecCStmX7zF5HmWGPBk5NlZzmcglhAMCoU6GR2O4HQQ6KKqReGBupD4yj16Qc3bQepi8kmuCh8VpGbJiegobOBKI5ZeGlfSos0MJSN+9Aj8VsfcwUj7B+ds26nnBGPkdbxougjKyYZJue2aprhUJ/VhZabGnlnIiyOF4YmES51WUZfnG36BGFSWPNG8/+uoiVqBM49kRBYB8VWQ94SUK4CgjwIfLGDen5BJfDMg22R51LMID30DAIC1ykHiFwOhmI8uaWmmremwIIbRDXAAhdb1yd02RHONqP4sp8W2bwAdPXt1diMzDfaFV8XzT3vsOUYErNtlBL7rLLhJkY+D8cD2whHDvFAFzmb9s7bAUlf6NG
 tVjvQhuD
 lB0lRf9AkJYe2CW1QgcZ4uTgK7Hx3Vgpk/7drk73nyCxBMQtOyUNyPbMKj+HGiSjqfWDTlhXENrYEQ2tQTtVcTJQj8eLmGzwcxFe4Iyk9MoGg3MX+DkJhMsIbCM/pk4ostXwWA0lvXA9tR5f/rk7jsLRte/VLyf0rpwqlQ6rYFXNS82OmHXvv+TtdUtDDOTVb2EMgiITFmvLhBB23MY1icmA2NtjMDZFWXamH86DYlXx3cXQGWaGh6JJycIwqya+lph5mBMvzgfbfBpjv9Q6NFfq+OTd8WTqo+HqRGh8/XWNEbbsgMRWJvcVagSxrsdVx12poGnLRlkxIy8+TPDlSos+v6CyWYFCUCZhnhQWcZs59owUlRS3Eue1b9T+/MhWo6BkmQMmpjcanHlG+VqtCHZqBiVPUoHAMhTpYXhT4gXD/rGg/s5lpnU1ZYfzbNnTu/zI1IK9+R5MRmO4opYE6V5TVoEKroYvzLg06GCHCWEuRnmTJ2I993IyMxxYe94mCD88twSHsgPLzN4RsgSYAEhATRhhH4E/4fQ3KxD96hKFCIseUyKxO7Ua6EGF58Tbf/2Kdv6xwjiaruR/1H1MPvQKVGvYfBQ3BMNHhd3r6isAvxvqG+ULzeCprUOdWbRW5FQg3pZwSo0zqdI7FLXWG7ABTAYdHUCRb1e1C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jun 28, 2026 at 6:20=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On 2026-06-28 14:36:52+02:00, Christian Brauner wrote:
> > > I think the proposed patch will only change behavior if the
> > > interpreter path starts with "$ORIGIN"? That wouldn't work on existin=
g
> > > kernels unless you have a directory literally named "$ORIGIN" in the
> > > cwd, because "$ORIGIN/..." would be interpreted as a normal relative
> > > path.
> >
> > I was thinking:
>
> A few other things came to my mind:
>
> (1) memfds: /memfd:woot-woot
>
>     A memfd doesn't have a path so any $ORIGIN type behavior - script or =
not -
>     will be at least useless if not very confusing outside of a sandbox.
>
>     Btw, used by runC to guard against binary overwrite attacks.
>
> (1.1) deleted memfds: /memfd:woot-woot (deleted)
>
>       Same as (1).
>
> (2) deleted executables:
>
>     /woot/woot-woot (deleted)
>
> (3) unrecoverable executable paths
>
>     No path can be resolved at all. What to do?
>
> All of that needs consistent, easy to reason about treatment. Reading thr=
ough
> the glibc implementation of $ORIGIN for shared libraries in rpath - even =
with
> an eye on cutting through most of the complexity - doesn't give me very w=
arm
> feelings. It feels very hackish and full of edge cases...
>
> Imho, tying the lookup of the interpreter to the binary itself and making=
 the
> kernel responsible for figuring out the relationship by resolving bprm->f=
ile
> and splicing it with PT_INTERP is terrible.
>
> So, I kinda like the concept of having relocatable dynamic executables bu=
t then
> let's cut through all the userspace red tape and figure out something tha=
t's
> super simple and outsources the problem to userspace.
>
> I think the wrap-buddy approach here: https://github.com/Mic92/wrap-buddy=
 is
> going in the right direction in that it gets the kernel completely out of=
 the
> way. I like that a lot more than moving more nasty bits into the kernel i=
tself.
>
> In a way we have been doing something in systemd that goes in a similar
> direction. As of systemd 261 systemd _only_ links against libc and nothin=
g
> else.
>
> Any other shared library is dlopen()ened as needed (discoverable via
> elf-notes). Lennart wrote about this just a few days ago:
> https://mastodon.social/@pid_eins/116781776665322560
>
> This effectively minimizes the work the loader has to do at startup. Imho=
, your
> effort with wrap-buddy is related. To me moving the loader invocation out=
 of
> the kernel and into userspace makes a lot of sense to me.
>

Wow the systemd approach sounds pretty surprising. As a Nix/NixOS user
having software enable/disable features depending on changes to the
system ad-hoc seems like a footgun. Despite the allure of shared
objects, the are less re-used in practice and rebuilding them when a
CVE appears is just as easy.
A good read to me:
https://web.archive.org/web/20260320072121/https://drewdevault.com/dynlib.h=
tml
https://lore.kernel.org/lkml/CAHk-=3Dwhs8QZf3YnifdLv57+FhBi5_WeNTG1B-suOES=
=3DRcUSmQg@mail.gmail.com/
(yes true, NixOS also uses "shared libraries" but they are effectively
static in how they are setup with fixed paths).

Anyway, I digress.
What other options are there to go after for a relocatable binary? The
steps wrap-buddy has to take... are a bit horrendous in practicality
(although amazing from an engineering-sense).

binfmt itself is configurable and modules can register additional exec
types. What about something similar for ELF & INTERP ?
Maybe we can meet-half way and support it via a plugin architecture
that NixOS can leverage.

