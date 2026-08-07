Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 588C0C5ACD1
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 21:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4866B008A; Fri,  7 Aug 2026 17:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 634B56B008C; Fri,  7 Aug 2026 17:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F62A6B0095; Fri,  7 Aug 2026 17:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22FED6B008A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 17:22:56 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3701A1C0097
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:22:54 +0000 (UTC)
X-FDA: 85075748268.01.E6373C0
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5FA00C0005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 21:22:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hjAmc3My;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786137772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wGhPRnqQkvQ9XTDuFD2lcLHAbRWoNgCOpfXPrXNXFpc=;
	b=C9545pqjtDYLkwMaOOkQqT8bWKJncP4Cur2FaXIWQRDh8WwTlx/nwQ+5y5Bv2rEgrvG30v
	dM4efF64AssIk4xopDueBD5ZxN5xwH/z6wvvspjcY5uGnnWKbjlWMB6zxvaVoaqGk1+Svt
	qHQ5S/htr7fz5bGDcJO2pXkY9vJsq98=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hjAmc3My;
	spf=pass (imf28.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786137772;
	b=ij8MQbLA7CZ9e/8TP7/ihRub9KX52XYUGg2Sv+BYWBKxy7kV8SlbC6LzJiwLBE14J7j+2x
	/A4Lr1mM2jQ8oh0oXpDNua9asrugK4FW5JDoaNUUjcsR6oVioeiOdWUjpB06OtDNlvKOLp
	sEz9s0PfFI0CQi7MAUMrjyhoXhnnOz0=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2ce7d2adef4so287735ad.3
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 14:22:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786137771; x=1786742571; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=wGhPRnqQkvQ9XTDuFD2lcLHAbRWoNgCOpfXPrXNXFpc=;
        b=hjAmc3My8zw4QdDQ5oJpvAywcEZEauSHn0KXOL+JfCao/1xYTnP4z929TplFcDff1z
         N5tzIGnGlhLGKMehk62RkONjeMVPzbepWdFug8Woj8FxxoduLvbZA+IsMY9gUHlouzqN
         3stXIyhH1m9cEnO1t0fn70YFPoLg1ASZYxZheZoA3qT7i3g4pXozmZZUtif3V5vw+x1o
         jlf0w/phwaMrxHuTTIurhmcR5SJjFqUqwBy3vJ099E6QGoyvfWZns0Y97nlvtTyM3NzI
         omqZD/xI/r/tSt2EFRX02VDdz9Tf6peQ9RBmaJOi/WasWdJQX57yN5cywacMsxX8bSAz
         ATBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786137771; x=1786742571;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=wGhPRnqQkvQ9XTDuFD2lcLHAbRWoNgCOpfXPrXNXFpc=;
        b=poYY5PkVZauU530z1RGYGFy6Xdjcvr0Qhobr/8gcrOP4wmjS3+7y33Xr7ECYJrEKx0
         9YLYiQwfu/UUrhehIDIcaqcqtBrK0KqNWSqDyMAEX4N0bI/5b2EMvN6McgrA5NJODaWr
         gNUUX3L1P4xBvaRjWwud++sTB/W9VO3E0NlVN3qnaW0MHaIIyffH54022HBJ8L5H2naC
         TxCHmaMmhF+4PMr6pE8mFiTsdub4CKnn6SOiLvh/mQkpbTJ3rT7YNO0uqiiVnq7YbJC4
         pOh92roZQTdrCU3c+TRWNP5C1C501FrX1tN7nGhyDTkkcwWebsSAp766gUUAaJ/rUkH1
         Di/g==
X-Forwarded-Encrypted: i=1; AHgh+Rqykx5w1Q8nyHAwpqe1Y1YfITsKxLCIbJBG7RgYHtfdI4rNkRPu3y+Roe0Pulslsqcp9e3Ygexnew==@kvack.org
X-Gm-Message-State: AOJu0YzAuRXgMx9FqZ5EJn0TkR0QCQzkI6XTDDFcVCDvDZpy2hr6+KJU
	9bF6IY9HbkD4FPbNquV9XH/1egEnLIz/v4pHJK4pH3fWPRZto/1mhm8W
X-Gm-Gg: AR+sD13Q0eiRj4+LIplitHJH6+cvDJ5O11yrt7mus4GC6ffpTpZKCbaVeosh+qThc7l
	DCx24mKKl1BX8UeJW3LUe2OfG07uMAtgDT4WhbeTiReZ3tbZ+eAgCF3jjE774q7zv0XjYqVtw/0
	Q7pcwck4FstwwVm906mkFrKcRKbqmJ3dy7awnyYCmV62m1KJwxvlj4i6NDmGe3aofzbdzqb46fp
	Xe8fR9erpb9ynGzFBkCOi6C1tyQLU/UXb0cFTwwC+/lj28OiB3ADv2walMxeRV++h48wHZUR79P
	BjeVltvNdgU9Yo/T4FXgpI90XRvGfhPSLeQzt5LATk0j7JRqvQh7YQfnODAyvFc42IsQR+ulwrC
	7i+R49TVLRbyS4N7YWCSV7zFTx7J9y9IE4PwvGz+uYCvKcRAaAQHeVJnSbHAmtJahxJloCR57Ur
	sfsPYkbJdgvcXNExffxJqk9jkKW2pG9a9QbJR3s0/s1y3+zBgSCf+jVMseEWbCfbpq8qn/FANv5
	6+OXffHrM416BoA1ACs8XcB
X-Received: by 2002:a17:902:e5c1:b0:2d0:cc92:f7ae with SMTP id d9443c01a7336-2d294b29499mr79128275ad.3.1786137771208;
        Fri, 07 Aug 2026 14:22:51 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d14dbeaad6sm13880585ad.51.2026.08.07.14.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 14:22:50 -0700 (PDT)
Date: Sat, 8 Aug 2026 05:22:41 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Shivam Kalra <shivamkalra98@zohomail.in>, 
	Kairui Song <kasong@tencent.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	Nico Pache <nico.pache@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 0/3] mm: support splitting mappingless swapcache folios
