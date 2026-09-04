Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E104CC624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 09:05:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6F7D6B0092; Fri,  4 Sep 2026 05:05:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C20946B0095; Fri,  4 Sep 2026 05:05:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B35EE6B0096; Fri,  4 Sep 2026 05:05:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9381D6B0092
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:05:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2B01D80C11
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:05:48 +0000 (UTC)
X-FDA: 85175497176.23.A1E08BC
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1190D180004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 09:05:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lcczhL0i;
	spf=pass (imf16.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788512746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HvVcR1L5HLtDSGjj5QAvynuTIH/BiFENIznYFocO2Uw=;
	b=KOv0WuhxJ0DLcpce/iYkF/PB8DEcyxCOMZ6DCo6uaqNrJ4OlvHKGkoxS1l+EH8fyWPSSZG
	0PKjvWExkrhCzywzyZJy3iV/EhCBii54iuRRxjuZF8f40C9ja5EUqA/QMSnjOq/Y9YvQMj
	7u1tflFe6vgTClWtjECf/plkfCx5yhY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788512746;
	b=69WKLcQ646z23wtuS7LcJ7HnJDNpKxtgX7vEFnF+fMs6P8iEHhp73whrhQi41ydpTaWcOm
	u9KZdONVod2wZye9llRPg9+C7G17cKBZ7rYgjXR1wotT3nu+nlsoUKYxB8Oy2tZs45uoAb
	UVqJlKvhWF7kgnTeU0fmbQCekZrldtU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lcczhL0i;
	spf=pass (imf16.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788512742; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=HvVcR1L5HLtDSGjj5QAvynuTIH/BiFENIznYFocO2Uw=;
	b=lcczhL0i1+cS3e7USBlJfyNcU6OkC6qKih29D+N0aY1oqkIfuAKlGhxK2m41aBPRzX8v0s1ZFQ4nom/Yq/oXpRZq/l3iZIWP/wA7zTyizXIcEX+77cFY8PM+bzZHzmNXOUo+snDgWcFiIkFq/rd3TV0kLfGS3fd/0RSYo5BwM3w=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=28;SR=0;TI=SMTPD_---0XAIQHTh_1788512738;
Received: from 30.178.82.219(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAIQHTh_1788512738 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 17:05:40 +0800
Message-ID: <d40413c0-d826-4797-b768-644f38f4e5b6@linux.alibaba.com>
Date: Fri, 4 Sep 2026 17:05:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm: memcg: settle memory.high debt after THP faults
 with non-blocking gfp
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Xunlei Pang <xlpang@linux.alibaba.com>,
 "Liam R . Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Chris Down <chris@chrisdown.name>, Chuanhua Han <hanchuanhua@oppo.com>,
 Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260904035407.4098627-1-qinyuntan@linux.alibaba.com>
 <20260904035407.4098627-2-qinyuntan@linux.alibaba.com>
 <de28b6a7-7f51-4344-8139-1ec412604062@linux.alibaba.com>
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
In-Reply-To: <de28b6a7-7f51-4344-8139-1ec412604062@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7p61khho5c9o3u918sn53c8774of9q1x
X-Rspamd-Queue-Id: 1190D180004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788512744-808318
X-HE-Meta: U2FsdGVkX19kV62skm/GMXyGZCrHNA2zG3uV8ftf0p1UvJqGeNrqUPJ9OocTdgj3bQegThxY9GGq5fLI1BSGrnjIPJcu/4C4ndCAuqZgwdAv+uez5pAQWL+mjUEePmKzaiXUYSPE8pgzWs3jyAQzufiZOE7tLv4bNfEw/72AFfS5elRC6M1GAQla1/rJII1jyr2tutkX5Nr3LeifxF5JlLI+pNqAj1YWOatjCpXloO4xp7GjAePFVD3OF8BleTrNRUU4L6WhRlxmSxd8fPsgLiDPo1PCKerTTbsfKQ4GBex5c8B1/bViPiC+pzm54yoeh+jILyOdvVO+8BTF7I+9I8dsXNn4MZnXbf9Jbi67hVL3dDSW9qgYQK5cAg2DKDbueo7UEITdqPsIfMhoN+Ii09uJsXJyKk8+qqLTi/01XKU4Mmr93B0BJlBVVDydssaT+lynXnVsTfLIAXnQq4V3zCvN2T1TX2jRlvo7UvkVMZtBlWswUFwW01xvZxdWMCgQTSMVzgcep/5QCk60HzS8l7A6ERuOy3zSbVqtgh/u6cvRPzcr247r7aaDm7eZMNOdwTYlyXgQwUnoxmdpzY6QiPYjRaHi3zIHEpe6pfjN2BRL9u6uVuC46gRGjfUTzgk3uWckr+5AkNrKxcpIPaYKJShk0Ohhj0gkkDILgkn/k3RzJYBYolwEdrz7pTChuOqJrbQrcq3KmraQuLRPALKD6LiUDvkvApWHnjpOKbq/IWbylIKP91TQgMjtVvpAXlYMjirBz/OQAGjdqCxdOLrpE+5zO0knyUtD/fID83YytF625hdfmKPMq2/4VGQwcQkWHB3FcFIS18DT6OMRzsLGbAIDT9vKvRmHVDb6BFPl8VcD21yePiOVkkU0en7IPeKgB8mj+uPIUEt9+yfWV8TbG8fN1fxaHWX5FYskm3D4hi30sTe/ViLXb+/lqkHkbSaiIxFxrA9fTUV/Bzm5vdM
 MJZIVpxX
 d6smpgnQc5qiROD9sc/bde5MvzOLHyyVOAHDc5kwY769AEpZUU9vBTyJ+zrAlitzBPBCx0C9/u923nEUKl4sHCf9QdCU6DRlxWuZTQje64xwvdsCPS3Oi3USgtKNIrM30FB+xCZ0qE+SNylM12+OEo5ZXt07yT4s2XIlmu5qx4f+67TEcdxNCuv7VdzQk6/PqgVlA7aVEaG1Gh/rXNYYFv+5QdqeW8YC4OeixllLGYDxmmUyPyrdPy9h5f8dQhk36qwQSI5G4lGzrP7+Sno50Xv6/8XXrgf6VZICp9Cyp5NGTS8jtFpF9w9KZNYqicg0d/GTw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baolin,

On 9/4/26 2:50 PM, Baolin Wang wrote:
> 
> 
> On 9/4/26 11:54 AM, Qinyun Tan wrote:
> 
> This doesn't convince me. If the user sets defrag=defer, it means large folio allocations should not block, so using gfpflags_allow_blocking() to decide whether to call mem_cgroup_handle_over_high() is reasonable.
> 
> If you call mem_cgroup_handle_over_high() directly in the allocation functions, it would definitely increase allocation latency. This is not what we expect when setting defrag=defer.
> 
> On the other hand, I wonder if briefly exceeding memory.high is really a problem in the real products. If this is only to fix the test_memcg_high_sync selftest below, which is full of magic numbers, I don't think it makes much sense.
> 
I agree defrag expresses that the THP *allocation* should not block,
and the patch keeps the allocation path untouched.

That said, let me share a small comparison I ran, which shows what
this means for memory.high in practice.  Same kernel, one mlock(40M)
in a cgroup with memory.high=30M (no memory.max set), measuring
end-to-end mlock() time:

              no memory.high    memory.high=30M
  THP on      0.00s              2.03s
  THP off     0.01s             33.73s

With 4K pages the populate is throttled on every charge batch and
the cost scales with the overshoot -- memory.high working as
documented.  With THP, all 40M is populated unthrottled and the
entire enforcement collapses into one penalty sleep on return to
userspace, clamped at MEMCG_MAX_HIGH_DELAY_JIFFIES (2s) -- a flat
fee independent of the overshoot (a 200M mlock pays the same 2s).

So the same workload under the same memory.high gets a completely
different level of enforcement depending on the folio order of the
allocation.  That looks more like a design question than anything
else, and I'm not sure the current behavior is what we expect --
would like to hear your thoughts.

Thanks again for taking the time to review, much appreciated!

Thanks,
Qinyun Tan

