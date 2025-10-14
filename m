Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A08ECCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:42:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1FF8E00D0; Tue, 14 Oct 2025 16:42:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A2608E0090; Tue, 14 Oct 2025 16:42:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791478E00D0; Tue, 14 Oct 2025 16:42:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5BC658E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:42:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC03D13C0B9
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:42:51 +0000 (UTC)
X-FDA: 83997893742.29.F53F123
Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	by imf13.hostedemail.com (Postfix) with ESMTP id DA9592000B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:42:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gchiJakK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760474569; a=rsa-sha256;
	cv=none;
	b=f5iW6QeZbZRHEapJ6s8P15x3lV5XPZcJ1KLIff61za6Pl2L9kQEKwkUfaGfBipAvnjjiRX
	6ZV4nC+DnsENoltpleEBU2NrqxtUWZo1jw05OaU9QmrRfKQiVo9kR/VlSa7NUQTTlJwc7i
	2OIQj+20w9r3bSrpQPEo+bup2FTCEno=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gchiJakK;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.217.54 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760474569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uockn1DmFA8ZAnlkgMjydfkJvdgnzoAnn5KXsE8LaOc=;
	b=Wi4Rb89uOzW0YWYWdhxUx2W9kMh7KCW1NDk7kE1R+x7sncf6EpMU0CljIDg1PHk+eUlRtc
	zub/kC0dbXqzQkgo0AI/TA6IhRePH7fOGz3aE5d5qxQpfbZQ5S4/A1VLESulNAQoEcmwHn
	03ROiNBrps1P9GOGKVufwFBohBAUycE=
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-5997f407c85so2056678137.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760474569; x=1761079369; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uockn1DmFA8ZAnlkgMjydfkJvdgnzoAnn5KXsE8LaOc=;
        b=gchiJakKPU8GyQNspM/EYMpvdTw2c0Nii1pApIOLTeqQlkoJEMoN9DDzGon1rS8x/Y
         lTk2u62HwqXqAK22a7G8sq8CeEXKWbynOGQu2rNe9Ttecip3Jy9DI/1CzJJnTRB32AhF
         1PBGUOL5S5LsZe5DSNVdjs6pPRh3aPvEVmNTlyqfgA+7nSG8ART0gNuk8huA9aIzqdpj
         Xjie+zosGNpWlfwzVV8vbMRGTw5lpm1Ko44l8DYE0v8ikEThLnINjI9BVGvJ1AfVGNt/
         f8on+uyhUq4Fu7lEJTbKNZjlwgQVuNr+a9yS2s4KQTYE1sr5Me4D+K9jIYiudDk9qIrs
         l/FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760474569; x=1761079369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uockn1DmFA8ZAnlkgMjydfkJvdgnzoAnn5KXsE8LaOc=;
        b=S50hepiGogKgidITRxwfG9/zGs6mExjmU+WEarayGVhxL2RvcdEGu6T8pGPtSu62HA
         n4CKEpPYcyTayX8oDcw+2sSad2C5KN0wjoiodk/2DdrSS6V30J7BP4yJdMgcGKEO2g6L
         McBaxb9P+zLAFgsCAqM1IsSUIPiPV3Jc5My8RGGjkQzX+dkXfOOntDA9HsrQh+ta4PXm
         58ZD7XqnFDClW/hQ+u/GFaCR5OqcN6VTr+45AFbb5HQNQ/rfkc7j6IGFc9e2arMg5nuy
         7V036mEuDGDGMvFBagwZjgtXc53V35p9u4j8oib545ZEkChlToVnrFVILkkqJb85hUAc
         0FzQ==
