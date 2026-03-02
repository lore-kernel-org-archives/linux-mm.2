Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57CD8EB362E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411646B0005; Mon,  2 Mar 2026 14:05:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C88D6B0088; Mon,  2 Mar 2026 14:05:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7816B0089; Mon,  2 Mar 2026 14:05:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B26D6B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:05:47 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C99D21C293
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:05:46 +0000 (UTC)
X-FDA: 84502052292.30.8B12248
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 11C73100019
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:05:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M+0XXKHg;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772478345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8vhf/0FWk459FLv1vW4bL+d4OiDFct30J/wSVyAWpyg=;
	b=Zh8xpQQjBc7e6vPewapjUxP6q19SNwCZE4LIMFtmd9ZFvf1NYp9kpmBhD9gEZ7Fq6qDrPF
	rN4xVcWaToFjK45LwQoKGSWkWFmqKhPWSJWWVgEpKhgBzlq6GnScXvrLa3Z1gKPQLzmja9
	effdFCZr5YAmzJXI1WPK2rIVVqUdgno=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772478345; a=rsa-sha256;
	cv=none;
	b=czvvT6kFVvx6ZMzi82/OKMCWNIJtfnYN1T5ys0hM10YKfTXpoyoAZ4JbkqaXM78syHNU35
	Uw5NOzUZCxFYlsDJXDfYR60sIPs735S+PMHYPJl1R84R4jY6R0BANdEK15HSWB56RH4gQP
	vP/OAGDzWxcBPYoflaZbq2vrfHRbL5s=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M+0XXKHg;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7001960008;
	Mon,  2 Mar 2026 19:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F41AC19423;
	Mon,  2 Mar 2026 19:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772478344;
	bh=Rs0xjjVXHNzPEJvNlyD9Y9f5tY776JO3uZf6IxhqsxM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M+0XXKHgJxkwHL/M/gTgaKnfv4ZoRocr2sM9unMSykbt8TJjqWyU6s9EOzEw6n/rd
	 lxuOQe9dK6iMMIHzoMqiEKO9hAm7D8lI5XUCENgUdURMd95vu+A3sQou5/7xw+HD9k
	 RkAfE+v8qIh/mk7JGLyaTY0lquc7gPaEAFU+s9BDU8kyFG02ZomDWhdfV3AyCQQaKl
	 itRR0slcD07SdcAn5ckkR+mAFJq52zeZ+J+EC2z7d2izdjBUDZvKY3555pzCsqaMwl
	 pp/iTIYQwhcPFVnaBOdH2OFF79m4qxo9NcSskpMmPlH3hx7gKaRQWhMJUCQJxvHVif
	 SbJD8T0CXz0xQ==
Message-ID: <99bb6e08-2c70-4b52-8fbc-1233173fc195@kernel.org>
Date: Mon, 2 Mar 2026 20:05:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm/huge_memory: Fix use of NULL folio in
 move_pages_huge_pmd()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Chris Down <chris@chrisdown.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
References: <aaBVg6nPQz-WvyzT@chrisdown.name>
 <27c260d2-796f-48a6-8b1c-751ab172d480@lucifer.local>
 <89d988b7-846f-48aa-9b69-c316f2179d61@kernel.org>
 <479c691e-1330-462d-9d7d-25cfda1f190b@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <479c691e-1330-462d-9d7d-25cfda1f190b@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11C73100019
