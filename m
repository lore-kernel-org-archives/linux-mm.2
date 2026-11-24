Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56EB7606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 01:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MhiLjCcn
Received: by kanga.kvack.org (Postfix)
	id 43E536B05B0; Mon, 23 Nov 2026 20:28:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F0F36B05B1; Mon, 23 Nov 2026 20:28:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306A76B05B2; Mon, 23 Nov 2026 20:28:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDA3F6B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:28:21 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70F0E1C44EF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:28:21 +0000 (UTC)
X-FDA: 85468277202.02.0ACE52C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D3211180006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:28:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MhiLjCcn;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795483700;
	b=NvhtVdUPa10fuKRoMb1xk1mV7SmgbGrZj3ysbxhQQfaOr+9GAWgsKmMd6navLyP56QAEFC
	2S5O6Dgv6Y2dSS1YrFYqo41oG/uyKw1PQSy5yxkQHw/vI56SCbT8ScQ+On1faOw6Uzv6Fm
	/d+YXiQ4vgzUO4ynf5vB0uZnxy9HDgg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795483699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rR3LoSS/CnHxEjvm/yoRjwsCnx6t2+6QYn8uLZ0saD0=;
	b=kyZZ84cieHf3rAzYeU8jwK/U8BH2UET7DslcblewveU0W/InM+jcf5QCcR5Chglsw/XyHf
	Dy0TogSzPJPS/21Ztx0EmvTp6pFAPVD78eVLVwyG+HfGrmQ183JFZkBYOtgXPAmFpMi3S+
	QXAvWTX5XNqXQiAiP6qlzNUJlKYTUo8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MhiLjCcn;
	spf=pass (imf16.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 49B8460D44;
	Tue, 24 Nov 2026 01:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5186A1F000C4;
	Tue, 24 Nov 2026 01:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795483699;
	bh=rR3LoSS/CnHxEjvm/yoRjwsCnx6t2+6QYn8uLZ0saD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=MhiLjCcnHp95T7HuSLpsxG3/eXdkRaSIRPl4sr8N1U5eHtYO0TTNagpfp9FvmkyLY
	 poVwlubetpPDij/MC3k1nK/9BUf5UjQy69XH3Y/lHA+UmTSurdUcg8YSSYFXRbKlTD
	 jcbh79HqiPBRN4crGCI4oilTmV8umW0Wa4zCjU7Akv5fnudGwO1FhYCxPW8ulDClTP
	 6fMW/Dcsm2g3xZssBeJt/iJjwdDF3L/cHmN6TjWY3Hoes81OGCWTlNSXOZmWrEz+K0
	 9hcKPTnRxdqfj1RyZC5Qoh8kkYy8ExXwELZeyHET1akIkufbVIPoo5520mFH4jAWpG
	 gH3wNwAHcfRDA==
Date: Tue, 24 Nov 2026 03:28:15 +0200
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
Message-ID: <awToL2PFNKVgIfqs@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awTmJIErjasO4lqq@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awTmJIErjasO4lqq@kernel.org>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D3211180006
X-Stat-Signature: m5n6armi899cpbo7mhe5jp7gajg8icmg
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795483699-189598
X-HE-Meta: U2FsdGVkX1+/EsoYWBTjfq84A7USB7sVaNcd1dVklzTF+hYbKAUtWPavllW8w+1lDvrKmnJB6Xrmzsdl7o8mBrRAvGnhLFS++p0nARti9zCaMgeAtEy72N0vWz68BnugM5UbCd+ufLURTS5wdD2OWFBb4OJtLw+9O4NnWMXuHyIiTBwlbjABCQcmY8b4Ypy6gdgj/RzWWjIbPX49LXc2vq4Tq7WcbBGNpas+zUefCjZjodxWv6KGvLdJvt8PGNSLRbDSu2+ft4512z3d59/u/bR5c1mdnhFGBBsHuxiD+NdOOEartRhT2JwwIOL/47Wq8LYq+hNztERP7+gsGUj4BT7k6aIl3LCSbjO1HzW0xAe03mCHiXhfg0aoX0h7+fSoJwAfphYmVAdLLpA3/fuqvTwpWdCIvQ7p75rpv5qcBR/FmCOllONr7qW1pLxCSMv3+wT0ZyLm7To9drsQ5Ov4EJO6Fb/LFcQRNZ3AcoyqH9Kp9qmHMkgnNh1oo8DkiKQ+jYqfCAC9WGeyKFPKj6S9BH36LBpj7esA2CsLG4NST40vjsfyXlzvi8/GDV5ywFQYj9ks8RHPMQtcMa5qPW1ZHw7D0mKkpRrtWRcqifDsbxMvCPd5xJgp0IPNLjdonBvjJLtuCaCrru2eLBrdKJsDPPWkzL8AqQLn2ob6tZagtyc/vWJsBZ/PnFZnYZQz0T/+U0FlA8myrCbc9CDPXskzTt9d3OMGLPOhs6IeZ0aFIXyijgzCtVnCY6NSh6TujO7uW4odjmlAf6nXcureLsYumWOMUpokbzv1rNXHaDnpzwiE2Mj7SastdvIw4Qq4eQPiD4ub2TI/Sx6cYbVS7tIPhkYceI68qM2Q4KOkjjHJgf/obGOLRYqrkqpCf/2NZnDZbenKrEAaW8cQVKe01mnTJmQvn973kytFaARMCYOntjZwGBRVJfedarS8p1zQoUE03mW3kI1VSSRN2F6+jEv
 yPsPHgsu
 TcV+lY4ndgbiuPHeTI9nWlLqkwH+JbHT0n/2dyJbhMmegt5t2gLNd033VD3vh92sUuDa90acLdU2EvofRncVfkl1t/uWHUWGaXpNeFXq8a51Sbma1i4Y2SkQSH6KVYuZWhMVng2F4yRTtV+Df6DY2M6DO58LIBlmpWBrr0zT099uQSQj5WVgrx79MqIkg8nVZK8G4qCxXI0qwFsCQ4d+fNQwqyrBqDPAYy8l0IHN1psbFNnMGuV/llNlm3CiifQwpUJqmFbW4N5w30geNGkSEAK0+TvOUJucZolam0uu3chNXEu556Au0EHfz2dUHon27ueCIFWYdW9DT2Hx5CxW1TCQVoRPgnMWXu8UugzGGxgrqVDpMEcJxTSKwRsky5J19TujwKMVlf0hHugAGlckVLvYl6lzVBFnpfMtdcwkuv9tWjWuQ2/v5axOtK4t0kNvu2fQkTs/pSkZLPymvhsPmxb95pw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 03:19:36AM +0200, Jarkko Sakkinen wrote:
> On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > SYSCALLS
> > ========
> > 
> > Two new system calls are proposed:
> > 
> > 1. userland_open(): open an opaque staircase-initialized container
> >    object (modeled on Intel SGX enclave initialization with separate
> >    build and live states) with no embryonic state, opting selected
> >    shared namespaces in via an allow-list instead of unshare semantics.
> > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> >    extents for a container user namespace in a single atomic system
> >    call.
> 
> I played on patching systemd and userns_set_idmap() alone does already
> a lot of good. I'm figuring out userland_open() integration next.
> 
> For the test implementation I probe the opcode's and dependening on that
> use either "userland path" or "fallback path".
> 
> This auto-probing is done so that I can commit the patches to my kernel
> test harness, which already has systemd, and try them out when built
> against userland-enabled kernel (via LINUX_OVERRIDE_SRCDIR):
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/?h=main
> 
> The project builds a hybrid ISO, which is a bootable bootc/composefs
> based operating system, and has toolbx bundled i.e., a reasonable test
> environment for all of this. It is also device-installable via "npx
> @puu/install"
> 
> I had to level the harness up a lot so that I could realistically test
> lockdown-hibernate but it is is also pretty good emulation environment
> for any possible container features.

Kernel is ukified and systemd-boot is used as the boot loader i.e., for
kernel testing purposes corresponds to something like Silverblue except
not using GRUB.

Br, Jarkko

