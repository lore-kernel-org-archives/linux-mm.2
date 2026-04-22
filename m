Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED1A2F9B5E3
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 08:36:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5419E6B0088; Wed, 22 Apr 2026 04:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F27A6B008A; Wed, 22 Apr 2026 04:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4083F6B008C; Wed, 22 Apr 2026 04:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F35E6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 04:36:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E1FA48EEA4
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:36:35 +0000 (UTC)
X-FDA: 84685535550.13.78DB560
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0FF22C000D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 08:36:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cy6kjQFk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776846994; a=rsa-sha256;
	cv=none;
	b=N/HZ7eqjRDBsAke18s7WpyGEaK///8XbZTvLi6Dagq24KZXbjJjnXNqIA7c6ozY8QFKPaW
	6ChFz1CGebrkaCyg7pnsFPmAqI1ind5OLxkYpmmoHZzYpzrUAS6W8YS5I1TexdHpgdAZAM
	KdY61lFBVyG7/IgfwPVGKKkrfxwBguU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cy6kjQFk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776846994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4qjpvS0H3Mptmlk4Mcn6QxosNXFOFA22Q2Biuk+rio=;
	b=7DKXguhrEvYCaE86z/Q1xywSYn+XUWnCPfL9H4bUoMWxdhFZn2gJQ6tNo/RH2ESQqqMQAU
	OrH9xuVavSezrFqjARvbOXOz75FOpSZATlmSDoLqGg1Qv8at5NQW9Uj0X0Yu5yRbkYCLj2
	vmgDxunzSzPAE6Vj5iNYsP3vizCGJNI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC20543CB2;
	Wed, 22 Apr 2026 08:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEFF4C2BCB4;
	Wed, 22 Apr 2026 08:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776846992;
	bh=IB4+zbAiRgQvocbxfAtp6b8wPK41BKcoSAZmR2iOybs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cy6kjQFkF4jpcqM44CdJdI/SbntqMzc47zdacoBocnMIE+RSA+Yir8eEMGdL9vCJy
	 cBNICFcr6ytzPrJPd6sMffkPGMU2+zvaXrYChZLUigJ1PXdouprajqfuCEho/05zmJ
	 g4cVaMJ456kQZ0GnQrQtXMN0a8DBtFIDgm16hF7OOE+pvUUVENNys5oIeGP7JnFkKa
	 y55XbkMCTid2VAdZnPiIRmaSzkXjjYb9jYTMlB3pUdtEgtiBUupysiRM8ZksGt1x+6
	 5Eti5wswN2scSv0+4RnPEF0UUn4P5UmdFhuwo6jVqBMOAEnXlU/3mvuIwdEbTY922G
	 4rIdHY+9KX39g==
