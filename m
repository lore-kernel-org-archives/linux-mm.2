Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23831CCD184
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 01:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FCCE8E00EA; Tue, 14 Oct 2025 21:52:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3D98E0005; Tue, 14 Oct 2025 21:52:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 510AA8E00EA; Tue, 14 Oct 2025 21:52:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 432598E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 21:52:19 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D93895C686
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:52:18 +0000 (UTC)
X-FDA: 83998673556.04.BB338AB
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id 22D2EC000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:52:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W+RsocPB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760493137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zgcZcBwEZHvov/1clD5IPA2OcJJtZnj/AiNz3lCc0iU=;
	b=ojdC1oDm7Mk4s64Z+JIsQMaNZDNVFgRoTpmMqcdu15ccycCO6ni+QpLmSoq5BCgDdNuozU
	e4LKt0w1jy/WoT5jXuRs3S9k4gaTXb9KQoNrQsWqgUBqXEj15NWhB7Be+g0ymEzmXLDvZ/
	CjbK+iyQuYqF46p2Iy6Aospamu8lX7M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760493137; a=rsa-sha256;
	cv=none;
	b=WIe2quVfJpCUdpFTZGUNRhmSzqUwtyk9gO1cBaSCNU7ga93jBvVS3cE/GB6ZECimXG5aoN
	PXN/tJssqw1TWV7Ga24b7x6VGqryHJ9FiXzifYLY1ROYMkLVlQl+Cinw4CiEdmC2udxCuY
	KN2zJEJ1pjz+3MOZCm3YMRbTRi5fj6E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=W+RsocPB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
Message-ID: <2495f0c5-b23e-49f1-85a9-0c55d8913554@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760493134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zgcZcBwEZHvov/1clD5IPA2OcJJtZnj/AiNz3lCc0iU=;
	b=W+RsocPBKrJlRE7cyN7uXBBi5IBWaiBP5MC6Jt74OoXWBwQphjOadPM3Ebb5Qlg9dwnidT
	4RDurvWqeAKMFW6HMCpbYp81uloFv4pkiZdSoqnxYcOD0GZXvzNFrhwLIxO2qeQNKgngN7
	K0Cx9T5+1qoTJt7yP+Ah/2Pmear6Nno=
Date: Wed, 15 Oct 2025 09:52:01 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v3 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
Content-Language: en-US
To: akpm@linux-foundation.org
Cc: David Hildenbrand <david@redhat.com>, Liam.Howlett@oracle.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, dev.jain@arm.com,
 hughd@google.com, ioworker0@gmail.com, kirill@shutemov.name,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, mpenttil@redhat.com,
 npache@redhat.com, ryan.roberts@arm.com, ziy@nvidia.com,
 richard.weiyang@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
References: <20251008032657.72406-1-lance.yang@linux.dev>
 <f33735d3-b38d-4b6a-aeba-b415e6b24ea2@lucifer.local>
 <0bfdbccd-9d4a-409f-ae43-b44bb7347d70@linux.dev>
 <f7392f43-b8f1-4e6a-b9c8-25ad8a47f82c@lucifer.local>
 <95a223b1-8d57-40c3-8226-678b1db233aa@redhat.com>
 <57cffedc-65c0-44f1-8364-3a3ff9bdc760@lucifer.local>
 <b0e88b97-3c55-4be3-9782-4ab5e5d72ebe@linux.dev>
 <c176f6d1-2f43-4920-8133-f405e6756c5a@lucifer.local>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <c176f6d1-2f43-4920-8133-f405e6756c5a@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Stat-Signature: 96s5gwpztc1qj9yftcb9wgnpduefzq45
X-Rspam-User: 
X-Rspamd-Queue-Id: 22D2EC000F
X-HE-Tag: 1760493136-709104
X-HE-Meta: U2FsdGVkX19JUG8U41OpNy2OfAZB6yPns5QUAdXHywiXUm+Uc3adywqj4YDbJYjslvKRZerPinj2u6BpOmTBw6AWkkXJ2MP1pGfeZISzySVgPVIHNXRt78z0bWPwjfWXNPkhcS9xBN0ooKZ4DUWLtzPU3ZOnIuy1Qb6dl0QSV4f8Ff8LFAvJ89jQH4qy0emJ8vPqzO9EfMYQ1oceuZikuAor0uspeVFX4Op1vUD0lKkCQg43ZLFBlss6QNZdxwz7m6ziLpNX5i4741w46mHvdurntn75DeEz8WNEw2iFlR4izeo7QM3ARBqsCc7FPxHAdNhT91k2/iojb9Yy8Cp5T0iayoKTELwDdIEb+o+2um7KSGATjys/d642Uv5Vb5dOaBX7D2wiR5hpHFqTg61VhiUX0DXHEaWL9Sy6dsG4kZcEYrkRzwcPUAr6KfE3YzKuFaHZNnRVt/6fUn9KtM+zQelSldRXXTyy8nKlAJULhNBm1zNT9I9lkk+u4FIwftjk3HbvZZPjfr6Yv+7vFi/3OQFrpXaea4Ej6F8MoWHoaOe6DnI979+XUDWzrbRmurJzP02qkZBE1ez1LBqSxym3iDfnAGXOBp66XCNmqlyfKq8e480EcBrqXVRHNolN7PJEQwx9tUc14wm75O30aMd70MN6OxWSwMHbtb4Oi4g/MylGvSjvO55upqrqPOhI06eADSAY+3fBAUvn9HsnQr5E+5Q4OB39UjeYdxJSwd+1dQ4Xf3nu1tQeiDcX+RQ3PXiHCSRNllOF7Pez25zArDNjvTMYugXQlUmBHCgUu/iMrZMvsyolvo+5gjgxenObSfnPWp7S+gHjoWtIS7X9AumkebqDarMfctsYJDh7LciYQ27hXxZXfIdEFctV0HYs55xqUKgic1xbpau6z5U0AjetoxaMWSzrI56fGwaiXkWOHMKRj7R1OJsFmS4fae1adlcz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


@Andrew could you please drop this patch from mm-new ;)

Thanks,
Lance

On 2025/10/15 00:27, Lorenzo Stoakes wrote:
> On Wed, Oct 15, 2025 at 12:09:42AM +0800, Lance Yang wrote:
>> Hi David, Lorenzo,
>>
>> Thanks to both of you for the deep dive on this!!!
> 
> That's ok :)
> 
>>
>> The code we've been discussing was moved to a new helper by
>> another patch series[1], so let's call it a day on this
>> thread and leave it as-is and just review/change the logic
>> at its new home :)
> 
> Ahh, please do make that clear in future, I reviewed this on the basis it
> was a dependency of [1] :)
> 
> I separately reviewed that on that basis.
> 
> Will reply there...
> 
>>
>> [1]
>> https://lore.kernel.org/linux-mm/20251008043748.45554-1-lance.yang@linux.dev/
>>
>> Thanks a lot!
>> Lance
> 
> Cheers, Lorenzo


