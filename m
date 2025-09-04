Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EABB9CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 15:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39BB38E0009; Thu,  4 Sep 2025 11:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3737F8E0002; Thu,  4 Sep 2025 11:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241B08E0009; Thu,  4 Sep 2025 11:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 12ADF8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 11:12:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC2A7140249
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:12:13 +0000 (UTC)
X-FDA: 83851908546.20.9D8F0A8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 35307160017
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 15:12:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sq7afq7e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cbwbe+rR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sq7afq7e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cbwbe+rR;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756998731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GrQcL+QO+sIg2dEOYUGJYHSlSV5m11t3/goGC+tNL7A=;
	b=qRgDZQnyAAlL7J3OoNRu9RE28CHujl2zxfUFEkVusgq7RVk7LMEk9IfBpFl1jxOReAt/Hc
	5Hf4R0pNq2sqwV2S7eStnfg6JFVYxD5XC0D4jIQoikSHKkkfwvkuvvooDQKAe3dBO81Daz
	07CjASvyGZg7b9BLe+L2ka48UNjPamI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756998731; a=rsa-sha256;
	cv=none;
	b=DYjSDDzvbpGH6Vw0etCReEAp203ZohpdvkweDq1qs1ocPXXQJ7eT+O/opmHBYAe5cN9t4x
	twKR/YYQvatIzG7mZ+bd41z7ZUv26nKdgjU6eibUudqSuq9Pd3JZRevsEQ048O9kwEWBdh
	PhqpaJWmaiZKhDcwwp+DTOfHzxZrsGU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sq7afq7e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cbwbe+rR;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=sq7afq7e;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=cbwbe+rR;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 50C33602F8;
	Thu,  4 Sep 2025 15:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756998729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GrQcL+QO+sIg2dEOYUGJYHSlSV5m11t3/goGC+tNL7A=;
	b=sq7afq7e8bEsyA9iyI2xBrl/QD7vo2p0wNO8T7p9GBK15XzhKry54RKEOSOaap8bLriFvl
	OACcccqTniNL4NHfVcDWgWt8CkFr6cGD6rklDdNYmTaaBXPEb/yGz0l0nWuaYxDP59K45m
	/2rSPPe8YVjHfH+8PeOYqPsbXuzVD/s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756998729;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GrQcL+QO+sIg2dEOYUGJYHSlSV5m11t3/goGC+tNL7A=;
	b=cbwbe+rR4slWIaoUwtZt96fLKUp4mO8j3MVCuIlBGuNpTsubmuIuv500iCiJUfH0OEFiwQ
	9Rnc80OKQlPWDMBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756998729; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GrQcL+QO+sIg2dEOYUGJYHSlSV5m11t3/goGC+tNL7A=;
	b=sq7afq7e8bEsyA9iyI2xBrl/QD7vo2p0wNO8T7p9GBK15XzhKry54RKEOSOaap8bLriFvl
	OACcccqTniNL4NHfVcDWgWt8CkFr6cGD6rklDdNYmTaaBXPEb/yGz0l0nWuaYxDP59K45m
	/2rSPPe8YVjHfH+8PeOYqPsbXuzVD/s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756998729;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=GrQcL+QO+sIg2dEOYUGJYHSlSV5m11t3/goGC+tNL7A=;
	b=cbwbe+rR4slWIaoUwtZt96fLKUp4mO8j3MVCuIlBGuNpTsubmuIuv500iCiJUfH0OEFiwQ
	9Rnc80OKQlPWDMBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38EDF13675;
	Thu,  4 Sep 2025 15:12:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RDJEDUmsuWhjBwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 04 Sep 2025 15:12:09 +0000
Message-ID: <6614bc25-f514-4a05-b45a-037d951adc77@suse.cz>
Date: Thu, 4 Sep 2025 17:12:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] mapple_tree: Fix build error (`make W=1`)
Content-Language: en-US
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 maple-tree@lists.infradead.org, linux-mm@kvack.org, llvm@lists.linux.dev,
 Nathan Chancellor <nathan@kernel.org>,
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>
References: <20250904090423.2293933-1-andriy.shevchenko@linux.intel.com>
 <6nk7wvp2vbsc5myxnx4mfohpq4yk4ixazkvif4hntilpuz7jtw@a2q2if4nc7kn>
 <aLmWF3V8ILOkL8W2@smile.fi.intel.com>
 <2ts445ufkl7mhtdd3ucs2c6lsp7fxbx6b5tqmu2tdecxprok55@fdr2dwppnoks>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <2ts445ufkl7mhtdd3ucs2c6lsp7fxbx6b5tqmu2tdecxprok55@fdr2dwppnoks>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 35307160017
