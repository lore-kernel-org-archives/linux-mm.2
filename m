Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64A3FC531D0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 01:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E39E6B008A; Mon, 27 Jul 2026 21:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 094DC6B008C; Mon, 27 Jul 2026 21:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEB8E6B0093; Mon, 27 Jul 2026 21:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C620E6B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:03:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43B7814028C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:03:23 +0000 (UTC)
X-FDA: 85036387086.09.38CF55B
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F6D9C000A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:03:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NY0BAgM8;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785200601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wskNm12QGMqSlQDsZWZfrxXV4LbUJu7o+wO+yhTqD8o=;
	b=qWpo76fK3CglXLHhyNH5vKmIZrbK2P7p/QouOz8wYYSqgSu57T1yZ52zLyHQRtd99K90BW
	tJjAnGsWsYo2HefUCuqMz+pKvmOz1WdaOUxQE0Ax5rL6Tte99NyVuiTp5pZEHLG/E5DkHU
	SFGr9hkeEx+qUS+oH+BRD/lV22nx6GQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NY0BAgM8;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785200601;
	b=uuf+ywTm5YazNo4PbkbPQg4ubm6hcm4GyChRUwz8T93gbrDStjpf05DhjpL5f+tH2RhzjP
	i3vLZ+VxpoYchjGNJ1sF277jIgLaxpE/3aSIXxLCI35CNbBxi8Wz6pNaVyYLbRDkOic0n7
	6c9eHwQFPT73SHnNx2mLQSCs68lteVA=
Message-ID: <2fd4c2f8-3166-4432-9192-17bdb2627138@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785200596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wskNm12QGMqSlQDsZWZfrxXV4LbUJu7o+wO+yhTqD8o=;
	b=NY0BAgM8ZYRyHEtVSJnSxYsA8oND9tMbRYWjMGqQgKKbBhOc47onOqDXLYqHhavVdTRBPJ
	gPrmHk7FdAfxf7/+tTdUxGZoQSQ5YGGdevEyDulT5HwCQlktNJaX6tD9rlr9J2G27mNZfR
	rP8dquj0rs/LejZ6vxumLi9h5kBPGHs=
