Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 464A4CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:08:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2A5D8E000B; Wed, 22 Oct 2025 04:08:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B5518E0002; Wed, 22 Oct 2025 04:08:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC478E000B; Wed, 22 Oct 2025 04:08:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7787F8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:08:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26171C05BD
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:08:57 +0000 (UTC)
X-FDA: 84025024314.29.F40CF69
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2D1E44000D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:08:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NRxCzfRy;
	spf=pass (imf17.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761120535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oXVMbOIfSgQPYb3Rv158n4rxfH8lc3g8IYzbeXhIsuI=;
	b=KmssBuDTAzOML9mrtk4v5z6bCB7Ez1ZvfuoE5GrKk5ZFygrsRs4rtVJfNOIHiHxc/gV47P
	cW1HZqnHPFcXpyw0k4ZNB3uxY/nBu/K7EhiDKwhzXpL4HhPKqT+2WKKojywOXkugy7cum1
	bQYo/1Hb/TxXMD7ZnQWkjMSATCzkPmc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NRxCzfRy;
	spf=pass (imf17.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761120535; a=rsa-sha256;
	cv=none;
	b=bp7L4jYvNKK022HZSOMz309Pevl+7fbnQivFeW6uYIoiwX0HBdCczaivBNg2BS7IVwm1WJ
	okaPdXki5/P+DuxtneUTlWitHcfO/BXaQ5jiS8JfnHU/qL9ujRT6TfA+mMROArtp7R1FAf
	geX2BbMLsvDrXmIkF4CaCX4r7XgNr90=
Message-ID: <ff0b2bd4-2bb0-4d0b-8a9e-4a712c419331@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761120533;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oXVMbOIfSgQPYb3Rv158n4rxfH8lc3g8IYzbeXhIsuI=;
	b=NRxCzfRyDKrdrdCaeEz+qFuxY+6mWedZ/EXzT2J6s/POmGvSXZAGbnlUgsNtnTl47Ga/OO
	b6B2Fm3BVsBLOscecU8WMG97uCmjhWlLx5E5dnGA+3LGGUHnDkLj05Aq+hQFHMClFMlTYL
	dbv3F7ZkGGuImW6ZIQJefaUyIOy6afk=
Date: Wed, 22 Oct 2025 16:08:45 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 6.1.y] selftests/mm: Move default_huge_page_size to
 vm_util.c
Content-Language: en-US
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
References: <20251022055138.375042-1-leon.hwang@linux.dev>
 <2025102230-scoured-levitator-a530@gregkh>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <2025102230-scoured-levitator-a530@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 5jwzh6hwiymurouzmty147dgj9dxmg5x
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2D1E44000D
X-HE-Tag: 1761120534-636228
X-HE-Meta: U2FsdGVkX1+NpxhUFgvTGLfAWUce2TFENJKtbD1O1/VxVbizpW++ZN93UrbJjTw1+pWFGxHHghoUzrEhJyWfBZxVhKdh5SfM0VPX4t0g9PFw6n6Bmn4p6KaStDRE1TtjSK0xI/E8Lh4OfWnkqV54qBReF0P7Kyiz/PEY5DNLhidC1QWc98fZS2W2nfDjG+YDbL1n5fEOfaJ6ssGJwIdTBRVpvt3+dOel7QB9XJK2ThLaHwtKZ6bR2PCBVN+7nnGnwHC6JvbhcAfHhiFH1KHiH54xNSHEfDKiFD327F7fFHFb36gaBx0cvqOHJ87LN15NM1AbLerx4VaoTXr4niFX4Uq1Bai+cK7xoqIj3H/KRQN7UMPbbd21KHnPCnB4CsNjZWYBCS4bmy+bJIooJJL0fqOwJ+RaMgKHp6/lHcSkX4KDrG74fVxCMPuS08nR2nreCeOO/qrg8h3agjSztSJxBjXNocdCPURdHOBL+iCxGyHTSbIi2JedMg17YD2Mxrd5ON8NINGsLG3wNACbJRoclzQLOLyQ8CPInGfGlqjw0o8mLDbm3LYIbxHw1UYZCbKg27qyck+zqN+ZhRWrTDZECLP8vnV6OxYymAdzlJX9Bppwh3O1dm8/zis1bg0L0h6ZoqUk/xYkfNsSNXmyQWpayN/gjRRZF9qF5R7M8vhorheQznGbl4rRlXhkD1qNLx/AcK7CdoysS6yADZ/w6H/R3L3tJOgCi6kDqNtNVggoBI66WNKOAafSMT+0wk0xqhD2VFiZ2GVB5r+7JiGyIkUgydyioK/dJbH4x4LUXXFS6AttYkQZgRA6nPwNhcIcppsCJniQ8ygeoa7wilcccSQreEjfThAaGL7GOGmwuphIFzWE1XJ+ShV4e2V6xyNO4lWtDPMeJVHeDTJk9rSlHbY9dWrv5d8hPVYYx1lMBIoIvRN0RpmCS18hULEk7i/hZJvRZJi/YABbnqR20fQVnjj
 Hd4nONix
 VzyKThg8LfZbHIRg2lwT4y+wS7c/JTxuOTO41R5HNJB7n7nfDbKhFQwaQlVe0TfyZfSYZkDbgCcp09HvyBFvSt3eam+VIcxC5mOybNy6ZyazT8RLZh/AsafI1VkQOSIPaBZlYU0XzT6z7ZV7hEucjubfiUGA9odkrA0atooWekjCFEMQNnqZJN6Siff9PSDbI3NO7+dhBIXGK857fYL122Zgz394cnIe07Nh5pCxKezLSjC1Eq/5Yv4+7YUTRC5j4RvZoUA9ybxeSRf6n5jeJIhnM6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/10/25 15:40, Greg KH wrote:
> On Wed, Oct 22, 2025 at 01:51:38PM +0800, Leon Hwang wrote:
>> Fix the build error:
>>
>> map_hugetlb.c: In function 'main':
>> map_hugetlb.c:79:25: warning: implicit declaration of function 'default_huge_page_size' [-Wimplicit-function-declaration]
>>    79 |         hugepage_size = default_huge_page_size();
>>       |                         ^~~~~~~~~~~~~~~~~~~~~~
>> /usr/bin/ld: /tmp/ccYOogvJ.o: in function 'main':
>> map_hugetlb.c:(.text+0x114): undefined reference to 'default_huge_page_size'
>>
>> According to the latest selftests, 'default_huge_page_size' has been
>> moved to 'vm_util.c'. So fix the error by the same way.
>>
>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
>> ---
>>  tools/testing/selftests/vm/Makefile      |  1 +
>>  tools/testing/selftests/vm/userfaultfd.c | 24 ------------------------
>>  tools/testing/selftests/vm/vm_util.c     | 21 +++++++++++++++++++++
>>  tools/testing/selftests/vm/vm_util.h     |  1 +
>>  4 files changed, 23 insertions(+), 24 deletions(-)
> 
> 
> What commit id does this fix?  And again, why not just take the original

Let me check which commit introduced the fix.

> commits instead?

I agree that taking the original commits would be preferable.

However, it might involve quite a few patches to backport, which could
be a bit of work.

If the backport turns out to be too complex, I think it’s acceptable to
leave the build error as-is for now.

Thanks,
Leon

> 
> thanks,
> 
> greg k-h


