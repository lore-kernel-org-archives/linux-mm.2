Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34BDC606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 15:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S7DabLGt
Received: by kanga.kvack.org (Postfix)
	id 60A106B0A47; Wed, 25 Nov 2026 10:08:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E1BA6B0A49; Wed, 25 Nov 2026 10:08:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F216B0A4A; Wed, 25 Nov 2026 10:08:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34B7B6B0A47
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:08:17 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AC86C1A0E95
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:08:16 +0000 (UTC)
X-FDA: 85473972192.14.8B0BA8B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1FF684000E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 15:08:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7DabLGt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795619295;
	b=nbDKEZV5iZq88XXiRXBiS97L35N0zp+KT7s2M0gQ5racWN1hXbnu56pAzvGgWAXGMoxY0H
	6xy3yNIEB4be3NccV2S5JZHLZtDwFTowPrZyyzgsnRvDZmMU38xC1kgey1MCAh0OCe+rBz
	T1r/vkUpkJmzQAHHck7hWnX4do8/Tg4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795619295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ab6sDbemIaeRzn7SHeKjklD9tikH4paIVcHamWm/hko=;
	b=Mck7ms2v1MK01LytpQoI1w0Yq+dTUQCFCVfelZvtJKJ7rlvcEDT5maHjrTOYq44Bqhwyjg
	zRmW9YOlLvdpGwM1WyvTRGqV5P1shlnqwRWaFd71j8421eqihoz6aE/eY6i0EMyDrC/oo1
	8e4zARJ50yVc9XrDD2OuoE8j8LZgNeA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7DabLGt;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 829246286D;
	Wed, 25 Nov 2026 15:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C7C1F000D1;
	Wed, 25 Nov 2026 15:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795619294;
	bh=Ab6sDbemIaeRzn7SHeKjklD9tikH4paIVcHamWm/hko=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S7DabLGtDTOKMSvXXcu7iMdY7NRE3qud2szwhRNeTv70gjiwDzZFLTsBbgZv55wAf
	 hEcaHeIhYNfO9760VtVwtjDxve5IRjoxq6XhrSG/EBCadMCUkqyW17HVSk5B5JNlEI
	 27Wd01QLoTGAYutUCXdP9aUSDr2rbWI2jI8cFI7qSiG38+hgMVpXZUMVh95tva1N/P
	 DBpfpu06cOBb7OV/4BMN1D26nLSh4sTnltp5MYZzGl2pIuW6oDxceV34bNKB2xze/q
	 NQGEMlFoszpqGFv9v63LwXs05Z3WRZgrxQnz42mccNV5dprMdnAC7EuOLlG6GYDVZq
	 AzkCkjqGawQ1w==
Date: Wed, 25 Nov 2026 15:08:12 +0000
From: Harry Yoo <harry@kernel.org>
To: Andrea Righi <arighi@nvidia.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jan Kara <jack@suse.cz>, Quan Liu <qualiu@nvidia.com>, 
	Lee Trager <ltrager@nvidia.com>, Seth Forshee <sforshee@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slub: Respect MPOL_BIND when taking remote partial
 slabs
