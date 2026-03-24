Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F9EEF54AAF
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B88C36B0005; Tue, 24 Mar 2026 09:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B12CB6B0088; Tue, 24 Mar 2026 09:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01926B0089; Tue, 24 Mar 2026 09:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8F5DC6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:15:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44E41161C10
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:15:57 +0000 (UTC)
X-FDA: 84581004354.13.CFACBFA
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id C4D421A0011
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:15:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lCLEI5rn;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lCLEI5rn;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774358154; a=rsa-sha256;
	cv=none;
	b=mrdxqzBdWsrauOBOF0oX/uoNyGxOvZswCepxPO4B86pJ3/++Df0lW7nCWc3t6mx4tCBeZu
	6MJHK+dNOa1KE8q7cQofhOCmEErZ+EhKlHcg/K5xl6iXPb0jA0qqzeWf8/DE+ZvVRHwS4V
	8adovcBrz6lPdvbUUt6n2//3oIRl53M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774358154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gTgQCP+5YBhbolPTDqqpYhG/7AEExmRx0uocLkbImg=;
	b=RYQw3f0ntjvsbFhv+y/4x5QGj/EV+TDIEq4yMFuXjS3t6IsahWocVZLIhkv64a5OwY49PM
	pV5l8Eju+SwKhe4NtR4zaW/42gizpiVVYX5IhZZoKq8cKpL7pYRQQP3gVg63cUTEK5cRUq
	y8EDHfXv5Rl7xGQ2chftvfghH62S70U=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774358149; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/gTgQCP+5YBhbolPTDqqpYhG/7AEExmRx0uocLkbImg=;
	b=lCLEI5rnVCaGOatpQquuNr+NQzvHK+dxa0bWVOJQswXydAKL0FBWb32iFbukUTSHlxrFf/caIPltXXNajKU8V5OucvR6p4i7ziVY+vD803W6VxgAmC120+kcT70AAg2gmfpoLBlWKxOCONTSrMS/rNC03yBpuGmM1rA5e1fJ9Mg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R941e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=27;SR=0;TI=SMTPD_---0X.ehy5D_1774358147;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.ehy5D_1774358147 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 21:15:48 +0800
Message-ID: <33f09051-b5a2-4f40-8ea8-a7cade5019bf@linux.alibaba.com>
Date: Tue, 24 Mar 2026 21:15:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/11] mm/khugepaged: remove READ_ONLY_THP_FOR_FS code
 in collapse_file()
To: Zi Yan <ziy@nvidia.com>, "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Song Liu <songliubraving@fb.com>,
 Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, linux-btrfs@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org
References: <20260323190644.1714379-1-ziy@nvidia.com>
 <20260323190644.1714379-3-ziy@nvidia.com>
 <7382046f-7c58-4a3e-ab34-b2704355b7d5@kernel.org>
 <E8D52134-B63E-44E9-BBBC-258DF74B8597@nvidia.com>
 <c20b7dbe-473d-4dca-a10b-b9f5267ad6da@kernel.org>
 <AF9011D6-8EA4-4134-B175-BD2DAB748419@nvidia.com>
 <71148f2e-cceb-418e-b762-c8dbd7a7eb1f@kernel.org>
 <FDC4C393-FB38-4422-9217-DAE95131C696@nvidia.com>
 <acGqbeSjktT4biku@casper.infradead.org>
 <9648838a-ada7-4983-99e3-d694e803e06b@kernel.org>
 <EA39EF46-4331-43AB-8602-D0A73E9C9C9B@nvidia.com>
 <16117b49-d83d-4ceb-b85d-d117d6993ce1@kernel.org>
 <C3591451-D910-453F-980E-C12CC66D731E@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <C3591451-D910-453F-980E-C12CC66D731E@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C4D421A0011
