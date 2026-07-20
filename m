Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD702C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 17:40:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D706B008A; Mon, 20 Jul 2026 13:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A75C6B0093; Mon, 20 Jul 2026 13:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46F1E6B0096; Mon, 20 Jul 2026 13:40:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A3A16B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:40:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5C279140239
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:40:46 +0000 (UTC)
X-FDA: 85009870092.08.52E9CB1
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7498FA0008
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:40:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ejRkfweg;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784569244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=STnxksxeYU5ANSzKJlg5+nS1izTc7aC2ZhhV2DsN+ME=;
	b=nVUbF7u0zirXnKuiHWVWlJJALNendknv/OY0Bg1NkAHnZpUunufwsuBBY2yraydgfMwnoo
	UDpxCGqkVj5E9rICruOzVKGqAyxI1woh0KQLMJ2KiQ0crI3B6xMlt/fHPce4Sj1GUyB/uj
	rqDmOfwxZ34ySQaCs5YNGrUKPmzi8IE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ejRkfweg;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784569244;
	b=rhWxZdA4ghACr63rIKNWru+AnlXn/ytYay0rcx2nzpKthTi1T67W8Dxj63CLjKIl1eR43Z
	OWnzLJDWAyLUG2+xmpcG58fVwI5NbtbVzPqeKKUjqsS+aYMCdOZ6x9Y7sMU+mfkTPmseQb
	uatxhbP3lbTSdtXINmDiHR5dh85zxPE=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8efef6533aaso71473556d6.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784569243; x=1785174043; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=STnxksxeYU5ANSzKJlg5+nS1izTc7aC2ZhhV2DsN+ME=;
        b=ejRkfwegsRg00kz6DvuSCByKhbkAlE9exGkRovEA3H5SOjFv/6DC2OSzWk/SOpEWQ6
         pRQzh4xw3ct0mmdlbridMJhbQxNnQejpKGyv5ny7mOKjjCpdiGjW8/z/COW/j03OHyjz
         Rg2h3lJTt60rpCQYWkJUADanTnQRG5iQGuBMkaf55kc5ejje2wCh6L0Kw3jbQX96F9VO
         2FO+F9JyGlzzu+isT2VpZWQ8BOOPHYNPwJ/p0REmmBNtaPM2g6PNJ1UCYwInAHcPpsuv
         FUAC4KbnoRj1/fU09mWNd11ekOWvi6beCGtOiaRlA2ixmeh9FLnBHKmBf/Fzwl5lP8MW
         YYOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784569243; x=1785174043;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=STnxksxeYU5ANSzKJlg5+nS1izTc7aC2ZhhV2DsN+ME=;
        b=ABqY6abkyewnBd1ZZDtkLXHBr4OSOiVoVJSx3S23aLlsCsgvW6dBE/4E9lZkYkhr5R
         3JMBHWU8ja2ROotXrffeW5JHBrxuq/I/aDwzrhNsAC+0t4l21Vd+FiIPErbYCXlZhCGp
         Z9RaY8z7/qFCOut/ymCyB59DlqzK4cQ4sIAuxQuBygnJm06H8VCC5Jcn3WIS+xB1DppK
         vPH9gp4QpMvUgeTh3aK6qTyrFh0JBO2WtQNyfC9WcWXLw+osnURP7+6727rWp+jSBIFn
         4Cxig3VylsVxc+/5oTVrV6v/6LmSx5zjNh9n9KfWNxDEyzBQ7jSL6S06u3qS7bxIuQ63
         oroQ==
X-Forwarded-Encrypted: i=1; AHgh+RpzMMFpxhqOzdaE30rcFH1n4i+gV3MQODWctBUlAwf4QYZNkYVpLZV9rPXNJB3gZY8tfYQKbu5XCA==@kvack.org
X-Gm-Message-State: AOJu0Ywj+OwYDhU0rqqjhSR4RH1g03o4nWQ7AuG5IkJJSedF3pw3PmZT
	ZP2v9MS79eyLrSXOYlb0JqILEYahkR5pI3XOwH4qwgk//QX6SgHT9QHkgEM5lM5ys0E=
