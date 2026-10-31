Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F369606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 21:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NQYoCgfO
Received: by kanga.kvack.org (Postfix)
	id A4A8B6B00EF; Sat, 31 Oct 2026 17:39:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FAE06B05B1; Sat, 31 Oct 2026 17:39:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912AB6B05B2; Sat, 31 Oct 2026 17:39:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62B6F6B00EF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 17:39:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C07EEC0138
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:39:28 +0000 (UTC)
X-FDA: 85384238016.23.84A7E66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1F6F4C0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 21:39:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQYoCgfO;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793482767;
	b=EQYUxmBVmdDQxSG8X5q8tQKPSRWShs/BHzpXhBFn+vm7Vuc0x2PDiwvZWC2M9E8TXTeHrO
	6QMU5pH53+jFUeVB+2AK/La8eD1jN7BL1rKx96aObecCN7s1OnKatp7pC3LHfgHFK1ptmk
	KZmYJkQCqLr1d9ShHa7v3/cmwSNdTt8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793482767;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3S03iCV4dK9dJWIYRZ6o0GPEOUkUn6vSd4nqDG1Mmw8=;
	b=dn53DQDPDsZtcek5D31nHP3TWQqn60iI5YwaRrNTr2BmL8OLS2pv958TT41Yaqw8rtVZir
	HZmD7l3IJM4jBKDQfmKsc8gkOL9AdSQIhUa/EZWSLCYSMeitbVbOs6YcuP4FKYhMXNcQ0H
	e5coVIS0xWb9uadrTKu4oFrkdU7Q7d4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQYoCgfO;
	spf=pass (imf22.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 422E16022F;
	Sat, 31 Oct 2026 21:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1831F1F00919;
	Sat, 31 Oct 2026 21:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793482766;
	bh=3S03iCV4dK9dJWIYRZ6o0GPEOUkUn6vSd4nqDG1Mmw8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NQYoCgfOR+/eaqcXcfxqPWGIt5MQfh3HfJmWUNTfTfBMiMeDZemhE9dkDX7MaL/Xh
	 wMvhden+1pqNtQ0QuondGl3OZa78iqW2P5D3HlJWYOalge64f/Ai2+iS06M8l/G8Zb
	 EDKtLUUM5tU34GwcGxvTyqJ72AEVG3WrQpeiFeeAz6GKQLWNX3Bi5b8nHf8ajxQwoa
	 dSvIPV41RUM4jknMgfMf1aAUDKXj+uQTMR+HN6gCVNXE0XgnBHJ9twYP5UZB6Gwl6u
	 sz6A4D3bDWD1Ag6jFl+TS0tBtOWbXjIhxZQ2Ko3aiH2LqVDcLhpVlaD4C0zXC6LwsK
	 MkcP2ZtjeeTIw==
Message-ID: <sashiko-outbox-192180@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 3/6] lib/string_kunit: Add test for copy_task_comm()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?QW5kcsOpIEFsbWVpZGE=?= <andrealmeid@igalia.com>, "Peter
 Zijlstra" <peterz@infradead.org>, "Juri Lelli" <juri.lelli@redhat.com>, "Vincent
 Guittot" <vincent.guittot@linaro.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Christian
 Brauner" <brauner@kernel.org>, "Kees Cook" <kees@kernel.org>, "Shuah Khan" <shuah@kernel.org>, willy@infradead.org, mathieu.desnoyers@efficios.com, "David
 Laight" <david.laight.linux@gmail.com>, "Linus Torvalds" <torvalds@linux-foundation.org>, akpm@linux-foundation.org, "Yafang
 Shao" <laoar.shao@gmail.com>, andrii.nakryiko@gmail.com, arnaldo.melo@gmail.com, "Petr
 Mladek" <pmladek@suse.com>
Cc: kernel-dev@igalia.com, linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
In-Reply-To: <20261030-tonyk-long_name-v8-3-c9b030332254@igalia.com>
References: <20261030-tonyk-long_name-v8-0-c9b030332254@igalia.com>
 <20261030-tonyk-long_name-v8-3-c9b030332254@igalia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 21:39:24 +0000
