Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDD8ECD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 18:31:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3B5A8E0007; Thu, 13 Nov 2025 13:31:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBD28E0002; Thu, 13 Nov 2025 13:31:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4198E0007; Thu, 13 Nov 2025 13:31:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B30F88E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 13:31:17 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E2DE12E9C7
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:31:17 +0000 (UTC)
X-FDA: 84106426194.06.DB5AC9F
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id DC8C1180009
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 18:31:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OqYwJzQ8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nIrwapuh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iZTpTG3t;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Ys3a/Jn1";
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763058675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mqo3HW2K7b9s9SB1ThItRPXoJR+FPNGVcSNqKObf4iI=;
	b=ofP7bvXy5VltCVtWSM6kYqvd62irvjmrOegXF5o6u4mlyxTye3BDHjEtRtobzXJI5gQXMI
	xwrNcb1DN+drr2LRiXUcSNHn3VAB6nBH+3GwmTVi3L47bp/VkRd82MksyZvE48MQYqr/o1
	DGiOGM8lmar1sGwytTb+BpHprbz4PU8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=OqYwJzQ8;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nIrwapuh;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=iZTpTG3t;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Ys3a/Jn1";
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763058675; a=rsa-sha256;
	cv=none;
	b=eRSpZh7h5IehP8+AE0UmgKHv+FjkCpApsg52WH8mRHp4SUbtSIlCEZVBruow6Z5DIH1Meu
	8Fj6bJ0MH4/8/Vsee3C9V3t52jELmFu9tRONzd0o6jqoPS7dTvQzyGa/Er9EY02jxMk/ph
	zfFeoQ/QTCsiqlYOCPaa8kXfsltCLgg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id E5E992116E;
	Thu, 13 Nov 2025 18:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763058673; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=mqo3HW2K7b9s9SB1ThItRPXoJR+FPNGVcSNqKObf4iI=;
	b=OqYwJzQ8hzZpe99OMVLPxbqFRz5NX63exN4dF+LEW0A+mtF9g8GwfKkAMIl6zGYNCE4L6v
	8BEp2QIqxdGTSnOJBQQbxtziNQBHQKv/f4BPu8aAT7b8sL58TlSy7WtENQQIdeMXGmwzCI
	G4/DK+rcJw4F5L6PKBTmrg+R73E9sLs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763058673;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=mqo3HW2K7b9s9SB1ThItRPXoJR+FPNGVcSNqKObf4iI=;
	b=nIrwapuhRQoF+M5ujD7ROtJuOKsFifjKiVnX0AUlZWHnDLZDm2xksy0KRRLihcEkldRkc4
	S1OqfZYPEDhB3JDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763058672; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=mqo3HW2K7b9s9SB1ThItRPXoJR+FPNGVcSNqKObf4iI=;
	b=iZTpTG3tQpv8D/dtd6snSnBvJ5/s+UZsVQ4WDOm9WxhB6IvzbCGwCDpHdgH6/BpGmtr/jx
	vZPg90hGMZy3022dxOFv1WdmenzkRINw1HOcv6FcijlShjXlHWTd/sUonlIc/blu6ddqRw
	bYCsr0/XnPGBh8syA0vYl07lpY4zVgw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763058672;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=mqo3HW2K7b9s9SB1ThItRPXoJR+FPNGVcSNqKObf4iI=;
	b=Ys3a/Jn1l66wRy3qzmAkPcWqCv2g5gwOtJWVb8QJAKItFybp8ep0W9h7Q4cbWRpJfDbEry
	8r5kSFoUQrKmBNDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D12DC3EA61;
	Thu, 13 Nov 2025 18:31:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id q8u3MvAjFmmpEQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 13 Nov 2025 18:31:12 +0000
Message-ID: <4e7cd56d-0696-4c73-af65-ef86862cdf87@suse.cz>
Date: Thu, 13 Nov 2025 19:31:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fix for 6.18-rc6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <djwong@kernel.org>,
 Tytus Rogalewski <tytanick@gmail.com>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC8C1180009
X-Stat-Signature: muzx5ntc6u9s5o1g1ifogcx6yec9th7u
X-Rspam-User: 
X-HE-Tag: 1763058674-68628
X-HE-Meta: U2FsdGVkX1+K3okDMoxDVaNgRohN4BM9O3k9lhjXmvz3ZpU3F+B4f50nt+IkLtuYoJJj53pg6Jhy/Cy/4Xx0WFJGctDmWqFHzn/rtR4c70hDKoVVMUsQ4rtU1M1ZSmqApFFKDq0YwRgxQRwXsdrysc2dCkBzosjSYUWIBqSytywqDYGaZv0zZ53c7EJh6vlPpgUeUdoIrgNGpgA92ofC7a1vQsX5q7GdNtAnO0e/ZhqagAyPDQCe0wvSoYxuBS5JASskjSNzQR2D5bRreBrH1Syv1pcA35OIBQBNwHE2zvYwtOC/m4XP6SCXEgmIxLZ1GWmZcVLGSsUHyp5cV+qurXWlh9L1sXuVSQcQYDqvu9nEmyZTEuQZoIopJvYBWsSWgulcorWJB19i+nBbsfm4um6DWX0e/IkjKW9B5sBZ0aToJH9eJA531aNKPsLyidVn1A0LR4OO2AT+I5piJqVJmK9pGPPnkTlp36U8jBlZjVNLBEmd72r+wMXtn+VVPae6DCI7Gm6JGa+yw0vGTRfAgc1gjQKW4hDIlpduuN0gxt5bHdU5NhalrC0VdTezfHmoksap+x/cVtzl3Y7wZOqn3wGC7o9dkHuVSGEJZPQkIfc5tv1YMUkxdh0ZVAFKnn80twwWCl7lo6drtXK7uadfUYqGLI6K6pDjlKKkMOJTxrTdiIfplaKjlOwsk9+4N7YSlbXYSYKXogcDFyQ9+fqnE9JeYCf6uWddpdNPkFwXw8z1Xq05U5ndJQHdyqxiwGBx0V6YPJkAB8C4DNaEpYvTovOxqTt0xKPIP2koN6kg7FNcZ1ismZQa1Cc4QhoOyBfqpnk5Bg6mrfWxdFP/eXn9wIGsBOfOsg+XXl56SRTzAUQPpVV5NWtDjoO01Cnej9U4yGMSVkmp7UNgqeOBGj+qqSU4DEHa2zKYyTtqvjxY9ckSKspaMQucmVOY0OwNmBeq4q5QNbahKZ3NJ6PXtmd
 t3ILRxID
 hhaw98R22CYC2ZvazAryuWW7mv2VywGeFWMrpNjILMdlHrFIQAOFNy3bRFZDx6te2dH/U2RJRDJhBDyySo1eKaJhyPzPJ9VgVC5d8HPBqPoeFBFXmGwZ4HjtGaU5zJpMTbxgkBCQbVrsVCrSGW6s1tT9LAsFE+i+v0n25rzJ2lM1P9ozeGOZZHnlL7lZ2ThcHEq9eWWeH7SG+0dHP+bT0ioONWN7CH6mIoYJKXfSNX/2gxtKu0SSuyM1WJVCqFy8kxufpFRUwWIHQ9q2H6Br5NYjyU95kj8zLcxc2GurgPib7VX706znOWn6av97TaNi16zAslaMLvtR0VFlw6KWWwzyh6NyL+RyzVre6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc6

Thanks,
Vlastimil

======================================

* Fix memory leak of objects from remote NUMA node when bulk freeing to a
  cache with sheaves (Harry Yoo)

----------------------------------------------------------------
Harry Yoo (1):
      mm/slub: fix memory leak in free_to_pcs_bulk()

 mm/slub.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

