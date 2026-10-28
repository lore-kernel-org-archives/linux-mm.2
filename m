Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 29217606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 09:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MQZfJNG9
Received: by kanga.kvack.org (Postfix)
	id 3EDBF6B05B6; Wed, 28 Oct 2026 05:02:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C55E6B05B7; Wed, 28 Oct 2026 05:02:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B4246B05B8; Wed, 28 Oct 2026 05:02:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 012B46B05B6
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 05:02:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E90DA893E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:02:53 +0000 (UTC)
X-FDA: 85371445026.13.915867F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id A0EFC40002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 09:02:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MQZfJNG9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793178171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EVc0/f8ChaWRV8kX9ByD+jZc0OWkw1ePPWsvRnLXgIk=;
	b=mg9FT1uSdV/43mvv6Icn1OxstBQ6vjgZdLOFpI0cKX2bsBzH9+rHqahM3/3t/u602tOY7K
	20REA+IfdYzKrhFpMj+EurXuyOVrK9IKzWhY5ce93QKKkkjE4EWpvh6Ou3T3Pt3HrBzYfV
	mIXoZLFbhK0M2NOvXawZxsFXmCDui+g=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MQZfJNG9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793178171;
	b=6PjcGa7KZuf+6LL3HdLnIm83F8RvxAwsifAFUwy8SjvEq20E4rwOcJ3ZrGvs5rcxTeEv/C
	W+L7Q5xMcocdBs6WkhjQ5h7BLWfj8WAt0PSJ9bSJdl4ujDiYl7zmUJfdsB2ce+dR4jdE3M
	3tHRjTFjLCcK++JNTIuoIdI0T59r3aE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 28162600DA;
	Wed, 28 Oct 2026 09:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB631F01825;
	Wed, 28 Oct 2026 09:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793178170;
	bh=EVc0/f8ChaWRV8kX9ByD+jZc0OWkw1ePPWsvRnLXgIk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MQZfJNG9+JCMzP5YNvf+YJ9gL5OOyjmTXPQnk9aW+HKbD0t24o2nd3HhnZ1LNrDQ/
	 q1yk/FMjfF8s9rlx4AZgdEf9k8YX0i/Up4dKThnSN81ZQIUMkepedhJeJcQ7hGVn43
	 XuwhGNaWUkhQJzrchBR9cRmpV7HVXZsUOsdGKoAPw1iDwB4Jf73xq/qdW9uZfcajnw
	 8XPb84Us2IWyzm1EcGSGgBqyc126G5xm4dkDgsEXLktbrtH6jNe6KiRv12vwF7j2Pa
	 tEynM4JiFTAbfLtZ6Sc7wY2RTTGf5dexzk05+N2QQd7DlCsOKl7N12DEDl/rEP9tcr
	 Q8JRJxoU8wjmg==
Message-ID: <e34c1804-8de0-488c-b962-b10ea45fd784@kernel.org>
Date: Wed, 28 Oct 2026 10:02:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/14] mm/shmem: fix truncate loop after boundary
 swapin failure
To: Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Gregory Price
 <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>
References: <20261027-fixes_shmem-v2-0-86a00952acb9@kernel.org>
 <20261027-fixes_shmem-v2-12-86a00952acb9@kernel.org>
 <2d111275-e7a8-4ac5-8618-f068e87145f2@linux.alibaba.com>
 <10ae2533-cc4b-4c30-95d7-705815ba7830@kernel.org>
 <7f4155ef-9f5c-4567-a84d-dddf640cb844@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7f4155ef-9f5c-4567-a84d-dddf640cb844@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A0EFC40002
