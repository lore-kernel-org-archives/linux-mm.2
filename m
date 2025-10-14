Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F4BCCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 17:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBB798E0125; Tue, 14 Oct 2025 13:54:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C2E8E0090; Tue, 14 Oct 2025 13:54:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A82358E0125; Tue, 14 Oct 2025 13:54:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98B658E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:54:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 367CD474F0
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:54:34 +0000 (UTC)
X-FDA: 83997469668.12.A8B9095
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 33972A0004
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:54:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eVKalihs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cBQpJMsk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eVKalihs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cBQpJMsk;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760464472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QiBAGQLyoWW3oeRVkn6HlA7gLuJxSljEXYQ/53OV4P8=;
	b=1FyihwffJs/VZUAhi/4A7O0jfkzrjr23/01Anh5foQr9po/u2k1eKEu/dQF14jV55reqzx
	M07i6NBBJWlf+QaLHfnEA0Llzq97AopWGN5Jv7AKv9p4tWqT/OdBX9rxjmFT7/l58KKrpp
	K22TEFSW92zI6xrblZL+sxChKl4ku5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760464472; a=rsa-sha256;
	cv=none;
	b=vVjgSN9TgfJQmoBNiZJmE6VU+JaWw0AvLyCWMVxUBp/SHoeywjtzTDZYOtDKp78fwMp2sa
	6bNtZQX8qORgpsDwrpn3dpEtrPUVbrHrdKcakcxmDQiEB6jXhsZSeSMTb0LSgAP5nMlmMe
	rzogxlWnXlorrhissOFz5tQj36/cBVA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eVKalihs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cBQpJMsk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eVKalihs;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cBQpJMsk;
	dmarc=none;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 78F8A211E0;
	Tue, 14 Oct 2025 17:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760464468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QiBAGQLyoWW3oeRVkn6HlA7gLuJxSljEXYQ/53OV4P8=;
	b=eVKalihsRfR0MBrM2iETQ0c2yVTPSkoLMHPQzqjjTY/khP4UhA1qElxsj1pbkD+yuc0ucg
	VNZRZ195OORXkj/KQDZJJnPDN9pFs5PMNetAuub4fOPs1z2YwJSD/5Pk0I8wlZ9wgIKSX8
	jgoLyPthdofGT7sN+gy3+G2mrtnqRgA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760464468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QiBAGQLyoWW3oeRVkn6HlA7gLuJxSljEXYQ/53OV4P8=;
	b=cBQpJMskKBQA1SRPwwUAHHXCBvwRjgV64eRZqpWk2DeQ4fC9E5xzsuerIP9lHxTkUwB1F+
	/P28iVKuAjYtolDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760464468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QiBAGQLyoWW3oeRVkn6HlA7gLuJxSljEXYQ/53OV4P8=;
	b=eVKalihsRfR0MBrM2iETQ0c2yVTPSkoLMHPQzqjjTY/khP4UhA1qElxsj1pbkD+yuc0ucg
	VNZRZ195OORXkj/KQDZJJnPDN9pFs5PMNetAuub4fOPs1z2YwJSD/5Pk0I8wlZ9wgIKSX8
	jgoLyPthdofGT7sN+gy3+G2mrtnqRgA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760464468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QiBAGQLyoWW3oeRVkn6HlA7gLuJxSljEXYQ/53OV4P8=;
	b=cBQpJMskKBQA1SRPwwUAHHXCBvwRjgV64eRZqpWk2DeQ4fC9E5xzsuerIP9lHxTkUwB1F+
	/P28iVKuAjYtolDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4F506139B0;
	Tue, 14 Oct 2025 17:54:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZxYGE1SO7mghQwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 14 Oct 2025 17:54:28 +0000