X-Gm-Gg: AR+sD11bkIL4tOEFPMNdyRFr3sXQAnbRDAN68lv9ih7gXCMDYWL5CUU9QvqW69Pm3QF
	CjOCAukp4hq7pKYqWX2a51qpo0LBzzSOlrUe3xOQV09dli8WPqs/KSCUC0JMmKQX0YYENaKcaCB
	5XcqnRQI4V7ZER3Y/WFVMq0ZOCc9wzgkQz0Ft21oPx5Vz8+9oqoX4pHFt4aR7WhaBk8Ss5XXElA
	zUc71qntdmCtaaYd4R7dZsnqX/CVWKWbB1P4fJfEYKGGRcAO9ZFfACnZCGupchhprtcwrKAWLtp
	0VlwSH8uycxhBrO45g/zi5YY6eujx4e7qH3NmCvsEW+w2r3EKgl0v5u5qSxEkpH/bR/PhIXNAkk
	L90Xo+OE+ZNjRZJO4vbCoP58Zmb81MxKX+aA20i01Dz1MJBGI09XwJ2klF+F/O9nMhFdFc/GjZO
	L41aqP3bxctilso7+HSo+0JvlB+Mk0NQmlEXXO3ZB3BplbDU7DNjId0eKsgw==
X-Received: by 2002:a05:6214:54c8:b0:8e9:f62b:8f93 with SMTP id 6a1803df08f44-9077853b82amr163551916d6.57.1784569243441;
        Mon, 20 Jul 2026 10:40:43 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907786ed2e2sm95014956d6.33.2026.07.20.10.40.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 10:40:42 -0700 (PDT)
Date: Mon, 20 Jul 2026 13:40:37 -0400
From: Gregory Price <gourry@gourry.net>
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Brendan Jackman <jackmanb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Jan Kara <jack@suse.cz>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Byungchul Park <byungchul@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Will Deacon <will@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, Thomas Gleixner <tglx@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>, 
	Olga Kornievskaia <okorniev@redhat.com>, Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	iommu@lists.linux.dev, loongarch@lists.linux.dev, linux-nfs@vger.kernel.org, 
	netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] mm: move internal mempolicy APIs to new internal
 header
Message-ID: <al5cqn34Xq19f5HG@gourry-fedora-PF4VCD3F>
References: <20260716-folio-alloc-cleanups-v1-0-5363b8e92d33@google.com>
 <20260716-folio-alloc-cleanups-v1-1-5363b8e92d33@google.com>
 <alkLSzQvzT9zJbY1@casper.infradead.org>
 <DK05KUIDJVLZ.61UIWOL0K3OT@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DK05KUIDJVLZ.61UIWOL0K3OT@linux.dev>
