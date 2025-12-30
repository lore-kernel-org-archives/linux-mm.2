Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00636E95A8B
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 13:35:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 243676B0005; Tue, 30 Dec 2025 08:35:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EFB26B0089; Tue, 30 Dec 2025 08:35:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1F36B008A; Tue, 30 Dec 2025 08:35:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F040A6B0005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 08:35:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84C8352538
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:35:24 +0000 (UTC)
X-FDA: 84276234168.27.170BE11
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D115880007
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:35:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CWDE7nCs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767101722; a=rsa-sha256;
	cv=none;
	b=WePOUvm5+qExxfBk/DOcZi6iCLIIxSsZxHpjLyPBt3z0O6GXfb2N0wWNLTRWGGpr3crd9S
	Q7BEgbhIQsuTaECskvvdvia6DUzixvbJ3XIKiE+mSK3B0TUOnnsQK+GnsRQWYmOMPlDYXK
	MYOHCGS5QtTs9ZdToKwFnp9oBJAqVYg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CWDE7nCs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767101722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vn99kUxkFB5+wK9ojN0PHHzpYtysnPbReP2pJI56ycc=;
	b=gevQFiAxK4wSpLwK9UvBd/5N87Tfbvf+4T0J8vGA4ig9Bj6L9LeihiRTHrwSsp+275gTxm
	vOAk8EXCVdIYoLAp7RVMsxiQGkyQl5Rn8h+N5kBo7q7KBxDvpxHU/rpcXdAoDU6U+mfCp6
	hSflqvz7WU2TlKFgduOvubn0wea6D/U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9C6C404D9;
	Tue, 30 Dec 2025 13:35:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F720C4CEFB;
	Tue, 30 Dec 2025 13:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767101721;
	bh=zrKnPVnZk0r9u4XqkpFB0C/GWctQn1znJPUkHa9muHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWDE7nCsUJhCXw5B4aa3hp8BANcsD96RzhzYkVW38qqvxJyoTH1tjUnCbNk4O26n5
	 2iz7gkf8n3ASHvG48GU6IxExF/IqtSzYqY8mfqx8G/Ro0obv3fSe4giIykpev8dNYI
	 SKDyBe3qDH10fXDaAoJrCYtW3fk3loUqEwMBMqSdUL3L2cXK4k+RAe3l+zGnZEkz4b
	 I0BPeauaqkirrHpgVqvWI0tF58znzcSrgOkn3ANMWW0UxG1V7aLs2dYAEF2OwOksvH
	 van6AtS9rOIYp9v5b8yCXwVvnLMsw0WsSj+miHsaEU0EBVwLg/ZAga4xjEdUjhehxo
	 OQJd6zW0N4eXQ==
From: Mike Rapoport <rppt@kernel.org>
To: akpm <akpm@linux-foundation.org>,
	david <david@kernel.org>,
	shengminghu512 <shengminghu512@qq.com>
Cc: Mike Rapoport <rppt@kernel.org>,
	"lorenzo.stoakes" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett" <Liam.Howlett@oracle.com>,
	vbabka <vbabka@suse.cz>,
	surenb <surenb@google.com>,
	mhocko <mhocko@suse.com>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"hu.shengming" <hu.shengming@zte.com.cn>,
	"zhang.run" <zhang.run@zte.com.cn>
