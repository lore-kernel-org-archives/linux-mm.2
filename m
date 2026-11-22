Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CB8C606A320
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=K0DZt8TE
Received: by kanga.kvack.org (Postfix)
	id 6A8F86B05B6; Sun, 22 Nov 2026 10:57:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65A1D6B05B7; Sun, 22 Nov 2026 10:57:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FE16B05BD; Sun, 22 Nov 2026 10:57:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 245A76B05B6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:57:53 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A60A61A06D6
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:57:52 +0000 (UTC)
X-FDA: 85463210784.20.BD7B531
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id C03C9A0002
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:57:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=K0DZt8TE;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795363070;
	b=L+PPM1dsXUHbyKqXMLBmqRqptrwmOAaVDbN0ZODpSXDrf5HO4vFP7rmLhckPcxGRGaTSNq
	r4A3EfUubbw5uFAuBem8VzfzW+vzF6LJBFnHRyT2pf7fI/M1l/dMYXRdD5ui2PBCD0MoYy
	FAt5IJPtVDJPduNkumsFZjWM95CuMpU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795363070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NcHYZCZqGjruQWjTBcuHdUshGK9b343QactbdxqWzZY=;
	b=l9OcxYxq8msYHio1v1FqRpY3mZiPIf+EAA240JOOhozWnTScmnBkGOeLFK8ir2voaWNmZ1
	/VGYSggDujntO6O8bT3A5NvlOYPuqye/oCtRXNnx7kRLT7ndSB3L+f7hhTUiyifUDww4ZX
	UX6yq5OW7Z1jLDQ7KOyQ2SaeMkvOreQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=K0DZt8TE;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-5495d549924so29372601cf.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:57:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795363070; x=1795967870; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NcHYZCZqGjruQWjTBcuHdUshGK9b343QactbdxqWzZY=;
        b=K0DZt8TEOpwIbqjECsISarnSfEeh5aISYM6h2MU5jPvcMi13QhQO2zADKQxJQY8L+U
         bWkKeXr/IgmbZrjMmkNsqwUwq5DdlEOEQL+voIMEVAqtdBQ0gCIeLJrJQmQ4laTOIWPK
         n2p8WzeVCqKeLUXyzl/a/Bkc0eB6v+63FNVboPCwzuNPhhbEpyTOsuinvcneMFogz6wm
         ma2xZV7Y2NZGD3xi6sP1vYZ9aSnmlH227flLCs2oJU750dKVIjg6ZDwWTa4TM9Q1tw5a
         Fmff10SH4LSmvA/Xhx33hbv2QtzkzJO2lyBYn+BwHFw+qf6WdLgrfPas7WN+mubXzh7S
         Slqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795363070; x=1795967870;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NcHYZCZqGjruQWjTBcuHdUshGK9b343QactbdxqWzZY=;
        b=PG6CN6wsI7vSkztidHskANvfh4Md5avVVZ8oAOfc5mhguHipHfYFZtuO0/toOxL6Ir
         bmaCG8Aop6JrcMHnlUmOpdBJbrFtN9mQl2xtRuEHRKnbppNkOH3LMOUkbFkdbdhjjVLA
         m6J9/g4JPLtKXfabEBZ80cgBUEdOJiuKkM4Sl3BaDrTb4DZtkh9eJW9K0dOsOsosX7h9
         FFYP4kAxVv7aRaX2bQKfSaPkGpgmZ33Qo7dVy5xZqbdDRK1Thn6thMHEpXuG64KHfqQ9
         LhUmOkKsiio6ZUIEg8A2vtBSvO9R3y5hZP7S9isp4UkyjF41CfkI7Oyy1mU/WWzyOyDI
         IErg==
