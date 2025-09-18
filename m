Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F639CAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 21:35:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85B1B8E00A6; Thu, 18 Sep 2025 17:35:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832B18E0068; Thu, 18 Sep 2025 17:35:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F608E00A6; Thu, 18 Sep 2025 17:35:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 698D08E0068
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 17:35:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E77A119DAF
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:35:44 +0000 (UTC)
X-FDA: 83903678208.19.8084FA4
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf15.hostedemail.com (Postfix) with ESMTP id 43E31A000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 21:35:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OjzBi3IY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758231342; a=rsa-sha256;
	cv=none;
	b=W92/1nR8Ri0/l1cYQ/3M8m8XuWH6kYHQTrBC5ldJ3CjuJ6pMheIDQOWmZIuudbIPASHXKs
	/QpHWwsioDWjT4w29PS4pUXU2MmBW/MiJwQ4NsQ1VKlbiyP9ufGhyEQsPztXzrVdTcTCr+
	jCFJft7MJ35pYCvZ2FVvi/tk/sjtKJs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OjzBi3IY;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758231342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jXnCKXVgE6hQ+FZVg5JB5sEK2bj0/Q1cT8SKrEgFiVE=;
	b=6PRrE6vE0026WvlQiWdqaq9dbcHyAhVvDNKY/LORYpwxQHPH8nTd7uElsxPobMEYz3C9s7
	3I0Li2fZtbYLLk6oAAzGvkI3A7JS9Dxnj70ORVS5YsRTKu80LmOxy2btzZdDkLTAx4hGvz
	3oPIWwPWrtvqyR7DHGAyFClrcBGEEB0=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4b7997a43ceso16084891cf.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758231341; x=1758836141; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jXnCKXVgE6hQ+FZVg5JB5sEK2bj0/Q1cT8SKrEgFiVE=;
        b=OjzBi3IYhMsl/AfP6kgOeBMSw3aTLBI9EL2fC5E5PGNM4ob9k7AsZEYi2Hi6hYd3+9
         QmDlgKNzILriW7ThReF8RBYGbUq8vuxZ0xk9evuJlRPXbFDvAm+xsebmHEkAE9kN3Y+p
         tZVmCacDkBnQlLvDejVpeL8bMuSj9x2KHVi9cmCTwP3cwdISKedPSdDsT8fsxnJUv3Oc
         BcRaRZgx/Kgj7KhCB/ZWXegFxZlS+klUxGW6jm5Z+GlYQI/lsSbELhZjnwklu3cbLBPz
         Q5vuORwZHaxnxcVXJN6+ejVyQ27Fp6WRtRMPMtAO6Yk73evACKdNs3zCUmA9pGX7px8z
         Jgjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758231341; x=1758836141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jXnCKXVgE6hQ+FZVg5JB5sEK2bj0/Q1cT8SKrEgFiVE=;
        b=lchz9ckg5yvMAS401eJ86lsMQCIYYoLJm+S8wCBn56mP7uHnkKn4MekQVZU0ikaSO3
         3837tNQOdWgzKDZoFSlBpwnLzXD7mIBg5H2oig4VNLeH127Jj6mnmAe3gy8PEqDM4PQn
         dbRxTIuRnobfH45Bepscp1w/WGRb1nqJiC+u6mPiFVNcvNed7iKu1tG4t8BgVsL8J/Be
         et1HYPnU3ebBGAUMxM+XTxYWY+vCArDbkDveObrL0tlAX+9eYO6zjMon1BOWmHSfD8+C
         cO7DGGKyvettUPimMSQfITIXllQ4geSPVw42kO8mR7f536skb9eWbGgQJsZwB7Dztph+
         yLag==
X-Forwarded-Encrypted: i=1; AJvYcCXzOjhtGJm5L4CR83Ubxsin++eerq8EV0qyYHTU7fCptbDdupCamRsJnMNQonPT2px/Z/7KTQwkNg==@kvack.org
X-Gm-Message-State: AOJu0YyxihUH9vXSVweKvymmxzKhLfIPF4qtU7amt+ayHP76jUFRY93D
	YEEcTUdQu1p+QDZ07CZcEIDAH7e31J8AjXVRNO8q1Rn7sqSC4Nk1xo2ObrwpqRShnO3NT5KDG8F
	fy64l94w+DMmVtLYtmXGGlVlfXaO2Wmo=
