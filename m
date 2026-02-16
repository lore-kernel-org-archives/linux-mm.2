Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1B5BE81A44
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E6E76B0088; Mon, 16 Feb 2026 11:50:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E6A6B0089; Mon, 16 Feb 2026 11:50:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 037E26B008A; Mon, 16 Feb 2026 11:50:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E05B46B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:50:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7D9271B558D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:50:57 +0000 (UTC)
X-FDA: 84450909354.09.917D1E1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4F7CF14000D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:50:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E2vmDcAU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SLai065L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E2vmDcAU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SLai065L;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771260655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=TKrAisxLufljEbCPcuYkp4gIN68IUdPRAOJEf+VlEiE=;
	b=YjhZePCoZTwombX9tlcfSTao4vFomPjcHwRLfz1WPNKKtoAY9JIeYRdSLNjqCLLLBkZjR6
	KxHkkfHJGFVkO+8I4r3neClHZRVHsaZ/aD3v3rimMavrzaWKJCrZaWOmxvo9ArdM3H7+LM
	IkeWy7qYQZTNQn0tAIOxd4pNKQw4woo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771260655; a=rsa-sha256;
	cv=none;
	b=C8aYjCrfYfzvSXGzIYkqQM/BW1a/NIDNQXhXnkxserxqthAGE1EWinByp0USN2YuefUBF1
	xNDWzIyPdLRIG+G60bWuQnWTN+cGgt5Z5aetyoCK9mguSwKaJMRY19AtogU7vPHpP3Kbfx
	QTVRpTdYmOhqS9dmKedRjoPO9iMV/gA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E2vmDcAU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SLai065L;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E2vmDcAU;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=SLai065L;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A742F5BCF0;
	Mon, 16 Feb 2026 16:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771260653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=TKrAisxLufljEbCPcuYkp4gIN68IUdPRAOJEf+VlEiE=;
	b=E2vmDcAU0GW9xPHgIg4qxOjazqwQV8IjNwffzhsq6zTKtESM6i10QZvYc2GZeSM9ycOoO/
	ny9GKnvVXg9K0lFhWEkRwRANZXUV+RGW4MOExcqoe8wQidlFqpaEfIJh8b4RZ0srEMTjvZ
	WWngoGaBu1tsWAzYYkVVR13iSeltgS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771260653;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=TKrAisxLufljEbCPcuYkp4gIN68IUdPRAOJEf+VlEiE=;
	b=SLai065L0glksYkNmArXR10XzvsG9B/IDCEnZBlTiBW3Zn3YMyLeGJeteFSiFUv69Crw0r
	6nyeTZqvUUIXbpCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1771260653; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=TKrAisxLufljEbCPcuYkp4gIN68IUdPRAOJEf+VlEiE=;
	b=E2vmDcAU0GW9xPHgIg4qxOjazqwQV8IjNwffzhsq6zTKtESM6i10QZvYc2GZeSM9ycOoO/
	ny9GKnvVXg9K0lFhWEkRwRANZXUV+RGW4MOExcqoe8wQidlFqpaEfIJh8b4RZ0srEMTjvZ
	WWngoGaBu1tsWAzYYkVVR13iSeltgS0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1771260653;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=TKrAisxLufljEbCPcuYkp4gIN68IUdPRAOJEf+VlEiE=;
	b=SLai065L0glksYkNmArXR10XzvsG9B/IDCEnZBlTiBW3Zn3YMyLeGJeteFSiFUv69Crw0r
	6nyeTZqvUUIXbpCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 703583EA62;
	Mon, 16 Feb 2026 16:50:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2RblGu1Kk2lVPQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 16 Feb 2026 16:50:53 +0000
