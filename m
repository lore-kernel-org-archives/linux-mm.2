Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60086CDE00A
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:59:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E0196B00AE; Thu, 25 Jun 2026 07:59:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8256B00AF; Thu, 25 Jun 2026 07:59:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CE116B00B1; Thu, 25 Jun 2026 07:59:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E3ABA6B00AE
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:59:11 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 684491C61AF
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:59:11 +0000 (UTC)
X-FDA: 84918289302.17.3874F3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id D2812C0004
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:59:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AArBWtJu;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782388749;
	b=v+eziQ1/+cGjEdxf1LhYXRa36XHeCOYFtNKsb46L4/T6pRv39kvc2g2fl15l774GfTZjr4
	Jg9pxFo7fQby9H7pfuaX46IvYVN/txrp9lG317FP5QQ2I9ow25xZFBaIm0K5nWg0y3hGnr
	pgJBLPm+eBoMktq2+ALpKdeISY6peS4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782388749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOWUv1XfnbEbqm4GgtkhR5DJeEd/Hng/YV/E0/Qc0Cc=;
	b=0Dtnn8dl1rIcGQUKUrIBDtGLxkuBlpegiHc5AhUArYZMLgC3Mwo2cs9JhWxSqQSbKhc4/I
	Li4psB6vsIC09aMnL4lBH17HQshpTVECICh5EiLuv2Sd/uM/4th8QCusYHU/n1JSaMeccC
	sLlbCe8HwR0UL0+6DjaiuoLTPwHXkrY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AArBWtJu;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F328843232;
	Thu, 25 Jun 2026 11:59:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12FB1F000E9;
	Thu, 25 Jun 2026 11:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782388748;
	bh=SOWUv1XfnbEbqm4GgtkhR5DJeEd/Hng/YV/E0/Qc0Cc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=AArBWtJuZNc+/FIFUIMlGuEZ8kMvlKEFWkOuvjAEvmSCRP6Xtr79DwdLfMRKxlCsp
	 Y3IT3WOyGk6qDjC+t4HKdGewaQIfROBx3//zGaqkVvAIWSn89JQ5+qpQIXdCm6oMxe
	 psbFJ8N1cByHOQzNmWU63y70+iMNRCiyAjs4IyQzZXKg4LEnhDy1S1MXdKCNt/nrsZ
	 xUKH6wlT1qw0OomPAMWfNmOPisTudnb6s7TrvtA9fGPJODLcaiOKBZlSZh07z2lZvG
	 ARk0cWPCvn/SNRPjo4quuTXhn9k1+0qPGQG2NWAw6QswrpPXgADAiOxmSiH3UgiJ/3
	 BLqOQd0LHWe1A==
Date: Thu, 25 Jun 2026 12:58:58 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Yitao Jiang <jytscientist@hotmail.com>
Cc: Alex Deucher <alexander.deucher@amd.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Felix Kuehling <Felix.Kuehling@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 1/3] mm/mmu_notifier: let interval notifiers block THP
Message-ID: <aj0XB-ZLl8uhSDzQ@lucifer>
References: <SY1PR01MB10596EB75463208A8E1EBBA0FC0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
 <SY1PR01MB1059616E59F213B6FB4F4E3C5C0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SY1PR01MB1059616E59F213B6FB4F4E3C5C0EC2@SY1PR01MB10596.ausprd01.prod.outlook.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D2812C0004
X-Stat-Signature: 9ep4onch5tbhxzhq9app4e6kagz5jiyg
X-HE-Tag: 1782388749-153537
X-HE-Meta: U2FsdGVkX1+uq+Mg2bU/UOYBD0HikjPQ9G9aNfuRGKnQHDZEPY0TdJFlq1YX8BZXELjAn91aXcVfjEg8oNktB3+ntRBuJhOggNMNWlfLFTeMnt2Q5lT6+c+idy3OGV40MSuuUOr/ig0OY4QKZXqClB9RALziWzOwACbMtOeRPu7Bh7330fy9dfV4ubmpFA43BAP6gA+nciw4UV+mGp0hM+vfpj5kjh/Hb6cIURM7ZPht+pHPmShC+qybSMs1f6rdJwLJFUN43eBIaI5lsYFtZxBMwK3msHNgXH1VzuEMFitQDenckc0rcloiNy2zwVqIA1JWsXg9iCDEFOCgfvtA+TWfLAyx2WHF5zxorJmkbt3cd0t2tObV77i3iwkBIToM27KEjZk7OSka+dRkBB4Q1YPzMEUaPA4C1XwLIkI5ouUNuFHLeq95w83nRVN2AiGrlmsS7Rz4d+teGzrEkWaVOJ+sBO3yYt1taCWRjTWgyXlbV/xVWKW1Bn6yRYf5ImI11zR6Jd7Qvm5YkbU/kNt1iiFPh3Nn3HbohnEQs14y0OhdiNzeDJKMRBifar6yq+AvOZ4y9I81SKVE1B6+E313mAVDSsQVT9A+av2p10BZ5iHhsaFE3td1i1RmDA7CnfvMcvy6Fr5xWZ2pFo3V5e7ypJVDdgjqfGd+c5rizBk8ieB25ySokUh5xXqXDK2XWboMdBsybdWjmTLtr4ASfk0vHp4+lnDKBi55Ilv5hGNkl8e+btDX6sE4HYJQOzMCh+kf9cXPXCswe45lGx2D74RA23KKl01Kr2rIIii2uymIEDWhLE6GImw5j6/z7/UQuIAX7lGpqgbHsfSxJpA5ILr6O2JRx830Zum3QBr0d9UzaviUi3cdia4ehyMq/ZgxeB14wWtaWiFfj7kjPCM1nlcTRe6UPdznV3ZYkg918fUme734lCpNXmXhvholZB9dA9FXblZA2PUji5QwFh+1XLX
 NEIvD3nE
 MYfNL2+XjKzU1An/iRfCeCLLoauSE4dopwVoM96OkuoJdvRwwdrE9XtRjh8+6ZjEGp33JIjzJEYdRboaQ544uoTlmPRFCUcGJ29qLeXPAbefH9fK34Gv43LMfprQ2aEeoNy9NzxO1C1sJNAE42UA24dBz+CEoiaTB32oTiSj3f9MyLwYvUEvWak0betWlBsWNZ+aDwF/+ZJ9/ri/MKTbxeQo5gscMKQdgflSBAQ7LIlXGsLPD5dxKlGhe3/KVN7skiqTNqaO5XaVjmqxijvtlvoS/i7BIWE0Tk/MukkFVaXzFvaai1wD6omVleeVefPdFiSCKT8814hDEtC6CMxWdwVHEaXYnX0PygJpFzzKD5JJXpfEGO6n2mgxEzP8mxuFtelAw3Df1tCxmR7rFb5h2N8ALCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 25, 2026 at 06:59:51PM +0800, Yitao Jiang wrote:
> Assisted-by: OpenAI-Codex:GPT-5.5

Thanks for acking AI involvement, that's appreciated (and there appears to be a
fair but of unacknowledged AI-generated code being submitted at the moment).

However, may I gnetly direct you towards the last few paragraphs in this document:

https://origin.kernel.org/doc/html/latest/process/generated-content.html

I think this MAY be a case of the AI possibly misleading you into a crazy idea
when, as David points out, page pinning is what you need :)

We don't bite, if you have a problem that you need to solve, feel free to email
linux-mm@kvack.org and relevant maintainers/reviewers from MAINTAINERS with a
'[DISCUSSION]' or '[QUESTION]'-prefixed thread and we can help you ahead of
time.

Thanks, Lorenzo

