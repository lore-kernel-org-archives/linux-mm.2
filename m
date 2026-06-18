Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5FFFCD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 11:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AE4D6B00D6; Thu, 18 Jun 2026 07:53:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0606C6B00D8; Thu, 18 Jun 2026 07:53:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67D76B00D9; Thu, 18 Jun 2026 07:53:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B33AB6B00D6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 07:53:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E844590FF2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:53:15 +0000 (UTC)
X-FDA: 84892872750.25.CD757D0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id D2C011C0002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 11:53:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tkJmfXIb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zLbFk2QT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tkJmfXIb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zLbFk2QT;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781783594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BEiRLGeKVxL1U6T0VrGb/zda4f8dnMRBfhdPPfgIhtk=;
	b=1UFJ8rHERNVQuVdrKfsaGC+Jizz7UIeNBN/AKnSUcRGahaJ8c8fmXCps0KkGI3NrLKf6Ys
	MAS6DCbV3SYFJCpM4isI8WHterA7bHcb44zwoaEFy6ijyklgv1UOjQGqJsJI3R2mr2V8vU
	3eBAKgy56cxc7QZqakpOZ49YaI9MfLQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tkJmfXIb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zLbFk2QT;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tkJmfXIb;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=zLbFk2QT;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781783594;
	b=l2rf2swY6fwTcWb/iRCa6ZVMCwHVaq1ehfBzy36eOK92Aq4YjqHTpiZPCcx/I/s4dnlnJQ
	/ETd0N+6ggKKlMWOgZmB7QVUCF2B3oIF56Posn95F7xEVjtKM9FpuBnnbq6+0h+uknhmWk
	XjtnIU823K2yqfPbQsx2lNkaBuZkSHw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 7655C75BF8;
	Thu, 18 Jun 2026 11:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781783592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BEiRLGeKVxL1U6T0VrGb/zda4f8dnMRBfhdPPfgIhtk=;
	b=tkJmfXIbXsqQStQZ/dyTCWfdzSPGf8VhqJGXdWA0aCschgAWaiSCHpi0Ocv1kjriwqbIWy
	qbQX7IEE/u+rw4OVV9O+Td0KhE7zYB/OxYSqH2/lxUzO0ICtlvlzaWyyvW0v5WmOw2CGqd
	WCBBeH0lJVt130rVEkZeP4dmt3ys+Xw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781783592;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BEiRLGeKVxL1U6T0VrGb/zda4f8dnMRBfhdPPfgIhtk=;
	b=zLbFk2QTZx2FJs+r8PhU4eKglF1NvJQH73d38bHRct2tTPw6UF4UxfEaCHFgBD9sAhQg/0
	nTFMF2HsE/DLMCCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1781783592; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BEiRLGeKVxL1U6T0VrGb/zda4f8dnMRBfhdPPfgIhtk=;
	b=tkJmfXIbXsqQStQZ/dyTCWfdzSPGf8VhqJGXdWA0aCschgAWaiSCHpi0Ocv1kjriwqbIWy
	qbQX7IEE/u+rw4OVV9O+Td0KhE7zYB/OxYSqH2/lxUzO0ICtlvlzaWyyvW0v5WmOw2CGqd
	WCBBeH0lJVt130rVEkZeP4dmt3ys+Xw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1781783592;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=BEiRLGeKVxL1U6T0VrGb/zda4f8dnMRBfhdPPfgIhtk=;
	b=zLbFk2QTZx2FJs+r8PhU4eKglF1NvJQH73d38bHRct2tTPw6UF4UxfEaCHFgBD9sAhQg/0
	nTFMF2HsE/DLMCCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D0340779A8;
	Thu, 18 Jun 2026 11:53:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Fn+VLyfcM2rpfQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 18 Jun 2026 11:53:11 +0000
Date: Thu, 18 Jun 2026 12:53:10 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 3/4] mm: mlock: use walk_page_range_vma() in
 mlock_vma_pages_range()
Message-ID: <ajPcEyORfPKVpaWI@pedro-suse>
References: <20260618092845.3905740-1-wangkefeng.wang@huawei.com>
 <20260618092845.3905740-4-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618092845.3905740-4-wangkefeng.wang@huawei.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: cmcdait6qyk4fdnnxtufsk8nszbecfhk
