Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C7F3E7C6F9
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 00:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD346B0088; Sat, 31 Jan 2026 19:43:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 950BA6B0089; Sat, 31 Jan 2026 19:43:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84F716B008A; Sat, 31 Jan 2026 19:43:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 756C06B0088
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:43:14 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BFBC713BA63
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 00:43:13 +0000 (UTC)
X-FDA: 84394038666.27.4B3F50A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0BEF21A0002
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 00:43:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BbpBcpEz;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769906592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/N2TX5w7TG0/ptW8V2UL9YErPH+kKWXCN3zQqvUn74=;
	b=qV4AVsdRF0sCmGXPiXoz56DctEyOBE1G8JqJBGwDk1uUwjpl3onNshAAzDSyPojY+rLijV
	giyud+U/1hRkCL52N0nM2uLo12O74vR79YhVm+Wp6+E1lY++L3po6qLgvtM/JAQR2Ex0OG
	oan02QWzxRoQZmZU8ObvRSUXMoLNoj0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BbpBcpEz;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769906592; a=rsa-sha256;
	cv=none;
	b=EF7aTybj3yYQFQI9IK15+TgwVNonrojfULV6W4NheTIIFZC+IIm6vFzW1/hYFRPGz02dPP
	b97r2ABnHWXTKE4sDRZthAQgiM+1/TqP4kazmFlcIzIOywuAsPurD5QxOtw+CwAJbDdSf8
	OibTTySkJHH0it7Cq2pO7QVxDexASG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1071460053;
	Sun,  1 Feb 2026 00:43:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F288C4CEF1;
	Sun,  1 Feb 2026 00:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769906590;
	bh=N/bSjHB232qPSoeOv44GNd40TFrJjRkIvnqNHWcNv5Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BbpBcpEzEMUAjgQatMPJP9qosblFzD9GPc34UqKsewAuZAK+oFHn/byEpK6W+U77S
	 sTD/U0Nxf0Y3jHQmCE3CsrjDpNh98N9qP8FVu/11R9UEPqKeIU9z03w3+SjvogAkDB
	 ZAvx54CfyNNwAVm4XPi/6CsBkv5hZscANmbR74ZU=
Date: Sat, 31 Jan 2026 16:43:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Kevin Lourenco <klourencodev@gmail.com>, linux-mm@kvack.org, Kevin
 Lourenco <k.lourenco@criteo.com>
Subject: Re: [PATCH] mm/fadvise: validate offset in generic_fadvise
Message-Id: <20260131164310.048caf9636063986a8b517e6@linux-foundation.org>
In-Reply-To: <1690da61-412a-457a-9bb4-1135838135da@kernel.org>
References: <20251222141817.13335-1-klourencodev@gmail.com>
	<961095cd-59d2-454a-9b97-493d12f296a1@kernel.org>
	<CAFveykO9tAhGnKCnSD-2_wt3QxMTNF3sW20NGwnPK-3yMd__yA@mail.gmail.com>
	<1690da61-412a-457a-9bb4-1135838135da@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0BEF21A0002
X-Stat-Signature: ap36j6dikt6kaecc6enyb36g5di3eux8
X-Rspam-User: 
X-HE-Tag: 1769906591-53967
X-HE-Meta: U2FsdGVkX1+N5xPuV8YT1h7dUGBLX6oatHX/XWmmnQTQv3Jegq4wrGHr79RcsCdxJs24Inx5FROf2uz5M6mwTIG7nubsMbvHE15TWqkh9aKv6OGnFBEQc9aptD/Mot0QMLbCpAKGuvptorfcBtqNThTRi9Rt/vd38N0TQKYLxbTOI38veEpxCpV89621X0AvPRwUlM5GxBZrpvyQDyPhARG5YfOcrfln8x5IzlTWann3slG4qJf3szwfJOeF9rpeR+/+UoWqsXFAl+WBXMbuPxwJw2pSO3XIUkTII7LWRB8AMc4+MvXQiU4y8iwzgjnfziDOwn1E1ghyZyPExb7N/iyjKkmsR65/UyaNDo9qVz4ccmMiPobWwjkX2YfPtXf7VoVWP7eS9jHpsjvxn5AAsR+ZkF5BbX12SY8mRgdzrZRb9Nb9vPzo1kHrZO5DUBRXx9FZc6JT6NT+QF+7Ms3jX0TAY5GdAOOGbn6UYSQ+4IED/wtuNbdqGY9TPts7eSNSu3zRzWbU4rBhpiQ5kchMm3pF05LFsCUrgLlaUD1kxFnMAr7+ZdBtaHT/5FoeyMiUgFjV6Y4AoQPayFiC7U+9rFIDpY7VtIyQ6dRKFuFHXEWVDlADQ9ZI5CzfWtaUIAuI0yim2R9RPNmB4tM5LUgf6c3saL2Lg0Py7mTmb8ip/JkS2pHjo56f5TKzuK/FH2Jh9sBaKFTJuIKxU8IDDA5/yMNXwVv7RHp6lXYg84ctQUxBuaHaQmpfTk2Yxbnv4rJMba7hU2fpzIObzAWVFIFkdsMsK2nz8kWzEJU0YHB45fgkCwgCRNKErhw+FfXUnr3JutQXjoQ2BqC5cBxT4RSyVblrqZTvEaeky9ERBwbRBhfwGXPm9OHKCGizFKtdp0el1rrP8Dp3ZlDRj7kDnqtny3e9JX3uOxoFBmBRKLixwQWxCMLPTNH5XT+KsYI+BmJDXraBtJI7ru94J8SXOP9
 mPiRkrq/
 Ma7uF+Q8KcQJfdeb4jvAg/vdGSePLkzR23tbimutyH+A1xPTW2KejvtpoXwwSfoEyFA3B43kx0PDrw5BhNoYnkkRb8+mm0Px0iPOQSEYQXQeF6XFeymVxR2Pmy6ZpNrbHWw3p134bdMlnPnIUndutvyY9bfKQcDnv5k+zwjh3c+5I8zkwyR4YWGgmCSqsqji6bEhSSYtHgqZGBGKdVB0fK6SqzqbfYkH/Oa35X8c73ZS1BJRv4wNmYbTcBrFg9q1//KYm7HiBP/gwnhMG6Dn5WfqRwxfIpKjPu07Adf65MwXSvPpuiZoLsAvebb7eWx9zsVLK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 6 Jan 2026 20:46:14 +0100 "David Hildenbrand (Red Hat)" <david@kernel.org> wrote:

> > Since I think nobody intentionally passes negative values and since
> > that makes no sense semantically speaking, I think we can consider it
> 
> Well, then why document negative length? ;) We should be as clear as 
> possible in the documentation.
> 
> If POSIX would have been clearer we wouldn't have this discussion :)
> 
> > unnecessary to update the man page right now and only think about it
> > in the future if a negative offset gains a new meaning, for example.
> > 
> > Wdyt?
> 
> Likely we should really update the man page to reflect reality. 
> "Starting with Linux v7.0, posix_fadvise() will fail with ...".
> 
> Given that FreeBSD rejects negative offsets I guess we are good.

I'm still not sure what to do with this.

Kevin, would you have time to update the changelog with the additional
things we've discussed: linux manpages, POSIX, freebsd etc?  Then
please resend, cc'ing linux-fsdevel, Jan Kara and anyone else we can
think of ;)

Thanks.

