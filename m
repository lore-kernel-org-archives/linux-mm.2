Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C90606A324
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mrWiPdJh
Received: by kanga.kvack.org (Postfix)
	id EE4306B05BD; Wed, 11 Nov 2026 19:31:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94F96B05BE; Wed, 11 Nov 2026 19:31:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAB6C6B05BF; Wed, 11 Nov 2026 19:31:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0A4A6B05BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:31:29 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5758A804C7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:29 +0000 (UTC)
X-FDA: 85424588298.11.20D6636
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C1ADA180005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mrWiPdJh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794443487;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9S+6EWuhGnazR//mbqE63p2Ta/W9cmMlZEk741JVhmw=;
	b=Gdi12qXKMSKuxZ5MeYZY4BzU/TQpMYaRn4NYO+qpIkN3ufHYTqCodRsGyjXKG4cA5JYYWO
	0qgWVt271IHASZ6TnBi0/hxIQ9pw5KO6QBviyvae64x6XyeZXurZNa/xRwlzUdTBvEJ5wg
	VzYw35gMxCIXZJ8VCk+zqWMLrNPbfE8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mrWiPdJh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794443487;
	b=58mJafDYD+5rGKn0z+3mFqdMTeUByi2BqxyZMzSwTqmS+6NtRCG4vkVsGPgBeBECYtut4i
	c4s8nsYsfoM7YSkoLt9cg6RkZBT3MGw5y5qux6VNplhCwqg2o5GibyV9qSJKUGDjoSDZTz
	RmqVYzax9Djt3dS/6u7CQLtawcqq2q4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 636D160052;
	Thu, 12 Nov 2026 00:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 743251F00A06;
	Thu, 12 Nov 2026 00:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443487;
	bh=9S+6EWuhGnazR//mbqE63p2Ta/W9cmMlZEk741JVhmw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mrWiPdJhaqCza1/1sKjJRctS+Tx+RhPrix0WaN4ThJJcTOzoUJZSgZX/nmuNOiPl1
	 Rm+YK4M01c7VW9nPXRbkuyJpLPf/fjUiMSQGvvEyBacPpZPvAHxDlR/4TDcd0UYp0n
	 MN5p5MRBcWsheu4s7K25e1ysEAJGbBoV9nf28d13GRGrKwq9drszEJcbe2aGo/L/OE
	 2IYAQQLuhQTFVnH92SJAOGmWJwd6fT9AEXIO9fa+hopZjGq3Idw/mzk6uXKawKOLUr
	 UgbOXn1GWghuYdLYjVYcLrhkAN2jCXtMBKvMPh8fx8opFoNTAXPDGCu57CCEB5uh6N
	 96vfOyPb1GIHA==
Message-ID: <sashiko-outbox-209946@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 14/19] selftests/liveupdate: Test which tmpfs files
 can be preserved
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
In-Reply-To: <20261111002358.1842967-15-dmatlack@google.com>
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-15-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:23 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C1ADA180005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: b8n8gey5815f5iabnf4mk9e1g4n41ssm
X-HE-Tag: 1794443487-393184
X-HE-Meta: U2FsdGVkX18rDynhy6NBlS099dVL7q01ldpy3EXetNwLxx3/SrZwxG45hKf45nrIBw0UHt/Z2ZWcXcRf7dwNaZKrCmNfdXG6NRvhF90+VHIZCbWnaQeSEq6bJn7v+8KP0cGQbGId7r2BxmVwR1T0xt4pvZVW5vz/jl+FHDLsEPTlpYVPwx4r1Z9uPztduuWuiKKs2gYKSlsxeMWQQdJHCYOPl5y/ytULQgx7lbKqV0GrpM2sZZa0DEy0YpE1tj9KqZb096kD4c66FMrji47iMvCM/c4C4Kzkoi3zZdwp4eVIQXX8hNIerv5gYTgQkbdfw9OZeloFTk8jJFnNf69eNIEx1bAoVf5fFO5eyfZC8ILk4X0UYJzgcvaAlMx81i4wxty5HlIQE9PcvFfKLIA77PcH+60yyTQdFG6qO0WEmrTRmWeOxqE0ZSu9d6w8H5/yVTZ/iS3OPu+v1U7y2n97eTxNYVQ1qebbyd3ZH3FcFJwVfsN2zQWhuTGtxkQuLwqJ9KdneGAO02XfG9VnE+utDQxL8GPqWFfbas0VXCYE7Fk+yaucgriV5FKjnXUX9nd2A3ysk6fE9D+fPIbSLGtqGDcmWoTzUWp+itIsXgMc2dc5DdA02wVKqlE8K/hrwZBKRStv3/4mkAu+zlWbwRzRit6Qxxg8Y82OyEZWRnz5DLXwUY262Tz5AZR0pkcBxTJBWsLirJP0LuG55hYu4PKf6yAGGSOPuLB1oljy5H6WrzizUqRq6Dj9WKbkJIQ4fcB+T5TiGqYO33AXBfJOHEOTrEAyTvkkW1wmO20/2PmyoWddKyiWo92ktf7s3iiYqfuyhwsMSFk/bj2DwYEVfqx2J0DaU41Yd0B/V9cSQBS8PDLMrbrtabCnAGRS1iePJts27f702o3bb+GYmBzL2pSvHBLP907kxLGFuzGP7aellAJZ3jonKAhoaDvgrk/FVps6+3wqjyILn6luMm6bWbN
 XQC5G5VU
 dED6sbBEahcmcFjyFiPZ8YeIcUtjI+r9wHM/fCHyIUjM1whZBvht7pWmreZYNvXXZKJBbIXYVwn0O+KEIaGNYZQe2O7hjc3lcp+WOoD+av5G3/PKxfBoY90AdHHMD9ddcIm2GEe+87n1838LR1mOJ6HvygpPj6r8UOv6cQlRoFZt//wEtHjjD5oygWi8ArATmPdwZvdedXWRdMfpnRNa0EiaoWmUQ126tZ4KXwImhPOEptiK+7DZXdcSnj6+BYRUoaZEYBkIGU6aefy4jvC15rn1JA90fgE4Pg6VYyJw2Z+veX0KnJ/ffXP2zPSZCWOrnN35pQwVUia0V118DuNxaIgVniPG4VhSy0QD5wd5K872+s0cFmEQsAEgbg3kfKwJaVk16zArptxvN+WpBbLMtvOfoIlnISCxBzL5OBhDb7268otbLlR2J8Iyzx5VscqCBdpjBmPLCR4Snb3zCnEZl9rs27prx905tgN5+ftjqhw97NUcUQ9mdFlgGUXblgxT6PRrQPDCO45S54gDtJMdX9m5Fkg2ge7CkjYVMZVbhLKhziYb8fXJcJW3QxHRK+WxXIAKyx0lKdI+YjCFatkh1NyCUwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] selftests/liveupdate: leak of mkdtemp() directory in
  preserve_tmpfs_setup()
