Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76D53606A332
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 11:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IkROlQ0P
Received: by kanga.kvack.org (Postfix)
	id 986C96B00EF; Sat, 21 Nov 2026 06:47:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 937996B05B0; Sat, 21 Nov 2026 06:47:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800346B05B1; Sat, 21 Nov 2026 06:47:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D5516B00EF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 06:47:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6B2312041A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:47:42 +0000 (UTC)
X-FDA: 85458951564.08.6A183DB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 337A84000A
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:47:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IkROlQ0P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795261661;
	b=IbDNRmgbkIq67xxV1fceVJPqDryv2uk+fwS/Fe3X7XpxzD0yC89J3usTcA/prTUDqd9+z8
	XaHLjDGDoV5roZM/DE1CpYuw0xJF1hGojLJvVXuJjFG8vpE7kR9qVkY9vEV1ySRE+T65Ks
	OqzYnj2fhRiZRI5U2ZJRwfkqCmtn9g8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795261661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ALx0sJpj+pkFds0WlOLPKL1r0Eodz+uXw3XkI0BnJQ=;
	b=6FM9/bRXxlHYM3lSbsZZ7Oltmk5oT6POjLLzbW3vsyWWTJ4AxzvDaeFtVAueiwK7r6LCBB
	DMybXz3oVD2rr2mu0afKfRDLad39PG61fSPKH1np3B2U+6zEou7fQjrqi15JI3TUPSCGA4
	qKHlDEj26193ZCVocsMuAGWavG9DXvU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IkROlQ0P;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of jarkko@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jarkko@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with UTF8SMTP id 20399456EE;
	Sat, 21 Nov 2026 11:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7B4521F000C0;
	Sat, 21 Nov 2026 11:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795261660;
	bh=4ALx0sJpj+pkFds0WlOLPKL1r0Eodz+uXw3XkI0BnJQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IkROlQ0Pq+Rut8U64pvIUJTh/oAnChCaeNYg7hBVBuRUnEhRsa7xNq/JRarTXK2K/
	 1SrKwVoY5oIeDiNoie/5u8U8GgnhTmyy0YX6Ld+DcqlRzwJDYG0Roi6EYh/NSo328Z
	 gtWd1bE18xVGxRviE+EdpOnXwrmVQ8V4R2Hep+47tEdMGgvQkfsf4DeY503xo0UrGz
	 +bmeCFDEAe5+Uy7+IO+cUFDQVBzUpeFHqWg93+bOiVNe0hghenDK7O9YRFT43oKEgj
	 ETQw/sww4Y0GKJuijqz84K+iCyImKpbC8/fpbl33gqZ6lI9qEE90ukgklczuRo0UYy
	 qfTMs+JqLTQJQ==
Date: Sat, 21 Nov 2026 13:47:36 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: linux-fsdevel@vger.kernel.org
Cc: linux-api@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	Alexander Mikhalitsyn <alex@amutable.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@amacapital.net>,
	Christian Brauner <brauner@kernel.org>,
	David Howells <dhowells@redhat.com>, Jan Kara <jack@suse.cz>,
	Jonathan Corbet <corbet@lwn.net>,
	Josef Bacik <josef@toxicpanda.com>, Kees Cook <kees@kernel.org>,
	Neal Gompa <neal@gompa.dev>, Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Zygmunt Krynicki <zygmunt.krynicki@canonical.com>
Subject: Re: [RFC PATCH v5 20/25] security: Add rootns LSM hooks
Message-ID: <awGE2FTQ6kpWEMJh@kernel.org>
References: <20261121000844.1863324-1-jarkko@kernel.org>
 <20261121000844.1863324-21-jarkko@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261121000844.1863324-21-jarkko@kernel.org>
