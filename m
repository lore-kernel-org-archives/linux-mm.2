Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED118D31A3A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 09:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CF656B0005; Wed, 14 Jan 2026 04:48:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57CD06B0088; Wed, 14 Jan 2026 04:48:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455186B0089; Wed, 14 Jan 2026 04:48:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 31A096B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:48:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D323B140447
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:48:06 +0000 (UTC)
X-FDA: 84330093372.11.B9FC226
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id 49278160003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:48:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uyP33/ot";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="JCXZg9/H";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uyP33/ot";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="JCXZg9/H";
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768384084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wCPgzUA/fWvSlyO7YMWemzLfFiJT5RI4JmCZszTQQCE=;
	b=p3IIZEtPp17O7euQvbVETXLSrckkcdqNDUC3kfqsb8AdZ6QjBHzatZ11AB+eSkXResCZvS
	gH49WelQCrC9WUzr0SmT9lciTLSCBAe9g+AultGaTAGCvHKWQFO2dIRCf9WIX9why2x+uh
	GZ4j6unlf8BXiUy60mfpqtzqByvTxFo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768384084; a=rsa-sha256;
	cv=none;
	b=06cy2ibVoHEOAn/yzLAmBzUjj4sGqevHNt+oFMnsAPzCX+rWvAbO49LPo85HvSRtfb1tjr
	ojAKkH2GWOG7qot+S2UzrgN4wEI+IjJG8GNqsEcTlKiDz/gmYm8pFhfvPthrn3Kgfrjska
	VJz63dpBGWPDLTwumUY0Tb1acv8ENNY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uyP33/ot";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="JCXZg9/H";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="uyP33/ot";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="JCXZg9/H";
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 54F0133A8F;
	Wed, 14 Jan 2026 09:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768384082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wCPgzUA/fWvSlyO7YMWemzLfFiJT5RI4JmCZszTQQCE=;
	b=uyP33/ot8vJyHxaQxMGlaqPsY+EfHkRcWkRYzQJi7yc4hhnuVhGBsJ7D32kYvBBMAiaKxh
	oKgDtrMHh+/cDAOE92SODXQYQcbblXt66KUOITl47E2KAP6YkghzLdIjE7avJwvLU6tK0M
	xrkYYW892AkdKMNK0P52OEqgw31HCF0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768384082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wCPgzUA/fWvSlyO7YMWemzLfFiJT5RI4JmCZszTQQCE=;
	b=JCXZg9/HwDywijqA3dtUM0kh11clykU1XUjOqY5N2Pgh1uHvvtk5u4rG00mz9agdbfB0OJ
	+BRHGWB9ngR+MhDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768384082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wCPgzUA/fWvSlyO7YMWemzLfFiJT5RI4JmCZszTQQCE=;
	b=uyP33/ot8vJyHxaQxMGlaqPsY+EfHkRcWkRYzQJi7yc4hhnuVhGBsJ7D32kYvBBMAiaKxh
	oKgDtrMHh+/cDAOE92SODXQYQcbblXt66KUOITl47E2KAP6YkghzLdIjE7avJwvLU6tK0M
	xrkYYW892AkdKMNK0P52OEqgw31HCF0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768384082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=wCPgzUA/fWvSlyO7YMWemzLfFiJT5RI4JmCZszTQQCE=;
	b=JCXZg9/HwDywijqA3dtUM0kh11clykU1XUjOqY5N2Pgh1uHvvtk5u4rG00mz9agdbfB0OJ
	+BRHGWB9ngR+MhDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 435CE3EA63;
	Wed, 14 Jan 2026 09:48:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QKsgEFJmZ2k2IQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 14 Jan 2026 09:48:02 +0000
