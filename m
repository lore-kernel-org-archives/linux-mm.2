Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87621CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36ABB6B0098; Tue, 29 Sep 2026 03:41:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3EE6B0099; Tue, 29 Sep 2026 03:41:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3E76B009B; Tue, 29 Sep 2026 03:41:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE5EC6B0098
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:41:54 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BCCF1A041F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:41:54 +0000 (UTC)
X-FDA: 85266005748.18.FE568EB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8BD9940004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:41:52 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eP7n9A61;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790667712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSrpAC8UMMB0qYiMQ+1O1rlIqHLeQMas3ZsG4eip2jw=;
	b=2qs4Ew66GbBBP/msLliKIub7UKFRrUd3C6wzOtU3g80S/lS37I/i50xVH/OOP7B7GcxxYG
	6jr4dZ/VKbx+Vf7ur4bCBlP7PKxq18AWKOcKVKY8xX0DP1Z3q6+/ndu5tCExMQiTW53NDJ
	uFCSE7klUwP3gzoOL2nP8mJ+7fOXOjI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eP7n9A61;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790667712;
	b=7+kej3wNLtM0dYXsDOIVHZJ9D3MUY24b8z9eK2pzl/4suM3M7GR8GHj31EtVF/vzkUO89/
	7fh+AYOdr7oBBWZbLrfBw1jlYVK5MdSe3g90VO6bAZ4kyslm+SdlLjqeegucBPCDsxoPX8
	MRwP22rmOk/PxSJuKUI6IafDH5oY4TQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BAFD84048D;
	Tue, 29 Sep 2026 07:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530681F000FF;
	Tue, 29 Sep 2026 07:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790667711;
	bh=GSrpAC8UMMB0qYiMQ+1O1rlIqHLeQMas3ZsG4eip2jw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=eP7n9A61yORmIgSnGkP5IduRoT3Pxx/cEH/DRB7RVfEi8dF1bIIY5M4VjQsthEAok
	 8oHF7RjRB9ZVbIujX9nDZmMaVuumAKVIIvbBKU5S2hrN2cjuxpbmDaK5oaQnUlnxAE
	 uvZFGbDo2RnyCoXrSKld3VA+q1qHSLOGJ3owCB6I0TMZI/a7IAGmDkyC0kS1M/kOUc
	 wlqr3pNEykCphZXz9UBWTvMAb1y7RRi6z/tDYn/GrC/iWVJchybK/fMhqOcs0TSN9x
	 2Ae0wYiBEJ9oHFeVJ/Ci1XcVKGMJ6IQYY8FJ1YZZ8cZ9NgChCMgUMi+Csr8ShsgMMv
	 tAYqOW9+dNNXw==
Message-ID: <3ae67ab0-ec42-4594-bebc-3c06d4c53eda@kernel.org>
Date: Tue, 29 Sep 2026 09:41:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 11/12] mm/sparse-vmemmap: drop unused
 section_nr_vmemmap_pages() arguments
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-12-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927025441.741633-12-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8BD9940004
X-Rspam-User: 
X-Stat-Signature: g1s7wwnz55zfqtunig5yxq191k9581rt
X-HE-Tag: 1790667712-514050
X-HE-Meta: U2FsdGVkX19pQjrUJC2QChNeS+3mjt3JbTHNMS8l6xyZjCbkYw4eUles9nbdukigGVlHkQUaph7wXk1u8CC8aBmmGvgBa4300xsmqUiX4uB+xbaWy/3r8qRoxbVSwtGW9eCpb9f0YpiFL3+LwcXM0SQY0F7+lY5muyYLX/RujdFfvjT/uz+jMXFeTlKIQWvWh+9ZMPR4RuxHhBFtAYWCni6dIJEKkfiVm/9M0DEJH7lMB4nGIuf3x4PwxLoObkDmdk5vuNBrsdwFlZuAAxCn9sJFNvY4JhYSbAd7gdJect9aZeBqMY9hq63XUbhqKDYLy/a1vhvgiwKpzwV4lF5nBsllG5zU8l814fTmr8je6ITocq6Wfd9oGk3SrmEaY3Bt+USYIrHG/HhoKbCJ/q2vXTl0i55M6e6M9aLbpAHxKifZQARuwQc2xKO35nz3StdvpFsvWK/+jynvWZJTO+KvXupAI7F03qiaAsSYIh/X8eF+fGJxVSyBPu/LMrtFMwf5BzIyOvzmPs+gugoZA1BVkb0DxPCra1bykdqE0Yh8C2mmI7cuXFxc029s5uWIy6tBEXLsvir3V5Ce3zp9dxHNFjdFrUxL/C0GjZIo4OFYiN4gjkxQeDLkfK7mspUQqFpLTG+22mmYWIxxCSab2kXYSclMMFLfGqf9df3x2xS/b6OalX59HolCYc/gA7ars37hv2U6dHOjhsBqFWw+IAz5D0QjzSVox1k4cd1XIlFr1nd1akS1JCg/a2HXdKvo1kMobFhMxm0LVgm54uss2pA4pZTtTjq5yGNxHYwzmEyU3QzLUsI+7KM0iUw5KAwY4h0TCIT97ZiUweIS2GVkE8rdvsxcUKrsu8XgstUZ3PF7EGyvQC7nH6xyyggXRHQjxTqI7/+2nBLk/CXc1tP172YqZp/vzzI3/LL9cRvSnnuZ4Z+yPXioi6gN6tcHmxp20pTK7sk/+Pk22ez5HdrEgNA
 I42vdkzL
 2OAF8e+KE/r7VVa2eCGN/pSPsK067CKY9t4VVAsxu9x1bBi/tJgEFIaIoMKEvCNsQEAg//w8bXgpYIDIFfnB6ySLJ1UNHoCnvMmuCex6Ti/TVVopsfwfpk28PMyS6Nt0Yo8EM/JnRsva5beWPPwrON46lzdbA2QrKJY12+AMJl4ejP7+dLXLuaHNO5PVXDpWY9HoNXGQsb8ycKJBdF/LI4Qd1rOSi6Lx8DrmZARmE44WrR28QRxjEmcxCqLeYnDE2Y+bwdKnghFAfCulb3ybteobpijqaXKPmDYMV+t4Dp7cquiM8LRoXFolPrumQ7Z/IrR/N//sExIuTsi+luyDW7d1d+kaUtq6q4mL6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 04:54, Muchun Song wrote:
> section_nr_vmemmap_pages() no longer uses the altmap or pgmap
> arguments, so drop them from the helper and its callers.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> ---
> v3:
> - Collect Acked-by from Qi Zheng
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

