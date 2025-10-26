Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27154CCD193
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 04:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0988E015E; Sun, 26 Oct 2025 00:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A14B8E0150; Sun, 26 Oct 2025 00:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DEB28E015E; Sun, 26 Oct 2025 00:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0ED8E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 00:54:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EEC5F577E8
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 04:54:20 +0000 (UTC)
X-FDA: 84039049080.10.DB7D97B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3DB6A100003
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 04:54:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZSa90mR0;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761454459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1qWh9wQYmqqXjANQ9udrR+FHPUEdVxXolZRGRUJdBI=;
	b=m9npZpXoCe37DsfnDPrlFm3Xfq6WAeP2G11poTe653f/AUIvrwA+SzS34FS+Fx+tgaI3LX
	HCzdWbreX9JMFOaKlnDpsgRn6HDQA4Evy9GluRtZ5HWVx0jNV62hBNCC+fB0l4hECn3wnC
	0yOBUJkWRP5RNeTL7NaGkdjmrjjg12o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZSa90mR0;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761454459; a=rsa-sha256;
	cv=none;
	b=Cvo4SVbS9SaQoT8t5YqHjyMDN+mFPo0voD6TeMV4ZbTru1Kz30Q4bSPthXv/bk4CUf8XNc
	cXyzau3RWat5fi6DhG6i4Ai6zaWBErqEGZlcbkLyrtS8OBbQPDcFZGiJz8CeRaKT6if3DX
	vPs06dtABX4q9qtwD4KOwTFmzEF8cyc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3181E4422E;
	Sun, 26 Oct 2025 04:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A70C4CEE7;
	Sun, 26 Oct 2025 04:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761454458;
	bh=ucWJuWDs7R36b9/cO5QkJztWCLe4j4T2lRr4BgXYjkw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=ZSa90mR0ncqVcsn+MWBFbF6cTiS2j8rPQM93oADJ4MLoxpTvK0abfvEwrQdH4NyJY
	 ZguZeHhHFg8HHhNpkr6fzPHh9FpaXSo2HREt9XkTep4zWROZeEfRc+H7PibHtUB9Bp
	 QJnC0l/W4BkCdCKVO5dV4weZI0VCrwChmVfmIWGo=
Date: Sat, 25 Oct 2025 21:54:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>, Alexander Viro
 <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Harry Yoo
 <harry.yoo@oracle.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Darrick J. Wong" <djwong@kernel.org>, Dave Chinner <david@fromorbit.com>,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 1/2] mm/memory: Do not populate page table entries
 beyond i_size
