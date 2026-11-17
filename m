Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6DA6606A330
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 21:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C26y9o1+
Received: by kanga.kvack.org (Postfix)
	id C39216B00EF; Tue, 17 Nov 2026 16:22:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C10CF6B05B0; Tue, 17 Nov 2026 16:22:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00176B05B1; Tue, 17 Nov 2026 16:22:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92A8A6B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 16:22:21 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E971E1205C2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:20 +0000 (UTC)
X-FDA: 85445884440.15.D1DD1E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 42647120006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 21:22:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C26y9o1+;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794950539;
	b=lWJe/xKkoufOLSu/mT8vCEq6/DomvC2w/TTQwat0AlwIYMgDb7Vu2zEcf2FQ0ODA0jpPT7
	B25bkz6duU3mtzzNT0Sf4Q0Sh53rWoIjMXpbjfPL9VuN2r0F+frvDP61uinHVGqrP/lYak
	thSzmsosjbElb5ckWq2xgkf/EeydEtU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C26y9o1+;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794950539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FeCT63aSkz/VhoJT6891eWVwy4XaOtOt1ms2iF5hk/M=;
	b=FMx4pb98Vo0W4Z8M5rkImzX7mvCvur0iMy+o7wmCIXZgG77GRvMFYWBUD1N5ei7Br1qIw2
	nMbbRiWhL6gKJ100OfkDWn48KWX7lBMuDeNwIaHmN4h4QLyYyo0RdfZ8ZeEPmUcSy4jPRp
	sMNkPrX76OP+20Pix4QhWU1geaKVPYE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67D0841330;
	Tue, 17 Nov 2026 21:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8BCA1F000C4;
	Tue, 17 Nov 2026 21:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794950538;
	bh=FeCT63aSkz/VhoJT6891eWVwy4XaOtOt1ms2iF5hk/M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=C26y9o1+nWX5rbIxEPoTXu6eAf4pOY/zxhGIIxnY9lboROWO9mDJvV1O4TONfP/pZ
	 QqXdWdHGUxi1GCKV5ysDzii9d0HhWEINL2pff3pA3lj7kIwRGo0yji4nVz2ewPSDVY
	 TEz/gfWJfuY7IqmG80r1CmprsRmkoDkbUVWVRzILMQqjm9YXd+vNUV9hRQiSit3pIG
	 pbY/VvZLcp7UOs5XpARuNFnsO05dcz0v4nMEw3YfRSdc+d73XC8zvUwjgqOm+s7TfC
	 Oh63dpOURFQ3sRV9KMKcXACtnQzqUNdbIxidyBqn9780GD++3ohF25r2kIM/Q8gsVl
	 OskHUcArEm3Wg==
From: David Hildenbrand <david@kernel.org>
To: Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>, 
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>, 
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>, 
 Ross Zwisler <zwisler@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
In-Reply-To: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
References: <20261116-dirty_file_pmd-v2-0-571883053174@kernel.org>
Subject: Re: [PATCH v2 0/2] mm/huge_memory: flush dirty file PMDs before
 removing rmap
Message-Id: <179495053051.3499.18428844631976887655.b4-ty@b4>
Date: Tue, 17 Nov 2026 22:22:10 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: kmmqs6ebfod5w3zfkajh3nmqmr8efnif
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42647120006
X-HE-Tag: 1794950539-235581
X-HE-Meta: U2FsdGVkX180uH4HC3hqfdSrukWfCqfiQWPXtcMa4WMcxhEA4uwtfrVeCMz7HOF9uHLLFFotYhM0NMPW+tuIJFYVJElIXXo8z9RWALbQBQ6ASEsViyX/B6kYG3fufp2wVm3YtaVe6yhRPFRscNQC6JhBULxZh96FBQbs34+gTa1kOTOtEhHxAtDY2vK5xmFOdC0BVWChtyVVXtNYWkGe7wdZCkce2qW8IZHcJSLKHnzXW0/kEgC9H5TFw2aJmKwnc6hrRSr98imuKsprFQ0+mk7dP9OBGClcAP69jVUfguENX9gjsoqSydM/BGbYZ8kaxBcprKl4m2porTNTNvB2sjTOzN7fehSR0rkutOyRE521cGtOjeLlpOu9uMJQ+XBmXibm+EXMX+ATP7qFtQXdbhq/wEqaJS/hQmV0Aq2r5GFMZAAs+gH69ZSMKbejXHmiymnE5ltvn8Y+QwgG1KxY2hVV7enC39csoKDNzPCOok6UUq/pGorCa+GgoBu+jc6PWmE0UGxk59DVLwNK7lXq6ozs3c7EYD8P9TKdf5IbhYt8rcNwdEYJ9FPeG+HKG9/BMsAoU4FWUBqX3xXWG7C6hCfJ8uizGZlH1YSYllSH+WzZ2+mhvL9HuthqlNTf8t+BV2Cz8LEICOXfmk/1G80UTwsjengfFcxzmHvyArryCUrNfJn6nwCRIOzSjT9ZvxtF2DTtNCKY6zBjevlVyl3UefOxk0PLA7hluCjrBbtYOdkrsOYZueeLSzfukbxKXkXLGt0ZNuuaKarNugv5ezy8dglIsSQ32f7JDB65VHTcZVhusDDNC4Qv3R6JSl9eq5dhI/0Ezoz0B4tDkqOzSWW1AbAinR703+jstilp+7YAPPMz9q6/K1hMqx7F1O1VYZ7/Ew8noTv6eECfCuhg9zZCp4jUzofaZ+nHzLdKiEhkHYeyVeugPXZOX4XEbdevFvDZTixE+ea0DtC4pYA/zOV
 G5/zRL9V
 wo0OLSwK+5BgNnK/lwb/yahAV8XjHYEFuF+lbOwlCzEy+oLO8v9EdbM4vkAwYiM6krHJIVb1ZS2idX+vQEMHzgwX2nBMrVfyG2N554Q+7tyyW5gZ/x4LX1X/LqRA2H+sqkH4iwSxbjoI3yL2GHoXH21SEkrPTogbw06r3QMieWUvvA39U32lleNrlPtGvdyIV32loEXUVfhYBk2VK9WySC8NSplJailydKA4v60wG8OYSnDrFtq6BLkxb5h0G8vfBfDN8EDoJSX4Pk5J6KmP6FwHLttE4r+ncApFE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 16 Nov 2026 16:06:57 +0100, David Hildenbrand (Arm) wrote:
> Details in #2. Now includes a fix for a preexisting issue on UP in #1.

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/2] mm/mmu_gather: delay rmap removal on UP as well
      https://git.kernel.org/mm/core/c/7faf889c
[2/2] mm/huge_memory: flush dirty file PMDs before removing rmap
      https://git.kernel.org/mm/core/c/5a1f5d89

-- 
Cheers,

David


