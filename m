Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2949FC79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7FD6B0092; Tue,  8 Sep 2026 10:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18FB36B0096; Tue,  8 Sep 2026 10:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A68F6B0098; Tue,  8 Sep 2026 10:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D54A76B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:23:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BA671406B9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:23:40 +0000 (UTC)
X-FDA: 85190813400.23.A259875
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 73EA214000F
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:23:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rG4vWSnG;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788877418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SnF7FxdLIEQlswE9xvoQ5sUHHcQzYgPIRrMFvodMtWw=;
	b=LFAsxRM6swjhWZx+HKyq1BcCEgnJIwrq3b45sy/yCXL1MamjxgCp+pp67vFwwUEm9h3jfQ
	LttZ5Ey41pWIOX0kqmn2g7mSQRCC4Hw0qGToUGNLg75a727WObBdAgvrLbCX+mDIF8hqNw
	TbgPwKaFJ8xGdTuJFrag1TePPO9nJ3c=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rG4vWSnG;
	spf=pass (imf09.hostedemail.com: domain of urezki@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788877418;
	b=1Gzry0v27xAKvHsPhbf/EzZ22sLFmPdgv2yS65VfTMPv79ypWQ/vJTU5qOM3pI9SpzifXD
	TkxnVDY5DLmjCBZnifTS71fLq7ET9V8tPYrWFefqLntWbAzcqGrCwCHdxiCO6B0baX0J1A
	2DKv7EEK+5321dMOTpOtAz/TQOStap8=
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84e04df8c46so5049739b3a.2
        for <linux-mm@kvack.org>; Tue, 08 Sep 2026 07:23:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788877417; x=1789482217; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SnF7FxdLIEQlswE9xvoQ5sUHHcQzYgPIRrMFvodMtWw=;
        b=rG4vWSnGqJx1ftmnkRnCXD3kqmgoFtqR6ArC84+b8fsqBIyn//8P/eXSWXadNSaTLd
         bTDJa4c/FgbDAcKjQDQLyUALdEsLU39w7WZZd77/GaPUpDxGhH9EO9PZJCz9gBs5WnTd
         KSrNUqnclpo2BZM8189DwvaVSOqJJCVavItnOx76it8T4v1sYOzDbuG/Oviybjg5SpzS
         cLKEk5RIVOxqtFmCOFUXXPYlLZnluWQmqSKIXIv7CzTlketTA5MY+u3ZRLL8E2cVFqy8
         0VwQ3pHq85J/mcfryO9G4H8zw5ehzn0WQhrqmIh1dMuqvN7RNPawMS0dAdCm7U4Z1PVz
         MviQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788877417; x=1789482217;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SnF7FxdLIEQlswE9xvoQ5sUHHcQzYgPIRrMFvodMtWw=;
        b=Krrr7NYAQnWeqYFG6kwIjpTMgojtL08zf/nGsvMTOVgfa7fHqEAKFmstrOgxiolRxD
         RnfW4ZRMxR3AVJJl/FEkU8xDtfO9SAlUhrkU0KRza+YSyXUdxT4jHV6YFOuMwWKcZ2Ca
         a59Uwse1An3KHhQ5yu+OkvA1kJnIwqTr3HDT8yEQJ0c+hhOoOq5QUo6g5IFHYShAOM77
         9HQ89RGHe2qq0gXNIMo39f5S1e80KYU3UncCGRyxqk8wSFEN5alVSKN8VTL4FTS6+jCQ
         MGCSBY50jKG6MIPuBsmQ0q/pMLS/zIupTXZ0mf5fJ/tOZegW0/mepz6pYMKTAcVfD0LL
         8pWA==
X-Forwarded-Encrypted: i=1; AKwUvBz1QT8RaJmd8yxWYVhNxs4cIkkIH1dpOb6SzvKZkg8f5TxxXrvdhtoy7hVAsZoUJDG3iBVaHw4Rig==@kvack.org
X-Gm-Message-State: AFuF++lp+xfYFZ82+zAuvjcJDQ1JTfnX6NwJjV5EivuDdOTZbBOWMJ0B
	HLCHs5Qb8bEKQbeRphbQ+LPld80tZA6cnJc/uMzqe2iUYoVz9pzY9Kex2yrhetbm
X-Gm-Gg: AYBFou2rg3Ky0ZtE7z1RYtQF8b7I6EfkSY66IukZVt8J83sqiPbioj+d7Xg06vUs37M
	LSK1DS0TFk8XsOgaxSCarqsudVtav7kRqYrDsazpnUmbCbdD9d2JnP+jJMnbkRLpUupa03hXFzc
	axxXkK7QNa7nTDa6uY+nePKDBfu1oj3nwkGkQyPRhNjcRph3PmZTHDM7kwxb9IEvXgi2dCoxuDq
	dBKuLzemCUjUO+S00U3FnSZL3zO1I+5nHNjhO9uO2oy/sO8hdTtj4Od8n1w4D4nUGiP6Xb1EPDb
	SgOG1d2KaDKHC5WE0qSUdySwJiTnN4gn66wcU5ycPK0lyiwfTsZ1HnMXbtzJpDbsKiJsRjhSpGZ
	IpKtj4ljU+w/xsK0zvmCU43aqAMPqGfqb0hgkFVMnVsmCGOiD1Kb8YrodwjGcpxCJM1lTyJ5dV7
	DVqvqOMZmMZZBLQDksWwmxx/73HX60ykkaVp5Pa4y0Rw==
X-Received: by 2002:a05:6a00:1702:b0:857:726d:270c with SMTP id d2e1a72fcca58-8616dd51063mr41868561b3a.24.1788877416550;
        Tue, 08 Sep 2026 07:23:36 -0700 (PDT)
Received: from pc636 ([125.29.25.186])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8615404876fsm5590951b3a.59.2026.09.08.07.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2026 07:23:36 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 8 Sep 2026 16:23:30 +0200
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>, linux-mm@kvack.org,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	stable@vger.kernel.org, Dev Jain <dev.jain@arm.com>,
	Ye Liu <ye.liu@linux.dev>, lirongqing <lirongqing@baidu.com>
Subject: Re: [PATCH RESEND] mm/vmalloc: Use dedicated unbound workqueues for
 vmap drain
Message-ID: <aqAaYhLcyzscOCxb@pc636>
References: <20260905152717.11711-1-urezki@gmail.com>
 <20260905153704.e7fe650d0226c3e20c1c8449@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260905153704.e7fe650d0226c3e20c1c8449@linux-foundation.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 73EA214000F
X-Stat-Signature: 3d8miiss1hhff4ijbgwg59o5f75z16zj
X-Rspam-User: 
X-HE-Tag: 1788877418-894086
X-HE-Meta: U2FsdGVkX18MIaPFSRk01t8jWCR8w83fD38esTBGRp65JjJR0dVMZIeaTd/qHGuLcCbRY8itndkqErnf1NYGxQA/SKXi88FmQQfqWBOrV5wnTC7ZDgJrAxvVeFzK39I25yhbz5eGkqRXBhf0d7v9pJ37DYBR/a0d+GOgrAWIXePnXKaSXHITWJuzqoe9YbqcsD4CVB6ALJEqzEwXiNftKhZu7QTcVZtnE7k9C/I9k+rIcwF1WlxP+u/BbI4WTHU0lhH7qiEaUBxb5H3i53e1JI/zIMa/w4zGkRztEcxHM9nEAZdtti68AcexUgIS8vRvB/KqeIuJa74xN70WEfDppV0pJc2KkGTOZyMW+wFcwCDZTu43rMsoVn2nkgsK0WcMx/oRbHo1aJeggQ88Ua9eRjPlp50SsGsaS5gVcs4uDJdwRVN5Ky4U+wPn09MWcV3tWdlyGeIVdS8Q7+ptpBH8HYsb65Zy1ue8ZC7juNhrvxBPbeRhKWoVxWouO9bHXlmDwYz9Ro/0Ds7DK8fLUG6BfCz1K4zoKIcXnadEBLLkAlJDGSHUx3lkW2ZMB2lVsAfkVnoR5zcigBFxCcEk75EiE9WrOu3gd41fna4syQaRdhaLOfrbKxSRqm0GgJW6XUzs9w7118EqKKjpfMNzgA4SP3SgHzhCnvXp8FaGcm+vkJVAARB8EY96VW6yvhV0yzzrb7g6158CiWMTpl4JGwWK4rKIEcCdcikMwX6BrPJ03FelSN0vEZ+OcjLiyYnwtZp1XjGY3MVDYKLO6OmAdcKe1Ad/SNGkrKwUUBVF9Dg4Zqmqh9XRavbklo0qYrf9RDQTA/56QcImSli2QOZeu0aeOmNBCfnwnd3L+xJF3WbQ/cUg+llv9vqprMMMXdJ1tuRqGTpzdl5DfnBLLvIACGw4v+trI8RmqRFnetXpqO5js0vP+w8aHNNxVsSdNbcuLqnBLfoYPlsF8MaesP5+t/8
 1VU+aemp
 r+LtV0ZX8DgKqsdz8+I7sloDJap4p5Mdb9mDuBLSLCdNK5m4jY6410GEGAf1DaIYeNUJYxLkrwrcwqEnhILC2P4KaoxzoD0dig4CAwKR4BIuzu7kpq4v1kfh+UNQ2w7JMCSGOA+k6nbQ6twPofe44RcP4md99MgY029UbEoYM74OUJvebJcPDa9b8tyrGe/A8+u4PmO1czeEPBdqd6NJPFbpYdGCQMiW6z9dG11rUA1b1WVMD1niksXeAuaZirdssVu0UBKhwmEPWIWfFtW7zw3Smnsct56rarT/P0RhIwuC2gY2P8U/bMz6s1B9zUtSWEBU8YeG+lkWifB+Nj9rNZRXZRT0OW2bvBxx/VWezt5du0rh2aBTO/Oa7wz4N7Yc+HTQqqCNNxit87eo/GSqnOmYQKaHDoHpg6TZ6wuIICyKg5URhYpCNW+1yRB42D6iaHxJBMjT82VK1a2hSe6GfHR3aGR8NjUovm08i6Mn+zAZFwx2OBwnUfXO1BFFg7vvFMd7DeXpNZkKltDo0buqlx7nNhCA8znF2lQe9uUO4xjYUkX8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 05, 2026 at 03:37:04PM -0700, Andrew Morton wrote:
> On Sat,  5 Sep 2026 17:27:17 +0200 "Uladzislau Rezki (Sony)" <urezki@gmail.com> wrote:
> 
> > drain_vmap_area_work() function can take >10ms to complete
> > when there are many accumulated vmap areas in a system with
> > high CPU count, causing workqueue watchdog warnings when run
> > via schedule_work():
> > 
> >   workqueue: drain_vmap_area_work hogged CPU for >10000us
> > 
> > Move the top-level drain work to a dedicated WQ_UNBOUND
> > workqueue so the scheduler can run this background work
> > on any available CPU, improving responsiveness. Use the
> > WQ_MEM_RECLAIM to ensure forward progress under memory
> > pressure.
> > 
> > Move purge helpers to separate WQ_UNBOUND | WQ_MEM_RECLAIM
> > workqueue. This allows drain_vmap_work to wait for helpers
> > completion without creating dependency on the same rescuer
> > thread and avoid a potential parent/child deadlock.
> > 
> > Simplify purge helper scheduling by removing cpumask-based
> > iteration to iterating directly over vmap nodes checking
> > work_queued state.
> 
> Thanks.
> 
> > Cc: stable@vger.kernel.org
> > Cc: Dev Jain <dev.jain@arm.com>
> > Cc: Ye Liu <ye.liu@linux.dev>
> > Cc: lirongqing <lirongqing@baidu.com>
> > Fixes: 72210662c5a2 ("mm: vmalloc: offload free_vmap_area_lock lock")
> > Link: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
> > Reviewed-by: Baoquan He <bhe@redhat.com>
> > Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> 
> I think what we wanted here was
> 
> Reported-by: Li RongQing <lirongqing@baidu.com>
> Closes: https://lore.kernel.org/all/20260319074307.2325-1-lirongqing@baidu.com/
> 
> so I made that change.
> 
Yep :) Thank you!

--
Uladzislau Rezki

