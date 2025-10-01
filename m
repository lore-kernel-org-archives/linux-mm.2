Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B5FCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 13:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0C968E0005; Wed,  1 Oct 2025 09:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4478E0002; Wed,  1 Oct 2025 09:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF9EF8E0005; Wed,  1 Oct 2025 09:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9CF868E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:44:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 328CD880DE
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:44:39 +0000 (UTC)
X-FDA: 83949665478.22.D40BB3C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id B6D3A100004
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 13:44:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tAZQS6W0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ImepUTZ9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qPDGAH8H;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="2vI/BOL5";
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759326277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RXKm7uHno0RVrdO73gZiJiNWmspDgiTH3SIvPr6Kuoc=;
	b=IVcZYoZBwe7uQFNch7jhsFUuryPwGP5T6uNQ8FQL9eCVwYhJq80vV7Qs9Eiia4VofN6M/D
	62/qD3eILpjBng2lYUB5HwgKt2BQ9gEhEoiNzuiWky9PqCgKUIocZyiPp+tumfqFHg3GcB
	7KcmLDBSgnAMrKqSp1LCnNy+Ev67coA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tAZQS6W0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ImepUTZ9;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qPDGAH8H;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="2vI/BOL5";
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759326277; a=rsa-sha256;
	cv=none;
	b=ki4ywxkF/JDcleGvEPHLecXWiXvYRQxuNCVoP4VMrEYpGSByqMqhzhnN4xjnPrqvoatKtJ
	6pheWAOVn6XgIlNhYIt6ZP3VePhKDxNTnY/EWp6DLJOlRjlztJxPm6GBE5ejV1TznaZTNw
	RS595NQ4uVnO0sSy9b7MiiTgOufB3ho=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DDEF91FB78;
	Wed,  1 Oct 2025 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759326270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXKm7uHno0RVrdO73gZiJiNWmspDgiTH3SIvPr6Kuoc=;
	b=tAZQS6W0FbVDQeHSwQjxvc272crMvd4NBWS1wZw7slpKHmXmg3kBzznZ0CS4RvhNlg9vJd
	65PsILbe+5cHsTQm2oDb107QA3clz2+qlkI5GvrPijUN62bGp5/XPp7rtZPvpTeViIrPCk
	kYVVZjXBFD8BTB4qhNkhrFQY1GfetT4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759326270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXKm7uHno0RVrdO73gZiJiNWmspDgiTH3SIvPr6Kuoc=;
	b=ImepUTZ9j4xdyUYX1G71yNrcxM7HqH5lzp3dv9QxXsvjUY4EbsZ/7Z3E1vHNMtkaLUOMhW
	gXB2akPgAMVKoCAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759326269; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXKm7uHno0RVrdO73gZiJiNWmspDgiTH3SIvPr6Kuoc=;
	b=qPDGAH8HeVB1km9OJ37bqLFvz98qM5hOngA7YJgjUURS88LsWeKUPqMvM/CYAeDR7zyf30
	LYrvTMoaipqBdUYpmf35ZKHLjZzCg3B3G8g6lsfSoc9/Otyb0EAOUVBYW+VMRraNnb72Za
	GKrqsuLtv56952NDNWUVHG9h/Rj87KA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759326269;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RXKm7uHno0RVrdO73gZiJiNWmspDgiTH3SIvPr6Kuoc=;
	b=2vI/BOL5LTZ2nP5Obmklz30pGvsvgQ5xks0R41jESgSffubPqLzvrfSdL9epIWClBCuGig
	5Tn8B/oXUBeUD2DQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C869E13A3F;
	Wed,  1 Oct 2025 13:44:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2MuFMD0w3WhwGAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 01 Oct 2025 13:44:29 +0000
Message-ID: <e261a18d-0ea3-4fba-9774-aa58270809af@suse.cz>
Date: Wed, 1 Oct 2025 15:47:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/page_owner: simplify zone iteration logic in
 init_early_allocated_pages()
To: Hu Song <husong@kylinos.cn>, Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250930092153.843109-1-husong@kylinos.cn>
 <20250930092153.843109-2-husong@kylinos.cn>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
