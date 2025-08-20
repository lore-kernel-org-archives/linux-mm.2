Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06778CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 16:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F1CD8E0007; Wed, 20 Aug 2025 12:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C9386B0105; Wed, 20 Aug 2025 12:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205F08E0007; Wed, 20 Aug 2025 12:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E45D6B0104
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:51:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 977F0C060D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:51:13 +0000 (UTC)
X-FDA: 83797726026.03.B09765F
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5FD4C80009
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:51:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b="fg/O2ocZ";
	spf=pass (imf02.hostedemail.com: domain of matyas.hurtik@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=matyas.hurtik@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755708672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEvEGZgaiQng64jbfPgPU723vPCPqVeUVZPTA1jHr5w=;
	b=1dPYU3FFpSCd+8xqCE8v4mozj/lOCbJ4Bkx0YkfvV6y03n5kF9ulecePrN7yuqwHyj9M++
	0/ZfxAErHM5PrHaFR8jyvp7juCxn3TzyrzdhbZyeuIgFFXBvs59gosryCSlP9DEQb3IKfA
	7aN4+mjJGglsG9kvCQ/yNKCn9T3hcUc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b="fg/O2ocZ";
	spf=pass (imf02.hostedemail.com: domain of matyas.hurtik@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=matyas.hurtik@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755708672; a=rsa-sha256;
	cv=none;
	b=lg1eQXLCYDdDj4IvMI9zrBbN1guSY3DVyn3XkhC4VAtqGCRWAVHwk/FmA3SbII5Pxd1nzA
	45nb4rElOURN/ygTaWRYs9GsWTOihcolFNfevXkI8mehvWGvSzjme6MOtQLNSie/WIYmhx
	fD0IekQK/sO+hYJq0d8SrNDYmN+zgHw=
DKIM-Signature: a=rsa-sha256; t=1755708669; x=1756313469; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=aEvEGZgaiQng64jbfPgPU723vPCPqVeUVZPTA1jHr5w=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=fg/O2ocZjuJb1khY1d9W6L5zjRL5KJ/K0LsmwHwa0y9DFWT285xTXAWuf4fbnzx+YklJOUB6jWFwMHodGpTOQGabBHo2NK9M7roc2jjsW/1PXXCJ9O1TxiqmoCgrYggOUkxlmfT/U8FO3TdiIy/04hwdCWacLsh3U0Z7ogZkeVY=
Received: from [10.26.2.104] ([80.250.18.198])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202508201851072124;
        Wed, 20 Aug 2025 18:51:07 +0200
Message-ID: <e65222c1-83f9-4d23-b9af-16db7e6e8a42@cdn77.com>
Date: Wed, 20 Aug 2025 18:51:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
To: Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>,
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
Content-Language: en-US, cs
From: Matyas Hurtik <matyas.hurtik@cdn77.com>
In-Reply-To: <aJzTeyRTu_sfm-9R@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CTCH: RefID="str=0001.0A002116.68A5FD2E.0047,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspamd-Queue-Id: 5FD4C80009
X-Rspam-User: 
X-Stat-Signature: namtsiz5o3ojatz1rcwzum5o9zza4eti
X-Rspamd-Server: rspam09
X-HE-Tag: 1755708671-126923
X-HE-Meta: U2FsdGVkX18S1U5y3gW/v8vXLslQEbMO07Uv3Ce+lbuMALAQENyM2FwtDGvgA/PdFsB21+oZQ4VFRQe1nVkWp9VP7DIr/12+pWlgYlEkP5QsvOBmkFfdUnEH+uVeBKhpP4OsBcyTkKnPsuMaVVAdJNPUh4xeXwzvwe+VwzWYnEF+LO9m9XVUdraxOssl1GEtswrv/WtZ8aNLCG1HQGCJXEflSTVEK5WSH9mbSAYlOooKiddT4F0l5FPHyEU38owc0qoLH4WClp2D/5Ed1MV/4xNw/Ku8xS2QI+1dVfithwqhlNpQJA0fTic/0eqPP01lg2VmWKY00nlnp9LDxOYftc4fZCk7iY3TxnTcfL5wok7LAEz/oLllCj+kLFg2HGp1wD0HQRCShV/EqkiGoH+dvfk8J73g9Dqdvo5b+xJhv8Ovz/yuCQTd6ZqKpINv3v4kuCycY+awF+O3P0yx9HCBo4TCqt1f3LKuW9pgcAghC/P5k0KluFq7E/qii/Rs1tnU/MgRCxFAyZKYvWeNoLc4a6quPKcth3UR8s2T9A/j6XDyUU84yWpWshtxWXLwlJBxCo8oyj+UaKb3Jv39ZYBIAvkqdnv0HfU9eBCf76pWkW85cuCO+1eWxDKxY6bRPgji8bR4c22E8uA7s09fDYlPvbI3bPpgEqf1X6kHaZjj/SeOCKwO9pXtcNTxwAGoCLuGQ1yhBVC1RFB7o8Sts7VsaZZHfarWh0UGBaS96wN8qj7MGM4sBGvf+e4+3j8KiPt/bV2epcpqOawjUHZvOJKgYF/FEg53FVvhegCUs+8Q33P8mq++DhzxZhiy4g9Knw3yL2jEA5R+43m8worv+VJLeJpG+urXQu+olCHnFyPjODfPJH1TJw4WR5gQTCOAsvOYueNuTqAij3xs7FuIrcWYse1+xrH6bJcG0WZCEmf4mZzB4F2wvPvho/EG0Xl+eV5GY/+PxCp/qcGZTs0Ogei
 pjMhvxzh
 9hQNAAuLSSpXEEmg6cdGqbuR3+FLbmCgqanY8clV7xs4kXU5fNfacFM1o88zu066FplfT+xLO7yKw2vgB+cLF8Fd2SecthxNjUHw503/+ak2lJl3oMg55fvsdsgmJRMr25WzaF/5ev6BsqB1qL0CLXI4AVqi4QBfoCMmQY99/0mDyO9YY2nZ6YMjkmiaJ/QcnskwLsC3FYY9f/+vAJy6fweq+POfL7ipV7jGW+eCXjrQpRP0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On 8/13/25 8:03 PM, Tejun Heo wrote:
> On Wed, Aug 13, 2025 at 02:03:28PM +0200, Michal Koutný wrote:
> ...
>> One more point to clarify -- should the value include throttling from
>> ancestors or not. (I think both are fine but) this semantic should also
>> be described in the docs. I.e. current proposal is
>> 	value = sum_children + self
>> and if you're see that C's value is 0, it doesn't mean its sockets
>> weren't subject of throttling. It just means you need to check also
>> values in C ancestors. Does that work?
> I was more thinking that it would account for all throttled durations, but
> it's true that we only count locally originating events for e.g.
> memory.events::low or pids.events::max. Hmm... I'm unsure. So, for events, I
> think local sources make sense as it's tracking what limits are triggering
> where. However, I'm not sure that translates well to throttle duration which
> is closer to pressure metrics than event counters. We don't distinguish the
> sources of contention when presenting pressure metrics after all.

I think calculating the value using self and ancestors would better match
the logic in mem_cgroup_under_socket_pressure() and it would avoid the
issue Michal outlined without relying on an explanation in the docs -
checking a single value per cgroup to confirm whether sockets belonging
to that cgroup were being throttled looks more intuitive to me.

If we were to have the write side of the stat in vmpressure() look 
something like:
   new_socket_pressure = jiffies + HZ;
   old_socket_pressure = atomic_long_xchg(
     &memcg->socket_pressure, new_socket_pressure);

   duration_to_add = jiffies_to_usecs(
     min(new_socket_pressure - old_socket_pressure, HZ));
   atomic_long_add(duration_to_add, &memcg->socket_pressure_duration);

And the read side:
   total_duration = 0;
   for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg))
     total_duration += atomic_long_read(&memcg->socket_pressure_duration);
Would that work?

There would be an issue with the reported value possibly being larger
than the real duration of the throttling, due to overlapping
intervals of socket_pressure with some ancestor. Is that a problem?

Thanks,
Matyas

