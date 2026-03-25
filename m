Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00BD4106B535
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 13:28:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E4076B0089; Wed, 25 Mar 2026 09:28:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194C56B008C; Wed, 25 Mar 2026 09:28:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AAE26B0095; Wed, 25 Mar 2026 09:28:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ECB906B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:28:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93AC08C64A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:28:49 +0000 (UTC)
X-FDA: 84584665578.12.31C20F1
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id B6A97C0002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 13:28:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CS4GovSL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3DePDaQgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3DePDaQgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774445327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ugI4fJPLVgpKdhxQIMsmcwuVQPmlpxkDqu42ttwGwnk=;
	b=Xkv3LDrJaBArI2kqdqAdoAApgZSGQ4+DVOkKOsdaWhpvJn+5is1iKiib058u1OhX8wgBGy
	tx5m9lI7QTPa2vboC5AP7BuMwHQM5t8tefJmVuVA3hwQ3MM8yBw+kAm/cHspdpNU5j9Ja5
	u46nexaSWa0B3zGAIOUWnUlsRSkvJa8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774445327; a=rsa-sha256;
	cv=none;
	b=j4N/V3M06al2EF105rEMAE1wEqs6rkOeDBlh+08TAWteIt3QpPpRZC0/TaopbDK+rG90hE
	snETRGMIV1GtGlUnI4qyUHRCwJyK+we6Jhrqgx8zZc1AT5KitdPm3vDGqedZjC6oS9Z6MI
	kpkE1dkAwJpPq+Gpm4CyPR+HDVqusvw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=CS4GovSL;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 3DePDaQgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3DePDaQgKCDgdUWegUhVaiiafY.Wigfchor-ggepUWe.ila@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4837bfcfe0dso54511845e9.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 06:28:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774445326; x=1775050126; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ugI4fJPLVgpKdhxQIMsmcwuVQPmlpxkDqu42ttwGwnk=;
        b=CS4GovSLdxYpe3+o6CtyY27ierBsC+J18vgYOcQYhEw60zz/IXyRp+CG7NJYEgPVf+
         bZF9n1EGXWmXsadfrgTKNjDmtlfziLRlFT7q3752mrFqM1D8mzMTJi0/x+Zxme4A8A+i
         DVOO/WSYSALU6kEkFA6IbEs9Nj+Hqs5Er/N9Q1d8NzZZQNyVRZPVgG20TSuMg08jAnXm
         eSWqBVrDvHS8dxLh8UJ1ZashkZLxK2KyUk7JAiN7Mruz0BpYXOxayqwnCJ2637mj1J7H
         x3bCyTIfsOaPGfZeYkSYKswzOaDVPdEh0hATTbPOtw91y9qkolWasETX6GE4eThTm/dA
         XftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774445326; x=1775050126;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ugI4fJPLVgpKdhxQIMsmcwuVQPmlpxkDqu42ttwGwnk=;
        b=UNW4yBWF8ry0xt2+5IjJFMVJhtzyIlqGJKRXdMQ1ms3MzweMWF/bydOWHPKYnLmpwH
         0LZ24Ncx0h3+Exatpr7ssmN4Vy8tDVxEL6HuID9baXU8VsGx7x2QX34SyDfighfmN1Tc
         mAA9DDEuWURZE0q/QxlFVRXano2DIq2WhC21UU7+4bQuJxk1ajcnIE6iqO7SNy8y9t+6
         eErkDF5Qdznj4Ngw40JOn8KkfgdYs9lFnw3WrJ0EfkZkTFP8x4/KXjYQ2KCNYzGkotAK
         1uRbUDkaVADoVsmJdfGDlnGkOQSHQSX63rHlfC5LWuormAyH2Ki7l04K9v+8BePda1IN
         /feQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLRH7q6at3IS6FsaDYQryxCiRXMOR7u/Szat0nAoLotyUWp68W0dlp0vKeUE9T2lx+PnvE4mZTKA==@kvack.org
