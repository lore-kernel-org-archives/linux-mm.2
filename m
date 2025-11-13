Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E66CD4F28
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 07:32:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AAC58E000B; Thu, 13 Nov 2025 02:32:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05AF98E0007; Thu, 13 Nov 2025 02:32:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB3018E000B; Thu, 13 Nov 2025 02:32:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8D528E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 02:32:25 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96CBA1408D3
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:32:25 +0000 (UTC)
X-FDA: 84104765850.04.2F63964
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0034BA0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 07:32:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bi2blkGl;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763019144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0i7hRKV8DTMLpxKz1tNlkpsWa1ktuB/e2qAZFWBh/rs=;
	b=mGpbN0oJuony1i8zn3+aDpQbZl72sEhNx0jCeLuB1fQH6Sj8fjNoY3FN+z7UL9wWoPLjWY
	3HYWMxjlNFA/HDPMwsm4KjN1LBzJl1ixqinReVJROCOrnlyo+lyKZ/AbUEYjBtFIwvFDMn
	kpyFYOLclLw+0DMVWvTxUeDLKjH5dwM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bi2blkGl;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763019144; a=rsa-sha256;
	cv=none;
	b=kbyLRtM19KTKWqE5iwGafrxBk7hhMkjfakw4cN0fEycVWr7kmROdIZVCsKAkSlG9nH6uWA
	8VOD0nHqtn2NsdGD6j528Vo0XwKw9vnXW0sM9uo91U0CZ6RoPkrsnF4k+3Hv0mBjM4iAYK
	Lb1dYEJUz0DFXF0oCHFBqAELj11vUbg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A396601D0;
	Thu, 13 Nov 2025 07:32:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F56BC4CEF7;
	Thu, 13 Nov 2025 07:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763019142;
	bh=6+s4EmAJUO31C3E6m+fUKs8Q2v9rA00c27ndUGZWmew=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bi2blkGlg81MeUhv5K542nJxO+2kxzMA7Zp1I77pGmaKBzagsy9OIkW8yJIuOpBkk
	 z1oZ0X/oXTqaHgJeksOr2aHFFeWzlp2ys7jBs74xNaMjIqLBdG3TfyuSvUozgkZlN+
	 1isSDCtOyMmuRSiPOUdWl0DN/sOrx6pGv2HPGbFJBo/UzvoIXDp3ueDaMXwK3c/c4F
	 3ocikKixQH0Bb6JF90QB2Tk1U7lQA/aBd8SjVBXrgqzXQt7uRleP01YEonLDVKbng+
	 A/PvFgbGE3AQuJ9CqgnBlmbXiS8BXO1wkGvejjVMM9RBVA+ZEdNSvR6NLONwE6CsiT
	 CHX67KQjezRvw==
Message-ID: <b02a9217-f2d9-4005-b7ed-6f4198670ba3@kernel.org>
Date: Thu, 13 Nov 2025 08:32:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: softleaf device private fixes in
 remove_migration_pmd()
To: Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>
References: <20251112044634.963360-1-balbirs@nvidia.com>
 <20251112044634.963360-2-balbirs@nvidia.com>
 <4e6286a6-721d-45cd-a4ea-e79e90e14fc7@kernel.org>
 <a9c8fd41-66c6-4cb4-a033-4138be701b3f@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <a9c8fd41-66c6-4cb4-a033-4138be701b3f@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0034BA0003
