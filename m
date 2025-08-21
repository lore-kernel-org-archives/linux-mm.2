Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E78ECA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 10:43:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF4448E000F; Thu, 21 Aug 2025 06:43:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCC318E0003; Thu, 21 Aug 2025 06:43:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE21F8E000F; Thu, 21 Aug 2025 06:43:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACE418E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 06:43:25 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A5E11603C7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:43:25 +0000 (UTC)
X-FDA: 83800427970.19.3D95625
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id B18B5100007
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 10:43:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755773003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xA5z4QGiRT8EMnfJu0zYHYDYsBX5hfHAvWyffpSGsoI=;
	b=MNbpKB9+TWsAXvu3w4pdKOCLXeWKmLW3DVPqDAXY4ZWj2cxHC1AFvyfrDFvjIsmZN6XA2W
	qthx/iKCta2S9SFKC/e1TOd9Vxo8vP3TxxsQQCnL4DCR7UptLx2vv0tvzZ1aTEvj9lnBEe
	5EaR0hmCSIQX/sogS6Wb44S5Gk2mrq8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755773003; a=rsa-sha256;
	cv=none;
	b=5d9Xrs4BkV7oNNboX7PkFJiZi8NmiSRwyqKr53sVc0po5RNldBPirgv5Bl6eHkyNALVuRu
	YYfIRJP8j1JN5F2RTR5mFcQlcZOsPFRZ/96mhrZm10hBcISMe5Z+yJTzUckIVXbeGN4Hn1
	cbMBaM4irixVl1/bXm+HLxzSR9tVGMk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 51F9D152B;
	Thu, 21 Aug 2025 03:43:14 -0700 (PDT)
Received: from [10.57.91.188] (unknown [10.57.91.188])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 298EB3F63F;
	Thu, 21 Aug 2025 03:43:14 -0700 (PDT)
Message-ID: <88ea592c-c6ff-4a19-a366-eadeca66b039@arm.com>
Date: Thu, 21 Aug 2025 12:43:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/8] selftests/mm: Add -Wunused family of flags
To: Muhammad Usama Anjum <usama.anjum@collabora.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Paul Walmsley <paul.walmsley@sifive.com>, Palmer Dabbelt
 <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, Shuah Khan <shuah@kernel.org>
Cc: kernel@collabora.com
References: <20250731160132.1795351-1-usama.anjum@collabora.com>
 <20250731160132.1795351-5-usama.anjum@collabora.com>
 <57c816d6-a9ba-47c9-8f40-3978580b7f67@arm.com>
 <8e9d7c59-46b4-4e1b-8a55-1898302f5080@collabora.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <8e9d7c59-46b4-4e1b-8a55-1898302f5080@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B18B5100007
X-Stat-Signature: b95f5ywo1cxaqywmqkj4obkdqynpzmba
X-Rspam-User: 
X-HE-Tag: 1755773003-466076
X-HE-Meta: U2FsdGVkX18/4TXqieMSEqYakgySsanQCnIlHaO3qVcXYbB+we51Mmbl7PT4FmD9zffzcZI8y+0Gg//WH62xy3SlX4wYF11e5MWbqzSYelktP/cGTdHoJ1FG8uf94QGQxEUNosEz39K8OIgcXUemJmBRlb6vNvBqyTXp5VH3nQ46YeufidLlXOgY5qZoh/Qhk2D3T2dpIrtRPASGsXHmnuthd5Ya3W2VtmydE0v69Zgs69N8f/N40RZxXxXdwdg1fhnMjjKaj6fNM31Y/oby7KTjrP0bJ/Deae9ugBJUCQbrpJV1iR+dPSLQyCJc+M/4kJyFgOmcsCiZCnsm+dSO2YaDP5sq3yMJWw0t28B1P1iNpui2FTH1RABOaosNoMB4le7yICPeCRMT0qo+dmwxkebYWedP/1kTHq3KshdzroSd4GWUFXjXqS2wTvAlUadObLOZphVoR4qKYqGONBvLbItVNQ3/E5MryyZxd31jrJ2lI4HmdTHot3A8Dtxo6HQ+aM88dgnK1DXKYmm5rrYy3We01KINwb01f01x1QBrdvP9lmL+8/3h3zAt7qJjZ5IMzORPfF8H1D2g3+HJ+ChltYj6wO1UqMbaShpBbuIrI7rdBedrlDCGmzcfZiJUVaME+0BB8O8zoa2nFNNSQMaulbytATSd1Vjq1XmUVsg0SyBNkAE/5JQYOTf6YQcWgKzVxG5HKzQfQ4fGYnZa+Hrf9HilNsCHoVcuJE4wUPC3wRo+fbgfciXWk36Eq6b1pOKgVu46g4QwwUl/lh+6dAYVYNThUGg6VSYqMg+4WsFpKGsP+yUY5XGU2An8rkua7BelQ7FMHoFkn1Q+x3VlquXbVhZohlO5h3HJbccnPGH+b+XJVnGqqCKp8xezEtA9F/pTHF5JLNNSHx3pymuOdSaGhcGMWUaOaTDc2bEEKN1mroxb96JJJCwLWEEOGTQUtGsS5xWEPTlpFVR8UrfNnW3
 vF3mM2Hx
 nZW+3gzLX0KobZd3QJ+IfzuenB1z4gzTFZDun1GJQs8gAqGceuWRbPhQnDMVRxPcFRt9WOmUdJBQr2lCrOK3Ljvism0Wh/zxvzsuz73DKYDN+tL/9isAyDXs7oSiuKaWHHIP/zgLU/PHa6Poim9Zdqhg+yHhDgY2HEwlFQlc01tdDWOY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21/08/2025 08:28, Muhammad Usama Anjum wrote:
>> As to -Wunused-parameter I am frankly not convinced it's worth the
>> hassle. We're getting 90 lines changed in patch 6-8 just to mark
>> parameters as unused, in other words noise to keep the compiler happy.
>> It is not enabled by default in the kernel proper precisely because it
>> is so noisy when callbacks are involved.
>>
>> Patch 5 is clearly an improvement, but I'd rather take it without
>> actually enabling -Wunused-parameter. The rest of this patch isn't that
>> useful either IMHO.
> Patch 5 removes genuinely unused parameters flagged by the compiler. If we
> drop the -Wunused-parameter option, however, new unused parameters will
> continue to creep in with future patches. The goal of enabling this warning
> is to surface such issues early so developers can address them during
> development, rather than later during review or debugging.
>
> Long term, I’d like us to rely more on compiler and static analysis just like
> kernel to catch these kinds of problems proactively, instead of waiting until
> they’re reported or someone fixes them later. While it may feel like noise
> initially, this is largely a one-time cleanup—once done, developers will
> simply fix warnings as they arise, keeping the codebase cleaner going forward.

Agreed on the general principle, but I think the hassle is just too big
for what we're getting in return here (see also Andrew's reply). New
code may also introduce a bunch of unused parameters for legitimate
reasons and it's easy to imagine contributors ignoring such seemingly
harmless/irrelevant warnings instead of sprinkling __unused all over. My
feeling is that unused parameters are expected to be allowed in the
kernel and it isn't helpful to go against that expectation in just a
small subset of kselftests.

- Kevin

