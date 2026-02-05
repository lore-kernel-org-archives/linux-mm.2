Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD868EA7963
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 04:23:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302AB6B0093; Wed,  4 Feb 2026 23:23:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E3426B0096; Wed,  4 Feb 2026 23:23:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B79E6B0098; Wed,  4 Feb 2026 23:23:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 091736B0093
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 23:23:46 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EAED58A53
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:23:45 +0000 (UTC)
X-FDA: 84409109610.29.49C303B
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id C19D91C0009
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:23:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Mz4t8aKu;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770265423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qW0+moZctApASOdwQkaNncsGOVFnNExxcEZS6yJkS4M=;
	b=bDmq/8hHiIuJBNqAeNdIX+6xvfZwoNOOceH2ECJYQyJkNQAQTFZr7nXKKQvUJVyfNk3bHo
	CuSDRMV9ZLdSLTOwCDF92PS4EUPOZveCJdeI2WbKr3jMmmzKse3X2pE0mS2BErbkXtbKrB
	vopu9012xZ6nPEDjF0tKKEaWcQAxHtc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Mz4t8aKu;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770265423; a=rsa-sha256;
	cv=none;
	b=4ntFlmty+yI1B7ZU7g5sJqTrPy44VnNWF7663DavtBgpQuoMyeeBl28enGTagwB4sgjkkV
	5gJSWhicn/+JtHT+iN5WTJyfSuk1WIHFETpahHvJ5liBD52CYuqJ8ijVV6U43uarRMmLt+
	iiKBymsDmwt/6ghliLO+qwnN7es9+3w=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-8c52f15c5b3so42452485a.3
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 20:23:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770265423; x=1770870223; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qW0+moZctApASOdwQkaNncsGOVFnNExxcEZS6yJkS4M=;
        b=Mz4t8aKukJHDpjbLO//53khHftcnfvov3f2skduJnTmjQyvtIoHv1uUv423iKgdCbq
         iuQYASX+ZZlaPOyB3KG0cSg9syt18k/8wjeuy0mL0et9K3VdiVrdyevmhaCGkkErQhYs
         yjuufnXs0h1SqvyQpmKJiZotJkzvoqfysrSXqY/wlExiAGxFJJbRWgkdcdbGN5d+G0er
         VwiNKz/dKrsKWWJlQCi6rVfZZ1Shr/DCeWfX2fm9vw+JoPYEpftGrzLPYUVS7hyLo+KH
         mvS5UQDvjus6UtT24Xn4gPM7u6sWQlhWtoHgaRZaD25LQ/1xA0Iy6zAdant7LKeaMFCK
         Ay5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770265423; x=1770870223;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qW0+moZctApASOdwQkaNncsGOVFnNExxcEZS6yJkS4M=;
        b=EFCZayL2pQHzx4WWhHGeWmm3Y2pbivgs/63WExf6ZmwZxoPbqEQovk5KebUIdBGoFc
         cJnYhE64gxNfeZtMnlE4WJKupE4yrKZjMT3gosCgzTStsMnK/c4HZts3an3KS3Kz00qO
         HOmnfKP3zw0IDwXIRKNmJiSTtdvi34zyY0MFsxpKYfuYKPt0XVC3cxwANR05P+p1xG/v
         V/GBbJCvK/KP9jDHdT6V7Zn/FnVKAN6NLBojrwQK/H4nk/DV4HRDygrJmKJ+3ELMkv2S
         rSLJ/sTfC6TVCFR4cfqqTIlxaOtGKO6XrDv9DI1RUQLvIYbxfcBHqH7OGjPE40v3rnQ5
         aYKA==
X-Forwarded-Encrypted: i=1; AJvYcCW9x9K8TMGHEfp0Ag2lQpex5eWt93TroBsLuKwkpJZjNliIEDqMFnT0J6aZal82YnM5YCFYh0jcgg==@kvack.org
X-Gm-Message-State: AOJu0Yx6wDpvHMK+3Yl4BEh2Vm3H6GVAU4OOyR7u1MbNGVQWAsUkgpfM
	rbxVabRWLfeysVdr0Nl78CTb5or7m1VyjjMOFLREb+BzJWlvC2yipd/dfQmHgfi6u7c=
X-Gm-Gg: AZuq6aI8l9WG7p0dExqkRJJKTA4LXA6sY/eoH9KyiYjoqKmk9BaX5Yr1/9HXQkNvXlI
	fOONkguu+Xnfk1KUFxoIn6VxUnwyHPH8HC80Tpok1ILsPtaP4kOPJJx/C36gQ9fIL7VG118ckmc
	bzOlbEKl2EFbQGdEJhvg8rkv3dqtA4ducDQ1olew6VZTynI40ZeYXWEYBmIKE205aUdNZhRhGo6
	ljIRWJam206sMmi7xoDhuuaKnV7prV1aSjEMvhDKiq0U3d5E1yJYeV7wO1m2HC1yhVc0dPsS8sR
	SIVdNY4xyAjb6yd9kZwDPu8egcKsVlTPus7nNAXZnXnjsY1+kv6HYr5zjJTeC5mYrWieGzW2wiM
	k95H1XXW4noAU/XGvJs3c0ubb9A7A2kQzHwInrvur1t5kymlezUdXYqxcUcKdJbhPSekmkX901j
	p3b7huNoxsMSzEg4VxEOrypvM0tNo+2HrkGzhZXwYlWt94hHwEkWQC5zayIYUrLRKkvbDJTw==