X-Forwarded-Encrypted: i=1; AJvYcCW2DHRGN7hCgBWCHgM6gDFewctO5QysfKau9psX+OxJWhrfKpFOWM0s00SeVz0cHk1t9EYPygYPWw==@kvack.org
X-Gm-Message-State: AOJu0YwHiwCNuXKyswSyu2IazWsWpIx7DMGRdA6+yZDpOc800vAu7Scl
	qB6WF9qe+DeXPr75QJ4RchBUsZ+6odjSFs7bmskZ9pqMhdOEXqiipADqUwkvK0H1VItAtE8zK6G
	44gitUmOkYwtcUNlYpu21fUr0fHnNq24=
X-Gm-Gg: ASbGncvvk1bt8A9jaIyNXA2hyrPXoCV+CFZaQ3/EPmZKZAdwR+6dmuJoP/7wlwu9H45
	nim2XhQ1q0eqthttRMdlUv1rV1RNZNkqueqssrdK7EhKuXN1HzR1GyWQLfZ2BUYk1MYU8i2uO5c
	dKWrD0KI4BsHNBDtBTvp4c25fQHaKTHu6we0N4G5qMBKaB4puRQbasxKTY4Lkk9z9kxgrg9FsZ1
	ea6LCVx8DQTHkoJ8kqx5ABzMPx2hnIupwpBAeDWPc5p7QddPUelgLaOUtyxXWWoXCsA
X-Google-Smtp-Source: AGHT+IEnsr51HAAycnl5TJWtojVCtdeDbTLi5HrOIWN/EM0aj7tT4qSjlzWUR1EkpvLjmCuZMzthdHU4KSmPdfVDcS0=
X-Received: by 2002:a05:6102:1516:b0:5d5:f6ae:38d5 with SMTP id
 ada2fe7eead31-5d5f6ae3b8bmr6904190137.42.1760474568697; Tue, 14 Oct 2025
 13:42:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250909065349.574894-1-liulei.rjpt@vivo.com> <CAMgjq7Ca6zOozixPot3j5FP_6A8h=DFc7yjHKp2Lg+qu7gNwMA@mail.gmail.com>
 <CAGsJ_4xiTteQECtUNBo+eC9uu8R3CgVT2rpvGCGdFqc3psSnWQ@mail.gmail.com> <fe38e328-5e64-44b2-9e62-f764c4b307bd@vivo.com>
In-Reply-To: <fe38e328-5e64-44b2-9e62-f764c4b307bd@vivo.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 15 Oct 2025 04:42:36 +0800
X-Gm-Features: AS18NWDkw8474qAcz1fNrydjfJ00yxfFAbDaJ_VQwKfXsjjmOArAdgWL5vP-vUY
Message-ID: <CAGsJ_4xdvGjZ9YZnc0mk3bDfPCwxdpF_5bhcbca09j=-KBM9Mg@mail.gmail.com>
Subject: Re: [PATCH v0 0/2] mm: swap: Gather swap entries and batch async release
To: Lei Liu <liulei.rjpt@vivo.com>
Cc: Kairui Song <ryncsn@gmail.com>, Michal Hocko <mhocko@suse.com>, 
	David Rientjes <rientjes@google.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Chen Yu <yu.c.chen@intel.com>, 
	Hao Jia <jiahao1@lixiang.com>, "Kirill A. Shutemov" <kas@kernel.org>, 
	Usama Arif <usamaarif642@gmail.com>, Oleg Nesterov <oleg@redhat.com>, 
	Christian Brauner <brauner@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrii Nakryiko <andrii@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Fushuai Wang <wangfushuai@baidu.com>, 
	"open list:MEMORY MANAGEMENT - OOM KILLER" <linux-mm@kvack.org>, open list <linux-kernel@vger.kernel.org>, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA9592000B
