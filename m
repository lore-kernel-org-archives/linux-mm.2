Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFE9DCA0FE9
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 19:45:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 270088E0106; Tue, 26 Aug 2025 15:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2213B8E0105; Tue, 26 Aug 2025 15:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1102C8E0106; Tue, 26 Aug 2025 15:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 017198E0105
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 15:45:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9EC791383D3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:45:57 +0000 (UTC)
X-FDA: 83819939154.17.112D612
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1D4051A0003
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 19:45:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gYhlOQdu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DPCKmIS2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oeHvizqX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O6hBVCHK;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756237555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9QUZm2wViBIYmUtxG7v0epJTawJL2u41RnKd5f132uU=;
	b=Xtozf3a0ydhcRORpvyQLXAty11scDs9BM9szOhQqj7MUg6eY8o4J+ahCt1jz5lkni3pNXe
	lEz1+hTas4DpdM760IFf66WfOS48Ssxf4fz6UttkYsKxTW5Lnm7kGsCtU7Vw0aspD1WAdh
	LOEdoCHdy2mK0hvj7s/aMojeZfS85oU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=gYhlOQdu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=DPCKmIS2;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oeHvizqX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=O6hBVCHK;
	spf=pass (imf19.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756237555; a=rsa-sha256;
	cv=none;
	b=VnVmWeNbnRHRpbxNnx0TVHek99iRojfbCIKeyJiJDBxlZ1TYwvPq9vaJ3a2nEzuUtvnd7X
	xdRNDYAkgvePk3LZ4gag+W+Ya5SqmXSbdQNuNUOrme+S4wwx4TxDdMha+l5dRjybpjvxzl
	rkQ2qtdP0QNGZ3EZ0vGDXRha81zsrjs=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DD6781F78D;
	Tue, 26 Aug 2025 19:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756237553; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9QUZm2wViBIYmUtxG7v0epJTawJL2u41RnKd5f132uU=;
	b=gYhlOQdukqRCtkLr85gCiI3TrR7X8FfWyFrywAj9oTh7BLmFqaPC15YMz0Ts9IpqYc8CVE
	u/BlZSpI+62FoMBmB5mL+4MYmCGSeWTmdaLnovA1cUf4rR5l/eHua8ojxzRuHwFjSOV9V2
	E+oxObd84k5syv5t+XCASD0vwi1VxDo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756237553;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9QUZm2wViBIYmUtxG7v0epJTawJL2u41RnKd5f132uU=;
	b=DPCKmIS2US56Cym/X9fkEiRinUL3il//ViPp45P8XBOYZMBoHaAUFU9SDYFrl658fciRuD
	7LXHLCfscQh/+qDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756237552; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9QUZm2wViBIYmUtxG7v0epJTawJL2u41RnKd5f132uU=;
	b=oeHvizqXmwkSLTt4smN82HGzb3sYs4v/eP1m8CfnUKMJxQ/VKsUhKx2Zbl6+u50zmULKUt
	I4NHCHeaGq6/zub711Y2ztMM5+ZkxPSA2C/rTbfAjU2OXauUcTNFQKiIf4k0rMe6BxI8dL
	8KFa8SuQi2G5BJ0f1afVClftVTP4Qy4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756237552;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=9QUZm2wViBIYmUtxG7v0epJTawJL2u41RnKd5f132uU=;
	b=O6hBVCHKdC5wYh9uPtgvBy19xzHo1lDq9lRPfcdg2RyS8tNs8sq9jXhDzW8Zx1OFiDCnsf
	m7DhmJwbn3u+BQAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8F7D13479;
	Tue, 26 Aug 2025 19:45:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9v9vMPAOrmjUKgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 26 Aug 2025 19:45:52 +0000
Message-ID: <3cca6ae2-6387-4d03-a4c5-9e2374fda687@suse.cz>
Date: Tue, 26 Aug 2025 21:45:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/testing/vma: Clean up stubs in vma_internal.h
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 WangYuli <wangyuli@uniontech.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250826102824.22730-1-lorenzo.stoakes@oracle.com>
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
In-Reply-To: <20250826102824.22730-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1D4051A0003
X-Rspam-User: 
X-Stat-Signature: 183dhuniffg88zqioyt8tgmx91rf3dkb
X-Rspamd-Server: rspam09
X-HE-Tag: 1756237554-504708
X-HE-Meta: U2FsdGVkX18ch3MSbNrPsWGFK6TkBHdlYumyPT00NnUJAYq+10G/XLSKBWl5E3OsxgdreZd4eSMT9QenBpMbESHtFhE/1EHrt35GfIxwBASavc26ykfmQ6tzvlLRPhMztmq/VFAWNe3fw9pD59zRmv8FabB+NscoguZhR07k2834gr9z3zK5GWmcAZThUspmjLOR682uXmJAxgourMVXbB/tdJziw2fsebTcdxcSuyvonyzU1qe1rWHJHBK2Be7OqiN+Z1j9YsKcgccRA2GCtdbRJQya9XN6bky/8xYin5TESDqOavH68+gPbv88Dh95XllqzsW59Xuwyo56vgwiFxj/rgv41HUUMlvbErb7pFQhPMJLYw7FplzFpoCW+JTGf4pD3OlEN/1Yi0oyjaby3hXDTC2XsnFYH3GrvywFWO3WQxdcDBVbKPK4muP2BdQs6GOdBqibHAsMsWxhZ0FNMNX8J4NzCpWqLH8jugSAVSikXPu5aXadAThW+Llo55RjoJGsIB1ZTocIRsnjoGZHeJnIVNdTcQGTuA73/p8e4/F1XaZ3bjreY5aeo8Z9bTk1P1vgCjFyQzGkZvpmnRMV8xFKu5VQUf4COohOtKWDCY6uc8Le+qUw59qfPsCrgDNxwoRZTm6q8yxfrVS+SV+W1o2BtL8c+OQD8rBnDmtnadLmS5hgfog7y8pCx45ZUZEtPNAq95kROIfYkB8D53b8xxjY2Uhkf1UqBjR8cJ7xOsBgXLIPy4XuZ5qR+g/v3KTPoOGG/rQaP1n4vDf2E5VSXIVIxQfDQKQWQQz6wG0cGkAqS2fE/N6DVcUEkwd81Jmq9HKQTBlX36xLoxhdO46dKM1o3B4hCzy5cAHu2ce3kmmjX7w21+gE3/F4BA6DD9ZUHmmz1iqoq4NxxfnvE9mZImKlTPRueO2rz5ryhrLw7atn4F0m3PdsDYnPZR/bQZSD0qicpjU4H+wvXSETvXO
 u03QKI/y
 gRO07BseYwx8EEBTaENtBwW91FsZD2t5nR9AzwVIAptNqqmRmzVj3pPXWfG0aZ1n8hfffAMUWMJNA+eZ7HDjE8iibmbUzLNs0gfelsBKXuqLz7HWIwFVj9I+PDCrTRL5OIauffGsctpjwnJbh018IAgcP+Rp0opJQyjWE6ZUgqe+tqhHoNOGc2SoQ+s+kF+QUjdnsP9LjrVFKQt6lFmA6BvBboPHpRLc7+u4o8MHtg9jClY/qKLeuf+xpLLfFh6FuJ+tlQDzSU2zdEKiZaVeYnsCEwtC/fDKbwI3s65FKpBlsR+S4uEX7PD1aB/P+L2Sx2KQigjzyTBscbtweb7SMOG2AFhAmwfzaZdhwhwHGF9cDGAtekoW79nfZT3JpvEHUc/jDbX71rP2GONR71dUx7WAXzWBLwXXj37ZUIVEaljx6UbO+K+f3ENSbs79g3Io0UG3LiWPLhIBe81M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/25 12:28, Lorenzo Stoakes wrote:
> We do not need to references arguments just to avoid compiler warnings, the
> warning in question does not arise here, so remove all of the instances of
> '(void)xxx' introduced purely to avoid this warning.
> 
> As reported by WagYuli in the referenced mail, GCC 8.3 and before will have
> issues compiling this file if parameter names are not provided, so ensure
> these are always provided.
> 
> Finally, perform a trivial fix up of kmem_cache_alloc() which technically
> has parameters in the incorrect order (as reported by Vlastimil Babka
> off-list).
> 
> Reported-by: WangYuli <wangyuli@uniontech.com>
> Closes: https://lore.kernel.org/linux-mm/EFCEBE7E301589DE+20250729084700.208767-1-wangyuli@uniontech.com/
> Reported-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>


