Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 892E1CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 08:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAC288E0007; Wed, 15 Oct 2025 04:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83948E0002; Wed, 15 Oct 2025 04:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D99778E0007; Wed, 15 Oct 2025 04:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C8EA78E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 04:32:49 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82D6547BBA
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:32:49 +0000 (UTC)
X-FDA: 83999682858.02.0D92EB2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id C49CF100007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:32:46 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TdXdtKk6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1OR6dwZB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TdXdtKk6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1OR6dwZB;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760517167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZmSAZ1zl+tLy118vO/d74ruAr+6etiS9zVRUuIXuv+s=;
	b=WRxY4aF/d0JKeDab9QW+/BslDNN/FWr8l2JM5KBv5pGi/0c1x3Qik+ye0jXitKl6WWXJwU
	ZptXSRnLr82r7M5yIRY/61UGuIcWlRoP54bzXMlZAod4Q8zDc5NMYLhjbH0yP4fJaTe9GC
	9xWvgaUSWYPC/gYmpKHoihpgtekANOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760517167; a=rsa-sha256;
	cv=none;
	b=ABVasx979je2n0hZEc75P+9r1UgJOyoq1uV+nulQ4WX/wa1lAtGjQzSS5t4Yz6O8KZp9ep
	0bvRw1REQDLiFasRWcD1jYazXBHgFhZ1ErHXMAiSoSYzvtDQ9KeyX3kuNmC2vL4m5nikZe
	Xw1Z+LPc2AXo9b486OQfWbi7GvetoOc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TdXdtKk6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1OR6dwZB;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TdXdtKk6;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1OR6dwZB;
	spf=pass (imf14.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3F1EF22372;
	Wed, 15 Oct 2025 08:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760517165; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZmSAZ1zl+tLy118vO/d74ruAr+6etiS9zVRUuIXuv+s=;
	b=TdXdtKk6eTAYR0dJYrLK5OtG6Txzy9pM9vXc3Trnj1OgYG6fhHy3L789fHJDrHCvCxLIkE
	cazcaTafPJ3xLWmYa3FkvdSUPF2RXtee25GFgQ62N3Xsg2pHEkmTh5pON4A3zhAnsS6Z6w
	1BfZAIoN6jkr0g/n/sWBO+Oyi18ohyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760517165;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZmSAZ1zl+tLy118vO/d74ruAr+6etiS9zVRUuIXuv+s=;
	b=1OR6dwZBmQkyjbrXuSyxIYkCUz/MXjiLzaDKCUlGui+1IXzks5529srD0WHvMwoR+xldJY
	4gZ68YAWB/wC5WDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760517165; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZmSAZ1zl+tLy118vO/d74ruAr+6etiS9zVRUuIXuv+s=;
	b=TdXdtKk6eTAYR0dJYrLK5OtG6Txzy9pM9vXc3Trnj1OgYG6fhHy3L789fHJDrHCvCxLIkE
	cazcaTafPJ3xLWmYa3FkvdSUPF2RXtee25GFgQ62N3Xsg2pHEkmTh5pON4A3zhAnsS6Z6w
	1BfZAIoN6jkr0g/n/sWBO+Oyi18ohyg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760517165;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=ZmSAZ1zl+tLy118vO/d74ruAr+6etiS9zVRUuIXuv+s=;
	b=1OR6dwZBmQkyjbrXuSyxIYkCUz/MXjiLzaDKCUlGui+1IXzks5529srD0WHvMwoR+xldJY
	4gZ68YAWB/wC5WDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 179B513A29;
	Wed, 15 Oct 2025 08:32:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id vjJsBS1c72jMeAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 15 Oct 2025 08:32:45 +0000
Message-ID: <c0eb4acf-47ff-4e39-8d32-4e5f3857a851@suse.cz>
Date: Wed, 15 Oct 2025 10:32:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/23] SLUB percpu sheaves
Content-Language: en-US
To: Christoph Hellwig <hch@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 Uladzislau Rezki <urezki@gmail.com>,
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org, Alexei Starovoitov <ast@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
 Qianfeng Rong <rongqianfeng@vivo.com>, Wei Yang <richard.weiyang@gmail.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 WangYuli <wangyuli@uniontech.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20250910-slub-percpu-caches-v8-0-ca3099d8352c@suse.cz>
 <aOS0Z5N4HaBNeb_J@infradead.org>
 <c750ab62-a3d4-422e-ac5b-c531dfcc749d@suse.cz>
 <aOX-87tPdtuPb9Uh@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aOX-87tPdtuPb9Uh@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: w8q9txh66aj8kfr6h6ybw5t3kz5wf6jz
