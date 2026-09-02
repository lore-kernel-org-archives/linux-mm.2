Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAADCC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:52:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B646B009B; Wed,  2 Sep 2026 04:52:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4BDD6B009F; Wed,  2 Sep 2026 04:52:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14356B00A3; Wed,  2 Sep 2026 04:52:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8C7456B009B
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:52:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1F02C0115
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:52:47 +0000 (UTC)
X-FDA: 85168206774.13.EE1D3E6
Received: from mta0.migadu.com (out-195.mta0.migadu.com [91.218.175.195])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5315E40006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:52:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C8erkTWr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788339166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xDVzMeg650MunH9/kpFZMjCl6QAJ9c1jDh4WC3/q5t8=;
	b=x6M2/z0QLXCIn6m9lr9L7gez1HfCwXTK8pfT9mH5H/CE+wWzgvGt4WyD1A+dpuFPb3ECBg
	7nubxTTteCgPVh5l0v9K3nsFd4j3a88HRGMeVfPhVo6yV2mhsng/3iOdTv4YtQT4fnhO6g
	GtvL64VelLJ++Wc7KokUcImoiiti51M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C8erkTWr;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.195 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788339166;
	b=MND7Hdyye9Z/fwX/XZCoUM+qFMaxoRFZSEAYBZt9Q5RNOoOI2utyI1HT7ForJqQuEnSbsD
	CpCY734dscDPJgbGRaj2zvMZZbPtLFuIqWP3tRz87ZFtoyCcCOrBxlwbQenTBlbasz+W6Q
	Ye8fZ0Y5OvP0HoHCF8+CHqJ1yZOfAhY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xDVzMeg650MunH9/kpFZMjCl6QAJ9c1jDh4WC3/q5t8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788339161; v=1; x=1788943961;
 b=C8erkTWrVaAmiyQ5xUjlXdZ+1BgyEimKZ4jqeLEuc5iK/hPhO07eF8+kmp2JuwY/VFTeO5KH
 9KXWg4cSXp4ko5fbbtdHAu5PIdSbn46ZrgJuYHeM60DjLP96bTJ4uXEO9wRywTs7wLrsU0O6+8W
 va5KTqtV9YdHg2SaucB7/6Ko=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8c8624c68a37385f;
	Wed, 02 Sep 2026 08:52:40 +0000
X-Mizu-Trace-ID: 8c8624c68a37385f
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] mm: hugetlb: Return -ENOSPC on memcg charge failure
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-1-e3e8942c141b@google.com>
Date: Wed, 2 Sep 2026 16:52:20 +0800
Cc: Alex Shi <alexs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Dongliang Mu <dzm91@hust.edu.cn>,
 Hongxiang Lou <louhongxiang@huawei.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Jonathan Corbet <corbet@lwn.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>,
 Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Shuah Khan <skhan@linuxfoundation.org>,
 jthoughton@google.com,
 fvdl@google.com,
 rientjes@google.com,
 vannapurve@google.com,
 Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Wupeng Ma <mawupeng1@huawei.com>,
 Yanteng Si <si.yanteng@linux.dev>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 stable@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8C2135DF-25DF-4D88-B2A5-B5F7440E84E4@linux.dev>
References: <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-0-e3e8942c141b@google.com>
 <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-1-e3e8942c141b@google.com>
