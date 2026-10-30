Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59689606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dwBFosyH
Received: by kanga.kvack.org (Postfix)
	id 79C866B05B9; Fri, 30 Oct 2026 06:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774B36B05BA; Fri, 30 Oct 2026 06:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A5F6B05BB; Fri, 30 Oct 2026 06:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 421536B05B9
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:22:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 40409805BD
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:22:12 +0000 (UTC)
X-FDA: 85378902504.25.D681A22
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 82EA3140008
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:22:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwBFosyH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793355730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o+kaUtC8ovQj6xhHRCbmiOuasEe9YC6Zr5iT5M2eCM0=;
	b=QnVgsxxMx1lR2K2/S10b0dx1/lgY8Q1CtRgVLUKRVvfqWHNWWhljqnmtYhJ/dDrkNSp/1t
	IdIfT75UH++BxpIICNLtp5rXrWNT34s/eNmrHR5Hg/MEBanHaRKNFpccUAPPvmZRZHn0I3
	+mTCl7G2dGKqFPr/zESXcBB7X3F0Ycs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dwBFosyH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793355730;
	b=BDzhXjb+6+oC63XTWcoQrCMw1dDnN7fVO80Hw0TBOniOvgmbFq+LGSSveenrfmGtCHEJ6x
	018z21cIzenUmRvWCL3DqNL2gN7O7wJYMlVR931bVk/FAe36nN6aG86G6rJLSWlJQuiBCz
	fIZGrbd/nivcpTYGYodkuO1Gr8EYpAc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B3C560092;
	Fri, 30 Oct 2026 10:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F301F000C1;
	Fri, 30 Oct 2026 10:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793355729;
	bh=o+kaUtC8ovQj6xhHRCbmiOuasEe9YC6Zr5iT5M2eCM0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dwBFosyHJNEN/VlP9Ae3KU8sfJ1VpcWyMYJG0hYheIRJZb8LD62PaQRkm1G0V2DOU
	 /thDolVwbKVJ+f+WEKxynk73Tq8txa/etK+tLb/fptp+mzUo+CQq8mvhbO0P5f+/p9
	 Nq/8/AzFmw5eWg9Jj0YW8MDMjUYo6UKlKavvcEB81ku1e5o7qQqsCBV7gvspaDsMz0
	 Jz/HAKpj8ZfulPBeQbw9kwQpzl6Et707A+yl1grA0FZJghBafUgkNkE2fQ8DGj/ZPB
	 gVCz8+83ggGBl0JMUrrgr16/dml/0dpNWJghy7sr9pH48z+QkBdbe20lK5K6Qhd0Y9
	 WzTTotFpshtjQ==
Message-ID: <6d679adb-a866-4a76-b9ea-3b8c64171fae@kernel.org>
Date: Fri, 30 Oct 2026 11:21:50 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 01/47] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
To: SJ Park <sj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 stable@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>
References: <20261030002004.154595-1-sj@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261030002004.154595-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 82EA3140008
X-Stat-Signature: nd7mmnz1xg8wd7uq4j8mwmo5phgi1d66
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793355730-965854
X-HE-Meta: U2FsdGVkX1/5kQggYAADniIReWXYvLNKX3hWBNvpfdWwjzOGiZKWTM7DZ7l9Dnql2MMOw1vNDHfNi6WEoeBevBmFeXUpwjvtOyW/CIz+5XrIuzKKIwLZDaoN0DIe3r0HKRRHuRk5iHArTb+iqmZ6N+pLJDlk1HaU940eqfNT7V6auW8RNZo4/3oWj2aiS4DbzSaR3xp/+dQB0f+gnnl8pJLejcwJ+QoGjhrgQhURsoAjhM5U8E/fAvcMiFEFFKOM7RdTNe6G5tp8PCitHBEw5cnLXoJ3kdIaQvleF+WI0jogaX4BoRViA+yQZtYtvCZikWBL1MMIzyguReA8se5wY4DMEtabWc+r+p/bGKIJVKr9WAbdVBLeOn6cN0gAPV8v1mnT1xbACCX8Cm0n1SMuoxZK+udcMIhS6z0ztNM1vPhbNhNA7Lcac8VUNJ1SMHr1tNxtlzh4VEUhuQp4sXr5bVO9e1oFn0exA8rRWiBublqrLlbA8KuZ9gcCC6ZTuujhLAXNGwWUDqjpJU6CV1uecAx87xLLdlRi4jhDEjbw+r7hQysptsT1Cwba5xJDTQ9dbWD0tB7SuEMOyp85Dg5yu8tF1fg9Ap3Yckwe/wyfXRLFaTMTWFgbmTMCsZBvaP3ohrqjnAcBAZPnFScAVOVEply3VDQnL4NlnT4/tuLKJc2mzMzJcbZ26e1e00ngup20j0bgr8+ax3oXnB+mowhGokM0VVVn7oeZaapiSPrlcCDLMZQLQAy+bL4FVfIBpgPng6EFSxL2OtB1IRZXsFoN+lyUmavCThmoyKbfiGaEGl9h2QWTbUuXarADlgkwMMwFIcudmjHVCyFSmtbEW71pG8cJ+QUzL6nqaW3BqMbXL3Kb/n2g5cx9o4xnj6tuuiwovLpmmL8sa0RWASB8QQwSM8eLak1BD/ZwDUrGqcgjdVpZhsik81rNzApOl/ri3M40yTB8fS1F7RR0/dB21bi
 D+ObjRVS
 xZQA1qW6AKR98LqfjCvnT9ACFlIRrTW9iP4tDYISql6JvhFtGE+ekqZO3niiJqv8XD8LB13BJK+0n4Fl10f6RXdTPKMs0R0jlMR+/GoCwzMqBqA6HmwNaFLxUOcninFVAWyzreFesme7mBAMW6kj3gSwbiitFXEUsXDbZSBlIGJLG/fNdmXVnIelIm2zmlrao+EpSmtQ2B5iypsjgxqz1IL2kmX0Huj571cGZgIQYyFITaVMWJRC/5B4GZfchgnPuufbBpV+EsIm8yS3GRc7aBdtVWgbNDGkVxMRUA2R0sHqFEMS/Lb41QuYtCCIRrKlQ/hksGO1IN8wnIu8zlUumgz+ZtdPmF5KKTMl5o57kZdpayX5qOGzuYWqDxSGrqzmgdUYmGY7IZxAcuLJNPv1GWQOEXgkCnsbYec8C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 01:20, SJ Park wrote:
> 'get_maintainer.pl --nogit --nogit-fallback' suggests adding below recipients.
> But I can show there are already quite a number of recipients, so I'm just
> noting here.
> 
> - Brian Geffon <bgeffon@google.com>
> - Oleksandr Natalenko <oleksandr@natalenko.name>
> - Steven Barrett <steven@liquorix.net>
> - Yu Zhao <yuzhao@google.com>

The CC list was so long that I limited it to people that area either a reviewer
or a maintainer of code.

MGLRU not having any real maintainer is a big problem; because that maintainer
would know whom to CC.

Thanks!

-- 
Cheers,

David

