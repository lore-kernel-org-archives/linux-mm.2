Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8611EC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:05:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D5A6B0005; Wed,  8 Jul 2026 09:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E39F6B0088; Wed,  8 Jul 2026 09:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FAE46B008A; Wed,  8 Jul 2026 09:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 30BD96B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:05:45 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8EF581C0D1C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:05:44 +0000 (UTC)
X-FDA: 84965631408.02.60EB47D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A300514000B
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:05:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jMQd+R06;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783515942;
	b=o+LWNu/p3S+T4f2v24oUxJGoqX9zuszp24qNuGCFAHp76nzUKzsYcPE7C71adtSTvE914N
	B9Iz/9izcn0wpZejpYG8mjDPosJPoM7j0nh0EomMdJK/t7Cti2THpK86X/eiSueT9p0rI5
	mbYvSXed+hWZAKpQKLnnO2AnNkPwY5k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jMQd+R06;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783515942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/h79yJy1u8ZSyvoFD94XJpXFnCee2Wtxipv9HGt8DnU=;
	b=geMncOx1phgzr97MQq3jXe47HZj2Rm/nmYhsmLgTg5+weoQAeOaMX3by7sEa6C7QMApaTu
	8XqKZcZF/JzM805Hrah1tomX6zF0BUFWSrYBmHyFwNEwUflfrPj2CuTzksPZVK0w6dvcwB
	K2RCNnjXrZChi5oeGPPMxoq3fmrZ2I8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8AF3B4130F;
	Wed,  8 Jul 2026 13:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D561F000E9;
	Wed,  8 Jul 2026 13:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783515941;
	bh=/h79yJy1u8ZSyvoFD94XJpXFnCee2Wtxipv9HGt8DnU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jMQd+R06mzZYgsdxXb20iIuLqDkr7+4IpgNO6Fh146lXX6Xz1IyGtst36WPpjefzz
	 upJRA4vZsJ0kyL3yDnb+rCLdJHmQzDZ6L6tUJ5a1/+P9+8JWqFpIYcMxsAdGu9fN1x
	 XPuBpQKzcjzyrK8OdaYQs9SF59D4UbxIFuel+gez5AedS4oMqf4g9QrU5+FR58zxWY
	 /FT4cCmoumhfxYtZXcorJzMtkZ1milvS8M/Mwpb3qUgF8R0hNymKerLoj3vGgj7UCN
	 5nMyaDc8YqabDbjbMbAI/PGEgq3LNBsIjYoM4SiXS8v2Lu9madudvIZaxxYHLV3BdK
	 og3GvJFDcCbbw==
Message-ID: <a2e8e3f6-a922-456d-924e-28ec57e1bc5e@kernel.org>
Date: Wed, 8 Jul 2026 15:05:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/mempolicy: skip non-present PMDs when queueing
 folios
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, apopple@nvidia.com,
 balbirs@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 byungchul@sk.com, dev.jain@arm.com, gourry@gourry.net, jannh@google.com,
 joshua.hahnjy@gmail.com, lance.yang@linux.dev, liam@infradead.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org,
 matthew.brost@intel.com, npache@redhat.com, rakie.kim@sk.com,
 ryan.roberts@arm.com, vbabka@kernel.org, ying.huang@linux.alibaba.com,
 ziy@nvidia.com, shakeel.butt@linux.dev, hannes@cmpxchg.org
Cc: sashiko-bot <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260708122040.861335-1-usama.arif@linux.dev>
 <20260708122040.861335-2-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708122040.861335-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A300514000B
X-Stat-Signature: qosi1mitb3pa9f98dq5jzjjb1cpzncaj
X-HE-Tag: 1783515942-696721
X-HE-Meta: U2FsdGVkX1+HjaiOps5p+x7vGgfVc3LbDjEtGkzxYo6fddwxFikGm1Amt7wYf2DlUuYWDSGCXCHYGUlAYteZkTsI1IjPTunWbTtHSblJz33KdGoeQf0zC2r1oDnoCyUO3fQf6cr8FLlZi6aOIeAyEveJKtl3Tajruhot28O8QWwX2DbWcVQKEWgyXYv7MDkfwnohgaMTSpv/lun3Iab9xQ5F5SJjrEhUp8B0tDrv66K6/eLGjnZXhYBcCA+C+prziKueu0ae51JY9zN2SGY9zgDnICIIFPkaLf9K506WaGO9HbXinwsiDXFMpDuit/tMFgTClpaCnepVwV7Or/DZ4+pX0WTXo/bntj5d/AcxxAUvo24qHTDpW+yrvetfPJEk94SbMp7jODq8Somgnf1ikD+xschEZIX3BO4MEdj1ZBGqU4vUiUwUvRZTnMzfZ8xgzRwrn5s+xPxNNXEF8lt0UnzRZsqVycU6C84F+4o+ThmZHQR1jNhRZyp4OhLk7eb4xLuMm/i7ayAi7nmIjTa4mWso5xqs3PBpyrUpvti12kV6ITaXChqWCDQ35Ua7b8OPeKZdWJLH0TC6Kf9tFO4WJA13Rm+IocwhlHswRqBSXWwIlfs1i5WCNA5nXfCIgl/ubbLb8Dk9+gtJfSJj80G7wi/KMg+YOV2Cz3ijpR9eNlvj6eri9PD4tdkbyqPeFX+vKxtxl5tykzyHjlq757iUyXs4gQ23O6pWCQwwtUK3+IMEyD7CzV4CDUzt5bbrG7Hc+fYyHyC7tTlPzFwSNHpB9O5ujx2TGwVGqXidQXDLy5Wf7pBqQXjEheHbxhsqArVs6l8UQDtPqS0sNdshD8c9Ty195e/QD0v4ODQQjTsVv2ohh7H9Kql85x3NZH4i5MKdKmsd6cZ4Ho4p3gqDDj2igGKAllqlcvmMrKGvs9rv59two+sUxom5PJCl2NnVBTJASVItXJQ5Qfly5ptQd/V
 I6lUXY30
 2zneVGa7OfQCCRJ83z6U5qyVZq8oeTo/mDnHDkDsI56qNrWXPuSDdMM/50+aOJrJCS2S+JTbouJdYgQqYrSq8wQXdUfWqD7cylkwG+OhgajJ8PyPcjZCiXhVCgaR9q3ltvY+eDWbX6zE1ltco7HWOwQBhHomxO2ERbxZhQzsdw0d/zOg47BXIx+Oiqx5c7jYe6kyfBzgXs/5ZycEdeZA71t0h8EWIil9KqAr8Q1sR0E5BjEjb6F+w21fzlE6qlf2h+OE6Ro2XMjoL2pbv7IAamYyD8T3RNAqw32GDQ6z7tRFQTl1mhFzNvnP5qbr9RCa/ng7RTlnbysk9wMUwQRIEFcylfjBJHBTrCDgcFua2TY5D2oZREtKOLvLrglU+10ztaaWIGUnc+gUmW/6C3c9NHf2E0kVsPAf0Ma8x1zR+Kue/LKy6aJuvFGl37m2U/vopcBzo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 14:20, Usama Arif wrote:
> queue_folios_pmd() is called under pmd_trans_huge_lock(), whose
> pmd_is_huge() check returns true for any non-present, non-none PMD
> softleaf. Passing such a PMD to pmd_folio() treats the softleaf encoding
> as a hardware PFN and can return a bogus folio pointer.
> 
> Mirror queue_folios_pte_range(): handle non-present entries before
> looking up a folio. Keep migration entries counted as failures, but skip
> other non-present PMDs such as device-private entries.
> 
> Potential trigger: an HMM-based GPU driver migrates an anonymous THP
> folio to device memory via migrate_vma_pages(), leaving a device-private
> PMD. Userspace then calls mbind(), migrate_pages() or
> set_mempolicy_home_node() on that range.
> 
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Link: https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
> Fixes: 368076f52ebe ("mm/huge_memory: add device-private THP support to PMD operations")
> Cc: <stable@vger.kernel.org>
> Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