To: ackerleytng@google.com
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5315E40006
X-Stat-Signature: oet134tdugdcbfpgzidq8zbk1ww4511w
X-Rspam-User: 
X-HE-Tag: 1788339164-680820
X-HE-Meta: U2FsdGVkX1/Q+2Vvbb9MI8arsWPsQuF4JfbwhQTWHemMAQq9FkTvMk9g0IgrkTYwVMQEYZOcKJpr6mAbVQtSI/zDlAzUy69TNSZeqhGrN2WFkctWtTp2zdqzyLLQ+62zrtjEKLctXT24AdTPpdbIZIvBk+dDnSpGg0zl9Gi9n3oeql8q6CBffiPMPleTNsZ4up3RSKmppZtkMvSME/x4/+ubc9+R3wCkVZPNo0dqaIDcONyAKugl9VcxiieVIxTmJt1O62r39avoXRcThQp3lvgTnlIB4NlsQBE+tMikI7w82UnDnztKaWHMxrUQ4y/fL3XKm1UKdbOrmrWvgzSkxtBXMkNPvi9l8NjT0Xw7BgxeGXB/yCTLvJBEOyE9Oi3S12eXDZd21CH2wx3of31rcXkEPSCqq108vRq3XRYy5bWusiSVdvDfRllT88iuzkpTcT29bZPh96Y3LHNjhYvgYvJeTfEz3Q+GxUhY64wLLuz6ntPQMVVvjgcs8ICA53Wlf+x2NkWwssVgn8p+n1ZyVLxycvKhLzJ53KvGI0F2Z73+jeTf8hyuYdaQ5R97KVUkdhB6hVEkeFNZCO9CdXoTymBhwhcNu1qEt433KDGXoAkF3VHgQL22Nt4AhuXjQ0VoYSeBNm4g4fd+VU3PDBRI+jwe1vyIikrMtUCaq3iJxu3hkO/rIXweyjWK0MuSAjdZs2aJuZ9KEzdsjqZjniJ8ZHC6AZZ3udzYgmhtEOukECa4V/yV+mKdvrlnw486thOeJwmS2N6t6qrr2QwKGfQiT8L1/dcZ9zIT1FCEGLue70iIR7vBWy2+DlOd9w4jliOj1PjJi5Hxq8BRJG5eM2dMYoOMn2OVo4IbBxCPbX5ALraiYIAVGHW9mH+HGHXer4EReO11I1jU3Gwk1h9ozD81bDeOaqVn0P9gk6jPmUDrL9DPksbu/M+Ycx3sZVkjQ/HoST3QxP1Yn2cVEdJxJXf
 kuLL+kNm
 r0xbUDh2P2Dov4spe3vLQzm6Zg+9gDnxNBwTgnPyoh1GTaFJtchi/C7zu/WNFTjixLu4VtIHTZR23qR6dh0m7+JkmYTiCp5krp4wap6duOVja9N8V9PjlyNOIERF34Pu9fhnBHZrIgjVZXLY+PWnQrWMsEbFxUW1rAgWLVwz7TLFLlc4nV7AcDsksSPn5KLWmvES0mdq4xdgHFadXgYy+820thNLFA8RJXFMKFJhiMSzPOL/R8R6Bb+VrNYrE9rsnpCPWLLcIdlsNiXEa9exA7xnOy4xYuvsTlTuTyH2i9OtNsBXw14YL8S3v2YuuW1836v1oV1qMVTM2RhUQtKDCDixuy91X3/iqnQfocnvL8A4iZuYyOZKTbIZBGqoOe79rsGvCi/8nyAelGqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 2, 2026, at 16:22, Ackerley Tng via B4 Relay =
<devnull+ackerleytng.google.com@kernel.org> wrote:
>=20
> From: Ackerley Tng <ackerleytng@google.com>
>=20
> When mem_cgroup_charge_hugetlb() fails with -ENOMEM, =
alloc_hugetlb_folio()
> currently propagates this error. This results in the page fault =
handler
> returning VM_FAULT_OOM.
>=20
> Because HugeTLB allocations are high-order and use =
__GFP_RETRY_MAYFAIL,
> they bypass the OOM killer. Returning VM_FAULT_OOM to the #PF handler
> without triggering the OOM killer (or having it make progress) leads =
to
> an infinite loop of retrying the fault.
>=20
> Avoid this loop by returning -ENOSPC when charging fails, which maps =
to
> VM_FAULT_SIGBUS, terminating the process cleanly.
>=20
> Make mem_cgroup_charge_hugetlb() fault handling use a common error =
handling
> path, the same handling used for =
hugetlb_cgroup_uncharge_cgroup{,_rsvd}(),
> which also don't trigger the OOM killer and hence opt to terminate the
> process with a SIGBUS.
>=20
> Fixes: 991135774c0e0 ("memcg/hugetlb: introduce =
mem_cgroup_charge_hugetlb")
> Cc: stable@vger.kernel.org
> Signed-off-by: Ackerley Tng <ackerleytng@google.com>

It looks like someone fixed a similar issue before, but I don't remember =
the
details. Anyway:

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


