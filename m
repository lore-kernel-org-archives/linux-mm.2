Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC44F34C58
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEC6C6B0089; Mon, 13 Apr 2026 10:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC35B6B008A; Mon, 13 Apr 2026 10:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00516B0092; Mon, 13 Apr 2026 10:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFEC46B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:28:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2BA6C1601FF
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:28:14 +0000 (UTC)
X-FDA: 84653762508.18.D2F8CE5
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1FF5718000F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:28:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	spf=pass (imf06.hostedemail.com: domain of pmenzel@molgen.mpg.de designates 141.14.17.11 as permitted sender) smtp.mailfrom=pmenzel@molgen.mpg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776090492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=ZTiJclLaXDEywemfdcqLONzDvleNE0fh/MD0T+W4qBQ=;
	b=Xa5dw0heoeJi/fsHl6R3NzRsPPQsRzcmDsBazCzbmcH2wf+LM+/ruJc6Kx3nWdhJDwyWTk
	+cvBOgRi6ANyru6Eu7dlXwvkV5/szdisuCa3sMyEHierEsYTuS/mrVqxJ7BelOqfypG16X
	rhUAZTfnJK56nOZUaToinxlqu9c7jyA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776090492; a=rsa-sha256;
	cv=none;
	b=RO62qTGDgXfXuZfD9eCcdxbBVYvntMalkA53NAyZPbtksB2M5MihF1ABlyTJunTNAjJcm9
	WQUC7W1anjRAFGegG85X/UHXfh7MtHvEpVNjloHoCpdl/T8ikilA23qWiDSVPESUW7Q5cB
	bVBZTT+97QcdrBqGVMIBJw8K9mhPZ9c=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of pmenzel@molgen.mpg.de designates 141.14.17.11 as permitted sender) smtp.mailfrom=pmenzel@molgen.mpg.de;
	dmarc=none
