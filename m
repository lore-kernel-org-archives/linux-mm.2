Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E27C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 08:41:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FC836B0088; Fri, 28 Aug 2026 04:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AD496B008A; Fri, 28 Aug 2026 04:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB7416B008C; Fri, 28 Aug 2026 04:41:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C084E6B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 04:41:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 08246160298
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:41:13 +0000 (UTC)
X-FDA: 85150033626.03.45E6D56
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4CF9440002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 08:41:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HyaHVJN7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787906471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hF7W6IgkqW3BA6qKiN2sGuxt00zyQz6GHtb2s+mggXw=;
	b=a4Y7dZcYFtkspCkKEctWlhZWC/etVcmPquZoEBBsusDvPLGkPVHbXvCJ6tBNRcBnXFBAQY
	s6wAL6drjNiWcvTH+WBCzHux59Ox7JO9yFWqKvVBsWLhiqHs3lTjwj6CG98y3U1P/pbD3r
	j3K9+HtaNjUdWiQ8SGnVuxzo7cRL17k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HyaHVJN7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of hughd@google.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787906471;
	b=DSxtg7p2+EWJUXDbBZj6c04b5zZ6xpSgKbNVaEJwM9jSdHp/LVunmXBGzLvqupTCyfH+//
	XlXCSvdMWhxExVdT0YWFRTbkYqHqJaE/7LyolWMjxL9EzbVzM35oJIEteZ9NH+S3sb4BPr
	kv49ZYEUcRGAnpeibV07gyg79j6Rm4I=
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-854f9c32c76so32516387b3.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 01:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787906470; x=1788511270; darn=kvack.org;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hF7W6IgkqW3BA6qKiN2sGuxt00zyQz6GHtb2s+mggXw=;
        b=HyaHVJN7DP/7buIsAhoiuGjYBpJbs/md5pP4XrdHTya0TbcEEVXCzGfFOcrNnI1Pqc
         pkOdIwZ89M3NU80b0oXgUQqSswsaKk6HWm6CvajA/4HClL4ez9VE4MwS6WXlDMbwdloz
         TbsC05yIwhNpLRarYmCo1yJ0A3ljTEaCgGqmrkfBThsXHKW9cNzodrJ9OtMhIrQs/Zj4
         Ut6SpOafsMS2d2Gb4MLdWLIa66x0KM809oQiC4hfxTrwhVSd5Wq8mpuMIgplcsbeofXE
         l1EXkAT2hm0/1XgKOah7LLtzOVeLOd4N8jJtrPY4hQRiMPHSg+aIWHp2mWfmnmo58mne
         Kf5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787906470; x=1788511270;
        h=content-type:mime-version:references:message-id:in-reply-to:subject
         :cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hF7W6IgkqW3BA6qKiN2sGuxt00zyQz6GHtb2s+mggXw=;
        b=O8nhyKqbVmboo0gu6WeKji5qfHxIE1B1IH8eD9LhgGFhCs+AOzgniIXHqnY9tSC1Fu
         uZg+UoPHyQCtKzhQuTdOdrWmVYuIUakdcCc58rz0zK7wTpl2BlYDX7C5z/jg16PwhCib
         6m99d1UrrqHbHBKaoUtSnrUcl0olOBPsr83YSH8wVpti7yJtU5WgDWV1KZE8jjOKWC5k
         FcEl/yhQutALUA3huknM+dAI7IUiUfNXAFkNAzqTVcF52QeSbTxepQEu9MdxVdEtLO7c
         tvvE832x4+yJBkuxh8FTYSoTlf7FDNxP4hOngeOPuXlV3iJxGr8BHacKY1+Kp8cvnl8A
         Ty/Q==
X-Forwarded-Encrypted: i=1; AHgh+RqSmEKVQ6qKDGfBZFgdOlsCnizm/tr5VlGsLhKyN04y8+hZccobL6I3dcCKMtITMS3aiNqNtTd7vg==@kvack.org
X-Gm-Message-State: AFuF++ncsflBvFfE+DBrNoxeQLazbF2nSL1Y20FfS9vZFU6MigChO+JH
	Ke/4l5FGY/PXl9E4LTQFTO0PuCdesu8bCTUui4dnt/5WF+7lE/KCFNxwr5HelAZGVg==
