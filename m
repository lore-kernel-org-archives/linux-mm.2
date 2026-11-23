Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DD11606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 00:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D9PzkT11
Received: by kanga.kvack.org (Postfix)
	id 77B0E6B05B1; Sun, 22 Nov 2026 19:22:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72C516B05B2; Sun, 22 Nov 2026 19:22:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 642B56B05B3; Sun, 22 Nov 2026 19:22:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35EBD6B05B1
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:22:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83AFEC079E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:22:51 +0000 (UTC)
X-FDA: 85464483342.20.57E54F3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E6B6240002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:22:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D9PzkT11;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795393370;
	b=V9p5aoHuBHZ4wZ51s1I1p1h83p71M1fXSbTfWAZiYOCa7yhASNVe8ggMAXwKv2eYlhwA8S
	MFjLVTWvI8bvsS4T9k55cYgTYokFuX0Rvh516k7xNMMotV3soY3S280h10jL2kBgvABc08
	0WWQHioPs22M0WqVRP0E3DVXTkUHXxw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795393370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jz1NKIIKgCd2mV0Gf7xePKwq1B4TLlq2GWrC4ESjcAQ=;
	b=Qka8+wTHfvD0VQVdLuxzgx5SKywcY0MHa3+t1w0LLugLTh59/Xo6fpRNVxpKI10iKd/KVZ
	b9FMLX3SyiQLAccHAIbLOTl290WGWxS0mu4Oa9sSFPK0SN/HW8zm0c6cy3hHai5fpBOPkh
	QEOeqo/tm6A+biJN8RjTqLRiwCOp8Zs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D9PzkT11;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 30BBE60DEB;
	Mon, 23 Nov 2026 00:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 15F751F000C6;
	Mon, 23 Nov 2026 00:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795393368;
	bh=Jz1NKIIKgCd2mV0Gf7xePKwq1B4TLlq2GWrC4ESjcAQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=D9PzkT11tfiXFbsmqjxDg4JVSIMsco9OtJLz8dJ3yn2/dEcJVEzcRbuZCSLbL4pIQ
	 NF9VESCGoar573rnroMuamO3celH4JvkzdLprPXCbFU0eHdwWCBjioF8vNDqae4K2U
	 w/0Pd5FZ5y+8wjRW+NkSdYPoaeBvmJBFPMnYS7EPPkexL9VZEZPlE0IRVWk8zCdpaZ
	 My/rP7StpwNbAYvw30XqtjzLOGJXEtSw56b1hzxXaQXLqgX64NeFtM52qSXjYW5fUI
	 mEYW9GYl79/y4A7eEhdM8pWZ1fxk4ooDT4Y4OMfTFDAx9aWat5amCSC7XxETL0zCHh
	 2siz7HXceBmwQ==
Date: Mon, 23 Nov 2026 02:22:44 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Giuseppe Scrivano <giuseppe@scrivano.org>,
	Hugh Dickins <hughd@google.com>, Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	KP Singh <kpsingh@kernel.org>,
	Lennart Poettering <lennart@poettering.net>,
	Neal Gompa <neal@gompa.dev>, Oleg Nesterov <oleg@redhat.com>,
	Paul Moore <paul@paul-moore.com>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v7 00/26] userland: Userland containers
Message-ID: <awOHVCpztLQv4Uwv@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awOEa303zNUDrzA3@kernel.org>
 <awOFGIWekH9-vlhM@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awOFGIWekH9-vlhM@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6B6240002
