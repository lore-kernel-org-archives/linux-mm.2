Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B62CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA6C36B0007; Wed, 10 Sep 2025 09:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7E506B000C; Wed, 10 Sep 2025 09:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B952D6B000D; Wed, 10 Sep 2025 09:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A651A6B0007
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:08:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 467E013AFD6
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:08:41 +0000 (UTC)
X-FDA: 83873370042.10.99DCC70
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0559FA000D
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:08:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w3VfEV+G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="30OH4Hw/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w3VfEV+G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="30OH4Hw/";
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757509719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+oSyfzNJLGLfUyM48/ZQpqckel3kTsMsG7r1q37tt4=;
	b=FnynrEVlNI+3eEiRTjkPTVqlN8gXJsH+mNQIdzZy4UxaY01LYdoESfAaRjq9d1wzY6UI60
	WTe+U0xVGEYjLE5lUTYXYnnWugV1ry9E01z04H02yR2eIud2xsaPZuJYaRyxxT97+WtwGn
	4UZrrCuWWzJiEGGJ1uD7F9qDGWluN0c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w3VfEV+G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="30OH4Hw/";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=w3VfEV+G;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="30OH4Hw/";
	spf=pass (imf15.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757509719; a=rsa-sha256;
	cv=none;
	b=zaHHhgSvJq/aYEwPkkhbJMBKw/6iIQWhAH2YqyhpkdyW6OTNgTQRXqQwEi2UyjPMokyemR
	CnRSevmakvWbNIMoLrY+4EdaBWgDhpvjaILaYOAW01DRlrBvdtOH4cFWwAYw0HbaANKfWD
	Mfmh+L+uJSwsIMYz++6PmcTjq7vEKOA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 591135CC91;
	Wed, 10 Sep 2025 13:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757509717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1+oSyfzNJLGLfUyM48/ZQpqckel3kTsMsG7r1q37tt4=;
	b=w3VfEV+GvLc3BqHxYCsKiYnp3HqbXCScgXCDJQRuFN6nGskMG4Hwo+srXkp2cDJDhGLSjm
	GW4tL6mOgjcftLjnrXTR0BnANiMKmdzZjl2E3CE+oIug3JlWdHOY9/RUKguY6N7HF02CPr
	nOCuID7P1fzS6UX/TlAR9wqrBG21E9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757509717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1+oSyfzNJLGLfUyM48/ZQpqckel3kTsMsG7r1q37tt4=;
	b=30OH4Hw/M1AubeXskn4o+uZbIK1J6Nmyq4HG/zNVTj077HQguHkz47u9GO/MtBs+FY49O+
	bwDhJ5o/sc5wkSDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1757509717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1+oSyfzNJLGLfUyM48/ZQpqckel3kTsMsG7r1q37tt4=;
	b=w3VfEV+GvLc3BqHxYCsKiYnp3HqbXCScgXCDJQRuFN6nGskMG4Hwo+srXkp2cDJDhGLSjm
	GW4tL6mOgjcftLjnrXTR0BnANiMKmdzZjl2E3CE+oIug3JlWdHOY9/RUKguY6N7HF02CPr
	nOCuID7P1fzS6UX/TlAR9wqrBG21E9k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1757509717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1+oSyfzNJLGLfUyM48/ZQpqckel3kTsMsG7r1q37tt4=;
	b=30OH4Hw/M1AubeXskn4o+uZbIK1J6Nmyq4HG/zNVTj077HQguHkz47u9GO/MtBs+FY49O+
	bwDhJ5o/sc5wkSDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2CBF713301;
	Wed, 10 Sep 2025 13:08:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g3y3B1R4wWgDCQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 10 Sep 2025 13:08:36 +0000
Date: Wed, 10 Sep 2025 14:08:34 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	maple-tree@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	Charan Teja Kalla <quic_charante@quicinc.com>, shikemeng@huaweicloud.com, kasong@tencent.com, nphamcs@gmail.com, 
	bhe@redhat.com, baohua@kernel.org, chrisl@kernel.org, 
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v1 5/9] mm/vma: Add page table limit to unmap_region()
Message-ID: <5li7vx377obryqypk34l7aw4plsulyg7jqbdhfwkx3mawlzugd@yqqjkvy4uzou>
References: <20250909190945.1030905-1-Liam.Howlett@oracle.com>
 <20250909190945.1030905-6-Liam.Howlett@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909190945.1030905-6-Liam.Howlett@oracle.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0559FA000D
