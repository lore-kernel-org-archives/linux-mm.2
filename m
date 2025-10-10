Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3D21CCA476
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 12:44:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0B568E0005; Fri, 10 Oct 2025 08:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4938E0003; Fri, 10 Oct 2025 08:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97BE28E0005; Fri, 10 Oct 2025 08:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA618E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 08:44:29 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F13641A01D8
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 12:44:28 +0000 (UTC)
X-FDA: 83982173016.16.F24A6C8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf06.hostedemail.com (Postfix) with ESMTP id 72C6718000B
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 12:44:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aMcmjXyb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TIGYfyQX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aMcmjXyb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TIGYfyQX;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760100266; a=rsa-sha256;
	cv=none;
	b=JiqQRwrBt1DW3Tu3z0SfgqiYzW5Fbnq51AXOeOmnn/K61cVYqyxNIEw/3mArqXx+/D4BKd
	4LwTG7BhtocTH/fu73J9hFyRvxbN2A+ooLOw9Agyram0TGFgXIT/wd6ALt0pX89LlWH8A7
	Ya6PvYODDCg+P6sgXA6DLcDYVL15LkQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aMcmjXyb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TIGYfyQX;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=aMcmjXyb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=TIGYfyQX;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760100266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=awaJTA4euvd5lWlQz6drPQdT+/x9DxKM967nJbwqyJA=;
	b=GlABRl6O1soOMhZPmnY4TnhIELKyjlAc/pjytjXTE72HE3Oe3nnHzUlUCsZxpEccDgzAMj
	m0ohPbUdBa475XrXVRPjn2oDumcrozbiTfimOrX0pgkWwnpN+kPAePaLLDw++ePoXDpx89
	O/s7fkNk6Y6HsFw9dcBbLK66S/GGMyw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 866941F397;
	Fri, 10 Oct 2025 12:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760100264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=awaJTA4euvd5lWlQz6drPQdT+/x9DxKM967nJbwqyJA=;
	b=aMcmjXybuhGMjvoSZ2v55NNCCUBta265KnO0fR9LQU4/NWxbGaJv04t7MItuKGgxSPxqi6
	RL6dFzJD8+giHqquaVFbly1RutVAQG3No/Uit59wUDNNlA3ePQ5rauMocaG4E0/YhCHE9F
	Nmu1kkovm6UXxD09eSWl0IpnaqdTMQI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760100264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=awaJTA4euvd5lWlQz6drPQdT+/x9DxKM967nJbwqyJA=;
	b=TIGYfyQXlEc9HheRyn7V4Dl0en9QAZjlnaew+k2xwodKXAlcbBZw4m3XjtewrzhebirOlB
	XW3YLN9SbI1fGdCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760100264; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=awaJTA4euvd5lWlQz6drPQdT+/x9DxKM967nJbwqyJA=;
	b=aMcmjXybuhGMjvoSZ2v55NNCCUBta265KnO0fR9LQU4/NWxbGaJv04t7MItuKGgxSPxqi6
	RL6dFzJD8+giHqquaVFbly1RutVAQG3No/Uit59wUDNNlA3ePQ5rauMocaG4E0/YhCHE9F
	Nmu1kkovm6UXxD09eSWl0IpnaqdTMQI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760100264;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=awaJTA4euvd5lWlQz6drPQdT+/x9DxKM967nJbwqyJA=;
	b=TIGYfyQXlEc9HheRyn7V4Dl0en9QAZjlnaew+k2xwodKXAlcbBZw4m3XjtewrzhebirOlB
	XW3YLN9SbI1fGdCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 618C613A40;
	Fri, 10 Oct 2025 12:44:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id M24xF6j/6GgvMgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 10 Oct 2025 12:44:24 +0000
Message-ID: <ceb8c9dc-2492-406d-b0b0-ccba3a77f144@suse.cz>
Date: Fri, 10 Oct 2025 14:44:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm/page_alloc/vmstat: Simplify
 refresh_cpu_vm_stats change detection
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Kiryl Shutsemau <kirill@shutemov.name>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
References: <20251002204636.4016712-1-joshua.hahnjy@gmail.com>
 <20251002204636.4016712-2-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251002204636.4016712-2-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 72C6718000B
