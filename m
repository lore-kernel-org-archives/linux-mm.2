Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E17CD0E6E5
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 14:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33646B002A; Tue, 25 Nov 2025 09:00:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCAB6B002B; Tue, 25 Nov 2025 09:00:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5DE56B002D; Tue, 25 Nov 2025 09:00:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90DE86B002A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 09:00:58 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1705E16017B
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:00:58 +0000 (UTC)
X-FDA: 84149290596.28.8C287B4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 43164C0025
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 14:00:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Zub+aUB7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=71VH94Xf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Zub+aUB7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=71VH94Xf;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764079255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+CiDYHXbpxplZXQ7tgsjF9iqjlg0GbhjXyIyaHRWFM=;
	b=5Rql/w1yYgK+H4xnsspVhJR45eovuhg7D85oPagQktxQea7a7bJyYws/C8N39bkmxXhVWh
	2FS3nSsYauAHMQrIRiRUHjI+Yz2ba6tbCsXxjkX3L+2gEpTTUpRKOitrCnnErUL9pCh9UE
	ch8O5R+zZ9/O1kbSvJw4hrxkn7dWBUc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764079255; a=rsa-sha256;
	cv=none;
	b=C9izomGbNxHAlYRCgJFrtF7FSCxig8IbXYz9B5mqaGCQG0wi9WgZ5TzjO74utMrbLgir0/
	wqqCfMAzcL9d/0aOgDXrJdOdZlcZ9MQvCfjlws3lCl2I77JjljgP5KkuARZSuIT6Lf0ZWz
	OO6CWvWjFoMJrQWGXELvjuJRYYCZ5PQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Zub+aUB7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=71VH94Xf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Zub+aUB7;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=71VH94Xf;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3675822785;
	Tue, 25 Nov 2025 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764079253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A+CiDYHXbpxplZXQ7tgsjF9iqjlg0GbhjXyIyaHRWFM=;
	b=Zub+aUB7tad1dUhZVJ/t2UH/LA1MoM20sAS0uBief8TQSpT2CVd8BFPdZ3ru/Pdt9sxTgW
	z6LdsiJDWAB5mG/pbl8yqPOFsvEomXOFzPMVqyoKz8DioE8kR5OxK7PVOPC6jrtQ2z2anY
	eMHdnVHDiXj8/WsMqD7xWnbLKSikzZQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764079253;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A+CiDYHXbpxplZXQ7tgsjF9iqjlg0GbhjXyIyaHRWFM=;
	b=71VH94XfLWvSJLIHZVboyqrasAHNDwltBco+km2qV2fj4tJ2XLI2xpokiAP7VA9m05bk8b
	YJWxqHB82xPW7nDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764079253; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A+CiDYHXbpxplZXQ7tgsjF9iqjlg0GbhjXyIyaHRWFM=;
	b=Zub+aUB7tad1dUhZVJ/t2UH/LA1MoM20sAS0uBief8TQSpT2CVd8BFPdZ3ru/Pdt9sxTgW
	z6LdsiJDWAB5mG/pbl8yqPOFsvEomXOFzPMVqyoKz8DioE8kR5OxK7PVOPC6jrtQ2z2anY
	eMHdnVHDiXj8/WsMqD7xWnbLKSikzZQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764079253;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A+CiDYHXbpxplZXQ7tgsjF9iqjlg0GbhjXyIyaHRWFM=;
	b=71VH94XfLWvSJLIHZVboyqrasAHNDwltBco+km2qV2fj4tJ2XLI2xpokiAP7VA9m05bk8b
	YJWxqHB82xPW7nDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 16F353EA63;
	Tue, 25 Nov 2025 14:00:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GsVBBZW2JWmxSQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 25 Nov 2025 14:00:53 +0000
Message-ID: <30e86012-4e62-4cc0-b244-cd50d86cfcd7@suse.cz>
Date: Tue, 25 Nov 2025 15:00:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add Mike Rapoport as maintainer for
 userfaultfd
