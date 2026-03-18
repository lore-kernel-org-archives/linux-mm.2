Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21718FCD0C6
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720B86B0100; Wed, 18 Mar 2026 03:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F7E46B0101; Wed, 18 Mar 2026 03:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60DB06B0102; Wed, 18 Mar 2026 03:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2ED6B0100
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:35:16 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 15B951B8494
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:35:16 +0000 (UTC)
X-FDA: 84558373032.21.2EFCD3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 78C0A180007
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:35:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBGgZIb+;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773819314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bcw7IxI11CEg//xlfL26dtvaJDpmUaHg39UI1yQRbpk=;
	b=U/ETKi6VzKjhO3mZSU6y/2V1z0jpDMU9whh1GR26S9iE64ac24jhuZp/uIB3rKv4+pWZGw
	TVAJroJmS5oINxqfjvUWCtwo9dZ8qdFQ5QNgucSqD1/CCdQ2RCWGsynaN+tFQF812Gt/NX
	+2xs/9yq+fn2oHVcGYjckTeMJm4Se+k=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dBGgZIb+;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773819314; a=rsa-sha256;
	cv=none;
	b=2b15CXRFJuQFr9tmUV6JYUvapDBzo32lXbM4YLXNXzVClh8l3HruQsNNcDc+weeTp/rwbL
	HXmUdYx5fPMLg1wAg3cOBxLGFO44ycz+JBtyF2ctHmoQHjflhO1FLzaKVKu6TYROjV9NBX
	kK8dQUVIzYqGhfL4e8VdDjRvn/mnHY4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C670060131;
	Wed, 18 Mar 2026 07:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8163C19421;
	Wed, 18 Mar 2026 07:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773819313;
	bh=aKgcvPGTjYha//Cur4xRQFNmv+GIS6eHhEkPZRVaV+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dBGgZIb+ecwylwaxTk0P155leL9bw1r4hZwUIDB4+tm7bPE1ypoetja9t3ZmzSaDD
	 6KxanD+Ro5fANTpuBuHWvBvR0zNIlB1k173drlfkGBzTC7JqBDGNp5RN7GAGQTLzja
	 tia7yL5G8mVVk+2pKUWkiXIDw9IrDSNsOUhfEWc9sPs1ikgIdTYT+0h2/AhnvyYSTj
	 i/EDNUnE5nChQY6TsfWPo/7nLECcFXsGVOYHVHYS9vLwCmWF/57Mf+YCdwYkz4dbAy
	 t5UVqN2Yn4DaNlx8BZvTdR0lEFoXcNyV+1COoQ5YrcFuBPEbIjkJ1AWGAdMAF1zI1U
	 20t2h+ipomKZQ==
Date: Wed, 18 Mar 2026 09:35:08 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 4/6] selftests/liveupdate: add test for zero-size memfd
 preservation
Message-ID: <abpVrFwp9h6lqfhm@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
 <20260309115441.266805-5-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309115441.266805-5-pratyush@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 78C0A180007