X-Gm-Gg: ASbGnctJkX9LkHdGGmy/hnnLc9xoG2AXEfRz3seEj225xRhYhJPyCKLaq0Q8dWw0fxo
	kQQwuBeAMHCJMusPriXBOO0OjmfYjojIuHhZx8CuOfLgqrt8eZtld1cZx3AGtwktdC3zU4WtUjZ
	hoGSixgwS6taBH02OyogCRdeN+o6m6338CsCZCoEDbH0w1nKfxdA95QlqLXF/QCXryolcp+zMiP
	I1T8/j7rTd7Dp6/rX96JGimDxquUqjZckkPS1jCUVngzxWJjuBM0w4vwiTc3NCNGgBVsR8=
X-Google-Smtp-Source: AGHT+IGiv+s5AouLfE/H+OI4d7OwQCqJOIBz2+RILHJ3o6xdlmWfK2Q4ZDqx59+U6xEoz6B2TESsbidYoVeBmWAkIXw=
X-Received: by 2002:a05:622a:614:b0:4b7:a951:21cc with SMTP id
 d75a77b69052e-4c07444df71mr8113061cf.84.1758231341042; Thu, 18 Sep 2025
 14:35:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-2-ryncsn@gmail.com>
 <CAGsJ_4w2GqGj8HZMfwndsWu7qkORqsnaw9WwhmQS=pW4gR7nEA@mail.gmail.com>
 <CAF8kJuNbUyDWcJ13ZLi-xsiYcbY30w7=cFs7wdxszkc7TC4K2Q@mail.gmail.com>
 <CAGsJ_4wKWem-STYAnh_0EgSFKzzs1M1c7wz6K82wLt6T6JEw9A@mail.gmail.com>
 <CACePvbU8cUs-wwPsXkZ24EWga5bXxxUGSCT18rKAWFYn5w9rpw@mail.gmail.com>
 <CAGsJ_4yhDU_WVfEybDhGE-WF5+w-fak1-F8jqbAQ-Qw1+qWkaw@mail.gmail.com>
 <CACePvbUabb+L6Z9Nb-41fLR-FMhj--cDWSbnXtCj3rpqXModiQ@mail.gmail.com>
 <CAGsJ_4y8yTX48ESHKgLNCvM1M1_gY9uGnD4qiz8n+gD47Zd1Hg@mail.gmail.com>
 <CANeU7QkZBWFO6SeVHtmm73oLu7r0zavePQEYmQfH8opKPH1QWw@mail.gmail.com>
 <CANeU7QmcC=-CTmJ7i8R77SQ_WArBvjP3VrmpLOy-b7QhCfMRYA@mail.gmail.com>
 <CAGsJ_4zmkibM_Ex7kGMsr2sni85H-cnxQvh0XwkWiALNQy+zAQ@mail.gmail.com> <CACePvbXae0zymE_BHydXtA_pjZ2NqabVyqxu1xKxLjLKmeYH9g@mail.gmail.com>
