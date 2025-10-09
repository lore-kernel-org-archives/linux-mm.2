Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E143CCD187
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 09:36:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C60F8E0069; Thu,  9 Oct 2025 05:36:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9767B8E0002; Thu,  9 Oct 2025 05:36:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88C288E0069; Thu,  9 Oct 2025 05:36:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 77E768E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 05:36:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FCC7160739
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:36:28 +0000 (UTC)
X-FDA: 83978070456.28.A698EE1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5743840021
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 09:36:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fQIapu8o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nRS35DJy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fQIapu8o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nRS35DJy;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760002586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=quLqhFh6BAHYO6xyyuUWw8Uhuh+9oB0f7ugizjDchjA=;
	b=INwZm9cfwLoC9igj5nDZ0bGk7KTFulJ/40ZgsZdq6LwzWfj5b6iXQCs3PTxhV6ugyjydBM
	LcQ13HhbQ/MB7vDkxXUEaecLvkxB6dCaxcLC9Yv3k3O+ZDwpBY1s5l6/GnMpE1MNPvnTM9
	K5QjpKOSwnmJZa1h3y4gs7VbSxV5kFY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fQIapu8o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nRS35DJy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fQIapu8o;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nRS35DJy;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760002586; a=rsa-sha256;
	cv=none;
	b=hPeFpDV4vQhUzhTtuotnDfSvD5hjObvz1+WHE6M22lNhPjCNtUlwKY0yLel7Kzud1dpA4D
	b+gz76V7n4yBuKa0NrP0h+ANC6gggvd67biU2DE0DzGvbthE1KZgXsE/GYDwJfvsCSR5+z
	oVcBSTe5s6UdK/yjiU6sNSFc41KIywY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D65141F790;
	Thu,  9 Oct 2025 09:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760002581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=quLqhFh6BAHYO6xyyuUWw8Uhuh+9oB0f7ugizjDchjA=;
	b=fQIapu8o4ZNvceociwYQmglMfMWKewusABDYNchRj251QoUXXx8i2cvO4bQR397cgRqjWP
	n/s70wI/lrF0rggxFHFF8vdokyBJLCR5ZTvorhtaIAH9zzalYcCn6GLel2Wb8UpNzoS5pr
	9h5TCpOcQjNpDNLb8UFwND5eW9+F+uQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760002581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=quLqhFh6BAHYO6xyyuUWw8Uhuh+9oB0f7ugizjDchjA=;
	b=nRS35DJy4BA2atq0e1k8XlooMPdf6xhWkLq6ToTp87dQ/FrxDcpo+9DxCyZ2UU2TcUWKD4
	m/LcMsYhlFiVoACg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760002581; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=quLqhFh6BAHYO6xyyuUWw8Uhuh+9oB0f7ugizjDchjA=;
	b=fQIapu8o4ZNvceociwYQmglMfMWKewusABDYNchRj251QoUXXx8i2cvO4bQR397cgRqjWP
	n/s70wI/lrF0rggxFHFF8vdokyBJLCR5ZTvorhtaIAH9zzalYcCn6GLel2Wb8UpNzoS5pr
	9h5TCpOcQjNpDNLb8UFwND5eW9+F+uQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760002581;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=quLqhFh6BAHYO6xyyuUWw8Uhuh+9oB0f7ugizjDchjA=;
	b=nRS35DJy4BA2atq0e1k8XlooMPdf6xhWkLq6ToTp87dQ/FrxDcpo+9DxCyZ2UU2TcUWKD4
	m/LcMsYhlFiVoACg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C2C3213A61;
	Thu,  9 Oct 2025 09:36:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id R2kyLxWC52iVLgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 09 Oct 2025 09:36:21 +0000
Message-ID: <9ec4a43b-d016-40b2-996a-e8aa098c0001@suse.cz>
Date: Thu, 9 Oct 2025 11:36:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fixes for 6.18-rc1
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iujk8g4ys33nae51d4eg59btmsmgr68d
X-Rspamd-Queue-Id: 5743840021
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760002583-844066
X-HE-Meta: U2FsdGVkX1/CKxEnbuvKAz3tyjqMrRwWC44X3xHk4phXLPGzormPgBVkt+1iB5oIceR0MUc1cCrVUDEg2f0kYXMt2xRLWkYDdnVRXVJ6OjrF+GwM4spqZlq1AMJoQnCWVlLK7NCvumk5p7hU7S8dWopTRQQw0eItTijSEkGglhIfFV1A/Zilu5aakxfiPGuPqxYC3dIIgSJLeKqwrcYyM9XK/eNnmS4oHqyZB9K92FnuhAzkR55d9hUUvrKTeGdXUNs+8MpAPux+4VX+d8Qn/b52XW+sssQpftfjXiKRA/cASF1n9ilNfRCxPx5R2+pU4KlgSwJ6UMPTPv/dHtGS8twoDZllTbQLPO7jCH6vEe3la2sB5jq6u5VhmvucgXeEJszrKQiaWeaN8cdBabEcm0VgTGA6PG8BvFUV/KEBrNMzJfPlkHdrsR+CuYX8TbiN1LWRKWTe3YmN2OvLcpiT3nHmpq7uoqNFnsBLMN3yb0hFQd9kMEzKUkPviJNoUEm42O6laAi4/lfem7zF1Vkt7lfKCPhoIWvJrdZdlmafDSV5b86RRWDU2Yz5x1nDrIqyZE8B/NFec2qiJnPRMdDbz71pSR1M9CO39z+q6A9amURUUKrynH1Z4rKhGEvW19GW6yAtbb738d+9u9OQROntXuDLQud0r69fiC4ZP6mi3ir+GMRWEBzSoIuViyR5H57o7aXiyHqB7L1n4iSzWekhTS9Ieu2MApJwucznSHqPM/k+1AoC1mEDnT/DUaR0FxAs1SS+sttMBxwEHyFAEe/RigWEjXZP6rCgbYsxt9eyll7pfvHyv2WPrFX8xSho0UWjllAPo+sNiE1WKDUAtBmLPXNLXX1xRCKfI9txmJrsughnTEsdtTFpz85dAjP0jbbvFM9zdJAz9JkTAtJ8bSuz3xRRnq9+kBYWSi3uh8K341jh1IhQG6oIGu/LmHbQTSnjVLf3HJSONu8lzQki2+J
 KOEFqPSW
 pDDU6PE6On1ebPYgtMmKooZr5CcSmtRBb7MbLdNavuYauz9PHtQMUFGQ/hyI3P0JZ8lmPxMLTBYU3dHclzTRr4Gw150HcGDngHbJLkFEgNq3t/uNtrkif9ABShchQRNinG5YP0Al0KJBBatJMBpbQqarvhhyhUKhIBRKdd6c+jrI6pwneL07CKSh92sB4yKk+uyB1GeKPR2lebszRQhGuqBcqydmLAaVqUGlYEOdMGBEJnTzljbb/C/MGKq6Jk07SPWCI6rQmGdJp5c/gNaYd076RX79SPxk28MKOeoc8iJkvb8jAFz9VQ5wgow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc1

Thanks,
Vlastimil

======================================

* Fixes for several corner cases in error paths and debugging options,
  related to the new kmalloc_nolock() functionality (Kuniyuki Iwashima,
  Ran Xiaokai)

----------------------------------------------------------------
Kuniyuki Iwashima (1):
      slub: Don't call lockdep_unregister_key() for immature kmem_cache.

Ran Xiaokai (2):
      slab: Add allow_spin check to eliminate kmemleak warnings
      slab: Fix using this_cpu_ptr() in preemptible context

 mm/slub.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

