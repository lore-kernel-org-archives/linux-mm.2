Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E19C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527526B0088; Thu,  9 Jul 2026 23:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D7C46B008A; Thu,  9 Jul 2026 23:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A15E6B0092; Thu,  9 Jul 2026 23:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F08E06B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:29:41 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 88B101C885A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:29:41 +0000 (UTC)
X-FDA: 84971437362.03.90B9F1F
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9BC2D80005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:29:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Df1kMmMZ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of richardycc@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=richardycc@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783654179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nhxH01x/G1oVoXsCxh8uiOizTJqiYQTwrU6XhUjYUXA=;
	b=XYjc3cq2Tsd5m4JYW/iETrk1qjvnbX7ON5tOD/eK/GbkHUcqk6lesQ/GHG43GZhbpqk3Qp
	SzK5qb8Td6VA2OQywmlqb8qm9KjJmWSCTLmys4QWYHspkhy+iETuOliD0qTadre7bz4jsG
	ziZJ8AqV2EVlkmF6qdDv3cf6Dk9NsdM=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Df1kMmMZ;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of richardycc@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=richardycc@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783654179;
	b=hYovXs9qV0yRhNVs7I7cDuDcBog2+XPYiNk/xKjX/kLBQbAbOlSicT3sXpTyrX+LtwKRuG
	1Hi2c7KrRWpTYORdDCR4E3wVw3JAJmzsYydAxO6nuzSd+Aa/pWB0WS7l8CHVp9FJRdfxYM
	o0+Cc/JqFkDMlKeE52bCsc44MX+zipQ=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so2813e87.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 20:29:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783654178; cv=none;
        d=google.com; s=arc-20260327;
        b=Iff+AOoBg8QlUjftHU6VqM38l/CnvZmFlt9DR7Kxuke/CLRNj03OUrfPzqedo7Xi8k
         kGhaNpU/IwIYj8FQJnhiFqJz8AK4KgPnoAMuvCm6JQIP1SBKP0Jev0DonmuagUVAHi/R
         QXNglLJ4dSLWdUq0bh0ekyLav5OtVLWHqMnfKAzgupVxzkbpSzDK80Dlf2OfR19T9ygN
         IfoZgY/epgYsL86lqfkSwRVWOyC20A2yTT92RhP46posKVj0v+3lhY1uhO5zCmC1c+hf
         CHJQkQHG5ol2n7FWPr6Y9n3mnB3/YtOHkG8KTblQ2obq40CaJD1/jp/H22RODNAkJqvg
         C0/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nhxH01x/G1oVoXsCxh8uiOizTJqiYQTwrU6XhUjYUXA=;
        fh=JUyzh0FoY+vQQz5qKeHSfeRazmh5NzGy+kAOs3oS78c=;
        b=HZfB5rfWLO8nAhOl5C/vuW+8zSlQCNuiv7O/cfEsfsbiEAps0oGt2DxTXvFXuCgnf+
         V3XAcUz/WNrQDBh+v9zt0f31oTVQAYfmateV5EU1yHZqRUh5vc+TbVRpGl2rss0XO8qz
         90lRQ0CH0iB7uxZ2tDhGYJxENeXhHlXB846A3VntLN9k9STagrxZIXp9z0J/CweLEgNf
         ym8xd3764TQc7YZh3ATyKUpRwbE39tnuaA0MIFfKtav9PPLLvvVzJc7EL7M0zB/BxkPf
         7iAVt3rU4J5QDcGDlviirGDgn5Y0WUAev8P9FQKZWMYm1TyO5400GXd5bi8jfEs+shHW
         8ZjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783654178; x=1784258978; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nhxH01x/G1oVoXsCxh8uiOizTJqiYQTwrU6XhUjYUXA=;
        b=Df1kMmMZ5sMpWelWRGzKH0CFLyTOoZD5p54oczarvVficVNXW6w6q4Kx4aJZZS9oUe
         xgHyPWrgvWn/rsdBExciD4I/hhigAhzg6bQUva8AT6DAvnJLOPqu6CHOHX5HHLtJh9dI
         x2xrB/+B/rVUfR1TXahAxIr5AfMiuIcwGwCvTygmZuS9dNUHG7fJ97J/xivBOOF7lY/f
         EaiaWYjs+UjSfoAGVOq2xTVmWFNrZlK1eZ5yOOc3bOYDZbqlLA/ZZxUotygYSL/NARiN
         adAVIzYiMenp8REzG1IMA8jCVUPd7RdfWfsa+raudAGsDf0uSP6c1G9J4u47JDxZSjhg
         0plQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783654178; x=1784258978;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nhxH01x/G1oVoXsCxh8uiOizTJqiYQTwrU6XhUjYUXA=;
        b=djwXrFpG8V4ElNwA3QVRioAgxfs82OOkwjN4N6I9gl4+jdelpX7a+6HB64Lbp/kmXD
         ps7XzNmYt+cy0dO19iKTt24dHTizxOp0339n2p5cKKUXag6lGuYmehRUYmZPVQgksj2O
         IYRdzd4ZCaGGSRX4XTBAGe/5GxIIyP6lqEizj9sGJ0UJTfX9L0PsaIt8hAC+yRmVyJTk
         +ESM/JwTu4eAsH/9M0L1Qbd6OxvKLxDwgWgWNcrwe8FWEBwDq4I6NXDYeL6/twMW5fkH
         jWLK2Y65wXrLVi9dXYqGCU5xXOIFf6jDaIKWCBNkvsdKvXP4BlsxBSzkJSSPGXzVmk6L
         wuKA==
