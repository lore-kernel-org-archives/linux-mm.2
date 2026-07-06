Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF85CC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 11:24:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCFF76B00C7; Mon,  6 Jul 2026 07:24:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B80C66B00C9; Mon,  6 Jul 2026 07:24:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70196B00CA; Mon,  6 Jul 2026 07:24:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8FA6B00C7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 07:24:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ED9621C32CF
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:24:38 +0000 (UTC)
X-FDA: 84958119036.19.607CD3D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 615EC80003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 11:24:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRViuTMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783337077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvZOkeuj6Jz+Vl/DDhv83e0XazYYb0gyHTufoIWjdys=;
	b=fZjB104l/orkW1kxEG8ESNRqRovRACjHmE1mdnwle98m2nGpBKo3r05lRJxGMunv/u8hcZ
	KK9V56fNjxzaSg1Ygh0daupuBR+IrW+xgEez0HYVB6TXFW8iD8LNq+HCNypA8+wg7kfnoF
	m71VHU1+elhKobKLrfte8tKKPOURl+g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dRViuTMC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783337077;
	b=hW+srAGLaMe4egBAtNfh+mKH9slEgkdNaXnLHyIVSDByjRTEnIhpMEAzTKZkkPxONYauJw
	y9k/6lps7F5OaZJQ4UTMVp8kWmLlzsXMmO4hyNDX3arjc67a/hPic8SkCa1OhgVj7G05SM
	7ZVdHTcHpajsKofNgCvMEDMJIEKvAwc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BFBC060018;
	Mon,  6 Jul 2026 11:24:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E14F1F000E9;
	Mon,  6 Jul 2026 11:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783337076;
	bh=YvZOkeuj6Jz+Vl/DDhv83e0XazYYb0gyHTufoIWjdys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dRViuTMC4dzD/BkkmAu7v1QO9lFTFk8gLpKC6/L9wm0+i8SkxP0QrdqW8//zbRd4Z
	 VQCq/5ex7W8mnUPn/usQSNkbCedvelcCq0jeJTSQn/oA1amJoczYsnseCgSu4ACuU3
	 7daAeIxjxLVYU/LLcpJMSlZpudmqW757h9wEX0vJLFW1SZiiodXqPBI2rd2JtRPC+6
	 C+wrq7l9fmVBxA15MTJY5Yf7Fu069HZI6RoqOWKUDbBiN1fr0m7URbc77rTQuUx3U+
	 FQh/4yVDwN1CuUUjnbcBzE1T+VHNztuNqjqC8v0wJc3cs6o5o+SK9tE8tpVN+h2aW9
	 0eZGaruac+GXw==
Date: Mon, 6 Jul 2026 14:24:30 +0300
From: Mike Rapoport <rppt@kernel.org>
To: longlong yan <yanlonglong@kylinos.cn>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/mm/mseal_test: Fix mmap return value check in
 test_seal_zero_address
