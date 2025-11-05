Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B13B0CCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11AB18E000D; Wed,  5 Nov 2025 04:05:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A4558E000A; Wed,  5 Nov 2025 04:05:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E848A8E000A; Wed,  5 Nov 2025 04:05:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D75968E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:05:34 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A5AB612B561
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:34 +0000 (UTC)
X-FDA: 84075970188.30.F2FF93B
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 45794120005
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1uXJvNXZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k+qtCPEX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1uXJvNXZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k+qtCPEX;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762333532; a=rsa-sha256;
	cv=none;
	b=d69jF4P/WRGzrnIV0k7BCboRmR/j9JrAZqIUtsymsnOQYecltGJ92ymWJrQcs1DjtBiHH2
	79ynQz61xk45Pev4LckyczNSrC4GrvO1Qc4pWkgKWZuDvQXP6bRZf68cFWagVbXFVFS5BH
	wmfx0cZMeEe7J0ki1XfJXWJ/gd6YkLs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1uXJvNXZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k+qtCPEX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1uXJvNXZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=k+qtCPEX;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762333532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=s7exJ7wPrvcdkgXiFEjvbZXYLs/HVJlgsx8rLBAN5tA=;
	b=Wssr5UcJci0Uhl6+XnAMYiiOlrg99cGlwH7G5+jzYGvjNNC5yf6VdFZ5p186klUtpAyRGS
	PByNAo6vvcQJDRKcJs12o4MyNfcRHwipK2fnyxVsp9CwEg+T3tUWbiafe3ycWelRt7m7Qi
	ex0NEjCXdyjEBr88G1Nks/kTzquUZKo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 93B981F451;
	Wed,  5 Nov 2025 09:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s7exJ7wPrvcdkgXiFEjvbZXYLs/HVJlgsx8rLBAN5tA=;
	b=1uXJvNXZ0oeWJolUamZsclQYWLhgjDV2VIcl2AbOW1bAUFeGvdxMpEVBuNcw4NTnuvG3Aa
	RhKnLdmaTkC4ixvPeVjbewnh9hT25WTqG8WZ1JfvPljMRZeUoPUty2LqHMT0WHor9+R26P
	jkTNLr8+2bVcEk/tU0+/zSgC8wKF9Ig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s7exJ7wPrvcdkgXiFEjvbZXYLs/HVJlgsx8rLBAN5tA=;
	b=k+qtCPEXLrLalvmr4cJJ973ilPbmBHT5tcP6DvcOr1rLdx5y8YfS3QXNGkh9OqHuzFvUCe
	zoE+w0eay0C+A+Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s7exJ7wPrvcdkgXiFEjvbZXYLs/HVJlgsx8rLBAN5tA=;
	b=1uXJvNXZ0oeWJolUamZsclQYWLhgjDV2VIcl2AbOW1bAUFeGvdxMpEVBuNcw4NTnuvG3Aa
	RhKnLdmaTkC4ixvPeVjbewnh9hT25WTqG8WZ1JfvPljMRZeUoPUty2LqHMT0WHor9+R26P
	jkTNLr8+2bVcEk/tU0+/zSgC8wKF9Ig=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=s7exJ7wPrvcdkgXiFEjvbZXYLs/HVJlgsx8rLBAN5tA=;
	b=k+qtCPEXLrLalvmr4cJJ973ilPbmBHT5tcP6DvcOr1rLdx5y8YfS3QXNGkh9OqHuzFvUCe
	zoE+w0eay0C+A+Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6EBB8132DD;
	Wed,  5 Nov 2025 09:05:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tOG2GloTC2lSBAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 05 Nov 2025 09:05:30 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH 0/5] slab: preparatory cleanups before adding sheaves to
 all caches
Date: Wed, 05 Nov 2025 10:05:28 +0100
Message-Id: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAFgTC2kC/x3MTQqAIBBA4avErBM0sr+rRAvRsQbCwiEJxLsnL
 b/FexkYIyHD0mSImIjpChWqbcAeJuwoyFVDJzutlNSCDzQJWdgTTXhuFrqfvB9GJ+fZQc3uiJ7
 ef7lupXzrHx/cYgAAAA==
