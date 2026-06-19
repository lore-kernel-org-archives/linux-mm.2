Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D937CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 23:01:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 115656B0005; Fri, 19 Jun 2026 19:01:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0726B008A; Fri, 19 Jun 2026 19:01:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA566B008C; Fri, 19 Jun 2026 19:01:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BABB66B0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:01:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 109188FBD7
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:01:42 +0000 (UTC)
X-FDA: 84898186044.28.EE25FCC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 29BD0140004
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:01:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMo0FKe+;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781910100;
	b=G/cnVnLHq8UOErhVIf7ELWda7G1hb9CVgnCI8pAQ0h4llZcUlvJfZ/vq2ptkI0yAglkabh
	ygFhq9Z2hQqwtFiUGGEeAYeNO+sV7fQAV4te2kF82nrmUQJmi+tEjDrkX39+yriTjLvflU
	zsCdVL3OmsWk4JVXCKuRasMNbOFex3M=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kMo0FKe+;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781910100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=in7WfQKY0w/TmW5U3tOjq+DnO91z9xA9wO6mimGD5JY=;
	b=VKtzRuu+yF/ndc1qRSmQKwddUyg8xXcnCfQw8fEihVbBLvnu5MMz84dJt+555o43JV5s0/
	XRO/JNKhH8Y8T/Kpdg7rJJSy9tUMzuY3PNtxoAvuL3WROcHYYY4hhOx2fngi6I9YoEgr+R
	BNy7jAT1+x63muMJXOtagvK7mBhs20E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5F194370C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C85FA1F00A3A
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 23:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781910098;
	bh=in7WfQKY0w/TmW5U3tOjq+DnO91z9xA9wO6mimGD5JY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kMo0FKe+qPY96kAbnKRvSEJKBC+xTElUO1hnS1IRFTW65ekX8Qliuhr8ft/PiBKUQ
	 Oel/1r+Hg+nEylIJWzml/f1dhyzl+CmQ00YyXTG4E69S34fcs6zJX6CwnSoxBgnOrM
	 K3iM6k93IBM7FhZtHpS4DyyjlCD3Gf5jWjXxpaIgeAkCGdIvOmXhjEJdMfKsEILjdJ
	 zlbIXZBOOCAr7ZI/ASLqGZSZ9+D27Y4fgGjyTRgjhh2LTqnXVGOvYv78T80e8uVus7
	 h7ihbrwE0GFrsYK2xDcTUglFgHSCDRPqBRYvajLfAk+op5i8ozKen6JQTKBCQMuRoC
	 x3Eg/K3G048+A==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-920f33347f5so87555785a.3
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 16:01:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ9LIl32CluKcgld3Jzop//arsITjGI713M2ZqCaTPw4WUaEJOSNcXI3P+XM262tmQF3C2hzSICTzA==@kvack.org
X-Gm-Message-State: AOJu0Yyi4RGeA6+YQapa/8jM17m9c/H7Vgdfs3sM9M2Cd4YsqjYsCpme
	+dyMLUUvnCMwjdi99njbdHDz5G4ChT1Mkhgy9fY+odrBUtofcEEQqSM++AAj+wXk2xtMHnKaR9M
	Vy8rZcMneVN4lVM0BCzMd667u7gL6oOo=
X-Received: by 2002:a05:620a:4606:b0:914:bf8a:ba81 with SMTP id
 af79cd13be357-920906d5f4emr844101285a.27.1781910098147; Fri, 19 Jun 2026
 16:01:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260618221720.71768-1-baohua@kernel.org> <9a194aa1-487c-4c45-b5db-00ef5190e5c1@kernel.org>
