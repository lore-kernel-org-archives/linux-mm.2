Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAFDCC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5D806B008A; Mon, 27 Jul 2026 14:11:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E340A6B008C; Mon, 27 Jul 2026 14:11:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71D56B0093; Mon, 27 Jul 2026 14:11:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B539B6B008A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:11:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C9604016F
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:11:02 +0000 (UTC)
X-FDA: 85035347964.02.BD7AC2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 92CF910000D
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:11:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgz4UnNG;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785175860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g0FQY8S0fSEGU3Bf2IiWPQIBoC5M7eurHC+TOVfMyOw=;
	b=aFTC3tuIv7/HuGeCX+IcMDry/2hvy9IiRGu8kiH91gr7KDBhMCjNNBoaQ8BUfBXebX6cIP
	8EwwsPnYT3pVEP4IfZkmwvNhpPS3WxpLyzY9bAec4E00UFbT86z7SeGAl2DArQ0VYBJC0E
	eJo+o02rO24nDr3AfX/9j35iVhPWDkI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgz4UnNG;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785175860;
	b=wn+1YPWoMAxEb8qW+bR3ffd6gCNoIm2/6mQhl6kSzCQlySC1sIf0fgNppY6fNjiTnuexvO
	t35Ap2E3yIAZ24NXfz3ObDNmBRx7bA1XPoYF+1lYzMcs/PCH6zo7+5PH3p2Eo3QKcMyq3V
	NLcyYQX09KjRAdmUGWrLarBPE9JWe00=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BEBEF41B09;
	Mon, 27 Jul 2026 18:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66F31F000E9;
	Mon, 27 Jul 2026 18:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785175859;
	bh=g0FQY8S0fSEGU3Bf2IiWPQIBoC5M7eurHC+TOVfMyOw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kgz4UnNGnMDJbFr07Zh72UjZH37rBDSu3pDdHnjvST3PtVaglZ0RbYr2PHFzYrk1h
	 SlbBhrfc+G7FubA9BTHNccBjGkZYD68jK21POgOuVbCGoLRXfzOE2sejZXtze6kgHq
	 T3l/wrQnD/GLAcSLqu65sdTuJ+8KnwRvmR814fqzWsIj/TX/0cTU38uIRgc9Dqs7Yn
	 UngsKRJyTYLv0iK0n/lb6V90BPCTbORtKT/UKHKdH4IW7dJByUvCbnR3+CKmIU8q8p
	 ChpTyC/A8dDursKm7O7xufMBxn1tPVD/Ibp0kd0JYbTpYRm7qo0wCg6eFnYS8OPN/b
	 fhkFfog7mvWkg==
Date: Mon, 27 Jul 2026 19:10:42 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Hengbin Zhang <uqbarz@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>
Subject: Re: [RFC PATCH v3] mm/thp: serialize huge-zero folio state
 transitions
Message-ID: <amee2qZ5HqwoLug3@lucifer>
References: <4146d4f5-c8fb-42cf-9dc8-a9d4c26055da@kernel.org>
 <20260727154001.4102341-1-uqbarz@gmail.com>
 <b915b058-f5b1-423a-a835-5891e7997080@kernel.org>
 <ameC4IWCOVBGlXZu@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ameC4IWCOVBGlXZu@lucifer>
X-Rspamd-Queue-Id: 92CF910000D
X-Rspam-User: 
X-Stat-Signature: fwsucpgirafmjujebwg9ym37jemxbhrc
X-Rspamd-Server: rspam04
X-HE-Tag: 1785175860-387787
X-HE-Meta: U2FsdGVkX1+uvVfHVAIt9jUNSmoX8StNvRvQFSpv+3hL8R7WLMKg79KStULuJnKNzukIpp2I/JHskj8AC2ns+KMbtND1CR/pQyGSo4fDx2VeOHNmty6CA7hJscAHm1tsXWnxkr47gwgPe0/icQ7cVszl9XYiIHMfzcH5IaJnwJdLa2zjkFmYuviG0aGoi7+bEQgYg+1doEak3OrqcW8Icgqguw5OeVt21RoiqzNGE9He4rDrTtTwGGv2ZX/PrwRQeYn7gqw5vJAl+y4xLuLjDgsBtXxWhL6n0H6rJXnB9gfwAF7YLLBVRBuwFNQ7+5mHudshmucCX5FfQDhT3N017PWCsw35fn/XFuJ0/q1huE6y/CcxY1djZ0FIClP/3MyKs8QeSHny9jUNPVHq1XXQLtHUeuJyE2yOn8zC3Jl21C+je5+PvMYEstyaPnbwdXVJmIbVHTDVwzjm+ww1doOLdvZvFHGxtg/2XH6bK6YlmWMDLmDSDadgaUd2FFwojRReuIp+vHEQXpRmUKxzrJWtevt4+aE+ggq41ERwkVzmqt0IJ2qCYfKrxTI2yAD3+IHw8mrd1fDGIfcprZleAJ3yIdmvggBCi/mnGyhoVJkb+n77Urvvr7Z5Qu78SlZoYLVKL0VSBhbK5oOhDlD4ak6O7nYQV9QrGgWiXbdgXP/Mqh2tgSxfDndd5K/GSGiN5yntzTi9FXAPHvDYPbC535d/XVNmplX/rZnFBr7cHozIJA/HFUYA9F5mW4pHe3TuCaJAmCpdsDfAYYcFC6kKJUJWpU5N2ks0ZUFFR2uMV4EZgOqmwtrNPdcRcWGhVi1Bc3Q72pJKVkAdZDDchy/7x+hMIdJTaltW/0ghexpwWPUFeI7+Pdtj2dwLiCoXY1oQxLmGX5S5BmOCbJ7nEqRXUcZUdd198V/IGqSllzeUDPwkuXX0NwgWwMFODzz2nUYPJ4jWApKlqVvR2om3kdrGw+e
 H7HpDHpO
 cmDvSKT41ZuDCIk6kFM6xRSbNTrPL3LHZ8q/vw4RcFuXKo0iN3cwzGD1GJfUcdetUC9+6167TZLoffT6Lo0KhbxXl0Kc51+uCKbo2XwGd4o5bqqBsOZkLuFyxGekFYvHWLORIUq9AdHPmEH9TzNSKj07e6Dfs0jRyLUYl86zIpPOpFZmYAWsrXr20GJbfU3nEb6sqzsEayksu7yImFgGUaCirDcQhkYc1Emo0XxMGq1cvcQZF3+8ntqHq3QTg3wEGLNsklqpZiTj01mA0cU64kmy4Ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 07:09:10PM +0100, Lorenzo Stoakes (ARM) wrote:

> Overall I am not confident you understand this so as per above I think

Trailing sentence... tired :) delete 'so as per...'

>
> > >
> > > Suggested-by: David Hildenbrand <david@kernel.org>
>
> Should be a S-o-b and David should handle this.

Oops left this in by mistake (tired, late in UK :) this was when I was hoping I
could get David to handle it :P

Cheers, Lorenzo

