Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B175F45A15
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 01:02:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F696B0089; Fri, 10 Apr 2026 21:02:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DF106B008A; Fri, 10 Apr 2026 21:02:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F69C6B0092; Fri, 10 Apr 2026 21:02:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 601BA6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 21:02:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 003AEE3581
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 01:02:47 +0000 (UTC)
X-FDA: 84644475174.03.AA92623
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id F32DE40012
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 01:02:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mfc/iL/4";
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775869366; a=rsa-sha256;
	cv=none;
	b=WPmHEtzOB9Pzy4SGF/f/WLKLnAf8nzbeR2lETHEvWQh1w7QuKxd5PYlyEqZt2cLBpN53sy
	uc31MG520Fw0jEGcaAGCXQQxR2jN8PALoD/9tbIvAivFP50CKzgkCfF83qHhx1EMFEwHou
	tHYfgWHTZb44C9NbuwhzNfvKYH4aF1I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775869366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJAI4uBjM3NK5AkUVYuA3IjJ2co8UkAPxCPAsZ5wXrU=;
	b=aBeLRYZmM4S4DAlmlzXEuwErZpRCDoIBI+WmLuDHozi52DMCxC4CN4Nd/01cNR0lvGNhSV
	v/aZ/Rd4WE5UJWn0u0z0rU8nJaY+OsXcumRm4AiC9s1HscYLeU6jsH1iWjgL5/p5VRXbSh
	H9CoILvTgJqRVpk3TSQSvSqCTMw0dKY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="mfc/iL/4";
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C903B4455F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 01:02:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 671C1C2BCC6
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 01:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775869364;
	bh=5tPIoFmVJ07KOPIR71GnzxoVDBapjkfgu8eIbgUDQms=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mfc/iL/4eBNq9QTWduXtb72hX8hQvf7tSgV0bvKyYxP6mwwYNbkPXY2bjOSLcEuTJ
	 3khOkyWi9W6JYGbNtSfozE8Ua4k9tjBCr+GZbHW2v4d6Rg8K2uVKZbaguggqrnyn7Q
	 oyqD5cbaX+u7xhOcE67DmkN8wiab2G5KZjRxP+N/YtUlwgdijWDnGPXsvmPgUVMRMf
	 wZjOe53OWrfVohgY0OLN5i46ajg2Ef5ImLmLWMjHui7xl10296HBH4qvAOVdoqYIWy
	 bq+VXHqu8+Dodh3oS6nQ2yZnr6pKm0mRHlSfn2YQV9vDQlvCoibGCQrVjl8Yook+Um
	 u0t74YB7OW5mw==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8cfd44fa075so314352485a.0
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 18:02:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWxoU7orzdgKBNwwsnvTs6ttyZds6gIGN9ghpL7sjWgJVIEBh9FEQznKVI6Yg/OoW91fYDVHBHDBA==@kvack.org
X-Gm-Message-State: AOJu0YypBrbQoJKwfL/n4y0cS+iUGZv5jq3hbW8GjkigFcCVXHIvllg4
	V87Rlfebk+jKqviHcBMo8jRfcs3vfu9zeqQcR1ycYW+cAfQCl+gRht0jeynziM4CbCrxUcNA469
	CQDahRxyLWx1aGLi3nnSLm4GO2TXvIts=
X-Received: by 2002:a05:620a:298e:b0:8cd:92e7:718a with SMTP id
 af79cd13be357-8ddcecbd120mr774599285a.38.1775869363502; Fri, 10 Apr 2026
 18:02:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260410103204.120409-1-dev.jain@arm.com> <20260410103204.120409-2-dev.jain@arm.com>
In-Reply-To: <20260410103204.120409-2-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 09:02:30 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zKG0M0W_PZp=nn80vnvVARbXpJ6EMVuqmoSLWM_2CQFQ@mail.gmail.com>
X-Gm-Features: AQROBzCISKu3Tqhprujvjz4T0jYfosHQeXGTjr5U2WWHZh6UoLqEZUydMAAURZw
Message-ID: <CAGsJ_4zKG0M0W_PZp=nn80vnvVARbXpJ6EMVuqmoSLWM_2CQFQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/9] mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, hughd@google.com, 
	chrisl@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, riel@surriel.com, harry@kernel.org, 
	jannh@google.com, pfalcato@suse.de, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F32DE40012
