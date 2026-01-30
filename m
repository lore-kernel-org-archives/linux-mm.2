Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7CAFE6BF0E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 14:00:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B1466B0089; Fri, 30 Jan 2026 09:00:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C786B008A; Fri, 30 Jan 2026 09:00:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19EAC6B008C; Fri, 30 Jan 2026 09:00:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 096E36B0089
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:00:56 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AAF83C2476
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:00:55 +0000 (UTC)
X-FDA: 84388791270.18.13D9CFD
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf02.hostedemail.com (Postfix) with ESMTP id 880ED80006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:00:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hof1iViL;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769781653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nM/SdAiqzbUu7ru7oIiet8XstWPtQwFu8sHUWw12G0Q=;
	b=jQdY+MpaPCwEb1FRkB12lnS17kON3R5Fwrg3GcRDmpM5FKnxveKP7vtiAoJWcBrEzQn1EO
	OFZdWPmn5geUjUQaNgU50gzmgc892Xwtgo5A816aTZzNyxKFYnyoEbYv68cLcOWl6XRMKi
	jq+E2FM4xPizYAVbARiL4Ggn8xFIHqg=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hof1iViL;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769781653; a=rsa-sha256;
	cv=pass;
	b=CB9XZYjMjGXxPFjWMKlstqZDFMUhzlyw0sYNhxZXHFnmhjdketJOCY02MNLU2/Chb/n063
	dot4d5aPMjOQ8HHdu+Diulo57DrFIWN348BlLUpqN/J9qTcL17ovtPNE1X4F9p46Y940L7
	HPtb+77yx2cerYFJoKkbuDm/7yJJY20=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-88888d80590so32414996d6.3
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 06:00:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769781652; cv=none;
        d=google.com; s=arc-20240605;
        b=F1N1pzwDR/WL7GaanIW/lGkAOHYhZ7Lednh/uFZKgyf3XlZiwriajPDkOy9Ad5JmKe
         pDBqWJrLiQv2YuIEcfyJC680qHfUODjz7QTdabXLdtGn3IMkSp9SsiAk9+r1lkwLQVVT
         w+7ArPi6iHjXLrhw7JVcWD4WRp+xatuhaa9Sy/LnvwBCMTgxBw8Wv3edSwttFNAJ5VJE
         a/oLlYK9lYM3eOyg8y74q3J65cMXubkCVyzaLjW5I9xDGU1EjLwslfHDh/faCx0feVrU
         AZCT7vileMkmiOBBUINgq89fGgJ/sehcn8IB0MvxgzE+Ns1DHYFZ61/S/Je6FViJSgzN
         Az+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nM/SdAiqzbUu7ru7oIiet8XstWPtQwFu8sHUWw12G0Q=;
        fh=b+4JfS9BqLj1aBOpebcs7ErLps0uCH9+zsUHPe93Qjk=;
        b=lt+Q7V88LnIh1bq0h8qPcQOoJhH0JuDTofWTsGuKTfh6y/TJBiy1u1ts7OiaFgqPrw
         rVp+QHkeIY3tFWEFqLLFaARVnRjcqcLzcflvLXKwgR0NlY1L3wGzj075y0/xT41UARZj
         kirBQNKv/5qD1go0ncnU3WOM78BVKZrgHVvmxQ1PkzGENaGJCuVRB0s4GgMYIyfIMmZ3
         i92iKCgDr/R+6sxsv8xDOCYnZK1AJfV5A5zHlNQHVXuzYuxSeh8B4QMOf0Pm6AfjemxV
         Q28ACdkI5B4s+FN41bLAe7kEvVWTr0noK2BaPkP91Wg5e2Se/1VmZM6BulF5QtF2c9h5
         xP9Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769781652; x=1770386452; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nM/SdAiqzbUu7ru7oIiet8XstWPtQwFu8sHUWw12G0Q=;
        b=hof1iViLx4fmlwPnH/fwobmtx5DX+30s1BtINFTYya3WT8iPHnWsMzxM84vv8VdYKo
         ejZCZ7v6wSR0XHfTEZEOAY7ko/Wt35dXHgSf2TUIqf1PzLMWaGE2zhm/Dtd2JHrtc2d4
         7N5FxjT4RFnep9QKruYkksba8je89oW/8UOyPAb42sXE8s56/0PvGeK9H00PK3gFUZg2
         TtWwlm/NVHnAPZ6n3DpDJVUjsi4nVTPpn465ZmZdQGmH8lKywgQlOykCo0F5oR5TS+Xn
         YK3PIWoQ+d0c3LhPnzPhdtNG4gYNWF6eDN07OBAfK/mCOHRovFoPjQppZy/2h8rrghrz
         IIHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769781652; x=1770386452;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nM/SdAiqzbUu7ru7oIiet8XstWPtQwFu8sHUWw12G0Q=;
        b=aOv65T+N7unbukm5OIzbiJppD5bi/jUs6JN+txW5tKo+xQtMw7yh0NAEppRZMSUuu0
         tiNkxxAGlCZkkmaAeePH5IfplgIUpI+j5TLPFu643HbxmyqRpqU3TjIxKYjt5GG/ChWR
         +HqNFoSMs5exr3b4/cEx4SESr3uq5MU5qq/x5nlPH5NASc6i6ghYH6e689/CMsKGjSok
         LT3OKW+4hB3CnTAzhNyUBYr4DJKzOhGHPpRT864JBfs++bZCfb/SsqyKzI68PqZt75yD
         loglacJ32G7ZF1TU4UTxhr/UfHD2M4CQtm/0n6C4nd+6iS0pyaZOxUI3huw3ZeNTmUoP
         cEpw==
