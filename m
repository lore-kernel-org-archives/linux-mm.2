Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2D9CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 03:26:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92D66B0098; Wed, 29 Apr 2026 23:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B43EA6B0099; Wed, 29 Apr 2026 23:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993516B009B; Wed, 29 Apr 2026 23:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 864106B0098
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 23:26:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4971F16022E
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:07 +0000 (UTC)
X-FDA: 84713783574.22.606E827
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9A145180003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:26:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fVM+pktx;
	spf=pass (imf24.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777519565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KTi8iXJqgdS3jOvFqzqbkSZoCbi8rsF0sqMU/64bow0=;
	b=2JYuFg5Q9hppbONwtCe/H1hTnDlBEpOc2CLQlWXcnpfYKlNJwCXtd6JKkUNuQ0w0CECP3u
	jfpTdkNI3ZN5WKl3As5quSIzp7B/mZXSIzz9mDWFtxaSGJOTyKwWYxASwKp/QzqDbkHLiv
	/uzvQ6LrgiIfeDnjLV2CLG+EaasMEGA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fVM+pktx;
	spf=pass (imf24.hostedemail.com: domain of patchwork-bot+linux-riscv@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=patchwork-bot+linux-riscv@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777519565; a=rsa-sha256;
	cv=none;
	b=8ebEp+/wV/3NoQdA0RF6PXKENdG5IKIdE5tuBF40S1Z5rhI5XxkuvGoA56Dcg90deevYWs
	Lei3D0e3qTUlyFzAvjie9dP7XzTDEpq1Auw5DNj7qdpc/YsgjZmrZ/B9f8RQSWOdXGSe/p
	qCXRr1eCwD03v3mD6qoc6rhjd0idE9A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CB9524353E;
	Thu, 30 Apr 2026 03:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7875C2BCC4;
	Thu, 30 Apr 2026 03:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777519564;
	bh=u3YoJI6PJeGWY/+fiJtWlQKeltd3H2IlxE1eW7TcW1A=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=fVM+pktx3qjd5wzp95nMpat78U+9GCLO9zfS0yJaFVt7LtrOzHwjQl5XYjgchazAi
	 GzBT3q0NikQODltSrtECYbwuUtcf5M44X/Khc8VQHfC4kybRnJ1RLFmzq8TS24PfAR
	 DTB83zl0VVO3hZ77nLDO3pxYU3IEFyM8xscIKtHOY4wmR/fE7dWT+mucmp8DqFeqYy
	 zvpMTvGyKhHJqASghT9ckCceQKLSZtOW1vVXXjjPZSLK/8jUTGtyLepmQTw/JwD2xU
	 viwJNWXaDMxcGK9hmTQbpKeZHcvviMpDn9u441MGWrPaIERXtZavQRgOd1S2RKPAaf
	 7R0DVkVfCocLQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 02DAD3809A07;
	Thu, 30 Apr 2026 03:25:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv7 04/18] mm: Move set/clear_compound_head() next to
 compound_head()
From: patchwork-bot+linux-riscv@kernel.org
Message-Id: 
 <177751951954.2274119.3235115726287439195.git-patchwork-notify@kernel.org>
Date: Thu, 30 Apr 2026 03:25:19 +0000
References: <20260227193030.272078-4-kas@kernel.org>
In-Reply-To: <20260227193030.272078-4-kas@kernel.org>
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9A145180003
X-Rspam-User: 
X-Stat-Signature: ax45ddj7ogfstwik6fonqaz7dfxggm1o
X-HE-Tag: 1777519565-23344
X-HE-Meta: U2FsdGVkX1/DPj3+5bH2y/4A5s4ZnV7z9FY1PYfSqj1TkvAzRkDNyVsVDtq6PwiKHnbMVP6Jt7cdgMC61NcYYMfzT29cXWIqCq/AzGJULWOfN9gq5Vst/h7MJyhpsEeLFQyydIU+qyo8QYEJVOWapzmdbN07tgAUBsKzTOgpvuKt77ZkqWPVk82uuVlO/Xt+F/UX3IWOnlJKhOAh40NRSJFlGDOlBERkORCOL7QTqqs+6PxqqzTjwUplKokHDfJYOMRvTK+0b4WSwLIaNczOlXCrw9ZLUwFc/pEPBfEKCsEuu07Yl1yJyM5a5VOE3R2Wsn2ZjSFaWawmAsXkEWLg8XvCMieNodhbsuO0VHO3NaEBJBuxi891sxau9c4oHWs9umuujkbIWZ6Y6a8s95tTpfimMyusnQX2BkgjWKniiZVx6HfkXzLNQUKsvN2vFJRwz8GxzJTA1ompvg8QtA8XyFb4WtSmpivmjDpkIALBpO734QhmFATSHotDuL6/OeGgNgW3A6mTjf2d3G6lciBj6mo1lkAAZH1skb/wNMjLDKnyDr1e7zIP+F74P2y3B+oq6d7/Xg8bT7i9MMUPlTzVdMrR3/r/acqbf8kh1Fs/Cepsn1uTD0TWTCoNtmBojg5PwBbu8zcNtMkimcO6QLqYgBp1oV4o5Chvpezn8OyZOp4shaBTEeyXwXHWjrHu9umY2z7o8k6qoyXVRJZvnvQknN2RHx7nRva4K+iHfw/O5n37zQeffOFJHuf8MO08GrZlWKf5ivmJbDtVwESJ6hjlc8FqI8ROlw92qyN26iogCiKurbxZpfcCBZemHC5RkyBYa6Z9hh7e9D6C+aTVP2MdqZfnlX+4d7rwMDp8LLzba3y9UnA26/1aX0XfLZQdJEvMtTwiVxRheLeNYjLDe0pW7Xoh5SVZMxSNdBFhF/1W0RJn/y9sf8En6uFanV0hwm9VhBGJvbei024EkTtPvPN
 1Xt13Cbk
 C85QwDxkC0Qftlqa/HRe8E4Tr4KUEfpof8nv0sfO986S0Er69I348ldcNhWHF1vrO3YC8AxJMVLoYJtZ23guazp8WjD2gvUz6fpwryRtDHFvvelavJm6DEBMsa9be3/JxWxeakG1o7zT+SRQJtE7VlP82kmTKsGZ0bDUyPVsZCH0bdTtBFzFU93ZFp5tCGqMe//L+poCwycBOVNa6JBf9wPEzFRsEPKGU3N32db/zvHhhoWYzpxN1xZ+uAOnA+t2YQ7BxORR+CmH42qoevGlnNPfv6umdpyCypjlUte/ex0xa5MBo5rio7/fndClwTrmald9uAwZwmWpOYvIey5AEJY4FD5MVAjaGKpR2OtSAivWHupfrzlbt78eDaAbbYmWorQTJZcxAhgVYU+L0D29lSl+2EZPmagrET0iPwdvLq5ulmM8U60B4rjzFGWg9ehdRQA9AxH70sl8EvKzgZ4F5aoResmic7ccFbnTYUD2hDmOcyIUItqPawuupcm/ovrtb1tYg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello:

This patch was applied to riscv/linux.git (fixes)
by Andrew Morton <akpm@linux-foundation.org>:

On Fri, 27 Feb 2026 19:30:05 +0000 you wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Move set_compound_head() and clear_compound_head() to be adjacent to the
> compound_head() function in page-flags.h.
> 
> These functions encode and decode the same compound_info field, so
> keeping them together makes it easier to verify their logic is
> consistent, especially when the encoding changes.
> 
> [...]

Here is the summary with links:
  - [PATCHv7,04/18] mm: Move set/clear_compound_head() next to compound_head()
    https://git.kernel.org/riscv/c/67c79a5af051

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



