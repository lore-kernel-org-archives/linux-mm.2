Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C66D0C821
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 10:24:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06516B0005; Tue, 13 Jan 2026 05:24:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE286B0089; Tue, 13 Jan 2026 05:24:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3D16B008A; Tue, 13 Jan 2026 05:24:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BB0056B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 05:24:35 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F5A056C5D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:24:35 +0000 (UTC)
X-FDA: 84326556510.08.DED8233
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 717E21C0009
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:24:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eIR8YX6U;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768299873;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PVSaJS016jpm0L0LuwgTRQyOBEyp1j00bVtkvYb5hrg=;
	b=AZUnJp4o9MPnvyae2GiFEYegd3hOIeC3aSC9qKBck3843obKWIh+4P5G2Jlk5S9N5oIoaD
	57a8km25ls1uViB1Twz39kqFSF4/TSum84nKs8n1+dKEl2+SNrZjl0jnKOH0heMLwtPLCC
	3x4ECg3gbZ+LYL6DwlIPxjiCg4W0kbI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eIR8YX6U;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768299873; a=rsa-sha256;
	cv=none;
	b=3R7LsRWG0TZGMfn0FsMDC+rHYgojgHe6QZv66xRzwU0q/74vLSmO0oo4hZ4a/v55qrCOBO
	9LkYwSod5GdEARC42YMb2BucMCoTbfuyTi93h3jDvw43yNbQ6aJPQhl7uYUcCAQGvCJo2D
	x3OtgqRKYAnXZ0rmLaAg1lYof2k2l14=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 82CAC4345C;
	Tue, 13 Jan 2026 10:24:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3953BC116C6;
	Tue, 13 Jan 2026 10:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768299872;
	bh=lp5DxS+Pi7wl7PFR07vL24CgIil/9+7y9jleMQ7K18o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eIR8YX6Uyj+2NRYDekiCMRzkhDmRrc2VZTkMvTXk5TdZSzJoIdcnUhTDvx/aFdH8y
	 UosN5aVE9GXo7glCBozLXqaBtoYKjUsk4nE+Xiri9ZTtbzjAh/14Rwnxca5tG2nHU5
	 H/0vip8iFAABH2/cw4oNa58t6pxYtot26dbvQdPVS3ByrjDk9r8hUR8fJnhr8OZXnF
	 UxpX7UGdwAB15CPmspS81j3QGP4dg+cQppPchuKWohGRPkd2QixQ3cmW90QyYrtsnK
	 xuS1reJSsqwYG65d6xB1MIKEc03soU+EJvmkQbgLVnGtfcTeO30Jbr0y6Ua5XcLoUB
	 LXE5+5uU2W7ZQ==
Message-ID: <51fe7876-c24b-48b9-a038-6cd850ebe512@kernel.org>
Date: Tue, 13 Jan 2026 11:24:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 02/14] mm/sparse: Check memmap alignment
To: Matthew Wilcox <willy@infradead.org>
Cc: Kiryl Shutsemau <kas@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>
References: <3b758468-9985-49b8-948a-e5837decf52d@kernel.org>
 <CDAEC896-E3EB-4EAB-9F0F-70BC448B3B9A@linux.dev>
 <4f82b8ef-77de-422b-a9a5-691c4eca24a3@kernel.org>
 <glu3noshgeh7ktwwqofk7xcwkvhek2x3hrbdmyyo56gmctdx3t@adsfih557p7g>
 <2ace6fc2-6891-4d6c-98de-c027da03d516@kernel.org>
 <aWF3xg-72SV4tmLk@casper.infradead.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aWF3xg-72SV4tmLk@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: es6j9qsx8jai84x5wfc8ki8eq7owqq69
