Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1648606A336
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JGMdQPeY
Received: by kanga.kvack.org (Postfix)
	id EE8EC6B05B5; Fri,  6 Nov 2026 17:42:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC1B26B05B6; Fri,  6 Nov 2026 17:42:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5936B05B7; Fri,  6 Nov 2026 17:42:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD1EC6B05B5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:42:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A98016023A
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:42:43 +0000 (UTC)
X-FDA: 85406170206.07.AD22D2A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5E7C9100005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:42:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JGMdQPeY;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794004961;
	b=VW17pSvUpK/wvg4cwmNNeXI6tBh2sdBaS3VknyXu+C5vrxVhS3FV3zqDVZCDtezGBy9gBQ
	jzSo4SZp+ozv6aNuIasz+ArWZONdT9VHarypOjhh8MJNH0BrE/Y++FNLBfrdnMm4gHAq5u
	E8rkvtn63MDwHJYS4lHuTEm67pG3K9k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JGMdQPeY;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794004961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlbEJ/mAQ5AEryfKs406khz/jZEGvS7oBKVbDoRy+Xo=;
	b=1T+tFnl8fnGau59pCbT4Q7aV6ARt9fSKeWKnupes0fEg2d/kdB1zmZFp46TshR9Iz7cwon
	bz1y4/RCPYJRlOuWtMc9uams/Xy5mjimXIZVBnUpj9AzUtI0XbB1HGaze0vWpM2iV98zss
	fng4zH271dPhVai/OLWzABc+8eQjudg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95E5943F9F;
	Fri,  6 Nov 2026 22:42:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFDB1F008A1;
	Fri,  6 Nov 2026 22:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794004960;
	bh=JlbEJ/mAQ5AEryfKs406khz/jZEGvS7oBKVbDoRy+Xo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JGMdQPeYWvZkx75geWZtgyTHasxq12eL2mvw130fUowkgQt5u/0QMWgjSwtPkrv9x
	 nAmjmlLC7P72HaNBsSW594Z2aGntB2xZRIbb1q2R8ZtMH3EYlK1ql87XNKKuF6C8g9
	 YgeHFDQ0cWMuaQUVjBvcVGKQAJpu6mwtlDJ0sGswiWtLGmASIR6/6q4X0dEpOAE2eF
	 iNsdg9qv5vVMyNNORv0rIQQxNkFL+m6shCr1VUsNJuYFfxAv45qwMOjzvRCmv+QD+r
	 SbMFCEmReiNw5AyNldI87KX38Qhwj6dZrU+wBDI8Sqtq/2STIRj0mAqTnzOzfGK3Zx
	 OkxQrVY8oZSWw==
Message-ID: <6b8d6030-efe7-47d2-8aa2-3f8fd77ce95c@kernel.org>
Date: Fri, 6 Nov 2026 22:57:19 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm: limit pagecache folio refcount when splicing into
 pipes
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 willy@infradead.org, jack@suse.cz, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, nico.pache@linux.dev, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 peterx@redhat.com, hannes@cmpxchg.org, songliubraving@fb.com,
 riel@surriel.com, hughd@google.com, will@kernel.org,
 aneesh.kumar@kernel.org, npiggin@gmail.com, peterz@infradead.org,
 jgg@ziepe.ca, kevin.tian@intel.com, joro@8bytes.org, robin.murphy@arm.com,
 steven.sistare@oracle.com, jhubbard@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, iommu@lists.linux.dev, stable@vger.kernel.org
References: <20261105-refcount_overflow_stable-v1-2-70b9c655da3e@kernel.org>
 <20261106100320.77084-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261106100320.77084-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 69jxpeeo7kmyubqyzip14w7m1au7b7di
