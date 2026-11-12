Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CDA66070783
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jqYvau3y
Received: by kanga.kvack.org (Postfix)
	id 5AB806B05C7; Thu, 12 Nov 2026 03:37:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5828C6B05C8; Thu, 12 Nov 2026 03:37:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498046B05C9; Thu, 12 Nov 2026 03:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0DB6B05C7
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:37:07 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ACC941A0517
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:37:06 +0000 (UTC)
X-FDA: 85425812052.30.5169D3F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0297FC0007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:37:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqYvau3y;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794472625;
	b=lxpRkSTSPMDrJcois5UxxVeCGctO+Mm2xKCGRkO5Hvhd3qMOxAu3+GvCjlUAALoT2VMIKR
	Vo4j+aJ+QyL0qGmtHG6dV5apzvsDNvrx5b9BzDN4S7lZv8F7EdMWL0WKWaZj0AfP1pCV59
	KJAEWwBbYzkr+dD8wI18QvMuXSy7pyk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jqYvau3y;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794472625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/yEdPtHpJ1NtcQC60gYn0MUtGO5PcvthVLd0v02et/I=;
	b=5yYxbRboMZOB+cfiPH0JxkSAo6sclrIXeJEK8pPaZLNUydVIrrbNSS3Aw+i/cSqTHt8Igs
	lr6nhL6qAKuABgXIRbK9IDHjwe6O1YsAqjhFg/MDIzG4a+zVQSb+3nO2fsW116pOY99IEk
	32XBSHx/TxO2bm0h5LX8JE484z6O7HA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CBB6611FD;
	Thu, 12 Nov 2026 08:37:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40DE1F00A13;
	Thu, 12 Nov 2026 08:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794472624;
	bh=/yEdPtHpJ1NtcQC60gYn0MUtGO5PcvthVLd0v02et/I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jqYvau3yOeSxB1kD7U3L2EBRpoOqvpE7k1VJV+6JuPIQNEtd9OKlj0k96CfLYRUmw
	 k975HhQUdKJzCdMO/SYXH4ORvvUC7VKbCqcZlbKFVngVPOjniEojfCvoswjg2X1f4W
	 AkWZsppHZgrlkxPj0Kkv2cEHcejVuJic610j9dC1GvTynDFVs3YGuqQ9pBMcWRBQID
	 J9dtYWYeCi5vTSp+FKk5fEFFxs3T+WPl/iHlti8oBLV/UWpzvy3B9KXgYxZevgQ52X
	 CalQuYCSTcxyR0EOiUzmQ/G2zhpd5OstOQgaL5U9Z5j5Dsr313YLlfpPJ3IFF/Kw6I
	 ig5dG3E0hkQsQ==
Message-ID: <a2ddd71c-7796-40a8-93df-f0c51aa65ca4@kernel.org>
Date: Thu, 12 Nov 2026 09:36:57 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: Frank van der Linden <fvdl@google.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, akpm@linux-foundation.org,
 azpijr@gmail.com, lance.yang@linux.dev, Qi Zheng <qi.zheng@linux.dev>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org
References: <cover.1794046188.git.zhengqi.arch@bytedance.com>
 <586d6c53ab7e4c64d6e89ad3cf0cf7e07dabbfaf.1794046188.git.zhengqi.arch@bytedance.com>
 <7abb3aa1-385a-422f-86bd-7aac9661c4d8@kernel.org>
 <423c9b28-ecf2-4fab-817d-2fb326690c73@linux.dev>
 <3a1a3bb5-0b01-4f20-aa0e-74a952544b8c@kernel.org>
 <5f68ffba-9f56-4e31-9e7c-9d110f552efc@bytedance.com>
 <CAPTztWb0XbjCxtihyp=Tx16Z_kjF+M8sa7YcUjvFv0WcS83MAg@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAPTztWb0XbjCxtihyp=Tx16Z_kjF+M8sa7YcUjvFv0WcS83MAg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0297FC0007
