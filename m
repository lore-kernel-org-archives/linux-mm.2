Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0626DFC72CB
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 17:11:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E57F16B0088; Sun, 22 Mar 2026 13:11:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E08B66B0096; Sun, 22 Mar 2026 13:11:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1EE66B009B; Sun, 22 Mar 2026 13:11:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C138E6B0088
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:11:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61CACBB297
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:11:25 +0000 (UTC)
X-FDA: 84574340130.01.3D22CE2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id AB58D1A0007
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:11:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KMREz7MM;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774199483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tK/IFAOJ/mYnO16YIRvGNNF8Gxw/NbezDdVKJWAgI0o=;
	b=yM8p9b/IDs85uQ2N8E4mzJHeCh6bq/lUdValBXjFm1SjFzn9lwB1MNFWAJkeullGEIFKHc
	1tx+nniU0UsVLiKJELwqK/WdNmpili3ZQU72FaWNd4iSbsPv8VTHsSAryCwJiDs1RyI0JH
	C05h1bHvqxq6vVkfxPGOMcGy9NJsVNs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KMREz7MM;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774199483; a=rsa-sha256;
	cv=none;
	b=p9g6Xc8TbhZ6HSzpIBc86xARHycCkP5AIWwijU0/macb9VAxJioNEq2NByCuSFg42h3LGb
	NVpBcADoe11W/mq1IKlidXmWX8przxY4XPZo4I3HKWNpo7aJsWXKolKhepOjZSCan0kYOV
	xz4d+eFDTv9BtGViU7KS8nLAf5JgVks=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE55240DAC;
	Sun, 22 Mar 2026 17:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AEE5C19424;
	Sun, 22 Mar 2026 17:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774199482;
	bh=1GWDWgR17ErUUXJrTZk+G7OZwGwEUaiSwip7+aut2Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KMREz7MMbbGt8fgJ1q5oJOSMdkWWglYdNCAcEN+6mKr/d6uxSPo4tanA/9MWx0g5a
	 PuCpvuZuy/5EHORXS5moIQxTamsgJTEKqRpMQ/XDComCVI48Aq4IFQlgdJlr9x5zt5
	 XiwB93IgDbWZccYZRIGGjxVMCzDRIa3A/n9CzA4Vn6Z6ZCrYRMqVs2s6OeplAQSK0p
	 uiRltAG6me1pzcwYJ+b2XYGTQMg7boNVL766m4DkkxqdAK4b7qIS6FbJ19o/yJ/lxz
	 cSDuxhVtpFrJMN7C+n913IbxguuR9hHDW5toILWbvG+lGz8Z1YghCkFmPbi/W8c1bW
	 mDIbTowoq6d8A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko status) [RFC PATCH v4 00/10] mm/damon: let DAMON be paused and resumed
Date: Sun, 22 Mar 2026 10:11:13 -0700
Message-ID: <20260322171114.83314-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322170506.82977-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AB58D1A0007
X-Stat-Signature: p4s8m41r4o7hbf153pijpqh66zyd746o
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774199483-733607
X-HE-Meta: U2FsdGVkX1/MOTDaAkV+jdePmrJz/Q2JmnHL/uAS8bTWEYyKWKplgFxEsgTe3THe/trllcmTjIfERq2DFIWGecgpsvVJQ8jOSJw1Nbdxn9mrj5VQ3HzmjeHVF/k58p9FMng703PnkmE6iMG7gFuuh/YXOy2Mf9pXjO/MjxH2Z96DnJyM0bW6Z2mFKq5LTr7oT8u+CakRyRQ22pyIcYLl6y4rPPWLqVwP7OY8vI4k/b42uqIkQId3+E+6DjznqpPf5HMosCnBIivCtCS395l6yTBdFfNkfwoeiQRl3q3XQKkdNcfBS668/qyntAh8u3SWu0T4fiGmKYtCRIK/DKit7oi0Ql81W9iTzEDR+CN0Lt1YuvKbreYz6sUN4zf31vSYcLdDYqS9q7u3rsmFhI6zjL5uktkn7SDWEgcGmVawYuRV7W/bHUz1nWhBanzNiDaU+p1L1880EmviNg9zKTYilhKIiK0KIhdL8VR1UCPASjLSBcKNu0v0jrQTFB0mOgp8O46lmw7LZxVT4d6rDx2ZVRCoijVzI8bCzHvoKS9dIiei+TRkqKxhsNGUbaoYejFH12hlF3z7rkrjDVTaPQd0s5fHCUowuhU7Yp24W9TevIg5yGmYIK0NK1N4ZGv2ytcB7tAUf/s0jsLYh6QnrmICl6qBrPFoKs+Jh4kb2qVhYG4KySFWAW3kezEgASHjJ6rVE9PBnXw/wOFoPqd78waSDiIN1n2IlbigTei/YXtn/3fPkZfWShQ0QCw2rYl7oZTeFS9TpG78ejIOidL/Wuo/Mx5gEglZf7M4voYkGTjsd+Skl66FbP4BhKlUMrDwsvtgYP2MJeOBjf63MtzjZXDXsAnC+JY5hS2fpTpcdocc554VTP11ft5dDEckhAo8ripH03ILqhkluceF9dYPdrknY3nMZYpXRfOFtbpB+e3xLEwcT/TcyAvjwJy8MxuMrPaHCcgdmEwG/PWe8tUJbbw
 24N4k1Zj
 VvXUChVcslcEGqHQ5GF3hdjJvC50E26otUPH/knHUBubacet89FASg7pxwS7F4Cn5i6HJ/U+NPfjFloaDwAndTk1l/4IwRd8V5tgSw3KURPNpjpI3ONJdvNNiVo654oPESpq9Xolw9zZll0sLrDMIsqPyB6tT3q/TSJAYOysElQa2azv7609wEZtnKdVbZNO5ec9tUEvYMi7IXVn1HxZ8qJ/YlaX7nz8baBYrSft1G+rTJudQZjERHWIhGLqdi1KwYh7dTRHIpGMVCTykDpjJ4M62t8KN7LTFwaRO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 10:05:05 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding sashiko.dev review status for this thread.
> 
> # review url: https://sashiko.dev/#/patchset/20260322155728.81434-1-sj@kernel.org
> 
> - [RFC PATCH v4 01/10] mm/damon/core: introduce damon_ctx->paused
>   - status: Reviewed
>   - review: ISSUES MAY FOUND
> - [RFC PATCH v4 02/10] mm/damon/sysfs: add pause file under context dir
>   - status: Reviewed
>   - review: No issues found.
> - [RFC PATCH v4 03/10] Docs/mm/damon/design: update for context pause/resume feature
>   - status: Reviewed
>   - review: No issues found.
> - [RFC PATCH v4 04/10] Docs/admin-guide/mm/damon/usage: update for pause file
>   - status: Reviewed
>   - review: No issues found.
> - [RFC PATCH v4 05/10] Docs/ABI/damon: update for pause sysfs file
>   - status: Reviewed
>   - review: No issues found.
> - [RFC PATCH v4 06/10] mm/damon/tests/core-kunit: test pause commitment
>   - status: Reviewed
>   - review: No issues found.
> - [RFC PATCH v4 07/10] selftests/damon/_damon_sysfs: support pause file staging
>   - status: Pending
>   - review: ISSUES MAY FOUND

The status is pending.  'ISSUES MAY FOUND' is a bug of hkml.  I'm fixing it.


Thanks,
SJ

[...]

