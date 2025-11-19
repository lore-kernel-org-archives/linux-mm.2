Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67DE1CF58C1
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 17:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C51D06B00B9; Wed, 19 Nov 2025 12:38:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C02E06B00BB; Wed, 19 Nov 2025 12:38:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF25A6B00BC; Wed, 19 Nov 2025 12:38:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E63F6B00B9
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:38:48 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5511812DB84
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:38:48 +0000 (UTC)
X-FDA: 84128066736.20.07B01FD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id DDA9216000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:38:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T9JBzqVh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yLu5T8cW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GzUsgZDZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XbrrhC6E;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763573926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mSLpYwyWs0jTEtlK1pjJRZyO0gy9r6uw5nGiKgaKjk=;
	b=6L+XdjZQRqlWPpiZJvlNmm4BJwYGPN3ZZZlTtKK+z9uyLeBbB9oyc33LRbEGizixVg5eLX
	RzQe3XM65WdIxqQXDaoQlXy/Sr77cLd89FCqX710GmFuHytQ5Q+dZKY6XyHEFd4f3srBWI
	1KVelxbhj5sA4NNIUKiSb/MjbeXfr8A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763573926; a=rsa-sha256;
	cv=none;
	b=1RQkYXxdgShT95SvhfT5m6B1256Crd9oszLOniw+RJ67oyN3Os+uLi9vj9ulrGLPM1r3II
	XQ3mqLTLjGN5NjUYXsQcf44KcqpVdDZ/wDpzZb3CHW0vn1JB5EpT0Y/Qwb4Zu0PChWMvgT
	YQXvPCe5F5SJYFoXgOfE9GAnj1KEDUE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T9JBzqVh;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yLu5T8cW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GzUsgZDZ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=XbrrhC6E;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D7E46205C6;
	Wed, 19 Nov 2025 17:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763573924; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1mSLpYwyWs0jTEtlK1pjJRZyO0gy9r6uw5nGiKgaKjk=;
	b=T9JBzqVh6oEbZwD5zolZL/taXOZDPJQINezckSXcdw3oKZ+HlPl8xO8onVtGG884PuvmuD
	v4hhDJsI4s2rKZ4BHfoAjD3RMLotXasXmZLRoWpJJPSdaAszOIJML9M/AVg2hd+lhYQ4X+
	4ONp93kZvetqvITD/kHjCdMrdsGB2EU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763573924;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1mSLpYwyWs0jTEtlK1pjJRZyO0gy9r6uw5nGiKgaKjk=;
	b=yLu5T8cWoBzkgrMG23WZh/ekbOdkBOvDajoWCleFw+AGIBFVCDIUaczHIkmJWv1BmPNRZr
	6cLW3DRyJhB6BnAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763573923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1mSLpYwyWs0jTEtlK1pjJRZyO0gy9r6uw5nGiKgaKjk=;
	b=GzUsgZDZi2H4PYOhAcEcflzMFnL3xgGyZJUobW02hbnGJ4r/CxeX8xfkTAm2XqycTny8lC
	moBN1wLpotdNFyWgoC739VKl8eAN3YvsyFsbdkmwjM8ISLfzq8G9Rs/Rgj2ftvsGhT7Bdb
	Iwybmk0hLj/lFa2mmvD/G64xORgHBbI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763573923;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=1mSLpYwyWs0jTEtlK1pjJRZyO0gy9r6uw5nGiKgaKjk=;
	b=XbrrhC6Ek8BBPwakObopUIjoE57tTvkr7nU8fkUIglIghQR5YqYG5ZP9sM3zju6emcA5Fy
	LIhmbD+QgNUJgMCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB38A3EA61;
	Wed, 19 Nov 2025 17:38:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gwRxKaMAHmnHLwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 19 Nov 2025 17:38:43 +0000
Message-ID: <9b82c8fe-7321-4481-bd02-1c0628eaf57c@suse.cz>
Date: Wed, 19 Nov 2025 18:38:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: propagate VM_SOFTDIRTY on merge
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1763399675.git.lorenzo.stoakes@oracle.com>
 <955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <955478b5170715c895d1ef3b7f68e0cd77f76868.1763399675.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: DDA9216000B
