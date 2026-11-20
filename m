Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16F75606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LexWIxiw
Received: by kanga.kvack.org (Postfix)
	id 3EBC16B05B1; Fri, 20 Nov 2026 04:18:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C3766B05B2; Fri, 20 Nov 2026 04:18:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D96D6B05B3; Fri, 20 Nov 2026 04:18:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 119486B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:18:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F2C6120E23
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:18:38 +0000 (UTC)
X-FDA: 85454947116.30.6FEF898
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D49BD80002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:18:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LexWIxiw;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795166317;
	b=gvpj9eMbvDrJft8VRjAaQxhzAPCS7Q6dDCPQMNzg7qGSE9EozqxveYPbODIdMxad0AMFps
	N///zvTerWLAa5kaalSuToXKa0CTpa+ou1UfcPNMBJ0247XybPz9wEKG9WPiuumTXK9Stq
	KQxRo9XM+FBSn+GFqs65j82X0DkIniA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795166316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CrWm9yszaSjT1+brCIxSYBYmwnFrRxhTb7bR33nbwck=;
	b=O2iSZc+Ja53knub9ahBUh0RZCyqBTQmJay9k0eCSco7EgHds94+wEV0NsOsSWHmK3zXhCg
	PKBBxSwb05z9araAyf1vh8mTXxA2VbzCoiNoBr4e3F/WH4F/N3xA4sHxOWBGOwNCDrn0CR
	Dlvd2QNcWhunT9B/hapDNsSPSlxmMlA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LexWIxiw;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D98146635;
	Fri, 20 Nov 2026 09:18:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3B11F000C6;
	Fri, 20 Nov 2026 09:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795166316;
	bh=CrWm9yszaSjT1+brCIxSYBYmwnFrRxhTb7bR33nbwck=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=LexWIxiwxcg/tw3IZ1+li3kQ+ULA1XV7e1Rjupo2+XX1cvX3bNaU7BBWClPBC0dYX
	 DITMTTO/ytU2cJC+gq78MHYFV/w6VXWmYBr7xCcCJSY6VjW6iBQtyTOoZq0TEF8Q+T
	 u5ShNJPnEwECLKzWpMOk2i7a/pMKBM9BYXAJjO664Hyt4amUlNIGgZJFVj2lOsmIXe
	 e6Xt9dj2W69ZXyizcpORRSI+jW/QS9XghD+2O0FHsKL+bHTtNZO1XbYRmvD2MlqugO
	 KH3Lid79RfL+++lKdQxVfrhynX9bF25ZV4OpK+90vCpQ1yzhrh22UqrP9vXPD+e/8m
	 gMHRng1lECYjw==
