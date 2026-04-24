Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01FF9FED3E6
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 15:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5C96B009E; Fri, 24 Apr 2026 11:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D526B009F; Fri, 24 Apr 2026 11:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA796B00A0; Fri, 24 Apr 2026 11:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0C46C6B009E
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 11:38:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A4BCF140230
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:38:18 +0000 (UTC)
X-FDA: 84693855876.21.E26B62A
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf25.hostedemail.com (Postfix) with ESMTP id 857ABA0013
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 15:38:16 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gc01UbS1;
	spf=pass (imf25.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777045096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zKN6v9bTjDgu0IaG/MSAwW/NKUa2Ct+xds0UCRCsb2c=;
	b=D/Cvav3rqQ0tuINnGaYgNujvSOBUv7Jm+5GBcAs8dJ6n0l+G5pXrEy4CDfbucX8If8yh/j
	0Oyi6779s65X6Cvfv1zmgYrQK80RdVvuuML6KCMi3v32RbOG/sojkeTyu0q2dKLrBaMGxl
	7YOAp1m5yIA8+OvCCX5jRhNgzJ1Qu8Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gc01UbS1;
	spf=pass (imf25.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777045096; a=rsa-sha256;
	cv=none;
	b=uifkkHXe8I/HGzJ9KPqfBnCg9JZA+aVAuXVKp+aAOmUuuKzHDscucPguJJs0I/LAPTNp8W
	hIGJkkNF9oJyYI8Mrjz0aVCXXnEfg1oxkIjg/4+jpmi2ltlb4+EeBIggV6j6Qp+cjfMCYW
	G5IHhOOaf/QFzNLSyNSdcHbGSCMu/AA=
Message-ID: <a4c8a792-7256-4e4c-9f8e-5539a8f93459@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777045093;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zKN6v9bTjDgu0IaG/MSAwW/NKUa2Ct+xds0UCRCsb2c=;
	b=gc01UbS19yK1by58PvOyc4eS5trp09R5wDt5hf4nlod7Ef7qA8rZ+Z/wcXaYPd2QmVQXSc
	E59QoPSmF5tLGx9wQB4OaYYcA2CxwgitLcmv9YSPNW9Bqn3ai7rArwSUo8zhNZCvZ6Rnf5
	tXvVqFzfzbe58uiCPeZCRNDcWqkI3M8=
Date: Fri, 24 Apr 2026 08:38:06 -0700
MIME-Version: 1.0
Subject: Re: [PATCH] mm/lruvec: preemptively free dead folios during lru_add
 drain
To: Barry Song <baohua@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@kernel.org,
 mhocko@suse.com, willy@infradead.org, hannes@cmpxchg.org, riel@surriel.com,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20260423164307.29805-1-jp.kobryn@linux.dev>
 <CAGsJ_4ygEvptQy662tTiPm-k+E4cbfvUKGGg3w7NaaALO-F4ig@mail.gmail.com>
 <aequK2ZM3O_7NM1M@linux.dev>
 <CAGsJ_4xy+kGktiePL28DP3PAcVsdnz8Noann2UGhD=EV+3xjqA@mail.gmail.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
In-Reply-To: <CAGsJ_4xy+kGktiePL28DP3PAcVsdnz8Noann2UGhD=EV+3xjqA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 857ABA0013
X-Stat-Signature: csxdwyjzs7rey48su9iznqonxuphw6ys
X-Rspam-User: 
X-HE-Tag: 1777045096-519549
X-HE-Meta: U2FsdGVkX1+w5p1IVu4MAzWTC+6/9Bb+l+42DRX+G639fhzopFIB8JeDwlNUNtwtT9e7bfRNQfShyReOKpeSwOaaRIDqS1a27TpaCEWeesGx/dbExIVeW94Hy/Y065jTgQrM6dSUneQb6uJo4MN6g/8sO0vttFAhcnpHjH8qHG+KhtLlcccyigX/FDT4Xbf9qurSbC6+9G/ii1vNBDDKBRhJpqHgiQgsCfsLzfoK9aM9L0GpuNhCI6nM3uDYfH8R3jBlHFwzI7vqtulJ/le1NxvkQT7LU2XKH76NarN+Z4NVWU9wuHx1KOEf9hmyLex+rxGPOQPQTZ2z+vGriTu36nYQtJPpF01o7duGKloi06z8S7YV2g3x4OA3eTuTLANsz6VavLhGUI28F3IqUjOh/eMnJh21ozogS7mFL5FJXO03/e3Q0T/AtK1qT9FulncqHDBOx7GkrdjZo4kuGlVtLldjCfsX+UVhBmyEDoewQEs04La1Y2t7ESH3V29OSwIdJ/L56lYYdSGrDC4ktJ4W4UxrL3WXBGwcHiNcN9tCxziq8UoBa/b0qY5Ci31GeaPhMtejL3CTg5ZLdNj8OgAAHJFo1gO+g8YPz2YdjR+fEL8n2+EAXYCGswA4BE+dbzuc5F2si0zCaZ+iuflttgO+Ba3IFL+HKFp9Sa6U6LbRN+Ty8hqAHX0+0zFVBqha4OzANYaNkb7kloafPkYdblbqjB6obgJo04PP5Jc3VwmejuiiOcZvkAq+OtwnSNRBzZrzoduSkxZXJPDF4EgRqd+vOzGZJkfe3TG35pOqG9RMAfk9HI9OQqb5gpjreopP1g7LBPOGG3HIUXgiByaQMHRvT4DwVKkNwCaSyueY4N41X2jh1eDSWu3dC1gZ/jy/OsAZ1zQ7zydXpEw2gLZT7/pPhCBA7jOfG6uYaN6NV5x6+JuGoekgC9hOKPtq18NOaKVXDGGJk+lVsB6rwGmKhn3
 +80X6uCO
 NnWoeJ2QisuX1JIJSeNBocCFQfCI4kkHfWXJoP2ae1IhDwRlC+4jRis/B9TmZ4QF6z4iK99QRzR0duFkHzTS8uDsP972XO7unZ32keCaLgXpRzUFjZJHn1L+ISHrfyI5DwPyArg21rygRys3BzjE7aFGkvKUxnwiXg9pck+h1IUdCiTcZ9fN3GvGadtcn1c0huC80HVYGFNq8HwJ3ITrssyiL85m3bqdT6xwl5QdxYMhwoUzC+Rj6fjQtGdAZ66WhLRwt8xNa5TcTZPZhmH/KCowPyTUzkTM/yoaKay23rJlcG+yS3PS26B5DJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/23/26 4:53 PM, Barry Song wrote:
> On Fri, Apr 24, 2026 at 7:46 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>
>> On Fri, Apr 24, 2026 at 07:22:30AM +0800, Barry Song wrote:
>>> On Fri, Apr 24, 2026 at 12:43 AM JP Kobryn (Meta) <jp.kobryn@linux.dev> wrote:
>>>>
>>>> Of all observable lruvec lock contention in our fleet, we find that ~24%
>>>> occurs when dead folios are present in lru_add batches at drain time. This
>>>> is wasteful in the sense that the folio is added to the LRU just to be
>>>> immediately removed via folios_put_refs(), incurring two unnecessary lock
>>>> acquisitions.
>>>>
>>>> Eliminate this overhead by preemptively cleaning up dead folios before they
>>>> make it into the LRU. Use folio_ref_freeze() to filter folios whose only
>>>> remaining refcount is the batch ref. When dead folios are found, move them
>>>> off the add batch and onto a temporary batch to be freed.
>>>>
>>>> During A/B testing on one of our prod instagram workloads (high-frequency
>>>> short-lived requests), the patch intercepted almost all dead folios before
>>>> they entered the LRU. Data collected using the mm_lru_insertion tracepoint
>>>> shows the effectiveness of the patch:
>>>>
>>>> Per-host LRU add averages at 95% CPU load
>>>> (60 hosts each side, 3 x 60s intervals)
>>>>
>>>>              dead folios/min  total folios/min   dead %
>>>> unpatched:        1,297,785        19,341,986  6.7097%
>>>> patched:                 14        19,039,996  0.0001%
>>>>
>>>> Within this workload, we save ~2.6M lock acquisitions per minute per host
>>>> as a result.
>>>>
>>>> System-wide memory stats improved on the patched side also at 95% CPU load:
>>>>   - direct reclaim scanning reduced 7%
>>>>   - allocation stalls reduced 5.2%
>>>>   - compaction stalls reduced 12.3%
>>>>   - page frees reduced 4.9%
>>>>
>>>> No regressions were observed in requests served per second or request tail
>>>> latency (p99). Both metrics showed directional improvement at higher CPU
>>>> utilization (comparing 85% to 95%).
>>>>
>>>> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
>>>
>>> Hi JP,
>>> I’m seeing a large number of "BAD page" bugs.
>>> Not sure if it’s related, but reverting this patch
>>> seems to fix the issue.
>>>
>>> [ 2869.365978] BUG: Bad page state in process uname  pfn:3a5417
>>> [ 2869.365981] page: refcount:0 mapcount:0 mapping:0000000000000000
>>> index:0x724884c20 pfn:0x3a5417
>>> [ 2869.365983] flags:
>>> 0x17ffffc0020908(uptodate|active|owner_2|swapbacked|node=0|zone=2|lastcpupid=0x1fffff)
>>
>> Hi Barry, are you using MGLRU? It seems like MGLRU set active flag in
>> folio_add_lru().
> 
> Yes. If you are referring to this set_active, I think it is
> incorrect, so I have fixed it here and am waiting for review:
> 
> https://lore.kernel.org/linux-mm/20260418120233.7162-1-baohua@kernel.org/
> 
>>
>> JP, we need to clean active flag but let's check what else can be set before
>> folio_add_lru().

Barry/Shakeel,

We can do something like this as a special case for MGLRU:

diff --git a/mm/swap.c b/mm/swap.c
index 71607b0ce3d18..68ea929f65031 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -185,6 +185,8 @@ static void folio_batch_move_lru(struct folio_batch 
*fbatch, move_fn_t move_fn)
  		 * deferred split list to avoid a dangling list entry.
  		 */
  		if (is_lru_add && folio_ref_freeze(folio, 1)) {
+			if (lru_gen_enabled())
+				__folio_clear_active(folio);
  			folio_unqueue_deferred_split(folio);
  			fbatch->folios[i] = NULL;
  			folio_batch_add(&free_fbatch, folio);

Unless Barry's patch works out... Any thoughts?