Content-Language: en-US
To: Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Peter Xu <peterx@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251125132908.847055-1-rppt@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSBWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBzdXNlLmN6PsLBlAQTAQoAPgIbAwULCQgHAwUVCgkICwUWAgMBAAIe
 AQIXgBYhBKlA1DSZLC6OmRA9UCJPp+fMgqZkBQJnyBr8BQka0IFQAAoJECJPp+fMgqZkqmMQ
 AIbGN95ptUMUvo6aAdhxaOCHXp1DfIBuIOK/zpx8ylY4pOwu3GRe4dQ8u4XS9gaZ96Gj4bC+
 jwWcSmn+TjtKW3rH1dRKopvC07tSJIGGVyw7ieV/5cbFffA8NL0ILowzVg8w1ipnz1VTkWDr
 2zcfslxJsJ6vhXw5/npcY0ldeC1E8f6UUoa4eyoskd70vO0wOAoGd02ZkJoox3F5ODM0kjHu
 Y97VLOa3GG66lh+ZEelVZEujHfKceCw9G3PMvEzyLFbXvSOigZQMdKzQ8D/OChwqig8wFBmV
 QCPS4yDdmZP3oeDHRjJ9jvMUKoYODiNKsl2F+xXwyRM2qoKRqFlhCn4usVd1+wmv9iLV8nPs
 2Db1ZIa49fJet3Sk3PN4bV1rAPuWvtbuTBN39Q/6MgkLTYHb84HyFKw14Rqe5YorrBLbF3rl
 M51Dpf6Egu1yTJDHCTEwePWug4XI11FT8lK0LNnHNpbhTCYRjX73iWOnFraJNcURld1jL1nV
 r/LRD+/e2gNtSTPK0Qkon6HcOBZnxRoqtazTU6YQRmGlT0v+rukj/cn5sToYibWLn+RoV1CE
 Qj6tApOiHBkpEsCzHGu+iDQ1WT0Idtdynst738f/uCeCMkdRu4WMZjteQaqvARFwCy3P/jpK
 uvzMtves5HvZw33ZwOtMCgbpce00DaET4y/UzsBNBFsZNTUBCACfQfpSsWJZyi+SHoRdVyX5
 J6rI7okc4+b571a7RXD5UhS9dlVRVVAtrU9ANSLqPTQKGVxHrqD39XSw8hxK61pw8p90pg4G
 /N3iuWEvyt+t0SxDDkClnGsDyRhlUyEWYFEoBrrCizbmahOUwqkJbNMfzj5Y7n7OIJOxNRkB
 IBOjPdF26dMP69BwePQao1M8Acrrex9sAHYjQGyVmReRjVEtv9iG4DoTsnIR3amKVk6si4Ea
 X/mrapJqSCcBUVYUFH8M7bsm4CSxier5ofy8jTEa/CfvkqpKThTMCQPNZKY7hke5qEq1CBk2
 wxhX48ZrJEFf1v3NuV3OimgsF2odzieNABEBAAHCwXwEGAEKACYCGwwWIQSpQNQ0mSwujpkQ
 PVAiT6fnzIKmZAUCZ8gcVAUJFhTonwAKCRAiT6fnzIKmZLY8D/9uo3Ut9yi2YCuASWxr7QQZ
 lJCViArjymbxYB5NdOeC50/0gnhK4pgdHlE2MdwF6o34x7TPFGpjNFvycZqccSQPJ/gibwNA
 zx3q9vJT4Vw+YbiyS53iSBLXMweeVV1Jd9IjAoL+EqB0cbxoFXvnjkvP1foiiF5r73jCd4PR
 rD+GoX5BZ7AZmFYmuJYBm28STM2NA6LhT0X+2su16f/HtummENKcMwom0hNu3MBNPUOrujtW
 khQrWcJNAAsy4yMoJ2Lw51T/5X5Hc7jQ9da9fyqu+phqlVtn70qpPvgWy4HRhr25fCAEXZDp
 xG4RNmTm+pqorHOqhBkI7wA7P/nyPo7ZEc3L+ZkQ37u0nlOyrjbNUniPGxPxv1imVq8IyycG
 AN5FaFxtiELK22gvudghLJaDiRBhn8/AhXc642/Z/yIpizE2xG4KU4AXzb6C+o7LX/WmmsWP
 Ly6jamSg6tvrdo4/e87lUedEqCtrp2o1xpn5zongf6cQkaLZKQcBQnPmgHO5OG8+50u88D9I
 rywqgzTUhHFKKF6/9L/lYtrNcHU8Z6Y4Ju/MLUiNYkmtrGIMnkjKCiRqlRrZE/v5YFHbayRD
 dJKXobXTtCBYpLJM4ZYRpGZXne/FAtWNe4KbNJJqxMvrTOrnIatPj8NhBVI0RSJRsbilh6TE
 m6M14QORSWTLRg==
