Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 445CFCAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 10:08:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EA998E0005; Fri, 26 Sep 2025 06:08:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0E68E0001; Fri, 26 Sep 2025 06:08:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B0248E0005; Fri, 26 Sep 2025 06:08:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 487238E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 06:08:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1D8C11A834
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:08:31 +0000 (UTC)
X-FDA: 83930976822.07.1FC55F6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf13.hostedemail.com (Postfix) with ESMTP id BF13320014
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:08:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HKFgXozA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kQnVrAQP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HKFgXozA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kQnVrAQP;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758881309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ql9sJWg0tZNaVxk76MXuMAFIJmAUgI2uAUBYEZyDzyg=;
	b=DH7/2ik9bh5st3Y/u+NjSQR5B7HMZmP7PMH38lkB9ZAvBQppqKkvFXVNCOE06jhqlpteJ1
	nsI8sB71qqsoM9tN6SvgN/AO9fUx2Pm8rFM3jSgp2mwOSNiZ0ZS5qAH8HNzSuS50x+xvYm
	mpqAA1fmeGROghqdxZHP3kjrWpxUEFU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HKFgXozA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kQnVrAQP;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=HKFgXozA;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=kQnVrAQP;
	spf=pass (imf13.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758881309; a=rsa-sha256;
	cv=none;
	b=1wAK6wD9WxlPhUDPePx8lBwylpfDSIX34L6xstfc09tvcvnD8xvNCEodGgEl/7fERPptY1
	YL7GSVQ1n1O8RrAk3HMvdlWQ37hQSwLgxWV6NqQAQ5ibpQxdW8oFig4l7lh/uhX9gSpx9t
	wVxUE5yYBGD63gkpCRUGYI+abtkvGX8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8440B6AFAC;
	Fri, 26 Sep 2025 10:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758881306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ql9sJWg0tZNaVxk76MXuMAFIJmAUgI2uAUBYEZyDzyg=;
	b=HKFgXozAba1H2yA32avvlwJ9Q66kjQ0ETPT9nX1Sq1ca662pY0w1um7zc68yNF0nRexnaf
	BZ1hD0s+xpEMWJstPonsuqupTxNVTdnwK3SaKYrEngMJbmAaqEBk+n1avXvTVbA63mCuod
	QTdX5g34O3rQb1sFcBUXvmQcFPgvBh4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758881306;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ql9sJWg0tZNaVxk76MXuMAFIJmAUgI2uAUBYEZyDzyg=;
	b=kQnVrAQPZCGhxYOMLLrpBSHnw77JSJnWJ1Os69YYHUeoPbVrYMQkWjiOJNa77MPZcia2cW
	3evCK9oqrEj+ckBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758881306; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ql9sJWg0tZNaVxk76MXuMAFIJmAUgI2uAUBYEZyDzyg=;
	b=HKFgXozAba1H2yA32avvlwJ9Q66kjQ0ETPT9nX1Sq1ca662pY0w1um7zc68yNF0nRexnaf
	BZ1hD0s+xpEMWJstPonsuqupTxNVTdnwK3SaKYrEngMJbmAaqEBk+n1avXvTVbA63mCuod
	QTdX5g34O3rQb1sFcBUXvmQcFPgvBh4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758881306;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ql9sJWg0tZNaVxk76MXuMAFIJmAUgI2uAUBYEZyDzyg=;
	b=kQnVrAQPZCGhxYOMLLrpBSHnw77JSJnWJ1Os69YYHUeoPbVrYMQkWjiOJNa77MPZcia2cW
	3evCK9oqrEj+ckBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6160E1373E;
	Fri, 26 Sep 2025 10:08:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CnB0Fxpm1miVFwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 26 Sep 2025 10:08:26 +0000
Message-ID: <80f8bdf8-ce50-4682-9468-9f38e0817e89@suse.cz>
Date: Fri, 26 Sep 2025 12:08:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu()
 operations
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, "Paul E . McKenney" <paulmck@kernel.org>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <20250910-slub-percpu-caches-v8-4-ca3099d8352c@suse.cz>
 <aMpxnACqmsQl-lp0@hyeyoo> <bbda8c25-b575-4e98-b1ae-b103c6598d38@suse.cz>
 <aMqcXyKRlZggLxu_@hyeyoo> <6f92eca3-863e-4b77-b2df-dc2752c0ff4e@suse.cz>
 <aMqyn6nenR8V_p1y@hyeyoo> <bf8b4741-1025-4cc8-b9ed-5b566bdcb2d7@suse.cz>
 <aMq40h5iOjj8K7cc@hyeyoo> <a32bd837-2597-43d0-9da3-1ce5a53b15f4@suse.cz>
 <40461105-a344-444f-834b-9559b6644710@suse.cz>
 <CAJuCfpG6CSm2iZ3jrwLQA4vVbTMvC=B37q10OL+wLzm-DSRhFw@mail.gmail.com>
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
In-Reply-To: <CAJuCfpG6CSm2iZ3jrwLQA4vVbTMvC=B37q10OL+wLzm-DSRhFw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BF13320014
X-Stat-Signature: zeuba4uc17gbxp45rg6xczzh3yy58huf
X-HE-Tag: 1758881308-859580
X-HE-Meta: U2FsdGVkX1/DDQXAFLvAkJ+0WJkuh33PxrSq+c/4NAPRhVrl4Vn0tSkCmgZIWwr7dlND/XyUluXKfN4TbutFcSmd064iZnU169e41ZrIEvWaoXsTCkOqDh3IEQzHmEVf9/NMRP6ry3xDpg2AfN1gFC3+DUgBcbtxcyhe7l8Jl2xlI8o6NrcTIsK893Wdc3sRLJ4+wRdtg86ZfnQoZXqLdnnoLx/0Ql4NY8+PXySEEfrNGRbbzW8xoArh5YIYqH4XihQEcLS6G+YQDTBVXo/l9W1UIXlDQmACTDV3fF0Ce9ZQ2Z1WGApVabuYtgajb3U4He060IIGRROAGGlGsoLdkDhzcTe52JEUQfPCAI2aMtRNAvrNMubg0+HwVmlr4ff1EjFa3OiBdzOrH7Li/clwfn8Ea8qcmcZCq4TgQFUdEnNaf47bcQNgoxTWeekeDk0lzUMpipnUQ1Z6qtzoT/9dYGsASGFAhqNVDUOgzxkt3+PeMcfCsut/89p+38TkSHmn99oM5C8coz3QFRNYC72Fqln+32gt7w0YKWUSJWmDGcLH7n0kZTLz97LYdgW8WESNXixJZJL+DyzlMGI2hk9nsYh4eYB7rI6y3Aj7rY513SLDLne4B0kf+3PsjOiYZ2zGvM5yxWkLYlhBLncEU1HaYBKL2uGMGzlNriEggl7QvKTgKGgGcjoIRH5kHvFdkD2bFiKtglAp3eJ8lbzqa2FFA0DcZamSZvApK+NkPcwDweCu7xqopZ44RXq04TP9ox4wURSj69HlkM8lXNvltQ9s7VwpKs5K3sTclUplcsQnT+qo+QKr4Am+PoUllAvft7icYPxzmqw0nIOerStS4e6r1h9Nda/H85y6I37F4tITbtNloZVtw0emHkK9uq9IYdSNip9Z4n/LE6kLL9axUwtPpz6ts7j417RqDKFlkb107YwntIG4Jx5VjQKFvpk8vTXG50NU7HY4vsFmQWtCvql
 OaET9vUV
 ujQVQPR6eY1/+GB2Lefytk0sZqJcsraRrj60u5qTuPVC+yNYA2FuQoSU7qByhwjrj+0SNVZAQmfRMC+Smn24UF16VWS4vETFl4D+vO4DpumittfOmHcnQeMvsqjzUuIz+4BjwbU4/gpnnCGxWk052/V7wdYWMaHvFfCxKdq/GzlJdt/ieOvLLqOWMkiI8gGT7GJp7k2K/CPfkFa4dNX4doZyuEvNpfqGZHFMVRT59B0Esz4fsg9xWqpnedIAhLNb/QA2nVaseDzBeDXY/lw4RipNwfsAtPwc60qj0KkbvSNE/s2ZnaLM9ptxn37iNcBY+oUgh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/25 06:35, Suren Baghdasaryan wrote:
> On Thu, Sep 18, 2025 at 1:09 AM Vlastimil Babka <vbabka@suse.cz> wrote:
>>
>> Expected advantages:
>> - batching the kfree_rcu() operations, that could eventually replace the
>>   existing batching
>> - sheaves can be reused for allocations via barn instead of being
>>   flushed to slabs, which is more efficient
>>   - this includes cases where only some cpus are allowed to process rcu
>>     callbacks (Android)
> 
> nit: I would say it's more CONFIG_RCU_NOCB_CPU related. Android is
> just an instance of that.

OK changed that.

Changes due to your other suggestions:

diff --git a/mm/slub.c b/mm/slub.c
index 8220ce095970..fec0cdc7ef37 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3945,15 +3945,12 @@ void flush_all_rcu_sheaves(void)
                         */
 
                        INIT_WORK(&sfw->work, flush_rcu_sheaf);
-                       sfw->skip = false;
                        sfw->s = s;
                        queue_work_on(cpu, flushwq, &sfw->work);
                }
 
                for_each_online_cpu(cpu) {
                        sfw = &per_cpu(slub_flush, cpu);
-                       if (sfw->skip)
-                               continue;
                        flush_work(&sfw->work);
                }
 
@@ -5643,6 +5640,10 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 
        rcu_sheaf = pcs->rcu_free;
 
+       /*
+        * Since we flush immediately when size reaches capacity, we never reach
+        * this with size already at capacity, so no OOB write is possible.
+        */
        rcu_sheaf->objects[rcu_sheaf->size++] = obj;
 
        if (likely(rcu_sheaf->size < s->sheaf_capacity))