X-Rspamd-Server: rspam08
X-Stat-Signature: ads5j47rge58xm41q8tzgk5t1axm9p7d
X-HE-Tag: 1773819314-511600
X-HE-Meta: U2FsdGVkX1/TSu4bYpSVfxKhUarCgvHhdFfbUYKu8wc7engswbln28BJj5+pD7l2f1PNuX2iJu/1F3hn+7vm0Gk61LVFNHSacV/s/M9z3ieBu/N6gYfyLTSt5VCjKl7xSCeIlwxgYd4S8WKaatZ4mzx5mcU6Z434NsEwJ5R1XhA3w66k0PaRJl3JZHxQZtf08MWaKSEWr1E6z8ek7CH/967/ZrWwjV/+kkZx9YezXyiq0M25uElezSa2Z7uPBaLs/gmjY2yh6QtV6nc1f+fH6zP/pyFXxXVTbOEkfchihDAeRpnntpilA4Xk/93GrdVtX2mWPEUyfxhWHeyj6YimJrzIDmaI//xI11t/B/kep2QZcIEjezUSnexX5t7F9VrG0SUzCKIFqo0pfwSUkOnaLWdNlBHdssPtD6ST15uIU0Efcb6fcORUzzp2KBqXf5FfTELVXTeU/5u+GzR6mjDoMv0hfxVhqPrgAb25oDWWZNCdWRFuIz2mT5ozisLOD9g+M5NH/kuveFwW1Oy+QD7bq2QiLnzHiy7Sv6aH6S2jFgwOO5urRyT6bqNUenQxzPQPT6v31KjTBvd8GDdIC/STZkPHpAbgTCtM411WFWP6+dXDktPK8wIXKi5A1sjH81nKAlXejUAI5PWDuAn3amu/QkQbit3PyfaPDK2C34CdT9zSNmzxcwH00plyEStgTtYE5aV0ZYsmW4WrVWe/fz7YJt3yDoAm0PxcyxPoyl7SEPM3tZuTClgWgXs6OXKA9a4jBw3AMQpgOcV8aqpVjnekChi9yhW9FA3ulKbH4N4SZVP5S6z38+0E1U8VZGvY6OEzoIxUNbKC5noLqWFuwUNFDZ3SCDWi/R1rE5ArmSigqP/53PVpJV7CuHloNXzUzQl321oK2cGkoNwinE8fFQfib0EfvKU3EwyUbB3f0ufnNX5hWcj9XZ1kwxuGjhaSM2uaTnVa6NledfuAtPHMHgm
 5QrIDpdy
 jjjMa5kuJzCmUwCKL8KIOhIsxH1n6WWjYCoOVpQk+z4A4YwigSHY5DAh9LhYxubSJ66q95yF+++nLIqlSJ19JWedI2IuEz4Ef3XTl9CENnKrrmgYgyW0/6jWeA+csyG0cq+XyDH5NQFz6oPU9zHQbWcUBTnpFsg4rMU0aEwsgerXN/gFIJlYB/tF4PKAM+zI3qOQpL5wgjeJpXd80KhCvcZBcv4gR8PLA3R5e6NzT5sE3vhqxkcC4qKI7XO/I6Ul5WlkMHmm/Or5BzQhPxLVqhtoVIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 11:54:37AM +0000, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> A zero-size memfd is a special case of memfd preservation. It takes a
> different path from normal both during preservation and during restore.
> In the serialization structure, the number of folios if zero and the

                                                       ^ typo: is

> vmalloc array with folios is empty. The restore logic should check for
> this and make sure to not touch the invalid array.
> 
> Add a test to make sure this path works as expected. In stage 1, the
> test creates and preserves a memfd without any data. In stage 2, the
> test retrieves the memfd and makes sure it is still without data.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  .../testing/selftests/liveupdate/luo_memfd.c  | 47 +++++++++++++++++++
>  1 file changed, 47 insertions(+)
> 
> diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
> index 52b5f6b16e19..56106cd09978 100644
> --- a/tools/testing/selftests/liveupdate/luo_memfd.c
> +++ b/tools/testing/selftests/liveupdate/luo_memfd.c
> @@ -36,6 +36,9 @@
>  #define MEMFD_DATA_BUFFER_SIZE SZ_1M
>  #define RANDOM_DATA_FILE "luo_random_data.bin"
>  
> +#define ZERO_SESSION_NAME "zero_session"
> +#define ZERO_MEMFD_TOKEN 1
> +
>  #define LIVEUPDATE_DEV "/dev/liveupdate"
>  static int luo_fd = -1, stage;
>  
> @@ -89,6 +92,50 @@ TEST(memfd_data)
>  	}
>  }
>  
> +/*
> + * Test that a zero-sized memfd is preserved across live update.
> + */
> +TEST(zero_memfd)
> +{
> +	int zero_fd, session;
> +	struct liveupdate_session_preserve_fd preserve_arg = { .size = sizeof(preserve_arg) };
> +	struct liveupdate_session_retrieve_fd retrieve_arg = { .size = sizeof(retrieve_arg) };
> +
> +	switch (stage) {
> +	case 1:

Helper functions?  And in other tests that do save and restore too?

Otherwise

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>


> +		session = luo_create_session(luo_fd, ZERO_SESSION_NAME);
> +		ASSERT_GE(session, 0);
> +

-- 
Sincerely yours,
Mike.

