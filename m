Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 629ECFF510C
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 16:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66E4F6B0005; Tue,  7 Apr 2026 12:04:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61EDE6B00BA; Tue,  7 Apr 2026 12:04:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534AB6B00BB; Tue,  7 Apr 2026 12:04:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41C7B6B0005
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E73AD8C67A
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:04:27 +0000 (UTC)
X-FDA: 84632232174.25.0EB41EB
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf17.hostedemail.com (Postfix) with ESMTP id C256340023
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 16:04:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H0GWcRkL;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775577865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/Q48D8Y76BF4XdQr4Fvx/gDALKRR3Al5nOab68rKoc=;
	b=a7hi/D73MQkf3RMhEg5GLMIUDM4Fnj+uTU07CrXpZEpkZz9cEEbW6f+LX7/USsCAB9JfR6
	UmYvcGh9p99ftl/9mdE56jWmyXU9fbmMYbM1M63L5BlNrxf7QizlbD70AR9vpXknS4tkG+
	dDrGOJipk6MVc346vUU6hdxwK59olUw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775577865; a=rsa-sha256;
	cv=none;
	b=8cMef3ku8ozvPUvVvWyyASiB/8d7QCab+viIbISdVTlzZ0/9qmaqx03hkVq/7U9u6ludR1
	CdIqYcq24Qt637txNfmvaRgfqhSwBE/a/lN5zlMqIynzgwI3PQNkXQ35Z6OOs96T5vj9xF
	bJkXh+CH66Gx1VUzH0BwqKgnWsbIRvk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=H0GWcRkL;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50bbc41677dso75064021cf.0
        for <linux-mm@kvack.org>; Tue, 07 Apr 2026 09:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1775577865; x=1776182665; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=T/Q48D8Y76BF4XdQr4Fvx/gDALKRR3Al5nOab68rKoc=;
        b=H0GWcRkLLMknOgQZDlG9ggwaWyP5Zjxhae861VzbeuV/L1gszj88/nT1wdcdKBAb51
         ZaN2m0aru91IhmJH5/MQ7MCV5NVOUCOf8xGGMPqOn80v7F9Wa5Kn4GtZQKvY0LNxcj3C
         pBR+ezltfUah7Rg6l4XyeenPUgwwXC8UBnXDs3dSKn6uAtFfUUw583FD0e0mGGSPrJEi
         Bkv5a0DxjfyuWNMBeu/YBFuciWVMCJc/WaNGLuGM/C2DqNR4bmGO5WkODWirmX2MQ7wG
         U7YqeMfL5lkfkA2EsV7Ut079mfHEAr9r/zrGaqA9BYq7/7YR9fncUYuBwIQBTBmEfQhY
         hY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775577865; x=1776182665;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=T/Q48D8Y76BF4XdQr4Fvx/gDALKRR3Al5nOab68rKoc=;
        b=FfpqdCQsK4UdypYvIK4G3ml2bP5+ws1I46H4PMzIkBEo5oR+PVdVT2bWA2EG9cffaU
         4Hut69hfNkN/k2nLi+RtyWE3hzYPRXuvRvhH8gSv3AtZ3LAkc00KMtRZfDXZ4YKtEl4B
         an+EE+ImPlsXYKuInWYQ4bERPpsrIUbeArD/7vLSfETvBoMoKvf3fJkpiddBzk58FHTH
         11zR621x1zSnusUMQZVWptrGisHJv/z8MrXtXuLDQG3BpnTbEfOcyAErXOvYPoL11hWX
         I27FAbdeME3z6CiAnaF2isGwYJkvuTRWfF0BGieu8w1Tc0jMDTI3MfHFZq0BjJaCChAV
         7Pkw==
X-Forwarded-Encrypted: i=1; AJvYcCW5iHKSw+UmrQwcCqWN55PkNQgjJh5RW9aukxXHrJjtemdvCTPrji7u7LjnYcAmBkhSSxOJaux6zQ==@kvack.org
X-Gm-Message-State: AOJu0YwIz59LzgsADBRsfVsHO5xzbZ3D5pm1NpBQvbzCEQoagNgGtbXt
	TZ3U9ykWQuCWVI8p8+uIqsxbzCE3w7GlOefG97W5bxfwayTueNjZZMD8g+duqjUtDxw=
