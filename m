Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4F90C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 01:34:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B3D86B0088; Tue, 22 Sep 2026 21:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63E3D6B008A; Tue, 22 Sep 2026 21:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52C366B008C; Tue, 22 Sep 2026 21:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2E46B0088
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 21:34:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E10E880673
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:34:12 +0000 (UTC)
X-FDA: 85243306344.28.FA6DB2C
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf20.hostedemail.com (Postfix) with ESMTP id E12461C0003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 01:34:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GsQk4z6h;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790127251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ju8/8hlgVD7koLs0Ca8D1iyAWrg9qc7MYYjxWgNuOVs=;
	b=Jmcq6c4vlY8KmbqA1/lRxV5F8pfnmbzmRsHwOE2YqkIEVN7jIeqZfAGNBv1VGBzu84RACR
	Tyb5+pwMj8ZYSEdZYPzj/qsRRWwsyDkPaFP0nxPuiyUWBiTyfFBoocXc434+sOg4hImhZA
	slV1+dHo4PNdE2b80RsmRJ8EYoyij+I=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=GsQk4z6h;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790127251;
	b=kc8ZtF3HdAVE7LtUuPx4Y5RzepIWm5LufUTtFG7SokXxDqes6vdavdvJksQ/XZjHYs1f8Q
	L3m2uKGg9R6V+a7Wo6Lb8ip2ovluTCGUfGvBP6wBr6aMyU/C8dJibcbZCjN5K7y99KjnmX
	ewDW/3R4yfhAMNt2EXzOq0f3ToyYv8o=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1790127247; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=ju8/8hlgVD7koLs0Ca8D1iyAWrg9qc7MYYjxWgNuOVs=;
	b=GsQk4z6hTRVQMT+9gpIkxCk8aXmFJXrzgPinPubAhL74oZjV/81Nb7XLsg1ceURF5GFAjZZRgocwajBuXhlz7RfTVzViSuip6MwR6FSpInMz1rKs29/1uxX6AFTzOJ6c4ORzURJ7P2jpcQBQW0Kc70f/11ii4iWmA3fwq7lO79Y=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0XBVICt._1790127243;
