Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E98D4D2ED0A
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F3916B008C; Wed,  1 Apr 2026 10:08:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA4F6B0092; Wed,  1 Apr 2026 10:08:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E09F6B0093; Wed,  1 Apr 2026 10:08:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD896B008C
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:08:09 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC3358C691
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:08:08 +0000 (UTC)
X-FDA: 84610166256.24.FC3113E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DF6068000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:08:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J76Ug42E;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J76Ug42E;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775052487; a=rsa-sha256;
	cv=none;
	b=Pu7Jx/JCzq4p7BXOOU19iY/bFuJqoqQMQMyQ2yp5N71C7TaaV/NONl/H8s9uQOz0yIX2aF
	UGJqTQgt71Y0ujtlQTMk62iov+m0ZD9V53BiT4FdS6fr8SGw3Q9n833maVrszBepK8hSoR
	I3AsoTEK7YMLFl5nlY3vY5plpA4jHw4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775052487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tNMXwGjj5cYuNiUVOVd2WCvhceFqZrqwbIJelkfsYY=;
	b=oNh5Vbq5x8RIdDzJYnOC4y+ehjXkEYxlZ8ZNosJJFkcd91V5g37sUSGhT7ORew6Y1qX9qd
	4xR2xyKoflQ6jOzNykmA3heBlTTUSMwUJGaFXlntzlx86g6D+tDgwr+pJ3gdr9Dg2aif63
	YLYHP98X9xWJ0iG739Nuzd6ONBTC5I4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E368F40A69;
	Wed,  1 Apr 2026 14:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7361FC4CEF7;
	Wed,  1 Apr 2026 14:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775052485;
	bh=bVa8O4fwTG1tjCVclLBS4//gcP3cU/KztS+qU9zJiIU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J76Ug42E+fQObk7s9g8QR0SUmtCwVlz3vosaqR92/k9ma26Whbo+9/s7UKl/KV6QN
	 iAmWdjQAmjwejHm4+4BD4x2j2hiWa8mxr+GnywY/itHAigaanX4Ps/zJdLwZEaA54O
	 dDnZarHpco6Ua9OAj7i3OXebtVUd4jCvbMKZjtTx1y2HgBY3k6pl1e8rgbJ6xtkSyT
	 B3JHJ/b/e1XEx9q9oh0zi3ESYg13hZ3ZH5W6prmZV+gpBsZl2B7DKLoCWXFO3JXKfG
	 MG+3eWARiCMWThrcEVv1W30SVPkgQg8w8hFnFMVPCbsZXfgPeAjn4NgPcuGk5A3+lj
	 fMa7I6BGXFMLQ==
Message-ID: <7dadb91c-745d-4fde-8a2b-c141b26823a7@kernel.org>
Date: Wed, 1 Apr 2026 16:08:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 04/13] selftest/mm: fix cgroup task placement and drop
 memory.current checks in hugetlb_reparenting_test.sh
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <1ac1cac332a692e8d2dd70922bb09c0582340143.1774591179.git.sayalip@linux.ibm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <1ac1cac332a692e8d2dd70922bb09c0582340143.1774591179.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DF6068000B
X-Stat-Signature: hrqtw118o8j7tes67w1y8z7r9jo9rn1f
X-Rspam-User: 
X-HE-Tag: 1775052486-13244
X-HE-Meta: U2FsdGVkX19f+80YL+MBf5oomykuIivAi1e0Vxr6dYtmn10sCYKxDdBGqrLKkjYD3ZZWUdU8HiG5ZP//YmwS53+5n+BfHh3XwbXRNr9wW6pDRDZT21fr+YK7dUNkbbrGrcoEF4+JXtsn8OFpXZIXHkO3TmijeJ7pjcONds4dyQteK8CxqGvEaZOLQ3F63hgpkQsp4Ay8bMWzSAbWNugl0BItZBL+ezeW6ijBj6VkzflLnQZqXf8vwtAcHWaZSwwdDJBLbQyZ7EB4HpgWfo1UgvQRNNFeUgfSSXPHYEBjCNqG9r0OEilNUECRG7eAFKi9R2UtmyZekYFW+p3+849QUSNKiNJhXDg1e1/8rr4AWJfohLFI6yKou+gpRwHqdvOSYEHxIlSULj0YweFGFJlHrvHw0H0b96xkNML3pNp5illR+vaYXs3xqXeN9Z3rzTEAZwIi0HaTV2gPyoN3NFfz4jhdvSHm5qGJsvUt+wSWCAf/RpztphpV6cqan0VOtJcgtUx3oQ1v2IoNZ5BbSfQLIaBNtPpQmzPcznnnItel61ko2LZ82yX94bSlh3AKmEbxkR7CGGCgG96fVBXVg3x9T8Guv0vWSrHAQd1e5bu64dCie99F5+RgPzhIXYuAHKBFFluQ2gQvYFgcvLvRLSgNE6t3pXGNV6VvkQ+veEiP9u912oVI9eZOsSmJwwvCMmvL6vdZGRa8W3+Xpsn6884S3H5rb1xKgGBKYe5cI9/qfbYgjfsbQhD2cHTErG8XP77ivZgCYhGnR+t4TX6Op8v1M/z4OpFGsUu7JDgL7rD/nV0w0YvylP/Bdm4jNb1TwylLN//RF1HxjbYa94iUW//3nOE6UQIKZP/fr7OYvJgJbVr2wM+YZSuj5phOsvaTDsWx5P1omIAxQ4b0xmWAF/URFYc9o4aPk7xSS+4aFpIn2iVgTEV+3Oli5YdyV6hGpdw/CSy12QKRVXU7GWg4MRg
 9OpqPomR
 T3eEoNWTzjnOf/Sqj0M02+nE/sSSCkMzDF5S3M/lSnD9m/1Xas9FMVju8qJ68Hlx2CbXEdD/eJYZuIq3k/RU6UZuB5KTVYfJQt+PDls83j8LRfD17pO0pxMkp0eo0Ldclyzr0hILeIOs74qVEcbURBLo7D1fXQi19iIrOcL8hqGidp7Hu+pWd2OJg3aCp8MkP4BUZNwk1SJOZb27ZVj4VjBK8BXru1EiEadWB4pNn/3nEpbFQsLqCRbPB9K9uthkes+gsHJz7Sb6RZcLx+kXHBPw54ZA0l0meDjAMvw8uRh+ghNk13SPavBDMHb/2E5uF9VR0o3T4UJcI25DlUikXyHgLW1ubpFVFFx2CKLKOgXp6JGtCBt54sO5ZrvusXvsjGjJJdmgYOiLvFpP4F/oDNX4zvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 08:15, Sayali Patil wrote:
> Launch write_to_hugetlbfs as a separate process and move only its PID
> into the target cgroup before waiting for completion. This avoids moving
> the test shell itself, prevents unintended charging to the shell, and
> ensures hugetlb and memcg accounting is attributed only to the intended
> workload.
> 
> Add a short delay before the hugetlb allocation to avoid a race where
> memory may be charged before the task migration takes effect, which
> can lead to incorrect accounting and intermittent test failures.

Isn't there still a chance for a race, for example, when running in a VM?

-- 
Cheers,

David

