Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C471606A327
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ukw/YXat
Received: by kanga.kvack.org (Postfix)
	id B11176B05E0; Sat, 14 Nov 2026 02:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC24A6B05E1; Sat, 14 Nov 2026 02:13:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D87D6B05E2; Sat, 14 Nov 2026 02:13:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7ADE46B05E0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:13:36 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13873A7D73
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:13:36 +0000 (UTC)
X-FDA: 85432859232.28.803A920
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4512580003
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:13:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ukw/YXat";
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640414;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2yOuaC5vZY/Cg0ZYrSDveIBucrJOwFIorRf7ht0Ka0=;
	b=s92p/+YGCBIdYTXBJE2NycqYM0KGVEIU3y3FJLokUAZy9DlUPZCJIWUovQhGu9ge/UCqIa
	UYnxeHIZQ65+RjzChJQ5VyQty0YED8OHlRxRJUBL4QZSB6YAi+rQHVGBmEYN+3pZ+mil0I
	nQELlbS4H07ZlYQ812Y/4+jHJvSsadU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640414;
	b=A4O4DRChJ1+BinWoiu61AZaMsRG2K/ghd8LZbDrCHEJ20Fq09DyImV0uAxgHFDKXMwtp+B
	gI88UlTIXM/8C/YhZpcEbGXrOllp4CcnedhFxKYkfuE9Sdv51RnKZxk4+xz5zA+Dd1h0CC
	oAD/bRZrYd6qzJAXlNPic06uCvsVFGY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ukw/YXat";
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50A0B60C02;
	Sat, 14 Nov 2026 07:13:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C681F000C4;
	Sat, 14 Nov 2026 07:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794640413;
	bh=E2yOuaC5vZY/Cg0ZYrSDveIBucrJOwFIorRf7ht0Ka0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Ukw/YXat0UTtusqWWSmOJe7aAFFb4Q241JhlbsrUixkUfFMCOc5/9wWLkjzsTyTFZ
	 QWLj6VOACLYgz+3EVfYXNpaKib7wDKvTgy7taKFZvi2jdjPtcWXwlrAtcugSq4cwzH
	 ZSo2Cgah4+DdwzAAh/IVze5wK7G89LrWny00vZMPtz78tXxH/Sd8DyhmCkB2n/Mpt/
	 osYJeWcxXVfoajmcYssLTsUTOB2jh0zkQCwUe8HlDQNsyG2rwqoPQDkvhCWYYbBxRP
	 u1xX2zJLjVFAQcg52uAKCku4Z7IDUF9w8DSB4/0glpmtn6Gf7QdniCB/EgKXO570up
	 79sN+Lq8GqfwA==
