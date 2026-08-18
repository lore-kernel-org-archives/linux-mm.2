Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02946C5DF7E
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 12:51:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2317A6B07CF; Tue, 18 Aug 2026 08:51:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BBE36B07D3; Tue, 18 Aug 2026 08:51:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 082A56B07D5; Tue, 18 Aug 2026 08:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD1F16B07CF
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 08:51:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6B9A4C0C66
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:51:51 +0000 (UTC)
X-FDA: 85114377222.30.976A96D
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 871D0A0007
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 12:51:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GNtJ8zh0;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787057509;
	b=3f7os/qsuBv7MUi24Z13NAsnfhqJbL8yXxzfAed3OOattyrViKzFSj5WRdfqtuk1Kz9dAH
	7zvd+2v1nouRF2rI/dLQD8vsDuS4XnxRRu91hjrHWGv7JF2Nmd/R6fxcsba89jWDkcr+4J
	B687I7GlCgrn25us41vOUrIcDDNWCBg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GNtJ8zh0;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787057509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kc5oCXq282LiDe88kKeCJ1XghMe7rR40RcvOL931zw8=;
	b=6iM5zQ4cxjRA0eIH67z+AT4w9+ulW/radXdqWzHXxnXNhW/NB+EG5Gl7Xe/gJjZpBZ7+hy
	BC8moVJyy225X38jZkRTW2Xp0QSs2Int5M8hlXySOoQqqpa69Em0/cUsCBdl5FiAE9glDD
	KEnnszI19Law9sUuSyDW/oO3JDhiHrI=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-52b3934af3fso45367711cf.1
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 05:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787057508; x=1787662308; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kc5oCXq282LiDe88kKeCJ1XghMe7rR40RcvOL931zw8=;
        b=GNtJ8zh01vL1i0BG0x/1EdJ0gA9NWJ8kTrDgy783+cjmecD2DKasDONcY/jRKFRR6e
         4I+UMqVus9GezGHWNcdosCqfjmvWKlojcp8ljqOqWF5aUijjFJyQwIGmZVVwTwkhP4qe
         a9dqNTXpiV85/zjdgFioZk1PjBMVGaoKdm7r6dm0OIdtWfTDJpL2otUo6HnBb+mTnKU8
         j8wPDK0+0IfqdB4MmNNG0PrQ0YDGjDntFf3ckcKwW6K1wvz3l3HzNLEW/16j3fFGDSqM
         hCxrAwcHcps2ePmQqLBVuGVLouNANM0M5B7+lT6+oXlH1eZEtlBrp7xV2UEq2L5ydUi2
         vOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787057508; x=1787662308;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kc5oCXq282LiDe88kKeCJ1XghMe7rR40RcvOL931zw8=;
        b=MiESvCsNHsLQu7dKAMr5Dmcx5iyXevFsziYGFZJYuTxVzsBfVSy9f9JkI7DPq9wInX
         3nHkNSK2qxjcL1J6Y3Czvf7ly5no5Gy+KabGtSJ8yl/RDoG3E2tldO0anNho64dVdp2N
         MUpiEXzWlz7YL12mkMfeH7bTmKzIT4wm4sfD0OXzzzRjMSkTBQKvnn1C4Sy8kSmeMSms
         oMDmxtDOfHxVQgqDxC8Nuah+UpOjK5FrFtxHuHvSQR9686LNrYVKpWXysYIXc4Oo/eCV
         foHvttwrAEnVUVZ27VeelcgwyX58uBXxohQkw04DMLg1AAxbm9xmKDfEk8b3ciiYUzlc
         QUDg==
X-Gm-Message-State: AOJu0YzoL1yoX9RsAG0hCf1Ejh+sYvNDmqSCTNHM0gHOiI+ZOb8HgPnp
	wPrkP+Ows+JZBUZNLMSP3QJ5RHr/tVvJUJZmS8uwDbBNCl7YeaDrbsmxI8C+UgajJMM=
X-Gm-Gg: AR+sD10MbsCc+BNqhVcibWU3ji/k0rmqvB7kcnkhNPHf271lAzlwoZTDLd0DBSxLpVz
	B1E9ya6rfmJdTRbE0RPQksC8nVT3aoHXjz9UyNwbVjT3mhG85Jr/nBCxY6cazhICMJtZYQRWfMW
	YDzAP2LmVZNm2OzeJAroaKU8HcG/jAG9DDOdl2eFWtGUi6QHjNnp6e81Fwcqn3qo2r7QQLUflEC
	2JBV9cyPTgakGR4pwSxSvC38yZW8+YQykOFH/T9gMAsf8t26rMnA77A9C5MDr26xU8d9GnOugFq
	Yh8IkRK4eTY+5yx7Pavww1pIvhY0GDbv6n9UzQbnCOz/L8mU88uDjk7KIGF9E3JpS+dJhlMtS/J
	trmgMr1wvEvWCErMnLtiwkmaVFqcAO2atS7TuWDXpoxBjpmiuuondikumGGKUKsTYrLo+v1+w/E
	jrrFABocP5ZGTI9otTCSxlZwAvdaHbv19MqkXing8+TNAO/mimYJdGh5tF3RCJtewZdM2QvlWgc
	FrTIQXJzp5vrIwYEkTgaYVn1h8cZNAmK5NduJEdN+Wa
