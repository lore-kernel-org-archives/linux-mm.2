Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0985CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:34:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541776B00D1; Tue, 26 May 2026 11:34:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519776B00D4; Tue, 26 May 2026 11:34:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 456A16B00D5; Tue, 26 May 2026 11:34:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 360126B00D1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:34:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 008A61C0203
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:34:13 +0000 (UTC)
X-FDA: 84809967228.07.08DCC8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 68F664000D
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:34:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Noq6FzjX;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779809652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IXtklErhcuWlv2r8L97+xvorQ7UpGoL4ZF+VJDkPygU=;
	b=dBMvPy1a4apA49m1b11a6eteJkT1uguXlXaorU+TtpJ2KKOsjatBahrdxAeGiAzCpN9yy2
	myOASRLQwT2edqCmioW4TMh9uy1T2i5RzkSIwKXF7Mkz+7fErFFC2/LSWYuybPy3Zshs92
	IQZ3vAITDUwy4C0xQyFXw9aBMDPR6Is=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Noq6FzjX;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779809652; a=rsa-sha256;
	cv=none;
	b=e9jfPjeF5u5bXGjI/gpU+EZ9vMoQUqSLFkAAs9k0YSlrifR5D8ImukVRa4HP3LPJ6vFfN3
	mf/mvOWtIEwXMpbjbwhEXdEiLxVg7EuV85CIc607aCWkeyMe760glWWeIA9hwtvJERP1Pg
	jC+eqJ3xQ3iK2CIHO4/cROYgfDVPpVc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 986D34362A;
	Tue, 26 May 2026 15:34:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5FAF1F00A3C;
	Tue, 26 May 2026 15:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779809651;
	bh=IXtklErhcuWlv2r8L97+xvorQ7UpGoL4ZF+VJDkPygU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Noq6FzjXAHednyJbKDsO7gWlmRYH4wZD0QhvuTN+ag2i1VdurKmvBGP3bOfMJCqvU
	 8kjwZvotf99uxGidiSuhzx7jYl16j0j9D5Yy+Ia0rEVFPucuDOg4YzNa4k3kD5Caql
	 cOvHKMZEdCkn6xBAgqAbnQEdTy1mWt1ZyuPL6nPS3yKF2BtW7gtEowzkU10F/6E0sj
	 qQ72PTZCTU8zRN6nz5ooPdaaDrJoW5P+Y3vgo8M1qA9dygwm5nF6SDZ5t2jHBQrPRo
	 Mw4mppN1KUMAVp0SjeJl63QoEfTyTcLoZY3AGxngefu9qBzd2UnGgPGypTmdUHd5W5
	 d3hKUeNpi6bxA==
Date: Tue, 26 May 2026 16:33:56 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Yin Tirui <yintirui@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Juergen Gross <jgross@suse.com>, Jonathan Cameron <jic23@kernel.org>, 
	Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Peter Xu <peterx@redhat.com>, Luiz Capitulino <luizcap@redhat.com>, 
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, "H . Peter Anvin" <hpa@zytor.com>, 
	Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Anshuman Khandual <anshuman.khandual@arm.com>, 
	Rohan McLure <rmclure@linux.ibm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Donnellan <andrew+kernel@donnellan.id.au>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Baoquan He <bhe@redhat.com>, Thomas Huth <thuth@redhat.com>, 
	Coiby Xu <coxu@redhat.com>, Dan Williams <djbw@kernel.org>, 
	Yu-cheng Yu <yu-cheng.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Conor Dooley <conor.dooley@microchip.com>, Rik van Riel <riel@surriel.com>, wangkefeng.wang@huawei.com, 
	chenjun102@huawei.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH mm-unstable RFC v4 0/7] mm: add huge pfnmap support for
 remap_pfn_range()
Message-ID: <ahW7rut_WP17KADW@lucifer>
References: <20260526145003.88445-1-yintirui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526145003.88445-1-yintirui@huawei.com>
X-Stat-Signature: ekhnh69b3wiyiwhaci14getqh3h7h95x
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 68F664000D
X-HE-Tag: 1779809652-815638
X-HE-Meta: U2FsdGVkX1/1GhMJ5RsglvGcMEgFPKLlDOXiJyOgDarnKUocK/QPhxbkoPzkYi1GE469rPi7pFXDov3zrs637lG3d/RTZOEx7MUxgcfHfQDyvl/yoZ8BypYFaJa9YNx0+MEL8asR8RSj6Ehvo7uDmc3vB1VI+4RXNraYvm+BrNRVKSnz9BeCqvY6cJwfgW4rICXYqDo3R1kbSsEL3+285g+zkT4ygf3y9OQbeE33tvIRtm/MXBafv1MUZA0c0AX72oV4qiM2lTjOTDziV28NzhgcAzjUpRbrgdGlunzaM4goTb8QSoTI9Ai8FxIu1CJN78nrCApE3asKVYkSFCsSuYTdO1dBBn3hkzv8thBAuRUzBHvxPXWFfVblvo6zPlRPl6n4rgQPqzGe4yMubWFreIQh++ol6HMd9UUhTRNGtvi3jD82M5E8dH2iBPzPOH6pNLcAFgENGvW5yJFCi9P0/zKUCFV+y2vMz/nMIGWbfvjpQLNIxw+uvk1r22CeHnso6Rhie5ZB9yEcDR3DvAbW2W81uu4Ms1qKdVTlFqoX+4+g8WfoYaRwVOJIrGp/z3cpRllWeNEiIJB9HEMMQZoShdZdrCu3cbU37raTE7dvenRTFNZXjiiy1fqZZDw8TT6Gi2e95mGjPJNDkA26Aw2pLB6eyqsToF1tBu2IZ6QldFwK61npthcHg/gaqIA4xxM88XEEZTawcYRtxVHKH/sqvV/6wmG2byvvNkTZIHAyq7IGqcTr7Rode26w1MwlbdTjh+V+SQtnbgAiUrleoFCh+Xu7tEHf/QZmDTP3c/4TMQH2TtHp2DLto+G+6PVgB3u2aGEASj5BolGAhmCh9mc0A7p3e5Sg6b8hjkRHrIxoCUEYhx2uxQlWVEGzFSvjAF/IGILPmZG1DJE89KO1P9P1v0/GGohNppb7ahLDHQnrgl5v+O2x3RFHgAzh/UjNgvbKjJNJ6F+/uyOKdLYFU3u
 LJUJYjko
 YtpVFpiFWRgnuxfbkRDUoBJ5Q1Wicv+vn50fPvM8sDSDuo40CNsVNZevxEBPBCxY04OGIJsi3OK2WryJkkWkvN+d9MqRIn3TfbSCLTQ3LV4RHYlPZJVvq8s89fyuhHpIi9K1qSuJegbgSMc+ppp1L7uH3MChTd15h0IKW3cx9nOQSynWEV648hsggfG+5BibnPCaEWhHhLyI3layffFkMOE0YahJ1KtnD4gGlyMm8pDXtM1mDwUUxfc3VLriPg9VLLRWgu0NlCTQFdzJTRqTSgKN6yGFnB4Xnfu2Ob52/EY+db+FVVs1IsG/BdzPZdr73XSd6bbG5sL2tJbZ2fa2TCpfq21JItQaP1w0MslPL8BKEX4wA9QvGijUvJqM+L3I1agqSw7T4f/7Jm7+NMN1sFLd753QzidM888SXI4EzRBmKxwnBzwexM/+vVXN0HFLOzdV/Zb41QRo8RKg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Allow me to be mildly pedantic (sorry :)

One thing I'd like to highlight here is that remap_pfn_range() is, in the long
run, deprecated.

mmap_prepare callbacks will indicate a PFN remap mmap_action, which will do the
heavy lifting (see [0]).

So perhaps worth referring to 'PFN remapping' or something?

(Since we already have mmap_prepare() in use, it's also kinda inaccurate to
say remap_pfn_range() :)

[0]: https://www.kernel.org/doc/html/next/filesystems/mmap_prepare.html

Sorry, this is pretty nitpicky :)

Cheers, Lorenzo