X-Forwarded-Encrypted: i=1; AL+hErEnHYa91eW4ZEnSdEGM2870v7cLcFy42Ku45bmhlurPPtt2nnEaByo7UV8ZXUJPcr+sCwXg0g8+bg==@kvack.org
X-Gm-Message-State: APuU4Z/lwa2XJstEu3gxU+FRpc7G3vE979rqxJHkvs/UCQpw5sg8kgVS
	Zj873qzPniK8p9oIk5vGuZ0EILlQxFa5a6FWdfp4a3bR/bjWlRi6qCkXoiwg2FySCLo=
X-Gm-Gg: AZFdTZezlI8EHy9brwjIhYebjLtoTr0jgNMDKPp21NitHFIYMA1iUS9mUxX2oGM9vsM
	fclHXcR1ojotP/sWtd1tffIB3UfP8AtmcGp7Fxf1MCpJGBj6imsGT6k2Dh3uxZEx5t2z+DgeIHd
	j79AlhnsYJEcF4u73yme0TyMNtefjG279+gTz2Y5Aw/0K/dE2ErRWGG1kCNnUARGKqkP4EXSsmJ
	0935JFMA4SaYprdu43t8cc4vp3IuVI7TWSOonmOLn5h63gd+yvDucS47VB4/bz13xQOOxT+6XbT
	veg5qHs9fmYeHbrkUEhO/CIm8RammXKGNARYjYBtLObJfVPjxBkauitDvM44qRKPNYjdKQP5dkZ
	U5pcNDain7FDhO264I2k9b3DCsSNkq6ZVhsTmTbByic1q6qFNo8BYcKU0ESnXTBpGqs12dMBxSe
	e8WxfW/cZ/oONUP/RyUE5UsIxWtx8MgvHi1DUZnu0l9tbNXRXkBIspCncPppLzOFL2YGnqrtuw4
	F+R5FCgkJ8AnraVBeKJW42PWuViutCd38Ujq7Bxmg/VwSJsMca41ienGyaK6Hh/bTxuDyp3nl7S
	fEog06DBNjqtH37HbEbU2RxBQfYowB/05jz1J50k8jlSAHXtr5I1rdlnNnYl/uL3t3kqL5ReYYb
	Km6MwLY4=
