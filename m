Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44047CD342F
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 02:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 650A86B0005; Tue,  5 May 2026 22:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6284D6B0088; Tue,  5 May 2026 22:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565286B008A; Tue,  5 May 2026 22:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 463336B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 22:05:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CB6E31A06C5
	for <linux-mm@kvack.org>; Wed,  6 May 2026 02:05:46 +0000 (UTC)
X-FDA: 84735353892.05.9140AE0
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf26.hostedemail.com (Postfix) with ESMTP id E0603140002
	for <linux-mm@kvack.org>; Wed,  6 May 2026 02:05:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eu/LWEgQ";
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778033145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zooTfGMwgUxut9TmF4UJ+R+H7n0OixPbclu6PSkIssg=;
	b=aPktQY5zXdyTaiviwrc4QLmMQBQHnnSscDSMw4fceWAXJ0q2QlZtgxRRV2H3XaiTIc4VP2
	QobjsfCRWBLy4FlL22Tqy7MtI+2Ds1r+iSIkSubWnVbhpUZuyUzMLqLIGp5G3ji+UC66aJ
	E7a3gmaPgbDHWrFc1Z/4KGooVoZHqec=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eu/LWEgQ";
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778033145; a=rsa-sha256;
	cv=none;
	b=6WaqXU1n7Lmc4EIyQrHW/5KFOdO1MSPXW6vBBb3q4UzSXDZzTdyGR/LO2bGjXbK7/M3xI2
	08O6a/7vAq7esdrkVKayE/FRZrOOViW/E2ZAYevPD0FHrbfE783/e/MmOjLZmBlAyFP3lN
	CMure0F0dNs5OuNinf/IzE4f5vOnAZQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778033142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zooTfGMwgUxut9TmF4UJ+R+H7n0OixPbclu6PSkIssg=;
	b=eu/LWEgQw6ybfH8JF0ngSDLBvaXrPp5zsR17NGm7LzHNtl89Hb8Lcr/0MHYl5ZFwaTB87d
	flzL4HqrESimXgWbHdfqfwpsDwLMyXZRWgX+7ka4N2JESxia03E6sEj6YAxEL4KSt3n/at
	dBJl7dIUW3E+ZJT6EfGdqa1i23sicmQ=
From: Lance Yang <lance.yang@linux.dev>
To: ye.liu@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	xhao@linux.alibaba.com,
	liuye@kylinos.cn,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foudation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: clear MMF_VM_HUGEPAGE on mm_slot_alloc() failure
Date: Wed,  6 May 2026 10:05:26 +0800
Message-Id: <20260506020526.18953-1-lance.yang@linux.dev>
In-Reply-To: <20260506012130.9306-1-ye.liu@linux.dev>
References: <20260506012130.9306-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E0603140002
X-Stat-Signature: jctwpmf1n7jfpcgu7yfxeypwykz3cuoz
X-HE-Tag: 1778033144-651144
X-HE-Meta: U2FsdGVkX19kt+tXojzXK/ehtsBr88VMuqmQe5noj+9pK/iMVahVj08v9Eni+3EF5byVnuUyyuN+cnxQ8qvVuH2v/QFS/TWaDw73iggZu9B1UicEyIpMW+is+GCWa49RrRvWlHCFgCzfjWBej7vnRw4AFoXpFE1hs4eJQGuu8ugtXTUPWpmWuuvdZ/vQGnTpegtqHkRp8GvAP5SJdKf7HJrM1GUwllJkPPcKUGn69KhW+tiGMYqBSKl2R5th6b+eHo73klxkUw/4OkAHqS1+zGqVUodOO7FktGuJrVKl0XuDzx6nfLLzs6yuZZ9cnmjYKj6RQ2PzNjb12hBq+pbSyFzfK2veXCd3wC7uuRrruBFrozCy8AFmnI+y3VYzeRhx+tRZTfl8e57DvfpIrqRwDa6WvgD8is1k+FyncQlJLYvgEU84aHLe805zRrtv48pHQ89vtiV7rALiMbMRP688n3O4J+v9YXeslwWJfMPhxkvRLRTeZM6y7LUSIx6RIlLqymLkEoHK+CZGq0+J+OOIQ0iAQJpjm13iDr67KFEYH+RNU+CrHxH0wprFvUzO9XF46sPdu9vL7p42cPHfTTx/QhoVRQVMuV8uGpXrY89aePROogsW3HHGD8Zcg8/DexEwhDKbSH2+eYxPz7SECxGa+M9Lpoi2UDebZQtCCSeHcbfvM7/giGYqmzKX9yHLUMvKG+toTPl17DozEcfJbDkDOQnLBuwnqq/t0tayg5HG5IHdJ7xyf7x2KheTHFzm4Er3G2loM4YnupoYFhOsC3VUHg2X+FsdV5K2OQFzW7jGCPnttupvnMaKYPSdko1FibbFSTmiD+Jvb3o3CxRxjEsoVDyZeptbNRsgmTDv01Klv0Y1YhwUUyEIVq3cnPDu57e/of0zedy3zYqj+xklxYA7P34HfDs2QA6P2GeZPUODYwFJ8kk5RPHBKmdaGMqbBHxPHZaBYRsI1odjTvfx7DA
 PC6HCRbX
 nbrOlfVp4Bl0cw3HM92587PuNmDx3cinl5yBD3/4B3QIsIe04b4gSHaePCRZ13B97dKKbPx8vuDBU8lyzoRAqqeCmC6nTTYijHLKpXgSFULSZm9juYWcSngM2DuXK4EoUL4Ku34G3zIf0o+tKMzuriJWYZpX8duN93f5m3i5DbXJRY38d/9XqszoUNHK/k8nABWqngGklCfnJ6OvhONjoOzcFmpI2wvPxb8JvGFU66K/BD+5FnCeDiCXl4wYZSvyLDdbB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, May 06, 2026 at 09:21:30AM +0800, Ye Liu wrote:
>From: Ye Liu <liuye@kylinos.cn>
>
>__khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
>corresponding mm_slot.  If mm_slot_alloc() fails, the function
>returns with the flag set but without inserting the mm into the
>khugepaged tracking structures.
>
>This leaves the mm in an inconsistent state: it is marked as
>registered (MMF_VM_HUGEPAGE set), but will never be scanned by
>khugepaged.  Future attempts to register the mm are skipped since
>khugepaged_enter_vma() checks the flag and returns early.
>
>Fix this by clearing MMF_VM_HUGEPAGE when mm_slot_alloc() fails,
>restoring the ability to retry registration later.
>
>Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for struct mm_slot")

Nit: the title does not exactly match the original commit subject.

It should be

Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for "struct mm_slot"")

which includes quotes around "struct mm_slot".

No need to resend; I think Andrew can fix it up when applying :)

>Signed-off-by: Ye Liu <liuye@kylinos.cn>
>---

Thanks, LGTM.
Reviewed-by: Lance Yang <lance.yang@linux.dev>

