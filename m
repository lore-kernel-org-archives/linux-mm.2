Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC3BFD6552B
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 09:58:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBD6F6B0005; Wed, 17 Dec 2025 04:58:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66FC6B0089; Wed, 17 Dec 2025 04:58:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93AB6B008A; Wed, 17 Dec 2025 04:58:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B93126B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 04:58:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5253F8B35A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:58:56 +0000 (UTC)
X-FDA: 84228514272.23.D844E01
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9593D180003
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 09:58:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765965534; a=rsa-sha256;
	cv=none;
	b=hLYnMibZc1RHozoowsZ7ht6/Hacy442oz4o8OvNs+/KIKnR6AoHZPI5afiXe5VN8E0m6P5
	9DG/wsc5FQX7zcNFHXV/MUgj3Vfjc8tdj9xf22wE6/y4EQZQ8oIz+rKtDXKYfC8ruWisDK
	WoYfgxAyReYmoUhW91siF8Q9XABgE9o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765965534;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gN/H8i3miq5qlipZQsB8fYqLIfEnDpgpAaccyJtST7I=;
	b=npwE2iKX6Drx3+cLB5p6ALqfetgzPv3vDf1MNdb/YIY0P1WrnlssH2bbn0PWiaFYAcnL4O
	EGZrFCZzXV9XAhALfOX5E/etLITreoopjdfr/WH3E9wKW94kaLK0UHO9D34n/9NyTOmVGa
	WjLpZ9NFbnEv/AmlEG1y/QuCnIRjZcI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8038C14BF;
	Wed, 17 Dec 2025 01:58:46 -0800 (PST)
Received: from [10.57.47.3] (unknown [10.57.47.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2D2E43F73B;
	Wed, 17 Dec 2025 01:58:51 -0800 (PST)
Message-ID: <c59eb8d7-c6bb-4618-b7d4-2ce5df88b5f1@arm.com>
Date: Wed, 17 Dec 2025 10:58:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] selftests/mm: remove flaky header check
To: Yunsheng Lin <linyunsheng@huawei.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Paolo Abeni <pabeni@redhat.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-2-kevin.brodsky@arm.com>
 <b62c18a2-7036-4cca-a3e6-8a873a2ca832@huawei.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <b62c18a2-7036-4cca-a3e6-8a873a2ca832@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9593D180003
X-Stat-Signature: ing3q1cj74ohpbjqmabf9ao4hfxf77bq
X-Rspam-User: 
X-HE-Tag: 1765965534-991307
X-HE-Meta: U2FsdGVkX1/kHHptFuPvaTdazMx1AvQ66P1hqvAiqnCJu1/GSqyWd0L/gCMlS9rPy8WVVJrAu+1TJV/syPwc1GjcU2HBs9lPi8BKi/inLw4srxhfxyZCyf8ZzUKci6kK5w59TQ24hXzamFmzUicWiopa3ngRIn+nH7qevDWx2my1b2V2Pcsj7KfTe2/3lZ2Su+rZBzKhFGScFMXWjgsX3qujdM8jcZdyFFY/rJglb2ohlh2OXNoEJTscGvtPGWXiyii6ymyar1BpktvAU87YSfAyxgRdrIdtcvskYwJBbU1j531acLFFUi2Al0RV1c7+ZlTSj+ywmsUfLwCbuz3Ecy5TxmFRDZXdWZ6iV2hkxrdM0n4mT4AVjzU8/q2ahMYbTUCqAJTzybL8KoWiXHYEaLjoRE7QkreJJP6gvHBIe4Ff7smG48F/ThMM/qh0mI4bbNwSTju3INU9Qt/jYYW9UMNJ3QXYm7w1lEDVQVm2v6yRN901s1SVZM2JvZkerv+lxFn8ekQ2oV6Dy9CCG6WwHeD08bsQxpYpF2MzatwNR79stBqPI7sGZZUHf7bf50XCjukRfx3wq5XhbgLECywTEEJath8RBHjgvnLooP8U9Da7p5DFonUdMVnVeEWJ0NGCvokMfeWWzjzANlopFg9CDCxmPBCiK8WxuKD1G8gl72hIlYciuprhegiSRcNdtsQkVXwcGMjTZu6kNLgJcPxAm2ce7vKttLL9ppqrMMarwHsR/pqB/c91tvQnr7by/fvsH46NEwxp26h5stWvQSsQNK2u7Sy+dZh84C7LaUfQn3jK67gEk+hsYGQHr7I8ZBMgG7gYlcH45wyKvQ2pTLFAzYjyQY9fA365/oTGooo8PZ6EE9OCjOQmH0ExCPaXks39EYLpPr0oH7PRQOYHkKoK7W9KIL/cSWoEqZlspyFfZfmtlf7SicI5YN3A/MbnuMnIlmq6hBbdkdOqP9Ud16Y
 XL/b+BdU
 hC1q82qKG3nfRGp4i7tM2RZCnbnhI/gxsapOREGlfAswTJy6MZSwOa+dcYVR40TebPoNVDgqEwpPMn6xUAbLILh6HuEJtz446dcmL6CtsZexve2rCDXABmKjV30U5fihV51/u4DAr1+beXN0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/12/2025 04:18, Yunsheng Lin wrote:
> On 2025/12/16 22:26, Kevin Brodsky wrote:
>> Commit 96ed62ea0298 ("mm: page_frag: fix a compile error when kernel
>> is not compiled") introduced a check to avoid attempting to build
>> the page_frag module if <linux/page_frag_cache.h> is missing.
>>
>> Unfortunately this check only works if KDIR points to
>> /lib/modules/... or an in-tree kernel build. It always fails if KDIR
>> points to an out-of-tree build (i.e. when the kernel was built with
>> O=$KDIR make) because only generated headers are present under
>> $KDIR/include/ in that case.
>>
>> <linux/page_frag_cache.h> was added more than a year ago (v6.13) so
>> we can probably live without that check.
> As some commercial OS still uses v6.6, I am wondering if we need that

Fair point, I hadn't considered that kselftests are supposed to be
buildable against older stable kernels.

> check for a little longer, is it possible to do something like below to
> avoid the flaky check?
>
> @@ -46,7 +46,8 @@ CFLAGS += -U_FORTIFY_SOURCE
>
>  KDIR ?= /lib/modules/$(shell uname -r)/build
>  ifneq (,$(wildcard $(KDIR)/Module.symvers))
> -ifneq (,$(wildcard $(KDIR)/include/linux/page_frag_cache.h))
> +KSRC := $(shell readlink -f $(KDIR)/source 2>/dev/null || echo $(KDIR))
> +ifneq (,$(wildcard $(KSRC)/include/linux/page_frag_cache.h))
>  TEST_GEN_MODS_DIR := page_frag
>  else
>  PAGE_FRAG_WARNING = "missing page_frag_cache.h, please use a newer kernel"

That seems reasonable, and it works for my out-of-tree setup.

Will do that in v2, shall I add your Suggested-by, or maybe Co-developed-by?

- Kevin