X-Stat-Signature: 17t6i36ut1ejryrgnkmpq7xy91fwyytb
X-HE-Tag: 1772478344-704857
X-HE-Meta: U2FsdGVkX18b1kGSds698UGAuqCe0B4NOxxpNLNPDNcpg0LsFCwP+vpBdyB3oK9Rjk/z3juq+F61+y7gthSe86SGFyCeXRsnevlSPngLz6biA5rm9qMUozXch8untCZB8MXiLycaVdxjacJyHW/uZ1FMXjcdsKVPk6+2s0kArLqPxYbcuvcWM5n2IQ7pZV4cJc+cnxnlgJItTxSVnoD39w6J7NnAx/m56BT8h4qL72OJEwL6dgJEvUxoffIUIFQ6qF2fMiHqHbhIdgRPwDOnJQKpQwP5F97qrKMG0PjazB7mc4PxsqCIWbMriyO9gW26lrE0bPVfnkOVey0zZQzN3Q4PiTaZs6/b638tUZUtL6wpz+YQUMQwokQk3+pSxoiy2qS//tnuMe/jzidquXtG+U5ik+1Rq1EpL681vzLLuIDDgdxdWzm137XqrNZAHgwhMWlum7UbiMF0L0r4IMDip+Kx5NXgwizVyfAG4lsLD54dKOS2kF7T49bZwLnXoLSSXCgRq3uL3/e7O8jbbMob0jxTpWmZ1NK5EoMjeWXR5S9HkzPO/9JI0YHZMdXFc1sho1Rn5ZC20kH859LDtBU9cQ+0B34TsbVD9Jwx+3GA6ZYvetfOiZrIuO9EAG6V+Jxcwj5xL3JKt8t3WQokXwXe705M4RLMPgOtPTApLuE1dLF+SJUzbe3k5eRYgryyvRg1PBOkdqYeLur+5MCCQ9cv9xeuS1VKTrCZkTSZCnnMiKPwKmK/WW0VyRvedyT2CSCpUs4MA1+GLognVQWGzETfJCsU2nb4DCUx5d+hRnkLbs7zCwIWScKmTZ5ezfVRXug7c2A3W4XDOfI/mi6LCeBjndtxQ/qmLnGqEQEU+iNNDMO14XTjjW5Gk/1WdwiArPvJZhYkUiMMrM9PVyTwHfN1cMNNaE7kOYdMk8J+Qy9BirX2j1sxjFrms9uLkgcpriNlkvup3aqQb2dR2VY8+EJ
 xNPpw6jO
 WopRWgQAimHdUWHIW1tDNGDogNsNBwDqBLcSu09wj6D8z/2Q6djazo/923pjtTwhX3n35mFzZf+MvyiKQM2buqwwOZ+Yr5pN7gnRrzdG76m86+aiNY4+79pBrA5ONisqaCN4zt6dyloeHYO7RQXTnXv0il17sKVd0YagVlDblkESiR41Lb7Sq5PJac2vHrZ+uugucy4uXGifbphRL/ngldcOaetoBlW72LfiCCLhI//XZX1uWHysdA5tl3oTXLCqsglj2rnS+7+HV/FU7OrSMaRZeGuoxA+tOEOacdfc4GAg2FQ23m8fBkFuu/ani4Hqfm7QfakhJrC/n9e8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 18:43, Lorenzo Stoakes wrote:
> On Mon, Mar 02, 2026 at 06:35:46PM +0100, David Hildenbrand (Arm) wrote:
>>
>>>
>>> I prefer my version at [0].
>>>
>>> Cleaner to actually pull out the zero_folio into a local variable, and also we
>>> should mark it special to be consistent with other codepaths.
>>
>> I argued in v1 that we should handle it similar to an ordinary move
>> during mremap()->move_huge_pmd() and not split it over two patches.
>>
>> It's still split over two patches, which doesn't make sense.
> 
> Yes, let's not do that, I made the same comment.
> 
>>
>> https://lore.kernel.org/linux-mm/0b653dcd-842b-4360-bc1c-8fe779efbc23@kernel.org/
>>
>> I don't think there is no need to get the folio involved at all if we
>> know that we have a well-prepared PMD (zero folio, makred as special).
>>
>> The less code we have that has to deal with setting PMDs special (and
>> possible messing it up), the better.
> 
> Yup I agree, I replied accordingly. That's a more elegant thing than duplicating
> huge zero installation code.
> 
> I had just assumed that there was _some reason_ why we wouldn't want to do that
> given the original patch from Suren didn't just do that, and for the sakes of a
> backport no need to think too deep on it.
> 
> But you're right I don't think there's any reason we need to diverge from what
> mremap() would do.
> 
> That does have:
> 
> 		if (vma_has_uffd_without_event_remap(vma))
> 			pmd = clear_uffd_wp_pmd(pmd);
> 
> Though rather than unconditonally invoking clear_uffd_wp_pmd().
> 
> Is that correct?

My conclusion was that UFFDIO_MOVE will never move uffd-wp information
(just like we currently don't do for any moved PTEs).

mremap() might sometimes. But it also effectively moves all (most) uffd
VMA properties, so it has slightly different semantics.

-- 
Cheers,

David

