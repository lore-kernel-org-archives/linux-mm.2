Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81C92CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 10:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508FF6B0088; Wed,  7 Oct 2026 06:16:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0BF6B008C; Wed,  7 Oct 2026 06:16:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F7746B0095; Wed,  7 Oct 2026 06:16:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 170EC6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 06:16:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D4FC1A0165
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:16:25 +0000 (UTC)
X-FDA: 85295425530.13.B429333
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id C0666160005
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 10:16:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f4meMJgd;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791368183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESIyTeV5wm8brFdtF/p7rC/YImFfa4MobdYy15tnWH4=;
	b=j3gGCy5ARie0NTSS1oCzNBD0cK1hWW9ym0VReHmfdptBSB22nRIAukf7Ci5SNXpWz6l0eP
	8Tstvrk+lWmlBirsFlyzSlLQ9b5i37LGdaTXGXMfsfwxnsPRYEFN6sqmbI7HShyPLXeZF/
	yAjYJ0X3USLQ+YeeMdigSH6a0eMjIQk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f4meMJgd;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791368183;
	b=5+NNW1UNu44wzDTz4cnRR1IVw+GxecRktTfDRUGh82nU8Df1rnO4hmuSmtWk5tQpyQtmXR
	I5M6NWYXq4Bn/uHthC42fRGqELj7Mhvjvqo5a1GqaLsrxSCg19e3dDPAO7DTugdNcWxMPv
	HHItWGoXOTlHi7UfseQRYQnAmhOh0GE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0521443896;
	Wed,  7 Oct 2026 10:16:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1101D1F0089B;
	Wed,  7 Oct 2026 10:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791368182;
	bh=ESIyTeV5wm8brFdtF/p7rC/YImFfa4MobdYy15tnWH4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f4meMJgd4ttNeAqnos8kPXy5BxbqEVCRAG7MoJptyFvMCp9/5Gf50bRt+LOsxKH8v
	 9ydNj6fXwfQZ8Do8udukd5QqgwPVv5s6TlXXyay4eG6xoJjQxc9QxkhC3uTxi5kamO
	 72GQG6wjjeo0oMO6dxq62JNasJ9OhnOT2qausxqIv44y+5XNwRTCbRWuaRBrRl+aYR
	 fgT1bYIhavBelsAAEIxdtkOsfaJ7LC39XCD7KAFE++UCNaIgtN1LTFVexZHh4I8Vn9
	 ImzUskbC4mIxvbhhpSFw733Y+NwWuEOrFuuqba+BL3+vHVLwWzNjwp2rvJ90oH1jrF
	 MpCb5MPi5dLTA==
Message-ID: <022ec915-62ab-40d9-8705-90692e75acfb@kernel.org>
Date: Wed, 7 Oct 2026 12:16:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: hugetlb_madv_vs_map: fix TAP plan
 mismatches