X-Stat-Signature: ubsqt7wyk9mjuty85c5wp9sb1yke5ojk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757509718-228061
X-HE-Meta: U2FsdGVkX1+bZzCPyGRidlUKH2jBKbTjCWf37AibtcQi0oLjYBgBuJfjxztuGDRiaps9h/oSQCSL1T0kqoEZp3U63dwFUl8ylxt6kTio2JgktxFiEkgtREhetK/OMNQtB6D5u4d3jipiLITmNuFpithRK7h+PstKJ94S2rIb3wWFo5r7j+UJ1bPplknZy64CLPSww3yo00a2JfYIx8VS/nNFIPeh9G36NwfgQWdxO1KeRJI149ufP/F95w7UtWHk6u5QjFcouaOlc/kiu4SWXpFcaF5V8jrHij8jzcUziFMS/nOshAdPbLYIKBxz64uMhwXd+JYdkpHwQ/V4x+cueQKP/NZWxp56OxUbUrKGxo09P4bbL3NQ4bm5qGugZHzbylyVbAxzqgZ+Mp1+VBUxe5W206vY82reqcJgC2lQVZA5lEuC7nAgfGkqlIICYIg9J6QLwzH2ly6bIJY1GGvtGWr2+zfK8sOTUuqbRln1CDXVvYqLHUey2Mzjd826NZlkvlq3Cyr1jW6ff0W1+ucq0iIul2OxdAAcndXu+ITW+7dI+VrVwg0qxcaSQ1pp3CURpkuK+Jm585Cr7G13+oF6V45ZZctr37O9hepybKd5GBD1hQnz4wQhlc5bOx8nM6elIBLhzVTTCcxfNdcet4lLr+B55WOehehFKfnWa/FA7MtAd3qK3rja0ktkwotee0iTVwEIzCbOsrEDDfgxYNPEVszqItj4OV3FN6ANtVx34eo+UXZIWh7uLfsE49SRGBenqkC1ZzT1jRGn3fRDg0f0gALI41r/yBUBhf4M8/YTFs6Sofso1uSLTdmqg12QiCgcxeE4WshxlnLIxjk4bTstwrXh5TDV5xQWYNmyna4y6mcIYe1KNde6qMTPvw1pNyoosrISX/5hrE5TlGD3MUUj/9ti5egNRUt1agUmJlPuNvN5NfrlERu5OvR8BgdVyZcBeEYnzPTj7hAi/sYQkNN
 5kMwfkx2
 EcEpQklrAqfCiTVHCDj611eMbGH+YLvdWvSNZZm90n8WvDE5gBwvBh4xrJyUDQeyCOVlFA4h8/x12iXPtoP0qm7TueVWM/8sXx5zF6F8mayI22Tq8/gi5/nfUAm/ZvVrxyuSEsMYv0h8xhkaJhkZWnQNrbyR2lDuhJz3H/9HmX9nKhrwIR/yDL+QwBelwl9w6ygBcszuJaYbjnU831jngm857fqOdHLya3iZmxsF18uUstbmaYHtqYrExcSK7FkO9f5Oee45LYIAPE9sf5bTDk3nIV4Tqnd0omZlLvnIjF7eWqQtSOsmID+s+g/8fNxvWzS1dBzQPkW91G7iDvsnTEOlQFPDQkvfcwSKQV3RXzVWt+yZteQHuuoCZgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 03:09:41PM -0400, Liam R. Howlett wrote:
> The unmap_region() calls need to pass through the page table limit for a
> future patch.
> 
> No functional changes intended.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

