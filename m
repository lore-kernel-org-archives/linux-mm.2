Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85FA1C79FA1
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 15:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 909226B00A1; Mon,  7 Sep 2026 11:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E0566B00A2; Mon,  7 Sep 2026 11:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81CCE6B00A3; Mon,  7 Sep 2026 11:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 641E16B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 11:27:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 06033A3BEE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:27:49 +0000 (UTC)
X-FDA: 85187346258.12.A90A2B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6B4F1140008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 15:27:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n2/6D9dV";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788794867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6hrOBQSxvF0DAR349U8/vdSM9iBMmaVDEOirsjTaU5A=;
	b=wRfp3wtVIO5vpv02cWyxkMP7g1choG87F4Uc9WrT4qDhdBqrnajuLwA4dx+bwecuEqj8wj
	Bn9uDi0w1U98iiWQuVdoA8NUKc7NqEgoCFoEYFe4OcAvfmu1J6mbdTqTvPETL+T2HkIR3/
	JIZggTTHu6eWlUITrY4iTMdijjaM1DM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n2/6D9dV";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788794867;
	b=ZCphZaQExiDLec1OgNVkv9+IJMiPbpk5tGGPuJCGeo6Q84COwjH10QqeKb23cMeZIlBWf8
	fldpn4muTZ7x9idzdgaU+TBFqhZAQ3uPPZHQmcLxZt0w20pnPlIbbgQkBkYgE7Y+R6+GbZ
	7otmnDVLjV8qTDCGaOv80qcIFoZtQ68=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 940A0403C4;
	Mon,  7 Sep 2026 15:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC32D1F00A3A;
	Mon,  7 Sep 2026 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788794866;
	bh=6hrOBQSxvF0DAR349U8/vdSM9iBMmaVDEOirsjTaU5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=n2/6D9dV588UugjGE35JL2jNmMYrvZmp13XEWqyHCwlOKBQ4CXbXIKOvMXbmo1DOr
	 QRTOBE2kf7W68XVe2AVyMtYDcqumD274NYRJTsEip23dIa36HSQZZIWDJAhPoYAknR
	 REUXmzealeYx8AdNQqDG8KapN8yi5yZCXX7vgc8T0U4CMlpIRt7/KjeAZdhruboHeG
	 pao8D/xBiH12p+W5OD2Pat8xC9WhfGOnCNAyhCl5PoXyUmKf6lHQTCYF3LflW1nVzc
	 OklKrV38XlcWfgi4g/V4V54aZF7Xu5SYEfyHhcenHBJQTFQOVkYItsMdKIJs8d+Ngv
	 Oq0fGodncyrMQ==
Date: Mon, 7 Sep 2026 16:27:41 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Pedro Falcato <pfalcato@suse.de>, "Liam R. Howlett" <liam@infradead.org>, 
	David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Mike Kaplinskiy <mike@recall.ai>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Subject: Re: [PATCH] mm/madvise: swap in CoW'd MAP_PRIVATE-file mappings on
 MADV_WILLNEED
Message-ID: <ap7Xz0clF7sOaAGK@gremlin>
References: <20260904-madv-will-need-map-private-v1-1-6b83cc99fcff@kernel.org>
 <apriM1q4GzAgP7JQ@pedro-suse.tail5790ac.ts.net>
 <aprjOxDy3JCPb2oa@gremlin>
 <20260905171757.ba8b0f8f0f18ebd04418bfeb@linux-foundation.org>
 <ap6u6Ana3MvvIIUe@gremlin>
 <55ce7bee-c0e0-4051-8bc4-26cf3aa3f7e9@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55ce7bee-c0e0-4051-8bc4-26cf3aa3f7e9@kernel.org>