Received: from [141.14.220.42] (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9B5C64C2C37D5B;
	Mon, 13 Apr 2026 16:27:29 +0200 (CEST)
Message-ID: <6548ed30-531b-4121-a4a4-f9cd724ba52b@molgen.mpg.de>
Date: Mon, 13 Apr 2026 16:27:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>
From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: UBSAN: invalid-load in mm/vmscan.c:4286:37: load of value 88 is not a
 valid value for type 'bool' (aka '_Bool')
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1FF5718000F
X-Stat-Signature: n6jbnnab9m3f6ewx8amz611nkwkw7mby
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776090491-57428
X-HE-Meta: U2FsdGVkX1/eZ5E83LWB1/F5nLJ61OoDfaTEMKWVu18G36nGMl7iRk5uwp1aLiBdpn3b0d5VYrHvXlrGgYjkZyvM0cQfCOOHBpeqhzAYYa4xf7XXJO6imhgl9c97HU4/7nuuqsuXlDQHrQ2DZWZrFoEc48aMF0uh7l8FQL5h/RNDRqM7Npvm63br9LEKKfRGFiXOzu1KrqhUuSrdh8RqP34tEpsBjrtXhX01DqJgtbiW3imymF4WSIHIfpS6rxEzdrvZLmf+4H/vFqUn4veRwqXjb3Wnxz6UuOzsbbo6c+97oI1sbGIUe2EKneTh//+GOoS5pcvhmHXadAzrha/sgQyDY6oPFGPs5qdvc7EASVqY98Iy7AZO7fTHV2yMSH1/6dGZT7nzaQtCsASLQ9Z0Zu3kV/DziUsDTgpY6vXAIMITDPVFf/M7n/ytagp6K7eJQknDUxQlwNbyoOTdtXQV6aNsrkC7YyFHGyHNwITcY1sNY+Z+A/WUMz5qQH3BpQOWNTYqKxGo+RQYljIyXQfLwgWAR3rEbS5xq+jewnXmutqQp2q8mVw/ljoKYbLEsMdFhFp1bOog9PVyc5JEwYSmFSBtXeVtNyQ6OjwtSPspB5XLyjsyhj5KRqsPNCGyaYY5YjvZIEaEDGxd+R4JuSN7XLyIvL1EWSRfAxOpGTHvV1VQY0r5+LEntnEmc514h+OYjBj5/Dc8XZZIAiqlGbs2xD9aJgVJMg3zEQgUL2NgIKo4bi2vGKoxsmrHolYlxY07ix9tR1dqEzQA99iEvooinKzzkVbGvbi64ON2oY7jenBtBmZ4158WHMIlUDZqO0rHps3ugzrkuvh8qbw5mEbUDOKe8hmQtPElWw4jphEp1NlY9x1vV8hfKCb6UwGoAYi68OgJT2umaiKExIJCdRdUGQmzHziHqGJlh6ufoVvSxQ/NgL0vqVSDR+ActIP7n6lhWM7jeqRe4+4Es9A3qyP
 WdxU7fqg
 8Lg+m4R9nIRdW6kjmm/oJS87viG7HU4wmB37Nc6kgQAJncAcsJLGGSlNAHC99NmFIxG5ubybvV5kLgHrwM0HKRj1gMZ2uH5ALK8NaC8B2aVNVRXsAW9e1WLN5yTQCbDoJ9/9T4lGa2ON+waa5efzErXf0+QA40hdGvlyTMTxLzDx0wZOpZ2PxXrLwJTHm7bhGABUyfJF/w3D21dxtGfQqsT6q82IZCBfFul+X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear Linux folks,


Linux 7.0 built with Debian’s *clang-23* 
1:23~++20260204101751+dd02b404b020-1~exp1 (and *libstdc++-16-dev* 
installed) logs an UBSAN finding on a Dell XPS 13 9360:

```
[    0.000000] Linux version 7.0.0 
(build@bohemianrhapsody.molgen.mpg.de) (Debian clang version 23.0.0 
(++20260204101751+dd02b404b020-1~exp1), GNU ld (GNU Binutils for Debian) 
2.46) #234 SMP PREEMPT_DYNAMIC Mon Apr 13 11:04:59 CEST 2026
[…]
[  149.874833] ------------[ cut here ]------------
[  149.874840] UBSAN: invalid-load in mm/vmscan.c:4286:37
[  149.874848] load of value 88 is not a valid value for type 'bool' 
(aka '_Bool')
[  149.874855] CPU: 2 UID: 0 PID: 69 Comm: kswapd0 Not tainted 7.0.0 
#234 PREEMPT(lazy)
[  149.874858] Hardware name: Dell Inc. XPS 13 9360/0596KF, BIOS 2.21.0 
06/02/2022
[  149.874860] Call Trace:
[  149.874864]  <TASK>
[  149.874868]  dump_stack_lvl+0x5e/0x80
[  149.874875]  ubsan_epilogue+0x5/0x30
[  149.874878]  __ubsan_handle_load_invalid_value+0x9c/0xa0
[  149.874886]  ? pfn_valid+0x106/0x130
[  149.874895]  lru_gen_look_around+0x2a6/0x570
[  149.874912]  folio_referenced_one+0x1d2/0x4c0
[  149.874919]  ? __rmap_walk_file+0x40/0x190
[  149.874933]  __rmap_walk_file+0x12b/0x190
[  149.874941]  folio_referenced+0x144/0x210
[  149.874945]  ? __pfx_folio_referenced_one+0x10/0x10
[  149.874949]  ? __pfx_folio_lock_anon_vma_read+0x10/0x10
[  149.874952]  ? __pfx_invalid_folio_referenced_vma+0x10/0x10
[  149.874959]  shrink_folio_list+0x58b/0x1220
[  149.874991]  ? mod_memcg_lruvec_state+0x15f/0x270
[  149.874999]  ? lock_release+0xfc/0x340
[  149.875005]  ? evict_folios+0x16f3/0x1c90
[  149.875013]  evict_folios+0x177d/0x1c90
[  149.875037]  ? lock_acquire+0xa8/0x1d0
[  149.875041]  ? lock_release+0xfc/0x340
[  149.875049]  ? lru_gen_rotate_memcg+0x37/0x2f0
[  149.875056]  try_to_shrink_lruvec+0x2be/0x370
[  149.875068]  shrink_one+0xa6/0x180
[  149.875073]  ? shrink_node+0x96f/0xd60
[  149.875077]  shrink_node+0xb04/0xd60
[  149.875094]  kswapd+0xa45/0x1210
[  149.875106]  ? kswapd+0x544/0x1210
[  149.875120]  ? lock_acquire+0xa8/0x1d0
[  149.875124]  ? lock_release+0xfc/0x340
[  149.875129]  ? __kthread_parkme+0x45/0xb0
[  149.875137]  ? _raw_spin_unlock_irqrestore+0x28/0x50
[  149.875144]  ? __pfx_kswapd+0x10/0x10
[  149.875150]  kthread+0xfe/0x130
[  149.875156]  ? __pfx_kthread+0x10/0x10
[  149.875160]  ret_from_fork+0x12a/0x2f0
[  149.875164]  ? __pfx_kthread+0x10/0x10
[  149.875169]  ret_from_fork_asm+0x1a/0x30
[  149.875185]  </TASK>
[  149.875186] ---[ end trace ]---
[  149.875214] ------------[ cut here ]------------
[  149.875216] UBSAN: invalid-load in mm/vmscan.c:4274:39
[  149.875222] load of value 112 is not a valid value for type 'bool' 
(aka '_Bool')
[  149.875226] CPU: 2 UID: 0 PID: 69 Comm: kswapd0 Not tainted 7.0.0 
#234 PREEMPT(lazy)
[  149.875230] Hardware name: Dell Inc. XPS 13 9360/0596KF, BIOS 2.21.0 
06/02/2022
[  149.875231] Call Trace:
[  149.875232]  <TASK>
[  149.875234]  dump_stack_lvl+0x5e/0x80
[  149.875238]  ubsan_epilogue+0x5/0x30
[  149.875241]  __ubsan_handle_load_invalid_value+0x9c/0xa0
[  149.875249]  ? pfn_valid+0x106/0x130
[  149.875256]  lru_gen_look_around+0x42a/0x570
[  149.875272]  folio_referenced_one+0x1d2/0x4c0
[  149.875277]  ? __rmap_walk_file+0x40/0x190
[  149.875291]  __rmap_walk_file+0x12b/0x190
[  149.875299]  folio_referenced+0x144/0x210
[  149.875303]  ? __pfx_folio_referenced_one+0x10/0x10
[  149.875307]  ? __pfx_folio_lock_anon_vma_read+0x10/0x10
[  149.875310]  ? __pfx_invalid_folio_referenced_vma+0x10/0x10
[  149.875317]  shrink_folio_list+0x58b/0x1220
[  149.875349]  ? mod_memcg_lruvec_state+0x15f/0x270
[  149.875356]  ? lock_release+0xfc/0x340
[  149.875361]  ? evict_folios+0x16f3/0x1c90
[  149.875369]  evict_folios+0x177d/0x1c90
[  149.875393]  ? lock_acquire+0xa8/0x1d0
[  149.875397]  ? lock_release+0xfc/0x340
[  149.875404]  ? lru_gen_rotate_memcg+0x37/0x2f0
[  149.875412]  try_to_shrink_lruvec+0x2be/0x370
[  149.875423]  shrink_one+0xa6/0x180
[  149.875428]  ? shrink_node+0x96f/0xd60
[  149.875432]  shrink_node+0xb04/0xd60
[  149.875450]  kswapd+0xa45/0x1210
[  149.875461]  ? kswapd+0x544/0x1210
[  149.875476]  ? lock_acquire+0xa8/0x1d0
[  149.875480]  ? lock_release+0xfc/0x340
[  149.875485]  ? __kthread_parkme+0x45/0xb0
[  149.875492]  ? _raw_spin_unlock_irqrestore+0x28/0x50
[  149.875498]  ? __pfx_kswapd+0x10/0x10
[  149.875504]  kthread+0xfe/0x130
[  149.875509]  ? __pfx_kthread+0x10/0x10
[  149.875514]  ret_from_fork+0x12a/0x2f0
[  149.875517]  ? __pfx_kthread+0x10/0x10
[  149.875522]  ret_from_fork_asm+0x1a/0x30
[  149.875538]  </TASK>
[  149.875539] ---[ end trace ]---
```

mm/vmscan.c:4274:39 should refer to `w` in `walk_update_folio()`:

```
[…]
4273                 if (last != folio) { 

4274                         walk_update_folio(walk, last, gen, dirty);
4275
4276                         last = folio;
4277                         dirty = false;
4278                 }
4279
4280                 if (pte_dirty(ptent))
4281                         dirty = true;
4282
4283                 young++;
4284         }
4285
4286         walk_update_folio(walk, last, gen, dirty);
[…]
```


`mm/vmscan.c:4286:37` refers to `dirty` in:

     walk_update_folio(walk, last, gen, dirty);


Kind regards,

Paul

