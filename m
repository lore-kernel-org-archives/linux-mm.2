Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4AADCC61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 04:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 396896B0088; Sun, 30 Aug 2026 00:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36DBD6B008A; Sun, 30 Aug 2026 00:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AB386B008C; Sun, 30 Aug 2026 00:42:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08EC26B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:42:47 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 721294026A
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:42:46 +0000 (UTC)
X-FDA: 85156690332.07.E5196C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8A1C1C0006
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:42:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXL6crpH;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788064964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atXEPa9UAnMS+WEK+D2z1APgofzXdx+YfnDKm8SmTWk=;
	b=dMFJ/ex8gmb5l0GjqvsdK3B0WgCh+jqEGf/W5XNdcabqVzSV0En3ChJcPVgXiuGs/41q1s
	wWU3eD+7NVU29AXF811kazZa2GpZYhMCxKRv4dDBjYTrTA7bDi8L6dpLuki0P/YfzjBIH3
	5+lWlWQBLn8uSKcW8Cb+kKCJSc1Fgbw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WXL6crpH;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788064964;
	b=pNgvjdYcTJ7qJaN+3A3rLR9z4KxL6nOMd1mvQVXxQZvlJ57Rbu0lVRDdy7JNe3bqvYdRDg
	v0pel3s/cNwWkiwOrwgWui848qcC7YsyUnLXv6vPIVUGz+LPQt4TzMoBWJyzWjs4PLPhG9
	hj+OWGu3DkKuS6IhMH/eiovzIjO7jLQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A836341B02
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D031F000E9
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788064963;
	bh=atXEPa9UAnMS+WEK+D2z1APgofzXdx+YfnDKm8SmTWk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=WXL6crpHf4qLMx7U0l0mbpkhCHkDbNndDnhwawkm6rfHW1E2HhPZI9Fr0FtuiUKO9
	 r2k3VTZmK3B25DOKGGRf0s3Jt0yx/1CnslCBcrGCj9VaDMtEIR2oCFKQx8vbPA6hgw
	 rETJziXVcOXnOn2gCVeb9HEmUH78SDNW+E5a6smY1vLdJ0PqzCLTvnfjxRygz+yBzC
	 68V2xyLNoDQCWoPpMAPurrVF4wNdlNSajsrnPVxdGqmwn+iTYZ7o1B/+9UWjQz4wz1
	 M6eh7zVlQOliBwVlKcoDYj6FFCj7qwuc/iwnugGkpdjEiZ9dIu4KTFzHXaW4s2bm78
	 9RXRN5NDdoaJg==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92ed19f4d60so201830585a.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 21:42:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpPrU++/4iyxR2h1+FwGqWIzp8ioPbq8LfnplxKzkHY1pEJPtHs5P9Fahjkp9nHBc5v5Cdkd3M1BA==@kvack.org
X-Gm-Message-State: AFuF++mwLvqlt2fVKYXhYb1C+OXeD4gLJnymWWU3m4ILrRxDczR+87gt
	Ph5cHaudSm2vf6L4fXn5Z2fK7zN0ZHBp/bJKYVIY8S5QOCEtEjK/FOSjpAxxI/SEypzNn9YOMGA
	X1pnfGML0hdSAFemUbp2UkdYMiBaU5gk=
X-Received: by 2002:a05:620a:8388:b0:937:1b42:c949 with SMTP id
 af79cd13be357-93936bd569emr25376785a.4.1788064962983; Sat, 29 Aug 2026
 21:42:42 -0700 (PDT)
MIME-Version: 1.0
References: <20260830042920.2280454-1-xueyuan.chen21@gmail.com> <20260830042920.2280454-2-xueyuan.chen21@gmail.com>
In-Reply-To: <20260830042920.2280454-2-xueyuan.chen21@gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Sun, 30 Aug 2026 12:42:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z8Yikc6UhHsHVY2cWcjcq0zej+20FOJAiumPUrpXxCQA@mail.gmail.com>
X-Gm-Features: AcwNN1UcWf3lsTry6wH4EtqhXnPuQtp450q_InQVv-OuUEkbZ_FBtSJFcs3Tl4A
Message-ID: <CAGsJ_4z8Yikc6UhHsHVY2cWcjcq0zej+20FOJAiumPUrpXxCQA@mail.gmail.com>
Subject: Re: [PATCH v7 1/4] mm: add page_counter_margin()
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, zhaonanzhe@xiaomi.com, 
	hannes@cmpxchg.org, ryncsn@gmail.com, youngjun.park@lge.com, 
	baolin.wang@linux.alibaba.com, hughd@google.com, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xibxo7o6fpijeskkrjcetauqoptkjcyx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8A1C1C0006
