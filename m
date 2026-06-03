Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4937CD6E57
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 18:12:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0223A6B00A6; Wed,  3 Jun 2026 14:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3B836B00B3; Wed,  3 Jun 2026 14:12:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78356B00B5; Wed,  3 Jun 2026 14:12:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D56DD6B00A6
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 14:12:05 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 800A0162E63
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:12:05 +0000 (UTC)
X-FDA: 84839395410.24.A895579
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E1465A0011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:12:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B27+dQYG;
	spf=pass (imf15.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780510323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRkJ7uiiD7zKB9qnDeo6XCLMAk07QjESwe3HgS4riFA=;
	b=8qQfJL7nsiygVmN9aH6QG9a3XQrx+mFS5HzEdFGAwNyxMFdU0bavUo9JWqgQ9E6Kl45wtg
	5GVXO90/d50fALtBc1JsmpUYJZvy8zMaB1jOwFil1YXzI/5UjoI+r//keYVmWK8xBu3C+n
	dkzAxNquk5ZW6NPlGFSRpVgyru+471Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780510323;
	b=qtQ19vn2VsmatfYJcKLmo3aH4hH4foMtNc+G7SSknq7rbEZqEbFgjoI07BBVmp9ATArX77
	MmPF+7DKsub85hx6S2j6dOaBsO8gTW6iSbcgcSCNyAe+vHsN5QbPM05/bSqU9MLk9wP0D2
	HAyoGj5HGb2KwmCfI0V53kQuvw8mPJA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B27+dQYG;
	spf=pass (imf15.hostedemail.com: domain of kuba@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 50A4D6008A;
	Wed,  3 Jun 2026 18:12:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3666A1F00893;
	Wed,  3 Jun 2026 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780510323;
	bh=QRkJ7uiiD7zKB9qnDeo6XCLMAk07QjESwe3HgS4riFA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=B27+dQYG4LhyQcTqGA591Kk0r+cQwyIZLXxmrccFJ2B9HzR7TNwYvuHIGqmq3s2H1
	 EmB5sy0V/0O0vJpdyC/No8VJQ4GC10uNe5ogoLYFfGmKmOhrPnqCWjIscZuxzv+y5K
	 U4mQD3HD2lJA8Oos00E9ZuiH3YIac/rbWjQQPb9IVi+mFl0Jjf3pMvGDxjQ0reUqtr
	 pxI9FIArphTePWwWLL3O/CTNFj7F1W70JLdvvfUVeq83Zyus2t0XgSajDuoDDALGPn
	 HR99k4B70qSrT+ZnxSbXlaR/Jr+0L4duz/in0PoUwZ+22M5k6K5gpWKCf2//rZYvvF
	 kFZGH08MfCfig==
Date: Wed, 3 Jun 2026 11:12:01 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Askar Safin
 <safinaskar@gmail.com>, akpm@linux-foundation.org, axboe@kernel.dk,
 brauner@kernel.org, david@kernel.org, dhowells@redhat.com,
 hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
 willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260603111201.6c723264@kernel.org>
In-Reply-To: <CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
References: <CAHk-=wiAqf0PdZ4AKj_4riUnnEb=g_ZNPkLnXrByA9BBHYiFRg@mail.gmail.com>
	<20260602225426.122258-1-safinaskar@gmail.com>
	<CAHk-=wgKy4dP0oQCNKyMQQf3-uVpaigmDyH6_T0Via76gWST9g@mail.gmail.com>
	<CALCETrWx8-Q5-rK1KnAPCxCbXaWCd=Yfs_Pr8qVMa8k8L6of1w@mail.gmail.com>
	<CAHk-=wizkDXRut5xLXRF-CVUVYMaZ5AOexxeghOAoXPb4yAvQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E1465A0011
X-Stat-Signature: r8bw7nr9adjf6qgqsx5ddfyztaq1z9ut
X-HE-Tag: 1780510323-275642
X-HE-Meta: U2FsdGVkX18O3nn2v08/BDKyftRt+4p2Uey8UFBr9La0awNCingnkQomAKKvFSNzY5F9FlDVBteI0XAljMlK7eDNSwZ1jvejNhruNcPBpxm2OsPlBrl8aZP6Jl5k9e2QRv09lHy5YT8mn41KxXebGHTTFlPvwRFkiMAqNxcwfoU9pSzf+EZZtFWOWlkl7bXlkfaO9DSDdBSV6oKbt8li5ojv8YAfLyjrs0Y87d5Gnpf9lNDEUmcgjke/gAPttK8IHJmZlxqmqWWs5btREWg80ulSqhKOiEJkGj2LyLItGBbu29mYDjYHUiu4wDLL6z6/EHR7kJ53bBvuln5dC4MzEzyz1zk8wkjL8glCw2lAS2SA2OXueF/wH5J+rwOm6LX7vumx2RwyGUeA50hBN0/5hmMj4mBEfsujpGeeFzZ426ByeTmcskN4OJmIGthvrUEKIWCnTXbGYn0vWIO36H5jkoTQkemGPLJH6i8fLq5PAN5Or4MO1Sc+hV+qWL+kYtXosW4mFfwW0LdSInzlin6m3p25ElmbSqojL8B3kKeazgwfBJqL5jWs/R6GA6W3W5JdlDIeQBR5Duj7x1RYn/KUavJxL8QJ2E8K3Cw6+CKEcrVXnxDasAf5hnRiVvI6k0Hl/HbdHhB5L3btouuSZPNBldnXIkTtVippN/z7cwOyQgeFjq7gVwlDTDDk2FQEDVlN/4oD/0/1AyI3gSdrPAocYWXoHRSbt3IgIeqWnTODSSr18IfbMqEDY51KpYD90zIRZU2DXck2RRvB2FQOQqg0yPcmt5r1X7sx3Jwg4iO+lY8JILsMKfF+unRTcGAqoKQTN99WFTrR59FLXWfYOl1aYkJT5j3w659WppPXkltFQKyyXIXejlPE7sbMWqjEYmDgiFBJdCERIc7ZKHc+kzwc8SMY/8hJntx3uhUP5zec5BeO09iYlSt2iU93ZZZyu+ZsMePl/DnL/FDwsB7UfWr
 fiuryiD3
 9m/NrsJuKQ3JPjqVGjkFCkqcfwGc4gNut67jhp0cuXiIZQJBbChXHbwlMV+YlZ18/Ce8vfqdM+5F59IQfVgZKZ6zYlE7Ys67F58TCqfnF+SEth1GowTiPnYZ17svvSHvEW+NcTGhjqwzDnHVo0zx/G9fYfNATHDlIVl5CF3m40wolqc0WYMk9X0rjTsOqRPpuUKG/MYLenytymztEI2IIy32AsqJZXSc+x2U8RJnQhyOtPKOQiv0EKl77ja2rzvOsW7+0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Jun 2026 21:20:13 -0700 Linus Torvalds wrote:
> They were all in the networking and crypto code that just didn't deal
> with shared data correctly.
> 
> So in that sense, it's a bit sad to discuss castrating splice.

+1 IMVHO the networking bugs where people just not knowing what they
were doing. Presumably AI has scrounged all the occurrences of that
bug by now. I'd also hate to render splice optimizations moot based
on those bugs.

