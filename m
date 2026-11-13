Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA5E606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 09:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Bfqf14KD
Received: by kanga.kvack.org (Postfix)
	id 46D926B064E; Fri, 13 Nov 2026 04:52:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43EED6B0653; Fri, 13 Nov 2026 04:52:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37C236B0654; Fri, 13 Nov 2026 04:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 183846B064E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:52:01 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F0B8C03B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:52:00 +0000 (UTC)
X-FDA: 85429629600.04.5686352
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id F1924120005
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:51:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bfqf14KD;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794563519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f4FQDKbejT3J1n5vJtGKFu4K5+PWNmUP6Rk+a9iJRqo=;
	b=ojTVxCt6c7u4h/6ElepulJZYi/wfxau6Z15rRxnbbz6JpFmrwnOKyIjJMvg81GR/pslh7Y
	x+xBmBFCyz0s4Do5Fm0PI9AH+wb+r7DnaQdrdNGK0a2q0P34qlPauCr/PAMyVCOMiKmYdW
	RTV0dBN9zX8Yj7cBV8gglCyJ4z7Ctiw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794563519;
	b=0El8bbLY6TWWNGULjuiHtYmDz5c7kkD3eT4l6W1uF34czzpr5yxTEEc8wX34Xe16d192X4
	yz9WDLE/QSBE3tFN8DD5I11huCrynX3ALI1nqhk24H91vs9KkJsV/L4ZHLb++3t2jsyFrR
	48eh9cmuFDsU/pVKOBSLXrTSxly1JhY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Bfqf14KD;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 817BE625E7;
	Fri, 13 Nov 2026 09:51:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796FB1F000C4;
	Fri, 13 Nov 2026 09:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794563518;
	bh=f4FQDKbejT3J1n5vJtGKFu4K5+PWNmUP6Rk+a9iJRqo=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Bfqf14KD2OgZDu86Z/9aV8o4CIRH0r8OahYXT0TKwNcziKzrzdOLXoTAuoYlVGbx7
	 pfgaSnNXw4J4gKWSz3NfG4AmnVizFOTOUtX5VUBwyPSnwRVd/IxOIkD3QNFOAvr7DO
	 7i+U4rAXiFfeOsXzW6MCVh6mgiRN8nJEJ2PIk0O4d18zjcuQ78R6WDZfvLVksXSBuv
	 P25IM8Gp4K5zOe50DJEWq5UCxBUWkQZKXb4fCZPvguf372n9zDOO6cVxeqEuYBMZ4N
	 IeRF1SkqeYixgTjc83/xHzbtEqEG2ETWEZ5zheXeg6drve1ZzHS5E8eQgVHHhu7mbz
	 A8Y0NGmPcugDg==
From: David Hildenbrand <david@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Pedro Falcato <pfalcato@suse.de>, 
 Lorenzo Stoakes <ljs@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, 
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com
In-Reply-To: <20261111182445.656620-1-kas@kernel.org>
References: <20261111182445.656620-1-kas@kernel.org>
Subject: Re: [PATCH v3] mm/memory: refuse to map page cache folios that are
 not uptodate
Message-Id: <179456351421.3136.15619726484550572099.b4-ty@b4>
Date: Fri, 13 Nov 2026 10:51:54 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam06
X-Stat-Signature: yro1yyjbwgywwqmuw6hezhqfyxjdm5z1
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F1924120005
X-Rspam-User: 
X-HE-Tag: 1794563518-390516
X-HE-Meta: U2FsdGVkX1+wezVakFEiMVESjC9FJeuEOPd/hELfcpHugYXMqAJKTbTwlfuULEfpUOtHA7dILaHJIzuymEmJGSByyeltaM+aVaRgLgOazZDCRtwqhC61aRBiFP11uKk3ct8L+IvRqwwr+13qyNg5yg2IR8vVjTncVg35dqstEFbf/DfSSPAD0+4ETNyjl8zQELUVg1WdUBlsfyakOXyr+uA0nWVzPYL/6ktVXtNrbL9+MvbO/Cm4C9rPMbpFu9zF7sKRi6H2ohoJ0tk5HVohuvKkqYzZnkH/Qm920/5zupbd3ziFs25Euw0wUYe6ocsc7Ux8B7wxWUWov0lcPbw2zcPbmuRlHNMOJaMOPote3y7aGYL+WuPWBg0S+8/DLDWIlmMUsmbe21WDKNar16Bc7bxbctzdYwtuTu8jPZ2FsDuKe2OWcUuU8mK0iYDtKCqorjkZa/ipOd262I2ntzbDqm8opu7nQG3AmDMn2rQhxOTRdusi8fIMkTutcJS/sJQmE4w0UGho0c58Ba/g1V8TVjEN3NdXQzyd2P387A3enQheyOQ5XaczIIxmC5Phimgyxq2cAxM1gXktMylMQLsyKZWYaHm1c9k13WoOBFK0wHYoc92VBwwyHrEpzrTJaz6/KGIUTFg9p5IQCvAysHLNhaICDo+6dThluq6cD0q/a2GoBjjfTdfMKMb1I01NrjraqAAmeHya+xM+c48T7+w5/19aFnSX2X7KBvVNUSFhf0pAN5TzfMhnDXOH3UY8ZaUUpJ6WsYm+3IRo8RvmcgI5pzTtva1/2ZrbpNZW+ArK8Cb5f5McMzdgHxKmFy6triMKjIKE9mf28paPUaIkRg94AIcckxujbVinX5p5ACf6vqbtamH9hZpdUmtvd0nvx3DdY8u3PTVi2VyU5YjinhDSkG0Rm82Q5vf5UkjO+vlOy+Gp4ctQ3vR41Oy+ECEcirwh90L11caBD514TWe7Acc
 taLNQxeR
 dbBMugIXvbsMjE4u8xS5jxKwqJkCwdhJlT2l3L9OViK1r3LhhGcKglxFa2CG5iIk2SLvsSTowfvqwF0S6Hx9RinvVsVb5bgHtCOyGd86SVUs4ZKrqCSgYFJC0w+emWOcWKfFCRwA2wEEPfQGUoYtg29GZTg8IluhZYKhW6pHbzQ+wt/yVN/c8ME+W8ciQ2h/kVTP9RLftMRSbRCmP7NgwcC3hHYD90Vek0vMCReblDG/qgzwaIPmtA/ULXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 11 Nov 2026 18:24:43 +0000, Kiryl Shutsemau (Meta) wrote:
> A page cache folio that is not uptodate holds data that was never read
> in or cleared. shmem fallocate(2), for one, adds such folios and clears
> them only on first use. Mapping one hands userspace whatever the memory
> held before.
> 
> Each path that maps page cache checks for this itself: fault-around in
> next_uptodate_folio(), a fault in filemap_fault() or shmem_get_folio().
> Nothing in the mapping code does, so a caller that misses the check
> leaks stale memory silently. MADV_COLLAPSE did exactly that with
> fallocated shmem THPs until recently.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/memory: refuse to map page cache folios that are not uptodate
      https://git.kernel.org/mm/core/c/2b2a2b86

-- 
Cheers,

David