X-Gm-Gg: AeBDieuj++S4kvebx0UPh56k2ghp7dbL4G+pfjz10IHpDM99aA+7DqfDxcfWq1k3Wwi
	VEfN3+Towsbho2aOUNEtdtSOYaUuwRvKZRzxGGMcsArEy0/sLjF6BIYL2VCfHxl8PyIF7aFfJno
	f+rDgj9mlm6uXd9SoraSJ/jcsW+uOhlx75UbxIU7iL/AcbEBZr+cgy1O1+sEgjDmXwNRN+oHdTd
	Ah0IB7mnV1Oo5oDxXGz5PRm/Id4RWKTy3Yco/u0cAfzq+DMtEyZvSfQ/cFhdOF/I6TL3aLG6YT7
	AZAW1EnGHJIexYeAdwsFEiVCUEwkBU9FB76QLCiMmlIVCcQnoPsJLLQELjsoKekn3TNQ5nzEUXy
	ARmkOF4lMKpQzBAxEYqHw0rkmgLdL9detdTluMmVqfnJJ/CgXX1uin3VLrGoT4J3f6AEbBWnfGn
	TQAZ9xWK7vE23p+6NpLOEOj1L0WTDo2TWFlheudb6dM8h81XHdGg/qx2OLmM3zdrrMDLyMvMeX8
	MiG0B6H+X4W
X-Received: by 2002:a05:622a:138a:b0:50d:7c4b:5c5b with SMTP id d75a77b69052e-50d7c4b619dmr186155721cf.5.1775577864437;
        Tue, 07 Apr 2026 09:04:24 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-243-150.washdc.fios.verizon.net. [71.191.243.150])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50d4b73e7e5sm138468951cf.17.2026.04.07.09.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 09:04:23 -0700 (PDT)
Date: Tue, 7 Apr 2026 12:04:21 -0400
From: Gregory Price <gourry@gourry.net>
To: Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linan122@huawei.com, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com,
	akpm@linux-foundation.org
Subject: Re: [PATCH] md/raid0: use kvzalloc/kvfree for strip_zone and devlist
 allocations
Message-ID: <adUrBdqowW_XeBJF@gourry-fedora-PF4VCD3F>
References: <69adaba8.a00a0220.b130.0005.GAE@google.com>
 <20260308234202.3118119-1-gourry@gourry.net>
 <13f2856b-a5b6-410d-a39b-94cc48ca546b@fnnas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <13f2856b-a5b6-410d-a39b-94cc48ca546b@fnnas.com>
