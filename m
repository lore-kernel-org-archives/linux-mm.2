Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC87C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F2FD56B00D8; Mon,  3 Aug 2026 09:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F078A6B00D9; Mon,  3 Aug 2026 09:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D946B00DA; Mon,  3 Aug 2026 09:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B3B116B00D8
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:54:19 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8AB51606B5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:28:26 +0000 (UTC)
X-FDA: 85059735012.14.E87844F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 38773180004
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 11:28:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOHKYs3a;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785756505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZaCVwMXNLzr4rttTuYs+5Z/9LNgxH6VHMXVNEb+GRw=;
	b=GJZ8g9LKSQbUcQBE7ZjjMmuOjSwSlCo69V0vO3w3Ors7wJbX1PLh02v/15I3X6YIUbbRzp
	yKt8Jg73r1k8Dai6nXdXvPb4ZrcWmOf177tsKJ1gdnfCSmeul+SAkNQZh2CPwVZu8DH6cG
	nKiaNoGpBUArMRen+qsPyYLhc5NEa88=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HOHKYs3a;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785756505;
	b=dBJ9SRA6SHZRQpx9Z6C5CB0wKmVt8JWYVFkAxHGHkHg5Vpogb3QyBlQXcXlTBwrDFpD7OF
	cEHDz+IdKnou5IM6LDTMBiqtrA2VF4wvwhn2QFnlmeLC9hmrl8zCNifwhNEVmFObOgpnyl
	62qd5hZFtB2Y4yELfhUDUtHyO+5YwRM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9B3E360A82;
	Mon,  3 Aug 2026 11:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 656011F000E9;
	Mon,  3 Aug 2026 11:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785756504;
	bh=kZaCVwMXNLzr4rttTuYs+5Z/9LNgxH6VHMXVNEb+GRw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=HOHKYs3abxK0pyHeRQpo/WcMDEbgeAxihfb06G2dsMdy5m7ntVCJmQ+hV2LXvuzBL
	 LHJ0YUsfQ33bTGBj6HyC6pYmMBtctoq97dzFUzY7Flq5LuE/NEO4KFe4dpC1C6GPuJ
	 n/WTWAHwDii0Er7bEQdzUFnlFIcU+tK2MOoqU9k0vCZ99QGAhuQ2m6SCYgVKhBOlkC
	 /bs/oKdm9w/d17kbOyLmwhK8p5TWRkG3DIIgSIu/Sgtsjp0W4s9KeRIy5C3T3a3ogZ
	 mei4p6nvJ8fl29Wn+X6gqswrOIZlEncOkD4AMPEDx55Hsqdfr1JB4A5TG9o7Crr2Zv
	 xgA478z3hkFVA==
Date: Mon, 3 Aug 2026 14:28:17 +0300
From: Mike Rapoport <rppt@kernel.org>
To: =?utf-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Evangelos Petrongonas <epetron@amazon.de>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
Message-ID: <anB7UXU0DduiJ-Lw@kernel.org>
References: <20260717134028.2880508-1-mclapinski@google.com>
 <178453346331.1178000.18393988680596713513.b4-ty@b4>
 <CAAi7L5dE=oROWR0mTknPyjnL-XRXuCUsfHSiGh7yUqWCSzE5PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAi7L5dE=oROWR0mTknPyjnL-XRXuCUsfHSiGh7yUqWCSzE5PQ@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 38773180004
X-Stat-Signature: 4t9iuohz1w64qxiiuje7tehsanhw97w4
X-HE-Tag: 1785756505-655373
X-HE-Meta: U2FsdGVkX19K5n6qONKvpTe0H8nKdAwG+T20ptPJqyblSgfSF0Yp1+ATAhBW5/ehJVI/EXBD0kmpoWhpm5YXqooIMcvR/RpI1Xc4ke9R0zAIMcEsFWpEt4pJVYp4comkwsNkIDEcObMmiyG6coMUssM76D5LY2JSWVuysGw3bwLb9MsOw9PkJw0aOM50w+UON8mpKiPFJcnqpJyHAbgrHeeHrEA025/bzOybG3P/uSPxS7bvhl1aluYqtOdGqd9JvH0qksJ/wcY1iy9dpKxXcjWNSm5ZBm5HfnP/iUp2zLe4QmffbWLOuI++g+AI2DtarPiC6dKbBbOdegzURfkuhAPeA4Fd/LfDEzx8zThPErs3J1RIVRAg2EknD8HikmxTIX9RBHH6irjM8wjgERnSiBDLIRQZL3Fq2fnYuiRZIVqrzkkwnY+MH0ezRzfoUU9RuenvWWQVbLxbpIesFwClj7EogzBT7lv2gys9O2FqeTOYECifHe15cHdlQb/XHc66E0EpZLghIpMlkgV/yz2Ezhw/SAmSap1err6CB0lhG5FWgQ2acq7RWEKQ8xcyk2ml9apgv4mCMnSpq7y5+szdeU4BzIEaZChIilHUdKfegOMznXIXyljCWlna+hmBBq9A7kTwX+BmFkb8XgBmpBAQbdyObqQQSL33OgVLJEiFA3A8mdnOoRSweFn6GY4rktFEt3WQn/shkSzZM85jqDG69V2mRMF1yEtn47ItRG/5Jn4eThHz4tJB9lJvVpkKcP9vhrGWbWK7DlES+HWihWDLQ38dF3twZ8Y6GPkPt1C33MJvdRn5OXmcG4rU9Z5IPNJcP7F6Z21uk3YnJLZUJr5K58oAwdEV3n/4mjzAMDZNgBkXp1GoWGKCiaY3uSntbipHUGc4nxLKsPfGPk+V+OSQQIEs1LWDJ1oFSKm78dgk9eEEIt35rvVd5uQuwuFel/F/t9D7oHgf3HjHH211kLV
 PR8GUjVT
 UhVuKT2fLcholQHEndcuHmOa7OPwyLC0shxlpss9XPNqvDZT08ZTTydEOIUQEFrhZy0aP16c3zaJzketEQt29HvdFyi95V6T/c0xpo+Nwt9SurLVXQaEAKHXax/PkjIb/WYGhOFBr+1/jHP/JtkMO1YxFrqxgkFr04Yws/lmDfoHhewfgaQKdwjCDE/yIEoj5O/gGdAHN6iqt6EOO1isFd4sYT3MRkBH/YHLzhxjj3X9oi9IacasVFzKrWsygprEN8pTQvYew6DH+BTKD3BIlyhA7aDUdrhnNiwfsaK3117jpFzmY+NCOHqrTjsBQIFE1IK7JpNSdWHQRGcXI94OBtfXEh0+pEayN6gzj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 12:14:18PM +0200, Michał Cłapiński wrote:
> On Mon, Jul 20, 2026 at 9:45 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Fri, 17 Jul 2026 15:40:28 +0200, Michal Clapinski wrote:
> > > kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
> >
> > Applied to fixes branch of liveupdate/linux.git tree, thanks!
> >
> > [1/1] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
> >       commit: c553c774c9715e1c92c48b342f30d60601693fb4
> >
> > tree: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux
> > branch: fixes
> 
> Hey,
> I see that this change (merged 2 weeks ago) didn't make it into linux
> rc6.

I had a really busy week last week, sorry for the delay.
 
> Do we need to do something manually to get it into the nearest
> release?

I already did :)

https://lore.kernel.org/all/20260803112452.1793120-1-rppt@kernel.org/

> Thanks.

-- 
Sincerely yours,
Mike.