X-Forwarded-Encrypted: i=1; AJvYcCVk40T/wPcSTPc9dZSr7pS6s0kruPManS7G2VmMLYpHXBEsD3hTFxNz2sk5OeqlDo9+lM5yQx2rWw==@kvack.org
X-Gm-Message-State: AOJu0Yya1NUd7kOUyVltvot9wKZMA2ch8Q6xrEc2aVxS7MlSknpfksK8
	6568wGYdIZpmhRu6WONh8qJjMcqNlNlDCcpVBxC9yscfKXe+ZRIj6hgpJCWwAk/CmjGx4vMRyue
	RE+Q8RCE++9lBMdPTJy7rZstlFKzgzRI=
X-Gm-Gg: AZuq6aIyqbifwn4avokTkXDjnpESMeMbwmrV9lqZZOEuXcFlxrGPrQBVL6eeNzRiwYq
	MwudR00AGkY4mucpnfbqQLA/ejwe6J/YNJDpz36PCDl+tQb95lpMzHm8lC4RAA5+CWHv3zTfj0p
	ahGRv3cBNOomsf910cTr8a1mqGhCr3ihGNdU7h0zDby0SwIWMBSMdRLnrNOfZw/RZ6D/tYTnmAL
	u4f1nlaKR9A6fQLLvbeKdz5JezYYdN/J4Fg7NNl60mC04Tki/TBrIESZjule3v7UZs2JkrI
X-Received: by 2002:ad4:5749:0:b0:894:6ff2:191c with SMTP id
 6a1803df08f44-894ea034885mr37076256d6.33.1769781652275; Fri, 30 Jan 2026
 06:00:52 -0800 (PST)
MIME-Version: 1.0
References: <20260130042925.2797946-1-shakeel.butt@linux.dev>
In-Reply-To: <20260130042925.2797946-1-shakeel.butt@linux.dev>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 30 Jan 2026 22:00:40 +0800
X-Gm-Features: AZwV_Qh8eUHpePAv_A_lOlwdp6GVUu1KAmqw4DrtwBjVbWAU-tLa-e42BVT3QeM
Message-ID: <CAGsJ_4xQhkEOe2Juqgy_3u7PNJ+hhby2qrpdf_X8YCuEwK8Yrw@mail.gmail.com>
Subject: Re: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in collapse_file()
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Rik van Riel <riel@surriel.com>, Song Liu <songliubraving@fb.com>, 
	Kiryl Shutsemau <kas@kernel.org>, Usama Arif <usamaarif642@gmail.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 880ED80006
