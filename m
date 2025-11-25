Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78304CFD368
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 11:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE326B0024; Tue, 25 Nov 2025 06:34:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB6346B0027; Tue, 25 Nov 2025 06:34:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA4FD6B002A; Tue, 25 Nov 2025 06:34:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A5B4B6B0024
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:34:22 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59CB38A149
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:34:22 +0000 (UTC)
X-FDA: 84148921164.08.7A3CF51
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1069420009
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:34:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=palqSKHR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pvrMIH+Y;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=palqSKHR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pvrMIH+Y;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764070460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A6bddmiCt8sswy5FDw/YJm1A15HUCBczbh3cCC6mC88=;
	b=wk8BE5dDkQYjJDjYgBoEUKartelulY5eSJC2FbVJBXaIJZA0VXwoQMpsA5QFXZbFR1uCy5
	bBASaFCursFLmzDP0LcZib9xg9pnjTlfeMS3L20MvIX80a/B1Evr8BlICzApkTHWK6I4b5
	Cp1NmCZhNPa9oDOo2dKjcTfDg7XGBak=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764070460; a=rsa-sha256;
	cv=none;
	b=hOelKBQBSf5IUp+KeSM9rcVGMxfMiasYahtAOYPAdYgaaF2bLBnWbwuijQ/I1fzbVD5IX4
	BOpEK3N1HGOP9En8UEKnFIm84gwuAyVJgPTNMG9a16cZYmZPhYXZ2Alqsw2mVUzq5Jmokz
	m8bGfWz/PcIeF96qy4T0soaziUcqZQU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=palqSKHR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pvrMIH+Y;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=palqSKHR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pvrMIH+Y;
	spf=pass (imf03.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 302842277D;
	Tue, 25 Nov 2025 11:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764070458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A6bddmiCt8sswy5FDw/YJm1A15HUCBczbh3cCC6mC88=;
	b=palqSKHRjkcLXV4og5WoC/JUbmhUagtlFS1bQrtw5FP9SxoldRiKzQNnH61RBYqTJd2tnB
	00GuCbIs8CMIS4oG/5Luox1wseXm4jYGhiEZEtXk2lkJ/S9lqyyJV6gKik2rIV+g3tEyne
	vZqqUro19lFh9H+C6S9HrJe2j6bl2BI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764070458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A6bddmiCt8sswy5FDw/YJm1A15HUCBczbh3cCC6mC88=;
	b=pvrMIH+Yrx68NoOAHREsZe5Rtxs+2tzvZhzioVYVOkM1GGiHefjz56+kv9VXk7seQZQdIK
	GGhtVtidoMvxKmDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764070458; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A6bddmiCt8sswy5FDw/YJm1A15HUCBczbh3cCC6mC88=;
	b=palqSKHRjkcLXV4og5WoC/JUbmhUagtlFS1bQrtw5FP9SxoldRiKzQNnH61RBYqTJd2tnB
	00GuCbIs8CMIS4oG/5Luox1wseXm4jYGhiEZEtXk2lkJ/S9lqyyJV6gKik2rIV+g3tEyne
	vZqqUro19lFh9H+C6S9HrJe2j6bl2BI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764070458;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A6bddmiCt8sswy5FDw/YJm1A15HUCBczbh3cCC6mC88=;
	b=pvrMIH+Yrx68NoOAHREsZe5Rtxs+2tzvZhzioVYVOkM1GGiHefjz56+kv9VXk7seQZQdIK
	GGhtVtidoMvxKmDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 154FC3EA63;
	Tue, 25 Nov 2025 11:34:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id veboBDqUJWl3OgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 25 Nov 2025 11:34:18 +0000
Message-ID: <ec6c066d-65e6-4ec5-9c40-0d064616e19a@suse.cz>
Date: Tue, 25 Nov 2025 12:34:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] mempool: factor out a mempool_alloc_from_pool
 helper
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251113084022.1255121-1-hch@lst.de>
 <20251113084022.1255121-7-hch@lst.de>
 <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com>
 <7b1265bc-835e-4c7d-af75-f237c46bc3a7@suse.cz>
 <20251124061517.GB16260@lst.de>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251124061517.GB16260@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: f1cpabtbjx89cqbucqt1ewm9wgcehayf
