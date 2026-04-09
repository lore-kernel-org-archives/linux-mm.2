Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABDB9F364AB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 18:12:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BA156B0005; Thu,  9 Apr 2026 14:12:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06ACE6B0089; Thu,  9 Apr 2026 14:12:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC2686B008A; Thu,  9 Apr 2026 14:12:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D71036B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:12:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D10FB62BE
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:12:37 +0000 (UTC)
X-FDA: 84639812754.09.8ED8F17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id D732EC000E
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 18:12:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XZB+gt1h;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775758356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tHNHJwgaPtwJHWT9cgWPi4YPKOqp8AtFlU26wzvYe84=;
	b=ttB3R8Qbi17gOaQkRzMRPWal8cKHnUOS+aIO6+aU9/9V/T+ZXynZtyfRflhMMVana+nI18
	b/cLAmNY9asavHA1g6LuT+mK0irApV83ONgYL2CiEW4sWTmZa5O6hY+Us+6RsWAUSVmsTg
	b+NPlqAYqtoEUgiaP/hFXdun4k/7Mtw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XZB+gt1h;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775758356; a=rsa-sha256;
	cv=none;
	b=1mwH3ZCdpIHfNp0Xc0yzdfkEpeLmt9ih8dzQpHLrz3x7HiPN/83IE4kxCCUKQ/N3FylPhQ
	x9l9gTdmvCKnWhai8q+5bygGglbv/FPcPineTIR7bxh6aqbrs1oQbPK9Lhi/x8HZwypfzO
	AJD2MeFCqbH3Y/DTK6xX5p8NUfs93vk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 99DDD44349;
	Thu,  9 Apr 2026 18:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60A26C19424;
	Thu,  9 Apr 2026 18:12:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775758354;
	bh=gcApZAdBePxG8cWm/tm+Oc6ad9GPWAlW6Va4NZC3jW0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XZB+gt1huoeyJXJMf+p7UwRj6HsC/FbEy7qDkwD5ZUGfQ127x36eeMNORElkDhlWW
	 EsiTvceg0xAtxiVpe12HgsCQHniaF0JL2nWrf+0/h5qykNkkKsu9HlaTx6MfoWWv9V
	 Ul1ARvPVql//ctwHzw2xatqCy3LFLujevTXXG7Z5cv6EuRM/e8BW2R3M+XvQ1C7F1c
	 RSsSoF5jgAw/KbMM8GQzF6R41ANa1hp/L4SQv7K+XkrDLve192cWb/yDkk9vtxR9tb
	 AtwuC0p6/HReEzEgQcoJahUaQ6svxKToJ4yrtlNOVXAAFutcI2X6YTHzqcCzOVagOm
	 GJHhcCFXLywoQ==
Date: Thu, 9 Apr 2026 21:12:27 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Xu <peterx@redhat.com>
Cc: David Carlier <devnexen@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] mm/userfaultfd: detect VMA type change after copy
 retry in mfill_copy_folio_retry()
Message-ID: <adfsCwaVcFk1sLhj@kernel.org>
References: <20260409120653.290386-1-devnexen@gmail.com>
 <adfdVbCY18PZMfI-@x1.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adfdVbCY18PZMfI-@x1.local>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D732EC000E
