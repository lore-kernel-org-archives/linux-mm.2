Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89D3FCCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 13:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A96FC8E0005; Wed, 22 Oct 2025 09:35:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E4E8E0002; Wed, 22 Oct 2025 09:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB418E0005; Wed, 22 Oct 2025 09:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 861D78E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 09:35:20 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1BF765B7F8
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:35:20 +0000 (UTC)
X-FDA: 84025846800.20.7133A6F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1550918000C
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 13:35:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vTfD15OZ;
	spf=pass (imf06.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761140118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vprp6Sprv0j2U+VrHGt+HSmR/LJpQhtuztUHl5jW5rg=;
	b=bXe/7H1V2CDq4fn4j+TsjaT7ubLtx734705yVfqi0EHvuaI3CDfOJrvjtwspmiyij5Jkys
	gtC4UR2jh0lBMhDwylwhc7BLjovHThXKpFX84FHF2y50MBmHLYVWUJcTdtoNGm2u6aqA4l
	GtH4wRNtzp/VvulnOceSCby1dWyaMgk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vTfD15OZ;
	spf=pass (imf06.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761140118; a=rsa-sha256;
	cv=none;
	b=sz/1ldSsKBoOd9xP3K5u9TEmgFd6mS3mq8WeAJeXI8+BvXK9ePd9F8AxBw/UCkEQZxbwW5
	px2lHQalGJ+HX1ceMnneuHm8zOBl36Rt9pyjYyzPL2YtrQlVfA1Icx6ks35+pSszz7RwEU
	MbAh7VsZvk6vLXcKQr8mrXsa9TGjx2E=
Message-ID: <70f8c6a1-cbb5-4a62-99aa-69b2f06bece2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761140115;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vprp6Sprv0j2U+VrHGt+HSmR/LJpQhtuztUHl5jW5rg=;
	b=vTfD15OZRMChVTcmQwOa7WBPKEdewiypH04vaDg6n1f79HcjPA/w9i6+/tDMH9/S32NHSS
	Yh169jpPTrGI5oBZvykiFZ0EL4Dqa1+Gg58Z6AH2dxBYjfx3syekoh2IEWNaXEvPUVkw9A
	z10CB584zYXDjOdt9GfYv+kUpZwXinQ=
Date: Wed, 22 Oct 2025 21:34:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 6.1.y] selftests/mm: Move default_huge_page_size to
 vm_util.c
To: Greg KH <greg@kroah.com>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org, david@redhat.com,
 lorenzo.stoakes@oracle.com, shuah@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lance Yang <lance.yang@linux.dev>
References: <20251022055138.375042-1-leon.hwang@linux.dev>
 <2025102230-scoured-levitator-a530@gregkh>
 <ff0b2bd4-2bb0-4d0b-8a9e-4a712c419331@linux.dev>
 <2025102210-detection-blurred-8332@gregkh>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Leon Hwang <leon.hwang@linux.dev>
In-Reply-To: <2025102210-detection-blurred-8332@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 1550918000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: nihqoxfuzrqnmsohypxaazg4p8g6ca78
X-HE-Tag: 1761140117-148807
X-HE-Meta: U2FsdGVkX19zzMiOrLr/ZaSkqz1s0hm5NQcJcZGIjdxBBKyDFi4vKkXFrlFfPE/l6KLj9DTxij2Qts6YlV6Sdft4Ayzc3Vc4IjIp6CDttr4mL63xuygWWH0LQNza2sw7VLRlWABPt5fE3lNZ7diU119fUSBHx/A4VZwRvNdUBMfgVc7Q25I2ib74KB8Xh1diJLbMq5GWfFPNp2RV8o1qgIvgj+56iawqIpBR64i8gAyoV5hKLN8VcgIu7dUXD9HFSCZAmOtHFpGX6/Mmnc84Rm+8s6enVW3iXRrAKnPxEYhH6toANItE50+NB94WVL2DheNFVOVQALv1Qkq2VxK88k+QWqiNjNdlyYJWp39tN9Eii89JAt71X6UxDNpgNVDnyVuyUeJk+TZdEHCWLlr2cngYCLl0QpaWLcndhiGB8lxOt3IB1wS0Wkz7pRnZMiYFZvQp7xhUnnFo4Si+2JO08R+5J8f3RWZirsLcepmkH17u+sl8ZYRb0AOq6GY3y+55bKP8YHtINU6Y6OaPzkNYMn1fIYumPvr/WriHtFybMzSEZqPHa3WcpftdG16VxDgnC09KwV8N4qp3A2mekh9eLgDDSIyopgnm8NSHKXjCgjQEftZrc67aCXG1N/mR3qCu3VoCMy15wkF+G313JI6twwO5TCqgLKXTXS+G+/ZE0iD+O9wboc4femiIk1vWXUDPKodYtF0umXP/EiB3wvVwRAaoOnyidOVyVyM+PNjQDbM4OAxFMahoifGHb11u7HWnuXnuNZPOjL0odi1vrbL7muyYzmPQqfDkW6/m31KmZq2ENGlYG7yPS70oriFggVFIGqbr66saHj18kBWelPDLw/lQ+i5eC11e1V2xoeF56eHDWcYbSawW9M5PLmD9+bRiC8ipMeo1E9zFAk1VyEXdWXkVuXJmNskGutwrt20s4tEbuytEIKDuWQ/0oGxHc5qQI9/U8qK+HNrOxE1baB7
 zUz6xgbU
 6L8g7nNXde0rukyu/4wu66sfMS/z4WnBiGLTEp6LwmJ0uo/y+1fSmwez+oaLNuhaq4+0jq0P0hEJXUtlJFYKPP1t2n2LkExC7GAMcmjsr/sXJCgBwstXy2YbMbOHTumLjqV0/AWZKBnkFip7tIZC7HUXM7dK4PnyIbssjczLKRhA4nWYALMKxfhsU1pwyiBhuJVZGpcftgXATqqHB3t1Bv60uoTYaF+OIor7BkX341naoZ5Eth1DyrIP6AGPCt14DbIjUs1feliBdBCeaukNx/EEzbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/22 16:20, Greg KH wrote:
> On Wed, Oct 22, 2025 at 04:08:45PM +0800, Leon Hwang wrote:
>>
>>
>> On 22/10/25 15:40, Greg KH wrote:
>>> On Wed, Oct 22, 2025 at 01:51:38PM +0800, Leon Hwang wrote:
>>>> Fix the build error:
>>>>
>>>> map_hugetlb.c: In function 'main':
>>>> map_hugetlb.c:79:25: warning: implicit declaration of function 'default_huge_page_size' [-Wimplicit-function-declaration]
>>>>    79 |         hugepage_size = default_huge_page_size();
>>>>       |                         ^~~~~~~~~~~~~~~~~~~~~~
>>>> /usr/bin/ld: /tmp/ccYOogvJ.o: in function 'main':
>>>> map_hugetlb.c:(.text+0x114): undefined reference to 'default_huge_page_size'
>>>>
>>>> According to the latest selftests, 'default_huge_page_size' has been
>>>> moved to 'vm_util.c'. So fix the error by the same way.
>>>>
>>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>>> Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
>>>> ---
>>>>  tools/testing/selftests/vm/Makefile      |  1 +
>>>>  tools/testing/selftests/vm/userfaultfd.c | 24 ------------------------
>>>>  tools/testing/selftests/vm/vm_util.c     | 21 +++++++++++++++++++++
>>>>  tools/testing/selftests/vm/vm_util.h     |  1 +
>>>>  4 files changed, 23 insertions(+), 24 deletions(-)
>>>
>>>
>>> What commit id does this fix?  And again, why not just take the original
>>
>> Let me check which commit introduced the fix.
>>
>>> commits instead?
>>
>> I agree that taking the original commits would be preferable.
>>
>> However, it might involve quite a few patches to backport, which could
>> be a bit of work.
>
> We can easily take lots of patches, don't worry about the quantity.  But
> it would be good to figure out what caused this to break here, and not
> in other branches.
>

Hi Greg,

After checking with 'git blame map_hugetlb.c', the issue was introduced
by commit a584c7734a4d (“selftests: mm: fix map_hugetlb failure on 64K
page size systems”), which corresponds to upstream commit 91b80cc5b39f.
This change appears to have caused the build error in the 6.1.y tree.

Comparing several stable trees shows the following:

- 6.0.y: not backported*
- 6.1.y: backported
- 6.2.y: not backported*
- 6.3.y: not backported*
- 6.4.y: not backported*
- 6.5.y: not backported*
- 6.6.y: backported
- 6.7.y: backported

Given this, it might be preferable to revert a584c7734a4d in 6.1.y for
consistency with the other stable trees (6.0.y, 6.2–6.5.y).

WDYT?

Thanks,
Leon