X-Received: by 2002:a05:620a:c4d:b0:8c6:f74f:9b69 with SMTP id af79cd13be357-8ca2fa5e50cmr701545185a.83.1770265422854;
        Wed, 04 Feb 2026 20:23:42 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89521cf8619sm34240906d6.32.2026.02.04.20.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Feb 2026 20:23:42 -0800 (PST)
Date: Wed, 4 Feb 2026 23:23:40 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	terry.bowman@amd.com, john@jagalactic.com,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/9] mm/memory_hotplug: add __add_memory_driver_managed()
 with online_type arg
Message-ID: <aYQbTFLTRHiAnrKr@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-3-gourry@gourry.net>
 <20260202172524.00000c6d@huawei.com>
 <aYDmor_ruasxaZ-7@gourry-fedora-PF4VCD3F>
 <20260202184609.00004a02@huawei.com>
 <aYEZAUJMLWvaug50@gourry-fedora-PF4VCD3F>
 <3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3424eba7-523b-4351-abd0-3a888a3e5e61@kernel.org>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C19D91C0009
X-Stat-Signature: 7btyeh9cyosz7cwcu16qtox7y3hacr6a
X-Rspam-User: 
X-HE-Tag: 1770265423-143047
X-HE-Meta: U2FsdGVkX1+FC4cEP8C9XdvXe5GuHFjggvIu41F9a7LExfKWjIgpo/IDvqKWj03KflGU9wflKVgMLJjJG/fChpaG7qqFdyj0sX4dTbBlzQEUVb0Jcx0HiXImwXGjUIN5KIDQzcHD0DODEgUKPNHoRiM5qvyA0A0zSn11Q2XSAfF3X1KOYYqLX4FqYgYlMJjniXxBkiBF3rf2dHs5kaCBwUegKf54F/gZix6W/XMJ406RajQ/PXRKJR3zVlRJ5kjBCIKt3/BAPyRE65h+eyM5hrwf9YlkIRymTanOB+tuuVLEJGIP9Y22grqlZeet/xmj+zxSmNhV1zaSieQvMhYFo+Z1I5zP2fJbH0cy9Gx+Lepkal3wZWLkYHp1OySaDhAySaqg93v0rR7tqWxusB0tDPlaQd5KCh0HqJ4Dj//BoP8VK7VR8gctiznBBuirPHY/l5IleCSpT0f9ftf0uH7OZ824P9EU/kBgXvA0sWpWHMoqCbm2nGupV0oOsQMDnOofbXjWMmL4lerQGYfG0BqijcdR7wkay+of9oPM2cOmIEDfTy38SuxuxOekYlcQNeE0j3L3byVjOeRofbMctUHNyKA2aRDXxrm0PEoR3gFcn9gPh6eCK90SzOTMyIKgnCpCBK1xK/buu7ViCZtT+ceVQfHa0vrf+3dM87fokkTJ1yCbg5sszL+wclISk7uRqSemLYa79buHZ+h70wRDEkXlNTXebx0p0+M/4HUBN2l+Pvi9hc0RZAU30RyRJXXC8SQM+UBuizYEyF7tmdH0tb6XRhjPyT8w8DXNb95GOPg74VmRvcuuuiRRfHyAtF3bt0FcYz5/lstriekc2GpSRlYpkoV/gbf426uCtqJzXRYMhhMGEp3y/QyLjQkroRPuP3rY963+WMUycgkXiFrcrxhaVAKU7we+6d3w/Xd5yyB4lNMHDBFRf0t40XXHsPOqtJYGFY7Pm+p7NMGgGVtQCMP
 kzNvkpzn
 lwg2UqLrB2qMxrxOMTng4Z1lLNCqcb7BBMNJEWVn4bu1rYFi/7Y3YtMXEriT0soPn7cDvk1OtMNG+nT/uFgRKjWIMSixzg0YH9sXFBx9/ogN5gTC5E7SgSc2/oCGpmzGB/AiLoorcwHBs2gqINACH6ba8ftpY19Th2WtF9AuWCeRxsVH87kTT03rDXo2G/73/R9yprdhZnXf8Gv5A7xZd1KnfsdYsBH0QuFs47W5fIyA5TrE/8nJ48ZwztXs3DQma6jGlm/s3S4rYEnj4NzgbAtmzyR2kzJNyLjsFvfeoVlGps+N0kcOETHlnRPPFkwb8pAPIiBjxpWufhl8wahgWjfJL3P0hzwJa/sK1fk2Tfc92u5rXTLlPl6tnp7cfk4G7bUYZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 10:08:45PM +0100, David Hildenbrand (arm) wrote:
> > 
> > David do you have thoughts here?
> 
> I guess we should clean that all up where easily possible, but I don't
> expect you to do that.
> 
> For online_types I used it, obviously, to save memory. So I'd expect it to
> stay at least there, but cast it to the proper type once we take it out the
> array.
> 

I can do it pretty easily and pull it out ahead.

~Gregory

