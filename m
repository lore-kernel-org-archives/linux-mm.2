Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5681FFD7078
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 11:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C18E76B0005; Tue, 17 Mar 2026 07:01:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0256B0088; Tue, 17 Mar 2026 07:01:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06116B0089; Tue, 17 Mar 2026 07:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2A86B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:01:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4127E1B861E
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:01:45 +0000 (UTC)
X-FDA: 84555264570.18.537360D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A29A5180012
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:01:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aADMx9bv;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773745303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXmS1F/uf9K2e8YWCdz9fUuRW7ADqrZoXkHfWuOIj94=;
	b=DLopl66fG7fVuQac3FptiYQ0V3K11+n+YM7Ar6UiVtErA4ItcFC3p9x1OjZ7JK9c7uXhbd
	IW4v5h5YNCGdBhT2l97Kl0kG0GoRyqHK7X0zxnyXhXAWniBihJih/GfIyacIZfWzHDSRCS
	v0QfXBJO5Kywsd/zWuozy3T8NEBkDAE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aADMx9bv;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773745303; a=rsa-sha256;
	cv=none;
	b=IZjxHlbKTYaAiuR3MTLUjD0i/002yFg8iOXPjqhorqdj5F8qkvZOq2x3gjuugqa3Q2ujUT
	HE/QQSU9qyES/iNYITzygTbJrjzmv0H8QUdt9GMWPzOTWR7DCWB+Q9CnUWXmaL1W6kBJse
	QciPh0PjvGVExo9vJvWXnAYiywhv7Hs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B16260103;
	Tue, 17 Mar 2026 11:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4192C2BC9E;
	Tue, 17 Mar 2026 11:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773745302;
	bh=u61teL6ZypykTqHoO//wd/OeQVhD4cwvPtG9zgyMYbE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aADMx9bvjPw8NXr7sHNNk2LtGP7NU2/vA74oilhWuvDE0baQG0UcjJafh0mmxZMOf
	 y1oLs8lzl2nI5xvviCrQnwcT9nbu5ppOnN9Mxm1aRSecLRRBxZTURQwBI0xk6+Nw79
	 IZWYo/12CUVc713o0BWdRYxtKdStuLdr5sEi2tuygiyfFuYZvv6JLEaN7vprsxdlCu
	 usOPKnQ4uN/VWI82FS07s7JbX62jRif/i3Pa/2p3KM8rnSeUeUu4dGB50ZMzzhgE0U
	 UkJ5a0ErZvwA162ml1JqNf97PIg3YCkdcG7u2nJBGpFFcRtCu3JyowvN3UJgyLnUpj
	 Llc5LBmT2uOEg==
Date: Tue, 17 Mar 2026 13:01:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 2/6] selftests/liveupdate: add helper functions for memfd
 tests
Message-ID: <abk0ke1wAiHMYnGs@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
 <20260309115441.266805-3-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309115441.266805-3-pratyush@kernel.org>
