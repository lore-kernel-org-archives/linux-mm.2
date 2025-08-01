Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AAFEC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 08:13:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A48696B009A; Fri,  1 Aug 2025 04:13:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A20516B009B; Fri,  1 Aug 2025 04:13:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936306B00A3; Fri,  1 Aug 2025 04:13:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83ABF6B009A
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:13:02 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 350BF8179E
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:13:02 +0000 (UTC)
X-FDA: 83727473004.04.80AF4BB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf09.hostedemail.com (Postfix) with ESMTP id CEA99140007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 08:12:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qHxSWG4l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="SIuZh/k4";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qHxSWG4l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="SIuZh/k4";
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754035980; a=rsa-sha256;
	cv=none;
	b=RKqQn0+xC6FCFGNtkCXJvYh5cKRkCFgLNByz/BSwU856SoEWmaABxVTUv4ZqIG9CeWv7Oh
	vMmedujNNw0gBjMkyUy8FpSO+wbOlfQlQAbhN/Twt8kqqjjYHV5htSzkQHYaCa38XkU2ug
	p7NXuiPpHnfyThCBGYEIKuD8//OET90=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qHxSWG4l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="SIuZh/k4";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qHxSWG4l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="SIuZh/k4";
	spf=pass (imf09.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754035980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwIzklYubVz/GvYPz2IwlXbYM1AY7MxAqx56MYh3lpk=;
	b=5Akxr9REh+ccPw51CYDkoBm9Vp3B7y3KRuTVO8eRizSnimHyiMPgnlvsz7y3GHcs7JKHXw
	z9g65iGzlUoSGyk1gcmEXq3gNA6EuPu4gwo9nFhMwTRsLb7Bz4Xf2dLDf87z+u92tRzLxt
	rQi8W6YsICKZhxmSVTBOMAt+NN11AHg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5B46A21A77;
	Fri,  1 Aug 2025 08:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754035978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UwIzklYubVz/GvYPz2IwlXbYM1AY7MxAqx56MYh3lpk=;
	b=qHxSWG4lVOhtunEgOG+lOXQhDj90+bIIRUIJ/gvA1/vZlxCPPciEI2T89crwxCAySoWrf4
	03l4pqtkcXHzgsdfj34DNb2L/kMoOCxi7m7xLB1zV2cac/GudccoLJEvzaweKE8Ob4+iOO
	sMfqOcPz9cQ1e+YGvvBf7FPyDfA05Ho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754035978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UwIzklYubVz/GvYPz2IwlXbYM1AY7MxAqx56MYh3lpk=;
	b=SIuZh/k48X1aZC5n/Ywqt5RKbUXPKbevte5ioyqkuYQZz/9f0mk4rkZ8wZ1ZQf5YUITEMd
	n6DHA2Tfgn/wNjCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754035978; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UwIzklYubVz/GvYPz2IwlXbYM1AY7MxAqx56MYh3lpk=;
	b=qHxSWG4lVOhtunEgOG+lOXQhDj90+bIIRUIJ/gvA1/vZlxCPPciEI2T89crwxCAySoWrf4
	03l4pqtkcXHzgsdfj34DNb2L/kMoOCxi7m7xLB1zV2cac/GudccoLJEvzaweKE8Ob4+iOO
	sMfqOcPz9cQ1e+YGvvBf7FPyDfA05Ho=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754035978;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UwIzklYubVz/GvYPz2IwlXbYM1AY7MxAqx56MYh3lpk=;
	b=SIuZh/k48X1aZC5n/Ywqt5RKbUXPKbevte5ioyqkuYQZz/9f0mk4rkZ8wZ1ZQf5YUITEMd
	n6DHA2Tfgn/wNjCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2B5E5138A5;
	Fri,  1 Aug 2025 08:12:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NX07Cgp3jGgoIgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 01 Aug 2025 08:12:58 +0000
Message-ID: <f37ec25e-70b1-4f24-9d18-d869576aa7eb@suse.cz>
Date: Fri, 1 Aug 2025 10:12:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] RDMA/siw: Fix the sendmsg byte count in
 siw_tcp_sendpages
Content-Language: en-US
To: Bernard Metzler <bernard.metzler@linux.dev>,
 Pedro Falcato <pfalcato@suse.de>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Jakub Kicinski <kuba@kernel.org>, David Howells <dhowells@redhat.com>,
 Tom Talpey <tom@talpey.com>, linux-rdma@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 torvalds@linux-foundation.org, stable@vger.kernel.org,
 kernel test robot <oliver.sang@intel.com>
