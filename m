Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2294CE74915
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 12:46:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A27C6B0005; Wed, 24 Dec 2025 07:46:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626336B0088; Wed, 24 Dec 2025 07:46:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FA626B008A; Wed, 24 Dec 2025 07:46:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39CE96B0005
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 07:46:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C94061601E2
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:46:30 +0000 (UTC)
X-FDA: 84254338140.19.D04DB5D
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf02.hostedemail.com (Postfix) with ESMTP id 159DA8000B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:46:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L1hmqr2c;
	spf=pass (imf02.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766580389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9wlVlC9b/pS7CL+ANzn0zFPhFeVvWZnrVU3LuyWiWxg=;
	b=0Rqh6l9yTl7rmlDLlaf5QwJjIqcPC0eyTRHONS3WR4edF3dbZ5yX8Z2KPzsjJBd5q315Up
	gWCMr+dmCV+fS4e2cUrNUZpvoRLEYIWBFfL+OYHnIqpie9h2annJW9AFZgZr7xtBzb3Ih+
	HJSMdGwuEf3gKmk2fLOqmnWC0e5Cw6c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=L1hmqr2c;
	spf=pass (imf02.hostedemail.com: domain of chandna.sahil@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=chandna.sahil@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766580389; a=rsa-sha256;
	cv=none;
	b=kgpRKXuu7iGB3ZLdDrJT1clgwEQrIldpNgsW0TZgzwM7dTYk8U7KciNEVoIIaDWBOCZwIu
	r26iGPzI+sF3ZGBKDkuq1IP671BIsuJFxIgqY+rzOpxFwzP+WB2HlMB9kcC9d9eSL1u0Hb
	UDMpjEHPzSpkW4bRib2d+BOVLfoRo+Y=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-34ca40c1213so4939740a91.0
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766580388; x=1767185188; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9wlVlC9b/pS7CL+ANzn0zFPhFeVvWZnrVU3LuyWiWxg=;
        b=L1hmqr2c9kEWp2dV/EptzH+i9SXR1Jt+u+D9SIcSTDIUOHfgZaLtH2kKdOX94YjtW4
         MVkmsjosMA5PLxGl9HaW7oLdHcNmMQJMP/u18cGn0t8PPKnQrL65Xho3yxiLBHYHfMzs
         A1QX/WgoxBZ5E34i9oFecmP4Oj1WpLHp7oVqel7W5gd1iBord0liPy/ssBbLIRPHUFnc
         8Vsupk/kT87cnYg5wVilE7O6owcB3iR5fNlrAF3nXNkYYsjT3k7vnb4y4YPja4k/kPWG
         wrw3O6x/IgkOdf+CBGHHBkYc+IFAudxr35IvKGm5AaPPPTUcIc7Z451/jyZEnW8jjwW0
         dBFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766580388; x=1767185188;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9wlVlC9b/pS7CL+ANzn0zFPhFeVvWZnrVU3LuyWiWxg=;
        b=EKZY+TnJY4lhjfU/Puxt2jG1LPQzwfOsru8nZ3QZyDG7dvCLXyrImjnfS0vfMcfXYP
         C89/whEHTpopSNlYvO8mdLC9qN0wRwXI7Nv1giZxi8pih/dtBGfFyJsjcinyfcq4yi/d
         b/yJP7yh/9rLHoiqULkN2w8moBRLgJHVKBxwdrZBCDw8VSGp0ERRAqTgbM0zFM+sDDXA
         FfQF33ldafLIayZRDE0klqVgoJfEqX5UxcdqD0sGtS3Yl6fGMPnDZ297kwYv9pvx28Er
         9PFJ3nug8B6tbPTJKJHjSaBY8xtVEQoJIjXk28j4T+MTIOuc0BJgvYUQa95TWsywDR85
         7+fw==
X-Forwarded-Encrypted: i=1; AJvYcCUgEmNFcyasPjM6Rfbtm8Cse++2K1Z/qZQ3wVCIjsEMb7V6cuLUhuStDEgucGQ5PfiZT3mWKROmEA==@kvack.org
X-Gm-Message-State: AOJu0Yzbqm/BOFMlHgfihXS+ocw9UIx4cWVGCw5bisLZFkSY1TzlE6SB
	g84Nw156YOWn0ccSc10sbZbMaykqDI1F7kHCyZg7czOst1Y+iFODA9b8
X-Gm-Gg: AY/fxX4/RB8qkfzNDfHBrymbVNZSzfa6zRtfQBhWakp6yYr1+yTL81yIhmaimKZ/LSi
	ODzI1VD389tKGwwkdQb9cDHVs8pNz29DKRptizWIAo1NoN8IhL8cVgipJbf2xHmGmZubMqjRVgK
	9LuU4fsCH9oZSp6QeE1gUoHt7jStG8KXWX0iiGuSW+lQZVz1qsx1Ryb402w4a/g7lzpR/4PNd9t
	q5S0exmo9BQMYCYlnqv3rviy4UsSEVcjEwaVVRJiSQy6NsvGT81XQlK2DSKLG/dpEO8AauY4ulo
	/CcwYVxZOFMi1BygePI2zxfgUv942yCFU3Aj7grQSlhQJkOsApA+cGaTWIKV/olWH59+Osu9ob7
	KJx8ooWfCWwXT9kVnbTZcnGNk19fp6usHUtQ4QsQ9dFvYYIXuPkzML4VrgI3j/iQJ9fXQPMFoVA
	/GbnQ4143MqB+oBSwuJ/syIuyjOLaU7zysemyPfQ==
X-Google-Smtp-Source: AGHT+IHzxQX59o7stHR2OJF+G0uLgA9CwrTfMv5VBSkhhu2VDNJvhwxQrWWgIJkEvKUvhhxyE95gvw==
X-Received: by 2002:a17:90b:5107:b0:34d:1d54:8bcf with SMTP id 98e67ed59e1d1-34e92142ab1mr14054539a91.9.1766580387869;
        Wed, 24 Dec 2025 04:46:27 -0800 (PST)
Received: from chandna.localdomain ([106.222.230.223])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e921b39dfsm15837892a91.8.2025.12.24.04.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 04:46:27 -0800 (PST)
Date: Wed, 24 Dec 2025 18:16:05 +0530
From: Sahil Chandna <chandna.sahil@gmail.com>
To: akpm@linux-foundation.org, Lance Yang <ioworker0@gmail.com>,
	baolin.wang@linux.alibaba.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
	axelrasmussen@google.com, chengming.zhou@linux.dev,
	david.laight.linux@gmail.com, david@kernel.org, david@redhat.com,
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com,
	nphamcs@gmail.com, rppt@kernel.org, shakeel.butt@linux.dev,
	surenb@google.com, vbabka@suse.cz, weixugc@google.com,
	willy@infradead.org, yosry.ahmed@linux.dev, yuanchu@google.com,
	zhengqi.arch@bytedance.com
Subject: Re: [PATCH v4 1/3] mm: pagewalk: simplify hugepage boundary
Message-ID: <aUvgjc_KGH_903D3@chandna.localdomain>
References: <62a2d7ba-e7c3-4153-b227-c08802ca9e1c@linux.alibaba.com>
 <20251224092332.53214-1-ioworker0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251224092332.53214-1-ioworker0@gmail.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: pgnsghcdqcefiporqs56tznoowutbkz3
X-Rspam-User: 
X-Rspamd-Queue-Id: 159DA8000B
X-HE-Tag: 1766580388-490807
X-HE-Meta: U2FsdGVkX19CTF1n/+vOjopG6bSw/p8L0AsviBeVWN3mqDpIVoh3ICP1FoZGdBLya8OqBHSVynzZ/T85rdyhhdLVMDiOvKjpXchvHux/vneY+qum0QkL/85IKaFxl54stSwRGcItNcLJNdI8dlYIczMgLsxR/Xv1cV70dkowAbSWytBJjHdd0w0SLvX3hj/e7No1zMTTRwK804Lk775soAFXKD/GVmMIx8vUzl08J6RCTS/M2x+xrlSSBbyUxAt7h8Y4abIQqkGKEQ22h9G/o62raqAtBS7nxzcgz66ftNeDO3iidhjflGzzNRjc+hGXqApPQA8gmUycso36MM44uA83RUuQXOLcHnUSiar5dDd4sjYnKIpfmOSYICX1cuxej2csQw9grbktlhjky7BAkwcHa4xC6weiFz/5fSE6AWAthMNCckZliIo7g0v1R3kO98BqPN4VE7w0wRJ84TNR2oh0DFZ650/ZCO7xgwmnTKn46v36MoJELM5H6PdT06CyA7o6w44uYqRwUPivmDSnPf4znMJQhByoJTdvUHmlKJhqOQrS8BR49DdQbRpE5WqGZHQAjU6IhvVTx2CFtgE4yTTNxHQuB2rx28lXp+ukasf9Y5nHQqgMFdT9nscVOvJBCCfGGyGMf+bjMJ+iD0/4ULZvrl5KrHRxqOQ+WnfDfXxCuK/Ze3j6cRRllylgd+IStAExpr2ScOb+HKEIbMpRjGxRRsh4gET46RvKXNsuXMng9FUhUKlOKb6P2p0GUhxD5BwwEcwaVd+Sr0rQYzrYLlswfY52LwNZTKZhI8Nii9795VrtthH6RLQsBojVUY3CPl53RB/vzqfz/dIV+vSy1c0vYwuWZWupHDBPNQ8JU4L697P1Bi8HHYQF5qmh4/gr9KO6ggrcLyd98lqKyywjNI0XP4bbEFtAEmBuNHlR/jQFYWiwU/5xB6DCg9RZEzcxvTz0TEWFAoDA2J8Tu3y
 solUJ0Nq
 2Ri3tQ0Q9uyzml80LdnTdJxlzMc43eQ5UNi98zkk2mUJemYOdvv69uTKL1F7k9qzD2AdFfyTzH9OL2z/YWO+EoEZhlZ/1z9A3LjwTnAxdbhLdY6C10M6mYelsTfetzHTeNFm3wG3VOx0gE9X1jWwY0LrA+qhC8alfcQnLl+4o4dn6aYqdwPDmwWbl6b6Rh8CsnwRDs61wVl50A6z2TSAvTnyoLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 24, 2025 at 05:23:32PM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>
>On Wed, 24 Dec 2025 15:50:34 +0800, Baolin Wang wrote:
>> Hi Andrew,
>>
>> On 2025/11/28 15:01, Sahil Chandna wrote:
>> > Replace hugepage boundary computation with ALIGN() helper instead of
>> > an open coded expression. This helps to improves code readability.
>> >
>> > This was flagged by Coccinelle (misc/minmax.cocci) as an opportunity
>> > to use min(), after which the boundary computation was updated following
>> > review suggestions.
>> >
>> > Found by: make coccicheck MODE=report M=mm/
>> > No functional change intended.
>> >
>> > Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> > Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>> > Suggested-by: Matthew Wilcox <willy@infradead.org>
>> > Suggested-by: David Laight <david.laight.linux@gmail.com>
>> > Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
>> > ---
>> >   mm/pagewalk.c | 3 +--
>> >   1 file changed, 1 insertion(+), 2 deletions(-)
>> >
>> > diff --git a/mm/pagewalk.c b/mm/pagewalk.c
>> > index 9f91cf85a5be..9fd59d517f37 100644
>> > --- a/mm/pagewalk.c
>> > +++ b/mm/pagewalk.c
>> > @@ -312,8 +312,7 @@ static int walk_pgd_range(unsigned long addr, unsigned long end,
>> >   static unsigned long hugetlb_entry_end(struct hstate *h, unsigned long addr,
>> >   				       unsigned long end)
>> >   {
>> > -	unsigned long boundary = (addr & huge_page_mask(h)) + huge_page_size(h);
>> > -	return boundary < end ? boundary : end;
>> > +	return min(ALIGN(addr, huge_page_size(h)), end);
>> >   }
>>
>> Please drop this patch from the mm-new branch, as it causes
>> 'run_vmtests.sh' to hang. Specifically, it leads to the system hanging
>> when executing hugepage-vmemmap test, because the program falls into an
>> infinite loop in walk_hugetlb_range() and cannot break out.
>
>Good catch! The problem is that ALIGN() returns addr itself when already
>aligned, causing the infinite loop ...
>
>>
>> This patch does introduce functional changes and makes an incorrect
>> assumption that the 'end' must be aligned to the hugepage size. However,
>
>Yep. This patch is not equivalent to the original code when addr is
>already aligned :)
>
>> this is not necessarily the case. For example, see how pagemap_read()
>> calculates the 'end':
>>
>> "
>> end = start_vaddr + ((count / PM_ENTRY_BYTES) << PAGE_SHIFT);
>> "
>>
>> Revert this patch, mm selftests work well.
Hi Baolin, Lance, Andrew,
Thanks for catching this, I understand why ALIGN() caused an infinite loop.
Please drop this patch, or shall I submit the revert ? 
Apologies for this, I am setting up environment for running the selftest
and will send out corrected patch once it successfully pass mm selftests.

Regards,
Sahil

