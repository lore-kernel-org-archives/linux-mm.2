Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B5B5EEA845
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 19:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFA66B0089; Thu, 12 Feb 2026 14:45:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09A0D6B008A; Thu, 12 Feb 2026 14:45:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB4086B008C; Thu, 12 Feb 2026 14:45:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC3DB6B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:45:55 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DC95B749E
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:45:55 +0000 (UTC)
X-FDA: 84436835070.23.57C4183
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id B3155140004
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:45:53 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XJ59lTq8;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770925553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3sqyKvzr0YAFEebxYbHEeScYgp6FLkzBHlQXM1pkWA0=;
	b=gpFWPj/yetc0wrpgBpXFjDWichlUFMi6vhUkXdndXzpy4mwjOa3fFWeY3rxNNcu+B+D8Om
	FDYzj0BX1qpgM1A40K2zW8ppClw3WpVbJNW+pIjTh9ZPFMJIxK4oql3R1453dspra3KwlC
	e6SUYEPj/+eXb/9DO/NAuHPLcTOhhoI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XJ59lTq8;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770925553; a=rsa-sha256;
	cv=none;
	b=8jlaBfO+bFDQrSZZC+bkCzaG5Ja31mh8m/I5tDnthrlSvWnNVCs4oqBwvYrkDU3CGkXvux
	gnrAS/jyy6R0fk9qdtdjkUzqEVzpQmuj80JyXc+uL2RhYDh7uelPYNz+QT07tcFzK5rNt4
	7Ah+0PSAikzWL8N60Dd66etiCOwvukU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23BE14075F;
	Thu, 12 Feb 2026 19:45:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D94C4CEF7;
	Thu, 12 Feb 2026 19:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770925552;
	bh=Ic65mngQtaJXVx3RmUW7BxomzrEKSbMbTTCrwVeU+JQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XJ59lTq8UZ2u+Lh0XzobGED46KgmSHT058g4YXfjiYOFUYR0kHIa/J/A0+ZQvPEiO
	 iLqL3/5TrFz+hX1F6sRsBpJYPD9DaAn1aHkNmX9FQpixCQlPz4foedvzlw59yi8COP
	 yWiWie+4oNN18w+pLSFhL4mRxRPW8GZnl1PjsJwULgOrJuz5zM60d6z/h7gUjf6Ru3
	 5TR8adl9ofiry4MBq9nKc1ddLP0Nu34EOBKwrhhXjoAG0l4nqACaNGTfy43LXi09DD
	 DuO62fidnN3Yf0F6h6HMH+azgd1TCDe7V/fSDGkI9gK1QVykkt/xQxReE1JZIDQo//
	 t1f+/bmObxBqg==
Message-ID: <1d67ddd1-8549-4c49-bac9-29e49b540bd3@kernel.org>
Date: Thu, 12 Feb 2026 20:45:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 2/5] mm: introduce is_pmd_order helper
To: Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
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
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-3-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260212021835.17755-3-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B3155140004
X-Rspamd-Server: rspam07
X-Stat-Signature: 8u9dyj91t8a6fyifinccibddd4fxc3fk
X-HE-Tag: 1770925553-933164
X-HE-Meta: U2FsdGVkX1/ZbfgJG0ca0UddtfEWO4CB5l8YiFgawSEWfL/GnudlFi4fhPyIg2kMQpfFbQAG+FB7meXQ6o4WE2+nJfJY6tvOn1oEJhGEBO2HLymIWBiTja7Y8X7ATy3LoRGVjvcfE/++41uaGNeDc0T14b8G73YMGJY9yYfWxB5XKkCw1/2u6u/6HNp/uNwN8+GNgJAE2qVk7I0Q5oLTg8YrSoSEfY4XbZY8FTqtLAVKORLL0Wd8VIUqj7TIf+rXjdSb4AFrJvIrFGzOMJScun/zvRKySD4ZaqmcHriTN2uIq3jPrtS/oP80A84r+UNuvaiAx6ihyS7SvO855mrQnGKkyHg1j4T5E2Y6+ZRRnEIAQEtvyOVe3qrmAwIK3pz8+y/wA5TPcFN0By4OdT+bwnSa9lfPJpY+XaLOUyhvSNJ07I1mzHXy89eHoy4IFfJxaPpMJCh+d6S1XzZovzSKoHsLQ4gK+fcPbWL/gFGhpiKHiRQkErn0Xe5lhaSr2/00RNgI0EO76ICCgkNAuxWZYsFTi4x0TudUGG9wP/zmxUVJXQyWJkMV48DL3jkH5KMSQzrFeH5olg2glQc7kOoxFBmXIHjObGbhhZ86CIOaE2LWSHi3CWH11989Ygq4sqMMVV7b6GkY3WFpvAMWv3FPH5F+a29noamYJvwKfJAV2HNHqcgle2C7NG3dloZMo1Rz6+ABPPBw3XqZj0E521l5pQ24fEhNDKmdb9ct9iCXKeGubMfEgu4YI89nvKwnvNrO6EhIlRJyQWRBRH0vRlXXNp92Kh0pVtGkckbaKkGB4VcgJOAfg2VTZOSZyGBFKGg5PFAZAre+glxGYDm2SCM8ic4knujCE9kcfiGAVJPSmj7VxGaciAu94pqdgKXPpLuQeAk+WyLa+p9tTbabW9ByTF6ubF6DNl3qOcFeoFp35u8qfoOaylcPupxpBEYzwKzko38TtU2LhUVq+mx2pn0
 yy/0FI1Y
 szBoMaZkZmd5iavp8TmPdG9t8XZsCvqo10DTKoHB+3lvAv49khuS1ucZRCmdQ2gctqbNcgPmS9jE780jttm+CtTx6uH+7MO+9JpjirzeYISq9q6G173ARBOi2L0Kw1/8CSvg/w/TpikQS1HYuXUba81oh97C9NwNWGB447IaZLtiz4hSvgx1FlW+jjS9FiWpftKn+ioQ0yepSWvEnrjnSnFTQwTefSoWaMPaScfALPrd9gAMjZnuXC3JJvSXvwlb7hD6aG6KxcTMnokUNFsUoUho8cu66pbqElVmVLRoohZFKVBgcoTH1EpOq/VVtg928Etch+28taYoMzFEhIPfPgGlAZG7kqjdXdiXQDIBT6HSqetE/6X5YuFPLGUMPohjE7wZrrhRmieSQIH7kvRMq8PXP8AoanwuCDYMx6gQ8ej/j19X7pyYJdk2OhHXNvVtlv64lf9TK5gm9u4Rg0paFiv6ldw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 03:18, Nico Pache wrote:
> In order to add mTHP support to khugepaged, we will often be checking if a
> given order is (or is not) a PMD order. Some places in the kernel already
> use this check, so lets create a simple helper function to keep the code
> clean and readable.
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Nico Pache <npache@redhat.com>
> 
> arches#    pick b3ace8be204f # mm/khugepaged: rename hpage_collapse_* to collapse_*
> ---


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