X-Stat-Signature: os7u7ahaewch5horf3445ch5detbskn1
X-Rspam-User:
X-Rspamd-Queue-Id: 337A84000A
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795261661-350601
X-HE-Meta: U2FsdGVkX1+2DN0pPN16qG8FuHyW4QiTYvhPN7g1VMTUWlOu/nctwNKQ1EakOl6V4d/uEurcHG9/y8l3YQEbvVXND/awdbkF9F4yRAaVwIU8mKUt+VVwzeaLlHyti1GAiZ5oCskxrvGCVw5jRt6QHPfsWXEfiISfEu+P6YIryJC9DsIeeOhtQgWeZe+w90mH5LXYXINOcImMAVFJ+DqYB2/kZ2NRc5reaFOHIO7PaFNpXEWzpV6KpqyJkjFG4agoEJFRcsra60DlQXPC1ldL7Vu4HHGekfKngWbMPckHJe5swPEoQO+se+fSdApzxbOtmiGsWNw8tOj/hpTgosPNqcs1vvMROupKkuGRLFphGB3VDp99ArNryeU3+DBAm8Dprhbv4vDQvWyiEGK93b7uNtZryANk/4+zKM53qf4Xsydq0MKg8TXDn321fBcQiNlwUt8xhEsYjGAEElxth4ww6mWbSlUOsEF5ZLqyh3ooXO6xBthUEXcjE/oQRVHtYEzDT7iKZll4X/49Gck9Fx5/bhqFXKb1vXbx+LhQLuZR0HDqbyA6ZgokjzE7N05kcv3nEMokcpKZKhKiwhY+JCecGAftpOcFd6NOzCdbHPweUTZzx4gOE1slX3tPSb1LMKYhpfkOrnna7stOIM0CK9UD1GHkFd8gO8l5M8ajJLSxQsz6W5B+HKLR1xh0a3vZpvw+voN9Mtg0e0RAcGpTB93phGj3ZlWgsGHcqxdOp+67m3H0cTtOO96TmCGQiXQC5e+6aWfJ1h8x6DwBO28EiKTi6mx4UkvQj8kcgwckRC+zaQhvcKpzuRWrDjsS71qt+3DdrFzzph9LNs4Wfnpa2+LIRf+B+uyR4nYjkiYMhB6v7QG5IsHvO+YQV+wxfMZ+dMbAO3jXYttrkCJae8U/Ma5mKUqo7OFeILH7IZqdDqW0hmehexE16Ax+URO6+lcbi7aEDhACsUJ5qeVY003nwiw
 0PblkZsi
 kgdtCg4KdY46bMYT1OR8pq1Hj1CoBRQqufFF/B0q5oiWY/hjG7tOvvT6O5cBK75yr0cZlHVRgscCPCIT6i+cCXqds7qS1XUqu0VzcXIstb9GMr1eG1+AwfOmgRlv8rgtDGDCEBM7e6x1o+63UBCiGWFS+zdbhVWRClcMUQC6ApKUrh0SFrN0RDqB1Nb9n07n09WDFouqL7jjEF+0oy1FEtAywxLuQuBl5mwAjbN6VDjuIgbvdV8PYiSMpSpoPUpXPQAhWh39maVxsZZXpLubrJYw6YyOnQUqKsGYq9BKKyTH1w2UOUbN/K02cJnHIy52ID2Psb8PjWrdTHJgm49r0mzzg4f8ZOBO56KA7415ieBQK4MvPPNWR8TyYOZA0TKE9Szu6L65mzZ91Z1h2MFjAQPHgmvgNQWeR1L8NhzuQ6LAGpadf5vOFQzB6yr7c5t4907nGQ8SHsioyyTjGe00dg3ZkOiZ9e2s6hiDxtnGP7VzuJrg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 21, 2026 at 02:08:39AM +0200, Jarkko Sakkinen wrote:
> Security modules need visibility into root namespace creation, teardown,
> process entry, and container-wide signal delivery so policies can attach
> per-rootns security state and mediate operations on rootns file
> descriptors.
> 
> Add lbs_rootns and rootns->security blob management alongside
> security_rootns_alloc(), security_rootns_free(), security_rootns_clone(),
> and security_rootns_kill().
> 
> Co-developed-by: David Howells <dhowells@redhat.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
> ---
>  include/linux/lsm_hook_defs.h |  7 +++
>  include/linux/lsm_hooks.h     |  3 ++
>  include/linux/rootns.h        |  3 ++
>  include/linux/security.h      | 30 ++++++++++++
>  kernel/rootns.c               | 44 +++++++++++++-----
>  security/lsm_init.c           |  6 +++
>  security/security.c           | 86 +++++++++++++++++++++++++++++++++++
>  7 files changed, 167 insertions(+), 12 deletions(-)
> 
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 87d9d06710cb..2cb90ddedc14 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -480,3 +480,10 @@ LSM_HOOK(int, 0, bdev_alloc_security, struct block_device *bdev)
>  LSM_HOOK(void, LSM_RET_VOID, bdev_free_security, struct block_device *bdev)
>  LSM_HOOK(int, 0, bdev_setintegrity, struct block_device *bdev,
>  	 enum lsm_integrity_type type, const void *value, size_t size)
> +
> +#ifdef CONFIG_ROOTNS
> +LSM_HOOK(int, 0, rootns_alloc, struct rootns *rootns, unsigned int flags)
> +LSM_HOOK(void, LSM_RET_VOID, rootns_free, struct rootns *rootns)
> +LSM_HOOK(int, 0, rootns_clone, struct rootns *rootns)
> +LSM_HOOK(int, 0, rootns_kill, struct rootns *rootns, int sig)


Rootns objects have a security model:

1. No embryonic state by design. Especially staircase initialization
   contributes to this property.
2. Unshare logic is inverted. Right now ROOTNS_SHARE ioctl does not
   exist right now but it is (obviously) doable.
3. Dead obvious and transparent LSM hooks. Really hard to get them
   wrong.
4. We already know by experience that opaque fd-bound objects with
   two-phase state machine (build, live) works. It's what make this
   secure and policy-free implementatiion.

The choices how to do things with closures used in SGX driver are
translatable and they are also pretty well reviewed choices, given all
those years... I would put some weight on this too.

Br, Jarkko

