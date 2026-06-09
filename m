Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30DB3CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 14:43:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9249A6B00A7; Tue,  9 Jun 2026 10:43:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4DF6B00AC; Tue,  9 Jun 2026 10:43:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C35D6B00AD; Tue,  9 Jun 2026 10:43:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6705B6B00A7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:43:34 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F802120628
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:43:33 +0000 (UTC)
X-FDA: 84860642706.17.0DBEFCB
Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8FEB118000A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:43:31 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=COdwqkDQ;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf16.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781016211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/y9sk2WKJk6IVRAkewpieDuGt24dURWTghxoT+OO5zI=;
	b=id6NnK8Y6IDkE8kwG81kRj163Agp2wfMLLCMedMQIG32B937Xl6WR275APs5ecmCnTLrCm
	0QtCdmcV8Fl74MzUjIh4cBWUOnPVz9P9gr3fVjwnOM9dKv4xpkapchHKkQsV3boSqo4kJy
	p9Iy4jQ9wxekwfedUuUnDob5oH75Li8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.beauty header.s=zmail header.b=COdwqkDQ;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf16.hostedemail.com: domain of me@linux.beauty designates 136.143.188.15 as permitted sender) smtp.mailfrom=me@linux.beauty;
	dmarc=pass (policy=none) header.from=linux.beauty
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781016211;
	b=o36W5CwoyGwSx6g1JbpNJjF4aXbMTk4gcSxfUfdO0xC4+ZygT7AbgcMos0n1fFBYup+JfU
	gsYt2cECMHrXYpILQobn2s/DN64s0Uvae21l8VrNZqsV2R4lMjS5imCFwl/Tlui7VJMprT
	lrjJfCq+f6Q1/+Jn/cVllBzLZof3JQ4=
ARC-Seal: i=1; a=rsa-sha256; t=1781016191; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=h7rLtiBgT6JIZSxmJMtvUqc4vDZXEE84xSFHH7+I7DRRoiIxpI6USJd4jeM5QKxTHLBOjRdGlGPZK491r6Ic0mZHo4E6Os5MnWiN1hQAtcqCaRDitY6VvI2f6oz5eb3b9mj4UTqInmHmmH9FyLo9Z/0p24DR0VZIseC0o1dhDWA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781016191; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=/y9sk2WKJk6IVRAkewpieDuGt24dURWTghxoT+OO5zI=; 
	b=f9q23nRD9SwH6P0dfQ+zaosNvHpR6OplQgfllXtgS+3kEfwrreImsF/Jw5oxfWk7c+v3pkV1oH1syqog/nU1i9ccZ4I1GbIytyRi6YvbmuDAhDo245bgvuYxw4L4FU3++fOLhMhm6/JQ6zyOrPZnYLAzpv71AKwoFhzJKFwluyk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781016191;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=/y9sk2WKJk6IVRAkewpieDuGt24dURWTghxoT+OO5zI=;
	b=COdwqkDQJ9R0ZBvzBwIwlx+nRdcQO9W3BEy4BNPz+VcJ0wKYsAMd0YbHmrS6azhT
	338RbHqaewKGsSI9be4yoWBCQGRKqjBZG5nbubYRN/04VYI2Y18hEQ5IZt8uHveiPhe
	CGUwP+qJQjwM8IFoZr8xMCL7e4gyrv2AhDkkmgj0=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1781016184094100.75145563479225; Tue, 9 Jun 2026 07:43:04 -0700 (PDT)
Date: Tue, 09 Jun 2026 22:43:04 +0800
From: Li Chen <me@linux.beauty>
To: "Andy Lutomirski" <luto@kernel.org>
Cc: "Christian Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>,
	"Alexander Viro" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel" <linux-fsdevel@vger.kernel.org>,
	"linux-api" <linux-api@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>,
	"linux-mm" <linux-mm@kvack.org>,
	"linux-arch" <linux-arch@vger.kernel.org>,
	"linux-doc" <linux-doc@vger.kernel.org>,
	"linux-kselftest" <linux-kselftest@vger.kernel.org>,
	"x86" <x86@kernel.org>, "Arnd Bergmann" <arnd@arndb.de>,
	"Thomas Gleixner" <tglx@kernel.org>,
	"Ingo Molnar" <mingo@redhat.com>, "Borislav Petkov" <bp@alien8.de>,
	"Dave Hansen" <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, "Jan Kara" <jack@suse.cz>,
	"Jonathan Corbet" <corbet@lwn.net>,
	"Shuah Khan" <skhan@linuxfoundation.org>