X-Stat-Signature: no37nzf4pm5ww498q1tn3q11azsn8i8y
X-HE-Tag: 1760474569-768693
X-HE-Meta: U2FsdGVkX1+z4zlLouJBZMBF2J3icau8nz/VRH1mzIF58BmSeSAGgWVnJqtup7jCF9nibrkAvwnARiEc4qqtqD5uBrEFl8Km22ejvH0xiW1MWKnKg/qEFoa9aF9Wiy5pNV3Z64pk1aY13KGMy2/Jb3dHIkKvpqDpZzSMaPsy+wmhRPgAghOSauG7r27wDQWpBcdtmDL9JvIs9f6dLI+nua8/guNgDktf/41MU4doG7lBTGmpBUXbefzIS/8JpQ8E33RbvP5LvEGudWvoqNlRsvo5P+BcewdS1ykPncKR1X5M3EOLPY/RNDICiBzsHuCjw/waqfv7hN2vnFcPrzH1vfpmPjQg854XkxBJ+/gWb3Sl0vUayIaTJ/UmiRVj4X2H9S5shyaLk8Khk6gNRYx++sjvixUG5c3PQVN/lrjyh4ZTKrSZztgF7jrs9A+fPMTqIfscHF3zwULdv9Wp00ovWYU/4QkrCuWxfpb/yvxDwGHJpN7AU6CI4HDp0CPHk3MI3DlQjR/hrqz3FLQkyNdRjAiJANQzrtxqswKs+ToSUJzpbRpwHQiXdka9CvKtUw7hj/DtJfnfH5/sr+UibN2IEatTZn2+sXNDeUpeaF+W74lo2OfB9ctAwVOCnBOB8xR+BUbrfqEuOfDPIE707FktJ+27W+Fz78/5nupH38HWRm18sCeNlkD+ls1sZ07lXRdrfo78rQ7F/IIXS3NXB0eY0l/RZ/B9/oxq7fYCcbHWlL5/1hVQjtz608olvjbdAVB5e86vhDFayiCBpAnrcoIyEPtdugfVuSzp1p1okQ4EMCFzn5v/gSU0+FFmcJDh0AxU1IhFxq1ANV/zl6vBQnGl8+KTZtQS1xA9GxguX7zrqfIXgqJXA0prFrgQXCUPImtGb9bZyqBKuXaIeHR2wDDH7M3w/acBuqSS5wqPFnpN7FVGzV6LfzffKmVe4fjFU6rcku9vuK5klXZ94dmicsJ
 UnH1sft2
 2ywzK3KuPhnrZTfhJJrCsak3+TGP5B7Rc+7xrnI4tLFSJqSfylWb+jx40uVG5ojNzy03Od81Ab4d9TTwTyym7kOjoG884PDMf1VOyMTz2eLDbbpxWeQw3qxG+9SmKg1Gxu8nBXljLoosBefAEmnEcJvvsS45PmxAgecBzbofMIkj/Grh3qZ9FajkYzNWlb12VSlIVEOCwch0y1dnXRj4UbidhrnAFEgam3/Mr5DMLa8+vkRDlHSIljdaIT8i0PlfM4nbhZavffA8V/oJdfoXHa5nEglGWHgXj6AdMtdn/oL/jVSwMG6udgjqJ+SmBOzTIj962+Omf7VcKG3Px/XSi8Nc0qm3/gpAmwkDFfuIO2F/6xxo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>
> Hi Barry
>
> Thank you for your question. Here is the issue we are encountering:
>
> Flame graph of time distribution for douyin process exit (~400MB swapped)=
:
> do_notify_resume         3.89%
> get_signal               3.89%
> do_signal_exit           3.88%
> do_exit                  3.88%
> mmput                    3.22%
> exit_mmap                3.22%
> unmap_vmas               3.08%
> unmap_page_range         3.07%
> free_swap_and_cache_nr   1.31%****
> swap_entry_range_free    1.17%****
> zram_slot_free_notify    1.11%****

If 1.11/1.31, or 85% of free_swap_and_cache_nr, comes from zram_free,
it=E2=80=99s clear that the swap/mm core is not the right place for this op=
timization.

As it involves too much complexity=E2=80=94for example, synchronization bet=
ween
swapoff and your new threads.

> zram_free_hw_entry_dc    0.43%
> free_zspage[zsmalloc]    0.09%

Thanks
Barry

