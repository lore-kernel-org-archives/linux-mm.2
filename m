Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BAEFF01804
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 08:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23EE6B0093; Fri,  6 Mar 2026 03:04:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FBA56B0095; Fri,  6 Mar 2026 03:04:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952C06B0096; Fri,  6 Mar 2026 03:04:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 86B456B0093
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 03:04:35 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 24EFF1B7E8F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:04:35 +0000 (UTC)
X-FDA: 84514901310.04.A19153D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8979A40006
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 08:04:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrMIMd16;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772784273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bFCUZ1lmwtVWRvHzJoX1dmihqbD+RimJaNlXwIvtjxA=;
	b=HbkBAOe0GXrUcn35w+gaBdN0Kxa8khzWzr+Y7NrZYVC+Qcrre8kOu40ptjiq0jK+/ZGFyB
	0SFGlYyYoc6ucQVXmB9h0ZMGDE4DmETDanrzi1qaVJXwIwLZuc7x69dXVYwVThRwE4te8U
	j2fSL0jE+q+jVA9FiEsj32rLhjj2GHc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772784273; a=rsa-sha256;
	cv=none;
	b=ICyUJujTDh++xhvHjZH4BkJlGQnFV+ePjwQqKhvq/c7YITO/61uULG2QuJ2jM2VQPfmgr5
	VeLUo3ckrK4HUjBwDOIgzc7zNFS/k47QSWZrNk+BoaeLwWwE45oxUiFLeecVXHybjp3VKZ
	TRSxiQUtGCvMygnLMs7vFUSuW/GDy0c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrMIMd16;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F30E443A4;
	Fri,  6 Mar 2026 08:04:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF945C19422;
	Fri,  6 Mar 2026 08:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772784272;
	bh=4WYdU2QhyXqU+J/LQCVn7X+IxtDxdQ46YOVOYQ3wx4c=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=KrMIMd165ybmkiKdddDSfICK3ILtiUxMoX1pfdggCmYoIassRhyrunuu/9Kxr5eC9
	 DTQ6fAvZtRQuT4vv5S+Zzkyw2EP9M29XZn3s2jrioa4jS+sXsUMDUp4Hq+GDGr/0g7
	 riy6PbiV+94LnsJUo+dYQ2l3NUFH1lsLw/c+80XdH29p4QI+1zFFodusolI0ShyCmO
	 IapfGSeeM+76Z1rst8ec2Ru7qL7DCBMq0i53dKLO1zRelCXYak3yNPWwfAc0j/u7UH
	 pyuADR9r3H9ajmJS2+6j5dYwynnVgvJrFrv0VlhJRi6FPO3NKhxZaj/Af6gV2gnMcL
	 6gpCIZtivuf0g==
Message-ID: <dd9794d9-fa88-4020-95ad-bb8fefa4e2d1@kernel.org>
Date: Fri, 6 Mar 2026 09:04:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: add mm-related procfs files to MM sections
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes
 <ljs@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260306013453.90906-1-sj@kernel.org>
Content-Language: en-US
In-Reply-To: <20260306013453.90906-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8979A40006
X-Stat-Signature: m436ufxht9aqhee1xehtxgxkkbf71qf5
X-HE-Tag: 1772784273-675428
X-HE-Meta: U2FsdGVkX1/YIEoREBwXW0DhTr4Ww3dEiIibU2FAFpr5yb4TA2mouZZ9k1FDLeK86P6fWUNzRyrbpFL0URAQ8E1lUKlA4awu37RHRyqQUUSYx1I4adrNj4JUDtUbo/Bdtzn7Wr21IrsTq48j1rNcrG12rPjcAr/l2imYyyCP5BkeHbFTzwPwn8y+I8suSe5b4NGLGMev6RArMp9D6nqbNo9Qka26DaQ0d15Q6hyFJEPPzLar8HwL/W/N2zv6W7KTpO3Gs1O/Cts50eN2aZtq3ypeHR/0+loLQ0qvIaUBP5yCRybNv/B0LF4XbXgCs5GQBRq9v9scsX++kKQyP4XAV2QFUZJ4W9wgzQ3wy2Tj92OWGf37LTjSwS5D1HwigRhsJq1z6Ja80p7ftZoBqjI6HBjw6FRQbGNYYP/VHTZQ1omBG8hcCZDK2jPNcajcgjmPPlOKYgWSg9ts/U3R4ctMPiO7dcVOue54rRiiOGJDq1FOldHWwKFPoF/Y8pEOksb9kMAdaWqI1vA6nGxcu5S4J/+EChZWB/1/lJKOQ9hxvG8xWF2fhzbuzHpnFmoISjS+L6Myjm+FcSV6X5X6eUNnJ+PWJaGpcvW1duYjRCho4SxbjPdaueR8l5FvQusI6YAsnkczxl0D98LckUP5xx8qvxEKg0i6R3AR0joxJX7ren0XVFHKNe7sGGC95OZnRhYu51uZ/BgR4x/NjwZGukPTGTGwOlv9ZJOoAd4YVjfR18Dgzlqf/DePj68T2yTuS0w3wfQVZhJieMqJPse/7bHN8uHAEbQ+Joj3OUPpLkbFU4wOObk7kd7QxebGnBeyeRvUB42XoW5o3Y4vbOnWVPM2tI0ymRJYMBnL2gHwaxNE7pVIboXrXmmt2l6AVxFRoWmVjw3t3lWk6xHvtXKp3arTvVI3hFu400/IuxAsOXZTNKAZh6nMzZuTBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 02:34, SeongJae Park wrote:
> On Thu, 05 Mar 2026 09:26:29 +0100 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:
> 
>> Some procfs files are very much related to memory management so let's
>> have MAINTAINERS reflect that.
>> 
>> Add fs/proc/meminfo.c to MEMORY MANAGEMENT - CORE.
>> 
>> Add fs/proc/task_[no]mmu.c to MEMORY MAPPING.
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> I have a few trivial comments below.  Regardless of those,
> 
> Acked-by: SeongJae Park <sj@kernel.org>

Thanks!

>> ---
>>  MAINTAINERS | 3 +++
>>  1 file changed, 3 insertions(+)
>> 
>> diff --git a/MAINTAINERS b/MAINTAINERS
>> index 3553554019e8..39987895bcfc 100644
>> --- a/MAINTAINERS
>> +++ b/MAINTAINERS
>> @@ -16683,6 +16683,7 @@ F:	include/linux/ptdump.h
>>  F:	include/linux/vmpressure.h
>>  F:	include/linux/vmstat.h
>>  F:	include/trace/events/zone_lock.h
>> +F:	fs/proc/meminfo.c
> 
> Should we sort files alphabetically, and hence put this before 'include/...' ?

Hm I mentally sorted include/headers above all .c files :)

> I see a few other MAINTAINERS sections including 'MEMORY MANGEMENT -
> USERFAULTFD' are doing so.  I have no strong opinion, though.

The get_maintainers.pl script doesn't care about that so I don't care much
either. Unless someone does.

>>  F:	kernel/fork.c
>>  F:	mm/Kconfig
>>  F:	mm/debug.c
>> @@ -16998,6 +16999,8 @@ S:	Maintained
>>  W:	http://www.linux-mm.org
>>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
>>  F:	include/trace/events/mmap.h
>> +F:	fs/proc/task_mmu.c
>> +F:	fs/proc/task_nommu.c
> 
> Ditto.
> 
> 
> Thanks,
> SJ
> 
> [...]