X-Received: by 2002:a05:622a:14b:b0:52b:4e1f:941d with SMTP id d75a77b69052e-52d8530dbc7mr334517651cf.6.1787057508583;
        Tue, 18 Aug 2026 05:51:48 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52db613ca70sm37684191cf.13.2026.08.18.05.51.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Aug 2026 05:51:48 -0700 (PDT)
Date: Tue, 18 Aug 2026 08:51:46 -0400
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	vbabka@kernel.org, jannh@google.com, matthew.brost@intel.com, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/mempolicy: skip zone device folios when
 queueing folios
Message-ID: <aoRUzDNvLgmMCqUn@gourry-fedora-PF4VCD3F>
References: <20260817220810.1175596-1-gourry@gourry.net>
 <20260817220810.1175596-4-gourry@gourry.net>
 <aoONaAtLLnYAZnmG@parvat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoONaAtLLnYAZnmG@parvat>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 871D0A0007
X-Stat-Signature: c9z6atuawai9nwnb1q39smwiyiihprj9
X-HE-Tag: 1787057509-633337
X-HE-Meta: U2FsdGVkX198WzsTXOpBjpokBbypCWdIlSpuuOxE9IW2EOq5DsRakgZ5n1O1lM9J3lwHAb0ciTqPej27pzH8jFlGnCQVW6b0xEhnqiNd8THJHcHpUi1aChgr6wN/6C6yS1rHRvCqRwTH5f8ysoXRNceHwAbHX8XqaGZYm8B9s3UrgXjUiU3/yXOPmlJ/gLxOObfYVRAc0Gf++heTz9YYQ60LJ2AARSFF/oKnjylzZnF7Rt8jCGXeFOuz2xlCVVA2/Vde3zaE3LQ0Om9VGPczTRyoPtkoUxpWp+oL4NR2gXZqoaCpSbVSCj+ZE+0O7POGfPUKGT+OzPjvxhkvjbr17Ypt0WwRlc0Lcw7HgIbbEeMMV07EsuAguQyDnDu9dGRTnMQ2o1RTURbjpOxxaXKddtrVIY6JcR09n9l3xqJv5OhtqdISpZXC0gHlQxMzSmj84sVRYoESTH8I5tZeIXVMvwyHKz91jxEzHd10Qg/2EYrO0TmjIVz6ygodV6TWqcbQunbUTJeN8f4Oun8PzEOhpQBsnTtMwrgbJYn7zUGSG36D2Tf+id3SsP5aUvOBEq1H/ihLB5Sn/lk5qIT3/VmzAw/Dlc+2JTq0SJT7Vws42GJ1UEad+NMlVzksz1NOrE8Dp/GkHihRrOZuoAohCg/6/gFbawzKN7VlsKRKWcH6igYdq3q2XZu/l1f/jpqnE4NOpFugkxIv7JCd5Wut5s81Hup/8HrO2pVGIa9usTKejTiG91JoPfRQDAaNvzHrSjEgCH/Fx6x28SUYgAYLOcv3Vqb4CP2sOZf7mUmVHNFwGHzOOduo+nJbPd3nFv7otNaCgc+CJwar55+3mjKdHr7aKtla17y2FOtTKzil3sXkFQBaKTbpCpQ15WEQtTtKZSAblaEQgpXiOZGWcJsJGFIGYpTuSde5b9fkdf2lg3B/8Ag+KBwOEjVUSFzMwtqFO9TwkEB5MUDcZO3+r2XhwKV
 YAagq309
 cKK2H+fVzLJYdZAyjMpqjts+LtHvn4pQMeTx/4Duw2xjQxnqQL4zIbMhxZLS3o8wst+d5WxfDSxpv73lYZhJoDlNRaeganQ0o97PjrAGpBHBY1x3qPeBUhsBrpvH/K9eiQO+ipkN0IjB68FPRxxFCT9CmL9mt83BaNWhz/lJrk6JOkI59yJEViKJ4aIWqfy+50UMzSzmZ1S4cKZ61uuJgD2vebubYZ0ytakfe2LkSWUh3RDabfqoEmODe3cHh8wn8D/eRVUu2ZVfRBfc9Z4xlHk1zHRtb9Juf1gEq3NqpLHIvRCbMPEYmwqsoAOFoCvSO1204CewR7Geu7Aj/i8hnt6GFQsdkQwxEH5IYFNmPauFqEmN91PZHxc7vUTCcrPd+VUEH/f/ZiSrAVGWMhXjMnitdZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 09:34:49AM +1000, Balbir Singh wrote:
> On Mon, Aug 17, 2026 at 06:08:10PM -0400, Gregory Price wrote:
> > 
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 3498a5651d50f..3418b5664dcf8 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -662,6 +662,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
> >  		return;
> >  	}
> >  	folio = pmd_folio(pmdval);
> > +	if (folio_is_zone_device(folio))
> > +		return;
> >  	if (is_huge_zero_folio(folio)) {
> >  		walk->action = ACTION_CONTINUE;
> >  		return;
> > -- 
> > 2.53.0-Meta
> >
> 
> 
> A similar patch was sent out earlier, but that was only for zone device
> private THP, we don't support migration of device coherent THP today (we
> should add support). The patch itself makes sense
> 

Yeah IIRC that was Usama's and I got confused thinking this had already
been resolved - but i realized this still affects device coherent.

ty!

~Gregory

