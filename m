Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E046FA0C47
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 08:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F026B0092; Wed, 15 Apr 2026 04:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25ED6B0093; Wed, 15 Apr 2026 04:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A62BD6B0098; Wed, 15 Apr 2026 04:03:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 997216B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 04:03:29 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3AD03E415F
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:03:29 +0000 (UTC)
X-FDA: 84660050538.01.B53E181
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id 08AED40012
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 08:03:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oKON00JV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SA8BaCQd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oKON00JV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SA8BaCQd;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776240207; a=rsa-sha256;
	cv=none;
	b=jZdepJsqzhukIOHaLt4ARQVqZsooBHbO+FNVuUW9sjHUYiOA2aZDi8z1MUtq90UraHx/4h
	FajT/NtM/zB21kGidf/9kvVTg8FIqKR1Iqc5vQwjw30Sds7QvTCWdL33YBlAXHWkyvg+yb
	k0AME8yTL6vu6wjc4+03xkcDA6sAH+I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oKON00JV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SA8BaCQd;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=oKON00JV;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SA8BaCQd;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776240207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HisAXEBH96eOi+Da34sQ2Z5rf72m88k4vWZJ1xIlaEI=;
	b=2trsuxH+JK3oVCmJs4nKaKvK4hcNL4abb8nkhyllo2DJuq8PHGCERKDppnZb8IdRCLMVbg
	F85zCPSNz7w08AyudSPtt4ykN1j4AownL67hOwpf6e5u3F1bOmhdQwV/+QSPT2B65I+6Ez
	Y/HMlT85LoPHIRkBca9NO4NPFjZ0Gww=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B7125BD08;
	Wed, 15 Apr 2026 08:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776240205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HisAXEBH96eOi+Da34sQ2Z5rf72m88k4vWZJ1xIlaEI=;
	b=oKON00JVDPRbEhZ4y6Fa1x2nACr/YwsVHI+8BihRDLAQuBUv+Joi1TPF+KZbVOndclBAP+
	URZUinY6rPC1TLR7QG1FTqUAgRZvAySaCRffGsPZ95yM+E22bMHA6KjV7HdZQzfnemu8SL
	t3lEczv4SFiqV3lWopaoK189k4Y4O54=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776240205;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HisAXEBH96eOi+Da34sQ2Z5rf72m88k4vWZJ1xIlaEI=;
	b=SA8BaCQdZE7LqXBQ14jo4vZ3n/DN8HDqKUejdjfq6xtuCoPFJQJxaJoNT9XlKA5vX4fp+D
	UXxV3KA/0J+fktDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776240205; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HisAXEBH96eOi+Da34sQ2Z5rf72m88k4vWZJ1xIlaEI=;
	b=oKON00JVDPRbEhZ4y6Fa1x2nACr/YwsVHI+8BihRDLAQuBUv+Joi1TPF+KZbVOndclBAP+
	URZUinY6rPC1TLR7QG1FTqUAgRZvAySaCRffGsPZ95yM+E22bMHA6KjV7HdZQzfnemu8SL
	t3lEczv4SFiqV3lWopaoK189k4Y4O54=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776240205;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HisAXEBH96eOi+Da34sQ2Z5rf72m88k4vWZJ1xIlaEI=;
	b=SA8BaCQdZE7LqXBQ14jo4vZ3n/DN8HDqKUejdjfq6xtuCoPFJQJxaJoNT9XlKA5vX4fp+D
	UXxV3KA/0J+fktDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AA06C4B8DC;
	Wed, 15 Apr 2026 08:03:24 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 10jUJkxG32lsIQAAD6G6ig
	(envelope-from <osalvador@suse.de>); Wed, 15 Apr 2026 08:03:24 +0000
Date: Wed, 15 Apr 2026 10:03:23 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Jane Chu <jane.chu@oracle.com>
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org,
	hughd@google.com, baolin.wang@linux.alibaba.com, peterx@redhat.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] hugetlb: normalize exported interfaces to use
 base-page indices
