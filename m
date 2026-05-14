Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09911CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C63E6B0088; Wed, 13 May 2026 22:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676876B008A; Wed, 13 May 2026 22:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565306B008C; Wed, 13 May 2026 22:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45C046B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:19:05 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA95F1C0461
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:19:04 +0000 (UTC)
X-FDA: 84764417808.11.7849012
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id A092EA0002
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:19:02 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S9zSbRV/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778725142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NTcHCLMwDFGHou/kFY3HOs8s4576E62WE4EOADoCAms=;
	b=xleAdjWlMG9OrTxBC6cJOEA4Aj2QT7VlT3iQt8TPMGTHrSck4acn419tBHqcPSGM1pNyoZ
	tuxdkCGqApotCYUx1IwP53VPhE6bmULgZvNu38ZOTyvuzNE/g+TNVWqc5fl9wVuQIK1rFg
	4TLkeC0/zthk9dpB5PVOvlT1HYBHNwg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778725142; a=rsa-sha256;
	cv=none;
	b=8h/SQtshYO1qsBosthSUYqrcKxOTi6Bvjzq4KvZu0jaMTP9jtL/yWKgKh3Im5+HKLJvZMH
	JODiggOkHn32HMhnh46dBDXfxLDKRHu+P/2XvL9wihokV44A8PhkzDM3HUUPcR+Ll+opNj
	xwnxIMs0RhPM5uJS3MtW4//2BmqO94Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="S9zSbRV/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf25.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778725142;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NTcHCLMwDFGHou/kFY3HOs8s4576E62WE4EOADoCAms=;
	b=S9zSbRV/7Hx0S6G+MngLYp9pVE3oBVOYtpBUO8LqU3lX9FJB3nAzaGhzYVNIANwEZF6qJK
	5s/XFn47hzeOxtfqx+EgRag1CAsJu7cxCFn8hwrERLxajcyaYW5Jd6AMfYRekc7f2d0HIL
	0+n/7ayTuNegSq2TPNHp7MbjqYYqEXQ=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-110-Eep_0c1iMGq2zEvtbF9qWA-1; Wed, 13 May 2026 22:19:00 -0400
X-MC-Unique: Eep_0c1iMGq2zEvtbF9qWA-1
X-Mimecast-MFC-AGG-ID: Eep_0c1iMGq2zEvtbF9qWA_1778725140
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-90d02857cdfso746877085a.2
        for <linux-mm@kvack.org>; Wed, 13 May 2026 19:19:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778725140; x=1779329940;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NTcHCLMwDFGHou/kFY3HOs8s4576E62WE4EOADoCAms=;
        b=GrZtsl+PSzkDBLTVkFmg4tUyzqe5vvTs/S4Ys5bkirTypHeqIVY+0yGTMyF87emGOr
         vcP98qsQGxriXhn28KWnDSAWlO2DKzPy431nhMIfwTRcODqmCAkr1CCmC9KLB0KuLRy4
         bNa4gzn6/S9eL9xWX8M6WHiDyqkN21S/1HflMKwNDOVx4J9sBvVnG/xfh8O+VeY4+RCl
         SS6++PRY6LNhaGQgaRSVW8K5vhhuMfDDOTaXWRmci4BlFccesJa1UOeYaOtygOsjSc9n
         TedU4BCSmFXAxRD+Ts/yJhqhfibWF4EYo2Ql5lYqYOHVuF09I39hImP22Ij6eZ7IPs59
         I0XQ==
X-Forwarded-Encrypted: i=1; AFNElJ8wK9iyZy7OQ3MFUggs0ks7fl9Qk9gkdD2YERrjq6tU6Ef7zoL/Sh1bG1hPdyBZ4407GCXJIsenig==@kvack.org
X-Gm-Message-State: AOJu0YzlqUmyx+ueMHwwyikQHkhPDYFpA6XQQNY43FqfK+Q7bTUtvcub
	3mkfcBBfPL2V1bw1y7ndzihg6MU57B0LPxYskn5D9v3PU2r3cL3Legy1ClfwTq2OK0m1pGcAnR8
	AHjcF7N066UreLsM/dVot7VNLMx4YqO4IzTj9VuZq0XuhLuO5dj4G
X-Gm-Gg: Acq92OFohPRblIP+6JWy9xY1vpLmQXPfl8mZNfIncOSToZ33mrAXHUk7sbHIKA8xHkP
	gzcxntjM2XgURSHK6DmLp9GQLUucX/FyvuwnXRg+IQvPvMXRb+xPiQ32ruXDHcJzcn6eF/ysQRB
	ZQhk18mMzt11m1CY2ldDnYMAyLwpO0hkNzL4TKPAUhNz2ZPgJPWDz2ozqa3Z/OboV+gIVvX4Q+f
	cR92oGhIxUESpr0dymIbyRNyIpD8uVGiOc5n4wMwv2pjRiUKon5Vo6+YnvFG2At331/cDGywYPp
	ic9n0LbSn3zwE6iHfVwvZJXw6az6XD1yvqK+FMFCeek/MgKxFLOewlv3lo6pJLzMJ3jVLShcopP
	wC5B3hbTIZVj/RqvhQ1twO9y/
X-Received: by 2002:a05:620a:1708:b0:910:4023:4fc5 with SMTP id af79cd13be357-910402352f4mr609026085a.13.1778725140292;
        Wed, 13 May 2026 19:19:00 -0700 (PDT)
X-Received: by 2002:a05:620a:1708:b0:910:4023:4fc5 with SMTP id af79cd13be357-910402352f4mr609022885a.13.1778725139748;
        Wed, 13 May 2026 19:18:59 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf35843sm118154085a.38.2026.05.13.19.18.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 19:18:59 -0700 (PDT)
Message-ID: <1f4bccaf-6472-4e4c-92d0-28ac05f6f838@redhat.com>
Date: Wed, 13 May 2026 22:18:48 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/9] mm: introduce pgtable_has_pmd_leaves()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <2a0bae00cdd2b6ef6b962610b523ebfc97806ba7.1777663129.git.luizcap@redhat.com>
 <07f1039c-cf9b-4b97-a044-9d5771ea54fb@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <07f1039c-cf9b-4b97-a044-9d5771ea54fb@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: LX_46Yag6xfg633IJB2Eu9GQSQlRss9MGCssycd-IIc_1778725140
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A092EA0002
X-Rspamd-Server: rspam04
X-Stat-Signature: dwqrhzty3wsksfmzkmf6ogbs31nmpo7a
X-HE-Tag: 1778725142-37563
X-HE-Meta: U2FsdGVkX18XNQPWPgPfnVoyNcEWWX4fYXAxlyIvU+vsV5RqkxZb6z1kdvIEjXpP9WDKEN71Z0OpkWGzxk+W41SUa5pDhd1gtfqN13kS+BfXgXMbWzaK1uELwrzfFVJVVw7VMwsSrNMobzuocj28RWBtsQi4K0S1UAmDJZJfKMIkCMcrioaXYOI/JObLSW4YRExHGsGwjOKCTQPvAj6BjjV5ckFR0fOsgCRDuYEZHwEuGQLaTXa1wXXugV/XSek3hNfRY0Baai4SkVLAdBna7989Ck7IpNtxbRWNZNujH8ZTaU0FTh8szxqWvsMYjblsIc4aysDA3yzCnOjBN2cT0f/L52u9RBtGTXI3xuJoWBcFUUShanicNaI279svcuvcovjrAwDYp2/jn+SS9EPwU/9rdyBT2gc/eDBeeZjxb7BFd+RcxwVG2p3muMBx/CdYWCchw7bK3gZNOzu7woRVdI7iIX8SK0LF6tCeydnoafsXCLx8SYcTVOqLNBdpg69Pj3H+gn2vgRxZFEpaO/6/j5qGHYeyx6qhGYznLT36Tu7To6wS7Tdj1t8ubOWXZdXeeLiZfPdlf9FIODVvhEBZKJeao+/hHyyCg9/svz6ctWdZx9PvRYUM3YTFclkkYKmtI6q1PFLdLWiXZ6txS+bQu8+7XRm4xjrQ6Zz6CC+2aUR/gkCd6j3uSwmCp8kJq40fkrgUx5LQKLmwqbaHkYuPB+l0X3h7D3DUfkaTVghRz+xlXBtwS0LZQbXAJxx3W7WGMjFK4y3IuyqSZ23+IiMAWTcbRDhQ0D+vFUBHGF1dDqX91ZS7AZR6h9DA4weNIa+jRD2h1b/It9zxxhQ12i4r4OUQIeYtTEPDz+Uc9/MbyTlw6l4gRvfKfofA1k45P4YvUJbJ6uDoAh6OqBlCC8AYql+3ng7704MSjBHD4DeLN9CWbN3SBXjSkyeWjV8tmVrx9eFrwbwixsfHhm7dkZn
 YqWXeNaY
 Byhnk5cXcXHbDc2beNsZAQqWqa2ZLWD7m3QMBjm9SW+AYH99BCjBHSYCUM93IdIzb/hKnPXjSsBWw6M8PQqHLIZtzEQOgTZz30p18yrOlQH2CwdsPVnQ+tbbLU9/P6rakiYkYbO8t7U+2rG5V9tjGnMai2psrvd3t3LtYCN6N949Wu3oN6nVu4jTVJgdDdDzAAXZTyJGp2E4aARwtu166M/cF0bzbSe+GZy8CRifQD7/jRLWfxYGWyg0ksg5tp+mYqfUrdtmhPcRBP1O8ESTKn70xgtlcfzSuqtlcrwiRSRGVKNoIC99SSJQ5+fH/MaThusUzCvzYp7JY8WXtm6rSZMxiUsl9p45mf2S0LN5yI7vO2Oav2sQvR0VFSyIhwHY5rjn4M8fatWaVCHHqAqQRkbNvPRMrgHaBQW67TtbCfqkc1em8MPhyfoGLlYDlBRkNm9mz/RcToszksX6r4EIdXathZvAjDiaYDcdasahn/h/gcEmFa4zKrVkZYtCI/oWX1VY4yW8EeOEg6AQ/bVvxTFreCXyNu9cBIRZu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-13 11:36, David Hildenbrand (Arm) wrote:
> On 5/1/26 21:18, Luiz Capitulino wrote:
>> Currently, we have two helpers that check for PMD-sized pages but have
>> different names and slightly different semantics:
>>
>> - has_transparent_hugepage(): the name suggests it checks if THP is
>>    enabled, but when CONFIG_TRANSPARENT_HUGEPAGE=y and the architecture
>>    implements this helper, it actually checks if the CPU supports
>>    PMD-sized pages
>>
>> - thp_disabled_by_hw(): the name suggests it checks if THP is disabled
>>    by the hardware, but it just returns a cached value acquired with
>>    has_transparent_hugepage(). This helper is used in fast paths
>>
>> This commit introduces a new helper called pgtable_has_pmd_leaves()
>> which is intended to replace both has_transparent_hugepage() and
>> thp_disabled_by_hw(). pgtable_has_pmd_leaves() has very clear semantics:
>> it returns true if the CPU supports PMD-sized pages and false otherwise.
>> It always returns a cached value, so it can be used in fast paths.
> 
> Oh, one more thing: what will be the semantics regarding
> CONFIG_TRANSPARENT_HUGEPAGE?
> 
> I assume it will only return true if CONFIG_TRANSPARENT_HUGEPAGE is enabled,
> correct?
> 
> That is, for example, relevant for patch #2.
> 
> We could later change these semantics, but for now we should be very clear about
> what it means.

I intended to decouple the API from CONFIG_TRANSPARENT_HUGEPAGE,so my
goal was to return true as long as PMD-sized pages are supported[*]. If
arch_has_pmd_leaves() is not implemented by the arch, we default to
CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE, not CONFIG_TRANSPARENT_HUGEPAGE.

Now, do you mean to say that the API should still be tied to
CONFIG_TRANSPARENT_HUGEPAGE? If yes, why?

  * Sashiko found out that the current arch_has_pmd_leaves()
    implementation for x86 (and possibly the other archs) is guarded by
    CONFIG_TRANSPARENT_HUGEPAGE, so we may return true without the
    hardware check. But that's a bug