X-Stat-Signature: kmut8zjq7xe8k3pxkpruuudu5n5uaaa8
X-Rspamd-Queue-Id: 1F6F4C0002
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793482766-363108
X-HE-Meta: U2FsdGVkX1+quD6gZT6M8M2WhJfZfjNKOCc6iBHJ11qLiuKJBLqhNDKGYzz0kRpbFKudicF0VrXBfqSEfoB/d2bGdhYriCPskdZogqOzyOgX/lpQfxmArvoOcVjNNJPWMGT8m0aOSiuCuA9jBmNmF1xKm1XrjKW+XY9wAEgm4m2HgtJthDqJOPyHDnuV3XQdbgs2Pqou18gTuq8cJuyCBDnXiRG3gw3jVh+n8dlyDbf+tdf6YBy9LdIjNJyZQSWWsxxlPt1XQiFwEdGsA4YpH7Rgzr83xcDXk8M7eehCD1hIlrS6wfodC30BQMIZl8ePxg4ZakehVGxpWsTZ87ImJTrltvDeNKHLb0uKCPL8p0oEoHH5GMYTgnl2CrqSfbgLTfLZ0Osad+H4nbEHb2UsiCfShmyzWAmoXz2h2cZ/TgJEa3xcnZo/iPQNLgtbXN31mANgyWIuLF4UP4pvpnV3wi71wrJUdvnHBaEA0J9CmK/U8cXIl402rdo2eb3mQKL8+14SodhFXYyfX/qaHh4Zcwq5yhPuKTkpu3ad4z4clZsfgE2pcuj3o3LERx6wZImorDQto2UDOFwFQdLNkIZEKnI5BJ6LOn5do/i0a4DzPR8uRFkPW7b+Qk9PgeY2wVG68KeOs0BlLhq5yGrGYwmfJVIOWi3dNAy7gmyvLFK0sd7Ru6RbeerJJa1+C3FL6luQ1G6nSN1XDR9mM1LE0IDantpZ40rW6nVUPhHRN+PT7t1mDA3VcqmdBX0o5yjcejVlRqiQRlaUAKTPuOigymKoSyHJDCSpf2tpn3woFWMCHcHEZCll4c4QrgzzWo4x7n3F233FtR00YjvSvC+y/J2oOm9f34pYFxiCatDwammr4cK4l2loLI+597vtrkyf0ScguDMhDA01gmLeAx8lOx8hB26a5+m5JEdWv+nfHJwzfm0wD+cpdUBWX/zOXaEhtCkFb08muhCDufMoESNmNS3
 2v4GC++c
 NXqcWMDa8ktxHheD9BuI3Nlnm32YKMHFQAxH0k5OSOXDudviodSDsVHtQwNoSYwV1J1+qAJgArAfZsGkD2Xo+oSPoE7HONRN7a76z9kmGBXQVRf7Y9I47X//mjSw3xx41z8hiwGL6CgsoWj8eBhodxuyoWdJfdZG2ql17kP3Mmpr2iEBXM9XUHi+3jgKPObrEb9yjzQVk1rQ4000HD3hIgl4D7aXLUAGEcrG9gz4Nve1i4DFna/6ooum3cKsdTC6g7Bu5yiSO6lDw9LlS384VIOPALSVB7gm5uCFd25kAiLKFK0SAlkWZNRVuS2z6YWoKxjVmHpRSCgTs6HPURGirZN2mwWmYCJLzIb9vkxF1/ZZbs1OtsYusKAmlnML9e6HgRQbbrME5xf7S14SjpiEDOglEu/jOPDyB8jDMjebudmYyMJOeVgeN7e8tjji2xY0va1zaJFPQp8Z/vwSO0ABu62MIkOZh0yd5z55100hMAnyJoYNUD285UHjOP0kQn3HZZqgOjoLwT4tNvxYByvF/WIg57ia/PteHXygrb916ACRcxbGwTY8+9xahFe4vLsN0gSqH1raV01Cx7Ptyv9FDkDIwsl07zlTmvip2lXb9kywL80OU91s5KrJzvZapzUfJb8HsgbBQFsgjQvk0pwz8R8t68AZIcSYqvPP/BWQdfM/2TpHCpOvmy7TwJ8w3q417X9MNnE2SoJz+fd9BSkPMaLWRWqLI/enWtGawN+xvBMLWclgLRHQ1Af8rpoTAepwW4HC5QIpaPmigZHypdZECgE5KDmCjnFLZ56Uq
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
- [Medium] lib/string_kunit: uninitialized stack read in string_copy_task_c=
omm()
--

commit 0d3a01595d2cc8a60f5d8a8716e5935db351758d
Author: Andr=C3=A9 Almeida <andrealmeid@igalia.com>

lib/string_kunit: Add test for copy_task_comm()

