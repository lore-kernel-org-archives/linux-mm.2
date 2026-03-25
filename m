Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 945C8109C020
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82E06B0093; Wed, 25 Mar 2026 10:25:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33A06B009D; Wed, 25 Mar 2026 10:25:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49476B009E; Wed, 25 Mar 2026 10:25:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AFD716B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:25:10 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5E2CF5BA8D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:25:10 +0000 (UTC)
X-FDA: 84584807580.24.F39A990
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 94EA01C000C
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:25:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mGFjNcJD;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774448708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpB4rzY1tUTs7SaigWeg5qoTE99gD+o6MD5fMH/+Tv0=;
	b=uxXTedAMr5dWjmSapPf19PCcXDNlFOAerU1a6HpT6zrCzECB5n1kTWt2nMXQlh8Jg7KyB7
	3YNrn5el4w3VoTeVhOx95XB2BQrvK9b5H0PrNVD67KRvdm6Uv2p5oQ18IE3x+NZ5T947Bs
	gPFzah4nTwj7cMlQVWJNrU5Kt009eC4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mGFjNcJD;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774448708; a=rsa-sha256;
	cv=none;
	b=aCBcYcySuOE6c/tNTPmgQMM08Hf5QzBXQMUXQeZQ/xm7VnyrmjWAur430TziIdqmtfpdl6
	T/yUh1rqRgicOtSg553GefxarSuOF2ojOlqFVsCADmx9jM1oMQhZ9McVjWf4osx5B1Igb/
	gpYB78DMPG6U6DF0C4wTBZlM7BHW8uo=
Message-ID: <19e8a328-d4c2-4809-a42d-e46d2a994d5d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774448704;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jpB4rzY1tUTs7SaigWeg5qoTE99gD+o6MD5fMH/+Tv0=;
	b=mGFjNcJD0uYEJwAeKxfMsFPSiUNxxi73p+sEDOn20KVqO8vXUnQx4ZpFKc2WX5PvgW3fIx
	O2qQisaWFU8hHm8gUyQ+KvGCiSSqa/rJ5JCAJCJDvW10Uq8YXROxffBt4A/wS2CCWyTDeY
	7+fKmj/9uM2HhhV4pZbaF6vK8AHq1mQ=
Date: Wed, 25 Mar 2026 22:24:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 0/4] fix unexpected type conversions and potential
 overflows
To: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ljs@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <cover.1774447069.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 94EA01C000C
X-Stat-Signature: ayznjwb4xhzbd8wncuu8e6g97xog137s
X-Rspamd-Server: rspam06
X-HE-Tag: 1774448706-968847
X-HE-Meta: U2FsdGVkX18c+Gf09riA8A0DuObU2CHy841pIB5lguCpyWMLi6clnfQwk2Tlhp3DK8Wlj413yaq8KzY0pt2BjNkIoEOcWiX7waSJcynG3yKuwmnUHw43KqWYkKrCKf1FlMZ+q2rGYCrl5A4amz21DF7R9MqFZ8RjWmVzrLqVA6qfsuH47517uGDtmkGtVVvUc1EvSYhGwY+6/ZdMPweT5n/pl9Jw97S4ktTTMN2yrZ26deJoAw3G9tTfe9GK6AojyN7he96oPmnswfDpnEZ64iq1Vub41ksuObga9q53vm/LecjLcn67MLdfPZq8t3EoW4nf6yuqNxHw1oKx1AcnVEdlp8JBlgnKng0SXyRL/jALtmJ4usXHbmLmLAzM9pVnlFeRiCX7eycxdJjzXKxAYiofCnPAMO5Cn0uPamg6ZxkJMrKwyjp0CsAnCyCUA9NhorjoutzHBALZr2/QOI33Ck3SNuoZeKPvek5ScWaBk1m73tGkKiXtXWzrV2coirc2C0E8xzIU9DQGFkv/T4MwMomyhzPbY4/9wng9Kn0UpgHxooLTJT240ZfIWFYDO5u79Ag16fz/n/Y1LhZvs0n1d5CuWqJihFCwTxOMYNeSWvyfJbfr4JV0xt5QGIN9RSCtZb2lQFw0DJk+6vq07OBfiOKAr6a+6xiVA5pKFkp8JvnLCgIp2p1KjvF2XmnOL9xZJ/aZl+ZVpRb5tapuKEY4IKwF0M9fxiD2x2CN0ydXmQKOWElmNUTm8qssuNyrL8RIdIZsCO0C2/7g7j5mYuJASajtyQWSFeBP+jn4HTPBz/p+L1KQuzgphpRqQJGVH1C5AZfsRjdLjEYFIzlXMAu3u2s18ltxS8EpWdBoK8QqNubPMYL/09r4GGPlbqeuB8+rEGw2jh+4CuOKAvzy2mYyTKzbW99HLD5coXZsPzG8DJMtGsFci/Qw1P63rUVi86TBQZK7Qw2z31lfQcYo14j
 InCGTrFS
 OvmcL6KSN0aQ3Mnq23yF5TDwd2YvP7N8fzkwqA39G+pt1rbMYKbYyPEOR4BVOi3gDp7anRQcCP99danMmCjSJ4TONEIS7wqxUf19sWR4HLX1/bRvoq0b3XIjC/0lWyN34oM9p55IY3QF4V6acHiBDBuwVvqjg0ah3fO32Q+NjXEG1U7i3hwML+4jMqUUAKntA80Bj52InR1j7UXnjS8xYO8V1Y6dZpCQyz/Ug/Z3GHP6I82RtuB2gHvg+c3c5RYAhT1zA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forgot to include the changelog:

Changes in v2:

  - modified all commit messages. (suggested-by Lorenzo Stoakes)
  - added a fix patch to resolve the unexpected massive positive number
    (pointed-by Harry Yoo and sashiko)
  - fix the print type mismatch in [PATCH 3/3]
  - collect Reviewed-by

On 3/25/26 10:13 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Hi all,
> 
> As Harry Yoo pointed out [1], in scenarios where massive state updates occur
> (e.g., during the reparenting of LRU folios), the values passed to memcg stat
> update functions can accumulate and exceed the upper limit of a 32-bit integer.
> 
> If the parameter types are not large enough (like 'int') or are handled
> incorrectly, it can lead to severe truncation, potential overflow issues,
> and unexpected type conversion bugs.
> 
> This series aims to address these issues by correcting the parameter types
> in the relevant functions, and fixing an implicit conversion bug in
> memcg_state_val_in_pages().
> 
> This series is based on the next-20260323.
> 
> Comments and suggestions are welcome!
> 
> Thanks,
> Qi
> 
> [1]. https://lore.kernel.org/all/acDxaEgnqPI-Z4be@hyeyoo/
> 
> Qi Zheng (4):
>    mm: memcontrol: correct the type of stats_updates to unsigned long
>    mm: memcontrol: change val type to long in
>      __mod_memcg_{lruvec_}state()
>    mm: memcontrol: correct the nr_pages parameter type of
>      mem_cgroup_update_lru_size()
>    mm: memcontrol: fix unexpected massive positive number in
>      memcg_state_val_in_pages()
> 
>   include/linux/memcontrol.h   |  2 +-
>   include/trace/events/memcg.h | 10 +++++-----
>   mm/memcontrol.c              | 37 +++++++++++++++++++-----------------
>   3 files changed, 26 insertions(+), 23 deletions(-)
> 


