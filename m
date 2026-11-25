Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA95606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:33:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ILwnqsTJ
Received: by kanga.kvack.org (Postfix)
	id 1ADFA6B0A4E; Wed, 25 Nov 2026 10:33:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15F276B0A4F; Wed, 25 Nov 2026 10:33:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0744D6B0A50; Wed, 25 Nov 2026 10:33:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D056E6B0A4E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:33:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6900BA8A18
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:33:02 +0000 (UTC)
X-FDA: 85474034604.05.33DB881
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A719740008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:33:00 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ILwnqsTJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795620780;
	b=rGqtuGRPzTLjJDYzAfGAvGGssHwo/DMOQODTNqI53MJhPtg0lgen9lHye4HnF9bo+bVK32
	ijt64K9kD7jEhpz1JMseOf9n1w7lj1/czAUVc4t38wxm9a8G87v8ry965crvLwwEb4RFOu
	nBq0PHTC2x8GvImFyn82PIQFJxrU4nA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795620780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9ziKV8LpwywZ6keY4HAU4E3v0yjAaX5+ig0pbD9Vik=;
	b=d8FGxiypevomgDPQrqu7IIEac+TvkZ4gzey5y2Kp3BprOcWgSVb2xakb01D0VYSDJfi8+s
	5PIuopNWKPgPpJ3q4wcASel2dsKm/w0jJ4z4d/DUb7oAN9FgjR6EuZZahWpVYEGyjdYWTT
	0A0n2qvY+WxkBW/HC/8p8i1rYRY3HK0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ILwnqsTJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 999114461B;
	Wed, 25 Nov 2026 15:32:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C791F000C4;
	Wed, 25 Nov 2026 15:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795620779;
	bh=P9ziKV8LpwywZ6keY4HAU4E3v0yjAaX5+ig0pbD9Vik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ILwnqsTJoTAX2y6yreyBSv7Ug5yv859gbc5ivHDIVIiyndf4xWNa3m/VfGPI0DL99
	 6gFkrWdGw5l67ojlhP1I0mG6HuDXK7MYpGaXJ4/mhpgBzqcv9csTA63EjjPcJYp7VM
	 zd1bRMFUPXTBVD4WIF+ATgxG7wh6LebcmSAsIaw7wIlmAtpj0YB86daZiYYipg/xOf
	 9k3BQCDgFcoAvRsp1wiODXhIQ4a8wYfGFQB7msaKHKnYHfUnHEnKBdj4iMKDrRzyOG
	 ST7+BxK9KYa8YfKIMqlD1LZN6QfEoeOny+w0NBKTzGb5Z0EJ3B73Dp7xyuJ87OVw3t
	 IB5NC0uG0pr8g==
Date: Wed, 25 Nov 2026 15:32:57 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrea Righi <arighi@nvidia.com>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Quan Liu <qualiu@nvidia.com>, Lee Trager <ltrager@nvidia.com>, 
	Seth Forshee <sforshee@nvidia.com>, Gregory Price <gourry@gourry.net>, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, Hao Li <hao.li@linux.dev>
