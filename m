Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B364CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 04:13:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 630C86B0005; Wed, 20 May 2026 00:13:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6084D6B0088; Wed, 20 May 2026 00:13:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F3B6B008A; Wed, 20 May 2026 00:13:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 435886B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 00:13:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DE81A8634C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:13:06 +0000 (UTC)
X-FDA: 84786477972.14.14A22FD
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0712040005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:13:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZkXJ2H0M;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779250385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRxIk/rNMXwMe3aqIZ0sV2FoVFm9Hl2o3laEA+4gbk4=;
	b=2gz6Y+MF1VTlEHl1DfcFk3a9W3rBC0g1oylykH0BzFX+r42X6WJPPxMQtSla6b2WLZbDt1
	3MZxOh1Q04hrzsbrf+1MEstlJNEr8oNIBZxOfxvTXX09Oc9qp4D3+tRjYsZkPQcqKqdBcY
	Ue0hyj5WvynD22awVX0LuxXGAV/Kq5A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779250385; a=rsa-sha256;
	cv=none;
	b=DcS3aBnXnoJ2WBU7qiT/u+/GqoZT4SCQgWtY8Am/tbsT5/+55r52e7XLK4vlzf9zQPvxmE
	2zuhM9ueGR8TxF4dHPBX5dPX5clujqxxVmCAx1mSMQ0AC2I4vnslVe/xuePLTkW9gpWpMY
	uophaMN4VE1NYycAmQLNVYVvormkzek=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZkXJ2H0M;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
Date: Tue, 19 May 2026 21:12:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779250382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oRxIk/rNMXwMe3aqIZ0sV2FoVFm9Hl2o3laEA+4gbk4=;
	b=ZkXJ2H0M1A8TbPE1BHyMrulOOmOHN3ljMZyTYcupbvGr+jR3MTuHpg5QkH7p69lQt2Ypuk
	s2iZE7b/MXQA4NvBuQZQ+NFxO3Fz9dJW/Ya1bKPSztN8l9KYJaWEjc+TQdJCNz3n4EncDG
	NQrSDSZa7akXzHm3+g5ueA8eM0PaV7E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Oliver Sang <oliver.sang@intel.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, oe-lkp@lists.linux.dev, lkp@intel.com, 
	linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, Allen Pais <apais@linux.microsoft.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Baoquan He <bhe@redhat.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chen Ridong <chenridong@huawei.com>, 
	David Hildenbrand <david@kernel.org>, Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Hugh Dickins <hughd@google.com>, 
	Imran Khan <imran.f.khan@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kamalesh Babulal <kamalesh.babulal@oracle.com>, Lance Yang <lance.yang@linux.dev>, 
	Liam Howlett <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Muchun Song <songmuchun@bytedance.com>, 
	Nhat Pham <nphamcs@gmail.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Usama Arif <usamaarif642@gmail.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, Yosry Ahmed <yosry@kernel.org>, 
	Yuanchu Xie <yuanchu@google.com>, Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [linus:master] [mm] 01b9da291c: stress-ng.switch.ops_per_sec
 67.7% regression
Message-ID: <ag00nBP_zNa9RWxm@linux.dev>
References: <93b7c3f206f158e7387cbb5f0bf5845b59b93053@linux.dev>
 <19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev>
 <agdS5rIhcjIBVSog@linux.dev>
 <agm61hMv08XnV8sI@xsang-OptiPlex-9020>
 <agoYp1zW9afZ6uQz@linux.dev>
 <agtATZG9mIlYzMUl@linux.dev>
 <agtPMpQK2jXdQAY4@linux.dev>
 <agvvRNJTAtNkCVZc@xsang-OptiPlex-9020>
 <agxxuHOfNLX-32kI@linux.dev>
 <ag0fyi8GjHHf8bdC@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag0fyi8GjHHf8bdC@xsang-OptiPlex-9020>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0712040005
