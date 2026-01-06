Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94610CD0430
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 03:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D02FE6B0088; Mon,  5 Jan 2026 22:47:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDB246B008A; Mon,  5 Jan 2026 22:47:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDD906B0093; Mon,  5 Jan 2026 22:47:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB0B36B0088
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 22:47:53 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59EF013AB05
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:47:53 +0000 (UTC)
X-FDA: 84300155226.05.930418B
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4DFAE40005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 03:47:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N0S7syNx;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767671271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/GXGuZ3cPXHcrpAe9cRwt8UMcvtK3NDfHnG89dSZn4=;
	b=ytRuugegk/4crZiFjI3tOICYP+ltZwadrCpuEQLFGrZ1jHz6ismzo0MhLsmfdUYwjfSYyD
	H01Hody5yfcyZwIFiTSyDkeXibcpdT9JoXhgQRHPt4TFefQRLK48WIY5664uWeg0QagETy
	yMjYOTg2eyuKPK1Fesz2du/hbHKknuo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767671271; a=rsa-sha256;
	cv=none;
	b=GIp+8xe8Vix5zJxGI0tkD9O+IbS90UM96KeFaKBLtCMwoIqYRTStxr1FfLDTRb6TueFQCo
	igkjZQuwLnYF3ofxIbpaWXpCqTyOct8pq2wrw4juVt6TcIMeNau+Kb8TmA1sVrJHI0fy/u
	uRuwwIT3jDCsqADIixPnd5cD9PTmUq4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=N0S7syNx;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1767671267; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=p/GXGuZ3cPXHcrpAe9cRwt8UMcvtK3NDfHnG89dSZn4=;
	b=N0S7syNxnONC91vPEjmsAzbQSYWXyg0qyW1BWto4mRxaJJjj55BRW+m5/qZamRRBZTkkm3s1y/PhCE1OmSSWC10BPzasLmuLIgXuzG+R+l0m/gNbCVGvebGk9kiZvnbbMMwJ5Vve1vUiC054c/Fvymcqy9g8LoL5njPc/ycuGsM=
