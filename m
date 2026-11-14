Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25DD8606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fVSckOqK
Received: by kanga.kvack.org (Postfix)
	id 30F666B05B2; Sat, 14 Nov 2026 02:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C05E6B05E4; Sat, 14 Nov 2026 02:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AEDE6B05E5; Sat, 14 Nov 2026 02:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ED8966B05B2
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:23:45 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AA42C0282
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:23:45 +0000 (UTC)
X-FDA: 85432884810.03.4C10C11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id CB60AC0005
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:23:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVSckOqK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794641023;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RrG3cdqKscMUKJ7tc0sEjXro6AUhZoj7jdiCwgM6e34=;
	b=oIAvSNEq2PNhEGmlmDtS3JJFog2tuvYU3HGDI1V8x+rbVW4lYGIIa3i28+NO73xVaAFj6u
	Nlxm3Gg1f9vxLlNUD/PAGsxscqPD+0HBbhE0N2qcm19SSCoIQlWhvcPzdL6aSFV8Wz87Ta
	s3FBpFWcmOgVVjUgOn2e0naQE3/JQUg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fVSckOqK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794641023;
	b=Bq2f5rbzBq0Wyx+6doGvn9B5r7xSgies5b1LmxF6gfqILDp52rrE2C47N0Wg0+ckix0XHH
	Wxz8y+9QmcUTBuR3Pv7/ub12ZJDJyfRsIoamO5Yd/Ht0vzuIjejI1OB4Ir3kjuVUo36yTO
	Wo1gp1Wx8loUq5bF4V8J9nHeMLM4hQ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5636E434DE;
	Sat, 14 Nov 2026 07:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5B911F000C4;
	Sat, 14 Nov 2026 07:23:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794641022;
	bh=RrG3cdqKscMUKJ7tc0sEjXro6AUhZoj7jdiCwgM6e34=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fVSckOqKurSf6J1Xo5Ec6DPeX6fg94eTu8pbhi3+8o5qBtsvp6j4P5V/iJrxCGc2f
	 nLcpjKLKRxBnv1MooFfC5c5kRuS5xXtixcWtm9RW/Cm4smrTLqs1EY/wXrUvltiGsZ
	 jkNkgWMT/CBqSjPxOHQKyj+yK8D+SEuoxujawrsiJLBm4GUXQYr9nZdkXMo7J3EvkS
	 WsEFqpWubXGKzVPheBL9NF2KUkyl/TTP0HbDTWwCopOrgQpUYHvO6aWwavM7otRo4c
	 7nN55V/Tc8hkgZZDVoE0QbLSV8xae6M2i58XVZgGuVBy+pZ0t8I/OsK2Se/Py6vjYC
	 ZnCzONOQQzooA==
Message-ID: <sashiko-outbox-214263@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] selftests/exec: check malloc() return in execveat
 concat()
