Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21C3BFA1FD0
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 16:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531EE6B0088; Wed, 22 Apr 2026 12:16:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2B16B008A; Wed, 22 Apr 2026 12:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8646B008C; Wed, 22 Apr 2026 12:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE456B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 12:16:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE62CB75F3
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 16:16:23 +0000 (UTC)
X-FDA: 84686694246.21.31EA1F1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id C39FC40015
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 16:16:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=grwWin7u;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776874582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h4eanJxpXrlVIm1nqyyHsFboSSOCzHcJax3wSI6MyVc=;
	b=4sXiueIvIv1mjuebpov1UWVnV62lwal3R+PbVVqYzUfbtriDCDzcOlzyUJNRefEmi9iIAo
	65R4GBj+yJZOgCj0MTwT7yiJVjdd/PRu7jOfgSUGfDYf7mjOWK09SvofZtDs92IZqAXL1t
	MUK6mZOCMRKuru+eXKjvs3LlZYCBJcs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=grwWin7u;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776874582; a=rsa-sha256;
	cv=none;
	b=Y/fOddOYJdmVh7M5Wrz30uONA8Johce5n8P5jPItP7aoPDIzkR2QcSd702ZiPzxOYJkQK3
	v/BGI6SAbsHmibL3sfFURHuEpm0dYy2IZlV3XYIpnPYP3qzEUPQzgsCWjAXiot5u8VoLnP
	+bPfslmBYnoU/o1Sx/wGE/QIG5mFH4k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A127A442E3;
	Wed, 22 Apr 2026 16:16:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A938C19425;
	Wed, 22 Apr 2026 16:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776874580;
	bh=h4eanJxpXrlVIm1nqyyHsFboSSOCzHcJax3wSI6MyVc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=grwWin7uGtk1gv9Nd1Kir0V4xj0jvFveBwjVZTD3oGvKd49DvP5u6v8pEMgDFDEjK
	 8nYa2WCbvWrBg5cb74IPu+2P+U9wU/yhdPaOqzO5cUzFvd4PzavFN7L28PfJEZDPiF
	 oLViFud9JXn9Npa9J8F2Ld3c1PGSx5TEwas8y8pU98z9/7dYZBSIakuK52Nf4yFlCG
	 mQxzHhQt3J/6+cF0isxEoI5Mt2wE37hXmACmFH/xwAwXC6Hm1OvzorlgTf3QipY+1O
	 gOIhrL6N3RePh9Xdb1iRqXASSdxlfTFU4c25o88bdWKKIH5xF04Of98tB7atP/5Bdu
	 3Uczsh5tPB6AA==
Date: Wed, 22 Apr 2026 17:16:12 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Yibin Liu <liuyibin@hygon.cn>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, 
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>, 
	"mjguzik@gmail.com" <mjguzik@gmail.com>, Jianyong Wu <wujianyong@hygon.cn>, Huangsj <huangsj@hygon.cn>, 
	Yuan Zhong <zhongyuan@hygon.cn>, "jack@suse.cz" <jack@suse.cz>, 
	"jlayton@kernel.org" <jlayton@kernel.org>, "chuck.lever@oracle.com" <chuck.lever@oracle.com>, 
	"alex.aring@gmail.com" <alex.aring@gmail.com>, "vbabka@kernel.org" <vbabka@kernel.org>, 
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIG1tOiBBZA==?= =?utf-8?Q?d?=
 RWH_RMAP_EXCLUDE flag to exclude files from rmap sharing
Message-ID: <aejzSsiXZBK1emv7@lucifer>
References: <20260421020932.3212532-1-liuyibin@hygon.cn>
 <aeikm2e5Gh5reJ30@lucifer>
 <bc514883d6154420b3cfde4ab25a20c7@hygon.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bc514883d6154420b3cfde4ab25a20c7@hygon.cn>
