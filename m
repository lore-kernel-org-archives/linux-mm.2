Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3310606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gwiAMXoB
Received: by kanga.kvack.org (Postfix)
	id BBD606B05B4; Wed, 18 Nov 2026 10:31:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D0D6B05C2; Wed, 18 Nov 2026 10:31:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0F3D6B05C4; Wed, 18 Nov 2026 10:31:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DAFF6B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:31:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73A49407AC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:31:43 +0000 (UTC)
X-FDA: 85448629686.01.D49C4FD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A296F18000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:31:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gwiAMXoB;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015901;
	b=U4Z8uO37Gbd3ch/Uqj/FSGGtFTnbxWKGRQC2MCynoq2vtQ2+tXHYW8DU1GiQvfJdYi40/D
	VSSX52gD9Fo1OcR2BAeBFgr5vQPy0O+czSXDSk9BPz3nvoK+UgVVTXU4IVbtmAeDX+AMNN
	iL6mybocRo9VnnhvLUAAe2DRkJckfgc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hYM8bpbp+9xhfsHxXLNF3JDHZuqj8rY+dL36Itkgvo=;
	b=0TMIeZ/5Q8SRRqAZCUyTjySfvSjX/GWSpJTAMOy8yz2bZ3FHHOP4yVYVAVtmNM4rGJVt/D
	xUbiphgy3xYVP6ZBy+YyOePQFBIYXNw9Vm7u/ZQnqgZgoZOlZ5k+R0ObWDK/XLODSHiIsz
	vcnQ9cQX3Zmj2ekZ/osQXqX0JW3CIcQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gwiAMXoB;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BD7962462;
	Wed, 18 Nov 2026 15:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F24F1F000C4;
	Wed, 18 Nov 2026 15:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015900;
	bh=/hYM8bpbp+9xhfsHxXLNF3JDHZuqj8rY+dL36Itkgvo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gwiAMXoBTo2CvMn9DRTyNeLMPW2GucVsI20FkFOP9b8mC67q0VeBWkMoqHMXogm5E
	 QXDiPWNucsuwYRQGs/InLLIvP9UPu1VzlYYjMUXoIcToAwG/3INezcalmn3mEd8j2r
	 rn3kRKHdWdI3YXmm0XG3rS8TeLV3kJwEBNwDhJ88QlCkKB3LZH3d9H+I3+GvIBzzPQ
	 zTxH5Mp6DAypeE2CXjQNNxoVqe0JgB3UQZc+NDfXa21MfD3WK+383bSa9HKrkVr+c2
	 1Q/4Az2gdRimU3M1UuJ0W579N3grZCWU99UEnC6znm6lu9VkNGyZQ3mVN4lPL9MvxY
	 B1dwb93lZBgsQ==
Message-ID: <0dc23953-328a-46b5-9432-4b1a1a16fac0@kernel.org>
Date: Wed, 18 Nov 2026 16:31:25 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 06/13] mm/migrate_device: don't let go of the fault
 page
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Usama Arif <usama.arif@linux.dev>, Kairui Song <kasong@tencent.com>,
 Balbir Singh <balbirs@nvidia.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?=
 <jglisse@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Yu-cheng Yu <yu-cheng.yu@intel.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>,
 Chris Mason <mason@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Mark Brown <broonie@kernel.org>,
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
 <20261113-mason-migrate-et-al-fixes-v2-6-50a2ed382b61@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-6-50a2ed382b61@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A296F18000A
X-Rspam-User:
X-Stat-Signature: 97jgphz45sfax6yrpoc6u6cgm4ca3r15
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795015901-655552
X-HE-Meta: U2FsdGVkX18LVb9igoZvVM8WvwEiQHezOaeH/MoxEC4uNl6ZKwHOvfThf0V3ZNSZmG8wS8GHZohqxAI9uIScUF1WUiZYRhwekd4oHhTeVheuGgFh0SVIfRyI3ZvtaUbdvccKD6C+jR5uX2hsgjTdS7yHocV6qkQNqqkSuklC+RFJ8LTDKR+merw6VPv5t0xcZqXz0bi7eyA6IrCAt5dI+ukDrHEgVF2vFmQgxBWIyCNMMzSHuG31+dfLFOS1Lx3Bb7gsn8R4V3f7umJ6Ssu8j8LmdK3Zi56LEeL0+zsqXaiLcg8lV3IGL/49+/dhRf4NhqY6Fvbhg6NizVXgJgkEgg/xlgD4JmiPqNB1WBtCHWJ/VJiAnEWH8Jvi8Jc1tyr2HVG7Kp/GFV8GcNEUP0ISf5a0IeSX2yb/ZRwWlkFIUvloXv/9hnE531IwO5NZ2SYCav0PFuV/nKjDud4/KP+mfQCOv2871fIN0CgrWIs4U3DyQdU0ft+VB/h47tPGcuSjYK7D/DIoHfR85brsnW/VIeJLOPHopTRYNvL9DrTEiPbXkkL0dMicDLFOnpKq3wtlKIGSUTQA2FdJyqKsTlkJHY6dmqsVzdwTwu5N+9kARs1gOY7JIoXtKIR3itDAXdGY2xdoJJky/KtlYuDQzz30lCFQHQYVDs/s5Nei3O6q74Fbpmp3OH657oG0011Jh72vCWKVdrN9ZQv9Ba/fdhzTxzDcks0SESQpTS1krIxIpUpvqX2gtIV4VWkQ52/CrHZ4RXJbhW5uK7A6cylDMSP9VsXlTUW63mpBoXOxnfamN0IHva7ZxhZRtkN/BHpWT/dFTls3J4Mzw63i3134pAVa42F4Go8UZnTH4qrNmq3CIRp05H9lng8aDJ6G8+v825+jKiXm4LqmlgZcBakF9sicsy4laiaPyVW7RYsxVxaZljWbEYfuKx29Gg8Y1uJ3y2ld6agCIzMJ6GrPfjOm2dx
 hMtexdNY
 gEerJf3Evy9BlZSub89ClzFQ4AVFH1yAEAjY3krbcncHKCBkNtA5gJUCxXHNQfY9Fq1Wgmk0jnmpv9cmtp9IF4LdACIWwfeDdh0y9AeBeqEN3V3kbAaZBzpWvxmulP3jYXcUvRhzV2sXT2r+bCsiYhP/AgS1B0uMfVdQS0B6HTnsptWBs5yCb0AhZPpXDaFSRcsYZ/S6zDNez5MbqbufcV6KHZWvqNyf2hcZdlihKZdno6kB8xRTkqKizFRqr0X4Ry6O2ThltKT9FhK35DCvGU7loVeHb6wY51oXwWKBzQxspYwkxWuY5d9D3lNfPbM9aI4iiwIlUVK+9iEOe94zOtQXt7MyC3NyoxIRI6YGCEzL5w1MXt/hsgZjGBfc0knt8NQRsggBJzs0uXjfa4WLaifO23/3p09nezlziXsyxGXOLFIFZbAJuUANRvpLKvtzaSiR5h9x8bFbNrp4XhIdC6JEypKjdeCGWkYjYTLc8lvDS3fLCYawi0ojA6rpTijGST2pRHl0wx6QEsTJVcQpDA+Q55+6OB4Ax0hE9hD1YFvkvxiPqio5dzGkwRffwVL4BH90FXPX9yntZttdER6xisMDjAoDnssc5jLebEqB4SjppsDBdlh+OTLQDsFF80efbe074
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 22:45, Lorenzo Stoakes (ARM) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> When migrate_vma_split_folio() has split the folio of the fault page,
> the lock and the reference which the fault handler has taken are at the
> former head page.
> 
> It then moves them to the folio which now holds the fault page, by
> taking a reference on and locking that folio, then unlocking and putting
> the former head.
> 
> split_folio() has unlocked the new folio and has dropped its own
> reference on it, so until folio_get() nothing but the page table entry
> holds it.
> 
> Only the mmap lock is held for read, which does not prevent another thread
> from zapping the entry with MADV_DONTNEED.
> 
> If this happens the folio is freed which results in folio_get() taking a
> reference on a free device page, which the driver can hand out again at any
> time.
> 
> In addition, folio_lock() can sleep here with the lock of the head page
> held.
> 
> Utilise split_huge_page() which will leave the lock and reference at the
> fault page correctly.
> 
> Fixes: 022a12deda53 ("mm/migrate_device: handle partially mapped folios during collection")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ ljs: tweaked commit message ]
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---

This code is so bad we should remove all of that from the tree, seriously.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

