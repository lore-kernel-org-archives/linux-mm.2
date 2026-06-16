Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAE28CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:06:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB3856B00DB; Tue, 16 Jun 2026 17:06:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B246B00DD; Tue, 16 Jun 2026 17:06:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA4C36B00DF; Tue, 16 Jun 2026 17:06:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9FFCD6B00DB
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:06:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 360571C0E73
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:06:32 +0000 (UTC)
X-FDA: 84887009424.23.461880E
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 05F871C000B
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:06:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hSEwNQOU;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781643990;
	b=pUabWKkLvP6HweH1dKV/SaEpjkJyr0fkJnjN6qD+vuE+3RGSn6hz6hDylwhoGMO1NeIlcB
	6RncI9I6pN/MFN6968HgHcpWtkKDFowz+tSReXf7smhwF1hPoRPIrL1cL7AxqFjcYVip6J
	XiYx2ltiVkDQ3Vj0l50k1K22XFMO9uA=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hSEwNQOU;
	spf=pass (imf18.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781643990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rnlo4U+8XVQcpe9elBQDCdpqJEQyFEfgWsDtAuY9ZpE=;
	b=23QGUb2o6fKt/84DpwRnhU0i7i8pHYCsa+rlNLUmhezeqfZXS94FiJzdR8DLaZD1F6fEDU
	ZG3m9APJvm6ZSEt7fM2T8Ed2H12067U/hyUjBQWjbRbTId0tEzwEwwbVEi1r/yIvh+UhCr
	uztE/aMbyY/SVfJwgpUt0M0sYUy239Q=
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5aa6792e7b8so4586793e87.1
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 14:06:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781643988; cv=none;
        d=google.com; s=arc-20240605;
        b=gQtOH9bW0tpQTbfFhWwtkIt2ELaAR+IWaW30YTXC8uJeSvkgG3OklUMQoXO9f1vm79
         O6itNkN7V+BZw99UiP90dDalQtu3gavaI+oDzGLnAyzD7s2SulU7PXjt/qltDA0ce47H
         bzdcthdlT6WK7qb4z9eE1H45Hv842jGhwsVloeP2VQsbQ+FBOetW9BONOd+Yf19/P6QA
         iZMCiWMUIbmAelyw9i+3aIY0GGfYU3P8A1gseSfPzwnKXUjOLofj5HJpXbr5zT4EtHER
         +U+vlCwpAK7dbk55dMwfmMGZZWxitx3P3q3c+y+0OzJZAYvAmHWEYliJCyWs4pw3m1uP
         i//g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rnlo4U+8XVQcpe9elBQDCdpqJEQyFEfgWsDtAuY9ZpE=;
        fh=OZl2L+3g1wHG03I89zcV3jFymzJ/bIaS3W9KxytZyUg=;
        b=VNMEheWLigLL974cKPV59tDuQ6vec5Api82P8/Nx6ZN9nh6RCrNOurhku6m/4mFrSC
         Nl37EUO8xBcB9XVAUCKe4F9KExM4FM0/BogyjT33J6X+Z1oNdgMWz1PNFDp+UJ/UGEgF
         8FZmCKgSLtMiJQGBthj2b82CV6iks7EDPDs9kpItTMxHo7J01wOcF4uAegLMotpD5Dp/
         kLNoDTlreSKdEWHkPEfNYrsDbAqFOny8qCY+VUSuCGsVOt1cTxDsNVuv9tcy5DIufAB3
         38682EXU9IUQ+9d5GsHX2lN1+kLp7wQBM03nJvNzxTh7+Az628lu4nlQrmCJtMFM2Day
         +Ddg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781643988; x=1782248788; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rnlo4U+8XVQcpe9elBQDCdpqJEQyFEfgWsDtAuY9ZpE=;
        b=hSEwNQOUiVPUQ+t6yOLwIif9pbEmTKyNIi7vvHNYh5r16Kg/cGUIM+CkG7qkfTLYbR
         VnPcKRZkmXy33wuS2VHOFOgDB344NudqyUXAV0HwY5QxJBl2vYLkXCNFV2IB3lTRWsTe
         1Zx2dNsx8QMKMXkoAiye0BclKpxXiGqLVxOWqUkX2y1mSWsuhej6jA1JYqZy4gQDs3+X
         tTQQswe29ft9ykf+eL7NtPHE4Iv9s/NOAwjCfYItiruqTYVPHwKEizRn2rqf4T+mowqB
         iQnx9Z+OaHo0UnWMKQDO7Dv1Pm6X7bFzimEpr8Y8c2Qrbev7ufAVeTCoI0037gJtL+Ma
         qWtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781643988; x=1782248788;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Rnlo4U+8XVQcpe9elBQDCdpqJEQyFEfgWsDtAuY9ZpE=;
        b=HO2xLDLfeDegA0TpRTmAwGu7r8mr9ktVAriUDeUe3l7pRFV4Vh1IeBk8kmNB6keRSO
         5DxgmCpNUFzUS4plQJgYn0FJYexwjwbCgzik2lMWHqBRWQE1dpCWLjKsyg5NNFNFHtXS
         6z1X39JKV4KqrfkawJ057LZhmKHzbDHI7H6sibP9a59s/MewZzGXy+inOl0rnz+5ylFu
         ZisXTXPxNfjQeF5BWWBD0canPAUi1Mkq1H0+X856IAZYNSM0DHgbP+8DfrmABUYlcfYP
         T8Nw13+7R93Kj9VQj3gOIzw5p3sy9zERuWSBSLvgk5GVmuom2TG5t7gBKhzQ9tCbIoh2
         kaMw==
X-Forwarded-Encrypted: i=1; AFNElJ+bWzl+KOCLwZm8xY0OIh3YY/DS/z1ZPGloR/YsgJ5buyqU6dZnR4HOmbE+eyjRf1WH9fuZ2qfz5Q==@kvack.org
X-Gm-Message-State: AOJu0Yz/EQY5DKLchR+fytfIVilmc0cjdnGx8GJYbd/XTq50aeh3GtBD
	5tKuB/sp2OaRHTwfgYib6OJ6Z+suYGIR/EpFRRNVWIGJG8hfT+ZW8vEOrzNDLHGIp3yIAnaUCiw
	M6s6pL/a2j29MeKU01qeKevSWfTB+q+X0mw==
X-Gm-Gg: Acq92OGKdHMm/1LjchRdkGZS1IpUfTXTe2dfpVCmurKVz5gtB1shp64qkMY+/gBtI41
	tm8zGU7wti9gFXlqG3PoUYtZrs2oZR0yG3WGZ6mYCFlh6XEOC1ltbTDih7BhalSlCCwdKkhOBVe
	rzFVETgXf3TSXfpy8/s4YKONNyUIRdEnuAK214oPcw9Vo4TYbjvEbTx7/E0+F425549iFQ1mu8z
	AxgmEUoZIWdqCOTB5mL8zaUU7i4isEQ23SWcAwhznuXSFaDBgVkJk/YpBgmduweyW2nDPNsH7XA
	xH9kKw8JZJA/mypeRW8I18HSwPmUU4lRV0BrNA7v51R8kxMlxX7D08E=
X-Received: by 2002:a05:600d:8443:20b0:490:b0e0:3de2 with SMTP id
 5b1f17b1804b1-492333f7715mr12498135e9.33.1781640537700; Tue, 16 Jun 2026
 13:08:57 -0700 (PDT)
MIME-Version: 1.0
References: <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev> <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330> <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
 <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
 <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com> <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com>
In-Reply-To: <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 16 Jun 2026 16:08:45 -0400
X-Gm-Features: AVVi8CcJkF64DjJPscg6dRd5pZugnnFWUYYuUhZo9kqIJ3vQ0Lo_eZdOtaRqDxM
Message-ID: <CAKEwX=N=Umi94wdKcLxEWOqUwhz6=Lj909pc1Pr_5ivVnZmdPQ@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: Yosry Ahmed <yosry@kernel.org>
Cc: YoungJun Park <youngjun.park@lge.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, 
	kasong@tencent.com, baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05F871C000B
X-Rspam-User: 
X-Stat-Signature: jedzww6h67qesuacjjniskse3pbrtti1
X-HE-Tag: 1781643989-985269
X-HE-Meta: U2FsdGVkX18RYaXZ1hFGhCpPfw9pd+DHwAw/t1xdr7ENFyjEdkwDpW64ZvQUjiurr/s233JR/2l2dy6dNJvaCqayRo+Yz9cnHeTu5zcq3W2d97/PsyjC8QIiiUtz9D/hj5QCAjGgUM9z3UoAjwJjDd9mA3OF7GTo/kbZ3ee040rDVoJFE0lupLtDObhylRMUmXeEBCeRNbJpqrbEbBA8feE0t4ctY7jBjfZJT/AN23MYeiXNqlaad9mHCahO5VUOrzONvY3kW8PO0PE0x38E0rhKWk5qWTxMyfJ2vtkLZF6NVa0L7VtV++fG7hvaWf0vQglQ7twZcyzPyXFYA+ZccicZtsxawA0J7roxdNxRI42LTa7xMD3n3KyeZu54ITqmMH+GQUsDHQkv57ywlmW3AyUiaQ3Vj0EIL6hOnBehGiG3EOE5Tyhx60jfjXeKI/c3/GmQSbNyggpeN6vFrhv1PojrCod9sKcF0hQI2dq4DXjoAMDHgvQ8cGLY6fzTEL24sDZ7MtXO3X17T2fRkV6R/ZhZYWJl864A54QmorbQ97F7kXl2B6VKhBZ7IbJGqsqZHqcpUjEom19JsSJ26NDc8WfRSRQOFbdFrPjRRRVDFp12eEYxToOUDyPzhlLQ1GK2hapVxMB/fPWlgC4lXVpwVCC1oeE7iLXW6wPXMPwur5EEUCxmihCaWeOMkKNcZOZrHyP6COnE2LssBSdvs2bMaC72WmsU5YXDOHfgpmNQGvBvUhBHvlUrbAxHViYwNNu6JZVewnb0QpA/LSeiX0bTCUKUetVhIWd2Kd63XK44GwjyyC/iZL85MFKdq7WKGSGMZ38ka4A1mUU/PJKi7Zwn3QbKNRDy6C7VxBMqxgt79TGsx/gNcRyMNL5rM4uPmFqs8afneyknwFQU5vxOwrn33141s/rWda/Cmmj9ZJPJdoCpDW29Akggth4nqQwvqOXjABNaN1/zsYo3+hQzw56
 Hc2UaCWS
 U0n6a1jLMRM151s/7kpBoYubTqJuMrFTbc9YghtXt7TFbF03vx6UrTHdq/MzpjkOEXsLGaW0kmySO365zNDt9HOWRCrKnHQvBqGxkVn3mD65kKPV0bwRtVXZYFciWtfPwB+PHZIb/UDZ1nQyECvkeHha1bzSSg1zgCE6GwlqBbPzbk5BiLcKbcNeMxINFadRvo2V1HMAXRn4DXEemEoeXEqAWVWS8Z5TZl+YWrT5llAygs0C67ngOzIZWe8MwTxZQp1mOtZYFOYo3sF2WNB4mnJy+OYzdcaULBd/uRv8VmsaMs6AghDQwGHx0UHynSkLpIvk+7loPaPZ1Ol7j06EnDsIGuplHFIEnOMzHhM0RmJORFuqvNpY1LR7Nq9EOC4Pox3QNQujU8du04bOHYXRwITqAiAjoHEhvCqLBOXhfmxWloWpX7pyQiYqKSGdLCRhwK3NctiUu2Xnk2RQOJixdYat1DHaMzjmGdIHlZodwtO2eoweGizbIJjwMZVwLlFt1DvfqpShh7mroIGNjPjVIhr9j0w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 3:54=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Tue, Jun 16, 2026 at 11:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wr=
ote:
> >
> > TBH, without vswap, we should not allow setting zswap as its own tier.
> > It's meaningless. Maybe makes it a no-op, and warn users what they're
> > setting is gibberish?
>
> Why? vswap is transparent to the user. Why can't zswap be its own tier?

Without vswap, if you set zswap as its own tier, which phys swap
device should we allocate from for the backing slot? :)

With vswap then it makes sense (and would probably be the "default"
for zswap setup until we enable zswap writeback).

