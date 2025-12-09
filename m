Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A0A0D3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 07:46:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABB816B0005; Tue,  9 Dec 2025 02:46:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C3B6B0007; Tue,  9 Dec 2025 02:46:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B056B0008; Tue,  9 Dec 2025 02:46:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8571C6B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 02:46:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FAF613AF79
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 07:46:02 +0000 (UTC)
X-FDA: 84199148964.03.C2FFF57
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id D5CAE20004
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 07:45:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ArPWOzqr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+9kVsrjw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ArPWOzqr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+9kVsrjw;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765266360; a=rsa-sha256;
	cv=none;
	b=k9WV5Q+ogHkMD3lx+JQ1gYmf+Xg2B0ItF/yTH//mFNledm16B6iRLgSZX24mAq4yns3/W/
	0iYEr00RO5uwUjDXr30HEXNhnpSykkJx5a1Qs8wbm9gM5eduAe2vGDeApZ0UhaV1kIsPpN
	5/4/K+FuQn0HrDTTVjpnVG0Y1ahMK6Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ArPWOzqr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+9kVsrjw;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ArPWOzqr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=+9kVsrjw;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765266360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vyUMGUr5q6ydWbAZ/XOXlO9x9TXtSajw6bYZWYBs7sI=;
	b=kGJpbueMJqziJEHLXQqgRykvuzmv10rqlSfwW51dPI/Gsz9wM8kslTVHnZ9ivWDNO1gGfb
	4YXZJwwsuqs52gOjzDc9O4AkhENDpQFPNtCs7AYYS+SWt5dPCIHKfg37TNoJs0vJl+rdsn
	mRV92wK8A27ex2rTBt9a4/FSBFB3oDQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 2B4DA336F2;
	Tue,  9 Dec 2025 07:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765266358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vyUMGUr5q6ydWbAZ/XOXlO9x9TXtSajw6bYZWYBs7sI=;
	b=ArPWOzqry+T5cOS2iVikGeqNVXifulv3jUvAKUVogE31EuolkmsjeMRLXsTaBOxwGZMcUc
	qpG8YvMRqQwec8zTBAGOMcP5J2AKV4dYpaOHriBSquVSOKEaBShD9pzx1FYgcHwvb1m7EA
	H0Ybd2V+4thyBWZGDjsksnWInyJrXB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765266358;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vyUMGUr5q6ydWbAZ/XOXlO9x9TXtSajw6bYZWYBs7sI=;
	b=+9kVsrjwBaPQ2mHtRbMqwr/v/yNzgQ1UlvsY4jHxYThD4kSrVmtqxCUNCU77H5BoOUIpuW
	C5fivGV17pWnFSDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1765266358; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vyUMGUr5q6ydWbAZ/XOXlO9x9TXtSajw6bYZWYBs7sI=;
	b=ArPWOzqry+T5cOS2iVikGeqNVXifulv3jUvAKUVogE31EuolkmsjeMRLXsTaBOxwGZMcUc
	qpG8YvMRqQwec8zTBAGOMcP5J2AKV4dYpaOHriBSquVSOKEaBShD9pzx1FYgcHwvb1m7EA
	H0Ybd2V+4thyBWZGDjsksnWInyJrXB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1765266358;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vyUMGUr5q6ydWbAZ/XOXlO9x9TXtSajw6bYZWYBs7sI=;
	b=+9kVsrjwBaPQ2mHtRbMqwr/v/yNzgQ1UlvsY4jHxYThD4kSrVmtqxCUNCU77H5BoOUIpuW
	C5fivGV17pWnFSDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D36D23EA63;
	Tue,  9 Dec 2025 07:45:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id V+H0H63TN2nFWQAAD6G6ig
	(envelope-from <hare@suse.de>); Tue, 09 Dec 2025 07:45:49 +0000
Message-ID: <d395cf62-2066-4965-87e6-823a7bbde775@suse.de>
Date: Tue, 9 Dec 2025 08:45:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v2 1/3] filemap: set max order to be min order if THP is
 disabled
To: Pankaj Raghav <p.raghav@samsung.com>,
 Suren Baghdasaryan <surenb@google.com>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Michal Hocko <mhocko@suse.com>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Nico Pache <npache@redhat.com>, Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 mcgrof@kernel.org, gost.dev@samsung.com, kernel@pankajraghav.com,
 tytso@mit.edu
