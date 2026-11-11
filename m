Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C9305606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZrKPgrKE
Received: by kanga.kvack.org (Postfix)
	id EB93A6B05B1; Wed, 11 Nov 2026 02:42:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E14156B05B7; Wed, 11 Nov 2026 02:42:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D037E6B05B8; Wed, 11 Nov 2026 02:42:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B33C36B05B1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:42:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BDEBEA0228
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:42:15 +0000 (UTC)
X-FDA: 85422045030.20.CD2D5CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E480C40007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:42:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZrKPgrKE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794382934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=173yMYYw7ZcLxgKiy0jg0nsIJyUryKORRWD5GlUnhak=;
	b=PcMQoq2Ir2TQOkUwD08Tk+Fj224zFHM03bVDbN76LQlws14VU5O+aw3pTE6GwjWnzlyajH
	jzVX34TcX60byNm++1fsTRiZ6XgiwwWDVQKD9nH08sKwy3OrPt4eaNaoxBng8mOW3k0duK
	0Rs1z6nWlZtHwVgdSuEJqPsRC3h4ZIs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZrKPgrKE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794382934;
	b=JcTDfTde9VTmeRxNbg0Qm+OL5rRdgl1yuqiQB9kRv4ie3m9XlVZvt5U5MeSJACqkhT3dU2
	IyYIyvxRyY7riAgJOfTKbWxh5ctve1tzInuyigeDqmsrhmS4TNbLsUZgdkZ+PAShkaKytx
	XsAnXAZR4ScKwU5TEfdH9Q8Au+EfOGI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 150AA4050D;
	Wed, 11 Nov 2026 07:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB16B1F00A05;
	Wed, 11 Nov 2026 07:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794382933;
	bh=173yMYYw7ZcLxgKiy0jg0nsIJyUryKORRWD5GlUnhak=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZrKPgrKEYhJ3yrT5CDmjH+84XqAPuC8dBR6n+o7uRVewZeDxtBU2esNhdUhlKZDGE
	 5/OF8Zp10h+LNC4wePwc242X5r0kA9voZ5MGuPjjE5dVW3bbYyojijX+SXp25q5yz7
	 pterk5xVQD/sj/5wJ8ps8IK2ZzriKEki/mJ5baXKQLA0xGsjApnODfEKbZLLYvQOzN
	 +HjL8O3rKTiiWnl5jF5TLaKxnviMquCws9mMONye0NSZABK80mzBQnPuPWKNps/mzh
	 InlthapJu41kW/sIjVNzmijcKciWkTZ/IObbE2c61U2ZW++XL25Arq/TAlS9Yu5PsE
	 eDcz2l1F79syw==
Message-ID: <0a971398-35d6-457c-81b4-0fd706da12b8@kernel.org>
Date: Wed, 11 Nov 2026 08:42:06 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, azpijr@gmail.com, lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, stable@vger.kernel.org
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
 <503c9f6d869e3206c6fd591de962c3d619b73825.1794379433.git.zhengqi.arch@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <503c9f6d869e3206c6fd591de962c3d619b73825.1794379433.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E480C40007
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 1ofxiiae11ndsx6s61p449g6ykk7oxzd
X-HE-Tag: 1794382933-35311
X-HE-Meta: U2FsdGVkX1+stdqCFgmPU1RXT+S1HpK+RepRq+zcq6P0+E3JIZcUCSIj0mNVhqTyoW9vvdE8OTaeXfBTiPkXGMHpcDh1Ivg4X2mW0bYQqrhIi5fC6jQ9fiS1P7CpO26X/pAPNt8AV1c259x6FYRdt2o3AEoLnzaixF+tcdDdbepewHyZFK0YVhrM49ctvZGymH1bhRg0jgO0mvL500pjVK3j1t32pQ5uqNc7HjoSwKLjVFK3INCxkcdN9OeMicSVPhFvaN+fOzi65mkM+TdAzRDxswtdMZT3Wf1txRwW/zU7zo33HBF9lsmxQaAjrIfzicFDXbAJGujULxcP2A2WgCAiQBm3guDu0nIkoIt4v0h890gb0BQMMF66jXgOF/LRgvKxUEqguGbRRF+6dmexBTgs5jr34y7mANtDw+55gCmRRYT2mocexwkE2KSM6cBpT1ZEwfOVe8o84XH0yL46V7EN3eiWYMhmtEXQB6yQcCF0L3Dyl5p0iUAIW6xHbU81u0zbZ/0q4bxs3Ffy0WgUbVJtQO3jBDlDRdWUwLS6/oQhvuULp9TEGDfd5uoR+0MDftGNdEwlwlKTIwL0bNcp0XaFOgL4cRup0NMlquVeV7tDlkaNd1VmomlUwrr5PiMkJzxaQKbzUljFotzTVvn5BqNQ4owsrmtucTRyOl76+edw1kHwMZTrBRfV1CEvK9bzShKnaKICtZlIiclF5CSJzyJpu/FmGqdas3N7Rblndl8JjOrL1U3UGnu8UGqhSz6RINWF+M//jC4BRoTJ1v5De2HkI3+vrwnY8lXVLTbbX//ak6pxikX//AUXumWUHDCBKY0I5pDnvLbagwCqVS5CUH3iogObFfzWkgJ7kaB8p7bksidqd7uR4SVkFfY+oY/hvGtaTBdm+DDaJAFVKP89x7ajTdQ6AiTiElLj9cclujxWeM/92j55TWejzz3AeNMCCy7+8ZAkZi++ILBcUXZ
 zHcyN6nJ
 jchMFtzg5VQ1PzcMfuc77bA9ydDoy7vHp2Z47cyE/4PYZVmxzzBGO2EnY4NWJGez7AggS7YMYPnwqzeRMMg1OttWe9t+TDR3gj2MolmneNOc34jlKdKwW4N/u6EBm4qCo/0IveWU9ZBNNAFVvqCaiuUlq4ibPSu5WcC/vPaNwRosi0pgvZC0U/HEjeoWgKmFq6NdNu/6nPaUfd2CriYSD9Xr4lk57NFeFqS0k/Iiv4qYdBW26dO6Sq1PqSUivNetdpVpTc+cmRB3QlqzKrn3pEbAbHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 07:46, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
> unpinnable, causing unnecessary migration or pinning failures.
> 
> These folios already own their CMA bitmap ranges, and memory blocks
> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
> HPG_cma to be pinned directly, including in ZONE_MOVABLE.

You should really describe here what this patch does (move stuff) and why, and
document why you decided to add more hugetlb hacks to core-MM that I absolutely
hate.

-- 
Cheers,

David

