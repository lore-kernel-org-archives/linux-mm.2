Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 056E7CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 16:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9778E0017; Thu,  4 Sep 2025 12:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C1156B0027; Thu,  4 Sep 2025 12:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D7208E0017; Thu,  4 Sep 2025 12:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3D55A6B0026
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:06:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1B62B7E4D
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:06:19 +0000 (UTC)
X-FDA: 83852044878.16.D149A5C
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf05.hostedemail.com (Postfix) with ESMTP id E5A1810000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 16:06:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=flp9Z9VF;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757001978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJB1/hNYsH8Q20BteySCtJnDw0ynZ68mEzNhyiDKstk=;
	b=OuGHosUHkkvdW70xhcda4G3WhDB3y3LOJHYcAwbGquxfzKvpdZDxN5IohRAKezGz541D3f
	ltWxO0+x5jNbB4/C2USp1y9iiNqAECSFdXinZM6bweOliBD88gkSEcPKwJpjyH98gJpMo8
	WJy8adpjmuwJmxJFfu/z6/+/6spo43M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757001978; a=rsa-sha256;
	cv=none;
	b=WE40MaYVrYUXXphnmIOZKcyzjC+SO2nepAOcZ1Kj0E03ZRIgw7i6Wd1T1uq0uv3h1aSgMb
	ljEZorZZW3iaU31oQXUzKVYFnm/nqb+iTwLE3hO4wFbl3u3vXIivGESB2yDcSyOch3xWd2
	xX0s2fxKjBmoyHuqUFEFEYR2//AS8Ls=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=flp9Z9VF;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-61a8c134533so2098550a12.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 09:06:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757001976; x=1757606776; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TJB1/hNYsH8Q20BteySCtJnDw0ynZ68mEzNhyiDKstk=;
        b=flp9Z9VFCdqo1tx0JzHYzJH1e/74+9Xfv5nbUYmbJmP0sFtiqBT3XWZLSoFkSKPGb3
         I3x82nMOuIuVZnuuFqbXoVfeKOCe7iKX0CR8BACkEHLdHfk1mVZwACmBDXAPYzshI+Nl
         d+IlbfTX6lDdA/GtIaj5DjLaPYoSgk+ofsEA18tiRtUuhnsuslZRJs0QzU6NZ47fVD7C
         MyoGdC29GPoalHTDkrRnrw/nZhwOFQipYkS0ND1uFsris2bBLNs73jNu6QPEpT2BcRap
         NUEbsheFt9GZurn+TrMIWTshQY+820gp5xQfVKEp4EUd6ypyjF+kfbUCkpYQUbeCLzbf
         AjIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757001976; x=1757606776;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TJB1/hNYsH8Q20BteySCtJnDw0ynZ68mEzNhyiDKstk=;
        b=A/YQrGDBiyO6L2hwXcedMia0yLnAD1Sh9CJuPUNpnZffPWnQZlnJuSTYLU+H/1vhgg
         BF8Levod3pQhigH5/Z2PixJUC7f7kZ3t7PoxEMeWicLvYEKE1Mw2Z+H/kxnkjOy2xAje
         P4bSqtBh32wKyQJJmJ/QU4GFYG3QNug+HDqnRDn6GvVuvqUzHosQTqx4P0IEMhLm1Dce
         beygzrrFOdXHgSWtoA5uBFb86RSQC2T4QF2h9AgGsaUCTT+AYPFlL4SoJNYUvT/IKXtN
         iH9IehH1UrpVUfmjhCj5TrLR7tO5/s89v4pKVYzGc5oTO7J18808ivYNaI5lxxFOkRoC
         Udsw==
X-Gm-Message-State: AOJu0YwRevx1/gICPTQkfudvReunUNQups4aR7/RBjbIouIrP9N1Lk6H
	prcRt/QAtHZdAij/J6xY5BDPxaAU0o/9ZDgfFUvP7xaXXdjjf/H5z7IB8ifbI7XOBRtS/nTv4QO
	U9CvOasBD6/V6eKWAhAPCnBw88brSXJQ=
X-Gm-Gg: ASbGnct0GmQXDUW3aqSHnIkdW/klk3o6bFvczkTd5FkNq2hyU6/EGyCmAOvLRV35dSU
	7TiV7186RtsXqhceawW9NjjGcTkINFAcR2e2Sy6hyJcKqclcVybNAAuMMQKSMOpf0aOEaDsqau/
	dAhckcVxgisEGfPuoPxh3634ypCeIHe6g4/Gro39p+1oM1i8/jC7q/jWV+PkhfcRLWiYmULv4+C
	pCnB2co5sI=
X-Google-Smtp-Source: AGHT+IHOugCOPsyWMYI/9frBi1EDh/M6MUda/nljZdBGVaeD4eAkldmiAKLHeV9fd51Mn6Vw2gFbWeyKSwJn5vu8fHA=
X-Received: by 2002:a05:6402:2686:b0:61f:afe3:9177 with SMTP id
 4fb4d7f45d1cf-61fafe393f9mr2096912a12.2.1757001976066; Thu, 04 Sep 2025
 09:06:16 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
 <CAKEwX=O-_khBw0h3F+Uqx-8joMPHb-aOBuODx6LVO3vEZ38tpw@mail.gmail.com>
