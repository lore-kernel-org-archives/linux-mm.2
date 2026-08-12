Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F34F6C5CFDB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 10:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E95A56B012B; Wed, 12 Aug 2026 06:52:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C066B012D; Wed, 12 Aug 2026 06:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D83D66B012E; Wed, 12 Aug 2026 06:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1F706B012B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 06:52:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 45A7BA02AB
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:52:00 +0000 (UTC)
X-FDA: 85092302400.22.FBAB083
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 359E4100009
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 10:51:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nEaJ9gED;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HnYI4tCT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wpUhZpzC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UCi97sZ7;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786531918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+em0Spp2GVSY5hXTNLCjA9ODhlqN5jS8d6CBWbJP9Mc=;
	b=XfUJZhfUE4rzX/tj2JIoB0qZubaCL0Mo4V7sEJbkTe2R+iDGtJwMRP/ubxgoqJm6g9q7r8
	cvkN1ciyOGJF4Vn7SKMz3jukD+c+N2VKoNImH27dc5JgRdKvtm7uG6xjrXcTX0Rwt9G1/m
	JeIaFKzTvUKTsRCcl77KRqSVdppjFa4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nEaJ9gED;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=HnYI4tCT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wpUhZpzC;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=UCi97sZ7;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786531918;
	b=i7SY59f9JE3MQX/+IyZMLIAd8+tL1viNVMA1QxEX6VtXxQO3Joz71CtDyi2NyijF7DjJmR
	PqPdsvGK8L81Ctz1ymltA3WtFWJeVR1x1cV5PTPCx7OfYURT+61zhNXaeNwoiW15nOM4fe
	cnKWjKZoJuX/DbOjYoIjadi8uHCvEiw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2B0AE82250;
	Wed, 12 Aug 2026 10:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786531912; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+em0Spp2GVSY5hXTNLCjA9ODhlqN5jS8d6CBWbJP9Mc=;
	b=nEaJ9gED6WkYmp5DVeUuGwnFUL/YQC589Re8TutWF7qHa3jBUe4n++lHsSy3GuugzxJ+hZ
	Y9dFaG+ZXk/VRfJD7E0DngzyJ3bdqRpihm5RCUhQ12vCBG5MRF3lXcu5/mk7Pgj8voa1cL
	a0D3wpztzwCCbn22L3SaZChS1/OXRKQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786531912;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+em0Spp2GVSY5hXTNLCjA9ODhlqN5jS8d6CBWbJP9Mc=;
	b=HnYI4tCTBwnT0/+oc13M1fhiNJzmCyKYtQx93kM7YEHPiweN5pTrsFQKmvsbHffO0+/lYP
	CeWA114WtUm0UdDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786531908; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+em0Spp2GVSY5hXTNLCjA9ODhlqN5jS8d6CBWbJP9Mc=;
	b=wpUhZpzCUySvhqllHAQD+/P15k5lCkoi9z0POQYVHx8wfTc72Em9Wwl1/acBnxnHfjSwNH
	83BCekhcXI54hLUF1x2KnRRvQ2/MzB5yp/tDfUM2LW1SkMp2WbVyje8uuf1PjuTxJg3uqx
	+UO68RaQO+vZ6aWPJXDWT1WQ8MDuIE4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786531908;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+em0Spp2GVSY5hXTNLCjA9ODhlqN5jS8d6CBWbJP9Mc=;
	b=UCi97sZ7Wi0b938tfBMsOJvWaw2saD18uRKGief7/Q7ratmtUUBcL3IiNXNBEm2ZK4wa+j
	0BCZJEU8kCrK92Cg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CEBC1779B1;
	Wed, 12 Aug 2026 10:51:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5fYzL0JQfGr5SwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 12 Aug 2026 10:51:46 +0000
Date: Wed, 12 Aug 2026 11:51:45 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 6/7] mm/khugepaged: unmap pte before releasing vma
 write lock
Message-ID: <anxQLGly0Rnb0TsB@pedro-suse>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-6-ddac39d61c4a@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 359E4100009
X-Stat-Signature: sihfz78fs8fgrhfh1i8f8fgbk3hzigwd
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786531918-47646
X-HE-Meta: U2FsdGVkX186EPQ6g0JZv22pltBiRqD4pH+wokif/8zNqfGJ/GPL2IjRsaKTvAuX/dzAbO8w/T2Yd8D0cRakQgsKztVc4c0DI3DDAuxQdWriM0r3j2VCEz7EvaPawyhFRCqny+1RcamtZvIHwwa6S35K305/ey/8HfA+V3Clv+qC/HHe5Lu+BXnMiHS4MlrQIGMmjed3k/FjmmtPipTTBaC3gaSZ0QqVxFY1enw3QUMO+bBQxineGb6Cxf/JLauHRk/Uhog9D+t8blqZ2MMa4dDu6L+whYyyZ5FQRuuGX4phDZO9Cx2F/zpoNDUhTgiepQB+xPMeTki+vd9f6TDPwPgKdmNw0Qq3rAApe2fXHlMQKgTLBKVjdfYraFO27Tsat8B3UI9gwa3mhX33YzYjwmDsum4Z9r1YZF3SdFGx2WhpE3zttqlGWsVKltq/VVgvPmi2x3xycDAGh+hztT+KumLWtGb9HxznJ6CnoyzNtb3karNrm+DPKHQdhapfBPTpKbWms1Eqg+fgZZRh0jQ9xG3g8UVR8lM8lttm4LFMIJuxiVvm5NsPT3zCnqvQ7b1BXnin0Gk5ezvj6TQpU4NOd7PNYu8joxX0d37CRBkrw1OCzy+SNdVKgDxqp1fWZnskUG51fGTDZ4orR0+PpL0pRRHoanxGcZ2EcsnFUuyC8jehA4vcqpWCQrB2w+0e+9FMQLcQL6V/zvnYfSvWymZlLagBpzzMOwb7BWII2qim/UZGKNDxK/XQn91IeBCLd1QFXrFGcKfilvQWo/xByrxqNF029xGf9qKK0UJDhUlr46Ap8bHYn0//J1BxhmaBRvcwEkTt2G/qZS0eLHzsjjJsbLs2oeiwbzDlvoRTr7eR2gSt3/YDGIGcMeBOl4SDiv1HxhljudIGQflv2TszC1xbAJR+TQJie5UjEelBT7b8IIuuChGp+w/sowxpHIWnCNKfxdVfLNCLfgYeObts8Jr
 m7jV1jdx
 QOtJVqrDIt6OsmNQBePGgvcSS0i01meJ/05XRzixZf5zitDvWaUJWwcYY7gmypHjy5H1J/bQ40RJueHmqV1oB3fe4YM0NdU38+7rm2A1uySFuhSmVatfVFf12boLPipdDJE+UAXU0B6w/bl/L3cKiW9PQxkOfHPWVItEISX0k8We7BO8aBx0pMWTW8cD1Eu5BbycppYcJUvksFPSlpWo3DPZVCmjafn96gCqTY6rU7hu/uB1RMUXKj++woz4UaAA8Znfvy+U0q65e0ZzPnIWOxcZ4wFf6hDa3IVBNuziTRiwYs4cmtO4UjMc+2L7d5i+hppDbiTKE6ynDgLdpZRn5Tb0kNJxyv2JtI9Xbk5a6+ZI8MLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:38AM -0600, Nico Pache (Red Hat) wrote:
> We are currently dropping the anon_vma write lock before unmapping the
> PTE. Although this is safe, due to us still holding the mmap_write_lock,
> its safer and less confusing to switch the order of these two operations.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

