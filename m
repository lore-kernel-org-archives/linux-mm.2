Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3B93606A32C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 10:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mOEZw52v
Received: by kanga.kvack.org (Postfix)
	id 0E7C76B05C5; Thu,  5 Nov 2026 05:33:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BEE86B05C6; Thu,  5 Nov 2026 05:33:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF25A6B05C7; Thu,  5 Nov 2026 05:33:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B91B76B05C5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 05:33:16 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5709680957
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:33:16 +0000 (UTC)
X-FDA: 85400703192.20.12E9F77
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 837E440009
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 10:33:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOEZw52v;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793874794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rW1nil3E5bYjTHxZT0jjYetDQyPmr3fpWazFoftmXjc=;
	b=Y8DAHOI9cZ8WtU4MW+AuwnFyw3Qm3n+uHbngZKkFlqkMJL4QzHCh6lOwKsj6SwXnbe5cGL
	/IYyWPTugo+H1vBwfICZzJ9urPxc1eCNh77ztLTbMhQAVZDy+OJ1A3G8U/SfI47uWhGNCt
	QmUHBpqwBOuW9eFmEtSI1XgMGpP1I68=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793874794;
	b=c9vVo10P1u5sYSMEWNbgkBzELBMiH0enuca/H9Im9zFTac/gubYtcFDF37PquUpmNeOksT
	7dlZjBAFxEZ+8EXRXDAyakpvNN/adeIvF8ME1RFG/4UhhY7nHMvYEV5TgltqMMIXh0QSnL
	oryztuYbO4LKfh97VXTcGjzs44XxoZA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mOEZw52v;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA67D43C35;
	Thu,  5 Nov 2026 10:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B2B1F000C1;
	Thu,  5 Nov 2026 10:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793874793;
	bh=rW1nil3E5bYjTHxZT0jjYetDQyPmr3fpWazFoftmXjc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mOEZw52vLFxK3rc/1pzuqdBC+HQCXx9mY2v9zCS7MB1PkcO28hR8mmYR7mquhduqx
	 nKCn9g7Qvm3pg2oAHDiffpJ2cDU2GqwF4uICQfDiPX4l5/O9J0qmW85ilAgvbRkP0U
	 1FSFR+Ow6AcRdFnndQOPSSu8RyMQ6V5tSfmrn4gdTkXN58WdIUPJ9XvCdUZ4NB8bgh
	 6pugwhg/dQzmCTa3DNeZNaV3LEU+nCDMPPQyPQivmSGt6TfuLL0FL0WkFPUM/3vgbU
	 A738imanAEwUusrWHcmT2mo/y2jRAKtqB2LSP30ROQRnYP8nrNE4QqaXB4uR9PXbRN
	 KZJLF4jYWfzXA==
Message-ID: <0851db25-fef3-4f96-8d37-81ad5c51d6c8@kernel.org>
Date: Thu, 5 Nov 2026 11:33:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/4] mm: Enforce read-only shared vmemmap tail mappings
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>, Lance Yang <lance.yang@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani
 <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261019090830.1917657-1-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20261019090830.1917657-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: egg4qt3yfyrftajqxxnjpk89amtjfyqp
X-Rspamd-Queue-Id: 837E440009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793874794-458895
X-HE-Meta: U2FsdGVkX1+2BKc2owqxTS87Q6Z93NAR3GeJSThvwDaMaWf19/KyVGAqqs3UvF7aMwUiHnO3wN+by65o7K/EN0JjKD+a5YyCfJcQptcau+JNGSLc739wOrUpe/ZR5vZcALXAZtTFNKNg0MD7q/CVTfE2TT3yaki4P6SvKa/9oK66vMuRMDN6O+M7Xro06/pGk+yho6n0GNXe25xFvhGsOrR6CwULEmLDIpX61oZ6UvDZNPEeubzCy9BEvjIdsyX1zus9F4fN8Yjle/olaQxHp7GxSx0yyxS/9lB1TJmly5tvYQ0gwnwDAPzYNK0kZj1b0Nyo2+WAow4dtozIP2vHFgyT5DBMXPwA5m2mNlHSt6XHupGKomT1r2xtoAVTT8wkjnnBMZO8bQZdkQ23jDkKqRkNfa0DeJ+KdwA0/mD6IcuKItck3MneNjLLn5lTJudOu41yEAnSp0RAnViq7roCEzbo2b2kSPK0pZBHMC7qSQcDjliuRTVln9F+2ozES9q/coVUm1+4p3EpSaWzjBSQO09dnT2qMHqF+NmeGdH5frOI+Ipzu9Fy7h1AX7ylOMpw8GM4ej+QePTbQOZgGyODBgqp+z9LYsu/2QsVGR7d08SL6W6jp9Z0omt6mVJ4842CbTGvG1dCdg61flGHpmBYjJlWV9dq3F5TuOjX68TQKPVuTWaYNfQMgjwN9Kna1wvVJ0ULno7311O3Xi4s3Qz7jFm90tRgBzN24lrXKyqzgswlvBmx4e1YWnMK11FOlLTQD6JY0s9/WjyMXJ2APzneEtDttK/ApN4KM5jultWUGqO9GtJcxT+Tof4BDkn5kaWsMQ8YjFpYLQOOstN8k+exCCRisicUZ1LyT8mNKb3N4ju/pqxMQ4sd26lt7Xkfu6pM7wNR/408dQ06SHTSObqrhx2QtupEdcXZmNcZSygDb6gDu5XuHcZGV6cb859tukDuaWzWW9az4NrcFoMsUqP
 eacRBy6x
 VwCcKaYnfl5tHT2lz/A98VjygCR6xLXCnp4jgTuo2KvNKrU2wiWpQQ8ZG7mhteIPgSJfGJ+BxhQ3IAOp14vm5c68Cx2u7N31T5XOxb2iMdEt34vw4WsBFgF9Ay8sdIkBF9iUNU1STdHneo4sK/DQj3/tk3BpWagia8TBRFk+9+53p9uArOo78dWfGZhulSa5IaDgFVUVFeBFCyZGMHdpiLwJRDUknqcY8ANVI9+0QNODZ2xT4Lo96+XoeszwGWpQ9K8YBYOlUv0AnwOVG+mzjr02WEoP5hZyqQO1me8M9owqbuK3/LvTsCSdoelXq98MwaAoRgKKqvnyARHxM36yXK2u94g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/19/26 11:08, Muchun Song wrote:
> This series is split out from the earlier, larger series "mm: Generalize
> HVO for HugeTLB and device DAX" [1]. While the parent series generalizes
> vmemmap optimization across HugeTLB and device DAX, this subset addresses
> a single, self-contained step: mapping shared vmemmap tail pages read-only
> at population time.
> 
> After the previous HugeTLB and device DAX conversions, both can install
> optimized shared-tail mappings during vmemmap population. These mappings
> should be read-only because each shared tail vmemmap page backs metadata
> for many tail pages. HugeTLB applies this protection in a later,
> subsystem-specific pass, but device DAX currently lacks it.
> 
> This series moves the protection into the generic sparse-vmemmap and
> powerpc radix population paths. This protects device DAX mappings and
> makes the HugeTLB-specific vmemmap_wrprotect_hvo() pass redundant. With
> that pass gone, the bootmem-only optimization wrapper has no distinct
> work and is removed as well.
> 
> This is intended to be the fifth smaller step toward the broader HVO
> generalization. The remaining HVO naming and enablement consolidation is
> left for follow-up series.

I assume this patch series is no longer applicable after we remove the RO
protection for HVO.

Or am I missing something? :)

-- 
Cheers,

David

