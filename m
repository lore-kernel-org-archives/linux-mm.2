Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E24F5108B8EC
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 10:24:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 463136B0005; Fri, 20 Mar 2026 06:24:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43AB06B0088; Fri, 20 Mar 2026 06:24:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377C46B0089; Fri, 20 Mar 2026 06:24:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 299946B0005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 06:24:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E700052F4E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:24:14 +0000 (UTC)
X-FDA: 84566056428.19.4A4DE14
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 585B1100005
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:24:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L9ltC+2P;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774002253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oBBrP+dJlC8xCC1p9KU1pC4ESzqrQhTEbPEnQfQ8Eyw=;
	b=CpEEQufkkqAjcmSEItyvxgGNoHFcL5icSi6Yxym3pq+XZIlrKLCAshieGX4ZLQbzWJeSro
	NY+O7Rs/scW2YGdb0sBz2vK7gPvz2SPTmAUVEFUSaIWnk/lnzb0GffwKc1d/WDb2/2GrN1
	kQBriuLwsg32hWexOeqfsW9B2srbx/I=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L9ltC+2P;
	spf=pass (imf14.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774002253; a=rsa-sha256;
	cv=none;
	b=YeLKWo5hs0hsjA9BdBbYF4qv5BFKIVyxw+XJ0MdQtOCpfPnPc/sN9tZIirFwmvDgLZPpza
	t2W2/4NJGul4H02Qm59sacAccwn1slzJaR17OObzztarzvnzSJKntyihyMJ0wqt1HvgpY6
	+gKiS45jpzCGVhOffn5D9mPpDKnZ2tI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B837660126;
	Fri, 20 Mar 2026 10:24:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDF9C4CEF7;
	Fri, 20 Mar 2026 10:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774002252;
	bh=Wn5jstUr6dOBAVU09O9JpAI9Bd4XixCEsjnU1Cfj78w=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=L9ltC+2PmAsjD6RD3FhjaLQ88mtFPqKCZ5e5wnXlbMD0IE9ci1RMSYc2iX7AMzX2x
	 FjYVkT+gjdl/yDn4ixlebZZ+2qW2aDJguNj3A/VBCQP9agUS4lHl8yk0KWw9VvMIXO
	 J7vr5Wg3QsfH7xzwVn0AgUtwCcaD/g2GsqkxKns3rKpMmSp2LxSdLI2Z4E9rk+133W
	 JG7fXKrDdeY4Z1Ksm/FRtx1S1+r14I/wUqQVqO6Ge7JvNdImtPHqNsEPwMm2rZUfJv
	 uOkHS/OYVXSHVS3P/53PHq+FigYnABJvBNjGBfIb924tCSOAW91pKd6lCAKkX/1ygE
	 hJ3HQ35zk27RA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kho: drop restriction on maximum page order
In-Reply-To: <abk1L_gpK7Ys4TK5@kernel.org> (Mike Rapoport's message of "Tue,
	17 Mar 2026 13:04:15 +0200")
References: <20260309123410.382308-1-pratyush@kernel.org>
	<20260309123410.382308-2-pratyush@kernel.org>
	<aa_zglmh3AU2_RA0@kernel.org> <2vxzo6kmddl8.fsf@kernel.org>
	<abk1L_gpK7Ys4TK5@kernel.org>
Date: Fri, 20 Mar 2026 10:24:08 +0000
Message-ID: <2vxzy0jmajef.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 585B1100005
X-Stat-Signature: qzn7tyc3hbgkx5uo85bippyxrmu168q6
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774002253-747331
X-HE-Meta: U2FsdGVkX1/poX7ZWmZwamii2M/ipsIled6J5964qHG2yNaMiMSj8eNu3vZHx+Dqpexn3kwaf+i3mD6isVHLZkb+CRdi0G6eQ2P9L6iEeOXwUbtx43xeAP2qu533sanhVAnJEsr+kePAi29bkxzc6TnR4/95dVWeW7oxriFJ93t5Ico9D9qz2mi7kRdXb5eCmC1yZf/8Un5I6gdEjpPmAF4egpCKQ6xIf/ADOWEuybbWhXGwRGJvw7BMiDF+K8JlOERBaToxwd6wp8mefZpWVZ8XhiB73+mOgHsti939ClFb+wsX3XDKp57g/gPGQjSzwGZ4feLoD7ZJ3meV1+cafrH+oHB6/NxMETgcjOWFOWr2wAsCNHhkKb/zx7lDro+r9opVuugdis7Nj8IUCoWocmS3smsaCIj9xNsmeiO/uhmlrAfQ07tLicLKs9zfkcbnVPPkr1Qeu3+64LC33POdnvKiuY8rkkf946dBbMk5sKgnZ/X+CoiINNnZx2vMAn+/30VmTGmZ24iharFy/YGxQl0nxmSnUZKFj31nGPffh5is7WsL14J1p4PwDuR5e/DbosPx+0ksz9NZPuNsEU8u0AaXktAMkbJSN+LMeM5InLKD45Kw4Ugr3AmxpMMEu+OQBzNvRXm9i/K0X+AO/s8VwTNWJa8E0Kx80+vBmWDvNwKwVHpXejLrNzCVz3h1yKxOTVNqIgQsmkaz9Sdm4un6oU03c2ryBNcXAkmbKN3BQ4NI1jvcwD4MsF4kD0RE9sNKq6tUB0SjSGGWcdDwfjZnFyLW8YQDlXaMIp0hILL2uxI6s3g39o8NgDZ1VIWq4or4ibw5PtWP2WnUY3OoVJHPjbs3+uD1HkLHHvHn/luPsVJvYEwXnBMbpCzKiKVVD4uObbfEMSjdf0bIIVM2Olz65kQqj1gZjE4OSJIvloEmVHNluC3tnO0ilgt9tO7QmT67MtjvTZt691j1BPPSleR
 kQ6xgfho
 jVgT21MYBNI9/TohcpOz0hEgOg8bT9vcm9BdBBP7bh5kkPurw0H43jIYWcKKKp6F2JEJNaDxfQk/AYCm5DpGANCoKt9E7+flNPYC9vxcvHE8uEN1xLYr14fF4tcFB8ZR4H8yLQAch3WnOhY6gV8sPlhMYiY58OmpulNLBmiila72uAAOC00aLhG/gxQq2J1FOlG7BoJ/1iUAlNc9ShtMx2saJbMu0nKnvGlxV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17 2026, Mike Rapoport wrote:

> On Tue, Mar 17, 2026 at 09:12:19AM +0000, Pratyush Yadav wrote:
>> On Tue, Mar 10 2026, Mike Rapoport wrote:
>> 
>> > On Mon, Mar 09, 2026 at 12:34:07PM +0000, Pratyush Yadav wrote:
>> >> KHO currently restricts the maximum order of a restored page to the
>> >> maximum order supported by the buddy allocator. While this works fine
>> >> for much of the data passed across kexec, it is possible to have pages
>> >> larger than MAX_PAGE_ORDER.
>> >> 
>> >> For one, it is possible to get a larger order when using
>> >> kho_preserve_pages() if the number of pages is large enough, since it
>> >> tries to combine multiple aligned 0-order preservations into one higher
>> >> order preservation.
>> >> 
>> >> For another, upcoming support for hugepages can have gigantic hugepages
>> >> being preserved over KHO.
>> >> 
>> >> There is no real reason for this limit. The KHO preservation machinery
>> >> can handle any page order. Remove this artificial restriction on max
>> >> page order.
>> >> 
>> >> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
>> >> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>> >
>> > One SOB should be enough ;-)
>> 
>> Hmm, I figured the unemployed me (who originally wrote the patch) and
>> the employed-by-google me (who is doing this new version) would count as
>> two separate entities and there should be a S-o-b for both.
>
> Maybe than something like:
>
> Signed-off-by: Pratyush Yadav (Hobbyist) <pratyush@kernel.org>
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
>  
> ;-)
>
Yeah, that works too :-)

I'll use that when I redo some of the HugeTLB patches too

-- 
Regards,
Pratyush Yadav

