Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C086ACCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 07:06:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 227008E0009; Mon, 20 Oct 2025 03:06:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D7FC8E0007; Mon, 20 Oct 2025 03:06:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C7188E0009; Mon, 20 Oct 2025 03:06:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EAFEF8E0007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:06:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A7A0D5B014
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:06:56 +0000 (UTC)
X-FDA: 84017610432.05.4E6C823
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C04AAC0011
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:06:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N7aMEBaN;
	spf=pass (imf22.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760944015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJybHeYE1ztYL9iPMAUStMessAVsBbSF1Nn5wdontMY=;
	b=moQM/qLplMxdxxQv79jMUkD9l2YO2Uf4eqPzOrxtrGKo3z5251wv3jafOPZvN9scsqom/D
	qbkK7uSmk+tcyeRlopYxonWZTejnbH/INwTAF+yXErOVEMsuGp1erPGdc4Q4aK/63dCasI
	ReygxTNoxAlEC35FO10+nEUVlrGpMC8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N7aMEBaN;
	spf=pass (imf22.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760944015; a=rsa-sha256;
	cv=none;
	b=s6s5CWR1rBMZtQBWQW3gSUXkF6bG0e6k/Nxo6VyI3BcsT1tSrSZp+/gmNOkDXZ9mE+sHEC
	g9qwPwQTIbjW4NJlcUC+a5/VpxDVBwMf1kOX/xGFC9GfX7Sstj0gwa4/bF0rVB9xYD4wbI
	E4HvEXcnGeONx0NlxSggBxEGhJyHP4o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1298436B6;
	Mon, 20 Oct 2025 07:06:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADAFC19421;
	Mon, 20 Oct 2025 07:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760944013;
	bh=kAdrSJwNBkfZ9vuaqIPPnTjBY/9PNf8m8VL7RRKS3sk=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=N7aMEBaNYZAUdtx97Nk6t48fjl0eFR71lZ68OlF1dPu1kPW0wCBRwej0RI6ETsqqv
	 nWr3dJUGIAt+aKaRJ7caDSTMp7z0IX8SSZi5xpqlM3JeTNh1PL4QWDyx4UiTgMdKTA
	 aDMC2Ja+g8OyUC4W/Wv7FXSPNtN5PwHh4y9410Zn4HUZuPDSpS1/pvG2a6TkNdiv68
	 H2o+BV+2UHGFTFXgd0nKFBYMMNfASPbLdcK29gbp94I3za9CT6wlViaH+wWcVgZ0es
	 Uxgj1wd2w0wcMdsvwTyOMRtCiqiUL8n+xZWVtveUq7x1fPv7gRuJIaLWjaOfMOU7hm
	 OSHRBEIxoJc+w==
Message-ID: <85707316-3f2b-4e29-b821-a32f9097244e@kernel.org>
Date: Mon, 20 Oct 2025 09:06:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
From: Jiri Slaby <jirislaby@kernel.org>
To: Matthew Wilcox <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, David Hildenbrand <david@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Julia Lawall <Julia.Lawall@inria.fr>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org>
 <3e798b9e-4915-404f-9197-ed3c32587141@kernel.org>
Content-Language: en-US
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <3e798b9e-4915-404f-9197-ed3c32587141@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1ijid9kso14tnit4hotcwfbt1srudywx
X-Rspamd-Queue-Id: C04AAC0011
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760944014-10254
X-HE-Meta: U2FsdGVkX18CYMV9FYa6cl61Ptom4aNtI/XjalnhrJQB1NcJyk5iMkFtxDMk0z8dhl5H694Ba6rtfepiGdU3zBqwC+c5sHYw6rjxbrtk7vS79n0HM0dDYA7JZMqLvJzu2m3H3kHqW3GRupJAw35np505VW8VDq+caECulFHWNAaSH+NG+27nchyuPHAZjM3T6AtL32hYCECzpuJS0Vf6P2hp+4G59mbTlYOWfNcGLSS38EuJGBRX2nA0zJghjY1iQ6HeLMAMezk+KDojzGk8q6l0GTfH+RI8+Nc8gIVXqzo7BJGvs49/RDf3rOfIwaNeoadlBRs5+wHhTD8NbBrLCqsSQy+P87lB+w2QjvLvhKKhIL6sJ7rmzTsonfDIeIGwBCPvib2dZsj6yUm1WLAbD2CZOibaqBrqYt2l5SQ6Dt1wBY39xMoGdBtGq8a6A2vpa9GG8k+YGOoglJThfMY1rfhLAkqlkWhxE+G7W+N70Aj7JnztMOgtG/sNzwAzcIXTQoFT4sJgaK+38uZ8Q17VNgUaga7bXGcwUk6zJ4QhbvMJDUVhbwVKg9aszdlIQ95whqSPLNXdfo5Rx3YstQDugSGo4wp8I2PvppGVcfDpFMt4R00VUyj4p9JjWcSE2wK65Z8P5wqF4hmqGAFOgxKIfaB/rMwiS9UczNX5cpEEh7FjsoKKHYRJsuNm4t5kaSq5akSiDJSlu+JkgoN2kc6qbeTB8VjQYTsLXfCOG9a5+R+6zTs+XJKZlM25ecKME/Z4H9Ra26dKhe6Wi2hAwffvL/VREMwZqPlkoB5pSDe4VZAmS8BqRWAvWU0GUDCuNitcbeGzPJ+TiFY3MF4NwhYK9s/fvMFIA3so8PFejMsoA1K/kcCBJzTEuR50WUtWDGpW4kDcVn2OhAYBmphn3D1/G+efH4Z0BsGzBvPUe5HA7fmemz/vJiSZrkoOkAgrHlRw+6B5NPty7fc2CY4wwUQ
 XNovRvL5
 igrNAjieqMo4caltYFXVMpTjQD7nJrcCJ6OvLXx43WpPpKnV59PJRPTWo3gCSsV7HUf/uJhosU1wnGl8OXdeHG+oJUDg+HHX2U2WZIF/8VTB9TM0nz13Tale+682OKrtt2GJxoj25gyNHmSrp/U4mmLAY9R1CgjEeLVT2v050Wpm6E5lsx8OIIrZoba84XCwTqFBXR00XqvtsrsNI8pfJnY1ey5i+ilYeoAzKEgRAy/SmgLDzQ6JkZQoVXfG+8dJ3h7/OwttM7Y/kphvFvL9E7YGlCZXTJMYvMIWGKe+dZc8XrfmESVNaE4mRH2upW/CrMj7Ygi79GQw29FZfhksI44s1KYJWy6txnwVvz8oEvqMwnoJwaLAAbyqZ5QQM/sxD/oICFXiEMGTFcMacKez5NMY9fcl1xbHU57eyB72JsIc6HMlP1mT82cExXA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20. 10. 25, 8:58, Jiri Slaby wrote:
> On 19. 10. 25, 2:30, Matthew Wilcox wrote:
>> On Sat, Oct 18, 2025 at 12:29:59PM +0300, Mike Rapoport wrote:
>>> Vast majority of allocations that use get_free_pages() and its 
>>> derivatives
>>> cast the returned unsigned long to a pointer and then cast it back to
>>> unsigned long when freeing the memory.
>>>
>>> These castings are useless and only obfuscate the code.
>>>
>>> Make get_free_pages() and friends return 'void *' and free_pages() 
>>> accept
>>> 'void *' as its address parameter.
>>
>> No.  Linus has rejected this change before.  I can't find it now, it was
>> a long time ago.  Most of them shouldn't be using get_free_pages() at
>> all, they should be using kmalloc().
> 
> I'd be interested in the refusal thread (what was the rejection exactly 
> about). In a need of whole pages, why would I want to alloc more for 
> metadata (using k*alloc)? Or what am I missing?

OK, AI yielded:
https://lkml.iu.edu/1512.2/03853.html
and an LWN summary:
https://lwn.net/Articles/669015/

> thanks,
-- 
js
suse labs


