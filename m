Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8226ECD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6C556B0092; Thu, 11 Jun 2026 07:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A43D06B0093; Thu, 11 Jun 2026 07:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A356B0095; Thu, 11 Jun 2026 07:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8476E6B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:16:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B3301A05B2
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:16:13 +0000 (UTC)
X-FDA: 84867377826.07.806A1BA
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 349E340004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:16:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xYXa4vxz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781176571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSIrasaGW1+vT6euBKp5FQeyC5hX4yIQf5dAsfWbK80=;
	b=D4Y7IFGzSxpcvzOJQPMkHv2bAXDRnNuYBPHNeqhh+12Iqaot8LkPm7crydKh+JLl34BHuS
	/6auzoA/6pwtCB6jCe6gXZ3grBXJb5iF7etdHEU4c2p6Flk8HkLCS8ETVIOLoHKAsux5kC
	LM3MfpZ1fttiO69C7JqQCAuBKVNUb2M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xYXa4vxz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781176571;
	b=HJA/qagrKUegC1mKr+qD7O9iZZ2ColL3Xkyf30VslipWGDB3RT8H8D0hSUcHOx0QzkyXp8
	yPa98JHvpX3jpKiZSjBh0D5+Zu/ZHs7mBwLHr+s3XlMA0om1QCxlMCGbL6sjFjurQFQaJ1
	gw5Vs4I8ZE8Sfsjs6oMWmwCdpCiEUQo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781176569;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YSIrasaGW1+vT6euBKp5FQeyC5hX4yIQf5dAsfWbK80=;
	b=xYXa4vxzQ3jzcKzp/ooX2aiaMgQNEJsFu27QWjCBmAiytg7ZBu+X5zb+55GxGTehUVF7kc
	1EvEw4yZ0V7lkzAbeFcc5gpe6MZ0L9dPjMmWwwPMyZXJ62VljCZf+UWnNyOtU2vSl5bOvV
	ekuOGVb+q+mdKgWUFsyY/I+0Pex/9/Q=
From: Lance Yang <lance.yang@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	Jason@zx2c4.com,
	anthony.yznaga@oracle.com,
	broonie@kernel.org,
	sarthak.sharma@arm.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Aishwarya.TCV@arm.com,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
Date: Thu, 11 Jun 2026 19:15:38 +0800
Message-Id: <20260611111538.9883-1-lance.yang@linux.dev>
In-Reply-To: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
References: <20260611-droppable_test-v1-1-b6a73d99f658@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 349E340004
X-Rspam-User: 
X-Stat-Signature: e55ggjrwgqkywpzdjs4b9zekw6ncr95q
X-Rspamd-Server: rspam09
X-HE-Tag: 1781176571-233034
X-HE-Meta: U2FsdGVkX1/SghdpHTYgy5l4w/XDYGlWYP7vt5a9yxuiGjohY1GLQEDNbXqvG3nEi8h3RAgkxVO8rNAGlbDYmDncTjUSMKPob1FlyTp8PKKxEk/dodjPXUeD0r4uGoscIm14NCbAj9x9MK25a89SnGogAqbJBDyV0dGUy3+huvMcmervNpvfEAqtp7T+VGVMf1rLSejXWeFmoUtjS5RJqm+guhN+Wst3/Z9GUX709v2/UTHoo31gl961mX7xwMiDl40qhUm9IKFX8IVekwCnffuyUji0NLb/XRSZ89wcVJIn7kydNZ/IWpAnBpiYF9TLsCPS/TAE0dSje6Bep4eYLHMOJ78aW4PlgHJP2pBOfnFfxybEsUhcRCDGYGDNg0Eou1C2SZfLq9Ru8I3MwbQtAeG1gbwkY/o1+zmAr4ykY85kLMKTUiC28iw3HFgOUeiaWNNp+7PK/ofKg8QVrlcRwULzBquDiONN0KgLccagbp3vpw3oWVDWq6R7HbsprsCDAR6sKNU/3fPeqm8rpOoiKOGppg35+TRRN78RewgeNAa3ietkAfJryeqWEaUcg56EMcsTRt2qp/aJ4AB+MH6QyL10mo+SUDf40pwPkplhKDTKgHUaxbTdOFwPMoY5IBDKOxu0cPSxbg4f9DjSJpsr28PR/CQs9RmQ3O4a7iwHqsPf0PDHRrph2VEDQwEnZ8m22VUEL0fmVOhqwsj0msatNaqjKYmw38TbrWaJy4hmkPkQKbdXFizoow3MLB6mL8/N3wmkA+9nEI6eVaMsfigcwF+e85O3801FSJJxMA9xcTQ8N9Oq/SYKtGVI9OgUcsPmq5wE39sWkgrf/p1wfcO8KMqcMgFan1FbcXJG1rNp9lHvU5k4Nz7VkCZs29OkTV6Hg5l4jAyPJ0rF3b3ilKfvcCcU4mmTkt6/t34qtWIlFLYVtyvY2thmYM939XTSMO2OdjIpBRNrWbMxV9DnCSy
 TkdWZJyJ
 E/kl6dRKExiA0OeTyfAFvXjG6sCiaIGf5AMOaAcsUtonVpvWqWvLO52jDSGQ3WiTfyAqSChUV1qbsL42LK+jzhcutNfLcDeZsQ1Wa1M4C33rsRR+QeYajopCcJordX0ef5TUMa2yYTCVvMQoODK48oOyAHdVEGZBUm8A/9rQ7mZKLH9sbkmb/+9hDrZutncNk2nxI52Mt4d1xhYmxOk4/eRqkl8Lowp1dYTbz7FkxXz/junBGc0Pv0ox8k0Hk5FpxKaNdmrO15sMlLMqwLrt7dmYqvqxC7p7Ii5c/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Jun 11, 2026 at 12:01:55PM +0200, David Hildenbrand (Arm) wrote:
>The droppable test currently relies on creating memory pressure in a
>child process to trigger dropping the droppable pages.
>
>That not only takes a long time on some machines (allocating and filling
>all that memory), on large machines this will not work as we hardcode the
>area size to 134217728 bytes.
>
>... further, we rely on timeouts to detect that memory was not dropped,
>which is really suboptimal.
>
>Instead, let's just use MADV_PAGEOUT on a 2 MiB region. MADV_PAGEOUT works
>with droppable memory even without swap.
>
>There is the low chance of MADV_PAGEOUT failing to drop a page because
>of speculative references. We'll wait 1s and retry 10 times to
>rule that unlikely case out as best as we can.
>
>On a machine without swap:
>
>	$ ./droppable
>	TAP version 13
>	1..1
>	ok 1 madvise(MADV_PAGEOUT) behavior
>	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>
>Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
>Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---

Cool! Tested with swap both off and on, and it passed either way :D

That's what I'd expect, VM_DROPPABLE folios stay anon + non-swapbacked,
so reclaim can discard them instead of swapping them out :)

Tested-by: Lance Yang <lance.yang@linux.dev>

