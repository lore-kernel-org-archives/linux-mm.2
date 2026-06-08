Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D494CD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 17:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A02D6B0005; Mon,  8 Jun 2026 13:51:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 876C86B0088; Mon,  8 Jun 2026 13:51:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B3716B008A; Mon,  8 Jun 2026 13:51:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A46B6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 13:51:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 189421638DB
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:51:02 +0000 (UTC)
X-FDA: 84857486364.29.76744E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7534180018
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:51:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FqXdrUY7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780941060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aHDkkZM0LDnjg910cSwEzql9JdvUeeXv0ZHTIK7GDLE=;
	b=xEtJf6GmmR4WQxTA28cpb0eTM0s4BKiBZ0rhhKNs5rCQVJgPA+CWYK+TlPLH3+VgA4cKxB
	gKKbBUYCBgGoJHscqu4c2ZtEmnFIc6z2CWOne7odqPOtczKoFqqtYuMeHPraaDTGpyrDK5
	XoTYvPHU7epLoKbQCoD0BkK4+CqRXZs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FqXdrUY7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780941060;
	b=SfMWQ5NfEy2SrFP7yxQoym80z4P30HL/aBLfts1RZsybtVzHcOMPVN82n6IeHOOvLFSYNi
	XELnrZRyBgQhEjjCQ7PVr2HanOripLL/ABSv4NRLV0THWVdoSqS3JDC2gq2LUHPkxrT2d6
	KEGLWlm7ZysfsORhbyDznn0rXST5+2Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6C1E60098;
	Mon,  8 Jun 2026 17:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D24281F00893;
	Mon,  8 Jun 2026 17:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780941059;
	bh=aHDkkZM0LDnjg910cSwEzql9JdvUeeXv0ZHTIK7GDLE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FqXdrUY7MnZgXjGyS34UzEp+k9mBFwy1XPyfvBzqH9M5+Rrj97WZggA524whLavtU
	 fex1sh7aoVw9IMLuHbqG0bK53P45PgKGPHUWWGnuSTW9bgc0GPSFWZWjJ5vXQvYnm6
	 jK3z3oPOO/9d8708nmY88nJxhryP72whFMVt1KqHlIeWHOf9gOvgtu09nP9cF9fTIK
	 NZvYXB/YeKY2j/gbsgK46F08vVHhDMqb/hdaRrs1gnoNECKz8Y7N866XxI2YSKkbTY
	 G82BRdrb2Nid29WdnkhJpE0VI5yr5LASvGW6ohHaH4bsJi3Jr2Wv2m4U+XIdkZsAwh
	 GkNZa8J2v58QQ==
Date: Mon, 8 Jun 2026 18:50:46 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	"Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	virtualization@lists.linux.dev, linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 00/37] mm/virtio: skip redundant zeroing of
 host-zeroed pages
Message-ID: <aib9QIGIn8f4W6RM@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <8d5d2fa3-a60c-4d04-b3bf-7a8fe89cb1a0@kernel.org>
 <e54f9b79-b6b4-4911-86ac-48b61889765a@kernel.org>
 <aibjjsoeEcvXobCw@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aibjjsoeEcvXobCw@gourry-fedora-PF4VCD3F>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7534180018
