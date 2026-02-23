Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FF74E98DEA
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 05:48:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C423C6B0088; Mon, 23 Feb 2026 00:48:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF05C6B0089; Mon, 23 Feb 2026 00:48:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2316B008A; Mon, 23 Feb 2026 00:48:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1C86B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 00:48:57 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0EF311B6760
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 05:48:57 +0000 (UTC)
X-FDA: 84474642714.12.0AC14F0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1839D1A0006
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 05:48:53 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771825734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l5xUgcMpGHoie23ripczefgJb2Wz/2ocYQjJUeDPxiA=;
	b=U8tw5P9jZkRlYpp4C25Z7yN1SSfB+Q6dH459xkExfmzMzIWXsy2PJkWUUh24U0DzoVN7jo
	w1rYACjnPm2CGXkbdHNihToX1kAtgznM41tijr2yczS0wF/gWmlkEbfhJ96c3+1rno+R8R
	YGzLt5zKTj/adAMGP2uxwlJjUSH7+eI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771825734; a=rsa-sha256;
	cv=none;
	b=eG4mnDddNcIGJbx1Q3dGlrmcM1HXJ6bPeLrAUBUEuzi1FgVQUjy4U5MOj3zy1BKtRZ3JUz
	sm3U80XYtTSz8Zg67zV86da8bUd82P4nFZj/Id+3Ww6sKYrs3tY5u9iYLjb2deIMTIB2GB
	WzgZ3LvrjY/7HvhSmKmNk7CYhCGfC2k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 91A33339;
	Sun, 22 Feb 2026 21:48:46 -0800 (PST)
Received: from [10.163.170.234] (unknown [10.163.170.234])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6D1F73F7BD;
	Sun, 22 Feb 2026 21:48:49 -0800 (PST)
Message-ID: <f486ff76-7c98-4b93-985b-69cced5ba00c@arm.com>
Date: Mon, 23 Feb 2026 11:18:46 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: allow __GFP_RETRY_MAYFAIL in vmalloc
To: SeongJae Park <sj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Vishal Moola <vishal.moola@gmail.com>,
 Christoph Hellwig <hch@infradead.org>,
 "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, zkabelac@redhat.com,
 Matthew Sakai <msakai@redhat.com>, linux-mm@kvack.org,
 dm-devel@lists.linux.dev
References: <20260221011952.59323-1-sj@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260221011952.59323-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1839D1A0006
X-Rspamd-Server: rspam02
X-Stat-Signature: sisb7fyodpc839xmmeqfuz4ncz5uub18
X-HE-Tag: 1771825733-374014
X-HE-Meta: U2FsdGVkX18SfZ/ZBRTEOZ9GA5ODSCCdbFqKx/+MOrThk/xNi5swNsltz2f2SWMWu9+jaA97t5je+7pCfwKBrIgtdVPqFlCJQngRuuyp3uerVbRVBb2JDJYOah2dFeq4mS4+4QYGMCMt+mPQHucKRIx9ssmNMgT4eOSTr0PmAialRzMSuhp7dN5ZgKIBXHoCVMLmgt3RwlzdyBU+El+ZocYadvnmqzdqd3dSH9w9JPTcQ6ogguGiwbD7U3b67wEF+w2/fHmSXR0HDFa9wwM3wHMyeyIYlw6emd6OW7/im2/BNQgHe10lircTU0RY6mSZQLVqyGPgOu4FPkpodmRPZoEyzFOudTIbi0OaYfamWCGBAwCszmhbKhRFy1Knrpq80LYdCv/d3c1mfIIuZItjiiST8VL/efJ0/RWDv8Hdu9VIjTXL6mmxhhjR+TLOdfAkSJ3g53ZwY1W/AFrAdyq4kqFBsf/2CZzgXte6Z3D505p+p1pYTNgURTUhs/RljfXWyx9jKqVsPU2s8vFNhasnV93H+XjnGFtsEOqVhuZThTq9B+9l71xPgDwFNmpzQ5Dhjx+NDm6z4wV39pDTO0Wxbao/b/iZrdjneXarxvsy3JMSAb9w6AG6TEXolC1RF5H9mQh700nQjUyKSNZpSN93sbAVOXzmyX36oKTrFKi5vGcvXlTjPcEG1JN8LN6LQJREYtc0dQr4ykWPVOwEtOFe6qu6nkZ09BbnlZC6D/mRHA5SMCMmppSxZZN9YzmTUJZXVncj9KT2q8WEV0zdic3RD3QyPN4A+rIJKXSSOqcvia7nnHnDQ6HjZ6ICtCNbcpKSzo41A3t/oXyyplMvmVi66HvgHvsZ6/yqrP38/Y+wT+CVhFKJeJNMdQi7RvgBhrKn+UFaSsKhV4KnhVDPnrV5gP2jPchDYgLpSPb4ax6EuRj/CtBVPHj4USRWiKsaY2q7W2C99uJL03zKCR/9Ofy
 GaWp33gD
 WmyHYNRKiDfjD5X4S4VGfr4dQnfhY3JGj5G+6eD7U2XW13lONhnWR+HdbXP+/yFd0ivR5xTWJSL4GFsFucZYXW8nm7Ima/IdKs83I25sn3qUJab/rCv+D3E7TsJRCFWaWvNmpQkjW9+JnBhfAFq4zZJm+OsiSB+zW+GuGir+6fpAj56YRu3KERepKGQAjaKHXGHCQ/NXPTXj1iYs8rMLT+zV10Qy76Ymn6S+XloEE7sExgCFE4MTrEXxXxH4HdgdcWokDoVO70NLJ6ihQCh4NtdSwVhPyjhxLTF4sENah7x6hqyGHOy8F+GgYi3/v1kqkfjl/aQWBymPzJ7k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 21/02/26 6:49 AM, SeongJae Park wrote:
> On Thu, 12 Feb 2026 17:33:30 +0100 (CET) Mikulas Patocka <mpatocka@redhat.com> wrote:
> 
>> The commit 07003531e03c8 ("mm/vmalloc: warn on invalid vmalloc gfp
>> flags") breaks the device mapper VDO target. The VDO target calls vmalloc
>> with __GFP_RETRY_MAYFAIL and this flag is not in the mask of allowed
>> flags.
>>
>> There is no reason why vmalloc couldn't support __GFP_RETRY_MAYFAIL, so 
>> let's add this flag to GFP_VMALLOC_SUPPORTED.
>>
>> Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> Reported-by: Zdenek Kabelac <zkabelac@redhat.com>
>> Fixes: 07003531e03c ("mm/vmalloc: warn on invalid vmalloc gfp flags")
>> Cc: stable@vger.kernel.org	# v6.19
> 
> Acked-by: SeongJae Park <sj@kernel.org>
> 
>>
>> ---
>>  mm/vmalloc.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> Index: linux-2.6/mm/vmalloc.c
>> ===================================================================
>> --- linux-2.6.orig/mm/vmalloc.c
>> +++ linux-2.6/mm/vmalloc.c
>> @@ -3928,6 +3928,7 @@ fail:
>>   */
>>  #define GFP_VMALLOC_SUPPORTED (GFP_KERNEL | GFP_ATOMIC | GFP_NOWAIT |\
>>  				__GFP_NOFAIL |  __GFP_ZERO | __GFP_NORETRY |\
>> +				__GFP_RETRY_MAYFAIL |\
>>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>>  				GFP_USER | __GFP_NOLOCKDEP)
> 
> By the way, I think this list might better to be alphabetically sorted in

Agreed.

> future.  Obviously just a trivial and random thought that never required for
> this patch.

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