X-Rspamd-Queue-Id: D2C011C0002
X-HE-Tag: 1781783593-311675
X-HE-Meta: U2FsdGVkX18aVfILId3WtmTYui8AcouXXVlquGcKoAXLlVSsxylqrH4SEu5y/t9sEIk0CH/ESQUKPoJYugutA8x8hDOvgf7RdP3BmydeF79DZgjfD69x0NuX//J1+lBhoDef6QrBfoAPhderdsz239VHFwtv/e45bZMBuDsV7YEh7FmyusCvL/0NkaPwAzS5gCFsqeqqBWrbieLCwjCWEByl4S34IIApgM70NqKa6UYSw5dV1rJuWsfhOP3sYc5zFx3jEO0giuxLUWW2yPz98xAIz0KDqEhfAQr2vvB9aA/tAxY9yAGnpz+LWsxTMbKcYnWdGcn6al3gzYe5S3K7vev9rxjI8Q83V/PMfyUcr4DeYZ/KiGAZ9e3SQzBuNHlwYWPvBtdRo8XgOi+9acy7appUlwfnS14QVvonJtLfp6luvnnT6hnU/cFxLp73fxScxdedjmncBr8hDhzTzjrAqbVT3uFaML62zVVvYv/QIeJuL6YNybAp4pTbUgfBHEMbijXMGiM/CVMIohHvyD52uKhsWhYciglsECg58wvA70j3rZl4CaLJ2N8T9Xpt7j307jV/DdNs4RAHqmfGUX/RGA7AH6XIE0lHf4/y+3FclHp1lDc8x+BRkzwp2m7E7A0qmGxAJknDNxxkvSNsfdrSnPoXAeT2nhjJDKPdWqBoHMolDe4tX2libLo+aaTpt907Zw7qWJDd9Q1dUP2PIWCOZcnM+PZ8BrIBVicRqjOcgbbFRDMLFNfhfMMBpOyJHLV1IP9Pc5Q8aZ2pa4YyfdQ/BqmrvM0HaaVH1l0XFEJr8Zwd5bbXLKou3hMfuEhaWhLSj8soUHUtQOdFsEYGWbMV9C/sQxHA71m3eOXFmD9Ou1RKTHtkXEDknlShIe5jk3Vaoi4YIAvDGtojtVpIBL9xmALlUyVYasRwQWLy+Xm0ZaCG2d/ZkQHKICSI0MN9lisHp7KKGjI1jqiIEhtxhkD
 xSgRznz9
 U91eVoeKLe5MiJAg9ERBy6hU5tV1kuRN1M9orzi/PNp0s0G5mvJv1JOIe41qNckTTZlEuCqA9QiAToBAH+WlC7RtpKkuef1eh0QTzUbp0RFw7gV3oejPixfbIHtTlmCK+bXuFa53IXbGyB/IpaNkLJfQDkdfebHit48+ton+ZoAK43Ykyu0/nN73rZPPyKK11sv+JXWEMrt1zT7GCitqVImhtGDe9j7Epwpqfsiswvos2h0uIA88ScBRH3skAcCM4mOJiLoqJ8tYJEzlI2TyKKt9VX1T6umQs+Iys7/poZetNND4eAKsLw63YKzUsj+mO2uhzAHTXhnQmkPfsY651SdyBANNFR6zXSj5F/MzrqTwHwYWd3EFkm/bAUXTRj01Y53Hj3JDbCOh3mfGpeqFklHEl784NQjx3PrFz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 05:28:44PM +0800, Kefeng Wang wrote:
> The mlock_vma_pages_range() uses walk_page_range() to walk the
> page table. Fortunately, the caller always passes start/end that
> falls within a single VMA, apply_vma_lock_flags() iterates per-VMA,
> and apply_mlockall_flags() passes the whole VMA.
> 
> Since there is no .test_walk in mlock_walk_ops and VM_PFNMAP
> was filtered by vma_supports_mlock(), it's safe to replace
> walk_page_range() with walk_page_range_vma() to eliminate an
> unnecessary find_vma() lookup.
> 
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