X-Gm-Gg: AR+sD13DIoI6XykdHPr+jq7/LahbAi//I4Yh2CPnMgSBeWj7VacGNC+imuu/yojw2CC
	JN1yhKMxqTYk10IRUAJFjLxNioItBq1HF5Extmit7AcS6S+asbfD1OsryEZRb7EmxjnBgC37OVK
	yJS1aPM+cr5STvzdK4tXv9cn9UrchYHLfn+KOqXThU6wTQ3+kzs/W9Rw3LK6M4BUWxjsaNCTck1
	MYA7bWJrmhJDTUrO1r/ky3gk4S5kJ252KeyWJikzJlwhPdfXTDzeK0Tq0hQkeSOGKTNerD/Xvnu
	poO4oDUvHIvVIKYsjQ5ycgpKbdULyk/uVU2JGgZZ94zhPZULkr6/X2+XHx5S5cY8Lbn6knRVgG1
	D3ezTuI8bmeyzS508k47rXt0snnPYXd8OmJHFHoEXPQghMEYLnfSBNDxsjaZjDEC89QbkQq4QMM
	D8qB09ekfTx+6+UMX6scoj05il+06v07VfF3JrVK4aJKY05XrVNSo5MtqodqrNlYsVgEHiAKyge
	tJKHK8JSAm/wX39xdmZXqv33ruVrOotOGV2ScK5dizzVG4k
X-Received: by 2002:a05:690e:4181:b0:667:8644:fb5c with SMTP id 956f58d0204a3-66e1185c3a5mr4866839d50.16.1787906469125;
        Fri, 28 Aug 2026 01:41:09 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-66e4ed15430sm508418d50.15.2026.08.28.01.41.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2026 01:41:08 -0700 (PDT)
Date: Fri, 28 Aug 2026 01:40:51 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: Kiryl Shutsemau <kas@kernel.org>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
    Ackerley Tng <ackerleytng@google.com>, 
    Alexander Viro <viro@zeniv.linux.org.uk>, 
    Baolin Wang <baolin.wang@linux.alibaba.com>, 
    Barry Song <baohua@kernel.org>, Binbin Wu <binbin.wu@linux.intel.com>, 
    Christian Brauner <brauner@kernel.org>, Christoph Hellwig <hch@lst.de>, 
    Christoph Lameter <cl@gentwo.org>, 
    Claudio Imbrenda <imbrenda@linux.ibm.com>, 
    David Hildenbrand <david@kernel.org>, JP Kobryn <jp.kobryn@linux.dev>, 
    Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>, 
    Johannes Weiner <hannes@cmpxchg.org>, Kairui Song <ryncsn@gmail.com>, 
    Lance Yang <lance.yang@linux.dev>, Leonardo Bras <leobras.c@gmail.com>, 
    Lorenzo Stoakes <ljs@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, 
    Matthew Wilcox <willy@infradead.org>, 
    Mel Gorman <mgorman@techsingularity.net>, 
    Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@suse.com>, 
    Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
    Oscar Salvador <osalvador@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
    Qi Zheng <qi.zheng@linux.dev>, Rik van Riel <riel@surriel.com>, 
    Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
    Shakeel Butt <shakeel.butt@linux.dev>, 
    Suren Baghdasaryan <surenb@google.com>, 
    Vlastimil Babka <vbabka@kernel.org>, 
    Yang Shi <yang@os.amperecomputing.com>, Yu Zhao <yuzhao@google.com>, 
    Zach O'Keefe <zokeefe@google.com>, Zi Yan <ziy@nvidia.com>, 
    linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 07/25] mm/fbatch: LRU_NEXT_ACTIVATE bit to optimize
 folio_activate()
