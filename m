Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 218E9CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 17:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 787A58E004C; Wed,  8 Oct 2025 13:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738218E0002; Wed,  8 Oct 2025 13:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FFA78E004C; Wed,  8 Oct 2025 13:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 49E548E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 13:05:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 02CC913B941
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 17:05:35 +0000 (UTC)
X-FDA: 83975573472.27.509831E
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id 00D882001B
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 17:05:33 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cUzSCvX7;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759943134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PXvJ84I7DoVfJBSKO4yOsPRB7++PVFt2jBMWq/ZPjB0=;
	b=CSz2Mz/JVwAaFvgNCO10FUMzNv84NDz/wIv1ijAjuuZ0vC9+rwuWCBPG9DNgpm6yZo9nKm
	FfHbXqg74w4w6H4L1FBkt3xSc8JnGi53/s6BQPcxS3KYeUKDIG2PIRFWNYNHok9OeojtCF
	NmG+xYkQ17woQpwKirxrkomE3dH4vVs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=cUzSCvX7;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759943134; a=rsa-sha256;
	cv=none;
	b=PSidiDUGZknBel4W5lIJoDt83+vMo7EFWMpPHVleGwmXIniAAd0FAQTYGbInmB1/485ViD
	t7YQzaR1KrOpm/kb8rTCBLNldlPYbLGEE4Q7FeHux3f/vqm6HqxS9fs5+irXYcZ2JXRx+B
	7KRvLSXdBAeUXBVVuCX43wj7BFCD2cQ=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-85d5cd6fe9fso3798085a.0
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 10:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759943133; x=1760547933; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=PXvJ84I7DoVfJBSKO4yOsPRB7++PVFt2jBMWq/ZPjB0=;
        b=cUzSCvX7NOxAYxfCG4An47KJoVzRH40sgd+Sau/YnA+yUu5hupk3FAaSuICUog0m5Z
         KLAowXipXpUXFP8Tn6nDTP2SzxYKZ+9ycd+OpGFaORH2mb+5465kxdJZC7lbFooBSXq+
         VRe9aH/wpVcdiLfx8z3CRy5gTjJVM1AqqRlhPJxAo6eP7bNZTs8oyniCrN55QBMxlNW8
         RByqBAviw54kLc5v4A6gpfooQk0gKCNDxj9qm6PiYu+/ZI5gVid+IphQ/TZl1AVj0fKu
         VI3KG/x9qW0049U44vZTiPN7K4C3TZvnG+kY9nWVWPyVESMtk/wg9fz911H7BZAt6VO9
         ISSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759943133; x=1760547933;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXvJ84I7DoVfJBSKO4yOsPRB7++PVFt2jBMWq/ZPjB0=;
        b=KCOx/r59kBu5wAJ937jvmhR7EQDr5/eXEt86KcppqvTV239dqxtjIpv/HHG5cXUqYb
         9BZWVg6xPsxMkD9u/CiHCa+hG2tGrZEOw+QTCEPmjRyQbdOChrCn3/c+LP0b6hzMuDmO
         GyJuELTaHh2CxKRrQz0I9VmgQi+NlCsVjYDG/MEsmQWHPKhfHVD/pdsIrlQmK3bOec0P
         zMqfZnYfur3D63fYL7GB2ZOojbAhYGBiNOV4QrcZO2r/zXhqHVm0QLgAmE3Y2KzoefRB
         OJKzJHVnZ1Hh4CnciyNl/EHDz62oLRfn3Ng2hZ3fj8mQVf5lhuGyFPEVk4JsEzJv1GNY
         d6dQ==
X-Forwarded-Encrypted: i=1; AJvYcCWNqaOjgHYrFYskv0tio0ymrjm/f3daYe6s+E+ne/eTJ+go6R+DgPr2lF3J98lFPctMGTd+3fAcFA==@kvack.org
X-Gm-Message-State: AOJu0YzX+ZExeq18SOGhRK+SCbqUUIc/8zZS1wJE35+WHsA5FTFovpF1
	dNAXOD9FWNQESDSQQDX6CS/ipwbJWeLf2y9wzpAKD52vBlWGk8BD21ZT4BNelfv6dxA8okdWJ4u
	zqSrE