X-Gm-Message-State: AOJu0YwfT7Bgi/IJXF6bqNT66hBA5i7zs/Hs6sN+4wh+re5HUOKrDqWW
	Y1/QGNFaa1o/pVqQUFItcDu7vDnFcGgikjGoN6b0M1XJ1vDqV07s0UM+dX2FMCjavUtVZZdYHQ5
	XxR0aM3mfiuVLBQ==
X-Received: from wmpr8.prod.google.com ([2002:a05:600c:3208:b0:486:f89b:7f11])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a088:b0:477:b734:8c53 with SMTP id 5b1f17b1804b1-48715fef727mr52438045e9.12.1774445325853;
 Wed, 25 Mar 2026 06:28:45 -0700 (PDT)
Date: Wed, 25 Mar 2026 13:28:44 +0000
In-Reply-To: <20260324152702.GLacKtRrAGFea3FGqH@fat_crate.local>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-1-28bf1bd54f41@google.com> <20260324152702.GLacKtRrAGFea3FGqH@fat_crate.local>
X-Mailer: aerc 0.21.0
Message-ID: <DHBWDCP23TEA.2T6XAJXUTG5YB@google.com>
Subject: Re: [PATCH v2 01/22] x86/mm: split out preallocate_sub_pgd()
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B6A97C0002
X-Stat-Signature: 7nf87ycu1699jr7ci3zbb3qshemgdzqp
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774445327-864835
X-HE-Meta: U2FsdGVkX1/uvYZxG8AV1/ILojTr5SfbhHFsLtAY1g1WyOdlwlz6oGGmhV8ZPwVDT6EekoOCVYkG+88BxaMEOXAn8yyq9LUIYyJ2mlfuRtAMWceQFMip728UTV5SBiXHerQVrLjevzcoNh2/YrQtHFbKa+HncdpqMZryQ47c/yMcqdjD7SQR9GwSlyIGEryaEj0gHstOlqGsDbtbsf5TzwNpz4S12RsbI/sgL8aTnbUyiKY7QySNddZ2d7dd4hK22f/hvmNw4p66Ra7cpCNR4fDEVTvuPNZLhXnUFa9wBlCr1ukocQFurlKrd1kgF9sARJ3VONSUvkBVaBxU5CASORJ5j67PFGSe1m6l/8WmcvUzWm0ZhPA4cCCyTBHrPNQoYbnXjTfgoI+pd4xRzfLs3VkcsS346WRrgWaMOq0bzS+4iXFRyNc8x+iKyaA3sHHl8otOGBEKiEyvjR3rpSeHFtfaSgHZtC5Nzbal8gDL6hH1+9OvucWrMy7WnaH1DQNg7TVVK75np3ir4NlomCcGxFYdmjEkw6QELcWIodN6dhSqHlwidXbO/Ev+Q/6hNYSUdVOJQEtnx9u6zg4TmuZ6qCXoRGWJJKdQGwn5P2ink7179KDVazVRqHHsLuv+fy4wD2PT07vngfLCWmAVSk1cuH/kGTlu3LRYlHXnO5e5mzbUypplP7IUxzudTdnbYq/hzqZ6WD6AEVO8Vd4Td533E0a0iAqwWZ+glOPZUNeyyi1rcvCgDEv/PNuntH4WEBbBlz53AoVJbO/+neLxF4AzaVMgqQ5SlVVmKJtFsrA7OS5AsThmyURo9WeHOQVvR9hovbzKDgUNHv0AEsVVl8zBpR3zBA+vDBKx9jwE9ud8jC3HcXqyM4bmM9z3EiqEC14R7Nm3vBRGObGTWv4P/EkbP1/IDZjyjTfxAHcDwxpajtM41SGKi9FYTXFsmQctH83I+qyaDjonfXwAtfyu4ri
 Ft3Fo52B
 nCfD3gvS5/KXwG6frTWp48MbpcGXOg2KsaMgD4pJeDaXusga7xcGd1cl4+4bC8wlr9k8vHVTyTTIYjYs3iiWeG9heHF+BM5dfrronA3G8dT/hp/5s5UTsj41qiHAjlbL4jQiyXsEB/EUBrvML1AXiDJm3uRvY6JGrYfI2puMt8A1u3kWNu2CfxMQVWR7HGN2j1qucE15ufjceKka7t9/x515tnWOtYCK4BMbDjkqT/dkMhLFlkLRiQapOZNBhuM74b06n/9I0rk06nBCSju2zojD9pjjVH7ar5OQPPyOspezGNb8g0pLrJVhPuxbFrfCvByJmG8DoJrc3rC/9Jq8bGPEOckbQ7/T0I65sNVWRfjYOjSl5zOsqdDV/1cRS5S2WU0er3X8CPLXCwO2KQb0vaChiKg6tR9xzgsEssvqF8dDBot/2V+tRnV2/TiSPPNwlGkukrOJK8v1r9iTii+iNmy8TDQfMuxwcpwqVKvNXBO8gCCsMhRYnzEK/ykXuXSUtkwsWc2huqD/Y+UaulsEaeGio5WGbV2vkLisJsGl6O3R5ADwbPakWy5zTpmukPwNWwcHN1Iqdv4rd6BSgflJKtSSOXyIBkp2ha6cIwePDZUe2xTeDaSaHWn/wEpp6u9scWid7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Mar 24, 2026 at 3:27 PM UTC, Borislav Petkov wrote:
> On Fri, Mar 20, 2026 at 06:23:25PM +0000, Brendan Jackman wrote:
>> This code will be needed elsewhere in a following patch. Split out the
>> trivial code move for easy review.
>>=20
>> This changes the logging slightly: instead of panic() directly reporting
>> the level of the failure, there is now a generic panic message which
>> will be preceded by a separate warn that reports the level of the
>> failure. This is a simple way to have this helper suit the needs of its
>> new user as well as the existing one.
>
> "Describe your changes in imperative mood, e.g. =E2=80=9Cmake xyzzy do fr=
otz=E2=80=9D instead
> of =E2=80=9C[This patch] makes xyzzy do frotz=E2=80=9D or =E2=80=9C[I] ch=
anged xyzzy to do frotz=E2=80=9D, as
> if you are giving orders to the codebase to change its behaviour."

Yeah there are a bunch of comments in this series where I've written "we
do XYZ" instead of "do XYZ", I've set up an AI prompt [0] to try and
catch it for me before I send you guys crazy with yet another series
that makes the same mistake over and over.

[0] https://lore.kernel.org/all/DHA6G1E2H5P4.2D7JKTRKIBE3U@google.com/

TBH for this particular case it seems borderline? The referent of the
"this" is the previous paragraph, it's trying to show that the logging
change is a side effect of the code movement rather than a part of
the patch's intent. But there are more explicit ways to carry that
message so I'll rewrite it.

>> Other than logging, no functional change intended.
>>=20
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  arch/x86/include/asm/pgalloc.h | 33 +++++++++++++++++++++++++++++++
>>  arch/x86/mm/init_64.c          | 44 +++++++----------------------------=
-------
>>  2 files changed, 40 insertions(+), 37 deletions(-)
>>=20
>> diff --git a/arch/x86/include/asm/pgalloc.h b/arch/x86/include/asm/pgall=
oc.h
>> index c88691b15f3c6..3541b86c9c6b0 100644
>> --- a/arch/x86/include/asm/pgalloc.h
>> +++ b/arch/x86/include/asm/pgalloc.h
>
> Why in a header?
>
> That function is kinda bigger than the rest of the oneliners there...

Hm, I suspect I wanted to avoid creating new ifdefs in the C file? Seems
harmless though. Looks fine in arch/x86/mm/pgtable.c.


