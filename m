Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66C71F46C79
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 19:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B871A6B0005; Mon,  6 Apr 2026 15:51:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37DC6B0088; Mon,  6 Apr 2026 15:51:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A75306B0089; Mon,  6 Apr 2026 15:51:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2696B0005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:51:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6809C1B820F
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:51:37 +0000 (UTC)
X-FDA: 84629175834.05.B53616E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E6FA4180003
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:51:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vWKRGODw;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775505096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kFJQbvcZYvrLtpfarL5XpYJ3iGlT7I7VEsM/QhwGfus=;
	b=yBgXNMk4ywdVrN5gzpl6H604rGC1fRM8xEmN/FcIcdPyu5kXFBFE5s8x/t4x+8hbG7GRkT
	Fysox4nl4WKzyDmBHn8lBxf5JmJWx0fcLDZU5iZA4/wJH156Kl1hXRc1KrhHYz4N8g7m9y
	fHwbNXsOGizzrwx4CNkuolOpi+abM6E=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vWKRGODw;
	spf=pass (imf24.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775505096; a=rsa-sha256;
	cv=none;
	b=JESUJBlColR7kJ8MEiiqiJGV2n7oi86KFkzH/NdxehLSPo4HCH4pdcaPfnRbkx95vRSnP8
	5cBTcloFIti6unewMcUS36e7yk7s4YIQbu5bKetwWkmVP9VQ+2XC8n+siH2Rdvnl+d0K/2
	Hrz0SWjiqvsoevVL4QANZPjSzhzT2c0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 18D7C6013F;
	Mon,  6 Apr 2026 19:51:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ADBBC4CEF7;
	Mon,  6 Apr 2026 19:51:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1775505094;
	bh=GMwjYkUhm6drJVHlYbtmPfNPSlWMffmCjzdHMomgceA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vWKRGODweREmOy5SZDLzFpguFGXXFlLktCpHdyvBoKeVvjP6hiSj4AA/TcNQnQbMd
	 Q2KYUjztPIKF2q4yWnUcDbp9nC6nXARbFRsMcCoiAdqSerLKUJwFtAX7F9zBqEIS9K
	 2bRU/gVmq5lkdhk4f/L9pkJ7lWrJnC2mn9GNmHyg=
Date: Mon, 6 Apr 2026 12:51:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Li Wang <liwang@redhat.com>, nsc@kernel.org, david@kernel.org,
 ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH v2 0/2] selftests/mm: clean up build output and
 verbosity
Message-Id: <20260406125133.eeb8efed993ae1faa2a9ad73@linux-foundation.org>
In-Reply-To: <20260406193216.GA1319599@ax162>
References: <20260331094402.144131-1-liwang@redhat.com>
	<20260406193216.GA1319599@ax162>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E6FA4180003
X-Stat-Signature: 8kxd8gj3r154x8r4yp9nqhpzt4i4jo6r
X-Rspam-User: 
X-HE-Tag: 1775505095-795477
X-HE-Meta: U2FsdGVkX18z91TaWO3jj45+o/ZpzJU3sSUVEFfq+AknLgfBBVm5TU/+XdX0jWMydEy+rFoUclPTL2G4FuhDbYOoPVYZscNhqLK33uKvqclWFPT+e1JSnyhj9oXUSzB7Cdv55jZttWimUmtI+H9mhOaXkk6Fxb80z4tkhvfFwfARz1+wQE7P6qPpRYyQNSL/SmVGP+kMYZ/xKfDrk3RHeN82lbe+g0nv1uoUYmOnJn28fQ63qPB31yJCLTqcfPsLPuT/TUMdWrynTLcyAIav8ikB2s7NbqW3NHy7kDEXxoqIzw2NsmGxyxHXggVPfBJzoDHy56mHnrybebEXhxhvTP1/rVYETzsmL+TLHENh3xlcLTc1EoFUskNPUBsaoOVyxrNsDRBsf78X+lyvP0VsH+ZDkRjeXsu99qIdWzgGg4HXIVGbIJVXcxWRq+R1NKcVqAcJP8JEcN/YjTkckVukj7fV+pS2iD4cBQ1jqW3TR1kJKYzh2XfKOCdyuAD+ODNjMy8MBHO1KEGl1m8NgV9f7j7tcp4fcpMx7jWQtPOdY2IFTXlVLpC300jr5o6Svzzo+JxRAQoxzM3RkQZxi/Jq3DTe129B26fgPuRKPUbLY8Mk3WlJ+/8fvH+53FM9k4/XZR2silL9SJ03jBY/Yk06dLOIiDZ8zlhtH63laJXZ5gQfgoMoq8lydx01gR+k9xKxAwhWnwXEwl8iGhLGMbSf6YL3A/2ZXTH/WxrAclRqHJ5odCpFuFElUjGBSjqnbZP5Kdc6S7CW3mKonuoB8s2s1PCVm2xYcNJwa0/fiKM8gNjggFO/vTd3ElwsDWjEtzPI7YYd9rVLPDpE2CdKEBFAVssnI+zSH7IoHUYiZih8kgaJAYkRa73QxTAx8/fDeFsaYeHDhPX84XrDal0OoUENSQY8u+o2ALxAmltzP1ru+9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 6 Apr 2026 12:32:16 -0700 Nathan Chancellor <nathan@kernel.org> wrote:

> > Second, the specific 32-bit and 64-bit compilation targets ignore the
> > standard kbuild verbosity settings, always printing their full compiler
> > commands even during a default quiet build.
> > 
> > Notes:
> >   Andrew mentioned he hopes this patch merge into kbuild tree, so I resend
> >   to linux-kbuild@vger.kernel.org.
> 
> Kbuild does not maintain anything in tools/, so this should go through
> either the mm tree or the kselftests tree.

No probs.  Li, please send it along after -rc1?

