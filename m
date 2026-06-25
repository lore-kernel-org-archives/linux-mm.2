Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D790ACDE007
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFD3C6B00C9; Thu, 25 Jun 2026 07:54:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD51D6B0128; Thu, 25 Jun 2026 07:54:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AECA76B012A; Thu, 25 Jun 2026 07:54:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8993A6B00C9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:54:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0839DA05FE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:54:33 +0000 (UTC)
X-FDA: 84918277626.23.F27B14F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 645251C000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:54:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=beu4O6BZ;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782388471;
	b=Xg/5XUN2LnICXTNAXgm2rPKcO1lbzyBaTGGrVHVmNQMKziOJ3EjpVpNVTx2ea3g4UWtmMX
	5brZg/XFjvuopcfNCwDGy35k5vf3+0G2pN+witVN9tVDLMxsRPKJ9GpwZE0fMddlgzi+MB
	YDmfxKh27nfmGiF+BxCYO7G6YA3Fyeg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782388471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/GXFi/MVRAwUZHw1Zk5DPCqLioIWwoiNAiqmK1nO1Ew=;
	b=CZ+c+EHuKcg+sBOF9H/3SQhsz9JebK0sH/fY87u19s+cbrkV9hM+clwqmwge7fU3aY6q6C
	e40Z19TFwKv6/hlIFTumJmHQ1ejSeqp0zCpEBoswWIy11ZnXLnJbT1dH4TUvP9nk3cBO+S
	Srr5TE2186ihtkNvwXOErrbVkdVFCYc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=beu4O6BZ;
	spf=pass (imf20.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 96DF040B7B;
	Thu, 25 Jun 2026 11:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264EE1F000E9;
	Thu, 25 Jun 2026 11:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782388470;
	bh=/GXFi/MVRAwUZHw1Zk5DPCqLioIWwoiNAiqmK1nO1Ew=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=beu4O6BZP1eXIi45Dd5+lSUZZefTpFb3TjvzlFxLH0t/BOcXi8L6Dale141fqCl6Z
	 /Xte0MUmMr3yT9Pcbt1Lg8nplPdvKdmOnIVohDbRXzgub0s/+nTkR/vXxf57AZz0CF
	 SBFlmlwifSmHo/3s7jGSTq143SfCAFMwOl8TxWJ61LJRBo6NS6O+GjGXDZFEdykJda
	 ZAhI6fYFT/UqiaP96opC92vgpKZ/jIEtfoHBzsGwNgcrPxbp9F0u58F4tUoecbcYza
	 skRccOgyZHJp/MMsUbljWviO84DFhaq696UGJc6N0ZebJUxf28JNGPE6nucgOmoHxO
	 kXQfySON4fttw==
Date: Thu, 25 Jun 2026 12:54:20 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Yitao Jiang <jytscientist@hotmail.com>, 
	Alex Deucher <alexander.deucher@amd.com>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Felix Kuehling <Felix.Kuehling@amd.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, amd-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/3] mm/mmu_notifier, drm/amdgpu: block THP for GPU user
 mappings
Message-ID: <aj0V0Dqg-4Xa8-6Y@lucifer>
References: <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
 <d462612c-508c-4682-a776-92f4f4a40e28@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d462612c-508c-4682-a776-92f4f4a40e28@kernel.org>
