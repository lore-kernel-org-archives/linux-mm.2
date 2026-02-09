Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 495E7E7E0D5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 19:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE2396B00BD; Mon,  9 Feb 2026 14:46:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6B46B00BE; Mon,  9 Feb 2026 14:46:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99CC26B00BF; Mon,  9 Feb 2026 14:46:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 89E666B00BD
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:46:16 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF18F16029E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:46:15 +0000 (UTC)
X-FDA: 84425949510.11.4ED1714
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1717F1C000E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 19:46:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tNizQ9Cz;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770666374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bv5KK0kyOTw3kNXqVQlj54HU89NlrQh84HsWO7IAWSc=;
	b=ZHESZTtvQXLEtQIWEuFOjsru75gbf0lWDAOslA4J8EghWGJV0r4KkXi91EbADVNpZlSR78
	Ul18gFNIUDUY17BQM6bxUNCzSQbeMj7wR9WZk3tovLzPW5gMQ1c3AvbXLGumC8v7xfD2eg
	vaG14XN15sbaGlcTE9z1gZzPvU4nlu8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tNizQ9Cz;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770666374; a=rsa-sha256;
	cv=none;
	b=cYD1Shkt+m8o1LHoSMoOPB6ahj5jW87seq7Zy+6AUB1nkL8HtE/bMZmiiK0MhwbVXZpCzj
	jyv24ug7A9AnE7NwjNncRyZaxTRX6mF2WR3YR63FUsdkfhogWV3g6sTQgBv7OGBzcOeDDO
	eW58Gyo4qUWzINvZXRzg9DuImWhbfuQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CCA8600B0;
	Mon,  9 Feb 2026 19:46:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C501C116C6;
	Mon,  9 Feb 2026 19:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770666373;
	bh=NjsLfTgcSHxbInEjowlv0DjeZPoEztoNp3YDgwdnlf0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tNizQ9Cz4zFrx+Aab+u/InMxiwoNYZQGZz/rYK7u+uYTkpwHGi7dHkFVAGf0CkQJ0
	 Y8pRjFcAzj95DJOxx98TxAdIe0sHJtASEgP572Tz+UX/FecRBmhr4A9a739ETiTn3c
	 SVIcJ9OO6PKVjKcG4W/LWHhqifgSOIHCEBl74venwHcvXb7AVhvQHwLZnnq0t+gAFW
	 /MQ89ixqGCp/z8pwiqGRE1YryoI9ddd5OJv5pk1VQ+66gS+9XfWQM4NhoibsItxduS
	 sCnuOjo7wCq0YaLBM46NZf6Zbfb79/Dc4814+MZkNATA0bfUMhfMlBU1xhxn1LqLxr
	 UqRQbPqmhFYvA==
Message-ID: <7e86e2f0-e581-4772-b468-1da04a214f07@kernel.org>
Date: Mon, 9 Feb 2026 20:46:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/page_alloc: clear page->private in
 free_pages_prepare()
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 npiggin@gmail.com, linux-kernel@vger.kernel.org, kasong@tencent.com,
 hughd@google.com, chrisl@kernel.org, ryncsn@gmail.com,
 stable@vger.kernel.org, willy@infradead.org
References: <209207FE-D3A9-4BE2-8DA7-9BE38A19F387@nvidia.com>
 <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260207173615.146159-1-mikhail.v.gavrilov@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1717F1C000E
