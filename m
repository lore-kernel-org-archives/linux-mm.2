Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E0BF106ACE4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 20:00:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F336B009E; Thu, 12 Mar 2026 16:00:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 513DD6B009F; Thu, 12 Mar 2026 16:00:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416E56B00A0; Thu, 12 Mar 2026 16:00:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F1376B009E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:00:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C7ADFC1B5E
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:00:39 +0000 (UTC)
X-FDA: 84538478598.26.7155809
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D492D20014
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:00:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A/jQTOKg";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773345638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9EBmqzWzWpZdu54pSpVesyY6LoVwcXPZZbYtuyuq/Ho=;
	b=h3C68/SaokBT0KkCwwQhQC/RJdmVJM5ye9Ed8/i2Z2cuVqDiQFx6uECSHebd0aH0gQ1Ttc
	9n0porevK78bNfkgHX3XkqIWpyBAqWLWJJr7cjAuUibvn7ioH+4fmx0+rhg/l3TPNMZGxt
	lpfKjDBQqP33LXbd7e9QLbG8HqpQEIk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773345638; a=rsa-sha256;
	cv=none;
	b=E//QI613ytYaDbgB3zma+qHRUUnCLdZ5poD8dEMBIml0D7fWly9CQ0EaIwYJienacZBnUI
	osb9CJ7zuSlTUlgOPDqkT4X9hy1LJpF6WRBZ31rxcSKvyPrmIHqHr+voXOLfrs0/dX9cs2
	A0AIif5n7aa0+AqEkuFDTFALlumZQPk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A/jQTOKg";
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B2AB441AA1;
	Thu, 12 Mar 2026 20:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DC5C4CEF7;
	Thu, 12 Mar 2026 20:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773345636;
	bh=X2l3L12LE/Ap7HQkaYJkOvMdZnPgyASN/c+AER2mf9E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A/jQTOKgGFuThlP6+bZiGnH9sHDS1JnpOiQ6X0m7ngr4C2WF4YRSdRx/V86yEsVZq
	 wxqr/bWVL8FMrj7J/DK3x9QSz7wR7kMbql9f1kBSCiKQPSqzkeVafoJ+up3YN92hra
	 lzImPhac4DRueo6ihfiJ8oCxajHO2joXO/HpbLCHWlYQdmQrtdoMJOOJQnRPvdpd+X
	 UmI3LAkJR+tyNRtUy8YnnSeE0PSdHA+GiRjimIkRk4l89zXQynD8PbNWRalVQN8Cs6
	 5BJOtk/DnPWCVSKPUMWkVuNJIiIFnajvIrmEOFi9fx4LyE9d6wIrXoWcJOgCBjKV9h
	 veyJx/83NIIsw==
Message-ID: <8487a99b-efc7-4e7a-9e24-1cfa705a586d@kernel.org>
Date: Thu, 12 Mar 2026 21:00:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v15 01/13] mm/khugepaged: generalize
 hugepage_vma_revalidate for mTHP support
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260226031741.230674-1-npache@redhat.com>
 <20260226032217.232353-1-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260226032217.232353-1-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D492D20014
X-Stat-Signature: 5xzg5q6z43oq1oon8ni7jsbb56d9ojee
X-HE-Tag: 1773345637-286624
X-HE-Meta: U2FsdGVkX1+p4c7iZ/SDHv7d3cxMZl5EcurKB+xXbMImN29opEBriixRmBflgl3mdS/KBlJtjC6R/wuztPcfosSnL3B1wyo+SyTLRCnEq+Sz796aAWcyEjdkXZz0FT8WlPYUS2D3s+37gA40zzgvosEa7UBSJTYtYt2qCUZZE53RWqi8B0MlUnKN7KqUkCAzZkxTDJHocku9Z/9NGil4BMZnZx4+AGs8lYh9s2bJFBqwfSqnwvrcrgbPHJl1kEjzm38CKKqmK2oVh12QPt97oQKWFtmmENDjyYO0IIpDlCJob44NoOSu6955F1QAM421+083bWia1g80hjOXbUq8v88LOIhN1l9DSprhBbU+RCEGSvNx2WYSPAsj9Zxju7AG9WJMl/2xP/syCss075n4CGCVhRXrvG2BC47Lwfgk5kxsmqIW25MV3d2l/oSTx5rmpvsoelsrVyT+4jyOnIhbrRdhLWz4qaLCOxLwWoVVRR/nsWLd2UhCkj4fPF8qYk6kAbOd+fQPiZvD5vtEUz+Y6+nn2lveBc3GeHSZc8lR3DJCy/TlRVFD4J9U4sNpqZEYiJNOrSlnhjyjRanQ6oMSTkgAC9UKtor4pSt8XKqKJ0tUL2mwGtbPIVQ6Vs2Y+1UX8bLz92martzmG2m2rUHRCbR2kXEF6CzBcaZZu+IzLPPUpuAw1ePa8myhyVz45c/Ahg0GHTgk3v4OIb/pcdZzvKgdRlGTA8mDdUE7qRcX7nLExhCqqHuEsraHdTQYsQ433Jy+4D4vQfrDLoh2a8g4lbRflTQp3yjLEMS6QV+VFo5xVoV8rPtQ9GxJ01jJlb9USwEBt3XS123ASRDuyrhyJ1Mt8A/jmMIz9EzHRyC+YRUYeDRueCX3SNiCO3aJ8PobrzK+YGyXt+JvUezEX+Fnw/eNs4otxoiEtYEGjAh9qasn5j627HYSLlr1KCrfmv6vU03AGuqQgjwBbQCrw5i
 tHldAJZN
 EJOjpLPdAeWdko9/VX3BrXhGrinavJ1IvbyGIiZJjnKL0KSAPQs3fP5AsguocQwFi95ItuOMHM1rhTknNEliyFE16CoZLiwyQzZsgszlngUIArpL4da5Iz4GDjZsNmS4IIYR7Xrxulsv8A9x84ESdDXRISX9ltuyix6nuD1GV9+jAH8YRcb0ucrfpUFoNsSK/U6ZkDzm5Ff/ZIToRrxYk5PujsDQJlsXYBGHlHdOpvshCQHnjUa0UFzB6IHP/MNzRxeebAH7WsJ7oEecn5NcyCvyR21W1qtvLvgrT3mvOTZiue45Y2Pio6vfx9FX7XurPFozK2Li+EShBzS3yUeV+6I20k98Bl+iQt4eeqamHzAciV+zTXO4d0rlRWamBT/HbWBMHlhut0VnCpHm1zA/odogxULn0F6Ne1ZXOzpFDDZ6EqGMIlTMxESZoId8P4UN0xSL/JvNY3Kfw2KCoai6DKN1zAQLPsJnv6qDVWtQervIIgitouvn28E2SADuZyMp2jwtks+nvlZsDZF+l6kFdmqtu0j81rvW+vMVh6iA/Y66VCDAbTiBOkiJtN/74ZPvJuvSj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 04:22, Nico Pache wrote:
> For khugepaged to support different mTHP orders, we must generalize this
> to check if the PMD is not shared by another VMA and that the order is
> enabled.
> 
> No functional change in this patch. Also correct a comment about the
> functionality of the revalidation.
> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Co-developed-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

