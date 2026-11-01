Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEAF6606A326
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:06:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=P5T/0GiJ
Received: by kanga.kvack.org (Postfix)
	id 7B63E6B05BA; Sun,  1 Nov 2026 12:06:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 766F96B05BC; Sun,  1 Nov 2026 12:06:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D196B05BD; Sun,  1 Nov 2026 12:06:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0AF6B05BA
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:06:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC441A87C4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:06:57 +0000 (UTC)
X-FDA: 85387180074.29.C3D9D16
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1713D120006
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:06:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P5T/0GiJ";
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793552816;
	b=cume6HExC+9UetNNCJLQhng40mWL0eguzkPBrc448VtFVpLJD5W2WTCKB61a7hKFSNX9hv
	cgbSEyoz/A5TrTJpsDDAtitWh7FhMjKRfsPbTzlTCQMqYKUhCP+nAbV0foViCy1fkBjNNn
	QrEFLETwG+nDM7fFd3juyGRm5CqaaDw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="P5T/0GiJ";
	spf=pass (imf29.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793552816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SSP10FG90qh8b5f5aDg1OH/wNNAY2fjTeu+XEqiARZs=;
	b=xzm8wUhvQAZB/FaEhvARf/Q/Sr/M1z+Tq+cRnLIujoaEXcc5T8h6Z9o/gm5mxmozuOyIXn
	xLGIeiHtTOrasf/jLg8q1B3HuKhZrLTUS8HkSKfnvG5sLlNLF8h6b6Wr9Cj7lvd/CedDCD
	7X87fDTo0PXabEdE2tH5bgpXFxW8S6c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0604600E2;
	Sun,  1 Nov 2026 17:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5411F000C1;
	Sun,  1 Nov 2026 17:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793552815;
	bh=SSP10FG90qh8b5f5aDg1OH/wNNAY2fjTeu+XEqiARZs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=P5T/0GiJ+afhGq3aagkAB3C9wrvvQlvJMSJpK3pP/ZxT3hK3GSsQv/p0H6ED/sqyl
	 bQOA9JYjdVehpIx8dvmGqovlLihGvyV4J1DlW8atohp1X/CNfYMiPgbHpJXTEgwna+
	 KxmMjqxC9+LqmXxxNGQZW3siu+I7ef8UslxIf4ZAS09GI9sY52zC2pgSmwYECCYJYm
	 n/01P50O0RsiayWhTV05qjbOdDO84w9AIEGAjznwuCXnzVj3yw7SV+4zv9DwbKTS/w
	 pUuNyZZOZpGxxSFHy5j1vZWvApPsEnx9aK3STZ6AYP9V6KcDXSmFtAYpP3Kr2q2M4D
	 TJCROKNCDQqGQ==
Date: Sun, 1 Nov 2026 17:06:53 +0000
From: Harry Yoo <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/2] MAINTAINERS: move SLAB ALLOCATOR under MEMORY
 MANAGEMENT
Message-ID: <audw9R-_gyYkwkGJ@minisforum>
References: <20261101-maint-page_alloc-update-v1-0-27e8c246b13d@kernel.org>
 <20261101-maint-page_alloc-update-v1-2-27e8c246b13d@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261101-maint-page_alloc-update-v1-2-27e8c246b13d@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1713D120006
X-Stat-Signature: knykejrjabth49arb7w7iz175fckm9a3
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793552815-37711
X-HE-Meta: U2FsdGVkX1+9uzeBMtzVItcPm7ErqBeoSa84EKdHPQ2VxvvPTw3NCLfkQ7hrocpThO7Uf4u7tW1R4jNHkssXTqfovZw52MF+WEpUNdEHm0m1PbFKeUpyCupmiW+Lu5ADImi6gdEN9TKkHULuPR9B9xEZonxpPxaLnX/kUP5fg6lM4LlMG1IXsVf8RylH5bvz7n1KCbpatuyhFLsOA9zLuLGN1kSYK5XYalxf+UrWwQsz7MCUGAzTy9xvFHEqA7G1W3U/ew7BGoB9WPwHK1PJUmbe6IjVdPyQYxO7IHsPOtJRBJppfpo+PrctSQ3/2vp6QxLkHz9x6EvBT1tfI51mkL6zoq7yLCLg0eI3pCoY7H4mn6ua2sfuDDEXOTsnUJrC0UEQJIBPboTrvSMQg8Pkdh4mbwU0o99zxE+wK07LygN7DM/gXPjeqfAIpiU4/1dXoFnrVpf69mwOZSRDLyHmjRcBezTP+u5m5bSg1I79NjQDZRaupmSOp9gE7oryBOXxtxUQCXjL8mVgrcSsuree5r2L4/rJsWV+2mzofPUGHaVKyfUYk466a/hMzkSRSns+Sx0YhmtEkyeZYKmK7PW0+IvL9kFyZZi7TvXHKjSloW+Jfs2g4VP6caZ1E71PdR06Hm2dirc3SqDAjf7/sTbY4q+bj/j+v6TXxmG8l2k8Kkhxqn7ISwD8P1EPo97z1M2x+K+hVRoGD6UCA9HEj1srKgprw09TjsD+zaLTE2AzHz7LSQj8qTUI8HuvRIcYerrGszXxoq0msvkG/sDVyDL+DF3Xs80mf+n9gS5OAf8savZqEdvLE521GK9mgherBJA5uq5zmosMpRwkBIunI+LRqYQnNRbdYcHXjOAFGP3kyUc0uHtcBsNqZrlBjuzwlkIMbvxiw0sGchz9FgAcs/+GlEFWIhLKL/Q8Jg6xueq+LIXU2eA+5Cq1UwatSOm/VPnsZLqHI6KlhSxw0o4vA/s
 4/Z3gqWu
 nfhltfZDk9bS39tWAD5yU5gVRDmLmZtO5Mdm+nMBzUobxGM1/1ipYrzD36ohHmNUEsgfYeSe95KXoOwdnQSWeTEiY5YSkMlxcpiDLdNY3ZD6n3wWRGN6yxQi0sGXJc/fwMZKdc9WY3UJN12U+pghWRLgw6eQtYcaQM4uIvVqfrj+qnc05B3mVJzF0KYSR5L96ZaMDV3iznYVeHCGy4gAfFyFIPbGdoPMcy+0FEf4oUPMuDuOaTQd66IM4WOfMAcqVMJHEp1dHD7/ZLmyshTDqkvy9GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 01, 2026 at 05:34:49PM +0100, Vlastimil Babka (SUSE) wrote:
> Following David's consolidation of several other MM subcomponents, do
> the same for the slab allocator.
> 
> Rename the section to MEMORY MANAGEMENT - SLAB ALLOCATOR and move it to
> remain in alphabetical order.
> 
> Remove Andrew as M: to signify he's not the primary person for picking
> patches in this subcomponent. get_maintainers will continue CCing him on
> most patches via the catch-all MM entry. David prefers not being added
> for mail volume reasons.
> 
> Indicate the primary integration branch (slab/for-next) in the T: entry.
> It will now be integrrated via the mm/linux integration tree.
> 
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Acked-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

