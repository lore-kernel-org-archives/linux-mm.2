Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 442AF606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 01:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LUpFOJ4e
Received: by kanga.kvack.org (Postfix)
	id A41176B05B3; Tue,  3 Nov 2026 20:03:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A122E6B05B4; Tue,  3 Nov 2026 20:03:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9726B05B5; Tue,  3 Nov 2026 20:03:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B4AA6B05B3
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 20:03:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5130C05F6
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:03:26 +0000 (UTC)
X-FDA: 85395638412.02.708F456
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 60DC520002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:03:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUpFOJ4e;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793754205;
	b=psmuyD0k1VaVwcviV7HVa2N58kP7jSkfYqnjuc9ZdMjIi5n29UPK1i5hBR8/ljcqG11vCP
	rsYzUhIDPQxUbhwNTtcAJH4gmvQC6/MO9c90SQt7U0M/mYYxToclCC8bRbcpeU0gG9I8UC
	5fQ2XTmI8OkBGCYLP5c+GYyomERSq0g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793754205;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=se8T7YveofbWh8YkjlpsY7Miv4OL+LoXEnC8W24eXlw=;
	b=MVWlIBFipwAozu6+pRXSoXcHoEmMdPF4sGrSmd931mJb+Z4EQ14SWoFVCNLl8P8nSu4+2Y
	uVHUv0Rjo1EM46Fkz7Hidr+3NvNkjQGuSWx59C52c/BXbPwZQtAFmQ/41NO73WH2XHzW/E
	Gm/pRDeqfqL72qNGkLpmEksKPUxxLZE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LUpFOJ4e;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC59060D82;
	Wed,  4 Nov 2026 01:03:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00C41F000C1;
	Wed,  4 Nov 2026 01:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793754204;
	bh=se8T7YveofbWh8YkjlpsY7Miv4OL+LoXEnC8W24eXlw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LUpFOJ4emoT0ugAgjuLIAruMWlysV/hjODIua2aAw3UkUTCSEgQARjRkSs39Tbw6f
	 nrLGWrRejD2l7AUAaQveaz2azAo0yCIcFx4kZFaeEgR4+pnChg5uTggnApS/I3nEhc
	 8Xvtrb6TGqyyjm+3Tilf0BEX1g47h2Hq1J4PbaQb4U0Y7YsHuZei5CA9CPaNa8jtRa
	 GyTAxcGQFa5YoWbermHnSoxl+3LdpA7sNFYhAeP4PgtWOhZFgisSVtLJOER4khVK9g
	 moQp4Ifkz0FHYBm96xs1+HFKHuWOxJluK4AP1d63WbXgGVFEKK1HV3P42Y6xrK8/pC
	 GqskQ2EfsFyEA==
Message-ID: <sashiko-outbox-196333@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/10] selftests: liveupdate: Add tests for preserve
 and retrieve user argument
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: "Alexander Graf" <graf@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>
In-Reply-To: <20261103010216.3447716-3-dmatlack@google.com>
References: <20261103010216.3447716-1-dmatlack@google.com>
 <20261103010216.3447716-3-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 01:03:23 +0000
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: pjhpqukqa6r4xdsk5o6jta787d533f3u
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 60DC520002
X-HE-Tag: 1793754205-54528
X-HE-Meta: U2FsdGVkX19o809/uo21YSNBo/KUUPlbcS7XBpHvJSxpBFyU3AiNKXfN4O0ClJSCWb31zg0KScG8SRATM17Ae4omoSLDmHtHKfFE+UuQuhb3Dk1/GfHeFdGhg6MZqvuYluw3ooVYW/TfbynoY3UtLkqdTCNhIFgbn7ZJnX4XY4vAL6FlApPpMrz1nJazn/P8upKxdt1UfBg1VJIf8fS9RajbRSTf30Nox9UiM5i17mEY9u3k3CL2Ou+2Bfx6S7iKB/+ZkU86L9KisaBtzfqoPpFMGmqZoDJlkfneBHx+K4VJE3PkscWXXg/+6zAfdnqi0H3xnX9S8NcbC/ndhELcdP/ry83CIjQc6boKdxtBAZMEpBt4Phgm7M8d65YRSAdo2Mcr1BBDP+s0oSBtgGPaqaLJmlo1sh4/yzfvNRyA8wwI8r4/LQx3SJ5qapHFHnU+B0NcgsstYCz/pdhQK38bFUVnJES++9ZYRfXc+k+LeHHu703feOhWq1e/0kZTND0m9alZsInIN6JFuDq7TQ1+p3gJZNZMlfBCQJcou8WJTFFN6ppLZEEwJM/9wDWhy5ZI0yoiFPBzpb+DWQgw8VJOh6CxMLqaOSA8mztLVTMHNV8wbqZok190lSiLtCbVh8N7FoVODJZZRKG8oyrwG8fh3gptsIxMXhlGuXfkci89JUIz389JIfvCB7KZdVe93OGuxfpcs984CIQxir7CntYy2j+MASj0scwJJF09VyJsMWO9UzbvKngPJtpbxxw3aSPJ2FClLWSfyHTGZHk9w3s5bSl6HlwfCbDF3VUQ3AKqNR+BQ+MHtWv7VHSJrmCoJIcoPYxJsHRonq3BeEaeUmlzKP+Wf+2iaMid4nDkZ2DDuyW6vlL8R81GV5N3vip7IxNYmxYMA/qM/xQk1Ap5urHSLCraXB5K3pHVpVqWi6LVmDTPSHcC9KepX3l2F60IPCWPA8yYKBiGkb7+nAuPHmW
 RT91Cf5P
 3NtCoxOgwkAzW7ZjjtDeCOoZhJdn2CWinc8LXXwGDIgZEHaB39FVMbrx8+BBjvXnMoxrmMm/R18k3MYvcZjnuE6NOmhqCn8m3Gaqu6588OTLLharVkrtDAUAfwOEfdZmq08wOeP0i2LWSMSHgPgf1BP/8BFx8W+diLCd46iMFje8BUTCqwlVGLGxM/XVs39T3nLZjlQuQx2717FrmN8xpaWweYhjnHsMwKmZWSdfDKF9qVdUCZlr55KABzbcNUpfh7npeYPzkcjPrZyPxarwiF/buG4CglQoT6YzdBiXYs7Wy9yLs4XNs85qRFlKPjr/AyoLWa571twHX5ihtESEAij4CxPLLFgqCt6Z9HBjxoYQrpg6kl2WXtAHgojc1wDjr7OWR2pQs20bf3H3/5WCTLslpXQrwZJQ6I4xdqhXTy40mmtiWmgSkY0Y1NYqxANH+bmG3+Q1hc1abRN3PDMgB7PpZcPc5HiqEtxy0xh7DLEvs/SV7E07bmO+yIELdDqrgwj8toT3AvXrzdooJ7LWucdMotnoPYJjdvJW6HDjWtHlde39eY4gkPuORllwFPVZRmvmqn1cL3Xhuv71qd34ksdspq6oswchWPuMK3Hix6/UEFF0lgxQZuQKsngxdLUFTS9zffxtDdActOvc7VV0gnxfvE4pJh/1h0n9qeheoHMPb/QlgOyr8eYoX1HTJZ+d5RFoIFv3hxqdaWKQMBsaw9JNnz9Szgqi9gA4X
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
- [Low] selftests/liveupdate: zero min_arg.arg in preserve_memfd_with_arg()
--

