Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24C0BD20692
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 13:34:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57BB76B002F; Thu,  4 Dec 2025 08:34:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52BD56B0030; Thu,  4 Dec 2025 08:34:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 468306B0031; Thu,  4 Dec 2025 08:34:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 38BCC6B002F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 08:34:10 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4C35B6258
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:34:09 +0000 (UTC)
X-FDA: 84181882218.06.478BD4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E23F714000A
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 13:34:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tlhw2Krm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764855248; a=rsa-sha256;
	cv=none;
	b=0a5AtAY5LrTaqCfva7z87mKlbV+YNcJYP9FaHOfKkYj1fKfNWBPdVFcb0QerRMHFf9Sncf
	ieFOu05L6IaMZQ9ZgrV9Yj11dCw5Fu9Qm5dOeMOV2RFnM+QKJMFXiERsUu/2VBQ4Wko4TO
	8wUYvTlVDccgAPohI3MUl2Mn8CzJFqs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Tlhw2Krm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764855248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iv2vFv4rTzg+g8D/aoEeKHyrOtx7EkECBIsctBYD4b8=;
	b=h89ucVefbLqAzC10kUqZxnHttSqSBkCwzVDa4CMcGaF2Fb/M1oEMZgl2YxN8Y/04IcpPHX
	D6K2rNqKPb9u77Las8m+LRmbMkSbNkW7xdpuczsmRPWtLHZfKsmH40dR8VmzjloYG52fQy
	XIkGliLRfscRJuuJp1TUVUy7EPinOK4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 359DC601E3;
	Thu,  4 Dec 2025 13:34:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E59C4CEFB;
	Thu,  4 Dec 2025 13:34:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764855246;
	bh=Lj25H6jCgokXTJy4WrsUG5umeuYrwquhju3RT34kAyo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Tlhw2KrmSin2tEXioAG8hYKGfmommZ1ZKl0H1+L4rHr2n5Qnag2wR38OQ+QSNyYsn
	 bPlZypHtUtiaRtAT1Eqn7T6hf2SKKyD3r887vh/i4YapHs9v/kiAMCdlx6yBG/9gl/
	 yqUWPjNLr2yI9zbP6kwsrhGpUQ/jCFxfItxe9MqZNYkeW1KAalXf2WdLIJ69vKSnof
	 k/ZK5bier8U5k0Wk2LbwHrlqs0+fYrw6gja5cjzIGhtpMuL+BPEJZOV+p4aGkjm+oV
	 SHnpz67HdZJtDa23I+8obx7rQMoHvaaoyfL4TDXqZ3xGTZwfpjMFpy0lCbw5e2MnTl
	 +MMfZqXe2hScw==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,  Arnd Bergmann <arnd@kernel.org>,  Hugh
 Dickins <hughd@google.com>,  Andrew Morton <akpm@linux-foundation.org>,
  Pratyush Yadav <pratyush@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  Arnd Bergmann <arnd@arndb.de>,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Kairui Song <kasong@tencent.com>,
  Christian Brauner <brauner@kernel.org>,  Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>,  Kemeng Shi <shikemeng@huaweicloud.com>,
  Guo Weikang <guoweikang.kernel@gmail.com>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [v2] mm: shmem: avoid build warning for CONFIG_SHMEM=n
