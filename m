Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7839C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 07:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7ACC6B0095; Mon, 14 Sep 2026 03:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E50CF6B0096; Mon, 14 Sep 2026 03:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D90446B0098; Mon, 14 Sep 2026 03:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD0926B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 03:48:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F23B81C396C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:48:32 +0000 (UTC)
X-FDA: 85211590464.02.B1096C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 519B8120006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:48:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPB4CoCS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789372111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RESuNQUKZgqmJNMbknpLT8POXLSUN+8DRhun9jrOVhk=;
	b=CF4YmxY/6is95qinlf9BX0Yn0lP98ZwnLN1de+4WnSuEPTuaRJbhPil0Vo61JzgLQd8RUs
	RA1M+Pc4MXQ9yxG891Br0BUEz47lwA+kjlwfhHhJ8mDsOQf1looI3UTJlP6subkcqT8qzf
	sZCM30meCghSRmTXMb5UobzcI0viKLs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789372111;
	b=EsmCy+ZMmMJOVqr+HXqV2sILD41tr9YqDMbVcOevgBQdC7vXfAXJNdyhqgF+OF0IJu2zzc
	i3dAiqdVgJ39toktZYnfPc/Upd6wfpGO8WOpBF1VZc22wgJyecrnAZp/Q+E9X40h0OiCoA
	qj6MJUhaEwbYMruesR5JKSftanyjsUo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OPB4CoCS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A3BE4403E6;
	Mon, 14 Sep 2026 07:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEDDD1F00893;
	Mon, 14 Sep 2026 07:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789372110;
	bh=RESuNQUKZgqmJNMbknpLT8POXLSUN+8DRhun9jrOVhk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=OPB4CoCSQXQMwjc4/kQbLp9oJw/ADZnF4xQX7WylqQDRXdOGfX6dzStIDgj3Sozsx
	 rwh3/JTdFukyIkZ/GTiHky3kVpGnxI3RsscJy9NPdEh5DqHzBn6BdodBmDWeVmfgv8
	 rnU8kAg1ifc7mk/ljWmNOoBt3mEn2qCV97Ww4fCOOqWWytl2DM4x02daXvgHof7TPZ
	 ZNU5WpkiVc8BliAonk+xAyWj9otZ3Hd8aP/wxVOEEqc9SOWf/1xC7Oy7TxyOb2do8Q
	 6XPx+f55fVSXQoS8wDI6jEbXM2ia1SwN41WnZ5oc2eA6/469ulUmlsPAsIgzmxOqFb
	 0oV+hP5RxrSQw==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 03/11] mm/sparse-vmemmap: open-code
 init_compound_tail()
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org, 
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20260911050228.58884-4-songmuchun@bytedance.com>
References: <20260911050228.58884-1-songmuchun@bytedance.com>
 <20260911050228.58884-4-songmuchun@bytedance.com>
Date: Mon, 14 Sep 2026 10:48:14 +0300
Message-Id: <178937209456.4188640.17384001721839433827.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 519B8120006
X-Stat-Signature: or31joqyhsa4qjuuafmbmfjd1zdc83q7
X-HE-Tag: 1789372111-977004
X-HE-Meta: U2FsdGVkX1/RrlAuiZKkllNAnv9EytnEuJPktwNOuGoaH7MRKi9TP6cg9qDJp/i87gCKD2m4268NfL2p4F+JuN++VAqgyNUYoKtFiLDyeQvrYuvYL8rDK6HW0+agxZ4WEU10COFxe9KAAe+qEyX/pwucGGUuLiBUuNdyGuwSEeecI5bx80oB0fuMUFevoO/YVxUNZaEO0PJ3mY3wRvvjisTwUIvT0oFMuCs58SSIoa/TOFajjrntDFvApqsOwH6bVmurejcj/DwFBGgfDTdfjNcZy15IUfnZtdnmWUpk3DVOrQuZH3Hi3P2RBZF1QTIhcDcdDpKybcC/cXAd0J4UaDFEW1NMHeIcvq36BhL+yA4uVIJPGlaVSS9dTLsgKO5yCy0DYp3VHEm0No03/6R7k65Jen0E/OBHNm3cCCvjExPGhqJaKysMjhgZTaV5Vh+gXBURyvj+j3DA6CANhURDkxC5VgSJhMe7noPqnmjlbfFqkE1jGOk8zMMe5CgnK7iaoj93inXrzMl1qACv6C9KaI3lnWNSpGlZw+tr/y7U0XHpz9QDJE+6cNAFFxT1csELRfuFF6OrySGzUt37cIgH/GuPqVQ7XGVUZdTNtd0XmVCZp6HTl/gd2U5z/PZ5pB1IXPW8dx+P0YelcQhHpR14lKzh74Kuqt81MzN9Iyz9vP0LsBpG/7n8BRmpGX3kt++t4v/BNR5nNskE2Ycl/y26G1XAfqvRpSJJE5t/XNF9HKcgVagKTYf+cmr/+/pfYejG3HPRchWdCr66Ng/wNmUrux9uKDH8uZxEm5r7sGptoJ6P62+RIXDVDiDvVQM0ZNJSpRBwFVSktXoatNTP57HSeRDQ3OBR2V/2aDMWCNibfWWz3v5XHg2eUEl8ksYduXwfrqhtmGfoDAslPNJCuh6St/xo75vgOy3Fp44JKmFiZCrdHvO1n06ndSPESO/J/islUM+bjrnvhPZBon4ME9C
 GAdzYdgz
 GL98qYi4FOYJgh67K0g+j0ni0gZD1Ux/dCEBPtU678ZVIBa7prllfK648XYFrLH3sfr/muzjOMpgka4lD1ucNsqtJHm1OMk6E3vAmBOwqYrntkVgHSq9vOmKN/O2eq9w1bL9ZJ19nBhrmxPniol1IP1nsFQ5YBvy4cytGOoaACeVv8kkycCZ4QPe2HJ+JKimuziWyYqMtldJraiV/w9J2RPqFYGJAPrIDAawl8XofrNhaJxQAtXliyXwjUarfiQk2AWc5QFHiut5Qlve1Pld0CXeTYDjN62Hx9E3FWDkC0yNRdj1cNfaePqzkng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 11 Sep 2026 13:02:20 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> init_compound_tail() is only used by vmemmap_shared_tail_page(), where
> the shared tail page setup intentionally passes NULL as the compound head.
> 
> Keeping this helper in mm/internal.h exposes that special case to the rest
> of the MM code and can make the NULL head argument look generally valid.
> Open-code the initialization at the only call site so the special-case use
> stays local to sparse vmemmap optimization.
> 
> [...]

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


