Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E81DACA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:51:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5319F8E0001; Tue,  2 Sep 2025 09:51:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 509198E0014; Tue,  2 Sep 2025 09:51:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4250F8E0001; Tue,  2 Sep 2025 09:51:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3073F8E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:51:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C80BCB69F0
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:51:23 +0000 (UTC)
X-FDA: 83844447246.25.995871A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7D90D8000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:51:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yBQR5eJU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bmnpvxgS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yBQR5eJU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bmnpvxgS;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756821081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWPyMeLRCeeUU/ic9vKx2QzsYI+HcsZ44/cFsH+0f28=;
	b=M7f/3PUN/0WTaFUIHuVFu+E0u3WKIsZXAB+2BSiazaocGPCaz+DGoPCsWSz6yhO2okiOeO
	cAyeRwMVzlOCBcBWNanvxdiBdxwYao6rj+aoj7bJAWi8w0h5oov0N5D854v9xXJGWiTdzP
	AWhLS+VZz2Q94zLlJ+Cqt8aGwSPULns=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yBQR5eJU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bmnpvxgS;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yBQR5eJU;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=bmnpvxgS;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756821081; a=rsa-sha256;
	cv=none;
	b=Fuf2Beb4KEX6+FkkV9VlyT3Z0khgafiPkWbMqOcJAxJi16cuvGuaRm2uoHhuwaZJQij6DJ
	F4TC1mGhl93tYChc5FzLmpoO0z306DTjdRVWGAbwfHzNQyZvmgLI8vlJTmTUozvGWg75E3
	qQOOPAljFtjR+UvjGUiaTwuHmmd4Dt4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BC74D1F394;
	Tue,  2 Sep 2025 13:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756821079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nWPyMeLRCeeUU/ic9vKx2QzsYI+HcsZ44/cFsH+0f28=;
	b=yBQR5eJUM4FzX/RhlChs2e3Vpb8nMs9c1v+U6DRFZIVWgMXNJM92kWHTKMJKPrPhlTphmj
	1xaB7NqYxUgibEWlZpFIh8/2btfW3Bd5u4tWzXj4htB8ooyN17Ek3oe7k6L6e5kuHdc3kk
	fqtIWKL8hvcjvg6SbvifU16z8luA0ro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756821079;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nWPyMeLRCeeUU/ic9vKx2QzsYI+HcsZ44/cFsH+0f28=;
	b=bmnpvxgSVwL9IsylGLyS3chpndfSTu7ZlTeMk7OOFyAWjh16RYqAQfkqS+5WYCuqdVWHsl
	jL63DdCYKbJSioAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1756821079; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nWPyMeLRCeeUU/ic9vKx2QzsYI+HcsZ44/cFsH+0f28=;
	b=yBQR5eJUM4FzX/RhlChs2e3Vpb8nMs9c1v+U6DRFZIVWgMXNJM92kWHTKMJKPrPhlTphmj
	1xaB7NqYxUgibEWlZpFIh8/2btfW3Bd5u4tWzXj4htB8ooyN17Ek3oe7k6L6e5kuHdc3kk
	fqtIWKL8hvcjvg6SbvifU16z8luA0ro=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1756821079;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nWPyMeLRCeeUU/ic9vKx2QzsYI+HcsZ44/cFsH+0f28=;
	b=bmnpvxgSVwL9IsylGLyS3chpndfSTu7ZlTeMk7OOFyAWjh16RYqAQfkqS+5WYCuqdVWHsl
	jL63DdCYKbJSioAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 1FCB813882;
	Tue,  2 Sep 2025 13:51:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9/IOBFf2tmhlZAAAD6G6ig
	(envelope-from <osalvador@suse.de>); Tue, 02 Sep 2025 13:51:19 +0000
Date: Tue, 2 Sep 2025 15:51:13 +0200
From: Oscar Salvador <osalvador@suse.de>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Muchun Song <muchun.song@linux.dev>, sidhartha.kumar@oracle.com,
	jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
