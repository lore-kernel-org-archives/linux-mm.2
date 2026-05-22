Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 413C9CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A982D6B0095; Fri, 22 May 2026 04:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A48FC6B0096; Fri, 22 May 2026 04:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95F036B0098; Fri, 22 May 2026 04:13:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 880666B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:13:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 39C541A0710
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:13:20 +0000 (UTC)
X-FDA: 84794340960.08.EE581BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8C3B016000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:13:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VwivcnQL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779437598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rjd0Ici5RRa42caP7Adz+RlEQcxBp92asdSU7nNb23I=;
	b=lI6QrRbrNecnGAxqQaPLHAJwdwmDQpJo7A2tDOutnG0NX+11w7NJcFMwaJfRVD4keCCJaX
	qDXmrNweguEwDUsHtVipg2CVf2X0kgKJ+V8iKP37hWEwIB7R1v6cAJoMX6BeLyYa4gDD2V
	IzqLaR2SHX/kKi++8re4yqW13SCDOHI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VwivcnQL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779437598; a=rsa-sha256;
	cv=none;
	b=AQyYvTFu2RqJ83+WLUPFfzercA3MqokNIMC1nKc9B2UgnL6KhLpjecTppnN9HhVzpMxpJm
	m4+TymJs2j7eVOGzN+8TkSqzV3cxIeicKYyG6EyY5dzxmulhVkviuntZMlnGWFqAkyjVOl
	iVHHbOEmOE641bgZtJnTk3UC8cZsvqU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D27DB416E5;
	Fri, 22 May 2026 08:13:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2071F000E9;
	Fri, 22 May 2026 08:13:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779437597;
	bh=rjd0Ici5RRa42caP7Adz+RlEQcxBp92asdSU7nNb23I=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=VwivcnQLXnX0HPcQa68w4qZ8+B1uxc/PXMVMVHbY6TOn0o9qF8c+f5Yco8PCOZz2E
	 jt3xWk9yPeRSf5Qkc0MmD9ifwaf2NMt6wBX0H6HpZZ7NcC4yS5wmOD+w66pAtJ1gao
	 izXbHWKUo9xaJl6iIeCMCV2jtBWj74XNJPwI5xas0z/a27GMDt04SYMrv/kB0xAILr
	 D/BGxkIiW8vuei6qeeaRnW5mFl4NrJyTlceABTTBZMUjjZtowzUXahrH48wJlfi/o1
	 BpVVTOroqOGNhvcnHz4bV4Xnz8oBlXWQfsanQa5egO/hNbagiyFKskYQdyvok+xfmR
	 e+PDjvzYHmOxQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 09/69] mm/mm_init: Defer hugetlb reservation until
 after zone initialization
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, Michael Ellerman <mpe@ellerman.id.au>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
 Ackerley Tng <ackerleytng@google.com>, 
 Frank van der Linden <fvdl@google.com>, aneesh.kumar@linux.ibm.com, 
 joao.m.martins@oracle.com, linux-mm@kvack.org, 
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260513130542.35604-10-songmuchun@bytedance.com>
References: <20260513130542.35604-1-songmuchun@bytedance.com>
 <20260513130542.35604-10-songmuchun@bytedance.com>
Date: Fri, 22 May 2026 11:13:03 +0300
Message-Id: <177943758345.3662727.12436499269960922490.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8C3B016000B
X-Stat-Signature: 7nzynzej5jyqazypz9uoaq58mk7kjhah
X-Rspam-User: 
X-HE-Tag: 1779437598-50890
X-HE-Meta: U2FsdGVkX19J5aizgg+DxoROOkZtzLzXuuBLplPiUH0T4mbsoc4MRZYyr1XAPS7ATCYWU57mdDTh3KgySmvsG+tZ0T6TqEqmnK/4uCjX5AxgmhHzMogkacrlSNvMrln0ul0YQtgSw24Zol3i/fWKFGyRziNn/8EI9OOqhVPp0+qmhid+k27WUGq97OjzgOhOdTzuLq20pD8Kg8aC8BurriUo4t0Y+P8Hzs2nELbtgAo6qgUaml8txIcCK689f/fwxSRSYhfjB8F1UM++f0jtUWzD8+MeqZEldiG0M1MWgYlZZVTZsscvl2riL0BENyW0ocxPxjDqTjKEkrAXTvRPiYukuF+qsRyZodWCTE1GG2oiBcn7a9v5V6tOh2q2a7lJEap+3TMxKgRen+gHB6zyUuVQ30cJ1pZ+WndmvdpMtwo2BRFfy3Js7wcp4k+sRbJbruuIN9Ahuf74Y8Wctc704uHAryUv27Euhmi2HS8lDsU/V44sYxcd15KIGugOPg6xf+WzB+gteK5JBhvDapi/xqQxxUhe6i32DNmrTP848rta69Gy9ldUwT7XbW+HJbr8fTlV9QWInzk0qEUv/NttCszne+e7OaxdJ0WnSiPFLsIEKKra6kel57rPAiTudqA3CLrXYvnDrnv59pxpn9hhyNlNbeQvdK+ExMC7Q6Mw81Uem8nCLwgtBPmnJG2fV0O5ioRE+joYLUp187JKN4HETkKnnqJvYECBFUTDCGss8SaPovBRy6IYjSsVLNNrLZ+cExFZfVzZOEyorpRH/0Vx7ZANZqT6k+R1FYraUVq2QQb7e7rzITPit3+RM1srKNi13glmDS47cyfXB4owTLQMZpqTWCjENGQWJpHpAhgcZ6TT5FQRYZ62KMWsdFVQ9bsPgSCtFyGcliE4IxMjWOWonbY9ARyPCqrojwTFl86ZNit06lmUCK1xONqjk0ulAZqX9PLwQlc5dcTVpvuufiK
 2K9VJhvT
 myqZ2h8Oy5h+O7iy/eo25HdUZBqGERNJWXvCarYe0JK5BI5koYRknzLUryJzXexKuwpROq61zQzkHKjTmrF/TDj8ztT+mJ11JQ6ZMGpp53leVCdnS4/a1cRpXOarOuUHXDQGdtYOG3bStxqF1mdk9WjhIlyf6SChIPBJRAW5ZNPO2/fvAl/OXf2+6H5hsUoMpUsDn2cS1nAAHmwvsGSMmYqCYfB1wCjoNMIETR6KHvo55M7OMAzcRaWYXTZcbCNFU8XDGXeWhfoSP/jceA/KH+M2ro1z9qNBb3HhcC22TmVwFtDY/sYQ0+ag8jQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 21:04:37 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> hugetlb_cma_reserve() and hugetlb_bootmem_alloc() currently run before
> free_area_init(), so HugeTLB reservation happens before zone state is
> initialized.
> 
> Move the reservation step after free_area_init() so the relevant zone
> information is available before HugeTLB reserves memory. This is needed
> for later hugetlb changes that validate boot-time HugeTLB reservations
> against zone boundaries.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


