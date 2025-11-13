Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D43FCD5BCE
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 11:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B91A88E0007; Thu, 13 Nov 2025 06:28:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42618E0002; Thu, 13 Nov 2025 06:28:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2878E0007; Thu, 13 Nov 2025 06:28:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 86A818E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 06:28:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 404D55B9D0
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:28:17 +0000 (UTC)
X-FDA: 84105360234.09.2027640
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0139440010
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 11:28:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CcWgcm7l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1Aa1hX44;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1eAivxcY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IuZwNtvu;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763033295; a=rsa-sha256;
	cv=none;
	b=0hAUv/jiBEF96OGfVZCIRvgXg0kTe42IalecwQ+2L7EyHxMR/dFVADpXw8bDsnSsv6VTYB
	rXqylf+0mUq2YUvqhku6CGNPiRgVs4PSmtOvx7sTnAYyI6QkiXxAGfvo89Bbc4q7HowA/O
	o5kxzi/OKOCg3n7SovjUDGI+4rFQob0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CcWgcm7l;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1Aa1hX44;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=1eAivxcY;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=IuZwNtvu;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763033295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+guB+4/sbzy+v6qvO1/wFlLMHRMHQDUcietxZJmXw18=;
	b=bfGr0q19MjZVJnwlP9elphGzVz/PRH7Co9JNC0PKROoiQjrsoCS5/I7WEQdAA3Kc2BBAsw
	llEK/8cEUujvN9Yq7xZWMXtcZmnt5PPyF4Z6NLwGgSBMcLoeBIZv5RqXod52SqFPPTymN/
	+8v242OO9VFXR+JfD1KsK4csybTHra0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4CFA71F388;
	Thu, 13 Nov 2025 11:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763033293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+guB+4/sbzy+v6qvO1/wFlLMHRMHQDUcietxZJmXw18=;
	b=CcWgcm7lYtpNs7mn73pBoa4nRC8JiQrK+gO212GsQjTat0FrQM1OCG4BRRt7yM3ghkreYC
	G98ydEB2YR7oK02EbnS/Ud96j243sM86TYmAaqc09XzlZNSAHZA+M47pi0z+3HrBDFwQtu
	y6P0XaEu3S2CdVlkODt/avi1tZ/VX8U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763033293;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+guB+4/sbzy+v6qvO1/wFlLMHRMHQDUcietxZJmXw18=;
	b=1Aa1hX44yVJ5tkE3C4qtHRTR+e71Hkl8ZeuTLjfs+C1gqSlvpuRdU+xGbS9xsg/kIuwkp+
	QbNYOZ6ce6ow/yCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1763033292; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+guB+4/sbzy+v6qvO1/wFlLMHRMHQDUcietxZJmXw18=;
	b=1eAivxcYZdOvsb13dmiwOsw03pon37+OH62VadJlazQwIP8FE4t2ULR0VDAEwS639Io/GH
	ya92J9EXRQ82sU09acZhfaFWGsAFWmcnvAVMLIOaeHDtfHNyM4X2p14LUAiYU9dYaUQYXA
	WIkExtJsRxhknS8bdpTt0OSSfliAhgE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1763033292;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+guB+4/sbzy+v6qvO1/wFlLMHRMHQDUcietxZJmXw18=;
	b=IuZwNtvu0oVqb9CEGDTa5frhvA7e2kRSAobrJWLWBoLuIJR3633WHQYXP17CvqA5OhIdt2
	WX/7eqWoDh2xiCBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3BB243EA61;
	Thu, 13 Nov 2025 11:28:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dThCDszAFWmtawAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 13 Nov 2025 11:28:12 +0000
