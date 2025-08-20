Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74823CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 15:13:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 018AF6B0025; Wed, 20 Aug 2025 11:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0B676B0026; Wed, 20 Aug 2025 11:13:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E490C6B0027; Wed, 20 Aug 2025 11:13:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D6D5E6B0025
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 11:13:12 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E668138B8F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:13:12 +0000 (UTC)
X-FDA: 83797479024.05.4E05B0A
Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	by imf21.hostedemail.com (Postfix) with ESMTP id B92A61C0006
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 15:13:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l0sCDOuB;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755702790; a=rsa-sha256;
	cv=none;
	b=6DVpGSsGKmMGar1oEbqQu5x4hMPmsFtvp4axbKRLZFX1doPIzWBnnCkcikAIRXFyzMbltX
	pZ9nvJMTCKbCZPQucWvsWVc3uiMGwX/X5+x4O2/PZhLDH1V8IzujFnfnrjw9igUlronLHD
	HjPNKCjyPgN/BAWf5qLzvCmi8r+cWiM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=l0sCDOuB;
	spf=pass (imf21.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755702790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFUStKMRHDPj6JYBVxnbw6Z9AEEYTWrR4Fi5aFJ1Z90=;
	b=OUE4rTbH56OoXSR6xfBB6iL9LvPgtc8UsVC508Rkz7YDjkfKoRaVkC1N5nAdFHP/iI9WNw
	1JaGrQdZ98xK0igbmaiqcBt8Dd4SyG3PwPXLzaA5qaaheC0CJWQ184+2vvQuk3jBK6EgK6
	+S0d2qTP8seoi7CiKzUXLBDFQpruUeg=
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e94dfbf7ba1so2439640276.3
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755702790; x=1756307590; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LFUStKMRHDPj6JYBVxnbw6Z9AEEYTWrR4Fi5aFJ1Z90=;
        b=l0sCDOuBO86MXvOpF/AP92U3/m389SwGL3BmF4IbXcJm9cWUcZiEcZkHcQSSnIBITI
         J5isyxw34Hk5LDtH7cn0e65MY8LaHewxsc/8HvfWUAL7jAhCIsm8B1sZRHpyov8Rt7G4
         ADZoISMjUkHvW8/62Faci3ogA4PEjbutUlsBn22JQFkeC48MEbubzpEqeuw/uUBypyh2
         iBtt4vxlj1/gLI1b5EUH0H5he6BT/pT11abuT6agdti5O+miu/BGo3nc7CH9DF/HKUcz
         CGedH1e5TWRTAWEtWXBFrMajlDlFmSl4yJheT4LUU1u5c6TcRLBx+oEnjiXb32Z3283j
         +H6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755702790; x=1756307590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LFUStKMRHDPj6JYBVxnbw6Z9AEEYTWrR4Fi5aFJ1Z90=;
        b=N/2VOKPTj04slHkGzx59L1Z2OrbPDIdziYCdGlKP+zPmgmWHA44+VLSyiYbFokdiot
         ptRev1v8AtGd28gzv5mXy3A8WxfI5tkGWuX1n6cSSKnudZvgq+DxWP16yDumWgdhTAMP
         305AZzQ3G2+lOaSIyK+ciTa9e9GVfFItPGTs/EpzYv8FjkcpWmw3CCCvZ0/AbBsXGbKF
         JHcLassSk9bwZATfEW3n3bNcyhEHxApENK1RYRX2Be2BniKi4sdwn0G4XHU39m55+pdD
         T486t7rTY36w58ZBee6uZfw2XkcEnfJeY2UKSwIPfBpdOp50E43BOQq8d+aZPlawhrv2
         LV3A==
X-Forwarded-Encrypted: i=1; AJvYcCX1UPB3jCJgdrrqgdEjsUEUN05DEeCyIdNWh/X58Wdenhy1GH+Oz+6m/tbPLIZulLDUTpRzdsoUzA==@kvack.org
X-Gm-Message-State: AOJu0YyzswUK/cI0D5cWfgFL4fyTkzXd626j2i6py/K/nqlZyEgc1YBw
	bdWhW2nKabMBIwNiX/uOe0OYTIWvkU5F1gf3675Q8lyttYbLvsLULW0I
X-Gm-Gg: ASbGnctNLrWaKlMgWPjJ/pDujbznO8FrWNf4lz63vyijX+i6cyYB6FtVbTON4usInGD
	MowQT/WboME3ocrRV912vLzL0XaqHMZ1jF3PLMghWAG/d3NG04/bFP2rg8qkIPSR0y5WV5rhUhC
	Oy09LS4V+Tppp0QCdmvwareeEZJsbfWi9Dxlxc1oPRQDaEXkNjlAp7jDV79+zgtvJnOUmRBPB/S
	Da3jMSIvbrZy8BEWtTkqpUjnOMMFp6WCHpE8OaySFmGy+GWsPqLY6uKXWIRv7R2k8W0uq1oCFBK
	AXZeg0rwOs+b5/HTA8wsJujfHj4lQKSYLMq+6rS3tYHd28yk9VQY1EUYz5dv4E5BQ3AWN4Z6PFc
	wCpt2FL7yZEnmDfW6tR9q
X-Google-Smtp-Source: AGHT+IGBD2iZAT2VlXMJEW/2T3OnRW/5IceBSHatfF1swKy5WFUb7kGAyVXVwSLkF/TyCFnIK2I5cA==
X-Received: by 2002:a05:6902:6c15:b0:e93:4a06:96cb with SMTP id 3f1490d57ef6-e94f64c9f8bmr3251284276.2.1755702789638;
        Wed, 20 Aug 2025 08:13:09 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:8::])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e933264aabcsm5146211276.9.2025.08.20.08.13.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 08:13:09 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Hillf Danton <hdanton@sina.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in batch freeing
