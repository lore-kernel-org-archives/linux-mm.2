Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7BB0CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 13:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D068E000B; Mon, 22 Sep 2025 09:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEDB18E0001; Mon, 22 Sep 2025 09:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDCC18E000B; Mon, 22 Sep 2025 09:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C5FAC8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 09:50:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DB8F59BEC
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:50:53 +0000 (UTC)
X-FDA: 83917021986.01.17C0C06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D7B3B2000B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:50:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kHXRzKkn;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758549051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iYBD8SMIk9k/4TXRQEY/8FtrovpCG2qHec/AObdXDc=;
	b=gFDwHRe5wrqxFvLCWdKqZTp97AohJtcd09iguB5xEBEigLr7EWFhhsNiC7xk5JQNRQg7W5
	okfWu981MRuxnHP8K+QXWQQX0WmZiZBt7CA/vFa6ZnVlCrUcf3Ku+5muLIRdeG+WKZPlHU
	bJ59hwMyqpAt51mPxI9KrnkLRe5tIJ0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758549051; a=rsa-sha256;
	cv=none;
	b=hz0fxNL6ECFtOD33E7Re3TTFLlFQ0jbLauY5Vp9RKHFZ/kmnI0rkD2+FrV3JKixfjgq1h/
	QXHNaVoCSV/+DmQcPWwYh1T0ZkLysnl04o9UyVJjO8ADBN38mNiGq+Tjp1y0JQEtWlKXG9
	FnPR7tdNetWzI7lJE/dC4KvMbStkxXI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kHXRzKkn;
	spf=pass (imf13.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C4E9343816;
	Mon, 22 Sep 2025 13:50:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B75E3C4CEF0;
	Mon, 22 Sep 2025 13:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758549049;
	bh=d8t+hPlDB0nO1VCV/5JqDtENUCr2tcakVRrmCSOG4Ac=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=kHXRzKknA3A9aDX+Xz4lbLB90q+PBv33eJfoQmsaLhGOv1tahF6UtQxvL4LPgamsz
	 t5rltBbjHiXOXBaIQ8GXVHEFuNa4IUu6hHP55+CClRyl9Jw9qBab7s+lj2ZLSzSwE0
	 2nVOz1InhfwHxtwZShWt9xa36LxkWLfKVBmhuogVea0VBtzaEoSCScVdh9pM8AOqlz
	 YDAPPY3zBoEUwLTXr7Vzl0RDcIzG0jf3tcO8mz+pWJ8x4ZFRN5eEfZk2Meog34jjTm
	 0hgRJoKPS0hhuNJDPgtvie5eQX1nGMYKMFqk0ZG0V091QLWQPTYjmQDB9nrEPj3vx8
	 U8HP7CeoJb1NA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Baoquan He <bhe@redhat.com>,  Changyuan Lyu
 <changyuanl@google.com>,  Chris Li <chrisl@kernel.org>,  Jason Gunthorpe
 <jgg@nvidia.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] kho: add support for preserving vmalloc allocations
In-Reply-To: <20250921054458.4043761-4-rppt@kernel.org>
References: <20250921054458.4043761-1-rppt@kernel.org>
	<20250921054458.4043761-4-rppt@kernel.org>
Date: Mon, 22 Sep 2025 15:50:46 +0200
Message-ID: <mafs0tt0ufvex.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: c6h4uzhtkmggdeemfinf8cdx11hf5on4
X-Rspamd-Queue-Id: D7B3B2000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758549050-289451
X-HE-Meta: U2FsdGVkX18cgAoQ4lmYNQh4i/EIBk+YtejEmZ5jYcB91qk9A4t+zbV7LMxg5biy2GEyzDpPmMwxtUDLMu/2e000eTOeTUFKTq+EHe6TA9j4kTBQwWlqdioLhPe/ntjUWHncX2E0/is9pQVkWcNQ4f0hVLCSXu5lTC4VTJxGDjrxH4xWU9mnae5ozerIjjt6Tl/GufjkepF7uqO4T9/GxNX/G3EDZ/y78WanQmWB7kM1Wocxfl+esfjRtz2RrKHOAWskSGzmssHLs0HBbaOtd2kH/JZ7jGxXbF/2dZxF8CIWu1HGccn6UAtTHdXWEFoCLGxDmuHvA+v6QlEsNGhVTtgkdd67NSkaLOb7mcazYDM9o2omSKjXHvEGNoy7rWEOAJU93wtX1HZwS/cmCBBna5lrwA+fGZxKme/wqRCvD8Smi14PjLCDyH0oJCLynaXujSdw3+Cas0pM0Z7DE2r6NgWk77x+X7izFT+VeXjjK06CMu2z7/xVbad6Ji55B31e7nEc9Dtm6AsdIcLF7wxxwZkhBIvlvKrq92CEetGpkHj/KCWrTNUTancSKDGX0Jafec8fkEVuTPxJeeL7iC9+oK5D8XqEuOrQeR05aYhifdfN0GsKzSO1GzTQVpLcYvZ93Tq6EXRNVBkdQI9g6sTHDDX0h02zfxRezDM56yw2MUL830DCLfYN6YeNSTj3sZbCgzrfzUklCVkDGepz190P4wfBiz4kXGYUq6CQFuiLNhwiZlWPJzYukc48g56+TEvckB03IWX7QkAlCD2dWpqjof+nalpkHEngapTCja3WItW0DqYj6pqEN/Udrg+VJSOnvbUHgTOE9VI5uPPyeKbJnYta6q/dHa4hHHeqU6qWFWnblxxWR/oUQBHHerxaLK4QZP6HUYeKNeB1OWkYd7yPNY5vH5UcMe4KU66keRm2u2kzHBDyIgopqdDyxaUoOO+zPawz1qzJaG2HCrcUImM
 GmO7bw1g
 nzWjXWFuSSzhhsfb3t2vM3dIRVItPLiKtBfgv0qwz+RSUbjJGhDN2AZqiNDdKZOj2W4thOW9uxqzZLAmkZs68FRAdW2kHmS5iy9Sn+8EjE4+Wv2Yu7pqYVyrZkk9t355wWpXAFTx5JNI+KuJoq54lZAbOZoJbZBJobHMso7shSHbnqUKu/76DX0EMN5HOcAEIKrusTZ4k6JYpA5DN2VmESOEbNgwd23623L6wRh0WdWNK6Hw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21 2025, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> A vmalloc allocation is preserved using binary structure similar to
> global KHO memory tracker. It's a linked list of pages where each page
> is an array of physical address of pages in vmalloc area.
>
> kho_preserve_vmalloc() hands out the physical address of the head page
> to the caller. This address is used as the argument to
> kho_vmalloc_restore() to restore the mapping in the vmalloc address
> space and populate it with the preserved pages.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

For the new kho_restore_pages() as well:

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

Thanks for working on this series!

[...]

-- 
Regards,
Pratyush Yadav

