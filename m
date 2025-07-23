Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E52FC83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:07:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0B2B6B008A; Wed, 23 Jul 2025 06:07:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE29B6B0093; Wed, 23 Jul 2025 06:07:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD2356B0096; Wed, 23 Jul 2025 06:07:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA256B008A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:07:43 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 59F64140650
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:07:43 +0000 (UTC)
X-FDA: 83695102806.15.01D91E6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf22.hostedemail.com (Postfix) with ESMTP id F0FB3C000F
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:07:40 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JwBZ4+Im;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LbCg72M+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JwBZ4+Im;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LbCg72M+;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753265261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gQCVMvvSDoDcWIMNBblxkeQLPATAiVq/0CnsoGRiB7o=;
	b=GYfdZQjShoyC9cT6Sm9TCrfJ7VZYJSRhhG+3bshP/VXHrzcPnOlXq5z8RRR7hzm84NBQbM
	RkD2llQPO2hJt4Q9asPH9d1VwEmETrUAswSuVhjKCboLxB8qsbqfkqMfmP7WZj4Sz8NCB2
	g6iYqIZaF9ITBcHwDEsN9ZF8PL2clP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753265261; a=rsa-sha256;
	cv=none;
	b=P+pwMvHYMWOzvNk744BXCN1THSL0rcwDCKBc0hxmabk26jGSGrtj0IfOr6gndvpTUrNgNX
	9nECxD4iBbMicbx1RY6LWidlG/8TNh6X9Xgsofi48ngg6ncprFKXXifTAYwjW/f7vme/1g
	mS+6Th/atRcIuaH9kdNWa82gOUbmZd4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JwBZ4+Im;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LbCg72M+;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=JwBZ4+Im;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=LbCg72M+;
	spf=pass (imf22.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 72501218A8;
	Wed, 23 Jul 2025 10:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753265259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gQCVMvvSDoDcWIMNBblxkeQLPATAiVq/0CnsoGRiB7o=;
	b=JwBZ4+Imqe7jGrfwcvwuC7256tkcqI91Y9Vn+m8J6toIcmPdtQRSAlEEjlZH31rDROgpX2
	4r8SXQrEScLppuBkhbtIsX8qzz625rLLxpMOlZTkVa+U6dgMc5Mn9ygwsn1w4KmwBN/6a5
	5J4g0PLnwL8s52jyNr6B0KvZk569aM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753265259;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gQCVMvvSDoDcWIMNBblxkeQLPATAiVq/0CnsoGRiB7o=;
	b=LbCg72M+OONtS1WPN0NLDOswOTU4yDSx1zovYHpYPMuYVyMLFMpWiykrrtyG7DLEIV6Lww
	hbrnTAGcf4dkIqCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1753265259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gQCVMvvSDoDcWIMNBblxkeQLPATAiVq/0CnsoGRiB7o=;
	b=JwBZ4+Imqe7jGrfwcvwuC7256tkcqI91Y9Vn+m8J6toIcmPdtQRSAlEEjlZH31rDROgpX2
	4r8SXQrEScLppuBkhbtIsX8qzz625rLLxpMOlZTkVa+U6dgMc5Mn9ygwsn1w4KmwBN/6a5
	5J4g0PLnwL8s52jyNr6B0KvZk569aM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1753265259;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=gQCVMvvSDoDcWIMNBblxkeQLPATAiVq/0CnsoGRiB7o=;
	b=LbCg72M+OONtS1WPN0NLDOswOTU4yDSx1zovYHpYPMuYVyMLFMpWiykrrtyG7DLEIV6Lww
	hbrnTAGcf4dkIqCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5395413ABE;
	Wed, 23 Jul 2025 10:07:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7/LJE2u0gGiUYgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 23 Jul 2025 10:07:39 +0000
Message-ID: <a3f60194-3498-4dce-b0f0-e16e706f66ee@suse.cz>
Date: Wed, 23 Jul 2025 12:07:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] MAINTAINERS: add missing files to slab section
Content-Language: en-US
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
References: <20250722175901.152272-1-lorenzo.stoakes@oracle.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250722175901.152272-1-lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F0FB3C000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: re4xa8pdmodjentezki3mogyrbi3bwc7
X-HE-Tag: 1753265260-886134
X-HE-Meta: U2FsdGVkX19ryZ1MfsDsffCPlNSKVo/moYLUVUe4uBsZFdSYQCuEOhrP90v9h86jO2GrAPi04j907JK8nIJIY7DUPMOjSEhKNv3jrTt84+J6g/IXEW99gtARzIjuVn334BGWlkrso0e0mk7ttiZweT4povVQShRbUm2P1wz+MUc2wyAIIN5TMlfPUfRFPZMM8G3sNbLOVNbdJRq2ucB4cyHywwWQ5d993TAFuLZa310PKLBkZxb7qQn+ilM8lgMSEUMnzL2DHHs0D0T2RZ7gZMrsr3nnv9Q+nCVsn7dbENU9ZoW0jWhgWdIiJJIKQzLfeH1Y6aK6JD4IwC+JnkdkQUw03diB9z7TadFxyI3RR7XpnU7qLgmas5/RTCAVuIlzpSMzqeMuRC/nc6RgQ87BNVSfkdP7wvALeMLAQ/2jcNTi/jEfImpzx/IqRl5PSlp+RmU4x9beZKKkH/EmfFKnaS2uLfEi1v5KecxjWhEL7c9oZuqzlx5l45FivH35ngW8K4Fz70CdoOArmafHnGlYO5AQJyWQx1lVbOU1mEdKR3h69nAdlAAZ9U3RO8QeY5jTywcKpK5AwdON0PlvDxguuxRxl8hXeTjsaHovvsLMtG9th2zGz+ktFwk++nC0aXzTOhVEwf4ZaKs5HI36qbGI9vvueR0BFrciDO7scry4kjdDe0x2a0vzPh+l+lZaU2CeX3HJflgIbsKj/grg96dU2H2enryLfSUNzfif71PbB/tbJ2vjUC+04IebINWH9HodQAFiif5KRWusBy8pnIunlAoO7POiC/sR+h/DVJvlr2EVbTz4Awgo8mOYfpGDeOTRlHNVRTAfqFJuudz+nouv7jVAgVSX5WewW+xECATujFyga1hhn0YDMvKWw3TCBRHNVoYc+4nbigl9l0RxJ6zPLm765Jnt6fNrRqWxuFJzWHUyNBZxVKSZAKHwPE+NUl8rWm3WkbjbKXTA+P8Wr7q
 oTAHI9YU
 T5hsLITg0EGB3TSPCHlzjY0XfANxykxR5qnYveLFHbwneD4obesv9sQC1UdRd+E0doDpIIlC47RIExbENQ2BHKHtE7nU737MRPCOAsxEs0/qqvpKbmxEI27qemKFLRADnJkDgK7pAuGqR0Vm0OhP33NPX8wtPj50AGKFdLT+ceQjn2t0fmVKQjsPbzy9f+Bo5V2m0OPX+nJ1R69H350N8oIofDOSoIbDWl1m035t5JhSsf265lbN8xJC+dU2rxiza8gvHBidIcBd6ZJFO58UBc8cu9Uoag+dUzpqaQdacBxsGh4m3VaWh+drtnni00CNZ0rz6+VwXCOjf7UM156h950DxnNUiAOklJMg5FlJkWXtysnS18t1D5zLuKQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/25 19:59, Lorenzo Stoakes wrote:
