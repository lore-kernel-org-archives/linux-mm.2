Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB314FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:23:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E66826B0088; Thu, 30 Apr 2026 11:23:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E17016B008A; Thu, 30 Apr 2026 11:23:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D06B86B008C; Thu, 30 Apr 2026 11:23:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB0756B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:23:17 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44ED1127783
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:39:03 +0000 (UTC)
X-FDA: 84715479408.03.19F6BD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 71612120005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:39:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cBwzWdl4;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777559941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=soGB2dX3th9XM1/fd7+XetO33KxQdA/Bvrbxnnw/eac=;
	b=026Mbbu11voo6I7BlwMryloZjMGEApox/wxjLSS4lcdk7u8w3mB5kM/g1m3PPhiTCfdUxn
	BVOfWMKxyRj+FldgZVVjXwa+OgJkdXybcA/EtvJXOyhYZoNKu1/ytivGzcCSXIGd2kpcc/
	+f/jeu3a1DaVQ5kZkaFHgGbpWYL7QLw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cBwzWdl4;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777559941; a=rsa-sha256;
	cv=none;
	b=kYZQR/rfy9S3lKGsH3W7mQBJ4ORaOynO9PDUUxiRPLoaavvprdrCs+DpWgwKdZ4l53IKY3
	jK6bfuERRg4RI/0wSI5/8ACsDg9OqlqxkAblMkdwJ0gvuu4wZAFwGR7mS85fdzJbaIIYob
	kjIffrd/VLwElQYQw7jVgseM6oNdQmc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82ED960180;
	Thu, 30 Apr 2026 14:39:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8E8C2BCB3;
	Thu, 30 Apr 2026 14:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777559940;
	bh=Gc0G/nPCLoAEXLQD+FtiMt3y+teazxkvZICdeWL4IwE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cBwzWdl4yUoKTWgksJJyhKfjlsm+HYb6h96SaWdcDFpiF7ClCSk4qAx1bTgq7rDa+
	 FKoVjMnszAcDwbqPa0iVOyr41ESF7ZFkR5G9u07gp4LlWVCH9NiyGv3SsWmoWdcVxX
	 xwDbu6eNe+rLQnb5bmxcgfrpBtPPAqMU9NCmIjMTRxyQcvZ4CV1q+80rQaGS+kCB91
	 nMvtPIOaueYC+KE0Rx6vg0lc/Kea58oohq/4yyOWLEHBm2HrDWkybfShWaYDi4I3mb
	 ggKnEZUOeN22zGA+0BNy8eRx0cNUOsva6ja+PAxJSVIkxaKm+Gn8N3umLqaRSJn3wu
	 opFKU9opqxYlQ==
Message-ID: <af21185c-3390-4566-bf28-ce79e13182dc@kernel.org>
Date: Thu, 30 Apr 2026 16:38:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 2/3] mm: process_mrelease: skip LRU movement for
 exclusive file folios
To: Minchan Kim <minchan@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 akpm@linux-foundation.org, hca@linux.ibm.com, linux-s390@vger.kernel.org,
 brauner@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 timmurray@google.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>
References: <7c7da8ae-cd39-4edf-b94f-c79ab85df456@kernel.org>
 <aevBRh08X4UTMUj9@google.com> <ae8NT0tLt7eBmH6j@tiehlicka>
 <CAJuCfpHQdA7C50V2WjNrdYcp7feV5ukgxJf+vMNEcp0P1SGEow@mail.gmail.com>
 <ae-Zu-VAzAA7SdLa@tiehlicka> <ae_roPR64e6sY_fN@google.com>
 <afBaJLLFigkdszov@tiehlicka> <afFco71vwmpQy3pk@google.com>
 <afG-4hq7Hr62Uu6J@tiehlicka>
 <7f98f461-62a7-455d-a7a8-cb8928465946@kernel.org>
 <afJ7FPkNK6cxUxSe@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <afJ7FPkNK6cxUxSe@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r4xzrpn3564q7z1rhrfamysqs89ympqa
