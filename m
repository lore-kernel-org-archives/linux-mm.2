Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3DDB2606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 00:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FxGxOuh/
Received: by kanga.kvack.org (Postfix)
	id 31D2A6B0BF2; Fri, 23 Oct 2026 20:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7426B0BF4; Fri, 23 Oct 2026 20:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16ECE6B0BF6; Fri, 23 Oct 2026 20:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E70BE6B0BF2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 20:32:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E84351A016F
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:32:43 +0000 (UTC)
X-FDA: 85355644206.04.6FD367C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 60A631A0002
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 00:32:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FxGxOuh/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792801962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XyvT2RE/oWa975FzIOJtY2uQYaJ6b76CZmdE3rvCcGg=;
	b=7/lQXlAhstGB+H73m//nwF8YQEBjvWo9uLceRkUJY1Vw7DYrg/q8ocus1vtSH9fqU5ylPs
	jxtbdkUqMmJimKADEcU1/NHMg8igAHkKuGZvHg4yAbVw9Rek//0F67ixfz7FjDEcvB4Xqg
	jti9ptiRt2MkoV7xtUWWMVHTp+NhBKA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="FxGxOuh/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792801962;
	b=rQPTRkt5L11Yhou+Zhey91kv8dgwAaFgSjhe4jStP75nicbJu+UjDjZLlW5X+TUyj9n5zP
	reV8JPRchF/VU+4h/StLMn5sTud+/4jkIdIhy5wlOkH11G+QLmhH5//PN/aavzmFqR2utD
	ZI1hbU0HbUuEW/36P8ym0KOp3aLQtgI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CE80429E4;
	Sat, 24 Oct 2026 00:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5D71F01825;
	Sat, 24 Oct 2026 00:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792801961;
	bh=XyvT2RE/oWa975FzIOJtY2uQYaJ6b76CZmdE3rvCcGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FxGxOuh/qmzaizPy8znUs4Ovs8LBRfCG0WpOIEBXvPML2LdenQK9hFoIwWZ1NSmNt
	 MuJef1AXNcPkYkL3YYRD7q5xpnIfJhxgmEsrJ9GmGbpP3Z2k/yUbwKsNdf2tjkPohV
	 b1V/68EyIIlXe80UExpffL2TLPJuVj17/6j5kXRYw6LPyPjEw4ZYJOmlNsys2cfGG1
	 d6OU06zSF9WH3QUWKdMFkmYwmCtNfOdsoJ5tS+YlMlZyFhwAO3+pJubyBTJqxKRCnC
	 4QAyZ5L0SjDspHzDsmmFunBu+l/sQTW1Eat9cPBaRwCTeHMPkvZ0SQtxXcF25iQV/c
	 XS6vIg+7xTBNw==
From: SJ Park <sj@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH] mm/mempolicy: remove unused mpol_is_preferred_many()
Date: Fri, 23 Oct 2026 17:32:33 -0700
Message-ID: <20261024003234.86981-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023161003.59086-1-ekffu200098@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 60A631A0002
X-Stat-Signature: 75edyr31i6xrrz8sdzttqu81eqhfmpjf
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-14.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792801962-601524
X-HE-Meta: U2FsdGVkX19rq45iJKeWtcP6Z58Bp43OZYEWXBWTOKe+4EVt2281w4jQAG1sfdMlphgZkNxTUOgtfWrgzD2TnkAvUScU95ZCYprQ58zNlaX7PWACTHZKbc15a/GDekfL7DG4eN+FF8rHg4zsWFNaDSAEw9jgNnkAUfk/tvWywR4A4o7CETdY8H73+4e6WnqYcB6YvFtKLUCBZy4mj5oALkOZ4C6pmM4+pWUwRUuhKke+mFVaU3CutOfKeTVkrIjKM4quKuykP9y4k4E1CdALj5OrgSCcXO7nlHwHXJ1KwEWVwG68apKfQJlxfQBHS9EaboAn9ZUv9E4rNNu0xjOl9bQpTrOB9A+qen7w8SHs8ox/w9bLAb4C9X2MzE5YsiwAjA6uWoFEk35Ez+8J6pxvhRe5ufIk/lbOfJTbM+zB2FZF5DCmhSGHPH2Gr+uaXfqEYWjirmxNi2hoPPh+HZqcBxGvqr97+ta/NGBlYXWt7v5yqR+kw+hTk8T3T9WRF3qZ5OBAA2CPqwZL0eAOSslluc0LniwWhpjgaNxJGMJm+g4Q31//dB6+fM1pu8VGqlQ7xaveCONTdlvuxAwo4vxWbGAWwUYXaIDbFzm/onxhW+r3zRx1h7ZFUk5uZ9vTJkdzD3xAiPurlNS5Yirx7bh+tY8p78Z8npE9hY1VTdFs3ufo3QkCUR30UOhtIs9nDrRiwia9o2FiDLJe1/Fw28Uq13gtfq6UEIWHMoqIHDgaB+wxx2MlqgmOZIasAbRpyj6UyA1/z09oIjHCRJ+KhqT/IRqHM5hgJLsuzm+r8JnPh/xaDwbF52mOf4B83Rvd5NbJxIjUfz7xMZ4sheSHwE/TCtt5dwR0mbFBTN/WQLvXX/U2U6LAx2yFc+kCY0QmMLL6g9aWZgy42HKgWzY4y0BM4e4bWMiuTOsRAX/xoMRpDHUZT5ej1Q4eJ4aFzMlbVxjMiPGHjY5EAKQDvsYp5kM
 2g3HimbE
 QYR9aMz8AUYnKVEU62iHeq7jvEkpWrC6EHH7sSwtqhq2BGoHURbmsjQ3iO7TlQ3HnOkD0X5QrFKP6axLeH0ash40vTmaAQONTGQeSz3jhvzdFkjgQ+9bbSqO0Evh0lWHW2YeN7rgDr3LnrQhuKgjtwm/KzRS+Z8L7/6YKJCLEXpN5ZzycirdUUuDQfNd0uzaI5qEooPmGDw4g2aCUchTwHXikw6hfAUxc7Du7qL+IVQTztvGgKgEsAbjJuDVfWgkBrhKiJKHQozVsYxCt2+Et7+MruwZRPYUuCzYPSvWa1HIkXUymY/JmMGobjvhJICCh+/JO2f2Ui+lbe20N7TClvgZlFcg2b0ARohCcDBCHBEAFZE2nmunTJ9yHiazC/oxuti24
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 24 Oct 2026 01:10:01 +0900 Sang-Heon Jeon <ekffu200098@gmail.com> wrote:

> Since commit a492abe28bec ("mm: hugetlb: move mpol interpretation out of
> dequeue_hugetlb_folio_vma()"), mpol_is_preferred_many() has no callers.

Looks correct to me.

> 
> So remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

