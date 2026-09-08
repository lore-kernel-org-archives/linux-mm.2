Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96970C79FA0
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7926B0099; Tue,  8 Sep 2026 05:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F336B009D; Tue,  8 Sep 2026 05:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC8B6B00AB; Tue,  8 Sep 2026 05:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E1A86B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:24:05 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 087018048D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:24:05 +0000 (UTC)
X-FDA: 85190058450.06.F3391EA
Received: from mta0.migadu.com (out-3.mta0.migadu.com [91.218.175.3])
	by imf04.hostedemail.com (Postfix) with ESMTP id ECB3840009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:24:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q1Wlwc1t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788859443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IM44ePpO94fxzu9/kZHKicLzbeTfvzqyw+Wr747U33c=;
	b=aAV/tKBRXCQ1bvjLY/WNJTwTeMEWWw34cC8nhjiMrk1OP3Kp/uF1wtbIqDw0IKnysdtyD0
	ZTFaKq9yI5685MQGzccIkJLMw+eKjtHdz0U8PlaaexMGh5JxUvlm0gjbPQDC0lJnfr93+J
	++XGIb8uIYdHAkHXHd8gkxVn+83EsoQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788859443;
	b=nsA0nmVYZ5SolYAVuLI5SLrZbfgayePAwW9h7cksUyYE9e4JrXqBER8jixkeLFmRBw8uJu
	mqs1S+2HTcMzs8A7CNm2rTU5WtbunBrgBx9t3PX6acKCcS2x+WYHU+SnmX6IB5MLB16dbG
	/nNJnHJ5TF7WRLaRTiBAE+jHJ5bRMYY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q1Wlwc1t;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.3 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Lq4ARpMbanal89TxHuI1tA2YfFgMGpzO1BWcDeL62IM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788859441; v=1; x=1789464241;
 b=q1Wlwc1tM+J8SYWg8S7iejZ2/QZ2aXPSQnppHpP1bMmlnNWxW5wCpgLIG40TPtcw7RIBi7Rj
 LvV+ThsluTG0LBe0G4Spoxikele24s034tqj3W1wtLi+OMSKwfOxPQrmCZcfw7AMk4H/WWmCHw2
 hpglh/bDvK+DiVFYi6ZkgXhU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 98e59e83dd11dcc5;
	Tue, 08 Sep 2026 09:24:01 +0000
X-Mizu-Trace-ID: 98e59e83dd11dcc5
X-Migadu-Flow: FLOW_OUT
Message-ID: <bb30518c-9046-418e-b190-9f3f1b542cbe@linux.dev>
Date: Tue, 8 Sep 2026 17:23:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/11] mm/sparse-vmemmap: drop unused
 section_nr_vmemmap_pages() arguments
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Randy Dunlap <rdunlap@infradead.org>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
 <20260908030335.96549-11-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260908030335.96549-11-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: ECB3840009
X-Stat-Signature: 7bzqjmg75epssuikngzzdf8aa4wiepgc
X-Rspam-User: 
X-HE-Tag: 1788859442-564334
X-HE-Meta: U2FsdGVkX18Boad1D4KSxpqGBLl0qJDJ9Y0nUsUh6H7YUCO+CQZQqHmA8YnmM1I7d/XDsuy+Xnc6j9F5+f1kXD88xONFo8BYOK/zqw0HyCXwuBnHnXcRbUPOCxYHqhuGPkjdLe4B5lcUkGszRnkq/sCsFYCKlEQTLIvwnWFdRYF9RC8gc9eBCuuTM5TbRrCoG7zSDy1AG5NucmDmqMYsB6GplfZqx32vKzsgl/SX5IFDq+8i/vRCF4nDCSqAd22WHRNL1cuG1bNDYH67fwc0Z0rO6++uS9fNIMRtyWr4utoyLbDKdPBGp2BDMh/idvZJBsQS48EXGxeGfig23jvRghjnIc+h7+2QOHQgKC6K2+nxLFtkgPnRWzB+RmPfRFq2rguV6vsj6zdEYdmMaPGIFHliytqTEvURuEpLX8ZPM6az2m/mVlRo7PYLy1l0WiUwFoVH5EHh5+0+rsuAEJRIsCQDYT491PTPy9+u4rIqec0voiRuVAEJucG1paJvt+1Q71MGl0o217xB9d8WJKS1aVRnbW65gZI26U/P90jCLqZTcLvr1Eah2BYktFr3Uzq5Nmt8/iIy76MACAUoG2t1ghuXlgm/H5CsgiZUBl71VnA5JqHFc/fojMnDOsHgd3gxPYEa1YYigNbHG94kIua0NHwafuAeJ7Dhe042oCD4T0gHT9iBokdP3vcjOTKKbUcH64cacrvVwUQbI4qbLUIZh6XhtZWkCdUZKpADoV7/KkOBRq+M2BAsrLKqI6qysrWJLPhJzJ83MogIK4+byrnEDqFb52/4xJNKjM3UJHyaBphcJRaLtVcXlmEeIlaVWlkQGOPFmqLP4Py8iN3cF7Z3hZfdGSH489+d0dZpZ+t9fABJd+CGdlaM+5JbJAIjQ7aYV4bG7NQTgi7HBoTKxxguOrplSDcxLyGe29OVdm9GC2SkbtIBwBfei8CeiD1iJzT6GvGJpvqmubMa6OEuco/
 P5aRoX55
 2G3nVA45PwzIvwIQiWqYwDWNATj9Syu5p+34Nh7mGgJ3xMpivCGdhrryngapbSyBxyNYTUaLCqjq4lwFXpVXZ3KEYhJdirpJR9z66kiN4vqxPZtW7jmlxU2CwuZbX5Tyd8GDu5Ht53SCZYADQ4QoZ8EULUzlcsozpy0VycnpJuEsdVfZRi614stuTiZ4tQkw1uBVTleictxXZxZhLSwL4dTgbsH7jD4/QQK7QLWQ9tYOML6ByW0cvSmpJrHy8EH7+huqMBjqCkqCSK7zGq1QQwLnd+xxTo3U/0vWUMrjkKemxMTV+g2DJxD8J2JTZ/G12yGWIWRH+jggHE4Grj3OiZwiweT7aMSkoEBPY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/8/26 11:03 AM, Muchun Song wrote:
> section_nr_vmemmap_pages() no longer uses the altmap or pgmap
> arguments, so drop them from the helper and its callers.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>   mm/sparse-vmemmap.c | 10 ++++------
>   mm/sparse.c         |  3 +--
>   mm/sparse.h         |  6 ++----
>   3 files changed, 7 insertions(+), 12 deletions(-)
> 

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi


