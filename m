Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF614CA0EFA
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 08:04:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12522900002; Tue, 26 Aug 2025 04:04:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4C78E00A8; Tue, 26 Aug 2025 04:04:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E904A900002; Tue, 26 Aug 2025 04:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F18F98E00A8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 04:03:35 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 981A91DE1FF
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:03:35 +0000 (UTC)
X-FDA: 83818169190.26.149C5BD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 23ADA1C000D
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 08:03:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zb5uZ1Ij;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sDCf7YV8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mFTUJo16;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JLFR3swe;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756195413; a=rsa-sha256;
	cv=none;
	b=ilY/fMHJSi2/YLZCbU+IcdFSk26Z1WeG3ScocxuLj9SEPKooAgoa5PXUfEqW9f/HVXp4to
	lVXXMBX00uqsodEUSgF/HJZ2bfHJIYiwxIrb2RYTDps4bvNXf9itnyHndn4F5hjslW4PWi
	sChJ4Xi7nAB6bhtulohT4lfkNMKXMLg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=zb5uZ1Ij;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=sDCf7YV8;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=mFTUJo16;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=JLFR3swe;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756195413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZOnM5TJgUgBgtssYK/pUO0RTc/rdRZVOmP7g13VKi4A=;
	b=bBxOgYtEnIVqm4EEiPE5u+zPO5cZTkpUzWW2KhykHMXb+VMw70EBVtHyBHdxTM2UFQ1V0z
	/qSjwAEPtutrac+Q179B0z9eW8acQQa7m+yACVJp4mmDQ2zZu2XXUY+v2Xl39v9ntd9Dka
	0mFHx7UjrGJwbVh18H/tMb1R/sdWrh0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7D2E51F78B;
	Tue, 26 Aug 2025 08:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756195411; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZOnM5TJgUgBgtssYK/pUO0RTc/rdRZVOmP7g13VKi4A=;
	b=zb5uZ1IjW/hqKXfIyWrIHEMvWaDbqNAAqJ/zFE3JtLGjFsH3YweQs60kFQvuvLxxvf3o3p
	XBEzbuQ7yRIHzhDBjkjwH1/ELPmzg2izmQIFmIiIFZp4tZk7YBi4wvn2luHzGGDd2+tGgE
	dCvYyCvyaPHFSVqa2sCPNsTpwJhgiV4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756195411;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZOnM5TJgUgBgtssYK/pUO0RTc/rdRZVOmP7g13VKi4A=;
	b=sDCf7YV8rS9ANknr98HRI0+AW5m+tbof7uEfNWfqjOUCKjtnfUoxpWEW2MO8N2b1aFTauZ
	vxj2ZgZMNzaEJwAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756195410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZOnM5TJgUgBgtssYK/pUO0RTc/rdRZVOmP7g13VKi4A=;
	b=mFTUJo16T8PfpwMuoIsgJlciQO8BQtSSkKtSRm+97faX4B4N1xmaBv3nS1omCgIuJECQsN
	+0SInBpryxKaO+PnFcOVgzQXDzD4swZnTAs7V/CMPWYXmqCE1i3HmFvnydYLVZDC8jPnjj
	CZckSFEUz3RekaVTJVbLojmzmzVJbAo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756195410;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZOnM5TJgUgBgtssYK/pUO0RTc/rdRZVOmP7g13VKi4A=;
	b=JLFR3sweUFLCWSfZvIgrRWRKHrY/CdY/EiAwSmyZ/sGDAcSLCPjR2y1GkdW1F1BoB9NGSD
	79yGZC61Jgv8L9CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6610A13479;
	Tue, 26 Aug 2025 08:03:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tnKRGFJqrWhoRgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 26 Aug 2025 08:03:30 +0000
Message-ID: <446b0ed2-16e5-45fa-82a1-09ed99108558@suse.cz>
Date: Tue, 26 Aug 2025 10:03:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/14] slab: add opt-in caching layer of percpu sheaves
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org
References: <20250723-slub-percpu-caches-v5-0-b792cd830f5d@suse.cz>
 <20250723-slub-percpu-caches-v5-1-b792cd830f5d@suse.cz>
 <aKL7yYL8coNuQpAP@harry>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aKL7yYL8coNuQpAP@harry>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 23ADA1C000D
