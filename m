Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44277D711D6
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:29:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70906B0088; Fri, 19 Dec 2025 03:29:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1E1A6B0089; Fri, 19 Dec 2025 03:29:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FFFF6B008A; Fri, 19 Dec 2025 03:29:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7E4406B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:29:15 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 289166021B
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:29:15 +0000 (UTC)
X-FDA: 84235545870.27.9BC03BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5BD3D40008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:29:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jWk8hALG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766132953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wRkE8opFJncv9+WBM2JtBve0txbJfMflTt+dw10GSOs=;
	b=sZ+1KCDOX1mIEsT0KNx5yxWzDwm8q57d7oyyAG28q19GhGEWZMciuUbJyj2DxHZQ+GaNd0
	6iU5MzL5dyY1hcatkFXrZlkijoywcQYn776/kN1X5ucKLboE3aUK8Um5NXoXYauZzptFfu
	sSkrMyqun1g5cuP3CDsuresq1s2fU6k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766132953; a=rsa-sha256;
	cv=none;
	b=P8Azv6nXf/9Kj90uB1oC3X4GzC6FoHe+B0SnCLAhLXx1/aMiIcyEjZieBXtlWHIq/DA1/W
	dUL8lI8pLXN0MOtt8B0p51oUSkFU8pZPMjT2hs/OKsJ1BZxXl00WsGGRqylGriWDtgWe/k
	KfNlnhRsw+YvPQRqrDcB3Hsd+HMS8pg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jWk8hALG;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F52E43C65;
	Fri, 19 Dec 2025 08:29:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD61DC116B1;
	Fri, 19 Dec 2025 08:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766132952;
	bh=UCFnBOrzhV3jWI43ElU9t2h6igr0WlVvCIX4xGYLDk0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jWk8hALGXyTDQTBOou4ixavX7CnsUIfth0+Lxjb9cqp3NQS5XoFaSEdUdUUI+f928
	 jty2G8rmU7Gk/BheKCFqD9Y2FzPRO1gtYzRCpdzGkQXIilkAMjttsvH6lJ2zgEypej
	 HaNcmYcLBoIxorXioJAgzgi2cVrlTLBJwzn0SFdSdFWPLklS7V7IbR0R+BxwEnScWT
	 UDDL+O12Zz9/L2S6Pp283WNMS6r2C3wwlFnSfs/Y0hhmBVkNgr6FpGP5Ndo51jWUOd
	 tqdy2GTXFYZr9jJINvQ81sVj6hCr6k9c3uf0AYlxm0bXd/uz0KlJzLGCbhDCkVDr5W
	 WP5UqAVOuYtdw==
Message-ID: <a3ca6293-8f85-4489-a48e-eb8d0d3792c5@kernel.org>
Date: Fri, 19 Dec 2025 09:29:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] selftests/mm: fix faulting-in code in pagemap_ioctl
 test
To: Kevin Brodsky <kevin.brodsky@arm.com>, Ryan Roberts
 <ryan.roberts@arm.com>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Usama Anjum <Usama.Anjum@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-4-kevin.brodsky@arm.com>
 <37210500-6f6e-46ac-ac2f-ac996308590d@arm.com>
 <6aa47cdb-d2e7-4977-929b-7019b6f991c1@kernel.org>
 <0575bcf6-c1a3-4ebf-a199-3113758fbdc5@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <0575bcf6-c1a3-4ebf-a199-3113758fbdc5@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: eo4hhm4q65bmn1o8ir8ustznxa95da7k
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5BD3D40008
X-Rspam-User: 
X-HE-Tag: 1766132953-347415
X-HE-Meta: U2FsdGVkX18OLy3nfSwlFwGSv7Hwz/YslvjBdH+WfsZWuunSe9O6E14f5QbSHl7CjWk1utKWA0ud4v3ZApMWaC1tpUlDlUZx1DO7482xyxZ5b+O8eDVx3UlmWVXhQ3fOP8L0l3xoLcCDdeQdgqEB3xr8gtr2BZ+JIaumxsTGjJumikGfpzrGBdlqRiVIv5ICBDfCEs9OGDZkhXt9EWNFRvwfs4IiYgqd878plTwnTw+oh/e8kyPRI2YhfZ+VpfSA+n7oOvr0zxfR2/p51334Ti0i5wWtalLd1++CzmfDppSWul7j4v7kWJRrmyYgctVCUcrN/Q3lU4JsJ9z4zTmaZUQbbQvCra7EaII2hwh1v9a18EqP1isWCOA5lq+kd9Nr7XbV/ocdH3NOo5gBVGeKk8xiWyut0fRmRxrwXtiDCD/pggLNNEQiJWgOhSxsFVx9AuaEWAvDfh1BWVNKd3JBxzVfkyPZKHq6oY/jnPZEyIuY37dppzOGlpsNkvs1Ov28V5NKkw6jeu+0/qNxBSxl6FdeKhrdKjB7+/GFUpnI6pYVXlPW+GiQX2RTl6KUNENBEUmBIdn/bi2Qic94oWhN0b2sawh8E9HB7fFKvhJ5obqn4k2IdkkgIkYIDW+SCIOsfjWbYnJ5gMRYsQ3ppILOtF7sbH+VcJKSc3fj4VZ5JElbwBfMeqRbBhpWGELzlJcpsaQ3vEdz3AvQ3SCFvraiHQPeIYEGuA0bRNLbA70lDyRKU6n8MTGqP6qMLPQAL/V8elZbDdlInslQndJFeYzfFCsYGJfShl8Wh+NgIE08+ZsVDm1TTFZWqZtXtkvEDupfaV05J7JDYS3RAhaT8isQtP3SpFsfQtJDWvu8JiQ9Pt9QinnkIN8OQh94fYkAmDDMLXArAtB5TdIjReJDrgN10NBncVrfZODm80ParKbi7Z67puXI+XU/9s/5siQqbXZjTr47qFedIWANU32JNbb
 196s7I0G
 HkCy4G7TvXbYavGXFUP8SBbZeUPSbzgjK4yranpWMOY4vnyTmH/m7A5RSq1KS1evCERRHwDE3lUPVRTdKenwACkQTNi9ldUN3YJLneU6IQg58/zXFfiuw7rRjGOMR6Gg3wKwEx3LTmeVg+vzaqp1/99+jkQLwbHFZ3k8N5MTxxVyolUGyjAchjyY7SrCzQZx3LBM055yz9GBci5+LjV5E273ymXUoxiW5IWDHNgiqUqg3X/GI8Ic+PuhowptfAr9It2dGT5/nDy1zcjNy1ny101Y+JFaq/OiFISyjVLNPOo63gUoc3RfqrSx6BvDJKYPbVs1sDNFs2b/6Kp0PRaYuT6Os8twJHCLibgsHgKJnMa6elHalZMl3BeYPP7LLiX/Vb1S5BDwg93+d+oI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 14:18, Kevin Brodsky wrote:
