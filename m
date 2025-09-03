Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08631CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 18:13:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E1D78E0002; Wed,  3 Sep 2025 14:13:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B97B8E0001; Wed,  3 Sep 2025 14:13:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5F78E0002; Wed,  3 Sep 2025 14:13:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2E9E08E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 14:13:08 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CADF2C082C
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:13:07 +0000 (UTC)
X-FDA: 83848735614.22.D7D6793
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECFA5180010
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 18:13:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KH3yhaTL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756923186; a=rsa-sha256;
	cv=none;
	b=R17sJ/mI3P6cOGd4w27ULPYg/Y/JhPe3QOiIKFiJSyosWYM03nGaNgbflwQncbv6Fi7c4v
	gg7o1qS66KL9vUWv5CtoSCK5Te2Y/5GkRG+MmIHtb9xsqNSXOiBis6BQoIQ+9nshjqNmTD
	bwPgWM5H0z6W0nOFaP28NktG4ByM4VA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KH3yhaTL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756923186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+V6XFpApnDR2sDMYgBfaHdUWcEUw96+ntmZdF92GSVU=;
	b=b6xRjai1cvz6Q82AVatrMXLS7o+N3wvnuVqPt74YICTtpp6f/onULyk4/b3mklaLaUcCAY
	2taNSxlb/bfQrmNdbgb8rrzlokqUj0E/732Rvca9ycqmlq7myPX4BF2BvITtL9ndNfks2K
	U2Sr4f+/TevqRmXdp2rTyqMKgJo5u1Y=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b47475cf8ecso79239a12.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 11:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756923185; x=1757527985; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+V6XFpApnDR2sDMYgBfaHdUWcEUw96+ntmZdF92GSVU=;
        b=KH3yhaTLBYK+uRKKHqIZh71vgbUKIuXNNrretECe+X6ZH4ZuerTy6R/yvn6MSqX/sT
         GycrzAe253Ltge9Vt7rAvNgenqXbJrM5Wxd5rJR8Mv25v9CMpmnNSs423G8jHWuZ0A7f
         e6S977HSSGyufiZh7bETbW1gQgT0X7KO2vr+XxAXF7T+mrEeB6WdR/YoWPz0CJ4dTc9f
         pWRwX7ks50QYNS9vD1xgeDma+nn58S3JNfhb2pNLyaezxSeTBxQXB++mC+X0k6vGWh4s
         I/rYpBLkQRPO03Cphuc2so4jw6llVWBxnSt+bnC0TRwtS3fy89YmbWI64f31MP5BTtef
         q9kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756923185; x=1757527985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+V6XFpApnDR2sDMYgBfaHdUWcEUw96+ntmZdF92GSVU=;
        b=OK99xuaybDvMgH2O/eVBjpipINST0r0mUzMz2wfykqyLsypwaITrSrt8OdrRtSDW1Q
         O5AC/ZQog6FEODGc98cjbKOKwQKdyy6e4WDd7f/VFvh5bQraC6FgsOK6G0xzh5yEZX6J
         rDLWxzEr3OakiNWgmEiFuhu2AoJESzUE89vApDARQ95frZ6R90/84SmbCk54aNOkYhJc
         QqDc4QHAvR7UBfG5xBKcvVPKtSPeECDnoOffqO+Wbd+dnD2Al86bOI3HYFth0ZVRL+pP
         /nhintuBEnztlF/qCxBcL/RrbuLZjFnyCalBt8MTenW0I9J5Y250ETBLE0L+VgHHSBZL
         jL2g==
X-Gm-Message-State: AOJu0YxqfXueHAiXCZ8WN8AAnJcExOvEf5XDwx9IQYW3qi7nj2ZIymN3
	b4K72BOTUty/CQ91DROistntXpvY9BJhSZ4JoPWuDw8avSiRuYmeK44u
X-Gm-Gg: ASbGncvj2BVdotBXRwQwDhy1NRoiDb7rREGlrgs5AgunAtKGMnFTm0E9IIJgR8/knuf
	FdSALWdXErAv6SbJl1w1I4lH6BdV9tAxmdDfn56bTh7bIQLpPIbZp5J+CMkzwAyLW/N968NyXLp
	kqB4v+44fSiIbcCkVa38KO9766k9oGaTMHXVZr1zHvlrKMeteP6dhGA6g1HvtmqVZx2uGk/zJnR
	J3rbJdV0EPV8UOWQqIwyhZraqRsIrK6AwqL/rP86WZBbcw7SHw2vDM3v2J9gI8wixk+TYApnv6I
	f1zRQBJ9Nz8xymUpHsEtnnmIqL6uc+sEGe2ZnIi7o0Q1C21q39IIv6JvoRK2KHloaj9nDmpWQAS
	Y9AVpiI7OktXkUzHVkFSma6yu8+Ibrm6k1m+vKfdGrs0L8uoCpKtsbo1uhDD1XN4p
