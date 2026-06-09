Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC0F8CD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 12:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E03686B008C; Tue,  9 Jun 2026 08:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDAF16B0092; Tue,  9 Jun 2026 08:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D17596B0093; Tue,  9 Jun 2026 08:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C0A146B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:12:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 86E94A0552
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:12:22 +0000 (UTC)
X-FDA: 84860261724.22.F88070C
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf23.hostedemail.com (Postfix) with ESMTP id 68884140008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 12:12:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf23.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781007139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HTZIEvPjjaoA2MuYVhvZwCr9z/DIZJdrQxkxg8vuSEo=;
	b=HphV5fne2yuW/wV0cpi5LE8TQ/harCgxvD2sighUHB2X8q5KZeKiofmTqowfqsG2NasLii
	WxQWXD+YGjczWL1y6N1Igkbl31NLGp0o1Bwsp0SfSrQpef6prfzOH3YFs0QIot1wtqEiLP
	EB0iPVfWZaL0kweTHW60Pba24nRHmrU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf23.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781007139;
	b=dT+53yNp2TPk6U94OJx0/cGW4JqagqRd3iPjPh7X+btdX+vSX/m4qk8UkiNrm7dQGL/mi0
	eNelq/DjsCifgrVeEpZXzDOMtazs6/cA1ppVnJXDrKbzDf4QYc83EV53dr8zn/wGmIL8u0
	vIsBKv5GzbKK227hljtW//fNqbZDqMI=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gZST234gmz4xNtM;
	Tue, 09 Jun 2026 20:12:06 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 659CBxAP077273;
	Tue, 9 Jun 2026 20:11:59 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 9 Jun 2026 20:12:02 +0800 (CST)
X-Zmail-TransId: 2af96a2803129d0-b6578
X-Mailer: Zmail v1.0
Message-ID: <20260609201202615oT6yd_LtIoKkGLksFaCha@zte.com.cn>
In-Reply-To: <20260609114619.144416-3-npache@redhat.com>
References: 20260609114619.144416-1-npache@redhat.com,20260609114619.144416-3-npache@redhat.com
Date: Tue, 9 Jun 2026 20:12:02 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <npache@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <usamaarif642@gmail.com>, <yuzhao@google.com>, <aarcange@redhat.com>,
        <npache@redhat.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
        <chengming.zhou@linux.dev>, <ljs@kernel.org>, <ziy@nvidia.com>,
        <baolin.wang@linux.alibaba.com>, <liam@infradead.org>,
        <ryan.roberts@arm.com>, <dev.jain@arm.com>, <baohua@kernel.org>,
        <lance.yang@linux.dev>, <matthew.brost@intel.com>,
        <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>, <byungchul@sk.com>,
        <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
        <apopple@nvidia.com>
