Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FB9CC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 09:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9638B6B008A; Fri, 18 Sep 2026 05:35:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913DB6B008C; Fri, 18 Sep 2026 05:35:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829D26B0098; Fri, 18 Sep 2026 05:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 61A5F6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 05:35:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F49480638
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:35:08 +0000 (UTC)
X-FDA: 85226374296.20.4E73255
Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf02.hostedemail.com (Postfix) with ESMTP id B464780003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:35:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7TZ60mt;
	spf=pass (imf02.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789724106;
	b=ZagyGPV16qS5jj/RYESKkFelN2covye0Vb5ASGbvUyHyeoant5g7QAOs4NhAt6tiB6tgkh
	HD2zFWd2i2kCFYh70OLtvhFY4/lNp9s4cWge3dOzWbmhUVtXbAVGd4Z2KUD3qJwR3xb0SS
	I5sndcKGoG081lnX2DvbeviZ8s9Gjnc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=t7TZ60mt;
	spf=pass (imf02.hostedemail.com: domain of dongtai.guo@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=dongtai.guo@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789724106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mMUmZK0P8YmnJG/+8kD4oWYLxaHcjZK2HJ/Mgo1W5Pw=;
	b=hc5e8B9G7PGZP8MtBFRSqTjWCRqw13EM0buxd/FgsJ4ThNL1036gNkQaiSTq1YS6bH8Ijr
	Qdei3u8DAbdvViGamtFkQwRDFeVqviCMTiwosYQIvulgYfg5lczZHycJUL2c8zBY/b5KSV
	5Gs1CodFbwTfcuEsdXd/Q/is/C4nz9s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=p/DQJd95U/7tkNehVUiamBQTKyTjZl52MTnDy+aDty8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789724104; v=1; x=1790328904;
 b=t7TZ60mtyBpGmXyqF9xUBXtjYq9ZtoFwrn0HSx2Ph+U4/WywNAhaY7HkNO2bIxtCLk/QXpXx
 ePKIRBMR7usKqfagJlrKT6QvXX4vhQ9JjEXuC8fYvlcP9wnXceW7kStV9BWvI9jpomfSYnSzZ8P
 /2Era6AfCaa01vvu6sABCWxY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c0e6a754c1f50c48;
	Fri, 18 Sep 2026 09:35:02 +0000
X-Mizu-Trace-ID: c0e6a754c1f50c48
X-Migadu-Flow: FLOW_OUT
From: George Guo <dongtai.guo@linux.dev>
To: pratyush@kernel.org
Cc: rppt@kernel.org,
	pasha.tatashin@soleen.com,
	sourabhjain@linux.ibm.com,
	graf@amazon.com,
	changyuanl@google.com,
	akpm@linux-foundation.org,
	chenhuacai@kernel.org,
	liukexin@kylinos.cn,
	guodongtai@kylinos.cn,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] liveupdate: kho: calculate per-node scratch sizes before allocation
Date: Fri, 18 Sep 2026 17:33:16 +0800
Message-ID: <20260918093317.12216-1-dongtai.guo@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <2vxz1par7amw.fsf@kernel.org>
References: <2vxz1par7amw.fsf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B464780003
X-Stat-Signature: 6ykn8by9ntq9i81f4z4rhqdbdyex9ora
X-Rspam-User: 
X-HE-Tag: 1789724105-449047
X-HE-Meta: U2FsdGVkX18jtQPIrLsFZbda3fcmy3lGrwG8mAVBzU35CM3M4ync/Ku3qWmcQfTnJ4uNpCPx/odZZ1O0nxDfHv9cSBmjc88N3WFzx5opNJUU6bhtlNPJ3DLDgbYpIXdIjok9savxMB6GhdqlpX4nRNrmtXhqyXaOF0p+MFBTN77rpg0IDSBmYeitlBPaiAZG4VX1yG+FdfXLbjB2TLNerBqZd98bIrLw74u3DmIvvRz6v7acq5LLgEAvfeKAcT+xIXzosnBbRWfs8dj5kzTpIXo7NlwOp5fcbJGxI4Cwygu0RRR1JLTDhpS2ukWQYBo3sDCIJLwAjjFY/+bNbgA0RN4na64I+qxYb90NIptXF6AEwg+v+F7SkYL6hq+LE/fpLseR3QPm/ONFAxWU68+Wlzm/yqR/n5DI0/AdsxfbfzNJ1/gYUu6MYoDN5vt8m02442m1O7cLUh4YQ7CvSozQgjuHpMHVfhImHAa97AgO/eCO9huI63znFmcHAxWCk9m2cVBVgmzZrwK3bXo3kcyjIAOXXZPYAlPLW6C2lPeEcxR/gc0wxxrDmAP2b9mdx6o9mXP/B11iyZvDN06uzsqB8ao+D0GWGLmtTyHwgPIKvyBhCs8z+LfwPPeyPInlcuxOxnMHiFqpn8tYjuaIx/fmn11l9XEyiXNACrpdBiHU83LNPipnfUKcWj0u6KaMJJFLYg3yLw+FIOf98PQc2RnmGwwZEIM43jXDQh+nIK0FoYo7o9WkazN0sadi0e2aEHYuLqc0Rh3EfO1ousrbbMf9fCKOx7wFWUL0P52pSWRikrDsTbWCfEHZ5+I6a+pzO+3ncZtOG1OJN68N1rBp0sp6xUROnwUjvdSrgYaAxCg7oHVRkyGAlwiLm4BXxPJX3hXQVs4XlknqviqKQ6RCYjA/8wzebYsO84lBC7I8rk2vRp7lUJF+PiAF/lAKB0zIAsIsy63SWkf7tsPNDMDI+hJ
 /JKyORDZ
 9sAkv8a/M61tnpERn0B6gFzPYCQA+Tdzr8qR8FEtGuMEG7s0LekfJEz2PpYI8COAT1Ry2jilceSwQetv7bueAYmfgZzN1jn4wJFr2IJQ83i71KxNJIZygrT+wsek/u5ygZnLfsn4AmwozmCkHtbxC5aLaO73hX3qBipT8Khc29T++C5t+cWx54E64Yugpz/hxf3p0s4KmmaxtneQzSGYyjFRVxzDKEkt115BBhhmg4Q3cXg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sourabh, Pratyush, 

> But in practice, this problem is only on CONFIG_NUMA=n and I don't think
> in practice KHO or LUO is being used in non-NUMA systems. So while I
> think it is worth fixing, I think we should also have a test where we
> enable CONFIG_NUMA.

Confirmed. My vmtest kernel has CONFIG_NUMA unset, and your analysis
matches the data.

I reran the vmtest with Sourabh's debug prints on both configurations:
same kernel, same QEMU command, and without my this fix patch, so the
default percentage policy is exercised. The only difference is
CONFIG_NUMA.

Without CONFIG_NUMA:

  KHO: Before low and global scratch allocations
  KHO: low size = 330185 KB
  KHO: global size = 322 MB
  KHO: Per node 0 = 672 MB
  KHO: After low and global scratch allocations
  KHO: low size = 330185 KB
  KHO: global size = 322 MB
  KHO: Per node 0 = 672 MB
  KHO: Failed to reserve nid 0 scratch buffer
  KHO: Failed to reserve scratch area, disabling kexec handover

With CONFIG_NUMA=y:

  KHO: Before low and global scratch allocations
  KHO: low size = 330197 KB
  KHO: global size = 322 MB
  KHO: Per node 0 = 96 MB
  KHO: After low and global scratch allocations
  KHO: low size = 330197 KB
  KHO: global size = 322 MB
  KHO: Per node 0 = 96 MB
  KHO: After per node allocation
  KHO: low size = 428501 KB
  KHO: global size = 418 MB
  KHO: Per node 0 = 288 MB

In the run without CONFIG_NUMA, the reserved-kern sum the sizing sees
is 330185 KB, which is the 98.45 MiB baseline plus the 224 MiB lowmem
scratch area: with memblock_get_region_node() hardcoded to return 0,
the NUMA_NO_NODE lowmem area is counted as node 0's kernel reservation.
Node 0 therefore requests 200% of (98.45 MiB + 224 MiB), rounded up to
32 MiB alignment: 672 MiB. That no longer fits next to the other areas
in the 1 GiB guest, and KHO disables itself.

In the run with CONFIG_NUMA=y, the real node ID excludes the
NUMA_NO_NODE regions, so node 0 requests 96 MiB. The allocation
succeeds and is visible in the sums printed afterwards (330197 KB ->
428501 KB), and the KHO selftest passes end to end ("KHO: found kexec
handover data", restore succeeds).

Sourabh, this also answers your question. Your PowerPC system runs
CONFIG_NUMA=y, so the node filter excludes the lowmem and global areas
and your numbers stay flat. Your experiment and mine are the two halves
of the same mechanism.

> I think on NUMA systems the problem is the other way round. The
> calculation for the global scratch also counts per-node allocations.

> So I think the proper fix for scratch sizing is what this patch does
> and then a fixup for the global scratch calculation as well.

Agreed. For v2 I plan to:

  - Compute all scratch sizes (lowmem, global, per-node) before any
    scratch area is allocated, per Mike's comment. The sizes are a
    function of the pre-allocation state, so this seals both feedback
    directions at once.
  - State the !CONFIG_NUMA condition in the commit message. The feedback
    described there is not unconditional, which is what triggered the
    question.
  - Add the LLM attribution Mike asked for.
  - Include the CONFIG_NUMA=y vmtest result as coverage.
  - Look at the global scratch calculation on NUMA systems as a
    follow-up.

Thanks,
George

