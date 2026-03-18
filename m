Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA9BFCD0CA
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 07:43:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B40D6B010B; Wed, 18 Mar 2026 03:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 865626B010D; Wed, 18 Mar 2026 03:43:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77AB16B010E; Wed, 18 Mar 2026 03:43:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 654936B010B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 03:43:55 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E24F1B8283
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:43:55 +0000 (UTC)
X-FDA: 84558394830.16.2C4D98E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7252112000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:43:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uU4ZfC6Y;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773819833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mL4Bi9ilJ1ud108q64rEprraqC40mX9MA6xGIzPsoX4=;
	b=w2qGBgkwnj8y3pBkoZEv4lSWwH4q5OUJ8ujHxHYSFHmYTSn41qmKTkVALPkzCPbM4y593Y
	vtGe22J6SNWvGWJmVK01iI9kUwnjqE7OEGeDV4Zm6xgdAkuaFBtSXOWpULP5kN9rDYuPPe
	+l6dUN6dmKKpIY5uMGYoHNrOmI4yOmM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uU4ZfC6Y;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773819833; a=rsa-sha256;
	cv=none;
	b=en4drW/Cr8sgmD25jekjdzlg2hQ8weSzqmTy9a470Kgc+2LS9Gwdi4BtzS4A/gU4HJPfGh
	/LeMM57B2gdgdkGVbu3gC+mvJUScPB9DAnIQP77+4oeNGgHpOPwNBhgjSLnuD7eBrvf5yV
	GzTd2mWCkhklCbeC5zfQcH9QS7SPR+4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7DB2C433A2;
	Wed, 18 Mar 2026 07:43:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88217C19421;
	Wed, 18 Mar 2026 07:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773819832;
	bh=MR6pOI/j04PYleruQQa98TK1ndpttSpNVdbTItOLHTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uU4ZfC6YLNJjoYyZgv6kgFdMKaBV84iR8hPCq0E1OE6spltjUu/iP0HXsirHpUwDu
	 R83utcMVIA+GmZ/fCO9wargcDNarNQ8TimXdWLZpq61FDfxzqXxgIynR1VX/AelDwm
	 1Yohcc8zUdOTT6a1ILg1eEcsPWtu33ZRds3x09hgai4XByGOrpujYJ76dU/H20x3G9
	 Q5Dkc8PGAIh2FlCj3H1Tkm2YynaeAJON+XazYalreEdjfim4cqyBKkUxpiSZIiGN31
	 iYEU2EMCTTVOieIutCSZy6irvOJQgoij8wf6B92iAo76kO5zdDzkHEq01UmEW6HQHr
	 hXwKwDiwqHxDA==
Date: Wed, 18 Mar 2026 09:43:47 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 6/6] selftests/liveupdate: add fallocate test for memfd
Message-ID: <abpXs6RgiUDSBA8-@kernel.org>
References: <20260309115441.266805-1-pratyush@kernel.org>
 <20260309115441.266805-7-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309115441.266805-7-pratyush@kernel.org>
