Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9CC4CD5850
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 10:35:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 370156B0005; Wed,  7 Jan 2026 05:35:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31E206B0092; Wed,  7 Jan 2026 05:35:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4D16B0093; Wed,  7 Jan 2026 05:35:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B7DF6B0005
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 05:35:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A6B338ACB4
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:35:54 +0000 (UTC)
X-FDA: 84304812228.13.FFE488B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 263AA1A0006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:35:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jKIozLfd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ojzMTDPW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jKIozLfd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ojzMTDPW;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767782152; a=rsa-sha256;
	cv=none;
	b=SEyLr8peTZJa4J5S/5bzsO98bSY6EueKlGWyXDjL2ExeqksZo8JEy7KLVcFDlrb1DbF9LG
	i4NJt8Yp0OKrMvzioMG0+n9QnYoGzrKYmDnoRFaqi8CAai8guytZpxKC68QlzaOgil/Vh6
	dGCaOYi+tIYHKRLBowyQW2ccn3mQsqM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jKIozLfd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ojzMTDPW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jKIozLfd;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ojzMTDPW;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767782152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MVyM2XgYGhqfYGvDWNK+u+Qx7/DZ4pq6Y1t/ykpduTQ=;
	b=FBzmDVxbAEHi5Cbtyc0RnG4c29GNaG+yt6eyGjB41EVwMcoA3BBjyIZaXcz4jHEz0iBCq2
	hi/vJ03NQqr/Q70PAWicrFa9UJ8J70aGIOFApeC6gcGPcsmNwM8TwFwfK9Jft5h4lR4/wA
	K81UmwIm391l/aaX5IiZ5KcfW/cc/ns=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4EAF933CB3;
	Wed,  7 Jan 2026 10:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767782150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MVyM2XgYGhqfYGvDWNK+u+Qx7/DZ4pq6Y1t/ykpduTQ=;
	b=jKIozLfdcUmDI9dILfHVBZ4Ory6Hn7aKUVWmFErSyrdmTtHrrl6UXxfh0/LbOl4VcC2SfB
	yvVgA3CD7lsBe7xYoIJvv7v6jqF7+Sao72vXPmRq9KZFs67/GFHr9Wj0MD0Yz9TNyeR2z7
	winRwJ+7Y8VYeQrR6wNmTgI+LXTUNfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767782150;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MVyM2XgYGhqfYGvDWNK+u+Qx7/DZ4pq6Y1t/ykpduTQ=;
	b=ojzMTDPWo5RN3Sk4j83BIcwsRffBJr6QKtAtCXju11KrAmOlaC+UPk1ml+WzvYxcJJ8IOQ
	KmU1ldnle6vLpTBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1767782150; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MVyM2XgYGhqfYGvDWNK+u+Qx7/DZ4pq6Y1t/ykpduTQ=;
	b=jKIozLfdcUmDI9dILfHVBZ4Ory6Hn7aKUVWmFErSyrdmTtHrrl6UXxfh0/LbOl4VcC2SfB
	yvVgA3CD7lsBe7xYoIJvv7v6jqF7+Sao72vXPmRq9KZFs67/GFHr9Wj0MD0Yz9TNyeR2z7
	winRwJ+7Y8VYeQrR6wNmTgI+LXTUNfQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1767782150;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=MVyM2XgYGhqfYGvDWNK+u+Qx7/DZ4pq6Y1t/ykpduTQ=;
	b=ojzMTDPWo5RN3Sk4j83BIcwsRffBJr6QKtAtCXju11KrAmOlaC+UPk1ml+WzvYxcJJ8IOQ
	KmU1ldnle6vLpTBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C0463EA63;
	Wed,  7 Jan 2026 10:35:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RmpJDgY3XmmdXgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 07 Jan 2026 10:35:50 +0000
Message-ID: <0a2474ae-013f-4c9d-b70e-5461367abe6f@suse.cz>
Date: Wed, 7 Jan 2026 11:35:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] slub: clarify object field layout comments
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, akpm@linux-foundation.org,
 harry.yoo@oracle.com, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251229122415.192377-1-hao.li@linux.dev>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251229122415.192377-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 263AA1A0006