X-Google-Smtp-Source: AGHT+IE6mulAKwH9025m2RLHU5y+28A1brzX418uJFTC1AUjoGY+4HwHcSr68SSqgbcMg5wB5MJ6Wg==
X-Received: by 2002:a17:902:f54d:b0:24a:9c83:e19f with SMTP id d9443c01a7336-24a9c83e357mr162442235ad.53.1756923184568;
        Wed, 03 Sep 2025 11:13:04 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24ca63c9e71sm18196285ad.95.2025.09.03.11.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 11:13:03 -0700 (PDT)
Date: Wed, 3 Sep 2025 11:12:59 -0700
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
Message-ID: <aLiFK8sIgbfiK-v2@fedora>
References: <20250902175903.1124555-1-vishal.moola@gmail.com>
 <f41383c3-913a-489a-82e6-d2c8d5519eed@redhat.com>
 <aLdOLQLjt-A1DBGi@fedora>
 <b0ed22cd-ebf9-41f7-b5fb-6fb078db593e@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b0ed22cd-ebf9-41f7-b5fb-6fb078db593e@redhat.com>
X-Rspamd-Queue-Id: ECFA5180010
X-Stat-Signature: 67cx1kg5gtbp5mnpuyp1rkiuzy8i1tg6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756923185-22466
X-HE-Meta: U2FsdGVkX181zrfaEfTCVoHMMIqk83w0UgUZeqVz18EuAM8zQHHe2zZAZvlpGKO+6LygaBJp7oxgfAe3VDydrbuRAc33X2n8D44pWrWWaXyliuKCA9Ln2Euvr/Z3tNW3+9mOem0zLedWK2MlSFPIq7KYTb6s+JyO7ylKqtjYfnCCx4WPivTyk/Va2ve+a0udfOHjcc7ExGDLrcFVm4PrBrYZ68N+F8Zgbg8u7HxRGEk9MKL/RJ7PkU7mOuH57xfWsFGbxIO5fVhO5m8y5+YOSp7NjH2JG6sHCAja0r2pPqfMts3g+suS+710RnwlrwVjkf9svNkcV/ZeeqcEKlHRG9dgHgCpYE/97Iyej7dSskbM9VLQpd9oO5M78kn8E/gqmFmqyyDqL2ECSGjj/AYQO6aWbcipwxFWRc9vA6JgbscBsah26i7TcbSY+ZKYCs6Be6oClPjDDBCYRKPmbwtZfMAjqVQLZcS6SWO01PWr1tDYTlZ0Wnd14ffijKI2g38IbqGb/sL0SxaP2DfoAM72v77hUrivEGQ86qiZh1y3nKqg0CKVm0u7gJ0GpRDTXUQW2y/yzfCcvJGw4ZH4hUqclRVyGCoO04u5yGFs/jgw6ax1szKsF+JEB3fmA4DxWHScAVXlwpg5RReZnnZs5wQwHTnXERfr6TqafUlAQc6ZNCOXlrsHafkjppyNJC2UhItT6LA2FufU8BMki7ixk8N3mVu5/jSHIm8fDmwAhWhPk2+w3sQmWXJWL5Mo5XGS2JTQOn7bycvBm30GIC6lHxJwKusEv2EagXm6mil2qaQ0CqO2U/SDm4lT/8sNO1PnYjhPYZEweaavnPpFaKdIPC98iJ71cTreSEGA/lQ3yjnZmAKagFUlqUo6NoQiEXefuKlFbVUuAke8LYWlzn2nHjCwqJU+e+Vd60ss4uJxrXVJMuOB6soIPLuM2t8e7MlzLr5rn1OhjsELwV13gkkvw/k
 xa+9SXMK
 0emBASHPz1ZIc9ftxc0oDMy5XLMvCYx0T6S07xSl3aoDNBk0iRPI3+3fXr9MOUpYYDu2HVft5lgBV5UyTWRXns/Cr5iT9loWWt0CvSEEElqyrS1y3J5z2IwQg7G+QDEEQJ8j7UasTiZM+eH38K/t7qyXnVSuRvQygp2l6ou6vGzA5ys4bXDb94Leq6CBFIwcavsg2GM983j335Q221YvrXFFKeYa6mzjjrcH/A8U9398g6zbXV+dZiMduZ+Alg9s28XIMvyP6KwupAMbTPtt1W81o90y698T3AydbsgoiPnpl88g2e3U/KRFG75rcCuhRBxW0bRshwjo+ZhlopwqBm8Smvc+xRrSo2IL3/9ydakCeGa/PzXiSVZtwbRRQ4CjMXnel9lIQoyBDqzQsxDwGvDmqZRUew96hcs9nwh5tFPg/Es9KgP4vpgRPb8sUPVgntqQFqhGmGrUnQdKEOFOckCYGG1y7I3r2VJeI06uTDJzYTm+DLae2J58hR1TOZxgfpM9hJ9F/dwtY5OsdGPOCrF+IEpxAGv3T+6XrNJs5buuV9TyYKX3pIWwJE+DF09XBbNSupAHwIMS48Dg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 09:46:44AM +0200, David Hildenbrand wrote:
