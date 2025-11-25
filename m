Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E7D9D0E6C4
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 11:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C58E6B002F; Tue, 25 Nov 2025 06:33:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49DA76B0031; Tue, 25 Nov 2025 06:33:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38C026B0032; Tue, 25 Nov 2025 06:33:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 25E916B002F
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 06:33:04 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A13CB5B715
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:33:03 +0000 (UTC)
X-FDA: 84148917846.09.05C1402
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 329C940007
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:33:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Yd4j54qH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=giLOF9tZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Yd4j54qH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=giLOF9tZ;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764070381; a=rsa-sha256;
	cv=none;
	b=r+yaqP5iI+SUoClpdsjDhnyFyuBtnXH94YrQI/5/z2JKaBt3gJ+laAfMzcxySuE+eLJU8P
	6vKW+PxGvJnkfbKHtCVzKT/FfPshD8sGd7Xt1Y3+2j5Nfs25DRioOZk5zHbrLn0mDnI8BP
	iEJB92Pmrg0Ug53+J6s3ZQ2v4ZO3ndM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Yd4j54qH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=giLOF9tZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Yd4j54qH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=giLOF9tZ;
	dmarc=none;
	spf=pass (imf27.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764070381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1qa9vAa4U8lDyYWaNi0O+STo0jj9KfVqsXxFN2yN/ok=;
	b=W+VV+HbxzMCkZOVdofPBeM+Sc5Xkjoqi5ypMT0b5d0XL/AgRa1xBB0XoErMrWDgvnzh0kP
	yITjKdcarnkVmVWcviuWUSW29UOqtpHkEZLcot14s0oEuOQfb/TOQUZSQNWcEtuUmTVIex
	QKwm8d9oLRobJsc3RuIz0YJGuwOHAA4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3BB31227D7;
	Tue, 25 Nov 2025 11:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764070379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1qa9vAa4U8lDyYWaNi0O+STo0jj9KfVqsXxFN2yN/ok=;
	b=Yd4j54qHrwxL6Sc60nDV9FBZHz9bTh4tyLifThb0S8GL4MrjAJoNqkHlnI41HaW835ky8J
	dAZbeoXpAZdsjzu45Y6JjlD0itDeZWF9AOuCGfCYPUd9K8by9PlBE4zPrGkX0KWf/I1Ul5
	BQUyLUoOO0oWEdO2BAZ/fHKUzwIVUdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764070379;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1qa9vAa4U8lDyYWaNi0O+STo0jj9KfVqsXxFN2yN/ok=;
	b=giLOF9tZzC8GrzRZYeLK8oSySv3fZgwAowc9sTuMr3d9nZ5GCcicAlitYoslGTmPayEenq
	9Idm3k5tsnN4QTDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1764070379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1qa9vAa4U8lDyYWaNi0O+STo0jj9KfVqsXxFN2yN/ok=;
	b=Yd4j54qHrwxL6Sc60nDV9FBZHz9bTh4tyLifThb0S8GL4MrjAJoNqkHlnI41HaW835ky8J
	dAZbeoXpAZdsjzu45Y6JjlD0itDeZWF9AOuCGfCYPUd9K8by9PlBE4zPrGkX0KWf/I1Ul5
	BQUyLUoOO0oWEdO2BAZ/fHKUzwIVUdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1764070379;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1qa9vAa4U8lDyYWaNi0O+STo0jj9KfVqsXxFN2yN/ok=;
	b=giLOF9tZzC8GrzRZYeLK8oSySv3fZgwAowc9sTuMr3d9nZ5GCcicAlitYoslGTmPayEenq
	9Idm3k5tsnN4QTDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0578B3EA63;
	Tue, 25 Nov 2025 11:32:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v47CAOuTJWkdOQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 25 Nov 2025 11:32:59 +0000
Message-ID: <b6d035e1-9b29-4a3f-89bd-5f556005d07b@suse.cz>
Date: Tue, 25 Nov 2025 12:32:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] mempool: factor out a mempool_alloc_from_pool
 helper
To: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 Eric Biggers <ebiggers@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251113084022.1255121-1-hch@lst.de>
 <20251113084022.1255121-7-hch@lst.de>
 <a8a2c740-2208-5692-cfc6-f475ae0f7d45@google.com>
 <7b1265bc-835e-4c7d-af75-f237c46bc3a7@suse.cz>
 <566ce586-4d53-f2d8-50b6-1f884f44d2c9@google.com>
 <23fac529-7b4d-4095-8c64-0d4a9d08c9b1@suse.cz>
 <8d043756-b59c-f604-f859-3f4803bbcd23@google.com>
