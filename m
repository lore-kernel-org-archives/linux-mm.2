Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE979606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=asz4x0W2;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ldxsGAVS;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=asz4x0W2;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ldxsGAVS
Received: by kanga.kvack.org (Postfix)
	id 1F4A76B06C9; Tue, 24 Nov 2026 08:13:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5C36B06CB; Tue, 24 Nov 2026 08:13:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BC2C6B06CC; Tue, 24 Nov 2026 08:13:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E42F06B06C9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:13:35 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA0F9A0C1D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:13:34 +0000 (UTC)
X-FDA: 85470054348.28.5D061F6
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf09.hostedemail.com (Postfix) with ESMTP id DB3E114000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:13:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=asz4x0W2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ldxsGAVS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=asz4x0W2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ldxsGAVS;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795526013;
	b=sjNj2Zrg2yIUStuk0VGbCcI/jJ2AZXEkk/zq8FNs2gVR7+G4gFSMIN8tlHmhD3YT3/M//i
	gVFWrAj4rsDaCozghT3J5kApz+XKHmbXmynMG4Cq8ta3tgisi8vjWj5V3L6dCLI1L/6NJx
	fsGQdZ2Ya2O78blbg2GPP4q87M3KA2s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795526013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R1D/oFBUDgIwZtTzD4NEUWHSoJdez4vEQgyX5LIiBZE=;
	b=3ncM+ImEKKohZLnEixKBGV0HxVwrmW6lQpYdpMFLFU5edAoziWu5Atf6tZnDz8mLjBDpvo
	vnntD866nPMVuEYFmXZwExeTpcLbyOVYTjZuK1OgDYaGcG8qSIWjs7pXZWde4Uwd09lhmT
	t8APUPcFf1Xguoh8IVdr879QY6WwQAU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=asz4x0W2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ldxsGAVS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=asz4x0W2;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ldxsGAVS;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf09.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 896881F7BA;
	Tue, 24 Nov 2026 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795526011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R1D/oFBUDgIwZtTzD4NEUWHSoJdez4vEQgyX5LIiBZE=;
	b=asz4x0W2SV2vumOJrc3KREERvqqeXmUFqlyyBaqCeoA3RxnbwEZGD3eZ4Tsg24cVZ9hze3
	A22BtNKrjaebbCiuc3sLeNNCPGvtK6F8UbIXojZAZKA9kJJDffApphlR+wYsATkBjcsps9
	iw2qFXTYdasAXme7FZlZj9QbrZYw4Uw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795526011;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R1D/oFBUDgIwZtTzD4NEUWHSoJdez4vEQgyX5LIiBZE=;
	b=ldxsGAVSrhfEVGATq22IInQ8SBx31nLGARMAVGBfwNCkrSe9G1iQn7Wqc4tDczR7MGu4NJ
	IKBs0y+/HF6x4uBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795526011; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R1D/oFBUDgIwZtTzD4NEUWHSoJdez4vEQgyX5LIiBZE=;
	b=asz4x0W2SV2vumOJrc3KREERvqqeXmUFqlyyBaqCeoA3RxnbwEZGD3eZ4Tsg24cVZ9hze3
	A22BtNKrjaebbCiuc3sLeNNCPGvtK6F8UbIXojZAZKA9kJJDffApphlR+wYsATkBjcsps9
	iw2qFXTYdasAXme7FZlZj9QbrZYw4Uw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795526011;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=R1D/oFBUDgIwZtTzD4NEUWHSoJdez4vEQgyX5LIiBZE=;
	b=ldxsGAVSrhfEVGATq22IInQ8SBx31nLGARMAVGBfwNCkrSe9G1iQn7Wqc4tDczR7MGu4NJ
	IKBs0y+/HF6x4uBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0E5F13505;
	Tue, 24 Nov 2026 13:13:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ymDDIXqNBWtVNgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 24 Nov 2026 13:13:30 +0000