Subject: =?UTF-8?B?UmU6IFtQQVRDSCBtbS11bnN0YWJsZSB2MSAyLzNdIG1tL21pZ3JhdGUuYzogUHJldmVudCBmb2xpbyBzcGxpdHRpbmcgZnJvbSBpbnRlcmFjdGluZyB3aXRoIEtTTQ==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 659CBxAP077273
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 09 Jun 2026 20:12:06 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A280316.000/4gZST234gmz4xNtM
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9g9ai1a8j57faso6eaqdsyipcw6hb3nr
X-Rspamd-Queue-Id: 68884140008
X-HE-Tag: 1781007139-199068
X-HE-Meta: U2FsdGVkX1/p9nsBewDkF5u1iiOSo3v43kWRVylhtXV03fY5Vm3Sx53i/gA6mgiMllHCds+i/Q22eZGA1XKmCMWN8FeSBIOlkWWfWFaV+xfXDIMDiWCl572O5zzF3bZo7RP24823QeI4MoAHBSC0JnYVzRwe+cUchaHNZ9T5RGBUS6xxwBwTu0daNqHhy6rxDuHECjTsfXaQk4lbDp0UUJqV4PsfN0IjFbPKX8XwC5hpM13SZp9sghDRye4qDEhCP7UvAXT/Lh3ZoMPnOLfb50Flu4tBbLHTgYqUSZFhHYQ+yVqrAWzsWt0UGkstkA7CThCTHA+CbEn+OGouXsVooejLAE2aoODP/NCYRVwzvAJjM14m0jcHZRVujVoJUkEsa8BG/xiVjufB/126F06yjN4PT1NgeQ6Iq2uKVxmgDTXPZCWFgCWRe3p25aR+MdawRvKeHyRsy+1HTUBcwogg/9XlHhDiF+PK3Cvgzday1+Y4R7aKI1Tmx9yHixTfFjV/9JljMfOAH+4gkEYL4pihadsL1g4n+rMoIltMRsGq27aLqDB+Ce7+wFjUcVXjHnV4UjwBbHBsOdbIpDowz9ec/mLlEbTEjzp1QTX2hH+N6q67jJAc1PX3cQydUc5eYksaSuFEHLJKMHlIdZhjVn+GAokdZYAN2IkMve3oK/u9RvV2U/H1NvwfCfxQ/3nVQhE596lp//AVAQZO2zh0P9H0V17NCjgP8H8QATuWsvqXra/F/8iHHMqRbGst2/r36O6uzh6VPBbTB3dMU5w9WALfopYIjx+gpmUyyhQ9JvWHMRUB31hg9lPZ686ZQf21YKznKGaPoQtyEAtq19U6c3PvcxQfrV48NsYeEMlk41HLVpn72Mm8BgurasdW5qhQVTRsIB8dW/EuhjBvOgxNA8RE6oOmrB6faOjbeX0xOBEKbtJ2mTj2J9wYXgHK6WTsbaO+pTRe1KuSFpQHnA8j5xf
 KRsE5p/+
 H/GuPWp2pk3cloZQ1vLPEd3QNTF4ule3g0oYc6uNVxZUPDQVVLqqKE8NeBSJMWxTN7qUS1LsKvj03mk4qWi6WZEmkgqCcZ6HfOZsRJTZz4ftmhHNpVdmQOvIMUJ6TOYJHjFvZWnFnMClYzUsikq46UT8xT86Dvxdw8PPeZt/cmmi2KyDC+5zmFkpEWiYDq5zfJrvSLdUMB/Cvvoa5X1i3B2bJ0FinRRoLi0KNHToemo8WqFg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
>when splitting isolated thp"), splitting an anonymous THP remaps all
>zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
>This flag is set unconditionally for every anonymous folio split,
>including splits triggered by KSM.
>
>When KSM is enabled with THP=always, this causes two regressions:
>
>1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
>   split_huge_page(). The split remaps all 512 zero-filled subpages to
>   the shared zeropage at once, freeing the entire 2MB THP when KSM only
>   intended to process a single 4KB page. This bypasses KSM's
>   pages_to_scan rate limiting, causing ~1GB to be freed almost
>   instantly.
>

Why do you see it as regressions?

AFAIU, KSM and THP do often conflict with each other. THP tries hard to collapse
a huge page (which may contain many zero pages). If KSM is enabled and part of
that huge page is mergeable, it can easily be split by KSM, rendering THP's
efforts futile.

Therefore, in our actual production environment, we typically avoid making the
same region both KSM mergeable and THP always.


>2. use_zero_pages=0: The same split side-effect occurs through the
>   stable/unstable tree merge paths. Each pages_to_scan iteration
>   triggers an expensive split_huge_page() that silently frees 2MB,
>   while the scanner wastes cycles on tree searches for zero-filled
>   pages that were already freed as a side-effect.
>
>Fix this by restricting TTU_USE_SHARED_ZEROPAGE being set in the case that
>KSM is running and the VMA has VM_MERGEABLE.

