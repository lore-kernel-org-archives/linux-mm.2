Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E87C9C61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 11:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C20FA6B008C; Sat, 29 Aug 2026 07:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2596B0092; Sat, 29 Aug 2026 07:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7B86B0095; Sat, 29 Aug 2026 07:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8EF196B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:00:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 23866C0691
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:00:20 +0000 (UTC)
X-FDA: 85154013000.29.BF1C5E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6CE091C000C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 11:00:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FuX452UX;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788001218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gXc6uvmEEbs0tjpDmzTEGwxIlYg9TWDsfiwiPxngOzE=;
	b=cMd+gNTgvQIzTWn8WkHzZ4VXU8EkExXEakQU8EaWIsNe95x67xIvINCXksxqhhd1EnK1MA
	AMjSbwThLW3QLZx3E7zizGRK2N2D8snDHkh0oQGa1K40SZuPU17uIRSVuZ0GNK/Ftx4Upa
	CM0+ERWlt6ogqK34CAhU8bfcY9ZQKOQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788001218;
	b=2t5mwyPBEX9SUnzphibKufnthypV0uydAZVnM0iT9B7btW0Y6GkIg6OQS4UuTF8+S2tD9X
	UajYV5E+oekUBkP7rrrdtk3unscbG361/P7YUUd52HwHEKQe4vMr0VSCCKg+rk0Iz1CONE
	kaVFCKyqrRMhMmrZjqhGUGvXCEhm7Tk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FuX452UX;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 35CF241600;
	Sat, 29 Aug 2026 11:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ACDE1F000E9;
	Sat, 29 Aug 2026 11:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788001217;
	bh=gXc6uvmEEbs0tjpDmzTEGwxIlYg9TWDsfiwiPxngOzE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FuX452UXi8Md7T20vL745dUi69Ui1QV/KOxLJj/ty2S9fwWxlS38Y55KfLpQWahhr
	 hopl168pK0jYYEkNMg236NXMW6s3gtPGn3OvYa4cKJiZ3YyALIKdJwqiSbyfy7rnrL
	 PXnGZl2bYgkAb+OsTZMJfjlYbazbGpwXeglNtUEFeqIgSiw59ymCfL5oNAX0RsVmLf
	 T2vqLfykJ4tJGrDwUQkkVsFB69QnkEz41lElPHW4pzsVHGhlXtNPu50Q2Esmi3tJng
	 O38SgqKGHA2jitUBjxGfntIUAYcJMU8BeA3MtqD6nWhNjIAqTUVLfyVtTFW8ciUo3x
	 Kn6KLeUl0ZKlQ==
Date: Sat, 29 Aug 2026 14:00:03 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>, Jann Horn <jannh@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	Nico Pache <nico.pache@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>,
	linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP}
 into single VM_UFFD
Message-ID: <apK7s4xSgA_GmY7d@kernel.org>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
 <ao16VxNvaYzlt2WG@gremlin>
 <ao_9R3CbjYFipFu7@kernel.org>
 <apAB9GSnHNyNoSc1@gremlin>
 <apAcweThjiD-iIBF@gremlin>
 <37f6af95-950e-4457-886e-6548d4719f0d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37f6af95-950e-4457-886e-6548d4719f0d@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6CE091C000C
X-Stat-Signature: durzymgd6ee53xdxg6bt1yr8g8iqtxgk
X-HE-Tag: 1788001218-532816
X-HE-Meta: U2FsdGVkX19ojmTkEMj2pxnZHyMA0mrF0OAmqinYvWwfQPpG7mjhGVIyQF3lGPVQPGtWQvw4S0E+3UOi9GK1te6dxLkAvvjNE+HsEM4FdTaJK/UwNZXW4L7OIKaRGaOT0tSvyns/61EcewN79O7K+Qv44U4UyYXUFdDntB9YlqIX/k87fYIIAXhfqUIAdeVM7xeqggJF15/1Vl4HYDeJaSJKdDcCWFJ6vQ3+OfGRKjXKHXrSgXDHCoO8mZ/ZTqNBtjXyPRU1ehqvl6d564uIZ9eXzbz52ifJBXTmDjUs/js8zRrv+V3vYR6Nlie7iWtge4sR3q/Lsi/+TKQq2mosxZNS7JRZ+QIPjdCUVrMyfqsKzvwqxi9WEq33aocc5xr/xMnIP1jA5VTL9TNhu6i3eYrwqle35ifOR7hQo16EVr8q+/KF9xgvEPqA+W4uXNl+LTuVERhTjTYoFTeExt48yGH5NXkPFCs2uyoAUg6KuR0DyKL2xkhTttEppoVU0Rn2+rCGwnxva32sCBL/OC++g0N/LRRdhVgoFt6KXZm+YttjhoD0un3Tw0Oe8ZRaW0FR2tU5mAmcgNtX/amH5BCnZL9mtBpARRtP7lonRwranQwzFEd2jmZWgaf2+4o6KSIkE3BaAAURI7MYPK5LLcA2mHX7+YFpW2nAzJJoR2MIEI3yPxKPB7Ey96HIJ62rMax9Y9HfOmHGSw1hmKGxKlU0I9ho4oa/7tvd4rqeOCBe3P8cCoG0hiRNm08LmSY/KAWLufMATm4ODmUaWoIhDqjWO1cEI5VdGilimCUZttCmmIjPX1YrEXwPqOUAIPmjNsYHm9W0LecQG1WF3frfjIpJB4lOfzYn6+H1OTPUr+62gVb/lx0PSrLfQFqvC92914V5zxMM8fp7DiWRxzdr6Rl9D88GFPwG2xU7qxeqkwFmLCH3rubtRoHCkv8K/rQQzy4NY936hCTD33z8Tu2IKM1
 gD41ZpZo
 SKX3TseIU+glee1ID5iHIKKa7+/OVza1y7/w1MyfglAanUoTuZmDPgfqiQjcCL6Avis/xh8PbRWcRooZuCW08eBR9N8xcSmp1BGKopnDK1OmpVhB3Kwu39QL58x7OZvh/Wt/THfAsiMz944dlTNcJgZfMOV2Kjuuhrl3YjeXBNsvhbNmdFBEJLTAp5rA9T6t5u8LKo2vC8pqRo5SsGFnQKvaLUEYlb+Du5BhrfNbXo6ddiI5WbyYW1AyRSTB7TNvAIX78ZsqrJ6bU/+N/YuzpJ39hY09k76+OlUpVp/aM9yw8tEKr4P/9zwYwYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 05:19:30PM +0200, David Hildenbrand (Arm) wrote:
> On 8/27/26 13:18, Lorenzo Stoakes (ARM) wrote:
> > On Thu, Aug 27, 2026 at 12:16:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> >> So actually you're increasing by a cacheline and increasing the VMA size by
> >> 64 bytes, i.e. 1/3, which is unacceptable obviously.
> >>
> >> Maybe there's something that can be done with:
> >>
> >> 		/* forced alignments: 1 */
> >>
> >> Perhaps? But that looks potentially ugly.
> >>
> > 
> > I say elsewhere (or think I do) but to highlight - I think probably we could fix
> > this by putting the flags in the low bits of vm_uffd_state.ctx?
> 
> if that's possible that would be clearly preferable memory-wise.

This gives only 4 bits and makes this completely not extendable.

So I think I'll drop this for now and wait until VMA grows another cache
line or until having per-VMA uffd state rather than a pointer to per-fd
context is a must.
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

