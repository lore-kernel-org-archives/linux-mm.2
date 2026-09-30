Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 421D4CA5FC5
	for <linux-mm@archiver.kernel.org>; Wed, 30 Sep 2026 20:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3586B0088; Wed, 30 Sep 2026 16:42:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B64246B008A; Wed, 30 Sep 2026 16:42:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53306B008C; Wed, 30 Sep 2026 16:42:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 75C2D6B0088
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 16:42:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EF9B0801B2
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:42:43 +0000 (UTC)
X-FDA: 85271602206.24.4AAB2FC
Received: from mail-wr2-f34.google.com (mail-wr2-f34.google.com [74.125.225.98])
	by imf21.hostedemail.com (Postfix) with ESMTP id 300E71C0006
	for <linux-mm@kvack.org>; Wed, 30 Sep 2026 20:42:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iUC2BsxV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790800962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mwbcEmf8gJZTNKkPLveWt1KeSmrbmyjXRuwXnFG5/0g=;
	b=QliErRiqVztX5prS/cRSBPSuSbYVtiw5ps7x1P4DfGkCmTVAjOfbr3VW4FDYOlPVRvFbZM
	UNm7ooSIop/Tc9Snj4pmGHRal8JoTTaeQdWigDku9xtAC6Ms+ydgJgK4eiRKn5ZJk9+SNc
	1odT/Cj4xvlsjQAYCenWs1M/uleweHE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iUC2BsxV;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of azpijr@gmail.com designates 74.125.225.98 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790800962;
	b=DvdvWNBIwXoAaOBYuOXu3nQu5rUUCXM9K0Gjvv27CnEQwA3OKe0JsFr3k4HNoRjrNwqYmO
	YoqWM8uaOM5kUbtlC06K/9tDd63cExzymdg8/YAN5Naiab/+r0/cO0V7JvBxJQrI3ENTlr
	uB4NSTMHe+9VncgoDd36KdYfIXnegO0=
Received: by mail-wr2-f34.google.com with SMTP id ffacd0b85a97d-48af0707d41so1148397f8f.1
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 13:42:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790800961; x=1791405761; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mwbcEmf8gJZTNKkPLveWt1KeSmrbmyjXRuwXnFG5/0g=;
        b=iUC2BsxViDeJjnVdJMKKjo1JbTQuj1fdtMCJrGd2HASQmUbMh/2F6QKceiUlKPt4n8
         xmEip/PSZkE2BKSQifapU/fbKyOYEGK2Wrf8hb4E7qBegVpySgikr0OVqPX9Zz3krbUU
         0jB2MGLKLoVYBnf8940QCdS6PR/dWLblyn5R4e+bc5USefvDK6lI/WpdsE0vCpKHb1K2
         DXI3EOi3FeqV29pYSgtdO2v9Vr71z9deVdhR4efcjN+jh3NHxIZjkPHwee8+NXXEtqyq
         /p1oQVBUD/6T2b78FP3f+OBIQWQnhm8KcDgAGiQlrpnLcOdh1K4oujiUzcL+iQd4jFFn
         sZog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790800961; x=1791405761;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mwbcEmf8gJZTNKkPLveWt1KeSmrbmyjXRuwXnFG5/0g=;
        b=IF+13OEahPWZzNpAinn/h0vJGXfS5XeQI4wxFdGZZxXoqyNzGtwtRRxx8out9j9EBY
         Wv/5VmxWIgcIJKGuydx8x0sST1oZ7eaKdN4IF7Idy+Uz3YgZxyuAPAi2ASUa2lrcZf3y
         FpSoUqtzDaLcjp0aYT2lmsO8ENBYSCp7D05yGwxUzoFq9AmKItIGNtqHnt5JfikJ580P
         aaI4hWvFfDmPUlqLx+ZQx2fYC2agTdYzafsDaOx2GCuOetIDQF+p/ZxDe/2GaECStZt0
         rN8jfQ1QLp8aZ9oFiV5LNlD8Gjf3akir4WMqxAlIWyrrEG5oPld08RpsBjN7UZVlJNXe
         RLbA==
X-Forwarded-Encrypted: i=1; AKwUvBzODXoJPacF3WMzreDt+qXrJlIohtNQdPHFgfl834gGaqb+klafS34cRG1NECT5ZoKpwDCYrY/X3w==@kvack.org
X-Gm-Message-State: AFq9FYJtYyq7zUDWh2ta4YEFckgOY5OLL75mI+JrHx+XH9FJBiJnkFQj
	g+pttNOelMZ27/SvAO1iIrAHKzu39isZC4nBgpJjuXSHAetP46wVpMO8
X-Gm-Gg: AYBFou0xSAG9sUDZaYzIMllvNKaNMP7xctomLmFFXjC185VWvahuk4/riajGO5tw+ae
	xj5luw5xY8RU3etPRwvS7ExvKZ421FwQqq5qGaJ4fan/4etqi9zY4xgao59pfIKP2HIyiWggWlc
	oZ64WNcvUJEC2P7kEpc8EODlKqVnfvNELOoZv78UVYQWE/D3bV8HGe1NrqNBEq8N857WujvOJ+e
	kZ35CXDwnRDQBzQQcBcq+aWmLu/Qauk5EQy0XGg2muwto0fJQ5YO0OxKBoL5rB8GS30YrVEwnnB
	4BEFeZLfmLAnXioYTrSA7wbnFqU10mPXAhjbwX9Yq3pKTH69cCdz08HvQupBuuaw6CjFk2PsQ1J
	BarpGkBYw4yvjpZFB4136ZhdBHZS38dH3yAr60i1iaD9eFEBC7vPrqqbybJxU242QyDlsvB79na
	IMMCoBkDk7qxipSKRRWafTdBRkRAEMomWEEu6q7MjKiWTqtXcymalhPO4zeKxOnmTIvNfx7g==
