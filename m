Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEDDCD2CE17
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 10:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F3EF6B0006; Wed, 10 Dec 2025 05:11:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4EF6B0007; Wed, 10 Dec 2025 05:11:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7936B6B0008; Wed, 10 Dec 2025 05:11:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6A3776B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 05:11:13 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C79B058F70
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 10:11:12 +0000 (UTC)
X-FDA: 84203143584.13.90841E1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 67FEA100002
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 10:11:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N2SZ3U5u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YeNqZVff;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N2SZ3U5u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YeNqZVff;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765361470; a=rsa-sha256;
	cv=none;
	b=JU56FvcT8tuxheVkIhFKQMtzUw9N2QLzT4GIbaVGyfbssQkGS6mxTjcs/6GWzr9phSJAbW
	0KTCGfKtQqycvW7+zB7RzoenHr+eUH+oqxPOkUday9Fte10c0hlBhRIuJ8oUQfV4dvWxaa
	mLcwKxFJuSNJyabXTcWkc0VO/8pzWOM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N2SZ3U5u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YeNqZVff;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=N2SZ3U5u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YeNqZVff;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765361470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dRaMpxzgDBt9RP9khKJl8i23dcxtS8Mm1SO47HiZZRA=;
	b=ibItDjN60QKHsrf3Xv22NulvcfKfp41Ij1wcmkFZ9CYEHftAo4DQtQTs3qLBQFLmURgEjy
	DAXTtpGzEpiaY3/rEVefFMXZXaXbgMCLRTp2CCC7YtVZuqkpATTo/SbKsr36HpeYkq3V5o
	qbcIvRwOckd0b9El7aY8kv+fZTK4gTM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A92CA5BD21;
	Wed, 10 Dec 2025 10:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765361468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=dRaMpxzgDBt9RP9khKJl8i23dcxtS8Mm1SO47HiZZRA=;
	b=N2SZ3U5uChrusF/whFlQf6VS2j4/izBCJPhZ3Wx9TDWX4d0JmDGQgOjdJum0STZ3A9nPPm
	vddkxrVAep8Sc2NQIoM0l9zGl/Dz6yc4f14ibeSAK1txW1gKPVDfpVImZ3d8cFrokiLFB7
	Riw+8fnwGqJ7XwTdCLMp9IxtErgp7tQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765361468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=dRaMpxzgDBt9RP9khKJl8i23dcxtS8Mm1SO47HiZZRA=;
	b=YeNqZVfffuX8up13yEQb/t29ICqxlZCDoJF7OBV4Cz5GhDwa1cthlEbcai5jn4OX0SqFax
	zaoqLCAOhGJPLzDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765361468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=dRaMpxzgDBt9RP9khKJl8i23dcxtS8Mm1SO47HiZZRA=;
	b=N2SZ3U5uChrusF/whFlQf6VS2j4/izBCJPhZ3Wx9TDWX4d0JmDGQgOjdJum0STZ3A9nPPm
	vddkxrVAep8Sc2NQIoM0l9zGl/Dz6yc4f14ibeSAK1txW1gKPVDfpVImZ3d8cFrokiLFB7
	Riw+8fnwGqJ7XwTdCLMp9IxtErgp7tQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765361468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=dRaMpxzgDBt9RP9khKJl8i23dcxtS8Mm1SO47HiZZRA=;
	b=YeNqZVfffuX8up13yEQb/t29ICqxlZCDoJF7OBV4Cz5GhDwa1cthlEbcai5jn4OX0SqFax
	zaoqLCAOhGJPLzDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 95E0F3EA63;
	Wed, 10 Dec 2025 10:11:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FnBBJDxHOWkedwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 10 Dec 2025 10:11:08 +0000
