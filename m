Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 238D8CA5FCE
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 19:26:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8AA6B0088; Mon,  5 Oct 2026 15:26:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D890A6B008C; Mon,  5 Oct 2026 15:26:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EA96B0092; Mon,  5 Oct 2026 15:26:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A77766B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 15:26:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 26BF81A0435
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 19:26:35 +0000 (UTC)
X-FDA: 85289554350.09.0618129
Received: from gwu.lbox.cz (gwu.lbox.cz [62.245.111.132])
	by imf18.hostedemail.com (Postfix) with ESMTP id B803C1C000B
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 19:26:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=J7hDwnY9;
	spf=pass (imf18.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791228393;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QpuccrIcgCvueKGVQVkI+hAnPAS4VH0mRSHq0z2XlXs=;
	b=2hGubkSVDdT7xqW8f0nRt5uziM9LBRwHc+wfJibc64oZfJg50Wxp/yrF0hSfK3CZ4MG2WQ
	PiBVywE4vsj9vJ2IdTrE2b59Kue4DBvAj8NjklD5jYmAt1N22u1lu/kFTI59A1+bHKVVj5
	LoaWvIVfrRP3OW9tXxSyEpYetcgPOd8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linuxbox.cz header.s=default header.b=J7hDwnY9;
	spf=pass (imf18.hostedemail.com: domain of nikola.ciprich@linuxbox.cz designates 62.245.111.132 as permitted sender) smtp.mailfrom=nikola.ciprich@linuxbox.cz;
	dmarc=pass (policy=none) header.from=linuxbox.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791228393;
	b=y5PXU4b0VgYGVAkaaAw8CGog1wveX+rrTy1P2vD7ZzeJsYUZJnjgqGnYQVkWvB0C5Muxqb
	WJStmzwYVWyCReED7Wp4gFddG9Fr6hUQwUe9f0G+6TFQm4ua1AGmZ58zjidU56i6ZMgGnY
	GZdSjRRRZLlFHKKL+EVOLnZQtnmpgP8=
Received: from linuxbox.linuxbox.cz (linuxbox.linuxbox.cz [10.76.66.10])
	by gwu.lbox.cz (Sendmail) with ESMTPS id 695JQ19o4191092
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 5 Oct 2026 21:26:01 +0200
DKIM-Filter: OpenDKIM Filter v2.11.0 gwu.lbox.cz 695JQ19o4191092
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxbox.cz;
	s=default; t=1791228362;
	bh=QpuccrIcgCvueKGVQVkI+hAnPAS4VH0mRSHq0z2XlXs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=J7hDwnY9F+btQChNhiXnDDvaPyIyZ25bzylci95cw5Ii+q9pOYzy19sME9STPS3mW
	 1P1P1RDB7tXKeDjKlOIO/cF/ZCo0n8CdmNE48eyRx4WsrUYrSGAWfnNJ1dhed4EbpH
	 cNQn2XihNsaomyCIFHjIlewPeCqkL+fKeF4IKYto=
Received: from pcnci.linuxbox.cz (pcnci.linuxbox.cz [10.76.3.14])
	by linuxbox.linuxbox.cz (Sendmail) with ESMTPS id 695JQ0hY042712
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 5 Oct 2026 21:26:00 +0200
Received: from pcnci.linuxbox.cz (localhost [127.0.0.1])
	by pcnci.linuxbox.cz (8.18.1/8.15.2) with ESMTPS id 695JPue52387525
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 5 Oct 2026 21:25:58 +0200
Date: Mon, 5 Oct 2026 21:25:56 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: David Laight <david.laight.linux@gmail.com>
Cc: Rik van Riel <riel@surriel.com>, ljs@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        david@kernel.org, Mike Rapoport <rppt@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Pedro Falcato <pfalcato@suse.de>, Kiryl Shutsemau <kas@kernel.org>,
        luizcap@redhat.com, pbonzini@redhat.com,
        Borislav Petkov <bp@alien8.de>, Tal Zussman <tz2294@columbia.edu>,
        Matt Fleming <matt@readmodwrite.com>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: hunting memory corruption bug in 6.18.x
Message-ID: <asP5xK4axiUk7jun@pcnci.linuxbox.cz>
References: <arwNebjYXyGqrp32@pcnci.linuxbox.cz>
 <arzRBv9ceJsxJppI@gremlin>
 <ar1Xl7PE2rcoT9h3@pcnci.linuxbox.cz>
 <ar63St2LBfCdyhwj@pcnci.linuxbox.cz>
 <ar9yRqq6cBxHDWKA@gremlin>
 <ar/F6+OUzj8qQ8YC@pcnci.linuxbox.cz>
 <asAE3kLFDUx5v0Nw@gremlin>
 <asKdhWiJb3qXeopz@pcnci.linuxbox.cz>
 <bd8e9b01ad88cafb12da33331f32a1ce315f590b.camel@surriel.com>
 <20261005132113.43548696@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261005132113.43548696@pumpkin>
X-Scanned-By: MIMEDefang 3.7.1 on 10.76.66.3
X-Scanned-By: MIMEDefang v3.7.1/SpamAssassin v4.000002 on lbxovapx9 (nik)
X-Scanned-By: MIMEDefang 2.86 on 10.76.66.10
X-Antivirus: on lbxovapx9 by Antivirus 
X-Milter-Copy-Status: O
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B803C1C000B
X-Rspam-User: 
X-Stat-Signature: xw5qkbmkuimhugua4ksre6ju3rac6f6h
X-HE-Tag: 1791228392-984589
X-HE-Meta: U2FsdGVkX18YpYo/O2xO8PXv/xFYC2xB/jag4Hj6TF/UWzBWHmW6mqlovjkjQw2QVn3RaXxBal84DnadWsIfIU6V+ECpBR5WZlKAMGmQ5xSio/rHbVhO31l/3wYvjsGNJFXdM0+33pbJeVVhpGej46JXSFqnm1zWFd0j4Eutqy763VF/zQRKeZ27kzU1XunCcnibJD35QXWpQXwc1ijOKn3a0J5igMSEBljWRSXR8YMqoYDPu/clE4aYb0jHHRDiKxYvB1m7VpWPKUhBildAiuNJm9HbpLWsOA13LzGzn8dng/P/FGYssmt8AJC7I7UhjDdjeAhwdwOEdaOiC7v71vy4R5kFLGej1OQlWTCMkKlfcjnKZ/edl3muf6aL+2trwUoZCL1BOAJn3yipKBXJXu84Zc7PymDrHTJ9467eS3bRMELOYKVVqPmB5XBEkiwfEuWxzzFVcsQgf2fsQs1pG3lU3gtHHvuBJ8jNLgQGWqd/hgaUZ0nuYOF8jwKmsz4bqByuDH9JjoWwTIt98gL/SfJWJguM9eLEnPJGu1ehFIVA9NtGpuLVdVcNTRCVYxIP4gQtIZbAU3xMR5M0Ae8JbWZrjglHvizgCKK4b76p53iN55Ui6fxGbIDwLWVtjiQVUss8SYIoynZnA0EHGqwafTqq3YgUSAefPA3QXA9OGuODRnCqW18gTAT6BBFe5tlmCW04RGwh5SNS+189XCw4YPIi4gfHixKN9ihmjD9j5BFil5cmNPGQZQBoeXOGiviQBO82MHhKUngntufDfXGgZZuavIVwRf82bF4Es20jkljIDujHA0nZ2bIfuwEaGwT3+oP//dUXLgVitDj5TMSUCHZyjc+daffSuwRsdUCVVcagbnrSF0bE8hU7ppH19Bb4IC9/BYnDnSvN65+tqGcO962U+L6HHQeP6WGWHsWzlg4+AUu/mzZXB6F0fy9W77RZ7smRruAPB2iwad7UF5t
 M/lTD4a/
 VO7r3uyBYWlYB9wgIoNlbJME1+w5tXp+RouG7WvimNkdRyLxM+aDFmRsfflwf3ZBPvgGLD3CKnigKNz4R0wvyfjO4eDzMlYV+dCSrClNaUhTiTuGNBEcYq6xmwxqJ7EK9vRQJfFHwlgpTCM+fQQCG9zN0lfdMESc2MW1FQSV6VRR8UDAvDALS/UMnslHYpGLOhtQJckoz0EaUzaNCFXrJUQskKQ6zHz0HM+N/Ck7rqU9eOABMl3l0P+d5nR0FzMCpNQOPX6s76h0n87E+0l77FgIT5KO0NqBbqyflPa9BEPhrOROsQe7THgu1ljKjKZpEtogmYYvzZ6lN93UsyweFxEG6lNPjCKf5RyHq6BjPf2VK8+ZG9BWzhWjj5Q91FlaAPTFV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> > > 10371fa400: fffffff0c930020
> > > 10371fa420: fffffff0c930020
> > > 10371fa430: fffffff0c930020
> > > 10371fa450: fffffff0c930020  
> > 
> > These are not random offsets in the page, either.
> > 
> > These all seem to be at offsets 0, 0x20, 0x30, 0x40, or 0x50 into the page.
> > 
> > If you look at the other addresses, are there any that are not at one of these
> > offsets?
> 
> If you hexdump the start of each page do they look 'similar' and are there
> any valid addresses that might point to other data and could help identify
> the what the memory was used for.

(again, I used AI to answer that, hopefully it does make sense...)

Yes to both. Results below.

Valid pointers in the crash frame (0x103360000):
Only two of the non-zero words in that page are valid kernel pointers; the
rest (e.g. 0xfffff86eb0c30000) are not in the direct-map or vmemmap ranges
(page_offset_base=0xffff985a80000000, vmemmap_base=0xfffff27140000000), so
they're data, not pointers. The two valid ones both resolve to the dentry
slab cache:

0xffff985caf209d48 -> dentry cache, object [ffff985caf209d40]
0xffff998c79483448 -> dentry cache, object [ffff998c79483440]

(Both slab pages show flags ...01 "locked".) So the dcache is in the blast
radius, same cache as the crashing __d_lookup.

The other value-bearing frames are NOT junk — they're a repeated structure:
Dumping the start of three of the frames the bad value appears in
(0x1ae234000, 0x24f0e2000, 0x342c40000), they are near-identical, a
fixed-format record. Field-by-field for the first 0x80 bytes:

off 1ae234000 24f0e2000 342c40000
+0x00 00ff00ff00100010 (same) (same) const
+0x08 bdcc802700060042 (same) (same) const
+0x10 0000000000006e43 (same) (same) const
+0x38 0bb8008000000000 (same) (same) const
+0x40 0000000117bc0000 (same) (same) const
+0x48 00000026813e0000 0000000fbb9be000 0000001b56718000 varies
+0x50 fffffc0ea76249a0 fffffc0ea76258c0 0007bb3a5e4ed461 varies
+0x58 0000000000001070 0000000000000906 0000000000000903 varies
+0x60 0000000003000200 (same) (same) const
+0x70 0000000000000078 (same) (same) const
+0xd0 ccccc30014894100 / 48cccccccccccccc (0xcc padding) const-ish

So: a constant header, a few varying fields at +0x48/+0x50/+0x58 (look like
a length/cookie/handle), and 0xcc padding. The same template appears in
physically-unrelated frames.

The corrupt value 0x0fffffff0c930020 appears deeper in this same structure
(page offsets 0x400/0x420/0x430/0x440/0x450), i.e. it is being written into
specific slots within this record format, not scattered randomly. That lines
up with the "written into one of ~6 slots" pattern: relative to a 0x400
base, occurrences are at +0x00 (x9), +0x20 (x9), +0x30 (x9), +0x40 (x2),
+0x50 (x11); none at +0x10.

Question: does anyone recognise this structure from its header? The constant
signature is:

+0x00: 0x00ff00ff00100010
+0x08: 0xbdcc802700060042
+0x10: 0x0000000000006e43
+0x38: 0x0bb8008000000000
+0x60: 0x0000000003000200
+0x70: 0x0000000000000078

I haven't positively identified the owning subsystem. Given the earlier
observation that these frames carry stale page_pool metadata in their struct
page (pp_magic set, pp_ref_count=0), a network/driver descriptor or buffer
origin is my guess, but that's only a guess — the header bytes should be
recognisable to someone who knows the relevant format.

Happy to dump more of any of these frames, or struct page for them, if
useful.


Field decode of the constant header (little-endian sub-fields), in case the
layout helps identify it:

+0x00 u16: 0x0010, 0x0010, 0x00ff, 0x00ff (counts/markers?)
+0x08 u16: 0x0042, 0x0006, 0x8027, 0xbdcc
+0x10 0x6e43 (bytes 'C','n') (signature?)
+0x38 0x0080=128, 0x0bb8=3000 (size/timeout?)
+0x58 small, varies: 0x1070 / 0x906 / 0x903 (length/seq?)
+0x60 0x0200=512, 0x0300=768
+0x70 0x78=120 (sub-struct size?)
+0x48 varies: looks like a 64-bit addr/DMA handle
+0x50 varies: 0xfffffc0e........ (two frames) (per-cpu/fixmap/IOVA-shaped,
not a direct-map/vmemmap ptr)
+0xd0 0xcc padding (record built in 0xcc-poisoned buffer)

I can't identify the owning struct from this. If anyone wants to grep: the
first two u64s (0x00ff00ff00100010, 0xbdcc802700060042) are a distinctive
constant signature across all affected frames.

BR

nik



> 
> David
>  
> > 
> > If this is a case of "system writes fffffff0c930020 into one of 6 slots",
> > there could be some at offset 0x10 too.
> > 
> > I'm having AI comb the kernel now for places where we could conceivably
> > construct this value, and write it into one out of 6 slots.
> > 
> > >   
> 
> 

-- 
Ing. Nikola CIPRICH
technický ředitel

+420 591 166 214
+420 777 093 799
nikola.ciprich@linuxbox.cz

www.linuxbox.cz

