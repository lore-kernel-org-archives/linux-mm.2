Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC7B5CA1013
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 18:51:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166BF8E0011; Thu,  4 Sep 2025 14:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13ED68E000A; Thu,  4 Sep 2025 14:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07BB78E0011; Thu,  4 Sep 2025 14:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA1B58E000A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 14:51:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 879A913ABE9
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:51:13 +0000 (UTC)
X-FDA: 83852460426.12.324183A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8461480005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:51:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CgUT/zbP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757011871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ai6lB+pefFbgDbEnmQTP4yLV88R+b8W9zigHFvjXlLA=;
	b=1Sf+li5jmhbm+sOeM4K+/5nDxX61bMruwQ7+Ix+b7Lf4if9tPfpQzx0/ra+fHqTk2vjhAM
	5bQvZ0z7Zvr3dZcB6aydUVTM5NbbmjlYvFHA3bUJiuRHGdqy1gr9Jfe03PfTVNSjwa7dD4
	zD2CwnAC0wAX2qndMxJsvIy+cLPZEJs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="CgUT/zbP";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757011871; a=rsa-sha256;
	cv=none;
	b=Qpy80H97509YLklMKJ5n4kQyVB+0GhGk3ZWaoZA0B5yI2zXpUqIEY6tvKW43koWv35R3Ud
	47X+Xx3LjvTL89YaYqgwhC3EuKYST1fCmoFLfkgnbPSn1K7lI1+9w2UKUq7CkOHepZSXP6
	dOTZWrSnN1dnKKpDs0stfkX3fSQPp4A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4E63F44C79
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:51:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F9EC4CEF1
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 18:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757011870;
	bh=ai6lB+pefFbgDbEnmQTP4yLV88R+b8W9zigHFvjXlLA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CgUT/zbP7Om17YgTUoZ/0Q816jHJtq/UJY5s6ec3LduAUaacBJqEqvDYSkW09fqp6
	 /Z/SqJTTav+zVa/V7GhZhiP00Y7yC73i3S35EoNTHxZ/qG9yMGGWMaGkDzRZcBZSff
	 Qd67ndibH5bCEPcwGaJFfLEF+ozAL+ArAfHewhtIn7HBPEyLNByyTxbMh6sv74x67f
	 /L+jEpjRRz9Z8+pKIgUf8v9QluZ4nCWjJTtGGLqmTvzUlJ62Co0r1yZ3Nz+gId+cuc
	 xFpznwGkLS6wVIUN/3eIZcDhC3J2RgGXICQG8W/MO59i46PMFno3u78QH/yuEzSKAy
	 azf8X+6smsB6w==
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-723bc91d7bbso16455527b3.3
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 11:51:10 -0700 (PDT)
X-Gm-Message-State: AOJu0YzmN9ZICDAL8qtnI6uV1820NyjHh4HrGDXBUDSVr+60R6sxA5g+
	R4b05oirjQSmWQaF2iDLzm0fPWOgy8lkNrtY0O7FSqy6ney7IJv5HlG2Re5cOeDaUFvl7ODNKl2
	+oN0IuR1Is6KlFc3HvaE/tsFFBMwLfWrdUGJhoCp6kg==
X-Google-Smtp-Source: AGHT+IH7qVxpOons5SDsE4z29KsS6P8pao64rTUzhFDwFK8Zp3/crRXFA210Kjq5GPcKz7VZKCxE/sWGa4j+RdNQvxw=
X-Received: by 2002:a05:690c:dcd:b0:722:6dd:55e8 with SMTP id
 00721157ae682-72276356b17mr210031997b3.11.1757011869282; Thu, 04 Sep 2025
 11:51:09 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <CACePvbWG85YJFpLDoFnz05tX2trUJFTzyuELMGYSYr5ye_hQ6w@mail.gmail.com>
 <CAMgjq7Bv99OHvbEiDcEMVYS5bRdSgSu75a8YUEQ+3roLiOo=ug@mail.gmail.com>