Subject: Re: [PATCH v2] mm/memblock: drop redundant 'struct page *' argument from memblock_free_pages()
Date: Tue, 30 Dec 2025 15:35:12 +0200
Message-ID: <176710164796.4000036.11847815060413161135.b4-ty@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <tencent_F741CE6ECC49EE099736685E60C0DBD4A209@qq.com>
References: <tencent_F741CE6ECC49EE099736685E60C0DBD4A209@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D115880007
X-Rspamd-Server: rspam03
X-Stat-Signature: 6pjfua6ywcmds4ieu1ciejfucp5n6mnw
X-Rspam-User: 
X-HE-Tag: 1767101722-382015
X-HE-Meta: U2FsdGVkX1+eLLd0GSNq+ClKWMOjn6IbL7s18Je6d7iZIvV96BC696twvEhLUtIUaqKuiT1xqpMxj9JrkYU33Gu3GNTXp0tJ7xP/m8n4e3Ffx+GJOxEAOd6dLDUxeG9V7VDfUxCAU4G3X5/4dL9zrHTaMSyuu+z4iQtF34rjljAleMLDUT9uac2CGW5djK5u+PqZj61LnFWR8yLTRSk5HPLFlCPxmZqSjkwJWNK23CvIoSeCfPj+cplUI8/MNgzwzvW25sAVm+wMQUehw2Egvo1DM5axahYiIFt2y1jSDDD1ZgVevhf68SEvgSNnxwPj5Sz2cYg274rxgm7akddkdtHnyhIqwHdJSrRDYNLeYkymgf6ANBxrrMEZGF8po+IHrQguZnwv5pnPkwygnJKZAXATjDhJpOogkMgwhvX+mCZCZElAUtOB3erGocs+gqtDdpMFEh1UjK1+x+wKzwclruQiEOFwYktQjomT6Y8Z3hxU//4QVGGVHa87klYilvm9Ctn+mHl4Tl+mUH9DSrg+VC2X05mPa8RwvEuzxsUp1Nrk2ViJfzabNuhmBZgj+bQw3PTykZmGlvsSMHb2vA3G+sP9pOUi1/4Z+tmwqf1hKlxri5Wcb1YCZ+rBace4Eu/MBRUFlQJ+ULJtu2v2eQPQSax5vQt/bCM+Xttx/yxTnb7VmM7f+nQ9kdyjfT3+R+qsazU8zFGy07Di71y+fT39JYwXcqG5O1QPzUafnBBJJYn/MGMcFs2/ZGCrDM+A2zzuqG2DxN1p+eHjXhkOOHFWszNQIsV5GH2upF8rux+uCALdDySvUUqHM6kWzMC+4SPAxnK65rQnRq6bC+kIIsdsSl9Eg5HfU+xI+O2RESMo8m3ZTGX3RWejMJrifC++1vg9ynxn7MtyOE6C2NgsaY8KR3AdMpkIMmrwYdQX2neyqjiX9OkGMQ6RheZz34xUBosCHHrGFTMj0F3pzY7w+da
 jzWQYJZU
 5aCbuKS8Phqeds/zTDdY0FFeMu4207+4zzWRRVi0hnRE0t/zaRq3GKjJU6ewpC5RjG0n/lUdrRq1Meyg3dbi4IGEulUyZkEEANa4zWESG5CndLMOu57PelTXypWK1SdAXVnuATc/QrtLsyBft/SOM4/iUFaeJGizc+y0o85OxxKpyXEzJQI9wSkjoLnPsoR4sCX3QblIrJwL8P4JWaIgobzxGvdKHCzCfCkHslvPzZjCpvx3AvWq9D8214kH/pZRybHGsp/ghbYpLDsrUwOP1MCj/L5EMwvmFcnnM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Dec 2025 21:52:27 +0800, shengminghu512 wrote:
> memblock_free_pages() currently takes both a struct page * and the
> corresponding PFN. The page pointer is always derived from the PFN at
> call sites (pfn_to_page(pfn)), making the parameter redundant and also
> allowing accidental mismatches between the two arguments.
> 
> Simplify the interface by removing the struct page * argument and
> deriving the page locally from the PFN, after the deferred struct page
> initialization check. This keeps the behavior unchanged while making
> the helper harder to misuse.
> 
> [...]

Applied to for-next branch of memblock.git tree, thanks!

[1/1] mm/memblock: drop redundant 'struct page *' argument from memblock_free_pages()
      commit: 42496efbfba1741fd4f1278366249bce9d34884a

tree: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock
branch: for-next

--
Sincerely yours,
Mike.


