Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACF0AE85363
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 12:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E69D6B0088; Fri,  3 Apr 2026 08:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 597146B0089; Fri,  3 Apr 2026 08:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AC996B008A; Fri,  3 Apr 2026 08:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 399346B0088
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 08:54:17 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 00F36E1422
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 12:54:16 +0000 (UTC)
X-FDA: 84617237754.11.B4AD550
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 556F0140007
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 12:54:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k5RK7Uaa;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775220855;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0bIy2HvjHd6HUlRNa8SxmkAxBp5y9HcpkcsUQNLKfGU=;
	b=7uOy2Wi1Y9+S08/4nGprL8ZOC+4SBvK7SwiB7GJtCFSr7syqN+XyO2iCR0T5q3ojQzqRPf
	Eu87znTJCP9sDhXdkBNAJUIWqkxvxhFOtP6p507U0h099wFndxQp3Y07ru0RFBmVk4z/ZE
	w9n+DQxLGRy9b5AZqJ/X3Dr6zosNtvs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775220855; a=rsa-sha256;
	cv=none;
	b=jIQPvp0CN30CrshxeYlyBkAxGv2QY7jlKk1Lkd83YIui1lbJqH9ohFIAU/m/o19KAULjU2
	T9/T5uFv5J1vEp5IapIvO1wadlZ+TRwypmTVEfcvADo2D7HfTCOC4yMIfpdYJtZzz9jIu6
	r2F6EWq+Z7Qvr7Liu+ytvseyUE7iis8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k5RK7Uaa;
	spf=pass (imf23.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F1CD34442B;
	Fri,  3 Apr 2026 12:54:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D305C4CEF7;
	Fri,  3 Apr 2026 12:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775220853;
	bh=JSDMZ50zmxlMSJSrQFbFqlAhhbTJtyO9Jz1PP7WSjUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k5RK7UaaStNBNTjrkkZugF9FaAH48CF6+MsNeYxjXQJlBC11UeEqtJTn54kJtCCye
	 y12jGio1VmWi5qVjhGjcIVZh4mPy92MUaurFatCaP3hySoPLwib1lCfZxz64Mgobtp
	 AZOHruz4CeULWx789vkplewzZ3kQYGU0JF3+OHtIgExCPlGrGqciiQ9LvGX820GCXZ
	 hJl+MrErarKqqdiKWR5RmQvOJCTOn7IWv+8ULi73jY1BqPAc3RFN97UCoGFY2/3+zs
	 Sr/POPOu9BZPg8GOJDuSAeESXxv8AMAqWcUkoREqPTA7yx3M5oVQTA1itREe5cyGmP
	 XZ8WLJxiE4s5Q==
Date: Fri, 3 Apr 2026 21:54:11 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Andrei Vagin <avagin@google.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	James Houghton <jthoughton@google.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nikita Kalyazin <kalyazin@amazon.com>,
	Oscar Salvador <osalvador@suse.de>,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 04/15] userfaultfd: introduce mfill_get_vma() and
 mfill_put_vma()
Message-ID: <ac-4c0hlgdrxktvJ@hyeyoo>
References: <20260402041156.1377214-1-rppt@kernel.org>
 <20260402041156.1377214-5-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260402041156.1377214-5-rppt@kernel.org>
X-Rspamd-Queue-Id: 556F0140007
X-Stat-Signature: 4qkktnqn67bif7p8a6z7aerahwa7bfwu
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775220855-749941
X-HE-Meta: U2FsdGVkX1/VKCfF9LijIv9GhbV1gXlvNcy1fGn3df3kpD6dzIktwDmaboHjgWe145EGgsUd40QF3XgC5i4opQydzUIjFG5cSPTdP4AIQI++HZciN20sD9ZVhW0CrR/9is+cfTd+KisXjtBNWILb0J2KeTpcZLhZUysc3TzsvfZ2j075bG9Lg9U3LF0psw1bkaOJ1729UmM2hZ2YquiJg+PzHqojVJZe07Xg8s5oKKw6JYyhCTdQ/yCitTmMgKV2u/CeqFgvKs2azGUTNoWzGar90KxRoSvW/4Mlj/2F2M5/GCnc6UtA5N5GCC7nRgns+nWz/vNr54wiKHzSfkKJ68txkIxhy4MHFM8kZOryRNCwgnTZATszvxTarzA5hLaQPSxaH5LvW4jaAbHMLmMGbD+iJWgJFyxZYbdc857mCQGSsUXhcn819yqFW20SwcRzt6ZITKNR4DQuBjK/kj9ytfx5fDXO7AaUyMAxTKqkqrt/D8U/rSkvqTa+4E2k4BIwQlcbwRcVAlY3q+yJzpKOzWvR+37UGIZx0UW5ZqnZK1atRcM03JdlBpbyuM82MG5+LQ1L3EafCsJG9wZ5+WYvFmtOYYGxBcdPrcPSxELhhGwluQEYfT9HcEkZm08UD6RFyoHXRGF9jooSFUTxoUeC6GSshRonWXcJAI7ruSIspeaWO1O0lZdnnBlfe9yNWClkS8feQws2mMJX7w11T+q3BGhGlMVaXuZp7/5FrC/oBx+rkFUH/6icLIqGPfVB4HGyR5Y2g/i38NW4nAWfSfWgENCpjZWbHL6DQfakLY5noftv/fO/mnmBoffq1S9BEo3WICm6vfjyhq0NG2TYZlhsP1T5BrwFxpHUO+z9Ie644YE49fP6TpZ4qO05KTrnkSV0izbeJ82dHYxO8+0z9i5wxhUdDITxbESHUEay9HMk6U1R/9ON3+Fs7+Al7XxMN4Dt8a6TSeSLBZ8dSQEmYYc
 k4s0SWK5
 ERYho8O9rOzDwaSQtLswjvLWbaIpeh9nqyMdfjbPx4Dms23gJRFtTNw9fK3wmc7IrElcgcajl3i7544sL/vMW/Xe9TnghgKE44MjWWzpAITTB64hxzZyQhvhV4kxa5cT88ejf5aDnsxh/1FoEEDlA+Ch4rjZUb7gu9p5oO69wNwKSppgnSGYe5X0YOTHo8Ce0FOzfR36mZG3Z78ZwqsXz/RimLX9xenWNvMD/STaCGUkOCLk5BbL0/uhubbWNiEe6O1bgsnNdOtT7xcMRuYLIFs7my/gPIzex44VonIJj8BAptO8gLZl0s7hABk8WC+scUXWPV8LEM0qyhO5axQVHNOxTRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 02, 2026 at 07:11:45AM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Split the code that finds, locks and verifies VMA from mfill_atomic() into
> a helper function.
> 
> This function will be used later during refactoring of
> mfill_atomic_pte_copy().
> 
> Add a counterpart mfill_put_vma() helper that unlocks the VMA and releases
> map_changing_lock.
> 
> [avagin@google.com: fix lock leak in mfill_get_vma()]
> Link: https://lkml.kernel.org/r/20260316173829.1126728-1-avagin@google.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Andrei Vagin <avagin@google.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