Date: Wed, 20 Aug 2025 08:13:07 -0700
Message-ID: <20250820151307.1821686-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250820012901.5083-1-hdanton@sina.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B92A61C0006
X-Stat-Signature: a75ecxk7m4hxw1boyugjpfkyi8nmdzns
X-Rspam-User: 
X-HE-Tag: 1755702790-336858
X-HE-Meta: U2FsdGVkX1/EG5d8Ai3nSgoMrMZoSQuXZqiNOtWM8xgmtC7Zplv67gi94EP5t1yVbG5sgGLxxddv9jH2t5D5d7lY/bvfYGGUrvFFW2RyWmySTCOlsdSMqCtkw0xQcECRMfXtkOEbMZnuu3Esz6/oJCrQPipjzJGmwv7AHmGoZ8lqPOOYo+DKOOxiL4LvS4BtUydRpqUsVWKMoe6pztfrrO2wR2Ir5+ML75T1ESJ1yLY50M6HZ7AFTlEbmviHmrlexUhxI5ESfz/OZW1Q3UDCHpUM85T7ovchxmifxPGFRToYQ/QxYBGjxHBMaemfYyYfiFFOksBXGE8T350FOMsowuuP0b3bKh8tfIOvOS+yNk9pts/Dx/0mzCUAirOqD761AtwRKCiS264mB69OIa6rFoQhIATnR5wvlhqjYkBXQ9SSR6qIojbGUVe2J1td4soaoLgQ+ntf4MRxKlGzj1oElcegXxDpwTpZ11N42XXCcn+SG+Na1GM7u6WaIKpxIqzkIQJ7tl38r2Qq1Ox9qq1d9imE/dYLdkia/cRWlARE175iEJecUt62gAuPB+T5+MY0KYEWLBaH4n4tST4PFcZAXb79d2+7VzyvG7rPQH3AyHMywLgWueO35J/MjrH2im4Uoja7kaivEho2yq/Z+P4tyElwJBr4nJ+f4QGMrUnUQK4QGZS9QyjLg1hh18Zcr3IgAozFbw5NNMM/g+lG/mlYRTTvgQ1pjTkrBm/3uwCLIu+V/675VSzwAVHtRPt87J1bsv0k3pdd8f25zVHvxakRNcRclzHfkYqqH/s1ge/7k8AbvEljrrqvGFH4VqhrR2h0LwlV9LfqNqefop0rLAHKUKkJwRKFY8LVzIAJ4gHPvDmSavJOe3p5+0FLAq83PUa3/bWBtmdJ7s/er2jAKkBOR/+lSwEA4642M/S7pAPSxI9LdNxMeMN8C5J4Hz+mRyVf/UFMl9NdRbvUXmN/TQb
 Zd76mCej
 ETBuQ83UHkWu3+NEByKkxL6VIila28XGOQpPVMilns38S1FXZsFMDDsxwEujNJNCDHdjFWBtsUSUGYVyLFDVX6qpVrjOSCg4Q3Dbzd8sUogc07oIWWMM/mvJaKwQ89lC/GP8jpx8EJ5DtE/2tfqlz0M81uYiba3yKe63e3w5lyJFnf69QRVarVIbRe/0B05xhnwPZezcWvWsCfwM4GCBrJtqoYv4qQkA+lxp8D/QEZQdFWidxNGhh2H5SJLzXsrsbhIfSqyCfYZehiyj5+FkBuEtl983XtKuJwin+LwXLd9ciurhNtBcmVRONyfw2SASJbBMv4biqJZ+qCJgy3jQZULKNajCfYmUqBjz3B/f0W8FbzOZ8+/ytnrUPCYIt4sgIrqC4cn/MDA0ohzGW0C5K+/9piBWgSabdlSAWhUaZ2qZBkJ00jvgYUoYP1HUA7iphp/aNOUIJFYAalSPskwGv0fR9QX37qpLCplxH5cKt/v9Z4aQEdtgJ1VRP4BSI052/LhnDgD0nPg+Rcs4ymqJ1GvbjM/0XI3MMVmHW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 20 Aug 2025 09:29:00 +0800 Hillf Danton <hdanton@sina.com> wrote:

Hello Hillf, thank you for your review!

> On Mon, 18 Aug 2025 11:58:03 -0700 Joshua Hahn wrote:
> > 
> > While testing workloads with high sustained memory pressure on large machines
> > (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> > Further investigation showed that the lock in free_pcppages_bulk was being held
> > for a long time, even being held while 2k+ pages were being freed.
> > 
> > Instead of holding the lock for the entirety of the freeing, check to see if
> > the zone lock is contended every pcp->batch pages. If there is contention,
> > relinquish the lock so that other processors have a change to grab the lock
> > and perform critical work.
> > 
> Instead of the unlock/lock game, simply return with the rest left to workqueue
> in case of lock contension. But workqueue is still unable to kill soft lockup
> if the number of contending CPUs is large enough.

Thank you for the idea. One concern that I have is that sometimes, we do expect
free_pcppages_bulk to actually free all of the pages that it has promised to
do. One example is when it is called from drain_zone_pages. Of course, we can
have a while loop that would call free_pcppages_bulk until it returns 0, but
I think that would be reduced to unlocking / locking over and over again.

As for the number of contending CPUs -- I'm not really sure what the number
looks like. In my testing, I have just done some spot checks to see that the
zone lock is indeed contended, but I'm not entirely sure how hotly it is
contended. I can run some tests before sending out the next version to see if
it is higher / lower than expected.

Thank you, I hope you have a great day!
Joshua

