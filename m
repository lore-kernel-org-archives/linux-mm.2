Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D83AC5AD05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 23:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F08D26B00B8; Fri,  7 Aug 2026 19:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9B76B00B9; Fri,  7 Aug 2026 19:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCFD66B00BA; Fri,  7 Aug 2026 19:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A94686B00B8
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 19:24:19 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D483980258
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:24:18 +0000 (UTC)
X-FDA: 85076054196.10.D700E19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id EF993C0009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:24:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bW1nRoUZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786145057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olMPjnRP79g9pK0k/LaANk0plHKsEj43HVsO0fZpKy8=;
	b=jdwkNEEtXmj54VTZ3O8yvSuLSTwsxxY00A3rOumzkhhj2RRuyMdw5DIjABbpmYbAx7p9//
	zbFRi4g7zJRcSKpiV9rSq92nU5ohQ7wU6KX076WwyRfb9k03QShKLhor65FlNjhjTgz36b
	vNgKWkLQP5Ev5fw5DIz5pLs3/BKKJ9Q=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bW1nRoUZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786145057;
	b=5/XQopt3U3//mhFv7liQyqj9hrgHJ6bZttbEaFCBwQ7FboLXu37U3ZVbZrGkDaWJB9rf50
	Tu97uT2T+D2Zj9/BU5kNhggO949YBOOxI9sLRVdygxOjdtBwAyoirNEDYWIBqVdaQZrRdm
	ph7+uvda74pQgLxHD0eDUOKSNcloUHg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8DC1160054
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 478321F00A3A
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 23:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786145055;
	bh=olMPjnRP79g9pK0k/LaANk0plHKsEj43HVsO0fZpKy8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bW1nRoUZ4Nqa0gaaExwXNNLFMszt80t48rv/8pjtLhVy4VZjTxoIVUPQi9U33TRWk
	 yYVMwo0nd6iByF/TdWFv0lqC2ZMW10TQLvMa4cEq3KnBPLUKaSqz6Xt2yOMV7IXfkX
	 4XKrbh7lLgnCGhN9HxkyDgkSD2DkTm2okvf37Wlr3lHAGK2yt83aqyXvaBDnVGjPmL
	 8lenNkr5kBl3mCk7BE3+mNthg8zFLZjB+pChU6Nfcwy15vBov+0LZAOo9mWvyAillf
	 xStzYlcq6rfJoRqrHX4G/xWUHBUjvmc9WtppdLj4AD7TvJoL8xlDbS6rxmsvkSRTnt
	 +Qcyf+ZHWZMQg==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-934974844ffso5817785a.0
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 16:24:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqD7YlUhPD4ImjECEHftOmoIjogCY1/TMdV+lfChqvYfn9Ia/dL5h9ZCPLh3WS75rLtBW6JszZg2Q==@kvack.org
X-Gm-Message-State: AOJu0YwuLVLGk9gkIHEaYcMohhT0ICR6U6gM4P5kSIBsE2AISfVhvgiw
	AtMhrElHb1Ao+nTtUqdlggveNMzzEG8ioxEOHdugcNi8gRbeFF5zPar7Sxek4N83kDVIxb9cO3C
	zN5XUDPQFq/xhlim49/ufGPPXpdKBe0M=
X-Received: by 2002:a05:620a:2620:b0:915:b852:4361 with SMTP id
 af79cd13be357-9367979c776mr449492985a.20.1786145054699; Fri, 07 Aug 2026
 16:24:14 -0700 (PDT)