In-Reply-To: <20250930092153.843109-2-husong@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B6D3A100004
X-Stat-Signature: j3sq36xx98xmj56n9ft55i1remstpjo4
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759326276-295479
X-HE-Meta: U2FsdGVkX19kM73DMBpE4TNO1oKsRYsZrwEQxfkAwThqY6lvewAIcHiCyjEIFj5JNG+aw5fcnMUAYyme0eIOQ+Dj2/+KK/Z3Kr6559oK2Cu4ytOQa/Lbr7sxeJK0xf23MhExmsAjmB1PQr6ZdqIt02nYwTYDSrcJRRAXvkY5oqje9UMjWLyLbw2WkGKobfqUaNHGJ0s25UK+Qa5ihP3vBKlGjlotEmUN9rhnGAFmyZLv2Wv7zSyaiOYDSRWKcTj2GyI1NTZshQtuRVzol0hM/QQOEc1jEhbF2Z/n22JrRKnRLjusSEv7afy197968aDBWRy6Fg4G+t4ToMIrwQD2USL5Vr7Y99TOVT/qdrZeTLAUBB/Ls3cT5vP8gxFqW82rz5NdOo75w18i0/ZBpVy2SPdNRnQAZo/cEyVjQiXmhi0X6I4sEhNvwNQ06ROgIbAdyiXd4h6DLYWStP0I+uSOaIjpuEZcmFLd0QLmMHi0Uh6p7ZHjOzZbLAYHmVyrc4jJdnzzYWpxAczrTov4Ly+lYaAGhbNjGCHsqtOh0qD05gwNcEMYEvthltpmqgDVEKvT/+yQI2YW1paTG/dXaXoqxrrDdd8sE5wog/tLHcbp6TQXRh+iRDFPjcgIA9zbr3Y6F1bHnz/c5fx7YWJWcBuWNT+3ubijtA+68lxUR3FWvMpvVmOo6uoA/HgQ4anmEYvtrP1dVjEM1pBtOdNo4+UqGXsVgZspBtjFzf9XZVYC146FOQ69IVe7ZjV/iEbZDSr0A3E2i+YrtS0KWGQ4CmWnEMEhowq+VYA84kVLFsKLuBB+tVrfeH0F1Tr6Gmb7jMAR238RSaHD8mvfLhgleAtjias1PwhfqVCHLuvu6kf9778OsXC+f0hoTvgjlKks40sbDuxR48TxbliB9vBkP1SMwwDKYHaE/Mb94vAxGOkwKZDyFoW7xqYgfjdYg/a+VcnD8zlGvmzfqew+Zvbboog
 EMxH0YT/
 wm3/xmO16tw3NqzY0lwv5CKZi/4O4VsNQyikBFMDYyFjhKQLuOHcuHAPmRAcW9aH4Cg2HRO9yOA52KehTZGPoH1JG6cCumf9/1B5+axTYbynbxPAS701GMF5ogVQZnU2tjJ5LRePNE3at06VKR2BjX3zPKf/m1PFFP06KrxB1RkuemcUpg8aCU3McRfY5PHPUPsKUzBFcm87kcvhyc0vDRldwT1o7InCbZp9xObpSzirf731V2AoTmhEbrobPO4vzXloH/RvUBM2+ggDiG84q8gD5jP+8++EJ+b1HP8Ol4WaZYUkQlbMi7HdU4DYWAZaurlJYtCzrc44sE6ptl2O6MJx579aihjDs7vZTCZabrCMnPUg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/30/25 11:21 AM, Hu Song wrote:
> From: Song Hu <husong@kylinos.cn>
> 
> The current implementation uses nested loops: first iterating over all
> online nodes, then over zones within each node. This can be simplified
> by using the for_each_populated_zone() macro which directly iterates
> through all populated zones.
> 
> This change:
> 1. Removes the intermediate init_zones_in_node() function
> 2. Simplifies init_early_allocated_pages() to use direct zone iteration
> 3. Updates init_pages_in_zone() to take only zone parameter and access
>    node_id via zone->zone_pgdat
> 
> The functionality remains identical, but the code is cleaner and more
> maintainable.
> 
> Signed-off-by: Song Hu <husong@kylinos.cn>

LGTM.

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