To: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Guillaume Morin <guillaume@morinfr.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Breno Leitao <leitao@debian.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261007092801.35649-1-jaeyeon.lee.dev@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261007092801.35649-1-jaeyeon.lee.dev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C0666160005
X-Stat-Signature: pd4z61amra4jj1zhpzne6odkrtfi3qg6
X-HE-Tag: 1791368183-511887
X-HE-Meta: U2FsdGVkX1/ue2pvcpmrtJzU04db1k8BHatjj7q5sf37aK2lD6jOEGGFbE32XaRxBl6lGI2pbTaUu6w50677Z079R3ju9rFlcvImRYLHzWeUjPt0hEpMmtwW8mJlxviW4XnGev8RDNB8VwdmoCxIbhQAkKjtSJRPFj+OpNdD8SctEz5WbeD2nggQWC23CbDCtV/B5iwuXeBNWNsgIu09hFjxxp14g6F/i8uD3/xjY47FpERDm0orRvathCJG0UPFGHTtBkm/7comj2R1pg5mtraTr/lwyseeHZBYn4FNAvTtuzAqvgHCvp4/1/XLH3z17I/8FjOOkkD/zOKvw1z3GlRgg/N+vTT9cZi4HLY/GhO1inEjUVIRYUCrgMgwP+SGg17IruyWN23deNy5yZ6I83QaGxIdOZb6ncFI/+7i8/fJZH1LNLiQ3l7kjyASQZZck3+RXxRjkQ1Uo7/aQDVAHjuwuCLTHck85gz7NTlxI3kfbaFS/m53mETEU1yL4ak9X65Y0sVpDdxeXxrLA/EEurU+Z/M7JwDKtgEMEAqQd9TM1RKh4EwOr/XrywCA4vNkqhJAwgd2X1vUgtiHd/SJMlnYE+Z9WtTI8lQ0UPTz/ZHaaErtg8v9EfXlhMqq20cv/dbCjq/vYffYpHAzyDHLBA65cqk/728cAWOr5HUHG0qexqZDKc48m3LQLON8O2Cx3b4sRgs0LJCQNTgaJ/TPIgBMFcDByrjAxSo2vMMThcqxtG3gv0DQkAxo47XxyktpzBDrOp9JNHwyEYtiRA/uc2EaW6HJT0d3C58Rzdavth33/RdSjUrW1NxWSnV0/3nP0ujnt+NYCHH6Yhem+uUjnImqB7L3Kw0zD64qlixBH6JCkc/rw5PfpcFzP6fD5CDPzUEvVGQPrJSCm1HjyJYRa2Ntu55SgpWg6sjojPWUXaTvrMeRMCv1DoeQE7v6JuaKlAhV05gVxjLChtJt2rP
 E7jIxDw2
 FguVK58L6pdMD37oxhxcN+sJrnDX6DtwCxyopafLTFKjZoFZotTzIYVyrqmXj9UfT0SzNVS7W7nLKHBQUQMiAp1197tKt21QwzvRbrrm/ynULWLw9wh/7gS/y86CPJ/bG0wZPs2aepRtnGJ+gMI6KWhmJivZJ+63cFHW+YQYhDQH1rmzf1C7PDDy+VdXPFNDAUTjwy5CM0TdvHy0FI9xpRMoWh5Qjfs490Qxk6ODsDyxG/I0TysacwP4sx2v+KTBFiMOpuaO3N+he4UZChddCpHt7saChGf3+eReJ4q52pPloZVHOJKUEcpmZ0Esmw2fvo8GCTu6PEm+UbfGu9pkX5LZvEPNbFzXeUmiMR++kusZIHGTAr7udT8xvizhLsdCiR13dEnR/jwCVE/qejN3AwmSNjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/7/26 11:28, Jaeyeon Lee wrote:
> The plan was raised from 1 to 3, but the HugeTLB setup check that may
> call ksft_exit_skip() still runs after ksft_set_plan(), so a setup
> failure reports one result against a plan of 3. Move ksft_set_plan()
> below the setup check.
> 
> Also, when the underflow check fails, or munmap() fails,
> test_underflow() jumps to err_cleanup and exits without reporting the
> remaining results. Report the munmap() failure as a test result and
> skip the final HugePages_Rsvd check in err_cleanup, so these failure
> paths report all 3 planned results.
> 
> Fixes: 827149aad495 ("selftests/mm: hugetlb_madv_vs_map: add underflow test")
> Assisted-by: LLM
> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
> ---
> Changes in v2:
> - Drop the duplicate ksft_perror() and report errno in
>   ksft_test_result_fail() (Sarthak Sharma).
> 
>  tools/testing/selftests/mm/hugetlb_madv_vs_map.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> index 1d111f42dd59..0f6afb834dbf 100644
> --- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> +++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
> @@ -168,7 +168,7 @@ void test_underflow(void)
>  
>  	/* First unmap, this will close the vma */
>  	if (munmap(huge_ptr, mmap_size) != 0) {
> -		ksft_perror("munmap failed");
> +		ksft_test_result_fail("munmap failed: %s (%d)\n", strerror(errno), errno);
>  		goto err_cleanup;
>  	}
>  
> @@ -203,18 +203,20 @@ void test_underflow(void)
>  	if (waitpid(pid, NULL, 0) <= 0)
>  		ksft_exit_fail_perror("waitpid failed");
>  
> +	ksft_test_result_skip("HugePages_Rsvd check after child exit\n");
>  	ksft_exit_fail();

That looks odd. SKIP + fail on the same path?

-- 
Cheers,

David