X-Stat-Signature: 386ty6wcuec6nwiyomk7gknnmgjufopn
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795393369-931325
X-HE-Meta: U2FsdGVkX19HBNukiurucjEewW7jQrkd36YviWgwchuuvI7EjXI2BhBy1hAhxPL+RnkDIvWhw8sBLYr77Hf+tftzonISI8vXwFyd6VKudWn6fdOdtCyarrgHp6WhKL9orK++aU3cS4hJy524DpImnbrFnHyrYhLVG/E4hVrDICrtZo+Ib5G0GQsBs15AHlYP7gSvO6T6uJfKcQKSqR/gY61sPfVGGieuwKwj2gfFDAUD8lmep3QeZZnWAr7zBtY0Udqwd3oyzRm0FmgYDu8SJWBNX+KiAjAh5SOltZVnftwfMLeNt8jlYfMmkYA5nGjvWn6UcQZRPFoe6qO5XB6K6ioTQLZ04vT0BgLtkyXJjdo5EW8WTb136rZM6g40JpuDa3SsrGVlXJfZhnZinDXDTtKKAl5lf5oPGpYnzdZGP6hONZUfdNlwlvOV8hxABvzMkQP1sS6I1EPmrpuewFq7EomyEut4hJc20n3I+3s0Rmn2+SirodK8th/Wsk70I18/bYm5DVrjf0XZBlkyqcqbI9m/cwA5cro7ohR0Tvhfec76Aws6MZzef3aVsXA0Ce/TKAGJvHj8dD/eF6EKD5zNUdEKlKLYcdsbjJcEl3QNd/Gk5IlOrvX2NLKYjt/jKrZVrXK7Gvh5Iv3q21bnpQ8knOyFaHeST8pHnrMQRRLP5rvw4S2LPmGqEqj4MZEpcJ3TatUHQVl0I4KwGnwslZSsQevg9nsqxedB8FMe3j7Exg46xqaadIAQ+KCiBWOs+bJn7TmXSYjKO+J0G2YUAJCgQCFKchdsPR7r6/mD/ePQlOD6jE9hvTBN7X3hjfBr3vccDk8qVD6jD0fhJhziRSrUv8BRldKAX3B00C2zlWt1Z+2Ib23xT+ww+xYYpQnAtLQQakA5B6SUYhPMIyC9wmWQcHNDFxws6uU7udbRths1GfO3eafbsoSwb901+vj/1c5MR71ibzM1j0b5pQfv9YU
 7sOmgqIG
 w8FTszsQ68cNLHjqe45kDoRrUxFgUhwDpjJAqJKtPI6d+JKuSUYK+j9rEZhkZoJz2Oy2r+2doZXs3gj0OEhQaY98+txRLwEklgh9+rQHPr63Zo37bszyFbZROVnKAn+B652bZEc+i6HvUx99ET1oCYbFOHIePnk+JN+9MDVX5wMLa3efMzUkC4S6UVYa2s5SVCxe+owIp897HPlgcViXvdOD69rTQ4T2MTtCjMVY51iPZmtK81mX3eHYwIrPvuxdAfwJsz8yLkDFX2WJ+cZuLDY7xZj5G3JnLQpJ//M7fSXipUCO+xKAgHtH2dCsdhQbO4jnVgVBxUgitroLua0m8eYa+BJsS4eh1aPmJJlLZeL+pVoTXEoLIbTXCLxKrd1Cf7xh9sCfy0EVUZs7Vyvx8D19umvFNCvubO8R4cANjvWhwpNRfKwU1aQiqJ5ubBt6T14UT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 02:13:16AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 02:10:23AM +0200, Jarkko Sakkinen wrote:
> > On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > > SYSCALLS
> > > ========
> > > 
> > > Two new system calls are proposed:
> > > 
> > > 1. userland_open(): open an opaque staircase-initialized container
> > >    object (modeled on Intel SGX enclave initialization with separate
> > >    build and live states) with no embryonic state, opting selected
> > >    shared namespaces in via an allow-list instead of unshare semantics.
> > > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> > >    extents for a container user namespace in a single atomic system
> > >    call.
> > 
> > Andy, perhaps a bit too far of the box idea but I'll just throw this out.
> > 
> > An alternative to userland_open() would a file e.g., virtual device
> > file, and necessary wiring for open().
> > 
> > Then the added syscall surface would reduce only to userns_set_idmap(),
> > and it adds more robustness to access control (e.g. who can create
> > containers).
> > 
> > What do you think of this?
> 
> Also, easy way to detect the feature. This does make sense to me.

This as a side-effect would enable LKM compilation, and reorganization
of the beef of the core feature as a driver. Not sure what would be
the best location for the driver tho, perhaps just drivers/userland.

I.e., full decoupling from the syscalls.

Br, Jarkko