X-Stat-Signature: fn7g5zjoa6jkr5y1hsorcffzzt9pbxm6
X-Rspam-User: 
X-HE-Tag: 1763019143-847618
X-HE-Meta: U2FsdGVkX1+hvlS0F0pOxJzQpoTomsQ70ET42NGg5zKrLlvZhO+X+XZ5YyiWEYdOxjQqwMOx6fEcXDWNgw1ubUgAuv2o3b6G5hEM6emMFq+W3BBowmO8XR/4+x7Ju1cmyM1RCYQLz0h6S2I1DKa67DWO3+gvCv/ktLjUhw6RZ+MDGSmne6deAHQCgLJTQs7MvWIOANLeyFDXISWyfvqIYeHyistjNNdZ6/y73rQAyP5ocipyNcIXhtqwL8MZS7dptofU5wFTIhBWmkTBXiTjjbM7G4E1t2kyWHIcPhNhx+vcNHwYg4cR1tzHck9KGGOrf2n1l9HjPSGJkv21jgA8QhXcBYmjQjWqiDELatVVCoS2FoW+LrJIQ27zoc1dkwRbUhH3Ra39/C3JAqquM5B2WJ3q4LeM7l7mTkA6cRbfKqWVvF1CGIJpcUdWb7C1587lx1gQncRIzTLTrKJD/bCAIpOVSCNfFcsvPRnoUQpz0bykdZrKRzRw3LC7lN4ZpX7J2hChahxHk572WavqsirNxQumUSym9wY5jV46pVEtegcckEd4vKDKTisnQRjwkxgEuSY2H34ad+iynlbRPqTdLVMRVPH+khVtvcG7Qi3z+KF+be5iId3N1cQCVryvO0bJUFWwTzmurOU4d/AF4I4L3SmgX1ENDEWNl0OuS6orE8nh4LsYwBqW7ndOE7jBRNyetm1OkPkQeiV1w5BdXLp1Zhe7CqeGdS42Y0kRBVDCPZ8OtzurfOvn8X0/VhkhJMNmP9+PdlK+lLEbCx9dr3FArPeTbHQZJ3RgMMN7DlWp++mFIJfP+6yyRBNiw010DlkWCat+anBwl+P00ufkSpAporkN46idVJglV7Hba0Q7Xnj6donVSRRwrn+DdXJqi7C3yIpC/eX+WAy7YLmupTQQJgWsEf3TFOawenXfuZlPEEOZh0oiSSMp3eDqyih0789GMtDHAYdfV/DCtL0WXzh
 3BJM9W7z
 ep9h69kr7fcKV6ZKny83/lTxNS/we45hAnyA/M8ONzATRtEupS1M8LQ4gfQTBuPLRTiMJGbFjIUNyiPAKslvEDwqCemtKbYEiotKsZ74YJv7/9KjmO6ziwFNyNVxcfqfv9+OODJApCnVFOyeSUtlsTYyEzjk4xcUZ9puNIt9fnB1jjuKnPDEnpHkaFMmqWI8f/t8ZRXxhI7am00RzeZlePvuwl7hKOSgrRszWu9uTYsfhs7B+wRmAMivaxaZHIxxMrsqgYzesceP+FiQx6fAWKoLBqDMgdXk8ON56J2/Yw5HicsHUk78WjSeEkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.11.25 06:03, Balbir Singh wrote:
> On 11/12/25 22:37, David Hildenbrand (Red Hat) wrote:
>> On 12.11.25 05:46, Balbir Singh wrote:
>>> commit a6ca2ba46390 ("mm: replace pmd_to_swp_entry() with softleaf_from_pmd()")
>>
>> So should this be squashed into Lorenzo patch, or incorporated in his series in case he has to resend?
>>
>>> does not work with device private THP entries. softleaf_is_migration_young()
>>> asserts that the entry be a migration entry, but in the current code, the
>>> entry might already be replaced by a device private entry by the time the
>>> check is made. The issue exists with commit
>>> 7385dbdbf841 ("mm/rmap: extend rmap and migration support device-private entries")
>>>
>>
>> Because this confuses me. If it's already a problem in the commit-to-go-upstream-first, it should be fixed in that commit?
>>
> 
> Not sure how to handle this, because that would break rebase of mm/mm-new
> or I'd have to send a replacement patch for the original patch from Lorenzo
> (which does not seem right).

Yes, to be expected. Maybe Andrew can figure out how do address the 
rebase, or we can give him a helping hand :)

> 
> I'll post a simpler patch, but it needs to be on top of the series

Agreed, thanks.

-- 
Cheers

David