X-Stat-Signature: tbmfricetdbiruqdkbcqy4c96ha4xn5e
X-Rspam-User: 
X-HE-Tag: 1775758355-852249
X-HE-Meta: U2FsdGVkX19bHmqinpB3Eaio29OOjd8r5eFntCuPf0nVCeNHchxbjpGm7Yh/iTD+j91zDpTw1V7D1fXcyY1VzlIoywuacD214C0WVi5ekT91Rqq3eqH5abbG73AGMHRkA48pgs2lxgn36tp7W5V0aOojJbeuHjmSun0i1JBTsvQV9c6U5t4FjzTs0oQDGJlt6vj1p0bQwoinhPGcGjVPv9w2XtuOEk8enB8yP0cQqIe93lIeT1UrPifD7EtMeWqzmQUfbcWqaefd8RUtrKCNhh+L3hOHmguqtf1mC3/vW//OuvPjrJI4z+gwycWodTnnDC5Mvp9JHrD3RZSIctMoOsU7VCFvMD+MHjnY9fmEzqJZ960C+iu6zin2LSMamkUrTwtURnyoa86a/SjDfS9PNV0ltjCfh+jIG+3bC89qPPIdnTXKJym8ckLcsfyQf9VWUnLrE8Z3NkZE5p1izUU3jG0t/fLYGX2SCC1mycGtmFQKBmtO1A6PW3cZvDq+K2a0xNdCC+/CFS4YM1FoCTJEP5el4XMvNkLEQF3ghrrUlxYtG/c6crnCH//JcYG2C7eoMsr3eUW5AEZd0QHRO9u6nVeXvQFE347PY4jyaTZXvxUSBy/GP2aFX1FjT9FMa0OeARxD8oJxISdwe5wDclILjckAmLvojykvWyWN4EEJNC/7zdjs7SRARV1vggcHL4ke6+ynXQ0J/2uk2eeiiw8aYC4O7CnokpXGOu/AIPaVCd8KyrkCcKnTg0VStB1RlZeYBtXj7wBfCisvbnrxAcjdlgenzZ+FMc1dX0STvGfo/BerchGDBSvxqsdxFtFehCz0GVU4fRwHFqN0Ol9CX9sEOe9oow64XNn0TJtzHrPkwCspN0NLSsO+ac66BCsZZw2Zls3aWNKakCJag8NGaNelrshRTjei3+mvGI/DSvw6O9aWM+E9rLpqyU695XrJW4B64KsfV2mbNYleFyFhYEI
 MPEl8sVf
 JXF+bdO2xmOTSTCxZ29H6A0bsjC1rzTpX7mOKrpBxjN3LkcfrsKi0SkwCxH0q03Jggh/M2wW3CTCB1KRxzOodG6dLAq72zEWrgxabuKh6TVW6xhDym+ZKQsUQwGTAPG7OLBxxxX68A/KPAV1uLWxG0ttMOp6Vrlp+RlReOWClSKb1k3Aco+tNSRPc7lBmkT0ho4H04XAQIGb/D7w0a2KSfbc/He/XbZe2L/a7Gc7D9OXUkZoY/d7DkcBLLXl6Gnzvs+29Qg0gG9dAPxh7CBU2VDdw+Ek4MCX3QJ2r92WeOVSMqeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 09, 2026 at 01:09:41PM -0400, Peter Xu wrote:
> On Thu, Apr 09, 2026 at 01:06:53PM +0100, David Carlier wrote:
> > @@ -465,6 +467,14 @@ static int mfill_copy_folio_retry(struct mfill_state *state, struct folio *folio
> >  	if (err)
> >  		return err;
> >  
> > +	/*
> > +	 * The VMA type may have changed while the lock was dropped
> > +	 * (e.g. replaced with a hugetlb mapping), making the caller's
> > +	 * ops pointer stale.
> > +	 */
> > +	if (vma_uffd_ops(state->vma) != ops)
> > +		return -EAGAIN;
> 
> I agree with -EAGAIN here, but we discussed over all the things on possible
> inode change and I don't know why we don't consider that.
> 
> I still think those should be considered.
> 
> If the vma snapshot idea is not welcomed, fine.  We need to think of
> something to cover those too.  Current patch won't cover "ops unchaged" but
> "inode changed", or offset changed, for example.

This patch is enough to fix the regression introduced by my refactoring.

The inode/file/vma_snapshot checks are needed to solve the issue that
existed roughly for a decade.
 
This should be a separate patch and it's really not urgent.

> Thanks,
> -- 
> Peter Xu
> 

-- 
Sincerely yours,
Mike.

