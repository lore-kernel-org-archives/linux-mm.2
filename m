Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6309BFD5F63
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 03:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53E556B0088; Tue,  7 Apr 2026 23:52:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C79F6B0089; Tue,  7 Apr 2026 23:52:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 395496B008A; Tue,  7 Apr 2026 23:52:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 255CC6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 23:52:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6A75160A02
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:52:31 +0000 (UTC)
X-FDA: 84634016502.06.A15FC6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 19B6840007
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:52:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gIVenmFH;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775620350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Gvnb8r6Snlkhz+vo6KVAfT1gf85YiijAJE2uZ7mznw=;
	b=KH6y9xtMPgpE+SLDSycqG3sbuL2HcqiaSY7aoXUWO3HSj26l64RZxif0S2+VCcXomKhdmE
	6LgPFfJyPjUqTaqL2nm5qmPqPZUxG8Yag0k12RkeLSdKYap7Qp8mc8uPDFXj1duM2L6Zcq
	XwDkYxbY9G4hakd9uPC2pronzNeTo7Q=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gIVenmFH;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775620350; a=rsa-sha256;
	cv=none;
	b=2dhmeW6WjHgC40QJsA6uGI7cJgYIPeZpy3T1iQLTJAXwnsfWg3WSKW/MMEUTHScRmQ+ahc
	ry3qajGYOYypkGs+Lp1+3aM7OlHnnT77DFDcs9vX5m00xoT8D3E73HUtzlKttc8eJLr+tW
	GI6R8h+zOcoYiXyI9ZOt+mdoJ5p0kS8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DAAD943AB7;
	Wed,  8 Apr 2026 03:52:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9A9C19424;
	Wed,  8 Apr 2026 03:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775620348;
	bh=wtmhbiDxrGbIO8cQPRouIzl/0p6VLYybidjJS0vemHg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gIVenmFHF231TQyCG+S1zN/DVz5Qv5vX0FXXoppNS4GbF2zCh8za2hYE7PtBg3p7n
	 zTaOWiLDpm4N/FOhfci1iJmw6yT1Uk35vaKfhcGHQNa5WQkCP2DrbVqVtMc/8V3V/A
	 hVCU9Qk9Sd7AHapaz5WD9osrVraJ3ABpnFgii4PmuG72z8zL0ayPbXNINB1loDxlLH
	 ZFV4sEYKodCdeUbcql1tp+xfp15veo0jf4/gYf64xTrIiG0AfhYZ2llALVmJkneV6s
	 1QappZXXU915bmvYx1Di/vz1QTu6zUFZn34GCBKikV6Wx7Ksyle+9C+KkOibhXe4nM
	 XB1w1508ztSmQ==
Date: Wed, 8 Apr 2026 12:52:26 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/percpu, memcontrol: Per-memcg-lruvec percpu
 accounting
Message-ID: <adXQ-uqvQtqr02pu@hyeyoo>
References: <adXAG52R6WVHd0n9@hyeyoo>
 <20260408034025.3317937-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260408034025.3317937-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 19B6840007