Message-ID: <0c8f9910-1b4f-4a8c-846e-397f328662ae@suse.cz>
Date: Mon, 16 Feb 2026 17:50:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab updates for 7.0 part 2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Hao Li <hao.li@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4F7CF14000D
X-Stat-Signature: 4merq64au1df9ipqt35xfa1hq1zium1p
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771260655-662202
X-HE-Meta: U2FsdGVkX190dNFekFIEtY25ooDb332WnM9r8OUkZNblLXA6WqY82HuBCQypgFI7NPRzzTbuQlsYU/AToT/OBqhwapgwoZeYBSbgY2gVVk+9FihfTPocoalfYILh4RpgJob5Uong3Lnw6O5LODgrUoZ4ERsAYEgmhOuM2SLiG/PyegmileYCsq6Q30+cevSt2HdVCxhYuPVVvvxaKemcR1mOFe+YwWkpJHOmvZHjHVg4aSuCJDq3Y8s9ZXkuxOKKTcJ7cJUi7IT5pbeO+xLAcc49S7dvaR3rIEvsED1mILAlPFZwt7N16MoKUyyLwmOWTMSRs/lZyny3gwrog1Kp7s8PF8f1gFovrO34ESQ6pBYMw79RIXo6atYDG340fwp42vVVjTwksVtphitEGbcUzXOfON5XturpRHQwH1gKu7ZkkfbMvJZhmORQjspFCR1eun54BhBe8YPXo8eseIig4bxqo6MP4JGtgTiP+OTAzzAqq1JCErDxPV0bPgZu1Hpr3kKDcHAk76Nt12v0Rdw4TOzH3b6ltubDWuWyOa2OBmqwZph3fGdpWpDfOzjYrz5DoJfEkJmw2M3YMgZYSC0X0ed76qg/vBQjOJ730D6LMt2dg0Cc23e1uEpMynMm7SNUodZezcdBB9Rj2NK3x2Hxl4oa1siZbB/V/yRM6SXG+DdyfyOy9btEHcAoQjAx5OviRj8VFnEufdz/lt4ea9BvVnjnorzQ37IckKCNUVIZtMdsPuyTtt8LAiwx96HYtU8Wv7bdRp4T04+jG2bZVKG/iP503Z2EK4W/cmZ+sfNeQqmMPfGfBEA7vUsJuGySR7skiEZpoAyVeyEIfV93UL10+fzILroEgw2pMgLfzaLCmXsm2triFmtuD0eWSliHSgh41ffQ7VGzDmaw/3Gs9O9MiO0N6LlW5AOpPO0qY2OqezCFddi68jpOBd24ys2pDj/vDPFNdhGjhsdDuXxoZAv
 8TJSDW3r
 Hpz7x
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab updates from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-part2

There are two stable fixes for kmalloc_nolock() corner cases. The other two
patches are lifting a significant limitation of kmalloc_nolock() so that
kfree_rcu() can be used with it, and will allow bpf to start using this [1].

However they only went to -next a week ago so I want to be clear about it,
as I know it should have been there earlier for a non-strictly-fix changes.

[1] https://lore.kernel.org/all/CAADnVQ%2Bq3QPqNdV3MuysQJQgxSS4g6CV%2BVzN2%3DUqCPHw7xq%3DSQ@mail.gmail.com/

Thanks,
Vlastimil

======================================

- Two stable fixes for kmalloc_nolock() usage from NMI context (Harry Yoo)

- Allow kmalloc_nolock() allocations to be freed with kfree() and thus
  also kfree_rcu() and simplify slabobj_ext handling - we no longer need to
  track how it was allocated to use the matching freeing function (Harry
  Yoo)

----------------------------------------------------------------
The following changes since commit 815c8e35511d0b9a214e9f644983fe477af9d5cb:

  Merge branch 'slab/for-7.0/sheaves' into slab/for-next (2026-02-10 09:10:00 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-part2

for you to fetch changes up to 27125df9a5d3b4cfd03bce3a8ec405a368cc9aae:

  mm/slab: drop the OBJEXTS_NOSPIN_ALLOC flag from enum objext_flags (2026-02-10 11:39:30 +0100)

----------------------------------------------------------------
slab updates for 7.0 part2

----------------------------------------------------------------
Harry Yoo (4):
      mm/slab: do not access current->mems_allowed_seq if !allow_spin
      mm/slab: use prandom if !allow_spin
      mm/slab: allow freeing kmalloc_nolock()'d objects using kfree[_rcu]()
      mm/slab: drop the OBJEXTS_NOSPIN_ALLOC flag from enum objext_flags

 include/linux/memcontrol.h |  3 +-
 include/linux/rcupdate.h   |  4 +--
 mm/kmemleak.c              | 22 ++++++-------
 mm/slub.c                  | 80 ++++++++++++++++++++++++++++++++++++----------
 4 files changed, 76 insertions(+), 33 deletions(-)

