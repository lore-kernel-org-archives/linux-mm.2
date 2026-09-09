Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E03C79FB7
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:02:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E08996B0092; Wed,  9 Sep 2026 13:02:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA316B0093; Wed,  9 Sep 2026 13:02:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD7FD6B0095; Wed,  9 Sep 2026 13:02:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A40136B0092
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:02:23 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EECE11202A8
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:02:22 +0000 (UTC)
X-FDA: 85194842124.06.806E0FB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 623FE4001A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:02:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvHsEybh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788973341;
	b=XhKskNxD1gpA/LB+sh/3PRnu8+LB3P3KatUNAdtlLw+QGFNhzEFRm/aFpz1ZH58hXu1alw
	p8uz2cq6pFKg1uFsvnkuL0Re7KezT2fhRtohcUPYnsWV1FwSs1L1GiHkqssk16oWecxVvm
	GO31wEUidabzy+Ise40zKvaiD0erdbg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BvHsEybh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788973341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DE9TKoe8bwCUSFbC5qwEZF5hRWO7Ho+OMN9J/HSOi+4=;
	b=xYYBXrVx53ZRulPEUFDzP39DTQhAxyYDJ6A8YavYG19JlcGdBcYTrGWwK5EjOA02x7gdDT
	MmgjFBD89sKr186d3Stwt64/A2enk+gHeoocnA/jiPFU4FCZsDZEtPbnccelucFnxOPVV9
	6HbwXrgv/NAvN2+9EM/JXnFjPIZJejo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E6F0C600CB;
	Wed,  9 Sep 2026 17:02:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8C11F000FF;
	Wed,  9 Sep 2026 17:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788973340;
	bh=DE9TKoe8bwCUSFbC5qwEZF5hRWO7Ho+OMN9J/HSOi+4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BvHsEybhbyBhohT255O8m66DWBprZJ0jHpZJ9nttr9EfnqWParDrLvXM68xOR+ceT
	 adjAKMH8V9z7oUDawSh03tPXtiAkiFv2rMtMIEHmy+4/hsQ9YLvQjTBofwdOi1La8k
	 l6kv4/TGLmc5Dlm5/3Yc3+/1jTE2vH3am+N2xfd/DyQDU0bvFavz5fIi5WMyNnK9Qi
	 8D0qTO1D+YwbX7Dize9bFAE/ROsQpb6Fkel0iR1beFJtEPXy0BMGYUAZZ5SNn8J+GP
	 HgHLrdn6YhpuSD6BBH9uAF713ewDuN163ZtMfdRbEQz+hBIGGnvE6yZ+SUz2yEG3ER
	 cA8EdV8lCN9Mg==
Date: Wed, 9 Sep 2026 19:02:11 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Oscar Salvador <osalvador@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/12] mm/sparse: move mem_section init to
 sparse_extreme_init()
Message-ID: <aqGREyCqExRFNCQz@localhost.localdomain>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
 <20260909-b4-sparsemem_cleanups-v1-1-008fc8d579fe@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-1-008fc8d579fe@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 623FE4001A
X-Stat-Signature: tj9fyum18immau6hqtmo6p9gr8i519yx
X-HE-Tag: 1788973341-229157
X-HE-Meta: U2FsdGVkX19UkVHoWdz1z0RiS6zfbpHsx813TgfPj/9bPA/IdFBTfyXzEu1yUzkTKvuMr435qB4pZ9AjJ4wxwRtEjwyLAakxh2ywUKtPZrbpJZ1oJ1NlHXKquA/ivTPgnqzsMpikbu0an2zsiJiED8UwFCJTIPmgm8mf4y340QqyzUGzOiff+PAj/vmUrFwWB1iAqfDXLcc8IyHuOlUSRH6EOUJ4zcpw4Q6LOj3ZHZxsOPc6RffSk/m1sDkpCat123V7uGGll+Wor+7KsVTEKyIiEtvNFgzj1RbZ3YT8+nhQvCvnpEU3Yim/m88RsqhS67mDTeCqORngkPla+I/SFRXReuwcpLb0ib+61rKLX1698kanVPLUxb8EL3R5VlB0aLwum90zNlAvotStPgw1bOcMNm4iZIrpOctjoxZakBgoQm6Me0THUTRKr5I0RU6Lsy05J5AATSIL7I3i69SHBCcVPeHptfge0Ll0jZC9bJS6Y5NdfxbUjweVOFKAVp6SFwGAGDCiE6Ij1Q6KWvyryxyRQ9xvTTdReYLunuIlKNitUPtcDPeGe1IJ8SNBrtJhqukq8kxNH62lebAP3nq0cAiYEYC47AwfEqa4Te5SJ5TkK5Q5wiDRztj1Zv6cOnQsCZzqdlbeqR1ENOlIb8PxtI5BUH6+OcELc4UpM+wCMkfQVefGEawEYlSzPIQdFyggypuemTh89mFc7BA92jOPm0eY8GV3LayFT5IfJ6JiDPNJoaUYc7zjMCfHeJU4JW/QusX2Riu6yOkzIo74fCr/fY4MBvuSGJOp9BUGGmilNJo8qN3BaF+DIhJz8QUxPHzIfbtoXHoSoxWL+gFBqe6jO5kT2RcRZERq4yMn1i+sF/oE9ucoIh54Iey2vs3DrG9+rCUjalWp+bRlmFXA8yedmAP71sJOPCN2FESuR/SpqcVqgm7U1fybRsloC0JrDCQh2wFXWf4TtX6HHolWgVB
 8525/VST
 /UiqD5lIahjUv3VIVXJDZb6zs5Rp6OMUchjVhah2Fxtmbp8QE8xhH5yS2E7Gx9mud3bt9YpSxXVAo0ZYjm2thedbGYrWhdt//aVfaPn+keDhZD10EEGeMqH7/yYo4WRu096YARvp1YInCzwecmu0OJPJiWVUEoBFkHt0jiJpgFPbUJanp/3qUVNjXssajkxeNPLII/ET6ukmFuHV4oO4rJTNL10Pm2ELUth/Puf3tYREd1vl440n6J2a3dPKO/G2EsiZ/EuSDjYYNB00LXVSmzMQ7nFxKIoEzIexzqFKZCnhG0r7nn8hyIcMc5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 09, 2026 at 03:32:54PM +0200, David Hildenbrand (Arm) wrote:
> Let's just avoid another pair of ifdef inside a function. While at it,
> switch to INTERNODE_CACHE_BYTES by just defining a fallback in cache.h
> as well, given that the x86 variant already provides one.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