In-Reply-To: <CAKEwX=O-_khBw0h3F+Uqx-8joMPHb-aOBuODx6LVO3vEZ38tpw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 5 Sep 2025 00:05:39 +0800
X-Gm-Features: Ac12FXxv3acge-iILq_OS5ASCS0n5qK1Bxoju9QuUQYOMxssZswBOiwQNaPmA3s
Message-ID: <CAMgjq7Dy1ma_jq-AutAGjOXfinFPOLVJatz7dnHi_Nc563q2cA@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Nhat Pham <nphamcs@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5A1810000A
X-Stat-Signature: uuoixbrnyenwyqazu1dq5mqxn4bbi4kq
X-HE-Tag: 1757001977-359918
X-HE-Meta: U2FsdGVkX1+X7x8oq3bfjfpT5PSp5XVFy5mSZ7pFDB/9O2ulHYANsFFq+kaAwuk+WwGSQg01hzHMF+RWXIudkWOxOd4omI6OAcig2uP/MdqfA+cCdRO5o6T0jSsF6csQfjR8YQ3/uFxSEsJC64S1FGCvChOx+tIuUFfewivM2EkaWva2tbj4aeRIy0tbLFHAxRQEPqa/UU8LHEMwStvqT83lYPpZqnqoy8MqzNWUxz/7V0DcWSaBJ/KPPU1sArFDeBDm9fkGd4RKBpH8OuOr3cqJz6SKsag8pgCW+CHXSuRn1nsGuuEjf0Uj0twcZd5oPaOwCmoChbeNoYb0JYcXoI4aquW4Zm3avYRGR3rlECoPDag4hOKOmIrLX3qZCyhrsuN9cwiuXjZSfhEYMa9FdCwGiDfy9r7IhKAAC6nOFG2fndgOCb90rWQLyjKPwxsZtP5+p5XZWUKm/KF8ebrls5JCFZ5L8R/17ow3o81Ox0blLuGgtvA74smrLiKMOlYNh02UsxQI9T0iIhgivqqljgPbblpxWkKAJMWF0uieumbxnaUF8MjKvVsIsMTBgy7NJANMjdktSC14w4sZsgEMJ++GSAUk7RLW65OJhlTU0IsiBmqlbCqQMjpIJbwl1P8+ggkiMAQhvQqhJJ90n3zV6M/Hindpw8M0ZG4SM4PYaMqYQ5Ugb277Aaa4/tfoc+MbDBLj1ihpYMS45WqKRk4+18GnJCMADJY1Gr9W61F5tFcwKyMN30uTQkdjW74pCjOv920imbqVgxt/dBkxBPwjPeeYMnUky/lHSUFu9Ok/Q9N6nz4CdU+F2xEp2ipWi8tvXMAKNBBRCJh3pj/xj0veY8cQV0v2Rd9tFPZd4lNynAhEoOk+VluDDjzsq1Zb8mMg5Ry884kum9U+alnPZSox31bh2rp7apJ1jiV18JtZ8wsCD+yaBx2oXs0OfchjpTSZRAXCg68Xg317hJFEvWy
 i1J/1PIN
 oMn7WOvg/WzkOhgW1r4YYnF2QfUM106DAuAglxEO5Npgb3ThoEhAHAMaiQi7VLV7FRShSTypiZ4g0O1Gr868NnhBtVUaZda3ZT6FbxtKwvzCUIXYWklcGsiiHvW7r55YrHxCYhtRQ/hn13VMbJm3zyOZAipgZDkuAy3d1aghRzA8v1aL6XUaLsRKgSWN+OPm0s+H+2WQtFh0s7Gq9bD80lrSz0RXZO9WNML5AqW3av0b0qXCE7fZRKYnIJy78ZgjA7XF/VgHfTeyh18Hm2x7hBoq+9Jv0yn4osEK7yOoc17+JyphMyZjg8RubUP3Ku/hlfbgMg7RZ5aUOTHw5VxtPiLXFuGiNewcGqGOYAW4zD94+TwURL8/LT3gG+Jb6b61+zU0aBenjXF6OkrBZP/GEz7cLig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 2:10=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrote:
>
> On Fri, Aug 22, 2025 at 12:20=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Always use swap_cache_get_folio for swap cache folio look up. The reaso=
n
> > we are not using it in all places is that it also updates the readahead
> > info, and some callsites want to avoid that.
> >
> > So decouple readahead update with swap cache lookup into a standalone
> > helper, let the caller call the readahead update helper if that's
> > needed. And convert all swap cache lookups to use swap_cache_get_folio.
> >
> > After this commit, there are only three special cases for accessing swa=
p
> > cache space now: huge memory splitting, migration and shmem replacing,
> > because they need to lock the Xarray. Following commits will wrap their
> > accesses to the swap cache too with special helpers.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
>
> My personal taste is we should have one patch to do the decoupling of
> readahead update and the swapcache lookup, then another patch to use
> the swapcache lookup helper in places that previously cannot be used
> (due to the coupling of swapcache and readahead).
>
> But, this looks good to me :) Feel free to add:
>
> Acked-by: Nhat Pham <nphamcs@gmail.com>
>

Thanks, I think I'll just drop the readahead update for now, it is
harmless to keep it out of the lock and it's really small change, I
didn't measure anything different either way.

We may test and figure out how to read ahead better later, not really
related to this series.

