Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14C1FD7879C
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 16:22:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79E666B00B3; Fri, 19 Dec 2025 11:22:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F1F6B00B6; Fri, 19 Dec 2025 11:22:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 670CB6B00D0; Fri, 19 Dec 2025 11:22:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 546346B00B3
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 11:22:23 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 10E3316030B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:22:23 +0000 (UTC)
X-FDA: 84236738166.25.EB694DB
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id A2AAAC000C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 16:22:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E9yfC28Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RW2m2wbb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="NVtIbG8/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tDK4c30S;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766161341; a=rsa-sha256;
	cv=none;
	b=sQJcLJJhiANGu+vogwNnZI4GF2nLBIVffuaCSOz1VU4k24+tPb8gT/2t1CpXFODK05vyq0
	GFRh8M5KIx7jrxHUnnifEjc3cBfmYRTqh24MF/HiK4so51Ou7aYVeokt/jzb7jBgP3zPhY
	8CzUyuusRRhNIrE0cY2eeRdjD41LjUQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=E9yfC28Y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=RW2m2wbb;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="NVtIbG8/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=tDK4c30S;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766161341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HjRkNrUoPD/Ci5NkKG692udcBe7n/qa+I/9BSJaQSts=;
	b=Z+DTgLaudLfSvPahVMAAJlpJyYVMjekQ/HJhrYI+b8diipp4qbXaXD/QUAhUrKD+3g1GtQ
	BWIVfZnjgboSS/Yxe8Q4ChS/xu4OkjdS4TUeq/UsEw5xCxCEo22t5yuPlmbo+O1xT89gFW
	h9WZWiVoSG0HGhxd+Zoh66017d5uVLk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id DFC7C5BF56;
	Fri, 19 Dec 2025 16:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766161339; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=HjRkNrUoPD/Ci5NkKG692udcBe7n/qa+I/9BSJaQSts=;
	b=E9yfC28Ytuv6Q97rTbl9OJBKjaWHFiSnXVlQzKB7DMFILJKI2MOWliWfQF9G+w48fudiXp
	dKNvP4j2WKx3lmReCUx2+4qDTUrsvFsyehBoh/sJSeFQer4N39L8FQ30bS6JONywAPzSVE
	7j9/OucKwhl9/69PDCDd/jgvuEotEhk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766161339;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=HjRkNrUoPD/Ci5NkKG692udcBe7n/qa+I/9BSJaQSts=;
	b=RW2m2wbb5Km58KzKbWGLaDw++NSOZj68Ave9drPzdb4YM96zXQXbtsKfrojnOqTTtcBpyx
	pePxnLNaYZfhp/DQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766161338; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=HjRkNrUoPD/Ci5NkKG692udcBe7n/qa+I/9BSJaQSts=;
	b=NVtIbG8/5a2rBj2Vtmw+kgd72aKySpO7ruFyX5jWinWVc0VYi/jQPETbMEoVTiQFZI1Slw
	b+0QFOuXkjJlwgP6EJoLa4Oi1l6clkMrLcGZwPp/xR3vQ7A+W7UyFd+nojUwYJ+pWS0/1X
	a0SFeWvzkf4X6th189xwBvreuVqCoas=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766161338;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:autocrypt:autocrypt;
	bh=HjRkNrUoPD/Ci5NkKG692udcBe7n/qa+I/9BSJaQSts=;
	b=tDK4c30SRG55dnpluunRQPoqHqvMFpjsEc8TeV8Rw2vM63Vz1B3nps/Th2sRmp+gwWVeDo
	l8AupzGIiLroz9Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C8ACD3EA63;
	Fri, 19 Dec 2025 16:22:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Vf3PLrp7RWmCUQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 19 Dec 2025 16:22:18 +0000
