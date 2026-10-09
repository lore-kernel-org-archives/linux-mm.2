Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B042DCA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 05:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90DEE6B0092; Fri,  9 Oct 2026 01:13:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4656B0093; Fri,  9 Oct 2026 01:13:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FABE6B0095; Fri,  9 Oct 2026 01:13:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61B4A6B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 01:13:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC921140182
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:13:22 +0000 (UTC)
X-FDA: 85301919444.02.983177E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 19D6AC0002
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 05:13:20 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UHYExIGv;
	spf=pass (imf22.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791522801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxOA5IA9d/sOcLcOYa/1JDqUTDM1AtvIu5zVhGZruJU=;
	b=awMVMVBcS2pW2cG4np1iehYBOVzI0d50JK4bMu/b1i3y5zO8btNhPRQoZ8BlqYQ/iBv/ok
	0dpociMJg8mrOTviWiaI6NmKS1ZJ2aJZ5uBhd8ZaslwjfnK8AavrzwwVVkejg1lA3L+SVm
	TpIbz4EOku//5hzHieAGdap9fa4w2yA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=UHYExIGv;
	spf=pass (imf22.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791522801;
	b=DHjdNl4lQdWCpr8w4LwZAOKqWer+g38AVbujZy5GEuMMDr0QoVJwDTaNAPOxhJ+WGtBVWA
	JUZj6tIKd3i3PXXsTwhmVcjjMovbk4E3dqLxl4+f3mdKfYjuyANzSqWkAPYcg1t+svN9gC
	xhg0fWg9T02z/YzXqe395RyodrHBvXI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D20B21570;
	Thu,  8 Oct 2026 22:13:16 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00AA63F8C6;
	Thu,  8 Oct 2026 22:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791522800; bh=Up5VW3WVYfkQh6zMtdnmrrbOJdA1MRxjQ2hW3bVNq4Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UHYExIGvLJG3xry06wgT+mB5czOQPwgieOVRyN5R34Wtc2hZfpp6E9BP3strDb0Ro
	 ThxzcoTixdbzkjzZV8R6Pj5EIq8j60y9ZSdDy2rQbk8FpcD8Hqux2VmlqDpYDt/1Aq
	 RcNK3rtmclPaeyQhmtuhkmFMK0VmstvzCEmFltU4=
Message-ID: <9a936154-fca0-4657-80f8-dd736bed7e38@arm.com>
Date: Fri, 9 Oct 2026 10:43:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 3/3] kselftest: mm: introduce size_to_shift() helper
To: Yeoreum Yun <yeoreum.yun@arm.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
References: <20261009-fix_hpage_macro-v5-0-54378ae45add@arm.com>
 <20261009-fix_hpage_macro-v5-3-54378ae45add@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261009-fix_hpage_macro-v5-3-54378ae45add@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 19D6AC0002
X-Stat-Signature: 45mj56s8stsocucbg8mjd1shmac7d6yq
X-HE-Tag: 1791522800-208884
X-HE-Meta: U2FsdGVkX1/WrXpj+M9E2lUHGke/BeyxdocRM3tB5ZV6Z7NiVK+uKjaiYMOu9tAIqj7PL/ZHuWdqGiA+48OkjC9Jswh5o4m47r+HqXmTSyLzmXxamDY8FYLn4iFfQqPKV6Sa9skM+VN3SnQcdj0/5SUeSakM9Z8oLWEn2hiBKnBKRh+Pg2OpAEe6YHRjDH9K20RonWcTXuG38KG/WSQ8leW5lP7s1P0Cqd1+2BqJVjtOJRd2zkjkpKq5SbcPYZH0DpVMAf1oerDglrulz1sqhRxTPjXgTz+mBsE3bi+ARfyLIWl3o464uxaWD0K3DNKbEzx0sKwa7qfNkmm5AeuGKFPVo1f66dURCTX033jLVYs/Th/CklGlNidmx82N9VC3GDkkdnqpo5FHKUneiVZBIuxSejeQidaOzBQ1V16nbnANdhuW73Y1EmrtXrFxZmpqbGZVLF6X7ZPt6i/f9GN0OR0QvX6h+Snn0aSfqaUA+PLp4tU56FonNNpJRpoxb28CXtfJj1uj3q7EbPeyAWHouxib4VDffrCXiAdzSqj7cz2aPjsSg0CcvK2v+vEYtTqxWyxhAqyZALs1aNLBd7Ib5MIzCwkDoBj9lheDk5V4BnF7rZwDTryKudIOT2nRF9obrmWDwRvNnrHqszQcNDpioYBm9YfytL/Rch7IlFVgLZJfdB45+6iZfDlg8PbsaP2zNL6XS7rl8D8MrV4OxSTQuR2QXWYmjcJ43U8hKSa2NQ67NQChWkjT/x71cc2XOeeWO7vc/sRPUc3y/c+N2mKNVXLdRfS5KAtM3ZdP4DpOHfrOm8KqhQklI/Fzl5BGpH0qlS9c3RsXVzHZDLUwg4/j7tlGHDbSVhpP05LULTn8rThPftMz23JdK5nyvSVXpW4Y56y1cBg+uH5hiCQBfqc6LHghIWfLBTO7r3ARN3mOnM8UZ42fyBmm6GFaQmzdrsmgMCgy9SqPT+eSI/31RHf
 51XHKre0
 7nxL+ZWBBmtJCDE32S66YDsbdTznC+bFBc9zAkp8bgt0xgZI8tlA2DmP4U8Chjn9DHVZu4TlKVrXhAblL46+Xg9gBcDfGIotlLxbTboqxu4gwnvjTtpJgOphb4hw9+16/TYojCz/3KmeouTxK6rPo/wZdNF0k6tjCf+3E8bs1K8yl1cj0stBYEgAD/p5fPFLZJb5X7kCPuk186jrnUdTCWAy0Guk41e7afAEyZBmWLduxOEc2IuN3ZYqToeZrfPKqIaOqEQJB4uuNLlQBa0uPJ8Xt8fAsGWkMDcl8bPCcWls9sMucC3GTH8LQI8B2sTSxL647J2Qmyn3yphv9e7B+V96uM7eDlJ5DTCsWX4qK8iXjk5k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/9/26 6:57 AM, Yeoreum Yun wrote:
> Introduce size_to_shift() for future users that need to
> obtain shift of a huge-page which is other than pmd_psize().
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

LGTM.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>