X-Rspamd-Queue-Id: 7252112000C
X-Stat-Signature: 6dfmqezsdcpqsk5r6ri9cxfho4nr17zk
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773819833-396584
X-HE-Meta: U2FsdGVkX193UzgcVJLsMf6RHoYxpNTabysOmhVDL3N9VrM+FES0qDM1JVuiKVp0/23BGDbBMCFFc1mD5TtyOsri0N9l9Mn11WDvDJaaHsgwEkFDYxlaHrMAW84SkZeHTcv3ht5CRwLRfq7itccNYnRBXa6hWI1+Eq/p7wo2oxY6w2AWZ3KN5LMLOi6YXBMuD43LGOL5NqjAISNB/ZgWy225X5LW+3I3AD1F9txCEd7lWDihqPQdcrY38fe1hVrFCweoOrs37/qJl6s6WVtgjKND9AyBl1bLxRZ5QWxNCPZGae9fi93IukRWhCrfg5+bXi9rUc3Z0RY5jmUUksvxBPvyaLfUaBije62wisEFNv/SS9vD1GFkjyXS0yVRJYn5v/Bp6MLl77jWJ9DJ8PezFXK9KGfgQPf8gSqJgJ7kyhmCuYcX3ptNR3QOKjlFHLaqqw424+pKSOKrCYEFNCo6VdYsSIXqBHxfP0K8eASyt6IpwGbfqD1Vuzd6CyqXiHj/kl9pQgxQlhMpykkydYbfTCwHhAasF9SEeugWmH2iTOW3s3eu5+rWFljIk2z8IqdItPWL1ECXpoXfsbi2fKkDIbcjTDojPKBwSS3wTDJB8sg3elZlXmCMSeAi77Y51XGLIvnH9P9JW0im/rMo23Nm5ADlDyarxZdMBcL7p198gwIAKOAzIG1RUz3rLpEhf52yCNS+k8StSJ6lizXMU8YDwBqFYaoUwJQr4Q9aD40CU3cNSmMB3pJL0dSHDmVdTOoisKwKUGKVXO2KWQr9EW4YKzvf4pzTp2A0e2WXs3XVI34fqYITAVCAbdwsPrcz7/Gg1oLLQZQpzaQSEpwZ64bHH5YDJKCZdvLxSMtv7hSuU3M0FJMQJWus2K/woqgKavaW668wiicyRPf7231Z/JEmopZA67zGn/2FzzoQAoKFEdx3t9qcpv+sevz+htbZN5cojFlNj6JNHeFGuePo0Fp
 9oIBMogK
 7H1iejCTQlmGG9TZM40n+tOgVYCCnXxQzMJG7/vT+/b5Jp4ZFWaaOCoYcvPf7CMo2W+14J/90dEOuLQvJJ2AAWPrbX4XyCearkJOYLjsKn/aTXck0/L9POPSwYcqbWtDtahQnhM8zBCSrfdsx+Iz5AfPXri++d605rwZ1YfQzyMRV5K9KED0yBByrmk1xHrhXBfZNwHJ8ekrM4IDLufy7aSnPefb6FxH6yRmokfDQ6eFFwietlKOYjmmEy4h8tDabGWaI4lGCBJp9acY7vihKD4Owyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 11:54:39AM +0000, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> When memory is added to a memfd via fallocate(), it does not get zeroed
> immediately. This is tracked by the absence of the uptodate folio flag.
> Initially, memfd preservation simply saved the folio flags at preserve
> time. This led to a bug, where all writes to un-initialized fallocated
> memory after preserve were lost after live update. This is fixed by
> patch [0] (not in mainline as of writing this).
> 
> Add a test that fallocates some memory in a memfd, preserves it, writes
> to it. Then in stage 2 it verifies the written content is still present.
> 
> [0] https://lore.kernel.org/linux-mm/20260223173931.2221759-2-pratyush@kernel.org/

Looks like it's already in mm-stable, so it's sha should be stable already.
 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  .../testing/selftests/liveupdate/luo_memfd.c  | 64 +++++++++++++++++++
>  1 file changed, 64 insertions(+)
> 
> diff --git a/tools/testing/selftests/liveupdate/luo_memfd.c b/tools/testing/selftests/liveupdate/luo_memfd.c
> index 75f88101e7b5..dde3c78db50e 100644
> --- a/tools/testing/selftests/liveupdate/luo_memfd.c
> +++ b/tools/testing/selftests/liveupdate/luo_memfd.c
> @@ -43,6 +43,11 @@
>  #define PRESERVED_MEMFD_TOKEN 1
>  #define PRESERVED_BUFFER_SIZE SZ_1M
>  
> +#define FALLOCATE_SESSION_NAME "fallocate_session"
> +#define FALLOCATE_MEMFD_TOKEN 1
> +#define FALLOCATE_BUFFER_SIZE SZ_1M
> +#define RANDOM_DATA_FILE_FALLOCATE "luo_random_data_fallocate.bin"

FILESYSTEM_COPY_ or something like that?

> +
>  #define LIVEUPDATE_DEV "/dev/liveupdate"
>  static int luo_fd = -1, stage;
>  
> @@ -193,6 +198,65 @@ TEST(preserved_ops)
>  	ASSERT_EQ(lseek(fd, 0, SEEK_END), PRESERVED_BUFFER_SIZE);
>  }
>  
> +/*
> + * Test that an fallocated memfd is preserved across live update and can be
> + * written to after being preserved.
> + */
> +TEST(fallocate_memfd)
> +{
> +	int fd, session;
> +	char *buffer;
> +	struct liveupdate_session_preserve_fd preserve_arg = { .size = sizeof(preserve_arg) };
> +	struct liveupdate_session_retrieve_fd retrieve_arg = { .size = sizeof(retrieve_arg) };
> +
> +	buffer = malloc(FALLOCATE_BUFFER_SIZE);
> +	ASSERT_NE(buffer, NULL);
> +
> +	switch (stage) {
> +	case 1:

Functions again :)

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

