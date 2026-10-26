Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0360F606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 04:52:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hQvr4fMu
Received: by kanga.kvack.org (Postfix)
	id F21566B05B0; Mon, 26 Oct 2026 00:52:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2236B05B1; Mon, 26 Oct 2026 00:52:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE7BB6B05B2; Mon, 26 Oct 2026 00:52:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BCDE56B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 00:52:50 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C8D42120440
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:52:49 +0000 (UTC)
X-FDA: 85363557258.22.F5540BB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E4EC51C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:52:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQvr4fMu;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792990368;
	b=6uXf7B7J3SQbxJ4NJn11/1Rui3Zz+ncIxj6yV3y7myL4Q/y9FyG8XSKrWW07cM169YDJmF
	1HwDzhq79m4aLpjsj/AgI9Y04FV9cwIUDVvSvJrgCyxGh3JAEc/Zn7vjS6PpCyDbgFC902
	lOYGLggcKRaFZh1P/6/tAMhn4NRIgX0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQvr4fMu;
	spf=pass (imf18.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792990368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wBTt6MDoP0oWCk5YcX06KXZMQu4SU2+/GpSjq8u/XPI=;
	b=b0xaoA59eNjhFFnrMFcZ3KBl1ZdwggiScYPGPK1ICfJmUYIbRbWIPA3xpGJKz8Xqz02GHG
	liNqJmtDB4h633vaNe17qSUox434rcsIJEnnnPo5oGy0gTJvG/VL8MzZz2edeGiyz49+pt
	Lt+4SKWQ38mhVKYkic5vDNU+bUdZThY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6DB243FEE
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53981F031EB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792990366;
	bh=wBTt6MDoP0oWCk5YcX06KXZMQu4SU2+/GpSjq8u/XPI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hQvr4fMuzl0diruADxjlXwpzYFn1Oc8BjJqOFIs/NNF6GXbmOFnc+Qs9zuaTLm2cU
	 +k/H8dkVBTue0J9zL8FPMtklx+PEkQJf1iGmExjA9StqYCOf7j1MP7zeal9RgW1fV/
	 2be3dzLsDypHyO+mLtt6ykD69HnJwv9HWwn4S4Ga82mKWwmCr0LrUjy5THI8Zb8FvM
	 +Z0S7gMP7JUbd85ld2RZPSV1B3NNpsk+TcLFAeye2uFoukxP9hEQMwbU1ab2s1GRy1
	 FhXSlBB7bC0LkBwcfkoU0vLXBEKGlH7J0WiHKAF+ufxWGXY9VW9/HpoqBTCJHRN/9K
	 Pp+pvS2ANhAuw==
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-53cd0c8614eso2341841cf.0
        for <linux-mm@kvack.org>; Sun, 25 Oct 2026 21:52:46 -0700 (PDT)
X-Gm-Message-State: AFq9FYLjKfe4PEcB9K8mrUIVn471RnjrJaDt4G+81cHYE7JE+vDhiaUs
	3BD+e834Jr7mDuc7epKFKTVttCKM2uTTPYsJUEdPRoV7dCFPGbN+z0goO+/RruCtF+BVdpPj2Wf
	HF3Mj4D1dz4niMBqtB7fHwyzAYLgR6oU=
X-Received: by 2002:a05:620a:2603:b0:93f:565f:e46 with SMTP id
 af79cd13be357-940ef97fb6emr813826385a.52.1792990366068; Sun, 25 Oct 2026
 21:52:46 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
 <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev> <CAGsJ_4zUVpBJazRxc1CzN6u5XvpUaGnaf-_7JMz-rGK_ZTYMtw@mail.gmail.com>
 <e865f7f0-087c-4fe5-b729-6e6946cd20f6@linux.dev>
In-Reply-To: <e865f7f0-087c-4fe5-b729-6e6946cd20f6@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Mon, 26 Oct 2026 12:52:35 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wp_jCtCeMx39nW0Z1Jm5pja7_V6XNwLB6p7zTan0c3VA@mail.gmail.com>
X-Gm-Features: AclHuK-BfQrdt1kOWUG-wz67A8OjcZGoLUsTLJeHszoeBANLz_PBEAvc05UFngk
Message-ID: <CAGsJ_4wp_jCtCeMx39nW0Z1Jm5pja7_V6XNwLB6p7zTan0c3VA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
To: Nico Pache <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Usama Arif <usamaarif642@gmail.com>, aarcange@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: E4EC51C0004
X-Stat-Signature: kg358zac7t7po3fs7njsjqqxhz1i1pwq
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792990367-622110
X-HE-Meta: U2FsdGVkX1+V1mr7RaeZ84cSLWS/ZcLVO9YwaAQ3CbvLCxJHx+5QpmTfaDps4HKRMuncWPQwJtQNOJvcSH3DEcoWX63BwuiK0jZw++f/SlkuLzImAnDqYFXX/y5olOq57N41DuA7eylcZ12x3DKsyVaskLmbULjmwOB/Oy49t6H9kGxma17T1PmSfQjSxv4gIl4VEFoIT0AcmO3nh3ryMlPe8soL4/gnJhvY2XqCDBGQzyCmxuePK9uzQ/n17/DbETpbfO0XXFVVFnvbpHxngaFXtMFHT57hOo0HFgILny/bwV0iMOzigp4lhVhOHZBahHM/e7LIZc7exbu8/gu4hRdGHKnk0Fanu9Iwz6cYilVEdpyd5aJaW4R7Gv+PY/V4GHXl6rx7qiszvWIsqMxJ6eqanrh//+HPPxNflTka3Ccs+XCdD8Oe4bovXQVmZ+HkPVA7qF65M5WuOQTQ39AyTtXbUslSU5z3JQ4+o7xbKDWq5wHbmpP6EEU1lh1xnTUV7ql3NnZ24r0SehkdTwNE1/RRtkD/9W25gTUr87eUnG9jSgamVf2Lc+yy/gqLtsGW4xy5dD37HODLZA34TCsyXqRkebmPzWU2F6mjfT+XTdCFTTEb2kVnq/NcbvTYNGyLeFdogW97r2Mev4DVU6/kH6zKyW+C3bE+ZtE56O6eQaTCYyWPbUeypIiVhk2YZVyIp0LUPwq7oYmgR981/beI+Xoy2n8GpyaXnY+j4MSUjPzCVMV78kyjMy569FHUJJJ8JOZLADi/wQFWoJO2bhwVLlR31VcjlWoke+8QHLidMFwGqiU39D9fL2XhiyGZto3lNrS8jCP0vO3VSNO4HHlyhaW41mHvijg59PykmtWVbnyrV1eReHYdw8h5rgR0mJual/UQxtlMkNgqTUb65h5ao1k3aq168Jl2ojIx1ilbSpvquOCRrgzYbRF9eiCjS0tDWoWxmk9oT+cA+4/K7KW
 NDZUH9ND
 EEfAyGvwOPhTSZ4+u4HN962FG/CfUq7sztI6X4+fpsVSd4vpBhTIbdd2tzOO4GmFCx3HRUTW6wC35buVB4hTJsvG6FR0XNw2mnYwc4x092zi6j3AgoYo2NdBVSiZqh+Ne5mrPiJCudo3hvpJ06DSDacylNp3CvmORXtIuGSla49f4IrClXiG0CDhwKlhMEN92lXurU3nU78o6fV0WnlHBNRntp03hABrLmeHGL/dF7LqUVVimFMySCK3GNG4trcgQyDUui2ebFSg4NZ5Xhsv5EAbSUZTmt1oTHTK8FaOv41w/OkCDn4Uioq8G3inLWNoGwk+X5Yge2R8NBJwULDqNuwrn7vUufTK0jBTqA0y9tyqi+8Y2sG7uG43gWeVYYEA4CZctCyzArmfJohL/gd/bQPdbC8yw9lDkrbw586X9x4t6bzi0Cv89DixpHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 5:48=E2=80=AFAM Nico Pache <nico.pache@linux.dev> w=
rote:
>
>
>
> On 10/25/26 2:28 PM, Barry Song wrote:
> > On Mon, Oct 26, 2026 at 1:40=E2=80=AFAM Nico Pache (Red Hat)
> > <nico.pache@linux.dev> wrote:
> >>
> >> The zero-page remapping in __folio_split() was added to support the
> >> underused THP shrinker. When the shrinker is disabled via
> >> shrink_underused, gate TTU_USE_SHARED_ZEROPAGE on split_underused_thp
> >> to avoid scanning subpages for zero content unnecessarily.
> >>
> >> Suggested-by: David Hildenbrand <david@kernel.org>
> >> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage whe=
n splitting isolated thp")
> >> Signed-off-by: Nico Pache <nico.pache@linux.dev>
> >
> > is b1f202060afe a correct fixes tag? as
> > commit b1f202060afe has no even "split_underused_thp" there.
>
> I believe so. IIUC these two series were merged together. While
> 81d3ff3c6f7 introduces the toggle, b1f202060afe is where the behavior
> started.
>
> I guess you could argue that the Fixes should include both?
>
> Not entirely sure!

Thanks for the clarification. I guess it's fine.

BTW, with the code below, we no longer add fully mapped
folios to deferred_split_folio. So the scanning code only
handles partially mapped folios to set up zero-page mappings
for their subpages.

I'm still not quite sure whether this is really harmful, though.
Am I missing something, or was there some discussion I missed?

void deferred_split_folio(struct folio *folio, bool partially_mapped)
{
        ...
        /*
         * Order 1 folios have no space for a deferred list, but we also
         * won't waste much memory by not adding them to the deferred list.
         */
        if (folio_order(folio) <=3D 1)
                return;

        if (!partially_mapped && !split_underused_thp)
                return;
}

