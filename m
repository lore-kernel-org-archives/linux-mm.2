Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8BFCA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EFD88E0037; Wed, 20 Aug 2025 18:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C73C8E0031; Wed, 20 Aug 2025 18:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8041A8E0037; Wed, 20 Aug 2025 18:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF0D8E0031
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:47:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1354AB6512
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:47:05 +0000 (UTC)
X-FDA: 83798622810.28.D0107B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7D6A1160007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:47:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oBjyg0Qa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755730023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iAtKmcPJYkLzUrxMfIhiIRPwepJ1ikSzqdktzgmsA+c=;
	b=0lWHk/XijnHkuY/nVk56lHdPMA8YA1/ChR04gOeDc5PGmTRXwHH9TufofQqzqwvQsJznnL
	35XV/FaCIOqc5PB6v+v111o19mwD+JwQmxJLCb5QD6lfbFJ5sO4w1ypCEsf0cBoHfRSjx8
	uaGPQY2hTcRhvRSgb3RAv9BnQgqFRoM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oBjyg0Qa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755730023; a=rsa-sha256;
	cv=none;
	b=dB6qaR3ABx8wbTeaEnTSqDcPxE1hFsavbfiq9TVNzdyQA22zVJ+iPc0dGUTcDkY/sVEgGz
	i4pE5urNAenfPB9FaeQt8uBOWAk37UMrx5phyvcR/7/9sQLOn2pGtTzdWM4wfuLOrGmT4l
	aK0E2pJYHsMLOlwftureK9FQOHiLgQM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D528E61444;
	Wed, 20 Aug 2025 22:47:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646A5C4CEE7;
	Wed, 20 Aug 2025 22:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755730022;
	bh=JYAqFozgqm8DSkeK9/y9X/fQKyqyYyCZdbwnzw/DShQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oBjyg0QaMLODFKrWIxK8jt4BilAkTDYlHHT2ZCphU/ZRw6tO7Yl3yv5aH9/0NfIj7
	 HFIgjXEq10jntLjReJ8P7mZalS1N8xQM+zEvzGDPN+RptWiAOlYjJq4cD7Tg39rrse
	 vdDNj50iY6jJak5T/htNp9lU0xRsP12IwDYKgv2r5rsgRBEbMm8P2siQgy6zE+8Row
	 C4O8+8qJ7H1E+ITBF2r0jMwtyBWp8DaZrLiLVKHqWgkK63I+hBv6VYCcGOB6Y+Ixjm
	 HSeoLr79uYsJPhAuDV+xv0zlQMIvMmJTV5cMz17ACT8Pk5NIG/flgkZSqu5J/1QjGh
	 mHMjBWr4lPZtg==
From: SeongJae Park <sj@kernel.org>
To: Nhat Pham <nphamcs@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry.ahmed@linux.dev,
	chengming.zhou@linux.dev,
	herbert@gondor.apana.org.au,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zswap: reduce the size of the compression buffer to a single page
Date: Wed, 20 Aug 2025 15:46:59 -0700
Message-Id: <20250820224659.88528-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250820181547.3794167-1-nphamcs@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7D6A1160007
X-Stat-Signature: 9w15ooqmybu1juzoay5n4u7wwjxow8my
X-Rspam-User: 
X-HE-Tag: 1755730023-781685
X-HE-Meta: U2FsdGVkX187nRx0+yazZCMEZqJS/JfTtEY+MD/ntb6825HxP6kNrmJxGn+0decpCagmJDYgzDviv9jy+1rpDubSKZiyvOT5lc1o0bBVBRcVShli2B6Jf/+Wx3Fr/5V2MzmIcRcpOLzoTWTlvNYSk/7PUP+dDlrNNGykb7qWe0f+T99Z8c1epdXRo3b43MR5syrqBB8FA6Bm+9as7kSyC9NjS2Io5C49WoyMq7ollH8CuO25ms8z8YYuk7BXo5pkIr+ODp3Gvx24feUGa/Qkgbk3xg/fs3HElFI3mXd23Xu4NpBXjeOjaKtbZ3/Qzydwu8Z4Niw0+cJSD+7Pcgrp2ZS29odSvNim0tZhZlA6t4nkyN2ZZCm1dGf23XJrEdeqM36PsM76xcyoqz/uzcSqDzSfTHSExhztUGNgPDjVPd22R6jNBMEUwXTdl84pGAI2MeW9r1UwnmLQqB2zHZxUcOwQkPKT52I0VFcKPQVh6miUWQpQqH4Gybe0+tjaqdQpdz+Ia3baWcDeVS+M1xMfoZuiCWvLmtqa4hSPFmx2e90mFOnzBTBEifRpu3vTfjRQpfKBaUVNmH4c8fhhim9sS0nDiYe7POx8HcUK1/Lf6H3ICXxsLmdPM6wr/KxhazMgkH/erhTt3Q7+Ac8HeaHcJdMYospdE/ycOCgPz3bxP3IBWgNoetl+MQsOBFUG4HmHweO//lb90HcnrKU4mgSeIhfbjCVdl6L8iU7Pt7t7oUAFzPk3V1cC+mfQfM6kBVYVrUuUwL/lb7/EeT3jLUtDkLVFzDfc0S/9M7PJ/9ksOXPbqDLXoaZDX1tpnHR8bZciTQR1ojKW3naMZYz1Nn5FSqIvroI2DH1ZmN4FSaGhxJvFTQQyYwRyiWdRMCy/bhUWkfNtarUCdn3EWkA9O9KR43EGsFu4tBdRtcczOUqxCbPFCVsWyS9YcBJjNMmsGHzqTcErY3FYuMHNtipkOj0
 x34/r3Tq
 uvbNJD/3C+XEzxx6+Up/gA4sfBfTbHUkGbIZjh5+b+coTngLMEKBahhU9acvsC5ItZPJJLGWGLMSC2tM40KFZpspxNzuzU1Vn7Lig2p8Gzw+fMGVkYXts71FFR50LQtTqtcQJPx5vTT3rbuZuvQ7pwN/HlXBijQ8qc7vkRmz4GcIQtZXIyTqUXSJ/u3ep3FN2Fn1P/NJBjM5nOzDqGQurcMha7bB+NKE2b26HvSBl85kpog6WdYgrUKSd0qZKPPAd3Hsp8OjLm1doZAqxykwOUsljmv7ENKObi5fjTRQhfl0jnAKzsL5hE92HZIsmsuh/e1xdVB5AwnEM787x0TNiOH0MGId8Ma9JmIVXPDvHWu9ACTvULqOKEIwU1j7Vqq8GO0kvxW3TCYTgG9M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 11:15:47 -0700 Nhat Pham <nphamcs@gmail.com> wrote:

> Reduce the compression buffer size from 2 * PAGE_SIZE to only one page,
> as the compression output (in the success case) should not exceed the
> length of the input.
> 
> In the past, Chengming tried to reduce the compression buffer size, but
> ran into issues with the LZO algorithm (see [2]). Herbert Xu reported
> that the issue has been fixed (see [3]). Now we should have the
> guarantee that compressors' output should not exceed one page in the
> success case, and the algorithm will just report failure otherwise.
> 
> With this patch, we save one page per cpu (per compression algorithm).
> 
> [1]: https://lore.kernel.org/linux-mm/20231213-zswap-dstmem-v4-1-f228b059dd89@bytedance.com/

This is not mentioned anywhere.  Probably you added this as a reference for the
past work from Chengming?

> [2]: https://lore.kernel.org/lkml/0000000000000b05cd060d6b5511@google.com/
> [3]: https://lore.kernel.org/linux-mm/aKUmyl5gUFCdXGn-@gondor.apana.org.au/
> 
> Co-developed-by: Chengming Zhou <chengming.zhou@linux.dev>
> Signed-off-by: Chengming Zhou <chengming.zhou@linux.dev>
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>

[...]


Thanks,
SJ