Message-ID: <ad9GS_hRv5hbLfl3@localhost.localdomain>
References: <20260409234158.837786-1-jane.chu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409234158.837786-1-jane.chu@oracle.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 08AED40012
X-Stat-Signature: nnnebrf7n76t5a7uuf6aqwkbgc6irr3w
X-HE-Tag: 1776240206-71653
X-HE-Meta: U2FsdGVkX1/yo8/kJpi7lJX04JFNtTwJlVRv/f6bNzw45xzY1KCGoDQbfph2RR3eK1dTburZglt1n6FtfX7nTXRpxzdoi/7HoCxEhymZYrT+RR+y59HZJZFzw3INWhnDjXcRR60SoFgHcJPyBNwFy3MX5Q/SSnjn4nGPVYuL+wY2mjD93x+Gp7VR3dnrwX1fZfAvdscSH67w9/JJ6RqDH16bYYGeUhGKVUsPKmqKrZeNmMVdHWUY0pBiqTnnawGjhJUaIKQaE7m+0yGFVYncZ4CwinEkPaDtTwvmsumzpKDHsE7YBDyVSZq5OjhHY6ZCTSvArId5IiMPeu6TpzHf8KxtTHWX4KWy17QYK7GTCJ0N473ieLjMa/oW8o3kNGhRVJNUWUpmgUh7k4tVu/Uiai8yJOni/IBulI4mD0Ftl5Lqr2ZCisVTdTUVz3AY1zsjcnWutnnZAlUW5CDly9+DB8DKFkGhjaUojaoUwdCfGM8mQaHoWls+dDFM9R9hviFlcFy9fC9m8clJiFK8aOYf6XVWB4PH5Hk07Q1HU2f4s8JcYbKCTIo7xPvLQXEBdXc13vK8xijAWsfkVGLDJW1FEh6MNhlWoYqFBSf96g0Y0OPqHkNaCRDB8iCpBBXRNwYnmW5Y5wUkOjMfqZsPrAoY2AcLqeQGXS97aTHZOeU8DgmWvDclbt6UIYWXNdnuxL1f8sd3/fZ2SnNmflu3JJF7NxG7a2Wj4LCorkhLH390v6BMogJ+Qmrqmpwhc3dUv7kHAuOlOX5hWyp6vE/0tTpfgPW9GuHkBBtiZAJlszkafZHh5106DhOKPWemD6KnStjV0Y0as08PDhAO6zADFWSEFizfNsCGHwmQhtprmHmEOWQ2gW3PV4YLXHvB2kkhTsViYptYQLyoFd15z0Z+YRyTAkUKsuB/eupu/UjZdBC83bzrQpualhg+p6gxYdwvV/iMrploiqeUf5yZll7vpCF
 iMiZpPBA
 E9UacvrvTjMpPwaqdSJwFcxR+PfXGwxRQs+UZRLRkqodT+OTtTW3PSrAcshgpnKJ5qW3iIr5pdwD53ioKxnOVxe0mjSjoJw1Ec2v9R6BALYNV+112gSceOmqcj6sa3oGTFYlCVj5wohsHBSe/xoBZGN3gbti/A6XFqolaOU19+KnoxXGm8F3E4Gw+YFhmcvAOfhJ/C0jnqsB3727OoXIph0WpaCiyaEd6w66gte6Vhlrq67SrZeAvJlMpGDiQZTcZWXYFm9581ahgSdUHwyw4Rk39Y366eL1hjuQ5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 05:41:51PM -0600, Jane Chu wrote:
> This series stems from a discussion with David. [1]
> The series makes a small cleanup to a few hugetlb interfaces used
> outside the subsystem by standardizing them on base-page indices.
> Hopefully this makes the interface semantics a bit more coherent with
> the rest of mm, while the internal hugetlb code continue to use hugepage
> indices where that remains the more natural fit.
> 
> It is based off mm-stable, 3/30/2026, b2c31180b9d6.
> 
> [1] https://lore.kernel.org/linux-mm/9ec9edd1-0f4c-4da2-ae78-0e7b251a9e25@kernel.org/

It seems you got some trailing spaces issues:

Applying: hugetlb: open-code hugetlb folio lookup index conversion
.git/rebase-apply/patch:64: trailing whitespace.
	pgoff_t index = start >> PAGE_SHIFT;

Applying: hugetlb: make hugetlb_fault_mutex_hash() take PAGE_SIZE index
.git/rebase-apply/patch:161: trailing whitespace.
	key[1] = index >> huge_page_order(hstate_inode(mapping->host));

Applying: hugetlb: drop vma_hugecache_offset() in favor of linear_page_index()
.git/rebase-apply/patch:44: trailing whitespace.
	start = linear_page_index(vma, vma->vm_start); 
.git/rebase-apply/patch:46: trailing whitespace.
	end = linear_page_index(vma, vma->vm_end);

Applying: hugetlb: pass hugetlb reservation ranges in base-page indices
.git/rebase-apply/patch:237: trailing whitespace.
		next_index = index + pages_per_huge_page(h)



-- 
Oscar Salvador
SUSE Labs