X-Stat-Signature: 1rh8zjs79mksxc3qf4mooy7iu5xqrkqz
X-HE-Tag: 1756195412-609663
X-HE-Meta: U2FsdGVkX1/W4xUoNBZ+rjI4n/mDlmrB9XIVOYZy5e2RbfeJCE4Csuf0u5WVk8Hgz9zlPzGX2ADRgRW0t8FYXd1s6OGphOl2+GAIdC84+80CJRosZwYKHbSsv7ekYnZ2BZav25jyWNtgKRXTIzxXLfoncarI0IvQu/AEOaJm2EeuhP/ASmwc2cc3wIQ0nDiFyXHnxfpeWeV2f+NWCvxFe9dnGu1zEbRZSI1HQRCGHFQK4oLzgf97rVXsD7Wb2Fo0P+GWSzi6qqAOAj6rPYxPmpCcl5Kt414hE/EcBjkH2j8sPBGq7GcTM/Db/S4ms5sbRFGtKSYEftMtF65fpDacOfkoDHqJTw1lYdPEZBndDPAL/9Ad04C7zSik18BOPEHguLkZu94NZMnDZlGDa1kIAAqlI9ogllhjmeYxsaTjXZRcHonIDGIFwZ/M1EXHokqcHe8MmxaHwBGmYuc60wHhY8tBA50W8SfPNtHYFUEJlmhXI3kfxfmt7kwiw0VLG+r2/9uZl4FisKSurFhHnrym0Z6cKYCoj1Sj92qL37jexRNsNSpPfwnYmHVs2uihFUISYtm1rw76m+VufXBA2AC4ZF8efvYH/1uAWdiEpAVRAFow71BRzU1ApDjwIFPeTiNFOJlaYr6pMD2BaUIYXcQJOF+IhEjUjn17MDIbfzHY1lEAdP0BG2vFTcjNo3QewG/jQaIMsF8cJ7UneyxLkoN27D4pVdtq0fJGY7ku8svE8FBK68nsk/iUzE0n+MieuqL4JvaD6uy7NCCtDrpI58ymJdrykInYt+t15raX2r+ptifK/0nkq4GqiWdX4dPdzqYR/0c4w0y/oBH2C7n6Y0oy6vs035Z0I16VYgLF9uBXP+7VkakhXovQdqFvuqghZPY9i2C8IgnBGIHhxeWv4Ea9QJjc5dd2N1xBZwUgJ59Bx5hB/4IytqTnoIp7kPimtrWjEYzpV0IZMpd4u6mRjcL
 NgSwlOcX
 0Wtnfa593/nIDWINKVUJ6eB66rwHwP1MejE5vbUYgPB38d8hjwvHDoLjAo87eGXCU6hDt9kxSo7LUGLwMCJDivhtj9RAGsxP5gqofz82ARu9Z370gYGR7WKG+tynvzilhKhkgQ/pApkPDIwdiivSq3yjsndqLIprPHSqGwWK4uHR22Zwpcca4MyUodnalrOUWElissowE+Qy6oj2dvppOpvYRS9XPp90wzrOFIFCI1qBeHIdfvqVHrmAaYQ1tqm49SvR6SaNMf1oZIl6wHMNEao2nbNdyHpIVaf07
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/18/25 12:09, Harry Yoo wrote:
>> +alloc_empty:
>> +	local_unlock(&s->cpu_sheaves->lock);
>> +
>> +	empty = alloc_empty_sheaf(s, GFP_NOWAIT);
>> +	if (empty)
>> +		goto got_empty;
>> +
>> +	if (put_fail)
>> +		 stat(s, BARN_PUT_FAIL);
>> +
>> +	if (!sheaf_flush_main(s))
>> +		return NULL;
>> +
>> +	if (!local_trylock(&s->cpu_sheaves->lock))
>> +		return NULL;
>> +
>> +	/*
>> +	 * we flushed the main sheaf so it should be empty now,
>> +	 * but in case we got preempted or migrated, we need to
>> +	 * check again
>> +	 */
>> +	if (pcs->main->size == s->sheaf_capacity)
>> +		goto restart;
> 
> I think it's missing:
> 
> pcs = this_cpu_ptr(&s->cpu_sheaves);
> 
> between local_trylock() and reading pcs->main->size().

Oops, yes, thanks!
Also fixed up the other things you pointed out.