X-Stat-Signature: bw5iwpj5zdbogdb4q4cedr3mysmyw9b3
X-HE-Tag: 1760100266-332965
X-HE-Meta: U2FsdGVkX19dXz0mFjuzWtpkcAvsX5pxY3uw2vGxjzQ04qWc189BR65QRp0ylMuBYQYU2U62WVvR35I6TkcDVO8xyNE8klisbGeRg38SfSFLinocREsQDVlmJNdrF/Lr+ZNz+LVGIKHK/XzMLcsiFUt+1Gpo79iPIv2Tmxe1iR9wvJ/Ltq2o5y20CB3R+cpW/NrwjM0FJTqVN/tDFG3QqSs2QFho7ju8rU14qEVtfDmFjDM3ylzoOs9zhMzsQpSr3ntOQEbJeA5MnDii//OxZ/0vNRIf5d45aOES228g2jyDZZwEqj/I0qsHkqE6kU9tOdwXeMXC1Qq42aJr3ultUgXSYnL1ybXTFY3gQfpT3h7M4YhX9ZgaF3ELJOWnKKm3NtnuV9eZJCk4IjBR3gF3UDPlOcj+DNyguO8lAb7DljqIHA0WVOS/fYpL5c0U/iuylwQlcNPTqgKTqgZMct+0iUoKTLlKx0u2Ba9ayiNYfkrZBsbYO4jHXqXZy6DRC5sWAt8DdrWWm+3aNQE4p41rMo84VBBEj5NZZJ68RcMBovshRK7I9LVZaBrXFlvI7Ccf34eziLSx6mTBpQgseneWjZ9QSTEU34+7tw58SsP/hDnqGdNX+zYBvdl9DsyOjgH4eHmL/0pCkFsbT1nl9e27rWr5lLG2mm3lLNnzdV8eYP91ptmrVqoLudVs/sumnvRcG1mxHqBvXSbK1HIGdNIMa0vSjzMdYNy5ETFt+B0Not6jKbdu1GJ42mu6gj8GyzsxbLQmSAZ7e5fO9AEfZOmdHgIJlmxy632ozyj+uwwcEDLGhmGvJPKF8PTivApEkdNSzg4bJqUYVSUHxl6qNZxdhwbFdRrmJ2VsFU6tOdpK3oHSgY5HEgicU7PdEwpdImznpLgRcjaIdk9C5xAEymVFuag0gb832W1HZw6AcGKJss3iWZIhfCpUdraM/GiDscr0dbLsEpgCijIyGo3UNHg
 4ybER8Qo
 VyAHwBGS8eKIiOY8dh3+oQgSE0/1cI0S75ytxiiUIuaFOEWpPMLUNm0q88yT0cZnvc3DWco7EWJ6OKDXEon6rGXP2kHez3zgPMlxPUTgE3w6gKovtVoyUtBALrvY1tYPupgDgMUDEBdhMyL6FS3R5urOgM8cLSS+gElGH7lTqJT3GHxpHoFycE/XORDxqISE1+/xLaa21IutWmAOxWLq2zJkUlfky4VSvUDto8WA5fE2EquXWHVI2LfmXQcV0kc8Ob7l+s/PvFbpxkuijK29Us6P/VzsjoeH3e1cF5qhSptyqsi57J+0CtTy1dxAGtM4e7Kn8qioYquqApzk7mf61kl7BlNYnWtlF23EZmEIphvPIj1KyVabSIjesfqoQF5svXL2hLA/sA+sqGx2A/6Imha9pVUFB5s71N5MN73EfI/NbcRE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/25 22:46, Joshua Hahn wrote:
> Currently, refresh_cpu_vm_stats returns an int, indicating how many
> changes were made during its updates. Using this information, callers
> like vmstat_update can heuristically determine if more work will be done
> in the future.
> 
> However, all of refresh_cpu_vm_stats's callers either (a) ignore the
> result, only caring about performing the updates, or (b) only care about
> whether changes were made, but not *how many* changes were made.
> 
> Simplify the code by returning a bool instead to indicate if updates
> were made.
> 
> In addition, simplify fold_diff and decay_pcp_high to return a bool
> for the same reason.
> 
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