X-Gm-Gg: ASbGncs/vMNspXSuLcOLVDVzPdu3dfDHX2Ry+X2FJZp297Ov4c8avIyE37N1iCbt+tC
	arcGJO4IgVRACe6W8pTYi82Q4PetzWjS2Y38bVZZfkR2Bj/uHvghfu5qXhRyxDG5bZswEcfSZnk
	0k0KtcjaSvW15IVazWKE7IVQ+79F7ZDNm1OZ+0+8V9HmuAC+f8SgOXbhjF/l/RT6w+ATc0daYDb
	yEQvXxwvXYr0J/9yMQyPeNyFg5xYMc4WWiL6lYTdBV6LABKaJpDOjTdtmcV/CUo21RbGSZ+ElNh
	Oo/yxkv3BRungCihtHJqFFE2XWbTiEA+M6kcJTQmsoP2KTpy5GIBROt5EssvlL5fyESI227Kd3A
	ilc6+j+GRViNhQjrwH9BQg7bx3tItNoY8QRBdvKektstaSE5LFSg7ANedSCbFkZyxyqhJtOnZIo
	i61GDW8ziM1FbDu1IxdA0RfP2/pssLYXFfAS/RcXJyu25t2bxJHh4=
X-Google-Smtp-Source: AGHT+IHTTVXTCiYKFRjp/R7MyfRa3HWK9EIiUGj0jtPBpCzSk6p5BgpHTweDq92wD5qHBCW74OIL9A==
X-Received: by 2002:a05:620a:44d0:b0:863:b78e:d159 with SMTP id af79cd13be357-88354ea751amr597920685a.51.1759943132915;
        Wed, 08 Oct 2025 10:05:32 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-878bdf53343sm168514456d6.54.2025.10.08.10.05.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 10:05:32 -0700 (PDT)
Date: Wed, 8 Oct 2025 13:05:30 -0400
From: Gregory Price <gourry@gourry.net>
To: Frank van der Linden <fvdl@google.com>
Cc: Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>,
	linux-mm@kvack.org, corbet@lwn.net, muchun.song@linux.dev,
	osalvador@suse.de, akpm@linux-foundation.org, hannes@cmpxchg.org,
	laoar.shao@gmail.com, brauner@kernel.org, mclapinski@google.com,
	joel.granados@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable
 sysctl"
Message-ID: <aOaZ2o3l7ufX-9Ly@gourry-fedora-PF4VCD3F>
References: <20251007214412.3832340-1-gourry@gourry.net>
 <402170e6-c49f-4d28-a010-eb253fc2f923@redhat.com>
 <aOZ8PPWMchRN_t5-@tiehlicka>
 <CAPTztWaH7mJ3ACfqqYr1CFCDycw6Zm727t7wAa4n9Th22bn-yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPTztWaH7mJ3ACfqqYr1CFCDycw6Zm727t7wAa4n9Th22bn-yQ@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 00D882001B
