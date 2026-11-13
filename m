Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70992606A327
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R2O5BE9R
Received: by kanga.kvack.org (Postfix)
	id 7E6286B0636; Thu, 12 Nov 2026 21:33:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796646B0643; Thu, 12 Nov 2026 21:33:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D3B76B0644; Thu, 12 Nov 2026 21:33:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4AF3F6B0636
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:33:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF4898010B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:33:52 +0000 (UTC)
X-FDA: 85428525504.14.3EAA814
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 39DB740006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:33:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R2O5BE9R;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794537231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vo3EuFGzZ8sMiniz968ZKrMVFQcbEM5I9uSXgOOhJ8w=;
	b=1O2fDK2wIgwSpFShPYIClynrzPSObdNCMXPCXRlZcHqxiyZju8la3KTNDu1wXv/hLB6wyE
	HIZkwkjy0Gx0lQ/KM75B2OAXX2myfQVSMLRNmJ+BqwU621PSsfVboSi+3RVce0LRpMCEO5
	tRGU/8P1UP2uW1T8Ej7oCqC41wC5wiI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794537231;
	b=WN8ODFbps+f0Gp+dM7hSmwgyMITLKJaeVOV7DoNijh1eEHKy98NMhFMr7P5V99830m/Tbz
	6QH0hZ9AhsOauVX+QXr7mTbNoaH+gb1RypNlOy5A5RN2NRD7eJqZOFyhP38rtYdwRNBfkG
	fJWZZCAPqKYUTWps7/lXLB94jNshXc8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R2O5BE9R;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 908D86252E;
	Fri, 13 Nov 2026 02:33:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68ECF1F000C4;
	Fri, 13 Nov 2026 02:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794537230;
	bh=vo3EuFGzZ8sMiniz968ZKrMVFQcbEM5I9uSXgOOhJ8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R2O5BE9RfQz3R4GwH6pbaOg77FwMYCfskeCy28RtNXXRKID45E5znoskpMUyVkN1r
	 IOVkVJ2Bw0NqyvNixVYmsqRUNDOZLRjH/7i6c+Oj4JoXO3kFXX2uFeadT3lgojfsBc
	 0dngUo6lzDCUjknWmHmkeVzAquODA2lz9/z9AhUCwcmAm8J1e7QhR4XEnoVagxxRFD
	 3sdHOUb3CUiXreG+qY5h0jE5I9WNYCUlfMK3DBDNkvy4wcKXooraF8L5AmEOqvkS1f
	 3HuYQhJymnw9o9k+1dtZVYfxrxfu7qnhQOlvtOjIdBWgyTttu3SKHBRJlAg/NCQiSQ
	 8/ZrS6jvxNTtA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	dipietro.salvatore@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	Salvatore Dipietro <dipiets@amazon.it>
Subject: Re: [STABLE 7.3.y] 0e05a469c294 ("mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations")
Date: Thu, 12 Nov 2026 21:33:29 -0500
Message-ID: <daily-reply-2026-11-12-1484516151@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261112094205.994560-1-dipiets@amazon.it>
References: <20261112094205.994560-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 39DB740006
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9or9ndkaggbtu85a9s58ht3eq7r4dcyh
X-Rspam-User: 
X-HE-Tag: 1794537231-510257
X-HE-Meta: U2FsdGVkX1/Hr8aSAo/nXS897eFWzblNr3c5bdd7NLRzoq77nshUeapEePbIaQPPB2bVkTWMHPgpTxZY7HsWu13ayuG7+7vh8k1IlXkk3NNs0ihfnEWyzxJvrseA7wjSklJswXKO/zF9BbyEExXn+JzRs2Z6A7GKLzlXZVnEzleH/3XwknZCcVH/sdsh20kPEiSf8/CmJRlRPVDCRpfDeuMbHK+OTFSNYQPfewPW+i3+LltowLJ7lG6vJy/OZsNPxpkWy/hqWti73IIjE8Pg9ZYf9x3bh3RnzF6fbUIaS9eurfa06iK2AFGmMmDyusckkpGL/aa15V7pjIQp6w8PaPGiuBSyaOZ7PUM3Uubd/SPbfbuSWa581HXL3Cj6YV6K4tP0xeyQW5MFhzchuSP8tFAN+vurDstFeSI279T5YR/hJ4IoefOiNkDyze3FV70DfYRSJsjQhsnYvgTx9dd7BSe9/KqawpUvvxqON+VPz0bla1lmf7Y2qk4zTECjzXtV4szGai6wnzV/O6pRdYTaYgSpoxu5evntGypvdQQ4u5hud31FQP3GyXugiP/U3ntbFDdekB8NkdYRGFW/pL0qz7WRF2Y6KSaGmkDtKsPD03fuUODacqvHb/UJLelQ4NJ13M9aYLNu8SE1XjB8UYhCXsoC0/JtIvplAD61eMCVpVziliKTPoiO0i/a8ktjEv57B55Q3VD23DOeUnjO18Lz7EqXGtBoeJnq71gFeISfA2DCLhkWNHmbSJQignDuUDYGhyDMtMhXpUg8tqFmqb4PJRlQ/wdq8JdYeeuyJ7iEQzInOikx1CwTiEHeqoPQpmYx5LT1VRQS5aYNiHGMpF7ZSTmxvhJ/5+eoxEvDHjb7//sbC9zPaEYB/NNp9LBLFF6Gw34VO/dRWshWn8rrmM4rhEzjQdPvCdBbRJz0w5Xup9XP8IKFI8qkXqL0CVGQBrfx9mzsdU+YBi0g52D1Bp+
 98BhBtUs
 tzOc4efRwPAyDOVyEXgKGnjAKZSiLOvvd1p+nayAKatbkubbAGhqSJ8JmSx+67ByuxpXZgtGeMCP17xuenIjhABx1t8qD6X6TJ7bfrlzTfW6+bq8VCK0zGYAHtZ2DTq8tgYAFeH2E/8Jg63e567C6h6UpCBWFnkGfqrL53DKcLBY0YEHdOibk9itXuiR5qKjp3FHRkIZS+XGTUtqNrn6G2OsneqUNRkDsmQ+Gdyj295pDRyA7aMy0MKrHsNxCSzbLyVB+Pd9O8A/fupn53rxLhfNHLTus6TQgmAIBm21RoK6pih/sjvdIKowCkEEgnhapBuSewlMJWlIhSRg57FoDLpRLLRtgEylRADHeCcFqkK/Hg0M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-12, Salvatore Dipietro wrote:
> [STABLE 7.3.y] 0e05a469c294 ("mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations")
> Hi,
> Please apply to 7.3.y:
>   0e05a469c294 ("mm/page_alloc: avoid direct reclaim and compaction for costly __GFP_NORETRY allocations")

Queued for 7.3, thanks.


-- 
Thanks,
Sasha