Date: Tue, 28 Jul 2026 09:02:58 +0800
MIME-Version: 1.0
Subject: Re: [PATCH -v4 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Barry Song <baohua@kernel.org>, Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Zhongkun He <hezhongkun.hzk@bytedance.com>,
 Muchun Song <muchun.song@linux.dev>, Davidlohr Bueso <dave@stgolabs.net>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260724033435.2573323-1-ridong.chen@linux.dev>
 <20260724033435.2573323-2-ridong.chen@linux.dev> <amcUqfpjE9lnXkn_@tiehlicka>
 <CAGsJ_4znMXrSYEjWOP0jA11=paJWmWu9fOPAfZD6iP11viys0g@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4znMXrSYEjWOP0jA11=paJWmWu9fOPAfZD6iP11viys0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 7F6D9C000A
X-Rspamd-Server: rspam01
X-Stat-Signature: x1ehxss8ffntaqszk5crubw49uaamj5w
X-HE-Tag: 1785200599-969983
X-HE-Meta: U2FsdGVkX1+l1iTKwkBIuTM4WuzZERI8yz2OWLFpECA8CHw4Z97Y9ojun1gq2N2kklWZM0Gv/zqBnGEaOo/zwAZ/nFP7Pd5oPMWOVxgE/lOZOEnNxsRdPXSvMlE6/PZRfPxbrEk8AwQq5Y99uwYbNOgjRKaoApSPervlCnqqGXzdZ+PZabbImLSUvrH9ih05dURAe/qAl7AOZCkmFtO7dMHs8puGigiAlUVMAr8MRq9ZyOSLefQoWqqXrbPmro0r+G+o3OQLZ0ORPp4YFNPdLNfnPfuBh0tbjTqIIXeWesvfFufTJq9KW7zGpd5eno5V3gawxwSj4A3UxNFoBhp0h3SAag1LI0U+DiYLKMzP+MF0yN9VW+ib+2EI7mtAdRYEyvZwwzFQp4WJCMxYUdqcGPH4Sn9R4Zr6O4e8Xr47ooDbjDK+prsTTIuSVS4K62+Vjsz55TshyUK74t38f0j11Flf7Vo3Ti0boU2j+Azn2S4ksQfRfRFzOA1rihsTLHCal/iztnmeQgvvIkDqErqr4vdPUp5Igg5BVRiRIrONVUTVWE7hdklXo5TzBlJnJ5LrCOuYB1sENl+TrdGLPfQbO23vTx9vWkNr0FyovXrFzxwW3vO0AEQw7kpCYYWQ3WEhIHpCmjbDKUQnSdeRaDDfVJ0xWcJLdr1dUoG1pfcEAKxSo4ptUVgaZX/GdV3ihE8zMvnSMt4B2TpZyTYdSgi9EaaxUE89Gye3gzG0Q8ra+Ai8jbkSCj+xAxIoqn7GBfQB8p9FFG9HRwgS6hbqBuaaApbywEZXhrisZum34mwXE7FdXJlXuVYlhiNtfRszxJIs6hK9XA0TEcDqHMBcLF58agccHZ8rhpiibTo/ttl/sxx/5m4dSB4o5p57+0nBJZjT+aIIurZXa2Rm7KWsxhr7Y8ckl0GNRHBKnZG0kJlXD/rTHMzLJQTGd5ZiRxZ/Xf6LJAAuzYGPZ1/sY+yEuKT
 0mXYLE0o
 6JZPIvHsVRHcpKUTXEmkU2Yq3Ns59BTbs+l27NCkpVbV5/e2cnIwdQ2MCtTDzioKGVBm2uhtXucqktg+Py8eedv9Z4hzQVbyIF2nOYGrHZy5TC+JseRjVIOzhFzihUxd27b22wB6ndQeO2fa/xyvZNltMRQktueBQmlLNz5HnJIjqw3WEYcDoMU+Z/AzZm2ObQOHVR9M6TgyQf1eqagmWb0fSQVNrYqA4ffSyi9nTMqKZyIL7YkbX0UnL5NXFer9StcYYWSOD5rhSbsYW2vTKcAoXKUTRDBx3oroZMRVR8A3WPPna35oC53NJPbhVDegkUcc5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/27/2026 6:56 PM, Barry Song wrote:
> On Mon, Jul 27, 2026 at 4:19 PM Michal Hocko <mhocko@suse.com> wrote:
>>
>> On Fri 24-07-26 11:34:32, Ridong wrote:
>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>
>>> As Qi mentioned [1], when swappiness=max (SWAPPINESS_ANON_ONLY) is set,
>>> the reclaim logic is expected to reclaim anonymous pages exclusively.
>>> However, due to the current ordering of checks in get_scan_count(),
>>> file pages may still be evicted if can_reclaim_anon_pages() returns
>>> false, which contradicts the semantics of SWAPPINESS_ANON_ONLY.
>>
>> But if can_reclaim_anon_pages tells us that anonymous pages are not
>> reclaimable then it makes no sense to try that, no? What do you expect
>> to see? An OOM killer?
> 
> This is proactive reclaim rather than direct reclaim, and
> SWAPPINESS_ANON_ONLY is only supported for proactive reclaim. It
> therefore cannot invoke the OOM killer.
> 
> If I understand correctly, this is exactly the issue this patch is
> trying to address. Instead of falling back to reclaiming file folios,
> it returns "bash: echo: write error: Resource temporarily unavailable".
> 
>   After (file cache is left intact):
>      # cat memory.stat
>      anon 200704
>      file 67178496
>      pgscan_proactive 0
>      # echo "64M swappiness=max" > memory.reclaim
>      -bash: echo: write error: Resource temporarily unavailable
>      # cat memory.stat
>      anon 208896
>      file 67178496             <- page cache untouched
>      pgsteal_proactive 0
>      pgscan_proactive 0
> 
> Ridong, please correct me if I am wrong.

Thank you, Barry, it's correct.

-- 
Best regards
Ridong