Content-Language: en-US
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
In-Reply-To: <8d043756-b59c-f604-f859-3f4803bbcd23@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 329C940007
X-Stat-Signature: 1gcstpqycowxq3qran1fcyoe6koky4ye
X-HE-Tag: 1764070380-210492
X-HE-Meta: U2FsdGVkX18eS+bPHoq+2ymw0unIs6jasFfMhsvhxLDqwrNDjfriqv+6QxwVzTfjSBv3mUnqIRPX4rKXdDGwtxjhnkLk5HlAOJF48x+GYaNhBuvUKs7JBlr1WrbvhJpLoEj7CiabXFcSxlikKEJpyMZjtN7F23cnU3JkBqcJoshU5Zgc8klqwKEC4J4qgutbRDUSMr7zHQrAzSxI5RPVKPzmYyLr04FkFp1FTxqaeBMdTbSE79G/sIWZT9IvxKOs++wDdDn1CxqIQdVy/lqoEGpgNVqWmZf672E6NNdH7iADvZhYQKlqKiKbdimDa/TF6+WWF5Cx3GTTLAd3VMdWF3BIPdVR9XV7DOf6UQjL7m+dBrApOk2aijfOTMvdI9ia/EUR9orT9ZfgQ5YPLhcZAQEyvEO50/bU5y1/gVfxZRoeoRSkPciXIVL5Do87tmeyLLcn+eFKmexGeU/HXe7dXgcMtgVxDsjHEeRNJeEH5ZmFpli/gvlF8b4ak+YLYrRIe8Zh05X00wqfL4HuSSAjD4ubO4bt293vCmjxjEZ87f6m+su7nJglSDAoKyFz/yxnMHaUxvJMBqB3SiPevZG+jz+0cAjIYZtDDi5aoQWL2mEcmSA+dXYpWdwRfKWRxGo+EGCv4O/h1phQ79PINJH56bSZrhYLKU7dkkExPThytxnlvm+NEyeq7CzjKxxH8nqvx0DOqRSAkFbAhpcNZ1I11v9tEu+u444f3+iy/FCkDJRONUQLwP148cxQnKohCOs9ZvWNpMWRFIIfPb7X3k2bANqPOTPiiZvSk1RokQw47k08daL+hA0aoE2zYdjc4YK/elxSl6n1hDMfhFCSXClp6hheRUiasCzRjcuPhSWeXZtuuh2LfYo6zigFpjQ/sZN/AtJtIWUeo2Etn+OpdXOZcMFi7/WN/Z98SdOCa8Lrd5VLYqrDy/X8D8w7IEN1TBiU+tji9hHWoFSOrZs/RBL
 CgibxD4r
 l6qNgTMEsRItXIdKRWl/2Eau7GyfagT8CwC5hCkX8ztk9bqgHlekjq/fgcckFmL+x+wkJULNWqkS9ocya5lL3e1AjRr3dX3BbxqXorXLLqp2TU0c72zKA5lBbzC+ugxLXlo5nEpY2DvD9sTVCyamLtOQBkg1ndl4zjmcwd6pTL/Fmw67Cvkdp2kWctIsVzP89EZK4z2Me7EX4N5G3CvaMf4xdGVy9IAcKFi34Ns4uH8Oa6cQ1Q61pL//5LjkYyFNL9FLPEHz+/1VBGPFx0ald22uXh1k4DCn16zUW4MT9OCsaZZ+frcaPSggiNSgkE4uiJ/KxcHn7VUvmiy2BR1ku3mYLrWNricxM67lsE7CnIrn+Dbqjnp6bGzE0JlN9YjSo6z8q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/24/25 00:04, Hugh Dickins wrote:
> 
> You are completely right: it was me who was missing that the second
> pool->alloc is with the full gfp, so not an identical repeat of the
> the first; and so it is correct not to wait after the first attempt,
> so you are right to call with gfp_temp instead of gfp_mask there.
> 
> (And this also addresses my slight concern, of whether it was
> appropriate to be doing a pool->alloc after waiting for a mempool
> free: your way, there is no such wait, at least not that most
> important first->second time: the wait would instead be inside
> the pool->alloc probably, reclaiming.)
> 
> Yes, your fixup is better in all ways than mine, please go ahead.
> 
> Thanks,
> Hugh

Thanks, Hugh!


