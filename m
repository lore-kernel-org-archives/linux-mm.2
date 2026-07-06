Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E40FC43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:51:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405D26B00A7; Mon,  6 Jul 2026 04:51:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DDE86B0121; Mon,  6 Jul 2026 04:51:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CC686B0122; Mon,  6 Jul 2026 04:51:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05BB66B00A7
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:51:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8AD6E402DC
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:51:17 +0000 (UTC)
X-FDA: 84957732594.14.0166437
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B8DB81C0009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:51:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMmpIc8B;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XzLv+da1VK2uoG9pUr+oPk8RYYDxZ2UhQ4fGhBT+UfI=;
	b=cY47zk4iM7SeSU0gqJqarrolM+s+xxReKmaBUXhLefTG/QznsL8Z5GuvbnK9Zw2q/+Gkhw
	wbbAbadomj2MeLlkwyEuiY3QylUGFq1BXTFM+1dvFiRWcQ4ZOgPFZ9tr00LaPkzOxLDdV5
	sUQvO2JptX64hOwFt/TPnrhJkMAhm3k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CMmpIc8B;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327875;
	b=4FNv4X4VUqrak/QyKOn5Ms/uScdYw4oIfrhmKppFaTcY9qIDgNLkvSulsFe9M5a04E1Hir
	KcER/MSuNSWtg7bOuqkIJzCPozQ0UJVgp5usPO80z4InFyIZCqJsnBJji2nbXeocflmpsT
	UKYXK4ijXf1k9ZO2f+XRi0uebmccYng=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14BE440AC1;
	Mon,  6 Jul 2026 08:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3632F1F000E9;
	Mon,  6 Jul 2026 08:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783327875;
	bh=XzLv+da1VK2uoG9pUr+oPk8RYYDxZ2UhQ4fGhBT+UfI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CMmpIc8BJghNiDy/pCe9GTyMUvlDSFT5HUMJXFRfF++L/1UvvKWrD9rnn4yjenoVD
	 5dHcgnp0FYUtLagXsim9k2A86Uv16/jzW84Wq2myLedNIHiqEWp0liHjjizBorDkaG
	 0Sg0fukbNdlhhOQjZ5ZL8LLx79gVWn4CtiXUSLxvekkwV6HZX9IEWSiaVYFWEEhNiq
	 k+MQ14GVNEQsBg+eDXeAMmoeow423kX3Ibdm1BdXtIrdTS5CxziVrG7yMm72YIWB2b
	 9NDhD0ZpAMGdJNBMOxUgV8k9avzG0Dx7N5Xrr1JcH8vQZii9SH6/66is7xCTON+Sdl
	 XDgtaStJD8VCg==
Message-ID: <69f71507-0a42-4fdf-af33-2c596657aca1@kernel.org>
Date: Mon, 6 Jul 2026 10:51:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 3/3] mm: move reclaim-internal declarations out of
 swap.h
To: Jianyue Wu <wujianyue000@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Jonathan Corbet
 <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-0-a028e8b5fc3d@gmail.com>
 <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-3-a028e8b5fc3d@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260705-ch-swap-series-plus-folio-lru-cleanup-v7-3-a028e8b5fc3d@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: seoqtzn3r7eazcwe4fpwtxsu145iymo7
X-Rspamd-Queue-Id: B8DB81C0009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783327875-650271
X-HE-Meta: U2FsdGVkX18fKQjLO7Q3zRYm22mL17x9XElVWpG0Jbc/YWPySKBPKWrCuEP6A+cY/aKfFq03YN8qWSAqXmukaH54l+ZYBL3VcpFjG7W3B+6k9Bmen1f8kS6DM/Z654jy2Xk72SQ+Yq2mGjqHsSXue2hbWBh4sOvnDdGv/1L2R5kiaidi073V1wnM7aP85ZEbYjjCUTjbE/41toYR/x6ATF/Jvl0s6tEXT5ZkWtLN5LUvgHRs0uPKy5McIao8mWg5xUQopkgVTfuznfd2cdblVgE4C1G+DdCwJhTSazkHRtlyET5lnJyD0zpHjES6Y3DZGjUj0zAVw+TxIoHtT5NOS/z2QQUEXDckDKiHilLAhHhnIW9CXzRP06gQDSiy4HvUsnOhysgMvQFm+HLlT/Fp41T3Ba+hEWZX2JKn1S+b1XydUeUPHyvdcgdvWtXJ7vsluC/gUOB3lxvXIBFY4vwKKf/kRApehdrhUkPoTzEh9IxnafSeIJmHIBt6N09miFirTWBt7MFdZ1zQPcj1kcLp1bdwSXoULRGXj0CCEcuJMRxfro2sbYirIbVoQr21xQ9VrK+6WU4LP3ka/zlKNs0fLpLrbRPo+bJMVQrM1T2QhFAIbdvcEL6j9q4x8Lp0NxgewiqS2Pw742Kn/dxHYjaBWAGoDbZP/6zs/dZRb4F9wT1RrUCV8aBMDyPp/q7Girr2eW/L8oKaQwzvdVMqnpnZH0/Jm73vGBfr9qUEYkSAdvCJ23+AH34kwtILUmAN+WCGzAFFz8mMgp6RDSLA9KVgl0xCy3QE6djwiGysOLUf4i1gLXvvVNuNIjx1p9tCDw1J+Lo7EHrh13BexXGEE9PtXxd+qtVEgyx9bYXgg/vd4PLq6OK8rvT69OPFQdlBG9nfhHQrNdkkB3bn0FdgkK7ttkLEZbmfuEuBAm5pQnpJ1aAXU0sKQms4cV5CvQEcOXfDOFWPXzwqUyP9zn9VasU
 PS73VMkK
 qlTdr9SJlCvBtzllbc0D4f4FMmIJ8Gcfq8YdHQNkY+hg6CZSvnkZcAsMTLLaqXPBgdEdIw9P4WjQO4pE1jCbF2HdslqdhAxqCqTs/huJ72iEkReuC1Flf+9B3+c/tb9MNFcgxpHBjmy82Or4mRbBNiEl/mOPmRkDp0QozzmOii066cDXo+5cCJYLE31tSAK6a/EnNGAMDOmnX/DwCmxOpMEaJqIecxwtWBTnMeRJDAVArWlTT+eyRQvivBvqgiqWvhCI3r5WRIh3tinkVW9mCgwvGVv2KI171PRKe427pyaF6VJZr2P4H476vx/Pkd5w82QEQME153Bbqt1gl8oCEqY7JEwQSK1SA5xVzzvsXhdslI0pbJvUZzwxsAG9ptCXkAqihe5NQGH1mJ1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/5/26 16:12, Jianyue Wu wrote:
> Keep include/linux/swap.h focused on swap-facing interfaces by moving
> MM-internal reclaim and workingset declarations into mm/internal.h.
> 
> Leave the small set of LRU helper declarations that are used outside mm/
> in swap.h so this cleanup does not need a new public header under
> include/linux/.
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Suggested-by: Baoquan He <bhe@redhat.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
> ---
>  include/linux/swap.h | 75 +++++-----------------------------------------------
>  mm/internal.h        | 67 ++++++++++++++++++++++++++++++++++++++++++++++

We likely want to split that up soon, but let's do that separately.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