X-Rspamd-Queue-Id: 7498FA0008
X-Rspam-User: 
X-Stat-Signature: 8g94rfcwe617h535dho7181yjwtkp7ag
X-Rspamd-Server: rspam04
X-HE-Tag: 1784569244-898760
X-HE-Meta: U2FsdGVkX19xUDFblHzzOYYGNC8u+BPIlhCl0H9xsaqmplSsIo78JL9HwEZ+ZXpG6CUNiut0LYwiJpfLIvDZkK4LRrNEp2t3f+pXAF/Fc3C7bf0bwEwGSSygBrp/7yjuLqppaL07k3JAV8maz2ldBeqyrqXBteJVirXgJd4tpo7Z+Vxvp5pAUAYqg6EqgbUTKAAbvjqfJ0FlG/crLxAmkTX9mb+WHc6ddQZ9IVhcLNHSYXRGoE8aeWZEV+bd6ixjJbqqqx6+Fs4La2lA8/eieE27nVntBBBDMBo4LzwLh3RiuQzTu0jg6EWto1KCE94iEgYzmrxaYfjlcv0cJqKfYL4P0F4CYw+0xE0Pcx4/mGX0eD7Bp1r8FGLguws5OjcG26ag1FhDg1EKm6cc6gAaf6DDxAZPdSWXGWacbnRlvLuVbrutd1R5BipLPNTUYGjEkhLyZcHWUKkG3XRj333NPB8wNULKxeSNJhH1uYsxZj5+yp7PtVTM6pehYNLp4rbUQolx49cYlENRf//MzdFv47AJtsG0+8cKy32npRid1pcsAKZS9BEI0Vd50wVGlXy9IB8XXJZgSr8RHBfHXfACC52wVxCm4uvHDqQpcoOe4MFCKnKKyQnd4NJ+0RcAPYGwxd61yKlP/iC0Xow2ZM55FetgTB62/SCujFyEsi0Tppgp0o+748ELsOjXEZcJd8xg0v1E7uRJnkaQ2lgvogTL6LZkYFmef8vhPMd4If6/I/ycirZR9ITBQnhTpfpDGwvlZcYFfKWT6iqb2LJnCGfttRKxmRuRScbfAPlO8Ag9WkWmpUSCIAmb4Nz6M82vFtVAK+uvd3LR8HLc/68PSNJXjx597u0qvnMoD39xzR4YDB+zy4fwNWNEPHgScpM564hYaApKazFTliyHtk8NKokmkUyw4dEz5Mfu+8nMTVRwjMk0HE5frm79XXz7DPVTO1ubnssLSsNwV5/37EpYFZu
 Fm2Kkjyw
 i+8SHKDQb/RnByQ5FmqgZpJftqmLOiaWdznZRu3H48CIAwqJGVQp4fWTpUBZAhCr2lfsUF/Xk5ySlaGHOtYllBqd5IDGOSuHbVlO1iAZBMzu7/1WOLid4A3xNIjibW1+osGpRWHru90+FacCjf8jPbEz63V8CO15N6Y/bn4ZhY0O9v64Ucltl34rPojnbsQqn26tJzR91fwiUCqMWE6AxVNblPlLxBGOUEaFvAnf9ILj8Y+K3Mfi6OEFd26SL8ncejz04BdtF01InxOTlms6q08+P/wAQZgGs9HkB1DDZeYQUyk8/nu+L+JD4oE7ptsFMy25W62SF0cw5erbwpBfWCsI7rtwTwJvUAbpFyzodg3kaqmrbY8ojpwBTWdxIdctnU1SvedTaKM2CDWWKxwR66eIy9qr5UnbdBYbN4GZwL8+NBexMz2Vj/a6b6+gMR9zIwgBnnEGJpksufotYTLKK6maeYZsf2xI/Bww07gibMX81OSAbUYCtr+r7AA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 04:57:37PM +0000, Brendan Jackman wrote:
> On Thu Jul 16, 2026 at 4:48 PM UTC, Matthew Wilcox wrote:
> > On Thu, Jul 16, 2026 at 02:30:10PM +0000, Brendan Jackman wrote:
> >> There are no external users for this surface, reduce the scope.
> >> -struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
> >> -		struct mempolicy *mpol, pgoff_t ilx, int nid);
> >
> > Hm.  So what we're saying is that allocations which respect mempolicy are
> > only for core mm and not for, eg, device drivers to do.  Is that really
> > what we want to say?  I don't think so, because that's inconsistent
> > with having just widened __filemap_get_folio_mpol to allow guest_memfd
> > to specify a mempolicy.
> 
> Yeah I agree, mempolicy definitely seems like a "public concept".  All
> I'm saying here is this specific function doesn't have any external
> users so it doesn't need to be an external header. 
> 
> ... With the ulterior motive that I want to add a new parameter to it
> that actually _is_ mm-internal. Namely, alloc_flags, so I can add
> ALLOC_UNMAPPED to implement AS_NO_DIRECT_MAP, i.e. the next iteration of
> [0]. So basically this is
> about trying to extend the allocator without creating a GFP flag.
> 
> So I'm envisaging if an external user arises for it later, we'd slap two
> underscores on the beginning of the internal one, (with the alloc_flags
> arg), and then bring back the public one as a wrapper.
> 
> Does that make sense?
> 
> [0]: https://lore.kernel.org/all/20260410151746.61150-1-kalyazin@amazon.com/
> 

fwiw i've been fiddling with a module side mempolicy interface for a bit
to allow a clean guest_memfd() + mempolicy() interaction [0][1].

I saw this and thought "maybe, maybe not entirely".

there is definitely some oddities in the mempolicy uapi (internal-only
flags that are exposed to the uapi is odd) that some of the interface is
worth internalizing.

(fyi i've converted my private node work on top of the alloc_flags
 addition + new zonelists, new rfc is being posted today, your recent
 merges were timely).

~Gregory

[0] https://github.com/gourryinverse/linux/commit/b25bb27602fe512733450a97ac31ef4387b7e727
[1] https://github.com/gourryinverse/linux/commit/670f7dd81ef33a9385985a54b8ad6bc070b2d581

