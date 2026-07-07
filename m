Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B8A3C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 05:58:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664906B009D; Tue,  7 Jul 2026 01:57:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 616D46B009E; Tue,  7 Jul 2026 01:57:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E416B009F; Tue,  7 Jul 2026 01:57:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D0F86B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 01:57:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B13BC16882C
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:57:58 +0000 (UTC)
X-FDA: 84960924636.13.BB2B917
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 322E7C0007
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 05:57:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dQ9kTZVH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783403877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iJynP4kRwvLyws2F7vEyjqsIEzMYchfgfzrFW9gLc4=;
	b=BgQYYe+r/gUe0ZjeUnXGoPKejK2sv12wPw9hu9SPpSfIRO717v+RpyvEjXdE6pdFV1NzHV
	E9rmHhlDA8RQMfte3ujc7EWy9FgTih9m/5TpFkszePoY/2QsHg04odzsxpZTjjZKpUE10V
	YveYcaF4XxZf8PvPkK1MJjBtHQtMROE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dQ9kTZVH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783403877;
	b=4w/FxAc1yNrwfKi+SP2m03NntMwZTK8srw5xmNE4CO8KTGQRCrFzEkO8RYn4X/Y1kPu8Y2
	uAJTAU0jo36tl0m9jLLjnWf+HOhR+07bGExCX5cmWG3YeH8xUXTBkyNQBkX+0xQPbxGF/z
	mZdZv3F75OPy6650taIdszFY9aPpfg0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 99DE8618A6;
	Tue,  7 Jul 2026 05:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 767161F000E9;
	Tue,  7 Jul 2026 05:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783403876;
	bh=3iJynP4kRwvLyws2F7vEyjqsIEzMYchfgfzrFW9gLc4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dQ9kTZVHkjSf2cdBbNxi7liZaZFy9C7kpYceHELbwh8LOTRGi+a6Bm4/mUVcc66e0
	 TfoWbDpBPeIH9OLm7Oxrs003CBLJKe63+VfM1Ac7hPXDxzLsdnPtntBZ639nz/qTaE
	 Evqb/q6Y3oKHVZQ+lrHTP9OqbqX75V3bADemQr2lq8KtG6jU38zDi3ftORuPAztetF
	 MdzRBQYWXGoRdVa3AYzhERTEG4zolLkrZGtjS8FDw/rN1EzW/HRQRl2pDuiIdMi313
	 aoM83Cu01DJ7iOLz+Vcq4CP4tVQPdoIKlYNxMBO43dOz+DqwK5VcyflS2hNAPUVvGs
	 6muiVlGaNUhdg==
Date: Tue, 7 Jul 2026 08:57:50 +0300
From: Mike Rapoport <rppt@kernel.org>
To: longlong yan <yanlonglong@kylinos.cn>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2] selftests/mm/mseal_test: Fix mmap return value check
 in test_seal_zero_address
Message-ID: <akyVXpECB19-H9Q8@kernel.org>
References: <akuQbvgVR8vrEFvo@kernel.org>
 <20260707031745.1039-1-yanlonglong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707031745.1039-1-yanlonglong@kylinos.cn>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 322E7C0007
X-Stat-Signature: pfxt3tfkh1nmnztyj71b5dtwimxmufwu
X-Rspam-User: 
X-HE-Tag: 1783403877-144504
X-HE-Meta: U2FsdGVkX1+Tv88VzI0AtUUyu5zqxxP8i3OYOgvVIAKtLvx5Cb65eJ0XJftyOhEysNCf9+pVXBjrHVvhgBKRDcn0bb2PwcHrSskaAhVYXRi3X63j7esiyzRm2zzDhteJDPooyYjPsWh63STV7uIzB34mjgHP50b/drC1cvPmkCi6sSys7HbZ+fxO+KugVVq+FrWYu/dJ7We5BUowH/dZ2Dt3eAImdCrSxdR6YgvPf0VWTie/e3MZWKIJta368yeJHoOr6rc+76vi3ykEyrHRBiqc9ooI4w78O0H088KZ95MzIJlK7dOSRDCP1BAK0ezWGLrLd+8bRtFSP6BXuFbCqq9OOl3U+sL1SVk4GJ0+5uxmMFCXitB4fUnDXNsDolk+E5yrHVQZVDpmElb1mRvnKiIjPmhceIYeaQH27t9u8jH0DWaKMh8ue1dP0W3cUc/aLA8MNd9A9N+BQQophVZFcOwDk67jfG5tfa+GaRIrEuzw4yJ7UoMA7asWAAYYa5UkHty6wGlLQDivRjc+Fiww0T1kT9RgwYE3SDWKNpQEFgctMoZZnC2AbGRBC9V63OOcM+MVnwM3SuSdeFeG6YQ0WNK33dPZunoXc/cRS4f0/gytVo89cb/cjezEhgDtocnZijrTKUWBQFEv3lfxpjA9xmxJkySPfRINCdTMpRnaurUdY3Ztj4YCuGHLKfl5M7Ks+MdkhbX8GArOdb2DbBsw5vo4xUBOjBy72iMm0D3oAlsrl3vuThwlmV9oR3TOCG5o80GiyHMt6dlD9eSBz7Je7zXJL18WiKCptkxfqclqwWYX7+RRW4X+tA5UXKmgfExdycMr3CHiSn1M+9uLrHPjphQxpY86PP7pbtLGlSiTqN5Wd30F7kEESN5pD13X3KMmQ8RwMGzpum+kMQPDSsHGcmG7tmPJzzME5PD3et1/ZUXCE0oIzD50rakxvwlfjb4PfHGy3b+vrhYPOUCp1ZI
 v1niqW4i
 L+j+voXfoiY8iu5EeZlTBt9I3BPms5HYM7NfZeAMk926jdelbY3R67ygh1wIbQpHqVw8ZqOTsI83MjSixwtFZ7YVhCdGnr4ZXnSU44pbMqYRF8mc6cJgtjjp+WAyXmaWV/jumyOd1B9eS2+bRouoEaWqRF7rk18Evp1ma2dTFH5pe4IsNEHNVP61NlsUkoxirTDqzc+OXvHtjWwzgSnDi3lZLXeYWkj9pG+KTQAOTByc53j582Bn+C2muxCPXdWMt+Xy0FlaOsQR2gmRGbPGbUdLiKVTYzp7AN0fCP9Pda4/+FBBxPhz95o023sKEAAA/c0Ox
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 07, 2026 at 11:17:45AM +0800, longlong yan wrote:
> The return value for a failed mmap function is MAP_FAILED.
> According to the definition of FAIL_TEST_IF FALSE,ptr must be
> determined to be distinct from MAP_FAILED
> 
> Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
> Signed-off-by: longlong yan <yanlonglong@kylinos.cn>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/mseal_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
> index faad4833366a..277c8fda3f5e 100644
> --- a/tools/testing/selftests/mm/mseal_test.c
> +++ b/tools/testing/selftests/mm/mseal_test.c
> @@ -482,7 +482,7 @@ static void test_seal_zero_address(void)
>  	/* use mmap to change protection. */
>  	ptr = mmap(0, size, PROT_NONE,
>  		   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> -	FAIL_TEST_IF_FALSE(ptr == 0);
> +	FAIL_TEST_IF_FALSE(ptr != (void *)-1);
>  
>  	size = get_vma_size(ptr, &prot);
>  	FAIL_TEST_IF_FALSE(size == 4 * page_size);
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

