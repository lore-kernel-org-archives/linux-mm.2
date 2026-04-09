Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D68ADF31E21
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:11:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410906B0095; Thu,  9 Apr 2026 11:11:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C1536B0098; Thu,  9 Apr 2026 11:11:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE786B0099; Thu,  9 Apr 2026 11:11:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 228946B0095
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:11:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C14A58C044
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:11:44 +0000 (UTC)
X-FDA: 84639356928.17.7ABA589
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2D10B18001A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:11:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n7I0kteo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775747503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmhpeXRFnKDZawMaN4TGSoZ0Kow/RbxIHzEqGbCkBA8=;
	b=zsG7pbmJ6nDM88UmjgDkyf/QN6yXT0Kw6p9VClYy85+dkfTivjlAql4J9GYQRofLb+DL5d
	4h6UdxPEvx68q81BpL68uZbiH4D8uiiJvHi6Bz1SotRezUe2NxPsm8o0BpLwG/lc070has
	Nf0hlYTsyTKBosk6RrQb1wh5kdp27n0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775747503; a=rsa-sha256;
	cv=none;
	b=09Mzf/yYokygI9kkLtkXOuMIpe3krHS452CN+rxj2wZWTzCTOvyRocZ8IRX+Fz5qx10Wbs
	nMBzZmfrt/RHmlrRsaw+9X8sY6L5A0bFXnnBrx9bYUkfBS+t15obUXB8PlIWh+P93tATz4
	MogzoPqOEb+n3mQ/mW2OavLJWSy4ZA0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n7I0kteo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A91C260125;
	Thu,  9 Apr 2026 15:11:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D58BC116C6;
	Thu,  9 Apr 2026 15:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775747502;
	bh=KFCI6V1rO1y+xOef/LA1LfimklhqeVXX7IveWVt1pR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n7I0kteoBfVBAO4NM+dn3SiWgNPYH6WufMcI7EfNaUzOSVb62RGST4az+Oy9VXVCy
	 KINxPsK34ExMnEypjO5Hmxm3BQB01JZ2AKZq30Rq1t3QgQS+dYwHE1YnwGp3fKGMym
	 9artXLDZNPjS6t46RhIpbtEHfpY3rYEDKBNsvMkOIgEFaxKbiDyZaLRzRWs4SvN+k2
	 uqfmHtkPaVVjqecf6/wdMT39JqZ1S50nFcgrpgQ+L96s9ZBncM4kcTQ1h4/0Xgir8w
	 Bd/tSati6bvFhu3I3D1eizTb0gp8XutMzrmWvf7tKQWdBH51JqSU7XD1woZoqDaabZ
	 2LFAuBdKpaFow==
Date: Thu, 9 Apr 2026 18:11:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kho: call kho_kexec_metadata_init() for both boot paths
Message-ID: <adfBp4WvhKDv7aG9@kernel.org>
References: <20260409-kho_fix_merge_issue-v1-1-710c84ceaa85@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260409-kho_fix_merge_issue-v1-1-710c84ceaa85@debian.org>
X-Rspamd-Queue-Id: 2D10B18001A
X-Stat-Signature: 6uckd98i13jjuuxd841jctsmjdjre3m9
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775747502-410576
X-HE-Meta: U2FsdGVkX18XqbpUF0KE8Q7c09lSThvVSjk7Q07xln7ceFNB6PWfrVW6DnCuVK5KPDtc0scnK9kzQtn7ncAVycBKwRLe3AjYpAol0oxEFoTbFgPI5k4xFjuuSH9zxeJzVlVSXtiHS5utx8URDr25ORJqk3sR3e8bvMHB/Dikrhyk6wBI03gFeArmfs90Qs2gbWd1IjxjXy4bFC6pTc7BHchos+FpfBLruBa4fYppffSevJMwAU6FtOqTCc8a62Vw5Erxw9cqIY+aYMJUv1IUVC0rCI+hP0/ltc5uC5HJaduRomGg/ef7qcpUmPfozJrOFKGXpYsxs2TSrCmDCMngeKcYSxanCP3QAsjHQF/nKOCNFvfc9H17sc2BnxBAipBzHkbtvACPu2jA2RW4F7RHxW2dYE0xviyu3JOksA4NrgdgrEtkPa0nxMB8CkereGpgNRNehrQ3yK9MvfMDVr7c2vPMqCIayCBKsl6lCVQwxTIVsTZJ9YdSbpYjTKR0UJnTO6vEOcew9QGTqOHYja3gs9xhAqnSMS8Uu3FsZ7fubkndy/HJZ1ndDFOSeKbI9dAPeq6VeUshho27y+qq5iy2OQV3W6YO1iJHQ0Ei6GpRq6mRmAAGtpIiOwagV6g87wYnziEFhpf7eJ7Md8xG1QAaKyiC5omui8ms7z6CCbPo841K0ZixwmEONegcQFUz4PAOljP6LCcQCmE81nGrETqcxPVGqNDP8i10sUJiaPwK6DinWZTVlQWd3qwYecVJMZyvbVrRrmICRB/KJPQCQvfrcWObTwFu7tcXCuh66z29y3qiTXc3oEHIItcEm6yOZyG+IZingh/AFaqwU7cZTzvmZQxAPBNhF/P1sar8DTCw671Rwwy6TaxvnrOVddInzo63akWeNXx2wC2k57DGq+ZQNzCETIHsP2352fRCTglkLMp6Ijzm8j9nVVr/DPao8a8XQfR2s03AZdJhE3QgNzs
 WKtzYjmX
 /QZfYeQutT38TgApWgVO0MENoGIYfkkCCQpVXV6U0MGSIwicKArYzMsH/uYK4y19b2T4Z2Jjdb3KtSBLIwIyH8EDcBpLtKBqr0gyY5gvvXGO0rqyW6NYmRm4p40dmTHcpQwi9tm2CfXxjp8wyG4hx06Q6tL2fpf6L7etgI6DX1ADy29qAZNCDDEZ00LZ2gDCiYUc0RK/et8sygfbqGH2cR94WYJ25PIMop1hC/QFelldwxqNrY/oRV/caTNYdfvakeXmJf6C3hI6yku6est3II6EZiPgyz5jf++02Ph/iCU4wmWF29PnZoTGiFu9dlQD3nS2CM/oUTqp+Goox5DOzufyiM13aclGUU7zh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 03:31:40AM -0700, Breno Leitao wrote:
> kho_kexec_metadata_init() was placed after the fdt check, causing it to
> run only on the fresh boot path (no incoming FDT) and skipping metadata
> initialization on the KHO restore path.
> 
> The original patch[1] was based on commit 5c9e55fecf93658 ("Add linux-next
> specific files for 20260312"), which included commit d7176a010afce8
> ("kho: fix deferred init of kho scratch"). That commit has since been
> rebased and reworked in linux-next, changing the code flow so that
> kho_kexec_metadata_init() is no longer reached on the restore path.
> 
> Fix this by moving the call before the fdt check so it runs regardless
> of whether an incoming FDT is present.
> 
> Link: https://lore.kernel.org/all/20260309-kho-v8-5-c3abcf4ac750@debian.org/ [1]
> Fixes: 047117e78331a ("kho: kexec-metadata: track previous kernel chain")
> Signed-off-by: Breno Leitao <leitao@debian.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  kernel/liveupdate/kexec_handover.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

-- 
Sincerely yours,
Mike.