X-Stat-Signature: 3sqxdggd1e36yc6w4n39z8fkribgypob
X-Rspam-User: 
X-HE-Tag: 1794472624-961323
X-HE-Meta: U2FsdGVkX1/NC574Yisu6jCHGHerqX9i5XMOBTchZnb0q/YICgVEpcpz14e6J05nNNGQOOUHaZ+NGG9shEX6ZqBh/+2kk387iCvx3mcWgUrTpD4F6FVW0t6fp6WZTtyn5+nJ+tTitdtuxHUBTe4S9iLG0rdMYJI30/NxcLwViRlxw5Ec6Or4BcrnllJlYuZ25s0E+DhbRYz+68PLld9wAAzlHU2/GsooxXoTsj0Styd7tir2kaaoaziWpv6PcV79E3fO+agj5zxkZfowI7ZC+lolEv34j7fn9ntgRs/wv1MlCgcDjrve1GEyudfKW5NeeMhi1EyPMBr+y2BIB/cYjgsAWcPNJScSTgZZDPRbASszUsYCAzGG9m9M94H5HS4C1E7w3z27VApaJO0W7T6jzL3UPdp7GdXpxPboNruB1H9HkEC39pbIaF+BSXstoPDCxhh+vw2pTwm+tlv+Iuhg6XMgu2GbVNcG8PZBjMSVUn2rVT64w0tTqtvbaB/e1IOJ/2A8RTaPxDW/XoV4aACRuTR+D9f5cO3n2UJ0kfDNlFYb4ZP0/7x/696imY44C+F5a5CSPi3j33K16okX8Y3U0G9kIaaxZICJtyR2sRPKoS5fQRg0IsQLVoTxim0rSPblykjzKueWGThRpwyhjkLaou35N+620PApOhFWLqap7fJyv59ix/yXP83jOk5bI1rOwGuIv5OolvfwdmsFUbJoZOIO9a/apHBCPMH1KMgqNRCDHnZIw2d4f+l6b+wyicwaBm+/tfMaW2Mpi0f0IY/vNCFIINYtEXonpsd85t/jsx8Te63qHkpLnZOrkLi6l03H/NjVkrjWaFOYEl5n49ArgkvrGfjtkMykgnYB9bLRDiu8SugPUW0tCQbJTcle+aIGZPmX04qSZuvkmlil1HEdsq4CKbTZv1ySwFuL91aK3mFj59mlnwyVPfT0tUEv9Swp6sKGnQGc2tiwl9mcRDj
 om9dOGa0
 qNPYoHn3wlZv5an/tBnIUg4WbpZy2y15cKbY4hLOyig8mE1FsqRiwj8Acu+/9hYogEFEP/P5FRrFAGTmnbV63hVn2v0cC3QlOAyav4Gj+XmuD9dJGUsQCxfF3nv7Dxg3s/mubIXc8Dk/bLPMQnLj37Em08wqoWfBBsA+pvUZ9AF16oVDYbguO4hN5nROL5S/T0Pe54u0pjmb/2ynmGgjWS8F0GqPAXCykonomk0UdX8KMQpJQjMKCSQeN7JSUAZnhNQTlKOLcQpP1NZzRdnLzywP1T1MYHW1Ujn1pA7m8V33HMdHlkZnWfh7mag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 23:26, Frank van der Linden wrote:
> On Wed, Nov 11, 2026 at 2:27 AM Qi Zheng <zhengqi.arch@bytedance.com> wrote:
>>
>> Hi David,
>>
>> On 11/11/26 3:43 PM, David Hildenbrand (Arm) wrote:
>>>
>>> You resent your series way too fast.
>>
>> Got it.
>>
>>>
>>> Now we have discussions in to threads, congratulations ;)
>>>
>>>
>>> Why can't that be resolved differently? What is the dependency?
>>
>> The dependency is that the new check wants to use
>> `folio_test_hugetlb_cma()`, which is a HugeTLB-specific inline helper
>> from `include/linux/hugetlb.h`.
>>
>> `folio_is_longterm_pinnable()` currently lives in `include/linux/mm.h`,
>> while `include/linux/hugetlb.h` already includes `linux/mm.h`. So I
>> can't simply use `folio_test_hugetlb_cma()` from `mm.h`
>>
>>>
>>
>> The more accurate code path is as follows.
>>
>> Assuming the 2M buddy allocation is successful, page P is borrowed from
>> the 1G CMA area.
>>
>> Now, proceed to request a new 1G huge page:
>>
>> only_alloc_fresh_hugetlb_folio
>> --> alloc_gigantic_frozen_folio
>>      --> hugetlb_cma_alloc_frozen_folio
>>          --> cma_range_alloc
>>                  /* set bitmap!! */
>>              --> bitmap_set(cmr->bitmap, bitmap_no, bitmap_count);
>>
>>                  <time A>
>>
>>                  /* may fail */
>>                  alloc_contig_frozen_range
>>
>>          /* set HPG_cma!! */
>>          folio_set_hugetlb_cma(folio);
>>
>> At time A, for page P, a bitmap was set, but HPG_cma was not set.
>>
>> If a concurrent FOLL_LONGTERM pin uses the bitmap alone to determine
>> ownership, it could incorrectly allow P to remain pinned. If
>> alloc_contig_frozen_range() fails, cma_range_alloc() clears the bitmap
>> bits, while the long-term pin on P remains.
>>
>> HPG_cma is set only after explicit CMA allocation succeeds. It records
>> the folio's own CMA ownership, whereas a set bitmap bit can represent
>> another allocation's in-flight reservation. Therefore, the bitmap
>> alone cannot replace HPG_cma in this check.
>>
>>>
>>> Or simply two bitmaps? "trying allocation - allocated"
>>
>> As a fix, perhaps this is a bit too complex? :(
>>
>> Alternatively, we could adjust the timing for setting the bitmap, though
>> this might introduce new concurrency issues.
>>
>> Thanks,
>> Qi
> 
> Yeah, ideally there would be a way to identify folios allocated
> through cma_alloc. But that would probably require.. dare I say.. a
> page flag. Trying to check bitmaps does seem too complex.

Why?

You know it's a CMA region. And CMA regions are limited and static. Bitmap check
is cheap.

Pageflag likely won't happen ...

In general, please, it's ok to send some hugetlb hacks (that make me angry) as a
quick fix, but please do think about a proper way of handling that.

-- 
Cheers,

David