X-Rspam-User: 
X-Rspamd-Queue-Id: 1069420009
X-Rspamd-Server: rspam01
X-HE-Tag: 1764070459-173013
X-HE-Meta: U2FsdGVkX19eq2uEziiFE0mQt/9Qz3vykq3m1PCn9u5W7rzOk3Y8GLZyL940077T71VLDwmUKOlOFBdCvEzB+Wb+yp/e/4emrJB1fH2F81UjW1ItF5MeWWB2EK959SdcwEUn2jDVgyAKuQncMw2DFSwKHSI4V3t7qMWX/bEJUZwQ2Kr9jCjAzkvsz6wN8CSQ1ToGufjsTdT+492A5Ua2EwciiitVFhaD3Rzfm/I6rpZhBIkrpQcxY9gGuG92hTZfKKZU6MaFykqlZLYeZW5mBVRZE+cZVTF+7IYgJbznbpq/pUt/+k0NKO8a20jxK+pm4d+urltGHLJb0O0StmIwFRYep2fS3wFHtYIN0cRSOhn4X13DCnzc28+vAHy8xCTXyRE5SyzrhC4kIzuMk6+fX5yZ05c2GL8/yGLSMAlquPqI0SFOzM4fPUj9/rJ0ByHAa8vo80Ekw/JOQrBcPphw7Xuw/NmdX14lCzOIcgzxxwg/JbDj0ypxCYg7Q+oUJWLZjFBQBevQTZBq6PzIv+KqQAObgHNfvo4NhXNUxyOyNvUgsxpmxrMiBTImQgCU6KLXfeoXw7gWnjUoZTXKe88xNH/ndi2+r+pQn2YJ5wH+DhVDnD3cNwb/DpzMn3flDizxlsRB7jLgfxJ+GquM1JbrS7hAKwrKuDucU0y5SbQFJO+vYoCFEZy2p6Hg4oe++LYq0Ygu9r35rE3TZ26HZPqW7gGzBNQiGdTu4h0rU9mrgdNCI5HFKjDtWt55HB86qdlr2h9IHalhcqiwPI48cwEyY/5eO2oiLqjaKEU+TCAPU3XMo3JHBbuohHBrlESTI+aQlsqF2G46AvRDA8lGCMQgMPw5chllBwYRx+Lex7eNPFP7ybIRstqrDRmjfbB+2TxRjhHB5qnQwUqalrZBGa0vlYadT0F2TGano6eJdBQN6o3/MlS+UQ5en2LppQw/dKWAgjYxMKirSp436S3+Cvc
 XWyFlX6c
 mZH3HpLBiCapBWDGxs6B4YnEYktI2WNWv16diGmiNlCQdaNDg1PkDImqeQBg6VlXPuTzAkDP6b5n4JdUtf2aYNovYtaVWXYD1Inaz+ViTFn4TNuba6DcrVJIlwrytiCKdMgzDkh/32GwUXpxkMaJ55ImYdLXWYDmrLyWyE4WelzJtKIkMDMjbNxDwJiQbUv6ayuhHFIWw1TP+RE114Q4ucKuakR1o4xlG1S6rMEwhWqZ8iutT0rKcJa9kvLICWWIDU0pm8V2r4qX03Ct+/zspyQULQk1KRMOUw4D2smEUnM2WHmG2A3Tu/MX+SxNMGUJGPhEZjhoROaEwGbNANdBc87pPsPNQnswLc2q6M+zQDN2fUoR9kIe3mmVqh4d5lMRhrpKH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 07:15, Christoph Hellwig wrote:
> On Sun, Nov 23, 2025 at 12:34:40PM +0100, Vlastimil Babka wrote:
>> Looking closer I noticed we're also not doing as the comment says about
>> passing the limited flags to mempool_alloc_from_pool() on the first attempt.
> 
> It does, that's gfp_temp.

It's gfp_temp now after my fixup, but you were passing gfp_mask by mistake.
Thanks for the review!


