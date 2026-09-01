Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2407C624D4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 14:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F586B00D5; Tue,  1 Sep 2026 10:11:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F32606B00D7; Tue,  1 Sep 2026 10:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E211F6B00D8; Tue,  1 Sep 2026 10:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB2126B00D5
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 10:11:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A783F8045B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:11:41 +0000 (UTC)
X-FDA: 85165381602.03.801437E
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	by imf13.hostedemail.com (Postfix) with ESMTP id C5B242000E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:11:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ToRJ74fL;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788271899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LHkkshZ3PVxOZzqbwKcqNzDLof8u7Tm/vxYAm4UhRQc=;
	b=QWaZhLdS1VwyfShKZ4x4TyxskDUERj1hW0nPfkQN7yd54KV0Ck6JVuJ38DXt/yusD+xRAe
	QoUKa+D52FaCZKUqycEIMHk3G6pcda//8RDCWpJdsGh7SLFDZBT1ZBu5sbX+g58aU9oGNA
	m+tYo06MKoRnDDQbyaxeW5HFS9ZiYc4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ToRJ74fL;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.43 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788271899;
	b=1x2trr4G9cIDPIw4dEJMkJaU/tYCgVLfjMFx279emhzNFY16vaOQG3txlI6GedNGYCkDIX
	HCYQs46hwWvWaEiGFlOoJenD4fPK2MRszLCSrWaEHoGwK2zggedymhQMh5d2kBDQZUjo3p
	RUA4JN5wQARh2eMuamb8KzaABsonRWU=
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6b145a9623fso1164258eaf.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 07:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788271899; x=1788876699; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LHkkshZ3PVxOZzqbwKcqNzDLof8u7Tm/vxYAm4UhRQc=;
        b=ToRJ74fLN5vQyGoaIw7GztDSeLVijqsmNhFVAR1iq9GMy1mG32lF43fKVzs6Le5Owt
         lAn2KCBiAWc0gWSBzjXyg4SVbxTphKfKEwv/YEkHhO/FE0KBJOqLU05CLQnSoh5Oxmdo
         M+EmT2PsiRsY/rCuRmmxI4ISoAeXoapzyXlZ94xmG+JrvA9GwPebXTVXfcv5Y+/HlOQe
         m65Xpb447RZ5I+YzPeiKYjGv0lkwY+CqjTZ2yezfLrFk3hleJNQpbfhnWlmFVnAOzP2m
         sLQHwvV8PhtAG+gglAqjasomgDBoHIyyu0Lte4ZeLAh5SXM2BHo9X5FVi+kDosRi6+2h
         V2/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788271899; x=1788876699;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LHkkshZ3PVxOZzqbwKcqNzDLof8u7Tm/vxYAm4UhRQc=;
        b=ct3CXA7rbcJowNjhac/egYqt6pgyDJnpxLGtnAIJGaCOkJ/bG+ji6nAmcRbKsAmZxP
         uGJILasWNfJ0tqZl9EGNuvlVnC9Q6JB9MbhxfUw+gLc1n8ZSr2ZfroLm5aZm4YknelzA
         TQFzOyrjk3avfczNEwFPisoqWp4zxrbQ76F/BANGozNfX3TpuDYOmCaAxJo3rqKNMXTc
         GEurB+UEbLT3WWIlUjv4yJtHCkNPxqcynZ1nAQHO6G4YbjFv98wCOIEc6F7j+6hco3TB
         STsdGOnqQ0ZVN6LEij6AmhlJb2+Oi5ohMqUL8BruxIcEwh96SU6oVzfImZSie6AZCOzH
         FUVA==
X-Forwarded-Encrypted: i=1; AHgh+RqwEQhKPoqWMqKaUmoOZPMeVqE7LyN4VFCsASj4kOniLhyKtQlg2HzLhozO5haRe3HUGeQsafeYuw==@kvack.org
X-Gm-Message-State: AFuF++nsNR6n+LukRvoPkmhKtPk6I3YVuKPbcodYoiwyW50UcVl9AKfg
	1xDvvTKrMjBN4GAEgAnyfH+AQro4tbZBf1oGkgqEnYdkNkCmDiB2VSTB