In-Reply-To: <apAllneItXmyjRPo@thinkstation>
Message-ID: <7b30ca86-dca6-83b7-a632-180e35ed2a0c@google.com>
References: <14a16945-529b-8bc0-ab38-3ea97e54e223@google.com> <16b39f43-d91e-7b23-900e-90cec13837ff@google.com> <apAllneItXmyjRPo@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: a73jee4sn91t3455jhzn5dqf7wqju4mw
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4CF9440002
X-Rspam-User: 
X-HE-Tag: 1787906471-718574
X-HE-Meta: U2FsdGVkX1+D3UXT3jUTkM2tOLcOXq2io0LfM8AutB48QoMZJVwlkjdH/r8ARYwG1mU8IGTH8CqYZg5pQDCUjc6M9bbpVl92u/lcQ2wmPRVRFvsBqCbWX8+t+kiK/A8A75Vd06m5h8CQRSnVwT5a6gqQ4FrUpLBNBcRnpPntMd2V4KWwPd8k5/A+hfnYvdUfWPnO4N6ZP/Q3WwSQce7QLnehJuTt7EP+SRVnZ0mV4IzTSvWgWhbmZYcsNuHQxVTUf6AcJjmsHyedhNH1e50tHv7YweSIpwUdVkX/Bm8QQr1b1GV06ioc/U8XM6eLqQSgg1a/Ex7i7gXkXoYbH60I+K+ToMpMtYFGzxBq0GAs6L2WvetZ53heMPfNR6yZjn3r9CKvsshG/ErMjjUYwpTPv9MHdHgLoa61IVg/QYVri3z57MhwOdnRglmcAQ4ll4Q1ZmjNFNIkpyU7JoXoQ84vjjjk8eCEjo0heafFUF/JsC11dj4jxT+AKziFg6ypKo6cSoedrOjZbcNGjRJiZN7s/grPF+dj3Gb3L9gEA1zveuuDO6A5cIQyEBhgj9CCN1YtkiCjbuzUqe9z9FU00hFMstrSMNdceYvtJ2ENze1jKvtEUttTOYG+OPAa5itM0lrI0w7qqpOG2tu7/CDgrv+XX6YwC4/pt5ycRAPyr5SNAE0xK+Zmyv+uvbXvOdttSktDpblVSsRcFEzn7yZ7K+IpzqiQ/J1p7kqDqOR/SOgOzKAW1sAGl/9OFD1ULuR1O5AFR0ERsO6uZRPh67KQpBfEFLZtiNlFRt0hst4TSinxrUzJp9nr5EllFkmnuos8ppLy4Uz2zlO7zUTr/SxsVYJ/G/AIval0XKRgqgnEPJnFG1lbRt5Fde9EpAw6wT8lY1qX3cpcZ1eBMiTmg4jyGVF32KHx8UXSwx+PajJQsqlsueQ2EU3A28CuAJqwoTYHGTq9WIPes7t4L++bhZBDQwU
 5lyxevJ+
 ilqLmiWpsjyom/92UAo8lxpu2nweypt66hjYkMRCwxnpREO3w1FKN0f6UcbFx+/5uK6lGsG//Tq7LyXKYLOPJNXF8ooxvOM9jMpEVsm7R++z+o8BENnNAjQ2qAE0hywk3g3mXNHtHqqvVZzN8bzVv2jMCorormUolWngOv2lfHwYedGxZQ6NtXMtyUmTlT1UW5S/kd1GkBK+40TKPHvPVqmxNxhjOknYmCpp+xmRssuHQj6mvG0zqYaQv9fGJEYv8NqT6qShDs6L2Uw3FWIFDF/3ZTufb7gjd2RHaA3YOLP657cCokWUIi1CK7dDYHvAV4o0MEO7a2O53lPHXyvTVQ5dvjAsLIkdLYRn/AfG7wTmvd8NW9XfaE41hEBkF/FkeapFkQGv0d0tUTh91gOQSnpjwbhJU9uBTRTjagQnpT9svkeJbhCpbc1w1CQkrhuNFESSvmfzpYz4ifr5AKdFKpkrJJueEO0RJymz1Jdy7TsvO6TY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 27 Aug 2026, Kiryl Shutsemau wrote:
> On Mon, Aug 24, 2026 at 07:09:34AM -0700, Hugh Dickins wrote:
> > @@ -355,6 +356,8 @@ bool lru_add_del_folio(struct folio *folio)
> >  	/* BUG_ON(folio_test_lru(folio)); */
> >  	if (!(folio->lru_next & BIT(LRU_NEXT_BATCHED)))
> >  		return false;
> > +	if (folio->lru_next & BIT(LRU_NEXT_ACTIVATE))
> > +		folio_set_active(folio);
> >  	folio->lru.next = LIST_POISON1;
> >  	/* BUG_ON(folio->lru_next & BIT(LRU_NEXT_BATCHED)); */
> >  	return true;
> 
> folio_activate()'s try_cmpxchg() can land in between two lru_next reads.
> Logically, it is safe but I suspect KCSAN would not be happy about it.
> 
> Maybe READ_ONCE() here?

I expect you're right, and I or someone should add that in due course.

But I'm not in a hurry to do so: I did run KCSAN while testing before
posting, and amongst 770 KCSAN reports did see a few which looked
likely to come from these changes - yes, something in lru_activate(),
which would be the WRITE_ONCE() end of the READ_ONCE() you suggest.

I decided it was more urgent to get on with posting the series,
than take another pass working out where perhaps to add those:
needs a different mindset.

I'll grouchily get around to agreeing to add them: but I think
they hurt readability, and I'm surprised that KCSAN doe not object
to almost every line I've ever written - that's what we do throughout
the kernel, make racy unlocked choices to minimize overhead.

Do you have a head for smp_mb__ barriers? I'm more anxious that
I might be missing one or two of those.

> 
> Other note, page_pool (pp_magic) seems to be using bit 2, but I don't
> think there's a real conflict.

Yes, again not a problem, as with bit 1.

Hugh

