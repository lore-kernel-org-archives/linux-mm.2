Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB61E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 07:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DD506B0088; Wed, 18 Feb 2026 02:52:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860476B0089; Wed, 18 Feb 2026 02:52:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 741B66B008A; Wed, 18 Feb 2026 02:52:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC8C6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 02:52:07 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E874DB6A2C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:52:06 +0000 (UTC)
X-FDA: 84456809052.22.4543E7D
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com [209.85.221.66])
	by imf07.hostedemail.com (Postfix) with ESMTP id E13BC40005
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 07:52:04 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y7LecrvV;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771401125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntZdvUFQplwCFL7s1fQ45P/X2oyjzcHIko4bs1V/f+I=;
	b=UA/KOhtfctM8Jge8ICHutZ5P9JjmSAxF04/QoKmJIM5Nt3f6+IMBHEpc4k0wjDmUf9fbHX
	oghqV19emDH/KMsRgzwI+77Eb/vL71Z/ysRw5Idb/I00SEdE6FN8PmQoHk5JTp1jNsjxNd
	2d7bK86Ro3xNXIw9diCmVxgRhJ9bNRM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Y7LecrvV;
	spf=pass (imf07.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.66 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771401125; a=rsa-sha256;
	cv=none;
	b=QvdNaY5pYBWQTy0lqZlik8QZzXXabII6VCGGR9Ueo+aAKarI1MBbl5aTRmdgEpfkkdiRK0
	MX2f+lTLZFVMaqn52J68FQfh7yiIJ77FcYBt7q9t5crx1Oi94f4VnSfGjCw8plYBqi7/KF
	6KPl+RwR9/BfMphfGL6HG38qV4hwcoI=
Received: by mail-wr1-f66.google.com with SMTP id ffacd0b85a97d-4362d4050c1so5697752f8f.2
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 23:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771401123; x=1772005923; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ntZdvUFQplwCFL7s1fQ45P/X2oyjzcHIko4bs1V/f+I=;
        b=Y7LecrvVdqEXmFpcBaZZFBMluktf/2/Gp3RuHQm6WjVhw5x+v7YTilJj75EUQLxGyh
         Ies1HxvPgfmNIM50DWPeYM41QSQw3PS2qcuu7o8S/5aS12/cGVqFChe2IrKrQRDeVv/E
         oJnpzyimU99rKsCvtxZMV2c5UwLUr67+DCC7DzBfwOufuduCAULUgYrl0APRBNfMtjqT
         NR4lwbNcUy9aX/lXADTYXwxzGYf2YAW4d/cDyiwOfefItCTSO9cm7hyL3o9n5uTH9//r
         NKev5Uy3ZSe7k+8rdUFnWxlrxosHIYfP6Y/Q0meZ8bN5El6RzHCan3EunFVc9F/elvs8
         3JlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771401123; x=1772005923;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ntZdvUFQplwCFL7s1fQ45P/X2oyjzcHIko4bs1V/f+I=;
        b=Q2RRnZD/VWytLIkykiyxAz/3QAM54c5cBhDvdiOWjJLDh6erMyp+4Qd3mZY8NIhSMI
         CdrbWVGxgnhfz5s0qFb0m+hMs647ruN3rr0H4im9HAChFkVF02heWgCxLfEW2bq43aEL
         dE3WYvQc7rwTsR3v3mDzCLIS46iVwYujTv+l+9rqyXlYM3y1ZVA5X9IaBlBRri6MRcw8
         sT5TnHhm5jBy5ZUWw3ZyAkacXFHeb3lV6keJ6VFElrDz2zbim8rS7id587nZ3x0JGG1X
         dhX/C+ROM2B12ZqZU65zQULOmMoDGjiEby1xFmARGtvfYL67xUP9mm+t1tSBw6Uioejl
         POEg==
X-Forwarded-Encrypted: i=1; AJvYcCVNpWS2Zs4LiB6MApNwaY+40xNW6NxcKY/3HujvsD24ufu8AVoVKh5a36QlZRNJQTU1PfbgcEPX0g==@kvack.org
X-Gm-Message-State: AOJu0Yw03EGsBXJDgiaXWZVx50uItVfZlS5rPGlfKE4XhlCRs81nu5g0
	ILa8RdbQUgg+grkXgjQX5WHFYrga8dxtzCnz4+N0qbluzkFa6tlDZ2KqjW2v4CDKhhM=
X-Gm-Gg: AZuq6aJq1xyKDhvR7tAbtFLhp8aLOnRQlhthMplBrYXnG50kozbcYKKJGm6LTqbELF7
	vrC4qX+P/t4JxySwIB7tUH0p2bG7H4QV+PJxoa6vf5Nl50tqZH1Iu+MihSZaX4DDik/e+f+Qcaw
	c2M++lv5R6sI7nD5UTpSl6XuL6w7Z5ZpvY8MSNs2YdTDjSg2cG/JCqvX+kd5pNotoQX3r1NTtYt
	PKysXS14bR1eseYrpCyXlARmFIwiIPLg+CpSMsgnAFe/Cfsz9rgUk3RhoN9kgxxNs3lys8tYMdG
	Nl0iYFNAnJMGfa1lyfZimzDffcOSiVdE9hUGkNXY6vjpGRsYG3HpImxtU83UJCC0XQi+vobZBgP
	XeB5qbnizrO0F9mfHcg9jPfKElR5bGgEAfvXwWEIbhNTDia/aUtvnXX0ELcSkdDB37CniG/9kvx
	b215kWRY+1bisVgbmCQ983bot048tIXm1znHu/
X-Received: by 2002:a05:600c:4f44:b0:480:4b59:932e with SMTP id 5b1f17b1804b1-48373a0a0c2mr261220115e9.11.1771401123031;
        Tue, 17 Feb 2026 23:52:03 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4839712324asm13737895e9.3.2026.02.17.23.52.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 23:52:02 -0800 (PST)
Date: Wed, 18 Feb 2026 08:52:01 +0100
From: Michal Hocko <mhocko@suse.com>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
Message-ID: <aZVvoWZDyJFfBqBr@tiehlicka>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <CAOptpSP1zx1akeGkZEuPBx1Fk8uz8rs4_m5c55GwPUROmCGxKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOptpSP1zx1akeGkZEuPBx1Fk8uz8rs4_m5c55GwPUROmCGxKg@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E13BC40005
X-Stat-Signature: rn8houg89zgx11nu476yz4yspk57f7i1
X-HE-Tag: 1771401124-407104
X-HE-Meta: U2FsdGVkX192hdEXdmCTBl87r1obESAOzV6SQv86KXKz8W25qJvsQbAqxAxuL+/Nwd2jglgx0ksuMdM5ft6qBSV6borAaY8ZkyKbt0gGShQk1wQckp815IkFBMem9KlVNTO/prRHIFQKVOSo0R/H/2j3FR5htJXR05WSLHiwqiOZCRAAHcXkFrrqTklr5xmriIbl6ozmk/RncliG+fyaqCEM/uQrAWRsLsZT0h12atTjVJUCRIFZvb/G/nVBHDwOJ889qx9tCFU2fydR7/0hvR84VWd5M0H7hwttbSOdJXD+W4LywHYNG2YnpfKTqA7AGXN6Zh+OZX9tIqaBVsjJz+ba8eAHJC3lN6HuzJhk9blO92rAj6K6PXImNOg64MR3026y9uZjUHuecJa9gL7zrjt6j9g8UvTu8RQNueiRGdvJ79Jzdr8n5HhgxS2H/dK27vASTT2Oqn+QkH9VdBmokfiDQKZOx7zFsH8OqySrw6Wzzh4GUcvHwiUsKkEfMq0tu+gZACwnA9DvQ5kWzjZ5FFT39YWjC/u3MqqDHCFoB7GCYqP41dToORtEbYgG4+mfe5LcNFs5REJMZ+vW53GC0LuOF+Zkv6gvmelEAsLqZf0n3wT37u9vHl5smFplIsyPh9KC6CIFh4q0oTYGW/ePSiqLIL4q5njeX1Dcl5jhsvOt+PnzXAIeGSs8uA9HUaXNm857N+JxE1kz6qdxkCmEDi9KzHaImfp+3YhAwuysR80fgj+oxcfv+FCnErGYKPLhBR3t+H6fgdGp70Rz8GE8eVcwMUHzJjS5M6520Iio83+5yBzkjnSiKwS1OHk1OPdfuNPdjlV4Re2QtSYUkvN2qb64vPosNNrDnt75YqJgUcJDHlqzidDGwH5fQH7NUvOVE7Nq8QCcDRKKgwDxXk8sf4o2lodXhMO4ShEEMvH92liz6hsjvVT3j9912kJyPVFEz+YuqOmCglB5e7xYMnJ
 uVZ4pciu
 i/211LZlcmJZAWU3oQ8IwrDWgXKYVNi+s5neQuKqboXASF2oxiTMAs8XBEj/UoWoXcYRwBal8sifvEc3CoQqGRhUCs/jZbfXWRALAZeNwSrFzhJllVf2DfxS2VlwVBgrsnjQM7NVgFi4ylZgdhUAFWnT3FNLNxgEv1mMnV9uYe7q+yW1+8/K2mnJ+KPiK47LU5qNpaxedpyI1hi5P3nBoDs7DQ02I5B0XTEGEMiigAve7mY/6gu9RKGW+YhBBmG6AgIdqC1NE3M/aFB7E0kb5OyFF1ihCJLnJ2HpO2Hw3YXmj8NlEgRn6++E5Xb4F+AltK96cpDgrBGO/BEpwQy4yTu9VG9w+yYYwf3LhplPWqlbw24MAkQzAP353Y86zBZFTbhSP5gWtL0/D0CPSdqKR+eRg9sh1aoWc1zbvJAY1k1EaJyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 17-02-26 23:22:20, Wenchao Hao wrote:
> On Sat, Feb 14, 2026 at 4:45 PM Wenchao Hao <haowenchao22@gmail.com> wrote:
> >
> > Add kernel command line option "count_zero_page" to track anonymous pages
> > have been allocated and mapped to userspace but zero-filled.
> >
> > This feature is mainly used to debug large folio mechanism, which
> > pre-allocates and map more pages than actually needed, leading to memory
> > waste from unaccessed pages.
> >
> > Export the result in /proc/pid/smaps as "AnonZero" field.
> >
> > Link: https://lore.kernel.org/linux-mm/20260210043456.2137482-1-haowenchao22@gmail.com/
> 
> Sorry for the late reply. We are now on Chinese New Year holiday, so...
> 
> The original goal of this patch is to measure memory waste from anonymous
> THPs - pages pre-allocated on fault but never accessed.

I believe you wanted to say "but never modified". Unless you map THP
through ptes you have simply do not have that information. Reading
zeroes might be just what your workload needs (e.g. large sparce data
structures).

> On memory-sensitive devices like mobile phones, this helps us make better
> decisions about when and how to enable THP. I think this is useful for
> guiding THP policies, even as a debugging feature.
> 
> Let me summarize the discussion so far:
> - Matthew Wilcox questioned the value and raised concerns fork but haven't
>   exec path
> - Michal Hocko criticized the inefficiency of scanning zero-filled pages.

Let me clarify. I am not objecting the inefficiency. _If_ you need to
recognize zero content then there are no ways around. I have merely
mentioned that the overhead is not negligible for /proc/<pid>/smaps as
you suggested.

> - Kiryl Shutsemau prefers a system-call-based interface.
> - David Hildenbrand acknowledged the value and suggested implementation
>   improvements.
> Please correct me if I missed or misrepresented anything.
> 
> I suggest we first agree whether this functionality is useful for upstream,
> before discussing implementation details.

Completely agreed!

> Reasons why this should go upstream from me:
> 
> - Anonymous THP can introduce real memory waste, but we currently have no
>   good way to measure it.
> - With accurate metrics, we can make better THP policy: disable for
>   low-utilization cases, or early-unmap to relieve memory pressure and so
>   on. This is especially valuable for mobile/embedded devices.

While I agree with your first point I am not so sure about the second.
You can easily run the same workload with and without THP enabled and
compare the rss to learn about a typical internal fragmentation (there
are several layers of precision you can influence - only for process,
madvise...). This is a very crude estimate but it gives you some
picture. Is it convenient. Not at all but likely sufficient if you are
debugging a reproducible workload. 

So I would start by explaining why this crude approach is not really
feasible. You are talking about early-unmap. How exactly do you envision
this to be done? I mean finding zero pages is one thing but how do you
make any educated guess that that particular sparsely used page needs to
be broken down and partially unmapped. What kind of interface do you
want to use for that? MADV_FREE for all zero subranges?
-- 
Michal Hocko
SUSE Labs

