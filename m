Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B9B5CD3427
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 12:59:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2942D6B0005; Thu,  7 May 2026 08:59:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26C256B008A; Thu,  7 May 2026 08:59:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9886B008C; Thu,  7 May 2026 08:59:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8316B0005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 08:59:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AF1ED1C10CB
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:59:42 +0000 (UTC)
X-FDA: 84740630604.10.42B8D5A
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id EBF93A000F
	for <linux-mm@kvack.org>; Thu,  7 May 2026 12:59:40 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rq2dqH3L;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778158781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N+8on1rJhIM7gFzPDRKP1K79fhr5fu80l2DgfLVZ7Hc=;
	b=FzyrPPR1Bfv3Zra3qR5ECvzDqxiRp+cmb7gRc2kUmY7xcVVYpuDtpyonbQR32nkwbEzCb/
	OrhJGAA7YjXzpgf+Xax2IWUBoYcf6NsDLYOD1K+Ml0Cvaj0cWtVvrF2tu868u7Af13wG6R
	ZV+YPtlinuBMjRZhJFmIKQsydrKczSc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778158781; a=rsa-sha256;
	cv=none;
	b=MAIDcjGO4KDMpzgVJuVtjQzeGUQ3KHbD1Xfb/CR6T5dKCMm3DqjU+KnL1175lIRXanLxsz
	ZMt04bRCJ2jBpM2HgS32nLacjxUmmQE8E5kB/iLZ8EKuKhvkj+6fQecHe/2SFI2GzyzpjR
	0qf8G+w3yDezWI6xbTM/WqzlYVdv6G8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=rq2dqH3L;
	spf=pass (imf25.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778158777;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=N+8on1rJhIM7gFzPDRKP1K79fhr5fu80l2DgfLVZ7Hc=;
	b=rq2dqH3LbsTDkNm64j4yfugrxYnuo1K5QSVNxsj0wf0x+gTd830yL//sZ1zls/YfFle5Ea
	rHimXqQZl2XdEdZH/pVmBJ7KEOCjfln0xEgi5Y+CUNGbqvdO6qsze8DrzkZ4nbLBf6umJN
	4C9u2RSxqusKL26SGb9MF9QMwi4Tu3I=
From: Lance Yang <lance.yang@linux.dev>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	willy@infradead.org,
	songliubraving@fb.com,
	clm@fb.com,
	dsterba@suse.com,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 06/14] mm: fs: remove filemap_nr_thps*() functions and their users
Date: Thu,  7 May 2026 20:59:21 +0800
Message-Id: <20260507125921.6325-1-lance.yang@linux.dev>
In-Reply-To: <20260429153538.727855-2-ziy@nvidia.com>
References: <20260429153538.727855-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EBF93A000F
X-Stat-Signature: ttrzjn14qhgsjkkw1md794cqn5cdkh4m
X-Rspam-User: 
X-HE-Tag: 1778158780-15967
X-HE-Meta: U2FsdGVkX1+9IRYHwMF/u6EuTUEuuouSVwGmAd70HmeEGGMrL50KbV7zeLH7yEo1koiiGfCaz1fz+UU2ayqUgBCCJh1hFrcpUwUPMRZqfE4Q/g8a7W7SuAa6RggAMiSsocUrb6Do2Zejj7Sa8pg8XOf0hHYk4MDVMBhvERgdIdlUYjJdlNaczOHwNcR/DhEdXLCni/iDqVc2O7/IRR+CX1ydY4WSeroaW0tb/UsVrsuMCJbTJ+XRNGDGANmgIGVBd7R/F3lU82wJxRtFuFL2pJUos81CEV+0saZVaKUl5gbirk9niT5Ihk3HNDJAVBqbJnt5wYX/YdEjjSLH4H9vTiqeLi3da68hz4+RBU1e70tBl3NWaICbSnUk6kU6L2T0TYoeJCEMePKVtzndqC1XG8PXgrDHlDTtaU0GUWDH0lxfUzK/OH4Bc6Re70GQLQM23n1pBTkvLKTsm8BxMOuIVENvjBAVWLvzKMgwQeZlG6A66cdzw44JN1A4YhMAe3UduX5l/+87JBpINxOC/wALyHJiwfzT8hUGoGltW9fLXUaWmFQ1bO0Kh1ux1U/eJ9QTYyRFBB9oXtWPszlLg7Ch1uD9D5KY0bW14ZY49iyZmqsQxevMEQLMcQ77KFROSiqKFXC3frAXSiznL5ZZ7Q+v3dNVFu/oMHX7RFLbUb/VM/r0Bc2mI9FC59Vo2AzNkY5fyCXrp4jh9oQ6Y4meOc/DCQJMpCg3yPliEypne9h7H7zjwcTe24w2cr0NqP5NdUF8dGrRwiutuwTMY+3DkOt3PWqIkSNMwvuazrX5VfNAMSA/jMU5k1nhlXrkUSBAMReTELOZlaJvfBJUo5KF1ZBOREUZj0nbLY5qX41LgT73sWV4rl80t1k8jeigfWc8mTIBXx7EDXM/Tm2WjS+cXLEjo4vf5pGGmRCejKvX0IGTIJiELHYOl8dWnGOPEBhDgHntjrXWgT4xZsPD6gOLMfS
 N/PjIEiS
 Ie6UH2LEJjImhL17Nx+2oCOKtqqcqKNgFf+6i5tRICrgrX/rGoa0T2omxHI3gJZdPw6a1deqqM9ayFnaiXt31wJkOepsnc7lu71d5aUA1kcpBYgyW/uPX5kg6W5sZvpWktr/VyOoebcVexo65E5MuNgF5EdMwnhveeGOSxUpwCXhRqa3GxfsL3b/+H27TjOooDP6FoOJzijgY3TE5mUlS/aWsI9FcPPaIzVMpQzi1EdVjzaYTsSwDMq3sO7xZ9reoHeZVG4KN4BDyC6U2lW+TxR+KTUGGgKtJlFriLL6lW5qhOPGL4z5RQobzlWgUMffjq7Qx/coQ3IT0KUao0fTe4W9MKtPlokCelaEu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Apr 29, 2026 at 11:35:29AM -0400, Zi Yan wrote:
>They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
>large folio support, so that read-only THPs created in these FSes are not
>seen by the FSes when the underlying fd becomes writable. Now read-only PMD
>THPs only appear in a FS with large folio support and the supported orders
>include PMD_ORDER.
>
>READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
>smp_mb() to prevent writes to a read-only THP and collapsing writable
>folios into a THP. In collapse_file(), mapping->nr_thps is increased, then
>smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
>do_dentry_open() first increases inode->i_writecount, then a full memory
>fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.
>
>Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
>since a dirty folio check has been added after try_to_unmap() in
>collapse_file() to prevent dirty folios from being collapsed as clean.
>
>Signed-off-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>---

Nice cleanup! The old counter/barrier trick is no longer needed;
collapse_file() now checks the thing we actually care about ;)

LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

