Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 487F2C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:22:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9E16B00D6; Mon, 13 Jul 2026 12:22:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590846B00D7; Mon, 13 Jul 2026 12:22:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A77D6B00D9; Mon, 13 Jul 2026 12:22:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 244AF6B00D6
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:22:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B69968B48E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:22:49 +0000 (UTC)
X-FDA: 84984272058.30.EF0FF98
Received: from lgeamrelo11.lge.com (lgeamrelo11.lge.com [156.147.23.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id A4ABB10000F
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 16:22:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783959768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Dl0rKF+am0cYTQ6c1TjZQsy8kQf8JEFX9joyKGNQ6LM=;
	b=fLsmAjKrQUmt0FCZHcDG2obD29k1x4pEw4silpLqJ189x5fqdFjzvBz9e/+t/mronwiqbw
	JAGKsC7Vgj107sNBHFfghbJTZvHso8DuyQ9OWW7Pk2U8lJqJM2UFJZ6hUNEi4sIhMl3dSi
	PC9FRXcZXVhaNK/PeHgmN1vf9uMeveg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.51 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783959768;
	b=7eZ24M5YXb446H2PSI0WGxs7REy2PX7KaKKzrVbfh7zDBFWxH1qVNBruawVnaTyDnQQmoJ
	Vvtlwun1IGFDBf728lbnXiLp1qZevZf9//EbnsU6Wv3XJBnaMDuw8Jz+0D0gsCafBEzZTI
	ilchnRCe0LBf9rDrRY5bELEFAZHC80U=
Received: from unknown (HELO lgemrelse7q.lge.com) (156.147.1.151)
	by 156.147.23.51 with ESMTP; 14 Jul 2026 01:22:42 +0900
X-Original-SENDERIP: 156.147.1.151
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.151 with ESMTP; 14 Jul 2026 01:22:42 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 14 Jul 2026 01:22:42 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com,
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com,
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com,
	baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A4ABB10000F
X-Stat-Signature: qp816x17qohx8i8813sntshopptjcsi4
X-HE-Tag: 1783959766-735674
X-HE-Meta: U2FsdGVkX18rF2B7V0tp8KZQU691wufFBr9WMKExJgsM4GoYJwZlKoWKLscs9QGmB95EKLK/NFauPb+71C+370rUNjF/Jh1ODrFu16+0hdcMGMG5t70xBATNAzaqIhpl5byOyOJ1mpxnFbrTnxzOFFGBt2vbfXjDjkbuavqMNpcNtMrufOODJUTmeRdpsuy+Fvtqh5eqIRyoKkRvS8aXKvq5WxFZKtf8SZV2aDUuwHNe14MA8GDO0kE5S55fPsekcFO+TibYbfKTV9RBdgjnmkdu10GiNivOIc0n/M87VnKV3XL3CBrOSkN3TYatiQLnQwPoX25gkcfUjBqgpRsRNbfTogv2htFNtW/hLUEmanwapINFgPiblNYBe4V0eD97o8MHmugsPq4OGUqNw9E2Wj7CY28TBblZdH0dt/ET59x+GvSaR7yqKytX9iM37gO9K83VSVvBcyszG7Nq/C/ipoEa5fAANzIHdQueXipCd6Qie9sRyOIqUyNcdCtIjgZtB7qzGW75PCDXOpkUCZBHRFnuyOLvrivIxWbqbLsXfcDsRNTfMrocGTQ9DktfO8IyXpXwI38xdANvzfI0gkuo3fJOii29teOm9Y5METnuawwpsU5O5oYT64wojOE87gfjBgYceeqmr5lOVgZWZCInebURdv8yYsxcnSdEPJKU7P0hBF67njEMgBEn6p/cqVKR5+euHDgvc8PIwC4gQTAaEuqQoHIPYn/hQjdK6IYsHjN91aNabG9ZT89S0hfAV9lNnzvc723X6FxjEeUrMJf7kzOB73UZD29q7BfhrwWFOHt9Wi8RQa0MGOuZc04JOKJLIpWbcj8tyJhKtcVLKjIiD9M3TMyAXRQ2/eDEyZqubDKhKCTBrCVDfJ39MNm7m1w1C6n1h4KwJAtdqzzPXIkmB1oSrEsek97LEOrSrkra3gU3zpMysWfSI2zEm4DkLIG3JxFGEkNCBcexOe68qv2
 2+D9a6aZ
 kMsKy3y7VSHJfzmiiQBqe1nD7UKToDbKn+W4d9KUuyGT5qNBBrz22DVS5TS4XVbB0UnAxMqf+6GHJefZAkLAYeJ9asTHZfaKPoG9RXFP92k/YWwbksp8gq+vvipjSrm/t4r62quJmCAAZxPOCVvyuMvJdmV0zXe2+fv12hysPqEngC23i9E/E6r6VGznnTHwM79wyPqVCp/oAjycfnI2XOYemzLL47wrE4n+BYf7FJyP+DIbLupSR85TjJhb+k7gGR6UTq2BdMo3AniZ3s0EJWSDuNE61a+6eten+v9+3DtM5ps+34d2DpQi+zHZX82I41p94oVUac90xCRCWC5aNMglr4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 09:01:20AM -0700, Yosry Ahmed wrote:
> On Mon, Jul 13, 2026 at 8:57 AM Youngjun Park <youngjun.park@lge.com> wrote:
> >
> > On Mon, Jul 13, 2026 at 08:50:36AM -0700, Yosry Ahmed wrote:
> > > On Sun, Jul 12, 2026 at 7:57 PM Youngjun Park <youngjun.park@lge.com> wrote:
> > > >
> > > > This is the v10 series of the swap tier patchset.
> > > >
> > > > v10 folds in the Sashiko review fixes for the selftests added in v9 and
> > > > rebases onto the current mm-new. There are no functional changes to the
> > > > core swap or memcg code since v9; see the changelog for details.
> > > >
> > > > For context, the bulk of the series is unchanged since v8, with great thanks
> > > > to Shakeel Butt and Yosry for the reviews and discussions [1] that shaped it.
> > > > The main change in v8 was the interface change to use memory.swap.tiers.max
> > > > with '0' (disable) and 'max' (enable) values. This mechanism was suggested
> > > > by Shakeel and Yosry.
> > > >
> > > > This change allows for future extensions to control swap between tiers and
> > > > aligns better with existing memcg interfaces. It is confined to patch #3's
> > > > user-facing interface; internally, patch #3 still uses the existing mask
> > > > processing method, which is implementation-efficient.
> > > >
> > > > We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for their
> > > > valuable feedback.
> > > >
> > > > Here is a brief summary of our tentative conclusions. Please correct me
> > > > if anything is misrepresented (details in references):
> > > >
> > > > * Zswap tiering [2]:
> > > >   Zswap can itself be a tier (typically the fastest one). But, until vswap lands,
> > > >   zswap cannot be the only allowed tier,
> > > >   since it still needs a physical device for allocation;
> > > >   that restriction can be lifted once vswap is supported.
> > >
> > > Does this series support zswap being a tier? I cannot find any mention
> > > of zswap in the patches.
> >
> > Hello Yosry!
> >
> > This series does not cover zswap as a tier yet.
> >
> > My plan is to land the swap tier infrastructure together with the
> > first use case (cgroup-based swap control) first, and then follow
> > up with zswap tier support in a subsequent series, continuing the
> > discussions we've had above.
> > (I mentioned on cover letter, right above the overview section)
> >
> > Does that approach sound reasonable to you?
> 
> How does swap tiering work with zswap in the current series? I assume
> zswap is just enabled for all devices in all tiers?

Yes, that's correct.

> I wonder if introducing zswap as a tier after the fact changes user-visible
> behavior. I guess if zswap will be introduced with a default "max"
> value it will more-or-less be the same behavior,

Right, that's the plan.

> but I would check all
> user-visible behaviors related to zswap (e.g. interaction with other
> zswap interfaces) to make sure nothing breaks or changes in a
> meaningful way when zswap is introduced as a tier later.

Fair point. Let me review this more and get back to you!

Thanks,
Youngjun