Message-Id: <20251025215416.dbe01a36382fdd1a6d6a8e5b@linux-foundation.org>
In-Reply-To: <xhpgje5pb5sxi5frjvje73v7oatablynl7ksyjnbrglwh5qx7h@fforsl3cwbl6>
References: <20251023093251.54146-1-kirill@shutemov.name>
	<20251023093251.54146-2-kirill@shutemov.name>
	<20251023134929.b72ab75a8c132a17ae68a582@linux-foundation.org>
	<3ad31422-81c7-47f2-ae3e-e6bc1df402ee@redhat.com>
	<20251023143624.1732f958020254baff0a4bee@linux-foundation.org>
	<xhpgje5pb5sxi5frjvje73v7oatablynl7ksyjnbrglwh5qx7h@fforsl3cwbl6>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hy1dbnu6aj7eha4u9xumbmnh9fufi14q
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3DB6A100003
X-HE-Tag: 1761454459-848126
X-HE-Meta: U2FsdGVkX1+jFv73mVFcBSddj4BIWagu7tbIbGQvH6dxho1BhGIEHZNAdd99uw/b5pYiSIF4WV7pNFvyWnlbmlVMLDtOuzPAL3kRN1P+AkM75orTvcCKfW74UT3SJJNRYNujaUwDTRxat7hUW5Hx24MpBd+S3PHJcz5jebjWOhHSl7GAxq/lXyfJR1BPV4GyzzMNboYjl79jK3NEvqcFTOcjcnv+yaJkZ01vdFRQaGr83OvxaxIGIjAUu/1h/cIPb+2WSHsAjslY95ESN0vq2401/M68CEZU9S81J3FB8akHj4OLOpxq/8DAyQJgpAL/uXAvohR/eX8aTUaPhzb4efrCJO4WOk4MKgvHh19uuEJMJylZlCscQRcwb2taexJDjtokYk6UA2IklHnKkN6qbkgYGJGeCWgOuR/dpU4ECrVsjQW52Z5LQ4IPBdfieb0S4EieByE71E6d+437g1YWpioz0IZozrGz3tWPxCUR2/l0Dg04D0YPdHf4eanwVKE3Hxw4RPWBXUUqV8Wnh6LJeuRCDksuAEnHgw3DlB4lgVkt5cr6/QJDV35EGa4qQypcDVjQ2zpMctsh44zP/Bl5jciwi1DZAswGUJcyGrMeOemmXkpSXscgL/NHf6/EC/FblWny4BLMFB37YZs32jCZYPz/bI7SyvrK4AX4Fhuhs9g21cYrr0VL4g4nTMGOOuZvDGNEHRcSP4yVo6pSJtMo4S1y9VBEelW/Q2ySBkFNDiiFtnHf2E9VOrpPVAwOnIpMtAfhBnKvEHW0CMrwryJscn2Q/qIO1xeGvGO+YHW3vAVKdYJHbZsgjupkYQmgYl5vDGWaPPOEHy8ZReGGggEdPNcRPJuDfT7/g87NVKN4O7ecw/kOU2SRsXZSaXM1oeymfg8ZmQvB6F38jA0yFqfC4X/bywD/xVbX8o5T9RibeDI0fFpRZVrn8ci/DDU4KR0vqvHcXSwWaXP3eoeDO8P
 7xf6dnec
 sWeKCIt0Zm04ziCYCYZwRbkLrdkKyBjLLu3vxDUQBoTDpiMvZiC5o9EXeaYOOqytgktB73lEcem3l606IBWQ3gAhii7kvQL9h6b9Z97hcdPVpKztdxe/VFleby8D9IQuZBCmp5h0gR2XhyYUrBd6GoJuBH5sr2Jw1xs/WKFzKjAuWkRaNz747jx1WJOS0bUSw+cpkjIAFKaLEBjj8CDN1r0VTcOHTiYHtiKk4p1WRuVFpvTP+M26a/bfQWMZWcS0OQFs6XE1luSPFwV0kJ68Ua+8wsCS3qbZAuKnvgt+V9fJwKIKB2BplluvUarS/R2slJDmncbMfYnFZGntsg4NKB5wRbFgr9A/VWZXm
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 24 Oct 2025 10:26:05 +0100 Kiryl Shutsemau <kirill@shutemov.name> wrote:

> > Because the Sep 28 2025 Fixes: totally fooled me and because this
> > doesn't apply to 6.17, let alone to 6.ancient.
> > 
> > > It sure is a fix for that. We can indicate to which stable 
> > > versions we want to have ti backported.
> > > 
> > > And yes, it might be all stable kernels.
> > 
> > No probs, thanks for clarifying.  I'll restore the
> > 
> > 	Fixes: 800d8c63b2e9 ("shmem: add huge pages support")
> > 	Cc; <stable@vger.kernel.org>
> > 
> > and shall let others sort out the backporting issues.
> 
> One possible way to relax backporting requirements is only to backport
> to kernels where we can have writable file mapping to filesystem with a
> backing storage (non-shmem).
> 
> Maybe
> 
> Fixes: 01c70267053d ("fs: add a filesystem flag for THPs")

OK, thanks, I changed it to

Link: https://lkml.kernel.org/r/20251023093251.54146-2-kirill@shutemov.name
Fixes: 01c70267053d ("fs: add a filesystem flag for THPs")
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
...
Cc: <stable@vger.kernel.org>

