Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50434CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 21:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6269C8E01E5; Thu, 30 Oct 2025 17:48:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FDAB8E009F; Thu, 30 Oct 2025 17:48:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ED2E8E01E5; Thu, 30 Oct 2025 17:48:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3DC758E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:48:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D092A13A574
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:48:24 +0000 (UTC)
X-FDA: 84056119728.19.2B6E2F5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5187D8000A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:48:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CWwi1ZN2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IHT2QUyE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pHrXAb92;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gl2zaOn8;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761860902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tuaScIMcrrhodAsQYWR/pzyJZ/yPqkjuHeawwOY4OSs=;
	b=GytKwRBkbkcBolOyJvGiuX44ariqOelfwr9SUG8lAprkMB8Sh1ZoqZWE7OpwaNjvP6tkoQ
	Ntul3FXCmOl5aiIAyUVJUHGkN/QrjGCgx8EVnH002wVtGGW2LXggeFt+lVTkBXoW8qCSol
	QumRoAYMC9MmCuxpwljfIocbfmkqEus=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CWwi1ZN2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IHT2QUyE;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=pHrXAb92;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=gl2zaOn8;
	spf=pass (imf30.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761860902; a=rsa-sha256;
	cv=none;
	b=wkTSSwZJm2C46n82Yq3pjjyIO1MzZ06Y+5qyk62+eXqe4Ln6m5UcAEKWQ9mX72WeXxzouf
	SmANFOiM8D1ryrkPa0i3+NAiFYpJVXMjocYGeJo/jp7GlwM7zGLqhjlWCOSz+Asn1ZsCjP
	GG1jYZfEtTHcyBYYXbm6Qn233BZdk4I=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 79F683371B;
	Thu, 30 Oct 2025 21:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761860900; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tuaScIMcrrhodAsQYWR/pzyJZ/yPqkjuHeawwOY4OSs=;
	b=CWwi1ZN2PDFTwP6IG3/nrXaAJ4+t4nINrmYrPNce6qBHL0J2iVx7lxhLCq9GpNTRyIAJ6A
	rJpbQA71fT3UkIT3Kq7DpQEPWdmSTxinb+bcWNmNp6yRx7qwmE/+QBNUJk26hx1Q1t4/YT
	LLZzlYgDgu5ahbs0fhUaGjAoYFfgYTk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761860900;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tuaScIMcrrhodAsQYWR/pzyJZ/yPqkjuHeawwOY4OSs=;
	b=IHT2QUyEiqcakoGIjbGocHiZwUydx5+Eftk69hpX7lktrin2a0GX2AzuLVKaOVqsyiSOL2
	v1K/wZXNT3OMWIBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761860899; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tuaScIMcrrhodAsQYWR/pzyJZ/yPqkjuHeawwOY4OSs=;
	b=pHrXAb92ICzphAPnxytqi+TmNeixgbqlmWbEUBPedD0pzqam8mFVRPFGYI0xWMyOfmvo5L
	AFetASCK7mKdCXhPIa09XQO3R0PbqOD0ojy5XMEmH3Q4A561bqvFJi0+hr7uYLgFnsRLX5
	H94/KWFjSOO2d2uByy9iRE3gKP8Sqe0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761860899;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=tuaScIMcrrhodAsQYWR/pzyJZ/yPqkjuHeawwOY4OSs=;
	b=gl2zaOn8cwauq+PDCyUPOt26ZhOcJQ4sHH+24gTF7XlOpzPxeDtZGDf2UPPB6wAD2f9e/B
	6C+tam/btvjyRbDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 489591396A;
	Thu, 30 Oct 2025 21:48:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DvAFESPdA2mQSQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 30 Oct 2025 21:48:19 +0000
Message-ID: <a3bcac19-78b7-4918-81b3-641a65a19a9d@suse.cz>
Date: Thu, 30 Oct 2025 22:48:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: introduce VM_MAYBE_GUARD and make visible for
 guard regions
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>,
 David Hildenbrand <david@redhat.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jann Horn <jannh@google.com>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Andrei Vagin <avagin@gmail.com>,
 Barry Song <21cnbao@gmail.com>
References: <cover.1761756437.git.lorenzo.stoakes@oracle.com>
 <7de40603015dee82970f5d37332a6d5af7532063.1761756437.git.lorenzo.stoakes@oracle.com>
 <xnsn5rfqigbm5ryjtbf2rtfotneiwygzesvyfdxiqrzlyzljdr@tmbht4ggnjcv>
 <61ae955e-310d-488e-b350-59bb809f06e1@lucifer.local>
 <c736tssdw3z57kamh6eqc23gr575q375n2o2nnszih64afnaf7@zwbqremsbhwf>
 <053f3a04-9195-4f8d-8959-42e0c3ba077b@lucifer.local>
 <72ee2324-d599-44b6-92ce-ed0afafed78f@suse.cz>
 <3ae457cd-6c18-4870-a617-7f937b107cb4@suse.cz>
 <88b72728-fa3f-4a70-9ea2-40ff50673047@lucifer.local>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <88b72728-fa3f-4a70-9ea2-40ff50673047@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5187D8000A
X-Stat-Signature: n84c6ctfrj1yztkfkb3ac6m1dm3y8tpg
X-Rspam-User: 
X-HE-Tag: 1761860902-625946
X-HE-Meta: U2FsdGVkX18jBi3J/gVqIRxfE3Y4R5Z5LuMWdVTm4TViKXehc3w2EathNS4/hssfv1D7eDCbRtrdWIlubGwV1GNsvBJsds1k3QoZjBxv6WWvBHkPknEOyiH7GapnSkjAu5e31xBn8suHV0wkRzIF8/Y+dmbdKZzQXWoLavCA7KJzHEJRcjlNqXTRRVrE/nF+tFE0e48Zllwd3NSfl+TSxt+gtGkePNylLz+2CvexfGoFs5qqn1+VaX9k84nFFIIPfgOewb6DVfrn4+DqVNTuw6nFWI2TVXgX7pFf2o1oddnBD6XhejLddJnVc9kGzx8D83bqWnpcqHHUR1adhWpk+XoOzrMeoOfLe+/fPCbC/m6frsSONZh2O7jaxOuC7GjGIOzJlVOxW/9zweAlCn0xRQNBp0Zg+hNOeOiTnMzFNviwRWM5mB/DbTZ+1wwdg6tuRO/Y52dRH5olpsjHeibQ3JLtbmJZnbQ58gu9/nbYx/9r895SKVpa/FvgNDKEOoEM1buly8aUS/oqo2+ALTPon/MG7/cKVMbxygjKbQg7lJOw+IY65HuuiTw7VtQdlnliERWeXCPiEBSp7mG94SZAtT7VfhntO3follgRu4ZfqrvGryUqV6hIC17lcs6+e4VQrDuBr1lZ4pzv4eVY3qIJ2Hhip1yXYWtAvKO4P9NR6HL+vLy6G4J0EufPCzlPWdFczUbpkKeJJ+PQiWKNw1Alk5WpHs+OBEaW0lOJWMDcAXmV0hpPYSspTCo6flseIWyIkKNQNvi24PJeavGyrQgBPoshkZH08/pBvyL4Vk+pWlU9ZOC+ki78+ha8NpzxXdQ01DZY0LlHpFtOXLCMUOFZ+WSHTXh7ud31qDnijr0G/ZUVebuV+9AbCkjHQkao/x+hb8I5cms3VDKmYhQgi6q2EZ/aLBTvTJiM04YU9q6XvsQejaeMn1YlRC7PshypXwq/QyBhQsigY6uXWyLdTzT
 QUz6xMFm
 LmV26+Ywfjdrmw08MJ5xHxwxk51Z+ijvVYRifPNcMBCv4TcAOdJotq6zwiJtPpoTpdlPOtBvbEYL4JB9b/yTLEiohud/ttpHjmnO9SgFSczua1UHGbwXbOf0g4N2p9+wdVd+pB1jYYdiRvyfdWEaUtS59jg7yjjNYEkBPctv0Ji8/9Bt7n+HTena41C6dIDgWToicDTfUiXwmPixBRjvAbEtybUiMBlFIgGwMp8PjXUsRdiSlYGiwJ4MRYTUk7eqxmpw9aff5VbmwgNbJNTRNfsNkn2QuIm1VVM42/T2lJCvm8tjxLNsixs8mhHpdp3MyrKFwjLbw/ARuI0y0OhEKQRJELQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/30/25 20:47, Lorenzo Stoakes wrote:
> On Thu, Oct 30, 2025 at 07:47:34PM +0100, Vlastimil Babka wrote:
>> >
>> > Could we use MADVISE_VMA_READ_LOCK mode (would be actually an improvement
>> > over the current MADVISE_MMAP_READ_LOCK), together with the atomic flag
>> > setting? I think the places that could race with us to cause RMW use vma
>> > write lock so that would be excluded. Fork AFAICS unfortunately doesn't (for
>> > the oldmm) and it probably would't make sense to start doing it. Maybe we
>> > could think of something to deal with this special case...
>>
>> During discussion with Pedro off-list I realized fork takes mmap lock for
>> write on the old mm, so if we kept taking mmap sem for read, then vma lock
>> for read in addition (which should be cheap enough, also we'd only need it
>> in case VM_MAYBE_GUARD is not yet set), and set the flag atomicaly, perhaps
>> that would cover all non-bening races?
>>
>>
> 
> We take VMA write lock in dup_mmap() on each mpnt (old VMA).

Ah yes I thought it was the new one.

> We take the VMA write lock (vma_start_write()) for each mpnt.
> 
> We then vm_area_dup() the mpnt to the new VMA before calling:
> 
> copy_page_range()
> -> vma_needs_copy()
> 
> Which is where the check is done.
> 
> So we are holding the VMA write lock, so a VMA read lock should suffice no?

Yeah, even better!

> For belts + braces we could atomically read the flag in vma_needs_copy(),
> though note it's intended VM_COPY_ON_FORK could have more than one flag.
> 
> We could drop that for now and be explicit.

Great!

