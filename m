Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9729CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 14:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A0C8E0010; Mon, 17 Nov 2025 09:10:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F0D58E0002; Mon, 17 Nov 2025 09:10:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12E458E0010; Mon, 17 Nov 2025 09:10:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3BAE8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 09:10:46 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA452C0125
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:10:46 +0000 (UTC)
X-FDA: 84120284892.10.4A943AC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CB7084000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 14:10:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t+gpjnou;
	spf=pass (imf11.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763388645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ya4bBZ63H0SMToco/C+iD+VLHj/TwV0a/p98HOQZzm4=;
	b=01HVE8kucaBTQfaOWzhGLPrTcdftPd6QIDS9EYjZkI4eMB6UDMQZUG3FWPtEtUtdXNtOlt
	HLxMgJ/osrnf+n8QNKhydwRlBpG9YamoEdZeCaCFoZhENWrIv+pkr5RwR6dNyAZgfCn6ep
	MpbA/DizB2C/0OhpOqt3YBoIRBfrBqo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763388645; a=rsa-sha256;
	cv=none;
	b=G0gfQ0y497A8DpTaDI/dN30ijFfjzCbzecTQC5I3s07unjIDRgd68nIcghIxYaTev8042l
	vUmlYlHKh8ejmXYHDlpX2TU2k9b2Y4n2fEteeVOIfhlkn/DeaLI+EeI3WN2xC1DrKNtjQ3
	q4FVSIJcIJdRC/t1131NUZf4WMNPfiU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t+gpjnou;
	spf=pass (imf11.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E44D4425C;
	Mon, 17 Nov 2025 14:10:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77577C19422;
	Mon, 17 Nov 2025 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763388643;
	bh=Ya4bBZ63H0SMToco/C+iD+VLHj/TwV0a/p98HOQZzm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t+gpjnoutbsfKiMO9QkOYzQqPSM5vwA8KzLy837LwsfrVSmdzj8pT5nartHtBsn3U
	 9jlTH/+IhlSFdfVMPKndUmdLWRL8oshKc4i1cIdDXgfrAczR65n8jvJwAlyAsRD+6z
	 tYH4U4tBXNngxwfYSawUC8+EnQo+gMjKN7U802rnXwjQZ0KJ/6DRFq9rzlqsg0vLVO
	 gwQ3DJFQfkryEwi4ecGuwMqykTx9Hn6EDYA1l5XkKs0avwnQM3K9WY+d5iodb05xMD
	 +JnRmALKx752MuGeVkBlDppnXoszl9Dqut6fVoc5DBXvvWKPWN2wD1G+O94TsHjnEg
	 dhW+R1gFLfDKg==
From: Sasha Levin <sashal@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Liam.Howlett@oracle.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@redhat.com,
	dev.jain@arm.com,
	hughd@google.com,
	jane.chu@oracle.com,
	jannh@google.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	npache@redhat.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	ziy@nvidia.com,
	Alistair Popple <apopple@nvidia.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Christoph Hellwig <hch@infradead.org>,
	Ying  <ying.huang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Mel Gorman <mgorman@techsingularity.net>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Minchan Kim <minchan@kernel.org>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Pavel Tatashin <pasha.tatashin@soleen.com>,
	Peter Xu <peterx@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Ralph Campbell <rcampbell@nvidia.com>,
	SeongJae Park <sj@kernel.org>,
	Song Liu <song@kernel.org>,
	Steven Price <steven.price@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Will Deacon <will@kernel.org>,
	Yang Shi <shy828301@gmail.com>,
	Yu Zhao <yuzhao@google.com>,
	Zack Rusin <zackr@vmware.com>
Subject: Re: [PATCH V1 6.1.y 2/2] mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()
Date: Mon, 17 Nov 2025 09:10:36 -0500
Message-ID: <20251117141036.3860228-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251111071101.680906-3-harry.yoo@oracle.com>
References: <20251111071101.680906-3-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7u5ebie7qopnjw4awc4pwqxnyhmt3ti5
X-Rspam-User: 
X-Rspamd-Queue-Id: CB7084000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1763388644-281636
X-HE-Meta: U2FsdGVkX18Itz5rcDAzKEWr631eMAC5kue4grJyNESL3ly43KjOl1lcQ9KQnIS0mCJZgR9qzQ3yiDMG5pPVE0wBkA3FTZUjTj8KiC9E0if7v4rVsb1Y63L1p9ttFFlDwCFTewy1mzPoRx2pSX/xNMB0xcN11vmJVd93xdez1MhhmJ6JYcRxnm6pJtjEiwwW43O1T87U4jOeehoHIwpGLHrg1ZCr+FMbTQ/yEotWyXX2RwHO3/4mxsDmqU3HSvmNMbraHt+1bxdqxKOZxfDQaZiTaEcowQDQOnHrfoti2kX1V56aqOcXbIfcQgh8WAiD+tihuTEyWDW7L2RVOVhcZtdr/Lg9UbMyMOx4Bz5hwkQrp8kw77Y7uqApxRWJl2BJVbM2DyeZSxBJgVwCLEayYFA0zf6sAaowWH186AaFIDl0H8UIru4UcEyGHB0jCPFvZHbmk98xND0VymQChMfPze1s4V8MbuqpuzcBoTLF7C32leXTfrRTi+enOX1YtZm4P72XbG2DWXELJY+4nfJTBh3C5DDriXDniSMWEAvOvpNB7Vv2AfrIR+BeB70fJqjB0sDz04OR3FhUszA6Q+cYBi5JydDDrBhE2I5f+I7dozYCBw7H+rnnwaym9j9bPGy0zJz4meFXA60EoAAwqQX2ckohfkirZG97CIky76UVBcGkW74VWnLYk11aVBaWTP/lrmG9R5f43PlKfu1VOjwT9LJ8Oyfze9vw6EJPc/OVFKndaZIxFlMUwheiGJGUS22yw14zzTOKtcQYdrS3LzYF6ht2VBr0rodTQvt9Osp++TRVIyvLaWNcoYV+dw0gOiwGP3IZyC0VZffwZZXe30Lk/BYxxo8z4uLS6VAu2JMCGV9DrbEVVWysbY4C9tThNvgG0oBnfacFq2QnzKNDG5fZFMyQxpwKZAlpjxE5nfzLCxrNUXp85bVmg410R/mQ/dwTvbhnaJKfWiSZYn8u7dX
 TzvhTtG5
 F8ziFW3u1hSYgfSG9b+2gtCNC8oqZgAmjif9ydEtvwWPBFIDbxjjQ5J66ccynGVBAd8L98/3114lfC1LwwBhTVSNh52rbG6ju2L4pAteD2UoZKyKtRndlxba8Tyuj5bvZPwj8aWCzbOmh/L3sEhQOwkj0KyRkDttViwXTVXv698i7DsoqjiqEO0inB/SLcnA/Il81cgzITfXxwib1d2N/yfrZr6z/NI3PVgOu5TsLkDNiBmQlqM5Ontfo0q3BUSBGoIlx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Subject: mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()
Queue: 6.1

Thanks for the backport!

