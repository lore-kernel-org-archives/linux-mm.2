Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D88EC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68EB46B00EB; Mon,  3 Aug 2026 09:42:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667056B00EC; Mon,  3 Aug 2026 09:42:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57D5A6B00ED; Mon,  3 Aug 2026 09:42:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3333A6B00EB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:42:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D7821A06CC
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:17:53 +0000 (UTC)
X-FDA: 85059708426.11.452F0FF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7FFCE160004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:17:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkILrIzg;
	spf=pass (imf08.hostedemail.com: domain of chao@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785755871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dxMHEVZ5lvURQccCytgBzz60+hKdTr7VQ/fMX7z8Nl0=;
	b=0q3QYINJQBGuDvPUlSh5JHFL4UCvv/B87+H3SWcHixqg+AMWg5EjMzLelr4x4wvomubjq8
	eYTt0M0E/Ox46VRa+40c3g1KMs8Wks+M3yCWaRuak353m548DUv93vGUUqengXknjbAOkR
	iB7kD52Nl1W5XppPFJtlNuDnGwEthXM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bkILrIzg;
	spf=pass (imf08.hostedemail.com: domain of chao@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chao@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785755871;
	b=7ZQkKMUNg2HU8nrS7f9vPa0bzzmLh//fZE0MtFlOyxVttD28gF/zt8gTt4mXqzxe5ypJE0
	YrmS/o2XrjCRqighHOvGN7Yo8SJGsttNkLFZpUkN0n/EaYY4/9Tkj2hVQYfOd97sm+8ikZ
	e1j7B3DfMay/YWhtM0rKuYp8zy76/IQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 01F6A60A82;
	Mon,  3 Aug 2026 11:17:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C4F1F000E9;
	Mon,  3 Aug 2026 11:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785755870;
	bh=dxMHEVZ5lvURQccCytgBzz60+hKdTr7VQ/fMX7z8Nl0=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To;
	b=bkILrIzgpJ8B4/gwmJ1vUJmKO8vaeVFvaNA7233yvcmyZmalQnHW34+0vwwhM8cmO
	 8UzmxRCKcL6avYHS2XfV1YYFEQuenOlT+P+zHt/9nSkQuLpDLM6qsd2OKhL4vJDuSI
	 b8B5M+IyF/xYRxkrxJ4XOxadWZ6Y4gbWsrp3jR+POQC7dcFasn0kVcSbpxuHu4+wyu
	 HoZjfC16g9h/oBL7wujbvKuqkzIz7ktKYqMYDJFDHP9SmfKqRu6jYhJfdhJFU2ph6Q
	 AOrmwZ65JWx4HtizrSpfjHQF7YbewTqVfrdtHavd6PcKKpbXhAWoQvarLikCgMWfNC
	 g7cqLP1juO/GQ==
Message-ID: <f27a21cb-42fc-4503-972a-6913312cab20@kernel.org>
Date: Mon, 3 Aug 2026 19:17:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: chao@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH RFC 06/14] fs/f2fs: stop using PG_private
To: Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-6-142c97ba3562@nvidia.com>
Content-Language: en-US
From: Chao Yu <chao@kernel.org>
In-Reply-To: <20260731-remove-pg_private-v1-6-142c97ba3562@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7FFCE160004
X-Stat-Signature: n5qkgrrss785udjw363tcxh9abemcpti
X-HE-Tag: 1785755871-607684
X-HE-Meta: U2FsdGVkX1+xBcIFo35MqTo44BwkDsZkATpFrekNfAaqckPoeng/nwxNstk6E11JCV8sq261YofbS5MYfiSF7BlNf4KmYc9h0UPbjzp4o1DBpMSrQDtulGpzW2bOv58+xtSkg9k+wIk/yB3OuQVnWeGk3mVcnfRVrlMRaiWGEND5onOZ1diF+YNhPt8XHHbWrXS444txoLj565ywZHqQs8AFk19CVhApNdP8KgmIAgEu9Mpwe8DlyxGPoa6gmnI5tpLqdYX3yZB/XUbkHI0LowxBm5leDBZg79nub+O+Z2PbWpFat1TYp1ANWtTl42yccOuCi1uE+t/zywk0jMrrWutpL1jEy3w9K7Xw4NJhi3x+eOZM+4gu/u5k6r+XYxbGtZkV5yv4XBU5D6Ghiz2CJaBDvosPa5tK8ZDmK5+vdSs1QPb8ln1BRNatXhllq2VVSK8andGo9N1aT8Ald5KPeBDhObXsWmavyLD+RjolIsjPQproUq0M1cSOgoClSaN44CsunwJzWpWuXJMgnb+D55c7/fkaRgBIXUFuXm/SaM/zTFYJKMtqFAaklndZbzX3HIKlle0sPUH3v8QaM/mlsYSQyO0/aXE4OIaCIAyxlCbiO8uyWoeZWQEHyt/TV6AheKpd9QRHqLyjpDYohsVsmZQSddyfnkGa+DPEuBPwe69Gb+MbpefujCg2WhvJDYHq4rafg8uOOcZSEF6neA5Evo8AVHlUHKgjneEh89HYFYWa0IBN/nW3GatVMYaOF4xdQrtc9wwVlWlz+M+keFxHc4O8ELYy5hmSarjOlUqJip2jypaiPY6pKnBNgnUFWkufcnKzXDZmS8PRFd/Zh3UeuJttiwp3Tnd38lqXb3pDvFEsB8wll52zb2HFG5EQgIVa0gNKh/u0m4SeYPSAQnFzbEHAAxtOIpylKMHnwkCOLJd6MN62QBUdG9jn5dInLA8JUQCoalFHMdZZRstmEqY
 P6hKneRR
 RmFja7nyXkGKtA8I0pfePVTF9yu7uQUJvZKOnmDQGVTJEt6B62BJi7U7bO9I1XP0+g2gkq5c8pEUbSzU71oTHLVH1WCFdU8hykINsvF5KCkKnrUdLBOOZcnnomDtDdQeYBzj7JBNSxgZTCa7iYrWdpguotzAD1hhUN/x+mTsTORW1hsk7wulnfX4jQ2QhVW7Kdnbk14glAN7r6qiu0qpOEC51TqifuIXxaSGDHDcma94wuqdDg9X730A44YoOUeHatL1kHQI4pDl5shzHjISZZaCw9jjqeNxI67ryT5KsyUgk5Jypzyf5Lu4CVMktndXLKerdqn59fjI/npV1YaXkBSKQ5FFsCawwgRKpE4vqn8btQknV5VF9ovjgD5MNFb+PYYOhMtkt9fVHizVn0Wn0HqeKwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/1/26 10:13, Zi Yan wrote:
> f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
> page->private != NULL is equivalent to checking PG_private. Change
> PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
> page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
> but it can cause confusion when PG_private is removed and
> page->private != NULL is used instead. Change it to initialize
> page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
> semantics.
> 
> It prepares for a future commit that removes PG_private.
> 
> No funtional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Jaegeuk Kim <jaegeuk@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: linux-f2fs-devel@lists.sourceforge.net
> Cc: linux-kernel@vger.kernel.org

Acked-by: Chao Yu <chao@kernel.org>

Thanks,

