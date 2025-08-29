Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C471CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 09:30:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7ABA8E0005; Fri, 29 Aug 2025 05:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B522F8E0001; Fri, 29 Aug 2025 05:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A676C8E0005; Fri, 29 Aug 2025 05:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 975608E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:30:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 38815852F6
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:30:22 +0000 (UTC)
X-FDA: 83829274284.11.7959B74
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 943DD140004
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:30:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yMdV7Phy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3rpaHY3v;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nzdDLAyh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="tNkPe45/";
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756459820;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYiVIHcWw6mnPlRfb7Zz1eL2ghY5CnwDBX6oDlGmM24=;
	b=0og9zVK+WLG64Zud2ZBJID/75FYiHhNZH9tefz71P5DnCzCVOF7TjOKCfhJVJ5mrcEF828
	XKowHZDdUzIqYbpv0Bu49Hg4TQdGO6K5NhXSL/0z6RWRK2sQunFRs1s422P0AYajC/2pL+
	hd0T1BG//zhnBvGn5vh+8rixe5GS1OM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=yMdV7Phy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3rpaHY3v;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nzdDLAyh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="tNkPe45/";
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756459820; a=rsa-sha256;
	cv=none;
	b=bCve1ylWoRzY9rKwtdvt9UbD+cqdjyTxv2V5lEAu1YX9zxid6PkZEutr92wMbvdDWEfE1n
	Z5OxpL7hPMeKwWWNtUl0+4PP+5YNigtlw82QIee3xpSp11iIRvcoulBvSZ8ElgnWqUpfXy
	StbuIcqErPfaUcoJPRBVRqi9YBp/Ek8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D157B5BFAC;
	Fri, 29 Aug 2025 09:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756459818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eYiVIHcWw6mnPlRfb7Zz1eL2ghY5CnwDBX6oDlGmM24=;
	b=yMdV7PhyDr5JWHuy4gjC5Nti2VzZ5xF39BYyeQRD5pu86lAAcUMv3DPf1vlfLIgEo5Y30B
	tgJE3Stk6/w7MZEe08F0cAJapMGFn0855XevjMSsmYYHWeenv6Oy/x0kmMB5lJBlaAJQ8y
	3JnxNRhzQcYKZ29xBatbml5zjki0pqA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756459818;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eYiVIHcWw6mnPlRfb7Zz1eL2ghY5CnwDBX6oDlGmM24=;
	b=3rpaHY3vo7z4SzBJUnKbGEgxlf+mTLm1q1o88k+9I8j7Dq0WNRKLT7oCcpiGByHjiKDIpj
	MlphF5ytIJfxW4CA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756459817; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eYiVIHcWw6mnPlRfb7Zz1eL2ghY5CnwDBX6oDlGmM24=;
	b=nzdDLAyhbSL/GEI7UOaoM5IMyBDkRkl2qwlqkLvTzEnQUp3A/orB479Z4G4XcDuc528KMK
	RW0upTdNWlgYxXKptcBnMJsPXLenRXnUh6ePqVHkl9CNid9Hm2B3+cdFR/yE+vSp/SPIOU
	mc/7BTlfkZqWdGt3H2SK9AE/f42GX0g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756459817;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eYiVIHcWw6mnPlRfb7Zz1eL2ghY5CnwDBX6oDlGmM24=;
	b=tNkPe45/T9Ca/TiKIWJD6vAZLaPw5IQOWCfjfrt84dDi0oVUr4Rrlr5wvijw2f8iXNX/8Y
	TLkm/Hi/zz03FYAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B36E513326;
	Fri, 29 Aug 2025 09:30:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id khpaKylzsWgdNQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 29 Aug 2025 09:30:17 +0000
Message-ID: <5e3bd766-0845-4d7a-acf3-1493eb925451@suse.cz>
Date: Fri, 29 Aug 2025 11:30:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: only set ALLOC_HIGHATOMIC for __GPF_HIGH
 allocations
Content-Language: en-US
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Mel Gorman <mgorman@techsingularity.net>,
 kernel-dev@igalia.com, Helen Koike <koike@igalia.com>,
 Matthew Wilcox <willy@infradead.org>,
 Thierry Reding <thierry.reding@gmail.com>, neil@brown.name
References: <20250814172245.1259625-1-cascardo@igalia.com>
 <10cdada2-f28f-4868-b821-4a13ed627e76@suse.cz>
 <77058118-b481-4c45-8f86-d9a67ea6a187@suse.cz>
 <filznxw2rq5ylpawl3auho7luiyaqxkmitf76bbpxyihkbkw43@pos7qfwb3i56>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <filznxw2rq5ylpawl3auho7luiyaqxkmitf76bbpxyihkbkw43@pos7qfwb3i56>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 943DD140004
