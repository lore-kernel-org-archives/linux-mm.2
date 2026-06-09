Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C11F6CD8C9D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 00:02:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3FEB6B0005; Mon,  8 Jun 2026 20:02:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1276B0088; Mon,  8 Jun 2026 20:02:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A06836B008A; Mon,  8 Jun 2026 20:02:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 934E76B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:02:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D75A1C1F97
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:02:15 +0000 (UTC)
X-FDA: 84858421830.08.426A5C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 017FD4000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:02:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eXuaGwnb;
	spf=pass (imf01.hostedemail.com: domain of luto@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780963333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woImH2BFt1btrxe26vw/Ytjm9bjqS1jpO9bbmq+ghwc=;
	b=oImiME573mrL5jk4K6FOfAAQj/txnUNCRaMQGvIvOgY2NDbAErT57kNJl6wrAddXcyrrGq
	wo9mnf3I5ABWwRMbnPSzPGKYC0/OaVZf0+mr1hAO7NXcGmWNWv3mw+NMD5InU7sv2/WTMW
	BwSNL9YeBqmkn+4IdpOCdtVs0KqRFyo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eXuaGwnb;
	spf=pass (imf01.hostedemail.com: domain of luto@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=luto@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780963333;
	b=gA9H9O+ly9s4f/PgyjIIflZ6mXrx5SQlr75RnNg4nwAeUZ0xtKmowzBLM+qKuxlj5gDIWW
	OHY6+5ViAhj5Wl9GPEVNyFTZJ+FxrnYuQ1O6/Yrk082NN26b/37hbuTDP439Ctcs0FENvR
	BNL8nBupSfRv5KRLZ0cj7/gDGwBJfKE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0EB6445D3
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:02:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1C31F0089B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780963331;
	bh=woImH2BFt1btrxe26vw/Ytjm9bjqS1jpO9bbmq+ghwc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=eXuaGwnbfl8E6wWfryKLt6weIAT4Z75+aTG0aA09Z+6+P+DvnOGzlfBa7qcSo+qls
	 CnpTVwlPYgMZb/84L+cL0zl/yqRgJgpiQNZNj3tyKzuJCDEXeuCmBvrTA9Twy/cyVv
	 13dmIrffNPg2+LY5j4c+OoGNTYA3oTB0OFQtwlO1BU7G5BkI/iPIk/xtxxFdXKpn2f
	 BYv2cBLQmh3UN/irun0I9IcmsMPa68yUN9BZELLHlZnykCZRfz486h56QvGFPkyGEV
	 Ks3lNGBKxpBu3lNX5505W24I53sadF6CTOf1KL2Lh9PVyzbofFtHL3rVYiFYyaOfNp
	 S+kOHw3mOgtxA==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-3967738c801so42017801fa.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 17:02:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ/VhNlxaHw78aeY0G8wllqgD+TUOA0pUHxG8voe7W7y3pBJQkGm/uZfHDWzlpa/D78TlMoDRW7jOg==@kvack.org
X-Gm-Message-State: AOJu0YyuFH0FZ1CLiZXfbSDuaFoxSARNZ/Dj8TWf+Recj8+FFLi+zMrJ
	G0A/5Qq8mFPIriFHIPweJvYxWj51384EMHp5OwK3nDUG3HDnOibNJnDpH/8MBR4INRD0zx3jLIA
	mmQFr9ZLd6lqxWWi6WNgRJR+TzAbaPsJQa6nn+8c9
X-Received: by 2002:a05:6512:401f:b0:5aa:73e6:b6f8 with SMTP id
 2adb3069b0e04-5aa87c3b216mr4211255e87.35.1780963330006; Mon, 08 Jun 2026
 17:02:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260528095235.2491226-1-me@linux.beauty> <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
In-Reply-To: <20260528-madig-fachrichtung-fehlinformation-61117ba640da@brauner>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 8 Jun 2026 17:01:57 -0700
X-Gmail-Original-Message-ID: <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>
X-Gm-Features: AVVi8Ce5fjaYqJFvbRl5NO-VXKi7ykDdQPBWcGcRNHTyLfWlxfmRoC6MkWLNyng
Message-ID: <CALCETrWJQpLR4n1cpichBk8=uExSKLWTMGU3BufGdk_WE_p5UA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 00/13] exec: add spawn templates for repeated
 executable startup
To: Christian Brauner <brauner@kernel.org>
Cc: Li Chen <me@linux.beauty>, Kees Cook <kees@kernel.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-arch@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, x86@kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Jan Kara <jack@suse.cz>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 017FD4000E
X-Stat-Signature: n8x4yj1n54ocmf9xd8kg66jstjd3s7b5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780963332-854145
X-HE-Meta: U2FsdGVkX1/cIKTi5xwDBQzImc37xRsSJTLHTWPDvQUb5P650D7X6aICo5+Il9oyndpr1W7Gvi+//JErqWajxT0QmwbSusJn2K3PbTb7qQ18yNYWJZ7by1yqSkinVV8LCr/zHRb7j1b+n/MFyIeQsTdHtNzB23wwJYf148ldtMKnHdfefoWSHZB1X9FE2hIRmA+HeDnBAdsiDusO4yB9gZ5LUXEuxKNqKMwOK9Ttlhg12/84G2xkuFBCBgCBXfNRNxCgUx2wQCDcg+ak8HOM0857HoA1ziTAchRzJBPwRFKzYYQCdwxbUSFhIEguKJwfGl+5EFJWRoDqAwZh/1j7occ9G7R0jKrgeRMMX6sPNLhcE7ubRIUvZiTJ/wDPtfUZgqIta2hoWe/JsTUqODyVw2KmjLHEI7qg0Ahmfb2JJJVecWRw3r17D6xzZ/ZtvZ+cPj71HnCoEkP2+lzUYH3hI58+tnJi+cEA2fLCYzcSbuKklWw3zsoKfsVGJ74pw97qWMDtkcFdf8M05y+IccD2Z+c/yI8N/rA+O8Q6oIqUyQgd63fJuSClSj/LbQx7K6n7iZr0jsAOV3O24FFNrMIjcoNeZ5nBWsBXa1pkgrGqjS/89LnwWftQuKI5wXdKLIsBPS7OGv1cRhQ0lLsBOoHaM6geoa/ACxlEh4c5WQ5U3+R+diaJYHKqwee8AWDqvDvyZ45U4Izzj/CXpXhoFD94hlImqYaDd47j4gp1Z/BsZHMTFuoya9WB4ryJa56Tc/z2seLhiR+QGBuFyJ7nFTsq5R8qYQVMuOuMlFCALbjjPn484wI5B39PCdTsakJdUb9JJpC8IfCCNQ7/iYrr9yFLI/mzxdnV0kuf5gpmckBDxC365d+v5dH+vwFm9/mL6tcNDih3eLyvyWU/ZewfJb82PlucCbQYEkDp3NJGJ2Rn/OskfUMyOvvtCLLlrr7EFipnEgRShMEWAYLgqijAQ6+
 Ld+vQwth
 AEa0sp5S2J2XQas33WRejNg0qA0uiRfsjXUUWOezYojASfIIwi/7r79HbOpqfG1UTjpvlu3uap5X2JOgTHFh9luk96KK8Lh4nF0Svlos1LujoDcIp5spcZpav7jwlhPOXlrMuDW3pCI2eLqXpLcwiZE8VGjOzf/wHv3/TjroLQdwy1QihJSLWrWb7qYTx/vcCy/6uUmtG2fiGVCXe+62mPT8Jjk9r42hiSMcNw+nusXzU9+e+w3zBbJLqtiXCx8Z9ZRETK22J/iC44spJ5OcnDZ9ww+GQT1uLQUXKGnN7W6M+zjP+LZGJypjMAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 28, 2026 at 4:05=E2=80=AFAM Christian Brauner <brauner@kernel.o=
rg> wrote:
>
> On Thu, May 28, 2026 at 05:52:21PM +0800, Li Chen wrote:
> > Hi,
> >
> > This is an early RFC for an idea that is probably still rough in both t=
he
> > UAPI and implementation details. Sorry for the rough edges; I am sendin=
g
> > it now to check whether this direction is worth pursuing and to get
> > feedback on the kernel/userspace boundary.
>
> The idea of having a builder api for exec isn't all that crazy. But it
> should simply be built on top of pidfds and thus pidfs itself instead.
> It has all the basic infrastructure in place already. Any implementation
> should also allow userspace to implement posix_spawn() on top of it.
>
> fd =3D pidfd_open(0, PIDFD_EMPTY /* or better name */)
>
> pidfd_config(fd, ...) // modeled similar to fsconfig()
>

After contemplating this for a bit... why pidfd?  Doesn't a pidfd
refer to an actual process that is, or at least was, running?  This
new thing is a process that we are contemplating spawning.  I can
imagine that basically all pidfd APIs would be a bit confused by the
nonexistence of the process in question.

