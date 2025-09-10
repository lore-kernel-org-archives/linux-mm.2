Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD94CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D26578E0003; Wed, 10 Sep 2025 16:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAFBA8E0001; Wed, 10 Sep 2025 16:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77508E0003; Wed, 10 Sep 2025 16:04:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A31218E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:04:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5ECD713A091
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:04:04 +0000 (UTC)
X-FDA: 83874416808.20.E5378C3
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6AE8240012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:04:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VkZ1oX9f;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757534642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1jQiJ3ObLTg319C1JhjfpaeHZ2yabjm8Fny02p0E5k=;
	b=RlLmPaH+omBuV3fPWPJ4m4HgDVvSwWtTU+fJb4ywLvPzTpOhRpJxanLItqC0wRQBlYJFE6
	as6BkvTQSzBSRKsnhL9bcs5gamx9iAnkvd0hYiNeeLB7QKN5OHry45AaQFsCb4GeCfMNM+
	yI5GPA8Ou+3agjzQ+Y3uN7n4MEbaPvE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VkZ1oX9f;
	spf=pass (imf01.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757534642; a=rsa-sha256;
	cv=none;
	b=Nvq2rBzfjKUneFW8Ze9aHth7EzqcTyH2JCEj0TUUGkNtmoOjPxE0bGWmYW1KD8Vk79NJMg
	nJ83jXNd8PIJFqBrgBuxo95xCNTlkaLlG6nq0DmHV+Pou8yFzYhUVyhUBrqtbZzx9vjzRz
	M+ilzi9ZjSGAKnEsbVo73i0mDafD+oA=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-45de287cc11so6692685e9.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757534641; x=1758139441; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i1jQiJ3ObLTg319C1JhjfpaeHZ2yabjm8Fny02p0E5k=;
        b=VkZ1oX9fRNjRdETlGvq/TOlmvO7jBWHuSKiHA23eb3l6qaQJpy0v5jNi5jNKXTbGD0
         Efhf4R/LLgry/bmpbm7e7GrXKreZ9FwgeQqH3JS5yS0QG3FuR/aqB1CS2LC14G75NlhX
         HZcyaaWNk4LCtqD/H7M7JT54pAGWITyUtAg7t+wgxvRLOBdpEWhCCrC1R5V5Oe6xs67Y
         4EyMmA5oFRVE1pGFUg6MyZaab3OzA0mpjYkQIHoXBiDnR9A9pWogkapmYdQeEiUjGJ7o
         5OFVCdlAyxYVVQMtTcu4MMSENhBzwGkXyMGQu07zHdNDTQ6vjA8z7ZCqDJiKLfk3tMM+
         azgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757534641; x=1758139441;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i1jQiJ3ObLTg319C1JhjfpaeHZ2yabjm8Fny02p0E5k=;
        b=jbiZJfF7E9vWo73BLeYFOdtjDIRWHVweZafagLGdLtNU6UqULZ5TON/U7Zdos0a21j
         xwjD65P0JbeVBu1GATcNcE39cGMNsT68bET8furhIuDvFmC0tl0C3yW8Z8qLqKuXFNW7
         JQQ7IEHCXAmm14CgHGhGCW8zKjYbzOs1u48udoNUNx9cme46SnMCJR1J3DyWAYfYw6Uc
         iKMP0b0QHHjsVNPDsdHoE5fuI3x2REoicjchYaviipCG3dftREZbkibWPullOvQhTQ2U
         GuVoutr/aLjtkStF4kjTsm1rH4NFk8Uh8ZVpsV3hhmeMRq4Mdp1J8AjecHNL36tbIwrb
         l5SA==
X-Forwarded-Encrypted: i=1; AJvYcCWvQTI7Pf01nfgBOcN+xUmZAMvE1Pqiehjd9TutSJdkWDUrazmB9vdJxjuKCXZQIugA62XQYkG8cQ==@kvack.org
X-Gm-Message-State: AOJu0Yxt19brwvb9hv4NzrPmYzVZhRYsx31N4YVK0FFUX1Pq7Gg4L1PM
	5v09JgavgSLW7oAGBBhxLtfAYu2xIUhmmlI7t7xf4KG5HSMIzgQGpoY3w3ViRqzSwIzR26TQ7iv
	TXhNtgymYA4YEPMK5c81UtVQplLbhrYs=
X-Gm-Gg: ASbGnct/PXxWA9TTCnEkgVVuN7D2nhjr6i1B1oim9RsPiNGwCH0Zv3WAYimBsoZ8ybf
	1gFmbnA51XMtK8mmia0z0YB9F7lmigJb4s17P3YeHMDYMXiJsuh6lgq2XdZFRFggqJQkF0j9ZbO
	zKyvgekKrTDDNGL2NgOeRewlbIqM0NmlmAzET5ROiDrohhKXgXxqljgNY/5BWV22Zhjd3hK9L6c
	5uRgUaoqEp+vTg5ZhTSPutb0xbNQqsoW/8w+gOjYiDq8fU=
X-Google-Smtp-Source: AGHT+IHPrzKh/NCjMb67pAYjeCbaSEqLefsgomfptnL6IFJqFhrI+KNJoephS6rhwpbWZRbU3aUSO9pYYaKzLjPJPUI=
X-Received: by 2002:a05:6000:144a:b0:3e0:34f4:31f9 with SMTP id
 ffacd0b85a97d-3e75e0da0dcmr623851f8f.1.1757534640406; Wed, 10 Sep 2025
 13:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250910142923.2465470-1-willy@infradead.org> <20250910142923.2465470-4-willy@infradead.org>
In-Reply-To: <20250910142923.2465470-4-willy@infradead.org>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 10 Sep 2025 13:03:48 -0700
X-Gm-Features: AS18NWBatJeXFdJGu6rcwS7sBR_Pic8cjv0HVbCHkjpnGKgYg7Bg4nvnNOpSi4o
Message-ID: <CAADnVQLfTDH7UXtRaRhWUupnUiTwgzMqTGEuHuWAVa_x_EWcqQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] mm: Remove page->order
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, 
	Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6AE8240012
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bnouda497bp84su1wiioinrkp5jmuzir
X-HE-Tag: 1757534642-807885
X-HE-Meta: U2FsdGVkX19I4yTdJ7E+KKsFY6WlcTXFs3Lqf7vQtcTvApDaQx/rnP6VigmiNyW3hpUrX4NKEoko12kGIjkY00gt7uuF+GO2wuMg3Xr4ZLj2DYwy+tdDZwtsiTeGrK2MfI+IXU+n1M87J4t1kWsWPEloEUMZCLO5n0Qy3SA1QwGz8/8S7vNqbc4qzIbtcgZn9tG56BLkwLLYxyWDL0EESlcBl8cr6CWlz/PTFUDYC/wr9xMTNbue16pvI845Ee/dvnXnQc99TZlLbQEc9u9XQghzTixsRCa/WXsf+iuhceK5j+FFhjRKpiqT4ln+biTl0nvRbUe0oJ5LEXCZWTnkfFWu5Q2pfVbQcYL1EyGk/JudP+eXvByPQ1bUbwp5lkMcW5IYm7u00uJC9M6cRMaI38j0syyHRdO5JgGGVvjZfaWx8vgCXAsS6SutY4r6S4Cr/mg3Pgspy3RxX/ME1PDVR7ouLO5pEKPWzXUh0mrJ2hcWjF21aPUPic0dtbOV2z2jOnlePbJtUS0lbpPnOem5g9oIE0Gbazs9RfWRjzEKPadjCxKESx+cWS9MDEDFGhFyhXkRkiP5QyXIcKJwqESeooDre1zgVmbSoVZ9QtgoTH4AB3o8S+tC157NJyy+FYnyq+4kDTTz7SQ2ElXschRcvdtP8Awb/CJHXpU5VogdcPyeTHNmKYdvCQFU3Tk93hgV5281wdw8iKdbHgij7osh9rLgN2TsLJbtvSMlgf5mRUu9OH8XTQKv6WDBsd27XSTct4rvTn3R3nHcrrjKSa+AnrgCnDG6JoQ+M4+zE9pzc24BfuWATVPX0KQqP97m9+RovrBhLKceOaIim8FUbOTBGZr9XaALYGjShfqmrOKXIkMI27RKnRlw4gY6mD34bgEITAgiLuwVy3uFqlna84OT7r4JmXFl2ekt1vzg6wh/Rg85pcq2guUSiVyuumiwky5anLoz51jnOom09JJcrg3
 WMWkK8V9
 UHshEsWoY+sHbDLjJBIUVOKFzuMxu4nUQXkUg7AV17tdxA09dR6ya3cu+oxvLRmmuVNU+W2yeX8Xo0RUjvzwrqgY/A2QRdBQ4bzuN2sR+8DCwq3ATHzQiTF+7AZbXdjyShe9dNr+/L6yMdzVu2YQ9nbmA+LAKow79IsFB5GHSTmgfwUGdn583nVgvLn5IbsKwn9uP0FC8kGQpD6+UkPvWWtazHc9nCEIP9aONOpX9wtuORdTDrPCJri5frLXbT0YNMD3OHmkkgS4vU8ANDwvEi2PytW/3fVqgOVUx5BjD9qYbjfWKOo9scuIn6oxvE5xgpKgCQ+yN57zJguK6FwvQg61d8KVD2JODoo+1TlzbcQFhvXvJgeMaGxnGz+poLNHiY1Wqa4uqXc/UzQmDOWO3tVm94NUU/NejsQ/LPz33MkH8H6CPyEG8tCPSIAwhx/jZr5SLRjnEL7w8rFoNgq5MUymiKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 10, 2025 at 7:29=E2=80=AFAM Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> We already use page->private for storing the order of a page while it's
> in the buddy allocator system; extend that to also storing the order
> while it's in the pcp_llist.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> Cc: Alexei Starovoitov <ast@kernel.org>

Makes sense to me.
Acked-by: Alexei Starovoitov <ast@kernel.org>