--

commit a1db86a2ad704903057c01aec8aee9743875c417
Author: David Matlack <dmatlack@google.com>

selftests/liveupdate: Test which tmpfs files can be preserved

This commit adds selftests verifying which tmpfs files can be preserved by
liveupdate and checking that a preserved file's size remains frozen until it
is unpreserved.

> diff --git a/tools/testing/selftests/liveupdate/liveupdate.c b/tools/test=
ing/selftests/liveupdate/liveupdate.c
> index 4c4272167635b..3d943b5672e6b 100644
> --- a/tools/testing/selftests/liveupdate/liveupdate.c
> +++ b/tools/testing/selftests/liveupdate/liveupdate.c
[ ... ]
> @@ -574,4 +583,298 @@ TEST_F(liveupdate_device, preserve_memfd_with_arg)
>  	ASSERT_EQ(close(mem_fd2), 0);
>  }
> =20
> +#define NOBODY 65534
> +
> +FIXTURE(preserve_tmpfs) {
> +	char dir[32];
> +	int luo_fd;
> +	int session_fd;
> +	bool mounted;
> +};
> +
> +FIXTURE_SETUP(preserve_tmpfs)
> +{
> +	self->luo_fd =3D -1;
> +	self->session_fd =3D -1;
> +	self->mounted =3D false;
> +
> +	self->luo_fd =3D open(LIVEUPDATE_DEV, O_RDWR);
> +	if (self->luo_fd < 0 && errno =3D=3D ENOENT)
> +		SKIP(return, "%s does not exist", LIVEUPDATE_DEV);
> +	ASSERT_GE(self->luo_fd, 0);
> +
> +	self->session_fd =3D luo_create_session(self->luo_fd, "preserve-tmpfs");
> +	ASSERT_GE(self->session_fd, 0);
> +
> +	strcpy(self->dir, "/tmp/luo-tmpfs-XXXXXX");
> +	ASSERT_NE(mkdtemp(self->dir), NULL);
> +	if (mount("tmpfs", self->dir, "tmpfs", 0, "size=3D1M"))
> +		SKIP(return, "Failed to mount tmpfs: %s", strerror(errno));
> +	self->mounted =3D true;
> +	ASSERT_EQ(chdir(self->dir), 0);
> +}
> +
> +FIXTURE_TEARDOWN(preserve_tmpfs)
> +{
> +	if (self->session_fd >=3D 0)
> +		close(self->session_fd);
> +	if (self->luo_fd >=3D 0)
> +		close(self->luo_fd);
> +	if (chdir("/"))
> +		return;
> +	if (self->mounted)
> +		umount2(self->dir, MNT_DETACH);
> +	rmdir(self->dir);
> +}

[Severity: Low]
Does FIXTURE_SETUP(preserve_tmpfs) leak the self->dir directory in /tmp when
mount() fails?

When FIXTURE_SETUP() exits via SKIP(), kselftest_harness terminates the test
child before clearing *_metadata->no_teardown, so FIXTURE_TEARDOWN() does n=
ot
run:

tools/testing/selftests/kselftest_harness.h:__TEST_F_IMPL() {
    ...
			fixture_name##_setup(_metadata, self, variant->data); \
			/* Let setup failure terminate early. */ \
			if (_metadata->exit_code) \
				_exit(0); \
			*_metadata->no_teardown =3D false;
    ...
}

Calling rmdir(self->dir) before SKIP() when mount() fails avoids leaving the
temporary directories behind in /tmp.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111002358.1842=
967-1-dmatlack@google.com?part=3D14

