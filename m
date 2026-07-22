Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D37CEC4451C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 09:03:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820B56B0096; Wed, 22 Jul 2026 05:03:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC5E6B0098; Wed, 22 Jul 2026 05:03:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627386B0099; Wed, 22 Jul 2026 05:03:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1EEEF6B0096
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 05:03:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AAF19803F2
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:03:22 +0000 (UTC)
X-FDA: 85015823844.29.1697E7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF8591A000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:03:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMUG6G9A;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784711000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LB1YvNIUdccnuadhTBME0b1wdoweU9sjcOMw+G1YPUs=;
	b=0LEji+kCWzmJ8J9zQiO+ktEhlQZYd46WvCEDcqCoBComaM8wFvbOWb1dPakP8Ld4mqUKc+
	Ab5Ml0gKYZ8I8y2IKalp8z+2RrvQfOV/CS7ZG2k8wDkwBGyWUG11Lr0aJH5IBGqIbQ0bVu
	G4q4ULE1dffda7n1+8cjp68dlclYzxk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784711000;
	b=dXIQMTSQhloq4MyokfYlPldnRLEzM0qUdL7z0eVJZO78CWEklv5dfcOjrT65POWu4mATT0
	j+3150Pi5r+9nc3o/o7J6AkAQMXGTywwpbiCIZbiJzdIBWdnZ45r6s7OvYW0OfwvXILKOn
	EHZkp/EQLlk06EjOonRMv9YaACiZYts=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OMUG6G9A;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AFE8600DA;
	Wed, 22 Jul 2026 09:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590771F000E9;
	Wed, 22 Jul 2026 09:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784711000;
	bh=LB1YvNIUdccnuadhTBME0b1wdoweU9sjcOMw+G1YPUs=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=OMUG6G9A0CrJ+g1RwqaNvBOi+c/wGmv5p1KyqABj0ZIa+CcdOwaylhu8HktFF5RSs
	 rRs8k0zSh0MFh8jxE+BdFB3RYNgagb3VwPRuTING5/alWIKHIrTjm8f/XEQoYkGTU5
	 67ZQ+9o2bdnQnmBZgTlRva1JzxjgXF20KZHEuWAHektU29YK4UokYQrPQ1odGE9zdP
	 fzSvK3+4xdSlikz+lmnSw6L1qntgHR9SXi2EDMLcroaZn7w0T8igoH216ZsRdiwUuB
	 lurDu5dPVLBt+EQTaxgRCXCPomVLoNn5sWJU3dgK1Mkakmjq9hz+BIOxKKRIIls7CW
	 3ag/bvRjhDbbA==
Message-ID: <b28c7d2f-2e4e-4760-9789-7b44f4f1c936@kernel.org>
Date: Wed, 22 Jul 2026 11:03:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 0/5] Only free healthy pages in high-order
 has_hwpoisoned folio
Content-Language: en-US
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: William Roche <william.roche@oracle.com>,
 "David Hildenbrand (Arm)" <david@kernel.org>, Jiaqi Yan
 <jiaqiyan@google.com>, linmiaohe@huawei.com, ljs@kernel.org, ziy@nvidia.com
Cc: osalvador@kernel.org, harry.yoo@oracle.com, willy@infradead.org,
 osalvador@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
 nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com,
 jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev,
 liam@infradead.org, rientjes@google.com, duenwen@google.com,
 jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 rppt@kernel.org, shuah@kernel.org, surenb@google.com, mhocko@suse.com,
 boudewijn@delta-utec.com
References: <20260705180714.3708947-1-jiaqiyan@google.com>
 <85cb7ea8-8116-4092-8310-69b61eb8602c@kernel.org>
 <ee6bcc74-0846-43f2-bcca-b1bedff74351@oracle.com>
 <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 xsFNBFZdmxYBEADsw/SiUSjB0dM+vSh95UkgcHjzEVBlby/Fg+g42O7LAEkCYXi/vvq31JTB
 KxRWDHX0R2tgpFDXHnzZcQywawu8eSq0LxzxFNYMvtB7sV1pxYwej2qx9B75qW2plBs+7+YB
 87tMFA+u+L4Z5xAzIimfLD5EKC56kJ1CsXlM8S/LHcmdD9Ctkn3trYDNnat0eoAcfPIP2OZ+
 9oe9IF/R28zmh0ifLXyJQQz5ofdj4bPf8ecEW0rhcqHfTD8k4yK0xxt3xW+6Exqp9n9bydiy
 tcSAw/TahjW6yrA+6JhSBv1v2tIm+itQc073zjSX8OFL51qQVzRFr7H2UQG33lw2QrvHRXqD
 Ot7ViKam7v0Ho9wEWiQOOZlHItOOXFphWb2yq3nzrKe45oWoSgkxKb97MVsQ+q2SYjJRBBH4
 8qKhphADYxkIP6yut/eaj9ImvRUZZRi0DTc8xfnvHGTjKbJzC2xpFcY0DQbZzuwsIZ8OPJCc
 LM4S7mT25NE5kUTG/TKQCk922vRdGVMoLA7dIQrgXnRXtyT61sg8PG4wcfOnuWf8577aXP1x
 6mzw3/jh3F+oSBHb/GcLC7mvWreJifUL2gEdssGfXhGWBo6zLS3qhgtwjay0Jl+kza1lo+Cv
 BB2T79D4WGdDuVa4eOrQ02TxqGN7G0Biz5ZLRSFzQSQwLn8fbwARAQABzSNWbGFzdGltaWwg
 QmFia2EgPHZiYWJrYUBrZXJuZWwub3JnPsLBsAQTAQoAWhYhBKlA1DSZLC6OmRA9UCJPp+fM
 gqZkBQJqFFy6GxSAAAAAAAQADm1hbnUyLDIuNSsxLjEyLDIsMgIbAwUJGtCBUAULCQgHAwUV
 CgkICwUWAgMBAAIeBQIXgAAKCRAiT6fnzIKmZJIUEADFx/tREzUImHrEwVHeSvDFmA7tJysI
 UVrlvrM09E7GIuzphzv7jYmo8n3ANpCczLEVr4G0syYQdTigaZgv3+FQDIIzhKih1IHhu1Ei
 XHlywNWKnQxxQEUNi5Mwx43wQz5XVw9F1A7gtKBKNtfogO511hAbrzagrYajyQacEJ/+sfhZ
 9Da8ltHIXD8pcYaHUfQgEusCgmEd9+KrUwrTbckFKmYq5chuE6yJ4J0EmWknL096jIE6CnzF
 FRslQ3B1UKDjxVsm1ZHfir5NeWszLkTvGFsddFaWTgh8UycESG6VQzKXjjewXu2pG7YQYRpj
 QKm1W5X2TkwWkXRBZTmfmbhxIUMh3+zf5wQ463rSmDN/8v81tdqBtAW6rH/kzg1GvkaTHXn0
 507yEHFzBksk2viAuIxxr7km8+/KARYLIdGtx30EG8cKzAUZOK6WqxtNCsXUJNrVE8CWrCaD
 icoNu7Fs1c5hmPHdSTnU48ce67449DdnO4neLSNhRiGlMHJgfJUmgrxu/hcYeOZ3haWmEQ2w
 uW1Mh01OHi8QZHCEyAbABrPs9GUgccc/4eYXX9hIgxfSkYzn8f+8NuIFPWl/0uTvjgqU29FQ
 SbzOLxHq9439Ox40G5mS5eZXRGxITYR+6TXvRGI6P/264jvflnr/pDGUttaikU+0W+1uxgKH
 cmYbEc7ATQRbGTU1AQgAn0H6UrFiWcovkh6EXVcl+SeqyO6JHOPm+e9Wu0Vw+VIUvXZVUVVQ
 La1PQDUi6j00ChlcR66g9/V0sPIcSutacPKfdKYOBvzd4rlhL8rfrdEsQw5ApZxrA8kYZVMh
 FmBRKAa6wos25moTlMKpCWzTH84+WO5+ziCTsTUZASAToz3RdunTD+vQcHj0GqNTPAHK63sf
 bAB2I0BslZkXkY1RLb/YhuA6E7JyEd2pilZOrIuBGl/5q2qSakgnAVFWFBR/DO27JuAksYnq
 +aH8vI0xGvwn75KqSk4UzAkDzWSmO4ZHuahKtQgZNsMYV+PGayRBX9b9zbldzopoLBdqHc4n
 jQARAQABwsF8BBgBCgAmAhsMFiEEqUDUNJksLo6ZED1QIk+n58yCpmQFAmfIHFQFCRYU6J8A
 CgkQIk+n58yCpmS2PA//bqN1LfcotmArgElsa+0EGZSQlYgK48pm8WAeTXTngudP9IJ4SuKY
 HR5RNjHcBeqN+Me0zxRqYzRb8nGanHEkDyf4Im8DQM8d6vbyU+FcPmG4skud4kgS1zMHnlVd
 SXfSIwKC/hKgdHG8aBV7545Lz9X6Iohea+94wneD0aw/hqF+QWewGZhWJriWAZtvEkzNjQOi
 4U9F/trLten/x7bpphDSnDMKJtITbtzATT1Dq7o7VpIUK1nCTQALMuMjKCdi8OdU/+V+R3O4
 0PXWvX8qrvqYapVbZ+9KqT74FsuB0Ya9uXwgBF2Q6cRuETZk5vqaqKxzqoQZCO8AOz/58j6O
 2RHNy/mZEN+7tJ5Tsq42zVJ4jxsT8b9YplavCMsnBgDeRWhcbYhCyttoL7nYISyWg4kQYZ/P
 wIV3OuNv2f8iKYsxNsRuClOAF82+gvqOy1/1pprFjy8uo2pkoOrb63aOP3vO5VHnRKgra6dq
 NcaZ+c6J4H+nEJGi2SkHAUJz5oBzuThvPudLvPA/SK8sKoM01IRxSihev/S/5WLazXB1PGem
 OCbvzC1IjWJJraxiDJ5IygokapUa2RP7+WBR22skQ3SSl6G107QgWKSyTOGWEaRmV53vxQLV
 jXuCmzSSasTL60zq5yGrT4/DYQVSNEUiUbG4pYekxJujNeEDkUlky0Y=
In-Reply-To: <1dea7b3c-7740-474d-b9d4-cd2baf47f181@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DF8591A000B
X-Stat-Signature: 1mhfmpg9g4qo6pngibbdwe7qhzwd9zfb
X-HE-Tag: 1784711000-345222
X-HE-Meta: U2FsdGVkX19SboJdDl0Bu2WWTobDLfoLxpYQ1gvCnmCaSlkK2ZQdzry4I8xiDE6d3BuWyiFqRcFMrFsq5pXmIuOZ1/q1Yx3FhPLyD9EWQ0W550krOkgmnZlXm+qhhB3//ZST0w62M4iVrHDHSg8F0LYg5O1bkV/V5Z2odJOm5lrUrZTRVRN54PEbTJhBC1Z/PTUEGBCl0XrUlL6KMabSFdzqyq/HsVrKEwQX85YRy82vE0BzyV4k6T9YGhy9rCAalHWZEs5ZsshjnF028BVP72ViyTVG6xbMgWioaf4lK1w8mhby/vDzIizl64mMsAjJkWbK/KJvqToqaeAP5en40Egqguv1qnKvjQ6rAvGoLRx/x+ldhLkFqY9o2Wsw4gvdxYd2shRKUt0sxk2PdoKmtjw4/WinLJ/DmbvEEr/tqWpkIEd4blZI6tT6eo7Rkbu6zfEz1voE/9RBsA/XX6O/UVOWFt5kUGL/Rod2MfpXGmiGxa+eD6vSERc60OxXI+mQr7IgXrtabrfeuP2SKbyMgRuz2O7aF2GspY/VYAZG2wB+D4nkTSd+W35f+pK88P2fKuLlyA5J7ThEwZ1VIpY/DcYnETOVIH0WYzTxCIcN+D3BGUsmOKZq28O0uPYCUH5sYPgCJNhfLQ985sYyeuUSXbng6TkQyD19Ov3UCkJCQRjxoB+528nNmlIG9vzzDeDRJP7H6di21C0xCDCPfbo+7BMVEEeduEUQYOp0PgDXfYKa3j0AIM7hI6hm57ehL7jqrkHDKWSLubcih8kEWAagffEY2h8gb3fqv3/igUstPWdxlWMRDBzrIFmj1Ov/Et7v/DP1CnKhMIf6wLYvojnOr7gj1cmyY1iOOrOZVPaKtbWxf5tOywBehSrVW8EtuGY9BAIFBtTJSs7uvFvi7mooNzqYWoMG0N+2ZNDV5Mq6TgOMqIU2BXYXHLB4TbLpRXlMTccPC3e9JYXX8sOi4C+
 ZqbiDZdV
 Y3p1u0RSl1ZhP7yKmT/Okp9zUQnQfkme7NHOFDEKZO/C3cRSpqTqDO0uJP3iEwqYE2i2SBhuk/0CxoJ86dJ5pY9/uEFMmfOL2XKxZ22pRzZ6EZObNVn5qvR7fGFsyZ9bVA/e8SDh9XYgZ/CD+iiqy8H8GqppKLPdHpryGDN2z4gfdfCk5vtMHwVq7oUAdSuHv38+MRw/GeBGjkf++ujp3MiyY018xU5OLMMcntSfpOf2BN7l+8uO/XuId+MVrltEXvt5/ImkFMXd687hFHxskohtVyeejIcswWRk8lVtC46e/dYfwkeFt9JVyf1aNi4ZP2kQnBQ9WAjg/t7zrn3Jdw8imJafZ9N77LZvIphEZGZjXm22FCHFbBPg4Rl3Xu9BsabK1mI4OFLsroCCCLNAZcOIgCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/22/26 10:27, Vlastimil Babka (SUSE) wrote:
