Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC266109E52F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 00:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061E76B0089; Wed, 25 Mar 2026 20:50:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 012746B008C; Wed, 25 Mar 2026 20:50:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A666B0092; Wed, 25 Mar 2026 20:50:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D924A6B0089
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 20:50:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 974D21A0909
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:50:10 +0000 (UTC)
X-FDA: 84586382580.13.0D20C7C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id EC1398000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 00:50:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qLYHKKHR;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774486209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=otYwA3BnCH/XwFj3pN3+hU1O9SMzTXyP6YrLAf+Hby4=;
	b=1OnIA3hI66kOLN1DsetJsCxuEdkEkAwGSJnPFU8U9Mlj0kCnaOxdzlL+1XTbzufpGYpAyA
	LaHHJSTdZKNGqmQq7eaE6Z1DK09/UYuuoCAMkzPL/Z9Xpl2jCWl79vJ0x2rV9u1oo2dG3R
	373GAme0zxopxgRIHaFZSuW5ts7q30E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774486209; a=rsa-sha256;
	cv=none;
	b=TEPNCu7VNIj+0zZLrAWgQZ2bm2LNaEj7HE5GiNu72zT2qwVddTwSw9mS1MrPgVnUi8CmPK
	WT1+0XrsAikNXexPCZl3dCH9HKzmmvLoCkENO1ZcUrBu2O7XHTSGAE6ZEnhA3uMJAVsQRI
	uvqSDLMl04EShHAsKoP4sN8vhbc8mHs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=qLYHKKHR;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 33D6B60121;
	Thu, 26 Mar 2026 00:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C45C4CEF7;
	Thu, 26 Mar 2026 00:50:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774486207;
	bh=+OmHiraGimH70ANOJHEaNBOgGdEAVeQc/N+5UwHJRrI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=qLYHKKHR6Wr/lquOKS2e/gEJJlRCj2LkxHzXE+VSA+b9vcX1sBFN+VhGUIbbS1B0E
	 pfNWOqg44Q/rEv1fsm5GOq7oSiOvKM8kosWkN/RoJ99g03Jlxz+oObUNh/sNR1qV3W
	 5UStY24RY7/E/KZtqBsl2tV7uepJcm/67JlG4Wto=
Date: Wed, 25 Mar 2026 17:50:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mboone@akamai.com
Cc: Max Boone via B4 Relay <devnull+mboone.akamai.com@kernel.org>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/pagewalk: fix race between concurrent split and
 refault
Message-Id: <20260325175006.1c3cae2ee50dd491a153226e@linux-foundation.org>
In-Reply-To: <20260325-pagewalk-check-pmd-refault-v2-1-707bff33bc60@akamai.com>
References: <20260325-pagewalk-check-pmd-refault-v2-1-707bff33bc60@akamai.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: EC1398000E
X-Stat-Signature: rwhb8d6ppxpq697pxge7kcxosioqehwn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774486208-425139
X-HE-Meta: U2FsdGVkX18DYNUxwWr8T69U0FqcVkHZ+ZeH7nbEZSV8rLfq+S4P3lgPZZqFSiXWcvDZIM83AnPjpHic7ubYyIt4YO8D1L1wQ7b+QUxseMCCZJlmP/Nw5VFocYrcM0mhiXZdf/Qi+RMjt9LqYoRkjSHYNGTvY1YNZfFCUhlavTNhzo687pIyck7//6wNWj3PlVjawhhrTHe2k6ainw567kGBU7RRIf3gxIuDl88TzYfm3ZG9ZeonX/mmKTsGhTnvNspaHZotr1JUCMON/X6xeWfUY0slDwnfFsfmL/mu7iKLg2wnHVbHwlRy6t8JIC+l6b2LKRJR+2PXZa97qMEkOu0eAxKWm29TZVcfZWUacrKGDf0eVxJuShpNIvj2F/aSsNr+ri5FIZKx5x7YWg8F7gnvVT/991sAuVdY8iu5+Kl1XqwdT5S823PL2eWcPtCHIdzHkKvj5KQCzteGr6Omn22a+d4c436KyS6aJSTRSjjufBjarg1jXD8Dlp5wbnpKsYDaXQv+tVTDd6J8CUdUoZaN1mXEK9zbvCBSlxxFF6FnU6h9dsrtg5wg1JHylldNTPKYf7A4Mrbgkefh3tSLOgd4GtknsegMLjWa2xGwGsOHVDOuH5UiJKdDYaHxHuoxn74dYhU68vVm7FPDHheccB1okNWeShQS36q6XasexajAzTRcu7JLH3xH3q87cuZ2SdzB3XjsRPxFCNCzlQTEM5OrSgT07+8IZErs49Y9GrQCfBH2bychK56PrEpckepGAxb8xxhMw0JBk3mgKWEBR1L0PMnzT3o6YLsuHoPsW2s0JIpKypjg6rjIVluPJVvi36WLUBLyU3Lhn9P9q6ZHE6a8z7fyMvOswmvif0K1t+ePmWIp1xJUNF5ri1Lem2B/6nh8rYCvrC9YWIHk0cpl/enb6GzTnN/uOhXaTVPHE9SgVc3NSvt8LZyeNOv28i9zsCXaTahL2L66Lm5+0Tc
 7EmCweMS
 8iFp1vcablzFshmBwmW1lh2UJIQ6T5+Hzdb5MlqjWVSMUj/I/MSgFuw2rNd/QSb362P86qK5eyNDW3OQ8hcMffGW4mVrcwzvU10jL57Tnqm+k4brYHS9HukDBIW2u1TU7KRw6SSlcz/10Aj2vWhN7H3r6Dk+x2NeOVg7eIJt02oPOV4Hbko/flIBWat1EbLqxEIf/xvLR9HAq7u9xwy6XhfSg0H+ivDoD2CQgotLvC3q166taVntfzE7PzHi5RcoBFsvW7Jo0oyP60rBCx/sggEYWc7OsMu4PZZSpL/XEIrzvnaces/hrPIDBbmD1jWv/IlE5ZoACUheDp5Y/ka+XW+UTCNh4gsBvj3UNNK5nKwNlxqnouCmFmLWFyzdIyXKrnVN961uf1QtaRMipjoDd3b1PWHO0o/n+5h3FU+Vp7RSMvfEJicHv60wyR8dQsGrTpkMl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 10:59:16 +0100 Max Boone via B4 Relay <devnull+mboone.akamai.com@kernel.org> wrote:

> The splitting of a PUD entry in walk_pud_range() can race with
> a concurrent thread refaulting the PUD leaf entry causing it to
> try walking a PMD range that has disappeared.
> 
> An example and reproduction of this is to try reading numa_maps of
> a process while VFIO-PCI is setting up DMA (specifically the
> vfio_pin_pages_remote call) on a large BAR for that process.
> 
> This will trigger a kernel BUG:
> vfio-pci 0000:03:00.0: enabling device (0000 -> 0002)
> BUG: unable to handle page fault for address: ffffa23980000000
> PGD 0 P4D 0
> Oops: Oops: 0000 [#1] SMP NOPTI

Thanks, updated.

AI review has a couple of questions:
	https://sashiko.dev/#/patchset/20260317-pagewalk-check-pmd-refault-v1-1-f699a010f2b3%40akamai.com

It flagged the same things against the v1 patch - maybe nobody checked?


