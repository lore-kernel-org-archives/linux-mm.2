Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D413CC5B572
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 04:38:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63FB6B0092; Wed, 19 Aug 2026 00:38:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14876B0093; Wed, 19 Aug 2026 00:38:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A6A6B0095; Wed, 19 Aug 2026 00:38:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A26126B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 00:38:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2E7DCC0495
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:38:17 +0000 (UTC)
X-FDA: 85116762234.18.2FF6A84
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5493240002
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:38:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TjCmvA9m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787114295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G2B/nm1Ufm+tffhg4JH1u0tnb8mm/qie/SDcpg/EfZw=;
	b=0ctycuG68RtUpYSmIr8LdfqOIVV9CzSG7JWOcUf2t0oH3XdhUgF3OhFNAQOkjd9reQ2aJF
	XO3kTARhVCXshKzRRLuqU/61MdY1nBrkK6K4D/kjNK+QCLN0UuJBjM/McBSA2RxxnJpMdd
	9n9kQz4cQAjqP5fKBs9RTLvF+f8B7ls=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TjCmvA9m;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787114295;
	b=BLv/Oqle9zghC518I4qU+fpppFs17e2xIlnZAKa/kzNy19kgeqQNtC2KYw0wNogWmcZyAp
	4swAIS2dK0X1thSbYLGts2/uUui7o54ykYCXEIv8X2fwO2BV2CXC2J+t2q8Qa0N2lUGuTd
	iP0/OAV3skbNufmMEYhIsixBiWm/Zt0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C8CFB601FB
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:38:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DFFA1F00A3A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787114294;
	bh=G2B/nm1Ufm+tffhg4JH1u0tnb8mm/qie/SDcpg/EfZw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=TjCmvA9m6EVuyfn7EAHmggHeTDyxjiIX9WRk0q4qvlHXeepbsZaA01+g+lI/2jf99
	 n+F+i5K7pz8V1r5ccb+LjN9FAlq2DbeikB7PdM+Rcei81kYjwLZ5zY+x7Nhw7YYA+S
	 LzSwAOE2h4Mu8u5mipgCGFSc9RvK/cycXG3O8ULErYtJ456Gr1imdxPPm3fW7+mocv
	 FFsJ4X5tXsvIvfJVP6C1Ip9KnXI+pO06GCB4YURVbPFshrKNDTsoqyBqbay2o1y193
	 k5QlTMrSLlF4ieK6OL4OKEcRk5elGuaN5LR4oUPe+mgdouuwGDAPznRM30UURm222m
	 d8ser7A83icBQ==
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-529a1ee0e62so3604431cf.2
        for <linux-mm@kvack.org>; Tue, 18 Aug 2026 21:38:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpokNjbzqKonnasG/7reE56XiyHYYVDpi6ndp2Cx2axp59ZaYfxpSr1WgJ+w+FMnyyya+E8HjKXlg==@kvack.org
X-Gm-Message-State: AOJu0Yy4F7qowzpdTF3wa3NuxIJTtyyloh6ZK8B3bwARHzxFnT5iq3l5
	4ifOE/VjPKDiuYg2dpg91GoN6utjv2RJnRlbJbjjAkjM758daGbuX3BdW94GcHcClpmfdui5wNq
	zHdmd4768053l+8n7lwW8uKaSOldUq/Q=
X-Received: by 2002:a05:622a:15cf:b0:51c:a7e:4cc2 with SMTP id
 d75a77b69052e-52dd5a22f93mr16196401cf.20.1787114293769; Tue, 18 Aug 2026
 21:38:13 -0700 (PDT)
MIME-Version: 1.0
References: <20260818225904.55236-1-baohua@kernel.org> <20260819030249.96570-1-lance.yang@linux.dev>
In-Reply-To: <20260819030249.96570-1-lance.yang@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Wed, 19 Aug 2026 12:38:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xXTyL-dQ22rASb03nDAcw5WskXywh_-vQdWrKqRsGmGw@mail.gmail.com>
X-Gm-Features: AcwNN1XcjFzglkBHojrL9H17jxlIalod76TfvGNhP4smzRkk1YVvMJ8eKMpvgj0
Message-ID: <CAGsJ_4xXTyL-dQ22rASb03nDAcw5WskXywh_-vQdWrKqRsGmGw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 0/4] mm: enable lru cache for smaller large folios
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	liam@infradead.org, linux-kernel@vger.kernel.org, ljs@kernel.org, 
	mhocko@suse.com, npache@redhat.com, rppt@kernel.org, ryan.roberts@arm.com, 
	surenb@google.com, vbabka@kernel.org, ziy@nvidia.com, hughd@google.com, 
	ackerleytng@google.com, usama.arif@linux.dev, joannelkoong@gmail.com, 
	hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8jxpo5arw8qs8tsjxue7f3ctqze3za6i
