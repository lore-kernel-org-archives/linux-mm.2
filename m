Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38E1ACA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 22:41:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D946B0005; Wed, 10 Sep 2025 18:41:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6188E0006; Wed, 10 Sep 2025 18:41:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5329D8E0001; Wed, 10 Sep 2025 18:41:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45F516B0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 18:41:03 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2F9A140325
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:41:02 +0000 (UTC)
X-FDA: 83874812364.17.78131D4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5E7A4120003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:41:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MN9wBiof;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757544061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Dcw9/G0hnRZW8UTi6zVoPrVUotmEJn2Z75ZY2eZcK0=;
	b=YIiSy/fmc/0rfsG6a89uwsEn+ol8Wbs5bJqxQK/zpmiI1eFyAOqV+VlFYvCc9hxatuvs7E
	F2q9ZwSvCaldMkuXb0wnpx0GVlzyT5eLEdFK+OYh7+kg8ghJL8xBUNOB4bTcIlLKQtIcFa
	yotjLGk2L2VlnfNLyVR7OfOKP0M/Wqg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757544061; a=rsa-sha256;
	cv=none;
	b=28rOleRJU1fN8SNQ47SwChVqZk2YzBBAcoaNOcPGzmtHBzGfgzq8t5ikQjC4hQruoc63BJ
	iUbwP5PtPF87xRB9+HZf1AtJ5XPdcaOwoi+BHCSk9ci9hT8nFnQcFIzup1ytAAyE43cxkm
	WcUrxW8wPjRfhBiu5fdVrRj1bWN72TQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MN9wBiof;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63C66600B0;
	Wed, 10 Sep 2025 22:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B79CC4CEEB;
	Wed, 10 Sep 2025 22:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757544060;
	bh=TMJqa8O8IQsauMof+lR/u1sGz9Yy4baUV6tf/oB6K5g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MN9wBiof4cTGyl3Cc2xv1mj4goUe6R7u5v+Ite63exIxpE3VTY2FG4t3t1YBSfzI2
	 OGpPMqUnWkxwZtepa1IrS7MOMT/b8ukY/7RxyH8XKk/GiyJOWoZShrmVrhBM/WwgNl
	 kP1s8uL1xiEqg5XgPwIS67G6HkJvaCc2GjTaXHU4=
Date: Wed, 10 Sep 2025 15:40:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Matthew Wilcox <willy@infradead.org>, Hugh Dickins
 <hughd@google.com>, Chris Li <chrisl@kernel.org>, Barry Song
 <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, Nhat Pham
 <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>,
 Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v3 00/15] mm, swap: introduce swap table as swap cache
 (phase I)
Message-Id: <20250910154058.5947c4b4ff6dac6cc4f89007@linux-foundation.org>
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5E7A4120003
X-Stat-Signature: hcki58kpz4e9zpor1ak7ubm845sz9n4r
X-Rspam-User: 
X-HE-Tag: 1757544061-394999
X-HE-Meta: U2FsdGVkX18EkjBCsl72rXCQgOd8cIyG4FaqyCXcU60NDo599E6Zr9y9IbT1YxeK3/U1H38ia8s9k3MfS2tFDV4B3WmQkTG7Y/10OnqZ3UULymlk0SgWdxEQGCHO9D3nFeZhjva5OJC5bAHXqRz5cTnYCkBu1dG/PykXON3H/gaOHOF9+kv5XPbBhHHx9OLZSIX9jApG5B7yUSD1E069eBpS9dfHNA/DhQis4sRXsXcFGLbiUCJBkmcli/s6ybnWMSdXganKfWeRgaS0q1+hHezC/oqRrhx3w/7xYkQBw/PO/T86xJm8PHT7+h/MEMfmC5xU600R4ffJdj8Xj0D7qpApH9uGMLZiCINBePV8NGansn46iMDu0XOB8Y95scv9uzgP2hWWW4BSh4UqCifx6AA6L79+nOZCr0qib+MG9eorGHCk6C/xDLUEU/SqtSO93am+I6Wdc9vmthSz64uUlK8lFBbc0AcLAxUJ1wNIXnXbgYexfDapsnPqYuj7JAo8XHzx0uh2qxDzuNvbhtZbansNqyZCfiB+O4qbm3eOl3n6xpKD/bjPvIJ8zZxK0Vsn/QlpEYewFq/p+VkCbwHNMwlbfHqew0mGYFB+3BTNJalV4oK/FR6QHwM+gj6XR8A0b1yTfLE4At/eHigcQN2uI8jbxiW10p0QLdRgyPeh5HXx6MLJasAqIc7tGXMRMhWSDHan0BbmFl/3vAuSV9PqA3VITavPpkYnrp14IFP8UsGu5YW5Y5bPmfjYRG1uQzd7eNPu6pEA4nOQmE6QjIf5S55ImcF4qW3kJdNKE7Klasx8oadzRUyjSKLmumhrQOY7C3xxeS2u6C1ZgCF0cdQ2Qp6rY3FxFIbkbmK2J0u4CVbFxU7LSOAxFIenvlJ1Va8Q/EHQeQwF5Cal9fzfr2BEVRA64Bv/luVMG7+JjhR+pIwD0bxbnB8+zjBnREJBwCYYuGQnvAa+ldMx4Lgzbg4
 d/JU/aNc
 c/czjyl2K4PC7P/1UBMDm4/6KBvCwA7gpELnZWQ/fZ3whUhk8iPmB3yFjtt064G49oe6wndN8k56GG2d9sM30/j+wYWS//gqu6lxO8CedrVVVUrSISnwbE45rN3Mq0rT2QvDAyzl1qFfa4qsgKqt67km770pATACDGn+aUcPvg8f9p/H8BBqmorvyxEHw+lXpC69LlbJgqXst9Nc5X81aaFy6wpB6h9xkl07XYtsIut6dbkUvwMDCqpl1YC3WxFzrjYacD5KlVDZ7wjmVahtF4j5Rzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Sep 2025 00:08:18 +0800 Kairui Song <ryncsn@gmail.com> wrote:

> V3 changes:
> There is basically no code change, mostly clean up and comment changes.
> - Renames a few variable and functions [ David Hildenbrand, Chris Li ]
> - Move the folio_matches_swap_entry check under unuse_pte in patch 5
>   [ David Hildenbrand ].
> - Remove two redundant function params for the folio replace helper in
>   patch 10, and add comment about folio setup [ David Hildenbrand ].
> - Move the shmem clean up patch after the API rename patch to fix build
>   error, no code change. [ Baolin Wang ]
> - Fix build error with !SWAP and !SHMEM config. [ Klara Modin, SeongJae Park ]
> - Fix a few typo and blank lines [ David Hildenbrand ]
> - Minor code style change [ Chris Li ].
> - Fix documentation warning from bot. [ Chris Li ]

Thanks, I updated mm-unstable to this v3 series.