X-Stat-Signature: rubf955yuyjhymayr7yijiazdikrqrhz
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6B4F1140008
X-Rspam-User: 
X-HE-Tag: 1788794867-204065
X-HE-Meta: U2FsdGVkX1+2+dgCh5A9m/CMd+bIq4xjOoYczqFI41K7nnRoL2422zahx1ZPAZ+P8w/MCyv6Xa8g/0ujihZeVoex5q66AV4clwZoVJ0r/SMN5+ppYDLhzRau77jt4sfZ5H2Al04eP3ZvikyBS9RkMpPyqDRnUW/Uhooj4yYNYs2mXIIh9DlvMbkmkfm/HSzKNK+Le3aU6zW/Tl01vmi3CaDwXQuZ5y5VBbd4sY2tXwCDIKwU97OaUp2M02dldn77ohKv13f9DgNAAl8zHSfnuvxGip/akMK2Nt3+4v1yK0NTpYX/+8fuk10QryNNJ+At2b0heEaPkaYwzuUeh/NcA9MF4v5AR3AhNu7VW+jk7yeruQI9Mc+bxCqhPy6toG6uhM89KtgC0Eov+1hw0c83Sqd0osyS917SxIbJyvI7vVegjj8rOOLo3b6tn5HyeiiWDGQxacDLZL6r8/Up2Csv8N2if9aeOEoMwijGGNrl6NbSnwzGuNY2tXSe6awWqUmBqL3jAb3WGuo1oFYP5XHi/W51CRDIzPy1Dm5d0yyaantU4KY5/jqGxbrRxu8rhC5mtolTqA60BJLNWNkyKSrMupV6D7BVenzL2sVEmNptxFHAFdPxwV1IyldoOYI078b4AKQC+yo/YoLRIUx0v1GOycQUMY5izsbHU+DQUp0n4L7uPXl+o3lGzd5i7ebb9ITzsdiougykWjkbb5yZ4D0j/wUzxTXPIzyyFhSVOzSG7hhHOdFpmrB00ptvz6pxFzlY7RtqqcNgvykZ/cRYr+66J8+DVlx7dIwjt26dnZgO7T/4zPCdi1aZqvE8QobgSSmGWkFBsdhz828lK66PXGIRX/VkwUkQhnf2K2ppz1U+VnSCJKK4T+VdFecsh/u6ss6t06pTbm1RXBYxZ+c+v7q9xLaRQKCJ6j5ho8RAMbIEWEvABiq69pZ6LdRUi4HoAPS66A2AYgHh5ZGBoDktyGm
 2sR2Sl96
 EGi3LI0DnQmVX75R123hvvzRwI40oXykirIe5EL4CcapLl1uTdcwtXO7TYKZE6WMLlH9EpFbdnCm0v1W4K8WaKJtO8/0dbyh7C26ukuuQlB8sesBS8OA7zMcaCvfLAl+PPoa3jijuZdl5iafViSBFXPWIKabfvCox5J5sb219mfMRs38viHNCKM7fsY6KAZM2kHpI/8dsFiUrDpAg1RZCf4xyJvh1fdc/4jcRTlzqjbySTj6mRYws1O6cjSOFdzvCoxb5yDgAu4nOUmiFklMAscTolTxKg47/kbuxsJfJug+Iu30GiTHtq+eISwNX2PtP/sabZOZkUNwek4beanjctTpCdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 07, 2026 at 05:09:34PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/7/26 14:32, Lorenzo Stoakes (ARM) wrote:
> > On Sat, Sep 05, 2026 at 05:17:57PM -0700, Andrew Morton wrote:
> >> On Fri, 4 Sep 2026 17:01:37 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:
> >>
> >> > Andrew - could you swap the patch out in-place with below? Thanks!
> >> >
> >>
> >> np.
> >>
> >> > Currently MADV_WILLNEED treats file-backed and pure anonymous mappings
> >> > entirely separately - using POSIX_FADV_WILLNEED (equivalent of a readahead)
> >> > for the former and a tree walk and swap in to swap cache for the latter.
> >> >
> >> > MAP_PRIVATE-file backed mappings straddle the two and currently get treated
> >> > as if they were purely file-backed, meaning any swapped out private pages
> >> > remain swapped out.
> >> >
> >> > Resolve the issue by explicitly checking for CoW'd MAP_PRIVATE-file backed
> >> > mappings and performing both walks in this case.
> >> >
> >> > Since the logic checks for vma->anon_vma this means un-CoW'd
> >> > MAP_PRIVATE-file backed mappings retain only the single file walk.
> >> >
> >> > Reported-by: Mike Kaplinskiy <mike@recall.ai>
> >> > Closes: https://lore.kernel.org/all/CABeknB_S2XJSHFgnHdgnN0rjzHhH4oQJs_APq9fvxHztQ_pgiA@mail.gmail.com/
> >> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>
> >> The failure mode looks pretty obscure, so I'm thinking that no backport
> >> is needed.
> >
> > Well it's not even really a failure mode so much as a 'known limitation' :)
> > So yeah agreed.
>
> Yeah, as we know madvise() just an advice after all, the kernel is free to
> ignore it :)
>
> (MADV_DONTNEED and friends enter the chat)

Haha yeah, another brilliant footgun invented by the proud folks at kernel mm,
catch us next time with some prctl's and BPF APIs! ;)

>
> > --
> > Cheers, Lorenzo
>

--
Cheers, Lorenzo