Message-ID: <80e63358-3016-4208-bfc5-242f201d4f94@suse.cz>
Date: Wed, 10 Dec 2025 11:11:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fix for 6.19-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 67FEA100002
X-Rspamd-Server: rspam10
X-Stat-Signature: 94yf6gx3gqkt5por5oefttprrwfonxa5
X-HE-Tag: 1765361470-530619
X-HE-Meta: U2FsdGVkX18Z6lLyPGcLddqiejoiFyTYVD/WMAH/VbD3+JJjC3YCUyftIG8CZXG34XNr6xqXJDD4jHv5EE5eGiCtEiAoVkIArRlUIYdvJARVol2F6w6aU1kYkBm5b5LKogS1h2hC2Myhj8tbahFGIn7/CkdVp9C33K7ZuNc/RIzEUfpclX4bbQLx/oYQcuapkfgjtd10bIph0ISgp2BpKjJq15Ca/gNniVPhJl7wfBFqNG9/ocOP/W/yLvZPW+qeped7hue59GpIHsvd6iOXbULfCj/KA7xL9dg+xK2M/2XAaL4X0dD1PinSzH83KlZmVPGHYA5/kVaZ1qpXZnfKgcBpEdrFfTjYAa/a/VTPHKofVG9h3r2Mzyf9aBJqVHOBY0+p8XO7DYv7efSe6vve0/4H92w21Zx+VbkHfIaEzVn4+03NsnTYFgUfTYHPkObbtwcA+6CNzDbH9SIv3APvUH0go7V1sGCup9NfeN+oKDLCl77MjaW7ZRl04n6uxdemgxYGRcZ19ah+ZMkGy3EXm4rzzR7Joe0wma9Wi8vMYJ8W0mkdfhouguqRCAO20PVMgei4UqdtLoSYEaJghbAhaUaEbJg8uFi0qU2d6YQgqW9KIC7WdbbPfTOwg9uB4C1KF3TpvqaNfGUTGZyGcsSOMs7gWTQSKUoE0usPhKU2QiXg3QmW383qHPpjaGia1Zntzab4U+hdNNeurlTJE3OVMvBTRo01b+8lo+8T8tVB/sIVOsFqA7TaYVSLwXY8zdsNAL5KnXF72uxUj+o/4i8UZ4nzG/VdxQ7FBxqL+VM1AgaIOV82o68Y8f2FrzRs09HfXJOEs+tSo+dIIkNiJkZoFE6OcdaYvfjON+hYG+Vgfklp6/8RVoMrk1zHudF52EbAjnjhNtMl8FOC3XtOeRhejYsstfLXKyjsytml7+YRhvED+BO24BoDmop9Lvou8xeHS8qMGLObeOuYRwnHA4A
 fftOvXlA
 j5FULmO9mLDEyWaQkq6eV8SRUPwWfQdYAJqrcX5IM4XaiCfV7C/EO+MY4Q6F6ieEFv+BP8psajArtbziUMAr56OXlFE1ewi/ECiMYd0SxjVKQFZRKJqUyrClB8JdxPoDGcRMSV9mUdJW4Tb1ON6+IFfSIU7cKeZ5cXcAa/v8F0y8C/Mvu4sxxhZbACNvcpGoil2Clb6fP3VHIFCGw01Y44XZKXu3YH6GCnkVgsbaFtwqUHrJ8XncU4X2IsMOnj9kdJLqafGOhJtrhzyNc/ktDZ+8zmZP0D6EqPxAK2JEHp/ryuJrmxjAR+/lC5caFYALKy6m6ho7SjIFlwyvi5Jn6LxW3aP/J0Gc7I2ou
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the slab fix from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc1

Fixing this perf regression in rc1 should save time for people integration-
testing new code on top of it.

Thanks,
Vlastimil

======================================

- A stable fix for performance regression in tests that perform
  kmem_cache_destroy() a lot, due to unnecessarily wide scope
  of kvfree_rcu_barrier(). (Harry Yoo)

----------------------------------------------------------------

The following changes since commit b687034b1a4d85333ced0fe07f67b17276cccdc8:

  Merge tag 'slab-for-6.19' of git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab (2025-12-03 11:53:47 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc1

for you to fetch changes up to 0f35040de59371ad542b915d7b91176c9910dadc:

  mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction (2025-12-07 18:09:54 +0100)

----------------------------------------------------------------
Harry Yoo (1):
      mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction

 include/linux/slab.h |  7 +++++++
 mm/slab.h            |  1 +
 mm/slab_common.c     | 52 +++++++++++++++++++++++++++++++++++--------------
 mm/slub.c            | 55 ++++++++++++++++++++++++++++------------------------
 4 files changed, 75 insertions(+), 40 deletions(-)