Message-ID: <19eacd64508.26b92c022125848.262962729296162879@linux.beauty>
In-Reply-To: <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>
References: <20260528095235.2491226-1-me@linux.beauty> <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner> <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8FEB118000A
X-Stat-Signature: oxsisuqtxkansf4sr8aghjfwbqazfc8i
X-Rspam-User: 
X-HE-Tag: 1781016211-771253
X-HE-Meta: U2FsdGVkX19AAWD1pgzawin3WgyYjQLFPK+NiooQb3TOZcXJfrvIZPt2HEFaArknWH+OcmL8YAErdvLpJQf4BXiKzu/uOzeW1yEpEtqu7CT0VKHmgty0aupwbQpOBYEp5xVpx4R5Pr5qUFcCPt9cR/uxESDxGdIPwFfJuHq7qvxJ1w7dwr6Bp5ISJc881acftUcjkA6xlE6TcOo9kNfKuTPCeAS6sYUY3iw01mLK/WWr9c99QfghgPcPIKsJN/LcphFKzLWwMpnzxWJt8zD1FMjy5ZjFZ/ZiQwtZOiYw0vP33WZmTxyvTElSjBMzLqok86QjcJd87O7xWTpQ8kS01zat++8TMLIQ05oDj7UBgkoKszZ5B0j3JBf3aySEdDmNM3CyhQQHoZ3NCLpfPTSSS5g7TOkcJKYyaZEStozPYQMX3RQf0TFN9qsOA16B9tuHMp2fIDq1ehUNdwWcJF1YdIppg4hJYpO14RnVTwo7KoK4JwUvLCdtP8EA8PSHU5TR/sOZiBb5M0I8M4axFbYmmvORW61DyO2nvqldiBvKs66wEhAg2x4x1tR5lp0cgCH1peOa8QWZOy8DkkI/e3qeJqEe6SXB0nLjQB+i9IJQxFeLhUnURXQHjo2HM73Wi4CiHaAsz9y5bAXbEdEb/LsBmyON4HS3wAJk+l4zeC6Z+3kPZ1xDgmdWiP5xHchryVqTRKhzjCFHqGJPZEAdwR98geEvZgjFhDbDYzr3qwbGW/EbXSQFv9TxB8Lx3glZbz+IGcVwpy4guCepIpshCLb0Ryt3seiJEMYULU2/X1vzLZEEAQEEDj8z5NfwmqbB4o6CFyTOd6nTurSYjIa8YukBphNKk7ByVxYGKfQgZ5pQHLHDe2be6h/IUAtTLI/9PvDMDKZpxMPmdaxFasGp0ETgBBvgx5v5VtzAfY8MY4Mov+7UxecQJQf2lLV00OXuwvZZoLtlsGjmnefCvAJepei
 LDymXmN4
 LYWXOvMQtVTSFvXkIXE72wLqVpDp0ZyyW837fk3IngQMFbZQ8yyWV7O+S6oXbbSu3x72I1A3vpZuoKQi66fUaOmB3ljVemE+JW5N9EDCzftTZgExo2teqP/cU8VEekcWjcM1TvFLTHBhFjpyHNdBmNOKhB9s/CnqddnjiFKDZHCoH99z+n+yJGFx9RY60Ht8Vqn8MmDVw2W0so5FIkXTAEX4J/8IjqZhmsZIizeyXytl0KCZi/fpbb7QFGd4rrNNowRxDAu+JEnRNAXja9UCn9x3Wa3haSfYYDyh6C+BEIzkl0egwLEkEM5pzAAoBe+sk7fgld+QUIOMo4Tx1nIlp/DI7xFlr2W0SPGmYXvX/i3ddbcqu3DjHCynIoeF+5GHgwNRq2vqsKezsEG9LdrJeyyqrn1exs4mHLbhO3vYFCh/Y0NBB4iH7kYB3d3uWS2Iz9vqXlzTuCXoWQUNLdvcAjpNJcneVStmTDfmwJr5aj95LOLSmn9c6qb0fNcc1nWrjDqJ2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andy,

 ---- On Tue, 09 Jun 2026 08:01:57 +0800  Andy Lutomirski <luto@kernel.org>=
 wrote ---=20
 > On Thu, May 28, 2026 at 4:05=E2=80=AFAM Christian Brauner <brauner@kerne=
