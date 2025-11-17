Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9C14CEBF61
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 17:15:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CFE28E0014; Mon, 17 Nov 2025 12:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FD38E0002; Mon, 17 Nov 2025 12:15:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F8E8E0014; Mon, 17 Nov 2025 12:15:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F39808E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 12:15:15 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 729A7139D49
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:15:15 +0000 (UTC)
X-FDA: 84120749790.12.5B74AB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id AC90F120015
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 17:15:13 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bxbrXTDR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763399713; a=rsa-sha256;
	cv=none;
	b=O25Kf+lJWRddNtG5/2HkZC2lxfW8Pc05nSXDenzBvTSYAXqWbWSbYATSI2JlWhW6TdUOhT
	/ixkfIc+uvf03gEKAni8VL8T1X9h9S19Cy3dBhiuw35kC21cJuV7+R1ffaOqPxzgqatIdJ
	7RFa2C1iPuWg9Qkgk1iSmyvlzI009zM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bxbrXTDR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763399713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OAzmOiNgZHj9E2sHRH6O4qoqDNtGS56byqdGrNZH4jI=;
	b=VhcvGgBzn+lddQX9KTQrGwmeKfku0jpwf7+wjMH4i08zqNGfGBO/S2njHJ6yUsea9FYQ1n
	N33yTH27tWczyuRG5NyVV/xXHxCvAd3bs51TlfYm50TuTXOCYSlkEBcNQg+OXBabUzTJgQ
	fA/Vgn1v5kL9uya7v9ASrX99V2og8dc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0637F6023D;
	Mon, 17 Nov 2025 17:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9913DC19422;
	Mon, 17 Nov 2025 17:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763399712;
	bh=RLJWDgvqexJm3kpqTl9EZT21sIb+C2Qyt8z0WQg5EU4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bxbrXTDR84ASz4tPia6zDAvidOkIROEQEVrS/yyvBNhsrAhCaKYTV112+R5LelGFB
	 InCyMARDK+hXkSXbbxVgeKbwVuhXdG9Yh0+m2kg9c3sQT3/8cI4SSnUY16OdAujjvW
	 uWuQddql+Nc7DiV9Sy/n7TcNnn/xIyyeGgNcjqUSSlH9+AbGVlDUt5ZqK3BZnnketu
	 Uy7uwb9ufarWAAZ75hnHiCLrhI3TYfQCzAfcflxc0CwsSTP8sO9HIfAnMH5g4qJeyh
	 nHrA8yWDZDzzkWUK3By7nEghAXuTg9/nkAPxcyCnBHAwW++NssX7203zMAgbqOcYdt
	 ZcB8/XtwKCfzQ==
Message-ID: <bcfd5575-cff0-4ead-9136-dd509bf11f64@kernel.org>
Date: Mon, 17 Nov 2025 18:15:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/2] mm/memory-failure: avoid free HWPoison high-order
 folio
To: Jiaqi Yan <jiaqiyan@google.com>, nao.horiguchi@gmail.com,
 linmiaohe@huawei.com, ziy@nvidia.com
Cc: lorenzo.stoakes@oracle.com, william.roche@oracle.com,
 harry.yoo@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 willy@infradead.org, jane.chu@oracle.com, akpm@linux-foundation.org,
 osalvador@suse.de, muchun.song@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20251116014721.1561456-1-jiaqiyan@google.com>
 <20251116014721.1561456-3-jiaqiyan@google.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251116014721.1561456-3-jiaqiyan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC90F120015