Message-ID: <271c4413-2d6a-4dd9-9b31-714cfef3f28f@suse.cz>
Date: Fri, 19 Dec 2025 17:22:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@suse.cz>
Subject: [GIT PULL] slab fix for 6.19-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>
Content-Language: en-US
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A2AAAC000C
X-Stat-Signature: dk8z35f4kw5fu7m86hohdznh8s65p8ts
X-Rspam-User: 
X-HE-Tag: 1766161340-733755
X-HE-Meta: U2FsdGVkX1/UtuCeiiR9046BzVz9vPmVvgK3NixC3MnWV8h6AErcyxKGZLfclTbYbUIy9UR9ilnCuttpkVenTva2/tMbhAEPtYgWc+GqSkHaPz5fr2r4yDVQ2DM7CX1p398nslIOJWiqrWODBBuOHexLvBwknUs79sWcX+v38GF8ksFo+5QB8OD//WHQb7KqOKftQuxKPjxn29Ket+zZH96/9STt0Oklx+7vTpOMLHbMSbGOIYM/mu42m4wWraLAHgmZ7uajv47nkjmMdRxOZ9JR0l6ZLk9EBC6Dyt4ecaKeP9ywmrkiNyplWIFcz3UdQNeDRn0byqFYA6aSXe9A7LA42PVq2nBFbvMvXwzIt62xNS591njopPt/YZTP8kuh+Bpyet2Y88aBP8JfOt5gQhuKPTWPIQteEZL8pI8yBENDOqgyi9VHYZQD6gF4H0xRBb/yf2CY9yeRzc0q6XGqE+PSayyqs/sy0FRXcDBhlScZxXre95kD2cf81taZq0uTBmYMbfLaMmLM5uPHewDwk2HnqlzcihfqUhc2F5Ra6r5UIt2/44g2NJLT0OsK/WwOC0H/cLyBgl2janwpi3fQCA/JhM8YfQMblVwcgA/FQCC+7LmXBrUQbllx0XPljIGvcApzxH6wVmAFqn0Y2BZbv3oNEGnkBRecPeQvYqn5RvZaco32c/ICLfN9E8PKe0sozm8hXw3IfrRqdd9Y0Ozgko8etqPk/0jE7/IDs8y/CNhiTmjBZXoyv+oHQrY21FwbXQA7uuO5uqT5zHn6EZ6juSetWVypO2NW09KfJUx0SJMD/yz9pk+5pmvdLol4Exp0xhmT+/yZdvj424MHQk5GjqDSoNcVjfvBfOvqA6nyH2bDCARXxlcxzAZK4mO3ehcLaaiWHAq5ZuLZ/VAWVEeydtFo7G6Js+rZhPJD/XraTPvEElmgdUx3LkOtYzYUfhJjMovJP6EpM17+JYVRoGQ
 PGKCOSKD
 gJdcbbZtNIFUuzrHgUeWw52tdl+aU5A/mKX9jS1oJBRCYhJBgxs1e02s2BEzksZiduLg7r2lEy3d44+nh+KqExrY8HeBegysFBMPX/4n003ea7HEZXI1mgG0mvsoYD3NnTDxg+YlPQdtvSmmGfNdumIcpGKrcGQcqqAfsU2KcY6h0DWUuFCMqdwfJ6EXE9Ib9P2ossqpDy8UsmdDb/+N556bdoDvCheGMllAjcdRZX6DEf5BeDfQdpzp6J31fppmC96GBOVW40J5gpMEZDSZDqnaW0FHiToJZadREMfht9MW29WC//L8ND9c/nQg1wTK21J/t5qygHIHQyDbhyn39Q+HSDh3giqt/4P55
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the slab fix from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc2

Thanks,
Vlastimil

======================================

- A stable fix for a missing tag reset that can happen in kfree_nolock()
  with KASAN+SLUB_TINY configs. (Deepanshu Kartikey)

----------------------------------------------------------------
The following changes since commit 0f35040de59371ad542b915d7b91176c9910dadc:

  mm/slab: introduce kvfree_rcu_barrier_on_cache() for cache destruction (2025-12-07 18:09:54 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc2

for you to fetch changes up to 53ca00a19d345197a37a1bf552e8d1e7b091666c:

  mm/slub: reset KASAN tag in defer_free() before accessing freed memory (2025-12-10 13:54:53 +0100)

----------------------------------------------------------------
Deepanshu Kartikey (1):
      mm/slub: reset KASAN tag in defer_free() before accessing freed memory

 mm/slub.c | 2 ++
 1 file changed, 2 insertions(+)