Message-ID: <c5a8b713-70e2-4ed8-8573-27e818de0ef4@suse.cz>
Date: Thu, 13 Nov 2025 12:28:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 00/16] Prepare slab for memdescs
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org
References: <20251113000932.1589073-1-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251113000932.1589073-1-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0139440010
X-Stat-Signature: 18ty9wha91ib478eobik5e7azzfm3j8c
X-Rspam-User: 
X-HE-Tag: 1763033294-671248
X-HE-Meta: U2FsdGVkX1/aAPW8WrdZCMkMC7KkEyYjBklPyrfOZn01obYHwc4IXArrTcfjlVGVILSjlNIs8lxeGrqTfyj3APtmRUno6Rl3YWK0AXseBlRPatfuy4YHqtOj/2oH1J8plQMPT59GHqr+WPf8dipIm/wMYSuYAKUztZaJCSO9nUc+tefdlTxHog646G/1H8rSDDGXfgwCHXQp0sqXiF6QEZwK0tKZH0behVipH+7rG5vf26qismFtndW7zUn4goZn+4lBIpli8uos1VnhYrR/HcmMGOJwAnxb6/+OKmLB6pDJyddMXOQ7nlgAvWhaYj55ONhkf8rRyeTuNvpmTYCWFbCFD1UsjbzBoqaKuNvLKFxv7exto/NfNwG8rdLDBjtpwD6oAv6LzUUoLQ/N/FFX4aUE3Ky3aZgLZtAGoTsPdBYGVEs2KjReYvWxPIqyKmCLgUz9jKzfayl7AvDTYnH8xqMLk5TVT7S847n1wwxTizbIbVN/eHnYE6SDXBZSWLzh80PVijKMEYnDXKqs4Te9gFO7HvUt1XgoVnDmOHRO+tqG8NNMAbqInrGtl7YAC8EDHOow/DQ5dyJNJMnTDGziG43V0KWmzJ4QhF2rs8C+4DL0fOnM1390uzJcCactx3gjRlDoRYuMMDiMwMTtxVKslitdCU65XRm+YODImdwrc2ZpkRq6hxdMUmtpHvLYqgXjAaXcPyX+By7sndeBY0TrN2JE8HjUegRjYQW8Z0784FY+2XjxzS9ZQRXZnuwf+GsVr4opWqF00ZegVMjQmQIKxUqtIuYeuVyTZzEYnKoo6Ag3MDfiY7tGA9Kdk2DItHR2zsGYhryXyRzkf+FXNSLSDUYYYEABK7kfwQ5k8E6W92LHFh5kot5xQgpq8nGiAKbqIfo/vVCf1zsrl7XEAxv8iRJ0g+gs09yAeubfqqNhIYhDozd1FW5taQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/13/25 01:09, Matthew Wilcox (Oracle) wrote:
> When we separate struct folio, struct page and struct slab from each
> other, converting to folios then to slabs will be nonsense.  It made
> sense under the 'folio is just a head page' interpretation, but with
> full separation, page_folio() will return NULL for a page which belongs
> to a slab.
> 
> This patch series removes almost all mentions of folio from slab.
> There are a few folio_test_slab() invocations left around the tree that
> I haven't decided how to handle yet.  We're not yet quite at the point
> of separately allocating struct slab, but that's what I'll be working
> on next.
> 
> v4:
>  - Rebased on next-20251110 + a couple of fixes
>  - Fixed compilation warnings when CONFIG_MEMCG not set
>  - Picked up R-b tags from Harry (thanks!)
>  - Restored the order of slab vs large_kmalloc tests (Vlastimil)
>  - Removed setting of LargeKmalloc on tail pages (Vlastimil)
>  - Restored handling of non-slab, non-kmalloc checks in
>    check_heap_object() (me)

All LGTM now. Added to slab/for-next, thanks!

Vlastimil

> Matthew Wilcox (Oracle) (16):
>   slab: Reimplement page_slab()
>   slab: Remove folio references from __ksize()
>   slab: Remove folio references in memcg_slab_post_charge()
>   slab: Remove folio references in slab alloc/free
>   slab: Remove folio references from ___kmalloc_large_node()
>   slab: Remove folio references from free_large_kmalloc()
>   slab: Remove folio references from kvfree_rcu_cb()
>   slab: Remove folio references from kfree()
>   slab: Remove folio references from __do_krealloc()
>   slab: Remove folio references from build_detached_freelist()
>   slab: Remove folio references from kfree_rcu_sheaf()
>   slab: Remove folio references from kfree_nolock()
>   usercopy: Remove folio references from check_heap_object()
>   memcg: Convert mem_cgroup_from_obj_folio() to
>     mem_cgroup_from_obj_slab()
>   kasan: Remove references to folio in __kasan_mempool_poison_object()
>   slab: Remove references to folios from virt_to_slab()
> 
>  include/linux/page-flags.h |  16 +----
>  mm/kasan/common.c          |  12 ++--
>  mm/kfence/core.c           |  14 ++--
>  mm/memcontrol.c            |  36 ++++------
>  mm/slab.h                  |  58 ++++++++--------
>  mm/slab_common.c           |  29 ++++----
>  mm/slub.c                  | 137 +++++++++++++++++++------------------
>  mm/usercopy.c              |  24 ++++---
>  8 files changed, 153 insertions(+), 173 deletions(-)
> 