X-Rspamd-Queue-Id: 5E7C9100005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794004961-731006
X-HE-Meta: U2FsdGVkX19mKLbB8Hg7JOjPPVkNji30UG3e0564rhYidJlx+aWn3tcOkkhmjto1KN3KOfKUUM3BuDPZfXZotRvVdk8N/kiihOylJ66D8fETLLHERTtMOD1C6UFSl//Yd3Dzzu3A5lyDjJK9oq2xXLZuZUqqct4Ru4Ctdv2Lm8IP9srGZJ30ca5TPatqH9vW6OWUwFgIbII9L7Tc0vw6Hdl+W/YewIx7Ttw6CDKF5ejkonmK9RouHNClpYm46Vd/d1IwL+QMfQ276czloy/45OZpVcVQtLmq7NJcGYNTiFCVpuTOevFzZo84E1pVZ1l9JcXbOf+9EtJ/ca5kW6hoLAi7/MrfwnyLd1HOkK523o83IqEwMlL/9DcD8Y9nlCYhbXhmD0VQi4AcwTTqYn8CnWLtStHwzenpwwQ23VgbcRwZILsmnnkk9+HqGq1zPho4W3ge8Tjk7h/GeJVIkSsCd2zcGSvEsY1o1yw8ORKgxJWZIzR8MuCn+V3PIzYBkMZxoPETpMtFdgql72nzqXO6S+wNOUyCbqxt4muOcmQgTp9nI2M37rt3+iMjtUsIATYxMvQjxGYovWig/ZG5ITKLV1nAtGRpUhZp96qr0q3Ik0Z1iEvuN5EbshZfcDoK7wLIoWXxKMQkbsMmS11Dr7F3gd9eJPH9gYyzbXUqlERprtcJyobNrfB/xyjWF8OUtZRIqLTni55LpoGTORklBK5EHdFGB1fFDGHoGvxL/fqz9kaAdsSPBWHJHMZ3N4zOC2Z6tPX/0sk/AFpjaAMVlh2QxuKAOa6OVQ4UjjLXfumMs8p1GVZYrql1WCmbUQBUnPKOqGuxSdfIpDFZUjEOYyek4KvntdOmhKinzfJGrt7pZDL84ij20G2agmrYWUTinFpMzIR+UI1fKF8iyBD4Y6ogjMWFix80RUdwFidKSq9dK1z+jc2SZ6Lpgg6K4d9tE02//wF31WsxD/z+gSm09s3
 cPg2yVUI
 70QTBytauycZbVYXk7FovMBdzKg/VVQYbpSdMWFi6sMycrIDbQRi6jFk5MQJoRCiMFCz/pDJFO9AnL1BIg4kdzkSTCFvFHY1RntPvXsi4lWkzovB3SF+UpTGGcO7AIdVEQnv5MQOeygOa0aPQNsHwUfI4mcqxOoq64SL4k/darWPx804ZrZoQ6epG/L8xhJuAW8gD2Ucj+MznC4WJ6WCBC4MCoxaAHqcAXhCX4OjoV3j9tdDHbzyAwu0FHTz7QStkL7FHdp+MhgL3FWGSPGcoPUHrMI6QNtvyVXt34yGaPYpHWQqr82TEen0DkEW2RKwjBfU1UJ7zdJZ//LkMY6zW5pvHDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 11:03, Lance Yang wrote:
> 
> On Thu, Nov 05, 2026 at 02:10:11PM +0100, David Hildenbrand (Arm) wrote:
>> Similar to mapping pagecache folios into page tables, let's reject splicing
>> folios into a pipe if the refcount is at it's limit, similar to how we
>> handle it during GUP.
>>
>> This will prevent more cases of possible folio refcount overflows with
>> large pagecache folios.
>>
>> Let's keep it simple and check in the two callers of
>> splice_folio_into_pipe().
>>
>> Also check in try_get_page() to cover pipe-buffer duplication by tee()
>> and partial pipe-to-pipe splicing.
> 
> What about fuse_ref_folio()? Buffered FUSE_WRITE requests can carry
> pagecache folios into a pipe through /dev/fuse without going through
> splice_folio_into_pipe() or try_get_page() ...

Of course it has its own handling ... :)

Thanks! I was hoping the number of folio references would be bounded ... I guess
one reference per pipe buffer is not the end of the world, but, let's just add
it, and fallback to copying.

-- 
Cheers,

David