Reply-To: sashiko-reviews@lists.linux.dev
To: zhangchujun <zhangchujun@cmss.chinamobile.com>, kees@kernel.org, shuah@kernel.org
Cc: akpm@linux-foundation.org, richard.weiyang@gmail.com, linux-mm@kvack.org
In-Reply-To: <20261113072313.1723-1-zhangchujun@cmss.chinamobile.com>
References: <20261113072313.1723-1-zhangchujun@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 07:23:41 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CB60AC0005
X-Stat-Signature: ggt1xbcfcyny4jzgd51fn6k1fsgjaoe3
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794641023-311641
X-HE-Meta: U2FsdGVkX1+UBbRhBF7tXmfgsOnm3cyxSDBvIB3qddUJEJxEIYHbsupK+KUqf7FtwbqytVnX1fztsTZ9ouV0bMPPwveW37zlyHUucYDZX9ZuIpG1xOMTWEF+cMuNokCGG7YM0AjybNY+MQe8jO2+GwfuCbX7xPQWzLlDjV3yFues8zMs9hnGwm0lqgC1avqsUXzhxWZwBfLH3Oc4BLvdyy1RTUGwyKBAGym/v4gL28QIn7+Px7aXkrTmMqwjKVxwl8t8Csrw4Bs704ulWgVpFRjoeXjst3U2I6R7Je4jb4xvsCa2r30gteQosmft0mwES5O1K1LMy3zdfBs+5zPshSkEeH7v8L0D2bD6NF8rKO95RjKqcXdN9enat045RSPKfTMhVHIDxRIqORPdtwSfWacTZzT5xTrcdJMn/Owurw/TstVhiS9jb9JkV96VgtVIMC48UB8D1DMmoj+t2nJxDiPSLFVpZEi38YFddOS3T3M2k7HnOfCYCMaQzLj/N7fAhbGAhC36e2fjEo9uc4TRqSi/0ICdX0BzrD0iwrFK6bkhBcD02EQw9rb76wAvvh+3iBDKSEP3PM4Ldb6wRR8YWvJuHzCWyZ/EItuxyr8JNK3PXzu8DmN8w6fJerYTh+QQDkl6DgZjU9LF/Hnomf7fMjSVBodcsI1kP/IWmqmOsCiTA4g6sdFoMCjDrsbKudqVtNSB62N2z2qD/ifSkbN7SkmmbDiToOF8BHy+rdGiorBe9SEGHUjQnvnB4qbamI1i7luZ8Xt9Acx1swd28lkFUg++ZDsD1GVH8RorGEGG9kvw+SJmb+OtuseVu4N3fPHD1QTdZrTRvdDuGKhnJGH08srVgwiK1UbgSdxPFaIeuB3u/pzqr42mvgJuIZJUVwbdtAa0MbI2DwtZN7XYrhynSqjzENPMnv/D1PWfZwJlXkA8uX36XIy9CxYRqysRoyUaj9O7gdHC3zSapojfVCS
 HjOHcDHs
 k17BccI00/x6eXgJX+UBJYpyeDFZOJsD80GIbOwY75T67jVCY1zt9QyEgMW7OFjY+XEILo/5Kn9Tq+dFDFD6yUhb+e48KzG7gfnzqBUSsMaQJVqzhKzEkGvL5ACXsxAR7mJIuunfESI+pO0frgX0JV0IZIBHoeqs/CALD12aICTGS10ice7xPQVqdIebXQeJCEHh9VWX2Z+WOZbRxYo7G/RlqVdxMs8q4655zlPInYZkEvUTwBi6wW/zYNH7lH744rjLAFA+A3i0fk5wZOmJKjjUqCZh3rn6YcP4tf+JAzjNP7WaaeKkTtwkI3s+zONnpU45r78p5BE1VpfXdd4DfwTiI7avmRi7Vav8dCfLDYZEyKi4FL/Kd3rBkUGrGSAqdAXWVzoSLm4lnQdRS4wx1I2NjqgvUZAImuJ1LpL5YqaztZ9l6/nrwz9ZB8iJ2crmRIAp5fwzA5zwU3218/2RpqgeiiCy6G9MVO7rOEfCejDfLaeoABm5yM4a8t4DcAEom8Kd1fHSoAtRV6qmtrGwvCLeJIXr+ZU3oWLSw4Vavm0LwFFblM058DFQ9VCFVi2EGuLZSCkfrKlR4tVyWHtFe2Bf1RuSWuOjaHOATLmWzGE1ZsdbnZ/2yXcBvBU36LdJub/8Xzv8ic7n+k2NI9KlfTJGvyX4i6gbqOzCd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] selftests/exec: single-word username in Signed-off-by trailer
- [Low] selftests/exec: missing Fixes trailer for unchecked malloc() in
  concat()
--

commit 1c579e8be1fe05d3235ea43d298729637c25d600
Author: zhangchujun <zhangchujun@cmss.chinamobile.com>

> selftests/exec: check malloc() return in execveat concat()
>
> concat() strcpy()s into the buffer returned by malloc() without
> checking it for NULL.  If the allocation fails, the helper
> dereferences NULL and crashes the test.
>
> Check the allocation and exit with a failure message via
> ksft_exit_fail_msg(), which is how the file already reports
> unrecoverable errors.
>
> Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

[Severity: High]
The Signed-off-by trailer and Author header use a single-word username
("zhangchujun") rather than a full real name.  Per
Documentation/process/submitting-patches.rst, the Developer's Certificate
of Origin requires a known real human name (given and family name) rather
than a single-token handle.

[Severity: Low]
Since this fixes an unchecked malloc() in concat(), should the commit
message include:

  Fixes: c9b26b81af9c ("syscalls: add selftest for execveat(2)")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113072313.1723=
-1-zhangchujun@cmss.chinamobile.com?part=3D1