> On 7/17/26 15:06, William Roche wrote:
>> On 7/17/26 12:18, David Hildenbrand (Arm) wrote:
>>> On 7/5/26 20:07, Jiaqi Yan wrote:
>>>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB
>>>> folio becomes non-HugeTLB and is released to buddy allocator
>>>> as a high-order folio, e.g. a folio that contains 262144 pages
>>>> if the folio was a 1G HugeTLB hugepage.
>>>>
>>>> This is problematic if the HugeTLB hugepage contained HWPoison
>>>> subpages. In that case, since buddy allocator does not check
>>>> HWPoison for non-zero-order folio, the raw HWPoison page can
>>>> be given out with its buddy page and be re-used by either
>>>> kernel or userspace.
>>> 
>>> I still don't like the complexity of this, in particular, as we have different
>>> mechanisms in the page allocator already to try handling this,
>>> 
>>> We also do have cases where we set the hwpoison bit, while a page is just about
>>> to get allocated from the buddy. So before we take it off the buddy, we might
>>> just hand out the page.
>>> 
>>> check_new_pages() seems to check for PageHWPoison() and make us not hand out
>>> such pages. It's guarded by "check_pages" but it seems to do exactly what we are
>>> looking for, now?
>> 
>> 
>> Just adding a comment about this aspect:
>> The check_new_pages() mechanism used by the __rmqueue functions should
>> filter these pages out, but this has been disabled by default in 2023
>> with:
>> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
>> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
>> 
>> So it would need to be enabled back, taking some of the performance hit.
>> (and I personally think that it has to be done)
> 
> Would it truly fix the issue, or rather there would still be a race window
> left where we check that there's no hwpoison flag in the re-enabled check,
> and only then someone sets it?
> 
> Also, can the hardware actually detect a problem with a page that nobody
> accesses? I guess if yes, it's only in some corner cases.
> 
> So I'm wary about penalizing the allocator paths again. If the page is in
> the buddy allocator, shouldn't it be isolated away as part of setting the
> hwpoison? I thought we already did that?

Looking at the code, seems soft_offline_page() tries to take a refcount
first and then sets the hwpoison flag, so it should be completely race-free
wrt the page allocator.

memory_failure() seems to start with TestSetPageHWPoison() and only then
tries to get the refcount. Wonder if it should be that way.

> So assuming we don't just leave
> hwpoison pages in the buddy and this is only about some small race window
> where it's being taken away from the buddy? Then the extra check would only
> make a small window smaller, but is it worth it?
> 
>>    A note about the related project:
>> This patch is an addition to the "mm: memfd/hugetlb: introduce 
>> memfd-based userspace MFR policy"
>> project -- recycling the impacted hugetlb pages.
>> 
>> I do think that "memfd-based userspace MFR policy" is a valuable
>> enhancement, and if the impacted large page can be more easily recycled
>> enabling check_new_pages() it's even better !
>> 
>> HTH.
> 


