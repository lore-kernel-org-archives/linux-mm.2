Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69A94D3E782
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 05:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B09F46B0007; Thu, 11 Dec 2025 00:42:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A93A96B0008; Thu, 11 Dec 2025 00:42:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983766B000A; Thu, 11 Dec 2025 00:42:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 897126B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 00:42:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 270B6BB387
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:42:46 +0000 (UTC)
X-FDA: 84206095932.18.0D0ECC0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 064E210000D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 05:42:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J5x1YOcd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nMWGwcZq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J5x1YOcd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nMWGwcZq;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765431764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXpLRwabY1N9l3QqkPFaPN8m63+QPMyhsor2WdHWG+E=;
	b=GQv1xDc/JEno6MwAetJt1Wq/thrfkaeHuqFo5tVcE+LDSO/f2WE3vjnhwn9v0UDDCqySL5
	1VabEec0AnlOfZw864iHJgrQpYcUvGDg3zhu4+YkM2NObfs9bSLr3mTp2vzsEDrhWzBA4a
	OchYqSGFZdsl8mxX9hKoQD6QJ6CBhZw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J5x1YOcd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nMWGwcZq;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=J5x1YOcd;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=nMWGwcZq;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf05.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765431764; a=rsa-sha256;
	cv=none;
	b=cSaudWwxKC+TAAFNlpEDZpXwSEtpGGNjTM3nvumKjPGyLY1tWTI/wQarrRHWZGy7L1yEw8
	nXAMkz/4/ZuMFBdVZo4fLdlsZWlfc0tknsNWkXkhEjl1S16DsDeaihkwV59ecAOZMaRjdx
	t3vSVlYrNI7jw1hmLw9u6pm0uFjfh2s=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 71D775BDA6;
	Thu, 11 Dec 2025 05:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765431762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UXpLRwabY1N9l3QqkPFaPN8m63+QPMyhsor2WdHWG+E=;
	b=J5x1YOcdxLiG6sDRFY74G9B6OMUyGnkzquvTad1SVja1yuuZh1uySu9Faw1cy/3fCRaGpx
	lzWIitr+w4dL9cql8kFY0Mvq4YQEJ6aEOYbbp8xdzMf2mMMCWkERitlp6Rb0I+0y6j9FGB
	RU3aTdV1j+OYH07Idb/bVCJ/3DRYI5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765431762;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UXpLRwabY1N9l3QqkPFaPN8m63+QPMyhsor2WdHWG+E=;
	b=nMWGwcZqtaKI/QB5LHNEnC8POpFpAZLAlTcFxcpbl6DShkFMtGcn5qhiMgKOoy5/bPJAb9
	AzUiH/LG9yknicAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765431762; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UXpLRwabY1N9l3QqkPFaPN8m63+QPMyhsor2WdHWG+E=;
	b=J5x1YOcdxLiG6sDRFY74G9B6OMUyGnkzquvTad1SVja1yuuZh1uySu9Faw1cy/3fCRaGpx
	lzWIitr+w4dL9cql8kFY0Mvq4YQEJ6aEOYbbp8xdzMf2mMMCWkERitlp6Rb0I+0y6j9FGB
	RU3aTdV1j+OYH07Idb/bVCJ/3DRYI5w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765431762;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UXpLRwabY1N9l3QqkPFaPN8m63+QPMyhsor2WdHWG+E=;
	b=nMWGwcZqtaKI/QB5LHNEnC8POpFpAZLAlTcFxcpbl6DShkFMtGcn5qhiMgKOoy5/bPJAb9
	AzUiH/LG9yknicAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B6D53EA63;
	Thu, 11 Dec 2025 05:42:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6I2YC9FZOmn9MgAAD6G6ig
	(envelope-from <osalvador@suse.de>); Thu, 11 Dec 2025 05:42:41 +0000
Date: Thu, 11 Dec 2025 06:42:35 +0100
From: Oscar Salvador <osalvador@suse.de>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-mm@kvack.org, Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>, Muchun Song <muchun.song@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Liu Shixin <liushixin2@huawei.com>
Subject: Re: [PATCH v1 3/4] mm/rmap: fix two comments related to
 huge_pmd_unshare()
Message-ID: <aTpZy-_A-aFxpdn5@localhost.localdomain>
References: <20251205213558.2980480-1-david@kernel.org>
 <20251205213558.2980480-4-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251205213558.2980480-4-david@kernel.org>
