Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE6C1606A322
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 03:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Hl37Zxfq
Received: by kanga.kvack.org (Postfix)
	id 04A766B05DB; Mon, 23 Nov 2026 22:38:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022F56B05DD; Mon, 23 Nov 2026 22:38:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1586B05DE; Mon, 23 Nov 2026 22:38:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD4A06B05DB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 22:38:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CE714120A44
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:38:00 +0000 (UTC)
X-FDA: 85468603920.09.AA04EE9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 209B340005
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:37:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hl37Zxfq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795491479;
	b=M1uv38+vKgPqefvrU00dHG+gEd3pYOdIhIJIb2j+l/vHxRXeI1XGlXvf0M/s1YF/cbBzde
	XKJ+3nDtf/mw/eC70dOztDoaCM7LB9wWQl+/3v/ZSX6/NQ8ITVeHQ7JHEPyq5xrluoTL04
	tnwBS2N9qU+10xInAVweqi6f8AFAg2M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795491479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+eRa9i7CtmafJcWw1IGcHObp/3OCLe48VR0aUW22rk4=;
	b=3mU2hyqhnI4mxIHttwOnke3qS7VB6igQY6CbLhhfWSPNN6z2hliXHZueHi9wCaBRF5U4nm
	a0ZJXiZHwJ60Ko3bxkMZNJLF+B9fokcbpJir93eavYgIn4vW62/jsqc5U26inr0vQq1QJs
	3+HOk8kwJdCyEwYoydoCKqMtx7WlRXo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Hl37Zxfq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 44D1241915;
	Tue, 24 Nov 2026 03:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CDC1A1F000C4;
	Tue, 24 Nov 2026 03:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795491477;
	bh=+eRa9i7CtmafJcWw1IGcHObp/3OCLe48VR0aUW22rk4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Hl37Zxfq1YEb/KW6XeaIPjFuYb4guOvBMUFj3yJB/7niV5bf4UPy09XENiuDlE9Ro
	 LAgxCwk64dt6h019EHmRmYSy46uw6JBtlDnXyxDEfQX2za1Sme7AvkduutqDAAccg9
	 O+Dod/5SGwPR3ree5ZExwPLvTmHgQeo/k1s9iYM7Rj72CZFTed3+mVRzYLxvI0gfY+
	 l4vATV8jbRU+l6KcJ25ccKrWiDViDDYUk+XZ25WsEq+cE9ZhnAmulrMGJH7do/ALdP
	 xRi/t7qoD6nkbm8NsRwRO0e3p3o3XyK9D2KYBactsLrtGTZB1RIpE1U2DD9tJEzf3j
	 OOlFdDsneTPpg==
Date: Tue, 24 Nov 2026 05:37:53 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: bpf@vger.kernel.org, containers@lists.linux.dev,
	linux-api@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Aleksa Sarai <aleksa@amutable.com>,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
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
Message-ID: <awUGkYoyDXp4P5LJ@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awTmJIErjasO4lqq@kernel.org>
 <awToL2PFNKVgIfqs@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awToL2PFNKVgIfqs@kernel.org>
