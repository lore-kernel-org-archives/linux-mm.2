Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 766A7C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 08:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275C16B008C; Mon, 28 Sep 2026 04:03:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24D7E6B0092; Mon, 28 Sep 2026 04:03:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A7C6B0093; Mon, 28 Sep 2026 04:03:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBCF46B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 04:03:25 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66603C0119
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:03:25 +0000 (UTC)
X-FDA: 85262431170.17.68B95A8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8C72D20004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:03:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kiLKu/n2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790582603;
	b=Nn57YHl7apGx6YTvC1yz6Wb1mRJX3fh2G2L8UhCY45Pbtk4P4Euw7HlTBHOP46cxak0f9P
	+7PVlRcW7fPCrjGMVeApvXhnOY+fyTYiRPv1H1nLwKuBWxEdjvf7Kq7z3uyybDT8h5Zavh
	K9V1vhhB/5Il9TWT5w5SdPbMJ5suiwQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="kiLKu/n2";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790582603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uLtk5iYtDPMtIjf5WTw5JxqxgyZJ3TAaIpJ0Mr6L5tk=;
	b=NiznlNL3yOzdXXskn4HS5DrNGqVSl0KSPKds4jag5Pq7sg3ZY1c+2IpeAxJkkmPnfUoaqT
	4hh/sGn3WgDFfCuh0JueW+kqke7p9eP7DLXDpUh+6n7tsteBxQlfeKuegt7eLBnfDpQShQ
	Ghx/Mub9Hh5k06mWi4espZvzWgxni0E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C9626025A
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:03:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C160B1F0089F
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 08:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790582602;
	bh=uLtk5iYtDPMtIjf5WTw5JxqxgyZJ3TAaIpJ0Mr6L5tk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kiLKu/n2P9LKVxauyh78A62Apzf18L164SCB+JFa4nsaAUf+aQJ1FcBfxROio1Clg
	 QoaLgcPH30j6Je61dwa8YwhsSwIs2NPoZtThsfcPZNUhPe7SHvCsNjQM/aq485mpzj
	 Ein3QGww/zTl6PUYojYsUsRqUJeTw5dvqzlhGfzaG8+mPuHPwKlw8UDP5FlOCWzIJ5
	 Gb7sBn7SIJEvuPaWkiBhpxHspoQ3iJb0QD8yJY9EtesZNfj4vqwiC+QVYSd0kplQaS
	 Q6RdnGv294OUs1dZ0NDP3fOibhYgDrH/eqNOZuDJEcmz18mIzyXJeKDcT6rkqsaPGE
	 VmyzhcL44fLaA==
Received: by mail-qk2-f22.google.com with SMTP id af79cd13be357-93bef17c191so245355685a.2
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:03:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx6uwGQEElfPOb7Gj5ZZPv+Ypk1NefombO3UgPB+SUhXP72zDmzD3Y+XFF0lV3ubCvdeW73WmwQuA==@kvack.org
X-Gm-Message-State: AFuF++nkeEePpdZeaiY/YMc0D3HVXSJ6NkWmCuIf/yu2tx0CTU/z0VB0
	QrD4Ot0ZysckXmMwn+EGPnMZ0T2P/3mdaGTRWugpwUYVW1kkPsn2sQIRkn9AvA0dq+QCsz15pXe
	Ze62X374bwmd7eZvVYNTjjWaeqJFR1G8=
X-Received: by 2002:a05:620a:690d:b0:93b:eb9a:ca47 with SMTP id
 af79cd13be357-93c43cb6afbmr1943937785a.31.1790582602049; Mon, 28 Sep 2026
 01:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
 <20260920162014.4479-1-lance.yang@linux.dev> <e22eb6f7-7eb4-4f50-af2b-13a2e3952cac@kernel.org>
 <CAJnrk1Zk_4awd5OfbvsCLts1YPsB6JjjOF2hiSmg-wAp+_KUDw@mail.gmail.com>
 <00d07f4a-f679-486f-9413-6917b5213854@kernel.org> <CAJnrk1bD+4tndrOWuSENvEb7ody47HL2aNv2n+RzUqDE8mpkrQ@mail.gmail.com>
In-Reply-To: <CAJnrk1bD+4tndrOWuSENvEb7ody47HL2aNv2n+RzUqDE8mpkrQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 28 Sep 2026 16:03:09 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xWC4hg_-MLoDn3Zav7NUM709gu1jPeQpRuODdt8OUpZQ@mail.gmail.com>
X-Gm-Features: AclHuK9L9DVPffHQzXWLpUjv_VnN92J2qaEuVoIHuFVp342S5196rZaalz-1W7c
Message-ID: <CAGsJ_4xWC4hg_-MLoDn3Zav7NUM709gu1jPeQpRuODdt8OUpZQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: Joanne Koong <joannelkoong@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, 
	ljs@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, willy@infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: uuwif3yfxa8w4sf48s9x379zkrgcifja
