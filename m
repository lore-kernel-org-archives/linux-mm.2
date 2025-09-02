Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A5B4CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:06:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682418E000B; Tue,  2 Sep 2025 16:06:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658148E0001; Tue,  2 Sep 2025 16:06:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56DC08E000B; Tue,  2 Sep 2025 16:06:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45A188E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:06:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDD3558C81
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:06:11 +0000 (UTC)
X-FDA: 83845391742.08.7A9D22B
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id F4101160012
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:06:09 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FMr+/508";
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756843570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=azzJpww1T6QT9OEQQ5Xdin+vv/Lolribc8Oh9kh33z0=;
	b=s0tP4U5rPzl/1lHMWEPSl6KLOq3SUWqgIjzLgAwzt2DzoBh5tGAbbUYtc4ZaLOmUULb+En
	UmI915R89OcvIoTSFdkXMwkuKnzWvb+y3b3OQLXrbvO7OHflYKHbAdh2L/t3cJ+T3BNyX4
	eyWSZhtHDIPK3KdsM2muSiFC+eHU03k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="FMr+/508";
	spf=pass (imf08.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756843570; a=rsa-sha256;
	cv=none;
	b=j/gA790UhaHewFreWbrKxkVW3LYhHVRSrndy/yI7qKT1Zs8aUBW+e1aPgjSt8cPJWa55tv
	3BTrHNi5wSS6IgW3gE6ChZlgKR8bwJBnAAUsZgLYUFRdMTDDXPheh3rK43Uk5SWEU2kt1e
	8hipRxojUd01WYpxSMrjau/d7ixrnro=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b49b56a3f27so3728341a12.1
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 13:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756843568; x=1757448368; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=azzJpww1T6QT9OEQQ5Xdin+vv/Lolribc8Oh9kh33z0=;
        b=FMr+/508aFeSljZQXjD8GOjVINKLipJhCtiyHZQ0e9ztdbmmgbqCrtnlsrhsEtTQ1S
         ArFLOuxr8FwHXOQdQHzMKONltTdQN7CUiDpPnJG6l/g75UbfR0dOwEWhc3zSmukGsO24
         7Avbo2A+dZWeN5U7UqKF5FTsagZxcJYGwNItc9kXrEyrAJnEX5iegwpIWyOcHPkQLPbq
         stokbJpVb8+HP9hhOtbqb97suKTrmvD9xuOeWzknw7VYSdTtF/jyfTyajY/koYNyAFeq
         GYiD3fmYqXJVcGMp0l12cdR2q5JNQ6KEMk+rFXrfcClAYpaqRsJOWNRkHtSRjC2FM50R
         Z9GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756843568; x=1757448368;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=azzJpww1T6QT9OEQQ5Xdin+vv/Lolribc8Oh9kh33z0=;
        b=TCdqT3xSz37y3qUhfVAD/ogNG9Y2OPJVhncREO2JoQFI9vVoLEoUmQ/vdsu2KNlsPE
         CO0YiVAgr0+/4VkWbguFEuZWDTHdXaMW3Wl1Uvc+OwSnnqqULDRVbFrRClQJcdDKIn55
         75uoG19wLT8AHYFR+sI7ooePbtCIXW8lXpViym1ZeTf81bvsEVy/y34rIwsj9cJoOlUV
         yJVN0QHxytapTXmyafapQQAVNVOsvK8E31+ZA7uz57gz35SPAsqEk5uWWgQ3sBYaESZZ
         pOnN8aLUetxQn+3VbTJfZtkNGggIattI9L3g/+1R4tmQXAgwolyF4ywNGCPdL/TkTIi9
         +Xwg==
X-Gm-Message-State: AOJu0Yz26ww82KuIxCsv5gdS/vpIbbri3A+6XBEPtqw7GwxY7CsGjMDs
	7qUvbqpBlkGFVfNPKOdq1e9j56zXw3W7qPSUReSFYIhQsfBu1/+PXBxW
X-Gm-Gg: ASbGnctNL/sGAnL46HT9UGaXTiCZjid7Jy1gmamyemvx2RGQ7E8phC8u8HcmlT86LUA
	5VtANf8Yyf3Wx2NR86snhvGbo5CUPT0dIqAbzPvPDvjnPrCV9hpKRAR8QSBWeP+sZ6rEhm1Im5Z
	Rdw5ZPq3Fcv8FRsKmzUZ18DQ0Rr6KC4wi9U71rYfOo7feA8bDngeqjvZaEviY1+61kpSeaZf1D2
	jrx0HU6wO8QX4b/I/MWu5Ze+kc3eMd1T072vLlU7jdDV9NW3SqnU1irlC5HD4Gn3ewYz3SpMv8X
	Wq022uxKVoUKLnNVRXQykNQzMSc5VWUdbIvNPQyKYf0coe6fo9pnXsYuf0r2yLek7rQC92lNIjU
	L8mU79iKTaTci7HcNQ6ItkMYhvQwxrVgSBRfeK6aJnFtGJKM5lIXcWQ==
X-Google-Smtp-Source: AGHT+IECRMkjHsjdrff1b+uYIwH526sZaUzamyfw9eNA2twwQkFG/MgXEMmYprucKZG08B8k8zHCZA==
X-Received: by 2002:a17:902:f78a:b0:24b:11c8:2cfd with SMTP id d9443c01a7336-24b11c832c5mr46470555ad.7.1756843568456;
        Tue, 02 Sep 2025 13:06:08 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24b0e860ab5sm32663555ad.5.2025.09.02.13.06.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 13:06:07 -0700 (PDT)
Date: Tue, 2 Sep 2025 13:06:05 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Kees Cook <kees@kernel.org>, kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>
Subject: Re: [PATCH] mm: Fix kernel stack tagging for certain configs
Message-ID: <aLdOLQLjt-A1DBGi@fedora>
References: <20250902175903.1124555-1-vishal.moola@gmail.com>
 <f41383c3-913a-489a-82e6-d2c8d5519eed@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f41383c3-913a-489a-82e6-d2c8d5519eed@redhat.com>
X-Rspamd-Queue-Id: F4101160012
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: yhdtp71o7er7zq7euitbs9fgiwxopxrc
X-HE-Tag: 1756843569-216518
X-HE-Meta: U2FsdGVkX1+jI0GsTIhIZMbsMdZvDPr/UTW1rxxYGDCfK3qrmsDYOCeodRoVQthrWPbIrK+Zeko60dfPIqGA1XqF8Ob5P8LALdo4btXZ9pQelBapw+6w4ccV7RqDRdGOscNmMVzEAAiZAwjdBcrpgQr5Lrq6fcnSlVjsmsFob6TwRizIJGAXXi7aJjszc+0TT5Q1G00DKBZTQB7k56tKx8MsmEX2FLhlsbpBaPcsFyZeiRKSdgyfuylMLMAukTRRGPMzl0f8LnXEUjvddnOzgM7rtgT6U/9XyJiM5LLpD9yJdtQXHxTNYzOI9gSxAHLei3JpCxkoTSQW6IPsRvHWJHkLY6/6wHhFFA11pFMvFs2gaF97YqwEI2HuhHNg9ZxEti1yt48wUxvE8kNENoI2tIvLiVx3o/kO7cASkFSsfG3SqN2l61xtfCIm7lPcPghA0GKQ4S94o9oUkPpzysUkdyym3hBFD4lPx+T0ScEbd0iTlKQKqKl4V5c0+Kcb0Ep5YMt5Cxvi5PBAkntHUwrAGOIOxE/EABcs22lcKmXbogOY5jJ3YC5a/Bc4m6/AstGdlQ5olE4zPVdfjZUqrbMvFVmplqA/PoS14XARM8Kr93q3SfMFHtlVHlyeHqOWorsiWOWJFbi4ZXzcE9yU8LzRfQ68UvR1pbwbgrUXeECcBO5A77/0EE8/73dOnRbRprwNuMKsO4FapuB3YXvgyHwO0pir0882INZ5DUt6jEQF5t0fvDUyQ6uJlFdTqpH6+TV/jOihNE6/bL4Gc37DHJ3KuTAAsdKiuOLUE3ViS2FM8psQW2+yTNwjcM9ovUwawsf50Ff0g5mRiROi65fFF0bwR6CLTW85dUrQjOr3RIW4zqvDXBczRnQ2NA9oakL71NmGagMy3f5RoMHgWVYfh48IAgC4QtGklEk0nQmncBVBSWAFbDh00XzfzDJIN2gIAkJooh+wr+SsLJ/kkQBH6nv
 x2crX/Uf
 WT+v9iAQnb6uOdIb61ob3tjVe3WEZZecHdFDTqZQn+0tyzYHkhNMOQl9Mh/2NPTrKJ1BDs4BlJDsJabb4FcKB0a8giC0jUlOurbHhHP5SQsbe71lCXtvJahPydBlPLLPkrXTrccv07sIyFSHwukJt7pT+t6292ZZAhJFQV+cqzbdcJZhVuExDfBtG4xyWTfGw7CIaX+V2qklXXKrFAO96ku4f01GgjrcPdoc9myAex2D3yCC5I/RZUifohDXi87dRpDis8vfOkiGeobCOqh6mvIA22OkT3qdq2VYICkOnuZXpqWq7MDkhDPXt2Tt869UZlVtQ7fzqF2Qmy3NLE0YDxnHssQUi62cez8PytDUEVcaU3eVXmQh6yiSJndbbBm4BQQ/vonnrGwe+Tb5d87hygWvXSHDCeHgRLqK8NOxivH3VmzTBWm7Mxh9WBz/QSmuubHmo7XJ9Zq9Ut3Gi1pJ70JlaIcClJiuvHGUy+HPdRhzv8aIB+q6Rcpzu9f/M7AMRTuYyr8s0XPpNHYhWDxhpBd8J86nBvrelFUqGPMOdDLMyONWW+1bULEkm99+GYdek7S72x8lo3MNQB4Y5EvHDhTYfVQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 08:23:06PM +0200, David Hildenbrand wrote:
> On 02.09.25 19:59, Vishal Moola (Oracle) wrote:
> > Commit 4ef905bda61f ("mm: tag kernel stack pages") began marking pages
> > that were being used for the kernel stack.
> > 
> > There are 3 cases where kernel pages are allocated for kernel stacks:
> > CONFIG_VMAP_STACK, THREAD_SIZE >= PAGE_SIZE, THREAD_SIZE < PAGE_SIZE.
> > These cases use vmalloc(), alloc_pages() and kmem_cache_alloc()
> > respectively.
> > 
> > In the first 2 cases, THREAD_SIZE / PAGE_SIZE will always be greater
> > than 0, and pages are tagged as expected. In the third case,
> > THREAD_SIZE / PAGE_SIZE evaluates to 0 and doesn't tag any pages at all.
> > This meant that in those configs, the stack tagging was a no-op, and led
> > to smatch build warnings.
> > 
> > We definitely have at least 1 page we want tagged at this point, so fix
> > it by using a do {} while loop instead of a for loop.
> > 
> > Fixes: 4ef905bda61f ("mm: tag kernel stack pages")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > Closes: https://lore.kernel.org/r/202508300929.TrRovUMu-lkp@intel.com/
> > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > ---
> 
> You sent the patch on August 20 and I replied on August 21.
> 
> I did not receive any reply so far.

Ah sorry, I didn't mean to miss your reply.

I can't find your reply in my inboxes so I definitely missed it somehow.
I'll go find it and respond.

> And now I realize that this patch is not upstream yet and the commit id not
> stable. So the Fixes/Closes etc. do not really apply.

Gotcha.

> My current opinion is that we don't want this. (see vmalloc reasoning and
> unclear use)
> 
> I'm happy to be convinced otherwise.
> 
> -- 
> Cheers
> 
> David / dhildenb
> 

