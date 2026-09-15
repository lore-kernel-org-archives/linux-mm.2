Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6591CC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:13:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126D86B0088; Tue, 15 Sep 2026 04:13:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D91B6B0093; Tue, 15 Sep 2026 04:13:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2FFD6B009E; Tue, 15 Sep 2026 04:13:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CA7F86B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:13:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4B0AA1C2283
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:13:27 +0000 (UTC)
X-FDA: 85215282054.03.BD3D0A6
Received: from mta0.migadu.com (out-17.mta0.migadu.com [91.218.175.17])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3BABEA0005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:13:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YyF2w0Bv;
	spf=pass (imf15.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.17 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789460005;
	b=Ka0xlyubxj5NiUxoNhHMdfhE9QPL5LKY2DiNfRAHd6UGv2CpRyvLuXZiDtplGBwNDzRceS
	TzsVoixhJuu82QpO88ZJu4GUvnk6BkeyhklAxnZ+ylGYPtS85xp7CEFUxtCEjGIwpKn6Nr
	rY+Kr8z1xnF4xZ1yGXtjoIk/ESw+M7c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YyF2w0Bv;
	spf=pass (imf15.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.17 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789460005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLKeFGVwg08I+DpcoOl1EenKiR9OUpor9+w9nYwyRC0=;
	b=w74ratAeRd7/wpjepqwedzpC2zftvUvIxwVPme5UUVQ6eO4/kcxKwV8W7vU7qKP0I1dbWO
	abtuWTdkic5pfnd5n2TBhVOH01rtuvZ4aRwMyCd6NljRNHOq/eMsXEDRW8yIRbq3ehEygB
	YZldxd2qiZcGHAfaXrUILt5n5HdzZm8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vuspLam82Go25b7VUX5tqc0m7B7hmyslMJV//0MlqZ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789460003; v=1; x=1790064803;
 b=YyF2w0BvxypSG4hIpPrEoeSkPMZv2eoPaOihQA94UTK1ua6QkdWa20x7GcwtQ63y9MDqRKvc
 QmHt1fLNVmoU8Bw2pGhHPnPgNbWUOY1onyC2omMDcRX/YgrD7DqeCGaGEWhZzwCGQ04HF3aRIAj
 OqilWz8A6nOzspAh8EXy6ck0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9987edb77f9512db;
	Tue, 15 Sep 2026 08:13:23 +0000
X-Mizu-Trace-ID: 9987edb77f9512db
X-Migadu-Flow: FLOW_OUT
Message-ID: <3c8d1d8e-0e67-4d1a-b73d-4eadd6266aa6@linux.dev>
Date: Tue, 15 Sep 2026 16:13:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/oom_kill: fix hung tasks queued on mmap_lock behind a
 long reap
To: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Zhou Yingfu <yingfu.zhou@shopee.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, David Rientjes
 <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-kernel@vger.kernel.org
References: <20260914113239.367200-1-jiayuan.chen@linux.dev>
 <aqg-oG2HDIUeK5Us@tiehlicka>
 <20260914203533.3544ae8dd0903c7603b385c6@linux-foundation.org>
 <aqjsPW92SgcHONKO@tiehlicka>
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <aqjsPW92SgcHONKO@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3BABEA0005
X-Rspam-User: 
X-Stat-Signature: 9ahp134igajk54pegzmfsuzn81p5nt74
X-HE-Tag: 1789460004-681823
X-HE-Meta: U2FsdGVkX1+uVE4prDkbP4Fyr34UJg7XBIwUSoJJrYgCebnAQvdIijblqRxDzroiJBIZnk2mp5ZGxPCWAW2Xgdhos0PACb++46ECKVF9GIzbQh6tpLo5+dQZaYhhnEcbogp/FZYMRur3diU5cuZhQrxSYk5E9Bai9BSTN7jkpvHQUtlP7A+khaIE4giRKst4rBekXic9m3MqvPvqSTdYL+YwQiw10xyiv/jB79/uuf17hemuAqLms+KmbtYFluesg0bG3jPwM6wQJoZDi/W1Gqp5ZtGXKokjTgiMLg0XdMx4/E/mStmsRpTfzK0r5h592M2AEp8OwlZ+esYpPXj3yJHbUs2h/veGWQB7O0ZlzBNh4wY3OTTpVJ+CIwcwKDg9mQdg6Uv8dp8TjGlRWlR0aLQkwF+94P60SPo7SQVNP4l0LRCyxXm+uXRDdYh4mblLjAVoroWr3GaPJt0QSHnKE6zYbX4lKun+E8slF5w27EzsdCSJ4SrZXqhE9Pii6U5UWuEDVF4RQuIw/THtqFVJSE495LfW7xmWiI3TkFnJsC+dvcTTSW1FoKh0HdMo0p3yayJlPiU/kF2Chbx0rKk7etFaeesvqylG38PaE9CVHV5xS2axTSQx93Wv89eaapnlei4QfpwPRfPLENqqFiLGIbd6EeIsa4xGp/o2gaCckk6uGdKaUvA1WgYz/Gw07HEf3QIxoOz4vI4XfbfZ0K6bDmEdboTlI3ey9HcOETbGKB40geQQ8PG0YbsqDtja7Ycnpwq/wundc4bieS5lD+B2uXHp/VDyuDlMCedsAtn01mLrG/1z9nrZ4PeG492+4pUlVy/lHlw4ZTUOHOCt1EDQFRRf81EapOCTaBAuTlNuMT2Z3/30/PgAJ5/jujdAnE3H3UqWQmepuCrKasidFpNqhcLTWJWTGArJlkQMjNG/rOJGXEl3ioqlmNqnClMTrw/MgtU5PsrkmWQ2VST2Mmg
 +Rtmv/IM
 EEKf3DK+qsl3JKe4g8Sv/ub/wFtpXe9qW/a6cTaez8JkpgZzpWnahCv8Md8VGPhKU710NWjlz+xYKJ3zRdT8J5EP0Je9umZrZjzTC44OX65QieCLHWC80aOxkwNeEOxY4cuTM3FveSzI1w+clf6fpSzmp4fzsD4FxwftZSiitBW79qRGyByevbQ7FrqkScWPNJ1kzsSkQdkOdHuWHmSY+Nv6WOAeqQXrE0P3ruh4+EhOvrHZY5ZahWesnErUcGXiFFpG5X4r0TO9W+6E19Fjtr1btiknNNkHbCeAhoVPAHtm0oCeJx2mhYWEdwNzMnr32ZpJM4/hNAEM+YGjCR/XwJXHQFxmq5Va5rPLR15dy/gj6UsUeXzvGdIlkkkdipq2kXysu/yURVDCn4oL5AQBaaKvQ6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 9/15/26 2:57 PM, Michal Hocko wrote:
> On Mon 14-09-26 20:35:33, Andrew Morton wrote:
>> On Mon, 14 Sep 2026 20:36:16 +0200 Michal Hocko <mhocko@suse.com> wrote:
>>
>>>> Call Trace:
>>>>   <TASK>
>>>>   __schedule+0x487/0x1870
>>>>   schedule+0x28/0xb0
>>>>   schedule_preempt_disabled+0x16/0x30
>>>>   rwsem_down_write_slowpath+0x1d4/0x750
>>>>   down_write+0x60/0x70
>>>>   __ksm_exit+0xb4/0x230
>>>>   __mmput+0x12c/0x150
>>>>   mmput+0x1e/0x30
>>>>   do_exit+0x283/0xa30
>>>>   do_group_exit+0x34/0x90
>>>>   get_signal+0x952/0x960
>>>>   arch_do_signal_or_restart+0x41/0x250
>>>>   exit_to_user_mode_loop+0xd3/0x560
>>>>   do_syscall_64+0x385/0x470
>>>>   </TASK>
>>>>
>>>> KSM is just the one LTP happened to hit: __khugepaged_exit() has the
>>>> same write lock cycle ahead of exit_mmap().
>>> Why is this a practical problem we need to care about? It is kind of
>>> natural that the oom victim exit path might race with the oom reaper. They
>>> share the same lock that is mutualy exclusive. The whole point of the
>>> reaper is to ensure there is a forward progress achieved. So before we
>>> start modifying this let's talk about any practical/real life problems.

Hi Michal, Andrew

Agreed, the hung task warning itself is harmless, especially for a dying
task. The real problems are what sits behind it.

With a 500G swapped-out victim the reap takes ~600s, and for all of it:

1. The victim cannot exit. __ksm_exit() needs mmap_lock for write and
  queues behind the reaper, so the process stays alive in D state for
  10 minutes and whoever waits for it (parent, container runtime)
  waits too.

2. ksmd and khugepaged stall. Once that writer is queued, their
  mmap_read_lock() on this mm queues as well, so both daemons stop
  for the whole system for the same ~600s.

With the patch they wait for one 1G chunk at most, and since exit_mmap()
now frees alongside the reaper, the victim's memory is gone in 264s
instead of ~600s. The reaper still never blocks on mmap_lock and still
makes progress on every pass, so forward progress is not changed.



>> If this situation is expected, unavoidable etc then perhaps the best
>> change is to periodically poke the hung-task detector?
> Right. Reaping 10s of GBs worth of VMAs might take some time indeed and
> that could trigger the hung task detector.
>

