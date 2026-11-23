Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8435A606A31D
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 00:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aIBalDqF
Received: by kanga.kvack.org (Postfix)
	id 603F86B00EF; Sun, 22 Nov 2026 19:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B5376B05B0; Sun, 22 Nov 2026 19:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47FCE6B05B1; Sun, 22 Nov 2026 19:10:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15A636B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:10:26 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4A36AC079C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:10:26 +0000 (UTC)
X-FDA: 85464452052.05.6F3CCAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id AA97116000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:10:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIBalDqF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795392624;
	b=sjYDAg+vGDbtwV9Vwik0OXXgCtn4+LA8L2RjjyTP0df1U1QqQRUNMA8W72UtncGUnDEOec
	BYW5WIb/H7Rf0ZJWM9WP4157zYwGJsTpguznqAPwURF9AKffNmMF70aVr8ajU31FY24xAY
	VOeGUOK3gbuI+K7kJ8jp/q3CTpFnbb4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795392624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVqAgRNp/806Eu6FhKubSIrbLTDfdOK4rCR11mJ3soA=;
	b=MqCUFw9a1aK10B64lb7pgKCXVhr8AipeVc7Qa7l9IDgV0q4Edq8OIzBalarL2CvhDEpq7K
	g7erAT2nfDgQ80D5+C0rKSZYwq3aDJ1OCF7ZrR3igyWZLHbZnsrhgliGDbZijKGT1E5dfb
	fw2dcIzZuXsHVwrStSMxBabsuRnTMbQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aIBalDqF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id ACBBF40A9B;
	Mon, 23 Nov 2026 00:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 574BA1F000C0;
	Mon, 23 Nov 2026 00:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795392623;
	bh=ZVqAgRNp/806Eu6FhKubSIrbLTDfdOK4rCR11mJ3soA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=aIBalDqFUyBaRSQx3VhqHqWOCy356DzFuoO1chw/cAmHvSXvAodD4MbvPpaj96fK0
	 7kG77OT80wpmVRWo8hA4UTxfYDOvNNQ+OPKjT8JIHjGfDyoxJ5mHA0oCR5MqNuJz12
	 sXnZ3AfTd+SHluWBc9scTS910r7uaKlFGTcD3VAMeNTD6CPRRb5C/uuEGDUYWLaxGO
	 4Xoz8L38hCpwtmo1Nups5A87P+5Uu+QzJzway5aRYJikhauRbI82OjUxnAql+Uzlxy
	 1vhRp2jijx/G6uOla6NeECNxbmKVss6aoH3MP/Y0bhy+w0it1R8Sn/KeH7uil/e+Q/
	 Vo6z9i9W8aI0Q==
Date: Mon, 23 Nov 2026 02:10:19 +0200
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
Message-ID: <awOEa303zNUDrzA3@kernel.org>
References: <20261122193539.3334213-1-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261122193539.3334213-1-jarkko@kernel.org>
X-Stat-Signature: rbebfiwurwukns1h4hpjm1b4tifkuepj
X-Rspam-User:
X-Rspamd-Queue-Id: AA97116000D
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795392624-546154
X-HE-Meta: U2FsdGVkX1/f6nk7ReTq8mQZ376QxANaCe7uHTHbOPlqT+OLszG2rHLLbESipAEki7duTx6TUQM1UM8Ws9bjg2i/HfaQ3A8MyjDDGNy07LLMpuaG9LSURuoGD+H1TpnXLSGikVuow1cb6+UY3L3H8QWYOg5uLUH44p3CmI6cizGhuwdpYiA0mYgMll6TCrtajSCaCUV7C7Q/f8f2uiIJm7YD/zuTNp1Zfv8bfgUivENpRu5Be8zvLSkOo5LJy7SfTEDcf0rh1WmaxiYWlsxsppkgzRa6NCA7097ASywxgyAGjfjL7l3iwaxD2j9D8uIk0pS27ZVw/IH86dEec+RZS3EyPCSsNtKp+rHFzIkAo0ox7szVMMqbpt1TbRWKMwg5NlRkSg9SCB9Z8iwD6fNmx4zJNxRyHbpdRKTEnBGtn2nK5IRziHQFJUoRFcCe67C9nWfmRsTRJ5y3QPSRC0pCEV2+7xnrSWLYOTEHp5Jxbh2j81GQ28wkERgMAOr2vKxmeDQR4w3xC5wxOrInnye+w3dEHIfr+Keqc0jx3v2VRvx8G8HL69HC9SVNRKn7+CnCYxK0eeQ/jgjSebo2QJ6HTdv6eMVKjgDrmeJxo98NimnhtAM4WZAxLmOQ+50krFscTah2kioWwBtiN+IcoIcdtKxa3sjHlAGxiQNCDvpXM4XPXCuX8LnRuVYyl3ebwptAwL2PJ2ZdzRGoLYMB6bPuuqedTwQFSocQS8QgFn5fi+VIIQ4j5TN+L1+kjzkfx1i7MyqVAg0Fk3mr4wk6BONnKALGEcEcTOf2DCDGgu/ezQUS9lj2JA8taSuUHXbELqTCnu2/KNjRzsHQDJ4a6tvzyNWjDZ6CCrXAZ/GpkqHINqqhI0RB892MvjF97KmHjyWWj75uUx4Z7NwxqIymgPoAfbb0bJZ9K3MBvhA639vYfO+q2ytZoHMB88Msc4QgKpOyyixRIPrWG9MRQGUyauH
 AGIRNoXR
 76YT2+CPpE6UVjal9oqkSc2HmwVlJTo9Z5dNGkcu4oSoGg++V3ojbZKhhP0V6T7RuI0E8JrbUfqw0QIqtS1d7BVUM9v7AjltLHMm/Q/w/BaDybEkwMmjFPfRm80ZouusMAwJ2WPa4SfmWnowJ1Io4z9VpR7ufMmugOWc07L6AzZ3zsnjBQmJOIhwHey30xv5D52rNkercMgDNvL9fb4XVZM2L0LN97TExzI09drgJc4ZvOSz7mcBy6LdhyF0Cev6+q0ZOzkQsi4Vb/Ocvij+3i2hMyLfsHK5faWXN4088963+n/YjmOPZVR9WFMxwRF4swvcgnDxZ+tD9GsfEYsIVJznSXmypfEi9x3Q0JRzl0MAk+l58BzhviRrAm3D8bxj8zSepKpKjBTE4kLObiablvMdU/7x/vj30IxiFMu3C2iQuVQFmboRt/Gsk0ah/xHXfawrk0ETCFdQliu2WG/BH5tF3ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 09:35:13PM +0200, Jarkko Sakkinen wrote:
> SYSCALLS
> ========
> 
> Two new system calls are proposed:
> 
> 1. userland_open(): open an opaque staircase-initialized container
>    object (modeled on Intel SGX enclave initialization with separate
>    build and live states) with no embryonic state, opting selected
>    shared namespaces in via an allow-list instead of unshare semantics.
> 2. userns_set_idmap(): configure all UID, GID, and project ID map
>    extents for a container user namespace in a single atomic system
>    call.

Andy, perhaps a bit too far of the box idea but I'll just throw this out.

An alternative to userland_open() would a file e.g., virtual device
file, and necessary wiring for open().

Then the added syscall surface would reduce only to userns_set_idmap(),
and it adds more robustness to access control (e.g. who can create
containers).

What do you think of this?

Br, Jarkko