X-Rspam-User: 
X-Rspamd-Queue-Id: 717E21C0009
X-Rspamd-Server: rspam08
X-HE-Tag: 1768299873-996644
X-HE-Meta: U2FsdGVkX1+HQQVh1OwlDCCoSkDqnITpe+xXAWWFnkhmiwVdkdQv3l2DtuJRJT7h3CXU9tvUw3flveB4OuON01JsaJcik4zz4u+4WdxenBp+EPlgX5LGLgwnoXuZf6qsTOvO3kJfakofjIx/XQdhcgz+h7L6VmIweEjku7aKqrg2PihNZj6h5I48l9jYrUsuoxCwBCZEyzb42fMSZwQ0Wljre8JjiE2CB4kYavoZXPfG+tE3sLexCEF36rBYUri4VSrXEMV8nRXnwhf6IgFdvySdnlWy2hRawrEvW//plkT9DMKKM1Wg52gdBNY9oS0YPWTrsE4qrPMPVueGw/hBG6xmy/2+hh1Ch/5yN/Hg3A9ug8uJ2ILR77T0fzEcoFsfMUJIGIYOPm6TYGz48n4TEI1p+OUsr1T0/LytJ3/6TLrE28krOrcT7MJcOcsT0i7+qN/tETVc8Cc3BxrNirsaFM5WHxnPc+dPko3dqu/1B5wMyPydf1e98IWFnrm/49cOfmaIMVvaLfl058mPl8/vHlxiIYUfbY+17q8Vc1DPbE5Q04jGjJg8wNflk5sBchnB+NTiNaTecXdI00TU9VT9IGh5unIwmSlPq5O0cKpbG7odAWiuEV9RERJSRpm27MyWLYdS7eZ3rvB/i6HLKcRiP0rALjkrgoNJwEX21sxOWqCNzQheXMhFhnXyrBarw8sH52Iubggu5P7YK1RVWQCSQjSmZdmQM21Mp273AVne1K/qAGeVdPzssh3nBQrazGJxbl6kP0TxNtcIWlVZDwfTIW6Hih4w2Woiz6EmaQYkvv9rE56sz3+zcT0S79DITBvA49Vz87Do+1Jjbemeo9IScP+K0P6uJ31I44W1KrlZ6wyl5LrnpePc8jC+KOa6dDtCV3Ked8NBIN36qrTvHUzi5SrRFztQxg5Z9cxB6/84mEzckUoVsNCh5TSGe7vgy42+0sS/BXvqxZ5fzdRFugJ
 060fBW4c
 c7KreRxlEzx74XgIYc4n0cPukIFyWsiLJtYVfk9fiv9roob4WkF2OGoqdz8mwdQwYp4elUJ/poTRTxieXo30Pzt2yn8mGQKPo+pmi/F1IbcN5v0X0WsRdbzEknpjIxSI8e+Dupyw45pD+zlicI9Xl6GA7anLhAIiY+rll/7I74fwW5lasY1I+Co9NATaAmDyfjW8X18DTspt4Xwui0uw/OY5rHX2VXFfZsYuW77xrzIeXYkaBihDIJGuqZsfOM3pPp8D/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> When the program was called "2025" I considered it very ambitious :) Now I
>> consider it ambitious. I think Willy already shared early versions of the
>> "struct slab" split and the "struct ptdesc" split recently on the list.
> 
> ptdesc, yes.  Slab is still in progress.

Ah, I could have sworn you sent something out, but maybe these were 
preparations only. :)

> 
>> For quite some time there will be a magical config option that will switch
>> between both layouts. I'd assume that things will get more complicated if we
>> suddenly have a "compound_head/folio" pointer and a "compound_info" pointer
>> at the same time.
> 
> What I'm hoping to get to is a point where calling compound_head() on
> a page which is part of a folio is a BUG.  You should only be calling
> page_folio() on a page which is part of a folio -- because there's nothing
> useful to find in the head page.  So compound_head (or compound_info) can
> share space with page->memdesc.  For now I've actually put page->memdesc
> adjacent to page->compound_head, for no reason that I can recall.
> 
> I had thought that calling page_folio() on a page that's not part of
> a folio would also be a BUG(), but now I think it's better to quietly
> return NULL.  That's based on my experience working with slab and ptdesc.

So once that is in, even if we only allocate "struct folio" separately, 
the whole fake-head stuff can go away either way, as it is 
hugetlb->folio material only.

Which leaves the question whether we should consider Kiryl's patch set 
in the meantime here as something to merge.

Willy, what is the rough timeline until we can expect to see at least 
"struct folio" get allocated separately, and would this patch set here 
get in the way of doing so, or doesn't it really matter?

-- 
Cheers

David