X-Rspamd-Queue-Id: 5493240002
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787114295-938752
X-HE-Meta: U2FsdGVkX18NZ6D/iJBanTvXRdKIpzz95D7s8sNBhkel7HpyFPP+QiyWziA1PF9Zi3Y7mTUL+rg60BXI8Hp6ansatCByRRiJFu1ezJwo/r4UrDXH0fsAGYqZ6zA0TJZu66rfjahk3ipAZcaPqO9rHFKBRmVv3xU7oiamU60TElpUrKoq1NiqU7AvlK7v7xzgatdZsmPLqwFtj3JKnTKMRWlwmMHt+Q7RBr9xzKfoUAcc8ZTQ6fsikWIlq01H+Yr4W6DkaLTam3SOaFYCla2ZI2zg0C7m92TGDJmK2JQK6+OjE4PS+Qn9HhTEC+2fLWcWHgPnHZhSuIJ0xETY/Z9rMApdP3uAm55uhkVGa+eWPrJ24TQmIVJM7WJnllLfMTakDEqnYqKAprRDS+DG5Df9880KNIe9WcEDNBe8VbzwRm/DkQOd9JzTUsHwOALxVxFWdG43TzNzT+WRhMs67Ey7s//yjsW1e3+ytCBtYyoRm+HgkZHbzDKo0HuSz8jdde3wtFQtuB8CaRbMDbFRaOfM+tTZ9tIJFPVw4MrAMxaZuP+DVjy4AWoEe7fi8PRmeVy3xqQhqUAQVrfA5eWQP5Pc7qffeBKXH23dlz3BgDdjzRg+xxR9T1rgI4OwDDNrSGfEUsDocgIZG40jy5AqRgnYTJOK5POUHhOIdj2u0411JtZbabVHiYonj1Ej1nbDhpWgrNXZbTkn92PWUG+ncpjLQgR96etnAMIT0EDI1fB4woWsbzhQCm1w80EGvDw7Am75oyJdaEvpCX8XtC7ZVOHQEF4mv/SHppMV4V1VYkazYyWwIXY5QFhmeUnnvv5E485B+82uU61z54sH9R7bLHUhdEUWW49Hsk0irMP284twU5Rrjy35w7kxTuX33dOImDX/1VfSTm7oyh03qVhE9LwvVV6+Wcia5Jkvg7j3KHLZnqoxWUMMHfe0Jk6rjJd7NMpwj6FfPRF/yGlor/97trx
 GqDwWCiX
 EfCdlcGTNZFYB5SSkozih/V0KGvBhF69XcpzRUWan37iMLA1vTWYEBMs2YrjBkExKEKPVHYuf3sX1Ubs14sKaGz38KoURDhxVluPVgtcIAm2K6J/t2QpTxAYv/8OpfwYir8W8NUlVeBq2Bqppj0aHmvzNcPkwoT/PAjYMZuxlN/lcJvZBwQpU2cTT4hZH+abfDkyofxqF3P436mDV0atDsBagyuPslqGz49nprsjBjKMRIT2+6SyxkQQi574nkmjJ453yYweKtAwqQMTegvRjsJA5Nx9QglIb+u0A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 11:03=E2=80=AFAM Lance Yang <lance.yang@linux.dev> =
wrote:
>
>
> On Wed, Aug 19, 2026 at 06:59:00AM +0800, Barry Song (Xiaomi) wrote:
> [...]
> >
> >-RFC v3:
> >  * Rather than hard-coding `< COSTLY_ORDER` to enable the lru_cache,
> >    allow the lru_cache for larger orders as long as the folio contains
> >    fewer than `FOLIO_BATCH_LRU` pages. Also limit the total number of
>
> Tiny typo ... should FOLIO_BATCH_LRU be FOLIO_BATCH_SIZE here?

Lance, thanks for the review. You=E2=80=99re right=E2=80=94it should be
FOLIO_BATCH_SIZE.

Best Regards
Barry