X-Stat-Signature: 9exm8p6ico17aqxhqo9trtxkdbcs5d3i
X-Rspam-User: 
X-HE-Tag: 1774358152-203292
X-HE-Meta: U2FsdGVkX1+1UpBic2hOjttW/a3EraG0ZBcM+q1AaPPecIEx9Q4lijClV2Voak4EAK+z1UCP1T5jBEXM4eAs19xUV/l1gp55PBUfMr7cCpGR3RVvDlSgvjes3rpDz/VHkGs8mACsKcdvp72r9dvcNoGc/x9BS/hOQto7TItxk7qYxbOwqIBBbgbSf7TpDcPiRqaVvAtLAwkRt1QY3HPTFh4tmAn3WND8JyVouFySX0ttYQlrAVDcYhVzuMppQsDFojAbGamPPm7CgORXJxDu3aelLh1OmemlkCqVl7OhNidVXUd6GdB0gq9IAEJ1Jmw/fvLWlZYppF8oT8A4kIFSymS8/b2ghxBaVoJmWEsgJlGHVi3W0Z7Pl6i7gV8gvwRFW/xbBh6Fq4M5hrNW7P9h4EWFDzkb3s/lH80d3Rp3qZqcLfwQ0mNPg/vaDA9P1GmTUvUe4I2FF9XMYVtEj6+EAn8JRSs6ZFoib7sMm542gr40bIKCV3M8yKF+DZFxEsKTNGcKqXgvxH5ApnSPZNPyHKdrfoZ6RjJcXizaSfeyu1fJQwsFL79hFk2U7YsTlI+xcwfApt1gH3EOpjpgw4c2OwKAvt2T86OasBD8/BLK/CfrMuERtoZ7RzioyPSKNBkr/fLjTDDvkC8k0lGInvUE9EO59q+LgV0wwqLo6Yx9f0GyjB1EgmF5RJEztKLVUgzgFJB3mQOHOlUyATZpgNHMuyglGCAmRAa+LqdJ85QpZ0MS38wIRH8nTwcn94/Tb2XFaymBi3REEo4zlX/Uxqrxq97BIMeo4i5bhM5yce2X0UQg9Fmqm94GjDHg9HybqI1g2hWFWXkpYC9vN8Zb7aFKO7z9H6FaWrkkqj9wdWKjFZuYaoz4989mUfD18BZDENy7aP/LJUhObpIXbaL0Ym0vE212ju5hlsDF4odpbQqRUCOsjOD8FBXEiN97yxIGABkCWLmswXSbzCDsIhtkHuI
 3KVNxWHZ
 1OpLsAHvMKWpZQSr+eBFckavqFDCKyVuIAAkLKDQtuyzUfjZy+6QHG3+szGMYsxLYrpO8SsbYszJTG/1O6F0Fafy6CimtpxG27iywCvbgz3DGdRwzCkQGwJXlcxhSFRnlfsP/tSSBP1GrsPo6bR5ks/OjQHCMS0C/YX9vnEfBj6MbvLkfrDkC/D6XST8h4RLu9hyrGbqs4WB7geA9mVTF/rVgJDTiQRGFcpPiwX3zXT6nib44HJLymNZrpdngMxB3JqwG/Wp4HfIlm4IJ3KpcnGa1RpCgQfqsvs9CiUMXCtc5PlIKYBWzOdlQE1OkhvnOTYt2m3LznYjI8BPLehXSlAkiWWqoDct9+iXetZ0adYOgA8o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/26 8:12 AM, Zi Yan wrote:
> On 23 Mar 2026, at 17:21, David Hildenbrand (Arm) wrote:
> 
>> On 3/23/26 22:11, Zi Yan wrote:
>>> On 23 Mar 2026, at 17:05, David Hildenbrand (Arm) wrote:
>>>
>>>> On 3/23/26 22:02, Matthew Wilcox wrote:
>>>>>
>>>>> Not necessarily that lucky; if you set VM_HUGEPAGE,
>>>>> do_sync_mmap_readahead() will allocate PMD-sized folios automatically.
>>>>> On busy database servers (and is there any other kind?), khugepaged
>>>>> takes too long to run and find opportunities to collapse text pages.
>>>>> Like, days.
>>>>
>>>> Yes, in particular given that the default khugepaged settings are awful.
>>>>
>>>>>
>>>>>
>>>>> I think the test needs to be:
>>>>>
>>>>> 	if (mapping_max_folio_order(mapping) >= PMD_ORDER)
>>>
>>> This is very helpful, since I was thinking about using
>>> mapping_large_folio_support().
>>>
>>>>>
>>>>> as there can be cases of filesystems which support up to, say, 64KiB,
>>>>> but not all the way up to 2MiB.  I disapprove of this situation, but
>>>>> this is where we are right now.
>>>>
>>>> Right, that's what I had in mind.
>>>
>>> Does Nico’s mTHP support for khugepaged include changes to collapse_file()?
>>> That might change the above test.
>>
>> At least not regarding adding support for other folio sizes. Baolin
>> (IIRC) had a version for shmem support, but that will come after Nico's
>> series was merged.

Right. Here is the link to the RFC version:

https://lore.kernel.org/all/cover.1755677674.git.baolin.wang@linux.alibaba.com/

Moreover, I have further updated my local tree based on Nico's series. I 
will send out the new version once his series is merged.

