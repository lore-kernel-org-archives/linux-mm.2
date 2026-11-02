Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EFF2606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 22:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KvjvBCab
Received: by kanga.kvack.org (Postfix)
	id 78C116B05B3; Mon,  2 Nov 2026 17:47:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 763DC6B05B6; Mon,  2 Nov 2026 17:47:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7456B05B3; Mon,  2 Nov 2026 17:47:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 408BF6B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 17:47:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C6657C02BC
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:47:45 +0000 (UTC)
X-FDA: 85391667690.03.B96BAD5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 37D3040003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:47:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KvjvBCab;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793659664;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SeXl+7sHZ6BJjoxuUPDxP6KgJft9uuzUqAS1rwxVtLw=;
	b=E4AM6mWz4yp+zPiiIjrdBRvKy491TEdv2NQZVi6+zMI+V50qWQzbr0qwmor5SqRhVhAhDh
	ZA2Ag+e/VVtqKBeW7+x0ICrpFOBKMqR/RzCGNel8yVgZZkOvAHLQWijuAdi7RLRdnag0VA
	q2L4hIbGvng6CEYegViyCtyLnRRONbM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793659664;
	b=ANep7dL4hCHRfI/E2TeWtWIEsIMpRNneMLc7gFkxnJde9dmmYd6cgpSU6CVxqNGikzieWt
	fnhZlwBwg/GNacT6AtAFN27N+PxenxduKIV+38LegfyY7SPLodRrJhySVE9Md/xG2X2BzA
	3FK9GR1WzCcYhv2MLaCf4D3TqGDVpD0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KvjvBCab;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CB7C86022C;
	Mon,  2 Nov 2026 22:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 842E31F00A16;
	Mon,  2 Nov 2026 22:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793659663;
	bh=SeXl+7sHZ6BJjoxuUPDxP6KgJft9uuzUqAS1rwxVtLw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KvjvBCab3ce01xagXf8LL/qS6uv8xEbOogljAbyRlIokQH0qW/NoRJRZelCMSeleq
	 UL+F+Q9wCoXcMJfP3VP1EKsy670jzu/FJ5wpcMbwF+nf7dEIGJW3Qzo4J/mbz9Dh1P
	 hSN/227OOP3feCg64nzQMrNOy5L5AuVLwhqKI5TmTqiuZgQJRS4kB6cAOJTn3+U2J5
	 yNFxocO+TW4jGI2rhefzD5dcv4rxU8dzIRfk2XlocCABjm94sxkFtE4wWC906p9ADb
	 JOAzD6FGpfRvIEHXC0imUpUS0geM2lk9lCwGCL8WltyEx322lTUtC8bTMXhaZLn5RS
	 2bHVr30oUwDiw==
Message-ID: <sashiko-outbox-194303@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: add a uffd test for re-registering
 during UFFDIO_COPY
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Mike
 Rapoport" <rppt@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Shuah
 Khan" <shuah@kernel.org>, "Peter Xu" <peterx@redhat.com>
Cc: "Lorenzo Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, linux-mm@kvack.org, "Muchun Song" <muchun.song@linux.dev>, "Oscar
 Salvador" <osalvador@suse.de>
In-Reply-To: <20261102081140.201987-3-azpijr@gmail.com>
References: <20261102081140.201987-1-azpijr@gmail.com>
 <20261102081140.201987-3-azpijr@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 02 Nov 2026 22:47:42 +0000
X-Stat-Signature: mz3t6ozsaxybmxm5c78nup3qemh66god
X-Rspamd-Queue-Id: 37D3040003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793659664-872289
X-HE-Meta: U2FsdGVkX1/KVFLNoPuDaiZktBKJfo5/yNP2rrHWzIQg6NgKW84A2jaupv0I8EV5L5l39j0zbPK2Ah7/jhp3LTBC6JSIif/lPsq1XQB8uQouPgti4yXuG2aTkfiYO4hPzFUcmziWh72iNLGbeXh4F1IEe+d+ityU2ErYE2uG86crrdCB2938t5qUXHGYfOvqllHCOTit+w0DMwmohOz2PA1dz/nuwGKt8+0WC0IGIBStqwIhbH48KoY/M8zGVT3jwGMlYxQ5nexrelywApWIngmZP4z6MKIwglUtT0K0D2CUfQWm/WXhLP+zSRg+YVuAfL2/7XhETajwiRz3BywBypF11WUBg+BWfCBTMlgZ01kERqGmVaRWObEw5Qb/tM0uKRWkqviVTGJD09CH0sxuqBSmA6Hjwz/+2+Pjwx/39jC2HZDyBqaQxCMOQ4Y88J2gkSszIZ14V9ktq8d/T1yMZW6f4z/guqnF4EHg5oYQtr8y6bOr7TmpZR6H7QzzaEqnTkqT4Xu0X+SuopxiMuRkbI8k8FdQqd08KOdDSsABphk1u/0Y8apwxnT+/93C6XFg+ZUCqahOSTFiga/gvXMNIO1BERTf2m384rqv1hWkkejjKqTriTzUaebbCLVEwbHJXZ2hbAnbYecrDtHtnXFVUzAcBbB3gMjz7EnzgWjBJaAJKLNLG3HVATejLQ0WYOUh4ge9Qkii3drYtRWtAj/gFI/nZiiL5dZwwId58bnI8Ze6kXQUA+w0OMggAyfF3NVK9AoAW/TSmabYh9TmbBFtXtBvjS0jqTM4xqkW2qBbtLGRJ6mNlq0XlVkmZ5gkAOf/1tmQWP61WoeLRHuUbPHae1/G6FrHgzWW55OA8V+TDqHoSH5hdhTTTTUTKWwnZpdHZzqzYNDgKRpMBKt5EJWnsxgP4dlj/ww1ghq6RPNfhtx4ni0BGrxdwjflPZkOV9BNniPVOYB1D2Jb5LTezcy
 5DClcz6L
 4krkDC96KFaGSoPFWlIgjDbCCSs8CTvuFnbSV8vOcut0dcyflw0M5+DRJg/5QI+FEWp7nTO8me/EyeBqxJZxMDwGI+6sJpLiAWFlanx1JMZBw6FJtfH2LfEO+I+oq8EzF9yKa3z8Q5ARPyqGZ9KpEz9EaH2DNUpOV9qKKqDI+8Ir7CJnQQmw3fNmLPnB3vl0rziqPMQ3DOJKqIb/sBPF865jrk6KGx6+uckme/mDYUisU1A28EbNSmOayn0JoofDArtQslUgmurFNTs7i0dUTaocOjrtJirC5PthH2DEQ0MDkveC+4Dr+K9YzSNGtaWxBqUau6TRGAvIUOXB1kEmP0FM06PCBhhachB+2bx1bOq3qw997ixGOeAsGx1DXCzZKJAfhwQ7iXAewfmrRKshQUANciJc4ON6GBv2UxONH9qU8WUeFUQLcFAvqNwYjbXg2XKp+8Pa82m05uiNTqAv87xO9HdqyE5O6svnd9isMWJ0dPr9oPDspglhsFSG/Oukqq9eYI2Q97onFNjR+kSAfbenmfUqqc92jV5TuqgVtaox2cx/8V80v93G/pQQ63umeuLSUYNoSvwUE+8PvvgloiLi4UdpWNRnzhg+GXpN6iLJ5iQ6n6Odhsq06wMuJ46uLAqrN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] selftests/mm: poll() returns POLLERR in uffd_wp_copy_reregister_=
