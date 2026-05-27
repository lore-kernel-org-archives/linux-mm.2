Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63D06CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 10:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93A06B008C; Wed, 27 May 2026 06:04:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A44DE6B0092; Wed, 27 May 2026 06:04:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933886B0093; Wed, 27 May 2026 06:04:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3936B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:04:35 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E3A91C0449
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:35 +0000 (UTC)
X-FDA: 84812765310.21.CAA03E1
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0F1284000D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 10:04:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mLBz8tZM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rh9FmP1M;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rFvxMq2x;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cA5FspLc;
	spf=pass (imf12.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779876273; a=rsa-sha256;
	cv=none;
	b=4+yvjh/+7OSRsymkf2jPpVC1jket4a7y9btL0O6Tk4mN977GGLixVahhDAvhQfdodVZKSa
	K3n3Q855IlSRNx2bOTPG/Kb59fZOx0NFulPcNCMcRclRUg60ErisUyQM6j3efl3C1MKYAR
	Mw37den+JyGcuI1GehNJMqZ+yPFntv0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=mLBz8tZM;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=rh9FmP1M;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rFvxMq2x;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cA5FspLc;
	spf=pass (imf12.hostedemail.com: domain of hare@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=hare@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779876273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CmYoieD2LwluZC8EpmehcWynC6L7vkpdtLzTGX53oII=;
	b=s08ummGiCqNFImFyMONHE5SCf4KVRU8xMs+5gBaKtZQ1uOyg49UrQHAmXxm2ru1QWgtw74
	C8B19izEjtSC0MEZmDBnYe8kvbSG4KsZ57wMT43MVTSuV0Xqe3Cn4u7EoWAwes45ulbC/k
	vIiKln5wyg10wTjNEY9WWAlCHZhi/GM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 524606AB63;
	Wed, 27 May 2026 10:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779876271; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmYoieD2LwluZC8EpmehcWynC6L7vkpdtLzTGX53oII=;
	b=mLBz8tZMTOXfnxoTF1GS8k2q8HVX40oAgymX2pbssvoFox9T7nOdI2t9oJsYmPC1Jz8ie8
	ilMmTmYTqDdGHmmS7kbWWg7Sqpvy7is0rrCqLmYGWDHBBoEvxegFvANsY1FGnha2wCv7hB
	Mn8LB5xMZfQRwFddTDp9aigpNJ2DJr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779876271;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmYoieD2LwluZC8EpmehcWynC6L7vkpdtLzTGX53oII=;
	b=rh9FmP1MEzf7jn0kgTmrtjMv3xE0bVxctB0yjBdUSCz2CgoJPdxwF6NWiM9pwkXEIQgPka
	rr4hXQ3EbLlPi0AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779876270; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmYoieD2LwluZC8EpmehcWynC6L7vkpdtLzTGX53oII=;
	b=rFvxMq2xu8FYED4hBciFi066c7ZdUARBy9WeJGfwFVNtqbFJOIXyC2mLrNoliz5+w5hWib
	pMjL/GejnUgYC/gkVMlcrPV/p3XKJsZb5eWUNXYz5pZ+xuKUJgS790ArpvlgikKCk0O11u
	7A1Wcv8pVWuwg32Bb+GdDYiVIsBQtls=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779876270;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CmYoieD2LwluZC8EpmehcWynC6L7vkpdtLzTGX53oII=;
	b=cA5FspLcapv1NXUyaHC1Sp4ym3UO0qdoYxldrnCIMETKncqxJtmINH2+qgYyKhUwjayCup
	F8xXoiagENd1F6Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 251015A78D;
	Wed, 27 May 2026 10:04:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i/qQCK7BFmpAVAAAD6G6ig
	(envelope-from <hare@suse.de>); Wed, 27 May 2026 10:04:30 +0000
Message-ID: <17258981-d5b3-4ed1-9b3d-56a0b6ecb3f9@suse.de>
Date: Wed, 27 May 2026 12:04:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] block: partitions: replace __get_free_page() with
 kmalloc()
To: Vlastimil Babka <vbabka@suse.com>, Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>, Christoph Hellwig <hch@infradead.org>,
 Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260520-block-v1-1-6463dc2cf042@kernel.org>
 <ahPnX-CwVgK-9chp@infradead.org> <ahPxmSqT4Y4jcAbQ@kernel.org>
 <ahP3R2nH8-bHMVf0@infradead.org> <ahQX_JCgS9JWIhY-@kernel.org>
 <1dea9df9-18c2-46f5-bf47-abb3f088574b@suse.com>
 <ahWwD0eqj3cUgaKn@casper.infradead.org>
 <8b780901-8184-4908-8bda-56fac42fe6b3@suse.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.de>
In-Reply-To: <8b780901-8184-4908-8bda-56fac42fe6b3@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F1284000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 4f7qdhy93njqkw7xj3ny1skgbqm6sg9d
X-HE-Tag: 1779876272-385527
X-HE-Meta: U2FsdGVkX1+AflHAevRuy3A0ILXt7bYDvOOI243AnlMAqZ5MfqX4e4SLdBqNJuoe6vzWOEmHrfh3dYlRr57JTU6lZ+96UBUE36atGecF6H4NjdmL5L90N5PeYIa6haa1KhD1tYcgqGlRo+yGrk6Ug9wWg3RV5B4UFpW8NZpQ/HRaQ/0mj/9B0j3WoqgjF8JtF/WcCxWQYcPze193ZuMhZSghQvQ0lEZhdeH8AnwQVgI8PdqQHtGzVp5H0MEdgcDVdn/AWhW2fOUPlPyu/vMBN0/dbMwfp3k7Vxknq5wq8VHfqS0AclV8fJSWSa9nOONcrwSVM+iDWq8YJjajYhnItDlTNV85Q/bJfgUdtDajZJBmBMv69OkcfIIfOP+ZhrZpRmRCx1A8LutQTaLAUHBpPUpSKcuG78rAvFort33CTmBJ2VT2+3lDao2mNUuUKb//aJ1YbN5ccAmyiTwTqRyEqcrbehpm7lHB4GWhPhygsSMKrWqmuGSy7xFHM5kvwKwhMWjXkOU5Hggrk4NmSVcjoekVPLjKyZx5n8cjF5QqLpuxem8VYIMd8hw5bqoxJwuJ6WQJwnOyI96HQX893To7V5qsBiLNVn+oBsl4iWlg0463PJMPUImWcu513YCGiDV3l1e0KRQOG7HF0zeIILFodXvKW7mKE4f96MEo+VFr4SLMJnQCanXcvI17a5M4OjuwNi40/HxrHg86GGpQtBOrRxRWLn4YFhq333TA6rh4WMwcteTCxwhpwX8KdNwJlh53FiKwrkBjxw+6dvt8vvP4KMPuo2FJtW9+BLlFdcyB9vMJTSXytPiEuj6LTjs1ZNk8FzUZudCNCUuk92j4Br/QAuz1nd9g3GxhFX9KyqwuEerkgHsnE2mZao4GK3KoCMHvC6ETVpRtzxwaJ50VkSUdH15F5bKTXpCG5gsYd2NZHw/Vp7i4HgCJw2KgupNiz5kR9zAwxBevqbIddHv6ULs
 eCdLtFyS
 pMo4d7IOTf3LHAE5gWcly/Li0VqI0J5O8F9EJNqAzjKOnrHKgessIOEpMkyEPluHdzogMfGnM/HyOt/MYpXHPI8OGyFeauqOQUj4b3EXZy0qm893ot2UZzqEYVNoZfvfHVVXZLT9aTkOHk+copcFdkBB8EsaIT6Aw7I3vgK43eTbiT+6UM56FFfR+5/iObBpTHBEAbiBUqOt0ZQio9wCb0FLNBaHcoChvxI4YaqKDJhRmElfB8z3XV8hq61c18R4U0XdJG6yYZKc5AWHSM0/jub8wXUkAxRMU74QlwjG4xf+FNKpkktTVc89jK4hiQAfGGSQm5B8Zi5LS5Z8GG1QpP1WJ8E8OKRMD98nzvHlvvIKJrAfm4Sbtlic6PgOJ1r65CeMWggvM+X5dIl3sN9/mTajM5kAbGseLLm2XM4bSK3ZFiK4yrpIanEa6PjUHpVoK+EX76gATeKL1umI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 22:57, Vlastimil Babka wrote:
> On 5/26/26 16:37, Matthew Wilcox wrote:
>> On Tue, May 26, 2026 at 02:07:36PM +0200, Vlastimil Babka wrote:
>>> The main reasons for switching AFAIU would be related with the
>>> folio/memdesc conversions? If one needs just a kernel memory buffer,
>>> kmalloc() it is, even if it happens to be page size. Page allocator
>>> should be only used if you need e.g. the refcounting or anything else
>>> that struct page provides. But then in some cases the memdesc conversion
>>> would need adjustments at some point. With kmalloc() we can forget about
>>> this user.
>>
>> No, I think this is unrelated to memdescs.
>>
>> I've seen a few people say slightly wrong things about
>> folios/pages/memdescs recently, so let me try to clarify the end state.
>>
>> I do not intend to get rid of the ability to allocate a bare page of
>> memory with something like alloc_pages() or get_free_page().  It's
>> just that the struct page associated with it will contain far less
>> information (because it's smaller).
> 
> Alright, but isn't it still the case that if you don't need any of what
> struct page provides today or will do in the future, it's better if you just
> use kmalloc()? I thought you said so yourself?
> 
> https://lore.kernel.org/all/aPQxN7-FeFB6vTuv@casper.infradead.org/
> 
Precisely my reasoning. In most cases, __get_free_page() is just a
lazy way of saying "I need some memory and the allocation should not 
fail". And typically these callers don't really care about the page
mapping, too.
Additionally, these applications get in the way when using large block
sizes on the system, as they needlessly increase the pressure on
compaction.
So switching them over to kmalloc() is a good thing IMO.
If nothing else it allows us to differentiate which places _actually_
need struct page, and which callers just want to do a memory allocation.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.de                                +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich

