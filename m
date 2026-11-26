Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D8A1606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LoQ73B1M
Received: by kanga.kvack.org (Postfix)
	id 46D466B05B2; Thu, 26 Nov 2026 09:01:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 443C86B05B3; Thu, 26 Nov 2026 09:01:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B036B05B4; Thu, 26 Nov 2026 09:01:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1973F6B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:01:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B2AC814029C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:01:51 +0000 (UTC)
X-FDA: 85477433622.01.858470D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3146E8003D
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:01:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A35AF455E2;
	Thu, 26 Nov 2026 14:01:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB881F000C0;
	Thu, 26 Nov 2026 14:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795701700;
	bh=axz7TbyZfCz1r+C0ASr08xilH+HCS96/gQXwmQi+6d4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LoQ73B1MVqtATP8QZPwwSeTiprDc2wKSxjj01xje7iiEZgFfFU0KMru+M3MzGYI6/
	 Z6IqQcigpkNMo+6TO64XzXg6lZeZFiH/cY4GU5L2dyxgUAOqjQTClaOdObsxyiVdh9
	 ea7pQkJOyMN/oizgooKeWq7KdJ5GqD3S1CKyilOlFQt7V9ZoFibHNTdPK9WxEi03lX
	 funu331pIcghv+yY2brcDDtYHCiiA+n8B+W+8zqkiJoVAVjs9d0vsW2V8gsajhSi6l
	 fJfkNvH5b5RPeFPnAUVv7x/3dbt4X6PSTJCIPFaOfrkoW3rg3xS0dn/RXOaXvQX68u
	 FYfcM26VxRC6A==
Date: Thu, 26 Nov 2026 14:01:30 +0000
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
Message-ID: <awg3r1kVqhQy7wlZ@gremlin>
References: <20261125-huge-pfnmap-fault-races-v3-0-bbc44489341b@kernel.org>
 <dc62bf2a-9188-4cc6-9850-14ab3a2e5274@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dc62bf2a-9188-4cc6-9850-14ab3a2e5274@kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3146E8003D
X-Stat-Signature: 1fp7xu95kz9bfrkkpea93nypcbkj871b
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: nil
X-HE-Tag: 1795701702-552429
X-HE-Meta: U2FsdGVkX1/IxcHqnoUpW9gkt0XGG0qNah8r3jKW0kw0Kh54kI3zv6bijFv4BzMElFQFJiMgkKsKZVg1g9D151MOcbsEgZSoAnVEA1blQRAzwO+OOE/R0pByI+ilAtideNOp5ZsWqlJt2+BCu+xIFCo8NEvZeAbzL1DdfxyjCCdKrUu6JLO+dvYTtd+6yb4VpF7qrLUjWbAwkI7L0EywEdbXrr9WLnXPpYL9Q1n/pr1wficjZ/l0/5/tB24df9leZI5hX5X8IDAj1dPZEseqtOWFLPiCqnt9t4cQzGbx3sxZskEeJzoQjQAzOVqGNRBJIppan3RaZRCMqIejkVHlsLQQQHLcPqqpCopu5nTMUvmujaHlYfGl4rQRzCxwXD8lCnR70sgaYUxHJtbNCQCjXR+U8U5du1CRBxG6ZQ0g9lw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 26, 2026 at 02:26:37PM +0100, David Hildenbrand (Arm) wrote:
> Dropped v2, tried to apply v3, doesn't apply.
>
> Against which branch was it based? mm/hotfixes-stable?

mm-new. I can resend against mm-core for-next-fixes if that helps?

Only one patch is changed anyway - patch 3/4 'mm/memory: do not report OOM if
insert_pfn() races a huge fault'.

Let me know if you want a resend!

>
> I this really urgent stuff or can this wait until the next merge window?
>
> I had v2 staged for the next merge window.

It's currently broken in linux-next so you probably want to fix _that_ next
sooner rather than later to avoid further reports :)

As to the urgency stuff, as far as I + claude can tell nothing crazy here, so
can wait for 7.5.

OTOH I'm not sure how I feel about the triaging for hotfixes stuff, it feels
like it makes it random what gets taken for that/not (if you sent a hotfix early
more likely > late).

Also meanwhile Linus moans about that but then took a 41k line 'hotfix' PR
from ext4 ;) https://lore.kernel.org/all/awW86EI5fYafQx-o@mit.edu/.

Anyway nothing to get too worried about here, as long as it's queued.

--
Cheers, Lorenzo

