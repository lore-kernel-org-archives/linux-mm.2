Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88F36606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KpMV8KKy
Received: by kanga.kvack.org (Postfix)
	id 60A6E6B05B7; Wed, 11 Nov 2026 19:31:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E2486B05B8; Wed, 11 Nov 2026 19:31:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1096B05B9; Wed, 11 Nov 2026 19:31:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC6A46B05B7
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:31:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AFE61C3CAC
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:11 +0000 (UTC)
X-FDA: 85424587542.18.6EDC96B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 83FE21C0004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KpMV8KKy;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794443469;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1EWFO17EH5oEfTbKye5xe/8R6ziLPWTGMHOqE213Ii8=;
	b=qRRu2x8cMbjzoRT2ALGtz8JslR3Pvq0Zt5ohU2pTrppW22PRfVUvIzPQ6TWgvsGhc8QYn7
	qeJpogiOKF/AgsnTOjoEU8LowIwo/ZMl2JfxyJ4Wi2wK273IWQh3e/MkjQ1K5dVJ7juZZW
	3xz4lPP+CadGIarEp8Re5ymf7DX0WMg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KpMV8KKy;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794443469;
	b=ZHDriko2sHAdx3IdNlBczmGkxJ1zufnwz30PX7XS0er5wMmdINrJpvzJheIhLpbZdN/q8l
	en6xeFXzEeGoeD65y41c1pDMDH5Mk1GAwSggHFvr3xXq4imqZEhXVFGEf8NIrgsw+neqGE
	XRiYZMp+dOHOT28B+AttoQiTsij5hFw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 790D0411D7;
	Thu, 12 Nov 2026 00:31:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5787E1F00A05;
	Thu, 12 Nov 2026 00:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443468;
	bh=1EWFO17EH5oEfTbKye5xe/8R6ziLPWTGMHOqE213Ii8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KpMV8KKy3ExuPz8BSRcFqJoM649LkHNNm3AjBPoHebwZhovEBnuWJv0kTsTkHLDPt
	 vmteyTfkrXtm7gQtzW0nprpYezjzRXmcoJp/7W+HVxZ0p3qx8N+vvES9mIF+t3kTt9
	 3NgLvzrfJHhu6PASnPCpUeoqW6XIo/2BUgyAllDb0lESL3i98DKBTxFuqQ8AU9FeEG
	 nkHBq+SB26NuHjl+kUi4dWxeSsMrKhagvsoYg7j4fDg7bgSYRriBxUw69krukYGmXb
	 Ho8Sp9u04yjdQrpa5iyFU7b0qpGUA9La0fcCLclGdZ5DF7Jn4udDnbrEsSEowW+DrP
	 5VGLKwjMR9tHQ==
