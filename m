Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13FCCCF34DE
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 16:02:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70C0E6B0062; Wed, 19 Nov 2025 11:02:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB9E6B007B; Wed, 19 Nov 2025 11:02:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2986B00C0; Wed, 19 Nov 2025 11:02:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 454DA6B0062
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 11:02:55 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DF34812F724
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:02:54 +0000 (UTC)
X-FDA: 84127825068.29.5B44E85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 528E6120019
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 16:02:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=f5tBSw7z;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763568173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+6uecwSwGFFbXl1qPuexBXFyChv3MWiyVof996dOVmk=;
	b=SV58HbU4fONPH3b2hA3bQvEMdX+YLNMqEUg4VeRsf/6FE7VT6ucoWg0i/2KSAC5qUrI3HN
	eUWFsS1X6VYIzwrtLvCBQNBrK2cNa66Xg08ayZjFuO4MfZEJgj80TXd1XOA30N+V86ctBD
	cNf7nQrhFy/JgwCO/Eyqpd4ySaKHlxU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=f5tBSw7z;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763568173; a=rsa-sha256;
	cv=none;
	b=gjXUIQ9iBlWWLUFTJ2jLWlHmWybxCez6uecPU0Pk/yqTd/D9Z8tZWKVnErcG8qx7UXcC2K
	fysAk6rmEQfaJC25sAvAvamWLd4AulevKEE8/fjiqOcNTGjSL6Iwym9TgsFk8xXfJLd9gB
	0UcA02SIkr63iRzCYXb9KSyuku/lums=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACDFA60172;
	Wed, 19 Nov 2025 16:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02CB8C116B1;
	Wed, 19 Nov 2025 16:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763568172;
	bh=FFzMom7BsypiO6WAJXDo5CLw9r6cCiHmGONxZukFeVQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f5tBSw7zSc8oLVvRFqNW6gJ49iCAgkMwgQSn9wBOIQm8ouy5frc7i8HoGMS2NW9mJ
	 eJ7Ui70VVxCypKXXXDnUsbIaa0RAGBBCo65wD50kopyTmEL5NrBhMV+da7pWwIwZIw
	 Jb1Z4RXCInwdmtw4sUYT01n8lP7aecoY/jcBashc=
Date: Wed, 19 Nov 2025 17:02:49 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: add test_kho to KHO's entry
Message-ID: <2025111944-bullpen-slinging-dcdc@gregkh>
References: <20251118182416.70660-1-pratyush@kernel.org>
 <2025111944-tracing-unwieldy-1769@gregkh>
 <mafs0wm3m2f1h.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0wm3m2f1h.fsf@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 528E6120019
X-Stat-Signature: ucy14mqoacxk1hdnbkku7n3rq1y6fsr3
X-Rspam-User: 
X-HE-Tag: 1763568173-403426
X-HE-Meta: U2FsdGVkX19C1ZFOm/A8flJsLswmuRKXtMpa4r1hImU07sSA6VhPe+5citNrOcqN5i7+8tqnTUVvcztDsjzKJK2d/cSnTYoUnicC6oVRsPhdA6zMj5emuDc1JKvORuEiIXhbG+Bq9t80y1MX2pISNFRd0ZSZx6iB8DvT3SsiIEQglmJg7O29CeHd3LXmmA3fNWaULZ/uZP9EZwF3892j32qLu6KtRdHtFD38+OVwp1HQcD59NMRglDPjdnMu9LBWSqUFeCpMp7fXOnS+WyOHW6cSvc0XG6jywduMQWre7DYnSl/HvouxUuEANCqiy77SdbxWHbqv4cs73ydE6HQBHMWaZL5A/HGjcHfcycMgnsQSzx+wqnFkIhX5oVsXM2dHect9TFHPnJSoYXkDAH9WkCsFPfX5FmV4+YCAAD1DwKflLFO5NO67KKA97RYjhQPw/bQS05avJQ1RvIhgyOM1aaOX/PlBAS1OREMedB6ZOuD3EIw/HwcQfadhROuDtbi4irxkd1ED2yh+S15sme5hwXqA/PaavyAujFNSxIC/3+PIxRLsWIxc2NqZiqwO562gIvgAHE9qARvFtb0keN/WiglBHHnBrI+8/ByMzFuHd2muhax7dajJlEEn7I/X4wPAIZXSpySJD4RcEj3UnhCU+AfwsBk/FafMsKssVK28zQnpi/0o3AsN64KXrmK05VVZvsnjp4nDPYP+8sMKqB0PaoEnhsJ2HBLHqPZTnrRj1dgKEyvGE8sEwQt+K/2X6+1tg2hOLeqrhOMZRGN+nP+9L6Q/W7KjtLFAQsN7XFjv3eyHIFNxQYYaXC1MTI5yVWDTAyDjdvHvchI8ArBntN4rWYJfsscg9SKX04j83U6b7exCM1/1M7Z1H/53l9tLCEWYz8nWC0HocJB2m4zfBAzoNv2iWndU3aBzTZUCSWZTtmc/Sq32qEcwtx1TWBPCTwww34Oj1xBdP6cGD2ymali
 zxP3/vV2
 svaUzkRJPNFM5YgfUiaXqnTVfzz+N3HtVObu0wOKAaHmo80vdVvzNg6kXW7OWwlCcXgN3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Nov 19, 2025 at 04:55:06PM +0100, Pratyush Yadav wrote:
> On Wed, Nov 19 2025, Greg KH wrote:
> 
> > On Tue, Nov 18, 2025 at 07:24:15PM +0100, Pratyush Yadav wrote:
> >> Commit b753522bed0b7 ("kho: add test for kexec handover") introduced the
> >> KHO test but missed adding it to KHO's MAINTAINERS entry. Add it so the
> >> KHO maintainers can get patches for its test.
> >> 
> >> Cc: stable@vger.kernel.org
> >
> > Why is this a patch for stable trees?
> 
> If someone finds a problem with this test in a stable kernel, they will
> know who to contact.

Contacting developers/maintainers should always be done on the latest
kernel release, not on older stable kernels as fixes need to ALWAYS be
done on Linus's tree first.

Please don't force us to attempt to keep MAINTAINERS changes in sync in
stable kernel trees, that way lies madness and even more patches that
you would be forcing me to handle :)

thanks,

greg k-h