X-Received: by 2002:a05:622a:1aa2:b0:536:719d:7974 with SMTP id d75a77b69052e-55d76a5212cmr163702871cf.55.1795363070036;
        Sun, 22 Nov 2026 07:57:50 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d7887bec2sm76958671cf.22.2026.11.22.07.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 07:57:49 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 0/7] mm: reworked AI-generated VMA and mremap fixes
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
Date: Sun, 22 Nov 2026 10:57:48 -0500
Message-Id: <179536306892.412063.18259419201274512281.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 1yhe36tibk59hodgu5rja7obyrqw48m3
X-Rspam-User:
X-Rspamd-Queue-Id: C03C9A0002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795363070-294810
X-HE-Meta: U2FsdGVkX1/vYSNLc6RlGnnXitxYgPDBl2o7oxnFduv5p7U8NwEgLTF9C6Ei3p4OAYFVm1C0R/KfvrZq950KGv7ZXiU3z96rzNQVCRfjPVzyFcnbn0NrQMKqylv18R5kDI7zW8v0N16+sXsF7KPMCZoNaVZm+E05iUOOaFa3rfXR1eggcxo3LM1w//Uub+59H/QO3A11Vhznir0+ujJOzrQ2clpIuHPThCKaCUmMg3Lpt4qgIWvDD00E3r6vn6xj8Rg5OfzPzcE4VQSLJE3YTZL7zqPHEfkqWvr+hJAP5O5MqlArNFXxIIwoCPaENMCDVED61PoZva2OC+Y09qYegeOA4m+n0/t21Qnap3Xh210R90JxqvKbxUTIWd+YctirkVb3VOgmpBP+8zi4wHjMGIk4OWYXeLN6gPSvXdrosbKJ0pT5oD1zmEmP4rAgqkoDCcN8YbuXiLFIN1h6eRRLpucXm2fPdZnQTPDntxEmTPRXjtvBH0n89JYzOefstJYNxCBQ0AXuzgwptYyQP4wgh+ycJUu+PXCU5w6V2k/8gpKAes/ZeszfkXb5CVbyKdcKy0fIcjLzpaFiSmZnvQShQOPQWbveNSDRanU3G6TDXtNNpIvQyyWRiRsVxxvuPQ+Us7oDxRd/SUrqom8yn81jdPWv+nA7hbvXJP95l3Fg1LTiPcWKfoQUDNqXey7vZeAa1+KZIwzT6VjyU4oGxvRK/Ncrm1v6D/UA22m1ADkoN6LfRqQ3SNwIoIl/JVyRHEkVbLwuxlbTjfd+Q1As8tduW+3Ln2ZzmM58jlqU7hABA/RzPCgtwDowHRaeJNMJDRDv/NrQmimXhehCb71Vu04HD+38qcS9OY5kc198y4sQk1YEDRSYmXQ4h9cvw8jSJGVj84PsZQnVo9hkHmEq9dp1abXesw1BHBz92k6IFVRH9SbnQ06PNHsiWfuE0UzT5EEwvLYejUGSCJuWE/MRKOu
 aIYDCzWd
 t+tD8aAbGJfm/SP65gP/Zc8lwTf8LnkBcqhugSc/cL9gIPNG/jnN8izjNkCfRBYxdSPsd78EiqPxT9eAHakFVYX8STEJEqFQIXZvZzbU6QcatEeHf0z4WR8Z6PwkPFMO240TCEJLoEFzWokAVOOVvzevLmvA990VKHB3eWn3pN+VfHLKPd/40CBtK0aEVA5Q5zJq2bAisz2tFqoRhXsmApCuoCkb7NLrFtosmhzX7xGdPkaJjUsUn2ocaSqQDMSy8qDL+SEEtE9po6DQ0xEqul0V/vDgvkLOqZLZk2D7KcHVmNUG3tGDIj9mxxLGmZhTl6L/dD3Zqm5v2UC7FpuZ9bLgKWpklqBnUJJBLDf0RsHovhSNYqnoZv+gcdwTSBNsYrpVcABRXDD0TFxsX014P2/3WFqvTe3DXapvzJA+8sTrvj9YEQD1tu9NseO7ePdEZbz/4OlZyyW89Wh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-21 16:02 +0000, Lorenzo Stoakes (ARM) wrote:
> I have reordered the patches here by priority, David - the first 2 should
> be prioritised as hotfixes, the rest can go in 7.5:
> 
> == Critical ==
> 
> 1. unmapped_area_topdown() invalid bounds - possible memory corruption,
>    triggerable by any local user.
> 2. Lock VMAs before mm_all_locks_mutex - system-wide unkillable hang,
>    triggerable by a local user with FUSE.
> 
> == Need fixing ==
> 
> 3. KSM unmerge only interrupted by fatal signal - silent data loss on
>    mremap() of KSM memory.
> 4. Uncharge after failed stack relocation - strict overcommit limit
>    defeated system-wide.
> 5. mmap() offset limits on mremap() expansion - invalid file offset
>    reaches the DAX fault handler.
> 
> == Hardening (no need for Cc: stable) ==
> 
> 6. Guard gaps on in-place mremap() expansion.
> 7. Non-executable brk mappings under MDWE.
> 
> As usual, please go through and check these carefully for correctness,
> sanity.
> 
> Note that one of the original patches was punted over to the BPF
> guys ([0]), as it doesn't feel that it'd make sense to change core mm to
> address it.
> 
> [0]:https://lore.kernel.org/all/awGZWsCp6v63H_py@gremlin/
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Was able to reproduce every issue and validate the fix.

Not sure I agree with your assessment of NX brk mappings not needing
stable, that's a pretty bad bug in my opinion.

-- 
~Gregory