In-Reply-To: <20251125132908.847055-1-rppt@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: 6udzwfun97fxb4fdse1sgfof4fm8omxr
X-Rspam-User: 
X-Rspamd-Queue-Id: 43164C0025
X-Rspamd-Server: rspam10
X-HE-Tag: 1764079254-166656
X-HE-Meta: U2FsdGVkX189vJlxGPCAe0QjYcvPaFQ+EkN1bG8XnG8Eqgkyn+eXT5Y6Jh/PrIdDPt8UwQoIjifmnZcaGYp5487OCDC4BlvhaJ78YQOpBTBtNWPnmAamXGSyIMtXDskrlBQtwJrV60PCnTmhdnuHAGPxoyUAMg2NgcgJzAFho1dFdPxCzi7Xn5sD5faB2gTsYmiw0AwQTf5dRJgR8j2TbE1zyUl+nf4N/5ObCWJQH0r4hVGSzbEPiRgTLPA8uh3DAhyQ0SxHFA36VOXgSkAdD+fGR2wiuUmiefw6FQvOKc1KayaT77mq6Sgs7czzkHpmDnzt/4+kjzK39Kpze+ga2wgtgfv7zA6U/1BKO81Kan+Y8GXDCG9x6lmAz7asmY2D6agj/zNmd4jW34U63C2kY+04ceuISy9QAKyoUyApF8Ck9bjJq3RiDlpC2ts11uvpP2ofw4A6hReMNlI+52zb4eDh322T9uWep1bFAgiBagNYtCWLf0qrqgBbxm3g4wMwIBBJ38pCizhRtm/PXPIihGgDjWoG9KHFPK3hJv4Sp4FCumaL0aF6rdIysVlzOidmG5fSWvdsEFU9Ixp7V1+XyPXFidmd8fMBYD/qwCisLfOCNiiJ1g6Kf5GTg0YmsAITPGl63AsdKY0+9E5K198vh9ckThlAHJ8DsZeOsux8PZSvTSbtLEBg7NYBosmyv8HUDdUpR2yeSiNM0Jt4TZCWMFs1KBJaEGD/1PAHOqJ4k8DsWqMrArTFkVwaI8T9sYHsN1zjzq5cGQE+riod3ic2ltj+axcFyul2zQnJhAPAgtvnQnHcig5i5SVX3rVf1u746sWmZrhcnMY0Inr5NO58FQNLOrIO5YRo6n6rgqwx6POszY2mW1ufn4bLaFiup5DwHJfGzAgHHpRGkEg9lb+gzu5d26Ya+GcGcmWH4I5eGdU8lcGV4dq0rfVFwpAIyATzK9sinSgY1pdfPA4kJsu
 OpwWa5Aq
 68J9FORdGPOtIs6Y+h1v7NU9LqgK3/AfkyfnmHEe92JjGgCOE1CDu+O8II3OB8IUk8DXMDU8Rrl14xKwfUOUgD076y9jT1TEtTohhXm0J8g7zwjb07cT+iZ/R4adu9wxjofbK0baMwv8buh5VVVkRWU1qVrvdi/Lz4IP84vQw56Vp8Qs72uDM2BWYoDQ3Z7tWI2BYZ6CaC4PXAz6Ax4LeFwi2P37JxwLh2uD91TT1YTU7MRC1v76RfqMxojkQQAF/c0RGIk4rP6r1T0W06G+fBMGOEMXPADlbb67d1J9SUdpepVfHyTjWBJluh7kAyEwLRnK980rxtATkmM31izXDh0YLIWAtnhf3rWIHWDExcmHTG04EvNQWIa6XyYjidVUVIUgmqIvobx1Mbns+abTYExjYIJ4ayVZBq8kghvUJ5FDvRfiL+6M/lTd3gK6mGX9dErigyA/cjsC2Xy0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/25/25 14:29, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Great, thanks!

Acked-by: Vlastimil Babka <vbabka@suse.cz>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6df89b14b521..5243fd0eca74 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16547,6 +16547,7 @@ F:	tools/testing/selftests/mm/transhuge-stress.c
>  
>  MEMORY MANAGEMENT - USERFAULTFD
>  M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	Mike Rapoport <rppt@kernel.org>
>  R:	Peter Xu <peterx@redhat.com>
>  L:	linux-mm@kvack.org
>  S:	Maintained


