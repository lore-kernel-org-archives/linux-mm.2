Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8825CD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 18:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD0816B00D1; Fri, 29 May 2026 14:12:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D816A6B00D3; Fri, 29 May 2026 14:12:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70726B00D7; Fri, 29 May 2026 14:12:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B17186B00D1
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:12:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B8C58CCAB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:12:39 +0000 (UTC)
X-FDA: 84821252838.11.8E5D847
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 94FE51C000A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 18:12:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UecRj9nC;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780078357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=WjF3Brf6cRxJkzPL/ipfulgSkES6dK/SaDc1kkuFm9w=;
	b=fKwIaL6smH6lOg/N9R7S9eKtF9RCG/Qzni0wVFdicfRHbWZ0k5yV8lsLXtzGYl3Hijyg4s
	XBauxmqW4pZb+RZBLHqZPMh0VQNo0Prf3B97xfKZk9kW01ep/ZhQKbP8hz2eIEIH5mlhyn
	R5uoHM65eqr42KDY9Z4KNR2hHUE3yxM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UecRj9nC;
	spf=pass (imf20.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780078357; a=rsa-sha256;
	cv=none;
	b=ztWB46BETLGb0yqq8KPw/M4zOSWJ22THdiVQUq3QcRm+1HdFw6GBv4cfJU1rS3nIw7hToh
	+VRHvSx7uXs7paKf0xwczv+VUIqruaq07ocffo9UCKIVAFYqxf8PPYaPqalK2J5gIyuxwN
	KqmzNj1/PlH7hssdVYMv853CLBVRiE0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E895E60136;
	Fri, 29 May 2026 18:12:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C6141F00893;
	Fri, 29 May 2026 18:12:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780078356;
	bh=WjF3Brf6cRxJkzPL/ipfulgSkES6dK/SaDc1kkuFm9w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=UecRj9nCTx6y0yJqMUOAJoOTqbT9S71bZ/5V6yr5lUgZLmSRRZ+b9yZ32/KlvirZF
	 2D+cZ98qJc23CtZ9PRjAUBJ05fv1yAGnSt4G8o4qyhI5QjO4amK32O1MnklaEoPG5F
	 0rhA0SwYNTPzDsqn+5qjm81KTsfzrLPwpSndxwYSfNyT5+Uca/5J2ROvfC8a43rwOv
	 J6Eu/RvYDqKD4e4ABWzwPqZ6GI17kHnR+mUPYsupQCGdjiIsdJZgofv1Cyq1vnsG0w
	 xm2jCd8A1EbQh6ovD04PtWDhkOfsswYua4dYZa6gGkWJyPK5z4Xh8hbKM3C/OlPknV
	 HXYPui3QG45FA==
Date: Fri, 29 May 2026 08:12:35 -1000
Message-ID: <3901fe0537edee9d7acdfd91695ead28@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: David Hildenbrand <david@kernel.org>, David Vernet <void@manifault.com>,
 Andrea Righi <arighi@nvidia.com>, Changwoo Min <changwoo@igalia.com>,
 Alexei Starovoitov <ast@kernel.org>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Andrii Nakryiko <andrii@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
 bpf@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] bpf: Recover arena kernel faults with scratch page
In-Reply-To: <DIUMP21RASZI.2VNQV45RIL209@gmail.com>
References: <20260522172219.1423324-1-tj@kernel.org>
 <20260522172219.1423324-3-tj@kernel.org>
 <7fd673df-22f3-4d70-a779-ea0b878188b3@kernel.org>
 <DIUMP21RASZI.2VNQV45RIL209@gmail.com>
X-Stat-Signature: uk5it7mfyz5bnoz6nkfc5a8toqewnucb
X-Rspamd-Queue-Id: 94FE51C000A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780078357-718996
X-HE-Meta: U2FsdGVkX1/PcGOPVU65JisA351+fwDEnxMZKqBEyH+Dd138CpOkR2rAgWswmJxL/wK+M0wAln9b8TERJkjzZoG9HjQIqaJH3WybShcdV2IUYke69uIpn2tQ+KNesoWQNonmyB0X1/5h37KNAFOPc+T7F2psHsI++6N0Vs1NkB0Q8wCMwwpIqNupJ5PhgDZPksEzcw8WU755dvEnFuh9foxYo9nKtGfI0nr/evRtOgUFbpL82zDHebnav7bvvNLh3ioD5hD64vdYU6LlYYgIoob1c86gqNRH35FvUUIwPTO7TEr97EkKaNRQsnLyUp5xNZk7YYg6MbrvWiReaH9jZbacqx+ZXJPUbD0EhuvfNe2OiSMksQWzRMp4/xLLXm7X+rDGoSAw+CKAHoMM/nSBL9vyYzWOIukNsksVlwLw7x8ckLauup6FFpLcz3UI9QErLjypKsH4RS8OmZoPnf548mJZMMc56U2fS8Ud1MAykgC22M320Pop6b84O4k5ZbqdXza+jE/Y0ICC0CRvydjEmRHpV7rqgotsQQZd1pQkqcNRqdcCeSmSGfOiE+bkfomvNfZw9qLbUEkLppyWVdZ0FYBZEZ1zWdPrfIcVZ48q2Y93zCRUTwnP0+we+4WnydcoLHvgf96u8dIU6vZIh6ARRJz0C09+a4pOtHY39cHK20pGIoBU+k91V7HC/o/TsIf0uG/9LhnfRl2ueMIklgaqHejZ9WFr/Fn8rDzuvDkX+STfbVgL+snC8U/oGtCHM6ssOPj/ObsBDBrjTTl2aI5INBA6ybkzlAwnkEu/86YmI3Vhd6Lxbe7wgq4i3EHSw8JlR7fLZ3mwLAvbFAW1aeuvH6uBOk16sFwNYf1wsIMGKZzdDXYdrUuwJuvR/mII3GH5tQfSwj1cufpH/ijy3pYLTkOPApFZAMgPfv7g3SRqupBFddJjJpSTVNTYKVxp/lshiN+PuHjItQ3Pfh1XWUm
 qFLTpKjz
 U97zMC1LQ/ELYxVvn8qBaUmD9HHRwnpz5kXs4eTwH8I5LlqGOO8ZdPuYyfjqgiK3nZpHwKbo2ifHPpGCRufrc8qennqTR/clVN4tJ/INfS7Qv41KYi5tBVkY/7Jq2V2hjiOsY9AqlIZiCAl9yURs61XNkZUjiJxQKtG8EsKEoAVJ9vpYmqVpsP5lHdEMn1SF2POyzgzr/FBu3heTlfC1z6znBCGx4PJayYYj0HWdpSy+nuZ0qWuicYVQiPvMBR+5H3ANt5tJeQ7pw8AC3KD2Si4pSAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

> It should do set_pte_at() unconditionally.

I think two concerns are tangled here.

1. The racing write. set_pte_at() and the scratch installer's
ptep_try_set() hit the same PTE with no common lock. On x86-64 and arm64
set_pte_at() is a single atomic store, so it can't tear against the
cmpxchg, but a plain store racing a cmpxchg isn't atomic in general.
David, is that the worry - an arch where set_pte_at() is split and could
tear - or something else?

2. The SEGV. It's a BPF program failure propagating out as a SEGV. Maybe
not ideal, but as long as we surface the BPF error properly, it doesn't
necessarily seem broken to me.

Thanks.

--
tejun

