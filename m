Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF0F4C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:02:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A51C76B00B6; Fri,  3 Jul 2026 05:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A02906B00B7; Fri,  3 Jul 2026 05:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9D26B00B8; Fri,  3 Jul 2026 05:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5DADA6B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:02:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C646C404A0
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:02:53 +0000 (UTC)
X-FDA: 84946875426.13.4CFD30A
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id CC4951A0008
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:02:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pJSxGIwi;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783069372;
	b=enhkylTlci5W7viBNxp3EMAVSlQ+xLzCJDZ0mVwOMHbkGXiESdfmYb+Xqdhv+5DKOE3m7z
	K3YyXDL7Y0o4OVDVD9pDMGruHd6JqusuARS+bm2b7BBE+WG+kmBSuLtZ4CRTKl31br2pTg
	lFNRyU2bEERcXD78wjuhy10oQLJULZo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783069372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzXLulUbBSbZLvJAq7z0tj7+rdC0gx8arHAJzkhxD9k=;
	b=0IUBdTCsH6PUk+vh8uYeYpBIHXXAX0kEQF7Pk7VXGyeQr0GaiguLLLda8u+/L3ZJwsabMW
	M4KgZNklc+31uBfgk51VEJjpejzCoxx7hyghSudwaXzp5hVRXxhdw2ZR1+vLhH1KcJGShX
	Bc+AklkSZdZTNKO9m3Hi2hK4Hg8Xw6s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pJSxGIwi;
	spf=pass (imf19.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783069369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LzXLulUbBSbZLvJAq7z0tj7+rdC0gx8arHAJzkhxD9k=;
	b=pJSxGIwiCViVhM7YfkOworfjBjsSN6hJ51Ojh+C07ZWE94Uigy7V2fl54i7o2f54b17f9n
	SGqOyOgHBjWFc29laKmIvkt1gCeQ6vVeZ57eAnm6JMmZllpxQgcWkH30BRjMWNi6pGFt8r
	cCL2HmJEDDTUmc3Ct0RnBM4vYIRPkOA=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: pfalcato@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	willy@infradead.org,
	song@kernel.org,
	ehagberg@janestreet.com,
	ziy@nvidia.com,
	gleventhal@janestreet.com
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when collapsing
Date: Fri,  3 Jul 2026 17:02:32 +0800
Message-Id: <20260703090232.26261-1-lance.yang@linux.dev>
In-Reply-To: <e924bed9-4c46-4fe3-b6cd-7c77fd9e25c8@kernel.org>
References: <e924bed9-4c46-4fe3-b6cd-7c77fd9e25c8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CC4951A0008
X-Stat-Signature: qtwak3u8hcprqrk3qozao5rfirqq5p18
X-HE-Tag: 1783069371-350143
X-HE-Meta: U2FsdGVkX1973K1ExbIR6zVPfByMxmtnCWbGM7+pKHJtpKihnHPdMWAu6OSyvOUWo2Mn4VXCFNh9QUbi5/WT07fEX3sOkLNg5n+Y85leaFDcHKgtd8RKcBv8CK6ABgcr6m4pzYZrlE06g8Hzo9W5RqVzTq/xSSuv+JSy3+wXpRwVxrOXYzgmN1iORRSZSL6IQYOv10gDkabvl2kvZBcgE6Ld/BEUfRj1NKLiIKMCHucc+wUFsedKDGl0EskUcM9ENf1OzxdgJgCSrCIaldfCYywjPW43WU9vcArosLTWlGB1xCEaZam71hxH1lGkpN1RXVgWhLGAyctiRdEMZi199GQRXllawETxGhmP2tHCMWs+7yjaDYnbY0SLuol6qT2Y+xxCth93njkhGjL2byBLm6B4mtHrVl3v0QU0Gmx7tjerZB0CQ0tyvR0f7xn03MPloTO6QI6pLCoXD/I+XQ/DDb5GkgSqCWBQTIXK+muBfr558TJN7wzS16hr2Nt7LQMhiKRzwBzesSG4dYztoIaSYOI+mK0+D1hrI28DzTMwGyJOxhs9/a/wNoHJa8zVbOk2PwfA9jtp3VcXPxkiNeLwOAnWyQwyHnL09I/D5RM7kzMXI1Y84HOApw/jg8BUi+V77Cwa9vxWqvGVKSC8noeT+zOV3suRvd23Ei9i/bT2GpBFw+aQw0zinbiEqeHsq2+dX7xWxhwoY6OvazxgTmUmRi+WTnZwnGKl/5i4RIgkPGqEqwrPdFFS6ch3KVN/AOBalAaiERoYmWRXATl6ucuBsaFjmKbI3iGVf6QNnuE0rjYmriO/oJa+c8QWnIL4CJWlvpzRWmHz8BDmwiF+nmKYPSg+OeG8G0xTgSUa82L9JNzXLjYoMLAbCU7pBacpedKFiiUj5HE5QNsmI+yRVIXcys93oVgXslRzucIX9pUxWR8xnxkkuHqWQ3I+01cSz1TUFYE3aM5fCqB2868QkBR
 LH5m9/8a
 LhIaafRUqIUKfuWIFdbR4h1F3OhMDa05od+O4Z54nP5IDRr+2jgTjoZkVMAVrPeL8yomwLZhcWbx0eWzsnTaDzcQRN69xRQfTz2lQwe7tK/OSvMAgxNulZBtWO+p3nAfaPD8FLYZil5GWHrlqdlnQuCow4esHax5fNbsQGpFJeV73zDr722EsnTtj5v3nCpnm88x+DSOya/4TSBdQekuf1EyoPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jul 03, 2026 at 10:55:42AM +0200, David Hildenbrand (Arm) wrote:
>On 7/2/26 18:54, Pedro Falcato wrote:
>> As-is, khugepaged and writable-file opening exclude each other. A file
>> cannot be open writeable and have THPs (because the filesystem is not aware
>> of them). khugepaged will never collapse file pages for files that are
>> opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
>> particular file is dropped. This is fine because nothing could've been
>> dirtied.
>> 
>> However, there is an edge-case: collapse_file() might not be able to
>> coexist with concurrent writers, but it can coexist with dirty folios
>> (from previous writers). Therefore, the following can happen:
>> 
>> open(file, O_RDWR)
>> write(file)
>> close(file)
>
>Okay, folios are dirty.
>
>> madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
>
>collapse_file() has
>
>	if (!is_shmem && (folio_test_dirty(folio) ||
>			  folio_test_writeback(folio))) {
>		...
>		result = SCAN_PAGE_DIRTY_OR_WRITEBACK;
>		goto out_unlock;
>	}
>
>Making us abort collapse.
>
>What am I missing?

Hmm ... dirty folios can be outside the range being collapsed ...

For example:

  write/dirty:      [6M, 8M)
  MADV_COLLAPSE:    [0M, 2M)

collapse_file() only checks the folios in the collapse range, so the
dirty/writeback check passes for [0M, 2M). But after that, for the old
READ_ONLY_THP_FOR_FS case, nr_thps gets bumped for the mapping.

Then a later writable open can hit ...

  filemap_nr_thps(mapping)
    -> truncate_inode_pages(mapping, 0)

and that drops page cache for the whole mapping, including the dirty
folios at [6M, 8M) ...

Cheers, Lance