Received: from 30.221.149.230(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WwUF.zz_1767671265 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 06 Jan 2026 11:47:45 +0800
Message-ID: <2b12f63b-ceab-4d3e-a06f-f41e6b1b2d23@linux.alibaba.com>
Date: Tue, 6 Jan 2026 11:47:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: fix uninitialized folio in shmem_symlink
To: Brian Foster <bfoster@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 akpm@linux-foundation.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Hugh Dickins <hughd@google.com>,
 syzbot+178fff6149127421c2cc@syzkaller.appspotmail.com
References: <20251224094027.65842-1-21cnbao@gmail.com>
 <aUwcV2HhtdiXXxfJ@casper.infradead.org>
 <CAGsJ_4whKLWiw6LNexFPHTFWB1QbSrAwrBtspuc=c8fM2=WnvQ@mail.gmail.com>
 <bdb7f7c6-ecf5-4da1-a11a-cc19c77fe4f2@linux.alibaba.com>
 <aVvDcEB583Yuolm_@bfoster>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <aVvDcEB583Yuolm_@bfoster>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r77tnf3txqurqxccri9kahcqg79bwmw7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DFAE40005
X-Rspam-User: 
X-HE-Tag: 1767671269-991614
X-HE-Meta: U2FsdGVkX18QBFFZZK6q+YtyCAs6DBC2aZ5UGX/mwuRQhWOCRK3Zrw3KXCcIFZLoQwUy5ug8dT9ghDG1pmcdnDMRTlsUxXtLc/gLlSm9tqrR1zIsH2R/7zHKDJxk2iHZzCEIu8T3Y0z7PxjeHueKs2eeTZNQHPr0OsDxsW8A+XMJe/O5d/2EmWA9MXrfFbOSs4Lo0cnPYLtsaHHvzDMRMHLtQO2EEYZftw9+7YO+Pa+XCoWKQbLiaVLp3jMsVDzDYVqRMOBdW6kG3IZbBANA4mgpRp0MaBiuAOHr998c2pHfVFMugBoC41J5DJxmt8/fd7jrEbKapSOFjsMmdAgU1t4QbPOm1yvNs9K+8qaMhDBqe3u/bSDrpbX0npOzuN3Nbfak4IYLDN8BHIk6FyifTXndQ4R4J7qRXsYRWPDacPVgwzsyxDmfebpnvufiK/e+7vqU68klE5QabBfhvihco9rXIHB9/ukkuhC5ZMJoGqk1fyjNoef3b8W6+sHP0lMSVMpN0iHgQKOYI1ZmJQhZKJwkpMNEtrVxbAjyJYywpKpJnc/sVOi1qt3k5yhhJ1BG67ildBD4PockOjk9PEsr5YrLXdBeZEoZv9lq0I0AV5DU/wecl8mBwUD029faQRjJbt4DdoBKuQ27eRRNWDUTx3vNwpdUgge1Q3jMy5kbh3QF3rXUxW/wyXYhsPh+OkMJkuXtiu3//I3JtM7aJkV0JtFQdfFUAcY5584GW10HavyFyBQbiKNzQLaLnxchF4HZvEGNE7gBml1LTr4Pw4yht9w/Nak484hZikkGDiN2WRHV3H7MIcKj+HowVMfVaTpbjDOgNlhNdUjOTn2Vgd47I67t4F6Opuco6+jDFGiDVMTDPUGttJAY1AplCRO4cHaiXxTOpPY+tnQK2HtgmzWvBunou+Uq+JnjPKebPlEmmi8W3gKGpGrqUoNqezSkvS8rkvTntbwORqt2WIOOTY9
 xV9F953g
 7bj5GkrcQc7y6Y1/MGIZDLsiQ3fb7QZ/XMBLR3htDqwCvjjnGg1/k4wPGo+29EmEET06G3M6rBnSeXzsZgXRYQ3+uQ6u1IEQmRGCptz4j2jJJAsMFEO99pi79JydGaSkrAW9cxrMmWh75blWv8Q5dvtBcdpIqfYYp+P5VDD+fLosneWP6WxAYi99RaCTm1dZtVPCi3SfjQy9rP9fbHbi+EW/snQVaZJHto/5iKh2EPVXcnldKw1G/LmV13ocIR7bQ7Ao17Jd/xeTiXFOlHwfnEefjTij/rRHCXMM/C2Gm/52wXLXBZpJL2ABsiOneHJATdfFsPU2oRFKJ8pskJ7AGO40OqRzAQ4VIGA+47bMtXMInbutv26sSV4xvp02EaKXPmYk4C2K/ATyGXLyLsLeJDZMkZvVszPTpIzhSSc+zSf8ghrOmHmLISjzQaDDag+iHB7J91qKyYGI/ORRJ9hi4Q/siys16i15ehXX4wDCBitY0MRnItZP2irK5UiulT7QXvdjIALQcwvdSqxqllnZf5vAWB1JB2BOQmKaIb7kdkJWMUQCtEKh5UCi3uECja5EXUuzho9UFnGqliSI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 1/5/26 9:58 PM, Brian Foster wrote:
> On Thu, Dec 25, 2025 at 06:08:08PM +0800, Baolin Wang wrote:
>>
>>
>> On 2025/12/25 12:04, Barry Song wrote:
>>> On Thu, Dec 25, 2025 at 6:01 AM Matthew Wilcox <willy@infradead.org> wrote:
>>>>
>>>> On Wed, Dec 24, 2025 at 10:40:27PM +1300, Barry Song wrote:
>>>>> From: Barry Song <baohua@kernel.org>
>>>>>
>>>>> Uninitialized folio allocated in shmem_symlink() may be accessed
>>>>> during swap-out, causing KMSAN BUG:
>>>>
>>>> This would be an unfortunate way to fix it.  The vast majority of
>>>> symlinks are short, and we'll never access past the \0 in normal
>>>> operation, so we'll be dirtying a lot of cachelines essentially to (1)
>>>> shut up an automated tool and (2) optimise a corner case.
>>>>
>>>> How about this instead which delays zeroing to swapout?
>>>
>>> Matthew, thank you very much for your review, even during Christmas.
>>> I would like to wish you a happy holiday!
>>>
>>> I am not quite sure, as shm symlinks do not seem very common. Since
>>> allocating a folio requires a symname longer than 128 bytes (where
>>> 128 == SHORT_SYMLINK_LEN), such cases appear even rarer.
>>>
>>> BTW, do we need to migrate the owner_2 flag in folio_migrate_flags()?
>>> If so, I am not quite sure it is worth changing the hotpath to
>>> accommodate this.
>>
>> +1. At least for me, using the 'PG_owner_2' flag alone to mark this uncommon
>> case doesn't seem quite worthwhile.
>>
> 
> Also JFYI the post-eof swapout zeroing work (still pending) looks to me
> like it would cover the swapout time case [1]. That's just if you wanted
> to go that route here; creation time zeroing for the large symlink case
> seems reasonable enough to me as well.

IMHO, your post-eof zeroing work is intended to zero !uptodate or beyond 
EOF folios before swap-out, however, the symlink folio is uptodate and 
not beyond the EOF. I am not sure if it will make your code more 
complicated when you want to cover this symlink case.

Why I prefer Barry's fix: First, the symlink folio is marked Uptodate 
after copying the symlink name, but the whole folio hasn’t been 
initialized, which seems unreasonable to me. Second, as I said before, 
using the 'PG_owner_2' flag to mark this uncommon case doesn’t seem 
worthwhile. Currently, IIUC the 'PG_owner_2' is only used by btrfs; if 
we ever want to remove the 'PG_owner_2', this uncommon symlink case 
shouldn’t block its removal.

BTW, as I said before, I've reviewed and tested your post-eof work[1]. 
Maybe you could resend the patch set so that Hugh can take a look when 
he has time.

> [1] https://lore.kernel.org/linux-mm/20251121152246.1023918-3-bfoster@redhat.com/
> 
>>>> diff --git a/mm/shmem.c b/mm/shmem.c
>>>> index ec6c01378e9d..f3b3be1b50fe 100644
>>>> --- a/mm/shmem.c
>>>> +++ b/mm/shmem.c
>>>> @@ -1636,6 +1636,13 @@ int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
>>>>                   folio_mark_uptodate(folio);
>>>>           }
>>>>
>>>> +       /* Zero out symlink tails to help with compression */
>>>> +       if (folio_test_owner_2(folio)) {
>>>> +               struct inode *inode = folio->mapping->host;
>>>> +               folio_zero_segment(folio, inode->i_size, folio_size(folio));
>>>> +               folio_clear_owner_2(folio);
>>>> +       }
>>>> +
>>>>           if (!folio_alloc_swap(folio)) {
>>>>                   bool first_swapped = shmem_recalc_inode(inode, 0, nr_pages);
>>>>                   int error;
>>>> @@ -4133,6 +4140,7 @@ static int shmem_symlink(struct mnt_idmap *idmap, struct inode *dir,
>>>>                   memcpy(folio_address(folio), symname, len);
>>>>                   folio_mark_uptodate(folio);
>>>>                   folio_mark_dirty(folio);
>>>> +               folio_set_owner_2(folio);
>>>>                   folio_unlock(folio);
>>>>                   folio_put(folio);
>>>>           }
>>>
>>> Thanks
>>> Barry
>>
>>