Date: Tue, 24 Nov 2026 13:13:29 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Jann Horn <jannh@google.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Wupeng Ma <mawupeng1@huawei.com>, Ding Feng <dingf3ng@gmail.com>
Subject: Re: [PATCH] mm/msync: return -ENOMEM if page-aligned length overflows
Message-ID: <awWNUEFaBppsa2q4@pedro-suse.tail5790ac.ts.net>
References: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Spam-Level: 
X-Rspamd-Queue-Id: DB3E114000E
X-Stat-Signature: xpdkesfnpk4xokwo8sz569jixrtf77uj
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1795526012-664658
X-HE-Meta: U2FsdGVkX19kRLKB3NEuW4ak2a9MM74+9dpoOEg8V36ixz+/ww4wvI5Nnv3zyrqJQgCItDbHUPMlloSZThDgLxpUKjgC+qZhTZNuXJzlvLrQZg2gyVHLD7I7l+jrvBvwTuoIGNOYKBKbo3YoUhpWtRhV7d3XcxV8LpNPEMgfRAtlZH3gHmKrr6laitjdK6pxKGu1YLWoAw1B8yL1r6UMxHYhBwWDHEbVrgN7kgWYsxt+5kTvIIeF4vvME8p3WOBHMj0UIZZMLdxuPyGUXYEU4J3M4o18VQ1WIQKhfQeF2lrXHvZ7a0cKzVhJFtwDUzRtNz+SvocWJ9mTaF1NOunlChS+cdhMgHVEbQR+ZpVNmZBRh96ehgnBpcP20sXpaQam9fX9IX+5uJNkADudb0iGwg9Tqj2d8E7XCz3NeG/NrhrUZlDNszCDJbwTMIvK1hT+1TVj04kBiV1oEH/YvxuAAsJo9/DCL0pRd9NToyMhjWu3YOIWx63pQex0v4UT+bgXVYFHVeRLnGCTqBQJNJuUTW24l+r7BkO8Ez+xqfW5Ef0FIJMsMgDpwVLQEZp5PQfuRP+S1esUanCK+3WHBiySNWyIg9i0jsDY79qU5ePE5vgLJAqDkw30O/Awigjxks3JsQbvh8D195ypLZFP3lLd5jwd0QL6WlgIts75/WfXyI5Fpt0MadUo4uQk2OwByXhHmZPgynIU61yTvOCkTwBkRruhmBjvMhF2hT3fmnQvJPWPhf0lpDsqMfcVzF+yiZLuqBPsWa1T9auVAJqQPzhPZnOUM6jMgSZdEIGkPnuV8UDj3aCBr3SZP+jciZ0n8LXuFgPy3Ev9ubKFcvkQ/tMAWw66PoV2Y3fe6jFHeTSGteYIWPGvauAKmIVztB9JiAcNBGEqdfHiX2VX+51mgcnutFQQmY4l3sbnck+CWwYqyNnMp1HZq02c3EhTMDbECqa83H7286t5AIpy6m6Wo1U
 JlmuDk8D
 q/0Kwdz5xyTqyZErpU6JxrQMpSDRWLEWtksURQ0GqEsewud24YQJEraXEYkhL3baWehNF4sR7Upqm+CQzCWG2GMgdDFATazkSXXE5sxGIPcpHeop4lv9ujBvqqOQfq/wvKF2apqRH+7HAbgWw1iC4y9HANIajmnVrIA48q985fCHnJDf0hh11eoVzjG9ujNBR6uSOcncB5xYWB9ERnziqH8Edc/Gh0BeflDtaWIkdhgq09R1oDMGl5NmFPMMwgelA5V5dX6en2bwpfbTGjgerDq3HxM7tmXi/M4Qmgd1r77AqJqgKaZxuKrFKoabSZinSNMmrcuNFDCFK9gwp5LoO6IwgC3RX/3J4tvlTPAeBPLrVvJyaWVhH9tSE3qyY3aisRffVyt6O+72ECJ9esj5XPsUkDhRBxPcUyue/TCQ0gnF96DqEHGaoVrV3yNmo8DU+5rKPq/2xFlcWx3lT1L7vORb3Ee3loHDtE943mO3+OdWXdEE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 10:59:56AM +0000, Lorenzo Stoakes (ARM) wrote:
> Currently the msync() system call will simply return 0 if you provide a
> length parameter which, when page-aligned (rounding up) overflows (i.e.
> SIZE_MAX - n, where n is in the range [0, PAGE_SIZE - 1).)
> 
> This requires broken input, and nobody has complained about this, but for
> correctness this should really return -ENOMEM, so do so.
> 
> Also, since error is assigned within the following loop, remove the
> unnecessary assignments prior to it.
> 
> Link: https://lore.kernel.org/linux-mm/20230321074035.1526157-5-mawupeng1@huawei.com/
> Reported-by: Ding Feng <dingf3ng@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20261120051413.46167-1-dingf3ng@gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