X-Rspam-User: 
X-HE-Tag: 1788064964-271245
X-HE-Meta: U2FsdGVkX18gtOKxjB8/68OMFtM67auVmcDld8rxYQPgqCOxgCdui1y3ZodebqgFu3TPpl2OokT+dFcpb2qfBM3zBxI5mW6X7Q32vz+zX9ZkMLJ7FEfylzfVH8mwhFRsmEsbF1mAXm4ns3iHb5VC6DdyoE+Y55nTIxtTwXsEttF7Df5807B9tSlY5Kqr3bkqgnuclzmlQ89k4oSkCt41zLKEulLCQ8ezVQuWxLuErKoxVHKaU7RwQybw3PxCSnVFCmeyRc+D4wOBeUJDiu07TtmVdVGtwEvbefBsMtQ9gX2zptosoeXJqvP71yJS6Un4/xtxtNkxhRkY5SqWf3t36TcSQEcSQx8Uv16b2gJJ26wJ4dAQtrY0zo1QwHHY1UVUIZ4sk4CRGFyW0gSIfCzRyAoFQgsRRfryWoWQLDowBINM+gSdwolZM4FtNc5pmCk/Ck0sLfnm1cqsiLCTcyst+Pl4x7EvXsulnV9/P2veF6QcrUNtCFP6IweCiTV1IysjA26J0kqTVOH1wDhSCwZ5Je/v2krPFlUMwlv7DOwYvrfWAIx4/U6hM9IYZaD9JAhPW+1AdKhOc8f28gqgqLAgmTqKYRXj9xWSQMFZ15VldWE4JOMQqtN7JSigEyLeg3QysZsCzfyyww6PdoNtJdj1d5R6QlTzJ+TD6InEQXMfeJAQZ9MhdEZoCPT7ZlKOUaBHaPxoVqO8qyPpIzGhwlCHyzfpUhjhZsNZVn53lKcQC1zFgAd73lC+ZVHTRrHAlV/G3XVTo/jwQwu7Mo309F7TALvteOMvhqiK7IQ1joWu/IIZ/dpt24ymXxIBgdHiK1PSDkvmrIHNqCn2Ksz9k/3XpirGvaggKjQxAC0SNttGcXAxwXsbORjerjQtccZpKCTz/kVGxI7dZEKPJp4LC2Gbd9lTXwUuvigamvkCg31Et0pih1mvSSXt1Tve/ta6WbEmKeCXq+Pxq8WClqltOVB
 YqO9+Onm
 +aeejIV7RdGduM/xce20YpNMbSpia9S8su1HxpBncL1JR3ra/sdR+3Yd4+ElXsAM+/26NGoHgDbOBcqo+PWkpOszImg145Wq9BVul5sV1R+yQds/E4S9LMqgsvsK34pzNMIJYSOFVfkFNwV411An80QUFkWhxC9vIrGJdSpKjXjpG6hMc3hv9KIDwJ3rdCRJg2RWC+93ttLT5IJ/Z/kbXWKT/IRKd9QN6g2V3r01nScFouqV48QwO/GsP+0eHsP6F7aRTIkXr+OdGAH5c418uNSwJ3BYOJbh44Xd2vaa5zNp7l+xVv4IjI0o99lcV4ydcETpifjHep4ilFEOIui0jC/C46Pej8gnpJe6L7/Fv5qPjVETx/Cfbf7nvKw5L2Xx0VUof5bk4WQlW7IGuCLb/Vqo3WJTggqWANsa2/FychFKvn4HjxWDrV1xVT+yM4J+1QVPMp/f12z4GHwOQh9/oZlhvm5GUqaq9Mu3ZIQSscF5Yla4W5woxFLWVFxSgMmcDXC5O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 12:29=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail=
.com> wrote:
>
> From: Johannes Weiner <hannes@cmpxchg.org>
>
> mem_cgroup_get_nr_swap_pages() open-codes the remaining capacity across
> the memcg swap counter hierarchy.
>
> Add page_counter_margin() to return the minimum usable space from a page
> counter to the root, and use it in mem_cgroup_get_nr_swap_pages(). This
> is a pure refactoring with no intended behavior change.
>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

Thanks for working over the weekend. I've been waiting for this
resending for a while. :-).  LGTM,

Reviewed-by: Barry Song <baohua@kernel.org>