X-Stat-Signature: cj7qzzagfqj9b1kgm836upybxq7nz1dg
X-HE-Tag: 1763399713-829379
X-HE-Meta: U2FsdGVkX1+5yL6Lx7/Xuyd4UBBb8WotxjxwUaqHE2j/B73z7jLC6DrzQwmzfDuV4l2nTg+2MXJgWtqMMOGe72wHCg0QbkSXqXW1BhyfaphUNd/tVR7npITCjE2t77lywvrk0cDdBvcT8bFFBAqg/2De/2wCukQNis/5w11ZokRFT/Zs6cxler0sw7X0hYyQ9kYHVIQ39MRuVXa/2uD7bzDUrTOk8JU4jX6bi2kdeLIr8qpu6+W2fA/Pgv4Kg6i3tbDuS4SJ73YpTQyxs7k23bUQSn8H86gFSaJuv/RfAf4oHlLfZnR6qvy3vkKmipxsQup9yVO6Ganw11EsVzbnv1sVH5GkedYEk4dD1zBE3pP+CqDtFEFtBr8hYsM0ZzJo1egJHxtpBOc8ydBPvsJGSCA2MHSim5hLbDEEQc8e6eqZzryZPBgBNoGNxp4y8z+gJ51eHrR1opAYrM9UqXwXqIprwLAm3PI9uGzT2PpyG2NYyrGNAgPa52svVvqazqygF/16tnJvUHYup49WVw7SFGCR7Fi+Oy5vmtQ3G83KR/jxZLqgqF3SNch1VUY1MmwL1hSkMy7F8zghBARxLgdikwty8z1kNn4MdrquNWTk4FlDlL3cuD/sCUNutOJCHP/TbIYAiDUqRufBYDHytS0L4aIVkfTYvXCCni5fzJFTzhC9duCF2bqQTtWJBR/ShrmBX/CB/srSKMEcP7fuOcqkefrxlGUsgv1QPPxfO6iga5mIf15Mm/qmnsPW5WCSnr5b1/V+x+mAnz9i9y4gyiV3g5mHasOszpBDj4YIKb+KBI4babB3GeQqO2xSHaY+urDCJphvz7ihTdsCRF4QR8ntlt/YT9xUfgIAEjl8d4wqzbcHjHqfd0OtDbYwGjtTB/+ewNPvVh04y6ySVKcSRE4i8IHHjFUy8CLbSgLvBE9+M1h3dWsXcQ3EoGcv2OlpNOy0D4PndowLVJ5fyfjPX1s
 QE80TRAF
 YsZqt9obes6BZ9dQ5fgatShDTDy73u58GsfcD4h+nalA1Wi+iiUIl6ERR7/9HDpR4l1tt4xkxK8ISNqJhQvNxQhEwwECztvL6HZWy+l6ACjNsC/08tb1gbdiliyb1ulPkEMReiFzCde4X+6hquOQkm4oIBpYGtz+SvmLw9kZcxzXiVgTGM9fZTx4fWynW2vM0izmOjc3+Tz2JzbbQVDd9ahxzgl6awWRx+w7jCf2uakZDoDXKQ/vT991cYGHosX6N78a2rzjDHPctimILEUGi2Q2Ou0vO7m12oBBy/rdS/5chZTmZ3bCia0sAjYOc4APd9y+eY7Wnkx+pG0crFj+dm8OVQ5dcB9djEc/ZoCo7+JEQYrGl52AuX98uQPyyECghioSI8JDAuW3aCRsAUZTccPQwvyrvY0z8VxMpqNfCj58kQAFY5Z7RTfbBJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 16.11.25 02:47, Jiaqi Yan wrote:
> At the end of dissolve_free_hugetlb_folio, when a free HugeTLB
> folio becomes non-HugeTLB, it is released to buddy allocator
> as a high-order folio, e.g. a folio that contains 262144 pages
> if the folio was a 1G HugeTLB hugepage.
> 
> This is problematic if the HugeTLB hugepage contained HWPoison
> subpages. In that case, since buddy allocator does not check
> HWPoison for non-zero-order folio, the raw HWPoison page can
> be given out with its buddy page and be re-used by either
> kernel or userspace.
> 
> Memory failure recovery (MFR) in kernel does attempt to take
> raw HWPoison page off buddy allocator after
> dissolve_free_hugetlb_folio. However, there is always a time
> window between freed to buddy allocator and taken off from
> buddy allocator.
> 
> One obvious way to avoid this problem is to add page sanity
> checks in page allocate or free path. However, it is against
> the past efforts to reduce sanity check overhead [1,2,3].
> 
> Introduce hugetlb_free_hwpoison_folio to solve this problem.
> The idea is, in case a HugeTLB folio for sure contains HWPoison
> page(s), first split the non-HugeTLB high-order folio uniformly
> into 0-order folios, then let healthy pages join the buddy
> allocator while reject the HWPoison ones.
> 
> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-mgorman@techsingularity.net/
> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-mgorman@techsingularity.net/
> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> 
> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>


[...]

>   /*
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index 3edebb0cda30b..e6a9deba6292a 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2002,6 +2002,49 @@ int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>   	return ret;
>   }
>   
> +void hugetlb_free_hwpoison_folio(struct folio *folio)

What is hugetlb specific in here? :)

Hint: if there is nothing, likely it should be generic infrastructure.

But I would prefer if the page allocator could just take care of that 
when freeing a folio.

-- 
Cheers

David

