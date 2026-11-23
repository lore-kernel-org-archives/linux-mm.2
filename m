Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9808F606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 00:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XTTYuAtT
Received: by kanga.kvack.org (Postfix)
	id A8EBE6B05B3; Sun, 22 Nov 2026 19:26:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3FB76B05B4; Sun, 22 Nov 2026 19:26:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E996B05B5; Sun, 22 Nov 2026 19:26:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BEF56B05B3
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:26:17 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8F5B5A8372
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:26:16 +0000 (UTC)
X-FDA: 85464491952.12.35D7BB0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0C193120003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:26:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XTTYuAtT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795393575;
	b=PA4pxnEdBXV4JpnSHRNPqCzX+2D3nVkXaODGNBhokgHtzkM53rwgo8eiB/51m9MzoObMYX
	b3dSa9Q5iujLwJKap1yfakJ6AZ5iXJNOe1itZ0hiqVvZbajuXdONhnBYVKVlCdybroMd/G
	AmcKfQzMnJEOSSyZWRw1hbE/cs0iYNw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795393575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Np7fZSYURVKo0ykLKnKN/e1CFyZ5GmziW7UTv6oqkBg=;
	b=UCcl+e+Im6Mq9SI1AnHBiPOg3fcDnzZLTh2x0kt8r77iRI5GJ2GJq3H1xYyc4V62IVh48E
	dwUI3Fv6VgElXToMlaepcXZnxRnMMzrmlX+h1QQ+t5S/JkAeVvDVZ8Sh7cbKGYFrfGWzn0
	A1hrlcivZHMF3Gccs6gQJuTR8FtOa7U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XTTYuAtT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of jarkko@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id 7E90C60A9F;
	Mon, 23 Nov 2026 00:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 77F411F000C6;
	Mon, 23 Nov 2026 00:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795393574;
	bh=Np7fZSYURVKo0ykLKnKN/e1CFyZ5GmziW7UTv6oqkBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XTTYuAtTfAlg0WH9XZNPNM7S+HLBop3wyxrt6AZb8BiQ/Gcs79kUj59MMdnE7zjKQ
	 6xk0zPvaGdlG8o9ZUMGLAaOiaoDh4dLG6WNkRYPhuhQSyEsvPBz3KMQjuS6m7xd5dG
	 Ot9O95tbcPRy9IHFMgYR0M5uFEZsIn+69FEAQlQR3rWR6ymXF88kwRbDdIo+Jw4lgY
	 YKAHH8A25VOQvWrywy5q8chM2R+ortwz1L4AYTL89LZ/Swh1LO/3fuwj1dPvoYQS1e
	 rxcdFPD4rGTTlycsU6r7F/Z5zD9ej6TCW+7qcXWzVmur1oME5eDf3FDMxcpULj0bY5
	 LbOIMT1N38+0Q==
