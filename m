Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95BADEA812A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:06:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3BB26B008A; Tue, 10 Feb 2026 10:06:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE8786B008C; Tue, 10 Feb 2026 10:06:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCAAF6B0092; Tue, 10 Feb 2026 10:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC7FC6B008A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:06:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F8798C063
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:06:08 +0000 (UTC)
X-FDA: 84428872416.02.3F1A499
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05FE8180017
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:06:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CPHUk0Hf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3LHBHABW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CPHUk0Hf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3LHBHABW;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770735966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ol82LLZH5V29RbSzfWc13E4nnPF8saO5omNFaIbCybk=;
	b=mgqjI/cPS0r7hmAWTN81kiE+N6cEs6YoTqNcrIUx1Yk7zt2RF9K1LKKLJSb2IJrhCStgXU
	tBOCxJZjUFQCiWIfutXpYYsvMxvYnQh5xo/+KOXkL7Xv4FpQ0LHXMh6+fStF7IdeaiXKR+
	Tw+gsNa9xutHg4d2gnsLzUkOcrV6SBI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CPHUk0Hf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3LHBHABW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CPHUk0Hf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3LHBHABW;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770735966; a=rsa-sha256;
	cv=none;
	b=EJy8VY4jZzyT6mvCjYVHkkjFi4FEMeiacjH9zFcmHjXCJxyIgZUj/ZRxosTQYKuPfye889
	TiTZ0AkspXscKV8PVtiU7JXheDBh40mEMR8yv7G4x/AUNnphlVsXQ9j98VtyF/e1SrwrAt
	59FofPn5iWat1MlPwNVfacoFHWDXXZY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 837043E71C;
	Tue, 10 Feb 2026 15:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770735964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ol82LLZH5V29RbSzfWc13E4nnPF8saO5omNFaIbCybk=;
	b=CPHUk0HfVZmqMat5wYRSNnqyitz4vsV2uWllTwlzrcPF258jA9+iAkE7Tf0xVoGJDBBdcU
	T9Lw+0emBAFKHVl3oSGcpNEKWW8lW8FzEub58RGYjhmgfQEP4DZNKofzMFhRtoz9yFtQ6C
	45M7GBa+9uhKQc0pwcvs1yF9ErRKCwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770735964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ol82LLZH5V29RbSzfWc13E4nnPF8saO5omNFaIbCybk=;
	b=3LHBHABW8+md1RPXhNWocRi7FSVTGhWqVkxXm8D9V+9KTe/ioSLsbTj6+qs1cVAny5IEWG
	Q3puUYDYCSvMihCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770735964; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ol82LLZH5V29RbSzfWc13E4nnPF8saO5omNFaIbCybk=;
	b=CPHUk0HfVZmqMat5wYRSNnqyitz4vsV2uWllTwlzrcPF258jA9+iAkE7Tf0xVoGJDBBdcU
	T9Lw+0emBAFKHVl3oSGcpNEKWW8lW8FzEub58RGYjhmgfQEP4DZNKofzMFhRtoz9yFtQ6C
	45M7GBa+9uhKQc0pwcvs1yF9ErRKCwE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770735964;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ol82LLZH5V29RbSzfWc13E4nnPF8saO5omNFaIbCybk=;
	b=3LHBHABW8+md1RPXhNWocRi7FSVTGhWqVkxXm8D9V+9KTe/ioSLsbTj6+qs1cVAny5IEWG
	Q3puUYDYCSvMihCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 404BF3EA62;
	Tue, 10 Feb 2026 15:06:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0/HQDlxJi2njUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 15:06:04 +0000
Message-ID: <4dd46022-b534-4aea-889a-03a7ac25da22@suse.cz>
Date: Tue, 10 Feb 2026 16:06:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 02/17] mm: Change the interface of prep_compound_tail()
Content-Language: en-US
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-3-kas@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260202155634.650837-3-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 05FE8180017
X-Stat-Signature: idibeknpsc5kpwuignqgqoyh76b4byb6
X-Rspam-User: 
X-HE-Tag: 1770735965-212144
X-HE-Meta: U2FsdGVkX18HJDlCUvG9y0Y305sG2UFtI5eHuNNFeXaobHPoHgOgd4kcYBYOUUnV7iQIoYoN/8NG0DHXkzynVcTZ2uwfDJNpIvZ8KsLVHu/IJpP4lBwjzRI6wo4Dtpog0POL7q7mffMz77ouh+FeM/GsbkyWmpxl9BKQpX/2TMcecThD4dyJMMKXXaGu2SEEDEec8LSLw++rIobT4EoiyoOoR6tnpSNXGpF9xrV3n5lvKiAK2hj0NQsEDukz10tGqj6co61IUp+NDxi9NZ835SDZdwl0MMzoJ3ZowiHdZjPNRDG+wWdT9Ut8sdUvT1qFo9e05us8VAOBPKR0fGqaNRKzX/OLwKF929wvKz/NKEzaJU5mtPMp0psIbeOVFpeOmaxXssgJPaLRogCOCbmWownHNLHmMsYW3bmlS2gVdaiQ2oUC3EEh+dWas3YZgxnPWZQQvs6+9q6xvGp0Ojsb49KR0AKdohMG9hdrL5YJHrLYIv92rfqOmU34MKa1snV24BbdYQkCwTGqo55VG2eiZsHtmSBTvEegvNohAAZmO+aDe2EMiIVZ9OTidlTGguaj93qJa1tPTws4cEi+vJrf0OBxPO4xTQmtJbA61f71JX1X/Zt/dosqS85MU17aQuLTseSRiBsLrpS/grIOk6lIhzsLxTDbMWNr+MzUu4xnxAuyLYlPeVyb74xfZ/GpV5aOu3mO0J7HcQDu9jErQir/++s9Py+G6P3Ns9Nwv75huWscEjEUhJEoZI4yywTmrY9sncR/PaK5cMfdfr5zMVIyKXQ34q+uWC293VRFKrXBD2Iev8dhJhJtSLAw6Y2FfNYC5BFvk8koe/mcuKtePof6YlYkqqth9NzonBY2dg5pqBCpLPnj/0I1UchaZmAYrU1Cuvml9R1HKTkyp2OI6Tif9JC9WkUWJY3JM2oeZiXvPT/lgNxV4WBeQNhBLfFH9hvxaiS9TN1v+1wB9lcliNR
 g031dSkt
 qLmwYWhyyLE1ODPPeZ1CKwhIMzYCwY9JyfqI9OStWYvVkgOrHwlKL8DIkkkfCEI8sqZF6+mdEuDf3dD/aAaJ1EisRIxPTC6HR1khaD9Cewl0X+Gsby8Pqm3JM8+AcTsXRHW0a1a9IuK7zuhhYqg+w5JoUKk5DyhLeqAnRGns2OGSVJjnKVlIp+FoMTir4mV5xJ8o+NlU2wOvmXTos/t/hs8jIun3KcEPn96ih9rrC+iBxXfQGYM79qIzQNHOICjIXOGMrWjSMW5R3IjSmTjkDSIfaZnmj4t8+T+TosM/odSJhvQu6MFgt3l4y5VaPIip7Fh4w0NP7cMaCqhdt8O2UfwTubJxJyW8tfIWWbfloWwTOIdwj97uAATAsMN058/obks7b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> Instead of passing down the head page and tail page index, pass the tail
> and head pages directly, as well as the order of the compound page.
> 
> This is a preparation for changing how the head position is encoded in
> the tail page.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