X-Rspamd-Queue-Id: A29A5180012
X-Stat-Signature: m7icoyzes6fbosg934ndrsyp7tguyf9b
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773745303-585230
X-HE-Meta: U2FsdGVkX18aThiF4My7AjzEQxXsiYd2a8nCP/xXjlBT4TNsWWokpd5FskVD5tfriNkzZ8IE4i2g4A0JO0W1XQ0JBRFai970bd4eZBNNUFC6TosRLRfKxhSljec5ZlxG0nYMoGYD9KZd8l24N4vwotjjItpQd1gDfuWgt2nzsBguBlUSx40MoOhsAE55FvmXnRJxFCXF4MvUAi+B8D7KIQnGSnXS9o8nB6ZM9vsWxQdkYoug6dE+5d0RTTeWY5u2Z+QlaNqbVUopqmswzAQzFhGJQuFG4VPjZO2LMmX//rIvnqlx/pg7W1w8iKTWE9vVIFh3Hh9oj4God6/0G+oyx8apu+XPicDyVFjDnur4vspKAsRAlEE3WRobOKNk3NggKhFsT7yhPrfia0fGTgGv4Bt5dcouCbCMRu3OpU4lLviGFQ2PgTU1EmR4yDmKdQasDJeyPiCW31twBhaSpVc01xwk90oICm17tTAfdE4vXYU+V0hM0NsXZY9KjyD3iN9fgTBMnVPlV6K4+eTrBD6vdbCYjRuVkJ+A/zCR1shvSS7OU+bQrJecEbH06Ab+Cv+LGPVgt8GMFUSAq6V1JyZLWemGvvynn+viFAEyF7uQz0zT37N269Fhaq853L5c4HJcA3ytbzk5fy22frVF8uetowOLdlzhBSnoHA48oM8C+ea12duFMq6GzFuivXZzVWsSZ8zewq3Pw+4BBRv0oVeC31vHy/MwOe61lT8q93MtLigtVTtKL8c/DIPRfUcUWXT5krU+KVA2sSFWIhFh8uPgY0UY3PDadxqMokjAvp7G6m8M7mXYcZIMGhR0t6aFuXfKkcuLE6D7LeZ8luwqMmj9Gpximx+GtboCUWRrvQ/7FJMuUGrb4iNSb4tEUBryvyKbtA+R3oRY5PTfOb0ALQUwC9e5n8lqmZXrzTe8q8EFNt5P6XQAOdFx9xtJopUG86bXD/i7yKkZU4OCcvnVTN4
 Hha80QtK
 VcON4+4zO6IQlUb0gf/AvRs9zRaeG5XrcUnrOEfrDZZkBS1oCNqT0y5VsxV6HW1S5qcLUkyVDwFIuBKPFMVUZ+K68NkhTm7u5honNw42+Xzbp4hL12oRVHaajhZldUrxmZUmx6slDekByyGoQt2hQJQVXIRa7+y/H9lLqe+iulUM/dolaGJxQRRJIZ8VSmKuhTFy4LWh1vSdLY1A/QfESHUkds8/wM9teFfI5n1zVKbzNSifh7KMco/WmXdkzktosYzIHvQx0aw+j0Iu0BLf2NviPyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 11:54:35AM +0000, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Add some helper functions that will be used by memfd tests. This moves
> some of the complexity out of the test itself, which results in better
> test readability and less code duplication.
> 
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  .../selftests/liveupdate/luo_test_utils.c     | 175 +++++++++++++++++-
>  .../selftests/liveupdate/luo_test_utils.h     |   9 +
>  2 files changed, 183 insertions(+), 1 deletion(-)

Some review comments from an LLM that make sense to me as well :)
 
> diff --git a/tools/testing/selftests/liveupdate/luo_test_utils.c b/tools/testing/selftests/liveupdate/luo_test_utils.c
> --- a/tools/testing/selftests/liveupdate/luo_test_utils.c
> +++ b/tools/testing/selftests/liveupdate/luo_test_utils.c

[ ... ]

> +/* Read exactly specified size from fd. Any less results in error. */
> +int read_size(int fd, char *buffer, size_t size)
> +{
> +	size_t remain = size;
> +	ssize_t bytes_read;
> +
> +	while (remain) {
> +		bytes_read = read(fd, buffer, remain);
> +		if (bytes_read == 0)
> +			return -ENODATA;
> +		if (bytes_read < 0)
> +			return -errno;
> +
> +		remain -= bytes_read;
> +	}

Should the buffer pointer be advanced after each read()?  As written,
if read() returns a partial result, the next iteration reads into the
same position, overwriting the data just read.  Something like
buffer += bytes_read after remain -= bytes_read seems to be missing.

This is exercised by generate_random_data() which reads from
/dev/urandom, where partial reads are possible for large requests.

> +/* Write exactly specified size from fd. Any less results in error. */
> +int write_size(int fd, const char *buffer, size_t size)
> +{
> +	size_t remain = size;
> +	ssize_t written;
> +
> +	while (remain) {
> +		written = write(fd, buffer, remain);
> +		if (written == 0)
> +			return -EIO;
> +		if (written < 0)
> +			return -errno;
> +
> +		remain -= written;
> +	}

Same issue here: buffer is not advanced after each write(), so on a
partial write the same initial bytes would be re-sent instead of
continuing from where the previous write left off.

-- 
Sincerely yours,
Mike.

