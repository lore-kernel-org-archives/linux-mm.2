Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E555606A332
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HDvZ6ex5
Received: by kanga.kvack.org (Postfix)
	id AAC606B062B; Thu, 12 Nov 2026 21:37:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5C416B0647; Thu, 12 Nov 2026 21:37:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 972336B0649; Thu, 12 Nov 2026 21:37:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6985E6B062B
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:37:31 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC2281A013E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:37:30 +0000 (UTC)
X-FDA: 85428534660.22.FA171C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 350D4140007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:37:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HDvZ6ex5;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794537449;
	b=4k5xJVX0EKWvT4kMaiD3kxuVQnI39lJUv3xkY+HgF453vzFgPSqYmwgbIU3gElGYUzpXrN
	udZlH3Nxzu4SLy7BgRFIUocdpp7roXN0CXHZkb9gCx1MqFHJntX4wcWCkQc9FkTE/jLVGm
	bHYmDBnsG4IDF4/4bnBdZw0Yn4OlgPs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794537449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c7xVO+NmGklllKi/pnNJQ5f6BZkQyZyz+72UU6VKSbA=;
	b=sVWg+SdtBnZgwupmmB9okH6rM1gMzoftoOARgw/U2sprofW7i92cH4t0u6nJmzApZh1Q2f
	aZw5vyoyX/UbjqeHI6+W05nzjrBwKDCiFDReEoRGrBoYX8z/7rTJMDJgwVpPHxPXIj25tc
	k1eVyPdD4f+p6i3vyOp1cLqybFCDqAI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HDvZ6ex5;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69EE2434CE;
	Fri, 13 Nov 2026 02:37:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32821F000C4;
	Fri, 13 Nov 2026 02:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794537448;
	bh=c7xVO+NmGklllKi/pnNJQ5f6BZkQyZyz+72UU6VKSbA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HDvZ6ex5mndLiwSybBItN1+QPlX1KOoZqAvJ+RsPkPLPX828lEASG07GMcjmVOP7w
	 wNOxlWkKtT+wuid9MBOoC0w06gT4wqs6y4+6qvmSIIuoUH6VfKZ2f9WPXChjWfM5uH
	 h4QCONLhbPu7nyc6ogBQJGTRB9wYoKrq3vJmHaHo=
Date: Thu, 12 Nov 2026 18:37:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, ahuang12@lenovo.com
Subject: Re: [PATCH mm-unstable 1/1] fs/proc/task_mmu: advance seq_file
 position on interrupted VMA lookup
Message-Id: <20261112183727.68afda9533aff699eea12cdd@linux-foundation.org>
In-Reply-To: <20261112140101.647-1-adrianhuang0701@gmail.com>
References: <20261112140101.647-1-adrianhuang0701@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 350D4140007
X-Rspamd-Server: rspam12
X-Stat-Signature: njqeog9x6m48ykdr5gp8onnmsauyf81p
X-Rspam-User:
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794537449-125388
X-HE-Meta: U2FsdGVkX1+ZnNW0AtQo6wr4kJA3y7RWYslBMByXQsHn+TN8kezvpRwfW3CL6Ya1P9yMg9cvCBnawDmx4RsFKJEx1s42ZIVUTSY3ywbTCX3X5HPnw5fNTNx+LpjHWOwhIt3S8cD1txm5qs2Xb12DUHeiVgfb55omA4CsnCG+tAEYM1S4K/iKhHYSH8J1IaF9MfCZyB9Z5QDz84lGXVC0K1DBE7xsREWG1XUIyWzV2/k3L8bwDoGWybepwaoNFRY//kL13Y24G0EUlDs1otyP+Rau60Qn5Aff05mPwj4zAl7TjboskB7m6ZHgYpumkch7CkldQZnukI/kpUWmCCgXebmSQ+6JLyA42t8Kh3cSJG2ERXBoHA2gXcn3MUNVAUdqggx58BKU/ZchLA3O0TDgiInF6dSviqbTJGHhfiGwLOXo4RqiKfTm+W86FdhQyXmvvW6iQ2NNPbEEcj1JbEFg62IwEtDhrIIENR9xdwO4jzLpeqTwlx1OWkk1csE0csDgK/VuzIst8aKmRwmQxP4ZNvrp9k7X3anh7kzjzw5igR3rJ0+vjhZLvZLYEvvraqaqyRVanPpCs34BT1Z2yFsQfvzjhbpKrck1g5iESRYQAmXPXEwQOXfq0Q/idmZ6z+lD9mXwCR2RGIqXu2OAnnXg7EOtfi/9c0TjSB7ZMV3o+U7PfXLLrwn+nS4cl6b0XUz8d0xaa1Q08yaEu1Lbm347T+Y9Pqokf9/amJ1q5J24zH0Nujf5y9s1BoAVhMyBMrxRJosIwoRgHvGTkJGribulzeTGZ7vwtl7k5KeOnlwl/3B5qhHWw3W6j50wcKN9oEDAYPK+DcnDxczQOY60T+qppFYeGZ4RxQoz4CxWmitMARKONPdi50SwCShalJjR+1f1OPuXcEx9ysSYFXuuneW4KSb49QDc7ogx06+UeIxNd8BSmlQkOc3mFFCGbJGO/+f2kdPZ8s3vfqFJu6Cs1DG
 OnO7BNQd
 qKDsIGL6CtHU5PRqBQz7mBPqd+Zkug3e6fykedDdZ24X2njn6tDWLHpL/FKf4IbwPYkdN9VMQdeHwRtQ/vE1HD7UCIhqEchkLA8EIRSp50D6qcPpECpbBYlsgAZcynFzAFiR8j7M6OCbVafX0y3G3NFKnrU0315vp83H7rfAcc1wPMTRQWtf9TzZOq8v/0QmOYhUn//UdDgpqEwzNzWbWdklak+0karcNxeTLKodLvSlMg6TizDGOaF3vb42bxBIfZFxoKVt/Hg995LGhudqJSKmchww8N7S2H2TAdSlYYtyk5eC7zQ1v1Y7gu8uEuKE2h6bPR3aTYu7kgSNnN9RVERU2kSOt+SbpUlJbunaV7wtuJZz05YNMfhtnOV6HgB1eKctstagyuSCHrv6x/UFx6O0weJiV43p0CUWc9uM1/6WGSu2mAFcL6dAb4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 22:01:01 +0800 "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com> wrote:

> Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under
> per-vma lock") introduced the possibility of returning -EINTR
> from proc_get_vma() when the VMA lookup is interrupted.

OK, but what's causing the interruption?

> When this happens in m_next(), proc_get_vma() returns an error
> pointer without updating the position index. Consequently,
> seq_read_iter() reports:
> 
>   seq_file: buggy .next function m_next did not update position index
> 
> The above buggy message is reproduced by the following command:
> 
>   # stress-ng --vma 0 -t 60

afaict "stress-ng -t" can send SIGALRM, but mmap_read_lock_killable()
only responds to fatal signals.

So please clarify: exactly what is causing this to happen?