commit 0eae9757b9fca17ee60f5d085e6dce0d9304a977
Author: Pasha Tatashin <pasha.tatashin@soleen.com>

selftests: liveupdate: Add tests for preserve and retrieve user argument

This commit adds libliveupdate helpers for passing user arguments to
LIVEUPDATE_SESSION_PRESERVE_FD and LIVEUPDATE_SESSION_RETRIEVE_FD, and adds
the preserve_memfd_with_arg test case to verify memfd argument validation a=
nd
legacy struct size handling.

> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/test=
ing/selftests/liveupdate/liveupdate.c
> index 2dedd5fc2534f..4c4272167635b 100644
> --- a/tools/testing/selftests/liveupdate/liveupdate.c
> +++ b/tools/testing/selftests/liveupdate/liveupdate.c

[ ... ]

> @@ -530,4 +531,47 @@ TEST_F(liveupdate_device, preserve_many_files)
>  	ASSERT_EQ(close(session_fd), 0);
>  }
> =20
> +/*
> + * Test Case: Preserve MemFD with User Argument
> + *
> + * Verifies that passing a non-zero user argument to memfd preservation =
fails
> + * with -EOPNOTSUPP, while passing a zero argument or using the minimum =
struct
> + * size without the arg field succeeds.
> + */
> +TEST_F(liveupdate_device, preserve_memfd_with_arg)
> +{
> +	struct liveupdate_session_preserve_fd min_arg =3D {};
> +	int session_fd, mem_fd1, mem_fd2;
> +
> +	self->fd1 =3D open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->fd1 < 0 && errno =3D=3D ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->fd1, 0);
> +
> +	session_fd =3D luo_create_session(self->fd1, "preserve-arg-test");
> +	ASSERT_GE(session_fd, 0);
> +
> +	mem_fd1 =3D memfd_create("arg-memfd-1", 0);
> +	ASSERT_GE(mem_fd1, 0);
> +
> +	/* Non-zero arg is not supported by memfd handler */
> +	EXPECT_EQ(luo_session_preserve_fd_arg(session_fd, mem_fd1, 0x1111, 1),
> +		  -EOPNOTSUPP);
> +
> +	/* Legacy struct size (up to token) should zero-fill arg and succeed */
> +	min_arg.size =3D offsetof(struct liveupdate_session_preserve_fd, arg);
> +	min_arg.fd =3D mem_fd1;
> +	min_arg.token =3D 0x1111;
> +	ASSERT_EQ(ioctl(session_fd, LIVEUPDATE_SESSION_PRESERVE_FD, &min_arg), =
0);

[Severity: Low]
In preserve_memfd_with_arg, min_arg is zero-initialized at declaration:

	struct liveupdate_session_preserve_fd min_arg =3D {};

Because min_arg.arg is already 0 in userspace memory when ioctl() is called
with LIVEUPDATE_SESSION_PRESERVE_FD, the call would still see min_arg.arg =
=3D=3D 0
even if the kernel read the entire struct from userspace instead of truncat=
ing
at min_arg.size and zero-filling the trailing arg field.

Should min_arg.arg be set to a non-zero value before the ioctl() call so th=
at
this subtest verifies the kernel ignores bytes beyond min_arg.size and
zero-fills arg?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103010216.3447=
716-1-dmatlack@google.com?part=3D2

