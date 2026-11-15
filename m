Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4362606A31F
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 21:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=gY3mMjYg;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=DmLbD5KU;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=qIV84Pyr;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=mZIJVbXM
Received: by kanga.kvack.org (Postfix)
	id A915F6B00EF; Sun, 15 Nov 2026 16:59:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A422B6B05B0; Sun, 15 Nov 2026 16:59:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 930B26B05B1; Sun, 15 Nov 2026 16:59:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 642F76B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 16:59:49 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE669A8590
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:59:48 +0000 (UTC)
X-FDA: 85438721256.12.3D70A11
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id A1BD9140007
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:59:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gY3mMjYg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DmLbD5KU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qIV84Pyr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mZIJVbXM;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794779987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVZtep4ZvvYVafoyhBpdOjFTJN1dKVl9nzH4Gq67ry0=;
	b=MKzPnAMJF7ESiEuqgAYGVsgHfcH5SzCbudZ63Eqav500HL+mGeAm7JcJJ4zQX96EUT3PGM
	5xwcCkwD5f+0buuPU2d7VxCWprt3Uf0On4ENgeBdWg8Z4HDM90w9GBUKMtkVpx9mCggViD
	jBoFLjMq2wRJz6ZaKZvPH64YY21WjcA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gY3mMjYg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=DmLbD5KU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qIV84Pyr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=mZIJVbXM;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf23.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794779987;
	b=z5YzMq2sWy7imB42mr7StllSNpkrw+/Oxr+GDg2myWk8HCyufEPOiGTIWhrxbWHhY90LDI
	JWehAOHyC2Bg3bvNkXL3wRzJ7VOiHrIOINbBJvLsXDqozVGcaaAPtfYXtfVokFlc/xSeni
	xnSLDJhvnUxCeBZ7uuyt/6dZHHWhWNM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1ED7B1F449;
	Sun, 15 Nov 2026 21:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794779983; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVZtep4ZvvYVafoyhBpdOjFTJN1dKVl9nzH4Gq67ry0=;
	b=gY3mMjYgF5vu+pI9mP2Rd7Drc/pLMD4+v0EO8drluBELU1wBHzwhO1G0DsDiVTzXFHGgH+
	O1TnR4e+K/hgSgv0EpizCjhk7Znh2BGwNm/UvaVImw1Nl0VmTZZ0sY8HpSDVbFQn5Cmuwe
	x/iUHMnlIVIoZGAEAtOoUhKk69k9i7Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794779983;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVZtep4ZvvYVafoyhBpdOjFTJN1dKVl9nzH4Gq67ry0=;
	b=DmLbD5KUDJLP/w2kKJHYFJocZG1hzbxdIfNN2YISnQFOeYfkFh3/beBXJ6IR+yltYHkFXR
	2sIQl02LYF9HBpDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794779982; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVZtep4ZvvYVafoyhBpdOjFTJN1dKVl9nzH4Gq67ry0=;
	b=qIV84PyrNE0dD3kBoWUBjZeNZWF3AuDrlfCmqolb2FyOl3t/p9nLINmfhRiuwbEhnf7cHn
	uvbVod1sY0b1k4VFPEjCI4wF9A6sHGkBMWXKQMyIMavO1PCvH88n5U2cE3xwkVVWvd5TV9
	ynZMTjAbR5YSxOQOGxknOfLcTpH5dRA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794779982;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CVZtep4ZvvYVafoyhBpdOjFTJN1dKVl9nzH4Gq67ry0=;
	b=mZIJVbXM4XB1a0Tz1IPi2hV9yfHM9XZLuK3X4kSgmZKoLw9I0IrLNWZDHe+a9xJq9w2YW+
	TR77jarbUdO9STAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5ABED134F4;
	Sun, 15 Nov 2026 21:59:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 408tCkwr+mr9bgAAD6G6ig
	(envelope-from <clopez@suse.de>); Sun, 15 Nov 2026 21:59:40 +0000
Message-ID: <743f60f7-d611-4d73-a2d1-d5873bcdda36@suse.de>
Date: Sun, 15 Nov 2026 22:59:39 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 4/9] mm: keep writable entries writable on protection
 changes
