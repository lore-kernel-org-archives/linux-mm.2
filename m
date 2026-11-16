Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03F82606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B216B05B0; Mon, 16 Nov 2026 02:09:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F3AE6B05B1; Mon, 16 Nov 2026 02:09:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 030016B05B2; Mon, 16 Nov 2026 02:09:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D50416B05B0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:09:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 629681A08E0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:09:09 +0000 (UTC)
X-FDA: 85440105618.02.C7F0764
Received: from angie.orcam.me.uk (angie.orcam.me.uk [78.133.224.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7943640004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:09:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794812947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1mHmG9IJHtIMld4ZeRanDjKIMZUQxx8f0ptnWkrCv+U=;
	b=mu1357B8pphPY7usXCFd0lwPsvNWy24/QtxmNMjeJyNLH6rlz4QyPriURh9vpSm18K61f7
	UX8Y/T2hjPOlIZ8OnLzhjNrg6AC7+vllA6lF7QqT9QDvvt6oylG12U5u/yg+8cZb3bDkFB
	Zs3OdgQzg0qMVIFTzH12LYBjZtaEaMg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=none (imf17.hostedemail.com: domain of macro@orcam.me.uk has no SPF policy when checking 78.133.224.34) smtp.mailfrom=macro@orcam.me.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794812947;
	b=q1jJfNQumm4Y1O/+Uf1ZKDreFeCjap4euncqBvGB95WTYiAHYlRCUrLjE6Ip6wq8iJ+6Rz
	/43K5E1UUR+DtviPdU8Vu6mDX8L3ZV4iyA7abOJob8mq6mnz1zSW14FNI60SUBnjrkwZEb
	LbpiLrOeu6ur/jTt6QH8/F+mCoXAqxA=
Received: by angie.orcam.me.uk (Postfix, from userid 500)
	id 39D8A92009C; Mon, 16 Nov 2026 08:09:04 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by angie.orcam.me.uk (Postfix) with ESMTP id 376CC92009B;
	Mon, 16 Nov 2026 07:09:04 +0000 (GMT)
Date: Mon, 16 Nov 2026 07:09:04 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@orcam.me.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: David Laight <david.laight.linux@gmail.com>, 
    Christian Brauner <brauner@kernel.org>, 
    Geert Uytterhoeven <geert@linux-m68k.org>, linux-fsdevel@vger.kernel.org, 
    Jann Horn <jannh@google.com>, Josef Bacik <josef@toxicpanda.com>, 
    Chris Mason <mason@kernel.org>, Jeff Layton <jlayton@kernel.org>, 
    NeilBrown <neil@brown.name>, Eric Dumazet <edumazet@kernel.org>, 
    Thomas Gleixner <tglx@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, 
    Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>, 
    Greg Kroah-Hartman <gregkh@suse.de>, 
    Joel Granados <joel.granados@kernel.org>, Kees Cook <kees@kernel.org>, 
    Jan Kara <jack@suse.cz>, Jan Kara <jack@suse.com>, 
    linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org, 
    linux-acpi@vger.kernel.org, linux-kselftest@vger.kernel.org, 
    linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, 
    linux-um@lists.infradead.org, linux-wireless@vger.kernel.org, 
    linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org, 
    ntfs3@lists.linux.dev, platform-driver-x86@vger.kernel.org, 
    coreteam@netfilter.org, kexec@lists.infradead.org, 
    linux-pci@vger.kernel.org, linux-sound@vger.kernel.org, 
    netfilter-devel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
    ibm-acpi-devel@lists.sourceforge.net, jfs-discussion@lists.sourceforge.net, 
    linux-alpha@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    linux-cifs@vger.kernel.org, linux-fbdev@vger.kernel.org, 
    linux-hwmon@vger.kernel.org, linux-mm@kvack.org, linux-sh@vger.kernel.org, 
    linux-usb@vger.kernel.org, samba-technical@lists.samba.org, 
    sparclinux@vger.kernel.org, linux-m68k@lists.linux-m68k.org, 
    linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, 
    linux-atm-general@lists.sourceforge.net, Takashi Iwai <tiwai@suse.de>, 
    linux-input@vger.kernel.org, linux-raid@vger.kernel.org, 
    linux-ext4@vger.kernel.org, linux-modules@vger.kernel.org, 
    linux-debuggers@vger.kernel.org, Chuck Lever <cel@kernel.org>
Subject: Re: [PATCH RESEND v2 14/23] proc: let procfs copy in writes before
 pinning the entry
In-Reply-To: <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.2611160657470.17804@angie.orcam.me.uk>
References: <20261104-work-procfs-core-v2-14-76ace653a773@kernel.org> <CAMuHMdVfakapgBK6TBhO1iWX8qzvLDk8jzRS=t2MVa5G=MCUeg@mail.gmail.com> <20261107-akteur-gemieden-eckdaten-21304d085e35@brauner> <20261108185953.28054fb3@pumpkin>
 <alpine.DEB.2.21.2611090504170.17804@angie.orcam.me.uk> <20261109214558.0d9d5228@pumpkin> <CAHk-=whsA3tKcUCBJDj_vmJ11rVGT9rivgnKjGRgMO21CPmCxg@mail.gmail.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7943640004
X-Stat-Signature: gymb34ezsh4zxree4zxnpwgmb5hjk6db
X-Rspam-User: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794812947-759263
X-HE-Meta: U2FsdGVkX18qhtDyVvWHb2klhohM9FGx+ZKiUD8eNHrjKAbnC8Zo1CWVplPrHuLuvfa0V08aJCoKAz2gbIFhsMCwHoo0T+L7po7o4vEFHs0JgDoMhFs/TEeIPb8RaORBLO+a0ReoSbrTCIRqgttgNEnfctMqYU2JkA69JcIe/zqZriCAyfqbYQZoy3cEK6Yn1KbYUCzdmcpbzIpbZU22anGp/GOjDU0crLOpmRr/USTfh2ETFEePuQW+Ol1VBEkbhJ07OLMPw4jgmtysnFwmFXE5KOv50S6yKjsoV0NeljsbaIGn6Kllq3Up/p05r9ENejXvKlUo+RnAB/gLlyZj/9EalN99SthcAjXULrBaaFwZv7ne0tBmPKHU6MNSJjgVSFlp3hIy0n0gRZPcLx7D9p774r8iSMU4Y4eu6XOHUw5Gu/tgk/CADjOtUzpPMvDbb0Ccn/s/CWbWpiA4pHwiZq5l/0ykNaQbQ9KaLAOnbvhiV+rKyiv/1F9z3Aw9Xk2g1Z5QPidzICbN2Iakk5LM0i1BcIf4qTboCj0pBhDHJv8BKICW/nEhTZMn58/TTtBo61FH3qU6l30mrkvz6v8OBRsQnFDpJGLQYQbDg36m3/dYinVodQhZzve82W3Dh5M3t3r9bNTuI9HTtQ9ZOhWcuYGsIHdykszrf2/Wm05YlZ2dJMuwaWBFgxc8lcrOl9wxKoGPII6dACeuCPAQiWgCg9FC9O1rF/c8yKgZCd24+lPEHKzZi7X7tbOfdmwNK1BT6VMLp7M3lzTpOMYCW+hWW72rURS+g+MAM/ssqnD2+i1AX9o7fe2toEDN73xIBDQuzZzJoK56YiuQqIi/okYH2WfQ5/GLBY1Oj9ImYzLno7K5I676dmNGZu9QmJ5DAsThGPtgGbHq5ipnR4odd1PqyCS3uicXgw97HCkFxOUubJpC0MaxZQeTQjSIfWFGuocjqQm+J4gF1UvMFfcv5Nz
 FuZrPH0l
 yEcZQcJ2X3ftfgUOOV7/xiBRpa647uVZRA0dhA3+FW3BP4egyOJX6U7oyHoJdnhDOLGs1uMiJROxt7/gv3AwGdZ/zKx7PvrKSsbIcWtIeEvZZC+I+9rVugsy0J9Pij1tvtcPS7U8e0FIkkEuSI2BizUynVbpOu+8EOkSsV6yKCcD+qq0FyYn1XZuxnDC2hsMXSo+XS5VTzvqm2cNbN3VjDhtAYEDaZEQg5joKVpEgvgRMLk0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 9 Nov 2026, Linus Torvalds wrote:

> > Just that the cast would have to be:
> >         u8 *foo = (u8 *)bar;
> > where 'bar' is 'char *', and I don't think you need a cast there when
> > char is unsigned.
> 
> .. and just to clarify: 'char' is always unsigned in the kernel on all
> architectures since commit 3bc753c06dd0 ("kbuild: treat char as always
> unsigned") back four years ago...

 Thanks, yes, that's the piece of the context I was missing.  I've since
actually come across this commit while investigating which Linux ports 
have plain `char' signed in the psABI (MIPS for sure).

  Maciej

