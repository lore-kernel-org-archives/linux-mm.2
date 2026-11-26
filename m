Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B01606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJDPIgoI
Received: by kanga.kvack.org (Postfix)
	id 3B4706B05B9; Thu, 26 Nov 2026 09:24:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38B546B05BA; Thu, 26 Nov 2026 09:24:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8406B05BB; Thu, 26 Nov 2026 09:24:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DEF66B05B9
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:24:08 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A91E402FA
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:24:07 +0000 (UTC)
X-FDA: 85477489734.04.121C115
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0CD5940002
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:24:05 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJDPIgoI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795703046;
	b=d/7oEVl9keLRkKcpDHBb9twChGR3qdNZoXzQCzzNiv9/l48o6bVJhBFOH7zuwFcMDxvL7X
	z4FwCW0N6kJRGDR2oz1CwoAlZ8hTRnpXQBEAnOw+gY/WTXXZFdkq3E0kZPwubICztGwEg2
	ksdV4HeAKql9NLW53UZDAnnTy+M9Moc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795703046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGDviZu4wWbCw/94ZJVbbOlqdCrfKBOx/sMrkNJCHBs=;
	b=cZpGHPKYR0znbir7ZkJLurH1c3ZGrSu4WWQi1RNOR9NF6VflL9AQrmL89Q5MGzvOUjnMov
	39K1hV8FGF658W95WYrP8d56dc18sZIGbdGZiNyByYhM6OSy7rX337SHB34omebYbKKzYl
	jbOpdlr+IeFVT+6WReyYWVS9UvvhAco=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dJDPIgoI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3916A4448B;
	Thu, 26 Nov 2026 14:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AA41F000CA;
	Thu, 26 Nov 2026 14:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795703045;
	bh=nGDviZu4wWbCw/94ZJVbbOlqdCrfKBOx/sMrkNJCHBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dJDPIgoIEY6adsxiBKLj31BpxdocV45Ho0ZXndsXTByUCNQSeqJbisV76kX96NGTm
	 lP8PTWZkBAGAaf4ROQhL4YqNqDUlIg+OsBLvEgyfgtkWB+XlbUoT0R/bzjR59GoZSP
	 N5+A4KpckrQdwruGKB/c/3DFMnTOqERUzcvPzJZpY/g4Kdxp2gDzUy1JYrmyX8XKYP
	 TXxxUruqjjJGGyB011S20azsLDh52IjKOk0t101eKEo/U3oNrczd8Vk1ozeO6EL1DP
	 x3OTUL1cheR2+0oIxHePd2pDgUmFL2xhTfFh30DsPsjg1hCIsQI/y4vtjeD7HByrbT
	 yF43DQKEx+kfQ==
Date: Thu, 26 Nov 2026 14:23:55 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
	Roman Kisel <romank@linux.microsoft.com>, Saurabh Sengar <ssengar@linux.microsoft.com>, 
	Naman Jain <namjain@linux.microsoft.com>, Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
	"Jose A. Perez de Azpillaga" <azpijr@gmail.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Eliav Farber <farbere@amazon.com>, "Gregory Price (Meta)" <gourry@gourry.net>
Subject: Re: [PATCH v3 0/4] mm: fix races between huge and non-huge faults in
 PFN mappings
Message-ID: <awhAygxxEKQ7TVuY@gremlin>
References: <20261125-huge-pfnmap-fault-races-v3-0-bbc44489341b@kernel.org>
 <dc62bf2a-9188-4cc6-9850-14ab3a2e5274@kernel.org>
 <awg3r1kVqhQy7wlZ@gremlin>
 <e60ef611-5e67-41b3-9c5a-ade4d183c492@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e60ef611-5e67-41b3-9c5a-ade4d183c492@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0CD5940002