In-Reply-To: <CAMgjq7Bv99OHvbEiDcEMVYS5bRdSgSu75a8YUEQ+3roLiOo=ug@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Thu, 4 Sep 2025 11:50:57 -0700
X-Gmail-Original-Message-ID: <CACePvbWg1hg1G0+unAJKz9SiwJOhahf8Gsoq+VB-5HDdAiRcqw@mail.gmail.com>
X-Gm-Features: Ac12FXwtTkBGJRru6NjbBV2SHpTb7Nla8kbUmwJPWO1uDuzkKSDkxwjE537gem8
Message-ID: <CACePvbWg1hg1G0+unAJKz9SiwJOhahf8Gsoq+VB-5HDdAiRcqw@mail.gmail.com>
Subject: Re: [PATCH 0/9] mm, swap: introduce swap table as swap cache (phase I)
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8461480005
X-Stat-Signature: ufq3yet8u1i4z9x3gozc5kcmq1tax71w
X-Rspam-User: 
X-HE-Tag: 1757011871-166222
X-HE-Meta: U2FsdGVkX19q8K5t0W5oWXkjufCWj5na4RKbRoL4oLTLYV/ZWdzeBLubik9X9+Ky41aCOcUTqx1eZP1Xy9DCOab5Y87Nk/c3Kl4nUHeDyZyYWytsg20bkmz4HOcaQGrlDNvspcvEE6mPsIgLHyfra9rWJZzqoj1kwZUpUVJWetfjUs+IlkTL0/7skXU9j+ApUlqduldS7My9+mLGVvgS+u7A3jE9ZhnW93GxhHxC/MdouwFyw7I1B7ToOi2abMovlb1ejlICg9ZQ4DMBO9jdAPMm3x1tYP71YbnUGJg80UePmEQMvUU9l17ubJ1KyAMXeQsKs0P/HmzO+JZpCV/bmNIjbLJDJbUB453HlIOAXzmQfRIXCvupCKZUhLnMfkPmul1bJ2pm8LVSZ1jAoJe9IX+Gq/Xrjhq/GQW7h/Shdg4EQbIYzwh7u0FN9Wudk/w2EqtbQ9YnTryBVGzz5ze44jKidbzwx411uR0RB+vH5axcd5M6eEFkZF6VFfBNMM+4oXtExk7CQWzC3HNwkHMOETC37Ng5VcXzVrmWbDjLERqU5dpIwxtcTaNKF7ViT7/cEMV/BYpfNZF+Goto3gk3snCd5X0Swre4H59SkGP/B59vf9w6eWiFEx9vmBd2kZFflJKcHklulIcBXISctCNdIas9jTwVyQPhzARHVWo9r8vAKkifLCWL2NE32HGzcIszEw/n2UqeLZifY/XaXRfPa8yoG4A1YSLRwxmwBjr8w2KCcDB2eHcX0IyF8FiMWtL+LH5Ns7UK4GWiEPLEekEMgrefV4Lp7oF9DkZ4i+qFxETlriTYztb2Z3+6jpvK7BF/tQBM9vhgDcXQhu6rcokkSAWnLk7wC07OFIviksD/GkKSs4I05o2SF2FinRHOvI9gSjiS4UZ391Kf4mUlingY9RcV8+eWkqER3PGL3kUHKJVjpBOM4Gmjz0M2Ni/zuKnD3H46Bt8Y8nyrjNtX7tf
 3GCQmoB8
 0PJ+/UFfYcX7MLqAb6aHyDW7j5hGWVlbLPV1+jtYi21MOYOa1wAzk792SiTD3BK0qhwdggh3akxbzmyFngj7l41E/kjdyw90o565Mb5jWzrQPTdcCteP/cQbLtD42vYMZNcQwhuZ5QraEYeYqO7qnFHDDr3HTitol2oLGZL0CEwVBKHxHUUR2VBrgl2uG2pgGvTOLUTPKmNsDiYY8PS9ok3HJzfkfLbhiGLd+t7gAX+UiGobZkX/hy5o/5IfYLFvQQNYgA8XSRoCg1ZMVn6YKS0HLtdAOjcU+aF5fAO5/K31G0Sc4ZgSlG72c8N1Jrf9xqmcWIT4dom5kdtk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 4, 2025 at 9:36=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrote=
:
>
> On Sat, Aug 30, 2025 at 2:57=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > Hi Kairui,
> >
> > I give one pass of review on your series already. I Ack a portion of
> > it. I expect some clarification or update on the rest.
> >
> > I especially want to double check the swap cache atomic set a range of
> > swap entries to folio.
> > I want to make sure this bug does not happen to swap table:
> > https://lore.kernel.org/linux-mm/5bee194c-9cd3-47e7-919b-9f352441f855@k=
ernel.dk/
> >
> > I just double checked, the swap table should be fine in this regard.
> > The bug is triggered by memory allocation failure in the middle of
> > insert folio. Swap tables already populated the table when the swap
> > entry is allocated and handed out to the caller. We don't do memory
> > allocation when inserting folio into swap cache, which is a good
> > thing. We should not have that bug.
> >
> > I also want some extra pair of eyes on those subtle behavior change
> > patches, I expect you to split them out in the next version.
> > I will need to go through the split out subtle patch one more time as
> > well. This pass I only catch the behavior change, haven't got a chance
> > to reason those behavior changes patches are indeed fine. If you can
> > defer those split out patches, that will save me some time to reason
> > them on the next round. Your call.
>
> Thanks a lot for the review and raising concern about robustness of phase=
 1.
>
> I just added more atomic runtime checks and ran another few days of
> stress and performance tests. So far I don't think there is a race or
> bug in the code, as I have been testing the longer series for months.
> But with more checks, we are still a lot faster than before, and much
> less error prone. So it seems very reasonable and acceptable to have
> them as this is a quite important part, even for a long term.

Yes, that is what I want it to be. Every time an entry messes up in
the swap table, that is one page worth of corrupted data. I definitely
don't want the corrupted memory to propagate to another place, e.g.
write to the harddrive. That is much worse than having a BUG() and
stopping the machine there.

> That will surely help catch any potential new or historical issue.

Yes, let it rip in the mm-untable and hopefully we don't see any
trigger of that in the wild.

> V2 would have a few more patches splitted from old ones so it should
> be cleaner. The code should be basically still the same though. Some
> parts like the whole new infrastructure are really hard to split though
> as they are supposed to work as a whole.

That is great. Looking forward to it.

> > Oh, I also want to write a design document for the swap table idea. I
> > will send it your way to incorporate into your next version of the
> > series.
> >
> > Thanks for the great work! I am very excited about this.
>
> Later phases will also be exciting where we start to trim down the LOC
> and long existing issues, with net gains :)

Same feeling here. Also looking forward to it.

Chris

