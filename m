Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A406FC61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 11:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD57D6B0096; Thu, 27 Aug 2026 07:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A867C6B0098; Thu, 27 Aug 2026 07:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97AF36B0099; Thu, 27 Aug 2026 07:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7BBB76B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 07:18:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0ABE91403CD
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:18:27 +0000 (UTC)
X-FDA: 85146801054.07.A53E55D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 77E0C40005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 11:18:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DC6qIxE0;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787829505;
	b=MC51qvwb+ucLyN5ZTfN/k+woBGB7ybJotNEbJg2NrVmPEfKsPBcu349NJy1bv9qBaSOEcw
	FeYgtZwy/z6su/213wDfShUCBNZ86NNllTDF2++5D36FFPbYS7JzzGe/8PDny1QFrN7XaY
	jQW7NZv3jBhb+pPpkGMmkIKToyIMaiU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DC6qIxE0;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787829505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UXfBo8v3K8VIzDSO2VHXgtuPrAb/8lRFr7BXsf++oYA=;
	b=JRmKV3+Fa3a26lc18GYVlp44pSZUhs1Mb0l4xSpl5g4Ohb8H+fK/RfuWQMlf0/em5tkd9p
	zp6roPjiKfwCCkx/Xvwo15zcyPgFnUe4HpDwPU4ETg+IjRxVqawIN0fH7D1NMjwI+vkq5t
	mA4nX8qSKFeQFiXwaUJDHg0IL7JGYjo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE061600D4;
	Thu, 27 Aug 2026 11:18:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FF01F000E9;
	Thu, 27 Aug 2026 11:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787829504;
	bh=UXfBo8v3K8VIzDSO2VHXgtuPrAb/8lRFr7BXsf++oYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DC6qIxE0KrdRhnwTpQj+mqOREb/P52l2gDOdyFApoE8VA1gv3wcCC3cG1+ykL3FjI
	 gLV3FcWtR1+Q8HXEsmNwdHlWMLmr6Ox5CZzzOTla/i+4zIByVE+n7H9QeLbqUQogTP
	 HINaxGjyQ2EfkOvrIiHXrZQ/YuvaW1nAJ04hK9lO596nhxDAP9PBO+TTzqNAXyYD8y
	 jFe48V+dIKFBme7rHsNveL4VaiDtgdVQ6BFNh0GS6CIQwxW+R8p1M0PGA1lY/0j4F/
	 kjvulu43FN0rQAskUM5hgMh93Jh6XhGXLIM5ckhruJrXivG8JmUlG0gU47N82N0yaF
	 KlpeMGvJUSCAQ==
Date: Thu, 27 Aug 2026 12:18:14 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Hugh Dickins <hughd@google.com>, 
	Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett" <liam@infradead.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Shuah Khan <skhan@linuxfoundation.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Zi Yan <ziy@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] userfaultfd: collapse VM_UFFD_{MISSING,WP,MINOR,RWP}
 into single VM_UFFD
Message-ID: <apAcweThjiD-iIBF@gremlin>
References: <20260823-uffd-vm-flags-v1-v1-0-3086981b33cf@kernel.org>
 <20260823-uffd-vm-flags-v1-v1-6-3086981b33cf@kernel.org>
 <ao16VxNvaYzlt2WG@gremlin>
 <ao_9R3CbjYFipFu7@kernel.org>
 <apAB9GSnHNyNoSc1@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apAB9GSnHNyNoSc1@gremlin>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 77E0C40005
X-Stat-Signature: 168duf3arrxzgsfwrmgu1gqyuf8spgsa
X-HE-Tag: 1787829505-862014
X-HE-Meta: U2FsdGVkX1+E4TqcC/wvFTfjJaJgIGy6LXwsNcvrfgG4qM9sjfzPS2F1wRcpeI5k8+bFCOsOYeLfJYwqqSNn9lb/gMvjCsdW3yaZHfRHlZUVSimh1vs9Axl1ZDHYkQkmArjIhoVbis014woqheUwXlLHzrAG2c3BBYj87cqCK+qLH7egREHf3sUK3T1IpdMnrPDw8K+qONeWbsRDLA75pK6Mn4JeY2WVMsfocszpv8ZEmSYDx38IL/jETVP3JzObPvT9Zyg1SzMhdFEL8EdDtIzNb05GWk76eBIaQrtLrsUK5XKqighj9rUyaCMaQt+Fr77cbxR8c8qjHhYCfAMgwOw5PnTuhivxGJD+DO56rWSDUOwsHM2JXFEN60uh0qx1Xe3byJ9mMPecP/pj/xcq5vx2CwXpcDHOPFGctGyLuVkRek7GmjehXb8MSvNZkSTpDfbv22HByce2Z8N4prmDv6slwILd/PFfLfID7kbIYRlNvCmvVuoetesNePOcVlgsxB0neHxfuya832jGdJNCim6vOPBz2Z6Z/7QuNIdT7SzoaK9U6RQwAta7dn57y6k0GQvePWfxV1o3MjMCaqIzKon+dSq4EN/m8vuIHEkgaOIh4S9xMi8lRcXJWg/9g6rXUWXeJR8dvAOuaTzdC+Sf1qSz+N3upL8atAQCOh9wdrNdK2R1a4xHUkYOIaU16aW6HIrXLqOCZJlVdYpAqsv56OBTqajjxm97PvYqCRW7u70GKmUoVNaOq2PGLm9nkEydv8ih4dbbnvcsQgTMxEWLAlJxe8hIyiB+xkMJdNWiuTWeDi14teampU+yQT2Pp+EsmD229HRofyTXyj/O4oafZpEbGXQ22KKDQpeuUaGJBYzns+2dn4fgoBOqDm3tDbmK+CNQ/rOmyk3Ok59TP5YM+kXFRFFA69m3aQEZ1NPm5YVR/q5X0Wr1SmLadJ9sc+28hqfqdHvFfHbDlTzYUsk
 b6WsMaze
 Z8QycQOenvXDxUgJugHyaYifn869JONbP03rde/vJVAB0dbvp4J1WImY6qYJLS0nlg9BjXmg9Wzph+ViztOTkYXL2H5zkQD/1twDCmvlMDnn+9Dd+C9xbcVYAk0hqr5yJspHavKbMlUSHhDvSnn2uupw99g+7hedw431r5d24XYb5lwmi7McYRU5bbJu6BJrcJ39R24+LKS//PHgWVmVnKTnPLWKCD1a8rTJIgWejZFDIzdpHTfVzDkIex8R5/HlOtf+rewzhSz/Aa3Txh6awsjRIZNo+vyK1q8pGemYjlh2+bww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 27, 2026 at 12:16:32PM +0100, Lorenzo Stoakes (ARM) wrote:
> So actually you're increasing by a cacheline and increasing the VMA size by
> 64 bytes, i.e. 1/3, which is unacceptable obviously.
>
> Maybe there's something that can be done with:
>
> 		/* forced alignments: 1 */
>
> Perhaps? But that looks potentially ugly.
>

I say elsewhere (or think I do) but to highlight - I think probably we could fix
this by putting the flags in the low bits of vm_uffd_state.ctx?

--
Cheers, Lorenzo

