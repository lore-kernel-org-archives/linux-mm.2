Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 320AFC83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 08:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2D98E0002; Wed, 23 Jul 2025 04:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 993738E0001; Wed, 23 Jul 2025 04:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882708E0002; Wed, 23 Jul 2025 04:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 764E08E0001
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 04:41:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30CDC112F2B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:41:37 +0000 (UTC)
X-FDA: 83694885834.28.14C3BFD
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf07.hostedemail.com (Postfix) with ESMTP id F200C40008
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 08:41:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=BR7ahQgq;
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf07.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753260095; a=rsa-sha256;
	cv=none;
	b=r51RCJQgvcX5U4j7WB18xEVr4fnrJltwzv/pKyuACV+MGibSRIfgCSzyiiBCndoiMORR8v
	YaxVrF21ONOG0O9FiW99fK8qoBRZDY62rCI0SdAbvlhX0+kkO+n7Zdo5Ko1eU2e5dRgotV
	h59F3qIqidOJfkjweLmNxpPNZRcDtxs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=BR7ahQgq;
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf07.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753260095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7eCUOWke4mAzQtpD5jhgOmBpiDVIy3hPcFQXQYgQgc=;
	b=Wm6xWEfx8GVVJJqdZPfEIs6+0jqWBmc1Dna8DQgUvbTOLRbCcWzoRIjSfKx4Afu8UbbDFc
	12VAd74mpks0ayS5wLfM8ThaN9D/800wqNZkZQEX+MyNAGvMCWNbXSmZNLMtWKKuDhJ3uN
	u2nXKvQBq/AlJFjGZyX+Lxa+EpUIE1k=
DKIM-Signature: a=rsa-sha256; t=1753260092; x=1753864892; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=Y7eCUOWke4mAzQtpD5jhgOmBpiDVIy3hPcFQXQYgQgc=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=BR7ahQgqu5jB0ylvabvi4zREjcqEqtUDjpslN0Pv3tRrLJNBX9OpvjPjghki2fSxvbakWXxu85HlBksvmrIOdNzs/RzqY+RupdFNNdrziFO3ZwB2r/1Q/GDckKS6rHWATPjKqAfoeV8hpIA5HcL9PMoDrJQly8IOBPZW6o0AQOM=
Received: from [10.0.5.28] ([95.168.203.222])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202507231041312250;
        Wed, 23 Jul 2025 10:41:31 +0200
Message-ID: <01ab2653-dbff-4a3f-ac91-f3f21a06dd2e@cdn77.com>
Date: Wed, 23 Jul 2025 10:41:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Kuniyuki Iwashima <kuniyu@google.com>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
 netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 Matyas Hurtik <matyas.hurtik@cdn77.com>
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
 <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CTCH: RefID="str=0001.0A00211C.6880A03E.0039,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F200C40008
