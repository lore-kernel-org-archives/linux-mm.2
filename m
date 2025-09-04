Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784ECCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 08:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1666B0011; Thu,  4 Sep 2025 04:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA2156B0012; Thu,  4 Sep 2025 04:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B69A36B0022; Thu,  4 Sep 2025 04:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A02AD6B0011
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 04:56:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 315FEBCCB0
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:56:14 +0000 (UTC)
X-FDA: 83850961068.21.399586F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2AE7A100005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:56:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sy5hY5wh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Bf1r7jXn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VGsA9teC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UFMl6h+K;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756976172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=m0ZDa47UqfnYQ0ZbmuSqajhVRJWdZWcH4E32chG0A7M=;
	b=jp6zImyvK/KEYJxIXx59d4QnKkIou8Z3oxPIBtDLnVg/p82RDQKBDbE/vBtFgutn1D/1mc
	M0Xd9utZ5fDf/0V4eDMtzaDWbWQ5bt8Xm5zQIi0qX8jTzct0J+eWkALvcWnKCqj/hNBmRN
	dEJRSr84qRiKETkdHiHWUU+DKqkbe+0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sy5hY5wh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Bf1r7jXn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VGsA9teC;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=UFMl6h+K;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756976172; a=rsa-sha256;
	cv=none;
	b=4pHCzhSMJjtGDBVULppWKMpbeRBzJogaBgto0lrYFOQR5ECY4fnwZIP/CciJlYNsW+mfUl
	CXMTfU3SBuZVvVOyi8d6aFhIAJj3xswfCQI4fVA4p38N5jMgkDi5bPk8ZUd93PODkXWsCD
	ms5Pzf75Kl4WJk5nHBdLbWcjfHSIcL4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 749FF33DB3;
	Thu,  4 Sep 2025 08:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756976170; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=m0ZDa47UqfnYQ0ZbmuSqajhVRJWdZWcH4E32chG0A7M=;
	b=sy5hY5whGhnE+z7dC8cRex9GO4Wgo8yuBp6BJo1uMQZ6q5Aw9x92JgiRgI1svfSFuJdK/8
	zlQJApWkP2yOLGkOBBPAUmbDBm9xKrzUqxo7DgAfsBhsyKrpjKevi5mtgHlf7zpiIn8Gzu
	1k7AWrpYcurli6M1ct1gJf6hpkg+dSU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756976170;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=m0ZDa47UqfnYQ0ZbmuSqajhVRJWdZWcH4E32chG0A7M=;
	b=Bf1r7jXnWJbLEhm+5JmbbTwLTtYyDaT7HRWcfFha6xEo67qcJZQD6MwQTm1lupPBB+nYz7
	o8iUUcqgHzTaxVAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756976169; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=m0ZDa47UqfnYQ0ZbmuSqajhVRJWdZWcH4E32chG0A7M=;
	b=VGsA9teCgiYqgQg4XKdYxx1VwqW3JA5CHsiJJJ83AC02y0IWvlwc6eAD66r08d31bv8uos
	6evPPorgYRtsYu3UrJZCN8eg+EPKDor6zeLSFy+Ny5eA7e9wTiEtVujIFhit8wgO/9P193
	YxS3o66jCV8moTKbz1qfV36qxusqQbY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756976169;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=m0ZDa47UqfnYQ0ZbmuSqajhVRJWdZWcH4E32chG0A7M=;
	b=UFMl6h+KloWwRH225BeEDiyvK7tdlUITS5aXqEyUUtaWZpcW327l0HpOpUgrzJ1ujjamRO
	ulpAaU+DQJRaY7Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6588B13675;
	Thu,  4 Sep 2025 08:56:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RdB8GClUuWhlEQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 04 Sep 2025 08:56:09 +0000
Message-ID: <c15d56f1-b1f9-4ed2-8f20-1d8111ac1115@suse.cz>
Date: Thu, 4 Sep 2025 10:56:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fixes for 6.17-rc5
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@linux.com>, Andrew Morton <akpm@linux-foundation.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2AE7A100005
X-Stat-Signature: w59zbc56iabez57tnjfjgdr8gkm6xygi
X-Rspam-User: 
X-HE-Tag: 1756976171-172750
X-HE-Meta: U2FsdGVkX1/y9AdMnMJyeoXzfBUGV/PkN+GCrmhGlcUhaI01mGBMaI8NSFX+m487D013BfAtodpnsX7C2jVyAhhxCf9SMAghvzCa9QiwkodLnrdQsbFaoeoiB6bV55UPBI75rKECdDI8oFzObtHPR887+UI8iMW0aQLf664pYCjM5S/A/YfOr9Jmlh7tlY8LsYNVeBJkOE8kCQyZblc8TwfzbNDWW0GkgXAmq90pHvnBG2c0HRpEiFGs/FRUvW8KWZBeqP5yMD25cFosSK+yBR2UWPyXiOJCvKUSoaGN6j3qIuoevDh3bBxFJ+U/cvKM4GrjFb2a+zG+SnwSiyhkLaEfItVch79rs8Uh01IepvTAZ2m6c67kTeptjNetolXrvJBG8WcHZXkrn9xGNpHJYZvC+ggRrjl0m5LvfoZBStgXLdardAFsRzF9C/fTVL0qMkB+D65kkVUNLEDwZ1YQxlPuLbYoDky+H5HRGJuA0AFRKDq/5K9Bx0YR1Ij7FUe2il9GNcGEbPPYAuO+9bkbUYiEn0d2CK3erJ6NTEp3z+9qj9/SDX/04Z/npowKqBURW3aFGUIEGBgZWw56pUJHVqI0k8Xj/fdwNWbspHexajtuK3Xhz3gYEMIGlMZNvn+ZBn2vFDINAfss5ktyggSZhsHpcQdxA/5T11moX/Y8/cVs/VKOFk/aG+3XR7NcNCPlrUAZTFahGVgu0/IS0QVufADs2t6XBznLYtcY5lQ0BZ+ry1vpYED99wnsMWnbXqWJ6n+dQWqKgt0Hy7jLc4Y1U08BZ9dLg24K5B9f+xihKVPgH0aE9OZGq0PDNJ48CMIqpoyXp3/wJqlh9DZPmyFz/faP6d2Vz50wziEB1f1L/8rmp4VrRoqlPeRC+V7bM1c1FF/06pHNgcvOyFawcPn4SbJl3wp0c7+aDF7m6FHykUsQgf56iFEEsj/CB04VeRQXBR+capG0ilDglVt8zir
 /opKFmZx
 tMSAa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.17-rc5

Thanks,
Vlastimil

======================================

- Stable fix to make slub_debug code not access invalid pointers in the
  process of reporting issues (Li Qiong)

- Stable fix to make object tracking pass gfp flags to stackdepot to
  avoid deadlock in contexts that can't even wake up kswapd due to
  e.g. timers debugging enabled (yangshiguang)

----------------------------------------------------------------
Li Qiong (1):
      mm/slub: avoid accessing metadata when pointer is invalid in object_err()

yangshiguang (1):
      mm: slub: avoid wake up kswapd in set_track_prepare

 mm/slub.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