X-Rspam-User: 
X-Stat-Signature: bkpnatybq9ooaxkmfjazw6559brb8mgc
X-Rspamd-Server: rspam09
X-HE-Tag: 1756459819-759632
X-HE-Meta: U2FsdGVkX1+BI3pKVUxm+4Zify8zmUfcdTvGbzVcXkpZL0lvQURo8xO1+7unH3ZqkTkO49CJ0QKJEIAOTH6GqDb0BSpql9FyWEzBuBQKg76C7cR5eriVTdEZH8vmC7KGY7/e/3O5kSsmkdQ42lMooJk4zrDLjVvliAR+peipUUWM2ZgZJYT1CDYUpBo+EP2+7ElzSZU+hmgbspxztS/tNJf5nJ14CV5HYkXjl4Jagfj1d3b4QuRbIO/7amV/qyBznxB0nrDUi78ZwxRtrLE5uLz3Jogpy2wwL6kMtwd669BVnk1xAgHCVcOjL2du8XXLp7e9CM73rK9V3bk6YRa2Z6SGbZvyBRK/tlVOlNuqWlOJqaNXkKab8Ieh+HOU13NzJYzjCzJT/eohXyXoIKTpsER3UYBymNo5LzXfQxnHTACBhFwgqN9SLhcdpK4GjQcDsMQOMmq5Zv0wNY3aFyDrWuqEzcEA7Go/pIUD3hEX8qljow+4tgw4GH7VwIG40pKUL3/LkT2wv7eaSdi7TF3HjqwMBrLmZln+D5k6V/IqmiXwmHtIL7v69fA+CcPvuQDkuHlY35/HlJu5qpaLC52/VwtHyZq72nifebL/8BG/VHlqPT6T1C7Ve/JJ/PKQ38P6MnXoQPny0WZ8zCFKass++qoPu5+xQ0nfdxG7eDrAoOiLBz5ZeT64meLB7zYr59vmPy5HIRaCJan++qrMDTe0vD0lraQincMrYZzUjq8N9rc95Z1wvc/nUHpZBKwBjKKCh/vT97COIa+H5i/bmT+MdylJ+i7slfSzy8x5ry8QaP75Q1XcLq5VanpO8AJrJ1K5C/BWk1A1rmrRNdqd+X83gLyedA7kMF0xQGY9aZ8s831cd1xkpjNQx87su0hCDwGPogCcVnuRFT7jt27Va0XZ/XgGqrZ2MMMiJjc2FjbIK5B8JJHPXPY7UETVRDTDhkVHdKWOBpPF7ytV2VziQDc
 5jUAcxpV
 dexFz1N4C47AthvlMsdSUFdFvTeOFMa1TiHtZENmDIfM7caiqcSAvVmVkbFIXWqxOoftVLD+qJivSZIXi5XyjoQlL+69gLTRpWr4pJy2Ej1OxhkHLVcJJaFQBw2G1Dx8JWTNgpJyRTbYTUGcuki4XSbnpBsvaMXUGhrGEvU5PEmG1rr1irm6R+yx8YufCjnIe3Psr9el+Co9gfRhZjr5+2bSfX9xbMV0Sh8CPSlooajzw9bEnxSRMqmncHcuDtpoTJrooLSZKiDZOlZdDlDQ6YX+JGqGVjr3awFmDdTNkoe5o6J3KP0PGThybCgt7Pd6IgeeDIkUP5ZAmARNdeuGor6Zxo/r078eEVjG3kWL5Xcuvry72R9uzLgBh7DoJBClcCkcETDXbJ2n+Gr5PYP65pyng16dSJN6mQeXxgM9jNU/Md+yYy6WxBFCesMeoNkWea/6lI7+IOO+J8LU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/29/25 10:56, Sergey Senozhatsky wrote:
> On (25/08/29 10:38), Vlastimil Babka wrote:
>> On 8/29/25 10:36, Vlastimil Babka wrote:
>> > On 8/14/25 19:22, Thadeu Lima de Souza Cascardo wrote:
> [..]
>> > Agreed with others that this change matches the original intention and it
>> > must have been an oversight. Also found nothing to the contrary in the
>> > original threads.
>> 
>> Oops, forgot to add
>> 
>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> 
> Thank you!
> 
> FWIW
> Tested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> 
> This needs Cc: stable@vger.kernel.org  all the way down to 5.15,
> as far as I can tell.

If that problem bothers users of LTS kernels in that range, we can do that.
I wonder a bit how it was only found out now as a regression in the
browser/desktop environment test if it's that old? Is there another factor
i.e. some new frequesnt source of allocations that trigger it?