Message-ID: <sashiko-outbox-209935@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 03/19] selftests/liveupdate: Add tests for preserve
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
In-Reply-To: <20261111002358.1842967-4-dmatlack@google.com>
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-4-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:06 +0000
X-Stat-Signature: f9g7jqia537ch4yyzc1jfj4fd3p69e7z
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 83FE21C0004
X-HE-Tag: 1794443469-609586
X-HE-Meta: U2FsdGVkX19okC9zGEUzvdQhxKCSdk9u8QUMQXzEeH66sr3IDLYYT5eQ8d1/vsv39UnPp9j5E761/eBRatXCWi6r3vRQd6ws/R8yKDBx68KlKOen+S50kSE/9OEly1/MxWrZB78wuZypaKxw6XWiPcqTU0A4mClOmC9+8UFrHEPOuUT9AjEllB2SLbGhxINDtPJdf/zoxi9yQEwaWrhY/U2bbGYF7whdAiCi5UwyCeKl4z32+VX8xoh70rO0FY3+feUoZHmdT8AyFeO4HLsSQeWUo4YnrKXOovzsLUcF1gl6G7MsMCM7fiAjX7ybVGzJAt3iI0SFuJhLgTCN1Rq53oDnltK1h1Qbp+aeLDImxVA86bg5Vn4yXgllXM1Dx6capUYVVbrFdWLrNWGmVUmWMj8RYR/TtOfC1JmxQdnvjfF4N0dH7c4g+rgzsaSvNCHvvS7hy+zkVRhjmBvC/ARITAi1wtTWuHflwJaCkkFq+3gJ6gh30wAvecT5dKnD41q8SMLGEhMIdiQxFDz4xJ4iOwlIpxphXMtungMMlO2fZZZ3SEIXrSx5KVvl9jOCwPjtvh1c6ZQxTUEhuMYcm33yNpmTag4X0g4PY32VVQMb/VFrdMVDqNoy7rA0CzvfVDVof03lreBBnylBML2SCuYTZH7ooXbFBsD/CgFR72V/xsW/GRVyQKaXYPuRsgoarmd0TEy/WHqaPhv+OTynKKobkgvIvXUN3Sa1VeOrIpgrBJZwpZjXGdNybIaDKtvv5kyLoz7pxiGV6Y++IvvekBzSJSfxgnviNFzKgHxlECOHOc9PqZfu3CTvw6/UY6b1sQpudkwlxEBwmbeph8C9q55wSq+upnJw9TviuF9jwhDzL0dUGeeUIsjztjy7q24QsvwAFTVf+hVdDFXF/X7C02nUjfc/RHRPC7g0rhuKCEm1orvVgkbKXibMd8Efb+FpP5Zkt4L/biJHsz7QamhNGcd
 lkyDxSFd
 QVEQ8MxPtT/4I8Kbe3McHTzNb9SQiG49Bi6Q03P0OSbtY0A5OtVHAMW1mftUeLQyQkIMXPfJfSGDDnj5VP5R/X/VpPeQzC4SJ8gqTsdSpfwFruhDUQ8f3n07TumqJV6hVHYzADKLH/y1MbSrm/duF9THSYgaR8D3QFJ+QTigL60K7x7MxK0JLtdBqsX9k5xAsRs865fmvErTpi7sEtnjLl7B5Cf+rTQv4bGMtwZqcNq89LyjPLibeyaBnC94CNeRxNOyIHXj9If57pkaR6RG7VFz2DpV4MW8HA50t5PbBv4gDM5RGtbWd8+UY/A6HdFlPUtiDBGXEPyUzvn3N5mtf0QqWaAZkkPpmUAat2VrCuR+XFYTOm4JyPEyWf7dMNBkp9NHCrmTyjlg67X5z/AqDTLQ1Kzr8aMHRFMRFDjfL85qGYJws/hvOjeHvlJUS9/Bcq1THE8omnijz2ggk3SYxs3zu7nB+miK+vQnmYZyVjcshmCz+2OVgMOzKLivn+eCqV09jKVp2geAOlIBywUGPNTSgoCv4Ci468lfJ8+FEVEqYPWnwTLmqkZl/aoT02OQsNRSkqzfkJbz+xZQLFD+gPxuCeATd/U1rFmg0BRA27WUlWeEuIb+APF/Hv8D4HkwGeErlMMe+l0ZfrMk=
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
- [Low] selftests/liveupdate: zero min_arg.arg in
  preserve_memfd_with_arg()
--

commit 1a8c90d14c1496a0314a67c567059709fa28b4ba
Author: Pasha Tatashin <pasha.tatashin@soleen.com>

selftests/liveupdate: Add tests for preserve and retrieve user argument

This commit adds libliveupdate helpers for passing a user argument to
LIVEUPDATE_SESSION_PRESERVE_FD and LIVEUPDATE_SESSION_RETRIEVE_FD, along
with a preserve_memfd_with_arg test case covering memfd argument handling.

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
Should min_arg.arg be set to a non-zero value before this ioctl() call?
Because min_arg is zero-initialized on the stack, min_arg.arg is already 0
in userspace, so this check would still pass even if the kernel ignored
min_arg.size and read the trailing arg field from userspace.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111002358.1842=
967-1-dmatlack@google.com?part=3D3

