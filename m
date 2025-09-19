Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA70CA1013
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 02:12:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657CB8E0053; Thu, 18 Sep 2025 22:12:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62EEA8E0008; Thu, 18 Sep 2025 22:12:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BDC8E0053; Thu, 18 Sep 2025 22:12:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44B828E0008
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 22:12:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA51B160546
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:12:33 +0000 (UTC)
X-FDA: 83904375786.20.B5762C5
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf19.hostedemail.com (Postfix) with ESMTP id A3F2A1A0002
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 02:12:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lQFeRzwm;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758247951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m6BSTlEv4BxYzmuMdizgJCn5FFRfQjdUu4Ddm03+goQ=;
	b=OLkj85uxmC+pRhamuvbNzmLuoL73BXP1HE666OhmvxRHBET8DPtBpWmRfQrWF50YD7ZTkZ
	XhwcgOW7CjmF1FvwldWVxDiVtV4TqMH2uLO1FozZU0Jj7yZ7IG0SLU+QvBIDeIjvoEUg43
	lTcuQZ3uT29i2zfx4udcSJPccYB2mD8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=lQFeRzwm;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758247951; a=rsa-sha256;
	cv=none;
	b=5VAqMZeA+4KOw8IzjxTSfsEUpvSQnoz/2ERdKldNuG3MhzZ4vvgWgOh39zHj4pG6P1pblE
	6gjWABQZa0CXT9/GvKaN3lrDtJ2KxzbSYNDAyH+jzjEASLYU9pJ5/dsCHb7scG3qbyu5QS
	3uZttmSYE7H8Twgyclqd58iBEiyZtaw=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758247934; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=m6BSTlEv4BxYzmuMdizgJCn5FFRfQjdUu4Ddm03+goQ=;
	b=lQFeRzwmQ8ZymA3Oz1BIxYmSAfGQQLbN4I6e09nvLAz/o6fAgBR9qHkh1icKLGMcDHtGtHm98GKEzBAu6xtY2hMJNuBi6VPMEfiRXzFHd3cOpcPCPewM5mwX/CAHSbrSdimoNWIBdmQdkpvIzmszq4/roHTq0eAPtv4DjAyJ8k0=
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoHs.rR_1758247933 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Sep 2025 10:12:14 +0800
Message-ID: <787dc1a4-d0b7-4559-8160-55de987beac3@linux.alibaba.com>
Date: Fri, 19 Sep 2025 10:12:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: vmscan: remove folio_test_private() check in
 pageout()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: David Hildenbrand <david@redhat.com>, akpm@linux-foundation.org,
 hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 lorenzo.stoakes@oracle.com, hughd@google.com, willy@infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1758166683.git.baolin.wang@linux.alibaba.com>
 <9ef0e560dc83650bc538eb5dcd1594e112c1369f.1758166683.git.baolin.wang@linux.alibaba.com>
 <17d1b293-e393-4989-a357-7eea74b3c805@redhat.com>
 <4e938fa1-c6ea-43fb-abbd-de514842a005@linux.alibaba.com>
 <tombfifwrhx2n4jnj2pgcdcpj42mdv7yizkpxrppnqrtsxd5fw@epnrjqgmmy6z>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <tombfifwrhx2n4jnj2pgcdcpj42mdv7yizkpxrppnqrtsxd5fw@epnrjqgmmy6z>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A3F2A1A0002
X-Rspamd-Server: rspam05
X-Stat-Signature: umr53zyrf5ef8cp9mjocf8f1jwf4c1hi
X-Rspam-User: 
X-HE-Tag: 1758247949-229044
X-HE-Meta: U2FsdGVkX19pycLIn8VDjsNuEapGHAJVe5zGUKqeMCH03GM4KPLNJ4JoswwUc0MgoluLAZwNOKoKPob8luGJyCuvn9SsZHhGUdtY/YjqshHCgoDn/NhC/uYfEZAVHl+l1XIH95FyU0vitDhit6B5DkYTkBw3RnDt2fP9GBa2OMDR5dLPCGmegKdCmu/xLax1BN/du3Q55oDN67E85Lt87eH9jIZm4O9IDQ6MzLWIwi5v3dR3TEIbxJyLGUI6myZ+buS4TGKjtH4ci7Xc2Hs4eHNgdVkMGbwfflL30SFhD1KZLwxc/grSzF/3iyOrPZkQZDM0pCgtaa76I+WdxuW6maIch6oJQbtCexJ5BT0W9RtCrZF9T46m85YEKIi2BYoqj4/JTBnbFQQQWdkWOuG/o67GiJEGEV4mRbYTN4VH1VZ5kn2dV7eQ+5S4JhvHx5lnoMS/lHm+R8fP/xWAwTSm1dSqz7G2kWelU2D9dgujbke6MigT9XJ4LExtctziJCyj+ObyMU8fNgbxK5hmLFT+a5gVFbzJuUgGebHuze/lzZMvAa8oMwGzBfouK3I0YAd2gAehBnWw54gJK7rszcT0c8nwIym49KjVWnhzOF21SBcL8jcNjz08ibjpZM6mognhCnqbumwqDJnNiaxqKOyFgN2gL716V+XmwQ2g8NmRWqCl5M47cteHXR0eR6HM/TyVoh3qKx0l4qfba9qVLj56Wgwi7dGOaLciiEJ0agBXm9mpL8Czk4XGnhBNldpMr505qVL7lqneEvdu2pPb6eUroA4QSwp/qieHj1gFfr5WSUTz2NW0B6Zpo8LWLYTtrqLFA7Ug/OZMC6CZCYXDt6Uvf8FIt4mLa5Y9WpJpkKCefgd+ezfIZmkZUw3R8wQT2LNYgFxqSp3e7e1ZE/8KrymCPnsCbV2rJv4qGNIbtNWoyr2xbt2Hr/LxXsGFNKH+ZNI7EW1qldRDXNFk57u0HQ9
 KOLrsSkc
 znwbKnELiZXhMMfg6LBySWxSVRkZCl0BWeBTCB5SbG6stcmN5oGZwDkpBHCcHBenF2FjxXHLmNpYVONfpT+oQ71h6LKrUSp9YfKCSWFJ+JV4Te4miNwuyjLQQOj9CHGq2ywx0+wRDP9K+U/EBFoCDbkU3FBzT6XjgVimKbxvc6IrEctrLSPlQ/4wSn/ik0BVcf+PGl+ftyHKapczbkts2uE+/qYcJJD8txajJJbp9S691sQ+zcEFnA81Jj8jaogW0lQdSM67BuuPfGXNnEk+p0FOu2AHfiufWjtN68pnSjNnYZvryAlqruDKQYEunxEtZgFNHpanHB/DUG5HNmBRNubxLcXPIjUGeb+4s6FCdzYEkrxfHxWJMBZQZgbOhCzDjE+aR8lygg8j4M8IwrX3zrk69Ab19YhQKD4DD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 09:06, Shakeel Butt wrote:
