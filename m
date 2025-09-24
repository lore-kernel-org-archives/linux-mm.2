Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49845CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 21:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F6678E001C; Wed, 24 Sep 2025 17:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A7BA8E0018; Wed, 24 Sep 2025 17:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E4788E001C; Wed, 24 Sep 2025 17:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59F3A8E0018
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:00:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08CA7C01D0
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:00:15 +0000 (UTC)
X-FDA: 83925361590.28.3D27B84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 11C494001C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 21:00:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qANOd8KC;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758747613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H/knSdUCFMG3lWF+vWXfJAJaG5rbjtKiF+qySoPplzo=;
	b=EGs9rHsmi+uAVpOB6JJntoJcN4SlmGwMSZqOdJuGLIksXCy7hzEvISf3Zjda7v3KLtXyrG
	5QnUfE/HB5HTLRV4zqRVNvATQaS47C/3oG6eqg5qTGrO+wGFhgR9+d6ggA4UkIxZFrLVdV
	Y1WywiByGI/+99AyqlwX8OqhqQq6YOI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qANOd8KC;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758747613; a=rsa-sha256;
	cv=none;
	b=gexvJjfYh7Er/KTutBCQ2Wfv61OqN2S0C1RvT4scr1H6qHFEpMRPMDKI1rP33ULftRwwcg
	V5sD97jZgWgzMhL0YHs7ja2ZvrfgJmRREaLa+riUOY1MTBVeMYd/ap0rMQZ1h1K3vGUWsu
	H2106Wbof4yc51RaWTHk3CvIm7DUHPc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8FA2D44B8E;
	Wed, 24 Sep 2025 21:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19600C4CEE7;
	Wed, 24 Sep 2025 21:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1758747611;
	bh=dDJN8b77rN9ysunvOFha1XEVk2yflq4396QA+xCKryA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qANOd8KCLjLmqepp6rdBNv6MmCrjJQdAU6quKdt1acGS2IMaHi6blrwkvKzfR/A2g
	 pLanFR4po7eEdJLjiTLqiKCNSElQhay+3N7EYlL820XKuZIP0G1rqUhse3aEbpG/jt
	 YQ4zbJV7UVgLhM7jEUz3SZDs4Wg2MoCAuIB9KoM8=
Date: Wed, 24 Sep 2025 14:00:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>,
 Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>, Changyuan
 Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, kexec@lists.infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 3/4] kho: add support for preserving vmalloc
 allocations
Message-Id: <20250924140010.81305926b42d0223dcf3b818@linux-foundation.org>
In-Reply-To: <mafs0ikh7dg54.fsf@kernel.org>
References: <20250921054458.4043761-1-rppt@kernel.org>
	<20250921054458.4043761-4-rppt@kernel.org>
	<20250922131948.GX1391379@nvidia.com>
	<20250922143407.93e171f8b7c09eb21159a33e@linux-foundation.org>
	<mafs0ikh7dg54.fsf@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 11C494001C
X-Rspamd-Server: rspam05
X-Stat-Signature: 44bcnun41kyznftdfckbg88c7hm8snat
X-Rspam-User: 
X-HE-Tag: 1758747612-668803
X-HE-Meta: U2FsdGVkX1/I5/dZZC4o8iQ7dJxP1UvoZgk73Obfk1u4KVALjvQvpcemIbF8JxHWcqgrCToorm/UyvmmTAcro2fXmTjiOaySKQWD4y6q9SRVqygR4+wjQOfj/wmlESeg1oR9eTQy0dXAk4vNAooQP4VOnmvx9m2ru8fFpbVebrY+KJhsbVJqm4AcPTYct5cwHSFcTFBz0Sosx1h/y0aYb6u5RcX0++M1SCB1kEeMQMM0J5nlRU2VWBxPcjasRTCIKtXmUDCHJF9kdT6hWWHZ0Jw09V9EmwCduWpbEHR5GMHih89F11YRzNc+IhHV/5r7vgJnoMONJSZ/VQ1enyOJMukCl9juFRbxUrfhaE8iJA+x3S7EfdUwKPZuvyxjhjLrstNEZhC/KOBq2dCf3LG4Bp1cjR3R/j6mAbCwmISmleE9p3ex7U4FA75fQT/1jx2I4bT27ftI44rzpbl9Uj/3fi9m1tyb3KVR6t1QHpx6BCI/pL8maMYMlNZ7SmPX2vs8aElhaEUUPoBIPD0ynS1bgtEUHChl0r5JzCCitNOJuQ98l3oQKh7O4n9eQd9hfrILWw+HgoZ1CifQBgk1k2+vh5xmbNPU/L+k1dc6W0UIPldt3LfG3vwzAwgFsxORJRr0miQmveP5AJAJkCsCzyzu/N5ywSKvgOUmIVPRW3jFDfDC7IX8tG+oF6+pkX55VMr0q365W3kV0HQEu+gDIB2FPec3hkyO6oossZA4BiOgspgB12o6DBfHuOl8f80d+rx0E4x+fjl7wgGI0e0OVRAOKpEVl3fDIOI0NAuSvhtb/eK9BjZAJkzgY87/OdLtfe9PXBHo871wRmTiXRboSnHEemGYvo3vbkxs/lyQZayRKx8An4PzBLDejBmiI3vdka0XlXa0H7n2YRduPsDilrtkBWzaymiuirxF2wg9F9fj+qELuX9HCm9Dm0A5vl0a07rBC1pYujfhIB4cECyxIgS
 sr2C3508
 zlHalbiXFGYoMNv9pWK6/eaQR5w1f2g1fW/b6QbZtRpc5yUYARa/1jKXvAEekjX/Z1uLuU4EACy8rmteRv+F6pDyA5GPCndenfsnAuwwbhfSM1c3kz9TvIpkX8w6Nwni7JZEjlRqW+qZVUQ2ZE7QOUJuAn3xuJcpGxMJHgFXinBZhmMWOk1qfUbY8s/M0KetfoRSm79nML21VURXGT+y2xN6UrWbz0k0Wvz3zfjSurgH6B4TbU2JUzTMmQiBhLNAOeakuYn8dqK5n9+OnCLXtqSbctw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 24 Sep 2025 17:28:07 +0200 Pratyush Yadav <pratyush@kernel.org> wrote:

> >
> > Not sure why this code works - I'll suspend the series from linux-next
> > for now.
> 
> It only gets called in the error path and that didn't get hit during
> testing I suppose. Until v3 the chunk was being allocated using
> kzalloc() so I guess this got missed in the move to get_zeroed_page().
> 
> I think Mike is out of office this week. Do you think this series is
> stable enough to land in the upcoming merge window? If so, I can send a
> v6 with the fix today.

A one-liner fiup would be preferred, if no other changes are required,
thanks.

