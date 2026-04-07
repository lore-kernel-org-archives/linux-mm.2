Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F28B7EDB7E8
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 10:10:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0686B0088; Tue,  7 Apr 2026 06:10:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 371696B0089; Tue,  7 Apr 2026 06:10:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286CD6B008A; Tue,  7 Apr 2026 06:10:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 18B0D6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:10:17 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3B8FE2413
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:10:16 +0000 (UTC)
X-FDA: 84631339632.26.DE4B44E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1FCE1C0010
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:10:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nkumau9Z;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775556615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uJwhrCZ5DVi1XGiVE85l7GZb0X3pCioNotmsUsRYefE=;
	b=Jo4cmyCobmbTETZxmSoY8Ye8EHbbo3vTOdzAoDCFNT6oEndfyfADe4KMkTIhRYxYAvKKeO
	FpmU94a4FcKSBmozkN+ZLoqDevX0mFraX+LooVd7bN3r9K+Tdfh1Zx95HeEFaS/qn+BooP
	KhJeOzFgkckhzKEjgQ7V0GVFYmCBskY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nkumau9Z;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775556615; a=rsa-sha256;
	cv=none;
	b=dvtlmzca3KEkP7dcxGOyrFU9WgbpJSkQRAar1sOKllGQ4g69Nd60yYLA3A252NcGKpPJZD
	Odb1vQKXYO83GI1dmiSehu/r0Q7wivT6X9h92SCtrajJ2NMyH3pPKCLIittvFKMaUgsVVD
	Uk+8VuMRDWRnCJ0eSzI7KuUBuOwUSCo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 991BF600AC;
	Tue,  7 Apr 2026 10:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF52C116C6;
	Tue,  7 Apr 2026 10:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775556614;
	bh=uJwhrCZ5DVi1XGiVE85l7GZb0X3pCioNotmsUsRYefE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nkumau9ZkicHGxV91qxYWjPubXMFULLZk3pPmXQ7EZvc6i+zLYpzG1V+ahiER9OHH
	 BR5AHjlnw6nKN9it8TN9PvZR63KdbXLwqng9rQ+UGRcVw8LeYS/qsFHwfRFzJQ54w+
	 tYI+dvFq5PhS+fszRDxi4GsTLjolDl+T59NdJz/T7VqPArV9p/+waErCWpJZP8A1qc
	 RqecKtM08KUOQRJihnsNRHncdPa1Th4gfCJZl3zKWr1gq/ZWljZIh3ouGYcehbBbto
	 r2v6KzKZTzc5eTJTEOjYLm1TxZ6Wrbof2WBXKtY+FurfLniwKd/dPAW4Tpqi7LJXhV
	 vGupcfnvlxl+g==
Date: Tue, 7 Apr 2026 11:10:05 +0100
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>
Cc: Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	intel-xe@lists.freedesktop.org, Alistair Popple <apopple@nvidia.com>, 
	Ralph Campbell <rcampbell@nvidia.com>, Christoph Hellwig <hch@lst.de>, 
	Jason Gunthorpe <jgg@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	John Hubbard <jhubbard@nvidia.com>, linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
	stable@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v5] mm: Fix a hmm_range_fault() livelock / starvation
 problem
Message-ID: <adTXtnJs_Rnl_pTD@lucifer>
References: <20260210115653.92413-1-thomas.hellstrom@linux.intel.com>
 <adOqU0UDzpxvQuwA@lucifer>
 <adOtS_q1MuFOawGM@lucifer>
 <adQFYAVGLqv6amZK@gsse-cloud1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adQFYAVGLqv6amZK@gsse-cloud1.jf.intel.com>
