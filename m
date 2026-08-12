Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D73B1C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24D36B00E3; Wed, 12 Aug 2026 05:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD55B6B00E4; Wed, 12 Aug 2026 05:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4106B00E5; Wed, 12 Aug 2026 05:25:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 971706B00E3
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:25:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23118A0B9A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:25:57 +0000 (UTC)
X-FDA: 85092085554.28.52D3C79
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1AA6AC0007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:25:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Tt9x+QhR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FBOa9hNc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BM4NJrdN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LjGPtZZg;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786526755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uSXmi/X6VIXJSpaHbALVzu1i81Tq5CI7DGOYzCoOXrA=;
	b=bACInGT86Dsx2lkYE2+f4D5p1XTLVSFJ4IaRuokLhYXGPLRTYtQbbKqQ+PfN+4EUUExV3x
	kg2jRaUJKg3rnw0SQZEaGDeCnkKaIuVK5V9wdDmU8HPIRDEMLRnzXEwmfqi8fVsgY7tECN
	DzZVbFeOb9dIr/gIBvp5sC3Yngxt0nw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Tt9x+QhR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FBOa9hNc;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BM4NJrdN;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=LjGPtZZg;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786526755;
	b=avSzZ3DAbzJjoMdHZjEo2H1DIUyfIUe4ahToPk5HAVsDcBYhjS3mjia1CU04J/YET8Tif8
	tST0DEKnySS3tk6KUIghl/QYGg6bTpvzYk7BUSmYIIwdsAydANfrpzvFPRdn7FlUXY6bJF
	lFd/0rISWKQphKxgUzwCEZHiEFZ9u/U=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id B8F3E8217A;
	Wed, 12 Aug 2026 09:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786526749; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uSXmi/X6VIXJSpaHbALVzu1i81Tq5CI7DGOYzCoOXrA=;
	b=Tt9x+QhROvIfFwZjVNm9ekk8BGR0sR4WPttfxa+R0dgwUKVu3SXdOGD1edgOBiYpA3GXSG
	gRpmE+x66hknl9GP5SZls1v+fvmaIZkIZf5ddV9+pZDGBrb2K0g5fdAoTPdZl03WPD8+Cv
	QZ6kniSRQTlj092YdiQto2t/wy7uACU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786526749;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uSXmi/X6VIXJSpaHbALVzu1i81Tq5CI7DGOYzCoOXrA=;
	b=FBOa9hNcNO05tO0llJw/rXx5POcJsm8g5ND+Y9DhW4zschHYYlSnebPQKrOyOpioRTJtqh
	ecK/vmzNnLs4kZDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786526745; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uSXmi/X6VIXJSpaHbALVzu1i81Tq5CI7DGOYzCoOXrA=;
	b=BM4NJrdNfHX4WvnnG43VCgDgtRLNe2XTPPlP4FHYpduIFPUdrB/RJmKjZucd99D9CDMwdh
	aqFHOmQs/hwpwPlGt+X86wT/8Fz35E3zn52bd87BZR13FZAlJApOb+4jOYRUi3jU1p56a7
	7rrpdF1+v55q/XK5OQjbX9GPkR/CYt4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786526745;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=uSXmi/X6VIXJSpaHbALVzu1i81Tq5CI7DGOYzCoOXrA=;
	b=LjGPtZZgOFpnYYJORh6I+4YMMTIyvIOMF5q2EtN535M853tinYDAX2vMo5yfRD54XNIczs
	du1nCdTKDvvDFJDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 61A83779B1;
	Wed, 12 Aug 2026 09:25:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aolgEhg8fGpJeAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 12 Aug 2026 09:25:44 +0000
Date: Wed, 12 Aug 2026 10:25:42 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 2/7] mm/khugepaged: extract reference check into
 folio_pte_referenced() helper