X-Rspamd-Queue-Id: 71612120005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777559941-481053
X-HE-Meta: U2FsdGVkX1/iQySQyIdMc60lUbm1hfa73fHcZkGyqrFgrvQ8JsjdSJvi2AI+R6c2N76qkGpTJaSgD55DiWEH8eiie56wrSgysy0aVl7ka5+K5MlBcKK/9aabdXW14j72TzLDRP0HTx9Y84/ZuFilHR1+TL7O3ifyjde4UMJyNNgHSaHdbmd3sSbzEhyawRQtsqg16uqUYei1zS6Rnoc0cne8XlHyT/yOW/CUA8T6UGAboITiAfYXWlfusSZgFRHJJBFSzYfy95jta4P7cGxtpEYNAFEuACV7gisqnLftOBNr0eMiHAx27a5ocbOsa9AsCxSDSrGGgMkc36coVyjSavpkPTV1pSPCrfov/GvcEKnos10P3k9kU9wsOUa6f9nB5LkCPa4+iu7am2TOSDhxSwYc7xvCgn0bftqM3B6focEZMLI25NUsiI0D1/efs42IYtIJTPdBIR0MVwj64MhuYyTfdLtSrB93OYuLZtKgreyaY3xIykENawR4KaHSXqwIwF4PqzwDZgU5GUAmSxc+wn2PwNDDA31kwoK4Lbeq7/nDOTI7JjsDhUmjyiTFD59LM3PoEQexsglM/Std/Bac9x7RX0PRVn6ioOyza5u/BfGXdPzykT+oeaLXbD7yoXDx99HZ+mSQvP70ZyYMhACv8AWkfnJE9N0MwlT1G9Y7Zv5P4swEfk2hWp8aPZ+TY9pBB6Xq7hTMN1dtbzHyxFl2bIroBuBqfypL2xor2qmppZCdE4ymYAav5xwkdtiyksK1srIhnlV3yW6GIQWRx5MDc12/saYMeAtmXWBzq2Z2b3x6rkvwDV6Mqzto5oMlP10vitzsD6IryXdCnBtoi3bkiq02x0rn05x/KpS46LhsF39MNccDa5vVPTC/Kfbl+szHCVjWIVbD8PyJEPB4/NmHqOaA3oNvYB7Uw0TOsQH/AtD2lE7ZBlsBaf4e7PL6/jQ/K+7D0FOHsxSoRKuZuOC
 YoZHVT91
 YefxrOctHMIqlp3L6Y5+4JtRKMff26ExbgBYX4sMmJxZO3AYy0EkTwtoJKe8QYIxAV9XjfnEcIYo07KYd6glQmyb2DYI81EpHUmCjCzbqPIzh91sexFFqKMd5+3QEvbxcdHnLhDYR8qbytpNsPml5HSg1Cqi8ShRYs8E/M3MhNkd7lIZ4e4/sNobSo/xeD5OGwuhCWsDRJ9cWnT4Odmz3/l2BqfI5uUOcYC69a4wN2eJ1jUyRIhCWr33e4c9sQfTGAS8tOSw3mTgBZLfAhCTWXlAC6tpWygH9Xi288rUns3zLQDFZTGJWoh6RUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/29/26 23:41, Minchan Kim wrote:
> On Wed, Apr 29, 2026 at 11:09:55AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/29/26 10:18, Michal Hocko wrote:
>>> [...]
>>>
>>> Page cache doesn't belong to any process.
>>>
>>> [...]
>>>
>>>
>>> I will let others to discuss this. I maintain my position that this is a
>>> hack for a very particular use case and you still seem to not explain
>>> non-Android users of the syscall. Anyway, I will not repeat myself here.
>>>
>>
>> One thing that got lost in the thread here: this code path is not
>> process_mrelease specific?
>>
>> We seem to end up in __oom_reap_task_mm() also from ordinary oom_reap_task_mm().
>>
>> There, we unconditionally set MMF_UNSTABLE to then zap_vma_for_reaping() where
>> memory can be "reaped".
> 
> After updating my development brach, I see zap_vma_for_reaping now.
> 
>>
>> So why is there "process_mrelease" part of the patch subject at all?
> 
> While __oom_reap_task_mm() is indeed shared with ordinary oom_reap_task_mm(),
> I added a boolean parameter (try_evict_file_folios) to isolate the
> optimizations in recent patch.

Well, not in the original patch, that's what I meant :)

> 
> -static bool __oom_reap_task_mm(struct mm_struct *mm)
> +static bool __oom_reap_task_mm(struct mm_struct *mm, bool try_evict_file_folios)
>  {
>         struct vm_area_struct *vma;
>         bool ret = true;
> @@ -556,12 +556,14 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
>                                                 mm, vma->vm_start,
>                                                 vma->vm_end);
>                         tlb_gather_mmu(&tlb, mm);
> +                       tlb.try_evict_file_folios = try_evict_file_folios;
> +                       struct zap_details details = { .ignore_access = try_evict_file_folios };
>                         if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
>                                 tlb_finish_mmu(&tlb);
>                                 ret = false;
>                                 continue;
>                         }
> -                       unmap_page_range(&tlb, vma, range.start, range.end, NULL);
> +                       unmap_page_range(&tlb, vma, range.start, range.end, &details);
>                         mmu_notifier_invalidate_range_end(&range);
>                         tlb_finish_mmu(&tlb);
>                 }
> 
> In the current patch, ordinary oom_reap_task_mm() passes 'false', so it
> does not see these side effects of broken aging and file cache eviction.
> 
> The optimizations are strictly active only when userspace calls
> process_mrelease() with the PROCESS_MRELEASE_REAP_KILL flag.
> (I believe OOM killer is ultimately target of the user but didn't want
> to introduce side effect until we can conclude for the direction).

I'd assume we would want the same behavior for any form of OOM reaping.

-- 
Cheers,

David

