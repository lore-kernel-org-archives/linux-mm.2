Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC505CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 20:58:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4528E002A; Wed, 20 Aug 2025 16:58:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 475728E0010; Wed, 20 Aug 2025 16:58:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38B1C8E002A; Wed, 20 Aug 2025 16:58:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23BFF8E0010
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:58:38 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CA2C714014D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:58:37 +0000 (UTC)
X-FDA: 83798349474.27.1160F2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 380A514000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:58:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nnk9QIhB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755723516; a=rsa-sha256;
	cv=none;
	b=Tn9bF3jqTqlLfTC4CRFdv47+kfAe90w0joC5da8EQkMz9m+JvLCgZ9TQP1b/DGvXk55tJX
	kk3zadcJKtVJqSQk3Am6to6EJ+oUjfE0SV6roDaddQ/ilFasUWKZxB/6FU7GrGAqKPUWOf
	pvySA3E6J+AzatHz8GXs2g/KFtClfQE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nnk9QIhB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755723516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6FJys3l78Ida0BYuqx/TVV4BkqEWiZArZgFRb8oI9g=;
	b=Nw516lduV+2xYqnRH19H8hAjLDyLT3nuu9IKvcLb+31Q0D0RhO/+Cu9Q9re1XfGroQ0c4J
	uM00jATcOP0Oa8wz9HrdyC3i2O5MnGhEIh7YSomdeTH4KVAQz7KFAgWGqWltKhK3ohIrOs
	8M8S1Z3dV3LbL5tlDWXBULciqi85HYE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E12B601EA;
	Wed, 20 Aug 2025 20:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8E8C4CEE7;
	Wed, 20 Aug 2025 20:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755723515;
	bh=2LIlV6jZV84iq2Ygc/m4ROJTKmC2fI48srPWv9QJ338=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nnk9QIhBnunV2dusAtIYAOEhwvRBZyAphZf+rtRSzXmJSWWPbKeBm3PLl4iA8Qn/S
	 jLHsDOtIWncKkY+QQpPBCNotmtZNXKOrBoxYcLtmCmhGpcueAWX/kdiXitgzL+SRai
	 lQ9EdWw4kelLR8kUHZFf0RZKwLdghw2g3H3TeGNo9AuMQ8Nai4cJXllnoSM1A7yZr9
	 KSTvl+vujY46+GQ8TokMD+2+cFexCY675+8WYcW5lfEEYLnNPbAaJHnHKeFOezwquD
	 b2ENPWE54KW6Go5aJl/h8F7X+VRlrRRXstz0GZEuOSJxVQrxyiVxrZJmchoBPGmDUn
	 rT9qIQbg9SavQ==
Date: Wed, 20 Aug 2025 10:58:34 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, viro@zeniv.linux.org.uk, brauner@kernel.org,
	jack@suse.cz, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, axboe@kernel.dk
Subject: Re: [PATCH] memcg: Don't wait writeback completion when release
 memcg.
Message-ID: <aKY2-sTc5qQmdea4@slm.duckdns.org>
References: <20250820111940.4105766-1-sunjunchao@bytedance.com>
 <20250820111940.4105766-4-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250820111940.4105766-4-sunjunchao@bytedance.com>
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 380A514000D
X-Stat-Signature: 9dbkgbwqf3bjgum49npfgi1ih417x8ak
X-HE-Tag: 1755723516-202247
X-HE-Meta: U2FsdGVkX1+SDbVeemC84zRQ5mfFE663T4Ei8xiMoIWAomlWYpZpyBN6O3BOyp6kv9CK6VYjmgr7GQsP3nH7gdFUxLXEb00B3Nyncutn0DVL5Y7SOTcnQD/psDEPP2POHH9irud5MNx5xRQFVNIz4V6UG7y40B29B0FMzoZYONtEqYozi4ToS/61YdqpQYf+Sh3XjWe/lvzVCez3h21pTUf7mspoq2mZQ4O/C4ow6L/5uCmLNTADpQE7Aw8PRgHXh77AFjlOuNi3M5UXOL8OVCVjNUDvoFwTZHg1chPG65wjym3CVeIcfDJ4DBTFJLhq/c39fXBbhaQznwL2YMaX4rtCMqixraSjFiTiiqiwYsSNuuiHuRMA1qIcynJZGaO2oWuHA+Su+wcgR7FqWnJOifARQRkKW7lDG+1UF1xrGdOvAT9CRDeTnDtQLcr3X9+KngoIfQlPnut7Jm/ABYjMCj/qmwhKPXy3qjSmlhP6OlXcNQJ2FxEMY29dGq4ycnWXZbxXcUuDHrDmAThe0JI+cf23Q6q8Y7AmZbRNQvYwYR9pbQxhDFOEBPVhXZs27lBQZgnxzh36qjGD0NV4XMGNzHovb2gWULa8lsoqk43xr2q6L3bLgz6+Zz/1SgdtqLmSaartiVRDeo3riU7ZCGibEq35EFWnrD7hlcA4wnw3mILKkHP8mMRMH9i89eh4d1ZyDnrWHcQQTlvh35U6/3/AzbsRmUBnQ3tcuuitVq9kxSAnNbPYmw3b7JILDl2GjtafzoFZPvWjdN5W10GwTCwMqsgWx9rfFxdrY3Cu6neO4s+zLOlKxGJ1PB5s3T/MN/P7sMCtMT585/lM9uvkGmcuT931z7sylyN+CPwZIupKbRypuZer+VcEZsdjnl/nyGWHv38Kx20OLJShnJwMCxwwyfV69n38eNx3B2wJstdbeQs9nzQEQZr0/d8qE49YGzIBw8KjSUt91V4fuK9Aiv7
 fZu86H9V
 7FLamXLJ9OIK7TUoM5VXNW3l3QNYis2TFwZsrhppT3ChxHNEFnnUIGy2auRMQcoblejUrQNNfgUZmaY6Ku+sQ6OyvYyaV4j7ZT/N4YEFo6wGBDQtIZjrcOMynmdisBJlYH4aI+slUmtdvBwzSZcK8+1M+rX00Sk8ksqyA4+HswfikBKRSahmZ7ewUbPZMoImr0QFSTbyJc8Ym+InExACSMFsFig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 07:19:40PM +0800, Julian Sun wrote:
> @@ -3912,8 +3921,12 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
>  	int __maybe_unused i;
>  
>  #ifdef CONFIG_CGROUP_WRITEBACK
> -	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++)
> -		wb_wait_for_completion(&memcg->cgwb_frn[i].done);
> +	for (i = 0; i < MEMCG_CGWB_FRN_CNT; i++) {
> +		struct wb_completion *done = memcg->cgwb_frn[i].done;
> +
> +		if (atomic_dec_and_test(&done->cnt))
> +			kfree(done);
> +	}
>  #endif

Can't you just remove done? I don't think it's doing anything after your
changes anyway.

Thanks.

-- 
tejun