X-Rspam-User: 
X-Rspamd-Queue-Id: 8C72D20004
X-HE-Tag: 1790582603-618633
X-HE-Meta: U2FsdGVkX19CcRnucqcO+GfCU0YJUteV8f0z6HJ1D3Vmf/wBrk0gNWpehgkMBj1IP4HJFXBXtDkDCBURtyJYMHKwKl+F8Mxl986gzP/O6vuIFtDn6ZkSFUfXRXNY9Rb/agqMs+bdzN8Mx3VJd+1Xq09AiU/fBjGoQVFODs1xGKjPR3EowvGq6eB3SsQ5tYHGJ/e770xHEi8SVITOPGh72EgNeMVOiJzs8Mz8fcVBtiSSVFpTdPDFQRe+mRCR5MpgSr/MEOmJqOEcHkczmpg8iBsfWZDuXXkmzX6CArIB1IHqk06FJIiyOE+5DoGV5fIHtg7oDrFgZsdWMzcHz7TRBoimpBxIdxp2b5ga8BtyQhK+lGrlEVqmngwbGoIfo9zycaP/yKzAPgndaSaznQ/ENdldknVb/0HSILOp90+Sl6gu82IpRHzVMq7NTFKjhw/NI5HnI04++G6SxQmJpmxZz1ervFQhR8WUK0nCeVpogm+zv3Kj2gO8D8yduAnkX1m8lB5mfRUp4s2U43OTiWfj4NI7Qo535tWLO6fZrzfnHJPumuNxigq7vX3AdStH2RHBfz54fK4ogu24rki/VWc3MODvsNMyH/9z4HRVJB9bOAv0ohmcnUFeoW/DfPiOWiVe8goy5jsLNgAr2Ns8ReA7QU2EIDPRiEVmqltrDgHiMgJZWG2GuWxun4RTt8Pf2S33FBTTc/pdqmTfaEgjGliZRpr6cR3Vg7/XjDxY8si48bkfu4VEXKQCPMSJJZykYbcRgnHHhBPLFATNLyVe0gWK0NGGXjr2zjGc/xGkkx71VejYSOVv6mjEV8p2cXUsVrL6FanfZMvrXHxMJ1Q2ZxvqHTVf4XAg48zZaLDUCR+QYUSc4sEDKGDDA3WMfLiUY6JXjGTEaNUm5TjzRNZt/I3epYH9YqbNw6Uy6mnhy8xmpvsDVBA533in8QZgEaObWaXUQ3H5maeq5TQSi4bzpC/
 tgdECAMC
 YMPP6q7bZRt+NC/GnQaSgS2qDyVjHj9FPsS9UtWu9q9yinEDWaCq5PI4fBQbbK5EQ68rhtpozLD9VMcmsRctCHxpGk0Erk3tuuS1TSYNe6E0OUJ3zwUjXY84NBf0Sue1IEGMOj7g78zkoF+cpgkJAS5gageVMVw+1jrRaANOrd/iwdeFbpILc8wo4hZo4Bgv2lG8XulTPIrK8j9FuWy+BiME25iOKuR7MaLs+FxkCrg62eXA6GlCNOKWBsdUO/klw/FRCrynPrtJlPdrxYhEho/RyYd9pcQbpLhLdup0SUiDUxa90sFjX4UBIBOGH+bBHpaekjQROUDp80G8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 7:47=E2=80=AFAM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
[...]
>
> Based off the benchmark results in [1] and [2], I think the cutoff
> needs to be at 64k where we exclude anything under that. On 4k base
> pages, this is order 4, but on 64k base pages, order 4 would mean 1M,
> which I think would be overly conservative. I think it makes more
> sense to express it as an absolute threshold value instead of by
> order. I'll try to find an arm64 machine to double-check this on.

Hi Joanne,

I once recommended a hard-coded value such as 2 MB[1]. Would that work?

Maybe 1 MB or 512 KB would also be fine. I=E2=80=99m still worried that 64 =
KB
is too small, especially on machines with 64 KB or 16 KB page sizes.

Also, we could have more contention between lru_lock and the deferred
split lock, since, as you mentioned, folio_unqueue_deferred_split()
is called under lru_lock in many cases.

smaller folio sizes make mTHP collapse and the underused shrinker
more likely to ping-pong?

Just my two cents. I'd also like to hear what David thinks.

[1] https://lore.kernel.org/linux-mm/CAGsJ_4x86EYsMz_n2NKDwTqeiv2pi4AcZb1Ru=
ZoBeUBR1iFqOA@mail.gmail.com/

Best Regards
Barry