To: "David Hildenbrand (Arm)" <david@kernel.org>, kvm@vger.kernel.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, ljs@kernel.org,
 imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-6-clopez@suse.de>
 <603cd8e0-c2c5-4c1e-85c4-d0a5ceda8d4c@kernel.org>
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
Content-Language: en-US
In-Reply-To: <603cd8e0-c2c5-4c1e-85c4-d0a5ceda8d4c@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.50
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A1BD9140007
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: n8skrfbkob46oqib15nmpzdniczubu3z
X-HE-Tag: 1794779986-357611
X-HE-Meta: U2FsdGVkX18zqdT3cEy4hgYpRrOToB7yUsD+0eQFGL70ja4gyfKnrLCkPEQA1yJmTSkfL8DE7Ex5/XFPj+nA145Hzp6KghuIOZNNrVJvOxOTpZimJTRF9v5TbUQUNAQvGE+ieCjUNxPtddT6rkXqMVJCNKhzM3HzL25aIop9pgLyqxNdefKmfK69tOc/whaFpIlhzqwYhdwI9L19hLsUQyF58N5ESkU/PVD/Hb9Y36UjuK0pBIEkFzYMT4w9Tqsp24g7DgoTr42Fs+yIONoqPbLmA1vuvPjnSF4sqROAwt+avkIXBxKk4pPAkPCWEkdi45rfuAEk9VeVDzZDUclbcmEdrq0rix/zts05dTYte7B7bptZe3BLr3ymf+xIDxE9m4M6lIhHF5WSkG9U/mV5YznAH91MPqyp+9iyqY1CaDWlrSl0rdrk5qxR5IVoSd77cdC4euXkeYyf0/0CXPe/PUoOegyUaynG/57yG2S9G1bWH/oLrrtQnEQkwcIwEZ+e+zuDi0SNB9JJII6hiCp2N0u24URWH8AQ5yRhhWLhxSYmglfycUcDBwwdl8f3B8JEEo8k5y74M/d3vjqhtVrIVI7pkSlYEtSLIL7CqzK5Wt/sp41iZgEssOWerTQlFwyw7NaUCF0v8JaRtg5lQKidpsmAkOpY9O+B8DYDm10nIkSKVy7P1vy2dsGnWCgaii+wJWrcMWtF4BDIfxpSxcVO/QC2PNJOsNo9AEUSEDm8E4keHlP+49MRAJGFdAvadqU8jYqRfEgpyrtGSCk5TqTX9MVIRkWaTKxOsaHwx8focSpEAXnrnReuZ9UKNutwAikd0Rur9TtPCoRpCt8MkVR+Qiii0wIZe90OeFJAotvp3CKnRGJm7dUCsloC6TIWvXikmlxbGZ0g2CR6Q2LbUE5L5qmAcokcXSAenPCXmAqoIhf73lmIyhtw+KcmHkY6mgNml3UA/k48wy7SPPIhH3g
 Za1lB9wx
 ZelEJjz0ZEIBT9SM/PUOrTqEXR/FC5NRyIdJRNd0kJw6iQQ8Yvz6gg7kCHvFgqWbYrNbHPKo5cs3IBqkaBcypvMBtVZcJ6mh345pQC8hGyUpJQutt8yGgww8i9l59JvYE5HHQt9ewLBpVrB75SemTmth4rvH8ttA0CzAcnPDa6JCMAVhzE7YJrUgbkAmIz6CzrsJgwNc2Jtg663oFq91mFfIBjwTp/EXAMo7YzP9CIGBO1o8cPdoj597yuGMVzn3d9R2yuooGPek0sj2B/H1XK0cYgM84gg0aOP1YEvmaMovSCvA/KxIXr8+S7AlbYpCuPPxnAjAFg3p5XLI2c6uMN5aqaiJ1tuo9HlwHwWGfvHC/njc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 7:56 PM, David Hildenbrand (Arm) wrote:
> On 11/12/26 15:20, Carlos López wrote:
>> change_protection() applies vma->vm_page_prot, which lacks the write bit
>> for CoW and write-notified mappings. MM_CP_TRY_CHANGE_WRITABLE makes
>> entries writable again if a write fault would only set the write bit.
>> In shared mappings, it relies on the dirty bit for this, as a clean
>> entry might still need a write fault to notify the FS.
>>
>> However, this misses clean entries that were already writable. For
>> example, a uffd-wp unprotect makes shmem PTEs read-only if they were
>> mapped by a read fault before uffd-wp was registered, so the next write
>> to each of them faults.
> 
> See my other reply, adding such optimizations without any motivation why we
> should even care is not really what we want.
> 
> Drop it from your series and keep the MM changes to a bare minimum please.
> 
> Or is there a real dependency for your work?
> 

Yes there is, but I clearly did not explain it properly.

The whole point of the series is to avoid zaps when no permission bits
are removed by a protection change, e.g. mprotect(PROT_READ |
PROT_WRITE) on a read-only VMA. My proposal is for change_protection()
to signal this is the case to MMU notifiers with a new flag. However,
change_protection() sometimes write-protects entries that were writable,
which makes the flag wrong, so this patch fixes that.

I'll be sure to explain this properly.