> On 18/12/2025 09:05, David Hildenbrand (Red Hat) wrote:
>> On 12/16/25 15:56, Ryan Roberts wrote:
>>> On 16/12/2025 14:26, Kevin Brodsky wrote:
>>>> One of the pagemap_ioctl tests attempts to fault in pages by
>>>> memcpy()'ing them to an unused buffer. This probably worked
>>>> originally, but since commit 46036188ea1f ("selftests/mm: build with
>>>> -O2") the compiler is free to optimise away that unused buffer and
>>>> the memcpy() with it. As a result there might not be any resident
>>>> page in the mapping and the test may fail.
>>>>
>>>> We don't need to copy all that memory anyway. Just fault in every
>>>> page by forcing the compiler to read the first byte.
>>>>
>>>> Cc: Usama Anjum <Usama.Anjum@arm.com>
>>>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>>>> ---
>>>>    tools/testing/selftests/mm/pagemap_ioctl.c | 6 +++---
>>>>    1 file changed, 3 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c
>>>> b/tools/testing/selftests/mm/pagemap_ioctl.c
>>>> index 2cb5441f29c7..67a7a3705604 100644
>>>> --- a/tools/testing/selftests/mm/pagemap_ioctl.c
>>>> +++ b/tools/testing/selftests/mm/pagemap_ioctl.c
>>>> @@ -1056,7 +1056,6 @@ int sanity_tests(void)
>>>>        struct page_region *vec;
>>>>        char *mem, *fmem;
>>>>        struct stat sbuf;
>>>> -    char *tmp_buf;
>>>>          /* 1. wrong operation */
>>>>        mem_size = 10 * page_size;
>>>> @@ -1167,8 +1166,9 @@ int sanity_tests(void)
>>>>        if (fmem == MAP_FAILED)
>>>>            ksft_exit_fail_msg("error nomem %d %s\n", errno,
>>>> strerror(errno));
>>>>    -    tmp_buf = malloc(sbuf.st_size);
>>>> -    memcpy(tmp_buf, fmem, sbuf.st_size);
>>>> +    /* Fault in every page by reading the first byte */
>>>> +    for (i = 0; i < sbuf.st_size; i += page_size)
>>>> +        (void)*(volatile char *)(fmem + i);
>>>
>>> We have FORCE_READ() in vm_util.h for this. Perhaps that would be
>>> better?
>>
>> Agreed, and if we have multiple patterns where we want to force_read a
>> bigger area, maybe we should provide a helper for that?
> 
> I've found just a couple of cases where FORCE_READ() is used for a
> larger area (in hugetlb-madvise.c and split_huge_page_test.c). The step
> size isn't the same in any of these cases though. We could have
> something like fault_area(addr, size, step) but maybe the loops are
> clear enough already?

Note that even for hugtlb we can read page-per-page, no need to 
hugetlb-page-per-hugetlb-page. Not sure if the performance change would 
make any real performance difference in this testing code.

-- 
Cheers

David

