Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66A49606A325
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=b7JtXIvv
Received: by kanga.kvack.org (Postfix)
	id 712406B05B1; Thu, 19 Nov 2026 01:40:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66EE16B05B2; Thu, 19 Nov 2026 01:40:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 537036B05B3; Thu, 19 Nov 2026 01:40:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 264856B05B1
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:40:58 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79F3314093C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:40:57 +0000 (UTC)
X-FDA: 85450920954.29.86CFFA1
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf21.hostedemail.com (Postfix) with ESMTP id 03F431C0002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:40:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=b7JtXIvv;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795070455;
	b=Q3dYRRApgdOLhUCTpMennU/rHwSqHhGcI4bdzZxvRZkynkHwVizOAgsjpgnW5R11t5Nsp0
	majg1t6LqdxGZ/70a0tAJg6SSYfxGmAIe4EruEQGnuRIUaaATgz8llH7v77TemjrxrUzz4
	DUvFcK7jrzawNSas4iYh7yaaRU1IhNo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795070455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WIcv/gkn9Du3gkmEGWgbXZJ6Zc+8Qnh9DQ97QQlxpCI=;
	b=kdPtnCXBBLyJrGsEr9+MTDopQuu0xvK56DZ/y3jo0BRXhMADFuVYURJxqK7e8vjswnMhHW
	oYWPWBcbW/IA9uVo37PAcuGwsTEvuTi3zbOUvnOjspqrPosdnKakHgD8VduGfdcYdiicPe
	G2tLCYeZqIleZlL1R5GjzSB1K6z9Jh0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=b7JtXIvv;
	spf=pass (imf21.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=WIcv/gkn9Du3gkmEGWgbXZJ6Zc+8Qnh9DQ97QQlxpCI=;
	b=b7JtXIvvCTMxQdeFXTNABaFx7yHdXSqUYFdskf/Hg5CCQOUHbV+qL85qk10C223Mk7tvHQr4t
	C7Re8hRislQX811JpLYz5IXbdD9isKe7J2CPqT+XPHLnNZUhx47IDHEdWv1J4JusWaGdGWVismX
	AuhHyWm+0TNlcGwFNi3xd2I=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4jVTNb424xznTbF;
	Thu, 19 Nov 2026 14:39:59 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 271164055B;
	Thu, 19 Nov 2026 14:40:52 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 14:40:50 +0800
Subject: Re: [PATCH v2 2/2] mm/hugetlb: clear the hugetlb flag before leaking
 a hwpoisoned folio
To: <mt4022@columbia.edu>
CC: Naoya Horiguchi <nao.horiguchi@gmail.com>, Matthew Wilcox
	<willy@infradead.org>, Jane Chu <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Kaitao Cheng <kaitao.cheng@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Yu Zhao
	<yuzhao@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<tz2294@columbia.edu>, <stable@vger.kernel.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <20261103-hugetlb-hwpoison-leak-v2-0-98085750c145@columbia.edu>
 <20261103-hugetlb-hwpoison-leak-v2-2-98085750c145@columbia.edu>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <7fe14c15-0a99-d634-bf9c-bbf69c9ce5fd@huawei.com>
Date: Thu, 19 Nov 2026 14:40:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261103-hugetlb-hwpoison-leak-v2-2-98085750c145@columbia.edu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 03F431C0002
X-Rspam-User:
X-Stat-Signature: igui4iqs94umiuwxapht1qn53mw1wbr6
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795070454-799764
X-HE-Meta: U2FsdGVkX18t7evIuPdDyTJrgEq6UnBR0sEiT2PZwVTlICBZb++s/gjGagnEKm3zOmPd2NTLAJuVi5TQEc/gVgnoLGeB7bKg1beMERq3TVqcxzFidpQMBsgY9z011dozdOZacESabjK20zyyJ2veOCn3ba8ris/XMzglvLCCPbW8zR9a3oZncvqYMwn9TMgb4zc0BL1Zhl0CpFLz0Urw6lNKFRSBdffbJbmS09uR1nWnbgcxC0o4kVD8KlrNPlxNSeYTdlB4Kc6JZPdjODbolqOohYOE+mf9TxVVnH2saCe/XsQETcjumfRLPXJgDALAmKgbnBfPb6xC3cjSf8scOAIrq/CufpygyOseC7aUYMv+cXgs3EW3C3yCTGbUpHEtOnTK61m0J1shTk2lp3152EsDnnZouNuUn7mq026Xx2Vru47BbPHh0s4fvYMexVi7YQHdI83DmU4EOwEqQ8eQOh4NQouLJzfqNUy0Ld33w6eEEX+K1qRju1Xyf7wYzVl4Hdr3e3lRv7YdeYj8ztUxyqYMQPNkj9sP30sNUWPM1/XPi0caId26/8fcEZdmO9PpGl/GcIjjjTECwl4Gzx8MYTb+106k/LIZAthaupS4MRc07pMBvbxVaSCsa98UwIo/ZTZATFl34HYBEczIf+4JI8TvFN0yT/wMypQqTMYbC5JBv1pQPYkcDyjM9XN7jAXcI7QKA6byWJUSWP12OLs4vXGpEnCSeKvh/OuoKTuMAa3av0pQfw3wQhzMCOUQ4XUKQVwLW0bixuGuG7YyYHngWRKXSdCHzZOh6qFgFuPR2bxDXE9c8rVtHMt1lfO2Unr9nc7Hrp+5eC31Pvlgw6Qmnh7PQS/8gKbLXQ0vGrdus0DD4MJOUozg0x19tLI4nTApbuzLS5++bks1xfbrDRD8LQDYz3aF4ha95IupLUzBgPlv3aOk9GanrymsJj4o/kgtz9heWtTGsyXvmBxi+3R
 iGhiXHt5
 adUA1KH02i4Ol1C9OyLw4i1YQIwc4EV2UArLoPagg/SNWnPxTu3vCfII3vzpekWxXBiUXeMI3Yumr8o8J4YuPLZkwBZhkoQm90X0r0Cs+TrEA5EeOgPd6AUYgFyZw3Z/gIBxgIgQ2dcMliWgUdLfwiRdxXjLcVaLOBMZ2RwxGM+kdgk+1xytA4jQw6cXrEyrs6oh0Vtgr1Cc11y2HUO7rT/vSJPrQ5wYxWb2/TtYDpLmaVB8OqI9CYaLdkKwy0SA3fVLtwOLyUj4dmEUgwnzoK663WuPv1ECx+Su23k+7Pk+kUoQxWcOTS3XR65/BpB4B+5MZLSlgkDhajG9QaS6qM3EIBchevmvXrBQ4Zjy8ymlU3mDpbPI4pwHeS04LOG733SKMEmGQpkrxnkQl5CP15Bl5xTDWMHm8XHL0568CB9qns2G+zgXJFP+EJfv21z+8GjwgnRUthSnevTRfvmwYspvElmBSkOomdo4WJWobWD63K6TZBf0H9fkoCVaQkd3xR80C635LUe7/Bx8m1DRVh6JHgo2bvpWHC2eH+est6Q79npw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/4 5:00, Mani Tofigh via B4 Relay wrote:
> From: Mani Tofigh <mt4022@columbia.edu>
> 
> If hugetlb_update_hwpoison() fails to allocate a raw_hwp_page, the folio
> is marked raw_hwp_unreliable and __update_and_free_hugetlb_folio() leaks
> it intentionally.  With hugetlb_free_vmemmap=on, it's leaked before the
> hugetlb flag is cleared, since commit 32c877191e02 ("hugetlb: do not
> clear hugetlb dtor until allocating vmemmap") doesn't remove the flag
> until the vmemmap is restored.  The leaked folio is then a hugetlb folio
> with refcount 0 and on no list (the same state as a hugetlb folio that
> is being freed), but nothing is freeing it, and
> dissolve_free_hugetlb_folio() keeps retrying on it.  Offlining its
> memory block then never completes, even on SIGKILL, and other tasks
> block on the memory hotplug lock:
> 
>   [    3.271255] Memory failure: 0x20007: recovery action for free huge page: Failed
>   [   41.729695] INFO: task hugeoffline:77 blocked for more than 20 seconds.
>   ...
>   [   41.733014]  get_online_mems+0xc1/0xd0
>   [   41.733026]  soft_offline_page+0xfd/0x9b0
> 
> alloc_and_dissolve_hugetlb_folio() loops on it the same way.  The
> refcount is 0 since commit bd225530a4c7 ("mm/hugetlb_vmemmap: fix race
> with speculative PFN walkers").  Before that these paths failed with
> -EBUSY.
> 
> Check raw_hwp_unreliable after the hugetlb flag is cleared so that the
> folio is leaked as a non-hugetlb folio, as without vmemmap
> optimization.  unpoison_memory() keeps refusing to unpoison it.  With
> the fix, offlining retries as it does for any page it can't isolate,
> and stops on a signal.
> 
> Fixes: 32c877191e02 ("hugetlb: do not clear hugetlb dtor until allocating vmemmap")
> Fixes: bd225530a4c7 ("mm/hugetlb_vmemmap: fix race with speculative PFN walkers")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.