Message-ID: <anw7_Y5zCoL3DhLf@pedro-suse>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-2-ddac39d61c4a@linux.dev>
X-Rspamd-Queue-Id: 1AA6AC0007
X-Stat-Signature: yp3swfnuwngtdf7hknzwn1n75o4dbc48
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786526754-591140
X-HE-Meta: U2FsdGVkX192DNH5YlsQxgc89NYv6jNuxez8rLdyevaRzfBUUP72mhhOBtJdmIvH50NvNKemYzBvkApNT/vxIzt/z+Z6NCegw5WZDnGMvPKEp549Mn8j1syG4xDGYaskdSnK7zRXMENxFWCb9/4iFsxJJ9WysuCHwKVMQdDSQFUfWxD0vZ7cFyt/1K/jhA02ATZVC9UUamATJMmqmNPpp63CLoWo0rmt3LYYUYOd/uLVZ26EGz/SDS++oIIvUXEzShP4fi2Lot3vNIVpmwANsrw033+l+ODd9YyJFFlzOhnoaDFqY03KcS8CF578Mk++OtsS4SDrUCxChm6gpZh71j63d763hm+bsvKp4j0VfZKkkZodoCSORNToc8Qd+H88Y1zpcZ1RYyEhgT3MRfY7o+BLIXhyID86FwK65rrhCILFty4O0+NmVrCdvqa7hZXxnRTis9XpnW3eTbdGsijfxAksOtefax+bOKLGnUadUDkIh8U8GVJRFvfLbD6VWQLnd8vpM018vnckpxnqOmpSXwALUspnLZL+8sqU/5VqYIboTkIltiNiARRbt55MYhmDq0ysDZvXDh/DBFPT9mfzKjwvyQdIvNW01CfLKbGavcTwpXI7RWZdNKzb2UQGDjBf2aLx/FmJmHbYgockDe+xO0Ma7ql3Dv4HEuqzKcM8jkz+GvNY6onQVL3rNSDVy3/GgasUAUZ49pwR+7bsEEwAgoZh9k60uRm9ZII34BSkYc+Pgp3m1kxxjlVFrkwwXtfCac9pRg2aHQAZ/sNHSkr03D0oJXx9fCDzueEZMgKpubGfvzrfYPvqkm6T0wdrt8TrAXUwlgAc8Sy85vWzUnGVX8BCQZkfbLv41xaQ/yO9Bg8iA87kD4oxFcRdLE1lxXdNOBnuG3jG4S4YPrxAzqaHK4I9Z/0a75VzlwFnWLRjzQ2HdWLZnZ3ranEA6OBR+x22mZU/Tci2yXe3MT/YiHV
 NK47Bmnv
 5vKV0G1UtKRtVrpe80SVoh5lAoaDO6JHb736okSA6uunSelJZFTXWlZe6KDfU0+EIqlG9l6swdUVic/PWgBCoUBWjTQ6YPzUD3yGv9SKIjDmfm0QxQ02fy69fsB2zMOUfzU4dxOE4/bHH5lwIqhA/N5UHtffzUQIbK0st6ATGPVuq/bFGcb/r7SLeGVSzcDMYRn2Uf29Qa6BrPSYkktEp5S7VQFctT/zhh1ZzXg4xvGOyJNImkqOAd9lSZ3gz1PONKAhpNmP3goXIUcvF8Rc37CITFLAlxRbO6XS512wEsZlLUWAcP4+4F8LUDujaeOTY+4E/wsLcxzf2rO3ZjphPHG05LmUYnmq7nOps
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:34AM -0600, Nico Pache (Red Hat) wrote:
> This change deduplicates the "is this PTE/folio referenced enough to be
> considered for a collapse" condition that was repeated in both
> __collapse_huge_page_isolate() and collapse_scan_pmd(), extracting it into
> a single inline helper function.
> 
> Also move the comment and use it as the function header. While we are at
> it, updated the comment to clarify that a young pte is a recently accessed
> one.
> 

Nice!

Reviewed-by: Pedro Falcato <pfalcato@suse.de>


-- 
Pedro