Message-ID: <sashiko-outbox-214241@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] selftests/memfd: close fd in sysctl helpers
Reply-To: sashiko-reviews@lists.linux.dev
To: zhangchujun <zhangchujun@cmss.chinamobile.com>, hughd@google.com, david@kernel.org
Cc: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, shuah@kernel.org, linux-mm@kvack.org
In-Reply-To: <20261113071306.1673-1-zhangchujun@cmss.chinamobile.com>
References: <20261113071306.1673-1-zhangchujun@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 14 Nov 2026 07:13:32 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: tnmp7fi8ywyba1r38utt8jua6wh16wix
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4512580003
X-Rspam-User: 
X-HE-Tag: 1794640414-611465
X-HE-Meta: U2FsdGVkX192MFzoSvSwQqdUyxQEJDrtnB+bNfZdZ3B6PlMuBc+KJBSANHnBJQGdB4JjnS3kCcpnmhfezVufVPjLdlFe1lLRDnFWeaj28xrCFvw1uT8OVMrBkNZqQfEFOMVA9hOjTv4s5O0H+oNCq6J9yidsDTIi7em8OycZuGFW5GoOy8ANj60/Rh54Q/GWqW0SlD/Dobcc/85gCobtb7RCLEBI02SKvGGaKPDGNl1nCxwGRjpXNeT1W5HM95sxVhUuUMLQAKskMOh8hTgHmJf8YmfDxVrwi6sA038uB4mY+fy86StoGJqstbfQ1Bre3r/Q2fs99cS55o+OSkHKStl1WB5iytrmRZnt6kBAumSu9EkhF2IRsfZQj4mNPOUqpdCSJ/MWiyDgHTFrLDUJYERBB0EJF0m16JWcz2csh9ECM4jXtlj4cUFiT1dZhfB9KJxsPl7DAoVyetnnWVlGWI7bVsB6IufFS/Gx2FSD7Bg8OjViYlaEyl/1Q2hAwcmon2ZA4FKaUhVL+S1uSQ6gqGfQIDuuXpE2RPgElXCyBVjMSuNzXEyyITKUn5kdaa/bT/WmIjYMzOKhAHo7xfX0MSupFhd1xNmjB9Op9p3dWeRgN/oT3ikLaT2/OdRwbEqbyYwsEpurC0gi6l6NMvpntlRNLzydzgaUrUtuLJcTVTLbuNrgm8TbXo4V1sHscL1d0fIiiHpM/xzs2VrlIclqjq8FvxpgLF69VtJsOqQI52kZ+XLPpqvMysZsj/FNJq6/rRePbVujciW5wFZ1uSqt3tBZMqEBLtZsxRjfrLrel7WysFejoWNFq4CGkM1nei2gzynEyquZw81WjVc6TUOpDMcUQRjjUWsRYL0N1TQrqf71UUQUKdtDVi2P67CpIxaGhssaq7vPz+3JhtnW7gXsmnr8WhcDkhhwAf41/1JwHUYTA/yMrsE6JugcbnJ2j8ivc5gGwaVufiBfLHalJgj
 4oHYCGj8
 t4MxL4elo9rrnHtHaUcv7IDENgIIdGRSPKhF+CUwOjiz6CHOGPJbNBTFoZQCdZBq63oygygrLrtXI+nNIWWAASgkODsED60UIFHvBANrEx+iQcMKHHgbpvF1omdng3VAqrGbMNolN7u/T79jizist6/5sn2RiJRtEK3iYlfA1VhwwEDvUcGtmziA9HZbzU9rLtBKGGvC9Kw7nE3n2UPj9BEs0tACXywWhcqSaaZQb6VbQENdrl29yC4KVXh2FLWE5jW16W8gg7etT3Hw95y9riOZC+GPaMpeaAhdQsZ/47++Q8wGSm+LG/3Uwu5X0K23ouFwV0eN4sOimqE5x/yMLlnseFiWRXWHesmAeOJX7YHtDaew1A1LXGJPI9bvF0vp5YSgRInL850kPdteJBvRPnmAjtpGJfzN8OV+Kbms5NQrJXrTa748rrIzOzroSANNwmseFHhFZ8BJRdl+NkNYzeYvQzv+O9pD1LaPAEMTH7T/zhxR8fXIHzO9e0GL0XY48okyMTp5c3bvR01SB/ygD8ov6n0cOSoBmQvVaxqJEXAU2YJ9IlU+VJzjZirDQIhXFLbMEXqPPwJfn1ulct4OM5vNEmQ==
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
- [High] selftests/memfd: Signed-off-by trailer uses handle instead of
  real name
- [Low] selftests/memfd: missing Fixes trailers for sysctl helper fd
  leaks
--

commit f7c1cc7489dcee54b6a1302dc52c7e84f82859e6
Author: zhangchujun <zhangchujun@cmss.chinamobile.com>

> selftests/memfd: close fd in sysctl helpers
>
> The three sysctl helpers sysctl_assert_write(), sysctl_fail_write()
> and sysctl_assert_equal() open /proc/sys/vm/memfd_noexec but never
> close the descriptor, leaking one fd on every call.  The noexec tests
> call these helpers in a loop, so the test can run out of file
> descriptors on a system with a low limit.
>
> Close the fd before returning from each helper.
>
> Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

[Severity: High]
Per Documentation/process/submitting-patches.rst, the Signed-off-by trailer
and commit Author field must use a real human name rather than a single-word
account handle or username ("zhangchujun").

[Severity: Low]
Since this fixes file descriptor leaks introduced in sysctl_assert_write(),
sysctl_fail_write(), and sysctl_assert_equal(), should the commit message
include Fixes tags for the commits that added those helpers?

  Fixes: 11f75a01448f ("selftests/memfd: add tests for MFD_NOEXEC_SEAL MFD_=
EXEC")
  Fixes: 6469b66e3f5a ("selftests: improve vm.memfd_noexec sysctl tests")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261113071306.1673=
-1-zhangchujun@cmss.chinamobile.com?part=3D1