Message-ID: <9adb16d4-ca80-45b2-8026-135cbf0f00e5@suse.cz>
Date: Wed, 14 Jan 2026 10:48:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [vbabka-slab:slab/for-7.0/obj_metadata 9/10] Warning:
 mm/slub.c:7013 function parameter 'objp' not described in 'ksize'
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>, kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-mm@kvack.org
References: <202601140605.GNpnpgLF-lkp@intel.com> <aWbxLWF0R5rIvRb5@hyeyoo>
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
In-Reply-To: <aWbxLWF0R5rIvRb5@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49278160003
X-Rspam-User: 
X-Stat-Signature: 84ziw153r939uhyx6yi5xejge7y7ijpx
X-HE-Tag: 1768384084-683764
X-HE-Meta: U2FsdGVkX19zCnatu5TLLxFYdKeFYoxKgwtiqK79H5ZrdHS2jZg53LUrdyCcOU+FrFU1xZ5dKjhrXQfPUd0f3GC+ZutDUGLy0el7xDFROMqChUGZdGZh0KMahpQJw2ugJF4phwRcfWYknWwV6VKcfqcvLPg9u+g+vUHNdfYpBsf3P+4St922eQogNTVLXu/G6pXCndHKqHtOOHZIjCKpJbkkd/mMKWm7oXaeAYrZ0kR5qNROui4SEpibumcrCnQyHrlv/ukxdR98HsS2gZKtq0gSM1t7UDoBnVS2Xq0vclAsgYaDT1jwqsuM7lW6Y7Rf1d+0DpJnULf8rmbEiixTAjRDwVPnJ0ilnEHSdcA7apA0GOFWznA4WTwh1uuZqQXgPNMj+rqaUmVUJhnETQhtxn571Nlq0EoqnrFm2Eoak0+XcR4HCQXeesuMmSoqh/4KcZNRDxtqSyArVhwpsWOahZJt59UeBOFmjh5JmGnKEuolNhZdzBZW28kmJn+qj5xsmm54hgGNv7k7pnazuDQij+T6RPaKFXA6+AuaPqRXRMZOaN4Rb5w4mnklDPHCX/URdbDeU5HdqvTvnrA6KRU+8k+twYRwsZve6sNjtTxJ9NGc3HSDg0uBXBIcpghtTQsJMba3wd0P5ajVveD2ieQWuQCWDg2dSRTZCuPo2142EcLKuiV9Tha/Cp/vEgV75+uduBs9CJUqJFChMNmtc+7NhkeilHWHIsU2YRwJ4KbZyxEua9XILtANRz6vnMXkJb6hNbcfA3pe/g19dmLJR7fFtTPc2Aw9T76zFEmCzOAcY4+5uyPpJW7Sgwr4xAuqglHALnZudb+g+OvpmeAkPG6HksaHLmVlVlqklu/GI8FsG0FZgdU1dgYpTWLQX11N2jKQaJYzltwIgXlzfuzvQLwPEGVXNkcNGNXoHyZJwVz0X1/adnPHXpd3VFD3qF/KTW53kUzqGuGsyo5LzTNDyyU
 R8jmanG6
 mcXYfQI563kBQfY6ehtQZNkwloGLAKabtET+TQu4J/KZhrY5DCaKqHXXXe5/tyc3YXAwvbBaDmsvwEFamcIuJleS6NmarW89NZPw85biIsA1LrYlA8V8GBxInH+tmsq0eluCO+q4aiZKXgKJHMs2jFOFAdR/Qq6inC0lPBw740iU+qLny8p4tIqxx2QcoY4ClUgE7Ake2vKcx4U2rGJ0aem1WSXhBeKHTYrGcBfgUrOgx42jSHZASt2nE/PxjhuclLKK3/WLwUFAGteJDdjh3oLqHEv+s+yCiGUiIkamlNcTxxa8emut/czuay3hFl5OJlI5YHmivpT2kp9NRQf6H0WNXFEWiEn3OOxRupepln1l5aArIj5I2dodYI5WTVx6IUgXvPwrJzt9L/5HtGt1dC5v6ow==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 02:28, Harry Yoo wrote:
> On Wed, Jan 14, 2026 at 07:00:18AM +0800, kernel test robot wrote:
>> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
>> head:   a4e5702b7bb846cf50d2917cadf2289c25720812
>> commit: 1e8eb4117f27366855b192104098330a2f290f26 [9/10] mm/slab: move [__]ksize and slab_ksize() to mm/slub.c
>> config: x86_64-rhel-9.4-bpf (https://download.01.org/0day-ci/archive/20260114/202601140605.GNpnpgLF-lkp@intel.com/config
>> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
>> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260114/202601140605.GNpnpgLF-lkp@intel.com/reproduce
>> 
>> If you fix the issue in a separate patch/commit (i.e. not just a new version of
>> the same patch/commit), kindly add following tags
>> | Reported-by: kernel test robot <lkp@intel.com>
>> | Closes: https://lore.kernel.org/oe-kbuild-all/202601140605.GNpnpgLF-lkp@intel.com/
>> 
>> All warnings (new ones prefixed by >>):
>> 
>> >> Warning: mm/slub.c:7013 function parameter 'objp' not described in 'ksize'
>> >> Warning: mm/slub.c:7013 function parameter 'objp' not described in 'ksize'
> 
> We moved the comment from __ksize() to ksize(),
> but didn't rename @object to @objp.

Haha actually I moved... sorry.

> Could you please fix it locally, Vlastimil?

Done, thanks!

> 
> diff --git a/mm/slub.c b/mm/slub.c
> index d3aa805f3e05..373ee58b8b9e 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -7070,7 +7070,7 @@ static size_t __ksize(const void *object)
> 
>  /**
>   * ksize -- Report full size of underlying allocation
> - * @object: pointer to the object
> + * @objp: pointer to the object
>   *
>   * This should only be used internally to query the true size of allocations.
>   * It is not meant to be a way to discover the usable size of an allocation
> @@ -7078,7 +7078,7 @@ static size_t __ksize(const void *object)
>   * the originally requested allocation size may trigger KASAN, UBSAN_BOUNDS,
>   * and/or FORTIFY_SOURCE.
>   *
> - * Return: size of the actual memory used by @object in bytes
> + * Return: size of the actual memory used by @objp in bytes
>   */
>  size_t ksize(const void *objp)
>  {
> 


