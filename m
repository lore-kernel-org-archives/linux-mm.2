Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F90ECA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 13:46:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C478E0007; Wed, 27 Aug 2025 09:46:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CF68E0001; Wed, 27 Aug 2025 09:46:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89AE8E0007; Wed, 27 Aug 2025 09:46:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 96ED88E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:46:57 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C248BA7C4
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:46:57 +0000 (UTC)
X-FDA: 83822663274.23.18F66C5
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4FD1A40009
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:46:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K1EyJHYo;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756302415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tWdtgwMC4xOmfKmxCHPIWNUnKj2dqPGspbwOLyOacsE=;
	b=Gye3XGwKtPL5igIvw/iiHm193sC7LPBolGjqqntPqhvvBFb3OWKcOVUK2WKXuFSGuDxxKn
	wQz1/42C+gnHq3ziVF5fvPmh7vTuiQHHOLnyexn4PjV4xJXJCY7kT2eUM8xRnO6kqZ9kIP
	KiHsgVbYDoRdRR+yfiWxbqyg0zr4ewI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K1EyJHYo;
	spf=pass (imf04.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756302415; a=rsa-sha256;
	cv=none;
	b=vH+kycim1nbr+Sw+0KRbtfBurqRRaGjDERnMDY+ol1usYqAd7taRjp78ZUjJvpCOdRKIQh
	VFou2odS6FBhiGenJUpcX4ZnrmVgXsL3KK7HyWpMtWUbwflOXkaWv9F5zodcfS/mBUCdNv
	Z4PZoshxtXjHcp3ssi5Ttv78hF25QqM=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-333f92a69d4so50280881fa.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756302414; x=1756907214; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tWdtgwMC4xOmfKmxCHPIWNUnKj2dqPGspbwOLyOacsE=;
        b=K1EyJHYocSQXKtIWvbdhiSc3eELq6lCIBJvtA/g+j/U0kJm2Qt0NOiRdKgasmjjL/6
         D9WZuav6s2PlPATHT9l+ixy5Y3PhF9rnKBt4y1QLjAPYkUCkCiDWz8kfzupkfrm0haeA
         LG2U0abwuLzrTwRGALb7YMzZkc5wcP3j418SUykDcWEcdcGWtGlHjeCB6H6h+lF0CBFf
         zb8eReCTtaOlSny3SFXIkx2tYVkZTVFlhf+uz/GMDmjdyVN/s4/87nNAzjtG7Dq2qzoB
         AnyEWVdcnL7fCIHZ1ownLnMsD423iMBX67w8Qj7qeMkQp/d3l/UWO1IuhDQ6slEzi9FV
         Apow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756302414; x=1756907214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tWdtgwMC4xOmfKmxCHPIWNUnKj2dqPGspbwOLyOacsE=;
        b=CnZc1mA7uAVaIk62jhaXMDh3GVFqCTmdCkm9z8Qjc4azVDNt5KDvUgP8wV0ePuCecO
         KSRZIxRU5BHBdyu3oqowf5267O5+yRiQrjxnfRQ4DjY1hN3sCpSHumAT/gzYtsBVG0/n
         VrrRi/Mw6nOuwSztCYGV3KhewFSRraVgvAh8yZNQF0nypi2oqkcdxeF1pVmXhzuPud/K
         1P2dMwNDm/vaXqj/JgNlVG86NYcfQW67zqiYbDJfzH4TtpfvpLT9G560GmvxlVV2iHdB
         2+eINSqbuqgDKe3lHSUaQtEiDv+7exnIViviDoL2kCQwDD0KcYXxZcgnBGkX9hzj9Qcu
         +5Jw==
X-Gm-Message-State: AOJu0YywzWiVdjWHCeXwGXKU1U60EENvuSOhNibSuKGJfzLlWmg77GZl
	6PqqSp+PEwXuglv0khE6dLQq+aqyuJeal7xwUjqIDPx4enY2y3fZ128h3bwQqRhi9IKF4u1QMuB
	GU1e1BAnz4O2Gr+hkrowf3pAoE7BuUZfcJzFhOc8=
X-Gm-Gg: ASbGncv+FPevkD/rLDj4lTPEkDntMN26zUOrtxhORk7CilIJwydnLUa1gZv54KklzER
	s+B4UIYPNxUHC4Gktz9Sf7bxm6Ad7tbyJhjBBYTAuuwPTPLH7IBrjc+ae9+RDjOreUlJjEivRFP
	L39vTPBmdgwckW/Y492Ecl2bf3tSXy+nRSQb0Cdjk6qNZ2kLdY4+p2C5Xioj9Ft2Gpx1HsjqEz8
	VuqKz4=
X-Google-Smtp-Source: AGHT+IFjPl2md36EjKemozMYhYwDLSCZh2KeLt3TyuHDY9I2P4jqHFGfc3BYtzJxAKzHDYtC6+Y3UQVaMl8l54xjk0g=
X-Received: by 2002:a2e:a4b7:0:b0:336:8c6d:dfe3 with SMTP id
 38308e7fff4ca-3368c6de41emr11268681fa.18.1756302413473; Wed, 27 Aug 2025
 06:46:53 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-2-ryncsn@gmail.com>
 <aK6A76NVcV2j+J57@MiWiFi-R3L-srv>
In-Reply-To: <aK6A76NVcV2j+J57@MiWiFi-R3L-srv>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 27 Aug 2025 21:46:16 +0800
X-Gm-Features: Ac12FXyR4V0OeH51yDQpMdfxm3IPqgbIMY4zg2e5mYKtqWnw1-Pko8dcKcOhbWI
Message-ID: <CAMgjq7D93cj6CHxJDKc1ax5SCeb9QvFt38YWQM_rrF7SRi+zCA@mail.gmail.com>
Subject: Re: [PATCH 1/9] mm, swap: use unified helper for swap cache look up
To: Baoquan He <bhe@redhat.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: s7rsfgtdhsfe55optjn5pcr9fxbbad1m
X-Rspam-User: 
X-Rspamd-Queue-Id: 4FD1A40009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756302415-279086
X-HE-Meta: U2FsdGVkX1+FcrTpt8b07Py+RmV7h1Uw4RdIetBGQCtbOzvSo1oCnD2P7mbim16HTJm/rGA+ZOEqe729FoQWtynQjcUNmW8OTUVI+qzmutNQhn6DuiGEX7Z9J36K29PwEpOg8KFXp2HCr7mtv+ApebyWSae5VfWNJHx32lCv27JHuxvjHlR7yTxeaxoTlp4SUt/AaJRoNQ6avba2VF1XjiGrPB8elJOktsbKuFFt8OLxwXuPA6Zy5ag49HhPRW4TWrhW1XeU+uiljqg6bUKa6tMlHdPinK35dUUWVNiW99jKASgBSM4wvOVosXAgO+b3JczuCdm4gbfZh9tNZ9vhXadwpYytvNj3n4Mk2VHYfosr4WSadKE6LvUDL9kLJZ93Li3a53J1oSuLDSQbLPLaxYOv/3AQa/CSYXFtD4ywt/qjYn3MtwJm3rnS6sAK9wXnBZdMpSHbnH3nuKwnop65G+O8JHQYG9hku8Pdf7wt/88pt/dd9z78UgKfwaFwkhfXtn/heCBqAIwz0DFN+JUqhHIBJ1nxkS3VJhGU0T37CHhzVWWT2nukE+2129Uzfh1sPec8oItO/3fnjk5hgCR9WxYGT8eEqZK9hbf+X9WpRVRPCgzhr2ZKFwTQvJuUhyQZyKHARR8I71pPEhMWDk1HKjoz4vSuynO+PH7W9hoiEUIglZ4Ed9mn82i6HvqoH/zluAvT+Ssd5zce/sVQgJEIHjE2fSOVDzQyfSHX0CYUVCgMIDMMxZ9nT6N6O8twcxnBQs7imxMCJVv69ob7UA9j8GCCIHJyi+m0ZrEMRbOR3lVSDvh/e4KmfThvVYj4azAbWwPdK/dwjBcnhjM8GJcT4mHNzSqf0lCDc7sYcWqcWj6BrhTpD5YqxUgGmHsothbFDfuN0W2FzzD+HplmOunSHWZS5IEyRKuaAFyc+TvJc2dYKlnBmGcpbvil2EnCa4BEMlmHHI6LsYn7kzVXlyw
 UGF5joqC
 /Z6r8nuPE763K/GnvDR6APSHePuIRwM4QM8Hdf+IQIptnMUBftLvGyd8hxUXWfH/sXpBTiAAG4A47lopc6KfiDL4XL13v/9h6NDA4EQfwIvIjoa7chcj4/UyJOL6+yG9kMgphENtEF/+9OQraiQDi2RV8umR31Q/Z+zOn8WfQOoSdEqnxW7g1X3jmAaCgyBjFlCkMr8s4tqwu4zXtEUm5aimNBZpLpZYl7so5I0MreCKgDIQFWrVeBS8Aoy3CMsaGtEaQH0lFj8vBTuJVg7De9f1aMorLTpaLxSDtIhgMIbQKPjTfE8wkmKmTYwItp+6RYQQ/lGRU8Lm7jWuct/CBvd8m/4Hn1faII5nZSXiZ8Q8mD0+M9GSBpM8K53OPdn5SpBpMr8BJEY5X9wMrcHAgH4i+qQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 12:48=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 08/23/25 at 03:20am, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> ......snip...
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index 99513b74b5d8..ff9eb761a103 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -69,6 +69,21 @@ void show_swap_cache_info(void)
> >       printk("Total swap =3D %lukB\n", K(total_swap_pages));
> >  }
> >
> > +/*
> > + * Lookup a swap entry in the swap cache. A found folio will be return=
ed
>
> Lookup is a noun, we should use 'look up' which is a verb here instead?

Hi Baoquan,

I just checked filemap.c to see how page cache helpers describe
themselves, 'Look up' is better indeed. Thanks for the review.