X-Stat-Signature: fzpfiwu1tywk1by4ctwk73i6syw8xdbm
X-Rspam-User: 
X-HE-Tag: 1779250384-396695
X-HE-Meta: U2FsdGVkX19DIaKDK6IwvC0CWr4/TSd9aApU+FAUZhLUfnxonVSOYulGBJgAtILSJTEoH1Id2iemIv/lfwC2a1ABgB8YdO3MYGLuFpesF4CVjRsCahGFlq43rmftmrns/1t6oAc8EvjgfC7LCVlhI0yqEHNOUh7m2cuyX6ly9CRW5t2wcLPDEkLhHNQt6OXBOOvMPjDi7dnjoSHvXMdY6D3fhr1PtFOLhSqVJYaeCWoNmhhGMFSuG9DB7ApljaFvgQWeuY1HZPFem93ThFK84cbU2KctmmopRRhHwv6A6VW2oPnimRmQb35PXAUmvvAAiXmmqp9ImPYrnwQ6KgZO0AM3Q+KiQW223OxKA02wj1k/Se2GpeBr2M2i1Snp6Y5f5govISQxJIXptdt9OUqKBj6l2kvdkEMk/ipSDHjbw4jrPDwtlVMMuQC9GuGBOMCXO+nThM8J6EgJeB5OFgxacewBjDXc2zT+WNg007iwXwo1rCDuPabOu3iTA1afJrVWdWFLeZmOErE7vTNP065MebSnIAjqkNUYasHiRA/xJLFYXJNbcntpvgAObrWp5uJkfm+gM3in52zXbJPjgxCNrHjbXEnFCCXwFf6dhYNvBXrxnjyCgzkvZURGxrybPiIsX7PRqU1Tl/YLN3SQrHv4OfXffj2D2hXBlQOa/tekFRwYl8Gz8bljUJG9crjY3Q+dvKj1quFDaynhu3BVFgym1ZbxoTPxLCnIOyGvsO3KKVHhENBPGLxLLWmBXOOTN/uEvhhw7z5SDlPFegKJX5/8QrEwxvUMZZUs0KsmZSh0vzDlEtppj4qqtrfFW84ciYhyQmnmWD4M5I/O/GmWX2hhHLXoNSw8RvNB73qKnQDB0BlhA7qLKL3wrHDY2zY2PSAuTGHQQNsSgsGuhNUD2RUjQEAue0NfNxwADIscfd9FOeSZgvH+IlUvND2/kYbUEHSMmVS8QrleKyriylYjzUC
 YLz9BaqE
 cU1pklJmBoElOfSxXLEuZ5d79xBDZZnY3KK4J/9eEgeFjMAUq4ZSBSs6zvqXYLcRzUH6spxJNqWdHSHuPgCpaqYYYTPecLiTMx3LCcKYiv8Fp2nU1TqdgvZtiW6ZGt6gcAYZ/oMHkqorp1pSUdVER+s4ToHb63eLJHvDaoBKuPTlrmvYUE/6BwrW0F2opb85Z5gUf1nxAfmBhRk5uV6Q0yzjbVMwFN8ILK9vUGu8R+/95vZqzLZwdoF/LjfKZZvCU1zMe7saMemaC4QwQkncRBVG9KA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 10:43:22AM +0800, Oliver Sang wrote:
> hi, Shakeel,
> 
> On Tue, May 19, 2026 at 07:22:52AM -0700, Shakeel Butt wrote:
> > Hi Oliver,
> > 
> 
> [...]
> 
> > 
> > > > > 
> > > > > Also I am rethinking the approach, so I will send a prototype in response on
> > > > > this email for which I will need your help in testing.
> > > > 
> > > > Hi Oliver, can you please test the following patch?
> > > 
> > > got it. will change to test following patch. and this looks quite different
> > > with v2 or v3, so if you still want us to test v3, please let me know. thanks!
> > > 
> > 
> > No need to test v3 as it is similar to v2. Please test the following patch as it
> > is a direction I want to pursue and wanted an early signal if this is the right
> > direction.
> 
> FYI. in our tests, the following patch also recovers the regresion.
> 
> Tested-by: kernel test robot <oliver.sang@intel.com>

Thanks a lot. I will send out the formal patch with your tested-by tag.