Message-ID: <anZLkwwxHdhM2M2Q@KASONG-MC4>
References: <20260805-b4-mappingless-swapcache-v1-0-b1d78ba257ca@zohomail.in>
 <590B3189-5B66-4ECB-84CD-7B7EF18C0E54@nvidia.com>
 <anNOroQdjQh7xmU9@KASONG-MC4>
 <DKIRYOJXLIYN.32KI06POZL7SY@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DKIRYOJXLIYN.32KI06POZL7SY@nvidia.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5FA00C0005
X-Stat-Signature: ap5jgcykqht5oqcus65us6twqkr8n17b
X-HE-Tag: 1786137772-679561
X-HE-Meta: U2FsdGVkX18tsQLetcv9Q3s5vYi+d1GlVS5NBl38pxwrWr8Aq7omkgD+cgp2R/UNJOmytCt7cXJao4tJ3dimI20lxXaA7GVFq8QjuZVeKu9wMZ3e8jqWdiIT/QoSATQK7o3MMmThtpbT8hZ3IH24jJWTejzq9L40oEM0ICz1qGyOWWfnKAUMHKmjb5iJFvSHcvtdcvm2wjHCg9cHboY7mDBirqC6+jzxp9m8BIxEebN6ipty3KZ54QRTeCr4WOuINvMMOTdaFe3EgieODqtkupkhQhcNnLwfrc+nvXjxxDPJ94eOXe97i08TBJ7e36bTy7+uZlgVINBR0MYUisYg0QH5wd7/8dCseO2ywN3SEP055o7yAA7mJZFt7X2qS0Hbi+BEyOTZmvV69pEnhSDnIeQwmi1Fq2Kb94oLe0YPScxqa8LdxKuUzojST3HiURK69gU4LE+733EmZwhn9lUsvH0wLR7Mb/9TZcvkBPYw0YcLOd8c2zk1V4wCBQJ88LNFOKFma1KKHNXU/6BLcLiGS2I4HSjv5nZ9wk6QpisAzBQPPgOx/PnFw2auYj/b44X8va77p6pwQyRQ3SPoSKLsOxT8s2E30QkSlC3j4guK4ZXbZyiOmuB3OhfNBlwWc6Dm4wYjuX3GujBF4ShmSQJLHq6B/ky+3SIa2S38RARBoj8WoWYAJ1crCiNC3/5qBJDmVABLlhdcKwqXeVReOlffmVz2IIh8mCddXJB33YASgaKjRj2N/8A5cAMMcp/asdQCU0E28aOjguMqfs9MCj3JJf3vs553sVDwnrXnarasdVTqC4s9IJUPCkAEALWw/pmXkLg2lh4rSqLBQ+CViiudYEUuaF7vU6NGMz2trSNvP9P47oC28IRItiK738kQmQxpKP2wSMP03z8iKXQ/waHX1w0uFmtirTeqnQFPcqWtZ2+uBw6SfDjDK7aFvSvVFTx+yKfkjK4Kf+q9Bbv+Oqg
 um4wLgV0
 72a/Jie9i3L+ybufJqjtedG2weAs28f7y8X5uOrtjgb9XL/kZUR7fkZmF2N0QkoyXhWu6Qcfx+M/2ELSCEKca/mgDStna5Tk6PA+jAXzhF3TUtEhlBxehGtGm21JSgm+wu0By6OxA0Gp/tzcu6hO0j7yDFF/dDxYYrKJr2jQi1vw4Z+5V1nPlhzGSHalCzU3jv0gk9thauF/lc6Ca6YClstvKZhjy3QjUqLEGakQNycJTRrBYRq/+OH59gg5AUTaHG1bY6Og/gv8aZ3mw0JGk/bfcHmilWy4BXbI1oIO408bJTDsL5+43s/FOlEDK9vXn5OgpDPJ1c+opL9uDshjtzNFDPNRcoV0ZV9H0XzblsMhLNbqTdf4Fq0fCPFa5jLLG4q/PIED1VwEywWpivHLjc10CAxUtH5l3V9yaQiJQ3VecgbE6jDbXu/APuGY4HQNehvhs/O4foB9aZBAWRtur7O7kDFu7a1tz4Q7xSQZeSYMNSLG2vbuW5cWCMNB9569VH51O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 10:18:05AM +0800, Zi Yan wrote:
