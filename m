Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58717CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:35:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674CE8E01D2; Thu, 30 Oct 2025 10:35:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625718E007D; Thu, 30 Oct 2025 10:35:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC798E01D2; Thu, 30 Oct 2025 10:35:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 36E718E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:35:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 127A91A00DF
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:35:52 +0000 (UTC)
X-FDA: 84055029744.26.C695791
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf22.hostedemail.com (Postfix) with ESMTP id 97EAEC0012
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:35:49 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="W+zzT/UB";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Yo26M07j;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="W+zzT/UB";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Yo26M07j;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761834950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WJBY+7WN8pUZ7BL5b9TfJ0orEZ9d/pc565rFs0g1Cf0=;
	b=eolRkMQgpKHZi9x5zXBNhdBAFV1XiV3A2RDy5Urfy3/zfaDdFjqaNKEu28NXOsmeiYszK2
	No61lQhxvI7+icyLQ7nZRXeDv5/Il41y8wIIa+SX695uLlBnGB0y6g3WpUKPFeYWK7Y5wI
	LellKxuKXwDOGKk0qy7zRracmax+Fl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761834950; a=rsa-sha256;
	cv=none;
	b=QO4DCNoCpaolvA5W+hMUTldnE3MS5ynLrVrmOkbdJk+GHo/eTpVm8iM9vQpZohiWrHT31K
	t3aiQyUZhJlmeICo0WL5o3GS+KSAGWq3RFq73Yx7ugOP/c6Lq+dyvj/bBclr6b+Sg4WaXO
	gOwpPjnS1H01LLbI+KkubmFPzWXmWDA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="W+zzT/UB";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Yo26M07j;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="W+zzT/UB";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Yo26M07j;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7E1EA1F88A;
	Thu, 30 Oct 2025 14:35:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761834947; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WJBY+7WN8pUZ7BL5b9TfJ0orEZ9d/pc565rFs0g1Cf0=;
	b=W+zzT/UBbEvDTjbKFqd2EcQDFGmk7FKNscdPOv1I/4wT5dDK1USXSu/0ESRIckmgVnNijo
	WRoJWIYG3lfWmG46tBxUT5i+hl/ZRyg+0YQpP5Kjqd5ZdPCE6Q1/r601U4+kSmRqUEHiHL
	oFLJYPFHS1mVRbThl1mjnVS4/RhwZRI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761834947;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WJBY+7WN8pUZ7BL5b9TfJ0orEZ9d/pc565rFs0g1Cf0=;
	b=Yo26M07jw1OLhnqf0Pa8mezu3jEDm6K7dmtSK8p3SUM0BJgGM9ZUbRtmbspS43/+DBBF59
	ckX/H+bSSaUs1ECA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761834947; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WJBY+7WN8pUZ7BL5b9TfJ0orEZ9d/pc565rFs0g1Cf0=;
	b=W+zzT/UBbEvDTjbKFqd2EcQDFGmk7FKNscdPOv1I/4wT5dDK1USXSu/0ESRIckmgVnNijo
	WRoJWIYG3lfWmG46tBxUT5i+hl/ZRyg+0YQpP5Kjqd5ZdPCE6Q1/r601U4+kSmRqUEHiHL
	oFLJYPFHS1mVRbThl1mjnVS4/RhwZRI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761834947;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=WJBY+7WN8pUZ7BL5b9TfJ0orEZ9d/pc565rFs0g1Cf0=;
	b=Yo26M07jw1OLhnqf0Pa8mezu3jEDm6K7dmtSK8p3SUM0BJgGM9ZUbRtmbspS43/+DBBF59
	ckX/H+bSSaUs1ECA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5053813393;
	Thu, 30 Oct 2025 14:35:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MNgvE8N3A2mqKAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 30 Oct 2025 14:35:47 +0000