l.org> wrote:
 > >
 > > On Thu, May 28, 2026 at 05:52:21PM +0800, Li Chen wrote:
 > > > Hi,
 > > >
 > > > This is an early RFC for an idea that is probably still rough in bot=
h the
 > > > UAPI and implementation details. Sorry for the rough edges; I am sen=
ding
 > > > it now to check whether this direction is worth pursuing and to get
 > > > feedback on the kernel/userspace boundary.
 > >
 > > The idea of having a builder api for exec isn't all that crazy. But it
 > > should simply be built on top of pidfds and thus pidfs itself instead.
 > > It has all the basic infrastructure in place already. Any implementati=
on
 > > should also allow userspace to implement posix_spawn() on top of it.
 > >
 > > fd =3D pidfd_open(0, PIDFD_EMPTY /* or better name */)
 > >
 > > pidfd_config(fd, ...) // modeled similar to fsconfig()
 > >
 >=20
 > After contemplating this for a bit... why pidfd?  Doesn't a pidfd
 > refer to an actual process that is, or at least was, running?  This
 > new thing is a process that we are contemplating spawning.  I can
 > imagine that basically all pidfd APIs would be a bit confused by the
 > nonexistence of the process in question.
 >=20

Yes, I think that is a real concern.                                       =
                                                                           =
                                            =20
                                                                           =
     =20
In my current local WIP I tried to keep that distinction explicit.         =
                           =20
pidfd_spawn_open() returns a pidfs-backed builder fd, not a normal pidfd
referring to a process. The builder fd is allocated as an anonymous pidfs  =
                                                                           =
                                                          =20
file with builder-specific file operations:      =20
                                                                           =
                           =20
    file =3D pidfs_alloc_anon_file("[pidfd_spawn]",                        =
                             =20
                                 &pidfd_spawn_builder_fops, builder,     =
=20
                                 O_RDWR);                                  =
                           =20
                                                 =20
and the normal pidfd helpers still reject it because it does not use the
ordinary pidfd file operations:                                            =
                           =20
                                                                           =
                           =20
    struct pid *pidfd_pid(const struct file *file)
    {
        if (file->f_op !=3D &pidfs_file_operations)                        =
                             =20
            return ERR_PTR(-EBADF);              =20
        return file_inode(file)->i_private;                                =
                                                                           =
                                                          =20
    }                                                                      =
                                                                           =
                                                          =20
                                                                           =
                                                                           =
                                                          =20
So the current split is:                                                   =
                           =20
                                                                           =
                           =20
    builder_fd =3D pidfd_spawn_open(...);       /* builder object */
    pidfd_config(builder_fd, ...);    =20
    child_pidfd =3D pidfd_spawn_run(builder_fd, ...); /* real pidfd */
                                                                           =
                           =20
Only the last fd is a normal pidfd for an actual child process. The
builder fd is only accepted by the builder operations.                     =
                                                                           =
                                                          =20
                                                                           =
                           =20
This avoids having to define what waitid(P_PIDFD), pidfd_send_signal(),
pidfd_getfd(), poll(), etc. mean before the process exists. The downside   =
                                                                           =
                                                          =20
is that it adds a separate open-style entry point and is less uniform than =
                                                                           =
                                                          =20
the pidfd_open(0, PIDFD_EMPTY) spelling Christian sketched.                =
                                                                           =
                                                          =20
                                                                           =
                                                                           =
                                                          =20
If people think there is a better way to represent the pre-spawn builder
state, or if the preference is to integrate it directly into pidfd_open()
with an explicit empty/future-pidfd state, I would be happy to discuss
that.

Regards,
Li=E2=80=8B


