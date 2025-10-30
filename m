Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD6CACCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 13:36:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 350AC8E0149; Thu, 30 Oct 2025 09:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327E18E01CC; Thu, 30 Oct 2025 09:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23DD28E0149; Thu, 30 Oct 2025 09:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 10E8D8E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 09:36:05 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C06BD855CB
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:36:04 +0000 (UTC)
X-FDA: 84054879048.13.3604E5B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2E563C000B
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:36:01 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hycsPsXt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NgwLEXgk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hycsPsXt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NgwLEXgk;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761831362; a=rsa-sha256;
	cv=none;
	b=lV9f4KaKkaf4lWGofeMojOl92K64UopFBD79GlyHkSjS9iRvo5XRFSBjoy8FhdBY9t0ti7
	YWgmAmnVrAE3x/J0dymY1stSS6v52u4EJ3V/mzMNd91oraifMBMBn+uXHt4md0keUO0OTX
	8r5+89xOLMdHYinifeBw5UA33ZY//9E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hycsPsXt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NgwLEXgk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=hycsPsXt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=NgwLEXgk;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761831362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cx4e4qHpFfi03cT3ON+oqjQTUys+LHN5xAhwx6utm5E=;
	b=LPMUgG6iwhuhfzS7ZErvLr7fzgk2ZJ+NKlGzvSD3KEBNZk9ucfZgrrE14Bn0V21T2EvOq2
	VFlLRmpcZPuqXLiJ1Z+Xvn0Obkl12NafuDFovsZLpDmhuZFs5YtGjQocPFZiJ8RA2/BN8t
	InSepnh1Mv4/hhMFTdhjcmmrUujV7Pk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 31EF3336A1;
	Thu, 30 Oct 2025 13:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761831360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cx4e4qHpFfi03cT3ON+oqjQTUys+LHN5xAhwx6utm5E=;
	b=hycsPsXtvqa9RJ4pUW7D3BYM3kxhk+JQ0XzZpau83UG25Q8Lgya7xhRVp6EUbWwLg4pSU8
	t/gvJyN8eIKYM/E01vDBOi7ujx7bt2BGL4fsbHgN4QMy8FRFTaPns/648rezNOGS4FbXDf
	7kQwCD7aMuHmB9dEEYd0eTe6sSpIHM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761831360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cx4e4qHpFfi03cT3ON+oqjQTUys+LHN5xAhwx6utm5E=;
	b=NgwLEXgknCPeE5mfvhEybZ0e8TtII3rd54kFwksEgDZkoaIhXLczXcCsmOcVJI5/vtrWKx
	S4VFKy/l2tUHjXDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761831360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cx4e4qHpFfi03cT3ON+oqjQTUys+LHN5xAhwx6utm5E=;
	b=hycsPsXtvqa9RJ4pUW7D3BYM3kxhk+JQ0XzZpau83UG25Q8Lgya7xhRVp6EUbWwLg4pSU8
	t/gvJyN8eIKYM/E01vDBOi7ujx7bt2BGL4fsbHgN4QMy8FRFTaPns/648rezNOGS4FbXDf
	7kQwCD7aMuHmB9dEEYd0eTe6sSpIHM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761831360;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=cx4e4qHpFfi03cT3ON+oqjQTUys+LHN5xAhwx6utm5E=;
	b=NgwLEXgknCPeE5mfvhEybZ0e8TtII3rd54kFwksEgDZkoaIhXLczXcCsmOcVJI5/vtrWKx
	S4VFKy/l2tUHjXDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 137DC1396A;
	Thu, 30 Oct 2025 13:36:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yzJoBMBpA2kjawAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 30 Oct 2025 13:36:00 +0000
Message-ID: <60782da4-887c-4209-8014-8c2438d24d03@suse.cz>
Date: Thu, 30 Oct 2025 14:35:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] slab: use new API for remaining command line
 parameters
Content-Language: en-US
To: Petr Tesarik <ptesarik@suse.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1761324765.git.ptesarik@suse.com>
 <6ae7e0ddc72b7619203c07dd5103a598e12f713b.1761324765.git.ptesarik@suse.com>
 <aQHx_vx1ElIBh7tq@hyeyoo> <20251030143226.4661857f@mordecai>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251030143226.4661857f@mordecai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: 91m5qcijx417dw58hp4qq4z1wnib3ccw