X-Stat-Signature: 5f173bw5upsjgh1tix88oumpxw8bcb7c
X-Rspam-User: 
X-HE-Tag: 1769781653-635448
X-HE-Meta: U2FsdGVkX18luMcWs9MFarEDIhyZ2gTkFQrtieBsU7kvRI+SJS8hk5cjVPdM83ZQ2hTPH8ZbaEhkv/fahK9/E/dVAxxK3bdYelpZJg8ptZ12GM507IwQF/k9nIvOcnCove5VtuD9pmz46LFtsjs8kMKWlWY3Z2x4ZJiyJIGwMWzdvfh38AD5kGdooxvWMqxhdb43yXNYNNg5Cne9XK9C1lZf4K39etiYzDHvlXGgNaVHi4NHy1ErhtO+4GXI5mU/JoGBzvYQn1wvurBW7XX9/REeelOclVJNVsXcv8dX7eXei9r+9lfWjkoBpnG/PTXyWMk+yGdz/JsUxHA+irZaobpjCagP+GA+iXXGy3GEftpcIPva55dmRLuSW+sFEwRv9ldUHrfG+mY1lFHH1tCS54/Cj4rTEPFIxWpNiW+3TW2A3QCXiRJuOBoXLyVfNOowOmx+uqORTlPzaIHc6ClJu4cf2iwEgTi/z7Zu6NLIXdte04xb5h5SJElyne66vFqi9S4zWyK/hrRVC7aammZeeF7a8cbhohg9iz0wSFf9cDlW9K226KwXcU/U3P4yetldaxDKV/X/ZjQxS/KwhO69P3LOFlFaNS6tVBYUPywDRid7sCnlA3JuhS+tXP1sqJQNuGkLIC/s3iSlHYH2YcmYusFPGBMatdnNZcyOV4RPWcn8M02fanRSaaCSk0i5HWInBeqLcpjsN0dcSFvi9JFbztsNSJBCZK/J1O5GHK+T5gUPrQOW68P6NlLFJoUGi7Od0sRGqqedZvBYcw/UyPO1yeT8DvNkfYvQ0N3+l1ma6Gk5tLvjW4JOfSFzLnqLHjLTDBUHIsLJ14IftXCPZJl26bypxI4tG9w6Xo0ZVn2ZC7BNwNsM+4KbNG4jxDOLIi88qIJfuVu3VJzPluOPtA8rb6Lc9Mi9SSILZXoAlb9hquzLp88uYZVsIFZxLBOt1NA0haHc/LziGpd8wVru7FV
 wnEdNFHA
 WoGYd2x9K9uYEcHQ3577xN34klp1bXl4i6nY7X+sTkthbQHeKig+gYU80k7lrq9la8arIdkkqgpxXXW0JFmnpqrlEQUXI2Bv9twUXzHDusjBW+iot/8DnNWGC278lqWvCf0EYTxnyIJ3pKXjdbeZQtjnAhDf6VZ5I6T/u295ikWLyqAUewXhvgdkB1/QMZbEW8Xv97qsuJMsG2JR6YFJqzp6QAisgr6EFOIllZfHSVNklux43LTES3BUSKZZEQQwhatGmeHIaSVeCZcZ0VqpTi2h9I1cf6NF5KREFV1YXYt4XFaO6elJDQ7MMm5C7YJm3KzZOQlMcTGFqAKCfhp4hDw8Li4SynaEJxgm0W4LTjSx33NlSNcQoPNfys9cukNyUN2vifW7TU/48+m/ZPSI8BVXQUt9aRadzse1GZWEpw4Xq843VaKeWIl6GtF0Krcc2OB/bfUJR3S0wcAHQsiVlMT8OhQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 12:29=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> In META's fleet, we observed high-level cgroups showing zero file memcg
> stats while their descendants had non-zero values. Investigation using
> drgn revealed that these parent cgroups actually had negative file stats,
> aggregated from their children.
>
> This issue became more frequent after deploying thp-always more widely,
> pointing to a correlation with THP file collapsing. The root cause is
> that collapse_file() assumes old folios and the new THP belong to the
> same node and memcg. When this assumption breaks, stats become skewed.
> The bug affects not just memcg stats but also per-numa stats, and not
> just NR_FILE_PAGES but also NR_SHMEM.
>
> The assumption breaks in scenarios such as:
>
> 1. Small folios allocated on one node while the THP gets allocated on a
>    different node.
>
> 2. A package downloader running in one cgroup populates the page cache,
>    while a job in a different cgroup executes the downloaded binary.
>
> 3. A file shared between processes in different cgroups, where one
>    process faults in the pages and khugepaged (or madvise(COLLAPSE))
>    collapses them on behalf of the other.
>
> Fix the accounting by explicitly incrementing stats for the new THP and
> decrementing stats for the old folios being replaced.
>
> Fixes: f3f0e1d2150b ("khugepaged: add support of collapse for tmpfs/shmem=
 pages")
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/khugepaged.c | 16 +++++++++-------
>  1 file changed, 9 insertions(+), 7 deletions(-)

