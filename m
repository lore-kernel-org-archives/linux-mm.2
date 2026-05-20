Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D22CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 21:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE9436B0088; Wed, 20 May 2026 17:59:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A456B008A; Wed, 20 May 2026 17:59:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 988366B008C; Wed, 20 May 2026 17:59:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86BEE6B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:59:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23551A044C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:59:19 +0000 (UTC)
X-FDA: 84789164838.21.C9E25E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 726E914000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 21:59:17 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2x4AZIv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779314357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjrZfJA5LVaV6nvefAlqmqd3ZyjRNop6UOwyOfVB51I=;
	b=akd0dfpXhmKPeafjTaOXj6N2ASCBfomXuWMb+P5HbdLXGS/ng0SB6VnhZKgRzf8NKbQEyA
	AnfG9s6cDT7o7zzYMghQPr7LYIvClvdles14ABb730zb8f7uxJlcnMG+Vouy08KqdAONSR
	c89l5mHfItJu7Iw3GjsfZHC+nDmOcLA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779314357; a=rsa-sha256;
	cv=none;
	b=vM4/sf3xb7sNkpkSuHmLK0418g/oCi0VAOuQXGI9VSgBparPYsCIi+BzezmguAhRzRlRet
	YWrp7RVpj6grMRIkhsYhvjVnWWZR90Blm76+DSnA44avlSNr+8t29DyqXJcplG8VKzkEsB
	7OX2sQbrG+B8xdov33TRniuNEpHtKUE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F2x4AZIv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3A85600FF;
	Wed, 20 May 2026 21:59:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E5B1F000E9;
	Wed, 20 May 2026 21:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779314356;
	bh=tjrZfJA5LVaV6nvefAlqmqd3ZyjRNop6UOwyOfVB51I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=F2x4AZIvETZuTswgfkeOHnkgP5j/iV47PP07EQkqmBL9s+K6OVe8bb6kBrdcw6Pen
	 zlEo7klNwkxdCSf6YBhEwzzm+AO0xa3E+EZg0itoUCZPOytvcbderUtMUDl4pTs5t6
	 srPasluXZ8Sp9zApk2v8seFMUk+PjFypnjRiXDicDb1RplKUjqjQetm8EYfSEvqA53
	 rDqAqNkEgz1aNSxK/MeIE/Ax+nrZkLjCbVBE/OxHTdx6rKzVFiscIjtvxZeCT770Pa
	 t5j5khIrKUWesKiRhXErmr56Kke6x3kknpbZ1Z0hk9Ee7dDPZ/u88t9ONgQMT2ifsy
	 uuRBaiONd0mSg==
Message-ID: <003bbdb8-85ae-4e1a-9260-fb2a85fb9b3c@kernel.org>
Date: Wed, 20 May 2026 23:59:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] x86/mm: fix vmemmap leak on memory hot-remove
To: Dave Hansen <dave.hansen@intel.com>, Juhyung Park <qkrwngud825@gmail.com>
Cc: linux-mm@kvack.org, stable@vger.kernel.org,
 Lu Baolu <baolu.lu@linux.intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Andrew Morton
 <akpm@linux-foundation.org>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dan Williams <djbw@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <20260519151008.1399226-1-qkrwngud825@gmail.com>
 <e9a08bed-3d5f-4606-8d17-80a16a4c82f1@kernel.org>
 <CAD14+f316+wMZNm_sJF6ULRDUD9EbkdecdDwhGQKcsu70Bdp0w@mail.gmail.com>
 <9c0e3e53-d284-4675-89d8-943f93436e07@kernel.org>
 <78ef8003-9c86-4969-95b9-589127b30be2@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <78ef8003-9c86-4969-95b9-589127b30be2@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 726E914000C
