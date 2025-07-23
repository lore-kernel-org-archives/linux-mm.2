Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FF9C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 09:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A38D6B009F; Wed, 23 Jul 2025 05:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37AA26B00A0; Wed, 23 Jul 2025 05:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 242A26B00A1; Wed, 23 Jul 2025 05:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 16D5A6B009F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 05:24:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D24CC1DB1E7
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:24:21 +0000 (UTC)
X-FDA: 83694993522.25.DE7D008
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8E944180007
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 09:24:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J25gLojy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QOQxm+hb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J25gLojy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QOQxm+hb;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753262659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Umxq9tC9oV7T6xLjIOHoIDREJCvxx4xmfRh9hhbWa6A=;
	b=xdCc0s3WWvbmymvahic7xSnzpscJQQQ/8OIjXvqzbzn/AFhWn/5NwyCrDoozI9P9MAVQcz
	82U2rEaXXkgC1w/OWbxiw9w7h/b6r8JKNIFGEWKLg3YcIsba44SA4o4uLyX0rOspa25Ly6
	wZ6AjkZb+phkj1WoyfodNntB48FbMZQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J25gLojy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QOQxm+hb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J25gLojy;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=QOQxm+hb;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753262659; a=rsa-sha256;
	cv=none;
	b=pSwihlupRdJoBG44Sbo6rINM6QI6j8kr4nCKMZh6gqWiTDkcp5lHhSMk0zfIiUCbg/0N02
	R9atgyf9dKF+dN5YiSDMEMmmJlyfAc/siXZO5F4FQYV5heQumt5rbpMQa1citT97L9ocle
	RG+Gdi8iEbjgW/ryllBzpcbbJr8yxnI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F05E421284;
	Wed, 23 Jul 2025 09:24:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753262658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Umxq9tC9oV7T6xLjIOHoIDREJCvxx4xmfRh9hhbWa6A=;
	b=J25gLojyHwBrDMmrlxyurOQyxx0dFEimFpZnvhH81aOsUNlEUq4AQkc/RMPB15s7ebl86J
	hEvHhxD1qNBNVEa9y4vo5ARMnhcDzSDMtR3Uexx1MgGJ7xeYZgEdJdCNd8JRhUIJZ/0ABT
	ROMH3hHKgBENZ1FToDLcvEdtBt3yCn0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753262658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Umxq9tC9oV7T6xLjIOHoIDREJCvxx4xmfRh9hhbWa6A=;
	b=QOQxm+hbw/ergomcIR5qHQZWOJqfkplnlzNwhZdqB8DBetiCvL5/89OLlsBrsUTc6ygJp4
	EZ3NaqlX0gig7DBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753262658; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Umxq9tC9oV7T6xLjIOHoIDREJCvxx4xmfRh9hhbWa6A=;
	b=J25gLojyHwBrDMmrlxyurOQyxx0dFEimFpZnvhH81aOsUNlEUq4AQkc/RMPB15s7ebl86J
	hEvHhxD1qNBNVEa9y4vo5ARMnhcDzSDMtR3Uexx1MgGJ7xeYZgEdJdCNd8JRhUIJZ/0ABT
	ROMH3hHKgBENZ1FToDLcvEdtBt3yCn0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753262658;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Umxq9tC9oV7T6xLjIOHoIDREJCvxx4xmfRh9hhbWa6A=;
	b=QOQxm+hbw/ergomcIR5qHQZWOJqfkplnlzNwhZdqB8DBetiCvL5/89OLlsBrsUTc6ygJp4
	EZ3NaqlX0gig7DBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C65C413302;
	Wed, 23 Jul 2025 09:24:17 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EnzQL0GqgGjqVQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 09:24:17 +0000
Message-ID: <98ecfbe3-2130-4260-a6a5-2146587ea5c5@suse.cz>
Date: Wed, 23 Jul 2025 11:24:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: remove
 trace_mm_alloc_contig_migrate_range_info()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Richard Chang <richardycc@google.com>,
 linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Rientjes <rientjes@google.com>, Martin Liu <liumartin@google.com>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