X-Stat-Signature: mgfy7csbk6pisyu8u6j8gyyqa6sdx9q5
X-HE-Tag: 1763573925-112918
X-HE-Meta: U2FsdGVkX1/F8HFuULDnu4tDt7fkB/VYB3SsS50OxJiiHrcZaaFrmPWexilPL9//RG1D9B7CoUPqLDC6Nmgyhl9lSJSFZg7NyXGdjWEEvsZBsMgrUn5hhXwl7sJwgDgI1ZNE/khcnwI0+1THoGSJjHhttrpBYETK3l8lK4KbARznuosYiNe7D2F1QJcy6wrkMZpBUL+f41Z0acMndjSuND5dZMg+vi9xKGU+DRiXZsMGQV9njJvJMHCzAKhZIrumxp41wSt7n/wO/bhYVYhg0Iuuly0NjTHHQDPvybMj+wgvfiaLknrmC8KcTr0rx0dsfrW1qqXU2fB6B4f54riUuxFMdR+h0zGigx4MSo5yk+2S+0qLpcLDt/kesa5fM8HpTnEjsJJ2NSFYJule+FmM4xOYXjUbULvshqaJoKVQZaU934K0BHa0URGRWO2ValgOlagcjYLmBORdN/s5p8llmgC63QkhtfU30mAHZYMaHhrCiZsAJ7D0rvu9MNYSweWWEXxCOfZWcw13obQiv6nKKk0wFiz1WKbQ39gFNiLcBKVrsHgk5JA6On6UzIyRBGGrmBSC+n87d79uiOsN8/cIHDnZAUQ8+lgg2hVxGlEuN2t38PL08pj0ZCzM88T9AU9NjOPjOk6TbVj9Rf97R1qrSVcqXx6Tn5+n9lvrfAnPlDNr8yFX+al3zN+DbGwt53ureJ16wzvAUKtEYyqxndvthiBShM9ynri4u4m20lZDtAFjhYRpggo9wohWnzouVYO2w5ZxlsZHkarT5KT52N43HV2/kCuqnf2FMgIIuJtpDwu8tIrRV6/ClD3VewxeeNqL9ToIZ25OJxakP/+nF6NMjOOTmG++ea4zncKXioczJ21E8lTqw8IQKWaOnUP8CHhT1FFtOpa+tsBCJPO+ubgzq2tylgG3lfBSM36rQaCIp3QFVcrDoXv5TAPja6C/SfkwOpbo3cLwjB3uxVjfP3z
 3Ac2C01/
 4my8FHIKVkmGg0UuHLtfdwPNc6tARk/6aUYLJ8v65RKbrpX7k6j/buHyza/mYYMsGckkka3VH8NPjn4L7GxqYz9jZ3e7bDGprItTPr5e+2neWd9Q5AVLUz12nRl417eQa6gr3yuxfeYL+2C+wSHrIxVApPrWEQob4LbuCx+7e4mM/K+hwa2i+grzhFtX7aVSI47GZ9mb+kVYuQ9XbIAWuR5XCMmMBxCxxLZK5Ij+SNqWz1xc2KaCqCoFEESBy0y6j7X+l/+l6RkKIKggJ8JF5p4PqW1m/TSmYDyMujVErhjP3JfkpHRE5VrmbbR3PW22LkV/m6N3Br6VtKJVdL5nuTcZR/VT1aO7Vjz0pBlQJsWnuaIJgPv0DA12JcfoNi9OVsVEt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/17/25 18:33, Lorenzo Stoakes wrote:
> Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
> establishing a new VMA, or via merge) as implemented in __mmap_complete()
> and do_brk_flags().
> 
> However, when performing a merge of existing mappings such as when
> performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> 
> This is because currently we simply ignore VM_SOFTDIRTY for the purposes
> of merge, so one VMA may possess the flag and another not, and whichever
> happens to be the target VMA will be the one upon which the merge is
> performed which may or may not have VM_SOFTDIRTY set.
> 
> Now we have the concept of 'sticky' VMA flags, let's make VM_SOFTDIRTY one
> which solves this issue.
> 
> Additionally update VMA userland tests to propagate changes.
> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Seems it's been like that since 34228d473efe ("mm: ignore VM_SOFTDIRTY on
VMA merging") (unless it was in the meanwhile fixed and broken again) but as
was discussed, not urgent for stable.

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>


