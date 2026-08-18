Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12E01C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 19:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DCDC6B018D; Tue, 18 Aug 2026 15:28:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E456B018E; Tue, 18 Aug 2026 15:28:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D2A6B018F; Tue, 18 Aug 2026 15:28:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DFB4A6B018D
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:28:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6923A120208
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:28:48 +0000 (UTC)
X-FDA: 85115377536.21.6A98E44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A7C4CC000C
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:28:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1Ch6BF2p;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787081326;
	b=qTZk6vN7ZCDWT5tkPxDeX5WVx/rOcfXoQsYD8+2H3VJShcgh/6naGYTkWDEmzrpXB/oCjO
	gD698HNjlCQvjjiUsZAdK8kgb4Rtfvz9YVBsxYfa9ralBpaile/boeaA60nEpCYDkIBsBt
	6vG5lK4UISNMA8/mKZeULojn2zV/Nzc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=1Ch6BF2p;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787081326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cZNjCfbYHIfdsRcFPvK2wydI/XjK8b1Rn1pUmZtlJeQ=;
	b=7vLnoDQqzm18cloSM6KNkNsSXywx7f280wYKTKCaI6+DVfOvI2pAXYG/qvWbQXqOJbtb2/
	NX4wgA0NS6xh4iVjlYg0qQsH+7f/5Fq39FS2WuuNH2GU9phOC9iF0Y7MOZF6pKckzcqXLr
	J/rbtQ1i/g1MWNg9Mc0/sCCuZbaxeDw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EAC09601FB;
	Tue, 18 Aug 2026 19:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F77A1F00AC4;
	Tue, 18 Aug 2026 19:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787081325;
	bh=cZNjCfbYHIfdsRcFPvK2wydI/XjK8b1Rn1pUmZtlJeQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=1Ch6BF2pzmORCdDXF6fKXUg5XWDOtX8jdXFDfkMCik+01vWgZJ1w55VmLqepohv8e
	 N2HH1+eTBtBJshqOcMJD8MKD4K+4A1/ewE4P/YoJeysTCe5hs8j82KO00EbkCu9jCZ
	 gfNDcrr3VEJKSxiqXZ5cWBQdlY6kz1nvQFfBsprE=
Date: Tue, 18 Aug 2026 12:28:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Breno Leitao <leitao@debian.org>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng
 Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, Youngjun Park
 <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, Miaohe Lin
 <linmiaohe@huawei.com>, Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm, swap: ratelimit bad swap entry reports
Message-Id: <20260818122844.71988535d6380ba67e8a2b1a@linux-foundation.org>
In-Reply-To: <20260818-swap_part_one-v1-1-a4fc58119fc0@debian.org>
References: <20260818-swap_part_one-v1-1-a4fc58119fc0@debian.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A7C4CC000C
X-Stat-Signature: a3h5zgbnqmczazgkphjgdqumjtuf9iah
X-HE-Tag: 1787081326-957884
X-HE-Meta: U2FsdGVkX1+wOOaGbgbQi1R52SX9q4PwtDNqo3tBEoH7h7ZkwyoHQyvIdwfSjZwrmpa0Co1J6FC2bBjIndw39SfK7rx2SmKboXamUk9equhI6ZfehDdEUbCPQTpHmcyedmUfIlo6Fg1QH7JbhFim1QjdEd6uJ4/vmyw+7zX93nqI3qK9FCop19H7PCDsKQ66lfm564DFyvpqqCV9j1+nDX1VNbUNTcz+vMTuRarMKbJUFlP2X4SoXPY1aLkZ77YRbRZoffsMJfjOTgeQhO+Rt73W7J9UpxHNSDgBY9XFJXYMPxiQI6UMLEgu2CuF0nnPWAhV3uRKLud7yNCraSigBZOgG3m13IB9CF3lbuTTBzIqMmu5fr/AVe13qi8DSL2hsSCfk7VseWI0u80RC3zEOUrqPJ1G5bMda/NKEPxKS7yqahkLQJl76PdG1TK2mR0FUIwTHpPbBoM2NEZaPyh1v7cKLYRm6nGl3W1wKpRkxXpb1+XjaI0BkK7+8ISOkIQtlwHZ8so0Mo9QzkJO577PawxhneTQa5LM9hg4xdrkDXDFFqvW2E95PaiC5y1bTJdQ5Jgtlpw+umQhDZ8WyFK5V1NZ0iWfxUQU/rPJGl+GS4sXSYTsbPkiMTa0DHneb3J726HVkdPo/FK+1pEda94KeYXqv4VRSuVG6tGGsJi5x0IEFFt/dgo9Sz0vB76ZFo6Q8Zpemh+U2Vre52xFuIlm0kFT3V/k8l1ZmNpZ2CVpACOdIQqU/6fUut+TILdTpGeDcJrTaxbXGg57kan0Gg9VdOzTFMbqV+PQZNyT9/2B4/AH6DK4ur1AggHMSm1fJv8zTiv6Ct5O5YwuEryYdrNU8V5s4/gVuWVQD5/2EdIdc1KnTtEXPbYMALGk1iWErWWGcizIcxlofrLuuSv5wkF64P/8Pm93+7iNarblkcjtkwD+DiGe8ih0yjDoyE1iNRRCouHDoTo10lcZJLdrbHG
 5YkwuZzY
 0SajhaKYAKLf85VPNtD7NcVGZec2ElnDIsxQhiEWGH9rI6pAnFMcnlmP4Y1BvPLL+P32OKSJyxS7gVoFDCyX80NjnVcbvHG+LDMBfv+4AK4LsJkbGSS5ApCTkjIw+bVUc51Ko9YGFD8GUHk45HyQqn7wmtNEQZO5m+5tOquKV1VTlzdyw9gJ+qrYmbR1zWdFNfZc8AFODVYELb/Fv7scv1KaUmD5qwynCJ8gT/t/bx5Q6BbGGyCMSb51F304+wR6fH5IcQ4pA7SlH/oETHLTlRph7zqKRmnlhsBk/NHYK1yCQFcWygshsjiTRBPVYq3zeaCdI++z8FNurZIS7+IZ5thayYOnqz7oQ4sNPqbE9vCk5MloCdjFgIvkfd3mPd+n4oF6e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Aug 2026 02:03:40 -0700 Breno Leitao <leitao@debian.org> wrote:

> A corrupt page table hands the same bogus entry to get_swap_device() on
> every access to the mapping, and every rejection is logged. One machine
> logged 6185620 copies of the same line in a few hours.
> 
> swap_dup_entry_direct() prints the same message from the fork path, once
> per call: the WARN_ON_ONCE() guarding it warns once, the pr_err() inside
> does not.
> 
> Rate limit all three prints.

Sashiko suggests that ratelimiting these might cause pre-existing
problems to become worse:
	https://sashiko.dev/#/patchset/20260818-swap_part_one-v1-1-a4fc58119fc0@debian.org

The problem it's identifying does require that unrelated things go
wrong first - get_swap_device() failed, swap_retry_table_alloc() did a
retry.  So presumably you wouldn't have hit this in testing.

Sigh, so much to fix.