> On Wed Aug 5, 2026 at 11:54 AM EDT, Kairui Song wrote:
> > On Wed, Aug 05, 2026 at 08:03:33AM +0800, Zi Yan wrote:
> >> On 5 Aug 2026, at 7:18, Shivam Kalra via B4 Relay wrote:
> >> 
> >> > Large shmem folios lose their address-space mapping when they are written
> >> > to swap, but remain valid members of the swap cache. Folios read from swap
> >> > but not yet associated with an anon_vma can have the same mappingless
> >> > swapcache state. folio_check_splittable() currently mistakes both cases for
> >> > truncation and rejects the split with -EBUSY.
> >> >
> >> > Implement the longstanding TODO for this state. Allow mappingless
> >> > swapcache folios to use the existing uniform order-0 swapcache split path,
> >> > while continuing to reject truly truncated folios and unsupported
> >> > higher-order or non-uniform swapcache splits.
> >> 
> >> Thank you for your patches.
> >> 
> >> As Kairui (cc’d) mentioned in [1] (see “A bit more details on this”),
> >> we might not need to implement this split. I will let Kairui to decide
> >> how we should deal with this patchset.
> >> 
> >> [1] https://lore.kernel.org/all/CAMgjq7CHDG8JhesSPMkn1kzG8jKb0BXO756BvxMQC_MCn2eTyA@mail.gmail.com/
> >
> > Thanks for the CC, this is actually not hard to implement as shown by
> > Shivam, I just found the code more and more hard to follow and fragile
> > as we add more logic to it. And we don't have to reject higher order
> > split either which can be seen easily if the code is cleaner.
> >
> > Personally I think doing some cleanup first is better, I haven't post any
> > code as right now there doesn't seem to be much user of this. It will be
> > needed if more clean THP swapcache begin to show up due to things like
> > THP readahead for swap, which isn't here yet. I think I can send an RFC
> > tomorrow just for reference. I'm fine if we prefer to remove that TODO
> > using this smaller change first :)
> 
> Thanks. Can you also help review this patchset? The changes looks good
> to me but I am not sure if I get all the details about swapcache handling.
> 
> -- 
> Best Regards,
> Yan, Zi

Hello,

Thanks for the reminder, I got a bit busy so delayed for a day on that
RFC.

For this series I think it's functionally fine, just the split logic is
a bit complex to follow and we still have restriction on swap cache
for order 0 uniform split only. I'll have a closer look later. Also
let me know how you think about that RFC.

