Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 593BDD7234A
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:25:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD04C6B044A; Fri, 23 Jan 2026 03:24:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9ACD6B044E; Fri, 23 Jan 2026 03:24:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A656B044F; Fri, 23 Jan 2026 03:24:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 860D16B044A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:24:59 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F1E5139CFA
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:24:59 +0000 (UTC)
X-FDA: 84362543118.25.33747E6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id E64CE140008
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:24:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="dVgz2B/U";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R1AHuviK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="dVgz2B/U";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R1AHuviK;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769156697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HX9jMOalZTXsJvwVorva6xTEEt0s5gXTpdQM8dYUdKc=;
	b=copzW6I421KkYdIALkM2S33C3feAYI0cQQ5ZoGgqvvWoLsB0uvqD6umclyyiDRP/77R2xv
	+KrN1rO7UcUUbyl/Yyrrfx23gaM2WGlRfOid39Zbo6D7Q3TQD+QWmhIVsjxD7fZ4e9URkO
	fYwvzdaTM8/rXQ5VK4cRCZr3jn4GUjk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769156697; a=rsa-sha256;
	cv=none;
	b=Nyb6ivr/UloGCj+eEStrQS8jbZf1tEX5rjLnl2I2RgmH4SLy6u60Zn2ZcyZAyhxDolYyDI
	C38/zBUxXYrKSlLDfOPWWQkXchWC1MSo4npCZx3MN5sNlPN5Z71hZGiijE1dvDwfeNdlB1
	X5eAUlot5mCh3+7xRB6B2RrAfGiDvhM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="dVgz2B/U";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R1AHuviK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="dVgz2B/U";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=R1AHuviK;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 57BAD33768;
	Fri, 23 Jan 2026 08:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769156695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HX9jMOalZTXsJvwVorva6xTEEt0s5gXTpdQM8dYUdKc=;
	b=dVgz2B/UR1O0R0H9iw+nTs68HQiaCe/trrf2rWuk52lcgimh35I89Ugcejlq58WsvD8rkS
	2xMYGqbszOI/VucSszU1RTpEWh+8/DlPUzKuZZqpyqf5NAbT857TvAyHc0NE7l5C16W4ba
	qeKnTbSNZf8pRHSmYhaJGxyr4wn/SNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769156695;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HX9jMOalZTXsJvwVorva6xTEEt0s5gXTpdQM8dYUdKc=;
	b=R1AHuviKLQM92RU1qqPoXbePiWcf0XrgMFPNmj0UE3RiHsBqnYx3EzQJLTJDlGHQWtUsqB
	LgPJ6F8m3p56NEBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769156695; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HX9jMOalZTXsJvwVorva6xTEEt0s5gXTpdQM8dYUdKc=;
	b=dVgz2B/UR1O0R0H9iw+nTs68HQiaCe/trrf2rWuk52lcgimh35I89Ugcejlq58WsvD8rkS
	2xMYGqbszOI/VucSszU1RTpEWh+8/DlPUzKuZZqpyqf5NAbT857TvAyHc0NE7l5C16W4ba
	qeKnTbSNZf8pRHSmYhaJGxyr4wn/SNM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769156695;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HX9jMOalZTXsJvwVorva6xTEEt0s5gXTpdQM8dYUdKc=;
	b=R1AHuviKLQM92RU1qqPoXbePiWcf0XrgMFPNmj0UE3RiHsBqnYx3EzQJLTJDlGHQWtUsqB
	LgPJ6F8m3p56NEBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 24192136AA;
	Fri, 23 Jan 2026 08:24:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 1MMXCFcwc2kkOgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 23 Jan 2026 08:24:55 +0000
Message-ID: <168cbc6c-5f7b-4324-8d45-d9033613a67e@suse.cz>
Date: Fri, 23 Jan 2026 09:24:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v3 03/10] mm/vma: rename is_vma_write_only(),
 separate out shared refcount put
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, Peter Zijlstra <peterz@infradead.org>,
 Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
 Boqun Feng <boqun.feng@gmail.com>, Waiman Long <longman@redhat.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