X-Rspamd-Queue-Id: 2E563C000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1761831361-318719
X-HE-Meta: U2FsdGVkX19JG/awLliVNZ2XhGAsHRj3MQus9RGUOdIVmDZU8YoKghFajpwGO3TA6U69DfYEJUCQHclw3iK6l3iA01MilIgI07knTXOoinRdonHQZBCpWVG1iv/UdnWBGw84Nw03CvlxGArY1AdEtHJMViI9tpBltHcMaDmp9NrSYv6cpgMh1KVGs+4VqCkPIh/Q4XtTqHBXNoTy9fKfjpI2hhUXAXRlUbxkjz5CADXboKruZiRtcJ6VjySrYuer7N3f2LiNnwNXDJkIgzgRzT0KqhD/VXp7JoX5vawQWqW2GaNGrnEYC8n/d5hf5ljPWKlpFQ7nqYnPZW6XUr1jj3K7t9GuzuXbjcnCsCqMR+JOqFV47YhaLNHV9cYqoGvevHMX9fmpPcGn489jvmX5I7uV7LsZh/gvHwR6xzXymXkfFbG+NeaxHT7WFLXaguICa3VgkLdILwEZozE4mT03AlMzIIwOBijMUG/y9FXLNowDe1HY9SlpAfD8Gke35uV5JZCJW1vPnxamFAVCgo8MoDTqkKHvIqSMDKVmfd8tfxIttin70AQuWnGl1cZ3/r1MTf/vrnFDi3mk3SZGBdyL6ePXhBQK3BxZtbm1pR4YiurKMLe4KaTS+uRBzsLpIZiHSRvZEwqTVr1DCdP6OEzCADTm1H+g0qx59A56QVkywt5Qkn0usQrGp3KJ6EQnhuZpWiGQwyQRH6o+7/YLHNhcvFDazj+IPzVi+TuYbYIBEXDW4am7t3A5oCukbDNFR9FapVau0X4GGwAAU9Sg1MyzC5KfFFNhxGIGpePlFw0BFQrvLO+mS6qldwILKKylDsJFOzzh+21wtV4a8RFDUfts/ZmsNkefZzg6sSe8pedJxEsjpm2mN4sQ456dMmpMPS7SILXFOa7S9623Kj94eZaa0LaoUkbugPiNTH9zX35OyTScUrgF/E42Hv2XdeoFvMNrAGXlvDhRkIu5y9nfGYF
 AXvraypo
 eUc4R78bZW2lZpmVKsoINrSKjgZ74/Hdj1bR1oZPpOhebrJZSj1FsA/aUeeoHTEICWNHJa42jITVahAEMIcoEimryINm99hWulyTsdzDBS6KSC03ZqCmSawq6vCXVTIg7k42NC7cRdG/M96F44EnVaoCntE7quEHf2NGDO1Kj1cclBvYVUuuWV68LQ6ajqP9xIGwn+RrnJVQUo4T8dfbErotfqF/vRAtrvsStdAqbyaFYbY+RR30wnN1ZkVzsRejdo4FVDKP4BOnfzOlofQSvHVys1BDino7xzIcUJ/nJTbONUtDv0xmkbLLB4234VUNzaZqf/wbGjbuFT5M1g3C34YGmSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/30/25 14:32, Petr Tesarik wrote:
> On Wed, 29 Oct 2025 19:52:46 +0900
> Harry Yoo <harry.yoo@oracle.com> wrote:
> 
>> On Fri, Oct 24, 2025 at 07:06:54PM +0200, Petr Tesarik wrote:
>> > Use core_param() and __core_param_cb() instead of __setup() or
>> > __setup_param() to improve syntax checking and error messages.
>> > 
>> > Replace get_option() with kstrtouint(), because:
>> > * the latter accepts a pointer to const char,
>> > * these parameters should not accept ranges,
>> > * error value can be passed directly to parser.
>> > 
>> > There is one more change apart from the parsing of numeric parameters:
>> > slub_strict_numa parameter name must match exactly. Before this patch the  
>> 
>> nit: ^ slab_strict_numa

Ah right, thanks, fixed up.

> Indeed.
> 
> Petr T


