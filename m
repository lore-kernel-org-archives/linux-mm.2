Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6F8CE8305D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 08:44:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49F636B0089; Tue,  3 Feb 2026 03:44:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449696B008A; Tue,  3 Feb 2026 03:44:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 338596B008C; Tue,  3 Feb 2026 03:44:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3B26B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 03:44:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E852D58C4C
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:44:14 +0000 (UTC)
X-FDA: 84402508428.17.C51EA69
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9AB35100003
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:44:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fns0K84g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z7X6tqni;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fns0K84g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z7X6tqni;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770108253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UwAPr09xyBevgF3++iKXrEQPjPRavUX5waQDeAooNGA=;
	b=iA9MTS23QluOXIDCDO1XsHj9Lad4j/7AdUewJMhJKU8jh3U5oKUap07MiJF7NK90ZE19OF
	DM9j6CG7SNU5xQdgRE3Jx/6KQyZHO8NNuqTLfs505LCp+opqIizA94mAaFQXhui9qdyrKO
	61VJJvZ6SylbmvOjBvQiqF3vtPqI5KY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770108253; a=rsa-sha256;
	cv=none;
	b=gdE8oQmVHPvu0BnqPsZY/iY3v8DbW6quHaZrBxAhIt5x+9ZkALxAELELuhI3IDNaUXl5EX
	hixaU8PrqlBEFF5A/hUtbGEld7Y1FseMFlN4Dai2xZE+6yyNxnkEZEJFhIFts6f5cCxiov
	aF8SoDXVQJ3VoYjRJdbILEcOr9Emh8M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fns0K84g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z7X6tqni;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Fns0K84g;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=z7X6tqni;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DD47E3E6C2;
	Tue,  3 Feb 2026 08:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770108250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UwAPr09xyBevgF3++iKXrEQPjPRavUX5waQDeAooNGA=;
	b=Fns0K84gGADWdXyuIzxx5GLYPTCh8IuTmiK0LMmCWKYto1ovMDvB5ofUtHlvsXP3AYCka1
	SXtuBPNKCIv2FD64IHkQKbX9oJk2M2SYZ8saqQBWngwT7AzGW7eYnIwXv/Fr0iFi8qqZka
	eCoeUn5YnT7LUDVh6njsAsVLrhSDl6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770108250;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UwAPr09xyBevgF3++iKXrEQPjPRavUX5waQDeAooNGA=;
	b=z7X6tqniEThCjuNgx1r72u5ogssNYw7dHhoWRVae4drpdfmmWeX63h6Ei4/p88rjHJz9Ik
	vcAfAZogXqmNHdDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770108250; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UwAPr09xyBevgF3++iKXrEQPjPRavUX5waQDeAooNGA=;
	b=Fns0K84gGADWdXyuIzxx5GLYPTCh8IuTmiK0LMmCWKYto1ovMDvB5ofUtHlvsXP3AYCka1
	SXtuBPNKCIv2FD64IHkQKbX9oJk2M2SYZ8saqQBWngwT7AzGW7eYnIwXv/Fr0iFi8qqZka
	eCoeUn5YnT7LUDVh6njsAsVLrhSDl6I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770108250;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=UwAPr09xyBevgF3++iKXrEQPjPRavUX5waQDeAooNGA=;
	b=z7X6tqniEThCjuNgx1r72u5ogssNYw7dHhoWRVae4drpdfmmWeX63h6Ei4/p88rjHJz9Ik
	vcAfAZogXqmNHdDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BD55C3EA62;
	Tue,  3 Feb 2026 08:44:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /ObcLVq1gWkucAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 03 Feb 2026 08:44:10 +0000
Message-ID: <4b321435-3681-4593-a5d6-c3bbff0f31cc@suse.cz>
Date: Tue, 3 Feb 2026 09:44:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Kernel Bug] WARNING in mempool_alloc_noprof
Content-Language: en-US
To: =?UTF-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>,
 syzkaller@googlegroups.com, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <CAHPqNmwK9TY5THsXWkJuYCdt7x+mZHPq65AUOLZJeMp-FdAMvA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9AB35100003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: x1zkq338gymmrejx6e4dfy73z1f8ritx