X-Stat-Signature: h8gzxaaryh66sc87bm1yktfhtr1sjzn6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C39FC40015
X-HE-Tag: 1776874581-378328
X-HE-Meta: U2FsdGVkX1+LBdtVZsWoslGvmAztoBM0TK54lvmCmsAmW1rDWxnO+sicfqJuHdwDCX2fANmkvRY7anbdA1Yap5tSN20HFVtptWLAS+xE3TxkBCrRq64XeuPvAK6hOdnCBduXC2F9mIsBtvTvWWgtV9g2r2Pzrh4xgZaIqaPvm1S3t9F1YGUGtAbJLv2UkU0Fm6hKEAi7IMA6SgJVIUksg55M3dnlbCmdszcRDaoftH1FpbdQRmyLX9plheUKgsgxncSUBOD0K1FbJ0IhcHZrsOEXXb3DbRDV8paMVg4+x/2ZTRtpJSgPoOQ3ulW5rp+ozd1i3xMUR3PPiYrsp6IkoR/nQ7d/6Ty58ZH07edXGz/Luf5sg9Rkzgi8550myXuQjn6BmTKSm27IEqnZh86XssrsyzB5SvZ9yJB5WdhszQOdnMxLJ2KNnIX3WYdoJXxUjkgdzneIwyQxoxKThUQS+3LSI4m6LGBvdeDz8aszDwB7JbCfcsg0scQWTwzjgC0I5qFNW3ZrDOh1qYcUHO0tz9t4mMTtNNc01u8Mx6L2xMoer+DFjHQYX8O01XM9LRoFsmApVKTTbnSTWJXtz9N8ibrTJoudfB6lIOEAd5qmvZyeIoW2hEjsJQnyrAb1QMvkO+UzjM8IxMeJ9JuXOVHFV05vcAWARa3ZOl8352SP/stsjCVG4py7FfM8aTtHq5n2mGUJEvASWPIUYnwo0W5MfdBKwAcQI5iu09TCX2a0ppROwcrFjy5V+BHX9VjW98+qiWGQHIvAilD5QOOeQd3YqLPL/zxJY7esElNrid/I0sylKaEvxveYCxbAObMTyDSzY4YlSp0xjiA37urx8N0+YOK5bbwm+3z+iFjD8laiD/azIijsARRVOz8c3mkLxLOGpIDACPSK7ckFSyeuNfD10NdGq3ByTI1fmfcJYFr6BIWKJ9SYuitAL0g3iPV8aPXdzj6hi+UNSBfqAxdVUzn
 SQYzquTn
 VCZwCpn7EM7ty/kEyNABjF26ZVmayfGQXUv5WiUWkvo6bwHfiW+X2OCqQUShhBeu4Zkgi9Q0tKRx+6aL1Q4eBVuwny/Kt3w5gpW4oAiQ8uznU12vnoggIyHkFZ3XO+q06qz3B/6w42WGewoLvhf4TkOXALeQRdpbs89M+VTbNmMsNbOWtRUlXrYAbqYKycHv/k+6OKPlm5s5VIUtpNAd8k+cTJRxlUAv5wlu4XvlEqpsCzBLFN5fbib95JjA4DZ4NIV8Uw5Ag7zFjkJpBA9MIb/5ULObpS9qMdjokUzbge2U/kxAMw/1RhRhwY/6dzHQQxMmUGqxlmc9EIoxq5r+HYK0IrM98+jsTWe7b9IBgzAfV1U3vZxSGHM+OM0ChF92zdpGew5ed2vF5PtGJL39Fd1tg8T+zDRZksDCdtrnuzYLUp9+nVXBi5zkjMnjsK6XLOtdkcNCHFLYQ6ggoLBAifiID2cE+IBdviRrUwAZLX3XNp2rDiqJROjZxAUl+u6xSDbLw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 12:51:06PM +0000, Yibin Liu wrote:
> First of all, I am truly sorry for not using RFC.
> Secondly, I omitted many maintainers because I wanted to “not disturb too many people”,
> and I apologize deeply for that. I will fully follow these two rules from now on.
>
> As for this patch, indeed, as Matthew said, the truncate part is not feasible.
> My original intention was to apply this to frequently used library files like libc and ld.
> Contention on the i_mmap_rwsem lock (which eventually turns into osq_lock) caused by
> these two files alone reaches up to 70% in the “256-core execl” case, as observed from
> flame graphs. Besides, no one performs truncate operations on libc and ld anyway.

Interesting, would be good to see these? And more details on the scenario?

What workloads are contending that exactly?

>
> So I wanted to try skipping rmap for them. Since they are small, even if they cannot
> be reclaimed or migrated, I assumed it would not cause much trouble. Of course,
> this idea was totally wrong, and I will definitely mark such insane proposals with RFC in the future.
>
> These ideas are inspired by Mateusz’s work and thoughts
> (https://lore.kernel.org/linux-mm/CAGudoHEfiOPJ2VGEV3fDT9cDsuoHB-wk8jg-k-EK6JhWgiHkWw@mail.gmail.com/),
> so I specifically CC’d him to seek more opinions and insights.

I think the best thing in general going forwards is to bring up this issues in
advance, we're more than happy to look into things and very interested in issues
with lock contention, latency, etc.

And that way you can discuss ideas you might have to tackle up front and we can
give you early feedback, which should save time all round and help get us to a
good solution :)

Just send with a [DISCUSSION] preface and cc- people you feel are relevant (use
MAINTAINERS to figure out e.g. maintainers of relevant things, like rmap, mmap,
etc.)

>
> Lastly, I sincerely apologize for the trouble I have caused the community.
> I will strictly follow community conventions when sending patches in the future.

It's no problem, better to be direct about this - it's more useful to discuss
rather than to jump to a solution without community involvement, which might not
work out/conflict with other stuff etc.

Thanks, Lorenzo

