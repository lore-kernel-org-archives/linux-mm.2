Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40142CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 19:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B1A6B0023; Fri, 29 Aug 2025 15:07:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 632E06B002A; Fri, 29 Aug 2025 15:07:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 549536B002F; Fri, 29 Aug 2025 15:07:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41EDC6B0023
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:07:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EAB718589F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:07:32 +0000 (UTC)
X-FDA: 83830728744.20.BA84E07
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5787818000F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:07:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=maMdnIWk;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756494451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=plDYCsclX4/jGAKMFpCtOmX0Iz6ElDhn+hIBKH14ouM=;
	b=hLowxGWXR7q2peWIKSChzMsi0Ea5YOC0bkazvE9xVyIhRvcoBBHiOBfiNoiReIFO5cypbs
	fHUzRn+XboC/h7m+/9FCF+du1FzwxteiNe1op9gM4L9YMKda8bgAnGRbJsANhPffjbjUK0
	r1ue0b8Jx9Vu3iEfbERaucLf06thAyo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=maMdnIWk;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756494451; a=rsa-sha256;
	cv=none;
	b=tcmpW05psiv9dGFkjGCLuTIS1SqN2dOx9kfJuCBhg5bBvJ0gomqlru+VcPmRT9Mph8nTS5
	tsXEArbZsLhY7BNbGWFL0ZWpYAwWkK/KIt31x/I/3SQewbUjD4vwW/U3ZLsMHM6iDq4s1J
	7vrer0KMBF7z4ILZEcYLvNX1kRUqTu8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8C8EF6014D;
	Fri, 29 Aug 2025 19:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D322C4CEF0;
	Fri, 29 Aug 2025 19:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756494450;
	bh=1Shi8HJrteTcOySM/bdJs2aeSH/sLRydCCsiHIebN7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=maMdnIWkF/k0CEl1/wG66nhX5O+AKCirshD5t3aZABep2ejOazOLulBkrPP8HZh6e
	 g8aQse/iYVDueyL7axACXOq5H6snn87RL10izSFOzRCvJHAGV586zGKMEUVDrv7Nvc
	 a11IxNRkDivBLUv1DymNfo5CLWc/cPUgzA7Qy8idC0W0eGuOhQ1DAH32JRA91q6dGY
	 BVxg1bnPaT7wBv9UUxHYtt1oM4cAbbEwX+GxDwupyLSpBglcJCINlkRhktnMObnvFx
	 n0/Vw7ZQYiBC+z602mptQJCJv8Xbi1oKWzamKlA5gCb9WCA3QaNCLFRsHpit3tP5p9
	 M451sfa+0Lh1A==
From: SeongJae Park <sj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosryahmed@google.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <zhouchengming@bytedance.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: remove unused zpool layer
Date: Fri, 29 Aug 2025 12:07:28 -0700
Message-Id: <20250829190728.60675-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250829162212.208258-3-hannes@cmpxchg.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5787818000F
X-Rspam-User: 
X-Stat-Signature: dbfjbonhg7qczk3u47tymq3rmwbut6xt
X-Rspamd-Server: rspam09
X-HE-Tag: 1756494451-660880
X-HE-Meta: U2FsdGVkX1/CpiEwRYCB/tyHqdg85NL4+0RoJ/3noD1bf65pCQbFF13kNjaz6CnW4/86421K1YKVLmGkUwo4mfKrWqUMPux1ENkkCIJFs/7gUPZYh9haItdL4bjZZ0MbyFus9zskwoW0jLm5BQE/cfhEGZLZwr7k9rk/Ndy1AdzWPgH446bMjuu0rsocSzdFPs7QIdotsA7QZ3hJsjOl+fIhNSLNOfg9WTKFe9WxYF0SPnLuBiEyxrnVrcZT8P114tlujoJmd8rbcl9Kfvj8cGTfBXArLRyc2vhFfIq7Kz4I2JbIWlavHkbauj6ZMjcMiq7I6S7darzqjnqNt0RicbUHohJmCfh7rir03JW+ov/KcAFwZ3ByDxdRV9cb8XrPbitgg0Rrx5Ricq5JAyCBo4+cUvOsBvTlyscSV9ATw3Qo5RBaXIpUqNsk7OLrkmQzoc9jc7pl4q01rmsmJ4AEw61S43hmcLTtNzHkvRWkqFdHXvwTR+b22u5SHNgR06y92gKUWlbwGlbI5nBXhn8ONiOpqNVmKiXxF6/adVCvt4kD+bGqPJXVvXsd37KnKZooWvjMBnReakEOgL3HXGHK6vxgnh9LEPSoaHHYj51WF1Y4hLvsrlnZ/k9Q4REIU/E54+XCb9CuuLZTb2b2+EIz6vCSJvF2sv5mEWsZE2GCklAV5b/RKO9fpWR8AXau84b8+kaZQHI5NSKzvw50a+KpuStw2NPBgI8xiWkEO5oy2V21JyDIPzeHErn9ttq3GGBx1CWrIkw9G5iLhlo0n8YG6Cxwt0O9ozgou5ADeCUjYolcfH6iXXqEEcCzfM6GkoTvzwTAQ0o5vc0cFdpJsWkvob7l3O8PQoG6j544dFSXB0XaF/iiwDR0C1UklRSYovgclKERxr3E1OjiWnoKGeO9yPAwHzl3bFH5DCwF+TkskbuNgEX4jd3ePQHbrAoTC2BoDdivpA54nrdPzxQExq1
 YfpMi5sy
 rzCnnfSzoqHqiIq4NRe4hejHc2kE1iOGqEk0bFqGoA2RFevR3pCcCIOcjM5ekqbFR0jTchQHjpJNsoc6pvqxaJuU/gg5Iumim4kQukSmmv1qXzRsrDwqRLy4lofPwuVYuQeZi6FfwVGzuXpDpdgzUk/Fp9KbdyIwrXFZI231vwtQlTaaEIQYasAa0S8Y8dAJYDvgCad6km8J8R+JUKraw9l4OcuHxcJiFKY1rTTM1Bp1qF3I2Tadz2XyWSE6THzVuh0v0UmwkQFMZ0NDz8zOd3EwLojDkMgR8H9R+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 29 Aug 2025 17:15:27 +0100 Johannes Weiner <hannes@cmpxchg.org> wrote:

> With zswap using zsmalloc directly, there are no more in-tree users of
> this code. Remove it.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
[...]
> --- a/Documentation/admin-guide/mm/zswap.rst
> +++ b/Documentation/admin-guide/mm/zswap.rst
[...]
>  When a swap page is passed from swapout to zswap, zswap maintains a mapping
> -of the swap entry, a combination of the swap type and swap offset, to the zpool
> -handle that references that compressed swap page.  This mapping is achieved
> -with a red-black tree per swap type.  The swap offset is the search key for the
> -tree nodes.

Nit.  s/red-black tree/xarray/ ?

Other than that,

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