References: <20250722194649.4135191-1-ziy@nvidia.com>
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
In-Reply-To: <20250722194649.4135191-1-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8E944180007
X-Rspamd-Server: rspam06
X-Stat-Signature: 49x45qyh1hbdkaxq7wxajgwsktcs75bf
X-HE-Tag: 1753262659-694732
X-HE-Meta: U2FsdGVkX18LN5gHUZAstVBuAiSG6w4lc/ZTqy2bTV0Ev3bfUoP151zv6XDLFGbwcx+XkQIKN5xS9J5NJQ+iVxVHarJsqk0pkdsae4z/zcyE9zhMJFZ2JzECgCXBI+LBr0YK3Bxcek0qxDBK29wx9gMo37XYf42BhMZimPq4oSo6Fn9O0XpbaWOBjAnPlzGlxhlp9O+Q9J9DQnjRPsTjtOys1faxzQiL4vIYnRJugoDsSbrsz3Zm5i3PUSD3lmzfCwPhIgZv+QdZfqIwlkjDL0SHw6C5u64W5V5jF+Jy6hQsIdc7AgiitSau0UruRh7VLeoZIsDCzWc3EoNn0niXfID9T5+fbVA6irFEXh0/p0o+89NK9m7xlEcJffp7i4x7DyeTnGgVih4GkASfEpvZkb/PUHKI2J78OtXNf/p8FiVkimlsfLj+ZVcQtoeD0YJtghAK2IDrpWhoi1RNQNClqZWY2y3IMqec1Ot1imyYgdIMBtY0f4CQVCY6tlRZacz29qHsnQf7AUX2urZAXwtR/PtueNqqan3Zdo+atjRrz9/kEzXKT7sC+mM3iDU8a9e0mJqkODxHHn34woHl10q2S8b/FAW7VNhysHVokXslqTquKJX5cckU99swwrTBpee4oXxP6h4vlvaGRc3qMqLCTRG8LhaIw4YBKEkrfmMCMd/8bhDrwCaxmaz5clwzDkfFMJQwDEZCF7rUcRJ5qaYzgLOjK+PVNH1hxzxNAD92dER0KFf7N8icJDiUHsO4+DZSB1vXIhVgCO9pN3K8yY8JXVxOMU36NsOVL+vz3mvsPxaw64Tu/G2FiJNaEZ6QCeoJLwTYdYTuOFjqCR8F/5WZRiMadPaM1zqaNnWlhXCk06R114vXzd+81p6bIkudvTQaC922lcXMERebXlPTdsMnBXyG2/XQzmmo2R4Ctliz/BKiYhx7O+0fJdGdzdybz+ySzV90hrqm9/nXfPO9rtK
 odrWKpO1
 CFaC3oUhHQKW6mjLwvps4znei9lhR6qvsEmYV1vkmtZdTvif4nxlnBF7YLziLgWYa3tDTcK7Tl2gKRczs1nK6nS9tZ9ib5DXLTj2+wEhLw8UoQXME7RkbSiAk4Dox6wxLYdQLkF/s/by2SUZvzHNo0yFPZRfe/ZIPaholPnggdECSAtzlaHPx0ycw+P+SkxmYnOS12F2Ufcn/3/5Gro3ylC2YaRDCPXMbA2/x5ScaBruJkQ3OhKPecCBQM9wZEZ15XS9Gbspt82FADxEqSaBigID2eQXYM83Cn++Ndd56npwSjEkH+qSdWbg24b8JIA5G+h7ErmwCQOpyd+0Z9PJbScACB5gSRuH/gaC10wYmW07Rh/QpdncCKwZIBNBKb7MdId3qEhuQ05uwnqBhb0H4cnS20Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/25 21:46, Zi Yan wrote:
> The trace event has not recorded the right data since it was introduced
> at commit c8b360031218 ("mm: add alloc_contig_migrate_range allocation
> statistics"). Remove it.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202507220742.P3SaKlI6-lkp@intel.com/
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>


