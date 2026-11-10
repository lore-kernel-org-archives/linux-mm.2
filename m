Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88E14606A326
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GCDwX14v
Received: by kanga.kvack.org (Postfix)
	id 5F4366B05B7; Tue, 10 Nov 2026 07:46:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A43D6B05B8; Tue, 10 Nov 2026 07:46:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46CA66B05B9; Tue, 10 Nov 2026 07:46:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1C68D6B05B7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:46:52 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ADE89A85D7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:46:51 +0000 (UTC)
X-FDA: 85419183822.18.2B2F73F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1E8261C000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:46:49 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCDwX14v;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794314810;
	b=WK9oC3+gH8ysCdEhfQ3PsEf3Cjcc8Z/O+qJgV/eTxo4/D3Prxi/JPPbBLuD874vkuR/ZUp
	OIDtxHUJZ8ZyhNVtFQur7A9VNY8NuCOS5TujDbqT/J3UbtFrySNjwKk+bDIX8Y0W1dVHcw
	bDthjXsTKYZyd/PkkM8hT382knqCOO8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GCDwX14v;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794314810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Iadron3w0mtp6FUOIlxkmVN3eT1tt34wJC4l9phyJAw=;
	b=RBbsi+kwuCj3gZHnco3L2AfVjswJMvbQQNBM9GpNlCx0Yc9gPiAgI8WPfaL8l+MYfrxyxJ
	bF6x3+4AoS+raYTgLjk2NjuZySJAddrlNPiRLbBj5BhbsIXPzMw7HnfeowC5HRg9qk+dXR
	EDz0+CKi6djJJO7G2F3O5huZncG3STI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CA2140AE8;
	Tue, 10 Nov 2026 12:46:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8721F00900;
	Tue, 10 Nov 2026 12:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794314809;
	bh=Iadron3w0mtp6FUOIlxkmVN3eT1tt34wJC4l9phyJAw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GCDwX14v21WbLajB2krTKYrET/K+N61tHnKhsWXud1ti9u60OCiTW5U1YiOLKl+79
	 cRfsMDlqLKMteU8ZF8SIcjuKSEXCrHFqpqXb+CzVAdfBfUt7tgmKmxsZg1J5rf6QjU
	 vhoO3l5RHIcd6zeTRltf01kH5JNxY3cs9lnTBmDlY9SFnlNbkkJQYYPz1GM/0b+yF3
	 DOFL52/UerZ+0bck/E59XBGVrT8iuMFDs+iPGfbM8Wd/wIpWHE1h48068QUX0UdXLa
	 XiKG51ZqsgY2iChGwRIxH3edF7xYm+yOINlp4helsaQqqv/DbAZHLrSiQOyBISslxu
	 6Mg8xCAWlc/PA==
Date: Tue, 10 Nov 2026 12:46:37 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Danilo Krummrich <dakr@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Tamir Duberstein <tamird@kernel.org>, 
	Alexandre Courbot <acourbot@nvidia.com>, Onur =?utf-8?B?w5Z6a2Fu?= <work@onurozkan.dev>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Uladzislau Rezki <urezki@gmail.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS
 entry for THP
Message-ID: <avMR7WWJ2nis94vG@gremlin>
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
 <e1b0d6b4-f7ec-44df-a9f0-0e3a3722a973@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e1b0d6b4-f7ec-44df-a9f0-0e3a3722a973@kernel.org>
X-Stat-Signature: axa5f3d3d1deoacb7j5ae6jkh1aqtxmp
X-Rspamd-Queue-Id: 1E8261C000B
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794314809-863507
X-HE-Meta: U2FsdGVkX1/KIBTNG4cRvStRMpjOWYeDRLRFhC0iI+36gkp+MjRE6iyeQvpDmhHpoB23z3mPLGqgOCU/1abdYs2CVMMIgnR0svKx3NQ3ikReX0luXANXa7j0RExNF+01SS9vs85ZAOLJEX5nQV9j4MPKHoCk9HsYfXT4EL+6VUJpzqjZrFiNx5szusiHDRTPq6z/zvSHBX3Udw00PaT15TgugIOfhCHEwdLv+R6jJgaLvWChz5++TvNeW8yi+Nl8+u+C0Vuu7ObV5EeYZXsk/1ucoXcrw0FTh/dmBInGymVFSH/nPjyaXNdPNvA1kSnuh770JQbaQnI9WRsUsSbTDQ2onpjQnPbf2vAuSkhYNMcV4UXj4WC+kjHX+ph9lKw7DUWMgVfkIPd/Px7j2l8MPNl/9CUSed5nhxFjQZNqvLQU4OKe5SFMlrFKWkUwLDH7R5KRVDrEwGnidMNlOLVCp/IKVYBu6T2njbRmTbRQaM3yqxaykUxwIcQ7tL06FQt0gbZQkpFtfsRpI6lyLYJE5jO/KdHerHBvxB6BlLodPpxH8QmUtOMs3DxQtY8gT4WuOCmD0Do0UfKao/EdopUXRsPB6/AMJWKY+T0gQaYUEKavqeKnmPK2eM35pSD5XGitHyTsXNJYQWOu1w4XzRzmH4fvgGyzUZyktJU9PThQaTLHwgoO+BfyCPSdT1rYCV148QyuDaX1tfip/EQscbdMyDelJ4gwgUVfuhrhxeNMzDBfrbPYlNnWD65UYcEbM4JCgYGWz94V3QvBVT6Nad3DMycarKSXejEK/d6UOZ/K0UjJX5uwgjLKfPYlcDa7WLyLFSuBw7Q3ijY7syWiI4XO1b0gYEYTpJf23vai4lpsD9CU/cpD5TvYhH+NUW3EUPDR8Cfk09hE7DvgPL+1tgbmXx8SDuGjbYeiz+OTx1G3iuKG8E3FAMgudQ10dMJmT11FRgnNRmRICtYK2K/su6l
 3bVzPocu
 0Jy/lS4RFMKLFZHzjshzK/Q50cdolJQe3M8PscS8W9lCBMyXt2LyFMMndXDqd9CrHkqDYimqkzkYRYceGtI1PRL4f3TetPdyakprA03yFrVNt9brYtrhR5vc+4C9Yg+sY6IbRHNK3mzY0nnNsrcsokLJGPLggHiRs6PWSjGmLTk4+X6ixInL/3ZAFHkNLTCqQ17lE4TVT1ZVfhkUVH2m5B9vMyUq25B/hCymygg/sAcq2z0xSrCDP9i0o9EbLrVhTeg1XnMCoOPH5DRwb+WwZQ28cqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 01:06:52PM +0100, David Hildenbrand (Arm) wrote:
> On 11/10/26 13:03, Lorenzo Stoakes (ARM) wrote:
> > Given the current throughput in the kernel resulting from AI-generated
> > series, I unfortunately lack the bandwidth to generally be able to offer
> > review except in those areas I maintain.
> >
> > I have separated the patches into areas maintained by David, Andrew, and
> > Alice + Danilo, so each can take the patches relevant to the subsystems,
> > for convenience.
> >
> > Apologies for doing this, but given the current trends I'd like to do
> > something to make my inbox a little more manageable :)
>
> Yeah, it's crazy.
>
> Thanks a lot man!

Thanks, I'll still obviously help you out wherever needed! (I will still of
course send that fix series I'm working on now :P)

>
> Andrew can just queue the whole series I guess.

Ah no need to split then :P still perhaps reasonably logical to break out by
maintainer anyway!

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

--
Cheers, Lorenzo

