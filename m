Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C84BF606A32D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=e3O83Rok
Received: by kanga.kvack.org (Postfix)
	id CA8CC6B0635; Tue, 24 Nov 2026 03:19:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C80406B0637; Tue, 24 Nov 2026 03:19:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD856B0638; Tue, 24 Nov 2026 03:19:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88A436B0635
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:19:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3EAA4160ABD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:19:48 +0000 (UTC)
X-FDA: 85469314056.13.798D96D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9D6518000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:19:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3O83Rok;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795508386;
	b=e+VFbugwQWMTooHim7ReC3Xt8HawtgS/vm9rIhqOBpbHBfg6WXsnaIJBKBSmAGV1yBb+6m
	ElW1JUek1hC0QfHPMRhwKD3d+q39vOUOx2+Aya3kc/XZITYSYuBuEhAbyvXNbZWsb5ksTB
	NuHPVLPiTnHK4hfCeAKAaQkjXCxwILo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795508386;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9abjPcthtIyY+MMEtQrTLzJvidQaqZjoo58q53HUoc=;
	b=2hbBQm/Te6aDYPR8fKfYcPrpjvFeXn2ZgRMNq8j22Lw4TmxvCNini/9KxSKy92FQRFYpWW
	uQeAvjrcbObJbtMhFnYQ5Flfjej1kQsnPoGbgVOnJ8+F+tXSNehzI9p+Uxn7SUnTLGsYOp
	pwTWn+eRSTgeNUuhE4f33lFlYgmROpQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e3O83Rok;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 306A961F32;
	Tue, 24 Nov 2026 08:19:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CDE391F000CA;
	Tue, 24 Nov 2026 08:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795508385;
	bh=E9abjPcthtIyY+MMEtQrTLzJvidQaqZjoo58q53HUoc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e3O83RokhWRQvZwd1DE9oTpgGvx6IqeB+fzR6eFpiyChO2W7NR7MJQGtBcoiAgXR8
	 Wn3CnXsXOg60lEc79jyvbWLaENSpj7epk3SWKZSxsfG/TzzsD96HViD8sVrUPvjHiI
	 Uu3bfmaxPEXAcEMAc1H7CfoY+IZGDYCSroILEOWmGmLpFtMqe71KxLTvROwTUBBEjK
	 ZVvaTxYXqgEAgFgyKpJXSMDUSEV3VLF1gE9e9SbjHCr8Ql87moA1+n2j36wPzWax7i
	 zLVJg4VgAJDdKWFmBmBJnIeOjxrS95srOseTu7pz6bMmjmadSVRv7TQ8qDqTHAkRSB
	 BmAIIyq5qxSzQ==
Date: Tue, 24 Nov 2026 10:19:41 +0200
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
Message-ID: <awVInf04kGC0uZZo@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awTmJIErjasO4lqq@kernel.org>
 <awToL2PFNKVgIfqs@kernel.org>
 <awUGkYoyDXp4P5LJ@kernel.org>
 <awULfmZR-pESj2EC@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awULfmZR-pESj2EC@kernel.org>
X-Rspamd-Queue-Id: 9D6518000B
X-Stat-Signature: b4ic4zisz3yctmgzmb91opjxszagzm8r
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795508386-639173
X-HE-Meta: U2FsdGVkX1/Z0gP8twL59mF28orz/AZgygKsUKL0tuRrCBLKTTekuvC4YliEw61NgC81qT1IledyHw40eQCH453TBlazdqnCwtTf1qaKX4Rqe0ShK5DD4AzlfwLNSEq3rh2vIsnfHUwOayg/NydcCCKCg5AU+ZyA3rlc5Saju2pTO1DFISFK1Azvl/jgKaQyhPsSDhPJMkPqflbyfYrxbAvd0WkwrpcHLiqgg/xKtWHGyq8PK0wxV4KO5Sb60Bm/BSODXYgtOBvKuD1O0Jhjp8Hq85QWWCLvRulFeq/T8B3uvIlas40fISBzTJLsGxlvKfJflnpwSGZBXURG4SIleq/nswOqgz2Kv3TMrUAfu3aSwH7g4yDgIxNGwQMzaq7Vp+NcJ2bihLRmLIVPw3etbyCTcWMKD15y4nFfuWkAKymLrizfCdHlRULrlXWcmyDWMhDQultLhii6m7VRppsWFQfqlAacYOcUCUn0nPoogVhunuFhfcT3oUiWIlNNqBhocEJs0Ri9aQzXYXNtPB5zac6b1iOs+WRpmBna1g3cqvdrssEvaejJtwN46Tt6zin0J/eQf8voXLlRDyBuA4bNGvLUKDuxGTM+AKJFCNu62Z1u1Dskkze3WB8OZsmeE/l4n+DsYaKkN3g9q4dJWA//e7zzFydrCBhfOCwW40uUoQCzP2f08h8bPk4pj4KtnWUpexNlHoES53TzW7gyTigYzYRM/LrTl2WdlKKpNysiA4VYMAB2OptALlL+exPPSAp2xxqa5kjWTgytDh2UdI2fDsxnUuhkT3djYey9WAnHZUOy3BMGSHc0GHRgmLuwcsDDkwN2pWUWtZI61PDmPxOz3Mgx0ti+Q22I8NNE41lTltlobibYI1VR52hIhw7fu5A+QsKpzD8em4mkd9BIXHJWpp6cvXpXs5ieXj7DCOmplz56T+VjT4aCm3wcI20CjgJLWJ2Zb7+pqsZ5GlTRL9q
 pBfap1xM
 FxNYQDSV+eWuTb37MLLE+vyTt2E20h0lgGxoWmfNEscltR0QRJF/2rGTp7iCtCU+/4mR1pzxPtmCP36Ft7qJ3s1b/ScHngLEP5xF/mI3lizlIP/wDy4bjrg+HOF0wl3G6zsSPFoQlCh712nO1Heo7qyNaVGNg2pv7FVj0DEax07Jlki4O6+sERyjHB0kvsJ0NyqOs0pte+Xa+dXRGc2atftdS2r9vgT+Irj21a3VEft0FTMrfN6eaH365gFAi+Nfq2BBul0asShbFIs/eyX5CC6+1WiItNyTW3fKhh9U5WqVnspDGzEWXSGqPY3+k/cpf7Z4+WZud99qgtWuv52z+UwpzSjNb+FPmkuhS8tQBgGRU2NFrlI50AyzSBM+HXRMdjtq5EL3i+8ycHAaTmp3QfJrh9v6IFp5G733jGPUASQp4eYtvo7QtfowQVPGRM4ObhGCjD1/N0CFh3lX0gR0oGBJomw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 05:58:58AM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 24, 2026 at 05:37:58AM +0200, Jarkko Sakkinen wrote:
> > On Tue, Nov 24, 2026 at 03:28:19AM +0200, Jarkko Sakkinen wrote:
> > > On Tue, Nov 24, 2026 at 03:19:36AM +0200, Jarkko Sakkinen wrote:
> > > > On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > > > > SYSCALLS
> > > > > ========
> > > > > 
> > > > > Two new system calls are proposed:
> > > > > 
> > > > > 1. userland_open(): open an opaque staircase-initialized container
> > > > >    object (modeled on Intel SGX enclave initialization with separate
> > > > >    build and live states) with no embryonic state, opting selected
> > > > >    shared namespaces in via an allow-list instead of unshare semantics.
> > > > > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> > > > >    extents for a container user namespace in a single atomic system
> > > > >    call.
> > > > 
> > > > I played on patching systemd and userns_set_idmap() alone does already
> > > > a lot of good. I'm figuring out userland_open() integration next.
> > > > 
> > > > For the test implementation I probe the opcode's and dependening on that
> >                                             ~~~~~~~~
> > 					    syscalls
> > 
> > > > use either "userland path" or "fallback path".
> > > > 
> > > > This auto-probing is done so that I can commit the patches to my kernel
> > > > test harness, which already has systemd, and try them out when built
> > > > against userland-enabled kernel (via LINUX_OVERRIDE_SRCDIR):
> > > > 
> > > > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/?h=main
> > > > 
> > > > The project builds a hybrid ISO, which is a bootable bootc/composefs
> > > > based operating system, and has toolbx bundled i.e., a reasonable test
> > > > environment for all of this. It is also device-installable via "npx
> > > > @puu/install"
> > > > 
> > > > I had to level the harness up a lot so that I could realistically test
> > > > lockdown-hibernate but it is is also pretty good emulation environment
> > > > for any possible container features.
> > > 
> > > Kernel is ukified and systemd-boot is used as the boot loader i.e., for
> > > kernel testing purposes corresponds to something like Silverblue except
> > > not using GRUB.
> > 
> > Experimental systemd patches:
> > 
> > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/commit/?h=main&id=e4d6b15da3376ad09c0c575cedf467f69db32a52
> > 
> > The patches are layered per syscall feature:
> > 
> > - 1-5: userns_set_idmap
> > - 6-10: userland_open()
> > 
> > Virtual device would add path/mount complexity and generally dependency
> > to mounts i.e., I think it was an awful idea. At least initially this
> > feels fairly lean way of doing container things now that I've trialed
> > systemd-nspawn a bit.
> > 
> > I'll update the patches over time.
> 
> "userland_open" is just a name as I don't have anything better for the
> time being (perhaps <something>fd() e.g., containerfd(), would work
> better).

What I did at late 2025 was simply going through the old ML discussions
for David's patches and addressed the remarks one by one. Then I
improved the patch set bit further until other stuff came along, and I
forgot the whole thing for some time.  Last week's burst was really
unwritten todo list starting to remind about itself in flashbacks.

There's not much more in API sense to do except maybe syscall rename and
associated prefixes in constants etc. My Git branch has additional fixes
(e.g., more LSM plumbing) on top of this but they don't change the gist
of this by any possible way so no new RFCs for the time being.

The most up to date version:

https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=vault

Br, Jarkko