X-Forwarded-Encrypted: i=1; AHgh+RroB39PB6/oqnMoGL0WTar6vtgKRG+iwtvx7VBVeXQVSZPtXqHN+aT+dWOXTpttYJJlBj7kY+ELWQ==@kvack.org
X-Gm-Message-State: AOJu0Ywl13y5ttSuSyVI5bSClZWZxw72VFDF5vqYhb0BEKETSgORZx4q
	dLXBmO2gf1CljLKJyRBcgdhVHcMWRcjdSZEMUEIm6eM2UNlUhqgxgjUpaPCS5tCGCNGagdKOSXn
	LMudrUA2OFckm76pxQVCC0tlr1VvdON0Otf877OE=
X-Gm-Gg: AfdE7cnw+DW6eGsMgyRt5hQTZtm4hl+scUzOMimRDHID0/96O2TddnfOCy2Pmd2E/rp
	1F9Uq2pMsynug9Da9Ce/hziDtZ1XG766mwRJvg+g+LebCyFRg8OIZOpi5r2S9V2iyi7kcLiFcL0
	9f0lGWBD7797RFM9fIRdm8TccjqarBYDx7GlV4fkZdey4wBOgDv39fq6LDWKLdGgu/QVOFRS/3y
	vU448eMl416UW8CC9LIQnPN4DEIyMF/TTlkzogk5S96EONqXWQ3Xc6w7si59ZI1i5xtVd/bPT44
	0dppNE1ySfNXSs8W
X-Received: by 2002:a05:6512:2201:b0:5a8:6646:d7b4 with SMTP id
 2adb3069b0e04-5b01cd3d81emr74320e87.1.1783654177440; Thu, 09 Jul 2026
 20:29:37 -0700 (PDT)
MIME-Version: 1.0
References: <ak5-qwmpXrYi5md6@linux.dev> <20260709072231.3163082-1-richardycc@google.com>
 <ak-OyACkE8lLaRRS@tiehlicka>
