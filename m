Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1E37606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 13:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hvP5uzYV
Received: by kanga.kvack.org (Postfix)
	id 16E5E6B05B2; Thu, 26 Nov 2026 08:16:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146856B05B5; Thu, 26 Nov 2026 08:16:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 083366B05B6; Thu, 26 Nov 2026 08:16:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F4416B05B2
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 08:16:50 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3347BA0450
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:16:50 +0000 (UTC)
X-FDA: 85477320180.19.50DFAC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 814B81C0012
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 13:16:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hvP5uzYV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795699008;
	b=vvamkAO9HWieoHI6Nyx/grGN5wkuYYhebYXR4rJy6Vo/vF2EwD7RIadgsT3edbb2Oie3d6
	uFZteuvMXct0yklRbMA4IAGktThLhFCGfFQFRffe/cOOVVoexmZiBb+jAwlWZVZoGOszS/
	vyK73nnDDEqiUU99oNd7IUW6EJ7GtgY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795699008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ehgUlTp55qdmB35sLa7A0/qjO2eVfa+LAyFNNpEVErI=;
	b=LjaoFXxtgpOtHhef5+gN0A43kTaTEk1aNVPi+W7yBfbfatadkrZGwzMCXAvJcC6FjxQNBZ
	g/n8MxmJoLD8PA/nVsLb+QKhFo2nGtwshROxpYYIJrtUuIO+zMbdYuVMTliIv/m722dGdZ
	eAhU17d5+dDDgEG5i+SI81ZTkfwS+fY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hvP5uzYV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C65074486E;
	Thu, 26 Nov 2026 13:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9831F000ED;
	Thu, 26 Nov 2026 13:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795699007;
	bh=ehgUlTp55qdmB35sLa7A0/qjO2eVfa+LAyFNNpEVErI=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=hvP5uzYV/M6mmd/34FK8Mg1hVQnnl7JC2syiVD/BCJPbcQp3xGy130d5votP+66EJ
	 EsvedPNywuwHqx5NqtnpvSMSf/jkHTaBQY/227R6kE+zjV1gjZYJLpsp+0qqKp+X7B
	 oNkrrvENLDIjUizp276GwgI7eEwHlDQq/5LfJ7WOoX4xhuTaPGuzD7f/W0oD742UyM
	 Nq+RqD+6YlalFBxPPmOY0QLfvp1DpnYLGVGRhJK8Hp87iU26p6rFZ6EZdgTxNMSgA0
	 ldiATGL8MtNaTSC07F3eijcyEFPH5wdsLgWIwu0kREDBOBabUR4G0xnVf6NM5zPTrw
	 TCmxqQUbporXA==
From: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
 Ying Huang <huang.ying.caritas@gmail.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-rt-devel@lists.linux.dev, 
 linux-riscv@lists.infradead.org, stable@vger.kernel.org, 
 Kirk Swidowski <swidowski@google.com>, 
 Huang Ying <ying.huang@linux.alibaba.com>
In-Reply-To: <20261125-rmap-v2-1-0ba817662eac@kernel.org>
References: <20261125-rmap-v2-1-0ba817662eac@kernel.org>
Subject: Re: [PATCH v2] mm/rmap: avoid reusing batched TLB flush
 generations
