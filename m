Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F86D37E33
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0750E6B00B8; Wed, 14 Jan 2026 08:57:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C336B00B9; Wed, 14 Jan 2026 08:57:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56A46B00BA; Wed, 14 Jan 2026 08:57:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D6B596B00B8
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:57:53 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A99761A04DD
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:57:53 +0000 (UTC)
X-FDA: 84330722826.14.AF7A12C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0974F180009
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:57:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BQannB2C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F0F1Ddo1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BQannB2C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F0F1Ddo1;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768399071; a=rsa-sha256;
	cv=none;
	b=uRDJt16NIshR0AMaNkgTbaKa4Bgvbyf3r5ioq0Hi6X38NIWVXoVuku/485ZkiNXhyHXKXX
	DOv3OixCr/YT9PKzVfjjxC5Ct2t6Xgph8lsRGPixPW46vlAkm1eZiSM44+XN/b7GL8GoTk
	+p+dkmW9OhcNaR2W0d0hcgWD72giG54=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BQannB2C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F0F1Ddo1;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BQannB2C;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=F0F1Ddo1;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768399071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkLtCD3VeUT4+7u4NR2PnnGS/Xl6g5UrZVDdOLhFDZE=;
	b=nQTRwNKFBoVNWMFO+1y3tj3Aa9oP/Iii2+x83BB8Fx5/kw1Hq1RiEUDupPbkGWk2hZqfyR
	CJW7vWWTCdzA7wZKiwMfUheC/MOUwGuaXaRE/EaIdefDkKZ1rV57Ee5ePCmWEy26m2wt3F
	BLI4tHGqXiFsTcfSj5sgt267Yo7vX90=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6605E5C879;
	Wed, 14 Jan 2026 13:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768399069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pkLtCD3VeUT4+7u4NR2PnnGS/Xl6g5UrZVDdOLhFDZE=;
	b=BQannB2CzAZBWc7xWmJ9UAU5t2Mf9VkaNfgF8njZsex08GX49yjptH3kSeQtTXwqDPuxmC
	vI48/izDxJdcNCyIdeHjI30bf3Rw+rA2ksx0X1zmUMlW0VqLbNHRc+A7H/o87TOjSmdmcz
	X0tfWTnaybaS3gtt5LuxMFz6xhAbY7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768399069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pkLtCD3VeUT4+7u4NR2PnnGS/Xl6g5UrZVDdOLhFDZE=;
	b=F0F1Ddo1czaR1YSWlbcabDQM64DX7zHNaK9OoGz5GhtRH6IgStx5HqymwMdF1NSsogHUEq
	KENSKw+tPmoKv+AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768399069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pkLtCD3VeUT4+7u4NR2PnnGS/Xl6g5UrZVDdOLhFDZE=;
	b=BQannB2CzAZBWc7xWmJ9UAU5t2Mf9VkaNfgF8njZsex08GX49yjptH3kSeQtTXwqDPuxmC
	vI48/izDxJdcNCyIdeHjI30bf3Rw+rA2ksx0X1zmUMlW0VqLbNHRc+A7H/o87TOjSmdmcz
	X0tfWTnaybaS3gtt5LuxMFz6xhAbY7k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768399069;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pkLtCD3VeUT4+7u4NR2PnnGS/Xl6g5UrZVDdOLhFDZE=;
	b=F0F1Ddo1czaR1YSWlbcabDQM64DX7zHNaK9OoGz5GhtRH6IgStx5HqymwMdF1NSsogHUEq
	KENSKw+tPmoKv+AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3DF3C3EA63;
	Wed, 14 Jan 2026 13:57:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EC/ODt2gZ2mZLAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 14 Jan 2026 13:57:49 +0000