Message-ID: <akuQbvgVR8vrEFvo@kernel.org>
References: <20260706083049.187-1-yanlonglong@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260706083049.187-1-yanlonglong@kylinos.cn>
X-Rspamd-Queue-Id: 615EC80003
X-Stat-Signature: h4zi9tj1f4gbjou951s75maaqr9hcsew
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783337077-65189
X-HE-Meta: U2FsdGVkX1/FoXk+zTrQu17lB4pynJK5fP8/sFCnY2MTaKKH/zqceVBEk0i73Lg/k04OlWVy8l2qocGbhq8enodc/ktn9CjOI5D0aWnJjVH/ih254Kme/NBZpn+yGm7rRl5GMGTyMlNggHstRiNUj27qxF7664qh0YgJGrWayFqvt/hltYo1EfVgfQvbhy06YI62O8MoFYwgbBS4yUupeEO7znAZlsTmauLxzo6plFZi55lTc5PFpud6TXcqXwvNf9k5PqZHmJ30VTGy2xgzLv3Ri4tMtc4iXbQjDFDXq/zGwgwGCvHwGwhkXEK8tA8PvVYCPgeQ2hfmFiNPK3tWScc9hTJbVqTl8V9o9Gx2FqaFE1m1Tc9mk8NAlEkXcY3nN9pmSc9WOFC4dwEQ/25ehvq+0yGbOaD0TldflUpDEnghwSIWiMu+aFfWsmZVzgaoFXuckEX0wo6alXihNnjW4H2/fTHks1IwFT+Cy8pQaDggkisif4VBLagD2U36FVgP/dm2RjjRY3Lt6czjz5iUwp5ZvAZwa/LjMoNYWd2t730V+e1gcjBfFReWSlDxUAgw7endWKRcid/e73Bx+upYsxVWoF8bYeTul3c66QHLXfxLuj5yultnn0F2RJ8qXrYnQWtPY7938yAB2swQN8kpEDMZhRwCst7lLa4TByR+2ITLbba2brssFQsi9/wc06cGR7ym0vXDvHT+L6zJZcF8LcfhZxWuZgfWrYtAL5vARP+daSO4nDXf8njZ5+suI24G8LYugise4N7UukCcgRIHzLl+7+JuHIlTtxQBJ/2rPZigXJ71AdRuWZ9jjExt+ztd+3QF2MvSjgQnBuYZmfvWZ886u2VkDAm6zeNDU7g+xB05sZtci0Cegj1lousgrbFTxyjvtvtP58epEkRlMOKmCHiS5ZAcMNnWIC7TSViarH08ftTjOva9LFrjrcHrOszJxVgh9nnSHgYTBKe708F
 yWekMv67
 A8MQCIj8XkrptHCEbz4BcFXf1okBChb4oB2sXDoGbeDkimfp/UL5rSpkYNHnr1yAF10n9AygWs9WJDw56fhBoAPxwh0gy7qkMWxIw265a2rjZaPOPYDJpGOV6nFjHUOpBsKZdKS0BKHlgKWKHQDGJSZqMEMtIBhowp674QkYfIyr8FcGRAp42FJLv64H7kDEmbzJvSKzY2YDZykmQxScontkWNvuquIui2F71BQ/N3/pGMsL5vOO4J+4Q/AdAdr9ddTWoOEAnqUcV+B85CiaywbfCpmMQcVC58Vqgrl7JDI1XQ6ewJctj4GRZVJlPg54RETq+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Jul 06, 2026 at 04:30:48PM +0800, longlong yan wrote:
> test_seal_zero_address() uses mmap() with MAP_FIXED to map at address 0,
> but only checks if the return value equals 0. If mmap() fails, it returns
> MAP_FAILED ((void *)-1), not 0. The existing check FAIL_TEST_IF_FALSE(ptr == 0)
> would pass when ptr == -1 (since -1 != 0 is true), causing the test to
> continue with an invalid pointer.
 
> Add a check for MAP_FAILED before verifying ptr == 0, consistent with all
> other mmap() checks in this file which use FAIL_TEST_IF_FALSE(ptr != (void *)-1).

The changelog looks like an LLM generated. Can you please instruct your LLM
to produce more concise descriptions that communicated the gist of the
change?
 
> Fixes: 4926c7a52de7 ("selftest mm/mseal memory sealing")
> Signed-off-by: longlong yan <yanlonglong@kylinos.cn>

Other than that,

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  tools/testing/selftests/mm/mseal_test.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/mm/mseal_test.c b/tools/testing/selftests/mm/mseal_test.c
> index faad4833366a..a6ecc81c6aa0 100644
> --- a/tools/testing/selftests/mm/mseal_test.c
> +++ b/tools/testing/selftests/mm/mseal_test.c
> @@ -482,7 +482,7 @@ static void test_seal_zero_address(void)
>  	/* use mmap to change protection. */
>  	ptr = mmap(0, size, PROT_NONE,
>  		   MAP_ANONYMOUS | MAP_PRIVATE | MAP_FIXED, -1, 0);
> -	FAIL_TEST_IF_FALSE(ptr == 0);
> +	FAIL_TEST_IF_FALSE(ptr == (void *)-1);
>  
>  	size = get_vma_size(ptr, &prot);
>  	FAIL_TEST_IF_FALSE(size == 4 * page_size);
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