Date: Mon, 23 Nov 2026 02:26:10 +0200
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
Message-ID: <awOIIuoNvNLZ_scF@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
 <awOEa303zNUDrzA3@kernel.org>
 <awOFGIWekH9-vlhM@kernel.org>
 <awOHVCpztLQv4Uwv@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awOHVCpztLQv4Uwv@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0C193120003
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: gzdwaraa1j55ezd1oa1r75ubk9nu7w3d
X-HE-Tag: 1795393574-670295
X-HE-Meta: U2FsdGVkX19S7ndlCIcPTc1iD0+MRc+swbuk3MGAv4zMUO+4hXQzGZQDxAxUHnIgo9tJyXpw1n55tfqDjb3NoRCOiQaPbGoJTiP++RXKdnlZBqTp1ocMf3VGxbPxcsLjK0HqltgZbWYJUheLvwkakIsFhZVf3hqeZI7+I8rF6gPxOQQy4BSiR3NrEUGXL4SpChFB7jH5+m+89yrQu6sZJpZPnNPnvZevEGsXNMqCkhTODaUCWL2wEDeYHmsBY077FMW9Ia1R9JG2HzoUBVxZGVDBOeKuXjidYm7wkiQ8CQ9K+oCkSST1kznc3KefcsWA9e8AdcJ79Ok1ZroBxVlh0depg1Vixk3BrDIamtJVygtSJJcwhKt8c7LIVpDW48g4bBc53y5SP4Ggj4aTkgLzRN0cDdXbe7rOQSrWFXlDfmAu16Sp+g9MdDzt3CL+F1u8H8RFkwQyOdnSyhZ2V2wlybTjH/59krtCV+lBYB5OC+Zq3Sg5OHbQK7uPp31TzmDWgzvNxDYqftWeocq3hiP1GuSgyI8pyvXNCKFdOq6r/PvCpgL1LKZzZiHKvUWSNqVsQhOPZWHnOSJ/fP0fqBjvStMqQ2ORBcW4zQsZ+XFZlok9CxrXV5cBPqD34Jcvtp7c83oUSDklgcIJ1nji20kBCdS/BZU9bcusCq0UYCrp/rvcaUnJiHuq2s0Gn22wSmVs1hmhX+fUolI9h5o3uHa5i1LtEVIbJwssorDLNM0IGS3ExQDVxRuaLCkVy78JyKgHCoFKwKrmqdz1qtIX9/HZ0EawfmE5qUWf03YS/rKClfbEw47Vp7TmpmnjISUAmbN9J2fW/Qw+gmzLRMh89iBj3+zwUT5HPx/QZUZ6MR2zfYgmGhmffDgWK7BWkSw1gpfSjswZkfLNTVVeE3rtw7ve8xoINBdXRhtUN92xOX7kxets9mWJq06hZ2g80boxx6JGP0KAFT7T9dkQwDJZ81B
 a3ZpWLeG
 +xyyCFfk4+5Z/4SOpXHtHFIZIyI6PHZphoZ4tDy9scdaJIZhkR8QbSEVSqPjScUUKMadLXmkDFFyN4T0KfLuzHwpQmR2y/dA/eJ15+pI7vzFQCndoDG+qJ3MYVWdvDzLxSvaF1ehedz2EoPELlvOUj9M42qbDvVWzMnV4n6uZQkd83aFVX8GI3NQnQlWMSB4RCA0fSUUpmOxkMo2aAyb9PWNvzgJvEhGBgUUf9rT2VQTW2bFmg17jPVDQdiWvCmEQUxp6SMVA6SexQ9aJOmTmKSLZZMqfh2kk7zH58eYp7UKqs9+R3aWsTsSU60ATbamIgiz9hBhgXsDUV5IDSHua48q3Unlil0oh2P/BdJHqSWY6wFAkPSKoxL9FNVbVQpG2jyP+7WqHDhashN32eLkNWArB2XqO20gB7f0w+pHZ54up+WF7tQi7tbYOgWBPg3l0f99+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 02:22:49AM +0200, Jarkko Sakkinen wrote:
> On Mon, Nov 23, 2026 at 02:13:16AM +0200, Jarkko Sakkinen wrote:
> > On Mon, Nov 23, 2026 at 02:10:23AM +0200, Jarkko Sakkinen wrote:
> > > On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> > > > SYSCALLS
> > > > ========
> > > > 
> > > > Two new system calls are proposed:
> > > > 
> > > > 1. userland_open(): open an opaque staircase-initialized container
> > > >    object (modeled on Intel SGX enclave initialization with separate
> > > >    build and live states) with no embryonic state, opting selected
> > > >    shared namespaces in via an allow-list instead of unshare semantics.
> > > > 2. userns_set_idmap(): configure all UID, GID, and project ID map
> > > >    extents for a container user namespace in a single atomic system
> > > >    call.
> > > 
> > > Andy, perhaps a bit too far of the box idea but I'll just throw this out.
> > > 
> > > An alternative to userland_open() would a file e.g., virtual device
> > > file, and necessary wiring for open().
> > > 
> > > Then the added syscall surface would reduce only to userns_set_idmap(),
> > > and it adds more robustness to access control (e.g. who can create
> > > containers).
> > > 
> > > What do you think of this?
> > 
> > Also, easy way to detect the feature. This does make sense to me.
> 
> This as a side-effect would enable LKM compilation, and reorganization
> of the beef of the core feature as a driver. Not sure what would be
> the best location for the driver tho, perhaps just drivers/userland.
> 
> I.e., full decoupling from the syscalls.

Right, and LKMs are great for live patching. This has enough quantative
weight.

Br, Jarkko

