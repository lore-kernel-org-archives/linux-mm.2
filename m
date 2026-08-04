Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3E2DC55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 23:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA5FC6B007B; Tue,  4 Aug 2026 19:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F706B0088; Tue,  4 Aug 2026 19:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF7886B008A; Tue,  4 Aug 2026 19:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8267D6B007B
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:02:02 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8925BA19F0
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:02:00 +0000 (UTC)
X-FDA: 85065111600.24.76D05B4
Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id A44EC20011
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:01:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="VO/4FND3";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785884518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iz6wwUefZFkmNA7PKZhIfUvF38jPXDSd/DYv372kOcA=;
	b=MtDJcCcVqnfol58RpZ1jnW6Tr0u8Zp38x7tRlsti6hefU6OMRMdXXXSAepKxXDeLO492ae
	OtONBP0Qgst0HK3vKehfD42u5SdBzBtCSITaU9yEF5rMPfXs1cpbvajjVggrEUbK2v6MVD
	cKpXvUbLPcETEwOrk28HZt9bJ/UjJ/Y=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="VO/4FND3";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.49 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785884518;
	b=YGdQv+Z/17gSXLA7Jwj3KJAOIfwgKFM3cHjFa8+W/z3BmwPRjDyJjbhtt4NZKfFakOKcRN
	cdpdxnlmXCZAn3rrij/k055iBN1AbM8TRHdFkxc/6xi+lr4h7ih10kikcpKrbX2QOuyB4/
	v8nsebn/kyzo2zc1JKQSUxzStaZ563g=
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-7475a4f8b05so177284137.1
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 16:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1785884518; x=1786489318; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iz6wwUefZFkmNA7PKZhIfUvF38jPXDSd/DYv372kOcA=;
        b=VO/4FND3Qn/RcdozaJAdx/zVI0Hv9IqssgLHdDuxS90X/72coedPVApx0L4rGJc1H+
         7vWJWcqRPEKGANex4yF1Fs78ctoH6DoDmLr5ciECdENigm/377kmIiZbp9tuvxd/MMAH
         A6yb7jHiFs2lAhn803VNxrt3nB+2bV9if8mQitSrjKK95oxJ9QYup0ywPRJi5xrjC/3e
         gK3ns5xBcUd5yGVhv6rC8MQ6ySVS9m5W0jQ/D6Zl6lZkGh3pYJNq9hhtBi6emMX0GevQ
         /Z9PWfdrdx0jNdHIqyrSX0kDhOEs+LjP32X7hskif4f9+mlT8baUEZK4Kcg/QGBoKTwD
         WKIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785884518; x=1786489318;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iz6wwUefZFkmNA7PKZhIfUvF38jPXDSd/DYv372kOcA=;
        b=UbRTIjO0bT+jo5TWhDqBUtD1rA/VO4JNNBxXY44QrIqh2/EcaO3lqFoCMBuFLZkoGJ
         boeYP6P2nwWxXVNPj/itbrxHwWO9Rb3Ttu3X24AgANDianKV+GHu67iqLdkhhswLLt3d
         YJNL7hPEx/RukSee0plM+Oyv3afxVqt9CYD+dRBMI2TNRoX+jIyFcjd1xETTvpbs8/BW
         ih+DZIUx3/McBQom6VAqGjRSvvGJd+vOWALhXteBvRe91AXcg2Fj7AbDWNM/tgjVV1+N
         AGWCiAm9wTVe34XnLWtDmylQxks20IeNCznEsQisob4oDRJy62DNGsJ1kBFD70z1QTZr
         LoMQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqz8/D0O23DcZ1/vZR6yvUsXPwU0EyiEhdCRsk6CoOUR6FFoPhBX4iQDQCQ/oKhQUECwbSwwww6Gg==@kvack.org
X-Gm-Message-State: AOJu0YyV4nxnurT/NW9A0bts9+W07Ay/GCu6bx1tW2+8lxMd3riyeI7t
	IChGaJL7FJujkapD3xyy/g5GhlBIhUhYQeL+t3EkJ0JudV2hg07FF8lA687y6QALLEc=
X-Gm-Gg: AR+sD11tSzMZar+iH8L5TC40XRFWEsOP0t9adsHXZG+2JGmLwk3YAWTVIRsYl7DFQo/
	ibKWRHpnaw55haIp0i3JpIVF7TLgTn2BKdB9a6wtbSh25niGUPzleQCheKPizhd5N4DrVPBcgxD
	KlpEFrPKRS+J5gFirEtADOBbg1q1EumqWr/JhfjgBxiSqwOOEBii7YU9QConvFfg3orQbeHmnSl
	LjmrC97yEmHo5umKUVNW75GPy6+jZp3mEq7+n1HQjBKZf3jJfmRoCQDTgW0VgjokDAI55mNqMWs
	q1aR2FR+N41kwfWAMovEuu0ejRjwG/alMXM+dQVwI75C+imjtAWUDWx/D2PG5bdmegNwTWUNrn9
	AWVr/+dwAKt5pC+l20ESF0cYtVF2jm6xJi8GgoBO9ZuRI0kw/+3ka9tYr/6UnDPlnFUHFXedHH6
	wuz+UM5Xr/59YlPQ4VLUtOsC0n5cTDifSw3FkfXXjWAq9Piv4hvoIRxX8atPfHc93NNPGpNpawn
	h8m8stoOZZ40rco5NK07RgwMp1ygisfYWujl9Zj4uxa
X-Received: by 2002:a05:6102:5045:b0:74d:ce64:efa9 with SMTP id ada2fe7eead31-760e9951613mr747189137.12.1785884516765;
        Tue, 04 Aug 2026 16:01:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9087ff9d04csm13795626d6.3.2026.08.04.16.01.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 16:01:56 -0700 (PDT)
