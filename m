Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E263CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 483516B0092; Thu, 18 Jun 2026 04:27:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D786B00AD; Thu, 18 Jun 2026 04:27:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AFA76B00AE; Thu, 18 Jun 2026 04:27:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00C686B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:27:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6BF9740708
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:27:28 +0000 (UTC)
X-FDA: 84892354176.05.EC4FBD1
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf14.hostedemail.com (Postfix) with ESMTP id 87019100009
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:27:25 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="ytUSAOf/";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781771246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vga0PBlAszo4+/XRJ99g51mi9gAcKzYo/je2wr1YCYU=;
	b=nbYKqsOO0SXUiK53JgWtKkOs7bUegwTUF84Ocvt4u9UI1i2AbTpm08DSBTeHoob/VPgqa4
	t+VFE5DWY5CMBi64ABc2X9ZbJsoJNLSvidNrSAKFl41bmnzOrX7fGFve3wSeyVFpJMZJ/i
	C5e0PP46DSRlZkozGVPz1Ki3gtm9Ejw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="ytUSAOf/";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781771246;
	b=F13KAP5rDalTIVkcN6CPevu0h3pdoOyOeQBQFEx+wwP8q/7t99q+wBsb/sBJP3f6MSJV0G
	LS8ca+VUuBFyuxmolEm1TjwDzVtM+0IZ8HillOojvrVaTrPbcAIIvacQWbgxNjOTrheY6b
	/RIrGQtTjfV9l+JoVZy48wN1jfcFYL8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=vga0PBlAszo4+/XRJ99g51mi9gAcKzYo/je2wr1YCYU=;
	b=ytUSAOf/4YQCq4owGXEipJIBbj27xp+Eb74DDNsdOnuVtu+SD1ulT6nB+XQimRu/30o9vaIab
	KoSNOr9Gt/oBHiCsX191TmpVSuho1e8hc7U7YB3ZJuPAwKthYkZaNY1MbhlF2xUN7GcddwR8iE1
	v7oeSVnc/4GT8o7rFonMcyE=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4ggtsP4jDvznTXL;
	Thu, 18 Jun 2026 16:18:33 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 0262940561;
	Thu, 18 Jun 2026 16:27:21 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 16:27:19 +0800
Message-ID: <1ccfd95e-b7d3-46ea-8958-5d3bb28148d0@huawei.com>
Date: Thu, 18 Jun 2026 16:27:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: mlock: use walk_page_range_vma() in
 mlock_vma_pages_range()
To: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton
	<akpm@linux-foundation.org>
CC: Zi Yan <ziy@nvidia.com>, "Liam R. Howlett" <liam@infradead.org>, Lorenzo
 Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, <linux-mm@kvack.org>
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
 <20260617082622.3397584-4-wangkefeng.wang@huawei.com>
 <2de0f73d-076c-4301-9b78-4025910fe650@kernel.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <2de0f73d-076c-4301-9b78-4025910fe650@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 87019100009
X-Stat-Signature: dwf5b777mpx9p7b8bkktromsq8pdq8bf
X-Rspam-User: 
X-HE-Tag: 1781771245-930342
X-HE-Meta: U2FsdGVkX19lT3o/56c199hTWlA9Wo/qO8tb3lSTIUEB/ngpVv2/ZGm6tPczqQ+Xjgt8xi6qOcIysreFpVDxtNuNALhTos4nFLj9eKB+6mgRNYohGgmqtXVfQLmEdq4kj6JFB7X4jA+i463akLjai2b8+9GOmEQAAs9FUqXJhcgwf/2V681Uc9+TsmJX+hVNSKbwgCN9P+YSjU+EQIWfiVz/InxgvdwAyLGISk8qQQs+SDzW4lT5xoOqRhLysKIQHC+7xux1dzI4rbKmWIMqIE3IK5qrph4ekYGVGlD46qb3pY4ovtKCTUGFc//buRrl0ZC5gPWj/xv3ipiAicYtkInqjwEyVdVxH+qc4iloDBj+2TzlFNRAX0dbqRE1IAF119M2D1lGLblCUje8lyykN0nGT0AgwlvpYeHaUJJv7G8saiZB3DpIrUFwWIO6wbXf1H3AnSRKkmWG/MW3XPN4LKIRJcNDjSwl3VvtTjtO3q+hf7nLfa7z1wX3BgbuxzAjCky95kXdZsTdBrxszuSfpZ65my3aXL9SLedVXzdxYt74BG/zI7OMU8b4UER3Z1+yP7P8l8MXuflPrXksUAJbzmYBGAEB2euoShTTLGA3AtgHwC2oaC0SawBq79moQzHBsvaOgQyR4JgjN5ESuYeC0Hu5isT7VwW3y3h3ybhVlRc0nThn+Gic1kV41z2FPIYZ3/JN1UhUa5DvPPT3SdsvNWxWWfdc+63sDrB0z+Ya8mo2njN1gHWrDtXvox3oln3uaKxrkgNwrz4TjW3tUnpIH40WTGBL6UcOKLb050vGhCh52IhB2ngU7T/2BABxa1AVzcssvQ7lsUULrHDyHkj/IBXHlky27hzANR7CXPIe7LZM0ATdfm7YwwefbiimnCviewlE2fzb+UcMRmODOPIPgCtzWFiuu3fMdZnCChrRD5q4ylaHjEIYqym5YbOuEjg1v0qqvu5wDgi5bmEFYNz
 wtPf1rD9
 rGbFdDzTFu5FGUjmZSUAXReBAyyroA0Sv2Zvi/PVQo33U+QyBu26pR4Fcp4k1F5GNcTaSGxOI6ZzyvZmRUMcwTXOKtM8jOy0TnjfY0qZYPWK7x775JOXfYKu26sqzBUwYvRcOaQO1K+9Aabg4f7ShHTkDvDnWvcAqJv/IsNUV37JV0h6AGtjrPiMXigVQ6gjX95aEHw6W3di2A2toPtvHzXQBl6A9bRZdg9EahBMMGMkVu/EXpOkbCpEyp/OvJ50NsuLezDr9ia/JYs8DfIVRdj+UdGorLnotxeZJ929V/79yETpQcLdMKOCHEaTsaFmtpSf1UaN0/2QOO1hrh3h6kgCC1vAY8rU95T/gwzYob91a3Mk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/18/2026 4:16 PM, David Hildenbrand (Arm) wrote:
> On 6/17/26 10:26, Kefeng Wang wrote:
>> The mlock_vma_pages_range() uses walk_page_range() to walk the
>> page table. Fortunately, the caller always passes start/end that
>> falls within a single VMA, apply_vma_lock_flags() iterates per-VMA,
>> and apply_mlockall_flags() passes the whole VMA.
>>
>> Since there is no .test_walk in mlock_walk_ops and VM_PFNMAP has
>> been filtered by vma_supports_mlock(), it's safely replace
>> walk_page_range() with walk_page_range_vma() to eliminates an
>> unnecessary find_vma() lookup.
> 
> Re-reading that after #4:
> 
> s/eliminates/eliminate
> 
> s/safely/safe to/
> 

will fix all

Thanks.