In-Reply-To: <CACePvbXae0zymE_BHydXtA_pjZ2NqabVyqxu1xKxLjLKmeYH9g@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 19 Sep 2025 05:35:29 +0800
X-Gm-Features: AS18NWCCgGfrK6FrQV50p4UjYkTXPoOuJcmQjaVmpdGYkQAzdS7lktT97iKTrKg
Message-ID: <CAGsJ_4zB4ygGCN4JTx+AW+XAUm8WtFVLVesStuDHc8S-HT0ihQ@mail.gmail.com>
Subject: Re: [PATCH v4 01/15] docs/mm: add document for swap table
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 43E31A000D
X-Stat-Signature: ebgzw19n6b7bx6ny3a4kfr6d1wjnned3
X-Rspam-User: 
X-HE-Tag: 1758231342-113814
X-HE-Meta: U2FsdGVkX19ZK3Dr5KaE9kfhpfKMtsYRP5etGjdCHylkJMXtfdNEWEobMHTtVW7bA970AguDjHHHlCFvA7VMm7RZxjfH3qR/da7NbLheA1KUnbwFI1yfhbJl31Z7kjkFO1uIlCqLu/rlZYhTkvCV127XBQvPeBjgD1N1rFeuLJSlq/2eNTpNBKgbQdB6ZlgrKNSA+Gq7G1d0AROLMiSLp3F84ait/yejiHunw5fz8VXDn34MbDJkfkLDHnLrG62TP546ue1Sf2eQwI9zedDkkgdssafieZqvxRVg/z4kxO/MvQ8MqgtP1eQs6yC2RbDKkGy5CLhFMkMU1JQsX3LfLWVRffkqPCvAPm+cfHT4R3xaEOstgsMM0CwyMCXMcu17L6tm+Uyh22VzoGvGudE0O4y9ZMhFVM5sPBYo6QeN3x3ke14ojaW4OD79Frj0PAlJWut9JB8vf6Ma9QGzhb/Gm6GKZ1AgRz5kdpAxzlxcLNSeG0d5kFI07+X5KLjdj2gkIJ31gHzsTmPWfYZZggbZnmLHoDbN0sFzYLPR/aC02nhd4unX3joi/myRjsGtXvKik01+ihU1MUMLNJaULz5SaxC73BTWPiJNNKgopVeW5SNYF8NDujEvh+bDdg64BsByzEmckmYykiaG69OsiDAlYprTrrKEmwiL54NF1KKK38g1k9Pj1TwL9kI9d2qnEvmoLKkUcIxtZTqg2QxApd3OEZS3X7H6UrKiLogQV3CzONyib4iwzzLfzR6iyiCQAJhp6XzyqiAOQh9A/+urAEVeDEAr+a4GqLAXx4Kh7KZfQUmLkqdOhghldXTQ2pnfVRSIWp0QSJ0ej6e/rMsoZORppMaPY1TzQhp7Xt3wje4iIWj1XYChsVaA4KCrBjbKZaEnDQ0/DDLmajRJg7SmlgsHFvMskLM72Cdc3l4rxPSpvJQLPAgRbwPhqz/LseODJgnqhzVgpAyICCGNjv2JGfN
 qPa3Ai7I
 0NiOtxOYfENP3NY7NgpjcveY8HKQrXSjoBKOpp8qXR58P0HrcMQHy/RIoKRZ5kHCM4PR1/2ynGW+qj4mZ5upHeUGH+r379ZK8g3TM/z25UFZoWllIvad+wFEPJnZOkjZ8hulJPMIehTsfAJMfgxLO3Ejj1CxUdL+Un0MCd3fbhknJ6O7xqlDB6ZxXVM7X5CPDD6Fj9ecPC/hL0FqoF3YNYsM0V+oqbHqfbi7mV/SooqIvkP8ssa9ouUnbcJgvW+Odm0Pu1WMp0qj1i4LBxWMPMN5t3mhbbq9RQeIGcqfaDcLWq8MdIHy59bGPfGMZwYUxlWPYLKhnyuD8RsN5KfjjGMMKgBioEOUQAPz5X3edmEIlqD0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > I=E2=80=99m not entirely sure what you mean by =E2=80=9Cpage table page=
.=E2=80=9D
>
> The page that gets pointed by the page table, or the page that holds the =
PTE.
>
> > My understanding is that you=E2=80=99re saying:
> > The swap table contains an array of pointers, each the same size as a P=
TE,
> > so its total size typically matches a PTE page table=E2=80=94one page o=
n modern
> > 64-bit systems.
>
> That sounds good. Thanks for the suggestion.
> I take your suggestion with some small modifications, mostly to
> clarify the total size is the total size of one cluster of swap
> tables. The total size of all swap tables in a swap file is much
> bigger.
>
> How about this:
>
> A swap table is an array of pointers. Each pointer is the same size as a =
PTE.
> The size of a swap table for one swap cluster typically matches a PTE
> page table,
> which is one page on modern 64-bit systems.

Acked.

>
> Chris

Thanks
Barry