X-Stat-Signature: org8qwicmbz1np7ng949mebzjofmfp4w
X-HE-Tag: 1756998730-287570
X-HE-Meta: U2FsdGVkX1+eAMfqJu1QZOv6SujanoVcKPGNmOKea4lHkTnrKdEgRibhsDatjl3pPWi8IFhmDT022FRFGInsPXcnwXT7yuRWu6C8TE+sfMI+SLVd5BSZetN8NZrZAnVv5/Wfb68/1xy22pt7nvYIg8udTuouSVghTrZdQ738KkCQ0rs+ujw+7UazFMw59g9IlYivqnEr8P2eMeRBJ9uxhsdb5yj7i35CEAgAJUDTZ7j8OQ5mwABzIP7g10sgqPrrBR3Ratj1HKbaS7f5MZd5AhJN9QuhI0dK0tS6kYowxlALBUb9d2NSjiOGJ8cg+2E/IwwQtDgZ5kZOhwZrenQgAMMceLQnric4l5mV/ZXKICMwyXj5zEr2bj3MEItqdevPkcxi7s3AbTikjTymqjBA6nF8qn9IR8i7v396maWKPakFCZa38EVh5SHV5wK/b5XI7XAk/g6EjkBNlbT6GNC6iunbObFq+eQMoXDaiXHyU1enJBvofjK5aBVx2V210iAEewkSQjk+WkHaeHUWHl/J0bId+pBCoKTsQNqgoY5XsEIuKmguYg5isOdHULRRwaWkiPH+jOA4p4+9FGDyEvRdlSziJJi4aOkzFBl42hxc8EId5eDQCMmhKlMu7hMW+f+XQurxdbpzf2QuoliDh1jV8brUe32ICnbnAT64zjsB72jzidP5Wm5qgck+GaZBiK9U/pt5ncGtmEeOyn8RSYOknFLGmn4jgncxecHboMBvjejrqt9fFxlhW0TM569Vt6AaEbZmtgJoxsds24kQtgCOCLXH6x7l26tpSF7pm/wAbVhwwwJkAWlHpYMjg4MTgKR5afng/X2YRh/tjeXLLBQMngB4JNwM8Kj3QIkrzXg2kZxmyaxtwzUAinN6KkmNbPDroUO3kGGk64NTdnqBl8HsX818DMWdr2UYVkHDRl6/0rGsw1qOZzR99CPObGUfKsJenfN9Kptt5okmGEJbuOQ
 8syiSe9j
 ogtRrgzICXHq3TzuKiPjpQ3nsA+NH6iQB7pfF4JUDcp0z9+3IOnKUeNVnnVCGkIA+V3G6EMHTwVO4+/OHhf+esrOaUVhcR3ei/D1sVRbQJblMxEoEwRmo954qZhLWlf34f7gXlTEFtnNObOXB/ejqDFcNDKI5LuRo7JtyHdzD0uxt5hLWsGeri7Xt69nTLLc398FqttoAI1FVLU8DL8tgAqqlocrRQ7WsgGsPD0FSGjKNRg456X50kgl5s5yBpcqzk8Jc4Dn3rSe8PvGF8fMDk9ebdkyGInhbkeRHjVK7lSLvPUxRaqaXqQJl/wjSxT+tyciFecObF3omhDFfVa2SX/vmQwPeAG6/VEvmBgSSkrWjGjJIohIT1AA/RK/jgJmlO0UozJcQRxoOwTdAAILMACsF0isj44Ge0u36GYQOYK13cE4vZ7FjjT4Eq8kZl+sFxNMbbU89YqzJgXJDdTmxsjW8Fg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/25 15:42, Liam R. Howlett wrote:
> * Andy Shevchenko <andriy.shevchenko@linux.intel.com> [250904 09:37]:
>> On Thu, Sep 04, 2025 at 09:32:52AM -0400, Liam R. Howlett wrote:
>> > * Andy Shevchenko <andriy.shevchenko@linux.intel.com> [250904 05:04]:
>> > > clang complains about unused function:
>> > > 
>> > > lib/maple_tree.c:179:19: error: unused function 'mt_alloc_bulk' [-Werror,-Wunused-function]
>> > > 
>> > > Fix this by removing unused code.
>> > > 
>> > > Fixes: a48d52b2d21b ("maple_tree: Convert forking to use the sheaf interface")
>> > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> > 
>> > Thanks.  This should be squashed into the patch listed in the fixes tag
>> > since it's not a stable commit yet.
>> 
>> I fine with any solution, I just want this to be fixes rather sooner. So, please go ahead!
> 
> Sounds good.  I've added Vlastimil to the email as it went through his
> branch.

Squashing into the tomorrow's linux-next release, thanks.

> Can you please Cc the SoB people next time?
> 
> Thanks,
> Liam