X-Stat-Signature: f4qeq9asu81edwcw79bq4xhx3brgeq44
X-HE-Tag: 1775869365-222417
X-HE-Meta: U2FsdGVkX1/p5BWHcUy0v6H7ttdd01ZjUB7svo5PNso+QlSgFD7nyxYWeNARrXkEDuYs50utLJIWrpM6bmGZvkjWi3Bny0aim/DqcPSfGdJwqJFAkdztnwghwKW9ciru1Sgbweo3ZeHdtmRwLeqHpvRrhuDiq7TCxmPTT2EyM1hSGpEG8t+HYQb/SBOOMbZDF0ij3TySQCbA3LPG7AgJwWNXGvP2ZfR9QXFt0IzAH9ifNws/LeeoKFQmSQpiBBKt2opcI7jKpBG5OSj1R1ZyCIZd6NiONHO3jj/5MJsI1Z6qh0Cb+u+ODjKRVTKtGYy8OyiBzDALPRhOjMzRj1AnJvTakdiqNyO4e1T3vCr8cGPdxUbd4WW7SkgsiXWeliMkcAxGurpHNj408uv0lAaBkdMPs5VhRMIX/lWrLfLN8Iv9BQKXX0yujZyK5a5wV331Sikuici8epKRPDXLU/+1ht/j9rYnIL1mmBqddhku3vMl+lnzdRQ0END6hhbT5g/XuBxtl70cRmQuetJ16ZAZUb5I++bakeRX/2hMrcNgafcDmQhdKef8zeAq2Wm2GkZxan7ds6zX2FEhklW4oRo5V0LsY8PdobTPqJh/UiT1snI/8W2iLVIQd9rr8uYnWlVHN50cWOGbTOMoDtWQJjJQzM7CQbQhPxVI7LXsa6e6Fpyy4odobxeMgtY/GwXri5LxTHHRHQrgp8mbSkbjFifTsR1MZEPJxuYvAni8SQ9vQEpgHtGwh4cQxzI8xSD/+3ALYbcUD94q0vxpAZE1YW6mu9eJWDwoILkyl8rsDk4Y4Uk/53XLRzA53v7WYFRzdn+Jl1lPsxKA2iSDo9Jj1RkYqTML89HhGdd1XIy8BsJas/5DIt8DreyvNIL7RCwuZpwQBuYPiS++i7QMo90BGARhyPy/Eq9v7BOoAlhNZcd4884MzbLj7ypN1gBwkcQwp80ydrTbjqjxbqiALdFguU7
 4QFX0j6N
 BZCsfL2JHrobDuazkIF22KW9R2jnOfWNxZ+yb7toHO3YJtvhsTh6urWQsRxp+rrrgBVfAbB10eo2wALTHkCYisRqlo89lrtxexo5wm2L+93H9seKfa3iiNM8XCeKoiQOkX8V06N+YmA7Sk5ol/zE/8XPXFbWpsvTA83RURiu+JWSnJStwsdSrYJ0HUJaFElxvedBw5R8aNxeGQowBALueqiH1qqLtLZ3rtZxjLVrYUq1I6TD7s056sjIe5mbtDHqftKPqKfB0V34/s+n7RZ9ZQHXmemQ6qI8ovaCaQrzud3cT6xu4ebV69ll/nDPPr/khqepykujc3GspIGMcC4ym6tsGLu/dtl1p/CU5k7rclp0ULj8gKmCcZmJurvOODlPf3q3uSdVd3wBmGLf7mmnqk8giYEkQPVfxIxCU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 6:32=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Initialize nr_pages to 1 at the start of each loop iteration, like
> folio_referenced_one() does.
>
> Without this, nr_pages computed by a previous folio_unmap_pte_batch() cal=
l
> can be reused on a later iteration that does not run
> folio_unmap_pte_batch() again.
>
> I don=E2=80=99t think this is causing a bug today, but it is fragile.
>
> A real bug would require this sequence within the same try_to_unmap_one()
> call:
>
> 1. Hit the pte_present(pteval) branch and set nr_pages > 1.
> 2. Later hit the else branch and do pte_clear() for device-exclusive PTE,
>    and execute rest of the code with nr_pages > 1.
>
> Executing the above would imply a lazyfree folio is mapped by a mix of
> present PTEs and device-exclusive PTEs.
>
> In practice, device-exclusive PTEs imply a GUP pin on the folio, and
> lazyfree unmapping aborts try_to_unmap_one() when it detects that
> condition. So today this likely does not manifest, but initializing
> nr_pages per-iteration is still the correct and safer behavior.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Acked-by: Barry Song <baohua@kernel.org>

