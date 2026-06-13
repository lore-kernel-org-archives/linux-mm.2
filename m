Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4184FCD98C5
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 19:35:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 383876B0092; Sat, 13 Jun 2026 15:35:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D266B0093; Sat, 13 Jun 2026 15:35:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FBA76B0095; Sat, 13 Jun 2026 15:35:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C63D6B0092
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 15:35:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F46AA04D8
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:35:10 +0000 (UTC)
X-FDA: 84875892780.23.A56A21F
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 24AC7160007
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 19:35:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HNoEjJb7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781379309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtZ58HMyb2KWleS4KaZ+M8+Hcfntu8GbwUU5x+HyEbI=;
	b=5ti81k3jiFj2v0momaxkvBPdc4ne2bB3iNt3lTTu2Y4HYlWkfvv86B4djYz7uSFBHkuRfn
	OcXy8e+WN2Y8z6DXhQB+In2UpVtjJtVeyC7F4Rbe68hBO2XdA8D67fZHdFUdCX2Dkf276U
	3LACrDTh9pRWGvAkBEwOTmaPMXKqv8I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HNoEjJb7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781379309;
	b=WZU90KKt+uVWXLIHCGiIT7eeqMYUWmoq/i6xWkXem79PmeEOMmnAgdo0JbET5/73J/V16m
	m5AP7nHwRsDA5kAQ1Tz36IC1YXqZqDK+Kfz+36P391rrb+NSt2XJ584yKcK2nvIZlsV3tl
	eAG/0k8CO/3lWkfqqxAhIZV6bdEa28s=
Message-ID: <e68d5c68-9b4e-4959-a507-a9f94f3ce6e0@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781379303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NtZ58HMyb2KWleS4KaZ+M8+Hcfntu8GbwUU5x+HyEbI=;
	b=HNoEjJb79tKVpnf/gfxxUOlyv1qOtaVi8rKP6rcqCVxgA+dih6PGZDXtimzaRUc1BhkdMQ
	cUOmq9BxRA1czVg5oKbD3Ptzc3+kRm4dpoaEr4o5PumNO0WdMpixO3XjxWixxPelUPm0BA
	eEMhBFKEnwbouSVkJZ1v7SVoD5PQg3g=
Date: Sat, 13 Jun 2026 20:34:45 +0100
MIME-Version: 1.0
Subject: Re: [v2 00/16] mm: PMD-level swap entries for anonymous THPs
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>,
 ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 npache@redhat.com, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com
References: <20260602142537.198755-1-usama.arif@linux.dev>
 <aa712058-7b4f-4421-b265-c3173fcad87c@linux.dev>
 <6E99CC4E-A026-4DE3-8A5A-34216771F521@nvidia.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <6E99CC4E-A026-4DE3-8A5A-34216771F521@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 24AC7160007
X-Rspam-User: 
X-Stat-Signature: 35of3cbfr5azr4dyumfhb4n97pbcim5e
X-Rspamd-Server: rspam09
X-HE-Tag: 1781379306-304833
X-HE-Meta: U2FsdGVkX19mh8szALuwkf/mG9cKqKkooC0cAqysJjIr6HlkzeBDC+dThz4K3OSpBOtN3jgu3YdKUMJQagKX7Hg6ZqZ0zZyps9fysW2Ekw6hXeX0IEXGWkp30VwHTL9A+X1m8Mkg5XlceQR34hpWE79mkKs484XVChK9TNCW5a8toDGbnFrYq0TBHSvUrtniDK7rbWFbh+NwB23nINLl20YvR/Zc9WmZAdi+FYEuXkE/qc357Nxos6yItb2lbwAtE9xCA8pz85rWB6YGBMagOXC2m6+8yWOL+VIwdjoahrNUO4SAhUY7kYVVyvYwm9+RsR4TlC//XDTMe3X07Vjey7rrzOJWO0g5KEiHNBKNfHUNRlvFYjQOvIMlNvqfciHvb8FWd7OIKKuuK7nZopbw+VOS8zD7ymdnNQH2cgFua4GhazzcKZfkDuy9kHEWE22FE1UYcFEQq8oeCRlod0e15WG5yyBd6QRbQ0kmk4RUCnN8GotU129tawX2z8PpKC+GaY30mxonAdbZS1gfDAOnJFIZG87ZnnO0zn3lSHU2aZpOdfD7V/AW5FjB7hruhmZKVZY/XRLSCsW7pzCQq4Annf93XiYmhy2JjJx/Y3uEAvj0QHfH0dB/j7zcwV56yGsAFiA2MlTF6gOlnZWL9D7c3tM2GI6gfg+JfERpEWxMbB/obVolRmgz+MZYBq0H9gmhp9tFHNKNBcEkDMl9BZuFCxE0SgiDo62XVuSlWuxB1jPEipNMu0KJKXeF4DO+nR6gv+VIc3jWyBfjTXdOtJK3qlWWiOrCM5SWgqoMjL0kMgOnQIAdR8V5TjmJS/Xz0dTMKyq7e5QjNLpKCWy/etAV4ojzjPx573JZBQUPw2SvDlKERqALl/+9z1gV5zthhGjR5jh+YTfUG5Ac/wtHDzSV3r1gtS8CMkGJINA86BnNhT6YqM03l2TG0b+924d+KBKnTpZuF6MSoPubLpMaiYu
 2dLImXSi
 Etuwdg7eeKhkhMo1tfxNbKP78XyNWErJRdC1unikZ3R6nSKs3xjvhA1ywkD4jo6NsWNk0bRdYusYzSRlHYXuAYlQPc58o/ZSowI6vQWZmBty4BWdrjrJRaO88g+QQLcMHxuiF2G48OauxaumP8G54Q9I9qOlf8sypbnQHtsjPet5G8Zq/YBHghp9BhS5/9eWbSGvV+u7P5HOGGE2wjUwBZgfUng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 13/06/2026 20:27, Zi Yan wrote:
> On 9 Jun 2026, at 10:29, Usama Arif wrote:
> 
>> On 02/06/2026 15:24, Usama Arif wrote:
>>> When reclaim swaps out a PMD-mapped anonymous THP today, the PMD is
>>> split into 512 PTE-level swap entries via TTU_SPLIT_HUGE_PMD before
>>> unmap.
>>>
>>> This series introduces a PMD-level swap entry. The huge mapping is
>>> preserved across the swap round-trip, and do_huge_pmd_swap_page()
>>> resolves the entire 2 MB region in a single fault on swap-in,
>>> no khugepaged involvement is needed. swap_map metadata is identical
>>> either way (512 single-slot counts), so the PTE split buys nothing
>>> on the swap side, it is purely a page-table representation change.
>>>
>>
>> Hello!
>>
>> Just following up if there were any reviews/comments on this series!
>>
>> I know its a large series but was just checking if there was any
>> feedback?
> 
> Maybe send first 6 clean-up patches separately to get them merged first?

Good idea! Will do that. Thanks! 


> 
> --
> Best Regards,
> Yan, Zi


