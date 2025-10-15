Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C5B2CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 05:53:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6460C8E0009; Wed, 15 Oct 2025 01:53:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61DF88E0003; Wed, 15 Oct 2025 01:53:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55AA58E0009; Wed, 15 Oct 2025 01:53:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45FDF8E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 01:53:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C5E7B5628B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:53:13 +0000 (UTC)
X-FDA: 83999280666.02.FD3BDC2
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf21.hostedemail.com (Postfix) with ESMTP id DA60A1C0012
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:53:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C0HMzAab;
	spf=pass (imf21.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760507592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFLT62ixVQldJQ7fYkTdCMI80L5ybOIFkFHbPj9dyUI=;
	b=fEH1Wk3iuYxx5EQ29O/8xdSH2Kadegqbz5h/JSK3fV8g2WvBVCZ1S04uLQE938WiiUDvS1
	Lmuq14n8/exu00rQm/QEBOlPb2UE9XOAap4xihVbVLQWkY4C8Thf5rNwr4FMU3mSRbKMMo
	Rhj1n1zAwT8ylBcHH0fJWL+elQuxhUg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760507592; a=rsa-sha256;
	cv=none;
	b=aZ9+cyKTPQd6gGzigQ7+7pTOLNFNV8Nt4DM1I0eQHBPhgXlYMKqOoWuIoIiTRAFMwf87As
	8wPeN/ILuTSP0k6za2eyU58Ty7h+JVCRwQt31YP6Iv4xcLTYn9xmxf+x0R6MPWPV9nRAWP
	mKXay1WZv9dlR7RcWulz78ePLdM/IIs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=C0HMzAab;
	spf=pass (imf21.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-57b35d221e2so1008481e87.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 22:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760507590; x=1761112390; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFLT62ixVQldJQ7fYkTdCMI80L5ybOIFkFHbPj9dyUI=;
        b=C0HMzAabegofrTMG1EUut5IsQgCnIzBKoK9W0TxaersSuh/uziWel+n4yW1t7zzfgy
         vWDblFPgAHmVBXnUsfcoEOJlVztXigzJ3MJQwq/OwCyBdc81fRQtEhc4mgbyB/3aGtds
         fwPzqS3p0bvNiLIU6HR7Nk1T9rfU9QcnEiWPH1300rr7+1yYfVHuVXn92CJlbnmmXqsd
         GzGZ7MggueTociX0vq+atESDa+2SsNbky9oA8rNKMltEO+3Cd0+v+dkNLCqinZia4R4y
         +ewqnP+4m7zRllXVCE445jbHAw6QKRHA5osLimXomKJzriBrutBVh1EGV/4WIkFvvSeC
         o2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760507590; x=1761112390;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kFLT62ixVQldJQ7fYkTdCMI80L5ybOIFkFHbPj9dyUI=;
        b=TrRRrlsILDYmAOmRYa5J4tJVHVmb/Qf7aXAbTpnR1NztSZo8/K8YMlCBRvR/oVICa/
         3j4Zs1/ba9F36SUK5gJRnmToFCUCbr4I7qcvdPYw14YyqGighXCEsByeZhPhdo6lXW/8
         fkPIE/y78nbGKbp0cUTkKV2cPOQioAliveeXn+Q0h0kwEO86WVVtSzHVaw/B4UlZwR3V
         AfB+DNvZDP7buYwcQvQWwHPwdKEeGfE20W2oNc8USwP6oHdBXCCdpbDPyBpdkRBxjNGx
         5Sduj2NDQFAVUd4jmmb2J3TmyXsG0z+gUF1ZbTi23Fvm8OQISEdMbVmHq8HcL6PjuWcL
         fkSQ==
X-Forwarded-Encrypted: i=1; AJvYcCVJHtq7HVX8/DSyninED2zfj6oYvHEsdPwkBmukLb3wqD9mRosITvc/cINi+yfbkCK243qd73XfuA==@kvack.org
X-Gm-Message-State: AOJu0Yxo4r1FJdHRo4p/n17yCHLEVQ/caIuzc5vq+AMZORxQO6TDNcZ1
	HdXWPwnn9yg6/CvkSHEI0BRZMsAG8l3PePu8H6jE8qoAp4XwGojMcqLrygen2bhYi3rKmx68g06
	HhEDVfHsmRYL38mLBACuUKajGEm/KrAE=
X-Gm-Gg: ASbGnctlCaYWYifU/UQ026/8mESd7wpqubiLoogkdfv9uKGFs4jQFxT9/Vo/hT1D+fQ
	YJHekQKaPTGmZBvFxnSJPcC/CJoA3sl7viMG5p7iBKmEzdNtK4Oqtt1AojArvyR0J5784xPdMpO
	OK8IkdR5mOpZgPHXft4p3KEARR68VR7DMJrao9fC93A3B5oRe0t0PUMuU8rFHdDqoEAEVrXrr3n
	ijqMyebA3eSjJZ+E9XGB3/7E4I=
X-Google-Smtp-Source: AGHT+IFLUphpgOZG5QCNUsC60fCVIMlNWQyaFYF7MclW2rvaBp7nodjf6JgXjXmvHO9NPEejKXvxuliDGWMWkHx4m3I=
X-Received: by 2002:a2e:bea4:0:b0:36d:501:76bc with SMTP id
 38308e7fff4ca-37609c975f0mr40445141fa.2.1760507589531; Tue, 14 Oct 2025
 22:53:09 -0700 (PDT)
MIME-Version: 1.0
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
 <20251014083230.1181072-3-zhaoyang.huang@unisoc.com> <87953097-a105-4775-88a5-9b3a676ff139@amd.com>
 <CAGWkznGN7W-txq_G+xpZ6DtH_1DNorYc=CxqUjebo7qfB4Sxsw@mail.gmail.com>
 <ecba7133-699c-4f3e-927c-bad5bd4c36a3@amd.com> <20251014171003.57bbfd63@mordecai.tesarici.cz>
 <97da9924-9489-4d30-a858-8ee5c87bc031@amd.com> <CAGWkznGnmb=8GgcrfDvY2REHdRZYVXZy=F3thXhK0FaSoiK7tw@mail.gmail.com>
 <aO8TKQN6ifOSMRSC@casper.infradead.org>
In-Reply-To: <aO8TKQN6ifOSMRSC@casper.infradead.org>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Wed, 15 Oct 2025 13:52:57 +0800
X-Gm-Features: AS18NWBOWQWzhWDzp18HSEEZyxB5KfY1PDfoAz_DuZJ3dbHjn7xlZV-pDkl9jw0
Message-ID: <CAGWkznFG2_WGmLRmHnjV-49iTX0mrt9jxQBzZYK=K9U7eKJD0g@mail.gmail.com>
Subject: Re: [PATCH 2/2] driver: dma-buf: use alloc_pages_bulk_list for
 order-0 allocation
To: Matthew Wilcox <willy@infradead.org>
Cc: =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Suren Baghdasaryan <surenb@google.com>, Petr Tesarik <ptesarik@suse.com>, 
	"zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Mel Gorman <mgorman@techsingularity.net>, 
	Vlastimil Babka <vbabka@suse.cz>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 6u7ffbd556b8moa3yu4h4crbdcm9btw3
X-Rspam-User: 
X-Rspamd-Queue-Id: DA60A1C0012
X-HE-Tag: 1760507591-102875
X-HE-Meta: U2FsdGVkX18h038rWaaXdrse4eizXrHHvUkI/CLQeq2TQ5MIbeXS5yX6iPHLwj5EUfX5sm2Dvf9MkS2M/PU+RWJdyr+QiTaMiiVK638tDxJDyL1ChweSCemSsky1N2HeikP2P1Wm3QxhCNfoKRVyRdEKnwCuLuIfaw+F1R7MN8jGl9hur/5mXwOWAru8wihm812wSXNk2Phm4FIQ0igNV5DXRWJ+dwQwOBHadIyIf3sL/VSNc8lwzlQVBNXeh/0GHnamhbGOUsGtmkV1SbbGnT7W6LAOxMkCKcpqEnEJXlXe9tJsFwPdyo9GeVl1kr7ZE7aKsy8hqyl4nfAZwmSYrcgYv/H6tz/vonRSd1IGoyVNoU3SsyFyCR7nRKymsfK7BCIu60BWUQayZ6UNybXVtg57PPpcGnI6TZhZC04YdhDo4SiOas4nDHV3diHSoeWbx/CY1KuetD1QjUtR2Y4iMbfbqsNJpqeSIMRhiALJauGnOe5pViYuT7aLIvITst5Uif7ynQJaCiW4u+pRSxv5seMMAlLNEUlqQ5Hig4nKQF+dQa3T8xSCRzaEO170mj8Qqo6IPOQMOel+XIR7AAsFR3kJf41G7/lRWIkAMY5sVfUygBJMPSF5BAsl+mt3sih/AtsvkB0egUzLFuDhpMu9wf6s5u6MuNXFByUjeKgq2yKGs4aFmBjuxp/AnuWAw5Ki08KbtU5GQxLaHG8WdD1GOIb1QImyamT5pTk4MNLZo0tgYEpLfCrQApGYxbbG2ymM0okr5v0vm9CjI82oggqqyhkLr5W16K2PcPrJxqKo601N5RR6+ail79Qf7dCNWI6V/37yXWlAhYF3s/mhwfBo2OnOi4S59OJyvsiKrOLuvFx14AZ3A0f/7vFNROt83EFHnWAYJqs1AqKPt3qJOzj/l8ScZpmPfE13xleKpRAwAazrzIhaYyEb6/55tzd53bSLHGRaFSZuV0KBTaZ6dUW
 BguXRjiF
 L1k1XxnFxZtsgpynaXH6ao7z+XlF8KntofzJtm2O2fWE7H/8/V+lQR/kNuZ8XEfWBW3871PApFyi51r1f7l3QrbzgibzybKfpjIVH5yq4hgbjE/KQd5MpwT4sMkJQ0BXXVYA6eKK3f7wmeuIBAHnVks3sO3z/snemI0+H2DDGA0i6AN/urx25B1BNwtVXhV31CwYX7hoRjrTiNwRYL7ctKBBiVFJJeQAtwhEMmki1IHAdDAXzETT6ou/GVuZpjd0LfDGa3wBTJd6lfsq2FJH4BcvwKYTs3qpr5t43UDTzZVzkHCMcvSeA7H8QkRqiA8tQz3IDGSP3Pqg1QFIJZk2Bx9EMncUfBawqPbi7jVYTCnGCqppP1EEsbvBrDZ6S/zBbyzcE4GXnaOcSvTyvNchCN14Em0o1ZoDRMrONRaQdJZp0RsnqMSJywghG5qD2uK8UThpm6Jjssfq+DwX0r8jZv2IVHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 11:21=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Wed, Oct 15, 2025 at 09:12:07AM +0800, Zhaoyang Huang wrote:
> > > Could be that we need to make this behavior conditional, but somebody=
 would need to come up with some really good arguments to justify the compl=
exity.
> > ok, should we use CONFIG_DMA_BUF_BULK_ALLOCATION or a variable
> > controlled by sysfs interface?
>
> No.  Explain what you're trying to solve, because you haven't yet.
Dma-buf works as a memory allocation backend could loop thousands of
times alloc_pages for allocating order-0 pages to fulfill the dozens
MB demand, this commit would like to replace the loop by once
alloc_pages_bulk. Whereas, alloc_pages_bulk_array perhaps introduces
extra memory allocation along with direct-reclaim which could be more
expensive than iterating the list. so call back the API
alloc_pages_bulk_list as well