> The failslab implementation implements fault injection for slab allocations
> so seems best suited to the slab section.
> 
> The mempool implementation uses slab in the backend, so that seems best
> suited here also.

It has other backends too but perhaps slab is the most complex and David was
involved so seems acceptable.

> 
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---
> NOTE:
> 
> To try to reduce conflicts with the latest batch of MAINTAINERS changes, I
> think this is best merged through the slab tree.
> 
>  MAINTAINERS | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e55accbef..2d5c844ab 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15738,7 +15738,6 @@ F:	include/linux/memfd.h
>  F:	include/linux/memory_hotplug.h
>  F:	include/linux/memory-tiers.h
>  F:	include/linux/mempolicy.h
> -F:	include/linux/mempool.h
>  F:	include/linux/memremap.h
>  F:	include/linux/mmzone.h
>  F:	include/linux/mmu_notifier.h

I'll leave out this hunk as your other patch moves the header entry from MM
to MM-MISC (maybe it could be removing it there while at it?).

> @@ -22831,7 +22830,10 @@ S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
>  F:	Documentation/admin-guide/mm/slab.rst
>  F:	Documentation/mm/slab.rst
> +F:	include/linux/mempool.h
>  F:	include/linux/slab.h
> +F:	mm/failslab.c
> +F:	mm/mempool.c
>  F:	mm/slab.h
>  F:	mm/slab_common.c
>  F:	mm/slub.c
> --
> 2.50.1