In-Reply-To: <ak-OyACkE8lLaRRS@tiehlicka>
From: Richard Chang <richardycc@google.com>
Date: Fri, 10 Jul 2026 11:29:25 +0800
X-Gm-Features: AVVi8CdEDrZKrrKRh8Eb_gCprI7zkoPCteZBESFwGkJDbtyr3UZeK0JLPbOvLgM
Message-ID: <CALC_0q8O1uw18aWM8w8be60TxW02Os90AKSOLFoqubYAbLjkrA@mail.gmail.com>
Subject: Re: [PATCH v2] mm: vmscan: abort proactive reclaim early when
 freezing for suspend
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Martin Liu <liumartin@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9BC2D80005
X-Stat-Signature: 7i8we175u6auak5q1hzacrx1nknwigts
X-Rspam-User: 
X-HE-Tag: 1783654179-815307
X-HE-Meta: U2FsdGVkX1+ItbWZFT7pWXtjiue3BnRhg1gIRDkPOKCqaN+rDMnv+Lym1mz1oDfGbeprmqeBgP8HTjX32x73b8vgLl4oxE/6EAocMtJiRYH2BRQ2B9BTxs9uCsT0/t8dKopoIztBBJwdQ6vfMrRomYM9cA6DqYMkkm7ftcfdPSJwkTv+P36EsXjEg0z+Vjh1wGXkYWshD5kGu8M6b3uWNmJtQ4BHAJqENh6ptN4TRwKqCHomK57tIRnSW2xnxTuypgIFxhVS+SQadlFV3FyFo/qB3/l/C+FehWTjHCV1Gx/lphB8Ye4J22D9YhbuvQbGqMRcBGshDhqJKTod+03YQcjd/f8cst4is4qLbOmxMI/nMqqtu9gnZpPtiOUtwSzXJd413TGMP02oSh+/yrOTMnWa8hXD59El82muZnPiW4jXHHdVVsym5rUV5oVWqsCWJyF7qTcJlZ9glK9icyTr80jIJpBGJhM8u7jI5j0YsR4lZDfgRpKvikhpEAXKBB/Zx5kPlb1QYMH50N7iqLrHWolDCckLFy6wJt5znjPIiQn/Sotux8ln1ghP6lFYE0tKMV6HLo0B/imo/PUL7i6j/hrhxlTtN2jjLyWMNLpdp1fzu4Qh2kBd6Am5W9xOGAHB8n0iyO1hkuL6F/bs2DXHp4bJCwYksHa7MMfsRCYd3sQluQkjKKPbUUGGhrPrPtDOJyi5RW6YKKsTKWezSeTMJFNQmn7YQB/GfkO7I6q6ozVQ6pI82xWKs1K8q+ZCJXypiS+ITRWNWqa6i33xXwznK/vjP4gXmOPxQFIR0QQF7n7ubkah6XHcc2yOKnVpy4GEUqEWx1MEHE44VPv/LV7YrQ2+/tNx1NSIujw4BZ4kZlo4iJeWMHjo8Ab0LukcxveAa0r7z5MWWxVf0Kr0P+ydBJ0Wx4e/Qoe65qTRAwehwzoo9TmNfKNe2TzETRhF77x+jftn8IA1f3y5AztSzat
 IGcp1sZO
 9PKiNIi3J4fvvkwV2JLlHuym0llsrTU1gHOM4wSRxbPtljLs28cK1p6hzLzMrVf1epthZkAvHX9olQNA43hD6CvNaKM1paxKKeqrncK6L35KF5Zy6lbK4xh7BhsD9g+GX1g4hjnAC3KWU7ve56bIq/hZ9jJb5t07G/+Ok2A8VA9qq3vZvhcAXHvdvmIfq81Z/4tL/85VNiar3Hr568G6nwmxfgeMIJZbFEBpU9CrYOZydPnV6H6foEQOyZo7QbdVFe4gOgPYbcr3yLm7Bqz6ai9yVEjovk4LMrUzCkorI0oobn41DaNhw2HSxRBxv7JBLfpDr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Michal,

On Thu, Jul 9, 2026 at 8:06=E2=80=AFPM Michal Hocko <mhocko@suse.com> wrote=
:
>
> The changelog doesn't explain whether this is MGRLU specific problem as
> the fix is MGRLU specific AFAICS.
>
I will prepare the v3 changelog update. Thanks.

> Also do I get it right that freezing a task while doing the pro-active
> reclaim will force EINTR early return even if no real signal was
> delivered to the task?
>
Yes, that is correct.
The PM freezer ( freeze_task() ) calls fake_signal_wake_up(), which
sets TIF_SIGPENDING on the target task.
Returning -EINTR when checking by signal_pending(current) is already
the existing behavior of user_proactive_reclaim().
This patch does not change the behavior, it just allows the task to
exit the inner loop quickly.

