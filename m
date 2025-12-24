Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00A60E74902
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 05:38:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E5996B0005; Wed, 24 Dec 2025 00:38:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568F66B0088; Wed, 24 Dec 2025 00:38:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B646B008A; Wed, 24 Dec 2025 00:38:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 348236B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:38:43 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F132B140619
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:38:42 +0000 (UTC)
X-FDA: 84253260084.30.37464AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 64488100002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:38:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cOP6F9fP;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766554721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93MPd6uhSvvxoTe5ibofbBzjvhs1xZ9z3W3j6+HZhz4=;
	b=b8DjIuCsgsMAnJELOyeOBv30hvW5D69gbM773hamKv2e/KuVymdNAzCQ2d49S/xSB0h4rQ
	AVzzYtgKbP5EccywNfSavgnxlmeZqzXrTInoH9/DIhaG6mD2mcAeE2m1UJ09/T/bUcs4gs
	yV7sH2ahRMA4L1AxFhVzIkOvMtuSz9s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cOP6F9fP;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766554721; a=rsa-sha256;
	cv=none;
	b=lGssfYQ28mi00IGcc/GswgpWl2wU37R19ldPRUbG8JC3v1xGggbhRG/Vjf7T+UvuakYeug
	4cEJ83tnzn/69PcHaKl38b/VEhazK3Nao/3ilADDykRxF+zrzFHXYzv8oCS/+lMIE6WvxY
	J0rFZ53eJ902zwJE1fK84zwkTTgHFV8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CD42360123;
	Wed, 24 Dec 2025 05:38:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF29C4CEFB;
	Wed, 24 Dec 2025 05:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766554720;
	bh=p/zI3MMRNaUVcNPNRBOBmlYid0Ap95K6FX4Ax2CKavE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOP6F9fPT62XTPWlqvxxYwPnRkNcbC9f3l1J8sFT4R/M0O1Aj8HcOWNezsGaMziFo
	 lESJ9Ytu6qkVVVUY32u3hXnXY8b5HeF8aPmJvg7MJgvLL/QaP2BvuFmwx9BuKCVFbv
	 TixzBgf1OOjP4fl1/5XPaD/tuWap3aFEm8SDXOZwVIVUfWsQHq0JmgBZ9kgKqXEwiJ
	 6RyFPPdXOUsrEtcyfzJ0x+Anso6/IUgkS08O+mgigLRAps8t36Z9eCXpD73Fvh/iwh
	 RGBxek0X564tpsC1hAkBc2J4pQVGLsuf2muhKo/tUbkBZsiWHDH6tNJuOJFYOxHK2h
	 pEFVNUUgcqNJw==