X-Stat-Signature: bpawquq9rpjikcg51pnpqo74hg15o8qs
X-Rspam-User: 
X-HE-Tag: 1770666373-62499
X-HE-Meta: U2FsdGVkX1+Fy1s1EepD1OI4y7T1+6C0FbORqNfp6IYMKMiDQfAP2OfJcUe337R4ROo8e14n9FNkaL6yeCB2Nq4OA0DashFFfd645dsqMKpamquc7SaRbAplpjuDhQ4tpqUjTsG1u0AbjSnMFSe0ZO5hGlu+tgMOuIFRfUD//OlSMseFb7rMdJXFepXBv6sktCcymuvtVq48r1D2YVBPB6OlJPmV2I46R5O2wNdhDLA+Aq616rf483XmUWaIYx6Gl4gUnIAT3ZIYfwhjcLL4TykJ8IR7X/RpcE/7HHKQNKIMRaalElWGI/lM2VIqmBfpUaDdrq59eK4UqoQbltpsXQYd9uVvneu0W09vfFTY2kk+KlQmVmsM7szEyLDeWicqI/oV2SzapDWS7k26PFTCrfNNgnYN9NWphdTP2vB2yC/P9wtW6mV0Vpip98cEXqmkCARKpKPv5yX3n9h/Im1AnSJ6inink2BMUZLVFLkECoQLXE7LZ4wmLxz9uC/rpHTHX6UVfoHaSiPIpVSYMdg46omC+yfg2epsfHYRELaVAbBUkFY6m9PyB3ZM+79Uy2LhpXftxhm9IDvubbTbvS5l/tQTuN5qoXFZTfS/CbGQo437OnYSX+BgUNH+JCD07Y0cCcEi4RLsULclk2yoCv2TVf0G2zWBqgO4XhLnm20Iy7GwPYlnK4XzvYnK18fNigDvVSTh0KT13+VSmlu9RLV+3tALNnGAIeMTeVOrJpDroVzZfaEVdaDL8nWiyXFWFG2r83OnHB04ybvjKn8+2GpMmtL0JfsKiwgEnT4U4c+bWGmoPGxm8NXOvyc7oVSve+IcjV2cehTPuvarhGi699Xq4er2dOM7QHThunD6Bg5IAKBh8S7upJuWRD3hhUTAHHwxv0wlf+6qbZEShJWcflE7QbS8I+qL9awUGF1qY841EbQ3dUqsw/zIC4hvaIMG/oKaYA8WEVLNMoip/P61Zxb
 ZQ9HRzqu
 w2zkOCgaV+cNMZKqKDPvE0QSDB5mlwLJrg+UXi79zmGc+NTEHwVqsAZZ8Oc3Fq3NL3+N0WIKEtoJ+bJ7bHIDesJYGoY4WFuCi4ei81LrPLoffE1UltrYB2h2qSPSk6qw/lHvb8isK9zgBsk7Nsapcgx6S4LYxKHFhwTNntcDWf1k0/Dbf4ITB7uHgfwAbY6y/cl4UwgjjQrTvDwKMDzzOFSDEhBP0lovhtnl4Vl4GVGfQ45QW2C5J7E+C/3z9Fv8+dbXzt7WQakaH2mnD3KR7UJKVGVnfNv2qdldYbl/6G1z+Q1aAeuBEZ7kqdu+vmHtm2Kts8ar3X2S9CudfqB2Jgk5NRnZO9Nkoh9cmLAtGOjcLbsQIZwZ1VMmniunuenjOpZbBRTkuPlq4jjF0a5h8NA/0Ncf5aP134/MD0eyiGVKuKR5z1Qp5jtQP2Ah9kGOIcG8C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/7/26 18:36, Mikhail Gavrilov wrote:
> Several subsystems (slub, shmem, ttm, etc.) use page->private but don't
> clear it before freeing pages. When these pages are later allocated as
> high-order pages and split via split_page(), tail pages retain stale
> page->private values.
> 
> This causes a use-after-free in the swap subsystem. The swap code uses
> page->private to track swap count continuations, assuming freshly
> allocated pages have page->private == 0. When stale values are present,
> swap_count_continued() incorrectly assumes the continuation list is valid
> and iterates over uninitialized page->lru containing LIST_POISON values,
> causing a crash:
> 
>    KASAN: maybe wild-memory-access in range [0xdead000000000100-0xdead000000000107]
>    RIP: 0010:__do_sys_swapoff+0x1151/0x1860
> 
> Fix this by clearing page->private in free_pages_prepare(), ensuring all
> freed pages have clean state regardless of previous use.
> 
> Fixes: 3b8000ae185c ("mm/vmalloc: huge vmalloc backing pages should be split rather than compound")
> Cc: stable@vger.kernel.org
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
> ---

Okay, let's do this as a fix, and cleanup the page->private handling 
separately.

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