From: David Hildenbrand <david@kernel.org>
To: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jann Horn <jannh@google.com>, Ying Huang <huang.ying.caritas@gmail.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 Sashiko <sashiko-bot@kernel.org>
In-Reply-To: <20261119-madv_free_thp-v1-1-a312919e1ee5@kernel.org>
References: <20261119-madv_free_thp-v1-1-a312919e1ee5@kernel.org>
Subject: Re: [PATCH] mm/madvise: fix MADV_FREE handling for PMD-mapped THPs
Message-Id: <179516630988.4236.15752843940169828814.b4-ty@b4>
Date: Fri, 20 Nov 2026 10:18:29 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: p8abxiygqtcxo4cq3wqyi8uwpzwo57np
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D49BD80002
X-HE-Tag: 1795166316-496026
X-HE-Meta: U2FsdGVkX1/RpR62CNfuSr7niIXOrKiGLZJwaOSwMZr9JOOxTSzIdRMqzRzmOjutNumOeEjcUsiRIpus9X5GPhzc2y1Nxk87Qehv56uZrZ36hGdRQm0jC7Vj8Da6HjBlqXLbbRwIoYgdSfOfN6EkW+AIv9SayK3/FjF64aULj5FkwqYorl0q4bytraJD50HUpDjiTBEgrjuT9MXDE/+TfZtXmCoYEDo1VS7YwiQtORCgywVCMPLKtxk1n52YzEIzrz008SB2A1w5e2fBpqISiaseu8MzzStlW88seJ7g+37HZ4tsKdi2cfthC1bqkVQNAxMKkTrbL1w3QtPpVO8gSd/asyUq/awLKgLRdaEYjgBPUEY0HeKwRsns2bXDZeq4P2Ian/3OGzwI0O0YqDj5PZDcw50eaFHtLRqvfJrIQlixQ8YER9IfxWqP/kumGySTjpOA4dq3xQgYo9mZdW19Nbu+C1R+ZkyICj2HKq3lQ0Piro9AOPy9pmKTcO4RTfiD/xwWiK0yw1p1xpKi8swjz4shL7PKckrYaAwaS830ZCdzeiZGKBQozFHYjIKecXXT2T3TuGB/qkLynNZRM0JUYMxTZ5BETfkjA+JK1CoqBLBylqXg5zkjC2YP6WoU21GW88hTGq69UU93Nt1Xy/7yfR07HEJNq0vecqgq9EtnUjkwSW57ym5APdRUM31HdhfuH3unZolcN6IMRde8WZQszL5C2ifRR8BIBy1tfWluoTlXSzcEmOHXPWEvhfNFYCMbVGMNWcBpIGwE3/xzqIuLtrwKwBYZ0+8LhnAVwOhWyY4AVbCRePv15iv6jT03pudqlnMwB5Gq8Se9VCJiccZWWmJWEOvQS6RgOf00EuzFU9HzVmpuYzZaX+9H+Nl1KiWMH0eFJOTBaM1aIRo5exJpnVKy0EDHEmDzb16YlcN5/JMMpkCuh8Z5REOkZNWAJSQbWPnN69Jv/ASVEQxoRV9
 1yYekz6A
 WSHlKBRXXqu3INZCqU/C66Gf57ypuesvKctijpBL7ZpVejWberNrRz3ayi1SZAlba34CI2w7eqfaziq/Eds8LaLbl15Qpf/Ig/JIBZ/+Gne9X2yAOKOU1hi+IrhBXHXuhAeUGtuFRtBHaKKFmvN9FXsLMi5ODHSuFdZd8C/NLUD2ebCwt8OKswSH0StXqOyTVXSTy15v2YsMsFUOxBWFZvRkBPDZbcSc3xHlX5Cmr6VDKv+N95BTvU0C0kI4qoFUviJhlKc0mvlRu7dlAyHSBdktzvLShdjZ/UD/mWxa023fJIOHibpYxJCAPqKBCMED5ZpyvM7CsRINwkxuO44zVY9Hp6Oa153l83N8EHt0zCSbRD3y05AllTzB+h9vfP6DgqPi9HWYE7p9Q9alOi7be+IRVkcpkDTEt8pIn1ImEx/u9YrHd5iWYC/o/xqszLiutH3V3Se2TgMl2NR5nxUctKohnMJR+75dewFrjRwIszXfqSvL8gqKtMoxwocuptcL+3Ubt/sAU4j4pi90UC6pTKyDSMxSs5HnAhQL3deYuxczwH4FWYa2uKzOj5TGnwx/TbbeEvh4MYv2uZTqH8qup16sLoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 19 Nov 2026 17:04:34 +0100, David Hildenbrand (Arm) wrote:
> After MADV_FREE cleared the dirty flag of an anonymous folio, reclaim will
> later free the folio without writing it back if no mappings are dirty.
> 
> If our folio is still in the swap cache, the swap entries then point at
> swap slots that were never written, exposing stale content of the swap
> device. Bad.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/madvise: fix MADV_FREE handling for PMD-mapped THPs
      https://git.kernel.org/mm/core/c/344d84f4

-- 
Cheers,

David