X-Stat-Signature: ya9b4etdytzx53et45omn8xcab8thdrn
X-Rspamd-Server: rspam06
X-HE-Tag: 1775620349-240912
X-HE-Meta: U2FsdGVkX1/VnArNWHthgJeDFVLcsd3GCrzpk9bO7mCtN8yvuXTnmQn5ApAnscv5xK2t7RRujLcfM4utsqcOZDnmP6chiy1YKboyMNwQv84CPLhQTcLS9iWNqAtlo8c8SImwvtbNIkK6RDlz2ViwgX34WCOyLKFYJXnCjdSL0IJoprcEIEv1J0Z1czGUQHFGStuQNbK4UpwLfD1lG3u55BiEyzVC1SmUZonOg13jeurVtVVBkhxpLlonMalTNZE9zjT+lQTg10JxHCOK6AlU8z4yL1T3Df6Efqhm4IJxIvLaUMjNDdFtB8nfnmpbm6sG2UVVHJvymyJvVG4oYNQnh71J6P8WuQf/skxr0+LStmD8XT/RKN3Co3B3CboyN5uQ4MiIec1jqVTv0UbbfJ3BB2owkZ+n3C7HoKzraiTThFuIeRlErQjSkNKRHgIeYWLIv6DUWMK8F6gR+qx88px/H1kgOw+BucO5wY621amRPDiSVDAyjMlG+XKcmgtD3UimgW8BBakUHomMbMszBYxjXj+YhR07iAuuV1hITv41E57z7uXdb0fzsHdbr8iAFuHBmf5ppmDjdsaP5fMAVLtceNirz3L21XdOPjk3hinvvpIv/IdLwp8l8T5rMdbf0VQgktume/5WuESRzOPXw9taJMjlDLLun8zgDbFQZrGQjeqbfhAURMbnQuMarG7DcbDJebYx20LGAw5aXCGb1ggQ40edQVUzEZpR24+iV90SzoJ9q5kLiykHQhhLxjECBrYyY9aKuykbiCSBQykDn1sBtIroxDDxVeOdltTIfAZDTfs/ocnxav/HZsS50f1NBITW7Tg+e/uNhiFmbycmHqioIBJpR5JEfxpAL7e9+AccegsCmvY8ZecAEFELC7k4mqChSKugScP9sW5taVVsKswMceVAUh3YOFTt/r4ofIFCkMXPyRC9AErNXGbSrX5VFrmWcjVCXAJU/usCC/9wIvz
 +vXwrV0N
 T3CCSiNMW3LKES2jBcpTRT+hpd4fmYclKygUDiNb1rUjpa3e1UnWzsGDcPryYhMeXzQ078yr6oMsnPhJeIX0vBzhZeolJf2pWUrzMtsvo1dQi0PpjRQ3nxTsCuXyt7myrW4kGT2UrbYShQj+gqpZ4XRY05CggA4qA0XhElg5DH0FTRQqvJSbWhoqikXVOfoedBFaQlKJztLuyJVGl3jTTd384+08olSk2iP8bFea+afU8aJwbZEoiaiubqOan+yr4ecZ4NUiOeZBXqUSjJKJshCOlXNP+tFxVVN11e9RpM1DyxjZRMUB5QVf7HqwQCMjp7fMenJ0migNbGY/gLlJNPJJnMtHwhI2N5IJf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 08:40:24PM -0700, Joshua Hahn wrote:
> On Wed, 8 Apr 2026 11:40:27 +0900 "Harry Yoo (Oracle)" <harry@kernel.org> wrote:
> > On Fri, Apr 03, 2026 at 08:38:43PM -0700, Joshua Hahn wrote:
> > > diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
> > > index 4f5937090590d..e36b639f521dd 100644
> > > --- a/mm/percpu-vm.c
> > > +++ b/mm/percpu-vm.c
> > > @@ -65,6 +66,10 @@ static void pcpu_free_pages(struct pcpu_chunk *chunk,
> > >  				__free_page(page);
> > >  		}
> > >  	}
> > > +
> > > +	for_each_node(nid)
> > > +		mod_node_page_state(NODE_DATA(nid), NR_PERCPU_B,
> > > +				-1L * nr_pages * nr_cpus_node(nid) * PAGE_SIZE);
> > 
> > Can this end up with mis-accounting due to CPU hotplug?
> 
> Hey Harry, thanks for giving this patch a look!

np :)

> Yes, definitely. I think the solution is just to charge based on possible
> CPUs, even if that might lead to some inaccuracy (by however many CPUs
> aren't online at that moment).

Yeah, that sounds fine to me.
Not sure if there's nr_cpus_node() equivalent for possible CPUs though.

> Seems like that's what already happens
> in memcg anyways, so I think this discrepancy is OK to tolerate.

Agreed.

> Will spin up a v3! Thanks a lot, Harry! Have a great day : -)

You too!

-- 
Cheers,
Harry / Hyeonggon