> On 02.09.25 22:06, Vishal Moola (Oracle) wrote:
> > On Tue, Sep 02, 2025 at 08:23:06PM +0200, David Hildenbrand wrote:
> > > On 02.09.25 19:59, Vishal Moola (Oracle) wrote:
> > > > Commit 4ef905bda61f ("mm: tag kernel stack pages") began marking pages
> > > > that were being used for the kernel stack.
> > > > 
> > > > There are 3 cases where kernel pages are allocated for kernel stacks:
> > > > CONFIG_VMAP_STACK, THREAD_SIZE >= PAGE_SIZE, THREAD_SIZE < PAGE_SIZE.
> > > > These cases use vmalloc(), alloc_pages() and kmem_cache_alloc()
> > > > respectively.
> > > > 
> > > > In the first 2 cases, THREAD_SIZE / PAGE_SIZE will always be greater
> > > > than 0, and pages are tagged as expected. In the third case,
> > > > THREAD_SIZE / PAGE_SIZE evaluates to 0 and doesn't tag any pages at all.
> > > > This meant that in those configs, the stack tagging was a no-op, and led
> > > > to smatch build warnings.
> > > > 
> > > > We definitely have at least 1 page we want tagged at this point, so fix
> > > > it by using a do {} while loop instead of a for loop.
> > > > 
> > > > Fixes: 4ef905bda61f ("mm: tag kernel stack pages")
> > > > Reported-by: kernel test robot <lkp@intel.com>
> > > > Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> > > > Closes: https://lore.kernel.org/r/202508300929.TrRovUMu-lkp@intel.com/
> > > > Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> > > > ---
> > > 
> > > You sent the patch on August 20 and I replied on August 21.
> > > 
> > > I did not receive any reply so far.
> > 
> > Ah sorry, I didn't mean to miss your reply.
> > 
> > I can't find your reply in my inboxes so I definitely missed it somehow.
> > I'll go find it and respond.
> 
> I had a mail server config issue on one day last month (sending @redhat.com
> through kernel.org :) ), let me check if that was on that problematic day
> and it might have went straight into your spam folder due to dkim mismatch.
> 
> So the mailing list did not reject it:
> 
> https://lore.kernel.org/all/96148baf-f008-449b-988b-ea4f07d18528@redhat.com/
> 
> And yes, indeed, it was on that problemtic day, and there is:
> 
> 	Received: from smtp.kernel.org
> 
> So, problem on my side. Willy already replied, but let me resend that mail.
> 
> > 
> > > And now I realize that this patch is not upstream yet and the commit id not
> > > stable. So the Fixes/Closes etc. do not really apply.
> > 
> > Gotcha.
> 
> If there are bigger changes it usually makes sense to send a v2, or a simple
> fixup as reply to the original patch (I prefer as inline reply).

Ok I'll keep that in mind for the future :). My mail client loves
attaching the fixup patches as additional files, but I'll find a workflow
for inlining them.

> Of course, once it's in mm-stable or upstream, things get more tricky :)
> 
> -- 
> Cheers
> 
> David / dhildenb
> 

