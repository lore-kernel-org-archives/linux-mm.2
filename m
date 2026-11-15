Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94647606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 22:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ZGBkIWcO;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4PQMnCTn;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ZGBkIWcO;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=4PQMnCTn
Received: by kanga.kvack.org (Postfix)
	id 8748E6B05BA; Sun, 15 Nov 2026 17:03:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8253B6B05BB; Sun, 15 Nov 2026 17:03:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7153B6B05BC; Sun, 15 Nov 2026 17:03:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA926B05BA
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:03:56 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B500412083B
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:03:55 +0000 (UTC)
X-FDA: 85438731630.10.6605D08
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8A11CC0005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 22:03:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZGBkIWcO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4PQMnCTn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZGBkIWcO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4PQMnCTn;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794780233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFjckpkKpxZQl7refnurMjE2pE+eWaaM4naABY3aji0=;
	b=J90YJsUhMRZSNOm9tBkcBUt1ZcHYuA/MWhcY0iOFR4QmMdhWZuFlm4G3r1oBR/XY5ptjGX
	7R1vdrCkG8YZBc9Bgo3G6QdDeuoW5EX/KceKpzZwPlDG3+UAoI4gTG1RFTzahLoPXSyVe7
	UEFsQzE2GQj+LUC+vCLc+mKdlGSOCtI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZGBkIWcO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4PQMnCTn;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZGBkIWcO;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=4PQMnCTn;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf22.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794780233;
	b=E7LbPrFeNPtALHdGjQpKU9U3uwB0qHVGJFNaMuZU0Rxvi21PuxyvktdRRKSf7eDY531Ghc
	eXe/fYltjMYfrw2IZNd3JfFSng2jcGd97ECvoBabuczrwkeSamFc09TAUxwsT+mqOZeuLM
	FMAXJjBEEbIl0BecqYFxNEoBNLkFC9M=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 33AF321E76;
	Sun, 15 Nov 2026 22:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CFjckpkKpxZQl7refnurMjE2pE+eWaaM4naABY3aji0=;
	b=ZGBkIWcOxQJjdDqEfSg9iVP0fEIttrVsvIVsoss9fKm4l11GcJPktxSG50oAMsrtkp3cvo
	6fesLoGr9nX+06DOsA6sVXYccYxDKwOCbKw8UtI4q8x3gvLOU70VaBDZvEbPMgBT+v1z3/
	Ikj79aL7x81OAYkHknKK5Mh6xz8abps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CFjckpkKpxZQl7refnurMjE2pE+eWaaM4naABY3aji0=;
	b=4PQMnCTnsDkT7rVaMOut/wKMfi9DV4yhSwE86WrI6WPRoW6YksQCEIpgq9eOIBRP+mhjnC
	1zJrxQTfOr22O0AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794780232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CFjckpkKpxZQl7refnurMjE2pE+eWaaM4naABY3aji0=;
	b=ZGBkIWcOxQJjdDqEfSg9iVP0fEIttrVsvIVsoss9fKm4l11GcJPktxSG50oAMsrtkp3cvo
	6fesLoGr9nX+06DOsA6sVXYccYxDKwOCbKw8UtI4q8x3gvLOU70VaBDZvEbPMgBT+v1z3/
	Ikj79aL7x81OAYkHknKK5Mh6xz8abps=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794780232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CFjckpkKpxZQl7refnurMjE2pE+eWaaM4naABY3aji0=;
	b=4PQMnCTnsDkT7rVaMOut/wKMfi9DV4yhSwE86WrI6WPRoW6YksQCEIpgq9eOIBRP+mhjnC
	1zJrxQTfOr22O0AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BAAC4134F4;
	Sun, 15 Nov 2026 22:03:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ut9FG0Ys+moHdAAAD6G6ig
	(envelope-from <clopez@suse.de>); Sun, 15 Nov 2026 22:03:50 +0000
Message-ID: <5412ba3a-ff32-48e8-b5a1-d46b97cf5f8f@suse.de>
Date: Sun, 15 Nov 2026 23:03:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 5/9] mm/mprotect: add MM_CP_PERM_UPGRADE
To: "David Hildenbrand (Arm)" <david@kernel.org>, kvm@vger.kernel.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org,
 linux-riscv@lists.infradead.org, seanjc@google.com, pbonzini@redhat.com,
 akpm@linux-foundation.org, peterx@redhat.com, ljs@kernel.org,
 imbrenda@linux.ibm.com, borntraeger@linux.ibm.com, frankja@linux.ibm.com,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
 <20261112142039.907090-7-clopez@suse.de>
 <3314e44d-dbfe-45da-a1b0-8337784a5e86@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Carlos_L=C3=B3pez?= <clopez@suse.de>
