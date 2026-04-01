Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67A96D35162
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 11:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 879A56B0005; Wed,  1 Apr 2026 07:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A106B0088; Wed,  1 Apr 2026 07:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 718DA6B008A; Wed,  1 Apr 2026 07:21:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DFFC6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 07:21:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F1053E1224
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:21:05 +0000 (UTC)
X-FDA: 84609745290.22.BDCB867
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id D12E910000B
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:21:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Igxn/Ksy";
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775042464; a=rsa-sha256;
	cv=none;
	b=tXPMi6smddSGi/8u+mrQaorvmi5fH96P29hmd2MmI9BwHJRnp2jtD3KYCvEWMX180Jq4fv
	QUZ3KYQz2ro12abfFGLrsSk1vRp4t91Kxfyo6gbtFou6sQWECibcPZENM7BDqmmCOMLYNU
	Z1RnujlHRZuZQYUTd0Bp7OAK+h5yUNo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775042464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UebqlSzKqacX5E8CJ3qASYdWU109pMRbyg8cPv53GRc=;
	b=PWld6shGZ1/zErlbYtX9CcsQwRMVf1PD2iSvvBPvVEtcTy0Et0NZ7ZtKiCTTPYEGtMzGw/
	iP4mBychXvyxHDQrPXYi12vDUTFSZ7LHbMmqKP5e9IfQkZI1Ks9Pxf1fDG4n/3ds5dFrQB
	ulTPKydpZqLkugvH9C33gVOHjer07V0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Igxn/Ksy";
	spf=pass (imf14.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775042461;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UebqlSzKqacX5E8CJ3qASYdWU109pMRbyg8cPv53GRc=;
	b=Igxn/Ksyj6n7VznzSj69beimIUFJWdx4bwroO+BMnIhy++j5EoH0g+omggUGB6H3KxUhfr
	/U7eLljdyGvI9OPKyZYkdbh2Alnu1pO/SznB+dR1zMi19oNOAK9rBYtVhBtGDKWzKRTGBm
	m5wI9yoSk0rLmPcOUGijQO4kMWdtnqM=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: lance.yang@linux.dev,
	kartikey406@gmail.com,
	usama.arif@linux.dev,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dev.jain@arm.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] WARNING in deferred_split_folio
Date: Wed,  1 Apr 2026 19:20:49 +0800
Message-Id: <20260401112049.18634-1-lance.yang@linux.dev>
In-Reply-To: <f28d968b-1d09-4db9-9f4b-55205f43c951@kernel.org>
References: <f28d968b-1d09-4db9-9f4b-55205f43c951@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D12E910000B
X-Stat-Signature: yqatmp9ygg1g1q9wss38nigfmhc7hark
X-HE-Tag: 1775042463-412463
X-HE-Meta: U2FsdGVkX1826+4M8CK6xmEjtt/3Il/IcHJXOgj3h8UpOJYamn8t55MJqa6ykGzeRLhx91QIHqCkL1HF8jctEPZLRY3NTG0iDR7BTjoZXiD1nRG82Cc1tT2gBj+t71Z4/Unhxiu+9c8oVa38ZT2EQ0lyRMPL+KEiZ78aGSWLMIT5eufjAIyD5JXP019J7WS2kMLbXGj+phzOpzc4RsHQWNTlB77r59+p82XpapblWNEQRyyV30xAgVIdn4TAWeI4tP/xsGjPGpSUhHo5rzk5qlB/nx+lcoXKoVeKiNNeFy6DN6f/eZ5gDF253busa8Of+bCjl7fVHcDgSXSdocqnmyjSI+VHJjKByn+TRwBG1sNR3G+YJdTnimYy+x5l2mfzoxiJD0Ji/NCllcVDfOKJiLYfwYzSbSH8U6ZFq8Oi69otgfdGvppHovd6ngqNElP651vZgc4ajjhDagdh/ZPi4kS2vbweEfAfh7cw2raGFujL0lm1Ah1B0Z30ERAhTdKtgmTOW5HD5vHWwkHIAP3V7fX6EAoBw1onMrdkM+KQrIeQC23VROPuJOuU76zUimTkz8X3huFKAR2XKroBuivW9GlzOB8FYNLBMoZKAeihwIT13Wce/SOThThx9+7OsoKakOay6/EJNwiQ/FriYoo9JJ9UTjpZhrkHbNrAt917IO928rWiMhn+xXrsPsW3hmIn9ZoRGtp0jQjxzot9sC40nBQbhB6a4BFyoie2+xCwV2gAl6PKGL0nKj1GaezuUkeyClOJ0zF6qkBWP/+9SVZIDuxbTyFVizEUgpav9C+zXzOqDUPXvSZONle4cRZkAbiGNyDJ2wPI7rON8z459NYltCw3ZRsWHyiTVemlAmdehF2ssz/gcBlwYlIL4BO3ycR8tE5KIoiuX3eJdtELfYgrJEmzwcLumWsL5DIPBNzbWk+qxvwiQPzhUEkicmwxzZkb9PkrZELxUZA8hv2kkXu
 5iVbFAV5
 SiySg0JAeogGx9fvDFqQnqwx8lSM9+zzF5jnNvbFbR5QBMQ2s6vMOUErd8PASxDR8PyDxq5SriZ7rwe1AgJQZbDXpuweyEX6ECHnXj6SFzUDI6cw/wtM5Oms6zValTxbBHhCmTuHxDz+LA2m2niU3on8VhG48LGUf/zQJ1EYwdjY9+Ml6fDD8Y+AUf5umfXTjamHS46uVZtre71PZ5luCau/aHTyXrdZSU6vxeE4BYbMeMJjVPby9G7/1nlFIFcQkSeADPGDoOBMBR6loDV9OB9Vhtbtce6wOLVV25iMx4kqGn48tar4Afg4vp2NNQPSUsbdy+foQfUN/bINgQol6Rkv68OCjQ9tqMG6q/pn+bFDbhZDbr4mEjW+N1BBjZYVNyFJ4snv7i17OR2tdrDaP5wF0wlvqtgZTfeWXA7LBivPjtDSxsD8mGVUBwDkPXKHtc6ycBJAhvf/HTcrJYmtFeM4EZyNXqlWXdiJcNZwLLRZt5XMcNVPUKAlamQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 01, 2026 at 01:00:13PM +0200, David Hildenbrand (Arm) wrote:
>On 4/1/26 12:53, Lance Yang wrote:
>> 
>> +Cc Deepanshu
>> 
>> On Wed, Apr 01, 2026 at 12:16:43PM +0200, David Hildenbrand (Arm) wrote:
>>> On 4/1/26 10:59, Lance Yang wrote:
>>>>
>>>> >from another sharer can then remove some of those mappings and reach
>>>>
>>>> Perhaps the WARN is simply too strict there :)
>>>>
>>>> Migration already holds the folio lock on dst, while the competing
>>>> rmap-removal path runs under the page-table lock. So once
>>>> remove_migration_ptes(src, dst, 0) makes dst visible again, this race
>>>> looks hard to avoid.
>>>>
>>>> So maybe the simplest fix is just to drop the WARN in the
>>>> !partially_mapped path:
>>>>
>>>> ---8<---
>>>> Subject: [PATCH 1/1] mm/thp: avoid false warning in deferred_split_folio()
>>>>
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> migrate_folio_move() snapshots src_partially_mapped from src before
>>>> migration and later requeues dst after remove_migration_ptes(src, dst, 0).
>>>>
>>>> Once dst is visible again, a competing rmap-removal path can legally set
>>>> PG_partially_mapped before the migration path reaches
>>>> deferred_split_folio(dst, src_partially_mapped).
>>>>
>>>> Migration already holds the folio lock on dst, while the competing
>>>> rmap-removal path runs under the page-table lock. So once
>>>> remove_migration_ptes(src, dst, 0) makes dst visible again, this race
>>>> looks hard to avoid.
>>>>
>>>> So just drop the WARN in the !partially_mapped path and preserve an
>>>> already-set PG_partially_mapped bit.
>>>>
>>>> Link: https://lore.kernel.org/linux-mm/69ccb65b.050a0220.183828.003a.GAE@google.com/
>>>> Fixes: 8a8ca142a488 ("mm: migrate: requeue destination folio on deferred split queue")
>>>> Reported-by: syzbot+a7067a757858ac8eb085@syzkaller.appspotmail.com
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>>  mm/huge_memory.c | 3 ---
>>>>  1 file changed, 3 deletions(-)
>>>>
>>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>>> index 745eb3d0d4a7..8ea8e293dc7c 100644
>>>> --- a/mm/huge_memory.c
>>>> +++ b/mm/huge_memory.c
>>>> @@ -4433,9 +4433,6 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
>>>>  			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
>>>>
>>>>  		}
>>>> -	} else {
>>>> -		/* partially mapped folios cannot become non-partially mapped */
>>>> -		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
>>>>  	}
>>>
>>> Can't we simply move the setting before restoring migration ptes?
>> 
>> Afraid not, it closes the remove_migration_ptes() ->
>> deferred_split_folio() race, but opens a new one with the shrinker, IIUC
>> 
>> Once dst is on the deferred split queue, deferred_split_scan() can
>> pick it up immediately. The shrinker unconditionally dequeues every
>> folio it visits:
>> 
>> 	list_del_init(&folio->_deferred_list);   /* always */
>> 
>> Then for a non-partially-mapped folio, if folio_trylock() fails
>> (dst is still locked by migration), it falls through to:
>> 
>> next:
>> 		if (did_split || !folio_test_partially_mapped(folio))
>> 			continue;  /* not requeued, dst silently lost */
>> 
>> so it is *not* requeued.
>
>How is that different to the shrinker just trying to lock the folio before we
>unlock it and failing? The race already exists?

Ouch, you're right, I was wrong - the trylock drop is a pre-existing
issue, not caused by the reorder ;)

>
>To sort out that race a trylock must not result in the folio getting
>discarded.

Nice, LGTM!

Given that the "trylock -> drop" behavior seems to exist already today,
do you think it's worth fixing that together with the reorder?

>diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>index ff9a42abd1b6..521989517cd1 100644
>--- a/mm/huge_memory.c
>+++ b/mm/huge_memory.c
>@@ -4558,7 +4558,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>                                goto next;
>                }
>                if (!folio_trylock(folio))
>-                       goto next;
>+                       goto requeue:
>                if (!split_folio(folio)) {
>                        did_split = true;
>                        if (underused)
>@@ -4569,6 +4569,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
> next:
>                if (did_split || !folio_test_partially_mapped(folio))
>                        continue;
>+requeue:
>                /*
>                 * Only add back to the queue if folio is partially mapped.
>                 * If thp_underused returns false, or if split_folio fails
>
>

