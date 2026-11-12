Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37800606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i1zNU4pQ
Received: by kanga.kvack.org (Postfix)
	id 5D1356B05B2; Thu, 12 Nov 2026 04:37:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587BF6B05B3; Thu, 12 Nov 2026 04:37:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498656B05B4; Thu, 12 Nov 2026 04:37:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D8776B05B2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:37:37 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C1AB01C1F78
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:37:36 +0000 (UTC)
X-FDA: 85425964512.11.1A8B76A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 29D4C140002
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:37:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1zNU4pQ;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794476255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=guUgMXJMpJZTYVz358gle49CYmzbo9EaOfDTkZTQ/V0=;
	b=bgggcNmLSXDpCsdQr4ZWQE1+bSviqqzWntgm5O225HdTBPTaaRm1ASCNmdZBmdlc4VYwqr
	x1bOluj4ud7hOzJRu5162nKiDWYu1Etiu/XzL517yORRXJKSlvgXPWdQNWIyAx+43ymanx
	QrEzOAZig709M3j90YB6w4ajJaD88ts=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794476255;
	b=iUoIM21t6E9kEe7iFVy5fV2jW+a5PjJR+yFrCksWbRbriy3L5ZNBBB3ZwZNaGKCUmv82BN
	0FnIG9tFh7DFxAb0Q4PsuThbzOC9v/j5ltsAIxskp/NxydcbXuDTCt5NrGcRxLj+ezA4TZ
	FxgnfyQgR6NA+gFNRyltj1c/2tYuMR4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i1zNU4pQ;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D3A7A632AC;
	Thu, 12 Nov 2026 09:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5F471F00A05;
	Thu, 12 Nov 2026 09:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476253;
	bh=guUgMXJMpJZTYVz358gle49CYmzbo9EaOfDTkZTQ/V0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=i1zNU4pQ6RAI0SHQH2oxMsM0nUCVXis4Rxxkc6IyJElj8kWz9/fLPxxXaJsr8SQnP
	 vIxw5uWb/5fBksp4FatGEMr/ik3Wz4w/KZ24xl02IVDAuQPUb9wKIPzD5YFQNyjVI9
	 DpfLCLLMyHqNdjxa7DI9cLe+RcUTBANCQk2gXq7fppNYIjKh/ab1qQzs0nCL9w8Jmz
	 fZ2ZzjUZoSu0YMg7f74981wrUBUlS/eYQh+jUjMkJSJStAWP/owDMexV2ELXwCHZsx
	 1nVYBUSCY8lg7WEgE1cpXnSxcc4sANgtBiKKWtL6odOni3+3EbUpsWJl+mNs3irQ3/
	 5ZYt2LgII1hiQ==
From: David Hildenbrand <david@kernel.org>
To: linux-mm@kvack.org, "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, ying.huang@linux.alibaba.com, 
 weixugc@google.com, aneesh.kumar@linux.ibm.com
In-Reply-To: <20261021024438.1942502-1-gourry@gourry.net>
References: <20261021024438.1942502-1-gourry@gourry.net>
Subject: Re: [PATCH v2] mm/memory-tiers: reset demotion targets of nodes
 without memory
Message-Id: <179447625038.6053.14351810863988916081.b4-ty@b4>
Date: Thu, 12 Nov 2026 10:37:30 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: atj7p6krexj8fno1ucjc8xgam5g53z1x
X-Rspamd-Queue-Id: 29D4C140002
X-Rspam-User: 
X-HE-Tag: 1794476254-97768
X-HE-Meta: U2FsdGVkX1/wnQihoxXvErvCFF8cVipgOCG/Iy9ynlw/od5XXFHJ15okpP1eOOQ+qfILRHcx1PhBII6y+oUXqgqkJ9Ie1MIG9cuT+QIqIFuHOUf8qtqqnOeMK2y9Z2cDGkg/JGydoHK+Uo7ay+DF3jKbbmo9dpl4pAeI0y5ahW9bYzJPKxQn+Np9f1DmwncLtWqNYxwNAqdJZ5mIP4GzNKDciXcwfxDKC6f6LNi9x+y25WMrrctmaApd4dYqKd2RC9ecH1AFBuSkoKJQbaECUzDQNsQuVjGcV4WzERd8HE11NzEgvL8zmNZtlLUC7QN85tXTaKTVqzjA8nFEi2R05Nic81zrSY8f32EWWv/vnnJUMBeUiz0tKEpu6u2wQo8MmUSryhFu2H2X6lf8G0vHomB824txhFCVbmmweBnDN1fIe9Iq4QQUIDFQEkfM+n44pVJKDOsw835ljjSxoS60IALFUXjvs+fZhrlMHoWRafdY28DVWNUyWygxHvZMT06xpSP5O12xNWLTTUAy74e3bzFubRko5KMnAIwn5KyH1vt3Sm8Kj+NY74eNr0qkUiLMThnVhr5vNZTt6MnJ5FErpicpS/aDA74MOrjHzPBhrBgqdkXLBHPCWbWfFrpVoqmYJXHmM8m2VZmA28rBYLNAjPfZ+d2MxLQxjcMyBmfZEMVLEZY8mC1YU+pCGJFQKycBDYjo3RA2oTGOh/Y1fH2plp1Wf1T5t6WnbpK+LIhdZp5+9Rce7YwQjHW6hn7el0PZPML/OZmh9nBYupHkG2lc5QAJ0BdSBK80nne11A+dF0d5Z62O5NvrsAxDx1N+yzxSgJWGU6OX0AA2FB1TdarVrY0t8UbmRCVgaC6MX48GKeQkKYjsN2rfW15khwPUDmRXCoYZ5ZszXd/EQ3/BtCRsZ3Ij4bit/lO1itaGwzXsBpJVJ+UOkZv+Uh1Gle3lVKncv0paUNsbRwKjEuk9dlc
 FYu79MwD
 feR6Ip6mojJRjO/h28/cEzl0olwdogW6+ZSP91epKtlLYBYGi/McDDLQgSrvq+PoVCvNxfBnIrkaj+2i/++LlEOvYgRgbSMWK9QhrqMxmZVNVakQqH8m5Fc2pZQDkwryPHptTMUEVoo6vXxMbgQvNN6P/+fHI+YJ4g3aynnmGJ+6QQSCVl6qr3ZJIMp2nrEtWy8W2Ift0r5Beor83MM4sPlm85f4GgpxIICAgoMU/DDvyvq8rG8uQ+/KqTIOmTbW2xXZdJGTvwuPsQF3/rdmXiiTDF77qGfjYYTnEMb1zQ8FpjmCmA/E0q8fPDfyb1lT4STLP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 20 Oct 2026 22:44:38 -0400, Gregory Price (Meta) wrote:
> When a node loses its last memory, offline_pages() clears N_MEMORY
> before the memory-tier callback rebuilds the demotion targets.
> disable_all_demotion_targets() resets only N_MEMORY nodes, so the node
> keeps its old node_demotion[] entry while it has no memory. Before
> 6c542ab75714, the reset covered every online node.
> 
> A reclaimer reads the stale entry only between the node regaining memory
> and its targets being rebuilt, and it filters the entry against the
> current allowed targets, so there is no user-visible effect. To see it,
> online and then offline a node's only DIMM: a debugger still finds the
> lower-tier node in node_demotion[nid].preferred.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: migrate-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/memory-tiers: reset demotion targets of nodes without memory
      https://git.kernel.org/mm/core/c/12566c5b

-- 
Cheers,

David


