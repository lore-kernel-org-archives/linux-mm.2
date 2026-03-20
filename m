Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8889E109193D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 09:34:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEED96B009B; Fri, 20 Mar 2026 05:34:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F836B009D; Fri, 20 Mar 2026 05:34:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8E4E6B035D; Fri, 20 Mar 2026 05:34:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C51B36B009B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 05:34:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70D99B3D3C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:34:11 +0000 (UTC)
X-FDA: 84565930302.15.7EC9B3E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E5005160011
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:34:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LRIN//CB";
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773999249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rFEUQS40e8ZuUNK+kkGjgLyPCZhV9YM/3NDUpWGxwl4=;
	b=II1gmzduZmyppQkDuZzOklAr8LrEXEIeqobX0Vz2h2kT8suh8YxL7UkX7YeohyRiPBRf5z
	mJn40nm+a/9gDlKk3k79HR7yhAEqlolpNelPi8654HjOfldv3kfu2ebGJXDyTApCwErKnv
	scHRvy9T9pUzd8Gw38E+y/PeqTjGCpw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773999249; a=rsa-sha256;
	cv=none;
	b=Et36P4bHIQbEnVNWcJ/CXeZW3Alw1IpPv5YWiaBmJrsYzY2v4J7YreY7k+8xRX5BPtOBYG
	UDUCc/cJrn+0UVkt5Ir6ArXjLxmqA+h2Wecj1Q6FUxN+Ceny5+XhgdLwNpMMAvGUlKRfm0
	nlaFKlgkqgrTVmRlIYxUnQR0QyewTRU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LRIN//CB";
	spf=pass (imf08.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C7DF60127;
	Fri, 20 Mar 2026 09:34:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8171C4CEF7;
	Fri, 20 Mar 2026 09:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773999248;
	bh=1pObmRVkfeuQHYXDX4q0M1f+DzcmBEqslPtmpLMlMHI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=LRIN//CB6MP+nL28Urhsf35RBU+5j+q4s9WMUnkan6oPM5eUelTBgsLXNwnb6cj+7
	 /wlQgCFQ9QStiUsV3QXxDxCPt6K7Po24n9hJt+xABILmFuebTJmAZtPeDVD3leehRi
	 ZbNbYFJqQ55b38pAAVD9HJgWK1inJ2m0xriETxGH95kCunDnLqEEeDSpRrB1pYkoxs
	 XK8P1rnwPgyQ/LanSiCVzqhHTWiC+JY5kGush4hpuqJHL4xxIsuXb1o0hXcZelek9w
	 NyUXdLYDUopFe6DYKiCYqH3GsIPy6V9K6fsRotl612dRlmadMWmv3Jk3hCn7hSLY8b
	 q9Fb92lDd2bhw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,  Alexander Graf <graf@amazon.com>,  Mike
 Rapoport <rppt@kernel.org>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  kasan-dev@googlegroups.com
Subject: Re: [PATCH v2] kho: use checked arithmetic in deserialize_bitmap()
In-Reply-To: <20260319193735.2ea34594b36d37e7850a8c37@linux-foundation.org>
	(Andrew Morton's message of "Thu, 19 Mar 2026 19:37:35 -0700")
References: <20260319210528.1694513-2-elver@google.com>
	<20260319193735.2ea34594b36d37e7850a8c37@linux-foundation.org>
Date: Fri, 20 Mar 2026 09:34:05 +0000
Message-ID: <2vxzv7eqc0aa.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E5005160011
X-Stat-Signature: p6dgm3rywcoz3r53913d6ps5sg4kayjz
X-Rspam-User: 
X-HE-Tag: 1773999249-757379
X-HE-Meta: U2FsdGVkX1/FP9n28sx4rvHTn+hERggIjOZujxQ2FNk5lxCSY96JdDYRYP9lIy6smm3uj/IbineliNgUVqGsTaVZsom0JnPO3swNNkwHniP8DKul9UFVwolWxMVSTDJJJdI2dFGmRgxPayZp5l+gJqVHLr4qmOjd5IiNRGBRenzXxiOBw6uxh7fX7XJMuw/+2IG1SQs8YmyKpUxkrX105y3uRMeqoPfmXJCnZwXB7cILezPMFpND+c4UJTpbgleUdT2jExixzINtymuNiXa3kOCVkW06C79+nUnysopUX/KoZU37w9Z/DYCt0cZQjeVYpXlF3cqZh0tQjLwDH1eRZW1T7sp5vJxGjbY08mt90INOCk+kaACjsPfbC+lHsOyivu6+JEtIrhR/uELKLKBdqfOb5j3BXQ+AhnXNmrbCC9glyug0PGwPAR7IWAOnG3dcX4/0TosUtxnVrbv4dpRSdPXF/bZ+iEQh6WPni5i+Hcp8F6uqQNCMX/lJbVGqWV033TZHGu+/5+tWaviikwjexg34fpEg/8HraggLZDSC81PHNh6YF3N6E6QcFbGw/XanyTzqARLGP7LfHq5dQSzBDJPyNQkTI/1DPnOY4lqCOZe0W8NAgahIsdH/xf822D9wM5Ev4X7ShMb+qp/hsMyHKa644NGwTbg7x0ZAddjziYKgirTpzxMStx73SDeZQylpvXG8grkkRRbyLXPGMz9ntTRq7SgcZr+XbPcTXRCEczPqC2v8UuHAn/VqL5gHBSxJcowXSG7JhimuC7pPBXqd1dOhRhdUcCo3gy5r5GDpTd/5M05UkqRZx/ZfskwhU0zB6+ah1JNU721HbkvCyMpEVhWLxETnIXOiiiU56vwqm50/88cT2/I474NwuQyFyX6h/6NmWHfJAmUMkukaMbWQPAzWd5gRLlTZFY8SG3B3Pz0utBflQduy/8HT+1gc/WPLvSMqE6OT3ANKUqx4fBf
 zXSdM0XJ
 fTRshwHmtcD5ivv3E0trCUA9qbE/A/lBi7uqb2KczdnimurgutUhkwXPq8+9okfW3I2Dkoh06XGR1iQ2jDRT2xHl5EADyZoUvuQdk6rWq560CbNaGDxRbM3tOppJeN6xrXnytC7bmu9Do6Y0A8MzIkIMFapioL1Ja+wtSyyc2F6FyOALUdnXw5YzdyTIHw5sSs+YwUaK0gj5j8/b2vD3p9opZpEdQICBlyf0f3h+KefSv/YU8Wal3Yj8VZ017YDrMh9MiL5eLZ3JJRwYWP2DfjrLNalce7WAMaEY7GPqY3az8AVyO/lWtlDMtRV8+buq4itiI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19 2026, Andrew Morton wrote:

> On Thu, 19 Mar 2026 22:03:53 +0100 Marco Elver <elver@google.com> wrote:
>
>> The function deserialize_bitmap() calculates the reservation size using:
>> 
>>     int sz = 1 << (order + PAGE_SHIFT);
>> 
>> If a corrupted KHO image provides an order >= 20 (on systems with 4KB
>> pages), the shift amount becomes >= 32, which overflows the 32-bit
>> integer. This results in a zero-size memory reservation.
>> 
>> Furthermore, the physical address calculation:
>> 
>>     phys_addr_t phys = elm->phys_start + (bit << (order + PAGE_SHIFT));
>> 
>> can also overflow and wrap around if the order is large. This allows a
>> corrupt KHO image to cause out-of-bounds updates to page->private of
>> arbitrary physical pages during early boot.
>> 
>> Fix this by changing 'sz' to 'unsigned long' and using checked add and
>> shift to safely calculate the shift amount, size, and physical address,
>> skipping malformed chunks. This allows preserving memory with an order
>> larger than MAX_PAGE_ORDER.
>
> AI review asked questions:
> 	https://sashiko.dev/#/patchset/20260319210528.1694513-2-elver%40google.com

I have also been keeping an eye sashiko for kho/live update patches. I
think it is missing some context for KHO/live update, like the fact that
only 64-bit platforms are supported, FDT data doesn't need to care for
endianness, and so on. I think we need a set of subsystem prompts for
KHO and live update. I am experimenting around with a local deployment
of sashiko. I'll see if I can get a basic set of prompts working.

The the LLM review of this patch, I think the only relevant comment is
checking if elm->bitmap is NULL.

For the others:

1. The restore path does (should) support order larger than
   MAX_PAGE_ORDER. I sent this series [0] to make that work properly.
2. KHO is not supported on 32-bit.
3. We just have to trust the previous kernel. There is no sane way of
   preventing attacks if the previous kernel is malicious. For example,
   it might as well give us valid memory addresses, but change the
   contents there. So all of these checks only defend against buggy
   kernels, not against malicious ones.

[0] https://lore.kernel.org/linux-mm/20260309123410.382308-1-pratyush@kernel.org/T/#u

-- 
Regards,
Pratyush Yadav