From: SeongJae Park <sj@kernel.org>
To: Shu Anzai <shu17az@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] mm/damon/tests/core-kunit: extend existing test scenarios
Date: Tue, 23 Dec 2025 21:38:37 -0800
Message-ID: <20251224053838.82114-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251224042200.2061847-1-shu17az@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 64488100002
X-Stat-Signature: y9gb7k1xdwe7mw47d7srd98isy8jbypg
X-Rspam-User: 
X-HE-Tag: 1766554721-954589
X-HE-Meta: U2FsdGVkX1+r2vufMaosGm+q2Qy5zhNscBL77MgI0fH8elo1vOKbwLKn9+TVSCb5TKxv/89eIEm9xjjTR6dRyeyWjjnWH6WGKagCVsRPBEIhUGI1ZDjlkdTa01uKozxXBOwNb4z71i5NsTtZol6jHky98P37VUZY/U5m8UgkXQt8YKvmy42CkORGYmpptNx1V3OgqhlzrqfyUu7LE7bPn5+CPJnyHfjFRremDunriR3V8TcpjOhVySZfU0hZY5vvCzies4Uhv9wQ7Dw7fJjebRlFQ3akH8xD8Gm+7nDu0iFIgB1/n+aDNr0GwnhCyFe7Ra9YD2kMP9LiNi4CJVY8FJRhxgg2lHUzr+BkGD67LsUEfWax7D79m4zkemQCJFuSUVtiY9aCP1yQ4FuVbMWQyhS1qZMrZ/MBxIuMwahcHl/L4Bjn6j7/Vvg4U2l0MsNC16rzarlKMTijlv6Ugz+03SmraPwYaIzBSNoNxun5MdHsvyyyeYA14t1vd2TWCkm8uaKVmz3aV5MPPjVvPDZa1sVX+tFPT+8yOUDFiVID/qHmo0MpeNkmaxE6/fFJFWF1dr/0XyKPBq2onljW+pMsFjDiVauTROUkiwSNXfUS4cIZ/fJnNLmNlAgCmkxK+pAtNzDqRYKE/QLhd8YjhyYNpoQnzK+AU9UVQpqLQCuUrpVGPPm22IXgV3wfE7dsVnB5zCxxHW+SOyjnMO170tI3mGgwCyerLls7XwpOFuYXhEzn1f963u7K7F65530Nu9K3SMfxxS0Jh1Rj/qK9zCuXavoas55t8dVIF2oAGnNOYfSFAqaWl38wjnk1YffWQRjSgryBvNKVxKVgiKrPngW+QdP2Zf3GpYUH+TvSG0KjEeZ9nsFitMP+hrUSiWRKwF2Fz78OpX4jhsb1UjElMjglwGSgPdsKx2QB0sbw48NYf7IUQILEeRSmeE6HKSQJr3svguxwQqOO1Mdl4cpuf5r
 HiHvrNEW
 ZlVWWEoDCG5GN1A8HKb2Dz3LYgOcTaHjg1RhXNwLdXHE+6azZwgotNSjNS+vNMJdJnMETBn8Gg8SwsohnOQbmK8VGlrAxgtpsH5RApDCmsnGoJTbP21dtmfLI9t+nCF+wVFT5H0v6BWMZeB0Cjyai/eo7xRSfMvFCLI6byezrLKVmpADj1LY3P5TVcVlBQzgJi3ueD4Zmb75d2nk0U7GJKNxlndfeMSSaYcR9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Dec 2025 04:21:55 +0000 Shu Anzai <shu17az@gmail.com> wrote:

> Improve the KUnit test coverage for DAMON. 
> 
> The five patches in this series respectively extend damon_test_split_at(), 
> damon_test_merge_two(), damon_test_merge_regions_of(), 
> damon_test_split_regions_of(), and damos_test_commit_quota_goal().
> 
> Changes from v1:
> - Split the original patch into five smaller patches.
> - Remove a newly added region from damon_test_merge_regions_of() 
>   to avoid an obvious test case.
> - Restore the test case in damon_test_split_regions_of() 
>   that was previously removed.

Thank you for revisioning, Shu!

> 
> Shu Anzai (5):
>   mm/damon/tests/core-kunit: verify the 'age' field in
>     damon_test_split_at()
>   mm/damon/tests/core-kunit: verify the 'age' and 'nr_accesses_bp'
>     fields in damon_test_merge_two()
>   mm/damon/tests/core-kunit: add a test case for region merge size limit
>     in damon_test_merge_regions_of()
>   mm/damon/tests/core-kunit: add test cases for multiple regions in
>     damon_test_split_regions_of()

I left a trivial comment on this fourth patch for unnecessary braces enclosing
a single statement.  Other than that, all look good to me.

>   mm/damon/tests/core-kunit: remove a redundant test case and add a new
>     test case in damos_test_commit_quota_goal()
> 
>  mm/damon/tests/core-kunit.h | 50 +++++++++++++++++++++++++++++--------
>  1 file changed, 39 insertions(+), 11 deletions(-)
> 
> -- 
> 2.43.0


Thanks,
SJ

[...]