Subject: Re: [PATCH v2 0/9] mm: hugetlb: cleanup and allocate frozen hugetlb
 folio
Message-ID: <aLb2UUYspuy8oLHM@localhost.localdomain>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7D90D8000F
X-Stat-Signature: wcpnmk16og8aaebf8rb5esgdoudwbwhn
X-Rspam-User: 
X-HE-Tag: 1756821081-153253
X-HE-Meta: U2FsdGVkX18WiRqsZjykE1/b9pWtz6qbv9j3+mZnn4bXZq+mFgeUdY/ptbOTMfBn4pfqPpDkvFCTFSwBeEjhiEb/3W/IpprZqMaNI1ztnLArKdo185T8dIS+QDLuvmbTcXhfzE+34dy44H3PDVZUpug71a1pUGozKX6+5L9OGV6Gx+iyi5i3ZxFWExwWMr8/BG8yaJiXz8IzRDAQr0WsaCzOeugPVJIQr9BnKaFTnGgCmE/C2bx6YCHRRa5KfE6PucYXx1HgJU93BiXLBa87kXT/rZOOIgYTP7i5b37yNEI/tdg4plAEMUNprhe4NgG5aItdLBpg1sIvYjqGHF7/OYmPfnJylT+//Dua5xl744blgDj+JFG6J/7DSqBXIQoe60EULrwX67E15ajp1XvsZQloo4QzNgiJqRCKGcm6p4mtjGEoYWb8a2bA88UHpOIZS/52J3Z6Jd5gIXa1Blq5qazA652JWvjhKWbVZi7+UH+20f+CHwBSEeTN+la4y56Ww8IYW37lhl1vdbKX/ECrJnpz7AvdlgmZ8ifhzWdF1nlmXGAfKfsPSvGuSWnxM+WCPr7VjrYI0S2NUg+xwbttVHBuZF7hjX2anQ1i6zOXNbOR1xiwE1qbWamPuIL8MHPV4qv/Y20Y3gWXYL8n2h28c0BWbJ1Ij2x0IKykwlMLMpduiGOLVqB3FLH3f0aLjN7U9wme70jVLVakRBzbvMaGnRqlrUD3Rj65qaxZRkckW/AMmnC4a1yrmI0310uVJ/uBFz2GIIDwbnwhXXVnxg0f0MhTFXjjkkvHH4Lh3QnfORyhd3MxtE8AH5LxVSO0k3ZVjrQhnBOv5ukC3MZb1Ylc/UYUiji8pzF4hoxt1RWiBHrDApUq3L5fkud9zEckenuChl0wG2x0uyBwTkiA/VSPFn540u3byv9qNj5dRzBT4n8zFn8Q3tPbcn3IFd27ZV+GNfdJf+CmSvsvyqXMCBb
 deMvqOZY
 1XVjxEl6ax/9qZpy0HQe7ysprkIa+XeQuqHYCT6SbUpqrEdP6+XTTiBu8Y3ymmjT5TLfGRcqZu4YxGNJjIkhZcpMBfk6rgO4hctxJb276QK78y4gjAiy2fotz2m8n3bSkdQCdXi0qM1asOFG1Pu/aH2hwnYph006zfckUWos3SNI9OyE+eCfhdGUeQoKX2ct373hiqoaik8UjusnxH32XXfnwtDqywv0g+HWsuDfvbngSklZYZMsbREXK27L/qQUWmGi965mUMu3FNYhrTPGG7LMsSyZRQfSM1tHjdoyNg3c/K3uGgiLl3LGJJJoMFZAY1EJX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:48:11PM +0800, Kefeng Wang wrote:
> The first part is to cleanup some hugetlb folio allocation and the
> others convert to allocate frozen folio in gigantic folio, similar
> to alloc_buddy_hugetlb_folio(), avoid atomic operation about folio
> refcount.

I plan to look at this, but I will not be fully back from vacation till next
week, sorry!

 

-- 
Oscar Salvador
SUSE Labs