References: <cover.1769086312.git.lorenzo.stoakes@oracle.com>
 <c51d6396d78532d85a542da07ba783bc838b852f.1769086312.git.lorenzo.stoakes@oracle.com>
 <6f45d01a-7586-4d8a-8339-fdfbda4c971e@suse.cz>
 <CAJuCfpHhVOC5kzapSPtvUHGy3jMr8DyjPba7tkSv5zOWotvcQw@mail.gmail.com>
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
In-Reply-To: <CAJuCfpHhVOC5kzapSPtvUHGy3jMr8DyjPba7tkSv5zOWotvcQw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E64CE140008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 3sa74ab5668qz8cqknmykijmb5h11697
X-HE-Tag: 1769156696-649178
X-HE-Meta: U2FsdGVkX1/XyuvnxfF2n+UavYfLzJ2lPftAX5bsiXPW4HplCCohuUI3aOyyrAug3eVvZ8DcOgp8ZDW8Do4W1r7Aay1BXMh9DTugBDiBXvWcchYv3TYddWcpE7kzwXPqhm+9ExPRXuZCc2JShKNx/cMxY7ftZklciRPq+WnthQ40qzNWuktJP9OImysBxTkEDpEiQ+XWY4ozWC8Xi+lfJHm72jbJfQenS8ZoltpmDnG+2HB6JBkTUYFphphIlzRxhp4GYV576L0aLuirrxJDfWL1jdBguLFLcjV02uHVSRguw68y8/oGR4ZucJ3TQeM8ovauYlkbNRsPtu+ICsVAQ+jj/U9x8u+2O0FiI+XgPqTOKnj4j92f8LEhMo4+lNFZeNr+CARVB5Mq1MRgN7Xs5txhAftCm6s1UJkyAYCCSsS1u2I0PYSH6c85ijH0LYkKSST6Ix4h07guCpbF7xCrrjDtzbpKo6Us/lFup0w78PVjAYLUxwy6FRxmy+cWzx1SlyKSpwUME1CnstJJHRo1DUtDQEIDFxN43/7Q4KuBVJXAIczObKT9vorMIJ/OkKZa6JZE2MDdrE5wmfb0IuEBTiRyvAr3cAtXKjBMSbE+UFL0lvh1XszLtn5+yZFeEsgtpMae+E6fWY/u26lIVziwqCkkkw8TrEltzjeRahMoYuJ+7EAzLwreQrHLu7xbg1YcvZSj2V4baRGbXVxfvTHF9PcQgwzD7HbYeOUrQQzSIBv0aICGCiLWr5PHHANALj5ZwAoqnjslpLyYbt/giSZIC3lU85DwnoINflfJbDONF12f9EGswywSc+BaPpdcEwt1V/EejAn7XCEgnbxjNaTHm2qoGjnSoxtaOw4vhUeRzkJhe2ekF5jRH01f+/tts7DcYqeShXq2zgm/zj2B4Vo7TzNkx7gJwe70RQZtnSWyz4wGQ357aoP8xR4Ah4StY1cEcA/iKRAaxNoiNrYi/IQ
 xDVXfP2H
 xZOEntcQFUTM/v4eGHYyn/1QI8I3YJog3mn/hNwIGb6hwDDC/bS0nZywVRhnelLpz45KdE+B6eAF+eAG+8hPmjQohAUAXWGPH7buay0txj3rpqPAfUAmllR3aVMJbzJY5VHXZX4OUo5brSksDH63lOGmC/hUJX3wYr0yhICUnchfFTlqhpLSGAvVhvxYOwVn/BIOV1uTAlWz730JlNfTdZA3/+CZM6uOfcAgErdQwIc9BQn1dIjMnVoKJsCVpSeS/EKTsFPmM9WFRbT/jdQsNag8WQNMxhafEwNys9w34x3Q5afzPD2gjovUPp4+jEcV5LhwKlOXG3iw5DNkRu0k66nVLZf/QLVxKiWiihKtxkjH0VOwqoSVqw5QW/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/22/26 20:31, Suren Baghdasaryan wrote:
>> > +     int oldcnt;
>> > +     bool detached;
>> > +
>> > +     detached = __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
>> > +     if (refcnt)
>> > +             *refcnt = oldcnt - 1;
>> > +     return detached;
> 
> IIUC there is always a connection between detached and *refcnt
> resulting value. If detached==true then the resulting *refcnt has to
> be 0. If so, __vma_refcount_put() can simply return (oldcnt - 1) as
> new count:
> 
> static inline int __vma_refcount_put(struct vm_area_struct *vma)
> {
>        int oldcnt;
> 
>        __refcount_dec_and_test(&vma->vm_refcnt, &oldcnt);
>        return oldcnt - 1;
> }
> 
> And later:
> 
> newcnt = __vma_refcount_put(&vma->vm_refcnt);
> detached = newcnt == 0;

If we go that way (both ways are fine with me) I'd suggest we rename the
function to __vma_refcount_put_return to make this more obvious. (c.f.
atomic_dec_return, lockref_put_return).


