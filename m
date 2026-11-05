Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49100606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 09:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JFHZQ0+B
Received: by kanga.kvack.org (Postfix)
	id 6C5816B05B7; Thu,  5 Nov 2026 04:40:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64F576B05B8; Thu,  5 Nov 2026 04:40:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53E546B05B9; Thu,  5 Nov 2026 04:40:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 322596B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:40:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ACF16C099F
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:40:36 +0000 (UTC)
X-FDA: 85400570472.28.5544424
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E7BB31C0008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:40:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JFHZQ0+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793871635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNJAaZwZg/NlUwIwsUXdsW6SMrErhNT8mcGAusSULhA=;
	b=hHYEcaFSAiyh5CAhjnrn4UUSSy7qhJf3iDQYBQYhBYRJfiL0k0LumlKuQw+0JanKCykF3l
	1urCsP5Hu9XG/zNTIISoXMC/6RcdH3LAx9X2JcU2KcsaEGd3B5GlCbIC7RGas9fgzE6uXf
	wZEaMobAIaCejiCKhJ9W6uw7jtY7qSY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793871635;
	b=8TCUGCHOXcbT3uzhv1yVbF34PswTonge6cPCEputHaAE7eJYKjj3ENvqk3Q4kF40PBVw0m
	s6FsBjybIgki1x7Mgulov2C7sNjehxH82ISN/7IE9ehHKyP1tvn1uwJ/MmOqmRfDoVSpLL
	RGE/muHGjgYJ7nhTeWKVbO1Abo8HFwY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JFHZQ0+B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3066A40933;
	Thu,  5 Nov 2026 09:40:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1882F1F000C1;
	Thu,  5 Nov 2026 09:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793871634;
	bh=fNJAaZwZg/NlUwIwsUXdsW6SMrErhNT8mcGAusSULhA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=JFHZQ0+B2pCdL2m7OmeatH+nXT7ERwyRnjO7ucStV2zTSV6hDRBg7ZjO58r4XJNc3
	 6J19dRZjLktv4cuG8OHzMgprb3YQRgYMOlQq9iFkZ0CmH88laE+DtyMso0puQW7NVa
	 y0h9zTTDZXkIaxA/U7I/nnH+983gE7L4e8JIsVgpMQUrp3Qy8/Kbx2lRyIDxeiKBmV
	 YNwjargTypudlyx0E844Ecd0GEGFNuAxf1zSt+1m/yiUG7/b3dEtt+pMhqzmqQI75F
	 JyGXjN6Vg3Bpcp9rxwEDnRYKgBIqOtDyvplFEfTJ+5PHg4XvTdF7cURUslAGn0uYVK
	 5SKQXsEPknI1g==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Zhao Gongyi <zhaogongyi@bytedance.com>
In-Reply-To: <20261102-ksm-anon-rmap-fix-v1-1-68962acfb59b@kernel.org>
References: <20261102-ksm-anon-rmap-fix-v1-1-68962acfb59b@kernel.org>
Subject: Re: [PATCH] mm/ksm: avoid unsafe anon rmap dereference in KSM
 merge
Message-Id: <179387163181.11797.15205182972949028650.b4-ty@b4>
Date: Thu, 05 Nov 2026 10:40:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Stat-Signature: xt8uf8hsbafnfq6akmfhqip7wwg9m1k8
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E7BB31C0008
X-HE-Tag: 1793871634-104775
X-HE-Meta: U2FsdGVkX18KuQ9FMhHRcjWL7Qj+iqdTLTzDToGsVwHD+YFm1mGVPjjV9VautcXlba12pTBAN5CpBqtQFp5HhVAMarCYPlnifx6ingRDuMddLrzkW9IUntuMVFgLGDpR5p9PGlqOeWfjOGT5C35XRdi4xWtddnMf8z3emGSQ4c+ziXK3Yb01M7fs67fiYaQtAj9+E/0jwt+oFso0Jg6kutCbxTGW0/lQhxCPcA7FUsi1VmjN0F2gbWy6uLlZqkpSxNG2MXXGYhyhVI7rEYbOgNWOOc/vdaHarPj6/ASB43F49hEYJBu5oVXrmjlCq0923Xkm7ZRWpZQEZW+e14A2ItGsEOCiXhHxtYMqHOdbNZg1C89q9MqfUPRBAYzJ2SlaGwI3MQWYSo5904nXe5EHPrvKnjYRb/Ehy4/BUqBREEDMhkzxaZQNXCKvwaYexpUeJNBOisoWdXI76U3PgBxY7AGuihhwxJ2j19CIm9D6DtTaIwf2MUcOsYw3K/XwVyXdH6D567IRdDMUgOLh/n+Pdk7q7HaZRnnr1tk87TyXHygmime4HLNi0a6vL27dLsaNQL+22AdXvPqNxgzDuA0La5dpVxhbr7PCiLVuBRbjiP8cy5co6Z/ISuf8qfr5zFpNsNy5/Fmu98z3Ee3OoU8yc8D9WDwAPgPEuTBUgKjLDz0qwyxWtKkwfmr0RvQjTsk5WR/up20gkMChJeEGoP66O8hrm+zdcm9KceK1wSb5qSHbz3LyZsp1pGkjo3dkrY/dAh8U5K234189UZiozEeHQPVp0kC1IbLD9Q4evGxkb1+Rzxm1uHjhqzLw6UQqc934PU9Dh0c0K9/7uJpwYz6trAODp/9joqtE5mas3s3LyjNFl4ZkuXdB6u1s7JqRpnjO4NuKLMioupvVM3f9wQUgb3qINgWNfBwbNuggY+J4bz5X7o/Gku2/3ymgEx2cz0SZoue5dDxnAGg3bHw7dT6
 //3ox0/g
 Sd/pHkwGanFqHDQLr7SwFSM3xl7CPqfAK51T8tx/at7MVVjA596meDVJOguoDJMgm3PKzEmi0Ak6qoGzmug2PFHZmrppEwo5I9M1r9mhfbWp/3jebudKU4BU0EISX17zPUvFP8oTWIBcHM/NXeanD+RuQs38vhwL3ytBfgu2gVrFe5rt479dFExm2NseAc43/z3IJg+35wACbAZVGTxFceKviBqMK7SEhuFiaMoUpD9kc7OA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 02 Nov 2026 12:32:25 +0000, Lorenzo Stoakes (ARM) wrote:
> When KSM examines candidate VMAs in scan_get_next_rmap_item(), it
> accumulates (mm, address) pairs in ksm_rmap_item objects, assigning them
> via get_next_rmap_item(), pinning folios via a page walk in
> ksm_next_page_pmd_entry().
> 
> Throughout this operation, scan_get_next_rmap_item() holds mmap read lock,
> which it drops afterwards.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: ksm-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/ksm: avoid unsafe anon rmap dereference in KSM merge
      https://git.kernel.org/mm/core/c/d8d12d97

-- 
Cheers,

David