X-Rspam-User: 
X-Stat-Signature: y3zrqnfhcsw1fxb7pxmeuf1bjc68z5ge
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 645251C000D
X-HE-Tag: 1782388471-260293
X-HE-Meta: U2FsdGVkX1/69e4thw/3jTFfFtOKC0A8aF7T/FqYSZg0EdydUGhrV3NEI1PHuYcKJSRIl6kO1B2TQgqP9ihfoilXPLlvfjg/7/PDqgJtxKrM0gYnjhDIWuDK6DLq1OQQkscRRWNcecltAlf0cI9jIJuXventAQz5ifwGFDvvC8k65Ta/GGtQ4Ia/Quduuk/blOq5/3etmkOaA6hVLQqiM5gilbK/MJ117R53YHvDozqVwuBiCH/8aY+Cafu+CBbfJkoM523+twkDJoww5C9RIJX5pB3saUpwyH5jGnpEMYBG0MBlU5uZSa0h/Yx9fkBSYlSOmEQLBEjTagdcbiDtg8uXAQJwrKNroJA2RGNtmg/w4WK3eOiC2cYXSGUuiDliVmqRFxtIHZNbxzUGMJ3ONTI6y0SFHgkIuvkEJlA+qFpb0WqkN4+00Zd0p3v9Q+RbDcZK9r+kK2rm3nkB+ax9Qum293Oz/fx4ah6N/lDkQugy3D7p4H90lc7+dGbIxN5HoenZAMk2+wLj2lxzbpHFXN29lM61dYsSBLt5OCfc+UbTxBzqNQRtUMY1XMsDBvbXNZ9U4UIjOWFv5jvUymUq4UVwSgUR1gsA9494K1DuqS4FX4TtgQtDw7temLvFad2yf17qc1x99r3oHc2uleTPUtVaJZryMbx4URxEZCEE5DKrTlZ2Y8Ggk5FR3YqZNfV3xb69LKayME1MLIRpgoCKeobM6jcnPtjBeE5H/kDru9qvLqHpb4TphtIi/DWjwRJyFP05enAGSZ72vDeOGnmB7mp+WfUwk5bB8oiTgP03wM+aJ2ezXL+KI/dIllKIG6L7HFFYLvZD30CsD1XoAkt5Z5Efoo243YENyCReE4MGFgOkoWKN6iGRz9BezSnqozuscMNrF4jEhah+ha+Ob1VIZl0kQMhzjU5YRzXsjz2HmN74Znvb0FYfoRoIDCPa5TkWIRY8U6Ba/xJmfXy6hSw
 wuyKZNLY
 Z3cwMiKzx649tIZ1n/5B1000nAMjpIUbfPSZxYInEiUl0SaYUpbXmNnEjWUVY1iw/fPSlUquZTcFJI/L2jBc+5N+RC7qvLO08SnkSeug8aEVXKDlC06zySJpqSspto7mk5i7mr1Y9fwuX80jZoJvx/d+LcJyL2m+WYpxIL4lvDRS+mVrq3iD9df34oe6fmOdVxTtD3hwCvfLsj/7ecfQx7aiKATN9l9e9erweW7Dr1Uc6GgERADQ05VD0w/ctK4qIUGQJcPE3DrftjuBT83NYlNge+Xt0l8h6Bh/cMZ/e6oHIaTA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK to this or any version of this.

This series is insane and the idea is insane.

On Thu, Jun 25, 2026 at 01:47:25PM +0200, David Hildenbrand (Arm) wrote:
> On 6/25/26 12:59, Yitao Jiang wrote:
> > Hi,
> >
> > This series fixes a THP policy problem I found while debugging
> > frequent ROCm GPU failures on an AMD Radeon 780M system during ML
> > training.
> >
> > Some AMDGPU/KFD user mappings are registered through interval
> > notifiers and cannot safely tolerate the backing VMA changing from base
> > pages to a transparent huge page after registration. Userspace can
> > still apply MADV_HUGEPAGE or MADV_COLLAPSE, and khugepaged can also
> > collapse the range, after the GPU mapping has been registered.
>
> Huh, why? As a memory notifier user, you must be prepared from memory to get
> unmapped+remapped at random points in time.
>
> What is the precise problem here? How are you handling THPs at registration time?
>
> Letting arbitrary drivers make THP policies sounds like the very wrong approach.

We absolutely will not _ever_ allow drivers to do this while I still breath :)

>
> --
> Cheers,
>
> David

Thanks, Lorenzo