X-Rspam-User: 
X-Stat-Signature: 9436f33acqfd6g15ini8mhuybzyc7ck7
X-Rspamd-Queue-Id: 064E210000D
X-Rspamd-Server: rspam06
X-HE-Tag: 1765431763-963140
X-HE-Meta: U2FsdGVkX1+78l7VnatuhZeFGodhl7WgBiF4ZAH1FtKYNUN0K4A07EoZ2XeAvBg9hR9Lpc4X/Jy/ZaVA+R6iPNOaDTf62huikDciMkukPVp3Qw/3AaqZbgzDSpa35ByG3vnzm2JfPN2ARXed2rqc4PW/JCHqLy6ZQxYCb4bhxYJY+XAOqQVl6k0qPBOuix7mql0qJiCM0HrDnnqraYNoDuTUaCD95PZ2u2IqxcDD1IalXoy0TKxRFiu8A4PGnJx9WlEexJa8+gpWgJ9Lw20utwmGnMgivfri2THdikK/E8EGNC2VbTXNKxV8xSdh8ncxux2VjTYq6EdBPPowOMSLS5yxVFKc4JysNktaagUkJ+ElSUdVpGvjZqixsVGoTUXKUskwUpHisWq4AEYqkvF9zUNGPmMIQy2L2UcG73OUfQDPhoROLYknCt8wisJJE12U3/HSChbvVHjvkyy81GGIfIoQPTs3sxJCVgyOMt+TTA+Zw3pVt+bpTZvL6xlWiYaTG7C7MRxURVIlSNHn5aAj1s6fUWbx7TXsq3kF7UJOAksJ24UxhaBFlqK2OVKBtxvHjq3Of96Rj51Zd1eIaWV+MmsrBEuJDJ0ci5UOMpBNUdvUcoFwOckYw2wY0HgCCuBDBHc2mGP85HJJnONeIgXTkIV2WF/DzaFHBXJ86YZmAUsymM0L2ODyqEhsICjZ2738D2o0F51n4g6esUHAGL7xE7uQZNWiFbxUioHzJKumvqmaaYGOGRys95bEw3VS779osXa8Zozj1VY4I+yyJDEAIquhssbB/a6AuPO0mN5JbHHKSurnH/NrX5atV6shFjd3OeJ4Uyp6mPR1qw4GLxZUE6dKauatRzlBk5xyz/Xd0eIUwl+6P2/MUAY0BW5U+l/QxCXvhdSlsHynaeQs80IcbfGGSqOkFRjIjHLOWECJTCNw6hJrju9QFezLEvXfCvCz36Hbn5uIiyopbm3EVzX
 Wo6PZ+j8
 axYNOnI568yREHN2G9aYy0X2gvyVkSp8MjzmJHMiwdp4Jn8KJn6xibtpZOTNteZRCxVVo0sn0J8f5ji6oLA2U7KkGrVl/vRMAr4YhIujfFtO8Dg1fBEKs5ZKyquAm4R+5mjA8j6Y/s3MaM3a5Dm8mtlZdOMpnpZL4hjqcxTS0pjheZTquodedlb5JskuQkIFo47D0jPQl+mvvDv/o4Go1th8e/ZG21mnjt5prWD/lWpjGQX1arQCmQG6YkHAOxmLwRXv7yFyb2oadmShiBzHXZEYWo/sO/GnAiMP2UUqurSclEQxcq+T/sH5aZ5ENH4Vg9FA0eBbNG8UrR7veEDzYBg82fMZye1xmylKI+8ZJkRZsBJPtohuluTlVJAehnMSZCezAue+Z9Ah4MfmMJhHPreCfDOGEFdk62jPgN6pKpLrg5hetrQpt15mVCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 05, 2025 at 10:35:57PM +0100, David Hildenbrand (Red Hat) wrote:
> PMD page table unsharing no longer touches the refcount of a PMD page
> table. Also, it is not about dropping the refcount of a "PMD page" but
> the "PMD page table".
> 
> Let's just simplify by saying that the PMD page table was unmapped,
> consequently also unmapping the folio that was mapped into this page.
> 
> This code should be deduplicated in the future.
> 
> Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
> Cc: Liu Shixin <liushixin2@huawei.com>
> Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>

Acked-by: Oscar Salvador <osalvador@suse.de>

 

-- 
Oscar Salvador
SUSE Labs