Received: from 30.74.144.107(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XBVICt._1790127243 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 23 Sep 2026 09:34:04 +0800
Message-ID: <1619fbdf-9d68-43ef-afa6-66dbe3e61c77@linux.alibaba.com>
Date: Wed, 23 Sep 2026 09:34:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: don't release a swapin-error marker as a swap
 entry
To: David CARLIER <devnexen@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 kasong@tencent.com, bhe@redhat.com, chrisl@kernel.org, baohua@kernel.org,
 nphamcs@gmail.com, shikemeng@huaweicloud.com, hughd@google.com,
 syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
References: <20260920155002.1030454-1-devnexen@gmail.com>
 <fe49c311-582b-4ee2-8d17-42a758351570@linux.alibaba.com>
 <CA+XhMqy_0UPL5HfPYhPHeJ-ZngG4DRzme_a32sLSYd2VGSjo3g@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CA+XhMqy_0UPL5HfPYhPHeJ-ZngG4DRzme_a32sLSYd2VGSjo3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E12461C0003
X-Stat-Signature: 96is5pjacg19ucj1muoirrw8u6giumxc
X-HE-Tag: 1790127249-139254
X-HE-Meta: U2FsdGVkX1/JoIl4sXAfz0D/ELZ14M4I9yKl1ZXqRBQjnHOtw7aLJU5CINJgAt3JoDfxyHMXJkywSd8drLhgt4NmrXqkqyRuhGWlOkwGWQEebIuY8xBXkfv1fIu9RCDBH2ozRV5AwHLHjG6mkc01e29F7wFLDD8R+8NaHO17OInQ+6JFEKtE5ScH5iFomHIMjAfwwi4/6jIu7rnnLMgD0H8bnNRYgT3wCzTh7oUnPidn8bg+fGyWWs6h/zrqBu1Eugi4/1hO88Clq9+2RfZTX9xjD1OCPhfXUZC+NRp2BTRmlZJVDWYZN6af1a0ZGcyi+sBm8nUpt7ZeR8Cx0GQW2zPPIEJdh3qddp+0K9oRgEKGrSSs4poVpZOw+UnlqgQOI8hKuqaKEzJlI7lmO4FqumBAix689nUSBQyaOylT5i12cu+RTkEgl7Ovmb2vIICsLqEjfOEXtdxdnNV3ZIVnbGEBlXemklXJhYVcn/Hgv6Bzw3fxP1BKUMj8iBPYYidSQbOu1AOxv2ohsPOgdkQ9+5dBQHScscO/dTBAT5AqvucoBbrCsCBAwGb/lCZ05XgnrKw970smjiuv4snXJ5MDepuYJ6fK7FytWv/h5eR0XDyb/R4+ueN4X86urK2hXdvuvXX/pq7+czFMO3GhzeEL+cbEL8D1I5OxSLGI7aqZiS54HejQhcxvZD+zxVBH+7AFvdeYuVlYeSDU09upnAbjWYjfLG2XncswX1Hy6o4DXLvx0+1WEjYsXcMNHOe0hT7An7dO4jaiepLe+9TvZ7bWrxkvc2MRzfHKM4AcXtFKjSSTnANXXBG6ckGoKPhvg28JCaizY0hwJ2eBXfXdtodv8Yv6SRMWk0CrC/ayfrO7hxhjFlQdYzQYt6pLKyNkogiOG4IzZEmUeEU0T3AoPdgO2Q9yoBVAapvNfSeyLkSozbpVXRsunFcLURikFnm7bD8g+vEjHCthDRppz9pJb3x
 n3P/aUBP
 ANN2FHYmgDdEF4gNaky6IxS8TzFOkNmq5SS0R4ozl4JYFYM04/8Gdkq5qCC+uZ7mZJdmWy2X8tXzhGzOS8m0t4rf2IFYG30pYY9d5eWR1ECtuKkHMWXJx+EqxxNUpFy23FeBg5g6qZNqeCn9Xdmdjp6eG3xVBLrO+sKcvgdT0HKwBQjADznHe0Rj8jCCVD0TaEzizg/tQMJOd+m/YfK0eZTnx9k8U1b06A/nNawT/x48XucfBlzYtUjZpvA8XL5oVEjTwnf80/YgD0QSafDHQ93qfKYnfU1hi/jNNhVx22RhQfjAFVvpi3LR+c2mI4ZgB6EjCFx78T7i6yGiNHnCSVZnkUbR2ndM68xOxvVFt/rPcU02UyMWG0lKVpoS9ZDnxOBkoZPGxvlQiTsQgLoI73lFJ3/YFqFOJ/2PHQZW6H7eUCY20xMjDQ6LFRRfb7d/8jN7SDDuu+sHq36+8OE3YWupHhEzalWkLDsBXrJDToHAi5cElNpiMCGyBBnZi05A7ZvybGdx5uLbjn9XRsqNDCFLnoXcRIAoze4qbqdnYqRGAm7I5AlR5L7iUsK+9/gPPdlHR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/23/26 5:03 AM, David CARLIER wrote:
> On Mon, 21 Sept 2026 at 03:45, Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 9/20/26 11:50 PM, David Carlier wrote:
>>> A failed shmem swapin frees the swap slot and leaves a PTE_MARKER_POISONED
>>> entry in the page cache. On truncate or eviction shmem_free_swap() passes
>>> that marker to swap_put_entries_direct(), which warns because it is not a
>>> swap entry. There is nothing left to release either way.
>>>
>>> Skip the release for non-swap entries, as every other caller already does.
>>>
>>> Reported-by: syzbot+23b25ba3c6bf971f9c57@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=23b25ba3c6bf971f9c57
>>> Fixes: ac2d3268284b ("mm/swapfile.c: remove the unneeded checking")
>>> Signed-off-by: David Carlier <devnexen@gmail.com>
>>> ---
>>>    mm/shmem.c | 6 ++++--
>>>    1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>> index b572c60f2af8..94f2c59c8cfc 100644
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -1184,6 +1184,7 @@ static long shmem_free_swap(struct address_space *mapping,
>>>                            pgoff_t index, pgoff_t end, void *radswap)
>>>    {
>>>        XA_STATE(xas, &mapping->i_pages, index);
>>> +     const softleaf_t swp = radix_to_swp_entry(radswap);
>>>        unsigned int nr_pages = 0;
>>>        pgoff_t base;
>>>        void *entry;
>>> @@ -1200,8 +1201,9 @@ static long shmem_free_swap(struct address_space *mapping,
>>>        }
>>>        xas_unlock_irq(&xas);
>>>
>>> -     if (nr_pages)
>>> -             swap_put_entries_direct(radix_to_swp_entry(radswap), nr_pages);
>>> +     /* A swapin-error marker holds no swap slot, so just drop it. */
>>> +     if (nr_pages && softleaf_is_swap(swp))
>>> +             swap_put_entries_direct(swp, nr_pages);
>>>
>>>        return nr_pages;
>>>    }
>>
>> Makes sense to me.
>>
>> But another issue caught my eye. Since we already call
>> shmem_recalc_inode() to decrement 'info->swapped' when handling poisoned
>> entries in shmem_set_folio_swapin_error(), shmem_free_swap() still
>> returning 'nr_pages' for poisoned entries would cause a second call to
>> shmem_recalc_inode(inode, 0, -nr_swaps_freed), thus triggerring
>> WARN_ON(i_blocks) in shmem_evict_inode().
>>
>> I'm not sure if you've observed this warning. IIUC, shmem_free_swap()
>> should return 0 for poisoned entries.
> 
> Hi Baolin,
> 
> Thanks for the review.
> 
> I think returning nr_pages is needed. shmem_set_folio_swapin_error()
> decrements both alloced and swapped, so shmem_recalc_inode() sees
> nothing freed and the block stays accounted. The second decrement in
> shmem_undo_range() is what finally releases it. Returning 0 there
> would leave i_blocks non-zero at evict time.

Yes, you are right. My memory is coming back :). So,

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