Message-ID: <6d62386c-242a-4735-add3-fee9c6e0ba96@suse.cz>
Date: Tue, 14 Oct 2025 19:54:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/3] mm/page_alloc: Batch callers of free_pcppages_bulk
Content-Language: en-US
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
References: <20251014145011.3427205-1-joshua.hahnjy@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251014145011.3427205-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 8jrqj34o8hg397ogwub1ymmm9fnnczkg
X-Rspam-User: 
X-Rspamd-Queue-Id: 33972A0004
X-HE-Tag: 1760464469-205379
X-HE-Meta: U2FsdGVkX1/i3x2MUFX9xQcaBzOWLGGR/ZR/qJGXrxUpjFI+MdGxvT24D19/GkSK3dw8Upvi/KDevqSlymd91TG7ECrREXeNSIODie8MIg6Xcd+KkIcw2uLdwOoM1wSGW010awGuEZzXkKlKyV57neO2aV8CgnSE/mW7pzIkA656dL3VZlbiQR89RUVDNr6AVPYvfmqED/8AcJwSmofxqYIYmxoFkEqUT/1tPGGbxaw84Qze5l9SrhYi6MV08G/FbeD7g7Gnp0mnAp9Z2/SsnvgK8RO82mewIPQNC948hESViueHbpKsWC3L4D4s5nSP9XqoM2KSwtz2/VKNh90hHFvlUFNGp6GdRytDmdnH9UcTS3+VHHH5Bsvl4OzwDptXkERTSk9hJwPlq4cjRhVCzVA9Ugs4WJqxAMG+tZgjnemctqps78yAg+LzUM1SXLo7OqLZqomTiguj/y2Z6HWLg+E1lJUgt0gyI6R525A6aeETM5Aln+akCbJv/o4aJNJ1LC5x9QzI7H0dg81W8xlYDoMItddxNmvx+em9Vcfike6dTpcvghKQqZQxSSixbUjtCzd5wWVA5jg+a6aOQIBiwoBsDsR/uxMY9cKPbq/GceSQvcFEfjQmo6TW9lQ+I35YJZBAD3SKhmJzfo2kp8JKRHT7NyRtZKvhSrCdEBG48MDAvBIe65bRck3oyxLp7X9NsINKAD4raPiP6hy1R6CrHrdBbyi20fbtm8qrXRhkgn+IYSCqW79qg+1sLaiWICaZtlsLQ4oHP+x1mObvexACwaKust2Snt3/KTVVKM4inTA8oLTuA/lXOtVOKcTQwiToFlCN+LmDQTgYsRndg6yg4pPR42rRZQY2CaT7FTK4cAeFhZLiWSHKgPi3fFZMqSfMsO3ELlSxYYRc5NywtKTxYWvC6htC6udM70axAuja3c9wApY1uJ8Kex13uEygvGCazkk2dvlMDpBHCeEj5IF
 3tOl7+mK
 nRgkKkdXmvjOAn+2BEOTjF3x0zSJp/WJ7/SKJqY1ao3DBaalfbKPNE7HQ5V8QyRfEsIVHQIz7RnWHHf4tTPiPsdvK41eNCYbakkdJjKRVQBVERApBQCF4/0u/tDl46w1G6Y1Ha+F3w9LtviPujsawAnFPTKwHs3GDovn6OQhHOzF3oumMv3c7Z88/N7jRIRFTrsRX/qoI9ExKSF4GGt3yF7AU5144fueuN1fjgHDbKBr56MOTUJE5eMcFpvqIkqDzg2H8chFcsrP37OOAwsE9Uw2OF1FgEBr3QGBz9A++RGtRPkUOCDa3RnYgNf0XEkzdR8ielofSUIeUfm0VLmfg4+p6bAIWaKFjOOpTEMgt/57dEIkdgaLBM1+MsWkeNZS+n+wvkhDOi+57HcVuW5QkGx6F9Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/25 16:50, Joshua Hahn wrote:
> Changelog
> =========
> v4 --> v5:
> - Wordsmithing
> - Patches 1/3 and 2/3 were left untouched.
> - Patch 3/3 no longer checks for the to_free == 0 case. It also now checks
>   for pcp->count > 0 as the condition inside the while loop, and the early
>   break checks for the opposite condition. Note that both to_free and
>   pcp->count can become negative due to high-order pages that are freed, so
>   we must check for (to_free <= 0 || pcp->count <= 0), instead of just
>   checking for == 0.

I don't see how that's possible?
- to_free is decremented by to_free_batched = min(to_free, batch); so it
can't go negative.
- pcp->count indeed decrements by nr_pages but it should be exactly zero
once pcp becomes empty. It's true that internally in free_pcppages_bulk()
the count parameter (where we pass to_free_batched) can go negative, but
that doesn't affect to_free_batched in the caller free_frozen_page_commit().
So testing for <= is unnecessary and only looks weird?