X-Stat-Signature: oqukwbmue4wuz4yyyatkj893gpopht7c
X-Rspam-User: 
X-HE-Tag: 1780941060-583238
X-HE-Meta: U2FsdGVkX194ZI7H7XqbJybk8ktALDP4qRL8lP/fH9cUS7/8DVrWDmpYi2r3GrcBboEEvsOpY6v8uA+Hx8zZMQ6Eqb/5wA9GGNkZXmSB83KjhaBBpSTJhY1Llf9uwx+iHKFXcr08RAfyZYY3n12H54tGFJyRy1d0pn42Rn/pYHNCdnPY5tEV946qLCxJb/Baedm4Ndn2LCB7eivu9y1BTxm3x11xF1b6DE7saTnfq4KsejO6+Opem3fCfNulagHgNotuG5fWBVLbEt2SaO67yknbPuMv18zMcIWgfIQCkOpZNQPbFc+g38Zq2hvS1VlricnqPybiJnJix5umv1CpmOOPIQaCQ3Ezhv4PM8BkyzHUL4OrBWfmqNephvuZdDNq2Z8FPW09MkFFuhFAMhnh7R53UOxoWIqf1fIocuPSSCmDH3tFUmsrMff87alnGTz7eLQvLJkPGslyCnhF+BwQogf2PvWpd2Tgq5SW65PmAupPZPQwAP4V2PbNSomhOiJi3Q4sK8n+0r1Adal+NKVHeJVzBCv3RVaZ8fZL30InUWMQNzGm/JblYI5T/n6u1VHCtXg54VtOwJPprzuLPNA1coGRjUD88yRv8SnsY76+hJCDIS0makgn85MnFhsAe+O2Yw5TnK3eKkO6/BlADEC+9Ws90xR47rRetYhfG1lgJqjZUCD8qQ922bbzbKEwjY3X3KFEcXn3/VXqXpNg6d28Q9DQTjBdFdmqNUJlAX/uz+oZuNtD9R9x6mX0h11mZhzIE62NCs8bhn8ktiKPXV/JkHa6AJ5QIOhNfceoi5DllsFcqZNBVIYJ3cZPCUReaKB+d0cuCEkRAZJzv+s/zzjEcUTkIrnmBOjceHLqOI1YuAnrfe1ThuXPime2PA9pIO9lxRWXR/K4PuhBFezn0PuCt13+J/XbpmxdKNsPUeYlAFPbO5x6Ye/XxmTvcoen1NT6AUrUDcUzlHYXe8ZmWs1
 Lnptt3KL
 mFeio4Z5xi5iMeH5CeRP80orA7bWumfT4rVvb0u4FT6W3vU4VSW0QSg5HbIvP29/k8n9lRdcJW41dvi8Fzuk0j5AceIsjjhszwr/p4vSyrPQDdop0OWVUrkdU+nt9ligW1+jrXgRLQLnD3xUZ0onpC9JgppIZqw2ZiTpGRx4aaWGkL/NQYQWA8pnfxRkkkHeS87Yv+X7CR9c7/VUU6I6Dv8JvT+w0kidJIxUo4YVRLH7EYdDtLMiF3Z9ncRRPCsFy5emUKITzIZyU0n6HRchGZeENkUr6flGW/hMZZRihbOMqrWtM6OOv947SakRh62DeAJMbHVUfGr/k4VA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 11:45:18AM -0400, Gregory Price wrote:
> On Mon, Jun 08, 2026 at 01:13:42PM +0200, Vlastimil Babka (SUSE) wrote:
> > On 6/8/26 13:02, Vlastimil Babka (SUSE) wrote:
> > > On 6/8/26 10:33, Michael S. Tsirkin wrote:
> > >> Further, on architectures with aliasing caches, upstream with init_on_alloc
> > >
> > > It seems those are niche architectures so we can ignore that part for perf
> > > purposes; the other reason why user_alloc_needs_zeroing() would be true is
> > > booting with init_on_alloc.
> >
> > OK I misread how user_alloc_needs_zeroing() works wrt init_on_alloc, as it's
> > negated. But you're changing that anyway to skip that user zeroing, right?
> >
> > "
> > This series eliminates that double-zeroing by moving the zeroing
> > into the post_alloc_hook + propagating the "host
> > already zeroed this page" information through the buddy allocator.
> > "
> >
> > So relying on "everything in buddy is zeroed" would still work I'd think.
> >
>
> This regresses for anything that previously didn't zero on free or
> alloc, which is most kernel allocations.
>
> I think the scope of this set has increased too much based on early
> feedback to fix the userland-initiated allocations piece along with the
> balloon/reporting/double-zero piece.  That's making all of this
> difficult to continue following.

Yeah I feel this is 3, 4 or 5 series put together, and there's a lot to
discuss in each :) so it's pretty difficult to work with them all put
together.

These need to be deferred/separated.

>
> ~Gregory

Thanks, Lorenzo

