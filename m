Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 138F4FD0655
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 08:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F62E6B0005; Wed, 11 Mar 2026 04:26:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27CA36B008A; Wed, 11 Mar 2026 04:26:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D3DA6B008C; Wed, 11 Mar 2026 04:26:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F1FDF6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 04:26:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 773C9C268E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:26:24 +0000 (UTC)
X-FDA: 84533100288.05.8EFC444
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0630380003
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 08:26:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jouh6own;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773217583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hSDeUBJt08Lm6SKXqjUQA54HFRhwjxPVdke7bIKd/DQ=;
	b=WCNXSyWlbtPXX8FLQdimAtGOhftn1PPxzETwA6koDoGV53EEAybg8Rcl+qK4Imp/7mV4rF
	AoinJ3FQBri2wjEJ7D4eCxwZN55y+Ekal0+MH4bWL1Hj31Uf+sDlw7BlT7jqZDAuOnlzrL
	DmiNTpXo8pWUzyEGZSnS3XudtbBlzJg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773217583; a=rsa-sha256;
	cv=none;
	b=ElYnYdcfnQI/Rs3GzoJsV2oXPWnrXlsbGkkthCq1Y5k0ktlyN0HijF8H3tSOUnndMBHzFA
	MRIgqQGROk9MMPxA4ihyvxY94mlXd/i8QWWYZBjmC5m5ZRof2e3AvamujtER/fNQsNyPuC
	F1MKiylrEXeAlpocfEjgGb9h0PbVmWY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Jouh6own;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7F8286013E;
	Wed, 11 Mar 2026 08:26:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36483C4CEF7;
	Wed, 11 Mar 2026 08:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773217582;
	bh=6cBlhOKJedbx2qsxUWwykXn46F7QgKz0H5LTP9zsQ7w=;
	h=From:Subject:Date:To:Cc:From;
	b=Jouh6ownmsDl4uHhgu00E696xSDlRCFSswWYm3haODHphQ3DtOBX6PWXg+4yfs94t
	 r92hBR470/avu+bXQ2oood6mK9eTGsZd0ev+NBeBTcV8WDqLwtMhDRw/cGxSBDKqsR
	 zFbAXlBoWWigp0ggdKhKCVW+CuVU3Ja4+IAaE3PqqWEdOZtHqNqhtgRsEcpHTVQ6El
	 /vpmiZ4LxOxUhHok2LqtRbB74PQpXbT4A0XmOo1qasQ2sGHxlJRbMl/Psf3IWR39Vx
	 lSXJ6JOtK6kOqqG27DM/OMUILUteMJim8mPMjFgn4deLMtyN9UpLrGdQMNqqhhTevl
	 KIskA17y0tZ1g==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 0/3] slab: support memoryless nodes with sheaves
Date: Wed, 11 Mar 2026 09:25:54 +0100
Message-Id: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABInsWkC/x3MTQqEMAxA4atI1hNo6x94FZlFqlEDWiWBYUS8u
 8Xlt3jvAmMVNuiKC5R/YrKnDP8pYFgozYwyZkNwoXGl9xgrtJUibrzteq5shpE0GU40NpVvQyR
 XQ84P5Un+77r/3vcDrxYx2WoAAAA=
X-Change-ID: 20260311-b4-slab-memoryless-barns-fad64172ba05
To: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0630380003
X-Stat-Signature: eokdq5t4qq173cfi78o33spnnncq4zhb
X-Rspam-User: 
X-HE-Tag: 1773217582-736196
X-HE-Meta: U2FsdGVkX1+3cPa68TcXacuNocADSrxs6kZYKfTWPcy5EF2LNH48jjSsvzwvkCiPLD9odLRZGf6mJ0aDRaE7dygCzkduky1AdM7SbeklfuqId4YJF7Nzdvi2qYWNv8S9W9PeCFX9wSYCagdPYmBOgBVcUEFWxob/HQnFFyUQfmCRoyM+/8LLqZGX5vWgMibuVP8mkRwFuN/2Y0MqJtQ5WyEKCV9qajR0mQ0aEpZ1c28J/d5qzjdkXlqc/C1C+wHzS0qUkRa9gUuAlgE8MxJONwIx+8K3zUUfNgcjYDqiy6CTd1MS5h417XAnu8yXki6x4FtWe+5v2keJ+CMpXpn0AT2e3sumUJPgNNLz6hOwn4dSzQjUFOerMjpYLaF10P4mx2NkPzOhghdbJW3k1huLjwwICXKdq8rOkfNtZJgCNZAHFlj7bxl8rKaClu7tBjmA6BdSnaQs9gor23qpVgvlo/jQI8ZYVncktrF0HN+SOKnwx4EKZmKrMkyz5qCX3S0f+Zs+jaS0DjFeekrs9DY/jGpRqqUOkVMoL8/VXNiQXIVtCY5E4/evpDuU30ErgpaS+/ER3Da8w4al7T7Mk1/Ixs7P++2rZQE8S3VFjDcwhA5JfmE76S9SE6gmo1VI/uJFUBJugQ1RjeNyjkQQ0EMXaswZjcuiNBcfqoP1iBqdN+dQY2vltxBKdTQ1r+zrUb/7MTBXaEfKJ0Hh9OlMDCtx9l/Fy0/TT1R9ODexKCvO87D/46a+D39VpcsusPdx/6B4xDX80nSMWblKYz6b8YhGv2ylQ6F6oub69/nyjtebLngZDc1Bm2C4CNsCp1fHz15PycjD+NAtm1gWMDKbu6/9jnm1FkSzenAMuuJ/kw0Lnvzr7zvxVjNlsk69Vh6yQ7mdjiG4Te2flZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the draft patch from [1] turned into a proper series with
incremental changes. It's based on v7.0-rc3. It's too intrusive for a
7.0 hotfix, so we'll only be able to fix/reduce the regression in 7.1. I
hope it's acceptable given it's a non-standard configuration, 7.0 is not
a LTS, and it's a perf regression, not functionality.

Ming can you please retest this on top of v7.0-rc3, which already has
fb1091febd66 ("mm/slab: allow sheaf refill if blocking is not
allowed"). Separate data point for v7.0-rc3 could be also useful.

[1] https://lore.kernel.org/all/c6a01f7e-c6eb-454b-9b9e-734526dd659d@kernel.org/

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
Vlastimil Babka (SUSE) (3):
      slab: decouple pointer to barn from kmem_cache_node
      slab: create barns for online memoryless nodes
      slab: free remote objects to sheaves on memoryless nodes

 mm/slab.h |   7 +-
 mm/slub.c | 256 +++++++++++++++++++++++++++++++++++++++++++++-----------------
 2 files changed, 191 insertions(+), 72 deletions(-)
---
base-commit: 1f318b96cc84d7c2ab792fcc0bfd42a7ca890681
change-id: 20260311-b4-slab-memoryless-barns-fad64172ba05

Best regards,
-- 
Vlastimil Babka (SUSE) <vbabka@kernel.org>