X-Stat-Signature: nerdxz44agmgfn14mge8ttuf7y9xehfs
X-HE-Tag: 1753260094-80407
X-HE-Meta: U2FsdGVkX1+vfQa8cRABpGtwLtiI3+fGRqdrxjbJZlYJ0lM4//gGPWm+nbWEikJdKnE/vRCZbOWZ8vG7F/8KJ346JlgYNGJQLk1bALYzn9jBSfIUrE9RHz7d4pr3jNNKXzjSw3ismwp7OS+BbLCWBWMfcQEngHkGv2O7rjHcyzBnHmCmwg0fNgg8Ke4IKRCQdGzk55RpD/nVIz0I/esUX+CJBCcB/NvxArCjMtlBIuyOrbyw8DXdLEBwQGwc33qGOQ4apG1oftChIyCReCs2GsHDA7jj2aqQQkp/ALo2Y5vkOb5Xo8x+JjdheAlxhKj1PdRxBneMCltqwK/8KAdIiA8kHEl+4JtH4sFcZWesGSvhq6Mnjow0tMrEYHJ5mm1wimTIxcB4PLceCMh+IT8H/wnXD+dJuafqvM1iAmkgMmXlcdgdMCy6Qa1n3cBcP/SfD0UhIg6LHGILx7Z0TyX96rNmi5zmPTTPfnwaTZlDNkGm+FY1LOXyXdrj2dXsNXdoilBq8VL9X8M0ih/ckp91GMhUyY7yprH2egD48GdNsE1815EOzw+BVa18BuX3hb3eCzapWLWOEA4bk1iSm0tg89jelZNw0pNQgpsvghiKFUMxW+fcKsE+M0eTobblUIElbp895lxyoBeaJKXyVx1olKSxDMMEvdxHJtXFgdFv8Sss9VPhBK8guLfNHISqx1O7RZedNSyetA6u9PwltSWW5z/vEmUpj0sIzPbsByzQExGNfZ7TUoQyyWN3Ho8fOSEzZ9jiZKxQBhwdViCz6u2QyYA8YslOjH5/cMS6jk4QYcYG3VX941pUlSnY8Ij71PXh3J/XYAkY64uehZdrPN45eufiUPyHkteCUC/lueCNdiwrgoaAztHUevy6kqDpZpFQET0SrcvS3LOUeujeIJnwSXQ19nLh81jIBSPR+tDyIQMeOdsBlHWlimz6dwlVC+DkoBTAKzQQtYw0AhRpk4g
 2UpfA3KT
 Wipwy9EexZ9442/AR5I1w9QSIZnTGLNTnZYospTv8l9DnxmEbhdCYMtB/n6TYjUu+vY5Pl9uWjnbV6EY3r/tMxCRzV+E6/c3W7G99+fayXqovVPAztEC1v4IXUvFeH9zSpuSbkgQaMAANveqsxUeVzKuMcRB1sB3/WRbac1GGjjhDMywURhWgU8/WuSWShf3j2PZ8ap7/ONR0MB6ApuOXjpq7u5jacfw2nsr3nGwp5eLXuHu6DsJeHjzju71zZQogZYkqyrJJ3tFSO4Cyefuwr+flPsKMWtSSiIRR5K1UXEEET7Ujbgyxlqg3sQOPxNljrqPsNFtpNj6rlsdWIK2EqDxt4tHuktMaU2pe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/25 9:05 PM, Shakeel Butt wrote:
> On Tue, Jul 22, 2025 at 11:27:39AM -0700, Kuniyuki Iwashima wrote:
>> On Tue, Jul 22, 2025 at 10:50 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>>
>>> On Tue, Jul 22, 2025 at 10:57:31AM +0200, Michal Koutný wrote:
>>>> Hello Daniel.
>>>>
>>>> On Tue, Jul 22, 2025 at 09:11:46AM +0200, Daniel Sedlak <daniel.sedlak@cdn77.com> wrote:
>>>>>    /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
>>>>>
>>>>> The output value is an integer matching the internal semantics of the
>>>>> struct mem_cgroup for socket_pressure. It is a periodic re-arm clock,
>>>>> representing the end of the said socket memory pressure, and once the
>>>>> clock is re-armed it is set to jiffies + HZ.
>>>>
>>>> I don't find it ideal to expose this value in its raw form that is
>>>> rather an implementation detail.
>>>>
>>>> IIUC, the information is possibly valid only during one jiffy interval.
>>>> How would be the userspace consuming this?
>>>>
>>>> I'd consider exposing this as a cummulative counter in memory.stat for
>>>> simplicity (or possibly cummulative time spent in the pressure
>>>> condition).
>>>>
>>>> Shakeel, how useful is this vmpressure per-cgroup tracking nowadays? I
>>>> thought it's kind of legacy.
>>>
>>>
>>> Yes vmpressure is legacy and we should not expose raw underlying number
>>> to the userspace. How about just 0 or 1 and use
>>> mem_cgroup_under_socket_pressure() underlying? In future if we change
>>> the underlying implementation, the output of this interface should be
>>> consistent.
>>
>> But this is available only for 1 second, and it will not be useful
>> except for live debugging ?
> 
> 1 second is the current implementation and it can be more if the memcg
> remains in memory pressure.

In our production environment, when this so-called pressure happens, it 
typically stays under pressure for a few hours straight. So, in our 
scenario, even a 1 or 0 would be helpful since it does not oscillate.



