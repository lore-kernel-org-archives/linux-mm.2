Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5941CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 18:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5068E000A; Wed, 22 Oct 2025 14:10:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CCC8E0002; Wed, 22 Oct 2025 14:10:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB898E000A; Wed, 22 Oct 2025 14:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E2A908E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 14:10:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8220013BEDC
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:10:32 +0000 (UTC)
X-FDA: 84026540304.09.78B8719
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id B53D3140005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 18:10:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ewT9VmjD;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761156631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2oguebMI32HO2qu+qTFZ3a4OfXPITAp8SRQtXmR8DU0=;
	b=0ePXp7oMb3mtpu8Peh5Lbce18QxKsJZFNpqkvPFutWv2tgGHlVcWQ1eDsp6XmZvkFoCQni
	bHFMP6+VljGNIsyWlkQmKzW7Szi0V55exmOH9vox7YsuySvnjRaymlng1kyVhQZRv8CXsL
	Y0kUVRxAV2y8VZf4Xd15d+Zcpoqi5tc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ewT9VmjD;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761156631; a=rsa-sha256;
	cv=none;
	b=dcogvxQlJuKtp7rqVX74WLH90a6TF7x9mv1BPv6vmaAlslFMwsntiUhIl8zG56R/jqoemM
	NHzEutJ2KlG7f16yWyG3qbwJH/zVc8L+9mpkNBWjtEZ9LyAEaP9BVl+jMzG6T8Ac86H0/u
	s3jJNRQAePIAvqmsLUIKQnwMrNnFwrA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761156628;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2oguebMI32HO2qu+qTFZ3a4OfXPITAp8SRQtXmR8DU0=;
	b=ewT9VmjD7fTQPe1Npsb/bC39b2Tzxw6BCjJHe1M8WUB/Q2xBU9/d7L11V6Vb5wHFwQkqr8
	oSNvVeGhpWgBJ7R7fiHC0RpiHou+2eQte79hbL/RqkaC5+9NPXswBassBgdxbSf1mH/NRJ
	b772Rg8EO0Wab8lYZl/nE8lHfRnMQoI=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Johannes Weiner <hannes@cmpxchg.org>,
  Michal Hocko <mhocko@kernel.org>,  Muchun Song <muchun.song@linux.dev>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: manually uninline __memcg_memory_event
In-Reply-To: <3h26sozqgksxn4fvh7i6qjhtbnrtzit6eluyieyhsvycs3fbs5@ddblsq2crkit>
	(Shakeel Butt's message of "Tue, 21 Oct 2025 18:28:02 -0700")
References: <20251021234425.1885471-1-shakeel.butt@linux.dev>
	<20251022005801.120250-1-sj@kernel.org>
	<3h26sozqgksxn4fvh7i6qjhtbnrtzit6eluyieyhsvycs3fbs5@ddblsq2crkit>
Date: Wed, 22 Oct 2025 11:10:22 -0700
Message-ID: <87v7k67qpd.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ga4afe5agu691xke49pbrcs559dnb45g
X-Rspamd-Queue-Id: B53D3140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761156630-627228
X-HE-Meta: U2FsdGVkX19Dc0kb54nivKnDkZADMOTDj5uvfWezqI34uqBtSDrrr2zzmHINBe7ca7lOZ8fvU6e95Go2OeBZIdp1x20AooNivJOMVWa7ck3B1A2qTB8mVeRm16x/89HEEjE4wq6U0rEt18Xv4ZIJpgUqYWnvO3vLLxApnmhtWTu8y6Kb6iMykdXGQy8SJ/7sH0bsNr+Y/n3fVxN54WcoEwWAJRBIjnNk0UjBFHuaGWh9Y+09s7gSLmz+3bjh3/NmR2K0qDhr9z4pLIeL6XU2Xhdc8r2OjD+UTx4I+2QPtBkVexmWA6SGSc7Lj7ou0MnaXiE23bzGi49bgiUyrndrcO7Q2IdyYc6jnEdDnD4lAgtFOYYkj95qmFUYV2lO69Nq6EOOoTLYBbE/LxWR4DG+c9Z8gq8FUTdRdeI83HXMxyoytE4pOW1Fbdx1H9UJcV6N96+Aw5Pyueedd73nq88RJTMHW8CioL82SCA9uajlydUgZFVhQTF/nHhS4DqHx4Hgzjhfc/o4MhfLzqQXubUHqRvId0LpI/6lNL91D9m62TRPy3XpR/00xi8RD3hJql6mWF+drZB2VgKhrz2HQ5VlzmCde+XBKnNQHNMZeOVlIlVq8PQNg+nimNgWMGWYeo+PfUpbnH10FionjlyU9ZeUwbmPfoj0H1BXpRklZbu36kfpdLOXrhE9w/jRcC1kR8YeFSRjIKWtBiTuV+t4poeVmmODYCttBE7A+fO7KJrgFC9Ckf10EK/osVycj6nP+X89SIaLspi9A6df1IG/27vQIwlgBGbDo4i/9OnxWYuW7v15DaOBO6nfnsJewCLMprpNA1zkwJXaPRFcn49H3WoVRI7ua5FQWTexYxPkOZHa5Bv7QFJRfYAxsDpbduaSx4Ar92bqPUVvGN26bIy4wyQmsiY5E+YOif5p2K8PTxZOKIueU2BlR3s9VabyQ7eG0vRjrTZ4XWgtE227OFbVk22
 Ur399DDB
 bHkeCVn5wnyQIwt5txY9ZW0zysP8y7yg0AXUIjbI42GLklLvJtZ99vh63910QhMginJP5s3coylMXz7GT+OpCWM3xIbZBHk5RLy3amynNBlCz0iQqjS5fBeA7hwdim5m8X0UUBOcz1bhVlqGc+bYFdU8+Eooajzcm+bPlyjaTZw3TakOEMln7R1vizRXWCXxgF8hFK/99EIVe8G4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Shakeel Butt <shakeel.butt@linux.dev> writes:

> On Tue, Oct 21, 2025 at 05:58:00PM -0700, SeongJae Park wrote:
>> On Tue, 21 Oct 2025 16:44:25 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
>> 
>> > The function __memcg_memory_event has been unnecessarily marked inline
>> > even when it is not really performance critical. It is usually called
>> > to track extreme conditions. Over the time, it has evolved to include
>> > more functionality and inlining it is causing more harm.
>> > 
>> > Before the patch:
>> > $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
>> >    text    data     bss     dec     hex filename
>> >   35645   10574    4192   50411    c4eb mm/memcontrol.o
>> >   54738    1658       0   56396    dc4c net/ipv4/tcp_input.o
>> >   34644    1065       0   35709    8b7d net/ipv4/tcp_output.o
>> > 
>> > After the patch:
>> > $ size mm/memcontrol.o net/ipv4/tcp_input.o net/ipv4/tcp_output.o
>> >    text    data     bss     dec     hex filename
>> >   35137   10446    4192   49775    c26f mm/memcontrol.o
>> >   54322    1562       0   55884    da4c net/ipv4/tcp_input.o
>> >   34492    1017       0   35509    8ab5 net/ipv4/tcp_output.o
>> > 
>> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!