Date: Wed, 22 Apr 2026 11:36:26 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org,
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: Re: [PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
Message-ID: <aeiIish34t1mA50H@kernel.org>
References: <20260417135805.1758378-1-ekffu200098@gmail.com>
 <aeXIKM9BeRmaCZ_d@kernel.org>
 <CABFDxMHT0W-FFuLJwiWMqXueXZvz-2wSsZyRPKJ6ki6FhVPLnA@mail.gmail.com>
 <aecZPdGyF5i1baee@kernel.org>
 <CABFDxMGU8DwoG0yYb8gBstntTJ5okY-2bs_2iywBnrSX1H7-Uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABFDxMGU8DwoG0yYb8gBstntTJ5okY-2bs_2iywBnrSX1H7-Uw@mail.gmail.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: p7m4mtb567in198fpgig64184ztxpu4p
X-Rspam-User: 
X-Rspamd-Queue-Id: 0FF22C000D
X-HE-Tag: 1776846993-751590
X-HE-Meta: U2FsdGVkX18lS63iga04hfdZzwbgzELOtU9uYZgw06Wt0qcMo2OxbeQekaW0AuYCFrl6JW0o/RjcchQzzgJWQvg03opPbM0Rjq0hv4sMDeQxHOlkvkjG5GMBPIFQu9csRtKqVBNdQPtMshoC7NQpC5aZbREbCRdfJCXA67kQ0CRddOVbjLlyKSGI0Cbjgo7YbEFykx5eSm96q5Ij+f+aOxRisvKJ0vXxYESLbFfAvUGfFgtw9fU01A/P8RSOsOx77YMA7Uvlsw1jVnFx+Ond+UJM4Vyx+y+tPrNjwkSmziOAChuWoogb18WcDm+TU+GJwawRbxrBrhbtOmWUk7jvFJ8u/E5oxQQWS2b42c6uDzMRBKYugWKW1km6/uEP2qWbjqD4nEUXjDJiw+/zusvYkQLHp2khIYgcCdjDD3fElr6keDqAtZUUL85+4sqw+9VIzyMvv0p+RNuir5obaLmYOKDQlPg1vPVQ+3CYfDYD7zotw5Kf7e7HA+A47WRB+LSpumNPB943iHVeoT4ba+C5ieLyKh4Bv2TJMFOWSLdiNB1iwsMnxnNXHcLAs1r1axnbTkQ0IiS/blCaJJ6F9g36BlwktkXJwzuLNwTyEEzWQKbVKa61ZYJXjf3vo+5TTwrGmeUD/L+dw7Sy9kthbrN01grAEnCXhvt5cNpoicz03WA68TxKic4S9j5KGhXhsP/aQJtxE/tijSggFBrZI1eisaFPVXNzZW/pEtli1uuj8E/hY3kqgaV0yzgyghRxKgyw+CvXcQk3qBwKMXl2yMSvCjUAeOiBaRarvIbjC1+2CeimfRNGbxGmY2qtNGNS0oE07DTT/Lt7j35VDURgzmHwKgzk10RER1e3vRVGvkar5gQoqvK2p72tie9dxIA+4KvSgcXFKsMTLkXVkwCe1RrJyV6bFX+BLEjBsYP589RA3Z1EZG7Jo7vpycH44jBeNsEj1NfZasUCI2X/FWpkWUR
 QIv/Et1A
 t9iaEtbQkGCsYioPeRW+rSMrGKWBC9dkzqI0+1/aRafl0I3jCWohF21LYYGtM+ljS4VSnRED0QchZ5EhNFKOsTJaK5Zos1wB2MRq/VuWg5PaKbJBZPY8dJPnr1dDFLgmYo3iQOoccWU5aQya5k8xSkWnYVDfAd2CulPHdLxtnSoIfoHVyTK0cak1nb2nz92vypirIYqSbjqQ6rWhc3sYyWyaVBlKBev8FFVXFIRsTi/G9dsAna1W8DvGhjINTuw203ovECKl69/O6fdR/rKVMCSPiBOFiXbHW2qpPAJ02seUBw78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 03:56:01PM +0900, Sang-Heon Jeon wrote:
> Hi
> 
> On Tue, Apr 21, 2026 at 3:29 PM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Mon, Apr 20, 2026 at 11:26:13PM +0900, Sang-Heon Jeon wrote:
> > > On Mon, Apr 20, 2026 at 3:31 PM Mike Rapoport <rppt@kernel.org> wrote:
> > > > On Fri, Apr 17, 2026 at 10:58:05PM +0900, Sang-Heon Jeon wrote:
> > > > > When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> > > > > returns the next absolute node ID, not the number of nodes created.
> > > > >
> > > > > The existing under-allocation detection logic compares next absolute node
> > > > > ID (ret) and request count (n), which only works when nid starts at 0.
> > > > >
> > > > > For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> > > > > 1: 128MB) and numa=fake=8U, 8 fake nodes are successfully created from
> > > > > node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> > > > > fake node nid starts at 8, but only 4 fake nodes are created due to
> > > > > current FAKE_NODE_MIN_SIZE being 32MB, and
> > > > > split_nodes_size_interleave_uniform() returns 12. By existing
> > > > > under-allocation detection logic, "ret < n" (12 < 8) is false, so the
> > > >
> > > > In this example it would be 11, won't it?
> > > > I'll update when applying.
> > >
> > > Oops, my previous reply is not the main point of this review. (Please ignore it)
> > > But 12 is still correct, because split_nodes_size_interleave_uniform()
> > > returns next available node ID.
> > >
> > > IMHO, it would be clearer if both the commit message and the function
> > > comment change into "next available node ID".
> > > If you're okay with it, I'll create v3 patch soon, including minor fix below
> >
> > No need for v3, I updated the comment and the whitespace:
> > https://git.kernel.org/rppt/memblock/c/a34436ac05e76bd6634a89fc0a399ab3a48f509a
> 
> Thanks for your help, Mike. However, it seems like '12' was changed to
> '11' in the commit message. I think this change should be rolled back.
> Could you check?

Node IDs are counted from 0, hence for 12 nodes the last nid would be 11.

-- 
Sincerely yours,
Mike.

