Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B829EB491C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:47:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 942A26B008A; Thu, 12 Feb 2026 07:47:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC566B008C; Thu, 12 Feb 2026 07:47:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF086B0092; Thu, 12 Feb 2026 07:47:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E7286B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:47:42 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 18EF955C90
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:47:42 +0000 (UTC)
X-FDA: 84435781164.14.7432D38
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 61FFE1A000D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:47:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lHionywG;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770900460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=njRlN4d6kNVdpMpfoVti+Ietl1nXYjRsUYDu/Y1qv5c=;
	b=OnOdlGgZsZ8pJzJWwjHB06LK8qtZVWY1YtnAHXShLsCNgMwzV762HEF0QFjZ9zi5f/a3Z9
	4o3FvyAcsdcsKiGPBT3uujhgAUhuIuch42Tx868PHAW8isf60twGOBghEQ2VgeYgASCC/i
	+aMs0NWj8Eg6a9stLBBNu//Nn3A6M3U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lHionywG;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770900460; a=rsa-sha256;
	cv=none;
	b=oQPponeKQF9dEI4uI+a88WU9pd33LamBLEJUP6jF2Xs4+Gc6jcI/ISTsNYNqGDf7/WndpN
	aBTQbcYX/kwCnNflGg96AnDhFkyf6ooSBrt3xMqqXFC2IPfG1/dcecrjZsY0Yuk20rVj01
	cvqfoZSfZ9WA4M/0CNfNf92syPvkMuI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CCB4160018;
	Thu, 12 Feb 2026 12:47:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7E8C4CEF7;
	Thu, 12 Feb 2026 12:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770900459;
	bh=7u+Ah2ekJpSaeBE0rGk9aSzT2yJ1QfSkFI/lI5g1dRE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=lHionywGxDyubOlbZk8DN8Xy578RDJsEfrSCaGl3Cp11wK07buKXQadWsIpZkvqBZ
	 LPA3baWtj7dYXkCyCPCYEIbvjN3CpJpph8flrnIkKEEJi4nqvIiSxli0s3Z2uauNqN
	 wGDwvOE+VrBHjcP6Y75rSdJxG7VWjGl6KTtlZ49zJD+uvHv3vTWrJ2/o3zaASbX9Sm
	 6s1lUJ7TSE1a9VGwGzD4fQi2KDzwKmPzbgyKX9j3Chc0sjibjfVBsRD5/ZOOQcrfik
	 zuqF4zO/rJVZ4HthPS4m2KeudY4PFOO7U6ezhzHTS7tp/CG4B8up4FZrEFUvcmfXzt
	 +G7Y9CTiNJc5Q==
Message-ID: <21a9b331-58ec-4c04-a09e-545ac31f2eca@kernel.org>
Date: Thu, 12 Feb 2026 13:47:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/userfaultfd: fix likely/unlikely annotation in
 move_pages()
To: Matthew Wilcox <willy@infradead.org>,
 Aswin Kumar <aswinkumar3301@gmail.com>
Cc: linux-mm@kvack.org, andrew.morton@linux-foundation.org,
 linux-kernel@vger.kernel.org
References: <20260204142350.1642-1-aswinkumar3301@gmail.com>
 <aYNemlPABKnQkf-x@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYNemlPABKnQkf-x@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wx7dqu3prr57gte7n1dok6sx4tsi3mkw
X-Rspamd-Queue-Id: 61FFE1A000D
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770900460-449770
X-HE-Meta: U2FsdGVkX18I3gK85QeEH0d2ed6vT6H2oYyaqF7yWbb5qWms9fudXSxhi6DMxuRrxgKpZPk3dApWOHZtJaPvKvm9UvKpZfGbUW7h2aTsD4y4fme+4KSVn1pXoM/g6PaNzGpF+U8mcYLsg19uByGY2FDcrzbk0IRSjPfDFGTw4KpAmeP5vsKKqH70ZXGGNdChVrpt2zeBV+WWjefkunHges7N0tN0rDdYjs699oirMgHfZ/ui4KlfnVB49WPkoFoq2lZRvQAMGMkx8BCKUK1V7vakg1PBvmnHNmvi7cU2Ss6R1k0OpMFQlpVlkc+XczshuF82XsTGvVCWQsCt0MbKQbaA6bGbKvSHJI147+tIt6oyvcikb9Us0yDJFdTxRTuKRjjUf5GZAyHU2SEO4c7ZprrlwyA8Hvr3yRTp0p5EJz1OK6LQ2JQ7WFo0Ie59ALiIa/vkhLyzl0XicEa1HPcWEimf03bUdgIq6q8WxWANV6WtMxg4b031awELGXJm49bRx4okKvWL08PyledcXcg+hOFq7H2fg+bdS0Gm7zzDrp17ZTWn9otbt7t+IBlZffbrvULM2YHkrZ2cXSeiWdFbYh1VjjEuWXaLNlN/lhw3TkZTdH+lMRFtiMGxZjG9cQMXIJnzWaEWwwXl/V6/p0vMyLx0M0WmS9pp59ihmG22JtmJmfFsbpLB46lIHYTQbATfiAsdIF8bx9GNZkmanN29W+uHz9/6EvNj8wR1x1jJymo3q7bQSjp0Xp80fvcD/JNavikRYpMvbT9IeF18/ZFMljYG6fKjfgiVehl3gOZdB6Y+NMTcBvZUn9msSKGw951+GQKpFuXNGkL4MRqzQE4/IDCxMPbPVFbsL6HQY1fsU+J97RsN5LkaOwEW+89phPwAsfoitVTd8kBTi1EqZdjlHKwdASHHKOUTJOICZBlmQDbctAaXka90AL3C5TfSxfBs4qdDRufP8Gm/UqWWAnt
 iRIlY7ah
 qSiRtIAQ7w/ETemIIkvWFfaV3RZCHVCqbfSqjrLlhsInmVbWTHiOHKPECRfRQ70dwhDae9i4/U04S5Uz5eEJwWC8JWPipzddNgTHRvptNIc3gXU66WOGAohv8Zdmw5H/gG6Iq/s2BVDC36pUXivTsiz+AScN+ZUgQWrkUwHPQ7S0NdmQVUOpY4LYs4FLLFDJvfzvv0ERXJm6PAmbqTr/dHAbya+WVX0P2YXxkBjct6Bukq22AWXlKbtu/HPOC4IHNcW0Uor0hYFyfXe1Md+UyYp8UHFrvPlUtCejQ0SaJZduQDF0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 15:58, Matthew Wilcox wrote:
> On Wed, Feb 04, 2026 at 02:23:50PM +0000, Aswin Kumar wrote:
>> All other userfaultfd paths use unlikely() for the mmap_changing check,
> 
> No they don't?
> 
> $ git grep mmap_changing mm
> mm/userfaultfd.c:               if (atomic_read(&ctx->mmap_changing))
> mm/userfaultfd.c:       if (atomic_read(&ctx->mmap_changing))
> mm/userfaultfd.c:       if (atomic_read(&ctx->mmap_changing))
> mm/userfaultfd.c:       if (likely(atomic_read(&ctx->mmap_changing)))
> 
>> This is a performance-only fix - the logic is correct but the branch
>> prediction annotation is wrong, potentially causing a minor performance
>> penalty on the fast path.
> 
> Can you measure it?  Bet you can't.
> 
> Honestly, I'd just remove the likely() annotation, not change it to
> unlikely().

Agreed.

-- 
Cheers,

David

