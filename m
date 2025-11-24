Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F047FCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 11:03:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E0F6B0098; Mon, 24 Nov 2025 06:03:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435736B0099; Mon, 24 Nov 2025 06:03:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B0B6B009B; Mon, 24 Nov 2025 06:03:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1FCE66B0098
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:03:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7CC64ECE7
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:03:27 +0000 (UTC)
X-FDA: 84145214454.24.FC6D3AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 082341A0004
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:03:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tAXJgd8K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763982206; a=rsa-sha256;
	cv=none;
	b=GBhqOz4UvG25o57QFVnyfQ1Dq9UH4jqh6ucxBSbUkTVTXhXvni9MiROGR7LZhJohgmnwVC
	dTWXg+lieki01FJv5bIGjWvRCQS8mj/UZnyro4l6xHTeKIn0k1l9neSbHqy6rCRLXOjwOy
	TWhOKjr8EctVEO8Kriwx644E7ThBrUU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tAXJgd8K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763982206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sy6WqMY6M1O1R0n5g1DBh8RjPYVNARXygJZgYeGGgjo=;
	b=wGKMPL+yxppOmPK2kurugAM8UoDtGWxmVLelm5PQ20L4fZbkRR/LBTyrYPG2+azEqolMWz
	Rv/X6UhhHxAwcGzATgvFVHLe3mYedkRcCBRXQizEDJES0hhVWtE1PzKYPGRS8CJBDwFbvo
	IwfTv99r20HnY9nSlBDvEof+N5cIEbM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 357DE60190;
	Mon, 24 Nov 2025 11:03:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E8FC4CEFB;
	Mon, 24 Nov 2025 11:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763982204;
	bh=dPX6RM/71Vh3Rg6mMUUHNMjki5uHeW9Di7AFUe06SIM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tAXJgd8KRu8Q5V9aLwauZ1k+fElq8tVU+jgRk9V8z9tI8Wt82uOnUMl4A41BAxhlH
	 a97WXS50IpqSn9hKKdunuS4HBW2ES2f0Vv6k68wx8XxHSXmvVPAbatbuM8ocpG2k3s
	 W78fXij3OS3qK5KaDT+OO9o+l8Csdaj/Xz161iBtcKql4r5F2AgBR/M2a25HYp1yHD
	 b81IFqXfFkgCxXe0QBvBzGoAjRknxrnmYYbwqgP6tqBPcxW/GAuT4vGKtCGbRpmb86
	 8p6A0ytk0HtSUfUyuLrEC3z7MWaPMnyKG8LvVPtKjJw3gd3LZCWvJj/PwioCnqL9fY
	 mJK76Wr1oG7pQ==
Message-ID: <a06e57ff-b77b-44fd-9b69-929d7647644b@kernel.org>
Date: Mon, 24 Nov 2025 12:03:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] userfaultfd, shmem: use a VMA callback to handle
 UFFDIO_CONTINUE
To: Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org
Cc: Andrea Arcangeli <aarcange@redhat.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Hugh Dickins
 <hughd@google.com>, James Houghton <jthoughton@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Nikita Kalyazin <kalyazin@amazon.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <20251123102707.559422-1-rppt@kernel.org>
 <20251123102707.559422-3-rppt@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251123102707.559422-3-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 082341A0004
X-Stat-Signature: 4xxtwzsau1iwb4sdjfkae6xfk4kfye9z
X-HE-Tag: 1763982205-92784
X-HE-Meta: U2FsdGVkX1/Dy2FGr/u77BUbwNB9OQZAJnqVQb1vn53u+S4kF7LlbCo2wwYdWt6aTQ1KtEukvBUKXJoriOVUChUGHrLIpW2te5QvpECLiG91HKjTyz1ZNmXQAoKXTe0I+Cxh6S7bKnA4L9f2he3O4zjLgDmETj+Sxip2MPEA/TX4QAEz9ie7yLVEDQiXoHO8k7WCP66Gq/rNMVRe0diRKoHhvLfmgBUfWbe2UOSymCZNR6vWQosLlvnvS4qIKR37zMRZsRGLjcI/4n29u/SH9RF8C8gRkSWmRY8SStK/YZrVuE0Hbc8UY9jyyLpY9bCq9ZNEluf83bamuoBjZ1EErkBsc+xMgTIArMuWT6OODMWwsJKicfEwB4IYFSMZuc4kIbFsdACVxZ/PJfG4smh0+/uKBOcPYafzObBwfC7SEXgfin0SGGEu/KTmuB/RKxR8bBqsVzIMQ6PCEs0Z7OQA8ggWdwfcdc+APL9DEY1GHKxl4JleFXzn5XfMdufxPRW4pE2ySUzMlppQivx4xIx375FLBez3eDQkek0m6/YcquMRUFohDbfY6zoGmWbAbPOyspiqcScAABStjowhq1BzZf5wRwCo9aYRWKOiTFxWQtc2zpv9XBywZmaSQ0/BYkQ8sElQLa+S0dLaXyBrKT8njjGFtE9/YdHVl6JCXX2tFqvjbN+X1Y7urupi3U38ceK14Fd5QmJ9a2I5HQ2t+wbXuMtRLyeld2Oan66oZmH85vo9WUP87mI/AyUNoDMjtAdtMqBxkOtCcypu0NGRFO64Svawv1k9iiCWUpX4apaWP6Lc0+ZU79ayJ9lU75U6u/mLDomBWQc2KBggcM8Pa+GIPAAtjmChnksMQh1UL//P6R/xKVwpo3pcvQ3mwTgwzQqaEAEzM3LtqrJCyHqOFnWRLym2ZZoG8RAkDIRWiQb18W1GiUaK56xMeajT1iBLCcrE7fu/TREQ5qv+OWiorzP
 AdcAQTxV
 BUSbYSwsBvyN6vOieOj1d9MiXxP7M73hfJcxyKuS8brKEFCEgkViaBgtZon5qYvgaihUQG+oST4prwbeOLtObcND76r/5bO1svXZUQ9QyROr1iEHDUwPI239+uNfTstL5FXUa6JjJsagtnTifVsf1VrWODEvNjh51LF/avkrZrsqKFdR9ZHCCgdxvh4FVUW1UgfZMpA+YXwmi6qXzYRsNujxDbWA1tTiZ6QetJcQw3oMwrbbaJEk/Hua+US10iO2DyIwIyUg3IsSuNalNzYw0WOe85GZ7l59PZQFPiSEr+J+loV75pm9ft5wxFfySUOfcWZXOzNT+f5Ne5f0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/23/25 11:27, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> When userspace resolves a page fault in a shmem VMA with UFFDIO_CONTINUE
> it needs to get a folio that already exists in the pagecache backing
> that VMA.
> 
> Instead of using shmem_get_folio() for that, add a get_pagecache_folio()

get_shared_folio()

Given that the helper now no longer receives a VMA, I assume we can just 
really call it get_folio() and the "shared" part would be implicit. 
(from the inode)

> method to 'struct vm_operations_struct' that will return a folio if it
> exists in the VMA's pagecache at given pgoff.
> 
> Implement get_pagecache_folio() method for shmem and slightly refactor
> userfaultfd's mfill_atomic() and mfill_atomic_pte_continue() to support
> this new API.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Nothing else jumped at me :)

-- 
Cheers

David