X-Change-ID: 20251105-sheaves-cleanups-548ff67d099d
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>
X-Mailer: b4 0.14.3
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 45794120005
X-Stat-Signature: iktmsedpmcges87cdq6faazamcmtpq99
X-HE-Tag: 1762333532-523791
X-HE-Meta: U2FsdGVkX19hGFytEQH5xW2gdEsn9JkZ2fC5YYkMjqPLhQM9SXFd48LB8bBTazyVVCz/k7hPpz+4yD64QiH1lBJtbd2BkAy+KOMSHUgNqKBEqIe5CZshFrpXdsOUBiAdIQJ+8ZpaclE76/oqhK5lPeAiiyqCYqlNmhLiml1yi7w+PtziE9R9R9jUdYFli5tIYc0r0QWR2I/8hVRtipr72pQOLf7t+uo0MAyC5Oqj2wU7SwUL349CmupdAcdp61yHpZodEDu03HAJSFkp+f7uk0ze7wEfbhwiuJ41GiuAl0twAtjJdL9j+YdXoCz6v1d9So8AR6RaT/VpUTHnGVz/WO0HjBFE2vKN+R2Xq30MUBmUmaKTe6N0vSmlw3Sx12TXw0SjrdU+u151zIHIX/vjE+3/JQOVshvE3iMJv23whaY9PiRNkTYwo1cLaNZq+7u3mVjS8ygW/jDay2njVAZ7S/BnwkomePVoNRDehKOHjwlNfRS74Btovnhrw+POu5go+G0lJ9BykM6KZztyyMxgnNsq/MHcAnB3ocn/gZob4fEBb3f5kOVjaT6c3f07u+Ngu+obeXj7L+f3rikJgLxA5Pdj8U4PjoL62N9puQW7bwducBMPZBbM+jXwjMCu1ESwB7/tQb1kAWtV5Q8jaDy2ottZ6m3vrPoZvM2o7n97B8g4YlHrH1cvYdRyT1oeSFPVSjmpKz8iH6Eg2TKktX/nBv1fRQ8PpE5h0SfzTBpgTqCgJ87oA71+jRAbWEfkFzDvQ408r+2TMJiZPbFX8Dz26ujGGGM92DJzN753YLuFD7cn7hEjx3bt7wliKiXrOE/QhjZZNat6bXvyyKZEy77wCUZlaYW8XVpJbjNzEQOmHQqqtk4qb0y7Xvz2UYz6+v8zxnjioS8hQ2F6bYv2Hj8BhCdAmH++qv7yelJGr9P7a7F6c4+2DFsk5+TG+UjPwmvoVVEG320LLqDw5ViI35z
 RnG2x7vG
 gNStWOj0sv5MWD/Fbcch/Lsj4+lPhIlfDoDGlIEwDlgW4KdP8OezYxF98+koEVBbUQ+5Nq83Pg+r/wLu/tjTwW7vNPZOpaoH90P3yQUQYPR7Nx4I24qvK4Ms5iynbazqCcYcl+ZHdbJTO/9Imrkn4bASDuByvcTkOwAP4Kr76HfJVGXpmBHbXbZyIAZJ+jSAU2Da71Rrd5prhtQbX2gufqk1RWdVFdnk1BSLPnwN5ZWo3PzQixm3qVSwmy9qzuolv1flAZ3SgbX0znJw3EcCQ1xvfP9aBUOcoOWstqvZLx8IuclB7OlordRDsrS8+8HWWQri7uiUR2d9pS4fe6QMFETM6G0mVGpjL3zPAG4IurfJwzAhrI3pDaU50wQNSwjvb0AbdZ801Mjdc4Mk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These patches are separated from the RFC [1] since that needs more work
and 6.19 would be unrelistic for the whole series at this point. This
subset should be safe to land, improve the codebase on its own and make
the followup smaller.

Patch "slab: make __slab_free() more clear" is a new one based on review
of one of the RFC patches where __slab_free() was found rather tricky.

Git branch: https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/sheaves-cleanups

[1] https://patch.msgid.link/20251023-sheaves-for-all-v1-0-6ffa2c9941c0@suse.cz

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
Vlastimil Babka (5):
      slab: make __slab_free() more clear
      slab: move kfence_alloc() out of internal bulk alloc
      slab: handle pfmemalloc slabs properly with sheaves
      slub: remove CONFIG_SLUB_TINY specific code paths
      slab: prevent recursive kmalloc() in alloc_empty_sheaf()

 include/linux/gfp_types.h |   6 -
 mm/slab.h                 |   2 -
 mm/slub.c                 | 318 ++++++++++++++++++++++++----------------------
 3 files changed, 166 insertions(+), 160 deletions(-)
---
base-commit: 136fe0cba6aca506f116f7cbd41ce1891d17fa85
change-id: 20251105-sheaves-cleanups-548ff67d099d

Best regards,
-- 
Vlastimil Babka <vbabka@suse.cz>