X-HE-Tag: 1770108252-515018
X-HE-Meta: U2FsdGVkX1//O5TNGqTczBeYJNJFy+mnSZg5/PVPAQuO4fXPEm2Pr+2Sik2D1z3qz7lSZ5uMSsHtt+d3gY7KTZLvDElFALyylYjp84MZA+WZLsEvCBrjpjZU3r5JAJNnU7Jz3rUtQ/NunSjahTJ7ibEzPZ4P0JUxBXtYPwfl/B78uG7eS9Q3M1rMVOTiES8GpbpygbmOC+UdxgyQFwd2v3Qd8eSoiSMaQjCx5U5VBCdYKURjEXQEp8D/6AGDno72PV1l0rbupOXNNOSiqzLaRV7QT0IvMrlKhNCB0UUgkBgJsoIxSaZF9C6u7pmcRxAEH7EAP7WKLy0kFm/no7Mwvs3Drtj86lPK7JcK0YIJ2S7K8MBuiV1Hnbx0q4ZhygsGDtkqfroTBewr45mpIrjcaESGK1TFW9RzYybMGuhCITPYy+OgLUBpE99AggeZVKanD6GcjSnXi0gZXFsBy1zrZhj6vyUFKZJGJ6meLVWju4ne8NKqt7yQJCbzEihX8o73R1j/h8hqGUR0HHTPkAioe4gmhyp52pJGWDiDs7Pva7bLbwhBdZDK2blkqhqlV5DaPgzsW+tIkMHbjUkHXCKFhPey5JQgFxJfvRQk3oCeVyE6A52n0n2Y1ymqzi8x4goYPOC8b5P7LRacfknT8bEBSdJW5a5MslwvyCWQnokqHqE5OlhUmX0uelnOju37lKTiNyGtHI9+jf4WIsxX3euM9Km3T/wIe/z5Wrkig1TQ6TawdlsZwq+cpxwtGUcSqes3cxgMPcxs8HfXi3b+yH8NP+TttsAsnVqhQOYto44TC4AN1KM0nj5I1/PQtJ91XrcBBtgIWezXfAiAPzrEiuZw7KNJeyzWMG46tA+8nIeu6rR5+kZZJsLk1x8QIt9nq1k6xTieZtPyRb+2tj6I9/wNC4jHnmCJiCD9Y/5JNZn2TWv8MzNyS51yOffHbS2ESCiMbKOh7bKDFfZ6fKL4k8z
 oVYTqe3f
 nMH6x6/2pE1nDhbbsSZhUWVN4bfaN5+GsVoTrlK/qYh8ZdeRgZPxrF5+KTAb3Jbx2sFXUVCaJjstRTNmLeHEJcN2r9xyMaA1J/hSJCEu2olyCoLmaW/zsuYK1NT7hyVoXPgxpVJrtrx0uv/hqj33EKUfZMoOBwNQ3ABMjSoiNikbP8paT7+rrojdfKgyr9PewwrumjWDdA+NjDtvT0wEizeE1g8caJ99A9Qa5vhblkykVAty+5osRLgzmDz4k2cp65bL11mpyJSq+KsE4kUzyiVU924zaNrZOs73wfUi2hMEAK3Tu+KhMUcXYMPmbB0G9D7ki/mMTYKDN0ncSMVG4evZTsay0BV/BSryv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 07:40, 李龙兴 wrote:
> Dear Linux kernel developers and maintainers,
> 
> We would like to report a new kernel bug found by our tool. WARNING in
> mempool_alloc_noprof. Details are as follows.

Hi,

> Kernel commit: v6.12.11

that's a very old version and your reports could get dismissed - in this
case you were lucky. Please use bug finding tools on recent versions.
Ideally even rc kernels (now 6.19-rc7) so new bugs can be fixed before a
final kernel is released.

Thanks,
Vlastimil


