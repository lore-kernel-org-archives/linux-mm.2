Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6EE3CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C6516B0092; Tue,  9 Jun 2026 09:48:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 377846B0093; Tue,  9 Jun 2026 09:48:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28CD16B0095; Tue,  9 Jun 2026 09:48:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B26C6B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:48:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DCBFC1F1B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:48:10 +0000 (UTC)
X-FDA: 84860503140.17.AD610B1
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf25.hostedemail.com (Postfix) with ESMTP id F22EFA001C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:48:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781012887;
	b=hutLzXULAXcGX7q1oXZeDNrywpO2Ldz8sRow7CxQfwhiKhCdp5rX2w4L8fK4B+xbmwTHTR
	GsfaX7Vbch67OUHv98tSzHcEbhHPjJ9iPwlNgeePbgl7c+j5HZUHHAUD+S+lb0X1plF54w
	KPteD6TPR+EAue9kelkr/Y6RHAOdQwA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781012887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2CIWA5JUgOv3+6N62UvKsReWBK7CPL/YURfQ/j3E4T4=;
	b=N9i889MFd8RW1yK+N4MO0E9zS4iyucwAyjgAKerCpQtTngt5fgWVGdmh2PEr7Oh/TmaCah
	w26CrLc57yxDPh6u+5CNoV1sHwt534JRKX1H35eB70vCp8wxNh1jaEInEH39RZX6LpxgR2
	arjeadCi1Tdx5O9CmZVMTfOc3ymBIOI=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gZVbd46THz58fcB;
	Tue, 09 Jun 2026 21:47:57 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 659Dlt7b041799;
	Tue, 9 Jun 2026 21:47:55 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 9 Jun 2026 21:47:58 +0800 (CST)
X-Zmail-TransId: 2afa6a28198e605-22142
X-Mailer: Zmail v1.0
Message-ID: <202606092147587040QWUtifMcXLhNfANT7GRO@zte.com.cn>
In-Reply-To: <CAA1CXcDv8uXN_yZgCqbGUJ4LG-kxFMv1P0yz5exMMAyfUS6N_w@mail.gmail.com>
References: 20260609114619.144416-3-npache@redhat.com,20260609201202615oT6yd_LtIoKkGLksFaCha@zte.com.cn,CAA1CXcDv8uXN_yZgCqbGUJ4LG-kxFMv1P0yz5exMMAyfUS6N_w@mail.gmail.com
Date: Tue, 9 Jun 2026 21:47:58 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <npache@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <usamaarif642@gmail.com>, <yuzhao@google.com>, <aarcange@redhat.com>,
        <akpm@linux-foundation.org>, <david@kernel.org>,
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
X-MAIL:mse-fl1.zte.com.cn 659Dlt7b041799
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 09 Jun 2026 21:47:57 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A28198D.000/4gZVbd46THz58fcB
X-Rspamd-Queue-Id: F22EFA001C
X-Stat-Signature: u83g3zi1sjrwpfgnkpsf47j9bahjd9cw
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781012885-396084
X-HE-Meta: U2FsdGVkX19S8441etp811HiNUyNPEL4pXcre/ZMpyZV6fyfT7NrDzLpOIm1fSCljj2vnun5Rt0Cj0tHI9XPAPA4MPF1Mu5Cn5olc2lpy1bTp/h3qdXVmSNn2CMdkJXFa5HhxZxSga8E7vtPPjgKEKLdOTDc0fB/S0/aZCn0xhPPbALDX1glUNCZbzZhoILKgK4Xv3Ix0O/0Bq2f3ckgkcYk3azPXDZmACqyv/Sk1Eoue67aZa56kATzmV588GCA8+OcnKRTnWiM/xVZRDwTr9ugZyGR6/8vrVxiEcH33EXkWfnccMu5NIgni80bPpQ4C08pbmPYQon8bl3vANXZKtflD2yYWolGi3HQJNzh3RNJ+uqnK4/S252WAcLfk/bWIh8Y/SchKGXTaWKqTcKM0DYxzLiMagJ5LAPhg47vLSVGN2jJ/sMC38Dl318VOjEyyVqjHJ/fxi+HV9hTxfuMzv1V6W5G5CJUHTJSUhe72Ebt4oDwX9+y9X66nTdfSh/KY/k8hI5DlD9KN6PCqOlvQQeIOB7HKc86mHfDNXfvoVQfcLJSuHGXOtI5PEuSxyk7dhDav831w4g0G//QGonE15ZJWNph2ZIm3Sn5eZ/0QOLSZJJ7G8IwSPSyziB+3b0cRPXM1oefCcfUjyvoTyMWoqiaa+nPgDbVa9P4kfTOfNll70l9AG/5fFeQpnOKIkEvFKTktJzpWh1rEUQgzdd3qw9EdqDz69bJ8aiG4x90GFStWs58y/3iVd8OrHyhjjieeCVny2qjfnBZ4JXmOJNZ/BZb2wIrNtR4kiaSxYBNUEDTdIujsjfuEH2VDZLIPo1U5lKI6R9XEV0ZfZumY1J4WxrnAd1QsX3XdrhVZpiMGtW2rSwR7239ADcTFxcbClJXKjfjP9NkBQ5DA3YGv6Wz9oRnIGMeQq41tPeutz0UZUpa0Mglv+qG2VFbbsP8cikgG64SUHX+owBc150xuzp
 PwiQratu
 /7wpRXMmRRtvJidlb2tjH9QSicD9v0F+d4uZHIT0ihAXrWgHiAtaht1fsEJFg8E+uwvvwRg9bF34qdlLYWVMWOfbSLCz+yNjr7qQNoe87eMwXs2U+mSKx2L7GvH7CKf2ZjXovjoOXUEOYUOAFQvpVcruY7bRfnrWFr5AGCf+mc5N6e4k1Q4F/ajZ8Rij+MUiZ4I1ThxdpWpdopzRwmgwLjsxXuKVQjUIqBlvOeurbtdBj/MfDRMOaC9xLD8ogcZg2cJcUtiyZcNYOUf8ARCzL5k+yglTm0sz3tcfpqpEsDOWBEwq4O/+fXzoSQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > >Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