X-Rspamd-Queue-Id: C256340023
X-Stat-Signature: jhhi7jayzfpri5o5phq3x17bermh4ouw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775577865-303161
X-HE-Meta: U2FsdGVkX1/6TsQhSBr9yjnrh+Fg7xFNKtEOT9Xy4FgVlk6t5d8cOrIezFnoUXPESo7TBPp7HdbnWUATmU4XhbchZSmcabJ8pCE9kJOEJ7W8O9eD4KBr/+nCIjwJpqE7F2K9sotePxYATQa2mRuZvrY+XzzB9uNPrToP2Axz9BbwuK6BechVv6xTPc5tW8vk23GcFFIjZqQGV2gR861uDWmwo3VUBHmu3+A3BZeR77c2vlvPv2aWytB3nksDby+4XxI2aoST1RmCk5pobMN4cR9u7sqPWjqWPXzQF5nV2qt/6ezg37Z8ZUn4ky8LpUtYxJMgderaYf51/JdSnLTDefgbRqRrKuo93AJIaOmpPcZ4iGQ560hmN+e3PGQFMXMvV21W/KjZbWg+micQhXO77CXqVYC8m8EKuc67fBtbbj9pfztPK6rb/0km+Fnr2gcpVz7TbKqZwzh5Hkzz71Zvc6F9DSIqYDJnGgfnDQVGZP297h0JFEf+H3PertPGVWPFZ14PTzVYt1GbOw5dZTMue7yOiK/g30CvfGKzcEaVWgm463oQ7gf8ssawr0LWE7JxePpkc8BKZtCkspwAawJdK0kCxLpYM/+4/oRhPexgQ9SmmN5aIavXo+2GqX+jWkpCZokPCiLBNh8Mk+8Hhuq8w2svo0C7FqrPFTHKM9kQM/OkRCXPnrS8himQZ6yCqtUwYiJd6CqIonJ7jKaWljgT+xAGwS2fwh1vHDQxjfZ1oBCiawCruOMUJ75HWHcInwJIYG9Anx9MnPzQIMZyNvnBC7UeUUVQtppE2/FC1/p1IsRDcHZ+T+mGLR4njXTn5ODVyIYVyhuAdarkxCt24ckCvGjLhk/ys90lh6/YoPkWMMWZJy5ZGPzwzgE1u5Isx5gFdycpPMljz4Qtky7iCFIqNqDnIT+M6n3XWaLfudFpxIJWoJf9xIDRc8puQDfn3DmgJgyav4WKe7eTeRNwp6W
 kCH2ukos
 U0IOH6gkwvtj8B4IVSJB1FOjyOtKf/Hpn2DJ0QCNIDmb+UPZm4dHnf6LuukbE0KQjkFkCj1UhF53cgHxtbxIdDRf/uG+XXvyhVlOpvtJs9xnZonjfCH3Ar8DlMU4qL56znS5tH6foADYtYctC3FELlWNC5yEM7Ic/kByx4prgvoC9smV3riY5FHD+nsgmoUM1Pwg8Pt6imiB+RN3TPf5V2neSPCHmhrD3CVcDUZ+HSoNTSMxe7dT7YGTLO0e1LUKnBGsOH7nlsvKatWJm9tNGlCLZbbpASS6OsFhEk5oSsCC1qpejNp89ZtEqkzoz/QojNegGGrCXc9jTa2qwHVCznsGZQkLLEMqnb6YqLlYnsLDE+30b8iCy2JO5oaan5WVO94SO54Z2+7gT2w71QQQ51oWKAY8YKbcWdTA1QGS+yo3URav1L8BmUgZirRCZ67BS0psc45y9oWnUh+oJmKTCR5ZNwOmV2ODMGer74hDpmQdUOQ9TFeQ95V3mDj5UJPgVTzUbzC7TG40KtxvpXC6jNGkBqLkmQtFxIE6jSeDuDFejjlkn1JKCvZqHMGoj2Qsp7HlxrIaZANGudc/C08zwBnbV2NslywLEMi/HsPjeSujwz9BLzQRsFgkp5LX8API28vY8mVicqQH1SB8d05p11ktWqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 01:06:19PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2026/3/9 7:42, Gregory Price 写道:
> > syzbot reported a WARNING at mm/page_alloc.c:__alloc_frozen_pages_noprof()
> > triggered by create_strip_zones() in the RAID0 driver.
> >
> > When raid_disks is large, the allocation size exceeds MAX_PAGE_ORDER (4MB
> > on x86), causing WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER).
> >
> > Convert the strip_zone and devlist allocations from kzalloc/kzalloc_objs to
> > kvzalloc/kvzalloc_objs, which first attempts a contiguous allocation with
> > __GFP_NOWARN and then falls back to vmalloc for large sizes. Convert the
> > corresponding kfree calls to kvfree.
> >
> > Both arrays are pure metadata lookup tables (arrays of pointers and zone
> > descriptors) accessed only via indexing, so they do not require physically
> > contiguous memory.
> >
> > Reported-by:syzbot+924649752adf0d3ac9dd@syzkaller.appspotmail.com
> 
> Reported-by should be followed by Closes tag, applied tom md-7.1 with following tag:
> Closes:[syzbot] [mm?] WARNING in create_strip_zones - syzbot <https://lore.kernel.org/all/69adaba8.a00a0220.b130.0005.GAE@google.com/>
>

Ah, gotcha, didn't realize there was automation here, first time i've
poked at a syzbot report.

Thanks!

> > Signed-off-by: Gregory Price<gourry@gourry.net>
> > ---
> >   drivers/md/raid0.c | 18 +++++++++---------
> >   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> -- 
> Thansk,
> Kuai