Date: Tue, 4 Aug 2026 19:01:54 -0400
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, 
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	Christian Brauner <christian@brauner.io>, Jiaqi Yan <jiaqiyan@google.com>
Subject: Re: [PATCH v8 10/15] mm: Check individual hugetlb pages for poison
Message-ID: <anJvBEHeq58WBQaj@gourry-fedora-PF4VCD3F>
References: <20260731200802.574821-1-willy@infradead.org>
 <20260731200802.574821-11-willy@infradead.org>
 <anI5bPVScck1WXvh@gourry-fedora-PF4VCD3F>
 <anJX2bjH57IHz-jX@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anJX2bjH57IHz-jX@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: yc4pd65x3r47owcy5ysxgj8cfx65schc
X-Rspamd-Queue-Id: A44EC20011
X-HE-Tag: 1785884518-24842
X-HE-Meta: U2FsdGVkX1/aWKZcAoOKgPylrgNZZrJYnktPraz2gw7u3ksG3MEc9hbYSxNvQHspK6gl03T0okytv/4g0TdaC2QLKW6m6eMDDuZIbGMp/Jn0EholyGvG0krDv0MIjExmphu4R2dxXxnawNRVLyMVDcSijYsTnUwPu69n+e6OCuYk536+DvDzmpYx4KQl0snXIbsWq80X8vb+0dCuw+VZ3z9Ae9dFf4EI0Sj+Sc9fA4Xp2dAxV0LcH7B1MfePdNmxPorg7C0akDP83/Ke9jL/LW/jwgY5TZSnNVVVG4JzT2ytmXawBZqDEXkuiPHLm4/ZSIUcpZJM1Z9v0I/9Dfw/ryMIzvLjJfGRUB+J8JTFnDOsHTsVWeUZoy4vbn9CapbO1zwgKn7V7OiXEzmVzwt+N93HC1EPEmJo0Bw/r0QLwSpL7MASLHW8no4otMX5S80ClIZD1jgvz6nOoZJZEM7iAJbq/dpeNM0WjGNkBhxJ/mGDIztD63SUkFgPDLUQyjw1kRkY0J4P3zvroyV0UGfVoP4nY0Ch6SkOLMM6go++5fHV2wkQtIg6yQOC7gYZwbsBJWQMEVc+eDzgllsu4KAWFfdybdN1RVdxYQj4O+F9B5ZrwVSIWa+Q2qWxwTVidm2eZR8B1m1qwKoa/NNoeVZ8qRvuZVtQPLBZ0cXz9GN4U876L5q9+Sm90udF0f31oNWyVzY8cD+MusEhWo6s1+/wbTbSrGhZW7c2uifZLi5UKRdz47CJ2ovdBrdOiteU66AA20mnF7xnuyIuNEzqp09Kpp/NNIgHEiucZTWw/2bw66r62KWG0lgERkhp/3qnnAoOekJJO7MInMrZ94TVR6Babcn5/SYhEfQ+zdHZna/VUs+//aaRFtFD087MHF3X8nI/QIjvObFVNECAvKKLhoCMJpwIEOLCWX4mN6fYR2bLdMvV7ApWwQF8Cp/f7C29+SSkb7/22nxrsO0G4DEp6fc
 JMphMVAW
 xEc1vxAoh7o9is5zxfwLeaYnla0pSj7kNQ+RshjLdrZDh6Y1lY3M2vbQhoAclyZHQZbbnbYCZzv83vWR6XYQHD9aO2lX5v5J14vSMhYvu66DGv95aj3sxUnCnLSYEJ04GwXVz/uK/70M/MN7/xDACeJXU2lRLLTAsyPwH+eV8c7Mge39G3p8XW+mRBNVL9auAkogCY9wSHYagNt2SPsWHHFuF9x6cWVgN7w3lMy8gMt3bKlzymjcjfnr5pihT1Yswzj+0N50vSxNe4u9ZMthfglIzyVz/nMKD52ENaazg8RZCp7ZQ6ZRv5PPVtgwkMJJsNjD0yjhuJcNWv/QRkmNW09J5pmyACZl+d86WE4PrqGujyAObBhJf9LTIY7yKXqYD3SQxi/ULDBVw/RdspK1wyUlb/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 10:21:29PM +0100, Matthew Wilcox wrote:
> On Tue, Aug 04, 2026 at 03:15:37PM -0400, Gregory Price wrote:
> 
> So the pointer we get back from page_folio() must have been a folio _at
> some point_.  It may not be a folio now.  It may be a folio, but not one
> that contains this page.  But it's not a wild pointer, and treating it
> as if it's a folio won't cause any harm (as long as we're really careful).
> 
> Specifically, we call:
> 
> > +	if (!folio_test_huge_poison(folio)) {
> 
> and all that does is access folio->page.page_type aka mapcount.  So if
> the pointer we have is not a current folio, it'll just return false and
> we'll check PageHWPoison.
> 
> So the only case this can return 'true' is if the folio was hugetlb
> at that exact point.  And we've got the hugetlb lock, so it can't stop
> being a hugetlb folio.  At this point it's safe to walk the list.
>

This is basically the reasoning i came to, ergo "not worth addressing"

> That's my reasoning, and I think Sashiko has explained enough of its
> reasoning to be fairly sure Sashiko is wrong about this.  But hey,
> you're not Sashiko.  Maybe you've found a gap in my logic.

I think sashiko is essentially just saying:

"But if someone does a dumb thing with this interface in the future dumb
 things will happen"

To which we say "Don't do the blatantly dumb thing :]"

~Gregory

