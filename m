Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45238606A330
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 08:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k1QFahsn
Received: by kanga.kvack.org (Postfix)
	id 58B4D6B064F; Tue, 24 Nov 2026 03:59:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561BC6B0651; Tue, 24 Nov 2026 03:59:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4515B6B0652; Tue, 24 Nov 2026 03:59:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A23B6B064F
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:59:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 97A2CC04D7
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:59:02 +0000 (UTC)
X-FDA: 85469412924.26.8AF69D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDF171A000B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:59:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k1QFahsn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795510741;
	b=RzopyurBVz/nERqf/P3GKvBGe6Nlfvm+v3jtbheTH5FoHeil/2/PWGVOGKnSYeEHQWST0N
	bIU0iykw/ME1XvcTbbYtW6+61LGm2gmIAf9NqH27aY1+iGeA+oZMGsyEeG+SLcp+r776Jw
	u+yQvSXpmzmu9Fvn7Z320BY/6KWcNDA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795510741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iYjv7RbotbqaHt7QdXT/8Tg8XeFQ6Uk7hTPrb5SAdJ8=;
	b=RRF/Ro+kc5IIRkJ1Df6T50ZjSIOTekO4hk/6WLUq/tVf40lZD7nHKvqrUZxF1fNaQT4/wr
	CAMoMNcmj31funB6HYJUN5tpPn+lXMX4XHxR6cu+XedKvD+y2KF2eXa5KP5PnaJbm8CP8r
	7xeWBRjVZz/83ZTu4NnGDWoy625slwA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k1QFahsn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 36F5B437F6;
	Tue, 24 Nov 2026 08:59:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DE6741F000C0;
	Tue, 24 Nov 2026 08:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795510739;
	bh=iYjv7RbotbqaHt7QdXT/8Tg8XeFQ6Uk7hTPrb5SAdJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k1QFahsnF0x+zCcltI5RHNJkWBpdEzrqZsbILpvtucLNDMLYBfD6HWPxRRuOpcHVm
	 B66SoPYuvfdPFugWs2E1SoH2Vokq28QQ9oQQ7MtJ8nyM0BJfp6WotjqfE56EijnxfU
	 NP8mgmGthJgV7XbUfHSEev5bMps1Q0zcY5GY2p1n0R7ZrwysvhdXu5vXlcCgDkx+Uo
	 MYOmOIgF8uCyWYV0/QGGjTFZkVnF4jMMv7qpzw3G1Etf56xsKLlv1wUVPQD1P6epM9
	 CHd6CiLmUEwl567ey9CMCYt2Fjs9101x/9q2KbVqhb2F3stKSmENWpqGOf4572Dj4R
	 LIUH5hhlX0zOw==
Date: Tue, 24 Nov 2026 10:58:55 +0200
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
Message-ID: <awVRz8XC54nfevtW@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awTmJIErjasO4lqq@kernel.org>
 <awToL2PFNKVgIfqs@kernel.org>
 <awUGkYoyDXp4P5LJ@kernel.org>
 <awULfmZR-pESj2EC@kernel.org>
 <awVInf04kGC0uZZo@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awVInf04kGC0uZZo@kernel.org>
X-Stat-Signature: 1jktznsscgouxq1nq9qjines84wgh7i1
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: EDF171A000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1795510740-28261
X-HE-Meta: U2FsdGVkX1+p25IJWzCE6CSzV/DUJ1F95DiNUS9017A9ORA55ySQj+jjPN0kVvixyA4ju39ENLpltN/GUWm1h1GLpVMqT3LCy/QAQ9Mn11jXepe8cLRk6FGTr/7i55fdtqx96AlWU0iT2Pu2Wj2dhN8nsU8m/x9cg+v7tkyGEThhmSR70Cqkiz50B9i0aMGnvOeJ1RuWeQ2N+LnlEGJq8JjIXNrZc/DZF1AWSqkGD9FeiPGLetkKrKyKgtCR5w9nKn8hRYGWJcJ4itOnIZ0sTc8C/qKjzcOzbFw4BxXhUd2dQb4KfJzAVklbs00xTLRqC9n3KDzELGXglSbsg4Jg/cI8seswalxbz5lf9kL2zxpHVqoPvJvkoSVG5CRs8O9VvBkul/R9StaOrDwKdkj1TEZiuaitA4xbTUPjf/zz7cZY9vzanL51wNW9pVXsImoEyuqlz5r3GoQZVUo8pYLMMF2RGlBsmzj960xzcnvMuBVnkSzBNI3ktH8ZQjDY74XFM8VcrZPlZ1jTH1w1+SjFW1eqSucyPNoo1mC4QdEpfKAq4CsY22gQyEOLny14oKUdDhT05FZT7RUtxzrYu1Fm29G4pCr04kAaZEL91Hadlo3B0wFBQevTGted4edi9E4nic4bmv6jK0p22iTmJmOF5TsHzs9PUmlYOzbA0KJNA7hNfxJFLZI/2XodbVy7faEID46EuAie2esM1BNpwbLrdA1UxgaWEcmR1NK0RGAzmSqfZUNuo1IduGyrK01//DLfqvKXt9FxGT4L+YH6sphY4szo8wiqIO8U4aFW0+Zfit/8uKiHRTi0+lqzIVROROk5xKhfzm2rCB2kKA70Jfb7p44MHupj8qUIAqBv1EE2n1C9E0z3ZZ6uYlVDE+QK/vPniWqxh5ng54/xlKoySZfneB+L6CvyJK/75n8ZlP1Vl1h+B0/JrdOFbfd5eIr7HRQWuW7vyuQD0pYoXonLg9T
 ItVcjfhU
 pVgqsAw8I4N7VeTZdxq2SF+IhQEQV8PMRMS9RtJmjHQsNfVv2uEDVTtyzZl3ix/wYRaqv5fosibUjoYATXfnKBL173Xayev5dJMskTsHEU5aUXAv4VCqR4XJFkZnhKBMYDm7zr6xfkwAmIRENLA5IQdywYeHJh5fed5MGiLcjPDW/74X2WZdW7KuIIcL+C/6D+hlCboWZfTOgduw3qSMxelImY86Aj/mrN9YfZUU8EYy0lmOGTbJ15LIubtrEL+b9w2URiyDgz4QGVLVD3ZAmfLqosYqJdK+KRGA2Ch9xwSGuEzvIOf5pQUFLTiQ4yR9X4g/OQHuiCB5QOwFs6aPbU07DH6TqfJI6+JRoUySWJMai276vCHgUOPV1jRd+AGAl1q8wygynr7dCAtpp3r7J0Fz3hLwAVgZvHDIRoFD5+jYnNNMBBX4xRf/sx/c41lgT80IhtGBZPA02ruzRcSgP13xRyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 10:19:46AM +0200, Jarkko Sakkinen wrote:
> On Tue, Nov 24, 2026 at 05:58:58AM +0200, Jarkko Sakkinen wrote:
> > On Tue, Nov 24, 2026 at 05:37:58AM +0200, Jarkko Sakkinen wrote:
> > > On Tue, Nov 24, 2026 at 03:28:19AM +0200, Jarkko Sakkinen wrote:
> > > > On Tue, Nov 24, 2026 at 03:19:36AM +0200, Jarkko Sakkinen wrote:
> > > > > On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > > > > > SYSCALLS
> > > > > > ========
> > > > > > 
> > > > > > Two new system calls are proposed:
> > > > > > 
> > > > > > 1. userland_open(): open an opaque staircase-initialized container
> > > > > >    object (modeled on Intel SGX enclave initialization with separate
> > > > > >    build and live states) with no embryonic state, opting selected
> > > > > >    shared namespaces in via an allow-list instead of unshare semantics.
> > > > > > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> > > > > >    extents for a container user namespace in a single atomic system
> > > > > >    call.
> > > > > 
> > > > > I played on patching systemd and userns_set_idmap() alone does already
> > > > > a lot of good. I'm figuring out userland_open() integration next.
> > > > > 
> > > > > For the test implementation I probe the opcode's and dependening on that
> > >                                             ~~~~~~~~
> > > 					    syscalls
> > > 
> > > > > use either "userland path" or "fallback path".
> > > > > 
> > > > > This auto-probing is done so that I can commit the patches to my kernel
> > > > > test harness, which already has systemd, and try them out when built
> > > > > against userland-enabled kernel (via LINUX_OVERRIDE_SRCDIR):
> > > > > 
> > > > > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/?h=main
> > > > > 
> > > > > The project builds a hybrid ISO, which is a bootable bootc/composefs
> > > > > based operating system, and has toolbx bundled i.e., a reasonable test
> > > > > environment for all of this. It is also device-installable via "npx
> > > > > @puu/install"
> > > > > 
> > > > > I had to level the harness up a lot so that I could realistically test
> > > > > lockdown-hibernate but it is is also pretty good emulation environment
> > > > > for any possible container features.
> > > > 
> > > > Kernel is ukified and systemd-boot is used as the boot loader i.e., for
> > > > kernel testing purposes corresponds to something like Silverblue except
> > > > not using GRUB.
> > > 
> > > Experimental systemd patches:
> > > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/commit/?h=main&id=e4d6b15da3376ad09c0c575cedf467f69db32a52
> > > 
> > > The patches are layered per syscall feature:
> > > 
> > > - 1-5: userns_set_idmap
> > > - 6-10: userland_open()
> > > 
> > > Virtual device would add path/mount complexity and generally dependency
> > > to mounts i.e., I think it was an awful idea. At least initially this
> > > feels fairly lean way of doing container things now that I've trialed
> > > systemd-nspawn a bit.
> > > 
> > > I'll update the patches over time.
> > 
> > "userland_open" is just a name as I don't have anything better for the
> > time being (perhaps <something>fd() e.g., containerfd(), would work
> > better).
> 
> What I did at late 2025 was simply going through the old ML discussions
> for David's patches and addressed the remarks one by one. Then I
> improved the patch set bit further until other stuff came along, and I
> forgot the whole thing for some time.  Last week's burst was really
> unwritten todo list starting to remind about itself in flashbacks.
> 
> There's not much more in API sense to do except maybe syscall rename and
> associated prefixes in constants etc. My Git branch has additional fixes
> (e.g., more LSM plumbing) on top of this but they don't change the gist
> of this by any possible way so no new RFCs for the time being.
> 
> The most up to date version:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd.git/log/?h=vault

The key function to look up from here is spawn_userland_container():

	https://git.kernel.org/pub/scm/linux/kernel/git/jarkko/linux-tpmdd-test.git/tree/br2-external/patches/systemd/0010-nspawn-Start-containers-in-an-experimental-userland.patch?h=main

It demonstrates an initialization flow that ends up cleanly with
clone(). userland_share_host_ns() demonstrates the ioctl I added
previous week i.e., USERLAND_SHARE_NSFD, which is used to punch those
host namespaces that the guest actually needs. This is the allow-list
part, which is usually the favorable principle over deny-list.

Br, Jarkko

