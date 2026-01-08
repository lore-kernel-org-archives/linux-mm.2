Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F423FD232C2
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 22:50:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4022A6B0089; Thu,  8 Jan 2026 17:50:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0136B008A; Thu,  8 Jan 2026 17:50:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BBF66B0092; Thu,  8 Jan 2026 17:50:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 182AF6B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 17:50:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B69F6C0BA8
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:50:42 +0000 (UTC)
X-FDA: 84310292724.29.B1841A9
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id CFE1040010
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 22:50:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S8lNzgxB;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767912641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiutodSCryP8xE+zUXAHFxoi+kF4AieFcdf6dqFfuM0=;
	b=OzV215X29iOW5VHzieo4qGXWpT4nvZXXRMJPIekeZHfhO02YEmpdDBERfWrI4/1l6HgM6x
	VU2N/hpMJmyeep2L6/OaHpPkPjDVocIP2tMMKF2TALWVrU0W6oUI060XaxaZRhVpQ++PLU
	ox0mqJ03fm9CHslGgneoGlxAVnAjCmw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S8lNzgxB;
	spf=pass (imf17.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767912641; a=rsa-sha256;
	cv=none;
	b=nyGWUz1IM8gVb/GXwkUy5Uq4Wp+SadSy+12Lh5D+MvsoykQY5c+48QTOJ6h3Ht4SSDM6g8
	s3Qncq1wD8dTYyleXzgZnRdFxbWBogKoK5DP5pAMZt670aiNlYgmxobWxz8BSnYtCPdiQm
	jDOxV/cnI9NS8MpcbMD96/tBCCXECHw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767912638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GiutodSCryP8xE+zUXAHFxoi+kF4AieFcdf6dqFfuM0=;
	b=S8lNzgxBrs+O14O5zBi0n1LeqQ3o6mRMOpQFXNjmjrDuPUR8o4Lk2u2r/b5XeYJL28srVA
	Wjh00dH7rAOs2GUKLeyMUYQ2OiscoskiSuC6vnxlcBwg2GpQOyBjqpof4YlXaZutHTDQML
	uVVRZuzVbru4j/zUIx76MVtaUTssF04=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>,  jianyuew@nvidia.com,
  hannes@cmpxchg.org,  mhocko@kernel.org,  shakeel.butt@linux.dev,
  muchun.song@linux.dev,  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: optimize stat output for 11% sys time reduce
In-Reply-To: <20260108111027.172f19a9a86667e8e0142042@linux-foundation.org>
	(Andrew Morton's message of "Thu, 8 Jan 2026 11:10:27 -0800")
References: <20260108093741.212333-1-jianyuew@nvidia.com>
	<20260108111027.172f19a9a86667e8e0142042@linux-foundation.org>
Date: Thu, 08 Jan 2026 22:49:55 +0000
Message-ID: <7ia45x9bhg8c.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 7m6i86acyq53pb99fnywnmc4dsshmpwb
X-Rspamd-Queue-Id: CFE1040010
X-Rspamd-Server: rspam04
X-HE-Tag: 1767912640-444371
X-HE-Meta: U2FsdGVkX18JSs+AFOEKbf0dibweWC4virX8V4Qwu8GaCZ9LB6Wl2/tQL2ZAp0hmKWaRC6EpCEOCxr06Y67lsfvtCj2AcAlJHCJsdTteXr2mdkxcFJ7968wK8OVqbkFtXqtGyrWcXWE8KVfruTo7sF8sGuMOB+PTAP0XE0PsE/eL/JiSvF7C2KWe1Mhfh5uyEoZbGYZrtb/Vmv1UY801lDCxRmd0A1uiSwv2AX+L6DRBjuaEFa00NHOR1SMe+i8RAlN3mcaVRBiTqPhXDgjHyuDYpnrc0BJZ+uHScc+WfGHSqBCDd010U/8xqfRp5xqL48luN8Zuj/DTn/zWcjrCl8g9MKkTM2ZMvvz0oagwbeMgoXVk0tnGOPRurNKrUhe8AUrsVTSay/aw946ktjZoufDJaU/0DGV1RpCzBbyiblqWxUh7NbvR2Bxuo6EODPBc7QLOmRh3yPCEP9c9aaa5pFMM+x7Bk593I+/kVNufWSl2RGelxw9hhbmTCH6FHnZQThMwcY/Himf203g+SWdi+nwDLkXt3He4sgo3d2m+r4CH17g5gnumJEH2IEcf+CA1g3g0xgrX3mZDmfHw4FHmkrbQD/23ck4c1xqALszmEIZMrGVw+nzXgUPOWWo+nMaVI56S73boCR6Igf8z7olWaDgtXa1+9n3PRgAeYSCD3i6RQF/9j8TkOkaAKwDi7H1Wb2jBUZGoBbJ6+CNyf1qYvdbDO3mDte8tkx0rIJT+cXdKO9hGl7gASTDp+g/89Zg1IZOMRT4KuYSIyfqWQOfS7gh2H5UyYyOXcp77XgprU5b64UOzORybfDzvO2HJjN/q7b4ObII5fMlG71ffm41+oSKkuhQbQbutiaIrPmrsTRfo6TwsPXSZ+yTCgbw7qCF0w3/5W3ZJvsIOn7SKFO/lCTxRMia3ZIfAk3fCqovJijjxaQqI5GvVzP3cvVeSOHLtM07b97xjr6WlO4VMb7/
 EJYj3Zwh
 aK++LOSknenTkiJpE8QGxRbRpZ0utp2bjrMMhYVemnmj+YrMSqF9liTIvNQpey90RCgwan1OagOv2kPNAcHTJMMfXy5ZJKLJlkLx3oWwgw8zrTlmZ8Yn5tSrWEzyRqx504c09pf8S0QjtKoXaNRH7FR9Su/YpiJ+zTqfxaCVxr8QhQjzZ7LjKz0BwPm9rDJNRv63oXbiScLziyZE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu,  8 Jan 2026 17:37:29 +0800 Jianyue Wu <wujianyue000@gmail.com> wrote:
>
>> From: Jianyue Wu <wujianyue000@gmail.com>
>> 
>> Replace seq_printf/seq_buf_printf with lightweight helpers to avoid
>> printf parsing in memcg stats output.
>> 
>> Key changes:
>> - Add memcg_seq_put_name_val() for seq_file "name value\n" formatting
>> - Add memcg_seq_buf_put_name_val() for seq_buf "name value\n" formatting
>> - Update __memory_events_show(), swap_events_show(),
>>   memory_stat_format(), memory_numa_stat_show(), and related helpers
>> 
>> Performance:
>> - 1M reads of memory.stat+memory.numa_stat
>> - Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
>> - After:  real 0m9.051s, user 0m4.775s, sys 0m4.275s (~11.4% sys drop)
>> 
>> Tests:
>> - Script:
>>   for ((i=1; i<=1000000; i++)); do
>>       : > /dev/null < /sys/fs/cgroup/memory.stat
>>       : > /dev/null < /sys/fs/cgroup/memory.numa_stat
>>   done
>> 
>
> I suspect there are workloads which read these files frequently.
>
> I'd be interested in learning "how frequently".  Perhaps
> ascii-through-sysfs simply isn't an appropriate API for this data?

We just got a bpf interface for this data merged, exactly to speed
things up: commit 99430ab8b804 ("mm: introduce BPF kfuncs to access
memcg statistics and events") in bpf-next.