X-Stat-Signature: w5e6b9w4i6eercqt4qjn8txfd7a16tdj
X-Rspam-User: 
X-HE-Tag: 1759943133-595628
X-HE-Meta: U2FsdGVkX19FD6brcnUogvY8/8fIxC0ZUVOtBBIe19reHbpRYTZzIzeImV6EW7+mkjFCM5deCLXZqLMm/HUvZ3fRNeO6GNxtNOoH8R26PxCiSvhxIVwUqDMnZVpnY9CN21svrp3to902wVa3YFIrWq6LM5gA7tVOq0t2R9tt7+fYowM6DhJ9h9hH4miqawFAz6mhbJ7T+sGOri1hdm7ctPfC0FInqZMI2Uy3nvKXwFCRzrNf6cqQXKQg3oThWvWnylvgIQtmLzlARdNWmofmEYVSKi1cjTXMIuwLOIJg2iifSYxgSTjNqEQLByNyF+VTwsAiFmzBzN3b91hseqvXSJd0dKGZYuEToTjPsgaxlovZbb6HKvFI3PaffsM+T3CX90/b03psFqVC+mKHAhoe6ithDjB5PvGsWlLeu8FCrH93+5cchsR61Hs5BIUlznfGzlBtvieoqxP00UStvM/56Dxoi8CWdmOvtqQKJYnVE6THB4VFb1IcYyyyXzBH087sBLOm+ys2HyLYPGd66VNp4QfKM7UJd4KJmpfmH7g26I6/TERzhw/ScbaRIiR3rw+6+zZRt+rEa5fLQf9ss720JFytARIJ2QikIzMTrzmvZFF3VvdXo2i9sW7KFLhRFQ1McIXN1YjKfpSp3KMHN75kkT8Zq9YDEU6mATgPJNV7ggpMekyYRqMU2QZXBPOo3Q71wjBKV7nBSVAieVAzzXZjSLs/Mmr3jAI5X4MZJyfrhQFv6Aa9C/GgMr/ZGAnKxzR1GH59sLv34RPR1YVE/wiHq+gC/tY4VFQrQpAAj94XHW/whe1kB6LFeHKuZVHwhcqzZfZ7DO6UUjRyeuAClat5yW3pcekC+T9yiW/hHjyuK6c3KdhKu3m0EAebasUnf5mdQP2VECXUTQUi5XFouBGkP+JsvzOa/5GgJSzLzEpX5H37gGjRj3h4hNHKcbO5gAP/g5Rrvr8QLFy7sCBca51
 Bjil58vJ
 oko5c6RaPsEKhVkWmj1eTO+eci0z6s58ox03iexcphj4MQgm4iryfLWCbRR4PJ/vto1HXzK4giDA+jRlpLS/geAzzzIvaWNbsqd/+7ZTkYmCdD8hZ3uQjtMgVbfXdrAwTaTTJP2XI/wV+817rBv5jF1AEWLT4TAHmGJvF6hC/Kk0pnBMRz5Y8go8oczBP0mXYgXzVOqr1GN1bB+44TR0PI9D3MrvwmcLy6L5HIsY2GmQfXL25agJbdWLuAHd/VcAgFqWbMKV+XaYtg306Jzxo4O+Q1L/kgnx03zampjk9Kis68YXJa+TFFf0bRhZ+G86Y+dl1kg8Ry7GrjlzohYyOIW1CzS4jWRn00jS0nkIVgTxEGW9fnIcCxnq3tV/aY5/Z33/gI+cPB2zTwFssr2vYgx0aAbH/74ClghsEsfxnmN0lFO7GVXFzo/RenAGbMSGQmhPZzkTBld/6b4Jl5hdcWlKkt5xiLe/bajz55b8uOPasftF258I9pT0NxRTYl0+52K0aCY8SpFoFQkgneXEzPdwoeD5Uo0KkCWVTqw8157bEaUk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 09:08:01AM -0700, Frank van der Linden wrote:
> On Wed, Oct 8, 2025 at 7:59 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > Maybe what we really want is to have a configurable zone rather than a
> > very specific consumer of it instead. What do I mean by that? We clearly
> > have physically (DMA, DMA32) and usability (NORMAL, MOVABLE) constrained
> > zones. So rather than having a MOVABLE zone we can have a single zone
> > $FOO_NAME zone with configurable attributes - like allocation
> > constrains (kernel, user, movable, etc). Now that we can overlap zones
...
> 
> I agree that having mutiple zone properties is probably the way to go.
> 

Ah, I should also mention that I've been kicking around the idea of a
ZONE_DEVICE allocator - but this blows up pretty quickly into
maintaining an entirely separate page allocator for non-general-use
memory, so i didn't want to start off with that until later.

tl;dr: pgmap->alloc_folio(gfp, order)

Then allow driver managed memory to "online" this capacity via
ZONE_DEVICE and integrate *specific* areas of the kernel to use it -
rather than everything.  The device's driver is then responsible for
implementing alloc_folio(gfp, order), and a zone_device_alloc() is
responsible for hitting all the relevant devices for a compatible
allocation.

I alluded to this in the hotness/compression discussions - where there
is some compressed memory you want to draw hard boundaries around how
it is accessed/mapped, but want it available as a demotion source.

https://lore.kernel.org/linux-mm/aNzWwz5OYLOjwjLv@gourry-fedora-PF4VCD3F/

Not sure if i'm just overcomplicating the discussion here, but if we're
talking about new ZONEs then maybe it's worth considering something like
this as well.

~Gregory