In-Reply-To: <5e40dd55-c9ea-4387-bd9b-7a4410df9898@kernel.org> (David
	Hildenbrand's message of "Thu, 4 Dec 2025 12:03:02 +0100")
References: <20251204102905.1048000-1-arnd@kernel.org>
	<93782526-c198-4590-b96b-c4f630b8ecbb@kernel.org>
	<aTFojchpaTywDh1D@kernel.org>
	<5e40dd55-c9ea-4387-bd9b-7a4410df9898@kernel.org>
Date: Thu, 04 Dec 2025 14:34:00 +0100
Message-ID: <86ms3yl6bb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E23F714000A
X-Stat-Signature: u8siyidf43e9nskfcyf4mf4ziot1m7tb
X-Rspam-User: 
X-HE-Tag: 1764855247-845390
X-HE-Meta: U2FsdGVkX19S+AM89GZ7FB6U2BamH9K6yPSh9DBxEu0HnHxlMRIl6fUp7V8VOiPe+oppGpPs1RDjNwtgvONcov+BG+O8QDFGjc5ghK5z3MDGouH6G0W0+oV8AHtp28dzSlqngsYpo30GEPBIZZSF7hLsORQ4LpOjMPFbqrfiCBW9PpqWeZ7vNA/poW/a5zMfdElVWhK4xJu3eAseL3ZhqsaocSj5jtluaSAgrCQp4CIl5+cu1wNrWlB62WipCCa79pGEklmtVg0Y/59juYvYHQPUPIXhKNTaD+V2KAyGnCbcF1o7WS3CP+g/2OJEmXjTdHtctd3UE86cFx0rCgfJDGTWzRdJCpHG65KmTC5sw1ji4vBZf3wc49wRDXvH/kqypwpm5/6nmOO4qPEAM1CneTP6aC6nnJlYcuBMJiTxEfPjVilLDisKlDPiSPLET8i4LzRD4fXuA/L3P5SP72X1JLiGR8mmJPJ0eS8WO1337hMp8C6t3dQjHV4bB61Lce43RYuRrm1s7jxH/hg82DHecGIGoh2xFFvLl2m3LOdYjqV/NFvNB0sex24htzUJCiiKChUp1CYX7ItjrPGY0yt9VljzDS+abpuQSPAvtE/DJUBRcUibYS+B3ClsAE3wvPoZXiayTbKtZS2cFdprvXgxL9tmTvFnjLn/WUTad0z+E874azk9US5YyxNM13rLBLrkKjufwYjo0tPGKqmnAktCZR0mzAN+YjFWCHfqJEmA/e3ppwN4I9YLbmiERMfoT5AE24eq+595B2Z6sYIscEk5I8t4zWk5yEdilOQw/6wAk6dCrihgT5jMFeIGk/xZ69CkDxqWjptNIC96LDpTvW6qe7cIPobRCEOfbHFyoJHuXQ3IYKd2jNAv7gHiZUpR2fTQD97nR5y91xWsqXrnCaJJSxncvA1pM1OzKmzwJwmhcxq4lHIIIXdjZdiZh+yDaDzQXgMWkTSu4JhC1Zyhnjn
 gyLTeVYd
 gq8+y5giKbb7blndNPZjxKcQHlLBI2JgGGNgXq/m0dt+W+1k98cHBKt9MYD0TUFeJA58232/qDR/TdQ/sM1FusPs0egIFJu48EHxW7Xlwh1IAJkS92rFT1WddUKcI2khFhDgg0eZHqdMAFWkwf2xjTSjnxO2Wx61u7cMGthVYlCtM6SpHoFr8n/nQgfY+KRgdgTv+b0aAaoJ3pl+2D2nsM/sH3Xz5BOrnJZPhzXtj1gBGbbyxD3ugqE8e20V3ceT1ACX3tTo9DYXLQLGEI0xvPG5CS3n0tL13oIeyyPB/c06vPNKeNcwiqUC6zL9VTydqH46rbosl67+UtxH6Omm3fd0sdsaRNAKYl031k2dToExOVuepz4gUs9959A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 04 2025, David Hildenbrand (Red Hat) wrote:

> On 12/4/25 11:55, Mike Rapoport wrote:
>> On Thu, Dec 04, 2025 at 11:34:24AM +0100, David Hildenbrand (Red Hat) wrote:
>>> On 12/4/25 11:28, Arnd Bergmann wrote:
>>>> From: Arnd Bergmann <arnd@arndb.de>
>>>>
>>>> The newly added 'flags' variable is unused and causes a warning if
>>>> CONFIG_SHMEM is disabled, since the shmem_acct_size() macro it is passed
>>>> into does nothing:
>>>>
>>>> mm/shmem.c: In function '__shmem_file_setup':
>>>> mm/shmem.c:5816:23: error: unused variable 'flags' [-Werror=unused-variable]
>>>>    5816 |         unsigned long flags = (vm_flags & VM_NORESERVE) ? SHMEM_F_NORESERVE : 0;
>>>>         |                       ^~~~~
>>>>
>>>> Replace the two macros with equivalent inline functions tto get the
>>>> argument checking.
>>>>
>>>> Fixes: 6ff1610ced56 ("mm: shmem: use SHMEM_F_* flags instead of VM_* flags")
>>>
>>> That's still not upstream, right?
>>>
>>> $ git tag --contains 6ff1610ced56
>>> mm-everything-2025-11-29-19-43
>>> mm-everything-2025-12-03-23-49
>>> next-20251201
>>> next-20251203
>>> next-20251204
>>>
>>> So we can likely just squash it into the problematic commit before
>>> proceeding with it?
>> It's mm-nonmm-stable, I don't think fixups can go there.
>
> Ah, I only looked at mm-stable and mm-unstable.
>
> Confused why this is in nomm-stable and not mm-stable.

The patch came in with the liveupdate series [0], most of which counts
as nonmm I suppose.

[0] https://lore.kernel.org/all/20251125165850.3389713-1-pasha.tatashin@soleen.com/

[...]

-- 
Regards,
Pratyush Yadav

