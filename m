Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60369F3095B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 13:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38066B009F; Thu,  5 Mar 2026 08:15:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE6066B00A1; Thu,  5 Mar 2026 08:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BDD16B00A2; Thu,  5 Mar 2026 08:15:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 887C26B009F
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 08:15:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 30648C03FE
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:15:12 +0000 (UTC)
X-FDA: 84512055264.01.9EC2C60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3DCC540012
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:15:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RM70g9ya;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772716510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AwhW6f1IWZxLf2mQT1DI8SkqOVm8lYtHZX5PjS1sQBU=;
	b=vzgtWPgricx4szUHb/tHvvW29nN+713jACM4Ug4rWmnJaYuPtfJI5IZfqmi9yiARAGAwx3
	l5mp5XVm9mM7Bybka52x+t2WP3yz/Lmmo3KRlFL656DGZnaGJIARIf9wH7kOc12n2fh5Hk
	0UOQLc2qjcL5Z+8AyXHygNNweKoqqmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772716510; a=rsa-sha256;
	cv=none;
	b=ygJ9VGYpDWChniQ+TYqPvS3arPqtmV5ZmYFbkErgiolovzgWKleFoT/rSBDmT9gaAoqjzz
	YWkOU5P3gJsBXJXr8geiPYG+u53tiB8JK17ZqDQRxav4usXLPxmz8X6tX+D8k8xEUR0Xvb
	MTlZ6jarzYU/TEqHZdXPwU174G1F/SA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RM70g9ya;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EA29C405FD;
	Thu,  5 Mar 2026 13:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20263C116C6;
	Thu,  5 Mar 2026 13:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772716508;
	bh=2Lb8YlWfVoPWN0myJ+Ltfw/Xuq1Wtsb4qDK10kcn2ZM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RM70g9yab8l04hR2QPEbw3QQd1+2N1613ElZK/IZlBjmKFdoFNYYl1IGU576KCgGK
	 CjLEXF10R5+Tmh5cuvs3OyhPkq7+yh8F1/p3xjfgSz2B1bJdoPo1jQ419l6JACQgqT
	 hZHuIXl7hBMuC18YgxHQfVCZpYYgvcLD8350cLbJJ1XB5vNYcvikVOyrsv6d9BOfFn
	 pCKFFnym1MPfOQrnkM5RzT//Rm0xdrK1vkZcZgYPpkxbB52ioDYab4DxC32MWUns2/
	 lERzLNjmKibJqyUtZh2qH31JJLlHFChLGbDPEwLsRrH9+oUS4dGtVL9xiJem+BNZXN
	 R7kINuydUumiQ==
Message-ID: <0ca11dfe-b54a-4f40-a68d-baa917909873@kernel.org>
Date: Thu, 5 Mar 2026 14:14:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: thp: reduce unnecessary start_stop_khugepaged()
 calls
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kernel-team@meta.com
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
 <aagSrIwiFM7GaL1m@thinkstation>
 <e46c8bd6-9f6b-4985-bec5-fef6c8f33dfe@lucifer.local>
 <ae48168f-c88c-4f74-8cf6-ab90f6c97c68@kernel.org>
 <cac26373-2323-4897-992b-5cc56e2b9481@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <cac26373-2323-4897-992b-5cc56e2b9481@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3DCC540012
X-Stat-Signature: 8bfr9bu6h9wqb5zfugrrt4qauy8x5ykb
X-Rspam-User: 
X-HE-Tag: 1772716510-83436
X-HE-Meta: U2FsdGVkX185vlSRKt7XJu1lU2PXr1edmLBstlrd3lwNfOUCWzUTzdoRowxit9pQ2d2GqtvK9FHtai8jQaqgBVB70GESF3ig7RGcSIWDKyyuxLCtIbyj5q4UCB81mtVKTJn8hbdrJXfBuPEfa4taGiBVBcq/BQ9X86Yb3n+5LPoHBKhTwBCY+JEWRtr1QnlkD0dU5HDukNualN3pcL8TXGnDYbpQfkUJou3z7nLo4v4m/I0EkRF1NfbybngXiPX/P3FB4SOSYSU9qDpsQZmpzY6r8hilpDX8n0GXGU8ZJ6ag+HnBwGgMUXd9bcyTLlyuHBpJ1qS6NKzqgTPorqAIjYtCV0Q9sZk+ueVn15+sMayULNNHx++g4fTBCXoN6MSS3O8VLhI7IYxi77nOmCfNStpZ1LnVIBkJsq6tk6ZvuS28lkk14KeDlVDndVrjz4OH2mqQb/3YZqfT/weIvDCG8V21tH0+fMzSORWFcL/Iv6Cwuu+gN5VhxnfwonxwuQEzqUdTHsPf7g0XnP5ZXgeLqoS8qPjk4336DGHUBYhz+o3MeynWiAU2xeRoDs4W6nx4KVaiTKt/7epw+E+SUIoEx374XlssE36thUQgCekJ6x/9XPWHFv0BJjqp+L90Lk6qRBkeMH0DPo5Cre5d58lQX4AYJtjNjReCsnUCv66httUDDBRaNpTRR+EnT2+IaqU93nYj6At3R754FTbdg85f5s8Vl7DH/ovspqz+N0HARKyqRTSWOgfd1ld6l7p09H+lwq8SVhtHR9uBUfKjZZbrStx5SH3pZU30NvzwSgnGPAiAdBzjGmPlUK7hyA2cnJeBchU+QD0DrYuYqe0jas1wD7SfKkNfpZggV7vLzaTFswZie0/Kl3lNIBgGkeeHwjdLGsKW+IrrC0H0kFCPHNchJoUzll0CyOMmmA3EWzTsmOn7HlCF5DXRt70adfjNJQDdH8STYlIl/M+sdXKibrJ
 as4k81Kw
 oTtsSFzTn4I9+A9YDvSIPfosGCqebRspoNhh7KUtR2NSpH1n0KbkAhEPLRW6+xUS592pPbSBJCHUDDHth/QtLyiPj4fPUHsjgPxkFaL5woYq0iGZ0yOg4tF7+HuWEwr/U3h4A+eVCfpyZHRUNQJRMp6+5Nzuz1wlnaKy2nW2aKVVraTrQiZk7TfczjQPXTuMSuYw9UAp8BDLB4W0OjWN1J+pga8JoxbtB5ChLSFLg2Mx4nMUwtd5qRuDfjAoN7sByc5psMT0D3L1dtdtwYKLEV+JGKymdy3Upmm0KwipUege1kpW56aZDcmDodw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 13:45, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 05, 2026 at 01:41:33PM +0100, David Hildenbrand (Arm) wrote:
>>
>>>
>>> This is horrible, better to break out the latter expression as a small static
>>> function like:
>>>
>>> static bool is_khugepaged_thread_running(void)
>>> {
>>> 	if (khugepaged_thread)
>>> 		return true;
>>> 	return false;
>>
>> return khugepaged_thread;
>>
>> should do the trick, given taht the return type of the function is a bool :)
> 
> Yeah I know :)
> 
> I mean it's subjective, but this form makes it clear that what you're returning
> is _not_ a boolean.
> 
> I was a bit 'meh' when I first saw this pattern, but it's grown on me, sort of a
> 'make it so simple you can't get confused' kinda thing.

I consider

if (x)
	return true;
return false;

rather ... questionable :)

-- 
Cheers,

David

