Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B66F3CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:01:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272E96B03FB; Mon,  1 Jun 2026 11:01:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223446B03FD; Mon,  1 Jun 2026 11:01:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 139886B03FE; Mon,  1 Jun 2026 11:01:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F3D996B03FB
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:01:03 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD58E1C0056
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:01:03 +0000 (UTC)
X-FDA: 84831656406.08.82023E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6F9B9C0018
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:00:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PfrQB9K1;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=temperror reason="query timed out" header.from=kernel.org (policy=temperror)
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 843AF40057;
	Mon,  1 Jun 2026 15:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DFB61F00893;
	Mon,  1 Jun 2026 15:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780326052;
	bh=K2LGn8OAwrEd9b1/Rv5dGAHkDLQl1TIsvmokPCh8Ww0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfrQB9K11jZD8NBEwmq3WrZQOfxGXWARvhXhRPhZIv5NVXyUNjNgqMmgBaxy6j4Q+
	 xAU7afb29lMPaXPjuPQ8yOlVdzIuiiN6lsqjrXNJupEtTn4RvmLIyc3DuRruNSwS4A
	 4nEYIydueCaeEn5Fd4lJKODXfSJpyVgQURSinZHh1jnetR6/Z81YIKCwPE7lgvnDoH
	 s1aHsjhg3DM5ESolB3OXL+7pF4zD5GlVN+7E4pn5pDIY9uwxsS/F/od2N3KFlOL239
	 IkJiLsMS4MmVHphUW0ms92CqSJoWqcHuegn6QweJvDWACmSYsJjH107K+v2s0jAAVO
	 Viwk6EBBJC+dA==
From: SeongJae Park <sj@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: SeongJae Park <sj@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] MAINTAINERS: add ABI documents for mm
Date: Mon,  1 Jun 2026 08:00:43 -0700
Message-ID: <20260601150043.128330-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <ah1TEcshd2wTroXb@lucifer>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y9gmomzn9ea7jkghsjy5i66zydc8gfto
X-Rspamd-Queue-Id: 6F9B9C0018
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780326053-588144
X-HE-Meta: U2FsdGVkX19bJO/iAtsybHzdI/P4NDW9lTKnA8qB85B95ZLPNLQuz97aY8ezvPnjvI27A21oWIHHVI1BzTRwNWubtvTt2p3lwiTdF4jf9D5MOwNkAFnvIKQaNansXuWjeS3gi463+qg5N2asX/rFK5X2CqtJY6igYK0jObaYg+t09RjGRHFide493J/ItPgtvfLx0Z5x/u1m523QKMW3sgeD/gl0/K+/5gCKhXvoCg4J9XCyVFYklfCOCJkW17UIR0qOBWHf2QPWpYkFRGxGbEREEd2DGy/P8zptvVftNrJ51rmd3u7THt+mnH3bGsdCUgsxRBRcMrytvlcAOfAYYI7LnDnfp6VN8vH6tTJjRZTTx1HZLFSWRmqerlnSWygunRMfr5n2KG95LF5VtINvrrAUwtzoE37fyCmKAtH993S3XdRvKE4tO+xTxLO7+xZSVBnOivQKBAE6G5OI4o4zQr1EGxvrhlUJJ3KpqPemcbjG7PY1u9/5GsGjJsVpHOMShdd+KDb6NH7nSxSoOn72fkoutnUqpEzLRe9ttV71X3GEmu2n4F6ZZvRz+TPOkV3KydfO2OYMXaDPetRpXUNF9VdMoecxWYsTiDxOVj2wh2sA59O4vv4rNlACp0B5BxRPlVnSOZI/9wR3f7rK9CAKmhKKN2rQHqYJMMbYcHsBRSHMGFP3FDTbt99r+843Xu4gyIvL0EShG41Q9fOkqFFeldeu5nZ9JxtcEawcpCSMK/z2SjNXB5sXl6RiSpJ+oGrccq9lnyMPI2wAAgVxE4H5kcZeAnwIhVsA/AYM7EtLzKytk9Na8KVAbhGlpzRu6b1h6IbQNTPyxgNjb76XLekaH4z+90bFSqL+ho68K/bqcrj3pNIJ2fPG7FuP7XuvWPtyiHX7u81H9Gzo/sVwHyHIfBaK5lC4Xxv9GO7sd6TsTha3zDFjeGG3SIEDdYfflSLjX1dAdeVU0TRdRSmJAHO
 hd2R647Q
 V8Xg7A1s5y0S4D21csJwI6vWOuv6fE7T2wtnn+/BVhP4bXi79nhxvsjJ47FxL0mBDk50Ujt2hy8g0ckpIjS8Da1Gsxz2P4kkUQ8K0vyC15w0qIFNcdCwYTAOhw0cMDRkgxKHORvf+xrMlUtLmq8ycZUrzw8LMONxHwnwq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Jun 2026 10:38:53 +0100 Lorenzo Stoakes <ljs@kernel.org> wrote:

> On Sun, May 31, 2026 at 09:19:29PM +0200, David Hildenbrand (Arm) wrote:
> > On 5/30/26 03:18, SeongJae Park wrote:
[...]
> Also LGTM from my side - thanks for doing this SJ! :) So:

I'm happpy to help :)

> 
> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Thank you!


Thanks,
SJ

[...]