Message-ID: <48170d2a-04ef-41be-97d2-f4927d04b046@suse.cz>
Date: Thu, 30 Oct 2025 15:35:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH V3 1/7] mm/slab: allow specifying freepointer offset
 when using constructor
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, Suren Baghdasaryan <surenb@google.com>,
 Christian Brauner <brauner@kernel.org>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, cl@linux.com,
 dvyukov@google.com, glider@google.com, hannes@cmpxchg.org,
 linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev,
 rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com,
 shakeel.butt@linux.dev, vincenzo.frascino@arm.com, yeoreum.yun@arm.com,
 tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251027122847.320924-1-harry.yoo@oracle.com>
 <20251027122847.320924-2-harry.yoo@oracle.com>
 <CAJuCfpF5gG63njY436vctG-Tzbco8X9a1w3YA=u1AGrRqxVshg@mail.gmail.com>
 <aQG97ocbfd0T-clN@hyeyoo>
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
In-Reply-To: <aQG97ocbfd0T-clN@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Stat-Signature: o9tzecuoshgxyn48yz4puogxam3gdnam
X-Rspam-User: 
X-Rspamd-Queue-Id: 97EAEC0012
X-HE-Tag: 1761834949-698608
X-HE-Meta: U2FsdGVkX1/ls2gGDxaeW2cabMe4HGgyD1B3U910b/UGREGgr+Ei5UiDOaYyS/EN5fQNoU394U7s+F2dCY1wp2nP/SZBOq6qzHhTdz/TvRFbaUEZks3cDMdkaorsvio1Hz/7d9Rv1FnEvvY7rE6NHT8MA97edZYECxy4VHa+Ig46OoCMeHI+r7P4S8QSLV0h5+9NLQlSKD8dM32f6D2m6QNgGkfXHDWJ+fl4cK2mo69T7aMaX0wmwNCMblCF38gCH+lTj07AM1fUazKSJfIaubU2VtDQXQmJPqFGAbh1yXqfXw0Z77B/d+zIr5uNjaO5Xk1jKkrTtIVx5CU9O0CJRtDLAAselRd/2zJEvQ0ZMOh8YwKRAHKdYT54+4ZCBzwvnITQnb4fsW7E2pe+qXDYFHYQ8JfzH0NMiof+e1g4z4qCGrzfZqK5r1+/YCXBOEkbCa0J2TtvVzZTVnOiAN9lbLn7jbuwqNjIJBJi69oZvy83H3cuP1WoLB3Leff+nEbC5Wr7JkPOK2943uXthlrA9H9CwLx/jDrHh11qtL3LN3WwRuEninchD8Z/lqIa20axDriT/lIZjo+9ZDZLrWotM6nmikbzvSt8gzvUGV2yLKcq585e3IlGUQkR3SqiOG/RLPrLUcqpobO6XpoJ3qICnhDdSaEs9APDv5e7PtL5WpjiCokVq05L0iKyY4cUFu4TOed/cVOMbwTRGcF1bfhH4LzapzRdMeqhxh33b2jv/ZYrsKiJt06ug7TttiNEALCqAXPBXazn0o6QFZegD1ueFP/eOfHlBP6KH1VZTF4dehRdYxINQhZleRc+fA+Sk0yJ+sUYc0bsYgFfWlpT53WVZDP5jRkpZ3r3rLBy7vd0TMg3JZPo/GASqrsj5gRnUuatzUG+cFCDXyoUyRpoKh7oNEXx1I9Bf+d3W4q/AMeVuwNtKy6nBpVU9U5kx5IkLivwsEcdHMqXDXMQw6NUdJ1
 2yCZC1vM
 twOV4YaRzlhwrRB8+juJ2V7O/3T6tlk+dnOGHNOvPBDZJsP+xa5U1jUQOkoaxFfV5VwVYHxQ+0NMLXM81oMSa99wz0+Y6mSXpPiZE8ffQzc9Q4H097SoAem1zpFz1P7H6t9+uvRczuwaozbZ2NcbEqmrTMVZkSXbDhamRCxlf8q/JzsB+MpDTqG0J2DWy2EmB2wH6XOopPNAViUQvy1xK4cHqFgMRmxHJ4e/KBu+EKEUh1AYM0qHmzIZ2hzuApS/jE/ztzDPLOwaBxw3As1IFDGihDsesobfubU2/BWojIYRGZtb6aH1aNlgQtgU9jXjQvve1F4aQvb3P2TwHRiP1dC/z0mIYaWOOugU0YJnGGO6DhCr2I/9p17/giELL9uiYNdTbCORbvY3bMK6iTSYMK8G1FFXwLTQmMJTonE9IlD0/1MjyU8sMnyVoGzXk5FelDTT1imNm7hGAZH64Ckmez8YPrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/29/25 08:10, Harry Yoo wrote:
> On Tue, Oct 28, 2025 at 10:43:16AM -0700, Suren Baghdasaryan wrote:
>> On Mon, Oct 27, 2025 at 5:29 AM Harry Yoo <harry.yoo@oracle.com> wrote:
>> >
>> > When a slab cache has a constructor, the free pointer is placed after the
>> > object because certain fields must not be overwritten even after the
>> > object is freed.
>> >
>> > However, some fields that the constructor does not care can safely be
>> > overwritten. Allow specifying the free pointer offset within the object,
>> > reducing the overall object size when some fields can be reused for the
>> > free pointer.
> 
> Hi Suren, really appreciate you looking into it!
> 
>> Documentation explicitly says that ctor currently isn't supported with
>> custom free pointers:
>> https://elixir.bootlin.com/linux/v6.18-rc3/source/include/linux/slab.h*L318
>> It obviously needs to be updated but I suspect there was a reason for
>> this limitation. Have you investigated why it's not supported?
> 
> commit 879fb3c274c12 ("mm: add kmem_cache_create_rcu()") says:
>> When a kmem cache is created with SLAB_TYPESAFE_BY_RCU the free pointer
>> must be located outside of the object because we don't know what part of
>> the memory can safely be overwritten as it may be needed to prevent
>> object recycling.
> 
> The reason the slab allocator requires the free pointer to be
> outside the object is the same: we don't know which fields
> should not be overwritten, since users may assume a certain state
> for specific fields in newly allocated objects.
> 
> If users don't initialize certain fields in the constructor, they
> should not assume any particular state for those fields, and they may
> therefore be overwritten.
> 
>> That has the consequence that SLAB_TYPESAFE_BY_RCU may end up adding a
>> new cacheline. This is the case for e.g., struct file. After having it
>> shrunk down by 40 bytes and having it fit in three cachelines we still
>> have SLAB_TYPESAFE_BY_RCU adding a fourth cacheline because it needs to
>> accommodate the free pointer.
>> 
>> Add a new kmem_cache_create_rcu() function that allows the caller to
>> specify an offset where the free pointer is supposed to be placed.
> 
> I'm not sure why Christian added support only for SLAB_TYPESAFE_BY_RCU
> and not for constructors, but I don't see anything that would prevent
> extending it to support constructors as well.

IIRC we considered it and only left it for later because there was no user
yet, so we wouldn't have a proof that it works and we're not missing
something. If you have a user now, it's legit to do it, and there are no
known theoretical obstacles to it. Obviously docs should be updated at the
same time then.
>> I remember looking into it when I was converting vm_area_struct cache to
>> use SLAB_TYPESAFE_BY_RCU but I can't recall the details now...
> 