This commit adds a KUnit test case for copy_task_comm() in
lib/tests/string_kunit.c to verify copying a task command name into buffers
of equal, smaller, and larger sizes.

> diff --git a/lib/tests/string_kunit.c b/lib/tests/string_kunit.c
> index 0819ace5b0275..66c3398f23174 100644
> --- a/lib/tests/string_kunit.c
> +++ b/lib/tests/string_kunit.c
> @@ -881,6 +881,43 @@ static void string_bench_strrchr(struct kunit *test)
>  	STRING_BENCH_BUF(test, buf, len, strrchr, buf, '\0');
>  }
> =20
> +#define TASK_NAME "task_name"
> +#define TASK_NAME_LEN 9
> +#define TASK_MAX_LEN TASK_COMM_LEN
> +#define SMALLER_LEN (TASK_NAME_LEN - 3)
> +#define BIGGER_LEN (TASK_MAX_LEN + 3)
> +
> +static void string_copy_task_comm(struct kunit *test)
> +{
> +	char str[TASK_MAX_LEN] =3D TASK_NAME, copy[TASK_MAX_LEN],
> +	     smaller_buf[SMALLER_LEN], bigger_buf[BIGGER_LEN];
> +	static struct task_struct task, *tsk =3D &task;
> +	int len1, len2, i;
> +
> +	/* set and get task name */
> +	strscpy_pad(tsk->comm, str);
> +	copy_task_comm(copy, tsk, TASK_COMM_LEN);
> +
> +	len1 =3D strlen(str);
> +	len2 =3D strlen(copy);
> +
> +	KUNIT_ASSERT_EQ(test, len1, len2);
> +	KUNIT_ASSERT_EQ(test, len2, TASK_NAME_LEN);
> +	KUNIT_ASSERT_EQ(test, copy[len2], '\0');
> +	KUNIT_ASSERT_TRUE(test, !strcmp(str, copy));
> +
> +	/* copy to a smaller dst buffer */
> +	copy_task_comm(smaller_buf, tsk, sizeof(smaller_buf));
> +	KUNIT_ASSERT_TRUE(test, !strncmp(str, smaller_buf, SMALLER_LEN - 1));
> +	KUNIT_ASSERT_EQ(test, smaller_buf[SMALLER_LEN - 1], '\0');
> +
> +	/* copy to a bigger dst buffer */
> +	copy_task_comm(bigger_buf, tsk, sizeof(bigger_buf));
> +	KUNIT_ASSERT_TRUE(test, !strncmp(str, bigger_buf, TASK_NAME_LEN));
> +	for (i =3D TASK_NAME_LEN; i < BIGGER_LEN; i++)
> +		KUNIT_ASSERT_EQ(test, bigger_buf[i], '\0');
> +}

[Severity: Medium]
Does this loop in string_copy_task_comm() read uninitialized stack memory at
 the end of bigger_buf[]?

In string_copy_task_comm(), bigger_buf is declared on the stack without an
initializer and sized to BIGGER_LEN (TASK_MAX_LEN + 3, where TASK_MAX_LEN is
TASK_COMM_LEN).

However, copy_task_comm() in include/linux/sched.h clamps the copy length to
TASK_COMM_LEN and does not zero-pad dst beyond _len:

include/linux/sched.h:copy_task_comm() {
	const char *_src =3D tsk->comm;
	size_t _len =3D min(len, TASK_COMM_LEN);

	if (!_len)
		return;

	memcpy(dst, _src, _len);
	dst[_len - 1] =3D '\0';
}

Because copy_task_comm() only writes TASK_MAX_LEN bytes into bigger_buf, the
trailing 3 bytes from TASK_MAX_LEN to BIGGER_LEN - 1 are never written. When
the loop iterates i up to BIGGER_LEN, won't KUNIT_ASSERT_EQ() read those 3
uninitialized stack bytes and fail the test (or trigger a KMSAN report) when
stack variables are not zero-initialized?

Note that in the later commit de6fdb508944 ("sched: Extend task command name
with TASK_COMM_EXT_LEN"), tsk->comm and the clamp in copy_task_comm() are
increased to TASK_COMM_EXT_LEN (64) while TASK_MAX_LEN here remains
TASK_COMM_LEN (16). That masks the uninitialized read only because
bigger_buf (19 bytes) ceases to be larger than tsk->comm (64 bytes), which
leaves this commit broken during bisection and means the bigger_buf test
case is no longer testing a buffer larger than tsk->comm after that commit.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261030-tonyk-long=
_name-v8-0-c9b030332254@igalia.com?part=3D3

