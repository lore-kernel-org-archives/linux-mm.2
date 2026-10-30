Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B05C606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 22:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Vk97GFiK
Received: by kanga.kvack.org (Postfix)
	id 5DEFA6B05B3; Fri, 30 Oct 2026 18:33:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B62E6B05B4; Fri, 30 Oct 2026 18:33:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6F06B05B5; Fri, 30 Oct 2026 18:33:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26BF66B05B3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 18:33:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B91B712086D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:33:50 +0000 (UTC)
X-FDA: 85380746220.28.D04F3D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id F40D5180003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 22:33:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Vk97GFiK;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793399629;
	b=Hy6uRpmnVy1Ew3YOdhvNQflC1YGe8CRscBmr4cm3LK/ebt23kNAPqvi5LR2J/hYVoCmvio
	Z7f+QglTWTbmQaAYtdflkg9IMx70pDyjNdm4iqNNxJnlnaHLKjUNo47Kpgj9VbRRSXKYh3
	C4fwzZRdAZfkeTDt/uLBiB9lkBSJQaQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Vk97GFiK;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793399629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ucXB7kIXkR22wptA4ECw1Ukmrn4C7DPZ8GfL9sZbPxg=;
	b=gZ2a6ev1OeU2gahgNNY5G78TOT2/2Ii2ZxrqxJq9iOq61vrmVWQCxnhdy/rs7alb7gcCcj
	4FL041lIajYXXJzzMLjc1ISJ//aXogDYvuyPCFAbPiDbxCQrfzMV+TXH+xA4XXca2s2gVZ
	WH+/RIEjJOIir1Ua26c9gqtWEIuHlvI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7997A60233;
	Fri, 30 Oct 2026 22:33:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC75A1F000C1;
	Fri, 30 Oct 2026 22:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793399628;
	bh=ucXB7kIXkR22wptA4ECw1Ukmrn4C7DPZ8GfL9sZbPxg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Vk97GFiKii5heUCxUE0rGgXFrRQo8z7xlej80GQQndc0rTb+p2aICUANyQvibAKyg
	 3OoZjHTlLmP6Ja46z3aZqb0EUlojQj/Fyg6xq1NJ0wjDXXR4Sfb69m1VHnONpbtdby
	 0uhiQy7RzXCMegLzFo3y0rRkPyBUmBm9gD1U7PGY=
Date: Fri, 30 Oct 2026 15:33:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Alexandre Ghiti <alex@ghiti.fr>, David Hildenbrand <david@kernel.org>,
 Jisheng Zhang <jszhang@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-riscv@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-next@vger.kernel.org
Subject: Re: [PATCH linux-next] riscv/mm: fix up the mm-fixes merge of
 free_pmd_table()
Message-Id: <20261030153347.5641a97e22e18ddff6043416@linux-foundation.org>
In-Reply-To: <20261030221401.155797-1-sashal@kernel.org>
References: <as0D2sHzh_UnNF5L@sirena.org.uk>
	<20261030221401.155797-1-sashal@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q7tkbic68e5kej883ihg8m9u44xeeh5j
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F40D5180003
X-Rspam-User: 
X-HE-Tag: 1793399628-349955
X-HE-Meta: U2FsdGVkX19V4iWxCPa3k4j6/X63D/rikefAntsp7fgkI11u17unvBTB1rpYVvMLW43ud/VW8duturdm1aFKhinTzPWKH3jYYG4IfPSDVOvvEbXei/FeIFtbzTj2rLWcWy5CRR7BckiZ3iGa6I3UpUp2LNGwjdBFkAPlqndWZKqarDj+9I4hhl7YMTd0InLf4myKHO0RnVfbSme1Zd+DUy/SlEdBdPtas9/SVr24UGpNRxQw0XYbO1J+TF7ZtijbEowdHnI2zdOOjyiqf8aeAPKBQfWtzjL8IP0MFc35HWeMwF0poGFZDvbK06Sv5CtUAsfE5F5pEvFksEsD534FSbQKzeP118kafrkdHNTegrybBb+BsmwxJff1PxrD0/tYLFzStIVAcUBIuEe5vLypHTNZ6Deqc7nsuqi2QMAWKUO8UvGz+nS4xZ4ECrhIMuPPObDDCVqotvlmvdn77fiFAmR0+mxIClYOg6HRBuLc9SvKpGyl+W5e5lmzm772EeoCscApGOdqGwXxIAt4e5Bg5fWcv2PfE6tihv3hzQpWEhcDfgS1Blepm/bfeHIFvw3qcGg1RtjqoZRSpKz9ZRZGKYn2Im2NTgFnMGQoVUZNnh03hvirxjhHMrJDa2mJEny+sEKkCrmLaH0lrhqZGetQ+UVcjbpef/3m3xFaplXgfcGYNfd6GJeA0UDl/BOSM7ghTrSsGtC7YOhVjAGYZeljuyhBuftKPlokwXuAAgShRy75tzpkA/Dp+clvhTWjiymcJX/AiiVe615wOFwHuFwIA54/Ee0JiR2z+emub9OGhSV0N2TfbZNvmIVr8ZvdstjSW4c62kZWQYHwDZ10upECFuVsTrk3KfReo1WCrhjYH1wKtwkXWWgv8ZNXUTy7HUGsE3JHxgS0lyAqsA/axCVY1uw2106R9M9WXS7Olk0ujEOxHH7nwyKbBM1IlMqgBhDmuqnNVSmiv8tNOlu6uE0
 ToOolIrX
 boliZZiEqQXQ/6DAo0Du36wwALTU1y+iJshVwXmRYahWcZYe0ojpAwrPKVhQb1mIkrg4XrB2mkP4p6me2iY7nRjGNFkb8yh6w4BTK++Tx/GbvX0tz8i6vGkmyjvkNpLpLnUMKD89zhirfke1n3Bl/ZTFboaykMmY/zuANdeiLOklIOGqAizWhB+8wqXxvcdAsMB5eQINDtJT5j+VEMMSSib+scOKe4zq3PwF5jhPSmZ1b1cUUmK2/JrnAFNqKaJEb8EP5spJwfAv3iJMOdADgt0xgQ/xCl31YZ/vZERbOgzEBomxFS35LSwn1zPz8JKRVpySF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 30 Oct 2026 18:14:01 -0400 Sasha Levin <sashal@kernel.org> wrote:

> The mm-fixes merge reuses an older resolution of the conflict in
> remove_pud_mapping() and keeps the free_pmd_table() call that passes
> is_vmemmap. Commit f998a21c2ba5 ("riscv/mm: fix hotplug page-table
> destructor handling") in mm-fixes removed that argument, so a riscv
> build with CONFIG_MEMORY_HOTPLUG fails:
> 
>   arch/riscv/mm/init.c:1657:35: error: too many arguments to function call, expected 2, have 3
> 
> Drop the argument to match the mm-fixes version of the call.
> 
> ---
> Mark, this applies on top of next-20261030 and is meant to be folded into
> the mm-fixes merge resolution. Next/merge.log says it was resolved using
> a previous resolution, I think the one from the risc-v/mm conflict on
> 2026-10-12, which had the same problem (next-20261012 has it too).

Thanks.  The "mm: Fix page-table teardown during memory hot-remove", v3
series was problematic, but I now have all four patches lined up in
Muchun's as-sent order in mm-hotfixes-unstable.  I'll push that in the
next hour or three.  Then hopefully any -next merge resolution can just
go away.


