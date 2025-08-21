Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC320CA0EF8
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 12:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE8508E003D; Thu, 21 Aug 2025 08:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D992A8E0020; Thu, 21 Aug 2025 08:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF0A8E003D; Thu, 21 Aug 2025 08:31:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BA3A18E0020
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 08:31:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14884C03E8
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:31:32 +0000 (UTC)
X-FDA: 83800700424.09.ED11F01
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0C2E220014
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:31:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=pxY2U7T6;
	spf=pass (imf13.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755779490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0Pa53Um5cV6psLWFzf5R9C2ysYXE6Bche9EpkTiSqE=;
	b=fOOg2TAEQDklDGyo2YyD6BWQsnM2XX+V4gUd88EHX1m6SLVDc2aa/kcnIZRNcXFHUpXgiC
	1hI6lQooWjBgoItBN4j0SSvbp5t22vTcnuqBJftuTctOhJ+qYM1X9sraQgVd5DuIPNmj+2
	iRHjgWqAmdJRN/S9+a3909v8/KVYOB4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=pxY2U7T6;
	spf=pass (imf13.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755779490; a=rsa-sha256;
	cv=none;
	b=Ht352zdiWJk/oFF7ZaY98/w11zD3L0b1L1cmPa7FJ4kdTKtwYrmPXTNNyWQRqE06V+KUOO
	GMQSv3KJDFxMATTNP7woNPosjWn014sZSzW9D1Fht1FL7h1znTZPa9AKqwfkdLLUqkxX2+
	Y4ptqGxYzBgoUbhzhTu94MvwsPh91K0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755779487;
	bh=1X8YBWQ47kcR3NLnc+BPXG4nANE+2JC2KP0lrQKG31k=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=pxY2U7T6feWMfT06C+jDFtze1Osu/4/30Jd05L50qRP1+VvZiFq28HhygitP/Ob3X
	 7AgKEzRJm4aK65dep/E37eDo07STb6zGmIi+1+o2wGt4mG3JJF6H6B/GVyz/+s3BIq
	 5HUlOnikVBzFqJn+/fRC+dqu3++s9wG4MPjSjg+tIE7auAevL/3Uxkm2mKAOju655V
	 f7Y854pDGZHftB2+BHbQ73Mb+mKQr2yHyg/sFlDVH2WsrBiY+nBVp7YEXrVOgeJom7
	 M25vTND0UIyH52A1ZGChgPa4YAVPMHoBlP6iVU0/TmnMIzYYlBlt+P7oQ4ziPu4UU+
	 LZZjStQTddfhQ==
Received: from [192.168.100.175] (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E4E8D17E0154;
	Thu, 21 Aug 2025 14:31:22 +0200 (CEST)
Message-ID: <4abd97fe-412d-4e3e-9efc-cf3092d66e57@collabora.com>
Date: Thu, 21 Aug 2025 17:31:21 +0500
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@collabora.com, kernel@collabora.com,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 Vlastimil Babka <vbabka@suse.cz>, Albert Ou <aou@eecs.berkeley.edu>,
 Zi Yan <ziy@nvidia.com>, David Hildenbrand <david@redhat.com>,
 Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Palmer Dabbelt <palmer@dabbelt.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Leon Romanovsky <leon@kernel.org>,
 Shuah Khan <shuah@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Alexandre Ghiti <alex@ghiti.fr>, Barry Song <baohua@kernel.org>,
 Dev Jain <dev.jain@arm.com>, linux-kselftest@vger.kernel.org,
 Paul Walmsley <paul.walmsley@sifive.com>, linux-mm@kvack.org,
 Nico Pache <npache@redhat.com>, John Hubbard <jhubbard@nvidia.com>,
 Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2 4/8] selftests/mm: Add -Wunused family of flags
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
 <20250731160132.1795351-5-usama.anjum@collabora.com>
 <57c816d6-a9ba-47c9-8f40-3978580b7f67@arm.com>
 <8e9d7c59-46b4-4e1b-8a55-1898302f5080@collabora.com>
 <88ea592c-c6ff-4a19-a366-eadeca66b039@arm.com>
Content-Language: en-US
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <88ea592c-c6ff-4a19-a366-eadeca66b039@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0C2E220014
X-Stat-Signature: gj4ed5tx5r68f8rd5btzgz3dshawrnjt
X-Rspam-User: 
X-HE-Tag: 1755779489-49804
X-HE-Meta: U2FsdGVkX19aAX4OW9oaOBy7XjL5qo7ioRAh2/4HZHOQijTPI6YMoe4YofE4VaT29J4DeknGodjmR9cGY5oUNQyhPq/zx438rVoEiQfdQEYOq/hyxiegbEatX11JiqTvU5A3JIUC4EHygDyaby9NOyjyO33oN024iNCHhLgHKmXCA7PRBWA6p0Jk0xHqZEniBeMUrGNJbPj1mWhnWRH0WNydiFF5C15APJRmRDRABXw+QvLPKS9lsoKVloKNR14Ddp9YWltjOog0lz3kKrii1q1rFNl+UrHMXI86ps0XLpZVwrHQW/wYHD7hUbzi19M2iXMJB4oWao0Jr9UGSRhsmoxRpwAUwY/uqPMZimhGST+XxqmQpR+/qBmJEiANbOP5bUWWq0QYmYChdWPZNKnr2hY0QSmnW0lwqn44tcZFiZR+6PtPnxbj2GlBfilwTglJ+PFhZGiQxfsrHphJXNU7fLU1FpIwcw11rhgFYYuNHCe2jrVZ+/2KntVX2uqZlEtD+eZasTjXoe1KaMn3d/opQRxJln/Ira2HMkYTmawdyikcKJVbo8UI9QQGmZCp1gkq0iIzka/U5PFaGy2WYJ6azeVc9PXZoOTRpw1xtXs0PeCkox8NQV493ehCigY31yJ/Qa4vviB1gq2QeiWL5UJgjOc9ZLTNCUyJm6ai1DGRTmpqs46P3ErNwmS/4lKszqazmx2G4ZGrg+BHjdqxerrQwhu2a4ToOlJobqBzZFk/GK4XFswQWSf4cS+r4bmLMrCabajEOM86fdD3iqNHlaPcubbxXpzU6WRW6j2qyb4lS0pwlOFv8ko4UD6abOgGPwKTQ4wUlO/B7PRH9QECsWo7nnNQ+vvkMfg6y581hj4gFo1Y2k6AyqBvO2zygi38JkPKh9D33bBB6JPAP3IooSiwTEBZD2UyJv5t5mtO5MjMZrrjhurgiOsMjFFkuVvQqFpuyb0SSlNSiB2cyBwBllu
 c8RAGtZO
 537tUWovXmWSFkOwgOToLhbcZk0z5IekXLNHZZLGflS4JPrZIhMPzWs+k1tZyW1dl7MfLeBiXTbk/A6yRaz1hcU74Cxx9fnj1ZiywKEzsOOj4Jp0yekjlEAkZjP0rfnQ4nEL5O9m9j9gr/9X/loKB4BfQYhbz8fvX+bWwESFgDZ7hVybL+7g/kKvPVu6qhumAap3LU7i50rZkBrC6IcXC18djv6g5TQnoOM4HGsUpP65qwDYixTamOYSz7EEjS30Y6afxCKTNYyQJnQQf6lNknRmk9H/e8wll4b8uPAkkEYlL0Qa8+mJ0iLhym7Gp52CjNlb/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/25 3:43 PM, Kevin Brodsky wrote:
> On 21/08/2025 08:28, Muhammad Usama Anjum wrote:
>>> As to -Wunused-parameter I am frankly not convinced it's worth the
>>> hassle. We're getting 90 lines changed in patch 6-8 just to mark
>>> parameters as unused, in other words noise to keep the compiler happy.
>>> It is not enabled by default in the kernel proper precisely because it
>>> is so noisy when callbacks are involved.
>>>
>>> Patch 5 is clearly an improvement, but I'd rather take it without
>>> actually enabling -Wunused-parameter. The rest of this patch isn't that
>>> useful either IMHO.
>> Patch 5 removes genuinely unused parameters flagged by the compiler. If we
>> drop the -Wunused-parameter option, however, new unused parameters will
>> continue to creep in with future patches. The goal of enabling this warning
>> is to surface such issues early so developers can address them during
>> development, rather than later during review or debugging.
>>
>> Long term, I’d like us to rely more on compiler and static analysis just like
>> kernel to catch these kinds of problems proactively, instead of waiting until
>> they’re reported or someone fixes them later. While it may feel like noise
>> initially, this is largely a one-time cleanup—once done, developers will
>> simply fix warnings as they arise, keeping the codebase cleaner going forward.
> 
> Agreed on the general principle, but I think the hassle is just too big
> for what we're getting in return here (see also Andrew's reply). New
> code may also introduce a bunch of unused parameters for legitimate
> reasons and it's easy to imagine contributors ignoring such seemingly
> harmless/irrelevant warnings instead of sprinkling __unused all over.


> My
> feeling is that unused parameters are expected to be allowed in the
> kernel and it isn't helpful to go against that expectation in just a
> small subset of kselftests.
I thought kernel must be giving error for unused parameters as well (from
my memory). But just checked and it doesn't seem like it. I'm okay with
dropping -Wunused-parameters.

We need to drop patch 6/7 and in Patch 4 should have only:

-CFLAGS += -Wunused  -Wunused-parameter -Wunused-function -Wunused-label -Wunused-variable -Wunused-value
+CFLAGS += -Wunused

@Andrew, Should I resend the entire series or would you can make the change?

> 
> - Kevin


-- 
---
Thanks,
Usama

