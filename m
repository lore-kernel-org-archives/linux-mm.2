Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80922CCF9E0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 16:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD8018006E; Mon, 27 Oct 2025 12:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAECC8000A; Mon, 27 Oct 2025 12:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEC0F8006E; Mon, 27 Oct 2025 12:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BEE198000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 12:23:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 753621A01AE
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:23:43 +0000 (UTC)
X-FDA: 84044415126.11.27B95A6
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf17.hostedemail.com (Postfix) with ESMTP id AFDF84000F
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 16:23:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=PeKAj31u;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761582221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Wd9jZ/xyaKFNfuiEgH09msyR8RuNPw1/jIEYWNk9Hw=;
	b=G17N7VjNcxp9rgxxSRmVne5jzISGXSZECoTAiUmoBp6xiWj9PghbiwXkLHPQkZn/PZRfAf
	Lh25itqU9Iv5u/+yDveudXKSRQCOg7ypptjsdv0hXqIu8wztf5ofkHVD4mTsp+mO/TDtqr
	boXHemJxfxLVMMIiLX4ocWj99GGYdVo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761582221; a=rsa-sha256;
	cv=none;
	b=n76ccNsbk64tN5Ij0cWgajCkC5geyFNk9JE9O8C+KUIN4/hWyZXNApL/1s3YX+l+HETYGN
	QIP5Ucec0e8v8np+6zBjffe2wRAztqcPKzLed9hWBhACMMcFemev0TXrlvCGpWG//Ko8RQ
	K7l+8mPtsktmvqCVSWsE8QyLQjnyoR8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=PeKAj31u;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf17.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
Received: from shell.ilvokhin.com (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 0BA9B9AFE0;
	Mon, 27 Oct 2025 16:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1761582220;
	bh=3Wd9jZ/xyaKFNfuiEgH09msyR8RuNPw1/jIEYWNk9Hw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=PeKAj31uvlVwbZ4JZNdYKIZMrxmBSQwHpD5PTMWrucnMR8OgH/xH1+4UnNnm95dSL
	 /uW4LjH0fPhJ+uLcbRwguuYGrdZ+Q6Rg6pv9EaD3nrRXZQVj5z/I8LMrk96D0hs5Gh
	 owBQTp2y9quYMHcLtYo2CqlP/kUC5Nr747hbhC7A=
Date: Mon, 27 Oct 2025 16:23:36 +0000
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] mm: shmem/tmpfs hugepage defaults config choice
Message-ID: <aP-ciK_NsCPFZLHZ@shell.ilvokhin.com>
References: <aPpv8sAa2sYgNu3L@shell.ilvokhin.com>
 <aPstDXRerYqi1O2X@tiehlicka>
 <aPtg1vUnpkaK1Ce5@shell.ilvokhin.com>
 <aPvjFuio9lBKf2In@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPvjFuio9lBKf2In@casper.infradead.org>
X-Rspamd-Server: rspam01
X-Stat-Signature: smpc7yi3tbddxgdny3kp6r1d1cx7tnh9
X-Rspam-User: 
X-Rspamd-Queue-Id: AFDF84000F
X-HE-Tag: 1761582221-652337
X-HE-Meta: U2FsdGVkX19Z3tA6Faytk/6yA13Fr8uqWNb1A+5GGncmQtEE1nXUa0fmZ8F/AIbmJE3JFKcyLB1dVVc/KVHBU3Gq4hY31p/2pIXo0FvHrRWQtceQu2A/UQOkJ6dLE9u4kqwDIEqP7qTPDSq0aOpVZ6ap4e76H9wj0CIm7bdYVPW5Fl9MAODH/h7F9eg3kqwfjPTcaTKSXt5BXhWrAebkaSzKEvPy870dlXToOx5Hli/+L6D1o9bwHiZI4KSLjpR+3RLDvej6O+VTYhuo3MMzTBo6I8YzqGv+jFyCTAfS+Qo/clr1XS0A31mny/z8Rm2GvfjqVeBoOJaFyucWGXEDnkN1BRmelI3jDBYiNYD66AlQxfLTnRuw0IgB0tUpQ4nHdjeXHu2+3MqZ8ISV2jVaK/3wez48+pj/bAHEkkcPw80QyKuIJV2U/hq77FCmhsHKffcGF/ABzZ2Nnoh+JqHaPGeGMCFcNBIOPm7h2C9D1bZxoTyZNKoAFNZGzhWu1RUUxY2p6/SBcb+VedaU8Metl0YAIz/VlX5Vz70uGX2OtYdqpetlqF9M1IgbRH78ItKg8pIZc+N+Yfbi84J626X9sKp19qc17g8GQHjkii1S3wKbpS2I5o8jHNZt7g9HLN+LhrEkRzywKGM8xGC92YTL+PS/iNtyPso3dAJZz8yDxDRw+YPEPgX0BTE0Uvy3rAOTzUxXC5sg7e91u5E4ohqhpITpvXimhbSeEvEt0aZAcHPEBT2QEnZYEff1fZo2hnDW8eViHNF3DwRCEvR18K92kl5RUClp8mRtZHFXPjrf3UOYx3qM5ygNN2y1vYM+mgudUnvDa/Y14FGGjmVUZM7hMoUxZcd8Y9TYNPZ278fPvTjUSmrzmpHi9iuiVfr3pajyQxs3O1nR9lYw5w/VDeHAEjSt51wJa+CXV8V3wQwa4Z3RWJ4P1gEngkmwp4pZ0wpURQrw197BXgX4aI+1ZDv
 xCf14XiW
 Przg/hLprLGK2KJrqkT6wMxdXN48uKgpFECSmtG7ZJVf26n78VI3eHp96lLi2hTGnZEEvB9f8zKrGSlmXlx77bqlEL1SpegS/dx2S4ev7lf9hPnX1/0ioItoqXJAqNLLsraZVW/84z/CuwDDx0P+3Pl40f33miPccmIyotsJTWZt/u9CxBC9NJ67Wzf+Os1QpvrdWWJabJgnsnCJoRDdNPv0mLdEM8348Uutosv4t5B7uL7A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 09:35:34PM +0100, Matthew Wilcox wrote:
> On Fri, Oct 24, 2025 at 11:19:50AM +0000, Dmitry Ilvokhin wrote:
> > Primary motivation for adding config option is to enable policy
> > enforcement at build time. In large-scale production environments
> > (Meta's for example), the kernel configuration is often maintained
> 
> So you work for Meta?  It is poor form to send patches without
> disclosing your employer.  That way, we'd all be able to see that the
> positive reviews come from your colleagues rather than having it look
> like everyone's just "oh, i'm a random developer doing this on my own
> time".

Thanks for the feedback, Matthew. For transparency: I work for Meta, and
this patch is being submitted as part of that work. I know it's common
for many contributors to submit work-related patches using personal
emails, but I can understand your point and appreciate the guidance.

