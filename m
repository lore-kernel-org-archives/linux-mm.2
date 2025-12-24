Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF14E74903
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 05:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A03D6B0005; Wed, 24 Dec 2025 00:34:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3784D6B0088; Wed, 24 Dec 2025 00:34:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2852A6B008A; Wed, 24 Dec 2025 00:34:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A3026B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 00:34:14 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B305E59AE9
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:34:13 +0000 (UTC)
X-FDA: 84253248786.18.87FCC11
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2E34E2000A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 05:34:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QgufPEiV;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766554452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pzp9G/yJumA9RBvYHz1MARrAhteSndOz1nQxRqrm7/w=;
	b=2ZKiUN+CEQtxH+EwaDAcDErZd/flHeG/7utdInfMvXCavBT9+6qypfuUqXacizyybfMfQx
	9ety3QfcDMVz0GPJRnEg/Lt+CdQKVjzFFSIhN3kYvJUuQxiDaSQkqzTZyRf9mFfenSLGK9
	lJvGWWkGd3ap0pMwdJlb4uXhjNxSY/M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766554452; a=rsa-sha256;
	cv=none;
	b=dUCdL3FMMB9e4wXFZazwho+79U2qFiNQbxu8No+NPs82GunRqER2dCsSpynem+MiHPFFzW
	yYWSQgEInzl2Bxt4yTBEv8bHHg9421uO1DGzWB9qpOq1T+0Iqm4XbIK7+CmcrZMVFw7ubS
	AsuJC7WcKCd5jMCniAZa+NCJsxb1GCo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QgufPEiV;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A4DC060123;
	Wed, 24 Dec 2025 05:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D47CC4CEFB;
	Wed, 24 Dec 2025 05:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766554451;
	bh=zLbx+xTupXnZyVSWwHXN/mFc292jJY5gpBhLh0NJUjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QgufPEiVfZHHvxciL5ll7cKFyhoADE4nwvihwpP4RWBmiIYGyzbeFNUe/+nTnVDLi
	 QYVLUh2Hvs/a1gDo6k6EIR61XjwoYqWSyBplII4zjnOBGZuEkrZScvA70njC5SfqP+
	 dEJfwoEiuLmFx+XuNbhEqxSS419LE2qL31r8btfEth4vg+ZShlg6iaOaCu0/ii2UH+
	 AU9awsBcbSU16eS18PaXtKGg4iKp6T9NicEL2uoEQuz5G54qs2ImgCTBJulyOWtiTD
	 eXGwHuA88T/J3cPTkvBZa0Is7eM0JzRnr7StFDNeBIK/LObKjlvGSUgB3f+4oWaRPg
	 nBDu4NjZGfeQQ==
