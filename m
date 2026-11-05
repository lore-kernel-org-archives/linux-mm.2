Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46CC2606EEB3
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gLKKX8Wd
Received: by kanga.kvack.org (Postfix)
	id 5C7BA6B05B6; Thu,  5 Nov 2026 04:50:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59D706B05B7; Thu,  5 Nov 2026 04:50:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD996B05B8; Thu,  5 Nov 2026 04:50:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 287AB6B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:50:33 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A84BE8099F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:50:32 +0000 (UTC)
X-FDA: 85400595504.12.9ADB2D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1384F20008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:50:30 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gLKKX8Wd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793872231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eKvOk6hqjka5HPdZ35CJThnwv8GeMdInJ5jOI/7/YwE=;
	b=U37Ix/PycAnrBCrD+pOglnFqlV34F7FcMNF8xPbd4D+I0LHgnmUjFvXHdUrZeJ1Y6vI3Fk
	hTX4FFA1lY5fNCbw2Bv9NW7hBDr3AatrySFybFKh2VR0GKd85WZRBBfoyzSLZ+I0tsUSNb
	nAmYaxwFYAtuVjzXsAiruF02b4/bx+U=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gLKKX8Wd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793872231;
	b=nkQ+oznEqMwT809T56iALg1zfXVX0SyRLFrK9zodtH5dXcJ0QxaER9n9KENQzPYWMCEdSo
	NS4SxVl3iznUgvxKAQafZLeWZKL2WYmTCBn7Lk8pChSNeybTUWxozbh7el7DbjwTudOBAI
	cxrb288PG+D/VLbr+gywBbWpXwPWwl4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A10560D90;
	Thu,  5 Nov 2026 09:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9A51F0093A;
	Thu,  5 Nov 2026 09:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793872230;
	bh=eKvOk6hqjka5HPdZ35CJThnwv8GeMdInJ5jOI/7/YwE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=gLKKX8Wd//E5jldGnKbwM1rC476RYrG/9KK0TriRxzreefZGhKF9PtPjB463sQJ58
	 0fI4jd7HL1cKiQPGquBTp1BEiIDgx69fOkdw1+jEUuli/DXjug9cKpVlSyvfNrRYQx
	 iJVmxDfVbUwzt6uSkuGnbcOv7f7DPipHlbPCRJkabT2oV/8TWL1W6sp3yWpc79r8jd
	 CcRi78X8/yVqJjSU3m9ZYj4uOhZmle4STN0OCNzqfEvNEwCqLMxG6Nm78F1dmnitdJ
	 BrMIf7cJcCl9lyjHZ1H9dd0buPQPvAmeQLKjHyYifPhZMLM/maLUZKtckm5Y/VsBH1
	 8lcp07Nn/N2hw==
From: David Hildenbrand <david@kernel.org>
To: linux-mm@kvack.org, "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
 harry@kernel.org, stable@vger.kernel.org
In-Reply-To: <20261030161234.1505367-1-gourry@gourry.net>
References: <20261030161234.1505367-1-gourry@gourry.net>
Subject: Re: [PATCH v2] mm/mempolicy: recompute automatic interleave
 weights on memory hotplug
Message-Id: <179387222742.14716.9173968610487237394.b4-ty@b4>
Date: Thu, 05 Nov 2026 10:50:27 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1384F20008
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: huqozxpkwqtj58fxz3ndhjzgb373ycor
X-HE-Tag: 1793872230-665618
X-HE-Meta: U2FsdGVkX18pUXCNfpiiydC0XCIr1JBsLT0khtlCySN1eec90rK5DbkOI6mPuk50SaEmJT8dYjxV58g0CQbvxp638bC2T2EXjGH54QkskrjvLn9iHfjxq+T8mhuo+UiWKjYbelCXQhzR2aZcBdKT0BG2WJIDWvJ//k+vnBH3PtqYeur3Bcsd79NpUp3bSjsbgSui69VBm8cQnolVv8LW9ZWLBmiP+/DF9Pq/PwRMUFxOxYjd/9KVUvjrqFVDskZfmFULeduRdAvboMrOdjpWstIWIheh6WHd7yMaJ3Z93jNEOocgkueS0QHIzWaVJxd6W/IluseeeZXzGlaIjUKbEbNSHKJVyv0darKREu1ua8u6rXHC2J9Nz/D3+RG4ZmQfiK83pYwTOblGL3RmounMdY7UV3xsOYTSaanes5vcs0b07pbZgyiQOF1VUXiKvJoG7D7ilO5XomQTDCuZSabC7OAS7H4SAilkNwlwc8SsINDYfaWQy4T5Gm/7jDCC6CDqNYpubWL+nIQACrKUX7wjBlbAso0bZ0TObndrK0j0N5VBxcckHgwMqJbOVSPZ0DBr+qtqDN7EKh6TqdLmgZsB2rWDEuoUz/PmxdN9vIYRNG9xAjnKCUrqLxQofo3THd6f+yYA/SqoNtVKaSXoJK+w+Cd355sjurHafCbj6J8XWVZ5sv1lwIJ/l7vBqgNX7YRsVp7qxXG6aaJxatVNWMTnNrtykZ7iDby3TAg9577N9iWxmTrFMjxt3zC9TFN6bKmaIrlF12n0e8EUB3NvfkAiWkaPKtZ1gSjpGqiC6nXvMzNKoUGGpPuCS8p4Iw4lf+5SuC9cJupQ1/BcB7i+TUel1WcwjkTr+/8Q3WcqLEW+PuOs7LWHFRFTTpkUPp3ga4IO4tdJNk5f8vjds8rbQOqY3kLBqlf0jVSRC74GkNK/tlSNq52jBF3CnDHrKesALrb4L0CLr7IExdE3nF9hIva
 BmPO9aIq
 CRuNNtGVO7eAIGX3FFGYDfK2wH2pnL1lSM8ZULKb3rDQkx92DczRLM4kD0llq/APXlkjYQrpNLRm3Mm8TZ95dzEScP37z4AMURXIjkn34jf7WL1ZPTlTh19ESe6eongPPXzFqu4UN58SgTnoRkGxPeoSdh7J6tUasG7X1gGZlPMh1Mll/UirhFpWRWfGDg5y0Y07J7w9lEF6RVvo6BVOOoSGSKO2rp1uXXl7BerUdfFudXEHQI2LY3PGtDv6deqWK932P8um2IV02p5g9fS4N3hJ1dKM9IZrrBts+5TL4MSjG280EsaEkdNVANfBqUPjK9ReP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 12:12:34 -0400, Gregory Price (Meta) wrote:
> In auto mode, weighted interleave derives each node's weight from its
> bandwidth, reduced over the nodes in N_MEMORY. HMAT and CXL report a
> node's bandwidth once, when the node first gains memory, and nothing
> else on the hotplug path recomputes the weights.
> 
> This can result in a major skew in distribution and overload tiers
> with more data than their respective bandwidth can support, resulting
> in a performance regression.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: mempolicy-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/mempolicy: recompute automatic interleave weights on memory hotplug
      https://git.kernel.org/mm/core/c/ece8f7dc

-- 
Cheers,

David


