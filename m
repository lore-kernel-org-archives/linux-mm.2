Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A238CA0EFA
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 18:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71C1E6B0108; Thu, 21 Aug 2025 14:44:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F3206B0109; Thu, 21 Aug 2025 14:44:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FB46B010A; Thu, 21 Aug 2025 14:44:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4EA616B0108
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 14:44:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0B42E1A0505
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:44:14 +0000 (UTC)
X-FDA: 83801639628.19.91D58D4
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf25.hostedemail.com (Postfix) with ESMTP id AFD09A0007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 18:44:11 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=CbHGaVTf;
	spf=pass (imf25.hostedemail.com: domain of matyas.hurtik@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=matyas.hurtik@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755801852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bjBzbYOJlLNoEFfSNXFlpKexNeNZRAUPsNyoE1U3vUI=;
	b=gNaA/RsDy+Mh9G7psziGSmwuMN9cLR4nbZkIsUBGl1yPOdBOQOmffod2sE/jCCQE0OzPdM
	xAbsA2SV1TmJdkhH7vcfpvCwEDRbdq9gKO+KpIsIoEORBRAFPuoZsvV/+oqDMIFDb4Lem7
	SZzEd+0rPslbuhlA2ZAJhDgjuOxQF/Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=CbHGaVTf;
	spf=pass (imf25.hostedemail.com: domain of matyas.hurtik@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=matyas.hurtik@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755801852; a=rsa-sha256;
	cv=none;
	b=Bes15B9hZh7wgDvAToaDEEzlNxfBDC55+6/C//D55w7NzedYr74QbTi8L1YjNO/yfQCLHx
	zaJAFFS14DiumoA2XFEn/5J3gWyS5khhx2uMqhJREN9D68Afdn9sOvzWkoPRuHRHdqiDiK
	wsgPeOmTitPdHc2XLkfU/ElKFwFV6wQ=
DKIM-Signature: a=rsa-sha256; t=1755801849; x=1756406649; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=bjBzbYOJlLNoEFfSNXFlpKexNeNZRAUPsNyoE1U3vUI=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=CbHGaVTf3If/ptzjPsO+GpjYx0DXlemHfrAiFMy0U7WTbRDbxZp2J6MO/2+YuOhAKa/Y9Exp0OxEZU4i/3lovvcwdy+E+8L0FaLtBu+1VCjDfb9PtfikwJKsZiQTtpCGJQhEXl8uMauNzHdJ96PEmE8AEhKBoLwn7KF7BCAsoHw=
Received: from [192.168.0.206] ([78.44.198.142])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202508212044088574;
        Thu, 21 Aug 2025 20:44:08 +0200
Message-ID: <29defc2f-1dd4-4269-8677-34bb1ce44a55@cdn77.com>
Date: Thu, 21 Aug 2025 20:44:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Daniel Sedlak <daniel.sedlak@cdn77.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
 netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <aJeUNqwzRuc8N08y@slm.duckdns.org>
 <gqeq3trayjsylgylrl5wdcrrp7r5yorvfxc6puzuplzfvrqwjg@j4rr5vl5dnak>
 <aJzTeyRTu_sfm-9R@slm.duckdns.org>
 <e65222c1-83f9-4d23-b9af-16db7e6e8a42@cdn77.com>
 <aKYb7_xshbtFbXjb@slm.duckdns.org>
 <fa039702-3d60-4dc0-803a-b094b41fd2b9@cdn77.com>
 <kyy6mxg4g6aer2mht3xawiq56ytveg7vllg7o6f7dgivkoh52z@ccinqivomtyl>
Content-Language: en-US, cs
From: Matyas Hurtik <matyas.hurtik@cdn77.com>
In-Reply-To: <kyy6mxg4g6aer2mht3xawiq56ytveg7vllg7o6f7dgivkoh52z@ccinqivomtyl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CTCH: RefID="str=0001.0A002101.68A768F9.0008,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspamd-Queue-Id: AFD09A0007
X-Rspam-User: 
X-Stat-Signature: ckwo1qeiu4psqkm7e14c5f6jr178adpt
X-Rspamd-Server: rspam09
X-HE-Tag: 1755801851-421600
X-HE-Meta: U2FsdGVkX1+mwM8Ukg5xGsYz+syhoJsX9lvURGDoNvvIkIw77AHrsGAQfqXetihyVpU/ZJzB7LD5041o+UAjZyF0WkEXVv94G5jdfA6fuVhddKw82C1Vp12HalLut98DA8C0Nhy3NDw8Q5+diIxqz6SE34fWgBlM0LHpPnuF33jhWUu5qEh0r077GCIm9StJkqE3XpAJmzcGwj0cr5bBWmN1xxgwh2iy9MTHVLGABWmjwBlUo5Xx5N/WpbwBHUZBmkCclg8maM32hzLH8VBxUppDnjZuklXolY/I0iU16y/ttb1uvqWWqYE9sjPek1PAdt80/Jn/7tunSr6Rp+4Oq2bvOitE53H+zNOTJGyoZYjLihy9zYqM3gw3zgWjt66bJykUZepYFx1PgdCeOfc51/sdxka7F5AMgMf2cRIPFvk4yIajdpaibo+TiyKxstl71hHyQllm/9AM5E7CAZoH4qn3YPASM7p+8D42AVZKPRvsu4Z+7f13IZFnDsmgnrEVVw/NlX5i0dpgVX08kE8AtiLbnVJfm8M5K6K6PPYUCgAeZKiDUjApUu0EdZ/QvHd7bokdtowejgjV8E3aeDmdJukr/kztXsMoNfW3rMpWNt03r1kuqW86CDD0ughUk3ylS3Qhl6Q3dKQI0/38KrTl7YOMyqJIzG5QpfLh0tH59JZmws9OlU1CvAUCxRtn61kr/pUEAImtw6rhSN2fV23KTMXU1gfU3pUDhHpB4D02AcHYl5ycsB9ubHVG/iy/dbwuAtcK1mzkPVRp3TBjluPvOd8dxIC4DkRivgj0/UXv6x835K0X32l39Wsc+v/QY9tWgJN5NilQxXY8G1IRgImISG8jztiWVGDq5meQhcov5K+xogwue4gPF2+l28CuVsF1/Yw2GgdBhHHECdZcQ6u7HEPS9eOgV6vX5cDH9Wx7hZ+J//lSsywzefkRtZkzLN6ocfGHFjZPtCObDDI8ZXQ
 Xqvutgkx
 YVBS8e2c9cTHm24iL4SrKgYFKYsh+8lCbW5viz/SuHGY4+niOsvnQZ7UI/OAVcs0U/u02DswH8DBmgwi1iWODMb1qM0WQo3JyACdz0DWfF383ng3tvt9UTEDZXb6xQLaG68k3SgBtPTAIMhRD4T+OHMgTp5wEmtaKQzRpv+ZxsF38MgZTNNHXqIBFbseeGkR534Z7GAsOHERf/d8mLeIrDm20/Farx0Y1zqThz47cpsuMj2izz9IfQ5JiUuptfY30OEo0VmzUsV2VNcWkxUR+bU7s87VSppzKzCTaKoSwCXI0m3c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On 8/20/25 11:34 PM, Shakeel Butt wrote:
> On Wed, Aug 20, 2025 at 10:37:49PM +0200, Matyas Hurtik wrote:
>> Result of mem_cgroup_under_socket_pressure() depends on whether self 
>> or any ancestors have had socket_pressure set. So any duration of an 
>> ancestor being throttled would also mean the child was being 
>> throttled. By summing our and our ancestors socket_pressure_duration 
>> we should get our total time being throttled (possibly more because 
>> of overlaps). 
> This is not how memcg stats (and their semantics) work and maybe that 
> is not what you want. In the memcg stats semactics for a given memcg 
> the socket_pressure_duration metric is not the stall duration faced by 
> sockets in memcg but instead it will be stall duration caused by the 
> memcg and its descendants. If that is not what we want, we need to do 
> something different and orthogonal to memcg stats.

By memcg stats, do you mean only the contents of the memory.stat file?

Would it be semantically consistent if we were to put it into
a separate file (like memory.net.throttled) instead?

Just to summarize the proposals of different methods of hierarchical 
propagation:

1) None - keeping the reported duration local to that cgroup:

    value = self

    Would not be too out of place, since memory.events.local
    already does not accumulate hierarchically.
    To determine whether sockets in a memcg were throttled,
    we would traverse the /sys/fs/cgroup/ hierarchy from root to
    the cgroup of interest and sum those local durations.

2) Propagating the duration upwards (using rstat or simple iteration
    towards root memcg during write):

    value = self + sum of children

    Most semantically consistent with other exposed stat files.
    Could be added as an entry into memory.stat.
    Since the pressure gets applied from ancestors to children
    (see mem_cgroup_under_socket_pressure()), determining the duration of
    throttling for sockets in some cgroup would be hardest in this variant.

    It would involve iterating from the root to the examined cgroup and
    at each node subtracting the values of its children from that nodes 
value,
    then the sum of that would correspond to the total duration throttled.

3) Propagating the duration downwards (write only locally,
    read traversing hierarchy upwards):

    value = self + sum of ancestors

    Mirrors the logic used in mem_cgroup_under_socket_pressure(),
    increase in the reported value for a memcg would coincide with more
    throttling being done to the sockets of that memcg.

I think that variant 3 would be the most useful for diagnosing
when this socket throttling happens in a certain memcg.

I'm not sure if I understand the use case of variant 2.

Thanks,
Matyas