> On Thu, Sep 18, 2025 at 05:36:17PM +0800, Baolin Wang wrote:
>>
>>
>> On 2025/9/18 14:00, David Hildenbrand wrote:
>>> On 18.09.25 05:46, Baolin Wang wrote:
>>>> The folio_test_private() check in pageout() was introduced by commit
>>>> ce91b575332b ("orphaned pagecache memleak fix") in 2005 (checked from
>>>> a history tree[1]). As the commit message mentioned, it was to address
>>>> the issue where reiserfs pagecache may be truncated while still pinned.
>>>> To further explain, the truncation removes the page->mapping, but the
>>>> page is still listed in the VM queues because it still has buffers.
>>>>
>>>> In 2008, commit a2b345642f530 ("Fix dirty page accounting leak with ext3
>>>> data=journal") seems to be dealing with a similar issue, where the page
>>>> becomes dirty after truncation, and it provides a very useful call stack:
>>>> truncate_complete_page()
>>>>         cancel_dirty_page() // PG_dirty cleared, decr. dirty pages
>>>>         do_invalidatepage()
>>>>           ext3_invalidatepage()
>>>>             journal_invalidatepage()
>>>>               journal_unmap_buffer()
>>>>                 __dispose_buffer()
>>>>                   __journal_unfile_buffer()
>>>>                     __journal_temp_unlink_buffer()
>>>>                       mark_buffer_dirty(); // PG_dirty set, incr.
>>>> dirty pages
>>>>
>>>> In this commit a2b345642f530, we forcefully clear the page's dirty flag
>>>> during truncation (in truncate_complete_page()).
>>>>
>>>> Now it seems this was just a peculiar usage specific to reiserfs. Maybe
>>>> reiserfs had some extra refcount on these pages, which caused them
>>>> to pass
>>>> the is_page_cache_freeable() check. With the fix provided by commit
>>>> a2b345642f530
>>>> and reiserfs being removed in 2024 by commit fb6f20ecb121 ("reiserfs: The
>>>> last commit"), such a case is unlikely to occur again. So let's
>>>> remove the
>>>> redundant folio_test_private() checks and related buffer_head
>>>> release logic,
>>>> and just leave a warning here to catch such a bug.
>>>>
>>>> [1] https://git.kernel.org/pub/scm/linux/kernel/git/tglx/history.git
>>>> Acked-by: David Hildenbrand <david@redhat.com>
>>>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
>>>> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>> ---
>>>>    mm/vmscan.c | 12 +++---------
>>>>    1 file changed, 3 insertions(+), 9 deletions(-)
>>>>
>>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>>> index f1fc36729ddd..930add6d90ab 100644
>>>> --- a/mm/vmscan.c
>>>> +++ b/mm/vmscan.c
>>>> @@ -701,16 +701,10 @@ static pageout_t pageout(struct folio *folio,
>>>> struct address_space *mapping,
>>>>            return PAGE_KEEP;
>>>>        if (!mapping) {
>>>>            /*
>>>> -         * Some data journaling orphaned folios can have
>>>> -         * folio->mapping == NULL while being dirty with clean buffers.
>>>> +         * Is it still possible to have a dirty folio with
>>>> +         * a NULL mapping? I think not.
>>>>             */
>>>
>>> I would rephrase slightly (removing the "I think not"):
>>>
>>> /*
>>>    * We should no longer have dirty folios with clean buffers and a NULL
>>>    * mapping. However, let's be careful for now.
>>>    */
>>
>> LGTM.
>>
>> Andrew, could you help squash these comments into this patch? Thanks.
>>
>>>> -        if (folio_test_private(folio)) {
>>>> -            if (try_to_free_buffers(folio)) {
>>>> -                folio_clear_dirty(folio);
>>>> -                pr_info("%s: orphaned folio\n", __func__);
>>>> -                return PAGE_CLEAN;
>>>> -            }
>>>> -        }
>>>> +        VM_WARN_ON_FOLIO(true, folio);
> 
> Unexpected but better to use VM_WARN_ON_ONCE_FOLIO here.

Um, I don't think it makes much difference, because we should no longer 
hit this.

