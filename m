Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B1F7606D821
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 16:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hFPtyt1W
Received: by kanga.kvack.org (Postfix)
	id A9AB96B05B7; Fri,  6 Nov 2026 11:36:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4A186B05B8; Fri,  6 Nov 2026 11:36:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 911E66B05B9; Fri,  6 Nov 2026 11:36:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64BD16B05B7
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 11:36:21 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE1F040146
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:36:20 +0000 (UTC)
X-FDA: 85405246920.24.F4572FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5B031C0006
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:36:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFPtyt1W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793982979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YOpzMaze85kA6XBFXM861p8qWghg+m3macQSZJE7kdw=;
	b=DxNtnSh9Wr1KcyXwfnRfHdjaNXaSYKKL45/1LuCrIm5Q7RXzfUrASOI/p4tfgqezRIl2HK
	Y19Kd44cJ22bXDNQ2TRV1eoEuBkDcPE1yZ7i5OTAfnT3jH570TocfPxuHKGNZJ0+gVpYAx
	/uuPXy3AKLP0uzeOFqYNlLUlgU+N73g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793982979;
	b=JUVFqMMCpu95GBqqBwjUOVK7qsADF7R36gi3ef4jTI3ppf3YekMuu6uTwbKvZSt6y5v+h5
	Rb7I9K2kL0X4AV8U1bRyamGrU+A9n19GsrPuKB22UPstHCr7jzGCFmjJ5YrdOhw90HasvL
	jaVUDMNLPzcsqruiLuUZOq5EYgPSvkg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hFPtyt1W;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C09E841312;
	Fri,  6 Nov 2026 16:36:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C63A1F008A2;
	Fri,  6 Nov 2026 16:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793982977;
	bh=YOpzMaze85kA6XBFXM861p8qWghg+m3macQSZJE7kdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hFPtyt1W+JPFYy4NQPQqI1CvxeELRgPbFlF6Bc1SIFP1TEZNH99seVoKh64cP2FHO
	 t/JO3hexch6BiIsLSjze6zk+LOXwhJmLLAMpA1KqqFNwcQ2iIvSCVHOoE3Ofx+EJox
	 Lp4cyVhE7+7Rjwr3rPMMhvrtlk9UpiHrxrTtxT+W9oVJWHI0s1T5yUHSjN2urByVim
	 NyprraPbisZsOBJyPTd7xZt6ZmjJdku2UQRzGCGuCbkntaK2GOP5COVmBCO1xNO8rD
	 cG+4QhhGy+gK4tGEKTF6TwHPjjIRZBpHNUVsnhJut38Vn3xVDK2MEDFxWRsp9X3LRw
	 RmAfxb6xjkuEw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	linux-mm@kvack.org,
	david@kernel.org,
	yangge <yangge1116@126.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <21cnbao@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mark Bundschuh <mkbund@amazon.com>
Subject: Re: [PATCH 5.10] mm: replace free hugepage folios after migration
Date: Fri,  6 Nov 2026 11:35:53 -0500
Message-ID: <2026-11-06-1-daily-reply-0018-mm-hugepage-folios@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105070150.3093908-1-mkbund@amazon.com>
References: <20261105070150.3093908-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 64o86ow8imk9usa5tt6ktdhhtb3c3d1q
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5B031C0006
X-HE-Tag: 1793982979-944035
X-HE-Meta: U2FsdGVkX18pkmCzJwpx+2umORpWPSmsCIqPVUrohNwXvoLVMvju2ZlWY6mCMAvQDwKRDtun35E+bb2MOYwNi9d6QnLjZUanf+3rrdwc+GvVAhjQUJvXWoFo5CYkoGynkb+JOwyCOV1N/eg6a0Xq6Y5hgegPNQ1wpsp1r3zpnnGYoGYG4X8aWz/LcksxDHo+TOOmgQEUNGdP5VodubQQstscBS5YrO7zKqj0V6uYtjpDBDF6A27BqAZbB75T5tb3ctcRKOwxKANtY209dxl6aGRoJLoaHtNgrRC/gg047karFpkOhdKrHg1bejgI6eB9X2oLApT0hMTjadDTtcY9frrBO0SNOuzu5XAcE1Zp+UtXJbVpcsBeL+KFNCgFs4lmTa0t5y1LJQ0pQpSMbYXayyqWbCHvEHK3zz7m30yVLRyVWbkG4EsWC9q9AZuQuVgmH0pdai3Ndekn/lxbTqfFEMjLpaE6fzt70LpsY1ywl7cSw5KjFae/SlJEZ+ZXmdFqzLUnEz1W9yLVDv/kKArFPyW/JByT/x80Yb9aDbrbJuXd9ATCnihn6bWbyuQLTZTpvNH3S7eA3t4G8n/txmcAPJ6Sb8FPwhgeznro1P789IXbC24iw6Imw6Y9vGGR5ti4DwTGOABJWpsdUwdRypGKV1J0Gr4iqMa+CTvkhB53DfMmZaW3kziHbGaERp5tbjro1mFpAOhwLUdguLksmiICK5THdmhJ6ynODKAcyly2TjLHhenwAcU0Ouz1z7UyIipw4oytOVr18RtX7iIg3YVyRooorzxu0C786n2B8sJRfs7rvmNjfZBRFfE6Tv+Mu+SdBAJAK5jv+O4ME7H9TYPX8k/Mmq+kwO0FF9U37wftbD7pf9hRpeG6o3TpVO8roU0Am6s7SXb7MhZ8nYbrooYoolhDwiJs/d2nhD9DLetyVVPBdEdmfE6l5S7rErPZxu/f/FjhS5ekJ6m/lWs05jR
 bQ68KUVj
 RExUFgaVqslFsPgUypJQ/rbLbKxnC7Q1mLuFmF8QAWj4UTCISd+Z8XwEWIom+5InhTJH6rh+atIGgUqAVWriVNeJ91dnxsUQa6AJltKU8+TKUxjGmkC+h+asY4SgbOfsQOdPEcnW4qtf0MxUjrapcK8vEUW8i+7ZUiqKlhY3iIGK3PasMKRKK8zgETE3NPyUScEaruL86YgRT2bXZ2K+rFwuxUBLd8Y0jqFzCBpdr9brZvnE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [ Upstream commit 04f13d241b8b146b23038bffd907cb8278391d07 ]

David points out in the 5.15 thread that this reduced backport is only right
for 5.10: 5.15, 6.1, 6.6 and 6.12 all have hugetlb migration in
alloc_contig_range(), so they need the whole of 04f13d241b8b ("mm: replace free
hugepage folios after migration"), including replace_free_hugepage_folios().

Could you respin 6.12, 6.6, 6.1 and 5.15 with the full backport? The acked 5.10
patch stays on hold until those newer trees are covered.

-- 
Thanks,
Sasha