X-Gm-Gg: AR+sD135T1Ilc68Do2SAMsnqSFYCwkxnwf4lEq4TMoXnnEEoNNmWD8vmbVxfE9cC0aZ
	7y+YkmLzMLpuBM4RfbdTbHZzIGMcNc0Eyr9/o3BCsaxd/Cskdg14sXWkdQ0wFyFAMmduOKYfLfK
	oaNBouLMqaP/paL0sX3N5h107NUxS8k9qLQL3zNsu5YYQaHTdQjBu4JmWeiXeFPqHYZ3dQ2nBgj
	Krmp4OKTphtaFlrtpkoz17RsgRT9TsQva0hFhyb+SlimV7DphOg5H9++/vz65YDeGml+WFsN2Ir
	PuB82lED7YPbhwAzaMc8f4bk/DpVscP0vkpSDAdIyp2/hZQcn6/wZ/nfzmuHIbvLAi9QGuHooB0
	IbiCpEJtnSSftm6Yv1Zkbw8Q475cZv2+L3zZIQoql/6nOhTAAdJy1La0lBaVBl34jkWyo13Xdet
	m5yNDRoItBeByftyG+7y+hOnj4l2s7xOPjfxSAUKjmZF9xjLnI3L3mBFjJdng0qvizk+9Rz1KcH
	AvOGT7qr4tyi0RiFuE=
X-Received: by 2002:a05:6820:160e:b0:6b1:464d:4d1d with SMTP id 006d021491bc7-6b1c65bfcd0mr34936183eaf.11.1788271898644;
        Tue, 01 Sep 2026 07:11:38 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b1ce359f82sm13402124eaf.14.2026.09.01.07.11.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 07:11:38 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	dev@lankhorst.se,
	mripard@kernel.org,
	nat@pixelcluster.dev,
	tj@kernel.org,
	osalvador@suse.de,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 7/7] mm/memcontrol: add stock to the memsw page_counter
Date: Tue,  1 Sep 2026 07:11:35 -0700
Message-ID: <20260901141136.1871423-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <apaZdbM_l3kJIiyK@localhost.localdomain>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: arzq58ian8zbw5hzuak3tpq461zy869c
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C5B242000E
X-Rspam-User: 
X-HE-Tag: 1788271899-35197
X-HE-Meta: U2FsdGVkX1+axHiLhNi6HwqC75MhbMhGQL4MImQjSImg7Qjg+k03FF2Uzi39XEA1OxsqPdpALtoS3r6j5Qk23+ysEDzTWFe5hMXLQoCtfzdsv7/eoIn4PtwX/0gyDr4QRE36nAA93SrOUIligbOornxzKinGCJtMlcPSVuqKu1ewl5qR6RMM+l8M4QDgv9WocY6L7x4xMSJHtUOsNoYiHGgl1+58/4PR/PbfxT+s/MOul+/+RqHG7vC7yucxKVEx0IEaQChUxPWXeeOkHsRH1Q8dzqLwCypC4j4t98jUmG9vnKpc0PnLq34aYmb8ztLxZKuI+kCViEL2Puy93GdVD4VvL4Kv/B4ZAYSn/IlFdmCOLbRhiiZdnkA3E8WOeWmruyVLzEPQQFWqHCGUyWW9irXnME1aJLGEhSxyguSFNCIjdr56ibHebEcMRlrskLPFcvP0nd70Swb/WT6h9ppxtwoWIroCSOE7Ry6XHBNl7mXCSKXZSFUgVVfn1gs27xUfpqC/B3QixmaQBi/Utg4GLq1vTezUdXT3eRaCwLSlVRzxz3lH5jZWTzCiDSw7qJa//E9FzP+cp4Wyhwu1rKB1nVvt7fsW+Va2IW3IoaVWuOutY/x5WWGKiavVjsuZC/67BmevdDrGPp/XhbNad+sBBJr8MyaeVEgJTq9P0S90LI20rscEiMUq82262PkyJIpHgPQeQSMoKm1iiX8A0kwZ+ZD+bH5IZS1rHbBy0/8K8BS+RhhnHqcmALqsDSSjTckhcr4v1z5qZAFs8TaIJTfV25IiFD309Ng+mR6hTXlkdQ44UI6AOc3dWUmSFQWw6fp2eyWqrs2ACqhHeK1cA3mibYBO0xgvhk4qmNxFEzAcJHKkpYtiIXaT9v/sNzCF39cMBrtP67HKrZGOWoVcuG1SW+3O8eg3pqShdl+tzB9htt9M4kMoyMkr0MY7iR5iZbYy3V28UW8XrlMKfrC7wLo
 tS0AgT9O
 cTgVGi7+93U87bUYzVJHHrrwDsvIGjxlLRoAcJ16T7K1JRgFW2Xohu4P+otm5h+DMyq2tZ7yTU7F262QcePCpxH9EedOsCa1J/1a+oTXXt41eUnp4RaNL4b1FInMoR+206N1IrkKSeJ0B0TIc+9QRlYpq4Zi8bAVUL51pBYGNoOMISG19tDX6FvlQp3lrJCfWu5WQmPDauGaVgBeqdzw4e09wT/eFvmB3XR8L4mC7IvgSPKLxgnquHSxh1gBanTHm+Pd9W6KMs+YF1I8dUdxvQGT3jIJAWH+YvDmZ8TBV8bC3b0Mro7QDUyFbeHrwVPRvF0E51mLsm16LnFkoP/D5U96v81Ie18UpdOjI2/YvWf59CuLDMjucHGrlcVFygz7m5PkOjJjRNkKzHzz7xsAgkP7AIHBmVrWH2wfD+sMFoJNS8GGfZ5cBJ7uws6US437hM3Qi5ynLBe4SeloL84hhnm9TnSiw1Vcrmhlu8t72TmAPum3s0ykUc26cJn4iyWQD8gN5ftGc/LykYQHKjC6/dQzezX3XdGQCfk4Lo1Ae1kB6esjE4z0zFdFuNMX8cwJw68LM74dESvfTdx0Ukta4Zevmw2r6kWDFNDdnaCa5O5JE/9zoYFdKAQKAqSHr+3Em90oKccFptMWyMOI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 1 Sep 2026 11:40:31 +0200 Michal Koutný <mkoutny@suse.com> wrote:

> Hello Joshua.
> 
> On Mon, Aug 31, 2026 at 09:37:51AM -0700, Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> > Before this series, each memcg had one stock shared by all its
> > page_counters (memory + memsw). Now that the memcg stock was folded
> > into the page_counter level, give memsw its own page_counter_stock
> > so that it can benefit from caching charges as well.
> > 
> > Note that while the allocation is conditional on do_memsw_account(),
> > the freeing is not; the freer will only free non-NULL stocks. This
> > matters because do_memsw_account() could have changed in between the
> > allocation and the free.
> 
> (Just a passerby comment, I have no remarks to the overhaul.)

Hi Michal! Thanks for taking a look at the series.

> The change of do_memsw_account() is because of re-attaching the memory
> controller between v1 and v2 trees. That's not so common operation (but
> not ruled out), pre-condition for that is that there's only a single
> online memcg, namely the root memcg. So it needs treatment especially at
> memcg offlining (which is what drain_all_stock() (also) does).

Wow, that's good to know. To be completely honest I dont have much
experience with cgroup v1. I didn't realize it wasn't a "switch whenever
you want" type of operation. Good to know that there is some more
guarding there.

> I don't know how expensive page_counter_drain_stock_async() is going to
> be [1] but the v1 parts here could could be guarded with
> !cgroup_on_dfl(memcg->css.cgroup).

The function itself should be pretty quick. It just frees one CPU's
stock, but the rest is just scheduling a job item.

> Regards,
> Michal
> 
> [1] Now, I see in 5/7 that there's the counter->stock check which should
>     be quick bailout on v2 (maybe quicker than the cgroup_on_dfl()
>     I proposed above).

I'm not entirely sure, it's probably similar : -)
I think they should achieve the same goal, and hopefully it wasn't too
difficult to understand why we don't have the cgroup_on_dfl() there.

Hopefully the rest of the code looks good to you too. Thanks again for
taking a look Michal, I hope you have a great day!
Joshua