In-Reply-To: <9a194aa1-487c-4c45-b5db-00ef5190e5c1@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 20 Jun 2026 07:01:26 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wk2xHhDiNs2d4uKLHKt-kteWsO4WJpArGYkxV37kFkew@mail.gmail.com>
X-Gm-Features: AVVi8CeeQ4ypTNwQEc0IKybBS_cT-U3DtsN976y3tM5nMZc19BWXCo7ybg6Ffcg
Message-ID: <CAGsJ_4wk2xHhDiNs2d4uKLHKt-kteWsO4WJpArGYkxV37kFkew@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: Avoiding split large folios if swap has no space
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nanzhe Zhao <zhaonanzhe@xiaomi.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j4mdziqxujshiyw1qq81gdahr4txd5uj
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 29BD0140004
X-HE-Tag: 1781910099-624899
X-HE-Meta: U2FsdGVkX19RN20Hnw9PIsyR0VkgXoFbR6vmmXmPPylsU472afAZ6Tt18nkjLYXVjbBjcLwE/QOzaWznPHhw+wMEzSYPOxU4+enkE9LT/Q5QCtVT0K1blg4DSapq2HhpibLm/hGfG0/NaXKoZ/iEaw+jFm5s2p0XNNGF8duD21YZ8pDRdoNOEQmeg8Lsb6Q8O69Xoigj0LLefKnPTr7gBCln8ZtYVrRWIoJW/0ylcB9AGT4AGou9o0Ixj7nHdoF9j8EeR/QcWLl4a4uhxUFcU5g7p4J17arWB+NewgEJrnT4VHI+9elGEdYsEtMYArP/e3Qik1cy0aU3VmR5p8K8tA0usqV7kzeFXODPzYW4cWksqpuR889AD289N0VqsQkVd1U53PmU1as1pslyl8xlpIMzm0xRd9NgdQNHMmspN8pyskKxvdvsF0KIz5D7Kbz+ISELVrypUmfR5BhDuie4UG+hjR1rF4JEpfbJ0lhNz5UXTuRrxbDrZBJFcGeONJqKP93QwIxfhXTjFLKCCFVW2bo1csGNXqIUYES/GpyR5U6bVKFkHPLIZTk/c4Yd8XdNO1oq4RiPsIIalsKnr5c+BMHO7IknVIYWbtLMnmWOo3pJ53Z+kVaGjdKmn3h8iGhAK9Wh25hazAE55xW9S/0IxM2OwPela77iVTFaBUc+YXHq/tEDSspZD+MC1ovY9WCrohFKOie86SxzXTZS0qU/I4cHhnpZ0U8QDjKVkmi19KFy06mwnCt7Bm+Wo4IlS2YVOnsu/Spo2dlMo1uNnIEak7LzsTjT00GESnsbDczfFKB1rHqc2bU9Kxata6jt9ReexDuTV+TvaHTE32pjQX8qLHDSSmvg91D8WlZoDHNdnU05N9t+ls4CNfNIScPG5Jd8k6wqNmbbRzEhta+tIau6toD2fRuDEWo29IJwPJDdJq5OzyMtCLaqiJKb7egtYNnP+xW7fSXBbRUBv/yzljz
 6ZegjGAB
 JM+20WXZ+brHqsxPrQwuYfftd3FB09vz/hWG4ahPy54Xlw0AtBQFDukcna69KeQBW6+rY3Rpa2k6vBrJjbU7c0a5YYSrHrmnK7wqiWzdIwB6dOHwgR/bodKky4SWGBSZCXZ3/t78kUnz94dbQNcuUWHet5czKcYTuiFah1UM+6M7Suw3ZmvQWFI9f2oF4cPCVnzMa4+HLHcLTJyIXP9MKSsC+48ub5SzUH2IU9v6gIHocNiLKDHNDsH2eQ9zWvR0EdaIKPI5HlnM0WHrqeAA6C3t7Au5p83jDqzIXi6Jo5t7zLYE1YTKBnH+CvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 10:02=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 6/19/26 00:17, Barry Song (Xiaomi) wrote:
> > When swap is disabled or exhausted, swap slot allocation
> > may fail during swapout, causing large folios to be split
> > into small folios. The splitting is reasonable when we
> > truly fail to obtain contiguous swap slots, but it is
> > pointless in the no-space case.
> >
> > A simple way to reproduce this is to invoke MADV_PAGEOUT on
> > a system with mTHP enabled but without swap configured.
>
> Would we ever run into that code without MADV_PAGEOUT, or is that a
> MADV_PAGEOUT-special thing?
>
> I recall that can_reclaim_anon_pages() would make vmscan skip such code, =
but
> it's tricky.

I guess there could also be cases such as
get_nr_swap_pages() =3D=3D 1 while folio_nr_pages() > 1,
for example, where can_reclaim_anon_pages() cannot help.

Best Regards
Barry

