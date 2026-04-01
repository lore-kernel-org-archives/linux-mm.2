Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F17D35179
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 12:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE5696B0005; Wed,  1 Apr 2026 08:26:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBD5E6B0088; Wed,  1 Apr 2026 08:26:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9FD6B0089; Wed,  1 Apr 2026 08:26:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C22666B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 08:26:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5DF2E5A214
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:26:21 +0000 (UTC)
X-FDA: 84609909762.26.8C9F4ED
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf03.hostedemail.com (Postfix) with ESMTP id 538DA20011
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 12:26:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DuCPEUoQ;
	spf=pass (imf03.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775046379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9RRpsgUrZWaL+QC1rauEtM+0dsvtlEKa3fb+EjeI+Vg=;
	b=oFmIMDNKflPFok+Nhjd3cFsN7JuSYldJiZcAWx9AOZWJI2+BJA715StBhr3r0r+tfiDuuG
	dthTswMLr+5uMHcjC+lnMOLLSNOQ7QDE5uBGWbQWFEyWwvKskSPkUk5o4BvfCuHkzJWL9v
	clAHjJ3QW10g9OXa8TfsLCbLQaRSOCc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775046379; a=rsa-sha256;
	cv=none;
	b=wXCBOBU+CoPT2Z2Sf7O9RON/nPqFjGjcA65vLqWqNnZ0K0D1fzpqgdM8Lt2YVWOQDEjWyx
	VnIwuhh3vFM2Hq+eOdVTgSDUSB4tuGb2Vz50HUg1q+rVEx6Cj63ZxQO3C4ToDTgqVRx81T
	ZDBe9lHsXBw53/OA234UFOo26P2uB7s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DuCPEUoQ;
	spf=pass (imf03.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775046376;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9RRpsgUrZWaL+QC1rauEtM+0dsvtlEKa3fb+EjeI+Vg=;
	b=DuCPEUoQ585nScG8yHQ7EYzzMTFYAosos72EJa5eXCTRxZSXHExP4bnU5tW90oMuKkp5Ay
	WYLplWHm7RjosHRA1bSoehBUqKAZxQ93bUXPDx/tKg91C2lL77mO3+unvHyY9jKVxmeofP
	vVr5tOOeue8gXsBtv4fOj9imFr5VfTY=
Date: Wed, 01 Apr 2026 12:26:15 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "teawater" <hui.zhu@linux.dev>
Message-ID: <a897fa9eb0ba60fa5a5b4be106d9d376f2f1e2ca@linux.dev>
TLS-Required: No
Subject: Re: [PATCH mm-stable v3] mm/memcontrol: batch memcg charging in
 __memcg_slab_post_alloc_hook
To: "Harry Yoo (Oracle)" <harry@kernel.org>, "Shakeel Butt"
 <shakeel.butt@linux.dev>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Muchun
 Song" <muchun.song@linux.dev>, "Andrew Morton"
 <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Hui Zhu" <zhuhui@kylinos.cn>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Hao Li" <hao.li@linux.dev>
In-Reply-To: <acv5QCe0qMUUW2xP@hyeyoo>
References: <20260331091707.226786-1-hui.zhu@linux.dev>
 <acvnjCr26zpQUW0h@linux.dev> <acv5QCe0qMUUW2xP@hyeyoo>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 538DA20011
X-Stat-Signature: nf5g1ddc7pehaghz1qna9yhm7114q5uw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775046379-243660
X-HE-Meta: U2FsdGVkX1+1jkUND3TtqvXUoh4Xz9l/jScn5X7ku64w3KL/XdzjmgJXxQ3dg6jIY9OZN/Zsm90EapxpiDKxXFD45Dzg+/4OaxtL1+PFfoWBbnZw0VQNfECFKmMlmhKbvpE8dkonOUmQ+hYZDZ69KU+NmpaLfzAAquDXuEaCaLQ3J9V+Ew5NAL9SobujVBysKBkHYPtNXnNEd5UkiGg9D10HrDmjREmBIVIuLvNOX+IgkxinFEYLMI4W6B7LSDxZv0VpVjRvDdEyTQC8S/R9v3MjTk09VgmUQ7zPAAcDoxw75L8+aU/ix5sGtEO7b11YrivYpqtq3vPswS2swXp/ck6WKuav7TnLnhnSUu//y4AGU+wBO7QrfajLzGNUxdy8xsKeLds2GFT7y99uolpJsYMmG21TX8+HheetgVBw2NOq4Cl8d5F1rm4C0jfSBd4PPwEJgqkH/lKrTYWUuytVtGVSaKP+N2pZSf3wKeDHkKPxyDv9FnDxEdxznpP+YcAC/A7g0cLppBdxVn0hO9pa32Fh6LBD+QnoXYNWQwL2PuOxfGHGHglC0bWth0RbywWoCEku/xJmcYQpOtESW+tcl8TJQ4Mhuo8Og2z0tg3BEp6WweDJCG167sK5ki4sVEBYsWqqYf8Us2ALNE2Jp3RhrXDyEb2WvisQWfCDtbZlVdzmp59U9/ig5hLmm7UWLG3xqFA0K9O6UTixx9CP/gRTnuNt5bu4AcAgckti88tzizPRVprdSt7lI4rWLNdXs1l8vi2nmUmmn3SbZmVZf0j/xPk6kLa2fpVx0gHZFGQ2EgM7DmMHwkfQ4pMiiq8ME6bqxBSSIv8w7xrVXe4a5zIhtDsiAlypbDBluY/xvJdON93CKWUBvMoKSKh+f/sbQsA10gFmz7brF036Mwhrs10AHH65f3RSVQOwdpYJD0vM2k8RFDvPH3Kldr2rVok0MJ2vYFHYuyxnqDSZ3I0oNTw
 Nfm98Q63
 3yOBawEjgy6H2ezQYFEjIn1cQ32QYhN/S24DUQXooABu7vlJsBfeOohI/4HNfQ0sXZJpOkircESH+sgtTHI9B6WctX8X2okWW9euxBUK/dFwTCdtD/u5xpu81nohE2X/6ynppBSlqkwbdwhlpxdD2Fh1IcRm5BD50u7xKmBpnPlX6FgDXepWWNKuz5xekE2aQxgM5GXgBxM2tiv3LHOmQ9ZM0qtsE/lJdT//lvfMAVoUJQYXnYjGf/n0rrDzp43zipL5C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Tue, Mar 31, 2026 at 08:32:30AM -0700, Shakeel Butt wrote:
>=20
>=20>=20
>=20> On Tue, Mar 31, 2026 at 05:17:07PM +0800, Hui Zhu wrote:
> >  From: Hui Zhu <zhuhui@kylinos.cn>
> >=20=20
>=20>  When kmem_cache_alloc_bulk() allocates multiple objects, the post-=
alloc
> >  hook __memcg_slab_post_alloc_hook() previously charged memcg one obj=
ect
> >  at a time, even though consecutive objects may reside on slabs backe=
d by
> >  the same pgdat node.
> >=20=20
>=20>  Batch the memcg charging by scanning ahead from the current positi=
on to
> >  find a contiguous run of objects whose slabs share the same pgdat, t=
hen
> >  issue a single __obj_cgroup_charge() / __consume_obj_stock() call fo=
r
> >  the entire run. The per-object obj_ext assignment loop is preserved =
as-is
> >  since it cannot be further collapsed.
> >=20=20
>=20>  This implements the TODO comment left in commit bc730030f956 ("mem=
cg:
> >  combine slab obj stock charging and accounting").
> >=20=20
>=20>  The existing error-recovery contract is unchanged: if size =3D=3D =
1 then
> >  memcg_alloc_abort_single() will free the sole object, and for larger
> >  bulk allocations kmem_cache_free_bulk() will uncharge any objects th=
at
> >  were already charged before the failure.
> >=20=20
>=20>  Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT
> >  (iters=3D100000):
> >=20=20
>=20>  bulk=3D32 before: 215 ns/object after: 174 ns/object (-19%)
> >  bulk=3D1 before: 344 ns/object after: 335 ns/object ( ~)
> >=20=20
>=20>  No measurable regression for bulk=3D1, as expected.
> >=20=20
>=20>  Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >=20=20
>=20>  Do we have an actual user of kmem_cache_alloc_bulk(GFP_ACCOUNT) in=
 kernel?
> >=20

Hi=20Harry and Shakeel,

> Apparently we have a SLAB_ACCOUNT user in io_uring.c.
> (perhaps it's the only user?)

Looks like __io_alloc_req_refill is only user that call kmem_cache_alloc_=
bulk
with SLAB_ACCOUNT.

I am working on make a benchmark code for it.

Best,
Hui

>=20
>=20>=20
>=20> If yes, can you please benchmark that usage? Otherwise can we pleas=
e wait for
> >  an actual user before adding more complexity? Or you can look for op=
portunities
> >  for kmem_cache_alloc_bulk(GFP_ACCOUNT) users and add the optimizatio=
n along with
> >  the user.
> >=20
>=20Good point. I was also wondering what are use cases benefiting
> from this beyond the microbenchmark.
>=20
>=20>=20
>=20> Have you looked at the bulk free side? I think we already have rcu =
freeing in
> >  bulk as a user. Did you find any opportunities in optimizing the
> >  __memcg_slab_free_hook() from bulk free?
> >=20
>=20Probably a bit out of scope but one thing to note on slab side:
> kfree_bulk() (called by kfree_rcu batching) doesn't specify slab cache,
> and it builds a detached freelist which contains objects from the same =
slab.
>=20
>=20On the other hand kmem_cache_free_bulk() with non-NULL slab cache
> simply calls free_to_pcs_bulk() and it passes objects one by one to
> __memcg_slab_free_hook() since objects may not come from the same slab.
>=20
>=20Now that we have sheaves enabled for (almost) all slab caches, it mig=
ht
> be worth revisiting - e.g. sort objects by slab cache and
> pass them to free_to_pcs_bulk() instead of building a detached freelist=
.
>=20
>=20And let __memcg_slab_free_hook() handle objects from the same cache b=
ut
> from different slabs.
>=20
>=20--=20
>=20Cheers,
> Harry / Hyeonggon
>