Message-ID: <596a5461-eb50-40e5-88ca-d5dbe1fc6a67@suse.cz>
Date: Wed, 14 Jan 2026 14:57:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 06/20] slab: make percpu sheaves compatible with
 kmalloc_nolock()/kfree_nolock()
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-rt-devel@lists.linux.dev, bpf <bpf@vger.kernel.org>,
 kasan-dev <kasan-dev@googlegroups.com>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-6-98225cfb50cf@suse.cz>
 <20260113183604.ykHFYvV2@linutronix.de>
 <CAADnVQK0Y2ha--EndLUfk_7n8na9CfnTpvqPMYbH07+MTJ9UpA@mail.gmail.com>
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
In-Reply-To: <CAADnVQK0Y2ha--EndLUfk_7n8na9CfnTpvqPMYbH07+MTJ9UpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0974F180009
X-Stat-Signature: zmpsk18byqpupqpo4txq14nz1ax1zrno
X-Rspam-User: 
X-HE-Tag: 1768399070-686553
X-HE-Meta: U2FsdGVkX1/LjvzXROcsg8/av9ccuWN7md3Caj72zerTVUatmhoiaqTljIgSfwxxIHciwlKN+sdiAPeI/N6l1gLFBa6ea2QoTX2BNwsa6B3ajL/xMc4dlEm9GL2bj2E4YHFHK1xxDd1qz1Fh5yAE+V+jSC6qj+hoFG2VYNmnhB+yWHEoE4eWcIvNqKfDB6KZC+6XaUdW50jRfcqoL1h2RuqgV/LSmTWELgQnMpILVvePAPTIV1vwx7sxYmaDgaHluWdTr+KNGweSLXnHRt8uEx5Bm4jqG6n8qjtj6XRx7P/D4YsVZ18fWhl093wNQ3gvZHUxxturzwfUCjzCu2CpXDEBFigieZK40N15nq10ztcbtHHub0LNDYtT8Zw+WPDAqxXz3VwAEP5pgOFfHPQIWkY1rno1UHpa6H33MnkUxu+tr1bVQUeFy32m1EuCaG+AxXZbMJfKZM4AajWr8MKBHFVD+3XxqvzsPD++SW15JSjR2vAcP5/gUjtkbOZTMSfHH36nHq+DHGytviN6NsvTzoheu0rPME0f7JSnBh1UC4z9qcDhdg0NFOLwfhMuMVNA1J7oLBIGilr3PJb/VOir63raSQvaayr2W1htqv7mjiGymGxJB8sLwJrF9Uvq9gtU+v6b6Izhp21WU6vwHGm9rmpfrbOOEjRkenOpbt0RYgGm1H6QKAQUVjy54XyuQcaPTVlA0qVZn0fI1W5ejm/tRmCEJrMQ3TfQ/ZFszoCnCYGwq6GOyw2HKux8vZO/ddKfTojqWPnaxt4qgCpN3gSIDSnzbN0q0g3AzZyVP1AYRjLSOS9+Fa3sv+d4N4V5j6RFUek1MowTCvC3CRNz6n8obfO18YlDzVePL0Z95yArB9oQ6QWVF5H0r6tyJ19Tw+0OqrqpB6SP4LtCTdjj3mtdBNaXUjJNXNBFtwtjX+u8xYlXPcFF9x829y9MAjIabdCfNfGxPbS81Y+ckE87fVb
 RNQLgZpG
 Crl2VOcBBr6jGWnD/R9rvdGbyy3Ex7H+mDK00W5ZAjeriiU/A4COnqKrRMeDsqutPCml4osXAf5uvJXSUIzU/M5yXAsgyfbzI5xhEiOGOZKwW0cUKqDMna4LF+BH8crmvtHDoDHRJ1qE2AkNbzi6cJzEA5/+Sga23Wh5adbHAjHJiEMogBZN2fUhV9Ahx+zf4N0xt3fLc8/pK6nxCas+nAtMNTD8FTohmFl6nJE8ydQ/X6cUB1DtbyDf9EW8MphGYuT1kGWIFi03lNEnGV0l7YYwcXFHkS1r39sJCUpUvp1dnE1pMtpFOKEXSeomv44eMVpQBRJ/ijrSub6Y8rI57YMqHxaMF31UssdxsPbhKYOMZiAk3Y736zEKBzRTlKdamdjdeok83HyfIDqrjTzkCWCZEBgEI9aBmB/KbioKJjsrPcFeYPSctBTHCpMLte20FQNO2Fwc6niHOQFB2usVytBvWG+6xGHDKFRQV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 00:26, Alexei Starovoitov wrote:
> On Tue, Jan 13, 2026 at 10:36 AM Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
>>
>> On 2026-01-12 16:17:00 [+0100], Vlastimil Babka wrote:
>> > --- a/mm/slub.c
>> > +++ b/mm/slub.c
>> > @@ -5727,6 +5742,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
>> >                */
>> >               return NULL;
>> >
>> > +     ret = alloc_from_pcs(s, alloc_gfp, node);
>> > +     if (ret)
>> > +             goto success;
>>
>> I'm sorry if I am slow but this actually should actually allow
>> kmalloc_nolock() allocations on PREEMPT_RT from atomic context. I am
>> mentioning this because of the patch which removes the nmi+hardirq
>> condtion (https://lore.kernel.org/all/20260113150639.48407-1-swarajgaikwad1925@gmail.com)
> 
> Right. With sheaves kmalloc_nolock() on RT will be more reliable.

Yes IIRC Hao Li pointed that out before. We'll be able to remove that
!preemptible() check that we area about to add by the patch above.

But I'm not sure we can remove (or "not put back") the "in_nmi() ||
in_hardirq()" too, because as you said it was added with different reasoning
initially?