X-Stat-Signature: heg1a3a87d1hhgn99ag9qbmbghqakugy
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793178171-803792
X-HE-Meta: U2FsdGVkX1+/orPNz8o4GPgLyXNCS3RT7NGfzbgDqjroQ1SpeJxOGJ2jstRg2f23tMhUsgdgOChuX0hl/UYPRHSBgTW3OONuxmckULXXz119oPNCnNZ+lcRJXo1c2ljvj+H5p7s1vO4tj6jk+qkAPFVy8pxBVRuOz5eevrCZIAq2k12lEsz7g2z9DJhz9Rlz9efX+cGmGtcqhXTroe1UvdzPpZ12PWNEXhSuI5bnrYUsrvdKLUPHhIlx3L+uv6lDfbXzGoaKI7pW86xxGv7sH9/AyDuG7Kbui3ukXH5wOFFPP+waLUnRpRv/0Ymh2rDe3WSaPuioJ6g7vMJIUoJpKilJLY6D1N/ANmpsCT5XH+H6i7I75PFqaj1ojpw6Mf54vVswW9yKEAFcM9wf0gL0UoYHI77UvMLFotxXqoazB5Ki/iYXstQ6/VuiO9noz9aC4g9SOF2aqoCr1DVNZv0Ev7OQsYxcrBiPbxrazENr7KWQirsp9Bm4ESXw6sRlikDdTFbT/lDFp6fHDTUmmTFOzfxGSyobB9lhWAIImfSS/tYjKhlp8Zr18zx/NgTfcQ9S3YjsOYVQ4l960KmJeLHWXNTqSc17J6oySOBw74ksfyp0YUVdKt9hBnOjDYe5DTmn+vNmLqL3Er0kXshSJ5XLPHx8Cdw/jsebwtaQb508VqsmkqO/1tIuR/DuHsYCRx3NgfUS3OnMrkXWkmts/WA91aUg9/MMKaF/0s0WM/DM6RjDVJ5agprCN89abaBKJUtGm7YDEXxcU/Unb2SVxSEGDvmoZ9sOWLjylgOtqVoVGXhAhtL4s+gxG5QyWcvwhBoWn05/4PfQHDw6c1hOvGI5Qops2Q+9bc5PalVIr5f1T33Lg2Hm8xfVSZxZf5T8KClIO0x9ULJmLLKiWNM4gjI4Y7C3RgT2v7qQN49hDJxkHxNJpbnhnakFZgEP+DIKFVGARqu0lxI3p7ijY5nnzj2
 JeybBWy0
 pb70AXj4MJBktMNUN8jN8puW0oc2f5mM1mM3G5KePoRhbo5SxP2RcguwlhpI5rN2OFDFPtZtpQt9wE5aYRF8RztMoI8S0q++xIviDkEQmIjvV0N9gK6F/nAijQnTs8QsePrcLopirTTPkaJYBBQxIyyNWZgssflLRLO/VEo0uRNYMDlRnBxHfBlT7XM/WzE0XiLICcmHc3F5ES438sYmgXVZAXelQfK7uqjGpQtF1fBfY2NMsRtp1EF+GlME7JKCR/dNGknkCk8Yfksjh+5UyTY6g8sRxWhJGdLtwBdt8eADqVanO4tkR2EE22q6Hi4Vn/gyqw3FjgZQH9tBsS4o1gOwsLlIe4zOHsIevBn8jmg0z6Sg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/28/26 10:01, Baolin Wang wrote:
> 
> 
> On 10/28/26 4:21 PM, David Hildenbrand (Arm) wrote:
>> On 10/28/26 02:30, Baolin Wang wrote:
>>>
>>>
>>>
>>> Right. But ...
>>>
>>>
>>> IIRC, we originally avoided advancing start because a concurrent swapin fault
>>> could split the boundary large swap entry via shmem_split_large_entry(), leaving
>>> small swap entries below the new start.
>>>
>>> Sigh.
>>>
>>> There doesn't seem to be a simple fix. We may need to swap in the large entry as
>>> shmem_get_partial_folio() does, and then split the large folio. I'll work on
>>> this as a follow-up.
>>
>> Thanks!
>>
>> So you are fine with the patch as is to fix the endless loop?
> 
> Yes, let's get this fixed first.
> 
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Thanks, sending out v3 soonish!

-- 
Cheers,

David

