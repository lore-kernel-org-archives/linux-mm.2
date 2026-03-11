Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF0B51049526
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 09:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DFE2C6B0005; Wed, 11 Mar 2026 05:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA7D16B0089; Wed, 11 Mar 2026 05:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3B06B008A; Wed, 11 Mar 2026 05:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A4BFC6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:56:24 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 482A5160790
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:56:24 +0000 (UTC)
X-FDA: 84533327088.13.8473498
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf23.hostedemail.com (Postfix) with ESMTP id 18A9814000A
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 09:56:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L4gJM2KD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FIfZdxZL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L4gJM2KD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FIfZdxZL;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773222982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7bzVvzdWc5ep0b7yb3gm0vq2rmlvwDapRWBJqvHgS8=;
	b=DJ2N9cllc9Rux1Srz2SRAA0rAwBilG4yNsCdTk/r+SrDcFfI6gQ6wlic6EHtC5e4tFOjLe
	147DTlKTIRvyhygzmtlszpV6cLwG8wMqHfumLWzqueNKXvL7UN/yr698fTUXpu+M2ELJLc
	xkt5Jida0liTuzLKMLHBAdVEL15jBgo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L4gJM2KD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FIfZdxZL;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=L4gJM2KD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FIfZdxZL;
	spf=pass (imf23.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773222982; a=rsa-sha256;
	cv=none;
	b=NvcaJ+NhfpKDiZYaHJsAXx9uxoW8G+mPHMePTAUYLWiDAzaLMhL+Sy+Horbbc3iF/vpBVc
	qBoyDuxk4hHK6mNW0+IowqU9AaljzfEUzu/EIR5vgxVmGQeLJzqW8hDmE6erhGpbGoK3fd
	uVbgT6ypAP6o31W8kMnXTqj0NGzIBGM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8B0584D1F6;
	Wed, 11 Mar 2026 09:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773222980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7bzVvzdWc5ep0b7yb3gm0vq2rmlvwDapRWBJqvHgS8=;
	b=L4gJM2KDJO76PDAnMK9hmf9Wqfxee8YFW2bhh5aGGFmxtCvjM6ocknSK/iRPvJ+93SYNB8
	Pth8eua16VngWk5Qza2xmwQJFWAXcxlvqknJLK9zfAgcEGjWdhMFB286j2lN20EIKKn69B
	KQQvzs9bX49SAqA7ZqZUPRzyLN4FASI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773222980;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7bzVvzdWc5ep0b7yb3gm0vq2rmlvwDapRWBJqvHgS8=;
	b=FIfZdxZLuee18ApOiH2YZ2mTWgPzOWVvmAEg4X+kpJiWY6LEPoC87Akx4tsa63okNSh3dc
	nkwA6zOKtQ5z7sBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773222980; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7bzVvzdWc5ep0b7yb3gm0vq2rmlvwDapRWBJqvHgS8=;
	b=L4gJM2KDJO76PDAnMK9hmf9Wqfxee8YFW2bhh5aGGFmxtCvjM6ocknSK/iRPvJ+93SYNB8
	Pth8eua16VngWk5Qza2xmwQJFWAXcxlvqknJLK9zfAgcEGjWdhMFB286j2lN20EIKKn69B
	KQQvzs9bX49SAqA7ZqZUPRzyLN4FASI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773222980;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N7bzVvzdWc5ep0b7yb3gm0vq2rmlvwDapRWBJqvHgS8=;
	b=FIfZdxZLuee18ApOiH2YZ2mTWgPzOWVvmAEg4X+kpJiWY6LEPoC87Akx4tsa63okNSh3dc
	nkwA6zOKtQ5z7sBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8FFE43F963;
	Wed, 11 Mar 2026 09:56:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EK7wH0M8sWlzcgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 11 Mar 2026 09:56:19 +0000
Date: Wed, 11 Mar 2026 09:56:17 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Anthony Yznaga <anthony.yznaga@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, jannh@google.com, Jason@zx2c4.com, shuah@kernel.org
Subject: Re: [PATCH v2 2/2] selftests/mm: verify droppable mappings cannot be
 locked
Message-ID: <ci3s76cywghceblvsjccphbmidr4yop37dupcj6jyccqzipzwy@4rk6gdjq2gum>
References: <20260310155821.17869-1-anthony.yznaga@oracle.com>
 <20260310155821.17869-2-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310155821.17869-2-anthony.yznaga@oracle.com>
X-Stat-Signature: hnek1rbaadrgq796w9zkaoe1abejuhuy
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 18A9814000A
X-HE-Tag: 1773222981-552543
X-HE-Meta: U2FsdGVkX18wSZj193SVP1Q3FP3P2AQBL0b/ODZrgJwZGH4cA1HdDqvUeM77gN5HK+E6ICOF0q2faKJTTR11Uq6yAtbfYG1E/Ltlt2Gvaas39YwB+F9gHjGr0vAfIuKBc/OrSfC8aPT+6ocV1zdrJqvn9mSEtEoP10WUgvp56H3vZPQTLDvlB2JRbWhzAIPvmwZRGY4HUNr5msgzZ/Zs9Vr07NQI1xYSJ16PO5TtQDghMQBgEMH713WA+DxYw8YltnC/uheTUmFp18XxX2Vns/0xeb4guARDV9Q4s1wd8WUU0hwWN7Pk2zRVyrrQIfK9v6PyLirLpX3EnDN3g++MMaH6AGYQ/C2GxRU2ITw/e34vwq2iWM3+8Qzl9KakwHMjqjrroBSksImEQNAGVbjbPIkYAvpxCo9HU7jBZQI6lXTYuRneH+qNrrCD4qzR+VtLi9JOCgF7rF4sDY63CW1spYJParmRLkh5p40bt1FYpsEYs/64EeEkE5Gf9XknscA1PNxQFPJQv/OWn8ZMjcVPYqQYiYwwtB+LgClbAfUY5tONoTHILIqsZufd+v0I0Jd2QZwzcaAnd66yYAbFgch8dHEeKSePiFJqXPACFsUIiQ5Ooep6Z0TfeR2qI2fLNTsvnRoFTFBl8oAI9CIR7UHCHqhYmkvvdeNw46gO1WSMFtL9DgYk1Cap+X1ErWRom4WukcbpsBwwCTxakZQbdwRRlfHmh28bIvhB1B8azbTid3ESzXTbyszpofHIPk42mdsmhBRQ6DzyWhpT9RmavGHVI8tUyEpn7BfyYe9rB6iZ+HYyUfUGJQEHWciQEo402rydixwzmvSY6Nil1HzUSaPumNnKSyzV4LVUGu+/V4M2AdyPMGR/NLjc+hLFAasQy9OcUfnoLUGuQncfw4P9IZE87fvaXfk8gvj8Zodg7pZqqRFEZcHv5m7r4f6HRWV44SFHnQ2TqesorrIJ1FkzvDg
 zR92dRbO
 AfutGbv1XimPfslWbHwBq4c4uNomeVoSbp8fy97ah9Hm0rp0GkFqzo17XBPVkltWHkIwpCpCeENxBMzS8wBugLbyxAbeCx3yo+eLLG/VO38AGjFKTi7joI17am+kU/IYowtUMz5joZsgdw6VzQi7WD5R/f38LcIY3IX6DxMdUN6JRhWKNVk14a7UrKNChJQeqBvISQ0gHggh7fB6F7VZZJso8N+9IQ7ge6QL4yIXwMzN/BU+Rt4VuwHy0FOQRiTGEYMzs3iIf5/tAobT6a2FgeAU0l5OOVrVeBa+J9DSXiVeeB2MiwVZfOTK91wxzlWKMxMnasyGnnxIIZK0Q1qsQj5sEenk2Xl++e44dhKqbFGv/2O4qLb4ABdUKiRjKOqgYGsYtDsmC+qdJdUyzd/mqyc4+6EUUgUAAlOuN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 08:58:21AM -0700, Anthony Yznaga wrote:
> Verify that a mapping created with MAP_DROPPABLE cannot be locked
> via mlock(), and that it will not be locked if it's created after
> mlockall(MCL_FUTURE).
> 
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