X-Rspamd-Server: rspam03
X-Stat-Signature: 5ex3hq4yy1b4u1hwjkwactshpm4t1jbs
X-Rspam-User: 
X-HE-Tag: 1767782151-311546
X-HE-Meta: U2FsdGVkX1/XMjcpFBhKpRiehi9ehQO3xX8KpqRrJLAub9DxnD+gifqNzewRcWKe2K3Ly8t5d7dS7v4jA9ukuIeMacWZwE7mYFvYPipQJQgYzRnievIKldRA/4mreIkjUMsI7jl6tF9bbYjzpB2cYym8MKxE9Ns01JeSxB50Kc58P8EiKUbm1lQmrbvMbeUupFcl4BmKgF5VPa25DbnCLUJ9+OeEnlbkjqa5e5ErqyA2DnKjPIkAl22xYeCFRhySZ268wvDMMz69Y85sozQLwXmtJiDi462FJFJhBisnwoWsAh9bw71HTohlGbGNWwkqkAXPydq4tpmgNFnkIBMj+ZHamPXWBX+8fF1t389CpE8w3Bg/QBOInBfPZdWmDwJRKxwoUcRRTMNznZNvX0gq88zhcJz8vwGeS7fACZcmDA5gUXLcYB1w/6mEmHiOGnxq3e5dpcZ6GvyZl6mSLBSPYZ+HHptQzEXTwpUFaTVtsljYqYu91T9FLO4yJiUaX3/fI//TCd4a9RGWHCEfQqU1NC4JqycEMSs+EV1soWnUA8oPTsHUy4BHz7P57GO5UkFmzdYxVyd8LT6fGnRLIFFpPkOQCvM14x7iGoffjFJ2VzjlUlS83mBf4WBIuOLKIsj+Y+sFQ1vWBweDn7/E7XQMb0SGrTvLLTaZ1CoU2pcYLeno1s0Pd9rF+wbc2txVVqZNTSovkJ8h5wrPVEPm5qaDavSbrYTM4rMtZucJ6hbooIIKJSeBER6jOookxK4zxUMkdnGTc/gob0/lUBpl2j4TBzBL4FCbOK1NFLsoe45S7FobGdXN8FgBtR1nAHotdTlxESDxZ3F2EmNDgBvA8KtX7HwIHi4Chnxnq1OaAaoJHLv0+xqXEMkSEqQC7ixX8FZ5IfuR+SMc+Y7tKX2JPXlllZZwX6izQL69Uaomao+JYDFoWg5FVSkORKaiix6meD6FBXLVtF936CkxV5cxDnD
 77XGJlEx
 8thmpkiyC+g8Vn/5cYnZv8AUzA0VVdr68yeFc55exfxAIc1VFpVIl47jfoE5sRlRozlPajV4C/T7sMMnKz/IVDmyOhf87pwjrbWgEiEwvKSwC2u+NLfvPkhcutvX34y5RSrww8BA+Ou8joVOeSlKg+84bVDAQrHcY4F8krV2yd8U4TP8H6WtZ+WPM2zW7wCsFjYvfVE5vGhu6MUwemh0xMjeL+oOkgvnyDswDQaWeicw2p+APzgnNRUFdA4li1aTwfpmdhN58n8stOn+ExXUpr7a9xZsrhYr0KYOvCp13zpIxcyyg2cj+6w0l1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/29/25 13:24, Hao Li wrote:
> The comments above check_pad_bytes() document the field layout of a
> single object. Rewrite them to improve clarity and precision.
> 
> Also update an outdated comment in calculate_sizes().
> 
> Suggested-by: Harry Yoo <harry.yoo@oracle.com>
> Acked-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Hao Li <hao.li@linux.dev>

Thanks, that's a great improvement. Adding to slab/for-next.
Wonder if some ASCII art diagram would be also feasible to add, if you feel
like trying :)