X-Rspamd-Queue-Id: 209B340005
X-Stat-Signature: dpn6uhurf5fzw34jpnw1pims4rqdchrm
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795491478-365205
X-HE-Meta: U2FsdGVkX195GE1zLT7FXatfSca9krudtFl4rLmuQhX2JQRrUhFfwgGcXO6HBD4X0bta7M+2ERyArAQcbgQlnMJBKTO3R0k/VmD/FxClWrve9wKbK88LL/TgOz3nt48Nyk/u9JOdmqMgsr+ta3J6Q8I9HaPGRiT1LlPP0Ahdl1Wj/DEsIb/7Nobi8kQjiUHHRJXRFJmX0sdrKnShuDlsOIEvnV0zOGZdkXZQCxeGFbszYih0Zfp4KF5I9cPSFmkWUkfM4OVLBQaVcLLkPyuLRrtSyaKKXSS0cQBnl/sV+KLWKTwPnuwiw8DQZ9JSP3oLFT7G929EChvs0rvisAKsiZtqKBJPNozMAOf59FSEIC4VjtUljxNxFn8ZG3ONlstbLHOVMEoC2tZX+/vvJphe9QxyQjxGjU0gjgwJ3SyBP9v6f+NqhzJGybTBsmQL//I4p6uWd27Y9mGuIFClaUzWrokeior9QrURn5X9SW7HhXJIa/R2/sSQjCGanzjx9SlrdVQvQZODqRyub4WT4SghMce7wqoZX4OHS82/bjJN3ryBW0eMwgY1h/yqxodr10rudcBhqgqLltvayqcroTL/Jt8QfoCywenO4fsgqfF0ywf+T+hhyDRL1WfWO/aJpIe046x9FPwsPobVpBhPeCwbrBzXJEMCRRoQ4ZL2yGJqyg/7QXHlD0beSYj0VcurGhDiL9wfzZcD5QKOg3qHcPX5wYDvrQlc+GRVZ8XtpDSRfhUa/sG4SRRxr7EY4lFIjKsJ6ixWG1De/w9ylF7/syOercbclJvFFwqLa8csF7rRR4ytVXmRN0oLfY+KZ/cFWKsmEynT+JcdUC4nwBOMmQyyYiV8FJrMVf+zNW+WRyEwf7hhZ3c3BpOoQfDstPVhQrNKETbQ6JqRg4TIcGBzgPhfOYFGTWy9G3DQ9DksM44PF1O9TzStQFO7yTc+mHOkk5fUCG4mHb3FeXqR0PTXjt5
 lZmm+13L
 6YNsAnKR4azHdhLLIoYaC0NwMTuQKuqx8FaDvNY/kR3wImqHO/izmMns0vG6Bm0sQ5TKiz9ocAZ5c8eYHNGpmH8qPzyY8awZlgDH45Xcjf+xfl2egEEQEH0iO+DwaIFKvnFRFUXvT8JegG2fz7USuQvGOliQzJO2+7wy7bzUWOZfsImS//xpqsuvRI0280KkMuYhy4GFbfHkXa2ApKhPXZfAChdielWYSYjeUQX6Q6L3TGDOLK2dJX5jeKuliZh2B4r2MYSF2AxJ6VNhVed+45OKU+mqeAjI/1MtA3K2YfuMZeOL52aFT0o9xFxNHXBqNYhJDUHSIyDej631SESMzkGsFALfDMUWLiZVn5tD3wgGfk6/8T+bL6Wv2/jMP/TikrcoogmA28RwM11BcONEogQDFLilJiL0HTWX4ZCBukthc2TMrqHBm3x2+frU27QVlFUpESv6BEVVpdmcLHnLryOT9RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 03:28:19AM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 24, 2026 at 03:19:36AM +0200, Jarkko Sakkinen wrote:
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
> > I played on patching systemd and userns_set_idmap() alone does already
> > a lot of good. I'm figuring out userland_open() integration next.
> > 
> > For the test implementation I probe the opcode's and dependening on that
                                            ~~~~~~~~
					    syscalls

> > use either "userland path" or "fallback path".
> > 
> > This auto-probing is done so that I can commit the patches to my kernel
> > test harness, which already has systemd, and try them out when built
> > against userland-enabled kernel (via LINUX_OVERRIDE_SRCDIR):
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/?h=main
> > 
> > The project builds a hybrid ISO, which is a bootable bootc/composefs
> > based operating system, and has toolbx bundled i.e., a reasonable test
> > environment for all of this. It is also device-installable via "npx
> > @puu/install"
> > 
> > I had to level the harness up a lot so that I could realistically test
> > lockdown-hibernate but it is is also pretty good emulation environment
> > for any possible container features.
> 
> Kernel is ukified and systemd-boot is used as the boot loader i.e., for
> kernel testing purposes corresponds to something like Silverblue except
> not using GRUB.

Experimental systemd patches:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/commit/?h=main&id=e4d6b15da3376ad09c0c575cedf467f69db32a52

The patches are layered per syscall feature:

- 1-5: userns_set_idmap
- 6-10: userland_open()

Virtual device would add path/mount complexity and generally dependency
to mounts i.e., I think it was an awful idea. At least initially this
feels fairly lean way of doing container things now that I've trialed
systemd-nspawn a bit.

I'll update the patches over time.

Br, Jarkko