X-Rspam-User: 
X-Rspamd-Queue-Id: C49CF100007
X-HE-Tag: 1760517166-955913
X-HE-Meta: U2FsdGVkX1+homstp+KUev+AjfstBc3ucnvTzHsSYGwnJ1sd3J4IsVPTl4WeqKqgY9T59H7NvtAne1gXSeQiKDrA3+sQHJqYyQjrkydGEKWARrOpIMbqRQj413nVg5VhHrMhC4LnarlPEDPP0cVRWfWIN/zkMAC7Jd+ArvqgimfKc8P2dbslGtzf5aYPSs058BXS8y/0gPGwaFqyHxelPscReNJuRg85dXHkoxd7Ob2I8byEIUONAtKMEvLM5lKsjNGev3MqQqThZNvMGqkUYllNwFSHd9KDM+uOkjcqRMjjonfTA3zMFqeWZkB2Xro+udNuq0DfqH8vJFpTX/pLW4Wc0+PkWTAIn+xLm9tUT+VVoSxg7GIZ8rzBHWK2XAP+kiF7zQymMNmau3x/WIZ1LLHKhlevh0+REW6Nfr8UDmxmWPLveJGXR/Ro18CTbpL5MrfQyH3m09qRyBdxGTv/LUGyepIxCEGPdGcRi0M0BdcNrASBuhLtwW3I1LmliUKBJMWKeC90yP3L53jt1RJH3qjY1Fhmnb0RrZ05JMDYL6SJC4wRF8S3HQDNeR9YKkkl8iwPn2yZt8dYwCtOrsRgjLa1mThG78YxKcsnd3PS2w0dQG/ddqjTLCLVEsDicMb0fFWlYTHxkmfIYpsEXqMmVAT/MBnqJ/3uPmooPDLiZhGxQYWX2P7JBbzvM92AEig9cGdLQRFhc8kEg7tHD1mGHW5A/ULvYz5fXS7B9D/i9KDcmSIJYwqWo0aZiaD4y5wkYM1eIqsiZjBk0pC7AC9ukjwVi9OxAUxFTrPUFcX6OkG/Q7Ivt5rMLkM+40HLDTkNP7F2YexXnLJXi5MsBEdXOxwdUIQCu6c5l5GWqvxiSEfOZSa859+nDtPyxD4Jubxcxgs0SMwEgXkNZOI3KUMzaC0wvzF/GZJGKTbaxXNy4l2TbAhGilAIP8VcNbIabb1Jlioa3ho+LSzw4lzrsmq
 pieqssOO
 sxXzghEkUIweOimUEJUcKO2w/CaEEt4RpjQoFVfiRpTJsJoX6nOgCBbIJs4ca3fFs80nd8S2DjLiKxU9tRVl4t2CbMtS2uSBVB6PkLGTIE1TgIRK+vSEemTCqW8f0i6VhwfWNydP5sKodkiDFqGWg/qF6Jo5NI8GJCqOjnXqmLnOs3uNtdlCMam504xdTfwEImiNB5xXmayr2Qt+0JBDwPD/I/zfXa8a8K2qiZZX2HUMllKQgttNofhshSVbp5/tqTp2JcC8NNmgSJqK7U+sG74/gPMrtUXxUgbqYKmOBl82liC2dlXEyKz9IX1UhHcIryFJFBFaUXXFVXXUUMIgfsLX63Z4DW6IwLby6sXeabmvdMwlbJTA9MNxr3zG/6BNFSgkf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/8/25 08:04, Christoph Hellwig wrote:
> On Tue, Oct 07, 2025 at 10:03:04AM +0200, Vlastimil Babka wrote:
>> Basically it's for situations where you have an upper bound on the objects
>> you might need to allocate in some restricted context where you can't fail
>> but also can't reclaim etc. The steps are:
> 
> Ok, so you still need a step where you reserve, which can fail and
> only after that guarantee you can allocate up to the reservation?  I.e.
> not a replacement for mempools?  Just asking because I recently had

Yeah, not a replacement for mempools which have their special semantics.

> to implement a mempool_alloc_batch to allow grabbing multiple objects
> out of a mempool safely for something I'm working on.

I can imagine allocating multiple objects can be difficult to achieve with
the mempool's guaranteed progress semantics. Maybe the mempool could serve
prefilled sheaves?

