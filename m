Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D786FFF8864
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5AE6B009E; Wed, 29 Apr 2026 23:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48D7A6B009F; Wed, 29 Apr 2026 23:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA216B00A0; Wed, 29 Apr 2026 23:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E6246B009E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:27 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B713E1C051F
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:26 +0000 (UTC)
X-FDA: 84713784372.12.D3A94AB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 33E8740003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UjAkF/lB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmI7cTCWimUP59Uw275C2nFWoDGH/tSc/gEFyebouD8=;
	b=MYgsx/eA5raI3++0OxRi70QiHG7Mgje2sJBYnb4N1O7+1GyCRVHWb1P2pRMq7FMkpX0BB7
	bvWvk01g+PGaxuDImgKkZ+RAkNI3mV9MauYHEpfILomvFeu2Sr1G/Wx43mjVL/fIHsPPFi
	YyjGa5JPh96QbBerGAsFLW2WHcWaAJc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519585; a=rsa-sha256;
	cv=none;
	b=nKriJ1HpJ9GE05pWwlOkBj+Kxz8s2UY0XatlMJ1ZwkOhILSNv9+IRV5wern+QXz1ZOWA+N
	RS02liAawa+AoRR2c6t7VSpOVsGo9HPfeognye4HlKDnCyLqpZBGBqRrYN0/IByDVkMWaD
	JjyLTXFq71f7cSkrgVrV9UkBNgqum5E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="UjAkF/lB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B319461143;
	Thu, 30 Apr 2026 03:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A6EC2BCB8;
	Thu, 30 Apr 2026 03:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519584;
	bh=YLRZtfFNTmgVRKQzL/ebIB7raBLyFWP+zBt/tIh6/gE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UjAkF/lBjBrztJbWPv7Nv+P1UQwRCadHgjZmyc0gOUgdshtZuG6fNVk/6qLysPWxN
	 cz3t4kVUzVaOpLfzu3/LvCeUqmfdQT6dbyfvFdGZNQHqe7dDD+3xhXDuPWm/HOBP21
	 VsujrCdKA7P5NzUJawotOUV3pfAKyP5Yrx/+iF+rLLBRmw14+ARbGsY7rcYMIaN7wf
	 gsJtpuEKSJ0kv4CkMyk1WFaP6qzknZqEk/n17a9tgeWy90WQ/ridNgrm3bd19S3mGg
	 5rq7JRJwBfVmOzhnSjH+krjZbWYqvNs94J4FiTD10T46AqKz3xXRixPmEAalrrEVRf
	 TM/g5vnXuYiJQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B9E993809A07;
	Thu, 30 Apr 2026 03:25:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 07/18] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751953941.2274119.10364319398429839294.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:39 +0000