MIME-Version: 1.0
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-4-xueyuan.chen21@gmail.com> <ee89226e-64b3-48e6-9be2-4934c23b729f@kernel.org>
In-Reply-To: <ee89226e-64b3-48e6-9be2-4934c23b729f@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Sat, 8 Aug 2026 07:24:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4ykCQWuYyAxOWk5thUOZpCAcGb+W_uCq4KVAFffo2Cn4Q@mail.gmail.com>
X-Gm-Features: AUfX_mzqI4seBIKJEvk6MKVPwksdfmT-CUfAVDeDPy-xD6vYQyx7NLbgiH7dTzU
Message-ID: <CAGsJ_4ykCQWuYyAxOWk5thUOZpCAcGb+W_uCq4KVAFffo2Cn4Q@mail.gmail.com>
Subject: Re: [RFC PATCH v5 3/4] mm/vmscan: avoid pointless large folio splits
 without swap
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, youngjun.park@lge.com, baolin.wang@linux.alibaba.com, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EF993C0009
X-Stat-Signature: spiwkbytfuo99o9zrzn67t8omjgugeiw
X-Rspam-User: 
X-HE-Tag: 1786145056-729247
X-HE-Meta: U2FsdGVkX19VCL1TimIRfIOKA3x+PRFr4acBGIGJOXhXK9eV+GmSYQI/rX/bO89PxUtyhlTTqaSrVDdjwN5vhzWsfMmnRoq7KyWEmROtjDqB2TvE+54OTrhT2DkrOIV9DDS12E2ts+H+3DeDJXm4BEz98cbAotJ3Gt+XtcbiPWrB51RDM8TuA40jj+rmU0l1hkIAq6tn2TECEs0z6WiLXx+35fmkBNhDNNDvADAMpw2F2zNLVr+JSY+6moAoSTh0bhSCx4b+gpWJh/TKG9U0NFTFSBXrIWIuCNxQtDRxZ/sdLrsJGE5YQmxzjKgiLIbIAf+Gz0KnyV1KiaJ7sWnFN1IFSMtj9dUCimye2M5tWoXe5vt7VpjbNjRYP4cQj7C23MyJFVSpi2Iim87U8nZ1s1QXjRIkIFPMGV7+OVgJcs54CrFO9U4X099l30WWMIUfN//TrfTuMQW+HAGBA+HWuDGAw3XGCBqq+Zo3O/OKRcOC37EkoeuW/MgqTthUAJ5W8k2/aEBLSysI3Uuadv8U89wV6xmHqDUDkcpq/6FyftaWacmStyo7oENPP0NNR+MwrKX3nzq8eukfCTPIuLZ/mwj1E5XbwnfdgrJvjX0XGWSWrPMKDjTRK3U/nYAjjZmaMxoOHeMARv+cMJD5XrwS9yJMsmcS3s5cSl9vOTYAFjxAgRuBf77+s7DbR/AxuNa7ornE5MRk27Tt4G6ZR8/Z52Lcjchrr11Zx4lxnOrVBvyojkPhVrGGZ193LqrGycg6/9Kn2tKmXlm6fU3CEAKp36t+ZOkYKfHLVfhIxeISv3PHFIEfO4/l/E6pEreDK1n5Yqy8WlVbdEwA9YO7DBz/XbQblf4HKdvV2Xtp3Rx44cj6kcz3JAuuHH3Gap5j5oSi9Nz0VqOhmfDE4bQ8ELT2KLB9gxpKv4W/5ri9Wbp9+Wzfdp5cKQiWeEiitiwqS7rggkTyixGGmYzRw42+YHj
 r82ouTtM
 4hon5sha6ql8LavGY/DCGpb1z6c4qTZmaw5kCnnsdh1kiTRDzluezGbFNLNm5KBHm7oPa0l06uvyyKeHvnt5NkL1eGm0OqrazUZVG5NRxaLRefOclXG+jraYpN5auMvZ35hrXQ6NiMNd2x64vqQYfrNvF0trXtmfTnx0bOkEHN/203RL8fm9wCahruZPpVxUq0/XALHUWABi47nwn6U21YVoyjZTnqUkOlPGHxOajJLxEphgL/hc5/W8GbjApysIVhLaPpwwqzwMWyWlytsZi7pAqP3VKnhM5QdFz456A1phFZM7XHiloHXNDslZ2+xUNC9SjDDkPDf/nYjwY4JjTmhCx2H/5lmP9NiADtl7/OmYFNAnDZaDUAMHFSVvklkiv+rWbxFPSTd94B7J1Iek4YhSrqA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 6, 2026 at 9:58=E2=80=AFPM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 7/30/26 14:23, Xueyuan Chen wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > When swap is disabled, exhausted, or unavailable due to memcg swap
> > limits, splitting a large anonymous folio cannot make swapout progress.
> > The fallback only destroys the large folio and inflates split statistic=
s.
> >
> > Use -E2BIG from folio_alloc_swap() as the explicit signal that splittin=
g
> > the folio might allow swapout of smaller pieces. For other allocation
> > failures, keep the existing activation path and avoid the split.
> >
> > This preserves the split fallback for fragmented or partially available
> > swap, while avoiding it when there is no backing space for any part of =
the
> > folio.
> >
> > Reported-by: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
>
> Do you have a link to the report?

No. Nanzhe mentioned that to me verbally.

>
> I assume this is not Fixes-worthy.
>
[...]
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
> --
> Cheers,
>
> David