In-Reply-To: <3314e44d-dbfe-45da-a1b0-8337784a5e86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spam-Score: -13.50
X-Spam-Level: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8A11CC0005
X-Stat-Signature: r5s1ygbzomofam495ym816ht1pw96tdg
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794780233-82683
X-HE-Meta: U2FsdGVkX182LVUhz+fCdvqC7asT9wbdl2PJ2Q8y5wxRQXIGrQ6U8f5eiywmqOeTP+8+EC2CFN6aWb5mipT6lyN3CiGROZxoJ7P3oeIL6xdaTwYOMFpRTHpo3T82/JwFPQoli+lSl16Oz71v3f4aPzKGtBrIb5Wl48VYwnPW06v3CP/tVHs6L3T0/yC4WxLbeVFMQyvIBVRaqv7dOiSOGQpjMMCK6ea6ir+schDrG7bOEUAuJ1F51aUtNdo9r+wBAk4I6/fY5bya0s3rORuxokD+UIrv7hvEJ2oheqogVLVf867TmVqayVmyAl/6fIUBoaQiuowiYGdMc5L0p5qTHpofPPeYvgKaJT5V/nTaLduIM3nMl+CQN5nnYkCqcgc9jgUj+Rs5MQ32aMJGLlB+lO7FyQBiCoayu+GQOVsxPcklE/80vRSwM+0/swDyhxeuXr7ulJW92qnaA2rCIu7Wx8IlsJt4aPzbtviyNdInUnv0S05+ZFB36VrjmBs50VxY4ke/pOX14uaBbmSU3+XRoMUH80sVsfz1HK9YCxUI3UxTC2g2NNULeatq+5SRUFmSCrTxxiLBLs2uZC6bPhfGGiY8NdQAY8qN6ghwJBuU8b6vWLj+zkIq/0wiYL5TABgGZ5ZmVNRRUi4uYuhJZV360y5qJGQo2Hqn+U2/o8CMS0wl5rnDWpA3QdYFmECVGyOukGKhAbkJJq/ys5gfHEP3g5Umz9FBy6niRPF1U8nv5gRRMQ8bDqm6I6s1PzXp03ImjEQGOqDCtq4vmu67P5E8NBFMP59VRMNxQCvvBpSjwRynI/WxULbB45N4mi2LXFPcGbYFgP/Hdt4bB59wQG8+tn+0qn/Sj9JxNfAw30IQU/j0HRV9ufhqvKmYzTYnNUkez+jDQP5h+IjE6Ech7BxlS/JAiUqRcXQUbMZyglAL41n5ORDbwI9idA14Df6aNESUsVYOsT0283RXm/bQgvx
 WtAWFIRW
 lXev+glgeuXA7XJ2TiYK3D+CcUSxikdgUmE9Lp/LiDTQQPNKFdvZggnKZzxOJO2T+BMWxHbOoliO9xaZh01PU+Zq/t6zE2Toaynofa4zLIVdJgIAcPIrvJVgDmJncMU6TcO2IhkmcOW2pg92xq/7suCnaH5rjUxtec+71MsP5n+9retLSf55sh59Smn4jyB0TdrC+PWCKw6V9KRxkWjfWGvmEux7hH8dzaC0Q2/PRi+R2pfPXpe1rzfETZLUhiwkEZz46AtrQb6X+vKi4Eh3ZmVa5P+/bhcC6CAVGaCqGjHQz3yPtyQc3WgEjYSZfGv3iebBZgW74KUCnuKfxDGCG1l7oqKPE80EVMJSZmM4vFSkOW+t4nQLtXO1+PjvMqeRVc9+z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 7:51 PM, David Hildenbrand (Arm) wrote:
>> diff --git a/mm/mprotect.c b/mm/mprotect.c
>> index 84bcfe0281d3..8c0fcd10f5a3 100644
>> --- a/mm/mprotect.c
>> +++ b/mm/mprotect.c
>> @@ -767,6 +767,17 @@ static const struct mm_walk_ops prot_none_walk_ops = {
>>  	.walk_lock		= PGWALK_WRLOCK,
>>  };
>>  
>> +static bool vma_flags_is_perm_upgrade(vma_flags_t old_vma_flags,
>> +				      vma_flags_t new_vma_flags)
> 
> Two tab indent.

Will fix

>> +{
>> +	vm_flags_t old = vma_flags_to_legacy(old_vma_flags);
>> +	vm_flags_t new = vma_flags_to_legacy(new_vma_flags);
>> +	/* VM_ACCOUNT does not affect page tables */
>> +	vm_flags_t mask = VM_READ | VM_WRITE | VM_EXEC | VM_ACCOUNT;
> 
> Why is VM_ACCOUNT a permission upgrade? At best it's "no change".
> 
> What am I missing?

It isn't, this just means to cover the case where mprotect(PROT_READ |
PROT_WRITE) on a private read-only VMA sets VM_ACCOUNT as well. Without
this, the change is not detected as an upgrade.

> Also, what you really care about is "no permission downgrade", and "no
> permission upgrade" is not the inverse of that ;)

Right, I'll rename it.