test()
--

commit 58286e73577bfa5312c30b5cdc10c8a436006bfb
Author: Jose A. Perez de Azpillaga <azpijr@gmail.com>

selftests/mm: add a uffd test for re-registering during UFFDIO_COPY

This commit adds the wp-copy-reregister selftest to verify that re-register=
ing
a destination VMA without write-protection while UFFDIO_COPY with
UFFDIO_COPY_MODE_WP is waiting on a source page fault fails with -EINVAL and
does not leave a uffd-wp bit behind.

> diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing=
/selftests/mm/uffd-unit-tests.c
> index 2a97ba1d6feb1..cc22b4cde621c 100644
> --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> @@ -375,6 +375,104 @@ static void uffd_wp_unpopulated_test(uffd_global_te=
st_opts_t *gopts, uffd_test_a

[ ... ]

> +static void uffd_wp_copy_reregister_test(uffd_global_test_opts_t *gopts,
> +					 uffd_test_args_t *args)
> +{
> +	struct uffdio_api api =3D { .api =3D UFFD_API };
> +	struct wp_copy_args copy_args =3D { .gopts =3D gopts };
> +	unsigned long len =3D gopts->page_size;
> +	struct uffdio_zeropage zeropage;
> +	struct uffd_msg msg;
> +	struct pollfd pfd;
> +	pthread_t thread;
> +	uint64_t value;
> +	int pagemap_fd;
> +	int src_uffd;
> +
> +	/* The source fault comes from the kernel, so no UFFD_USER_MODE_ONLY */
> +	src_uffd =3D uffd_open(O_CLOEXEC);
> +	if (src_uffd < 0) {
> +		uffd_test_skip("cannot open a kernel-mode userfaultfd");
> +		return;
> +	}
> +	if (ioctl(src_uffd, UFFDIO_API, &api))
> +		err("UFFDIO_API failed");
> +
> +	copy_args.src =3D mmap(NULL, len, PROT_READ | PROT_WRITE,
> +			     MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (copy_args.src =3D=3D MAP_FAILED)
> +		err("mmap() failed");
> +
> +	if (uffd_register(src_uffd, copy_args.src, len, true, false, false))
> +		err("register src failed");
> +	if (uffd_register(gopts->uffd, gopts->area_dst, len, true, true, false))
> +		err("register dst failed");
> +
> +	if (pthread_create(&thread, NULL, wp_copy_thread, &copy_args))
> +		err("pthread_create() failed");
> +
> +	/* Wait until UFFDIO_COPY blocks on the source page */
> +	pfd =3D (struct pollfd){ .fd =3D src_uffd, .events =3D POLLIN };
> +	if (poll(&pfd, 1, 10000) !=3D 1)
> +		err("no fault on the source page");
> +	if (read(src_uffd, &msg, sizeof(msg)) !=3D sizeof(msg))
> +		err("read() failed");

[Severity: Medium]
In uffd_wp_copy_reregister_test(), src_uffd is opened with uffd_open(O_CLOE=
XEC)
without O_NONBLOCK (unlike UFFD_FLAGS, which includes O_CLOEXEC | O_NONBLOC=
K).

In the kernel, mm/userfaultfd.c:userfaultfd_poll() requires O_NONBLOCK to be
set on the file descriptor:

	if (unlikely(!(file->f_flags & O_NONBLOCK)))
		return EPOLLERR;

Because POLLERR is returned in pfd.revents regardless of pfd.events,
poll(&pfd, 1, 10000) immediately returns 1 with pfd.revents =3D=3D POLLERR =
without
waiting for a page fault. The 10-second timeout is bypassed, and if no fault
occurs on the source page, the subsequent read() will block indefinitely.

Should src_uffd be opened with O_CLOEXEC | O_NONBLOCK (or UFFD_FLAGS &
~UFFD_USER_MODE_ONLY), and should pfd.revents also be checked for POLLIN?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102081140.2019=
87-1-azpijr@gmail.com?part=3D2