From: SeongJae Park <sj@kernel.org>
To: Shu Anzai <shu17az@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/5] mm/damon/tests/core-kunit: add test cases for multiple regions in damon_test_split_regions_of()
Date: Tue, 23 Dec 2025 21:34:06 -0800
Message-ID: <20251224053407.81911-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251224042200.2061847-5-shu17az@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fsq7naz7e5535d7kkfaogrsmzx7w3dhh
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2E34E2000A
X-Rspam-User: 
X-HE-Tag: 1766554452-804462
X-HE-Meta: U2FsdGVkX1/YPjpZvvED4RBWrFAs4M9jLQsbCZ/Pcg8Xl6IouaKPswR4G3bro2H/MYCqO9qMqi3Dq3+oxxeV+83zC3XOQxAKtLiqFRXzfdV8KXMEj9ttwht/CXuTK0Tvu7Bq+im38r6lS8zYp1LGtjOpVlLoiRcI6ZjqQqdW2GdQFjMaClh3EWz6sSLN0ZHMQxFPMmGh+J0RcDKZfBxSYWrwJP0ylKrK6nWnktYlqRPeScGB3c38VgEV9JRk2MoSw0zIjlXlh+B5pqO7Z5ZfRJJoPVXParHvO8q49S/yI8ws3lcD8NwU1/9nmTOCk6zhSZmaNfcTA036Q3yfJ3vj6HgZ+SGvOJfWgGF/s5ZaHK8fZ+d9A+fbVilmxnAGSnNt2go4KYgdVV8I9zWGqYgNA/wx4N+4qLv8lMdNkMxun6TF/t9F4QD+kzXAbDHFjjjjd+9OqwMVRF8JST0pRGyPWJyOxwtRi6YdXqpz/N7kF4A0pApHMsJ3Q2stD1cFFXJq7FvrkG0fSjl8wAA2cAEhEXHhSPZKSkB9MNDZTkFpCWU/wAF3n46gbNVTimknbISxwjHBd9iOp94vjIDLWfshAKhYEWrVNlS+0ibFaPDJNuCROCI4RvzVsuSYPkTNY4gKdX0/5y5AM+uUe5kfRQJzuvfivHFDrl4wSlxGwNBbt9vDJe4/vTC5WTIQMXmcm1qX/AtV3ehpZijKjY5A7mBlEvoeFcPuaU4pwCM2jx38PF2J8QRs3aWJ2lr4YW83NJb4hlsN02WwAIy5YTPOkxSZtsqUvSnrlaZqWbNZ98/70Br2+Y/Hq8WQqtQSp+tQmL6LfMJCeU87gUU2bI9NtHWvDdn+SpC8nA/+3Ph4jppbRQBzWCEuJoFx8YhUpG37uuCeEN/leP0wZf82i5jFHs3kTgnQSiJh3Syt+o1aippDq0XWMOX2bZWxvDxnl7TuHdPF8imvVnyz5qubENXYf6+
 qMsKDLkG
 6MfeXbyPQ5lgQ7oozlwOLxvJB2oLMCB5WElDHNexRBoZ/jsubBPC4wfUAdIH8p6PoPSBsIB2wSAgI+OBx4HJrcG2y7paVclzD/CaWAOp6lmQndD+YZEhfZIAoTxwAKHft1mSpeSGX4sshrLaR/nKrQWGLV8n0qdfhJBoqMr8vlq/yRFZ5n/GwSEqH0kRXxZ9khkl1rzMSlp+M4/cHg1VRYJBCw3NDqt9AAk1AArpoTbzWa4kS1gGYZnty1C9J617SZL+TWXzC/0cDpe7kjT3rRWWhG5w1r31t2lyIGfOoM471V9A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Dec 2025 04:21:59 +0000 Shu Anzai <shu17az@gmail.com> wrote:

> Extend damon_test_split_regions_of() to verify that it correctly handles 
> multiple regions with various 'min_sz_region'.
> 
> Signed-off-by: Shu Anzai <shu17az@gmail.com>
> ---
>  mm/damon/tests/core-kunit.h | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index 2eb6f41635a8..36622a2c11f1 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -275,6 +275,9 @@ static void damon_test_split_regions_of(struct kunit *test)
>  {
>  	struct damon_target *t;
>  	struct damon_region *r;
> +	unsigned long sa[] = {0, 300, 500};
> +	unsigned long ea[] = {220, 400, 700};
> +	int i;
>  
>  	t = damon_new_target();
>  	if (!t)
> @@ -301,6 +304,24 @@ static void damon_test_split_regions_of(struct kunit *test)
>  	damon_split_regions_of(t, 4, 1);
>  	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
>  	damon_free_target(t);
> +
> +	t = damon_new_target();
> +	if (!t)
> +		kunit_skip(test, "third target alloc fail");
> +	for (i = 0; i < ARRAY_SIZE(sa); i++) {
> +		r = damon_new_region(sa[i], ea[i]);
> +		if (!r) {
> +			damon_free_target(t);
> +			kunit_skip(test, "region alloc fail");
> +		}
> +		damon_add_region(r, t);
> +	}
> +	damon_split_regions_of(t, 4, 5);
> +	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
> +	damon_for_each_region(r, t) {
> +		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
> +	}

Nit.  The above braces for single statement is unnecessary.

> +	damon_free_target(t);
>  }
>  
>  static void damon_test_ops_registration(struct kunit *test)
> -- 
> 2.43.0

Other than the above trivial nit for the unnecessary braces,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

