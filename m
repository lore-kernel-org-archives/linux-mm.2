Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E024BCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 09:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1966B6B00D2; Thu, 18 Jun 2026 05:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16DFF6B00D3; Thu, 18 Jun 2026 05:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085A26B00D4; Thu, 18 Jun 2026 05:34:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E30C6B00D2
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 05:34:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F64414043B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:09:50 +0000 (UTC)
X-FDA: 84892460940.29.B50F73A
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id CF5614000B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:09:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iaVcoVSi;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781773788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKrBJr5QmN+p5FbcRlDp75b6qG882022YARGfpuKY7s=;
	b=oK1O1ntGHo/y9958/tO+ZN0Q1F75L24ELxY1zLsBQ106odK8Elo2wQf7SkNiupFvVHpcJs
	FlGX6GsoFIPfgH0gn+VJS068+Ii0pfdEhXzlGkoZhaBkJlv0nhP6g8RR3PeX73InsMyz9I
	iD/gvs7Ja+/Wp8/X1ahZiJPQO6ypKaU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iaVcoVSi;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781773788;
	b=M/imSCbbj5HfqWBY4nt5FpbyR5qjkyDHcWKMCwjMUeT5iDC06Q96BdEwEih+d7Qnomdpyo
	r0npfAhIH/JhGyRd0emD8KuWiEZjOCBntroQ1oWWBzvrUFsNteueATOGotclA52Xr0gXHX
	BOvR+NefTX7+9k6ITRkC9hnMAZErx6c=
Message-ID: <0fe2a584-c633-4f82-8c47-d204e3b39a57@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781773784;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WKrBJr5QmN+p5FbcRlDp75b6qG882022YARGfpuKY7s=;
	b=iaVcoVSiDIAOGWJUuJNAp8Ahx07xCPBuz/Rn6y8sE6PY32pmlFgooAFFRZJLl1HreGsUMs
	NHy+Pf3tnl0QlBrwxn7rDoaiYpKoqBh6B6eag51TlKEAddnPbcx/CZr/YSR/arQESvRcdp
	TertYgNDaOYeIzia/R60F4s2Jttch0U=
Date: Thu, 18 Jun 2026 17:09:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
Content-Language: en-US
To: "David Hildenbrand (Arm)" <david@kernel.org>, dev.jain@arm.com
Cc: akpm@linux-foundation.org, ljs@kernel.org, chrisl@kernel.org,
 kasong@tencent.com, hughd@google.com, liam@infradead.org, riel@surriel.com,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, baolin.wang@linux.alibaba.com,
 pfalcato@suse.de, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
 <20260618074449.24974-1-lance.yang@linux.dev>
 <d6259e43-e507-48a4-a048-93b5df2f1b62@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <d6259e43-e507-48a4-a048-93b5df2f1b62@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: CF5614000B
X-Stat-Signature: fcgh7n4zpc99zmret58fdm798x9ipsib
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781773786-506568
X-HE-Meta: U2FsdGVkX19NCl104Qnn3uYyy1fB13U6n5zx1Le0psL7ighNRd6oZ9fwPt66LDrwjmI7DgLqTKAs21MX+PKp2SZyMVOloxrBDqTA+N2uqvda/v2Hf+mixJ8PPRLIkKvG9quRqGUEByKlg8A77ooh01szcab1853nBbrZCYRd9pazoZx1WMIE9wt9LD0tlSix3+EMTbiHJ8dIlkwWTcshpJKVCtQb9xkztAdQHo+PS5OmhKQbXhSl5F6DGr41v4ODh7XjaAxmd8NbuB5a5ZYXeHECQmNNh2Aj392dTVG+pbEDwsf/varpRMeJoDOSSPPAUR3pcMIpPFnomTKqTgAFcJLOGBppVogkOCYnwtNQRoVN5bzbzktNick3E1/cKFKnUELkWm1THmoRBa7AE29DocgCz3MPQgkK2WUHE78fVikn32YVUua/4Jy5pEucnEpIqEArgi7mo79iUgHZL3yIx7cAvfL4yuXbJTaqBGuEnG+v27p0zFtzil5/NrZnqo2FvMYL7SmQLtrO+z7tS+iWUwJR3jhFfdVIe/fNtwkj+fDyC5PgzIhlxjCRMh9zIlNXyO9A1jseFRUH9RoZruy3NR+XaOqZFCLd5k2lYa4Pnxzo02be+Q3Jd/pN1CaplBgqhgUJx9CthNAyY6+HFVXVh6V4zWP7116qm4ULCgVZvx8Y2Fb9y+UBAkQkHJmOf11DRXS8+h6F7JN4kmS3CZU1A8mx7bx2exs292KTX1OeqGvtcJP1h/6mtxlOi3Oj9lfiKZs4n4KIJP4Z5WnjK+GpEH9kJmkm4Akg0yDNUJ7ha7tPM5QVmzdW2x9pa2dZtckinRUdyHiNw75c22d258P78E6CUeneDdXudFEV4nCNV1pj7ReVQlbQIakPes40Q7lIpa6sIsaQti4fVsz/CIX+OfiBXvKMcukt/xEsJN796SvGFsUzv/yYA3wGRfl5S+1uMvtm7fXhT2Ky3IMNpy5
 y3khOYV4
 ne2DjvmG38Y86h1tjdh7eO9AaaCUrAJ0O1cWg/WpHdOLStf1qhNvWpQXpVAO1/eK4O+8nIYcKqotjY8e+iu+OJiF3j1uiejFCBLafkEB0UnMl4aEWNnyvXTpAnHEj/pV9Cf0Dpjg3tv6423+LSCIwuhsfOkUoFcntE5auMwv3g2uxe3O0ugTX1/NZItqQR2rPqCeAhmFoC146YKKvbIicZxUZZHPFzaWwjZfbCLooZqePNQdNrxm351MfYyIwxCUj0tUK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/18 15:55, David Hildenbrand (Arm) wrote:
>> 	return __rste_to_pte(pte_val(*ptep));
>> }
>>
>>>> +	VM_WARN_ON(!pte_present(pteval));
>>>> +	subpage = folio_page(folio, pte_pfn(pteval) - folio_pfn(folio));
>>>
>>> No need for subpages.
>>
>> So plain ptep_get() can feed raw huge-entry bits into pte_pfn(), and the
>> derived subpage can be wrong.
> 
> Good question which impact that might have in practice?

The subpage check can warn, but we still pass that subpage to
make_hwpoison_entry(). So the hwpoison marker can end up with the
wrong PFN?

+	subpage = folio_page(folio, pte_pfn(pteval) - folio_pfn(folio));
+	VM_WARN_ON(folio_page(folio, 0) != subpage);
[...]
+	pteval = swp_entry_to_pte(make_hwpoison_entry(subpage));