References: <20250729120348.495568-1-pfalcato@suse.de>
 <8fad6c00-9c15-4315-a8c5-b8eac4281757@linux.dev>
 <x43xlqzuher54k3j4iwkos36jz5qkhtgxw4zh52j5cz6l2spzw@yips5h4liqbi>
 <631a1251-5bbc-484d-9bd9-167c5e7cb69f@linux.dev>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <631a1251-5bbc-484d-9bd9-167c5e7cb69f@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CEA99140007
X-Stat-Signature: q5donq9yxunafu3xcjw4b97qzsp7hyg1
X-HE-Tag: 1754035979-785245
X-HE-Meta: U2FsdGVkX1/MkPXb5U/hML0cSJ1ynR8fjdNZ0+y77+/PvsNjfr5dJLoQTgI+vgmSTMV3tFUkGApgif9dHnPDhHNgO0brfRcoJat2TiprvU9Ry409S3/lzztz8vID2mzc22ylfoNulJtPSjPYSCh/1w9PNsmKWPpQggRBkZ6vHJGYWldQVpUHgiWgdLNRCXP3igmsrI8N68PIolVmJn9pVi7S9/xaD0Z/OTu9GpzDmQY0uk/nPC63Hy1rdUcTlSoGemApHpxram2DLNtiA+uDCyM4UPX49wtwKYhLAEr9BCO1TT2UP/w408ydh7UMJcqfEGO1SpWhnNnvLZP+1BuMFKkZe7QV1b9dvvSoD4qInsgCChBMRHJlxspDPw8LgkhEFS/ZQO40TGm5IE1HD2s+t4UWQ0bT+8cEVPCOrmL9+RQ4chp3KlOQjO3KkurUJtIyRi8fdOOHtqrRYazuF3IPHvXxzTl+aPiQagmgyZM4IpJfAcvLM3TcmUaQmgjJ8TyE3h/L4RdrgRTndfcbDcf/WW+htHep79Uss5U3dk6oopjSlw+xck51l70rTZMbEeI5Ugo3659ffTH3MWsIM8+dkwO6LW9Lo9j/i5k58SAGQZfZXOCLxMQj4fFfTzxnSzlf8FM3tTHwsQJ3bDVGLmQ+vjIpF8L7hEPbfTlRrbdTSc9kQg+nzngxNZssiSXHxpa53F3YhOteRcsgFhQ6SkFNri7TLyCg4Ld+nH+QLbPIfLygatuPN8eywWgjNH4fYhEfkaYugcNS0QnAPPaVpql48C1KIxqdxOpidHMBM5MLilpRHgRTHjxazEp8n3MbdJBmdnPYp5yNvOQAdMbUFHDNW5K7qR5U9N3xUmdfbGzy7uQKATbQ8LBIifa2n81k1JE5WS715lXkQ6AmJWo/IFZNjsM/KjCl9i52fy8maMOq18tm2eYclDBfePRXUHk9BPHgXAEPPbb75WOGwIO46m7
 NJrR44bV
 +jr3hqV+qdbli0Tj55is/ajD38q34rjXp3N8a3BszVnE3CZNwuLlbx6/yBp/SSVjDQDJ5UicX7Ep1i3lq6AKDn6dgUcquYoI2yEccFYhwP/RoR3596hmJT/63PdlnIQiMKr5kgNTap68Tao29jLu+DU+fDiEgxw3Qn1iNk81yR+bba//nofH8ohZT1gdrxMauuof5ld3b4IKi2M6HnfCK9cwNjEoV6TXJHojMqeCRxvu4dN5Dc9U1Ey+dGYTC/U8Hs1B//BeFMFqfcKlcL63t4IZhlkQlwvIAGMhA4l6cAQHT7OK03DEq6qTh/IxYt2jLqrAOtaQMxZ9/YvrZgQ0C5LDbLudgzlWvWBbDxTVorduuFosJpij8o7ZhIpGHriqZelUA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/25 22:19, Bernard Metzler wrote:
> On 30.07.2025 11:26, Pedro Falcato wrote:
>> On Tue, Jul 29, 2025 at 08:53:02PM +0200, Bernard Metzler wrote:
>>> On 29.07.2025 14:03, Pedro Falcato wrote:
>> Thanks!
>>
>> Do you want to take the fix through your tree? Otherwise I suspect Vlastimil
>> could simply take it (and possibly resubmit the SLAB PR, which hasn't been
>> merged yet).
>>
> Thanks Pedro. Having Vlastimil taking care sounds good to me.
> 
> I am currently without development infrastructure (small village
> 
> in the mountains thing). And fixing the SLAB PR in the
> 
> first place would be even better.

The SLAB PR was meanwhile merged and Jason said he would take care of
sending a PR with the fix:
https://lore.kernel.org/all/20250730184724.GC89283@nvidia.com/

> Best,
> 
> Bernard.
> 


