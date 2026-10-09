Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55D88CA6018
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 11:27:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590E56B00A0; Fri,  9 Oct 2026 07:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 568DE6B00A1; Fri,  9 Oct 2026 07:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4A26B00A2; Fri,  9 Oct 2026 07:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 291676B00A0
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 07:27:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC93440329
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:27:35 +0000 (UTC)
X-FDA: 85302862470.16.7104412
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2062540004
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:27:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=eh8QHMkE;
	spf=pass (imf01.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791545253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sd29WIiqfdVWcWcizPFVJr9wsS2+jLlXGujHLrFRB5g=;
	b=XGuh/LUGu1lVhUUpRMW6de8DOtOc0aMYUikvLNCLWTtOjW3QJwRFAuwtgKISQ01dgmFybC
	zNjr7E9q1BQp3KaxbgC8Jj4ZkUWftYqtvPKN5qOuTceSrC8HACJksXeKbghgStNyDZqAfV
	1VrWIa/xrCVmvQsB+F/3A32ooXrpGeA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=eh8QHMkE;
	spf=pass (imf01.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791545253;
	b=qrmlkiZU8FcR/mE4b+p2ccUtbIBQiHfjSxcdJ9X8L9NvN2H/PINeMqWaHvsvPYbGhHVOUa
	jzcUcWszhgiIX30oO6xQGThXw705RL0esFVVkNulxJwlkuwYAFY3fo/wv6NyiXnE5gPERi
	pSh0Q8ap4OzHWawpdxgEHDpTxNLldbI=
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20261009112731euoutp02f7e4c9f6da8d4709158f858aa3a4cf29~c2OnwbJcK2428124281euoutp028
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 11:27:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20261009112731euoutp02f7e4c9f6da8d4709158f858aa3a4cf29~c2OnwbJcK2428124281euoutp028
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791545251;
	bh=sd29WIiqfdVWcWcizPFVJr9wsS2+jLlXGujHLrFRB5g=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=eh8QHMkEFgU8Sy6/PcFUtjJwUoiVOeRsuISS9DdNDMXzr4/dd5rCvbl1agE354YXu
	 IQa6IB8mokguVKD/BFtqyA2b4KX15ZWKZRXbd53ZoMxMuTrqWf0JOvFFiKPGt8hpG7
	 bl9LHhiPnQc0C1zED5y0d78Q/oZ6/V/T5JYWBn7Q=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20261009112730eucas1p1f516da70272a6482ddd5a6e5c90ba395~c2Onj92gJ0217302173eucas1p1R;
	Fri,  9 Oct 2026 11:27:30 +0000 (GMT)
Received: from [106.210.134.192] (unknown [106.210.134.192]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20261009112729eusmtip2bd8329823fee0d3259af1274218235e5~c2OmuwG6m2544925449eusmtip2N;
	Fri,  9 Oct 2026 11:27:29 +0000 (GMT)
Message-ID: <81d6c6be-d03b-4fa8-be30-1425c4d1ad40@samsung.com>
Date: Fri, 9 Oct 2026 13:27:29 +0200
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH v2 2/2] of: reserved_mem: allocate and map the
 reserved_mem array early
To: Wandun <chenwandun1@gmail.com>, linux-mm@kvack.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mike Rapoport <rppt@kernel.org>, Rob Herring <robh@kernel.org>, Saravana
	Kannan <saravanak@kernel.org>, Oreoluwa Babatunde
	<oreoluwa.babatunde@oss.qualcomm.com>, Andrew Morton
	<akpm@linux-foundation.org>
Content-Language: en-US
From: Marek Szyprowski <m.szyprowski@samsung.com>
In-Reply-To: <a8ac6daa-e721-4cba-bef3-3333643db23d@gmail.com>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20261009112730eucas1p1f516da70272a6482ddd5a6e5c90ba395
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20261008152450eucas1p1d5517eadc2c1d684ff6d4ddc010f6331
X-EPHeader: CA
X-CMS-RootMailID: 20261008152450eucas1p1d5517eadc2c1d684ff6d4ddc010f6331
References: <20261008152403.766439-1-m.szyprowski@samsung.com>
	<CGME20261008152450eucas1p1d5517eadc2c1d684ff6d4ddc010f6331@eucas1p1.samsung.com>
	<20261008152403.766439-3-m.szyprowski@samsung.com>
	<a8ac6daa-e721-4cba-bef3-3333643db23d@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2062540004
X-Stat-Signature: t9usnhwijjkfxpe4zg51y8qg6sg81t5y
X-HE-Tag: 1791545252-80381
X-HE-Meta: U2FsdGVkX18h2ZJ7oOn2zn5iYcSwqBxQHOp8YACxQ/YoMSjDKRnee7zFwlsvc6SAFbsVZEHdLHhpo3l7c2vjQ/witzYCY7SQ7iVN8y9afiATtOm9lwrlMPzV23hxynuU8gjdWlD7D7FltKFNaRMhtqH2v1QuJnGdzFKIXhpfU5tkS2mXC7zhNtXIjXJs5AZS1085oOCohtSpZXpEheIY3A1CYhboaLif0xAO190+S4RfSjss051ZdCfNB1XE7vkOQfGoCqrfzlO2GSsRZTWgFMs5P1fS+QaHgQ+NR8b1TFO4gso40seyxKFhSMvDIsXQv4wutUTwre3U8CGX/5QOApj7awG9hqtJV80yE4qiFoAsbWwARXV54ag5Vv9JihhU6pXcj1xCj6kuE5z3hB+L5BdBzjyCIIxkH/fnKvmvwWg2cwINPxTE5Vo4F6U2jr0ZtwP3mUyrjBaD2Ht7p/sLSizhU16IzyxVJFGNHqPZuE3JUmv7CYAHpjRvIKeBXA07qLQCWci48iMhb9byHO1qBgdnahgmleE1u9VfDs/9tktriBxUHTcqaCyH97iLlN5CAWNXux/rpWFwXkp9oB2RsiGCU96PlmPBuCsRtHVr9xU21Yu1cwL1ilcemzWICkmBowbNoPVU5Y3lpaveDx/DJPv6qshvkogBzEJ6B5s4nzIjUF56k+ql6CdxERwmyFF50kCuZIMwqHMLVkASlyGq1nRnjJjKbo4igCwb8ZAZt2ltLjPGwRCigKKQogs1DZc9iXjG+TdW2Nh5WgiWsYYrBbl8HT73xLCiC8KUb4c6INALClYwGNJg1Tbzw6Lmv8+zL8RnSunX06c/7HTt0C994n6d9U8VLCdBxKoQG54j467g758dOG2Gwv1jwr5wWsI49Jxd2qhMJNxOkyNq0Tt3TWsNIx5z283Nj+LiktjSFUwe19my9knA8ngaBC1HevHf4a9Dhs2JSxK2bM8PKnW
 4giPs9NS
 mepvj4RfyAhIxvMSSYOlN/8vUMS3ZXSu06mdNlAw8bUy1HW0XdDJdEOo7X/ISjxnN9pGftBIqo1t5gUOpmaKtJvijYz7YBFJRWgnSewVtcDzNOVGBob5HVU3U4sGTF/SKPhV6bhkRAJbNoW2POG7CaITYVB4P3Ay9AvbXHQILukZOQ0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.10.2026 04:16, Wandun wrote:
> On 10/8/26 23:24, Marek Szyprowski wrote:
>> Get rid of the static, limited-size reserved_mem array and replace it
>> with array allocated by memblock_alloc_raw() and accessed through a
>> temporary early_memremap() mapping. Such mapping is needed for some
>> architectures (like ARM64), where linear map is not yet available during
>> early boot scan. Having a single, writeable array with all reserved
>> regions removes the need to perform two step initialization introduced
>> by commit 8a6e02d0c00e ("of: reserved_mem: Restructure how the reserved
>> memory regions are processed"), so all regions can be processed
>> directly during the early scan again.
> One concern about the ordering here: the new memblock_alloc_raw() for the
> reserved_mem array runs *before* the static ("reg") regions are reserved,
> so the array can be allocated from inside one of them which makes the
> subsequent static region reservation fail.

Well, that's what Sashiko already reported. It will be trivial to process
'static' regions before doing the reserved_mem allocation, but this in turn
returns us to the point of not being able to handle their reservation
failures. I wonder what's worse...

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland


