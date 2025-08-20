Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A59CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 20:37:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 867446B0103; Wed, 20 Aug 2025 16:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819056B0104; Wed, 20 Aug 2025 16:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E246B0105; Wed, 20 Aug 2025 16:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DF806B0103
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:37:58 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D43091157B5
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:37:57 +0000 (UTC)
X-FDA: 83798297394.22.9412989
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9A3F78000F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 20:37:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=3mmZCMJ4;
	spf=pass (imf02.hostedemail.com: domain of matyas.hurtik@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=matyas.hurtik@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755722276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVaPb/FC4PHKTD/XuKegsQ+CXxMYcycndmhjeELweqg=;
	b=B6q9VcEMONsR1/f+c9vSZTIBizOA3JMXH8XTVg6BNtIF0CYI9jtsOELJZFaHU3hazeANtJ
	qbldLBdZmTJy3+McK7xqbBb+lIOl3+jbj68UkE2kle35brVu26A7rciACp9Au9MSYpEAd7
	2loQ/0QaXXZ/3zl4/LQupjJERE3fxZ8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=3mmZCMJ4;
	spf=pass (imf02.hostedemail.com: domain of matyas.hurtik@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=matyas.hurtik@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755722276; a=rsa-sha256;
	cv=none;
	b=c5/WGXDm/5AF2qDV9pqEhev+UNaDDUBAC/YPw5aDcO8YOlgu7w+8LX/envZuy18rOJlZZu
	cR6xYdoa9WpIhXwgwQugki1Q2WhQijOcTSLZreVhtqvhkAtwnuAbfIKLQohHvr9/bk6FtT
	fSPPNPN5ZP78VrlOjqemi6ANfUSDINg=
DKIM-Signature: a=rsa-sha256; t=1755722273; x=1756327073; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=rVaPb/FC4PHKTD/XuKegsQ+CXxMYcycndmhjeELweqg=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=3mmZCMJ4umanZdA6PxqH/ZZlzjZl6Hr2mtn5c6R7MuYhwg/XAG2QoM7qHXQFRDPtBdrOUvXSjXK7yaBA2gWzRNnJUdSzHEs1dvIDIqVNxS1oZ2pVwNRF6geOPaJRDQ/tiek2GIWsc2ccpfjIc1PclkXH/C0vqyedMpAjBmjUzSM=
Received: from [192.168.0.206] ([78.44.198.142])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202508202237494479;
        Wed, 20 Aug 2025 22:37:49 +0200
Message-ID: <fa039702-3d60-4dc0-803a-b094b41fd2b9@cdn77.com>
Date: Wed, 20 Aug 2025 22:37:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
To: Tejun Heo <tj@kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Daniel Sedlak <daniel.sedlak@cdn77.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 linux-mm@kvack.org, netdev@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <aJeUNqwzRuc8N08y@slm.duckdns.org>
 <gqeq3trayjsylgylrl5wdcrrp7r5yorvfxc6puzuplzfvrqwjg@j4rr5vl5dnak>
 <aJzTeyRTu_sfm-9R@slm.duckdns.org>
 <e65222c1-83f9-4d23-b9af-16db7e6e8a42@cdn77.com>
 <aKYb7_xshbtFbXjb@slm.duckdns.org>
Content-Language: en-US, cs
From: Matyas Hurtik <matyas.hurtik@cdn77.com>
In-Reply-To: <aKYb7_xshbtFbXjb@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CTCH: RefID="str=0001.0A002118.68A631CC.007B,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspamd-Queue-Id: 9A3F78000F
X-Rspam-User: 
X-Stat-Signature: ypix17kcpbzg3xrigb6hnr8wxy9a644r
X-Rspamd-Server: rspam09
X-HE-Tag: 1755722275-785053
X-HE-Meta: U2FsdGVkX1/1LSQtlJijIwbq29MirmemjTSWq1X4WWYLU4sKszqtofOdC5xfeMZQUqDL7Yj33iU3jhNAgg5B9xNyQm7xvScKgufto2OyXJDnfSDwI3QYZdR8ajHY82yNGE+N/tzDgXH4EnS76A1t/gZrkM9SYuTWRqejlyC34aeWHdzVUwrOTo6nhi7cCzqV9tH3GISaWNFS2ujQxo6kZvLTGDws1GW1s+i9YZ6I39sUDFHDwqkWW5rp0RHQ5iJj4d9N4nJhtUwz7tPgYvCeb3btwliP5sOW4KAnF4bdqpJGyJchCCqX1wGEd9ljyGWu/NyqbSjRA1kOLMnIkLKBV7FGVDwga8K1y0u+fWw9NB4NTDvNbAFIuvpsPakIpRvJTOqDVoFVRg8yk0r9FC6rS+md9cDWk8itKXNTJrURrXCOdLXe0t2iuZTcpOeJb+y0nq3HQjHtJaPOeKy6sZAOU9SDc0eDwBM3A33veMri83DYdE3buZ5Un/FsvS0Vzep13Gyu4cnyNp/wJzsDp4VnRxbjswUmZ/3VudIzqFpm9gFsX8K8SJ8M3j3kE7RmAXBN3uRzYNFux+ewwsa1EETMjARr7jNqI1l3Zd3Ics4puV6b0dkEhkbG2drf1W35BGd4Pey4wSCBp22fiQAQo052JPR+abzAuqrEJZXq65LUlbni4vTGd/FVeT2hRoGSnV4NOi1khNaQguh/2dSrdlMtkH+R7RS+d2Z/20V0ZzjUaw3r3BUmch/BdO58RO2ceyCDhqeQkgMnqaotcIKXWbMTMAvT4nc1T/kVwj8Pvcm/ETG2TP0zM9CU7flhIVCGVUcsfp0VecdhxLTno0HxMr2eQ57YxyPrPgbAkuFS4zrR2hHWqLDgsJXVB3EuMQYAMUCegRF+kvlmmPiI0q45F3f7+yTNGhabs64mU02skUoBjX2KeDwOXL40PFqu5aQlsjkGW0WlbA3KFX41+DER6Ul
 PfUpwe3x
 obCFlawRVewj44N5/SIP+IaPifi3Jap2Au3zHK5nBQ2KrAPwUAtbWpM6hfD9R8tvWQr7WhMLzGwgQCU6EmyYHlDpanhFYm8Ii0ZsdQRoIGWE6q9OeYqakTLIl9AidTi7oURkBTIoaf6HKsEQjJrEkQx9sVt4YLsk6X+Z52YLv0dkkGQ9T2ZOas3SZpeMfQk/lWPn5P/MWI9yS0xxk9FzVxVamNq+TzRcgGYmXwRzFOH+lJok=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On 8/20/25 9:03 PM, Tejun Heo wrote:
> On Wed, Aug 20, 2025 at 06:51:07PM +0200, Matyas Hurtik wrote:
>> And the read side:   total_duration = 0;   for (; 
>> !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))     
>> total_duration += atomic_long_read(&memcg->socket_pressure_duration); 
>> Would that work? 
> This doesn't make sense to me. Why would a child report the numbers 
> from its ancestors?

Result of mem_cgroup_under_socket_pressure() depends on
whether self or any ancestors have had socket_pressure set.

So any duration of an ancestor being throttled would also
mean the child was being throttled.

By summing our and our ancestors socket_pressure_duration
we should get our total time being throttled
(possibly more because of overlaps).

Thanks,
Matyas