X-Rspam-User: 
X-Stat-Signature: 5eod3et9g16ew15z1bryy9yqpb71tbid
X-Rspamd-Queue-Id: 1FCE1C0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1775556614-682985
X-HE-Meta: U2FsdGVkX1/ayxel2h9qI4hf11v7gNfUINBVo3YRd7QR347vhLTtkOyGvjmLQqu5BrgRSIVQU9FUpOmEqw14KBJMB29uFp1ATCSiQ4K+dLu1Cbg9rwigSv52Ha2Ca+lVr0UrVPD1nRlN4KXuVbrHG7OqCuF3Zt0QO6+LrzrnX+s0ZmrA+CmFSh07ju2lNbgiRA8uHDelJ5smWNcx4oRvWKTvFsU14Ok+lUcueX0g9wI1k1MoagybV/NC6L9Fjx0zCJwDGdze3oA9kq7kN09bfU6yUvBTaNFZTK2mSqtCLKlNoo5KCSv+nNM9LtDl5ACqzaDnjUD5fCmbkPLPrlZDwEvlOhN7rPAyWmprhvbXS5LjzLqWoqM0P8T9PUXCoxTX1Ft1NVncKZWj7dP7Ai+SvfcEsskxsMu6foxDfPyeN4x/hoMpdfwvdqBO7VoJZIHOvPYAgxzU3YR8KKaz6F2XVRdGX+Ig1YP1E53/JpErfEpAcuatNl8j6SeOFJGQqFNujlHa9Dm7h7iimhvRc66EyqPauirZVrIffA7YxhFQxA+nG8sKVoCFLI9SkW3mSTm7nykZP6EtOdP/BO2axt418ouRpOhk0fJnzbG9clyjwlSWfU4OJmyNmaBTNtFRxhzTWJsKQHZmpyhUUDlf1Pfzc+E4jdPwcoce58BYk0/MtpdPqJEH6znitI9R65gMbcEw1pTW/LrK32eSi+sgFZBUSkJEmp7MfYJEpxD71+gu8zGghuGAmWKdYmjtOLl3SQjlW6QriL3hoAO2+nXCa9aX7nz+k4DjGD4av5ppusa64VR/rw2+DEk5tQdU7Tk6NjXHpc6aK5CHegbAI7Riam+89JTubIdg8Bn7aX9Xay4x+y5Ul0Ln+yvu1KtCcuW0ResjwjYESfZGOyUJZ6z1vUnnHYkkZ7tpZGP7XBzDY5/UINhulY4RtjV2YO9M3LWSOwDQSRY+8GVIQ7B7AalrU3z
 PwvUy663
 SOHx6BeNOG398ZNRpgKAqcxY+E5ZSXzL1uqd5/BCV13cjG+TkpuKNcc0f0WVDDB3Hzn7sS0bKTMNWW+XXAvwRklS9LV+c8PI8WO2AXWLpOx3Gn6QTuOqWKIomj8cIGkmS2VjROP+exF35X7RtyKN1n68pW3KmS3gMeBrjQXapwmf/4sDqjgglfHO3pv+C7YABZFNVxXk7dnIozqRiQCbSIiigvHIe4Vdma+/nzVl0O5cQ6l0h6PE49d36DMgtdLEB0Zv1wiovM+OGwBkla57fGv90gpTTvnRH6J/0Xlf5vuCgVR9a3XUkRAG3idtPxu821knfgWNtL7K8DDa5jrvNFeQgpw5mhcQZRrey9Z1xE8S2OCQ6Tpb3AXI/mhKWw4tw3DPR52igL7T3gJGqZjNVtlqczMBRkQrWlktxK/WhjVeNGQYrN7840T2J5KvqiJn6+sDDKulQtihr2dA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 06, 2026 at 12:11:28PM -0700, Matthew Brost wrote:
> On Mon, Apr 06, 2026 at 01:56:49PM +0100, Lorenzo Stoakes (Oracle) wrote:
> > On Mon, Apr 06, 2026 at 01:54:13PM +0100, Lorenzo Stoakes (Oracle) wrote:
> > > I see John gave a tag (and he's great so that gives me confidence here),
> > > but we should really follow the procedure on this properly.
> >
> > Oh and just noticed Alastair also :) so that adds further confidence, so this is
> > really a point about cc/M signoff requirement going forwards.
>
> +1.
>
> Andrew did ACK this via DRM here [1].
>
> When we take external subsystem patches through DRM, our merge script
> requires ACKs from an external maintainer, as determined by
> get_maintainers.pl.
>
> I’m not sure what happened here, but it looks like Andrew’s ACK was lost
> on the patch, and somehow our merge tool allowed it to go in regardless.
> We will be more diligent going forward.

ACK on that... ack :), but please make sure to cc- at least the relevant
maintainers on these series going forwards also.

I realise mm has changed somewhat in its approach with this so forgiveable you
missed it :>) but - at least for me - reading mailing lists is just out due to
bandwidth limitations.

>
> Matt
>
> [1] https://patchwork.freedesktop.org/patch/703183/?series=161082&rev=3#comment_1294670
>
> >

Thanks, Lorenzo