Message-Id: <179569899881.7893.12894803575730359323.b4-ty@b4>
Date: Thu, 26 Nov 2026 14:16:38 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Queue-Id: 814B81C0012
X-Stat-Signature: hr9xbxsbnffaer8yj1kydo3fcxm1f8co
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795699008-680788
X-HE-Meta: U2FsdGVkX1+Ai87vXKOTt6GpvZQqQyvKPUFSggedFRyHLdmRc06dh4d59rxgHj+btGRpevr9JRM4rUGQo/CYcrB3hwtpVjT6kfxohO+MTdszHmorIrNhEIz3+B7L3nwSQjIIvnyXj1/CYce+ycF2UawkAcTAQvpB87yVz2EkhYmMVqVBz4FpkcGRblUCX/cxEUZV7n1ETRPcJXP9IhUQb6rJ1dbLWPGskI6EvvUAAIbnqfeahSj5jDC9Xi8aMY1Hj/7pONE5zN4NmlHy+1pkjfFdcw4p1M2brUomBI77Qr2VJqCjkeVE44rZ1WdmN5l5cyyIvrLlSMv3y7COcbpGoSB7hD73MiU9jHaYGgFVcJYof5LRZYk595Mz6Cst0b2kN0/NWhIKhSn3PpNhRN7+IReSfKOoeO3slo9FJ/84cBSRf9ikm4EiOLwBJWdKzf2iBJ1GBOZgT9Gmxx+TsnMuT1rWrxzjQeTtSNZ1+fmO97KjuyU2ArZs5EkqqRgeL4/PqMKFbSrbr23Gejrjx/2g8q/mUmyDLYHqk3ZIO7itYt0mZCHehafT9VmiEStY4DnhRZVH9qsaMLEFeH5LbWavQ2BOPKKAnOtijuCTgigOFRqQDgWFc2t2qyHX4d0oEjUSc1EqOLrp9LgAtOkwLJe9+YcgBc66IVrNn1ob1K+W8euqrSMO9M4iFqMHOcxsYUwn1YCfR8zqbWqQVxPCH6rpf5w4ZKhEru2Mu3zjAthKTR0xUNXACmjvpWWz9IRYVYDdluHK+CQOQIkZJwRd5uNkeT5YB4sjnKabpHbCfRl9BHkOu4mfYPVpFny+U7l/dHprEHqFVxRaJvWlTPbOex+fQy0b+YN9TIMoz6NneKmwrwEMavOhY75RRABneRKpP4EJW6YAqMNVGe4PYbJiEYAVGfSCyfKpworW7O1ffpE20E//g/igRYl31CQCgGF3zTjptCA592FEbEZCeqlZ/Vp
 jAdxcOgk
 BwHWvPYSNkqNyrAjEdssYgDPp5hQQW/0FXhLDAjVlz4/6aIPFKzirFj5CEL49SthOZEdezqcZDhYGbWvk7WFuZsATDyUEzn6nrvxckzud8XGguPTJFh2Oa1o04k6pfq6IwckUFVGdJb182KjUKSkzRLWh0GJ0CNGS8ecTADwWRSP+s59tZi2HaHCS15VsVzecUXI8rJg7lloYXL4/aNvI7miHglXxuUQMtOMSb22v+fnNk48nrG+MLWAs/49wWL6SIscXoScGOIMNW4sD3xFapxTu9GqXraY1DMFj/DRojE9Do6fyeseDD4C8ZECAw1+7GknQ4au2VeLc3zmfZFSJsW3g/RBAbhAclAF8P9gpfgtBOlABjtu/8OTR6MdR1/+ZupZjopg01+OgjQthZ7eiNQutSwzLjU989sDjgFTxkvQDLBKmNKszogQ55rmct7RMKpbjsLci51QDYl0u+s8ZIRxAdpiuz1Nt7oB487ykLVu7lcmuBmYrnTOyyF2uHKhqSsh0hmaMgybT497BpaocBCtzs89ZpI8IbXo3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 25 Nov 2026 10:34:46 +0100, David Hildenbrand (Arm) wrote:
> mm->tlb_flush_batched packs a 15-bit pending and a 15-bit flushed
> counter into one atomic_t, and resets both once pending gets large.
> flush_tlb_batched_pending() updates flushed with a cmpxchg() against the
> value it read before flushing.
> 
> If the counters get reset and reach that same value again while
> flush_tlb_mm() is running, the cmpxchg() succeeds and unmaps that
> happened in the meantime are considered flushed. A later zap can then
> skip the flush and leave stale writable TLB entries behind.
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

[1/1] mm/rmap: avoid reusing batched TLB flush generations
      https://git.kernel.org/mm/core/c/40e0fced

-- 
Cheers,

David


