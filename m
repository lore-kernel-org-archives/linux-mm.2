Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D03EBCD3423
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 07:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 472786B0005; Mon,  4 May 2026 03:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 449B66B008A; Mon,  4 May 2026 03:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3600A6B008C; Mon,  4 May 2026 03:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28E836B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 03:53:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6FCD1C120F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:53:08 +0000 (UTC)
X-FDA: 84728971656.01.14F471A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0AC8312000F
	for <linux-mm@kvack.org>; Mon,  4 May 2026 07:53:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B6uV02bn;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777881187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h/4fc2Deq5QyH656aaxlrF0fZqSx/rStDBdQnkNdfqM=;
	b=ohSJ5YrdlS3VCvm+OjfCVYl+abKFbi0ysVJd+jQX60FQx6ZoBpwOw9OH3P7s0EhyO5txw7
	LsokAj070XSLJqVu4A2A9Uo1kUSwaMxKOr2VE+yRo2XQVZuTmIXsMOb2iQyUrT4e1ZFKra
	V/13f0T22a58TcXgFwPYJTpw7LRYGIQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B6uV02bn;
	spf=pass (imf29.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777881187; a=rsa-sha256;
	cv=none;
	b=CIedTYwHpSswOMJsG/97nI7XYJnqcD57iaIXm8Pw+xAjFy7BHYZVt6ZTfVOfZpuucE1KPy
	eEBjJKpTv8rC6UElkX8usPJbYTzvF9uYRGLvYVJyOUk2VdbMcWfKj6KnNcn/6spVEXcGSA
	5NTo1/lNr5DvjF4qkX759EZMmwSc4Bw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFCBE4098F;
	Mon,  4 May 2026 07:53:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FE0CC2BCB8;
	Mon,  4 May 2026 07:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777881185;
	bh=rMBgP1n8ks/9dio5wMGxcP8k8Hcb6wMZ4/wkWPj+EAk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=B6uV02bn3+cHnWm12AzSZ5AphoQssv2s4BtmhoXwBe4XXVu5/u6aajXvu38/wLj/m
	 aQy7pGqB87aEheFeHSI2lUTMUxTXM7+yzRkpkCIA4+d8df0uLHWCxkpi4C4fSVEiQ9
	 EW4cFmc3zTQHNhYyzUpSfz6Kzci8cQwH0zY718qX2/6/3cekilK1kinwnf8MbEQZ6H
	 H+Aw6g6HT3X283NkSufNiaHBgM0b+znNyPF8DsLkX30IT0YFkrCoFhJdiq6WigYTwX
	 9/bSd44bnVp26sZ4lI/UTZ5lVCI8Z9coyhMF+omyN3KWRuPgx6Cp01s45Fc82HTXx9
	 qLr3dHdHCdIag==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Michal Clapinski <mclapinski@google.com>,  Evangelos Petrongonas
 <epetron@amazon.de>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Samiullah Khawaja <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Andrew Morton
 <akpm@linux-foundation.org>,  Vlastimil Babka <vbabka@kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,
  Brendan Jackman <jackmanb@google.com>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v9 0/3] kho: add support for deferred struct page init
In-Reply-To: <afcdDm4aAJvNaQqH@kernel.org> (Mike Rapoport's message of "Sun, 3
	May 2026 12:01:50 +0200")
References: <20260423122538.140993-1-mclapinski@google.com>
	<afcdDm4aAJvNaQqH@kernel.org>
Date: Mon, 04 May 2026 09:53:01 +0200
Message-ID: <2vxzse87392a.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0AC8312000F
X-Rspam-User: 
X-Stat-Signature: 84oya3bturifjk19mn9u4n4hwprrujkr
X-HE-Tag: 1777881186-772222
X-HE-Meta: U2FsdGVkX1+hm07e2iy1cZxLJs+oQL87Df3Dz8Fz05exZvrzjmT/TOxZo4beojnnk6Ux11lfAjKgLWHjQsQD2362RirK7LTAR5rWwtxioOyxB10wjRsD4EhxamsAc3WhJ564xkncWSjSLTWfs+RSTzMVNiTa1r5Aw1gVvQIGBxrPc+Sw1V8optId7kBoOLzk2+ZW3COsiQxpeLAlIiR9vEs5PNHST6XvIig6TthF9qgayzrItuR17PNVkO3KmWBj7RSLHtEs+8f37TAh4XNoqwdq2Ow51U8xpjQ9D8PvdZEJ0yjaLypOA/bIhYdIVgeOGyXEMcV3zHspxZ5Mg5pc5OCE93vpuczGA1aUlmNsHnyN2z/WHq5uZ/iuS3RnFYG97vQ5NZDXz5PhDeePIsJCwuTb+o9W4gXA5s3UR8egIuiApVtyqwgRMQRfFnaYtvEAwGWjj199+hql3b300W59PZGrPbukQ2jElh6n6cxR2l4co0oHLcXWuc8ZxghJfCUKJA16wyWP+tQWS5u8VCB8HwhmOivZBDJ6Ass7rqLpNkm71XsWF80Qui2sSA24/K+9fkzyDddXMNYSj2TOt0b4xuws7HRpacGYJe0KfzPSvKuZXydkwntHWHpV/0vCH16zGOazz26Hd9u8cSe/TwjlseLyzvXYSMrY8r7HRHWB4YEmPEpsg3ON7yykywtp3MAa3SrrHqIDMcn9P0gFcawt9xywfr2UR87GDqpsV6pTGhUb+WYBJ1/h1k40TjV4d+hXZw934xg7sNNo8pVftannQLvroTSax57IPbMIDXOA4SV+jQK1syUbLFBWjjgkR3uTuRZgcrOL6NX3DyDrXUZ6KHi7IbkE0U0ebfwtmgb2fDngvpVtpUGkA1a0Oam0ljlXpkdqJkMe8IUsFGAimEdp3bHskYTdtTnTvvcGVPzTM60RjbY58wG1PDUwRuD4P+fikA+yv16l9LehujbLt99
 /Y+g8tRm
 rhqUxfo3hvjVBxpCas8zlzsdU9v5ikJ0eC7xSZW3Pk+GFoNrzIfNf8+ZT3awI1hC8hnEdjtXaWKxmGDI3rHuhA2fk5GRvX2LxpCeF3h0bMz/3/cRSBDIZ7pHjPPB/0CeJ4i/s3RZCLYdMCwxIxXASo9cB4N68915kljfyy1g3F1ZFiNdHRO8Ha1cbe7Pev1cCYXWd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, May 03 2026, Mike Rapoport wrote:

> Hi Michal,
>
> On Thu, Apr 23, 2026 at 02:25:35PM +0200, Michal Clapinski wrote:
>> When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
>> initialization is deferred to parallel kthreads that run later in
>> the boot process.
>
> This patchset breaks memblock tests:
> https://github.com/linux-mm/linux-mm/actions/runs/25259346624/job/74063911769
>
> Can you please send a fix?

Would something like this do the trick? It fixes the build for me and
the tests pass.

I can send this as a proper patch if this looks good.

--- 8< ---
diff --git a/tools/testing/memblock/linux/mmzone.h b/tools/testing/memblock/linux/mmzone.h
index bb682659a12d..8d934ff5b080 100644
--- a/tools/testing/memblock/linux/mmzone.h
+++ b/tools/testing/memblock/linux/mmzone.h
@@ -35,4 +35,8 @@ typedef struct pglist_data {
 
 } pg_data_t;
 
+enum migratetype {
+	MIGRATE_CMA,
+};
+
 #endif
-- 
Regards,
Pratyush Yadav