X-Received: by 2002:a05:6000:1ac8:b0:48a:ffe0:1497 with SMTP id ffacd0b85a97d-48b068cfa97mr1394230f8f.20.1790800960456;
        Wed, 30 Sep 2026 13:42:40 -0700 (PDT)
Received: from gmail.com ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48b068bc944sm1646164f8f.3.2026.09.30.13.42.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 13:42:40 -0700 (PDT)
Date: Wed, 30 Sep 2026 22:42:37 +0200
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	=?utf-8?B?67CV7YOc7ISgL+y7tO2TqO2EsMK3QUntlZnrtoA=?= <ts930@dgu.ac.kr>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/mlock: fix zero-length request normalization and
 integer overflows
Message-ID: <ar1y9pekhVr19MDm@gmail.com>
References: <179066531783.50175.13377521828379196177@dgu.ac.kr>
 <3a95d0e5-7969-4b0d-988a-ead62b06b6f5@kernel.org>
 <art6x0XpWcT2aUyy@gremlin>
 <CAFPGN2jPGhcWVqa3k16RWMaMR3TwKyhFbYYF4D3L6L85T8E96g@mail.gmail.com>
 <7d120555-0c31-474f-893b-e5ee3466ead4@kernel.org>
 <arz82IHw4MqGTb6l@gremlin>
 <091706d4-96cf-4dbd-8f9f-97ebd3f8d81b@kernel.org>
 <ar00Lx1xB5rvKOdu@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ar00Lx1xB5rvKOdu@gremlin>
X-Rspam-User: 
X-Stat-Signature: 67axmhmqta77e4i5qkqs7xe8osdd6t7c
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 300E71C0006
X-HE-Tag: 1790800962-164349
X-HE-Meta: U2FsdGVkX19mPlm/M1RSY9xsKTu3izFpANtPo4G5tTPfuHEZJlwCj082fRwljKoxBCFfcfIGIiUCfYuGkUhmLjICTc94PcZNzmbDffLDdGZ0W21QSoAFsdNVaV5tvO4SgaHV+B7aBIvS9EXjQ1nVtK/Fjz6BroqSC3nuSIgciTdWX+vm1zolOszj/0bUvU6q5SQ7Qf4nflgiVYmgloCqvCiehmylkLrW7FTrcsyLAnY366/wIWv5n2HEY1JcZETaRU6qK1p8LVvfnsNLexkOgWM9ttbgiEMRs5LOcN2a9DIZaEeqRRsTzhdBizb7dOQGfxbZZSJLpaI4bi/yL3xkGxVQhLa/5Nh+byWAiZFl6p6qf5T/F74bZKRLYJfhDbKDxJfpNMFWajZpBkneSRSpjiPbaOilKLi4kIHX+plerp+7XKPxlevMKTNl/KHgJY9gBS2RPJhLer4gHcdvSr3+bDBVHaKtIqytsCx7lDukbcc0Qy9orasRjRli0WVqjYssLrsxiBxErKTx8TIjNteUCRV+prUMAbmtyomGK3WLitAznnFIxic0MkV0lwAn6H82awlT13CrCt9u1gTv7KWEXLXYC5UjcEXG0y1m3MkfY23gJQnfPfy0yTl55/vlGBnLel4n48kjB7HgCEtck4JYngfHNz+STUNldD/9m07WJJepzQpY0BGzQaeEzu/UiiH470zgIRWR1eJWii6ojGq3NRkdXWm/2NOfZ22j+d05k+CN+n1yGuPBzqQW2k1oUHu5HByIAYO2pnKUSdCgihzg9IzH4gIKA+4kMrkTonbd57QYBos59x7A3E2+CXLswpgXMgy14oeHjFOPHoYahAyNelEsI9mCr9I3hcZExkb+f/fqX8s+NYfkgNox7o03bfDLEyRhliwT+GSPz4xZOqAPDNorxxlKY9zx/xG2s6OTAW23w98N8j5i/Tbo6JnG1Hr9MPAcFrnX5ftxIs63ojO
 Wk3Smv6u
 oyT3ZteXAClq7nFHkOavXW0NiWMuYQSDoDvwJrI8eM+WB+CkexOdRLA4YwpDWUbmVAd1PsnrVsL5qAyqf96qxibm+OwFZm+eVXVGRNnMfrF2cj578JYBvWZDzMhc57eG83nsT5CAeGXXJEWkhipn/9gLQkJPfksEzuHHNw4JADakGGToMMaW1AmadzpV2kd2bjf5xeXXqsEIbHeOsbqE+P01h8MCfqb/Dnq1zi/7HV3IkoBW5q7DEAw4Z1mr9D24vUJwYkWwDV1vlkqesXPhKqc7Mvc8zfJ/x72PrXoyzpTkqj5AgIoK+8/iofq3DumyIhbAJaeGaQR8pM4xLtsRKS40hjT5+jbxQ6gLmxaC6qULV9w4H7ushmpcNkdORO7RiltG8cuBXBS7/I8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 05:09:26PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Wed, Sep 30, 2026 at 06:08:15PM +0200, David Hildenbrand (Arm) wrote:
> > >> So is this patch doing more harm than good?
> > >
> > > As above, I think the submitter has decided to drop this patch?
> >
> > Sure, but I still got CI noise because the patch was apparently not even
> > properly tested?
> >
> > So I really want people that send "fixes" to test stuff first.
>
> Entirely agreed!

if nobody has picked this up, could I take the wrap around part on its
own? I would implement it cleanly and test it before posting :)

--
cheers,
jose a. p-a