References: <20251206030858.1418814-1-p.raghav@samsung.com>
 <20251206030858.1418814-2-p.raghav@samsung.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <20251206030858.1418814-2-p.raghav@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D5CAE20004
X-Rspamd-Server: rspam10
X-Stat-Signature: rpcfz9ugzt3ph4zaocyf5xrbk3qhhhux
X-HE-Tag: 1765266359-144387
X-HE-Meta: U2FsdGVkX18g9K/9W7lDnrmEpg/RiXWS369zjIttgOxyIex6JvIRyWoVp9kD/PiLwuu98M64MPsPgj9ZG0+OLJUbcm4pkxWepWMNZ71BW9bY1V43O5vt+AUNFmnRSyI34aIM4xWXUduxFoghgEsjhoVQD0d8OK05ZkQl593uxQB2MNMCcyeHAycKwSvQShgxS//G16PNPM14JgkHnFqLu0pktmMjwCLifQNITtdZxFs+neC4ixTwNb0Yp3BkEMB2AROm2yVS4QkkvQxV6+UZlcVY9W/6eU2Q2unEAOFzbeAZqV7RCV3WgjEksB1PdQlZqNTFkuOJqk51nTirhqdwFYJnBIopzcu8lDeMewE0YC74jEZ3hJFZThm/ITXMupD8w2cdYsrYXnGYlBcIKV74d6Xjpsa3PV8w7vvS2aJaE7BQBYUC+XPc6493QGBGHrNRi3HFCdpUR5ARnDCd/3LHhQ71zCtqJzR1EU6xo0JYT/JWa+uX/G9xn0/THgeK+DlJbhBZeeTuIBrY5GN/Z7rES2AtWlaTnssnOgz1Nf4If8Iwqzvm8t7Emb/jGnjnROAU5TJc1YKbjTfgQRSy3XK7p1N3VdqsNN9KleNaQ1Ai6Xktr5V7t2f7uWab4Lsbpb8/u2ux4ewdeZC0kY480GmRI8jvf6t7HtMzJTHY/VQ96MoE+XCe1mT41HA7mTG2OWRf60Q7rqFoEXXp5Xj1WMMeMhMSoJmR3WIwUMZVPobAxkDevSlMYnBuujOF/VoIh/3+7MM+ldP+1rwOGSs+HOXkDykc5yXlfAU7s8BxQUMdkmAXVU8ebvz/7O1tCSfs5MiRnMd2YRMxftVolD0QFf060aMgKt4WARXglSwahoUMx/CYrhncB/QKKDOhBh0eZMDnoPg4h3cAVJvKxO2CSvJ/fhkoFmQ5wu1BSBVOyxI5DgLpyFYXNFXfZvfXPJod0L/iE9itcsPaOgXlO3FeomC
 MwgtOFeb
 rmaHL093aY7/tT1R+/zQ5NnY0OCIHFgbRt6vOfRpXWzSBN6grQ6lXPE0pmo5npt2tFWApGKgrwkquSBdHthv+3aeEsvlql03riN/d2C7YNcnHtmHD8VuJntDJg0xyd2j79B8R2yrcS+evkvKJZqOmKVL64B9TivCu2DeF09e8hG1Jvj03AjzCBWw/iMSwID5DeuoUFsoHbRbRDjkz8FAWXBBVhbZPbePrhMoTq95Sni8lm8mDX7ZbQY2/t2VXXuM5GEfDnsTklPuSzb3zT6zIYXhxmFX8rBnHO5PlbqPzgKXZjl8qWw5aO9mt6bHJpBCfh7TSDGituI6XC4Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/6/25 04:08, Pankaj Raghav wrote:
> Large folios in the page cache depend on the splitting infrastructure from
> THP. To remove the dependency between large folios and
> CONFIG_TRANSPARENT_HUGEPAGE, set the min order == max order if THP is
> disabled. This will make sure the splitting code will not be required
> when THP is disabled, therefore, removing the dependency between large
> folios and THP.
> 
The description is actually misleading.
It's not that you remove the dependency from THP for large folios
_in general_ (the CONFIG_THP is retained in this patch).
Rather you remove the dependency for large folios _for the block layer_.
And that should be make explicit in the description, otherwise the
description and the patch doesn't match.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