X-Stat-Signature: s6t6pny7rcgs95hgqak3t8nf5446snuq
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795703045-683661
X-HE-Meta: U2FsdGVkX1/MdkLdqObWqRpGuzSIrqrDOMXXojT5vvT9iS02fvG11LIE4Lfpyi7ggcuPPpbQJyfbUujJ1ApPRjAB8Ffae1+c/ZwaAQGJLoFKwd9j4oc3zAVswT+ojBkj8NBgkLhdBfKcxxkKDDPuZY3vVaUjrlBLWDtOYcVnffv/KzbhjTYPtL1Xq5YU5CHhNykqsrimhmwJQDh/NaPf/wD/3UWfryH5fbNvVo8mXatiJktm7IBsB53qupNow6D7Dt2Gz0vd8gyHO19ACUQjrWVctFql2mK65f9YvC9A6jjKjqUc6ED+GE1ucfVR/pTNXbhpLHWpbCSh95MmpkIi2qBCJNyuWWmeWBrF5q9bdg3KWskAOqwmr4AR1qnSRTAZv7yAFCQdI/RWCv5+zGlrUOqkmOfwiRXeWMv5znp+0uGMlZtIoWNIPw+ouwcY62EkLDjwRTm/YUpwa5yJMRmSWVZOhCP4dFtlyLjNWtZWH7YN6fa68/Rh4a0Z5nuHhjGdgk92zgPaRTmkj7Sqy9GHWocoImOQi7YiDZy45/wTITsWkQBQE9xX7lF9ZLQe7bPDhF5u6HXES9II+BUsjrYpMIijWr1hwt1s7WU0Y0MndQj7qWTTBIu1oUkFs/8B5zfszP8+yZrUMNog4sBUgu5bcT0ysRIptxuulKMEGOa1u28YVnqkjBC9oogqNCu4F2HCT2EJAvf+n3DGR9spETUdqFhrMszGMVc6Kh2jQ6B9EHPEQomf2NGgsvvvO6IeqNb0V+jw2n6q1RMsJ/D/WRhnOHn1nkUGT+YeYP/Hl3A3jaFS6b7MOkT85UsbHQXJEbhPSaYbDvKvEvRqAuo8y9AJAwFoxO4Xv/Pdp2W2yyRxsIxoZjSJ3xaAVlDjrcAdvrafPZPeCN25IOeeuYHFhmJ/eyVCX3/CQXr100hqTY37/dVT8TuPcMi77kp6JVVLvHrJu2fNvd4XzuY1+bCJ/yn
 wWLFZyHU
 yJrUBqFxmiichReGl8dddaMAFzyRN099rjlpSGGmGSNU1O+utOgvAQymMNzip79RD4f7SWMFAdw7uZ2fg3DlSyYlFSbsR3IzS/TajCs/HtXVpAQsWjWt4F/5gD3Oopn6p7rYZZvoTOyffL4j9mAa0DlhRpQDVBBWlFTxElSeVjOkUs3wK4Iz2nQNqggKWDB7irHH2nuhBGjeGV8Cn3sLMKyCyBAryUZFZJbT1pMWp+b26n/ecKMSaNhkBjpiBvij2JwgaJp1Io8gpqywe1mL3J8Sp17J7gRvn3zK6SbSOS0h1L9gGUxQgqxOAT1OfzZ9z++/DsqgLBDVnulTyIz0SDu2sZp4A7PcpONhsX47CKiGrHzV7OXL6cb5DLq4Io12DoofMNBedm/mVUqUUGZf/bZHXhb0Mi++8dfcBWGTAxAy2cakfbg64cZjujXXcQsOmfq+TS7Ur4mc6Q7az59r9L4GMQwHS6oUXI8bx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 03:15:57PM +0100, David Hildenbrand (Arm) wrote:
> Can you resent against mm-core/for-next? That would help a lot.

[ ... ]

> I dropped the series from mm-core/for-next and pushed the branches.
>
> If you're fast I can apply it there again even before I merge -next this evening ;)

Sure, on it, will get that out in a sec!

--
Cheers, Lorenzo