X-Stat-Signature: j58ddu5q4rzwznaiuos83iettp3f6f6g
X-Rspam-User: 
X-HE-Tag: 1779314357-901222
X-HE-Meta: U2FsdGVkX1/GATQkwryQKxq9g1nKpwF/r+i7MYpbXwpOSXMrq9JaLHkxdBjSx9pIRH71f1GW1CmN/Xq3FhVDL26hgTqxk5m/k+G988pWPOZC6xVRYwLwZmxFTkU3WnPfV4G2fiEb2R6rKLlIY4004CweqRJ4e3nEW8/ewhYcBWPMXce7rZllZ4TpyLOTEYnNb35d6Ra/L1Rx1dlF23DJ9XqE/M4c2JTT5950ixixLBo1HjLZhcygUQa3nostYy1xaLFEkWUXrN+qLBxfwkKmBZEeSOFWFFHhpamA/bdEHYjdv4WJsDCrPaYchLoF3tZRx0IItXRaLZ+3hqM9nZPXEhO3gsuKsfJO6yfdRPh2SVd+ai7+klEsTpPcPvujC+1ew7PzwBslzi3FNAv3S3zag/Ikv0IogcL/ftWlA9LfDELGMBc5gXGPSQMOaDK63rXsTBAIuynycr03l0TGqI/ZBr1GzjTVUBni4xjCmW+8u66ALNte1Mud7idy3myh64am/0IsACdQQ15/UZwsTfTK6sFjqAgPpT49bkn4Vb2rgN7mfXZx+Pe2DYSuEqdgpjc4aCxtSuQVlaFZZvOZv7DI8ghJtHK7UVcw6p0gjwcYobhDdT3PobnU9myMExL0O3rnd5OHxK59mJeY3MOzfdW7Vl+FUuwUvy4NnyMGQGobqex4lyGm58eoqR5HoEa1YUeOvGaE2QMGBfasrWm9O28XhCZ3PRT1bXvYE8k7oM9ZB97yoscQ6nkBY349SuqNIWwA3etlveLiTv3x6o1FJ5Y/PWrptDYndJB772Nvw2S8nCBrdjB2grCS3IqQi94GIrN4TNLmODJWkSXGgg5JENHciWrn3Jk8KoSDJ0JSfzJoDR5CVFw7p954+kaHa+ZKjnSUfL/QFFVKRud+n5F12rWLbZ3xvPTJPt2HlWvzzbqRAo2kvCf8jdxY7RhVNy4wA1h+pxdgS2PcOKRWVf6YJ7i
 MWwBvdGz
 4V1t8sXoXP6Elccqb1Sr04oe96l3iBwZvPFvkXfG0lGlTzLKLvzyd3HscMcDY6JyS4pKrP2bPrN3kEOk8YDsTebwva5gjFsX1hniCIeluamxPpK0exmc60ZKZ4saAk2amgUWQuMp7kVcK8i3xC3OFY7bReXGIfFu2RMtLQuu2Kf9l5O/avitwAFs5Yd0wFfH/WLexrMa0F/z/y6k889JUnaqOiPb7EidiAxWSLjryVKHWLnrtX2s2S38NwtbD2EjWVr4ojEDfnZeSAoQnUB9Y5w50SKmXzAbwI1Za
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/20/26 23:54, Dave Hansen wrote:
> On 5/20/26 14:52, David Hildenbrand (Arm) wrote:
>> On 5/20/26 12:33, Juhyung Park wrote:
>>> Neat. Any sign of it getting merged?
>> I hope it will catch the attention of more x86 maintainers soon 🙂
> 
> David, thanks a ton for that patch. It's in the queue behind a couple of
> other things, but I'll definitely take a look.
> 
> Attention caught, I promise! ;)

No need to excuse ... my inbox is overflowing because of conferences and travel ...

Note that I have more cleanups that are waiting for that fix (including,
removing the order parameter from free_pagetable(), removing
CONFIG_HAVE_BOOTMEM_INFO_NODE), so expect free_pagetable() and
free_vmemmap_pages() getting cleaned up properly next.

-- 
Cheers,

David

