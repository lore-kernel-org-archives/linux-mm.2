Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E393CC61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 21:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7B4D6B0098; Wed, 26 Aug 2026 17:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B826B0099; Wed, 26 Aug 2026 17:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41826B009B; Wed, 26 Aug 2026 17:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B39D16B0098
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 17:44:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3E972140242
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:44:01 +0000 (UTC)
X-FDA: 85144748682.25.010F15E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 591D54000D
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:43:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=or2rPFmW;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787780639;
	b=mMMm2+IXuhAbXt7Xre7NGMwCmnjofymtz1g//UXSYFXgjDuHA047zcfOspyEk2XpM+YwOE
	Ch5YZqlSUcYlwMpXDBj6s+LZpz3Px3rioJVMGe8dLYK/kbcnd3Hvzfeu/X/2M/2wyuaubU
	hGUIRyaXQdxOw8yRYo7rW3UgnAy6A6E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787780639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2roDRA2Ocj9k8psJYEvUg6GITDjk4l3VJCYd3f7li1k=;
	b=sh8WxyKiyxavIcpVbw1ztOY7W08gD3bnRdeoHdQJHCw0xnknUNWfTytG5ewa7eDbPMxcqP
	Y5lT9E7KJ7H5uK91989jkLNkVpW/VhNRfhUm9Tlfjt/n07OCdCdelkypejPRwOEy8HVOv0
	onEeW1WPjSNlU+9YOM6RA5jVnMv3SP0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=or2rPFmW;
	spf=pass (imf27.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ED67860A5C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B4F1F00ACA
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787780637;
	bh=2roDRA2Ocj9k8psJYEvUg6GITDjk4l3VJCYd3f7li1k=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=or2rPFmWUworOzOd0pxbnRMZfNe9k4jfeGb1aD3IjVSuKPlG1lHPQJItjRDwVeaYV
	 VVhBTG8BYODz4KjJnOFsUMPxUnCWSTNbC1pgwiKJuYCGECGE6pna0jwrS5joo+BU6C
	 VyZULLEtJhIy+rGIiq0vwkVW1NwH5AxRl842FRFmnGYIujs6nGBXZVqR93wFqggpEk
	 3s1rB/+AwlxalZjrWeLwP7BDNs1UAq7eZo13FmMWJthdAZS0HhSDJrjAXVFwQKa+lg
	 eKtq4Np76Efi8A+zdhDE4tDWjAITguCqLT8ukGi12ryYBhrPPid2hRAL8O3imGgLDK
	 BEZnPim2KiXmQ==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-938fd7c5379so2575185a.3
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:43:57 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpYi/9+9CBXI6d7pLc4OKJkOqG1GWsf/VHozY7bJiQ4ajX/GRsQBEtT7Ocpor1H5bn7FHFao/HG0Q==@kvack.org
X-Gm-Message-State: AFuF++mUA77si6BCAudZt6u3FbXbcmwyd0EfQ2vnlldXMDG9tTEK+V2h
	tXX0UqGQHEEvjNf2aYnu38lGX0iMMeU2DjYg3jHdpOLb1M9bzGGJA5zOvlB4deiDuAD+ywbP2m0
	MVjLBGFN1bAFg4FeMjiHk+PQvnmW03to=
X-Received: by 2002:a05:620a:46a0:b0:939:3c0:7520 with SMTP id
 af79cd13be357-93903c077a9mr41198885a.18.1787780636906; Wed, 26 Aug 2026
 14:43:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260821102538.22642-1-baohua@kernel.org> <20260821102538.22642-4-baohua@kernel.org>
 <ao6qTTtk2xkkeKob@fedora>
In-Reply-To: <ao6qTTtk2xkkeKob@fedora>
From: Barry Song <baohua@kernel.org>
Date: Thu, 27 Aug 2026 05:43:45 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ywk7mA1xfk=emtqby1UAwFsaH9PChmk2TuZoDKrMzuXw@mail.gmail.com>
X-Gm-Features: AcwNN1U1hcI0Vzy6pZR5m6oVpQepLjO3IAPExcgcrEvv2QP6yu7Rc87cN4jKPoQ
Message-ID: <CAGsJ_4ywk7mA1xfk=emtqby1UAwFsaH9PChmk2TuZoDKrMzuXw@mail.gmail.com>
Subject: Re: [PATCH 3/6] mm/mglru: enhance cold/hot inversion handling in inc_min_seq()
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, chenridong@xiaomi.com, david@kernel.org, 
	hannes@cmpxchg.org, kasong@tencent.com, lianux.mm@gmail.com, 
	linux-kernel@vger.kernel.org, ljs@kernel.org, lyugaofei@xiaomi.com, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	stevensd@chromium.org, wangzicheng@honor.com, weixugc@google.com, 
	yuanchu@google.com, zhangbo56@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 591D54000D
X-Stat-Signature: o3xydorfd34849scw5fpgg1u5rm9g4i7
X-HE-Tag: 1787780639-591994
X-HE-Meta: U2FsdGVkX18nfNhxVJPz0HPHqDnT2wtRJXD6zmInqecR1cYlTaJQFjzQ0Cmu6qtHjJKmyQQv6PW3DdtvzalcRn7l93SIey4N0//rfSWziU1w7Xy3F1fpsXr1vJuloozhnnTYcwp7zc5zSnQcfh6SiS1ACrvQncbzCstdfl+u3kkRSNssPRBnNl/EaXsED2lY32j1ns/+ZbH1wMeVAQSNrT4PwPRWCmavEvcwqT1JqZrK0Gf40u7hUZKIuOP7T90Vy5E7hjyob0L+V8+HPnJdIWEEm4+3Py3cIwUdg3s/WXlCXLOTQ8HHCxlh4dFxW/9RLjs2QNfvMAk0+pbkJslFdZdbBowsqcWPTaaFuIjWNj6T8JQwGFjDVqh3jKExb8Ts5/v4/lS7+0RrpBZX3fQgFzegZcIiYhQITZgAciXFgMP5c9BRvj1ZVdVsrY9S65Nscn/MziG4PW67u98k0wvFQ6f/AVHjYusCyQLvkNIskBtDIgd/C2Kj4EwPQVUpSiY+ZeSzPk7AJF2ZZLu8JhtAhvHYc8keLfo1JG92f0XTGRlBz7aGk4tNB6JLe3IX0SDT5UiPh4HB6WmO5WW0tnhqVAf7w/qJdkoLYTL79iUqpzPuX9r1+LMfc9jz0OhQdjILBjNVKKmCtvb+ftsqEB+0qpZ/aE74sKqvQTt/i46HdUbmVIF0XtgRPv01gJdW0n+07VNLCPby3gDz1gDeJiM59iRWzcr0KyVjn9D7nO4naDYmAL8jAMd1fohskKiG0iJ3CGckuTuk3LrCXZNcRJTvqp3+c1q9gz3vMfcKtUaCumQsIa/brddewfl8klfTpg+/AJFCZu4SmWk4sNGPKZDhbr2oG4028AmI3/5BZP7tg3o1Gfv+kqaQ9Z1YVdq3q9k4Yo/hbxuSfmLQfvO2mc1IfrEeSW6is/0QtUwUaPi+4sBr0a10qKTe6+m6Y5+n+MGaWEnC8ePBE/xQIFKcxYq
 qU8+HfR8
 nclnVSfkUG1m4D9B0mSkdvN5pGzFxgu16nibr8jufKSvNPEoRU15g946waMqg4wtliDsleJedZNttWRa5HBJ1t2zf+F+BjnpBQdtnzJYPMHMfZ+XPSjQPcu7Y41R4o9WeV2pFv1poE1JYYodw/xDLJsOqgVOoiNexm0t9HTxoc8FmP2D6u+7jJBAFxHtRSjQ7F9LMIaESTOR1v3c7/2Zrx4/+J1dg34USQoDy+ZCQCOaFVOmjJ3qy7wbO4iPb0+8V8NkUUzjR7Gpg2Kuv0o9ynivyKFrYf5CrT6CJ+MRhsBaWV3lrs//u9gvsmN+7mrRTHW9fUjZ0/z7piYQb/GtmCxvZ3JS4Qd//nEdrQ4Sy1xpDC3+Efc3JCYI7tw3Xnu56EB0M6TAUXYGQX+YO53IT/9Nc3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 4:56=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> On 08/21/26 at 06:25pm, Barry Song (Xiaomi) wrote:
> > During aging, a folio's generation may already have been updated by
> > folio_update_gen(), even though it has not yet been moved to the
> > corresponding generation list. Such folios are hotter than those
> > already in that generation.
> >
> > It makes sense for inc_min_seq() to increment the generation of
> > folios that were never promoted during aging and move them to the
> > tail of the new oldest generation. However, folios that were already
> > promoted should instead be moved to the head of their updated
> > generation, just as sort_folio() does in scan_folios().
>
> While sort_folio() move protected folio to the head of next gen too.
> It only moves ineligible folios to the tail of next gen.
>

Hi Baoquan,

Thanks for the review! I=E2=80=99m not quite sure I understand what you mea=
n :-)
Could you please clarify what you=E2=80=99re suggesting?

I can explain the design in more detail.

Yes. For both promoted and protected folios, `sort_folio()` moves them
to the head of the corresponding generation.

Here, `inc_min_seq()` is a bit different. We are overlapping `max_seq`
and `min_seq`, so the `min_seq` generation should be moved to the
second-oldest generation. Therefore, I think non-promoted folios should
be placed at the tail.
They are genuinely not promoted, so they shouldn't be at the head.

For example, suppose we have the following folios:

Second-oldest gen: f1, f2, f3, f4

Oldest gen:        f5 (promoted), f6 (not promoted),
f7 (promoted), f8 (not promoted)

Without my patchset, the result is:

Second-oldest:

f1, f2, f3, f4, f8 (promoted), f7 (not promoted),
f6 (not promoted), f5 (promoted)

So you can see that both promoted and non-promoted folios are at the tail
of the second-oldest generation?

With my patchset, the result is:

Second-oldest:

f5 (promoted), f8 (promoted), f1, f2, f3, f4,
f7 (not promoted), f6 (not promoted)

Best Regards
Barry