Message-ID: <awbyHcZjHYvOizeI@thinkstation>
References: <20261119160430.1113397-1-arighi@nvidia.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119160430.1113397-1-arighi@nvidia.com>
X-Rspamd-Queue-Id: 1FF684000E
X-Stat-Signature: 3a6ewese59b5wgwzdufidfi1ycuimzb3
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795619294-643939
X-HE-Meta: U2FsdGVkX18l/48Oo/zPptcpMDMvSaGwmyiQLvfbk8oCNXQGdjGf9QOKqw8yoP9KeTdHCGUVrGJP82r/xdlX/6CsecimNqrbos/1nVNOdGweorzckdw3YZvqIukZW0eoCkbMSgiAC5yWhKIYqOY49X703dJVVNZxVLokQXvgxeXksduk1S+BWVkbSn1fM+g9pQbnUDjoHlL5B/uE8zfYqMr2y/tx4BxKBgbkiz7+/bsV0Wutc4lr5615PzYDtAME9h5gE78ljtDvEtv5mshPZ4vCWbi8fEAVQj4ctPOjVv+JuBcXrVXjthVk2rjZH1yTFiZxKsupw8OS1amkhxfF2VqUP71Yuj5Nv7dSz/sJqwSnjBhKlCyhuSJil+Hm/Q016dITec1gTqiJQNkQgu/Ti3fK4ZHQ8F2oUi0JK3iPONP0OtVRvq84YM9YaNVUTKraKnFPnOBof41c87NZb1poj8544AGTreWinkRdWvRmRdDijPclKPdamWXSmV+ofCRlrjGEnOqG9zo7B+6jFp7D73prAflCjZ/qzBXuyOZ22RXHf/FIYAUmwaWTCf9t+h0lzbOGWbadffdFJnX8EdLJz3yOWHq70/lZX7l0uoJBC34PDRXg6C098hgrKE4f7jvyhUFXL8gj2q+YorLg31LSJNF6lwD8UGqB6bRd6gBaKriM3M35kzZV/kg0vxGqd1kdTQHTT+9YYF02XTdf/FJrR/vqqxmiNExRLmKbbWOJYxhIjUDURw5mswIycOJlqLlnImAxzOoUifXJ4cxu5s4GJp2Cqypl6gYFN6PuGaym3h6iU795qkf81dm2E+0fKwZNCG+Oc/4UseFTEfnat686qrDadt2py8SxStYeophXFHqrQ7oNPiYwFMVnVMAgQ9nM6S+y5m6CSqcN4lHke+3gsWhbU74/kbYtDgm6YmC8gUbRvPpeUirg1jJNhGoUQFZgH9xtU7270Gr76AAx6SU
 OYX+l5f3
 xRwU+VPr0LIR3JnsVxcDTTCDoGBVMqwpHt+ybv2pmQTOfqbo/Hqx8cwUFVM+gdtqvqtMS3Sp8RXdSWwK8HqL6aLnKRmJtTqLLMJqVC2gO2+9LMBel7SrREnbYcktJm83JQ879qUj2d2v0R/fAEOgdzXldfP0sNaYj0oWOk6jk05LX8hk0i6IZP6grNPPUKtCW1gLE6Y5ChluHQdvtTMzhDoYgXJrkDDN2iYMYRMr7zEWvXkqIy043OPyLnfTEFc835VXHyCfswQ1ZLO/JoeS7s08HE/rb7XD/CXhqXdbLVcv4qsPt3gb2J1Gvnu8hSPmE8rEntUO8zqtw+VhxKVEZetxl1NV5Na2bvd2Z14/Rfg+/NtgZQ1RcvMcdUXmoeT+OGUIkkEzoLOUfIGpb8Y61wWRjZsa8y2Gco5WAkyWLau6wfm+oDK+ygxqoLDDfsMsP1oFibJXZAP+ka0+GlKw/onu1GkKp7rg+fruSwNEMFiF05PqhlkpCCf2YodeS9Iq6RezdVD1dujdVzdg3GMaa1FSYDSYNjjYTmFG2SIFJiFR/wtcoNHUvnYxXqovsEt/FtNCxNowhN3lMlSPoZByzBHezybUOlBUeGehz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 05:04:30PM +0100, Andrea Righi wrote:
> When the local node has no partial slabs, get_from_any_partial() and
> __refill_objects_any() take partial slabs from other nodes.

There's a tradeoff between memory usage and NUMA locality and the
kernel by default favours reducing memory usage.

This could be tuned by /sys/kernel/slab/<name>/remote_node_defrag_ratio.

> The scan
> only checks cpuset_zone_allowed(), not the task's mempolicy, so a task
> bound to a node with MPOL_BIND can get objects from nodes outside its
> policy, even though new slabs for it are allocated on the allowed nodes.
>
> slab_strict_numa doesn't help here: when the local node is in the bind
> mask, apply_strict_numa_policy() leaves the node as NUMA_NO_NODE and the
> allocation takes the same path.

This sounds like an issue to be fixed in slab_strict_numa?
NUMA_NO_NODE allocations should still honour the mempolicy, no?

-- 
Cheers,
Harry / Hyeonggon