Subject: Re: [PATCH] pipe: Prefer mempolicy node for metadata allocations
Message-ID: <awb8v4sLglHQyHQ2@thinkstation>
References: <20261110065219.894219-1-arighi@nvidia.com>
 <hbkxlhc5y2jkvuov5o2kjgpisx2pavuo3ad4c4ydixeic7vaq6@mpzzfmhjvtof>
 <avQP1aXhe7nQuzt9@gpd4>
 <3f761a27-74df-4e19-878b-323164da5a69@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f761a27-74df-4e19-878b-323164da5a69@kernel.org>
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A719740008
X-Stat-Signature: 1rpysk1p36aofiqrxm9kkjde7or3uj7f
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795620780-928327
X-HE-Meta: U2FsdGVkX18XlTF4r4KpOJe8dt/P5dwUJBIuiZPkrXXCCvOm92Qijxu3OiFyyHLz45bbU4X0h/KylYCUeoXcZAFap2oV/uiD6I01NV/QxhYMPWoJUvthB5eTpO2HHvjxFlmFEuGHPwnYH7cjfdDOXUFLtPUiVz+Q0gZNhjydL89PWeL38X6lmrW1VIaZvVV4AQLcQ+nFttLeMlUUqd32hCdxoo9nn5tg2MfBfSW1w2g2RWCFYHf20/ldcHQf9oEXX64dwUz7Jc/wM3+sSVRC3PKvn5/0DYjRJbMHYvJpHRQT9R1vNzXT3nV2b4OdLWQm0/chJSCcg6P1mmOCE0hss5f6Lg2rMbnkAZIj0ogWYB366oyoVS0fxm61TjuKECRh4Ty4edMc05x9qlw/S/16mHcgJkBfbXO5slvlfiNhs+iXhcKykGAEsdrZK8HPo3MBX94GDG0bKb12XfubOLoS4M/NKf1iAxxy+0Rc1veBVhc5BMIGlmMI3w8BuFoLhbRI3MsmR2Op898Hd5M58JgrGFmfIG3jWmiJtLPz9XpvCBE7zYA4uMThVp+Bxw8eP7WX9D3aITsjCAhzYaKXvXu0TUXqq/lSESohoH9eSunmk+VeVGbCaUPd6aJdtkaT1pANj+1rjXpSfNDUuGDGwn9+YxzaguXJMXTRlfql3ebNeVnm5MrO5nzYnQdyu37SYxEQGoR9CKrNGTXfGyw1t+KTwURMKxcXSqHW7hvpbWYokWPseXRzvVuBDu2l5TuLWdDoTMJC8rZAtdcskdN+GEHWR318K2zY+te/44qTjzE3Ht7WQDZ7vRLUpKkiTEkFtp70uq/iALPHIM1d+sc/4jmDZFtE5Nb6c299GgKXJ290S5VAjtzDsKxQKjbtZio8CKbSNnvyroocX0JK9SPKsMjF7XuQ1h8QH3XJc88TuQ2NUnehkK6UK/NsZKkSy9hs/72ZV2n9p3+UtijTtmKAp8m
 4nLxEEgf
 lbkhIhHg4x+B6ymsWZIIdQs1HXavXDzXH2OtsRxr4nTCi0HEsSctNhPLSt1Vp9K9/GffSzqt5xPZirgfNh+28Hx9fSAQSnYLPkATFX2it6Krg6vzTRV0IHTwdDD0SV4Xdv9m0I00+qOQhDoXdSXXbcre2FEQtgLw21vuQShbQfcRV57p1ey8JPOt/SkpaJPPG5S/4GKCoTyVBXQ+t9ydt03NC3MxHy7ajY2T8wAhjP7nyylXxzns4BGKcNE4Ant1X0fuf/2hyjOqFhKlkrn5xT6ccvWWyBrtp2eT//bMLG2MAKiJejRKHmZYR/GSWy85wapcRCg/0rupAtKv8GEvsclETGwBqidiTVTdXiH05nZzJ0LbaXXwFGyWG2fcP+AmTLlQFPKjJqxjmmFHiYhHWsPvm0hOiL0A/AUrvgpp7rLpCKqJG86xB2GIRbU9p4pr7VCIqRcJb9811KT480MHH04uGHhid0W/sPJY2PF/kpoaFWEX0vGj+qx6ny1Da2UyyxED4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 09:12:44AM +0100, Vlastimil Babka (SUSE) wrote:
> On 11/11/26 07:48, Andrea Righi wrote:
> > Hi Jan,
> > 
> > On Tue, Nov 10, 2026 at 01:27:53PM +0100, Jan Kara wrote:
> >> On Tue 10-11-26 07:52:19, Andrea Righi wrote:
> >> > Generic slab allocations can reuse partial slabs from another NUMA node,
> >> > even when a pipe workload is bound to one node. Pipe metadata is shared
> >> > between senders and receivers and accessed throughout the pipe lifetime.
> >> > Reusing remote metadata can therefore make an IPC workload pay remote
> >> > access and coherence costs on every exchange.
> >> > 
> >> > The target use case is a workload that binds its workers and memory to
> >> > one NUMA node with numactl. The policy node is then a useful placement
> >> > hint for shared pipe metadata.
> >> > 
> >> > Allocate pipe_inode_info and its descriptor array on the node selected
> >> > by the caller's memory policy. Apply the same preference when replacing
> >> > slab-sized descriptor arrays during ring resizing. An explicit node lets
> >> > SLUB try local allocations before reusing remote partial slabs.
> >> > 
> >> > For descriptor arrays larger than KMALLOC_MAX_CACHE_SIZE, pass
> >> > NUMA_NO_NODE to keep the policy-aware page allocation path. An explicit
> >> > node would otherwise lose the MPOL_BIND nodemask on fallback. Select the
> >> > policy node only for slab-sized arrays, avoiding an extra advance of an
> >> > interleave policy for large allocations.
> >> > 
> >> > Moving a pipe's users to another node doesn't migrate its existing
> >> > metadata, so migration can still result in remote accesses regardless of
> >> > this change. Generic allocations may reuse remote partial slabs, making
> >> > initial placement dependent on allocator state. In contrast, preferring
> >> > the policy node leverages the workload's placement hint to improve
> >> > locality when users remain on the intended node.
> >> > 
> >> > Testing has been performed on a dual-socket NVIDIA Vera system, covering
> >> > hackbench, pipe transfers, pipe creation and resizing, pipe_bench, and
> >> > targeted stress tests.
> >> > 
> >> > The primary hackbench reproducer is:
> >> > 
> >> >   $ numactl --physcpubind=0-87 --membind=0 \
> >> >       hackbench -P -p -g 10 -f 20 -s 100 -l 100000
> >> > 
> >> > Results (over 10 measured runs per case):
> >> > 
> >> >               avg       stdev
> >> >    before     9.811s    0.130s
> >> >    after      5.770s    0.058s
> >> > 
> >> > Before this change, allocations could reuse remote pipe metadata. With
> >> > this change, both pipe objects and descriptor arrays are allocated on
> >> > the requested node, improving locality and reducing hackbench runtime by
> >> > approximately 41%.
> >> > 
> >> > Reported-by: Quan Liu <qualiu@nvidia.com>
> >> > Signed-off-by: Andrea Righi <arighi@nvidia.com>
> >> 
> >> To me this makes sense so feel free to add:
> >> 
> >> Acked-by: Jan Kara <jack@suse.cz>
> >> 
> >> But IMHO it deserves a look from MM guys since this is more of an MM thing
> >> than a filesystem one... Added to CC.
> > 
> > Thanks for taking a look, and good point about getting MM feedback.
> > 
> > Vlastimil, Gregory, do you think this SLUB locality and mempolicy
> > aspects makes sense here? In particular, does preferring the policy node
> > for slab-sized pipe metadata, while retaining the policy-aware path for
> > larger arrays, look reasonable?
> 
> It's not wrong, but feels a bit ad-hoc. If it's pipe metadata now, what's next?

Good point.

> Slab will generally return objects from the cpu's local node even if it's
> not specified. It's not guaranteed, but it's not guaranteed also when it's
> specified by kmalloc_node() (unless __GFP_THISNODE forces it).
> 
> So the results above are surprising to me. Are they on recent kernels? Are
> cpus 0-87 all local to node 0, or is membind 0 there to force a node that's
> not local to some of them? If they are all local, I would expect the objects
> to be from node 0 even without kmalloc_node(). So maybe we have some unknown
> deficiency that should be investigated.

This is the default behaviour of remote_node_defrag_ratio = 1000.
When there's no slabs left on the local node, most likely it grabs
objects from remote node before allocating slabs from the local node.

This means quite some of allocations would have to be served from the
remote nodes before the slab memory on the local node grows.

-- 
Cheers,
Harry / Hyeonggon