References: <20260227193030.272078-7-kas@kernel.org>
In-Reply-To: <20260227193030.272078-7-kas@kernel.org>
To: Kiryl Shutsemau (Meta) <kas@kernel.org>
Cc: linux-riscv@lists.infradead.org, akpm@linux-foundation.org,
 muchun.song@linux.dev, david@redhat.com, willy@infradead.org,
 usamaarif642@gmail.com, fvdl@google.com, osalvador@suse.de, rppt@kernel.org,
 vbabka@suse.cz, lorenzo.stoakes@oracle.com, ziy@nvidia.com, bhe@redhat.com,
 mhocko@suse.com, hannes@cmpxchg.org, corbet@lwn.net, chenhuacai@kernel.org,
 kernel@xen0n.name, palmer@dabbelt.com, paul.walmsley@sifive.com,
 aou@eecs.berkeley.edu, alex@ghiti.fr, kernel-team@meta.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, david@kernel.org
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 33E8740003
X-Stat-Signature: 4oaaadjbykpj637kc3copsiam31j9qix
X-Rspam-User: 
X-HE-Tag: 1777519585-575590
X-HE-Meta: U2FsdGVkX18i4h49Ta+cyyTIGQGV10b/u/NOanicLF96V2nHdI2SC7Rkm5xEP7gmx8phAofk44gxoNesqA76eFsTbqNlmkVpSGFmSs71NdFfUTEL/60rLIcYUgUSc48dD/1vN/1f2S2Agq9WINMrR7153D0ntbS8Na4TdTUNGUsygDR7WVt2yac3Yi7dafoPvYUqUtRIGOE7uOz+db3KQF8lkikJUPL+8xZpW80ThPNSMsr/8FEKWgSL9jMG3b+dAUshh93vYv8OzbkuqAdhD31K5+xvK8dQjyXpWtVkuyjJytUMaHSscOGHEGsoADmyxmq7RDgLWW56R9P25h5ZaANEnnFOKpRUd4/1/odLl8w8xkpUeSYd+ovp+uYLJ6M61WnwOhazvPWoIuvfW60wuMZJAwg3W1KkkkxHBUQKlzZeKdgwE2tJ990w6F6yfXNYBYx1vPvgGW39wPjbJg7G+jpK1HRTeRRB6odECJ74nkIwhy4kS85LbEKGVccYIZwBKfsdtpaXgOQaS/1PGexi0yII0uU8y0LUfS65eEsNriOp9SLuXpoLJ3S8dNB6g2Jfyzo66yQJuYI822m4rOZpgYCXBR2ZYg9QJx+5kLcXSlvr5H4Ue8K6RGAeQljtRIInDzNWWdHwwuFGd1RnU7oL53CiXoHM9yXCqQrmjvzwi0OUatG+sihUVGLBj3mcdmCoBQiYTpI02GrZ6uiBqtfDMkL7FQuBcUPT7r0Mipgnv0d6Oxx+JmsJMUakdABlAUb++l6aJ+e2Cwhrfc0a0h6NGGwVTnuxQwP+Pr8n6qtHZcbp+qLqBsPSuPTeMwGfeP6XrDOsQiQQbl+4NIXdjVdmjtUwWeWH7eY7qanq+catZq8CmZqXmOPtBFeoufxZr5rAR7DKwjzXXgmAjlKDPqK2OY5xYI+eXWLlzltx1vpJHuO3KnwKpabl+rxcgCKNiGpZDgcbDYrcxqetKDa8SNQ
 RDfvICH5
 D3NvcpihFD2ozVWEMRnab6+jtAlMRMm+nkpyU9/S473xKT6zQYDYNYFFJwbZNc+mMahiwI1h7FLneo/d42ermaOUf2ECvSnZQFf/z6GDa/qRg4rs2dDRp0W17SziPvbXLWvGBaaoT2mDUpTe1zJa1svPCV/GOFL7D3TiJHthYIVo7xeTEeXHDAg4sl0CWNzHX8a3oEbL5q4XyXWsOJgWiEjPhB1j7hGnsXaUowRXpf/5gK3tBPTtkBt2eecpXBMwVuZ1ryAPHuOos6p6JqqB1C1Qi3em7zmbRRafkTAuLPEaJkvAYFpP+7WTkaPLwmzY6GIgXRItXHKlCEhHbHMmBnChzP5bTyDDF7bB2HYORMHreF2je9xjnkw9RCyqnkji0wGSBIC3S4Ahh1MB6ttxPf1xEPelTnaYpuPyvzRwbqrzXma51NVrer646S28kKU4UNR7d33g85DpldcbzmSoXotLQmiLaM8EKFtRQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:08 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> For tail pages, the kernel uses the 'compound_info' field to get to the
> head page. The bit 0 of the field indicates whether the page is a
> tail page, and if set, the remaining bits represent a pointer to the
> head page.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,07/18] mm: Rework compound_head() for power-of-2 sizeof(struct page)
    https://git.kernel.org/riscv/c/8c846c879e22

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