> > >when splitting isolated thp"), splitting an anonymous THP remaps all
> > >zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
> > >This flag is set unconditionally for every anonymous folio split,
> > >including splits triggered by KSM.
> > >
> > >When KSM is enabled with THP=always, this causes two regressions:
> > >
> > >1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
> > >   split_huge_page(). The split remaps all 512 zero-filled subpages to
> > >   the shared zeropage at once, freeing the entire 2MB THP when KSM only
> > >   intended to process a single 4KB page. This bypasses KSM's
> > >   pages_to_scan rate limiting, causing ~1GB to be freed almost
> > >   instantly.
> > >
> >
> > Why do you see it as regressions?
> 
> Since the zero-page remapping was introduced our test has shown the
> following behavior changes:
> 
> With use_zero_pages=0, the merge rate drops from 60MB/s to ~6 MB/s
> even after raising pages_to_scan. The KSM merging is now much slower
> and CPU utilization has increased.
> 
> With use_zero_pages=1, ~1 GB is freed almost instantly, and it no
> longer respects the pages_to_scan behavior.
> 
> Even with just this patch (1 & 2) or the RFC linked in the cover
> letter, the issue no longer occurs.

Understood. You're saying that the additional processing action in split_huge_page
(remap unused subpages to shared zeropage) increases the scanning cost of ksmd.

However, I still wouldn't simply classify this as a performance regression,
because commit b1f202060afe increases memory savings through this action — so
it saves memory at the cost of additional CPU overhead.

If you want to address the increased overhead on ksmd, I think we could add a
check for the shared zeropage in cmp_and_merge_page, and skip merging when a
shared zeropage is detected.

>>
>> AFAIU, KSM and THP do often conflict with each other. THP tries hard to collapse
>> a huge page (which may contain many zero pages). If KSM is enabled and part of
>> that huge page is mergeable, it can easily be split by KSM, rendering THP's
>> efforts futile.
>>
>> Therefore, in our actual production environment, we typically avoid making the
>> same region both KSM mergeable and THP always.
>
>THP=always is a global setting used in many production environments,
>so these features now interact very poorly together.
>

Actually, I have long thought about submitting a patch: add a new interface
'skip_huge_page' under KSM's sysfs, allowing users to choose not to split huge pages.

